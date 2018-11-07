#!/bin/bash
# I run this script to quickly configure my orangepi zero plus and construct ML environment

if (( $EUID != 0  )); then
        echo "run as root please"
            exit
        fi

srcfiledir=https://raw.githubusercontent.com/hankso/OrangePi-BuildML/master
dotfiledir=https://raw.githubusercontent.com/hankso/dotfiles/master

mkhomedirs () {
    cd ~ && echo "Building home folders structures"
    mkdir -p \
        document \
        notebook \
        .pip \
        .vim/bundle \
        .vim/dirs/backups
}

dldotfiles () {
    echo "Downloading useful dotfiles"
    mv ~/.zshrc  ~/.zshrc.old  2> /dev/null
    mv ~/.bashrc ~/.bashrc.old 2> /dev/null
    mv ~/.vimrc  ~/.vimrc.old  2> /dev/null
    wget ${dotfiledir}/zshrc    -O ~/.zshrc
    wget ${dotfiledir}/pip.conf -O ~/.pip/pip.conf
    wget ${dotfiledir}/bashrc   -O ~/.bashrc && source ~/.bashrc
    wget ${dotfiledir}/vimrc    -O ~/.vimrc  && git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/
}

dlpackages () {
    # set mirror url and refresh package list
    echo "APT update and upgrade installed packages"
    mv /etc/apt/sources.list /etc/apt/sources.list.old 2> /dev/null
    wget ${dotfiledir}/sources.list -O /etc/apt/sources.list && apt-get update && apt-get upgrade

    # install pip and many packages by apt & pip
    echo "Installing packages"
    cd /tmp
    wget https://bootstrap.pypa.io/get-pip.py  && python2 get-pip.py
    wget ${srcfiledir}/files/apt-install.list  && apt-get install -y $(cat apt-install.list 2> /dev/null)
    pip install tensorflow scipy pillow reportlab pylsl -i ${srcfiledir}/wheels
    wget ${srcfiledir}/files/requirements.txt  && pip install -r requirements.txt 2> /dev/null
    cd
    # Tensorflow is so so different from other packages, it's hard to install
    # I failed by simply typing `pip install tensorflow` and `apt install python-tensorflow`
    # which should work at most situations(my orangepi zero plus is ARMv8 aarch64 architecture)
    # TF depends on many compiled libs, but compile with bazel is difficult and slow and need luck
}

others () {
    # nice tool for accessing your pi in different LAN
    cd ~/document
    wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip
    unzip ngrok-stable-linux-arm.zip && rm ngrok-stable-linux-arm.zip
    chmod +x ngrok && ln -sf $(pwd)/ngrok /usr/local/bin/ngrok
}


if [ "${1}" == "--source-only" ]; then
    echo "Defined function:"
    echo "    mkhomedirs"
    echo "    dldotfiles"
    echo "    dlpackages"
    echo "    others"
    echo "You may use them now."
else
    mkhomedirs
    dldotfiles
    dlpackages
    others
fi
