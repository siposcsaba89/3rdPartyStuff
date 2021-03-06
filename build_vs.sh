#!/bin/bash
set -e

if [ "$#" -ne 1 ]; then
    printf "Illegal number of parameters!\n\n Usage: build_vs.sh [vs2017|vs2017-x86|vs2015|vs2015-x86|vs2013|vs2013-x86|linux] \n"
	exit 1
fi

vss="vs2015 vs2015-x86 vs2013 vs2013-x86 linux"
generator="Visual Studio 14 Win64";
if [ "$1" == "vs2015" ]; then
	generator="Visual Studio 14 Win64"
elif [ "$1" == "vs2015-x86" ]; then
	generator="Visual Studio 14"
elif [ "$1" == "vs2017" ]; then
	generator="Visual Studio 15 Win64"
elif [ "$1" == "vs2017-x86" ]; then
	generator="Visual Studio 15"
elif [ "$1" == "vs2019" ]; then
	generator="Visual Studio 16"
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


cmake_prefix_path="-DCMAKE_PREFIX_PATH=$PWD/install/$1"
echo "Cmake prefix path set to $cmake_prefix_path"

#apt install nasm libgles2-mesa-dev libxcursor-dev libxinerama-dev libxrandr-dev
mkdir -p sources
cd sources



if [ -z "$AMD_GLES_SDK" ]; then echo "AMD_GLES_SDK is unset"; else echo "AMD_GLES_SDK is set to '$AMD_GLES_SDK'"; fi

if [[ ("$1" == "linux") || !(-z "$AMD_GLES_SDK")]]; then
	glfw_FLAGS="-DGLFW_CLIENT_LIBRARY=glesv2 -DGLFW_USE_EGL=1"
	projs="glfw zlib freetype imgui libjpeg-turbo libexpat adobe_xmp dng_sdk eigen"
	#projs="adobe_xmp dng_sdk eigen"
        #assimp
else
	projs="glfw zlib freetype glew imgui libjpeg-turbo libexpat adobe_xmp dng_sdk eigen"
fi

glew_FLAGS=""
freetype_FLAGS="$cmake_prefix_path"
glfw_FLAGS="$glfw_FLAGS -DGLFW_BUILD_EXAMPLES=0 -DGLFW_BUILD_TESTS=0"
assimp_FLAGS="-DBUILD_EXAMPLES=0 -DBUILD_TESTING=0 $cmake_prefix_path -DASSIMP_BUILD_ASSIMP_TOOLS=0"
libjpeg_turbo_FLAGS="-DCMAKE_DEBUG_POSTFIX=_d -DENABLE_SHARED=0"
libexpat_CMAKELIST="../../../sources/libexpat/expat/"
libexpat_FLAGS="-DBUILD_shared=0 -DCMAKE_DEBUG_POSTFIX=_d"
adobe_xmp_ORIGIN="https://github.com/siposcsaba89/adobe_xmp.git"
adobe_xmp_FLAGS="-DXMP_BUILD_STATIC=1 -DCMAKE_DEBUG_POSTFIX=_d"
adobe_xmp_CMAKELIST="../../../sources/adobe_xmp/build/"
dng_sdk_ORIGIN="https://github.com/siposcsaba89/dng_sdk.git"
dng_sdk_FLAGS="-DBUILD_EXAMPLES=1 -DCMAKE_DEBUG_POSTFIX=_d"
eigen_ORIGIN="https://siposcsaba89.visualstudio.com/DefaultCollection/_git/eigen"
eigen_FLAGS="-DBUILD_TESTING=1 -DCMAKE_DEBUG_POSTFIX=_d"

for proj in $projs
do
    proj_orig=$(echo $proj | tr - _)"_ORIGIN";
    if [ -z "${!proj_orig}" ]; then
        proj_ORIGIN=" https://github.com/siposcsaba89/$proj.git"
    else
        proj_ORIGIN="${!proj_orig}"
    fi
    echo "Origin: $proj_ORIGIN"
    
	if cd $proj 2> /dev/null; then git pull; cd ..; else git clone $proj_ORIGIN; fi
	cd ../
	mkdir -p build/$1/$proj
	cd build/$1/$proj
	opts="$proj""_FLAGS"
    opts=$(echo $opts | tr - _)
    echo "$proj options are: ${!opts}"
	echo ${!opts}
    
    cmake_source=$(echo $proj | tr - _)"_CMAKELIST";
    if [ -z "${!cmake_source}" ]; then
        proj_CMAKELIST="../../../sources/$proj/"
    else
        proj_CMAKELIST="${!cmake_source}"
    fi
    echo $proj_CMAKELIST
	cmake $proj_CMAKELIST -G "$generator" -DCMAKE_DEBUG_POSTFIX=_d -DCMAKE_INSTALL_PREFIX=$PWD/../../../install/$1/ -DCMAKE_PREFIX_PATH=$PWD/../../../install/$1/ -DBUILD_SHARED=0 ${!opts} -DCMAKE_BUILD_TYPE=Release
	cmake --build . --config Release --target install
	cmake $proj_CMAKELIST -G "$generator" -DCMAKE_BUILD_TYPE=Debug
	cmake --build . --config Debug --target install
	cd ../../../sources
done
