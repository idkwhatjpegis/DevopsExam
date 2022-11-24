#!/bin/bash

echo "* Update repositories and install common packages"
apt-get update
apt-get install -y ca-certificates curl gnupg lsb-release tree git 

echo "* Import the repository key"
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

echo "* Install transport https package for Debian"
sudo apt-get -y install apt-transport-https

echo "*Save repository definition"
echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

echo "* Install Elasticsearch, Logstash, and Kibana"
sudo apt-get update && sudo apt-get install -y elasticsearch logstash kibana

echo "* Deploy configuration for Elasticsearch"
sudo cp -v /vagrant/elasticsearch.yml /etc/elasticsearch/

echo "* Correct the Java heap size for Elasticsearch"
cat > /etc/elasticsearch/jvm.options.d/jvm.options <<EOF
-Xms1g
-Xmx1g
EOF
    
echo "* Create beats configuration for Logstash"
cat > /etc/logstash/conf.d/beats.conf << EOF
input {
  beats {
    port => 5044
  }
}
output {
  elasticsearch {
    hosts => ["http://localhost:9200"]
    index => "%{[@metadata][beat]}-%{[@metadata][version]}-%{+YYYY.MM.dd}"
  }
}
EOF

echo "* Deploy configuration for Kibana"
sudo cp -v /vagrant/kibana.yml /etc/kibana/

echo "* Start the services"
systemctl daemon-reload
systemctl enable --now elasticsearch
systemctl enable --now logstash
systemctl enable --now kibana