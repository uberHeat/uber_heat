#!/bin/bash
# Installation du projet uber_heat


# CONSTANT
NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'

# FUNCTION
print(){
    echo -e $1
}

## MAIN
clear
rm -f install.log
print $ORANGE
echo  "  _    _ ____  ______ _____        _    _ ______       _______  "
echo  " | |  | |  _ \|  ____|  __ \      | |  | |  ____|   /\|__   __| "
echo  " | |  | | |_) | |__  | |__) |     | |__| | |__     /  \  | |    "
echo  " | |  | |  _ <|  __| |  _  /      |  __  |  __|   / /\ \ | |    "
echo  " | |__| | |_) | |____| | \ \      | |  | | |____ / ____ \| |    "
echo  "  \____/|____/|______|_|  \_\     |_|  |_|______/_/    \_\_|    "
echo  "                                                                "
print $NC

# CHECK REQUIREMENTS
print "$ORANGE=> CHECK REQUIREMENTS $NC"
COMMANDS_NEED=("git" "curl" "docker" "docker-compose")
for COMMAND in "${COMMANDS_NEED[@]}"
do
    if ! command -v $COMMAND &> ./install.log
    then
        print "$RED not found.$NC \t$COMMAND"
        exit
    else
        print "$GREEN OK $NC \t$COMMAND"
    fi
done

# CLONE REPOSITORIES
echo ""
print "$ORANGE=> CLONE REPOSITORIES $NC"
REPOS_LIST=("https://github.com/uberHeat/uber_heat.git" "https://github.com/uberHeat/uber_heat_monolithe.git" "https://github.com/uberHeat/uber_heat_front.git")

for REPO in "${REPOS_LIST[@]}"
do
    git clone $REPO &> ./install.log
    if [ "$?" -ne 0 ]
    then
        print "$RED ERROR $NC \t${REPO##*/}"
        exit
    else
        print "$GREEN OK $NC \t${REPO##*/}"
    fi
done

# MOVE SUB-FOLDER
echo ""
print "$ORANGE=> MOVE SUB-FOLDER $NC"
FOLDER_TO_MOVE=("uber_heat_monolithe" "uber_heat_front")
for FLD in "${FOLDER_TO_MOVE[@]}"
do
    mv $FLD uber_heat
    if [ "$?" -ne 0 ]
    then
        print "$RED ERROR $NC \t$FLD"
        exit
    else
        print "$GREEN OK $NC \t$FLD into $PWD/uber_heat"
    fi
done

# PULL BASE IMAGE
echo ""
print "$ORANGE=> PULL BASE IMAGE $NC"
IMG_TO_DWL=("php:7.4.14-fpm" "composer:1.7.2" "mysql:5.7" "mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim" "mcr.microsoft.com/dotnet/core/sdk" )

for IMG in "${IMG_TO_DWL[@]}"
do
    docker pull $IMG &> ./install.log
    if [ "$?" -ne 0 ]
    then
        print "$RED ERROR $NC \t${IMG##*/}"
        exit
    else
        print "$GREEN OK $NC \t${IMG##*/}"
    fi
done

# BUILD CUSTOM IMAGE
echo ""
print "$ORANGE=> BUILD CUSTOM IMAGE $NC"
CUSTOM_IMG=("uber_heat_php" "uber_heat_front")

for IMG in "${CUSTOM_IMG[@]}"
do
    docker-compose build $IMG &> ./install.log
    if [ "$?" -ne 0 ]
    then
        print "$RED ERROR $NC \t$IMG"
        exit
    else
        print "$GREEN OK $NC \t$IMG}"
    fi
done
