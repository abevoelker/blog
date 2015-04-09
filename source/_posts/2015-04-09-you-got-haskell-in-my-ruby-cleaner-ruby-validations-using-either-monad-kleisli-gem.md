---
layout: post
title: "You got Haskell in my Ruby! Cleaner Ruby validations using the Either monad and Kleisli gem"
date: 2015-04-09 12:00
comments: true
categories:
facebook:
  image: haskell-in-ruby.jpg
---

[{% img center /images/haskell-in-ruby.jpg "You got Haskell in my Ruby!" %}](/images/haskell-in-ruby.jpg)

Alternate title: "You could have invented Either!"

I'm still a rank beginner at Haskell, but I guess it's already leaving some tracks in my brain as I find myself wanting algebraic data types and pattern matching when I'm writing Ruby.

<blockquote class="twitter-tweet" lang="en"><p>Algebraic Data Types Considered Harmful: once you use them, every language lacking them drives you to madness. <a href="https://twitter.com/hashtag/LangSec?src=hash">#LangSec</a></p>&mdash; Nathan Wilcox (@least_nathan) <a href="https://twitter.com/least_nathan/status/581544451597709312">March 27, 2015</a></blockquote>

Recently this became even more apparent when I had to perform a laundry list of validations against an image as part of a feature where users can upload custom avatars of themselves.  Before I save the user-uploaded image to the database and do post-processing on it, I have to ensure that it meets some requirements:

 * verify the file size is < 1MB
 * verify the image is a valid image format
 * verify the image is of type PNG, JPEG, or GIF
 * verify the image dimensions are within 5,000x5,000 pixels

Also, I need a JSON-friendly version of the validation return value as the website is uploading the image via Ajax.

<!-- more -->

## Version 1: naive validation object

Let's write an object to do the validation as naively as possible.  To fit into my Rails project neatly, I'm going to pass it the user-uploaded file directly (which is an `ActionDispatch::Http::UploadedFile`).

Here's a naive version (note I'm using [`mini_magick`][mini_magick] but eliding the `require` as this is a Rails project):

```ruby
class AvatarValidator
  MAX_SIZE = 1.megabyte
  ALLOWED_FORMATS = %w(PNG JPEG GIF)
  MAX_WIDTH, MAX_HEIGHT = [5000, 5000]

  def initialize(uploaded_file)
    @uploaded_file = uploaded_file
  end

  def validate
    @valid ||= begin
      if @uploaded_file.size > MAX_SIZE
        "Picture size must be no larger than #{MAX_SIZE} bytes"
      else
        image = MiniMagick::Image.open(@uploaded_file.tempfile.path)
        if image.valid?
          if ALLOWED_FORMATS.include?(image.type)
            if image.width > MAX_WIDTH or image.height > MAX_HEIGHT
              "Picture dimensions must be within #{MAX_WIDTH}x#{MAX_HEIGHT}"
            else
              true
            end
          else
            "Picture must be an image of type #{ALLOWED_FORMATS.join(' or ')}"
          end
        else
          "Picture must be a valid image format"
        end
      end
    rescue StandardError
      "Sorry, an internal error occurred. Try again or contact us."
    end
  end

  def validate_as_json
    if validate == true
      {success: true}
    else
      {success: false, message: validate}
    end
  end
end
```

The `AvatarValidator` is initialized with the uploaded file. The `validate` method will either return `true` if the file is valid according to our specifications or a `String` indicating the error message if not.  The `validate_as_json` wraps the `validate` method, returning a `Hash` that I can use in a controller for an Ajax-friendly `.json` format.

There are a couple things I don't like with this approach. The first being the return values: two primitive types are being returned with [no context about][boolean-blindness1] [what they represent][boolean-blindness2]. If the values stay pretty close to where they are generated, this is usually okay. However, when projects grow large, these kinds of values have a habit of ending up far away from where they are generated, like some kind of cancerous [metastasis][], [causing confusion as to where they originate from][avdi-boolean] when they cause bugs.

You especially see the problem happen with `nil`s, because they can inhabit any type in Ruby and are used pretty often to represent invalid or unexpected values. So they can happily get passed between long chains of methods until one of the methods eventually tries to do something with it and blows up, far from where the `nil` actually originated from, leaving you to have to dig through a stacktrace and figure out where it came from.

So the first thing I'm inclined to do is to create a type to add some context to what these return values represent.  I'm thinking some kind of `Success` class to represent a successful validation, and an `Error` class to represent a failed validation.  Additionally, the `Error` class should also store some kind of message so that I know what went wrong during the validation.

Let's give it a try:

## Version 2: make return values first-class objects, wrapping a context

```ruby
class AvatarValidator
  MAX_SIZE = 1.megabyte
  ALLOWED_FORMATS = %w(PNG JPEG GIF)
  MAX_WIDTH, MAX_HEIGHT = [5000, 5000]

  class Success; end
  class Error
    attr_reader :message
    def initialize(message)
      @message = message
    end
  end

  def initialize(uploaded_file)
    @uploaded_file = uploaded_file
  end

  def validate
    @valid ||= begin
      if @uploaded_file.size > MAX_SIZE
        Error.new("Picture size must be no larger than #{MAX_SIZE} bytes")
      else
        image = MiniMagick::Image.open(@uploaded_file.tempfile.path)
        if image.valid?
          if ALLOWED_FORMATS.include?(image.type)
            if image.width > MAX_WIDTH or image.height > MAX_HEIGHT
              Error.new("Picture dimensions must be within #{MAX_WIDTH}x#{MAX_HEIGHT}")
            else
              Success.new
            end
          else
            Error.new("Picture must be an image of type #{ALLOWED_FORMATS.join(' or ')}")
          end
        else
          Error.new("Picture must be a valid image format")
        end
      end
    rescue StandardError
      Error.new("Sorry, an internal error occurred. Try again or contact us.")
    end
  end

  def validate_as_json
    case validate
    when AvatarValidator::Success
      {success: true}
    when AvatarValidator::Error
      {success: false, message: validate.message}
    end
  end
end
```

Now our return values can either be an `AvatarValidator::Success` instead of a bare `true`, or an `AvatarValidator::Error` with a `message` which contains the error instead of just a bare `String`.  The code is a little longer than before, but I feel like it's safer now.

The other thing that is bothering me about this approach is the use of nested conditionals for each step of the validation.  This approach is pretty much at its limit, as the successful validation is currently nested within conditional branches four layers deep!  If I needed to add more validations, like ensuring the the image is of square proportions or doesn't have any animation frames, I'd have to add even more nested layers.

One solution would be to convert the nested conditionals into a bunch of individual conditionals with early `return`s, and `Success` being at the very bottom, like so:

```ruby
  def validate
    @valid ||= begin
      if @uploaded_file.size > MAX_SIZE
        return Error.new("Picture size must be no larger than #{MAX_SIZE} bytes")
      end
      unless ALLOWED_FORMATS.include?(image.type)
        return Error.new("Picture must be an image of type #{ALLOWED_FORMATS.join(' or ')}")
      end
      # ...
      Success.new
    end
  end
```

However that does not look like very idiomatic Ruby, and there is danger in forgetting to use `return` in each conditional, or forgetting to put the `Success` as the last value in the method (which would return one of those pesky `nil`s if we ended on a conditional branch not-taken).

Luckily, there is a concept we can borrow from functional programming that will both clean up this conditional branching mess as well as generalize the concept that we invented about propagating the success/error context of our validation: it's called the [Either monad][either-monad].

The general concept of the Either monad is that you wrap success values in a `Right`, and failures in a `Left`.  The mnemonic to remember which is which is to remember that "right" = "correct."  If you're aware of the connotation of ["left" being "sinister" or "evil"][left-evil], you could also remember that. (Fun fact: I was naturally left-handed as a small child until my grandfather would slap my hand every time I would try to use it dominantly.  Thanks for beating the evil out of me Grandpa! :))

But in short, we will be replacing our use of `AvatarValidator::Success` with `Right` and `AvatarValidator::Error` with `Left`.<a href="#footnote-1"><sup>1</sup></a>

I'm going to use the [Kleisli gem][kleisli-gem] to write this version of the validator.  This gem helps clean up our conditional validation mess by introducing a `>->` operator, which lets us do a sort of pattern-matching on these two possible `Either` values. If given a `Right` value, `>->` will unwrap the value inside the `Right` and evaluate a block with it. If given a `Left`, it will simply ignore/skip the block. In this way, `>->` lets us build a sort of short-circuiting pipeline for doing validation, which will either immediately return a `Left` with an error message if *any step* in the pipeline returns a `Left`, or a `Right` only if *every step* in the pipeline returns a `Right`.

Let's try it out!

## Version 3: Either monad using the Kleisli gem

```ruby
require 'kleisli'

class AvatarValidator
  MAX_SIZE = 1.megabyte
  ALLOWED_FORMATS = %w(PNG JPEG GIF)
  MAX_WIDTH, MAX_HEIGHT = [5000, 5000]

  def initialize(uploaded_file)
    @uploaded_file = uploaded_file
  end

  def validate
    @valid ||= begin
      Right(@uploaded_file) >-> value {
        if value.size > MAX_SIZE
          Left("Picture size must be no larger than #{MAX_SIZE} bytes")
        else
          Right(value)
        end
      } >-> value {
        image = MiniMagick::Image.open(value.tempfile.path)
        if image.valid?
          Right(image)
        else
          Left("Picture must be a valid image format")
        end
      } >-> value {
        if ALLOWED_FORMATS.include?(value.type)
          Right(value)
        else
          Left("Picture must be an image of type #{ALLOWED_FORMATS.join(' or ')}")
        end
      } >-> value {
        if value.width > MAX_WIDTH or value.height > MAX_HEIGHT
          Left("Picture dimensions must be within #{MAX_WIDTH}x#{MAX_HEIGHT}")
        else
          Right(value)
        end
      }
    rescue StandardError
      Left("Sorry, an internal error occurred. Try again or contact us.")
    end
  end

  def validate_as_json
    case validate
    when Kleisli::Either::Right
      {success: true}
    when Kleisli::Either::Left
      {success: false, message: validate.value}
    end
  end
end
```

I hope you find this as readable as I do! I find it really easy to see at a glance what the different steps in the pipeline are doing, and the chaining using the `>->` operator helps to prevent fat-finger mistakes.

I have to give props to the Kleisli gem for striking a nice balance between providing useful functional programming tools while still keeping the syntax Rubyish. Also, after looking through similar gems, I find it comforting that it "aims to be idiomatic Ruby to use in Enter-Prise production apps, not a proof of concept." Some other similar gems seem to either have unwieldy syntax or are more toy academic exercises (which is fine, but I don't want to use them for Serious Business™).

## Bonus version: type-annotating methods with contracts.ruby

To add even more safety to this object, there is an interesting gem out there called [contracts.ruby][contracts-ruby-tutorial] which basically lets you add runtime type checking to the boundaries of your methods. This can't give us the purely functional static type checking that languages like Haskell have, but it is a nice tool for catching erroneous inputs and outputs early on, preventing bad values from propagating between method calls.  It's really great for catching dumb mistakes like returning a `nil` from a method that shouldn't be, and the DSL is pretty expressive (as you'll see, I can even describe the internal structure of a `Hash` that should be returned).

Here's a version with `contracts.ruby` type-checking added to the methods:

```ruby
require 'kleisli'
require 'contracts'

class AvatarValidator
  include Contracts
  MAX_SIZE = 1.megabyte
  ALLOWED_FORMATS = %w(PNG JPEG GIF)
  MAX_WIDTH, MAX_HEIGHT = [5000, 5000]

  Contract ActionDispatch::Http::UploadedFile => Any
  def initialize(uploaded_file)
    @uploaded_file = uploaded_file
  end

  Contract None => Kleisli::Either
  def validate
    @valid ||= begin
      Right(@uploaded_file) >-> value {
        if value.size > MAX_SIZE
          Left("Picture size must be no larger than #{MAX_SIZE} bytes")
        else
          Right(value)
        end
      } >-> value {
        image = MiniMagick::Image.open(value.tempfile.path)
        if image.valid?
          Right(image)
        else
          Left("Picture must be a valid image format")
        end
      } >-> value {
        if ALLOWED_FORMATS.include?(value.type)
          Right(value)
        else
          Left("Picture must be an image of type #{ALLOWED_FORMATS.join(' or ')}")
        end
      } >-> value {
        if value.width > MAX_WIDTH or value.height > MAX_HEIGHT
          Left("Picture dimensions must be within #{MAX_WIDTH}x#{MAX_HEIGHT}")
        else
          Right(value)
        end
      }
    rescue StandardError
      Left("Sorry, an internal error occurred. Try again or contact us.")
    end
  end

  Contract None => Or[{ :success => Bool}, { :success => Bool, :message => String }]
  def validate_as_json
    case validate
    when Kleisli::Either::Right
      {success: true}
    when Kleisli::Either::Left
      {success: false, message: validate.value}
    end
  end
end
```

Now if we pass an unexpected value to any of these methods (or try to return an unexpected value *from* them), we will get an immediate runtime type error:

```text
>> AvatarValidator.new('/tmp/path/to/some/file')
ContractError: Contract violation for argument 1 of 1:
        Expected: ActionDispatch::Http::UploadedFile,
        Actual: "/tmp/path/to/some/file"
        Value guarded in: AvatarValidator::initialize
        With Contract: ActionDispatch::Http::UploadedFile => Any
        At: /home/abe/code/gun_crawler_web/app/models/avatar_validator.rb:12
```

Which is a big improvement over the bizarre errors you'd get when you try to use a value of the wrong type as if it were a different type.

## If you enjoyed this, check out Haskell!

This whole example really uses only the most basic concepts in Haskell. If any of this has piqued your interest, I highly recommend learning some Haskell! The best resource for that in my opinion is [Chris Allen (@bitemyapp)'s guide][learn-haskell] (it's the one I find the best as a beginner myself, anyway).

[{% img left /images/haskallywags.jpeg "Haskallywags logo" %}][haskallywags]

And if you're in the Madison, WI area, come check out the [Haskell meetup][haskallywags] hosted by [Bendyworks][bendyworks]!  We've just started working through the exercises referenced in [Chris Allen's guide][learn-haskell], so it's a great time to come if you're a beginner like me.

<div style="clear: both"></div>

## References

* ["Cleaner, safer Ruby API clients with Kleisli"][cleaner-safer-kleisli]
* [Kleisli gem on GitHub][kleisli-gem]
* [The contracts.ruby tutorial][contracts-ruby-tutorial]
* [contracts.ruby on GitHub][contracts-ruby-github]
* [Learn Haskell using Chris Allen (@bitemyapp)'s guide][learn-haskell]

## Footnotes

<sup id="footnote-1">1</sup> Note that unlike our `AvatarValidator::Success`, a `Right` actually wraps a value. This is required so that we can build the pipeline that unwraps the value and passes it to the next block.

Technically what we had actually built was sort of an upside-down [Maybe monad][maybe-monad] around error values, with a `None` (`AvatarValidator::Success`) indicating success (no error), and a `Just m` (`AvatarValidator::Error message`) indicating the error + error message.

[mini_magick]: https://github.com/minimagick/minimagick
[boolean-blindness1]: https://existentialtype.wordpress.com/2011/03/15/boolean-blindness/
[boolean-blindness2]: http://dev.stephendiehl.com/hask/#boolean-blindness
[avdi-boolean]: http://devblog.avdi.org/2014/09/17/boolean-externalities/
[cleaner-safer-kleisli]: http://thoughts.codegram.com/cleaner-safer-ruby-api-clients-with-kleisli/
[kleisli-gem]: https://github.com/txus/kleisli
[learn-haskell]: https://github.com/bitemyapp/learnhaskell
[haskallywags]: http://www.meetup.com/Madison-Haskell-Users-Group/
[bendyworks]: https://bendyworks.com/
[metastasis]: http://en.wikipedia.org/wiki/Metastasis
[either-monad]: http://book.realworldhaskell.org/read/error-handling.html#errors.either
[contracts-ruby-tutorial]: http://egonschiele.github.io/contracts.ruby/
[contracts-ruby-github]: https://github.com/egonSchiele/contracts.ruby
[left-evil]: http://english.stackexchange.com/a/39094
[maybe-monad]: http://en.wikipedia.org/wiki/Monad_%28functional_programming%29#The_Maybe_monad
