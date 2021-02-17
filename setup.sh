#!/bin/bash
# Installation du projet | uber_heat
declare -a COMMANDS_NEED=("git" "curl" "docker-compose")
NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'

print(){
    echo -e $1
}

echo  "  _    _ ____  ______ _____        _    _ ______       _______  "
echo  " | |  | |  _ \|  ____|  __ \      | |  | |  ____|   /\|__   __| "
echo  " | |  | | |_) | |__  | |__) |     | |__| | |__     /  \  | |    "
echo  " | |  | |  _ <|  __| |  _  /      |  __  |  __|   / /\ \ | |    "
echo  " | |__| | |_) | |____| | \ \      | |  | | |____ / ____ \| |    "
echo  "  \____/|____/|______|_|  \_\     |_|  |_|______/_/    \_\_|    "
echo  "                                                                "

# Check requirement
print "$ORANGE=> CHECK REQUIREMENTS $NC"
for COMMAND in "${COMMANDS_NEED[@]}"
do
    if ! command -v $COMMAND &> /dev/null
    then
        print "$COMMAND.. $RED not found.$NC"
        exit
    else
        print "$COMMAND.. $GREEN OK $NC"
    fi
done

# clone project

