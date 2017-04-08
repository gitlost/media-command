#!/usr/bin/env bash

set -ex

# Taken from http://stackoverflow.com/a/41138688/664741

IMAGEMAGICK_VERSION='6.9.8-3'

install_imagemagick() {
	cd /tmp

	curl -O https://www.imagemagick.org/download/ImageMagick-$IMAGEMAGICK_VERSION.tar.gz
	tar xzf ImageMagick-$IMAGEMAGICK_VERSION.tar.gz
	cd ImageMagick-$IMAGEMAGICK_VERSION

	./configure --prefix=$HOME/opt
	make
	make install

	cd $TRAVIS_BUILD_DIR
}

PATH=$HOME/opt/bin:$PATH convert -v | grep $IMAGEMAGICK_VERSION || install_imagemagick

ls $HOME/opt

export LD_FLAGS=-L$HOME/opt/lib
export LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib:$HOME/opt/lib
export CPATH=$CPATH:$HOME/opt/include

echo $HOME/opt | pecl install imagick
