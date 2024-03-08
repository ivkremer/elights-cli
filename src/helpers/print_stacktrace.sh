##
# Prints a stacktrace for a script and a function being currently executed.
# e.g.:
# echo -e "Error occurred:\n$(_print_stacktrace)\n"
# Bash incompatible.
function _print_stacktrace {
  printf 'sources:\n\n%s\n\ncalls:\n\n%s' "$(_join_by \\n "${funcsourcetrace[@]:1}")" "$(_join_by \\n "${functrace[@]:0:-1}")"
}
