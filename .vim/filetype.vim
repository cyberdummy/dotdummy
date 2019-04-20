" my filetype file
if exists("g:did_load_filetypes")
    finish
endif

augroup filetypedetect
    au! BufRead,BufNewFile *.xresources setfiletype xdefaults
    au! BufNewFile,BufRead *.muttrc setfiletype muttrc
    au! BufNewFile,BufRead *.h setfiletype c
    au! BufNewFile,BufRead *.blade.php setfiletype html
augroup END
