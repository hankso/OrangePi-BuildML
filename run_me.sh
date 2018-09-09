#!/bin/bash
# I run this script to quickly configure my orangepi zero plus and construct ML environment

# *****only for python 2.7*****

# network
sudo nmtui



srcfiledir=https://raw.githubusercontent.com/hankso/OrangePi-BuildML/master/files
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
wget https://bootstrap.pypa.io/get-pip.py            && sudo python2 get-pip.py
wget ${srcfiledir}/apt-install.list                  && sudo apt-get install -y $(cat apt-install.list 2> /dev/null)

sudo pip install ${srcfiledir}/tensorflow-1.2.1-cp27-cp27mu-linux_aarch64.whl \
                 ${srcfiledir}/scipy-1.2.0.dev0+994e74b-cp27-cp27mu-linux_aarch64.whl \
                 ${srcfiledir}/reportlab-3.5.7-cp27-cp27mu-linux_aarch64.whl

wget ${srcfiledir}/requirements.txt                  && sudo pip install -r requirements.txt 2> /dev/null
wget ${srcfiledir}/liblsl64.so.1.4.0                 && sudo cp liblsl64.so.1.4.0 /usr/local/lib/python2.7/dist-packages/pylsl/liblsl64.so

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


# NodeJS is useful for me, if you don't need it just comment these lines
# wget https://nodejs.org/dist/v9.6.1/node-v9.6.1-linux-arm64.tar.gz
# tar xzf node-v9.6.1-linux-arm64.tar.gz
# rm node-v9.6.1-linux-arm64.tar.gz
# cd node-v9.6.1-linux-arm64/bin
# sudo ln -sf $(pwd)/node /usr/local/bin/node
# sudo ln -sf $(pwd)/npm /usr/local/bin/npm
