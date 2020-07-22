### https://github.com/linkedin/kafka-tools , support python3 

export KAFKA_HOST="kafka1:9092,kafka2:9092,kafka3:9092"
export ZK_HOST="zookeeper1:2181,zookeeper2:2181,zookeeper3:2181/kafka"

pip install kafka-tools
kafka-assigner --help


# In bash profile
DAEMON_PATH=/root/kafka/bin
export PATH=$PATH:$DAEMON_PATH
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre

source .profile 

# test an assigneer
kafka-assigner -z $ZK_HOST --generate balance --types count

output
[INFO] Connecting to zookeeper zookeeper1:2181,zookeeper2:2181,zookeeper3:2181/kafka
[INFO] Getting partition list from Zookeeper
[INFO] Closing connection to zookeeper
[INFO] Getting partition sizes via SSH for kafka1
[INFO] Getting partition sizes via SSH for kafka2
[INFO] Getting partition sizes via SSH for kafka3
[INFO] Starting partition balance by count
[INFO] Calculating ideal state for replica position 0 - max 25.0 partitions
[INFO] Calculating ideal state for replica position 1 - max 25.0 partitions
[INFO] Calculating ideal state for replica position 2 - max 24.333333333333332 partitions
[INFO] Partition moves required: 1
[INFO] Number of batches: 1
[INFO] --execute flag NOT specified. DRY RUN ONLY
[INFO] Executing partition reassignment 1/1: {"version": 1, "partitions": [{"partition": 1, "topic": "second_topic02", "replicas": [1, 3]}]}
[INFO] Number of replica elections: 1
[INFO] Executing preferred replica election 1/1



# execute an assignment
kafka-assigner -z $ZK_HOST -e balance --types count 
