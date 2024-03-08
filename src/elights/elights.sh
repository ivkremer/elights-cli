##
# Operates the Elgato Key Lights.
# Make sure ELGATO_LIGHT_L_ADDRESS and ELGATO_LIGHT_R_ADDRESS env variables are properly set.
# Inspired by https://github.com/adamesch/elgato-key-light-api.
#
# Synopsis: elights [OPTIONS...]
#
# Options:
# -l, --lamp        [ID] specifies the lamp (as an integer ID starting from 1).
# -t, --temperature [VALUE] specifies lamp's temperature within the range [143-344]
#                   which represents the range of Kelvin from 2900K to 7000K.
# -b, --brightness  [VALUE] specifies lamp's brightness within the range [2-100].
# -e, --enabled     [VALUE] specifies the value of "on" option in the request. Can be only 0 or 1.
# -s, --scene       [SCENE_NAME] specifies the pre-configured scene.
# --on              an alias for "-e 1"
# --off             an alias for "-e 0"
#
# Examples:
# elights --scene work
# elights -l 1 -b 100 -t 150
function elights {
  # arguments
  declare -i LAMP
  declare TEMPERATURE
  declare BRIGHTNESS
  declare ENABLED
  declare SCENE=""
  declare POSITIONAL_ARGS=()
  # end_arguments

  while [[ $# -gt 0 ]]; do
    case $1 in
    -l | --lamp)
      LAMP="$2"
      shift 2
      ;;
    -t | --temperature)
      TEMPERATURE="$2"
      shift 2
      ;;
    -b | --brightness)
      BRIGHTNESS="$2"
      shift 2
      ;;
    -e | --enabled)
      ENABLED="$2"
      shift 2
      ;;
    -s | --scene)
      SCENE="$2"
      shift 2
      ;;
    --on)
      ENABLED=1
      shift
      ;;
    --off)
      ENABLED=0
      shift
      ;;
    -*)
      echo -e "\033[0;31m$(_print_stacktrace)\n\n$(_current_func_name): Unknown option: \"$1\". Aborting.\033[0m"
      return 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1")
      shift
      ;;
    esac
  done

  set -- "${POSITIONAL_ARGS[@]}"

  if [[ -n $SCENE ]]; then
    _set_scene "$SCENE"
    return
  fi

  if [[ -z $TEMPERATURE ]] && [[ -z $BRIGHTNESS ]] && [[ -z $ENABLED ]]; then
    echo -e "\033[0;31m$(_print_stacktrace)\n\n$(_current_func_name): No options provided for the lamp. Aborting.\033[0m"
    return 1
  fi

  declare lamps_hostnames=()
  case $LAMP in
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

  if [[ -n $ENABLED ]]; then
    changes+=('"on":'"$ENABLED")
  fi

  if [[ -n $BRIGHTNESS ]]; then
    changes+=('"brightness":'"$BRIGHTNESS")
  fi

  if [[ -n $TEMPERATURE ]]; then
    changes+=('"temperature":'"$TEMPERATURE")
  fi

  # Note that arrays are 0-indexed in Bash and 1-indexed in Zsh, so for the sake of compatibility:
  declare changes_json="${changes[*]:0:1}"
  declare -i i
  for ((i = 1; i <= $#changes - 1; i++)); do
    changes_json+=", ${changes[*]:$i:1}"
  done

  declare request_json
  request_json=$(printf '{"numberOfLights": 1, "lights": [{%s}]}' "$changes_json")

  declare lamp_hostname
  for lamp_hostname in "${lamps_hostnames[@]}"; do
    _change_lamp -l "$lamp_hostname" -b "$request_json"
  done
}
