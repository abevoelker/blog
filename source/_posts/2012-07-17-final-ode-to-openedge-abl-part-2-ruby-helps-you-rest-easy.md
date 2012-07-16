---
layout: post
title: "Final Ode to OpenEdge ABL Part 2: Ruby Helps You REST Easy"
date: 2012-07-17 19:00
comments: true
categories: 
published: false
---

In [part 1][1] of this series, we learned how to get Ruby to talk to an OpenEdge
database by using [an adapter][22] for the [DataMapper][2] ORM framework.

In this post, I would like to demonstrate both the power and beauty of Ruby by
rapidly prototyping a RESTful Web service. [REST][18] is a pretty big topic and
if you are unfamiliar with it you should probably invest some effort into
learning about it.  The simplified version is that it is a way to
describe resources and actions involving said resources.  The HTTP protocol
that powers the Web was basically built specifically to implement REST
principles.  Therefore, if your resources can respond properly to all the HTTP
methods than your service is probably pretty RESTful.

In researching this article I tried to find some existing examples of REST
in use in the OpenEdge community to compare to.  All I found were some murmurs
about a [REST adapter][5] that Progress Corp. was supposedly going to provide
for AppServers / WebSpeed as part of OpenEdge 11 which apparently hasn't
materialized, and a "Web 2.0 RIA" [product][3] sold by BravePoint which
doesn't use REST at all but uses some proprietary "[RPC Engine][4]" to
communicate between client (JavaScript) and server (WebSpeed broker).

Knowing that we have no existing prior art in the OpenEdge community to compare
to, let's break new ground and do it ourselves.  We are going to start by
building a barebones REST API for a single resource - customers.  We are going
to support all the basic CRUD actions, which in HTTP terms are POST for create,
GET for read, PUT/PATCH for update, and DELETE for... delete.  For this example
we are going to use [Sinatra][6].

## Setup

I am going to assume that you are following along from [part 1][1] and have
already installed JRuby using rvm (if not, go back and do so).  Let's proceed
by installing a newer version of JRuby and creating a fresh gemset to namespace
our gems for this demo:

    rvm install jruby-1.7.0.preview1
    rvm use --create jruby-1.7.0.preview1@openedge-sinatra

Let's re-use the same git repo from part 1 that has our DataMapper models
defined (if you still have the code just copy it to a new directory):

    git clone git://gist.github.com/3073736.git openedge-sinatra
    cd openedge-sinatra

If this is a fresh clone be sure to change the database parameters on line
4 of `example.rb` to match yours, and potentially change the version of
OpenEdge on line 4 of the `Gemfile` to use a different JDBC driver loading
mechanism.

Next, we are going to install the `sinatra` gem.  Open the `Gemfile` and add
this line at the bottom:

    gem "sinatra", "~> 1.3.2"

Now we are ready to install the gems using bundler by typing

    bundle install

## Sinatra

Sinatra is essentially a very simple [Domain-specific language][8] (DSL) for
specifying how to respond to
HTTP requests.  It isn't a Web server in itself, so it will delegate to
[WEBrick][15] (a Web server that comes built-in to Ruby's stdlib) if you don't
have one.  WEBrick is fine for development, but should never be ran in a
production environment as it is not optimized for that. Obviously we won't be
worrying about that here, but keep it in mind if you continue using Ruby.

Let's create a simple server using Sinatra to respond to the root url (`/`)
with `hello world`.  Create a file called `server.rb` and put this content in
it:

```ruby
require 'sinatra'

get '/' do
  'hello world'
end
```

At this point we can start our Web server by running our Ruby code:

    ruby server.rb

Now browse to [http://localhost:4567][7] in your browser. You should see
the text `hello world` in the body of your browser. If you're an ABL
programmer, I hope you're shocked by how simple that is.

Without waxing poetically too much, I'd like to point out some things about
Ruby here that might look a bit like magic.

First, lines 3-5 probably don't look much like code.  That's because Sinatra
is taking advantage of some features of Ruby to essentially make its own
[DSL][8].  The first is that `get` is just a Ruby method that Sinatra has
defined but moved into the global object scope so that it looks like a
Ruby language keyword.  `get` takes two parameters - the first is a string
that matches a path, in this case the root path `/`, while the second
parameter is a block, which is the part between the `do ... end` (in this
case it's just `'hello world'`.  Blocks can also be passed using curly
braces (`{ }`); standard practice is to use braces for one-line blocks and
`do ... end` for multi-line blocks.

In Ruby, blocks are very important.  They are a [lexical closure][9], or a
chunk of code that is bound to the lexical scope they are defined in (i.e.
they can see variables defined outside of the block).  They are powerful
because they let you pass around a block of code as an object.  The way that
we are using them in our `get` method is to evaluate the first argument -
the route, in this case the `'/'` - and if it matches to execute the code in
the second argument, i.e. the block.

Secondly, you might note that the first argument to the `get` method - `'/'` -
doesn't look much like an argument because it doesn't have parentheses around
it.  That's because in Ruby, parentheses are **optional** (well, as long as its
not ambiguous to the interpreter that you are passing method arguments,
anyway).

Finally, in Ruby the last statement of a method/block is the return value;
you don't need an explicit `return` statement.  You *can* use one, but
it's not idiomatic Ruby and looks ugly; it's typically only used to
short-circuit evaluation near the beginning of a method due to a problem with
some state that should prevent execution from continuing.  Therefore, you can
see that the return value of our `do ... end` block is simply and
unconditionally the string `'hello world'`.

Taking all of the above into consideration, it would also be valid to write our
method as

```ruby
Sinatra::Base.get('/'){ return 'hello world' }
```

However, notice the difference in readability.  Ruby encourages the Sinatra
method of creating mini-DSLs over making everything look like generic, terse
code, for good reason.

## Hooking into our models

Now that we have a running Web server, let's make it do something useful.
Let's load our DataMapper code from part 1 and add a route to display all
customers.  Edit your `server.rb` to look like this:

```ruby
require 'sinatra'
require './example'

get '/customers' do
  Customer.all.to_json
end
```

Restart the server and visit [http://localhost:4567/customers][10] in your
browser, and voilà - you should see a big JSON array that contains every
customer in our database!  If you're using Chrome I recommend the
[JSONView][11] extension for improved readability.

The URI that we just created is referred to as a *collection URI* as it returns
a collection of resources rather than a single element.  Let's go ahead and add
support for individual elements, and implement all the HTTP methods that
correspond to the CRUD actions - GET (read), POST (create), PUT/PATCH (update),
DELETE.


### GET (read)

We already implemented this HTTP type for our collection URI.  The only added
complexity we need for a single element is to accept the primary key of the
element that the user is requesting.  Sinatra makes this very easy by providing
support for this in its route matcher.  Add this to your `sinatra.rb` file:

```ruby
get '/customer/:cust_num' do |cust_num|
  @customer = Customer.get(cust_num)
  if @customer
    @customer.to_json
  else
    not_found 'unknown customer'
  end
end
```

A few more things to note here about Ruby.  First, that similar to methods,
blocks can take parameters (`|cust_num|`). The block value for `cust_num`
will be anything after `/customer/` in the request URL, according to our route
matcher.  If there was another `:param` in our routing string then we could
have our block accept multiple arguments.

Second, note the conditional on line 3; Ruby conditionals evaluate anything
other than `false` and `nil` as true (this is known as "truthy" evaluation).
Therefore, it is very common
to just use the actual object in a conditional rather than adding an explicit
check to see if it is not nil, because an initialized object will have a
non-nil value anyway.  You *can* explicitly check for nil using
`@customer.nil?`, but it is almost always unnecessary and is a definite code
smell.

Finally, note that again we are taking advantage of Ruby's DSL-supporting
features of the return value of a method being the last statement it evaluates
and the lack of parentheses around the call to the `not_found` method.

To test our method, let's use a Unix utility called [curl][14] to fetch just
the first customer (alternatively, you could visit the address in your
browser):

    curl http://localhost:4567/customer/1

You should see this JSON get output on your console:

```json
{"cust_num":1,"name":"Lift Tours","country":"USA","address":"276 North Drive","address2":"","city":"Burlington","state":"MA","postal_code":"01730","contact":"Gloria Shepley","phone":"(617) 450-0086","sales_rep":"HXM","credit_limit":"0.667E5","balance":"0.90364E3","terms":"Net30","discount":35,"comments":"This customer is on credit hold.","fax":"","email_address":""}
```

### POST (create)

Next, let's support creating a new customer using the HTTP POST method.  Add
this code to `server.rb`:

```ruby
post '/customer' do
  next_id = Customer.last.cust_num + 1
  Customer.create(params.merge(:cust_num => next_id))
end
```

This one is pretty easy as DataMapper's `create` method accepts a [hash][12] of
attributes, which is what we're passing in (Sinatra stores our parameters in a
hash called `params`).  The only tricky part is getting the next customer
number to use for insertion, as we don't have a sequence.  Also note that we
are using [`Hash#merge`][17] to override any user-provided value for `cust_num`;
this may actually not be a valid consideration if you want API users to be able
to provide a value for this (personally I don't see why you would need this).

To test this method we can again use curl, specifying the HTTP POST header
with the `-X` option and parameters with `-d`:

    curl -X POST -d "name=foo&country=Mexico" http://localhost:4567/customer

You should see a response with the JSON data of our new customer appear in the
console.  It should look something like this:

```json
{"cust_num":2107,"name":"foo","country":"Mexico","address":null,"address2":null,"city":null,"state":null,"postal_code":null,"contact":null,"phone":null,"sales_rep":null,"credit_limit":null,"balance":null,"terms":null,"discount":null,"comments":null,"fax":null,"email_address":null}
```

### PUT and PATCH (update)

To update an existing customer, we will support the HTTP methods PUT and PATCH.
The difference is that PUT is for completely replacing the entire customer
object, while PATCH is for retaining the existing customer but only replacing
*some* of its attributes (i.e. a merge).  [PATCH][13] is relatively recent,
having only been proposed in 2010.

```ruby
put '/customer/:cust_num' do |cust_num|
  @customer = Customer.get(cust_num)
  if @customer
    @customer.destroy && Customer.create(request.params.merge({'cust_num' => cust_num}))
    @customer.to_json
  else
    not_found 'unknown customer'
  end
end

patch '/customer/:cust_num' do |cust_num|
  @customer = Customer.get(cust_num)
  if @customer
    @customer.attributes = request.params.reject{|k,v| k == 'cust_num'}
    @customer.save
    @customer.to_json
  else
    not_found 'unknown customer'
  end
end
```

There's not a whole lot going on here, besides the `&&` which is just for
chaining method calls together, continuing as long as every call returns true
(you've probably seen it in bash scripts or many other
languages).  Also, we again use [`Hash#merge`][17] in the `put` method to force
`cust_num` to be the value passed in from the URL, and not a value that the
user provides.  For the same reason, we use [`Hash#reject`][16] in the `patch`
method to pull out any user-provided value for `cust_num`.

Let's test PUT with curl:

    curl -X PUT -d "name=bar" http://localhost:4567/customer/2107

You should see a result like this:

```json
{"cust_num":2107,"name":"bar","country":"USA","address":"","address2":"","city":"","state":"","postal_code":"","contact":"","phone":"","sales_rep":"","credit_limit":"0.15E4","balance":"0.0","terms":"Net30","discount":0,"comments":"","fax":"","email_address":""}
```

Notice that the customer's name did change to `bar` as expected, however the
other attributes reverted to new object defaults (note country changed to
`USA`).  This is because we are creating an entirely new object.

Now let's test PATCH:

    curl -X PATCH -d "country=Mexico" http://localhost:4567/customer/2107

You should see output like this:

```json
{"cust_num":2107,"name":"bar","country":"Mexico","address":"","address2":"","city":"","state":"","postal_code":"","contact":"","phone":"","sales_rep":"","credit_limit":"0.15E4","balance":"0.0","terms":"Net30","discount":0,"comments":"","fax":"","email_address":""}
```

Note that country changed to `Mexico` as expected, however the name remained
`bar` because we are modifying the existing object and not creating a new one.

To test our little security feature of disallowing the `cust_num` field to
change, we can try passing it in like this:

    curl -X PATCH -d "cust_num=9999" http://localhost:4567/customer/2107

The output from curl verifies that it works:

```json
{"cust_num":2107,"name":"bar","country":"Mexico","address":"","address2":"","city":"","state":"","postal_code":"","contact":"","phone":"","sales_rep":"","credit_limit":"0.15E4","balance":"0.0","terms":"Net30","discount":0,"comments":"","fax":"","email_address":""}
```

### DELETE

Finally, to delete a customer, we simply define a method like this:

```ruby
delete '/customer/:cust_num' do |cust_num|
  @customer = Customer.get(cust_num)
  if @customer
    @customer.destroy
  else
    not_found 'unknown customer'
  end
end
```

Once again we test with curl, this time adding the `-I` option, which displays
the HTTP headers of the response.  Alternatively, we could change our server
code to return some type of `{status: "success"}` JSON in the response body
but then it would probably make sense to change the rest of our methods too,
so we will take the simple way out and just pay attention to the HTTP response
code:

    curl -IX DELETE http://localhost:4567/customer/2107

You should see a `200 OK` HTTP header on the first line of the response, which
means that the request was successful.  It should look something like this:

    HTTP/1.1 200 OK 
    X-Frame-Options: sameorigin
    X-Xss-Protection: 1; mode=block
    Content-Type: text/html;charset=utf-8
    Content-Length: 0
    Server: WEBrick/1.3.1 (Ruby/1.9.2/2011-12-27)
    Date: Fri, 13 Jul 2012 03:09:01 GMT
    Connection: Keep-Alive

To verify that the customer really is deleted, you can either repeat the same
command we just did (side note: the ability to repeat this action without
fear of causing side-effects is called [idempotence][26]), or just a simple GET
request and you should see a response header of `404 Not Found` with a body of
`unknown customer`.

### Putting it all together

If you've been following along, your `server.rb` should look like this:

{% gist 3102551 server.rb %}

That's a RESTful JSON API for `sports2000` customers in 50 lines of code! Do
you think you can do that in ABL?

## Tests

I agonized over whether to write this app from a test-driven development
perspective, which would necessitate writing tests before writing the app code.
I decided in the interest of absolute simplicity I would focus on the actual
server code, but it would be an excellent learning experience to do this on
your own.  Sinatra has some [good examples][27] of how to write tests for
different test frameworks (I personally enjoy [RSpec][28]).

## Ruby on Rails

I was tempted to make this post be about creating a full CRUD app in [Rails][19]
complete with HTML forms for creating/updating customers, but it would have
required too much hand-waving to be of any use for people new to Ruby (my
audience being ABL programmers).  Sticking with Sinatra keeps you closer to
plain Ruby and keeps the code short and understandable; Rails has a lot of
conventions and requires knowledge of that black magic to get up and running.

The advantages with using Rails would have been that I could have
had models and relationships for *every single table* in `sports2000`, and had
complete HTML forms for CRUD actions be generated easily by Rails's
[generators][23].

Although it wasn't worth the added complexity for this tutorial, I do think
that Rails excels at the typical CRUD app (which is what most applications of
ABL are) and would be worth exploring if you found this post enlightening.
For learning Rails, the best resource I can recommend is
[Michael Hartl's Rails tutorial][21]. However, I would first recommend getting
a better foundation in Ruby, for which I recommend the book
[The Ruby Programming Language][24] both as an overview and as a reference.

Personally, I only learned Rails to pay the bills... Ruby the language is what
really captivated me (although at this point the honeymoon is kind of over).

## Next post(s) in series

There doesn't seem to be much interest in this so far, so I may just cut it
short with the next post with a short summation and some honest advice for
Progress Software Corporation.  However, I also had an idea of showing how to
do a simple database migration using DataMapper's ability to connect to
[multiple databases][25] at the same time (called "contexts" in DataMapper
lingo).  If you've been following along and that interests you let me know in
the comments.

[1]: /final-ode-to-openedge-abl-part-1-a-ruby-adapter-is-born/
[2]: http://datamapper.org
[3]: http://www.apevolution.com/
[4]: http://pugchallenge.org/2012PPT/OpenEdge_and_HTML5.ppt
[5]: http://195.0.161.230/pug/arr/karlstad11/OpenEdge_11_Update_Scandi_PUG.pptx
[6]: http://www.sinatrarb.com/intro
[7]: http://localhost:4567
[8]: http://en.wikipedia.org/wiki/Domain-specific_language
[9]: http://en.wikipedia.org/wiki/Closure_%28computer_science%29
[10]: http://localhost:4567/customers
[11]: https://chrome.google.com/webstore/detail/chklaanhfefbnpoihckbnefhakgolnmc
[12]: http://www.ruby-doc.org/core-1.9.3/Hash.html
[13]: http://tools.ietf.org/html/rfc5789
[14]: http://en.wikipedia.org/wiki/CURL
[15]: http://en.wikipedia.org/wiki/WEBrick
[16]: http://www.ruby-doc.org/core-1.9.3/Hash.html#method-i-reject
[17]: http://www.ruby-doc.org/core-1.9.3/Hash.html#method-i-merge
[18]: http://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm
[19]: http://guides.rubyonrails.org/
[20]: https://github.com/datamapper/dm-rails
[21]: http://ruby.railstutorial.org/
[22]: https://github.com/abevoelker/dm-openedge-adapter
[23]: http://guides.rubyonrails.org/generators.html
[24]: http://www.amazon.com/gp/product/0596516177/ref=as_li_ss_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=0596516177&linkCode=as2&tag=perwebofabevo-20
[25]: http://datamapper.org/docs/misc.html
[26]: http://en.wikipedia.org/wiki/Idempotence#Computer_science_meaning
[27]: http://www.sinatrarb.com/testing.html
[28]: http://rspec.info/
