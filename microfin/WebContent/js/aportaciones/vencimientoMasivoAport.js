$(document).ready(function() {
	// Definicion de Constantes y Enums
	esTab = true;
	var parametroBean = consultaParametrosSession();
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
               grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','procesar');
               $('#fechaInicio').val(parametroBean.fechaSucursal);
        }
  	});

	$('#procesar').focus();
	$('#fechaInicio').val(parametroBean.fechaSucursal);

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			fechaInicio: {
				required: true
			}
		},
		messages: {
			fechaInicio: {
				required: 'Especifique la Fecha de Vencimiento.'
			}
		}
	});

});

function confirmar(){
	if(confirm('¿Desea Ejecutar el Proceso de Vencimiento Masivo?'))
		return true;
	else
		return false;
	}