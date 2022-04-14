$(document).ready(function() {
	esTab = true;
	var parametroBean = consultaParametrosSession();
	agregaFormatoControles('formaGenerica');

	//Definicion de Constantes y Enums
	var catTipoTransConcilia = {
		'grabar' : '1'
	};

	var catTipoConConcilia = {
	'principal' : 1,
	'foranea' : 2
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------

	$(':text').focus(function() {
		esTab = false;
	});

	$.validator.setDefaults({
		submitHandler : function(event) {
			if (validacionGrid() != false) {
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'false', 'SolicitudCreditoID', 'funcionExito', 'funcionError');
			}
		}
	});

	$('#procesar').click(function() {
		$('#tipoTransaccion').val(catTipoTransConcilia.grabar);
	});

	$('#formaGenerica').validate({
	rules : {},
	messages : {}
	});

	movimientos();

});// fin de jquery

function movimientos() {
	var params = {};
	params['tipoLista'] = 1;
	$.post("tarDebCorrespGrid.htm", params, function(data) {
		if (data.length > 0) {
			$('#contenedorMovs').html(data);
			$('#contenedorMovs').show();
		} else {
			$('#contenedorMovs').hide();
			$('#contenedorMovs').html("");
			mensajeSis('No se han encontrado movimientos con los datos proporcionados');
		}

		var numFilas = consultaFilas();
		if (numFilas == 0) {
			deshabilitaBoton('procesar', 'submit');

		} else {

			habilitaBoton('procesar', 'submit');
		}

	});
}

function validacionGrid() {
	var count = 0;
	$('input[name=checkProc]').each(function() {
		if ($(this).is(':checked')) {
			count++;
		}
	});
	if (count == 0) {
		mensajeSis("No ha seleccionado ningun registro para conciliar");
		return false;
	} else {
		return true;
	}
}

//Función consulta el total de creditos en la lista
function consultaFilas() {
	var totales = 0;
	$('tr[name=renglon]').each(function() {
		totales++;

	});
	return totales;
}

//Función que al dar click en un check de la lista de creditos asigna valor si es seleccionado o no
function verificaProcesado(control) {
	var numero = control.replace(/\D/g, '');
	var si = 'S';
	var no = 'N';
	if ($('#' + control).attr('checked') == true) {
		document.getElementById(control).value = si;
		$('#estatusConci' + numero).val('S');
	} else {
		document.getElementById(control).value = no;
		$('#estatusConci' + numero).val('N');
	}

}

function seleccionaTodas() {

	if ($('#selecTodas').is(":checked")) {
		$('input[name=checkProc]').each(function() {
			var control = (this.id);
			var numero = control.replace(/\D/g, '');
			$('#' + this.id).attr('checked', true);
			$('#estatusConci' + numero).val('S');
		});
	} else {

		$('input[name=checkProc]').each(function() {
			var control = (this.id);
			var numero = control.replace(/\D/g, '');
			$('#' + this.id).attr('checked', false);
			$('#' + this.id).val('N');
			$('#estatusConci' + numero).val('N');
		});
	}

}

function funcionExito() {
	movimientos();
}

function funcionError() {

}