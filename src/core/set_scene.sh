##
# Sets specified scene. Usage:
# set_scene <scene_name>
#
# Modify this file according to your preferences.
function set_scene {
  declare -i exit_code
  trap 'exit_code=101' ERR

  case $1 in
  max)
    change_lamp -l "$ELGATO_LIGHT_L_ADDRESS" -b '{ "numberOfLights": 1, "lights": [{ "on": 1, "brightness": 100, "temperature": 250 }] }'
    change_lamp -l "$ELGATO_LIGHT_R_ADDRESS" -b '{ "numberOfLights": 1, "lights": [{ "on": 1, "brightness": 100, "temperature": 250 }] }'
    ;;
  cinema)
    change_lamp -l "$ELGATO_LIGHT_L_ADDRESS" -b '{ "numberOfLights": 1, "lights": [{ "on": 1, "brightness": 2, "temperature": 344 }] }'
    change_lamp -l "$ELGATO_LIGHT_R_ADDRESS" -b '{ "numberOfLights": 1, "lights": [{ "on": 0, "brightness": 2, "temperature": 344 }] }'
    ;;
  work)
    change_lamp -l "$ELGATO_LIGHT_L_ADDRESS" -b '{ "numberOfLights": 1, "lights": [{ "on": 1, "brightness": 25, "temperature": 280 }] }'
    change_lamp -l "$ELGATO_LIGHT_R_ADDRESS" -b '{ "numberOfLights": 1, "lights": [{ "on": 1, "brightness": 30, "temperature": 280 }] }'
    ;;
  off)
    change_lamp -l "$ELGATO_LIGHT_L_ADDRESS" -b '{ "numberOfLights": 1, "lights": [{ "on": 0 }] }'
    change_lamp -l "$ELGATO_LIGHT_R_ADDRESS" -b '{ "numberOfLights": 1, "lights": [{ "on": 0 }] }'
    ;;
  on)
    change_lamp -l "$ELGATO_LIGHT_L_ADDRESS" -b '{ "numberOfLights": 1, "lights": [{ "on": 1 }] }'
    change_lamp -l "$ELGATO_LIGHT_R_ADDRESS" -b '{ "numberOfLights": 1, "lights": [{ "on": 1 }] }'
    ;;
  *)
    echo -e "\033[0;31m$(print_stacktrace "Bad usage:")\n$(print_func_name): No such scene \"$1\". Aborting.\033[0m"
    return "$exit_code"
    ;;
  esac
}
