var esTab = false;
var tipoReporte = "";
$(document).ready(function () {

	var catTipoConsulta = {
		'principal': 1
	};

	var catTipoListaSucursal = {
		'combo': 2
	};

	var parametros = consultaParametrosSession();
	$('#usuario').val(parametros.claveUsuario); // parametros del sesion para el reporte
	$('#nombreInstitucion').val(parametros.nombreInstitucion);
	$('#fechaSistema').val(parametroBean.fechaSucursal);
	$('#excel').attr("checked", true);

	var maximoValorDecimal = 999999999999.99;

	// ----------------------------------- Metodos y Eventos -----------------------------
	agregaFormatoControles('formaGenerica');

	inicializaCampos();

	$(':text').focus(function () {
		esTab = false;
	});

	$(':text').bind('keydown', function (e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$.validator.setDefaults({
		submitHandler: function (event) {

		}
	});

	$('#fechaInicio').blur(function () {
		var Xfecha = $('#fechaInicio').val();
		var Zfecha = parametroBean.fechaSucursal;
		if (esFechaValida(Xfecha)) {
			if (Xfecha == '') $('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha = $('#fechaFin').val();
			if (Yfecha != '') {
				if (mayor(Xfecha, Yfecha)) {
					mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.");
					$('#fechaInicio').val(parametroBean.fechaSucursal);
				}
			}
		} else {
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}

	});

	$('#fechaInicio').change(function () {
		var Xfecha = $('#fechaInicio').val();
		if (esFechaValida(Xfecha)) {
			if (Xfecha == '') $('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha = $('#fechaFin').val();
			if (Yfecha != '') {
				if (mayor(Xfecha, Yfecha)) {
					mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.");
					$('#fechaInicio').val(parametroBean.fechaSucursal);
				}
			}
		} else {
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaFin').blur(function () {
		var Xfecha = $('#fechaInicio').val();
		var Yfecha = $('#fechaFin').val();
		if (esFechaValida(Yfecha)) {
			if (Yfecha == '') $('#fechaFin').val(parametroBean.fechaSucursal);
			if (mayor(Xfecha, Yfecha)) {
				mensajeSis("La Fecha de Fin es menor a la Fecha de Inicio.");
				$('#fechaFin').val(Xfecha);
			}
		} else {
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaFin').change(function () {
		var Xfecha = $('#fechaInicio').val();
		var Yfecha = $('#fechaFin').val();
		if (esFechaValida(Yfecha)) {
			if (Yfecha == '') $('#fechaFin').val(parametroBean.fechaSucursal);

			if (mayor(Xfecha, Yfecha)) {
				mensajeSis("La Fecha de Fin es menor a la Fecha de Inicio.");
				$('#fechaFin').val(Xfecha);
			} else {
				if ($('#fechaFin').val() > parametroBean.fechaSucursal) {
					mensajeSis("La Fecha de Fin  es Mayor a la Fecha Actual.");
					$('#fechaFin').val(parametroBean.fechaSucursal);
				}
			}
		} else {
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}
	});

	$('#generar').click(function () {
		listaBitacoraRecepciones();
	});

	$('#formaGenerica').validate({
		rules: {
			fechaInicio: {
				required: true
			},
			fechaFinal: {
				required: true
			}
		},
		messages: {
			fechaInicio: {
				required: 'La Fecha de Inicio es Requerida.',
			},
			fechaFinal: {
				required: 'La Fecha Final es Requerida.',
			}
		}
	});

	function listaBitacoraRecepciones() {
		var speiRecepcionesPenBit = {
			'tipoLista':1,
			'fechaInicio':$('#fechaInicio').val(),
			'fechaFin':$('#fechaFin').val()
		};


		$.post("speiRecepcionesPenBitGrid.htm", speiRecepcionesPenBit, function(data) {
			$("#divRecepcionesPenBitGrid").html(data);
		});
	}
});

function inicializaCampos() {
	$('#fechaFin').val(parametroBean.fechaAplicacion);
	$('#fechaInicio').val(parametroBean.fechaAplicacion);
	$('#fechaInicio').focus();
}

//	VALIDACIONES PARA LAS PANTALLAS DE REPORTE

function mayor(fecha, fecha2) {
	//0|1|2|3|4|5|6|7|8|9|
	//2 0 1 2 / 1 1 / 2 0
	var xMes = fecha.substring(5, 7);
	var xDia = fecha.substring(8, 10);
	var xAnio = fecha.substring(0, 4);

	var yMes = fecha2.substring(5, 7);
	var yDia = fecha2.substring(8, 10);
	var yAnio = fecha2.substring(0, 4);



	if (xAnio > yAnio) {
		return true;
	} else {
		if (xAnio == yAnio) {
			if (xMes > yMes) {
				return true;
			}
			if (xMes == yMes) {
				if (xDia > yDia) {
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		} else {
			return false;
		}
	}
}

/*funcion valida fecha formato (yyyy-MM-dd)*/
function esFechaValida(fecha) {
	if (fecha != undefined && fecha.value != "") {
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)) {
			mensajeSis("Formato de Fecha no Válida (aaaa-mm-dd)");
			return false;
		}
		var mes = fecha.substring(5, 7) * 1;
		var dia = fecha.substring(8, 10) * 1;
		var anio = fecha.substring(0, 4) * 1;

		switch (mes) {
			case 1:
			case 3:
			case 5:
			case 7:
			case 8:
			case 10:
			case 12:
				numDias = 31;
				break;
			case 4:
			case 6:
			case 9:
			case 11:
				numDias = 30;
				break;
			case 2:
				if (comprobarSiBisisesto(anio)) {
					numDias = 29
				} else {
					numDias = 28
				};
				break;
			default:
				mensajeSis("Fecha introducida errónea");
				return false;
		}
		if (dia > numDias || dia == 0) {
			mensajeSis("Fecha introducida errónea");
			return false;
		}
		return true;
	}
}

function comprobarSiBisisesto(anio) {
	if ((anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
		return true;
	} else {
		return false;
	}
}


function soloLetrasYNum(idControl, campo) {
	if (!/^([a-zA-Z0-9])*$/.test(campo)) {
		mensajeSis("Solo caracteres alfanuméricos");
		$('#' + idControl).focus();
		$('#' + idControl).val('');
	}
}