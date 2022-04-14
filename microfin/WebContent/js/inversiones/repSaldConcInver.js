$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	

	var parametroBean = consultaParametrosSession();
	$('#fecha').val(parametroBean.fechaSucursal);
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
	
	$('#imprimir').click(function() {		
		var fecha = $('#fecha').val();	 
		$('#ligaImp').attr('href','SaldConcInver.htm?fecha='+fecha); 
	});

});