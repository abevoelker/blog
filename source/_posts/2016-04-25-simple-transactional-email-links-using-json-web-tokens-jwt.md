---
layout: post
title: "Simple transactional email links using JSON Web Tokens (JWT)"
date: 2016-04-25 12:00:00 -0500
comments: true
categories:
published: true
facebook:
  image: jwt.jpg
---

[{% img center /images/jwt-wide.jpg "JWT logo" %}](https://jwt.io/)

Recently I ran into an issue with a Rails web application where I wanted to add
one-click unsubscribe links to transactional emails I send out. This website
tracks the inventory of retail product websites; users subscribe to individual
products and get notified via email when the price or stock status changes so
that they can quickly make purchasing decisions based on the information.

Up until now, I've sent out these emails with a message in the footer
stating "If you no longer wish to receive these notifications, visit the
product page and un-watch the item." I had linked to the product page in this
message, but it was still unsatisfying to me to require users to sign in to
their account to make changes. I think it could lead to a lot of frustrated
users, because speaking for myself, when I get sick of an email notification
and finally decide to unsubscribe, I want it done NOW with near-zero hassle.

If users can't easily unsubscribe, they'll be more likely to mash that spam
button in their email client, marking the message as spam to their provider and
creating a [hard bounce][hard-bounce] on further emails sent to them, which in
turn will give you headaches with your email service and possibly affect
deliverability rates to all your other users (very not good!). So when sending
emails, I try to keep my recipients as happy as possible.

So a better solution in terms of UX would be if users could simply **click a
link in the email footer that would immediately unsubscribe them** from further
notifications. But how to implement that?

<!-- more -->

## Existing Rails models / database schema

The existing Rails models follow a simple join table style and look something like this:

```ruby
# app/models/user.rb
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      not null
#  ...
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ActiveRecord::Base
  has_many :subscriptions
  # ...
end
```

```ruby
# app/models/product.rb
# == Schema Information
#
# Table name: products
#
#  id              :integer        not null, primary key
#  ...
#
class Product < ActiveRecord::Base
  has_many :subscriptions
  # ...
end
```

```ruby
# app/models/subscription.rb
# == Schema Information
#
# Table name: subscriptions
#
#  id         :integer     not null, primary key
#  product_id :integer     not null
#  user_id    :integer     not null
#
# Indexes
#
#  index_subscriptions_on_product_id              (product_id)
#  index_subscriptions_on_user_id                 (user_id)
#  index_subscriptions_on_user_id_and_product_id  (user_id,product_id) UNIQUE
#

class Subscription < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  # ...
end
```

As you can see, very simple.

## First idea: add unsubscribe UUID column to subscriptions table

My first thought was to simply add an *unsubscribe_uuid* column to the subscriptions
table. This would act as a sort of secret key that allows anyone who has it to
be able to perform an *unsubscribe action* on just that subscription (the
*unsubscribe action* in actuality being simply deleting the given
*subscriptions* record from the database).

I would also create a new Rails route and controller to handle a new URL with
this *unsubscribe_uuid* parameter to be sent out with the emails.

Here's a migration that would add this column and an index to the database:

```ruby
class AddUnsubscribeUuidToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :unsubscribe_uuid, :uuid, default: 'uuid_generate_v4()'
    change_column_null :subscriptions, :unsubscribe_uuid, false
    add_index :subscriptions, :unsubscribe_uuid, unique: true
  end
end
```

However, I quickly started to realize this solution will not be ideal. The initial
problem is caused by my actually deleting the *subscriptions* record: once the
unsubscribe is complete and the web page displays a "success" message, the URL will
now 404 due to the *subscriptions* record (and thus, the *unsubscribe_uuid*) no
longer existing. Hitting reload on the page or re-opening old email links will
now no longer work. I would prefer for the unsubscribe action to be replayable and
idempotent, although perhaps with an expiration time for some security. Also, I
have a stretch goal in that I would like to put a one-click "undo" button
alongside the "success" message, which makes it simple to re-subscribe to the
product if the unsubscribe was accidental - can't do that if the authorization
info for the existing subscription is gone.

Now, I could solve this problem by adding the *[paranoia][]* gem and performing
*soft deletes* on the *subscriptions* table rather than truly deleting records.
However, I tend to prefer to truly delete records, and also set up foreign keys
so that the database also deletes dependent records (I embrace the database
enforcing referential integrity). I also tend to write real database triggers and
constraints rather than fully relying on Rails validations, again leaning on the
database to enforce referential integrity whenever possible. I've seen enough
surprising or buggy behavior in complex ActiveRecord callbacks and Rails's
transaction handling to warrant that.

Anyway, even if I changed to soft deletes, I'd also have to
adjust the way I do insertions to this table to always look for an existing soft
deleted record first, and re-activate it if it exists. Alternatively, I could
always insert a new record, but I'd have to change my
*index_subscriptions_on_user_id_and_product_id* index due
to it being unique for `(user_id,product_id)` pairs - multiple subscriptions for
the same user-product pair could not coexist given the existing
definition. One way to fix the index in Postgres would be by using a
[partial index][partial-index]:

```
CREATE UNIQUE INDEX index_subscriptions_on_user_id_and_product_id ON subscriptions (user_id,product_id)
    WHERE deleted_at IS NULL;
```

However, I feel like either solution is starting to get quite messy. It would
get even more messy if I started to add new types of email actions besides
unsubscribe.

## Second idea: create a new model/table to store unsubscribe links

Drawing on the age-old wisdom on how to solve any Computer Science problem by
adding another layer of indirection, I briefly thought moving the unsubscribe
link to its own table/model might make things easier. These records and their
associated UUIDs would never be deleted; rather, when a new *subscription*
record is created, an ActiveRecord callback or a database trigger would fire to
ensure this associated record exists.

This didn't get any further than a brief thought in my head, because it really
isn't much (any?) better than just having a column on *subscriptions* with a
soft delete mechanism. But it did get me to start thinking about reducing the
dependency on the database, leading me to the idea of possibly hashing some data
that is private to the user and static (e.g. their join date + database PK),
and using that hash as a secret token to authorize unsubscribe links for that
user. That sort of lead me to JWT and my final solution.

## Implemented idea: encode the desired action using JSON Web Tokens (JWT)

The core problem we are trying to solve is how to serialize an allowed action
in a way that an anonymous (not-logged-in) user can present it back to us, while
being sure that it's something that we generated and authorized, and hasn't been
tampered with (e.g., users cannot change the `user_id` or `product_id` of an
unsubscribe target).

For solving these sorts of problems, the database is a tool that a
lot of web developers often reach for first out of habit, like I did. It's
a convenient tool because of our inherent trust in it (only we can write to it -
nobody can create fraudulent UUIDs in the above ideas) and because we can store
an arbitrary amount of our dynamically generated objects there. However, it is
also inflexible in that you now have to
manage the lifetimes of these objects you are creating, which is made harder by
the fact that they're often attached to lifetimes of other objects, causing
annoying issues like I had to think about above with my UUIDs.

The database solutions I had thought out are also not very
expressive or flexible. At the core I have to generate a shared secret
and infer a lot about what that single value means in my code. If I want to
add varying behavior to these tokens I'd have to add additional fields to the
table to configure that, while being extremely careful to not mess up existing
tokens that I've generated.

A better solution to the stated core problem is for the web app to serialize
allowed actions in a more expressive data structure such as JSON, and use some
cryptographic math (a digital signature) to ensure that the data was generated
by us. We can simply hand this data to the client - no need for us to store
anything! - and later when they hand it back to us, we can verify the signature
to make sure we are the entity that generated it and it hasn't been tampered
with.

Luckily someone has already thought all this out and made it friendly for
web-specific use cases!

### JSON Web Tokens (JWT)

[JSON Web Tokens (JWT)][jwt] solve this problem using a simple data format
consisting of three pieces of Base64URL-encoded data concatenated together with
periods:

1. A **JSON header**, mainly used for specifying the algorithm used to sign the
   token.
2. A **JSON payload**, consisting of the private data that you want to sign. You
   can put whatever data you want in here, but there are a short number of
   [reserved names][jwt-reserved-names] that have special meaning to JWT
   processing (e.g. setting a token expiration time using `exp`)
3. The **binary signature** that cryptographically signs the header and payload,
   proving the integrity of the message.

There is a handy debugger on the JWT site's main page that shows a nice
color-coded example token and how the different pieces break out:

[{% img center /images/jwt-debugger.png "JWT debugger" %}](https://jwt.io/)

One nice thing about JWTs, that you can see from the example, is that the tokens
are so short that they can easily fit in URLs (assuming you don't create crazy
large payloads).

It's worth playing around with the debugger and then reading the
[introduction page][jwt-intro] to get better explanations about JWT than I can
provide here.

One important thing to note is that the header and payload **are not
encrypted**; they are only Base64URL-encoded. There are ways to encrypt JWTs -
although that will expand their size - but by default that's not how they are
made.

### Solution code

Here is my coded solution to the problem using the official
[JWT Ruby gem][jwt-ruby]. I have a `ProductSubscriptionToken` class, which makes
it easy to encode a subscription as a JWT as well as decode a JWT back into a
Ruby data structure:

```ruby
# app/models/product_subscription_token.rb
class ProductSubscriptionToken
  def self.encode(subscription, exp_time=(Time.now + 1.year).to_i)
    secret = ENV["PRODUCT_SUBSCRIPTION_TOKEN_SECRET"]
    data = {
      user_id: subscription.user_id,
      product_id: subscription.product_id
    }
    payload = { data: data, exp: exp_time }
    JWT.encode(payload, secret, "HS256")
  end

  def self.decode(token)
    secret = ENV["PRODUCT_SUBSCRIPTION_TOKEN_SECRET"]
    begin
      decoded_token = JWT.decode(token, secret, true, { algorithm: "HS256" })
      product_id = decoded_token[0]["data"]["product_id"]
      user_id = decoded_token[0]["data"]["user_id"]
      subscription = Subscription.find_by(product_id: product_id, user_id: user_id)
      if subscription
        Right({
          subscription: subscription,
          product: subscription.product,
          user: subscription.user
        })
      else
        Right({
          subscription: nil,
          product: Product.find(product_id),
          user: User.find(user_id)
        })
      end
    rescue JWT::DecodeError
      Left("Invalid token")
    rescue JWT::ExpiredSignature
      Left("Expired token")
    end
  end
end
```

I use an environment variable, `PRODUCT_SUBSCRIPTION_TOKEN_SECRET`, to
store the secret I use to sign JWTs. I personally generate secret values using
`SecureRandom.hex(64)`. I don't show it here, but I also use a gem called *[ENVied][]*
which ensures that this environment variable has been provided before starting
the Rails application (if not, it fails fast). I think that's a good practice
to avoid passing `nil` as a secret to your hashing algorithm, which could be
completely unsafe! (Note: I just tested encoding with a `nil` secret and it errored out, saying
`TypeError: no implicit conversion of nil into String`, however encoding with
an empty string secret works fine!)

I use HS256 (HMAC with SHA-256) as the MAC algorithm, because it is a symmettric
algorithm - the key used to both sign and verify the message are the same (I'm
both signing and verifying the message myself, and the key never needs to leave
the server so there are no distribution concerns). If
I had a use case for verification to be done by another party, there are
asymmetric (public key) algorithms JWT supports that can be used instead.

Finally, note that it's just my personal Ruby style, but when decoding I use
`Right()` to wrap successful results and `Left()` to wrap unsuccessful results.
The specific implementation I use is from the *[kleisli][]* gem, however the
names and idea are from typed functional programming. This is just my preferred
way to represent success or failure as values, there's nothing specific to JWT
here.

The next things implemented are the new route and the controller that parses a
JWT parameter into either a set of
successful ActiveRecord objects or a simple error message:

```ruby
# config/routes.rb
get "product_subscriptions/unsubscribe", to: "product_subscriptions#unsubscribe"

# app/controllers/product_subscriptions_controller.rb
class ProductSubscriptionsController < ApplicationController
  def unsubscribe
    ProductSubscriptionToken.decode(token).fmap { |data|
      @subscription = data[:subscription]
      @product = data[:product]
      @user = data[:user]
      @subscription.destroy! if @subscription
    }.or { |error|
      @error = error
    }
  end

  private

  def token
    params.require('token')
  end
end
```

Note that the
block passed to `.fmap` is executed if the given object is a `Right` (success),
otherwise it's ignored. Likewise, the block passed to `.or` is executed if the
given object is a `Left` (failure), otherwise it's ignored. Again this is just
my personal style of handling success or failure values and has nothing to do
with JWT specifically.

The view is pretty simple and self-descriptive:

```haml
-# app/views/product_subscriptions/unsubscribe.html.haml
- if @error
  .alert.alert-danger
    %p
      There was an error processing your request:
      %span= @error
- else
  .alert.alert-success
    %p
      You
      = "(#{@user.name})"
      have successfully unsubscribed from price and stock status changes for
      = link_to @product.title, product_path(@product)
```

Since we have full access to the
user and product, it would be easy to some day add an "undo" single-button form
to this page, allowing the user to easily re-subscribe if they had clicked the
unsubscribe link by mistake.

## Conclusion

This is my first time using JWTs. I don't see myself reaching for them
often for the types of web apps I build, but in these kinds of scenarios they
seem like a great fit.

Let me know what you think! Is there a simpler option I'm missing? Have you used
JWTs before, and if so what was your use case? Was it a good or bad experience -
any problems you encountered?

## References

* [Stateless tokens with JWT](http://jonatan.nilsson.is/stateless-tokens-with-jwt/#examples)

[jwt]: https://jwt.io/
[jwt-intro]: https://jwt.io/introduction/
[jwt-ruby]: https://github.com/jwt/ruby-jwt
[jwt-reserved-names]: http://self-issued.info/docs/draft-ietf-oauth-json-web-token.html#RegisteredClaimName
[hard-bounce]: http://kb.mailchimp.com/delivery/deliverability-research/soft-vs-hard-bounces
[paranoia]: https://github.com/rubysherpas/paranoia
[partial-index]: http://www.postgresql.org/docs/current/static/indexes-partial.html
[kleisli]: https://github.com/txus/kleisli
[ENVied]: https://github.com/eval/envied
