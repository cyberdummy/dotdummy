function! RestoreFilePosition() abort
    if line("'\"") > 0 && line("'\"") <= line('$') && !has('nvim') && &ft !~# 'commit'
        execute "normal! g`\""
    endif
endfunction

augroup restore_file_position
    autocmd!
    autocmd BufReadPost * call RestoreFilePosition()
augroup END
