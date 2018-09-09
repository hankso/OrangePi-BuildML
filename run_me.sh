#!/bin/bash
# I run this script to quickly configure my orangepi zero plus and construct ML environment

# *****only for python 2.7*****

# network
sudo nmtui



srcfiledir=https://raw.githubusercontent.com/hankso/OrangePi-BuildML/master
dotfiledir=https://raw.githubusercontent.com/hankso/dotfiles/master



# dirs
cd ~
mkdir -p document notebook .pip .vim/bundle .vim/dirs/backups 



# dotfiles
mv ~/.bashrc ~/.bashrc.old 2> /dev/null
mv ~/.vimrc  ~/.vimrc.old  2> /dev/null
wget ${dotfiledir}/bashrc   -O ~/.bashrc && source ~/.bashrc
wget ${dotfiledir}/vimrc    -O ~/.vimrc  && git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/ 2> /dev/null
wget ${dotfiledir}/pip.conf -O ~/.pip/pip.conf



# set mirror url and refresh package list
sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak
sudo wget ${dotfiledir}/sources.list -O /etc/apt/sources.list
sudo apt-get update && sudo apt-get upgrade

# install pip and many packages by apt & pip
cd /tmp
wget https://bootstrap.pypa.io/get-pip.py  && sudo python2 get-pip.py
wget ${srcfiledir}/files/apt-install.list  && sudo apt-get install -y $(cat apt-install.list 2> /dev/null)
sudo pip install tensorflow scipy pillow reportlab pylsl -i ${srcfiledir}/wheels
wget ${srcfiledir}/files/requirements.txt  && sudo pip install -r requirements.txt 2> /dev/null

cd ~


# Tensorflow is so so different from other packages, it's hard to install
# I failed by simply typing `pip install tensorflow` and `apt install python-tensorflow`
# which should work at most situations(my orangepi zero plus is ARMv8 aarch64 architecture)
# TF depends on many compiled libs, but compile with bazel is difficult and slow and need luck


# nice tool for accessing your pi in different LAN
cd ~/document
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip
unzip ngrok-stable-linux-arm.zip
rm ngrok-stable-linux-arm.zip
chmod +x ngrok
sudo ln -sf $(pwd)/ngrok /usr/local/bin/ngrok

