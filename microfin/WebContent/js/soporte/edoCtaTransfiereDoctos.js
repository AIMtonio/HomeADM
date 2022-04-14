$(document).ready(function() {
	parametros = consultaParametrosSession();

	function init() {
		var fechaAplicacion = parametros.fechaAplicacion;
		var partes = fechaAplicacion.split("-");
		var anio = partes[0];
		var mes = partes[1];

		if(mes > 1) {
			mes--;
		}
		else {
			anio--;
			mes = 12;
		}

		var anioMes = anio + "" + (mes < 10?"0"+mes:mes);
		$("#anioMes").val(anioMes);
		$("#lblAnioMes").text(anioMes);
		$('#btnGuardar').focus();
	}
	init();
	
	
	
	var catTipoTransaccion = {
		'importaTransfiereArchivos' : 3
	};
	
	$('#btnGuardar').click(function(){
		$("#tipoTransaccion").val(catTipoTransaccion.importaTransfiereArchivos);		
	});
	
	// ------------ Metodos -------------------------------------
	$.validator.setDefaults({
		submitHandler: function(event) {
			deshabilitaBoton('btnGuardar', 'submit');
			grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','');
			habilitaBoton('btnGuardar', 'submit');
		}
    });
	
	$('#formaGenerica').validate({
		rules: {

		},
		
		messages: {

		}		
	});
});