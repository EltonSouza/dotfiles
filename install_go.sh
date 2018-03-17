#!/bin/bash
wget https://storage.googleapis.com/golang/go1.10.linux-amd64.tar.gz
sudo tar -zxvf go1.10.linux-amd64.tar.gz -C /usr/local/
rm go1.10.linux-amd64.tar.gz
export GOROOT=/usr/local/go
export GOPATH=$HOME/gocode
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
go get -u github.com/derekparker/delve
go get -u golang.org/x/tools/cmd/present
