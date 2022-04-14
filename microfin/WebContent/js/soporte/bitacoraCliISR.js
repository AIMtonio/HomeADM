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
	$('#fecha').val(parametroBean.fechaSucursal);
	console.log(parametroBean.fechaSucursal);
	//
	$.validator.setDefaults({
	      submitHandler: function(event) { 	      
	      	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','fecha','funcion1','funcion2');
	      }
	});

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			fecha: 'required'
		},
		
		messages: {
			fecha: 'Especifique la Fecha de Limpieza'
		}		
	});	


});

function funcion1(){}
function funcion2(){}

