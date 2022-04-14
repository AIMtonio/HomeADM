//============================= Definicion de Constantes y Enums   ========================= //
var catFormTipoCalInt = {
	'principal' : 1,
};
var TasaFijaID = 1; // ID de la formula para tasa fija (FORMTIPOCALINT)
var TasaBasePisoTecho = 3; // ID de la formula para tasa base con piso y techo (FORMTIPOCALINT)
var VarTasaFijaoBase = 'Tasa Fija'; // Texto que indica si se trata de tasa fija o tasa base actual (alert)
var parametroBean = consultaParametrosSession();
var nombreInstitucion;
var estatus;
var inicioAfuturo = ''; // indica si el producto de credito permite el desembolso anticipado del credito
var diasMaximo = 0; // Indica el maximo numero dias a los que se puede desembolsar un credito antes de su fecha de inicio
var autorizado = 'A';
var inactivo = 'I';
var procesado = 'M';
var cobraAccesorios = 'N';
var catTipoTransaccionCredito = {
	'agrega' : '1',
	'modifica' : '2',
	'actualiza' : '3',
	'actNumTraSim' : '5',
	'actuaCredi' : '34',
	'actTmp' : '7',
	'simulador' : '9'
};

var catTipoActCredito = {
	'autoriza' : 12,
	'autorizaPagImp' : 2,
	'actualizaCred' : 33,
	'actualizaCredAmor' : 32,
	'actTmpPagAmor' : 5
};
var catTipoConsultaCredito = {
	'principal' : 1,
	'agropecuario' : 29,
	'foranea' : 2,
	'pagareImp' : 3,
	'ValidaCredAmor' : 4,
	'fechaVencimiento' : 14
};

var catEstatusCredito = {
	'autorizado' : 'A',
	'inactivo' : 'I',
	'procesado' : 'M',
};
var Enum_Credito_Lis = {
	'agropecuario' : 47
};
var Enum_TipoCalculo = {
	'TasaFija' : 1
};
var Enum_TipoPersona = {
	'Fisica' : 'F',
	'FisActEmpresarial' : 'A',
	'Moral' : 'M'
};
var Enum_SubClasifCredito = {
	'HabilitacionAvio' : 125,
	'Refaccionario' : 126
};
var Enum_TipoReporte = {
	'Fisica' : 1,
	'Moral' : 2,
	'MoralUnico' : 3
};
var catNumClienteEsp = {
	'Consol' : 10
};

var Enum_TipoConsultaParamGenerales = {
	'cteEspecifico' : 13,
};

var esTab = false;
var tipoPersona = '';
var destinoCredito = 0;
var subClasifCredito = 0;

$(document).ready(function() {
	$("#creditoID").focus();
	$('#tipo').val(3);
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	llenaComboPlazoCredito();
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('exportarPDF', 'submit');
	deshabilitaBoton('ExptablaAmorti', 'submit');
	deshabilitaBoton('caratula', 'submit');
	deshabilitaBoton('imprimir', 'submit');
	deshabilitaBoton('simular', 'submit');
	validaEmpresaID();
	consultaComboCalInteres();
	$('#pregagos').hide();
	agregaFormatoControles('formaGenerica');
	// ==================================== MANEJO DE EVENTOS =================================== //
	$('#grabar').click(function() { //boton grabar
		$('#tipoTransaccion').val(catTipoTransaccionCredito.actuaCredi);
	});
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});

	$('#fechaMinistrado').blur(function() {
		var estatusCred = $('#estatus').val();
		if (this.value != '' && estatusCred == autorizado || estatusCred == inactivo || estatusCred == procesado) {
			eventoBlurChangeFechaMinistrado();
		}
	});

	$('#fechaMinistrado').change(function() {
		this.focus();
	});
	$('#exportarPDF').click(function() {
		var credito = $('#creditoID').val();
		var mc = $('#montoCredito').asNumber();
		var tb = $('#tasaBase').asNumber();
		var ci = $('#calcInteresID').asNumber();
		var mon = $('#monedaID').asNumber();
		var tt = catTipoTransaccionCredito.actualiza;
		var ta = catTipoActCredito.autorizaPagImp;
		var numeroUsuario = parametroBean.numeroUsuario;
		var nombreInstitucion = parametroBean.nombreInstitucion.toUpperCase();
		var fechaEmision = parametroBean.fechaSucursal;
		var dirInst = parametroBean.direccionInstitucion;
		var RFCInst = parametroBean.rfcInst;
		var telInst = parametroBean.telefonoLocal;
		var sucursal = parametroBean.sucursal;
		var gerente = parametroBean.gerenteGeneral;
		var montoCuot = $('#montoCuota').asNumber();
		var calcInteres = $('#calcInteresID').val();
		var leyenda = encodeURI($('#lblTasaVariable').text().trim());
		var url = 'pagareCreditoAgroInd.htm?calcInteresID=' + ci + '&montoCredito=' + mc + '&tasaBase=' + tb + '&creditoID=' + credito + '&tipoTransaccion=' + tt + '&tipoActualizacion=' + ta + '&monedaID=' + mon + '&usuario=' + numeroUsuario + '&nombreInstitucion=' + nombreInstitucion + '&producCreditoID=' + $('#reca').val() + '&sucursalID=' + sucursal + '&gerenteSucursal=' + gerente + '&direccionInstit=' + dirInst + '&RFCInstit=' + RFCInst + '&telefonoInst=' + telInst + '&fechaSistema=' + fechaEmision + '&montoCuota=' + montoCuot + '&calcInteres=' + calcInteres + '&leyendaTasaVariable=' + leyenda;
		window.open(url, '_blank');
	});
	$('#ExptablaAmorti').click(function() {
		var credito = $('#creditoID').val();
		var mc = $('#montoCredito').asNumber();
		var ci = "10"; // para generar reporte solo tabla AMORTICREDITO
		var mon = $('#monedaID').val();
		var tt = catTipoTransaccionCredito.actualiza;
		var ta = catTipoActCredito.autorizaPagImp;
		var producto = $('#nombreProd').val();
		var fechaDes = $('#fechaMinistrado').val();
		var clienteID = $('#clienteID').val();
		var calcInteres = $('#calcInteresID').val();
		var leyenda = encodeURI($('#lblTasaVariable').text().trim());
		var nombreInstitucion = parametroBean.nombreInstitucion.toUpperCase();
		var url = 'pagareCreditoAgroInd.htm?clienteID=' + clienteID + '&calcInteresID=' + ci + '&montoCredito=' + mc + '&fechaMinistrado=' + fechaDes + '&nombreProducto=' + producto + '&creditoID=' + credito + '&tipoTransaccion=' + tt + '&tipoActualizacion=' + ta + '&monedaID=' + mon + '&nombreInstitucion=' + nombreInstitucion + '&calcInteres=' + calcInteres + '&leyendaTasaVariable=' + leyenda;
		window.open(url, '_blank');
	});
	$('#caratula').click(function() {
		var credito = $('#creditoID').val();
		var producto = $('#producCreditoID').val();
		var monedaID = $('#monedaID').asNumber();
		var montoCredito = $('#montoCredito').val();
		var calcInteres = $('#calcInteresID').val();
		var numeroUsuario = parametroBean.numeroUsuario;
		var sucursal = parametroBean.sucursal;
		var nombreInstitucion = parametroBean.nombreInstitucion;
		var dirInst = parametroBean.direccionInstitucion;
		var telInst = parametroBean.telefonoLocal;
		var RFCInst = parametroBean.rfcInst;
		var fechaSistema = parametroBean.fechaSucursal;
		var solicitudCredito = $('#solicitudCreditoID').val();
		var ci = "8";
		var url = '';

		var numClienteEspecifico = 0;

		// Consulta el número de cliente específico.
		paramGeneralesServicio.consulta(Enum_TipoConsultaParamGenerales.cteEspecifico,{ async: false, callback:function(valor){
			if(valor!=null){
				numClienteEspecifico = valor.valorParametro;
			}
		}});

		if(numClienteEspecifico == catNumClienteEsp.Consol){ // ========= CONTRATO CONSOL =========
			if(subClasifCredito == Enum_SubClasifCredito.HabilitacionAvio){
				if(tipoPersona != Enum_TipoPersona.Moral){
					generarContratoAvioPF(credito, producto,  monedaID, montoCredito,
						nombreInstitucion,RFCInst, dirInst, telInst, calcInteres, fechaSistema);
				}else{
					generarContratoAvioPM(credito, producto,  monedaID, montoCredito,
						nombreInstitucion,RFCInst, dirInst, telInst, calcInteres, fechaSistema);
				}

			}else if (subClasifCredito == Enum_SubClasifCredito.Refaccionario){
				if(tipoPersona != Enum_TipoPersona.Moral){
					generarContratoRefaccionarioPF(credito, producto,  monedaID, montoCredito,
						nombreInstitucion,RFCInst, dirInst, telInst, calcInteres, fechaSistema);
				}else{
					generarContratoRefaccionarioPM(credito, producto,  monedaID, montoCredito,
						nombreInstitucion,RFCInst, dirInst, telInst, calcInteres, fechaSistema);
				}
			}
		}else{
			// Personas Físicas o Físicas con Act.Empresarial.
			if(tipoPersona != Enum_TipoPersona.Moral){
				url = 'RepContratoFira.htm?creditoID=' + credito + '&tipoReporte=' + Enum_TipoReporte.Fisica;
			} else if(tipoPersona == Enum_TipoPersona.Moral){
				var confirmar = confirm('¿El Contrato es de Administrador Único?.');
				if(confirmar){
					url = 'RepContratoFira.htm?creditoID=' + credito + '&tipoReporte=' + Enum_TipoReporte.MoralUnico;
				} else {
					url = 'RepContratoFira.htm?creditoID=' + credito + '&tipoReporte=' + Enum_TipoReporte.Moral;
				}
			} else {
				url = 'pagareCreditoAgroInd.htm?creditoID=' + credito + '&usuario=' + numeroUsuario + '&sucursal=' + sucursal + '&nombreInstitucion=' + nombreInstitucion + '&calcInteresID=' + ci + '&solicitudCreditoID=' + solicitudCredito;
			}

			if(url.trim()!=''){
				window.open(url, '_blank');
			}
		}
	});

	$('#creditoID').bind('keyup', function(e) {
		lista('creditoID', '2', Enum_Credito_Lis.agropecuario, 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');

	});
	$('#creditoID').blur(function() {
		if (esTab) {
			$('#fechaMinistrado').focus();
			$('#gridAmortizacion').html("");
			$('#contenedorSimuladorLibre').html("");
			$('#contenedorSimuladorLibre').hide();

			if (isNaN(this.value) || this.value == '') {
				deshabilitaBoton('grabar', 'submit');
				deshabilitaBoton('exportarPDF', 'submit');
				deshabilitaBoton('ExptablaAmorti', 'submit');
				deshabilitaBoton('caratula', 'submit');
				deshabilitaBoton('simular', 'submit');
				inicializaForma('formaGenerica', 'creditoID');
				$('#creditoID').select();
				$('#creditoID').focus();
			} else {
				validaCredito();
			}
		}
	});

	$('#simular').click(function() {
		simulador();
	});
	$("#fechaInicioAmor").blur(function() {
		if (!$("#fechaInicioAmor").is('[readonly]')) {
			var dias = restaFechas(parametroBean.fechaAplicacion, this.value);
			var diasAux;

			if (esFechaValida(this.value) == true) {

				if (parseInt(dias) < 0) {
					mensajeSis("La Fecha de Inicio No debe ser Menor a la Fecha del Sistema.");

					this.value = parametroBean.fechaAplicacion;
					this.focus();
					diasAux = restaFechas(this.value, $("#fechaMinistrado").val());
					if (parseInt(diasAux) > 0) {
						$("#fechaMinistrado").val(parametroBean.fechaAplicacion);
						$("#fechaInicio").val(parametroBean.fechaAplicacion);
					}

				} else {

					if (parseInt(dias) <= diasMaximo) {
						if (!$("#calendIrregularCheck").is(':checked')) { // Empiece a pagar en NO aplica  para pagos de capital LIBRES

							consultaFechaVencimiento('plazoID');
							diasAux = restaFechas(this.value, $("#fechaMinistrado").val());

							if (parseInt(diasAux) > 0) {
								$("#fechaMinistrado").val(this.value);
								$("#fechaInicio").val(parametroBean.fechaAplicacion);
							}
						} else {

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
						diasAux = restaFechas(this.value, $("#fechaMinistrado").val());

						if (parseInt(diasAux) > 0) {
							$("#fechaMinistrado").val(parametroBean.fechaAplicacion);

							$("#fechaInicio").val(parametroBean.fechaAplicacion);
						}
					}
				}
			} else {
				this.value = parametroBean.fechaAplicacion;
				this.focus();
			}
		}
	});

	$("#fechaInicioAmor").change(function() {
		this.focus();
	});
	$.validator.setDefaults({
		submitHandler : function(event) {
			esTab=true;
			if (validaTablaMinistraciones(true, 'graba', true, true)) {
				var ministraDiferencia = $("#diferenciaMinistra").val().replace(",", "");
				if(parseFloat(ministraDiferencia)>0.00){
					mensajeSis("Aún existe Capital pendiente por Ministrar.");
				} else{
				var procede = validaFechaMinistrado();
				if (procede == 0) {
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'creditoID', 'ExitoPantalla', 'ErrorPantalla');
				} else {
					return false;
				}
				}
			}
		}
	});
	$('#formaGenerica').validate({
		rules : {
			creditoID : {
				required : true
			},
			fechaMinistrado : {
				date : true
			}
		},
		messages : {
			creditoID : {
				required : 'Especificar Crédito',
			},
			fechaMinistrado : {
				date : 'Fecha Incorrecta'
			}
		}
	});
	//agrega el scroll al div de simulador de pagos libres de capital
	$('#contenedorSimuladorLibre').scroll(function() {
	});
	$('#lineaFondeo').bind('keyup', function(e) {
		lista('lineaFondeo', '2', '1', 'descripLinea', $('#lineaFondeo').val(), 'listaLineasFondeador.htm');
	});
	$('#lineaFondeo').change(function() {
		if (isNaN($('#lineaFondeo').val())) {
			$('#lineaFondeo').val("");
			$('#lineaFondeo').focus();
			$('#descripLineaFon').val('');
			$('#saldoLineaFon').val('');
			$('#tasaPasiva').val('');
		} else {
			consultaLineaFondeo(this.id);
		}
	});
	$('#lineaFondeo').blur(function() {
		if (isNaN($('#lineaFondeo').val())) {
			$('#lineaFondeo').val("");
			$('#lineaFondeo').focus();
			$('#descripLineaFon').val('');
			$('#saldoLineaFon').val('');
			$('#tasaPasiva').val('');
		} else {
			consultaLineaFondeo(this.id);
		}
	});
	$('#tipoFondeo').click(function() {
		deshabilitaControl('institFondeoID');
		deshabilitaControl('lineaFondeo');
		$('#institFondeoID').val("0");
		$('#lineaFondeo').val("0");
		$('#descripFondeo').val("");
		$('#descripLineaFon').val("");
		$('#saldoLineaFon').val("");
		$('#tasaPasiva').val("");
		$('#folioFondeo').val("");
	});
	$('#tipoFondeo2').click(function() {
		habilitaControl('lineaFondeo');
		consultaInstitucionFondeo('institFondeoID');
	});
});

function validaCredito() {
	var numCredito = $('#creditoID').val();
	var fechaAplicacion = parametroBean.fechaAplicacion;
	setTimeout("$('#cajaLista').hide();", 200);
	destinoCredito = 0;
	if (numCredito != '' && !isNaN(numCredito)) {
		var creditoBeanCon = {
			'creditoID' : $('#creditoID').val()
		};
		creditosServicio.consulta(catTipoConsultaCredito.agropecuario, creditoBeanCon,{async:false,callback:function(credito) {

			if (credito != null) {

				dwr.util.setValues(credito);
				if(credito.esAgropecuario == 'N'){
					mensajeSis("El Crédito No es de Tipo Agropecuario.<br>Consultar en el Módulo <i><u>Cartera</u></i>.");
					$('#creditoID').focus();
					deshabilitaBoton('grabar', 'submit');
					deshabilitaBoton('exportarPDF', 'submit');
					deshabilitaBoton('ExptablaAmorti', 'submit');
					deshabilitaBoton('caratula', 'submit');
					deshabilitaBoton('simular', 'submit');
					inicializaForma('formaGenerica', 'creditoID');
				}
				destinoCredito = credito.destinoCreID;
				consultaDestinoCredito(credito.destinoCreID);
				$('#cat').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 1
				});

				$('#tipoPrepago').val(credito.tipoPrepago);
				if (credito.estatus != catEstatusCredito.autorizado && credito.estatus != catEstatusCredito.inactivo && credito.estatus != catEstatusCredito.procesado) {
					deshabilitaControl('tipoPrepago');
				} else {
					habilitaControl('tipoPrepago');
				}

				$('#plazoID').val(credito.plazoID).selected = true;
				$('#montoCredito').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});

				fechaMinisAct = $('#fechaMinistrado').val();
				if (credito.fechaMinistrado == '1900-01-01') {
					$('#fechaMinistrado').val(fechaAplicacion);
					$('#fechaMinistradoOriginal').val(fechaAplicacion);
				} else {
					$('#fechaMinistrado').val(credito.fechaMinistrado);
					$('#fechaMinistradoOriginal').val(credito.fechaMinistrado);
				}
				estatus = credito.estatus;
				$('#esConsolidacionAgro').val(credito.esConsolidacionAgro);

				if (estatus != catEstatusCredito.autorizado && estatus != catEstatusCredito.inactivo && estatus != catEstatusCredito.procesado) {
					deshabilitaControl('fechaMinistrado');
					deshabilitaBoton('grabar', 'submit');
					consultaMinistraciones('A');
				} else {
					habilitaControl('fechaMinistrado');
					habilitaBoton('grabar', 'submit');
					consultaMinistraciones('I');
				}

				consultaCliente('clienteID');
				consultaHuellaCliente();
				consultaMoneda('monedaID');
				if (credito.tasaBase != 0) {
					consultaTasaBase('tasaBase');
				}

				consultaProducCredito('producCreditoID', credito.grupoID);
				if (credito.fechaInhabil == 'S') {
					$('#fechaInhabil1').attr("checked", "1");
					$('#fechaInhabil2').attr("checked", false);
					$('#fechaInhabil').val("S");
				} else {
					$('#fechaInhabil2').attr("checked", "1");
					$('#fechaInhabil1').attr("checked", false);
					$('#fechaInhabil').val("A");
				}

				if (credito.ajusFecExiVen == 'S') {
					$('#ajusFecExiVen1').attr("checked", "1");
					$('#ajusFecExiVen2').attr("checked", false);
					$('#ajusFecExiVen').val("S");
				} else {
					$('#ajusFecExiVen2').attr("checked", "1");
					$('#ajusFecExiVen1').attr("checked", false);
					$('#ajusFecExiVen').val("N");
				}

				if (credito.calendIrregular == 'S') {
					$('#calendIrregularCheck').attr("checked", "1");
					$('#calendIrregular').val("S");
				} else {
					$('#calendIrregularCheck').attr("checked", false);
					$('#calendIrregular').val("N");
				}

				if (credito.ajusFecUlVenAmo == 'S') {
					$('#ajusFecUlVenAmo1').attr("checked", "1");
					$('#ajusFecUlVenAmo2').attr("checked", false);
					$('#ajusFecUlVenAmo').val("S");
				} else {
					$('#ajusFecUlVenAmo2').attr("checked", "1");
					$('#ajusFecUlVenAmo1').attr("checked", false);
					$('#ajusFecUlVenAmo').val("N");
				}

				if (credito.diaPagoInteres == 'F') {
					$('#diaPagoInteres1').attr("checked", "1");
					$('#diaPagoInteres2').attr("checked", false);
				} else {
					$('#diaPagoInteres2').attr("checked", "1");
					$('#diaPagoInteres1').attr("checked", false);
					$('#diaMesInteres').val(credito.diaMesInteres);
				}
				$('#diaPagoInteres').val(credito.diaPagoInteres);

				if (credito.diaPagoCapital == 'F') {
					$('#diaPagoCapital1').attr("checked", "1");
					$('#diaPagoCapital2').attr("checked", false);
				} else {
					$('#diaPagoCapital2').attr("checked", "1");
					$('#diaPagoCapital1').attr("checked", false);
					$('#diaMesCapital').val(credito.diaMesCapital);
				}

				if (credito.tipoCredito == 'N') {
					$('#tipoCreditoDes').val("NUEVO");

				}
				if (credito.tipoCredito == 'O') {
					$('#tipoCreditoDes').val("RENOVACIÓN");

				}
				if (credito.tipoCredito == 'R') {
					$('#tipoCreditoDes').val("REESTRUCTURA");

				}
				$('#diaPagoCapital').val(credito.diaPagoCapital);
				asignaTipoFondeo(credito.tipoFondeo);
				if (credito.tipoFondeo != 'P') {
					esTab = true;
					consultaLineaFondeo('lineaFondeo');
				}

				$('#tasaPasiva').val(credito.tasaPasiva);
				agregaFormatoControles('formaGenerica');

				if( credito.esConsolidacionAgro == "S" ) {


					$('#fechaInicioAmor').val(credito.fechaInicio);
					$('#fechaMinistrado').val(credito.fechaInicio);
					$('#fechaInicio').val(credito.fechaInicio);
					$('#fechaPagoMinis1').val(credito.fechaInicio);
					$("#fechaInicioAmor").attr('readonly', true);
					$("#fechaInicioAmor").datepicker("destroy");
					$("#fechaMinistrado").attr('readonly', true);
					$("#fechaMinistrado").datepicker("destroy");
					$("#fechaPagoMinis1").attr('readonly', true);
					$("#fechaPagoMinis1").datepicker("destroy");
					deshabilitaControl('fechaInicioAmor');
					deshabilitaControl('fechaMinistrado');
					deshabilitaControl('fechaInicio');
					deshabilitaControl('fechaPagoMinis1');
				}

			} else {
				mensajeSis("No Existe el Crédito.");
				$('#creditoID').focus();
				$('#creditoID').val("");
				deshabilitaBoton('grabar', 'submit');
				deshabilitaBoton('exportarPDF', 'submit');
				deshabilitaBoton('ExptablaAmorti', 'submit');
				deshabilitaBoton('caratula', 'submit');
				deshabilitaBoton('simular', 'submit');
				inicializaForma('formaGenerica', 'creditoID');
			}
		  }
		});
	}
}
function consultaCliente(idControl) {
	var jqCliente = eval("'#" + idControl + "'");
	var numCliente = $(jqCliente).val();
	setTimeout("$('#cajaLista').hide();", 200);
	tipoPersona = '';
	if (numCliente != '' && !isNaN(numCliente)) {
		clienteServicio.consulta(1, numCliente, function(cliente) {
			if (cliente != null) {
				tipoPersona = cliente.tipoPersona;
				$('#clienteID').val(cliente.numero);
				$('#nombreCliente').val(cliente.nombreCompleto);
				if (cliente.estatus == "I") {
					deshabilitaBoton('grabar', 'submit');
					mensajeSis("El Cliente se Encuentra Inactivo.");
					$('#creditoID').focus();
				}
			} else {
				mensajeSis("No Existe el Cliente.");
				$('#clienteID').focus();
				$('#clienteID').select();
			}
		});
	}
}

function consultaPagareImp(idControl) {
	var creditoBeanCon = {
		'creditoID' : $('#creditoID').val()
	};
	creditosServicio.consulta(catTipoConsultaCredito.pagareImp, creditoBeanCon, function(credito) {
		if (credito.pagareImpreso == 'S') {
			deshabilitaBoton('imprimir', 'submit');
			deshabilitaBoton('exportarPDF', 'submit');
			deshabilitaBoton('ExptablaAmorti', 'submit');
			deshabilitaBoton('caratula', 'submit');
			deshabilitaBoton('simular', 'submit');
		}
	});

	$('#tipoPrepago').val(credito.tipoPrepago);
	if (credito.estatus != catEstatusCredito.autorizado && credito.estatus != catEstatusCredito.inactivo && credito.estatus != catEstatusCredito.procesado) {
		deshabilitaControl('tipoPrepago');
	} else {
		habilitaControl('tipoPrepago');
	}
}

function consultaSaldoLinea(idControl) {
	var jqNum = eval("'#" + idControl + "'");
	var numLin = $(jqNum).val();
	setTimeout("$('#cajaLista').hide();", 200);

	if (numLin != '' && !isNaN(numLin)) {
		var lineaFondBeanCon = {
			'lineaFondeo' : $('#lineaFondeo').val()
		};
		lineaFonServicio.consulta(catTipoConsultaCredito.principal, lineaFondBeanCon, function(lineaFond) {
			if (lineaFond != null) {
				$('#nombrelineaFond').val(lineaFond.descripLinea);
				$('#saldoLinea').val(lineaFond.saldoLinea);

			} else {
				mensajeSis("No Existe la Línea Fondeador");
				deshabilitaBoton('modifica', 'submit');
				deshabilitaBoton('agrega', 'submit');
				$('#lineaFondeo').focus();
				$('#lineaFondeo').select();
			}
		});
	}
}

function consultaInstituFondeo(idControl) {
	var jqInst = eval("'#" + idControl + "'");
	var numInst = $(jqInst).val();
	setTimeout("$('#cajaLista').hide();", 200);
	if (numInst != '' && !isNaN(numInst)) {
		var instFondeoBeanCon = {
			'institFondeoID' : numInst
		};
		fondeoServicio.consulta(catTipoConsultaCredito.principal, instFondeoBeanCon, function(instFondeo) {
			if (instFondeo != null) {
				$('#nombreInst').val(instFondeo.nombreInstitFon);
			} else {
				mensajeSis("No Existe la Institución de Fondeo.");
			}
		});
	}
}

function consultaMoneda(idControl) {
	var jqMoneda = eval("'#" + idControl + "'");
	var numMoneda = $(jqMoneda).val();
	var conMoneda = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numMoneda != '' && !isNaN(numMoneda)) {
		monedasServicio.consultaMoneda(conMoneda, numMoneda, function(moneda) {
			if (moneda != null) {
				$('#monedaDes').val(moneda.descripcion);
			} else {
				mensajeSis("No Existe el Tipo de Moneda");
				$('#monedaDes').val('');
				$(jqMoneda).focus();
			}
		});
	}
}

function consultaLineaCredito(idControl) {
	var jqLinea = eval("'#" + idControl + "'");
	var lineaCred = $(jqLinea).val();
	var lineaCreditoBeanCon = {
		'lineaCreditoID' : lineaCred
	};

	setTimeout("$('#cajaLista').hide();", 200);
	if (lineaCred != '' && !isNaN(lineaCred)) {
		lineasCreditoServicio.consulta(catTipoConsultaCredito.principal, lineaCreditoBeanCon, function(linea) {

			if (linea != null) {
				$('#saldoDisponible').val(linea.saldoDisponible);
				$('#saldoDeudor').val(linea.saldoDeudor);
			}
		});
	}
}

//Consulta Tasa Base
function consultaTasaBase(idControl) {
	var jqTasa = eval("'#" + idControl + "'");
	var tasaBase = $(jqTasa).val();
	var TasaBaseBeanCon = {
		'tasaBaseID' : tasaBase
	};
	setTimeout("$('#cajaLista').hide();", 200);

	if (tasaBase != '' && !isNaN(tasaBase)) {
		tasasBaseServicio.consulta(1, TasaBaseBeanCon, function(tasasBaseBean) {
			if (tasasBaseBean != null) {
				$('#desTasaBase').val(tasasBaseBean.nombre);
			} else {
				mensajeSis("No Existe la Tasa Base.");
				$('#tasaBaseID').focus();
				$('#tasaBaseID').selected();
			}
		});
	}
}

function consultaProducCredito(idControl, grupoID) {
	var jqProdCred = eval("'#" + idControl + "'");
	var ProdCred = $(jqProdCred).val();
	var ProdCredBeanCon = {
		'producCreditoID' : ProdCred
	};
	setTimeout("$('#cajaLista').hide();", 200);

	if (ProdCred != '' && !isNaN(ProdCred)) {
		productosCreditoServicio.consulta(catTipoConsultaCredito.principal, ProdCredBeanCon,{
			async:false,callback: function(prodCred) {
			if (prodCred != null) {
				cobraAccesorios = prodCred.cobraAccesorios;
				if (prodCred.permitePrepago == 'S') {
					$('#pregagos').show();
				} else {
					$('#pregagos').hide();
				}
				if (prodCred.modificarPrepago == 'S') {
					habilitaControl('tipoPrepago');
				} else {
					deshabilitaControl('tipoPrepago');
				}
				if (estatus != catEstatusCredito.autorizado && estatus != catEstatusCredito.inactivo && estatus != catEstatusCredito.procesado) {
					deshabilitaControl('tipoPrepago');
				}
				$('#nombreProd').val(prodCred.descripcion);
				$('#reca').val(prodCred.registroRECA);

				if (prodCred.esGrupal == 'S' && grupoID > 0) {
					mensajeSis("Producto de Crédito Reservado para Créditos Grupales.");
					deshabilitaBoton('grabar', 'submit');
					deshabilitaBoton('exportarPDF', 'submit');
					deshabilitaBoton('ExptablaAmorti', 'submit');
					deshabilitaBoton('caratula', 'submit');
					$('#gridAmortizacion').html("");
					$('#contenedorSimuladorLibre').html("");
					inicializaForma('formaGenerica', 'creditoID');
					$('#creditoID').focus();

				} else {
					consultaGridAmortizacionesGrabadas();
				}

				// valida si el producto de credito puede tener un desembolso anticipado
				if (prodCred.inicioAfuturo == 'S' && ($("#estatus").val() == catEstatusCredito.inactivo || $("#estatus").val() == catEstatusCredito.autorizado || $("#estatus").val() == catEstatusCredito.procesado)) {
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

				if( prodCred.reqConsolidacionAgro == 'S' && prodCred.fechaDesembolso == 'S' ) {
					$("#fechaMinistrado").attr('readonly', true);
					$("#fechaMinistrado").datepicker("destroy");
				}
			} else {
				mensajeSis("No Existe el Producto de Crédito.");
			}
		}});
	}
}

function consultaDirCliente() {
	var direccionesCliente = {
		'clienteID' : $('#clienteID').val(),
		'direccionID' : '0'

	};
	var numCliente = $('#clienteID').val();
	setTimeout("$('#cajaLista').hide();", 200);

	if (numCliente != '' && !isNaN(numCliente)) {
		direccionesClienteServicio.consulta(3, direccionesCliente, function(direccion) {
			if (direccion != null) {
				dwr.util.setValues(direccion);
				habilitaBoton('imprimir', 'submit');
				habilitaBoton('exportarPDF', 'submit');
				habilitaBoton('ExptablaAmorti', 'submit');
				habilitaBoton('caratula', 'submit');
			} else {
				mensajeSis("El cliente no cuenta con una Dirección");
				deshabilitaBoton('imprimir', 'submit');
				deshabilitaBoton('exportarPDF', 'submit');
				deshabilitaBoton('ExptablaAmorti', 'submit');
				deshabilitaBoton('caratula', 'submit');
			}
		});
	}
}

function actNumTransacSim() {
	var creditoBeanCon = {
		'creditoID' : $('#creditoID').val(),
		'numTransacSim' : $('#numTransacSim').val()
	};

	creditosServicio.consulta(6, creditoBeanCon, function(credito) {
		$('#numTransacSim').val(credito.numTransacSim);
	});
}

//funcion para llenar el combo de plazos
function llenaComboPlazoCredito() {
	dwr.util.removeAllOptions('plazoID');
	dwr.util.addOptions('plazoID', {
		"" : 'SELECCIONAR'
	});
	plazosCredServicio.listaCombo(3, function(plazoCreditoBean) {
		dwr.util.addOptions('plazoID', plazoCreditoBean, 'plazoID', 'descripcion');
	});
}

/* se ocupa al momento en que fecha ministrado cambia o pierde el foco */
function eventoBlurChangeFechaMinistrado() {
	var fechMinis = $('#fechaMinistrado').val();
	var fechaAplicacion = parametroBean.fechaAplicacion;
	var diasAux;

	if (esFechaValida(fechMinis)) {
		convertDate(fechMinis);
		convertDate(fechaAplicacion);
		if (fechMinis < fechaAplicacion && fechMinis != '' && ($("#estatus").val() == catEstatusCredito.inactivo || $("#estatus").val() == catEstatusCredito.autorizado || $("#estatus").val() == catEstatusCredito.procesado)) {
			mensajeSis("La Fecha de Desembolso no debe ser Inferior a la del Sistema.");
			$('#fechaMinistrado').focus();
			$('#fechaMinistrado').select();
			$('#fechaMinistrado').val(fechaAplicacion);
			$('#fechaPagoMinis1').val(fechaAplicacion);
		} else {
			if (fechMinis == '') {
				mensajeSis("La Fecha de Desembolso está Vacia.");
				$('#fechaMinistrado').focus();
				$('#fechaMinistrado').select();

			} else {
				$('#fechaInicio').val(fechMinis);
				$('#fechaPagoMinis1').val(fechMinis);

				diasAux = restaFechas($("#fechaInicioAmor").val(), fechMinis);
				if (parseInt(diasAux) > 0) {
					$("#fechaInicioAmor").val(fechMinis);
					$("#fechaInicioAmor").focus();
				}

				consultaFechaVencimientoCuotas('numAmortizacion');
			}
		}
	} else {
		$('#fechaMinistrado').val(parametroBean.fechaAplicacion);
		$('#fechaPagoMinis1').val(parametroBean.fechaAplicacion);
	}
}

//función para consultar si el cliente ya tiene huella digital registrada
function consultaHuellaCliente() {
	var numCliente = $('#clienteID').val();
	if (numCliente != '' && !isNaN(numCliente)) {
		var clienteIDBean = {
			'personaID' : $('#clienteID').val()
		};
		huellaDigitalServicio.consulta(1, clienteIDBean, function(cliente) {
			if (cliente == null) {
				var huella = parametroBean.funcionHuella;
				if (huella == "S" && huellaProductos == "S") {
					mensajeSis("El Cliente no tiene Huella Registrada.\nFavor de Verificar.");
					$('#creditoID').focus();
					deshabilitaBoton('grabar', 'submit');
				}
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
	parametrosSisServicio.consulta(tipoCon, ParametrosSisBean, function(parametrosSisBean) {
		if (parametrosSisBean != null) {
			if (parametrosSisBean.reqhuellaProductos != null) {
				huellaProductos = parametrosSisBean.reqhuellaProductos;
			} else {
				huellaProductos = "N";
			}
		}
	});
}

//});

/* Cancela las teclas [ ] en el formulario*/
document.onkeypress = pulsarCorchete;
function pulsarCorchete(e) {
	tecla = (document.all) ? e.keyCode : e.which;
	if (tecla == 91 || tecla == 93) {
		return false;
	}
	return true;
}

function consultaFechaVencimientoCuotas(idControl) {
	var jqPlazo = eval("'#" + idControl + "'");
	var plazo = $(jqPlazo).val();
	var tipoCon = 3;

	var PlazoBeanCon = {
		'plazoID' : $('#plazoID').val(),
		'fechaActual' : $('#fechaInicioAmor').val(),
		'frecuenciaCap' : $('#frecuenciaCap').val()
	};
	if (plazo == '0') {
		$('#fechaVencimien').val("");
	} else {
		plazosCredServicio.consulta(tipoCon, PlazoBeanCon, function(plazos) {
			if (plazos != null) {
				$('#fechaVencimien').val(plazos.fechaActual);
			}
		});
	}
}

//funcion a ejecutar cuando la operacion fue exitosa
function ExitoPantalla() {
	consultaGridAmortizacionesGrabadas();

	deshabilitaBoton('generar', 'submit');
	deshabilitaBoton('grabar', 'submit');
	$('#contenedorSimuladorLibre').hide();
	$('#contenedorSimuladorLibre').html("");
	consultaCredito();
}

function consultaGridAmortizacionesGrabadas() {
	$('#tipo').val(3);
	var params = {};
	params['creditoID'] = $('#creditoID').val();
	params['tipoLista'] = 3;
	params['cobraSeguroCuota'] = $('#cobraSeguroCuota option:selected').val();
	params['cobraIVASeguroCuota'] = $('#cobraIVASeguroCuota option:selected').val();
	params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
	params['cobraAccesorios'] = cobraAccesorios;
	var numeroError = 0;
	var mensajeTransaccion = "";
	$.post("consultaCredAmortiAgroGridVista.htm", params, function(data) {
		if (data.length > 0) {
			$('#gridAmortizacion').html(data);
			if ($("#numeroErrorList").length) {
				numeroError = $('#numeroErrorList').asNumber();
				mensajeTransaccion = $('#mensajeErrorList').val();
			}
			if (numeroError == 0) {
				$('#gridAmortizacion').show();
				$('#contenedorSimuladorLibre').hide();
				$('#contenedorSimuladorLibre').html("");
				var jqAmortiza = eval("'#amortizacionID1'");
				var amortizacion1 = $(jqAmortiza).val();
				// valida si el grid trae amortizaciones anteriores para habilitar boton imprimir
				if (amortizacion1 == 1) {
					habilitaBoton('exportarPDF', 'submit');
					habilitaBoton('ExptablaAmorti', 'submit');
					habilitaBoton('caratula', 'submit');

					habilitaControl('ligaPDF');
					agregaFormatoControles('formaGenerica');
				} else {
					deshabilitaBoton('exportarPDF', 'submit');
					deshabilitaBoton('ExptablaAmorti', 'submit');
					deshabilitaBoton('caratula', 'submit');
					deshabilitaControl('ligaPDF');
				}

				if ($('#tipoCreditoDes').val() == 'REESTRUCTURA') {
					habilitaBoton('exportarPDF', 'submit');
					habilitaBoton('ExptablaAmorti', 'submit');
					habilitaBoton('caratula', 'submit');
					habilitaBoton('ligaPDF');

				} else {

					habilitaControl('ligaPDF');
					agregaFormatoControles('formaGenerica');
				}
				if ($('#siguiente').is(':visible') && $('#anterior').is(':visible') == false) {
					$('#filaTotales').hide();
				}

				if ($('#siguiente').is(':visible') == false && $('#anterior').is(':visible') == false) {
					$('#filaTotales').show();
				}
				muestraDescTasaVar('calcInteresID');
			}
		} else {
			$('#gridAmortizacion').hide();
			$('#gridAmortizacion').html("");
			$('#contenedorSimuladorLibre').hide();
			$('#contenedorSimuladorLibre').html("");
			deshabilitaBoton('exportarPDF', 'submit');
			deshabilitaBoton('ExptablaAmorti', 'submit');
			deshabilitaBoton('caratula', 'submit');
			deshabilitaControl('ligaPDF');
		}
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
}

function ErrorPantalla() {
	agregaFormatoControles('formaGenerica');
}

//valida que los datos que se requieren para generar el  simulador de  amortizaciones
function validaDatosSimulador() {
	if ($.trim($('#producCreditoID').val()) == "") {
		mensajeSis("Producto De Crédito Vací­o");
		$('#producCreditoID').focus();
		datosCompletos = false;
	} else {
		if ($.trim($('#clienteID').val()) == "") {
			mensajeSis("El Cliente Está Vacío");
			$('#clienteID').focus();
			datosCompletos = false;
		} else {
			if ($('#fechaInicioAmor').val() == '') {
				mensajeSis("Fecha de Inicio de Amortización está Vacía");
				$('#fechaInicio').focus();
				datosCompletos = false;
			} else {
				if ($('#fechaVencimien').val() == '') {
					mensajeSis("Fecha de Vencimiento Vacía");
					$('#fechaVencimien').focus();
					datosCompletos = false;
				} else {
					if ($('#tipoPagoCapital').val() == '') {
						mensajeSis("El Tipo de Pago de Capital Está Vací­o.");
						$('#tipoPagoCapital').focus();
						datosCompletos = false;
					} else {
						{
							if ($('#tipoPagoCapital').val() == 'L') {
								/* se valida que si el tipo de pago de capital es libre, no se pueda escoger como frecuencia
								 * la opcion de libre */
								if ($('#frecuenciaInt').val() == 'L') {
									mensajeSis("La Frecuencia de Interés Libre sólo Aplica para Calendario Irregular.");
									$('#frecuenciaInt').focus();
									$('#frecuenciaInt').val("");
									datosCompletos = false;
								} else {
									if ($('#frecuenciaCap').val() == 'L') {
										mensajeSis("La Frecuencia de Capital Libre sólo Aplica para Calendario Irregular.");
										$('#frecuenciaCap').focus();
										$('#frecuenciaCap').val("");
										datosCompletos = false;
									} else {
										if ($('#calcInteresID').val() != "") {
											if ($('#calcInteresID').val() == '1') {
												if ($('#tasaFija').val() == '' || $('#tasaFija').val() == '0') {
													mensajeSis("Tasa de Interés Vací­a");
													$('#tasaFija').focus();
													datosCompletos = false;
												} else {
													if ($('#montoCredito').asNumber() <= "0") {
														mensajeSis("El Monto Está Vacío");
														$('#montoCredito').focus();
														datosCompletos = false;
													} else {
														datosCompletos = true;
													}
												}
											}
										} else {
											mensajeSis("Seleccionar Tipo Cal. Interés");
											$('#calcInteresID').focus();
											datosCompletos = false;
										}
									}
								}
							} else {
								if ($('#calcInteresID').val() != "") {
									if ($('#calcInteresID').val() == '1') {
										if ($('#tasaFija').val() == '' || $('#tasaFija').val() == '0') {
											mensajeSis("Tasa de Interés Vací­a");
											$('#tasaFija').focus();
											datosCompletos = false;
										} else {
											if ($('#montoCredito').asNumber() <= "0") {
												mensajeSis("El Monto Está Vacío");
												$('#montoCredito').focus();
												datosCompletos = false;
											} else {
												datosCompletos = true;
											}
										}
									}
								} else {
									mensajeSis("Seleccionar Tipo Cal. Interés");
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
	return datosCompletos;
}

//llamada al sp que consulta el simulador de amortizaciones
function consultaSimulador() {
	var params = {};

	tipoLista = 7;
	params['tipoLista'] = tipoLista;

	params['numTransacSim'] = $('#numTransacSim').asNumber();
	params['cobraSeguroCuota'] = $('#cobraSeguroCuota option:selected').val();
	params['cobraIVASeguroCuota'] = $('#cobraIVASeguroCuota option:selected').val();
	params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
	bloquearPantallaAmortizacion();
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
				$('#gridAmortizacion').html("");
				$('#gridAmortizacion').hide();
			}
		} else {
			$('#contenedorSimuladorLibre').html("");
			$('#contenedorSimuladorLibre').hide();
			$('#gridAmortizacion').html("");
			$('#gridAmortizacion').hide();
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

/* funcion para sugerir fecha y monto de acuerdo  a lo que ya se habia indicado en el formulario.*/
function sugiereFechaSimuladorLibre() {
	var numDetalle = $('input[name=fechaVencim]').length;
	var varFechaVenID = eval("'#fechaVencim" + numDetalle + "'");
	$(varFechaVenID).val($('#fechaVencimien').val());
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
		$(varCapitalID).val($('#montoCredito').val());
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
			mensajeSis("La Fecha debe ser Menor o Igual a la Fecha de Vencimiento");
			document.getElementById("fechaVencim" + fila).focus();
			$(jqFechaVen).addClass("error");
			return false;
		} else {
			if (xYear == yYear) {
				if (yMonth > xMonth) {
					mensajeSis("La Fecha debe ser Menor o Igual a la Fecha de Vencimiento");
					document.getElementById("fechaVencim" + fila).focus();
					$(jqFechaVen).addClass("error");
					return false;
				} else {
					if (xMonth == yMonth) {
						if (yDay > xDay) {
							mensajeSis("La Fecha debe ser Menor o Igual a la Fecha de Vencimiento");
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

/* funcion para calcular la diferencia del monto con lo que se va poniendo en el grid de pagos libres.*/
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

		if (sumaMontoCapturado > $('#montoCredito').asNumber()) {
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
			diferenciaMonto = $('#montoCredito').asNumber() - sumaMontoCapturado.toFixed(2);
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

//funcion para validar la fecha
function esFechaValida(fecha) {

	if (fecha != undefined && fecha.value != "") {
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)) {
			mensajeSis("Formato de Fecha No Válido (aaaa-mm-dd)");
			return false;
		}

		var mes = fecha.substring(5, 7) * 1;
		var dia = fecha.substring(8, 10) * 1;
		var anio = fecha.substring(0, 4) * 1;

		switch (mes) {
			case 1:
			case 3:
			case 5:
			case 7:
			case 8:
			case 10:
			case 12:
				numDias = 31;
				break;
			case 4:
			case 6:
			case 9:
			case 11:
				numDias = 30;
				break;
			case 2:
				if (comprobarSiBisisesto(anio)) {
					numDias = 29;
				} else {
					numDias = 28;
				}
				;
				break;
			default:
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

/* Cancela las teclas [ ] en el formulario*/
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
	$('input[name=capital]').each(function() {
		jqCapital = eval("'#" + this.id + "'");
		capital = $(jqCapital).asNumber();
		if (capital != '' && !isNaN(capital)) {
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
	if (suma != $('#montoCredito').asNumber()) {
		mensajeSis("La suma de Montos de Capital debe ser Igual al Monto Solicitado.");
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



/* FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y LAS FILAS CONTINUEN DE MANERA COHERENTE.*/
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

/* FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y LAS FILAS CONTINUEN DE MANERA COHERENTE.*/
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

/* FUNCION PARA VALIDAR QUE LA FECHA DE VENCIMIENTO MODIFICADA NO SEA MAYO A LA FECHA DE VENCIMIENTO SIGUIENTE*/

//funcion para validar si cambia la fecha de desembolso o no .
function validaFechaMinistrado() {
	var procede = 1;
	var fechMinis = $('#fechaMinistrado').val();
	var fechaAplicacion = parametroBean.fechaAplicacion;
	convertDate(fechMinis);
	convertDate(fechaAplicacion);
	if (fechMinis < fechaAplicacion && fechMinis != '') {
		mensajeSis("La Fecha de Desembolso no debe ser Inferior a la del Sistema.");
		$('#fechaMinistrado').focus();
		$('#fechaMinistrado').select();
		$('#fechaMinistrado').val(fechaAplicacion);
		procede = 1;
	} else {
		if (fechMinis == '') {
			mensajeSis("La Fecha de Desembolso está Vacia.");
			$('#fechaMinistrado').focus();
			$('#fechaMinistrado').select();
			procede = 1;
		} else {
			if ($('#frecuenciaCap').val() == 'M') {
				if ($('#diaPagoInteres').val() == 'A') {
					$('#diaMesInteres').val($('#fechaMinistrado').val().substring(8, 10));
				}
				if ($('#diaPagoCapital').val() == 'A') {
					$('#diaMesCapital').val($('#fechaMinistrado').val().substring(8, 10));
				}
			}
			if ($('#fechaMinistrado').val() != $('#fechaMinistradoOriginal').val() && $('#tipoPagoCapital').val() == "L") {
				procede = 1;
				$('#simular').show();
				deshabilitaBoton('grabar', 'submit');
				habilitaBoton('simular', 'submit');
				mensajeSis("Se requiere una nueva Simulación");

				//Se Eliminaran todas las amortizaciones
				$('#contenedorSimuladorLibre').html("");
				$('#gridAmortizacion').html("");
				$('#contenedorSimuladorLibre').hide();
				$('#gridAmortizacion').show();
				simulacionRealizada = false;
				$('#simular').show();
				deshabilitaBoton('grabar', 'submit');
				habilitaBoton('simular', 'submit');
			} else {
				if ($('#tipoPagoCapital').val() == "L" && $('#numTransacSim').asNumber() == 0) {
					procede = 1;
					$('#simular').show();
					deshabilitaBoton('grabar', 'submit');
					habilitaBoton('simular', 'submit');
					mensajeSis("Se requiere una nueva Simulación");

					//Se Eliminaran todas las amortizaciones
					$('#contenedorSimuladorLibre').html("");
					$('#gridAmortizacion').html("");
					$('#contenedorSimuladorLibre').hide();
					$('#gridAmortizacion').show();
					simulacionRealizada = false;
					$('#simular').show();
					deshabilitaBoton('grabar', 'submit');
					habilitaBoton('simular', 'submit');


				} else {
					deshabilitaBoton('simular', 'submit');
					procede = 0;

					if ($('#simuladoNuevamente').val() == "S") {
						$('#tipoActualizacion').val(catTipoActCredito.actualizaCredAmor);
					} else {
						$('#tipoActualizacion').val(catTipoActCredito.actualizaCred);
					}
				}
			}
		}
	}
	return procede;
}

//Función para calcular los días transcurridos entre dos fechas
function restaFechas(fAhora, fEvento) {

	var ahora = new Date(fAhora);
	var evento = new Date(fEvento);
	var tiempo = evento.getTime() - ahora.getTime();
	var dias = Math.floor(tiempo / (1000 * 60 * 60 * 24));

	return dias;
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
		$('#fechaVencimien').val("");

	} else {
		plazosCredServicio.consulta(tipoCon, PlazoBeanCon, function(plazos) {
			if (plazos != null) {
				$('#fechaVencimien').val(plazos.fechaActual);
				if ($('#frecuenciaCap').val() != "U") {
					$('#numAmortizacion').val(plazos.numCuotas);
					if ($('#tipoPagoCapital').val() == 'C') {
						$('#numAmortInteres').val(plazos.numCuotas);

					} else {
						$('#numAmortizacion').val(plazos.numCuotas);
						if ($('#perIgual').val() == "S") {
							$('#numAmortInteres').val(plazos.numCuotas);

						}
					}

				} else {
					$('#numAmortizacion').val("1");
				}
			}
		});
	}

}// fin consultaFechaVencimiento

function consultaCredito() {
	deshabilitaBoton('grabar', 'submit');
	var creditoBeanCon = {
		'creditoID' : $('#creditoID').val()
	};
	destinoCredito = 0;
	creditosServicio.consulta(catTipoConsultaCredito.agropecuario, creditoBeanCon, function(credito) {
		if (credito != null) {
			dwr.util.setValues(credito);
			destinoCredito = credito.destinoCreID;

			$('#tipoPrepago').val(credito.tipoPrepago);
			if (credito.estatus != catEstatusCredito.autorizado && credito.estatus != catEstatusCredito.inactivo && credito.estatus != catEstatusCredito.procesado) {
				deshabilitaControl('tipoPrepago');
			} else {
				habilitaControl('tipoPrepago');
			}

			$('#plazoID').val(credito.plazoID).selected = true;
			$('#montoCredito').formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 2
			});
			var fechaAplicacion = parametroBean.fechaAplicacion;
			fechaMinisAct = $('#fechaMinistrado').val();
			if (credito.fechaMinistrado == '1900-01-01') {
				$('#fechaMinistrado').val(fechaAplicacion);
				$('#fechaMinistradoOriginal').val(fechaAplicacion);
			} else {
				$('#fechaMinistrado').val(credito.fechaMinistrado);
				$('#fechaMinistradoOriginal').val(credito.fechaMinistrado);
			}
			estatus = credito.estatus;
			if (estatus != catEstatusCredito.autorizado && estatus != catEstatusCredito.inactivo && estatus != catEstatusCredito.procesado) {
				deshabilitaBoton('grabar', 'submit');
				deshabilitaControl('fechaMinistrado');

			} else {
				habilitaControl('fechaMinistrado');
			}
			consultaCliente('clienteID');
			consultaHuellaCliente();
			//consultaLineaCredito('lineaCreditoID');
			consultaMoneda('monedaID');
			if (credito.tasaBase != 0) {
				consultaTasaBase('tasaBase');
			}
			consultaProducCredito('producCreditoID', credito.grupoID);
			if (credito.fechaInhabil == 'S') {
				$('#fechaInhabil1').attr("checked", "1");
				$('#fechaInhabil2').attr("checked", false);
				$('#fechaInhabil').val("S");
			} else {
				$('#fechaInhabil2').attr("checked", "1");
				$('#fechaInhabil1').attr("checked", false);
				$('#fechaInhabil').val("A");
			}

			if (credito.ajusFecExiVen == 'S') {
				$('#ajusFecExiVen1').attr("checked", "1");
				$('#ajusFecExiVen2').attr("checked", false);
				$('#ajusFecExiVen').val("S");
			} else {
				$('#ajusFecExiVen2').attr("checked", "1");
				$('#ajusFecExiVen1').attr("checked", false);
				$('#ajusFecExiVen').val("N");
			}

			if (credito.calendIrregular == 'S') {
				$('#calendIrregularCheck').attr("checked", "1");
				$('#calendIrregular').val("S");
			} else {
				$('#calendIrregularCheck').attr("checked", false);
				$('#calendIrregular').val("N");
			}

			if (credito.ajusFecUlVenAmo == 'S') {
				$('#ajusFecUlVenAmo1').attr("checked", "1");
				$('#ajusFecUlVenAmo2').attr("checked", false);
				$('#ajusFecUlVenAmo').val("S");
			} else {
				$('#ajusFecUlVenAmo2').attr("checked", "1");
				$('#ajusFecUlVenAmo1').attr("checked", false);
				$('#ajusFecUlVenAmo').val("N");
			}

			if (credito.diaPagoInteres == 'F') {
				$('#diaPagoInteres1').attr("checked", "1");
				$('#diaPagoInteres2').attr("checked", false);
			} else {
				$('#diaPagoInteres2').attr("checked", "1");
				$('#diaPagoInteres1').attr("checked", false);
				$('#diaMesInteres').val(credito.diaMesInteres);
			}
			$('#diaPagoInteres').val(credito.diaPagoInteres);

			if (credito.diaPagoCapital == 'F') {
				$('#diaPagoCapital1').attr("checked", "1");
				$('#diaPagoCapital2').attr("checked", false);
			} else {
				$('#diaPagoCapital2').attr("checked", "1");
				$('#diaPagoCapital1').attr("checked", false);
				$('#diaMesCapital').val(credito.diaMesCapital);
			}
			$('#diaPagoCapital').val(credito.diaPagoCapital);

			$('#cat').formatCurrency({
				positiveFormat : '%n',
				roundToDecimalPlace : 1
			});

			agregaFormatoControles('formaGenerica');
			$("#esConsolidacionAgro").val(credito.esConsolidacionAgro);
			if( credito.esConsolidacionAgro == "S" ) {

				$('#fechaInicioAmor').val(credito.fechaInicio);
				$('#fechaMinistrado').val(credito.fechaInicio);
				$('#fechaInicio').val(credito.fechaInicio);
				$('#fechaPagoMinis1').val(credito.fechaInicio);
				$("#fechaInicioAmor").attr('readonly', true);
				$("#fechaInicioAmor").datepicker("destroy");
				$("#fechaMinistrado").attr('readonly', true);
				$("#fechaMinistrado").datepicker("destroy");
				$("#fechaPagoMinis1").attr('readonly', true);
				$("#fechaPagoMinis1").datepicker("destroy");
				deshabilitaControl('fechaInicioAmor');
				deshabilitaControl('fechaMinistrado');
				deshabilitaControl('fechaInicio');
				deshabilitaControl('fechaPagoMinis1');
			}

		} else {
			mensajeSis("No Existe el Crédito.");
			$('#creditoID').focus();
			$('#creditoID').select();
			deshabilitaBoton('grabar', 'submit');
			deshabilitaBoton('exportarPDF', 'submit');
			deshabilitaBoton('ExptablaAmorti', 'submit');
			deshabilitaBoton('caratula', 'submit');
			deshabilitaBoton('simular', 'submit');
			inicializaForma('formaGenerica', 'creditoID');
		}
	});
}

//funcion que llena el combo de calcInteres
function consultaComboCalInteres() {
	dwr.util.removeAllOptions('calcInteresID');
	formTipoCalIntServicio.listaCombo(catFormTipoCalInt.principal, function(formTipoCalIntBean) {
		dwr.util.addOptions('calcInteresID', {
			'' : 'SELECCIONAR'
		});
		dwr.util.addOptions('calcInteresID', formTipoCalIntBean, 'formInteresID', 'formula');
	});
}
function consultaMinistraciones(estatus) {
	$("#gridMinistraCredAgro").html("");

	var tipoListaMin = 3;
	if(estatus === '' || estatus === 'I'){
		tipoListaMin = 1;
	}

	var fechaMin = $("#fechaInicioAmor").val();
	if(fechaMin=='' || fechaMin ==undefined || fechaMin == null){
		fechaMin = parametroBean.fechaAplicacion;
	}

	var beanMinistraciones = {
		'solicitudCreditoID' :0,
		'creditoID' : $("#creditoID").asNumber(),
		'clienteID' : 0,
		'prospectoID' : 0,
		'fechaPagoMinis' : fechaMin,
		'tipoLista' : tipoListaMin
	};

	$.post("ministraCredAgroGrid.htm", beanMinistraciones, function(data) {
		if (data.length > 0) {
			$("#gridMinistraCredAgro").html(data);
			$("#gridMinistraCredAgro").show();
			agregaFormatoControles('formaGenerica');
			if( $("#esConsolidacionAgro").val() == 'S'){
				$("#fechaPagoMinis1").attr('readonly', true);
				$("#fechaPagoMinis1").datepicker("destroy");
			}
		} else {
			$("#gridMinistraCredAgro").html("");
			$("#gridMinistraCredAgro").show();
		}
	});
}
function consultaLineaFondeo(control) {
	var numLinea = $('#lineaFondeo').asNumber();
	setTimeout("$('#cajaLista').hide();", 200);
	if (numLinea >0 && esTab) {
		var lineaFondBeanCon = {
			'lineaFondeoID' : $('#lineaFondeo').val()
		};

		lineaFonServicio.consulta(1, lineaFondBeanCon,{ asyn:false,callback:function(lineaFond) {
			if (lineaFond != null) {
				dwr.util.setValues(lineaFond);
				var fechInicio = $('#fechaInicio').val();
				var fechUltAmorti = $('#valorFecUltAmor').val();
				$('#institFondeoID').val(lineaFond.institutFondID);
				esTab=true;
				consultaInstitucionFondeo('consultaInstitucionFondeo');
				$('#descripLineaFon').val(lineaFond.descripLinea);
				$('#saldoLineaFon').val(lineaFond.saldoLinea);
				$('#saldoLineaFon').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});

				if (fechInicio < lineaFond.fechInicLinea) {
					mensajeSis("La Fecha de Registro es Inferior a la de Inicio de la Linea de Fondeo.");
					$('#lineaFondeo').focus();
				}
				if (fechInicio > lineaFond.fechaFinLinea) {
					mensajeSis("La Fecha de Registro es Superior a la de Fin de la Linea de Fondeo.");
					$('#lineaFondeo').focus();
				}
				var numTran = $('#numTransacSim').val();
				if (numTran != '0' || numTran != '') {
					if (fechUltAmorti > lineaFond.fechaMaxVenci) {
						mensajeSis("La Fecha de Vencimiento de la Última Amortización es Superior a la Fecha de Vencimiento la Linea de Fondeo.");
						$('#lineaFondeo').focus();
					}
				}
				quitaFormatoControles('formaGenerica');
				var saldoLinFon = $('#saldoLineaFon').val();
				var montoCred = $('#montoSolici').val();
				var saldo = parseFloat(saldoLinFon);
				var monto = parseFloat(montoCred);
				agregaFormatoControles('formaGenerica');
				if ($('#tipoFondeo2').is(':checked')) {
					if (monto > saldo) {
						mensajeSis("La Línea de Fondeo no tiene Saldo Suficiente.");
					}
				}
			} else {
				var linea = $('#lineaFondeo').asNumber();
				if (linea > 0) {
					mensajeSis("No Existe la Linea Fondeador.");
					$('#lineaFondeo').focus();
					$('#lineaFondeo').select();
					$('#lineaFondeo').val('');
					$('#institFondeoID').val('');
					$('#descripLineaFon').val('');
					$('#saldoLineaFon').val('');
					$('#tasaPasiva').val('');
					$('#lineaFondeo').focus();
				}
			}
		},errorHandler : function(message) {
			mensajeSis("Error en Consulta de la Linea de Fondeo." + message);
		}
		});
	}
}

function consultaInstitucionFondeo(idControl) {
	var numInstituto = $('#institFondeoID').asNumber();
	var instFondeoBeanCon = {
		'institutFondID' : numInstituto
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (numInstituto>0) {
		fondeoServicio.consulta(2, instFondeoBeanCon, function(instituto) {
			if (instituto != null) {
				$('#descripFondeo').val(instituto.nombreInstitFon);

			} else {
				if (numInstituto > 0) {
					if ($('#tipoFondeo').val() == 'P') {
						$('#institFondeoID').val('');
						$('#descripFondeo').val('');

					} else {
						mensajeSis("No Existe la Institución.");
						$('#institFondeoID').focus();
						$('#institFondeoID').select();
						$('#institFondeoID').val('');
						$('#descripFondeo').val('');
					}
				}
			}
		});
	}
}

//---------------------valida la linea de fondeo al hacer el submit---------------------
function validaLineaFondeo() {
	var numLinea = $('#lineaFondeo').val();
	setTimeout("$('#cajaLista').hide();", 200);
	if (numLinea != '' && !isNaN(numLinea) && esTab) {
		var lineaFondBeanCon = {
			'lineaFondeo' : $('#lineaFondeo').val()
		};

		lineaFonServicio.consulta(1, lineaFondBeanCon, function(lineaFond) {
			if (lineaFond != null) {
				dwr.util.setValues(lineaFond);
				var fechInicio = $('#fechaInicio').val();
				var fechUltAmorti = $('#valorFecUltAmor').val();
				var instFondeo = $('#institFondeoID').asNumber();
				$('#descripLineaFon').val(lineaFond.descripLinea);
				$('#saldoLineaFon').val(lineaFond.saldoLinea);
				$('#saldoLineaFon').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				if (instFondeo != lineaFond.institFondeoID && instFondeo != '0') {
					mensajeSis("La Linea de Fondeo no Corresponde con la Institución.");
					$('#lineaFondeo').val('');
					$('#institFondeoID').val(instFondeo);
					$('#descripLineaFon').val('');
					$('#saldoLineaFon').val('');
					$('#tasaPasiva').val('');
					$('#lineaFondeo').focus();
					procede = 1;
				} else {
					if (fechInicio < lineaFond.fechInicLinea && instFondeo != '0') {
						mensajeSis("La Fecha de Registro es Inferior a la de Inicio de la Linea de Fondeo.");
						$('#lineaFondeo').focus();
						procede = 1;
					} else {
						if (fechInicio > lineaFond.fechaFinLinea && instFondeo != '0') {
							mensajeSis("La Fecha de Registro es Superior a la de Fin de la Linea de Fondeo.");
							$('#lineaFondeo').focus();
							procede = 1;
						} else {
							if ($('#numTransacSim').asNumber() != '0' || $('#numTransacSim').val() != '' && instFondeo != '0') {
								if (fechUltAmorti > lineaFond.fechaMaxVenci) {
									mensajeSis("La Fecha de Vencimiento de la Última Amortización es Superior a la Fecha de Vencimiento la Linea de Fondeo.");
									$('#lineaFondeo').focus();
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
				var linea = $('#lineaFondeo').val();
				var instit = $('#institFondeoID').val();
				if (linea != '0' && instit != '0') {
					mensajeSis("No Existe la Linea Fondeador.");
					$('#lineaFondeo').focus();
					$('#lineaFondeo').select();
					$('#lineaFondeo').val('');
					$('#institFondeoID').val('');
					$('#descripLineaFon').val('');
					$('#saldoLineaFon').val('');
					$('#tasaPasiva').val('');
					$('#lineaFondeo').focus();
					procede = 1;
				}
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
	var instFondeo = $('#institFondeoID').asNumber();
	agregaFormatoControles('formaGenerica');
	if ($('#tipoFondeo2').is(':checked')) {
		if (monto > saldo && instFondeo != '0') {
			mensajeSis("La Linea de Fondeo no tiene Saldo Suficiente");
			$('#lineaFondeo').focus();
			procede = 1;
		} else {
			procede = 0;
		}
	} else {
		procede = 0;
	}
	return procede;
}
function asignaTipoFondeo(tipoFondeo) {
	if (tipoFondeo == 'P') {
		$('#tipoFondeo').attr("checked", true);
		$('#tipoFondeo2').attr("checked", false);
		$('#institFondeoID').val("");
		$('#lineaFondeo').val("");
		$('#descripFondeo').val("");
		$('#descripLineaFon').val("");
		$('#saldoLineaFon').val("");
		deshabilitaControl('institFondeoID');
		deshabilitaControl('lineaFondeo');
	}
	if (tipoFondeo == 'F') {
		$('#tipoFondeo').attr("checked", false);
		$('#tipoFondeo2').attr("checked", true);
	}
}

function consultaDestinoCredito(destinoCreditoID) {
	var DestCred = destinoCreditoID;
	var DestCredBeanCon = {
			'destinoCreID' : DestCred
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (Number(DestCred)>0) {
		destinosCredServicio.consulta(catTipoConsultaCredito.principal, DestCredBeanCon, function(destinos) {
			if (destinos != null) {
				subClasifCredito = destinos.subClasifID;
			} else {
				subClasifCredito = 0;
			}
		});
	} else {
		subClasifCredito = 0;
	}
}