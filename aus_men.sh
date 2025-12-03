#!/bin/bash
source helper.sh
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

echo -e "${GREEN} Wecome ! lets get started${RESET}"

if [[ ! -f user.txt ]]; then
echo -e "${RED} user.txt not fount ${RESET}"
exit 1
fi
show_active(){
echo "Active user detials"

tem=$(grep ",active" user.txt | awk -F"," '{print $1}')
log "$tem"
}
show_inactive(){
echo -e "${YELLOW} Inactive user detials ${RESET}"
grep ",inactive" user.txt | awk -F"," '{print $1}'
}
show_both(){
echo -e "${YELLOW} User details ${RESET}"
awk -F"," '{print $1}' user.txt
}
search() {
echo -n " enter the name to search: "
read uname
result=$(grep "^${uname}" user.txt )
if [ -z "${result}" ]; then
echo "Not found !"
else
name=$(echo ${result} | awk -F"," '{print $1}')
role=$(echo $result | awk -F"," '{print $2}')
status=$(echo $result | awk -F"," '{print $3}')
echo "Name - ${name}, Role - ${role}, Status - ${status}"
log "**** Search Date *****"
log "Name - ${name}, Role - ${role}, Status - ${status}"
fi
}
add(){
echo -n "Enter the User name : "
read name
if [ -z "$name" ]; then
echo "name cannot be empty"
return
fi

if [[ "$name" =~ [0-9] ]]; then
echo "Cannot be number"
return
fi

if [[ "$name" =~ [^a-zA-Z] ]]; then
echo "Cannot be special char"
return 
fi	

if grep -q "^${name}," user.txt ; then
echo "User is already exist "
return
fi
echo -n "Enter the User Role ; "
read role
echo -n "Enter the User status(active\inactive) : "
read status
if [[ $status != "active" && $status != "inactive" ]]; then
echo -e "${RED}Enter only valid status ${RESET}"
return
fi
echo "${name},${role},${status}" >> user.txt
log "${name},${role},${status} added successfully"
echo -e "${GREEN}User added successfully${RESET}"
}
update_status(){
echo -n "Enter user name : "
read uname
result=$(grep "${uname}" user.txt)
if [[ -z "${result}" ]]; then
echo "user not found!!"
return
fi
echo -n "Enter the status : "
read status
if [[ $status != "active" && $status != "inactive" ]]; then
echo "Enter only valid status"
return
fi
sed -i "/^${uname},[^,]*,[^,]*/${uname},$(echo "$result" | awk -F',' '{print $2}'),${status}/" user.txt
}

delete_user(){
echo -n "Enter the user name : "
read name
result=$(grep "$name" user.txt)
if [[ -z "$result" ]]; then
echo "User not found!!"
return
fi
sed -i "/^${name}/d" user.txt
echo "Deleted successfully!!"
}

export_csv(){
echo "name,role,status" > exportCSV.csv

while IFS="," read -r name role status
do
echo "${name},${role},${status}" >> exportCSV.csv
done < user.txt
echo "Succeffully exported !!!"
}

export_json(){
count=1
total=$(wc -l < user.txt)
echo "[" > exportjson.json
while IFS="," read -r name role status
do
if [[ $count -eq $total ]]; then
echo " {\"name\":\"$name\", \"role\":\"$role\", \"status\":\"$status\"}" >> exportjson.json
else
echo " {\"name\":\"$name\", \"role\":\"$role\", \"status\":\"$status\"}," >> exportjson.json
fi
((count++))
done < user.txt
echo "]" >> exportjson.json
echo "export succeffull json!!"
}

backup_user(){
timestamp=$(date '+%Y-%m-%d_%H-%M-%S')
mkdir -p backup
cp user.txt backup/user_backup_${timestamp}.txt
log "backup created : backup/user_backup_${timestamp}.txt"
echo "back up created succfully" 
}
restore_user(){
bkt=$(ls -t backup/user_backup_*.txt | head -1)
if [[ -z bkt ]]; then
echo "file was not found "
return
fi
echo "--> ${bkt}"
cp "${bkt}" "${bkt}_2".txt
echo "restored done !!"
}
archive_user(){
timestamp=$(date '+%Y-%m-%d_%H-%M-%S')
mkdir -p archive
tar -czvf archive/back_user_${timestamp}.tar.gz user.txt
echo "succufff archived !!"
}

while true; do
echo -e "${RED}"
echo "1.Active"
echo "2.Inactive"
echo "3.Both"
echo "4.search"
echo "5.Add"
echo "6.Update user status"
echo "7.Delete user"
echo "8.export CSV"
echo "9.export json"
echo "0.Exit"
echo "11.backup"
echo "12.restore"
echo "13.achive"
echo -e "${RESET}"

read choice
case $choice in
1) show_active ;;
2) show_inactive ;;
3) show_both ;;
4) search ;;
5) add ;;
6) update_status ;;
7) delete_user ;;
8) export_csv ;;
9) export_json ;;
0) echo "BYE!" ; exit 0 ;;
11) backup_user ;;
12) restore_user ;;
13) archive_user ;;
*) echo "Invalid option" ;;
esac
done
