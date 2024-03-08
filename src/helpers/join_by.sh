##
# Joins an array into a single string using the given delimiter:
# _join_by <delimeter> <list>
# e.g.:
# > _join_by , a b c
# a,b,c
function _join_by {
  local delimeter=${1-} list=${2-}
  if shift 2; then
    printf %s "$list" "${@/#/$delimeter}"
  fi
}
