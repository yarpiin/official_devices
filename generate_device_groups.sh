#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
ENDCOLOR='\033[0m'

# Exceptions for devices that don't have
# groups that directly translate to their
# codename.
declare -A exceptions=(
  # Google exceptions
  ["blueline"]="Pixel3"
  ["crosshatch"]="Pixel3"
  ["sargo"]="Pixel3"
  ["bonito"]="Pixel3"
  ["oriole"]="Pixel6"
  ["raven"]="Pixel6"
  ["bluejay"]="Pixel6"
  ["panther"]="Pixel7"
  ["cheetah"]="Pixel7"
  # OnePlus exceptions
  ["fajita"]="OnePlus6"
  ["enchilada"]="OnePlus6"
  ["guacamoleb"]="OnePlus7"
  ["guacamole"]="OnePlus7"
  ["hotdog"]="OnePlus7"
  ["hotdogb"]="OnePlus7"
  ["instantnoodle"]="OnePlus8"
  ["instantnoodlep"]="OnePlus8"
  ["kebab"]="OnePlus8"
  ["lemonades"]="OnePlus8"
  ["lemonade"]="OnePlus9"
  ["lemonadep"]="OnePlus9"
  # Realme exceptions
  ["bladerunner"]="_Bladerunner"
  ["bladerunner_48m"]="_Bladerunner"
  # Samsung exceptions
  ["crownlte"]="9810"
  ["starlte"]="9810"
  ["star2lte"]="9810"
  # Xiaomi exceptions
  ["raphael"]="Raphael_v2"
)

# Ignored devices if group isn't Evolution X
# specific or if there is no group at all.
declare -a ignored_devices=(
  "taimen"
  "walleye"
  "redfin"
)

declare -A devices_by_brand
while IFS= read -r device; do
    brand=$(echo "$device" | jq -r '.brand')
    codename=$(echo "$device" | jq -r '.codename')
    if [[ "${ignored_devices[*]}" =~ "$codename" ]]; then
        continue
    fi
    if [[ -n ${exceptions[$codename]} ]]; then
        codename=${exceptions[$codename]}
    fi
    codename="${codename^}"
    if [[ ${devices_by_brand[$brand]} != *"${codename}"* ]]; then
        devices_by_brand[$brand]+="$codename "
    fi
done < <(jq -c '.[]' devices.json)
printf '%s\n' "${!devices_by_brand[@]}" | tr ' ' '\n' | sort -u | while read -r brand; do
    echo "${brand}:"
    for device in $(echo "${devices_by_brand[$brand]}" | tr ' ' '\n' | sort | tr '\n' ' '); do
        echo "@EvolutionX${device}"
    done
    echo ""
done > ../device_groups.txt 2>&1

echo -e "${GREEN}===========================================================${ENDCOLOR}"
echo -e "${BLUE}      ______            __      __  _                _  __  ${ENDCOLOR}"
echo -e "${BLUE}     / ____/   ______  / /_  __/ /_(_)___  ____     | |/ /  ${ENDCOLOR}"
echo -e "${BLUE}    / __/ | | / / __ \/ / / / / __/ / __ \/ __ \    |   /   ${ENDCOLOR}"
echo -e "${BLUE}   / /___ | |/ / /_/ / / /_/ / /_/ / /_/ / / / /   /   |    ${ENDCOLOR}"
echo -e "${BLUE}  /_____/ |___/\____/_/\__,_/\__/_/\____/_/ /_/   /_/|_|    ${ENDCOLOR}"
echo -e "${BLUE}                                                            ${ENDCOLOR}"
echo -e "${BLUE}                         #KeepEvolving                      ${ENDCOLOR}"
echo -e "${GREEN}Finished generating ../device_groups.txt                   ${ENDCOLOR}"
echo -e "${GREEN}===========================================================${ENDCOLOR}"
read -p "Would you like to display the output? (y/n) " choice
echo -e "${GREEN}===========================================================${ENDCOLOR}"
if [[ $choice == "y" ]]; then
  cat ../device_groups.txt
fi
echo -e "${ENDCOLOR}"
