Step1: 
We have to perform (rolling restart at the end of each step)
1.Setting inter broker and log version to current kafka version
2.Upgrade Kafka binaries
3.Change inter broker protocol version 
4.Upgrade kafka client versions if docs specifies it(all or most of them avoid up and down conversions)
5.Upgrade message protocol version 


# We want to upgrade 2.4.1 to 2.5.1
#1. Add current below config to server.properties in all brokers
How to find exist version (cat /var/log/kafka/kafka.log | grep -iE .version)
inter.broker.protocol.version = 2.4
log.message.format.version = 2.4

# In admin server
kafka-rolling-restart --cluster-type kafka --start-command "systemctl start kafka" --stop-command "systemctl stop kafka" --check-count 3

# 2. Upgrade Kafka binaries
Exist kafka home: /root/kafka 

$ wget https://downloads.apache.org/kafka/2.5.0/kafka_2.12-2.5.0.tgz
$ tar -xzvf kafka_2.12-2.5.0.tgz
$ ls 
jolokia  kafka  kafka_2.11-2.4.1.tgz  kafka_2.12-2.5.0  kafka_2.12-2.5.0.tgz  prometheus

$ kafka-topics.sh --version
2.4.1 (Commit:c57222ae8cd7866b)


$ mv kafka kafka.2.4.1working
$ mv kafka_2.12-2.5.0 kafka
$ kafka-topics.sh --version
2.5.0 (Commit:66563e712b0b9f84)


# BU istisnadi cunkimen zookker kafka ilebir yerde ishleyir.Ona gore onunda konfiglerini atmaliyam
cp kafka.2.4.1working/config/zookeeper.properties kafka/config/zookeeper.properties

# Copy exist kafka
cp kafka.2.4.1working/config/server.properties kafka/config/server.properties


kafka-rolling-restart --cluster-type kafka --start-command "systemctl start kafka" --stop-command "systemctl stop kafka" --check-count 3


# 3. Change inter broker protocol version  
inter.broker.protocol.version = 2.4 Update as 2.5

Rolling restart()

#Check as below 
cat /var/log/kafka/kafka.log | grep -iE .version

#Output
	inter.broker.protocol.version = 2.5
	log.message.downconversion.enable = true
	log.message.format.version = 2.4
	inter.broker.protocol.version = 2.5
	log.message.downconversion.enable = true
	log.message.format.version = 2.4


5. log.message.format.version = 2.4 to 2.5
Rolling restart