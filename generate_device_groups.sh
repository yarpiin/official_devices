#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
ORANGE='\033[0;33m'
ENDCOLOR='\033[0m'

dependencies="jq coreutils"

missing_dependencies=()
for dependency in $dependencies; do
  if ! dpkg -s "$dependency" >/dev/null 2>&1 && ! rpm -q "$dependency" >/dev/null 2>&1 && ! pacman -Q "$dependency" >/dev/null 2>&1 && ! equery -q list "$dependency" >/dev/null 2>&1; then
    missing_dependencies+=("$dependency")
  fi
done

if [ ${#missing_dependencies[@]} -ne 0 ]; then
  echo -e "${ORANGE}Missing dependencies:${ENDCOLOR}"
  for dependency in "${missing_dependencies[@]}"; do
    case $dependency in
      jq)
        echo -e "$dependency: Lightweight and flexible command-line tool for parsing and manipulating JSON data."
        ;;
      coreutils)
        echo -e "$dependency: Collection of essential command-line utilities for basic file and text manipulation tasks."
        ;;
    esac
  done

  while true; do
    read -p "Do you want to install these dependencies? (y/n): " choice
    case $choice in
      [Yy]|[Yy][Ee][Ss])
        if [ -x "$(command -v apt-get)" ]; then
          echo -e "${ORANGE}Detected Debian/Ubuntu distribution, installing required dependencies...${ENDCOLOR}"
          sudo apt-get update && sudo apt-get install -y "${missing_dependencies[@]}" || {
            echo -e "${RED}Error: Failed to install required dependencies using apt-get.${ENDCOLOR}"
            exit 1
          }
        elif [ -x "$(command -v pacman)" ]; then
          echo -e "${ORANGE}Detected Arch Linux distribution, installing required dependencies...${ENDCOLOR}"
          sudo pacman -Sy --noconfirm "${missing_dependencies[@]}" || {
            echo -e "${RED}Error: Failed to install required dependencies using pacman.${ENDCOLOR}"
            exit 1
          }
        elif [ -x "$(command -v dnf)" ]; then
          echo -e "${ORANGE}Detected Fedora distribution, installing required dependencies...${ENDCOLOR}"
          sudo dnf update -y && sudo dnf install -y "${missing_dependencies[@]}" || {
            echo -e "${RED}Error: Failed to install required dependencies using dnf.${ENDCOLOR}"
            exit 1
          }
      elif [ -x "$(command -v emerge)" ]; then
        echo -e "${ORANGE}Detected Gentoo distribution, installing required dependencies...${ENDCOLOR}"
        sudo emerge -av "${missing_dependencies[@]}" || {
          echo -e "${RED}Error: Failed to install required dependencies using emerge.${ENDCOLOR}"
          exit 1
        }
        else
          echo -e "${RED}Error: Unsupported distribution or package manager detected.${ENDCOLOR}"
          exit 1
        fi

        echo -e "${GREEN}Dependencies successfully installed.${ENDCOLOR}"
        break
        ;;
      [Nn]|[Nn][Oo])
        echo -e "${RED}Missing dependencies not installed. Exiting!${ENDCOLOR}"
        exit 0
        ;;
      *)
        echo "Invalid choice. Please enter 'y' or 'n'."
        ;;
    esac
  done
fi

devices=$(<devices.json)

declare -A device_groups

for device in $(echo "${devices}" | jq -r '.[] | @base64'); do
    _jq() {
        echo "${device}" | base64 --decode | jq -r "${1}"
    }
    brand=$(_jq '.brand')
    device_group=$(_jq '.supported_versions[].device_group')
    if [ -z "${device_groups["${brand}"]}" ]; then
        device_groups["${brand}"]="${device_group}\n"
    else
        device_groups["${brand}"]+="${device_group}\n"
    fi
done

{
    for brand in $(echo "${!device_groups[@]}" | tr ' ' '\n' | sort); do
        echo "${brand}:"
        echo -e "${device_groups[${brand}]}" | sort -u | awk NF
        echo
    done
} > /tmp/device_groups.txt

echo -e "${GREEN}===========================================================${ENDCOLOR}"
echo -e "${BLUE}      ______            __      __  _                _  __  ${ENDCOLOR}"
echo -e "${BLUE}     / ____/   ______  / /_  __/ /_(_)___  ____     | |/ /  ${ENDCOLOR}"
echo -e "${BLUE}    / __/ | | / / __ \/ / / / / __/ / __ \/ __ \    |   /   ${ENDCOLOR}"
echo -e "${BLUE}   / /___ | |/ / /_/ / / /_/ / /_/ / /_/ / / / /   /   |    ${ENDCOLOR}"
echo -e "${BLUE}  /_____/ |___/\____/_/\__,_/\__/_/\____/_/ /_/   /_/|_|    ${ENDCOLOR}"
echo -e "${BLUE}                                                            ${ENDCOLOR}"
echo -e "${BLUE}                         #KeepEvolving                      ${ENDCOLOR}"
echo -e "${GREEN}Wrote device groups to /tmp/device_groups.txt              ${ENDCOLOR}"
echo -e "${GREEN}===========================================================${ENDCOLOR}"
check_command() {
    if ! command -v "$1" &>/dev/null; then
        echo -e "${RED}Error: $1 is not installed! Please install it and try again.${ENDCOLOR}"
        return 1
    fi
}

while true; do
    read -p "How do you want to view the file? Choose an option:
    1. Cat
    2. Nano
    3. Vim
    4. Gedit
    5. Enter your own command
    6. Exit
    Enter your choice (1-6): " choice

    case "$choice" in
        1)
            if check_command "cat"; then
                cat /tmp/device_groups.txt
                break
            fi
            ;;
        2)
            if check_command "nano"; then
                nano /tmp/device_groups.txt
                break
            fi
            ;;
        3)
            if check_command "vim"; then
                vim /tmp/device_groups.txt
                break
            fi
            ;;
        4)
            if check_command "gedit"; then
                gedit /tmp/device_groups.txt
                break
            fi
            ;;
        5)
            while true; do
                read -p "Enter the command to open the file: " custom_cmd
                if eval "$custom_cmd /tmp/device_groups.txt"; then
                    break 2
                else
                    echo -e "${RED}Failed to execute the command!${ENDCOLOR}"
                    continue 2
                fi
            done
            ;;
        6)
            echo -e "${ORANGE}Exiting..${ENDCOLOR}"
            break
            ;;
        *)
            echo -e "${ORANGE}Invalid choice. Please enter a valid choice (1-6).${ENDCOLOR}"
            ;;
    esac
done
