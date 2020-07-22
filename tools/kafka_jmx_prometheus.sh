### Implement it kafka  servers
mkdir prometheus
cd prometheus
wget https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.13.0/jmx_prometheus_javaagent-0.13.0.jar
wget https://raw.githubusercontent.com/prometheus/jmx_exporter/master/example_configs/kafka-0-8-2.yml



# Add below config to systemd yaml
Environment="KAFKA_OPTS=-javaagent:/root/prometheus/jmx_prometheus_javaagent-0.13.0.jar=8000:/root/prometheus/kafka-0-8-2.yml"


systemctl daemon-reload
systemctl restart kafka


# Look at metrics
curl localhost:8000/metrics



https://github.com/prometheus/jmx_exporter
https://github.com/oded-dd/prometheus-jmx-kafka
