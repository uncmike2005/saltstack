#!/bin/bash

rpm -Uvh http://ftp.linux.ncsu.edu/pub/epel/6/i386/epel-release-6-8.noarch.rpm
yum -y install salt-master git
git clone git@github.com:uncmike2005/saltstack.git
