" Check if a project is pointing at live
function IsLive() abort
    let l = system('dake is_live')
    if len(l) < 2
        return ''
    endif
    let l = l[:-2]
    if stridx(l, 'live') >= 0
        return printf('%%#SpellBad# %s %%*', l)
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
