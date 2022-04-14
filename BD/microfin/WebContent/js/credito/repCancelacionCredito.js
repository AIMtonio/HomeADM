var esTab = false;
var parametrosBean = consultaParametrosSession();
var catTipoConsultaCredito = {
'principal' : 1,
'foranea' : 2
};

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
	$.validator.setDefaults({
		submitHandler : function(event) {
			generaExcel();
		}
	});
	$('#formaGenerica').validate({
		rules : {
			fechaInicio : {
				required : true
			},
			fechaFinal : {
				required : true
			}
		},
		messages : {
			fechaInicio : {
				required : 'La Fecha Inicio es requerida.',
			},
			fechaFinal: {
				required: 'La Fecha Final es requerida.'
			}
		}
	});
	$('#fechaInicio').change(function() {
		var Xfecha = $('#fechaInicio').val();
		if (validacion.esFechaValida(Xfecha)) {
			if (Xfecha == '') {
				$('#fechaInicio').val(parametrosBean.fechaSucursal);
			}

			var Yfecha = $('#fechaFinal').val();
			if (mayor(Xfecha, Yfecha)) {
				mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.");
				$('#fechaInicio').val(parametrosBean.fechaSucursal);
			} else {
				if ($('#fechaInicio').val() > parametrosBean.fechaSucursal) {
					mensajeSis("La Fecha de Inicio es Mayor a la Fecha del Sistema.");
					$('#fechaInicio').val(parametrosBean.fechaSucursal);
				} else if ($("#sucursalID").val() == 0) {
					fechaFinal = sumaMesesFechaHabil($('#fechaInicio').val(), 1);
					if (fechaFinal > parametrosBean.fechaSucursal) {
						fechaFinal = parametrosBean.fechaSucursal;
					}
					if ($('#fechaFinal').val() > fechaFinal) {
						$('#fechaFinal').val(fechaFinal);
					}
				}
			}

		} else {
			$('#fechaInicio').val(parametrosBean.fechaSucursal);
		}
	});

	$('#fechaFinal').change(function() {
		if (!validacion.esFechaValida($('#fechaInicio').val())) {
			$('#fechaInicio').val('');
			$('#fechaInicio').focus();
		} else {
			var Xfecha = $('#fechaInicio').val();
			var Yfecha = $('#fechaFinal').val();
			if (validacion.esFechaValida(Yfecha)) {
				if (Yfecha == '') {
					$('#fechaFinal').val(parametrosBean.fechaSucursal);
				}
				if (mayor(Xfecha, Yfecha)) {
					mensajeSis("La Fecha de Inicio es mayor a la Fecha de Fin.");
					$('#fechaFinal').val(parametrosBean.fechaSucursal);
				} else {
					if ($('#fechaFinal').val() > parametrosBean.fechaSucursal) {
						mensajeSis("La Fecha de Fin  es Mayor a la Fecha del Sistema.");
						$('#fechaFinal').val(parametrosBean.fechaSucursal);
					} else if ($('#sucursalID').asNumber()==0 && $('#fechaFinal').val() > fechaFinal) {
						$('#fechaFinal').val(fechaFinal);
					}
				}
			} else {
				$('#fechaFinal').val(parametrosBean.fechaSucursal);
			}
		}
	});
	$('#sucursalID').bind('keyup', function(e) {
		lista('sucursalID', '2', '1', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});
	$('#sucursalID').blur(function() {
		consultaSucursal(this.id);
	});
	
	$('#producCreditoID').bind('keyup',function(e){  
		lista('producCreditoID', '1', '3', 'descripcion', $('#producCreditoID').val(), '	listaProductosCredito.htm');
	});
	
	$('#producCreditoID').blur(function() {
		consultaProducCreditoForanea($('#producCreditoID').val());
	});
	
	$('#generar').click(function() {
		generaExcel();
	});
	
});

function inicializarPantalla() {
	$("#fechaInicio").focus();
	$('#fechaInicio').val(parametrosBean.fechaSucursal);
	$('#fechaFinal').val(parametrosBean.fechaSucursal);
	$('#producCreditoID').val("0");
	$('#nombreProducto').val("TODOS");
	$('#sucursalID').val("0");
	$('#nombreSucursal').val("TODAS");
	agregaFormatoControles('formaGenerica');
}

function consultaSucursal(idControl) {
	var jqSucursal = eval("'#" + idControl + "'");
	var numSucursal = $(jqSucursal).val();
	var conSucursal = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numSucursal != '' && !isNaN(numSucursal)) {
		sucursalesServicio.consultaSucursal(conSucursal, numSucursal, function(sucursal) {
			if (sucursal != null) {
				$('#sucursalID').val(sucursal.sucursalID);
				$('#nombreSucursal').val(sucursal.nombreSucurs);
			} else {
				$('#sucursalID').val('0');
				$('#nombreSucursal').val('TODAS');
			}
		});
	} else {
		$('#sucursalID').val('0');
		$('#nombreSucursal').val('TODAS');
	}
}

function consultaProducCreditoForanea(producto) {
	var ProdCredBeanCon = {
		'producCreditoID' : producto
	};
	if (producto != '' && !isNaN(producto)) {
		productosCreditoServicio.consulta(1, ProdCredBeanCon, function(prodCred) {
			if (prodCred != null) {
				$('#nombreProducto').val(prodCred.descripcion);
			} else {
				$('#producCreditoID').val("0");
				$('#nombreProducto').val("TODOS");
			}
		});
	} else {
		$('#producCreditoID').val("0");
		$('#nombreProducto').val("TODOS");
	}
}

function generaExcel(){

	var fechaInicio = $('#fechaInicio').val();
	var fechaFinal = $('#fechaFinal').val();
	var sucursal = $("#sucursalID").val();
	var nombreSucursal = $('#nombreSucursal').val();
	var producto = $("#producCreditoID").val();
	var nombreProducto = $("#nombreProducto").val();
	
	var nombreInstitucion = parametroBean.nombreInstitucion;
	var usuario = parametroBean.numeroUsuario;
	var nombreUsuario = parametroBean.claveUsuario.toUpperCase();
	var fechaEmision = parametroBean.fechaSucursal;

	var liga = 'ReporteCreditosCancelados.htm?'+
		'fechaInicio=' + fechaInicio +
		'&fechaFinal=' + fechaFinal +
		'&sucursalID=' + sucursal +
		'&nombreSucursal=' + nombreSucursal +
		'&producCreditoID=' + producto +
		'&nombreProducto=' + nombreProducto +
		'&usuario=' + usuario +
		'&tipoReporte=' + 1 +
		'&tipoLista=' + 17 +
		'&nombreUsuario=' + nombreUsuario +
		'&parFechaEmision=' + fechaEmision +
		'&nombreInstitucion=' + nombreInstitucion;
	window.open(liga, '_blank');
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