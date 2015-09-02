#!/bin/bash

# evoke with a single file name:

#     palm-foto-convert.sh /filename/

#  This quick and dirty script does a sha1 hash, checks to see if it's a new 
#+ photo, and if so copies to import directory; converts the .jpg.pdb format to
#+ just a plain .jpg; does some tricky stuff with `exiftool` to add/revise the
#+ photo date into a date derived from the filename; adds the hash and original
#+ filename to the growing hash file; and then finally deletes the working
#+ *copy* of the original file - at no time is the original file moved or
#+ touched. 

#  The program should exit immedatly if something goes wrong: filename isn't a 
#+ good match, not allowd to read file, etc. Useful error messages should be 
#+ printed to stderr

# Or at least that's the plan. legacy code is below the divider:


########
##  Setup 
########

workDIR="/home/juser/Pictures/palm"
workFile="$*"
workHashes='/home/juser/Pictures/palm/palm-sha1-hashs'

########
# Main
########

# Validate input file, can we get a date from the file name? Wouid the converted
#+ name collide with an existing file name in our ${workDIR} ?

 # test file exists, and is readable
 # test for ending in '.jpg.pdb'
 # test for start w/ "Photo"
 # test for usable date (e.g. '_101514_' becomes 15oct2014 )
 # test results of the file command, should be "data"

# hash input file and save to variable

hash=$(sha1sum ${workFile})

# check to see if hash exist already (i.e. "have we converted it yet?")

hashOnly=$(echo -n ${hash:0:40}) # extract first 40 char

  # test if only [0-9abcdef]

grep -q "${hashOnly}" "${workHashes}" ; x=$? # 0 if match, 1 otherwise
if [ $x = 0 ] ; then 
  exit 0  #exit, we can skip this one
fi       

# if not, we copy locally and convert to jpg. 

copy ${workFile} ${workDIR} --no-clobber ; x=$x

error="file already exists in working directory, aborting"
if [ $x = 1 ] ; then
  echo "ERROR: $error"
  exit 1
fi

localCopy=""  #extract local file name

pilot-foto -c ${localCopy}

#  Edit new photo w/ `exiftool` to reset date to the date it was taken on. This
# is absolutly critical if we want to later import the photos into `shotwell`.
#+ In fact, that is the main purpose why this utility was written.

# Now hash the original .pdb file again, piping the output to the end of the
#+ ${workHashes} file

########
# cleanup
########

# remove our local copy of the .pdb file, leave converted .jpg and we never touch the original file of course.

rm ${localCopy}

# exit w/o error
exit 0  #nothing below should be run

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

