switch_lights()
{
	scheme=$1

	echo "$scheme" > ~/.interface_style


	case "$scheme" in
		dark) 
			zellij_theme="catppuccin-macchiato";;
		light)
			zellij_theme="catppuccin-latte";;
	esac

	zellij_config="$HOME/.config/zellij/config.kdl"
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
