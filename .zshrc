# The following lines were added by compinstall
#
# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%{$fg[green]%}[%{$fg[red]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[green]%}]%{$reset_color%}$%b "

zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:]}={[:upper:]}'
zstyle :compinstall filename '/home/drsh4dow/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt extendedglob
unsetopt autocd beep
bindkey -e
# End of lines configured by zsh-newuser-install

### Some enviromental variables
export CLUTTER_BACKEND=wayland
export MOZ_ENABLE_WAYLAND=1
export _JAVA_AWT_WM_NONREPARENTING=1
export XDG_SESSION_TYPE=wayland
export QT_QPA_PLATFORM=wayland

### Exports
export EDITOR=vim
export VISUAL=vim
export VIDEO=mpv
export IMAGE=imv
export OPENER="xdg-open"
export READER=zathura
export GOROOT="/usr/lib/go"
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:/home/drsh4dow/.cargo/bin:$PATH"
export CLICOLOR=1
export TERM=xterm-256color
export TERMINAL=alacritty
#export TERMINAL=kitty
export BROWSER=firefox
export PAGER="less"
export WM="sway"
#export WM="i3"
export COLORTERM="truecolor"


### NNN Configuration
export NNN_TRASH=1
export NNN_COLORS='4444'
export NNN_FCOLORS='c1e2272e006033f7c6d6abc4'
export NNN_FIFO='/tmp/nnn.fifo'
export NNN_PLUG='m:nmount;d:dragdrop'

################################################
### StartX
#if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
#	exec startx
#fi

### Start Wayland
if [ "$(tty)" = "/dev/tty1" ]; then
	exec sway
fi

### Start Gnome Wayland
#if [[ -z $DISPLAY && $(tty) == /dev/tty1 && $XDG_SESSION_TYPE == tty ]]; then
#  exec dbus-run-session gnome-session
#fi
################################################



### Aliases
alias ls='exa'
alias l='exa -lahg'
alias grep='grep --color=auto'
alias mv='mv -i'
alias cmatrix='cmatrix -bC blue'
alias tiktak='tty-clock -scC 4'
###

bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

neofetch
