[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

. /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

setxkbmap gb
# sudo localectl set-x11-keymap gb

# Start redshift to adjust screen temp
redshift &

feh --bg-scale ~/.local/share/bg.jpg
exec bspwm
