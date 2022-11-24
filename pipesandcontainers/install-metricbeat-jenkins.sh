#!/bin/bash
echo "*Wait for elasticsearch to go online"

while true; do 
  echo 'Trying to connect to elasticsearch:9200 ...'; 
  if [ $(curl -s -o /dev/null -w "%{http_code}" http://192.168.111.102:9200) == "200" ]; then 
    echo '... connected.'; 
    echo 'Sleep for another 30s for ElasticSerach to calm down';
    sleep 30;
    break; 
  else 
    echo '... no success. Sleep for 5s and retry.'; 
    sleep 5; 
  fi 
done

echo "* Download the package"
wget https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.1.0-amd64.deb

echo "* Install the package"
sudo dpkg -i metricbeat-8.1.0-amd64.deb

echo "* Deploy configuration"
sudo cp -v /vagrant/metricbeat.yml /etc/metricbeat/metricbeat.yml

echo "* Enable the system module"
sudo metricbeat modules enable system

echo "* Enable and start the beat"
sudo systemctl daemon-reload
sudo systemctl enable --now metricbeat


