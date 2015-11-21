sed -i 's/\<'$1'\>/'$2'/' $(git grep -l $1 -- "*.asm")
# $1: phrase to find
# $2: phrase to replace $1