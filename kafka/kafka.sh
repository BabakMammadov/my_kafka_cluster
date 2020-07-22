eparate Disk ands XFS FS
Configure FileHandle Limits
Configure Kafka as a Service


# user_profile
DAEMON_PATH=/root/kafka/bin
export PATH=$PATH:$DAEMON_PATH
export KAFKA_HEAP_OPTS="-Xmx256M -Xms128M"







echo "* hard nofile 100000
* soft nofile 100000" | sudo tee  --append /etc/security/limits.conf


# Edit Kafka Configs 
cd kafka 
mv config/server.properties config/serverpropertiesold
vim config/server.properties




# start kafka
bin/kafka-server-start.sh config/server.properties




# check zookeeper
bin/zookeeper-shell.sh localhost:2181
ls /kafka




# check  zoo navigator in WEB UI


# edit kafka confs
rm config/server.properties
vim  config/server.properties  ## Add below config




Single node client connect
bin/kafka-topics.sh --zookeeper  zookeeper1:2181/kafka  --create --topic first_topic --replication-factor 1  --partitions 3
bin/kafka-console-producer.sh --broker-list kafka1:9092 --topic first_topic 
bin/kafka-console-consumer.sh --bootstrap-server kafka1:9092 --topic first_topic  --from-beginning
bin/kafka-topics.sh --zookeeper  zookeeper1:2181/kafka   --list


Multi node client connect
After configure mutli node kafka cluster  you have to configure as command before you created
# make sure fix to consumer offsett topic It's issue
 bin/kafka-topics.sh --zookeeper  zookeeper1:2181/kafka --config min.insync.replicas=1 --topic __consumer_offsets  --alter 
 
 
 
Read one  of the  borker above produser data.
bin/kafka-console-consumer.sh --bootstrap-server kafka1:9092 --topic first_topic  --from-beginning



Mutli Node Cluster de sen borker id, listenet adini , min.insync.replicas  sayini deyishmelisen


Single Node Kafka Cluster Config

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# see kafka.server.KafkaConfig for additional details and defaults


############################# Server Basics #############################


# The id of the broker. This must be set to a unique integer for each broker.
broker.id=1


############################# Socket Server Settings #############################


# The address the socket server listens on. It will get the value returned from 
# java.net.InetAddress.getCanonicalHostName() if not configured.
#   FORMAT:
#     listeners = listener_name://host_name:port
#   EXAMPLE:
#     listeners = PLAINTEXT://your.host.name:9092
listeners=PLAINTEXT://kafka1:9092


# Hostname and port the broker will advertise to producers and consumers. If not set, 
# it uses the value for "listeners" if configured.  Otherwise, it will use the value
# returned from java.net.InetAddress.getCanonicalHostName().
advertised.listeners=PLAINTEXT://kafka1:9092




# Switch to enable topic deletion or not , default value is false
delete.topic.enable=true






# Maps listener names to security protocols, the default is for them to be the same. See the config documentation for more details
#listener.security.protocol.map=PLAINTEXT:PLAINTEXT,SSL:SSL,SASL_PLAINTEXT:SASL_PLAINTEXT,SASL_SSL:SASL_SSL


# The number of threads that the server uses for receiving requests from the network and sending responses to the network
num.network.threads=3


# The number of threads that the server uses for processing requests, which may include disk I/O
num.io.threads=8


# The send buffer (SO_SNDBUF) used by the socket server
socket.send.buffer.bytes=102400


# The receive buffer (SO_RCVBUF) used by the socket server
socket.receive.buffer.bytes=102400


# The maximum size of a request that the socket server will accept (protection against OOM)
socket.request.max.bytes=104857600




############################# Log Basics #############################


# A comma separated list of directories under which to store log files
log.dirs=/data/kafka


# The default number of log partitions per topic. More partitions allow greater
# parallelism for consumption, but this will also result in more files across
# the brokers.
num.partitions=8


# we will have 3 broker so default rep factor should 2 or 3 
default.replication.factor=3


# number of ISR to have in order to minimize data loss
min.insync.replicas=2


# The number of threads per data directory to be used for log recovery at startup and flushing at shutdown.
# This value is recommended to be increased for installations with data dirs located in RAID array.
### num.recovery.threads.per.data.dir=1


############################# Internal Topic Settings  #############################
# The replication factor for the group metadata internal topics "__consumer_offsets" and "__transaction_state"
# For anything other than development testing, a value greater than 1 is recommended to ensure availability such as 3.
###offsets.topic.replication.factor=1
###transaction.state.log.replication.factor=1
###transaction.state.log.min.isr=1


############################# Log Flush Policy #############################


# Messages are immediately written to the filesystem but by default we only fsync() to sync
# the OS cache lazily. The following configurations control the flush of data to disk.
# There are a few important trade-offs here:
#    1. Durability: Unflushed data may be lost if you are not using replication.
#    2. Latency: Very large flush intervals may lead to latency spikes when the flush does occur as there will be a lot of data to flush.
#    3. Throughput: The flush is generally the most expensive operation, and a small flush interval may lead to excessive seeks.
# The settings below allow one to configure the flush policy to flush data after a period of time or
# every N messages (or both). This can be done globally and overridden on a per-topic basis.


# The number of messages to accept before forcing a flush of data to disk
#log.flush.interval.messages=10000


# The maximum amount of time a message can sit in a log before we force a flush
#log.flush.interval.ms=1000


############################# Log Retention Policy #############################


# The following configurations control the disposal of log segments. The policy can
# be set to delete segments after a period of time, or after a given size has accumulated.
# A segment will be deleted whenever *either* of these criteria are met. Deletion always happens
# from the end of the log.


# The minimum age of a log file to be eligible for deletion due to age
log.retention.hours=168


# A size-based retention policy for logs. Segments are pruned from the log unless the remaining
# segments drop below log.retention.bytes. Functions independently of log.retention.hours.
#log.retention.bytes=1073741824


# The maximum size of a log segment file. When this size is reached a new log segment will be created.
log.segment.bytes=1073741824


# The interval at which log segments are checked to see if they can be deleted according
# to the retention policies
log.retention.check.interval.ms=300000


############################# Zookeeper #############################


# Zookeeper connection string (see zookeeper docs for details).
# This is a comma separated host:port pairs, each corresponding to a zk
# server. e.g. "127.0.0.1:3000,127.0.0.1:3001,127.0.0.1:3002".
# You can also append an optional chroot string to the urls to specify the
# root directory for all kafka znodes.
zookeeper.connect=zookeeper1:2181,zookeeper2:2181,zookeeper3:2181/kafka


# Timeout in ms for connecting to zookeeper
zookeeper.connection.timeout.ms=6000




############################# Group Coordinator Settings #############################


# The following configuration specifies the time, in milliseconds, that the GroupCoordinator will delay the initial consumer rebalance.
# The rebalance will be further delayed by the value of group.initial.rebalance.delay.ms as new members join the group, up to a maximum of max.poll.interval.ms.
# The default value for this is 3 seconds.
# We override this to 0 here as it makes for a better out-of-the-box experience for development and testing.
# However, in production environments the default value of 3 seconds is more suitable as this will help to avoid unnecessary, and potentially expensive, rebalances during application startup.
###group.initial.rebalance.delay.ms=3






############################# Other #############################
# don't use it in production, I'll keep in for testing.
auto.create.topics.enable=true




docker-compose.yml
version: '2'


services:
  kafka-manager:
    image: sheepkiller/kafka-manager:latest
    network_mode: host
    environment:
      ZK_HOSTS: "zookeeper1:2181,zookeeper2:2181,zookeeper3:2181"
      APPLICATION_SECRET: letmein
      KM_ARGS: -Djava.net.preferIPv4Stack=true
    restart: always





Testing Cluster

# Create topics with replication factor 3
bin/kafka-topics.sh --zookeeper zookeeper1:2181,zookeeper2:2181,zookeeper3:2181/kafka  --create --topic  second_topic --replication-factor 3 --partitions 3

# we can publish data to Kafka using the bootstrap server list(any broker)
bin/kafka-console-producer.sh --broker-list kafka1:9092,kafka2:9092,kafka3:9092 --topic  second_topic

# we can get data from kafka topic any broker using bootstrap server list
bin/kafka-console-consumer.sh --bootstrap-server  kafka1:9092,kafka2:9092,kafka3:9092 --topic  second_topic --from-beginning

# List all topics
bin/kafka-topics.sh --zookeeper  zookeeper1:2181,zookeeper2:2181,zookeeper3:2181/kafka   --list

# Delete topic
bin/kafka-topics.sh --zookeeper  zookeeper1:2181,zookeeper2:2181,zookeeper3:2181/kafka   --delete --topic first_topic 
Topic first_topic is marked for deletion.
Note: This will have no impact if delete.topic.enable is not set to true.

# List again.
bin/kafka-topics.sh --zookeeper  zookeeper1:2181,zookeeper2:2181,zookeeper3:2181/kafka   --list
__consumer_offsets
second_topic