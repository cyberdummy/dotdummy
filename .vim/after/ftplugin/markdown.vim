setlocal textwidth=79

let b:undo_ftplugin .= ''
            \ . '|setlocal textwidth<'
            \ . '|silent! vunmap <buffer> <LocalLeader><Blash>'

vnoremap <buffer> <silent> <LocalLeader><Bslash> :EasyAlign*<Bar><Enter>
