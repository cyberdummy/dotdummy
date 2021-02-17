[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

. /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

setxkbmap gb

# So docker containers can connect to X
xhost local:root

# Start redshift to adjust screen temp
if [[ -f ~/.config/dotdummy/docker.sh ]]; then
    source ~/.config/dotdummy/docker.sh
    redshift
fi

feh --bg-scale ~/.local/share/bg.jpg
exec bspwm
