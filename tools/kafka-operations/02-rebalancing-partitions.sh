export KAFKA_HOST=" kafka1:9092,kafka2:9092,kafka3:9092"
export ZK_HOST="zookeeper1:2181,zookeeper2:2181,zookeeper3:2181/kafka"
# Manual Way rebalancing partition
1.Json file
2.Kafka Manager
3.Linkedin Tools


Json way
# Create topics
bin/kafka-topics.sh --zookeeper $ZK_HOST  --create --topic  second_topic02 --replication-factor 2 --partitions 2

# describe config and see partition assignment
bin/kafka-topics.sh --zookeeper $ZK_HOST  --describe --topic  second_topic02
Topic: second_topic02	PartitionCount: 2	ReplicationFactor: 2	Configs: 
	Topic: second_topic02	Partition: 0	Leader: 2	Replicas: 2,1	Isr: 2,1
	Topic: second_topic02	Partition: 1	Leader: 3	Replicas: 3,2	Isr: 3,2


# produce some messages
bin/kafka-console-producer.sh --broker-list $KAFKA_HOST --topic  second_topic02
>hello 
>hdasd dadaS
>DADaD
>ADaDSSD
>ADADSAD
>aDADaDADaDADaDADaDASd
>


# Consume messages
bin/kafka-console-consumer.sh --bootstrap-server  $KAFKA_HOST --topic  second_topic02 --from-beginning



# Create agginment
touch topics.json
{
    "version": 1,
    "topics": [
        { "topic": "second_topic02"}
    ]
}
$ ./bin/kafka-reassign-partitions.sh --zookeeper $ZK_HOST --topics-to-move-json-file topics.json --broker-list "1,2,3" --generate 

Current partition replica assignment
# {"version":1,"partitions":[{"topic":"second_topic02","partition":1,"replicas":[3,2],"log_dirs":#["any","any"]},{"topic":"second_topic02","partition":0,"replicas":[2,1],"log_dirs":["any","any"]}]}

#Proposed partition reassignment configuration
# {"version":1,"partitions":[{"topic":"second_topic02","partition":0,"replicas":[1,2],"log_dirs":#["any","any"]},{"topic":"second_topic02","partition":1,"replicas":[2,3],"log_dirs":["any","any"]}]}


# Copy from Proposed reassignment file and add below file 
vim reassignment.json
$ ./bin/kafka-reassign-partitions.sh --zookeeper $ZK_HOST --reassignment-json-file reassignment.json --execute 

$ ./bin/kafka-reassign-partitions.sh --zookeeper $ZK_HOST --reassignment-json-file reassignment.json --verify
Status of partition reassignment: 
Reassignment of partition second_topic02-0 completed successfully
Reassignment of partition second_topic02-1 completed successfully

Daha sonra sen hemcinin KafkaManagerde reassignment partition hissesine girsen goreceksen ki axrinci defebu vaxti update olub

# You can see changes with describe command
bin/kafka-topics.sh --zookeeper $ZK_HOST  --describe --topic  second_topic02

# run preferred replica election
bin/kafka-preferred-replica-election.sh --zookeeper $ZK_HOST




In Kafka Manager, "Generate Partition Assignments"  and then  click "Reassign Partitions" daha sonra describe ve ya kafkaM den part assigne baxsaq deyisikliyi goreceyik