//funcion para obtener los valores de la primera solicitud si ya existe una
//sólo se ocupa para solicitudes grupales y cuando ya es la segunda que se da de alta.
var nSolicitudSelec = 0;
var solicitudBeanCon = null;
var validacion_maxminExitosa = false;
var Comercial = 'C';
var Consumo = 'O';
var financiado = "FINANCIAMIENTO";
var TasaFijaID = 1; // ID de la formula para tasa fija (FORMTIPOCALINT)
var TasaBasePisoTecho = 3; // ID de la formula para tasa base con piso y techo (FORMTIPOCALINT)
var hayTasaBase = false; // Indica la existencia de una tasa base
var VarTasaFijaoBase = 'Tasa Fija Anualizada'; // Texto que indica si se trata de tasa fija o tasa base actual (alert)
var deduccion = "DEDUCCION";
var anticipado = "ANTICIPADO";
var programado = "PROGRAMADO";
var costoSeguroVidaCredito = 0;// costo del seguro de vida
var numeroDias = 0; // numero de dias entre fechas
var montoGaranLiq = 0;
var requiereSeg = ""; // indica si requiere o no seguro de vida
var calculaTasa = "";//declaracion de variables que se ocupan para no recalcular el monto a menos que este haya cambiado
var montoSolicitudBase = 0;// monto de la solciitud original (sin accesorios * Com. apertura, Seguro de vida)
var plazoBase = 0;//Plazo del credito seleccionado en un inicio por el usuario
var montoComApeBase = 0; // monto de la comision por apertura
var montoIvaComApeBase = 0; // monto del iva de la comision por apertura
var formaCobroComApe = ""; // forma de cobro de la comision por apertura (adelantada, financiamiento, deduccion)
var montoComIvaSol = 0; // monto que incluye el iva, la comision por apertura seg vida
//variables que se ocupan como base para saber si los datos seleccionados han cambiado y se ejecuten ciertas consultas
var clienteIDBase = 0; // numero de cliente que escoge en un inicio el usuario
var productoIDBase = 0; // numero de producto que escoge en un inicio el usuario
var prospectoIDBase = 0; // numero de prospecto que escoge en un inicio el usuario cuando es pantalla individual)
var grupoIDBase = 0; // numero de grupo que en un inicio se escoge (se usa
//cuando es pantalla individual)
var solicitudIDBase = 0; // numero de solicitud que se indica
//variables que se utilizan para validar el monto minimo o maximo de la solicitud toman sus valores al consultar el producto de credito
var montoMaxSolicitud = 0.0; /*indica el monto maximo que puede escoger en la solicitud*/
var montoMinSolicitud = 0.0; /*indica el monto minimo que puede escoger en la solicitud*/
//variables que sirven como base para recalculor el monto del seguro de vida
var fechaVencimientoInicial = "";

//declaracion de variables que sirven como banderas.
var continuar = 0;
var productoCreditoGuardado = 0; // Número del Producto de Credito (Se usa
//solo para la consulta de una Solicitud
//individual)
var procede = 1;
var procedeSubmit = 1;

var parametroBean = consultaParametrosSession();
var usuario = parametroBean.numeroUsuario;
var fechaSucursal = parametroBean.fechaSucursal;
var diaSucursal = parametroBean.fechaSucursal.substring(8, 10);
var diaPagInter = '';
var pagoFinAni = "";
var pagoFinAniInt = "";
var diaHabilSig = "";
var ajustaFecAmo = "";
var ajusFecExiVen = "";
var tipoLista = 0;
var NumCuotas = 0; // se utiliza para saber cuando se agrega o quita una cuota
var NumCuotasInt = 0; // se utiliza para saber cuando se agrega o quita una
var funcionHuella = parametroBean.funcionHuella;
var calificacionCliente = "0.00"; // calificacion numerica del cliente
var cambiarPromotor = parametroBean.cambiaPromotor;
var PanSolicitudCredito = 'S';
var inicioAfuturo = ''; // indica si el producto de credito permite el desembolso anticipado del credito
var diasMaximo = 0; // Indica el maximo numero dias a los que se puede desembolsar un credito antes de su fecha de inicio
var solicitudEstatus;
var estatusSimulacion = false; // indica si ya se realizó la simulación
var solicitudPromotor;
var auxDiaPagoCapital; // variable auxiliar para indicar el dia de pago de capital
var auxDiaPagoInteres; // variable auxiliar para indicar el dia de pago de interes
var modalidad;
var tipoPagoSeg = "";
var esquemaSeguro;
var prodCredito;
var factorRS;
var porcentajeDesc;
var montoPol;
var descuentoSeg;
var pagoSeg;
var dias;
var datosCompletos = false;
var valorTasaBase = 0; //Valor de la tasa base cuando el calculo de interes es de tipo 2,3,4.
var permiteSolicitudProspecto = 'S';
var tipoFactorMora = '';
var esNomina = 'N';
var numeroDias = 0;
var numTransaccionInicGrupo = 0;//Número de transaccion de credito grupal de tipo operacion formal;
var tipoOperacionGrupo = '';
var numeroHabitantes = 0;
var numeroHabitantesLocalidad = 0;
var financiamientoRural = 'N';
var grabaTransaccion = 0;
var mensajeValidacion = "";
var esConsolidadoAgro = "";
var deudorOriginalID = 0;
var montoOperacion = 0.00;
var banderaProyeccion = 0;
var banderaCliente = 0;
var montoOriginalSolicitud = 0.00;

var tipoOperacion = {
	'global': 'G',
	'noFormal': 'NF'
};
var expedienteBean = {
	'clienteID' : 0,
	'tiempo' : 0,
	'fechaExpediente' : '1900-01-01',
};

var listaPersBloqBean = {
	'estaBloqueado' : 'N',
	'coincidencia' : 0
};
var esCliente = 'CTE';
var esUsuario = 'USS';
var productoCredito = 0;
var var_NoEsNuevaSol = true;

//Definicion de Constantes y Enums
var catTipoConsultaSolicitud = {
	'agropecuario' : 9,
	'foranea' : 2
};

var catTipoTranSolicitud = {
	'altaCreditoAgro' : 9,
	'modifica' : 10,
	'actualiza' : 3
};

var catTipoActSolicitud = {
	'liberar' : 5
};

var catTipoConsultaSeguroVida = {
	'principal' : 1,
	'foranea' : 2
};
var enum_productos_list = {
	'agropecuario' : 14
};

var enum_productos_con = {
	'agropecuario' : 8
};

var enum_solicitud_lis = {
	'agropecuarios' : 21
};

var Enum_TipoFondeo = {
	'RecursosPropios' : 'P',
	'Financiamiento' : 'F'
};

$('#pantalla').val(PanSolicitudCredito);
var esTab = false;
seccionCalendarioLibreAgro();

var cat_ForCobComisiones = {
	'Disposicion' : 'D',
	'CadaCuota' : 'C',
	'TotalPriDisposicion' : 'T'
};

var cat_ForPagComisiones = {
	'Deduccion' : 'D',
	'Financiado' : 'F'
};
var fechaVencimientoLinea = '1900-01-01';
var montoLineaCreditoAgro = 0.00;
var manejaComAdmon = "";
var manejaComGarantia = "";
var forCobComAdmon = "";
var forCobComGarantia = "";
var porcentajeComAdmon = 0.00;
var porcentajeComGarantia = 0.00;

$(document).ready(function() {
	// ------------ Metodos y Manejo de Eventos Solicitud  -----------------------------------------
	muestraSeccionSeguroCuota();
	consultaTipoGarantiaFira();
	agregaFormatoControles('formaGenerica');
	$('#sucursalID').val(parametroBean.sucursal);
	deshabilitaBoton('modificar', 'submit');
	deshabilitaBoton('agregar', 'submit');
	deshabilitaBoton('agregaConsolidacion', 'submit');
	validaEmpresaID(); //Se consulta parametro de huella por producto.
	consultaComboCalInteres(); //llena el combo para la formula del calculo de intereses
	mostrarLabelTasaFactorMora('');
	consultaSICParam();
	deshabilitaCampoLinea();
	limpiaCamposLinea();

	// si ya hay una solicitud en el grupo.
	if ($('#numSolicitud').asNumber() >= 0) { // numSolicitud
		// hace  referencia a  jsp  solicitudCreditoGrupalCatalogoVista.jsp

		var numSolicitud = $('#numSolicitud').val();

		nSolicitudSelec = numSolicitud;

		$('#solicitudCreditoID').val(numSolicitud);
		$('#solicitudCreditoID').focus().select();

		if ($('#puedeAgregarSolicitudes').val() == 'N') {// puedeAgregarSolicitudes
			// hace referencia  a  jsp  solicitudCreditoGrupalCatalogoVista.jsp
			deshabilitaControl('solicitudCreditoID');
		}

		// eventos para cliente

		$('#clienteID').bind('keyup', function(e) {
			lista('clienteID', '3', '14', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
		});

		$('#buscarMiSuc').click(function() {
			listaCte('clienteID', '3', '26', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
		});
		$('#buscarGeneral').click(function() {
			listaCte('clienteID', '3', '14', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
		});

		$('#deudorOriginalID').bind('keyup', function(e) {
			lista('deudorOriginalID', '3', '41', 'nombreCompleto', $('#deudorOriginalID').val(), 'listaCliente.htm');
		});

		$('#creditoID').bind('keyup', function(e) {

			var camposLista = new Array();
			var parametrosLista = new Array();

			camposLista[0] = "creditoID";
			camposLista[1] = "clienteID";

			parametrosLista[0] = $('#creditoID').val();
			parametrosLista[1] = $("#deudorOriginalID").val();
			listaCredito('creditoID', '3', '1', camposLista, parametrosLista, 'listaConsolidacionesAgro.htm');
		});



		esTab = true;
		validaSolicitudCredito('solicitudCreditoID');

		productoCredito = $('#prodCreditoID').val();
		$('#productoCreditoID').val(productoCredito);
		// si la lista esta vacia  puede puede modificar el  producto de credito para que se instancien al  grupo
		if (productoCredito != 0) {
			deshabilitaControl('productoCreditoID');
		}
		$('#liberar').hide();
		if ($('#grupo').val() != undefined) {
			funcionMuestraDivGrupo();
		} else {
			funcionOcultaDivGrupo();
		}


	} else {

		if( $('#solicitudCreditoID').val() == '0' || $('#solicitudCreditoID').val() == 0){
			inicializaValoresNuevaSolicitud();
		}
		iniciaPantallaSolicitudGrupal();
		deshabilitaBoton('agregar', 'submit');
		deshabilitaBoton('modificar', 'submit');
		deshabilitaBoton('liberar', 'submit');
		deshabilitaBoton('agregaConsolidacion', 'submit');
		$('#simular').hide();
		$('#trMontoSeguroVida').hide();
		$('#trBeneficiario').hide();
		$('#trParentesco').hide();
	}

	// Fin Metodos y Manejo de Eventos Solicitud Grupal
	$('select').css('background-color', '#FFFFFF');
	// -------------------------- Metodos y Manejo de Eventos -----------------------------------------

	$.validator.setDefaults({
		submitHandler : function(event) {
			if (validaTablaMinistraciones(true, 'graba', true, true)) {
				llenarDetalle();
				if (($("#tipoTransaccion").val() == 1 || $("#tipoTransaccion").val() == 2) && estatusSimulacion == false && $("#tipoPagoCapital").val() != 'L') {
					mensajeSis("Se Requiere Simular las Amortizaciones.");
				} else {
					procedeSubmit = validaCamposRequeridos();
					if($("#tipoFondeo2").is(':checked')){
						if(financiamientoRural == 'S'){
							evaluaFinanciamientoRural();
						}

					}
					else{
						grabaTransaccion = 0;
					}
					if (procedeSubmit == 0 && grabaTransaccion == 0) {
						procedeSubmit = validaUltimaCuotaCapSimulador();
						if (procedeSubmit == 0) {
							habilitaControl('tipoFondeo');
							habilitaControl('tipoFondeo2');
							grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'solicitudCreditoID', 'inicializarSolicitud', 'errorSolicitud');
						}
					}
				}
			}
		}
	});


	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});

	$('#agregar').click(function() {
		validarTransaccion();
		$('#tipoTransaccion').val(catTipoTranSolicitud.altaCreditoAgro);
		$('#tipoActualizacion').val('0');
	});

	$('#modificar').click(function() {
		validarTransaccion();
		$('#tipoTransaccion').val(catTipoTranSolicitud.modifica);
		$('#tipoActualizacion').val('0');
	});

	$('#liberar').click(function() {
		validarTransaccion();
		$('#tipoTransaccion').val(catTipoTranSolicitud.actualiza);
		$('#tipoActualizacion').val(catTipoActSolicitud.liberar);
	});

	function validarTransaccion(){

		var fechaAplicacion = parametroBean.fechaAplicacion;
		var fechaProyeccion = $('#fechaDesembolso').val();
		var validacion = false;
		var tipoMensaje = 0;

		if( banderaProyeccion == 0 &&
			Date.parse(fechaProyeccion) > Date.parse(fechaAplicacion) ) {
			validacion = true;
			tipoMensaje = 1;
		}

		if( banderaCliente > 0 ) {
			validacion = true;
			tipoMensaje = 2;
		}

		if ( validacion ) {

			var mensajePantalla = "";
			var jqControl = "";
			var idControl = "";

			switch (tipoMensaje) {
				// si el tipo de pago de capital es CRECIENTES
				case 1 :
					mensajePantalla = "La fecha de desembolso ha sido modificada, favor de recalcular los intereses de los créditos a consolidar.";
					idControl = "fechaDesembolso";
					jqControl = eval("'#" + idControl + "'");
				break;
				case 2 :
					mensajePantalla = mensajeValidacion;
					idControl = "clienteID";
					jqControl = eval("'#" + idControl + "'");
			}

			mensajeSis(mensajePantalla);
			$(jqControl).focus();
			return;
		}
	}

	$('#agregaConsolidacion').click(function() {

		if( $('#creditoID').val() == 0 ||  $('#creditoID').val() == '' ){
			mensajeSis('El campo Crédito esta vacío');
			$('#creditoID').focus();
			return ;
		}

		var consolidacionesBean = {
			folioConsolidaID 	: $('#folioConsolidaID').val(),
			creditoID 			: $('#creditoID').val(),
			solicitudCreditoID 	: $('#solicitudCreditoID').val(),
			fechaDesembolso 	: $('#fechaDesembolso').val(),
			transaccion 		: $('#numTransaccion').val(),
			tipoTransaccion		: 1
		};

		bloquearPantalla();
		$.post( 'consolidacionCreditoAgro.htm',consolidacionesBean,
			function(consolidacionesResponse) {
				desbloquearPantalla();
				if (consolidacionesResponse != null) {
					if( consolidacionesResponse.numero == 0 ){
						$('#folioConsolidaID').val(consolidacionesResponse.consecutivoInt);
						$('#numTransaccion').val(consolidacionesResponse.consecutivoString);
						$('#datosCredito').val('');
						$('#creditoID').val('');
						mostrarCreditosConsolidado(consolidacionesResponse.consecutivoInt);
					} else {
						mensajeSis(consolidacionesResponse.descripcion);
					}
				} else {
					mensajeSis("Error en el Alta de Créditos Consolidados.");
				}
			}
		);
		$('#creditoID').focus();
	});


	// eventos para cliente
	$('#clienteID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		var prospec = $('#prospectoID').val();
		var clienteBloq = $('#clienteID').asNumber();
		if (clienteBloq > 0 && esTab) {
			listaPersBloqBean = consultaListaPersBloq(clienteBloq, esCliente, 0, 0);
			if (listaPersBloqBean.estaBloqueado != 'S') {
				expedienteBean = consultaExpedienteCliente($('#clienteID').val());
				if (expedienteBean.tiempo <= 1) {
					consultaClienteConsolidado($('#clienteID').val());
					if( esConsolidadoAgro == 'S' ){
						if (alertaCte($('#clienteID').asNumber()) != 999) {
							if (prospec == '0' || prospec == '') {
								if ($('#clienteID').val() == '0' || $('#clienteID').val() == '' && esTab == true) {
									mensajeSis("Especificar " + $('#alertSocio').val() + " o Prospecto.");
									$('#prospectoID').focus();
									$('#nombreCte').val("");
									$('#promotorID').val("");
									$('#nombrePromotor').val("");
								}
							}

							if (isNaN($('#clienteID').val())) {
								$('#clienteID').val("");
								$('#clienteID').focus();
								$('#nombreCte').val("");
								$('#promotorID').val("");
								$('#nombrePromotor').val("");
								$('#prospectoID').val("");
								$('#nombreProspecto').val("");
							} else {

								if (clienteIDBase != $('#clienteID').asNumber() || $.trim($('#clienteID').val()) != "") {
									clienteIDBase = $('#clienteID').asNumber();
									calculaTasa = 'S';
									consultaCliente($('#clienteID').val(), calculaTasa);

									validaDatosGrupales('productoCreditoID', Number($('#solicitudCreditoID').val()), Number($('#prospectoID').val()), Number($('#clienteID').val()), Number($('#productoCreditoID').val()), Number($('#grupoID').val()));
									//Se agrega ajuste para que solamente consulte el porcentaje de la garantia cuando la solicitud tenga valor
									if( $('#solicitudCreditoID').asNumber() > 0 ) {
										consultaPorcentajeGarantiaLiquida(this.id);
									}
								}
							}
						} else {
							mensajeSis('Es necesario Actualizar el Expediente del ' + $('#alertSocio').val() + ' para Continuar.');
							$('#clienteID').val("");
							$('#clienteID').focus();
							$('#nombreCte').val("");
							$('#promotorID').val("");
							$('#nombrePromotor').val("");
							$('#prospectoID').val("");
							$('#nombreProspecto').val("");
						}
					} else {
						$('#clienteID').focus();
						mensajeSis(mensajeValidacion);
					}
				}
			} else {
				mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
				$('#clienteID').val("");
				$('#clienteID').focus();
				$('#nombreCte').val("");
				$('#promotorID').val("");
				$('#nombrePromotor').val("");
				$('#prospectoID').val("");
				$('#nombreProspecto').val("");
			}
		}
	});

	$('#deudorOriginalID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if(esTab){
			consultaDeudorOriginal($('#deudorOriginalID').val());
		}
	});

	$('#creditoID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if(esTab){
			consultaCredito($('#creditoID').val());
		}
	});

	// eventos para prospecto
	$('#prospectoID').bind('keyup', function(e) {
		lista('prospectoID', '1', '1', 'prospectoID', $('#prospectoID').val(), 'listaProspecto.htm');
	});

	$('#prospectoID').blur(function() {
		if (prospectoIDBase != $('#prospectoID').asNumber() && $.trim($('#prospectoID').val()) != "" && esTab == true) {
			prospectoIDBase = $('#prospectoID').asNumber();
			consultaProspecto(this.id);
			validaDatosGrupales('productoCreditoID', Number($('#solicitudCreditoID').val()), Number($('#prospectoID').val()), Number($('#clienteID').val()), Number($('#productoCreditoID').val()), Number($('#grupoID').val()));
			//Se agrega ajuste para que solamente consulte el porcentaje de la garantia cuando la solicitud tenga valor
			if( $('#solicitudCreditoID').asNumber() > 0){
				consultaPorcentajeGarantiaLiquida(this.id);
			}

		}
		if ($('#prospectoID').val() == '' || $('#prospectoID').val() == '0') {
			$('#nombreProspecto').val('');
			habilitaControl('clienteID');
		}

	});

	// eventos para producto de credito
	$('#productoCreditoID').bind('keyup', function(e) {
		lista('productoCreditoID', '1', enum_productos_list.agropecuario, 'descripcion', $('#productoCreditoID').val(), 'listaProductosCredito.htm');
	});

	$('#productoCreditoID').focus(function() {
		if ($('#prospectoID').asNumber() == '0') {
			if ($('#clienteID').asNumber() == '0') {
				mensajeSis("Especificar " + $('#alertSocio').val() + " o Prospecto");
				$('#prospectoID').focus();
				$('#nombreCte').val("");
				$('#promotorID').val("");
				$('#nombrePromotor').val("");
			}
			if (funcionHuella == "S" && huellaProductos == "S") {
				consultaHuellaCliente();
			}
		}
	});

	$('#productoCreditoID').blur(function() {
		if (isNaN($('#productoCreditoID').val() && esTab == true)) {
			$('#productoCreditoID').val("");
			$('#productoCreditoID').focus();
			$('#descripProducto').val("");
		} else {
			if ($('#productoCreditoID').asNumber() > 0 && $.trim($('#productoCreditoID').val()) != "") {
				if (esTab == true) {
					productoIDBase = $('#productoCreditoID').asNumber();
					// si la solicitud es cero (se trata de una nueva solicitud)
					if ($('#solicitudCreditoID').asNumber() == 0) {
						consultaProducCredito(this.id);
						validaDatosGrupales('productoCreditoID', Number($('#solicitudCreditoID').val()), Number($('#prospectoID').val()), Number($('#clienteID').val()), Number($('#productoCreditoID').val()), Number($('#grupoID').val()));
					} else {
						consultaProducCredito(this.id);
					}
				}
			}
		}
	});

	$('#grupoID').blur(function() {
		if (isNaN($('#grupoID').val()) && esTab == true) {
			$('#grupoID').val("");
			$('#grupoID').focus();
			$('#nombreGr').val("");
			grupoIDBase = 0;
		} else {
			if (grupoIDBase != $('#grupoID').asNumber() && $.trim($('#grupoID').val()) != "") {
				if (esTab == true) {
					grupoIDBase = $('#grupoID').val();
					consultaGrupo(this.id);
					validaDatosGrupales('productoCreditoID', Number($('#solicitudCreditoID').val()), Number($('#prospectoID').val()), Number($('#clienteID').val()), Number($('#productoCreditoID').val()), Number($('#grupoID').val()));
				}
			}
		}

	});

	$("#fechaInicioAmor").blur(function() {
		if (!$("#fechaInicioAmor").is('[readonly]')) {
			var dias;

			if (this.value != "") {
				if (esFechaValida(this.value, "fechaInicioAmor") == true) {
					dias = restaFechas(parametroBean.fechaAplicacion, this.value);

					if (parseInt(dias) < 0) {
						mensajeSis("La Fecha de Inicio No debe ser Menor a la Fecha del Sistema.");
						this.value = parametroBean.fechaAplicacion;
						$("#fechaInicio").val(this.value);
						this.focus();
					} else {

						if (parseInt(dias) <= diasMaximo) {
							if (!$("#calendIrregularCheck").is(':checked')) { // Empiece a pagar en NO aplica para pagos de capital LIBRES
								consultaFechaVencimiento('plazoID');
								$("#fechaInicio").val(this.value);
							}

							else {
								if (this.value != parametroBean.fechaAplicacion) {
									mensajeSis("La Fecha de Inicio de Primer Amortización \nNo Puede Ser Diferente a la Fecha Actual \nCuando el Calendario de Pagos es Irregular.");

									this.value = $("#fechaInicio").val();
									this.focus();

								}
							}

						} else {
							mensajeSis("La Fecha de Pago puede Iniciar en Máximo " + diasMaximo + " Días.");
							this.value = parametroBean.fechaAplicacion;
							this.focus();
						}

					}

				} else {
					this.value = parametroBean.fechaAplicacion;
					this.focus();
				}
			}
		}
	});

	$("#fechaInicioAmor").change(function() {
		this.focus();
	});

	$('#grupoID').bind('keyup', function(e) {
		if ($('#grupo').val() == undefined) {
			if (this.value.length >= 2) {
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "nombreGrupo";
				parametrosLista[0] = $('#grupoID').val();
				listaAlfanumerica('grupoID', '1', '1', camposLista, parametrosLista, 'listaGruposCredito.htm');
			}
		}
	});
	$('#destinoCreID').bind('keyup', function(e) {
		if ( !isNaN($('#productoCreditoID').val()) ) {
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = 'destinoCreID';
			camposLista[1] = 'producCreditoID';
			parametrosLista[0] = $('#destinoCreID').val();
			parametrosLista[1] = $('#productoCreditoID').val();
			lista('destinoCreID', '2', '2', camposLista, parametrosLista,'listaDestinosCredito.htm');
		}
	});

	$('#destinoCreID').blur(function() {
		if (isNaN($('#destinoCreID').val())) {
			$('#destinoCreID').val("");
			$('#destinoCreID').focus();
			$('#descripDestino').val("");
		} else {
			esTab = true;
			consultaDestinoCredito(this.id);
		}
	});

	$('#promotorID').bind('keyup', function(e) {
		lista('promotorID', '1', '10', 'nombrePromotor', $('#promotorID').val(), 'listaPromotores.htm');
	});

	$('#promotorID').blur(function() {
		consultaPromotor(this.id);
	});

	$('#solicitudCreditoID').bind('keyup', function(e) {
		if (this.value.length >= 0) {
			var camposLista = new Array();
			var parametrosLista = new Array();

			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#solicitudCreditoID').val();

			lista('solicitudCreditoID', '3', enum_solicitud_lis.agropecuarios, camposLista, parametrosLista, 'listaSolicitudCredito.htm');
		}
	});

	$('#plazoID').change(function() {
		consultaFechaVencimiento(this.id);

	});

	$('#plazoID').blur(function() {
		if ($('#plazoID').val() != '0' && $('#plazoID').val() != '') {

			if ($('#montoSolici').val() != '0' && $('#montoSolici').val() != '') {
				calculoCostoSeguro();
				consultaFechaVencimiento(this.id);
				consultaPorcentajeGarantiaLiquida('montoSolici');
			} else {
				mensajeSis('Especifique el Monto Solicitado');
				$('#montoSolici').focus();
			}

		} else {
			if (esTab) {
				mensajeSis("Especificar el Plazo del Crédito");
				$('#plazoID').focus();
			}
			esTab = false;
		}
	});

	$('#montoSolici').blur(function() {
		/*MINISTRACIONES*/
		if ($('#montoSolici').asNumber() > 0) {
			$('#diferenciaMinistra').val($('#montoSolici').val());
		}

		/*FIN MINISTRACIONES*/
		if ($('#montoSolici').val() != '' && esTab == true) {
			// si el producto de credito no se ha especificado se solicita indicarlo
			if ($('#productoCreditoID').val() == '') {
				mensajeSis("Especificar Producto de Crédito");
				$('#productoCreditoID').focus();
				$('#montoSolici').val("0.00");
				montoSolicitudBase = 0.00;
				montoOriginalSolicitud = montoSolicitudBase;
			} else {
				if (inicioAfuturo == 'S') {
					$('#fechaInicioAmor').focus();
				} else {
					$('#plazoID').focus();
				}
				/*consulta el porcentaje de GL de la tabla de esquemas de garantia liquida */
				if ($('#plazoID').val() != '0' && $('#plazoID').val() != '') {
					calculaNodeDias($('#plazoID').val());
				}
				consultaPorcentajeGarantiaLiquida(this.id);
			}
		}


		$('#montoSolici').formatCurrency({
			positiveFormat : '%n',
			roundToDecimalPlace : 2
		});

		if ($('#auxTipPago').val() != "") {
			var aux = $('#auxTipPago').val();
			$('#forCobroSegVida').val(aux);
			calculoCostoSeguro();
			calculaMontoGarantiaLiquida($('#porcGarLiq').asNumber());

		}

		// Si existe un cambio en el monto de la solicitud de crediuto y la solicitud tiene una linea de credito agro
		// Se verifica que el monto de la solicitud no exceda el monto de la linea de credito
		if( $('#lineaCreditoID').val() > 0 &&
			$('#estatus').val() == 'I' &&
			$('#montoSolici').asNumber() > $('#saldoDisponible').asNumber() ){
			mensajeSis("El Monto solicitado es mayor al saldo disponible actual de la línea de crédito seleccionada.");
			$('#montoSolici').focus();
			$('#montoSolici').select();
		}

		// Si existe una linea de credito agro que maneja comision por administracion y la forma de cobro de la administracione es por
		// disposicion se recalcula el monto de comision
		if( $('#lineaCreditoID').val() > 0 &&
			$('#manejaComAdmon').val() == 'S' &&
			$('#forPagComAdmon').val() != '') {

			var montoBase = 0.00;
			var montoPagComAdmon = 0.00;
			var montoIVAAdmon = 0.00;
			var montoSolicitadoCredito = $('#montoSolici').asNumber();

			if( forCobComAdmon == cat_ForCobComisiones.Disposicion ){
				montoBase = $('#montoSolici').asNumber();
			}

			if( forCobComAdmon == cat_ForCobComisiones.TotalPriDisposicion ){
				montoBase = montoLineaCreditoAgro;
			}

			montoPagComAdmon = (montoBase * $('#porcentajeComAdmon').asNumber())/100;
			montoPagComAdmon =  montoPagComAdmon.toFixed(2);
			$('#montoPagComAdmon').val(montoPagComAdmon);

			if( $('#pagaIVACte').val() == 'S'){
				montoIVAAdmon = $('#montoPagComAdmon').asNumber() * parametroBean.ivaSucursal;
				montoIVAAdmon =  montoIVAAdmon.toFixed(2);
			}

			$('#montoIvaPagComAdmon').val(montoIVAAdmon);

			if( $('#forPagComAdmon').val() == cat_ForPagComisiones.Deduccion ){
				montoPagComAdmon = montoOriginalSolicitud;
			}

			if( $('#forPagComAdmon').val() == cat_ForPagComisiones.Financiado ){
				montoPagComAdmon = parseFloat(montoPagComAdmon) + parseFloat(montoIVAAdmon) + parseFloat(montoSolicitadoCredito);
			}

			$('#montoSolici').val(montoPagComAdmon);
			$('#capitalMinis1').val(montoPagComAdmon);
			$('#totalMinistra').val(montoPagComAdmon);
			$('#diferenciaMinistra').val(0.00);


			$('#montoSolici').formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 2
			});

			$('#montoPagComAdmon').formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 2
			});

			$('#montoIvaPagComAdmon').formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 2
			});

			$('#manejaComGarantia').focus();
			if( $('#manejaComGarantia').val() == 'N' ){
				$('#simular').focus();
			}

			if($('#montoSolici').asNumber() > $('#saldoDisponible').asNumber() ){
				mensajeSis("El Monto solicitado es mayor al saldo disponible actual de la línea de crédito seleccionada.");
				$('#montoSolici').focus();
				$('#montoSolici').select();
			}
		}

	});

	$('#institutFondID').bind('keyup', function(e) {
		lista('institutFondID', '1', '1', 'nombreInstitFon', $('#institutFondID').val(), 'intitutFondeoLista.htm');
	});

	$('#institutFondID').blur(function() {
		consultaInstitucionFondeo(this.id);
	});

	$('#lineaFondeoID').bind('keyup', function(e) {
			var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "descripLinea";
		camposLista[1] = "institutFondID";
		parametrosLista[0] = $('#lineaFondeoID').val();
		parametrosLista[1] = $('#institutFondID').val();
		lista('lineaFondeoID', '0', '2', camposLista, parametrosLista, 'listaLineasFondeador.htm');
	});

	$('#lineaFondeoID').change(function() {
		if (isNaN($('#lineaFondeoID').val())) {
			$('#lineaFondeoID').val("");
			$('#lineaFondeoID').focus();
			$('#descripLineaFon').val('');
			$('#saldoLineaFon').val('');
			$('#tasaPasiva').val('');
		} else {
			esTab = true;
			consultaLineaFondeo(this.id);
		}
	});

	$('#lineaFondeoID').blur(function() {
		if (isNaN($('#lineaFondeoID').val())) {
			$('#lineaFondeoID').val("");
			$('#lineaFondeoID').focus();
			$('#descripLineaFon').val('');
			$('#saldoLineaFon').val('');
			$('#tasaPasiva').val('');
		} else {
			if (esTab == true) {
				consultaLineaFondeo(this.id);
			}
		}
	});

	$('input[name="tipoFondeo"]').change(function(event) {
		var tipoDeFondeo = $('input[name=tipoFondeo]:checked').val();
		if (tipoDeFondeo == Enum_TipoFondeo.RecursosPropios) {
			deshabilitaControl('institutFondID');
			deshabilitaControl('lineaFondeoID');
			deshabilitaControl('tasaPasiva');
			$('#institutFondID').val("0");
			$('#lineaFondeoID').val("0");
			$('#descripFondeo').val("");
			$('#descripLineaFon').val("");
			$('#saldoLineaFon').val("");
			$('#tasaPasiva').val("");
			$('#acreditadoIDFIRA').val("");
			$('#creditoIDFIRA').val("");
			mostrarElementoPorClase('mostrarAcredFIRA', false);
			mostrarElementoPorClase('mostrarAcred', false);
			mostrarElementoPorClase('mostrarCred', false);
		} else if (tipoDeFondeo == Enum_TipoFondeo.Financiamiento) {
			habilitaControl('lineaFondeoID');
			habilitaControl('tasaPasiva');
			consultaInstitucionFondeo('institutFondID');
		}
	});

	$('#tipoDispersion').blur(function() {
		if ($('#tipoDispersion').val() == 'S') {
			habilitaControl('cuentaCLABE');
			$('#cuentaCLABE').focus();
		} else {
			deshabilitaControl('cuentaCLABE');
			$('#cuentaCLABE').val('');

		}

		consultaPorcentajeGarantiaLiquida('montoSolici');

	});

	$('#cuentaCLABE').blur(function() {
		if ($('#cuentaCLABE').val() == "" && $('#tipoDispersion').val() == 'S') {
			mensajeSis("Cuenta CLABE requerida");
			$('#tipoDispersion').focus();
		} else {
			// valida que los primeros tres digitos de  la cuenta clabe correspondan con alguna  institucion
			validaSpei(this.id, this.id);
		}
	});

	// Consulta Tasa Base al perder el Foco
	$('#tasaBase').blur(function() {
		if ($('#tasaBase').val() != 0) {
			consultaTasaBase(this.id, true);
		} else {
			hayTasaBase = false;
			$('#tasaBase').val('');
			$('#desTasaBase').val('');
			$('#tasaFija').val('').change();
		}
	});

	// Buscar Tasa Base por Nombre
	$('#tasaBase').bind('keyup', function(e) {
		if (this.value.length >= 2) {
			lista('tasaBase', '2', '1', 'nombre', $('#tasaBase').val(), 'tasaBaseLista.htm');
		}
	});

	$('#sobreTasa').blur(function() {
		if (hayTasaBase) {
			$('#tasaFija').val(parseFloat(valorTasaBase) + $('#sobreTasa').asNumber()).change();
			$('#tasaFija').formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 4
			});
		} else {
			$('#tasaFija').val('').change();
		}
	});

	$('#tasaFija').change(function() {
		vuelveaSimular();
	});

	$('#parentescoID').bind('keyup', function(e) {
		if (this.value.length >= 2) {
			lista('parentescoID', '2', '1', 'descripcion', $('#parentescoID').val(), 'listaParentescos.htm');
		}
	});

	$('#parentescoID').blur(function() {
		consultaParentesco(this.id);
	});

	$('#solicitudCreditoID').blur(function() {

		estatusSimulacion = false;
		if (isNaN($('#solicitudCreditoID').val()) && esTab == true) {
			$('#solicitudCreditoID').val("0");
			var_NoEsNuevaSol = false;
			inicializaValoresNuevaSolicitud();
			muestraSeccionSeguroCuota();
			if( $('#solicitudCreditoID').val() == '0' || $('#solicitudCreditoID').val() == 0){
				inicializaValoresNuevaSolicitud();
			}

		} else {
			if ($.trim($('#solicitudCreditoID').val()) != "" && esTab == true) {
				if($('#solicitudCreditoID').asNumber()==0){
					var_NoEsNuevaSol = false;
				} else {
					var_NoEsNuevaSol = true;
				}
				validaSolicitudCredito(this.id);
				consultaEsquemaSeguroVidaForanea(tipoPagoSeg);
				validacion_maxminExitosa = false;
				validaDatosGrupales('productoCreditoID', Number($('#solicitudCreditoID').val()), Number($('#prospectoID').val()), Number($('#clienteID').val()), Number($('#productoCreditoID').val()), Number($('#grupoID').val()));
				$('#liberar').hide();
			}
		}
	});

	$('#lblFolioCtrl').hide();
	$('#folioCtrlCaja').hide();
	$('#sep').hide();

	// ------------------------- EVENTOS PARA SECCION DE CALENDARIO DE PAGOS -------------------------------- //
	$('#fechInhabil1').click(function() {
		$('#fechInhabil2').attr('checked', false);
		$('#fechInhabil1').attr('checked', true);
		$('#fechInhabil').val("S");
		$('#fechInhabil1').focus();
	});

	$('#fechInhabil2').click(function() {
		$('#fechInhabil1').attr('checked', false);
		$('#fechInhabil2').attr('checked', true);
		$('#fechInhabil').val("N");
		$('#fechInhabil2').focus();
	});

	$('#diaPagoInteres1').click(function() {

		$('#diaPagoInteres2').attr('checked', false);
		$('#diaPagoInteres1').attr('checked', true);
		$('#diaPagoInteres').val('F');
		deshabilitaControl('diaMesInteres');
		$('#diaMesInteres').val("");

	});

	$('#diaPagoInteres2').click(function() {
		$('#diaPagoInteres1').attr('checked', false);
		$('#diaPagoInteres2').attr('checked', true);
		$('#diaPagoInteres').val($('#diaPagoProd').val());

		$('#diaPagoInteres1').attr('checked', false);
		$('#diaPagoInteres2').attr('checked', true);
		$('#diaPagoInteres').val('D'); // Por default se asigna dia del mes
		$('#diaMesInteres').val(diaSucursal);

		if ($('#diaPagoProd').val() == "D" || $('#diaPagoProd').val() == "I") { // solo si es Dia del mes o Indistinto se habilita la caja
			habilitaControl('diaMesInteres');
		} else {
			deshabilitaControl('diaMesInteres');
		}
	});

	$('#diaPagoCapital1').click(function() {
		$('#diaPagoCapital2').attr('checked', false);
		$('#diaPagoCapital1').attr('checked', true);
		$('#diaPagoCapital').val('F');
		deshabilitaControl('diaMesCapital');
		$('#diaMesCapital').val("");

		if ($('#tipoPagoCapital').val() == 'C' || $('#perIgual').val() == 'S') {
			$('#diaPagoInteres2').attr('checked', false);
			$('#diaPagoInteres1').attr('checked', true);
			$('#diaPagoInteres').val('F');
			deshabilitaControl('diaMesInteres');
			$('#diaMesInteres').val("");
		}
	});

	$('#diaPagoCapital2').click(function() {
		$('#diaPagoCapital1').attr('checked', false);
		$('#diaPagoCapital2').attr('checked', true);
		$('#diaPagoCapital').val('D'); // Por default se asigna dia del mes
		$('#diaMesCapital').val(diaSucursal);

		if ($('#diaPagoProd').val() == "D" || $('#diaPagoProd').val() == "I") { // solo si es Dia del mes o Indistinto se habilita la caja
			habilitaControl('diaMesCapital');
		} else {
			deshabilitaControl('diaMesCapital');
		}

		if ($('#tipoPagoCapital').val() == 'C' || $('#perIgual').val() == 'S') {
			$('#diaPagoInteres1').attr('checked', false);
			$('#diaPagoInteres2').attr('checked', true);
			deshabilitaControl('diaMesInteres');
			$('#diaMesInteres').val(diaSucursal);
			$('#diaPagoInteres').val('D');
		}
	});

	$('#diaMesCapital').blur(function() {
		if (this.value != "") {
			if (parseInt(this.value) <= 31) {
				if ($('#tipoPagoCapital').val() == 'C' || $('#perIgual').val() == 'S') {
					$('#diaMesInteres').val($('#diaMesCapital').val());
				}
			} else {
				mensajeSis("El Día de Mes Indicado es Incorrecto.");
				this.focus();
				this.select();
			}
		}
	});

	$('#diaMesInteres').blur(function() {
		if (this.value != "") {
			if (parseInt(this.value) > 31) {
				mensajeSis("El Día de Mes Indicado es Incorrecto.");
				this.focus();
				this.select();
			}
		}

	});

	$('#periodicidadCap').blur(function() {
		if (parseInt(this.value) > 0) {
			if ($("#frecuenciaCap").val() == 'P') {
				$("#numAmortizacion").val(parseInt(parseInt($("#noDias").val()) / parseInt(this.value)));
			}
			if ($('#tipoPagoCapital').val() == 'C' || $('#perIgual').val() == 'S') {

				$('#periodicidadInt').val($('#periodicidadCap').val());
				$('#numAmortInteres').val($('#numAmortizacion').val());
			}
		} else {
			if ($("#frecuenciaCap").val() != '') {
				if ($("#frecuenciaCap").val() != 'L') {
					mensajeSis("Indique la Periodicidad de Capital.");
					this.focus();
				}
			}
		}
	});

	$('#periodicidadInt').blur(function() {
		if (parseInt(this.value) > 0) {
			if ($("#frecuenciaInt").val() == 'P') {
				$("#numAmortInteres").val(parseInt(parseInt($("#noDias").val()) / parseInt(this.value)));
			}
		} else {
			if ($("#frecuenciaInt").val() != '') {
				if ($("#frecuenciaInt").val() != 'L') {
					mensajeSis("Indique la Periodicidad de Interés.");
					this.focus();
				}
			}
		}
	});

	$('#calendIrregularCheck').click(function() {
		if ($('#calendIrregularCheck').is(':checked')) {
			$('#calendIrregular').val("S");
			if ($("#fechaInicio").val() < parametroBean.fechaAplicacion) {
				$("#fechaInicioAmor").val(parametroBean.fechaAplicacion);
				$("#fechaDesembolso").val(parametroBean.fechaAplicacion);
			} else {
				$("#fechaInicioAmor").val($("#fechaInicio").val());
				$("#fechaDesembolso").val($("#fechaInicio").val());
			}
			deshabilitaControl('frecuenciaInt');
			deshabilitaControl('frecuenciaCap');
			deshabilitaControl('tipoPagoCapital');
			$('#frecuenciaInt').val('L').selected = true;
			$('#frecuenciaCap').val('L').selected = true;
			$('#tipoPagoCapital').val('L').selected = true;
			$("#numAmortInteres").val('1');
			$("#numAmortizacion").val('1');
			deshabilitaControl('numAmortInteres');
			deshabilitaControl('numAmortizacion');
			validarEsquemaCobroSeguro();
		} else {
			$('#calendIrregular').val("N");
			$('#frecuenciaInt').val('').selected = true;
			$('#frecuenciaCap').val('').selected = true;
			$("#montoSeguroCuota").val('');
			habilitaControl('frecuenciaInt');
			habilitaControl('frecuenciaCap');
			habilitaControl('tipoPagoCapital');
			habilitaControl('numAmortizacion');

			if ($("#tipoPagoCapital").val() == 'C' || $('#perIgual').val() == 'S') {
				deshabilitaControl('numAmortInteres');
			} else {
				habilitaControl('numAmortInteres');
			}
		}

		$('#numTransacSim').val("0");
	});

	$('#tipoPagoCapital').change(function() {
		estatusSimulacion = false;
		validaTipoPago();
	});

	$('#tipoPagoCapital').blur(function() {
		validaTipoPago();
	});

	$('#frecuenciaCap').change(function() {
		validarEventoFrecuencia();
		validaPeriodicidad();
		consultaFechaVencimiento('plazoID');
	});
	$('#frecuenciaCap').blur(function() {
		validarEventoFrecuencia();
		validaPeriodicidad();
		consultaFechaVencimiento('plazoID');
		var fecha = parametroBean.fechaAplicacion;
		validaDiasCobro();
		esTab = true;
		var fechaCalculada = sumaDiasFechaHabil(3, fecha, numeroDias, 0, 'S');

		$("#fechaCobroComision").val(fechaCalculada.fecha);
	});

	$('#frecuenciaInt').change(function() {
		validarEventoFrecuencia();
		validaPeriodicidad();
		consultaCuotasInteres('plazoID');
	});
	$('#frecuenciaInt').blur(function() {
		validarEventoFrecuencia();
		validaPeriodicidad();
		consultaCuotasInteres('plazoID');
	});

	$('#tipoConsultaSICBuro').click(function() {
		$('#tipoConsultaSICBuro').attr("checked", true);
		$('#tipoConsultaSICCirculo').attr("checked", false);
		$('#consultaBuro').show();
		$('#consultaCirculo').hide();
		$('#folioConsultaCC').val('');
		$('#folioConsultaBC').focus();
		$('#tipoConsultaSIC').val('BC');

	});

	$('#tipoConsultaSICCirculo').click(function() {
		$('#tipoConsultaSICBuro').attr("checked", false);
		$('#tipoConsultaSICCirculo').attr("checked", true);
		$('#consultaBuro').hide();
		$('#consultaCirculo').show();
		$('#folioConsultaBC').val('');
		$('#folioConsultaCC').focus();
		$('#tipoConsultaSIC').val('CC');
	});

	// valida que el numero de cuotas sólo se modifique +1 cuota, -1 cuota de la calculada
	$('#numAmortizacion').blur(function() {
		if ($("#frecuenciaCap").val() != "") {
			if (parseInt(this.value) > 0) {
				var nuevoNumCuotas = $('#numAmortizacion').asNumber();
				var valorMayor = parseInt(NumCuotas) + 1;
				var valorMenor = parseInt(NumCuotas) - 1;

				if ($('#tipoPagoCapital').val() != "L" && $('#frecuenciaCap').val() != "P") {
					if (nuevoNumCuotas > valorMayor) {
						$('#numAmortizacion').val(NumCuotas);
						mensajeSis("Sólo Una Cuota Más");
						$('#numAmortizacion').focus();
					} else {
						if (nuevoNumCuotas < valorMenor) {
							$('#numAmortizacion').val(NumCuotas);
							mensajeSis("Sólo Una Cuota Menos");
							$('#numAmortizacion').focus();
						} else {
							if (nuevoNumCuotas <= valorMenor) {
								$('#error2').hide();
							} else {
								if ($('#tipoPagoCapital').val() == 'C' || $('#perIgual').val() == 'S') {
									$('#numAmortInteres').val($('#numAmortizacion').val());

								}
								consultaFechaVencimientoCuotas('numAmortizacion');

							}
						}
					}

				} else {

					// valida q el numero de cuotas tecleado * periodicidad no superen el numero de dias del plazo
					if ($('#frecuenciaCap').val() == "P" || ($('#tipoPagoCapital').val() == "L" && $("#calendIrregularCheck").is(':checked') == false)) {
						var diasCalculados = parseInt(this.value) * parseInt($("#periodicidadCap").val());
						if (parseInt(diasCalculados) > parseInt($("#noDias").val())) {
							mensajeSis("El Número de Cuotas es Incorrecto Para el Plazo y Frecuencia de Capital Indicados.");
							this.focus();
							this.select();
						}
					}

					if ($('#tipoPagoCapital').val() == 'C' || $('#perIgual').val() == 'S') {
						$('#numAmortInteres').val($('#numAmortizacion').val());
					}
				}
			} else {
				mensajeSis("Indique el Número de Cuotas.");
				this.focus();
			}
		}
	});

	// valida que el numero de cuotas sólo se modifique +1 cuota, -1 cuota de la calculada
	$('#numAmortInteres').blur(function() {
		if ($("#frecuenciaInt").val() != "") {
			if (parseInt(this.value) > 0) {
				var nuevoNumCuotas = $('#numAmortInteres').asNumber();
				var valorMayor = parseInt(NumCuotasInt) + 1;
				var valorMenor = parseInt(NumCuotasInt) - 1;

				if ($('#tipoPagoCapital').val() != "L" && $('#frecuenciaInt').val() != "P") {
					if (nuevoNumCuotas > valorMayor) {
						$('#numAmortInteres').val(NumCuotasInt);
						mensajeSis("Sólo Una Cuota Más");
						$('#numAmortInteres').focus();
					} else {
						if (nuevoNumCuotas < valorMenor) {
							$('#numAmortInteres').val(NumCuotasInt);
							mensajeSis("Sólo Una Cuota Menos");
							$('#numAmortInteres').focus();
						} else {
							if (nuevoNumCuotas <= valorMenor) {
								$('#error2').hide();

							} else {
								if ($('#tipoPagoCapital').val() == 'C' || $('#perIgual').val() == 'S') {
									$('#numAmortInteres').val($('#numAmortizacion').val());
								}
								consultaFechaVencimientoCuotas('numAmortInteres');
							}

						}
					}

				} else {

					// valida q el numero de cuotas tecleado * periodicidad no superen el numero de dias del plazo
					if ($('#frecuenciaInt').val() == "P" || ($('#tipoPagoCapital').val() == "L" && $("#calendIrregularCheck").is(':checked') == false)) {
						var diasCalculados = parseInt(this.value) * parseInt($("#periodicidadInt").val());
						if (parseInt(diasCalculados) > parseInt($("#noDias").val())) {
							mensajeSis("El Número de Cuotas es Incorrecto Para el Plazo y Frecuencia de Interés Indicados.");
							this.focus();
							this.select();
						}
					}

					if ($('#tipoPagoCapital').val() == 'C' || $('#perIgual').val() == 'S') {
						$('#numAmortInteres').val($('#numAmortizacion').val());
					}
					consultaFechaVencimientoCuotas('numAmortInteres');
				}
			} else {
				mensajeSis("Indique el Número de Cuotas.");
				this.focus();
			}
		}
	});

	$('#simular').click(function() {
		var ministraDiferencia = $("#diferenciaMinistra").val().replace(",", "");
		if ($('#tasaFija').asNumber() > 0) {
			if (llenarDetalle() && parseFloat(ministraDiferencia) == 0.00) {
				if ($('#solicitudCreditoID').asNumber() >= 0 && $('#tipoPagoCapital').val() == "L") {
					if ($('#numTransacSim').asNumber() > 0) {
						consultaSimulador();
						simulacionRealizada = true;
					} else {
						if (validaTablaMinistraciones(false, null)) {
							//Esta variable esta declarada simuladorPagosLibres.js
							simulacionRealizada = true;
							simulador();
						}
					}
				} else {
					mensajeSis("Solo se permite el Tipo de Pago de Capital en Libres.");
					$('#tipoPagoCapital').focus();
					simulacionRealizada = false;
				}
			} else {
				mensajeSis("Falta acompletar la Tabla de Ministraciones.");
				$('#capitalMinis1').focus();
				simulacionRealizada = false;
			}
		} else {
			mensajeSis('Especificar ' + VarTasaFijaoBase);
			$('#tasaFija').select();
			simulacionRealizada = false;
		}
	});
	// ------ FIN EVENTOS PARA SECCION DE CALENDARIO DE PAGOS

	$('#solicitudCreditoID').blur(function() {
		if ($('#solicitudCreditoID').val() != null && $('#solicitudCreditoID').val() != '' && $('#solicitudCreditoID').val() != '') {
			consultaCambiaPromotor();
		}
	});

	$('#tipoPagoSelect').hide();
	$('#tipoPagoSelect2').hide();

	$('#tipPago').change(function() {
		if ($('#tipPago option:selected').text() == "ADELANTADO") {
			$('#forCobroSegVida').val("A");
			var formPagOtro = "A";
			var esqSegVida = esquemaSeguro;
			consultaEsquemaSeguroVida(esqSegVida, formPagOtro);

		} else {
			if ($('#tipPago option:selected').text() == "FINANCIAMIENTO") {
				$('#forCobroSegVida').val("F");
				var formPagOtro = "F";
				var esqSegVida = esquemaSeguro;
				consultaEsquemaSeguroVida(esqSegVida, formPagOtro);

			} else {
				if ($('#tipPago option:selected').text() == "DEDUCCION") {
					$('#forCobroSegVida').val("D");
					var formPagOtro = "D";
					var esqSegVida = esquemaSeguro;
					consultaEsquemaSeguroVida(esqSegVida, formPagOtro);

				} else {
					if ($('#tipPago option:selected').text() == "OTRO") {
						$('#forCobroSegVida').val("O");
						var formPagOtro = "O";
						var esqSegVida = esquemaSeguro;
						consultaEsquemaSeguroVida(esqSegVida, formPagOtro);
					}
				}
			}
		}
		consultaPorcentajeGarantiaLiquida('montoSolici');
	});

	$('#tipPago').blur(function() {
		calculaNodeDias($('#fechaVencimiento').val());
		consultaPorcentajeGarantiaLiquida('montoSolici');
	});

	$('#montoSolici').keyup(function(e) {
		if (validarTeclas(e)) {
			montoSolicitudBase = $('#montoSolici').asNumber();
			montoOriginalSolicitud = montoSolicitudBase;
		}
	});

	$('#fechaInicio').blur(function(e) {
		consultaPorcentajeGarantiaLiquida('productoCreditoID');
	});

	$('#fechaDesembolso').change(function() { // click //
		$('#fechaDesembolso').focus();
	});

	$('#fechaDesembolso').blur(function(e) {
		if( esTab ){
			validaFechaDesembolso();
		}
	});

	$('#lineaCreditoID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "clienteID";
		camposLista[1] = "productoCreditoID";
		parametrosLista[0] = $('#clienteID').val();
		parametrosLista[1] = $('#productoCreditoID').val();
		lista('lineaCreditoID', '3', 8, camposLista, parametrosLista, 'lineasCreditoLista.htm');
	});

	$('#lineaCreditoID').blur(function() {
		if(esTab){
			consultaLineasCreditoAgro(this.id);
		}
	});

	$('#manejaComAdmon').change(function() {
		if( $('#manejaComAdmon').val() == 'N' ){
			deshabilitaControl('forPagComAdmon');
			deshabilitaControl('comAdmonLinPrevLiq');
			$('#cobroComAdmon').hide();
			$('#comAdmonLinPrevLiq').val('N');
			$('#comAdmonLinPrevLiq').attr("checked", false);
		} else {
			habilitaControl('forPagComAdmon');
			habilitaControl('comAdmonLinPrevLiq');
			$('#cobroComAdmon').show();
		}
	});

	$('#manejaComGarantia').change(function() {
		if( $('#manejaComGarantia').val() == 'N' ){
			deshabilitaControl('forPagComGarantia');
			deshabilitaControl('comGarLinPrevLiq');
			$('#cobroComGarantia').hide();
			$('#comGarLinPrevLiq').val('N');
			$('#comGarLinPrevLiq').attr("checked", false);
		} else {
			habilitaControl('forPagComGarantia');
			habilitaControl('comGarLinPrevLiq');
			$('#cobroComGarantia').show();
		}
	});

	$('#comAdmonLinPrevLiq').click(function() {
		if( $('#comAdmonLinPrevLiq').is(':checked') ){
			$('#comAdmonLinPrevLiq').val('S');
			$('#cobroComAdmon').hide();
		} else {
			$('#comAdmonLinPrevLiq').val('N');
			if($('#manejaComAdmon').val() == 'N'){
				$('#cobroComAdmon').hide();
			} else {
				$('#cobroComAdmon').show();
			}
		}
	});

	$('#comGarLinPrevLiq').click(function() {
		if( $('#comGarLinPrevLiq').is(':checked') ){
			$('#comGarLinPrevLiq').val('S');
			$('#cobroComGarantia').hide();
		} else {
			$('#comGarLinPrevLiq').val('N');
			if($('#manejaComGarantia').val() == 'N'){
				$('#cobroComGarantia').hide();
			} else {
				$('#cobroComGarantia').show();
			}
		}
	});

	$('#forPagComAdmon').blur(function() {
		$('#manejaComGarantia').focus();
		if( $('#manejaComGarantia').val() == 'S' ){
			$('#capitalMinis1').focus();
		}
	});

	$('#forPagComAdmon').change(function() {
		validaMontoAdmon();
		$('#manejaComGarantia').focus();
		if( $('#manejaComGarantia').val() == 'S' ){
			$('#capitalMinis1').focus();
		}
	});

	// --------------------------------- Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules : {
			productoCreditoID : 'required',
			promotorID : 'required',
			tipoPagoCapital : 'required',
			frecuenciaCap : {
				required : function() {
					return $('#frecuenciaCap').val() == '0';
				}
			},
			plazoID : 'required',
			cuentaCLABE : {
				required : function() {
					return $('#tipoDispersion').val() == 'S';
				},
				number : true,
				maxlength : 18
			},
			tipoDispersion : 'required',
			numAmortizacion : 'required',
			montoSolici : 'required',
			proyecto : 'required',
			destinoCreID : 'required',
			calcInteresID : 'required',
			beneficiario : {
				required : function() {
					return $('#reqSeguroVidaSi').is(':checked');
				}
			},
			direccionBen : {
				required : function() {
					return $('#reqSeguroVidaSi').is(':checked');
				}
			},
			parentescoID : {
				required : function() {
					return $('#reqSeguroVidaSi').is(':checked');
				}
			},
			tasaFija : {
				required : function() {
					return $('#tasaFija').asNumber() <= 0;
				}
			},
			tipPago : {
				required : function() {
					return $('#reqSeguroVidaSi').is(':checked') && modalidad == 'T';
				}
			},
			tasaBase : {
				required : function() {
					return $('#tasaBase').is(':enabled');
				}
			},
			sobreTasa : {
				required : function() {
					return $('#sobreTasa').is(':enabled');
				}
			},
			cadenaProductivaID : 'required',
			ramaFIRAID : 'required',
			subramaFIRAID : 'required',
			actividadFIRAID : 'required',
			tipoGarantiaFIRAID : 'required',
			progEspecialFIRAID : 'required',
			tasaPasiva : {
				required : function() {
					return $('#tasaPasiva').is(':enabled');
				}
			},
			deudorOriginalID :'required',
			fechaDesembolso :'required',
			manejaComAdmon : {
				required : function() {
					if($("#lineaCreditoID").val() == 0 ) return false; else return true;
				}
			},
			forPagComAdmon : {
				required : function() {
					if($("#lineaCreditoID").val() == 0 ){
						return false;
					} else {
						if($('#comAdmonLinPrevLiq').is(':checked')) return false; return true;
					}
				}
			},
			manejaComGarantia : {
				required : function() {
					if($("#lineaCreditoID").val() == 0 ) return false; else return true;
				}
			},
			forPagComGarantia : {
				required : function() {
					if($("#lineaCreditoID").val() == 0 ){
						return false;
					} else {
						if($('#comGarLinPrevLiq').is(':checked')) return false; return true;
					}
				}
			}
		},

		messages : {
			productoCreditoID : 'Especifique Producto',
			promotorID : 'Especifique un Promotor.',
			tipoPagoCapital : 'Especifique Tipo Pago de Capital',
			frecuenciaCap : 'Especifique Frecuencia',
			plazoID : 'Especifique Plazos',
			cuentaCLABE : {
				required : 'Especificar cuenta CLABE.',
				number : 'Soló Números.',
				maxlength : 'Máximo 18 Números.'
			},
			tipoDispersion : 'Especifique Dispersión',
			numAmortizacion : 'Especificar No de Cuotas',
			montoSolici : 'Especificar Monto',
			proyecto : 'Especificar Proyecto',
			destinoCreID : 'Especifique Destino de Crédito.',
			calcInteresID : 'Especifique Cálculo de Interés.',
			beneficiario : 'Especificar Nombre Completo',
			direccionBen : 'Especificar Dirección',
			parentescoID : 'Especificar Tipo de Parentesco',
			tasaFija : {
				required : 'Especifique la Tasa'
			},
			fechaInicioAmor : {
				date : 'Fecha Incorrecta'
			},
			tipPago : {
				required : 'Especificar Tipo de Pago'

			},
			tasaBase : {
				required : 'Especificar la Tasa Base.'

			},
			sobreTasa : {
				required : 'Especificar la Sobre Tasa.'

			},
			cadenaProductivaID : {
				required : 'La Cadena Productividad es Requerido.'

			},
			ramaFIRAID : {
				required : 'La Rama FIRA es Requerida.'

			},
			subramaFIRAID : {
				required : 'La Subrama FIRA es Requerida.'

			},
			actividadFIRAID : {
				required : 'La Actividad FIRA es Requerida.'

			},
			tipoGarantiaFIRAID : {
				required : 'El Tipo de Garantía es Requerido.'

			},
			progEspecialFIRAID : {
				required : 'El Programa Especial FIRA es Requerido.'
			},
			tasaPasiva : {
				required : 'Especifique la Tasa Pasiva.'
			},
			deudorOriginalID : {
				required : 'El Deudor Original es Requerido.'
			},
			fechaDesembolso : {
				required : 'Fecha Invalida'
			},
			manejaComAdmon : {
				required : 'Especifique la comisión por Admon.'
			},
			forPagComAdmon : {
				required : 'Especifique la Forma de Pago por comisión por Admon.'
			},
			manejaComGarantia : {
				required :  'Especifique la comisión por Garantía.'
			},
			forPagComGarantia : {
				required : 'Especifique la Forma de Pago por comisión por Garantía.'
			}
		}
	});

	consultaCambiaPromotor();
	//agrega el scroll al div de simulador de pagos libres de capital
	$('#contenedorSimuladorLibre').scroll(function() {

	});
	/** =========== BURO ===================== **/
	$('#tipoConsultaSICBuro').click(function() {
		$('#tipoConsultaSICBuro').attr("checked", true);
		$('#tipoConsultaSICCirculo').attr("checked", false);
		$('#consultaBuro').show();
		$('#consultaCirculo').hide();
		$('#folioConsultaCC').val('');
		$('#folioConsultaBC').focus();
		$('#tipoConsultaSIC').val('BC');

	});

	$('#tipoConsultaSICCirculo').click(function() {
		$('#tipoConsultaSICBuro').attr("checked", false);
		$('#tipoConsultaSICCirculo').attr("checked", true);
		$('#consultaBuro').hide();
		$('#consultaCirculo').show();
		$('#folioConsultaBC').val('');
		$('#folioConsultaCC').focus();
		$('#tipoConsultaSIC').val('CC');

	});
	/** =========== FIN BURO ===================== **/
	/** =========== CATALOGOS FIRA ===================== **/
	$('#cadenaProductivaID').bind('keyup', function(e) {
		lista('cadenaProductivaID', '2', '1', 'nomCadenaProdSCIAN', $('#cadenaProductivaID').val(), 'listaCadenaProductiva.htm');
	});
	$('#cadenaProductivaID').blur(function() {
		if (esTab) {
			consultaCadenaProductiva();
		} else if (validacion.esNumeroEntero($('#cadenaProductivaID').val())) {//Si no es numero
			limpiaCamposAgro(true, false, false);
		}
	});
	$('#cadenaProductivaID').change(function() {
		limpiaCamposAgro(true, false, false);
	});
	$('#ramaFIRAID').bind('keyup', function(e) {
		if ($('#cadenaProductivaID').asNumber() > 0) {
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "cveCadena";
			parametrosLista[0] = $('#cadenaProductivaID').val();
			camposLista[1] = "descripcionRamaFIRA";
			parametrosLista[1] = $('#ramaFIRAID').val();
			lista('ramaFIRAID', '2', '1', camposLista, parametrosLista, 'listaRelCadenaRamaFIRA.htm');
		}
	});
	$('#ramaFIRAID').blur(function() {
		if (esTab) {
			consultaRamaFIRA();
		} else if (validacion.esNumeroEntero($('#ramaFIRAID').val())) {//Si no es numero
			limpiaCamposAgro(false, true, false);
		}
	});
	$('#ramaFIRAID').change(function() {
		limpiaCamposAgro(false, true, false);
	});
	$('#subramaFIRAID').bind('keyup', function(e) {
		if ($('#cadenaProductivaID').asNumber() > 0 && $('#ramaFIRAID').asNumber() > 0) {
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "cveCadena";
			parametrosLista[0] = $('#cadenaProductivaID').val();
			camposLista[1] = "cveRamaFIRA";
			parametrosLista[1] = $('#ramaFIRAID').val();
			camposLista[2] = "descSubramaFIRA";
			parametrosLista[2] = $('#subramaFIRAID').val();
			lista('subramaFIRAID', '2', '1', camposLista, parametrosLista, 'listaRelSubRamaFIRA.htm');
		}
	});
	$('#subramaFIRAID').blur(function() {
		if (esTab) {
			consultaSubRamaFIRA();
		} else if (validacion.esNumeroEntero($('#subramaFIRAID').val())) {//Si no es numero
			limpiaCamposAgro(false, false, true);
		}
	});
	$('#subramaFIRAID').change(function() {
		limpiaCamposAgro(false, false, true);
	});
	$('#actividadFIRAID').bind('keyup', function(e) {
		if ($('#cadenaProductivaID').asNumber() > 0 && $('#ramaFIRAID').asNumber() > 0 && $('#subramaFIRAID').asNumber() > 0) {
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "cveCadena";
			parametrosLista[0] = $('#cadenaProductivaID').val();
			camposLista[1] = "cveRamaFIRA";
			parametrosLista[1] = $('#ramaFIRAID').val();
			camposLista[2] = "cveSubramaFIRA";
			parametrosLista[2] = $('#subramaFIRAID').val();
			camposLista[3] = "desActividadFIRA";
			parametrosLista[3] = $('#actividadFIRAID').val();
			lista('actividadFIRAID', '2', '1', camposLista, parametrosLista, 'listaRelActividadFIRA.htm');
		}
	});

	$('#actividadFIRAID').blur(function() {
		if (esTab) {
			consultaActividadFIRA();
		} else if (validacion.esNumeroEntero($('#actividadFIRAID').val())) {//Si no es numero
			limpiaCamposAgro(false, false, true);
		}
	});
	$('#progEspecialFIRAID').bind('keyup', function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "subPrograma";
		parametrosLista[0] = $('#progEspecialFIRAID').val();
		lista('progEspecialFIRAID', '2', '1', camposLista, parametrosLista, 'listaCatFIRAProgEsp.htm');
	});
	$('#progEspecialFIRAID').blur(function() {
		consultProgramaFira();
	});

	function validaMontoAdmon(){
		/*MINISTRACIONES*/
		if ($('#montoSolici').asNumber() > 0) {
			$('#diferenciaMinistra').val($('#montoSolici').val());
		}
		/*FIN MINISTRACIONES*/
		if ($('#montoSolici').val() != '' && esTab == true) {
			// si el producto de credito no se ha especificado se solicita indicarlo
			if ($('#productoCreditoID').val() == '') {
				mensajeSis("Especificar Producto de Crédito");
				$('#productoCreditoID').focus();
				$('#montoSolici').val("0.00");
				montoSolicitudBase = 0.00;
				montoOriginalSolicitud = montoSolicitudBase;
			} else {
				if (inicioAfuturo == 'S') {
					$('#fechaInicioAmor').focus();
				} else {
					$('#plazoID').focus();
				}
				/*consulta el porcentaje de GL de la tabla de esquemas de garantia liquida */
				if ($('#plazoID').val() != '0' && $('#plazoID').val() != '') {
					calculaNodeDias($('#plazoID').val());
				}
				consultaPorcentajeGarantiaLiquida(this.id);
			}
		}
		$('#montoSolici').formatCurrency({
			positiveFormat : '%n',
			roundToDecimalPlace : 2
		});

		if ($('#auxTipPago').val() != "") {
			var aux = $('#auxTipPago').val();
			$('#forCobroSegVida').val(aux);
			calculoCostoSeguro();
			calculaMontoGarantiaLiquida($('#porcGarLiq').asNumber());
		}

		// Si existe un cambio en el monto de la solicitud de crediuto y la solicitud tiene una linea de credito agro
		// Se verifica que el monto de la solicitud no exceda el monto de la linea de credito
		if( $('#lineaCreditoID').val() > 0 &&
			$('#estatus').val() == 'I' &&
			$('#montoSolici').asNumber() > $('#saldoDisponible').asNumber() ){
			mensajeSis("El Monto solicitado es mayor al saldo disponible actual de la línea de crédito seleccionada.");
			$('#montoSolici').focus();
			$('#montoSolici').select();
		}

		// Si existe una linea de credito agro que maneja comision por administracion y la forma de cobro de la administracione es por
		// disposicion se recalcula el monto de comision
		if( $('#lineaCreditoID').val() > 0 &&
			$('#manejaComAdmon').val() == 'S') {

			var montoBase = 0.00;
			var montoPagComAdmon = 0.00;
			var montoIVAAdmon = 0.00;
			var montoSolicitadoCredito = $('#montoSolici').asNumber();

			if( forCobComAdmon == cat_ForCobComisiones.Disposicion ){
				montoBase = $('#montoSolici').asNumber();
			}

			if( forCobComAdmon == cat_ForCobComisiones.TotalPriDisposicion ){
				montoBase = montoLineaCreditoAgro;
			}

			montoPagComAdmon = (montoBase * $('#porcentajeComAdmon').asNumber())/100;
			montoPagComAdmon =  montoPagComAdmon.toFixed(2);
			$('#montoPagComAdmon').val(montoPagComAdmon);

			if( $('#pagaIVACte').val() == 'S'){
				montoIVAAdmon = $('#montoPagComAdmon').asNumber() * parametroBean.ivaSucursal;
				montoIVAAdmon =  montoIVAAdmon.toFixed(2);
			}

			$('#montoIvaPagComAdmon').val(montoIVAAdmon);

			if( $('#forPagComAdmon').val() == cat_ForPagComisiones.Deduccion ){
				montoPagComAdmon = montoOriginalSolicitud;
			}

			if( $('#forPagComAdmon').val() == cat_ForPagComisiones.Financiado ){
				montoPagComAdmon = parseFloat(montoPagComAdmon) + parseFloat(montoIVAAdmon) + parseFloat(montoSolicitadoCredito);
			}

			$('#montoSolici').val(montoPagComAdmon);
			$('#capitalMinis1').val(montoPagComAdmon);
			$('#totalMinistra').val(montoPagComAdmon);
			$('#diferenciaMinistra').val(0.00);

			$('#montoSolici').formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 2
			});

			$('#montoPagComAdmon').formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 2
			});

			$('#montoIvaPagComAdmon').formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 2
			});

			$('#capitalMinis1').formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 2
			});

			$('#totalMinistra').formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 2
			});

			$('#diferenciaMinistra').formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 2
			});

			if($('#montoSolici').asNumber() > $('#saldoDisponible').asNumber() ){
				mensajeSis("El Monto solicitado es mayor al saldo disponible actual de la línea de crédito seleccionada.");
				$('#montoSolici').focus();
				$('#montoSolici').select();
			}

			$('#manejaComGarantia').focus();
			if( $('#manejaComGarantia').val() == 'N' ){
				$('#simular').focus();
			}
		}
	}
	/** =========== FIN CATALOGOS FIRA ===================== **/
});


function validaFechaDesembolso(){

	var fechaAplicacion = parametroBean.fechaAplicacion;
	var fechaProyeccion = $('#fechaDesembolso').val();
	var realizarProyeccion = "N";
	var reiniciarBandera = "N";
	var fechaVencimiento = $('#fechaVencimiento').val();

	if( Date.parse(fechaProyeccion) >= Date.parse(fechaVencimiento) ) {
		mensajeSis('La fecha de Desembolso es Mayor a la Fecha de Vencimiento.');
		$('#fechaDesembolso').val(fechaProyeccion);
		$('#fechaDesembolso').focus();
		return;
	}

	if( Date.parse(fechaProyeccion) < Date.parse(fechaAplicacion) ) {
		mensajeSis('La Fecha de Desembolso no puede ser Menor a la fecha del Sistema');
		$('#fechaDesembolso').val(fechaProyeccion);
		$('#fechaDesembolso').focus();
		return;
	}

	if( Date.parse(fechaProyeccion) == Date.parse(fechaAplicacion) && banderaProyeccion > 0 ) {
		realizarProyeccion = "S";
		reiniciarBandera = "S";
		$('#fechaInicioAmor').val(fechaProyeccion);
		$('#fechaPagoMinis1').val(fechaProyeccion);
		$('#fechaInicio').val(fechaProyeccion);
	}

	if( Date.parse(fechaProyeccion) > Date.parse(fechaAplicacion) ) {
		realizarProyeccion = "S";
		$('#fechaInicioAmor').val(fechaProyeccion);
		$('#fechaPagoMinis1').val(fechaProyeccion);
		$('#fechaInicio').val(fechaProyeccion);
	}

	if( realizarProyeccion == 'S' ){

		var consolidacionesBean = {
			folioConsolidaID 	: $('#folioConsolidaID').val(),
			fechaDesembolso 	: $('#fechaDesembolso').val(),
			transaccion 		: $('#numTransaccion').val(),
			tipoTransaccion		: 7
		};

		var folioConsolidaID = $('#folioConsolidaID').val();

		bloquearPantalla();
		$.post( 'consolidacionCreditoAgro.htm',consolidacionesBean,
			function(consolidacionesResponse) {
				desbloquearPantalla();
				if (consolidacionesResponse != null) {
					if( consolidacionesResponse.numero == 0 ){
						mostrarCreditosConsolidado(folioConsolidaID);
						banderaProyeccion = 1;
						if( reiniciarBandera == "S" ){
							banderaProyeccion = 0;
						}
					} else {
						mensajeSis(consolidacionesResponse.descripcion);
					}
				} else {
					mensajeSis("Error en la Proyección de Intereses de Créditos Consolidados.");
				}
			}
		);
		$('#folioConsolidaID').focus();
	}
}


function seccionCalendarioLibreAgro(tipoOperacion){

	switch (tipoOperacion) {
		// si el tipo de pago de capital es CRECIENTES
		case "C" :
			$('#divCalendarioPagos').show();
		break;
		case "I" :
			$('#divCalendarioPagos').show();
		case "L" :
			$('#divCalendarioPagos').hide();
		break;
		default :
			$('#divCalendarioPagos').hide();
		break;
	}
}



function validarTeclas(tecla) {
	var aceptado = false;
	if ((tecla.keyCode >= 48 && tecla.keyCode <= 57) || // teclas numercias
		(tecla.keyCode >= 96 && tecla.keyCode <= 105) || // panel teclado numerico
		(tecla.keyCode == 190) || (tecla.keyCode == 110) || (tecla.keyCode == 8)) { // punto, retroceso
		aceptado = true;
	}
	return aceptado;
}

//funcion para calcular o recalcular,Com. Apertura, Seguro de Vida, tasa de interes y Garantia Liquida y otras validaciones
function validaMontoSolicitudCredito() {
	// Si el monto de la solicitud de credito esta dentro de los montos permitidos por el producto de credito
	if (validaLimiteMontoSolicitado() == 1) {

		// La comision por apertura se calculando tomando el monto base(monto original) de la solicitud de credito
		consultaComisionAper();
		// La tasa de interes se calcula tomando el monto total de la solicitud de credito
		consultaTasaCredito($('#montoSolici').asNumber(), 'montoSolici');
		// La garantia liquida se calcula tomando el monto total de la solicitud de credito
		calculaMontoGarantiaLiquida($('#porcGarLiq').asNumber());
	}
}

//----------------- FUNCIONES PARA SECCION DE CALENDARIO DE PAGOS   ------------------------------ //
//funcion para cambiar los controles dependiendo de el tipo  de pago de capital  seleccionado
function validaTipoPago() {
	switch ($('#tipoPagoCapital').val()) {
		// si el tipo de pago de capital es CRECIENTES
		case "C" :
			deshabilitarCalendarioPagosInteres();
			igualarCalendarioInteresCapital();

			break;

			// si el tipo de pago de capital es IGUALES
		case "I" :
			if ($('#perIgual').val() == 'S') {
				// se llama funcion para igualar calendarios
				igualarCalendarioInteresCapital();
				deshabilitarCalendarioPagosInteres();
			} else {
				habilitarCalendarioPagosInteres();
			}
			break;

			// si el tipo de pago de capital es LIBRES
		case "L" :
			if ($('#perIgual').val() == 'S') {
				// se llama funcion para igualar calendarios
				igualarCalendarioInteresCapital();
				deshabilitarCalendarioPagosInteres();
			} else {
				habilitarCalendarioPagosInteres();
			}

			break;

		default :
			habilitarCalendarioPagosInteres();
		igualarCalendarioInteresCapital();
		break;
	}
}

/* FUNCION PARA IGUALAR CALENDARIO EN PAGOS CRECIENTES O QUE  PERMITEN IGUALDAD.*/
function igualarCalendarioInteresCapital() {
	deshabilitaControl('frecuenciaInt');
	deshabilitaControl('numAmortInteres');
	deshabilitaControl('diaMesInteres');
	deshabilitaControl('diaPagoInteres1');
	deshabilitaControl('diaPagoInteres2');

	$('#frecuenciaInt').val($('#frecuenciaCap').val()).selected = true;
	$('#numAmortInteres').val($('#numAmortizacion').val());
	$('#periodicidadInt').val($('#periodicidadCap').val());
	$('#diaMesInteres').val($('#diaMesCapital').val());

	if ($('#diaPagoCapital1').is(':checked')) {
		$('#diaPagoInteres2').attr('checked', false);
		$('#diaPagoInteres1').attr('checked', true);
		$('#diaPagoInteres').val("F");
	} else {
		if ($('#diaPagoCapital2').is(':checked')) {
			$('#diaPagoInteres1').attr('checked', false);
			$('#diaPagoInteres2').attr('checked', true);
			$('#diaPagoInteres').val("D");
		}
	}

}

//funcion para eventos cuando se selecciona dia de pago de  interes  por aniversario o fin de mes, dependiendo de la frecuencia.
function validarEventoFrecuencia() {

	switch ($('#tipoPagoCapital').val()) {
		// si el tipo de pago de capital es CRECIENTES
		case "C" :
			habilitaControl('numAmortizacion');
			deshabilitaControl('periodicidadCap');

			if ($('#frecuenciaCap').val() == 'S' || $('#frecuenciaCap').val() == 'C' || $('#frecuenciaCap').val() == 'Q' || $('#frecuenciaCap').val() == 'A') {

				if ($('#diaPagoCapital1').is(':checked')) {
					$('#diaPagoCapital1').attr("checked", true);
					$('#diaPagoCapital2').attr("checked", false);
					$('#diaMesCapital').val('');
				} else {
					$('#diaPagoCapital2').attr("checked", true);
					$('#diaPagoCapital1').attr("checked", false);
					$('#diaMesCapital').val(diaSucursal);
				}

			} else {
				if ($('#frecuenciaCap').val() == 'P') {
					if ($('#diaPagoCapital1').is(':checked')) {
						$('#diaPagoCapital1').attr("checked", true);
						$('#diaPagoCapital2').attr("checked", false);
						$('#diaMesCapital').val('');
					} else {
						$('#diaPagoCapital2').attr("checked", true);
						$('#diaPagoCapital1').attr("checked", false);
						$('#diaMesCapital').val(diaSucursal);
					}

					habilitaControl('periodicidadCap');

				} else {
					// si el tipo de pago es UNICO se  deshabilitan las cajas para indicar numero de cuotas
					if ($('#frecuenciaCap').val() == 'U') {
						deshabilitaControl('numAmortizacion');
						$('#numAmortizacion').val("1");
						mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
						$('#frecuenciaCap').focus();
						$('#periodicidadCap').val($('#noDias').val());

						if ($('#diaPagoCapital1').is(':checked')) {
							$('#diaPagoCapital1').attr("checked", true);
							$('#diaPagoCapital2').attr("checked", false);
							$('#diaMesCapital').val("");

						} else {

							if ($('#diaPagoCapital2').is(':checked')) {
								$('#diaPagoCapital2').attr("checked", true);
								$('#diaPagoCapital1').attr("checked", false);
								$('#diaMesCapital').val(diaSucursal);
							}

						}

					} else {

						if ($('#diaPagoCapital1').is(':checked')) {
							$('#diaPagoCapital1').attr("checked", true);
							$('#diaPagoCapital2').attr("checked", false);
							$('#diaMesCapital').val("");

						} else {

							if ($('#diaPagoCapital2').is(':checked')) {
								$('#diaPagoCapital2').attr("checked", true);
								$('#diaPagoCapital1').attr("checked", false);
								$('#diaMesCapital').val(diaSucursal);

							}
						}

					}
				}
			}

			// se llama funcion para igualar calendarios
			igualarCalendarioInteresCapital();
			deshabilitarCalendarioPagosInteres();

			break;

			// si el tipo de pago de capital es IGUALES
		case "I" :
			habilitaControl('numAmortizacion');
			deshabilitaControl('periodicidadCap');

			if ($('#frecuenciaCap').val() == 'S' || $('#frecuenciaCap').val() == 'C' || $('#frecuenciaCap').val() == 'Q' || $('#frecuenciaCap').val() == 'A') {
				if ($('#diaPagoCapital1').is(':checked')) {

					$('#diaPagoCapital1').attr("checked", true);
					$('#diaPagoCapital2').attr("checked", false);
					$('#diaMesCapital').val('');
				} else {
					$('#diaPagoCapital2').attr("checked", true);
					$('#diaPagoCapital1').attr("checked", false);
					$('#diaMesCapital').val(diaSucursal);
				}
			} else {
				if ($('#frecuenciaCap').val() == 'P') {

					if ($('#diaPagoCapital1').is(':checked')) {
						$('#diaPagoCapital1').attr("checked", true);
						$('#diaPagoCapital2').attr("checked", false);
						$('#diaMesCapital').val('');
					} else {
						$('#diaPagoCapital2').attr("checked", true);
						$('#diaPagoCapital1').attr("checked", false);
						$('#diaMesCapital').val(diaSucursal);
					}

					habilitaControl('periodicidadCap');
				} else {

					if ($('#frecuenciaCap').val() == 'U') {
						deshabilitaControl('numAmortizacion');
						$('#numAmortizacion').val("1");
						$('#periodicidadCap').val($('#noDias').val());

						if ($('#diaPagoCapital1').is(':checked')) {
							$('#diaPagoCapital1').attr("checked", true);
							$('#diaPagoCapital2').attr("checked", false);
							$('#diaMesCapital').val("");

						} else {
							if ($('#diaPagoCapital2').is(':checked')) {
								$('#diaPagoCapital2').attr("checked", true);
								$('#diaPagoCapital1').attr("checked", false);
								$('#diaMesCapital').val(diaSucursal);

							}
						}

					} else {

						if ($('#diaPagoCapital1').is(':checked')) {
							$('#diaPagoCapital1').attr("checked", true);
							$('#diaPagoCapital2').attr("checked", false);
							$('#diaMesCapital').val('');
						} else {
							if ($('#diaPagoCapital2').is(':checked')) {
								$('#diaPagoCapital2').attr("checked", true);
								$('#diaPagoCapital1').attr("checked", false);
								$('#diaMesCapital').val(diaSucursal);

							}
						}
					}
				}
			}

			// Verifica el producto iguala el calendario de interes al de capital
			if ($('#perIgual').val() != 'S') {
				habilitarCalendarioPagosInteres();

				if ($('#frecuenciaInt').val() == 'S' || $('#frecuenciaInt').val() == 'C' || $('#frecuenciaInt').val() == 'Q' || $('#frecuenciaInt').val() == 'A') {

					deshabilitaControl('periodicidadInt');
					habilitaControl('numAmortInteres');

				} else {

					if ($('#frecuenciaInt').val() == 'P') {
						if ($('#diaPagoInteres1').is(':checked')) {
							$('#diaPagoInteres1').attr("checked", true);
							$('#diaPagoInteres2').attr("checked", false);
							$('#diaMesInteres').val(diaSucursal);

						} else {
							$('#diaPagoInteres1').attr("checked", true);
							$('#diaPagoInteres2').attr("checked", false);
							$('#diaMesInteres').val('');
						}

						habilitaControl('periodicidadInt');
						habilitaControl('numAmortInteres');

					} else {
						if ($('#frecuenciaInt').val() == 'U') {
							$('#numAmortInteres').val("1");
							deshabilitaControl('numAmortInteres');
							deshabilitaControl('periodicidadInt');
							$('#periodicidadInt').val($('#noDias').val());

							if ($('#diaPagoInteres1').is(':checked')) {
								$('#diaPagoInteres1').attr("checked", true);
								$('#diaPagoInteres2').attr("checked", false);
								$('#diaMesInteres').val("");
							} else {
								if ($('#diaPagoInteres2').is(':checked')) {
									$('#diaPagoInteres2').attr("checked", true);
									$('#diaPagoInteres1').attr("checked", false);
									$('#diaMesInteres').val(diaSucursal);

								}
							}

						} else {
							habilitaControl('numAmortInteres');

							if ($('#diaPagoInteres1').is(':checked')) {
								$('#diaPagoInteres1').attr("checked", true);
								$('#diaPagoInteres2').attr("checked", false);
								$('#diaPagoInteres').val('F');
								$('#diaMesInteres').val("");

							} else {
								if ($('#diaPagoInteres2').is(':checked')) {
									$('#diaPagoInteres1').attr("checked", false);
									$('#diaPagoInteres2').attr("checked", true);
									$('#diaPagoInteres').val('D');
									$('#diaMesInteres').val(diaSucursal);

								}
							}
						}
					}
				}

				// solo si el producto de credito indica que el dia de pago es Indistinto
				if ($('#diaPagoProd').val() == 'I' && $('#diaPagoInteres2').is(':checked')) {
					habilitaControl('diaMesInteres');
					habilitaControl('diaPagoInteres1');
					habilitaControl('diaPagoInteres2');
				}
				// solo si el producto de credito indica que el dia de pago es Dia del mes
				if ($('#diaPagoProd').val() == 'D') {
					habilitaControl('diaMesInteres');
				}

			} else { // SI IGUALA CALENDARIOS (Interes con Capital)
				igualarCalendarioInteresCapital();
				deshabilitarCalendarioPagosInteres();
			}

			break;

			// si el tipo de pago de capital es LIBRES
		case "L" :

			habilitaControl('numAmortizacion');
			deshabilitaControl('periodicidadCap');

			if ($('#frecuenciaCap').val() == 'S' || $('#frecuenciaCap').val() == 'C' || $('#frecuenciaCap').val() == 'Q' || $('#frecuenciaCap').val() == 'A') {
				if ($('#diaPagoCapital1').is(':checked')) {
					$('#diaPagoCapital1').attr("checked", true);
					$('#diaPagoCapital2').attr("checked", false);
					$('#diaMesCapital').val('');
				} else {
					$('#diaPagoInteres2').attr('checked', true);
					$('#diaPagoCapital2').attr("checked", true);
					$('#diaPagoCapital1').attr("checked", false);
					$('#diaMesCapital').val(diaSucursal);
				}
			} else {
				if ($('#frecuenciaCap').val() == 'P') {

					if ($('#diaPagoCapital1').is(':checked')) {
						$('#diaPagoCapital1').attr("checked", true);
						$('#diaPagoCapital2').attr("checked", false);
						$('#diaMesCapital').val('');

					} else {
						$('#diaPagoCapital2').attr("checked", true);
						$('#diaPagoCapital1').attr("checked", false);
						$('#diaMesCapital').val(diaSucursal);
					}

					habilitaControl('periodicidadCap');
				} else {

					if ($('#frecuenciaCap').val() == 'U') {
						$('#numAmortizacion').val("1");
						deshabilitaControl('numAmortizacion');
						deshabilitaControl('periodicidadInt');
						$('#periodicidadCap').val($('#noDias').val());

						if ($('#diaPagoCapital1').is(':checked')) {
							$('#diaPagoCapital1').attr("checked", true);
							$('#diaPagoCapital2').attr("checked", false);
							$('#diaMesCapital').val("");

						} else {
							if ($('#diaPagoCapital2').is(':checked')) {
								$('#diaPagoCapital2').attr("checked", true);
								$('#diaPagoCapital1').attr("checked", false);
								$('#diaMesCapital').val(diaSucursal);
							}

						}

					} else {

						if ($('#diaPagoCapital1').is(':checked')) {
							$('#diaPagoCapital1').attr("checked", true);
							$('#diaPagoCapital2').attr("checked", false);
							$('#diaMesCapital').val('');

						} else {
							if ($('#diaPagoCapital2').is(':checked')) {
								$('#diaPagoCapital2').attr("checked", true);
								$('#diaPagoCapital1').attr("checked", false);
								$('#diaMesCapital').val(diaSucursal);
							}
						}
					}
				}
			}

			// Verifica el producto iguala el calendario de interes al de capital
			if ($('#perIgual').val() != 'S') {
				habilitarCalendarioPagosInteres();

				if ($('#frecuenciaInt').val() == 'S' || $('#frecuenciaInt').val() == 'C' || $('#frecuenciaInt').val() == 'Q' || $('#frecuenciaInt').val() == 'A') {

					deshabilitaControl('periodicidadInt');
					habilitaControl('numAmortInteres');

				} else {
					if ($('#frecuenciaInt').val() == 'P') {

						if ($('#diaPagoInteres1').is(':checked')) {
							$('#diaPagoInteres1').attr("checked", true);
							$('#diaPagoInteres2').attr("checked", false);
							$('#diaMesInteres').val(diaSucursal);

						} else {
							$('#diaPagoInteres1').attr("checked", true);
							$('#diaPagoInteres2').attr("checked", false);
							$('#diaMesInteres').val('');
						}

						habilitaControl('periodicidadInt');
						habilitaControl('numAmortInteres');

					} else {

						if ($('#frecuenciaInt').val() == 'U') {
							$('#numAmortInteres').val("1");
							deshabilitaControl('numAmortInteres');
							$('#periodicidadInt').val($('#noDias').val());

							if ($('#diaPagoInteres1').is(':checked')) {
								$('#diaPagoInteres1').attr("checked", true);
								$('#diaPagoInteres2').attr("checked", false);
								$('#diaMesInteres').val("");

							} else {
								if ($('#diaPagoInteres2').is(':checked')) {
									$('#diaPagoInteres2').attr("checked", true);
									$('#diaPagoInteres1').attr("checked", false);
									$('#diaMesInteres').val(diaSucursal);

								}

							}

						} else {
							habilitaControl('numAmortInteres');
							if ($('#diaPagoInteres1').is(':checked')) {
								$('#diaPagoInteres1').attr("checked", true);
								$('#diaPagoInteres2').attr("checked", false);
								$('#diaPagoInteres').val('F');
								$('#diaMesInteres').val("");

							} else {
								if ($('#diaPagoInteres2').is(':checked')) {
									$('#diaPagoInteres1').attr("checked", false);
									$('#diaPagoInteres2').attr("checked", true);
									$('#diaPagoInteres').val('D');
									$('#diaMesInteres').val(diaSucursal);
								}

							}
						}
					}
				}

				// solo si el producto de credito indica que el dia de pago es Indistinto
				if ($('#diaPagoProd').val() == 'I' && $('#diaPagoInteres2').is(':checked')) {
					habilitaControl('diaMesInteres');
					habilitaControl('diaPagoInteres1');
					habilitaControl('diaPagoInteres2');
				}
				// solo si el producto de credito indica que el dia de pago es Dia del mes

				if ($('#diaPagoProd').val() == 'D') {
					habilitaControl('diaMesInteres');
				}

			} else { // SI IGUALA CALENDARIOS (Interes con Capital)

				igualarCalendarioInteresCapital();
				deshabilitarCalendarioPagosInteres();
			}
			break;

	}
	validarEsquemaCobroSeguro();
} // FIN validarEventoFrecuencia()

//asigna en dias la periodicidad, dependiendo de la frecuencia seleccionada
function validaPeriodicidad() {
	switch ($('#frecuenciaCap').val()) {
		case "S" : // SI ES SEMANAL
			$('#periodicidadCap').val('7');
			break;
		case "D" : // SI ES DECENAL
			$('#periodicidadCap').val('10');
			break;
		case "C" : // SI ES CATORCENAL
			$('#periodicidadCap').val('14');
			break;
		case "Q" : // SI ES QUINCENAL
			$('#periodicidadCap').val('15');
			break;
		case "M" : // SI ES MENSUAL
			$('#periodicidadCap').val('30');
			break;
		case "B" : // SI ES BIMESTRAL
			$('#periodicidadCap').val('60');
			break;
		case "T" : // SI ES TRIMESTRAL
			$('#periodicidadCap').val('90');
			break;
		case "R" : // SI ES TETRAMESTRAL
			$('#periodicidadCap').val('120');
			break;
		case "E" : // SI ES SEMANAL
			$('#periodicidadCap').val('180');
			break;
		case "A" : // SI ES ANUAL
			$('#periodicidadCap').val('360');
			break;
		case "L" : // SI ES LIBRE
			$('#periodicidadCap').val('');
			break;
		case "P" : // SI ES PERIODO
			$('#periodicidadCap').val($("#noDias").val());
			break;
		case "U" : // SI ES UNICO
			$('#periodicidadCap').val($("#noDias").val());
			break;
		default : // SI ES DEFAULT
			$('#periodicidadCap').val('');
		break;
	}

	switch ($('#frecuenciaInt').val()) {
		case "S" : // SI ES SEMANAL
			$('#periodicidadInt').val('7');
			break;
		case "D" : // SI ES DECNAL
			$('#periodicidadInt').val('10');
			break;
		case "C" : // SI ES CATORCENAL
			$('#periodicidadInt').val('14');
			break;
		case "Q" : // SI ES QUINCENAL
			$('#periodicidadInt').val('15');
			break;
		case "M" : // SI ES MENSUAL
			$('#periodicidadInt').val('30');
			break;
		case "B" : // SI ES BIMESTRAL
			$('#periodicidadInt').val('60');
			break;
		case "T" : // SI ES TRIMESTRAL
			$('#periodicidadInt').val('90');
			break;
		case "R" : // SI ES TETRAMESTRAL
			$('#periodicidadInt').val('120');
			break;
		case "E" : // SI ES SEMANAL
			$('#periodicidadInt').val('180');
			break;
		case "A" : // SI ES ANUAL
			$('#periodicidadInt').val('360');
			break;
		case "L" : // SI ES LIBRE
			$('#periodicidadInt').val('');
			break;
		case "P" : // SI ES PERIODO
			$('#periodicidadInt').val($("#noDias").val());
			break;
		case "U" : // SI ES UNICO
			$('#periodicidadInt').val($("#noDias").val());
			break;
		default : // DEFAULT
			$('#periodicidadInt').val('');
		break;
	}
} // FIN validaPeriodicidad()

//funcion para deshabilitar la seccion del calendario de  pagos que corresponde con interes
function deshabilitarCalendarioPagosInteres() {
	deshabilitaControl('numAmortInteres');
	deshabilitaControl('frecuenciaInt');

	deshabilitaControl('periodicidadInt');

	if ($('#diaPagoProd').val() != 'I' || $('#perIgual').val() == 'S') {
		deshabilitaControl('diaPagoInteres1');
		deshabilitaControl('diaPagoInteres2');
	}

	if ($('#diaPagoProd').val() != 'D' || $('#perIgual').val() == 'S') {
		deshabilitaControl('diaMesInteres');
	}
}

//funcion para habilitar la seccion del calendario de pagos que corresponde con interes
function habilitarCalendarioPagosInteres() {
	habilitaControl('frecuenciaInt');
	habilitaControl('numAmortInteres');

	if ($('#diaPagoProd').val() == 'I' && $('#perIgual').val() != 'S' && $("#tipoPagoCapital").val() != 'C') {
		habilitaControl('diaPagoInteres1');
		habilitaControl('diaPagoInteres2');
	}
	if (($('#diaPagoProd').val() == 'D' || ($('#diaPagoProd').val() == 'I' && $('#diaPagoInteres2').is(':checked'))) && $('#perIgual').val() != 'S' && $("#tipoPagoCapital").val() != 'C') {
		habilitaControl('diaMesInteres');
	}

	if ($("#frecuenciaInt").val() == 'P' && $('#perIgual').val() != 'S' && $("#tipoPagoCapital").val() != 'C') {
		habilitaControl('periodicidadInt');
	}

}

//valida que los datos que se requieren para generar el simulador de amortizaciones esten indicados.
function validaDatosSimulador() {
	if ($.trim($('#productoCreditoID').val()) == "") {
		mensajeSis("Producto De Crédito Vací­o");
		$('#productoCreditoID').focus();
		datosCompletos = false;
	} else {
		if ($.trim($('#clienteID').asNumber()) <= "0" && $.trim($('#prospectoID').asNumber()) <= "0") {
			mensajeSis("Especificar " + $('#alertSocio').val() + " o Prospecto.");
			$('#prospectoID').focus();
			datosCompletos = false;
		} else {
			if ($('#fechaInicioAmor').val() == '') {
				mensajeSis("Fecha de Inicio Amotización Vacía");
				$('#fechaInicioAmor').focus();
				datosCompletos = false;
			} else {
				if ($('#fechaVencimiento').val() == '') {
					mensajeSis("Fecha de Vencimiento Vacía");
					$('#fechaVencimiento').focus();
					datosCompletos = false;
				} else {
					if ($('#tipoPagoCapital').val() == '') {
						mensajeSis("El Tipo de Pago de Capital Está Vací­o.");
						$('#tipoPagoCapital').focus();
						datosCompletos = false;
					} else {
						if ($('#frecuenciaCap').val() == 'U' && $('#tipoPagoCapital').val() != 'I') {
							mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
							$('#tipoPagoCapital').focus();
							datosCompletos = false;
						} else {
							/* se valida que si el tipo de pago de capital es libre, no se pueda escoger como frecuencia la opcion de libre */
							if ($('#frecuenciaInt').val() == "L" && $('#calendIrregular').val() == "N") {
								mensajeSis("La Frecuencia de Interés Libre sólo Aplica para Calendario Irregular.");
								$('#frecuenciaInt').focus();
								$('#frecuenciaInt').val("");
								datosCompletos = false;
							} else {
								if ($('#frecuenciaCap').val() == "L" && $('#calendIrregular').val() == "N") {
									mensajeSis("La Frecuencia de Capital Libre sólo Aplica para Calendario Irregular.");
									$('#frecuenciaCap').focus();
									$('#frecuenciaCap').val("");
									datosCompletos = false;
								} else {
									if ($('#calcInteresID').val() != "") {
										if ($('#calcInteresID').val() == '1') {
											if ($('#tasaFija').val() == '' || $('#tasaFija').val() == '0') {
												mensajeSis("Tasa de Interés Vací­a.");
												$('#tasaFija').focus();
												datosCompletos = false;
											} else {
												if ($('#montoSolici').asNumber() <= "0") {
													mensajeSis("El Monto Está Vacío.");
													$('#montoSolici').focus();
													datosCompletos = false;
												} else {
													datosCompletos = true;
												}
											}
										} else {
											if ($('#calcInteresID').val() == '2' || $('#calcInteresID').val() == '3' || $('#calcInteresID').val() == '4') {

												if ($('#tasaBase').val() == '' || $('#desTasaBase').val() == '') {
													mensajeSis("Tasa Base de Interés Vací­a.");
													$('#tasaBase').focus();
													datosCompletos = false;
												} else {
													if ($('#sobreTasa').val() == '') {
														mensajeSis("Sobre Tasa de Interés Vací­a.");
														$('#sobreTasa').focus();
														datosCompletos = false;
													} else {
														if ($('#calcInteresID').val() == '3') {
															if ($('#techoTasa').val() == '') {
																mensajeSis("Techo de Tasa Base de Interés Vací­a.");
																$('#techoTasa').focus();
																datosCompletos = false;
															} else {
																if ($('#pisoTasa').val() == '') {
																	mensajeSis("Piso de Tasa Base de Interés Vací­a.");
																	$('#pisoTasa').focus();
																	datosCompletos = false;
																} else {
																	datosCompletos = true;
																}
															}
														} else {
															datosCompletos = true;
														}
													}

												}
											}
										}
									} else {
										mensajeSis("Seleccionar Tipo Cal. Interés.");
										$('#calcInteresID').focus();
										datosCompletos = false;
									}
								}
							}
						}
					}
				}
			}
		}
	}
	return datosCompletos;
}

//llamada al sp que consulta el simulador de amortizaciones
function consultaSimulador() {
	var fechaIni = $('#fechaInicioAmor').val();
	$('#fechaInicio').val(fechaIni);

	if ((Date.parse($('#fechaInicioAmor').val())) < (Date.parse(parametroBean.fechaAplicacion))) {
		$('#fechaInicioAmor').val(parametroBean.fechaAplicacion);
		var fechaIni = $('#fechaInicioAmor').val();
		$('#fechaInicio').val(fechaIni);
	}
	estatusSimulacion = true;
	var params = {};
	tipoLista = 7;

	if ($('#tipoPagoCapital').val() == 'L' & ($('#frecuenciaCap').val() == "D" || $('#frecuenciaInt').val() == "D")) {
		mensajeSis("No se permiten Frecuencias Decenales con pagos de Capital Libres");
		$('#frecuenciaInt').val('S');
		$('#frecuenciaCap').val('S');
		return false;
	}

	if ($('#diaPagoCapital1').is(':checked')) {
		auxDiaPagoCapital = "F";
	} else {
		auxDiaPagoCapital = "D";
	}
	if ($('#diaPagoInteres1').is(':checked')) {
		auxDiaPagoInteres = "F";
	} else {
		auxDiaPagoInteres = "D";
	}

	if (numTransaccionInicGrupo != undefined && numTransaccionInicGrupo != null && numTransaccionInicGrupo != 0 && tipoOperacionGrupo == tipoOperacion.noFormal) {
		params['tipoLista'] = 13;
		params['numTransacSim'] = numTransaccionInicGrupo;
	} else if(tipoOperacionGrupo == tipoOperacion.noFormal){
		params['tipoLista'] = 14;
		params['numTransacSim'] = $('#numTransacSim').asNumber();
	}
	else {
		params['tipoLista'] = tipoLista;
		params['numTransacSim'] = $('#numTransacSim').asNumber();
	}
	params['cobraSeguroCuota'] = $('#cobraSeguroCuota option:selected').val();
	params['cobraIVASeguroCuota'] = $('#cobraIVASeguroCuota option:selected').val();
	params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();

	bloquearPantalla();
	var numeroError = 0;
	var mensajeTransaccion = "";

	$.post("lisSimuladorLibresAgroConsulta.htm", params, function(data) {
		if (data.length > 0 || data != null) {
			$('#contenedorSimuladorLibre').html(data);
			if ($("#numeroErrorList").length) {
				numeroError = $('#numeroErrorList').asNumber();
				mensajeTransaccion = $('#mensajeErrorList').val();
			}
			if (numeroError == 0) {
				$('#contenedorSimuladorLibre').show();
				$('#contenedorSimulador').html("");
				$('#contenedorSimulador').hide();
				$('#totalCap').val(totalizaCap());
				$('#totalInt').val(totalizaInt());
				$('#totalIva').val(totalizaIva());
				$('#totalCap').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				$('#totalInt').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				$('#totalIva').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				var idLastFechaVen = $('#TablaAmortizaLibresBody >tr:last').find("input[name^='fechaVencim']").attr("id");
				var fechaVencAmor = $('#'+idLastFechaVen).val();
				$('#fechaVencimiento').val(fechaVencAmor);
			}
		} else {
			$('#contenedorSimuladorLibre').html("");
			$('#contenedorSimuladorLibre').hide();
			$('#contenedorSimulador').html("");
			$('#contenedorSimulador').hide();
		}
		$('#contenedorForma').unblock();
		/****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
		if (numeroError != 0) {
			$('#contenedorForma').unblock({
				fadeOut : 0,
				timeout : 0
			});
			mensajeSisError(numeroError, mensajeTransaccion);
		}
		/**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
	});

}// fin funcion consultaSimulador()

//Consulta total de filas del grid
function consultaFilas() {
	var totales = 0;
	$('tr[name=renglon]').each(function() {
		totales++;
	});
	return totales;
}

//-------------------- FUNCIONES PARA SECCION DE CALENDARIO DE PAGOS ----------------------------------

//consulta el tipo de integrante de la solicitud de credito
function consultaTipoIntegrante() {
	var solicitud = $('#solicitudCreditoID').val();
	var grupoInteGruBeanCon = {
		'solicitudCreditoID' : solicitud
	};
	var listaIntegrante = 3;
	setTimeout("$('#cajaLista').hide();", 200);
	if (solicitud != '' && !isNaN(solicitud) && esTab) {
		integraGruposServicio.consulta(listaIntegrante, grupoInteGruBeanCon, function(integrantes) {
			if (integrantes != null) {
				$('#tipoIntegrante').val(integrantes.cargo);
			}
		});
	}
}

//funcion consulta de grupos
function consultaGrupo(idControl) {
	var jqGrupo = eval("'#" + idControl + "'");
	var grupo = $(jqGrupo).val();
	var grupoBeanCon = {
		'grupoID' : grupo
	};
	setTimeout("$('#cajaLista').hide();", 200);
	tipoOperacionGrupo = '';
	if (grupo != '' && !isNaN(grupo)) {
		gruposCreditoServicio.consulta(15, grupoBeanCon, {
			callback : function(grupos) {
					if (grupos != null) {
						esTab = true;
						$('#nombreGr').val(grupos.nombreGrupo);
						tipoOperacionGrupo=grupos.tipoOperacion;
						//aqui se  obtiene  el grupo  de  consulta  para individual
						sgrupo = grupo;
						if ($('#grupoID').val() == undefined && productoIDBase > 0 && (clienteIDBase > 0 || prospectoIDBase > 0)) {
							consultacicloCliente();
						}
					} else {
						if ($('#grupoID').val() != 0 && $('#grupoID').val() != '') {
							mensajeSis("El Grupo no Existe");
							$('#nombreGr').val("");
							$('#tipoIntegrante').val("4");
							$(jqGrupo).focus();
							grupoIDBase = 0;
						}
					}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error al Consultar Grupo.<br>" + message + ":" + exception);
			}
		});
	}
}

/**
 * funcion para consultar una solicitud de credito
 * @param idControl
 * @returns
 */
function validaSolicitudCredito(idControl) {
	var jqSolicitud = eval("'#" + idControl + "'");
	var solCred = $(jqSolicitud).val();
	setTimeout("$('#cajaLista').hide();", 200);
	if($('#solicitudCre1').asNumber()>0 && $('#solicitudCre1').asNumber() != $('#solicitudCreditoID').asNumber() && $('#solicitudCreditoID').asNumber()>0){
		deshabilitaControl('tipoFondeo2');
		deshabilitaControl('tipoFondeo');
		deshabilitaControl('lineaFondeoID');
	}
	if (solCred != '' && !isNaN(solCred) && esTab) {
		inicializaValoresNuevaSolicitud();
		if (solCred == '0') {
			// se trata de una solicitud de credito nueva
			habilitaInputsSolGrupal(); // Funcion que Deshabilita los inputs de la  solicitud Grupal > 0 para que no se queden deshabilitados
			if ($('#grupo').asNumber()>0) {
				if ($('#solicitudCre1').asNumber() > 0) {
					consultaValoresPrimeraSolicitudGrupal($('#solicitudCre1').asNumber());
					deshabilitaInputsSolGrupal();// Deshabilita los inputs  de la Solicitud	 grupal  si la  solicitud no es  la primera
				}
			}
			//Asigna valor defeult consulta SIC
			consultaSICParam();
		} else {
			var SolCredBeanCon = {
				'solicitudCreditoID' : solCred,
				'usuario' : usuario
			};
			mostrarElementoPorClase('ocultarSeguroCuota', "N");
			solicitudCredServicio.consulta(catTipoConsultaSolicitud.agropecuario, SolCredBeanCon, {
				callback : function(solicitud) {
					if (solicitud != null && solicitud.solicitudCreditoID != 0) {
						if( solicitud.esConsolidacionAgro != 'N'){
							solicitudPromotor = solicitud.promotorID;
							$('#montoSeguroVida').val(solicitud.montoSeguroVida);
							mostrarElementoPorClase('ocultarSeguroCuota', solicitud.cobraSeguroCuota);

							if (solicitud.forCobroSegVida != '') {
								consultaTiposPago(solicitud.productoCreditoID, esquemaSeguro, solicitud.forCobroSegVida);
							}
							if ($('#grupo').val() != solicitud.grupoID && $('#grupo').val() != undefined) {
								mensajeSis("La solicitud " + solCred + ", no pertenece \n al grupo: " + $('#nombreGrupo').val());
								$('#solicitudCreditoID').val("");
								$('#solicitudCreditoID').focus();
							} else {

								esTab = true;
								dwr.util.setValues(solicitud);
								deshabilitaCampoLinea();
								consultaTiposLineasAgro(solicitud.productoCreditoID, 2);
								seccionCalendarioLibreAgro(solicitud.tipoPagoCapital);
								$("#fechaInicio").val(solicitud.fechaInicio);
								$('#fechaInicioAmor').val(solicitud.fechaInicioAmor);
								$('#fechaDesembolso').val(solicitud.fechaDesembolso);

								if (solicitud.calcInteresID == '2' || solicitud.calcInteresID == '3' || solicitud.calcInteresID == '4') {
									consultaTasaBase('tasaBase', false);
								}

								consultaCambiaPromotor();

								consultaCadenaProductiva();
								consultaRamaFIRA();
								consultaSubRamaFIRA();
								consultaActividadFIRA();
								consultProgramaFira();

								// se asignan valores Base
								montoComApeBase = solicitud.montoComApert;
								montoIvaComApeBase = solicitud.ivaComApert;
								clienteIDBase = solicitud.clienteID;
								productoIDBase = solicitud.productoCreditoID;
								prospectoIDBase = solicitud.prospectoID;
								grupoIDBase = solicitud.grupoID;
								solicitudIDBase = solicitud.solicitudCreditoID;
								plazoBase = solicitud.plazoID;
								fechaVencimientoInicial = "";
								requiereSeg = "";

								tipoPagoSeg = solicitud.forCobroSegVida; //tipo de pago del monto de seguro de vida
								prodCredito = solicitud.productoCreditoID;

								if (solicitud.forCobroComAper == 'F') {
									$('#formaComApertura').val(financiado); ///XXXX

								} else {
									if (solicitud.forCobroComAper == 'D') {
										$('#formaComApertura').val(deduccion);
									} else {
										if (solicitud.forCobroComAper == 'A') {
											$('#formaComApertura').val(anticipado);
										} else {
											if (solicitud.forCobroComAper == 'P') {
												$('#formaComApertura').val(programado);
											}
										}
									}
								}

								// forma de pago del seguro de vida

								if (modalidad == 'U') {
									if (solicitud.forCobroSegVida == 'F') {
										$('#tipoPagoSeguro').val(financiado); //XXXXX

									} else {
										if (solicitud.forCobroSegVida == 'D') {
											$('#tipoPagoSeguro').val(deduccion);
										} else {
											if (solicitud.forCobroSegVida == 'A') {
												$('#tipoPagoSeguro').val(anticipado);
											}
										}
									}
								} else {
									if (modalidad == 'T') {
										calculaNodeDias(solicitud.fechaVencimiento);
										if (solicitud.forCobroSegVida == 'F') {
											$('#tipPago').val('F');
										} else {
											if (solicitud.forCobroSegVida == 'D') {
												$('#tipPago').val('D');
											} else {
												if (solicitud.forCobroSegVida == 'A') {
													$('#tipPago').val('A');
												} else {

													if (solicitud.forCobroSegVida == 'O') {
														$('#tipPago').val('O');
													}
												}
											}
										}

										consultaEsquemaSeguroVidaForanea(solicitud.forCobroSegVida);
									}
								}

								if (solicitud.forCobroSegVida == 'A') {
									montoSolicitudBase = solicitud.montoSolici;
								} else {
									if (solicitud.forCobroSegVida == 'D') {
										montoSolicitudBase = solicitud.montoSolici;
									} else {
										if (solicitud.forCobroSegVida == 'F') {
											montoSolicitudBase = solicitud.montoSolici - solicitud.montoSeguroVida;
										} else {

											montoSolicitudBase = solicitud.montoSolici;
										}
									}
								}

								if (solicitud.forCobroComAper == 'D') {
									montoSolicitudBase = montoSolicitudBase;
								} else {
									if (solicitud.forCobroComAper == 'F') {
										montoSolicitudBase = montoSolicitudBase - solicitud.montoComApert - solicitud.ivaComApert;
									} else {
										montoSolicitudBase = montoSolicitudBase;
									}
								}
								montoOriginalSolicitud = montoSolicitudBase;

								montoComIvaSol = solicitud.montoSolici;
								$('#fechaVencimiento').val(solicitud.fechaVencimiento);
								fechaVencimientoInicial = solicitud.fechaVencimiento;
								$('#productoCreditoID').val(solicitud.productoCreditoID);
								$('#aporteCliente').val(solicitud.aporteCliente);
								$('#aporteCliente').formatCurrency({
									positiveFormat : '%n',
									roundToDecimalPlace : 2
								});
								$('#grupoID').val(solicitud.grupoID);

								setCalcInteresID(solicitud.calcInteresID, false);
								$('#tipoCalInteres').val(solicitud.tipoCalInteres).selected = true;

								if (solicitud.calendIrregular == 'S') {
									$('#calendIrregularCheck').attr("checked", "true");
									$('#calendIrregular').val("S");
									deshabilitaControl('tipoPagoCapital');
									deshabilitaControl('frecuenciaInt');
									deshabilitaControl('frecuenciaCap');
									deshabilitaControl('numAmortizacion');
									deshabilitaControl('numAmortInteres');
								} else {
									$('#calendIrregularCheck').attr("checked", false);
									$('#calendIrregular').val("N");
									habilitaControl('tipoPagoCapital');
									deshabilitaControl('frecuenciaInt');
									habilitaControl('frecuenciaCap');
									habilitaControl('numAmortizacion');
									if (solicitud.tipoPagoCapital == 'C' || $('#perIgual').val() == 'S') {
										deshabilitaControl('numAmortInteres');
									} else {
										habilitaControl('numAmortInteres');
									}
								}

								if (solicitud.fechInhabil == 'S') {
									$('#fechInhabil').val("S");
									$('#fechInhabil1').attr('checked', true);
									$('#fechInhabil2').attr("checked", false);
								} else {
									$('#fechInhabil2').attr('checked', true);
									$('#fechInhabil1').attr("checked", false);
									$('#fechInhabil').val("A");
								}

								$('#ajusFecExiVen').val("N");
								$('#ajFecUlAmoVen').val("N");

								$('#diaMesCapital').val(solicitud.diaMesCapital);
								$('#diaMesInteres').val(solicitud.diaMesInteres);

								if (solicitud.diaPagoCapital == 'F') {
									$('#diaPagoCapital1').attr('checked', true);
									$('#diaPagoCapital2').attr('checked', false);
								} else {
									$('#diaPagoCapital2').attr('checked', true);
									$('#diaPagoCapital1').attr('checked', false);
								}
								$('#diaPagoCapital').val(solicitud.diaPagoCapital);
								$('#diaPagoProd').val(solicitud.diaPagoCapital);

								if (solicitud.diaPagoInteres == 'F') {
									$('#diaPagoInteres1').attr('checked', true);
									$('#diaPagoInteres2').attr('checked', false);
								} else {
									$('#diaPagoInteres1').attr('checked', false);
									$('#diaPagoInteres2').attr('checked', true);
								}
								$('#diaPagoInteres').val(solicitud.diaPagoInteres);

								consultaCalendarioPorProductoSolicitud(solicitud.productoCreditoID, solicitud.tipoPagoCapital, solicitud.frecuenciaCap, solicitud.frecuenciaInt, solicitud.plazoID, solicitud.tipoDispersion);
								productoCreditoGuardado = solicitud.productoCreditoID;
								consultaProducCreditoForanea(solicitud.productoCreditoID, 'no');

								consultaBeneficiario('solicitudCreditoID');
								calculaTasa = 'N';
								consultaCliente(solicitud.clienteID, calculaTasa);
								consultaProspecto('prospectoID');

								consultaDestinoCreditoSolicitud('destinoCreID');

								$('#factorRiesgoSeguro').val(solicitud.factorRiesgoSeguro);
								$('#forCobroSegVida').val(solicitud.tipoPagoSeguro);
								$('#montoPolSegVida').val(solicitud.montoPolSegVida);

								if (modalidad == 'U') {
									if (solicitud.forCobroSegVida == 'F') {
										$('#tipoPagoSeguro').val(financiado);
									} else {
										if (solicitud.forCobroSegVida == 'D') {
											$('#tipoPagoSeguro').val(deduccion);
										} else {
											if (solicitud.forCobroSegVida == 'A') {
												$('#tipoPagoSeguro').val(anticipado);
											}
										}
									}

								} else {
									if (modalidad == 'T') {
										if (solicitud.forCobroSegVida == 'F') {
											$('#tipPago').val('F');
										} else {
											if (solicitud.forCobroSegVida == 'D') {
												$('#tipPago').val('D');

											} else {
												if (solicitud.forCobroSegVida == 'A') {
													$('#tipPago').val('A');
												} else {
													if (solicitud.forCobroSegVida == 'O') {
														$('#tipPago').val('O');
													}
												}
											}
										}
									}
								}// termina condicion de modalidad
								$('#lineaFondeoID').val(solicitud.lineaFondeoID);
								$('#institutFondID').val(solicitud.institutFondID);
								consultaInstitucionFondeo('institutFondID');
								consultaLineaFondeo('lineaFondeoID');

								consultaDeudorOriginal(solicitud.deudorOriginalID);

								if (solicitud.tipoFondeo == "P") {
									$('#tipoFondeo').attr('checked', true);
									$('#tipoFondeo2').attr("checked", false);
									deshabilitaControl('lineaFondeoID');
									deshabilitaControl('tasaPasiva');
									$('#acreditadoIDFIRA').val("");
									$('#creditoIDFIRA').val("");
									mostrarElementoPorClase('mostrarAcredFIRA', false);
									mostrarElementoPorClase('mostrarAcred', false);
									mostrarElementoPorClase('mostrarCred', false);
								} else {
									if (solicitud.tipoFondeo == "F") {
										$('#tipoFondeo2').attr('checked', true);
										$('#tipoFondeo').attr("checked", false);
										if($('#solicitudCre1').asNumber()>0 && $('#solicitudCre1').asNumber() != $('#solicitudCreditoID').asNumber() && $('#solicitudCreditoID').asNumber()>0){
											habilitaControl('lineaFondeoID');
										} else {
										habilitaControl('lineaFondeoID');
										}
										habilitaControl('tasaPasiva');
									}
								}

								if (solicitud.clasifiDestinCred == Comercial) {
									$('#clasificacionDestin1').attr("checked", true);
									$('#clasificacionDestin2').attr("checked", false);
									$('#clasificacionDestin3').attr("checked", false);
									$('#clasifiDestinCred').val('C');
								} else if (solicitud.clasifiDestinCred == Consumo) {
									$('#clasificacionDestin1').attr("checked", false);
									$('#clasificacionDestin2').attr("checked", true);
									$('#clasificacionDestin3').attr("checked", false);
									$('#clasifiDestinCred').val('O');
								} else {
									$('#clasificacionDestin1').attr("checked", false);
									$('#clasificacionDestin2').attr("checked", false);
									$('#clasificacionDestin3').attr("checked", true);
									$('#clasifiDestinCred').val('H');
								}

								if ($('#grupo').val() != undefined || (solicitud.grupoID > 0 && solicitud.grupoID != "" && solicitud.grupoID != null)) {
									consultaGrupo('grupoID');
									consultaTipoIntegrante();
								}
								$('#montoSolici').formatCurrency({
									positiveFormat : '%n',
									roundToDecimalPlace : 2
								});
								$('#montoAutorizado').formatCurrency({
									positiveFormat : '%n',
									roundToDecimalPlace : 2
								});
								$('#montoAutorizado').formatCurrency({
									positiveFormat : '%n',
									roundToDecimalPlace : 2
								});
								$('#montoCuota').formatCurrency({
									positiveFormat : '%n',
									roundToDecimalPlace : 2
								});

								$('#CAT').formatCurrency({
									positiveFormat : '%n',
									roundToDecimalPlace : 1
								});

								// valida que el comentario de ejecutivo contenga informacion para mostrarlo
								if (solicitud.comentarioEjecutivo != "" && solicitud.comentarioEjecutivo != null) {
									$('#comentariosEjecutivo').show();
									$('#separa').show(); // separador
								} else {
									$('#comentariosEjecutivo').hide();
									$('#separa').hide();
								}
								// se utiliza  para  saber cuando se agrega  o  quita  una cuota
								NumCuotas = solicitud.numAmortizacion;
								NumCuotasInt = solicitud.numAmortInteres;

								//validaciones para consultaSIC
								if (solicitud.tipoConsultaSIC != "" && solicitud.tipoConsultaSIC != null) {
									$('#comentariosEjecutivo').show();
									if (solicitud.tipoConsultaSIC == "BC") {
										$('#tipoConsultaSICBuro').attr("checked", true);
										$('#tipoConsultaSICCirculo').attr("checked", false);
										$('#consultaBuro').show();
										$('#consultaCirculo').hide();
										$('#folioConsultaCC').val('');
									} else if (solicitud.tipoConsultaSIC == "CC") {
										$('#tipoConsultaSICBuro').attr("checked", false);
										$('#tipoConsultaSICCirculo').attr("checked", true);
										$('#consultaBuro').hide();
										$('#consultaCirculo').show();
										$('#folioConsultaBC').val('');
									}
								} else {
									//mostrar por defecto valor de parametrossis
									consultaSICParam();
								}

								if (solicitud.estatus != 'I') {
									if (solicitud.estatus == 'A' || solicitud.estatus == 'D' || solicitud.estatus == 'L' || solicitud.estatus == 'C') {
										deshabilitaBoton('modificar', 'submit');
										deshabilitaBoton('liberar', 'submit');
										deshabilitaBoton('agregar', 'submit');
										deshabilitaBoton('agregaConsolidacion', 'submit');
										$('#simular').hide();
										$('#fechaInicio').val(solicitud.fechaInicio);
										$('#fechaInicioAmor').val(solicitud.fechaInicioAmor);
										$('#fechaDesembolso').val(solicitud.fechaDesembolso);
										deshabilitaControl('direccionBen');
										deshabilitaControl('beneficiario');
										deshabilitaControl('parentescoID');
										deshabilitaControl('parentesco');
										deshabilitaControl('tipPago');
										deshabilitaControl('deudorOriginalID');


									}
									deshabilitaInputs();
								} else {
									// si la solicitud es inactiva valida que el promotor pueda liberar la solicitud de credito si corresponde
									// con la sucursal o si el promotor no atiende sucursal
									$('#sucursalPromotor').val(solicitud.sucursalPromotor);
									$('#promAtiendeSuc').val(solicitud.promAtiendeSuc);
									habilitaControl('tipPago');
									if (solicitud.sucursalID == solicitud.sucursalPromotor || solicitud.promAtiendeSuc == 'N') {
										// si se  trata de una solicitud individual entonces se muestra y habilita el boton de liberar,
										// en caso contrario se oculta si se trata de una solicitud individual entonces se muestra el
										// div de comentarios, en caso contrario se oculta
										if ($('#grupo').val() != undefined) {
											deshabilitaBoton('liberar', 'submit');
											$('#liberar').hide();
											$('#comentarios').hide();
											$('#comentario').hide();
											funcionMuestraDivGrupo();
										} else {
											if ($('#flujoIndividualBandera').val() == undefined) {
												habilitaBoton('liberar', 'submit');
												$('#liberar').show();
												$('#comentarios').show();
												$('#comentario').show();
												funcionOcultaDivGrupo();
											} else {
												deshabilitaBoton('liberar', 'submit');
												$('#liberar').hide();
												$('#comentarios').show();
												$('#comentario').show();
												funcionOcultaDivGrupo();
											}
										}

										habilitaBoton('modificar', 'submit');
										habilitaBoton('agregaConsolidacion', 'submit');
										deshabilitaBoton('agregar', 'submit');
										habilitaInputsAutorizada();
										$('#simular').show();
										if ((Date.parse($('#fechaInicioAmor').val())) < (Date.parse(parametroBean.fechaAplicacion))) {
											$('#fechaInicioAmor').val(parametroBean.fechaAplicacion);
										}

										habilitaControlesSolicitudInactiva();

										// valida que no se pueda cambiar el grupo en la solicitud cuando es modificación
										if ($('#grupo').val() != undefined) {
											deshabilitaControl('productoCreditoID');
											deshabilitaControl('grupoID');
											deshabilitaControl('tipoIntegrante');
											deshabilitaControl('lineaFondeoID');
											deshabilitaControl('tasaPasiva');
										} else {
											habilitaControl('productoCreditoID');
											habilitaControl('grupoID');
											deshabilitaControl('tipoIntegrante');
											habilitaControl('lineaFondeoID');
											habilitaControl('tasaPasiva');
										}
										habilitaControl('direccionBen');
										habilitaControl('beneficiario');
										habilitaControl('parentescoID');

									} else {
										deshabilitaBoton('liberar', 'submit');
										deshabilitaBoton('modificar', 'submit');
										deshabilitaBoton('agregar', 'submit');
										deshabilitaBoton('agregaConsolidacion', 'submit');
										mensajeSis("El promotor que atiende la sucursal, no corresponde con la sucursal de la Solicitud");
										$('#promotorID').focus();
										deshabilitaInputs();
										return;
									}
								}


							}
							if ($('#grupo').val() != undefined || (solicitud.grupoID > 0 && solicitud.grupoID != "" && solicitud.grupoID != null)) {
								consultaMinistracionesGrupales(solicitud.solicitudCreditoID);
							} else {
								consultaMinistracionesconsolidadas(solicitud.estatus);
								$('#fechaPagoMinis1').val(solicitud.fechaInicio);
							}

							crearTablaTemporal(solCred);
							$("#creditoID").val('');

							if (solicitud.estatus != 'I') {
								deshabilitaInputs();
							}

							$('#fechaPagoMinis1').val(solicitud.fechaInicio);

							if(solicitud.lineaCreditoID > 0){
								$('#lineaCreditoID').val(solicitud.lineaCreditoID);
								consultaLineasCreditoAgro('lineaCreditoID');

								$('#manejaComAdmon').val(solicitud.manejaComAdmon);
								$('#forPagComAdmon').val(solicitud.forPagComAdmon);
								$('#porcentajeComAdmon').val(solicitud.porcentajeComAdmon);

								$('#manejaComGarantia').val(solicitud.manejaComGarantia);
								$('#porcentajeComGarantia').val(solicitud.porcentajeComGarantia);
								$('#forPagComGarantia').val(solicitud.forPagComGarantia);

								$('#comAdmonLinPrevLiq').val("N");
								$('#comGarLinPrevLiq').val("N");

								if( solicitud.comAdmonLinPrevLiq == 'S' ) {
									$('#comAdmonLinPrevLiq').val("S");
									$('#comAdmonLinPrevLiq').attr("checked", true);
									$('#cobroComAdmon').hide();
									if($('#manejaComAdmon').val() == 'N'){
										deshabilitaControl('comAdmonLinPrevLiq');
									}
								}

								if( solicitud.comGarLinPrevLiq == 'S' ) {
									$('#comGarLinPrevLiq').val("S");
									$('#comGarLinPrevLiq').attr("checked", true);
									$('#cobroComGarantia').hide();
									if($('#manejaComGarantia').val() == 'N'){
										deshabilitaControl('comGarLinPrevLiq');
									}
								}

								if($('#manejaComAdmon').val() == 'S'){
									$('#montoPagComAdmon').val(solicitud.montoPagComAdmon);
									$('#cobroComAdmon').show();
									if( solicitud.comAdmonLinPrevLiq == 'S' ) {
										$('#cobroComAdmon').hide();
									}
								} else {
									$('#cobroComAdmon').hide();
									deshabilitaControl('forPagComAdmon');
									deshabilitaControl('comAdmonLinPrevLiq');
									$('#montoPagComAdmon').val(0.00);
								}

								if($('#manejaComGarantia').val() == 'S'){
									$('#montoComGarantia').val(solicitud.montoPagComGarantia);
									$('#cobroComGarantia').show();
									if( solicitud.comGarLinPrevLiq == 'S' ) {
										$('#cobroComGarantia').hide();
									}
								} else {
									$('#cobroComGarantia').hide();
									deshabilitaControl('forPagComGarantia');
									deshabilitaControl('comGarLinPrevLiq');
									$('#montoComGarantia').val(0.00);
								}

								if(manejaComAdmon == 'S'){
									habilitaControl('manejaComAdmon');
									var montoPagComAdmon = 0.00;
									var montoComisiones = 0.00;
									var montoIVAPagComAdmon = 0.00;

									switch(forCobComAdmon){
										case cat_ForCobComisiones.Disposicion:
											montoComisiones = $('#montoSolici').asNumber();
										break;
										case cat_ForCobComisiones.TotalPriDisposicion:
											montoComisiones = montoLineaCreditoAgro;
										break;
									}

									montoPagComAdmon = (montoComisiones * solicitud.porcentajeComAdmon)/100;
									$('#montoPagComAdmon').val(montoPagComAdmon.toFixed(2));

									if( $('#pagaIVACte').val() == 'S' ){
										montoIVAPagComAdmon = $('#montoPagComAdmon').asNumber() * parametroBean.ivaSucursal;
									}

									$('#montoIvaPagComAdmon').val(montoIVAPagComAdmon.toFixed(2));
								}

								if(manejaComGarantia == 'S'){
									habilitaControl('manejaComGarantia');
									var montoIvaComGarantia = 0.00;
									if( $('#pagaIVACte').val() == 'S' ){
										montoIvaComGarantia = $('#montoComGarantia').asNumber() * parametroBean.ivaSucursal;
									}

									$('#montoIvaComGarantia').val(montoIvaComGarantia.toFixed(2));
								}

								montoOriginalSolicitud = $('#montoSolici').asNumber() -( $('#montoIvaPagComAdmon').asNumber() + $('#montoPagComAdmon').asNumber());
								$('#montoPagComAdmon').formatCurrency({
									positiveFormat : '%n',
									roundToDecimalPlace : 2
								});

								$('#montoComGarantia').formatCurrency({
									positiveFormat : '%n',
									roundToDecimalPlace : 2
								});

								$('#montoIvaPagComAdmon').formatCurrency({
									positiveFormat : '%n',
									roundToDecimalPlace : 2
								});

								$('#montoIvaPagComAdmon').formatCurrency({
									positiveFormat : '%n',
									roundToDecimalPlace : 2
								});

								deshabilitaControl('lineaCreditoID');
								deshabilitaControl('tipoLineaAgroID');
								deshabilitaControl('saldoDisponible');

								if( $('#estatus').val() != 'I'){
									deshabilitaControl('manejaComAdmon');
									deshabilitaControl('comAdmonLinPrevLiq');
									deshabilitaControl('forPagComAdmon');
									deshabilitaControl('porcentajeComAdmon');
									deshabilitaControl('montoPagComAdmon');
									deshabilitaControl('montoIvaPagComAdmon');
									deshabilitaControl('manejaComGarantia');
									deshabilitaControl('comGarLinPrevLiq');
									deshabilitaControl('forPagComGarantia');
									deshabilitaControl('montoComGarantia');
									deshabilitaControl('montoIvaPagComAdmon');
									deshabilitaControl('porcentajeComGarantia');
								} else {
									habilitaControl('lineaCreditoID');
									$('#prospectoID').focus().select();
								}
							}
						} else {

							var mensajePantalla = 'La Solicitud de Crédito no Corresponde a una Consolidación.';
							if(solicitud.tipoCredito == "N"){
								mensajePantalla = "La Solicitud de Crédito " +solicitud.solicitudCreditoID +
												  " no es del Tipo Consolidación.<br>Favor de consultarla en " + "<b><a onclick=\"$('#Contenedor').load('flujoIndividualAgro.htm',function(response, status, xhr){" + "if(status == 'error') {$('#Contenedor').html(response);}});consultaSesion();\"> Flujo Individual Solicitud de Crédito Agro. <img src=\"images/external.png\"></a></b>";
							}
							if(solicitud.tipoCredito == 'R'){
								mensajePantalla = "La Solicitud de Crédito " +solicitud.solicitudCreditoID +
												  " no es del Tipo Consolidación.<br>Favor de consultarla en " + "<b><a onclick=\"$('#Contenedor').load('flujoIndivReestructuraAgro.htm',function(response, status, xhr){" + "if(status == 'error') {$('#Contenedor').html(response);}});consultaSesion();\"> Flujo Individual Reestructura Agro. <img src=\"images/external.png\"></a></b>";

							}
							if(solicitud.tipoCredito == 'O'){
								mensajePantalla = "La Solicitud de Crédito " +solicitud.solicitudCreditoID +
												  " no es del Tipo Consolidación.<br>Favor de consultarla en " + "<b><a onclick=\"$('#Contenedor').load('flujoIndividualRenovacionFiraVista.htm',function(response, status, xhr){" + "if(status == 'error') {$('#Contenedor').html(response);}});consultaSesion();\"> Flujo Individual Renovacion Agro. <img src=\"images/external.png\"></a></b>";
							}
							mensajeSis(mensajePantalla);
							deshabilitaBoton('agregar', 'submit');
							deshabilitaBoton('modificar', 'submit');
							deshabilitaBoton('agregaConsolidacion', 'submit');
							return;
						}
					} else {
						mensajeSis("La Solicitud de Crédito No existe o no es una Solicitud de Crédito Agropecuario.");
						inicializarSolicitud();
						$('#solicitudCreditoID').focus();
						$('#solicitudCreditoID').val("");
					}


				},
				errorHandler : function(message, exception) {
					mensajeSis("Error al consultar la Solicitud de Crédito.<br>" + message + ":" + exception);
				}
			});
		}//End solCred == '0'
	}
}// consulta el producto de credito sólo se ocupa cuando se trata del alta de una solicitud de crédito nueva.
//funcion para obtener los valores de la primera solicitud si ya existe una
//sólo se ocupa para solicitudes grupales y cuando ya es la segunda que se da de alta.
function consultaValoresPrimeraSolicitudGrupal(solCred) {

	setTimeout("$('#cajaLista').hide();", 200);
	habilitaControl('lineaFondeoID');
	habilitaControl('tasaPasiva');
	habilitaControl('tipoFondeo2');
	habilitaControl('tipoFondeo');
	numTransaccionInicGrupo = 0;
	tipoOperacionGrupo = '';
	if (solCred != '' && !isNaN(solCred) && esTab) {

		if (solCred != '0') {
			var SolCredBeanCon = {
				'solicitudCreditoID' : solCred,
				'usuario' : usuario
			};
			solicitudCredServicio.consulta(9, SolCredBeanCon, {
				callback : function(solicitud) {
					if (solicitud != null && solicitud.solicitudCreditoID != 0) {
						esTab = true;
						// forma de pago del producto de credito com apertura
						if (solicitud.forCobroComAper == 'F') {
							$('#formaComApertura').val(financiado);
						} else {
							if (solicitud.forCobroComAper == 'D') {
								$('#formaComApertura').val(deduccion);
							} else {
								if (solicitud.forCobroComAper == 'A') {
									$('#formaComApertura').val(anticipado);
								}
							}
						}

						/*campo auxiliar para la forma del cobro usado en el calculo del seguro de vida
						 * cuando se da de alta la segunda solicitud grupal*/
						$('#auxTipPago').val(solicitud.forCobroSegVida);

						// forma de pago del seguro de vida
						if (solicitud.forCobroSegVida == 'F') {
							$('#tipoPagoSeguro').val(financiado);
							$('#forCobroSegVida').val("F");
						} else {
							if (solicitud.forCobroSegVida == 'D') {
								$('#tipoPagoSeguro').val(deduccion);
								$('#forCobroSegVida').val("D");

							} else {
								if (solicitud.forCobroSegVida == 'A') {
									$('#tipoPagoSeguro').val(anticipado);
									$('#forCobroSegVida').val("A");

								} else {
									if (solicitud.forCobroSegVida == 'O') {
										$('#forCobroSegVida').val("O");

									}
								}
							}
						}

						// valores del calendario de pagos
						if (solicitud.fechInhabil == 'S') {
							$('#fechInhabil').val("S");
							$('#fechInhabil1').attr('checked', true);
							$('#fechInhabil2').attr("checked", false);
						} else {
							$('#fechInhabil2').attr('checked', true);
							$('#fechInhabil1').attr("checked", false);
							$('#fechInhabil').val("A");
						}

						$('#ajusFecExiVen').val("N");

						$('#calendIrregular').val("S");
						deshabilitaControl('numAmortizacion');
						deshabilitaControl('numAmortInteres');

						$('#ajFecUlAmoVen').val("N");

						if (solicitud.diaPagoCapital == 'F') {
							$('#diaPagoCapital1').attr('checked', true);
							$('#diaPagoCapital2').attr('checked', false);
						} else {
							$('#diaPagoCapital2').attr('checked', true);
							$('#diaPagoCapital1').attr('checked', false);
						}

						$('#diaPagoCapital').val(solicitud.diaPagoCapital);
						$('#diaPagoInteres').val(solicitud.diaPagoInteres);

						if (solicitud.diaPagoInteres == 'F') {
							$('#diaPagoInteres1').attr('checked', true);
							$('#diaPagoInteres2').attr('checked', false);
						} else {
							$('#diaPagoInteres1').attr('checked', false);
							$('#diaPagoInteres2').attr('checked', true);
						}

						if (solicitud.tipoFondeo == "P") {
							$('#tipoFondeo').attr('checked', true);
							$('#tipoFondeo2').attr("checked", false);
							deshabilitaControl('lineaFondeoID');
							deshabilitaControl("tipoFondeo2");
							deshabilitaControl("tipoFondeo");
							deshabilitaControl('tasaPasiva');
							$('#acreditadoIDFIRA').val("");
							$('#creditoIDFIRA').val("");
							mostrarElementoPorClase('mostrarAcredFIRA', false);
							mostrarElementoPorClase('mostrarAcred', false);
							mostrarElementoPorClase('mostrarCred', false);
						} else {
							if (solicitud.tipoFondeo == "F") {
								$('#tipoFondeo2').attr('checked', true);
								$('#tipoFondeo').attr("checked", false);
								deshabilitaControl("tipoFondeo2");
								deshabilitaControl("tipoFondeo");

								if($('#solicitudCre1').asNumber()>0 && $('#solicitudCre1').asNumber() != $('#solicitudCreditoID').asNumber() && $('#solicitudCreditoID').asNumber()>0){
										habilitaControl('lineaFondeoID');
									} else {
									habilitaControl('lineaFondeoID');
									}
								habilitaControl('tasaPasiva');
							}
						}

						if ($('#grupo').val() != undefined) {
							consultaGrupo('grupoID');
						}
						fechaVencimientoInicial = solicitud.fechaVencimiento;
						NumCuotas = solicitud.numAmortizacion;
						NumCuotasInt = solicitud.numAmortInteres;
						$('#fechaVencimiento').val(solicitud.fechaVencimiento);
						$('#productoCreditoID').val(solicitud.productoCreditoID);
						$('#grupoID').val(solicitud.grupoID);
						setCalcInteresID(solicitud.calcInteresID, false);
						$('#tipoCalInteres').val(solicitud.tipoCalInteres).selected = true;
						$('#diaMesCapital').val(solicitud.diaMesCapital);
						$('#diaMesInteres').val(solicitud.diaMesInteres);

						$('#numAmortizacion').val(solicitud.numAmortizacion);
						$('#numAmortInteres').val(solicitud.numAmortInteres);
						$('#periodicidadInt').val(solicitud.periodicidadInt);
						$('#periodicidadCap').val(solicitud.periodicidadCap);
						deshabilitaControl('lineaFondeoID');
						deshabilitaControl('tasaPasiva');
						deshabilitaControl('tipoFondeo2');
						deshabilitaControl('tipoFondeo');

						// se llena la parte del calendario y valores parametrizados en el producto
						// seleccionando los que se trajo de resultado la consulta
						consultaCalendarioPorProductoSolicitud(solicitud.productoCreditoID, solicitud.tipoPagoCapital, solicitud.frecuenciaCap, solicitud.frecuenciaInt, solicitud.plazoID, solicitud.tipoDispersion);

						consultaProducCreditoForanea(solicitud.productoCreditoID, solicitud.fechaVencimiento);
						consultaMinistracionesGrupales(solicitud.solicitudCreditoID);
						consultaGrupo('grupoID');
						numTransaccionInicGrupo = solicitud.numTransacSim;

						simulador();
					}
				},
				errorHandler : function(message, exception) {
					mensajeSis("Error en consulta de la Solicitud de Crédito.<br>" + message + ":" + exception);
				}
			});
		}
	}
}

//consulta el producto de credito sólo se ocupa cuando se trata del alta de una solicitud de crédito nueva.
function consultaProducCredito(idControl) {
	var jqProdCred = eval("'#" + idControl + "'");
	var ProdCred = $(jqProdCred).val();
	var ProdCredBeanCon = {
		'producCreditoID' : ProdCred
	};

	setTimeout("$('#cajaLista').hide();", 200);
	if (ProdCred != '' && !isNaN(ProdCred) && esTab) {
		productosCreditoServicio.consulta( 8, ProdCredBeanCon, {
			async : false,
			callback : function(prodCred) {
				if (prodCred != null) {

					consultaTiposLineasAgro(prodCred.producCreditoID, 2);
					mostrarLabelTasaFactorMora(prodCred.tipCobComMorato);
					// SEGUROS
					if ($('#mostrarSeguroCuota').val() == 'S') {
						$('#cobraSeguroCuota').val(prodCred.cobraSeguroCuota).selected = true;
						$('#cobraIVASeguroCuota').val(prodCred.cobraIVASeguroCuota).selected = true;
					} else {
						$('#cobraSeguroCuota').val("N").selected = true;
						$('#cobraIVASeguroCuota').val("N").selected = true;
					}
					// FIN SEGUROS

					/*Se verifica primero si el producto de credito permite Consolidacion */
					if( prodCred.reqConsolidacionAgro == 'S'){
						/*Se verifica primero si el producto de credito permite prospecto*/
						if ($('#clienteID').asNumber() > 0 || prodCred.permiteAutSolPros == permiteSolicitudProspecto) {

							consultaRelacionCliente('productoCreditoID');
							modalidad = prodCred.modalidad;
							esquemaSeguro = prodCred.esquemaSeguroID;

							esTab = true;
							consultacicloCliente();
							$('#descripProducto').val(prodCred.descripcion);
							$('#factorMora').val(prodCred.factorMora);
							setCalcInteresID(prodCred.calcInteres, true);
							$('#tipoCalInteres').val(prodCred.tipoCalInteres);
							if (prodCred.tipoCalInteres == '2') {
								$('#tipoPagoCapital').val('I').selected = true;
							}

							$('#institutFondID').val(prodCred.institutFondID);
							$('#esGrupal').val(prodCred.esGrupal);
							$('#tasaPonderaGru').val(prodCred.tasaPonderaGru);
							if (Number(prodCred.institutFondID) != 0) {
								$('#tipoFondeo2').attr("checked", true);
							}
							$('input[name="tipoFondeo"]').change();

							consultaPorcentajeGarantiaLiquida('productoCreditoID');

							// forma de pago del producto de credito com apertura
							if (prodCred.formaComApertura == 'F') {
								$('#formaComApertura').val(financiado);
							} else {
								if (prodCred.formaComApertura == 'D') {
									$('#formaComApertura').val(deduccion);
								} else {
									if (prodCred.formaComApertura == 'A') {
										$('#formaComApertura').val(anticipado);
									}
								}
							}

							formaCobroComApe = prodCred.formaComApertura;

							montoMaxSolicitud = prodCred.montoMaximo;
							montoMinSolicitud = prodCred.montoMinimo;

							if (prodCred.institutFondID == '0') {
								habilitaControl('tipoFondeo');
								$('#tipoFondeo').attr('checked', true);
								deshabilitaControl('lineaFondeoID');
								deshabilitaControl('tasaPasiva');
								$('#lineaFondeoID').val('0');
							}
							// si el producto de credito es grupal, activa el input de grupo
							if ($('#grupo').val() != '' && $('#grupo').val() != undefined) {
								deshabilitaControl('grupoID');
								$('#tipoIntegrante').val("4");
							}

							deshabilitaControl('tipoIntegrante');
							deshabilitaControl('grupoID');

							// GUARDA  EL VALOR  SI  TIENE SEGURO O NO
							requiereSeg = prodCred.reqSeguroVida;
							// esconde o muestra los elemento de cuando requiere seguro de vida
							validaSiseguroVida(prodCred.reqSeguroVida);

							if (prodCred.modalidad == "T") {
								descuentoSeg = prodCred.descuentoSeguro;
								$('#ltipoPago').hide();
								$('#tipoPagoSeguro').hide();
								$('#tipoPagoSelect').show();
								$('#tipoPagoSelect2').show();

								consultaTiposPago(prodCred.producCreditoID, prodCred.esquemaSeguroID, "");

							} else {
								if (prodCred.modalidad == "U") {
									descuentoSeg = prodCred.descuentoSeguro;

									$('#ltipoPago').show();
									$('#tipoPagoSeguro').show();
									$('#tipoPagoSelect').hide();
									$('#tipoPagoSelect2').hide();
								}
							}

							// forma de pago del seguro de vida
							if (prodCred.modalidad == "U") {
								$('#factorRiesgoSeguro').val(prodCred.factorRiesgoSeguro);
								$('#forCobroSegVida').val(prodCred.tipoPagoSeguro);
								$('#montoPolSegVida').val(prodCred.montoPolSegVida);
								if (prodCred.tipoPagoSeguro == 'F') {
									$('#tipoPagoSeguro').val(financiado);
								} else {
									if (prodCred.tipoPagoSeguro == 'D') {
										$('#tipoPagoSeguro').val(deduccion);
									} else {
										if (prodCred.tipoPagoSeguro == 'A') {
											$('#tipoPagoSeguro').val(anticipado);
										}
									}
								}
							} else {

								if (tipoPagoSeg == 'A') {
									$('#tipPago').val('A');
								}
								if (tipoPagoSeg == 'F') {
									$('#tipPago').val('F');
								}
								if (tipoPagoSeg == 'D') {
									$('#tipPago').val('D');
								}
								if (tipoPagoSeg == 'O') {
									$('#tipPago').val('O');
								}
							}

							// consulta el calendario de pagos limite de monto, sólo cuando es una solicitud nueva
							validaLimiteMontoSolicitado();
							// valida la comision por apertura
							consultaComisionAper();
							// se llenan los valores de los combos segun lo parametrizado
							consultaCalendarioPorProducto('productoCreditoID');

							if ((clienteIDBase > 0 || prospectoIDBase > 0) && montoSolicitudBase > 0) {
								consultaTasaCredito($('#montoSolici').asNumber(), 'productoCreditoID');
							}

							// verifica el credito podra tener un desembolso anticipado
							$('#fechaInicioAmor').val(parametroBean.fechaAplicacion);
							$('#fechaDesembolso').val(parametroBean.fechaAplicacion);

							if (prodCred.inicioAfuturo == 'S') {
								$("#fechaInicioAmor").attr('readonly', false);
								$("#fechaInicioAmor").datepicker({
									showOn : "button",
									buttonImage : "images/calendar.png",
									buttonImageOnly : true,
									changeMonth : true,
									changeYear : true,
									dateFormat : 'yy-mm-dd',
									yearRange : '-100:+10'
								});

								inicioAfuturo = 'S';
								diasMaximo = prodCred.diasMaximo;
							} else {
								$("#fechaInicioAmor").attr('readonly', true);
								$("#fechaInicioAmor").datepicker("destroy");

								inicioAfuturo = 'N';
								diasMaximo = 0;
							}

							if(prodCred.fechaDesembolso == "S"){
								$("#fechaDesembolso").attr('readonly', false);
								$("#fechaDesembolso").datepicker({
									showOn : "button",
									buttonImage : "images/calendar.png",
									buttonImageOnly : true,
									changeMonth : true,
									changeYear : true,
									dateFormat : 'yy-mm-dd',
									yearRange : '-100:+10'
								});
							} else {
								$("#fechaDesembolso").attr('readonly', true);
								$("#fechaDesembolso").datepicker("destroy");

							}


							financiamientoRural = prodCred.financiamientoRural;
						} else {
							mensajeSis("El Producto de Crédito No Permite Autorización de Solicitud Por Prospecto.");
							$('#productoCreditoID').focus();
							$('#productoCreditoID').select();
							$('#descripProducto').val("");
						}
					} else {
						mensajeSis("El Producto de Crédito No Permite Consolidaciones.");
						$('#productoCreditoID').focus();
						$('#productoCreditoID').select();
						$('#descripProducto').val("");
					}
				} else {
					mensajeSis("No Existe el Producto de Crédito o No es un Producto de Crédito Agropecuario.");
					$('#productoCreditoID').focus();
					$('#productoCreditoID').select();
					$('#descripProducto').val("");
					// SEGUROS
					$('#cobraSeguroCuota').val('N').selected = true;
					$('#cobraIVASeguroCuota').val('N').selected = true;
					$('#montoSeguroCuota').val('');
					productoIDBase = 0;

					$("#fechaInicioAmor").attr('readonly', true);
					$("#fechaInicioAmor").datepicker("destroy");
					$("#fechaDesembolso").attr('readonly', true);
					$("#fechaDesembolso").datepicker("destroy");

					inicioAfuturo = 'N';
					diasMaximo = 0;
					//resetea toda la parte del formulario sobre el producto e credito
					$('#destinoCreID').val('');
					$('#descripDestino').val('');

					$('#proyecto').val('');

					$('#lblFolioCtrl').val('');
					$('#folioCtrlCaja').val('');

					$('#esGrupal').val('');
					$('#tasaPonderaGru').val('');
					$('#cicloClienteGrupal').val('');
					//oculta los campos refernte al nomina

					$('#lblFolioCtrl').hide();
					$('#folioCtrlCaja').hide();
					$('#sep').hide();
					//vuelve visible el campo de cicos preomedio grupal
					$('#lbciclos').show();
					$('#lbcicloscaja').show();
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error en Consulta de Producto de Crédito.<br>" + message + ":" + exception);
			}
		});
	}
}

//consulta la tasa de credito
function consultaTasaCredito(idControl, control) {
	var monto = idControl;
	var cte = $('#clienteID').val();
	var numCred = ''; // variable numero del ciclo del Cliente
	var cicloCte = $('#numCreditos').asNumber(); // Ciclo individual del cliente

	if (cte == '') {
		$('#clienteID').val('0');
		$('#pagaIVACte').val('S');
	}

	numCred = cicloCte;

	setTimeout("$('#cajaLista').hide();", 200);
	// bean para cuando es un cliente
	var credBeanCon = {
		'clienteID' : $('#clienteID').val(),
		'sucursal' : $('#sucursalID').val(),
		'producCreditoID' : $('#productoCreditoID').val(),
		'montoCredito' : monto,
		'calificaCliente' : $('#calificaCliente').val(),
		'plazoID' : $('#plazoID').val(),
		'empresaNomina' : 0

	};

	// bean para cuando no es un cliente y es un prospecto
	var credBeanConsulta = {
		'sucursal' : $('#sucursalID').val(),
		'producCreditoID' : $('#productoCreditoID').val(),
		'montoCredito' : monto,
		'calificaCliente' : $('#calificaCliente').val(),
		'plazoID' : $('#plazoID').val(),
		'empresaNomina' : 0

	};

	// se ejecuta la función para buscar la tasa
	if (monto != '' && !isNaN(monto)) {
		// solo entra cuando se trata de un cliente
		if ($('#clienteID').val() != '0') {
			if ($('#plazoID').val() != '') {
				creditosServicio.consultaTasa(numCred, credBeanCon, {
					async : false,
					callback : function(tasas) {
						if (tasas != null) {
							if (tasas.valorTasa > 0) {
								$('#tasaFija').val(tasas.valorTasa).change();

							} else {
								mensajeSis("No Hay una Tasa Parametrizada para los Valores Indicados.");
							/*	$('#montoSolici').val("0.00");
								montoSolicitudBase = 0.00;*/
								$('#tasaFija').val("0.00").change();
								$('#' + control).focus();
								$('#' + control).select();
								if ($('#grupo').val() != undefined) {
									$('#montoSolici').focus();
								} else {
									$('#plazoID').val('');
								}
							}
						} else {
							mensajeSis("No Hay una Tasa Parametrizada para los Valores Indicados.");
							/*$('#montoSolici').val("0.00");
							montoSolicitudBase = 0.00;*/
							$('#tasaFija').val('0.00').change();
							$('#' + control).focus();
							$('#' + control).select();
						}
					},
					errorHandler : function(message, exception) {
						mensajeSis("Error en Consulta de la Tasa.<br>" + message + ":" + exception);
					}
				});
			} else {
				$('#tasaFija').val("0.00").change();
			}
		}
		// solo entra cuando se trata de un Prospecto
		if ($('#prospectoID').val() != '0' && $('#prospectoID').val() != '') {
			if ($('#plazoID').val() != '') {
				creditosServicio.consultaTasa(numCred, credBeanConsulta, {
					callback : function(tasas) {
						if (tasas != null) {
							if (tasas.valorTasa > 0) {
								$('#tasaFija').val(tasas.valorTasa).change();

							} else {
								mensajeSis("No Hay una Tasa Parametrizada para los Valores Indicados.");
								$('#montoSolici').val("0.00");
								montoSolicitudBase = 0.00;
								montoOriginalSolicitud = montoSolicitudBase;
								$('#tasaFija').val('0.00').change();
								$('#' + control).focus();
								$('#' + control).select();
							}
						} else {
							mensajeSis("No Hay una Tasa Parametrizada para los Valores Indicados.");
							$('#montoSolici').val("0.00");
							montoSolicitudBase = 0.00;
							montoOriginalSolicitud = montoSolicitudBase;
							$('#tasaFija').val('0.00').change();
							$('#' + control).focus();
							$('#' + control).select();
						}
					},
					errorHandler : function(message, exception) {
						mensajeSis("Error al consultar la Solicitud de Crédito.<br>" + message + ":" + exception);
					}
				});
			} else {
				$('#tasaFija').val("0.00").change();
			}
		}
	}
}

//consulta foranea del producto de credito utilizada en la consulta de la solicitud de credito
function consultaProducCreditoForanea(producto, varfecha) {

	var ProdCredBeanCon = {
		'producCreditoID' : producto
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (producto != '' && !isNaN(producto) && esTab) {
		productosCreditoServicio.consulta(enum_productos_con.agropecuario, ProdCredBeanCon, {
			async : false,
			callback : function(prodCred) {
				if (prodCred != null) {
					mostrarLabelTasaFactorMora(prodCred.tipCobComMorato);
					$('#descripProducto').val(prodCred.descripcion);
					montoMaxSolicitud = prodCred.montoMaximo;
					montoMinSolicitud = prodCred.montoMinimo;
					formaCobroComApe = prodCred.formaComApertura;
					$('#tasaPonderaGru').val(prodCred.tasaPonderaGru);
					$('#esGrupal').val(prodCred.esGrupal);
					requiereSeg = prodCred.reqSeguroVida;
					if (prodCred.reqSeguroVida == 'S') {
						if (varfecha != 'no') {
							calculaNodeDias(varfecha);
						}
						modalidad = prodCred.modalidad;
						esquemaSeguro = prodCred.esquemaSeguroID;
						$('#esquemaSeguroID').val(prodCred.esquemaSeguroID);
					}
					financiamientoRural = prodCred.financiamientoRural;
					// esconde o muestra  los elemento de cuando requiere seguro de vida
					validaSiseguroVida(prodCred.reqSeguroVida);
					if (prodCred.reqSeguroVida == 'S') {
						if (prodCred.modalidad == "T") {
							$('#ltipoPago').hide();
							$('#tipoPagoSeguro').hide();
							$('#tipoPagoSelect').show();
							$('#tipoPagoSelect2').show();
							consultaEsquemaSeguroVidaForanea(tipoPagoSeg);
						} else {
							if (prodCred.modalidad == "U") {
								descuentoSeg = prodCred.descuentoSeguro;
								$('#ltipoPago').show();
								$('#tipoPagoSeguro').show();
								$('#tipoPagoSelect').hide();
								$('#tipoPagoSelect2').hide();
							}
						}
					}

					// forma de pago del producto de credito com apertura
					if (prodCred.formaComApertura == 'F') {
						$('#formaComApertura').val(financiado);
					} else {
						if (prodCred.formaComApertura == 'D') {
							$('#formaComApertura').val(deduccion);
						} else {
							if (prodCred.formaComApertura == 'A') {
								$('#formaComApertura').val(anticipado);
							}
						}
					}

					if (prodCred.modalidad == "U") {
						$('#factorRiesgoSeguro').val(prodCred.factorRiesgoSeguro);
						$('#forCobroSegVida').val(prodCred.tipoPagoSeguro);
						$('#montoPolSegVida').val(prodCred.montoPolSegVida);

						// forma de pago del seguro de vida
						if (prodCred.tipoPagoSeguro == 'F') {
							$('#tipoPagoSeguro').val(financiado);
						} else {
							if (prodCred.tipoPagoSeguro == 'D') {
								$('#tipoPagoSeguro').val(deduccion);
							} else {
								if (prodCred.tipoPagoSeguro == 'A') {
									$('#tipoPagoSeguro').val(anticipado);
								}
							}
						}
					} else {
						if (prodCred.modalidad == "T") {
							if (tipoPagoSeg == 'A') {
								$("#tipPago option[value=" + tipoPagoSeg + "]").attr("selected", true);
							}
							if (tipoPagoSeg == 'F') {
								$("#tipPago option[value=" + tipoPagoSeg + "]").attr("selected", true);
							}
							if (tipoPagoSeg == 'D') {
								$("#tipPago option[value=" + tipoPagoSeg + "]").attr("selected", true);
							}
							if (tipoPagoSeg == 'O') {
								$("#tipPago option[value=" + tipoPagoSeg + "]").attr("selected", true);
							}

							if ($('#tipPago option:selected').text() == "ADELANTADO") {
								$('#forCobroSegVida').val("A");
							}

							if ($('#tipPago option:selected').text() == "FINANCIAMIENTO") {
								$('#forCobroSegVida').val("F");
							}

							if ($('#tipPago option:selected').text() == "DEDUCCION") {
								$('#forCobroSegVida').val("D");
							}

							if ($('#tipPago option:selected').text() == "OTRO") {
								$('#forCobroSegVida').val("O");
							}
						}
						consultaEsquemaSeguroVidaForanea(tipoPagoSeg);
					}

					// valida si el credito puede tener un desembolso anticipado
					if (prodCred.inicioAfuturo == 'S') {
						$("#fechaInicioAmor").attr('readonly', false);
						$("#fechaInicioAmor").datepicker({
							showOn : "button",
							buttonImage : "images/calendar.png",
							buttonImageOnly : true,
							changeMonth : true,
							changeYear : true,
							dateFormat : 'yy-mm-dd',
							yearRange : '-100:+10'
						});
						inicioAfuturo = 'S';
						diasMaximo = prodCred.diasMaximo;
					} else {
						$("#fechaInicioAmor").attr('readonly', true);
						$("#fechaInicioAmor").datepicker("destroy");
						inicioAfuturo = 'N';
						diasMaximo = 0;
					}

					// valida si el credito puede tener un desembolso anticipado
					if (prodCred.fechaDesembolso == 'S') {
						$("#fechaDesembolso").attr('readonly', false);
						$("#fechaDesembolso").datepicker({
							showOn : "button",
							buttonImage : "images/calendar.png",
							buttonImageOnly : true,
							changeMonth : true,
							changeYear : true,
							dateFormat : 'yy-mm-dd',
							yearRange : '-100:+10'
						});
					} else {
						$("#fechaDesembolso").attr('readonly', true);
						$("#fechaDesembolso").datepicker("destroy");
					}


				} else {
					mensajeSis("No Existe el Producto de Crédito o No es un Producto de Crédito Agropecuario.");
					$('#productoCreditoID').focus();
					$('#productoCreditoID').select();
					$("#fechaInicioAmor").attr('readonly', true);
					$("#fechaInicioAmor").datepicker("destroy");
					$("#fechaDesembolso").attr('readonly', true);
					$("#fechaDesembolso").datepicker("destroy");
					// SEGUROS
					$('#cobraSeguroCuota').val('N').selected = true;
					$('#cobraIVASeguroCuota').val('N').selected = true;
					$('#montoSeguroCuota').val('');
					inicioAfuturo = 'N';
					diasMaximo = 0;
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error en Consulta de Producto de Crédito.<br>" + message + ":" + exception);
			}
		});
	}
}

/*
 * Metodo para consultar las condiciones del calendario  segun el tipo de producto seleccionado y sólo se ocupa
 * cuando se trata de una solicitud nueva para dar de alta,  se dispara cuando el producto de credito pierde el foco
 */
function consultaCalendarioPorProducto(idControl) {
	var jqproducto = eval("'#" + idControl + "'");
	var producto = $(jqproducto).val();
	var TipoConPrin = 1;
	var calendarioBeanCon = {
		'productoCreditoID' : producto
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (producto != '' && !isNaN(producto) && esTab) {
		calendarioProdServicio.consulta(TipoConPrin, calendarioBeanCon, {
			async : false,
			callback : function(calendario) {
				if (calendario != null) {

					//Valida que el calendario permita calendario irregular
					if (calendario.permCalenIrreg == 'S') {
						//Se valida que tenga la Frecuencia de Libres
						if (calendario.frecuencias.includes("L")) {
							if (calendario.fecInHabTomar == 'S') {

								$('#fechInhabil1').attr('checked', true);
								$('#fechInhabil2').attr("checked", false);
								habilitaControl('fechInhabil1');
								deshabilitaControl('fechInhabil2');
								$('#fechInhabil').val("S");
							} else {

								$('#fechInhabil2').attr('checked', true);
								$('#fechInhabil1').attr("checked", false);
								deshabilitaControl('fechInhabil1');
								habilitaControl('fechInhabil2');
								$('#fechInhabil').val("A");
							}

							$('#ajusFecExiVen').val("N");

							if (calendario.permCalenIrreg == 'S') {
								$('#calendIrregular').val("N");
								habilitaControl('calendIrregularCheck');
								$('#calendIrregularCheck').attr("checked", true);
							} else {

								if (calendario.permCalenIrreg == 'N' && $('#estatus').val() == 'I') {
									deshabilitaControl('calendIrregularCheck');
								}

								$('#calendIrregularCheck').attr('checked', false);
								$('#calendIrregular').val("N");
							}
							$('#ajFecUlAmoVen').val("N");

							if (calendario.iguaCalenIntCap == 'S') {
								$('#perIgual').val("S");
								deshabilitaControl('frecuenciaInt');
								deshabilitaControl('numAmortInteres');
								$("#numAmortInteres").val($("#numAmortizacion").val());

							} else {

								if (calendario.iguaCalenIntCap == 'N') {
									$('#perIgual').val("N");
									habilitaControl('frecuenciaInt');
									habilitaControl('numAmortInteres');
								}
							}

							// VALIDA el dia de pago de capital
							switch (calendario.diaPagoCapital) {

								case "F" : // SI ES FIN DE MES

									$('#diaPagoProd').val("F");
									habilitaControl('diaPagoCapital1');
									deshabilitaControl('diaPagoCapital2');
									$('#diaPagoCapital1').attr('checked', true);
									$('#diaPagoCapital2').attr('checked', false);
									$('#diaPagoCapital').val("F");
									deshabilitaControl('diaMesCapital');
									$('#diaMesCapital').val('');
									deshabilitaControl('diaPagoInteres1');
									deshabilitaControl('diaPagoInteres2');
									$('#diaPagoInteres1').attr('checked', true);
									$('#diaPagoInteres2').attr('checked', false);
									$('#diaPagoInteres').val("F");
									$('#diaMesInteres').val('');
									deshabilitaControl('diaMesInteres');

									break;

								case "A" : // SI ES POR ANIVERSARIO

									$('#diaPagoProd').val("A");
									deshabilitaControl('diaPagoCapital1');
									deshabilitaControl('diaPagoCapital2');
									$('#diaPagoCapital2').attr('checked', true);
									$('#diaPagoCapital1').attr('checked', false);
									$('#diaMesCapital').val(diaSucursal);
									$('#diaPagoCapital').val("A");
									deshabilitaControl('diaMesCapital');

									deshabilitaControl('diaPagoInteres1');
									deshabilitaControl('diaPagoInteres2');
									$('#diaPagoInteres2').attr('checked', true);
									$('#diaPagoInteres1').attr('checked', false);
									$('#diaPagoInteres').val("A");
									$('#diaMesInteres').val(diaSucursal);
									deshabilitaControl('diaMesInteres');

									break;

								case "D" : // DIA DEL MES

									$('#diaPagoProd').val("D");
									deshabilitaControl('diaPagoCapital1');
									deshabilitaControl('diaPagoCapital2');
									$('#diaPagoCapital2').attr('checked', true);
									$('#diaPagoCapital1').attr('checked', false);
									$('#diaPagoCapital').val("D");
									habilitaControl('diaMesCapital');
									$('#diaMesCapital').val(diaSucursal);

									deshabilitaControl('diaPagoInteres1');
									deshabilitaControl('diaPagoInteres2');
									$('#diaPagoInteres2').attr('checked', true);
									$('#diaPagoInteres1').attr('checked', false);
									$('#diaPagoInteres').val("D");
									$('#diaMesInteres').val(diaSucursal);
									habilitaControl('diaMesInteres');

									break;

								case "I" : // SI ES INDISTINTO

									$('#diaPagoProd').val("I");
									habilitaControl('diaPagoCapital1');
									habilitaControl('diaPagoCapital2');
									$('#diaPagoCapital1').attr('checked', true);
									$('#diaPagoCapital2').attr('checked', false);
									$('#diaPagoCapital').val("F");
									deshabilitaControl('diaMesCapital'); // se deshabilita xq por default se chequea fin de mes
									$('#diaMesCapital').val('');

									habilitaControl('diaPagoInteres1');
									habilitaControl('diaPagoInteres2');
									$('#diaPagoInteres1').attr('checked', true);
									$('#diaPagoInteres2').attr('checked', false);
									$('#diaPagoInteres').val("F");
									$('#diaMesInteres').val('');
									deshabilitaControl('diaMesInteres');

									if (calendario.iguaCalenIntCap == 'S') {
										deshabilitaControl('diaPagoInteres1');
										deshabilitaControl('diaPagoInteres2');
									}

									break;

								default :

									$('#diaPagoProd').val("I");
								habilitaControl('diaPagoCapital1');
								habilitaControl('diaPagoCapital2');
								$('#diaPagoCapital1').attr('checked', true);
								$('#diaPagoCapital2').attr('checked', false);
								$('#diaPagoCapital').val("F");
								deshabilitaControl('diaMesCapital');
								$('#diaMesCapital').val('');

								habilitaControl('diaPagoInteres1');
								habilitaControl('diaPagoInteres2');
								$('#diaPagoInteres1').attr('checked', true);
								$('#diaPagoInteres2').attr('checked', false);
								$('#diaPagoInteres').val("F");
								$('#diaMesInteres').val('');
								deshabilitaControl('diaMesInteres');

								if (calendario.iguaCalenIntCap == 'S') {
									deshabilitaControl('diaPagoInteres1');
									deshabilitaControl('diaPagoInteres2');
								}

								break;
							}

							consultaComboTipoPagoCap(calendario.tipoPagoCapital);
							consultaComboFrecuencias(calendario.frecuencias);
							consultaComboPlazos(calendario.plazoID);
							consultaComboTipoDispersion(calendario.tipoDispersion);
							/*Para creditos agro se habilitan los campos de calendario irregular*/
							$('#calendIrregular').val("S");
							if ($("#fechaInicio").val() < parametroBean.fechaAplicacion) {
								$("#fechaInicioAmor").val(parametroBean.fechaAplicacion);
								$("#fechaDesembolso").val(parametroBean.fechaAplicacion);

							} else {
								$("#fechaInicioAmor").val($("#fechaInicio").val());
								$("#fechaDesembolso").val($("#fechaInicio").val());

							}
							deshabilitaControl('frecuenciaInt');
							deshabilitaControl('frecuenciaCap');
							deshabilitaControl('tipoPagoCapital');
							$('#frecuenciaInt').val('L');
							$('#frecuenciaCap').val('L');
							$('#tipoPagoCapital').val('L');
							$("#numAmortInteres").val('1');
							$("#numAmortizacion").val('1');
							deshabilitaControl('numAmortInteres');
							deshabilitaControl('numAmortizacion');
							validarEsquemaCobroSeguro();
							/**/
						} else {
							mensajeSis("Es Necesario que el Producto Tenga Parametrizado la Frecuencia de Libres.");
							deshabilitaBoton('agregar', 'submit');
							deshabilitaBoton('modificar', 'submit');
							deshabilitaBoton('agregaConsolidacion', 'submit');
						}

					} else {
						mensajeSis("Es Necesario que el Producto Permita Calendario Irregular.");
						deshabilitaBoton('agregar', 'submit');
						deshabilitaBoton('modificar', 'submit');
						deshabilitaBoton('agregaConsolidacion', 'submit');
					}
				} else {
					mensajeSis("No Existe un Calendario de Pagos para el Producto de Crédito Indicado.");
					deshabilitaBoton('agregar', 'submit');
					deshabilitaBoton('modificar', 'submit');
					deshabilitaBoton('agregaConsolidacion', 'submit');
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error en Consulta del Calendario.<br>" + message + ":" + exception);
				deshabilitaBoton('agregar', 'submit');
				deshabilitaBoton('modificar', 'submit');
				deshabilitaBoton('agregaConsolidacion', 'submit');
			}
		});
	}
}

/* Metodo para consultar las condiciones del calendario segun el tipo de producto seleccionado y sólo se ocupa
 * cuando se trata de una consulta de una solicitud
 */
function consultaCalendarioPorProductoSolicitud(producto, valorTipoPagoCapital, valorFrecuenciaCap, valorFrecuenciaInt, valorPlazoID, valorTipoDispersion) {
	var TipoConPrin = 1;
	var calendarioBeanCon = {
		'productoCreditoID' : producto
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (producto != '' && !isNaN(producto)) {
		calendarioProdServicio.consulta(TipoConPrin, calendarioBeanCon, {
			async : false,
			callback : function(calendario) {
				if (calendario != null) {
					//Valida que el calendario permita calendario irregular
					if (calendario.permCalenIrreg == 'S') {
						//Se valida que tenga la Frecuencia de Libres
						if (calendario.frecuencias.includes("L")) {
							if (calendario.fecInHabTomar == 'S') {
								habilitaControl('fechInhabil1');
								deshabilitaControl('fechInhabil2');
							} else {
								deshabilitaControl('fechInhabil1');
								habilitaControl('fechInhabil2');
							}

							if (calendario.permCalenIrreg == 'S') {
								habilitaControl('calendIrregularCheck');
							} else {
								if (calendario.permCalenIrreg == 'N' && $('#estatus').val() == 'I') {
									deshabilitaControl('calendIrregularCheck');
								}
							}

							switch (calendario.diaPagoCapital) {
								case "F" : // SI ES FIN DE MES

									$('#diaPagoProd').val("F");
									habilitaControl('diaPagoCapital1');
									deshabilitaControl('diaPagoCapital2');
									deshabilitaControl('diaMesCapital');

									deshabilitaControl('diaPagoInteres1');
									deshabilitaControl('diaPagoInteres2');
									deshabilitaControl('diaMesInteres');

									break;
								case "A" : // SI ES POR ANIVERSARIO

									$('#diaPagoProd').val("A");
									deshabilitaControl('diaPagoCapital1');
									deshabilitaControl('diaPagoCapital2');
									deshabilitaControl('diaMesCapital');

									deshabilitaControl('diaPagoInteres1');
									deshabilitaControl('diaPagoInteres2');
									deshabilitaControl('diaMesInteres');

									break;
								case "D" : // DIA DEL MES

									$('#diaPagoProd').val("D");
									deshabilitaControl('diaPagoCapital1');
									deshabilitaControl('diaPagoCapital2');

									deshabilitaControl('diaPagoInteres1');
									deshabilitaControl('diaPagoInteres2');

									if ($('#diaPagoCapital1').is(':checked')) {
										deshabilitaControl('diaMesCapital');
										deshabilitaControl('diaMesInteres');

									} else {
										habilitaControl('diaMesCapital');
										habilitaControl('diaMesInteres');
									}

									break;
								case "I" : // SI ES INDISTINTO

									$('#diaPagoProd').val("I");
									habilitaControl('diaPagoCapital1');
									habilitaControl('diaPagoCapital2');

									habilitaControl('diaPagoInteres1');
									habilitaControl('diaPagoInteres2');

									if ($('#diaPagoCapital1').is(':checked')) {
										deshabilitaControl('diaMesCapital');
										deshabilitaControl('diaMesInteres');

									} else {
										habilitaControl('diaMesCapital');
										habilitaControl('diaMesInteres');
									}

									if (calendario.iguaCalenIntCap == 'S') {
										deshabilitaControl('diaPagoInteres1');
										deshabilitaControl('diaPagoInteres2');
									}

									break;
								default :

									$('#diaPagoProd').val("I");
								habilitaControl('diaPagoCapital1');
								deshabilitaControl('diaPagoCapital2');
								deshabilitaControl('diaMesCapital');

								deshabilitaControl('diaPagoInteres1');
								deshabilitaControl('diaPagoInteres2');
								deshabilitaControl('diaMesInteres');

								break;
							}

							if (calendario.iguaCalenIntCap == 'S') {
								$('#perIgual').val("S");
								// se llama funcion para deshabilitar calendario de interes
								deshabilitarCalendarioPagosInteres();
							} else {
								if (calendario.iguaCalenIntCap == 'N') {
									$('#perIgual').val("N");
								}
							}

							// se consultan los valores que trae la solicitud
							consultaComboTipoPagoCapSolicitud(calendario.tipoPagoCapital, valorTipoPagoCapital);
							consultaComboFrecuenciasSolicitud(calendario.frecuencias, valorFrecuenciaCap, valorFrecuenciaInt);
							consultaComboPlazosSolicitud(calendario.plazoID, valorPlazoID);
							consultaComboTipoDispersionSolicitud(calendario.tipoDispersion, valorTipoDispersion);
							/*Para creditos agro se habilitan los campos de calendario irregular*/
							$('#calendIrregular').val("S");
							if ($("#fechaInicio").val() < parametroBean.fechaAplicacion) {
								$("#fechaInicioAmor").val(parametroBean.fechaAplicacion);
								$("#fechaDesembolso").val(parametroBean.fechaAplicacion);

							} else {
								$("#fechaInicioAmor").val($("#fechaInicio").val());
								$("#fechaDesembolso").val($("#fechaInicio").val());
							}
							deshabilitaControl('frecuenciaInt');
							deshabilitaControl('frecuenciaCap');
							deshabilitaControl('tipoPagoCapital');
							$('#frecuenciaInt').val('L');

							$('#tipoPagoCapital').val('L');

							deshabilitaControl('numAmortInteres');
							deshabilitaControl('numAmortizacion');
							validarEsquemaCobroSeguro();
							/**/
						} else {
							mensajeSis("Es Necesario que el Producto Tenga Parametrizado la Frecuencia de Libres.");
						}
					} else {
						mensajeSis("Es Necesario que el Producto Permita Calendario Irregular.");
					}
				} else {
					mensajeSis("No Existe un Calendario de Pagos para el Producto de Crédito Indicado.");
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error en Consulta del Calendario.<br>" + message + ":" + exception);
			}
		});
	}
}

//funcion que llena el combo de tipo de pago capital, de acuerdo al producto
//se usa sólo cuando se trata de una solicitud nueva que se dara de alta
function consultaComboTipoPagoCap(tipoPago) {
	// se eliminan los tipos de pago que se tenian
	$('#tipoPagoCapital').each(function() {
		$('#tipoPagoCapital option').remove();
	});
	// se agrega la opcion por default
	$('#tipoPagoCapital').append(new Option('SELECCIONAR', '', true, true));

	if (tipoPago != null) {
		var tpago = tipoPago.split(',');
		var tamanio = tpago.length;
		for (var i = 0; i < tamanio; i++) {
			var pagDescrip = '';

			switch (tpago[i]) {
				case "C" : // si el tipo de pago es CRECIENTES
					pagDescrip = 'CRECIENTES';
					break;
				case "I" :// si el tipo de pago es IGUALES
					pagDescrip = 'IGUALES';
					break;
				case "L" : // si el tipo de pago es LIBRES
					pagDescrip = 'LIBRES';
					break;
				default :
					pagDescrip = 'CRECIENTES';
			}
			$('#tipoPagoCapital').append(new Option(pagDescrip, tpago[i], true, true));
			if ($('#tipoCalInteres').val() == '2') {
				$('#tipoPagoCapital').val('I').selected = true;
				deshabilitaControl('tipoPagoCapital');
			} else {
				$('#tipoPagoCapital').val('').selected = true;
				habilitaControl('tipoPagoCapital');
			}

		}
	}
}

function consultaTiposLineasAgro(valor, tipoConsulta){
	var consulta = tipoConsulta;
	var tipoLineaAgroID = valor;
	var tiposLineasAgro = {
		'tipoLineaAgroID' : tipoLineaAgroID
	};

	if(tipoLineaAgroID != '' && !isNaN(tipoLineaAgroID)){
		tiposLineasAgroServicio.consulta(consulta, tiposLineasAgro, {
			async: false, callback: function(tiposLineasAgroBean){
				if(tiposLineasAgroBean != null){
					if(tipoConsulta == 1){
						$('#tipoLineaAgroID').val(tiposLineasAgroBean.nombre);
					}
					if(tipoConsulta == 2){
						if(tiposLineasAgroBean.tipoLineaAgroID > 0){
							deshabilitaControl('lineaCreditoID');
						} else {
							deshabilitaCampoLinea();
						}
					}
				}else{
					mensajeSis("Error en Consulta de validación de Líneas de Crédito por producto de Crédito.");
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error en Consulta de validación de Línea de Crédito Agropecuaria por producto de Crédito.<br>" + message + ":" + exception);
			}
		});
	}
}

function consultaLineasCreditoAgro(idControl){
	var jqLineaCreditoID = eval("'#" + idControl + "'");
	var lineaCreditoID 	 = $(jqLineaCreditoID).val();

	var tipConPrincipal = 4;
	var lineaCreditoBeanCon = {
		'lineaCreditoID' : lineaCreditoID
	};

	if(lineaCreditoID != '' && !isNaN(lineaCreditoID)){
		lineasCreditoServicio.consulta(tipConPrincipal, lineaCreditoBeanCon, {
			async: false, callback: function(lineaCreditoBean){
				if(lineaCreditoBean != null){
					if( lineaCreditoBean.clienteID != $('#deudorOriginalID').asNumber()){
						mensajeSis("La Línea de Crédito no pertenece al cliente. Por tal motivo no puede realizarse operaciones en esta pantalla.");
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
						limpiaCamposLinea();
						$('#lineaCreditoID').val(lineaCreditoID);
						$(jqLineaCreditoID).select();
						$(jqLineaCreditoID).focus();
						return ;
					}

					if( lineaCreditoBean.estatus == 'I' || lineaCreditoBean.estatus == 'R' || lineaCreditoBean.estatus == 'E' ){
						var estatusLinea = "Rechazada";
						if( lineaCreditoBean.estatus == 'I' ){
							estatusLinea = "Inactiva";
						}
						if( lineaCreditoBean.estatus == 'E' ){
							estatusLinea = "Vencida";
						}
						mensajeSis("La Línea de Crédito esta en estatus "+ estatusLinea+". Por tal motivo no puede realizarse operaciones en esta pantalla.");
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
						limpiaCamposLinea();
						$('#lineaCreditoID').val(lineaCreditoID);
						$(jqLineaCreditoID).select();
						$(jqLineaCreditoID).focus();
						return ;
					}

					if( lineaCreditoBean.fechaInicio > fechaSucursal ){
						mensajeSis("La Fecha de Inicio de la Línea de Crédito es "+ lineaCreditoBean.fechaInicio+". Por tal motivo no puede realizarse operaciones con esta Línea de Crédito.");
						limpiaCamposLinea();
						$('#lineaCreditoID').val(lineaCreditoID);
						$(jqLineaCreditoID).select();
						$(jqLineaCreditoID).focus();
						return ;
					}

					montoLineaCreditoAgro = lineaCreditoBean.autorizado;
					forCobComAdmon = lineaCreditoBean.forCobComAdmon;
					forCobComGarantia = lineaCreditoBean.forCobComGarantia;
					manejaComAdmon = lineaCreditoBean.manejaComAdmon;
					manejaComGarantia = lineaCreditoBean.manejaComGarantia;
					porcentajeComAdmon = lineaCreditoBean.porcentajeComAdmon;
					porcentajeComGarantia = lineaCreditoBean.porcentajeComGarantia;

					$('#tipoLineaAgroID').val(lineaCreditoBean.tipoLineaAgroID);
					$('#saldoDisponible').val(lineaCreditoBean.saldoDisponible);
					$('#manejaComAdmon').val(lineaCreditoBean.manejaComAdmon);
					$('#porcentajeComAdmon').val(lineaCreditoBean.porcentajeComAdmon);

					$('#montoPagComAdmon').val(0.00);
					if($('#manejaComAdmon').val() == 'S'){
						var montoPagComAdmon = 0.00;
						var montoComisiones = 0.00;
						var montoIVAPagComAdmon = 0.00;

						switch(forCobComAdmon){
							case cat_ForCobComisiones.Disposicion:
								montoComisiones = $('#montoSolici').asNumber();
							break;
							case cat_ForCobComisiones.TotalPriDisposicion:
								montoComisiones = lineaCreditoBean.autorizado;
							break;
						}

						montoPagComAdmon = (montoComisiones * lineaCreditoBean.porcentajeComAdmon)/100;
						$('#montoPagComAdmon').val(montoPagComAdmon.toFixed(2));

						if( $('#pagaIVACte').val() == 'S' ){
							montoIVAPagComAdmon = $('#montoPagComAdmon').asNumber() * parametroBean.ivaSucursal;
						}

						$('#montoIvaPagComAdmon').val(montoIVAPagComAdmon.toFixed(2));
					}

					habilitaControl('forPagComAdmon');
					if( lineaCreditoBean.manejaComAdmon == 'N'){
						$('#cobroComAdmon').hide();
						deshabilitaControl('forPagComAdmon');
						deshabilitaControl('comAdmonLinPrevLiq');
					}
					else{
						$('#cobroComAdmon').show();
						habilitaControl('comAdmonLinPrevLiq');
						habilitaControl('manejaComAdmon');
					}

					var mensajeValidacion = '';
					// Si la lineas de credito es por cobro en Total en primer disposicion y la forma de cobro es NO se envia la alerta que
					//  ya se efectuo el cobro, por tal motivo se deshabilita la seccion de comisiones por admon y se se coloca todo como default
					if( lineaCreditoBean.manejaComAdmon == 'S' &&
						lineaCreditoBean.forCobComAdmon == cat_ForCobComisiones.TotalPriDisposicion &&
						lineaCreditoBean.cobraTolPriDisposicion == 'N'){
						$('#manejaComAdmon').val('N');
						$('#forPagComAdmon').val('');
						$('#montoPagComAdmon').val('0.00');
						$('#montoIvaPagComAdmon').val('0.00');
						$('#porcentajeComAdmon').val('0.00');
						deshabilitaControl('manejaComAdmon');
						deshabilitaControl('comAdmonLinPrevLiq');
						deshabilitaControl('forPagComAdmon');
						$('#cobroComAdmon').hide();
						mensajeValidacion = 'La Línea de Crédito tiene configurado la forma de Cobro Total en Primera Disposición, dicho cobro se' +
						 ' ha efectuado el día: ' + lineaCreditoBean.fechaCobroComision +
						', su próximo cobro a efectuar es el día: '+ lineaCreditoBean.fechaProximoCobro;
					}

					$('#manejaComGarantia').val(lineaCreditoBean.manejaComGarantia);
					$('#porcentajeComGarantia').val(lineaCreditoBean.porcentajeComGarantia);
					$('#montoComGarantia').val('');
					habilitaControl('forPagComGarantia');
					if( lineaCreditoBean.manejaComGarantia == 'N'){
						$('#cobroComGarantia').hide();
						deshabilitaControl('forPagComGarantia');
						deshabilitaControl('comGarLinPrevLiq');
					}else{
						$('#cobroComGarantia').show();
						habilitaControl('comGarLinPrevLiq');
						habilitaControl('manejaComGarantia');
					}

					$('#saldoDisponible').formatCurrency({
						positiveFormat : '%n',
						roundToDecimalPlace : 2
					});

					$('#porcentajeComAdmon').formatCurrency({
						positiveFormat : '%n',
						roundToDecimalPlace : 2
					});

					$('#porcentajeComGarantia').formatCurrency({
						positiveFormat : '%n',
						roundToDecimalPlace : 2
					});

					$('#montoPagComAdmon').formatCurrency({
						positiveFormat : '%n',
						roundToDecimalPlace : 2
					});

					$('#montoComGarantia').formatCurrency({
						positiveFormat : '%n',
						roundToDecimalPlace : 2
					});

					$('#montoIvaPagComAdmon').formatCurrency({
						positiveFormat : '%n',
						roundToDecimalPlace : 2
					});

					$('#montoIvaComGarantia').formatCurrency({
						positiveFormat : '%n',
						roundToDecimalPlace : 2
					});

					consultaTiposLineasAgro(lineaCreditoBean.tipoLineaAgroID, 1);

					if(lineaCreditoBean.estatus != 'A'){
						deshabilitaControl('tipoLineaAgroID');
						deshabilitaControl('saldoDisponible');
						deshabilitaControl('manejaComAdmon');
						deshabilitaControl('comAdmonLinPrevLiq');
						deshabilitaControl('forPagComAdmon');
						deshabilitaControl('porcentajeComAdmon');
						deshabilitaControl('montoPagComAdmon');
						deshabilitaControl('montoIvaPagComAdmon');
						deshabilitaControl('manejaComGarantia');
						deshabilitaControl('comGarLinPrevLiq');
						deshabilitaControl('forPagComGarantia');
						deshabilitaControl('montoComGarantia');
						deshabilitaControl('montoIvaComGarantia');
						deshabilitaControl('porcentajeComGarantia');
					}

					var montoSolicitado = $('#montoSolici').asNumber();
					var saldoDisponible = $('#saldoDisponible').asNumber();
					fechaVencimientoLinea = lineaCreditoBean.fechaVencimiento;

					// Si la solicitud esta en estatus inactiva se realizan las validaciones correspondientes
					var banderaBoton = 0;
					if( $('#estatus').val() == 'I' ){

						if( montoSolicitado > saldoDisponible ){
							banderaBoton = banderaBoton + 1;
							mensajeSis("El Monto solicitado es mayor al saldo disponible actual de la línea de crédito seleccionada.");
							$('#lineaCreditoID').focus();
							$('#lineaCreditoID').select();
						}

						if( $('#fechaVencimiento').val() > fechaVencimientoLinea ){
							banderaBoton = banderaBoton + 1;
							mensajeSis("La fecha de vencimiento de la Solicitud de Crédito excede a la fecha de vencimiento de la línea de Crédito.");
							$('#lineaCreditoID').focus();
							$('#lineaCreditoID').select();
						}

						if( banderaBoton > 0 ){
							if( $('#solicitudCreditoID').val() == 0 ){
								deshabilitaBoton('agregar', 'submit');
							} else {
								deshabilitaBoton('modificar', 'submit');
							}
							return ;
						} else {
							if( $('#solicitudCreditoID').val() == 0 ){
								habilitaBoton('agregar', 'submit');
							} else {
								habilitaBoton('modificar', 'submit');
							}
						}
					}

					$('#comGarLinPrevLiq').focus();
					$('#comGarLinPrevLiq').select();
					if( lineaCreditoBean.manejaComAdmon == 'S'){
						$('#comAdmonLinPrevLiq').focus();
						$('#comAdmonLinPrevLiq').select();
					}
					
					if(mensajeValidacion != '' ){
						mensajeSis(mensajeValidacion);
						$('#manejaComAdmon').focus();
						$('#manejaComAdmon').select();
					}

				}else{
					$(jqLineaCreditoID).focus();
					$(jqLineaCreditoID).select();
					fechaVencimientoLinea = '1900-01-01';
					montoLineaCreditoAgro = 0.00;
					forCobComAdmon = '';
					forCobComGarantia = '';
					manejaComAdmon = '';
					manejaComGarantia = '';
					porcentajeComAdmon = 0.00;
					porcentajeComGarantia = 0.00;
					limpiaCamposLinea();
					$('#lineaCreditoID').val(lineaCreditoID);
					mensajeSis("La Línea de Crédito Agropecuaria no Existe.");
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error en Consulta  de Línea de Crédito Agropecuaria.<br>" + message + ":" + exception);
			}
		});
	} else {
		deshabilitaCampoLinea();
		habilitaControl('lineaCreditoID');
		if(lineaCreditoID != '') {
			mensajeSis("El Número de Línea de Crédito no es Valido.");
			$('#lineaCreditoID').focus();
			$('#lineaCreditoID').select();
		}

		if( $('#solicitudCreditoID').val() == 0 ){
			habilitaBoton('agregar', 'submit');
		} else {
			habilitaBoton('modificar', 'submit');
		}
	}
}

//consulta el cliente
function consultaCliente(numCliente, calcularTasaCredito) {
	setTimeout("$('#cajaLista').hide();", 200);
	bloquearPantalla();
	if (numCliente != '' && !isNaN(numCliente)) {
		clienteServicio.consulta(1, numCliente, {
			async : false,
			callback : function(cliente) {
				if (cliente != null) {
					$('#nombreCte').val(cliente.nombreCompleto);
					if (cliente.esMenorEdad == "S") {
						mensajeSis("El " + $('#alertSocio').val() + " es Menor, No es Posible Asignar Crédito.");
						$('#clienteID').val("");
						$('#clienteID').focus();
						$('#nombreCte').val('');
					} else {
						$('#calificaCliente').val(cliente.calificaCredito);

						if (cliente.calificaCredito == 'N') {
							$('#calificaCredito').val('NO ASIGNADA');
						}
						if (cliente.calificaCredito == 'A') {
							$('#calificaCredito').val('EXCELENTE');
						}
						if (cliente.calificaCredito == 'C') {
							$('#calificaCredito').val('REGULAR');
						}
						if (cliente.calificaCredito == 'B') {
							$('#calificaCredito').val('BUENA');
						}

						if ($('#grupo').val() == undefined) {
							if ($.trim($('#productoCreditoID').val()) != "") {
								consultacicloCliente();
							}
						} else {
							if ($.trim($('#productoCreditoID').val()) != "" && $.trim($('#grupoID').asNumber()) > 0) {
								consultacicloCliente();
							}
						}

						esTab = true;

						$('#clienteID').val(cliente.numero);
						$('#nombreCte').val(cliente.nombreCompleto);
						$('#pagaIVACte').val(cliente.pagaIVA);

						$('#sucursalCte').val(cliente.sucursalOrigen);

						if ($('#solicitudCreditoID').val() == 0) {
							$('#promotorID').val(cliente.promotorActual);
						} else {
							$('#promotorID').val(solicitudPromotor);

						}

						// Consultamos la tasa si ya tenemos los datos necesarios
						if ($('#clienteID').asNumber() > 0 && $('#productoCreditoID').asNumber() > 0 && $('#calificaCliente').val() != '' && $('#montoSolici').asNumber() > 0 && $('#sucursalID').asNumber() > 0 && ($('#numCreditos').asNumber() > 0 || $('#cicloClienteGrupal').asNumber() > 0) && calcularTasaCredito == 'S' && ((esNomina == 'S' && $('#institucionNominaID').val().trim() != "") || esNomina != 'S')) {
							esTab = true;
							consultaTasaCredito($('#montoSolici').asNumber(), 'clienteID');
						}

						if ($('#solicitudCreditoID').val() == '' || $('#solicitudCreditoID').val() == '0') {
							if (cliente.estatus == "I") {

								deshabilitaBoton('agregar', 'submit');
								deshabilitaBoton('agregaConsolidacion', 'submit');
								mensajeSis("El " + $('#alertSocio').val() + " se encuentra Inactivo");
								$('#clienteID').focus();
								$('#nombrePromotor').val('');
								$('#nombreCte').val('');
								$('#promotorID').val('');
								$('#sucursalCte').val('');
								$('#calificaCredito').val('');
								$('#nombreSucursal').val('');
								$('#clienteID').val('');

							}
						} else {

							if (cliente.estatus == "I") {

								deshabilitaBoton('agregar', 'submit');
								deshabilitaBoton('modificar', 'submit');
								deshabilitaBoton('agregaConsolidacion', 'submit');
								deshabilitaBoton('liberar', 'submit');
								mensajeSis("El " + $('#alertSocio').val() + " se Encuentra Inactivo.");
								$('#solicitudCreditoID').focus();
							}
						}
						consultaSucursal('sucursalCte');
						consultaPromotor('promotorID');
						if (cliente.estatus == 'A') {
							//consultaRelacionCliente('clienteID');
						}

					}
				} else {
					if ($('#clienteID').asNumber() != '0') {
						mensajeSis("El " + $('#alertSocio').val() + " especificado no Existe.");
						$('#clienteID').val("");
						$('#clienteID').focus();
						$('#clienteID').select();
						$('#calificaCredito').val('');

					}
					clienteIDBase = "";
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error en Consulta del Cliente.<br>" + message + ":" + exception);
			}
		});
		// consulta la calificacion numerica del cliente
		clienteServicio.consulta(16, numCliente, function(cliente) {
			if (cliente != null) {
				calificacionCliente = cliente.calificacion;
			}
		});

	}
	desbloquearPantalla();
}

//consulta del Deudor Original
function consultaDeudorOriginal(deudorOriginal) {
	setTimeout("$('#cajaLista').hide();", 200);
	if (deudorOriginal != '' && !isNaN(deudorOriginal)) {
		clienteServicio.consulta(26, deudorOriginal, {
			async : false,
			callback : function(clienteResponse) {
				if (clienteResponse != null) {
					$('#nombreDeudorOriginal').val(clienteResponse.nombreCompleto);
					$('#deudorOriginalID').val(clienteResponse.numero);

					if( parseInt(deudorOriginalID, 0) != parseInt(clienteResponse.numero, 0) ){
						reiniciarTablaTemporal();
					}
					deudorOriginalID = clienteResponse.numero;
				} else {
					mensajeSis("El " + $('#alertSocio').val() + " especificado no Existe o no Cumple con los requisitos para una Consolidación.");
					$('#deudorOriginalID').focus();
					$('#nombreDeudorOriginal').val('');
					deudorOriginalID = 0;
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error en Consulta del Deudor Original.<br>" + message + ":" + exception);
			}
		});
	}
}


function consultaFechaDesembolso(){

	var folioConsolidacionID = $('#folioConsolidaID').val();
	var consolidacionesBean = {
		folioConsolidaID : folioConsolidacionID
	};

	setTimeout("$('#cajaLista').hide();", 200);
	if (folioConsolidacionID != '' && !isNaN(folioConsolidacionID)) {
		consolidacionesServicio.consultaConsolidacion(1, consolidacionesBean, {
			async : false,
			callback : function(consolidacionResponse) {
				if (consolidacionResponse != null) {
					$('#fechaDesembolso').val(consolidacionResponse.fechaDesembolso);
					$('#fechaPagoMinis1').val(consolidacionResponse.fechaDesembolso);

					var fechaAplicacion = parametroBean.fechaAplicacion;
					var fechaProyeccion = $('#fechaDesembolso').val();
					if( Date.parse(fechaProyeccion) > Date.parse(fechaAplicacion) ){
						banderaProyeccion = 1;
					}

				} else {
					mensajeSis("No Existe una fecha de Desembolso para el Folio de Consolidación.");
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error en Consulta de la Fecha de Desembolso.<br>" + message + ":" + exception);
			}
		});
	}
}

// Reinicio de Tabla Temporal
function crearTablaTemporal(){

	var consolidacionesBean = {
		folioConsolidaID 	: $('#folioConsolidaID').val(),
		solicitudCreditoID 	: $('#solicitudCreditoID').val(),
		transaccion 		: $('#numTransaccion').val(),
		tipoTransaccion		: 5
	};

	bloquearPantalla();
	$.post( 'consolidacionCreditoAgro.htm',consolidacionesBean,
		function(consolidacionesResponse) {
		desbloquearPantalla();
		if (consolidacionesResponse != null) {
			if( consolidacionesResponse.numero == 0 ){
				$('#creditosConsolidadosGrid').html("");
				$('#creditosConsolidadosGrid').hide();
				$('#folioConsolidaID').val(consolidacionesResponse.consecutivoInt);
				$('#numTransaccion').val(consolidacionesResponse.consecutivoString);
				mostrarCreditosConsolidado(consolidacionesResponse.consecutivoInt);
				consultaFechaDesembolso();
			} else {
				mensajeSis(consolidacionesResponse.descripcion);
			}
		} else {
			mensajeSis("Error en la creacion de la tabla para los Créditos Consolidados por solicitud.");
		}
	});
}

// Reinicio de Tabla Temporal
function reiniciarTablaTemporal(){

	if( $('#folioConsolidaID').val() != 0 ){
		var consolidacionesBean = {
			folioConsolidaID 	: $('#folioConsolidaID').val(),
			solicitudCreditoID 	: $('#solicitudCreditoID').val(),
			transaccion 		: $('#numTransaccion').val(),
			tipoTransaccion		: 3
		};

		bloquearPantalla();
		$.post( 'consolidacionCreditoAgro.htm',consolidacionesBean,{
			async : false,
			callback : function(consolidacionesResponse) {
				desbloquearPantalla();
				if (consolidacionesResponse != null) {
					if( consolidacionesResponse.numero == 0 ){
						$('#creditosConsolidadosGrid').html("");
						$('#creditosConsolidadosGrid').hide();
						$('#montoSolici').val(0.00);
						$('#diferenciaMinistra').val(0.00);
						$('#montoSolici').blur();
					} else {
						mensajeSis(consolidacionesResponse.descripcion);
					}
				} else {
					mensajeSis("Error en el Reinicio de la tabla para los Créditos Consolidados por solicitud.");
				}
			}
		});
	}
}


//consulta de Crédito
function consultaCredito(creditoID) {
	setTimeout("$('#cajaLista').hide();", 200);
	var creditoBean = {
		'creditoID' : creditoID
	};

	if (creditoID != '' && !isNaN(creditoID)) {
		consolidacionesServicio.consulta(1, creditoBean, {
			async : false,
			callback : function(creditoResponse) {
				if (creditoResponse != null) {
					$('#datosCredito').val(creditoResponse.descripcion);
					if($('#numTransaccion').val() == '') {
						$('#lineaCreditoID').val(creditoResponse.lineaCreditoID);
						if( creditoResponse.lineaCreditoID > 0 ){
							consultaLineasCreditoAgro('lineaCreditoID');
							deshabilitaControl('lineaCreditoID');
						}
					}
				} else {
					mensajeSis("El Crédito no Existe.");
					$('#datosCredito').val('');
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error en la Consulta del Crédito .<br>" + message + ":" + exception);
			}
		});
	}
}

//consulta de Crédito
function asignaTipoGarantia() {
	setTimeout("$('#cajaLista').hide();", 200);

	var consolidacionesBean = {
		folioConsolidaID 	: $('#folioConsolidaID').val(),
		transaccion 		: $('#numTransaccion').val()
	};

	var var_TipoGarantiaFIRAID = $('#tipoGarantiaFIRAID').val();
	consolidacionesServicio.consulta(3, consolidacionesBean, {
		async : false,
		callback : function(consolidacionesResponse) {
			if (consolidacionesResponse != null) {
				deshabilitaControl('tipoGarantiaFIRAID');

				if( consolidacionesResponse.activaCombo == 0 || consolidacionesResponse.activaCombo == '0' ){
					habilitaControl('tipoGarantiaFIRAID');
					$('#tipoGarantiaFIRAID').val(consolidacionesResponse.tipoGarantiaFIRAID);

					if(var_TipoGarantiaFIRAID != '' ){
						$('#tipoGarantiaFIRAID').val(var_TipoGarantiaFIRAID);
					}

				} else {
					$('#tipoGarantiaFIRAID').val(consolidacionesResponse.tipoGarantiaFIRAID);
				}

				$('#progEspecialFIRAID').val(consolidacionesResponse.progEspecialFIRAID);
				$('#progEspecialFIRAID').blur();
				$('#progEspecialFIRAID').focus();


				//$('#datosCredito').val(creditoResponse.descripcion);
			} else {
				mensajeSis("Error en la Consulta para Asignación de Garantía.");
			}
		},
		errorHandler : function(message, exception) {
			mensajeSis("Error en la Consulta para Asignación de Garantía.<br>" + message + ":" + exception);
		}
	});
}


//consulta validacion
function consultaClienteConsolidado(clienteID) {
	setTimeout("$('#cajaLista').hide();", 200);
	var solicitudCreditoBean = {
		'clienteID' : clienteID
	};

	if (clienteID != '' && !isNaN(clienteID)) {
		consolidacionesServicio.consulta(2, solicitudCreditoBean, {
			async : false,
			callback : function(consolidacionResponse) {
				if (consolidacionResponse != null) {

					mensajePersonalizado = "El Cliente No ha Completado Correctamente los Siguientes Flujos:<br>" ;
					var numero = 0;
					banderaCliente = 0;
					if( consolidacionResponse.dentificacion == 0 ){
						banderaCliente = 1;
						numero = numero + 1;
						mensajePersonalizado = mensajePersonalizado +'<p align="left">'+ numero +".- No Cuenta con una <b>Identificación Oficial.</b><br>";
					}

					if( consolidacionResponse.direccion == 0 ){
						banderaCliente = 1;
						numero = numero + 1;
						mensajePersonalizado = mensajePersonalizado +  numero +".- No Cuenta con una <b>Dirección Oficial</b>.</br>";
					}

					if( consolidacionResponse.cuentaAhorro == 0 ){
						banderaCliente = 1;
						numero = numero + 1;
						mensajePersonalizado = mensajePersonalizado + numero +".- No Tiene con una <b>Cuenta de Ahorro Activa.</b></br>";
					}

					mensajePersonalizado = mensajePersonalizado + '</p>';
					mensajeValidacion = mensajePersonalizado;
					esConsolidadoAgro = consolidacionResponse.esConsolidadoAgro;

				} else {
					mensajeSis("El " + $('#alertSocio').val() + " especificado no Existe o no Cumple con los requisitos para una Consolidación.");
					$('#clienteID').focus();
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error en Consulta del Cliente Consolidado.<br>" + message + ":" + exception);
			}
		});
	}
}


//funcion que llena el combo de tipo de pago capital, de  acuerdo al producto se usa sólo cuando se trata de una consulta de solicitud
function consultaComboTipoPagoCapSolicitud(tipoPago, valor) {
	if (tipoPago != null) {
		// se eliminan los tipos de pago que se tenian
		$('#tipoPagoCapital').each(function() {
			$('#tipoPagoCapital option').remove();
		});
		// se agrega la opcion por default
		$('#tipoPagoCapital').append(new Option('SELECCIONAR', '', true, true));

		var tpago = tipoPago.split(',');
		var tamanio = tpago.length;
		for (var i = 0; i < tamanio; i++) {
			var pagDescrip = '';
			switch (tpago[i]) {
				case "C" : // si el tipo de pago es CRECIENTES
					pagDescrip = 'CRECIENTES';
					break;
				case "I" :// si el tipo de pago es IGUALES
					pagDescrip = 'IGUALES';
					break;
				case "L" : // si el tipo de pago es LIBRES
					pagDescrip = 'LIBRES';
					break;
				default :
					pagDescrip = 'CRECIENTES';
			}
			$('#tipoPagoCapital').append(new Option(pagDescrip, tpago[i], true, true));
			// se selecciona la opcion por default
			$('#tipoPagoCapital').val(valor).selected = true;
		}
	}
}

//funcion que llena el combo de Frecuencias, de acuerdo al producto
//se utiliza sólo cuando se da de alta una solicitud de credito nueva.
function consultaComboFrecuencias(frecuencia) {
	if (frecuencia != null) {
		// se eliminan los tipos de pago que se tenian
		$('#frecuenciaCap').each(function() {
			$('#frecuenciaCap option').remove();
		});
		// se agrega la opcion por default
		$('#frecuenciaCap').append(new Option('SELECCIONAR', '', true, true));

		// se eliminan los tipos de pago que se tenian
		$('#frecuenciaInt').each(function() {
			$('#frecuenciaInt option').remove();
		});
		// se agrega la opcion por default
		$('#frecuenciaInt').append(new Option('SELECCIONAR', '', true, true));

		var frec = frecuencia.split(',');
		var tamanio = frec.length;

		for (var i = 0; i < tamanio; i++) {
			var frecDescrip = '';

			switch (frec[i]) {
				case "S" : // SEMANAL
					frecDescrip = 'SEMANAL';
					break;
				case "D" : // DECENAL
					frecDescrip = 'DECENAL';
					break;
				case "C" :// CATORCENAL
					frecDescrip = 'CATORCENAL';
					break;
				case "Q" : // QUINCENAL
					frecDescrip = 'QUINCENAL';
					break;
				case "M" : // MENSUAL
					frecDescrip = 'MENSUAL';
					break;
				case "B" : // BIMESTRAL
					frecDescrip = 'BIMESTRAL';
					break;
				case "T" : // TRIMESTRAL
					frecDescrip = 'TRIMESTRAL';
					break;
				case "R" : // TETRAMESTRAL
					frecDescrip = 'TETRAMESTRAL';
					break;
				case "E" : // SEMESTRAL
					frecDescrip = 'SEMESTRAL';
					break;
				case "A" : // ANUAL
					frecDescrip = 'ANUAL';
					break;
				case "P" : // PERIODO
					frecDescrip = 'PERIODO';
					break;
				case "U" : // PAGO UNICO
					frecDescrip = 'PAGO UNICO';
					break;
				case "L" : // PAGO UNICO
					frecDescrip = 'LIBRE';
					break;
				default :
					frecDescrip = 'SEMANAL';
			}
			$('#frecuenciaCap').append(new Option(frecDescrip, frec[i], true, true));
			$('#frecuenciaInt').append(new Option(frecDescrip, frec[i], true, true));
			$('#frecuenciaCap').val('').selected = true;
			$('#frecuenciaInt').val('').selected = true;
		}
	}
}

//funcion que llena el combo de Frecuencias, de acuerdo al producto se utiliza sólo cuando se consulta una solicitud de credito
function consultaComboFrecuenciasSolicitud(frecuencia, valorCap, valorInt) {

	if (frecuencia != null) {
		// se eliminan los tipos de pago que se tenian
		$('#frecuenciaCap').each(function() {
			$('#frecuenciaCap option').remove();
		});
		// se agrega la opcion por default
		$('#frecuenciaCap').append(new Option('SELECCIONAR', '', true, true));

		// se eliminan los tipos de pago que se tenian
		$('#frecuenciaInt').each(function() {
			$('#frecuenciaInt option').remove();
		});
		// se agrega la opcion por default
		$('#frecuenciaInt').append(new Option('SELECCIONAR', '', true, true));

		var frec = frecuencia.split(',');
		var tamanio = frec.length;

		for (var i = 0; i < tamanio; i++) {
			var frecDescrip = '';

			switch (frec[i]) {
				case "S" : // SEMANAL
					frecDescrip = 'SEMANAL';
					break;
				case "D" : // DECENAL
					frecDescrip = 'DECENAL';
					break;
				case "C" :// CATORCENAL
					frecDescrip = 'CATORCENAL';
					break;
				case "Q" : // QUINCENAL
					frecDescrip = 'QUINCENAL';
					break;
				case "M" : // MENSUAL
					frecDescrip = 'MENSUAL';
					break;
				case "B" : // BIMESTRAL
					frecDescrip = 'BIMESTRAL';
					break;
				case "T" : // TRIMESTRAL
					frecDescrip = 'TRIMESTRAL';
					break;
				case "R" : // TETRAMESTRAL
					frecDescrip = 'TETRAMESTRAL';
					break;
				case "E" : // SEMESTRAL
					frecDescrip = 'SEMESTRAL';
					break;
				case "A" : // ANUAL
					frecDescrip = 'ANUAL';
					break;
				case "P" : // PERIODO
					frecDescrip = 'PERIODO';
					break;
				case "U" : // PAGO UNICO
					frecDescrip = 'PAGO UNICO';
					break;
				case "L" : // PAGO LIBRE
					frecDescrip = 'LIBRE';
					break;
				default :
					frecDescrip = 'SEMANAL';
			}
			$('#frecuenciaCap').append(new Option(frecDescrip, frec[i], true, true));
			$('#frecuenciaInt').append(new Option(frecDescrip, frec[i], true, true));
			$('#frecuenciaCap').val(valorCap).selected = true;
			$('#frecuenciaInt').val(valorInt).selected = true;
		}
	}
}

//funcion que llena el combo de plazos, de acuerdo al producto sólo cuando se trata de una solicitud de credito nueva
function consultaComboPlazos(varPlazos) {
	// se eliminan los tipos de pago que se tenian
	$('#plazoID').each(function() {
		$('#plazoID option').remove();
	});
	// se agrega la opcion por default
	$('#plazoID').append(new Option('SELECCIONAR', '', true, true));

	if (varPlazos != null) {
		var plazo = varPlazos.split(',');
		var tamanio = plazo.length;
		plazosCredServicio.listaCombo(3, {
			callback : function(plazoCreditoBean) {
				for (var i = 0; i < tamanio; i++) {
					for (var j = 0; j < plazoCreditoBean.length; j++) {
						if (plazo[i] == plazoCreditoBean[j].plazoID) {
							$('#plazoID').append(new Option(plazoCreditoBean[j].descripcion, plazo[i], true, true));
							$('#plazoID').val('').selected = true;
							break;
						}
					}
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error al Consultar Plazos.<br>" + message + ":" + exception);
			}
		});
	}
}

//funcion que llena el combo de calcInteres
function consultaComboCalInteres() {
	dwr.util.removeAllOptions('calcInteresID');
	formTipoCalIntServicio.listaCombo(1, function(formTipoCalIntBean) {
		dwr.util.addOptions('calcInteresID', {
			'' : 'SELECCIONAR'
		});
		dwr.util.addOptions('calcInteresID', formTipoCalIntBean, 'formInteresID', 'formula');
	});
}

//funcion que llena el combo de plazos, de acuerdo al producto se usa cuando se consulta una solicitud de credito
function consultaComboPlazosSolicitud(varPlazos, plazoValor) {
	// se eliminan los tipos de pago que se tenian
	$('#plazoID').each(function() {
		$('#plazoID option').remove();
	});
	// se agrega la opcion por default
	$('#plazoID').append(new Option('SELECCIONAR', '', true, true));
	if (varPlazos != null) {
		var plazo = varPlazos.split(',');
		var tamanio = plazo.length;
		plazosCredServicio.listaCombo(3, function(plazoCreditoBean) {
			for (var i = 0; i < tamanio; i++) {
				for (var j = 0; j < plazoCreditoBean.length; j++) {
					if (plazo[i] == plazoCreditoBean[j].plazoID) {
						$('#plazoID').append(new Option(plazoCreditoBean[j].descripcion, plazo[i], true, true));
						$('#plazoID').val(plazoValor).selected = true;
						break;
					}
				}
			}
		});
	}
}

//funcion que llena el combo tipo dispersion, de acuerdo al producto se usa cuando se da de alta una solicitud nueva
function consultaComboTipoDispersion(tiposDispersion) {
	if (tiposDispersion != null) {
		// se eliminan los tipos de pago que se tenian
		$('#tipoDispersion').each(function() {
			$('#tipoDispersion option').remove();
		});
		// se agrega la opcion por default
		$('#tipoDispersion').append(new Option('SELECCIONAR', '', true, true));

		var tipoDispersion = tiposDispersion.split(',');
		var tamanio = tipoDispersion.length;
		for (var i = 0; i < tamanio; i++) {
			switch (tipoDispersion[i]) {
				case "S" : // SPEI
					disperDescrip = 'SPEI';
					break;
				case "C" :// CHEQUE
					disperDescrip = 'CHEQUE';
					break;
				case "O" : // ORDEN DE PAGO
					disperDescrip = 'ORDEN DE PAGO';
					break;
				case "E" : // EFECTIVO
					disperDescrip = 'EFECTIVO';
					break;
				default :
					disperDescrip = 'SPEI';
			}

			$('#tipoDispersion').append(new Option(disperDescrip, tipoDispersion[i], true, true));
			$('#tipoDispersion').val('').selected = true;
		}
	}
}

//funcion que llena el combo tipo dispersion, de acuerdo al  producto se usa cuando se consulta una solicitud de credito
function consultaComboTipoDispersionSolicitud(tiposDispersion, valor) {
	if (tiposDispersion != null) {
		// se eliminan los tipos de pago que se tenian
		$('#tipoDispersion').each(function() {
			$('#tipoDispersion option').remove();
		});
		// se agrega la opcion por default
		$('#tipoDispersion').append(new Option('SELECCIONAR', '', true, true));

		var tipoDispersion = tiposDispersion.split(',');
		var tamanio = tipoDispersion.length;
		for (var i = 0; i < tamanio; i++) {
			switch (tipoDispersion[i]) {
				case "S" : // SPEI
					disperDescrip = 'SPEI';
					break;
				case "C" :// CHEQUE
					disperDescrip = 'CHEQUE';
					break;
				case "O" : // ORDEN DE PAGO
					disperDescrip = 'ORDEN DE PAGO';
					break;
				case "E" : // EFECTIVO
					disperDescrip = 'EFECTIVO';
					break;
				default :
					disperDescrip = 'SPEI';
			}

			$('#tipoDispersion').append(new Option(disperDescrip, tipoDispersion[i], true, true));
			$('#tipoDispersion').val(valor).selected = true;
		}
	}
}

//funcion que deshabilita parametros calendario consulta las cuotas de interes
function consultaCuotasInteres(idControl) {
	var jqPlazo = eval("'#" + idControl + "'");
	var plazo = $(jqPlazo).val();
	var tipoCon = 3;

	var PlazoBeanCon = {
		'plazoID' : plazo,
		'fechaActual' : $('#fechaInicioAmor').val(),
		'frecuenciaCap' : $('#frecuenciaInt').val()
	};
	if (plazo == '0') {
		$('#fechaVencimiento').val("");
	} else {
		if ($('#frecuenciaInt').val() != "") {
			plazosCredServicio.consulta(tipoCon, PlazoBeanCon, function(plazos) {
				if (plazos != null) {
					$('#numAmortInteres').val(plazos.numCuotas);
					// se utiliza para saber cuando se agrega o quita una cuota
					NumCuotasInt = parseInt(plazos.numCuotas);
				}
			});
		}
	}
}

//consulta del promotor
function consultaPromotor(idControl) {
	var jqPromotor = eval("'#" + idControl + "'");
	var numPromotor = $(jqPromotor).val();
	var tipConForanea = 2;
	var promotor = {
		'promotorID' : numPromotor
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (numPromotor != '' && !isNaN(numPromotor) && esTab) {
		promotoresServicio.consulta(tipConForanea, promotor, function(promotor) {
			if (promotor != null) {
				$('#nombrePromotor').val(promotor.nombrePromotor);

			} else {
				if ($('#promotorID').val() != 0 && $('#prospectoID').val() != 0) {
					mensajeSis("No Existe el Promotor.");
				}
				$('#nombrePromotor').val("");
			}
		});
	}
}

//consulta de la fecha de vencimiento en base al plazo
function consultaFechaVencimiento(idControl) {
	var jqPlazo = eval("'#" + idControl + "'");
	var plazo = $(jqPlazo).val();
	var tipoCon = 3;
	var PlazoBeanCon = {
		'plazoID' : plazo,
		'fechaActual' : $('#fechaInicioAmor').val(),
		'frecuenciaCap' : $('#frecuenciaCap').val()
	};
	if (plazo == '') {
		$('#fechaVencimiento').val("");
	} else {
		plazosCredServicio.consulta(tipoCon, PlazoBeanCon, function(plazos) {
			if (plazos != null) {
				//Se actualiza la fecha de la primera ministracion
				$('#fechaPagoMinis1').val(parametroBean.fechaAplicacion);
				$('#fechaVencimiento').val(plazos.fechaActual);
				if ($('#frecuenciaCap').val() != "U") {
					$('#numAmortizacion').val(plazos.numCuotas);
					if ($('#tipoPagoCapital').val() == 'C') {
						$('#numAmortInteres').val(plazos.numCuotas);
						NumCuotasInt = plazos.numCuotas; // se utiliza para saber cuando se agrega o quita una cuota
					} else {
						$('#numAmortizacion').val(plazos.numCuotas);

						if ($('#perIgual').val() == "S") {
							$('#numAmortInteres').val(plazos.numCuotas);

							NumCuotasInt = plazos.numCuotas; // se utiliza para saber cuando se agrega o quita una cuota

						} else {
							consultaCuotasInteres('plazoID');
						}
					}
					NumCuotas = plazos.numCuotas; //se
					// utiliza para saber cuando se agrega o quita una cuota calculo de numero de dias
					calculaNodeDias(plazos.fechaActual);
				} else {
					$('#numAmortizacion').val("1");
					NumCuotas = 1; // se utiliza para saber cuando se agrega o quita una cuota
					calculaNodeDias(plazos.fechaActual);
				}
				fechaVencimientoInicial = plazos.fechaActual;
			}
		});
	}
}

//funcion que calcula la comision por apertura e iva de credito de acuerdo al producto de credito seleccionado
function consultaComisionAper() {
	var ProdCred = $('#productoCreditoID').val();
	var ProdCredBeanCon = {
		'producCreditoID' : ProdCred
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (ProdCred != '' && !isNaN(ProdCred) && esTab) {
		productosCreditoServicio.consulta(enum_productos_con.agropecuario, ProdCredBeanCon, {
			async : false,
			callback : function(prodCred) {
				if (prodCred != null) {
					mostrarLabelTasaFactorMora(prodCred.tipCobComMorato);
					esTab = true;
					formaCobroComApe = prodCred.formaComApertura;
					// si es por porcentaje
					if (prodCred.montoComXapert > 0) {
						if (prodCred.tipoComXapert == 'P') {
							montoComApeBase = montoSolicitudBase * (prodCred.montoComXapert / 100);
							$('#montoComApert').val(montoComApeBase);
							$('#montoComApert').formatCurrency({
								positiveFormat : '%n',
								roundToDecimalPlace : 2
							});
						} else {
							// si es por monto
							if (prodCred.tipoComXapert == 'M') {
								montoComApeBase = prodCred.montoComXapert;
								$('#montoComApert').val(prodCred.montoComXapert);
								$('#montoComApert').formatCurrency({
									positiveFormat : '%n',
									roundToDecimalPlace : 2
								});

							}
						}
					}
					// ya teniendo el monto de la comision se calcula el iva
					consultaIVASucursal();
				}
			}
		});
	}
}

//funcion que calcula el IVA de la comision por apertura de
//credito de acuerdo a la sucursal del cliente
function consultaIVASucursal() {
	var numSucursal = $('#sucursalCte').val();
	setTimeout("$('#cajaLista').hide();", 200);
	if (numSucursal != '' && !isNaN(numSucursal) && esTab) {
		sucursalesServicio.consultaSucursal(1, numSucursal, {
			async : false,
			callback : function(sucursal) {
				if (sucursal != null) {
					var iva = sucursal.IVA;
					// si el cliente paga iva
					if ($('#pagaIVACte').val() == 'S') {
						montoIvaComApeBase = (montoComApeBase * iva);
						$('#ivaComApert').val(montoIvaComApeBase);
						$('#ivaComApert').formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 2
						});

					} else {
						// si el cliente no paga iva
						if ($('#pagaIVACte').val() == 'N') {
							$('#ivaComApert').val("0.00");
							montoIvaComApeBase = 0;
						}
					}
					// si es forma de cobro por Financiamiento
					if (formaCobroComApe == "F") {
						montoComIvaSol = parseFloat(montoComApeBase) + parseFloat(montoIvaComApeBase) + parseFloat(montoSolicitudBase);
						if (montoSolicitudBase > 0) {
							$('#montoSolici').val(montoComIvaSol);
							$('#montoSolici').formatCurrency({
								positiveFormat : '%n',
								roundToDecimalPlace : 2
							});
						}
					}

					calculaNodeDias($('#fechaVencimiento').val());
				}
			}
		});
	}
}

//consulta el destino de credito metodo que se llama cuando pierde el foco la cajita de Destinos de credito
function consultaDestinoCredito(idControl) {
	$('#clasifiDestinCred').val('');

	var jqDestino = eval("'#" + idControl + "'");
	var DestCred = $(jqDestino).val();
	var DestCredBeanCon = {
		'producCreditoID' : $('#productoCreditoID').val(),
		'destinoCreID' : DestCred
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (DestCred != '' && !isNaN(DestCred) && esTab) {
		destinosCredServicio.consulta(2, DestCredBeanCon, function(destinos) {
			if (destinos != null) {
				$('#descripDestino').val(destinos.descripcion);
				$('#descripDestinoFR').val(destinos.desCredFR);
				$('#descripDestinoFOMUR').val(destinos.desCredFOMUR);
				$('#destinCredFRID').val(destinos.destinCredFRID);
				$('#destinCredFOMURID').val(destinos.destinCredFOMURID);

				if (destinos.clasificacion == Comercial) {
					$('#clasificacionDestin1').attr("checked", true);
					$('#clasificacionDestin2').attr("checked", false);
					$('#clasificacionDestin3').attr("checked", false);
					$('#clasifiDestinCred').val('C');
				} else if (destinos.clasificacion == Consumo) {
					$('#clasificacionDestin1').attr("checked", false);
					$('#clasificacionDestin2').attr("checked", true);
					$('#clasificacionDestin3').attr("checked", false);
					$('#clasifiDestinCred').val('O');
				} else {
					$('#clasificacionDestin1').attr("checked", false);
					$('#clasificacionDestin2').attr("checked", false);
					$('#clasificacionDestin3').attr("checked", true);
					$('#clasifiDestinCred').val('H');
				}
			} else {
				mensajeSis("No Existe el Destino de Crédito.");
				$('#destinoCreID').focus();
				$('#destinoCreID').select();
				$('#destinoCreID').val("");
				$('#descripDestino').val("");
			}
		});
	}
}

//-----------consulta el destino de credito metodo se llama cuando se consulta la solicitud ya que para consultar se consulta
//el campo de Clasificacion que se encuentra en la tabla de solictud de credito. y no la de la tabla de DESTINOSCREDITO
function consultaDestinoCreditoSolicitud(idControl) {
	$('#clasifiDestinCred').val('');

	var jqDestino = eval("'#" + idControl + "'");
	var DestCred = $(jqDestino).val();
	var DestCredBeanCon = {
		'destinoCreID' : DestCred
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (DestCred != '' && !isNaN(DestCred) && esTab) {
		destinosCredServicio.consulta(2, DestCredBeanCon, function(destinos) {
			if (destinos != null) {
				$('#descripDestino').val(destinos.descripcion);

				$('#descripDestinoFR').val(destinos.desCredFR);
				$('#descripDestinoFOMUR').val(destinos.desCredFOMUR);

				$('#destinCredFRID').val(destinos.destinCredFRID);
				$('#destinCredFOMURID').val(destinos.destinCredFOMURID);

			} else {
				mensajeSis("No Existe el Destino de Crédito.");
				$('#destinoCreID').focus();
				$('#destinoCreID').select();
				$('#descripDestino').val("");
			}
		});
	}
}

//-------------consulta la sucursal--------------------
function consultaSucursal(idControl) {
	var jqSucursal = eval("'#" + idControl + "'");
	var numSucursal = $(jqSucursal).val();
	var conSucursal = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numSucursal != '' && !isNaN(numSucursal) && esTab) {
		sucursalesServicio.consultaSucursal(conSucursal, numSucursal, function(sucursal) {
			if (sucursal != null) {
				$('#nombreSucursal').val(sucursal.nombreSucurs);
			} else {
				mensajeSis("No Existe la Sucursal.");
			}
		});
	}
}

//----------------------consulta la tasa base --------------------
function consultaTasaBase(idControl, desdeInput) {
	var jqTasa = eval("'#" + idControl + "'");
	var tasaBase = $(jqTasa).asNumber();
	var TasaBaseBeanCon = {
		'tasaBaseID' : tasaBase
	};
	setTimeout("$('#cajaLista').hide();", 200);

	if (tasaBase > 0 && esTab) {
		tasasBaseServicio.consulta(1, TasaBaseBeanCon, function(tasasBaseBean) {
			if (tasasBaseBean != null) {
				hayTasaBase = true;
				$('#desTasaBase').val(tasasBaseBean.nombre);
				valorTasaBase = tasasBaseBean.valor;
				if (desdeInput) {
					$('#tasaFija').val(valorTasaBase).change();
				}
				$('#tasaFija').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 4
				});
			} else {
				hayTasaBase = false;
				mensajeSis("No Existe la Tasa Base.");
				$('#tasaBase').focus();
				$('#tasaBase').val('');
				$('#desTasaBase').val('');
				$('#tasaFija').val('').change();
			}
		});
	}
}

//-----------------consulta el prospecto----------------------------
function consultaProspecto(idControl) {

	var jqProspecto = eval("'#" + idControl + "'");
	var numProspecto = $(jqProspecto).val();
	setTimeout("$('#cajaLista').hide();", 200);

	var prospectoBeanCon = {
		'prospectoID' : numProspecto
	};

	tipoConProspForanea = 2;

	if (numProspecto != '' && !isNaN(numProspecto) && esTab) {
		prospectosServicio.consulta(tipoConProspForanea, prospectoBeanCon, function(prospectos) {
			if (prospectos != null) {
				if (prospectos.cliente != '' && prospectos.cliente != null) {
					$('#clienteID').val(prospectos.cliente);
					$('#nombreProspecto').val("");
					$('#prospectoID').val("");
					habilitaControl('clienteID');
				} else {
					soloLecturaControl('clienteID');
					$('#clienteID').val('');
					$('#nombreCte').val('');
					$('#nombreProspecto').val(prospectos.nombreCompleto);
					$('#sucursalCte').val(parametroBean.sucursal);
					esTab = true;
					consultaSucursal('sucursalCte');
					consultaCalificacion('prospectoID');
					$('#productoCreditoID').focus();
				}

				consultaRelacionCliente('prospectoID');
				if ($('#grupo').val() == undefined) {
					if ($.trim($('#productoCreditoID').val()) != "") {
						consultacicloCliente();
					}
				} else {
					if ($.trim($('#productoCreditoID').val()) != "" && $.trim($('#grupoID').asNumber()) > 0) {
						consultacicloCliente();
					}
				}
			} else {
				if ($('#prospectoID').asNumber() != '0') {
					mensajeSis("No Existe el Prospecto.");
					$('#prospectoID').val('');
					$('#prospectoID').focus();
					$('#prospectoID').select();
					$('#nombrePromotor').val('');
				}
			}
		});

	}
}

function consultaCalificacion(idControl) {
	var jqProspectos = eval("'#" + idControl + "'");
	var numProspectos = $(jqProspectos).val();
	setTimeout("$('#cajaLista').hide();", 200);
	var prospectoBeanCons = {
		'prospectoID' : numProspectos
	};
	var tipoConProspCal = 4;
	prospectosServicio.consulta(tipoConProspCal, prospectoBeanCons, function(calificacion) {
		if (calificacion != null) {
			$('#calificaCliente').val(calificacion.calificaProspectos);
			if (calificacion.calificaProspectos == 'N') {
				$('#calificaCredito').val('NO ASIGNADA');
			}
			if (calificacion.calificaProspectos == 'A') {
				$('#calificaCredito').val('EXCELENTE');
			}
			if (calificacion.calificaProspectos == 'C') {
				$('#calificaCredito').val('REGULAR');
			}
			if (calificacion.calificaProspectos == 'B') {
				$('#calificaCredito').val('BUENA');
			}

		} else {
			mensajeSis("El Prospecto no tiene Calificación Asignada.");
			$(jqProspectos).val('');
		}
	});
}

//----------------consulta la institucion de fondeo----------------
function consultaInstitucionFondeo(idControl) {
	var numInstituto = $("#institutFondID").asNumber();
	var instFondeoBeanCon = {
		'institutFondID' : numInstituto
	};

	mostrarElementoPorClase('mostrarAcredFIRA', false);
	mostrarElementoPorClase('mostrarAcred', false);
	mostrarElementoPorClase('mostrarCred', false);
	setTimeout("$('#cajaLista').hide();", 200);

	if (numInstituto > 0) {
		fondeoServicio.consulta(2, instFondeoBeanCon, {
			callback : function(instituto) {
				if (instituto != null) {
					$('#descripFondeo').val(instituto.nombreInstitFon);
					if(instituto.capturaIndica!=null && instituto.capturaIndica!=''){
						if(busca(instituto.capturaIndica,'A')){
							mostrarElementoPorClase('mostrarAcred', true);
							mostrarElementoPorClase('mostrarCredS', true);
							mostrarElementoPorClase('mostrarAcredFIRA', true);
						}

						if(busca(instituto.capturaIndica,'C')){
							mostrarElementoPorClase('mostrarAcredFIRA', true);
							if(busca(instituto.capturaIndica,'A')){
								mostrarElementoPorClase('mostrarCredS', true);
							} else {
								mostrarElementoPorClase('mostrarCredS', false);
							}

							mostrarElementoPorClase('mostrarCred', true);
						}
					}

				} else {
					if ($('#institutFondID').asNumber() > '0') {
						if ($('input[name=tipoFondeo]:checked').val() == Enum_TipoFondeo.RecursosPropios) {
							$('#institutFondID').val('0');
							$('#descripFondeo').val('');

						} else {
							mensajeSis("No Existe la Institución.");
							$('#institutFondID').focus();
							$('#institutFondID').select();
							$('#descripFondeo').val('');
						}
					}
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error en Consulta de la Institución de Fondeo.<br>" + message + ":" + exception);
			}
		});
	}
}

//---------- consulta linea de fondeo ---------------------------
function consultaLineaFondeo(control) {
	var transaccionOperacion =$('#numTransaccion').val();
	var ID_institucion = $('#institutFondID').asNumber();
	var numLinea = $('#lineaFondeoID').val();
	setTimeout("$('#cajaLista').hide();", 200);
	if (numLinea != '' && numLinea != '0' && !isNaN(numLinea) && esTab) {
		var lineaFondBeanCon = {
			'lineaFondeoID' : $('#lineaFondeoID').val()
		};

		lineaFonServicio.consulta(1, lineaFondBeanCon, {
			callback : function(lineaFond) {
				if (lineaFond != null) {
					if (ID_institucion != lineaFond.institutFondID) {
						mensajeSis("La Linea de Fondeo no Corresponde con la Institución.");
						$('#lineaFondeoID').val('');
						$('#descripLineaFon').val('');
						$('#saldoLineaFon').val('');
						$('#tasaPasiva').val('');
						$('#lineaFondeoID').focus();
					}else{

					dwr.util.setValues(lineaFond);
					$('#numTransaccion').val(transaccionOperacion);
					var fechInicio = $('#fechaInicio').val();
					var fechUltAmorti = $('#valorFecUltAmor').val();
					$('#descripLineaFon').val(lineaFond.descripLinea);
					$('#saldoLineaFon').val(lineaFond.saldoLinea);
					$('#institutFondID').val(lineaFond.institutFondID);

					if($('#tasaPasiva').asNumber()==0){
						$('#tasaPasiva').val(lineaFond.tasaPasiva);
					}
					$('#folioFondeo').val(lineaFond.folioFondeo);
					var instFondeo = $('#institutFondID').asNumber();
					$('#saldoLineaFon').formatCurrency({
						positiveFormat : '%n',
						roundToDecimalPlace : 2
					});


					if (fechInicio < lineaFond.fechInicLinea && instFondeo > '0') {
						mensajeSis("La Fecha de Registro es Inferior a la de Inicio de la Linea de Fondeo.");
						$('#lineaFondeoID').focus();
					}
					if (fechInicio > lineaFond.fechaFinLinea && instFondeo > '0') {
						mensajeSis("La Fecha de Registro es Superior a la de Fin de la Linea de Fondeo.");
						$('#lineaFondeoID').focus();
					}
					var numTran = $('#numTransacSim').val();
					if (numTran != '0' || numTran != '' && instFondeo > '0') {
						if (fechUltAmorti > lineaFond.fechaMaxVenci) {
							mensajeSis("La Fecha de Vencimiento de la Última Amortización es Superior a la Fecha de Vencimiento la Linea de Fondeo.");
							$('#lineaFondeoID').focus();
						}
					}
					quitaFormatoControles('formaGenerica');
					var saldoLinFon = $('#saldoLineaFon').val();
					var montoCred = $('#montoSolici').val();
					var saldo = parseFloat(saldoLinFon);
					var monto = parseFloat(montoCred);
					agregaFormatoControles('formaGenerica');
					if ($('#tipoFondeo2').is(':checked')) {
						if (monto > saldo && instFondeo > '0') {
							mensajeSis("La Línea de Fondeo no tiene Saldo Suficiente.");
						}
					} else {
						$('#acreditadoIDFIRA').val("");
						$('#creditoIDFIRA').val("");
						mostrarElementoPorClase('mostrarAcredFIRA', false);
						mostrarElementoPorClase('mostrarAcred', false);
						mostrarElementoPorClase('mostrarCred', false);
					}
					$('#institutFondID').val(lineaFond.institutFondID);
					$('input[name="tipoFondeo"]').change();
				}
				} else {
					var linea = $('#lineaFondeoID').asNumber();
					var instit = $('#institutFondID').asNumber();
					if (linea > '0' && instit > '0') {
						mensajeSis("No Existe la Linea Fondeador.");
						$('#lineaFondeoID').focus();
						$('#lineaFondeoID').select();
						$('#lineaFondeoID').val('');
						$('#institutFondID').val('');
						$('#descripLineaFon').val('');
						$('#saldoLineaFon').val('');
						$('#tasaPasiva').val('');
						$('#lineaFondeoID').focus();
					}
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error en Consulta de la Linea de Fondeo.<br>" + message + ":" + exception);
			}
		});
	}
}

//---------------------valida la linea de fondeo al hacer el submit---------------------
function validaLineaFondeo() {

	var numLinea = $('#lineaFondeoID').val();
	setTimeout("$('#cajaLista').hide();", 200);
	if (numLinea != '' && !isNaN(numLinea) && esTab) {
		var lineaFondBeanCon = {
			'lineaFondeoID' : $('#lineaFondeoID').val()
		};

		lineaFonServicio.consulta(1, lineaFondBeanCon, {
			callback : function(lineaFond) {
				if (lineaFond != null) {
					dwr.util.setValues(lineaFond);
					var fechInicio = $('#fechaInicio').val();
					var fechUltAmorti = $('#valorFecUltAmor').val();
					var instFondeo = $('#institutFondID').asNumber();
					$('#descripLineaFon').val(lineaFond.descripLinea);
					$('#saldoLineaFon').val(lineaFond.saldoLinea);
					$('#saldoLineaFon').formatCurrency({
						positiveFormat : '%n',
						roundToDecimalPlace : 2
					});
					if (instFondeo != lineaFond.institutFondID && instFondeo != '0') {
						mensajeSis("La Linea de Fondeo no Corresponde con la Institución.");
						$('#lineaFondeoID').val('');
						$('#institutFondID').val(instFondeo);
						$('#descripLineaFon').val('');
						$('#saldoLineaFon').val('');
						$('#tasaPasiva').val('');
						$('#lineaFondeoID').focus();
						procede = 1;
					} else {
						if (fechInicio < lineaFond.fechInicLinea && instFondeo != '0') {
							mensajeSis("La Fecha de Registro es Inferior a la de Inicio de la Linea de Fondeo.");
							$('#lineaFondeoID').focus();
							procede = 1;
						} else {
							if (fechInicio > lineaFond.fechaFinLinea && instFondeo != '0') {
								mensajeSis("La Fecha de Registro es Superior a la de Fin de la Linea de Fondeo.");
								$('#lineaFondeoID').focus();
								procede = 1;
							} else {
								if ($('#numTransacSim').asNumber() != '0' || $('#numTransacSim').val() != '' && instFondeo != '0') {
									if (fechUltAmorti > lineaFond.fechaMaxVenci) {
										mensajeSis("La Fecha de Vencimiento de la Última Amortización es Superior a la Fecha de Vencimiento la Linea de Fondeo.");
										$('#lineaFondeoID').focus();
										procede = 1;
									} else {
										if ($('#tipoFondeo2').is(':checked')) {
											if ($('#montoSolici').asNumber() > $('#saldoLineaFon').asNumber() && instFondeo != '0') {
												mensajeSis("La Linea de Fondeo no tiene Saldo Suficiente.");
												procede = 1;
											} else {
												procede = 0;
											}
										} else {
											procede = 0;
										}
									}
								} else {
									if ($('#tipoFondeo2').is(':checked')) {
										if ($('#montoSolici').asNumber() > $('#saldoLineaFon').asNumber() && instFondeo != '0') {
											mensajeSis("La Linea de Fondeo no tiene Saldo Suficiente.");
											procede = 1;
										} else {
											procede = 0;
										}
									} else {
										procede = 0;
									}
								}
							}
						}
					}
				} else {
					var linea = $('#lineaFondeoID').val();
					var instit = $('#institutFondID').val();
					if (linea != '0' && instit != '0') {
						mensajeSis("No Existe la Linea Fondeador.");
						$('#lineaFondeoID').focus();
						$('#lineaFondeoID').select();
						$('#lineaFondeoID').val('');
						$('#institutFondID').val('');
						$('#descripLineaFon').val('');
						$('#saldoLineaFon').val('');
						$('#tasaPasiva').val('');
						$('#lineaFondeoID').focus();
						procede = 1;
					}
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error en Validación de Linea de Fondeo.<br>" + message + ":" + exception);
			}
		});
	}
	return procede;
}

//-------------valida el saldo de la linea de fondeo-----------------------
function validaCreditoSaldoLineaFondeo() {
	quitaFormatoControles('formaGenerica');
	var saldoLinFon = $('#saldoLineaFon').val();
	var montoCred = $('#montoSolici').val();
	var saldo = parseFloat(saldoLinFon);
	var monto = parseFloat(montoCred);
	var instFondeo = $('#institutFondID').asNumber();
	agregaFormatoControles('formaGenerica');
	if ($('#tipoFondeo2').is(':checked')) {
		if (monto > saldo && instFondeo != '0') {
			mensajeSis("La Linea de Fondeo no tiene Saldo Suficiente");
			$('#lineaFondeoID').focus();
			procede = 1;
		} else {
			procede = 0;
		}
	} else {
		procede = 0;
	}
	return procede;
}

//habilita controles de la solicitud de credito para poder modificarla si es inactiva
function habilitaControlesSolicitudInactiva() {
	habilitaControl('clienteID');
	habilitaControl('institFondeoID');
	habilitaControl('lineaFondeo');
	habilitaControl('productoCreditoID');
	habilitaControl('destinoCreID');
}

//valida vacios cuando se hace el submit de una solicitud
function validaCamposRequeridos() {
	if ($.trim($('#grupoID').val()) != "" && $('#grupoID').asNumber() != "0") {
		if ($('#tipoIntegrante').val() == "") {
			mensajeSis("Especificar tipo de Integrante.");
			$('#tipoIntegrante').focus();
			procede = 1;
		} else {
			if ($('#frecuenciaCap').val() == 'U') {

					mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
					procede = 1;

					procede = validaCamposRequeridosSolicitud();

			} else {
				procede = validaCamposRequeridosSolicitud();
			}
		}
	} else {
		if ($('#frecuenciaCap').val() == 'U') {

				mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
				procede = 1;

				procede = validaCamposRequeridosSolicitud();

		} else {
			procede = validaCamposRequeridosSolicitud();
		}
	}
	return procede;
}

//valida vacios cuando se hace el submit de una solicitud
function validaCamposRequeridosSolicitud() {
	// valida que la fecha de vencimiento no este vacia
	if ($('#fechaVencimiento').val() == "") {
		mensajeSis("La Fecha de Vencimiento Está Vací­a.");
		procede = 1;
	} else {
		if ($('#numTransacSim').asNumber() == '0' || $('#numTransacSim').val() == '') {
			mensajeSis("Se Requiere Simular las Amortizaciones.");
			procede = 1;
		} else {
			if ($('#frecuenciaCap').val() == '0' || $('#frecuenciaCap').val() == "") {
				mensajeSis("La Frecuencia de Capital Está Vacía.");
				esTab = true;
				$('#frecuenciaCap').focus();
				procede = 1;
			} else {
				if ($('#tipoPagoCapital').val() == '0') {
					mensajeSis("El Tipo de Pago Está Vacío, Se Reiniciarán los Valores Originales de la Solicitud.");
					esTab = true;
					consultaLineaFondeo('lineaFondeoID');
					procede = 1;
				} else {
					if ($('#diaPagoCapital2').is(':checked') && $('#diaMesCapital').asNumber() == 0) {
						mensajeSis("Especificar Día Mes Capital.");
						$('#diaMesCapital').focus();
						procede = 1;
					} else {
						//
						if (($('#frecuenciaInt').val() == '0' || $('#frecuenciaInt').val()) == "" && $('#tipoPagoCapital').val() != "C") {
							mensajeSis("Especifique Frecuencia de Interés.");
							$('#frecuenciaInt').focus();
							procede = 1;
						} else {
							if ($('#numAmortInteres').asNumber() == '0') {
								if ($('#calendIrregular').val() == "S") {
									mensajeSis("Es Necesario Calcular de nuevo las Amortizaciones.");
									$('#calcular').focus();
									procede = 1;
								} else {
									mensajeSis("Numero de Cuotas de Interés Vacio.");
									$('#numAmortInteres').focus();
									procede = 1;
								}
							} else {
								if ($('#diaPagoInteres2').is(':checked') && $('#diaMesInteres').asNumber() == 0 && $('#tipoPagoCapital').val() != "C") {
									mensajeSis("Especificar Día Mes Interés.");
									$('#diaMesInteres').focus();
									procede = 1;
								} else {
									if ($('#productoCreditoID').asNumber() == '0' || $('#productoCreditoID').val() == '') {
										mensajeSis("El Producto de Crédito Está Vacío.");
										procede = 1;
									} else {
										if ($('#destinoCreID').asNumber() == '0' || $('#destinoCreID').val() == '') {
											mensajeSis("El Destino de Crédito Está Vacío.");
											$('#destinoCreID').focus();
											procede = 1;
										} else {
											if ($('#tipoDispersion').val() == '0') {
												mensajeSis("El Tipo de Dispersion Está Vacío.");
												$('#tipoDispersion').focus();
												procede = 1;
											} else {
												if ($('#tasaFija').asNumber() > 0) {
													procede = validaCreditoSaldoLineaFondeo();
													if (procede == 0) {
														procede = validaLineaFondeo();
													}
												} else {
													mensajeSis("La " + VarTasaFijaoBase + " no es Válida.");
													$('#tasaFija').focus();
													procede = 1;
												}
											}
										}
									}
								}
							}
						}

					}
				}
			}
		}
	}
	return procede;
}
//habilita los controles cuando una solicitud de credito  esta autorizada
function habilitaInputsAutorizada() {
	habilitaControl('productoCreditoID');
	habilitaControl('destinoCreID');
	habilitaControl('proyecto');
	habilitaControl('montoSolici');
	habilitaControl('plazoID');
	habilitaControl('tipoDispersion');
	habilitaControl('lineaFondeoID');
	habilitaControl('tasaPasiva');
}

//validaciones del monto solicitado
function validaLimiteMontoSolicitado() {
	// se valida que el monto solicitado no sea mayor a lo parametrizado
	if ($('#montoSolici').asNumber() > montoMaxSolicitud) {
		continuar = 0;
		$('#montoSolici').val(montoMaxSolicitud);
		$('#montoSolici').formatCurrency({
			positiveFormat : '%n',
			negativeFormat : '%n',
			roundToDecimalPlace : 2
		});
		mensajeSis('El Monto Solicitado No debe ser Mayor a ' + $('#montoSolici').val());
		$('#montoSolici').val('0.00');
		montoSolicitudBase = 0.00;
		montoOriginalSolicitud = montoSolicitudBase;
		$('#montoSolici').focus();

	} else {
		// se valida que el monto no se sea menos a lo parametrizado
		if ($('#montoSolici').asNumber() < montoMinSolicitud && $('#montoSolici').val() != "") {
			continuar = 0;
			$('#montoSolici').val(montoMinSolicitud);
			$('#montoSolici').formatCurrency({
				positiveFormat : '%n',
				negativeFormat : '%n',
				roundToDecimalPlace : 2
			});
			mensajeSis('El Monto Solicitado No debe ser Menor a ' + $('#montoSolici').val());
			$('#montoSolici').val('0.00');
			$('#montoSolici').focus();
			montoSolicitudBase = 0.00;
			montoOriginalSolicitud = montoSolicitudBase;
		} else {
			continuar = 1;
		}
	}
	return continuar;
}
//------------------ valida que la cuenta CLABE este bien formada ---------------
function validaSpei(valor, cuentaClabe) {
	agregaFormatoNumMaximo('formaGenerica');
	var numero = document.getElementById(cuentaClabe).value;
	var tipoDisper = $('#tipoDispersion').val();
	if (tipoDisper == 'S' && numero != '') {
		if (isNaN(numero)) {
			mensajeSis("Ingresar Sólo Números.");
			$('#cuentaCLABE').select();
		}
		if (numero.length == 18 && numero != '') {
			if (!isNaN(numero)) {
				var institucion = numero.substr(0, 3);
				var tipoConsulta = 3;
				var DispersionBean = {
					'institucionID' : institucion
				};
				institucionesServicio.consultaInstitucion(tipoConsulta, DispersionBean, function(data) {
					if (data == null) {
						mensajeSis('La Cuenta Clabe No Coincide con Ninguna Institución Financiera Registrada.');
						document.getElementById(cuentaClabe).focus();
					}
				});
			}
		} else {
			mensajeSis("La Cuenta Clable debe de Tener 18 Caracteres.");
			document.getElementById(cuentaClabe).focus();
		}
	}
	return false;
}
//-----------consulta el parentesco del beneficiario con el cliente---------------
function consultaParentesco(idControl) {
	var jqParentesco = eval("'#" + idControl + "'");
	var numParentesco = $(jqParentesco).val();
	var tipConPrincipal = 1;
	setTimeout("$('#cajaLista').hide();", 200);
	var ParentescoBean = {
		'parentescoID' : numParentesco
	};
	if (numParentesco != '' && !isNaN(numParentesco)) {
		parentescosServicio.consultaParentesco(tipConPrincipal, ParentescoBean, function(parentesco) {
			if (parentesco != null) {
				$('#parentesco').val(parentesco.descripcion);

			} else {
				mensajeSis("No Existe el Parentesco.");
				$(jqParentesco).focus();
				$(jqParentesco).val("");
			}
		});
	}
}
function validaSiseguroVida(segurodeVida) {
	// si lleva seguro de vida
	if (segurodeVida == 'S') {
		$('#trMontoSeguroVida').show();
		$('#trBeneficiario').show();
		$('#trParentesco').show();
		$('#reqSeguroVidaSi').attr("checked", true);
		$('#reqSeguroVidaNo').attr("checked", false);
		$('#reqSeguroVida').val("S");
	} else {
		// no lleva seguro de vida
		if (segurodeVida == 'N') {
			$('#trMontoSeguroVida').hide();
			$('#trBeneficiario').hide();
			$('#trParentesco').hide();
			$('#tipoPagoSelect').hide();
			$('#tipoPagoSelect2').hide();
			$('#reqSeguroVidaSi').attr("checked", false);
			$('#reqSeguroVidaNo').attr("checked", true);
			$('#reqSeguroVida').val("N");
		}
	}
}

//FUNCION PARA CALCULAR EL MONTO DE LA GARANTÍA LÍQUIDA DEL CRÉDITO
function calculaMontoGarantiaLiquida(garanLiquida) {
	// calculo el monto de garantia liquida
	calculosyOperacionesDosDecimalesMultiplicacion($('#montoSolici').val(), (garanLiquida / 100));
}

//CONSULTA DEL BENEFICIARIO DEL SEGURO DE VIDA DEL CRÉDITO
function consultaBeneficiario(idControl) {
	var jqCred = eval("'#" + idControl + "'");
	var Credito = $(jqCred).val();
	var SeguroVidaBean = {
		'solicitudCreditoID' : Credito
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (Credito != '' && !isNaN(Credito) && esTab) {
		seguroVidaServicio.consulta(catTipoConsultaSeguroVida.foranea, SeguroVidaBean, function(seguro) {
			if (seguro != null) {
				$('#seguroVidaID').val(seguro.seguroVidaID);
				$('#direccionBen').val(seguro.direccionBeneficiario);
				$('#beneficiario').val(seguro.beneficiario);
				$('#parentescoID').val(seguro.relacionBeneficiario);
				$('#parentesco').val(seguro.descriRelacionBeneficiario);
			} else {
				$('#direccionBen').val('');
				$('#beneficiario').val('');
				$('#parentescoID').val('');
				$('#parentesco').val('');
			}
		});
	}
}

function consultaTipoGarantiaFira() {
	dwr.util.removeAllOptions('tipoGarantiaFIRAID');
	dwr.util.addOptions('tipoGarantiaFIRAID', {
		"" : 'SELECCIONAR'
	});
	var CatTipoGarantiaFIRABean = {
		'descripcion' : ''
	};
	catTipoGarantiaFIRAServicio.listaCombo(1, CatTipoGarantiaFIRABean, function(tipoGarantiaF) {
		dwr.util.addOptions('tipoGarantiaFIRAID', tipoGarantiaF, 'tipoGarantiaID', 'descripcion');
	});
}

function consultaCadenaProductiva() {
	var cadenaProductivaID = $("#cadenaProductivaID").val();
	var cadenaProductivaBean = {
		'cveCadena' : cadenaProductivaID
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (cadenaProductivaID != '' && !isNaN(cadenaProductivaID) && esTab) {
		catCadenaProductivaServicio.consulta(1, cadenaProductivaBean, {
			callback : function(cadenaBean) {
				if (cadenaBean != null) {
					$("#descipcionCadenaProductiva").val(cadenaBean.nomCadenaProdSCIAN);
				} else {
					$("#cadenaProductivaID").focus();
					$("#descipcionCadenaProductiva").val("");
					$("#ramaFIRAID").val("");
					$("#descripcionRamaFIRA").val("");
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error en Consulta de la Cadena Productiva.<br>" + message + ":" + exception);
			}
		});
	} else {
		if (isNaN($('cadenaProductivaID').val())) {//Si no es numero
			$('#cadenaProductivaID').val("");
			$("#descipcionCadenaProductiva").val("");
		}
	}
}

function consultaRamaFIRA() {
	var cadenaProductivaID = $("#cadenaProductivaID").val();
	var ramaFIRAID = $("#ramaFIRAID").val();
	var cadenaProductivaBean = {
		'cveCadena' : cadenaProductivaID,
		'cveRamaFIRA' : ramaFIRAID
	};

	setTimeout("$('#cajaLista').hide();", 200);
	if (cadenaProductivaID != '' && !isNaN(cadenaProductivaID) && ramaFIRAID != '' && !isNaN(ramaFIRAID)) {
		relCadenaRamaFIRAServicio.consulta(1, cadenaProductivaBean, {
			callback : function(cadenaBean) {
				if (cadenaBean != null) {
					$("#descripcionRamaFIRA").val(cadenaBean.descripcionRamaFIRA);
				} else {
					$("#ramaFIRAID").val("");
					$("#descripcionRamaFIRA").val("");
					$("#subramaFIRAID").val("");
					$("#descipcionsubramaFIRA").val("");
					$("#ramaFIRAID").focus();
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error en Consulta de la Rama FIRA.<br>" + message + ":" + exception);
			}
		});
	} else {
		$("#ramaFIRAID").val("");
		$("#descripcionRamaFIRA").val("");
		$("#subramaFIRAID").val("");
		$("#descipcionsubramaFIRA").val("");
	}
}

function consultaSubRamaFIRA() {
	var cadenaProductivaID = $("#cadenaProductivaID").val();
	var ramaFIRAID = $("#ramaFIRAID").val();
	var subRamaFIRAID = $("#subramaFIRAID").val();
	var cadenaProductivaBean = {
		'cveCadena' : cadenaProductivaID,
		'cveRamaFIRA' : ramaFIRAID,
		'cveSubramaFIRA' : subRamaFIRAID
	};

	setTimeout("$('#cajaLista').hide();", 200);
	if (cadenaProductivaID != '' && !isNaN(cadenaProductivaID) && ramaFIRAID != '' && !isNaN(ramaFIRAID) && subRamaFIRAID != '' && !isNaN(subRamaFIRAID)) {
		relSubRamaFIRAServicio.consulta(1, cadenaProductivaBean, {
			callback : function(cadenaBean) {
				if (cadenaBean != null) {
					$("#descipcionsubramaFIRA").val(cadenaBean.descSubramaFIRA);
				} else {
					$("#subramaFIRAID").val("");
					$("#descipcionsubramaFIRA").val("");
					$("#actividadFIRAID").val("");
					$("#descripcionactividadFIRA").val("");
					$("#subramaFIRAID").focus();
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error en Consulta de la SubRama FIRA.<br>" + message + ":" + exception);
			}
		});
	} else {
		$("#subramaFIRAID").val("");
		$("#descipcionsubramaFIRA").val("");
		$("#actividadFIRAID").val("");
		$("#descripcionactividadFIRA").val("");
	}
}

function consultaActividadFIRA() {
	var cadenaProductivaID = $("#cadenaProductivaID").val();
	var ramaFIRAID = $("#ramaFIRAID").val();
	var subRamaFIRAID = $("#subramaFIRAID").val();
	var actividadFIRAID = $("#actividadFIRAID").val();
	var cadenaProductivaBean = {
		'cveCadena' : cadenaProductivaID,
		'cveRamaFIRA' : ramaFIRAID,
		'cveSubramaFIRA' : subRamaFIRAID,
		'cveActividadFIRA' : actividadFIRAID
	};

	setTimeout("$('#cajaLista').hide();", 200);
	if (cadenaProductivaID != '' && !isNaN(cadenaProductivaID) && ramaFIRAID != '' && !isNaN(ramaFIRAID) && subRamaFIRAID != '' && !isNaN(subRamaFIRAID) && actividadFIRAID != '' && !isNaN(actividadFIRAID)) {
		relActividadFIRAServicio.consulta(1, cadenaProductivaBean, {
			callback : function(cadenaBean) {
				if (cadenaBean != null) {
					$("#descripcionactividadFIRA").val(cadenaBean.desActividadFIRA);
				} else {
					$("#actividadFIRAID").val("");
					$("#descripcionactividadFIRA").val("");
					$("#actividadFIRAID").focus();
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error en Consulta de la Actividad FIRA.<br>" + message + ":" + exception);
			}
		});
	} else {
		if (isNaN(actividadFIRAID)) {
			$("#actividadFIRAID").val("");
		}
		$("#descripcionactividadFIRA").val("");
	}
}

function consultProgramaFira() {
	var progEspecialFIRAID = $("#progEspecialFIRAID").val();
	var cadenaProductivaBean = {
		'cveSubProgramaID' : progEspecialFIRAID
	};

	setTimeout("$('#cajaLista').hide();", 200);
	if (progEspecialFIRAID != '') {
		catFIRAProgEspServicio.consulta(1, cadenaProductivaBean, {
			callback : function(cadenaBean) {
				if (cadenaBean != null) {
					$("#progEspecialFIRADes").val(cadenaBean.subPrograma);
				} else {
					$("#progEspecialFIRADes").val("");
					$("#progEspecialFIRAID").val("");
					$("#progEspecialFIRAID").focus();
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error en Consulta de la Programa FIRA.<br>" + message + ":" + exception);
			}
		});
	} else {
		$("#progEspecialFIRADes").val("");
	}
}

function limpiaCamposAgro(limpiaCadena, limpiarama, limpiasubrama) {
	if (limpiaCadena) {
		$("#ramaFIRAID").val("");
		$("#descripcionRamaFIRA").val("");
	}
	if (limpiaCadena || limpiarama) {
		$("#subramaFIRAID").val("");
		$("#descipcionsubramaFIRA").val("");
	}
	$("#actividadFIRAID").val("");
	$("#descripcionactividadFIRA").val("");
}

//FUNCION PARA OBTENER EL PORCENTAJE DE GARANTIA LIQUIDA  PARA PRODUCTO DE CREDITO
function consultaPorcentajeGarantiaLiquida(controlID) {

	var jqControl = eval("'#" + controlID + "'");
	var tipoCon = 5;
	var producCreditoID = $("#productoCreditoID").val();
	var productoCreditoBean = {
		'producCreditoID' : producCreditoID
	};

	// verifica que el producto de credito en pantalla requiere garantia liquida */
	productosCreditoServicio.consulta(tipoCon, productoCreditoBean, {
		async : false,
		callback : function(respuesta) {
			if (respuesta != null) {
				if (respuesta.requiereGarantia == 'S') {
					var clienteID = 0;
					var calificaCli = $('#calificaCliente').val();

					var monto = $("#montoSolici").asNumber();

					// verifica que los datos necesario para la consulta NO esten vacios.
					if (parseInt(producCreditoID) > 0 && calificaCli != '' && parseFloat(monto) > 0) {
						tipoCon = 1;
						var bean = {
							'producCreditoID' : producCreditoID,
							'clienteID' : clienteID,
							'calificacion' : calificaCli,
							'montoSolici' : monto
						};

						// obtiene el porcentaje de garantia liquida
						esquemaGarantiaLiqServicio.consulta(tipoCon, bean, {
							async : false,
							callback : function(respuesta) {
								if (respuesta != null) {

									$('#porcGarLiq').val(respuesta.porcentaje);
									$('#porcentaje').val(respuesta.porcentaje);

									// se ejecuta funcion que valida el monto indicado para la solicitud de credito
									validaMontoSolicitudCredito();

								} else {
									mensajeSis("No existe un Esquema de Garantía Líquida para el Producto de Crédito, Calificación del " + $('#alertSocio').val() + ", Plazo y Monto indicado.");
									$(jqControl).focus();
									$(jqControl).select();
									$('#porcGarLiq').val('0.00');
									$('#porcentaje').val('0.00');
									$('#aporteCliente').val('0.00');
								}
							}
						});
					} else {
						$('#porcGarLiq').val('0.00');
						$('#porcentaje').val('0.00');
						$('#aporteCliente').val('0.00');
						validaMontoSolicitudCredito();
					}
				} else {
					$('#porcGarLiq').val('0.00');
					$('#porcentaje').val('0.00');
					$('#aporteCliente').val('0.00');
					validaMontoSolicitudCredito();
				}
			} // termina comparacion si es null si el producto de credito no requiere garantia liquida
			else {
				$('#porcGarLiq').val('0.00');
				$('#porcentaje').val('0.00');
				$('#aporteCliente').val('0.00');
			}
		}
	});

}

function consultacicloCliente() {
	var CicloCreditoBean = {
		'clienteID' : $('#clienteID').val(),
		'prospectoID' : $('#prospectoID').val(),
		'productoCreditoID' : $('#productoCreditoID').val(),
		'grupoID' : $('#grupoID').val()
	};
	var solicitud = $('#solicitudCreditoID').val();
	var grupoInteGruBeanCon = {
		'solicitudCreditoID' : solicitud
	};
	var listaIntegrante = 3;

	setTimeout("$('#cajaLista').hide();", 200);
	solicitudCredServicio.consultaCiclo(CicloCreditoBean, {
		async : false,
		callback : function(cicloCreditoCte) {
			if (cicloCreditoCte != null) {
				$('#numCreditos').val(cicloCreditoCte.cicloCliente);
				$('#cicloClienteGrupal').val(cicloCreditoCte.cicloPondGrupo);
				if (solicitud != '' && !isNaN(solicitud)) {
					integraGruposServicio.consulta(listaIntegrante, grupoInteGruBeanCon, function(integrantes) {
						if (integrantes != null) {
							$('#lbcicloscaja').show();
							$('#lbciclos').show();
						} else {
							$('#lbcicloscaja').hide();
							$('#lbciclos').hide();
						}
					});
				}

			} else {
				mensajeSis('No hay Ciclo para el ' + $('#alertSocio').val() + '.');
			}
		},
		errorHandler : function(message, exception) {
			mensajeSis("Error al consultar el Ciclo del Grupo.<br>" + message + ":" + exception);
		}
	});

}

//funcion para llenar valores default de la pantalla
function iniciaPantallaSolicitudGrupal() {
	if ($('#grupo').val() != undefined && $('#solicitudCreditoID').asNumber() == '0') {
		$('#grupoID').val($('#grupo').val());
		$('#nombreGr').val($('#nombreGrupo').val());
		grupoIDBase = $('#grupo').val();
	}
}

/* FUNCION PARA HACER OPERACION DE MULTIPLICACION Y OBTENER EL RESULTADO REDONDEADO CON DOS DECIMALES */
function calculosyOperacionesDosDecimalesMultiplicacion(valor1, valor2) {
	var calcOperBean = {
		'valorUnoA' : 0,
		'valorDosA' : 0,
		'valorUnoB' : valor1,
		'valorDosB' : valor2,
		'numeroDecimales' : 2
	};
	setTimeout("$('#cajaLista').hide();", 200);
	calculosyOperacionesServicio.calculosYOperaciones(2, calcOperBean, {
		callback : function(valoresResultado) {
			if (valoresResultado != null) {
				$('#aporteCliente').val(valoresResultado.resultadoCuatroDecimales);
				$('#montoSolici').formatCurrency({
					positiveFormat : '%n',
					negativeFormat : '%n',
					roundToDecimalPlace : 2
				});
				agregaFormatoControles('formaGenerica');
			} else {
				mensajeSis('Indique el monto de nuevo.');
				$('#aporteCliente').val("0.00");
			}
		},
		errorHandler : function(message, exception) {
			mensajeSis("Error al realizar cálculo.<br>" + message + ":" + exception);
		}
	});
}

//función para consultar si el cliente ya tiene huella digital registrada
function consultaHuellaCliente() {
	var numCliente = $('#clienteID').val();
	if (numCliente != '' && !isNaN(numCliente)) {
		var clienteIDBean = {
			'personaID' : $('#clienteID').val()
		};
		huellaDigitalServicio.consulta(1, clienteIDBean, {
			callback : function(cliente) {
				if (cliente == null) {
					var huella = parametroBean.funcionHuella;
					if (huella == "S") {
						mensajeSis("El " + $('#alertSocio').val() + " no tiene Huella Registrada.\nFavor de Verificar.");
						$('#clienteID').focus();
					}
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error en Consulta de la Huella Registrada.<br>" + message + ":" + exception);
			}
		});
	}
}

//Consulta para ver si se requiere que el cliente tenga registrada su huella Digital
function validaEmpresaID() {
	var numEmpresaID = 1;
	var tipoCon = 1;
	var ParametrosSisBean = {
		'empresaID' : numEmpresaID
	};
	parametrosSisServicio.consulta(tipoCon, ParametrosSisBean, {
		callback : function(parametrosSisBean) {
			if (parametrosSisBean != null) {
				if (parametrosSisBean.reqhuellaProductos != null) {
					huellaProductos = parametrosSisBean.reqhuellaProductos;
				} else {
					huellaProductos = "N";
				}
			}
		},
		errorHandler : function(message, exception) {
			mensajeSis("Error en consulta de parametros.<br>" + message + ":" + exception);
		}
	});
}

//Asigna valor por default a consultaSIC
function consultaSICParam() {
	var parametrosSisCon = {
		'empresaID' : 1
	};
	setTimeout("$('#cajaLista').hide();", 200);

	parametrosSisServicio.consulta(1, parametrosSisCon, function(parametroSistema) {
		if (parametroSistema != null) {
			if (parametroSistema.conBuroCreDefaut == 'B') { // si tiene por default Buro
				$('#tipoConsultaSICBuro').attr("checked", true);
				$('#tipoConsultaSICCirculo').attr("checked", false);
				$('#consultaBuro').show();
				$('#consultaCirculo').hide();
				$('#folioConsultaCC').val('');
				$('#tipoConsultaSIC').val('BC');

			} else if (parametroSistema.conBuroCreDefaut == 'C') { // si tiene por default Circulo
				$('#tipoConsultaSICBuro').attr("checked", false);
				$('#tipoConsultaSICCirculo').attr("checked", true);
				$('#consultaBuro').hide();
				$('#consultaCirculo').show();
				$('#folioConsultaBC').val('');
				$('#tipoConsultaSIC').val('CC');
			}
		}
	});
}

consultaCambiaPromotor();
//CAMBIAR PROMOTOR PARAMETROSSIS
function consultaCambiaPromotor() {
	if (cambiarPromotor == 'N') {
		soloLecturaControl('promotorID');
	} else {
		if (cambiarPromotor == 'S') {
			if ($('#estatus').val() == 'I') {
				habilitaControl('promotorID');
			} else {
				soloLecturaControl('promotorID');
			}
		}
	}

}

function verificarvacios() {
	// quitaFormatoControles('gridDetalle');
	var numAmortizacion = $('input[name=renglon]').length;
	$('#montosCapital').val("");

	for (var i = 1; i <= numAmortizacion; i++) {
		// controlQuitaFormatoMoneda("capital"+i+"");
		var valCapital = document.getElementById("capital" + i + "").value;
		if (valCapital == " ") {
			document.getElementById("capital" + i + "").focus();
			$("capital" + i).addClass("error");
			return 1;
		} else {
			return 2;
		}
	}
}


function mostrarGridLibres() { // BORRAR
	var data;

	data = '<input type="hidden" value="0" name="numeroDetalle" id="numeroDetalle" />' + '<fieldset class="ui-widget ui-widget-content ui-corner-all">' + '<legend>Simulador de Amortizaciones</legend>' + '<form id="gridDetalle" name="gridDetalle">' + '<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">' + '<tr>' + '<td class="label" align="center"><label for="lblNumero">N&uacute;mero</label></td>' + '<td class="label" align="center"><label for="lblFecIni">Fecha Inicio</label></td>' + '<td class="label" align="center"><label for="lblFecFin">Fecha Vencimiento</label> </td>	' + '<td class="label" align="center"><label for="lblFecPag">Fecha Pago</label></td>' + '<td class="label" align="center"><label for="lblCapital">Capital</label></td> ' + '<td class="label" align="center"><label for="lblDescripcion">Inter&eacute;s</label></td> ' + '<td class="label" align="center"><label for="lblCargos">Iva Inter&eacute;s</label></td> ' + '<td class="label" align="center"><label for="lblTotalPag">Total Pago</label></td> ' + '<td class="label" align="center"><label for="lblSaldoCap">Saldo Capital</label></td> ' + '</tr>' + '</table>' + '</form>' + '</fieldset>';

	$('#contenedorSimuladorLibre').html(data);
	$('#contenedorSimuladorLibre').show();
	$('#contenedorSimulador').html("");
	$('#contenedorSimulador').hide();
	agregaFormatoControles('gridDetalle');
	mostrarGridLibres2();
}

//funcion que consulta la fecha de vencimiento en base a ls cuotas
function consultaFechaVencimientoCuotas(idControl) {
	var jqPlazo = eval("'#" + idControl + "'");
	var plazo = $(jqPlazo).val();
	var tipoCon = 4;

	var PlazoBeanCon = {
		'frecuenciaCap' : $('#frecuenciaCap').val(),
		'numCuotas' : $('#numAmortizacion').val(),
		'periodicidadCap' : $('#periodicidadCap').val(),
		'fechaActual' : $('#fechaInicioAmor').val()
	};
	if (plazo == '0') {
		$('#fechaVencimiento').val("");
	} else {
		plazosCredServicio.consulta(tipoCon, PlazoBeanCon, {
			callback : function(plazos) {
				if (plazos != null) {
					$('#fechaVencimiento').val(plazos.fechaActual);
					if (requiereSeg == 'S' && $.trim($('#fechaVencimiento').val()) != "" && $.trim($('#fechaVencimiento').val()) != null) {
						calculaNodeDias(plazos.fechaActual);
					}
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error al consultar la Fecha de Vencimiento.<br>" + message + ":" + exception);
			}
		});
	}
}

//calcula el numero de dias del plazo seleccionado
function calculaNodeDias(varfechaVencimiento) {
	if ($('#fechaVencimiento').val() != '') {
		var tipoCons = 1;
		var PlazoBeanCon = {
			'plazoID' : $('#plazoID').val()
		};

		plazosCredServicio.consulta(tipoCons, PlazoBeanCon, {
			async : false,
			callback : function(plazos) {
				if (plazos != null) {
					$('#noDias').val(plazos.dias);// número de dias parametrizado en el plazo

					if (requiereSeg == 'S') {
						calculoCostoSeguro(); // calcula el seguro de vida

					}

					if (parseInt($("#periodicidadCap").val()) > 0) {
						if (parseInt($("#periodicidadCap").val()) <= parseInt($('#noDias').val())) {

							if ($('#frecuenciaCap').val() == "U") {

								$('#periodicidadCap').val(plazos.dias);
								if ($("#tipoPagoCapital").val() == 'C' || $('#perIgual').val() == 'S') {
									$('#periodicidadInt').val(plazos.dias);
								}
							}
						} else {
							mensajeSis("La Periodicidad de Capital es Mayor al Número de Días del Plazo.");
							$("#frecuenciaCap").focus();
						}
					}

				}
			}
		});
	}
}

//FUNCION PARA CALCULAR EL MONTO DEL SEGURO DE VIDA DEPENDIENDO DE LA CANTIDAD DEL MONTO DE CRÉDITO
function calculoCostoSeguro() {
	agregaFormatoControles('formaGenerica');

	if (modalidad == 'U') {

		numeroDias = $('#noDias').val();
		var pagoseguro = $('#forCobroSegVida').val();

		var costoSeguroVida = 0;
		var factRiesgo = $('#factorRiesgoSeguro').asNumber();
		var SeguroVidadosDecimales = 0;
		var SeguroDescVidadosDecimales = 0;
		var montoDescuento = 0;
		var descSeguro = (descuentoSeg / 100);

		costoSeguroVida = (factRiesgo / 7) * montoSolicitudBase * numeroDias;
		montoDescuento = costoSeguroVida - (costoSeguroVida * descSeguro);

		SeguroVidadosDecimales = montoDescuento;
		SeguroDescVidadosDecimales = costoSeguroVida;

		montoComIvaSol = montoSolicitudBase;

		$('#montoSeguroVida').val(SeguroVidadosDecimales.toFixed(2));
		$('#montoSegOriginal').val(SeguroDescVidadosDecimales);
		$('#descuentoSeguro').val(descuentoSeg);

		// SI EL TIPO DE PAGO DEL SEGURO Es POR  FINANCIAMIENTO SE LE SUMA AL MONTO DE CREDITO EL SEGURO DE VIDA
		if (pagoseguro == 'F' && montoSolicitudBase > 0) {
			montoComIvaSol += parseFloat(SeguroVidadosDecimales);
		}

		if ($('#formaComApertura').val() == 'FINANCIAMIENTO' && montoSolicitudBase > 0) {
			montoComIvaSol = Number(montoComIvaSol) + (parseFloat(montoComApeBase) + parseFloat(montoIvaComApeBase));
		}

		if (montoSolicitudBase > 0 && Number(montoComIvaSol).toFixed(2) != $('#montoSolici').asNumber()) {
			$('#montoSolici').val(Number(montoComIvaSol).toFixed(2));
		}

	} else {
		calculoCostoSeguroTipoPago();
	}

	agregaFormatoControles('formaGenerica');

}

function calculoCostoSeguroTipoPago() {

	agregaFormatoControles('formaGenerica');

	if (modalidad == 'T') {
		var pagoseguroTip = $('#forCobroSegVida').val();
		var esqSeguVida = esquemaSeguro;

		consultaEsquemaSeguroVida(esqSeguVida, pagoseguroTip);

		if (factorRS == 0 && $('#ClienteID').val() == "") {
			$('#montoSeguroVida').val("0.00");
			$('#tipPago').val("");

		}

		numeroDias = $('#noDias').val();

		var pagoseguro = $('#forCobroSegVida').val();
		var costoSeguroVida = 0;

		$('#factorRiesgoSeguro').val(factorRS);
		var factRiesgo = $('#factorRiesgoSeguro').asNumber();
		var montoDescuento = 0;
		var descSeguro = (porcentajeDesc / 100);

		var SeguroVidadosDecimales = 0;
		var SeguroDescVidadosDecimales = 0;

		costoSeguroVida = (factRiesgo / 7) * montoSolicitudBase * numeroDias;
		montoDescuento = costoSeguroVida - (costoSeguroVida * descSeguro);

		SeguroVidadosDecimales = montoDescuento;
		SeguroDescVidadosDecimales = costoSeguroVida;

		montoComIvaSol = montoSolicitudBase;

		$('#montoSeguroVida').val(montoDescuento.toFixed(2));
		$('#montoSegOriginal').val(SeguroDescVidadosDecimales);
		$('#descuentoSeguro').val(porcentajeDesc);

		// Si el tipo de pago de seguro es por Financiamiento se le suma al monto solicitado
		if (pagoseguro == 'F' && montoSolicitudBase > 0) {
			montoComIvaSol = parseFloat(montoComIvaSol) + parseFloat(SeguroVidadosDecimales);
		}

		if ($('#formaComApertura').val() == 'FINANCIAMIENTO' && montoSolicitudBase > 0) {
			montoComIvaSol = Number(montoComIvaSol) + (parseFloat(montoComApeBase) + parseFloat(montoIvaComApeBase));
		}

		if (montoSolicitudBase > 0 && Number(montoComIvaSol).toFixed(2) != $('#montoSolici').asNumber()) {
			$('#montoSolici').val(Number(montoComIvaSol).toFixed(2));
		}
	} else {
		// kzo	montoComIvaSol=$('#montoSolici').val(); provocaba que se duplicara el monto por com. aper
	}
	agregaFormatoControles('formaGenerica');

}

//inicializa la solicitud de credito
function inicializarSolicitud() {
	$('#solicitudCreditoID').focus();
	$('#solicitudCreditoID').select();
	deshabilitaControl('tipoFondeo');
	deshabilitaControl('tipoFondeo2');
	inicializaValores(); // funcion que iniciliza valores de la forma
	inicializaVariables(); // funcion para inicializar las variables
	deshabilitaBoton('agregar', 'submit');
	deshabilitaBoton('modificar', 'submit');
	deshabilitaBoton('agregaConsolidacion', 'submit');
	inicializaCombos();

	if ($('#grupo').val() != undefined) {
		consultaIntegrantesGrid();
		var solicitud = $('#solicitudCreditoID').val();
		$('#numSolicitud').val(solicitud);
	}

	validaFlujoIndividual();

	if ($('#numSolicitud').val() != undefined) {
		$('#numSolicitud').val($('#solicitudCreditoID').val());
		var SolCredBeanCon = {
			'solicitudCreditoID' : $('#solicitudCreditoID').val(),
			'usuario' : parametroBean.numeroUsuario
		};
		solicitudCredServicio.consulta(1, SolCredBeanCon, {
			callback : function(solicitud) {
				if (solicitud != null) {
					var ProdCredBeanCon = {
						'producCreditoID' : solicitud.productoCreditoID
					};

					productosCreditoServicio.consulta(1, ProdCredBeanCon, {
						callback : function(prodCred) {
							if (prodCred != null) {
								validaProductoRequiereGarantia(prodCred.requiereGarantia);
								validaProductoRequiereAvales(prodCred.requiereAvales);
								if ($('#flujoIndividualBandera').val() != undefined) {
									muestraPestanias();
								}
							}
						},
						errorHandler : function(message, exception) {
							mensajeSis("Error al consultar Grupo.<br>" + message + ":" + exception);
						}
					});
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error al consultar Solicitud.<br>" + message + ":" + exception);
			}
		});
	}
}

//funcion que se ejecuta cuando surgio un error en la transaccion
function errorSolicitud() {
	agregaFormatoControles('formaGenerica');
}

//funcion para deshabilitar controles
function deshabilitaInputs() {
	deshabilitaControl('productoCreditoID');
	deshabilitaControl('destinoCreID');
	deshabilitaControl('proyecto');
	deshabilitaControl('montoSolici');
	deshabilitaControl('plazoID');
	deshabilitaControl('tipoDispersion');
	deshabilitaControl('lineaFondeoID');
	deshabilitaControl('tasaPasiva');
	deshabilitaControl('promotorID');
	deshabilitaControl('monedaID');
	deshabilitaControl('estatus');
	deshabilitaControl('sucursalID');
	deshabilitaControl('montoAutorizado');
	soloLecturaControl('fechaVencimiento');
	deshabilitaControl('factorMora');
	deshabilitaControl('montoComApert');
	deshabilitaControl('ivaComApert');
	deshabilitaControl('tipoCalInteres');
	deshabilitaControl('calcInteresID');
	deshabilitaControl('tasaBase');
	deshabilitaControl('tasaFija');
	deshabilitaControl('sobreTasa');
	deshabilitaControl('pisoTasa');
	deshabilitaControl('techoTasa');
	soloLecturaControl('fechaInicio');
	deshabilitaControl('cuentaID');
	deshabilitaControl('fechInhabil1');
	deshabilitaControl('fechInhabil2');
	deshabilitaControl('tasaFija');
	deshabilitaControl('periodicidadInt');
	deshabilitaControl('periodicidadCap');
	deshabilitaControl('ajusFecExiVen1');
	deshabilitaControl('ajusFecExiVen2');
	deshabilitaControl('ajFecUlAmoVen1');
	deshabilitaControl('ajFecUlAmoVen2');
	deshabilitaControl('numAmortInteres');
	deshabilitaControl('montoCuota');
	deshabilitaControl('lineaFondeoID');
	deshabilitaControl('tipPago');
	deshabilitaControl('clienteID');
	deshabilitaControl('deudorOriginalID');
	deshabilitaControl('creditoID');
	deshabilitaControl('ramaFIRAID');
	deshabilitaControl('cadenaProductivaID');
	deshabilitaControl('subramaFIRAID');
	deshabilitaControl('horarioVeri');
	deshabilitaControl('tipoConsultaSICCirculo');
	deshabilitaControl('tipoConsultaSICBuro');
	deshabilitaControl('actividadFIRAID');

	deshabilitaControl('tipoFondeo');
	deshabilitaControl('tipoFondeo2');
	deshabilitaControl('lineaFondeoID');
	deshabilitaControl('comentario');
	deshabilitaControl('prospectoID');
	deshabilitaControl('creditoIDFIRA');
	deshabilitaControl('acreditadoIDFIRA');
	deshabilitaControl('institutFondID');
	deshabilitaControl('fechaInicioAmor');
	deshabilitaControl('fechaDesembolso');
	deshabilitaControl('folioConsultaBC');
	$("#fechaInicioAmor").attr('readonly', true);
	$("#fechaInicioAmor").datepicker("destroy");
	$("#fechaDesembolso").attr('readonly', true);
	$("#fechaDesembolso").datepicker("destroy");
}

//Habilita inputs Generales de la Solicitud de Credito sin importar si es grupal(primera, diferente de primera) o individual
function habilitaInputsSolicitud() {

	habilitaControl('beneficiario');
	habilitaControl('parentescoID');
	habilitaControl('direccionBen');
	habilitaControl('destinoCreID');
	habilitaControl('proyecto');

}
//deshabilita inputs de la solicitud grupal cuando las solicitud es >1
function deshabilitaInputsSolGrupal() {
	deshabilitaControl('tipoPagoCapital');
	deshabilitaControl('frecuenciaCap');
	deshabilitaControl('plazoID');
	deshabilitaControl('tipoDispersion');
	deshabilitaControl('tipPago');

}

function habilitaInputsSolGrupal() {
	habilitaControl('tipoPagoCapital');
	habilitaControl('frecuenciaCap');
	habilitaControl('plazoID');
	habilitaControl('tipoDispersion');
	habilitaControl('tipPago');

}
//funcion para inicializar los valores cuando se da de alta una nueva solicitud
function inicializaValoresNuevaSolicitud() {

	inicializaValores(); // funcion que iniciliza valores de la forma
	inicializaVariables(); // funcion para inicializar las variables
	inicializaCombos();
	/* Funcion que habilita los inputs generales de la solicitud sin importar si
	 *  es grupal o individual. Ecepto inputs que se deshabilitan en casos  especiales */
	habilitaInputsSolicitud();
	$('#sucursalID').val(parametroBean.sucursal);

	habilitaBoton('agregar', 'submit');
	habilitaBoton('agregaConsolidacion', 'submit');
	deshabilitaBoton('modificar', 'submit');
	$('#fechaRegistro').val(parametroBean.fechaAplicacion);
	$('#fechaInicio').val(parametroBean.fechaAplicacion);
	$('#fechaInicioAmor').val(parametroBean.fechaAplicacion);
	$('#fechaDesembolso').val(parametroBean.fechaAplicacion);
	$('#fechaCobroComision').val(parametroBean.fechaAplicacion);
	$('#monedaID').val('1');
	$('#simular').show();
	$('#tipoPagoSelect').hide();
	$('#tipoPagoSelect2').hide();
	// SEGUROS
	$('#cobraSeguroCuota').val('N').selected = true;
	$('#cobraIVASeguroCuota').val('N').selected = true;
	$('#montoSeguroCuota').val('');

	if ($('#grupo').val() == undefined) {
		habilitaControl('productoCreditoID');
		habilitaControl('grupoID');
		deshabilitaControl('tipoIntegrante');
	} else {
		deshabilitaControl('tipoIntegrante');
	}

	habilitaControl('clienteID');
	habilitaControl('deudorOriginalID');
	habilitaControl('creditoID');
	habilitaControl('ramaFIRAID');
	habilitaControl('cadenaProductivaID');
	habilitaControl('subramaFIRAID');
	habilitaControl('horarioVeri');
	habilitaControl('tipoConsultaSICCirculo');
	habilitaControl('tipoConsultaSICBuro');
	habilitaControl('actividadFIRAID');

	habilitaControl('tipoFondeo');
	habilitaControl('tipoFondeo2');
	habilitaControl('lineaFondeoID');
	habilitaControl('comentario');
	habilitaControl('prospectoID');
	habilitaControl('creditoIDFIRA');
	habilitaControl('acreditadoIDFIRA');
	habilitaControl('institutFondID');
	habilitaControl('fechaInicioAmor');
	habilitaControl('fechaDesembolso');
	habilitaControl('folioConsultaBC');

	$('#contenedorSimulador').html("");
	$('#contenedorSimulador').hide();
	$('#contenedorSimuladorLibre').html("");
	$('#contenedorSimuladorLibre').hide();
	$('#acreditadoIDFIRA').val("");
	$('#creditoIDFIRA').val("");
	mostrarElementoPorClase('mostrarAcredFIRA', false);
	mostrarElementoPorClase('mostrarAcred', false);
	mostrarElementoPorClase('mostrarCred', false);
	deshabilitaCampoLinea();

}
//funcion que iniciliza valores de la forma
function inicializaValores() {
	consultaMinistracionesconsolidadas('');
	/*SECCION Solicitud de Crédito Agropecuario*/
	$('#cadenaProductivaID').val('');
	$('#descipcionCadenaProductiva').val('');
	$('#ramaFIRAID').val('');
	$('#descripcionRamaFIRA').val('');
	$('#subramaFIRAID').val('');
	$('#descipcionsubramaFIRA').val('');
	$('#actividadFIRAID').val('');
	$('#descripcionactividadFIRA').val('');
	$('#tipoGarantiaFIRAID').val('');
	$('#progEspecialFIRAID').val('');
	$('#progEspecialFIRADes').val('');
	/*FIN SECCION Solicitud de Crédito Agropecuario*/
	soloLecturaControl('fechaInicio');
	soloLecturaControl('fechaInicioAmor');
	soloLecturaControl('fechaDesembolso');
	soloLecturaControl('fechaVencimiento');
	$('#contenedorSimulador').html("");
	$('#contenedorSimulador').hide();
	$('#creditosConsolidadosGrid').html("");
	$('#creditosConsolidadosGrid').hide();

	$('#contenedorSimuladorLibre').html("");
	$('#contenedorSimuladorLibre').hide();

	$('#clienteID').val('');
	$('#nombreCte').val('');
	$('#productoCreditoID').val('');
	$('#descripProducto').val('');
	$('#promotorID').val('');
	$('#nombrePromotor').val('');
	$('#destinoCreID').val('');
	$('#descripDestino').val('');
	$('#destinCredFRID').val('');
	$('#descripDestinoFR').val('');
	$('#destinCredFOMURID').val('');
	$('#descripDestinoFOMUR').val('');
	$('#proyecto').val('');
	$('#numCreditos').val('');
	$('#cicloClienteGrupal').val('');
	$('#tasaPonderaGru').val('');
	$('#esGrupal').val('');
	$('#montoSolici').val('');
	montoSolicitudBase = 0.00;
	montoOriginalSolicitud = montoSolicitudBase;
	$('#montoAutorizado').val('');
	$('#fechaVencimiento').val('');
	$('#formaComApertura').val('');
	$('#forCobroComAper').val('');
	$('#montoComApert').val('');
	$('#ivaComApert').val('');
	$('#pagaIVACte').val('');
	$('#sucursalCte').val('');
	$('#nombreSucursal').val('');
	$('#porcGarLiq').val('');
	$('#aporteCliente').val('');
	$('#porcentaje').val('');
	$('#forCobroSegVida').val('');
	$('#montoPolSegVida').val('');
	$('#noDias').val('');
	$('#montoSeguroVida').val('');
	$('#factorRiesgoSeguro').val('');
	$('#beneficiario').val('');
	$('#parentescoID').val('');
	$('#parentesco').val('');
	$('#direccionBen').val('');
	$('#desTasaBase').val('');
	$('#cuentaCLABE').val('');
	$('#prospectoID').val('');
	$('#nombreProspecto').val('');

	$('#calcInteresID').val('');
	$('#tipoCalInteres').val('');
	$('#tasaBase').val('');
	$('#tasaFija').val('');
	$('#sobreTasa').val('');
	$('#pisoTasa').val('');
	$('#techoTasa').val('');
	$('#factorMora').val("");
	$('#numAmortizacion').val("");
	$('#numAmortInteres').val("");

	$('#CAT').val("");
	$('#numTransacSim').val("");
	$('#periodicidadInt').val("");
	$('#periodicidadCap').val("");
	$('#frecuenciaInt').val("");
	$('#estatus').val("I");
	$('#montoCuota').val("");
	$('#factorMora').val("");
	$('#tipoDispersion').val("");
	$('#tipoIntegrante').val("4");
	$('#comentarioEjecutivo').val("");
	$('#comentariosEjecutivo').hide();
	$('#diaMesCapital').val('');
	$('#diaMesInteres').val('');
	$('#tipoPagoSeguro').val('');

	$('#trMontoSeguroVida').hide();
	$('#trBeneficiario').hide();
	$('#trParentesco').hide();

	$('#reqSeguroVidaNo').attr('checked', true);
	$('#reqSeguroVidaSi').attr("checked", false);
	$('#reqSeguroVida').val('N');

	// inicializa radios de valores del calendario de pagos *****
	$('#fechInhabil').val("S");
	$('#fechInhabil1').attr('checked', true);
	$('#fechInhabil2').attr("checked", false);

	$('#ajusFecExiVen1').attr('checked', false);
	$('#ajusFecExiVen2').attr("checked", true);
	$('#ajusFecExiVen').val("S");

	$('#calendIrregularCheck').attr("checked", true);
	$('#calendIrregular').val("N");

	$('#ajFecUlAmoVen1').attr('checked', true);
	$('#ajFecUlAmoVen2').attr("checked", false);
	$('#ajFecUlAmoVen').val("S");

	$('#diaMesCapital').val("");
	$('#diaMesInteres').val("");

	$('#diaPagoCapital1').attr('checked', true);
	$('#diaPagoCapital2').attr('checked', false);
	$('#diaPagoCapital').val("F");

	$('#diaPagoInteres1').attr('checked', true);
	$('#diaPagoInteres2').attr('checked', false);
	$('#diaPagoInteres').val("F");
	$('#calificaCredito').val("");


	$('#folioCtrl').val("");
	$('#horarioVeri').val("");
	$('#lblFolioCtrl').hide();
	$('#folioCtrlCaja').hide();
	$('#sep').hide();
	$('#tipoPagoSelect').hide();
	$('#tipoPagoSelect2').hide();
	// SEGUROS
	$('#cobraSeguroCuota').val('N').selected = true;
	$('#cobraIVASeguroCuota').val('N').selected = true;
	$('#montoSeguroCuota').val('');

	$('#comentarios').show();
	$('#comentario').val('');
	$('#separa').hide();

	$('#folioConsultaBC').val('');
	$('#folioConsultaCC').val('');
	$('#deudorOriginalID').val('');
	$('#nombreDeudorOriginal').val('');
	$('#numTransaccion').val('');
	$('#folioConsolidaID').val('');
	$('#creditoID').val('');
	$('#datosCredito').val('');
	$('#fechaDesembolso').val(parametroBean.fechaAplicacion);
	$('#fechaInicioAmor').val(parametroBean.fechaAplicacion);
	$("#fechaInicioAmor").attr('readonly', true);
	$("#fechaInicioAmor").datepicker("destroy");
	$("#fechaDesembolso").attr('readonly', true);
	$("#fechaDesembolso").datepicker("destroy");


	// valida si la pantalla fue llamada desde solicitud grupal para mantener el  numero de grupo o inicializarlo
	if ($('#grupo').val() != '' && $('#grupo').val() != undefined && $('#grupo').asNumber() != '0') {
		$('#grupoID').val($('#grupo').val());
		$('#nombreGr').val($('#nombreGrupo').val());
		// si el grupo ya esta y esta definido el producto de credito
		if ($('#productoCredito').asNumber() != 0) {
			$('#productoCreditoID').val($('#productoCredito').val());
			$('#descripProducto').val($('#nombreProducto').val());
			deshabilitaControl('productoCreditoID');
		}
	} else {
		habilitaControl('productoCreditoID');
		$('#grupoID').val("");
		$('#nombreGr').val("");
		$('#productoCreditoID').val("");
		$('#descripProducto').val("");

	}

	$("#tdTasaFija").show();
	$('#acreditadoIDFIRA').val("");
	$('#creditoIDFIRA').val("");
	mostrarElementoPorClase('mostrarAcredFIRA', false);
	mostrarElementoPorClase('mostrarAcred', false);
	mostrarElementoPorClase('mostrarCred', false);
}

//funcion para inicializar las variables
function inicializaVariables() {
	montoSolicitudBase = 0; // monto original del credito(sin comision x apertura ni seguro de vida cuando estos son financiadas)
	montoOriginalSolicitud = montoSolicitudBase;
	montoComApeBase = 0; // monto de la comision por apertura
	montoIvaComApeBase = 0; // monto del iva de la comision por apertura
	formaCobroComApe = ""; // forma de cobro de la comision por apertura (adelantada, financiamiento, deduccion)
	montoComIvaSol = 0; // monto que incluye el iva, la comision por apertura  seg vida
	// variables que se ocupan como base para saber si los datos seleccionados an cambiado y se ejecuten ciertas consultas
	clienteIDBase = 0; // numero de cliente que escoge en un inicio el usuario
	productoIDBase = 0; // numero de producto que escoge en un inicio el usuario
	prospectoIDBase = 0; // numero de prospecto que escoge en un inicio el
	// usuario
	if ($('#grupo').val() == undefined && $('#solicitudCreditoID').asNumber() == '0') {
		grupoIDBase = 0; // numero de grupo que en un inicio se escoge (se usa cuando es pantalla individual)
	}
	solicitudIDBase = 0;

	// variables que se utilizan para validar el monto minimo o maximo de la
	// solicitud
	// toman sus valores al consultar el producto de credito
	montoMaxSolicitud = 0.0; // indica el monto maximo que puede escoger en
	// la solicitud
	montoMinSolicitud = 0.0; // indica el monto minimo que puede escoger en
	// la solicitud

	// variables que sirven como base para recalculor el monto del seguro de
	// vida
	fechaVencimientoInicial = "";
	requiereSeg = ""; // indica si requiere o no seguro de vida

	// declaracion de variables que sirven como banderas.
	continuar = 0;
	numTransaccionInicGrupo = 0;
	tipoOperacionGrupo = '';
	deudorOriginalID = 0;
	montoOperacion = 0.00;
	banderaProyeccion = 0;
	banderaCliente = 0;
	mensajeValidacion = "";
	fechaVencimientoLinea = '1900-01-01';
	montoLineaCreditoAgro = 0.00;
	forCobComAdmon = '';
	forCobComGarantia = '';
	manejaComAdmon = '';
	manejaComGarantia = '';
	porcentajeComAdmon = 0.00;
	porcentajeComGarantia = 0.00;
}

//funcion que inicializa los combos, elimina los valores que tenia cargados y deja por default SELECCIONAR
function inicializaCombos() {
	$('#tipoPagoCapital').each(function() {
		$('#tipoPagoCapital option').remove();
	});
	$('#tipoPagoCapital').append(new Option('SELECCIONAR', '', true, true));

	$('#frecuenciaCap').each(function() {
		$('#frecuenciaCap option').remove();
	});
	$('#frecuenciaCap').append(new Option('SELECCIONAR', '', true, true));

	$('#frecuenciaInt').each(function() {
		$('#frecuenciaInt option').remove();
	});
	$('#frecuenciaInt').append(new Option('SELECCIONAR', '', true, true));

	$('#plazoID').each(function() {
		$('#plazoID option').remove();
	});
	$('#plazoID').append(new Option('SELECCIONAR', '', true, true));

	$('#tipoDispersion').each(function() {
		$('#tipoDispersion option').remove();
	});
	$('#tipoDispersion').append(new Option('SELECCIONAR', '', true, true));

}

function validaGrupoSolGrupal() {
	// seccion para validar si la pantalla fue llamada desde la pantalla  solicitud grupal(pivote) refresca los valores de
	// los integrantes, no eliminar, esto no afecta el comportamiento individual  de la pantalla

	if ($('#grupo').val() != undefined) {
		consultaIntegrantesGrid();
		var solicitud = $('#solicitudCreditoID').val();
		$('#numSolicitud').val(solicitud);
	} else {
		// $('#grupoID').val("");
	}

	if ($('#solicitudCreditoID').val() != undefined && $('#solicitudCreditoID').asNumber() == 0 && $('#grupo').val() == undefined) {
		inicializarSolicitud();
	}

}

function validaFlujoIndividual() {
	// seccion para validar si la pantalla fue llamada desde la pantalla de  flujo individual(pivote) refresca los valores de
	// la solicitud no eliminar, esto no afecta el comportamiento individual de  la pantalla
	if ($('#flujoIndividualBandera').val() != undefined) {
		var solicitud = $('#solicitudCreditoID').val();
		$('#numSolicitud').val(solicitud);
		consultaDatosSolicitud();
	}
}

/* funcion para ocultar el numero de grupo, nombre e integrante */
function funcionOcultaDivGrupo() {
	$('#nombreGr').val("");
	$('#grupoID').val("");
	$('#tipoIntegrante').val("4");
	$('#nombreGr').hide();
	$('#grupoID').hide();
	$('#tipoIntegrante').hide();
	$('#grupoDiv').hide();
}

/* funcion para mostrar el numero de grupo, nombre e integrante */
function funcionMuestraDivGrupo() {
	$('#nombreGr').show();
	$('#grupoID').show();
	$('#tipoIntegrante').show();
	$('#grupoDiv').show();
}

/////funcion para consultar y validar los datos grupales y guarda el error
function validaDatosGrupales(idControl, solicitud, prospecto, cliente, productoCre, grupo) {
	// id control se refiere al dato que esta tomando de el espacio select, input de la forma para procesar la informacion

	if (productoCre > 0) {
		// nuevo paso n 1 obtener los datos ya que tenemos grupo y producto de credito de credito
		var proCredBean = '';
		var conGrupo = 8;
		proCredBean = {
			'producCreditoID' : productoCre
		};
		productosCreditoServicio.consulta(4, proCredBean, {
			callback : function(procred) {
				if (procred != null) {
					if (procred.esGrupal == 'S') {
						max = Number(procred.maxIntegrantes);
						maxh = Number(procred.maxHombres);
						maxm = Number(procred.maxMujeres);
						maxms = Number(procred.maxMujeresSol);
						minms = Number(procred.minMujeresSol);

						if (grupo > 0) {
							var GrupoBeanCon = {
								'grupoID' : grupo
							};
							gruposCreditoServicio.consulta(conGrupo, GrupoBeanCon, {
								callback : function(grupo) {
									if (grupo != null) {


									} else {
										mensajeSis('El Grupo No Existe.');
										validacion_maxminExitosa = true;
										deshabilitaBoton('agregar', 'submit');
										deshabilitaBoton('modificar', 'submit');
										deshabilitaBoton('liberar', 'submit');
										deshabilitaBoton('agregaConsolidacion', 'submit');
									}
								},
								errorHandler : function(message, exception) {
									mensajeSis("Error en Validación de Créditos Grupales.<br>" + message + ":" + exception);
								}
							});
						} else {
							// mensajeSis('No se igresaron caracteres
							// validos para el Número de Grupo ');
						}
					}
				} else {
					mensajeSis('El Producto de Crédito Ingresado No existe.');
					validacion_maxminExitosa = true;
					deshabilitaBoton('agregar', 'submit');
					deshabilitaBoton('modificar', 'submit');
					deshabilitaBoton('liberar', 'submit');
					deshabilitaBoton('agregaConsolidacion', 'submit');
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error al consultar Producto de Crédito.<br>" + message + ":" + exception);
			}
		});

	}
	// return validacion_maxminExitosa;
}

/* *****************************CALENDARIO IRREGULAR *****************************************/
/*
 * funcion para sugerir fecha y monto de acuerdo a lo que ya se habia indicado
 * en el formulario.
 */
function sugiereFechaSimuladorLibre() {
	var numDetalle = $('input[name=fechaVencim]').length;
	var varFechaVenID = eval("'#fechaVencim" + numDetalle + "'");
	$(varFechaVenID).val($('#fechaVencimiento').val());
	$(varFechaVenID).focus();
	var varCapitalID = eval("'#capital" + numDetalle + "'");
	if (numDetalle > 1) {
		$(varCapitalID).val($('#diferenciaCapital').val());
		$('#diferenciaCapital').val("0.00");
		$(varCapitalID).formatCurrency({
			positiveFormat : '%n',
			roundToDecimalPlace : 2
		});
	} else {
		$(varCapitalID).val($('#montoSolici').val());
		$(varCapitalID).formatCurrency({
			positiveFormat : '%n',
			roundToDecimalPlace : 2
		});
	}
}

function verificarvaciosCapFec() {
	$('#montosCapital').val("");
	var regresar = 1;
	$('#TablaAmortizaLibresBody tr').each(function(index) {
		var fechaInAmortizacion = "#" + $(this).find("input[name^='fechaInicio'").attr("id");
		var fechaVencimAmor = "#" + $(this).find("input[name^='fechaVencim'").attr("id");
		var fechaInAmortizacionVal = $(fechaInAmortizacion).val();
		var fechaVencimAmorVal = $(fechaVencimAmor).val();

		if(fechaInAmortizacionVal ==""){
			$(fechaInAmortizacion).addClass("error");
			regresar = 1;
			mensajeSis("Especifique Fecha de Inicio");
		} else {
			regresar = 3;
			$(fechaInAmortizacion).removeClass("error");
		}

		if(fechaVencimAmorVal ==""){
			$(fechaVencimAmor).addClass("error");
			regresar = 1;
			mensajeSis("Especifique Fecha de Vencimiento");
		} else {
			regresar = 4;
			$(fechaVencimAmor).removeClass("error");
		}

	});

	return regresar;
}

//funcion para validar que la fecha de vencimiento indicada sea mayor a la de
//inicio
function comparaFechas(varid) {
	var fila = varid.substr(11, varid.length);
	var jqFechaIni = eval("'#fechaInicio" + fila + "'");
	var jqFechaVen = eval("'#fechaVencim" + fila + "'");

	var fechaIni = $(jqFechaIni).val();
	var fechaVen = $(jqFechaVen).val();
	var xYear = fechaIni.substring(0, 4);
	var xMonth = fechaIni.substring(5, 7);
	var xDay = fechaIni.substring(8, 10);
	var yYear = fechaVen.substring(0, 4);
	var yMonth = fechaVen.substring(5, 7);
	var yDay = fechaVen.substring(8, 10);
	if ($(jqFechaVen).val() != "") {
		if (esFechaValida($(jqFechaVen).val(), jqFechaVen)) {
			if (validaFechaVencimientoGrid($(jqFechaVen).val(), $('#fechaVencimiento').val(), jqFechaVen, fila)) {
				if (yYear < xYear) {
					mensajeSis("La Fecha Indicada debe ser Mayor a la Fecha de Inicio.");
					document.getElementById("fechaVencim" + fila).focus();
					$("#fechaVencim" + fila).val("");
					$(jqFechaVen).addClass("error");
				} else {
					if (xYear == yYear) {
						if (yMonth < xMonth) {
							mensajeSis("La Fecha Indicada debe ser Mayor a la Fecha de Inicio.");
							document.getElementById("fechaVencim" + fila).focus();
							$("#fechaVencim" + fila).val("");
							$(jqFechaVen).addClass("error");

						} else {
							if (xMonth == yMonth) {
								if (yDay < xDay || yDay == xDay) {
									mensajeSis("La Fecha Indicada debe ser Mayor a la Fecha de Inicio.");
									document.getElementById("fechaVencim" + fila).focus();
									$("#fechaVencim" + fila).val("");
									$(jqFechaVen).addClass("error");
								} else {
									/* FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y LAS FILAS
									 * CONTINUEN DE MANERA COHERENTE. */
									comparaFechaModificadaSiguiente(fila, jqFechaVen, jqFechaIni);
								}
							} else {
								/*  FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y LAS FILAS
								 * CONTINUEN DE MANERA COHERENTE. */
								comparaFechaModificadaSiguiente(fila, jqFechaVen, jqFechaIni);

							}
						}
					} else {
						/*  FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE  MODIFICA O ELIMIMA Y LAS FILAS CONTINUEN DE MANERA
						 * COHERENTE.  */
						comparaFechaModificadaSiguiente(fila, jqFechaVen, jqFechaIni);
					}
				}
			} else {
				$(jqFechaVen).focus();
			}
		} else {
			$(jqFechaVen).focus();
		}
	}
}

//funcion para validar que la fecha de vencimiento No sea mayor a la de vencimiento calculada por los plazos.
function validaFechaVencimientoGrid(fechaVenGrid, fechaVenCred, jqFechaVen, fila) {
	var xYear = fechaVenCred.substring(0, 4);
	var xMonth = fechaVenCred.substring(5, 7);
	var xDay = fechaVenCred.substring(8, 10);

	var yYear = fechaVenGrid.substring(0, 4);
	var yMonth = fechaVenGrid.substring(5, 7);
	var yDay = fechaVenGrid.substring(8, 10);
	if (esFechaValida(fechaVenGrid)) {
		if (yYear > xYear) {
			mensajeSis("La Fecha debe ser Menor o Igual a la Fecha de Vencimiento.");
			document.getElementById("fechaVencim" + fila).focus();
			$(jqFechaVen).addClass("error");
			return false;
		} else {
			if (xYear == yYear) {
				if (yMonth > xMonth) {
					mensajeSis("La Fecha debe ser Menor o Igual a la Fecha de Vencimiento.");
					document.getElementById("fechaVencim" + fila).focus();
					$(jqFechaVen).addClass("error");
					return false;
				} else {
					if (xMonth == yMonth) {
						if (yDay > xDay) {
							mensajeSis("La Fecha debe ser Menor o Igual a la Fecha de Vencimiento.");
							document.getElementById("fechaVencim" + fila).focus();
							$(jqFechaVen).addClass("error");
							return false;
						}
					}
				}
			}
		}
	} else {
		$(jqFechaVen).focus();
	}
	return true;
}
/*  funcion para calcular la diferencia del monto con lo que se va poniendo en el  grid de pagos libres.  */
function calculaDiferenciaSimuladorLibre() {
	var sumaMontoCapturado = 0;
	var diferenciaMonto = 0;
	var numero = 0;
	var varCapitalID = "";
	var muestraAlert = true;
	$('input[name=capital]').each(function() {
		numero = this.id.substr(7, this.id.length);
		numDetalle = $('input[name=capital]').length;
		varCapitalID = eval("'#capital" + numero + "'");
		sumaMontoCapturado = sumaMontoCapturado + $(varCapitalID).asNumber();

		if (sumaMontoCapturado.toFixed(2) > $('#montoSolici').asNumber()) {
			if (muestraAlert) {
				mensajeSis("La suma de Montos de Capital debe ser Igual al Monto Solicitado.");
				muestraAlert = false;
			}
			$(varCapitalID).val("");
			$(varCapitalID).select();
			$(varCapitalID).focus();
			$(varCapitalID).formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 2
			});
			return false;
		} else {
			diferenciaMonto = $('#montoSolici').asNumber() - sumaMontoCapturado.toFixed(2);
			$('#diferenciaCapital').val(diferenciaMonto);
			$('#diferenciaCapital').formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 2
			});
			$(varCapitalID).formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 2
			});
		}
	});

}

//--------------- funcion para validar la fecha --------------------------
function esFechaValida(fecha, jcontrol) {
	if (fecha != undefined && fecha.value != "") {
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)) {
			mensajeSis("Formato de Fecha No Válido (aaaa-mm-dd).");
			$(jcontrol).val('');
			$(jcontrol).focus();
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
				mensajeSis("Fecha Introducida es Errónea.");
			return false;
		}
		if (dia > numDias || dia == 0) {
			mensajeSis("Fecha Introducida es Errónea.");
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

/* Cancela las teclas [ ] en el formulario */
document.onkeypress = pulsarCorchete;
function pulsarCorchete(e) {
	tecla = (document.all) ? e.keyCode : e.which;
	if (tecla == 91 || tecla == 93) {
		return false;
	}
	return true;
}

//funcion para poner el formato de moneda en el Grid
function agregaFormatoMonedaGrid(controlID) {
	jqID = eval("'#" + controlID + "'");
	$(jqID).formatCurrency({
		positiveFormat : '%n',
		roundToDecimalPlace : 2
	});
}

/* Para ejecutar el simulador de pagos libres de capital y fecha cuando das clic en el boton calcular */

function validaFechas() {
	$('tr[name=renglon]').each(function() {
		var ID = this.id.substring(7);

		var jqFechaInicio = eval("'#fechaInicio" + ID + "'");
		var jqFechaVencim = eval("'#fechaVencim" + ID + "'");
		var jqFechaExigible = eval("'#fechaExigible" + ID + "'");
		var jqInteres = eval("'#interes" + ID + "'");
		var jqIvaInteres = eval("'#ivaInteres" + ID + "'");
		var jqTotalPago = eval("'#totalPago" + ID + "'");
		var jqSaldoInsoluto = eval("'#saldoInsoluto" + ID + "'");

		var fechaInicio = $(jqFechaInicio).val();
		var fechaVencim = $(jqFechaVencim).val();
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;

		if (!objRegExp.test(fechaVencim)) {
			mensajeSis("Formato de Fecha No Válido (aaaa-mm-dd).");
			$(jqFechaVencim).val('');
			$(jqFechaVencim).focus();
			return false;
		}

		if (fechaVencim < fechaInicio) {
			$(jqFechaVencim).val('');
			$(jqFechaExigible).val('');
			$(jqInteres).val('');
			$(jqIvaInteres).val('');
			$(jqTotalPago).val('');
			$(jqSaldoInsoluto).val('');
			mensajeSis('La fecha de Vencimiento no puede ser Menor a la Fecha de Inicio.');
			$(jqFechaVencim).focus();
			return false;
		}
	});
	return true;
}

function crearMontosCapitalFecha() {
	var mandar = verificarvaciosCapFec();
	var regresar = 1;
	if (mandar != 1) {
		var suma = sumaCapital();
		if (suma != 1) {
			var numAmortizacion = $('input[name=capital]').length;
			$('#montosCapital').val("");
			for (var i = 1; i <= numAmortizacion; i++) {
				var idCapital = eval("'#capital" + i + "'");
				if (i == 1) {
					$('#montosCapital').val($('#montosCapital').val() + i + ']' + $(idCapital).asNumber() + ']' + document.getElementById("fechaInicio" + i + "").value + ']' + document.getElementById("fechaVencim" + i + "").value);
				} else {
					$('#montosCapital').val($('#montosCapital').val() + '[' + i + ']' + $(idCapital).asNumber() + ']' + document.getElementById("fechaInicio" + i + "").value + ']' + document.getElementById("fechaVencim" + i + "").value);
				}
			}
			regresar = 2;
		} else {
			regresar = 1;
		}
	}
	return regresar;
}

//funcion para verificar que la suma del capital sea igual que la del monto
function sumaCapital() {
	var jqCapital;
	var suma = 0;
	var contador = 1;
	var capital;
	esTab = true;
	$('input[name=capital]').each(function() {
		jqCapital = eval("'#" + this.id + "'");
		capital = $(jqCapital).asNumber();
		if (capital != '' && !isNaN(capital) && esTab) {
			suma = suma + capital;
			contador = contador + 1;
			$(jqCapital).formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 2
			});
		} else {
			$(jqCapital).val(0);
		}
	});
	if (suma.toFixed(2) != $('#montoSolici').asNumber()) {
		mensajeSis("La suma de Montos de Capital debe ser Igual al Monto Solicitado.");
		deshabilitaBoton('continuar', 'submit');
		return 1;
	}
}

function crearMontosCapital(numTransac) {
	var suma = sumaCapital();
	var idCapital = "";
	if (suma != 1) {
		$('#montosCapital').val("");
		for (var i = 1; i <= $('input[name=capital]').length; i++) {
			idCapital = eval("'#capital" + i + "'");
			if ($(idCapital).asNumber() >= "0") {
				if (i == 1) {
					$('#montosCapital').val($('#montosCapital').val() + i + ']' + $(idCapital).asNumber() + ']' + numTransac);
				} else {
					$('#montosCapital').val($('#montosCapital').val() + '[' + i + ']' + $(idCapital).asNumber() + ']' + numTransac);
				}
			}
		}
		return 2;
	}
}

//funcion que bloque la pantalla mientras se cotiza
function bloquearPantallaAmortizacion() {
	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
	$('#contenedorForma').block({
		message : $('#mensaje'),
		css : {
			border : 'none',
			background : 'none'
		}
	});

}
//agrega el scroll al div de simulador de pagos libres de capital
$('#contenedorSimuladorLibre').scroll(function() {

});

/*
 * FUNCION PARA VALIDAR QUE LA ULTIMA CUOTA DE CAPITAL EN EL COTIZADOR DE PAGOS
 * LIBRES EN CAPITAL O IRREGULAR NO SEA CERO.
 */
function validaUltimaCuotaCapSimulador() {
	var procede = 0;
	if ($('#tipoPagoCapital').val() == "L") {
		var numAmortizacion = $('input[name=capital]').length;
		for (var i = 1; i <= numAmortizacion; i++) {
			if (i == numAmortizacion) {
				var idCapital = eval("'#capital" + i + "'");
				if ($(idCapital).asNumber() == 0) {
					document.getElementById("capital" + i + "").focus();
					document.getElementById("capital" + i + "").select();
					$("capital" + i).addClass("error");
					mensajeSis("La Última Cuota de Capital no puede ser Cero.");
					procede = 1;
				} else {
					if ($('#diferenciaCapital').asNumber() == 0) {
						procede = 0;
					} else {
						mensajeSis(" La Suma de capital en Amortizaciones debe ser igual al Monto Solicitado.");
						procede = 1;
					}
				}
			} else {
				if ($('#diferenciaCapital').asNumber() == 0) {
					procede = 0;
				} else {
					mensajeSis(" La Suma de capital en Amortizaciones debe ser igual al Monto Solicitado.");
					procede = 1;
				}
			}
		}
	} else {
		/*
		 * se valida que si el tipo de pago de capital es libre, no se pueda  escoger como frecuencia la opcion de libre  */
		if ($('#frecuenciaInt').val() == "L" && $('#calendIrregular').val() == "N") {
			mensajeSis("La Frecuencia de Interés Libre sólo Aplica para Calendario Irregular.");
			$('#frecuenciaInt').focus();
			$('#frecuenciaInt').val("");
			procede = 1;
		} else {
			if ($('#frecuenciaCap').val() == "L" && $('#calendIrregular').val() == "N") {
				mensajeSis("La Frecuencia de Capital Libre sólo Aplica para Calendario Irregular.");
				$('#frecuenciaCap').focus();
				$('#frecuenciaCap').val("");
				procede = 1;
			} else {
				procede = 0;
			}
		}
	}
	return procede;
}
/*  FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y LAS  FILAS CONTINUEN DE MANERA COHERENTE.  */
function ajustaValoresFechaElimina(numeroID, jqFechaInicio) {
	var idCajaRenom = "";
	var siguiente = 0;
	var anterior = 0;
	var continuar = 0;
	var numFilas = $('input[name=fechaVencim]').length;

	if (numeroID <= numFilas) {
		if (numeroID == 1) {
			siguiente = parseInt(numeroID) + parseInt(1);
			idCajaRenom = eval("'#fechaInicio" + siguiente + "'");
			$(idCajaRenom).val($(jqFechaInicio).val());
			continuar = 1;
		} else {
			if (numeroID < numFilas) {
				siguiente = parseInt(numeroID) + parseInt(1);
				anterior = parseInt(numeroID) - parseInt(1);
				idCajaRenom = eval("'#fechaInicio" + siguiente + "'");
				jqFechaVencim = eval("'#fechaVencim" + anterior + "'");
				$(idCajaRenom).val($(jqFechaVencim).val());
				continuar = 1;
			} else {
				if (numeroID == numFilas) {
					continuar = 1;
				}
			}
		}
	}
	return continuar;
}

/*  FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y LAS  FILAS CONTINUEN DE MANERA COHERENTE. */
function ajustaValoresFechaModifica(numeroID, jqFechaInicio) {
	var idCajaRenom = "";
	var siguiente = 0;
	var continuar = 0;
	var numFilas = $('input[name=fechaVencim]').length;

	if (numeroID <= numFilas) {
		if (numeroID < numFilas) {
			siguiente = parseInt(numeroID) + parseInt(1);
			idCajaRenom = eval("'#fechaInicio" + siguiente + "'");
			jqFechaVencim = eval("'#fechaVencim" + numeroID + "'");
			$(idCajaRenom).val($(jqFechaVencim).val());
			continuar = 1;
		} else {
			if (numeroID == numFilas) {
				continuar = 1;
			}
		}
	}
	return continuar;
}

/*  FUNCION PARA VALIDAR QUE LA FECHA DE VENCIMIENTO MODIFICADA NO SEA MAYO A LA  FECHA DE VENCIMIENTO SIGUIENTE */
function comparaFechaModificadaSiguiente(varid, jqFechaVen, jqFechaInicio) {
	var siguiente = parseInt(varid) + parseInt(1);
	var numFilas = $('input[name=fechaVencim]').length;
	if (varid < numFilas) {
		var jqFechaVenSiguiente = eval("'#fechaVencim" + siguiente + "'");

		var fechaIni = $(jqFechaVen).val();
		var fechaVen = $(jqFechaVenSiguiente).val();
		var xYear = fechaIni.substring(0, 4);
		var xMonth = fechaIni.substring(5, 7);
		var xDay = fechaIni.substring(8, 10);
		var yYear = fechaVen.substring(0, 4);
		var yMonth = fechaVen.substring(5, 7);
		var yDay = fechaVen.substring(8, 10);
		if ($(jqFechaVen).val() != "") {
			if (esFechaValida($(jqFechaVen).val(), jqFechaVen)) {
				if (validaFechaVencimientoGrid($(jqFechaVen).val(), $('#fechaVencimiento').val(), jqFechaVen, varid)) {
					if (yYear < xYear) {
						mensajeSis("La Fecha Indicada debe ser Menor a la Fecha de Vencimiento \nde la siguiente Amortizazion.");
						document.getElementById("fechaVencim" + varid).focus();
						$(jqFechaVen).addClass("error");
					} else {
						if (xYear == yYear) {
							if (yMonth <= xMonth) {
								if (xMonth == yMonth) {
									if (yDay <= xDay || yDay == xDay) {
										mensajeSis("La Fecha Indicada debe ser Menor a la Fecha de Vencimiento \nde la siguiente Amortizazion.");
										document.getElementById("fechaVencim" + varid).focus();
										$(jqFechaVen).addClass("error");
									} else {
										ajustaValoresFechaModifica(varid, jqFechaInicio);
									}
								} else {
									ajustaValoresFechaModifica(varid, jqFechaInicio);
								}
							} else {
								ajustaValoresFechaModifica(varid, jqFechaInicio);
							}
						} else {
							ajustaValoresFechaModifica(varid, jqFechaInicio);
						}
					}
				} else {
					$(jqFechaVen).focus();
				}
			} else {
				$(jqFechaVen).focus();
			}
		}
	}
} // fin comparaFechaModificadaSiguiente

function habilitarBotonesSol() {
	if ($('#solicitudCreditoID').val() == '0') {
		deshabilitaBoton('modificar', 'submit');
		deshabilitaBoton('liberar', 'submit');
		habilitaBoton('agregar', 'submit');
		habilitaBoton('agregaConsolidacion', 'submit');

	} else {
		if ($('#estatus').val() != 'I') {
			if ($('#estatus').val() == 'A' || $('#estatus').val() == 'D' || $('#estatus').val() == 'L' || $('#estatus').val() == 'C') {
				deshabilitaBoton('modificar', 'submit');
				deshabilitaBoton('liberar', 'submit');
				deshabilitaBoton('agregar', 'submit');
				deshabilitaBoton('agregaConsolidacion', 'submit');
			}
		} else {
			// si la solicitud es inactiva valida que el promotor pueda liberar la solicitud de credito si
			// corresponde con la sucursal  o si el promotor no atiende sucursal
			if ($('#sucursalID').val() == $('#sucursalPromotor').val() || $('#promAtiendeSuc').val() == 'N') {
				// si se trata de una solicitud individual entonces se muestra y  habilita
				// el boton de liberar, en caso contrario se oculta  si se trata de una solicitud individual entonces se muestra
				// el div  de comentarios, en caso contrario se oculta
				if ($('#grupo').val() != undefined) {
					deshabilitaBoton('liberar', 'submit');
				} else {
					if ($('#flujoIndividualBandera').val() == undefined) {
						habilitaBoton('liberar', 'submit');
					} else {
						deshabilitaBoton('liberar', 'submit');
					}
				}
				habilitaBoton('modificar', 'submit');
				habilitaBoton('agregaConsolidacion', 'submit');
				deshabilitaBoton('agregar', 'submit');
				$('#simular').show();
			} else {
				deshabilitaBoton('liberar', 'submit');
				deshabilitaBoton('modificar', 'submit');
				deshabilitaBoton('agregar', 'submit');
				deshabilitaBoton('agregaConsolidacion', 'submit');
			}
		}
	}
}

/*
 * Realiza las validaciones correspondientes para que se asigne un producto de credito correcto al cliente que solicita el credito
 */
function consultaRelacionCliente(controlID) {
	var tipoCon = 1;
	var beanParametros = {
		'empresaID' : 1

	};
	// Verifica que esta validacion este parametrizado como S = SI en  PARAMETROSIS
	parametrosSisServicio.consulta(tipoCon, beanParametros, function(parametros) {
		if (parametros != null && parametros.validaAutComite == 'S') {
			tipoCon = 1;
			var clienteID = $("#clienteID").val();
			var prospectoID = $("#prospectoID").val();
			var producCreditoID = $("#productoCreditoID").val();
			var SiAutorizaComite = 'S';
			var tipoCliente = '';

			// verifica que el cliente y el producto de credito  sean válidos
			if ((parseInt(clienteID) > 0 || parseInt(prospectoID) > 0) && producCreditoID != '' && producCreditoID != '0') {
				if (clienteID == '' || clienteID == '0') {
					clienteID = 0;
					tipoCliente = 'Prospecto';
				}
				if (prospectoID == '' || prospectoID == '0') {
					prospectoID = 0;
					tipoCliente = $('#alertSocio').val();
				}
				var beanCliente = {
					'clienteID' : clienteID,
					'prospectoID' : prospectoID
				};
				var ProdCredBean = {
					'producCreditoID' : producCreditoID

				};

				// consulta si el cliente es de tipo  Funcionario, Empleado, o si tiene relacion  con otro de tipo Funcionario o Empleado
				relacionClienteServicio.consulta(tipoCon, beanCliente, function(respuesta) {

					if (respuesta != null) {
						productosCreditoServicio.consulta(tipoCon, ProdCredBean, function(prodCred) {
							if (prodCred != null) {
								if (prodCred.autorizaComite != SiAutorizaComite) {
									if (controlID == 'clienteID') {
										mensajeSis("El " + tipoCliente + " No Cumple con los Requerimientos del Producto de Crédito.");
										$("#clienteID").val('');
										$("#nombreCte").val('');
										$("#clienteID").focus();
									} else {
										if (controlID == 'productoCreditoID') {
											mensajeSis("El Producto de Crédito No Aplica para las Características del " + tipoCliente + " Indicado.");
											$("#productoCreditoID").val('');
											$("#productoCreditoID").focus();
										} else {
											mensajeSis("El Prospecto No cumple con los Requerimientos del Producto de Crédito.");
											$("#prospectoID").val('');
											$("#nombreProspecto").val('');
											$("#prospectoID").focus();
										}
									}
								}
							}
						});
					}
				});
			}
		}
	});
}

function calculoTotalCapital() {
	var sumaMontoCapturado = 0;
	var numero = 0;
	var varCapitalID = "";
	var muestraAlert = true;
	$('input[name=capital]').each(function() {
		numero = this.id.substr(7, this.id.length);
		numDetalle = $('input[name=capital]').length;
		varCapitalID = eval("'#capital" + numero + "'");
		sumaMontoCapturado = sumaMontoCapturado + $(varCapitalID).asNumber();

		if (sumaMontoCapturado.toFixed(2) > $('#montoSolici').asNumber()) {
			if (muestraAlert) {
				mensajeSis("La Suma de Montos de Capital debe ser Igual al Monto Solicitado.");
				muestraAlert = false;
			}
			$(varCapitalID).val("");
			$(varCapitalID).select();
			$(varCapitalID).focus();
			$(varCapitalID).formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 2
			});
			return false;
		} else {
			sumaMonto = sumaMontoCapturado.toFixed(2);
			$('#totalCap').val(sumaMonto);
			$('#totalCap').formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 2
			});
			$(varCapitalID).formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 2
			});
		}
	});
}

function calculoTotalInteres() {
	var sumaMontoCapturado = 0;
	var numero = 0;
	var varCapitalID = "";
	$('input[name=capital]').each(function() {
		numero = this.id.substr(7, this.id.length);
		numDetalle = $('input[name=interes]').length;
		varCapitalID = eval("'#interes" + numero + "'");
		sumaMontoCapturado = sumaMontoCapturado + $(varCapitalID).asNumber();
		sumaMonto = sumaMontoCapturado.toFixed(2);
		$('#totalInt').val(sumaMonto);
		$('#totalInt').formatCurrency({
			positiveFormat : '%n',
			roundToDecimalPlace : 2
		});
		$(varCapitalID).formatCurrency({
			positiveFormat : '%n',
			roundToDecimalPlace : 2
		});
	});
}

function calculoTotalSeguros() {
	var sumaMontoCapturado = 0;
	var numero = 0;
	var varCapitalID = "";
	$('input[name=montoSeguroCuotaSim]').each(function() {
		numero = this.id.substr(7, this.id.length);
		numDetalle = $('input[name=montoSeguroCuotaSim]').length;
		varCapitalID = eval("'#montoSeguroCuotaSim" + numero + "'");
		sumaMontoCapturado = sumaMontoCapturado + $(varCapitalID).asNumber();
		sumaMonto = sumaMontoCapturado.toFixed(2);
		$('#totalSeguroCuota').val(sumaMonto);
		$('#totalSeguroCuota').formatCurrency({
			positiveFormat : '%n',
			roundToDecimalPlace : 2
		});
		$(varCapitalID).formatCurrency({
			positiveFormat : '%n',
			roundToDecimalPlace : 2
		});
	});
}

function calculoTotalIva() {
	var sumaMontoCapturado = 0;
	var numero = 0;
	var varCapitalID = "";
	$('input[name=ivaInteres]').each(function() {
		numero = this.id.substr(10, this.id.length);
		numDetalle = $('input[name=ivaInteres]').length;
		varCapitalID = eval("'#ivaInteres" + numero + "'");
		sumaMontoCapturado = sumaMontoCapturado + $(varCapitalID).asNumber();
		sumaMonto = sumaMontoCapturado.toFixed(2);
		$('#totalIva').val(sumaMonto);
		$('#totalIva').formatCurrency({
			positiveFormat : '%n',
			roundToDecimalPlace : 2
		});
		$(varCapitalID).formatCurrency({
			positiveFormat : '%n',
			roundToDecimalPlace : 2
		});
	});
}

function totalizaCap() {
	var suma = 0;
	$('input[name=capital]').each(function() {
		var numero = this.id.substr(7, this.id.length);
		var Cap = eval("'#capital" + numero + "'");
		var capital = $(Cap).asNumber();
		suma = suma + capital;
	});
	return suma;
}

function totalizaInt() {
	var suma = 0;
	$('input[name=interes]').each(function() {
		var numero = this.id.substr(7, this.id.length);
		var Cap = eval("'#interes" + numero + "'");
		var capital = $(Cap).asNumber();
		suma = suma + capital;
	});
	return suma;
}

function totalizaIva() {
	var suma = 0;
	$('input[name=ivaInteres]').each(function() {
		var numero = this.id.substr(10, this.id.length);
		var Cap = eval("'#ivaInteres" + numero + "'");
		var capital = $(Cap).asNumber();
		suma = suma + capital;
	});
	return suma;
}

/* Funcion que genera el reporte Proyeccion de Credito, para mostrar la tabla de amortizaciones generada por el simulador */
function generaReporte() {
	var clienteID = $("#clienteID").val();
	var nombreCliente = $("#nombreCte").val();
	var tipoReporte = 1; // PDF
	var nombreInstitucion = parametroBean.nombreInstitucion;
	var capitalPagar = $("#totalCap").asNumber();
	var interesPagar = $("#totalInt").asNumber();
	var ivaPagar = $("#totalIva").asNumber();
	var frecuencia = $("#frecuenciaCap").val();
	var frecuenciaInt = $("#frecuenciaInt").val();
	var frecuenciaDes = $("#frecuenciaCap option:selected").html();
	var tasaFija = $("#tasaFija").val(); // tasa fija o tasa base

	var numCuotas = $("#numAmortizacion").asNumber();
	var numCuotasInt = $("#numAmortInteres").asNumber();
	var califCliente = $("#calificaCredito").val() + "     " + calificacionCliente;
	var ejecutivo = parametroBean.nombreUsuario;
	var numTransaccion = $('#numTransacSim').val();
	var montoSol = $("#totalCap").asNumber();
	var periodicidad = $('#periodicidadCap').val();
	var periodicidadInt = $('#periodicidadInt').val();

	var diaPago = auxDiaPagoCapital;
	var diaPagoInt = auxDiaPagoInteres;
	var diaMes = $('#diaMesCapital').asNumber();
	var diaMesInt = $('#diaMesInteres').asNumber();

	var fechaInicio = $('#fechaInicioAmor').val();
	var producCreditoID = $('#productoCreditoID').val();
	var diaHabilSig = $('#fechInhabil').val();
	var ajustaFecAmo = $('#ajFecUlAmoVen').val();
	var ajusFecExiVen = $('#ajusFecExiVen').val();
	var comApertura = $("#montoComApert").asNumber();
	var calculoInt = $('#calcInteresID').val();
	var tipoCalculoInt = $('#tipoCalInteres').val();
	var tipoPagCap = $('#tipoPagoCapital').val();
	var cat = ($('#CAT').val()).replace(/\,/g, '');
	var leyenda = encodeURI($('#lblTasaVariable').text().trim());
	// SEGUROS
	var cobraSeguroCuota = $('#cobraSeguroCuota option:selected').val();
	var cobraIVASeguroCuota = $('#cobraIVASeguroCuota option:selected').val();
	var montoSeguroCuota = $('#montoSeguroCuota').asNumber();

	if (clienteID == '' || clienteID == 0) {
		clienteID = $("#prospectoID").val();
		nombreCliente = $("#nombreProspecto").val();
	}
	if (periodicidad == '') {
		periodicidad = 0;
	}
	if (periodicidadInt == '') {
		periodicidadInt = 0;
	}
	if (diaMes == '') {
		diaMes = 0;
	}
	if (diaMesInt == '') {
		diaMesInt = 0;
	}
	if (cat == '') {
		cat = 0.0;
	}

	url = 'reporteProyeccionCredito.htm?clienteID=' + clienteID + '&nombreCliente=' + nombreCliente + '&tipoReporte=' + tipoReporte + '&nombreInstitucion=' + nombreInstitucion + '&totalCap=' + capitalPagar + '&totalInteres=' + interesPagar + '&totalIva=' + ivaPagar + '&cat=' + cat + '&califCliente=' + califCliente + '&usuario=' + ejecutivo + '&frecuencia=' + frecuencia + '&frecuenciaInt=' + frecuenciaInt + '&frecuenciaDes=' + frecuenciaDes + '&tasaFija=' + tasaFija + '&numCuotas=' + numCuotas + '&numCuotasInt=' + numCuotasInt + '&montoSol=' + montoSol + '&periodicidad=' + periodicidad + '&periodicidadInt=' + periodicidadInt + '&diaPago=' + diaPago + '&diaPagoInt=' + diaPagoInt + '&diaMes=' + diaMes + '&diaMesInt=' + diaMesInt + '&fechaInicio=' + fechaInicio + '&producCreditoID=' + producCreditoID + '&diaHabilSig=' + diaHabilSig + '&ajustaFecAmo=' + ajustaFecAmo + '&ajusFecExiVen=' + ajusFecExiVen + '&comApertura=' + comApertura + '&calculoInt=' + calculoInt + '&tipoCalculoInt=' + tipoCalculoInt + '&tipoPagCap=' + tipoPagCap + '&numTransaccion=' + numTransaccion + '&cobraSeguroCuota=' + cobraSeguroCuota + '&cobraIVASeguroCuota=' + cobraIVASeguroCuota + '&montoSeguroCuota=' + montoSeguroCuota + '&leyendaTasaVariable=' + leyenda;
	window.open(url, '_blank');

}
//Función para calcular los días transcurridos entre dos fechas
function restaFechas(fAhora, fEvento) {

	var ahora = new Date(fAhora);
	var evento = new Date(fEvento);
	var tiempo = evento.getTime() - ahora.getTime();
	var dias = Math.floor(tiempo / (1000 * 60 * 60 * 24));

	return dias;
}

function consultaEsquemaSeguroVida(esq, tipoPAg) {
	var prodCre = $('#productoCreditoID').val();
	var esquemaSeguroVid = esq;
	var tipPagoSegu = $('#forCobroSegVida').val();

	var esquemaSeguroBean = {
		'productoCreditoID' : prodCre,
		'esquemaSeguroID' : esquemaSeguroVid,
		'tipoPagoSeguro' : tipPagoSegu
	};

	var tipoConsulta = 3;
	esquemaSeguroVidaServicio.consulta(tipoConsulta, esquemaSeguroBean, function(esquema) {
		if (esquema != null) {
			factorRS = esquema.factorRiesgoSeguro;
			porcentajeDesc = esquema.descuentoSeguro;
			montoPol = esquema.montoPolSegVida;
			$('#montoPolSegVida').val(montoPol);
		} else {
			factorRS = 0;
			porcentajeDesc = 0.00;
			montoPol = 0.00;
		}
	});
}

function consultaEsquemaSeguroVidaForanea(tiPago) {
	var prodCre = $('#productoCreditoID').val();
	var esquemaSeguroVid = $('#esquemaSeguroID').val();
	var tipPagoSegu = tiPago;
	$('#forCobroSegVida').val(tiPago);

	var esquemaSeguroBean = {
		'productoCreditoID' : prodCre,
		'esquemaSeguroID' : esquemaSeguroVid,
		'tipoPagoSeguro' : tipPagoSegu
	};

	var tipoConsulta = 2;
	esquemaSeguroVidaServicio.consulta(tipoConsulta, esquemaSeguroBean, function(esquema) {
		if (esquema != null) {
			factorRS = esquema.factorRiesgoSeguro;
			porcentajeDesc = esquema.descuentoSeguro;
			montoPol = esquema.montoPolSegVida;
			if (modalidad = 'T') {
				$('#montoPolSegVida').val(esquema.montoPolSegVida);
				$('#descuentoSeguro').val(esquema.descuentoSeguro);
			} else {}
		} else {
			factorRS = 0;
			porcentajeDesc = 0.00;
			montoPol = 0.00;
		}
	});
}

function consultaTiposPago(prod, esq, varTipoPagoSeguro) {
	var prodCre = prod;
	var esquemaSeguroVid = esq;

	var esquemaSeguroBean = {
		'productoCreditoID' : prodCre,
		'esquemaSeguroID' : esquemaSeguroVid
	};
	var tipoLista = 3;
	dwr.util.removeAllOptions('tipPago');
	esquemaSeguroVidaServicio.lista(esquemaSeguroBean, tipoLista, function(esquemasSeguroVida) {
		$('#tipPago').append(new Option('SELECCIONAR', "", true, true));

		for (var i = 0; i < esquemasSeguroVida.length; i++) {
			$('#tipPago').append(new Option(esquemasSeguroVida[i].descTipPago, esquemasSeguroVida[i].tipoPagoSeguro));

			if (varTipoPagoSeguro == esquemasSeguroVida[i].tipoPagoSeguro) {
				$('#tipPago').val(varTipoPagoSeguro).select();
			}
		}
	});
}

//Funcion que cambia la etiqueta de Tasa Fija Actualizada por Tasa Base Actual
function setCalcInteresID(calcInteres, iniciaCampos) {
	$('#calcInteresID').val(calcInteres);
	if (TasaFijaID == calcInteres) {
		VarTasaFijaoBase = 'Tasa Fija Anualizada';
	} else {
		VarTasaFijaoBase = 'Tasa Base Actual';
	}
	$('#lblTasaFija').text(VarTasaFijaoBase + ': ');
	if (iniciaCampos) {
		limpiaCamposTasaInteres();
	}
	habilitaCamposTasa(calcInteres);
}

//Funcion que limpia los campos de Tasas
function limpiaCamposTasaInteres() {
	$('#tasaBase').val('');
	$('#desTasaBase').val('');
	$('#tasaFija').val('');
	$('#sobreTasa').val('');
	$('#pisoTasa').val('');
	$('#techoTasa').val('');

	$("#tdTasaFija").show();

}

//Funcion que habilita y da formato de tasa dependiendo del calculo de interes
function habilitaCamposTasa(calcInteresID) {
	if (calcInteresID == TasaFijaID) {
		deshabilitaControl('tasaFija');
		deshabilitaControl('pisoTasa');
		deshabilitaControl('tasaBase');
		deshabilitaControl('sobreTasa');
		deshabilitaControl('techoTasa');
	}

	if (calcInteresID == 2 || calcInteresID == 4) {
		deshabilitaControl('tasaFija');
		deshabilitaControl('pisoTasa');
		habilitaControl('tasaBase');
		habilitaControl('sobreTasa');
		deshabilitaControl('techoTasa');
	}

	if (calcInteresID == TasaBasePisoTecho) {
		deshabilitaControl('tasaFija');
		habilitaControl('pisoTasa');
		habilitaControl('tasaBase');
		habilitaControl('sobreTasa');
		habilitaControl('techoTasa');
	}
	$('#tasaFija').formatCurrency({
		positiveFormat : '%n',
		roundToDecimalPlace : 4
	});
	$('#pisoTasa').formatCurrency({
		positiveFormat : '%n',
		roundToDecimalPlace : 4
	});
	$('#sobreTasa').formatCurrency({
		positiveFormat : '%n',
		roundToDecimalPlace : 4
	});
	$('#techoTasa').formatCurrency({
		positiveFormat : '%n',
		roundToDecimalPlace : 4
	});

}

/* Funcion que pone las banderas para que se solicite de nuevo la simulación
 * por cambio en tasas y oculta/limpia los simuladores */
function vuelveaSimular() {
	$("#numTransacSim").val('');
	estatusSimulacion = false;
	$('#contenedorSimulador').html("");
	$('#contenedorSimulador').hide();
	$('#contenedorSimuladorLibre').html("");
	$('#contenedorSimuladorLibre').hide();
}

function javaURLEncode(str) {
	return encodeURI(str).replace(/%20/g, "+").replace(/!/g, "%21").replace(/'/g, "%27").replace(/\(/g, "%28").replace(/\)/g, "%29").replace(/~/g, "%7E");
}

function mostrarLabelTasaFactorMora(tipoFactorMora) {
	if (tipoFactorMora == 'T') {
		$('#lblveces').hide();
		$('#lblTasaFija').show();

	} else if (tipoFactorMora == 'N') {
		$('#lblveces').show();
		$('#lblTasaFija').hide();
	} else {
		$('#lblveces').hide();
		$('#lblTasaFija').hide();
	}
}

function validarEsquemaCobroSeguro() {
	var tipoConPrincipal = 1;
	var productoCreditoID = $('#productoCreditoID').asNumber();
	var frecuenciaInt = $("#frecuenciaInt option:selected").val();
	var frecuenciaCap = $("#frecuenciaCap option:selected").val();
	var mostrarSeguroCuota = $('#mostrarSeguroCuota').val();
	var cobraSeguroCuota = $('#cobraSeguroCuota option:selected').val();
	var esquemaSeguroBean = {
		'producCreditoID' : productoCreditoID,
		'frecuenciaCap' : frecuenciaCap,
		'frecuenciaInt' : frecuenciaInt,
	};

	$('#montoSeguroCuota').val(0);

	if (cobraSeguroCuota == 'S' && mostrarSeguroCuota == 'S') {
		if (productoCreditoID > 0) {
			if (frecuenciaCap != "") {
				if (frecuenciaInt != "") {
					esquemaSeguroServicio.consulta(esquemaSeguroBean, tipoConPrincipal, {
						async : false,
						callback : function(esquemaBean) {
							if (esquemaBean != null) {
								$('#montoSeguroCuota').val(esquemaBean.monto);
							} else {
								mensajeSis('No Existe Parametrizado el Monto de Seguro Para esta Frecuencia.');
								$('#montoSeguroCuota').val("");
								return false;
							}
						}
					});
				} else {
					$('#frecuenciaInt').focus();
					$('#montoSeguroCuota').val("");
				}
			} else {
				$('#frecuenciaCap').focus();
				$('#montoSeguroCuota').val("");
			}
		} else {
			$('#productoCreditoID').focus();
			$('#montoSeguroCuota').val("");
		}
	} else {
		$('#montoSeguroCuota').val("0");
		return true;
	}
	return false;
}

/**
 * Muestra los campos de seguro por cuota solo si generales tiene que Si
 */
function muestraSeccionSeguroCuota() {
	var con_paramSeccionEsp = 16;
	var parametrosSisCon = {
		'empresaID' : 1
	};
	$('#mostrarSeguroCuota').val("N");
	mostrarElementoPorClase('ocultarSeguroCuota', "N");
	parametrosSisServicio.consulta(con_paramSeccionEsp, parametrosSisCon, {
		async : false,
		callback : function(varParamSistema) {
			if (varParamSistema != null) {
				var mostrarSeccionSeguros = varParamSistema.cobraSeguroCuota;
				$('#mostrarSeguroCuota').val(mostrarSeccionSeguros);
				mostrarElementoPorClase('ocultarSeguroCuota', mostrarSeccionSeguros);
				if (mostrarSeccionSeguros == 'N') {
					$('#cobraSeguroCuota').val('N').selected = true;
					$('#cobraIVASeguroCuota').val('N').selected = true;
					$('#montoSeguroCuota').val('0.0');
				}
			} else {
				$('#mostrarSeguroCuota').val("N");
			}
		}
	});
}



function consultaNumeroHabitantes(){
	var tipoConsulta = 20;
	var bean = {
			'empresaID'		: 1
		};

	paramGeneralesServicio.consulta(tipoConsulta, bean, { async: false, callback:function(parametro) {
			if (parametro != null){
				numeroHabitantes = parametro.valorParametro;


			}else{
				numeroHabitantes = 0;
			}

	}});
}



function consultaDirCliente() {
	var direccionesCliente ={
		 'clienteID' : $('#clienteID').val(),
		 'direccionID': '0'

	};
	var numCliente = $('#clienteID').val();
	setTimeout("$('#cajaLista').hide();", 200);

	if(numCliente != '' && !isNaN(numCliente)){
		direccionesClienteServicio.consulta(16,direccionesCliente,{ async: false, callback:function(direccion) {
			if(direccion!=null){

				numeroHabitantesLocalidad = direccion.numeroHabitantes;
			}else{
				numeroHabitantesLocalidad = 0;
			}
		}});
	}
}

function evaluaFinanciamientoRural(){
	consultaNumeroHabitantes();
	consultaDirCliente();
	if(parseInt(numeroHabitantesLocalidad) > parseInt(numeroHabitantes)){
		grabaTransaccion = 1;
		mensajeSis("La Localidad del Cliente no cumple con el número de habitantes para el Financiamiento Rural");

	}else{
		grabaTransaccion = 0;
	}
}

function eliminarConsolidacion(numero){
	var consolidacionesBean = {
		folioConsolidaID 		: $('#listaFolioConsolidaID'+numero).val(),
		detalleFolioConsolidaID : $('#listaDetalleFolioConsolidaID'+numero).val(),
		solicitudCreditoID 		: $('#listaSolicitudCreditoID'+numero).val(),
		creditoID 				: $('#listaCreditoID'+numero).val(),
		transaccion 			: $('#numTransaccion').val(),
		tipoTransaccion			: 2
	};
	var folioConsolidaID = $('#folioConsolidaID').val();

	bloquearPantalla();
	$.post( 'consolidacionCreditoAgro.htm',consolidacionesBean,
		function(consolidacionesResponse) {

		desbloquearPantalla();
		if (consolidacionesResponse != null) {
			if( consolidacionesResponse.numero == 0 ){
				mostrarCreditosConsolidado(folioConsolidaID);

			} else {
				mensajeSis(consolidacionesResponse.descripcion);
			}
		} else {
			mensajeSis("Error en la baja de Créditos Consolidados.");
		}
	});

	$('#folioConsolidaID').focus();
}


function mostrarCreditosConsolidado(folioConsolidaID){

	var consolidacionesBean = {
		folioConsolidaID 	: $('#folioConsolidaID').val(),
		solicitudCreditoID 	: $('#solicitudCreditoID').val(),
		transaccion 		: $('#numTransaccion').val(),
		tipoLista			: 2
	};

	$('#creditosConsolidadosGrid').show();
	$.post("listaConsolidacionesGridAgro.htm", consolidacionesBean,function(consolidacionesResponse) {
		if (consolidacionesResponse.length > 1298) {
			agregaFormatoControles('formaGenerica');
			$('#creditosConsolidadosGrid').html(consolidacionesResponse);
			$('#creditosConsolidadosGrid').show();

			var montoCredito = 0.00;
			var monto  = 0.00;
			var cadena = "";

			var numeroItereciones = $('input[name=listaMontoExigible]').length;
			if(numeroItereciones == 0){
				$('#montoSolici').val(montoCredito);
				return ;
			}

			for(var iteracion = 1; iteracion <= numeroItereciones; iteracion++){

				cadena  = document.getElementById("montoExigible"+iteracion+"").value;
				// Elimina caracteres especiales
				for (var i = 0; i < cadena.length; i++) {
					cadena = cadena.replace(',', '');
				}

				monto = cadena;
				montoCredito = montoCredito + parseFloat(monto);
				monto = 0.00;
				cadena = "";
			}

			montoOperacion = montoCredito;
			montoSolicitudBase = montoCredito;
			montoOriginalSolicitud = montoSolicitudBase;

			$('#montoSolici').val(montoCredito);
			$('#montoSolici').blur();
			$('#montoSolici').formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 2
			});

			if($('#lineaCreditoID').val() ==  0 || $('#lineaCreditoID').val() == '' ){
				$('#diferenciaMinistra').val('0.00');
				$('#totalMinistra').val(montoCredito);
				$('#totalMinistra').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});

				$('#capitalMinis1').val(montoCredito);
				$('#capitalMinis1').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
			}

			$('#creditoID').focus();
		} else {
			agregaFormatoControles('formaGenerica');
			$('#creditosConsolidadosGrid').html('');
			$('#creditosConsolidadosGrid').hide();
			$('#progEspecialFIRADes').val('');
		}
	});
	asignaTipoGarantia();
	$('#creditoID').focus();
}

function deshabilitaCampoLinea(){
	deshabilitaControl('lineaCreditoID');
	deshabilitaControl('tipoLineaAgroID');
	deshabilitaControl('saldoDisponible');
	deshabilitaControl('manejaComAdmon');
	deshabilitaControl('comAdmonLinPrevLiq');
	deshabilitaControl('forPagComAdmon');
	deshabilitaControl('porcentajeComAdmon');
	deshabilitaControl('montoPagComAdmon');
	deshabilitaControl('montoIvaPagComAdmon');
	deshabilitaControl('manejaComGarantia');
	deshabilitaControl('comGarLinPrevLiq');
	deshabilitaControl('forPagComGarantia');
	deshabilitaControl('montoComGarantia');
	deshabilitaControl('montoIvaComGarantia');
	deshabilitaControl('porcentajeComGarantia');

	$('#lineaCreditoID').val('');
	$('#tipoLineaAgroID').val('');
	$('#saldoDisponible').val('');
	$('#manejaComAdmon').val('');
	$('#forPagComAdmon').val('');
	$('#montoPagComAdmon').val('');
	$('#montoIvaPagComAdmon').val('');
	$('#porcentajeComAdmon').val('');
	$('#manejaComGarantia').val('');
	$('#comGarLinPrevLiq').val('');
	$('#forPagComGarantia').val('');
	$('#montoComGarantia').val('');
	$('#montoIvaComGarantia').val('');
	$('#porcentajeComGarantia').val('');
	$('#comGarLinPrevLiq').val('N');
	$('#comAdmonLinPrevLiq').val('N');
	$('#comGarLinPrevLiq').attr("checked", false);
	$('#comAdmonLinPrevLiq').attr("checked", false);
	$('#cobroComAdmon').show();
	$('#cobroComGarantia').show();
}

//Funcion que limpia los campos de lineas Agros
function limpiaCamposLinea() {
	$('#lineaCreditoID').val('');
	$('#tipoLineaAgroID').val('');
	$('#saldoDisponible').val('');
	$('#manejaComAdmon').val('');
	$('#forPagComAdmon').val('');
	$('#montoPagComAdmon').val('');
	$('#montoIvaPagComAdmon').val('');
	$('#porcentajeComAdmon').val('');
	$('#manejaComGarantia').val('');
	$('#forPagComGarantia').val('');
	$('#montoComGarantia').val('');
	$('#montoIvaComGarantia').val('');
	$('#comGarLinPrevLiq').val('');
	$('#porcentajeComGarantia').val('');
	$('#cobroComAdmon').show();
	$('#cobroComGarantia').show();
}