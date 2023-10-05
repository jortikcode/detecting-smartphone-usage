#!/bin/bash
usage() { echo "Usage: $0 [-h] [-d --dirname <string>] [-f <integer>]" 1>&2; exit 1; }

while getopts "d:f:-:" option; do
        if [ "$option" = "-" ]; then
                OPT="${OPTARG%%=*}"
                OPTARG="${OPTARG#$OPT}"
                OPTARG="${OPTARG#=}"
        fi
        case "${option}" in
                d | dirname)
                        dirname=${OPTARG}
                        ;;
		f)
			fps=${OPTARG}
			;;
                *)
			usage
                        ;;
        esac
done
if [ -z "${fps}" ] || [ -z "${dirname}" ]
then
	usage
fi
folder="${dirname}-${fps}fps-images"
mkdir $folder
for filename in $dirname/*.mp4; do
	mkdir "${folder}/${filename##*/}"
	ffmpeg -i $filename -vf fps=$fps "${folder}/${filename##*/}/${filename##*/}-%d.png"
done
