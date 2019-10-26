#!/bin/bash

#i686-linux-gnu
if [[ -z "$@" ]]
then
	echo "No platforms specified."
	echo
	echo Example:
	echo "	kcct i686-linux-gnu i686-w64-mingw32 x86_64-linux-gnu x86_64-w64-mingw32"
fi

if [ -f kcct-pre.sh ]
then
	source ./kcct-pre.sh
fi

if [ -f kcct-args.txt ]
then
	KCCT_ARGS0=`cat ./kcct-args.txt`
fi

OLD_CXXFLAGS=$CXXFLAGS
OLD_CFLAGS=$CFLAGS
OLD_LDFLAGS=$LDFLAGS

unset CXXFLAGS
unset CFLAGS
unset LDFLAGS

for PLAT in "$@"
do
	if [[ $PLAT == *"i686"* ]]
	then
	  K_CXXFLAGS="-m32 $OLD_CXXFLAGS"
	  K_CFLAGS="-m32 $OLD_CFLAGS"	
	  K_LDFLAGS="-m32 $OLD_LDFLAGS"
	else
	  K_CXXFLAGS="$OLD_CXXFLAGS"
	  K_CFLAGS="$OLD_CFLAGS"	
	  K_LDFLAGS="$OLD_LDFLAGS"
	fi

	export PREFIX=$HOME/.kcct/$PLAT
	
	K_CXXFLAGS=$(eval echo $K_CXXFLAGS)
	K_CFLAGS=$(eval echo $K_CFLAGS)
	K_LDFLAGS=$(eval echo $K_LDFLAGS)

	KCCT_ARGS=$(eval echo $KCCT_ARGS0)

	make clean

	echo
	echo --------------------------------------
	echo Building for $PLAT
	echo CXXFLAGS: $K_CXXFLAGS
	echo CFLAGS:   $K_CFLAGS
	echo LDFLAGS:  $K_LDFLAGS
	echo additional parameters: $KCCT_ARGS
	echo --------------------------------------
	./configure --host=$PLAT --prefix=$PREFIX $KCCT_ARGS "CXXFLAGS=$K_CXXFLAGS" "CFLAGS=$K_CFLAGS" "LDFLAGS=$K_LDFLAGS" \
		&& make clean \
		&& make -j4\
		&& make install || exit 1
done

