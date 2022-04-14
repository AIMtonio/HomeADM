var titulo="";
var tipoUpload=0;

$(document).ready(function() {
	// Definicion de Constantes y Enums
	 
	deshabilitaBoton('procesar','submit');
	var parametroBean = consultaParametrosSession();   
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	$("#fechaSistema").val(parametroBean.fechaAplicacion);
	$('#subirCtasActivas').click(function() {
		titulo = "Carga Archivo Ctas. Activa.";
		tipoUpload=1;
		subirArchivos(titulo, tipoUpload);
	});
	$('#subirCtasPendientes').click(function() {
		tipoUpload=2;
		titulo = "Carga Archivo Ctas. Pendientes.";
		subirArchivos(titulo,tipoUpload);
		
	});
	
	$.validator.setDefaults({
		submitHandler: function(event) { 
			  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','false',
			  'funcionExito','funcionError');
		}
	});	


	$('#procesar').click(function() {
		$("#tipoTransaccion").val(1);
		var archivo =  $('#rutaArchivo').val();
		var archivoCtaAct = $("#rutaArchCtasActivas").val();
		var archivoCtaPend =$("#rutaArchCtasPendientes").val();
		var contador = 0;
		var extencion = "";

		if(archivoCtaAct != ''  && archivoCtaPend != ''){
			mensajeSis('El archivo no es valido');
		}else{
			if(archivoCtaAct != '' && archivoCtaAct != null){
				var path_splitted = archivoCtaAct.split('.');
				extencion = path_splitted.pop();
				if(extencion == archivoCtaAct || extencion == ""){
					mensajeSis('El archivo no es valido');
				}
				if((extencion != 'txt' && extencion != 'csv') || extencion == ""){
					mensajeSis('El archivo no es valido');
				}else{
					contador++;
				}
			}
			if(archivoCtaPend != '' && archivoCtaPend != null){
				var path_splitted = archivoCtaPend.split('.');
				extencion = path_splitted.pop();
				if(extencion == archivoCtaPend && extencion == ""){
					mensajeSis('El archivo no es valido');
				}
				if((extencion != 'txt' && extencion != 'csv') || extencion == ""){
					mensajeSis('El archivo no es valido');
				}else{
					contador++;
				}
			}	
		}	
		
	});

	
	$('#formaGenerica').validate({
		rules: {
		},		
		messages: {		

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
	}else{
		deshabilitaBoton('procesar','submit');
	}
}

//Funcion de Exito
function funcionExito(){	
	$("#rutaArchCtasActivas").val("");
	$("#rutaArchCtasPendientes").val("");
	deshabilitaBoton('procesar','submit');
}

//Funcion de Error
function funcionError(){
	$("#rutaArchCtasActivas").val("");
	$("#rutaArchCtasPendientes").val("");
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
