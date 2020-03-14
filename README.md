# 3rdPrtyStuff building

This repository is a collection of multiple 3rdparty repositories as 
git submodules.

Prerequisites: 

	cmake 3.13 or later
	git 2.7 or later


An example to build the 3rdPartys with Ninja in Debug configuration:

	1. clone this repo:
	
		git clone https://github.com/siposcsaba89/3rdPartyStuff.git
		
    2. cd 3rdPartyStuff
    3. git submodule update --init
    4. mkdir b
    5. cd b
    6. cmake .. -G "Ninja" -DCMAKE_INSTALL_PREFIX=./install -DCMKE_BUILD_TYPE="Debug"
    7. cmake --build . --target install