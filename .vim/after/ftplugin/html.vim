setlocal tabstop=2 " number of spaces per tab
setlocal softtabstop=2 " number of spaces when editing
setlocal shiftwidth=2 " autoindentation also << >> & ==
let b:undo_ftplugin .= '|setlocal tabstop< softtabstop< shiftwidth<'
