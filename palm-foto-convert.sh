#!/bin/bash

# evoke with a single file name:

#     palm-foto-convert.sh /filename/

#  This quick and dirty script does a sha1 hash, checks to see if it's a new 
#+ photo, and if so copies to import directory; converts the .jpg.pdb format to
#+ just a plain .jpg; does some tricky stuff with `exiftool` to add/revise the
#+ photo date into a date derived from the filename; adds the hash and original
#+ filename to the growing hash file; and then finally deletes the working
#+ *copy* of the original file. 

#  At no time is the original file moved or touched. 

#  The program should exit immedatly if something goes wrong: filename isn't a 
#+ good match, not allowed to read file, etc. Useful error messages should be 
#+ printed to stderr

#  Or at least that's the plan. 

#  Note: Y2K issue. Filenames that place the creation year as >90 are assumed 
#+ to be in the 20th century, e.g Photo_123199_001.jpg = '31dec99' and assumed
#+ to be from year 1999. This is only an issue to the exif tag that's written
#+ to the photo. Fix this software before the year 2090.


########
##  Setup 
########

workDIR="/home/juser/Pictures/palm"
workHashes='/home/juser/Pictures/palm/palm-sha1-hashs'
workFile="$*"
localCopy="${workFile##/*/}"     # remove path

hashIt=""
hashOnly=""

##echo "DEBUG:1"


#######
# Main
########

# Validate input file, can we get a date from the file name? Wouid the converted
#+ name collide with an existing file name in our ${workDIR} ?

 # test file exists, and is readable
 # test for ending in '.jpg.pdb'
 # test for start w/ "Photo"
 # test for usable date (e.g. '_101514_' becomes 15oct2014 )
echo "${workFile}" | grep -qoE "_[0-9]{6}" ; x=$?

 # test results of the file command, should be "data"

##echo "DEBUG:2 "'$x:'"$x"  


# hash input file and save to variable

hashIt="$(sha1sum ${workFile})"

# check to see if hash exist already (i.e. "have we converted it yet?")

hashOnly=$(echo -n ${hashIt:0:40}) # extract first 40 char

##echo '$hashIt'" $hashIt" 
##echo '$hashOnly'" $hashOnly" 
##echo "DEBUG:3   " 
  # test if only [0-9abcdef]

grep -i -q "${hashOnly}" "${workHashes}" ; x=$? # 0 if match, 1 otherwise 
if [ $x = 0 ] ; then 
  echo; echo "--- Dupe! We'll just skip this one."
  exit 0  #exit, we can skip this one
fi       

##echo "DEBUG:4"

# if not, we copy locally and convert to jpg. 

##echo "DEBUG: ${workDIR}/${localCopy}"
if [ ! -e "${workDIR}/${localCopy}" ] ; then
  cp --no-clobber ${workFile} ${workDIR} #; x=$?  #copy locally
  else
    echo "ERROR: file already exists in working directory, aborting"
    exit 1
fi

##echo "DEBUG:5"

echo
/usr/bin/pilot-foto -c "${localCopy}" #convert to .jpg

##echo "DEBUG:6"

#  Edit new photo w/ `exiftool` to reset date to the date it was taken on.
 #exiftool -EXIF:CreateDate='2013:11:08 12:57:07' Photo_123110_001.jpg #to add a tag
 #exiftool  -EXIF:CreateDate  100_2652.JPG # to dump current file name

year="${localCopy:10:2}" # extract 2 digit year

exiftool -EXIF:CreateDate='2013:11:08 12:34:56' "${localCopy/.pdb/}" #convert
                                            # the one that doesn't end w/ .pdb

##echo "DEBUG:7"

# Now copy the hash to the end of the ${workHashes} file

echo "${hashIt}" >>"${workHashes}"

##echo "DEBUG:8"

########
# cleanup
########

# remove our local copy of the .pdb file
rm "${localCopy}"
rm "${localCopy/.pdb/}_original"  #dupe made by exiftool

# exit w/o error
exit 0  #nothing below this line should be run
