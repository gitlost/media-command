#!/usr/bin/env bash

set -ex

if [[ $TRAVIS_SUDO ]]; then
	sudo apt-get -qq update
	sudo apt-get install -y ghostscript
else
	true
fi
