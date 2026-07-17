#!/bin/bash

# customizable
LIST_DATA="#{window_name} #{pane_title} #{pane_current_path} #{pane_current_command}"
FZF_COMMAND="fzf-tmux -p --delimiter=: --with-nth 3 --color=hl:2"

# do not change
TARGET_SPEC="#{window_id}:#{pane_id}:"

# select pane
LINE=$(tmux list-windows -F "$TARGET_SPEC $LIST_DATA" | $FZF_COMMAND) || exit 0
# split the result
args=(${LINE//:/ })
# activate session/window/pane
tmux select-window -t ${args[0]}
