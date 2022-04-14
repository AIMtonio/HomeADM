$(document).ready(function() {
	esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTranFileUpload = {
	  		'enviar':1,
	  		'modificar':2,
	  		'eliminar':3
	}; 
	var nombreArchivo = "";	
  	
//------------ Metodos y Manejo de Eventos -----------------------------------------
  	
  	$(':text').focus(function() {	
	 	esTab = false;
	});
	
  	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','polizaID');
	  	}
	});	

	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#enviar').click(function() {		
		$('#tipoTransaccion').val(catTipoTranFileUpload.enviar);
	});
	
	$('#listaArchivos').change(function(){
		var fileInput = document.getElementById('listaArchivos');
		var nombresArchivos = "";

		for(var i= 0;  i< fileInput.files.length; i++){
			var nomArchivo = fileInput.files[i].name;
			nombresArchivos = nombresArchivos + nomArchivo.substring(nomArchivo.lastIndexOf('.')) + "-" ;
		}

		nombreArchivo= $('#listaArchivos').val();
		conta = 1;
		$('#observacion').focus();
		$('#cadenaArchivos').val(nombresArchivos);
	});

	
	var parametroBean = consultaParametrosSession();
	rutaArchivos = parametroBean.rutaArchivos;
	$('#recurso').val(parametroBean.rutaArchivos);

	//------------ Validaciones de la Forma -------------------------------------
	
	$.validator.addMethod('filesize', function(value, element, param) {
		var tamanioArchivosSuma = 0;
		var fileInput = document.getElementById('listaArchivos');
		for(var i= 0;  i< fileInput.files.length; i++){
			tamanioArchivosSuma = tamanioArchivosSuma + fileInput.files[i].size;
			if(tamanioArchivosSuma > 3145728){
				return false;
			}
		}
		return true;
	});
	
	$('#formaGenerica').validate({
		rules: {			
			observacion: {
				required: true
			},
			listaArchivos: { 
				required: true, 
				filesize: true
			}
		},
		messages: {
			observacion: {
				required: 'Especificar Observación'
			}	,
			listaArchivos: {
				required: 'Seleccionar Archivo',
				filesize: 'El conjunto de archivos no deben superar los 3MB'
			}	 
		}			
	});
	
//------------ Validaciones de Controles -------------------------------------	
});



