# !/bin/bash
for HOST1 in `psql -h localhost -U postgres -d DBNAME -c "select hostname from sites_full order by hostname ASC;"`
do
	if [ "$HOST1" == "hostname" ] #First hostname result is empty.. (=column title)
	then
		continue
	else
		HOST_FINAL="$(curl -Ls -o /dev/null -w %{url_effective} $HOST1 | sed -e 's/http:\/\///g' -e 's/https:\/\///g' -e 's/\/.*$//')" #Get final hostname after redirections
		HOST_IP="$(dig $HOST_FINAL +noall +answer | grep $'IN\tA' | grep -v 'IP ADDRESS SUBNET eg: 192.168.0')" #Check if new IP address is different from customers IP subnet (grep -v)
		if [ -z "$HOST_IP" ]
		then
			continue
		else
			echo $HOST_FINAL
			echo $HOST_IP
			printf "\n"
		fi
	fi
done
