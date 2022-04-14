$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
  		 
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
  
  
	$(':text').focus(function() {	
	 	esTab = false;
	});

  
	//------------ Validaciones de la Forma -------------------------------------
 
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
 
	var parametroBean = consultaParametrosSession();
	$('#fechaBloqueo').val(parametroBean.fechaSucursal);

	//Graba la Transaccion: Realiza el Cierre
	$.validator.setDefaults({
	      submitHandler: function(event) { 	      
	      	grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','procesar');
	      }
	});
	
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			fechaBloqueo: 'required'
		},
		
		messages: {
			fechaBloqueo: 'Especifique la Fecha de Cierre'
		}		
	});	

});