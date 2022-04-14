$(document).ready(function() {
	esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionFileUpload = {
  		'enviar':4,
  		'modificar':5,
  		'eliminar':6
  	}; 
	var nomAr = "";	
  		
//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('pdf', 'submit');
  	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	 
	$.validator.setDefaults({
		submitHandler: function(event) { 	
		grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','cedeID');
	 	}
	});		   			
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#enviar').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionFileUpload.enviar);
	});
	
		
	$('#file').change(function(){
		nomAr= $('#file').val();
		$('#extarchivo').val(nomAr.substring(nomAr.lastIndexOf('.')));
		conta = 1;
		$('#observacion').focus();
	});
	
	$('#observacion').change(function() {	
		nomAr= $('#file').val();
		$('#extarchivo').val(nomAr.substring(nomAr.lastIndexOf('.')));
	});
	
	var parametroBean = consultaParametrosSession();
	rutaArchivos = parametroBean.rutaArchivos;
	$('#recurso').val(parametroBean.rutaArchivos);	
	
	//------------ Validaciones de la Forma -------------------------------------
	$.validator.addMethod('filesize', function(value, element, param) {
	    return this.optional(element) || (element.files[0].size <= param) ;
	});
	
	var comentario = $('#comentario').val();
	$('#observacion').val(comentario);

	if($('#observacion').val() != ''){
		$('#observacion').attr('readOnly',true); 
	} 
	
	$('#formaGenerica').validate({
		rules: {
			cedeID: {
				required: true
			},
			tipoDocumento: {
				required: true
			},
			observacion: {
				required: true
			},
			file: { required: true,filesize: 3145728  }		
			
		},
		messages: {
			cedeID: {
				required: 'Especificar Cede'
			},
			tipoDocumento: {
				required: 'Especificar Tipo de Documento' 
			},
			observacion: {
				required: 'Especificar Observacion'
			}	,
			file: {
				required: 'Seleccionar Archivo',
				filesize: 'El archivo seleccionado debe tener un tamanio maximo de 3MB' 
			}	
		}		
	});
	
//------------ Validaciones de Controles -------------------------------------

});


