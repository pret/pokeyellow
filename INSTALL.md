# Linux

	sudo apt-get install make gcc bison git python python-pip
	sudo pip install pypng

	git clone https://github.com/bentley/rgbds
	cd rgbds
	sudo make install
	cd ..

	git clone --recursive https://github.com/pret/pokeyellow
	cd pokeyellow

To build **pokeyellow.gbc**:
	make


# Mac

In **Terminal**, run:

	xcode-select --install
	sudo easy_install pypng

	git clone https://github.com/bentley/rgbds
	cd rgbds
	sudo make install
	cd ..

	git clone --recursive https://github.com/pret/pokeyellow
	cd pokeyellow

Copy the ROM "Pokemon Yellow (U) [C][!].gbc" to the same directory as the disassembly under the name "baserom.gbc".

Then run (in the shell):

	make


# Windows

To build on Windows, use [**Cygwin**](http://cygwin.com/install.html). Use the default settings.

In the installer, select the following packages: `make` `git` `python` `gettext`

Then get the most recent version of [**rgbds**](https://github.com/bentley/rgbds/releases/).
Extract the archive and put `rgbasm.exe`, `rgblink.exe` and `rgbfix.exe` in `C:\cygwin\usr\local\bin`.


In the **Cygwin terminal**:

	lynx -source bootstrap.pypa.io/get-pip.py | python
	pip install pypng

	git clone --recursive https://github.com/pret/pokeyellow
	cd pokeyellow

Copy the ROM "Pokemon Yellow (U) [C][!].gbc" to the same directory as the disassembly under the name "baserom.gbc".

Then run (in the Cygwin terminal):

	make
