if exists('g:current_compiler') || &compatible
  finish
endif
let g:current_compiler = 'php-lint'

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

if filereadable("dakefile")
    CompilerSet makeprg=dake\ lint\ %:S
else
    CompilerSet makeprg=dummy-code\ lint-php\ %:S
endif

CompilerSet errorformat&

" phpmd
CompilerSet errorformat+=%E%f:%l%\\s%#%m

" php -l
CompilerSet errorformat+=%E<b>%.%#Parse\ error</b>:\ %m\ in\ <b>%f</b>\ on\ line\ <b>%l</b><br\ />,
      \%W<b>%.%#Notice</b>:\ %m\ in\ <b>%f</b>\ on\ line\ <b>%l</b><br\ />,
      \%E%.%#Parse\ error:\ %m\ in\ %f\ on\ line\ %l,
      \%W%.%#Notice:\ %m\ in\ %f\ on\ line\ %l,
      \%-G%.%#
