GRUPO="$(dirname $PWD)"
es_irreparable(){
    if [ ! -f "$DIRMAE/financiacion.txt" ]
    then
        if [ ! -f "$GRUPO/original/tablas_maestras/financiacion.txt" ]
            then
                return 1
        fi
    elif [ ! -f "$DIRMAE/terminales.txt" ]
    then
        if [ ! -f "$GRUPO/original/tablas_maestras/terminales.txt" ]
            then
                return 1
        fi
    elif [ ! -f "$DIRBIN/tpcuotas.sh" ]
    then
        if [ ! -f "$GRUPO/original/scripts/tpcuotas.sh" ]
            then
                return 1
        fi
    #elif [ ! -f "$DIRBIN/soinit.sh" ]
    #then
    #    if [ ! -f "$GRUPO/original/scripts/soinit.sh" ]
    #        then
    #            return 1
    #    fi
    fi
    return 0
}

necesita_reparacion(){

    if [ ! -d $DIRBIN ]
       then
            return 1
    fi

    if [ ! -f "$DIRBIN/tpcuotas.sh" ]
    then
            return 1
    fi

    #if [ ! -f "$DIRBIN/soinit.sh" ]
    #   then
    #        return 1
    #fi

    if [ ! -f "$DIRMAE/financiacion.txt" ]
       then
            return 1
    fi

    if [ ! -f "$DIRMAE/terminales.txt" ]
       then
            return 1
    fi

    if [ ! -d $DIRENT ]
    then
        return 1
    fi

    if [ ! -d "$DIRENT/ok" ]
    then
        return 1
    fi

    if [ ! -d $DIRRECH ]
    then
        return 1
    fi

    if [ ! -d $DIRPROC ]
    then
        return 1
    fi

    if [ ! -d $DIRSAL ]
    then
        return 1
    fi

    return 0
            
}


if [ ! -f "sotp1.conf" ]
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
    echo -e "INF-$(date +"%Y/%m/%d %T")-Comenzando el proceso de instalacion..." >> "$GRUPO/sisop/sotp1.log"
    echo -n >> "$GRUPO/sisop/soinit.log"
    echo -n >> "$GRUPO/sisop/tpcuotas.log"
    while [ $choice = "NO" ]
    do

        echo Defina el nombre del directorio de ejecutables \(actualmente es $DIRBIN, si quiere usarlo presione ENTER sin escribir nada\):
        echo -e "INF-$(date +"%Y/%m/%d %T")-Se le solicita el directorio de ejecutables al usuario" >> "$GRUPO/sisop/sotp1.log"
        read DIRBIN_aux
        while [[ ($DIRBIN_aux = "original") || ($DIRBIN_aux = "sisop") || ($DIRBIN_aux = "tp1datos") || ($DIRBIN_aux = "misdatos") || ($DIRBIN_aux = "mispruebas") || ($DIRBIN_aux = $DIRMAE) || ($DIRBIN_aux = $DIRENT) || ($DIRBIN_aux = $DIRRECH) || ($DIRBIN_aux = $DIRPROC) || ($DIRBIN_aux = $DIRSAL) || ($DIRBIN_aux = "Grupo1") ]]
        do
            echo -e "ERR-$(date +"%Y/%m/%d %T")-El valor $DIRBIN_aux ingresado para el directorio de ejecutables es erroneo. Se solicita otro nombre al usuario\n" >> "$GRUPO/sisop/sotp1.log"
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
        echo -e "INF-$(date +"%Y/%m/%d %T")-El nombre del directorio de ejecutables determinado por el usuario es $DIRBIN" >> "$GRUPO/sisop/sotp1.log"

        echo Defina el nombre del directorio de tablas del sistema \(actualmente es $DIRMAE, si quiere usarlo presione ENTER sin escribir nada\):
        echo -e "INF-$(date +"%Y/%m/%d %T")-Se le solicita el directorio de tablas maestras al usuario" >> "$GRUPO/sisop/sotp1.log"
        read DIRMAE_aux
        while [[ ($DIRMAE_aux = "original") || ($DIRMAE_aux = "sisop") || ($DIRMAE_aux = "tp1datos") || ($DIRMAE_aux = "misdatos") || ($DIRMAE_aux = "mispruebas") || ($DIRMAE_aux = $DIRBIN) || ($DIRMAE_aux = $DIRENT) || ($DIRMAE_aux = $DIRRECH) || ($DIRMAE_aux = $DIRPROC) || ($DIRMAE_aux = $DIRSAL) || ($DIRMAE_aux = "Grupo1") ]]
        do
            echo -e "ERR-$(date +"%Y/%m/%d %T")-El valor $DIRMAE_aux ingresado para el directorio de tablas maestras es erroneo. Se solicita otro nombre al usuario" >> "$GRUPO/sisop/sotp1.log"
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
        echo -e "INF-$(date +"%Y/%m/%d %T")-El nombre del directorio de tablas maestras determinado por el usuario es $DIRMAE" >> "$GRUPO/sisop/sotp1.log"
        
        echo Defina el nombre del directorio de novedades \(actualmente es $DIRENT, si quiere usarlo presione ENTER sin escribir nada\):
        echo -e "INF-$(date +"%Y/%m/%d %T")-Se le solicita el directorio de novedades al usuario" >> "$GRUPO/sisop/sotp1.log"
        read DIRENT_aux
        while [[ ($DIRENT_aux = "original") || ($DIRENT_aux = "sisop") || ($DIRENT_aux = "tp1datos") || ($DIRENT_aux = "misdatos") || ($DIRENT_aux = "mispruebas") || ($DIRENT_aux = $DIRBIN) || ($DIRENT_aux = $DIRMAE) || ($DIRENT_aux = $DIRRECH) || ($DIRENT_aux = $DIRPROC) || ($DIRENT_aux = $DIRSAL) || ($DIRENT_aux = "Grupo1") ]]
        do
            echo -e "ERR-$(date +"%Y/%m/%d %T")-El valor $DIRENT_aux ingresado para el directorio de novedades es erroneo. Se solicita otro nombre al usuario" >> "$GRUPO/sisop/sotp1.log"
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
        echo -e "INF-$(date +"%Y/%m/%d %T")-El nombre del directorio de novedades determinado por el usuario es $DIRENT" >> "$GRUPO/sisop/sotp1.log"

        echo Defina el nombre del directorio para los archivos rechazados \(actualmente es $DIRRECH, si quiere usarlo presione ENTER sin escribir nada\):
        echo -e "INF-$(date +"%Y/%m/%d %T")-Se le solicita el directorio de archivos rechazados al usuario" >> "$GRUPO/sisop/sotp1.log"
        read DIRRECH_aux
        while [[ ($DIRRECH_aux = "original") || ($DIRRECH_aux = "sisop") || ($DIRRECH_aux = "tp1datos") || ($DIRRECH_aux = "misdatos") || ($DIRRECH_aux = "mispruebas") || ($DIRRECH_aux = $DIRBIN) || ($DIRRECH_aux = $DIRMAE) || ($DIRRECH_aux = $DIRENT) || ($DIRRECH_aux = $DIRPROC) || ($DIRRECH_aux = $DIRSAL) || ($DIRRECH_aux = "Grupo1") ]]
        do
            echo -e "ERR-$(date +"%Y/%m/%d %T")-El valor $DIRRECH_aux ingresado para el directorio de archivos rechazados es erroneo. Se solicita otro nombre al usuario" >> "$GRUPO/sisop/sotp1.log"
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
        echo -e "INF-$(date +"%Y/%m/%d %T")-El nombre del directorio de archivos rechazados determinado por el usuario es $DIRRECH" >> "$GRUPO/sisop/sotp1.log"

        echo Defina el nombre del directorio de lotes ya procesados \(actualmente es $DIRPROC, si quiere usarlo presione ENTER sin escribir nada\):
        echo -e "INF-$(date +"%Y/%m/%d %T")-Se le solicita el directorio de lotes al usuario" >> "$GRUPO/sisop/sotp1.log"
        read DIRPROC_aux
        while [[ ($DIRPROC_aux = "original") || ($DIRPROC_aux = "sisop") || ($DIRPROC_aux = "tp1datos") || ($DIRPROC_aux = "misdatos") || ($DIRPROC_aux = "mispruebas") || ($DIRPROC_aux = $DIRBIN) || ($DIRPROC_aux = $DIRMAE) || ($DIRPROC_aux = $DIRENT) || ($DIRPROC_aux = $DIRRECH) || ($DIRPROC_aux = $DIRSAL) || ($DIRPROC_aux = "Grupo1") ]]
        do
            echo -e "ERR-$(date +"%Y/%m/%d %T")-El valor $DIRPROC_aux ingresado para el directorio de lotes es erroneo. Se solicita otro nombre al usuario" >> "$GRUPO/sisop/sotp1.log"
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
        echo -e "INF-$(date +"%Y/%m/%d %T")-El nombre del directorio de lotes determinado por el usuario es $DIRPROC" >> "$GRUPO/sisop/sotp1.log"

        echo Defina el nombre del directorio de resultados \(actualmente es $DIRSAL, si quiere usarlo presione ENTER sin escribir nada\):
        echo -e "INF-$(date +"%Y/%m/%d %T")-Se le solicita el directorio de resultados al usuario" >> "$GRUPO/sisop/sotp1.log"
        read DIRSAL_aux
        while [[ ($DIRSAL_aux = "original") || ($DIRSAL_aux = "sisop") || ($DIRSAL_aux = "tp1datos") || ($DIRSAL_aux = "misdatos") || ($DIRSAL_aux = "mispruebas") || ($DIRSAL_aux = $DIRBIN) || ($DIRSAL_aux = $DIRMAE) || ($DIRSAL_aux = $DIRENT) || ($DIRSAL_aux = $DIRRECH) || ($DIRSAL_aux = $DIRPROC) || ($DIRSAL_aux = "Grupo1") ]]
        do
            echo -e "ERR-$(date +"%Y/%m/%d %T")-El valor $DIRSAL_aux ingresado para el directorio de resultados es erroneo. Se solicita otro nombre al usuario" >> "$GRUPO/sisop/sotp1.log"
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
        echo -e "INF-$(date +"%Y/%m/%d %T")-El nombre del directorio de resultados determinado por el usuario es $DIRSAL" >> "$GRUPO/sisop/sotp1.log"
           
        clear
        echo -e "INF-$(date +"%Y/%m/%d %T")-Se le muestra los directorios ingresados al usuario y se pide confirmacion" >> "$GRUPO/sisop/sotp1.log"
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
        while [[ (! $choice = 'SI') && (! $choice = 'NO') ]]
        do
            echo Respuesta invalida. Esta de acuerdo con los directorios? \(SI - NO\)
            read choice
        done

        if [ $choice = 'SI' ]
        then
            echo -e "INF-$(date +"%Y/%m/%d %T")-El usuario confirmo los directorios. comenzando la instalacion" >> "$GRUPO/sisop/sotp1.log"
            mkdir -p "$GRUPO/$DIRBIN"
            echo -e "INF-$(date +"%Y/%m/%d %T")-Se creo el directorio de ejecutables" >> "$GRUPO/sisop/sotp1.log"
            mkdir -p "$GRUPO/$DIRMAE"
            echo -e "INF-$(date +"%Y/%m/%d %T")-Se creo el directorio de tablas maestras" >> "$GRUPO/sisop/sotp1.log"
            mkdir -p "$GRUPO/$DIRENT"
            echo -e "INF-$(date +"%Y/%m/%d %T")-Se creo el directorio de novedades" >> "$GRUPO/sisop/sotp1.log"
            mkdir -p "$GRUPO/$DIRENT/ok"
            echo -e "INF-$(date +"%Y/%m/%d %T")-Se creo el directorio de novedades ok" >> "$GRUPO/sisop/sotp1.log"
            mkdir -p "$GRUPO/$DIRRECH"
            echo -e "INF-$(date +"%Y/%m/%d %T")-Se creo el directorio de rechazados" >> "$GRUPO/sisop/sotp1.log"
            mkdir -p "$GRUPO/$DIRPROC"
            echo -e "INF-$(date +"%Y/%m/%d %T")-Se creo el directorio de lotes procesados" >> "$GRUPO/sisop/sotp1.log"
            mkdir -p "$GRUPO/$DIRSAL"
            echo -e "INF-$(date +"%Y/%m/%d %T")-Se creo el directorio de liquidaciones" >> "$GRUPO/sisop/sotp1.log"

            echo -e "GRUPO-$GRUPO\nDIRCONF-$GRUPO/sisop\nDIRBIN-$GRUPO/$DIRBIN\nDIRMAE-$GRUPO/$DIRMAE\nDIRENT-$GRUPO/$DIRENT\nDIRRECH-$GRUPO/$DIRRECH\nDIRPROC-$GRUPO/$DIRPROC\nDIRSAL-$GRUPO/$DIRSAL\nINSTALACION-$(date +"%Y/%m/%d %T")-$USER" >> "$GRUPO/sisop/sotp1.conf"
            echo -e "INF-$(date +"%Y/%m/%d %T")-Se creo el archivo de configuracion y se escribieron todos sus datos" >> "$GRUPO/sisop/sotp1.log"

            cp $GRUPO/original/tablas_maestras/financiacion.txt $GRUPO/$DIRMAE
            echo -e "INF-$(date +"%Y/%m/%d %T")-Se copio el archivo financiacion.txt al directorio de tablas maestras" >> "$GRUPO/sisop/sotp1.log"
            cp $GRUPO/original/tablas_maestras/terminales.txt $GRUPO/$DIRMAE
            echo -e "INF-$(date +"%Y/%m/%d %T")-Se copio el archivo terminales.txt al directorio de tablas maestras" >> "$GRUPO/sisop/sotp1.log"
            mv "$GRUPO/original/scripts/tpcuotas.sh" "$GRUPO/$DIRBIN"
            echo -e "INF-$(date +"%Y/%m/%d %T")-Se copio el archivo tpcuotas.sh al directorio de ejecutables" >> "$GRUPO/sisop/sotp1.log"

        else
            clear
            echo SE RECHAZO LA INSTALACION, SE PEDIRAN NUEVAMENTE LOS DIRECTORIOS
            echo -e "INF-$(date +"%Y/%m/%d %T")-El usuario rechazo la instalacion. Se pediran nuevamente los directorios" >> "$GRUPO/sisop/sotp1.log"
            echo
            echo
        fi
    done
    echo
    echo INSTALACION FINALIZADA
    echo -e "INF-$(date +"%Y/%m/%d %T")-Instalacion finalizada" >> "$GRUPO/sisop/sotp1.log"
    echo
else

    GRUPO=`grep "^GRUPO.*$" sotp1.conf`
    GRUPO=${GRUPO##*-}

    DIRCONF=`grep "^DIRCONF.*$" sotp1.conf`
    DIRCONF=${DIRCONF##*-}

    DIRBIN=`grep "^DIRBIN.*$" sotp1.conf`
    DIRBIN=${DIRBIN##*-}

    DIRMAE=`grep "^DIRMAE.*$" sotp1.conf`
    DIRMAE=${DIRMAE##*-}

    DIRENT=`grep "^DIRENT.*$" sotp1.conf`
    DIRENT=${DIRENT##*-}

    DIRRECH=`grep "^DIRRECH.*$" sotp1.conf`
    DIRRECH=${DIRRECH##*-}

    DIRPROC=`grep "^DIRPROC.*$" sotp1.conf`
    DIRPROC=${DIRPROC##*-}

    DIRSAL=`grep "^DIRSAL.*$" sotp1.conf`
    DIRSAL=${DIRSAL##*-}

    necesita_reparacion
    if [ $? -eq 0 ]
    then
        clear
        echo Programa ya instalado correctamente
        echo
        echo Datos del archivo de configuracion:
        echo
        cat $DIRCONF/sotp1.conf
        echo
        echo -e "INF-$(date +"%Y/%m/%d %T")-Se le informa al usuario que el programa fue instalado correctamente y se le muestra el contenido del archivo de configuracion" >> "$GRUPO/sisop/sotp1.log"
    
    else
        es_irreparable
        if [ $? -eq 1 ]
        then
            echo es irreparable
        else
            clear
            echo -e "INF-$(date +"%Y/%m/%d %T")-Se le muestra los directorios ingresados al usuario y se pide confirmacion de reparacion" >> "$GRUPO/sisop/sotp1.log"
            echo -e 'Tipo de proceso: \t \t \t \t \t REPARACION'
            echo -e 'Directorio padre: \t \t \t \t \t '$GRUPO
            echo -e 'Ubicacion script de instalacion: \t \t \t '$GRUPO/sisop/sotp1.sh
            echo -e 'Log de la instalación: \t \t \t \t \t '$GRUPO/sisop/sotp1.log
            echo -e 'Archivo de configuración: \t \t \t \t '$GRUPO/sisop/sotp1.conf
            echo -e 'Log de la inicialización: \t \t \t \t '$GRUPO/sisop/soinit.log
            echo -e 'Log del proceso principal: \t \t \t \t '$GRUPO/sisop/tpcuotas.log
            echo -e 'Directorio de ejecutables: \t \t \t \t '$DIRBIN
            echo -e 'Directorio de tablas maestras: \t \t \t \t '$DIRMAE
            echo -e 'Directorio de novedades: \t \t \t \t '$DIRENT
            echo -e '*Directorio novedades aceptadas: \t \t \t '$DIRENT/ok
            echo -e 'Directorio de rechazados: \t \t \t \t '$DIRRECH
            echo -e 'Directorio de lotes procesados: \t \t \t '$DIRPROC
            echo -e 'Directorio de liquidaciones: \t \t \t \t '$DIRSAL

            echo Esta de acuerdo con los directorios? \(SI - NO\)
            read choice
            while [[ (! $choice = 'SI') && (! $choice = 'NO') ]]
            do
                echo Respuesta invalida. Esta de acuerdo con los directorios? \(SI - NO\)
                read choice
            done
            if [ $choice = 'NO' ]
            then
                echo Ha decidido no aceptar los directorios para la reparacion.

            else
                echo -e "INF-$(date +"%Y/%m/%d %T")-El usuario confirmo los directorios. Comenzando la reparacion" >> "$GRUPO/sisop/sotp1.log"
                if [ ! -d $DIRBIN ]
                then 
                    echo -e "INF-$(date +"%Y/%m/%d %T")-Se creo el directorio de ejecutables" >> "$GRUPO/sisop/sotp1.log"
                    mkdir -p "$DIRBIN"
                fi
        
                if [ ! -d $DIRMAE ]
                then
                    echo -e "INF-$(date +"%Y/%m/%d %T")-Se creo el directorio de tablas maestras" >> "$GRUPO/sisop/sotp1.log"
                    mkdir -p "$DIRMAE"
                fi

                if [ ! -d $DIRENT ]
                then
                    echo -e "INF-$(date +"%Y/%m/%d %T")-Se creo el directorio de novedades" >> "$GRUPO/sisop/sotp1.log"
                    mkdir -p "$DIRENT"
                fi

                if [ ! -d "$DIRENT/ok" ]
                then
                    echo -e "INF-$(date +"%Y/%m/%d %T")-Se creo el directorio de novedades ok" >> "$GRUPO/sisop/sotp1.log"
                    mkdir -p "$DIRENT/ok"
                fi

                if [ ! -d $DIRRECH ]
                then
                    echo -e "INF-$(date +"%Y/%m/%d %T")-Se creo el directorio de rechazados" >> "$GRUPO/sisop/sotp1.log"
                    mkdir -p "$DIRRECH"
                fi

                if [ ! -d $DIRPROC ]
                then
                    echo -e "INF-$(date +"%Y/%m/%d %T")-Se creo el directorio de lotes procesados" >> "$GRUPO/sisop/sotp1.log"
                    mkdir -p "$DIRPROC"
                fi

                if [ ! -d $DIRSAL ]
                then
                    echo -e "INF-$(date +"%Y/%m/%d %T")-Se creo el directorio de liquidaciones" >> "$GRUPO/sisop/sotp1.log"
                    mkdir -p "$DIRSAL"
                fi

                if [ ! -f $DIRMAE/financiacion.txt ]
                then
                    cp $GRUPO/original/tablas_maestras/financiacion.txt $DIRMAE
                    echo -e "INF-$(date +"%Y/%m/%d %T")-Se copio el archivo financiacion.txt al directorio de tablas maestras" >> "$GRUPO/sisop/sotp1.log"
                fi

                if [ ! -f $DIRMAE/terminales.txt ]
                then
                    cp $GRUPO/original/tablas_maestras/terminales.txt $DIRMAE
                    echo -e "INF-$(date +"%Y/%m/%d %T")-Se copio el archivo terminales.txt al directorio de tablas maestras" >> "$GRUPO/sisop/sotp1.log"
                fi

                if [ ! -f $DIRBIN/tpcuotas.sh ];then
                    cp "$GRUPO/original/scripts/tpcuotas.sh" "$DIRBIN"
            echo -e "INF-$(date +"%Y/%m/%d %T")-Se copio el archivo tpcuotas.sh al directorio de ejecutables" >> "$GRUPO/sisop/sotp1.log"
                fi
            fi
        fi
    fi
fi
