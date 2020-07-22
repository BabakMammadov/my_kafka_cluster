# Replacing broker(update, upgrade) and keep volume
Steps: 
Terminate this machine
Create new machine
Assign new disk to new machine  
Start kafka on that machine(Sadece bu  machine datalari replicate edecek )


If you have problem disk of kafka broker machine
Steps:
Stop machine
wipe disk 
start broker and kafka automaticly replicate missing data 



Remove completely broker from cluster.
1. Use tool move away partitions from broker
https://github.com/linkedin/kafka-tools/wiki/module-remove
2. Remove broker.
If broker removed first, its impossible to remove the partitions assignment without tinkering with Zookeeper(Its really not recommended)
