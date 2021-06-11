check_instalacion(){

    if [ -f "$BASE/sotp1.conf" ]; then
        echo "INF-$(date +"%Y/%m/%d %T")-Existe el archivo de configuración 'sotp1.conf'" >> "$BASE/soinit.log"
        return 1
    fi
    
    echo "ERR-$(date +"%Y/%m/%d %T")-No se ha instalado correctamente" >> "$BASE/soinit.log"
    echo "INF-$(date +"%Y/%m/%d %T")-Por favor reinstale el programa con el script 'sotp1.sh'" >> "$BASE/soinit.log"
    return 0
}

check_archivos(){
    
    echo "INF-$(date +"%Y/%m/%d %T")-Chequeando la existencia de las tablas maestras" >> "$BASE/soinit.log"  

    if [ ! -f "$DIRMAE/financiacion.txt" ]; then
        echo "WAR-$(date +"%Y/%m/%d %T")-No existe la tabla maestra financiacion.txt" >> "$BASE/soinit.log"
        echo "INF-$(date +"%Y/%m/%d %T")-Solución: Copiar de original/tablas_maestras el archivo financiacion.txt y pegarlo en DIRMAE" >> "$BASE/soinit.log"          
        return 0     
    elif [ ! -f "$DIRMAE/terminales.txt" ]; then
        echo "WAR-$(date +"%Y/%m/%d %T")-No existe la tabla maestra terminales.txt" >> "$BASE/soinit.log"
        echo "INF-$(date +"%Y/%m/%d %T")-Solución: Copiar de original/tablas_maestras el archivo terminales.txt y pegarlo en DIRMAE" >> "$BASE/soinit.log"
        return 0
    fi
    return 1
}


# ** Definición de variables **
definir_variables(){

    echo "INF-$(date +"%Y/%m/%d %T")-Configurando las variables" >> "$BASE/soinit.log"  

    DIRBIN=`grep "^DIRBIN.*$" $BASE/sotp1.conf`
    DIRBIN=${DIRBIN##*-}

    DIRMAE=`grep "^DIRMAE.*$" $BASE/sotp1.conf`
    DIRMAE=${DIRMAE##*-}

    DIRENT=`grep "^DIRENT.*$" $BASE/sotp1.conf`
    DIRENT=${DIRENT##*-}

    DIRRECH=`grep "^DIRRECH.*$" $BASE/sotp1.conf`
    DIRRECH=${DIRRECH##*-}

    DIRPROC=`grep "^DIRPROC.*$" $BASE/sotp1.conf`
    DIRPROC=${DIRPROC##*-}

    DIRSAL=`grep "^DIRSAL.*$" $BASE/sotp1.conf`
    DIRSAL=${DIRSAL##*-}

    GRUPO=`grep "^GRUPO.*$" $BASE/sotp1.conf`
    GRUPO=${GRUPO##*-}

    DIRCONF=`grep "^DIRCONF.*$" $BASE/sotp1.conf`
    DIRCONF=${DIRCONF##*-}

    if [ -z "$GRUPO" ]; then 
        echo "ERR-$(date +"%Y/%m/%d %T")-Directorio GRUPO inexistente" >> "$BASE/soinit.log"   
        echo "INF-$(date +"%Y/%m/%d %T")-Solución: Poner en el archivo de configuración 'GRUPO-Directorio'" >> "$BASE/soinit.log"
        return 0
	elif [ -z "$DIRCONF" ]; then 
        echo "ERR-$(date +"%Y/%m/%d %T")-Directorio donde se encuentra el archivo de configuración (DIRCONF) inexistente" >> "$BASE/soinit.log"   
        echo "INF-$(date +"%Y/%m/%d %T")-Solución: Poner en el archivo de configuración 'DIRCONF-Directorio'" >> "$BASE/soinit.log"    
        return 0
	elif [ -z "$DIRBIN" ]; then 
        echo "ERR-$(date +"%Y/%m/%d %T")-Directorio de ejecutables (DIRBIN) inexistente" >> "$BASE/soinit.log"
        echo "INF-$(date +"%Y/%m/%d %T")-Solución: Poner en el archivo de configuración 'DIRBIN-Directorio'" >> "$BASE/soinit.log"
        return 0
	elif [ -z "$DIRMAE" ]; then 
        echo "ERR-$(date +"%Y/%m/%d %T")-Directorio de tablas maestras (DIRMAE) inexistente" >> "$BASE/soinit.log"
        echo "INF-$(date +"%Y/%m/%d %T")-Solución: Poner en el archivo de configuración 'DIRMAE-Directorio'" >> "$BASE/soinit.log"
        return 0
	elif [ -z "$DIRENT" ]; then 
        echo "ERR-$(date +"%Y/%m/%d %T")-Directorio de entrada (DIRENT) inexistente" >> "$BASE/soinit.log"
        echo "INF-$(date +"%Y/%m/%d %T")-Solución: Poner en el archivo de configuración 'DIRSAL-Directorio'" >> "$BASE/soinit.log"
        return 0
	elif [ -z "$DIRRECH" ]; then 
        echo "ERR-$(date +"%Y/%m/%d %T")-Directorio de rechazados (DIRRECH) inexistente" >> "$BASE/soinit.log"
        echo "INF-$(date +"%Y/%m/%d %T")-Solución: Poner en el archivo de configuración 'DIRRECH-Directorio'" >> "$BASE/soinit.log"
        return 0
	elif [ -z "$DIRPROC" ]; then 
        echo "ERR-$(date +"%Y/%m/%d %T")-Directorio de salida inexistente" >> "$BASE/soinit.log"
        echo "INF-$(date +"%Y/%m/%d %T")-Solución: Poner en el archivo de configuración 'DIRSAL-Directorio'" >> "$BASE/soinit.log"
        return 0
	elif [ -z "$DIRSAL" ]; then 
        echo "ERR-$(date +"%Y/%m/%d %T")-Directorio de salida (DIRSAL) inexistente" >> "$BASE/soinit.log"
        echo "INF-$(date +"%Y/%m/%d %T")-Solución: Poner en el archivo de configuración 'DIRSAL-Directorio'" >> "$BASE/soinit.log"
        return 0;
	else 
        check_archivos
        if [ $? -eq 1 ]; then
            echo "INF-$(date +"%Y/%m/%d %T")-Archivo de configuración correcto, instalación correcta" >> "$BASE/soinit.log"
            echo "Directorios correctos"
            echo "INF-$(date +"%Y/%m/%d %T")-Variables de ambiente definidas correctamente" >> "$BASE/soinit.log"
            echo "Variables de ambiente configuradas"
            
        
            export GRUPO=$GRUPO
            export DIRCONF=$DIRCONF
            export DIRBIN=$DIRBIN
            export DIRMAE=$DIRMAE
            export DIRENT=$DIRENT
            export DIRRECH=$DIRRECH
            export DIRPROC=$DIRPROC
            export DIRSAL=$DIRSAL

            return 1
        fi 
	fi
    return 0    
}

permisos_arch(){

    echo "INF-$(date +"%Y/%m/%d %T")-Dando permisos a los archivos" >> "$BASE/soinit.log"  

    # ** Permisos de ejec. a los scripts **
    chmod +x tpcuotas.sh
    echo "INF-$(date +"%Y/%m/%d %T")-Permiso de ejecución para 'tpcuotas.sh' asignado" >> "$BASE/soinit.log"  
    chmod +x frenotp1.sh
    echo "INF-$(date +"%Y/%m/%d %T")-Permiso de ejecución para 'frenotp1.sh' asignado" >> "$BASE/soinit.log"  
    chmod +x arrancotp1.sh
    echo "INF-$(date +"%Y/%m/%d %T")-Permiso de ejecución para 'arrancotp1.sh' asignado" >> "$BASE/soinit.log"  

    # ** Permisos de lectura a tablas maestras **
    chmod 444 $DIRMAE/financiacion.txt
    echo "INF-$(date +"%Y/%m/%d %T")-Permiso de lectura para la tabla maestra 'financiacion.txt' asignado" >> "$BASE/soinit.log"  
    chmod 444 $DIRMAE/terminales.txt
    echo "INF-$(date +"%Y/%m/%d %T")-Permiso de lectura para la tabla maestra 'terminales.txt' asignado" >> "$BASE/soinit.log"  
    
    echo "INF-$(date +"%Y/%m/%d %T")-Fueron asignados los permisos de los archivos" >> "$BASE/soinit.log"
    echo "Permisos dados con éxito"
}

ejecutar_proceso_ppal(){
    
    TP_IN_EJEC=`ps -f | grep -c  ./tpcuotas.sh`

    if [ $TP_IN_EJEC -eq 1 ]; then
        echo "INF-$(date +"%Y/%m/%d %T")-Listo para ejecutar el proceso principal" >> "$BASE/soinit.log"
        echo "INF-$(date +"%Y/%m/%d %T")-Se tiene de 'arrancotp1' para reanudar el proceso ante un freno de 'frenotp1'" >> "$BASE/soinit.log"
        echo "Se dispone de 'arrancotp1' para reanudar el proceso ante un freno de 'frenotp1'"
        
        ## CHEQUEAR ESTO FIJA!!!!
        ./tpcuotas.sh &
    else
        echo "ERR-$(date +"%Y/%m/%d %T")-El proceso principal ya se encuentra en ejecución" >> "$BASE/soinit.log"
        echo "INF-$(date +"%Y/%m/%d %T")-Si lo que se quiere es inicializar el ambiente ejecute el comando 'frenotp1'y vuelva a ejecutar este script" >> "$BASE/soinit.log"
    fi
}

BASE="../sisop"
echo "INF-$(date +"%Y/%m/%d %T")-El usuario $USER inicializó el ambiente+" >> "$BASE/soinit.log"

## chequeo instalación
check_instalacion
if [ $? -eq 1 ]; then
    ## defino las variables
    definir_variables
    if [ $? -eq 1 ]; then
        ## le doy permisos a los archivos
        permisos_arch

        ## corro el proceso principal en bg
        ejecutar_proceso_ppal
    fi
fi


