---
title: "Doxxing countermeasures for faceposters"
date: 2020-08-11
comments: false
permalink: "doxxing-countermeasures-for-faceposters/"
header:
  og_image: "doxxing-countermeasures-for-faceposters/AC-130.jpg"
---

{% asset 'doxxing-countermeasures-for-faceposters/AC-130.jpg' %}

Do you post online under your real name and face (*facepost*)?

Have you ever worried you'll eventually say something stupid, or have something you said misconstrued, and be attacked by an angry online individual (or worse, mob)?

Have you considered the same risks due to *saying nothing* in the era of "silence is violence?"

I certainly have, and I'd like to share some strategies for shrinking the potential blast radius to your real-world livelihood that I think are useful.

## Faceposting versus alts

The stakes are certainly higher when you post under your real name. It's a whole lot easier to figure out where you live and work starting with your real name. And everything you ever write is forever tied to your permanent identity, ready to be mined; there's no "undo" button. The tradeoff (in theory) is your words carry more weight since you've got your real identity backing them.

A tempting alternative is to simply post under a pseudononymous *nom de plume*[^nom-de-guerre] (*alt*) that you can walk away from at the drop of a hat, but this minimization of personal risk also has repercussions for society.

[^nom-de-guerre]:
    *Nom de guerre* would probably be more accurate in today's climate

There are growing bubbles of masses holding hidden preferences, of media narratives allowed to run wild because the only visible dissent is from anime avatars. These traditional institutions can easily disregard this type of dissent, and the bubbles only pop when the masses are forced to reveal their preferences in something like an election vote.

Rather than get into the calculus of choosing one method over the other - obviously there is value in doing both - I'd rather focus on the scenario where someone online is very mad at you, they've somehow uncovered your real name and the state you live in[^us-centric] (which is a possibility even using an alt), and they want to do some drive-by harassment.

[^us-centric]:
    This is going to be very United States-centric, because, well, that's who I am and what I know!

<!--more-->

## PERSEC

Regardless of your method, you'll want to follow some basic [personal security (PERSEC)](https://www.military.com/spousebuzz/blog/2013/04/3-everyday-persec-rule.html) hygiene. Avoid posting where you work, your birthday, names of spouses and family, don't tag your location in posts, that sort of stuff. It's pretty easy to find this stuff via a [Twitter search](https://twitter.com/search?q=from%3Aelonmusk%20birthday).

You should also be mindful of what's shown in pictures you take - it's pretty easy to find a location if there's a business shown in the background, or sign posts at an intersection.[^extreme-geolocation]

[^extreme-geolocation]:
    Researchers and extreme autists can find a location [from a whole lot less than this stuff](https://www.bellingcat.com/tag/geolocation/), but that's outside the scope of our threat model.

If you want to be extra devious, you could sprinkle a little disinformation in your feed (e.g. list a false employer, say it's your birthday on a day it's not, etc.).

## High value target: your home address

Jobs are replaceable; the highest risk to your personal safety is your home address. Even if an online weirdo is unwilling or unable to pay you a personal visit, they could coax your local SWAT team into doing it for them from thousands of miles away.

So I'd like to spend the rest of the article outlining some publicly-available data sources that may be exposing your home address that you might not be aware of, and some potential strategies for mitigation.

## Exposure: voting

[{% asset "doxxing-countermeasures-for-faceposters/wi-voting-records.jpg" alt="Screenshot of Wisconsin voter data file schema" %}](https://badgervoters.wi.gov)

Many states sell registered voter information. For example, Wisconsin has [a handy website](https://badgervoters.wi.gov) where anyone can buy voters' personal information at a rate of $5 per 1,000 voters, with [no restrictions on usage](https://badgervoters.wi.gov/faq.html) (commercial or otherwise).

The [data provided includes full name, mailing address, phone number, email address, and many other fields](https://elections.wi.gov/sites/electionsuat.wi.gov/files/page/data_elements_electors_with_participation_pdf_19477.pdf).

**Countermeasures**

In Wisconsin, the only way to keep your voting data out of any data requests is to be a "[confidential elector](https://elections.wi.gov/elections-voting/voters/confidential)," which applies to certain victims of domestic abuse, sexual assault and stalking.

Otherwise, there is no way to have your data protected.

You also have to register to vote using your residence address, so you can't simply use a PO Box. Sadly that means the only real countermeasure is to not register to vote.

## Exposure: property ownership

[{% asset "doxxing-countermeasures-for-faceposters/dane-county-record-search.png" alt="Screenshot of Dane County parcel search" %}](https://accessdane.countyofdane.com/Parcel)

Owning a home or a piece of property in your own name puts your name on your county's property tax roll.

In my experience, many counties across the United States have these databases openly searchable by first and last name. Some counties may not be name-searchable and instead require you to provide a mailing address or tax or parcel ID.

Other counties may require you to visit the register of deeds in-person to inspect ownership records rather than have data available online (e.g. Los Angeles County has [an online property search](https://portal.assessor.lacounty.gov/) by address, but only reveals tax dollar amounts - viewing ownership information requires a physical visit to their office. Wouldn't want people looking up celebrities' addresses online!).

**Countermeasures**

You can assign ownership of your property to an artificial person such as a trust or an LLC. The downside is you may lose out on certain tax benefits or legal protections that require you to own your home in your name (mortgage interest deduction, capital gains tax exclusion from selling personal residence, homestead exemption, ...).

Using a revocable trust (which is an extension of your personhood) may still allow use of some of these.

## Exposure: business ownership

[{% asset "doxxing-countermeasures-for-faceposters/business-search.png" alt="Screenshot of Wisconsin business search" %}](https://www.wdfi.org/apps/CorpSearch/Advanced.aspx)

Many states have an online database where you can search for registered businesses by business name or the name of their registered agent, which for many in-state businesses will be the business owner themselves. A registered agent is the person who will be served process if you ever get sued (picture the movie scene when someone hands a person lawsuit papers and says "you've been served" - that's process serving).

The legal requirements in Wisconsin (and I imagine many states) are that the registered agent is available at the given address during normal business hours. Thus for many people starting a business from their home in their own state, they'll just provide their home address.

For example, here is [Wisconsin's online business search](https://www.wdfi.org/apps/CorpSearch/Advanced.aspx). If you search my given name, you'll find an outdated mailing addresses from a previous business venture.

Also, while typically not searchable, once you locate a business on these sites you can often find business ownership information from the articles of incorporation and annual reports, both which are public documents that many states make available for a small fee.

**Countermeasures**

The simplest countermeasure is to always use a registered agent service when starting a business instead of your home address. The [service I use](https://www.wisconsinregisteredagent.net/) costs about $50 per year.

If you want to fully hide your ownership from the public record (i.e. from the articles of incorporation and annual reports), you can assign your ownership in a company to a revocable/living trust (e.g. "Foo Bar Revocable Trust"), or even another LLC you operate (however that LLC will be exposed to the same public document risks, so it's just a layer of indirection - at some point you'll want to terminate with a trust).

Trusts by the way are actually very cool [once I learned about them](https://www.youtube.com/playlist?list=PL2UfDls0cww274MCugusQY36woWWFZX-k):

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Trusts are kind of neat. You write some stuff on a piece of paper, get it notarized, and blammo, you&#39;ve just created an artificial person that the gov&#39;t doesn&#39;t even know about</p>&mdash; Abe Voelker (@abevoelker) <a href="https://twitter.com/abevoelker/status/1286497294955749381?ref_src=twsrc%5Etfw">July 24, 2020</a></blockquote>

### Exposure: court cases

[{% asset "doxxing-countermeasures-for-faceposters/wcca.png" alt="Screenshot of Wisconsin court case search" %}](https://wcca.wicourts.gov/)

Getting a speeding ticket (or worse) could expose your personal information if your state has an online court case system.

In Wisconsin, we are very open access-friendly, and we have a single portal that lets you search for case parties across [all 72 Wisconsin county circuit courts](https://wcca.wicourts.gov/),[^ccap] as well as [Wisconsin Supreme Court and Court of Appeals cases](https://wscca.wicourts.gov/caseSearch.xsl).

[^ccap]:
    Colloquially Wisconsinites call this system *CCAP*, although technically that's incorrect - CCAP
    is the name of the technology wing of the state court system that implements these types of
    technical systems and provides IT services to the courts. The unified circuit court search
    is called WCCA and the Supreme Court and Court of Appeals search is WSCCA.

Other states may not provide this, or leave it up to individual counties to provide their own circuit court and state court case searches. So, you may have to know the county the person lives in (or try all the states' counties) to find court cases on them.

**Countermeasures**

At least in Wisconsin, there's [not a whole lot](https://wcca.wicourts.gov/faq.html#privacy) one can do to get their information off of the online court case system entirely:

> You probably can't get rid of this information. Wisconsin has a strong open records law [[Wis. Stats. 19.31-19.39](http://folio.legis.state.wi.us/cgi-bin/om_isapi.dll?clientID=49601954&infobase=stats.nfo&j1=19.31&jump=19.31&softpage=Browse_Frame_Pg)] that requires most court records to be open. ... Personal information appearing in court records is protected by statutes only in limited circumstances. According to Wisconsin court cases, even if the information may be harmful to an individual's reputation or privacy, that is not necessarily enough to allow a judge to seal a court record.

You *may* be able to pay an attorney to get a case sealed.

Otherwise, you can at least get your home address off of online court records by providing a PO Box to the police/courts.

### Exposure: licensing and credentialing

[{% asset "doxxing-countermeasures-for-faceposters/faa-airmen-search.png" alt="FAA airmen search" %}](https://amsrvs.registry.faa.gov/airmeninquiry/)

If you ever get a federal license, such as for HAM radio or for piloting an aircraft or commercial drone, you will be put on a publicly-searchable database that includes your home address.

For example, here's the [FCC HAM license search](https://wireless2.fcc.gov/UlsApp/UlsSearch/searchLicense.jsp) and here's the [FAA's airmen search](https://amsrvs.registry.faa.gov/airmeninquiry/). Speaking of aircraft, don't forget that they are also [publicly searchable](https://registry.faa.gov/aircraftinquiry/) by tail number and many other details, so be careful posting a picture of your new private aircraft.

Other occupations may also have online licensing databases. For example, if you're a healthcare provider, your information is publicly searchable through the [federal NPI database here](https://npiregistry.cms.hhs.gov/).

All sorts of occupations require state licensing and credentialing, from plumbers and electricians to hair dressers - here's [Wisconsin's credential/license search](https://licensesearch.wi.gov/) page. Thankfully it doesn't return home addresses from a couple tests I did, but your state may vary.

One type of license that many Americans hold is a driver's license. In theory we are supposed to be protected from data disclosures by the Drivers Privacy Protection Act (DPPA) of 1994, created after [an actress was murdered](https://en.wikipedia.org/wiki/Rebecca_Schaeffer) by a stalker who got her address from a DMV open records request. However, there seems to be loopholes as many states [are selling these records](https://www.vice.com/en_us/article/43kxzq/dmvs-selling-data-private-investigators-making-millions-of-dollars) to private investigators, towing companies and others, and making millions of dollars off of it.

**Countermeasures**

[Airmen (pilots) can choose to hide their addresses](https://www.faa.gov/licenses_certificates/airmen_certification/change_releasability/). It seems HAM radio doesn't have this option, so your best bet is to provide a PO Box when getting your license.

In Wisconsin, we can request our DMV withhold our name and address from records requests [using this form](https://wisconsindot.gov/Pages/dmv/license-drvs/rcd-crsh-rpt/optout.aspx). You should check with your state's DMV to see how they share your data and how/if you can opt out.

### Other exposures

There are plenty of other records the government keeps on you that anyone could request.

Some others that come to mind, albeit probably without your home address on them:

* Noncertified copies of vital records like your birth certificate, marriage certificate, death certificate
* Arrest records and mugshots
* Investigation files from police agencies (request your FBI file some time)
* Any correspondence with government agencies (if you know your target emailed a gov't agency, you could FOIA them to get a copy of the email)
* Employment records and even salary data with government agencies (if you worked for any, either as employee or contractor)

There really is a whole lot of data you can mine from the government by just asking - I'm sure I'm missing a ton. I recommend checking out [MuckRock](https://www.muckrock.com/) and seeing what kinds of FOIA / open records requests people are openly making.

If you want to see what kind of data various federal agencies are storing about you, many of them respond to [Privacy Act requests](https://www.justice.gov/opcl/individuals-right-access).

Overall it's an interesting balance - public records help keep the government auditable and accountable to the citizenry in a way that wouldn't be possible if the data was sealed. Yet, there are obvious tensions with citizens' right to privacy.

### When all else fails: end game mitigations

Let's say somehow somebody doxxes you even after you take all the precautions above, and your home address is leaked.

It's worth remembering the odds are still extremely low that someone will SWAT you or physically visit themselves - online mobs are lazy; attackers want a quick payoff and a way to socially validate their attacks with minimal exposure themselves, which lends itself toward online attacks. A tidal wave of negative social media comments, harassing your employer, review bombing your business - that type of stuff. Things that you / your employer can ignore for a couple days until the mob gets bored and moves on.

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Hahahahahahahaha How The Fuck Is Cyber Bullying Real Hahahaha Nigga Just Walk Away From The Screen Like Nigga Close Your Eyes Haha</p>&mdash; Tyler, The Creator (@tylerthecreator) <a href="https://twitter.com/tylerthecreator/status/285670822264307712?ref_src=twsrc%5Etfw">December 31, 2012</a></blockquote>

But, to be extra cautious against tail risk, here's some things that I do that make me feel more secure *just in case*.[^not-just-online]

[^not-just-online]:
    To be honest this is just getting into regular home defense planning which everyone should be doing anyway, to guard against more likely threats than online weirdos.

**Live in a rural area**. The people here are decidedly very "offline." Nobody here even reads online reviews for stores lol. There isn't a chance in hell a posse is going to form on my doorstep over some "online" grievance. Or that an online urbanite will want to make the flight/drive over here.

**Own dogs**. The best intruder alarms are dogs. Plus, they come with their own built-in weapons platform with autonomous target selection and engagement.

**Own and train with firearms**. Thankfully Americans still have the right to defend ourselves. 🇺🇸🦅🍔 The one time my home alarm went off at 2AM, I was very glad I was armed. I'm pretty confident in my ability to poke high velocity holes in someone if they threaten my family's safety.

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Got my Rifleman patch this weekend 😎 <a href="https://t.co/Eo2wW6YvGV">pic.twitter.com/Eo2wW6YvGV</a></p>&mdash; Abe Voelker (@abevoelker) <a href="https://twitter.com/abevoelker/status/1285224025841598464?ref_src=twsrc%5Etfw">July 20, 2020</a></blockquote>

**Secure your home**. Basically kick-proof your doors, get to know your neighbors, or go the extra mile put up some cameras or even a home security system. Or you can go full [KOCOA](https://youtu.be/K4FESGjiH3s?t=1031).

After all that, I feel pretty safe when commenting online. Now the only thing I worry about is posting cringe, which is arguably more terrifying. 😨
