$(window).load(function(){  
	 
}); 

$(document).ready(function() {
	esTab = true;
	 
	var catTipoTransaccionFileUpload = {
			'enviar':1
	}; 

  	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
  	habilitaBoton('enviar', 'submit');
  	
  	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','clienteID');
	  	}
	});	
  	
  	$(':text').focus(function() {	
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#enviar').click(function() {	
		console.log("entro")
		$('#tipoTransaccion').val(catTipoTransaccionFileUpload.enviar);
	});
	
	
	$('#file').change(function(){
		nomAr= $('#file').val();
		$('#extension').val(nomAr.substring(nomAr.lastIndexOf('.')));
		$('#nombreArchivo').val(nomAr);
	});

	

	var parametrosBean = consultaParametrosSession();
	var rutaArchivos = parametrosBean.rutaArchivos;
	$('#recurso').val(rutaArchivos);
	console.log(rutaArchivos+"/"+$('#file').val());
	console.log($('#extension').val());
	//------------ Validaciones de la Forma -------------------------------------
	$.validator.addMethod('filesize', function(value, element, param) {
	    return this.optional(element) || (element.files[0].size <= param) ;
	});
	
	$('#formaGenerica').validate({	
		rules: {
			
		},
		messages: {
			
		}		
	});
	

});



