# My Dot Files

I use arch linux with the [bspwm](https://github.com/baskerville/bspwm) window manager.

## Mappings for Window Manager

These mappings are executed by the
[sxhkd](https://github.com/baskerville/sxhkd) hotkey daemon, the config is [here](.config/sxhkd/sxhkdrc).

| Mapping           | Description                                                                              |
| ---               | ---                                                                                      |
| Super + Enter     | Open terminal window (alacritty)                                                         |
| Super + e         | Opens a floating window with a scratch pad style terminal                                |
| Super + 1         | Workspace 1 (large tmux terminal)                                                        |
| Super + g         | Workspace 1 alias                                                                        |
| Super + 2         | Workspace 2 (personal browser)                                                           |
| Super + i         | Workspace 2 alias                                                                        |
| Super + 3         | Workspace 3 (work browser)                                                               |
| Super + o         | Workspace 3 alias                                                                        |
| Super + 4         | Workspace 4 (media)                                                                      |
| Super + u         | Type out main gmail address                                                              |
| Super + y         | Type out main personal address                                                           |
| Super + q         | Open small floating terminal window with fuzzy find to copy a password                   |
| Super + b         | Open small floating terminal window with fuzzy find to copy a saved URL                  |
| Super + Shift + q | Open small floating terminal window with fuzzy find to copy a OTP                        |
| Super + c         | Find a slack window and focus it                                                         |
| Super + v         | Open small floating terminal window with fuzzy find to copy something saved to clipboard |
| Super + x         | Open small floating terminal window with input prompt to save something from clipboard   |
| Super + z         | Apply a 400 left and right padding to the workspace in order to more center a window     |
| Super + Shift + z | Remove above padding                                                                     |
| Super + m         | Set window to monocle mode                                                               |

## Workspace Layouts

I generally have 1 window per workspace.

### 1 - Terminal Tmux

The main workspace, I run an alacritty terminal in monocle mode so it takes the
entire screen. The terminal runs a tmux session with several windows which are
split up into panes depending on what I am doing within the window.

### 2 - Personal Browser

Firefox running under my "personal" profile. The profile dumps all history /
cookies / data etc when closed.

### 3 - Work Browser

Firefox running under my "work" profile. This profile persists data when closed
and is only used for work related things.

### 4 - Media

Any videos (mpv) open here. Also if listening to music via yewtube that is open
in a terminal here.

### 5-8 - Utility

Generally empty to be used when needed.

### 9 - Slack

Workspace that is told to load on the side monitor and runs slack inside it and
any other window that I need open for glancing at.

## tmux Setup
