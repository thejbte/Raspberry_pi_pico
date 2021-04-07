#!/bin/bash

#Author : Julian Bustamante Narvaez

#run as SUDO 
#use :  sudo ./programmer_embedded.sh sdp1 /home/julian/pico/pico-examples/build/blink/blink.uf2
#use :  sudo ./programmer_embedded.sh null /home/julian/pico/pico-examples/build/blink/blink.uf2
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

function print_error(){
  echo -e "${RED}Error:${NC}$1${NC} $2";
}

#lsblk -do name,tran

resp_sdx=$(lsblk -do name,tran | grep "usb"|cut -d ' ' -f1)
#echo "lala $resp_sdx"

#[ 9581.217454]  sdp: sdp1
resp_sdxx=$((dmesg|tail | grep "$resp_sdx:")| grep "$resp_sdx"|cut -d ':' -f2|tr '\n' ' ') 

resp_sdxxx=${resp_sdxx//[[:blank:]]/}
#echo $resp_sdxx

if echo $resp_sdxx | grep -q " ";
 then
  print_error "usb not detected"
  exit 1; 
fi
#exit 1
if [ $# -eq 0 ]
 then
  echo "Error: No arguments entry, ./file.sh sdb1 path/file.uf2"
  exit
fi


sdxx="$1" #argument sda1 or sdb1  // dmesg | tail
echo "Programming core ..."

mkdir -p /mnt/pico
resp_mount=$(mount /dev/$resp_sdxxx /mnt/pico/ 2>&1 )

#echo " output: $resp_mount"

if echo $resp_mount | grep -q "does not exist.";
 then
  print_error "$resp_mount"
  exit 1;
else 
  if echo $resp_mount | grep -q "mount: bad usage" ; then
    print_error "$resp_mount"
    exit 1
  else
    if echo $resp_mount | grep -q "/dev is not a block device." ; then
      print_error "$resp_mount"
      exit 1
    else
      echo "Mounted mass storage device... $resp_mount"
    fi
  fi

fi

#cp /home/julian/pico/pico-examples/build/blink/blink.uf2 /mnt/pico/
resp_cp=$(cp $2 /mnt/pico/ 2>&1)

if echo $resp_cp | grep -q "No such file or directory";
 then
  print_error "$resp_cp"
  resp_unmount=$(umount /mnt/pico 2>&1)
  exit 1;
fi

sync 
echo "Waiting..."
sleep 1
#sudo export PICO_SDK_PATH=~/pico/pico-sdk/

echo -e "${GREEN}succefull download...${NC}"




#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37
