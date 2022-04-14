$(document).ready(function() {
	parametros = consultaParametrosSession();

	function init() {
		var fechaAplicacion = parametros.fechaAplicacion;
		var partes = fechaAplicacion.split("-");
		var anio = partes[0];
		var mesFin = partes[1];
		var mesIni = 0;
		var anioMes = 'NINGUNO';

		deshabilitaBoton('btnGuardar', 'submit');
		
		//Solo sera posible generar la informacion de estado de cuenta
		//si el mes final de la aplicacion es Enero o Julio
		if(mesFin == 1 || mesFin == 7) {
			//Si el mes final es Enero, se convierte a Diciembre del anio pasado
			if(mesFin == 1){
				anio--;
				mesFin = 12;
			}
			//Si el mes final es Julio, se convierte a Junio del anio en curso
			else{
				mesFin--;
			}
			mesIni = mesFin - 5;
			//AnioMes toma el formato AAAAMIMF donde MI = mes inicio y MF = mes fin
			anioMes = anio + "" + (mesIni < 10?"0"+mesIni:mesIni) + "" + (mesFin < 10?"0"+mesFin:mesFin);
			$("#anioMes").val(anioMes);
			$("#lblAnioMes").text(anioMes);
			habilitaBoton('btnGuardar', 'submit');
			$("#btnGuardar").focus();
		}
		//Si el mes final es diferente de Enero o Julio,
		//no se genera la informacion de estados de cuenta
		else {
			deshabilitaBoton('btnGuardar', 'submit');
			$("#anioMes").val('');
			$("#lblAnioMes").text(anioMes);
		}
	}
	init();

	var catTipoTransaccion = {
		'generaInfoEdoCta' : 1
	};
	
	$('#btnGuardar').click(function(){
		$("#tipoTransaccion").val(catTipoTransaccion.generaInfoEdoCta);		
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