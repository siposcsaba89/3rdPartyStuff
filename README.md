# 3rdPrtyStuff building


To build the 3rdPartys we need do the following:

	1. clone this repo:
	
		git clone https://github.com/siposcsaba89/3rdPartyStuff.git
		
	2. Building 3rdParties on Windows:
		a) Open git bash
		b) Building with visual studio run the build_vs.sh script:
			*) ./build_vs.sh [vs2015|vs2015-x86|vs2013|vs2013-x86]
				-) vs2015 - builds the library with 64 bit Visual Studio 2015 comppiler
				-) vs2013 - builds the library with 64 bit Visual Studio 2013 comppiler
				-) vs2015-x86 - builds the library with 32 bit Visual Studio 2015 comppiler
				-) vs2013-x86 - builds the library with 32 bit Visual Studio 2013 comppiler
		c) Building with android NDK (need to set ANDROID_NDK environment variable to point the android-ndk-r## location)
			*) ./build_android.sh [armeabi|armeabi-v7a|arm64-v8a|x86|x86-64]
				-) armeabi - build with the armeabi toolchain (soft float, armv6), 32-bit
				-) armeabi-v7a - build with the armeabi-v7a toolchain (soft float, armv7a), 32-bit
				-) arm64-v8a - build with the arm64-v8a toolchain (soft float, armv8a), 64-bit
				-) x86 - build with the x86 toolchain 32-bit
				-) x86-64 - build with the x86-64 toolchain 64-bit