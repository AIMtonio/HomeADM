var esTab = true;
var contadorCte = "";
var esAnclaje	='N';
var generarFormatoAnexo=true;
var productoInvercamex=99999;
var parametroBean = consultaParametrosSession();
var maxPuntos=0;
var minPuntos=0;
var perfilUsuario=parametroBean.perfilUsuario;
var perfilAutEspAport=0;
var numComentarios=0;
var espTasa=false;
var calificacionCli = "";
var tasafijaOrig=0;
var aperturaAport='FA'; //FA: Fecha Actual

var catTipoTransaccion = {
	'autoriza':3
};

var catTipoConsulta = {
		'principal':1
	};

var catTipoLista ={
		'principal' : 1
};

var catTipoListaCambioTasa = {
		'principal': 16
};

var catStatusAportacion = {
		'alta':'INACTIVA',
		'vigente':'VIGENTE',
		'pagada' :'PAGADA',
		'cancelada':'CANCELADA',
		'vencida':'VENCIDA'
};

var catStatusPagare = {
		'impreso':'I'
};

$(document).ready(function() {
	$('#lblfechaApertura').hide();
	$('#fechaApertura').hide();
	$('#reinvertirVenSi').attr('checked',false);
	$('#reinvertirVenNo').attr('checked',false);
	$('#reinvertirVenSi').hide();
	$('#reinvertirVenNo').hide();
	$('#contenedorSim').hide();
	$('#contenedorSimulador').hide();
	$(':text').focus(function() {
	 	esTab = false;
	});
	$('#aportacionID').focus();

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	parametroBean = consultaParametrosSession();
	deshabilitaBoton('autoriza', 'submit');
	deshabilitaBoton('imprime', 'submit');
	$('#tdCajaRetiro').hide();
	agregaFormatoControles('formaGenerica');
	mostrarTasaVar();


	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','aportacionID', 'funcionExito', 'funcionFallo');
			}
	});

	$('#aportacionID').bind('keyup',function(e){
		 var camposLista = new Array();
		 var parametrosLista = new Array();
		 camposLista[0] = "nombreCliente";
		 parametrosLista[0] = $('#aportacionID').val();
		lista('aportacionID', 2, catTipoLista.principal, camposLista, parametrosLista, 'listaAportaciones.htm');
	});

	ocultaTasaVar();

	$('#aportacionID').blur(function(){
		if(esTab == true & !isNaN($('#aportacionID').val())){
			validaAportacion(this.id);
		}
	});

	$('#autoriza').click(function() {

		if(esAnclaje == 'N'){
			$('#tipoTransaccion').val(catTipoTransaccion.autoriza);
			if(aperturaAport != 'FP'){
				if(espTasa){
					var tasaMax=parseFloat(tasafijaOrig)+Number(maxPuntos);
					var tasaMin=parseFloat(tasafijaOrig)-Number(minPuntos);
					if($('#tasaFija').asNumber() > parseFloat(Number(tasaMax).toFixed(2)) ||
					   $('#tasaFija').asNumber() < parseFloat(Number(tasaMin).toFixed(2))){
						if(parseInt(perfilUsuario) != parseInt(perfilAutEspAport)){
							mensajeSis("La Aportación excede los límites de especificación de Tasa permitidos, requiere autorización especial.");
							return false;
						}
					}
				}
			}else{
				if(parseInt(perfilUsuario) != parseInt(perfilAutEspAport)){
					mensajeSis("La Aportación requiere autorización especial.");
					return false;
				}
			}
		}
		else{
			$('#tipoTransaccion').val('7');
		}
	});

	$('#fecha').html(parametroBean.fechaSucursal);


	$('#imprime').click(function() {
		deshabilitaBoton('imprime', 'submit');

		var aportacionID		= $('#aportacionID').val();
		var monedaID			= $('#monedaID').val();
		var nombreInstitucion	= parametroBean.nombreInstitucion;
		var monto				= ($('#montoAnclar').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2 })).asNumber();
		var dirInst				= parametroBean.direccionInstitucion;
		var usuario				= parametroBean.nombreUsuario;
		var sucursalID			= parametroBean.sucursal;
		var nombreSucursal		= parametroBean.nombreSucursal;
		var nombreCliente		= $('#nombreCompleto').val();
		var cuentaAhoID			= $('#cuentaAhoID').val();
		var descTipoAportacion	= $('#descripcion').val();
		var plazo				= $('#plazo').val();
		var calculoInteres		= $('#desCalculoInteres').val();
		var tasaBase			= $('#tasaBase').val();
		var tasaISR				= $('#tasaISR').val();
		var totalRecibir		= $('#monto').val();
		var fechaVencimiento	= $('#fechaVencimiento').val();
		var fechaApertura		= $('#fechaInicio').val();
		var sobreTasa			= $('#sobreTasa').val();
		var pisoTasa			= $('#pisoTasa').val();
		var techoTasa			= $('#techoTasa').val();
		var tasaNeta			= $('#tasaNeta').val();
		var tasaFija			= $('#tasaFija').val();
		var interesRecibir		= $('#interesRecibir').val();
		var totalRec			= $('#monto').asNumber();
		var nombreCaja			= $('#cajaRetiro').val()+" "+$('#nombreCaja').val();
		var tipoProducto		= "Aportacion";

		var pagina = '';
		if($('#tipoTasa').val() == 'V'){
			pagina = 'pagareVarAportRep.htm?';
		} else {
			pagina = 'pagareFijoAportRep.htm?';
		}

		pagina = pagina +
			'aportacionID='			+ aportacionID +
			'&monedaID='			+ monedaID +
			'&nombreInstitucion='	+ nombreInstitucion +
			'&monto='				+ monto +
			'&direccionInstit='		+ dirInst +
			'&nombreUsuario='		+ usuario +
			'&sucursalID='			+ sucursalID +
			'&nombreSucursal='		+ nombreSucursal +
			'&nombreCompleto='		+ nombreCliente +
			'&cuentaAhoID='			+ cuentaAhoID +
			'&descripcion='			+ descTipoAportacion +
			'&plazo='				+ plazo +
			'&calculoInteres='		+ calculoInteres +
			'&tasaBase='			+ tasaBase +
			'&tasaISR='				+ tasaISR +
			'&totalRecibir='		+ totalRecibir +
			'&fechaVencimiento='	+ fechaVencimiento +
			'&fechaApertura='		+ fechaApertura +
			'&sobreTasa='			+ sobreTasa +
			'&pisoTasa='			+ pisoTasa +
			'&techoTasa='			+ techoTasa +
			'&valorGat='			+ $('#valorGat').val() +
			'&tasaNeta='			+ tasaNeta +
			'&tasaFija='			+ tasaFija +
			'&interesRecibir='		+ interesRecibir +
			'&total='				+ totalRec;

		window.open(pagina,'_blank');
		$('#aportacionID').focus();

		generarReciboMexi(aportacionID);
	});

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			aportacionID:{
				required: true,
			},
			cuentaAhoID:{
				required: true,
			},
			tipoAportacionID:{
				required:true,
			},
			monto:{
				required: true,
			},
			plazo:{
				required: true,
			},
			fechaVencimiento:{
				required: true,
			},
			cajaRetiro: {
				required: function() {
				return generarFormatoAnexo;
				}
			}
		},
		messages: {
			aportacionID:{
				required:'Especifique Número de Aportación.',
			},
			cuentaAhoID:{
				required:'Especifique la Cuenta.',
			},
			tipoAportacionID:{
				required:'Especifique el Tipo de Aportación.',
			},
			monto:{
				required:'Especifique el Monto.',
			},
			plazo:{
				required:'Especifique el Plazo.',
			},
			fechaVencimiento:{
				required:'Especifique la Fecha de Vencimiento.',
		},
		cajaRetiro: 'Especifique la Caja de Retiro.'
		}
	});


});

function seleccionaEstatus(estatus){
	if(estatus == 'N'){
		$('#estatus').val('VIGENTE');
	}
	if(estatus == 'P'){
		$('#estatus').val('PAGADA');
	}
	if(estatus == 'C'){
		$('#estatus').val('CANCELADA');
	}
	if(estatus == 'I'){
		$('#estatus').val('INACTIVA');
	}
	if(estatus == 'A'){
		$('#estatus').val('REGISTRADA');
	}
	if(estatus == 'L'){
		$('#estatus').val('AUTORIZADA');
	}
}


	function validaAportacion(idControl){
		var jqAportacion = eval("'#" + idControl + "'");
		var numAportacion = $(jqAportacion).val();
		var aportaBean = {
			'aportacionID' : numAportacion
		};
		if(numAportacion != 0 && numAportacion != '' && !isNaN(numAportacion) && esTab){
			aportacionesServicio.consulta(catTipoConsulta.principal, aportaBean, function(aportBean){
				if(aportBean!=null){
					estatus = aportBean.estatus;
					seleccionaEstatus(aportBean.estatus);
					var varError = 1;
					if(aportBean.aportacionMadreID > 0){
						esAnclaje ='S';
					}else{
						esAnclaje='N';
					}

					$('#clienteID').val(aportBean.clienteID);
					aperturaAport=aportBean.aperturaAport;

					$('#cuentaAhoID').val(aportBean.cuentaAhoID);
					$('#tipoAportacionID').val(aportBean.tipoAportacionID);
					$('#tipoPagoInt').val(aportBean.tipoPagoInt);

					$('#monto').val(aportBean.monto);
					$('#plazo').val(aportBean.plazo);
					$('#plazoOriginal').val(aportBean.plazoOriginal);
					$('#fechaInicio').val(aportBean.fechaInicio);
					$('#fechaVencimiento').val(aportBean.fechaVencimiento);

					$('#tasaFija').val(aportBean.tasaFija);
					$('#tasaISR').val(aportBean.tasaISR);
					$('#tasaNeta').val(aportBean.tasaNeta);
					$('#valorGat').val(aportBean.valorGat);

					$('#interesGenerado').val(aportBean.interesGenerado);
					$('#interesRetener').val(aportBean.interesRetener);
					$('#interesRecibir').val(aportBean.interesRecibir);
					$('#valorGatReal').val(aportBean.valorGatReal);
					$('#totalRecibir').val(aportBean.totalRecibir);
					$('#cajaRetiro').val(aportBean.cajaRetiro);
					mostrarElementoPorClase('trMontoGlobal',aportBean.tasaMontoGlobal);
					$('#montoGlobal').val(aportBean.montoGlobal);
					agregaFormatoControles('formaGenerica');
					consultaCliente(aportBean.clienteID);
					consultaDireccion(aportBean.clienteID);
					consultaCtaCliente(aportBean.cuentaAhoID);
					consultaSucursalCAJA();
					evaluaReinversion(aportBean.reinversion,aportBean.reinvertir);
					$('#sobreTasa').val(aportBean.sobreTasa);
					$('#pisoTasa').val(aportBean.pisoTasa);
					$('#techoTasa').val(aportBean.techoTasa);
					if(aportBean.fechaApertura != '1900-01-01'){
						$('#lblfechaApertura').show();
						$('#fechaApertura').show();
						$('#fechaApertura').val(aportBean.fechaApertura);
					}else{
						$('#lblfechaApertura').hide();
						$('#fechaApertura').hide();
						$('#fechaApertura').val('1900-01-01');
					}

					if(estatus == 'C'){
						mensajeSis("La Aportación se encuentra Cancelada.");
					}
					if(estatus == 'N'){
						mensajeSis("La Aportación se encuentra Autorizada.");
					}
					if(estatus == 'P'){
						mensajeSis("La Aportación se encuentra Pagada (Abonada a Cuenta).");
					}
					if(estatus == 'V'){
						mensajeSis("La Aportación se encuentra Vencida.");
					}

					maxPuntos=aportBean.maxPuntos;
					minPuntos=aportBean.minPuntos;
					perfilAutEspAport=aportBean.perfilAutoriza;
					numComentarios=parseInt(aportBean.comentarios);

					// Si existen comentarios de la aportación los carga en el campo
					if(numComentarios > 0){
						$('#comentAport').val('');
						aportacionesServicio.lista(catTipoListaCambioTasa.principal,aportaBean,function(comentarios){
							if(comentarios != null){
								comentarios.forEach(function(coment) {
									var aux=$('#comentAport').val();
									$('#comentAport').val(aux +""+ coment.desComentarios.toString()+"\n");
								});
								$('#tablaComentario').show();
							}else {
								$('#tablaComentario').hide();
								$('#comentAport').val('');
							}
						});
					}else {
						$('#tablaComentario').hide();
						$('#comentAport').val('');
					}

					//llamada a función para cargar los campos de especificacion.
					cargaCamposEspecifica (aportBean.tipoPagoInt,
											aportBean.diasPagoInt,
											aportBean.capitaliza,
											aportBean.reinversion,
											aportBean.notas);
					consultaSimulador();

					if(estatus == 'A'){
						if(aportBean.fechaInicio != parametroBean.fechaSucursal && aportBean.aperturaAport == 'FA'){
							mensajeSis("La Aportación no es del día de hoy.");
						}else{
							varError = 0;
							habilitaBoton('autoriza', 'submit');
							deshabilitaBoton('imprime', 'submit');
							$('#autoriza').focus();
						}
					}
					if (varError > 0){
						$(jqAportacion).focus();
						$(jqAportacion).select();
					}

				}else{
					mensajeSis('La Aportación no Existe.');
					inicializaForma('formaGenerica','aportacionID');
					$(jqAportacion).focus();
					$(jqAportacion).select();
					$('#contenedorSimulador').html("");
					$('#contenedorSim').hide();
					$('#contenedorSimulador').hide();
				}

			});
		}else{
			mensajeSis('La Aportación no Existe.');
			inicializaForma('formaGenerica','aportacionID');
			$(jqAportacion).focus();
			$(jqAportacion).select();
			$('#contenedorSimulador').html("");
			$('#contenedorSim').hide();
			$('#contenedorSimulador').hide();
		}
	}

	function consultaFechaApertura(idControl){
		var jqAportacion = eval("'#" + idControl + "'");
		var numAportacion = $(jqAportacion).val();
		var aportaBean = {
			'aportacionID' : numAportacion
		};
		if(numAportacion != 0 && numAportacion != ''){
				aportacionesServicio.consulta(catTipoConsulta.principal, aportaBean, function(aportBean){
					if(aportBean!=null){
						if(aportBean.fechaApertura != '1900-01-01'){
							$('#fechaApertura').val(aportBean.fechaApertura);
							$('#lblfechaApertura').show();
							$('#fechaApertura').show();
							$('#fechaApertura').show();
						}else{
							$('#lblfechaApertura').hide();
							$('#fechaApertura').hide();
						}
					}
				});
			}
		}

	function consultaCliente(numCliente) {
		var conCliente = 1;
		var rfc = '';
		if(numCliente!='0'){
			setTimeout("$('#cajaLista').hide();", 200);
			if(numCliente != '' && !isNaN(numCliente)){

				clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
							if(cliente!=null){
								$('#nombreCompleto').val(cliente.nombreCompleto);
								$('#telefono').val(cliente.telefonoCasa);
								$('#telefono').setMask('phone-us');
								if(estatus != 'N'){
									consultaDatosAdicionales(cliente.numero);
								}
								calificacionCli = cliente.calificaCredito;
								CalculaValorTasa('monto', false);
							}
					});
				}
		}
	}

	function consultaDireccion(numCliente) {
		var conOficial = 3;
		var direccionCliente = {
  			'clienteID':numCliente
		};
		setTimeout("$('#cajaLista').hide();", 200);
			if(numCliente != '' && !isNaN(numCliente)){
				direccionesClienteServicio.consulta(conOficial,direccionCliente,function(direccion) {
						if(direccion!=null){
							$('#direccion').val(direccion.direccionCompleta);
						}
				});
			}
	}

	function consultaCtaCliente(cuentaID) {
        var numCta = cuentaID;
        var conSaldo =  5;
        var CuentaAhoBeanCon = {
        		'cuentaAhoID':numCta,
        		'clienteID':$('#clienteID').val()
        };
        setTimeout("$('#cajaLista').hide();", 200);

        if(numCta != '' && !isNaN(numCta)){
	          cuentasAhoServicio.consultaCuentasAho(conSaldo,CuentaAhoBeanCon,function(cuenta) {
	          	if(cuenta!=null){
					$('#saldoCuenta').val(cuenta.saldoDispon);
	              	$('#saldoCuenta').formatCurrency({colorize: true, positiveFormat: '%n', roundToDecimalPlace: -1});
	              	$('#tipoMoneda').html(cuenta.descripcionMoneda);
	              	$('#monedaID').val(cuenta.monedaID);
					$('#tipoMonedaInv').html(cuenta.descripcionMoneda);
					ponerFormatoMoneda();
	              	consultaTipoAportacion();
	          	}else{
	          		mensajeSis("No Existe la Cuenta de Ahorro.");
	          	}
	  			});
        }
	}

	function consultaTipoAportacion(){
		var tipoAportacion = $('#tipoAportacionID').val();
		var conPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);

		var tipoAportacionBean = {
                'tipoAportacionID':tipoAportacion,
        };
			if(tipoAportacionBean != 0){
				tiposAportacionesServicio.consulta(conPrincipal, tipoAportacionBean, function(tipoAportacion){
					if(tipoAportacion!=null){
						$('#descripcion').val(tipoAportacion.descripcion);
						$('#tipoTasa').val(tipoAportacion.tasaFV);
						if($('#tipoTasa').val() == 'F'){
							ocultaTasaVar();
						} else if($('#tipoTasa').val() == 'V'){
							mostrarTasaVar();
							monto = $('#monto').asNumber();
							plazo = $('#plazo').asNumber();
							obtieneTasaVariable(tipoAportacion.tipoAportacionID,monto,plazo);
						}
						if (tipoAportacion.especificaTasa=='S') {
							espTasa=true;
						}else {
							espTasa=false;
						}
					}
				});
			}
		}

	function evaluaReinversion(reinversion, tipoReinversion){

	}

	function obtieneTasaVariable(tipoAportacion, monto,plazo){
		var conTasaVariable = 3;
		var TasasAportacionesBean ={
			'tipoAportacionID' :tipoAportacion,
			'monto':monto,
			'plazo': plazo
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(tipoAportacion != '' && !isNaN(tipoAportacion)){
			if(tipoAportacion != 0){
				tasasAportacionesServicio.consulta(conTasaVariable,TasasAportacionesBean, function(tasasAportacionesBean){
					if(tasasAportacionesBean!=null){
						$('#tasaBase').val(tasasAportacionesBean.nombreTasaBase);
						switch(parseInt(tasasAportacionesBean.calculoInteres)){
							case(1):
									$('#desCalculoInteres').val('TASA APERTURA + PUNTOS');
								break;
							case(2):
								$('#desCalculoInteres').val('TASA DE INICIO DE MES + PUNTOS');
								break;
							case(3):
									$('#desCalculoInteres').val('TASA APERTURA + PUNTOS');
								break;
							case(4):
								$('#desCalculoInteres').val('TASA PROMEDIO DEL MES + PUNTOS');
								break;
							case(5):
								$('#desCalculoInteres').val('TASA INICIO DE MES + PUNTOS CON PISO Y TECHO');
								break;
							case(6):
								$('#desCalculoInteres').val('TASA APERTURA + PUNTOS CON PISO Y TECHO');
								break;
							case(7):
								$('#desCalculoInteres').val('TASA PROMEDIO DE MES + PUNTOS CON PISO Y TECHO');
							break;
						}

					}
				});
			}
		}
	}

	function ponerFormatoMoneda(){
		$('#monto').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#tasaNeta').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2	});
		$('#interesGenerado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#interesRetener').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#interesRecibir').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#totalRecibir').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	}

	function ocultaTasaVar(){
		$('#tdlblCalculoInteres').hide();
		$('#tdcalculoInteres').hide();
		$('#tdlblTasaBaseID').hide();
		$('#tdDesTasaBaseID').hide();
		$('#trVariable1').hide();
	}

	function mostrarTasaVar(){
		$('#tdlblCalculoInteres').show();
		$('#tdcalculoInteres').show();
		$('#tdlblTasaBaseID').show();
		$('#tdDesTasaBaseID').show();
		$('#trVariable1').show();
	}

function funcionExito(){
	deshabilitaBoton('autoriza', 'submit');
	habilitaBoton('imprime', 'boton');
}
function funcionFallo(){
    deshabilitaBoton('imprime', 'submit');
    deshabilitaBoton('autoriza', 'submit');
}

function consultaDatosAdicionales(numeroCli){
	var tipoCon = 25;
	var totalInv="";
	var totalAportacion="";

	/*Se consulta el total de cuentas del cliente */
	var CuentaAhoBeanCon = {
			'clienteID': numeroCli
			};

	cuentasAhoServicio.consultaCuentasAho(tipoCon,CuentaAhoBeanCon, { async: false, callback: function(cuenta) {
		if (cuenta != null) {

			if(cuenta.numCuentas != "0"){
				contadorCte = parseInt(cuenta.numCuentas);
			}else{
				contadorCte = 0;
			}
		}
	  }
	});

	/*Se consulta el total de Inversiones del cliente */
	var InversionBean = {
			'clienteID': numeroCli
			};

	inversionServicioScript.consulta(5,InversionBean, { async: false, callback: function(inversion) {
		if (inversion != null) {

			if(inversion.numInversiones != "0"){
				totalInv = parseInt(inversion.numInversiones);
			}else{
				totalInv = 0;
			}
			contadorCte = contadorCte + totalInv ;
		}
	  }
	});


	/*Se consulta el total de Aportaciones del cliente */
	var AportacionBean = {
			'clienteID': numeroCli
			};

	aportacionesServicio.consulta(3,AportacionBean, { async: false, callback: function(aportacion) {
		if (aportacion != null) {

			if(aportacion.numAportaciones != "0"){
			totalAportacion = parseInt(aportacion.numAportaciones);
			}else{
			totalAportacion = 0;
			}
			contadorCte = contadorCte + totalAportacion ;
		}
	  }
	});
}



function consultaSucursalCAJA() {
	if(!ocultarCajaRetiro()){
		var numSucursal = $('#cajaRetiro').val();
		var tipoConsulta = 8;
		setTimeout("$('#cajaLista').hide();", 200);
		if (generarFormatoAnexo=1 && numSucursal != '' && !isNaN(numSucursal)) {
			sucursalesServicio.consultaSucursal(tipoConsulta,numSucursal, function(sucursal) {
				if (sucursal != null) {
					$('#nombreCaja').val(sucursal.nombreSucurs);
					$('#cajaRetiro').val(numSucursal);

				} else {
					mensajeSis("La Sucursal No Cuenta con Ventanillas para el Retiro.");
					$('#nombreCaja').val('');
					$('#cajaRetiro').val('');
					$('#cajaRetiro').focus();
				}
			});
		}
	}
}

function ocultarCajaRetiro(){
	$('#tdCajaRetiro').hide();
	$('#nombreCaja').val('');
	$('#cajaRetiro').val('0');
	generarFormatoAnexo = false;
	return true;
}

function cargaCamposEspecifica (tipoPago, diaPago, capitaliza, tipoReinversion, notas) {

	// Carga el valor en el combo tipo de pago de interés
	var tipoPagoDescrip='';
	dwr.util.removeAllOptions('tipoPagoInt');
	switch (tipoPago) {
	case "V": // VENCIMIENTO
		tipoPagoDescrip = 'AL VENCIMIENTO';
		break;
	case "F": // FIN DE MES
		tipoPagoDescrip = 'FIN DE MES';
		break;
	case "P":// PERIODO
		tipoPagoDescrip = 'POR PERIODO';
		break;
	case "E":// PROGRAMADO
		tipoPagoDescrip = 'PROGRAMADO';
		break;
	default:
		tipoPagoDescrip = '';
	}

	$('#tipoPagoInt').append($('<option>', {
		    value: tipoPago,
		    text: tipoPagoDescrip
	}));
	deshabilitaControl('tipoPagoInt');

	dwr.util.removeAllOptions('diasPagoInt');
	if (parseInt(diaPago) > 0) {
		// Carga valor en el combo día de pago
		$('#diasPagoInt').append($('<option>', {
			    value: diaPago,
			    text: diaPago
		}));
		$('#diasPagoInt').show();
		$('#lbldiasPago').show();
	}else {
		// Carga valor en el combo día de pago
		$('#diasPagoInt').append($('<option>', {
			    value: 0,
			    text: 0
		}));
		$('#diasPagoInt').hide();
		$('#lbldiasPago').hide();
	}
	deshabilitaControl('diasPagoInt');

	// Carga valor en el combo capitaliza interés
	dwr.util.removeAllOptions('capitaliza');
	if (capitaliza == "S") {
		dwr.util.addOptions( "capitaliza", {'S':'SI'});
	}else {
		dwr.util.addOptions( "capitaliza", {'N':'NO'});
	}
	deshabilitaControl('capitaliza');

	// Marca el radio tipo de reinversión
	if (tipoReinversion == 'F') {
		$('#reinvertirPost').attr('checked', true);
		$('#reinvPost').text('Posteriormente');
		$('#reinvertirPost').val('F');
	}else if (tipoReinversion == 'S') {
		$('#reinvertirPost').attr('checked', true);
		$('#reinvPost').text('Reinversión Automática');
		$('#reinvertirPost').val('S');
	}else if(tipoReinversion == 'N') {
		$('#reinvertirPost').attr('checked', true);
		$('#reinvPost').text('No Realiza Reinversión');
		$('#reinvertirPost').val('N');
	}else{
		$('#reinvertirPost').attr('checked', false);
		$('#reinvPost').text('Posteriormente');
		$('#reinvertirPost').val('F');
	}
	deshabilitaControl('reinvertirPost');

	// Carga contenido el el campo notas
	$('#notas').val(notas);
	deshabilitaControl('notas');

}

// Carga Grid, funcion para consultar el calendario de pagos de Aportación */
	function consultaSimulador(){
		if(validaSimulador() == 0){
			var params = {};
			params['tipoLista']		= 2;
			params['fechaInicio']	= $('#fechaInicio').val();
			params['fechaVencimiento'] = $('#fechaVencimiento').val();
			params['monto']			= $('#monto').asNumber();
			params['clienteID']		= $('#clienteID').val();
			params['tipoAportacionID']	= $('#tipoAportacionID').val();
			params['tasaFija']		= $('#tasaFija').val();
			params['tipoPagoInt']	= $('#tipoPagoInt').val();
			params['diasPeriodo']	= $('#diasPeriodo').val();
			params['pagoIntCal']	= $('#pagoIntCal').val();
			params['diasPagoInt']	= $('#diasPagoInt').val();
			params['plazoOriginal']	= $('#plazoOriginal').val();
			params['capitaliza']	= ($('#tipoPagoInt').val()=="E")?$('#capitaliza').val():'';
			params['aportacionID']	= $('#aportacionID').val();

			$.post("simuladorPagosAportaciones.htm", params, function(simular){
				if(simular.length >0) {
					$('#contenedorSimulador').show();
					$('#contenedorSim').show();
					$('#contenedorSimulador').html(simular);
					// SE ACTUALIZAN LOS VALORES EN PANTALLA
					var varTotalFinal = $('#varTotalFinal').text();
					var varTotalInteres = $('#varTotalInteres').text();
					var varTotalISR = $('#varTotalISR').text();
					var varTotalCapital = $('#varTotalCapital').text();
					var varTotalInteresRecibir = Number(varTotalInteres) - Number(varTotalISR);
					$("#granTotal").val(formatoMonedaVariable(varTotalFinal,false));
					$("#interesGenerado").val(formatoMonedaVariable(varTotalInteres,false));
					$("#interesRetener").val(formatoMonedaVariable(varTotalISR,false));
					$("#interesRecibir").val(formatoMonedaVariable(varTotalInteresRecibir,false));
					// TOTALES DEL SIMULADOR
					$("#varSaldoCapital").text(formatoMonedaVariable(varTotalCapital,true));
					$("#varTotalCapital").text(formatoMonedaVariable(varTotalCapital,true));
					$("#varTotalInteres").text(formatoMonedaVariable(varTotalInteres,true));
					$("#varTotalISR").text(formatoMonedaVariable(varTotalISR,true));
					$("#varTotalFinal").text(formatoMonedaVariable(varTotalFinal,true));

					agregaFormatoControles('formaGenerica');
				}else{
					$('#contenedorSimulador').html("");
					$('#contenedorSim').hide();
					$('#contenedorSimulador').hide();
				}
			});
		}
	}

function validaSimulador(){
		if($('#tipoPagoInt').val() != 'V' &&  $('#tipoPagoInt').val() != 'F' &&  $('#tipoPagoInt').val() != 'P' && $('#tipoPagoInt').val() != 'E'){
			mensajeSis('Indique el Tipo de Pago.');
			$('#tipoPagoInt').focus();
			return 1;
		}
		if($('#monto').asNumber() <= 0){
			mensajeSis('Indique un Monto Mayor a 0.');
			$('#monto').focus();
			return 1;
		}
		if($('#plazoOriginal').asNumber() <= 0 && $('#tipoPagoInt').val() != 'E'){
			mensajeSis('Indique un Plazo Mayor a 0.');
			$('#plazoOriginal').focus();
			return 1;
		}
		return 0;
	}


function CalculaValorTasa(idControl, consultaAportaciones){
		var jqControl = eval("'#" + idControl + "'");
		var tipoCon = 2;

			var variables = creaBeanTasaAportacion();
			tasasAportacionesServicio.consulta(tipoCon,variables, { async: false, callback: function(porcentaje){
				if(porcentaje.tasaAnualizada !=0 && porcentaje.tasaAnualizada != null){
					tasafijaOrig=porcentaje.tasaAnualizada;
				}else{
					mensajeSis("No existe una Tasa Anualizada.");
				}
			}});
}


function creaBeanTasaAportacion(){
		var tasasAportacionBean = {
				'tipoAportacionID': $('#tipoAportacionID').val(),
				'plazo' 		  : $('#plazoOriginal').val(),
				'monto' 		  : ($('#montoGlobal').asNumber()>0?$('#montoGlobal').asNumber():$('#monto').asNumber()),
				'calificacion' 	  : calificacionCli ,
				'sucursalID'  	  : parametroBean.sucursal
		};
		return tasasAportacionBean;
}