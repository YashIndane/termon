#!/usr/bin/bash

total_mem=$(free -m | grep Mem | awk '{ print $2}')
refresh_time=0.65
while :
do
 year=$(date +"%Y")
 month=$(date +%b | tr [a-z] [A-Z])
 day=$(date +"%d")
 freq=$(lscpu | grep "CPU MHz" | awk '{ print $3 }')
 cache=$(free -m | grep "Mem:" | awk '{ print $6}')
 tasks=$(ps -e | wc -l)
 packets_received=$(netstat -s | grep "total packets received" | awk '{ print $1}')
 requests_out=$(netstat -s | grep "requests sent out" | awk '{ print $1}')
 interface=$(ip -o -4 route show to default | awk '{print $5}')
 ipv4=$( hostname -I | awk '{ print $1 }')
 read_speed=$(iostat | grep xvda | awk '{ print $3 }')
 write_speed=$(iostat | grep xvda | awk '{ print $4 }')
 uptime=$(uptime -p)
 uptime="${uptime:3:25}"
 type=$(uname -a | awk '{ print $1 }')
 manufacturer=$(dmidecode -t system | grep Manufacturer | awk '{ print $2}')
 model=$(dmidecode -t system | grep Product)
 model="${model:15:40}"
 chasis_type=$(dmidecode -t chassis | grep Type)
 chasis_type="${chasis_type:7:40}"
 cpu=$(lscpu | grep "Model name")
 cpu="${cpu:13:55}"
 used_ram=$(free -m | grep Mem: | awk '{ print $3}')
 p=$(free -m | grep Mem | awk '{ print $4 }')
 p=$(expr $p \* 100)
 per_memf=$(expr $p / $total_mem)

 echo "$year    TYPE    POWER    UPTIME"
 echo "$month $day  $type   ON       $uptime"
 echo "_________________________________"
 printf "\n"
 echo "MANUFACTURER     MODEL     CHASIS"
 echo "$manufacturer              $model  $chasis_type"
 echo "_________________________________"
 printf "\n"
 echo "CPU USAGE $cpu"
 printf "\n"
 cpu_usage=$(mpstat | grep all | awk '{ print $4 }')
 echo -n "$cpu_usage% ["
 for i in $(seq 1 ${cpu_usage%.*}); do printf '|'; done
 for i in $(seq 1 $(expr 100 - ${cpu_usage%.*})); do printf ' '; done
 printf "]\n"
 printf "\n"
 echo "FREQ MHz   TASKS"
 echo "$freq   $tasks"
 echo "_________________________________"
 printf "\n"

 echo "RAM        USING $used_ram OUT OF $total_mem MB"
 printf "\n"


 echo "FREE"
 echo -n "${per_memf}%   ["
 for i in $(seq 1 $per_memf); do printf '|'; done
 for i in $(seq 1 $(expr 100 - $per_memf)); do printf ' '; done
 printf ']\n'
 printf "\n"

 echo "CACHE"
 echo "$cache MB"
 echo "_________________________________"
 printf "\n"

 echo "TOP PROCESSESS"
 printf "\n"
 echo "%CPU  PID  USER     PROCESS                      %MEM"
 echo "$(ps -eo pcpu,pid,user,args,%mem --no-headers| sort -t. -nk1,2 -k4,4 -r |head -n 5)"
 printf "\n"

 echo "READ         WRITE"
 echo "$read_speed kb/s  $write_speed kb/s"
 echo "_________________________________"
 printf "\n"

 echo "NETWORK STATUS     Interface:$interface"
 printf "\n"
 echo "STATE   IPv4"

 ping -c 1 -q www.google.com >&/dev/null
 if [ $? -eq 0 ]; then
    echo -n "ONLINE"
 else
    echo -n "OFFLINE"
 fi

 echo "  $ipv4"
 printf "\n"

 echo "PACKETS RECEIVED     REQUESTS OUT"
 echo "$packets_received                 $requests_out"



 sleep $refresh_time
 clear
done
