var esTab = false;
var parametroBean = consultaParametrosSession();
var catTipoConsultaCredito = { 
	'principal'	: 1
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

	$('#formaGenerica').validate({
		rules : {
			fechaInicio : {
				required : true
			},
			fechaFinal : {
				required : true
			},
			sucursalID : {
				required : true
			},
			producCreditoID : {
				required : true
			}
		},
		messages : {
			fechaInicio : {
				required : 'La Fecha de Inicio es Requerida.',
			},
			fechaFinal : {
				required : 'La Fecha Fin es Requerida.',
			},
			sucursalID : {
				required : 'La Sucursal es Requerida.',
			},
			producCreditoID : {
				required : 'El Producto de Crédito es Requerido.',
			}
		}
	});
	$('#generar').click(function() {
		generaReporte();
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
  		consultaProducCredito(this.id);
	});
	$('#fechaInicio').change(function() {
		var Xfecha = $('#fechaInicio').val();
		if (esFechaValida(Xfecha)) {
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
				} else if ($("#sucursalID").val() == 0) {
					fechaFinal = sumaMesesFechaHabil($('#fechaInicio').val(), 1);
					if (fechaFinal > parametroBean.fechaSucursal) {
						fechaFinal = parametroBean.fechaSucursal;
					}
					if ($('#fechaFinal').val() > fechaFinal) {
						$('#fechaFinal').val(fechaFinal);
					}
				}
			}

		} else {
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaFinal').change(function() {
		if (!validacion.esFechaValida($('#fechaInicio').val())) {
			$('#fechaInicio').val('');
			$('#fechaInicio').focus();
		} else {
			var Xfecha = $('#fechaInicio').val();
			var Yfecha = $('#fechaFinal').val();
			if (esFechaValida(Yfecha)) {
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
					} else if ($('#sucursalID').asNumber()==0 && $('#fechaFinal').val() > fechaFinal) {
						$('#fechaFinal').val(fechaFinal);
					}
				}
			} else {
				$('#fechaFinal').val(parametroBean.fechaSucursal);
			}
		}
	});
});

function inicializarPantalla() {
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFinal').val(parametroBean.fechaSucursal);
	$('#sucursalID').val("0");
	$('#nombreSucursal').val("TODAS");
	$('#producCreditoID').val("0");
	$('#nombreProd').val("TODOS");
	agregaFormatoControles('formaGenerica');
	$('#fechaInicio').focus();
}

function generaReporte() {
	if ($("#formaGenerica").valid()) {
		var fechaInicio = $("#fechaInicio").val();
		var fechaFinal = $("#fechaFinal").val();
		var usuario = parametroBean.claveUsuario;
		var nombreInstitucion = parametroBean.nombreInstitucion;
		var tipoReporte = $('input:radio[name=tipoReporte]:checked').asNumber();
		var sucursal = $("#sucursalID").asNumber();
		var nombreSucursal = $("#nombreSucursal").val();
		var producCreditoID = $("#producCreditoID").asNumber();
		var nombreProd = $("#nombreProd").val();
		
		var liga = 'ReportePagosReferencia.htm?' +
			'fechaInicio=' + fechaInicio +
			'&fechaFinal=' + fechaFinal +
			'&sucursal=' + sucursal +
			'&nombreSucursal=' + nombreSucursal +
			'&producCreditoID=' + producCreditoID +
			'&nombreProducto=' + nombreProd+
			'&usuario=' + usuario +
			'&parFechaEmision=' + parametroBean.fechaSucursal +
			'&nombreInstitucion=' + nombreInstitucion +
			'&tipoReporte=' + tipoReporte;
			window.open(liga, '_blank');
	}
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

function consultaProducCredito(idControl) {
	var jqProdCred = eval("'#" + idControl + "'");
	var ProdCred = $(jqProdCred).val();
	var ProdCredBeanCon = {
		'producCreditoID' : ProdCred
	};
	setTimeout("$('#cajaLista').hide();", 200);

	if (ProdCred != '' && !isNaN(ProdCred) && esTab) {
		productosCreditoServicio.consulta(catTipoConsultaCredito.principal, ProdCredBeanCon, function(prodCred) {
			if (prodCred != null) {
				$('#nombreProd').val(prodCred.descripcion);
			} else {
				$('#producCreditoID').val("0");
				$('#nombreProd').val("TODOS");
			}
		});
	} else {
		$('#producCreditoID').val("0");
		$('#nombreProd').val("TODOS");
	}
}
function esFechaValida(fecha){

	if (fecha != undefined && fecha.value != "" ){
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)){
			mensajeSis("Formato de Fecha no Válido (aaaa-mm-dd)");
			return false;
		}

		var mes=  fecha.substring(5, 7)*1;
		var dia= fecha.substring(8, 10)*1;
		var anio= fecha.substring(0,4)*1;

		switch(mes){
		case 1: case 3:  case 5: case 7:
		case 8: case 10:
		case 12:
			numDias=31;
			break;
		case 4: case 6: case 9: case 11:
			numDias=30;
			break;
		case 2:
			if (comprobarSiBisisesto(anio)){ numDias=29 }else{ numDias=28};
			break;
		default:
			mensajeSis("Fecha Introducida Errónea");
		return false;
		}
		if (dia>numDias || dia==0){
			mensajeSis("Fecha Introducida Errónea");
			return false;
		}
		return true;
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
function comprobarSiBisisesto(anio){
	if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
		return true;
	}
	else {
		return false;
	}
}