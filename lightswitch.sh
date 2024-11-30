switch_lights()
{
	scheme=$1
	alacritty_config="${scheme}.toml"
	case "$(uname -s)" in
		Darwin*)
			alacritty_config="${scheme}_macos.toml";;
		*)
			case "$scheme" in
				dark)
					plasma-apply-colorscheme BreezeDark >/dev/null;;
				light)
					plasma-apply-colorscheme BreezeLight >/dev/null;;
			esac;;
	esac

	echo "alacritty_config=${alacritty_config}"
	echo "$scheme" > ~/.interface_style
	ln -sf $HOME/.config/alacritty/${alacritty_config} $HOME/.config/alacritty/alacritty.toml
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
