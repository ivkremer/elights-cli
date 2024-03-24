function print_help {
  cat << endOfHelp
elights CLI command v$1.

Operates the Elgato Key Lights.

Make sure $ELGATO_LIGHT_L_ADDRESS and $ELGATO_LIGHT_R_ADDRESS
env variables are properly set.

Inspired by https://github.com/adamesch/elgato-key-light-api.

Synopsis: elights [OPTIONS...]

Options:

  -l, --lamp        [LAMP_NAME] specifies the lamp.
  -t, --temperature [VALUE] specifies lamp's temperature
                    within the range [143..344]
                    which represents Kelvin [2900K..7000K] accordingly.
  -b, --brightness  [VALUE] specifies lamp's brightness
                    within the range [2..100].
  -e, --enabled     [VALUE] specifies the value of "on" option in the request.
                    Can be only 0 or 1.
  --on              an alias for "-e 1"
  --off             an alias for "-e 0"
  -s, --scene       [SCENE_NAME] specifies the pre-configured scene.
  -h, --help        Displays this reference.
  -v, --version     Displays the version of elights CLI.

Examples:

  Set scene "work":
  > elights --scene work
  Change lamp "L": brightness=100, temperature=150
  > elights -l L -b 100 -t 150
  Turn lamp "R" on:
  > elights -l R -e 1

Origin: https://github.com/ivkremer/elights-cli
endOfHelp
}
