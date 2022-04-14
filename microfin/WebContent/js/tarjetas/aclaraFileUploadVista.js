/*$(window).load(function(){  
	comboTiposDocumento();  
});*/ 
$(document).ready(function() {
	esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionFileUpload = {
  		'adjuntar':1,
  	}; 
  		
//------------ Metodos y Manejo de Eventos -----------------------------------------
  	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$.validator.setDefaults({
		submitHandler: function(event) { 
				grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','numero');
	 	}
	});
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	 var parametroBean = consultaParametrosSession();
     $('#fechaRegistro').val(parametroBean.fechaSucursal);
   
	$('#adjuntar').click(function() {
		var nombreArchivo= $('#file').val();
		$('#extarchivo').val(nombreArchivo.substring(nombreArchivo.lastIndexOf('.')));
		$('#tipoTransaccion').val(catTipoTransaccionFileUpload.adjuntar);
	});
	
	var parametroBean = consultaParametrosSession();
	rutaArchivos = parametroBean.rutaArchivos;
	$('#ruta').val(parametroBean.rutaArchivos);
	
	//------------ Validaciones de la Forma -------------------------------------
	$.validator.addMethod('filesize', function(value, element, param) {
	    return this.optional(element) || (element.files[0].size <= param) ;
	});
	
	$('#formaGenerica').validate({
		rules: {
			file: { required: true,filesize: 3145728  },
			tipoArchivo: {required: true}
		},
		messages: {
			file: {
				required: 'Seleccionar Archivo',
				filesize: 'El archivo seleccionado debe tener un tamanio maximo de 3MB' 
			},
		 		tipoArchivo: 'Introduzca una descripción del archivo a adjuntar'
		}		
	});
	
//------------ Validaciones de Controles -------------------------------------	
});