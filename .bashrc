
shopt -s histappend
HISTSIZE=100000
HISTFILESIZE=100000
HISTCONTROL=ignoreboth # ignore commands starting with whitespace & dupes
HISTTIMEFORMAT='%F %T '
PROMPT_COMMAND='history -a'

if [[ $(uname -s) == "Darwin" ]]; then
    export IS_MAC=1
else
    eval `dircolors ~/.dir_colors`
fi

for file in ~/.config/dotdummy/{exports.sh,aliases.sh,bash_prompt.sh,docker.sh}; do
    if [[ -r "$file" ]] && [[ -f "$file" ]]; then
        source "$file"
    fi
done
unset file
