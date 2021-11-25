if exists('g:current_compiler') || &compatible
  finish
endif
let g:current_compiler = 'shell-fmt'

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=dummy-code\ shell-fmt\ %:S
