$(document).ready(function() {

	//-----------------------Método valida y manejo de eventos-----------------------
	consultaNivelesRiesgo();
	agregaFormatoControles('formaGenerica');
	$.validator.setDefaults({
		submitHandler : function(event) {
			grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'false', 'nivelRiesgoID');
		}
	});

	$('#formaGenerica').validate({
	rules : {

	minimo : {
	required : true,
	number : true
	},
	maximo : {
	required : true,
	number : true
	},

	},
	messages : {
	minimo : {
	required : 'Especifique una cantidad',
	number : 'Solo números'
	},
	maximo : {
	required : 'Especifique una cantidad',
	number : 'Solo números'
	}
	}
	});

	$('#guardar').click(function(event) {
		$('#formaGenerica').validate();
		verificaPuntajes();
		procesaFilas();
	});

	$("#tipoPersona").change(function() {
		consultaNivelesRiesgo();
	});

});

function consultaNivelesRiesgo() {
	var tipoPersona = $("#tipoPersona").val();

	var catTipoConsultaNiveles = {
	'tipoPersona' : tipoPersona,
	'tipoConsulta' : 1
	};
	$('#tablaNiveles').html("");
	nivelesRiesgoCatalogoPLD.consultaPrincipal(catTipoConsultaNiveles, {
	callback : function(listaNiveles) {
		if (listaNiveles != null) {
			var tds = '';
			tds += '<table id="tablaNiveles" border="1" cellspacing="2px" style="position:absolute;top:23px;left:45px;" >';
			tds += '<tr>';
			tds += '<td>';
			tds += '<label><b>Nivel de Riesgo&nbsp;&nbsp;</b></label>';
			tds += '</td>';
			tds += '<td>';
			tds += '<label><b>&nbsp&nbsp&nbspM&iacute;nimo</b></label>';
			tds += '</td>';
			tds += '<td class="separador"></td>'
			tds += '<td>';
			tds += '<label><b>&nbsp&nbsp&nbspM&aacute;ximo</b></label>';
			tds += '</td>';
			tds += '<td>';
			tds += '<label><b>Requiere Escalamiento</b></label>';
			tds += '</td>';
			tds += '</tr>';
			for (var i = 0; i < listaNiveles.length; i++) {
				tds += '<tr id="renglon' + listaNiveles[i].nivelRiesgoID + '" name="renglon">';
				tds += '<td>';
				tds += '<label id="descripcion">' + listaNiveles[i].descripcion + '</label>';
				tds += '</td>';
				tds += '<td align="left">';
				tds += '<input type="text" id="minimo' + listaNiveles[i].nivelRiesgoID + '" value="' + listaNiveles[i].minimo + '" name="minimo" size="10"  maxlength="3"  style="text-align: right;" disabled/><label>%</label>';
				tds += '</td>';
				tds += '<td class="separador"></td>'
				tds += '<td align="left">';
				tds += '<input type="text" id="maximo' + listaNiveles[i].nivelRiesgoID + '" value="' + listaNiveles[i].maximo + '" tabindex="' + (i + 1) + '" name="maximo" maxlength="3" size="10" style="text-align: right;" onblur="calculaMinimo(this.id)"/><label>%</label>';
				tds += '</td>';
				tds += '<td align="center">';
				tds += '<input type="checkbox" id="seEscala' + listaNiveles[i].nivelRiesgoID + '" value="' + listaNiveles[i].seEscala + '" name="seEscala"/>';
				tds += '</td>';
				tds += '<td>';
				tds += '<input type="hidden"  id="nivelRiesgoID' + listaNiveles[i].nivelRiesgoID + '" value="' + listaNiveles[i].nivelRiesgoID + '" name="nivelRiesgoID" size="10" readonly="true"/>';
				tds += '</td>';
				tds += '<td>';
				tds += '<input type="hidden"  id="estatus' + listaNiveles[i].nivelRiesgoID + '" value="' + listaNiveles[i].estatus + '" name="estatus" size="10" readonly="true"/>';
				tds += '</td>';
				tds += '</tr>';
			}
			tds += '</table>';
			$('#tablaNiveles').html(tds);

			//Realiza check
			for (var i = 0; i < listaNiveles.length; i++) {
				var jqEscala = eval("'#seEscala" + listaNiveles[i].nivelRiesgoID + "'");
				if (listaNiveles[i].seEscala == 'S') {
					$(jqEscala).attr('checked', 'true');
				}
			}
		}
		//chekea si nivel medio es inactivo
		if ($("#estatusM").val() == "I") {
			$("#nivelActivoM").attr('checked', 'true');
			inactivaNivel();
		}
		deshabilitaControl('maximoA');
		agregaFormatoControles('formaGenerica');
		$("#tipoPersona").focus();
	},
	errorHandler : function(errorString, exception) {
		mensajeSis("Error al Consultar los Niveles de Riesgo:" + errorString + " - " + exception);
	}
	});
	$("#tipoPersona").focus();

}

//Concatena los registros seleccionados
function procesaFilas() {
	var estatusNivel = {
	'activo' : 'A',
	'inactivo' : 'I'
	};

	$('#listaNivelesPLD').val('');
	$('#tablaNiveles tr[name=renglon]').each(function(index) {

		if (index >= 0) {
			var nivelRiesgoID = $(this).find("input[name=nivelRiesgoID]").val();
			var minimo = $(this).find("input[name=minimo]").val();
			var maximo = $(this).find("input[name=maximo]").val();
			var seEscala = $(this).find("input[name=seEscala]").is(":checked");
			var tipoPersona = $("#tipoPersona").val();

			var estatus;
			var inabilitado = $("#nivelActivoM").is(":checked");

			if (nivelRiesgoID == "M" && inabilitado == true) {
				estatus = estatusNivel.inactivo;
			} else {
				estatus = estatusNivel.activo;
			}

			if (index == 0) {
				$('#listaNivelesPLD').val($('#listaNivelesPLD').val() + nivelRiesgoID + ']' + minimo + ']' + maximo + ']' + (seEscala ? 'S' : 'N') + ']' + estatus + ']'+ tipoPersona + ']');
			} else {
				$('#listaNivelesPLD').val($('#listaNivelesPLD').val() + '[' + nivelRiesgoID + ']' + minimo + ']' + maximo + ']' + (seEscala ? 'S' : 'N') + ']' + estatus + ']'+ tipoPersona + ']');
			}
		}
	});
}

function calculaMinimo(id) {
	var inabilitado = $("#nivelActivoM").is(":checked");

	if (!inabilitado) {
		switch (id) {
			case "maximoB" :
				if (!isNaN(parseInt($("#maximoB").val()))) {
					$("#minimoM").val(parseInt($("#maximoB").val()) + 1);
				}
				break;
			case "maximoM" :
				if (!isNaN(parseInt($("#maximoM").val()))) {
					$("#minimoA").val(parseInt($("#maximoM").val()) + 1);
				}
				break;
		}
	} else {
		switch (id) {
			case "maximoB" :
				if (!isNaN(parseInt($("#maximoB").val()))) {
					$("#minimoA").val(parseInt($("#maximoB").val()) + 1);
				}
				$("#maximoA").focus();
				break;
		}
	}

}

function inactivaNivel() {

	var inabilitado = $("#nivelActivoM").is(":checked");

	if (inabilitado == true) {
		$("#maximoM").val(0);
		$("#minimoM").val(0);
		deshabilitaControl('maximoM');
		if (!isNaN(parseInt($("#maximoB").val()))) {
			$("#minimoA").val(parseInt($("#maximoB").val()) + 1);
		}
		$("#renglonM").hide();
		$("#maximoB").focus();
	} else {
		$("#maximoM").val('');
		$("#minimoM").val('');
		habilitaControl('maximoM');
		if (!isNaN(parseInt($("#maximoB").val()))) {
			$("#minimoM").val(parseInt($("#maximoB").val()) + 1);
		}
		$("#renglonM").show();
		$("#maximoM").focus();
	}
}

function verificaPuntajes() {

	var inabilitado = $("#nivelActivoM").is(":checked");

	if (parseInt($("#minimoB").val()) > parseInt($("#maximoB").val())) {
		$("#maximoB").focus();
		mensajeSis("El Porcentaje Mínimo no puede ser Mayor al Porcentaje Máximo");
		return false;
	}

	if (parseInt($("#minimoB").val()) == parseInt($("#maximoB").val())) {
		$("#maximoB").focus();
		mensajeSis("Los Porcentajes Mínimo y Máximo no Deben Ser Iguales");
		return false;
	}

	if (parseInt($("#minimoA").val()) > parseInt($("#maximoA").val())) {
		$("#maximoA").focus();
		mensajeSis("El Porcentaje Mínimo no puede ser Mayor al Porcentaje Máximo");
		return false;
	}

	if (parseInt($("#minimoA").val()) == parseInt($("#maximoA").val())) {
		$("#maximoA").focus();
		mensajeSis("Los Porcentajes Mínimo y Máximo no Deben Ser Iguales");
		return false;
	}

	//Si el nivel medio HABILITADO
	if (inabilitado != true) {

		if (parseInt($("#minimoM").val()) > parseInt($("#maximoM").val())) {
			$("#maximoM").focus();
			mensajeSis("El Porcentaje Mínimo no puede ser Mayor al Porcentaje Máximo");
			return false;
		}

		if (parseInt($("#minimoM").val()) == parseInt($("#maximoM").val())) {
			$("#maximoM").focus();
			mensajeSis("Los Porcentajes Mínimo y Máximo no Deben Ser Iguales");
			return false;
		}
	}

	// comprueba si el minimo es 0 y el máximo es 100
	if (parseInt($("#minimoB").val()) != 0 || parseInt($("#maximoA").val()) != 100) {
		$("#maximoB").focus();
		mensajeSis("Porcentajes No Válidos, Referencia:<br>Minimo : 0% <br> Máximo: 100%");
		return false;
	}
	//Comprueba si hay campos vacios
	if ($("#maximoB").val() == "") {
		mensajeSis("Por Favor Rellena Todos los Campos");
		$("#maximoB").focus();
		return false;
	}

	if ($("#maximoM").val() == "") {
		$("#maximoM").focus();
		mensajeSis("Por Favor Rellena Todos los Campos");
		return false;
	}

	return true;

}