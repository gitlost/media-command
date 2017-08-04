#!/usr/bin/env bash

set -ex

if [[ ! $TRAVIS_SUDO ]]; then
	return true
fi
sudo apt-get -qq update
sudo apt-get install -y ghostscript
