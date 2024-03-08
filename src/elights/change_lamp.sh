## Sends specified JSON to the specified lamp. Usage:
# _change_lamp -l <lamp_hostname> -b <JSON_body> [--debug]
function _change_lamp {
  # arguments
  declare lamp_hostname=""
  declare request_json=""
  declare is_debug=""
  # end_arguments

  while [[ $# -gt 0 ]]; do
    case $1 in
    -l)
      lamp_hostname="$2"
      shift 2
      ;;
    -b)
      request_json="$2"
      shift 2
      ;;
    --debug)
      is_debug="1"
      shift
      ;;
    *)
      echo -e "\033[0;31m$(_print_stacktrace)\n\n$(_current_func_name): Unknown option: \"$1\". Aborting.\033[0m"
      return 1
      ;;
    esac
  done

  if [[ -z $lamp_hostname ]]; then
    echo -e "\033[0;31m$(_print_stacktrace)\n\n$(_current_func_name): No lamp hostname provided. Aborting.\033[0m"
    return 1
  fi

  declare request_url="http://$lamp_hostname:9123/elgato/lights"

  if [[ -n $is_debug ]]; then
    curl "$request_url" --request PUT --data "$request_json" -m 10 -v
  else
    declare output
    output=$(curl "$request_url" --request PUT --data "$request_json" -m 10 --fail-with-body -s -S 2>&1 1>&2)
    if [[ $? -ne 0 ]]; then
      echo -e "\033[0;31m$(_print_stacktrace)\n\n$(_current_func_name): The following request to the lamp failed:\n"
      echo -e "curl $request_url --request PUT --data '$request_json' -m 10:\n\n$output\nAborting.\033[0m"
      return 1
    fi
  fi
}
