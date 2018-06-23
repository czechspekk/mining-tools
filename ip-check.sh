KNOWN_IP=`cat ~/.my-ip`
CURRENT_IP=`curl --silent ifconfig.co`
if [ "x$CURRENT_IP" != "x" ]
then
	if [ "x$CURRENT_IP" != "x$KNOWN_IP" ]
	then
		echo $CURRENT_IP > ~/.my-ip
		curl -X POST --data-urlencode "payload={\"channel\": \"#nogrod-operations\", \"username\": \"webhookbot\", \"text\": \"Public IP has changed: $CURRENT_IP\", \"icon_emoji\": \":gluckauf:\"}" $SLACK_WEBHOOK_URL 
	fi
fi

