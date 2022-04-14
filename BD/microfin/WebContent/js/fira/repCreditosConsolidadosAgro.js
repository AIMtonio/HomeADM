// Definicion de Constantes y Enums
var esTab = true;
var parametroBean = consultaParametrosSession();

var catTipoListaRepSalTCred = {
	'saldoTotalExcel' : 3
};

var catTipoRepConsolidaCredito = {
'consolidaPDF' : 1
};
var catTipoConsultaCredito = {
	'principal'	: 1
};

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
		if (esFechaValida(Xfecha)) {

			if (Xfecha == '')
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha = parametroBean.fechaSucursal;
			if (mayor(Xfecha, Yfecha)) {
				mensajeSis("La Fecha es mayor a la fecha del sistema.");
				$('#fechaInicio').val(parametroBean.fechaSucursal);
				$('#fechaInicio').focus();
			}
		} else {
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaFin').change(function() {
		var Xfecha= parametroBean.fechaSucursal;
		var Yfecha= $('#fechaFin').val();
		var Zfecha= $('#fechaInicio').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha==''){
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}
			if ( mayor(Yfecha,Xfecha) ){
				mensajeSis("La Fecha Final es mayor a la Fecha Actual.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
				$('#fechaFin').focus();
			}
			if ( mayor(Zfecha,Yfecha) ){
				mensajeSis("La Fecha de Final es menor a la Fecha Inicial.")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
				$('#fechaFin').focus();
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}
	});

	$('#sucursal').bind('keyup', function(e) {
		lista('sucursal', '2', '1', 'nombreSucurs', $('#sucursal').val(), 'listaSucursales.htm');
	});
	
	$('#sucursal').blur(function() {
		consultaSucursal(this.id);
	});

	$('#producCreditoID').bind('keyup',function(e){
		lista('producCreditoID', '1', '10', 'descripcion', $('#producCreditoID').val(), 'listaProductosCredito.htm');
	});

	$('#producCreditoID').blur(function() {
  		consultaProducCredito(this.id);
	});

	$('#generar').click(function() {
		if ($('#pdf').is(":checked")) {
			generaPDF();
		}
	});

	$('#formaGenerica').validate({
		rules: {
			fechaInicio :{
				required: true,
			},
			fechaFin :{
				required: true
			}
		},

		messages: {
			fechaInicio :{
				required: 'Ingrese la Fecha de Inicio',
			}
			,fechaFin :{
				required: 'Ingrese la Fecha Final'
			}
		}
	});

});

function inicializa(){
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);

	$('#sucursal').val('0');
	$('#nombreSucursal').val('TODAS');

	$('#producCreditoID').val("0");
	$('#nombreProd').val("TODOS");

	$('#estatus').val("T");

	$('#pdf').attr("checked", true);
	$('#fechaInicio').focus();
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
				$('#sucursal').val(sucursal.sucursalID);
				$('#nombreSucursal').val(sucursal.nombreSucurs);
			} else {
				$('#sucursal').val('0');
				$('#nombreSucursal').val('TODAS');
			}
		});
	}
}

function generaPDF() {

	if ($('#pdf').is(':checked')) {
		var tr = catTipoRepConsolidaCredito.consolidaPDF;

		var fechaInicio = $('#fechaInicio').val();
		var fechaFin = $('#fechaFin').val();
		var sucursal = $("#sucursal").val();
		var producto = $("#producCreditoID").val();
		var estatus = $("#estatus").val();
		var usuario = 	parametroBean.claveUsuario;

		var descripcionEstatus = $("#estatus option:selected").html();
		if(estatus == ''){
			descripcionEstatus = 'TODOS';
		}else{
			descripcionEstatus = $("#estatus option:selected").html();
		}

		/// VALORES TEXTO
		var nombreSucursal = $("#nombreSucursal").val();
		var nombreProducto = $("#nombreProd").val();
		var nombreUsuario = parametroBean.claveUsuario;
		var nombreInstitucion = parametroBean.nombreInstitucion;

		$('#ligaGenerar').attr('href', 'RepCreditoConsolidadoAgro.htm?'+
			'fechaInicio=' + fechaInicio +
			'&fechaFin=' + fechaFin +
			'&sucursal=' + sucursal +
			'&producCreditoID=' + producto +
			'&estatus=' + estatus +
			'&estatusCred=' + descripcionEstatus +
			'&usuario=' + usuario +
			'&tipoReporte=' + tr +
			'&nombreSucursal=' + nombreSucursal +
			'&nombreProducto=' + nombreProducto +
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
//	FIN VALIDACIONES DE REPORTES

/*funcion valida fecha formato (yyyy-MM-dd)*/
function esFechaValida(fecha) {

	if (fecha != undefined && fecha.value != "") {
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)) {
			mensajeSis("formato de fecha no válido (aaaa-mm-dd)");
			return false;
		}

		var mes = fecha.substring(5, 7) * 1;
		var dia = fecha.substring(8, 10) * 1;
		var anio = fecha.substring(0, 4) * 1;

		switch (mes) {
			case 1 :
			case 3 :
			case 5 :
			case 7 :
			case 8 :
			case 10 :
			case 12 :
				numDias = 31;
				break;
			case 4 :
			case 6 :
			case 9 :
			case 11 :
				numDias = 30;
				break;
			case 2 :
				if (comprobarSiBisisesto(anio)) {
					numDias = 29;
				} else {
					numDias = 28;
				}
				;
				break;
			default :
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

function consultaProducCredito(idControl) {
	var jqProdCred = eval("'#" + idControl + "'");
	var ProdCred = $(jqProdCred).val();
	var ProdCredBeanCon = {
		'producCreditoID' : ProdCred
	};
	setTimeout("$('#cajaLista').hide();", 200);

	if (ProdCred != '' && !isNaN(ProdCred) && esTab && ProdCred != '0') {
		productosCreditoServicio.consulta(catTipoConsultaCredito.principal, ProdCredBeanCon, function(prodCred) {
			if (prodCred != null) {
				$('#nombreProd').val(prodCred.descripcion);
			} else {
				mensajeSis("No Existe el Producto de Credito");
				$('#producCreditoID').val("0");
				$('#nombreProd').val("TODOS");
			}
		});
	}
}