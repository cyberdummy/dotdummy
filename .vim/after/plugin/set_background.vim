let shellcmd = 'cat ~/.config/dynamic-colors/colorscheme'
let output=system(shellcmd)

if stridx(output, 'light') >= 0
    set background=light
endif
