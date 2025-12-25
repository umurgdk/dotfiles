if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias ls="eza"
alias ll="eza -l"
alias grep="rg"
alias cat="bat"
alias http="xh"
alias https="xhs"

set -gx EDITOR nvim

set -gx ANDROID_NDK_VERSION 27.2.12479018
set -gx ANDROID_SDK ~/Library/Android/sdk
set -gx ANDROID_NDK $ANDROID_SDK/ndk/$ANDROID_NDK_VERSION
set -gx ANDROID_NDK_SYSROOT $ANDROID_NDK/toolchains/llvm/prebuilt/darwin-x86_64/sysroot

fish_add_path $ANDROID_SDK/emulator

set -gx DOTNET_ROOT /opt/homebrew/opt/dotnet/libexec
