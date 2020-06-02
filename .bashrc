#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

### Exports
export EDITOR=vim
export GOROOT="/usr/lib/go"
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"
export CLICOLOR=1
export TERM=xterm-256color
export TERMINAL=terminator

### Aliases
alias ls='exa'
alias l='exa -lahg'
alias grep='grep --color=auto'
alias mv='mv -i'

###

PS1="[\[\e[31m\]\u\[\e[m\]@\[\e[36m\]\h\[\e[m\] \W]\\$ "

### Macros
bind "set completion-ignore-case on"

neofetch
