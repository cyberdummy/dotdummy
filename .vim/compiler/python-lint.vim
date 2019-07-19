if exists('g:current_compiler') || &compatible
  finish
endif
let g:current_compiler = 'python-lint'

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=dummy-code\ lint-python\ %:S

CompilerSet errorformat&
CompilerSet errorformat+=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
