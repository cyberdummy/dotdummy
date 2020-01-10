#!/bin/bash

if [[ $(uname -s) == "Darwin" ]]; then
    return 0
fi

# this is the stupid way I share files between containers and host
[[ -d /tmp/dummy ]] || mkdir /tmp/dummy

del_stopped(){
    local name=$1
    local state
    state=$(docker inspect --format "{{.State.Running}}" "$name" 2>/dev/null)

    if [[ "$state" == "false" ]]; then
        docker rm "$name"
    fi
}

relies_on(){
    for container in "$@"; do
        local state
        state=$(docker inspect --format "{{.State.Running}}" "$container" 2>/dev/null)

        if [[ "$state" == "false" ]] || [[ "$state" == "" ]]; then
            echo "$container is not running, starting it for you."
            $container
        fi
    done
}

nvidia_options(){
    echo -n "--device /dev/dri \
        --group-add video \
        --group-add render \
        --device /dev/vga_arbiter \
        --device /dev/nvidia0 \
        --device /dev/nvidiactl \
        --device /dev/nvidia-modeset "
}

aws(){
    (
        docker run --rm -it \
            --user $(id -u) \
            --log-driver none \
            -e "AWS_ACCESS_KEY_ID" \
            -e "AWS_SECRET_ACCESS_KEY" \
            -e "AWS_DEFAULT_REGION" \
            -v "${HOME}/downloads:/Downloads" \
            --workdir "/Downloads" \
            --name "aws" \
            cyberdummy/aws "$@"
    )
}

ctags(){
    docker run --rm -v=$(pwd):/workspace universalctags/ctags-docker:latest $@
}

phpcsfixer(){
    docker run --rm --user $(id -u) -v=$(pwd):/workspace cyberdummy/phpcsfixer $@
}

phpcs(){
    docker run --rm \
        --user $(id -u) \
        -v=$(pwd):/workspace \
        -v="${HOME}/.config/phpcs:/.config/phpcs" \
        cyberdummy/phpcs $@
}

phpmd(){
    docker run --rm \
        --user $(id -u) \
        -v=$(pwd):/workspace \
        --entrypoint "/bin/phpmd" \
        cyberdummy/phpcs $@
}

phpunit(){
    docker run --rm \
        --user $(id -u) \
        -v=$(pwd):/workspace \
        cyberdummy/phpunit "$@"
}

phpcbf(){
    docker run --rm --user $(id -u) -v=$(pwd):/workspace --entrypoint "/bin/phpcbf" cyberdummy/phpcs $@
}

hugo(){
    docker run --rm -v "$(pwd):/workspace" --user $(id -u) -p 1313:1313 cyberdummy/hugo $@
}

ff(){
    rm -rf ~/.local/share/buku/bookmarks.html
    buku --export /.local/share/buku/bookmarks.html

    firefox -P Tom
}

firefox(){
    local profile='Tom' OPTIND o

    while getopts ":P:" o; do
        case "$o" in
            P)
                # Figure out if we are using a profile
                profile=$OPTARG
                ;;
        esac
    done

    local profile_dir="${HOME}/.mozilla/firefox/${profile}"

    if [[ ! -d $profile_dir ]]; then
        echo "That profile does not exist use firefox_pm to create"
        return;
    fi

    local container_name="firefox_${profile}"
    echo $container_name

    # If instance is already running then just exec command inside (probably to open new URL)
    local state=$(docker inspect --format "{{.State.Running}}" $container_name 2>/dev/null)

    if [[ "$state" == "true" ]]; then
        docker exec $container_name firefox -P $profile "$@"
        return
    fi

    del_stopped $container_name
    relies_on pulseaudio

    rm -f "${profile_dir}/places.sqlite*"
    local cache_dir="${HOME}/.mozilla/cache/firefox/${profile}"
    mkdir -p $cache_dir

    local nvidia_opts=$(nvidia_options)

    local cmd="docker run  -d \
        --user $(id -u) \
        -e PULSE_SERVER=pulseaudio \
        -v /etc/localtime:/etc/localtime:ro \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e \"DISPLAY=unix${DISPLAY}\" \
        -e LANG=C \
        -v \"${cache_dir}:/.cache/mozilla/firefox/{$profile}\" \
        -v \"${HOME}/.mozilla/firefox/${profile}:/.mozilla/firefox/${profile}\" \
        -v \"${HOME}/.mozilla/firefox/profiles.ini:/.mozilla/firefox/profiles.ini\" \
        -v \"${HOME}/.local/share/buku/bookmarks.html:/bookmarks.html\" \
        -v \"${HOME}/downloads:/Downloads\" \
        -v \"/tmp/dummy/:/tmp/dummy\" \
        $nvidia_opts \
        --ipc=host \
        --name $container_name \
        cyberdummy/firefox -P $profile --class firefox-$profile \$@"

    eval $cmd

    docker network connect desktop $container_name
}

firefox_pm(){
    del_stopped firefox_pm

    docker run  -d \
        --user $(id -u) \
        --network desktop \
        -e PULSE_SERVER=pulseaudio \
        -v /etc/localtime:/etc/localtime:ro \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e "DISPLAY=unix${DISPLAY}" \
        -e LANG=C \
        -v "${HOME}/.mozilla/firefox:/.mozilla/firefox" \
        --ipc=host \
        --name firefox_pm \
        cyberdummy/firefox --ProfileManager
}

rtv(){
    del_stopped rtv

    docker run -ti \
        --name rtv \
        -e BROWSER="browser" \
        -e "DISPLAY=unix${DISPLAY}" \
        -e "TERM" \
        -v "${HOME}/.config/rtv:/root/.config/rtv" \
        -v "${HOME}/.mailcap:/root/.mailcap" \
        -v ${XDG_RUNTIME_DIR}/cyberdummy/dlaunch:/tmp/dlaunch \
        cyberdummy/rtv "$@"
    }

buku(){
    docker run --rm -ti \
        --name buku \
        -e BROWSER="browser" \
        -v ${XDG_RUNTIME_DIR}/cyberdummy/dlaunch:/tmp/dlaunch \
        -v "${HOME}/.local/share/buku:/.local/share/buku" \
        --user $(id -u) \
        cyberdummy/buku "$@"
    }

newsboat(){
    del_stopped newsboat

    docker run -ti \
        --name newsboat \
        -v "${HOME}/.newsboat:/root/.newsboat" \
        -v "${HOME}/.newsboat/urls:/root/.newsboat/urls" \
        -v "${HOME}/.newsboat/config:/root/.newsboat/config" \
        -v ${XDG_RUNTIME_DIR}/cyberdummy/dlaunch:/tmp/dlaunch \
        cyberdummy/newsboat "$@" && reset
    }

pulseaudio(){
    del_stopped pulseaudio

    docker run -d \
        -v /etc/localtime:/etc/localtime:ro \
        --device /dev/snd \
        --network desktop \
        -p 4713:4713 \
        --group-add $(getent group audio | cut -d: -f3) \
        --name pulseaudio \
        -v ${XDG_RUNTIME_DIR}/pulse/dnative:${XDG_RUNTIME_DIR}/pulse/native \
        --volume /run/dbus/system_bus_socket:/run/dbus/system_bus_socket \
        cyberdummy/pulseaudio

    sleep 2
}

go() {
    docker run --rm \
        -v "${HOME}/code/go:${HOME}/code/go" \
        --user $(id -u) \
        -e "GOPATH=${HOME}/code/go/gopath" \
        -e "HOME=${HOME}/code/go/home" \
        -e "TERM" \
        --workdir "${PWD}" \
        cyberdummy/go "$@"
}

golint() {
    docker run --rm \
        -v "${HOME}/code/go:${HOME}/code/go" \
        --user $(id -u) \
        -e "GOPATH=${HOME}/code/go/gopath" \
        -e "HOME=${HOME}/code/go/home" \
        --workdir "${PWD}" \
        --entrypoint "${HOME}/code/go/gopath/bin/golint" \
        cyberdummy/go "$@"
}

gofmt() {
    docker run --rm \
        -v "${HOME}/code/go:${HOME}/code/go" \
        --user $(id -u) \
        -e "GOPATH=${HOME}/code/go/gopath" \
        -e "HOME=${HOME}/code/go/home" \
        --workdir "${PWD}" \
        --entrypoint "gofmt" \
        cyberdummy/go "$@"
}

autopep8() {
    docker run --rm --user $(id -u) -v=$(pwd):/workspace cyberdummy/python autopep8 $@
}

pycodestyle() {
    docker run --rm --user $(id -u) -v=$(pwd):/workspace cyberdummy/python pycodestyle $@
}

pipenv() {
    docker run --rm --user $(id -u) -v=$(pwd):/workspace cyberdummy/python pipenv $@
}

pylint() {
    docker run --rm --user $(id -u) -v=$(pwd):/workspace cyberdummy/python pylint $@
}

pactl(){
    relies_on pulseaudio

    docker exec pulseaudio pactl "$@"
}

play(){
    del_stopped mpv
    relies_on pulseaudio

    docker run  -d \
        --rm \
        -v /etc/localtime:/etc/localtime:ro \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v "${HOME}/.config/mpv:/.config/mpv" \
        -v "${HOME}/.config/mpv/mpv.conf:/.config/mpv/mpv.conf" \
        -e "DISPLAY=${DISPLAY}" \
        -v "$(pwd):/workspace" \
        --workdir /workspace \
        --group-add $(getent group audio | cut -d: -f3) \
        --group-add video \
        --device /dev/dri \
        --network desktop \
        --user $(id -u) \
        -e PULSE_SERVER=pulseaudio \
        --runtime=nvidia \
        cyberdummy/mpv "$@"
    }

mpv(){
    #del_stopped mpv
    relies_on pulseaudio

    docker run  -d \
        --rm \
        -v /etc/localtime:/etc/localtime:ro \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v "${HOME}/.config/mpv:/.config/mpv" \
        -v "${HOME}/.config/mpv/mpv.conf:/.config/mpv/mpv.conf" \
        -e "DISPLAY=${DISPLAY}" \
        --group-add $(getent group audio | cut -d: -f3) \
        --group-add video \
        --device /dev/dri \
        --network desktop \
        --user $(id -u) \
        -e PULSE_SERVER=pulseaudio \
        --runtime=nvidia \
        cyberdummy/mpv "$@"
    }

twitchy(){
    del_stopped streamlink

    docker run  -ti \
        --name streamlink \
        -v ${HOME}/.config/streamlink:/.config/streamlink \
        -v ${HOME}/.config/twitchy3:/.config/twitchy3 \
        -v ${HOME}/.config/twitchy3/twitchy.cfg:/.config/twitchy3/twitchy.cfg \
        -v ${HOME}/datadummy/.config/twitchy3:/datadummy/.config/twitchy3 \
        -v ${XDG_RUNTIME_DIR}/cyberdummy/dlaunch:/tmp/dlaunch \
        --user $(id -u) \
        --entrypoint "twitchy" \
        cyberdummy/streamlink "$@"
    }

rclone(){
    del_stopped rclone

    (
        export RCLONE_CONFIG_PASS="$(pass show rclone/password)"

        docker run  -ti \
            --name rclone \
            -v ${HOME}/.config/rclone:/.config/rclone \
            -e "RCLONE_CONFIG_PASS" \
            --user $(id -u) \
            cyberdummy/rclone "$@"
    )
}

rclonesync(){
    del_stopped rclonesync

    (
        export RCLONE_CONFIG_PASS="$(pass show rclone/password)"

        docker run  -d \
            --name rclonesync \
            -v ${HOME}/.config/rclone:/.config/rclone \
            -v /mnt/disk/cloud:/sync \
            -e "RCLONE_CONFIG_PASS" \
            --user $(id -u) \
            --entrypoint "/sync.sh" \
            cyberdummy/rclone -d
    )
}

rtorrent(){
    del_stopped rtorrent

    docker run  -ti \
        --name rtorrent \
        -e "TERM" \
        --user $(id -u) \
        cyberdummy/rtorrent "$@"
    }

streamlink(){
    del_stopped streamlink

    docker run  -ti \
        --name streamlink \
        -v ${HOME}/.config/streamlink:/.config/streamlink \
        -v ${XDG_RUNTIME_DIR}/cyberdummy/dlaunch:/tmp/dlaunch \
        --user $(id -u) \
        cyberdummy/streamlink "$@"
}

feh(){
    docker run \
        --rm \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v "${HOME}/.local/share/bg.jpg:/root/bg.jpg" \
        -v "$(pwd):/workspace" \
        --workdir /workspace \
        -e "DISPLAY=unix${DISPLAY}" \
        cyberdummy/feh "$@"
    }

zathura(){
    local file=$(realpath "$1")

    if [[ ! -f $file ]]; then
        echo "PDF File does not exist" >&2
        return -1
    fi
    docker run \
        --rm \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v "$file:$file" \
        -e "DISPLAY=unix${DISPLAY}" \
        --ipc="host" \
        cyberdummy/zathura "$file"
    }

vdirsyncerd() {
    del_stopped vdirsyncerd

    (
        export CONTACTS_PASS=$(pass show codeclick/nextcloud/contacts)

        docker run -d \
            -v "${HOME}/.local/share/vdirsyncer:/.local/share/vdirsyncer" \
            -v "${HOME}/.local/share/vdirsyncer/contacts:/.local/share/vdirsyncer/contacts" \
            -v "${HOME}/.local/share/vdirsyncer/calendar:/.local/share/vdirsyncer/calendar" \
            -v "${HOME}/.config/vdirsyncer:/.config/vdirsyncer" \
            -e "CONTACTS_PASS" \
            -e "USER" \
            -e "TERM" \
            --user $(id -u) \
            --name vdirsyncerd \
            cyberdummy/vdirsyncer $@
    )
}

notmuch() {
    docker run -ti \
        -v "${HOME}/.notmuch-config:/.notmuch-config" \
        -v "${HOME}/mail:/mail" \
        -e "USER" \
        -e LANG="en_US.utf8" \
        -e LC_ALL="C" \
        -e "TERM" \
        --entrypoint 'notmuch' \
        --user $(id -u) \
        cyberdummy/mbsync "$@"
}

khal() {
    docker run -ti \
        -v "${HOME}/.local/share/vdirsyncer:/.local/share/vdirsyncer" \
        -v "${HOME}/.local/share/vdirsyncer/calendar:/.local/share/vdirsyncer/calendar" \
        -v "${HOME}/.local/share/khal:/.local/share/khal" \
        -v "${HOME}/.config/khal:/.config/khal" \
        -e "USER" \
        -e LANG="en_US.utf8" \
        -e LC_ALL="C" \
        -e "TERM=screen-256color" \
        --user $(id -u) \
        cyberdummy/khal khal "$@"
}

vdirsyncer() {
    (
        export CONTACTS_PASS=$(pass show codeclick/nextcloud/contacts)

        docker run -ti \
            -v "${HOME}/.local/share/vdirsyncer:/.local/share/vdirsyncer" \
            -v "${HOME}/.local/share/vdirsyncer/contacts:/.local/share/vdirsyncer/contacts" \
            -v "${HOME}/.local/share/vdirsyncer/calendar:/.local/share/vdirsyncer/calendar" \
            -v "${HOME}/.config/vdirsyncer:/.config/vdirsyncer" \
            -e "CONTACTS_PASS" \
            -e "USER" \
            -e "TERM" \
            --user $(id -u) \
            --entrypoint "vdirsyncer" \
            cyberdummy/vdirsyncer "$@"
    )
}

khard() {
    del_stopped khard

    relies_on vdirsyncerd

        docker run -ti \
            -v "${HOME}/.local/share/vdirsyncer/contacts:/.local/share/vdirsyncer/contacts" \
            -v "${HOME}/.config/khard:/.config/khard" \
            -e "TERM" \
            --user $(id -u) \
            --name khard \
            cyberdummy/khard $@
}

mutt() {
    del_stopped mutt

    relies_on mbsync vdirsyncerd

    # the subshell stops the vars exposing, the export lets us pass to
    # container without exposing to processlist.
    # the display is for urlscan to be able to copy to clipboard

    (
        export TOM_PASS=$(pass show cyberdummy/@tom)

        docker run -ti \
            -v "${HOME}/.mutt:/.mutt" \
            -v "${HOME}/dotdummy/.mutt:/dotdummy/.mutt" \
            -v "${HOME}/datadummy/.mutt:/datadummy/.mutt" \
            -v "${HOME}/mail:/mail" \
            -v "${HOME}/.gnupg:/.gnupg" \
            -v "${HOME}/.vim:/.vim" \
            -v "/tmp/dummy/:/tmp/dummy" \
            -v "${HOME}/downloads:/downloads" \
            -v ${XDG_RUNTIME_DIR}/cyberdummy/dlaunch:/tmp/dlaunch \
            -v "${HOME}/.local/share/vdirsyncer/contacts:/.local/share/vdirsyncer/contacts" \
            -v "${HOME}/.config/khard:/.config/khard" \
            -e "TMPDIR=/tmp/dummy" \
            -e "DISPLAY=unix${DISPLAY}" \
            -e "BROWSER=/usr/bin/browser" \
            -e "TOM_PASS" \
            -e "USER" \
            -e "TERM" \
            --user $(id -u) \
            --name mutt \
            cyberdummy/mutt && reset
    )
}

redshift(){
    del_stopped redshift

    docker run  -d \
        -v /etc/localtime:/etc/localtime:ro \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v "${HOME}/.config/redshift:/root/.config/redshift" \
        -e "DISPLAY=unix${DISPLAY}" \
        --name redshift \
        cyberdummy/redshift "$@"
    }

aslack(){
    del_stopped slack

    relies_on pulseaudio

    local nvidia_opts=$(nvidia_options)

    local cmd="docker run -d \
        -v /etc/localtime:/etc/localtime:ro \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e \"DISPLAY=unix${DISPLAY}\" \
        -e PULSE_SERVER=pulseaudio \
        --group-add $(getent group video | cut -d: -f3) \
        --group-add $(getent group audio | cut -d: -f3) \
        --device /dev/dri \
        -v \"${HOME}/.slack:/root/.config/Slack\" \
        -v \"${HOME}/downloads:/root/Downloads\" \
        --network desktop \
        $nvidia_opts \
        --ipc=\"host\" \
        --name slack \
        cyberdummy/aslack \$@"

    eval $cmd

    }

slack(){
    del_stopped slack

    relies_on pulseaudio

    docker run -d \
        -v /etc/localtime:/etc/localtime:ro \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e "DISPLAY=unix${DISPLAY}" \
        --device /dev/dri \
        --group-add audio \
        --group-add video \
        -v "${HOME}/.slack:/root/.config/Slack" \
        -v "${HOME}/downloads:/root/Downloads" \
        --network desktop \
        -e PULSE_SERVER=pulseaudio \
        --ipc="host" \
        --name slack \
        cyberdummy/slack "$@"
    }

qutebrowser(){

    local state
    state=$(docker inspect --format "{{.State.Running}}" "qutebrowser" 2>/dev/null)

    if [[ "$state" == "true" ]]; then
        docker exec qutebrowser su user -c "qutebrowser --target tab '$*'"
        return
    fi

    del_stopped qutebrowser

    relies_on pulseaudio

    mkdir -p ~/.config/qutebrowser/bookmarks
    buku -p -f 40 > ~/.config/qutebrowser/bookmarks/urls
    docker run -d \
        --memory 1gb \
        -v /etc/localtime:/etc/localtime:ro \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e "DISPLAY=unix${DISPLAY}" \
        -e "PULSE_SERVER=pulseaudio" \
        -v /dev/shm:/dev/shm \
        -v "/etc/hosts:/etc/hosts" \
        -v "${HOME}/.config/qutebrowser:/home/user/.config/qutebrowser" \
        -v "${HOME}/.config/qutebrowser/autoconfig.yml:/home/user/.config/qutebrowser/autoconfig.yml" \
        -v "${HOME}/.config/qutebrowser/quickmarks:/home/user/.config/qutebrowser/quickmarks" \
        -v "/tmp/dummy/:/tmp/dummy" \
        -v "${HOME}/downloads:/home/user/Downloads" \
        --device /dev/dri \
        --group-add audio \
        --group-add video \
        --name qutebrowser \
        --runtime=nvidia \
        -e "MYUID=$(id -u)" \
        cyberdummy/qutebrowser qutebrowser -l debug :adblock-update "$@"

    docker network connect desktop qutebrowser
}

zoom(){
    del_stopped zoom
    docker stop pulseaudio
    sleep 3
    relies_on pulseaudio
    sleep 3

    docker run -d \
        -v /etc/localtime:/etc/localtime:ro \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e "DISPLAY=unix${DISPLAY}" \
        --network desktop \
        -e PULSE_SERVER=pulseaudio \
        --user $(id -u) \
        --group-add $(getent group video | cut -d: -f3) \
        --group-add $(getent group audio | cut -d: -f3) \
        --device /dev/dri \
        --device /dev/video0 \
        -v /dev/shm:/dev/shm \
        -v "${HOME}/.zoom:/.zoom" \
        -v "${HOME}/.config/zoomus.conf:/.config/zoomus.conf" \
        --device /dev/snd \
        --name zoom \
        --runtime=nvidia \
        cyberdummy/zoom zoom "$@"
    }

skype(){
    del_stopped skype
    relies_on pulseaudio

    docker run -ti \
        -v /etc/localtime:/etc/localtime:ro \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e "DISPLAY=unix${DISPLAY}" \
        --network desktop \
        -e PULSE_SERVER=pulseaudio \
        --security-opt seccomp:unconfined \
        --group-add video \
        --group-add $(getent group audio | cut -d: -f3) \
        --device /dev/dri \
        --device /dev/snd \
        --name skype \
        --entrypoint "/bin/bash" \
        cyberdummy/skype
    }

mysqlsh(){
    local hist=""

    if [[ -z ${MYSQL_HISTFILE+x} ]]; then
        local MYSQL_HISTFILE="${HOME}/.mysql_history"
    fi

    if [[ ! -e $MYSQL_HISTFILE ]]; then
        touch $MYSQL_HISTFILE
    fi

    if [[ -f $MYSQL_HISTFILE ]]; then
        local hist="-v \"${MYSQL_HISTFILE}:/.mysqlsh/history.sql\""
    fi

    local cmd="docker run -ti \
        --rm \
        -e "TERM=screen-256color" \
        -e \"EDITOR=vim -i NONE\" \
        -e \"DISPLAY=vim -i NONE\" \
        -e "PROMPT" \
        -e \"PRODUCTION_SERVERS=testing\" \
        -v \"${HOME}/.inputrc:/.inputrc\" \
        -v \"${HOME}/.editrc:/.editrc\" \
        -v \"${HOME}/.my.cnf:/.my.cnf\" \
        -v \"${HOME}/.mysqlsh:/.mysqlsh\" \
        ${hist} \
        --user $(id -u) \
        cyberdummy/mysqlsh \"\$@\""

    #echo $cmd
    eval $cmd
}

mysql(){
    local hist=""

    if [[ -z ${MYSQL_HISTFILE+x} ]]; then
        local MYSQL_HISTFILE="${HOME}/.mysql_history"
    fi

    if [[ ! -e $MYSQL_HISTFILE ]]; then
        touch $MYSQL_HISTFILE
    fi

    if [[ -f $MYSQL_HISTFILE ]]; then
        local tmp_dir=$(mktemp -d -t my-XXXXXXXXXX)
        cp $MYSQL_HISTFILE "${tmp_dir}/mysql_history"
        local hist="-v \"${tmp_dir}:/hist\" -e MYSQL_HISTFILE=/hist/mysql_history"
    fi

    local cmd="docker run -ti \
        --rm \
        -e "TERM=screen-256color" \
        ${hist} \
        -v \"${HOME}/.inputrc:/.inputrc\" \
        -v \"${HOME}/.editrc:/.editrc\" \
        -v \"${HOME}/.my.cnf:/.my.cnf\" \
        --user $(id -u) \
        --entrypoint \"\"\
        mysql:5.7 mysql \"\$@\""

    echo $@
    eval $cmd

    if [[ ! -z $tmp_dir ]]; then
        cp "${tmp_dir}/mysql_history" $MYSQL_HISTFILE
        rm -rf $tmp_dir
    fi
}

transmission() {
    del_stopped transmission

    docker run -d \
        --net "host" \
        -v "${HOME}/downloads:/home/tomw/Downloads" \
        -v "${HOME}/.config/transmission-daemon:/.config/transmission-daemon" \
        -v "${HOME}/.config/transmission-daemon/settings.json:/.config/transmission-daemon/settings.json" \
        --user $(id -u) \
        --name transmission \
        cyberdummy/transmission

    sleep 3
}

tremote() {
    relies_on transmission

    docker exec -ti \
        --user $(id -u) \
        transmission \
        transmission-remote "$@"
}

# source in any local configs
local_file="${HOME}/.config/dotdummy/docker_local.sh"
if [[ -r "$local_file" ]] && [[ -f "$local_file" ]]; then
    source "$local_file"
fi

unset local_file
