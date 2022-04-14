$(document).ready(function() {
var charEstatus = "";
agregaFormatoControles('formaGenerica');

$('#estatus').change(function() {
	if ($('#estatus').val() == 1) {
		charEstatus = "V";
	} else if ($('#estatus').val() == 2) {
		charEstatus = "C";
	}
});

$('#buscar').click(function() {
	if ($('#opcionFiscal').is(':checked')) {
		if ($('#folioFiscal').val() != "") {
			var params = {};
			params['tipoLista'] = 2;
			params['folioFiscal'] = $(
					'#folioFiscal').val();
			mostrarGrid(params);
		} else {
			alert("Especifique un número de Folio Fiscal");
			$('#folioFiscal').focus();
			$('#gridCancelaFactura').hide();
		}
	} else {
		if ($('#fechaInicio').val() != ""&& $('#fechaFin').val() != "") {
			if ($('#fechaInicio').val() <= $('#fechaFin').val() != "") {
				var rfc =$('#rfcReceptor').val(); 
				if ( rfc.length > 0 && rfc.length < 12){
					alert("El RFC Receptor debe ser mínimo de 12 caracteres ");
					$('#rfcReceptor').focus();
					
				}else{
					var params = {};
					params['tipoLista'] = 3;
					params['fechaInicio'] = $('#fechaInicio').val();
					params['fechaFin'] = $('#fechaFin').val();
					if ($('#rfcReceptor').val() == '') {
						params['rfcReceptor'] = ' ';
					} else {
						params['rfcReceptor'] = $('#rfcReceptor').val();
					}
					if ($('#estatus').val() == '') {
						params['estatus'] = ' ';
					} else {
						params['estatus'] = charEstatus;
					}
					mostrarGrid(params);
				}
			} else {
				alert("La Fecha de Inicio debe ser menor a la Fecha de Fin");
				$('#fechaInicio').focus();
				$('#gridCancelaFactura').hide();
				
			}

		} else {
			if ($('#fechaInicio').val() == "") {
				alert("Especifique una Fecha de Inicio");
				$('#fechaInicio').focus();
				$('#gridCancelaFactura').hide();
			} else if ($('#fechaFin').val() == "") {
				alert("Especifique una Fecha de Fin");
				$('#fechaFin').focus();
				$('#gridCancelaFactura').hide();
			}
		}
	}
});

	$('#folioFiscal').bind('keyup',function(e) {
		lista('folioFiscal', '3', '1', 'folioFiscal',$('#folioFiscal').val(),'listaFacturaCFDI.htm');
	});

	$('#opcionFiscal').attr("checked", "true");
	if ($('#opcionFiscal').is(':checked')) {
		opcionFolioFiscal();
	}
	$('#opcionFiscal').click(function() {
		opcionFolioFiscal();
		$('#gridCancelaFactura').hide();	
	});
	
	$('#opcionRango').click(function() {
		opcionRango();
		$('#gridCancelaFactura').hide();
	});
	$.mask.definitions['#']='[a-zA-Z0-9%]';
	$('#folioFiscal').mask("########-####-####-####-############");
	
	$('#folioFiscal').blur(function () {
		setTimeout("$('#cajaLista').hide();", 200);
	});

	$('#fechaInicio').change(function() {
		var Xfecha= $('#fechaInicio').val(); 
		var Yfecha=  parametroBean.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaInicio').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La fecha capturada es mayor a la de hoy")	;
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}else{
				$('#fechaFin').focus();	
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}

	});

	$('#fechaFin').change(function() {
		var Xfecha= $('#fechaFin').val(); 
		var Yfecha=  parametroBean.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaFin').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				alert("La fecha capturada es mayor a la de hoy")	;
				$('#fechaFin').val(parametroBean.fechaSucursal);
			}else{
				$('#rfcReceptor').focus();	
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}

	});

function mostrarGrid(params) {
	$.post("gridCancelaFactura.htm", params,function(data) {
		if (data.length > 0) {
			$('#gridCancelaFactura').html(data);
			$('#gridCancelaFactura').show(500);
			compruebaVigencia();
		} else {
			$('#gridCancelaFactura').html("");
			$('#gridCancelaFactura').show(500);
		}
	});
}
function compruebaVigencia() {
	$('input[name=estatusGrid]').each(function() {
		var nombreID = this.id;
		var jqevalEstatus = eval("'#" + nombreID+ "'");
		var valorEst = $(jqevalEstatus).val();
		if (valorEst == "C") {
				$(jqevalEstatus).val("Cancelado");
				var ID = nombreID.substring(11);
				jqevalCheck = eval("'#cancelarCFDI"+ ID + "'");
				$(jqevalCheck).hide(500);
				jqmotivo = eval("'#motivo" + ID + "'");
				$(jqmotivo).attr("readOnly", "true");
		} else if (valorEst == "V") {
				$(jqevalEstatus).val("Vigente");
		}
	});
}
function opcionFolioFiscal() {
	limpiaCampos();
	$('#divOpcionFiscal').show(500);
	$('#divOpcionRango').hide();
	$('#divOpcionRango2').hide();
}
function opcionRango() {
	limpiaCampos();
	$('#divOpcionFiscal').hide();
	$('#divOpcionRango').show(500);
	$('#divOpcionRango2').show(500);
}
function limpiaCampos() {
	$('#folioFiscal').val('');
	$('#fechaInicio').val('');
	$('#fechaFin').val('');
	$('#rfcReceptor').val('');
	$('#estatus').val('0');
}

function mayor(fecha, fecha2){ // valida si fecha > fecha2: true else false
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


	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				alert("Formato de fecha no válido (aaaa-mm-dd)");
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
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
				break;
			default:
				alert("Fecha introducida errónea.");
			return false;
			}
			if (dia>numDias || dia==0){
				alert("Fecha introducida errónea.");
				return false;
			}
			return true;
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


	function exito() {
		agregaFormatoControles('formaGenerica');
	}
	function fallo() {
		agregaFormatoControles('formaGenerica');
	}
});