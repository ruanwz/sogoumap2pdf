= sogoumap2pdf

* sogoumap2pdf.rubyforge.org

== DESCRIPTION:

* Download map and convert to pdf

== FEATURES/PROBLEMS:

* Download map and convert to pdf


== SYNOPSIS:
  Find out the link of the center picture using Firebug plugin in Firefox, then type:
    sogoumap2pdf link map_widthxmap_height rowxcolumn save_file_name mode
  for example:
    sogoumap2pdf http://hbpic1.go2map.com/seamless/0/180/711/252/52/50449_10516.JPG 1024x768 5x5 gz.pdf sp
  mode description:
    sp: both satellite and path
    s: only satellite
    m: only map

  Links for some cities:
    1 Beijing:http://hbpic3.go2map.com/seamless/0/180/792/518/192/103647_38598.JPG
    2 Shanghai:http://hbpic3.go2map.com/seamless/0/180/792/540/145/108175_29128.JPG
    3 Tianjing:http://hbpic3.go2map.com/seamless/0/180/792/521/188/104367_37713.JPG
    4 Chongqin:http://hbpic2.go2map.com/seamless/0/180/792/474/137/94897_27407.JPG
    5 Chendu:http://hbpic4.go2map.com/seamless/0/180/792/463/142/92685_28539.JPG
    6 Dalian:http://hbpic2.go2map.com/seamless/0/180/792/541/187/108301_37462.JPG
    7 Fuzhou:http://hbpic0.go2map.com/seamless/0/180/792/531/119/106244_23925.JPG
    8 Guangzhou:http://hbpic0.go2map.com/seamless/0/180/792/504/105/100915_21050.JPG
    9 Hangzhou:http://hbpic1.go2map.com/seamless/0/180/792/535/140/107001_28156.JPG
    10 Jinan:http://hbpic4.go2map.com/seamless/0/180/792/520/174/104176_34934.JPG
    11 Kunming:http://hbpic0.go2map.com/seamless/0/180/792/457/114/91472_22905.JPG
    12 Nanjing:http://hbpic1.go2map.com/seamless/0/180/792/528/149/105778_29981.JPG
    13 Qingdao:http://hbpic0.go2map.com/seamless/0/180/792/536/171/107220_34345.JPG
    14 Sanya:http://hbpic4.go2map.com/seamless/0/180/792/487/82/97523_16429.JPG
    15 Shenzhen:http://hbpic4.go2map.com/seamless/0/180/792/507/102/101555_20499.JPG
    16 Shenyan:http://hbpic0.go2map.com/seamless/0/180/792/549/204/109907_40820.JPG
    17 Wuhan:http://hbpic3.go2map.com/seamless/0/180/792/508/142/101779_28448.JPG
    18 Xian:http://hbpic4.go2map.com/seamless/0/180/792/485/161/97019_32314.JPG
    19 Hongkong:http://hbpic3.go2map.com/seamless/0/180/792/508/101/101692_20253.JPG
    20 Zhengzhou:http://hbpic4.go2map.com/seamless/0/180/792/506/164/101221_32844.JPG
    21 Qinghuangdao:http://hbpic3.go2map.com/seamless/0/180/792/532/193/106514_38638.JPG
== REQUIREMENTS:

* pdf-writer
* rmagick(On ubuntu, imagemagick and libmagick9-dev are needed to be installed first)

== INSTALL:

* sudo gem install sogoumap2pdf

== LICENSE:

(The MIT License)

Copyright (c) 2008 FIXME full name

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
