## Sends specified JSON to the specified lamp. Usage:
# change_lamp -l <lamp hostname> -b <JSON body> [--debug]
function change_lamp {
  # arguments
  declare arg_lamp_hostname=""
  declare arg_request_json=""
  declare arg_is_debug=""
  # end arguments

  while [[ $# -gt 0 ]]; do
    case $1 in
    -l)
      arg_lamp_hostname="$2"
      shift 2
      ;;
    -b)
      arg_request_json="$2"
      shift 2
      ;;
    --debug)
      arg_is_debug="1"
      shift
      ;;
    *)
      echo -e "\033[0;31m$(print_stacktrace "Bad usage:")\n$(print_func_name): Unknown option: \"$1\". Aborting.\033[0m"
      return 1
      ;;
    esac
  done

  if [[ -z $arg_lamp_hostname ]]; then
    echo -e "\033[0;31m$(print_stacktrace "Bad usage:")\n$(print_func_name): No lamp hostname provided. Aborting.\033[0m"
    return 1
  fi

  declare request_url="http://$arg_lamp_hostname:9123/elgato/lights"

  if [[ -n $arg_is_debug ]]; then
    curl "$request_url" --request PUT --data "$arg_request_json" -m 10 -v
  else
    declare output
    output=$(curl "$request_url" --request PUT --data "$arg_request_json" -m 10 --fail-with-body -s -S 2>&1 1>&2)
    if [[ $? -ne 0 ]]; then
      echo -e "\033[0;31m$(print_stacktrace "Network error:")\n$(print_func_name): The following request to the lamp failed:\n"
      echo -e "curl $request_url --request PUT --data '$arg_request_json' -m 10:\n\n$output\nAborting.\033[0m"
      return 11
    fi
  fi
}
