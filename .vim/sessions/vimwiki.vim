" Mark down
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

" Diary template
augroup WikiDiary
    autocmd!
    autocmd BufNewFile ~/vimwiki/diary/*.md 0$pu=strftime('# %A %d %B %Y')
    autocmd BufNewFile ~/vimwiki/diary/*.md :normal Go
augroup END

packadd vimwiki
packadd goyo
packadd limelight
