---
layout: post
title: Raspberry Pi based wireless motion triggered camera
tag: raspberry linux video
location: Logatec
---
### The setup

To start the project I wrote a fresh image of [Raspbian wheezy](http://www.raspberrypi.org/downloads) onto a 4GB SD card with [win32diskimager](http://sourceforge.net/projects/win32diskimager/).
Raspberry was connected to my home router and accessed trought LAN with [putty](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html).
I also used Logitech C270 webcam and Edimax EW-7811Un wireless adapter.

I resized the partition size with raspi-config, using expand_rootfs command:
{% highlight bash %}
sudo raspi-config
{% endhighlight %}

To set the proper timezone run:
{% highlight bash %}
sudo dpkg-reconfigure tzdata
{% endhighlight %}

### Motion

References: [[1](http://through-the-interface.typepad.com/through_the_interface/2012/09/creating-a-motion-detecting-security-cam-with-a-raspberry-pi-part-2.html)] [[2](http://jeremyblythe.blogspot.co.uk/2012/06/motion-google-drive-uploader-and.html)]

First we update the repository list, upgrade the system and install [motion](http://www.lavrsen.dk/foswiki/bin/view/Motion/WebHome), the motion detection software. This will take a while, optionaly you can skip apt-get upgrade.
{% highlight bash %}
sudo apt-get update && sudo apt-get upgrade && sudo apt-get install motion
{% endhighlight %}

We enable the motion daemon in /etc/default/motion by setting *start_motion_daemon=yes* and restart the system to see if it boots up properly.
{% highlight bash %}
sudo vi /etc/default/motion
sudo reboot
{% endhighlight %}

At this point you might want to test out if motion actually works. Make some motion in front of the camera and check if any images and videos were stored into /tmp/motion. If yes continue! :)

First install python package manager pip and python module gdata:

{% highlight bash %}
sudo apt-get install python-pip
sudo pip install gdata
{% endhighlight %}

Then download [uploader.py](http://files.mihevc.org/raspi/motion/uploader) and [uploader.cfg](http://files.mihevc.org/raspi/motion/uploader.cfg). Configure uploader.cfg with your google account credentials to enable motion to upload recorded videos.

{% highlight bash %}
sudo wget http://files.mihevc.org/raspi/motion/uploader -O /etc/motion/uploader.py
sudo wget http://files.mihevc.org/raspi/motion/uploader.cfg -O /etc/motion/uploader.cfg
sudo chmod +x /etc/motion/uploader.py
sudo vi /etc/motion/uploader.cfg
{% endhighlight %}

Now reopen /etc/motion/motion.conf and add the following line: *on_movie_end python /etc/motion/uploader.py /etc/motion/uploader.cfg %f*
{% highlight bash %}
sudo vi /etc/motion/motion.conf
sudo reboot
{% endhighlight %}

We create a folder named motion on our google drive, this is where the captured videos will be uploaded to. Now we plugin the webcam, restart the system and test it by, well, moving. Final result should be recieving an email to our gmail account with a link to the captured video.
If something is not working it is worth checking /tmp/motion folder - if there is no files in it motion is not working properly. If files appear in /tmp/motion, but don't upload to your google drive account the problem is in the uploader area.

### WLAN

References: [[3](http://svay.com/blog/setting-up-a-wifi-connection-on-the-raspberrypi/)] [[4](http://www.linux-magazine.com/Online/Blogs/Productivity-Sauce/How-to-Quickly-Configure-Wireless-WPA-Connection-on-Raspberry-Pi)] [[5](http://rpi.tnet.com/project/scripts/wifi_check)]

To set up the wireless connection we first open the dedicated config file:

{% highlight bash %}
sudo vi /etc/network/interfaces
{% endhighlight %}

The "wlan0 part" should look something like this (but various other setups are possible).

{% highlight bash %}
auto wlan0
iface wlan0 inet dhcp
wpa-ssid YOUR_SSID
wpa-psk your_password
{% endhighlight %}

In case you have Edimax EW-7811Un wireless adapter you can assure it never enters power saving mode by setting *options 8192cu rtw_power_mgnt=0 rtw_enusbss=0* in /etc/modprobe.d/8192cu.conf:

{% highlight bash %}
sudo vi /etc/modprobe.d/8192cu.conf
{% endhighlight %}

Further, to ensure reestablishing of wlan connection in case it is dropped we download a script that reconnects in case of dropped connection and add it to cron.

{% highlight bash %}
sudo wget http://files.mihevc.org/raspi/motion/WiFi_Check -O /usr/local/bin/WiFi_Check
sudo chmod 0755 /usr/local/bin/WiFi_Check
crontab -e
{% endhighlight %}
Add the following line at the end
{% highlight bash %}
*/5 * * * * sudo /usr/local/bin/WiFi_Check
{% endhighlight %}

Finaly we reboot to finish setting up.
{% highlight bash %}
sudo reboot
{% endhighlight %}

Now we unplug the wired connecition and set up the camera and Pi in the desired position and see if everything works.
You can tweak the /etc/motion/motion.conf settings for higher resolution etc.