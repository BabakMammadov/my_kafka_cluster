# Increase rep factor with manually
export KAFKA_HOST=" kafka1:9092,kafka2:9092,kafka3:9092"
export ZK_HOST="zookeeper1:2181,zookeeper2:2181,zookeeper3:2181/kafka"

# create topic
kafka-topics.sh --zookeeper $ZK_HOST  --create --topic  second_topic03 --replication-factor 1 --partitions 4

# describe topic part assignment
# produce messages
# consume messages

# Create topic name assignment json file
touch topics.json
{
    "version": 1,
    "topics": [
        { "topic": "second_topic03"}
    ]
}

# generate 
kafka-reassign-partitions.sh --zookeeper $ZK_HOST --topics-to-move-json-file topics.json --broker-list "1,2,3" --generate 

{"version":1,"partitions":[{"topic":"second_topic03","partition":2,"replicas":[1],"log_dirs":["any"]},{"topic":"second_topic03","partition":1,"replicas":[3],"log_dirs":["any"]},{"topic":"second_topic03","partition":0,"replicas":[2],"log_dirs":["any"]},{"topic":"second_topic03","partition":3,"replicas":[2],"log_dirs":["any"]}]}

Proposed partition reassignment configuration
{"version":1,"partitions":[{"topic":"second_topic03","partition":2,"replicas":[2],"log_dirs":["any"]},{"topic":"second_topic03","partition":1,"replicas":[1],"log_dirs":["any"]},{"topic":"second_topic03","partition":0,"replicas":[3],"log_dirs":["any"]},{"topic":"second_topic03","partition":3,"replicas":[3],"log_dirs":["any"]}]}

# Copy proposed partition reassignment, change based on your requirements. 
cat increased_rep_fac.json | jq
{
  "version": 1,
  "partitions": [
    {
      "topic": "second_topic03",
      "partition": 2,
      "replicas": [
        2,3
      ]
    },
    {
      "topic": "second_topic03",
      "partition": 1,
      "replicas": [
        1,2
      ]
    },
    {
      "topic": "second_topic03",
      "partition": 0,
      "replicas": [
        3,1
      ]
    },
    {
      "topic": "second_topic03",
      "partition": 3,
      "replicas": [
        3,2
      ]
    }
  ]
}



# execute
$ kafka-reassign-partitions.sh --zookeeper $ZK_HOST --reassignment-json-file increased_rep_fac.json --execute


$ kafka-topics.sh --zookeeper $ZK_HOST  --describe --topic  second_topic03 
Topic: second_topic03	PartitionCount: 4	ReplicationFactor: 2	Configs: 
	Topic: second_topic03	Partition: 0	Leader: 3	Replicas: 3,1	Isr: 1,3
	Topic: second_topic03	Partition: 1	Leader: 1	Replicas: 1,2	Isr: 1,2
	Topic: second_topic03	Partition: 2	Leader: 2	Replicas: 2,3	Isr: 3,2
	Topic: second_topic03	Partition: 3	Leader: 2	Replicas: 3,2	Isr: 2,3

### No way increase rep factor with Kafka Manager 




### Increase Replication Factor With Linkedin tools

# generate test
kafka-assigner -z $ZK_HOST --generate set-replication-factor  --topic second_topic03  --replication-factor 1


# execute
kafka-assigner -z $ZK_HOST -e  set-replication-factor   --topic second_topic02 --replication-factor 1


