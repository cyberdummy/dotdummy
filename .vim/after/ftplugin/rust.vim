setlocal tabstop=4 " number of spaces per tab
setlocal softtabstop=4 " number of spaces when editing
setlocal shiftwidth=4 " autoindentation also << >> & ==
setlocal textwidth=80 " just applies to comments

setlocal comments-=://
setlocal comments+=f://
setlocal commentstring=//\ %s " default comment string

let b:undo_ftplugin .= '|setlocal tabstop< softtabstop< shiftwidth< textwidth<'
    \ . ' comments< commentstring<'


compiler rust-lint

" Lint on save
augroup MyRust
    autocmd! * <buffer>
    autocmd BufWritePost <buffer> silent lmake! <afile> | silent redraw!
augroup END

let b:undo_ftplugin .= '|unlet b:current_compiler'
    \ . '|setlocal errorformat< makeprg< textwidth<'
    \ . "|execute 'autocmd! MyRust * <buffer>'"

function! RustBuild()
    let l:old = ''
    if exists('b:current_compiler')
        let l:old = b:current_compiler
    endif

    let l:buf = bufname('%')
    compiler rust
    execute 'silent make! '
    execute 'silent redraw!'
    execute bufwinnr(l:buf).'wincmd w'

    if l:old != ''
        execute 'compiler '.l:old
    endif
endfunction

nnoremap m<CR> :call RustBuild()<CR>

let b:undo_ftplugin .= ''
            \ . '|nunmap m<CR>'
            \ . '|delf RustBuild'
