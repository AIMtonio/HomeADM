
$(document).ready(function() {
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionFileUpload = {   
  		'procesa':'1'
  	};
	
//------------ Metodos y Manejo de Eventos -----------------------------------------
  	$(':text').focus(function() {	
	 	esTab = false;
	});
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
  	$.validator.setDefaults({
		submitHandler: function(event) {
			if ($('#extarchivo').val() != '.xls'){
				alert('Archivo No Válido.');
				$('#file').val('');
			}else{
				grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true','institNominaID');
			}
    	}
    });
  
	$('#procesarArchivo').click(function() {
		var nombreArchivo= $('#file').val();
		$('#extarchivo').val(nombreArchivo.substring(nombreArchivo.lastIndexOf('.')));
		$('#tipoTransaccion').val(catTipoTransaccionFileUpload.procesa);
	});
	
	var parametroBean = consultaParametrosSession();
	rutaArchivos = parametroBean.rutaArchivos;
	$('#rutaArchivosPagos').val(parametroBean.rutaArchivos);
	
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
				required: 'Seleccionar Archivo.',
				filesize: 'El Archivo Seleccionado Debe Tener un Tamaño Máximo de 3MB.' 
			},
		}		
	});

	});