	#!/bin/bash 
	SERVERS=("google.com" "github.com" "pbca.local" "nonexistent.server")
	REACHABLE=0
	UNREACHABLE=0
	for SERVER in ${SERVERS[@]}; do 
		ping -c 1 $SERVER &>/dev/null 
		if [ $? -eq 0 ]; then 
			REACHABLE=$((REACHABLE +1))
			echo "$SERVER is reachable"
		else 
			UNREACHABLE=$((UNREACHABLE +1))
			echo "$SERVER is NOT reachable"
		fi
	done
	echo "========= Summary ========="
	echo "Reachable: $REACHABLE"
	echo "Unreachable:$UNREACHABLE"

