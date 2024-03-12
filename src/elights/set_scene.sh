##
# Sets specified scene. Usage:
# _elights_set_scene <scene_name>
#
# Modify this file according to your preferences.
function _elights_set_scene {
  declare -i exit_code
  trap 'exit_code=101' ERR

  case $1 in
  max)
    _elights_change_lamp -l "$ELGATO_LIGHT_L_ADDRESS" -b '{ "numberOfLights": 1, "lights": [{ "on": 1, "brightness": 100, "temperature": 250 }] }'
    _elights_change_lamp -l "$ELGATO_LIGHT_R_ADDRESS" -b '{ "numberOfLights": 1, "lights": [{ "on": 1, "brightness": 100, "temperature": 250 }] }'
    ;;
  cinema)
    _elights_change_lamp -l "$ELGATO_LIGHT_L_ADDRESS" -b '{ "numberOfLights": 1, "lights": [{ "on": 1, "brightness": 2, "temperature": 344 }] }'
    _elights_change_lamp -l "$ELGATO_LIGHT_R_ADDRESS" -b '{ "numberOfLights": 1, "lights": [{ "on": 0, "brightness": 2, "temperature": 344 }] }'
    ;;
  work)
    _elights_change_lamp -l "$ELGATO_LIGHT_L_ADDRESS" -b '{ "numberOfLights": 1, "lights": [{ "on": 1, "brightness": 25, "temperature": 280 }] }'
    _elights_change_lamp -l "$ELGATO_LIGHT_R_ADDRESS" -b '{ "numberOfLights": 1, "lights": [{ "on": 1, "brightness": 30, "temperature": 280 }] }'
    ;;
  off)
    _elights_change_lamp -l "$ELGATO_LIGHT_L_ADDRESS" -b '{ "numberOfLights": 1, "lights": [{ "on": 0 }] }'
    _elights_change_lamp -l "$ELGATO_LIGHT_R_ADDRESS" -b '{ "numberOfLights": 1, "lights": [{ "on": 0 }] }'
    ;;
  on)
    _elights_change_lamp -l "$ELGATO_LIGHT_L_ADDRESS" -b '{ "numberOfLights": 1, "lights": [{ "on": 1 }] }'
    _elights_change_lamp -l "$ELGATO_LIGHT_R_ADDRESS" -b '{ "numberOfLights": 1, "lights": [{ "on": 1 }] }'
    ;;
  *)
    echo -e "\033[0;31m$(_elights_print_stacktrace "Bad usage:")\n$(_elights_current_func_name): No such scene \"$1\". Aborting.\033[0m"
    return "$exit_code"
    ;;
  esac
}
