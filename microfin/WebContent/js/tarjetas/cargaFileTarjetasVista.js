var numeroDocumentos = 0;
$(document).ready(function() { 
	esTab = false; 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionFileUpload = {
	  		'enviar':1,
	  		'modificar':2,
	  		'eliminar':3
	}; 	
  	
//------------ Metodos y Manejo de Eventos -----------------------------------------
  	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','recurso');
	  	}
	});	
		
	 $('#enviar').click(function() {
	 	if ($('#extension').val() == '.txt' || $('#extension').val() == '.xls' || $('#extension').val() == '.xlsx'){
			$('#tipoTransaccion').val(catTipoTransaccionFileUpload.enviar);
		}else{
			mensajeSis("Seleccione un Archivo Válido");
			return false;
			
		}		
		
	});
	
	$('#file').change(function(){
		nomAr= $('#file').val();
		$('#extension').val(nomAr.substring(nomAr.lastIndexOf('.')));
		conta = 1;
	});

	$('#file').blur(function(){

		nomAr= $('#file').val();
		var filenameWithExtension = nomAr.replace(/^.*[\\\/]/, ''); 	
		$('#nombreArchivo').val(filenameWithExtension);
		conta = 1;
	});
	
	var parametroBean = consultaParametrosSession();
	$('#fechaCarga').val(parametroBean.fechaSucursal);
	$('#recurso').val(parametroBean.rutaArchivos);

	//------------ Validaciones de la Forma -------------------------------------
	
	$.validator.addMethod('filesize', function(value, element, param) {
	    return this.optional(element) || (element.files[0].size <= param) ;
	});
	
	$('#formaGenerica').validate({
		rules: {
			file: { required: true,filesize: 3145728  }
		},
		messages: {
			file: {
				required: 'Seleccionar Archivo',
				filesize: 'El archivo seleccionado debe tener un tamaño máximo de 3MB' 
			}	 
		}			
	});
	
});

