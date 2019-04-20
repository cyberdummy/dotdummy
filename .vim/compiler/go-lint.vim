if exists('g:current_compiler') || &compatible
  finish
endif
let g:current_compiler = 'go-lint'

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=dummy-code\ lint-go\ %:S

"CompilerSet errorformat&
"CompilerSet errorformat+=%E<b>%.%#Parse\ error</b>:\ %m\ in\ <b>%f</b>\ on\ line\ <b>%l</b><br\ />,
"      \%W<b>%.%#Notice</b>:\ %m\ in\ <b>%f</b>\ on\ line\ <b>%l</b><br\ />,
"      \%E%.%#Parse\ error:\ %m\ in\ %f\ on\ line\ %l,
"      \%W%.%#Notice:\ %m\ in\ %f\ on\ line\ %l,
"      \%-G%.%#
