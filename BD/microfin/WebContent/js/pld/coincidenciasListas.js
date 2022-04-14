esTab = true;

$(document).ready(function() {
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	
	$.validator.setDefaults({
	      submitHandler: function(event) {
	    	  grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','institNominaID', 
	    			  'funcionExito','funcionError');
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
	
	$('#procesar').click(function(event) {
		
	});
	
	// VALIDACION DE LA FORMA
	$('#formaGenerica').validate({
		rules: {			 
			fechaCarga	: {
				required	: true,
				date 		: true
			}
			
		},
		
		messages: {
			fechaCarga	: {
				required	: 'Especifique una Fecha de Carga.',
				date		: 'Fecha de Carga no válida.'
			}
		}		
	});
	 
}); // Fin del Document Ready

function funcionExito(){
}

function funcionError(){
}