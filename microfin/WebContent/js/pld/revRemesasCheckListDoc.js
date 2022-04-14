
$(document).ready(function() {
	esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionFileUpload = {
	  	'enviar':1,
	};
	
	var nomAr = "";	
  	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
  	
  	$(':text').focus(function() {	
	 	esTab = false;
	});
	
  	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','remesaFolioID');
	  	}
	});	
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#enviar').click(function() {
		if($('#tipoDocumentoID').val() == ""){
			mensajeSis('Especifique el Tipo de Documento en el Check List.');
		}else{
			$('#extension').val(nomAr.substring(nomAr.lastIndexOf('.')));
			$('#tipoTransaccion').val(catTipoTransaccionFileUpload.enviar);
			 consultaCheckListRemesas();
		}
	});
	
	$('#file').change(function(){
		nomAr = $('#file').val();
		$('#extension').val(nomAr.substring(nomAr.lastIndexOf('.')));
		conta = 1;
		$('#enviar').focus();
	});
	
	var parametroBean = consultaParametrosSession();
	$('#recurso').val(parametroBean.rutaArchivosPLD);

	//------------ Validaciones de la Forma -------------------------------------
	
	$.validator.addMethod('filesize', function(value, element, param) {
	    // param = size (en bytes) 
	    // element = element to validate (<input>)
	    // value = value of the element (file name)
	    return this.optional(element) || (element.files[0].size <= param) ;
	});
	
	$('#formaGenerica').validate({
		rules: {
			tipoDocumentoID: {
				required: true
			},
			file: { required: true,filesize: 3145728  }
	
		},
		messages: {
			tipoDocumentoID: {
				required: 'Especificar Tipo de Documento.'
			},
			file: {
				required: 'Seleccionar Archivo.',
				filesize: 'El Archivo Seleccionado debe tener un Tamaño Máximo de 3MB.' 
			}	 
		}			
	});
	
//------------ Validaciones de Controles -------------------------------------	
});