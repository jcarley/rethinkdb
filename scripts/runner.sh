#!/usr/bin/env bash

/vagrant/scripts/base.sh
/vagrant/scripts/redb-database.sh
/vagrant/scripts/nginx.sh
sudo -u vagrant -H bash -c "/vagrant/scripts/ruby.sh"

