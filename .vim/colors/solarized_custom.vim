runtime colors/solarized.vim

function! MyHighlights() abort
    highlight SpecialKey ctermbg=NONE
    highlight Conceal ctermfg=10
    highlight Comment cterm=italic
    highlight CursorLineNr cterm=None
endfunction

augroup MyColors
    autocmd!
    autocmd ColorScheme * call MyHighlights()
augroup END
