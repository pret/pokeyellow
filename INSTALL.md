# Linux

	sudo apt-get install make gcc bison git python

	git clone https://github.com/bentley/rgbds
	sudo make -C rgbds install

	git clone --recursive https://github.com/pret/pokeyellow
	cd pokeyellow

To build **pokeyellow.gbc**:

	make


# Mac

In **Terminal**, run:

	xcode-select --install

	git clone https://github.com/bentley/rgbds
	sudo make -C rgbds install

	git clone --recursive https://github.com/pret/pokeyellow
	cd pokeyellow

Then run (in the shell):

	make


# Windows

To build on Windows, use [**Cygwin**](http://cygwin.com/install.html). Use the default settings in the installer.

In the installer, select the following packages: `make` `git` `python` `gettext`

Then get the most recent version of [**rgbds**](https://github.com/bentley/rgbds/releases/).
Extract the archive and put `rgbasm.exe`, `rgblink.exe` and `rgbfix.exe` in `C:\cygwin\usr\local\bin`.

In the **Cygwin terminal**:

	git clone --recursive https://github.com/pret/pokeyellow
	cd pokeyellow

Then run (in the Cygwin terminal):

	make
