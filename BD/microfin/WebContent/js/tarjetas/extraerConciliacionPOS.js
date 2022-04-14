$(document).ready(function (){
	esTab = true;

	parametros = consultaParametrosSession();
	$('#fechaRegistro').val(parametroBean.fechaSucursal);
	var catTipoTransaccion = {  
			'procesar':'1'
	};
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	agregaFormatoControles('formaGenerica');

	//------------ Metodos y Manejo de Eventos ----------
	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event,'formaGenerica','contenedorForma','mensaje','true','fechaRegistro','exito','fallo');
			
		}
	});
	
	$('#procesar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.procesar);
		
	});
	$('#adjuntar').click(function() {
		subirArchivos();
	});
	function subirArchivos() {
		var url ="extracionTatrPOSSubirArchivo.htm";
		var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
		var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;

		ventanaArchivosCuenta = window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
				"left="+leftPosition+
				",top="+topPosition+
				",screenX="+leftPosition+
				",screenY="+topPosition);	
		
	}
	
	
	
	
	$('#formaGenerica').validate({
		rules: {
			ruta : {
				required : true
			}
		},	
		messages: {
			ruta: {
					required: "Adjunte un Archivo"
			}
		}
	});

});
function exito() {
	$('#ruta').val('');
	$('#fechaRegistro').val(parametroBean.fechaSucursal);
	generaDescargaZip();
	
}
function fallo() {
	
}
function generaDescargaZip() {
	var rutazip = $('#consecutivo').val();
	var nomArchivoZip = $('#campoGenerico').val();

	var pagina = 'descargaZipVista.htm?nombrezip='+ nomArchivoZip +'&rutaZip='+rutazip;
	window.open(pagina);
}

