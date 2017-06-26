---
layout: post
title: "Generating YouTube-like IDs in Postgres using PL/V8 and Hashids"
date: 2017-01-03 00:00
comments: true
facebook:
  image: hashid-url.png
excerpt_separator: <!--more-->
---

[![Hashid](/images/hashid-url.png "Hashid URL")]({{ page.url }})

<p class="message" markdown="1">
  **Update**: There is a brand-new [Postgres Hashids extension](http://hashids.org/postgresql/)
  that you should use if possible instead of this PL/V8 solution! However, this
  solution may still be valuable if you are using AWS RDS, which doesn't
  currently support the Hashids extension.
</p>

Recently on a Rails project, I ran into an issue where I wanted to expose a
resource (lets say it was a *product*) in a RESTful route, but I also didn't want
the URLs to be easily guessable. In other words, following Rails conventions my
standard "show" actions would be URLs like
[https://example.com/products/1](https://example.com/products/1),
[https://example.com/products/2](https://example.com/products/2),
[https://example.com/products/3](https://example.com/products/3), which are
trivially guessable since we're exposing the database's auto-incrementing
integer primary key as the resource ID. To prevent people from writing a super
simple script that could scrape my whole product catalog, it would be nice if we
could make the URLs not trivially guessable while still remaining
publicly-accessable for people who know them.

<!--more-->

One approach that [some people advocate](https://www.clever-cloud.com/blog/engineering/2015/05/20/why-auto-increment-is-a-terrible-idea/)
is simply using UUIDs, but I think URLs like [https://example.com/products/3bc95fb9-f0c1-4af8-989e-6ea8467879d3](https://example.com/products/3bc95fb9-f0c1-4af8-989e-6ea8467879d3)
simply look nasty, particularly when you get into nested sub-resources with
their own UUIDs tacked on. It's something I don't want to subject my users' eyes
to or have potentially affect SEO / page rank due to the extraneous length.<a href="#footnote-1"><sup>1</sup></a>

## Hashids

A nice compromise here is using a library called [Hashids][hashids], which can
take an integer input (e.g. our primary keys), and a salt, and obfuscate<a href="#footnote-2"><sup>2</sup></a> them into
YouTube-like, short, non-guessable IDs like these:
[https://example.com/products/NV](https://example.com/products/NV),
[https://example.com/products/6m](https://example.com/products/6m),
[https://example.com/products/yD](https://example.com/products/yD).

The Hashids project links to many implementations and documentation in various
languages, [including Ruby][hashids-ruby]. Since my project is using Rails, a
simple solution would be to add an `after_create` callback to my model to set an
attribute using the Ruby library:

```ruby
# == Schema Information
#
# Table name: products
#
#  id              :integer  not null, primary key
#  title           :string
#  hashid          :string
#
# Indexes
#
#  index_products_on_hashid  (hashid)
#

class Product < ActiveRecord::Base
  after_create :save_hashid

  private

  def save_hashid
    unless self.hashid
      h = Hashids.new(ENV["HASHID_SALT"], ENV["HASHID_MIN_LENGTH"].to_i)
      self.update!(hashid: h.encode(self.id))
    end
  end
end
```

This works! However there are at least two drawbacks:

1. Creating a `Product` requires two round-trips to the database: an INSERT to
   create the record with a NULL value in the `hashid` column, then an UPDATE
   after Rails gets the value of the integer `id` column and can calculate the
   Hashid value, and update the record with it. This should be safe in terms of
   not leaving half-baked `products` records with NULL `hashid` values out
   there, since Rails runs `after_create` callbacks in the same transaction that
   creates the record, but it's not good performance-wise.
2. Somewhat related to the first drawback, the schema for this table is
   not optimal as the `hashid` column should really have a NOT NULL constraint
   with a UNIQUE index. But using Rails callbacks forces it to be this way. It
   would be much more preferable if we could lean on the database to enforce
   referential integrity; at my job we've seen plenty of instances of bad data
   getting into loose schemas that Should Never Happen™ from the application's
   point of view.

If only there were a way for Postgres to populate that column instead...

## Executing JavaScript in Postgres using PL/V8

Luckily there is a way to do this using a Postgres extension that embeds the V8
JavaScript engine in Postgres called PL/V8!<a href="#footnote-3"><sup>3</sup></a>

On Ubuntu, installing PL/V8 is as easy as doing `sudo apt-get install postgresql-9.6-plv8`
(substitute 9.6 with whatever Postgres version you have installed) and
restarting the database cluster with
`sudo service postgres restart`. Then, open a SQL prompt on the database you
want to enable it for, and execute `CREATE EXTENSION plv8;`. Now you can write
JavaScript functions in the database!

The first step is writing a function to load the Hashids library:

{% gist 14cf0e781bd74fdde1969cca52fc902d %}

(The above is simply the source for [hashids.min.js](https://github.com/ivanakimov/hashids.js/blob/35371e75a5b1393f28d3422ac6d9be1519aaefbd/dist/hashids.min.js)
wrapped in an immediately-executed anonymous function).

After executing that DDL to create the function, execute this SQL to run it:

```sql
SELECT load_hashids();
```

And now, the `Hashids` constant is ready for use in any JavaScript code inside
PL/V8 functions for the remainder of the SQL session ([each session gets its own global JS runtime context](http://pgxn.org/dist/plv8/1.4.4/doc/plv8.html#Runtime.environment.separation.across.users.in.the.same.session)).
We can now do a quick test of the Hashids library inside Postgres:

```sql
DO LANGUAGE PLV8 $$
  var h = new Hashids('foo');
  plv8.elog(NOTICE,h.encode(123));
$$;
```

You should see `NOTICE:  1yR` in the output, confirming it works!

As mentioned, this constant will only live as long as the SQL session. A new
connection will require rerunning `SELECT load_hashids();` to make it
available again. Luckily, PL/V8 comes with support for a
`postgresql.conf` configuration value we can use to load a custom PL/V8 function
when the runtime is initialized. Simply add this to to `postgresql.conf`:

```
plv8.start_proc = 'load_hashids'
```

And now that is all handled for us!

## An example usage

Now let's put it all together with an example that fixes my issue with
*products*. First, let's make a helper SQL function to generate Hashids that
we'll be able to call from other SQL functions (like triggers):

```sql
CREATE FUNCTION gen_hashid(salt TEXT, min_length BIGINT, key BIGINT) RETURNS TEXT AS $$
    var h = new Hashids(salt, min_length);
    return h.encode(key);
$$ LANGUAGE PLV8 IMMUTABLE STRICT;
```

This can be tested like so:

```sql
SELECT gen_hashid('foo', 5, 123);
```

Which should output `61yR6`.

Next, here's a little mockup of a *products* schema that uses a pre-insert
trigger to automatically generate Hashids:

{% gist ecaea89e33ff67e943f2ad1aea3c9552 %}

Now let's test it out by inserting some test records:

```sql
INSERT INTO products (title) VALUES ('foo');
INSERT INTO products (title) VALUES ('foo');
INSERT INTO products (title) VALUES ('bar');
INSERT INTO products (title) VALUES ('baz');
```

And now let's see what `SELECT * FROM products` returns:

```
 id | title | hashid 
----+-------+--------
  1 | foo   | WmX
  2 | foo   | 4zq
  3 | bar   | eJk
  4 | baz   | eEp
(4 rows)
```

Works beautifully! My problem is solved.

Note that in this example I hardcoded the salt and minimum length values in the
`products_pre_insert()` function definition, but in reality one would probably
want to create a table to store salt values as there should be a different salt
value for each table that uses Hashids, and also salts should not be re-used
between test environments and production.

## Footnotes

<sup id="footnote-1">1</sup> I'm not saying it would necessarily affect SEO today,
but SEO tends to trickle down from what Google et al consider to be
human-friendly, which I don't think excessively long machine-readable IDs are. I
certainly think URLs that scroll way past the address bar with seemingly-random
gibberish discourage people who share URLs via address bar copy and paste.

<sup id="footnote-2">2</sup> Although *hash* is in the name, the
[project makes clear](http://hashids.org/#why-hashids) it's not a true
cryptographic hash function (and thus not secure). But for my purposes, it's
exactly what I needed to discourage casual scraping while maintaining a certain
level of user-friendliness that a very secure solution (UUIDs, real crypto hash
functions) wouldn't allow.

<sup id="footnote-3">3</sup> There are other Postgres extensions that add
support for other languages, like PL/Python, but PL/V8 is a "trusted" Postgres
language, while PL/Python is "untrusted." Trusted languages are safer as they
come with certain protections on what actions they can perform - untrusted
languages can do anything that the database administrator can do! This is
probably why AWS RDS supports PL/V8 but doesn't support PL/Python.

## References

* [Loading Useful Modules in PLV8](http://adpgtech.blogspot.com/2013/03/loading-useful-modules-in-plv8.html)
  * This is an awesome and thorough article; not sure I would've figured this out without it!
* [Hashids][hashids]

[hashids]: http://hashids.org/
[hashids-ruby]: http://hashids.org/ruby/
