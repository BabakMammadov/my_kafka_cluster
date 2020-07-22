# In agent side, all brokers
cd 
mkdir jolokia
wget https://search.maven.org/remotecontent?filepath=org/jolokia/jolokia-jvm/1.6.2/jolokia-jvm-1.6.2-agent.jar -O jolokia-agent.jar


# add it to home systemd unit file.
Environment="KAFKA_OPTS=-javaagent:/root/prometheus/jmx_prometheus_javaagent-0.13.0.jar=8000:/root/prometheus/kafka-0-8-2.yml -javaagent:/root/jolokia/jolokia-agent.jar=host=*"

systemctl daemon-reload 
systemctl restart kafka 
systemctl status kafka

#Now it works
curl localhost:8778/jolokia
<h1>404 Not Found</h1>No context found for request# 

curl -s  localhost:8778/jolokia/read/kafka.server:type=KafkaRequestHandlerPool,name=RequestHandlerAvgIdlePercent| jq
{
  "request": {
    "mbean": "kafka.server:name=RequestHandlerAvgIdlePercent,type=KafkaRequestHandlerPool",
    "type": "read"
  },
  "value": {
    "RateUnit": "NANOSECONDS",
    "OneMinuteRate": 0.9996199913247693,
    "EventType": "percent",
    "Count": 432031007860,
    "FifteenMinuteRate": 0.9731692839133481,
    "FiveMinuteRate": 0.9891381241292893,
    "MeanRate": 0.9986911258471968
  },
  "timestamp": 1594241132,
  "status": 200
}

curl -s  localhost:8778/jolokia/read/kafka.server:name=UnderReplicatedPartitions,type=ReplicaManager/Value| jq
{
  "request": {
    "mbean": "kafka.server:name=UnderReplicatedPartitions,type=ReplicaManager",
    "attribute": "Value",
    "type": "read"
  },
  "value": 0,
  "timestamp": 1594241314,
  "status": 200
}



############ Rolling Restart of Brokers installing Yelp Tools ####################
1. Provides passwordless login to brokers from admin tool server.
2. Testing rolling restart 
Hansi ki bu admin server agentlere 8778 portu ile qoshulur ve gracefull restart edir.

# Passwordless login
mkdir .ssh
cd .ssh/
vim config 
chmod 0400 config 
ssh-keygen 
ssh-copy-id -i id_rsa.pub root@172.20.20.21
ssh-copy-id -i id_rsa.pub root@172.20.20.22
ssh-copy-id -i id_rsa.pub root@172.20.20.23


# In admin server
https://github.com/Yelp/kafka-utils


$ pip install kafka-utils
# Install gcc, openssl-devel in centos 
$ kafka-utils  --help
usage: kafka-utils [-h] [-v] [--discovery-base-path DISCOVERY_BASE_PATH]
Show available clusters.
optional arguments:
  -h, --help            show this help message and exit
  -v, --version         show program's version number and exit
  --discovery-base-path DISCOVERY_BASE_PATH
                        Path of the directory containing the
                        <cluster_type>.yaml config. Default try:
                        $KAFKA_DISCOVERY_DIR, $HOME/.kafka_discovery,
                        /etc/kafka_discovery'
# yelp another commands
$ kafka-
kafka-check   kafka-cluster-manager   kafka-consumer-manager  kafka-corruption-check  kafka-rolling-restart   kafka-utils



$ mkdir -p /etc/kafka_discovery
$ edit /etc/kafka_discovery/kafka.yaml
---
  clusters:
    cluster-1:
      broker_list:
        - "kafka1:9092,kafka2:9092,kafka3:9093"
      zookeeper: "zookeeper1:2181,zookeeper2:2181,zookeeper3:2181/kafka"
  local_config:
    cluster: cluster-1


$ kafka-utils 
cluster-type kafka:
	cluster-name: cluster-1
	broker-list: kafka1:9092,kafka2:9092,kafka3:9093
	zookeeper: zookeeper1:2181,zookeeper2:2181,zookeeper3:2181/kafka

$  kafka-rolling-restart --cluster-type kafka 
Will restart the following brokers in cluster-1:
  1: kafka1
  2: kafka2
  3: kafka3
Do you want to restart these brokers? 
Please respond with 'yes' or 'no'
Do you want to restart these brokers? yes


$  kafka-rolling-restart --help 

# Change start and stop command and checkount  in rolling restart 
$ kafka-rolling-restart --cluster-type kafka --start-command "systemctl start kafka" --stop-command "systemctl stop kafka" --check-count 3



# Update kafka configs solutions 1
1. Update server.properties(for example change min.insync.replica in server properties file)
2. Rolling Restart



# Update kafka configs solutions 2(kafka-configs commands)
From Kafka version 1.1 onwards, some of the broker configs can be updated without restarting the broker. See the Dynamic Update Mode column in Broker Configs for the update mode of each broker config.
read-only: Requires a broker restart for update
per-broker: May be updated dynamically for each broker
cluster-wide: May be updated dynamically as a cluster-wide default. May also be updated as a per-broker value for testing.

# Broker-Wide
$ export KAFKA_HOST=172.20.20.21:9092
$ bin/kafka-configs.sh --bootstrap-server $KAFKA_HOST --entity-type brokers --entity-name 1 --alter --add-config log.cleaner.threads=2 
Completed updating config for broker: 1.

# Daha sonra sen zoonavigatorgirib zookeeper baxsan gorecesen ki config sadece broker 1 e apply olub(/kafka/config/brokers/1)

$ bin/kafka-configs.sh --bootstrap-server $KAFKA_HOST --entity-type brokers --entity-name 0 --describe
$ bin/kafka-configs.sh --bootstrap-server $KAFKA_HOST --entity-type brokers --entity-name 0 --alter --delete-config log.cleaner.threads

# Cluster-Wide
bin/kafka-configs.sh --bootstrap-server $KAFKA_HOST --entity-type brokers --entity-default --alter --add-config log.cleaner.threads=2
# Bu zaman sen zoonavigatora girsen goreceksen ki /kafka/config/brokers/<default>
bin/kafka-configs.sh --bootstrap-server $KAFKA_HOST --entity-type brokers --entity-default describe