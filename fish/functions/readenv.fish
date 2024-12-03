function readenv --on-variable PWD
    if test -r .env
        for line in (cat .env)
            set line (string trim $line)
            if test -z $line 
                or string match -q "#*" $line
                continue
            end

            set key_value (string split -m 1 = $line)
            set key (string trim $key_value[1])
            set value (string trim $key_value[2])

            set -gx $key $value
        end
    end
end
