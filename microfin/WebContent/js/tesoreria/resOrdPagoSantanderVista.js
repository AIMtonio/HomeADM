var titulo="";
var tipoUpload=0;

$(document).ready(function() {
	// Definicion de Constantes y Enums
	 
 
	var parametroBean = consultaParametrosSession();   
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('procesar','submit');
	$("#fechaSistema").val(parametroBean.fechaAplicacion);
	$('#subirOrdPago').click(function() {
		titulo = "Respuesta Transferencia Santander";
		tipoUpload=4;
		subirArchivos(titulo, tipoUpload);
	});

	
	$.validator.setDefaults({
		submitHandler: function(event) { 
			  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','false',
			  'funcionExito','funcionError');
		}
	});	


	$('#procesar').click(function() {		
		$("#tipoTransaccion").val(1);	
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
		$("#movLiquidados").val("");
		$("#movPendientes").val("");
		$("#movVencidos").val("");
		$("#movCancelados").val("");
	}else{
		deshabilitaBoton('procesar','submit');
		$("#movLiquidados").val("");
		$("#movPendientes").val("");
		$("#movVencidos").val("");
		$("#movCancelados").val("");
	}
	
}

function consultaTotalesprocesos(Archivo) {
	var archivoProceso= Archivo.trim();
	var resOrdPagoSantaBean = {
			'archivo': archivoProceso
	};
	
	resOrdPagoSantaServicio.consulta(resOrdPagoSantaBean, 1,function(resultado) {
		if(resultado!=null){
			$("#movLiquidados").val(resultado.contLiquidado);
			$("#movPendientes").val(resultado.contPendiente);
			$("#movVencidos").val(resultado.contVencido);
			$("#movCancelados").val(resultado.contCancelado);
		}else{		
			$("#movLiquidados").val("");
			$("#movPendientes").val("");
			$("#movVencidos").val("");
			$("#movCancelados").val("");
		}
	});
}

//Funcion de Exito
function funcionExito(){	
	$("#rutaArchOrdPago").val("");
	deshabilitaBoton('procesar','submit');
	var nombreArchivo = $('#cuerpoMsg').text().replace("]","");
	consultaTotalesprocesos(nombreArchivo.split("[")[1]);
}

//Funcion de Error
function funcionError(){
	$("#rutaArchOrdPago").val("");
	deshabilitaBoton('procesar','submit');
	$("#movLiquidados").val("");
	$("#movPendientes").val("");
	$("#movVencidos").val("");
	$("#movCancelados").val("");
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
