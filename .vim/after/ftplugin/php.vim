let g:PHP_vintage_case_default_indent = 1 " PSR compliant switch indents

setlocal tabstop=4 " number of spaces per tab
setlocal softtabstop=4 " number of spaces when editing
setlocal shiftwidth=4 " autoindentation also << >> & ==
setlocal textwidth=80 " just applies to comments

" stop // comments from continuing on next line
setlocal comments-=://
setlocal comments+=f://
setlocal commentstring=//\ %s " default comment string
setlocal formatoptions=qrocb

let b:undo_ftplugin .= '|setlocal tabstop< softtabstop< shiftwidth< textwidth<'
    \ . ' comments< commentstring< formatoptions<'

compiler php-lint

" Lint on save
augroup MyPHP
    autocmd! * <buffer>
    autocmd BufWritePost <buffer> silent lmake! <afile> | silent redraw!
augroup END

let b:undo_ftplugin .= '|unlet b:current_compiler'
    \ . '|setlocal errorformat< makeprg< textwidth<'
    \ . "|execute 'autocmd! MyPHP * <buffer>'"

" include files

function! PHPIncludeExpr(fname)
    " if path has \ turn then into /
    let l:newName = substitute(a:fname, '\', '/', 'g').'.php'
    " no starting slash
    let l:newName = substitute(l:newName, '^/', '', 'g')
    " if its starts with App/ then its probably a laravel project change to
    " app/
    let l:newName = substitute(l:newName, '^App/', 'app/', 'g')
    return l:newName
endfunction

" make gf use psr4 namespacing
setlocal includeexpr=PHPIncludeExpr(v:fname)
" backslash in file name so we can convert "use" paths to files
setlocal isfname+=\\
setlocal suffixesadd=.php
setlocal path-=.
setlocal path+=,,vendor/*/*/src

 " add include|require when I need to
setlocal include=use\\s

setlocal define=\\\(\\s\\\|\^\\\)\\\(function\\\|class\\\|trait\\\|interface\\\)\\s
"setlocal iskeyword+=$\\

let b:undo_ftplugin .= '|setlocal includeexpr< isfname< suffixesadd< path<'
    \ . ' include< define<'

" highlight PHPDoc tags
highlight! link phpDocTags phpDefine
highlight! link phpDocParam phpType

function! s:DefJump(dir, pattern, isVisual)
    let l:c = 1
    let l:repeat = v:count1
    let l:startPos = getcurpos()
    let l:dir = a:dir
    let l:moved = 0

    " want to start at top
    if l:dir == 'f'
        let l:tmp = cursor(1, 1)
        let l:dir = ''
    " want to go up from bottom
    elseif l:dir == 'l'
        let l:tmp = cursor(line('$'), 1)
        let l:dir = 'b'
    endif

    while l:c <= l:repeat
        let l:line = search(a:pattern, 'Wn'.l:dir)

        if l:line > 0
            " we want first jump to be from our starting position
            if l:moved == 0
                let l:tmp = setpos('.', l:startPos)
            endif
            execute "normal ".(a:isVisual ? 'gv': '').l:line."G"
            let l:moved = 1
        else
            break
        endif

        let l:c += 1
    endwhile

    " make sure we are still at where we started
    if l:moved == 0
        let l:tmp = setpos('.', l:startPos)
    endif
endfunction

function! s:PropJump(dir, isVisual)
    call s:DefJump(a:dir, '^\s*\zs\(\(protected\|private\|public\|static\)\|const\s\+[A-Z]\)\s\+\$', a:isVisual)
endfunction

function! s:ClassJump(dir, isVisual)
    call s:DefJump(a:dir, '^\s*\zs\(class\|trait\|interface\|abstract\)\s\+[A-Za-z]', a:isVisual)
endfunction

function! s:MethodJump(dir, isVisual)
    call s:DefJump(a:dir, '^\s*\zs\(public\|private\|protected\|static\)\s\+function\s\+[A-Za-z_]', a:isVisual)
endfunction

function! s:UseJump(dir, isVisual)
    call s:DefJump(a:dir, '^use\s\+[A-Za-z]', a:isVisual)
endfunction

" First use import
nnoremap <buffer> <silent> <LocalLeader>[i :<C-U>call <SID>UseJump('f', 0)<CR>
" Last use import
nnoremap <buffer> <silent> <LocalLeader>]i :<C-U>call <SID>UseJump('l', 0)<CR>

" Start of class
nnoremap <buffer> <silent> <LocalLeader>[c :<C-U>call <SID>ClassJump('f', 0)<CR>

" First prop
nnoremap <buffer> <silent> <LocalLeader>[P :<C-U>call <SID>PropJump('f', 0)<CR>
" Prev prop
nnoremap <buffer> <silent> <LocalLeader>[p :<C-U>call <SID>PropJump('b', 0)<CR>
" Next Prop
nnoremap <buffer> <silent> <LocalLeader>]p :<C-U>call <SID>PropJump('', 0)<CR>
" Last Prop
nnoremap <buffer> <silent> <LocalLeader>]P :<C-U>call <SID>PropJump('l', 0)<CR>

" Prev Method
nnoremap <buffer> <silent> [[ :<C-U>call <SID>MethodJump('b', 0)<CR>
vnoremap <buffer> <silent> [[ :<C-U>call <SID>MethodJump('b', 1)<CR>
" Next Method
nnoremap <buffer> <silent> ]] :<C-U>call <SID>MethodJump('', 0)<CR>
vnoremap <buffer> <silent> ]] :<C-U>call <SID>MethodJump('', 1)<CR>

nnoremap <buffer> <Leader>t :read ~/.vim/templates/php/**/*<C-z><S-Tab>

let b:undo_ftplugin .= ''
            \ . '|nunmap <buffer> [['
            \ . '|vunmap <buffer> [['
            \ . '|nunmap <buffer> ]]'
            \ . '|vunmap <buffer> ]]'
            \ . '|nunmap <buffer> <LocalLeader>[i'
            \ . '|nunmap <buffer> <LocalLeader>]i'
            \ . '|nunmap <buffer> <LocalLeader>[c'
            \ . '|nunmap <buffer> <LocalLeader>[P'
            \ . '|nunmap <buffer> <LocalLeader>[p'
            \ . '|nunmap <buffer> <LocalLeader>]p'
            \ . '|nunmap <buffer> <LocalLeader>]P'
            \ . '|nunmap <buffer> <Leader>t'
