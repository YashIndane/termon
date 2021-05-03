total_mem=$(free -m | grep Mem | awk '{ print $2}')
refresh_time=0.5
while :
do
 p=$(free -m | grep Mem | awk '{ print $4 }')
 p=$(expr $p \* 100)
 per_memf=$(expr $p / $total_mem)
 echo -n "Free RAM  : ${per_memf}%   ["
 for i in $(seq 1 $per_memf); do printf '|'; done
 for i in $(seq 1 $(expr 100 - $per_memf)); do printf ' '; done
 printf ']\n'
 cpu_usage=$(mpstat | grep all | awk '{ print $4 }')
 echo -n "CPU Usage : $cpu_usage% ["
 for i in $(seq 1 ${cpu_usage%.*}); do printf '|'; done
 for i in $(seq 1 $(expr 100 - ${cpu_usage%.*})); do printf ' '; done
 printf ']'
 sleep $refresh_time
 clear
done
