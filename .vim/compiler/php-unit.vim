if exists("current_compiler")
    finish
endif
let current_compiler = "php-unit"

if exists(":CompilerSet") != 2          " older Vim always used :setlocal
    command -nargs=* CompilerSet setlocal <args>
endif

let s:cpo_save = &cpo
set cpo-=C

"CompilerSet makeprg=vendor/bin/phpunit
CompilerSet makeprg=docker-compose\ run\ -T\ --rm\ php-cli\ vendor/bin/phpunit\ $*\ \\\|\ grep\ -v\ vendor
CompilerSet errorformat=%E%n)\ %.%#,%Z/code/%f:%l,%C%m,%C,%-G%.%#

let &cpo = s:cpo_save
unlet s:cpo_save
