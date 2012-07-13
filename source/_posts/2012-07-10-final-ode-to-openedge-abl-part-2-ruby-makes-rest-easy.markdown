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
describe resources and actions involving said resources.  The HTTP protocol
that powers the Web was basically built specifically to implement REST
principles.

In researching this article I tried to find some existing examples of REST
in use in the OpenEdge community to compare to.  All I found were some murmurs
about a [REST adapter][5] that Progress Corp. was supposedly going to provide
for AppServers / WebSpeed as part of OpenEdge 11 which apparently hasn't
materialized, and a "Web 2.0" "RIA" [product][3] sold by BravePoint which
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
OpenEdge on line 4 of the `Gemfile` to use a different JDBC driver loading
mechanism.

Next, we are going to install the `sinatra` gem.  Open the `Gemfile` and add
this line at the bottom:

    gem "sinatra", "~> 1.3.2"

Now we are ready to install all our gems using bundler. Type

    bundle install

to install them.

## Sinatra

Sinatra is essentially a very simple DSL for specifying how to respond to
HTTP requests.  It comes bundled with a simple Web server called WEBrick.

Let's create a simple server to respond to the root url (`/`) with
"hello world".  Create a file called `server.rb` and put this content in it:

```ruby
require 'sinatra'

get '/' do
  'hello world'
end
```

At this point we can start our Web server by running our Ruby code:

    ruby server.rb

Now browse to [http://localhost:4567][7] in your browser. You should see
the text `hello world` in the body of your browser. Does it shock you how
simple that is?  Can you imagine how much work that would be in ABL?

Without waxing poetically too much, I'd like to point out some things about
Ruby here that might look a bit like magic.

First, it's that the `get` block that we are using
almost reads like it is part of a language specific to Sinatra; however, it
is just plain Ruby.  The flexibility of the Ruby language allows you to make
[domain-specific languages][8] very easily; this `get` method is simply a
method that has been moved into the global scope and accepts two arguments
as parameters - the first being the path to match requests against and the
second being a block.

In Ruby, blocks are very important.  They are a [lexical closure][9], or a
chunk of code that is bound to the lexical scope they are defined in (i.e.
they can see variables defined outside of the block).  They are powerful
because they let you pass around a block of code as an object.  The way that
we are using them in our `get` method is to evaluate the first argument -
the route, in this case the `'/'`, and if it matches to execute the code in the
block.

Secondly, putting parentheses around arguments is *optional* in Ruby, which
is a boon to writing these DSLs as it makes the code look more like natural
language than method calls.  In addition, another way to specify
a block is with curly braces; therefore we could have written our Sinatra
method like this, and it would still be valid (but not look much like a
DSL):

    get('/'){ 'hello world' }

Finally, note that our return value of `'hello world'` doesn't need an explicit
return statement next to it - in Ruby, the return value of a method is simply
the last line executed in the method. You *can* do explicit `return`s but it's
not idiomatic Ruby and looks ugly; it's typically only used to short-circuit
evaluation near the beginning of a method due to a problem with some state that
should prevent execution from continuing.

## Hooking into our models

Now that we have a running Web server, let's make it do something useful.
Let's load our DataMapper code from part 1 and add a route to display all
customers.  Edit your `server.rb` to look like this:

    require 'sinatra'
    require './example'

    get '/customers' do
      Customer.all.to_json
    end

Restart the server and visit [http://localhost:4567/customers][10] in your
browser, and voila - you should see a big JSON array of Customers!  If you're
using Chrome I recommend the [JSONView][11] extension for improved readability.

The URI that we just created is referred to as a "collection URI" as it returns
a collection of resources rather than a single element.  Let's go ahead and add
support for individual elements, and hit all the HTTP methods that correspond to
the CRUD actions - GET (read), POST (create), PUT/PATCH (update), DELETE.


### GET (read)

We already implemented this HTTP type for our collection URI.  The only added
complexity we need for a single element is to handle the ID of the element that
the user is requesting.  Sinatra makes this very easy by providing support for
this in its route matchers.  Add this to your `sinatra.rb` file:

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

A few things to note here about Ruby.  First, that similar to methods, blocks
can take parameters, which is what is between the vertical bars
(`do |cust_num|`). The parameter in this case is obviously the customer number
being passed in in the URL.

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

```ruby
post '/customer' do
  next_id = Customer.last.cust_num + 1
  Customer.create(params.merge(:cust_num => next_id))
end
```

This one is pretty easy as DataMapper's `create` method accepts a [hash][12] of
attributes, which is what we're passing in (Sinatra stores our parameters in a
hash called `params`).  The only tricky part is getting the next customer
number to use for insertion, as we don't have a sequence.

To test this method, let's use [curl][14] to perform the POST:

    curl -X POST -d "name=foo&country=Mexico" http://localhost:4567/customer

You should see a response with the JSON data of our new customer appear in the
console.  It should look something like this:

```json
{"cust_num":2107,"name":"foo","country":"Mexico","address":null,"address2":null,"city":null,"state":null,"postal_code":null,"contact":null,"phone":null,"sales_rep":null,"credit_limit":null,"balance":null,"terms":null,"discount":null,"comments":null,"fax":null,"email_address":null}
```

### PUT and PATCH (update)

To update an existing customer, we will use the HTTP methods PUT and PATCH.
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

Not much special going on here... we use reject in the `patch` method to
prevent users from changing the `cust_num` PK.  Other than that, pretty
simple.  Let's test PUT with curl:

    curl -X PUT -d "name=bar" http://localhost:4567/customer/2107

You should see a result like this:

```json
{"cust_num":2107,"name":"bar","country":"USA","address":"","address2":"","city":"","state":"","postal_code":"","contact":"","phone":"","sales_rep":"","credit_limit":"0.15E4","balance":"0.0","terms":"Net30","discount":0,"comments":"","fax":"","email_address":""}
```

Notice that the customer's name did change to `bar` as expected, however the
other attributes reverted to new object defaults (note country changed to
`USA`).

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

Finally, to delete a customer, we simply add a method like this:

    delete '/customer/:cust_num' do |cust_num|
      @customer = Customer.get(cust_num)
      if @customer
        @customer.destroy
      else
        not_found 'unknown customer'
      end
    end

Once again we test with curl, this time adding the `-I` option, which displays
the HTTP headers of the response.  Alternatively, we could change the response
object in our server code to return some type of `{status: "success"}` JSON
but then it would probably make sense to change the rest of our methods too,
so we will take the simple way out:

    curl -IX DELETE http://localhost:4567/customer/2107

You should see an HTTP 200 code on the first line of the response, which means
that the request was successful.  Something like this:

    HTTP/1.1 200 OK 
    X-Frame-Options: sameorigin
    X-Xss-Protection: 1; mode=block
    Content-Type: text/html;charset=utf-8
    Content-Length: 0
    Server: WEBrick/1.3.1 (Ruby/1.9.2/2011-12-27)
    Date: Fri, 13 Jul 2012 03:09:01 GMT
    Connection: Keep-Alive

To verify that the customer really is deleted, you can either repeat the same
command we just did, or more properly do a GET request and you should see a
response header of 404 Not Found with a body of `unknown customer`.


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
