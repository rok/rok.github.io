---
layout: post
title: Wordpress at Dreamhost hacked
tag: wordpress hosting dreamhost hacked bash php
location: Logatec
---
Recently someone got access into admin area of my wordpress sites. It would appear that he added a small piece of code into one php file via the embedded wordpress editor. This thing ran itself via the eval function and copied into each .php file of wordpress (~400 files), then served some adds on the website via a .js file.
Fortunately solution to this is googlable and is a bash-fu script, see below:

{% highlight bash %}
find . -type d -perm -o=w -print -exec chmod 770 {} \;
find . -wholename '*wp-content/uploads/*.php' -exec rm -rf {} \;
find ./ -name "*.php" -type f |  xargs sed -i 's#<?php /\*\*/ eval(base64_decode("aWY.*?>##g' 2>&1
find ./ -name "*.php" -type f |  xargs sed -i '/./,$!d' 2>&1
{% endhighlight %}

_Sources:_

* [1] [http://danhilltech.tumblr.com/post/18085864093/if-you-get-eval-base64-hacked-on-wordpress-dreamhost](http://danhilltech.tumblr.com/post/18085864093/if-you-get-eval-base64-hacked-on-wordpress-dreamhost)

* [2] [http://blog.sucuri.net/2010/05/simple-cleanup-solution-for-the-latest-wordpress-hack.html](http://blog.sucuri.net/2010/05/simple-cleanup-solution-for-the-latest-wordpress-hack.html)