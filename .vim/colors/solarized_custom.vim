runtime colors/solarized.vim

function! MyHighlights() abort
    highlight SpecialKey ctermbg=8
    highlight Conceal ctermfg=10
    highlight Comment cterm=italic
    highlight CursorLineNr cterm=None
endfunction

augroup MyColors
    autocmd!
    autocmd ColorScheme * call MyHighlights()
augroup END
