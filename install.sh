#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [[ -d "$DIR/systemd/" ]]
then
  for file in $DIR/systemd/*
  do
    target=$(basename $file)
    if [[ -L /etc/systemd/system/$target ]]
    then
      sudo rm -i /etc/systemd/system/$target
    fi
    echo "Linking $target to /etc/systemd/system/"
    sudo cp -Ri "$file" /etc/systemd/system/
  done
else
  cp -R "$DIR/systemd_examples/" "$DIR/systemd/"
  echo "Please edit the files in "$DIR/systemd/" and run this command again"
fi
