Install java and helpfull packages
disable ram swap
add host mappings to /etc/hosts
download and setup zookeeper 
start zookeper
setup zookeper as a service


# user_profile
DAEMON_PATH=/root/kafka/bin
export PATH=$PATH:$DAEMON_PATH
export KAFKA_HEAP_OPTS="-Xmx256M -Xms128M"



Zookeeper Quorum Setup
#!/usr/bin/env bash
## Update and install helpful packages
sudo apt-get  update -y && sudo apt-get install vim  wget ca-certificates zip net-tools nano tar netcat -y


##  Install Java
sudo apt-get install default-jdk -y
java -version


## Disable Swap
sudo sysctl vm.swappiness=1
echo 'vm.swappiness=1' >> /etc/sysctl.conf


## Download Zookeeper and Kafa Packages
wget https://downloads.apache.org/kafka/2.4.1/kafka_2.11-2.4.1.tgz
tar -xzvf kafka_2.11-2.4.1.tgz
mv  kafka_2.11-2.4.1 kafka
rm -rf kafka_2.11-2.4.1




## Start Zookeeper
cd  kafka


# Add config to zookeeper  for  sending 4 letters words commands Or 4lw.commands.whitelist=stat, ruok, conf, isro, wchc
echo "4lw.commands.whitelist=*" >> config/zookeeper.properties


./bin/zookeeper-server-start.sh config/zookeeper.properties




## Start as  daemon in background and test it work as expected
./bin/zookeeper-server-start.sh -daemon config/zookeeper.properties


./bin/zookeeper-shell.sh localhost:2181


Connecting to localhost:2181
Welcome to ZooKeeper!
JLine support is disabled


WATCHER::


WatchedEvent state:SyncConnected type:None path:null
ls /
[zookeeper]
ls /zookeeper
[config, quota]
ls /zookeeper/config
[]




## stat,ruok, mntr, wchc
$ echo 'ruok' | nc localhost 2181 ; echo
imok




$ echo 'mntr' | nc localhost 2181 ; echo
zk_version    3.5.7-f0fdd52973d373ffd9c86b81d99842dc2c7f660e, built on 02/10/2020 11:30 GMT
zk_avg_latency    0
zk_max_latency    0
zk_min_latency    0
zk_packets_received    2
zk_packets_sent    1
zk_num_alive_connections    1
zk_outstanding_requests    0
zk_server_state    standalone
zk_znode_count    5
zk_watch_count    0
zk_ephemerals_count    0
zk_approximate_data_size    44
zk_open_file_descriptor_count    128
zk_max_file_descriptor_count    10240




## [2020-06-28 19:14:00,898] INFO The list of enabled four letter word commands is : [[wchs, stat, wchp, dirs, stmk, conf, ruok, mntr, srvr, wchc, envi, srst, isro, dump, gtmk, telnet close, crst, cons]] (org.apache.zookeeper.server.command.FourLetterCommands)




## Create service file for zookeeper
[Unit]
Description=Zookeeper Systemd File
After=syslog.target network.target
[Service]
LimitNOFILE=infinity
LimitNPROC=infinity
LimitAS=infinity
LimitFSIZE=infinity
User=root
Group=root
PIDFile=/var/run/zookeeper/zookeeper.pid
PermissionsStartOnly=true
ExecStartPre=-/bin/mkdir -p /var/run/zookeeper /var/log/zookeeper /data/zookeeper
ExecStartPre=/bin/chown -R root:root /var/run/zookeeper /var/log/zookeeper /data/zookeeper
ExecStart=/bin/bash -c "./bin/zookeeper-server-start.sh -daemon config/zookeeper.properties >> /var/log/zookeeper/zookeeper.log 2>&1 & echo $! > /var/run/patroni/patroni.pid"
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
KillSignal=SIGTERM
Restart=on-failure
RestartSec=42s
[Install]
WantedBy=multi-user.target






## Zookeeper command line examples
1. Create node, sub node and etc
2. Get/Set data for node
3. Watch a node
4. Delete a node


## Login to shell
./bin/zookeeper-shell.sh localhost:2181 
ls /
[zookeeper]
create /my-node "foo" 
Created /my-node
ls /
[my-node, zookeeper]
get /my-node  
foo


set /my-node "foo1"


get /my-node
foo1


create /my-node/sub-node "new-data"
Created /my-node/sub-node
ls /
[my-node, zookeeper]
ls /my-node
[sub-node]
get /my-node/sub-node
new-data
        


create /my-node/sub-node2 "cool-data"
Created /my-node/sub-node2






rmr /my-node
The command 'rmr' has been deprecated. Please use 'deleteall' instead.
deleteall /my-node
Node does not exist: /my-node
ls /
[zookeeper]




## Test a  watch and it  happen only one time
create /my-node "foo" 
Created /my-node
ls / 
[my-node, zookeeper]


get /my-node true 
'get path [watch]' has been deprecated. Please use 'get [-s] [-w] path' instead.
foo


set /my-node "foo1"


WATCHER::


WatchedEvent state:SyncConnected type:NodeDataChanged path:/my-node





## Stop all single zookeeper in all instances


## Zookeeper Quorum Setup
sudo mkdir -p /data/zookeeper




## declare server identity
echo "1" > /data/zookeeper/myid   ## 2,3 


## Edit zookeeper setting
dataDir=/data/zookeeper
clientPort=2181
maxClientCnxns=0
tickTime=2000
initLimit=10
syncLimit=5
server.1=zookeeper1:2888:3888
server.2=zookeeper2:2888:3888
server.3=zookeeper3:2888:3888
4lw.commands.whitelist=*




## Start zookeeper quorum and check
echo 'ruok' | nc localhost 2181 ; echo
imok




## On every node , create node, delete node and etc.
./bin/zookeeper-shell.sh localhost:2181 




## Zookeeper Four Letter Words


# Get configuration
echo 'conf' | nc zookeeper3 2181 ; echo
clientPort=2181
secureClientPort=-1
dataDir=/data/zookeeper/version-2
dataDirSize=67110000
dataLogDir=/data/zookeeper/version-2
dataLogSize=67110000
tickTime=2000
maxClientCnxns=0
minSessionTimeout=4000
maxSessionTimeout=40000
serverId=3
initLimit=10
syncLimit=5
electionAlg=3
electionPort=3888
quorumPort=2888
peerType=0
membership: 
server.1=zookeeper1:2888:3888:participant
server.2=zookeeper2:2888:3888:participant
server.3=zookeeper3:2888:3888:participant
version=0


# number of client connect to server
echo 'cons' | nc zookeeper3 2181 ; echo
# crst -  reset  connection/session statistics
# dump -  list outstanding sessions  and ephemeral nodes, it will onlt executed in leader node
# envi -  print details about enviroment
# srst - reset server statistics
# srvr - lists full details for server
# stat - brief connected clients
# wchs - lists brief information watches for the server
# wchc -  (new in 3.3.0) lists detail information watches for the server , by session
# wchp -  (new in 3.3.0) lists detail information watches for the server , by path
# mntr - list of variable could be usefull for monitoring health of server






## Zookeper Internal File Structure.


cd /data/zookeeper
$ ls -lR
-rw-r--r-- 1 root root    2 Jun 28 18:32 myid            ## have to created with manualy
drwxr-xr-x 2 root root 4096 Jun 28 19:24 version-2
./version-2:
total 20
-rw-r--r-- 1 root root        1 Jun 28 19:09 acceptedEpoch
-rw-r--r-- 1 root root        1 Jun 28 19:09 currentEpoch
-rw-r--r-- 1 root root 67108880 Jun 28 20:04 log.100000001  ##  data file
-rw-r--r-- 1 root root      559 Jun 28 19:08 snapshot.0

## Setup web tools in another machine


## Update and install helpful packages
sudo apt-get  update -y && sudo apt-get install vim  wget ca-certificates zip net-tools nano tar netcat -y && sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y 


curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get  update -y 
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo docker run hello-world




curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version




## Management tools for Zookeeper
#  ZooNavigator Docker-Compose
version: '2.1'


services:
  web:
    image: elkozmon/zoonavigator-web:latest
    container_name: zoonavigator-web
    ports:
     - "8000:8000"
    extra_hosts:
      zookeeper1: 172.20.20.21
      zookeeper2: 172.20.20.22
      zookeeper3: 172.20.20.23
    environment:
      API_HOST: "api"
      API_PORT: 9000
    depends_on:
     - api
    restart: always
  api:
    image: elkozmon/zoonavigator-api:latest
    container_name: zoonavigator-api
    extra_hosts:
      zookeeper1: 172.20.20.21
      zookeeper2: 172.20.20.22
      zookeeper3: 172.20.20.23
    environment:
      SERVER_HTTP_PORT: 9000
    restart: always
docker-compose  up -d