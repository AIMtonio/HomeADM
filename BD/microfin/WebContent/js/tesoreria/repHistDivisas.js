var esTab = false;
var parametroBean = consultaParametrosSession();
$(document).ready(function() {
	inicializarPantalla();
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});

	$('#formaGenerica').validate({
	rules : {
	fechaInicio : {
		required : true
	},
	fechaFinal : {
		required : true
	},
	},
	messages : {
	fechaInicio : {
		required : 'La Fecha de Inicio es Requerida.',
	},
	fechaFinal : {
		required : 'La Fecha Final es Requerida.',
	}
	}
	});

	$('#monedaId').bind('keyup', function(e) {
		lista('monedaId', '0', 2, 'monedaID', $('#monedaId').val(), 'listaMonedas.htm');
	});

	$('#monedaId').blur(function() {
		buscarDivisa(this.id);
	});

	$('#fechaInicio').change(function() {
		var Xfecha = $('#fechaInicio').val();
		if (validacion.esFechaValida(Xfecha)) {
			if (Xfecha == '') {
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}

			var Yfecha = $('#fechaFinal').val();
			if (mayor(Xfecha, Yfecha)) {
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.");
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			} else {
				if ($('#fechaInicio').val() > parametroBean.fechaSucursal) {
					mensajeSis("La Fecha de Inicio es Mayor a la Fecha del Sistema.");
					$('#fechaInicio').val(parametroBean.fechaSucursal);
				}
			}
		} else {
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaFinal').change(function() {
		var Xfecha = $('#fechaInicio').val();
		var Yfecha = $('#fechaFinal').val();
		if (validacion.esFechaValida(Yfecha)) {
			if (Yfecha == '') {
				$('#fechaFinal').val(parametroBean.fechaSucursal);
			}
			if (mayor(Xfecha, Yfecha)) {
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.");
				$('#fechaFinal').val(parametroBean.fechaSucursal);
			} else {
				if ($('#fechaFinal').val() > parametroBean.fechaSucursal) {
					mensajeSis("La Fecha de Fin  es Mayor a la Fecha del Sistema.");
					$('#fechaFinal').val(parametroBean.fechaSucursal);
				}
			}
		} else {
			$('#fechaFinal').val(parametroBean.fechaSucursal);
		}

	});
	$('#generar').click(function() {
		generaReporte();
	});

});

function inicializarPantalla() {
	$('#fechaFinal').val(parametroBean.fechaAplicacion);
	$('#fechaInicio').val(parametroBean.fechaAplicacion);
	$('#monedaId').val(0);
	$('#descripcion').val('TODAS');
	agregaFormatoControles('formaGenerica');
	$('#fechaInicio').focus();
}

function generaReporte() {
	if ($("#formaGenerica").valid()) {
		var fechaInicio = $("#fechaInicio").val();
		var fechaFinal = $("#fechaFinal").val();
		var moneda = $("#monedaId").val();
		var descripcion = $("#descripcion").val();
		var usuario = parametroBean.claveUsuario;
		var nombreInstitucion = parametroBean.nombreInstitucion;
		var fechaAplicacion = parametroBean.fechaAplicacion;
		var tipoReporte = $('input:radio[name=tipoReporte]:checked').val();

		var liga = 'reporteHistDivisas.htm?' + 'fechaInicio=' + fechaInicio + '&fechaFinal=' + fechaFinal
		+ '&monedaId=' + moneda
		+ '&descripcion=' + descripcion
		+ '&nomUsuario=' + usuario
		+ '&fechaSistema=' + fechaAplicacion 
		+ '&nomInstitucion=' + nombreInstitucion 
		+ '&tipoReporte=' + tipoReporte;
		window.open(liga, '_blank');
	}
}

function buscarDivisa(monedaID) {
	var monedaid = eval("'#" + monedaID + "'");
	var monedaNum = $(monedaid).val();
	if (monedaNum > 0) {
		var divisaBean = {
			'monedaId' : monedaNum
		};
		divisasServicio.consultaExisteDivisa(3, divisaBean, function(divisa) {
			if (divisa != null) {
				$("#descripcion").val(divisa.descripcion);
			} else {
				mensajeSis("No Existe la Divisa.");
				$('#monedaId').focus();
				$('#monedaId').val(0);
				$('#descripcion').val('TODAS');
			}
		});

	} else {
		$('#monedaId').val(0);
		$('#descripcion').val('TODAS');
	}
}
function mayor(fecha, fecha2){
	//0|1|2|3|4|5|6|7|8|9|
	//2 0 1 2 / 1 1 / 2 0
	var xMes=fecha.substring(5, 7);
	var xDia=fecha.substring(8, 10);
	var xAnio=fecha.substring(0,4);

	var yMes=fecha2.substring(5, 7);
	var yDia=fecha2.substring(8, 10);
	var yAnio=fecha2.substring(0,4);

	if (xAnio > yAnio){
		return true;
	}else{
		if (xAnio == yAnio){
			if (xMes > yMes){
				return true;
			}
			if (xMes == yMes){
				if (xDia > yDia){
					return true;
				}else{
					return false;
				}
			}else{
				return false;
			}
		}else{
			return false ;
		}
	} 
}