switch_lights()
{
	scheme=$1
	case "$scheme" in
		dark)
			echo dark > ~/.interface_style
			ln -sf $HOME/.config/alacritty/dark.toml /home/umurgdk/.config/alacritty/alacritty.toml
			plasma-apply-colorscheme BreezeDark >/dev/null
			exit;;
		light)
			echo light > ~/.interface_style
			ln -sf $HOME/.config/alacritty/light.toml /home/umurgdk/.config/alacritty/alacritty.toml
			plasma-apply-colorscheme BreezeLight >/dev/null
			exit;;
	esac
}

if [ -z "$1" ]; then
	current_time=$(date +%H:%M)
	if [[ "$current_time" > "18:15" ]]; then
		switch_lights dark
	else
		switch_lights light
	fi
else
	switch_lights $1
fi
