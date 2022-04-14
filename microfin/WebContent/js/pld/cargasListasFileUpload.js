
$(document).ready(function() {
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionFileUpload = {   
  		'procesa':'1'
  	};
	
	var parameters = {};
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
				alert('El Archivo no es Válido. Sólo archivos con extensión .xls');
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
	$('#rutaArchivos').val(parametroBean.rutaArchivosPLD);
	$('#fechaCarga').val(parametroBean.fechaSucursal);
	
	obtenValoresPOST();
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
				required: 'Seleccionar un Archivo.',
				filesize: 'El Archivo Seleccionado Debe Tener un Tamaño Máximo de 3MB.' 
			},
		}		
	});
	
	function obtenValoresPOST(){
		var query = location.search.substring(1);
		var keyValues = query.split(/&/);
		var tamanio = query.split(/&/).length;
		for (var index = 0; index < tamanio; index ++) {
		    var keyValuePairs = keyValues[index].split(/=/);
		    var key = keyValuePairs[0];
		    var value = keyValuePairs[1];
		    parameters[key] = value.split('%20').join(' ');
		}
		$('#labelLegend').text('Adjuntar Archivo para Carga de ' + parameters['descLista']);
		$('#tipoLista').val(parameters['tipoLista']);
	}
}); // Fin Document Ready