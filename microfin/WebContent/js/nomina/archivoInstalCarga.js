$(document).ready(function() {
    esTab = true;
    
    //Definicion de Constantes y Enums  
	var catTipoTransaccion = {   
  		'procesa':'1'
  	};
	  
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

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
			grabaFormaTransaccionRetrollamada(event,'formaGenerica2', 'contenedorForma',
					'mensaje', 'true', 'folioID','funcionExito','funcionFracaso');
    	}
    });
        
    $('#procesar').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccion.procesa);
		 
    });

    //------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica2').validate({
		rules: {
			file: 'required'
		},
		
		messages: {
			file: 'Se requiere un Archivo para subir.'
		}
		
	});
     
});