function elights {
  ## function helpers/print_stacktrace.sh
  ## function helpers/print_func_name.sh
  ## function core/set_scene.sh
  ## function core/change_lamp.sh
  ## function core/print_help.sh

  # arguments
  declare -i arg_lamp
  declare arg_temperature
  declare arg_brightness
  declare arg_is_enabled
  declare arg_scene=""
  declare arg_positional=()
  # end arguments

  declare version="1.3.0"

  while [[ $# -gt 0 ]]; do
    case $1 in
    -l | --lamp)
      arg_lamp="$2"
      shift 2
      ;;
    -t | --temperature)
      arg_temperature="$2"
      shift 2
      ;;
    -b | --brightness)
      arg_brightness="$2"
      shift 2
      ;;
    -e | --enabled)
      arg_is_enabled="$2"
      shift 2
      ;;
    -s | --scene)
      arg_scene="$2"
      shift 2
      ;;
    --on)
      arg_is_enabled=1
      shift
      ;;
    --off)
      arg_is_enabled=0
      shift
      ;;
    -h | --help)
      print_help "$version"
      return
      ;;
    -v | --version)
      echo "$version"
      return
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo -e "\033[0;31m$(print_stacktrace "Bad usage:")\n$(print_func_name): Unknown option: \"$1\". Aborting.\033[0m"
      return 1
      ;;
    *)
      arg_positional+=("$1")
      shift
      ;;
    esac
  done

  set -- "${arg_positional[@]}"

  if [[ -n $arg_scene ]]; then
    set_scene "$arg_scene"
    return $?
  fi

  if [[ -z $arg_temperature ]] && [[ -z $arg_brightness ]] && [[ -z $arg_is_enabled ]]; then
    echo -e "\033[0;31m$(print_stacktrace "Bad usage:")\n$(print_func_name): No options provided for the lamp. Aborting.\033[0m"
    return 1
  fi

  declare lamps_hostnames=()
  case $arg_lamp in
  1)
    lamps_hostnames=("$ELGATO_LIGHT_L_ADDRESS")
    ;;
  2)
    lamps_hostnames=("$ELGATO_LIGHT_R_ADDRESS")
    ;;
  *)
    # Apply to both lamps if no lamp was specified:
    lamps_hostnames=("$ELGATO_LIGHT_L_ADDRESS" "$ELGATO_LIGHT_R_ADDRESS")
    ;;
  esac

  declare -a changes

  if [[ -n $arg_is_enabled ]]; then
    changes+=('"on": '"$arg_is_enabled")
  fi

  if [[ -n $arg_brightness ]]; then
    changes+=('"brightness": '"$arg_brightness")
  fi

  if [[ -n $arg_temperature ]]; then
    changes+=('"temperature": '"$arg_temperature")
  fi

  # Note that arrays are 0-indexed in Bash and 1-indexed in Zsh,
  # so for the sake of compatibility we are concatenating JSON in the following way:
  declare changes_json="${changes[*]:0:1}"
  declare -i i
  for ((i = 1; i <= $#changes - 1; i++)); do
    changes_json+=", ${changes[*]:$i:1}"
  done

  declare request_json
  request_json=$(printf '{ "numberOfLights": 1, "lights": [{ %s }] }' "$changes_json")

  declare lamp_hostname
  for lamp_hostname in "${lamps_hostnames[@]}"; do
    change_lamp -l "$lamp_hostname" -b "$request_json"
  done
}
