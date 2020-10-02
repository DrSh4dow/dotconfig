#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# Kill some nice programs
killall feh
killall picom

# merge in defaults and keymaps

if [ -f $sysresources ]; then


    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then



    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi


# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

export XDG_SESSION_TYPE=x11
export GDK_BACKEND=x11
#exec gnome-session

#xrandr --output eDP1 --mode 1280x800
#feh --bg-scale /home/drsh4dow/Pictures/backgrounds/624.jpg
exec i3
