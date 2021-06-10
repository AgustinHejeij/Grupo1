chmod +x tpcuotas.sh
ID_PROCESO=`ps -ef | awk '/tpcuotas.sh/{ print $2 }'`
kill -9 "$ID_PROCESO"
