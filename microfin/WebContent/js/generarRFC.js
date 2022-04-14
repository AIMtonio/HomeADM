function generaRFC(nombre, apellidoPaterno, apellidoMaterno, fechaNac){
        var rfc = "";
        var patronVocal = /A|E|I|O|U/i;
        //Elimina Espacios Vacios, Convierte a Mayusculas
        nombre = trim(nombre.toUpperCase());
        apellidoPaterno = trim(apellidoPaterno.toUpperCase());
        apellidoMaterno = trim(apellidoMaterno.toUpperCase());
        
        var apellidoPaternoHomoclave = apellidoPaterno.toUpperCase();
    var apellidoMaternoHomoclave = apellidoMaterno.toUpperCase();
        
        //Quitamos los Articulos de los Apellidos
        apellidoPaterno = eliminaArticulos(apellidoPaterno);
        apellidoMaterno = eliminaArticulos(apellidoMaterno);    
        
        //Agregamos el primer caracter del apellido paterno
        rfc = apellidoPaterno.charAt(0);
        
        //Buscamos y agregamos al rfc la primera vocal del primer apellido
        //      rfc = rfc + apellidoPaterno.charAt(apellidoPaterno.search(patronVocal));
        for(var i = 1; i < apellidoPaterno.length; i++) {
          if (esVocal(apellidoPaterno.charAt(i))) {
                  rfc += apellidoPaterno.charAt(i);
          break;
          }
        }

        //Agregamos el primer caracter del apellido materno
        if(apellidoMaterno != ''){
                rfc = rfc + apellidoMaterno.charAt(0);
        }
        
        //Agregamos el primer caracter del primer nombre
        rfc = rfc + ignoraNombreComun(nombre,0);
        
        //Agregamos el segundo caracter del primer nombre en caso de que el apellido materno sea vacio
        if(apellidoMaterno == ''){
                rfc = rfc + ignoraNombreComun(nombre,1);
        }
        
        //Agregamos la fecha en formato yymmdd (dd/mm/yyyy) yyyy-mm-dd
        //rfc = rfc + fechaNac.substring(8,10) + fechaNac.substring(3,5) + fechaNac.substring(0,2);
        //Agregamos la fecha en formato yymmdd (yyyy-mm-dd)
        rfc = rfc + fechaNac.substring(2,4) + fechaNac.substring(5,7) + fechaNac.substring(8,10);
        //Le agregamos la homoclave al rfc
        //      rfc = calcularHomoclave(apellidoPaterno + ' ' + apellidoMaterno + ' ' + nombre, fechaNac, rfc);
        rfc=calcularHomoclave(apellidoPaternoHomoclave + " " + apellidoMaternoHomoclave + " " + nombre, fechaNac, rfc);
        
        //Eliminamos palabras Ofensivas
        rfc=eliminaPalabrasOfensivas(rfc);
        
        
        return rfc;
        
        //TODO  
}

  // Verifica si el caracter pasado es una vocal
function esVocal(letra) {
  if (letra == 'A' || letra == 'E' || letra == 'I' || letra == 'O' || letra == 'U')
  return true;
}

function calcularHomoclave(nombreCompleto, fechaNac, rfc) {
        var     nombreEnNumero;
        var valorSuma = 0;
        var tablaRFC1 = {
          "&": "10",
          "?": "10",
          "A": "11",
          "B": "12",
          "C": "13",
          "D": "14",
          "E": "15",
          "F": "16",
          "G": "17",
          "H": "18",
          "I": "19",
          "J": "21",
          "K": "22",
          "L": "23",
          "M": "24",
          "N": "25",
          "O": "26",
          "P": "27",
          "Q": "28",
          "R": "29",
          "S": "32",
          "T": "33",
          "U": "34",
          "V": "35",
          "W": "36",
          "X": "37",
          "Y": "38",
          "Z": "39",
          "0": "0",
          "1": "1",
          "2": "2",
          "3": "3",
          "4": "4",
          "5": "5",
          "6": "6",
          "7": "7",
          "8": "8",
          "9": "9"
        };
        var tablaRFC2 = {
          "0": "1",
          "1": "2",
          "2": "3",
          "3": "4",
          "4": "5",
          "5": "6",
          "6": "7",
          "7": "8",
          "8": "9",
          "9": "A",
          "10": "B",
          "11": "C",
          "12": "D",
          "13": "E",
          "14": "F",
          "15": "G",
          "16": "H",
          "17": "I",
          "18": "J",
          "19": "K",
          "20": "L",
          "21": "M",
          "22": "N",
          "23": "P",
          "24": "Q",
          "25": "R",
          "26": "S",
          "27": "T",
          "28": "U",
          "29": "V",
          "30": "W",
          "31": "X",
          "32": "Y"
        };

        var tablaRFC3 = {
          "A": "10",
          "B": "11",
          "C": "12",
          "D": "13",
          "E": "14",
          "F": "15",
          "G": "16",
          "H": "17",
          "I": "18",
          "J": "19",
          "K": "20",
          "L": "21",
          "M": "22",
          "N": "23",
          "O": "25",
          "P": "26",
          "Q": "27",
          "R": "28",
          "S": "29",
          "T": "30",
          "U": "31",
          "V": "32",
          "W": "33",
          "X": "34",
          "Y": "35",
          "Z": "36",
          "0": "0",
          "1": "1",
          "2": "2",
          "3": "3",
          "4": "4",
          "5": "5",
          "6": "6",
          "7": "7",
          "8": "8",
          "9": "9",
          "": "24",
          " ": "37"
        }
        //Agregamos un cero al inicio de la representaci?n n?merica del nombre
        nombreEnNumero = '0';
        //Recorremos el nombre y vamos convirtiendo las letras en
        //su valor num?rico
        for(var i=0; i < nombreCompleto.length; i++) {
                if (nombreCompleto.charAt(i) in tablaRFC1)
                        nombreEnNumero = nombreEnNumero + tablaRFC1[nombreCompleto.charAt(i)];
                else
                        nombreEnNumero = nombreEnNumero + '00';
        }
        
        //Calculamos la suma de la secuencia de n?meros calculados anteriormente
        //La formula es: ( (el caracter actual multiplicado por diez) mas el valor del caracter siguiente )
        //                                      (y lo anterior multiplicado por el valor del caracter siguiente)
        for (var i = 0; i < nombreEnNumero.length-1; i++) {
                valorSuma += ((parseInt(nombreEnNumero.charAt(i)) * 10) + parseInt(nombreEnNumero.charAt(i+1))) *
                                           parseInt(nombreEnNumero.charAt(i+1));
        }
        var div = 0;
        var mod = 0;
        div = parseInt(valorSuma % 1000);
        mod = div % 34;
        div = (div - mod) / 34;
        
        var indice = 0;
        var hc = "";            //Los dos primeros caracteres de la homoclave
        while (indice <= 1) {
                if ( ((indice == 0) ? div.toString() : mod.toString()) in tablaRFC2)
                        hc += tablaRFC2[indice == 0 ? div.toString() : mod.toString()];
                else
                        hc += "Z";
                indice++;
        }
        //Agregamos al RFC los dos primeros caracteres de la homoclave
        rfc += hc;
        
        //Aqui empieza el calculo del digito verificador basado en lo que tenemos del RFC
        var rfcAnumeroSuma = 0;
        var     sumaParcial = 0;
        
        for (var i = 0; i < rfc.length; i++) {
                if (rfc.charAt(i) in tablaRFC3) {
                        rfcAnumeroSuma = parseInt(tablaRFC3[rfc.charAt(i)]);
                        sumaParcial += (rfcAnumeroSuma * (14 - (i + 1)));
                }
        }
        var moduloVerificador = sumaParcial % 11;
        if (moduloVerificador == 0)
                rfc += "0";
        else {
                sumaParcial = 11 - moduloVerificador;           
                if (sumaParcial == 10)
                        rfc += "A";
                else
                        rfc += sumaParcial;
        }       
        
        return  rfc;
}

function ignoraNombreComun(cadena, indice){
        var patronEspacio = /\s/g;
        var nombres = cadena.split(patronEspacio);
        var primerLetra;
        if(nombres.length >1){
                //alert(nombres[0].charAt(indice));
                if(nombres[0] == "JOSE" || nombres[0] == "MARIA" || nombres[0] == "MA." 
                || nombres[0] == "MA"   || nombres[0] == "J."){
                        primerLetra = nombres[1].charAt(indice);
                }else{
                        primerLetra = nombres[0].charAt(indice);
                }               
        }else{
                primerLetra = nombres[0].charAt(indice);
        }
        return primerLetra;
}

function eliminaArticulos(cadena){
        var patron = /(DEL\s)|(LAS\s)|(DE\s)|(LA\s)|(Y\s)|(A\s)|(MC\s)|(LOS\s)|(VON\s)(VAN\s)/gi;
        return cadena.replace(patron,'');
}
/*****************************************************************************/
 //     Elimina palabras ofensivas
function eliminaPalabrasOfensivas(rfc) {
  var rfcNomApe  = rfc.substring(0,4);
  var ofensivas = rfcNomApe.split("\\s");
  var STRING_X = "X";
  
  if(ofensivas[0]==("BUEI")||ofensivas[0]==("BUEY")||ofensivas[0]==("CACA")||
         ofensivas[0]==("CACO")||ofensivas[0]==("CAGA")||ofensivas[0]==("CAGO")||
         ofensivas[0]==("CAKA")||ofensivas[0]==("CAKO")||ofensivas[0]==("COGE")||
         ofensivas[0]==("COJA")||ofensivas[0]==("KOGE")||ofensivas[0]==("KOJO")||
         ofensivas[0]==("KAKA")||ofensivas[0]==("KULO")||ofensivas[0]==("MAME")||
         ofensivas[0]==("MAMO")||ofensivas[0]==("MEAR")||ofensivas[0]==("MEAS")||
         ofensivas[0]==("MEON")||ofensivas[0]==("MION")||ofensivas[0]==("FETO")||
         ofensivas[0]==("GUEY")||ofensivas[0]==("JOTO")||ofensivas[0]==("KACA")||
         ofensivas[0]==("KACO")||ofensivas[0]==("KAGA")||ofensivas[0]==("KAGO")||
         ofensivas[0]==("MOCO")||ofensivas[0]==("MULA")||ofensivas[0]==("PEDA")||
         ofensivas[0]==("PEDO")||ofensivas[0]==("PENE")||ofensivas[0]==("PUTA")||
         ofensivas[0]==("PUTO")||ofensivas[0]==("QULO")||ofensivas[0]==("RATA")||
         ofensivas[0]==("RUIN"))
        
 //Se reemplaza la 4a. letra del RFC por una "X", cuando se forma palabra ofensiva 
  rfc = reemplazaCaracterEnPosicion(rfc, 3, STRING_X);
 return rfc;
 }

function reemplazaCaracterEnPosicion(rfc, posicion, caracterReemplazo) {
        return rfc.substring(0,posicion) + caracterReemplazo + rfc.substring(posicion+1);
}

/*****************************************************************************/

function valRFC(campo,apePat,apeMat,nombre,fecNac) {
                        
                        var nombreLength = nombre.length;
                        var longUltimo = nombre.toString().lastIndexOf('\ ')
                        var longPrimer = nombre.toString().indexOf('\ ',0)
                        var nombre1 = nombre.substring(0,longPrimer)
                        var nombre2 = nombre.substring(longUltimo,nombreLength)
                        if(nombre1 == ""){
                                nombre1 = nombre2
                        }
                        
                        var cad0 = apePat.toString().substring(0,1);
                var cad1 = apeMat.toString().charAt(0);
                var cad2 = nombre1.toString().charAt(0);
                var cad6 = nombre2.toString().charAt(0);
                if(nombre2.toString().lastIndexOf('\ ') != -1) {
                    cad6 = nombre2.toString().charAt(nombre2.toString().lastIndexOf('\ ')+1);
                }

                        if(apePat.toString().lastIndexOf('\ ') != -1) {
                    cad0 = apePat.toString().substring(apePat.toString().lastIndexOf('\ ')+1,apePat.toString().lastIndexOf('\ ')+2);

                
                        var a = apePat.length;
                                for(var i = 2; i <= a ;i++)
                    {
                                var letra =     apePat.toString().substring(apePat.toString().lastIndexOf('\ ')+i,apePat.toString().lastIndexOf('\ ')+(i+1));
                                if (letra == 'A' || letra == 'E'|| letra == 'I'|| letra == 'O'|| letra == 'U')
                                {
                                        cad0 =  cad0+letra
                                        i = a;
                                }
                    }

                }else
                {
                        var a = apePat.length;
                        for(var i = 2; i <= a ;i++)
                    {
                                var letra =     apePat.toString().substring(apePat.toString().lastIndexOf('\ ')+i,apePat.toString().lastIndexOf('\ ')+(i+1));
                                if (letra == 'A' || letra == 'E'|| letra == 'I'|| letra == 'O'|| letra == 'U')
                                {
                                        cad0 =  cad0+letra
                                        i = a;
                                }
                    }
                        
                }
                if(apeMat.toString().lastIndexOf('\ ') != -1) {
                    cad1 = apeMat.toString().charAt(apeMat.toString().lastIndexOf('\ ')+1);
                }
                if(nombre1 == "JOSE" || nombre1 == "MARIA") {
                                if(nombre2 != '')
                        cad2 = cad6;
                }
                        
                        var cad3 = fecNac.toString().substring(8,10);
                var cad4 = fecNac.toString().substring(3,5);
                var cad5 = fecNac.toString().substring(0,2);
                campo.value = cad0+cad1+cad2+cad3+cad4+cad5;
        }