setlocal tabstop=4 " number of spaces per tab
setlocal softtabstop=4 " number of spaces when editing
setlocal shiftwidth=4 " autoindentation also << >> & ==
setlocal textwidth=79

let b:undo_ftplugin .= '|setlocal tabstop< softtabstop< shiftwidth< textwidth<'

compiler python-lint

" Lint on save
augroup MyPython
    autocmd! * <buffer>
    autocmd BufWritePost <buffer> silent make! <afile> | silent redraw!
augroup END

let b:undo_ftplugin .= '|unlet b:current_compiler'
    \ . '|setlocal errorformat< makeprg< textwidth<'
    \ . "|execute 'autocmd! MyPython * <buffer>'"
