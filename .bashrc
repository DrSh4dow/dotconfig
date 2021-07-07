#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

### Some enviromental variables

## Wayland Variables
export CLUTTER_BACKEND=wayland
export MOZ_ENABLE_WAYLAND=1
export _JAVA_AWT_WM_NONREPARENTING=1
export XDG_SESSION_TYPE=wayland
export QT_QPA_PLATFORM=wayland
#export SDL_VIDEODRIVER=wayland
export XDG_CURRENT_DESKTOP=sway
export QT_QPA_PLATFORMTHEME=qt5ct

## HiDPI Variables
#export QT_AUTO_SCREEN_SCALE_FACTOR=1

### Exports
export EDITOR=vim
export VISUAL=code
export VIDEO=mpv
export IMAGE=eog
export OPENER="xdg-open"
export READER=evince
export GOROOT="/usr/lib/go"
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$HOME/Projects/myconfigs/scripts:$HOME/.local/bin:$PATH"
export CLICOLOR=1
export TERM=xterm-256color
export TERMINAL=alacritty
export BROWSER=brave
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
### Start Sway
if [ "$(tty)" = "/dev/tty1" ]; then
	systemctl --user start wallpaper.timer
	exec sway
fi


### Start Xorg
#if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
#  exec startx
#fi

### Start Gnome Wayland
#if [[ -z $DISPLAY && $(tty) == /dev/tty1 ]]; then
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
alias tr='transmission-remote'
alias mpv='SDL_VIDEODRIVER=wayland mpv'
###

PS1="[\[\e[31m\]\u\[\e[m\]@\[\e[36m\]\h\[\e[m\] \W]\\$ "

### Macros
bind "set completion-ignore-case on"

neofetch
