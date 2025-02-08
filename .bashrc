#
# ~/.bashrc
#

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

### Some enviromental variables

## Wayland Variables
# export GDK_BACKEND=wayland,x11
# export QT_QPA_PLATFORM="wayland;xcb"
export SDL_VIDEODRIVER=wayland,x11,windows
# export CLUTTER_BACKEND=wayland
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=Hyprland
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
# export QT_QPA_PLATFORMTHEME=qt5ct
export QT_QPA_PLATFORMTHEME=qt5ct:qt6ct

### Exports
export EDITOR=nvim
export VISUAL=nvim
export VIDEO=mpv
export IMAGE=gwenview
export OPENER="xdg-open"
export READER=okular
export GOROOT="/usr/lib/go"
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export FLYCTL_INSTALL="/home/drsh4dow/.fly"
export PATH="$GOBIN:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/bin:$FLYCTL_INSTALL/bin:$PATH"
export CLICOLOR=1
export TERMINAL=kitty
export BROWSER=zen-browser
export PAGER="less"
export NODE_OPTIONS=--max-old-space-size=8192

# export WM="hyprland"
export COLORTERM="truecolor"
# export RUSTFLAGS="-C target-cpu=native -C opt-level=2"

### Neovide config
export NEOVIDE_FRAMELESS=true
export NEOVIDE_FRAME=none neovide

### NNN Configuration
export NNN_TRASH=1
export NNN_COLORS='4444'
export NNN_FCOLORS='c1e2272e006033f7c6d6abc4'
export NNN_FIFO='/tmp/nnn.fifo'
export NNN_PLUG='m:nmount;d:dragdrop'

################################################
### Start Hyprland
if uwsm check may-start; then
  systemctl --user import-environment
  exec uwsm start hyprland.desktop
fi

### Start Sway
# if [ "$(tty)" = "/dev/tty1" ]; then
#   systemctl --user import-environment
#   if [ -z "$WAYLAND_DISPLAY" ]; then
#     exec sway
#   fi
# fi

### Start Xorg
#if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
#  exec startx
#fi

### Start Gnome Wayland
#if [[ -z $DISPLAY && $(tty) == /dev/tty1 ]]; then
#  exec dbus-run-session gnome-session
#fi
################################################

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi

unset rc

### Aliases
alias ls='exa'
alias l='exa -lahg --icons'
alias grep='rg --color=auto'
alias mv='mv -i'
alias cmatrix='cmatrix -bC blue'
alias tiktak='tty-clock -scC 4'
#alias tr='transmission-remote'
# alias mpv='SDL_VIDEODRIVER=wayland mpv'
alias vim='nvim'
alias cat='bat -pp'
###

PS1="[\[\e[31m\]\u\[\e[m\]@\[\e[36m\]\h\[\e[m\] \W]\\$ "

### Macros
bind "set completion-ignore-case on"

neofetch

# pnpm
source ~/.completion-for-pnpm.bash
# pnpm end
#
source /usr/share/nvm/init-nvm.sh

# fly completions
source "$HOME/.fly-completions.bash"

# Turso
export PATH="/home/drsh4dow/.turso:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH=$BUN_INSTALL/bin:$PATH
