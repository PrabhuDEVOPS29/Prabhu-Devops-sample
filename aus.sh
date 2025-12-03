#!/bin/bash
echo "welcome all"
if [ -f user.txt ]; then
echo -n "enter user u want : "
read status
rm -f "${status}"_user.txt
echo "$status"
grep ",${status}$" user.txt | awk -F"," '{print $1}' >> "${status}"_user.txt
else
echo "user.txt not fine"
exit 1
fi

