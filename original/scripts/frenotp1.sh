if [ ! -z "$TP_IN_EJEC" ]; then
    kill -9 $TP_IN_EJEC
    echo "INF-$(date +"%Y/%m/%d %T")-Se detuvo el proceso principal con pid $TP_IN_EJEC" >> "../sisop/frenotp1.log"
    echo "Se detuvo el proceso principal con pid $TP_IN_EJEC detenido correctamente"
    TP_IN_EJEC=""
else
    echo "WAR-$(date +"%Y/%m/%d %T")-El proceso principal no esta corriendo, no se puede detener" >> "../sisop/frenotp1.log"
    echo El proceso principal no esta corriendo
fi
