runtime colors/monokai_pro.vim

function! MyHighlights() abort
    highlight MatchParen ctermbg=blue guibg=lightblue
endfunction

augroup MyColors
    autocmd!
    autocmd ColorScheme * call MyHighlights()
augroup END
