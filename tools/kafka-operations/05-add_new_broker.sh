#1. Install basic system packages, configure bash profile
#2. Install same kafka version setup to same directory, create directory for kafka 
#3. Install Jmx,jolokia agant and add it to kafka service
#4. Change server.properties and restart
#5. Change in admin server tools(prometheus, kafka manager and etc)


Sadece son broker elave edenden sonra onun uzerinde partitionlarin olmadigini goreceksen.Onun uchun linkedin toolundan istifade 
ederek yenileri assing etmelisen.



export KAFKA_HOST=" kafka1:9092,kafka2:9092,kafka3:9092"
export ZK_HOST="zookeeper1:2181,zookeeper2:2181,zookeeper3:2181/kafka"

# test an assigneer
kafka-assigner -z $ZK_HOST --generate balance --types even


# execute an assignment
kafka-assigner -z $ZK_HOST -e balance --types even 
