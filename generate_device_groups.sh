#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
ENDCOLOR='\033[0m'

# Corrections for devices that don't have
# groups that directly translate to their
# codename.
declare -A corrections=(
  # Google corrections
  ["blueline"]="Pixel3"
  ["crosshatch"]="Pixel3"
  ["sargo"]="Pixel3"
  ["bonito"]="Pixel3"
  ["oriole"]="Pixel6"
  ["raven"]="Pixel6"
  ["bluejay"]="Pixel6"
  ["panther"]="Pixel7"
  ["cheetah"]="Pixel7"
  # OnePlus corrections
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
  # Realme corrections
  ["bladerunner"]="_Bladerunner"
  ["bladerunner_48m"]="_Bladerunner"
  # Samsung corrections
  ["crownlte"]="9810"
  ["starlte"]="9810"
  ["star2lte"]="9810"
  # Xiaomi corrections
  ["raphael"]="Raphael_v2"
)

# Remove devices if group isn't Evolution X
# specific or if there is no group at all.
declare -a remove_devices=(
  "taimen"
  "walleye"
  "redfin"
)

declare -A devices_by_brand
corrected_devices=()
removed_devices=()
while IFS= read -r device; do
    brand=$(echo "$device" | jq -r '.brand')
    codename=$(echo "$device" | jq -r '.codename')
    if [[ "${remove_devices[*]}" =~ "$codename" ]]; then
        removed_devices+=("$codename")
        continue
    fi
    if [[ -n ${corrections[$codename]} ]]; then
        corrected_codename=${corrections[$codename]}
        corrected_devices+=("$codename -> $corrected_codename")
        codename="$corrected_codename"
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

corrected_devices_output="Corrected Devices:\n"
for corrected_device in "${corrected_devices[@]}"; do
  corrected_devices_output+="  - $corrected_device\n"
done

removed_devices_output="Removed Devices:\n"
for removed_device in "${removed_devices[@]}"; do
  removed_devices_output+="  - $removed_device\n"
done

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
corrected_output=""
removed_output=""
final_output=""
while [[ ! $corrected_output =~ ^[yn]$ ]]; do
    read -p "Would you like to view a list of corrected devices? (y/n) " corrected_output
done
while [[ ! $removed_output =~ ^[yn]$ ]]; do
    read -p "Would you like to view a list of removed devices? (y/n) " removed_output
done
while [[ ! $final_output =~ ^[yn]$ ]]; do
    read -p "Would you like to view the final device_groups.txt? (y/n) " final_output
done
echo -e "${GREEN}===========================================================${ENDCOLOR}"
if [[ $corrected_output == "y" ]]; then
  echo -e "${corrected_devices_output}"
echo -e "${GREEN}===========================================================${ENDCOLOR}"
fi
if [[ $removed_output == "y" ]]; then
  echo -e "${removed_devices_output}"
echo -e "${GREEN}===========================================================${ENDCOLOR}"
fi
if [[ $final_output == "y" ]]; then
  echo -e "Final output:"
  cat ../device_groups.txt
fi
