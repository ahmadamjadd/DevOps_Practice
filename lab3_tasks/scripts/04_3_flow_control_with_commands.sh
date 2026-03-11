#! /usr/bin/bash

# Use of normal commands

package=apache2

if which $package ; then
  echo "$package already exists"
else
  echo "$package does not exists"
  echo "Installing package $package"
  sudo apt install -y $package >> apache_installation_log.log
  if [ $? -eq 0 ]; then
    echo "$package successfully installed"
    echo "You can find $package here:$(which $package)"
  else
    echo "$package did not install. please see the log file"
  fi
fi
