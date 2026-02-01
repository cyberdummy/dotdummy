## Options
set __fish_git_prompt_show_informative_status
set __fish_git_prompt_showcolorhints
set __fish_git_prompt_showupstream "informative"

# Colors
set green (set_color green)
set magenta (set_color magenta)
set normal (set_color normal)
set red (set_color red)
set yellow (set_color yellow)

set __fish_git_prompt_color_branch magenta --bold
set __fish_git_prompt_color_dirtystate white
set __fish_git_prompt_color_invalidstate red
set __fish_git_prompt_color_merging yellow
set __fish_git_prompt_color_stagedstate yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red


# Icons
set __fish_git_prompt_char_cleanstate ' 👍'
set __fish_git_prompt_char_conflictedstate ' ⚠️'
set __fish_git_prompt_char_dirtystate ' 💩'
set __fish_git_prompt_char_invalidstate ' 🤮'
set __fish_git_prompt_char_stagedstate ' 🚥'
set __fish_git_prompt_char_stashstate ' 📦'
set __fish_git_prompt_char_stateseparator ' |'
set __fish_git_prompt_char_untrackedfiles ' 🔍'
set __fish_git_prompt_char_upstream_ahead ' ☝️'
set __fish_git_prompt_char_upstream_behind ' 👇'
set __fish_git_prompt_char_upstream_diverged ' 🚧'
set __fish_git_prompt_char_upstream_equal ' 💯'

set -g fish_prompt_pwd_dir_length 99

function fish_prompt
  set last_status $status

  set_color $fish_color_cwd
  echo " "
  printf '%s' (prompt_pwd)
  set_color normal

  printf '%s ' (__fish_git_prompt)

  if test $CMD_DURATION
      set_color cyan
      # Show duration of the last command in seconds
      set duration (echo "$CMD_DURATION 1000" | awk '{printf "%.3fs", $1 / $2}')
      echo -n "$duration "
  end

  set_color yellow
  set live (dake is_live)
  if string match -q -e -- 'live' $live
    set_color blue
  end
  echo $live
  set_color yellow
  echo ''
  echo -n "    😄 "
  set_color normal
end
