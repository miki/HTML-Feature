use strict;
use warnings;
use HTML::Feature;
use Test::More tests => 10;

#------------------------------------------------------------------------
# HTML::Feature joined several words together by mistake. 
# It has been caused in the escape of some control codes (NewLine: 0x0a).
#
#                                         reported by Haidut  2008/10/04
#------------------------------------------------------------------------

my $content;
while (<DATA>) {
    $content .= $_;
}

my $f    = HTML::Feature->new;
my $text = $f->parse( \$content )->text;

my @improper_joined_words = qw(
  ownedby
  oncnn
  andappear
  user-generatedinformation
  citizenjournnalism
  jamal
  ireportstory
  orcoverage
  andfox
  californiawildfire
);

for (@improper_joined_words) {
    my $ret = $text =~ /$_/gs;
    is($ret,'',"improper joined words test :$_ ..OK");
}

__DATA__
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns:webvar="http://www.bloomberg.com/webvar">
<head>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>
                  Bloomberg.com:
                  U.S.</title>
<meta name="KEYWORDS" content="">
<meta content="Bloomberg L.P." name="OWNER">
<meta name="ROBOTS" content="NOARCHIVE">
<meta name="DESCRIPTION" content="">
<meta http-equiv="expires" content="Mon, 30 May 2005 00:00:00 GMT">
<link media="screen" type="text/css" href="/styles/main2.css" rev="stylesheet" rel="stylesheet">
<link media="screen" type="text/css" rev="stylesheet" rel="stylesheet" href="/styles/news.css">
<script language="JavaScript" src="/jscommon/ctype.js"></script><script language="JavaScript" src="/jscommon/banner.js"></script><script language="JavaScript" src="/jscommon/dropmenu.js"></script><script language="JavaScript" src="/jscommon/header_v1.js"></script><script language="JavaScript" src="/jscommon/flsh_charts.js"></script><script language="JavaScript" src="/jscommon/flsh_nav.js"></script><script language="JavaScript" src="/jscommon/bringupPlayer.js"></script>

</head>
<body topmargin="0" leftmargin="0" marginwidth="0" marginheight="0"><!--20670103--><div id="content">
<map name="bba">
<area target="_blank" href="https://bba.bloomberg.net/" coords="25,0,189,28" alt="Bloomberg Anywhere">
<area target="_blank" href="https://software.bloomberg.com/bb/service" coords="198,0,373,24" alt="Bloomberg Professional">
<area target="_blank" href="http://about.bloomberg.com/" coords="381,0,527,29" alt="About Bloomberg">
</map>
<div id="header">
<a href="http://www.bloomberg.com/?b=0"><img align="left" border="0" alt="Bloomberg" height="51" width="250" src="http://images.bloomberg.com/r06/navigation/logo.gif"></a>
<div id="anywhere">
<img border="0" height="24" width="511" alt="Bloomberg Anywhere" src="http://images.bloomberg.com/r06/homepage/bbganywhere4.gif" usemap="#bba"></div>
</div>
<div id="updatebar">    
      <div class="updatetext">
<b>Updated:&nbsp;&nbsp;</b><b>New York</b>,
      Oct 04 21:55</div>

<div class="updatetext">
<b>London</b>,
      Oct 05 02:55</div>
<div class="updatetext">
<b>Tokyo</b>,
      Oct 05 10:55</div>
<form accept-charset="UTF-8" method="GET" onSubmit="return CheckSearchBox();" action="http://search.bloomberg.com/search" id="sitesearch" name="search">
<div style="margin: 5px 0 0 0;">
<div style="float:left;margin: 4px 0 0 0;">
<img hspace="6" border="0" height="10" width="82" alt="Search" src="http://images.bloomberg.com/r06/homepage/searchnews.gif"></div>
<div style="float:left;">
<input maxlength="256" size="32" name="q" type="text" class="grayfield"><input value="wnews" name="site" type="hidden"><input value="wnews" name="client" type="hidden"><input value="wnews" name="proxystylesheet" type="hidden"><input value="xml_no_dtd" name="output" type="hidden"><input value="UTF-8" name="ie" type="hidden"><input value="UTF-8" name="oe" type="hidden"><input value="p" name="filter" type="hidden"><input value="wnnis" name="getfields" type="hidden"><input value="date:D:S:d1" name="sort" type="hidden">
</div>
<div style="float:left;margin: 2px 0 0 4px;">
<input src="http://images.bloomberg.com/r06/navigation/btn-go.gif" value="submit" type="image" name="submit" autocomplete="off">

</div>
</div>
</form>
</div>
<div id="tickerbar">
<table width="100%" cellspacing="0" cellpadding="0" border="0">
<tr valign="top">
<td>
<form onSubmit="getResearch(); return false;" name="quotesresearch">
<table id="tickerbarform" cellspacing="0" cellpadding="0" border="0">
<tr valign="middle">
<td><a onclick="JavaScript:quotehelp();return false;" target="blank" href="/apps/data?pid=exchangelist" onmouseover="return escape(popwEnterSymbolHelp(this))"><img hspace="5" border="0" height="13" width="13" alt="" src="http://images.bloomberg.com/r06/navigation/helpquestion.gif"></a></td><td><input onClick="clearinput(1)" value="Enter Symbol" class="grayfield" id="myticker" name="myticker" size="25" autocomplete="off"></td><td><input value="quote" onClick="document.pressed=this.value" type="image" src="http://images.bloomberg.com/r06/navigation/quote_quote_btn.gif" hspace="6"></td><td><input value="charts" onClick="document.pressed=this.value" type="image" src="http://images.bloomberg.com/r06/navigation/quote_chart_btn.gif" hspace="6"></td><td><input value="news" onClick="document.pressed=this.value" type="image" src="http://images.bloomberg.com/r06/navigation/quote_news_btn.gif" hspace="6"></td><td><a href="/apps/data?pid=symsearch"><img hspace="6" border="0" height="27" width="50" alt="Symbol Lookup" src="http://images.bloomberg.com/r06/navigation/symlookup.gif"></a></td>
</tr>
</table>
</form>
</td><td>
<div id="ticker"></div>

</td>
</tr>
</table>
</div>
<script type="text/javascript">
    putNWSTick();
</script>



 
      <SCRIPT xmlns:webad="http://www.bloomberg.com/webad" xmlns:wn="http://www.bloomberg.com/bloomberg-web-news" xmlns:nav="http://www.bloomberg.com/navigation" language="JavaScript">
 Keys = "null";
 Keys += "TEC" + "&";
    
x = "x70,x60,x20";
Description = "/news/regions/us/story";

 
 
 AD_INIT(x, Keys.slice(0,-1), Description);
</SCRIPT>
<div class="graybottom leaderboard">
<SCRIPT xmlns:webad="http://www.bloomberg.com/webad" xmlns:wn="http://www.bloomberg.com/bloomberg-web-news" xmlns:nav="http://www.bloomberg.com/navigation" language="JavaScript">
 adType = "OAS";
 Category = "03";
 HCat = "x70";
 Keys = "null";
 Width = "728";
 Height = "90";
 Tile = "1";

CallAd(adType, HCat, Width, Height, Tile, Keys, Category);
</SCRIPT>
<NOSCRIPT xmlns:webad="http://www.bloomberg.com/webad" xmlns:wn="http://www.bloomberg.com/bloomberg-web-news" xmlns:nav="http://www.bloomberg.com/navigation">
<a href="http://ads.bloomberg.com/RealMedia/ads/click_nx.ads/bloomberg/news/regions/us/story/1363274@x70"><img border="0" src="http://ads.bloomberg.com/RealMedia/ads/adstream_nx.ads/bloomberg/news/regions/us/story/1363274@x70"></a>
</NOSCRIPT>

</div>
<div id="navbar">
<div id="nav">
<a onMouseout="roll_over('menu8', 'http://images.bloomberg.com/r06/navigation/home-off.gif')" onMouseover="roll_over('menu8', 'http://images.bloomberg.com/r06/navigation/home-over.gif')" href="/?b=0"><img id="menu8" name="menu8" border="0" height="28" width="70" alt="Home" src="http://images.bloomberg.com/r06/navigation/home-off.gif"></a><a onMouseout="delayhidemenu()" onMouseover="setMenu('news');dropdownmenu(this, event, menu1, '150px'); roll_over('but1', 'http://images.bloomberg.com/r06/navigation/news-over.gif')" href="/news/index.html"><img NAME="but1" border="0" height="28" width="69" alt="News" src="http://images.bloomberg.com/r06/navigation/news-on.gif"></a><a onMouseout="delayhidemenu()" onMouseover="setMenu('news');dropdownmenu(this, event, menu2, '150px'); roll_over('but2', 'http://images.bloomberg.com/r06/navigation/market-data-over.gif')" href="/markets/index.html"><img NAME="but2" border="0" height="28" width="125" alt="Market Data" src="http://images.bloomberg.com/r06/navigation/market-data-off.gif"></a><a onMouseout="delayhidemenu()" onMouseover="setMenu('news');dropdownmenu(this, event, menu3, '150px'); roll_over('but3', 'http://images.bloomberg.com/r06/navigation/investment-over.gif')" href="/invest/index.html"><img NAME="but3" border="0" height="28" width="163" alt="Investment Tools" src="http://images.bloomberg.com/r06/navigation/investment-off.gif"></a><a onMouseout="delayhidemenu()" onMouseover="setMenu('news');dropdownmenu(this, event, menu4, '150px'); roll_over('but4', 'http://images.bloomberg.com/r06/navigation/tv-radio-over.gif')" href="/tvradio/index.html"><img NAME="but4" border="0" height="28" width="113" alt="TV and Radio" src="http://images.bloomberg.com/r06/navigation/tv-radio-off.gif"></a>
</div>
<div id="log"></div>
<div id="feedback">
<a target="_blank" href="http://www.bloomberg.com/apps/fbk?x=head"><img border="0" height="15" width="74" alt="Feedback" src="http://images.bloomberg.com/r06/homepage/feedback.gif"></a>
</div>
<script language="JavaScript">
            weblogin();
        </script>
</div>
<table class="graytop graybottom" id="primarystructure" cellspacing="0" cellpadding="0" border="0" width="992">
<tr valign="top">
<td id="ps1">
<table cellspacing="0" cellpadding="0" border="0">
<tr valign="top">

<td width="154"><a href="/news/index.html"><img border="0" height="54" width="154" alt="News" src="http://images.bloomberg.com/r06/global/heading/news_hd.gif"></a>
<div id="secondarynav">
<ul class="news">
<li class="secondary">
<a HREF="/news/exclusive/">Exclusive</a>
</li>
<li class="secondary">
<a HREF="/news/worldwide/">Worldwide</a>
</li>
<li class="secondaryOpen">
<a HREF="/news/regions/africa.html">Regions</a>
</li>
<li class="tertiary">
<a HREF="/news/regions/africa.html">Africa</a>

</li>
<li class="tertiary">
<a HREF="/news/regions/asia.html">Asia</a>
</li>
<li class="tertiary">
<a HREF="/news/regions/australianewzealand.html">Australia &amp; New Zealand</a>
</li>
<li class="tertiary">
<a HREF="/news/regions/canada.html">Canada</a>
</li>
<li class="tertiary">
<a HREF="/news/regions/china.html">China</a>

</li>
<li class="tertiary">
<a HREF="/news/regions/easteurope.html">Eastern Europe</a>
</li>
<li class="tertiary">
<a HREF="/news/regions/europe.html">Europe</a>
</li>
<li class="tertiary">
<a HREF="/news/regions/france.html">France</a>
</li>
<li class="tertiary">
<a HREF="/news/regions/germany.html">Germany</a>
</li>

<li class="tertiary">
<a HREF="/news/regions/india.html">India &amp; Pakistan</a>
</li>
<li class="tertiary">
<a HREF="/news/regions/italy.html">Italy</a>
</li>
<li class="tertiary">
<a HREF="/news/regions/japan.html">Japan</a>
</li>
<li class="tertiary">
<a HREF="/news/regions/latinamerica.html">Latin America</a>

</li>
<li class="tertiary">
<a HREF="/news/regions/mideast.html">Middle East</a>
</li>
<li class="tertiary">
<a HREF="/news/regions/uk.html">U.K. &amp; Ireland</a>
</li>
<li class="tertiaryOn">
<a HREF="/news/regions/us.html">U.S.</a>
</li>
<li class="secondary">
<a HREF="/apps/news?pid=stocksonmove">Markets</a>

</li>
<li class="secondary">
<a HREF="/news/industries/index.html">Industries</a>
</li>
<li class="secondary">
<a HREF="/news/economy/">Economy</a>
</li>
<li class="secondary">
<a HREF="/news/politics/">Politics</a>
</li>
<li class="secondary">
<a HREF="/news/law/index.html">Law</a>
</li>

<li class="secondary">
<a HREF="/news/environment/">Environment</a>
</li>
<li class="secondary">
<a HREF="/news/invest.html">Invest</a>
</li>
<li class="secondary">
<a HREF="/news/science/index.html">Science</a>
</li>
<li class="secondary">
<a HREF="/news/commentary/columnists.html">Opinion</a>
</li>
<li class="secondary">

<a HREF="/news/spend/">Spend</a>
</li>
<li class="secondary">
<a HREF="/news/sports/top.html">Sports</a>
</li>
<li class="secondary">
<a HREF="/news/muse/">Arts and Culture</a>
</li>
<li class="secondary">
<a HREF="/news/av/">Editors' Video Picks</a>
</li>
<li class="secondary">
<a HREF="/news/marketsmag/">Bloomberg Markets Magazine</a>

</li>
<li class="secondary">
<a HREF="/apps/news?pid=specialreport">Special Report</a>
</li>
</ul>
<br clear="all">
<div class="graytop padbox">
<b class="resource">RESOURCES</b>
<br>
<ul>
<li class="secondary">
<a href="javascript:bringupPlayer('LiveBTV');"> Bloomberg TV</a>
</li>

<li class="secondary">
<a href="#" onclick="audioPlayer(&quot;&amp;clipName=Bloomberg%20Live%20Radio&amp;clip=radio_live&quot;)"> Bloomberg Radio</a>
</li>
<li class="secondary">
<a href="/tvradio/podcast/"> Bloomberg Podcasts</a>
</li>
<li class="secondary">
<a href="http://www.ordering1.us/bloombergbooks/index.php?sid=1&ccamp=RETAIL">Bloomberg Press</a>
</li>
</ul>
</div>
</div>

</td><td bgcolor="#464646" width="1"><img border="0" height="1" width="1" alt="" src="http://images.bloomberg.com/r06/global/odot.gif"></td><td bgcolor="#000000" VALIGN="top" width="515">
<div class="articlepage">
<br>
<div class="contentbox article"> 

  

  

    
      
    <span class="news_story_title">CNN&#39;s Citizen Journalism Goes `Awry&#39; With False Report on Jobs </span>
           <br>
<p>By James Callan</p>        
       
                  
                  
    
      <p>     Oct. 4 (Bloomberg) -- CNN&#39;s plunge into online citizen-
journalism backfired yesterday when the cable-news outlet posted
what turned out to be a bogus report claiming that Apple Inc.
Chief Executive Officer <a href="http://search.bloomberg.com/search?q=Steve+Jobs&site=wnews&client=wnews&proxystylesheet=wnews&output=xml_no_dtd&ie=UTF-8&oe=UTF-8&filter=p&getfields=wnnis&sort=date:D:S:d1" onmouseover="return escape( popwSearchNews( this ))">Steve Jobs</a> had suffered a heart attack.     </p>

       <p>Apple <a href="/apps/quote?ticker=AAPL%3AUS" onmouseover="return escape( popwQuoteShort( this, 'AAPL:US' ))">shares</a> fell as much as 5.4 percent after the post on
CNN&#39;s iReport.com and rebounded after the Cupertino, California-
based company said the story was false. Atlanta-based CNN, owned
by <a href="/apps/quote?ticker=TWX%3AUS" onmouseover="return escape( popwQuoteShort( this, 'TWX:US' ))">Time Warner Inc.</a>, disabled the user&#39;s account and said it
tried unsuccessfully to contact the individual.     </p>
       <p>The event underscores the need for news organizations to
verify content generated by users before it is published,
<a href="http://search.bloomberg.com/search?q=William+Grueskin&site=wnews&client=wnews&proxystylesheet=wnews&output=xml_no_dtd&ie=UTF-8&oe=UTF-8&filter=p&getfields=wnnis&sort=date:D:S:d1" onmouseover="return escape( popwSearchNews( this ))">William Grueskin</a>, dean of academic affairs at Columbia
University Graduate School of Journalism, said in an interview
from New York. CNN competitors Fox and MSNBC also have added
interactive features to stretch resources and follow their
audience to the Web.     </p>
       <p>``It can be a very powerful influence when harnessed the
right way, but sometimes it goes awry as it clearly did in this
case,&#39;&#39; Grueskin said. ``News organizations are really getting
squeezed and so it&#39;s incumbent on them to be looking for ways to
engage citizens in the process.&#39;&#39;     </p>

       <p>The Securities and Exchange Commission&#39;s enforcement unit
is trying to determine whether the posting was intended to push
down Apple&#39;s stock price. CNN is cooperating with the probe,
Jennifer Martin, a spokeswoman for the network, said in a
telephone interview. She declined to say whether CNN provided
the user&#39;s IP address to the SEC.     </p>
       <p>CNN describes iReport as a place for ``unedited, unfiltered
news&#39;&#39; and said it ``makes no guarantee about the content or
coverage.&#39;&#39; The site was started in August 2006 as part of
CNN.com and became a standalone Web site in February.     </p>
       <p>MSNBC.com has a citizen-journalism site, <a href="http://www.msnbc.msn.com/id/16712587/" target="_blank" onmouseover="return escape( popwOpenWebSite( this ))">FirstPerson</a>, and
Fox News.com&#39;s is called <a href="http://www.foxnews.com/studiob/ureport/" target="_blank" onmouseover="return escape( popwOpenWebSite( this ))">UReport</a>.     </p>

       <p>Stock Declines     </p>
       <p>The ability to publish unconfirmed material on the Internet
can have a far-reaching impact.     </p>
       <p>In June, Yahoo! Inc. shares surged after a technology blog
said acquisition talks with Microsoft had resumed. The report
was later contradicted by CNBC and the shares gave back most of
the 11 percent gain.     </p>
       <p>A six-year-old article on the 2002 bankruptcy of <a href="/apps/quote?ticker=UAUA%3AUS" onmouseover="return escape( popwQuoteShort( this, 'UAUA:US' ))">UAL Corp.</a>
appeared on the Web site of the South Florida Sun-Sentinel, was
picked up by a Google Inc. search agent and mistakenly presented
as a new story by a trade publication.     </p>
       <p>The Income Securities Advisors Inc. summary appeared on the
Bloomberg terminal before the item was corrected. The airline&#39;s
shares plunged as much as 76 percent before recovering most of
the loss on Sept. 9.     </p>

       <p>Extending Coverage     </p>
       <p>IReport has at times aided CNN&#39;s coverage. In the April
2007 shootings that killed 32 at Virginia Tech university, the
network used cell-phone video of police and audio of gunfire
that was posted by a graduate student, Jamal Albarghouti.     </p>
       <p>CNN has also broadcast users&#39; videos of California
wildfires and Midwest floods.     </p>
       <p>Yesterday, Apple went into freefall after the iReport post
said Jobs, 53, had a heart attack and was hospitalized.     </p>
       <p><a href="http://search.bloomberg.com/search?q=Henry+Blodget&site=wnews&client=wnews&proxystylesheet=wnews&output=xml_no_dtd&ie=UTF-8&oe=UTF-8&filter=p&getfields=wnnis&sort=date:D:S:d1" onmouseover="return escape( popwSearchNews( this ))">Henry Blodget</a>, the former Merrill Lynch &amp; Co. Internet
analyst who is now a blogger, <a href="http://normalkid.com/2008/10/03/citizen-journalism-not-a-failure-blogs-a-failure/" target="_blank" onmouseover="return escape( popwOpenWebSite( this ))">drew attention</a> to the iReport
story by posting an item on his <a href="http://siliconalleyinsider.com" target="_blank" onmouseover="return escape( popwOpenWebSite( this ))">Silicon Alley Insider</a> Web site.     </p>

       <p>In an e-mail, Blodget said he decided to write about the
report before Apple responded to his inquiry. He said the report
was already circulating in the tech community and he considered
the story ``the first significant test-case for citizen
journalism&#39;&#39; -- one that failed, he said in an updated <a href="http://www.alleyinsider.com/2008/10/apple-s-steve-jobs-rushed-to-er-after-heart-attack-says-cnn-citizen-journalist" target="_blank" onmouseover="return escape( popwOpenWebSite( this ))">blog
post</a>.     </p>
       <p>No Review     </p>
       <p>After Apple spokesman Steve Dowling said the iReport post
was ``not true,&#39;&#39; the shares recovered some. They closed down
$3.03, or 3 percent, to $97.07 in Nasdaq Stock Market <a href="/apps/quote?ticker=AAPL%3AUS" onmouseover="return escape( popwQuoteShort( this, 'AAPL:US' ))">trading</a>.     </p>

       <p>Concern about Jobs&#39;s health has weighed on Apple stock this
year, contributing to a 51 percent <a href="/apps/quote?ticker=AAPL%3AUS" onmouseover="return escape( popwQuoteShort( this, 'AAPL:US' ))">decline</a> since December. Jobs
had surgery four years ago to treat pancreatic cancer and
appeared visibly thinner at a company event in June, sparking
speculation he was ill.     </p>
       <p>CNN has no plans to review its procedures for placing
content on the iReport Web site, Martin said. User-generated
information is vetted before it is broadcast on CNN, she said.     </p>
       <p>``IReport.com is an entirely user-generated site where
content is determined by the community,&#39;&#39; Martin said. ``Based
on our terms of use that govern user behavior on iReport.com,
the fraudulent content was removed from the site and the user&#39;s
account was disabled.&#39;&#39;     </p>

       <p>Apple&#39;s CEO told members of the company&#39;s <a href="/apps/quote?ticker=AAPL%3AUS" onmouseover="return escape( popwQuoteShort( this, 'AAPL:US' ))">board</a> in July he
is cancer-free and dealing with nutritional problems after his
cancer surgery, which can lead to weight loss, the New York
Times reported, citing people close to Jobs.     </p>
       <p>In August, Bloomberg News inadvertently published a draft
of an obituary for Jobs. The item wasn&#39;t meant for publication
and was retracted.     </p>
       <p>To contact the reporter on this story:
<a href="http://search.bloomberg.com/search?q=James+Callan&site=wnews&client=wnews&proxystylesheet=wnews&output=xml_no_dtd&ie=UTF-8&oe=UTF-8&filter=p&getfields=wnnis&sort=date:D:S:d1" onmouseover="return escape( popwSearchNews( this ))">James Callan</a> in New York 

<a href="mailto:jcallan2@bloomberg.net" onmouseover="return escape( popwSendEmail( this ))">jcallan2@bloomberg.net</a>.     </p>
       
        
    
    
    <I>Last Updated: October  4, 2008  00:00 EDT</I>
<p></p>

<table width="100%" class="newstools" cellspacing="0" cellpadding="0" border="0">
<tr valign="top">
<td class="crNW"><img border="0" class="corner" height="4" width="4" alt="" src="http://images.bloomberg.com/r06/news/story_tl.gif"></td><td rowspan="2"><img border="0" height="15" width="65" alt="" src="http://images.bloomberg.com/r06/news/news-tools.gif"></td><td rowspan="2">
<table class="newslinks" cellspacing="0" cellpadding="0" border="0">
<tr valign="middle">
<td><a href="mailto:?Subject=Bloomberg%20news:%20%20CNN&#39;s Citizen Journalism Goes `Awry&#39; With False Report on Jobs &body=%20CNN&#39;s Citizen Journalism Goes `Awry&#39; With False Report on Jobs %0D%0A%0D%0A%20http%3A//www.bloomberg.com/apps/news%3Fpid%3Demail_en%26refer=us%26sid%3DatekONWyM7As"><img border="0" hspace="5" height="15" width="18" alt="" src="http://images.bloomberg.com/r06/news/email_icon.gif"></a></td><td><a class="block" href="mailto:?Subject=Bloomberg%20news:%20%20CNN&#39;s Citizen Journalism Goes `Awry&#39; With False Report on Jobs &body=%20CNN&#39;s Citizen Journalism Goes `Awry&#39; With False Report on Jobs %0D%0A%0D%0A%20http%3A//www.bloomberg.com/apps/news%3Fpid%3Demail_en%26refer=us%26sid%3DatekONWyM7As">Email this article</a></td><td><a href="#" onclick="javascript:window.open('/apps/news?pid=20670001&amp;refer=us&amp;sid=atekONWyM7As','my_new_window','scrollbars=yes,resizable=yes,width=610,height=670')"><img border="0" hspace="5" height="15" width="17" alt="" src="http://images.bloomberg.com/r06/news/print_icon.gif"></a></td><td><a class="block" href="#" onclick="javascript:window.open('/apps/news?pid=20670001&amp;refer=us&amp;sid=atekONWyM7As','my_new_window','scrollbars=yes,resizable=yes,width=610,height=670')">Printer friendly format</a></td>
</tr>

</table>
</td><td class="crNE" width="4" height="14"><img border="0" class="corner" height="4" width="4" alt="" src="http://images.bloomberg.com/r06/news/story_tr.gif"></td>
</tr>
<tr valign="bottom">
<td class="crSW"><img border="0" class="corner" height="4" width="4" alt="" src="http://images.bloomberg.com/r06/news/story_bl.gif"></td><td class="crSE"><img border="0" class="corner" height="4" width="4" alt="" src="http://images.bloomberg.com/r06/news/story_br.gif"></td>
</tr>
</table>
<div class="textad">
<SCRIPT xmlns:webad="http://www.bloomberg.com/webad" xmlns:wn="http://www.bloomberg.com/bloomberg-web-news" xmlns:nav="http://www.bloomberg.com/navigation" language="JavaScript">
 adType = "OAS";
 Category = "03";
 HCat = "x20";
 Keys = "null";
 Width = "3";
 Height = "3";
 Tile = "3";

CallAd(adType, HCat, Width, Height, Tile, Keys, Category);
</SCRIPT>
<NOSCRIPT xmlns:webad="http://www.bloomberg.com/webad" xmlns:wn="http://www.bloomberg.com/bloomberg-web-news" xmlns:nav="http://www.bloomberg.com/navigation">
<a href="http://ads.bloomberg.com/RealMedia/ads/click_nx.ads/bloomberg/news/regions/us/story/1363274@x20"><img border="0" src="http://ads.bloomberg.com/RealMedia/ads/adstream_nx.ads/bloomberg/news/regions/us/story/1363274@x20"></a>
</NOSCRIPT>
</div>
</div>
<p></p>
<div style="background-color:white">
<img class="block" border="0" height="1" width="10" src="http://images.bloomberg.com/r06/global/1x1.gif"></div>

</div>
<div class="graytop">
<div class="contentbox smallertext">
<br>
<img border="0" height="18" width="117" alt="Sponsored links" src="http://images.bloomberg.com/r06/global/heading/sponsored-links.gif"><br>
<SCRIPT language="JavaScript">
        NewGoogleAd ("0900204988");
    </SCRIPT><script src="http://pagead2.googlesyndication.com/pagead/show_ads.js" type="text/javascript"></script>
<BR>
</div>
</div>
</td>
</tr>
</table>
</td><td bgcolor="#464646" width="1"><img border="0" height="1" width="1" alt="" src="http://images.bloomberg.com/r06/global/odot.gif"></td><td valign="top" bgcolor="" width="327">      <div class="ad">
<SCRIPT xmlns:webad="http://www.bloomberg.com/webad" xmlns:wn="http://www.bloomberg.com/bloomberg-web-news" xmlns:nav="http://www.bloomberg.com/navigation" language="JavaScript">
 adType = "OAS";
 Category = "03";
 HCat = "x60";
 Keys = "null";
 Width = "300";
 Height = "250";
 Tile = "2";

CallAd(adType, HCat, Width, Height, Tile, Keys, Category);

</SCRIPT>
<NOSCRIPT xmlns:webad="http://www.bloomberg.com/webad" xmlns:wn="http://www.bloomberg.com/bloomberg-web-news" xmlns:nav="http://www.bloomberg.com/navigation">
<a href="http://ads.bloomberg.com/RealMedia/ads/click_nx.ads/bloomberg/news/regions/us/story/1363274@x60"><img border="0" src="http://ads.bloomberg.com/RealMedia/ads/adstream_nx.ads/bloomberg/news/regions/us/story/1363274@x60"></a>
</NOSCRIPT>
</div>
      

<table width="327" cellpadding="0" cellspacing="0" border="0">
<tr>
<td>
<div class="related_media_box">
<br>
<div class="related_media_bar">
<div class="sm_news_roundtop">
<img style="display: none" class="corner" height="4" width="4" src="http://images.bloomberg.com/r06/news/news_tl.gif"></div>
<p>More News</p>
<div class="sm_news_roundbottom">
<img style="display: none" class="corner" height="4" width="4" src="http://images.bloomberg.com/r06/news/news_bl.gif"></div>

</div>
<div class="related_media_headlines">
   <ul class="headlines" id="headlines">
<li class="headline">
<a href="/apps/news?pid=20601103&refer=us&sid=aUhrJizaDFTg">
         U.S. Stocks Slide in Worst Week for S&amp;P 500 Since 2001 Terrorist Attacks 
       </a>
</li>
</ul>
      
   <ul class="headlines" id="headlines">
<li class="headline">
<a href="/apps/news?pid=20601103&refer=us&sid=ad4VH6tMLj9Y">
         Financial-Rescue Plan Wins House Approval 263 to 171; Bush Signs Into Law 
       </a>

</li>
</ul>
      
   <ul class="headlines" id="headlines">
<li class="headline">
<a href="/apps/news?pid=20601103&refer=us&sid=aaDYDblyAjTQ">
         Citigroup Confronts Wells Fargo After Rival Bid Sparks Fight for Wachovia 
       </a>
</li>
</ul>
      
   
</div>
</div>
</td>
</tr>
</table>

         

    
  <div class="ad">
&nbsp;
</div>
</td>
</tr>
<tr>
<td width="998" colspan="3">
<div class="graytop">
<div class="contentbox" id="footer">
<div xmlns:webad="http://www.bloomberg.com/webad" id="footer_toprow">
<a href="http://www.bloomberg.com/?b=0"><img border="0" height="21" width="133" class="toprow_img" alt="Bloomberg.com" src="http://images.bloomberg.com/r06/navigation/bloomberg.gif"></a><a href="/news/index.html">NEWS</a> | 
         <a href="/markets/index.html">MARKET DATA</a> |
         <a href="/invest/index.html">INVESTMENT TOOLS</a> |
         <a href="/tvradio/index.html">TV AND RADIO</a> |
         <a href="http://about.bloomberg.com/index.html">ABOUT BLOOMBERG</a> |
         <a href="http://about.bloomberg.com/careers/index.html">CAREERS</a> |
         <a href="http://about.bloomberg.com/contactus/index.html">CONTACT US</a> |
         <a href="/subscriber">LOG IN/REGISTER</a>

</div>
<span xmlns:webad="http://www.bloomberg.com/webad" class="imgcopyright"><img border="0" src="http://images.bloomberg.com/r06/navigation/copyright.gif"></span><a xmlns:webad="http://www.bloomberg.com/webad" target="_blank" href="/notices/tos.html">  Terms of Service</a> | 
        <a xmlns:webad="http://www.bloomberg.com/webad" target="_blank" href="/notices/privacy.html">Privacy Policy</a> | 
        <a xmlns:webad="http://www.bloomberg.com/webad" target="_blank" href="/notices/trademarks.html">Trademarks</a> | 
        <a xmlns:webad="http://www.bloomberg.com/webad" target="_blank" href="/sitemap.html">Site Map</a> | 
        <a xmlns:webad="http://www.bloomberg.com/webad" target="_blank" href="/help.html">Help</a> | 
        <a xmlns:webad="http://www.bloomberg.com/webad" target="_blank" href="/apps/fbk">Feedback</a> | 
        <a xmlns:webad="http://www.bloomberg.com/webad" target="_blank" href="http://about.bloomberg.com/news/bbcom.html">Advertising</a> | 
        <a xmlns:webad="http://www.bloomberg.com/webad" target="_blank" href="http://www.bloomberg.co.jp">日本語サイト</a>

</div>
</div>
</td>
</tr>
</table>
</div>
<script language="JavaScript" src="/jscommon/wz_tooltip.js"></script>
</body>
</html>
