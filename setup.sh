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
echo  " By Brice MICHALSKI, Alban PIERSON & Benjamin L'HONNEN          "
echo  "                                                                "
print $NC
print "If an error occurred, open the file: $PWD/install.log"
echo ""

# CHECK REQUIREMENTS
print "$ORANGE=> CHECK REQUIREMENTS $NC"
COMMANDS_NEED=("git" "curl" "docker" "docker-compose")
for COMMAND in "${COMMANDS_NEED[@]}"
do
    if ! command -v $COMMAND >> install.log 2>&1
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
    git clone $REPO >> install.log 2>&1
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
IMG_TO_DWL=("php:7.4.14-fpm" "composer:latest" "mysql:5.7" "mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim" "mcr.microsoft.com/dotnet/core/sdk" "traefik:v2.3")

for IMG in "${IMG_TO_DWL[@]}"
do
    docker pull $IMG >> install.log 2>&1
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
cd uber_heat
print "$ORANGE=> BUILD CUSTOM IMAGE $NC"
CUSTOM_IMG=("php" "front")
for IMG in "${CUSTOM_IMG[@]}"
do
    docker-compose build $IMG >> ../install.log 2>&1
    if [ "$?" -ne 0 ]
    then
        print "$RED ERROR $NC \t$IMG"
        exit
    else
        print "$GREEN OK $NC \t$IMG"
    fi
done

# INSTALL SYMFONY DEPENDENCIES
echo ""
cd uber_heat_monolithe
print "$ORANGE=> INSTALL BACKEND $NC"

cp .env.dist .env
docker run --rm -v $PWD:/app composer:latest composer install --no-interaction  >> ../../install.log 2>&1
if [ "$?" -ne 0 ]
then
    print "$RED ERROR $NC \t error during 'composer install' "
    exit
else
    print "$GREEN OK $NC \t backend installed"
fi
cd ..

# LAUNCH UBER HEAT APP LOCALLY
echo ""
print "$ORANGE=> LAUNCH APP LOCALLY $NC"
docker-compose up -d >> ../install.log 2>&1
if [ "$?" -ne 0 ]
then
    print "$RED ERROR $NC \t error during 'docker-compose up -d' "
    exit
else
    print "$GREEN OK $NC \t APPLICATION UP & RUNNING"
fi

echo ""
print "$GREEN=> SUCCESS$NC"
echo ""
print "You can now use our UI in your favorite browser:"
print "UI: $GREEN http://uberheat.localhost$NC"
print "API: $GREEN http://backend.localhost$NC"
print ""
