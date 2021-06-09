#TODO: escribir en el log toda la actividad

# Hardcodear cuando se usen las variables de ambiente

#GRUPO=
#DIRCONF=
#DIRBIN=
#DIRMAE=
#DIRENT='../ENTRADATP'
#DIRRECH='../rechazos'
#DIRPROC='../DIRPROC'
#DIRSAL='../DIRSAL'

DIRBIN=`grep "^DIRBIN.*$" $(dirname $PWD)/sisop/sotp1.conf`
DIRBIN=${DIRBIN##*-}

DIRMAE=`grep "^DIRMAE.*$" $(dirname $PWD)/sisop/sotp1.conf`
DIRMAE=${DIRMAE##*-}

DIRENT=`grep "^DIRENT.*$" $(dirname $PWD)/sisop/sotp1.conf`
DIRENT=${DIRENT##*-}

DIRRECH=`grep "^DIRRECH.*$" $(dirname $PWD)/sisop/sotp1.conf`
DIRRECH=${DIRRECH##*-}

DIRPROC=`grep "^DIRPROC.*$" $(dirname $PWD)/sisop/sotp1.conf`
DIRPROC=${DIRPROC##*-}

DIRSAL=`grep "^DIRSAL.*$" $(dirname $PWD)/sisop/sotp1.conf`
DIRSAL=${DIRSAL##*-}

GRUPO=`grep "^GRUPO.*$" $(dirname $PWD)/sisop/sotp1.conf`
GRUPO=${GRUPO##*-}

DIRCONF=`grep "^DIRCONF.*$" $(dirname $PWD)/sisop/sotp1.conf`
DIRCONF=${DIRCONF##*-}


####################### DEBUGUEAR ############################

# DEBUG="Y" 			 	para debuguear
# DEBUG_CONTEXT="contexto" 	para debuguear un contexto específico
# DEBUG_CONTEXT=all			para debuguear todos los contextos

DEBUG="Y"			
DEBUG_CONTEXT="procesando_registro"	

# Sintaxis:		debug context "[mensaje]"   (con comillas)
# Ejemplo :		debug main "Se inicia el main con el ejecutable $0"

debug(){

	if [  $DEBUG != "Y" ]; then exit  
	elif [ $DEBUG_CONTEXT = "all" ]; then echo "[DEBUG - $1 ] " $2
	elif [ $DEBUG_CONTEXT = ${1:-"none"} ]; then echo "[DEBUG - $1 ] " $2
	fi 
}


################################################################


# Verificar Inicialización
verificar_instalacion(){

	if [ -z "$GRUPO" ]; then return 0
	elif [ -z "$DIRCONF" ]; then return 0
	elif [ -z "$DIRBIN" ]; then return 0
	elif [ -z "$DIRMAE" ]; then return 0
	elif [ -z "$DIRENT" ]; then return 0
	elif [ -z "$DIRRECH" ]; then return 0
	elif [ -z "$DIRPROC" ]; then return 0
	elif [ -z "$DIRSAL" ]; then return 0;
	else return 1
	fi
}

# TODO: filtrar lo que imprime ls?
chequear_novedades(){

	return $(ls -l $DIRENT | grep -v "^total [0-9]*$" | grep -c '.*' )

}

verificar_archivo(){

	debug file_validation "--- Validación de $1 ---" 

	# Verificación del nombre
	result=$(echo $1 | grep "Lote[0-9]\{5\}_[0-9]\{2\}" | sed 's/.*/OK/g' )
	if [ ${result:-"NOT_OK"} = "OK" ]
	then
		debug file_validation "El archivo [$1] tiene nombre aceptado."
	else
		debug file_validation "El archivo [$1] NO tiene nombre aceptado."
		return 0
	fi
	
	# Detección de duplicados 
	# TODO: revisar duplicados solo en DIRPROC?
	result=$(ls $DIRPROC | grep $1 | sed 's/.*/DUPLICADO/g' )
	if [ ${result:-"OK"} != "DUPLICADO" ]
	then
		debug file_validation "El archivo [$1] es unico."
	else
		debug file_validation "El archivo [$1] NO es unico."
		return 0
	fi

	# Filtro de archivos vacíos
	result=$( cat $DIRENT/$1 | grep -c -m 1 '.*' )
	if [ $result -ne 0 ]; then
		debug file_validation "El archivo [$1] es un archivo no-vacío."
	else
		debug file_validation "El archivo [$1] NO es un archivo no-vacío."
		return 0
	fi

	# Filtro de tipo de archivo 
	result=$( file $DIRENT/$1 | grep "$DIRENT/$1.*text.*" |  sed 's/.*/OK/g' )
	if [ ${result:-"NOT_OK"} = "OK" ]; then
		debug file_validation "El archivo [$1] es un archivo de texto."
	else
		debug file_validation "El archivo [$1] NO es un archivo de texto."
		return 0
	fi

	return 1
}


clasificar_novedades(){

	debug clasificar "Clasificando novedades"
	IFS=$'\n'
	for i in $(ls $DIRENT); do

		if [ $i != 'ok' ]; 
		then
			debug clasificar "$i entro al if"
			verificar_archivo $i

			if [ $? -eq 1 ]
			then
				debug clasificar "Se mueve $i a $DIRENT/ok"
                sort -o $DIRENT/$i $DIRENT/$i
				mv $DIRENT/$i ${DIRENT:-.}/ok/$i 
			else
				debug clasificar "Se mueve $i a $DIRRECH"
				mv $DIRENT/$i ${DIRRECH:-.}/$i
			fi
		fi

	done
	IFS=' '

	debug clasificar "Fin de clasificacion"

}

procesar_novedaes(){

IFS=$'\n'
for i in $(ls $DIRENT/ok); do
        reg=0001
        debug procesando_registro "Comenzando a procesar $i"

while read line; do


            #echo $line
            reg_aux=`cut -d "," -f 1 <<< $line`
            codigo=`cut -d "," -f 2 <<< $line`
            terminal=`cut -d "," -f 3 <<< $line`
            num_lot=${i:4:5}
            lookup=`grep -c "$codigo,$terminal" "$DIRMAE/terminales.txt"`
            cant_campos=`grep -o "," <<< $line | wc -l`
            empty_in=`grep -c ".*,,.*" <<< $line`
            empty_start=`grep -c "^,.*$" <<< $line`
            empty_end=`grep -c "^.*,$" <<< $line`
            if [ $cant_campos -eq 0 ]; then
                #cantidad de datos incorrecta
                if [ ! -f $DIRRECH/C$num_lot ]; then
                    mkdir -p $DIRRECH/C$num_lot
                fi
                echo -n "$i-No hay separadores-$line" >> "$DIRRECH/C$num_lot/transacciones.rech"
                continue
            elif [[ ! $cant_campos -eq 13 ]]; then
                #cantidad de datos incorrecta
                if [ ! -f $DIRRECH/C$num_lot ]; then
                    mkdir -p $DIRRECH/C$num_lot
                fi
                echo -n "$i-Cantidad de datos incorrecta-$line" >> "$DIRRECH/C$num_lot/transacciones.rech"

            elif [[ $empty_in -eq 1 ]]; then
                #datos faltantes
                if [ ! -f $DIRRECH/C$num_lot ]; then
                    mkdir -p $DIRRECH/C$num_lot
                fi
                echo -n "$i-Datos faltantes-$line" >> "$DIRRECH/C$num_lot/transacciones.rech"

            elif [[ $empty_start -eq 1 ]]; then
                #datos faltantes
                if [ ! -f $DIRRECH/C$num_lot ]; then
                    mkdir -p $DIRRECH/C$num_lot
                fi
                echo -n "$i-Datos faltantes-$line" >> "$DIRRECH/C$num_lot/transacciones.rech"

            elif [[ $empty_end -eq 1 ]]; then
                #datos faltantes
                if [ ! -f $DIRRECH/C$num_lot ]; then
                    mkdir -p $DIRRECH/C$num_lot
                fi
                echo -n "$i-Datos faltantes-$line" >> "$DIRRECH/C$num_lot/transacciones.rech"            

            elif [ $reg_aux -lt $reg ]; then
                #numero de secuencia menor al esperado
                if [ ! -f $DIRRECH/C$num_lot ]; then
                    mkdir -p $DIRRECH/C$num_lot
                fi
                echo -n "$i-Numero de secuencia menor al esperado-$line" >> "$DIRRECH/C$num_lot/transacciones.rech"

            elif [[ ! ${codigo:1:5} -eq $num_lot ]]; then
                #codigo de comercio no coincide con el nombre del archivo
                if [ ! -f $DIRRECH/C$num_lot ]; then
                    mkdir -p $DIRRECH/C$num_lot
                fi
                echo -n "$i-El codigo de comercio del registro no coincide con el nombre del archivo-$line" >> "$DIRRECH/C$num_lot/transacciones.rech"

            elif [[ $lookup -eq 0 ]]; then
                #no existe la combinacion codigo de comercio - terminal
                echo "$codigo-$terminal"
                if [ ! -f $DIRRECH/C$num_lot ]; then
                    mkdir -p $DIRRECH/C$num_lot
                fi
                echo -n "$i-No se encontro la combinacion codigo de comercio,terminal en el archivo terminales.txt-$line" >> "$DIRRECH/C$num_lot/transacciones.rech"

            else
                #se puede procesar la linea

                #creo el archivo del comercio si no existe
                if [ ! -f "$DIRSAL/$codigo.txt" ]; then
                    echo -n >> "$DIRSAL/$codigo.txt"
                fi

                if [ $reg_aux -gt $reg ]; then
                    #logueo los registros faltantes
                    IFS=$'\n'
                    for j in $(seq -f "%04g" $reg $((reg_aux+1))); do
                        faltantes="$faltantes $j"
                    done
                    IFS=' '
                    echo -e "WAR-$(date +"%Y/%m/%d %T")-Faltan los registros$faltantes en el archivo $i" >> "$DIRCONF/tpcuotas.log"
                    reg=$reg_aux
                fi
               
                # Se leen los atributos del registro
                cuotas=`cut -d "," -f 7 <<< $line`
                primeros8=`cut -d "," -f 1-8 <<< $line`
                ultimos6=`cut -d "," -f 9-14 <<< $line`
                montotransaccion_aux=`cut -d "," -f 8 <<< $line`
                montotransaccion="${montotransaccion_aux:0:10}.${montotransaccion_aux:10:2}"
                fecha=`cut -d "," -f 4 <<< $line`        
                codigorubro=`cut -d "," -f 6 <<< $line`              


                # Obtención del coeficiente y del plan
                if [ $cuotas = "001" ]; then

                    # Caso 0: una sola cuota (sin interes)
                    debug procesando_registro "Registro $reg: caso 0"

                    coef=1
                    coef="${coef:0:4}.${coef:4:4}"
                    plan='SinPlan'
                    
                else

                    # Chequeo si coincide RUBRO-CUOTAS
                    lineaf=`grep "^$codigorubro,.*,$cuotas,.*$" "$DIRMAE/financiacion.txt"`
                    chequeo=`grep -c ".*,$cuotas,.*$" "$DIRMAE/financiacion.txt"`
                    
                    if [[ ! $chequeo -eq 0 ]]; then

                        # Caso 1: coincide rubro y cuotas
                        debug procesando_registro "Registro $reg del archivo $i: caso 1"

                        coef=`cut -d "," -f 4 <<< $lineaf`
                        coef="${coef:0:4}.${coef:4:4}"
                        plan=`cut -d "," -f 2 <<< $lineaf`

                    else

                        # Chequeo si coincide CUOTAS, con rubro vacío
                        lineaf=`grep "^,.*,$cuotas,.*$" "$DIRMAE/financiacion.txt"`
                        chequeo=`grep -c ".*,$cuotas,.*$" "$DIRMAE/financiacion.txt"`
                        
                        if [[ ! $chequeo -eq 0 ]]; then

                            # Caso 2: no coincide rubro y pero sí cuotas
                            debug procesando_registro "Registro $reg del archivo $i: caso 2"

                            coef=`cut -d "," -f 4 <<< $lineaf`
                            coef="${coef:0:4}.${coef:4:4}"
                            plan='Entidad'
                        else

                            # Caso 3: no coincide rubro y ni cuotas (sin interes)
                            debug procesando_registro "Registro $reg del archivo $i: caso 3"
                            coef=1
                            coef="${coef:0:4}.${coef:4:4}"
                            plan='SinPlan'
                        fi
                    fi   	
                fi

                # Calculos 

                debug procesando_registro "coef: $coef"
                debug procesando_registro  "monto transaccion: $montotransaccion"
                montotransacciontotal=`echo "scale=2;$montotransaccion*$coef" | bc -l`
                debug procesando_registro  "monto total OK: $montotransacciontotal"
                costofinanciacion=`echo "scale=2;$montotransacciontotal-$montotransaccion" | bc -l`
                debug procesando_registro  "costo financiacion: $costofinanciacion"
                montocuota=`echo "scale=2;$montotransacciontotal/$cuotas" | bc -l`
                debug procesando_registro  "monto cuota 1: $montocuota"
                montocuota=`echo "scale=2;$montocuota * 100" | bc -l`
                debug procesando_registro  "monto cuota 2: $montocuota"
                montocuota=`cut -d "." -f 1 <<< $montocuota`
                debug procesando_registro  "monto cuota 3: $montocuota"
                printf -v montocuota "%012d" $montocuota
                debug procesando_registro  "monto cuota 4: $montocuota"

                # Grabado en registro
                IFS=$'\n'
                for idx in $(seq -f "%03g" 1 $cuotas); do
                    echo -e "$i,$primeros8,$costofinanciacion,$montotransacciontotal,$idx,$montocuota,$plan,$(date -d "$fecha+$((idx-1)) month" +%Y%m%d),$ultimos6" >> "$DIRSAL/$codigo.txt"     
                done
                IFS=' ' 
            fi
            reg=$((reg+1))
            #echo $reg_aux
        done < $DIRENT/ok/$i

    debug procesar_novedaes "Se termina de procesar el registro $i. Se mueve a $DIRPROC"
    mv "$DIRENT/ok/$i" "$DIRPROC/$i"

done

}


verificar_instalacion
if [ $? -eq 0 ]
then
	echo "No se ha inicializado correctamente el ambiente."
	echo "Por favor, ejecute <inittp.sh>"
	exit
fi


a=5
# Main Loop 
while [[ 1 ]]; do
	
	chequear_novedades
	if [ $? -gt 1 ]
	then 
		
		debug mainloop "Detected new files"

		clasificar_novedades
		procesar_novedaes

	else 
		debug mainloop "Skipped the process block"
	fi


	sleep 2

	## Corte de prueba
	#if [ $a -gt 0 ]
	#then 
	#	a=`expr $a - 1`
	#	echo $a'/2'
	#else
	#	exit
	#fi

done







