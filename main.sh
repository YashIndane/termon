total_mem=$(free -m | grep Mem | awk '{ print $2}')
refresh_time=0.5
while :
do
 year=$(date +"%Y")
 month=$(date +%b | tr [a-z] [A-Z])
 day=$(date +"%d")
 uptime=$(uptime | awk '{ print $1 }')
 type=$(uname -a | awk '{ print $1 }')
 manufacturer=$(dmidecode -t system | grep Manufacturer | awk '{ print $2}')
 model=$(dmidecode -t system | grep Product)
 model="${model:15:40}"
 chasis_type=$(dmidecode -t chassis | grep Type)
 chasis_type="${chasis_type:7:40}"
 cpu=$(lscpu | grep "Model name")
 cpu="${cpu:13:55}"
 p=$(free -m | grep Mem | awk '{ print $4 }')
 p=$(expr $p \* 100)
 per_memf=$(expr $p / $total_mem)

 echo "$year    UPTIME    TYPE    POWER"
 echo "$month $day  $uptime  $type   ON"
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
 printf ']\n'
 echo -n "Free RAM  : ${per_memf}%   ["
 for i in $(seq 1 $per_memf); do printf '|'; done
 for i in $(seq 1 $(expr 100 - $per_memf)); do printf ' '; done
 printf ']\n'
 sleep $refresh_time
 clear
done
