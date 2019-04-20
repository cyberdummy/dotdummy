" Get lint status from ALE
function MyLinterStatus() abort
    if !exists('ale#statusLine#Count')
        return ''
    endif

    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
                \   '%dW %dE',
                \   l:all_non_errors,
                \   l:all_errors
                \)
endfunction

" Get number of errors in quickfix list
function QuickFixStatus() abort
    return len(filter(getqflist(), 'v:val.valid'))
endfunction
