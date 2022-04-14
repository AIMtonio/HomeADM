var esTab = false;
var parametrosBean = consultaParametrosSession();
var catTipoConsultaCredito = {
'principal' : 1,
'foranea' : 2
};

$(document).ready(function() {
	inicializarPantalla();
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});
	$.validator.setDefaults({
		submitHandler : function(event) {
			if(validacion.esFechaValida($("#fechaCastigo").val())){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'creditoID', "exito", "error");
			} else {
				mensajeSis("La Fecha de Condonación no es válida.");
			}
		}
	});
	$('#formaGenerica').validate({
	rules : {
		fechaCastigo : {
			required : true
		},
		rutaArchivoFinal:{
			required : true
		}
	},
	messages : {
		fechaCastigo : {
			required : 'La fecha es Requerida.'
		},
		rutaArchivoFinal:{
			required : 'El Archivo es requerido.'
		}
	}
	});

	$('#adjuntar').click(function() {
		subirArchivos();
	});

});

function inicializarPantalla() {
	$("#fechaCastigo").val(parametrosBean.fechaAplicacion);
	agregaFormatoControles('formaGenerica');
	$("#adjuntar").focus();
	deshabilitaBoton('procesar','submit');
}
function exito() {
	limpiaFormaCompleta('formaGenerica', true, ['creditoID']);
	$("#adjuntar").focus();
	$('#fechaCastigo').val(parametroBean.fechaSucursal);
	deshabilitaBoton('procesar','submit');
}
function error() {
	agregaFormatoControles('formaGenerica');
}

function ayuda(){
	$.blockUI({
		message : $('#ContenedorAyuda'),
		css : {
		top : ($(window).height() - 400) / 2 + 'px',
		left : ($(window).width() - 400) / 2 + 'px',
		width : '400px'
		}
		});
		$('.blockOverlay').attr('title', 'Clic para Desbloquear').click(function() {
			$.unblockUI();
		});
}

function subirArchivos(){
	if(validacion.esFechaValida($('#fechaCastigo').val())){
		var fecha = $('#fechaCastigo').val();
		var tipoUpload = 2;
		var url = "uploadFileGen.htm?" +
				"fecha=" + fecha +
				"&t1="+encoding("Archivo de Castigo Masivo")+
				"&t2="+encoding("Archivo de Castigo Masivo")+
				"&tipo="+tipoUpload;
		var leftPosition = (screen.width) ? (screen.width - 850) / 2 : 0;
		var topPosition = (screen.height) ? (screen.height - 500) / 2 : 0;
		ventanaArchivos = window.open(url, "PopUpSubirArchivo", "width=980,height=340,scrollbars=yes,status=yes,location=false,addressbar=false,menubar=0,toolbar=0" + "left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition);
	} else {
		mensajeSis("La Fecha no es Válida.");
		$("#fechaCastigo").focus();
	}
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