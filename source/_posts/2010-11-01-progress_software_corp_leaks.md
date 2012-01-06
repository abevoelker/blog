---
layout: post
title: Progress Software Corporation Leaks Expose 96K+ Users' Private Info
date: 2010-11-01
comments: true
categories: 
---

A scary post, just slightly late for Halloween...

Contrary to Progress Software Corporation's [privacy policy][],
it doesn't seem like they are doing a whole lot to "Safeguard customers'
information from unauthorized access.". Well, unless you consider
[security through obscurity][] to be a valid defense.

I've discovered two different areas on their websites where users' private
information is wide-open for public viewing - the unsettling ones being
plaintext password, name, address, telephone, job and company info. I've
decided to exercise my [First Amendment][] rights and
publicly release the information, since I am not convinced Progress
wouldn't simply block internet access to the URIs but continue storing
passwords in plaintext on their intranet and deny the issue ever existed if I
simply told them about it.

<!--more-->

## #1 - [Enhancement Request System][ERS]

### Vulnerable URI:

`http://www.progress.com/cgi-bin/ers.cgi/mntacct.r?userid=`

<div class="alert-message warning" markdown="1">
**Update**: Within several hours of this post, Progress took down the link
to the ERS.
</div>

### Number of users exposed: hundreds?

(Would have to scrape all enhancement requests to gather usernames to get an
exact number.)

### Info

Just append a username to the end of it
([example](http://www.progress.com/cgi-bin/ers.cgi/mntacct.r?userid=abevoelker))
and you can see all the private info of the given user. The
password appears starred out, but that's not a big deal - just view the HTML
source of the page or use the FireFox
[Unhide Passwords](https://addons.mozilla.org/firefox/addon/462) add-on and
you will see it.

This system is pretty old, so I feel bad picking on it I guess. So I hate to
mention that it is also vulnerable to [cross-site scripting][XSS] attacks
([example Oracle advertisement][XSS example]).

## #2 - [Progress ID][]

### Vulnerable URI:

`http://www.progress.com/cgi-bin/custprofile.cgi/ws/getProfile.p?id="`

<div class="alert-message warning" markdown="1">
**Update**: Within a few hours of this post, Progress took down the link to this
web service.
</div>

### Number of users exposed: `96,777`

(According to the [Progress Communities People search][] as of 2010-11-01)

### Info

Like #1, just append a valid username to the end of the URI
([example](http://www.progress.com/cgi-bin/custprofile.cgi/ws/getProfile.p?id=abevoelker)).
Oh, look, a bunch of my private information in XML form,
including my password in plaintext.  K-rad.

The scariest thing, in my opinion, is that customer passwords are stored in
plaintext. Since people often re-use their usernames and passwords across sites
(e.g. online banking), it wouldn't be hard for someone with access to this
information to abuse it (e.g. disgruntled employee).

### `{SHA}`

Interestingly, from a few queries I've done, it appears most Progress employees'
passwords are <strong>not</strong> stored as plaintext. They are stored as
<a href="http://en.wikipedia.org/wiki/Base64">base64</a> encoded
<a href="http://en.wikipedia.org/wiki/SHA-1">SHA-1</a> digests (the giveaway is
the `{SHA}` prefix in front of the password and the 28-char size of the data).
I'm guessing this is because this is a known service on their intranet and they
are trying to prevent employees from viewing other employee passwords. Why they
don't extend this same service to their customers, I have no idea. It works
just fine for customers, too, since I was able to encode my own password as
SHA-1 base64, append the {SHA} prefix, and change it using the "change
password" option.  It then allowed me to login by entering the plaintext
password. So it doesn't seem to be a technical limitation.

### `{crypt}`

Some passwords are also prefixed with `{crypt}` and followed by 13
chars. To me, this appears to be an implementation of the
["traditional" crypt(3)](http://en.wikipedia.org/wiki/Crypt_(Unix)#Traditional_DES-based_scheme)
C library function using a modified
[DES](http://en.wikipedia.org/wiki/Data_Encryption_Standard) algorithm.
I haven't created a test account to verify this, but if true, then it is weaker
than the SHA-1 hashing method.

### A Little About Progress' SHA-1 Hashing Method
The `{SHA}`
prefix tells the authenticator to take whatever the user enters for a password,
SHA-1 encode it and promptly forget the plaintext; this hash is then compared to
the hash stored in the database for validation.  The benefit to this is that the
user's password is never stored in its plaintext form, so if security gets
compromised (like right now), the user's plaintext password is not directly
exposed, since
[cryptographic hashing](http://en.wikipedia.org/wiki/Cryptographic_hash_function)
is a one-way operation (i.e. it is very easy to generate the hash
from plaintext but should be impossible to go algorithmically backwards from the
hash to the plaintext).

That is the simple way to do things.  The problem with this method is that it is
vulnerable to a
[time-memory tradeoff attack](http://en.wikipedia.org/wiki/Space-time_tradeoff)
by saving the results of brute-force generated digests into a
database (known as a <a
href="http://en.wikipedia.org/wiki/Rainbow_table">rainbow table</a>). This way,
the digests need only be generated once, and can then be simply looked up in the
database.

The method to get around the above vulnerability is to
[salt](http://en.wikipedia.org/wiki/Salt_(cryptography)) all passwords
with something before hashing, such as the user's username or a pre-shared key.
This makes rainbow tables useless, since they would have to be generated anew
for each salt.  Unfortunately, Progress chose not to salt the passwords, so each
hash is a vanilla SHA-1 digest of the plaintext password, making all user
passwords potentially exploitable by using the same widely-available vanilla
SHA-1 rainbow tables. This was verified by me both by creating a test account
using my own SHA-1 digest and successfully logging in with it, and by actually
looking up an existing user's SHA-1 encoded password on <a
href="http://www.freerainbowtables.com/">Free Rainbow Tables</a> (the password
was `Password1`).

## A Temporary Fix For Users

If you want to put a band-aid on your Progress ID account while Progress fixes
this leak, I suggest
[removing all personal information](http://psdn.progress.com/cgi-bin/custprofile.cgi/psdn/dw/index_eu.w)
from your account (phone number, address, company,
etc.), and SHA-1 encrypting your password.  Make sure that the password is
semi-complex since the hash will be vulnerable to rainbow table lookups until
the leak is fixed.  Also, note that the SHA-1 hash must be base-64 encoded.
Here is a quick example for changing your password to use SHA-1:

### SHA-1 Example
I will be using
[this free online ASCII converter](http://home2.paulschou.net/tools/xlate/)
for this example.

Assume I want to encode a password of `foobar` for my Progress ID. I first enter
in `foobar` in the upper-left hand "TEXT" box and hit "encode".  Then, in the
lower-right hand "MESSAGE DIGEST / CHECK SUM" box, select the text after
"SHA-1:" (it is hex in ASCII format).  For this example that text is

```
e727d1464ae12436e899a726da5b2f11d8381b26
```

Copy
this text and paste it into the upper-right hand box labeled "4 [ HEX ]" and
press "decode".  The box in the lower-left hand corner labeled "6 [ BASE64 ]"
now has the text that we want.  In this example it is

```
5yfRRkrhJDbomacm2lsvEdg4GyY=
```

Click in the box, and type `{SHA}` in front of the text so that it now reads

```
{SHA}5yfRRkrhJDbomacm2lsvEdg4GyY=
```

Copy this
text to the system clipboard; it will be the value you use in your new password
field.  Now visit
[this link](http://psdn.progress.com/cgi-bin/custprofile.cgi/psdn/redirect.p?nscr=pw)
to change your password.  Type in your old password, and paste in your
new one from the clipboard to complete the process.  You should now be able to
log in to your Progress ID using `foobar` for a password, but it will be stored
as a SHA-1 hash and not be publicly visible as plaintext.  Remember to use a
password that is more complex than `foobar`, since it is vulnerable
to rainbow tables.

## Concluding Remarks

Inspired by the <a href="http://en.wikipedia.org/wiki/Nachi_worm">Nachi worm</a>,
I had started writing a bot to scrape the Progress Community People
pages and automatically change unhashed passwords to be SHA-1 encoded.  However,
I stopped after I realized that a bug in the program could end up locking people
out of their accounts, and moreso that the extra bandwidth / resource strain
directed at Progress' servers could open up a door for litigation. Therefore, I
will leave it up to Progress to clean up this issue.

I guess the lesson to be learned from this experience is to trust 3rd parties as
little as possible with your private information, and particularly to avoid
re-using the same password across websites.  Progress isn't the only company to
do this - for example, any time you request your password from a website and
they email you your old password in plaintext instead of a link to enter a new
password, you can be sure that they are either storing your password as
plaintext or encrypting it (which is only a secret key leak away from being
plaintext).  I would be extra wary of my private information with such sites.

[privacy policy]: http://web.progress.com/en/privacy-policy.html
[security through obscurity]: http://en.wikipedia.org/wiki/Security_through_obscurity
[First Amendment]: http://en.wikipedia.org/wiki/First_Amendment_to_the_United_States_Constitution
[ERS]: http://www.progress.com/ers
[XSS]: http://en.wikipedia.org/wiki/Cross-site_scripting
[XSS example]: http://www.progress.com/cgi-bin/ers.cgi/dspreq.htm?lenhreq=0000004104
[Progress ID]: http://web.progress.com/en/progress-id.html
[PID vulnerability]: http://www.progress.com/cgi-bin/custprofile.cgi/ws/getProfile.p?id=
[Progress Communities People search]: http://communities.progress.com/pcom/people?sort=creationDate&showDisabledUsers=true&showExternalUsers=true
