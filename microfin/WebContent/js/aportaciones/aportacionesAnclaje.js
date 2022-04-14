var estatus = '';
var Var_TipoBeneficiario = '';
var anclaje = '';
var tasaMejorada = '';
var espTasa = '';
var aportacionOrig = '';
var tasaOrig;
var minimoAnclaje = 0;

$(document).ready(function() {

	esTab = true;

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if(e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	// Definicion de Constantes y Enums
	var esTab = true;
	var parametroBean = consultaParametrosSession();
	var diasBase = parametroBean.diasBaseInversion;
	var salarioMinimo = parametroBean.salMinDF;
	var diaHabilSiguiente = '1'; // indica dia habil Siguiente
	var pusoFecha = 0;
	var relaciones = '';
	var provCompetencia = '';
	var calificacion = '';

	deshabilitaControl('nuevoInteresGen');
	deshabilitaControl('nuevoInteresRec');

	var catTipoTransaccionInverAnclaje = {
		'agrega': 1,
	};

	var catTipoConsultaInverAnclaje = {
		'principal': 1,
		'foranea': 2
	};


	var catOperacFechas = {
		'sumaDias': 1,
		'restaFechas': 2
	};

	var catStatusAportaciones = {
		'alta': 'A',
		'cargada': 'N',
		'pagada': 'P',
		'cancelada': 'C'
	};

	var catStatusCuenta = {
		'activa': 'A'
	};

	var catTipoConsultaAportacion = {
		'principal': 1,
		'anclaje': 3
	};
	var catTipoConsultaTipoAportacion = {
		'principal': 1
	};
	var catTipoListaTipoInversion = {
		'principal': 1,
	};

	var catTipoListaCliente = {
		'principal': '1'
	};
	var catTipoListaCuentas = {
		'foranea': '2'
	};
	var catTipoConsultaCuentas = {
		'conSaldo': 5
	};
	var catTipoConsultaCliente = {
		'paraAportaciones': 6
	};
	var catTipoListaInversion = {
		'principal': 1,
		'inverAnclaje': 2,
		'inverSinAnc': 3

	};

	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('imprimirPagare', 'submit');

	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'aportAnclajeID', 'exito', 'error');
		}
	});

	$('#aportAnclajeID').focus();
	$('#direccion').val('');
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('agrega', 'submit');
	$('#tdCajaRetiro').hide();
	validaEmpresaID();
	ocultaTasaVariable();
	$('#plazo').val('');


	$('#agrega').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionInverAnclaje.agrega);
	});


	$('#aportAnclajeID').bind('keyup', function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreCliente";
		camposLista[1] = "estatus";
		parametrosLista[0] = $('#aportAnclajeID').val();
		parametrosLista[1] = catStatusAportaciones.cargada;

		lista('aportAnclajeID', 2, catTipoListaInversion.inverAnclaje, camposLista,
			parametrosLista, 'anclajeAportacionesLista.htm');
	});

	$('#aportacionOriID').bind('keyup', function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreCliente";
		camposLista[1] = "estatus";
		parametrosLista[0] = $('#aportacionOriID').val();
		parametrosLista[1] = catStatusAportaciones.cargada;

		lista('aportacionOriID', 2, catTipoListaInversion.inverSinAnc, camposLista,
			parametrosLista, 'anclajeAportacionesLista.htm');
	});

	$('#aportAnclajeID').blur(function() {
		if(esTab) {
			validaAportacionAnclaje(this.id);
		}
	});

	$('#aportacionOriID').blur(function() {
		if(esTab)
		{
			//BORRA TODO FORMA
			borraCondiciones();
			//BORRA TODO FORMA
			consultaAportacion(this.id);
			$('#monto').formatCurrency({
				positiveFormat: '%n',
				roundToDecimalPlace: 2
			});
		}

	});


	$('#montoAnclar').blur(function() {
		if($('#montoAnclar').val()!="" & esTab == true) {
			if($('#montoAnclar').asNumber()>=minimoAnclaje){
					calculaCondicionesAportacion();
					var montoAnclar = $('#montoAnclar').asNumber();
					var plazoInvOri = $('#plazoInvOr').val();
					var montoTotal = montoAnclar;
					montoTotal = Math.round(montoTotal * 100) / 100;

					$('#monto').val(montoTotal);
					var montoTotalAportaciones = Math.round(($('#montoAnclar').asNumber() + $('#montOriginal').asNumber() + $('#montosAnclados').asNumber()) * 100) / 100;
					$('#montoTotal').val(montoTotalAportaciones);
					$('#montConjuntoF').val(montoTotalAportaciones);

					$('#montoTotal').formatCurrency({
						positiveFormat: '%n',
						roundToDecimalPlace: 2
					});

					$('#montConjuntoF').formatCurrency({
						positiveFormat: '%n',
						roundToDecimalPlace: 2
					});

					if($('#montoAnclar').asNumber() <= $('#totalCuenta').asNumber()) {
						calculaNodeDias();
						$('#monto').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
					} else {
						mensajeSis("El Monto es superior al Saldo en la Cuenta.");
						$('#monto').val('');
						$('#montoAnclar').focus();
						$('#montoAnclar').val('');
						borraCondiciones();
					}
				}else{
					mensajeSis("El Monto es menor al Monto Mínimo de Anclaje.");
					$('#monto').val('');
					$('#montoAnclar').focus();
					$('#montoAnclar').val('');
					borraCondiciones();
				}
		}
		else if($('#montoAnclar').val()==""){
			$('#monto').val('');
			$('#montoAnclar').val('');

			$('#granTotal').val('');
			$('#montoTotal').val('');
			borraCondiciones();
		}

	});



	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {

			montoAnclar: {
				required: true,
				number: true
			},
			plazo: 'required',
			fechaVencimiento: 'required',

		},

		messages: {
			montoAnclar: {
				required: 'Especifique la cantidad a anclar.',
				number: 'Sólo Números.'
			},
			plazo: 'Especifique el plazo de la Aportación.',
			fechaVencimiento: 'Especifique la fecha de vencimiento.',

		}

	});


	function obtenDia() {
		return parametroBean.fechaSucursal;
	}



	//funciones controles
	function fechaHabil(fechaPosible, idControl) {
		var plazoInvOri = $('#plazoInvOr').val();
		var diaFestivoBean = {
			'fecha': fechaPosible,
			'numeroDias': 0,
			'salidaPantalla': 'S'
		};
		diaFestivoServicio.calculaDiaFestivo(1, diaFestivoBean, function(data) {
			if(data != null) {
				var opeFechaBean = {
					'primerFecha': $('#fechaVencimiento').val(),
					'segundaFecha': parametroBean.fechaSucursal
				};


				operacionesFechasServicio.realizaOperacion(opeFechaBean, catOperacFechas.restaFechas, function(data) {
					if(data != null) {
						$('#plazo').val(data.diasEntreFechas);
						$('#plazoOriginal').val(data.diasEntreFechas);
						CalculaValorTasa(idControl);
					} else {
						mensajeSis("Ha ocurrido un error Interno al Consultar Fechas.");
					}
				});
			} else {
				mensajeSis("Ha ocurrido un error al calcular Dias Festivos.");
			}
		});

	}




	function validaAportacionAnclaje(idControl) {
		var jqAportacion = eval("'#" + idControl + "'");
		var aportacionOri = $(jqAportacion).val();
		var tipConsulta = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		if(aportacionOri != '' && !isNaN(aportacionOri)) {
			if(aportacionOri == '0') {
				habilitaBoton('agrega', 'submit');
				inicializaForma('formaGenerica', idControl);
				habilita();
				$('#aportacionOriID').focus();
				$('#plazoOriginal').val('');
				$('#interesRetener').val('');
				$('#interesRecibir').val('');
				$('#destasaBaseID').val('');
				$('#montOriginal').val('');
				$('#plazoInvOr').val('');
				$('#tasaAportacionOr').val('');
				$('#interesGenInOri').val('');
				$('#interesRetOri').val('');
				$('#interesRecInOri').val('');
				$('#montConjuntoF').val('');
				$('#interesGenInOri').val('');
				$('#nuevaTasa').val('');
				$('#nuevoInteresGen').val('');
				$('#nuevoInteresRec').val('');

			} else {
				//preguntar si se ecnuentra en AportaciónANCLAJE
				var aportacionAnc = $('#aportAnclajeID').val();
				var aportacionBean = {
					'aportAnclajeID': aportacionAnc
				};

				aportacionesAnclajeServicio.consulta(tipConsulta, aportacionBean, function(aportacionAncla) {
					if(aportacionAncla != null) {
						//esTab = true;
						$('#aportacionOriID').val(aportacionAncla.aportacionOriID);
						$('#cuentaAhoID').val(aportacionAncla.cuentaAhoID);
						//Aportación Madre
						$('#montOriginal').val(aportacionAncla.montOriginal);
						$('#interesRetOri').val(aportacionAncla.interesRetenerOriginal);
						$('#plazoInvOr').val(aportacionAncla.plazoInvOr);
						$('#tasaAportacionOr').val(aportacionAncla.tasaOriginal);
						$('#nuevoInteresGen').val(aportacionAncla.nuevoInteresGen);
						$('#interesGenInOri').val(aportacionAncla.interesGeneradoOriginal);
						$('#interesRecInOri').val(aportacionAncla.interesRecibirOriginal);
						$('#tipoAportacionID').val(aportacionAncla.tipoAportacionID);
						$('#nuevoInteresRec').val(aportacionAncla.nuevoInteresRec);

						$('#montoAnclar').val(aportacionAncla.montoAnclar);
						$('#nuevaTasa').val(aportacionAncla.nuevaTasa);

						//CONDICIONES
						$('#monto').val(aportacionAncla.monto);
						$('#plazoOriginal').val(aportacionAncla.plazo);
						$('#plazo').val(aportacionAncla.plazo);
						$('#fechaInicio').val(aportacionAncla.fechaInicio);
						$('#fechaVencimiento').val(aportacionAncla.fechaVencimiento);
						$('#tasaBruta').val(aportacionAncla.tasaFija);
						$('#tasaISR').val(aportacionAncla.tasaISR);
						$('#tasaNeta').val(aportacionAncla.tasaNeta);

						$('#valorGat').val(aportacionAncla.valorGat);
						$('#interesGenerado').val(aportacionAncla.interesGenerado);
						$('#interesRetener').val(aportacionAncla.interesRetener);
						$('#interesRecibir').val(aportacionAncla.interesRecibir);
						$('#valorGatReal').val(aportacionAncla.valorGatReal);
						$('#montoTotal').val(aportacionAncla.montoTotal);
						$('#granTotal').val(aportacionAncla.granTotal);
						$('#montConjuntoF').val(aportacionAncla.montoTotal);


						$('#montoAnclar').val(aportacionAncla.monto);
						$('#montConjuntoF').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
						$('#montOriginal').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
						$('#monto').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
						$('#interesGenInOri').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
						$('#interesRetOri').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
						$('#interesRecInOri').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
						$('#nuevoInteresGen').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
						$('#nuevoInteresRec').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
						$('#tasaBruta').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 4
						});
						$('#tasaISR').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 4
						});
						$('#tasaNeta').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 4
						});

						$('#interesGenerado').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});

						$('#interesRetener').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});

						$('#interesRecibir').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});

						//Fin llenado de forma ***************************************************

						deshabilitaControl('aportacionOriID');
						deshabilitaBoton('agrega', 'submit');
						deshabilita();
						consultaSoloCuentaAho();
						consultaCliente(aportacionAncla.clienteID);
						validaTipoAportacion(aportacionAncla.tipoAportacionID);
						$('#telefono').setMask('phone-us');
						$('#montoTotal').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
						$('#montoAnclar').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
						$('#granTotal').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
						if(aportacionAncla.estatus=='N')
						 mensajeSis("La Aportación ya se encuentra Vigente.");
						else
							if(aportacionAncla.estatus=='A')
								mensajeSis("La Aportación ya se encuentra Registrada.");
							else
								if(aportacionAncla.estatus=='P')
									mensajeSis("La Aportación ya se encuentra Pagada.");
								else
									if(aportacionAncla.estatus=='C')
										mensajeSis("La Aportación ya se encuentra Cancelada.");


					} else {
						mensajeSis("No Existe el Anclaje.");

						inicializaValores();
						inicializarForm();
						$('#aportAnclajeID').focus();
						$('#aportAnclajeID').val('');
						deshabilitaBoton('agrega', 'submit');
					}
				});
			}
		}else{
			mensajeSis("No Existe el Anclaje.");
			inicializaValores();
			inicializarForm();
			$('#aportAnclajeID').focus();
			$('#aportAnclajeID').val('');
			deshabilitaBoton('agrega', 'submit');
		}


	}

	function consultaAportacion(idControl) {
		var jqAportacion = eval("'#" + idControl + "'");
		var numAportacion = $(jqAportacion).val();

		setTimeout("$('#cajaLista').hide();", 200);

		if(numAportacion != '' && !isNaN(numAportacion)) {

			if(numAportacion == '0') {
				deshabilitaBoton('agrega', 'submit');
				deshabilitaBoton('imprimirPagare', 'submit');
				inicializaForma('formaGenerica', 'aportacionOriID');
				$('#aportacionOriID').focus();
				$('#aportacionOriID').val("");
				mensajeSis("La Aportación No Existe.");

			} else {
				var AportaBean = {
					'aportacionID': numAportacion
				};
				aportacionesServicio.consulta(6, AportaBean, function(aportBean) {
					if(aportBean != null) {
						relaciones = aportBean.relaciones;
						estatus = aportBean.estatus;
						tasaOrig = aportBean.tasaFija;

						$('#clienteID').val(aportBean.clienteID);
						$('#cuentaAhoID').val(aportBean.cuentaAhoID);

						$('#fechaInicio').val(parametroBean.fechaSucursal);
						$('#fechaVencimiento').val(aportBean.fechaVencimiento);


						$('#montOriginal').val(aportBean.monto);
						$('#interesGenInOri').val(aportBean.interesGenerado);
						$('#interesRetOri').val(aportBean.interesRetener);
						$('#interesRecInOri').val(aportBean.interesRecibir);
						$('#tasaAportacionOr').val(aportBean.tasaFija);
						$('#plazoInvOr').val(aportBean.plazo);
						$('#tipoAportacionID').val(aportBean.tipoAportacionID);
						$('#tasaBaseIDOri').val(aportBean.tasaBase);
						$('#sobreTasaOr').val(aportBean.sobreTasa);
						$('#pisoTasaOr').val(aportBean.pisoTasa);
						$('#techoTasaOr').val(aportBean.techoTasa);
						$('#calculoInteOri').val(aportBean.calculoInteres);
						$('#nuevoInteresGen').val(aportBean.interesGenerado);
						$('#nuevoInteresRec').val(aportBean.interesRecibir);
						$('#plazoOriginalMadre').val(aportBean.plazoOriginal);
						$('#estatus').val(aportBean.estatus);

						if(aportBean.nuevaTasa > 0){
							$('#nuevaTasa').val(aportBean.nuevaTasa);
						}else{
							$('#nuevaTasa').val(aportBean.tasaFija);
						}
						if(aportBean.montosAnclados > 0){
							$('#montConjuntoF').val(aportBean.montosAnclados);
						}
						else{
							$('#montConjuntoF').val(aportBean.monto);
						}


						$('#valorGatOri').val(aportBean.valorGat);
						$('#valorGatRealOri').val(aportBean.valorGatReal);

						$('#interesGenInOri').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
						$('#interesRetOri').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
						$('#interesRecInOri').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
						$('#nuevoInteresGen').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
						$('#nuevoInteresRec').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
						$('#montConjuntoF').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
						$('#nuevaTasa').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 4
						});

						borra();
						habilita();

						seleccionaCalculoMadre(aportBean.calculoInteres);
						validaTipoAportacion(aportBean.tipoAportacionID);
						consultaDesTasaBaseID(aportBean.tasaBase);
						consultaCliente(aportBean.clienteID);
						consultaMontosAnclados($('#aportacionOriID').asNumber());
						consultaCtaAho();
						if(aportBean.estatus == catStatusAportaciones.alta) {
							mensajeSis("La Aportación no ha sido autorizada.");
							inicializaForma('formaGenerica', 'aportacionOriID');
							deshabilitaBoton('agrega', 'submit');
							$('#aportacionOriID').focus();
							$('#aportacionOriID').select();
						} else if(aportBean.estatus == catStatusAportaciones.cancelada) {
							mensajeSis("La Aportación ha sido cancelada y no puede ser Modificada");
							deshabilitaBoton('agrega', 'submit');
							$('#aportacionOriID').focus();
							$('#aportacionOriID').select();
						} else if(aportBean.estatus == catStatusAportaciones.pagada) {
							mensajeSis("La Aportación se encuentra Pagada (Abonada a Cuenta).");
							deshabilitaBoton('agrega', 'submit');
							$('#aportacionOriID').focus();
							$('#aportacionOriID').select();
						}

						$('#telefono').setMask('phone-us');
						$('#montOriginal').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
						$('#telefono').setMask('phone-us');

						if(estatus == catStatusAportaciones.cargada) {
							varError = 0;
							habilita();
							$('#montoAnclar').focus();
						}

						if(aportBean.aportacionMadreID > 0) {
							mensajeSis('No se pueden realizar Anclajes a una Aportación ya Anclada.');
							deshabilitaBoton('agrega', 'submit');
							$('#aportacionOriID').focus();
							deshabilitaControl('montoAnclar');
							deshabilitaControl('tasaBruta');
							deshabilitaControl('montoAnclar');
						}
						/*****************************************************************/
						/******************************************************************/


					} else {
						relaciones = '';
						mensajeSis("No existe la Aportación Seleccionada.");
						habilita();
						inicializarForm();
						$('#aportacionOriID').focus();
						$('#aportacionOriID').val('');
				}
				});
			}
		}
		else {
				relaciones = '';
				mensajeSis("No existe la Aportación Seleccionada.");
				habilita();
				inicializarForm();
				$('#aportacionOriID').focus();
				$('#aportacionOriID').val('');
			}
	}

	function consultaMontosAnclados(numAportacion) {
		var AportaBean = {
			'aportacionID': numAportacion
		};

		aportacionesServicio.consulta(7, AportaBean, function(montosAnclados) {
			if(montosAnclados != null) {
				$('#montosAnclados').val(montosAnclados.montosAnclados);
				var totalOri = $('#montOriginal').asNumber();
				var montoAncl = $('#montosAnclados').asNumber();
				var totalConjunto = totalOri + montoAncl;
				$('#montConjuntoF').val(totalConjunto);
				$('#montoTotal').val('');
				$('#interesesAnclados').val(montosAnclados.interesesAnclados);
				$('#montosAnclados').formatCurrency({
					positiveFormat: '%n',
					roundToDecimalPlace: 2
				});
				$('#montosAnclados').formatCurrency({
					positiveFormat: '%n',
					roundToDecimalPlace: 2
				});
				$('#montConjuntoF').formatCurrency({
					positiveFormat: '%n',
					roundToDecimalPlace: 2
				});
				$('#interesesAnclados').formatCurrency({
					positiveFormat: '%n',
					roundToDecimalPlace: 2
				});
			} else {
				$('#montosAnclados').val(0);
				$('#interesesAnclados').val(0);
			}
		});
	}

	function seleccionaCalculoMadre(calculoInteresMa) {
		switch(calculoInteresMa) {
			case('2'):
				$('#calculoInteresMa').val('TASA DE INICIO DE MES + PUNTOS');
				break;
			case('3'):
				$('#calculoInteresMa').val('TASA APERTURA + PUNTOS');
				break;
			case('4'):
				$('#calculoInteresMa').val('TASA PROMEDIO DEL MES + PUNTOS');
				break;
			case('5'):
				$('#calculoInteresMa').val('TASA DE INICIO DE MES + PUNTOS CON PISO Y TECHO');
				break;
			case('6'):
				$('#calculoInteresMa').val('TASA APERTURA + PUNTOS CON PISO Y TECHO');
				break;
			case('7'):
				$('#calculoInteresMa').val('TASA PROMEDIO DEL MES + PUNTOS CON PISO Y TECHO');
				break;
		}
	}

	function consultaDesTasaBaseID(tasaBaseID) {
		var TasaBaseBeanCon = {
			'tasaBaseID': tasaBaseID
		};

		tasasBaseServicio.consulta(1, TasaBaseBeanCon, function(tasasBaseBean) {
			if(tasasBaseBean != null) {
				$('#tasaBaseOr').val(tasasBaseBean.nombre);
			} else {
				if($('#tasaFV').val() == 'V') {
					mensajeSis("No Existe Tasa Base.");
				} else {
					$('#tasaBaseOr').val('');
				}
			}
		});
	}

	function consultaValorTasaBase() {
		var tasasAportacionesBean = {
			'tipoAportacionID': $('#tipoAportacionID').val(),
			'plazo': $('#plazo').val(),
			'monto': $('#monto').asNumber(),
			'provCompetencia': provCompetencia,
			'calificacion': calificacion,
			'relaciones': relaciones,
			'sucursalID': parametroBean.sucursal
		};

		tasasAportacionesServicio.consulta(2, tasasAportacionesBean, function(porcentaje) {
			$('#valorTasaBaseID').val(porcentaje.tasaAnualizada);
		});
	}

	// funcion que consuta el estatus del cliente
	function consultaEstatusCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var tipConForanea = 1;
		setTimeout("$('#cajaLista').hide();", 200);

		if(numCliente != '' && !isNaN(numCliente)) {
			clienteServicio.consulta(tipConForanea, numCliente, function(cliente) {
				if(cliente != null) {
					if($('#aportAnclajeID').val() == '' || $('#aportAnclajeID').val() == '0') {
						if(cliente.estatus == "I") {
							deshabilitaBoton('agrega', 'submit');
							mensajeSis("El " + $('#socioCliente').val() + " se encuentra Inactivo.");
							$('#clienteID').focus();
							$('#telefono').val('');
							$('#direccion').val('');
							$('#nombreCompleto').val('');
							$('#clienteID').val('');
							$('#tasaISR').val('');
						} else {}
					} else {
						if(cliente.estatus == "I") {
							deshabilitaBoton('agrega', 'submit');
							mensajeSis("El " + $('#socioCliente').val() + " se encuentra Inactivo.");
							$('#aportAnclajeID').focus();
						}
					}
				} else {
					mensajeSis("No Existe el " + $('#socioCliente').val() + ".");
					$('#clienteID').val('');
					$('#nombreCliente').val('');
				}
			});
		}
	}



	// función para consultar si el cliente ya tiene huella digital registrada
	function consultaHuellaCliente() {
		var numCliente = $('#clienteID').val();
		if(numCliente != '' && !isNaN(numCliente)) {
			var clienteIDBean = {
				'personaID': $('#clienteID').val()
			};
			huellaDigitalServicio.consulta(1, clienteIDBean, function(cliente) {
				if(cliente == null) {
					var huella = parametroBean.funcionHuella;
					if(huella == "S" && huellaProductos == "S") {
						mensajeSis("El Cliente no tiene Huella Registrada.\nFavor de Verificar.");
						$('#clienteID').focus();
						deshabilitaBoton('agrega', 'submit');
					} else {
						if($("#inversionOriID").val() == 0) {
							habilitaBoton('agrega', 'submit');
						}
					}
				} else {
					if($("#inversionOriID").val() == 0) {
						habilitaBoton('agrega', 'submit');
					}
				}
			});
		}
	}



	function consultaCtaAho() {
		var numCta = $('#cuentaAhoID').val();
		var CuentaAhoBeanCon = {
			'cuentaAhoID': numCta,
			'clienteID': $('#clienteID').val()
		};
		if(numCta != '' && !isNaN(numCta)) {
			cuentasAhoServicio.consultaCuentasAho(catTipoConsultaCuentas.conSaldo, CuentaAhoBeanCon, function(cuenta) {
				if(cuenta != null) {
					if(cuenta.saldoDispon != null) {
						$('#cuentaAhoID').val(cuenta.cuentaAhoID);
						$('#totalCuenta').val(cuenta.saldoDispon);
						$('#tipoMoneda').html(cuenta.descripcionMoneda);
						$('#tipoMonedaInv').html(cuenta.descripcionMoneda);
						$('#monedaID').val(cuenta.monedaID);
						if(cuenta.estatus == catStatusCuenta.activa) {
							calculaCondicionesAportacion();
						} else {
							mensajeSis("La Cuenta no esta Activa.");
							$('#cuentaAhoID').focus();
							$('#cuentaAhoID').val('');
						}
					} else {
						mensajeSis("La Cuenta no Existe.");
						$('#totalCuenta').val("");
						$('#cuentaAhoID').focus();
						$('#cuentaAhoID').select();
					}
				} else {
					mensajeSis("La Cuenta no Existe.");
					$('#totalCuenta').val("");
					$('#cuentaAhoID').focus();
					$('#cuentaAhoID').val('');
				}
			});
		}
	}

	function consultaCliente(numCliente) {
		var rfc = ' ';
		var NOPagaISR = 'N';

		if(numCliente != '0') {
			setTimeout("$('#cajaLista').hide();", 200);
			if(numCliente != '' && !isNaN(numCliente)) {
				clienteServicio.consulta(catTipoConsultaCliente.paraAportaciones, numCliente, rfc, function(cliente) {
					if(cliente != null) {
						calificacion = cliente.calificaCredito;
						provCompetencia = cliente.provCompetencia;
						$('#clienteID').val(cliente.numero);
						$('#nombreCompleto').val(cliente.nombreCompleto);
						if(cliente.esMenorEdad == "N") {
							$('#telefono').val(cliente.telefonoCasa);
							$('#telefono').setMask('phone-us');
							if(cliente.pagaISR == NOPagaISR) {
								$('#tasaISR').val(0);
							} else {

								$('#tasaISR').val(parametroBean.tasaISR);
								$('#tasaISR').formatCurrency({
									positiveFormat: '%n',
									roundToDecimalPlace: 4
								});
							}
							consultaDireccion(cliente.numero);
							consultaHuellaCliente();
						} else {
							mensajeSis("El " + $('#socioCliente').val() + " es Menor de Edad.");
							$('#clienteID').focus();
							$('#clienteID').val('');
							$('#nombreCompleto').val('');
							$('#direccion').val('');
							$('#telefono').val('');
						}
					} else {
						calificacion = ''
						provCompetencia = '';
						mensajeSis("El " + $('#socioCliente').val() + " No Existe.");
						$('#clienteID').focus();
						$('#clienteID').val('');
						$('#nombreCompleto').val('');
						$('#direccion').val('');
						$('#telefono').val('');
					}
				});
			}
		}
	}



	function validaTipoAportacion(tipAportacion) {
		var TipoAportaBean = {
			'tipoAportacionID': $('#tipoAportacionID').asNumber()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(tipAportacion != '' && !isNaN(tipAportacion)) {
			if(tipAportacion != 0) {

				tiposAportacionesServicio.consulta(catTipoConsultaTipoAportacion.principal, TipoAportaBean, function(tipoAportacion) {

					if(tipoAportacion != null) {
						$('#tasaFV').val(tipoAportacion.tasaFV);
						$('#descripcion').val(tipoAportacion.descripcion);
						$('#tipoAportacionID').val(tipoAportacion.tipoAportacionID);
						$('#diaInhabil').val(tipoAportacion.diaInhabil);
						validaSabadoDomingo();

						if(tipoAportacion.tasaFV == 'F') {
							ocultaTasaVariable();
						}
						if(tipoAportacion.tasaFV == 'V') {
							muestraTasaVariable();
						}

						anclaje = tipoAportacion.anclaje;
						tasaMejorada = tipoAportacion.tasaMejorada;
						espTasa = tipoAportacion.especificaTasa;
						minimoAnclaje = tipoAportacion.minimoAnclaje;

						if(tipoAportacion.anclaje == 'N') {
							mensajeSis("El Tipo de Aportación No permite Anclaje.");
							inicializaForma('formaGenerica', 'inverAnclajeID');
							borra();
							deshabilitaBoton('agrega', 'submit');
							$('#inverAnclajeID').focus();

						}

						if(tipoAportacion.anclaje == 'N') {
							mensajeSis("El Tipo de Aportación No permite Anclaje.");
							inicializaValores();
							deshabilitaBoton('agrega', 'submit');
							$('#aportAnclajeID').val();
						}
					} else {
						$('#descripcion').val('');
						$('#diaInhabil').val('');
						mensajeSis("El tipo de Aportación no Existe.");
						$('#tipoAportacionID').focus();
						$('#tipoAportacionID').val('');
					}
				});
			}
		}
	}

    /* Valida el tipo de Aportaciones cuando se encuentre parametrizado dia inhábil: Sabado y Domingo
     * para que no se realice el anclaje de Aportaciones el día Sábado */
	function validaSabadoDomingo(){
		var fecha = parametroBean.fechaSucursal;
		var diaInhabil = $('#diaInhabil').val();
		var aportacion = $('#aportacionOriID').val();
		var aportacionAnclaje = $('#aportAnclajeID').val();
		var estatus = $('#estatus').val();
		var sabDom	='SD';
		var domingo	='D';
		var autorizado = 'N';
		var noEsFechaHabil = 'N';
		var tipoAportacionID = $('#tipoAportacionID').val();

		var diaInhabilBean = {
				'fecha': fecha,
				'numeroDias': 0,
				'salidaPantalla':'S',
		};
		if (diaInhabil == sabDom && aportacion > 0 && aportacionAnclaje == 0 && estatus == autorizado){
			var sabado = 'Sábado y Domingo';
			diaFestivoServicio.calculaDiaFestivo(3,diaInhabilBean,function(data){
				if(data!=null){
					$('#esDiaHabil').val(data.esFechaHabil);
					if($('#esDiaHabil').val() == noEsFechaHabil){
						mensajeSis("El Tipo de Aportación " +tipoAportacionID +  " Tiene Parametrizado Día Inhábil: " + sabado +
								" por tal Motivo No se Puede Anclar la Aportación.");
						$('#aportacionOriID').focus();
						$('#aportacionOriID').select();
						$('#diaInhabil').val('');
						$('#esDiaHabil').val('');
						deshabilitaBoton('agrega', 'submit');
					}
				}
			});
		}
	}


	function CalculaValorTasa(idControl) {
		var jqControl = eval("'#" + idControl + "'");
		var tipoCon = 2;
		var cantidad = creaBeanTasaAportacion();
		if($('#montoAnclar').asNumber() <= $('#totalCuenta').asNumber()) {

			if($('#plazo').val() != '' && $('#plazo').val() != 0 && $('#monto').val() != '' && $('#monto').val() != 0) {
				var variables = creaBeanTasaAportacion();
				tasasAportacionesServicio.consulta(tipoCon, variables, function(porcentaje) {
					if(porcentaje.tasaAnualizada != 0 || porcentaje.tasaBase > 0) {
						if($('#tasaFV').val() == 'F' && porcentaje.tasaAnualizada > 0) {
							if(tasaMejorada == 'S') {
								$('#tasaBruta').val(porcentaje.tasaAnualizada);
								$('#valorGat').val(porcentaje.valorGat);
								$('#valorGatReal').val(porcentaje.valorGatReal);
								$('#nuevaTasa').val(porcentaje.tasaAnualizada);
								ajusteAnclaje();
							} else {
								$('#tasaBruta').val($('#tasaAportacionOr').val());
								$('#valorGat').val($('#valorGatOri').val());
								$('#valorGatReal').val($('#valorGatRealOri').val());
								$('#nuevaTasa').val($('#tasaAportacionOr').val());
								ajusteAnclaje();
							}
							$('#tasaBruta').formatCurrency({
								positiveFormat: '%n',
								roundToDecimalPlace: 4
							});

							$('#nuevaTasa').formatCurrency({
								positiveFormat: '%n',
								roundToDecimalPlace: 4
							});

							$('#calculoInteres').val('1');
							$('#tasaBaseID').val('0');
							$('#sobreTasa').val('0.0');
							$('#pisoTasa').val('0.0');
							$('#techoTasa').val('0.0');
							$('#valorTasaBaseID').val('0.0');
						}
						if($('#tasaFV').val() == 'V' && porcentaje.tasaBase > 0) {

							if(tasaMejorada == 'S') {
								$('#tasaBruta').val(porcentaje.tasaAnualizada);
								$('#calculoInteres').val(porcentaje.calculoInteres);
								$('#tasaBaseID').val(porcentaje.tasaBase);
								$('#sobreTasa').val(porcentaje.sobreTasa);
								$('#pisoTasa').val(porcentaje.pisoTasa);
								$('#techoTasa').val(porcentaje.techoTasa);
								$('#valorTasaBaseID').val(porcentaje.tasaAnualizada);
								$('#valorGat').val(porcentaje.valorGat);
								$('#valorGatReal').val(porcentaje.valorGatReal);
								$('#nuevaTasa').val(porcentaje.tasaAnualizada);

								seleccionaNuevoCalculo(porcentaje.calculoInteres);
								validaTasaBase(porcentaje.tasaBaseID);

								$('#tasaBruta').formatCurrency({
									positiveFormat: '%n',
									roundToDecimalPlace: 4
								});

								$('#nuevaTasa').formatCurrency({
									positiveFormat: '%n',
									roundToDecimalPlace: 4
								});
								ajusteAnclaje();
							} else {
								$('#tasaBruta').val($('#tasaInvOr').val());
								$('#calculoInteres').val($('#calculoInteOri').val());
								$('#tasaBaseID').val($('#tasaBaseIDOri').val());
								$('#sobreTasa').val($('#sobreTasaOr').val());
								$('#pisoTasa').val($('#pisoTasaOr').val());
								$('#techoTasa').val($('#techoTasaOr').val());
								$('#valorGat').val($('#valorGatOri').val());
								$('#valorGatReal').val($('#valorGatRealOri').val());
								$('#valorTasaBaseID').val($('#tasaInvOr').val());
								$('#nuevaTasa').val($('#tasaInvOr').val());

								seleccionaNuevoCalculo($('#calculoInteOri').val());
								validaTasaBase($('#tasaBaseIDOri').val());

								$('#tasaBruta').formatCurrency({
									positiveFormat: '%n',
									roundToDecimalPlace: 4
								});

								$('#nuevaTasa').formatCurrency({
									positiveFormat: '%n',
									roundToDecimalPlace: 4
								});

								ajusteAnclaje();
							}
						}

						$('#valorGat').val(porcentaje.valorGat);
						$('#valorGatReal').val(porcentaje.valorGatReal);

						if(!isNaN($('#aportAnclajeID').val())) {
							if($('#aportAnclajeID').asNumber() == 0) {
								habilitaBoton('agrega', 'submit');
								habilita();
							}
						}
						calculaCondicionesAportacion();
					} else {
						mensajeSis("No existe una Tasa Anualizada.");
						$('#montoAnclar').focus();
						$('#montoAnclar').val("");
						$('#monto').val("");
						$('#plazo').val("");
					}
				});
			}
		} else {
			mensajeSis("El monto Aportación es superior al Saldo en la Cuenta.");
			$('#montoAnclar').focus();
			$('#montoAnclar').select();
		}
	}

	function ajusteAnclaje() {
		var aportacionBean = {
			'aportacionID': $('#aportacionOriID').val(),
			'tasa': $('#tasaBruta').val(),
			'tasaBaseID': $('#tasaBaseID').val(),
			'sobreTasa': $('#sobreTasa').val(),
			'pisoTasa': $('#pisoTasa').val(),
			'techoTasa': $('#techoTasa').val(),
			'calculoInteres': $('#calculoInteres').val()
		};

		aportacionesServicio.consulta(8, aportacionBean, {
			async: false,
			callback: function(ajuste) {
				if(ajuste != null) {
					$('#nuevoInteresGen').val(ajuste.interesGenerado);
					$('#nuevoInteresRec').val(ajuste.interesRecibir);
					$('#interesesAnclados').val(ajuste.interesesAnclados);
					$('#nuevoInteresGen').formatCurrency({
						positiveFormat: '%n',
						roundToDecimalPlace: 2
					});
					$('#nuevoInteresRec').formatCurrency({
						positiveFormat: '%n',
						roundToDecimalPlace: 2
					});
				} else {
					mensajeSis('No se pudo realizar el Ajuste a la Aportación Madre.');
				}
			}
		});
	}


	function seleccionaNuevoCalculo(calculoInteres) {
		switch(calculoInteres) {
			case('2'):
				$('#desCalculoInteres').val('TASA DE INICIO DE MES + PUNTOS');
				break;
			case('3'):
				$('#desCalculoInteres').val('TASA APERTURA + PUNTOS');
				break;
			case('4'):
				$('#desCalculoInteres').val('TASA PROMEDIO DEL MES + PUNTOS');
				break;
			case('5'):
				$('#desCalculoInteres').val('TASA DE INICIO DE MES + PUNTOS CON PISO Y TECHO');
				break;
			case('6'):
				$('#desCalculoInteres').val('TASA APERTURA + PUNTOS CON PISO Y TECHO');
				break;
			case('7'):
				$('#desCalculoInteres').val('TASA PROMEDIO DEL MES + PUNTOS CON PISO Y TECHO');
				break;

		}
	}


	function validaTasaBase(tasaBase) {


		var TasaBaseBeanCon = {
			'tasaBaseID': tasaBase
		};

		tasasBaseServicio.consulta(1, TasaBaseBeanCon, function(tasasBaseBean) {
			if(tasasBaseBean != null) {
				$('#destasaBaseID').val(tasasBaseBean.nombre);
			} else {
				mensajeSis("No Existe Tasa Base.");
			}
		});

	}



	function calculaNodeDias() {
		if($('#fechaInicio').val() != '') {
			var fechaVenci = $('#fechaVencimiento').val();
			var plazoVal = $('#plazo').val();


			var opeFechaBean = {
				'primerFecha': parametroBean.fechaSucursal,
				'segundaFecha': fechaVenci
			};

			operacionesFechasServicio.realizaOperacion(opeFechaBean, catOperacFechas.restaFechas,
				function(data) {
					if(data != null) {
						$('#plazo').val(data.numeroDias);
						$('#plazoOriginal').val(data.numeroDias);

						fechaHabil($('#fechaVencimiento').val(), 'montoAnclar');
					} else {
						mensajeSis("Ha ocurrido un error Interno al Consultar Fechas.");
					}
				});

		} else {
			mensajeSis("Error al Consultar la Fecha de la Sucursal.");
			$('#aportAnclajeID').focus();
		}

	}


	function creaBeanTasaAportacion() {
		var tasasAportaBean = {
			'tipoAportacionID': $('#tipoAportacionID').val(),
			'plazo': $('#plazoOriginalMadre').val(),
			'monto': $('#montoTotal').asNumber(),
			'provCompetencia': provCompetencia,
			'calificacion': calificacion,
			'relaciones': relaciones,
			'sucursalID': parametroBean.sucursal

		};
		return tasasAportaBean;
	}




	function calculaCondicionesAportacion() {

		if($('#montoAnclar').val()!=""){
		var interGenerado;
		var interRetener;
		var interRecibir;
		var total;
		var tasa;
		if($('#tasaFV').val() == 'V') {
			tasa = $('#valorTasaBaseID').asNumber();
		}
		if($('#tasaFV').val() == 'F') {
			tasa = $('#tasaBruta').asNumber();
		}

		if($('#tasaISR').asNumber() <= tasa) {
			$('#tasaNeta').val(tasa - $('#tasaISR').asNumber());

			$('#tasaISR').formatCurrency({
				positiveFormat: '%n',
				roundToDecimalPlace: 4
			});
		} else {
			$('#tasaNeta').val(0.00);
		}

		$('#tasaNeta').formatCurrency({
			positiveFormat: '%n',
			roundToDecimalPlace: 4
		});
		$('#tasaISR').formatCurrency({
			positiveFormat: '%n',
			roundToDecimalPlace: 4
		});
		$('#tasaBruta').formatCurrency({
			positiveFormat: '%n',
			roundToDecimalPlace: 4
		});


		interGenerado = (($('#monto').asNumber() * tasa * $('#plazo').asNumber()) / (diasBase * 100));
		$('#interesGenerado').val(interGenerado);
		$('#interesGenerado').formatCurrency({
			positiveFormat: '%n',
			roundToDecimalPlace: 2
		});


		diasBase = parametroBean.diasBaseInversion;
		salarioMinimo = parametroBean.salMinDF;
		var salarioMinimoGralAnu = parametroBean.salMinDF * 5 * parametroBean.diasBaseInversion; // Salario minimo General Anualizado
		// SI EL MONTO DE INVERSION es MAYOR O IGUAL A 5 Salario minimo General Anualizado Distrito Federal segun DF,(SMAGDF),
		//entonces se aplica el calculo de ISR PERO SOBRE EL EXAportaciónNTE DE CAPITAL NO SOBRE EL CAPITAL ORIGINAL,
		// si no es CERO

		var tipoPersona = '';
		//AL PAGAR INTERESES A UNA PERSONA MORAL SIEMPRE SE LE DEBE RETENER ISR SOBRE EL MONTO TOTAL SIN CONTEMPLAR EXENCIÓN ALGUNA.
		clienteServicio.consulta(1, $('#clienteID').val(), {async: false, callback:function(cliente) {
			if(cliente != null){
				tipoPersona = cliente.tipoPersona;
			}
		}});

		if($('#monto').asNumber() > salarioMinimoGralAnu || tipoPersona == 'M') {
			if(tipoPersona == 'M'){
				interRetener = (($('#monto').asNumber() * $('#tasaISR').val() * $('#plazo').val()) / (diasBase * 100));
			}else{
				interRetener = ((($('#monto').asNumber() - salarioMinimoGralAnu) * $('#tasaISR').val() * $('#plazo').val()) / (diasBase * 100));
			}
		} else {
			interRetener = 0.00;
		}

		$('#interesRetener').val(interRetener);
		$('#interesRetener').formatCurrency({
			positiveFormat: '%n',
			roundToDecimalPlace: 2
		});

		interRecibir = interGenerado - interRetener;
		$('#interesRecibir').val(interRecibir);
		$('#interesRecibir').formatCurrency({
			positiveFormat: '%n',
			roundToDecimalPlace: 2
		});

		total = $('#montoTotal').asNumber() + interRecibir + $('#interesesAnclados').asNumber();

		$('#granTotal').val(total);
		$('#granTotal').formatCurrency({
			positiveFormat: '%n',
			roundToDecimalPlace: 2
		});
		}
	}




	function consultaDireccion(numCliente) {
		var conOficial = 3;
		var direccionCliente = {
			'clienteID': numCliente
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCliente != '' && !isNaN(numCliente)) {
			direccionesClienteServicio.consulta(conOficial, direccionCliente, function(direccion) {
				if(direccion != null) {
					$('#direccion').val(direccion.direccionCompleta);
					consultaEstatusCliente('clienteID');

				} else {
					$('#direccion').val('');
				}
			});
		}
	}


	//Consulta para ver si se requiere que el cliente tenga registrada su huella Digital
	function validaEmpresaID() {
		var numEmpresaID = 1;
		var tipoCon = 1;
		var ParametrosSisBean = {
			'empresaID': numEmpresaID
		};
		parametrosSisServicio.consulta(tipoCon, ParametrosSisBean, function(parametrosSisBean) {
			if(parametrosSisBean != null) {
				if(parametrosSisBean.reqhuellaProductos != null) {
					huellaProductos = parametrosSisBean.reqhuellaProductos;
				} else {
					huellaProductos = "N";
				}
			}
		});
	}

});


function muestraTasaVariable() {
	$('#lblTasaBase').show();
	$('#tdTasaBase').show();
	$('#trVariable').show();
	$('#trTasaVariable1').show();
	$('#lblCalculoInteres').show();
	$('#tdcalculoInteres').show();
	$('#lblTasaBaseID').show();
	$('#tdDesTasaBaseID').show();
	$('#trVariable2').show();
}

function ocultaTasaVariable() {
	$('#lblTasaBase').hide();
	$('#tdTasaBase').hide();
	$('#trVariable').hide();
	$('#trTasaVariable1').hide();
	$('#lblCalculoInteres').hide();
	$('#tdcalculoInteres').hide();
	$('#lblTasaBaseID').hide();
	$('#tdDesTasaBaseID').hide();
	$('#trVariable2').hide();
}


function borra() {
	$('#plazo').val("");
	$('#montoAnclar').val("");
	$('#tasaBruta').val("");
	$('#interesRetener').val("");
	$('#tasaNeta').val("");
	$('#interesRecibir').val("");
	$('#interesGenerado').val("");
	$('#interesRetener').val("");
	$('#tasaISR').val("");
	$('#desCalculoInteres').val('');
	$('#destasaBaseID').val('');
}


function deshabilita() {
	deshabilitaControl('aportacionOriID');
	deshabilitaControl('montoAnclar');
	deshabilitaControl('tasaBruta');
	deshabilitaControl('montoAnclar');
}


function habilita() {
	habilitaControl('aportacionOriID');
	habilitaControl('montoAnclar');
}


function inicializaValores() {
	$('#plazo').val("");
	$('#montoAnclar').val("");
	$('#tasaBruta').val("");
	$('#interesRetener').val("");
	$('#tasaNeta').val("");
	$('#interesRecibir').val("");
	$('#interesGenerado').val("");
	$('#interesRetener').val("");
	$('#tasaISR').val("");
	$('#cuentaAhoID').val("");
	$('#totalCuenta').val("");
	$('#direccion').val("");
	$('#interesGenerado').val("");
	$('#interesRetener').val("");
	$('#interesRecibir').val("");
	$('#direccion').val("");
	inicializaForma('formaGenerica', 'aportAnclajeID');

}

function exito() {
	deshabilitaBoton('agrega', 'submit');
	esTab = true;
	borraCondiciones();
	$('#aportacionOriID').val('');
	var aportAnclajeID=$('#aportAnclajeID').val();
	inicializarForm();
	$('#aportAnclajeID').val(aportAnclajeID);
}

function error() {
	agregaFormatoControles('formaGenerica');
}

function consultaSoloCuentaAho() {
	var numCta = $('#cuentaAhoID').val();
	var CuentaAhoBeanCon = {
		'cuentaAhoID': numCta,
		'clienteID': $('#clienteID').val()
	};
	if(numCta != '' && !isNaN(numCta)) {
		cuentasAhoServicio.consultaCuentasAho(5, CuentaAhoBeanCon, function(cuenta) {
			if(cuenta != null) {
				if(cuenta.saldoDispon != null) {
					$('#cuentaAhoID').val(cuenta.cuentaAhoID);
					$('#totalCuenta').val(cuenta.saldoDispon);
					$('#tipoMoneda').html(cuenta.descripcionMoneda);
					$('#tipoMonedaInv').html(cuenta.descripcionMoneda);
					$('#monedaID').val(cuenta.monedaID);
				} else {
					mensajeSis("La Cuenta no Existe.");
					$('#totalCuenta').val("");
					$('#cuentaAhoID').focus();
					$('#cuentaAhoID').select();
				}
			} else {
				mensajeSis("La Cuenta no Existe.");
				$('#totalCuenta').val("");
				$('#cuentaAhoID').focus();
				$('#cuentaAhoID').val('');
			}
		});
	}

}
function borraCondiciones(){
	$('#monto').val("");
	$('#plazoOriginal').val("");
	$('#plazo').val("");
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#tasaBruta').val("");
	$('#tasaNeta').val("");
	$('#valorGat').val("");
	$('#interesGenerado').val("");
	$('#interesRetener').val("");
	$('#interesRecibir').val("");
	$('#valorGatReal').val("");
	$('#montoTotal').val("");
	$('#granTotal').val("");
}

function inicializarForm(){
	habilitaBoton('agrega', 'submit');
	inicializaForma('formaGenerica', 'aportacionOriID');
	habilita();
	$('#aportacionOriID').focus();
	$('#aportAnclajeID').val('0');
	$('#plazoOriginal').val('');
	$('#interesRetener').val('');
	$('#interesRecibir').val('');
	$('#destasaBaseID').val('');
	$('#montOriginal').val('');
	$('#plazoInvOr').val('');
	$('#tasaAportacionOr').val('');
	$('#interesGenInOri').val('');
	$('#interesRetOri').val('');
	$('#interesRecInOri').val('');
	$('#montConjuntoF').val('');
	$('#interesGenInOri').val('');
	$('#nuevaTasa').val('');
	$('#nuevoInteresGen').val('');
	$('#nuevoInteresRec').val('');

}
