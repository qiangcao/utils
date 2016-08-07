#!/bin/bash

# install environment for go development


export WORKDIR=${1:-`pwd`}
export GOPATH=$HOME/go
export GOROOT=$HOME/goroot
export PATH=$PATH:$HOME/bin:$GOPATH/bin:$GOROOT/bin/

update_repo()
{
  sudo apt-get update
}

configure_go()
{
  # download latest go binary, currently 1.6.3
  mkdir -p $HOME/go $HOME/goroot
  wget https://storage.googleapis.com/golang/go1.6.3.linux-amd64.tar.gz
  tar xf go1.6.3.linux-amd64.tar.gz -C $HOME/goroot
  mv $HOME/goroot/go/* $HOME/goroot/
  cp $WORKDIR/go/bashrc ~/.bashrc
  # install go tools
  go get -u github.com/nsf/gocode
  gocode set propose-builtins true
  gocode close # just in case
}

install_base()
{
  update_repo
  sudo apt-get install -y build-essential cmake make clang
  sudo apt-get install -y python-dev libpython-dev
  sudo apt-get install -y vim git curl wget
  configure_go
}

configure_vim()
{
  mkdir -p ~/.vim/bundle
  if ! [ -d ~/.vim/bundle/Vundle.vim ] ; then
    git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim
  fi
  cp $WORKDIR/go/vimrc ~/.vimrc
  vim +PluginInstall +qall
  vim +GoInstallBinaries +qall
  cd $HOME/.vim/bundle/YouCompleteMe
  python install.py --clang-completer --gocode-completer
  cd $WORKDIR
  cp $WORKDIR/go/ycm_extra_conf.py ~/.vim/.ycm_extra_conf.py
}

install_base
configure_vim
