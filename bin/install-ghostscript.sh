#!/usr/bin/env bash

if [[ ! $TRAVIS_SUDO ]]; then
	return true
fi

set -ex

sudo apt-get -qq update
sudo apt-get install -y ghostscript
