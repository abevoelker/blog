---
layout: post
title: "Final Ode to OpenEdge ABL Part 2: Ruby makes REST easy"
date: 2012-07-10 21:35
comments: true
categories: 
published: false
---

In [part 1][1] of this series, we learned how to get Ruby to talk to an OpenEdge
database by using an adapter for the [DataMapper][2] ORM framework.

Now, we are going to use that ability and harness the power of Ruby to
rapidly prototype RESTful Web services. REST is a pretty big topic and if you
are unfamiliar with it you should probably invest some effort into
learning about it.  However, the simplified version is that it is a way to
describe resources and actions involving said resources; the HTTP protocol
that powers the Web was basically built specifically to implement REST
principles.

In researching this article I tried to find some existing examples of REST
in use in the OpenEdge community to compare to.  All I found were some rumblings
about a [REST adapter][5] that Progress Corp. was supposedly going to provide
for AppServers / WebSpeed as part of OpenEdge 11 which apparently hasn't
materialized, and a "Web 2.0" "RIA" [a product][3] sold by BravePoint which
doesn't use REST at all but uses some proprietary "[RPC Engine][4]" to
communicate between client (JavaScript) and server (WebSpeed broker); using
RPC here is Doing It Wrong if you ask me.

We have no existing OpenEdge prior art to compare to, so let's break new
ground.  We are going to start by building a barebones REST API for a single
resource - customers.  We are going to support all the basic CRUD actions,
which in HTTP terms are POST for create, GET for read, PUT/PATCH for update,
and DELETE for delete/destroy.  For this example we are going to use
[Sinatra][6].

## Setup

I am going to assume that you are following along from [part 1][1] and have
already installed JRuby using rvm.  If so, let's install a newer version of
JRuby and create a new gemset for this demo:

    rvm install jruby-1.7.0.preview1
    rvm use --create jruby-1.7.0.preview1@openedge-sinatra

Let's re-use the same git repo from part 1 that has our DataMapper models
defined (if you still have the code just copy it to a new directory):

    git clone git://gist.github.com/3073736.git openedge-sinatra
    cd openedge-sinatra

If this is a fresh clone be sure to change the database parameters on line
4 of `example.rb` to match yours, and potentially change the version of
OpenEdge on line 4 of the `Gemfile`.

Next, we are going to add the `sinatra` gem to our Gemfile before
installing our gems.  Open the `Gemfile` and add this line at the bottom:

    gem "sinatra", "~> 1.3.2"

Now we are ready to install our gems using bundler. Type

    bundle install

to install the gems.

## Sinatra

Sinatra is essentially a very simple Web server with a simple DSL for
specifying which requests to respond to, and the content to respond with.
Let's create a simple server to respond to the root url (`/`) with
"hello world".  Create a file called `server.rb` and put this content in it:

    require 'sinatra'

    get '/' do
      'hello world'
    end

At this point we can start our Web server by executing the code by
typing

    ruby server.rb

and browsing to [http://localhost:4567][7] in your browser. You should see
the text `hello world` in the body of your browser. Does it shock you how
simple that is?  Can you imagine how much work that would be in ABL?

Without waxing poetically about Ruby too much, I'd like to point out a
couple of things here that might look a bit like magic.

First, it's that the `get` block that we are using
almost reads like it is part of a language specific to Sinatra; however, it
is just plain Ruby.  The flexibility of the Ruby language allows you to make
[domain-specific languages][8] very easily; this `get` method is simply a
method that has been moved into the global scope and accepts two arguments
as parameters - the first being the path to match requests against and the
second being a block - which in turn is a [lexical closure][9], or a chunk
of code that is bound to the lexical scope it is defined in - to be evaluated
on path matches.  In Ruby, putting parentheses around arguments is *optional*,
which is a boon to writing these DSLs.  In addition, another way to specify
a block is with curly braces; therefore we could have written our Sinatra
method like this, and it would still be valid (but not look much like a
DSL):

    get('/'){ 'hello world' }

Secondly, note that our return value of `'hello world'` doesn't need an explicit
return statement next to it - in Ruby, the return value of a method is simply
the last line executed in the method. You *can* do explicit `return`s but it's
not idiomatic Ruby and looks ugly; it's typically only used to short-circuit
evaluation near the beginning of a method due to a problem with some state that
should prevent execution from continuing.

## Hooking into our models

Now that we have a running Web server, let's make it do something useful.
Let's load our DataMapper code from part 1 and adding a route to display all
customers.  Edit your `server.rb` to look like this:

    require 'sinatra'
    require './example'

    get '/customers' do
      Customer.all.to_json
    end

Now visit [http://localhost:4567/customers][10] in your browser, and voila -
you should see a big JSON array of Customers (if you're using Chrome, which you
should be, I recommend the [JSONView][11] extension for maximum readability)!

The URI that we just created is referred to as a "collection URI" as it returns
a collection of resources rather than a single element.  Let's go ahead and add
support for individual elements, and hit all the HTTP methods that correspond to
the CRUD actions - GET (read), POST (create), PUT/PATCH (update), DELETE.


### GET (read)

We already implemented this HTTP type for our collection URI.  The only added
complexity we need for a single element is to handle the ID of the element that
the user is requesting.  Sinatra makes this very easy by providing support for
this in its route matchers.  Add this to your `sinatra.rb` file:

    get '/customer/:cust_num' do |cust_num|
      @customer = Customer.get(cust_num)
      if @customer
        @customer.to_json
      else
        not_found 'unknown customer'
      end
    end

A few things to note here.  First, that similar to methods, blocks can take
parameters, which is what is between the vertical bars (`do |cust_num|`).
The parameter in this case is obviously the customer number being passed in
in the URL.

Second, note that Ruby conditionals use "truthy" evaluation - everything in
Ruby evaluates to true except `false` and `nil`.  Therefore, it is very common
to just see the object used in a conditional rather than an explicit nil check
such as `if @customer.nil?` (which is a code smell and less readable to boot).

Finally, note that again we are taking advantage of Ruby's DSL-supporting
features of the return value of a method being the last statement it evaluates
and the lack of parentheses around the call to the `not_found` method.

### POST (create)

Next, let's support creating a new resource using the HTTP POST method.  Add
this code to `server.rb`:

    post '/customer' do
      next_id = Customer.last.cust_num + 1
      Customer.create(params.merge(:cust_num => next_id))
    end

This one is pretty easy as DataMapper's `create` method accepts a [hash][12] of
attributes, which is what we're passing in (Sinatra stores our parameters in a
hash called `params`).  The only tricky part is getting the next customer
number to use for insertion, as we don't have a sequence.

To test this method, let's use curl to perform the POST:

    curl -X POST -d "name=foo&country=Mexico" http://localhost:4567/customer

Now open an `irb` session, type `require './example'` to load our DataMapper
code, and type `Customer.last` to retrieve the last customer, which should
look something like this, with the `name` set to `foo`:

    #<Customer @cust_num=2107 @name="foo" @country="Mexico" ...

### PUT and PATCH (update)

To update an existing customer, we will use the HTTP methods PUT and PATCH.
The difference is that PUT is for completely replacing the entire customer
object, while PATCH is for retaining the existing customer but only replacing
*some* of its attributes (like a merge).  [PATCH][13] is relatively recent,
having only been proposed in 2010.

    put '/customer/:cust_num' do |cust_num|
      @customer = Customer.get(cust_num)
      if @customer
        @customer.destroy && Customer.create(params.merge({:cust_num => cust_num}))
      else
        not_found 'unknown customer'
      end
    end

    patch '/customer/:cust_num' do |cust_num|
      @customer = Customer.get(cust_num)
      if @customer
        @customer.attributes = params.reject{|k,v| k == :cust_num}
        @customer.save
      else
        not_found 'unknown customer'
      end
    end

Not much special going on here... we use reject in the `patch` method to
prevent users from changing the `cust_num` PK.  Other than that, pretty
simple.  Let's test PUT with curl:

    curl -X PUT -d "name=bar" http://localhost:4567/customer/2107

Verify with `irb`:

    Customer.get(2107)
    # => 


Now let's test PATCH:

    curl -X PATCH 

### DELETE

Finally, to delete a customer, we simply add a method like this:

    delete '/customer/:cust_num' do |cust_num|
      @customer = Customer.get(cust_num)
      if @customer
        @customer.destroy
      else
        not_found 'unknown customer'
      end
    end

Once again we test with curl:

    curl -X DELETE http://localhost:4567/customer/2107

and then verify that the customer is gone from `irb`:

    Customer.find(2107) # => nil

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
