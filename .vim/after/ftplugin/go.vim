compiler go-lint
let b:undo_ftplugin .= '|unlet b:current_compiler'

" Lint on save and reload buffer
augroup MyGO
    autocmd! * <buffer>
    autocmd BufWritePost <buffer> silent make! <afile> | silent redraw! | silent edit
augroup END

let b:undo_ftplugin .= "|execute 'autocmd! MyGO * <buffer>'"

" whitespace
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
set noexpandtab

let b:undo_ftplugin .= '|setlocal tabstop< softtabstop< shiftwidth< expandtab<'

setlocal textwidth=79 " just applies to comments
setlocal formatoptions-=t

let b:undo_ftplugin .= '|setlocal textwidth< formatoptions<'

" jump to imports
function! FindImport(end)
    let l:line = search('^import (', 'bwn')

    if l:line == 0
        return
    endif

    " want to go to the closing import line fuckery to preserve jumplist
    if a:end == 1
        let l:pos = getcurpos()
        let l:tmp = cursor(l:line, 1)
        let l:line = search('^)$', 'n')
        let l:tmp = setpos('.', l:pos)

        if l:line > 0
            execute 'normal '.l:line.'G'
        endif

        return
    endif

    execute "normal ".l:line."G"
endfunction

function! FunctionJump(dir, isVisual)
    call DefJump(a:dir, '^\s*func\s\+', a:isVisual)
endfunction

function! TypeJump(dir, isVisual)
    call DefJump(a:dir, '^\s*type\s\+', a:isVisual)
endfunction

function! DefJump(dir, pattern, isVisual)
    let l:c = 1
    let l:repeat = v:count1

    while l:c <= l:repeat
        let l:line = search(a:pattern, 'Wn'.a:dir)

        if l:line > 0
            execute "normal ".(a:isVisual ? 'gv': '').l:line."G"
        endif

        let l:c += 1
    endwhile
endfunction

function! EndMethodJump(dir, isVisual)
    call EndJump(a:dir, '^\s*func\s\+', a:isVisual)
endfunction

function! EndStructJump(dir, isVisual)
    call EndJump(a:dir, '\s\+struct\s\+', a:isVisual)
endfunction

function! EndJump(dir, pattern, isVisual)
    let l:start_pos = getcurpos()
    let l:c = 0
    let l:found = 0
    let l:repeat = v:count1

    while l:c < 200 " seems reasonable
        " find next/prev line that is a closing }
        let l:closer = search('^}$', 'Wn'.a:dir)

        if l:closer == 0
            let l:tmp = setpos('.', l:start_pos)
            echoerr "not found"
            return
        endif

        let l:tmp = cursor(l:closer, 1)

        " jump to other end of brace (preserving jumplist)
        execute 'normal! %'

        " is this line a function def?
        let l:line = search(a:pattern, 'b', line('.'))

        " this is a func closer
        if l:line > 0
            let l:found += 1

            if l:found >= l:repeat
                let l:tmp = setpos('.', l:start_pos)
                execute 'normal '.(a:isVisual ? 'gv': '').l:closer.'G'
                return
            endif
        endif

        " not a function def (or not achived count) go to next closing brace and check again..
        let l:tmp = cursor(l:closer, 1)
        let l:c += 1
    endwhile
endfunction

nnoremap <buffer> <silent> <LocalLeader>[i :call FindImport(0)<CR>
nnoremap <buffer> <silent> <LocalLeader>]i :call FindImport(1)<CR>

nnoremap <buffer> <silent> <LocalLeader>[t :<C-U>call TypeJump('b', 0)<CR>
nnoremap <buffer> <silent> <LocalLeader>]t :<C-U>call TypeJump('', 0)<CR>

nnoremap <buffer> <silent> <LocalLeader>[S :<C-U>call EndStructJump('b', 0)<CR>
nnoremap <buffer> <silent> <LocalLeader>]S :<C-U>call EndStructJump('', 0)<CR>

nnoremap <buffer> <silent> [M :<C-U>call EndMethodJump('b', 0)<CR>
nnoremap <buffer> <silent> ]M :<C-U>call EndMethodJump('', 0)<CR>
vnoremap <buffer> <silent> ]M :<C-U>call EndMethodJump('', 1)<CR>
vnoremap <buffer> <silent> [M :<C-U>call EndMethodJump('', 1)<CR>

nnoremap <buffer> <silent> [[ :<C-U>call FunctionJump('b', 0)<CR>
nnoremap <buffer> <silent> ]] :<C-U>call FunctionJump('', 0)<CR>

vnoremap <buffer> <silent> [[ :<C-U>call FunctionJump('b', 1)<CR>
vnoremap <buffer> <silent> ]] :<C-U>call FunctionJump('', 1)<CR>

let b:undo_ftplugin .= ''
            \ . '|nunmap <buffer> [['
            \ . '|nunmap <buffer> ]]'
            \ . '|vunmap <buffer> [['
            \ . '|vunmap <buffer> ]]'
            \ . '|nunmap <buffer> [M'
            \ . '|nunmap <buffer> ]M'
            \ . '|vunmap <buffer> [M'
            \ . '|vunmap <buffer> ]M'
            \ . '|nunmap <buffer> <LocalLeader>[i'
            \ . '|nunmap <buffer> <LocalLeader>]i'
            \ . '|nunmap <buffer> <LocalLeader>[t'
            \ . '|nunmap <buffer> <LocalLeader>]t'
            \ . '|nunmap <buffer> <LocalLeader>[S'
            \ . '|nunmap <buffer> <LocalLeader>]S'
