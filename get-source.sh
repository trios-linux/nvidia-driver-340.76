#!/bin/bash
#
# Fetches and extracts specified XFCE 4.12 source package, allowing
# us to keep only /debian for it in git.
#
# 2015 Filip Danilovic <filip@openmailbox.org>


# Set the package version and name:
NAME=nvidia-graphics-drivers
NAME_DEBIAN=
VER=340.76
PKG=$NAME_$VER.orig.tar.gz

# Set the directory in which to download/extract
# This is meant for workspace/build dir on Jenkins!
DIR=jenkins-build


# If directory is set and exists, change to it.

if [ -z $DIR ] && [ -d $DIR ];
then
	cd $DIR
fi


# If no argument is given, default to just downloading the package.

if [ ! -f $PKG ]; 
then
	wget http://ftp.de.debian.org/debian/pool/non-free/n/nvidia-graphics-drivers/$PKG
else
	echo "$PKG exists, skipping download"
fi


# If argument is "-x", download and extract package.

if [ "$1" = "-x" ];
then
	if [ ! -f $PKG ]; 
	then
		wget http://ftp.de.debian.org/debian/pool/non-free/n/nvidia-graphics-drivers/$PKG
	else
		echo "$PKG exists, skipping download"
	fi
	tar xvjf $PKG --strip 1
fi


# If arguments are "-x" & "-r", download, extract and remove package.
# Might be needed to prevent dpkg from complaining during package building.

if [ "$1" = "-x" ] && [ "$2" = "-r" ];
then
	if [ ! -f $PKG ]; 
	then
		wget http://ftp.de.debian.org/debian/pool/non-free/n/nvidia-graphics-drivers/$PKG
	else
		echo "$PKG found, skipping download"
	fi
	tar xvjf $PKG --strip 1 && rm -v $PKG
fi


# If arguments are "-x" & "-m", download, extract and move package. Also remove self & Readme.md.
# This is what we use for Jenkins build.

if [ "$1" = "-x" ] && [ "$2" = "-m" ];
then
	if [ ! -f $PKG ]; 
	then
		wget http://ftp.de.debian.org/debian/pool/non-free/n/nvidia-graphics-drivers/$PKG
	else
		echo "$PKG found, skipping download"
	fi
	tar xvjf $PKG --strip 1 && mv -f -v $PKG ../$PKG && rm -f ./README.md && rm -f -- "$0"
fi
