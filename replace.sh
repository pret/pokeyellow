sed -i 's/\<'$1'\>/'$2'/' $(grep -lwr --include "*.asm" --exclude-dir=".git" --exclude-dir="extras" --exclude-dir="pic" --exclude-dir="gfx" $1)
# $1: phrase to find
# $2: phrase to replace $1