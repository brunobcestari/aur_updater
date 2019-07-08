#!/bin/sh

FILE_PATH="$HOME/Aur_Packages"

for BASEDIR in $(ls $FILE_PATH); do
	cd $FILE_PATH/$BASEDIR
	OUTPUT=$(git pull)
	if [ "$OUTPUT" == "Already up to date." ]; then
		echo "Repository of $BASEDIR already up to date."
	else
		echo "Repository of $BASEDIR updated."
	fi
	PKGNAME=$(cat PKGBUILD | grep "pkgname=" | head -1 | cut -f2 -d"=" | sed "s/'//g")
	LAST_VER=$(cat PKGBUILD | grep "pkgver=" | head -1 | cut -f2 -d"=")
	ACTUAL_VER=$(pacman -Qem | grep $PKGNAME" " | cut -f2 -d" " | cut -f2 -d" " | cut -f1 -d"-")
	echo "Last version: $LAST_VER"
	echo "Actual version: $ACTUAL_VER"

	if [ "$LAST_VER" != "$ACTUAL_VER" ]; then
		makepkg -si
	else
		echo "$PKGNAME already up to date"
	fi

	echo
	cd ..
done
