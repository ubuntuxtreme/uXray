#!/bin/bash
# sudo apt-get install dmidecode lshw x86info lm-sensors
# Setup lm-sensors using modprobe for the appropriate modules
# Dr.Paneas
# License: Artistic License 2.0
 
# DEFINE PC TYPE
_PC=`sudo dmidecode -s chassis-type`
LAPTOP=1    # by default
 
# IF NOT LAPTOP
if [ $_PC == "Desktop" ] ; then
  LAPTOP=0    # But...it's a Desktop eventually
fi
 
# LAPTOP INFORMATION
_LAPTOP_VENDOR=`sudo dmidecode -s system-manufacturer`
_LAPTOP_MODEL=`sudo dmidecode -s system-product-name`
_LAPTOP_PN=`sudo dmidecode -s system-version`
_LAPTOP_SN=`sudo dmidecode -s system-serial-number`
_LAPTOP_UUID=`sudo dmidecode -s system-uuid`
 
# LAPTOP BATTERY
_LAPTOP_BAT_VENDOR=`sudo dmidecode -t 22 | grep "Manufacturer" | awk -F ": " '{print $2}'`
_LAPTOP_BAT_NAME=`sudo dmidecode -t 22 | grep "Name" | awk -F ": " '{print $2}'`
_LAPTOP_BAT_SN=`sudo dmidecode -t 22 | grep "Serial Number " | awk -F ": " '{print $2}'`
_LAPTOP_BAT_CAP=`sudo dmidecode -t 22 | grep "Capacity" | awk -F ": " '{print $2}'`
_LAPTOP_BAT_VOLTS=`sudo dmidecode -t 22 | grep "Voltage" | awk -F ": " '{print $2}'`
_LAPTOP_BAT_KIND=`sudo dmidecode -t 22 | grep "Chemistry" | awk -F ": " '{print $2}'`
 
 
# PROCESSOR
_CPU_FREQ=`sudo dmidecode -s processor-frequency`
_CPU_VENDOR=`sudo dmidecode -s processor-manufacturer`
_CPU_FAMILY=`sudo dmidecode -s processor-family`
_CPU_VERSION=`cat /proc/cpuinfo | grep "model name" | awk -F ": " '{print $2}' | uniq`
 
# MOTHERBOARD
_MOBO_VENDOR=`sudo dmidecode -s baseboard-manufacturer | awk -F " " '{print $1}'`
_MOBO_MODEL=`sudo dmidecode -s baseboard-product-name`
_MOBO_REVERSION=`sudo dmidecode -s baseboard-version`
_MOBO_SERIAL=`sudo dmidecode -s baseboard-serial-number`
_MOBO_TAG=`sudo dmidecode -s baseboard-asset-tag`
 
# BIOS
_BIOS_VENDOR=`sudo dmidecode -s bios-vendor`
_BIOS_VERSION=`sudo dmidecode -s bios-version`
_BIOS_DATE=`sudo dmidecode -s bios-release-date`
 
# RAM
_RAM_TYPE=`sudo dmidecode --type 6 | grep "Type: DIMM SDRAM" | awk -F "DIMM " '{print $2}' | uniq`
_RAM_ALL=`sudo lshw -short -C memory | grep "System Memory" | awk -F "memory" '{print $2}'`
_RAM_SPEED=`sudo dmidecode --type 17 | grep Speed: | awk -F ": " '{print $2}' | grep "(" | uniq | awk -F "(" '{print $1}'`
 
corespeed=`cat /proc/cpuinfo | grep "^cpu MHz.*" | awk -F": " '{print $2}' | sed 's@\.@@g' | uniq`
let "corespeed=$corespeed/1000"
stockspeed=`cat /proc/cpuinfo | grep "^model name.*" | awk -F": " '{print $2}' | uniq | awk -F"@ " '{print $2}'`
nativecores=`cat /proc/cpuinfo | grep "^cpu cores.*" | awk -F": " '{print $2}' | uniq`
threads=`cat /proc/cpuinfo | grep "^siblings.*" | awk -F": " '{print $2}' | uniq`
family=`cat /proc/cpuinfo | grep "^cpu family.*" | awk -F": " '{print $2}' | uniq`
stepping=`cat /proc/cpuinfo | grep "^stepping.*" | awk -F": " '{print $2}' | uniq`
specification=`cat /proc/cpuinfo | grep "^model name.*" | awk -F": " '{print $2}' | uniq`
instructions=`cat /proc/cpuinfo | grep "^flags.*" | awk -F": " '{print $2}' | uniq`
diafora=`x86info | grep "EFamily.*" | uniq`
 
if `echo $instructions | grep "mmx" 1>/dev/null 2>&1`
then
  flags=`echo $flags mmx`
fi
 
if `echo $instructions | grep "sse" 1>/dev/null 2>&1`
then
  flags=`echo $flags sse`
fi
 
if `echo $instructions | grep "sse2" 1>/dev/null 2>&1`
then
  flags=`echo $flags sse2`
fi
 
if `echo $instructions | grep "ssse3" 1>/dev/null 2>&1`
then
  flags=`echo $flags ssse3`
fi
 
if `echo $instructions | grep "vmx" 1>/dev/null 2>&1`
then
  flags=`echo $flags VT-x`
fi
 
if `echo $instructions | grep "svm" 1>/dev/null 2>&1`
then
  flags=`echo $flags VT-x`
fi
 
if `echo $instructions | grep "lm" 1>/dev/null 2>&1`
then
  flags=`echo $flags EM64T`
  x86_or_64='64 bit'
else
  x86_or_64='32 bit'
fi
 
tempcpu=`sensors | grep "^Core" | awk -F ": " '{print $2}' | awk -F"C " '{print $1}' | nawk 'BEGIN{RS="="} $1=$1'`
cpufan=`sensors | grep "^fan1.*" | awk -F": " '{print $2}' | uniq | awk -F"RPM " '{print $1}'`
vcore=`sensors | grep "^in0.*" | awk -F": " '{print $2}' | uniq | awk -F"V " '{print $1}' | awk -F"+" '{print $2}'`
stockvolts=`sensors | grep "^cpu0_vid.*" | awk -F"+" '{print $2}' | uniq | awk -F"V " '{print $1}'`
#biosvendor=`sudo dmidecode | cat | grep Vendor | awk -F ": " '{print $2}' | uniq`
#biosversion=`sudo dmidecode | cat | grep "Version" | awk -F ": " '{print $2}' | nawk 'BEGIN{RS="="} $1=$1' | awk -F " " '{print $1}'`
#biosdate=`sudo dmidecode | cat | grep "Release Date" | awk -F ": " '{print $2}' | nawk 'BEGIN{RS="="} $1=$1' | awk -F " " '{print $1}'`
#mobomanufacturer=`sudo dmidecode | cat | grep "Manufacturer" | awk -F ": " '{print $2}' | nawk 'BEGIN{RS="="} $1=$1' | awk -F " " '{print $1}'`
#mobomodel=`sudo dmidecode | cat | grep "Product Name" | awk -F ": " '{print $2}' | nawk 'BEGIN{RS="="} $1=$1' | awk -F " " '{print $1}'`
#moboreversion=`sudo dmidecode | cat | grep "Version" | awk -F ": " '{print $2}' | nawk 'BEGIN{RS="="} $1=$1' | awk -F " " '{print $2}'`
#cpucodename=`x86info | grep "^CPU Model.*" | awk -F": " '{print $2}' | uniq`
#cpuvendor=`sudo dmidecode | cat | grep "Version" | awk -F ": " '{print $2}' | nawk 'BEGIN{RS="="} $1=$1' | awk -F " " '{print $3}'`
#cpumodel=`sudo dmidecode | cat | grep "Version" | awk -F ": " '{print $2}' | nawk 'BEGIN{RS="="} $1=$1' | awk -F " " '{print $6}'`
socket=`sudo dmidecode -t 4 | cat | grep "Socket Designation" | awk -F ": " '{print $2}'`
L1cacheData=`x86info -c | grep "L1 Data cache.*" | awk -F ": " '{print $2}' | uniq`
L1cacheInst=`x86info -c | grep "L1 Instruction cache.*" | awk -F ": " '{print $2}' | uniq`
L2cache=`x86info -c | grep "L2" | awk -F ": " '{print $2}' | uniq`
L3cache=`x86info -c | grep "L3" | awk -F ": " '{print $2}' | uniq`
 
_KERNEL=`uname -r | awk -F- '{print $1}'`
_MACHINETYPE=`echo $MACHTYPE`
_OSTYPE=`echo $OSTYPE`
_HOSTTYPE=`echo $HOSTTYPE`
 
#gpucodename=`sudo lshw -C display | grep "product.*" | awk -F ": " '{print $2}' | awk -F " " '{print $1}' | uniq`
gpudriver=`sudo lshw -C display | grep "driver" | awk -F "=" '{print $2}' | awk -F " " '{print $1}' | uniq`
gpumodel=`lspci | grep "VGA compatible controller" | awk -F ": " '{print $2}' | uniq`
 
echo
if [ $LAPTOP = 1 ]
then
 
  echo -e "\e[1;35mType: $_PC\e[0m"
  echo -e "\t Model: $_LAPTOP_VENDOR $_LAPTOP_MODEL"
  echo -e "\t Product Number: $_LAPTOP_PN"
  echo -e "\t Serial  Number: $_LAPTOP_SN"
  echo -e "\t Unique User ID: $_LAPTOP_UUID"
else
  echo -e "\e[1;35mType: $_PC\e[0m"
fi
echo
#PROCESSOR SECTION
echo -e "\e[1;34mProcessor Information: \e[0m"
echo -e "\tCPU: $_CPU_VERSION"
echo -e "\tArchitecture: $x86_or_64 Support"
echo -e "\tSocket: LGA $socket"
echo -e "\t$diafora"
echo -e "\tInstructions: $flags"
echo
if [ $threads -eq $nativecores ]
then
  echo -e "\tHyper-Threading:\t[\033[1m Not supported\033[0m ]"
  echo -e "\t\t\t\tPhysical Cores: $nativecores"
  echo -e "\t\t\t\tLogical  Cores: $nativecores"
else
  echo -e "\tHyper-Threading:\t[\033[1m Supported\033[0m ]"
  echo -e "\t\t\t\tPhysical Cores: $nativecores"
  echo -e "\t\t\t\tLogical  Cores: $threads"
fi
echo
echo -e "\tFrequency\tDefault Speed: $_CPU_FREQ  @ VID: $stockvolts"
echo -e "\t\t\tCurrent Speed: $corespeed MHz @ VCore: $vcore V "
echo
echo -e "\tCache info\tL1 Data: $L1cacheData"
echo -e "\t\t\tL1 Inst: $L1cacheInst"
echo -e "\t\t\tLevel 2: $L2cache"
echo -e "\t\t\tLevel 3: $L3cache"
echo
echo -e "\tCore Temperatures:\t$tempcpu in Celsius"
echo -e "\t\tCPUFan: $cpufan RPM"
echo
echo -e "\e[1;33mMainboard Information:\e[0m"
echo -e "\tMotherboard: $_MOBO_VENDOR $_MOBO_MODEL"
echo -e "\tReversion: $_MOBO_REVERSION"
echo
echo -e "\tBIOS\tVendor : $_BIOS_VENDOR"
echo -e "\t\tVersion: $_BIOS_VERSION"
echo -e "\t\tRelease Date: $_BIOS_DATE"
echo
echo -e "\e[1;32mVideo Card:\e[0m"
echo -e "\tGPU: $gpumodel"
#echo -e "\tCodename: $gpucodename"
echo -e "\tDriver in use: $gpudriver"
echo
echo -e "\e[1;31mRAM Memory: \e[0m"
echo -e "\t$_RAM_ALL  Type: $_RAM_TYPE"
echo -e "\tFrequency $_RAM_SPEED"
echo
if [ $LAPTOP = 1 ]
then
  echo -e "\e[1;34mBattery:\e[0m"
  echo -e "\tModel    : $_LAPTOP_BAT_VENDOR $_LAPTOP_BAT_NAME $_LAPTOP_BAT_KIND"
  echo -e "\tCapacity : $_LAPTOP_BAT_CAP"
  echo -e "\tVoltage  : $_LAPTOP_BAT_VOLTS"
  echo -e "\tSerial No: $_LAPTOP_BAT_SN"
fi
echo
echo -e "\e[1;35mOperating System:\e[0m"
echo -e "\tDistro architecture: $_HOSTTYPE "
echo -e "\tKERNEL version: $_KERNEL"
echo  
