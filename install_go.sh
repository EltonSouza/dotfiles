#!/bin/bash
wget https://storage.googleapis.com/golang/go1.12.5.linux-amd64.tar.gz
sudo tar -zxvf go1.12.5.linux-amd64.tar.gz -C /usr/local/
rm go1.12.5.linux-amd64.tar.gz
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
go get -u github.com/derekparker/delve
go get -u golang.org/x/tools/cmd/present
