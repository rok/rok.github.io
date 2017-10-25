---
layout: post
title: Jupyterhub for teamwork on AWS
location: Amsterdam
tags:
  - Python
  - jupyter
  - jupyterhub
  - AWS
  - cloudformation
author: Rok Mihevc
---
[TL;DR](http://knowyourmeme.com/memes/tldr) - Here's a fancy one command script to build your own JupyterHub in the (AWS) cloud: [(click)](https://gist.github.com/rok/909b6bb57b856ac1e5e8f1f123286e92)

# The need

I ocnasionaly need a reliable, secure and sharable jupyter(hub) installation. The combination of the three requires a bit of thought and sysadmin maintenance later on. My wishlist is usually: https connection, authentication for multiple users and maintainable python virtual environments.

# The implementation

* As I do this just enough to forget what I did the last time I wanted the whole proces scripted. I chose Cloudformation due to the fact deployments can easily be deleted with another command.
* The script implements a JupyterHub installation on EC2 machine. Supervisord restarts JupyterHub on machine restart.
* TODO: kernels other than python3 in seperate virtualenvs.
* TODO: easy user management.

# The How-To

* Pre-requirement: have [AWS CLI](https://aws.amazon.com/cli/) installed and configured on your system.
* Download the [script](https://gist.github.com/rok/909b6bb57b856ac1e5e8f1f123286e92) and store it to a file, e.g.: ___jh.yml___
* Run the following to create the EC2 machine (takes a couple of minutes, even when the machine is up it is not necessarily ready yet):
```
aws cloudformation create-stack \
  --template-body file://jh.yml \
  --profile <YOUR_USER_PROFILE> \
  --stack-name jupyterhub \
  --parameters ParameterKey=KeyName,ParameterValue=<YOUR_KEYPAIR_NAME> \
               ParameterKey=InstanceType,ParameterValue=t2.micro
```
* Log into your EC2 machine ```ssh ubuntu@<YOUR_EC2_MACHINE_IP>``` and create password for ubuntu (```sudo passwd ubuntu```). Create more users if you want them (e.g. sudo adduser bob).
* To access the machine open ```https://<YOUR_EC2_MACHINE_IP>``` and use one of the users credentials (ubuntu will be the admin user).
* Run the following to destroy the EC2 machine:
```
aws cloudformation delete-stack --profile rok --stack-name jupyterhub
```

# The code
{% gist 909b6bb57b856ac1e5e8f1f123286e92 %}