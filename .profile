for file in ~/.config/dotdummy/{exports.sh,aliases.sh}; do
    if [[ -r "$file" ]] && [[ -f "$file" ]]; then
        source "$file"
    fi
done
unset file
