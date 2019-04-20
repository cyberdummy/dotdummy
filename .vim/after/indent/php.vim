" vim overwrites this with its indent file..
setlocal comments-=://
setlocal comments+=f://
setlocal formatoptions=qrocb
let b:undo_ftplugin .= '|setlocal comments< formatoptions<'
