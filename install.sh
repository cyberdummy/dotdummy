#!/usr/bin/env bash
usage() {
    echo "Usage: $0 [-t home/dir] [-urh]" 1>&2
    echo '  -t DIR    Target directory to install into default to your $HOME' 1>&2
    echo '  -u        Uninstall files instead' 1>&2
    echo '  -r        Reinstall files - not compatible with -u' 1>&2
    echo '  -h        Show this help' 1>&2
    exit 1
}

action="install"

while getopts ":t:hru" o; do
    case "${o}" in
        t)
            target=${OPTARG}
            ;;
        u)
            action="uninstall"
            ;;
        r)
            action="reinstall"
            ;;
        h)
            usage
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

[[ -z $target ]] && target=$HOME

if [[ ! -d "$target" ]]; then
    >&2 echo "Target directory ${target} does not exist"
    exit 1
fi

# Find out directory of dotfiles
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done

DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

create_skeleton() {
    # These are folders we dont want to be symlinks
    local folders=(
    '.local/share'
    '.local/bin'
    '.ssh'
    '.config/systemd/user'
    '.config/transmission-daemon'
    '.config/qutebrowser'
    '.config/dotdummy'
    '.config/dotdummy/projects'
    '.gnupg'
    '.urxvt'
    '.vim/cache'
    '.vim/cache/backups'
    '.vim/cache/swaps'
    '.vim/cache/undo'
    '.config/twitchy3'
    '.newsboat'
    '.mutt/mailboxes'
    )

    local count=0
    while [ "x${folders[count]}" != "x" ]; do
        local path="${target}/${folders[count]}"
        [[ -d $path ]] || echo "Creating: $path" && mkdir -p $path
        local count=$(( $count + 1 ))
    done
}

if [[ "$action" = "install" ]]; then
    echo "Installing symlinks to $target"
    create_skeleton
    stow -d $DIR -t $target .
elif [[ "$action" = "reinstall" ]]; then
    echo "Reinstalling symlinks to $target"
    stow -D -d $DIR -t $target .
    create_skeleton
    stow -d $DIR -t $target .
else
    echo "Removing symlinks from $target"
    stow -d $DIR -t $target .
fi

# font-cache ?
# systemctl --user daemon-reload
