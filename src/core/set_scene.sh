##
# Sets specified scene. Usage:
# set_scene <scene_name>
#
# Modify this file according to your preferences.
function set_scene {
  declare -i exit_code
  trap 'exit_code=101' ERR

  case $1 in
## placeholder scenes
  *)
    echo -e "\033[0;31m$(print_stacktrace "Bad usage:")\n$(print_func_name): No such scene \"$1\". Aborting.\033[0m"
    return "$exit_code"
    ;;
  esac
}
