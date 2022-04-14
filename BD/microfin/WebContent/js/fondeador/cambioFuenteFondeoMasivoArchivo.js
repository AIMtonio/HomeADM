var catTipoTransaccionFileUpload = {
	'enviar':1
};

$(document).ready(function () {

	esTab = false;

	$(':file, :submit').focus(function() {
		esTab = false;
	});

	$(':file, :submit').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey) {
		esTab = true;
		}
	});

	$('#enviar').click(function(event) {
		var fechaHora = new Date();
		var fecha = fechaHora.getFullYear() + (fechaHora.getMonth() + 1 < 10 ? '0' : '') + (fechaHora.getMonth() + 1) + (fechaHora.getDate() < 10 ? '0' : '') + fechaHora.getDate();
		var hora = (fechaHora.getHours() < 10 ? '0' : '') + fechaHora.getHours() + (fechaHora.getMinutes() < 10 ? '0' : '') + fechaHora.getMinutes() + (fechaHora.getSeconds() < 10 ? '0' : '') + fechaHora.getSeconds() + (fechaHora.getMilliseconds() >= 100 ? '' : (fechaHora.getMilliseconds() >= 10 ? '00' : '0')) + fechaHora.getMilliseconds();
		var fechaHoraCarga = fecha + '-' + hora;

		$('#fechaHoraCarga').val(fechaHoraCarga);
		$('#tipoTransaccion').val(catTipoTransaccionFileUpload.enviar);
	});

//------------ Validaciones de la Forma -------------------------------------
	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','file');
		}
	});

	$.validator.addMethod('tamanioArchivo', function(value, element, param) {
		return this.optional(element) || (element.files[0].size <= param) ;
	});

	$.validator.addMethod('validaExtension', function() {
		var nomAr = $("#file").val();
		var extension = nomAr.substring(nomAr.lastIndexOf('.') + 1);

		extensionesPermitidas = {};
		extensionesPermitidas["csv"] = true;

		return extension.toLowerCase() in extensionesPermitidas;
	});

	$('#formaGenerica').validate({
		rules: {
			file: { 
				required: true,
				tamanioArchivo: 10485760,
				validaExtension: true 
			}
		},
		messages: {
			file: {
				required: 'Seleccionar Archivo',
				tamanioArchivo: 'El archivo seleccionado debe tener un tamaño máximo de 10MB',
				validaExtension: 'Solo archivos csv.'
			}	 
		}	
	});
});