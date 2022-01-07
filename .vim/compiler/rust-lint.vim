if exists('g:current_compiler') || &compatible
  finish
endif
let g:current_compiler = 'rust-lint'

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet errorformat&

if filereadable("dakefile")
    CompilerSet makeprg=dake\ lint\ %:S
else
    CompilerSet makeprg=dummy-code\ lint-rust\ %:S
endif
