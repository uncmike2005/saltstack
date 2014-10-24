#!/bin/bash
yum -y install git
git clone https://github.com/uncmike2005/saltstack.git /root/saltstack
chmod 755 /root/saltstack/setup.bash
/root/saltstack/setup.bash

