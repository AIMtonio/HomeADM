var esTab = false;
var parametroBean = consultaParametrosSession();
var fechaFinal;
$(document).ready(function() {

	inicializarPantalla();
	
	var clienteSofi = 15;  // Número de cliente que corresponde a SOFI EXPRESS.
	var numeroCliente = 0;
	numeroCliente = consultaClienteEspecifico();

	if (numeroCliente == clienteSofi) {
		$('#trOperaciones').show();
	}else{
		$('#trOperaciones').hide();
	}
	
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
		fechaFin : {
			required : true
		},
		sucursalID : {
			required : function(){ return $("#clienteID").asNumber()==0;}
		},
		clienteID : {
			required : function(){ return $("#clienteID").asNumber()>0;}
		},
		tipoPersona : {
			required : function(){ return $("#clienteID").asNumber()==0;}
		}
	},
	messages : {
		fechaInicio : {
			required : 'La Fecha de Inicio es Requerida.',
		},
		fechaFin : {
			required : 'La Fecha Final es Requerida.',
		},
		sucursalID : {
			required : 'La Sucursal es Requerida.',
		},
		clienteID : {
			required : 'El '+$("#safilocale").val()+' es Requerido.',
		},
		tipoPersona : {
			required : 'El Tipo de Persona es Requerida.',
		}
	}
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
	$('#generar').click(function() {
		generaReporte();
	});
	$('#sucursalID').bind('keyup', function(e) {
		lista('sucursalID', '2', '1', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});
	$('#sucursalID').blur(function() {
		consultaSucursal(this.id);
	});
	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '3', '14', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	$('#clienteID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		var cliente = $('#clienteID').asNumber();
		if (cliente > 0) {
			consultaCliente(this.id);
		} else if (cliente == 0) {
			$('#nombreCompleto').val('TODOS');
			$('#tipoPersona option[value=""]').attr("selected", true);
			habilitaControl('tipoPersona');
			$('#tipoPersona').focus();

		} else {
			$('#clienteID').val('');
			$('#nombreCompleto').val('');
		}
	});
	
	// Función para consultar el Cliente Especifico
	function consultaClienteEspecifico() {
		var numeroCliente = 0;
		paramGeneralesServicio.consulta(13, {
			async: false, callback: function (valor) {
				if (valor != null) {
					numeroCliente = valor.valorParametro;
				}
			}
		});
		return numeroCliente;
	}
});

function inicializarPantalla() {
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFinal').val(parametroBean.fechaSucursal);
	$('#tipoPersona').val("");
	$('#sucursalID').val("0");
	$('#nombreSucursal').val("TODAS");
	$('#clienteID').val("0");
	$('#nombreCompleto').val("TODOS");
	agregaFormatoControles('formaGenerica');
	$('#sucursalID').focus();
}

function generaReporte() {
	if ($("#formaGenerica").valid()) {
		var fechaInicio = $("#fechaInicio").val();
		var fechaFinal = $("#fechaFinal").val();
		var operaciones = $("#operaciones option:selected").val();
		var usuario = parametroBean.claveUsuario;
		var nombreInstitucion = parametroBean.nombreInstitucion;
		var fechaAplicacion = parametroBean.fechaAplicacion;
		var tipoReporte = $('input:radio[name=tipoReporte]:checked').asNumber();
		var sucursal = $("#sucursalID").asNumber();
		var nombreSucursal = $("#nombreSucursal").val();
		var clienteID = $("#clienteID").asNumber();
		var nombreCompleto = $("#nombreCompleto").val();
		var tipoPersona = $("#tipoPersona").val();
		var tipoPersonaDes = $("#tipoPersona option:selected").text();
		
		var descOperaciones;
		if(operaciones == ""){
			descOperaciones = 'TODOS';
		}else{
			descOperaciones = $("#operaciones option:selected").html();
		}
		
			var liga = 'reportePerfilTrans.htm?' 
				+ 'fechaInicio=' + fechaInicio 
				+ '&fechaFinal=' + fechaFinal
				+ '&operaciones='+operaciones
				+ '&descOperaciones='+descOperaciones
				+ '&sucursalID=' + sucursal 
				+ '&sucursalDes=' + nombreSucursal 
				+ '&clienteID=' + clienteID 
				+ '&nombreCompleto=' + nombreCompleto 
				+ '&tipoPersona=' + tipoPersona 
				+ '&tipoPersonaDes=' + tipoPersonaDes 
				+ '&usuario=' + usuario 
				+ '&fechaSistema=' + fechaAplicacion 
				+ '&nombreInstitucion=' + nombreInstitucion 
				+ '&tipoReporte=' + tipoReporte;
			window.open(liga, '_blank');
		
	}
}

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

/*==== Funcion valida fecha formato (yyyy-MM-dd) =====*/
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
				$('#clienteID').val(0);
				$('#nombreCompleto').val('TODOS');
			} else {
				$('#sucursalID').val('0');
				$('#nombreSucursal').val('TODAS');
			}
		});
	}
}
function consultaCliente(idControl) {
	var numCliente = $('#clienteID').asNumber();
	var tipConForanea = 23;
	var TipoPer = '';
	setTimeout("$('#cajaLista').hide();", 200);
	if (numCliente>0 && esTab) {
		var clienteN=$('#clienteID').val();
		clienteServicio.consulta(1, clienteN,{ callback:function(cliente) {
			if (cliente != null) {
					$('#clienteID').val(cliente.numero);
					$('#nombreCompleto').val(cliente.nombreCompleto);
					
					TipoPer = cliente.tipoPersona;
					switch(TipoPer) {
						case "F":
							$('#tipoPersona option[value="F"]').attr("selected", true);
							deshabilitaControl('tipoPersona');
							$("#fechaInicio").focus();
							break;
						case "A":
							$('#tipoPersona option[value="A"]').attr("selected", true);
							deshabilitaControl('tipoPersona');
							$("#fechaInicio").focus();
							break;
						case "M":
							$('#tipoPersona option[value="M"]').attr("selected", true);
							deshabilitaControl('tipoPersona');
							$("#fechaInicio").focus();
							break;
						default:
							mensajeSis("No Existe el " + $('#safilocale').val());
						} 
					
			} else {
				mensajeSis("No Existe el " + $('#safilocale').val());
				$('#clienteID').val(0);
				$('#nombreCompleto').val('TODOS');
			}
		},
		errorHandler:function(errorString, exception){
			
		}
		});
	}
}