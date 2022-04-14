var esTab = true;

//Definicion de Constantes y Enums
var catTipoTransaccionOpeInusuales = {
	'actualizar' : 1
};

var catTipoConsultaOpeInusuales = {
	'principal' : 1
};

// Corresponde al catalogo PLDCATEDOSPREO
var catEstatusOperacion = {
	'capturado' : 1,
	'enSeguimiento' : 2,
	'reportado' : 3,
	'noReportado' : 4
};

var varEstatusOperacion = 0;
var tipoPersonaSAFI = '';
var tipoOperacion = 1;
$(document).ready(function() {
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('adjuntar', 'submit');

	$(':text').focus(function() {
		esTab = false;
	});

	$('#opeInusualID').focus();

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$.validator.setDefaults({
		submitHandler : function(event) {
			if (varEstatusOperacion == catEstatusOperacion.reportado && $('#estatus').val() != catEstatusOperacion.reportado) {
				var confirmar = confirm('La Operación Inusual No. ' + $('#opeInusualID').val() + ' se encuentra Actualmente como Reportada.\n¿Desea continuar?');
				if (confirmar) {
					grabaFormaTransaccionOpInus(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'false', 'opeInusualID', 'funcionExito', 'funcionFallo');
				}
			} else {
				grabaFormaTransaccionOpInus(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'false', 'opeInusualID', 'funcionExito', 'funcionFallo');
			}
		}
	});

	$('#estatus').change(function() {
		$('#estatusAux').val($('#estatus').val());
		if ($('#estatusAux').val() == 3 && ($('#clavePersonaInv').val() == 0 || $('#clavePersonaInv').val().trim() == '') && tipoPersonaSAFI[0] == 'CTE') {
			$('#personaReportar2').show();
			$('#clavePersonaInv2').show();
			$('#nomPersonaInv2').show();
			$('#clavePersonaInv2').val("");
			$('#nomPersonaInv2').val("");
			$('#comentarioOC').val("");
		}
		if ($('#estatusAux').val() != 3) {
			$('#clavePersonaInv2').val($('#clavePersonaInv').val());
			$('#nomPersonaInv2').val($('#nomPersonaInv').val());
			$('#personaReportar2').hide();
			$('#clavePersonaInv2').hide();
			$('#nomPersonaInv2').hide();
			habilitaBoton('grabar', 'submit');
			habilitaBoton('adjuntar', 'submit');
			$('#comentarioOC').val("");

		}
		if ($('#estatusAux').val() == 3) {
			$('#comentarioOC').val("");
			habilitaBoton('grabar', 'submit');
			habilitaBoton('adjuntar', 'submit');
		}
	});

	$('#opeInusualID').bind('keyup', function(e) {
		if (this.value.length >= 2) {
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nomPersonaInv";
			parametrosLista[0] = $('#opeInusualID').val();
			listaAlfanumerica('opeInusualID', '1', '1', camposLista, parametrosLista, 'listaOpeInusuales.htm');
		}
	});

	$('#clavePersonaInv2').bind('keyup', function(e) {
		lista('clavePersonaInv2', '1', '1', 'nombreCompleto', $('#clavePersonaInv2').val(), 'listaCliente.htm');
	});

	$('#grabar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionOpeInusuales.actualizar);
	});

	$('#opeInusualID').blur(function() {
		validaOpInusual(this.id);
	});

	consultaEstatus();
	$('#estatusAux').val($('#estatus').val());

	$('#clavePersonaInv2').blur(function() {
		esTab = true;
		consultaCliente(this.id);
	});
	//------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({

	rules : {

	catMotivInuID : {
		required : true
	},

	catProcedIntID : {
		required : true
	},

	NomPersonaInv : {
		required : function() {
			return $('#estatusAux').val() == 3 && $('#clavePersonaInv').val() == 0;
		}
	},

	desOperacion : {
		required : true
	},

	desFrecuencia : {
		required : function() {
			return $('#frecuencia:checked').val() == 'S';
		},
	},

	empInvolucrado : {
		required : function() {
			return $('#involucraEmpleado:checked').val() == 'S';
		},
	},

	auxClavePersonaInv : {
		required : function() {
			return $('#estatusAux').val() == 3 && $('#clavePersonaInv').val() == 0;
		},
	},
	comentarioOC : {
	required : function() {
		return $('#estatus').val() == 3 || $('#estatus').val() == 4;;
	},
	maxlength : 1500,
	},
	estatus : {
		required : true
	}
	},
	messages : {

	catMotivInuID : {
		required : 'Especifique el Motivo'
	},

	catProcedIntID : {
		required : 'Especifique Procedimiento'
	},

	nomPersonaInv : {
		required : 'Especifique Nombre'
	},

	desOperacion : {
		required : 'Especifique una Descripcion'
	},

	desFrecuencia : {
		required : 'Especifique una Descripcion'
	},

	empInvolucrado : {
		required : 'Especifique un Empleado'
	},

	auxClavePersonaInv : {
		required : 'Confirme Cliente'
	},
	comentarioOC : {
	required : 'Especifique Comentario',
	maxlength : 'Máximo 1500 Caracteres'
	},
	estatus : {
		required : 'Especifíque Estatus'
	}
	}
	});

	//------------ Validaciones de Controles -------------------------------------

	//----------Funcion consultaMotivo---------------------//
	function consultaMotivo(idControl) {
		var jqMotivo = eval("'#" + idControl + "'");
		var numMotivo = $(jqMotivo).val();
		var conMotivo = 1;
		var motivoBeanCon = {
			'catMotivInuID' : numMotivo
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numMotivo != '' && esTab) {
			motivosInuServicio.consulta(conMotivo, motivoBeanCon, function(motivos) {
				if (motivos != null) {
					$('#descripcionMotivo').val(motivos.desLarga);

				}
			});
		}
	}

	//----------Funcion consultaProcedimientoInterno---------------------//
	function consultaProcInt(idControl) {
		var jqProc = eval("'#" + idControl + "'");
		var numProc = $(jqProc).val();
		var conProc = 1;
		var procBeanCon = {
			'catProcedIntID' : numProc
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numProc != '' && esTab) {
			procInternosServicio.consulta(conProc, procBeanCon, function(procedimientos) {
				if (procedimientos != null) {
					$('#descripcionProceso').val(procedimientos.descripcion);

				}
			});
		}
	}

	//----------Funcion consultaMoneda---------------------//
	function consultaMoneda(idControl) {
		var jqMoneda = eval("'#" + idControl + "'");
		var numMoneda = $(jqMoneda).val();
		var conMoneda = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numMoneda != '' && !isNaN(numMoneda)) {
			monedasServicio.consultaMoneda(conMoneda, numMoneda, function(moneda) {
				if (moneda != null) {
					$('#desMoneda').val(moneda.descripcion);
				}
			});
		}
	}

	// ////////////////funcion consultar cliente////////////////
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		setTimeout("$('#cajaLista').hide();", 200);

		if (numCliente != '' && !isNaN(numCliente) && esTab) {
			clienteServicio.consulta(1, numCliente, function(cliente) {
				if (cliente != null) {
					$('#nomPersonaInv2').val(cliente.nombreCompleto);
					$('#clavePersonaInv').val(numCliente);
					$('#nomPersonaInv').val(cliente.nombreCompleto);
				} else {
					mensajeSis("No existe el Cliente.");
					$('#nomPersonaInv').val('');
					$('#clavePersonaInv').focus();
					$('#clavePersonaInv').val("");
				}

			});
		}
	}

	function validaOpInusual(control) {
		var numOperacion = $('#opeInusualID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if (numOperacion != '' && !isNaN(numOperacion) && esTab) {

			if (numOperacion == 0) {

				deshabilitaBoton('grabar', 'submit');
				deshabilitaBoton('adjuntar', 'submit');
				deshabilitaControl('fechaDeteccion');
				deshabilitaControl('catMotivInuID');
				deshabilitaControl('catProcedIntID');
				deshabilitaControl('clavePersonaInv');
				deshabilitaControl('nomPersonaInv');
				deshabilitaControl('frecuencia');
				deshabilitaControl('frecuencia2');
				$('#desFrecuencia').attr('readonly', true);
				deshabilitaControl('involucraEmpleado');
				deshabilitaControl('involucraEmpleado2');
				$('#empInvolucrado').attr('readonly', true);
				$('#desOperacion').attr('readonly', true);
				deshabilitaControl('estatus');
				deshabilitaControl('fechaCierre');
				$('#comentarioOC').attr('readonly', true);
				inicializaForma('formaGenerica', 'opeInusualID');
				$('#frecuencia2').attr("checked", "1");
				limpiaDatosAdicionales();
				$('#involucraEmpleado').click(function() {
					if ($('#involucraEmpleado').is(':checked')) {
						$('#involucraEmpleado2').attr('checked', false);
					}

					$('#involucraEmpleado2').click(function() {
						if ($('#involucraEmpleado2').is(':checked')) {
							$('#involucraEmpleado').attr('checked', false);
						}
					});
				});

			} else {
				habilitaBoton('grabar', 'submit');
				habilitaBoton('adjuntar', 'submit');
				deshabilitaControl('fechaDeteccion');
				deshabilitaControl('catMotivInuID');
				deshabilitaControl('catProcedIntID');
				deshabilitaControl('clavePersonaInv');
				deshabilitaControl('nomPersonaInv');
				deshabilitaControl('frecuencia');
				deshabilitaControl('frecuencia2');
				$('#desFrecuencia').attr('readonly', true);
				deshabilitaControl('involucraEmpleado');
				deshabilitaControl('involucraEmpleado2');
				$('#empInvolucrado').attr('readonly', true);
				$('#desOperacion').attr('readonly', true);
				habilitaControl('estatus');
				habilitaControl('comentarioOC');

				var opInusualesBeanCon = {
					'opeInusualID' : $('#opeInusualID').val()

				};
				var parametroBean = consultaParametrosSession();
				var usuariosesion = parametroBean.nombreUsuario;

				opeInusualesServicio.consulta(catTipoConsultaOpeInusuales.principal, opInusualesBeanCon, function(opeInusuales) {
					if (opeInusuales != null) {
						var empleadoinvolucrado = opeInusuales.empInvolucrado;

						if (empleadoinvolucrado != usuariosesion) {

							dwr.util.setValues(opeInusuales);
							$('#montoOperacion').formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 2
							});
							$('#montoMenSocie').val(opeInusuales.ingMenSocie1);
							$('#montoMenSocie').formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 2
							});
							if ($('#formaPago').val() == "") {
								$('#formaPago').val("SELECCIONAR");
							}
							if (opeInusuales.creditoID == 0) {
								$('#numCredito').val('');
							}
							tipoPersonaSAFI = opeInusuales.tipoPerSAFI.split('|');
							mostrarElementoPorClase('trTipoPersInv',true);
							$('#tipoPersonaSAFI').val(((tipoPersonaSAFI[1]===tipoPersonaSAFI[2])?tipoPersonaSAFI[1]:(tipoPersonaSAFI[1]+' '+tipoPersonaSAFI[2])));
							// Solo si la persona involucrada es cliente, se consulta su detalle
							if (tipoPersonaSAFI[0] == 'CTE') {
								consultaCreditoLiquidado(opeInusuales.clavePersonaInv, opeInusuales.fechaDeteccion);
								consultaMovimientosCuenta(opeInusuales.cuentaAhoID, opeInusuales.fechaDeteccion);
								consultaAhoCte(opeInusuales.clavePersonaInv);
								consultaInvCte(opeInusuales.clavePersonaInv);
								consultaCreditoCte(opeInusuales.clavePersonaInv);
								consultaCreditosAvalados(opeInusuales.clavePersonaInv);
							} else {
								ocultaGrids();
							}
							esTab = true;
							consultaMotivo('catMotivInuID');
							consultaProcInt('catProcedIntID');

							if (opeInusuales.empInvolucrado != null) {
								$('#involucraEmpleado').attr("checked", "1");
							} else {
								$('#involucraEmpleado2').attr("checked", "1");
							}

							if (opeInusuales.fechaCierre == '1900-01-01') {
								$('#fechaCierre').val('');
							} else {
								$('#fechaCierre').val(opeInusuales.fechaCierre);
							}

							if (opeInusuales.clavePersonaInv == '0') {
								$('#clavePersonaInv').val('');
							} else {
								$('#clavePersonaInv').val(opeInusuales.clavePersonaInv);
							}

							if (opeInusuales.frecuencia == 'S') {
								$('#frecuencia').attr("checked", "1");
								$('#descripcionF').show(500);
								$('#desFrecuencia').show(500);
							} else {
								if (opeInusuales.frecuencia == 'N') {
									$('#frecuencia2').attr("checked", "1");
									$('#descripcionF').hide(500);
									$('#desFrecuencia').hide(500);
								}
							}

							if (opeInusuales.empInvolucrado == '') {
								$('#involucraEmpleado2').attr("checked", "1");
								$('#involucraEmpleado').attr("checked", false);
								$('#empleadoInv').hide(500);
								$('#empInvolucrado').hide(500);
							} else {
								if (opeInusuales.empInvolucrado != '') {
									$('#involucraEmpleado').attr("checked", "1");
									$('#involucraEmpleado2').attr("checked", false);
									$('#empleadoInv').show(500);
									$('#empInvolucrado').show(500);
								}
							}
							varEstatusOperacion = opeInusuales.estatus;
							if (varEstatusOperacion == catEstatusOperacion.noReportado) {
								deshabilitaBoton('grabar', 'submit');
								deshabilitaControl('estatus');
								$('#comentarioOC').attr('readonly', true);
							}

							if (opeInusuales.creditoID != 0) {
								$('#credito').show();
								$('#creditoID').show();
							} else {
								if (opeInusuales.creditoID == 0) {
									$('#credito').hide();
									$('#creditoID').hide();
								}
							}

							if (opeInusuales.cuentaAhoID != 0) {
								$('#cuenta').show();
								$('#cuentaAhoID').show();
							} else {
								if (opeInusuales.cuentaAhoID == 0) {
									$('#cuenta').hide();
									$('#cuentaAhoID').hide();
								}
							}

							if (opeInusuales.transaccionOpe != 0) {
								$('#transaccion').show();
								$('#transaccionOpe').show();
							} else {
								if (opeInusuales.transaccionOpe == 0) {
									$('#transaccion').hide();
									$('#transaccionOpe').hide();
								}
							}

							if (opeInusuales.naturaOperacion != 0) {
								$('#naturaleza').show();
								$('#naturaOperacion').show();
							} else {
								if (opeInusuales.naturaOperacion == 0) {
									$('#naturaleza').hide();
									$('#naturaOperacion').hide();
								}
							}

							if (opeInusuales.montoOperacion != 0) {
								$('#monto').show();
								$('#montoOperacion').show();
							} else {
								if (opeInusuales.montoOperacion == 0) {
									$('#monto').hide();
									$('#montoOperacion').hide();
								}
							}

							if (opeInusuales.monedaID != 0) {
								$('#moneda').show();
								$('#monedaID').show();
								$('#desMoneda').show();
								esTab = true;
								consultaMoneda('monedaID');
							} else {
								if (opeInusuales.monedaID == 0) {
									$('#moneda').hide();
									$('#monedaID').hide();
									$('#desMoneda').hide();
								}
							}

							$('#personaReportar2').hide();
							$('#clavePersonaInv2').hide();
							$('#nomPersonaInv2').hide();
							consultaArchivos(1, $('#opeInusualID').val(), 0);
						} else {
							mensajeSis("No existe la Operación Inusual");
							limpiaFormularioInusual();
						}
					} else {
						mensajeSis("No Existe la Operación");
						limpiaFormularioInusual();

					}
				});
			}
		}

	}

	function consultaEstatus() {
		dwr.util.removeAllOptions('estatus');
		dwr.util.addOptions('estatus', {
			'' : 'SELECCIONAR'
		});
		estadosPreocupantesServicio.listaCombo(1, function(estatus) {
			dwr.util.addOptions('estatus', estatus, 'catEdosPreoID', 'descripcion');
		});
	}

	function limpiaFormularioInusual() {

		deshabilitaBoton('grabar', 'submit');
		deshabilitaBoton('adjuntar', 'submit');
		inicializaForma('formaGenerica', 'opeInusualID');
		$('#estatus').val("-1").selected = true;
		$('#descripcionF').hide(500);
		$('#desFrecuencia').hide(500);
		$('#frecuencia2').attr("checked", "1");
		$('#empleadoInv').hide(500);
		$('#empInvolucrado').hide(500);
		$('#involucraEmpleado').attr("checked", false);
		$('#involucraEmpleado2').attr("checked", "1");
		$('#opeInusualID').val("");
		$('#opeInusualID').focus();
		$('#opeInusualID').select();
		$('#personaReportar2').hide();
		$('#clavePersonaInv2').hide();
		$('#nomPersonaInv2').hide();
		$('#credito').hide();
		$('#creditoID').hide();
		$('#cuenta').hide();
		$('#cuentaAhoID').hide();
		$('#transaccion').hide();
		$('#transaccionOpe').hide();
		$('#naturaleza').hide();
		$('#naturaOperacion').hide();
		$('#monto').hide();
		$('#montoOperacion').hide();
		$('#moneda').hide();
		$('#monedaID').hide();
		$('#desMoneda').hide();
		limpiaDatosAdicionales();
		deshabilitaControl('estatus');
	}

	$('#adjuntar').click(function() {
		subirArchivos();
	});
});//document ready

// funcion para llenar el grid de ultimos 5 creditos
function consultaCreditoLiquidado(clienteID, fechaDeteccion) {
	var params = {};
	params['tipoLista'] = 40;
	params['clienteID'] = clienteID;
	params['fechaDeteccion'] = fechaDeteccion;
	if (clienteID != '' && !isNaN(clienteID)) {
		$.post("resCredLiquidadosGrid.htm", params, function(dat) {
			if (dat.length > 0) {
				$('#gridCredLiquidados').html(dat);
				$('#gridCredLiquidados').show();
			} else {
				$('#gridCredLiquidados').html("");
				$('#gridCredLiquidados').show();
			}
		});
	}
}

// funcion para llenar el grid de movimientos en cuentas de ahorro
function consultaMovimientosCuenta(cuentaAhoID, fechaDeteccion) {
	var array_fecha = fechaDeteccion.split("-");
	var anio = array_fecha[0];
	var mes = array_fecha[1];
	var params = {};
	params['tipoLista'] = 3;
	params['cuentaAhoID'] = cuentaAhoID;
	params['anio'] = anio;
	params['mes'] = mes;
	if (fechaDeteccion != '') {
		$.post("cuentasAhoMovInuGrid.htm", params, function(dat) {
			if (dat.length > 0) {
				$('#gridMovimientosCuenta').html(dat);
				$('#gridMovimientosCuenta').show();
			} else {
				$('#gridMovimientosCuenta').html("");
				$('#gridMovimientosCuenta').show();
			}
		});
	}
}
// Grid Cuentas Resumen del cliente
function consultaAhoCte(numCliente) {
	var params = {};
	params['tipoLista'] = 4;
	params['clienteID'] = numCliente;
	if (numCliente != '' && !isNaN(numCliente)) {
		$.post("resumenCteAhoGrid.htm", params, function(data) {
			if (data.length > 0) {
				$('#gridAhoCte').html(data);
				$('#gridAhoCte').show();
			} else {
				$('#gridAhoCte').html("");
				$('#gridAhoCte').show();
			}
		});
	}
}
// Grid Inversiones Resumen del Cliente
function consultaInvCte(clienteID) {
	if (clienteID != '' && !isNaN(clienteID)) {
		var params = {};
		params['tipoLista'] = 2;
		params['clienteID'] = clienteID;
		$.post("resumenCteInvGrid.htm", params, function(dat) {
			if (dat.length > 0) {
				$('#gridInvCte').html(dat);
				$('#gridInvCte').show();
			} else {
				$('#gridInvCte').html("");
				$('#gridInvCte').show();
			}
		});
	}
}
// Grid Creditos Actuales Resumen de cliente
function consultaCreditoCte(clienteID) {
	var params = {};
	params['tipoLista'] = 7;
	params['clienteID'] = clienteID;
	if (clienteID != '' && !isNaN(clienteID)) {
		$.post("resumenCteCredGrid.htm", params, function(dat) {
			if (dat.length > 0) {
				$('#gridCredCte').html(dat);
				$('#gridCredCte').show();
			} else {
				$('#gridCredCte').html("");
				$('#gridCredCte').show();
			}
		});
	}
}
// Grid Creditos Avalados Resumen del cliente
function consultaCreditosAvalados(clienteID) {
	var params = {};
	params['tipoLista'] = 27;
	params['clienteID'] = clienteID;
	if (clienteID != '' && !isNaN(clienteID)) {
		$.post("resumenCteCreditosAvalados.htm", params, function(dat) {
			if (dat.length > 0) {
				$('#gridCreditosAvalados').html(dat);
				$('#gridCreditosAvalados').show();
			} else {
				$('#gridCreditosAvalados').html("");
				$('#gridCreditosAvalados').show();
			}
		});
	}
}

function limpiaDatosAdicionales() {
	$('#formaPago').val("SELECCIONAR");
	$('#ocupacionCli').val("");
	$('#clasificacionCli').val("");
	$('#sucursalIDCli').val("");
	$('#nombreSucursalCli').val("");
	$('#nivelEstudios').val("");
	$('#ingresoMensual').val("");
	$('#montoMenSocie').val("");
	$('#edad').val("");
	$('#fechaNacimiento').val("");
	$('#estadoCivil').val("");
	$('#localidad').val("");
	$('#numCredito').val("");
	$('#productoCredito').val("");
	$('#grupoNoSolidadario').val("");

	$('#gridCredLiquidados').html("");
	$('#gridCredLiquidados').show();
	$('#gridMovimientosCuenta').html("");
	$('#gridMovimientosCuenta').show();
	$('#gridAhoCte').html("");
	$('#gridAhoCte').show();
	$('#gridInvCte').html("");
	$('#gridInvCte').show();
	$('#gridCredCte').html("");
	$('#gridCredCte').show();
	$('#gridCreditosAvalados').html("");
	$('#gridCreditosAvalados').show();
}

function grabaFormaTransaccionOpInus(event, idForma, idDivContenedor, idDivMensaje, inicializaforma, idCampoOrigen, funcionPostEjecucionExitosa, funcionPostEjecucionFallo) {
	consultaSesion();
	var jqForma = eval("'#" + idForma + "'");
	var jqContenedor = eval("'#" + idDivContenedor + "'");
	var jqMensaje = eval("'#" + idDivMensaje + "'");
	var url = $(jqForma).attr('action');
	var resultadoTransaccion = 0;

	quitaFormatoControles(idForma);
	// No descomentar la siguiente linea
	$(jqMensaje).html('<img src="images/barras.jpg" alt=""/>');
	// Envio de la forma

	$.post(url, serializaForma(idForma), function(data) {
		if (data.length > 0) {
			$(jqMensaje).html(data);
			var exitoTransaccion = $('#numeroMensaje').asNumber();
			var campo = eval("'#" + idCampoOrigen + "'");
			if ($('#consecutivo').val() != 0) {
				$(campo).val($('#consecutivo').val());
			}
			// Ejecucion de las Funciones de CallBack(RetroLlamada)
			if (exitoTransaccion == 0 && funcionPostEjecucionExitosa != '') {
				funcionExito(jqContenedor, jqMensaje);
			} else {
				funcionFallo(jqContenedor, jqMensaje);
			}

			// TODO la de fallo
		}
	});
	return resultadoTransaccion;
}

function funcionExito(jqContenedor, jqMensaje) {
	inicializaForma('formaGenerica', 'opeInusualID');

	$('#estatus').val("-1").selected = true;
	$('#frecuencia2').attr("checked", "1");
	$('#involucraEmpleado2').attr("checked", "1");
	$('#involucraEmpleado').attr('checked', false);
	$('#descripcionF').hide(500);
	$('#desFrecuencia').hide(500);
	$('#empleadoInv').hide(500);
	$('#empInvolucrado').hide(500);
	$('#personaReportar2').hide();
	$('#clavePersonaInv2').hide();
	$('#nomPersonaInv2').hide();
	$('#credito').hide();
	$('#creditoID').hide();
	$('#cuenta').hide();
	$('#cuentaAhoID').hide();
	$('#transaccion').hide();
	$('#transaccionOpe').hide();
	$('#naturaleza').hide();
	$('#naturaOperacion').hide();
	$('#monto').hide();
	$('#montoOperacion').hide();
	$('#moneda').hide();
	$('#monedaID').hide();
	$('#desMoneda').hide();

	$('#formaPago').val("SELECCIONAR");
	$('#ocupacionCli').val("");
	$('#clasificacionCli').val("");
	$('#sucursalIDCli').val("");
	$('#nombreSucursalCli').val("");
	$('#nivelEstudios').val("");
	$('#ingresoMensual').val("");
	$('#montoMenSocie').val("");
	$('#edad').val("");
	$('#fechaNacimiento').val("");
	$('#estadoCivil').val("");
	$('#localidad').val("");
	$('#numCredito').val("");
	$('#productoCredito').val("");
	$('#grupoNoSolidadario').val("");

	$('#gridCredLiquidados').html("");
	$('#gridMovimientosCuenta').html("");
	$('#gridAhoCte').html("");
	$('#gridInvCte').html("");
	$('#gridCredCte').html("");
	$('#gridCreditosAvalados').html("");
	$('#contenedorForma').unblock();
	$('#gridArchivos').hide(500);

	$(jqContenedor).block({
	message : $(jqMensaje),
	css : {
	border : 'none',
	background : 'none'
	}
	});

}

function funcionFallo(jqContenedor, jqMensaje) {
	$(jqContenedor).block({
	message : $(jqMensaje),
	css : {
	border : 'none',
	background : 'none'
	}
	});
}

function ocultaGrids() {
	$('#gridCredLiquidados').html("");
	$('#gridCredLiquidados').hide();
	$('#gridMovimientosCuenta').html("");
	$('#gridMovimientosCuenta').hide();
	$('#gridAhoCte').html("");
	$('#gridAhoCte').hide();
	$('#gridInvCte').html("");
	$('#gridInvCte').hide();
	$('#gridCredCte').html("");
	$('#gridCredCte').hide();
	$('#gridCreditosAvalados').html("");
	$('#gridCreditosAvalados').hide();
	$('#gridArchivos').hide(500);
}

function subirArchivos() {
	var url = "archOperacionesPLDUpload.htm?" + "proceso=1&" + "operacion=" + $('#opeInusualID').asNumber();

	var leftPosition = (screen.width) ? (screen.width - 850) / 2 : 0;
	var topPosition = (screen.height) ? (screen.height - 500) / 2 : 0;

	window.open(url, "PopUpSubirArchivo", "width=680,height=340,scrollbars=auto,status=yes,location=no,addressbar=0,menubar=0,toolbar=0" + "left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition);

}