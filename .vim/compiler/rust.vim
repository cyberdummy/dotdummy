if exists("g:current_compiler")
  finish
endif
let g:current_compiler = "rust"

" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:save_cpo = &cpo
set cpo-=C

"CompilerSet makeprg=dummy-code\ build-rust
CompilerSet makeprg=cargo\ clippy

CompilerSet errorformat&

CompilerSet errorformat=
            \%-G,
            \%-Gerror:\ aborting\ %.%#,
            \%-Gerror:\ Could\ not\ compile\ %.%#,
            \%Eerror:\ %m,
            \%Eerror[E%n]:\ %m,
            \%Wwarning:\ %m,
            \%Inote:\ %m,
            \%-Z\ %#-->\ %f:%l:%c,
            \%-G%.%#
"\%E\ \ left:%m,%C\ right:%m\ %f:%l:%c,%Z

"let &efm .= '%-Z%*\s--> %f:%l:%c,'

CompilerSet errorformat+=
            \%-G%\\s%#Downloading%.%#,
            \%-G%\\s%#Compiling%.%#,
            \%-G%\\s%#Finished%.%#,
            \%-G%\\s%#error:\ Could\ not\ compile\ %.%#,
            \%-G%\\s%#To\ learn\ more\\,%.%#,
            \%-Gnote:\ Run\ with\ \`RUST_BACKTRACE=%.%#,
            \%.%#panicked\ at\ \\'%m\\'\\,\ %f:%l:%c
