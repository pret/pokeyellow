sed -i 's/\<foo\>/bar/' $(git grep -l foo)
# foo: phrase to find
# bar: phrase to replace foo