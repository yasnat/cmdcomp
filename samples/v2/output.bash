#!/bin/bash

_cliname() {
  local word cmd opts cur cmd_cur opts_cur
  COMPREPLY=()
  cmd=""
  opts=""
  cur=0
  cmd_cur=0
  opts_cur=0

  for word in ${COMP_WORDS[@]}; do
    case "${cmd},${word}" in
      ",$1")
        cmd="_cliname"
        cur=$(( cur + opts_cur + 1 ))
        ;;

      _cliname,list|_cliname,ls)
        cmd="_cliname_list"
        cur=$(( cur + opts_cur + 1 ))
        ;;

      _cliname,cd)
        cmd="_cliname_cd"
        cur=$(( cur + opts_cur + 1 ))
        ;;

      _cliname,test)
        cmd="_cliname_test"
        cur=$(( cur + opts_cur + 1 ))
        ;;

      _cliname_test,rubocop)
        cmd="_cliname_test_rubocop"
        cur=$(( cur + opts_cur + 1 ))
        ;;

      _cliname_test,pytest)
        cmd="_cliname_test_pytest"
        cur=$(( cur + opts_cur + 1 ))
        ;;

      *)
        opts_cur=$(( opts_cur + 1 ))
        ;;
    esac
  done

  case "${cmd}" in
    _cliname)
      cmd_cur=$cur
      while [ $cur -lt $COMP_CWORD ] ; do
        cur=$(( cur + 1 ))
        case "${COMP_WORDS[cur-1]}" in
          --verbose)
            cmd_cur=$(( cmd_cur + 1 ))
            ;;

          --no-verbose)
            cmd_cur=$(( cmd_cur + 1 ))
            ;;

          --version|-V)
            cmd_cur=$(( cmd_cur + 1 ))
            ;;

          --config)
            if [ $cur -eq $COMP_CWORD ] ; then
              file_completion "."

              return 0
            else
              cmd_cur=$(( cmd_cur + 2 ))
            fi
            ;;

          --help)
            cmd_cur=$(( cmd_cur + 1 ))
            ;;

          *)
            break
            ;;
        esac
      done

      if [[ ${COMP_WORDS[COMP_CWORD]} == -* ]] ; then
        opts="--verbose --no-verbose --version -V --config --help"
        COMPREPLY=( $(compgen -W "${opts}" -- "${COMP_WORDS[COMP_CWORD]}") )
        return 0
      elif [ $cur -eq $COMP_CWORD ] ; then
        opts="list ls cd test"
        COMPREPLY=( $(compgen -W "${opts}" -- "${COMP_WORDS[COMP_CWORD]}") )
        return 0
      fi

      return 0
      ;;

    _cliname_list)
      cmd_cur=$cur
      while [ $cur -lt $COMP_CWORD ] ; do
        cur=$(( cur + 1 ))
        case "${COMP_WORDS[cur-1]}" in
          --all|-a)
            cmd_cur=$(( cmd_cur + 1 ))
            ;;

          *)
            break
            ;;
        esac
      done

      if [[ ${COMP_WORDS[COMP_CWORD]} == -* ]] ; then
        opts="--all -a"
        COMPREPLY=( $(compgen -W "${opts}" -- "${COMP_WORDS[COMP_CWORD]}") )
        return 0
      fi
      cur=$COMP_CWORD
      if [ $cur -eq $COMP_CWORD ] ; then
        file_completion "."

        return 0
      else
        cmd_cur=$(( cmd_cur + 2 ))
      fi

      return 0
      ;;

    _cliname_cd)
      cmd_cur=$cur
      while [ $cur -lt $COMP_CWORD ] ; do
        cur=$(( cur + 1 ))
        case "${COMP_WORDS[cur-1]}" in
          -P)
            cmd_cur=$(( cmd_cur + 1 ))
            ;;

          *)
            break
            ;;
        esac
      done
      if [[ ! ${COMP_WORDS[COMP_CWORD]} == -* ]] ; then
        cur=$COMP_CWORD
        case $(( COMP_CWORD - cmd_cur + 1)) in
          1)
            if [ $cur -eq $COMP_CWORD ] ; then
            file_completion "$HOME"

            return 0
          else
            cmd_cur=$(( cmd_cur + 2 ))
          fi
            ;;
        esac
      fi

      if [[ ${COMP_WORDS[COMP_CWORD]} == -* ]] ; then
        opts="-P"
        COMPREPLY=( $(compgen -W "${opts}" -- "${COMP_WORDS[COMP_CWORD]}") )
        return 0
      fi

      return 0
      ;;

    _cliname_test)
      cmd_cur=$cur
      while [ $cur -lt $COMP_CWORD ] ; do
        cur=$(( cur + 1 ))
      done

      if [[ ${COMP_WORDS[COMP_CWORD]} == -* ]] ; then
        opts=""
        COMPREPLY=( $(compgen -W "${opts}" -- "${COMP_WORDS[COMP_CWORD]}") )
        return 0
      elif [ $cur -eq $COMP_CWORD ] ; then
        opts="rubocop pytest"
        COMPREPLY=( $(compgen -W "${opts}" -- "${COMP_WORDS[COMP_CWORD]}") )
        return 0
      fi

      return 0
      ;;

    _cliname_test_rubocop)
      cmd_cur=$cur
      while [ $cur -lt $COMP_CWORD ] ; do
        cur=$(( cur + 1 ))
        case "${COMP_WORDS[cur-1]}" in
          --auto-correct|-A)
            cmd_cur=$(( cmd_cur + 1 ))
            ;;

          *)
            break
            ;;
        esac
      done

      opts="--auto-correct -A"
      COMPREPLY=( $(compgen -W "${opts}" -- "${COMP_WORDS[COMP_CWORD]}") )

      return 0
      ;;

    _cliname_test_pytest)
      cmd_cur=$cur
      while [ $cur -lt $COMP_CWORD ] ; do
        cur=$(( cur + 1 ))
      done

      opts=""
      COMPREPLY=( $(compgen -W "${opts}" -- "${COMP_WORDS[COMP_CWORD]}") )

      return 0
      ;;

  esac
}

complete -F _cliname -o bashdefault -o default cliname
complete -F _cliname -o bashdefault -o default cliname2
