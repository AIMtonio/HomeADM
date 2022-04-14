// js  DEL REPORTE DE ANALÍTICO CARTERA
// Definicion de Constantes y Enums
var esTab = true;
var parametroBean = consultaParametrosSession();

var catTipoListaRepSalTCred = {
	'saldoTotalExcel' : 3
};

var catTipoRepSalTCredito = {
'salTotalPantalla' : 1,
'saldoTotalPDF' : 2,
'saldoTotalExcel' : 3
};
var catTipoConsultaCredito = { 
	'principal'	: 1
};	 
var parametroBean = consultaParametrosSession();
$(document).ready(function() {
	inicializa();
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$('#fechaInicio').change(function() {
		var Xfecha = $('#fechaInicio').val();
		if (validacion.esFechaValida(Xfecha)) {
			var Yfecha = parametroBean.fechaSucursal;
			if (mayor(Xfecha, Yfecha)) {
				mensajeSis("La Fecha es mayor a la fecha del sistema.");
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
		} else {
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#generar').click(function() {
		if ($('#excel').is(":checked")) {
			generaExcel();
		}
	});
	$('#formaGenerica').validate({
	rules : {
	atrasoInicial : {
		required : true
	},
	atrasoFinal : {
		required : true
	}
	},
	messages : {
	remesaCatalogoID : {
		required : 'Especifica Días de Atraso Inicial.'
	},
	nombre : {
		required : 'Especifica Días de Atraso Final.'
	}
	}
	});

});
function inicializa(){
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaInicio').focus();
	$('#excel').attr("checked", true);
	agregaFormatoControles('formaGenerica');
}


function generaExcel() {
	if ($('#excel').is(':checked')) {

		var tr = catTipoRepSalTCredito.saldoTotalExcel;
		var tl = catTipoListaRepSalTCred.saldoTotalExcel;

		var fechaInicio = $('#fechaInicio').val();
		var nombreInstitucion = parametroBean.nombreInstitucion;
		var usuario = parametroBean.numeroUsuario;
		var nombreUsuario = parametroBean.nombreUsuario;
		var fechaEmision = parametroBean.fechaSucursal;
		var hora = '';
		var horaEmision = new Date();
		hora = horaEmision.getHours();
		if (horaEmision.getMinutes() < 10) {
			hora = hora + ':' + '0' + horaEmision.getMinutes();
		} else {
			hora = hora + ':' + horaEmision.getMinutes();
		}

		$('#ligaGenerar').attr('href', 'RepSaldosTotalesCreditoContAgro.htm?'+
			'fechaInicio=' + fechaInicio +
			'&usuario=' + usuario +
			'&tipoReporte=' + tr +
			'&tipoLista=' + tl +
			'&hora=' + hora +
			'&FechaSistema=' + fechaEmision +
			'&nombreUsuario=' + nombreUsuario +
			'&nombreInstitucion=' + nombreInstitucion);
	}
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