[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

. /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

setxkbmap gb
export GDK_DPI_SCALE=0.8
# sudo localectl set-x11-keymap gb

# Start redshift to adjust screen temp
redshift &

# notifcation daemon so slack works again
dunst &

feh --bg-scale ~/.local/share/bg.jpg
exec bspwm
