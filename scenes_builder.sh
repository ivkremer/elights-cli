#!/usr/bin/env bash

##
# Usage:
# sh scenes_builder.sh \
#   --source ~/.elights_scenes.ini \
#   --scenes ./build/scenes.txt \
#   --scene-cases ./build/scenes_cases.txt \
#   --warnings ./build/warnings.txt \
#   --guide ./build/guide.txt
#
# This script reads the ini file with scenes and builds Shell case code for src/core/set_scene.sh and also some
# variables-dependant code.
# E.g. there is the following source file:
#
# [max]
# L={ "on": 1, "brightness": 2, "temperature": 344 }
# R={ "on": 0, "brightness": 2, "temperature": 344 }
#
# this script will generate such a code for src/core/set_scene.sh:
#
# max)
#   change_lamp -l "$ELGATO_LIGHT_L_ADDRESS" -b '{ "numberOfLights": 1, "lights": [{ "on": 1, "brightness": 25, "temperature": 280 }] }'
#   change_lamp -l "$ELGATO_LIGHT_R_ADDRESS" -b '{ "numberOfLights": 1, "lights": [{ "on": 1, "brightness": 25, "temperature": 280 }] }'
#
# Also the corresponding case code for `## placeholder scene_cases` in elights.sh (--scene-cases);
# Also the code for warnings regarding the env variables being unset (--warnings);
# And also the guide text for advising how to set up the env vars (--guide).
#
# This script is used in Makefile for building.
##

declare output
declare -i current_line
declare -a lamps

declare target_scenes
declare target_scene_cases
declare target_warnings
declare target_guide
declare source_ini

while [[ $# -gt 0 ]]; do
  case "$1" in
    --scenes)
      target_scenes="$2"
      shift 2
      ;;
    --scene-cases)
      target_scene_cases="$2"
      shift 2
      ;;
    --warnings)
      target_warnings="$2"
      shift 2
      ;;
    --guide)
      target_guide="$2"
      shift 2
      ;;
    --source)
      source_ini="$2"
      shift 2
      ;;
    *)
      exit 1
      ;;
  esac
done

while read -r line
do
  current_line+=1

  declare section
  declare rule

  section=$(echo "$line" | grep -ioE '^\[\w+\]$' | grep -ioE '\w+' | tr '[:upper:]' '[:lower:]')
  rule=$(echo "$line" | grep -ioE '^\w+\=\{.*\}$')

  if [[ -n "$section" ]]; then
    if [[ -n "$output" ]]; then
      # append ;; before the next section (that is a scene) starts
      output+="  ;;\n"
    fi
    output+="$section)\n"
  fi

  if [[ -n "$rule" ]]; then
    declare lamp_name
    lamp_name=$(echo "$rule" | grep -ioE '^\w+\={.*}$' | grep -ioE '^\w+=' | grep -ioE '\w+' | tr '[:lower:]' '[:upper:]')

    if ! echo "${lamps[@]}" | grep -qE "\b$lamp_name\b"; then
      # building the list of unique lamp IDs:
      lamps+=("$lamp_name")
    fi

    declare lamp_json
    lamp_json=$(echo "$rule" | grep -ioE '=.*$' | grep -ioE '{.*}$' | tr '[:upper:]' '[:lower:]')

    output+="  change_lamp -l \"\$ELGATO_LIGHT_${lamp_name}_ADDRESS\" -b '{ \"numberOfLights\": 1, \"lights\": [$lamp_json] }'\n"
  fi
done < "$source_ini"

output+="  ;;\n"

echo "$output" > "$target_scenes"

output=""

# Building the case-code in src/core/elights.sh:
for lamp in "${lamps[@]}"
do
  output+="$lamp)\n"
  output+="  lamps_hostnames=(\"\$ELGATO_LIGHT_${lamp}_ADDRESS\")\n"
  output+="  ;;\n"
done

declare all_lamps
for lamp in "${lamps[@]}"
do
  if [[ -n "$all_lamps" ]]; then
    all_lamps+=" "
  fi
  all_lamps+="\"\$ELGATO_LIGHT_${lamp}_ADDRESS\""
done

output+="*)\n"
output+="  lamps_hostnames=($all_lamps)\n"
output+="  ;;"

echo "$output" > "$target_scene_cases"

output=""
for lamp in "${lamps[@]}"
do
  output+="if [[ -z \"\$ELGATO_LIGHT_${lamp}_ADDRESS\" ]]; then\n"
  output+="  echo -e \"\\\033[1;33mWARNING: ELGATO_LIGHT_${lamp}_ADDRESS env variable is not defined.\\\033[0m\"\n"
  output+="fi\n"
done

echo "$output" > "$target_warnings"

output="Make sure the following env variables are properly set and exported:\n\n"
for lamp in "${lamps[@]}"
do
  output+="  export ELGATO_LIGHT_${lamp}_ADDRESS=<${lamp} Lamp IP address>\n"
done

echo "$output" > "$target_guide"
