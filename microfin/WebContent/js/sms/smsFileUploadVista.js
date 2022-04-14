/*$(window).load(function(){  
	comboTiposDocumento();  
});*/ 
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
  	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({
		submitHandler: function(event) { 
			if ($('#extarchivo').val() != '.csv'){
				mensajeSis('Archivo no valido');
				$('#file').val('');
			}else{
				grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','campaniaID');
			}
	 	}
	});
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#enviar').click(function() {
		nomAr= $('#file').val();
		$('#extarchivo').val(nomAr.substring(nomAr.lastIndexOf('.')));
		$('#tipoTransaccion').val(catTipoTransaccionFileUpload.enviar);
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
			file: { required: true,filesize: 3145728  }		
		},
		messages: {
			file: {
				required: 'Seleccionar Archivo',
				filesize: 'El archivo seleccionado debe tener un tamanio maximo de 3MB' 
			}	 
		}		
	});
	
//------------ Validaciones de Controles -------------------------------------	
});