#!/bin/sh

FILE_PATH="$HOME/Aur_Packages"

for files in $(ls $FILE_PATH); do
	cd $FILE_PATH/$files
	OUTPUT=$(git pull)
	if [ "$OUTPUT" == "Already up to date." ]; then
		echo "$files already up to date."
	else
		echo "$files updated."
	fi
	LAST_VER=$(cat PKGBUILD | grep "pkgver=" | head -1 | cut -f2 -d"=")
	ACTUAL_VER=$(pacman -Qem | grep $files" " | cut -f2 -d" " | cut -f2 -d" " | cut -f1 -d"-")
	echo "Last version: $LAST_VER"
	echo "Actual version: $ACTUAL_VER"

	if [ "$LAST_VER" != "$ACTUAL_VER" ]; then
		makepkg -si
	else
		echo "$files already up to date"
	fi

	echo
	cd ..
done
