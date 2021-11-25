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

" Check if a project is point at live
function IsLive() abort
    let l = system('dake is_live')
    if len(l) < 2
        return ''
    endif
    let l = l[:-2]
    if stridx(l, 'live') >= 0
        return printf('%%#ErrorMsg# %s %%*', l)
    endif

    return printf('%%#DiffAdd# %s %%*', l)
endfunction

" Get number of errors in quickfix list
function QuickFixStatus() abort
    return len(filter(getqflist(), 'v:val.valid'))
endfunction

" Get number of errors in location list
function LocationListStatus() abort
    return len(filter(getloclist(0), 'v:val.valid'))
endfunction
