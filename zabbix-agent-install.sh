#!/bin/bash
###Created by Georgi Dimitrov
###Purpose is to install
###and apply zabbix_agent config

###vars###
command=rpm
os=$(grep -E '^NAME' /etc/*release|awk -F '\"' '{print $2}')

$command -ivh zabbix-agent-4.4.6-*

if which unzip; then

unzip borica_zabbix.zip

else 
 if [ "$os"  == "SLES" ]; then
   zypper -n in unzip
 else
   yum -y install unzip
  fi
fi

echo '02aaa372ba14af274d23e11760ce72dfece18e90a6e490d97b725914e5cbb159' > /etc/zabbix/zabbix_agent.psk
cp  zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf
mkdir -p /usr/lib/zabbix/externalscripts/ 
cp oscheck.sh /usr/lib/zabbix/externalscripts/
####SETUP ZABBIX CONFIGURATON FILE##########################################################
sed -i 's/Server=*/Server=10.1.52.27/g' /etc/zabbix/zabbix_agentd.conf
sed -i 's/ServerActive=*/ServerActive=10.1.52.27:10050/g' /etc/zabbix/zabbix_agentd.conf
sed -i 's/Hostname=*/Hostname=$(hostname -f)/' /etc/zabbix/zabbix_agentd.conf 
sed -  's/TLSPSKIdentity=zabbix/TLSPSKIdentity=zabbix_test/g' /etc/zabbix/zabbix_agentd.conf
#############################################################################################
chown -R zabbix: /var/run/zabbix/
chown -R zabbix: /usr/lib/zabbix/
systemctl enable zabbix-agent
systemctl start zabbix-agent
