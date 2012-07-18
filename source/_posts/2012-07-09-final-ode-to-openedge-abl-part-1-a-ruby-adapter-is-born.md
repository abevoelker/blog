---
layout: post
title: "Final Ode to OpenEdge ABL Part 1: a Ruby Adapter is Born"
date: 2012-07-09 12:00
comments: true
categories: 
---

{% img center /images/mass_extinction_event.jpg Foreground: ABL developers at work. Background: arrival of Ruby adapter %}

<div class="alert-message error" markdown="1">
**Update 2012/07/17**: If you installed the sample code before
today, please try again with a fresh gemset
(`rvm gemset empty; bundle install`) as the `do_jdbc` version I was providing
was incorrect and would display error messages when used. Protip: if you're
building gems from source, always do a `rake clean` before a `rake build`!
</div>

It's weird how I have trouble letting go.  Nearly two years ago, I wrote
[a post][1] where I theorized a cure for a programming language and database
that had tortured me at the first full-time programming job that I ever had:
OpenEdge ABL. Shortly after writing that post, I quit my job and moved to a
new city, where I got a job contracting as a Ruby developer.  I'm much
happier at my new job, but every once in awhile I would think back on my
time with OpenEdge and how I never really got to revolutionize it like I
wanted to (yeah, I like to set the bar high).  I sometimes would find
myself checking in on the Progress community areas to see if anything's
changed, kind of like stalking an ex-lover on Facebook.

Little has changed in Progress-land, it seems from my visits.  People
are still drinking
the Kool-Aid, waiting for Progress to keep improving the ABL language.
I think some are slowly catching on to the insanity of it... many are
taking
advantage of the CLR bridge and writing a lot more .NET / C# code.  Of
course that only works for Windows clients; no Mono support yet.  Others
are slowly catching onto [AMQP][13], writing STOMP messaging code in ABL
and interfacing with an external broker like ActiveMQ or RabbitMQ.  Been
there, done that (you're still writing ABL... eww).  Others that still
use ABL directly seem to have all these tools that generate ABL code for
them from model-relationship diagrams (like UML) so they don't have to
write so much boilerplate code; if that's not a sign of a language smell
I don't know what is.

I'm hoping to change all that, now, with the tool that I theorized
in that [old blog post][1] - a Ruby adapter for OpenEdge using the DataMapper
ORM framework. At the time I wrote that blog post I didn't have enough Ruby
experience to extend an existing library, especially that does something
bare-metal like talk to a database.  That has changed, and I am proud to
present the alpha version of this adapter available for immediate testing.

I'm planning this post as part of a short series that will finally give me
some closure on my OpenEdge ABL / Progress past and allow me to move on.
After I'm finished I hope to be able to completely wipe OpenEdge from my
mind and not visit the community anymore (I'm sure they'll appreciate it).
I'd like to spend some time improving my Ruby and maybe learning some
Clojure|Erlang|Haskell.

<!-- more -->

## Requirements

The example code relies on OpenEdge 10.2B; other versions may or may not
work.  `git` is also required for downloading the sample code.  I would also
advise using Linux or Mac for running this code, as it is what Ruby plays
best with.

You will need to extract the JDBC .jar files that correspond to your
[OpenEdge version][14] and put them somewhere in your Java `CLASSPATH`
environment variable so that the adapter can find them. They can typically
be found in an OpenEdge installation directory under `$DLC/java`.

## Preparing a database

The example code will need a copy of the `sports2000` database that is running
the SQL engine.  Here are some commands to create one with the name `foo`,
convert it to UTF-8 (expected by the adapter if there are any non-ASCII chars)
and start serving it on port `13370`. These commands should be ran from a
`proenv` prompt on a machine that can create / serve up OpenEdge databases:

    prodb foo sports2000
    proutil foo -C convchar convert utf-8
    sql_env
    proserve foo -S 13370 -cpinternal utf-8 -cpstream utf-8

Note that I don't think the `-cpinternal` or `-cpstream` stuff is necessary for
the SQL engine but I left it there anyway as I'm paranoid.

## Preparing the Ruby environment

We're going to need a JRuby interpreter in order to run the DataMapper code;
I am assuming you don't have one and am providing installation instructions
using [rvm][2] (note that these instructions should work for Linux and Mac,
but Windows users are on their own):

1. Install [rvm][2] to manage Ruby interpreters and namespace [gems][3] that we
   are going to be installing (a gem is basically a way to package up Ruby code
   for distribution).  Just install rvm as your own user; do NOT use sudo or
   install as single-user mode as root user... it never seems to work right.
2. Open a new terminal window and prepare to install a JRuby interpreter. Type
   `rvm requirements` and find the section "For JRuby, install the following:"
   and install all packages required.  When that is finished, type
   `rvm install jruby-1.6.7`, which will download and install a JRuby
   interpreter.  That isn't the newest version of JRuby, but one that I have
   been testing with and I know works.
3. Create a gemset for containing the gems that we are going to install. Type
   `rvm use --create jruby-1.6.7@openedge-ruby`. This will also switch you
   into the new interpreter and gemset.

## Getting teh codez

I created a little snippet that bootstraps the DataMapper model
definitions needed for the example queries below.  There's also a Gemfile
for installing some gems needed to get up and running.

Get the code by cloning the git repo:

    git clone git://gist.github.com/3073736.git dm-example
    cd dm-example

### Note JDBC version

Open the file `Gemfile` and look at the line #4 with `jdbc-openedge` on it.
Notice that the version is `10.2B`, which is what I have tested everything
with.  There is also a version for `10.1C`, however I haven't tested it.
Any other versions of the OpenEdge JDBC driver may not work; contact me or
leave a comment if you need a different OE version supported.  It might be
difficult to test some versions as I don't have a subscription to Progress's
subscription center to download non-trial versions of their products.

### Install needed gems

Make sure you are using the rvm gemset we created, and install the gems
from the Gemfile using bundler:

    rvm use jruby-1.6.7@openedge-ruby
    gem install bundler
    bundle install

### Put the JRuby interpreter into Ruby 1.9.2-p312 mode

    export JRUBY_OPTS=--1.9

### Set the database parameters for example snippet

Open the file `models.rb` and modify the line #4 that starts with
`DataMapper.setup` to have the parameter values that correspond to your
database.  It should take the form of

    openedge://user:password@host:port/databasename

## Running the code

### Read it first

Before running the `models.rb` code, it makes sense to take a look at it first
and see what it is doing.  Here is the code:

{% gist 3073736 models.rb %}

You can see that the code is very readable.  All it is really doing is
specifying the definitions of a few tables of the `sports2000` database in
Ruby/DataMapper form.  Each Ruby class definition represents a table in the
database; each `property` is a column and an instance of the class
represents a row in the table.

The `storage_names[:default] =` part is for overriding DataMapper's default
behavior of trying to pluralize model names when it looks for them in the
database; e.g. for the model `Customer` the default behavior is to look for
table `Customers` in the database.  A similar behavior is going on with the
`:field` attribute on some properties of the models; DataMapper looks for
an inflected form of the actual property name in the database so we must
override it.  Both of these issues can be solved by writing a custom method
that tells DataMapper how to transform these names properly; it's just
outside the scope of this simple example, but would greatly DRY up the code
and make it much more readable.

Another thing you may notice is the `belongs_to` and `has n` attributes.  These
are for setting up [associations][5] or relationships between tables.  Examples
will follow later.

Finally, notice how primary keys are specified - simply pass a `:key => true`
as part of the attributes of the property.  Also note that DataMapper has no
trouble supporting composite primary keys - check out the `OrderLine` table
definition!

### Finally, execute the code

Type `irb` to open up an interactive Ruby shell. To run the example code,
simply type `require './models'`. If the code loaded successfully, you
should simple see `=> true` (the `=>` denotes the return value).  The rest
of the commands in the following sections will be entered from within this
`irb` shell.  If you are having issues, just post in the comments and I will
try to help.

### Querying

The adapter should handle most [queries][4] that DataMapper does.  I will also
post some SQL that the adapter is generating behind the scenes.

Find the first customer:

```ruby
c = Customer.first
# => #<Customer @cust_num=1 @name="Lift Tours" @country="USA" @address="276 North Drive" @address2="" @city="Burlington" @state="MA" @postal_code="01730" @contact="Gloria Shepley" @phone="(617) 450-0086" @sales_rep="HXM" @credit_limit=#<BigDecimal:678c862e,'0.667E5',3(8)> @balance=#<BigDecimal:3abd6b1e,'0.90364E3',5(8)> @terms="Net30" @discount=35 @comments="This customer is on credit hold." @fax="" @email_address="">
# SELECT TOP 1 "CustNum", "name", "country", "address", "address2", "city", "state", "PostalCode", "contact", "phone", "SalesRep", "CreditLimit", "balance", "terms", "discount", "comments", "fax", "EmailAddress" FROM "customer" ORDER BY "CustNum"
# Get their name:
c.name # => "Lift Tours"
```

Find the last customer:

```ruby
Customer.last
# => #<Customer @cust_num=2107 @name="foobar" @country="USA" @address="" @address2="" @city="" @state="" @postal_code="" @contact="" @phone="" @sales_rep="" @credit_limit=#<BigDecimal:247aa859,'0.15E4',2(8)> @balance=#<BigDecimal:70c27dc4,'0.0',1(4)> @terms="Net30" @discount=0 @comments="" @fax="" @email_address="">
# SELECT TOP 1 "CustNum", "name", "country", "address", "address2", "city", "state", "PostalCode", "contact", "phone", "SalesRep", "CreditLimit", "balance", "terms", "discount", "comments", "fax", "EmailAddress" FROM "customer" ORDER BY "CustNum" DESC
```

If you know the ID of your customer, you can look them up directly:

```ruby
Customer.get(5)
# => #<Customer @cust_num=5 @name="Match Point Tennis" @country="USA" @address="66 Homer Pl" @address2="Address 2" @city="Boston" @state="MA" @postal_code="02134" @contact="Robert Dorr" @phone="(817) 498-2801" @sales_rep="JAL" @credit_limit=#<BigDecimal:3f15676d,'0.11E5',2(8)> @balance=#<BigDecimal:16394576,'0.0',1(4)> @terms="Net30" @discount=50 @comments="" @fax="" @email_address="">
# SELECT TOP 1 "CustNum", "name", "country", "address", "address2", "city", "state", "PostalCode", "contact", "phone", "SalesRep", "CreditLimit", "balance", "terms", "discount", "comments", "fax", "EmailAddress" FROM "customer" WHERE "CustNum" = ?
```

Get the total number of customers:

```ruby
Customer.count
# => 1118
# SELECT COUNT(*) FROM "customer"
```

Get the number of American customers (country == "USA"):

```ruby
Customer.all(:country => "USA").count
# => 1060
# SELECT COUNT(*) FROM "customer" WHERE "country" = ?
```

Get the number of non-American customers (country != "USA"):

```ruby
Customer.all(:country.not => "USA").count
# => 58
# SELECT COUNT(*) FROM "customer" WHERE NOT("country" = ?)
```

If we often need to look up the Americans, we can create a scope for this
particular query by re-opening the Customer class (Ruby has an open object
model which lets you re-open class definitions at runtime!) and adding it:

```ruby
class Customer
  def self.american
    all(:country => "USA")
  end
end

Customer.american.count # => 1060
```

Let's say that I just want the first Wisconsin customer. I can use the `first`
method and even chain that onto my new `american` scope to make it quicker:

```ruby
Customer.american.first(:state => "WI")
# => #<Customer @cust_num=1114 @name="Apple River Sports" @country="USA" @address="945 US HWY" @address2="" @city="Amery" @state="WI" @postal_code="54001" @contact="K Conroy" @phone="(715) 268-9766" @sales_rep="JAL" @credit_limit=#<BigDecimal:4bfb1305,'0.498E5',3(8)> @balance=#<BigDecimal:509dd43b,'0.4517465E5',7(8)> @terms="Net30" @discount=25 @comments="" @fax="" @email_address="">
# SELECT TOP 1 "CustNum", "name", "country", "address", "address2", "city", "state", "PostalCode", "contact", "phone", "SalesRep", "CreditLimit", "balance", "terms", "discount", "comments", "fax", "EmailAddress" FROM "customer" WHERE ("country" = ? AND "state" = ?) ORDER BY "CustNum"
```

DataMapper also supports relations between tables, something that OpenEdge
doesn't really natively do.  For this to work you have to define some
[associations][5] in your model definitions, which we have already done.

Let's start exploring associations by starting with a particular customer
to branch off from. We'll just use the first customer.

```ruby
c = Customer.first
# => #<Customer @cust_num=1 @name="Lift Tours" @country="USA" ...
```

Let's get all the orders for this customer:

```ruby
o = c.orders
# => #<Order @order_num=6 @cust_num=1 ... (there's a bunch)
o.count # => 19
```

To get all the order-lines for this customer:

```ruby
ol = c.orders.order_lines
ol.count # => 46
```

To calculate the total money this customer has spent on every order
for all time, we use Ruby's [reduce][12] method, which is a functional
programming derivitave for reducing a large amount of data down to a
single value:

```ruby
total = c.orders.order_lines.reduce(0){|sum, ol| sum + ol.qty * ol.price}
# => #<BigDecimal:6f09c9c0,'0.6736944E5',7(8)>
```

BigDecimal's string format is yucky but the answer is $67369.44 if you
look closely.  If this were a real app I would consider a custom type for
monetary values.  But anyway, that brevity should bring a tear to your eye
after picturing the huge nested FOR EACH mess that ABL would make you
write to get the same value... *shudder*.

To get all the items this customer ever ordered:

```ruby
i = c.orders.order_lines.items
i.count # => 26
```

To go backwards and get every customer that ever ordered an item:

```ruby
c = Item.first.order_lines.orders.customer
c.count # => 49
```

Obviously I'm not very good at coming up with examples... play around
yourself!

### Insertion/updates/deletes

Record mutation was a secondary feature for me when writing this adapter,
but it seems to work just fine.  One big stumbling block was the lack of
[autogenerated primary key][6] support in the database. This means that
creating new records requires explicitly setting the primary key values on
insertion (however coming from the ABL world one should be used to that
already):

```ruby
next_id = Customer.last.cust_num + 1 # => 2107
c = Customer.create(:cust_num => next_id, :name => "foo bar")
# => #<Customer @cust_num=2107 @name="foo bar" ...
```

DataMapper's `create` method is an atomic thing; it tries to immediately do
a database insertion.  If you want to build up an object incrementally, you
can use `new` and then when you are ready to persist it, call `save`:

```ruby
c = Customer.new(:name => "baz quux")
# => #<Customer @cust_num=nil @name="baz quux" @country=nil
c.country = "USA"

# If we try saving at this point, we will not be able to because we 
# forgot to set a primary key value. The save method returns false:
c.save # => false

# To see the error for this object, just call the errors method:
c.errors
# => #<DataMapper::Validations::ValidationErrors:0x3a57aa @resource=#<Customer @cust_num=nil @name="baz quux" @country="USA" @address=nil @address2=nil @city=nil @state=nil @postal_code=nil @contact=nil @phone=nil @sales_rep=nil @credit_limit=nil @balance=nil @terms=nil @discount=nil @comments=nil @fax=nil @email_address=nil>, @errors={:cust_num=>["Cust num must not be blank"]}>

# To fix the error, we set cust_num to the next PK value:
c.cust_num = 2108
c.save # => true
```

Updating a record is basically the same as how we did the `new`/`save` combo,
except we will find an existing record instead of calling `new`:

```ruby
c = Customer.get(2107)
c.name # => "foo bar"
c.name = "corge grault"
c.save # => true
Customer.get(2107).name # => "corge grault"
```

When you get angry and want to delete a model, use the `destroy` method:

```ruby
Customer.get(2107).destroy # => true
Customer.get(2107) # => nil
```

## Future development

As mentioned, this is alpha software.  If you use it and find any bugs,
I would be grateful if you report them (contact me directly or open a
GitHub issue on [`dm-openedge-adapter`][7]).  Unfortunately, I don't have
a lot of time to fix things quickly.

I was hoping that if there was some
interest in this project I could take some donations, which would let
me take some time off of work and get this
polished up and ready for [integration][8] into mainline DataMapper (which
would also make usage for writing apps extremely simple by having clean
gems; e.g. just `gem install dm-openedge-adapter`).  If you are
interested in this here is the link:

<a href='http://www.pledgie.com/campaigns/17785'><img alt='Click here to lend your support to: OpenEdge Datamapper adapter and make a donation at www.pledgie.com !' src='http://www.pledgie.com/campaigns/17785.png?skin_name=chrome' border='0' /></a>

To get this ready for mainline DataMapper integration, there needs to be
better tests for `dm-openedge-adapter` as well as creating virtual machine
images with different OpenEdge versions pre-installed, ready for running
tests on.

Some other features that would be nice to have, that I would work on:

* Lots more tests!
* Support more versions of OpenEdge (should just need to add support
  to [jdbc-openedge][9], unless JDBC driver has bugs to work around)
* `:sequence` option for fields, like the [Oracle adapter][10] has.
  Would allow you to not have to manually provide a value for the
  field on record insertion if there is a sequence that can be used
  (you can still manually specify it if you want). Very useful for PKs.
* CentOS virtual machine images with various versions of OpenEdge;
  useful for testing and necessary for mainline DM integration.
* Support for [migrations][11]? I'm not really sure if this is something
  people would use as I would think this would be used more for
  legacy support rather than new development. It would probably be a
  lot of work, too.
* Other DataMapper core support needed to get mainline integration,
  or other possible features (please request in comments)

## Next posts in series

I hope to write at least two more posts in this series on OpenEdge;
the first will be expanding on the use of this adapter to write a
simple RESTful Web service using either Sinatra or Rails that
exposes `sports2000` tables as resources (including JSON
representations).  Then, my final post will be some final musings on
OpenEdge ABL and how to sandbox it; I think I will also give some
parting advice to Progress Corp. on how they should open up ABL more.

<div class="alert-message success" markdown="1">
**Update**: [Part 2][15] has now been posted.
</div>

[1]: /cure_for_the_plague_openedge_migration/
[2]: https://rvm.io/rvm/install/
[3]: http://docs.rubygems.org/read/chapter/1#page22
[4]: http://datamapper.org/docs/find.html
[5]: http://datamapper.org/docs/associations.html
[6]: http://stackoverflow.com/questions/9753744/properly-implementing-auto-incrementing-primary-keys-in-openedge-10-2b-using-sql
[7]: https://github.com/abevoelker/dm-openedge-adapter
[8]: https://github.com/datamapper/do/pull/34
[9]: https://rubygems.org/gems/jdbc-openedge
[10]: http://blog.rayapps.com/2009/07/21/initial-version-of-datamapper-oracle-adapter/
[11]: https://github.com/datamapper/dm-migrations
[12]: http://ruby-doc.org/core-1.8.7/Enumerable.html#method-i-reduce
[13]: http://en.wikipedia.org/wiki/Advanced_Message_Queuing_Protocol
[14]: https://github.com/abevoelker/jdbc-openedge#openedge-versions-supported
[15]: /final-ode-to-openedge-abl-part-2-ruby-helps-you-rest-easy/
