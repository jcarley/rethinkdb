#!/usr/bin/env bash

fancy_echo() {
  printf "\n%b\n" "$1"
}

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

fancy_echo "Upgrade all packages ..."
  sudo apt-get update
  sudo apt-get -y upgrade

fancy_echo "Updating system packages ..."
  if command -v aptitude >/dev/null; then
    fancy_echo "Using aptitude ..."
  else
    fancy_echo "Installing aptitude ..."
    sudo apt-get install -y aptitude
  fi

  sudo aptitude update

fancy_echo "Installing curl, for making web requests ..."
  sudo aptitude install -y curl

fancy_echo "Installing vim, for editing files on the server ..."
  sudo aptitude install -y vim

fancy_echo "Installing git, for source control management ..."
  sudo aptitude install -y git

fancy_echo "Installing Redis, a good key-value database ..."
  sudo aptitude install -y redis-server

fancy_echo "Installing node, to render the rails asset pipeline ..."
  curl -sL https://deb.nodesource.com/setup | sudo bash -
  sudo apt-get install -y nodejs
  sudo npm install npm -g

  sudo npm install -g yo
  sudo npm install -g grunt-cli
  sudo npm install -g karma-cli
  sudo npm install -g bower

  # sudo npm install -g generator-angular
  # sudo npm install -g generator-gulp-angular
  # sudo npm install -g compass
  # sudo npm install -g gulp

  # mkdir client && cd $_
  # yo gulp-angular fake_lunch_hub
  # gulp serve
  # bower install

