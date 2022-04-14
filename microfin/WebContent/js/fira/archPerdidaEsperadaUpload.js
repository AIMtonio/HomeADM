var esTab = true;
var nomAr = "";
var conta = 0;
var catTipoTransaccionFileUpload = {
	'enviar' : 1
};

$(document).ready(function() {
	var parametrosBean = consultaParametrosSession();
	var rutaArchivos = parametrosBean.rutaArchivos;
	$('#recurso').val(rutaArchivos);
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	habilitaBoton('enviar', 'submit');

	$.validator.setDefaults({
		submitHandler : function(event) {
			var parametrosBean = consultaParametrosSession();
			var rutaArchivos = parametrosBean.rutaArchivos;
			$('#recurso').val(rutaArchivos);
			$('#rutaLocal').val($('#rutaLocal').val());
			grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'envia');
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$('#enviar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionFileUpload.enviar);
	});

	$('#file').change(function() {
		nomAr = $('#file').val();
		$('#extension').val(nomAr.substring(nomAr.lastIndexOf('.')));
	});

	//------------ Validaciones de la Forma -------------------------------------
	$.validator.addMethod('filesize', function(value, element, param) {
		return this.optional(element) || (element.files[0].size <= param);
	});

	$('#formaGenerica').validate({	
		rules: {
			file: { required: true ,filesize: 3145728  }
		},
		messages: {
			file: {
				required: 'Seleccionar Archivo.',
				filesize: 'El archivo seleccionado debe tener un tamaño máximo de 3MB.' 
			}	 
		}		
	});

});
