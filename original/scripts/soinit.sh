check_instalacion(){

    if [ -f "$BASE/sotp1.conf" ]; then
        echo "INF-$(date +"%Y/%m/%d %T")-Existe el archivo de configuración 'sotp1.conf'" >> "$BASE/soinit.log"
        return 1
    fi
    
    echo "ERR-$(date +"%Y/%m/%d %T")-No se ha instalado correctamente" >> "$BASE/soinit.log"
    echo "No se encontro el archivo de configuracion, instale el programa con el archivo sotp1.sh"
    return 0
}

check_archivos(){
    
    bbb=1
    echo "INF-$(date +"%Y/%m/%d %T")-Chequeando la existencia de los archivos" >> "$BASE/soinit.log"  

    if [ ! -f "$DIRMAE/financiacion.txt" ]; then
        echo "ERR-$(date +"%Y/%m/%d %T")-No existe la tabla maestra financiacion.txt" >> "$BASE/soinit.log"
        echo Archivo de financiacion inexistente       
        bbb=0 
    fi 
   
    if [ ! -f "$DIRMAE/terminales.txt" ]; then
        echo "ERR-$(date +"%Y/%m/%d %T")-No existe la tabla maestra terminales.txt" >> "$BASE/soinit.log"
        echo Archivo de terminales inexistente
        bbb=0
    fi
    
    if [ ! -f "$DIRBIN/tpcuotas.sh" ]; then
        echo "ERR-$(date +"%Y/%m/%d %T")-No existe el archivo tpcuotas.sh" >> "$BASE/soinit.log"
        echo "Archivo tpcuotas.sh inexistente"
        bbb=0
    fi

    if [ ! -f "$DIRBIN/arrancotp1.sh" ]; then
        echo "ERR-$(date +"%Y/%m/%d %T")-No existe el archivo arrancotp1.sh" >> "$BASE/soinit.log"
        echo "Archivo de arrancotp1.sh inexistente"
        bbb=0
    fi

    if [ ! -f "$DIRBIN/frenotp1.sh" ]; then
        echo "ERR-$(date +"%Y/%m/%d %T")-No existe el archivo frenotp1.sh" >> "$BASE/soinit.log"
        echo "Archivo frenotp1.sh inexistente"
        bbb=0
    fi
    return $bbb
}

check_directorios(){
    asd=1
    if [ ! -d $GRUPO ]; then 
        echo "ERR-$(date +"%Y/%m/%d %T")-Directorio $GRUPO inexistente" >> "$BASE/soinit.log"   
        echo Directorio grupo inexistente
        asd=0
    fi
	if [ ! -d $DIRCONF ]; then 
        echo "ERR-$(date +"%Y/%m/%d %T")-Directorio donde se encuentra el archivo de configuración (DIRCONF) inexistente" >> "$BASE/soinit.log"   
        echo Directorio $DIRCONF inexistente 
        asd=0
    fi
	if [ ! -d $DIRBIN ]; then 
        echo "ERR-$(date +"%Y/%m/%d %T")-Directorio de ejecutables (DIRBIN) inexistente" >> "$BASE/soinit.log"
        echo Directorio $DIRBIN inexistente
        asd=0
    fi
	if [ ! -d $DIRMAE ]; then 
        echo "ERR-$(date +"%Y/%m/%d %T")-Directorio de tablas maestras (DIRMAE) inexistente" >> "$BASE/soinit.log"
        echo Directorio $DIRMAE inexistente
        asd=0
    fi
	if [ ! -d $DIRENT ]; then 
        echo "ERR-$(date +"%Y/%m/%d %T")-Directorio de entrada (DIRENT) inexistente" >> "$BASE/soinit.log"
        echo Directorio $DIRENT inexistente
        asd=0
    fi
	if [ ! -d $DIRRECH ]; then 
        echo "ERR-$(date +"%Y/%m/%d %T")-Directorio de rechazados (DIRRECH) inexistente" >> "$BASE/soinit.log"
        echo Directorio $DIRRECH inexistente
        asd=0
    fi
	if [ ! -d $DIRPROC ]; then 
        echo "ERR-$(date +"%Y/%m/%d %T")-Directorio de salida inexistente" >> "$BASE/soinit.log"
        echo Directorio $DIRPROC inexistente
        asd=0
    fi
	if [ ! -d $DIRSAL ]; then 
        echo "ERR-$(date +"%Y/%m/%d %T")-Directorio de salida (DIRSAL) inexistente" >> "$BASE/soinit.log"
        echo Directorio $DIRSAL inexistente
        asd=0;
    fi
    
    return $asd
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

    check_directorios

    if [ $? -eq 1 ]; then
        check_archivos
        if [ $? -eq 1 ]; then
            echo "INF-$(date +"%Y/%m/%d %T")-Archivo de configuración correcto, instalación correcta" >> "$BASE/soinit.log"
            echo "Directorios correctos"
            echo "INF-$(date +"%Y/%m/%d %T")-Todos los archivos presentes" >> "$BASE/soinit.log"
            echo "Archivos correctos"
            echo "INF-$(date +"%Y/%m/%d %T")-Variables de ambiente definidas correctamente" >> "$BASE/soinit.log"
            echo "Variables de ambiente configuradas"
            
        
            GRUPO=$GRUPO
            DIRCONF=$DIRCONF
            DIRBIN=$DIRBIN
            DIRMAE=$DIRMAE
            DIRENT=$DIRENT
            DIRRECH=$DIRRECH
            DIRPROC=$DIRPROC
            DIRSAL=$DIRSAL

            return 1
        fi 
	fi
    echo "Para reparar el programa, navegue hacia $DIRCONF y tipee bash sotp1.sh, finalizando ejecucion..."
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
    echo Permisos dados correctamente
}

ejecutar_proceso_ppal(){
    echo "INF-$(date +"%Y/%m/%d %T")-Listo para ejecutar el proceso principal" >> "$BASE/soinit.log"
    echo Inicializando el proceso principal...
            
    ## CHEQUEAR ESTO FIJA!!!!
    . ./tpcuotas.sh &
    TP_IN_EJEC=$!
    AMBIENTE=1
    echo Proceso principal iniciado correctamente
    echo "Se dispone de '. ./arrancotp1' para reanudar el proceso ante un freno de '. ./frenotp1'"
    echo "El process id del proceso principal es $TP_IN_EJEC"
    echo "INF-$(date +"%Y/%m/%d %T")-El pid asignado al proceso principal es $TP_IN_EJEC" >> "$BASE/soinit.log"
}

BASE="../sisop"
echo "INF-$(date +"%Y/%m/%d %T")-El usuario $USER inicializó el ambiente+" >> "$BASE/soinit.log"

if [ ! -z "$TP_IN_EJEC" ]; then
    echo "WAR-$(date +"%Y/%m/%d %T")-El proceso principal ya se encuentra en ejecución" >> "$BASE/soinit.log"
    echo "El proceso principal ya esta corriendo. Tipee . ./frenotp1.sh para frenarlo y luego poder iniciarlo de nuevo"
elif [ ! -z "$AMBIENTE" ]; then
    echo "El ambiente ya se encuentra inicializado, si quiere iniciar el programa tipee . ./arrancotp1"
    echo Si lo que quiere es inicializar de nuevo el ambiente, cierre la terminal y corra este archivo en una nueva terminal
else
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
fi


