# Guía de utilización del programa

## 1. Descarga
  - Del repositorio descargar los archivos en formato .zip
  - Moverlos a la carpeta donde se quiera guardar
  - Descomprimir el .zip que se descargó en esa misma carpeta
  
## 2. Instalación
  Una vez que se tienen los archivos correspondientes y se encuentra en la carpeta donde estan dichos archivos, 
  se pasa a la ejecución del script de instalación **sotp1.sh**, que se encuentra en la carpeta **sisop**. Para
  la ejecución del mismo se debe hacer:

    a) Abrir la terminal
    b) Ir hasta la carpeta donde esta el script de instalación: 
         cd $GRUPO/sisop
    c) Ejecutar el script de instalación:
         ./sotp1.sh
         
  Al ejecutar el script se tendrán que definir los directorios donde se quieran guardar ciertos archivos, por eso
  en cada caso se muestra un directorio por default y luego se podrá escribir el directorio que se requiera, tener
  en cuenta que las carpetas que vienen al descargarse el programa no se pueden seleccionar como tal. Para dejar el
  directorio que ponemos por default, basta con darle a "ENTER".
  Luego de definir todos los directorios podes confirmar o no la instalación, si se le da a la opción de no confirmar
  se vuelven a pedir todos los directorios para luego volver a confirmar o no la instalación.
  
### 2.1 Directorios definidos
  Si se quieren ver todos los directorios definidos se deberá hacer lo siguiente:
  
      cat  sotp1.conf
      
  Y mostrará en cada línea cada directorio definido asociado.
  
### 2.2 Log de instalación
  También se cuenta con un archivo de log, donde cada línea refleja lo que va sucediendo en el flujo de la instalación,
  se puede encontrar desde información, warnings y errores. Para ello como se encuentra en la terminal se está en la carpeta 
  "sisop" se debe hacer:
  
      more sotp1.log
      
   Para ir leyendo este archivo se debe dar a "ENTER" para ir linea por linea o darle a "ESPACIO" si se quiere avanzar de a más
   líneas.
   
## 3. Reparación

## 4. Ejecución
### 4.1 Inicialización
  Para la ejecución del programa, primero lo que se necesita es que el ambiente quede bien definido y para que esto
  suceda se deberá ejecutar lo siguiente
  
      a) Como se está en el directorio $GRUPO/sisop, se debe volver al inicio
          cd ..
      b) Luego ir hasta la carpeta donde se encuentran todos los ejecutables (carpeta bin)
          cd bin
      c) Ejecutar el script soinit.sh
          ./soinit.sh
      
  Lo que hace este script justamente es definir correctamente el ambiente, y si hay algun error o algun archivo que falte, lo
  avisará y además con un cierta ayuda para saber como solucionar el problema. Si no hay ningun problema que haga que el
  programa principal no pueda ejecutarse, se lanza el programa y queda funcionando en segundo plano.
  
#### 4.1.1 Log de inicialización
  Cada línea que antes mencionamos aparece en un archivo de log. Para ello como se encuentra en la terminal se está en la carpeta 
  "bin" se debe hacer:
  
      a) Volver a la carpeta inicial
          cd ..
      b) Ir a la carpeta de sisop
          cd sisop
      c) Ver el archivo de log de inicialización
          more soinit.log
      
   La forma de navegar es igual a la explicada para el archivo de log de instalación.
   
### 4.2 Programa principal
  Una vez que se empieza a correr el programa principal (que se realiza en background), el mismo lo que hace es recibir archivos .txt
  con un cierto formato de nombre que contiene por cada linea una transacción donde cada transacción tiene campos separados por comas ",".
  Estos archivos el programa los leerá por la carpeta seleccionada como el directorio de entrada (DIRENT), los procesará y luego enviará 
  al directorio de salida (DIRSAL) o al directorio de rechazados (DIRRECH) dependiendo del caso.
  Tener en cuenta que si no se cumple el nombre del archivo, campos de las transacciones vacios o faltantes se considerá un error, y si
  sucede eso, se mostrar en un archivo de log.
  
#### 4.2.1 Log de ejecución del programa principal
  Sucede lo mismo que pasaba para los otros archivos de log, este mostrará lo que va sucediendo en el flujo del programa. Por ende, 
  para ver esto, estando en la terminal en la carpeta "sisop" se debe hacer lo siguiente:
  
          more tpcuotas.log
      
  Y misma forma de navegación que mencionamos antes.
