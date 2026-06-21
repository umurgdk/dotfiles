if status is-interactive
    # Commands to run in interactive sessions can go here
end

set eza_comm --icons=always --group-directories-first
set eza_short --no-user --no-time --no-permissions

alias l="eza -1 $eza_comm"
alias ls="eza -x $eza_comm"

alias ll="eza -l $eza_comm $eza_short"
alias lt="eza -lT $eza_comm $eza_short"

alias llx="eza -l $eza_comm"
alias ltx="eza -lT $eza_comm"

alias less="nvim -R -c 'nnoremap q :q!<CR>' -"
alias grep="rg"
alias cat="bat"
alias http="xh"
alias https="xhs"

alias talk="piper -m ~/.local/share/piper-voices/en_US-lessac-high.onnx"
function tellme
    claude -p "/notify $(string join ' ' $argv)"
end

set -gx EDITOR nvim
set -gx MANPAGER 'nvim +Man!'

function open
    for arg in $argv
        if string match -qr '\.html?$' -- "$arg"; and test -f "$arg"
            xdg-open "file://"(path resolve "$arg")
        else
            xdg-open "$arg"
        end
    end
end

switch (uname)
    case Linux
        set -gx ANDROID_NDK_VERSION 29.0.14206865
        set -gx ANDROID_SDK /data/devtools/android_sdk
        set -gx ANDROID_NDK $ANDROID_SDK/ndk/$ANDROID_NDK_VERSION
        set -gx ANDROID_NDK_SYSROOT $ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64/sysroot
    case Darwin
        set -gx ANDROID_NDK_VERSION 27.2.12479018
        set -gx ANDROID_SDK ~/Library/Android/sdk
        set -gx ANDROID_NDK $ANDROID_SDK/ndk/$ANDROID_NDK_VERSION
        set -gx ANDROID_NDK_SYSROOT $ANDROID_NDK/toolchains/llvm/prebuilt/darwin-x86_64/sysroot
end

# PATH
fish_add_path $ANDROID_SDK/emulator
fish_add_path $ANDROID_SDK/platform-tools
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.zvm/bin
fish_add_path $HOME/.zvm/self

# opencode
fish_add_path /home/umurgdk/.opencode/bin
