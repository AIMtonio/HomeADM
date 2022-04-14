// js  DEL REPORTE DE ANALÍTICO CARTERA
// Definicion de Constantes y Enums
var esTab = true;
var atrasoInicial = 0;
var atrasoFinal = 99999;
var parametroBean = consultaParametrosSession();
comboClasificacionCredito();

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
		if (esFechaValida(Xfecha)) {

			if (Xfecha == '')
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha = parametroBean.fechaSucursal;
			if (mayor(Xfecha, Yfecha)) {
				mensajeSis("La Fecha es mayor a la fecha del sistema.");
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}
		} else {
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});
	$('#sucursal').bind('keyup', function(e) {
		lista('sucursal', '2', '1', 'nombreSucurs', $('#sucursal').val(), 'listaSucursales.htm');
	});
	$('#sucursal').blur(function() {
		consultaSucursal(this.id);
	});

	$('#promotorID').bind('keyup', function(e) {
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('promotorID', '1', '1', 'nombrePromotor', $('#promotorID').val(), 'listaPromotores.htm');
	});

	$('#estadoID').bind('keyup', function(e) {
		lista('estadoID', '2', '1', 'nombre', $('#estadoID').val(), 'listaEstados.htm');
	});

	$('#municipioID').bind('keyup', function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "estadoID";
		camposLista[1] = "nombre";

		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioID').val();

		lista('municipioID', '2', '1', camposLista, parametrosLista, 'listaMunicipios.htm');
	});

	$('#promotorID').blur(function() {
		consultaPromotorI(this.id);

	});

	$('#estadoID').blur(function() {
		consultaEstado(this.id);
	});

	$('#municipioID').blur(function() {
		consultaMunicipio(this.id);
	});
	
	$('#monedaID').bind('keyup', function(e) {
		lista('monedaID', '0', 2, 'monedaID', $('#monedaID').val(), 'listaMonedas.htm');
	});

	$('#monedaID').blur(function() {
		buscarDivisa(this.id);
	});
	
	$('#producCreditoID').bind('keyup',function(e){  
		lista('producCreditoID', '1', '3', 'descripcion', $('#producCreditoID').val(), '	listaProductosCredito.htm');
	});
	
	$('#producCreditoID').blur(function() {
  		consultaProducCredito(this.id);
	});

	$('#atrasoInicial').bind('keydown', function() {
		if (isNaN($('#atrasoInicial').val())) {
			if ($('#atrasoInicial').val().trim() != '') {
				$('#atrasoInicial').val(atrasoInicial);
			}

		} else {
			if (Number($('#atrasoInicial').val()) >= 0 && Number($('#atrasoInicial').val()) <= Number($('#atrasoFinal').val())) {
				atrasoInicial = Number($('#atrasoInicial').val());
			} else {
				$('#atrasoInicial').val(atrasoInicial);
			}

		}
	});

	$('#atrasoFinal').bind('keydown', function() {
		if (isNaN($('#atrasoFinal').val())) {
			if ($('#atrasoFinal').val().trim() != '') {
				$('#atrasoFinal').val(atrasoFinal);
			}
		} else {
			if (Number($('#atrasoFinal').val()) >= 0 && Number($('#atrasoInicial').val()) <= Number($('#atrasoFinal').val())) {
				atrasoFinal = Number($('#atrasoFinal').val());
			} else {
				$('#atrasoFinal').val(atrasoFinal);
			}
		}
	});

	$('#generar').click(function() {
		if ($('#pdf').is(":checked")) {
			generaPDF();
		}

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
	$('#atrasoInicial').val(atrasoInicial);
	$('#atrasoFinal').val(atrasoFinal);
	$('#promotorID').val('0');
	$('#nombrePromotorI').val('TODOS');
	$('#estadoID').val('0');
	$('#nombreEstado').val('TODOS');
	$('#municipioID').val('0');
	$('#nombreMuni').val('TODOS');
	
	$('#sucursal').val('0');
	$('#nombreSucursal').val('TODAS');
	$('#monedaID').val(0);
	$('#descripcion').val('TODAS');
	$('#producCreditoID').val("0");
	$('#nombreProd').val("TODOS");

	$('#excel').attr("checked", true);
	agregaFormatoControles('formaGenerica');
}
//***********  Inicio  validacion Promotor, Estado, Municipio  ***********
function consultaPromotorI(idControl) {
	var jqPromotor = eval("'#" + idControl + "'");
	var numPromotor = $(jqPromotor).val();
	var tipConForanea = 2;
	var promotor = {
		'promotorID' : numPromotor
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (numPromotor == '' || numPromotor == 0) {
		$(jqPromotor).val(0);
		$('#nombrePromotorI').val('TODOS');
	} else

	if (numPromotor != '' && !isNaN(numPromotor)) {
		promotoresServicio.consulta(tipConForanea, promotor, function(promotor) {
			if (promotor != null) {
				$('#nombrePromotorI').val(promotor.nombrePromotor);
			} else {
				mensajeSis("No Existe el Promotor");
				$(jqPromotor).val(0);
				$('#nombrePromotorI').val('TODOS');
			}
		});
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
				$('#sucursal').val(sucursal.sucursalID);
				$('#nombreSucursal').val(sucursal.nombreSucurs);
				$('#clienteID').val(0);
				$('#nombreCompleto').val('TODOS');
			} else {
				$('#sucursal').val('0');
				$('#nombreSucursal').val('TODAS');
			}
		});
	}
}
function consultaEstado(idControl) {
	var jqEstado = eval("'#" + idControl + "'");
	var numEstado = $(jqEstado).val();
	var tipConForanea = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numEstado == '' || numEstado == 0) {
		$('#estadoID').val(0);
		$('#nombreEstado').val('TODOS');

		var municipio = $('#municipioID').val();
		if (municipio != '' && municipio != 0) {
			$('#municipioID').val('');
			$('#nombreMuni').val('TODOS');
		}
	} else if (numEstado != '' && !isNaN(numEstado)) {
		estadosServicio.consulta(tipConForanea, numEstado, function(estado) {
			if (estado != null) {
				$('#nombreEstado').val(estado.nombre);

				var municipio = $('#municipioID').val();
				if (municipio != '' && municipio != 0) {
					consultaMunicipio('municipioID');
				}

			} else {
				mensajeSis("No Existe el Estado");
				$('#estadoID').val(0);
				$('#nombreEstado').val('TODOS');
			}
		});
	}
}

function consultaMunicipio(idControl) {
	var jqMunicipio = eval("'#" + idControl + "'");
	var numMunicipio = $(jqMunicipio).val();
	var numEstado = $('#estadoID').val();
	var tipConForanea = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numMunicipio == '' || numMunicipio == 0 || numEstado == '' || numEstado == 0) {

		if (numEstado == '' || numEstado == 0 && numMunicipio != 0) {
			mensajeSis("No ha selecionado ningún estado.");
			$('#estadoID').focus();
		}
		$('#municipioID').val(0);
		$('#nombreMuni').val('TODOS');
	} else if (numMunicipio != '' && !isNaN(numMunicipio)) {
		municipiosServicio.consulta(tipConForanea, numEstado, numMunicipio, function(municipio) {
			if (municipio != null) {
				$('#nombreMuni').val(municipio.nombre);

			} else {
				mensajeSis("No Existe el Municipio");
				$('#municipioID').val(0);
				$('#nombreMuni').val('TODOS');
			}
		});
	}
}

function generaExcel() {
	$('#pdf').attr("checked", false);
	$('#pantalla').attr("checked", false);
	if ($('#excel').is(':checked')) {

		var tr = catTipoRepSalTCredito.saldoTotalExcel;
		var tl = catTipoListaRepSalTCred.saldoTotalExcel;

		var fechaInicio = $('#fechaInicio').val();
		var sucursal = $("#sucursal").val();
		var moneda = $("#monedaID").val();
		var producto = $("#producCreditoID").val();
		var genero = $("#sexo option:selected").val();
		var nombrePromotorI = $('#nombrePromotorI').val();
		var nombreEstado = $('#nombreEstado').val();
		var nombreMuni = $('#nombreMuni').val();
		var nombreMoneda = $("#descripcion").val();
		var nombreProducto = $("#nombreProd").val();
		var nombreGenero = $("#sexo option:selected").val();
		var nombreSucursal = $('#nombreSucursal').val();
		var nombreInstitucion = parametroBean.nombreInstitucion;
		var usuario = parametroBean.numeroUsuario;
		var nombreUsuario = parametroBean.nombreUsuario;
		var promotorID = $('#promotorID').val();

		var estadoID = $('#estadoID').val();
		var municipioID = $('#municipioID').val();
		var fechaEmision = parametroBean.fechaSucursal;
		var atrasoInicial = $('#atrasoInicial').val();
		var atrasoFinal = $('#atrasoFinal').val();

		if (genero == '0') {
			genero = '';
		}

		$('#ligaGenerar').attr('href', 'RepSaldosTotalesCreditoAgro.htm?'+
			'fechaInicio=' + fechaInicio +
			'&monedaID=' + moneda +
			'&sucursal=' + sucursal +
			'&producCreditoID=' + producto +
			'&usuario=' + usuario +
			'&tipoReporte=' + tr +
			'&tipoLista=' + tl +
			'&promotorID=' + promotorID +
			'&sexo=' + genero +
			'&estadoID=' + estadoID +
			'&municipioID=' + municipioID +
			'&nombreUsuario=' + nombreUsuario +
			'&clasificacion=' + $('#clasificacion').val() +
			'&atrasoInicial=' + atrasoInicial +
			'&atrasoFinal=' + atrasoFinal +
			'&parFechaEmision=' + fechaEmision +
			'&nombrePromotorI=' + nombrePromotorI +
			'&nombreEstado=' + nombreEstado +
			'&nombreMuni=' + nombreMuni +
			'&nombreMoneda=' + nombreMoneda +
			'&nombreProducto=' + nombreProducto +
			'&nombreGenero=' + nombreGenero +
			'&nombreSucursal=' + nombreSucursal +
			'&nombreInstitucion=' + nombreInstitucion);
	}
}

function generaPDF() {

	if ($('#pdf').is(':checked')) {
		$('#pantalla').attr("checked", false);
		$('#excel').attr("checked", false);
		var tr = catTipoRepSalTCredito.saldoTotalPDF;

		var fechaInicio = $('#fechaInicio').val();
		var sucursal = $("#sucursal").val();
		var moneda = $("#monedaID").val();
		var producto = $("#producCreditoID").val();
		var usuario = parametroBean.claveUsuario;
		var promotorID = $('#promotorID').val();
		var genero = $("#sexo option:selected").val();
		var estadoID = $('#estadoID').val();
		var municipioID = $('#municipioID').val();

		/// VALORES TEXTO
		var nombreSucursal = $("#sucursal").val();
		var nombreMoneda = $("#descripcion").val();
		var nombreProducto = $("#nombreProd").val();
		var nombreUsuario = parametroBean.nombreUsuario;
		var nombrePromotor = $('#nombrePromotorI').val();
		var nombreGenero = $("#sexo option:selected").val();
		var nombreEstado = $('#nombreEstado').val();
		var nombreMunicipio = $('#nombreMuni').val();
		var nombreInstitucion = parametroBean.nombreInstitucion;

		var atrasoInicial = $('#atrasoInicial').val();
		var atrasoFinal = $('#atrasoFinal').val();


		if (nombreGenero == '0') {
			nombreGenero = '';
		} else {
			nombreGenero = $("#sexo option:selected").html();
		}
		if (genero == '0') {
			genero = '';
		}
		$('#ligaGenerar').attr('href', 'RepSaldosTotalesCreditoAgro.htm?'+
			'fechaInicio=' + fechaInicio +
			'&monedaID=' + moneda +
			'&sucursal=' + sucursal +
			'&producCreditoID=' + producto +
			'&usuario=' + usuario +
			'&tipoReporte=' + tr +
			'&promotorID=' + promotorID +
			'&sexo=' + genero +
			'&estadoID=' + estadoID +
			'&municipioID=' + municipioID +
			'&nombreSucursal=' + nombreSucursal +
			'&nombreMoneda=' + nombreMoneda +
			'&nombreProducto=' + nombreProducto +
			'&nombreUsuario=' + nombreUsuario +
			'&nombrePromotor=' + nombrePromotor +
			'&nombreGenero=' + nombreGenero +
			'&nombreEstado=' + nombreEstado +
			'&nombreMunicipi=' + nombreMunicipio +
			'&nombreInstitucion=' + nombreInstitucion +
			'&atrasoInicial=' + atrasoInicial +
			'&atrasoFinal=' + atrasoFinal);
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
					numDias = 29
				} else {
					numDias = 28
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

//funcion para llenar el combo de creditos por clientes
function comboClasificacionCredito() {
	var credBean = {
		'descripClasifica' : ''
	};
	dwr.util.removeAllOptions('clasificacion');
	dwr.util.addOptions('clasificacion', {
		'0' : 'TODAS'
	});
	clasificCreditoServicio.listaCombo(2, credBean, function(combo) {
		if (combo != null) {
			dwr.util.addOptions('clasificacion', combo, 'clasificacionID', 'descripClasifica');
		}
	});
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
				$('#monedaID').focus();
				$('#monedaID').val(0);
				$('#descripcion').val('TODAS');
			}
		});

	} else {
		$('#monedaID').val(0);
		$('#descripcion').val('TODAS');
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