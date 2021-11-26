#!/usr/bin/env bash

# older servers dont know the tmux TERM type
ssh() {
  local LOCAL_TERM
  LOCAL_TERM=$(echo -n "$TERM" | sed -e s/tmux/screen/)
  env "TERM=$LOCAL_TERM" ssh "$@"
}
