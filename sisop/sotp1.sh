GRUPO=`cd -`
if [ ! -f "$GRUPO/sisop/sotp1.conf" ]
then
    DIRBIN=bin
    DIRMAE=master
    DIRENT=ENTRADATP
    DIRRECH=rechazos
    DIRPROC=lotes
    DIRSAL=SALIDATP
    choice=NO
    clear
    echo Comenzando el proceso de instalacion...

    while [ $choice = "NO" ]
    do

        echo Defina el nombre del directorio de ejecutables \(actualmente es $DIRBIN, si quiere usarlo presione ENTER sin escribir nada\):
        read DIRBIN_aux
        while [[ ($DIRBIN_aux = "original") || ($DIRBIN_aux = "sisop") || ($DIRBIN_aux = "tp1datos") || ($DIRBIN_aux = "misdatos") || ($DIRBIN_aux = "mispruebas") || ($DIRBIN_aux = $DIRMAE) || ($DIRBIN_aux = $DIRENT) || ($DIRBIN_aux = $DIRRECH) || ($DIRBIN_aux = $DIRPROC) || ($DIRBIN_aux = $DIRSAL) || ($DIRBIN_aux = "Grupo1") ]]
        do
            if [[ ($DIRBIN_aux = "original") || ($DIRBIN_aux = "sisop") || ($DIRBIN_aux = "tp1datos") || ($DIRBIN_aux = "misdatos") || ($DIRBIN_aux = "mispruebas") || ($DIRBIN_aux = "Grupo1") ]]
            then
                echo $DIRBIN_aux es un valor reservado. Defina el nombre del directorio de ejecutables \(actualmente es $DIRBIN, si quiere usarlo presione enter sin escribir nada\):
            else
                echo $DIRBIN_aux ya ha sido usado para otro directorio. Defina el nombre del directorio de ejecutables \(actualmente es $DIRBIN, si quiere usarlo presione enter sin escribir nada\):
            fi
            read DIRBIN_aux
        done
        if [ ! $DIRBIN_aux = "^$" ]
        then
            DIRBIN=$DIRBIN_aux
        fi

        echo Defina el nombre del directorio de tablas del sistema \(actualmente es $DIRMAE, si quiere usarlo presione ENTER sin escribir nada\):
        read DIRMAE_aux
        while [[ ($DIRMAE_aux = "original") || ($DIRMAE_aux = "sisop") || ($DIRMAE_aux = "tp1datos") || ($DIRMAE_aux = "misdatos") || ($DIRMAE_aux = "mispruebas") || ($DIRMAE_aux = $DIRBIN) || ($DIRMAE_aux = $DIRENT) || ($DIRMAE_aux = $DIRRECH) || ($DIRMAE_aux = $DIRPROC) || ($DIRMAE_aux = $DIRSAL) || ($DIRMAE_aux = "Grupo1") ]]
        do
            if [[ ($DIRMAE_aux = "original") || ($DIRMAE_aux = "sisop") || ($DIRMAE_aux = "tp1datos") || ($DIRMAE_aux = "misdatos") || ($DIRMAE_aux = "mispruebas") ]]
            then
                echo $DIRMAE_aux es un valor reservado. Defina el nombre del directorio de tablas del sistema \(actualmente es $DIRMAE, si quiere usarlo presione ENTER sin escribir nada\):
            else
                echo $DIRMAE_aux ya ha sido usado para otro directorio. Defina el nombre del directorio de tablas del sistema \(actualmente es $DIRMAE, si quiere usarlo presione ENTER sin escribir nada\):
            fi
            read DIRMAE_aux
        done
        if [ ! $DIRMAE_aux = "^$" ]
        then
            DIRMAE=$DIRMAE_aux
        fi

        echo Defina el nombre del directorio de novedades \(actualmente es $DIRENT, si quiere usarlo presione ENTER sin escribir nada\):
        read DIRENT_aux
        while [[ ($DIRENT_aux = "original") || ($DIRENT_aux = "sisop") || ($DIRENT_aux = "tp1datos") || ($DIRENT_aux = "misdatos") || ($DIRENT_aux = "mispruebas") || ($DIRENT_aux = $DIRBIN) || ($DIRENT_aux = $DIRMAE) || ($DIRENT_aux = $DIRRECH) || ($DIRENT_aux = $DIRPROC) || ($DIRENT_aux = $DIRSAL) || ($DIRENT_aux = "Grupo1") ]]
        do
            if [[ ($DIRENT_aux = "original") || ($DIRENT_aux = "sisop") || ($DIRENT_aux = "tp1datos") || ($DIRENT_aux = "misdatos") || ($DIRENT_aux = "mispruebas") || ($DIRENT_aux = "Grupo1") ]]
            then
                echo $DIRENT_aux es un valor reservado. Defina el nombre del directorio de novedades \(actualmente es $DIRENT, si quiere usarlo presione ENTER sin escribir nada\):
            else
                echo $DIRENT_aux ya ha sido usado para otro directorio. Defina el nombre del directorio de novedades \(actualmente es $DIRENT, si quiere usarlo presione ENTER sin escribir nada\):
            fi
            read DIRENT_aux
        done
        if [ ! $DIRENT_aux = "^$" ]
        then
            DIRENT=$DIRENT_aux
        fi

        echo Defina el nombre del directorio para los archivos rechazados \(actualmente es $DIRRECH, si quiere usarlo presione ENTER sin escribir nada\):
        read DIRRECH_aux
        while [[ ($DIRRECH_aux = "original") || ($DIRRECH_aux = "sisop") || ($DIRRECH_aux = "tp1datos") || ($DIRRECH_aux = "misdatos") || ($DIRRECH_aux = "mispruebas") || ($DIRRECH_aux = $DIRBIN) || ($DIRRECH_aux = $DIRMAE) || ($DIRRECH_aux = $DIRENT) || ($DIRRECH_aux = $DIRPROC) || ($DIRRECH_aux = $DIRSAL) || ($DIRRECH_aux = "Grupo1") ]]
        do
            if [[ ($DIRRECH_aux = "original") || ($DIRRECH_aux = "sisop") || ($DIRRECH_aux = "tp1datos") || ($DIRRECH_aux = "misdatos") || ($DIRRECH_aux = "mispruebas") || ($DIRRECH_aux = "Grupo1") ]]
            then
                echo $DIRRECH_aux es un valor reservado. Defina el nombre del directorio para los archivos rechazados \(actualmente es $DIRRECH, si quiere usarlo presione ENTER sin escribir nada\):
            else
                echo $DIRRECH_aux ya ha sido usado para otro directorio. Defina el nombre del directorio para los archivos rechazados \(actualmente es $DIRRECH, si quiere usarlo presione ENTER sin escribir nada\):
            fi
            read DIRRECH_aux
        done
        if [ ! $DIRRECH_aux = "^$" ]
        then
            DIRRECH=$DIRRECH_aux
        fi

        echo Defina el nombre del directorio de lotes ya procesados \(actualmente es $DIRPROC, si quiere usarlo presione ENTER sin escribir nada\):
        read DIRPROC_aux
        while [[ ($DIRPROC_aux = "original") || ($DIRPROC_aux = "sisop") || ($DIRPROC_aux = "tp1datos") || ($DIRPROC_aux = "misdatos") || ($DIRPROC_aux = "mispruebas") || ($DIRPROC_aux = $DIRBIN) || ($DIRPROC_aux = $DIRMAE) || ($DIRPROC_aux = $DIRENT) || ($DIRPROC_aux = $DIRRECH) || ($DIRPROC_aux = $DIRSAL) || ($DIRPROC_aux = "Grupo1") ]]
        do
            if [[ ($DIRPROC_aux = "original") || ($DIRPROC_aux = "sisop") || ($DIRPROC_aux = "tp1datos") || ($DIRPROC_aux = "misdatos") || ($DIRPROC_aux = "mispruebas") || ($DIRPROC_aux = "Grupo1") ]]
            then
                echo $DIRPROC_aux es un valor reservado. Defina el nombre del directorio de lotes ya procesados \(actualmente es $DIRPROC, si quiere usarlo presione ENTER sin escribir nada\):
            else
                echo $DIRPROC_aux ya ha sido usado para otro directorio. Defina el nombre del directorio de lotes ya procesados \(actualmente es $DIRPROC, si quiere usarlo presione ENTER sin escribir nada\):
            fi
            read DIRPROC_aux
        done
        if [ ! $DIRPROC_aux = "^$" ]
        then
            DIRPROC=$DIRPROC_aux
        fi

        echo Defina el nombre del directorio de resultados \(actualmente es $DIRSAL, si quiere usarlo presione ENTER sin escribir nada\):
        read DIRSAL_aux
        while [[ ($DIRSAL_aux = "original") || ($DIRSAL_aux = "sisop") || ($DIRSAL_aux = "tp1datos") || ($DIRSAL_aux = "misdatos") || ($DIRSAL_aux = "mispruebas") || ($DIRSAL_aux = $DIRBIN) || ($DIRSAL_aux = $DIRMAE) || ($DIRSAL_aux = $DIRENT) || ($DIRSAL_aux = $DIRRECH) || ($DIRSAL_aux = $DIRPROC) || ($DIRSAL_aux = "Grupo1") ]]
        do
            if [[ ($DIRSAL_aux = "original") || ($DIRSAL_aux = "sisop") || ($DIRSAL_aux = "tp1datos") || ($DIRSAL_aux = "misdatos") || ($DIRSAL_aux = "mispruebas") || ($DIRSAL_aux = "Grupo1") ]]
            then
                echo $DIRSAL_aux es un valor reservado. Defina el nombre del directorio de resultados \(actualmente es $DIRSAL, si quiere usarlo presione ENTER sin escribir nada\):
            else
                echo $DIRSAL_aux ya ha sido usado para otro directorio. Defina el nombre del directorio de resultados \(actualmente es $DIRSAL, si quiere usarlo presione ENTER sin escribir nada\):
            fi
            read DIRSAL_aux
        done
        if [ ! $DIRSAL_aux = "^$" ]
        then
            DIRSAL=$DIRSAL_aux
        fi
           
        clear

        echo -e 'Tipo de proceso: \t \t \t \t \t INSTALACION'
        echo -e 'Directorio padre: \t \t \t \t \t '$GRUPO
        echo -e 'Ubicacion script de instalacion: \t \t \t '$GRUPO/sisop/sotp1.sh
        echo -e 'Log de la instalación: \t \t \t \t \t '$GRUPO/sisop/sotp1.log
        echo -e 'Archivo de configuración: \t \t \t \t '$GRUPO/sisop/sotp1.conf
        echo -e 'Log de la inicialización: \t \t \t \t '$GRUPO/sisop/soinit.log
        echo -e 'Log del proceso principal: \t \t \t \t '$GRUPO/sisop/tpcuotas.log
        echo -e 'Directorio de ejecutables: \t \t \t \t '$GRUPO/$DIRBIN
        echo -e 'Directorio de tablas maestras: \t \t \t \t '$GRUPO/$DIRMAE
        echo -e 'Directorio de novedades: \t \t \t \t '$GRUPO/$DIRENT
        echo -e '*Directorio novedades aceptadas: \t \t \t '$GRUPO/$DIRENT/ok
        echo -e 'Directorio de rechazados: \t \t \t \t '$GRUPO/$DIRRECH
        echo -e 'Directorio de lotes procesados: \t \t \t '$GRUPO/$DIRPROC
        echo -e 'Directorio de liquidaciones: \t \t \t \t '$GRUPO/$DIRSAL

        echo

        echo Esta de acuerdo con los directorios? \(SI - NO\)
        read choice

        if [ $choice = 'SI' ]
        then
            mkdir -p "$GRUPO/$DIRBIN"
            mkdir -p "$GRUPO/$DIRMAE"
            mkdir -p "$GRUPO/$DIRENT"
            mkdir -p "$GRUPO/$DIRRECH"
            mkdir -p "$GRUPO/$DIRPROC"
            mkdir -p "$GRUPO/$DIRSAL"

            echo >> "$GRUPO/sisop/sotp1.log"
            echo >> "$GRUPO/sisop/soinit.log"
            echo >> "$GRUPO/sisop/tpcuotas.log"
            echo -e "GRUPO-$GRUPO\nDIRCONF-$GRUPO/sisop\nDIRBIN-$GRUPO/$DIRBIN\nDIRMAE-$GRUPO/$DIRMAE\nDIRENT-$GRUPO/$DIRENT\nDIRRECH-$GRUPO/$DIRRECH\nDIRPROC-$GRUPO/$DIRPROC\nDIRSAL-$GRUPO/$DIRSAL" >> "$GRUPO/sisop/sotp1.conf"

        else
            clear
            echo SE RECHAZO LA INSTALACION, SE PEDIRAN NUEVAMENTE LOS DIRECTORIOS
            echo
            echo
        fi
    done
    echo
    echo INSTALACION FINALIZADA
    echo
else
    clear
    echo Programa ya instalado correctamente
    echo
    echo Datos del archivo de configuracion:
    echo
    cat $GRUPO/sisop/sotp1.conf
    echo
fi








