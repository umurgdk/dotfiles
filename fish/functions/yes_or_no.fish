function yes_or_no
	while true
		read -l -P "$argv [Y/n]: " yn
		switch $yn
			case Y y
				return 0
			case N n
				return 1
			case '*'
				return 0
		end
	end
end
