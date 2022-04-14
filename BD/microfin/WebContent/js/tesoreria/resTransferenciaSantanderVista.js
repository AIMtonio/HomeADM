var titulo="";
var tipoUpload=0;

$(document).ready(function() {
	// Definicion de Constantes y Enums
	 
	deshabilitaBoton('procesar','submit');
	var parametroBean = consultaParametrosSession();   
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	$("#fechaSistema").val(parametroBean.fechaAplicacion);
	$('#subirArchivo').click(function() {
		titulo = "Respuesta Transferencia Santander";
		tipoUpload=3;
		subirArchivos(titulo, tipoUpload);
	});

	
	$.validator.setDefaults({
		submitHandler: function(event) { 
			  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','false',
			  'funcionExito','funcionError');
		}
	});	


	$('#procesar').click(function() {
		var archivo =  $('#rutaArchivo').val();
		var path_splitted = archivo.split('.');
		var extencion = path_splitted.pop();
		if(extencion == archivo){
			mensajeSis('El archivo no es valido');
		}
		if(extencion == 'txt' || extencion == 'csv'){
			$("#tipoTransaccion").val(1);
		}else{
			
			mensajeSis('El archivo no es valido');
		}
	});

	
	$('#formaGenerica').validate({
		rules: {
			file: { 
				rutaArchivo: true,
			},
		},		
		messages: {		
			file: {
				rutaArchivo: 'El Archivo es requerido.',
			}
		}
		
	});
	
});

function subirArchivos(titulo, tipoUpload){
	var url = "cargaArchPlano.htm?" +
			"fecha=" + fecha +
			"&t1="+encoding(titulo)+
			"&t2="+encoding(titulo)+
			"&tipo="+tipoUpload;
	var leftPosition = (screen.width) ? (screen.width - 850) / 2 : 0;
	var topPosition = (screen.height) ? (screen.height - 500) / 2 : 0;
	ventanaArchivos = window.open(url, "PopUpSubirArchivo", "width=980,height=340,scrollbars=yes,status=yes,location=false,addressbar=false,menubar=0,toolbar=0" + 
										"left=" + leftPosition + 
										",top=" + topPosition + 
										",screenX=" + leftPosition + 
										",screenY=" + topPosition);
}
function consultaGridDepositosRefe(consecutivo, numeroMensaje, rutaArchivo, controlID){
	$("#"+controlID).val(rutaArchivo);
	if(rutaArchivo!="" && rutaArchivo!=null){
		habilitaBoton('procesar','submit');
	}
	else{
		deshabilitaBoton('procesar','submit');
	}
}

//Funcion de Exito
function funcionExito(){	
	$("#rutaArchivo").val("");
	deshabilitaBoton('procesar','submit');
}

//Funcion de Error
function funcionError(){
	$("#rutaArchivo").val("");
	deshabilitaBoton('procesar','submit');
}

function encoding(cadena){
	return btoa(cadena);
}

function decoding(cadena){
	return atob(cadena)
}

function exitoAdjunta(){
	habilitaBoton('procesar','submit');
}
