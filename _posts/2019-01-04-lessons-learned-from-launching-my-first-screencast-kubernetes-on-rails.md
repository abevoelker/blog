---
title: "Lessons learned from launching my first screencast series / training course, Kubernetes on Rails"
date: 2019-01-04
comments: false
header:
  og_image: "lessons-learned-from-launching-my-first-screencast/kubernetes-on-rails-screenshot.png"
toc: true
toc_label: "Sections"
toc_sticky: true
---

[{% asset "lessons-learned-from-launching-my-first-screencast/kubernetes-on-rails-screenshot.png" alt="Kubernetes on Rails website preview" %}]({{ page.url }})

Last month I recorded my first ever screencast series, [Kubernetes on Rails](https://kubernetesonrails.com/). It's a course that teaches Kubernetes by showing step-by-step how to deploy a sample Ruby on Rails application to Google Cloud's Kubernetes Engine (GKE) (note: although "Rails" is in the title, there's very little Rails-specific bits in the course[^title-note]). In addition, since Google Cloud (GCP) is still a bit more exotic than AWS, I end up teaching some GCP basics as well so it's not *only* about Kubernetes.

[^title-note]:
    Maybe I should've titled the course differently to reflect this. But
    naming and marketing a thing like "Kubernetes for Web devs" seemed a bit too
    broad... also the course teaches Kubernetes without really even needing
    to focus on the Web app bits. So that wouldn't even necessarily be more accurate. Oh well, whatever, naming is hard.

It's now been two weeks since I launched it so I thought I'd share some notes on what I did and what I've learned from my experience so far.

## Backstory

Kubernetes is something that has been stuck in my craw for a while now - the screencast is based on [a series of blog posts](/2018-04-05/deploying-a-ruby-on-rails-application-to-google-kubernetes-engine-a-step-by-step-guide-part-1/) I wrote in the middle of last year touching on basically the same subject material. I think it's important to learn Kubernetes because it was the clear winner in the war of how to deploy Docker containers to production a while back.[^kubernetes-win]

[^kubernetes-win]:
    Remember [Mesos](https://mesosphere.com/)? No? Well there you go.

Originally I wanted to update those blog posts since they were getting a bit out-of-date both in terms of Kubernetes and GKE, as well as smooth over some bumps that some people had emailed me about getting stuck on.

However it dawned on me that blog posts were a poor communication medium for what I was trying to convey, as well as being a lot of work to put together. Taking screenshots, writing step-by-step instructions, guiding it along a narrative that makes sense, with occasional asides on "by the way, here's why we're doing it this way" is hard to put together in a cohesive way when written out compared to me just recording myself actually doing the thing and talking through it.

As a side effect, the screencast approach also gave me a chance to monetize all the work I put into it, whereas I often feel the time I spend on blog posts is not really worth it and sometimes choose to just not bother.

## Results

I'll share the results first to color the context of the rest of the post.

The day I launched, I was charging **$49** for the course, and I received **two sales**. Those were the only sales I got for about a 10-day stretch, after which I changed the pricing to pay-what-you-want. In the 3 days since I changed that, I've gotten at least a sale each day:

1. **$5**
2. **$5.35**
3. **$15** and **$5**

So my gross over the first two weeks so far is **$128.35**. I'll talk more about pricing and marketing later on in the post.

## Inspiration

Before getting too deep into details I have to give props to [Wes Bos (@wesbos)](https://twitter.com/wesbos), who makes (mostly) JavaScript and CSS training courses, of which I've bought and worked through a couple.

I took a lot of inspiration from how Wes does things and when in doubt about a detail I'd look to see how he handled it. This possibly bit me a bit in regards to pricing and distribution which I'll cover later.

Other than following Wes's lead I didn't really do much research on how to do a screencast. I skimmed a couple Google searches but didn't get good results - the only nugget I recall actually using is to write out a transcript before recording (good advice).

Also, although it wasn't on my mind during development because the site is sort of on ice now, I should give props to [Ryan Bates](https://twitter.com/rbates) and [Railscasts](http://railscasts.com) because he was selling screencasts a long time ago, and he did an awesome job - every Rails developer from that era knows what I'm talking about and I certainly learned from his screencasts!

## Recording equipment

Originally I didn't plan on buying any special equipment for this project, so I was just going to use my existing webcam's mic ([Logitech C615](https://www.amazon.com/gp/product/B004YW7WCY/)). Partly because I tend to waste a bunch of time over-researching stuff and falling into an analysis paralysis trap, and partly because this isn't something I plan on doing often enough to justify sinking money into. Also to be honest I didn't have much faith I'd recoup my investment cost.

By chance though I did see [a Hacker News comment](https://news.ycombinator.com/item?id=18536498) saying how good [a cheap ($29) AmazonBasics condenser microphone is](https://amzn.to/2LNWJRM), and [after being convinced by a YouTube review](https://www.youtube.com/watch?v=vhn0lA6uAn8) I picked that up. Since I was buying that I also picked up a cheapo [microphone boom arm with pop filter for $19](https://amzn.to/2RuXNzw) to hold the microphone in front of my face and reduce the plosive thumps that were cited as a problem in the YouTube review.

<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="//ws-na.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&OneJS=1&Operation=GetAdHtml&MarketPlace=US&source=ac&ref=tf_til&ad_type=product_link&tracking_id=abevoelker-20&marketplace=amazon&region=US&placement=B076ZSRVFQ&asins=B076ZSRVFQ&linkId=58349d207e4a528a23d94edc31648015&show_border=true&link_opens_in_new_window=true&price_color=333333&title_color=0066c0&bg_color=ffffff"></iframe>

<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="//ws-na.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&OneJS=1&Operation=GetAdHtml&MarketPlace=US&source=ac&ref=tf_til&ad_type=product_link&tracking_id=abevoelker-20&marketplace=amazon&region=US&placement=B07CN2C93T&asins=B07CN2C93T&linkId=1507bc5dd70dc43296a48e8dc8ae17fc&show_border=true&link_opens_in_new_window=true&price_color=333333&title_color=0066c0&bg_color=ffffff"></iframe>

### What I'd do differently with hindsight

Nothing here - I'm happy with my cheapo microphone and boom arm, although if I grew aspirations to record more professional things I'd probably buy better gear.

## "Studio" setup

As I said, I didn't want to spend any money, so I just recorded from my existing computer desk without adding any acoustic foam or things like that.

Unfortunately my computer happens to be in the unfinished basement of our crappy little apartment. Right beneath the living room where you can hear running kids' feet thumping around, their yelling, TV blasting, my wife's desk chair rolling around, etc. For that reason I could only record in the small window of time where the kids were at school/daycare and my wife was at work, and I didn't have other duties to look after.

Being in the basement, I'm also seated about 10 feet away from our gas furnace, which on some December days in Wisconsin may kick on every half hour or so. So I'd put on my winter coat and boots and shut off the furnace for long stretches while recording. 🥶

We also happen to live very close to train tracks and a small airport due to our location right off the Mississippi river, so once in a while I would have to stop recording when a train horn would be blaring or a loud jet would be coming or going.

{% asset "lessons-learned-from-launching-my-first-screencast/planes-overhead.png" alt="Flight radar showing planes flying near my house" %}

Other fun house noises I now pick up on are the water pipes making noise for a few minutes after someone flushes a toilet and the tank refills, and our hot water heater occasionally kicking on for several minutes. Houses are alive, man!

One last noise I became acutely aware of is the fans on my own PC, and a couple external hard drives I have on my desk. I ended up moving my desktop tower underneath my standing desk (below and off to the side of the mic) and turning off my external hard drives during recording.

### What I'd do differently with hindsight

I don't think I'd do much differently here. Maybe buy some longer cables and move my desktop tower further away from my recording area, and block it off by draping some heavy blankets between. But that's getting a bit anal.

I didn't really research acoustic foam dampening (because $) but I know it exists, and might be worth looking into depending on your setup.

Some day if I got seriously into recording things I'd probably consider building a recording booth like Gary Bernhardt (he's also a lot more serious about recording quality):

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">fully reassembled, no damage as far as I can tell, everything seems to work <a href="https://t.co/00KFjjYdYF">pic.twitter.com/00KFjjYdYF</a></p>&mdash; Gary Bernhardt (@garybernhardt) <a href="https://twitter.com/garybernhardt/status/1053420397973037056?ref_src=twsrc%5Etfw">October 19, 2018</a></blockquote>

## Screen capture setup

First, my development machine runs Ubuntu so I'm limited to Linux-friendly software.

So the first software I tried was [OBS Studio](https://obsproject.com/), which is **amazing** for streaming and honestly really fun to just play around with - you can add multiple video and audio inputs, add different effects and filters on each, script transitions, do chroma key / green screen compositing, all sorts of stuff. It's so good that professional Twitch and YouTube streamers use it; it's really awesome that it's open source and GPLv2-licensed. Although it excels at streaming it also has a record function that works just fine too.

[{% asset "lessons-learned-from-launching-my-first-screencast/obs-screenshot.jpg" alt="OBS screenshot from official project page" %}](https://obsproject.com/)

However if I recall correctly, when recording a first sample with OBS I suffered some screen tearing. I did a quick google search but it was apparent I'd have to do a little tinkering, which led me to try out an alternative recording program first: [SimpleScreenRecorder (SSR)](http://www.maartenbaert.be/simplescreenrecorder/).

When SSR started up, right away it told me that [I had "allow flipping" enabled](http://www.maartenbaert.be/simplescreenrecorder/troubleshooting/#weird-glitches-horizontal-lines-missing-objects-when-using-the-nvidia-proprietary-drivers) in my NVIDIA driver settings which could cause screen glitches, and asked me if I wanted to disable it. After disabling it and recording some sample footage with SSR, I was pleased with the quality so decided to just stick with it. As the name implies, it's simple and does exactly what I needed.

[{% asset "lessons-learned-from-launching-my-first-screencast/SimpleScreenRecorder.png" alt="SimpleScreenRecorder screenshot from official project page" %}](http://www.maartenbaert.be/simplescreenrecorder/)

With the recording software setup, the next thing I did was create a separate Chrome profile to use for recording. This was handy for not accidentally exposing my browser history, bookmarks, extensions and so on when recording, and I could also set the zoom level to 150% for better readability for viewers.

However, when it came time to do some CLI work, I realized I didn't have a clean slate to show installation and configuration of some CLI tools because I already had them installed on my development machine.

So I ended up creating a new Ubuntu user account, then using Ubuntu's CTRL+ALT+F1 login switcher to log in as the other user, and CTRL+ALT+F2 / CTRL+ALT+F3 to quickly switch between my main user account and the screencast user account. I also cranked up the zoom level on my code editor and terminal.

The downside of creating a new user account is it really is a clean slate - I had to configure my code editor, my shell customizations, my SSR profile and so on from scratch.

The other downside is that Ubuntu's fast user switching is a bit more janky than, say, macOS's. Typically it would "just work," however once in a while the audio output would stop working, and I couldn't hear anything when playing back clips I recorded.

I discovered this apparently this has to do with how [PulseAudio](https://www.freedesktop.org/wiki/Software/PulseAudio/) handles multiple users at once (basically, it doesn't). This would be really noticeable if I tried to leave a YouTube video playing in the background on my regular user account then quick switch over to the screencast account and try to play anything that required sound - the play action would just spin/hang for a while then not work.

One really annoying thing that happened on occasion is when I'd get a Google Hangouts message, or any other type of audible "ding" on my main account, it would knock out the audio output on the screencast account for like 15 seconds.

[{% asset "lessons-learned-from-launching-my-first-screencast/poettering-meme.png" alt="AmazonBasics condenser microphone" %}](https://en.wikipedia.org/wiki/Lennart_Poettering)

I did briefly look into what it would take to fix, and it seemed like it would be a headache of [having to enable system-wide mode](https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/SystemWide/) or some such, and [ignore a bunch of security warnings](https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/WhatIsWrongWithSystemWide/) telling you you're probably an idiot for doing it.

Since it seemed to be more of a minor inconvenience - I didn't really need to replay myself talking while recording, just when editing later - I didn't bother messing around trying to fix it at the time. I wanted to just plow through this project as quick as I could while I still felt the itch.

Unfortunately, and I didn't realize this until much later (when I was recording the last episode in fact), but this bug also caused my AmazonBasics condenser microphone to completely disappear from the system. What I didn't notice is that during one of those buggy sound outages, SSR helpfully changed my microphone input back to my crappy webcam microphone! And since that option is sticky, it continued defaulting to my webcam mic going forward. 😞

So I ended up recording the first couple episodes with my new condenser microphone, but episodes 3-7 were recorded on my webcam microphone, while I talked into a dead condenser microphone right in front of my face the whole time.

I had a hint that something was amiss as I edited each one of these episodes after recording them, when I noticed the audio waveform looked noticeably smaller on the later episodes, and I *thought* it seemed a little quieter, but since I'm new to video editing and was tinkering around with editor display options, I assumed I had just messed up one of those.

This was probably my biggest regret on recording the screencast - unintentially making the audio quality worse than it needed to be by not using the equipment I bought. But the quality wasn't so bad that I felt the need to re-record those episodes. So I re-recorded the intro episode and added a voiced apology about the audio difference in some episodes and requested feedback on how annoying it is (if I should re-record or not). I haven't exactly made a lot of sales yet, but so far, no complaints.

### What I'd do differently with hindsight

I should've spent more time understanding and configuring PulseAudio to work with multiple users at once. I naively assumed that a Linux system, with its proud multi-user Unix heritage, would be able to multiplex audio between multiple users concurrently out of the box. Unfortunately the year of the Linux desktop has still not arrived.

I also should've trusted my gut and looked into things early on when my spidey sense tingled during editing.

## Recording process

Before recording an episode, I would write some notes (or for some episodes, almost a whole transcript) in Google Docs so I wouldn't forget anything when recording:

{% asset "lessons-learned-from-launching-my-first-screencast/notes.png" alt="Google Docs notes" %}

Then during recording, I would put my notes up on my leftmost monitor (I have three monitors for my desktop PC setup - the left and right monitors are oriented in portrait mode, and the center monitor is landscape).

The center monitor was the screen I was actually recording, where I was coding and whatnot.

The rightmost monitor I would have SimpleScreenRecorder open to make sure I was recording and a file browser open to occasionally review what I had recently recorded and to delete clips where my tongue would slip or I'd mentally blank out and have to re-record a clip. For some episodes I also had Kdenlive open and would be doing some editing while still recording clips for that episode yet.

I'm not a person who can speak extemporaneously and clearly for long stretches, so I quickly figured out that after I successfully spoke a few sentences or so, it would be helpful to pause for a second or two, and not immediately fill the space with "umm" or other filler words, because then I have a clean gap in the audio where I could pause recording, gather my thoughts for a moment, start recording again, and then cleanly splice the two recordings together to make something cohesive.

### What I'd do differently with hindsight

Get enough sleep the night before. When my brain was tired for a couple episodes it seemed like I could only string two cohesive sentences together at a time without needing to pause the recording after mispeaking about something or blanking out. That stretched out the total recording time and made for a lot of editing work after the fact.

I had one episode where I did pretty much record the whole thing in one take, or maybe only needed two clips, and it was **amazing**. I'm jealous of the programmers I see who can just do this all the time without effort.

If I wanted to continue making screencasts I think I should take a public speaking course or something that would force me to hone this skill. Maybe just talking to myself while coding at home, explaining what I'm doing and why to an invisible audience (I guess being in an always-on rubber duck debug mode) would help?

## Editing

For editing, I chose [Kdenlive](https://kdenlive.org/) and have been very happy with it. It makes it very easy to splice clips together, overlay text, add transitions and other effects, split out audio, all sorts of things. Like OBS, it's GPLv2-licensed and runs great on Ubuntu.

[{% asset "lessons-learned-from-launching-my-first-screencast/kdenlive.png" alt="Kdenlive screenshot" %}](https://kdenlive.org)

Also, it has well thought out features around saving which saved my bacon a couple times. It will do auto-saves (saved me once on a rare occasion where the program had hung when I hadn't manually saved in a long time) as well as keep a history of several backup saves (saved me once when I made an irreversible change that I couldn't undo - I was able to revert to an old save).

The only quirk with Kdenlive I'd point out is be very sure that you choose the correct editing profile at the start of editing. One time I accidentally started with a 30fps profile instead of my typical 60fps, got most of the editing for an episode done, then when I tried to switch to 60fps it screwed up all my clips, shortening lengths to make the overall length of the video about half. This is [apparently a bug that was fixed](https://forum.kde.org/viewtopic.php?f=265&t=138331) at one point which regressed, so hopefully it gets fixed in the future.

### What I'd do differently with hindsight

Nothing; pretty happy with Kdenlive. Although if I did more of this work I'd definitely need to buy more hard drives as video recording and editing requires a ton of storage space.

## Distribution: website and video hosting

When I first did some searching on how to distribute the screencast, I found it pretty odd that someone hasn't already made a platform to distribute screencasts yet. I knew about eBook platforms like have [Gumroad](https://gumroad.com/) and [Leanpub](https://leanpub.com/), but nothing really for screencasts. I found [Egghead.io](https://egghead.io/), however that's a gated subscription service with pre-approved instructors and courses.

So I followed Wes Bos's lead and spun up my own website to host the screencasts on. I use Stripe for payments, store the videos on GCP's Cloud Storage[^cloud-storage-cdn] (presenting signed URLs to users so they can't be trivially shared), and run it on Heroku for $7/mo.

[^cloud-storage-cdn]:
    One thing I like about Cloud Storage is that the URLs [are already edge network-replicated and cached](https://stackoverflow.com/questions/39802631/is-google-cloud-storage-an-automagical-global-cdn), so you get good performance out of the gate regardless of geographic location. With S3 you'd need to put CloudFront or some other CDN in front to get good similar performance.

If I got serious traffic, Cloud Storage would become too expensive and I'd have to look into using Vimeo, [Cloudflare Stream](https://www.cloudflare.com/products/cloudflare-stream/), or something else like that for storing and serving the videos.

### What I'd do differently with hindsight

I'm happy with the website's functionality (although it could probably use a designer's touch), but I may have taken the wrong approach by copying Wes here. He has a proven track record with his courses, 152K Twitter followers, and a mailing list with tens of thousands (perhaps over a hundred thousand?) subscribers.

Wes can easily share a new website he makes to an interested fanbase without having to do a lot of out-of-band marketing, and he can keep more profits for himself by charging cards directly.

I didn't realize until writing this blog post, but I may have been better served by selling my course on [Udemy](https://www.udemy.com/). It wasn't even on my radar because I kept using the term "screencast" until I was preparing to launch the site and then noticed that Wes marketed his stuff as "premium training [*courses*](https://wesbos.com/courses/)." Then I was like oh, right, this actually is sort of a "course." Whoops!

The problem I have looking at Udemy now is [the revenue share looks awful](https://support.udemy.com/hc/en-us/articles/229605008-Instructor-Revenue-Share). For most purchases they keep 50% and you still have to pay PayPal's processing fee - so **you get less than 50%** (!). Unless the user clicked any Udemy ad in the last 7 days, then you get 25% (!). The other problem is every Udemy course seems to be perpetually $9.99, so I figure I'd net about $4.50 per buy after PayPal fees (🤢).

The upside is it seems like people buy the courses at fairly high rates, even for courses that aren't rated very well. I also wouldn't have the monthly Heroku or GCP video storage/serving bill (although that's only ~$7 total).

For now I'm not going to cross-post to Udemy though, especially after some googling and seeing a lot of complaints from instructors (mainly over revenue sharing). I'm okay with the slow trickle of people coming to my own site. But if things dry up it may be something I'll consider.

## Marketing

I was working hard to launch the site before the holiday break started, to catch developers who want to spend their holiday downtime learning a new thing. I finally had the site ready to launch a bit later than I wanted to, but still not late enough that I felt the need to call it off - about 12:30pm central time, middle of the afternoon on Friday, December 21st.

So I posted to Reddit ([/r/ruby](https://www.reddit.com/r/ruby), then later I thought to post to [/r/kubernetes](https://www.reddit.com/r/kubernetes)), and tweeted once from my personal Twitter:

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">Yay I actually finished one of my projects this year! Check it out if you&#39;re a developer wanting to learn how to deploy web apps using Kubernetes <a href="https://t.co/0s1455UcK8">https://t.co/0s1455UcK8</a></p>&mdash; Abe Voelker (@abevoelker) <a href="https://twitter.com/abevoelker/status/1076217010118410241?ref_src=twsrc%5Etfw">December 21, 2018</a></blockquote>

I also posted to [Hacker News](https://news.ycombinator.com/) (as a Show HN) and [lobste.rs](https://lobste.rs/), but neither story got upvoted. 😭

My blog post series get decent search ranking for "rails kubernetes" type queries so I also put a little blurb at the top of those directing people to the newly-recorded screencast series.

### What I'd do differently with hindsight

Unfortunately the /r/ruby post, where I expected to get the most clicks, got hung up in the spam filter because I was posting from a brand new account (using my real name to be more professional). I messaged the mods very shortly after I posted when I noticed this, but after almost 2 hours I got tired of waiting and decided to doxx myself by posting from an alt with a lot of imaginary internet points.

So one thing I would do differently is create the new Reddit account way earlier, to build up some karma and account duration so that Reddit's really stupid spam filter doesn't trip me up.

Although I don't have many e-friends, I have at least a few I could count on to help slightly boost my submissions to help get traction (especially HN). I didn't do this because I find it distasteful but it probably would've helped.

Another thing I find distasteful that I didn't do, but I'm seeing more often, is retweet myself later on in the day to catch more eyeballs. Then again I have a small Twitter reach so this may not have done much.

The last thing I'd do is also post something on [DEV.to](https://dev.to), after seeing [something from Abraham Williams](https://dev.to/abraham/a-month-of-flutter-a-look-back-1j1a) saying he gets a surprising amount of views from posting on there.

Honestly I really hate this whole marketing process. I sympathize with the late [Bill Hicks's attitude on marketing](https://www.youtube.com/watch?v=tHEOGrkhDp0), and the damnedest thing is that social media has turned every single one of us into marketers.

## Pricing

Pricing used to be something I agonized over on a separate project I'm working with my brother on. But one day I [heard Paul Graham](https://youtu.be/4WO5kJChg3w?t=3393) say something to the effect of how it's way more important to get customers than worry about pricing, and how it's not hard to change later - if you raise prices you can just grandfather existing customers in at the old price, and if you lower prices everyone will be happy anyway. That made a lot of sense to me in the context of the other project I was working on (and still does, for something SaaS-y).

So I came in with the same "meh, not a big deal" attitude on pricing for this project and threw a dart at the wall at **$24**. But I didn't launch with this price. Just as I was preparing to launch I got the feeling this was a bit too low, especially after reviewing how much Wes Bos charges and how I'm marketing this as a premium course similar to his. I also had some echoes of [Patrick McKenzie / @patio11 saying "charge more!"](https://twitter.com/search?f=tweets&vertical=default&q=from%3Apatio11%20charge%20more) in the back of my head.

At that same moment a savvy entrepreneur I know on Twitter  separately pinged me with some feedback that he thought pricing was too low as well, so I roughly doubled it to **$49** at the last minute. He didn't advise me on a number, I just decided to double it as if I were being asked to forecast a completion time on a programming task. 🤭

As you saw from the results section earlier, I got **two sales** the day I launched, then nada over the next 10 days.

I felt like I may have missed out on some sales by pricing the course too high, and those people won't be coming back since it's unlikely they will even see a link to the course again, and in the rare event they do, the price will be etched in their mind and they won't re-visit.

I started researching how to adjust pricing to find the right equilibrium point, but there doesn't seem to be great info out there. There seem to be a lot of articles saying "[don't A/B test pricing!](https://www.priceintelligently.com/blog/ab-test-pricing-page-strategy)" so I didn't do that. They don't offer very good alternatives though - either [survey potential customers](https://www.priceintelligently.com/blog/how-to-raise-prices-and-customer-satisfaction-saas-pricing-strategy) to see what they'd be willing to pay (I don't have any marketing list to do that nor am I too keen on it for this type of thing) or copy what similar services are charging (this is what I already did - didn't work too well since I don't have Wes Bos's fanbase/talent and he's in a much hotter niche).

What I ended up doing is letting people choose their own price. I created a pricing page with a slider and text input, defaulted to my suggested $49 price, and a little emoji face that reacts based on how generous the person is:

<video autoplay loop muted>
  <source src="{% asset 'price-slider.mp4' @path %}" type="video/mp4" />
</video>

I've only had this feature up for a few days but I've already gone from a dry spell of sales to at least a sale each day, as I mentioned in the results section. This may not be the ideal solution compared to if I had perfect market information and could set the price to exactly the right point to maximize income, but it's already been a big relief to me that I don't have to overthink the pricing any more. And seeing new people sign up gives me a big confidence boost, even if it's a slow trickle.

In the screenshot above you can see the minimum goes down to $1, which I thought would be nice for students and whatnot, but as I was writing this I decided to nudge it up to $15 and change the step to $2.50 and maximum to $70:

<video autoplay loop muted>
  <source src="{% asset 'price-slider-updated.mp4' @path %}" type="video/mp4" />
</video>

Reason being, while I'm super grateful for every customer I've gotten so far, I realized I do think there is a price floor where if I received a non-trivial question I'd be tempted to just refund the customer outright rather than spend an hour digging into something (assuming it's not something that would affect a lot of people). Students or folks in other situations can always email me for reduced pricing, no problem (which I explain in the FAQ on the landing page).

Another thing I plan to do is when I release two bonus episodes I'm working on, I'll set a "you must spend this much to unlock the bonus episodes" minimum, similar to how Humble Bundle does it (existing customers will get the episodes for free regardless of what they paid). I think this kind of value-add is a very effective sales tactic.

### What I'd do differently with hindsight

With hindsight I realize "charge more!" isn't a magic incantation that nets me more money. Finding a way to experiment by adjusting pricing without ticking people off is great.

Now that I've made one pricing adjustment I feel way less worried about making more if I ever feel the need. The emoji thing was fun and I'm thinking about trying out more things like making the slider more "sticky" at certain price points.

## Final thoughts

I don't really know why I had the impulse to do this but I'm glad I did. Recording myself isn't something that's in my comfort zone, much less being brash enough to charge money for it, so I'm proud of myself for following through and completing it.

The day I launched it and posted the links on social media, I did have a pang of panic that this whole thing was foolish and kicked myself for even putting it out there. I do the same thing after I write a blog post. 😄

But within a few hours, as soon as I got the notification from Stripe that one person had bought the course, suddenly I felt like the whole thing was a success and was really pleased. Even if on paper I'm totally in the red in monetary terms, I still feel good about it! So thank you, first buyers! 😘

Now that I have a small trickle of sales coming in with the pricing change, it's fun to check in on the Stripe app on my phone (which is great by the way) to see if I've gotten another purchase recently or not. I'm looking forward to seeing how things change over time and perhaps making occasional adjustments to pricing.

All that said, I don't have any plans to do anything like this again any time soon! 😁

<div class="notice--success" markdown="1">
If this post made you intrigued, why not head on over to
[Kubernetes on Rails](https://kubernetesonrails.com/) and learn Kubernetes
with me! If you get in now, you'll receive the two bonus episodes
on Terraform and Helm when they're released (soon!)! ☺️
</div>
