#!/bin/bash
# I run this script to quickly configure my orangepi zero plus and construct ML environment

# *****only for python 2.7*****

# network
sudo nmtui

# dir
mkdir document
mkdir download
mkdir programs
mkdir notebook


# dotfiles
wget https://raw.githubusercontent.com/hankso/dotfiles/master/bashrc -O .bashrc
source .bashrc 

wget https://raw.githubusercontent.com/hankso/dotfiles/master/vimrc -O .vimrc

mkdir -p .pip
wget https://raw.githubusercontent.com/hankso/dotfiles/master/pip.conf -O .pip/pip.conf

sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak
sudo wget https://raw.githubusercontent.com/hankso/dotfiles/master/sources.list -O /etc/apt/sources.list
sudo apt-get update



# install
cd ~/download
wget https://bootstrap.pypa.io/get-pip.py
sudo python2 get-pip.py

wget https://raw.githubusercontent.com/hankso/OrangePi-BuildML/master/files/apt-install.list
sudo apt-get install -y $(cat apt-install.list 2>/dev/null)

wget https://raw.githubusercontent.com/hankso/OrangePi-BuildML/master/files/requirements.txt
sudo pip install -r requirements.txt 2>/dev/null

# I don't need python3
#sudo apt autoremove --purge python3* 2>/dev/null

# pylsl is a python package depends on compiled dynamic C library like 'liblsl64.so'
# here is an aarch64 version I cross compiled and it works fun on my orangepi
sudo pip install pylsl
wget https://raw.githubusercontent.com/hankso/OrangePi-BuildML/master/files/liblsl64.so.1.4.0
sudo mv liblsl64.so.1.4.0 /usr/local/lib/python2.7/dist-packages/pylsl/liblsl64.so


# Tensorflow is so so different from other packages, it's hard to install
# I failed by simply typing `pip install tensorflow` and `apt install python-tensorflow`
# which should work at most situations(my orangepi zero plus is ARMv8 aarch64 architecture)
# TF depends on many compiled libs, but compile with bazel is difficult and slow and need luck
# Fortunately, this package is available on the Internet
wget http://ai.2psoft.com/tensorflow/pine64/tensorflow-1.2.1-cp27-cp27mu-linux_aarch64.whl
sudo pip install tensorflow-1.2.1-cp27-cp27mu-linux_aarch64.whl 2> /dev/null



# nice tool for accessing your pi in different LAN
cd ~/programs
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip
unzip ngrok-stable-linux-arm.zip
rm ngrok-stable-linux-arm.zip
chmod +x ngrok
sudo ln -sf $(pwd)/ngrok /usr/local/bin/ngrok


# NodeJS is useful for me, if you don't need it just comment these lines
wget https://nodejs.org/dist/v9.6.1/node-v9.6.1-linux-arm64.tar.gz
tar xzf node-v9.6.1-linux-arm64.tar.gz
rm node-v9.6.1-linux-arm64.tar.gz
cd node-v9.6.1-linux-arm64/bin
sudo ln -sf $(pwd)/node /usr/local/bin/node
sudo ln -sf $(pwd)/npm /usr/local/bin/npm



# finally
sudo apt-get upgrade
