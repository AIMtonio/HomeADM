var SiTieneNegocio = 'S';
var totalAsignado = 0.0;
var totalValorComercial = 0.0;
var totalDeudasCreditos = 0.0;
var totalPasivosCalculado = parseFloat(0);
var procede = 'N';

var var_EstatusSolicitud = {
'Inactiva' : 'I',
'Liberada' : 'L',
'Autorizada' : 'A',
'Cancelada' : 'C',
'Desembolsada' : 'D',
'Rechazada':	'R'
};

var catEstatusRatios={
		'Calculada':	'C',
		'Guardada':		'G',
		'Rechazada':	'R',
		'Regresada':	'E',
		'Procesada':	'P'
};
var var_SolicitudEstatus = '';
var var_ClasifiDestinCredComercial = 'C';
var var_ClasifiDestinCredConsumo = 'O';
var Var_EsMarginada = 'S';

//Definicion de Constantes y Enums  
var catTipoTraRatios = {
'calcular' : 1,
'guardar' : 2,
'regresar': 3,
'rechazar': 4,
'procesar': 5
};

var catTipoConsultaSolicitud = {
'principal' : 1,
'foranea' : 2
};

var catTipoConsultaCliDatSocioE = {
	'SocioAlimentacion' : 3,
};

var parametroBean = consultaParametrosSession();
var usuario = parametroBean.numeroUsuario;
var nombreusuario=parametroBean.claveUsuario;

$(document).ready(function() {
	esTab = true;
	inicializarCalcRatios();
	
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
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'false', 'solicitudCreditoID', 'funcionExitoRatios', 'funcionErrorRatios');
		}
	});
	
	$('#generar').click(function() {
		$('#tipoTransaccion').val(catTipoTraRatios.calcular);
	});
	$('#guardar').click(function() {
		$('#tipoTransaccion').val(catTipoTraRatios.guardar);
	});
	
	$('#imprimir').click(function() {
		window.open('ReporteCalculoRatios.htm?'+
				'solicitudCreditoID=' + $('#solicitudCreditoID').val()+
				'&usuarioClave='+nombreusuario, '_blank');
	});

	$('#rechazar').click(function() {
		mostrarComentarios(catTipoTraRatios.rechazar);
	});
	
	$('#regresar').click(function() {
		mostrarComentarios(catTipoTraRatios.regresar);
	});
	
	$('#procesar').click(function() {
		mostrarComentarios(catTipoTraRatios.procesar);
	});
	
	$('#guardarRegresar').click(function() {
		$('#tipoTransaccion').val(catTipoTraRatios.regresar);
	});
	$('#guardarRechazo').click(function() {
		$('#tipoTransaccion').val(catTipoTraRatios.rechazar);
	});
	$('#guardarProcesar').click(function() {
		$('#tipoTransaccion').val(catTipoTraRatios.procesar);
	});
	
	
	$('#solicitudCreditoID').bind('keyup', function(e) {
		if (this.value.length >= 0) {
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#solicitudCreditoID').val();
			
			lista('solicitudCreditoID', '2', '11', camposLista, parametrosLista, 'listaSolicitudCredito.htm');
		}
	});
	$('#solicitudCreditoID').blur(function() {
		if(esTab){
			validaSolicitudCredito(this.id);
		}
	});
	
	$('#tieneNegocio1').click(function() {
		$('#trMontoVentas').show();
		$('#trSituacionMercado').show();
		$('#tieneNegocio1').focus();
	});
	
	$('#tieneNegocio2').click(function() {
		$('#trMontoVentas').hide();
		$('#trSituacionMercado').hide();
		$('#tieneNegocio2').focus();
		inicializaComboNoNegocioC4();
	});
	
	$('#totalAhorro').blur(function() {
		calculaCapital();
	});
	$('#activosInversiones').blur(function() {
		calculaCapital();
	});
	$('#activosTerrenos').blur(function() {
		calculaCapital();
	});
	
	$('#vivienda').blur(function() {
		calculaCapital();
	});
	$('#activosVehiculos').blur(function() {
		calculaCapital();
	});
	$('#otrosActivos').blur(function() {
		calculaCapital();
	});
	
	$('#otrosActivos').blur(function() {
		calculaCapital();
	});
	
	$('#montoCuota').blur(function() {
		CalculaCapacidadPago();
	});
	
	$('#formaGenerica').validate({
	rules : {
	estabilidadEmpleo : {
		required : true
	},
	ventasMensuales : {
		required : function() {
			return $('#tieneNegocio1').is(':checked');
		},
	},
	liquidez : {
		required : function() {
			return $('#tieneNegocio1').is(':checked');
		},
	},
	situacionMercado : {
		required : function() {
			return $('#tieneNegocio1').is(':checked');
		}
	},
	motivo : {
		required : function(){
			return $('#comentarioEjecutivo').is(':visible');
		},
		maxlength: 1000
	}
	},
	
	messages : {
	estabilidadEmpleo : {
		required : 'Especifique la Estabilidad a futuro'
	},
	ventasMensuales : {
		required : 'Especifique las Ventas Mensuales'
	},
	liquidez : {
		required : 'Especifique la Liquidez'
	},
	situacionMercado : {
		required : 'Especifique la Situación del Mercado'
	}, 
	motivo : {
		required : 'Especifique comentario.',
		maxlength: 'Máximo 100 caracteres.'
	}
	}
	});
});// Fin del Document Ready

/* **************************** SOLICITUD DE CREDITO  ******************** */
function validaSolicitudCredito(idControl) {
	
	var jqSolicitud = eval("'#" + idControl + "'");
	var solCred = $(jqSolicitud).val();
	setTimeout("$('#cajaLista').hide();", 200);
	
	if (solCred != '' && !isNaN(solCred)) {
		inicializaForma('formaGenerica', 'solicitudCreditoID');
		$('#tieneNegocio1').attr('checked', true);
		$('#trMontoVentas').show();
		$('#trSituacionMercado').show();
		
		var SolCredBeanCon = {
		'solicitudCreditoID' : solCred,
		'usuario' : usuario
		};
		bloquearPantalla();
		solicitudCredServicio.consulta(catTipoConsultaSolicitud.principal, SolCredBeanCon, {
		callback : function(solicitud) {
			if (solicitud != null && solicitud.solicitudCreditoID != 0) {
				dwr.util.setValues(solicitud);
				$('#comentarioEjecutivo').val('');
				$('#productoCreditoID').val(solicitud.productoCreditoID);
				if (solicitud.clasifiDestinCred == var_ClasifiDestinCredComercial) {
					$('#clasificacionDestin1').attr("checked", true);
					$('#clasificacionDestin2').attr("checked", false);
					$('#clasificacionDestin3').attr("checked", false);
				} else if (solicitud.clasifiDestinCred == var_ClasifiDestinCredConsumo) {
					$('#clasificacionDestin1').attr("checked", false);
					$('#clasificacionDestin2').attr("checked", true);
					$('#clasificacionDestin3').attr("checked", false);
				} else {
					$('#clasificacionDestin1').attr("checked", false);
					$('#clasificacionDestin2').attr("checked", false);
					$('#clasificacionDestin3').attr("checked", true);
				}
				if (solicitud.clienteID > 0) {
					$('#cliente').val('S');
				} else {
					$('#cliente').val('N');
				}
				
				if (solicitud.estatus == var_EstatusSolicitud.Inactiva) {
					$('#estatus').val('INACTIVA');
				} else if (solicitud.estatus == var_EstatusSolicitud.Autorizada) {
					$('#estatus').val('AUTORIZADA');
				} else if (solicitud.estatus == var_EstatusSolicitud.Liberada) {
					$('#estatus').val('LIBERADA');
				} else if (solicitud.estatus == var_EstatusSolicitud.Cancelada) {
					$('#estatus').val('CANCELADA');
				} else if (solicitud.estatus == var_EstatusSolicitud.Desembolsada) {
					$('#estatus').val('DESEMBOLSADA');
				} else if (solicitud.estatus == var_EstatusSolicitud.Rechazada) {
					$('#estatus').val('RECHAZADA');
				}
				
				var_SolicitudEstatus = solicitud.estatus;
				consultaParametrosCaja();
				consultaProducCredito(solicitud.productoCreditoID);
				consultaComboPlazosSolicitud(solicitud.plazoID);
				consultaCliente(solicitud.clienteID);
				consultaClienteGenerales(solicitud.clienteID);
				consultaDatosVivienda(solicitud.clienteID, solicitud.prospectoID);
				consultaSocioDemograficos();
				consultaDatosSocioeconomicos(solicitud.clienteID, solicitud.prospectoID);
				consultaRatios();
				consultaDatosGenerales();
				consultaGarantiasAsigandas(solicitud.solicitudCreditoID, solicitud.creditoID);
				consultaNAvales(solicitud.solicitudCreditoID);
				if (solicitud.prospectoID > 0) {
					consultaProspecto('prospectoID');
				}
				
				agregaFormatoControles('formaGenerica');
				desbloquearPantalla();
			} else {
				desbloquearPantalla();
				mensajeSis("La Solicitud de Credito No existe");
				$('#solicitudCreditoID').focus();
				$('#solicitudCreditoID').val("");
			}
		},
		errorHandler : function(message) {
			mensajeSis("Error en Validacion de la Solicitud.<br>" + message);
		}
		});
	}
}

//consulta foranea del producto de credito 
function consultaProducCredito(producto) {
	var ProdCredBeanCon = {
		'producCreditoID' : producto
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (producto != '' && !isNaN(producto)) {
		productosCreditoServicio.consulta(catTipoConsultaSolicitud.principal, ProdCredBeanCon, {
		callback : function(prodCred) {
			if (prodCred != null) {
				$('#descripProducto').val(prodCred.descripcion);
				$('#relGarantCred').val(prodCred.relGarantCred);
			} else {
				mensajeSis("No Existe el Producto de Credito");
				$('#productoCreditoID').focus();
				$('#productoCreditoID').select();
			}
		},
		errorHandler : function(message) {
			mensajeSis("Error en consulta del Producto de Crédito." + message)
		}
		});
	}
}

function consultaComboPlazosSolicitud(plazoValor) {
	plazosCredServicio.listaCombo(3, {
	callback : function(plazoCreditoBean) {
		dwr.util.removeAllOptions('plazoID');
		dwr.util.addOptions('plazoID', {
			'' : 'SELECCIONAR'
		});
		dwr.util.addOptions('plazoID', plazoCreditoBean, 'plazoID', 'descripcion');
		$('#plazoID').val(plazoValor);
	},
	errorHandler : function(message) {
		mensajeSis("Error en consulta de información de los Plazos." + message)
	}
	});
}

/* ********************************* CLIENTE ******************** */
function consultaCliente(numCliente) {
	setTimeout("$('#cajaLista').hide();", 200);
	if (numCliente != '' && !isNaN(numCliente)) {
		clienteServicio.consulta(1, numCliente, {
		callback : function(cliente) {
			if (cliente != null) {
				$('#nombreCte').val(cliente.nombreCompleto);
				$('#calificaCliente').val(cliente.calificaCredito);
				ValidaCalificacion(cliente.calificaCredito);
				
				$('#ocupacionID').val(cliente.ocupacionID);
				consultaOcupacion('ocupacionID');
				consultaBuro(cliente.RFC);
				consultaDireccionCliente(numCliente);
			} else {
				if ($('#clienteID').asNumber() != '0') {
					mensajeSis("El cliente especificado no Existe");
					$('#clienteID').val("");
					$('#clienteID').focus();
					$('#clienteID').select();
				}
			}
		},
		errorHandler : function(message) {
			mensajeSis("Error en consulta de datos del Cliente." + message)
		}
		});
	}
}

function ValidaCalificacion(calificacion) {
	
	if (calificacion == 'A') {
		$('#calificaCredito').val('EXCELENTE');
		$('#saldoPromedioAhorro').val('EXCELENTE');
	}
	if (calificacion == 'B') {
		$('#calificaCredito').val('BUENA');
		$('#saldoPromedioAhorro').val('BUENO');
	}
	if (calificacion == 'C') {
		$('#calificaCredito').val('REGULAR');
		$('#saldoPromedioAhorro').val('REGULAR');
	}
	if (calificacion == 'N') {
		$('#calificaCredito').val('NO ASIGNADA');
		$('#saldoPromedioAhorro').val('REGULAR');
	}
	
}
/*Consulta la información general del cliente ()   */
function consultaClienteGenerales(numCliente) {
	setTimeout("$('#cajaLista').hide();", 200);
	if (numCliente != '' && !isNaN(numCliente)) {
		clienteServicio.consulta(19, numCliente, {
		callback : function(cliente) {
			if (cliente != null) {
				if (cliente.moroso > 0) {
					$('#morosidadCredito').val('S');
				} else {
					$('#morosidadCredito').val('N');
				}
				$('#maximoMorosidad').val(cliente.maximoMora);
				$('#totalAhorro').val(cliente.totalAhorro);
				$('#activosInversiones').val(cliente.totalInversion);
				totalDeudasCreditos = cliente.totalCreditos;
				calculaCapital();
				agregaFormatoControles('formaGenerica');
				
			}
		},
		errorHandler : function(message) {
			mensajeSis("Error en consulta de datos generales." + message)
		}
		});
	}
}
/*  Consulta la Opcupacion del cliente  */
function consultaOcupacion(idControl) {
	var jqOcupacion = eval("'#" + idControl + "'");
	var numOcupacion = $(jqOcupacion).val();
	var tipConForanea = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numOcupacion != 0 && numOcupacion != '' && !isNaN(numOcupacion)) {
		ocupacionesServicio.consultaOcupacion(tipConForanea, numOcupacion, {
		callback : function(ocupacion) {
			if (ocupacion != null) {
				$('#descripcionOcupacion').val(ocupacion.descripcion);
			} else {
				if (numOcupacion != 0) {
					mensajeSis("No Existe la Ocupacion");
					$('#ocupacionID').focus();
					$('#descripcionOcupacion').val('');
					$('#ocupacionID').val('');
				}
			}
		},
		errorHandler : function(message) {
			mensajeSis("Error en Consulta de Ocupacion." + message);
		}
		});
	} else {
		$('#ocupacionID').val('');
		$('#descripcionOcupacion').val('');
	}
}
function consultaDireccionCliente(clienteID) {
	var TipoConsultaDirecciones = 3;
	
	var DireccionCteBean = {
	'clienteID' : clienteID,
	'direccionID' : 0
	};
	direccionesClienteServicio.consulta(TipoConsultaDirecciones, DireccionCteBean, {
	callback : function(direccionCliente) {
		if (direccionCliente != null) {
			Var_EsMarginada = direccionCliente.esMarginada;
			CalculaCapacidadPago();
		} else {
			if(clienteID>0){
				mensajeSis("El Cliente no tiene Registrada su Dirección.");
			}
		}
	},
	errorHandler : function(message) {
		mensajeSis("Error en Consulta de la Dirección del Cliente. " + message);
	}
	});
	
}
/* ****************   PROSPECTOS      ********************************  */
// consulta el prospecto 
function consultaProspecto(idControl) {
	
	var jqProspecto = eval("'#" + idControl + "'");
	var numProspecto = $(jqProspecto).val();
	setTimeout("$('#cajaLista').hide();", 200);
	
	var prospectoBeanCon = {
		'prospectoID' : numProspecto
	};
	
	if (numProspecto != '' && !isNaN(numProspecto)) {
		prospectosServicio.consulta(1, prospectoBeanCon, {
		callback : function(prospectos) {
			if (prospectos != null) {
				$('#nombreProspecto').val(prospectos.nombreCompleto);
				$('#ocupacionID').val(prospectos.ocupacionID);
				
				ValidaCalificacion(prospectos.calificaProspectos);
				consultaOcupacion('ocupacionID');
				consultaBuro(prospectos.RFC);
				
				localidadRepubServicio.consulta(1, prospectos.estadoID, prospectos.municipioID, prospectos.localidadID, {
				callback : function(localidad) {
					if (localidad != null) {
						if ($('#clienteID').asNumber() <= 0 || $('#clienteID').val() == '') {
							Var_EsMarginada = localidad.esMarginada;
							CalculaCapacidadPago();
						}
						
					} else {
						if ($('#prospectoID').asNumber() != '0') {
							mensajeSis("No Existe el Prospecto");
						}
					}
				},
				errorHandler : function(message) {
					mensajeSis("Error en consulta de datos generales." + message)
				}
				});
				
			} else {
				if ($('#prospectoID').asNumber() != '0') {
					mensajeSis("No Existe el Prospecto");
				}
			}
		},
		errorHandler : function(message) {
			mensajeSis("Error en Consulta de Información del Prospecto." + message);
		}
		});
	}
}

/* ****************   SOCIOECONOMICOS ******************************** */
function consultaDatosVivienda(numCliente, prospectoID) {
	var tipolistaPrincipal = {
		'principal' : 1
	};
	var datSocConyugueBean = {
	'prospectoID' : prospectoID,
	'clienteID' : numCliente
	};
	socDemoViviendaServicio.consulta(tipolistaPrincipal.principal, datSocConyugueBean, {
	callback : function(vivienda) {
		if (vivienda != null) {
			$('#tipoViviendaID').val(vivienda.tipoViviendaID);
			$('#tiempoHabitarDom').val(vivienda.tiempoHabitarDom);
			$('#tiempoHabitarDom').val(vivienda.tiempoHabitarDom);
		} else {
			$('#tiempoHabitarDom').val(0);
			$('#tiempoHabitarDom').val(0);
		}
	},
	errorHandler : function(message) {
		mensajeSis("Error al Consultar Datos de la Vivienda. " + message);
	}
	});
}
function consultaSocioDemograficos() {
	var SociodemograficosBean = {
	'prospectoID' : $('#prospectoID').val(),
	'clienteID' : $('#clienteID').val()
	};
	datSocDemogServicio.consulta(1, SociodemograficosBean, {
	callback : function(SocioDemograficos) {
		if (SocioDemograficos != null) {
			$('#mesesOcupacion').val(SocioDemograficos.antiguedadLab);
			$('#numDepenEconomi').val(SocioDemograficos.numDepenEconomi);
		} else {
			$('#mesesOcupacion').val(0);
			$('#numDepenEconomi').val(0);
		}
		
	},
	errorHandler : function(message) {
		mensajeSis("Error al Consultar Datos Socio Demográficos. " + message);
	}
	});
}
function llenaTipoComboTiposViviendaCli() {
	var todos = 0;
	var datSocDemogBean = {
		'tipoMaterialID' : todos
	};
	var tipoListaPrincipal = 1;
	dwr.util.removeAllOptions('tipoViviendaID');
	socDemoViviendaServicio.comboTiposVivienda(tipoListaPrincipal, datSocDemogBean, {
	callback : function(lisTiposViv) {
		dwr.util.removeAllOptions('tipoViviendaID');
		dwr.util.addOptions('tipoViviendaID', {
			'' : 'SELECCIONAR'
		});
		dwr.util.addOptions('tipoViviendaID', lisTiposViv, 'tipoViviendaID', 'descripVivienda');
	},
	errorHandler : function(message) {
		mensajeSis("Error al Consultar Información para los Tipos de Vivienda."+ message);
	}
	});
}

function consultaDatosSocioeconomicos(numCliente, prospectoID) {
	
	var datSocConyugueBean = {
		'prospectoID' : prospectoID,
		'clienteID' : numCliente,
		'solicitudCreditoID' : 0,
		'catSocioEID' : $('#IDGastoAlimenta').val()
	};
	clidatsocioeServicio.consulta(catTipoConsultaCliDatSocioE.SocioAlimentacion, datSocConyugueBean, {
	callback : function(CliDatSocioE) {
		if (CliDatSocioE != null) {
			$('#SocioEMontoAlimentacion').val(CliDatSocioE.montoAlimentacion);
			$('#egresosMensuales').val(CliDatSocioE.egresos);
			$('#ingresosMensuales').val(CliDatSocioE.ingresos);
			
			CalculaCapacidadPago();
		}
	},
	errorHandler : function(message) {
		mensajeSis("Error en Consulta de Datos Socio Económicos.");
	}
	});
}

/* ************************ BURO DE CREDITO **************************** */
function consultaBuro(rfc) {
	var solBuroBean = {
		'RFC' : rfc
	};
	solBuroCredServicio.consulta(5, solBuroBean, {
	callback : function(folio) {
		if (folio != null) {
			if (folio.diasVigencia > 0) {
				$('#calificaBuro').val(folio.calificacionMOP);
				if ($('#calificaBuro').val() == '') {
					$('#calificaBuro').val('SIN CALIFICACIÓN');
					
				}
			} else {
				mensajeSis("Es Necesario Consultar los datos del Cliente en Buro de Crédito");
				$('#solicitudCreditoID').focus();
				$('#solicitudCreditoID').val('');
				inicializaForma('formaGenerica', 'solicitudCreditoID');
				inicializaCombos();
				deshabilitaBoton('generar', 'submit');
				deshabilitaBoton('imprimir', 'submit');
				/*Autorizacion del proceso*/
				deshabilitaBoton('rechazar', 'submit');
				deshabilitaBoton('regresar', 'submit');
				deshabilitaBoton('procesar', 'submit');
				/*Fin Autorizacion del proceso*/
			}
		} else {
			$('#folioConsulta').val("");
			$('#fechaConsulta').val("");
			$('#diasVigenciaBC').val('');
			
		}
		
	},
	errorHandler : function(message,exc) {
		mensajeSis("Error en Consulta de Buro."+ message);
		//mensajeSis("Error message is: " + message + " - Error Details: " + dwr.util.toDescriptiveString(exc, 2));

	}
	});
}

/* *************************************** CALCULOS ******************** */
function CalculaCapacidadPago() {
	var margenGastos = parseFloat(0.0);
	var gastosAlimentacion = $('#SocioEMontoAlimentacion').asNumber();
	var totalGastosAlimentInte = gastosAlimentacion * ($('#numDepenEconomi').asNumber() + 1);// Gastos de alimentacion *(numero de dependientes economicos + el cliente)
	
	var ingresosMensuales = $('#ingresosMensuales').asNumber();
	var gastosAlimentacionTotal = parseFloat(totalGastosAlimentInte);
	var egresosMensuales = $('#egresosMensuales').asNumber() - gastosAlimentacion;
	
	if (Var_EsMarginada == 'S') {// verificamos los gastos minimos a considerar segun el tipo de localidad del cliente/prospecto			
		margenGastos = $('#gastosRural').asNumber();
		if (totalGastosAlimentInte < margenGastos) { // se comparan los gastos de alimentacion contra el margen de Gastos Rural
			gastosAlimentacionTotal = margenGastos;
		}
	} else {
		margenGastos = $('#gastosUrbana').asNumber();
		if (totalGastosAlimentInte < margenGastos) { // Se comparan los Gastos de Alimentacion contra el margen de Gastos Urbana
			gastosAlimentacionTotal = margenGastos;
		}
	}
	
	/* Nota: la suma total de los egresos mensuales no debe de traer lo de la alimentacion */
	/*FORMULAS
	 EgresosMarginales= Egresos*(Porcentaje de cobertura/100)+1
	 IngresosNetos = IngresosMensuales- IngresosMarginales
	 Cobertura=	IngresosNetos/MontoCuota
	 Porcentaje de Gatos Actuales sin el Credito = EgresosMarginales /IngresosMensuales
	  Porcentaje de Gatos Actuales CON el Credito = (EgresosMarginales+ MontoCuota) /IngresosMensuales
	 */

	$('#egresosMarginales').val((egresosMensuales + parseFloat(gastosAlimentacionTotal)) * (($('#porcentajeCob').asNumber() / 100) + 1));
	$('#ingresosNetos').val(ingresosMensuales - $('#egresosMarginales').asNumber());
	$('#cobertura').val(($('#ingresosNetos').asNumber() / $('#montoCuota').asNumber()) * 100);
	
	if (ingresosMensuales == 0) { //Para evitar la division entre Cero
		$('#gastosActuales').val('100');
		$('#gastosConCredito').val('100');
	} else {
		$('#gastosActuales').val(($('#egresosMarginales').asNumber() / ingresosMensuales) * 100);
		$('#gastosConCredito').val((($('#egresosMarginales').asNumber() + $('#montoCuota').asNumber()) / ingresosMensuales) * 100);
	}
	
	$('#gastosActuales').formatCurrency({
	positiveFormat : '%n',
	roundToDecimalPlace : 2
	});
	$('#gastosConCredito').formatCurrency({
	positiveFormat : '%n',
	roundToDecimalPlace : 2
	});
	
	agregaFormatoControles('formaGenerica');
}

function consultaParametrosCaja() {
	setTimeout("$('#cajaLista').hide();", 200);
	var tipoCon = 1;
	var ParametrosCajaBean = {
		'empresaID' : 1
	};
	parametrosCajaServicio.consulta(tipoCon, ParametrosCajaBean, {
	callback : function(parametrosCajaBean) {
		if (parametrosCajaBean != null) {
			$('#gastosUrbana').val(parametrosCajaBean.gastosUrbana);
			$('#gastosRural').val(parametrosCajaBean.gastosRural);
			$('#porcentajeCob').val(parametrosCajaBean.porcentajeCob);
			$('#IDGastoAlimenta').val(parametrosCajaBean.IDGastoAlimenta);
			$('#gastosPasivos').val(parametrosCajaBean.gastosPasivos);
			muestraGastosPasivos();
		}
	},
	errorHandler : function(message) {
		mensajeSis("Error en consulta de Párametros de la Caja para la Consulta de los Ratios." + message);
	}
	});
}

function muestraGastosPasivos() {
	var numCon = 4;
	var tdsFor = '';
	var tds = '';
	var totalGastosPasivos = 0;
	
	$("#tablaGastosPasivos").hide();
	eliminaTablaGastosPasivos();
	var gastosPasivos = {
	'linNegID' : 0,
	'clienteID' : $('#clienteID').val(),
	'prospectoID' : $('#prospectoID').val(),
	'tipoPersona' : ''
	};
	
	clidatsocioeServicio.lista(numCon, gastosPasivos, {
	callback : function(gastosPasivos) {
		if (gastosPasivos != null || !gastosPasivos.isEmpty()) {
			for (var i = 0; i < gastosPasivos.length; i++) {
				tdsFor += '<tr id="filaGastos' + i + '" name="filaGastos">';
				tdsFor += '<td class="label" nowrap="nowrap" style="width: 150px"><label for="lblantiguedad">' + gastosPasivos[i].descripcion + ':</label></td>"';
				tdsFor += '<td style="text-align: right;"><input  id="monto' + i + '" name="monto"   size="20" value="' + gastosPasivos[i].monto + '" esMoneda="true" style="text-align: right;" readOnly="true" type="text" /></td>';
				tdsFor += '</tr>';
				totalGastosPasivos = parseFloat(totalGastosPasivos) + parseFloat(gastosPasivos[i].monto);
				
			}
			
			if (i = parseFloat(gastosPasivos.length)) {
				$("#tablaGastosPasivos").append(tdsFor);
				totalPasivosCalculado = parseFloat(totalDeudasCreditos) + totalGastosPasivos;
				
				tds += '<tr id="filaGastos' + i + '" name="filaGastos">';
				tds += '<td class="label" nowrap="nowrap" style="width: 150px"><label for="lblantiguedad"> Con la Caja:</label></td>"';
				tds += '<td style="text-align: right;"><input  id="monto' + i + '" name="monto"   size="20" value="' + totalDeudasCreditos + '" esMoneda="true" onblur="calculaCapital()" readOnly="true" style="text-align: right;" type="text" /></td>';
				tds += '</tr>';
				tds += '<tr id="filaGastos' + i + '" name="filaGastos">';
				tds += '<td class="label" nowrap="nowrap" style="width: 150px"><label for="lblantiguedad"><b> Total:</b></label></td>"';
				tds += '<td style="text-align: right;"><input  id="totalPasivos" name="totalPasivos"   size="20" value="' + totalPasivosCalculado + '"  style="text-align: right;" esMoneda="true" readOnly="true" type="text" /></td>';
				tds += '</tr>';
				$("#tablaGastosPasivos").append(tds);
				$("#tablaGastosPasivos").show();
				calculaCapital(); // se vuelve a llamar la funcion de calculo
				// del capital
			} else if (i == 0) {
				muestraTablaPasivos(i);
			}
			
		}
	},
	errorHandler : function(message) {
		mensajeSis("Error en consulta de Gastos Pasivos." + message);
	}
	});
	
	agregaFormatoControles('formaGenerica');
	
}

function muestraTablaPasivos(i) {
	var tds = '';
	tds += '<tr id="filaGastos' + i + '" name="filaGastos">';
	tds += '<td class="label" nowrap="nowrap" style="width: 150px"><label for="lblantiguedad"> Con la Caja:</label></td>"';
	tds += '<td style="text-align: right;"><input  id="monto' + i + '" name="monto"   size="20" value="' + totalDeudasCreditos + '" esMoneda="true" style="text-align: right;"  readOnly="true" type="text" onblur="calculaCapital()" /></td>';
	tds += '</tr>';
	tds += '<tr id="filaGastos' + i + '" name="filaGastos">';
	tds += '<td class="label" nowrap="nowrap" style="width: 150px"><label for="lblantiguedad"><b> Total:</b></label></td>"';
	tds += '<td style="text-align: right;"><input  id="totalPasivos" name="totalPasivos"   size="20" value="' + totalDeudasCreditos + '" style="text-align: right;" esMoneda="true" readOnly="true" type="text" /></td>';
	tds += '</tr>';
	$("#tablaGastosPasivos").append(tds);
	$("#tablaGastosPasivos").show();
	calculaCapital(); // se vuelve a llamar la funcion de calculo del capital
}

function eliminaTablaGastosPasivos() {
	
	$('tr[name=filaGastos]').each(function() {
		var numero = this.id.substr(10, this.id.length);
		$("#filaGastos" + numero).remove();
		
	});
}

function consultaEstabilidadNegocio() {
	var ratiosBean = {
		'ratiosPorClasifID' : 16
	};
	dwr.util.removeAllOptions('estabilidadEmpleo');
	dwr.util.addOptions('estabilidadEmpleo', {
		'' : 'SELECCIONAR'
	});
	
	ratiosServicio.listaCombo(2, ratiosBean, {
	callback : function(ratios) {
		dwr.util.addOptions('estabilidadEmpleo', ratios, 'ratiosPuntosID', 'descripcion');
	},
	errorHandler : function(message) {
		mensajeSis("Error en consulta en Estabilidad del Negocio." + message);
	}
	});
}

function consultaEstabilidadVentasMensuales() {
	var ratiosBean = {
		'ratiosPorClasifID' : 17
	};
	dwr.util.removeAllOptions('ventasMensuales');
	dwr.util.addOptions('ventasMensuales', {
		'' : 'SELECCIONAR'
	});
	
	ratiosServicio.listaCombo(2, ratiosBean, {
	callback : function(ratios) {
		dwr.util.addOptions('ventasMensuales', ratios, 'ratiosPuntosID', 'descripcion');
		
	},
	errorHandler : function(message) {
		mensajeSis("Error en consulta en Estabilidad de Ventas Mensuales." + message);
	}
	});
}

function consultaEstabilidadLiquidez() {
	var ratiosBean = {
		'ratiosPorClasifID' : 18
	};
	dwr.util.removeAllOptions('liquidez');
	dwr.util.addOptions('liquidez', {
		'' : 'SELECCIONAR'
	});
	
	ratiosServicio.listaCombo(2, ratiosBean, {
		callback : function(ratios) {
			dwr.util.addOptions('liquidez', ratios, 'ratiosPuntosID', 'descripcion');
			
		},
		errorHandler : function(message) {
			mensajeSis("Error en consulta de Estabilidad/Liquidez." + message);
		}
	});
}

function consultaEstabilidadMercado() {
	var ratiosBean = {
		'ratiosPorClasifID' : 19
	};
	dwr.util.removeAllOptions('situacionMercado');
	dwr.util.addOptions('situacionMercado', {
		'' : 'SELECCIONAR'
	});
	
	ratiosServicio.listaCombo(2, ratiosBean, {
	callback : function(ratios) {
		dwr.util.addOptions('situacionMercado', ratios, 'ratiosPuntosID', 'descripcion');
	},
	errorHandler : function(message) {
		mensajeSis("Error en consulta para la Estabilidad del Mercado." + message);
	}
	});
}

function consultaGarantiasAsigandas(SolicitudCreditoID, CreditoID) {
	var numCon = 2;
	var tds = '';
	
	$("#tablaGarantias").hide();
	$("#trEncabezadoGarantias").hide();
	eliminaTablaGarantias();
	var garantiasBean = {
	'solicitudCreditoID' : SolicitudCreditoID,
	'creditoID' : CreditoID,
	'garantiaID' : 0
	};
	
	garantiaServicioScript.lista(numCon, garantiasBean, {
	callback : function(garantias) {
		
		if (garantias != null || !garantias.isEmpty()) {
			totalAsignado = 0.0;
			totalValorComercial = 0.0;
			for (var i = 0; i < garantias.length; i++) {
				tds += '<tr id="renglon' + i + '" name="renglon">';
				tds += '<td><input  id="consecutivoID' + i + '" name="consecutivoID"  size="6"  value="1" autocomplete="off"  type="hidden" />';
				tds += '<input id="garantiaID' + i + '" name="garantiaID"  size="6" value="' + garantias[i].garantiaID + '" readOnly="true" autocomplete="off"  /></td>';
				tds += '<td><input type="text" id="observaciones' + i + '" name="observaciones" value="' + garantias[i].observaciones + '" readOnly="true" size="60"/></td>';
				tds += '<td style="text-align: right;"><input  id="valorComercial' + i + '" name="valorComercial"   size="20" value="' + garantias[i].valorComercial + '" esMoneda="true" readOnly="true" type="text" style="text-align: right;"/></td>';
				tds += '<td style="text-align: right;"><input  id="montoAsignado' + i + '" name="montoAsignado"  size="20" value="' + garantias[i].montoAsignado + '" esMoneda="true" readOnly="true" type="text" style="text-align: right;"/></td>';
				tds += '</tr>';
				
				totalAsignado = (parseFloat(totalAsignado) + parseFloat(garantias[i].montoAsignado));
				totalValorComercial = (parseFloat(totalValorComercial) + parseFloat(garantias[i].valorComercial));
			}
			
			if (i = parseFloat(garantias.length)) {
				tds += '<tr id="renglon' + i + '" name="renglon" >';
				tds += '<td class="separador" colspan="2"></td>';
				tds += '<td class="label" style="text-align: right;"><label for="lblGarantizado">Total Garantizado:</label></td>';
				tds += '<td nowrap="nowrap" style="text-align: right;"><input type="text" id="garantizado" name="garantizado" readOnly="true"';
				tds += '	value="0" size="18"  esMoneda="true"   style="text-align: right;" /><label for="lblporcentaje">%</label></td>';
				tds += '</tr>';
				$("#tablaGarantias").append(tds);
				$("#trEncabezadoGarantias").show();
				$("fieldGarantias").show();
				$("#tablaGarantias").show();
				validaCubreMontoCredito();
			}
			agregaFormatoControles('formaGenerica');
			
			if (i == parseFloat(0)) {
				eliminaTablaGarantias();
				$("#trEncabezadoGarantias").hide();
				$("#tablaGarantias").hide();
				$("fieldGarantias").hide();
			}
		}
	},
	errorHandler : function(message) {
		mensajeSis("Error en consulta de Garantias Asignadas." + message);
	}
	});
	
}

function eliminaTablaGarantias() {
	$('tr[name=renglon]').each(function() {
		var numero = this.id.substr(7, this.id.length);
		$("#renglon" + numero).remove();
		
	});
}

function consultaFilas() {
	var totales = 0;
	$('tr[name=renglon]').each(function() {
		totales++;
	});
	return totales;
	
}

function validaCubreMontoCredito() {
	var montoCredito = $('#montoSolici').asNumber();
	var requerido = $('#relGarantCred').asNumber() / 100;
	var porcentaje = 0;
	if ((totalAsignado / requerido) >= montoCredito) {
		porcentaje = (totalAsignado * 100) / montoCredito;
		$('#garantizado').val(porcentaje);
	} else {
		porcentaje = (totalAsignado * 100) / montoCredito;
		$('#garantizado').val(porcentaje);
	}
}

function calculaCapital() {
	var totalActivos = $('#totalAhorro').asNumber() + $('#activosInversiones').asNumber() + $('#activosTerrenos').asNumber() + $('#vivienda').asNumber() + $('#activosVehiculos').asNumber() + $('#otrosActivos').asNumber();
	var totalPasivos = 0;
	$('input[name=monto]').each(function() {
		var numero = this.id.substr(5, this.id.length);
		totalPasivos = parseFloat(totalPasivos) + $("#monto" + numero).asNumber();
	});
	
	$('#totalPasivos').val(totalPasivos);
	
	var totalPasivos = $('#totalPasivos').asNumber();
	var montoCredito = $('#montoSolici').asNumber();
	var pasivosConCredito = totalPasivos + montoCredito;
	var deudaActualPorc = (totalPasivos / totalActivos) * 100;
	var deudaActualConCredPorc = (pasivosConCredito / totalActivos) * 100;
	
	$('#totalActivos').val(totalActivos);
	if (totalActivos == 0) {// Para evitar la division entre Cero
		$('#deudaActual').val('100');
		$('#deudaActualConCredito').val('100');
	} else {
		if(deudaActualPorc>100){
			deudaActualPorc = 100;
		} 
		if(deudaActualConCredPorc>100){
			deudaActualConCredPorc = 100;
		}
		$('#deudaActual').val(deudaActualPorc);
		$('#deudaActualConCredito').val(deudaActualConCredPorc);
	}
	
	agregaFormatoControles('formaGenerica');
	
}

function funcionExitoRatios() {
	deshabilitaBoton('rechazar', 'submit');
	deshabilitaBoton('regresar', 'submit');
	deshabilitaBoton('procesar', 'submit');
	$('#comentarioEjecutivo').val("");
	$('#gridComentarios').hide();
	consultaRatios();
}

function consultaRatios() {
	var ratiosBean = {
	'solicitudCreditoID' : $('#solicitudCreditoID').val(),
	'sucursalID' : parametroBean.sucursal,
	'empresaID' : 1
	};
	setTimeout("$('#cajaLista').hide();", 200);
	ratiosServicio.consulta(1, ratiosBean, {
	callback : function(ratios) {
		if (ratios != null) {
			$('#FielsetResultados').show();
			$('#nivelRiesgo').val(ratios.descripcionNivel);
			$('#totalResidencia').val(ratios.totalResidencia);
			$('#totalOCupacion').val(ratios.totalOCupacion);
			$('#totalMora').val(ratios.totalMora);
			$('#totalAfiliacion').val(ratios.totalAfiliacion);
			$('#totalDeudaActual').val(ratios.totalDeudaActual);
			$('#totalDeudaCredito').val(ratios.totalDeudaCredito);
			$('#totalCobertura').val(ratios.totalCobertura);
			$('#totalGastos').val(ratios.totalGastos);
			$('#totalGastosCredito').val(ratios.totalGastosCredito);
			$('#totalEstabilidadIng').val(ratios.totalEstabilidadIng);
			$('#totalNegocio').val(ratios.totalNegocio);
			$('#colaterales').val(ratios.colaterales);
			$('#puntosTotal').val(ratios.puntosTotal);
			
			$('#activosTerrenos').val(ratios.activosTerrenos);
			$('#vivienda').val(ratios.vivienda);
			$('#activosVehiculos').val(ratios.activosVehiculos);
			$('#otrosActivos').val(ratios.otrosActivos);

			$('#estabilidadEmpleo').val(ratios.estabilidadEmpleo);
			$('#ventasMensuales').val(ratios.ventasMensuales);
			$('#liquidez').val(ratios.liquidez);
			$('#situacionMercado').val(ratios.situacionMercado);
			if (ratios.tieneNegocio == SiTieneNegocio) {
				$('#tieneNegocio1').attr('checked', true);
				$('#trMontoVentas').show();
				$('#trSituacionMercado').show();
				
			} else {
				$('#tieneNegocio2').attr('checked', true);
				$('#trMontoVentas').hide();
				$('#trSituacionMercado').hide();
			}
			
			var arrayElementoOmitir=['solicitudCreditoID'];
			if (var_SolicitudEstatus == var_EstatusSolicitud.Inactiva) {
				
				switch(ratios.estatus){
					case catEstatusRatios.Guardada:
						deshabilitaBoton('generar', 'submit');
						deshabilitaBoton('guardar', 'submit');
						/*Autorizacion del proceso*/
						habilitaBoton('rechazar', 'submit');
						habilitaBoton('regresar', 'submit');
						habilitaBoton('procesar', 'submit');
						/*Fin Autorizacion del proceso*/
						habilitaBoton('imprimir', 'submit');
						mostrarComentarios('N');
						break;
					case catEstatusRatios.Rechazada:
						deshabilitaBoton('generar', 'submit');
						deshabilitaBoton('guardar', 'submit');
						/*Autorizacion del proceso*/
						deshabilitaBoton('rechazar', 'submit');
						deshabilitaBoton('regresar', 'submit');
						deshabilitaBoton('procesar', 'submit');
						/*Fin Autorizacion del proceso*/
						habilitaBoton('imprimir', 'submit');
						mostrarComentarios('N');
						break;
					case catEstatusRatios.Regresada:
						habilitaBoton('generar', 'submit');
						habilitaBoton('guardar', 'submit');
						/*Autorizacion del proceso*/
						deshabilitaBoton('rechazar', 'submit');
						deshabilitaBoton('regresar', 'submit');
						deshabilitaBoton('procesar', 'submit');
						/*Fin Autorizacion del proceso*/
						deshabilitaBoton('imprimir', 'submit');
						mostrarComentarios('N');
						break;
					case catEstatusRatios.Procesada:
						deshabilitaBoton('generar', 'submit');
						deshabilitaBoton('guardar', 'submit');
						/*Autorizacion del proceso*/
						deshabilitaBoton('rechazar', 'submit');
						deshabilitaBoton('regresar', 'submit');
						deshabilitaBoton('procesar', 'submit');
						/*Fin Autorizacion del proceso*/
						habilitaBoton('imprimir', 'submit');
						mostrarComentarios('N');
						break;
					case catEstatusRatios.Calculada:
						habilitaBoton('generar', 'submit');
						habilitaBoton('guardar', 'submit');
						deshabilitaBoton('imprimir', 'submit');
						/*Autorizacion del proceso*/
						deshabilitaBoton('rechazar', 'submit');
						deshabilitaBoton('regresar', 'submit');
						deshabilitaBoton('procesar', 'submit');
						mostrarComentarios('N');
						/*Fin Autorizacion del proceso*/
					break;
				}

			} else if(var_SolicitudEstatus!=var_EstatusSolicitud.Cancelada){
				switch(ratios.estatus){
					
					case catEstatusRatios.Guardada:
						deshabilitaBoton('generar', 'submit');
						deshabilitaBoton('generar', 'submit');
						/*Autorizacion del proceso*/
						deshabilitaBoton('rechazar', 'submit');
						deshabilitaBoton('regresar', 'submit');
						deshabilitaBoton('procesar', 'submit');
						/*Fin Autorizacion del proceso*/
						habilitaBoton('imprimir', 'submit');
						deshabilitarForma('formaGenerica', true,arrayElementoOmitir);
						mostrarComentarios('N');
						break;
					case catEstatusRatios.Rechazada:
						deshabilitaBoton('generar', 'submit');
						deshabilitaBoton('guardar', 'submit');
						/*Autorizacion del proceso*/
						deshabilitaBoton('rechazar', 'submit');
						deshabilitaBoton('regresar', 'submit');
						deshabilitaBoton('procesar', 'submit');
						/*Fin Autorizacion del proceso*/
						habilitaBoton('imprimir', 'submit');
						mostrarComentarios('N');
						deshabilitarForma('formaGenerica', true,arrayElementoOmitir);
						break;
					case catEstatusRatios.Regresada:
						deshabilitaBoton('generar', 'submit');
						deshabilitaBoton('guardar', 'submit');
						/*Autorizacion del proceso*/
						deshabilitaBoton('rechazar', 'submit');
						deshabilitaBoton('regresar', 'submit');
						deshabilitaBoton('procesar', 'submit');
						/*Fin Autorizacion del proceso*/
						habilitaBoton('imprimir', 'submit');
						mostrarComentarios('N');
						deshabilitarForma('formaGenerica', false,arrayElementoOmitir);
						break;
					case catEstatusRatios.Procesada:
						deshabilitaBoton('generar', 'submit');
						deshabilitaBoton('guardar', 'submit');
						/*Autorizacion del proceso*/
						deshabilitaBoton('rechazar', 'submit');
						deshabilitaBoton('regresar', 'submit');
						deshabilitaBoton('procesar', 'submit');
						/*Fin Autorizacion del proceso*/
						habilitaBoton('imprimir', 'submit');
						mostrarComentarios('N');
						deshabilitarForma('formaGenerica', true,arrayElementoOmitir);
						break;
					case catEstatusRatios.Calculada:
						habilitaBoton('generar', 'submit');
						habilitaBoton('guardar', 'submit');
						deshabilitaBoton('imprimir', 'submit');
						/*Autorizacion del proceso*/
						deshabilitaBoton('rechazar', 'submit');
						deshabilitaBoton('regresar', 'submit');
						deshabilitaBoton('procesar', 'submit');
						mostrarComentarios('N');
						deshabilitarForma('formaGenerica', false,arrayElementoOmitir);
						/*Fin Autorizacion del proceso*/
					break;
				}
				mensajeSis("La Solicitud no se encuentra Inactiva");
			} else {
				if(ratios.estatus == catEstatusRatios.Guardada || ratios.estatus == catEstatusRatios.Rechazada){
					habilitaBoton('imprimir', 'submit');
				}
			}
			
			agregaFormatoControles('formaGenerica');
		} else {
			$('#FielsetResultados').hide();
			if (var_SolicitudEstatus == var_EstatusSolicitud.Inactiva) {
				habilitaBoton('generar', 'submit');
				deshabilitaBoton('guardar', 'submit');
				deshabilitaBoton('imprimir', 'submit');
			} else {
				mensajeSis("La Solicitud no se encuentra Inactiva");
				deshabilitaBoton('guardar', 'submit');
				deshabilitaBoton('generar', 'submit');
				deshabilitaBoton('imprimir', 'submit');
				/*Autorizacion del proceso*/
				deshabilitaBoton('rechazar', 'submit');
				deshabilitaBoton('regresar', 'submit');
				deshabilitaBoton('procesar', 'submit');
				/*Fin Autorizacion del proceso*/
			}
			
		}
	},
	errorHandler : function(message) {
		mensajeSis("Error en consulta de los ratios.<br>" + message);
	}
	});
}

function consultaDatosGenerales() {
	var ratiosBean = {
	'solicitudCreditoID' : $('#solicitudCreditoID').val(),
	'sucursalID' : parametroBean.sucursal,
	'empresaID' : 1
	};
	
	setTimeout("$('#cajaLista').hide();", 200);
	ratiosServicio.consulta(2, ratiosBean, {
	callback : function(ratios) {
		if (ratios != null) {
			$('#montoCuota').val(ratios.cuotaMaxima);
		}
	},
	errorHandler : function(message) {
		mensajeSis("Error en consulta de datos generales." + message)
	}
	});
}

function funcionErrorRatios() {
	
}

function inicializaCombos() {
	$('#plazoID').val('');
	$('#tipoViviendaID').val('');
	$('#morosidadCredito').val('');
	$('#cliente').val('');
	$('#estabilidadEmpleo').val('');
	inicializaComboNoNegocioC4();
}

function inicializaComboNoNegocioC4() {
	$('#ventasMensuales').val('');
	$('#liquidez').val('');
	$('#situacionMercado').val('');
}
/**
 * Método para mostrar los comentarios
 * @param TipoOperacion
 */
function mostrarComentarios(TipoOperacion){
	switch(TipoOperacion){
		case catTipoTraRatios.regresar:
			$('#legendRegreso').show();
			$('#legendRechazo').hide();
			$('#legendProceso').hide();
			$('#guardarRegresar').show();
			$('#guardarRechazo').hide();
			$('#guardarProcesar').hide();
			$('#comentariosRegreso').show();
			$('#comentariosRechazo').hide();
			$('#comentariosProceso').hide();
			$('#gridComentarios').show();
			break;
		case catTipoTraRatios.rechazar:
			$('#legendRegreso').hide();
			$('#legendRechazo').show();
			$('#legendProceso').hide();
			$('#guardarRegresar').hide();
			$('#guardarRechazo').show();
			$('#guardarProcesar').hide();
			$('#comentariosRegreso').hide();
			$('#comentariosRechazo').show();
			$('#comentariosProceso').hide();
			$('#gridComentarios').show();
			break;
		case catTipoTraRatios.procesar:
			$('#legendRegreso').hide();
			$('#legendRechazo').hide();
			$('#legendProceso').show();
			$('#guardarRegresar').hide();
			$('#guardarRechazo').hide();
			$('#guardarProcesar').show();
			$('#comentariosRegreso').hide();
			$('#comentariosRechazo').hide();
			$('#comentariosProceso').show();
			$('#gridComentarios').show();
			break;
		default:
			$('#gridComentarios').hide();
			$('#legendRegreso').hide();
			$('#legendRechazo').hide();
			$('#legendProceso').hide();
			$('#guardarRegresar').hide();
			$('#guardarRechazo').hide();
			$('#guardarProcesar').hide();
			$('#comentariosRegreso').hide();
			$('#comentariosRechazo').hide();
			$('#comentariosProceso').hide();
	};
	
}

function inicializarCalcRatios(){
	esTab = true;

	//	------------ Metodos y Manejo de Eventos Solicitud Grupal -----------------------------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('generar', 'submit');
	deshabilitaBoton('imprimir', 'submit');
	deshabilitaBoton('guardar', 'submit');
	/*Autorizacion del proceso*/
	deshabilitaBoton('rechazar', 'submit');
	deshabilitaBoton('regresar', 'submit');
	deshabilitaBoton('procesar', 'submit');
	/*Fin Autorizacion del proceso*/
	llenaTipoComboTiposViviendaCli();

	consultaEstabilidadNegocio();
	consultaEstabilidadVentasMensuales();
	consultaEstabilidadLiquidez();
	consultaEstabilidadMercado();
	muestraTablaPasivos();

	/* Valida en la pantalla de solicitud grupal el numero de solicitud (perteneciente al grupo)seleccionado 
	no eliminar, no afecta el comportamiento de la pantalla de manera individual */

	if ($('#numSolicitud').val() != "") {
		var numSolicitud = $('#numSolicitud').val();
		$('#solicitudCreditoID').val(numSolicitud);
		$('#solicitudCreditoID').focus();
		validaSolicitudCredito('solicitudCreditoID');

	}
}
/**
 * Consulta el número de Avales que tiene la solicitud de Crédito
 * @param solicitudCreditoID: Numero de solicitud
 */
function consultaNAvales(solicitudCreditoID) {
	$('#nAvales').val('');
	var ratiosBean = {
		'solicitudCreditoID' : solicitudCreditoID
	};
	setTimeout("$('#cajaLista').hide();", 200);
	ratiosServicio.consulta(3, ratiosBean, {
		callback : function(ratios) {
			if (ratios != null) {
				$('#nAvales').val(ratios.nAvales);
			} else {
				$('#nAvales').val(0);
			}
		},
		errorHandler : function(message) {
			mensajeSis("Error en consulta de los Avales.<br>" + message);
		}
	});
}