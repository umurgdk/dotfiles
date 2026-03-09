function xwayland-windows
    for window in (niri msg --json windows | jq -c '.[]')
        set pid (echo $window | jq '.pid')
        set title (echo $window | jq -r '.title')
        set exe (readlink /proc/$pid/exe 2>/dev/null)
        if string match -q "*xwayland-satellite*" $exe
            echo $title
        end
    end
end

