#!/bin/bash

if [[ ! -z $IS_MAC ]]; then
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

phpcbf(){
    docker run --rm --user $(id -u) -v=$(pwd):/workspace --entrypoint "/bin/phpcbf" cyberdummy/phpcs $@
}

hugo(){
    docker run --rm -v "$(pwd):/workspace" --user $(id -u) -p 1313:1313 cyberdummy/hugo $@
}

firefox(){
    local state
    state=$(docker inspect --format "{{.State.Running}}" "firefox" 2>/dev/null)

    if [[ "$state" == "true" ]]; then
        docker exec firefox firefox "$@"
        return
    fi

    del_stopped firefox
    relies_on pulseaudio

    docker run  -d \
        --user $(id -u) \
        --network desktop \
        -e PULSE_SERVER=pulseaudio \
        -v /etc/localtime:/etc/localtime:ro \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e "DISPLAY=unix${DISPLAY}" \
        -e LANG=C \
        -v "${HOME}/.firefox/cache:/.cache/mozilla" \
        -v "${HOME}/.firefox/mozilla:/.mozilla" \
        -v "${HOME}/downloads:/Downloads" \
        --group-add $(getent group audio | cut -d: -f3) \
        --device /dev/dri \
        --ipc=host \
        --name firefox \
        cyberdummy/firefox "$@"
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

pactl(){
    relies_on pulseaudio

    docker exec pulseaudio pactl "$@"
}

mpv(){
    del_stopped mpv
    relies_on pulseaudio

    docker run  -d \
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
        --name mpv \
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

vdirsyncer() {
    del_stopped vdirsyncer

    (
        export CONTACTS_PASS=$(pass show codeclick/nextcloud/contacts)

        docker run -d \
            -v "${HOME}/.local/share/vdirsyncer:/.local/share/vdirsyncer" \
            -v "${HOME}/.local/share/vdirsyncer/contacts:/.local/share/vdirsyncer/contacts" \
            -v "${HOME}/.config/vdirsyncer:/.config/vdirsyncer" \
            -e "CONTACTS_PASS" \
            -e "USER" \
            -e "TERM" \
            --user $(id -u) \
            --name vdirsyncer \
            cyberdummy/vdirsyncer $@
    )
}

khard() {
    del_stopped khard

    relies_on vdirsyncer

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

    relies_on mbsync vdirsyncer

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
    relies_on pulseaudio

    docker run -d \
        -v /etc/localtime:/etc/localtime:ro \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e "DISPLAY=unix${DISPLAY}" \
        --network desktop \
        -e PULSE_SERVER=pulseaudio \
        --group-add video \
        --group-add $(getent group audio | cut -d: -f3) \
        --device /dev/dri \
        --device /dev/video0 \
        -v /dev/shm:/dev/shm \
        --device /dev/snd \
        --name zoom \
        --runtime=nvidia \
        cyberdummy/zoom
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

mysql(){
    del_stopped mysql

    docker run -ti \
        -v "${HOME}/.inputrc:/root/.inputrc" \
        -v "${HOME}/.editrc:/root/.editrc" \
        -v "${HOME}/.my.cnf:/root/.my.cnf" \
        --name mysql \
        --entrypoint ""\
        mysql:5.7 mysql $@
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
