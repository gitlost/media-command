#!/usr/bin/env bash

set -ex

IMAGEMAGICK_VERSION='6.9.8-3'

cd /tmp

curl -O https://www.imagemagick.org/download/ImageMagick-$IMAGEMAGICK_VERSION.tar.gz
tar xvzf ImageMagick-$IMAGEMAGICK_VERSION.tar.gz
cd ImageMagick-$IMAGEMAGICK_VERSION

./configure --prefix=$HOME/opt
make
make install

cd $TRAVIS_BUILD_DIR

ls $HOME/opt

echo "$HOME/opt\n" | pecl install imagick
