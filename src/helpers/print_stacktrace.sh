##
# Prints a stacktrace for a script and a function being currently executed.
# e.g.:
# echo -e "Error occurred:\n$(print_stacktrace [error title])\n"
# Inspired by: https://gist.github.com/akostadinov/33bb2606afe1b334169dfbf202991d36.
# Line number in Bash is not displayed.
function print_stacktrace {
  # arguments
  declare arg_header="$1"
  # end arguments

  declare stacktrace=""
  declare indent="  "
  declare -i i

  if [[ -n $BASH_VERSION ]]; then
    declare length=${#FUNCNAME[@]}
    for ((i = 1; i < length; i++)); do
      declare func="${FUNCNAME[$i]}"
      if [[ -z "$func" ]]; then
        func="[TOP LEVEL]"
      fi

      declare source="${BASH_SOURCE[$i]}"
      if [[ -z "$source" ]]; then
        source="[NO SOURCE]"
      fi

      stacktrace+="${indent}_> $func() in [$source]\n"
      indent="${indent}  "
    done

    if [[ -n "$arg_header" ]]; then
      printf '%s\n\n%s\n' "$arg_header" "$stacktrace"
    else
      printf '%s\n' "$stacktrace"
    fi
  else
    for ((i = 1; i < $#functrace; i++)); do
      # shellcheck disable=SC2154
      stacktrace+="${indent}_> ${functrace[i]} in [${funcsourcetrace[i + 1]}]\n"
      indent="${indent}  "
    done

    if [[ -n "$arg_header" ]]; then
      printf '%s\n\n%s\n' "$arg_header" "$stacktrace"
    else
      printf '%s\n' "$stacktrace"
    fi
  fi
}
