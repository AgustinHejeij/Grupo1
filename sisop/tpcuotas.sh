

# Verificar Inicialización

DIRENT='../ENTRADATP'

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

	return $(ls -l $DIRENT | grep -v "^total [0-9]*$" | grep '.*' -c )

}

clasificar_novedades(){

	echo "Clasificando novedades"
	IFS=$'\n'
	for i in $(ls $DIRENT); do
		echo "File: [ $i ]"

	done
	IFS=' '

}

procesar_novedaes(){
	echo se estan procesando novedades
}


verificar_instalacion
if [ $? -eq 0 ]
then
	echo "No se ha inicializado correctamente el ambiente."
	echo "Por favor, ejecute <inittp.sh>"
	#TODO: escribir en el log
	#exit
fi


a=5
# Main Loop 
while [[ 1 ]]; do
	
	## Buscar novedades
	chequear_novedades
	if [ $? -gt 0 ]
	then 
		
		## Clasificar novedades en distintas carpetas
		clasificar_novedades

		## Procesar novedaes aceptadas
		procesar_novedaes
	else 
		echo "Skipped the process block"
	fi

	## Dormir 2 segundos hasta la proxima iteración
	sleep 2

	## Corte de prueba
	if [ $a -gt 0 ]
	then 
		a=`expr $a - 1`
		echo $a
	else
		exit
	fi

done







