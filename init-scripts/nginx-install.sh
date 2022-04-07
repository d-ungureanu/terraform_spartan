#!/usr/bin/env bash

sudo apt-get -y update
sudo apt-get -y install nginx
sudo systemctl start nginx
sudo systemctl enable nginx
