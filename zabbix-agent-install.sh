#!/bin/bash
###Created by Georgi Dimitrov
###Purpose is to install
###and apply zabbix_agent config

###vars###
command=rpm
os=$(grep -E '^NAME' /etc/*release|awk -F '\"' '{print $2}')
Host=$(hostname)

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
cp  borica_zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf
mkdir -p /usr/lib/zabbix/externalscripts/ 
cp borica_zabbix/oscheck.sh /usr/lib/zabbix/externalscripts/
####SETUP ZABBIX CONFIGURATON FILE##########################################################
sed -i "s/^Hostname=/Hostname=${Host}.tst.srv/" /etc/zabbix/zabbix_agentd.conf 
#############################################################################################
####SETUP FIREWALL#########################################################################
#zabbix
firewall-cmd --permanent --add-port=10050/tcp
#apply rules
firewall-cmd --reload
################################################################################################
chown -R zabbix: /var/run/zabbix/
chown -R zabbix: /usr/lib/zabbix/
systemctl enable zabbix-agent
systemctl start zabbix-agent
