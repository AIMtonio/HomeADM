//VARIABLES
var esTab = true;
var montoGlobalVar = 0;
var montoTotalCapCons = 0;		// Monto total de solo el capital de las aportaciones consolidadas.
var diaPagoVar = 0;
var aportacionBeanVar;
var tipoAportacionBeanVar;
var parametroBean = consultaParametrosSession();
var totalSaldovar = 0;
var calificacionCteVar = "";
var tipoTasaVar = "";
var tipoAportVar = 0;
var maxPuntosVar = 0;
var minPuntosvar = 0;
var especificaTasaVar = "";
var pagaISRVar = "";
var tasaISRCliente = 0.0;
var tasaCalculada = 0.0;
var plazoAport = 0;
var clienteIDVar = 0;
var pagoIntCalVar = 0;
var tipoTransaccion = 0;
var tasaFijaOriginal = 0;
var nuevaTasaFija = 0;
var montoSinIntereses = 0;
var interesesMenosISR = 0;
var montoMinimoTipoAport = 0;
var perfilUsuario = parametroBean.perfilUsuario;
var perfilAutEspAport = 0;
var aportConsolida = '';
var estatusAportacion = '';
//CONSTANTES
var decimalCeroStr = '0.00';
var constanteSI = 'S';
var cadenaVacia = '';


//INTERFACES
var catTipoListaAportacion = {
	'reinversionPosterior': 13
};
var catTipoConsultaAportacion = {
	'principal' : 1
};
var catTipoConsultaCliente = {
	'foranea': 2,
	'aportaciones' : 25
};
var catTipoConsultaAportaciones = {
	'general' : 2
};
var catConVencimConsulta = {
	'principal' : 1,
	'existe' : 2,
	'estatus' : 3
};
var catTipoPago = {
	'programado' : 'E',
	'alVencimiento' : 'V'
};
var catReiversion = {
	'posteriormente' : 'F',
	'alVencimiento' : 'S',
	'noReinvertir' : 'N'
};
var catReinvertir = {
	'capital' : 'C',
	'capitalMasIntereses' : 'CI',
	'ninguna' : 'N'
};
var catTipoRenovacion = {
	'renovConMas' : 2,
	'renovConMenos' : 3
};
var catTipoTasa = {
	'tasaFija' : 'F',
	'tasaVariable' : 'V'
};
var catTipoCalculoFecha = {
	'vencimiento'	: 6,
	'programado'	: 5
};
var catTipoTransaccion = {
	'agrega'	: 1,
	'modifica'	: 2,
	'autoriza'	: 3,
	'consolida'	: 5
};
var catEstatusAportacion = {
	'vigente'	: 'N',
	'pagada'	: 'P',
	'cancelada'	: 'C',
	'registrada' : 'A'
};



//DOCUMENT READY
$(document).ready(function() {


	$(':text').focus(function() {
		esTab = false;
   });

   $(':text').bind('keydown',function(e){
	   if (e.which == 9 && !e.shiftKey){
		   esTab= true;
	   }
   });

	deshabilitaBoton('autorizar', 'submit');
	deshabilitaBoton('grabar', 'submit');
	cargaComboOpciones();
	$('#estatus').val('P');
	$('#aportacionID').focus();

	/* SUBMIT */
	$.validator.setDefaults({
		submitHandler: function(event) {
			if ($('#tipoTransaccion').asNumber() != catTipoTransaccion.consolida){
				if ( Number($('#tipoTransaccion').val()) === catTipoTransaccion.autoriza ){
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','aportacionID','exito','error');
				}else{
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','aportacionID','funcionExito','error');
				}
			}

		}
	});

	inicializaForma('formaGenerica','aportacionID');
	mostrarElementoPorClase('consolidarSaldos',false);
	ocultaGirdCons(true);

	$('#aportacionID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreCliente";
		camposLista[1] = "estatus";
		parametrosLista[0] = $('#aportacionID').val();
		parametrosLista[1] = 'A';

		lista('aportacionID', 1, catTipoListaAportacion.reinversionPosterior, camposLista, parametrosLista, 'listaAportaciones.htm');
	});

	$('#aportacionID').blur(function(){
		$('#autorizar').hide();
		var aportacionID = $('#aportacionID').val();
		var existeVal = $('#existe').val();
		if(aportacionID!= NaN && aportacionID != null && aportacionID != undefined){
			consultaGrupoConsolida(Number(aportacionID));
		}
		agregaFormatoControles('formaGenerica');
	});

	$('#reinversionAutomSi').click(function(){
		var existeVal = $('#existe').val();
			muestraSeccionesReinversion();
			if(existeVal == constanteSI){
				opcionesReinversion(aportacionBeanVar, 'S','S');
				agregaFormatoControles('formaGenerica');
			}else{
				$('#opcionAport').val(4);
				opcionesReinversion(aportacionBeanVar, 'N','S');
				agregaFormatoControles('formaGenerica');
			}
	});

	$('#reinversionAutomNo').click(function(){
		if($('#reinversionAutomNo').is(':checked')){
			ocultaSeccionesNoReinversion();
		}
	});

	$('#opcionAport').change(function(){
		var opAportacion = Number($('#opcionAport').val());
		var monto = Number($('#montoNuevaAport').asNumber() * 1);
		if( opAportacion === catTipoRenovacion.renovConMas || opAportacion === catTipoRenovacion.renovConMenos){
			mostrarElementoPorClase('cantidadReno',true);
			if(opAportacion === catTipoRenovacion.renovConMas){
				mostrarElementoPorClase('consolidarSaldos',true);
			} else {
				mostrarElementoPorClase('consolidarSaldos',false);
			}
		}else{
			$('#cantidad').val('');
			mostrarElementoPorClase('cantidadReno',false);
			mostrarElementoPorClase('consolidarSaldos',false);
		}
		$('input[name="consolidarSaldos"]').change();
		calculaMontoRenovacion(opAportacion);
		calculaMontoGlobal();
		agregaFormatoControles('formaGenerica');
		limpiaIntereses();
	});

	$('#cantidad').blur(function(){
			var opAportacion = Number($('#opcionAport').val());
			calculaMontoRenovacion(opAportacion);
			calculaMontoGlobal();
			agregaFormatoControles('formaGenerica');
	});

	$('input[name="consolidarSaldos"]').change(function (event){
		ocultaGirdCons(false);
		montoTotalCapCons = 0;
	});

	$('#tipoPagoNuevaAport').change(function(){
		var tipoPago = $('#tipoPagoNuevaAport').val();
		if(tipoPago === catTipoPago.programado){
			$('#lblDiaPago').show();
			$('#diaPagoNuevaAport').show();
		}else if(tipoPago === catTipoPago.alVencimiento){
			$('#lblDiaPago').hide();
			$('#diaPagoNuevaAport').hide();
		}
		agregaFormatoControles('formaGenerica');
		consultaFechaVencimiento();
		limpiaIntereses();
	});

	$('#plazoNuevaAport').change(function(){
		var plazo = $('#plazoNuevaAport').val();
		if(plazo!= NaN && plazo != null && plazo != undefined && Number(plazo) > 0){
				consultaFechaVencimiento();
				limpiaIntereses();
		}
	});

	$('#plazoNuevaAport').blur(function(){
		var plazo = $('#plazoNuevaAport').val();
		if(esTab){
			if(plazo!= NaN && plazo != null && plazo != undefined && Number(plazo) > 0){
				consultaFechaVencimiento();
				limpiaIntereses();
			}else{
				mensajeSis('Especifique los días de Plazo');
				$('#plazoNuevaAport').val('');
				$('#plazoNuevaAport').focus();
			}
			calculaValorTasa();
			agregaFormatoControles('formaGenerica');
		}
	});

	$('#diaPagoNuevaAport').change(function(event){
		consultaFechaVencimiento();
		limpiaIntereses();
	});

	$('input[name="capitalizaNuevaAport"]').change(function (event){
		limpiaIntereses();
	});

	$('#simular').click(function() {

		consultaSimulador();
	});

	$('#grabar').click(function(event){
		var existeVal = $('#existe').val();
		if(existeVal === constanteSI){
			if($('#reinversionAutomSi').is(':checked')){
				if($('#simulacion').val() == 'S'){
					if(validaEstatus()){
						if(tasaMinMax(true)){
							$('#estatus').val('R');
							$('#tipoTransaccion').val(2);
						}else{
							event.preventDefault();
						}
					}else{
						event.preventDefault();
					}
				}else{
					mensajeSis('No se ha realizado la simulación');
					$('#simular').focus();
				}
			}else{
				$('#tipoTransaccion').val(2);
			}
		}else{
			$('#tipoTransaccion').val(1);
		}
	});

	$('#autorizar').click(function(event){
		if(tasaMinMax(false)){
			$('#tipoTransaccion').val(3);
			var estatus = $('#estatus').val();
			if(estatus === 'P'){
				$('#estatus').val('R');
			}else if(estatus === 'R'){
				$('#estatus').val('A');
			}else{
				$('#estatus').val('R');
			}
		} else {
			deshabilitaBoton('autorizar', 'submit');
			event.preventDefault();
		}
	});

	$('#tasaBrutaNuevaAport').blur(function(e){
		if(!validacion.esNumeroDecimal($('#tasaBrutaNuevaAport').val())){
			$('#tasaBrutaNuevaAport').val('');
		}
	});

	$('#cantidad').blur(function(e){
		var cantidad = $('#cantidad').asNumber();
		if(!validacion.esNumeroDecimal(cantidad)){
			$('#cantidad').val('');
		}
	});

	$('#notasNuevaAport').blur(function(){
		limpiarCaracterEscape(this.id, 500);
		ponerMayusculas(this);
	});

	$('#condiciones').blur(function(){
		limpiarCaracterEscape(this.id, 500);
		ponerMayusculas(this);
	});

	$('#formaGenerica').validate({
		rules: {
			aportacionID: {
					required: true
			}
		},

		messages: {
			aportacionID: {
				required: 'Especifique Aportación.'
			}
		},
	});


	$('#reinversion').change(function(){
		calculaMontoReinv();
		sumaTotalesCons(true);
	});


});
//FIN DOCUMENT READY


function consultaSimulador(){
	var validacion = validaCondicionesSimulador();
	if( validacion === true){

		var params = {};
		params['tipoLista']		= 2;
		params['fechaInicio']	= $('#fechaInicioNuevaAport').val();
		params['fechaVencimiento'] = $('#fechaVencimNuevaAport').val();
		params['monto']			= $('#montoRenovNuevaAport').asNumber();
		params['clienteID']		= clienteIDVar;
		params['tipoAportacionID']	= tipoAportVar;
		params['tasaFija']		= $('#tasaBrutaNuevaAport').val();
		params['tipoPagoInt']	= $('#tipoPagoNuevaAport').val();
		params['diasPeriodo']	= '';
		params['pagoIntCal']	= pagoIntCalVar;
		params['diasPagoInt']	= $('#diaPagoNuevaAport').val();
		params['plazoOriginal']	= $('#plazoNuevaAport').val();
		params['capitaliza']	= ($('#tipoPagoNuevaAport').val() === catTipoPago.programado) ? opcionCapitaliza() : '';


		$.post("condicionesVencimSimulador.htm", params, function(simular){
			if(simular.length >0) {
				$('#contenedorSimulador').show();
				$('#divContenedorSimulador').show();
				$('#contenedorSimulador').html(simular);

				var varTotalFinal = $('#varTotalFinal').text();
				var varSaldoCapital = $('#varSaldoCapital').text();
				var varTotalCapital = $('#varTotalCapital').text();
				var varTotalInteres = $('#varTotalInteres').text();
				var varTotalISR = $('#varTotalISR').text();
				var varTotalInteresRecibir = Number(varTotalInteres) - Number(varTotalISR);

				$("#interesGenNuevaAport").val(varTotalInteres);
				$("#intRecibirNuevaAport").val(varTotalInteresRecibir);
				$("#isrRetenerNuevaAport").val(varTotalISR);
				$("#totRecibirNuevaAport").val(varTotalFinal);

				$("#varTotalFinal").text(formatoMonedaVariable(varTotalFinal, true));
				$("#varSaldoCapital").text(formatoMonedaVariable(varSaldoCapital, true));
				$("#varTotalCapital").text(formatoMonedaVariable(varTotalCapital, true));
				$("#varTotalInteres").text(formatoMonedaVariable(varTotalInteres, true));
				$("#varTotalISR").text(formatoMonedaVariable(varTotalISR, true));

				$('#simulacion').val('S');
				agregaFormatoControles('formaGenerica');
			}else{
				$('#contenedorSimulador').html("");
				$('#divContenedorSimulador').hide();
				$('#contenedorSimulador').hide();
				$('#simulacion').val('N');
			}
		});
	}
}


function validaCondicionesSimulador(){
	var plazo = $('#plazoNuevaAport').asNumber();
	var monto = $('#montoNuevaAport').asNumber();
	var tipoPago = $('#tipoPagoNuevaAport').val();
	var tasa = $('#tasaBrutaNuevaAport').asNumber();
	var diaPago = $('#diaPagoNuevaAport').val();
	var opcionAport = $('#opcionAport').val();
	var cantidad = $('#cantidad').asNumber() * 1;
	var tipoReinversion = $('#reinversion').val();


	if(plazo <= 0){
		mensajeSis('Especifique los días de Plazo.');
		$('#plazoNuevaAport').val('');
		$('#plazoNuevaAport').focus();
		return false;
	}
	if (monto <= 0){
		mensajeSis('Especifique el Monto.');
		$('#montoNuevaAport').val('');
		$('#montoNuevaAport').focus();
		return false;
	}
	if(tipoPago == '' || tipoPago == NaN || tipoPago == undefined){
		mensajeSis('Especifique el Tipo de Pago.');
		$('#tipoPagoNuevaAport').focus();
		return false;
	}
	if(tasa <= 0){
		mensajeSis('Especifique la tasa.');
		$('#tasaBrutaNuevaAport').val('');
		$('#tasaBrutaNuevaAport').focus();
		return false;
	}
	if(tipoPago === 'E' && (diaPago == '' || diaPago == NaN || diaPago == undefined)){
		mensajeSis('Especifique el día de pago.');
		$('#diaPagoNuevaAport').focus();
		return false;
	}
	if(((opcionAport == 2 && $('input[name=consolidarSaldos]:checked').val()==='N') || opcionAport == 3) && cantidad <= 0 ){
		mensajeSis('Especifique la cantidad.');
		$('#cantidad').focus();
		return false;
	}
	if(tipoReinversion == 'N'){
		mensajeSis('Especifique el Tipo de Reinversión.');
		$('#reinversion').val('');
		$('#reinversion').focus();
		return false;
	}

	return true;
}

function cargaComboOpciones() {
	dwr.util.removeAllOptions('opcionAport');
	$('#opcionAport').html('');

	var aportacionID = $('#aportacionID').val();
	var AportacionBean = {
		'aportacionID' : aportacionID
	};

	aportacionesServicio.lista(17,AportacionBean,function(opciones){
		if(opciones != null || opciones != undefined){
			if (opciones.length > 0){
				opciones.forEach(function(element) {
					if(element.descOpcionaport.trim() === "RENOVACION")
						$('#opcionAport').append(
								new Option(element.descOpcionaport, element.opcionAport, true,	true));
					else
						$('#opcionAport').append(
							new Option(element.descOpcionaport, element.opcionAport, true,	false));
				});
			}
			else{
				dwr.util.removeAllOptions('opcionAport');
				deshabilitaControl('opcionAport');
				$('#opcionAport').val('');
			}
		}
	});
}


function consultaAportacion(idAportacion){
	if(idAportacion > 0){
		if(esTab == true){
			var AportacionBean = {
				'aportacionID' : idAportacion
			};
			aportacionesServicio.consulta(catTipoConsultaAportacion.principal, AportacionBean, { async: false, callback: function(aportacion){
				if(aportacion!=null){
					estatusAportacion = aportacion.estatus;
					if( estatusAportacion === catEstatusAportacion.vigente){
						$('#clienteID').val(aportacion.clienteID);
						$('#fechaVencimiento').val(aportacion.fechaVencimiento);

						$('#isr').val(aportacion.interesRetener);
						$('#plazo').val(aportacion.plazoOriginal);
						$('#tasa').val(aportacion.tasaFija);
						$('#tasaISR').val(aportacion.tasaISR);
						$('#tipoPago').val(aportacion.tipoPagoInt).selected = true;
						$('#grupoAportConsol').val(aportacion.aportConsolID);
						$('#notas').val(aportacion.notas);
						plazoAport = aportacion.plazoOriginal;
						pagoIntCalVar = aportacion.pagoIntCal;
						tasaFijaOriginal = aportacion.tasaFija;

						montoSinIntereses = aportacion.monto;
						interesesMenosISR = aportacion.interesRecibir;
						perfilAutEspAport = aportacion.perfilAutoriza;

						if(aportacion.capitaliza === constanteSI){
							$('#capitalizaSi').attr('checked', true);
							$('#capital').val(aportacion.totalFinal);
							$('#interes').val(aportacion.interesGenerado);
						}
						else{
							$('#capitalizaNo').attr('checked', true);
							$('#capital').val(aportacion.monto);
							$('#interes').val(aportacion.interesGenerado);
						}
						// MONTO CAPITAL + INTERESES (CAMPO OCULTO).
						$('#totalFinal').val(aportacion.totalFinal);

						if(aportacion.tipoPagoInt === catTipoPago.programado){
							$('#tdDiaPago').show();
							$('#diaPago').show();
							$('#diaPago').val(aportacion.diasPagoInt).selected = true;
						}else{
							$('#tdDiaPago').hide();
							$('#diaPago').hide();
						}

						$('#diaPago').append(new Option(aportacion.diasPagoInt, aportacion.diasPagoInt, true,true));
						$('#diaPago').val(aportacion.diasPagoInt).selected = true;
						$('#aportTipoCapitaliza').val(aportacion.reinvertir);
						aportacionBeanVar = aportacion;

						if(aportacion.reinversion === catReiversion.alVencimiento){
							muestraSeccionesReinversion();
							$('#reinversionAutomSi').attr('checked', true);
							opcionesReinversion(aportacion, 'N','S');

						}else{
							$('#reinversionAutomNo').attr('checked', true);
							ocultaSeccionesNoReinversion();
						}
						if(aportacion.consolidarSaldos === 'S'){
							mostrarElementoPorClase('consolidarSaldos',true);
							mostrarElementoPorClase('cantidadReno',true);
							$('#consolidarSaldosSi').attr('checked', true);
						} else {
							mostrarElementoPorClase('consolidarSaldos',false);
							$('#consolidarSaldosNo').attr('checked', true);
						}
						consultaTipoAportacion(aportacion.tipoAportacionID);
						habilitaBoton('grabar', 'submit');
						consultaMontoGlobal();
						consultaCliente(aportacion.clienteID);
					} else if(aportacion.estatus === catEstatusAportacion.pagada){
						mensajeSis('Esta Aportación ya se encuentra Pagada');
						$('#aportacionID').val('');
						$('#aportacionID').focus(10);
						inicializaForma('formaGenerica','aportacionID');

					} else if(aportacion.estatus === catEstatusAportacion.cancelada){
						mensajeSis('Esta Aportación está Cancelada');
						$('#aportacionID').val('');
						$('#aportacionID').focus(10);
						inicializaForma('formaGenerica','aportacionID');
					} else{
						mensajeSis('Esta Aportación No está Vigente');
						$('#aportacionID').val('');
						$('#aportacionID').focus(10);
						inicializaForma('formaGenerica','aportacionID');
					}
				}else{
					ocultaSeccionesNoReinversion();
					mensajeSis('No existe la Aportación');
					$('#aportacionID').val('');
					$('#aportacionID').focus(10);
					inicializaForma('formaGenerica','aportacionID');

				}
			}});
		}
	}else{
		inicializaForma('formaGenerica','aportacionID');
		$('#aportacionID').val('');
		$('#aportacionID').focus(10);
		ocultaSeccionesNoReinversion();
		$('#divContenedorSimulador').hide();
		$('#contenedorSimulador').hide();
		deshabilitaBoton('grabar', 'submit');
	}
}

function consultaGrupoConsolida(idAportacion){
	var numAportacion = 0;
	if(idAportacion > 0 && esTab){
		var AportacionBean = {
			'aportacionID' : idAportacion
		};
		aportacionesServicio.consulta(catTipoConsultaAportacion.principal, AportacionBean, { async: false, callback: function(aportacion){
			if(aportacion!=null){
				/** Si pertenece a un grupo de consolidación, se consulta
				 ** el número de aportación del grupo.*/
				if(Number(aportacion.aportConsolID)>0){
					$('#aportacionID').val(aportacion.aportConsolID);
					numAportacion = aportacion.aportConsolID;
				} else {
				/** Sino, se consulta
				 ** el número de aportación ingresada desde oantalla.*/
					$('#aportacionID').val(idAportacion);
					numAportacion = idAportacion;
				}
				consultaAportacion(Number(numAportacion));
				consultaExiste(Number(numAportacion));
				consulta(Number(numAportacion));
				agregaFormatoControles('formaGenerica');
			}else{
				ocultaSeccionesNoReinversion();
				mensajeSis('No existe la Aportación');
				$('#aportacionID').val('');
				$('#aportacionID').focus(10);
				inicializaForma('formaGenerica','aportacionID');

			}
		}});
	}else{
		inicializaForma('formaGenerica','aportacionID');
		$('#aportacionID').val('');
		$('#aportacionID').focus(10);
		ocultaSeccionesNoReinversion();
		$('#divContenedorSimulador').hide();
		$('#contenedorSimulador').hide();
		deshabilitaBoton('grabar', 'submit');
	}
}

function consultaCliente(numCliente){
	if (numCliente != '0') {
		setTimeout("$('#cajaLista').hide();", 200);
		if (numCliente != '' && !isNaN(numCliente) && numCliente != undefined) {
			clienteServicio.consulta(catTipoConsultaCliente.aportaciones, numCliente, ' ', { async : false, callback : function(cliente){
				if (cliente != null) {
					$('#clienteID').val(cliente.numero);
					$('#nombreCliente').val(cliente.nombreCompleto);

					clienteIDVar = cliente.numero;
					calificacionCteVar = cliente.calificaCredito;
					pagaISRVar = cliente.pagaISR;

					if(pagaISRVar === constanteSI){
						tasaISRCliente = cliente.tasaISR;
					}
					if (cliente.validaTasa == 'S') {
						if(Number(cliente.tasaISR) == 0){
							$('#aportacionID').focus(10);
							inicializaForma('formaGenerica','aportacionID');
							deshabilitaBoton('grabar', 'submit');
							deshabilitaBoton('simular', 'submit');
							mensajeSis("El País de Residencia del " + $('#socioCliente').val() +
									"<br>No Cuenta con un esquema de<br>"+
									cargaLinkExterno('Tasas ISR para Residentes en el Extranjero', 'tasasISRExtVista.htm') +
									"<br><br>País de Residencia: <b>" + cliente.paisResidencia + "</b>.");
						} else {
							habilitaBoton('grabar', 'submit');
							habilitaBoton('simular', 'submit');
						}


					} else {
						consultaCtaAho();
					}
					$('#tasaISRNuevaAport').val(tasaISRCliente);
				} else {
					mensajeSis("El Cliente No Existe.");
					$('#aportacionID').focus();
				}
			}});
		}
	}
}


function consultaTipoAportacion(tipoAportacionID){
	tipoAportVar = tipoAportacionID;
	var tiposAportacionesBean = {
		'tipoAportacionID':tipoAportacionID,
		'monedaId':1
	};

	tiposAportacionesServicio.consulta(catTipoConsultaAportaciones.general, tiposAportacionesBean,{ async: false, callback: function(tiposAportaciones){
	    dwr.util.removeAllOptions('diaPagoNuevaAport');
	    dwr.util.removeAllOptions('tipoPagoNuevaAport');
	 	var strtiposAportaciones  = tiposAportaciones.tipoPagoInt;
		var tiposAportacionesArray = strtiposAportaciones.split(",");
		var tipAporTemp="";
	 		$('#tipoPagoNuevaAport').append(	new Option("SELECCIONAR","", true,true));
		for(var i = 0; i < tiposAportacionesArray.length ; i++){
			if(tiposAportacionesArray[i]=='E'){
			   tipAporTemp= "PROGRAMADO";
			}else{
				tipAporTemp="VENCIMIENTO";
			}
			$('#tipoPagoNuevaAport').append(new Option(tipAporTemp, tiposAportacionesArray[i], true,	false));
		}

		if(tiposAportaciones!=null){
			tipoAportacionBeanVar = tiposAportaciones;
			var strDiasPago  = tiposAportaciones.diasPago;
			var diasPagoArray = strDiasPago.split(",");
			$('#diaPagoNuevaAport').append(	new Option("SELECCIONAR","", true,true));
			for(var i = 0; i < diasPagoArray.length ; i++){
				$('#diaPagoNuevaAport').append(new Option(diasPagoArray[i], diasPagoArray[i], true,	false));
			}
			$('#diaInhabil').val(tiposAportaciones.diaInhabil);
			tipoTasaVar = tiposAportaciones.tasaFV;
			especificaTasaVar = tiposAportaciones.especificaTasa;
			montoMinimoTipoAport = tiposAportaciones.minimoApertura;
			$('#tasaMontoGlobal').val(tiposAportaciones.tasaMontoGlobal);
		}
	}});
}

function ocultaSeccionesNoReinversion(){
	$('#condicionesNuevaAport').hide();
	mostrarElementoPorClase('siRenovacion',false);
	$('#tdTipoReinversion').hide();
	$('#reinversion').hide();
	$('#opcionAport').hide();
	$('#lblOpcionAport').hide();

	$('#montoNuevaAport').val('');
	$('#montoRenovNuevaAport').val('');
	$('#montoGlobalNuevaAport').val('');
	$('#tipoPagoNuevaAport').val('');
	$('#diaPagoNuevaAport').val('');

	$('#plazoNuevaAport').val('');
	$('#fechaInicioNuevaAport').val('');
	$('#fechaVencimNuevaAport').val('');
	$('#tasaBrutaNuevaAport').val('');
	$('#tasaISRNuevaAport').val('');

	$('#tasaNetaNuevaAport').val('');
	$('#gatNominalNuevaAport').val('');
	$('#gatRealNuevaAport').val('');
	$('#interesGenNuevaAport').val('');
	$('#isrRetenerNuevaAport').val('');

	$('#intRecibirNuevaAport').val('');
	$('#totRecibirNuevaAport').val('');
	$('#notasNuevaAport').val('');
	$('#especificacionesNuevaAport').val('');

	ocultaGirdCons(true);
	mostrarElementoPorClase('consolidarSaldos',false);
	mostrarElementoPorClase('cantidadReno',false);
	limpiaSimulador();
}

function limpiaSimulador(){
	$('#contenedorSimulador').html("");
	$('#simulacion').val('N');
	deshabilitaBoton('autorizar', 'submit');
}

function muestraSeccionesReinversion(){
	$('#condicionesNuevaAport').show();
	mostrarElementoPorClase('siRenovacion',true);
	$('#tdTipoReinversion').show();
	$('#reinversion').show();
	$('#lblDiaPago').show();
	$('#diaPagoNuevaAport').show();
	$('#opcionAport').show();
	$('#lblOpcionAport').show();
	if(especificaTasaVar === constanteSI){
		habilitaControl('tasaBrutaNuevaAport');
		maxPuntosVar = tipoAportacionBeanVar.maxPuntos;
		minPuntosvar = tipoAportacionBeanVar.minPuntos;
	}else{
		deshabilitaControl('tasaBrutaNuevaAport');
	}
}

function opcionesReinversion(aportacionBean, varExiste, reinversion){
	if(reinversion == 'S'){
		var montoOriginal = $('#capital').asNumber();
		var opAportacion = Number($('#opcionAport').val());
		$('#tasaISRNuevaAport').val(tasaISRCliente);
		if(varExiste == 'S'){
			$('#reinversion').val(aportacionBean.reinvertir).selected = true;
			$('#tipoPagoNuevaAport').val(aportacionBean.tipoPagoInt).selected = true;
			$('#diaPagoNuevaAport').val(aportacionBean.diasPagoInt).selected = true;
			$('#plazoNuevaAport').val(aportacionBean.plazoOriginal);
			$('#plazoOriginalNuevaAport').val(aportacionBean.plazoOriginal);
			$('#fechaInicioNuevaAport').val(aportacionBean.fechaVencimiento);
			$('#montoNuevaAport').val(montoOriginal);
			$('#opcionAport').val(4);
			$('#cantidad').val('');
			mostrarElementoPorClase('cantidadReno',false);
			calculaMontoRenovacion(4);
		}else{
			$('#reinversion').val(aportacionBean.reinvertir).selected = true;
			$('#tipoPagoNuevaAport').val(aportacionBean.tipoPagoInt).selected = true;
			$('#diaPagoNuevaAport').val(aportacionBean.diasPagoInt).selected = true;
			$('#plazoNuevaAport').val(aportacionBean.plazoOriginal);
			$('#plazoOriginalNuevaAport').val(aportacionBean.plazoOriginal);
			$('#fechaInicioNuevaAport').val(aportacionBean.fechaVencimiento);
			$('#montoNuevaAport').val(montoOriginal);
			calculaMontoRenovacion(4);
		}


		calculaMontoGlobal();
		consultaFechaVencimiento();


		if(aportacionBeanVar.capitaliza === constanteSI){
			$('#capitalizaNuevaAportSi').attr('checked', true);
		}
		else{
			$('#capitalizaNuevaAportNo').attr('checked', true);
		}

		if(aportacionBean.tipoPagoInt === catTipoPago.programado){
			$('#lblDiaPago').show();
			$('#diaPagoNuevaAport').show();
		}else if(aportacionBean.tipoPagoInt === catTipoPago.alVencimiento){
			$('#lblDiaPago').hide();
			$('#diaPagoNuevaAport').hide();
		}


		$('#interesGenNuevaAport').val(decimalCeroStr);
		$('#isrRetenerNuevaAport').val(decimalCeroStr);
		$('#intRecibirNuevaAport').val(decimalCeroStr);
		$('#totRecibirNuevaAport').val(decimalCeroStr);
	}

	if(estatusAportacion == catEstatusAportacion.vigente){
	if(Number(aportacionBeanVar.comentarios) > 0){
		$('#lblEspecificaciones').show();
		$('#especificacionesNuevaAport').show();
		$('#especificacionesNuevaAport').val('');
		aportacionesServicio.lista(16,aportacionBean,function(comentarios){
			if(comentarios != null){
				comentarios.forEach(function(coment) {
					var aux=$('#especificacionesNuevaAport').val();
					$('#especificacionesNuevaAport').val(aux +""+ coment.desComentarios.toString()+"\n");
				});
			}
		});
		}else{
			$('#lblEspecificaciones').hide();
			$('#especificacionesNuevaAport').hide();
		}
	}else{
		$('#lblEspecificaciones').hide();
		$('#especificacionesNuevaAport').hide();
	}
}

function calculaMonto( aportacionBean){
	var monto = 0;
	if(aportacionBean.reinvertir === catReinvertir.capital){
		monto = Number(aportacionBean.monto) + Number(aportacionBean.interesRecibir);
		$('#montoNuevaAport').val(monto);
		$('#montoRenovNuevaAport').val(parseFloat(monto).toFixed(2));
	}else {
		monto = Number(aportacionBean.monto);
		$('#montoNuevaAport').val(monto);
		$('#montoRenovNuevaAport').val(parseFloat(monto).toFixed(2));
	}
}

function calculaMontoRenovacion(opAportacion){
	var montoRenovacion = 0;
	var valCantidad = $('#cantidad').val();
	var cantidad = Number($('#cantidad').asNumber());
	var monto = Number($('#montoNuevaAport').asNumber() * 1);

	if( opAportacion === catTipoRenovacion.renovConMas || opAportacion === catTipoRenovacion.renovConMenos){
		mostrarElementoPorClase('cantidadReno',true);
		if(valCantidad != '' && valCantidad != NaN && valCantidad != undefined){
			if($('#reinversionAutomSi').is(':checked')){
				if(opAportacion === catTipoRenovacion.renovConMas){
					montoRenovacion = monto + cantidad;
				}else if(opAportacion === catTipoRenovacion.renovConMenos){
					montoRenovacion = monto - cantidad;
					if(montoRenovacion < montoMinimoTipoAport){
						mensajeSis('El monto de renovación está por debajo del monto mínimo');
						$('#cantidad').val('');
						$('#cantidad').focus(10);
						montoRenovacion = monto;
					}

				}
			}
			$('#montoRenovNuevaAport').val(parseFloat(montoRenovacion).toFixed(2));
		}
	}else{
		$('#cantidad').val('');
		mostrarElementoPorClase('cantidadReno',false);
		$('#montoRenovNuevaAport').val(parseFloat(monto).toFixed(2));
	}
}


function calculaMontoGlobal(){
	var valMontoRenovacion = $('#montoRenovNuevaAport').asNumber();
	var montoG = parseFloat(Number(montoGlobalVar)).toFixed(2);
	var monto = parseFloat(Number(valMontoRenovacion)).toFixed(2);
	$('#montoGlobalNuevaAport').val( parseFloat( Number(monto) + Number(montoG) - Number(montoTotalCapCons)).toFixed(2) );
	agregaFormatoControles('formaGenerica');
}

function consultaFechaVencimiento(){
	var varDomingo = 'D';
	var tipoConsulta = 0;
	var diaInhabil = $('#diaInhabil').val();
	var plazo = $('#plazoNuevaAport').val();
	var monto = parseFloat( Number( $('#montoRenovNuevaAport').asNumber() ) ).toFixed(2);
	var diaPagoNuevaAport = 0;

	var tipoPago = $('#tipoPagoNuevaAport').val();
		if(tipoPago == catTipoPago.programado){
			tipoConsulta = catTipoCalculoFecha.programado;
			diaPagoNuevaAport = $('#diaPagoNuevaAport').val();
		}else if(tipoPago == catTipoPago.alVencimiento){
			tipoConsulta = catTipoCalculoFecha.vencimiento;
			diaPagoNuevaAport = '';
		}

	var opeFechaBean = {
		'primerFecha'	: $('#fechaInicioNuevaAport').val(),
		'numeroDias'	: plazo,
		'diaInhabil'	: $('#diaInhabil').val(),
		'diaPago'		: diaPagoNuevaAport
	};

	if(((diaPagoNuevaAport != 0 || diaPagoNuevaAport != '') && tipoPago == catTipoPago.programado)||
		(tipoPago == catTipoPago.alVencimiento)){
	operacionesFechasServicio.realizaOperacion(opeFechaBean,tipoConsulta,function(data) {
		if(data!=null){
			$('#fechaVencimNuevaAport').val(data.fechaHabil);
			$('#plazoOriginalNuevaAport').val(data.diasEntreFechas);
			calculaValorTasa();
		}else{
			mensajeSis("Error al Consultar Fechas. Intente nuevamente.");
		}
	});}
}


function consultaCtaAho() {
	var numCon = 5;
	var cuentaAhoID = aportacionBeanVar.cuentaAhoID;
	var clienteID = aportacionBeanVar.clienteID;
	var CuentaAhoBeanCon = {
		'cuentaAhoID'	: cuentaAhoID,
		'clienteID'		: clienteID
	};

	if(cuentaAhoID!='' && cuentaAhoID!=undefined && !isNaN(cuentaAhoID)){
		cuentasAhoServicio.consultaCuentasAho(numCon, CuentaAhoBeanCon, { async: false, callback: function(cuenta) {
			if(cuenta!=null && cuenta.saldoDispon!=null){
				$('#totalSaldo').val(cuenta.saldoDispon);
			}
		}});
	}
}


function calculaValorTasa(){
	var monto = $('#montoGlobalNuevaAport').asNumber();
	var tipoCon = 2;
	var totalSaldo = $('#totalSaldo').asNumber();
	var plazo = $('#plazoNuevaAport').asNumber() * 1;
	var tasasAportacionBean = {
		'tipoAportacionID': tipoAportVar,
		'plazo' 		  : plazo,
		'monto' 		  : Number(monto),
		'calificacion' 	  : calificacionCteVar ,
		'sucursalID'  	  : parametroBean.sucursal
	};

	if(plazo > 0 && esTab == true ){
		tasasAportacionesServicio.consulta(tipoCon, tasasAportacionBean, {/* async: false, */ callback: function(porcentaje){
			if((porcentaje.tasaAnualizada > 0 && porcentaje.tasaAnualizada != null) || (porcentaje.tasaBase > 0 && porcentaje.tasaBase != null)){
				tasaCalculada = porcentaje.tasaAnualizada;
				$('#tasaBrutaNuevaAport').val(porcentaje.tasaAnualizada);
				$('#tasaBrutaNuevaAport').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
				$('#gatNominalNuevaAport').val(porcentaje.valorGat);
				$('#gatNominalNuevaAport').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 4});
				$('#gatRealNuevaAport').val(porcentaje.valorGatReal);
				$('#gatRealNuevaAport').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 4});
				calculaTasaNeta();
			}else{
				mensajeSis("No existe una Tasa Anualizada.");
				$('#plazoNuevaAport').val('');
				$('#tasaBrutaNuevaAport').val('');
				$('#plazoNuevaAport').focus();
			}
		}});
	}
}

function calculaTasaNeta(){
	var tasaBruta = $('#tasaBrutaNuevaAport').asNumber();
	var tasaISR = $('#tasaISRNuevaAport').asNumber();
	var tasaneta = tasaBruta - tasaISR;
	$('#tasaNetaNuevaAport').val(tasaneta).formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
}


function opcionCapitaliza(){
	if ( $('#capitalizaNuevaAportSi').is(':checked') )
		return 'S';
	if ( $('#capitalizaNuevaAportNo').is(':checked') )
		return 'N';
}

function consultaExiste(aportacionID){
	var aportacionBean = {
		'aportacionID':aportacionID
	};

	condicionesVencimServicio.consulta(catConVencimConsulta.existe, aportacionBean,{ async: false, callback: function(aportacion){
		if(aportacion!=null){
			$('#existe').val(aportacion.existe);
			if(aportacion.existe === constanteSI){
				consultaEstatus(aportacionID);

			}else{
				$('#estatus').val('P');
			}
		}
	}});
}


function consultaEstatus(aportacionID){
	var aportacionBean = {
		'aportacionID':aportacionID
	};
	condicionesVencimServicio.consulta(catConVencimConsulta.estatus, aportacionBean,{ async: false, callback: function(aportacion){
		if(aportacion!=null){
			$('#estatus').val(aportacion.estatus);
		}
	}});
}


function validaEstatus(){
	var estatus = $('#estatus').val();
	if (estatus === 'A'){
		if(confirm("Las Condiciones ya se encuentran Autorizadas.\nSi desea continuar, pasarán a Estatus Por Autorizar y tendrá que Autorizarlas Nuevamente.")){
			return true;
		}else{
			return false;
		}
	}
	return true;
}


function tasaMinMax(esConfirm){
	// Si la nueva tasa no esta vacía y el producto si permite especificación de tasa.
	if($('#tasaBrutaNuevaAport').val() != "" && especificaTasaVar == 'S'){
		/** A la tasa sugerida por safi, se le suman/restan los puntos del producto
		 ** para obtener los límites. */
		var tasaMax=parseFloat(tasaCalculada)+ Number(maxPuntosVar);
		var tasaMin=parseFloat(tasaCalculada)- Number(minPuntosvar);

		/** Si la nueva tasa supera esos límites, entonces se valida el perfil del usuario.*/
		if( $('#tasaBrutaNuevaAport').asNumber() > parseFloat(Number(tasaMax).toFixed(2)) ||
			$('#tasaBrutaNuevaAport').asNumber() < parseFloat(Number(tasaMin).toFixed(2))){
			/** Si no es confirm, indica que se validará los perfiles de usuarios para validar
			 ** si esta autorizado, debido a que está autorizando las condiciones. */
			 if(!esConfirm){
				/** Si el usuario que registra las condiciones no tiene el perfil  autorizado,
				 ** entonces no permite la autorización y muestra el mensaje de validación. */
				if(parseInt(perfilUsuario) != parseInt(perfilAutEspAport)){
					mensajeSis("Las Condiciones de la Aportación excede los límites de especificación de Tasa permitidos.<br>Se requiere autorización especial.");
					return false;
				}
			 } else {
			/** Si es confirm, indica sólo mostratá un mensaje de validación para que el
			 ** usuario acepte o no, debido a que sólo se está grabando las condiciones. */
				if(confirm("Al Asignar una Tasa Superior o Inferior a los Límites Permitidos, La Aportación Requerirá un Proceso de Autorización Especial.")){
					return true;
				} else {
					$('#tasaFija').val(tasaCalculada);
					return false;
				}
			 }
		}
	}
	return true;
}


function consultaMontoGlobal(){
	var tipoAportacionID = tipoAportVar;
	var aportacionID = $('#aportacionID').val();
	var clienteID = $('#clienteID').val();
	var AportacionBean = {
		'aportacionID' : aportacionID,
		'tipoAportacionID' : tipoAportacionID,
		'clienteID' : clienteID
	};
	aportacionesServicio.consulta(12, AportacionBean, { async: false, callback: function(aportacion){
		if(aportacion!=null){
			montoGlobalVar = aportacion.montoGlobal;
		} else {
			montoGlobalVar = 0;
		}
	}});
}


function consulta(aportacionID){
	var aportacionBean = {
		'aportacionID':aportacionID
	};

	$('#simulacion').val('N');
	condicionesVencimServicio.consulta(catConVencimConsulta.principal, aportacionBean,{ async: false, callback: function(aportacion){
		if(aportacion!=null){
			$('#condiciones').val(aportacion.condiciones);
			if(aportacion.reinversionAutom === 'S'){
				opcionesReinversion(aportacionBeanVar, '','N');
				muestraSeccionesReinversion();

				$('#montoNuevaAport').val();
				$('#reinversion').val(aportacion.reinversion);
				$('#opcionAport').val(aportacion.opcionAport);
				$('#montoNuevaAport').val(aportacion.montoNuevaAport);
				$('#tasaNetaNuevaAport').val(aportacion.tasaNetaNuevaAport);
				$('#plazoNuevaAport').val(aportacion.plazoOriginalNuevaAport);
				$('#plazoOriginalNuevaAport').val(aportacion.plazoNuevaAport);
				$('#tipoPagoNuevaAport').val(aportacion.tipoPagoNuevaAport);
				$('#montoGlobalNuevaAport').val(aportacion.montoGlobalNuevaAport);
				$('#tasaBrutaNuevaAport').val(aportacion.tasaBrutaNuevaAport);
				$('#gatNominalNuevaAport').val(aportacion.gatNominalNuevaAport);
				$('#gatRealNuevaAport').val(aportacion.gatRealNuevaAport);
				$('#fechaInicioNuevaAport').val(aportacion.fechaInicioNuevaAport);
				$('#fechaVencimNuevaAport').val(aportacion.fechaVencimNuevaAport);
				nuevaTasaFija = aportacion.tasaBrutaNuevaAport;
				tasaCalculada = aportacion.tasaMontoGlobal;

				if(aportacion.tipoPagoNuevaAport === 'E'){
					$('#lblDiaPago').show();
					$('#diaPagoNuevaAport').show();
					$('#diaPagoNuevaAport').val(aportacion.diaPagoNuevaAport);
				}else{
					$('#lblDiaPago').hide();
					$('#diaPagoNuevaAport').hide();
					$('#diaPagoNuevaAport').val('');
				}

				if(aportacion.consolidarSaldos == 'S'){
					$('#consolidarSaldosSi').attr("checked",true).change();
				} else {
					$('#consolidarSaldosNo').attr("checked",true).change();
				}
				if(aportacion.opcionAport == 2){
					mostrarElementoPorClase('consolidarSaldos',true);
				}
				if((aportacion.opcionAport == 2 && aportacion.consolidarSaldos == 'N') || aportacion.opcionAport == 3){
					$('#cantidad').val(aportacion.cantidadReno);
				}

				$('#opcionAport').val(aportacion.opcionAport);
				$('#notasNuevaAport').val(aportacion.notasNuevaAport);
				$('#montoRenovNuevaAport').val(aportacion.montoRenovNuevaAport);
				$('#interesGenNuevaAport').val(aportacion.interesGenNuevaAport);
				$('#isrRetenerNuevaAport').val(aportacion.isrRetenerNuevaAport);
				$('#intRecibirNuevaAport').val(aportacion.intRecibirNuevaAport);
				$('#totRecibirNuevaAport').val(aportacion.totRecibirNuevaAport);
				$('#montoGlobalNuevaAport').val(aportacion.montoGlobalNuevaAport);

				if(aportacion.capitalizaNuevaAport == 'S'){
					$('#capitalizaNuevaAportSi').attr('checked', true);
					$('#capitalizaNuevaAportNo').attr('checked', false);
				}else{
					$('#capitalizaNuevaAportSi').attr('checked', false);
					$('#capitalizaNuevaAportNo').attr('checked', true);
				}

				$('#reinversionAutomSi').attr('checked', true);
				$('#reinversionAutomNo').attr('checked', false);
				$('#autorizar').show();
				agregaFormatoControles('formaGenerica');
				habilitaBoton('autorizar', 'submit');
			}else{
				$('#autorizar').hide();
				ocultaSeccionesNoReinversion();
				$('#reinversionAutomNo').attr('checked', true);
				$('#reinversionAutomSi').attr('checked', false);
			}
		}
	}});

}

function exito(){
}

function funcionExito(){
	deshabilitaBoton('grabar', 'submit');
	inicializaForma('formaGenerica','aportacionID');
	ocultaSeccionesNoReinversion();
	ocultaGirdCons(true);
	mostrarElementoPorClase('cantidadReno',false);
}

function error(){
}
function consolidaExito(){
	agregaFormatoControles('formaGenerica');
}
function consolidaError(){
	agregaFormatoControles('formaGenerica');
}

function limpiaIntereses() {
	$('#interesGenNuevaAport').val('0.00');
	$('#isrRetenerNuevaAport').val('0.00');
	$('#intRecibirNuevaAport').val('0.00');
	$('#totRecibirNuevaAport').val('0.00');
	limpiaSimulador();
}

function consultaAportConsol(){
	var aportConsolID = $('#aportConsolID').val().trim();
	var aportacionID = $('#aportacionID').val();
	var fechaVenc = $('#fechaVencimiento').val();
	setTimeout("$('#cajaLista').hide();", 200);

	if(Number(aportConsolID) > 0){
		if(Number(aportConsolID) != Number(aportacionID)){
			var AportacionBean = {
				'aportacionID'	: aportacionID,
				'clienteID'		: aportConsolID
			};
			aportacionesServicio.consulta(11, AportacionBean, { async: false, callback: function(aportacion){
				if(aportacion!=null){
					if($('#clienteID').asNumber() == Number(aportacion.clienteID)){
						if(aportacion.existe != 'S'){
							if(aportacion.estatus === catEstatusAportacion.vigente){
								if(aportacion.fechaVencimiento === fechaVenc){
									aportConsolida = aportacion;
								} else {
									$('#aportConsolID').focus();
									$('#aportConsolID').val('');
									mensajeSis('La Aportación '+aportConsolID+' No Vence el mismo Día que la Aportación '+aportacionID+'.'+
										'<br>Fecha de Vencimiento: '+aportacion.fechaVencimiento);
									aportConsolida = '';
								}
							} else {
								$('#aportConsolID').focus();
								$('#aportConsolID').val('');
								mensajeSis('La Aportación No se encuentra Vigente.');
								aportConsolida = '';
							}
						} else {
							$('#aportConsolID').focus();
							$('#aportConsolID').val('');
							mensajeSis('La Aportación Pertenece a Otra Consolidación.');
							aportConsolida = '';
						}
					} else {
						$('#aportConsolID').focus();
						$('#aportConsolID').val('');
						mensajeSis('La Aportación No Pertenece al Cliente.');
						aportConsolida = '';
					}
				} else {
					$('#aportConsolID').focus();
					$('#aportConsolID').val('');
					mensajeSis('No existe la Aportación.');
					aportConsolida = '';
				}
			}});
		} else {
			$('#aportConsolID').focus();
			$('#aportConsolID').val('');
			mensajeSis('La Aportación No se Puede Agregar<br>porque es la misma que se esta Condicionando.');
			aportConsolida = '';
		}
	}
}

function consultaGridAport(){
	var aportID = $('#aportacionID').asNumber();
	var aportBean = {
			'tipoLista'		: 1,
			'aportacionID'	: aportID,
	};
	$('#gridConsolidacion').html("");
	$('#gridConsolidacion').hide();
	bloquearPantalla();
	$.post("apConsolidacionesGridVista.htm", aportBean, function(data) {
		if (data.length > 0 ) {
			$('#gridConsolidacion').html(data);
		} else {
			mensajeSis('No hay Aportaciones por Dispersar.');
			mostrarDispersiones(false);
		}
	});
	$('#gridConsolidacion').show();
	desbloquearPantalla();
}


function listaConsolida(controlid){
	var camposLista = new Array();
	var parametrosLista = new Array();
	camposLista[0] = "clienteID";
	parametrosLista[0] = $('#aportacionID').val();
	lista(controlid, 2, 20, camposLista, parametrosLista, 'listaAportaciones.htm');
}

function agregarDetalle(){
	var idTablaParametrizacion = 'tbParametrizacion';
	var aportID = $('#aportacionID').val();
	var aportConsolID = $('#aportConsolID').val();
	habilitaBoton('grabar', 'submit');

	if(validaAportRepetidas(aportConsolID)){
		consultaAportConsol();
		if(Number(aportConsolida.aportacionID) > 0){
			var numTab=$("#numTab").asNumber();
			var numeroFila=numTab;
			numTab++;
			numeroFila++;
			var nuevaFila =
				'<tr id="tr' + numeroFila + '" name="tr"> ' +
					'<td nowrap="nowrap" width="05%"> ' +
						'<input type="text" id="aportID'+ aportConsolida.aportacionID + numeroFila + '" tabindex="' + numeroFila + '" name="aportID" value="'+ aportConsolida.aportacionID + '" readonly="true" style="width:99%;"/> ' +
					'</td> ' +
					'<td nowrap="nowrap" width="10%"> ' +
						'<input type="text" id="fechaVencimiento' + numeroFila + '" name="fechaVencimiento" value="'+ aportConsolida.fechaVencimiento + '" readonly="true" style="width:99%;"/> ' +
					'</td> ' +
					'<td nowrap="nowrap" width="15%"> ' +
						'<input type="text" id="monto' + numeroFila + '" name="monto" size="8" value="'+ aportConsolida.monto + '" maxlength="150" esMoneda="true" style="text-align: right; width:99%;" tabindex="' + numeroFila + '" readonly="true" /> ' +
					'</td> ' +
					'<td nowrap="nowrap" width="10%"> ' +
						'<input type="text" id="interesGenerado' + numeroFila + '" name="interesGenerado" size="8" value="'+ aportConsolida.interesGenerado + '" maxlength="150" esMoneda="true" style="text-align: right; width:99%;" tabindex="' + numeroFila + '" readonly="true" /> ' +
					'</td> ' +
					'<td nowrap="nowrap" width="10%"> ' +
						'<input type="text" id="interesRetener' + numeroFila + '" name="interesRetener" size="8" value="'+ aportConsolida.interesRetener + '" maxlength="150" esMoneda="true" style="text-align: right; width:99%;" tabindex="' + numeroFila + '" readonly="true" /> ' +
					'</td> ' +
					'<td nowrap="nowrap" width="15%"> ' +
						'<input type="text" id="total' + numeroFila + '" name="total" size="8" value="'+ aportConsolida.totalFinal + '" maxlength="150" esMoneda="true" style="text-align: right; width:99%;" tabindex="' + numeroFila + '" readonly="true" /> ' +
					'</td> ' +
					'<td class="label" width="01%"> ' +
					'</td> ' +
					'<td style="text-align: center;" nowrap="nowrap" > ' +
						'<input type="radio" id="reinvertirC' + numeroFila + '" name="reinvertirC' + numeroFila + '" tabindex="' + numeroFila + '" value="C" onclick="cambiaReinvertir(\'totalFinal' + numeroFila + '\',\'C\','+aportConsolida.monto+',0.00);" readonly="true"/> ' +
					'</td> ' +
					'<td style="text-align: center;" nowrap="nowrap" > ' +
						'<input type="radio" id="reinvertirCI' + numeroFila + '" name="reinvertirC' + numeroFila + '" tabindex="' + numeroFila + '" value="CI" onclick="cambiaReinvertir(\'totalFinal' + numeroFila + '\',\'CI\','+aportConsolida.totalFinal+',0.00);" readonly="true"/> ' +
					'</td> ' +
					'<td class="label" width="01%"> ' +
					'</td> ' +
					'<td nowrap="nowrap" width="15%"> ' +
						'<input type="text" id="totalFinal' + numeroFila + '" name="totalFinal" size="8" value="0.00" maxlength="150" esMoneda="true" style="text-align: right; width:99%;" tabindex="' + numeroFila + '" readonly="true" /> ' +
					'</td> ' +
					'<td nowrap="nowrap"> ' +
						'<input type="button" id="eliminar' + numeroFila + '" name="eliminar" value="" class="btnElimina" onclick="eliminarParam(\'tr' + numeroFila + '\')" tabindex="' + numeroFila + '"/> ' +
					'</td> ' +
				'</tr> ';
			$('#'+idTablaParametrizacion).append(nuevaFila);
			$("#numTab").val(numTab);
			$("#numeroFila").val(numeroFila);
			sumaTotalesCons(true);
			aportConsolida = '';
		}
	}
	$('#aportConsolID').val('');
}
function cambiaReinvertir(totalFinalID,reinvertir,montoCap,montoIntRecibir){
	var totalReinvertir = (reinvertir == 'C' ? Number(montoCap) : (Number(montoCap) + Number(montoIntRecibir)));
	$('#'+totalFinalID).val(totalReinvertir);
	sumaTotalesCons(true);
}

/**
 * Remueve de la tabla un tr.
 * @param id : ID del tr.
 * @author avelasco
 */
function eliminarParam(id){
	$('#'+id).remove();
	sumaTotalesCons(true);
}
/**
 * Regresa el número de renglones de un grid.
 * @param idTablaParametrizacion : ID de la tabla a la que se va a contar el número de renglones.
 * @returns Número de renglones de la tabla.
 * @author avelasco
 */
function getRenglones(){
	var numRenglones = $('#tbParametrizacion >tbody >tr[name^="tr"]').length;
	return numRenglones;
}

function sumaTotalesCons(limpiaInt){
	var montoCapital = $('#montoNuevaAport').asNumber(); // Aportación a consolidar.

	var totalCapitalCons = 0.00;
	var totalIntCons = 0.00;
	var totalISRCons = 0.00;
	var totalTotalCons = 0.00;
	var totalTotalRenovCons = 0.00;
	if(getRenglones()>0){
		$('#tbParametrizacion >tbody >tr[name^="tr"]').each(function(index){
			if(index >= 0){
				var montoID = "#"+$(this).find("input[name^='monto']").attr("id");
				var interesGeneradoID="#"+$(this).find("input[name^='interesGenerado']").attr("id");
				var interesRetenerID="#"+$(this).find("input[name^='interesRetener']").attr("id");
				var totalID = "#"+$(this).find("input[name^='total']").attr("id");
				var totalFinalID="#"+$(this).find("input[name^='totalFinal']").attr("id");
				totalCapitalCons = totalCapitalCons + $(montoID).asNumber();
				totalIntCons = totalIntCons + $(interesGeneradoID).asNumber();
				totalISRCons = totalISRCons + $(interesRetenerID).asNumber();
				totalTotalCons = totalTotalCons + $(totalID).asNumber();
				totalTotalRenovCons = totalTotalRenovCons + $(totalFinalID).asNumber();
			}
		});
	}
	/* Se valida si el tipo de aportación permite el cálculo de la tasa por monto global.
	 * Si permite, se obtiene el capital de las aportaciones consolidadas para evitar
	 * que se duplique el capital, puesto que la función del monto global ya considera dicho capital.
	 **/
	montoTotalCapCons = ($('#tasaMontoGlobal').val().trim()==='S' ? totalCapitalCons : 0.00);
	$('#totalCapCons').text(formatoMonedaVariable(totalCapitalCons));
	$('#totalIntCons').text(formatoMonedaVariable(totalIntCons));
	$('#totalISRCons').text(formatoMonedaVariable(totalISRCons));
	$('#totalCons').text(formatoMonedaVariable(totalTotalCons));
	$('#totalRenCons').text(formatoMonedaVariable(totalTotalRenovCons));
	$('#montoRenovNuevaAport').val(montoCapital + totalTotalRenovCons);
	calculaMontoGlobal();
	if(limpiaInt){
		limpiaIntereses();
	}
	agregaFormatoControles('formaGenerica');
}

function llenarDetalle(){
	if(getRenglones()>0){
		quitaFormatoControles('formaGenerica');
		var idDetalle = '#detalle';
		var validar = true;
		var aportacionID = $('#aportacionID').val();
		$(idDetalle).val('');
		$('#tbParametrizacion >tbody >tr[name^="tr"]').each(function(index){
			var numTR = this.id.substring(2);
			if(index >= 0){
				var aportConsID = "#"+$(this).find("input[name^='aportID']").attr("id");
				var fechaVencID = "#"+$(this).find("input[name^='fechaVencimiento']").attr("id");
				var montoID = "#"+$(this).find("input[name^='monto']").attr("id");
				var interesGeneradoID="#"+$(this).find("input[name^='interesGenerado']").attr("id");
				var interesRetenerID="#"+$(this).find("input[name^='interesRetener']").attr("id");
				var totalID = "#"+$(this).find("input[name^='total']").attr("id");
				var reinvID = "#"+$(this).find("input[name^=reinvertirC"+numTR+"]:checked").attr("id");
				var totalFinalID="#"+$(this).find("input[name^='totalFinal']").attr("id");
				$(idDetalle).val( $(idDetalle).val()+'['+
				aportacionID+']'+
				$(aportConsID).val()+']'+
				$(fechaVencID).val()+']'+
				$(montoID).val()+']'+
				$(interesGeneradoID).val()+']'+
				$(interesRetenerID).val()+']'+
				$(totalID).val()+']'+
				$(reinvID).val()+']'+
				$(totalFinalID).val()+']');
			}
		});

		$(idDetalle).val( $(idDetalle).val()+'['+
		aportacionID+']'+
		aportacionID+']'+
		$('#fechaVencimiento').val()+']'+
		$('#capital').val()+']'+
		$('#interes').val()+']'+
		$('#isr').val()+']'+
		($('#capital').asNumber()+$('#interes').asNumber()-$('#isr').asNumber())+']'+
		$('#reinversion').val()+']'+
		$('#montoNuevaAport').val()+']');
		agregaFormatoControles('formaGenerica');
		return true;
	}
	return false;
}

function validarTabla(){
	var validar = true;
	if(getRenglones()>0){
		$('#tbParametrizacion >tbody >tr[name^="tr"]').each(function(index){
			var numTR = this.id.substring(2);
			if(index >= 0){
				var reinvID = "#"+$(this).find("input[name^=reinvertirC"+numTR+"]:checked").attr("id");
				var totalFinalID="#"+$(this).find("input[name^='totalFinal']").attr("id");
				if($(reinvID).val()==='') {
					agregarFormaError(reinvID);
					validar=false;
				}
				if($(totalFinalID).asNumber() == 0) {
					agregarFormaError(totalFinalID);
					validar=false;
				}
			}
		});
	}
	return validar;
}

function grabaDetalles(event){
	if(validarTabla()){
		if(llenarDetalle()){
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','aportConsolID','consolidaExito','consolidaError');
		} else {
			event.preventDefault();
		}
	} else {
		event.preventDefault();
	}
}
function ocultaGirdCons(ocultar){
	var opAportacion = Number($('#opcionAport').val());
	if(ocultar){
		$('#consolidarSaldosNo').attr("checked",true);
		$('#gridConsolidacion').html("");
		$('#gridConsolidacion').hide();
		habilitaControl('cantidad');
		calculaMontoReinv();
	} else {
		if(opAportacion === catTipoRenovacion.renovConMas &&
			$('input[name=consolidarSaldos]:checked').val()==='S'){
			deshabilitaControl('cantidad');
			$('#cantidad').val('');
			consultaGridAport();
		} else {
			$('#consolidarSaldosNo').attr("checked",true);
			$('#gridConsolidacion').html("");
			$('#gridConsolidacion').hide();
			habilitaControl('cantidad');
			calculaMontoReinv();
		}
	}
}

function calculaMontoReinv(){
	var monto = 0;
	var reinversion = $('#reinversion').val();
	var cantidad = $('#cantidad').asNumber();

	if(reinversion === catReinvertir.capital){
		monto = Number(montoSinIntereses);
	}else if(reinversion === catReinvertir.capitalMasIntereses){
		monto = $('#totalFinal').asNumber();
	}
	$('#montoNuevaAport').val(monto);
	$('#montoRenovNuevaAport').val(monto);
	var opAportacion = Number($('#opcionAport').val());
	calculaMontoRenovacion(opAportacion);
	calculaMontoGlobal();
	agregaFormatoControles('formaGenerica');
	limpiaIntereses();
}
function validaAportRepetidas(aportacionID){
	var validar = true;
	if(getRenglones()>0){
		$('#tbParametrizacion >tbody >tr[name^="tr"]').each(function(index){
			var numTR = this.id.substring(2);
			if(index >= 0){
				var aportID="#"+$(this).find("input[name^='aportID']").attr("id");
				if($(aportID).asNumber() === Number(aportacionID)) {
					mensajeSis('La Aportación '+aportacionID+' ya Se Encuentra en la Consolidación.');
					validar=false;
				}
			}
		});
	}
	return validar;
}