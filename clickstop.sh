#!/usr/bin/env bash

#Click on an x window to pause or resume
#  This recursively obtains the child process tree of the whole application
#requires xdotool, pgrep
DEBUG=false

if [ "$1" == "pause" ]
then
	KILLARG="-STOP"
elif [ "$1" == "resume" ]
then
	KILLARG="-CONT"
else
	echo "ERROR: Commands are \"pause\" or \"resume\" only!" > /dev/stderr
	exit
fi



children() {
	PIDNODES=$( for i in $@
                    do
                            pgrep -P $i
                    done)

	#empty pidnodes means recursive exit condition
	if [ "$PIDNODES" ]
	then
		echo $PIDNODES
		children $PIDNODES
	fi
}

PROC=$(xdotool selectwindow getwindowpid)
[ "$DEBUG" == "true" ] && echo $PROC > /dev/stderr
CHILDREN=$(children $PROC) 
[ "$DEBUG" == "true" ] && echo $CHILDREN > /dev/stderr
PROCS="$PROC $CHILDREN"
[ "$DEBUG" == "true" ] && echo $PROCS > /dev/stderr


for i in $PROCS
do
	[ "$DEBUG" == "true" ] && echo "kill $KILLARG $i" > /dev/stderr
	kill $KILLARG $i &
done


