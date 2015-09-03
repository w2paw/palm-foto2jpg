# palm-foto2jpg

I wrote this because I wanted to pull together multiple copies of Zire 72 Palm photo databases into shotwell. 

The exif code was an attempt to code something so that shotwell would automatically sort the imported photos into directories by date. It doesn't do that, at least in the version of shotwell I'm using. Because I'm on a Ubuntu LTS release, shotwell is at 0.18.0 or something.


Right now I'm finding old `Photo_MMDDYY_???.jpg.pdb` files on memory cards and such. After hashing them (the test for uniqueness) and converting them (using `pilot-xfer` tools) I'm just dropping them into /home/$USER/Pictures and running `shotwell` which discovers them and indexes them. I'll write a different tool to 1) test that shotwell had indexed them, and 2) move the photos out of the home directory and into subdirectories by date. Once shotwell indexes a file, it seems to keep an eye on it, making the subsequently move to a subdirectory not something that will confuse the program.

Regarding a maddening thing that shotwell does: If shotwell is asked to copy photos off what it thinks is a camera, SD card,flash drive, or other removable media, it will actually copy the file into it's default folder structure (usually /home/$USER/Pictures) like you would expect, but if shotwell thinks it's a permanent part of the filesystem it will instead only *index* the files instead. When you remove that hotswappable SATA drive, all your photos will go with it. This is insane behavior for a program designed to sort and organize photos, but there you go. I've yet to determine if this has been fixed in later versions.  
