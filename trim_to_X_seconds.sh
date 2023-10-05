#!/bin/bash

usage() { echo "Usage: $0 [-h] [-s --seconds <seconds>] [-d --dirname <string>]" 1>&2; exit 1; }

while getopts "d:s:-:" option; do
	if [ "$option" = "-" ]; then
		OPT="${OPTARG%%=*}"
		OPTARG="${OPTARG#$OPT}"
		OPTARG="${OPTARG#=}"
	fi
	case "${option}" in
		d | dirname)
			dirname=${OPTARG}
			;;
		s | seconds)
			seconds=${OPTARG}
			;;
		*)
			seconds="5"
			;;
	esac
done

echo $dirname

if [[ -z "${dirname}" ]]
then
	usage
fi

# creating 
output_dir="${dirname}_trimmed_to_${seconds}_secs"
mkdir ${output_dir}
for filename in "${dirname}"/*.mp4; do
	ffmpeg -ss 00:00:00 -i $filename -c copy -t 00:00:0${seconds} "${output_dir}/${filename##*/}"
done
