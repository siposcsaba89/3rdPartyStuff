# 3rdPrtyStuff building

Prerequisites: 

	cmake 3.0 or later
	git 2.7 or later
	For windows builds: Visual studio 2015 or 2013
	For android build on Windows : android-ndk-r9c or later

Note: the armeabi toolchain is buggy in the ndk-r10, r11 versions and not working on phones
	running android 2.1

To build the 3rdPartys we need do the following:

	1. clone this repo:
	
		git clone https://github.com/siposcsaba89/3rdPartyStuff.git
		
	2. Building 3rdParties on Windows:
		a) Open git bash
		b) Building with visual studio run the build_vs.sh script:
			*) ./build_vs.sh [vs2017|vs2017-x86|vs2015|vs2015-x86|vs2013|vs2013-x86|linux]
				-) vs2017 - builds the library with 64 bit Visual Studio 2017 comppiler
				-) vs2017-x86 - builds the library with 32 bit Visual Studio 2017 comppiler
				-) vs2015 - builds the library with 64 bit Visual Studio 2015 comppiler
				-) vs2013 - builds the library with 64 bit Visual Studio 2013 comppiler
				-) vs2015-x86 - builds the library with 32 bit Visual Studio 2015 comppiler
				-) vs2013-x86 - builds the library with 32 bit Visual Studio 2013 comppiler
				-) linux - generate Unix makefile
		c) Building with android NDK (need to set ANDROID_NDK environment variable to point the android-ndk-r## location)
			*) ./build_android.sh [armeabi|armeabi-v7a|arm64-v8a|x86|x86_64]
				-) armeabi - build with the armeabi toolchain (soft float, armv6), 32-bit
				-) armeabi-v7a - build with the armeabi-v7a toolchain (soft float, armv7a), 32-bit
				-) arm64-v8a - build with the arm64-v8a toolchain (soft float, armv8a), 64-bit
				-) x86 - build with the x86 toolchain 32-bit
				-) x86-64 - build with the x86-64 toolchain 64-bit
	3. Building on Ubuntu 18.04
		a) These packages need to be installed: libxrandr-dev libxinerama-dev libxcursor-dev nasm
