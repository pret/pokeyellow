sed -i 's/\<'$1'\>/'$2'/' $(grep -lwr --include "*.asm" $1)
# $1: phrase to find
# $2: phrase to replace $1