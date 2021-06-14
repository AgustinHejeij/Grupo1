#TODO: escribir en el log toda la actividad

####################### DEBUGUEAR ############################

# DEBUG="Y" 			 	para debuguear
# DEBUG_CONTEXT="contexto" 	para debuguear un contexto específico
# DEBUG_CONTEXT=all			para debuguear todos los contextos

DEBUG="Y"			
#DEBUG_CONTEXT="all"	

# Sintaxis:		debug context "[mensaje]"   (con comillas)
# Ejemplo :		debug main "Se inicia el main con el ejecutable $0"

debug(){

	if [  $DEBUG != "Y" ]; then exit  
	elif [ $DEBUG_CONTEXT = "all" ]; then echo "[DEBUG - $1 ] " $2
	elif [ $DEBUG_CONTEXT = ${1:-"none"} ]; then echo "[DEBUG - $1 ] " $2
	fi 
}


################################################################

# TODO: filtrar lo que imprime ls?
chequear_novedades(){

	return $(ls -l $DIRENT | grep -v "^total [0-9]*$" | grep -c '.*' )

}

verificar_archivo(){

	#debug file_validation "--- Validación de $1 ---" 
    arch=$1
	# Verificación del nombre
	result=$(echo $1 | grep "Lote[0-9]\{5\}_[0-9]\{2\}" | sed 's/.*/OK/g' )
	if [ ! ${result:-"NOT_OK"} = "OK" ]; then
        echo -e "WAR-$(date +"%Y/%m/%d %T")-Se rechazo el archivo $1 por tener un nombre invalido" >> "$DIRCONF/tpcuotas.log"
		return 0
	fi
	
    # Detección de duplicados 
    result=$(ls $DIRPROC | grep $1 | sed 's/.*/DUPLICADO/g' )
    if [ ! ${result:-"OK"} != "DUPLICADO" ]
    then
        echo -e "WAR-$(date +"%Y/%m/%d %T")-Se rechazo el archivo $1 por ser duplicado" >> "$DIRCONF/tpcuotas.log"
        return 0
    fi

    result=$(ls $DIRENT/ok | grep $1 | sed 's/.*/DUPLICADO/g' )
    if [ ! ${result:-"OK"} != "DUPLICADO" ]
    then
        echo -e "WAR-$(date +"%Y/%m/%d %T")-Se rechazo el archivo $1 por ser duplicado" >> "$DIRCONF/tpcuotas.log"
        return 0
    fi

	# Filtro de archivos vacíos
	result=$( cat $DIRENT/$1 | grep -c -m 1 '.*' )
    if [ ! $result -ne 0 ]; then
		echo -e "WAR-$(date +"%Y/%m/%d %T")-Se rechazo el archivo $1 por estar vacio" >> "$DIRCONF/tpcuotas.log"
        return 0
	fi

	# Filtro de tipo de archivo 
	result=$( file $DIRENT/$1 | grep "$DIRENT/$1.*text.*" | sed 's/.*/OK/g' )
	if [ ! ${result:-"NOT_OK"} = "OK" ]; then
		echo -e "WAR-$(date +"%Y/%m/%d %T")-Se rechazo el archivo $1 por no ser un archivo de texto" >> "$DIRCONF/tpcuotas.log"
        return 0
	fi

    result=${arch:4:5}
    result=`grep -c "$result,.*" "$DIRMAE/terminales.txt"`
    if [ $result -eq 0 ]; then
        echo -e "WAR-$(date +"%Y/%m/%d %T")-Se rechazo el archivo $1 porque no existe el codigo de comercio" >> "$DIRCONF/tpcuotas.log"
        return 0
    fi

	return 1
}


mover_archivo(){
    NOMBRE=$1
    ORIGEN=$2
    DESTINO=$3
    nro=$( ls $DESTINO | grep -c "$1.*" )

    if [ $nro -eq 0 ]; then
        mv "$ORIGEN/$NOMBRE" "$DESTINO/$NOMBRE"
        return
    fi

    mv "$ORIGEN/$NOMBRE" "$DESTINO/$NOMBRE - $nro"
    return 

}


clasificar_novedades(){

	IFS=$'\n'
	for i in $(ls $DIRENT); do

		if [ $i != 'ok' ]; 
		then
			verificar_archivo $i

			if [ $? -eq 1 ]
			then
				echo -e "INF-$(date +"%Y/%m/%d %T")-Se acepto el archivo $i. Se mueve a $DIRENT/ok" >> "$DIRCONF/tpcuotas.log"
                sort -o $DIRENT/$i $DIRENT/$i
				mover_archivo $i $DIRENT $DIRENT/ok 
			else
				echo -e "INF-$(date +"%Y/%m/%d %T")-Se mueve $i a $DIRRECH" >> "$DIRCONF/tpcuotas.log"
				mover_archivo $i $DIRENT $DIRRECH
			fi
		fi

	done
	IFS=' '

}

procesar_novedaes(){

IFS=$'\n'
for i in $(ls $DIRENT/ok); do

        reg=0001
        rechazados=0
        leidos=0
        grabadas=0

        while read line; do

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
                let rechazados=$rechazados+1
   
            elif [[ $empty_in -eq 1 ]]; then
                #datos faltantes
                if [ ! -f $DIRRECH/C$num_lot ]; then
                    mkdir -p $DIRRECH/C$num_lot
                fi
                echo -n "$i-Datos faltantes-$line" >> "$DIRRECH/C$num_lot/transacciones.rech"
                let rechazados=$rechazados+1

            elif [[ $empty_start -eq 1 ]]; then
                #datos faltantes
                if [ ! -f $DIRRECH/C$num_lot ]; then
                    mkdir -p $DIRRECH/C$num_lot
                fi
                echo -n "$i-Datos faltantes-$line" >> "$DIRRECH/C$num_lot/transacciones.rech"
                let rechazados=$rechazados+1

            elif [[ $empty_end -eq 1 ]]; then
                #datos faltantes
                if [ ! -f $DIRRECH/C$num_lot ]; then
                    mkdir -p $DIRRECH/C$num_lot
                fi
                echo -n "$i-Datos faltantes-$line" >> "$DIRRECH/C$num_lot/transacciones.rech"  
                let rechazados=$rechazados+1          

            elif [ $reg_aux -lt $reg ]; then
                #numero de secuencia menor al esperado
                if [ ! -f $DIRRECH/C$num_lot ]; then
                    mkdir -p $DIRRECH/C$num_lot
                fi
                echo -n "$i-Numero de secuencia menor al esperado-$line" >> "$DIRRECH/C$num_lot/transacciones.rech"
                let rechazados=$rechazados+1

            elif [[ ! ${codigo:1:5} -eq $num_lot ]]; then
                #codigo de comercio no coincide con el nombre del archivo
                if [ ! -f $DIRRECH/C$num_lot ]; then
                    mkdir -p $DIRRECH/C$num_lot
                fi
                echo -n "$i-El codigo de comercio del registro no coincide con el nombre del archivo-$line" >> "$DIRRECH/C$num_lot/transacciones.rech"
                let rechazados=$rechazados+1

            elif [[ $lookup -eq 0 ]]; then
                #no existe la combinacion codigo de comercio - terminal
                echo "$codigo-$terminal"
                if [ ! -f $DIRRECH/C$num_lot ]; then
                    mkdir -p $DIRRECH/C$num_lot
                fi
                echo -n "$i-No se encontro la combinacion codigo de comercio,terminal en el archivo terminales.txt-$line" >> "$DIRRECH/C$num_lot/transacciones.rech"
                let rechazados=$rechazados+1

            else
                #se puede procesar la linea

                #creo el archivo del comercio si no existe
                if [ ! -f "$DIRSAL/$codigo.txt" ]; then
                    echo -n >> "$DIRSAL/$codigo.txt"
                fi

                if [ $reg_aux -gt $reg ]; then
                    #logueo los registros faltantes
                    reg2=`echo "$reg_aux-1" | bc -l`
                    IFS=$'\n'
                    faltantes=""
                    for j in $(seq -f "%04g" $reg $reg2); do
                        faltantes="$faltantes $j"
                    done
                    IFS=' '
                    echo -e "WAR-$(date +"%Y/%m/%d %T")-Faltan lo(s) registro(s)$faltantes en el archivo $i" >> "$DIRCONF/tpcuotas.log"
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

                    coef=1
                    plan='SinPlan'
                    
                else

                    # Chequeo si coincide RUBRO-CUOTAS
                    lineaf=`grep "^$codigorubro,.*,$cuotas,.*$" "$DIRMAE/financiacion.txt"`
                    chequeo=`grep -c "^$codigorubro,.*,$cuotas,.*$" "$DIRMAE/financiacion.txt"`
                    monto_int=`echo "$montotransaccion_aux+0" | bc -l`
                    
                    if [[ ! $chequeo -eq 0 ]]; then

                        # Caso 1: coincide rubro y cuotas                                      
                        tope=`cut -d "," -f 5 <<< $lineaf`
                        tope_int=`echo "$tope+0" | bc -l`
                        if [[ ! $monto_int -gt $tope_int ]]; then
                            coef=`cut -d "," -f 4 <<< $lineaf`
                            coef="${coef:0:4}.${coef:4:4}"
                            plan=`cut -d "," -f 2 <<< $lineaf`
                        else
                            # Chequeo si coincide CUOTAS, con rubro vacío
                            lineaf=`grep "^,.*,$cuotas,.*$" "$DIRMAE/financiacion.txt"`
                            chequeo=`grep -c "^,.*,$cuotas,.*$" "$DIRMAE/financiacion.txt"`
                            
                            if [[ ! $chequeo -eq 0 ]]; then
                                nuevo_tope=`cut -d "," -f 5 <<< $lineaf`
                                nuevo_tope_int=`echo "$nuevo_tope+0" | bc -l`
                                if [[ ! $monto_int -gt $nuevo_tope_int ]]; then
                                    # Caso 2: no coincide rubro, pero sí cuotas, monto menor tope
                                    coef=`cut -d "," -f 4 <<< $lineaf`
                                    coef="${coef:0:4}.${coef:4:4}"
                                    plan='Entidad'

                                else
                                    coef=1
                                    plan="SinPlan"
                                fi
                            fi
                        fi

                    else
                        # Chequeo si coincide CUOTAS, con rubro vacío
                        lineaf=`grep "^,.*,$cuotas,.*$" "$DIRMAE/financiacion.txt"`
                        chequeo=`grep -c "^,.*,$cuotas,.*$" "$DIRMAE/financiacion.txt"`
                        if [[ ! $chequeo -eq 0 ]]; then
                            nuevo_tope=`cut -d "," -f 5 <<< $lineaf`
                            nuevo_tope_int=`echo "$nuevo_tope+0" | bc -l`
                            if [[ ! $monto_int -gt $nuevo_tope_int ]]; then
                                # Caso 2: no coincide rubro, pero sí cuotas, monto menor tope
                                coef=`cut -d "," -f 4 <<< $lineaf`
                                coef="${coef:0:4}.${coef:4:4}"
                                plan='Entidad'
    
                            else
                                coef=1
                                plan='SinPlan'
                            fi
                           
                        else
                            # Caso 3: no coincide rubro y ni cuotas (sin interes)
                            coef=1
                            plan='SinPlan'
                        fi
                    fi      
                fi

                # Calculos 

                montotransacciontotal=`echo "scale=2;$montotransaccion*$coef" | bc -l`
                costofinanciacion=`echo "scale=2;$montotransacciontotal-$montotransaccion" | bc -l`

                montocuota=`echo "scale=2;$montotransacciontotal/$cuotas" | bc -l`
                montocuota=`echo "scale=2;$montocuota * 100" | bc -l`
                montocuota=`cut -d "." -f 1 <<< $montocuota`
                printf -v montocuota "%012d" $montocuota
                montotransacciontotal=`echo "scale=2;$montotransacciontotal * 100" | bc -l`
                montotransacciontotal=`cut -d "." -f 1 <<< $montotransacciontotal`
                printf -v montotransacciontotal "%012d" $montotransacciontotal
                costofinanciacion=`echo "scale=2;$costofinanciacion * 100" | bc -l`
                costofinanciacion=`cut -d "." -f 1 <<< $costofinanciacion`
                printf -v costofinanciacion "%012d" $costofinanciacion

                # Grabado en registro
                IFS=$'\n'
                for idx in $(seq -f "%03g" 1 $cuotas); do
                    num_cuota=`echo "$idx - 1" | bc -l`
                    echo -e "$i,$primeros8,$costofinanciacion,$montotransacciontotal,$idx,$montocuota,$plan,$(date -d "$fecha+$num_cuota month" +%Y%m%d),$ultimos6" >> "$DIRSAL/$codigo.txt"  
                    let grabadas=$grabadas+1
                done
                IFS=' ' 
            fi
            reg=`echo "$reg + 1" | bc -l`
            let leidos=$leidos+1

        done < $DIRENT/ok/$i

    echo -e "INF-$(date +"%Y/%m/%d %T")-Se termino de procesar el archivo $i, $leidos registros leidos, $rechazados registros rechazados, $grabadas registros grabados" >> "$DIRCONF/tpcuotas.log"
    mv "$DIRENT/ok/$i" "$DIRPROC/$i"
    echo -e "INF-$(date +"%Y/%m/%d %T")-Se movio el archivo $i a $DIRPROC correctamente" >> "$DIRCONF/tpcuotas.log"

done

}

ciclo=1
# Main Loop 
while [[ 1 ]]; do
	        
    echo -e "INF-$(date +"%Y/%m/%d %T")-Voy por el ciclo $ciclo" >> "$DIRCONF/tpcuotas.log"
    chequear_novedades
    if [ $? -gt 1 ]; then 
        clasificar_novedades
		procesar_novedaes
	fi
    let ciclo=$ciclo+1
	sleep 60

done
