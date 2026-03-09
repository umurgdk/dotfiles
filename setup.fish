#!/bin/env fish
set DOTPATH $(dirname $(realpath $argv[1]))
echo "DOTPATH=$DOTPATH"

# $1 config name
function link_config
	set name $1
	set path_exists $(test -e $HOME/.config/$name)
	set remove $(test $path_exists -eq 0 && yes_or_no)
	if test $remove -eq 0
		echo "- rm/unlink $name"
		# if test -L $HOME/.config/$name
		# 	unlink $HOME/.config/$name
		# else if test -d $HOME/.config/$name
		# 	rm -rf $HOME/.config/$name
		# else if test -f $HOME/.config/$name
		# 	rm $HOME/.config/$name
		# end
	else if test $path_exists -ne 0
		echo "+ ln -s $DOTPATH/$name $HOME/.config/$name"
	else
		echo ". skip $name"
	end

	# ln -s $HOME/.config/$1 $DOTPATH/$1
end

link_config nvim
