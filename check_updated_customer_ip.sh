# !/bin/bash
for HOST1 in `psql -h localhost -U postgres -d DBNAME -c "select hostname from sites_full order by hostname ASC;"`
do
	if [ "$HOST1" == "hostname" ] #First hostname result is empty.. (=column title)
	then
		continue
	else
		HOST_IP="$(curl -Ls -o /dev/null -w "%{url_effective}  %{remote_ip}" $HOST1 | grep -v 'IP ADDRESS SUBNET eg: 192.168.0')" #Check if new IP address is different from customers IP subnet (grep -v)
		if [ -z "$HOST_IP" ]
		then
			continue
		else
			echo $HOST1
			echo $HOST_IP
			printf "\n"
		fi
	fi
done
