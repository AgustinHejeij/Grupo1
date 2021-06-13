if [ -z "$TP_IN_EJEC" ]; then
    if [ ! -z "$AMBIENTE" ]; then
        . ./tpcuotas.sh &
        TP_IN_EJEC=$!
        echo "WAR-$(date +"%Y/%m/%d %T")-El proceso principal se inicio correctamente con pid $TP_IN_EJEC" >> "../sisop/arrancotp1.log"
        echo "El proceso principal se inicio correctamente con pid $TP_IN_EJEC"

    else
        echo "WAR-$(date +"%Y/%m/%d %T")-El ambiente no se encuentra inicializado, no se arranca el proceso principal" >> "../sisop/arrancotp1.log"
        echo "El ambiente no se encuentra inicializado, ejecute soinit.sh"
    fi
fi
echo "WAR-$(date +"%Y/%m/%d %T")-El proceso principal ya esta corriendo, no se puede arrancar uno nuevo" >> "../sisop/arrancotp1.log"
echo El proceso principal ya esta corriendo
