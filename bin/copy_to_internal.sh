#!/bin/bash

netrc_file="/home/xiaoquan.li/cd-home-password-file"
while getopts ":d:a:" opt
do
  case $opt in
    d) local_dir=$OPTARG
      ;;
    a) remote_base=$OPTARG
      ;;
    n) netrc_file=$OPTARG
      ;;
    *)
      usage
      ;;
  esac
done

command="find ${local_dir} -type f -exec curl --netrc-file ${netrc_file} --ftp-create-dirs -T {} ftp://${remote_base}/{} \;"

default="y"
read -p "Execute [ $command ] ? [y/n]" select
select=${select:-${default}}

if [ "${select}" != "y" ]; then
  exit 0
fi

files=$(find ${local_dir} -type f)

for f in ${files}; do
  echo "$f -> ftp://${remote_base}/${f}"
  curl --netrc-file ${netrc_file} --ftp-create-dirs -T ${f} ftp://${remote_base}/${f}
done


