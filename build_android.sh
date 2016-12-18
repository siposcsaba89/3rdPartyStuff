#!/bin/bash
set -e

if [ "$#" -ne 1 ]; then
    printf "Illegal number of parameters!\n\n Usage: build_vs.sh [armeabi|armeabi-v7a|arm64-v8a|x86-64|x86] \n"
	exit 1
fi


mkdir -p sources
cd sources

assimp_FLAGS="-DASSIMP_BUILD_ASSIMP_TOOLS=0"

for proj in freetype assimp
do
	if cd $proj 2> /dev/null; then git pull; cd ..; else git clone https://github.com/siposcsaba89/$proj.git; fi
    cd ../
	mkdir -p build/$1/$proj
	cd build/$1/$proj
	opts=$proj"_FLAGS"
    echo "$proj options are: ${!opts}"
	echo ${!opts}
	cmake ../../../sources/$proj -G "MinGW Makefiles" -DCMAKE_TOOLCHAIN_FILE=../../../cmake/toolchain/android.toolchain.cmake -DCMAKE_SYSTEM_NAME=windows -DCMAKE_DEBUG_POSTFIX=_d -DCMAKE_INSTALL_PREFIX=$PWD/../../../install/$1/ -DBUILD_SHARED=0 -DCMAKE_MAKE_PROGRAM="$ANDROID_NDK/prebuilt/windows-x86_64/bin/make" -DANDROID_STL=gnustl_static -DANDROID_ABI=$1 -DANDROID_STL=gnustl_static -DCMAKE_BUILD_TYPE=Debug ${!opts}
	MAKEFLAGS=-j4 cmake --build . --target install
	cmake ../../../sources/$proj -DCMAKE_BUILD_TYPE=Release
	MAKEFLAGS=-j4 cmake --build . --config Debug --target install
	cd ../../../sources
done
