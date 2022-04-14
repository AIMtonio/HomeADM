function centraDiv(divCentrar, contenedor) {
	jqConDivCentrar = eval("'#" + divCentrar + "'");
	jqConContenedor = eval("'#" + contenedor + "'");

	$(jqConDivCentrar).css(
			{
				position : 'absolute',
				left : ($(jqConContenedor).outerWidth() - $(jqConDivCentrar)
						.outerWidth()) / 2,
				top : ($(jqConContenedor).outerHeight() - $(jqConDivCentrar)
						.outerHeight()) / 2
			});
};

function cerosIzq(control, longitud) {
	expr = /\s/;
	control.value = control.value.replace(expr, "0");
	if (control.value == "")
		control.value = 0;
	if (isNaN(control.value) == true)
		control.value = 0;
	else
		control.value = parseInt(parseFloat(control.value));
	while (control.value.length < longitud) {
		control.value = "0" + control.value;
	}
}

/** Calculo entre dos fechas apertura y la fecha que escoja el cliente* */

function diferenciaDias(fechaInicio, fechaFin) {

	// Obtiene los datos del formulario
	CadenaFecha1 = fechaInicio;
	CadenaFecha2 = fechaFin;

	// Obtiene dia, mes y año
	var fecha1 = new fecha(CadenaFecha1);
	var fecha2 = new fecha(CadenaFecha2);

	// Obtiene objetos Date
	var miFecha1 = new Date(fecha1.anio, fecha1.mes - 1, fecha1.dia);
	var miFecha2 = new Date(fecha2.anio, fecha2.mes - 1, fecha2.dia);

	// Resta fechas y redondea
	var diferencia = miFecha2.getTime() - miFecha1.getTime();
	var dias = Math.floor(diferencia / (1000 * 60 * 60 * 24));

	// var segundos = Math.floor(diferencia / 1000);

	return dias;

}

function fecha(cadena) {

	var separador = "-";

	if (cadena.indexOf(separador) != -1) {

		var pos1 = 0;
		var pos2 = cadena.indexOf(separador, pos1 + 3);
		var pos3 = cadena.indexOf(separador, pos2 + 2);

		this.anio = cadena.substring(pos1, pos2);
		this.mes = cadena.substring(pos2 + 1, pos3);
		this.dia = cadena.substring(pos3 + 1, cadena.length);

	} else {
		this.dia = 0;
		this.mes = 0;
		this.anio = 0;
	}
}

function convertirFecha( cadena ) {

	var date = new Date();
	var separador = "-";

	var pos1 = 0;
	var pos2 = cadena.indexOf(separador, pos1 + 3);
	var pos3 = cadena.indexOf(separador, pos2 + 2);

	var anio = cadena.substring(pos1, pos2);
	var mes = cadena.substring(pos2 + 1, pos3);
	var dia = cadena.substring(pos3 + 1, cadena.length);

	date.setYear(anio);
	date.setMonth(mes-1);
	date.setDate(dia);


	return date.getTime();
}

	//Formatea un Fecha y la convierte en una Cadena o String
	//El formato Default es "año-mes-dia"
	function formateaFechaString(fecha){
		return formatDate(fecha, "yyyy-MM-dd");
	}

function ultimoDiaDelMes(Mes, Anio) {
     var ultimoDia = 30;
     if (Mes == 1 || Mes == 3 || Mes == 5 || Mes == 7
         || Mes == 8 || Mes == 10 || Mes == 12){
          ultimoDia = 31;
     }
     if (Mes == 2) {
         if (Anio % 4 == 0 && (Anio % 400 == 0 || Anio % 100 != 0))
              ultimoDia = 29;
         else
             ultimoDia = 28;
     }
     return ultimoDia;
}

/**
 * Función que limpia de caracteres especiales y acentos a una cadena de texto determinada.
 * @param cadena : Cadena o texo a limpiar.
 * @param tipoResultado : OR.- Mantiene texto original, MA.- El resultado lo pasa en Mayusculas, MI.- El resultado lo pasa en Minusculas.
 * @returns String : Texto limpio.
 * @author avelasco
 */
function limpiaCaracteresEspeciales(cadena,tipoResultado){
	var enMayusculas = 'MA';
	var enMinusculas = 'MI';
	var original = 'OR';

	// Si el tipo de resultado viene vacio, el default mostrará el texto original
	if(tipoResultado.length==0){
		tipoResultado = original;
	}

	// Definimos los caracteres especiales a limpiar.
	var specialChars = "!¡@#$%¨&*()«—»_––-+=§¹²³£¢¬\"\"`´{[^~}]<>.,‘’‚“”„:;¿?/°ºª+*|\\''¤¥¦©®¯±µ¶·¸¼½¾†‡•…‰€™";

	// Definición de letras con acentos y su equivalente sin acentos.
	var ConAcentos = 'ŠšŽžÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÒÓÔÕÖØÙÚÛÜÝŸÞàáâãäåæçèéêëìíîïòóôõöøùúûüýÿþƒñÑ';
	var SinAcentos = 'SsZzAAAAAAACEEEEIIIIOOOOOOUUUUYYBaaaaaaaceeeeiiiioooooouuuuyybfnN';

	// Se limpian los acentos
	for (var i = 0; i < ConAcentos.length; i++) {
		cadena = cadena.replace(new RegExp("\\" + ConAcentos[i], 'gi'), SinAcentos[i]);
	}

	// Se limpian caracteres especiales
	for (var i = 0; i < specialChars.length; i++) {
		cadena = cadena.replace(new RegExp("\\" + specialChars[i], 'gi'), '');
	}
	// Se limpian saltos de línea
	cadena = cadena.split("\n").join(" ");


	if(tipoResultado == enMayusculas){
		cadena = cadena.toUpperCase();
	} else if(tipoResultado == enMinusculas){
		cadena = cadena.toLowerCase();
	}

	return cadena.trim();
}

/**
 * Método que verifica que solo se agreguen números "." y "," dependiendo del tipo de válidación
 * @param evt Evento Keypress
 * @param tipo 1 - Solo Números Enteros 2 - Decimales (sin formato moneda) "." 3- Decimales (con formato moneda)
 */
function ingresaSoloNumeros(evt,tipo, id){
	try {
		var charCode = (evt.which) ? evt.which : event.keyCode;
		switch(tipo){
			case 1:
			break;
			case 2:
				if (charCode == 46) {
					var txt = document.getElementById(id).value;
					if (!(txt.indexOf(".") > -1)) {
						return true;
					}
				}
				break;
			case 3:
				if (charCode == 46) {
					var txt = document.getElementById(id).value;
					if (!(txt.indexOf(".") > -1)) {
						return true;
					}
				}

				if(charCode==44){
					return true;
				}
				break;
		}

		if (charCode > 31 && (charCode < 48 || charCode > 57))
			return false;
		return true;
	} catch (w) {
		mensajeSis(w);
	}
}
/**
 * Función que suma y/o consulta el día siguiente hábil.
 * Es necesario importar el servicio dwr diaFestivoServicio en el jsp.
 * @param numeroConsulta : Número de consulta [2,3].
 * @param fecha : Fecha formato [yyyy-mm-dd].
 * @param diasSuma : Días a sumarle a la fecha sin considerar días hábiles.
 * @param dias : Número de días considerando días hábiles.
 * @param diaHabil : Indica el tipo de día habil a tomar A. Anterior S. Siguiente.
 * @returns Arreglo tipo bean con el resultado de la consulta.
 * @author avelasco
 */
function sumaDiasFechaHabil(numeroConsulta,fecha, diasSuma, dias, diaHabil){
	var fechaBean = {
		'fecha' 		: fecha,
		'numeroDias'	: Number(dias),
		'numeroDiasSuma': Number(diasSuma),
		'sigAnt'		: diaHabil
	};
	var resultadoFecha = null;
	if(fecha != '' && fecha != '1900-01-01' && !isNaN(dias) && Number(dias)>=0 && !isNaN(diasSuma) && Number(diasSuma)>=0 && esTab){
		diaFestivoServicio.consulta(Number(numeroConsulta), fechaBean,{ async: false, callback:function(fechasBean) {
			if(fechasBean!=null){
				resultadoFecha = fechasBean;
			} else {
				resultadoFecha = fechaBean;
			}
		}
		});
	} else {
		resultadoFecha = fechaBean;
	}
	return resultadoFecha;
}

var validacion = {
esCorreo : function(str) {
	var pattern = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
	return pattern.test(str); // returns a boolean
},
estaVacio : function(str) {
	var pattern = /\S+/;
	return !pattern.test(str); // returns a boolean
},
esNumeroEntero : function(str) {
	var pattern = /^\d+$/;
	return pattern.test(str); // returns a boolean
},
esNumeroDecimal : function(str) {
	var pattern = /^([1-9]\d*(\.|\,)\d*|0?(\.|\,)\d*[1-9]\d*|[1-9]\d*)$/;
	return pattern.test(str); // returns a boolean
},
esIgual : function(str1, str2) {
	return str1 === str2;
},
esFechaValida : function(str) {
	  var regEx = /^\d{4}-\d{2}-\d{2}$/;
	  if(!str.match(regEx)) return false;  // Formato Invalido
	  var d = new Date(str);
	  if(!d.getTime() && d.getTime() !== 0) return false; // Fecha Invalida
	  return d.toISOString().slice(0,10) === str;
	}
};

function sumaMesesFechaHabil(fecha, numMeses){
	var fechaBean = {
		'fecha' 		: fecha,
		'numeroMesesSuma': Number(numMeses),
	};
	var resultadoFecha = null;
	if(fecha != '' && fecha != '1900-01-01' && !isNaN(numMeses) && Number(numMeses)>=0){
		diaFestivoServicio.consulta(4, fechaBean,{ async: false, callback:function(fechasBean) {
			if(fechasBean!=null){
				resultadoFecha = fechasBean;
			} else {
				resultadoFecha = fechaBean;
			}
		}
		});
	} else {
		resultadoFecha = fechaBean;
	}
	return resultadoFecha;
}

/**
 * Busca una cadena en otra cadena
 * @param cadena1 : Cadena completa
 * @param cadena2 : Cadena a buscar en cadena1
 * Ejemplo: busca("Hola Mundo", "Hola"); --> true
 * @returns {Boolean}
 */
function busca(cadena1, cadena2) {
	if (cadena1 != null && cadena2 != null) {
		var str = cadena1;
		var n = str.search(cadena2);
		if (n >= 0) {
			return true;
		} else {
			return false;
		}
	} else {
		return false;
	}
}

/**
 * Marca todos los checks segun su name.
 * @param nameInput : Propiedad name de los checks que se van a marcar
 * @param idCheck : ID del check que indica si se marcan o desmarcan
 * @returns
 * @author pmontero
 */
function marcarTodasCheck(nameInput,idCheck){
	$("input:not(:disabled)[name="+nameInput+"]").attr('checked', $("#"+idCheck).attr("checked"));
}

/**
 * Muestra nueva ventana (popup) centrado
 * @param url : URL completa
 * @param title: Titulo de la ventana
 * @param w: Ancho de la ventana
 * @param h: Alto de la ventana
 * @returns
 * @author pmontero
 */
function PopupCenter(url, title, w, h) {
	var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : window.screenX;
	var dualScreenTop = window.screenTop != undefined ? window.screenTop : window.screenY;

	var width = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
	var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

	var systemZoom = width / window.screen.availWidth;
	var left = (width - w) / 2 / systemZoom + dualScreenLeft;
	var top = (height - h) / 2 / systemZoom + dualScreenTop;
	var newWindow = window.open(url, title, 'scrollbars=yes, width=' + w / systemZoom + ', height=' + h / systemZoom + ', top=' + top + ', left=' + left);

	if (window.focus) newWindow.focus();
}