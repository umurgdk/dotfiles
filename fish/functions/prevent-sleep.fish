function prevent-sleep -d "Temporarily set lid close to lock+screen off (no sleep), revert on keypress"
    set -l profiles AC Battery LowBattery
    set -l dbus_dest org.kde.Solid.PowerManagement
    set -l dbus_path /org/kde/Solid/PowerManagement
    set -l group HandleButtonEvents
    set -l key lidAction
    set -l target_action 96 # 32 (lock) + 64 (turn off screen)

    # Save original values
    set -l originals
    for profile in $profiles
        set -l val (kreadconfig6 --file powerdevilrc --group $profile --group $group --key $key 2>/dev/null)
        if test -z "$val"
            set -a originals 1 # default is suspend
        else
            set -a originals $val
        end
    end

    # Apply lock + screen off for all profiles
    for profile in $profiles
        kwriteconfig6 --file powerdevilrc --group $profile --group $group --key $key $target_action
    end
    busctl --user call $dbus_dest $dbus_path $dbus_dest reparseConfiguration

    echo "Lid close set to lock + screen off (no sleep)."
    echo "Press any key to restore original settings..."
    read -n 1 -P ""

    # Restore original values
    for i in (seq (count $profiles))
        kwriteconfig6 --file powerdevilrc --group $profiles[$i] --group $group --key $key $originals[$i]
    end
    busctl --user call $dbus_dest $dbus_path $dbus_dest reparseConfiguration

    echo "Lid close settings restored."
end
