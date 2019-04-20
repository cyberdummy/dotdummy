function s:ShowSyntaxBlocks()
    if !exists('*synstack')
        return
    endif

    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

nnoremap <Plug>(ShowSyntaxBlocks)
      \ :<C-U>call <SID>ShowSyntaxBlocks()<CR>
