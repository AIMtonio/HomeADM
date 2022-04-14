$(document).ready(function() {
	esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionFileUpload = {
	  		'adjuntar':1
	}; 
	var nomAr = "";	  	
//------------ Metodos y Manejo de Eventos -----------------------------------------  	
  	
  	$(':text').focus(function(){
	 	esTab = false;
	});
	
  	$.validator.setDefaults({
		submitHandler: function(event) {
			if($('#extension').val()=='.jpg' || $('#extension').val()=='.jpeg'){								
				grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','representLegal');				
			}else{
				alert("Formato No Válido, Únicamente Archivos .jpg");
				$('#file').val('');
				$('#file').focus();
				$('#observacion').val('');
			}
	  	}
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#adjunta').click(function(){
		$('#tipoTransaccion').val(catTipoTransaccionFileUpload.adjuntar);				
	});
	
	$('#file').change(function(){		
		nomAr= $('#file').val();
		$('#extension').val(nomAr.substring(nomAr.lastIndexOf('.')));
		conta = 1;
		$('#observacion').focus();
	});
	
	$('#observacion').change(function() {	
		nomAr= $('#file').val();
		$('#extension').val(nomAr.substring(nomAr.lastIndexOf('.')));
	});
	
	var parametroBean = consultaParametrosSession();
	rutaArchivos = parametroBean.rutaArchivos;
	$('#recurso').val(parametroBean.rutaArchivos);	

	//------------ Validaciones de la Forma -------------------------------------
	
	$.validator.addMethod('filesize', function(value, element, param) {
	    // param = size (en bytes) 
	    // element = element to validate (<input>)
	    // value = value of the element (file name)
	    return this.optional(element) || (element.files[0].size <= param) ;
	});
	
	$('#formaGenerica').validate({
		rules: {
			observacion: {
				required: true
			},
			file: { required: true,filesize: 3145728  }
		},
		messages: {			
			observacion: {
				required: 'Especificar Observación.'
			}	,
			file: {
				required: 'Seleccionar Archivo.',
				filesize: 'El Archivo Seleccionado Debe Tener un Tamaño Máximo de 3MB.' 
			}	 
		}			
	});	
});
