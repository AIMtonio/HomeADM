#/bin/bash

# declaracion de constantes
CADENA_VACIA=""

function SALIR(){
	echo "---------------------------------------------------------------------------------------------------"
	exit
}

#Autor: mreyes
#Funcion Elimina los spacios del principio y del final
#parametros: Cualquier string
#Ejemplo: Variable=$( TRIM $Variable)
function TRIM(){
    Value=$1
    Value=${Value// }
	echo "$Value"
}

function PARAMETROS_PERMITIDOS(){

echo -e " \t Los parametros permitdos son:"
echo -e ' \t-f)\t para indicar la ruta y nombre del archivo donde estan los stores que se procesaran'
echo -e ' \t-d)\t Para indicar el directorio donde se creara el script de instalacion'
echo -e ' \t-h)\t muestra la ayuda \n'
echo -e ' \t Ejemplo: \n \t ./GeneraScriptInstalacion.sh -f DefinicionesSegundaFase.txt -d /home/mareyes/ScriptInstalacion.sql'
}

#Autor: 		mreyes
#Descripcion:	Verifica si un el archivo pasado por parametro, existe, 
#				si existe manda un msg, si no tambien manda un msg
#Parametros:	Ruta del archivo a verificar
#Ejemplo:		VERIFICA_ARCHIVO /home/mareyes/miguel.txt
function VERIFICA_ARCHIVO(){
	if [ "$(EXISTE_ARCHIVO $1)" = "TRUE" ]; then
		echo -e "Archivo $1 encontrado."
	else
		echo -e "Archivo $1 no existe"
		SALIR
	fi
}

#Autor: 		mreyes
#Descripcion:	Verifica si un directorio pasado por parametro, existe, 
#				si existe manda un msg, si no tambien manda un msg
#Parametros:	Ruta del directorio a verificar
#Ejemplo:		VERIFICA_DIRECTORIO /home/mareyes
function VERIFICA_DIRECTORIO(){
	if [ "$( EXISTE_DIRECTORIO $1 )" == "TRUE" ]; then
		echo ""
	else
		echo -e "El directorio $1 no existe "
		SALIR
	fi
}

#Autor: 		mreyes
#Descripcion:	devuelve TRUE si el archivo pasado por parametro existe
#Parametros:	Ruta del archivo a verificar
#Ejemplo:		EXISTE_ARCHIVO /home/mareyes/MARS:txt
function EXISTE_ARCHIVO(){
	if [ -f $1 ]; then
		echo "TRUE"
	else
		echo "FALSE"
	fi
}

#Autor: 		mreyes
#Descripcion:	devuelve TRUE si la ruta directorio pasado por parametro existe
#Parametros:	Ruta del directorio a verificar
#Ejemplo:		EXISTE_ARCHIVO /home/mareyes/
function EXISTE_DIRECTORIO(){
	if [ -d $1 ]; then
		echo "TRUE"
	else
		echo "FALSE"
	fi
}

#Autor: 		mreyes
#Descripcion:	Recibe como parametro un string(Ruta algun directorio), se verifica
#				Si el ultimo caracter es un "/", si no lo es, se le concatena
#Parametros:	Ruta del directorio a normalizar
#Ejemplo:		CarpetaDestino=$( NORMALIZA_DIRECTORIO /home/mareyes )
function NORMALIZA_DIRECTORIO(){
directorio=$1
LargoRuta="${#directorio}"
ultimoCaracter="${directorio:$LargoRuta - 1:$LargoRuta}"
if [ "$ultimoCaracter" = "/" ]; then
	echo $directorio
else
	echo "$directorio/"
fi
}

#Autor: 		mreyes
#Descripcion:	Recibe como parametro un string(Ruta algun archivo), del Cual
#				se extrae solo el directorio
#Parametros:	Ruta del archivo , del cual se desea extraer el directorio
#Ejemplo:		CarpetaDestino=$( OBTENER_DIRECTORIO /home/mareyes/MARS.txt ) 
#				el resultado seria, en la varibale CarpetaDestino se guardaria "/home/mareyes/"
#Ejemplo2:		CarpetaDestino=$( OBTENER_DIRECTORIO /home/mareyes/ ) 
#				el resultado seria, en la varibale CarpetaDestino se guardaria "/home/mareyes/"
#Ejemplo2:		CarpetaDestino=$( OBTENER_DIRECTORIO MARS.txt ) 
#				el resultado seria, en la varibale CarpetaDestino se guardaria "./"
function OBTENER_DIRECTORIO(){	
	# el nombre de archivo y extensión (si existen) y ruta hasta los mismos
	for RutaCompleta in $1
	do
		# Comenzamos extrayendo la parte derecha desde el ultimo caracter "/", es decir, el archivo
		NombreArchivo="${RutaCompleta##*/}"
		# Longitud de la ruta es el total de caracteres menos el largo del nombre de archivo
		LargoRuta="${#RutaCompleta} - ${#NombreArchivo}"
		# Extraermos la ruta desde el caracter 0 hasta el caracter final de largo de ruta
		RutaSola="${RutaCompleta:0:$LargoRuta}"
		# Lo siguiente es extraer nombre de archivo
		NombreSolo="${NombreArchivo%.[^.]*}"
		# Extension se obtiene eliminando del nombre completo el nombre mas el punto
		Extension="${NombreArchivo:${#NombreSolo} + 1}"
		# Las 2 lineas anteriores fallan si no hay extension por lo que es necesario comprobar que no
		# se de el caso de que haya extension pero no nombre ya que en ese caso la ext seria el nombre
		if [[ -z "$NombreSolo" && -n "$Extension" ]]; then
			NombreSolo=".$Extension"
			Extension=""
		fi
	done
	if [ "$RutaSola" = "" ]; then
		RutaSola=$( echo "./" )
	fi

	# Este es el resultado del script
	#echo
	#echo "Este es el resultado del script:"
	#echo
	#echo La ruta completa es:
	#echo $RutaCompleta
	#echo
	#echo "Ruta.........: \"$RutaSola\""
	#echo "Nombre.......: \"$NombreSolo\""
	#echo "Extension....: \"$Extension\""
	#echo
	echo $RutaSola
}


#Autor: 		mreyes
#Descripcion:	Recibe como parametro un string(Ruta algun archivo), del Cual
#				se extrae solo el nombre del archivo
#Parametros:	Ruta del archivo , del cual se desea extraer el nombre del archivo
#Ejemplo:		ArchivoFuente=$( OBTENER_DIRECTORIO /home/mareyes/MARS.txt ) 
#				el resultado seria, en la varibale ArchivoFuente se guardaria "MARS.txt"
#Ejemplo2:		ArchivoFuente=$( OBTENER_DIRECTORIO /home/mareyes/MARS ) 
#				el resultado seria, en la varibale ArchivoFuente se guardaria "MARS"
#Ejemplo2:		ArchivoFuente=$( OBTENER_DIRECTORIO /home/mareyes/.MARS.txt ) 
#				el resultado seria, en la varibale ArchivoFuente se guardaria ".MARS.txt"
function OBTENER_NOMBREARCHIVO(){
	# Script para descomponer una ruta completa a un archivo o directorio, obteniendo
	# el nombre de archivo y extensión (si existen) y ruta hasta los mismos
	for RutaCompleta in $1
	do
		# Comenzamos extrayendo la parte derecha desde el ultimo caracter "/", es decir, el archivo
		NombreArchivo="${RutaCompleta##*/}"
		# Longitud de la ruta es el total de caracteres menos el largo del nombre de archivo
		LargoRuta="${#RutaCompleta} - ${#NombreArchivo}"
		# Extraermos la ruta desde el caracter 0 hasta el caracter final de largo de ruta
		RutaSola="${RutaCompleta:0:$LargoRuta}"
		# Lo siguiente es extraer nombre de archivo
		NombreSolo="${NombreArchivo%.[^.]*}"
		# Extension se obtiene eliminando del nombre completo el nombre mas el punto
		Extension="${NombreArchivo:${#NombreSolo} + 1}"
		if [ "$Extension" != "$CADENA_VACIA" ]; then
			Extension="."$Extension
		fi
		# Las 2 lineas anteriores fallan si no hay extension por lo que es necesario comprobar que no
		# se de el caso de que haya extension pero no nombre ya que en ese caso la ext seria el nombre
		if [[ -z "$NombreSolo" && -n "$Extension" ]]; then
			NombreSolo="$Extension"
			Extension=""
		fi
	done
	if [ "$RutaSola" = "" ]; then
		RutaSola=$( echo "./" )
	fi

	# Este es el resultado del script
	#echo
	#echo "Este es el resultado del script:"
	#echo
	#echo La ruta completa es:
	#echo $RutaCompleta
	#echo
	#echo "Ruta.........: \"$RutaSola\""
	#echo "Nombre.......: \"$NombreSolo\""
	#echo "Extension....: \"$Extension\""
	#echo
	echo $NombreSolo"$Extension"
}

#Autor: 		mreyes
#Descripcion:	Recibe como parametro un string(Key), que indica la llave a buscar en la cadena(2do parametro)
#				el cual debe tener el formato KEY=VALUE
#Parametros:	String(KEY), que indica el "KEY" que debe contener la linea, para extraer su valor
#				String(Linea) de la cual se extraera el valor segun el KEY ESPeCIFICADO
#Ejemplo:		Nombre=$( GETKEYVALUE nombreCliente nombreCliente=Miguel ) 
#				el resultado seria, en la varibale Nombre se guardaria "Miguel"
#Ejemplo2:		Nombre=$( GETKEYVALUE Apellido nombreCliente=Miguel ) 
#				el resultado seria, en la varibale Nombre se guardaria "NO_ENCONTRADO"
#Ejemplo3:		Nombre=$( GETKEYVALUE Apellido nombreCliente:Miguel ) 
#				el resultado seria, en la varibale Nombre se guardaria "NO_ENCONTRADO"
function GETKEYVALUE(){

	Cadena=$2
	KeyBuscar=$1
	NoEncontrado="NO_ENCONTRADO"
	Encontrado="ENCONTRADO"
	SignoGato="#"
	Resultado=$NoEncontrado
	         

	#guardamos la longitud de la linea
	LongitudLinea=${#Cadena}
	PrimerCaracter="${Cadena:0:1}"
	
	#Se verifica si el primer caracter es un #
	if [ $PrimerCaracter != "$SignoGato" ]; then
	
		##Comenzamos extrayendo la parte derecha dede el primer caracter encontrado "=" hasta el fin de la linea, es decir el posible valor
		Value="${Cadena#*=}"
		#verificamos si la longitud de Value, es igual a la de la cadena original
		# si esto se cumple quiere decir que no cumple con el estandar
		#  de key=valor
		if [ $LongitudLinea -eq ${#Value} ]; then
			Resultado=$NoEncontrado
			Value=""
		else
			# Si cumple con el standart de value=key entonces
			#ya tenemos el value, falta calcular el key
			
			#para sacar el key, a la longitud de la linea original, le restamos la longitud del Value
			LongitudKey="$LongitudLinea - ${#Value}"
			#a la Longitud del Key, le restamos 1, por que en esta longitud se esta considerand el caracter "="
			LongitudKey="$LongitudKey - 1 "
			#
			Key="${Cadena:0:$LongitudKey}"
			
			#Verificamos si el key es diferente de vacio
			Value=$( TRIM $Value )
			Key=$( TRIM $Key )
			if [ "$Key" == "" ]; then
				Resultado=$NoEncontrado
				#Value=""
			else
				if [ "$KeyBuscar" == "$Key" ]; then
					Resultado=$Value		
				else
					Resultado=$NoEncontrado
					#Value=""
				fi
			fi
		fi
	fi
	#echo -e "\t value: -$Value-"
	#echo -e "\t key: -$Key-"
	#echo -e "\t longitud de linea $LongitudLinea"
	#echo -e "\t Resultado $Resultado"
	#echo -e "\t primer caracter: $PrimerCaracter"
	echo "$Resultado"
}


# Funcion para obtener el valor de un key(Propeiedad) de un archivo de properties
function GET_PROPERTIEVALUE(){
	#archivo de propiedades donde buscaremos el valor deseado
	RutaProperties=$2
	# Es el valor nuevo a buscar
	KeyBuscar=$1
	NoEncontrado="NO_ENCONTRADO"
	Encontrado="ENCONTRADO"
	Resultado=$NoEncontrado
	Value=""
	
	## primero verificamos  si el el KeyBuscar trae valor
	if [ "$KeyBuscar" != "" ]; then
				
		# Cargamos en un array todo el contenido del properties,(cada renglon debera ser una pocision en el array)
		#para la creacion del script de instalacion
		#OLDIFS=$IFS
		#IFS=$'\n'
		ArregloProperties=$(cat $RutaProperties )
		#IFS=$OLDIFS
		
		
		
		#while read lineaActual
		#do 
		#	Value=$( GETKEYVALUE $KeyBuscar $lineaActual)
		#	if [ "$Value" == "$Encontrado" ]; then
		#		Resultado="$Value"
		#		break
		#	fi
		#	
		#echo -e "$line\n"
		#done < $RutaProperties
		## empzamos a recorrer linea por linea 
		oldIFS=$IFS     # conserva el separador de campo
		IFS=$'\n'     # nuevo separador de campo, el caracter fin de línea
		for lineaActual in $( cat $RutaProperties ); do 
		#echo "buscando en: $lineaActual"
			Value=$( GETKEYVALUE "$KeyBuscar" "$lineaActual" )
			if [ "$Value" != "$NoEncontrado" ]; then
				Resultado="$Value"
				break
			fi
		done 
		IFS=$old_IFS     # restablece el separador de campo predeterminado
	fi
	echo "$Resultado"
}







