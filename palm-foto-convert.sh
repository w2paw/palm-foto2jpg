#!/bin/bash

# evoke with a single file name:

#     palm-foto-convert.sh /filename/

#  This quick and dirty script does a sha1 hash, checks to see if it's a new 
#+ photo, and if so copies to import directory; converts the .jpg.pdb format to
#+ just a plain .jpg; does some tricky stuff with `exiftool` to add/revise the
#+ photo date into a date derived from the filename; adds the hash and original
#+ filename to the growing hash file; and then finally deletes the working
#+ *copy* of the original file - at no time is the original file moved or touched

# Or at least that's the plan. legacy code is below the divider:


########
##  Setup 
########

workDIR="/home/juser/Pictures/palm"
workFile="$*"


#-----------------------------
# palm-foto-convert.sh - convert synced photo pdb into jpgs, make sure they're converted only once,
#			 and add exif data for an easy import into shotwell.

########
##  Setup 
########

fotoSource="/home/juser/jpilot/last-sync/"
fotoTarget="/home/juser/jpilot/extracted-photos/test2"
foto1sha="/home/juser/jpilot/extracted-photos/test2/foto1sha.txt"

check_for_existing_hash () {
    # "0" means a match,  "1" means no match, "$1" is the hash
    hash=$(tr 'ABCDEF' 'abcdef' <<<$1) #convert to lower case
    grep "$1" ${foto1sha} &>/dev/null #only look at exit status
    return $?
}

add_new_hash () {
    # add a new hash and filename to the list of already processed foto files
    # "$1" is hash, "$2" is filename. Example line:
    # bb294f2afb7458e32afbbfd5bfe2292f09396486,  "Photo_090910_001.jpg.pdb"
    echo "\"\""

}



########
# Main
########

#find all files in ${fotoSource}; sha1sum and check against sums in ${foto1sha}
# if new,
#	1. add hash to ${foto1sha}
#	2. convert to jpg, put in $fotoTarget
#	3. use `touch` to re-set timestamp
#	3. use exiftool to add EXIF data so that shotwell sorts via date when it imports 

for x in $(find ${fotoSource} -maxdepth 1 -type f -name "*.jpg.pdb") ; do  #find files
	sum=$(sha1sum $x |cut -b-40 ) #get sha1sum only
	grep ${sum} ${foto1sha} &>/dev/null #look to see if new or not, only look at exit status.
	if [ "$?" -eq "0" ] ; then #then we have new photo
		y="${x##/*/}" #remove "tree" from filename
		z="${y%.pdb}" #remove .pdb; $z is now perdicted filename of converted photo
		echo "${sum},\"${x}\"">>${foto1sha}	#add sha1sum to database
		pilot-foto -c ${x}			#convert to jpg, will stay in same dir
		dupeCount="0" ; targetFilename="${z}"   #setup for target filename test
	        while [ -e "${fotoTarget}${targetFilename}" ] ; do
			((dupeCount++))
			targetFilename=${z%.jpg}-${dupeCount}.jpg"
		#mv "${fotoSource}/${fotoName}"  #move (should add code to look for colosions)
	       #touch
       		#exiftool #timestamp	       



#create tmp dir  #future md5sum?
#mkdir /tmp/.photo-${uq}
#cd /tmp/.photo-${uq}

cd ${fotoTarget} #change to target directiry


for x in $(find ${fotoSource} -name "*jpg.pdb") ; do
	#check for name clobber 
		# /home/juser/jpilot/last-sync/Photo_043010_001.jpg.pdb
		# becomes "Photo_043010_001.jpg"
	y=$(echo "$x" |sed -e 's_^/home/juser/jpilot/last-sync/__' -e 's_.pdb$__')
	# if file exists at target then 
	if [ -e "$y" ] ; then
		echo "not overwriting ${y}" #error message
		true #do nothing
	else #else convert to normal jpg
		pilot-foto -c ${x} #convert, store in current dir

	fi 


done


#target="for x in $(find ${startD} -type f -name "*.jpg.pdb") ; do 

########
# cleanup
########
exit


{
  "_filename_palm": "t2z1vH4.mp4",
  "sha1sum": 0,
  "annotations": null,
  }

