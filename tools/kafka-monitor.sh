https://github.com/linkedin/kafka-monitor


Preprare systemd unti file for this java 



cd kafka-monitor
./gradlew jar

Change config as below
    "zookeeper.connect": "zookeeper1:2181,zookeeper2:2181,zookeeper3:2181",
    "bootstrap.servers": "kafka1:9092,kafka2:9092,kafka3:9092",

./bin/kafka-monitor-start.sh  config/kafka-monitor.properties 