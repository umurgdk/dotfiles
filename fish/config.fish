if status is-interactive
    # Commands to run in interactive sessions can go here
end

direnv hook fish | source
alias grep="rg"
alias ls="eza"
alias l="eza -l"
