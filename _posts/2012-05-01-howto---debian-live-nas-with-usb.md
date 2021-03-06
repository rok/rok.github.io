---
layout: post
title: HowTo - Debian Live NAS with USB
tag: NAS Linux Live Debian USB
location: Logatec
---
I had an old computer or two lying around, so I decided to cannabalize them and make a cheap [NAS](http://en.wikipedia.org/wiki/Network-attached_storage) with the old disks. The main ideas were to keep it easy to maintain and to buy no extra components.
Here's what I did:

* Hardware: I used an old desktop computer with BIOS that can boot from USB and an old 1GB USB stick (500 mb would be enough)
* I downloaded [Image Writer for Windows](launchpad.net/win32-image-writer) and burnt [Debian Live image](http://cdimage.debian.org/cdimage/release/current-live/i386/usb-hdd/) (debian-live-6.0.4-i386-standard.img in my case - I only wanted the command line) to the USB.
* Plugged the USB in and opened BIOS, to set it as first in the boot order.
* In the boot manager press Esc and write "live persistent".
* Install some packages needed - "sudo apt-get install parted ssh samba ntfs-3g hdparm"
* Partition the nonpartitioned part of the USB by: "parted /dev/sda" (where /dev/sda is the USB stick you're using). Use "help mkpart" and "print" to help with partitioning. Make a new partition by e.g.: "mkpart primary 302MB 1011MB".
* Make a filesystem on the new partition: "mkfs -t ext2 -L live-rw /dev/sda2"
* Configure the bootloader, so it boots automaticaly after 5 seconds: "sudo nano /live/image/syslinux/syslinux.cfg"
* INSTRUCTIONS HERE
* Make default booting option a persistent one "sudo nano /live/image/syslinux/live.cfg"
* INSTRUCTIONS HERE
* Add some password for minimal security: "sudo passwd root" and "sudo passwd user"
* Find the hard disks designations (in my case all partitions were NTFS): `"sudo fdisk -l | grep NTFS"` and add them into /etc/fstabs: "/dev/sda1 /mnt/windows ntfs-3g defaults 0 0" to have them mounted on startup.

* To have disks spin down if idle edit /etc/hdparm.conf: "/dev/sda { spindown_time = 120 }"
* Configure samba, to have it share the disks within your network. See [this](http://www.debuntu.org/guest-file-sharing-with-samba)

The result should be a USB stick which boots up a nice light debian system, shares your files accross the LAN and is easy to maintain if you have basic Linux knowledge.
I might improve the power consumption my setup in the future by replacing the old computer with a [Raspberry Pi](http://www.raspberrypi.org/) to make the whole thing much smaller and economical (supposedly it only consumes ~5W).