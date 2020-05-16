export BASH_SILENCE_DEPRECATION_WARNING=1
for file in ~/.{profile,bashrc}; do
	if [[ -r "$file" ]] && [[ -f "$file" ]]; then
		source "$file"
	fi
done
unset file
