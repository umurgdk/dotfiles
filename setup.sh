#!/bin/env fish
DOTPATH=$(dirname $(realpath $0))

function yes_or_no () {
	while true; do
		read -p "$* [y/n]: " yn
		case $yn in
			[Yy]*) return 0 ;;
			[Nn]*) return 1 ;;
		esac
	done
}

# $1 config name
function link_config () {
	local name=$1
	local path_exists=[ -e $HOME/.config/$name ]



	if [ -L $HOME/.config/$name ]; then
		unlink $HOME/.config/$name
	elif [ -f $HOME/.config/$name ]; then
		rm $HOME/.config/$name
	elif [ -e $HOME/.config/$name ]; then
		rm -rf $HOME/.config/$name
	fi

	ln -s $HOME/.config/$1 $DOTPATH/$1
}

link_config nvim
