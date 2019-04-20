setlocal bufhidden=delete " otherwise netrw wont let us shutdown
" escape exits netrw
nnoremap <buffer> <esc> :bd<CR>
