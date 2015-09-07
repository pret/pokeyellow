# Linux

	sudo apt-get install make gcc bison git python python-setuptools
	sudo easy_install pypng

	git clone git://github.com/bentley/rgbds.git
	cd rgbds
	sudo make install
	cd ..

	git clone --recursive git://github.com/luckytyphlosion/pokeyellow.git
	cd pokeyellow

To build **pokeyellow.gbc**:
	make


# Mac

In the shell, run:

	xcode-select --install
	sudo easy_install pypng

	git clone git://github.com/bentley/rgbds.git
	cd rgbds
	sudo make install
	cd ..

	git clone --recursive git://github.com/luckytyphlosion/pokeyellow.git
	cd pokeyellow

Copy the ROM "Pokemon Yellow (U) [C][!].gbc" to the same directory as the disassembly under the name "baserom.gbc".

Then run (in the shell):

	make


# Windows

To build on Windows, use [**Cygwin**](http://cygwin.com/install.html) (32-bit).

In the installer, select the following packages: `make` `git` `gettext` `python` `python-setuptools`

Then get the most recent version of [**rgbds**](https://github.com/bentley/rgbds/releases/).
Put `rgbasm.exe`, `rgblink.exe` and `rgbfix.exe` in `C:\cygwin\usr\local\bin`.


In the **Cygwin terminal**:

	easy_install pypng
	git clone --recursive git://github.com/luckytyphlosion/pokeyellow.git
	cd pokeyellow

Copy the ROM "Pokemon Yellow (U) [C][!].gbc" to the same directory as the disassembly under the name "baserom.gbc".

Then run (in the Cygwin terminal):

	make
