#!/usr/bin/env bash

set -ex

# Install imagick for PHP 5.6, 7.0 and 7.1.
# Taken from http://stackoverflow.com/a/41138688/664741

# ImageMagick version to use for PHP 7.x
IMAGEMAGICK_VERSION='6.9.8-3'

install_imagemagick() {
	cd /tmp

	curl -O https://www.imagemagick.org/download/ImageMagick-$IMAGEMAGICK_VERSION.tar.gz
	tar xzf ImageMagick-$IMAGEMAGICK_VERSION.tar.gz
	cd ImageMagick-$IMAGEMAGICK_VERSION

	./configure --prefix=$HOME/opt/$TRAVIS_PHP_VERSION
	make
	make install

	cd $TRAVIS_BUILD_DIR
}

if [[ ${TRAVIS_PHP_VERSION:0:2} == '7.' ]]; then

	PATH=$HOME/opt/$TRAVIS_PHP_VERSION/bin:$PATH convert -v | grep $IMAGEMAGICK_VERSION || install_imagemagick

	ls $HOME/opt/$TRAVIS_PHP_VERSION

	export LD_FLAGS=-L$HOME/opt/$TRAVIS_PHP_VERSION/lib
	export LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib:$HOME/opt/$TRAVIS_PHP_VERSION/lib
	export CPATH=$CPATH:$HOME/opt/$TRAVIS_PHP_VERSION/include

	echo $HOME/opt/$TRAVIS_PHP_VERSION | pecl install imagick

elif [[ $TRAVIS_PHP_VERSION == 5.6 ]]; then

	echo | pecl install imagick
fi
