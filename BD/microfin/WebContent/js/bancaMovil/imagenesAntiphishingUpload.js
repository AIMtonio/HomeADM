$(document).ready(function() {
	esTab = true;
	 
	var parametroBean = consultaParametrosSession();	
	
	//Definicion de Constantes y Enums  
	var catTipoTransaccionFileUpload = {
		'subir' : 1
	}
	var nomAr = "";	
  		
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#enviar').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionFileUpload.subir);
	});
			
	/*$('#file').change(function(){
		nomAr= $('#file').val();
		$('#extarchivo').val(nomAr.substring(nomAr.lastIndexOf('.')));
		conta = 1;
		$('#observacion').focus();
	});*/
	$(':file, :submit').blur(function() {
		
		if($(this).attr('id') == $('#formaGenerica :input:enabled:visible:last').attr('id') && esTab) {
			setTimeout( function() {
				$('#file').focus();
			}, 0);
		}
	});

	
	$('#file').change(function() {	
		nomAr= $('#file').val();
		$('#extarchivo').val(nomAr.substring(nomAr.lastIndexOf('.')));
		$('#extensionArchivo').val(nomAr.substring(nomAr.lastIndexOf('.') + 1));
	});
	
	var parametroBean = consultaParametrosSession();
	rutaArchivos = parametroBean.rutaArchivos;
	$('#recurso').val(parametroBean.rutaArchivos);	
	
	$.validator.setDefaults({
		submitHandler: function(event) { 	
		grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','file');
	 	}
	});	
	
	//------------ Validaciones de la Forma -------------------------------------
	$.validator.addMethod('filesize', function(value, element, param) {
	    return this.optional(element) || (element.files[0].size <= param) ;
	});
	$.validator.addMethod('validaExtension', function() {
		extensionesPermitidas = {};
		extensionesPermitidas["jpg"] = true;
		extensionesPermitidas["png"] = true;
		extensionesPermitidas["jpeg"] = true;

		return $('#extensionArchivo').val().toLowerCase() in extensionesPermitidas;
	});

	
	$('#formaGenerica').validate({
		rules: {
			descripcion: {
				required: true
			},
			file: { 
				required: true,
				filesize: 3145728,
				validaExtension: true
			}		
			
		},
		messages: {
			descripcion: {
				required: 'Especifique la descripcion'
			}	,
			file: {
				required: 'Especifique el archivo',
				filesize: 'El archivo seleccionado debe tener un tamanio maximo de 3MB',
				validaExtension: 'El archivo seleccionado debe ser de tipo imagen'
			}	 
		}		
	});
	
});




