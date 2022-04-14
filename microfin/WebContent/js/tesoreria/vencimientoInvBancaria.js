$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	var parametroBean = consultaParametrosSession();
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');  
	$(':text').focus(function() {	
	 	esTab = false;
	});

	//------------ Validaciones de la Forma -------------------------------------s
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
  	$.validator.setDefaults({
        submitHandler: function(event) { 
               grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','procesar');
               $('#fechaSistema').val(parametroBean.fechaSucursal);
        }
  	});

	$('#fechaSistema').val(parametroBean.fechaSucursal);

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			fechaSistema: {
				required: true
			}
		},
		messages: {
			fechaSistema: {
				required: 'Especifique la Fecha de Vencimiento'
			}
		}
	});

});