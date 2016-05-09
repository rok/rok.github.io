---
layout: post
title: Crontabed PyDrive uploader
tag: raspberry, python, google drive
location: Amsterdam
comments: True
---
I am preparing small data science-y project, where I will be collecting a bunch of logs on a network connected Raspberry Pi. I want to upload the logs to an online cloud storage automatically.
As I have a lot of storage on my Google Drive and it has a great [API](https://developers.google.com/drive/) with a [nice python wrapper](http://pythonhosted.org/PyDrive/) for, so I decided to use it.
The setup is quite simple and I decided to write it up for my future reference and the intertubes.

[Enable the drive API with your google account](https://developers.google.com/drive/v3/web/quickstart/python#step_1_turn_on_the_api_name). Only follow the Step 1 and download the client secret file and name it *client_secrets.json*.

To install PyDrive run: 
{% highlight bash %}
pip install pydrive
{% endhighlight %}
I used python 2.

Copy the following code into *uploader.py* and store it in the same location as the *client_secrets.json*.
{% highlight python %}
from pydrive.auth import GoogleAuth
from pydrive.drive import GoogleDrive
import os
import argparse

PARENT_ID = "LONG_FOLDER_ID_STRING"

# Parse the passed arguments
parser = argparse.ArgumentParser()
parser.add_argument("files", help="List files to be uploaded.", nargs="+")

# Define the credentials folder
home_dir = os.path.expanduser("~")
credential_dir = os.path.join(home_dir, ".credentials")
if not os.path.exists(credential_dir):
    os.makedirs(credential_dir)
credential_path = os.path.join(credential_dir, "pydrive-credentials.json")

# Start authentication
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

# Upload the files
for f in parser.parse_args().files:
    new_file = drive.CreateFile({"parents": [{"id": PARENT_ID}], \ 
                                              "mimeType":"text/plain"})
    new_file.SetContentFile(f)
    new_file.Upload()
{% endhighlight %}

Pick a folder in Google Drive and store its id under the PARENT_ID variable in uploader.py. The id is the string in the URL of your folder, e.g.: *https://drive.google.com/drive/folders/LONG_FOLDER_ID_STRING*.

Run 
{% highlight bash %}
python uploader.py
{% endhighlight %}
and follow the initial authentication instructions. Trough the prompt you will be given an URL, similar to [this one](https://accounts.google.com/o/oauth2/auth?scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&response_type=code&client_id={ID_STRING}.apps.googleusercontent.com&access_type=offline). Replace the {ID_STRING} with the one you were given and open the link in a browser. You will be asked to confirm an authorisation request and receive an authorisation code. Enter the code into the prompt, your uploader is now authenticated. Delete *client_secrets.json*.

You can now upload files to the selected Google Drive folder by running: 
{% highlight bash %}
python uploader.py example.txt
{% endhighlight %}

To create a crontab script, run:
{% highlight bash %} crontab -e {% endhighlight %} and add the fillowing line to it:

{% highlight bash %}
0 * * * * python ~/uploader.py ~/fr24feed.log && truncate -s0 ~/fr24feed.log
{% endhighlight %}

In my case I am uploading a log of transponder signals of nearby planes. I am using [Flightradar24](https://www.flightradar24.com/raspberry-pi) packaged [dump1090](https://github.com/antirez/dump1090) to decode and record transponder signals.

We now have an automated uploader to the cloud. Log uploading is only one of the many options available. Motion detection triggered videos, regular file backups and more could be uploaded like this.
