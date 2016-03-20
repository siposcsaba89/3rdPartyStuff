#!/bin/bash
set -e

if [ "$#" -ne 1 ]; then
    printf "Illegal number of parameters!\n\n Usage: build_vs.sh [vs2015|vs2015-x86|vs2013|vs2013-x86] \n"
	exit 1
fi

vss="vs2015 vs2015-x86 vs2013 vs2013-x86"
generator="Visual Studio 14 Win64";
if [ "$1" == "vs2015" ]; then
	generator="Visual Studio 14 Win64"
elif [ "$1" == "vs2015-x86" ]; then
	generator="Visual Studio 14"
elif [ "$1" == "vs2013" ]; then
	generator="Visual Studio 12 Win64"
elif [ "$1" == "vs2013-x86" ]; then
	generator="Visual Studio 12"
else
	echo "Invalid generator: $1"
	exit 1
fi


mkdir -p sources
cd sources

for proj in glfw glew freetype
do
	if cd $proj 2> /dev/null; then git pull; cd ..; else git clone https://github.com/siposcsaba89/$proj.git; fi
	cd $proj
	mkdir -p build_$1
	cd build_$1
	cmake .. -G "$generator" -DCMAKE_DEBUG_POSTFIX=_d -DCMAKE_INSTALL_PREFIX=$PWD/../../../install/$1/ -DBUILD_SHARED=0
	cmake --build . --config Release --target install
	cmake --build . --config Debug --target install
	cd ../../
done
