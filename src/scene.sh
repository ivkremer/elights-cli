#!/bin/bash

# Usage:
# In Stream Deck app chose "System > Open" as an action handler.
# Locate this file, copy its path and paste in "App / File" input field.
# Then add the desired scene after the path in quotes as following:
# "/Users/ivkremer/.zsh_helpers/elights/scene.sh" work
#
# Having $ELGATO_LIGHT_L_ADDRESS and $ELGATO_LIGHT_R_ADDRESS are required.

if [[ -f ~/.env.sh ]]; then
  source ~/.env.sh
fi
source ./elights.sh
elights --scene "$1"
