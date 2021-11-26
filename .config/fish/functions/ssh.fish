function ssh
    set LOCAL_TERM (echo -n "$TERM" | sed -e s/tmux/screen/)
    env TERM=$LOCAL_TERM ssh $argv
end
