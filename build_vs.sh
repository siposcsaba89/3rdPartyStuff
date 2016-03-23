#!/bin/bash
set -e

if [ "$#" -ne 1 ]; then
    printf "Illegal number of parameters!\n\n Usage: build_vs.sh [vs2015|vs2015-x86|vs2013|vs2013-x86] \n"
	exit 1
fi

vss="vs2015 vs2015-x86 vs2013 vs2013-x86 linux"
generator="Visual Studio 14 Win64";
if [ "$1" == "vs2015" ]; then
	generator="Visual Studio 14 Win64"
elif [ "$1" == "vs2015-x86" ]; then
	generator="Visual Studio 14"
elif [ "$1" == "vs2013" ]; then
	generator="Visual Studio 12 Win64"
elif [ "$1" == "vs2013-x86" ]; then
	generator="Visual Studio 12"
elif [ "$1" == "linux" ]; then
	generator="Unix Makefiles"
else
	echo "Invalid generator: $1"
	exit 1
fi


mkdir -p sources
cd sources

for proj in glfw glew freetype
do
	if cd $proj 2> /dev/null; then git pull; cd ..; else git clone https://github.com/siposcsaba89/$proj.git; fi
	cd ../
	mkdir -p build/$1/$proj
	cd build/$1/$proj
	cmake ../../../sources/$proj -G "$generator" -DCMAKE_DEBUG_POSTFIX=_d -DCMAKE_INSTALL_PREFIX=$PWD/../../../install/$1/ -DBUILD_SHARED=0 -DCMAKE_BUILD_TYPE=Release
	cmake --build . --config Release --target install
	cmake ../../../sources/$proj -G "$generator" -DCMAKE_BUILD_TYPE=Debug
	cmake --build . --config Debug --target install
	cd ../../../sources
done
