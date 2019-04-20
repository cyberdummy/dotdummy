" Motion for "next/last object".
" For example, "din(" would go to the next "()" pair and delete its contents.
" https://bitbucket.org/sjl/dotfiles/src/1b6ffba66e9f/vim/.vimrc?fileviewer=file-view-default#cl-1023
"
function s:NextLastOjects(motion, dir)
    let c = nr2char(getchar())

    if c ==# "b"
        let c = "("
    elseif c ==# "B"
        let c = "{"
    elseif c ==# "d"
        let c = "["
    endif

    exe "normal! ".a:dir.c."v".a:motion.c
endfunction

omap <Plug>NextOuterObject
      \ :<C-U>call <SID>NextLastOjects('a', 'f')<CR>
xmap <Plug>NextOuterObject
      \ :<C-U>call <SID>NextLastOjects('a', 'f')<CR>
omap <Plug>NextInnerObject
      \ :<C-U>call <SID>NextLastOjects('i', 'f')<CR>
xmap <Plug>NextInnerObject
      \ :<C-U>call <SID>NextLastOjects('i', 'f')<CR>

omap <Plug>LastOuterObject
      \ :<C-U>call <SID>NextLastOjects('a', 'F')<CR>
xmap <Plug>LastOuterObject
      \ :<C-U>call <SID>NextLastOjects('a', 'F')<CR>
omap <Plug>LastInnerObject
      \ :<C-U>call <SID>NextLastOjects('i', 'F')<CR>
xmap <Plug>LastInnerObject
      \ :<C-U>call <SID>NextLastOjects('i', 'F')<CR>
