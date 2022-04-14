$(document).ready(function() {
	esTab = true;
	//Definicion de Constantes y Enums  
	var catTipoTransaccionFileUpload = {
  		'enviar':4
  	}; 
	var nomAr = "";
	var extPrincipal='';
	var nombreCampo='';
	var jqExtension='';
  	var tipoDeExtension={
  			'tipoKey':1,
  			'tipoCer':2  			
  	}	;
//------------ Metodos y Manejo de Eventos -----------------------------------------
  	$(':text').focus(function() {	
	 	esTab = false;
	});
  	saberExtension();
	function saberExtension(){			
		if($('#ext').val()==tipoDeExtension.tipoKey){				
			extPrincipal='.key';	
			nombreCampo='archivoKey';			
			
		}else{
			extPrincipal='.cer';
			nombreCampo='archivoCer';				
			return extPrincipal;
		}
		return extPrincipal;
		
	};
	$.validator.setDefaults({
		submitHandler: function(event) { 				
			if ($('#extarchivo').val() != extPrincipal){
				alert('Archivo no valido');				
				$(jqExtension).val('');
			}else{					
				grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','ext');
			}
	 	}
	});
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#enviar').click(function() {				
		jqExtension = eval("'#"+nombreCampo+"'");		
		nomAr= $(jqExtension).val();					
		$('#extarchivo').val(nomAr.substring(nomAr.lastIndexOf('.')));		
		$('#tipoTransaccion').val(catTipoTransaccionFileUpload.enviar);					
	});
	
	//------------ Validaciones de la Forma -------------------------------------
	$.validator.addMethod('filesize', function(value, element, param) {
	    // param = size (en bytes)      // element = element to validate (<input>) //value = value of the element (file name)
	    return this.optional(element) || (element.files[0].size <= param) ;
	});
	
	$('#formaGenerica').validate({
		rules: {
			archivoKey: { required: true,filesize: 1048576 },
			archivoCer:{required: true,filesize: 1048576}
		},
		messages: {
			archivoKey: {
				required: 'Seleccionar Archivo',
				filesize: 'El archivo seleccionado debe tener un tamaño maximo de 1MB' 
			},
			archivoCer:{
				required:'Seleccionar Archivo',
				filesize:'El archivo seleccionado debe tener un tamaño maximo de 1MB'
			}
		}		
	});
	
//------------ Validaciones de Controles -------------------------------------	
});