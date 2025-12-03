#!/bin/bash
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

echo -e "${GREEN} Wecome ! lets get started${RESET}"

if [ ! -f user.txt ]; then
echo -e "${RED} user.txt not fount ${RESET}"
exit 1
fi
rm act_us.txt inact_us.txt
grep ",active" user.txt | awk -F"," '{print $1}' >> act_us.txt
grep ",inactive" user.txt | awk -F"," '{print $1}' >> inact_us.txt

echo -e "${YELLO} User details ${RESET}"
echo -e "${GREEN} $(cat act_us.txt) ${RESET}"
echo -e "${GREEN} $(cat inact_us.txt) ${RESET}"

echo -e "${YELLOW} tats all about ! have a nice day :-) ${RESET}"
