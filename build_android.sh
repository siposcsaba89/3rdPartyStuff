#!/bin/bash
set -e

if [ "$#" -ne 1 ]; then
    printf "Illegal number of parameters!\n\n Usage: build_vs.sh [armeabi|armeabi-v7a|arm64-v8a|x86-64|x86] \n"
	exit 1
fi


mkdir -p sources
cd sources

for proj in freetype
do
	if cd $proj 2> /dev/null; then git pull; cd ..; else git clone https://github.com/siposcsaba89/$proj.git; fi
	cd $proj
	mkdir -p build_$1
	cd build_$1
	cmake .. -G "MinGW Makefiles" -DCMAKE_TOOLCHAIN_FILE=../../../cmake/toolchain/android.toolchain.cmake -DCMAKE_SYSTEM_NAME=windows -DCMAKE_DEBUG_POSTFIX=_d -DCMAKE_INSTALL_PREFIX=$PWD/../../../install/$1/ -DBUILD_SHARED=0 -DCMAKE_MAKE_PROGRAM="$ANDROID_NDK/prebuilt/windows-x86_64/bin/make" -DANDROID_STL=gnustl_static -DANDROID_ABI=$1 -DANDROID_STL=gnustl_static -DCMAKE_BUILD_TYPE=Debug
	MAKEFLAGS=-j4 cmake --build . --target install
	cmake .. -DCMAKE_BUILD_TYPE=Release
	MAKEFLAGS=-j4 cmake --build . --config Debug --target install
	cd ../../
done
