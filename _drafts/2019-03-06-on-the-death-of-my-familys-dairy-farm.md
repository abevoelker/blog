---
layout: post
title: "On the death of my family's dairy farm"
date: 2019-03-06 00:00
comments: false
og_image: "on-the-death-of-my-familys-dairy-farm/cover-image.jpg"
excerpt_separator: <!--more-->
hide_post_header: true
---

<div class="row-full">
  <div class="video-container">
    <video autoplay loop muted class="responsive" style="height: 20vh;">
      <source src="{% asset 'on-the-death-of-my-familys-dairy-farm/farm-hover-1080p.m4v' @path %}" type="video/mp4" />
    </video>
    <div class="video-overlay center-absolute dairy-post-header-text" style="text-align: center;">
      <h1 class="page-title no_toc">
        <span class="title">{{ page.title }}</span>
        <br />
        <span class="byline">by Abe Voelker</span>
        <br />
        <span class="date">{{ page.date | date_to_string: "ordinal", "US" }}</span>
      </h1>
    </div>
  </div>
</div>

This Christmas, like every other, I traveled to northern Wisconsin to stay with my parents on the dairy farm I grew up on.

As usual I took the opportunity to help my dad and younger brother with barn chores and milk cows. The cows need to be milked twice a day, every day, roughly around 4AM and 4PM. I didn't help out every shift but I worked more than enough to once again be humbled about the life I left behind and recalibrate my nostalgia.

<figure>
  {% asset 'on-the-death-of-my-familys-dairy-farm/early-morning.jpg'
    srcset:width=640
    srcset:width=960
    srcset:width=1440
    sizes="(max-width: 320px) 640px,
          (max-width: 480px) 960px,
          1440px"
    width="100%"
  %}
  <figcaption>
    <em>Early morning walk to the barn</em>
  </figcaption>
</figure>

Speaking of which, I never had the work ethic to be a farmer. Ever since I was little and playing video games on our [NES](https://en.wikipedia.org/wiki/Nintendo_Entertainment_System), I was enamored by electronics. By the time our family got a personal computer and dial-up internet for Christmas in 1997,[^family-pc] when I was 11, I was completely and hopelessly sucked in. There followed many evenings where my dad would come flying in to the house to yell at me for being late for chores when I lost track of time on "that damn computer."[^trickery] 😅

[^family-pc]:
    The computer was a Gateway 2000 with a Pentium II 233MHz CPU and 32MB RAM. My parents splurged on a gaming add-on that added a Microsoft SideWinder joystick and a few games (including [Interstate '76](https://en.wikipedia.org/wiki/Interstate_%2776), which may even be what pulled me toward computer programming, which introduced me to hex editing vehicle definition files in order [to "hack" the game](http://www.localditch.com/posts/i-76-hacks/)).

    I have to give props to my parents for going out of their way to make Christmas special every year. I'd share a sentimental pic but most of our home pictures and videos were destroyed in a house fire when I was in college.

[^trickery]:
    I got good at spotting my dad walking the path between the barn and our house, and waiting until he was just kicking open the back door before I'd sprint out the front door. 😗

Thankfully for all involved, my younger brother Noah inherited my dad's insane work ethic and love of farming and took up the farm's reins (he also picked up my slack when we were younger - thanks Brother). He loves the work and excels at it.

<div class="row-full">
  <div class="foo-center">
    <div style="width: 150vh;">
    {% asset 'on-the-death-of-my-familys-dairy-farm/barn-panorama.jpg'
      srcset:width=640
      srcset:width=960
      srcset:width=1440
      sizes="(max-width: 320px) 640px,
            (max-width: 480px) 960px,
            1440px"
      width="100%"
      alt="Sunset harvest on the farm"
    %}
    </div>
  </div>
</div>

<div class="foo-center">
  <p>
    <em>Barn panorama</em>
  </p>
</div>

I instead went to college and became a computer programmer, and haven't lived in my hometown since.

I also have two older brothers; neither of them got the farming gene either. My eldest brother Jerry[^jerry-pic] lives near Madison and also works in the software field. My second-eldest brother John lives near my folks and helps out quite often, but he also does other work and has other obligations, so most of the daily farming work falls on my youngest brother Noah and my dad, who is now into his seventies.

Sadly this year I found out that it will have been my final Christmas coming home and milking cows, because they'll be selling off the cows over the coming spring and fall.

[^jerry-pic]:
    Not to leave brother Jerry out of the pics, 🤭 here he is with his nieces and nephews

    {% asset 'on-the-death-of-my-familys-dairy-farm/jerry-kids.jpg'
      srcset:width=640
      srcset:width=960
      srcset:width=1440
      sizes="(max-width: 320px) 640px,
            (max-width: 480px) 960px,
            1440px"
      width="100%"
    %}

<figure>
  {% asset 'on-the-death-of-my-familys-dairy-farm/dad-and-noah.jpg'
    srcset:width=640
    srcset:width=960
    srcset:width=1440
    sizes="(max-width: 320px) 640px,
          (max-width: 480px) 960px,
          1440px"
    width="100%"
  %}
  <figcaption>
    <em>My dad and brother Noah getting ready to milk</em>
  </figcaption>
</figure>

<!--more-->

## The end of a long battle

This probably shouldn't be a huge shock. Ever since I can remember there has always been a steady drumbeat of family farms going bust. Sometimes the tempo would increase, when milk and/or crop prices would hit new lows, but the drum has always beat on as the industry never seemed to turn a corner.

{% capture milk_price_caption %}
<figcaption>
  <p><em>American milk is a global commodity, with commensurate pricing volatility due to fluctuations in global supply and demand, futures market speculators, and other factors.</em></p>
  <p><em>Source: <a href="https://quickstats.nass.usda.gov/results/54B40DDA-2252-35BE-B720-546DB93F92D3">USDA</a>. 2018 dollar calculation made <a href="http://www.in2013dollars.com/1980-dollars-in-2018?amount=1#formulas">using CPI values</a>.</em></p>
</figcaption>
{% endcapture %}

<figure class="google-chart-xs">
  <iframe width="210.33647058823527" height="386.40625" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vSSJYhi-sgAOJLG__tPV1KEBkKJJtJEg48DoZXB8LcN2scBSx_WKbX5QKM2zeJLW1LK2iyAKiWorsvn/pubchart?oid=1756609052&amp;format=interactive"></iframe>
  {{ milk_price_caption }}
</figure>

<figure class="google-chart-sm">
  <iframe width="259" height="386" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vSSJYhi-sgAOJLG__tPV1KEBkKJJtJEg48DoZXB8LcN2scBSx_WKbX5QKM2zeJLW1LK2iyAKiWorsvn/pubchart?oid=1794751928&amp;format=interactive"></iframe>
  {{ milk_price_caption }}
</figure>

<figure class="google-chart-md">
  <iframe width="521.0128220402086" height="321.89099438470794" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vSSJYhi-sgAOJLG__tPV1KEBkKJJtJEg48DoZXB8LcN2scBSx_WKbX5QKM2zeJLW1LK2iyAKiWorsvn/pubchart?oid=1018332924&amp;format=interactive"></iframe>
  {{ milk_price_caption }}
</figure>

<figure class="google-chart-lg">
  <iframe width="687.5" height="425.1041666666667" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vSSJYhi-sgAOJLG__tPV1KEBkKJJtJEg48DoZXB8LcN2scBSx_WKbX5QKM2zeJLW1LK2iyAKiWorsvn/pubchart?oid=16272520&amp;format=interactive"></iframe>
  {{ milk_price_caption }}
</figure>

Our family farm was subjected to the same ups and downs as every other farm but had always managed to weather every storm. I recall my dad saying how farming was a series of upturns and downturns in pretty much everything, and how it was important to save money from the good years so you can survive the bad years.

{% capture small_farm_production_caption %}
<figcaption>
  <p><em>The cost of production has exceeded the value of production for dairy farms of my family's size since the USDA began collecting these statistics in 2010.</em></p>
  <p><em>Source: <a href="https://www.ers.usda.gov/data-products/milk-cost-of-production-estimates/">USDA</a>, "Milk cost of production by size of operation"</em></p>
</figcaption>
{% endcapture %}

<figure class="google-chart-xs">
  <iframe width="211" height="389" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vSSJYhi-sgAOJLG__tPV1KEBkKJJtJEg48DoZXB8LcN2scBSx_WKbX5QKM2zeJLW1LK2iyAKiWorsvn/pubchart?oid=1327472397&amp;format=interactive"></iframe>
  {{ small_farm_production_caption }}
</figure>

<figure class="google-chart-sm">
  <iframe width="259" height="389" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vSSJYhi-sgAOJLG__tPV1KEBkKJJtJEg48DoZXB8LcN2scBSx_WKbX5QKM2zeJLW1LK2iyAKiWorsvn/pubchart?oid=342453800&amp;format=interactive"></iframe>
  {{ small_farm_production_caption }}
</figure>

<figure class="google-chart-md">
  <iframe width="526" height="325" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vSSJYhi-sgAOJLG__tPV1KEBkKJJtJEg48DoZXB8LcN2scBSx_WKbX5QKM2zeJLW1LK2iyAKiWorsvn/pubchart?oid=488802163&amp;format=interactive"></iframe>
  {{ small_farm_production_caption }}
</figure>

<figure class="google-chart-lg">
  <iframe width="687.5" height="425.1041666666667" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vSSJYhi-sgAOJLG__tPV1KEBkKJJtJEg48DoZXB8LcN2scBSx_WKbX5QKM2zeJLW1LK2iyAKiWorsvn/pubchart?oid=1477499018&amp;format=interactive"></iframe>
  {{ small_farm_production_caption }}
</figure>

One of the bad times I can remember was in the mid-to-late 90s - I was in elementary school - when milk prices were so low that some farmers were [dumping their milk down the drain in protest](http://www.spokesman.com/stories/1997/jan/23/spilled-milk-dairy-farmers-dump-product-to/). At that time, my mom got involved in dairy activism and became a lead organizer of a group of area farmers who worked together to try to improve their lot and raise public awareness of their struggles.

In December 1995 they met with Wisconsin progressive legend [Ed Garvey](https://en.wikipedia.org/wiki/Ed_Garvey), a labor attorney who successfully helped form the [NFL players' union](https://en.wikipedia.org/wiki/National_Football_League_Players_Association), to talk about forming a union for farmers.

<figure>
  {% asset 'on-the-death-of-my-familys-dairy-farm/union.jpg'
    srcset:width=640
    srcset:width=960
    srcset:width=1440
    sizes="(max-width: 320px) 640px,
          (max-width: 480px) 960px,
          1440px"
    width="100%"
    alt="Newspaper clipping of Ed Garvey meeting regarding forming a union"
  %}
  <figcaption>
  </figcaption>
</figure>

The following year, after being rebuffed by a state representative for being a negligible percent of his constituency and told to come back when they had more support, they rallied farmers across the state to voluntarily close off their land to all recreational activity such as hunting, fishing, snowmobiling,[^snowmobiler-support] and four-wheeling (snowmobile and ATV trails often cross farmers' private land in Wisconsin).

[^snowmobiler-support]:
    It's worth noting that snowmobilers were generally supportive of the land lockout:

    {% asset 'on-the-death-of-my-familys-dairy-farm/closed-trails.jpg'
      srcset:width=640
      srcset:width=960
      srcset:width=1440
      sizes="(max-width: 320px) 640px,
            (max-width: 480px) 960px,
            1440px"
      width="100%"
      alt="Newspaper clipping of snowmobilers supporting land lockout"
    %}

<figure>
  {% asset 'on-the-death-of-my-familys-dairy-farm/dairy-lockout.jpg'
    srcset:width=640
    srcset:width=960
    srcset:width=1440
    sizes="(max-width: 320px) 640px,
          (max-width: 480px) 960px,
          1440px"
    width="100%"
    alt="Newspaper clipping of farmer land lockout"
  %}
  <figcaption>
  </figcaption>
</figure>

They also blockaded a creamery cooperative's weighing scales to protest the low prices.

<figure>
  {% asset 'on-the-death-of-my-familys-dairy-farm/scales-blocked.jpg'
    srcset:width=640
    srcset:width=960
    srcset:width=1440
    sizes="(max-width: 320px) 640px,
          (max-width: 480px) 960px,
          1440px"
    width="100%"
    alt="Newspaper clipping showing creamery scales being blocked"
  %}
  <figcaption>
  </figcaption>
</figure>

In 1997 they founded an organization called Save Our Family Farms with the objective of getting farmers across the country to respond to a non-binding referendum on pricing mechanisms and [supply management](https://en.wikipedia.org/wiki/Supply_management_(Canada)). I think the intent was to provide evidence of grassroots farmer support for Canadian-style controls on milk price and supply, which [reduce volatility and the need for subsidies](https://www.dairyfarmers.ca/what-we-do/supply-management/myths-realities) and have managed to maintain Canada's family farms' existence, which would give the American federal government ammo to institute similar policies.

Later in 1998 they succeeded in establishing their union[^union] (technically a guild due to federal labor laws) as a branch of [OPEIU](https://en.wikipedia.org/wiki/Office_and_Professional_Employees_International_Union), which in turn is affiliated with [AFL-CIO](https://en.wikipedia.org/wiki/AFL%E2%80%93CIO).

[^union]:
    The article states that it was the first such union in the country but that isn't accurate. There were other dairy farmer unions, such as the [National Farmers Organization (NFO)](https://en.wikipedia.org/wiki/National_Farmers_Organization), however the NFO had a reputation for protests sometimes spilling over into violence, which my mom and other farmers didn't want any part of.

<div class="row-full">
  <div class="foo-center">
  <div style="width: 150vh;">
  {% asset 'on-the-death-of-my-familys-dairy-farm/mom.png'
    srcset:width=640
    srcset:width=960
    srcset:width=1440
    sizes="(max-width: 320px) 640px,
          (max-width: 480px) 960px,
          1440px"
    width="100%"
    alt="Newspaper clipping showing creamery scales being blocked"
  %}
  </div>
  </div>
</div>

<!--
May 1997:

{% asset 'on-the-death-of-my-familys-dairy-farm/save-our-family-farms.jpg' alt='Newspaper clipping of "Save Our Family Farms" and the attempt at a national referendum' %}

Wisconsin Dairy Farmers Association? 02/25/1998
-->


Unfortunately, while my mom and the other farmers had some success in raising awareness and garnering some attention from various government officials, their efforts didn't have any discernible effect on policy or the milk price bottom line. Dairy farmers once again had to either hold on tight and ride it out, or go bust (and many did).

For our family at that time, the milk price situation combined with my dad needing knee surgery (from repeated stress of kneeling on concrete to milk cows) resulted in us having a dispersal sale and selling off most of the herd.

I remember it being an emotional day. After spending a week thoroughly cleaning up the barn and cattle, we set up a fenced-off show area outside the barn where on the day of the auction, the cattle were paraded out one-by-one to display to bidders and the auctioneer.

Milk prices being low also lowers the value of milking cows themselves, so we got less money than we had hoped for. To a kid it felt like vultures were paying a pittance to carry away a piece of my identity. By the end of the day, looking down the alleyway at mostly-empty cow stalls bedded with fresh sawdust, that anger turned to sadness and a sense of loss.

<figure>
  {% asset 'on-the-death-of-my-familys-dairy-farm/dispersal-sale.png'
    srcset:width=640
    srcset:width=960
    srcset:width=1440
    sizes="(max-width: 320px) 640px,
          (max-width: 480px) 960px,
          1440px"
    width="100%"
    alt="Dispersal sale newspaper ad"
  %}
  <figcaption>
    <em>Dispersal sale newspaper ad</em>
  </figcaption>
</figure>

In time, my dad recovered from his surgery, my older brothers graduated from high school and moved out, and as my younger brother and I aged into our early teens, the herd was slowly built up to near-previous levels again.

## "Get big or get out"

It seems hard to believe but at one point it was possible to make a decent living as a dairy farmer with a small herd (what's now considered small, anyway). In 1981 my dad had a herd of 82 milking cows and he cracked the top 50 in all of northwest Wisconsin's 22 counties for average milk production. This was in the heart of America's dairyland by the way, to the point that federal milk pricing used to be based on [how many miles away from here you were](https://www.wsj.com/articles/SB880411473424429000).

While not a scientific poll, it's an interesting sample. If you look at the herd sizes listed you can see that they're all what would now be considered small, with only two herds just barely over 100 head.

<figure>
  {% asset 'on-the-death-of-my-familys-dairy-farm/dads-top-50-herd.png'
    srcset:width=640
    srcset:width=960
    srcset:width=1440
    sizes="(max-width: 320px) 640px,
          (max-width: 480px) 960px,
          1440px"
    width="100%"
  %}
  <figcaption>
    <em>In 1981, my dad's herd was ranked 48th in northwest Wisconsin for average milk production</em>
  </figcaption>
</figure>


<!--
https://www.change.org/p/secretary-of-agriculture-sonny-perdue-help-dairy-farmers-survive?recruiter=928323288&utm_source=share_petition&utm_medium=email&utm_campaign=share_email_responsive&utm_term=share_petition

> The number of dairy farmers in the US has declined from nearly 360,000 in 1981 down to the present level of approximately 40,000.


My dad told me that when he was young he remembers when his folks were finished with chores they'd have time to eat dinner, play cards and visit with relatives and neighbors. He told me how although they weren't making a lot of money, they were content with what they had and had no sense of needing to expand.

That's hard to imagine compared to today. When I was young and my older brothers were teens, I remember us all working hard on the farm, and my dad always had a hired man or two to help out (and they were grown men who worked hard). With that amount of help the work felt manageable. Nowadays that same amount of work mainly falls upon just my dad and younger brother to complete. 

My dad and brother 

there was no frantic rush to expand and 


https://www.dairyherd.com/article/licensed-dairy-farm-numbers-drop-nearly-4-2017
https://www.milkbusiness.com/article/licensed-dairy-farm-numbers-drop-to-just-over-40000
https://release.nass.usda.gov/reports/mkpr0218.pdf
!-->

From what I can tell, the farming landscape changed dramatically in the 1970s when [President Nixon promoted agribusiness lobbyist Earl "Rusty" Butz](https://grist.org/article/the-butz-stops-here/) to USDA secretary. Butz had [a reputation going back to at least the 1950s](https://www.nytimes.com/1976/06/13/archives/why-they-love-earl-butz-prosperous-farmers-see-him-as-the-greatest.html) for lobbying for dramatic modernizations to farming at the expense of small farms. ["Adapt or die; resist and perish... Agriculture is now big business" he would say](https://books.google.com/books?id=zJs4AAAAIAAJ&pg=PA136&dq=%22Adapt+or+die,+resist+and+perish%22&hl=en&sa=X&ved=0ahUKEwi6lPm4t53gAhVE5YMKHft2AdkQ6AEIKDAA#v=onepage&q=%22Adapt%20or%20die%2C%20resist%20and%20perish%22&f=false). By the 1970s, before his USDA nomination, he was a director of three large agribusiness corporations.

<figure>
  {% asset 'on-the-death-of-my-familys-dairy-farm/earl-butz-usda-portrait-2.jpg'
    srcset:width=640
    srcset:width=960
    srcset:width=1440
    sizes="(max-width: 320px) 640px,
          (max-width: 480px) 960px,
          1440px"
    width="100%"
  %}
  <figcaption>
    <em>Portrait of former USDA secretary Earl Butz. Public domain image <a href="https://www.usda.gov/our-agency/about-usda/history/former-secretaries">courtesy USDA</a>.</em>
  </figcaption>
</figure>

Before Butz, farming practices were ruled by [FDR New Deal](https://en.wikipedia.org/wiki/New_Deal)-era controls on production, when memories of the [Dust Bowl](https://en.wikipedia.org/wiki/Dust_Bowl) and destruction of the land through overproduction were still vivid. These production controls aimed to smooth out volatility by paying farmers to keep fields fallow in times of overproduction, and to release grain from storage in times of shortages. Farming production was geared toward American consumption, but even with the production controls there was always a surplus of grain to deal with.

Nixon brought Butz in with a mandate to get rid of the grain surpluses. Butz architected this by selling off the grain surpluses to the Soviets in ["the largest grain deal so far as we [knew] in the history of the world"](https://www.nytimes.com/1973/11/25/archives/some-deal-the-full-story-of-how-amepnka-got-burned-and-the-russians.html) in 1972 for hundreds of millions of dollars.

Unfortunately, the deal didn't come with an upper limit on how much grain the Soviets could buy ("because it did not occur to [them] that the Russians could ever buy too much"), and the Soviets bought up [one-fourth of the U.S. wheat harvest that year](https://www.upi.com/Archives/1982/07/30/The-great-Soviet-grain-robbery-10-years-later/5162396849600/). The following year, American supermarket prices for bread and other goods [shot up by 20%, of which some estimates attribute at least 15% of the rise directly on the export deal](https://www.nytimes.com/1973/11/25/archives/some-deal-the-full-story-of-how-amepnka-got-burned-and-the-russians.html). Butz and the other dealmakers were dragged before a furious Congress to testify on what happened.

The grain shortages were a windfall for grain farmers, who were getting a higher price for their grain, but bad news for dairy farmers and other livestock farmers who fed their animals with grain.

To make up for the grain shortfall, Butz removed all production limits on grain and fervently encouraged farmers to go wild with production, to plant ["from fencerow to fencerow" and "get big or get out."](https://www.agweek.com/opinion/columns/4425097-considering-lessons-earl-butz)

The effects were quickly apparent, as before his USDA tenure was finished [Butz became a pariah to everyone but the big farmers](https://www.nytimes.com/1976/06/13/archives/why-they-love-earl-butz-prosperous-farmers-see-him-as-the-greatest.html) as small farmers went bust under the continual tightening of the efficiency noose (Butz of course had no sympathy for these "inefficient" farms).

While not the whole story, Butz's era was undoubtedly a major turning point in orienting our food economy towards consolidation and concentration of production in fewer and fewer hands.

<!--
Throughout the 1970s, grain farmers continued to do well, supermarket prices remained high, the USDA was exposed as being very "cozy" with large grain exporters, and [Butz became a pariah to everyone but the big farmers](https://www.nytimes.com/1976/06/13/archives/why-they-love-earl-butz-prosperous-farmers-see-him-as-the-greatest.html) as small farmers went bust under the continual tightening of the efficiency noose (Butz of course had no sympathy for these "inefficient" farms).

http://www.aei.org/publication/no-butz-about-it/

https://www.statista.com/topics/1284/milk-market/

https://data.bls.gov/timeseries/APU0000709112?amp%253bdata_tool=XGtable&output_view=data&include_graphs=true

https://www.statista.com/statistics/236854/retail-price-of-milk-in-the-united-states/


The evaporation of small farms as American farm products were turned into global commodities has continued ever since.
-->

<!--
https://www.google.com/search?q=butz+grain+storage+sale+to+russia&rlz=1C5CHFA_enUS809US809&oq=butz+grain+storage+sale+to+russia&aqs=chrome..69i57.7710j0j7&sourceid=chrome&ie=UTF-8


> While vaguely aimed at helping the "family farmer," (g)government assistance programs have... benefited the largest farms... Because they are geared to production, the percentage of farmers receiving government payments rises with farm size, as does the size of the payment. Government assistance programs have also become capitalized into land values, thereby benefiting larger landholders to the greatest extent.

source: 1978 article https://aliciapatterson.org/stories/american-farm-policy-helps-b-hurts-american-farm
!-->

## Rise of the CAFOs

The consolidation of dairy and the continual shrinking of profit margins have led to drastic changes to the industry over the years.

One change is that through selective breeding, improved nutrition, increased milking frequency and other factors, the amount of milk that a single cow yields per year [has more than doubled since the 1970s](https://www.wpr.org/how-we-produce-more-milk-fewer-cows):

{% capture average_milk_production_caption %}
  <figcaption>
    <small>
      <em>
        Source: <a href="https://quickstats.nass.usda.gov/">USDA Quick Stats</a>
        <ul>
          <li><a href="http://quickstats.nass.usda.gov/results/0F9E6099-F603-3ECB-9089-4D1005A9C9FC">MILK - PRODUCTION, MEASURED IN LB / HEAD (1924-2017)</a></li>
        </ul>
      </em>
    </small>
  </figcaption>
{% endcapture %}

<figure class="google-chart-xs">
  <iframe width="221" height="393" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vSSJYhi-sgAOJLG__tPV1KEBkKJJtJEg48DoZXB8LcN2scBSx_WKbX5QKM2zeJLW1LK2iyAKiWorsvn/pubchart?oid=1257936240&amp;format=interactive"></iframe>
  {{ average_milk_production_caption }}
</figure>

<figure class="google-chart-sm">
  <iframe width="255" height="393" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vSSJYhi-sgAOJLG__tPV1KEBkKJJtJEg48DoZXB8LcN2scBSx_WKbX5QKM2zeJLW1LK2iyAKiWorsvn/pubchart?oid=368073399&amp;format=interactive"></iframe>
  {{ average_milk_production_caption }}
</figure>

<figure class="google-chart-md">
  <iframe width="519" height="321" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vSSJYhi-sgAOJLG__tPV1KEBkKJJtJEg48DoZXB8LcN2scBSx_WKbX5QKM2zeJLW1LK2iyAKiWorsvn/pubchart?oid=1443506890&amp;format=interactive"></iframe>
  {{ average_milk_production_caption }}
</figure>

<figure class="google-chart-lg">
  <iframe width="687.5" height="425.1041666666667" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vSSJYhi-sgAOJLG__tPV1KEBkKJJtJEg48DoZXB8LcN2scBSx_WKbX5QKM2zeJLW1LK2iyAKiWorsvn/pubchart?oid=559722744&amp;format=interactive"></iframe>
  {{ average_milk_production_caption }}
</figure>

This has allowed overall milk production to increase, even while the total number of cows has shrank:

{% capture cows_vs_production_caption %}
  <figcaption>
    <small>
      <em>
        Source: <a href="https://quickstats.nass.usda.gov/">USDA Quick Stats</a>
        <ul>
          <li><a href="https://quickstats.nass.usda.gov/results/7BAA35F6-E43C-3C3D-8CC3-503DCDBABB91">CATTLE, COWS, MILK - INVENTORY (1867-2018)</a></li>
          <li><a href="https://quickstats.nass.usda.gov/results/C9B07057-72F5-3430-B5B8-987D54A7F123">MILK - PRODUCTION, MEASURED IN LB (1924-2017)</a></li>
        </ul>
      </em>
    </small>
  </figcaption>
{% endcapture %}

<figure class="google-chart-xs">
  <iframe width="215" height="445" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vSSJYhi-sgAOJLG__tPV1KEBkKJJtJEg48DoZXB8LcN2scBSx_WKbX5QKM2zeJLW1LK2iyAKiWorsvn/pubchart?oid=1921257666&amp;format=interactive"></iframe>
  {{ cows_vs_production_caption }}
</figure>

<figure class="google-chart-sm">
  <iframe width="258" height="445" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vSSJYhi-sgAOJLG__tPV1KEBkKJJtJEg48DoZXB8LcN2scBSx_WKbX5QKM2zeJLW1LK2iyAKiWorsvn/pubchart?oid=892985456&amp;format=interactive"></iframe>
  {{ cows_vs_production_caption }}
</figure>

<figure class="google-chart-md">
  <iframe width="518" height="321" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vSSJYhi-sgAOJLG__tPV1KEBkKJJtJEg48DoZXB8LcN2scBSx_WKbX5QKM2zeJLW1LK2iyAKiWorsvn/pubchart?oid=1319655728&amp;format=interactive"></iframe>
  {{ cows_vs_production_caption }}
</figure>

<figure class="google-chart-lg">
  <iframe width="687.5" height="425.1041666666667" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vSSJYhi-sgAOJLG__tPV1KEBkKJJtJEg48DoZXB8LcN2scBSx_WKbX5QKM2zeJLW1LK2iyAKiWorsvn/pubchart?oid=126435417&amp;format=interactive"></iframe>
  {{ cows_vs_production_caption }}
</figure>

While the overall number of cows have decreased a bit, the number of *herds* of cows, i.e. the number of farming operations, have decreased **dramatically** (and continues to do so - the latest count on the rate of change is [two dairy farms per day closing](https://hoards.com/article-23968-wisconsin-losing-almost-two-dairies-per-day.html)):

{% capture cows_vs_herds_caption %}
  <figcaption>
    <small>
      <em>
        Source: <a href="https://quickstats.nass.usda.gov/">USDA Quick Stats</a>
        <ul>
          <li><a href="https://quickstats.nass.usda.gov/results/7BAA35F6-E43C-3C3D-8CC3-503DCDBABB91">CATTLE, COWS, MILK - INVENTORY (1867-2018)</a></li>
          <li><a href="https://quickstats.nass.usda.gov/results/8E0A45DF-14CE-3A05-BCFB-330A431562F7">CATTLE, COWS, MILK, LICENSED HERD - OPERATIONS WITH INVENTORY, AVG (2003-2017)</a></li>
          <li><a href="https://quickstats.nass.usda.gov/results/EF543C3E-3A98-38AB-8A21-6866C0C67B5E">CATTLE, COWS, MILK - OPERATIONS WITH INVENTORY (1965-2007)</a></li>
        </ul>
      </em>
    </small>
  </figcaption>
{% endcapture %}

<figure class="google-chart-xs">
  <iframe width="213" height="384" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vSSJYhi-sgAOJLG__tPV1KEBkKJJtJEg48DoZXB8LcN2scBSx_WKbX5QKM2zeJLW1LK2iyAKiWorsvn/pubchart?oid=1570145872&amp;format=interactive"></iframe>
  {{ cows_vs_herds_caption }}
</figure>

<figure class="google-chart-sm">
  <iframe width="268" height="383" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vSSJYhi-sgAOJLG__tPV1KEBkKJJtJEg48DoZXB8LcN2scBSx_WKbX5QKM2zeJLW1LK2iyAKiWorsvn/pubchart?oid=328395745&amp;format=interactive"></iframe>
  {{ cows_vs_herds_caption }}
</figure>

<figure class="google-chart-md">
  <iframe width="518" height="320" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vSSJYhi-sgAOJLG__tPV1KEBkKJJtJEg48DoZXB8LcN2scBSx_WKbX5QKM2zeJLW1LK2iyAKiWorsvn/pubchart?oid=557559046&amp;format=interactive"></iframe>
  {{ cows_vs_herds_caption }}
</figure>

<figure class="google-chart-lg">
  <iframe width="687.5" height="425.1041666666667" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vSSJYhi-sgAOJLG__tPV1KEBkKJJtJEg48DoZXB8LcN2scBSx_WKbX5QKM2zeJLW1LK2iyAKiWorsvn/pubchart?oid=692393765&amp;format=interactive"></iframe>
  {{ cows_vs_herds_caption }}
</figure>

What this means is that the average number of cows on a given dairy operation has greatly risen, i.e. dairy farms have become much denser in terms of livestock. Looking at government statistics on dairy farm profitability, the reason this is happening (and the reason the trend will only continue) seems to be obvious - only farms with thousands of cows, that can use their size to cut costs, are able to operate [in the black](https://en.wiktionary.org/wiki/in_the_black):

{% capture net_value_by_operation_caption %}
  <figcaption>
    <p><em>The only dairy farms that have been able to turn a profit (net value above zero) since the USDA began collecting statistics on dairy production in 2010 are the very largest.</em></p>
    <p>
      <small>
        <em>Source: <a href="https://www.ers.usda.gov/data-products/milk-cost-of-production-estimates/">USDA Milk Cost of Production Estimates</a>, "Milk cost of production by size of operation"</em>
      </small>
    </p>
  </figcaption>
{% endcapture %}

<figure class="google-chart-xs">
  <iframe width="207" height="617.5" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vSSJYhi-sgAOJLG__tPV1KEBkKJJtJEg48DoZXB8LcN2scBSx_WKbX5QKM2zeJLW1LK2iyAKiWorsvn/pubchart?oid=966735344&amp;format=interactive"></iframe>
  {{ net_value_by_operation_caption }}
</figure>

<figure class="google-chart-sm">
  <iframe width="260" height="507" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vSSJYhi-sgAOJLG__tPV1KEBkKJJtJEg48DoZXB8LcN2scBSx_WKbX5QKM2zeJLW1LK2iyAKiWorsvn/pubchart?oid=1527273449&amp;format=interactive"></iframe>
  {{ net_value_by_operation_caption }}
</figure>

<figure class="google-chart-md">
  <iframe width="523" height="323" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vSSJYhi-sgAOJLG__tPV1KEBkKJJtJEg48DoZXB8LcN2scBSx_WKbX5QKM2zeJLW1LK2iyAKiWorsvn/pubchart?oid=1728392211&amp;format=interactive"></iframe>
  {{ net_value_by_operation_caption }}
</figure>

<figure class="google-chart-lg">
  <iframe width="687.5" height="425.1041666666667" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vSSJYhi-sgAOJLG__tPV1KEBkKJJtJEg48DoZXB8LcN2scBSx_WKbX5QKM2zeJLW1LK2iyAKiWorsvn/pubchart?oid=1972740286&amp;format=interactive"></iframe>
  {{ net_value_by_operation_caption }}
</figure>

These changes have given rise to a whole new type of livestock farm: the [Concentrated Animal Feeding Operation](https://en.wikipedia.org/wiki/Concentrated_animal_feeding_operation), or CAFO.

CAFOs are [defined by the EPA](https://www.nrcs.usda.gov/wps/portal/nrcs/main/national/plantsanimals/livestock/afo/) as "an AFO [Animal Feeding Operation] with more than 1000 animal units" (which for dairy, is 700 dairy cows, either milking or dry) **or** "any size AFO that discharges manure or wastewater into a natural or man-made ditch, stream or other waterway."

<figure>
  {% asset 'on-the-death-of-my-familys-dairy-farm/cafo-cows.jpg'
    srcset:width=640
    srcset:width=960
    srcset:width=1440
    sizes="(max-width: 320px) 640px,
          (max-width: 480px) 960px,
          1440px"
    width="100%"
  %}
  <figcaption>
    <em>Cows on a CAFO operation. Public domain image <a href="https://picryl.com/media/412_dsp_agriculture_125-e960cc">courtesy Danny Hart / PICRYL</a>.</em>
  </figcaption>
</figure>

In Wisconsin, the number of dairy CAFOs and the total number of cows on these operations continues to rise rapidly:

{% capture wisconsin_cafo_caption %}
  <figcaption>
    <p>
      <small>
        <em>Source: <a href="https://dnr.wi.gov/topic/AgBusiness/data/CAFO/">Wisconsin DNR CAFO Permittees</a></em>
      </small>
    </p>
    <p>
      <small>
        <em>Note: These numbers only cover the latest CAFO permit issued to each operation. I have a FOIA request in progress with the WI DNR to get the historical permit data in order to improve this chart's accuracy.</em>
      </small>
    </p>
  </figcaption>
{% endcapture %}

<figure class="google-chart-xs">
  <iframe width="219" height="398" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vQHVfMjApdFVlGaRgKY5hjKdI9T3H-tNKakPSGvPQgsu-7DIzk60h56Lds2X2Vc69OR46QM-BT7RqGH/pubchart?oid=1954327728&amp;format=interactive"></iframe>
  {{ wisconsin_cafo_caption }}
</figure>

<figure class="google-chart-sm">
  <iframe width="257" height="398" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vQHVfMjApdFVlGaRgKY5hjKdI9T3H-tNKakPSGvPQgsu-7DIzk60h56Lds2X2Vc69OR46QM-BT7RqGH/pubchart?oid=158188559&amp;format=interactive"></iframe>
  {{ wisconsin_cafo_caption }}
</figure>

<figure class="google-chart-md">
  <iframe width="522.4712522206468" height="323" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vQHVfMjApdFVlGaRgKY5hjKdI9T3H-tNKakPSGvPQgsu-7DIzk60h56Lds2X2Vc69OR46QM-BT7RqGH/pubchart?oid=622794509&amp;format=interactive"></iframe>
  {{ wisconsin_cafo_caption }}
</figure>

<figure class="google-chart-lg">
  <iframe width="646.4028776978417" height="399.6666666666667" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vQHVfMjApdFVlGaRgKY5hjKdI9T3H-tNKakPSGvPQgsu-7DIzk60h56Lds2X2Vc69OR46QM-BT7RqGH/pubchart?oid=1743810319&amp;format=interactive"></iframe>
  {{ wisconsin_cafo_caption }}
</figure>

The concentration of livestock on small plots of land and the large-scale industrialization of these farming operations have given rise to new negative externalities.

CAFO livestock produce literal [manure lagoons](https://en.wikipedia.org/wiki/Anaerobic_lagoon). There is so much manure produced that a huge pit must be dug, fitted with a liner, and the manure is dumped in, forming an artificial lake made of animal waste.

<figure>
  {% asset 'on-the-death-of-my-familys-dairy-farm/manure-lagoon.jpg'
    srcset:width=640
    srcset:width=960
    srcset:width=1440
    sizes="(max-width: 320px) 640px,
          (max-width: 480px) 960px,
          1440px"
    width="100%"
  %}
  <figcaption>
    <em>A typical manure lagoon. Public domain image <a href="https://commons.wikimedia.org/wiki/File:NRCSNC00011_-_North_Carolina_(5131)(NRCS_Photo_Gallery).jpg">courtesy USDA NRCS</a>.</em>
  </figcaption>
</figure>

These manure lagoons are open-air, and [the toxic fumes elevate rates of asthma in children living nearby](https://en.wikipedia.org/wiki/Anaerobic_lagoon#Environmental_and_health_impacts). The liquid itself contains toxic chemicals, pathogens, and bacteria, and if it leaks out (say during heavy rainfall), is devastating to nearby communities as it contaminates the local water table, where people draw their well water from, and destroys local bodies of water where wildlife live and people recreate.

Due to the number of cows on these operations, [high capacity wells that draw over 100,000 gallons of water per day](https://dnr.wi.gov/topic/Wells/HighCap/) are required in order to draw enough water for all the livestock.

In rural Wisconsin, our natural water supply is beginning to be destroyed through a combination of manure and fertilizer spills contaminating our well water, and high capacity wells sucking out so much water that it's disrupting the water table.

According to a [pretty damning 2010 CDC report on CAFOs](https://www.cdc.gov/nceh/ehs/Docs/Understanding_CAFOs_NALBOH.pdf) that is worth reading in its entirety,

> The agriculture sector, including CAFOs, is the leading contributor of pollutants to lakes, rivers, and reservoirs. It has been found that states with high concentrations of CAFOs experience on average 20 to 30 serious water quality problems per year as a result of manure management problems (EPA, 2001).

The report goes on to describe the long-term damage from even a single manure spill:

> When groundwater is contaminated by pathogenic organisms, a serious threat to drinking water can occur. Pathogens survive longer in groundwater than surface water due to lower temperatures and protection from the sun.
>
> ...
>
> Even if the contamination appears to be a single episode, viruses could become attached to sediment near groundwater and continue to leach slowly into groundwater. One pollution event by a CAFO could become a lingering source of viral contamination for groundwater (EPA, 2005).
>
> ...
>
> Groundwater can still be at risk for contamination after a CAFO has closed and its lagoons are empty. When given increased air exposure, ammonia in soil transforms into nitrates. Nitrates are highly mobile in soil, and will reach groundwater quicker than ammonia. It can be dangerous to ignore contaminated soil.
>
> ...
> 
> If a CAFO has contaminated a water system, community members should be concerned about nitrates and nitrate poisoning. Elevated nitrates in drinking water can be especially harmful to infants, leading to blue baby syndrome and possible death.

For some real-world examples, in Wisconsin in 2017 a [baby died from blue baby syndrome](http://www.startribune.com/baby-s-death-sparks-water-safety-fight-with-the-ag-industry/502477031/), a condition linked to high nitrates, in a community in Armenia, WI which had been experiencing a spike in private well nitrate levels after a 6,000-head dairy CAFO set up shop there. In the central sands region of Wisconsin, rivers such as the Little Plover, which was a notably good trout stream, have nearly dried up entirely [from the substantial use of high capacity wells](https://www.wpr.org/answers-water-management-central-sands-region-arent-simple).

In Kewaunee County in northeast Wisconsin, [more than one-third (!) of 320 wells tested](https://madison.com/ct/news/local/environment/bacteria-in-state-s-drinking-water-is-public-health-crisis/article_dd9b5d97-084b-5337-a664-37b9a6b36d30.html) were found to be unsafe to use due to unsafe levels of coliform bacteria or nitrates. In 2004 in that region, a six-month-old became violently ill after taking a bath in water poisoned by manure runoff. A state representative called the situation there a ["public health crisis."](http://legis.wisconsin.gov/senate/democrats/news/2015-press-releases/groundwater-protection-bill/)

<figure>
  {% include youtube url="https://www.youtube.com/embed/ug31xUsCHcw" %}
  <figcaption>
    <em>A shower in rural Kewaunee County runs brown, contaminated by manure after a rainfall. Courtesy Erika and Rob Balza.</em>
  </figcaption>
</figure>

In 2014 in Juneau County, a man was [forced to sell](https://madison.com/wsj/news/local/environment/manure-spraying-under-scrutiny/article_66a5b80b-b8c8-5daf-92ec-3d24585f35ea.html) the home he had lived in for 20 years after a CAFO began repurposing water irrigation systems to spray manure, and the liquid soaked into the walls of his home ("It was an ammonia smell. It hurt so bad even to breathe," he said).

<figure>
  {% asset 'on-the-death-of-my-familys-dairy-farm/irrigator-spraying-manure.jpg'
    srcset:width=640
    srcset:width=960
    srcset:width=1440
    sizes="(max-width: 320px) 640px,
          (max-width: 480px) 960px,
          1440px"
    width="100%"
  %}
  <figcaption>
    <em>An irrigation system is repurposed to spray manure on a Wisconsin field. Public domain image <a href="https://madison.com/wsj/news/local/environment/manure-spraying-under-scrutiny/article_66a5b80b-b8c8-5daf-92ec-3d24585f35ea.html">courtesy Wisconsin DNR</a></em>
  </figcaption>
</figure>


<!--
Seeing manure being aerosolized and shot great distances worries me about potential long-range

https://www.cdc.gov/nceh/ehs/Docs/Understanding_CAFOs_NALBOH.pdf



https://web.archive.org/web/20180809130833/https://co.ashland.wi.us/vertical/sites/%7B215E4EAC-21AA-4D0B-8377-85A847C0D0ED%7D/uploads/Manure_Irrigation_Rules_and_Regs_Baeten_Mar_2016.pdf


Looking at an irrigator aerosolizing 


that could happen, given how far aerosols can travel - outbreaks of Legionnaires' disease, for example, [have been tracked to dispersions of water vapor 6km](https://www.patientcareonline.com/articles/clinical-citations-legionnaires-disease-how-far-can-contaminated-aerosols-travel) from nuclear cooling towers.

Worse yet, the next step many CAFOs take is to use irrigation systems that would typically be used for water, to spray the liquid manure on the fields. This aerosolized cow manure with the previously-mentioned toxic chemicals and pathogens is then free to blow in the wind to nearby properties. One resident of Junea County, Scott Murray, [was forced to move after "](https://madison.com/wsj/news/local/environment/manure-spraying-under-scrutiny/article_66a5b80b-b8c8-5daf-92ec-3d24585f35ea.html)
-->

Besides environmental externalities, it's also an open secret that these CAFOs heavily rely on undocumented immigrants for their day-to-day labor, particularly the parlor milking setups. In a recent news story, [Congressman Devin Nunes's family's large dairy farm in Iowa got busted](https://www.esquire.com/news-politics/a23471864/devin-nunes-family-farm-iowa-california/) for such practices.

<figure>
  {% asset 'on-the-death-of-my-familys-dairy-farm/cafo-spanish-ad.png'
    srcset:width=640
    srcset:width=960
    srcset:width=1440
    sizes="(max-width: 320px) 640px,
          (max-width: 480px) 960px,
          1440px"
    width="100%"
  %}
  <figcaption>
    <em>A dairy CAFO located in a tiny Wisconsin village pins <a href="https://web.archive.org/web/20190215191027/https://www.facebook.com/BandDDairy/photos/a.2093550150919217/2093548550919377/?type=3&permPage=1">an ad for workers written in Spanish</a> to their Facebook page. There's no ad in English 🤔</em>
  </figcaption>
</figure>

That's not a dig towards the immigrants - I married a Mexican woman and I love my inlaws and their culture dearly.

However, it's important to remember that farms are in competition with each other for labor, land, and other resources. In this case, my brother and other family farms struggle and pay dearly to hire and retain legal workers at a high cost. Other farms, particularly the large ones, pay lower costs for illegal labor and externalize the costs of depressed wages onto everyone else, not unlike externalizing the costs of their pollution. It's not a fair playing field to compete on.

## Our CAFO neighbor

Just a mile down the road from my family's farm is the largest CAFO in our county, with [over 5,000 head of cattle](https://dnr.wi.gov/topic/AgBusiness/data/CAFO/cafo_det.asp?CountyChoice=Barron&Submit=Submit&PERMIT_NO=64397).

This CAFO has received [four Safe Drinking Water Act (SDWA) violations]({% asset 'epa_violation_report.csv' @path %}) from the EPA, two of which are due to coliform bacteria counts, as well as [one Clean Waters Act (CWA) violation](https://echo.epa.gov/detailed-facility-report?fid=110040433395) for discharging into a wetland.

Those are the federally-documented violations, anyway. My mom took some video of a leak about a month after the EPA-documented CWA violation which traveled down the hill into a creek that runs through my parents' property, killing the wildlife there for God knows how long:

<div class="video-container">
  <video autoplay loop muted class="responsive">
    <source src="{% asset 'on-the-death-of-my-familys-dairy-farm/norswiss-discharge.mp4' @path %}" type="video/mp4" />
  </video>
</div>

This CAFO is now going through the process of installing a manure pipeline to move waste around to various fields - so far through private lands, but apparently they are also pursuing public right-of-ways.

It's terrifying to consider how rapidly and how severely the water table and nearby wetlands could be damaged if this pipeline were to burst or leak, and how much manure could be pumped out below the topsoil before being detected.

So I spoke to the county's conservation officer who had nothing but good things to say about the pipeline and how it will get tanker trucks off the roads, how a pipeline is safer for the environment, and how leaks would be stopped by shutoff valves. That may be true, but yet you can easily find news reports of manure pipeline leaks. When I asked my mom her thoughts, she told me there was allegedly a pipeline break already which sprayed manure across a neighbor's yard and house, and showed me some pictures she took of the cleanup.

<figure>
  {% asset 'on-the-death-of-my-familys-dairy-farm/pipeline-break-cleanup.jpg'
    srcset:width=640
    srcset:width=960
    srcset:width=1440
    sizes="(max-width: 320px) 640px,
          (max-width: 480px) 960px,
          1440px"
    width="100%"
  %}
  <figcaption>
    <em>A skid steer cleans up an alleged manure spill at a neighbor's house. Picture courtesy my mom.</em>
  </figcaption>
</figure>

For my brother Noah, who is taking over the farm, having the county's biggest CAFO nearby unfortunately puts a competetive strain on his already-difficult situation. Because [Wisconsin Pollutant Discharge Elimination System (WPDES) permit requirements](https://dnr.wi.gov/topic/AgBusiness/documents/LargeDairyCAFOGP-WPDESPermit.pdf) require these CAFOs to own or rent enough land to spread manure on proportional to the amount of cows they have, this multi-million dollar corporation down the road is under land-pressure, and gobbles up all farming land in the area often before it's even on the market. This makes it harder for my brother to find farmland to buy or rent nearby.


<!--
Informal Enforcement Action - Notice of Violation - 09/11/2017

https://iaspub.epa.gov/enviro/ICIS_DETAIL_REPORTS_NPDESID.icis_tst?npdesid=WI0059340&npvalue=1&npvalue=13&npvalue=14&npvalue=3&npvalue=4&npvalue=5&npvalue=6&rvalue=13&npvalue=2&npvalue=7&npvalue=8&npvalue=11&npvalue=12

4 water system violations:

https://ofmpub.epa.gov/apex/sfdw/f?p=108:11:::NO:11,RIR:IREQ_PWSID:WI6030024

https://echo.epa.gov/detailed-facility-report?fid=110050575436

https://oaspub.epa.gov/enviro/fii_query_dtl.disp_program_facility?p_registry_id=110040433395

https://echo.epa.gov/detailed-facility-report?fid=110040433395


NPDES ID WI0059340

https://echo.epa.gov/trends/loading-tool/reports/dmr-pollutant-loading?year=2019&permit_id=WI0059340


http://wtnnews.com/articles/524/

> These agencies have identified animal feeding operations as the greatest contributors to the problem of excess mineral pollutants in water runoff, the most significant remaining source of water pollution.


https://dnr.wi.gov/topic/AgBusiness/CAFO/StatsMap.html

https://www.sierraclub.org/sites/www.sierraclub.org/files/sce-authors/u2196/CAFO%20White%20Paper%20final.pdf


https://docs.google.com/spreadsheets/d/1vqzLw2iKf2QvZG4QwspwcMb53Q-hiyoom0QLLG3aKe4/edit?usp=sharing

-->

## Failure of the cooperatives

One last thing I'd like to touch on is the failure of the farmer cooperatives in this era.

It's probably well-known that there have been periods where farmers have went through tough times, and going back to at least the 1920s, farmers have formed voluntary cooperatives (co-ops) to help one another out by pooling resources.

Check out this quaint 1940s-era video for an explainer:

{% include youtube url="https://www.youtube.com/embed/gLVqXrATB5w" width="420" height="315" %}

Unfortunately, the modern reality is that through repeated mergers, farming cooperatives have conglomerated into corporate behemoths. The co-op's presence in a farming community today is as a local outpost that belongs to a sprawling empire.

For example, in my family's farm area the co-op conglomerate is Cenex, a.k.a. [CHS Inc.](https://en.wikipedia.org/wiki/CHS_Inc.), which is a Fortune 100 company (!). And they're not the only Fortune 100 farmer co-op either - there was once [Farmland Industries](https://en.wikipedia.org/wiki/Farmland_Industries), which imploded from the kind of financial stupidity that can only happen when you grow too large.

Anyway, for all the mergers and supposed efficiency gained by the local cooperative turning into a corporate dragon, my brother gets cheaper seeds by buying them from one dude starting up his own business out of the back of his truck, compared to the local co-op's prices.

I've been told other services provided by the co-op suffer from massive inefficiencies as well - too many managers and idle workers at the headquarters, too many trucks show up concurrently at job sites leading to idle workers, inefficient truck routes, etc. The types of issues that crop up when there aren't any farmers in the mix at the co-op any more - there's no "skin in the game," and no connection to the farmers being served.

The same kind of stuff happens with the cooperative creameries - the place where dairy farmers send their milk to be processed. You wouldn't know there was a crisis going on looking at this creamery's newsletter, with puff pieces about [cheese curds showing up on the QVC channel](https://www.ellsworthcheese.com/wp-content/uploads/2018/12/ECC-Patron-Newsletter-11-18-2-compressed.pdf), or about [a director's jetsetting trips to China](https://www.ellsworthcheese.com/wp-content/uploads/2018/08/ECC-Patron-Newsletter-05-18.compressed.pdf) and how impressed the locals were he could use chopsticks. This same creamery cooperative's board allegedly bought another creamery to the tune of $6M without giving member farmers (patrons) a vote on it nor mentioning the intention at their annual meeting.

<figure>
  {% asset 'on-the-death-of-my-familys-dairy-farm/ellsworth-newsletter.png'
    srcset:width=640
    srcset:width=960
    srcset:width=1440
    sizes="(max-width: 320px) 640px,
          (max-width: 480px) 960px,
          1440px"
    width="100%"
  %}
  <figcaption>
    <em>An Ellsworth Cooperative Creamery director visited China while their patrons go bust. Source: <a href="https://www.ellsworthcheese.com/wp-content/uploads/2018/08/ECC-Patron-Newsletter-05-18.compressed.pdf">Ellsworth Cooperative Creamery newsletter, May 2018</a></em>
  </figcaption>
</figure>

Farmers are generally scared to speak up about this kind of stuff for fear of getting dumped by their creamery and having nowhere to send their milk (because creameries serve limited geographic areas, a farmer may have very few - perhaps even just one - options for where to send their milk). With the overabundance of milk supply, the feeling is that creameries are on the lookout for ways to lower their supply burden by getting rid of patrons.[^patron-loss] Not being able to sell their milk is obviously a death knell for a dairy farmer.

[^patron-loss]:
    Creameries sometimes drop a bunch of patrons instead of cutting rates across the board for everyone. In 2017 Grassland made headlines [when they dumped 75 patrons](https://www.farmprogress.com/dairy/grassland-dairys-actions-wakeup-call-farmers) at once. Right around this past Christmas, one creamery [even dropped their Amish farmers](https://www.jsonline.com/story/money/2018/12/21/amish-dairy-farmers-risk-losing-their-living/2378827002/) after entering into an agreement with another creamery - something one would think a creamery would do to benefit their patrons.

<!--
<iframe src="https://www.facebook.com/plugins/post.php?href=https%3A%2F%2Fwww.facebook.com%2FGrasslandDairyProducts%2Fposts%2F1949161728496934&width=500" width="500" height="291" style="border:none;overflow:hidden" scrolling="no" frameborder="0" allowTransparency="true" allow="encrypted-media"></iframe>
-->

<!--
"Recently our cooperative, having gained large quantities of milk due to their BST-free policy, reversed the policy. There was no knowledge of reversal consideration, no opportunity for membership input, no vote, no voice. This is common practice in cooperatives, mergers have transpired in this manner."
-->

Point being, farmer cooperatives were once local institutions bootstrapped by the farmers themselves, but now they too have fallen into the trap of corporate consolidation and become disconnected from the people they were meant to serve. Now, in hard times, these institutions have become a source of anxiety - at best an indifferent, inefficient use of resources, and at worst a potential hostile actor that could destroy you. Something unthinkable compared to their founding principles.

## No solution in sight

What's now happening in the final stages to the American family dairy farm has already happened to other food and livestock industries in this country.[^ilsr-podcast] Notably poultry, as poultry farmers nowadays [are more or less serfs](https://www.theguardian.com/sustainable-business/2017/apr/22/chicken-farmers-big-poultry-rules) to a handful of huge corporations.

[^ilsr-podcast]:
    There's an [excellent ILSR podcast](https://ilsr.org/food-industry-concentration-blp-episode-65/
    ) that goes into the consolidation that's happened to various industries across the entire food economy that I recommend listening to.

<div class="row-full">
  <div class="foo-center">
    <div style="width: 150vh;">
    {% asset 'on-the-death-of-my-familys-dairy-farm/farm-sunset.jpg'
      srcset:width=640
      srcset:width=960
      srcset:width=1440
      sizes="(max-width: 320px) 640px,
            (max-width: 480px) 960px,
            1440px"
      width="100%"
      alt="Sunset harvest on the farm"
    %}
    </div>
  </div>
</div>

<div class="foo-center">
  <p>
    <em>Sunset harvest on the farm</em>
  </p>
</div>

For a time some thought it would be possible for small dairy farms to escape to a niche like organic, but [even those farms are going bust](https://www.washingtonpost.com/outlook/dairy-farming-is-dying-after-40-years-im-out/2018/12/21/79cd63e4-0314-11e9-b6a9-0aa5c2fcc9e4_story.html?utm_term=.c1bc6568672b) as the large corporate farms have penetrated that market and flooded it with product (even if [they probably aren't following](https://www.washingtonpost.com/business/economy/why-your-organic-milk-may-not-be-organic/2017/05/01/708ce5bc-ed76-11e6-9662-6eedf1627882_story.html?utm_term=.cd7861a9a8a2) the already-lax USDA regulations).

I do think it may have been possible to save the family dairy farm at some point, probably through a supply management program similar to [what Canada has](https://en.wikipedia.org/wiki/Supply_management_(Canada)). There are all sorts of arguments to be made for or against such a system but by all accounts [Canadian farmers and consumers are generally happy](https://www.theguardian.com/world/commentisfree/2018/jun/09/milk-canada-us-trade-war) with their setup up there. The 2014 Farm Bill would've been a good start; it included an oversupply management mechanism, but [CAFO lobbyist groups like the Dairy Business Association](https://www.dairyforward.com/page/PolicySuccesses) pushed a last-minute amendment to remove it.

But at this point for America, the cow is out of the barn so to speak and it's too late for our family dairy farmers. As dairy farms [continue to close at record levels](https://www.wpr.org/wisconsin-pace-hit-highest-loss-dairy-farms-4-years), the consolidation into large corporate farms will continue unabated.

For a taste of what the near future looks like, [Wal-Mart already began bottling their own milk](https://www.milkbusiness.com/article/walmart-opens-indiana-milk-plant), shutting down over 100 dairy producers in the process. As for the distant future, I imagine it will look similar to the consolidation in other livestock industries, where a handful of mega corporations dictate production and the "farmers" are more like serfs, deeply in debt and entirely beholden to the corporation. I already mentioned poultry farming, but also look at hog farming: the [largest hog producer](https://www.agriculture.com/livestock/pork-powerhouses/pork-powerhouses-2018-ramping-up) in the country, Smithfield Foods, is [now owned by a Chinese corporation](https://www.usatoday.com/story/money/business/2013/05/29/smithfield-foods-china-acquisition/2368671/), and which is responsible for [staggering amounts of damage](https://www.rollingstone.com/politics/politics-news/why-is-china-treating-north-carolina-like-the-developing-world-122892/) to rural American communities due to the concentrated waste it produces.

In the name of efficiency, profits will be concentrated in fewer and fewer hands while waste gets concentrated into more and more toxic forms to be dumped on rural communities.

## Final thoughts

Growing up on a dairy farm is a very unique experience that I was fortunate to have. The farm was woven through all aspects of our family's life, and the success of our family depended on everyone's contribution to the farm. Family bonds were tempered by working with each other every day, and together overcoming the minor crises that arose (cows getting out, equipment breaking down, etc.). That's why I used "death" in this article's title; while it may seem melodramatic to some, that is what it feels like to me - like a piece of the family is dying.

<figure>
  {% asset 'on-the-death-of-my-familys-dairy-farm/john-fertilizer.jpg'
    srcset:width=640
    srcset:width=960
    srcset:width=1440
    sizes="(max-width: 320px) 640px,
          (max-width: 480px) 960px,
          1440px"
    width="100%"
  %}
  <figcaption>
    <em>Brother John coming back from spreading fertilizer, holding his daughter</em>
  </figcaption>
</figure>

You get a little taste of many things working on a farm, from agricultural, to construction (e.g. building and fixing up areas of the barn), to engineering (e.g. designing ad-hoc fixes to broken implements in the field), to mechanical and engine repair (e.g. fixing tractors and welding implements).

It saddens me that my brother Noah won't be able to pass that legacy on to his daughter, and I can't give my own kids a glimmer of it by having them work on the farm over the summers (and neither can my nieces or nephews).

<figure>
  {% asset 'on-the-death-of-my-familys-dairy-farm/noah-family.jpg'
    srcset:width=640
    srcset:width=960
    srcset:width=1440
    sizes="(max-width: 320px) 640px,
          (max-width: 480px) 960px,
          1440px"
    width="100%"
  %}
  <figcaption>
    <em>My kid brother Noah's family</em>
  </figcaption>
</figure>

It's also a loss for Wisconsin's culture - "America's Dairyland" - that we aren't going to have farm kids coming up any more,[^joe-rogan] and our rural pastoral landscape that was dotted with barns, silos, and pastures with grazing cattle is being replaced by an industrial one with huge buildings, heavy machine traffic, and artificial lakes made of animal waste. Those of us who grew up in these rural areas and moved out but longed to return can't even bear to do so any longer because the land has been blighted.[^message-board]

[^joe-rogan]:
    Comedian Joe Rogan said on [one of his podcasts](https://youtu.be/TLZgdmGN2JQ) that meeting another comic anywhere in the world, even cross-culturally, gives him a strong, instant connection to that person. I've personally found a similar thing to be true when meeting other people who grew up on family farms.

[^message-board]:
    I exchanged comments with an internet stranger on a programming-oriented messaging board who also happened to be a Wisconsinite who wanted to return to their rural area, but shared my strong apprehensions after the materialization of a CAFO.

<figure>
  {% asset 'on-the-death-of-my-familys-dairy-farm/cousins-eggs.jpg'
    srcset:width=640
    srcset:width=960
    srcset:width=1440
    sizes="(max-width: 320px) 640px,
          (max-width: 480px) 960px,
          1440px"
    width="100%"
  %}
  <figcaption>
    <em>Cousins gathering eggs from my parents' chicken coop</em>
  </figcaption>
</figure>

While the future is still uncertain for my kid brother Noah, I have no doubt he will succeed at whatever he puts his mind to. He's got brains, talent, and a god-tier work ethic.

If there's anything good to come of the situation, I am glad at least that he'll be freed from the burden of having cows, which require one to be out in the barn every single day without end. It will also be a relief to my dad, who I mentioned earlier is now in his seventies and still has to work out in the barn every day because of the difficulty in hiring legal farmhands.

Whatever happens, these family bonds that were forged on the farm remain, and we will take care of each other.

<figure>
  {% asset 'on-the-death-of-my-familys-dairy-farm/noah-skid-steer.jpg'
    srcset:width=640
    srcset:width=960
    srcset:width=1440
    sizes="(max-width: 320px) 640px,
          (max-width: 480px) 960px,
          1440px"
    width="100%"
  %}
  <figcaption>
    <em>Brother Noah getting in the skid steer</em>
  </figcaption>
</figure>



<!--

It would be easy to dismiss this post as sour grapes, but there are real lessons to be learned here of system failures and death of cultural value

> I saw this farmer, and I asked him, ‘What's your hobby?’ He said, ‘Farming.’ I said, ‘What would you do if you inherited a million dollars?’ He said, ‘I'd keep on farming as long as the money lasted.’ 

Butz joke. I suspect my brother will keep farming until the money is dried up.

-->

## What you can do

As I said, I don't think there's anything on the horizon that would save family dairy farms, save for a supply management program suddenly appearing like a deus ex machina and solving the overproduction problem. I suggest lobbying your representatives for supporting such a measure in a future Farm Bill, and/or supporting family farm organizations who are fighting for that and other measures such as:

* [Family Farm Defenders](http://familyfarmers.org/)
* [National Family Farm Coalition](http://nffc.net/)
* [Wisconsin Farmers Union](https://www.wisconsinfarmersunion.com/)
* [Farm Aid](https://www.farmaid.org/take-action/)
* [National Dairy Producers Organization](https://nationaldairyproducersorganization.com/)

If you live in a rural or semi-rural area, it's critical you pay attention to what's going on in your local area. CAFOs will continue to grow and spread, and through organizations like the [Dairy Business Association](https://www.dairyforward.com/) lobby for laws giving them freer ability to pollute the air, water, and land that we all need in order to survive. I suggest proactively lobbying your city or township to pass ordinances banning polluting activities in your area and restrictions that prevent CAFOs from operating in your area (otherwise you might [end up on the defensive](https://www.greenbaypressgazette.com/story/news/local/oconto-county/2018/09/14/neighbors-sue-stop-nearly-finished-manure-pit-oconto-co/1292391002/), which is nearly impossible to win). Some organizations that defend Wisconsin's water you can support are:

* [Wisconsin Conservation Voters](https://conservationvoters.org/)
* [Midwest Environmental Advocates](http://midwestadvocates.org/)
* [Friends of the Little Plover](http://www.friendsofthelittleploverriver.org/)
* [Farms not Factories](https://mary-dougherty-h7w1.squarespace.com/)

Everyone, including cityfolk, must get educated on what is going on with our food economy, and the dangerous direction it has taken. I'm still getting educated myself so am open to suggestions, but the [Food and Environment Reporting Network](https://thefern.org/) seems to do good work here.

Finally, I also recommend everyone, but especially rural folks support the [Institute for Local Self-Reliance](https://ilsr.org/), as they work hard on several fronts (including another issue dear to my heart, improving broadband access) to empower local communities.

### Addendum

This article is based solely on my own reflection and attempts to understand the systemic changes that affected my family's dairy farm. Any mistakes I made are solely my own and do not reflect upon anyone else mentioned in the article.

I spent a lot of time writing this post but there are so many other issues that I wasn't able to even get to. For example, the startling rate of farmers committing suicide ([more than double that of veterans](https://www.theguardian.com/us-news/2017/dec/06/why-are-americas-farmers-killing-themselves-in-record-numbers)), which hit close to home when the man who visited our farm my entire life in his familiar white truck and sold my dad farm equipment killed himself (RIP Marty); to creamery cooperative mismanagement and ineffectiveness and the farmers doing battle with their own creameries, and the general failure of the [Capper-Volstead Act](https://en.wikipedia.org/wiki/Capper%E2%80%93Volstead_Act); to the [consolidation of the farm implement industry](https://www.farm-equipment.com/articles/15963-whats-driving-consolidation-among-farm-equipment-dealers); to John Deere doing some shady things ([here](https://www.zerohedge.com/news/2017-07-18/farmers-go-broke-john-deere-ramps-its-captive-financing-operation-keep-ag-party-goin) and [here](https://motherboard.vice.com/en_us/article/kzp7ny/tractor-hacking-right-to-repair)); to statistical changes of the [price spread from farm to consumer](https://www.ers.usda.gov/data-products/price-spreads-from-farm-to-consumer/) (i.e. the amount of money farmers get from a gallon of milk or other dairy products compared to their retail cost); to digging into the nasty things CAFO lobbyists are doing; to rural communities fighting against CAFOs in their area; to Trump's tariffs and a certain political anger people direct at farmers; and so many more I regret I wasn't able to do justice to.

### Footnotes

















<!--
### What you can do

"We're required to go by the law"

https://www.greenbaypressgazette.com/story/news/local/oconto-county/2018/09/14/neighbors-sue-stop-nearly-finished-manure-pit-oconto-co/1292391002/
-->

<!--
https://uspirg.org/news/usp/new-report-highlights-how-toxic-%E2%80%9Caccidents-waiting-happen%E2%80%9D-threaten-us-waterways

https://www.epa.gov/wotus-rule/step-two-revise
-->


<!--
https://www.wpr.org/how-we-produce-more-milk-fewer-cows

https://www.newhope.com/blog/dairy-cows-produce-61-more-milk-25-years-ago

https://www.wpr.org/one-third-wisconsin-cafos-operating-under-expired-permits

https://dnr.wi.gov/topic/AgBusiness/data/CAFO/cafo_all.asp

https://madison.com/wsj/business/large-feedlot-hit-with-fine-for-manure-pollution/article_a6413723-2fc8-5569-884c-dd32015792f7.html

https://www.sierraclub.org/sites/www.sierraclub.org/files/sce-authors/u2196/CAFO%20White%20Paper%20final.pdf

https://www.wpr.org/cafos-northeastern-wisconsin-look-expand-farms-seek-permit-renewal

https://www.wehnonline.org/cafos/

https://www.dhs.wisconsin.gov/publications/p00977.pdf

https://dnr.wi.gov/topic/AgBusiness/CAFO/StatsMap.html
-->



<!--
## Some graphs

<iframe width="687.5" height="425.1041666666667" seamless frameborder="0" scrolling="no" src="https://docs.google.com/spreadsheets/d/e/2PACX-1vSSJYhi-sgAOJLG__tPV1KEBkKJJtJEg48DoZXB8LcN2scBSx_WKbX5QKM2zeJLW1LK2iyAKiWorsvn/pubchart?oid=692393765&amp;format=interactive"></iframe>
-->




<!--
American milk is a global commodity. Commodities are volatile for multiple reasons, including speculative trading, and being subject to 

[Cost of Production Outpaces All-Milk Price, Again](https://www.milkbusiness.com/article/cost-of-production-outpaces-all-milk-price-again)


https://www.ers.usda.gov/data-products/commodity-costs-and-returns/interactive-visualization-us-commodity-costs-and-returns-by-region-and-by-commodity/


[Price Spreads from Farm to Consumer](https://www.ers.usda.gov/data-products/price-spreads-from-farm-to-consumer/)

[Farm share of milk and dairy products](https://www.ers.usda.gov/data-products/price-spreads-from-farm-to-consumer/summary-findings/)
-->





<!--
[Wisconsin annual number of cows - 1867 to 2018](http://quickstats.nass.usda.gov/results/7BAA35F6-E43C-3C3D-8CC3-503DCDBABB91)

[Wisconsin annual licensed herd counts - 2003 to 2017](http://quickstats.nass.usda.gov/results/8E0A45DF-14CE-3A05-BCFB-330A431562F7)

[Wisconsin operations with inventory - 1965 to 2007](http://quickstats.nass.usda.gov/results/EF543C3E-3A98-38AB-8A21-6866C0C67B5E)

[Wisconsin annual milk production in lbs - 1924 to 2017](http://quickstats.nass.usda.gov/results/C9B07057-72F5-3430-B5B8-987D54A7F123)

[Wisconsin annual milk production measured in lb/head (cow efficiency) - 1924 to 2017](http://quickstats.nass.usda.gov/results/0F9E6099-F603-3ECB-9089-4D1005A9C9FC)


[Wisconsin annual number of cows measured by herd avg](http://quickstats.nass.usda.gov/results/B9726576-5A65-3116-B79A-2BB3F1BCD0B2)


[Milk price received 1980 to 2017](http://quickstats.nass.usda.gov/results/54B40DDA-2252-35BE-B720-546DB93F92D3)
-->



<!--
## This time is different

Family farms have been going bust in droves ever since I was a kid, and 2018 was the worst year for Wisconsin family farms in a long time. [Farm Aid](https://en.wikipedia.org/wiki/Farm_Aid), which blah blah since 1985, is receiving record numbers of calls on farmer suicide.

At this point I think it's fair to say the family dairy farm in American is in its final death throes.


Some farmers move to niches like organic: https://www.washingtonpost.com/outlook/dairy-farming-is-dying-after-40-years-im-out/2018/12/21/79cd63e4-0314-11e9-b6a9-0aa5c2fcc9e4_story.html?utm_term=.c1bc6568672b

We personally know other farmers that did the same thing with similar result. Organic farming has already been overtaken by large farms that are unlikely to be following the grazing rules. Organic crop farming can yield more profit per acre, but you get a lot less yield per acre as your crops get eaten up by pests.
-->



<!--
## Cultural malaise

Trump derangement syndrome

https://www.channel3000.com/news/-pride-doesn-t-pay-the-bills-farmer-shares-story-of-attempted-suicide-why-it-s-a-growing-problem/765567868



https://www.jsonline.com/story/money/business/2018/11/12/tony-evers-governor-have-agriculture-woes-his-plate/1947169002/

> Federal court data showed the Western District of Wisconsin had the highest number of Chapter 12 farm bankruptcies in the nation in 2017, and that's only a glimpse into the problem, since Chapter 12 is a relatively rare tool used in bankruptcies. 
> ...
> About 90 percent of Wisconsin’s milk goes into making cheese.


## "Get big or get out"

Transition to Agribusiness

["Get big or get out"](https://grist.org/article/the-butz-stops-here/)
-->



<!--
### Loss of Wisconsin culture

### Rise of the "big" - the CAFOs

Just down the road from my parents farm is a Concentrated Animal Feeding Operation (CAFO)


#### Lobbying


Wisconsin Farm Bureau Federation tries to represent all farmers but their policy handbook clearly favors CAFOs with their policy support of reduced regulation around water laws, drainage wells (large farms need high capacity wells)

https://wfbf.com/wp-content/uploads/2018/02/2018-Policy-Book_web.pdf
-->


<!--
[Milk pricing 101](https://www.adpi.org/Portals/0/Academy/Milk%20Pricing%20101.pdf)

"Class 1 prices around the US were based off of the distance from Eau Claire, WI." ???

https://www.adpi.org/Portals/0/Academy/Intel%20and%20Commentaries/Dairy%20Economics%20101.pdf
-->


<!--
[GAO Report: Information on Prices for Fluid Milk and the Factors That Influence Them](https://www.gao.gov/products/GAO/RCED-99-4)

"From January 1996 through February 1998, for the 31 fluid milk markets
that we reviewed, on average, farmers received 42 percent of the retail
price for a gallon of 2-percent milk, cooperatives received 10 percent,2
wholesalers received 31 percent, and retailers received 17 percent"



https://www.mintecglobal.com/top-stories-2018/us-milk-and-the-usmca


https://www.dairyherd.com/article/dairy-outlook-falling-leaves-slowly-climbing-milk-price



http://themccullygroup.com/wp-content/uploads/2018/11/The-McCully-Report-October-2018.pdf

http://themccullygroup.com/wp-content/uploads/2018/09/CMN-Guest-Column-Aug-24-2018.pdf

^ Wal-Mart fluid milk bottling plant in Indiana; Dean Foods terminated milk supply contracts with 100 farmers in 8 states noting Wal-Mart private label milk sales; fluid milk consumption long downward trend


https://madison.com/wsj/business/large-feedlot-hit-with-fine-for-manure-pollution/article_a6413723-2fc8-5569-884c-dd32015792f7.html
-->
