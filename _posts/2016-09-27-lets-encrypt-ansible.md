---
layout: post
title: Letsencrypt Ansible
tags: ansible, crypto, automation
splash: "../../../images/headers/keepass.png"
location: Amsterdam
---
Recently I have set up a [Snowplow](http://snowplowanalytics.com/) collector at work and needed a reliable way of generating https certificates. The collector (think of it as a very dumb web server with great logging) sits on a subdomain of a website and listens to events sent by javascript tags triggered by visitors of the site. To have this event traffic from visitors to the collector encrypted I needed an https cetificate.
It is a relatively straitforward to create a letsencrypt certicate with the great DNS challenge client letsencrypt provides, but I wanted an automatable way to do it and on a machine I can later destroy, etc. As the whole project is hosted on AWS EC2 I decided to use Ansible to do it. The script does the following:

1. Spins up a nano EC2 instance.
2. Points a domain at it with Route 53 DNS service of AWS.
3. Installs letsencrypt on the instance and runs it to generate the certificate.
4. Copies the certificate into AWS certificate menegement service.
5. Destroys the nano instance and Route 53 DNS entry.

You can find the code [here](https://github.com/rok/letsencrypt-ansible).

Let me know if you actually end up using it.