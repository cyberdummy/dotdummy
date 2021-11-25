compiler shell-lint
let b:undo_ftplugin .= '|unlet b:current_compiler'

" Lint on save and reload buffer
augroup MyShell
    autocmd! * <buffer>
    autocmd BufWritePost <buffer> silent lmake! <afile> | silent redraw!
augroup END

let b:undo_ftplugin .= '|setlocal tabstop< softtabstop< shiftwidth<'
setlocal shiftwidth=2
setlocal softtabstop=2 " number of spaces when editing
setlocal tabstop=2

let b:undo_ftplugin .= "|execute 'autocmd! MyShell * <buffer>'"

function! Format()
    let l:old = ''
    if exists('b:current_compiler')
        let l:old = b:current_compiler
    endif

    let l:buf = bufname('%')
    compiler shell-fmt
    execute 'silent make!'
    execute 'silent redraw!'
    execute bufwinnr(l:buf).'wincmd w'

    if l:old != ''
        execute 'compiler '.l:old
    endif
endfunction

nnoremap m<CR> :call Format()<CR>
