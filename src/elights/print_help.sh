function _elights_print_help {
  cat << endOfHelp
elights CLI command v$1.

Operates the Elgato Key Lights.

Make sure ELGATO_LIGHT_L_ADDRESS and ELGATO_LIGHT_R_ADDRESS
env variables are properly set.

Inspired by https://github.com/adamesch/elgato-key-light-api.

Synopsis: elights [OPTIONS...]

Options:

  -l, --lamp        [ID] specifies the lamp (as an integer ID, 1-indexed).
  -t, --temperature [VALUE] specifies lamp's temperature
                    within the range [143..344]
                    which represents Kelvin [2900K..7000K] accordingly.
  -b, --brightness  [VALUE] specifies lamp's brightness
                    within the range [2..100].
  -e, --enabled     [VALUE] specifies the value of "on" option in the request.
                    Can be only 0 or 1.
  -s, --scene       [SCENE_NAME] specifies the pre-configured scene.
  --on              an alias for "-e 1"
  --off             an alias for "-e 0"
  -h, --help        Displays this reference.
  -v, --version     Displays the version of elights CLI.

Examples:

  > elights --scene work
  > elights -l 1 -b 100 -t 150

Origin: https://github.com/ivkremer/elights-cli
endOfHelp
}
