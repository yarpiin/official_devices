#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
ENDCOLOR='\033[0m'

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
} > ../device_groups.txt

echo -e "${GREEN}===========================================================${ENDCOLOR}"
echo -e "${BLUE}      ______            __      __  _                _  __  ${ENDCOLOR}"
echo -e "${BLUE}     / ____/   ______  / /_  __/ /_(_)___  ____     | |/ /  ${ENDCOLOR}"
echo -e "${BLUE}    / __/ | | / / __ \/ / / / / __/ / __ \/ __ \    |   /   ${ENDCOLOR}"
echo -e "${BLUE}   / /___ | |/ / /_/ / / /_/ / /_/ / /_/ / / / /   /   |    ${ENDCOLOR}"
echo -e "${BLUE}  /_____/ |___/\____/_/\__,_/\__/_/\____/_/ /_/   /_/|_|    ${ENDCOLOR}"
echo -e "${BLUE}                                                            ${ENDCOLOR}"
echo -e "${BLUE}                         #KeepEvolving                      ${ENDCOLOR}"
echo -e "${GREEN}Wrote device groups to ../device_groups.txt                ${ENDCOLOR}"
echo -e "${GREEN}===========================================================${ENDCOLOR}"
while true; do
    read -p "How do you want to view the file? Choose an option: 
    1. Cat 
    2. Nano 
    3. Vim 
    4. Gedit
    5. None of the above
    Enter your choice (1-5): " choice

    case "$choice" in
        1)
            cat ../device_groups.txt
            break
            ;;
        2)
            nano ../device_groups.txt
            break
            ;;
        3)
            vim ../device_groups.txt
            break
            ;;
        4)
            gedit ../device_groups.txt
            break
            ;;
        5)
            echo "No action taken."
            break
            ;;
        *)
            echo "Invalid choice. Please enter a valid choice (1-5)."
            ;;
    esac
done
