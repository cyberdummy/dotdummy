if exists("current_compiler")
    finish
endif
let current_compiler = "php-cli"

if exists(":CompilerSet") != 2          " older Vim always used :setlocal
    command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

CompilerSet makeprg=docker-compose\ run\ -T\ --rm\ php-cli\ $*

CompilerSet errorformat=%E%.%#error:\ %m\ in\ /code/%f\ on\ line\ %l
CompilerSet errorformat+=%E%.%#Notice:\ %m\ in\ /code/%f\ on\ line\ %l

let &cpo = s:cpo_save
unlet s:cpo_save
