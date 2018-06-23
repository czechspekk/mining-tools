#!/bin/bash

#Expects input in form of "oneHost otherHost" or "12.23.34.45 21.32.43.45" - no error handling -> no input = no data
CLUSTER_NODES=$1
declare -A HRS
TOTAL_RATE=0
for NODE in $CLUSTER_NODES
do
	HR=`ssh $NODE ~/tools/get-latest-hashrate.sh`
	HRS[$NODE]=$HR
	PARTIAL_RATE=`echo "$HR" | cut -d ' ' -f 2 | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g"` 
	TOTAL_RATE=`echo "$TOTAL_RATE + $PARTIAL_RATE" | bc`
done
if [ "x$SLACK_WEBHOOK_URL" != "x" ]
then
	curl -X POST --data-urlencode "payload={\"channel\": \"#nogrod-operations\", \"username\": \"webhookbot\", \"text\": \"Total hashrate: $TOTAL_RATE\", \"icon_emoji\": \":gluckauf:\"}" $SLACK_WEBHOOK_URL &> /dev/null
fi
