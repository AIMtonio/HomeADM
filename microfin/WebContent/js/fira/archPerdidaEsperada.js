$(document).ready(function() {
	inicializa();
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$('#formaGenerica').validate({
	rules : {
	rutaArchivo : {
		required : function (){ return ($('#archivo').asNumber()==1||$('#archivo').asNumber()==3);}
	},
	fecha : {
		required : true
	},
	archivo : {
		required : true
	}
	},
	messages : {
	rutaArchivo : {
		required : 'Seleccionar un Archivo.'
	},
	fecha : {
		required : 'La fecha es Requerida.'
	},
	archivo : {
		required : 'Seleccione una Opción.'
	}
	}
	});
	$('#subir').click(function() {
		subirArchivos();
	});
	
	$('#archivo').change(function() {
		$('#fecha').val("");
		$('#rutaArchivo').val("");
		$('#nombreArchivo').val("");
		if($('#archivo').asNumber()==2 || $('#archivo').asNumber()==4){
			deshabilitaBoton('subir');
		} else {
			habilitaBoton('subir');
		}
		deshabilitaBoton('generar');
	});
	
	$('#fecha').change(function() {
		$('#rutaArchivo').val("");
		$('#nombreArchivo').val("");
		if($('#archivo').asNumber()==2 || $('#archivo').asNumber()==4){
			habilitaBoton('generar');
		}
	});
	$('#generar').click(function() {
		var nombreArchivo = $('#rutaArchivo').val();
		if($('#archivo').asNumber()==1 || $('#archivo').asNumber()==3){
			$('#nombreArchivo').val(nombreArchivo.substring(nombreArchivo.lastIndexOf('/')).replace('/',''));
			$('#nombreArchivo').val($('#nombreArchivo').val().substring(0,$('#nombreArchivo').val().lastIndexOf('.')));
		} else {
			if($('#archivo').asNumber()==2){
				var parametrosBean = consultaParametrosSession();
				var rutaArchivos = parametrosBean.rutaArchivos;
				$('#rutaArchivo').val(rutaArchivos+"FIRA/"+$('#fecha').val()+"/");
				$('#nombreArchivo').val('PINOFIRA_'+$('#fecha').val().replace('-',''));
				$('#rutaFinal').val($('#rutaArchivo').val()+$('#nombreArchivo').val());
			} else if($('#archivo').asNumber()==4){
				var parametrosBean = consultaParametrosSession();
				var rutaArchivos = parametrosBean.rutaArchivos;
				$('#rutaArchivo').val(rutaArchivos+"FIRA/"+$('#fecha').val()+"/");
				$('#nombreArchivo').val('SPNOFIRA_'+$('#fecha').val().replace('-',''));
				$('#rutaFinal').val($('#rutaArchivo').val()+$('#nombreArchivo').val());
			}
		}
		pagina='RepArchivosPerdida.htm?'+
			'fecha='+$('#fecha').val()+
			'&archivo='+$('#archivo').val()+ 
			'&rutaFinal='+$('#rutaFinal').val()+
			'&nombreArchivo='+$('#nombreArchivo').val();
		window.open(pagina);
	});
	

});
function inicializa() {
	$('#archivo').focus();
	agregaFormatoControles('formaGenerica');
	inicializaForma('formaGenerica', 'archivo');
	deshabilitaBoton('generar');
}
function exito() {

}
function error() {

}
function subirArchivos() {
	var fecha = $('#fecha').val();
	var archivo = $('#archivo').asNumber();
	if(validacion.esFechaValida(fecha) && archivo>0){
		var url = "archPerdEsperadaUpload.htm?fecha=" + fecha+"&archivo="+archivo;
		var leftPosition = (screen.width) ? (screen.width - 850) / 2 : 0;
		var topPosition = (screen.height) ? (screen.height - 500) / 2 : 0;
		ventanaArchivos = window.open(url, "PopUpSubirArchivo", "width=980,height=340,scrollbars=yes,status=yes,location=false,addressbar=false,menubar=0,toolbar=0" + "left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition);
	} else {
		if(!validacion.esFechaValida(fecha)){
			mensajeSis("Seleccione una Fecha.");
		} else if(archivo<=0){
			mensajeSis("Seleccione el tipo de Archivo.");
		}
	}
}
function habilitaGenera(){
	habilitaBoton('generar');
}