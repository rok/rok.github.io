---
layout: post
title: Crontabed PyDrive uploader
tag: raspberry, python, google drive
location: Amsterdam
---
I am preparing small data science-y project, where I am collecting a bunch of logs on a network connected Raspberry pi. I want to upload the logs to an online cloud storage automatically so I don't have to bother with data acquisition.
As I have a lot of storage on my google drive and there is a great python API for it with a nice wrapper, I've decided to use it.
As the setup is quite simple I decided to write it up for my future reference and for the intertubes.

1. [Enable the drive API with your google account.](https://developers.google.com/drive/v3/web/quickstart/python#step_1_turn_on_the_api_name). Only follow the Step 1 and download the client_secrets.json file.
2. Install PyDrive: ```pip install pydrive```
3. Copy the following code into uploader.py and store it in the same location as the client_secrets.json.
{% highlight python %}
from pydrive.auth import GoogleAuth
from pydrive.drive import GoogleDrive
import os
import argparse

# Parse the passed arguments
parser = argparse.ArgumentParser()
parser.add_argument('files', help='List files to be uploaded.', nargs="+")

# Define the credentials folder
home_dir = os.path.expanduser('~')
credential_dir = os.path.join(home_dir, '.credentials')
if not os.path.exists(credential_dir):
    os.makedirs(credential_dir)
credential_path = os.path.join(credential_dir, 'pydrive-credentials.json')

gauth = GoogleAuth()
# Try to load saved client credentials
gauth.LoadCredentialsFile(credential_path)
if gauth.credentials is None:
    # Authenticate if they're not there
    gauth.CommandLineAuth()
elif gauth.access_token_expired:
    # Refresh them if expired
    gauth.Refresh()
else:
    # Initialize the saved creds
    gauth.Authorize()
# Save the current credentials to a file
gauth.SaveCredentialsFile(credential_path)

drive = GoogleDrive(gauth)

# Upload the files and remove them locally
for file in parser.parse_args().files:
    print "Uploading " + file
    textfile = drive.CreateFile()
    textfile.SetContentFile(file)
    textfile.Upload()
{% endhighlight %}
5. Run ```python uploader.py``` and follow the initial authentication instructions.
5. Open the given url, replacing <client_id sting> with your own ```https://accounts.google.com/o/oauth2/auth?scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&response_type=code&client_id=<clent_id string>.apps.googleusercontent.com&access_type=offline```. You will be asked to confirm an authorisation request and reccieve an authorisation code. Enter the code into the prompt, your uploader is now permenantly authenticated.
6. You can now upload files by: ```python uploader example.txt```.
7. Create a crontab script, run ```crontab -e``` and add the fillowing line to it:
{% highlight bash %}
0 * * * * python ~/uploader.py ~/logs/* && rm ~/logs/*
{% endhighlight %}

[1]:http://stackoverflow.com/questions/24419188/automating-pydrive-verification-process
