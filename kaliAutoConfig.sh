#!/bin/bash

mv motd /etc/ 
apt update && apt -y full-upgrade && apt autoremove -y && apt autoclean && apt clean

apt install terminator hostapd bully 
