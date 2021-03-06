#!/bin/bash

echo ""
if [ -f "pid/dump_threads.dat" ]
then
	echo "Already running!"
	exit
fi

mkdir pid

if [ "$1" == "" ]
then
	mkdir log_dump_1
	exec ./dump.sh 1 > log_dump_1/out.log 2> log_dump_1/error.log &
	THREADS="1"
else

	THREADS="$1"
	THREAD="1"

	while [ "$THREAD" -le "$THREADS" ]
	do
		echo -ne "\x0dStarting thread $THREAD ... please wait."
		CMD="mkdir log_dump_$THREAD"
		eval $CMD
		exec ./dump.sh "$THREAD" > "log_dump_$THREAD/out.log" 2> /dev/null &
		sleep 1
		((THREAD++))
	done
	
fi
echo ""
CMD="echo \"$THREADS\" > pid/dump_threads.dat"
eval $CMD
echo "Started!"