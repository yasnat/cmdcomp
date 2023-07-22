#!/bin/zsh

function _cliname () {
    local context curcontext=$curcontext state line
    declare -A opt_args
    local ret=1

    _arguments -C \
        '(-h --help)'{-h,--help}'[show help]' \
        '(-v --version)'{-v,--version}'[print the version]' \
        '1: :__cliname_commands' \
        '*:: :->args' \
        && ret=0

    case $state in
        (args)
           case $words[1] in
                (get)
                    _arguments -C \
                        '(-u --update)'{-u,--update}'[Update local repository if cloned already]' \
                        '(-)*:: :->null_state' \
                        && ret=0
                    ;;
                (list)
                    _arguments -C \
                        '(-e --exact)'{-e,--exact}'[Perform an exact match]' \
                        '(-p --full-path)'{-p,--full-path}'[Print full paths]' \
                        '--unique[Print unique subpaths]' \
                        '(-)*:: :->null_state' \
                        && ret=0
                    ;;
                (look)
                    _arguments -C \
                        '1: :__ghq_repositories' \
                        && ret=0
                    ;;
                (import)
                    _arguments -C \
                        '(-u)-u[]' \
                        '(- :)*: :(starred pocket)' \
                        && ret=0
                    ;;
                (help|h)
                    __ghq_commands && ret=0
                    ;;
            esac
            ;;
    esac

    return ret
}

__cliname_commands () {
    local -a _c
    _c=(
        'get:Clone/sync with a remote repository'
        'list:List local repositories'
        'look:Look into a local repository'
        'import:Import repositories from other web services'
        'help:Shows a list of commands or help for one command'
    )

    _describe -t commands Commands _c
}

__ghq_repositories () {
    local -a _repos
    _repos=( ${(@f)"$(_call_program repositories ghq list --unique)"} )
    _describe -t repositories Repositories _repos
}


compdef _cliname cliname
