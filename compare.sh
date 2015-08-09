#!/bin/sh
# Compares baserom.gbc and pokeyellow.gbc

# create baserom.txt if necessary
if [ ! -f baserom.txt ]; then
    hexdump -C baserom.gbc > baserom.txt
fi

hexdump -C pokeyellow.gbc > pokeyellow.txt

diff -u baserom.txt pokeyellow.txt | less