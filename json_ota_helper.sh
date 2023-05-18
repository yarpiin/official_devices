#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
ENDCOLOR='\033[0m'

display_header() {
    echo -e "${GREEN}===========================================================${ENDCOLOR}"
    echo -e "${BLUE}      ______            __      __  _                _  __  ${ENDCOLOR}"
    echo -e "${BLUE}     / ____/   ______  / /_  __/ /_(_)___  ____     | |/ /  ${ENDCOLOR}"
    echo -e "${BLUE}    / __/ | | / / __ \/ / / / / __/ / __ \/ __ \    |   /   ${ENDCOLOR}"
    echo -e "${BLUE}   / /___ | |/ / /_/ / / /_/ / /_/ / /_/ / / / /   /   |    ${ENDCOLOR}"
    echo -e "${BLUE}  /_____/ |___/\____/_/\__,_/\__/_/\____/_/ /_/   /_/|_|    ${ENDCOLOR}"
    echo -e "${BLUE}                                                            ${ENDCOLOR}"
    echo -e "${BLUE}                          OTA helper                        ${ENDCOLOR}"
    echo -e "${BLUE}                                                            ${ENDCOLOR}"
    echo -e "${BLUE}                         #KeepEvolving                      ${ENDCOLOR}"
    echo -e "${GREEN}===========================================================${ENDCOLOR}"
}

display_help() {
    echo "Usage: $0 <input_json_from_out_dir>"
    echo "Updates the information from the input JSON file to the corresponding codename.json file."
    echo
    echo "Arguments:"
    echo "  input_json   The JSON file used to update ./builds/codename.json"
    echo
    echo "Note: The input file should follow the format 'evolution_<codename>-ota-<>.json'"
}

dependencies="jq coreutils"

missing_dependencies=()
for dependency in $dependencies; do
  if ! dpkg -s "$dependency" >/dev/null 2>&1 && ! rpm -q "$dependency" >/dev/null 2>&1 && ! pacman -Q "$dependency" >/dev/null 2>&1 && ! equery -q list "$dependency" >/dev/null 2>&1; then
    missing_dependencies+=("$dependency")
  fi
done

if [ ${#missing_dependencies[@]} -ne 0 ]; then
  clear && display_header
  echo -e "${ORANGE}Missing dependencies:${ENDCOLOR}"
  for dependency in "${missing_dependencies[@]}"; do
    case $dependency in
      jq)
        echo -e "${BLUE}$dependency: A lightweight and flexible command-line tool for parsing and manipulating JSON data.${ENDCOLOR}"
        ;;
      coreutils)
        echo -e "${BLUE}$dependency: A collection of essential command-line utilities for basic file and text manipulation.${ENDCOLOR}"
        ;;
    esac
  done

  while true; do
    read -p "Do you want to install these dependencies? (y/n): " choice
    case $choice in
      [Yy]|[Yy][Ee][Ss])
        if [ -x "$(command -v apt-get)" ]; then
          clear && display_header
          echo -e "${ORANGE}Debian/Ubuntu detected, installing required dependencies...${ENDCOLOR}"
          sudo apt-get update && sudo apt-get install -y "${missing_dependencies[@]}" || {
            echo -e "${RED}Error: Failed to install required dependencies using apt-get.${ENDCOLOR}"
            exit 1
          }
        elif [ -x "$(command -v pacman)" ]; then
          clear && display_header
          echo -e "${ORANGE}Arch detected, installing required dependencies...${ENDCOLOR}"
          sudo pacman -Sy --noconfirm "${missing_dependencies[@]}" || {
            echo -e "${RED}Error: Failed to install required dependencies using pacman.${ENDCOLOR}"
            exit 1
          }
        elif [ -x "$(command -v dnf)" ]; then
          clear && display_header
          echo -e "${ORANGE}Fedora detected, installing required dependencies...${ENDCOLOR}"
          sudo dnf update -y && sudo dnf install -y "${missing_dependencies[@]}" || {
            echo -e "${RED}Error: Failed to install required dependencies using dnf.${ENDCOLOR}"
            exit 1
          }
      elif [ -x "$(command -v emerge)" ]; then
        echo -e "${ORANGE}Gentoo detected, installing required dependencies...${ENDCOLOR}"
        clear && display_header
        sudo emerge -av "${missing_dependencies[@]}" || {
          echo -e "${RED}Error: Failed to install required dependencies using emerge.${ENDCOLOR}"
          exit 1
        }
        else
          clear && display_header
          echo -e "${RED}Error: Unsupported distro or package manager detected.${ENDCOLOR}"
          exit 1
        fi
        clear && display_header
        echo -e "${GREEN}Dependencies successfully installed. Generating device groups...${ENDCOLOR}"
        break
        ;;
      [Nn]|[Nn][Oo])
        clear
        echo -e "${RED}Dependencies not satisfied... Exiting!${ENDCOLOR}"
        exit 0
        ;;
      *)
        echo "Invalid selection. Please enter 'y' or 'n'."
        ;;
    esac
  done
fi

if [ $# -ne 1 ]; then
    display_help
    exit 1
fi

input_json=$1

if [ ! -f "$input_json" ]; then
    echo "Input file not found: $input_json"
    exit 1
fi

codename=$(basename "$input_json" | sed -E 's/^evolution_([^.-]+)-ota-.+$/\1/')
input_data=$(cat "$input_json")
filename=$(echo "$input_data" | jq -r '.filename')

if [ -z "$codename" ] || [ -z "$filename" ]; then
    echo "Invalid input file name: $input_json"
    echo "Please make sure the input file follows the format 'evolution_<codename>-ota-<>.json'"
    exit 1
fi

output_json="./builds/${codename}.json"

datetime=$(echo "$input_data" | jq -r '.datetime')
filehash=$(echo "$input_data" | jq -r '.filehash')
id=$(echo "$input_data" | jq -r '.id')
size=$(echo "$input_data" | jq -r '.size')

url="https://sourceforge.net/projects/evolution-x/files/${codename}/${filename}/download/"

if [ -f "$output_json" ]; then
    old_datetime=$(jq -r '.datetime' "$output_json")
    old_filehash=$(jq -r '.filehash' "$output_json")
    old_id=$(jq -r '.id' "$output_json")
    old_size=$(jq -r '.size' "$output_json")
    old_url=$(jq -r '.url' "$output_json")
    old_filename=$(jq -r '.filename' "$output_json")

    if [ "$datetime" = "$old_datetime" ] && \
        [ "$filehash" = "$old_filehash" ] && \
        [ "$id" = "$old_id" ] && \
        [ "$size" = "$old_size" ] && \
        [ "$url" = "$old_url" ] && \
        [ "$filename" = "$old_filename" ]; then
        echo "No changes required. All properties match."
        exit 0
    fi

    echo "Updating values:"
    echo "  datetime: $old_datetime > $datetime"
    echo "  filehash: $old_filehash > $filehash"
    echo "  id: $old_id > $id"
    echo "  size: $old_size > $size"
    echo "  url: $old_url > $url"
    echo "  filename: $old_filename > $filename"
fi

temp_file=$(mktemp)

jq --arg datetime "$datetime" --arg filehash "$filehash" --arg id "$id" --arg size "$size" --arg url "$url" --arg filename "$filename" \
    '.datetime = $datetime
     | .filehash = $filehash
     | .id = $id
     | .size = $size
     | .url = $url
     | .filename = $filename' \
    "$output_json" > "$temp_file"

echo "Updated JSON:"
echo
jq --indent 2 . "$temp_file"
echo

mv "$temp_file" "$output_json"

echo "Done."
