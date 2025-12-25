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

	zellij_config="$HOME/.config/zellij/config.kdl"
	echo "$scheme" > ~/.interface_style
	ln -sf $HOME/.config/alacritty/${alacritty_config} $HOME/.config/alacritty/alacritty.toml

	case "$scheme" in
		dark) 
			zellij_theme="$(sed -nE 's/.*\$lightswitch ([^\s]+) ([^\s]+)/\2/p' $zellij_config)";;
		light)
			zellij_theme="$(sed -nE 's/.*\$lightswitch ([^\s]+) ([^\s]+)/\1/p' $zellij_config)";;
	esac

	sed -E -i.bak "s/theme \"[^\"]+\"/theme \"$zellij_theme\"/" $zellij_config
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
