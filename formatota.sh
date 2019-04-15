#!/bin/bash

###############################
# ADJUST THOSE WITH YOUR INFO #
###############################

PROJECTPATH="your sourceforge project path"
PAYPAL="your paypal link"
MAINTAINER="your nickname/name"
MAINTAINER_URL="your contact url / telegram username / xda link / etc"
FORUM_URL="your xda/forum thread url"

################################################
# DONT TOUCH UNLESS YOU KNOW WHAT YOU'RE DOING #
################################################

RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color
GRAY='\033[0;37m'

if [ -z $1 ]; then
echo -e "${RED}${BOLD}SYNTAX EXAMPLE"
echo -e "${RED}./formatota.sh ${BLUE}out/target/product/jason/EvolutionX_jason-9.0-20190411-2213-OFFICIAL.zip ${GRAY}help"
exit
fi

timestamp=$(stat -c %Y $1)
name=$(stat -c %n $1 | sed 's/.*\///')
id=$(sha256sum $1 | cut -d " " -f 1)
filehash=$(md5sum $1 | cut -d " " -f 1)
size=$(cat $1 | wc -c)
device=$(sed 's/.*EvolutionX_\(.*\)-9.*/\1/' <<< "${name}")

echo -e "";
echo -e "${RED}{";
echo -e "${RED}         \x22error\x22${NC}:${BLUE}false,"
echo -e "${RED}         \x22filename\x22${NC}:${BLUE}\x22${name}\x22,";
echo -e "${RED}         \x22datetime\x22${NC}:${BLUE}${timestamp},";
echo -e "${RED}         \x22size\x22${NC}:${BLUE}${size},";
echo -e "${RED}         \x22url\x22${NC}:${BLUE}\x22https://sourceforge.net/projects/${PROJECTPATH}/files/${name}\x22,";
echo -e "${RED}         \x22filehash\x22${NC}:${BLUE}\x22${filehash}\x22,";
echo -e "${RED}         \x22version\x22${NC}:${BLUE}\x22Pie\x22,";
echo -e "${RED}         \x22id\x22${NC}:${BLUE}\x22${id}\x22,";
echo -e "${RED}         \x22website_url\x22${NC}:${BLUE}\x22https://evolutionx.ml\x22,";
echo -e "${RED}         \x22news_url\x22${NC}:${BLUE}\x22https://t.me/EvolutionXNews\x22,";
echo -e "${RED}         \x22donate_url\x22${NC}:${BLUE}\x22${PAYPAL}\x22,";
echo -e "${RED}         \x22maintainer\x22${NC}:${BLUE}\x22${MAINTAINER}\x22,";
echo -e "${RED}         \x22maintainer_url\x22${NC}:${BLUE}\x22${MAINTAINER_URL}\x22,";
echo -e "${RED}         \x22forum_url\x22${NC}:${BLUE}\x22${FORUM_URL}\x22";
echo -e "${RED}}";
echo -e "";
if [[ $2 == *"h"* ]]; then
echo -e "${RED}${BOLD}Pull latest official_devices repo,\npaste this output into official/devices/builds/${device}.json,\ncopy the changelog file out/target/product/${device}/${name}.txt to official_devices/changelogs/${device}/,\ncommit and PR";
echo -e "";
fi
