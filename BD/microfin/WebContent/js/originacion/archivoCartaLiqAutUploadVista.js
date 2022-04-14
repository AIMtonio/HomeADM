
$(document).ready(function() {
	esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionFileUpload = {
	  		'enviar':1,
	}; 
	var nomAr = "";	
  	
//------------ Metodos y Manejo de Eventos -----------------------------------------
  	deshabilitaBoton('pdf', 'submit');
  	
  	$(':text').focus(function() {	
	 	esTab = false;
	});
	
  	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID');
	  	}
	});	

	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#enviar').click(function() {	
		$('#extension').val(nomAr.substring(nomAr.lastIndexOf('.')));
		$('#tipoTransaccion').val(catTipoTransaccionFileUpload.enviar);		
	});
	
	$('#file').change(function(){
		nomAr= $('#file').val();		
			$('#extension').val(nomAr.substring(nomAr.lastIndexOf('.')));
			conta = 1;
			$('#comentario').focus();		
	});

	$('#comentario').focus(function() {	
		if(nomAr!=null){
			nomAr= $('#file').val();
			$('#extension').val(nomAr.substring(nomAr.lastIndexOf('.')));
		}
	});
	
	var parametroBean = consultaParametrosSession();
	rutaArchivos = parametroBean.rutaArchivos;
	$('#recurso').val(parametroBean.rutaArchivos);

	//------------ Validaciones de la Forma -------------------------------------
	
	$.validator.addMethod('filesize', function(value, element, param) {
	    return this.optional(element) || (element.files[0].size <= param) ;
	});
	
	$('#formaGenerica').validate({
		rules: {
			tipoDocumentoID: {
				required: true
			},
			comentario: {
				required: true
			},
			file: { required: true,filesize: 3145728  }
	
		},
		messages: {
			tipoDocumentoID: {
				required: 'Especificar Tipo de Documento'
			},
			comentario: {
				required: 'Especificar Observación'
			}	,
			file: {
				required: 'Seleccionar Archivo',
				filesize: 'El archivo seleccionado debe tener un tamanio maximo de 3MB' 
			}	 
		}			
	});
	
//------------ Validaciones de Controles -------------------------------------	
});
