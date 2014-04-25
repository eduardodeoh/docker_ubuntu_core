#!/bin/bash

#Based on https://github.com/ibuildthecloud/docker-ubuntu-core

UBUNTU_VERSION=14.04

ARCH=amd64

FILE=ubuntu-core-${UBUNTU_VERSION}-core-${ARCH}.tar.gz

URL=http://cdimage.ubuntu.com/ubuntu-core/releases/${UBUNTU_VERSION}/release/${FILE}

SHA256SUMURL=http://cdimage.ubuntu.com/ubuntu-core/releases/${UBUNTU_VERSION}/release/SHA256SUMS

#MAC OS
SHASUM="shasum -a 256 -c"

#Linux
#SHASUM=$(sha256sum -c)

function check() {
  grep $FILE SHA256SUMS | $SHASUM
}

if [ -f SHA256SUMS ]
then
  rm -f SHA256SUMS
fi

wget $SHA256SUMURL

if [ -e $FILE ]
then
  if ! check
  then
    rm -f $FILE
  fi
fi

if [ ! -e $FILE ]
then
  wget $URL
  check
fi

#Import ubuntu core to your local docker repository
cat $FILE | sudo docker.io import - eduardodeoh/ubuntu_core:${UBUNTU_VERSION}

#Docker push your new image to Docker Registry
#docker push eduardodeoh/ubuntu_core
