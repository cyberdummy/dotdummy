setlocal tabstop=2 " number of spaces per tab
setlocal softtabstop=2 " number of spaces when editing
setlocal shiftwidth=2 " autoindentation also << >> & ==

let b:undo_ftplugin .= '|setlocal tabstop< softtabstop< shiftwidth<'

setlocal suffixesadd+=.js
setlocal suffixesadd+=.jsx
setlocal include=^\\s*[^\/]\\+\\(from\\\|require(['\"]\\)
"setlocal define=\\\(\\s\\\|\^\\\)\\\(function\\\|class\\\|=>\\\)

"export const NAME = async (endpoint = '', params = {}, action = '') =>
"   await something()
let &l:define = '^\s*\(export\s*\)\?\(const\s*\)\ze\i\+\s*=.*=>'

let b:undo_ftplugin .= '|setlocal suffixesadd< include< define<'

