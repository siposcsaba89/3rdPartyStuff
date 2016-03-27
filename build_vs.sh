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



glfw_FLAGS="-DGLFW_BUILD_EXAMPLES=0 -DGLFW_BUILD_TESTS=0"
projs=""


if [ -z "$AMD_GLES_SDK" ]; then echo "AMD_GLES_SDK is unset"; else echo "AMD_GLES_SDK is set to '$AMD_GLES_SDK'"; fi

if [[ ("$1" == "linux") || !(-z "$AMD_GLES_SDK")]]; then
	glfw_FLAGS="$glfw_FLAGS -DGLFW_CLIENT_LIBRARY=glesv2 -DGLFW_USE_EGL=1"
	projs="glfw freetype"
else
	projs="glfw freetype glew"
fi

glew_FLAGS=""
freetype_FLAGS=""

for proj in $projs
do
	if cd $proj 2> /dev/null; then git pull; cd ..; else git clone https://github.com/siposcsaba89/$proj.git; fi
	cd ../
	mkdir -p build/$1/$proj
	cd build/$1/$proj
	opts=$proj"_FLAGS"
    echo "$proj options are: ${!opts}"
	echo ${!opts}
	cmake ../../../sources/$proj -G "$generator" -DCMAKE_DEBUG_POSTFIX=_d -DCMAKE_INSTALL_PREFIX=$PWD/../../../install/$1/ -DBUILD_SHARED=0 ${!opts} -DCMAKE_BUILD_TYPE=Release
	cmake --build . --config Release --target install
	cmake ../../../sources/$proj -G "$generator" -DCMAKE_BUILD_TYPE=Debug
	cmake --build . --config Debug --target install
	cd ../../../sources
done
