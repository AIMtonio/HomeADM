#/bin/bash
source ./funciones.sh
# declaracion de constantes
CENTERO_CERO=0
CSI_MAYUS="S"
CSI_MINS="s"
CNO_MAYUS="N"
CNO_MINS="n"

# se verifica si no ha introducido ningun parametro
if [ $# -eq 0 ]; then
	PARAMETROS_PERMITIDOS
	SALIR
fi

# Se leen los parametros y se asigna a las variables correspondientes
while [ $# -gt 0 ]; do
  case $1 in
		-f) shift
			archivo_stores=$1;;
		-d) shift
			Destino=$1;;
		-h)PARAMETROS_PERMITIDOS
			SALIR;;
  esac
  shift
done

# se compara que $archivo_stores si =  vacio 
if [ "$archivo_stores" = "$CADENA_VACIA" ]; then
	echo -e "NO SE ESPECIFICO EL ARCHIVO QUE CONTIENE LOS NOMBRES DE LOS STORES A PROCESAR \n"
	PARAMETROS_PERMITIDOS
	SALIR
fi

if [ "$Destino" = "$CADENA_VACIA" ]; then
	echo -e "NO SE ESPECIFICO LA RUTA DONDE SE DEJARA EL SCRIPT GENERADO \n"
	PARAMETROS_PERMITIDOS
	SALIR
fi
#Obtenemos el Directorio Destino
CarpetaDestino=$( OBTENER_DIRECTORIO $Destino )
archivoDestino=$( OBTENER_NOMBREARCHIVO $Destino )

# se compara que el archivo destino no sea vacio
if [ "$archivoDestino" = "$CADENA_VACIA" ]; then
	echo -e "NO SE ESPECIFICO EL NOMBRE DEL ARCHIVO DESTINO \n"
	PARAMETROS_PERMITIDOS
	SALIR
fi



#verificamos si el archivo introducido por parametro existe
VERIFICA_ARCHIVO $archivo_stores
VERIFICA_DIRECTORIO $CarpetaDestino
#Se normaliza el directorio destino, esto solo verifica si al final ya incluye "/" en caso conntrario se lo agrega
CarpetaDestino=$( NORMALIZA_DIRECTORIO $CarpetaDestino )
archivoDestino=$( echo $CarpetaDestino"$archivoDestino" )



# Cargamos en un array los stores que jugaran
#para la creacion del script de instalacion
OLDIFS=$IFS
IFS=$'\n'
STORES=($(cat $archivo_stores))
IFS=$OLDIFS

#Se obtiene el DIRECTORIO origen, apartir del archivo origen($archivo_stores) en el cual se encuentran las definiciones de los sqls a procesar
DIR=$( OBTENER_DIRECTORIO $archivo_stores )

#Se evalua la longitude del array
if [ "${#STORES[@]}" = "$CENTERO_CERO" ]; then
	echo -e "\tEl archivo $archivo_stores esta vacio \n"
	SALIR
fi
# Se hace una inspeccion de todos los archivos sql que se procesaran
for Store in ${STORES[@]}; do     
      archivoSql="$DIR$Store"
      # se verifica que el archivo sql exista
      VERIFICA_ARCHIVO $archivoSql      
done 

#Se verifica si el archivo destino existe y se pregunta si desea sobrerscribir
if [ "$(EXISTE_ARCHIVO $archivoDestino)" = "TRUE" ]; then
		while [ "$respuestaSobrescribir" != "$CSI_MAYUS" -a "$respuestaSobrescribir" != "$CSI_MINS" -a "$respuestaSobrescribir" != "$CNO_MAYUS" -a "$respuestaSobrescribir" != "$CNO_MINS" ]; do
		
			echo -e "El archivo $archivoDestino ya existe, desea Soberescribirlo? (S/n)"
			read respuestaSobrescribir
		done
		
		#se evalua la respuesta del usuario
		if [ "$respuestaSobrescribir" = "$CNO_MAYUS" -o	 "$respuestaSobrescribir" = "$CNO_MINS" ]; then
			echo "Se aborta la ejecución"
			SALIR
		fi
		
		`rm $archivoDestino`
	
fi
	



# Se Crea el script
for Store in ${STORES[@]}; do     
      archivoSql="$DIR$Store"
      ` cat $archivoSql >> $archivoDestino `
      echo -e "\n\n" >> $archivoDestino
      # se verifica que el archivo sql exista
    
done 

echo -e "\n\t Resumen:"

echo -e "\n\t Carpeta de destino: "$CarpetaDestino
echo -e "\t Total de archivos procesados: "${#STORES[@]}
echo -e "\t archivo generado: "$archivoDestino"\n"



#NOTAS Un ejemplo práctico y error común puede producirse al querer guardar nombres de ficheros en un array: 
#$ ficheros=$(ls) # MAL. Se guarda en una variable una lista de ficheros, pero no un array
#$ ficheros=($(ls)) # Todavía MAL. Si hay ficheros con espacios en sus nombres dará problemas.
#$ files=(*)      # Bien!. El asterisco * permite guardar cada nombre de fichero en una posición del array, aunque tenga espacios.
