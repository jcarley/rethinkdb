#!/usr/bin/env bash

fancy_echo() {
  printf "\n%b\n" "$1"
}

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT

set -e

if [ -z "${RBENV_ROOT}" ]; then
  RBENV_ROOT="$HOME/.rbenv"
fi

fancy_echo "Installing base ruby build dependencies ..."
  sudo aptitude build-dep -y ruby1.9.3

fancy_echo "Installing libraries for common gem dependencies ..."
  sudo aptitude install -y libxslt1-dev libcurl4-openssl-dev \
    libksba8 libksba-dev libqtwebkit-dev libreadline-dev

if [[ -d "$HOME/.rbenv" ]]; then
  sudo chown -R vagrant:vagrant $HOME/.rbenv
fi

if [[ ! -d "$HOME/.rbenv" ]]; then
  fancy_echo "Installing rbenv, to change Ruby versions ..."
    git clone https://github.com/sstephenson/rbenv.git $HOME/.rbenv

    if ! grep -qs "rbenv init" $HOME/.bashrc; then
      printf 'export PATH="$HOME/.rbenv/bin:$PATH"\n' >> $HOME/.bashrc
      printf 'eval "$(rbenv init - --no-rehash)"\n' >> $HOME/.bashrc
    fi
fi

fancy_echo "Installing rbenv plugins ..."

  # Install plugins:
  PLUGINS=(
    "sstephenson:rbenv-vars"
    "sstephenson:ruby-build"
    "sstephenson:rbenv-default-gems"
    "sstephenson:rbenv-gem-rehash"
    "rkh:rbenv-update"
    "rkh:rbenv-whatis"
    "rkh:rbenv-use"
  )

  for plugin in ${PLUGINS[@]} ; do

    KEY=${plugin%%:*}
    VALUE=${plugin#*:}

    RBENV_PLUGIN_ROOT="${RBENV_ROOT}/plugins/$VALUE"
    if [ ! -d "$RBENV_PLUGIN_ROOT" ] ; then
      git clone https://github.com/$KEY/$VALUE.git $RBENV_PLUGIN_ROOT
    else
      cd $RBENV_PLUGIN_ROOT
      echo "Pulling $VALUE updates."
      git pull
    fi

  done

ruby_version="2.2.1"

if [[ ! $(echo $PATH | grep "$HOME/.rbenv/bin") ]]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

fancy_echo "Installing Ruby $ruby_version ..."
  rbenv install -s "$ruby_version"

fancy_echo "Setting $ruby_version as global default Ruby ..."
  rbenv global "$ruby_version"
  rbenv rehash

fancy_echo "Creating gemrc file ..."

if [[ -a "$HOME/.gemrc" ]]; then
  sudo rm $HOME/.gemrc
fi

  cat <<GEMRC > $HOME/.gemrc
:verbose: true
:update_sources: true
:backtrace: false
:bulk_threshold: 1000
:benchmark: false
gem: --no-ri --no-rdoc
GEMRC

if [[ -a "$HOME/.rbenv/default-gems" ]]; then
  sudo rm $HOME/.rbenv/default-gems
fi

  cat <<DEFAULTGEMS > $HOME/.rbenv/default-gems
bundler
compass
DEFAULTGEMS

fancy_echo "Updating to latest Rubygems version ..."
  gem update --system

fancy_echo "Installing Bundler to install project-specific Ruby gems ..."

if [[ ! $(gem list bundler | grep "bundler") ]]; then
  gem install bundler
fi

