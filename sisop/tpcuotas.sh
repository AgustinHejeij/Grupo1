#TODO: escribir en el log toda la actividad

# Hardcodear cuando se usen las variables de ambiente

#GRUPO=
#DIRCONF=
#DIRBIN=
#DIRMAE=
DIRENT='../ENTRADATP'
DIRRECH='../rechazos'
DIRPROC='../DIRPROC'
DIRSAL='../DIRSAL'


####################### DEBUGUEAR ############################

# DEBUG="Y" 			 	para debuguear
# DEBUG_CONTEXT="contexto" 	para debuguear un contexto específico
# DEBUG_CONTEXT=all			para debuguear todos los contextos

DEBUG="Y"			
DEBUG_CONTEXT="all"	

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


	## Aca va lo groso del tp xd

	debug procces_file "Se estan procesando novedades"
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
	if [ $a -gt 0 ]
	then 
		a=`expr $a - 1`
		echo $a'/2'
	else
		exit
	fi

done







