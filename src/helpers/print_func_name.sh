##
# Prints function name which is currently being executed.
function print_func_name () {
  if [[ -n $BASH_VERSION ]]; then
    printf "%s" "${FUNCNAME[@]:1:1}"
  else
    printf "%s" "${funcstack[@]:1:1}"
  fi
}
