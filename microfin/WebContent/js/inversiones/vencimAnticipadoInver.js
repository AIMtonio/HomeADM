var funcionHuella = 'N';
var autorizaHuellaCliente = 'N';
var huellaCliente = 'N';

listaPersBloqBean = {
		'estaBloqueado'	:'N',
		'coincidencia'	:0
};

consultaSPL = {
		'opeInusualID' : 0,
		'numRegistro' : 0,
		'permiteOperacion' : 'S',
		'fechaDeteccion' : '1900-01-01'
};

var esCliente 			='CTE';

$(document).ready(function() {
	esTab = true;
	$('#statusSrvHuella').hide();

	var serverHuella = new HuellaServer({
		fnHuellaValida:	function(datos){
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','inversionID','funcionExitoVencimAnt','funcionFalloVencimAnt');
		},
		fnHuellaInvalida: function(datos){
			mensajeSis("La huella del cliente/firmante no corresponde con el registro en el sistema.");
			deshabilitaBoton("grabar");
			return false;
		}
	});

	validaAutorizacionHuellaCliente();
	var parametroBean = consultaParametrosSession();
	var funcionHuella = parametroBean.funcionHuella;
	$('#fecha').html(parametroBean.fechaSucursal);
	deshabilitaBoton('cancela', 'submit');
	agregaFormatoControles('formaGenerica');

	$.validator.setDefaults({
		submitHandler: function(event) {
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','inversionID','funcionExitoVencimAnt','funcionFalloVencimAnt');
		}
	});

	if(funcionHuella == 'S' && autorizaHuellaCliente == 'S'){
		$('#statusSrvHuella').show();
	}

	$(':text').focus(function() {
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	var catHuellaDigital = {
		'noHuellas' : 4
	};

	var catTipoConsultaCuenta = {
			'conSaldo': 5
	};

	var catTipoConsultaInversion = {
			'principal' : 1,
			'vencim_Anticipada' : 3
	};

	var catTipoConsultaTipoInversion = {
			'principal' : 1,
			'vencim_Anticipada' : 3
	};
	var catTipoTransaccionInsersion = {
		'agrega'	:1,
		'cancela' :2,
		'vencim_Anticipado':8
	};
	var catTipoConsultaCliente = {
		'paraInversiones': 6
	};
	var catTipoListaInversion = {
		'principal' : 1,
		'paraCancelacion': 3,
		'vencimientoAnt': 6
	};
	var catStatusInversion = {
	  		'alta':		'A',
	  		'cargada': 	'N',
	  		'pagada': 	'P',
			'cancelada':'C'
	};

	$('#inversionID').focus();

	$('#cancela').click(function() {
		if(validaCreditosInversionesEnGarantia()){
			$('#tipoTransaccion').val(catTipoTransaccionInsersion.vencim_Anticipado);
			if(funcionHuella == 'S' && autorizaHuellaCliente == 'S'){
				consultaHuellaCliente();
				if(huellaCliente == 'S'){
					serverHuella.muestraFirmaAutorizacion();
					return false;
				}
			}
		}else{
			return false;
		}
	});

	$('#tipoInversionID').blur(function(){
		consultaTipoInversion()(this.id);
	});

	$('#inversionID').blur(function(){
		validaInversion(this.id);
	});


	$('#inversionID').bind('keyup',function(e){
		if(this.value.length >= 3){

			var camposLista = new Array();
			 var parametrosLista = new Array();
			 camposLista[0] = "nombreCliente";
			 camposLista[1] = "estatus";
			 parametrosLista[0] = $('#inversionID').val();
			 parametrosLista[1] = catStatusInversion.cargada;

			lista('inversionID', 2, catTipoListaInversion.vencimientoAnt, camposLista,
					 parametrosLista, 'listaInversiones.htm');
		}
	});


	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			clienteID: {
				required: true
			},
			cuentaAhoID: {
				required: true
			},
			tipoInversionID: {
				required: true
			},
			monto: {
				required: true
			},
			plazo: {
				required: true
			},
			fechaVencimiento: {
				required: true
			},
			fechaInicio: {
				required: true
			},
			usuarioAutorizaID: {
				required: true
			},
			contraseniaUsuarioAutoriza:{
				required: true
			}
		},
		messages: {
			clienteID: {
				required: 'Especifique número de cliente'
			},
			cuentaAhoID: {
				required: 'Especifique la cuenta del cliente'
			},
			tipoInversionID: {
				required: 'Especifique el tipo de Inversión'
			},
			monto: {
				required: 'Especificar el Usuario'
			},
			plazo: {
				required: 'Indicar el plazo de la Inversión'
			},
			fechaVencimiento: {
				required: 'Indicar fecha de vencimiento'
			},
			fechaInicio: {
				required: 'Indicar fecha de inicio'
			},
			usuarioAutorizaID: {
				required: 'Especificar el Usuario'
			},
			contraseniaUsuarioAutoriza: {
				required: 'Especificar el password'
			}
		}
	});

	function validaInversion(idControl){
		var jqInversion = eval("'#" + idControl + "'");
		var numInversion = $(jqInversion).val();
		var InversionBean = {
			'inversionID' : numInversion
		};
		deshabilitaBoton('cancela', 'submit');

		if(numInversion != 0 && numInversion != '' && !isNaN(numInversion)){
			if(esTab){
				inicializaForma('formaGenerica','inversionID');
				inversionServicioScript.consulta(catTipoConsultaInversion.vencim_Anticipada, InversionBean,
															 function(inversionCon){
				if(inversionCon!=null){
					listaPersBloqBean = consultaListaPersBloq(inversionCon.clienteID, esCliente, 0, 0);
					consultaSPL = consultaPermiteOperaSPL(inversionCon.clienteID,'LPB',esCliente);
					if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
						validaInversionEnGarantia(numInversion);
						var estatus = inversionCon.estatus;
						var varError = 1;
						dwr.util.setValues(inversionCon);
						if(estatus == catStatusInversion.cancelada){
							mensajeSis("La inversión se encuentra Cancelada");
							validaEstatus('estatus');
							consultaCliente('clienteID');
							consultaDireccion("clienteID");
							consultaCtaCliente(inversionCon.cuentaAhoID);
							$('#inversionID').focus();
						}
						if(estatus == catStatusInversion.pagada){
							validaEstatus('estatus');
							consultaCliente('clienteID');
							consultaDireccion("clienteID");
							consultaCtaCliente(inversionCon.cuentaAhoID);
							mensajeSis("La Inversión ya fue Pagada (Abonada a Cuenta)");
							$('#inversionID').focus();
						}
						if(estatus == catStatusInversion.alta || estatus == catStatusInversion.cargada){
							if(inversionCon.fechaInicio != parametroBean.fechaSucursal){
								varError = 0;
								consultaCtaCliente(inversionCon.cuentaAhoID);
								habilitaBoton('cancela', 'submit');
							}else{
								validaEstatus('estatus');
								consultaCliente('clienteID');
								consultaDireccion("clienteID");
								consultaCtaCliente(inversionCon.cuentaAhoID);
								mensajeSis("La Inversón es del Día de Hoy, Utilice la pantalla de Cancelación");
							}
							}
							 if(estatus != catStatusInversion.alta){
								//la inversion si está de alta
							}else{
								deshabilitaBoton('cancela', 'submit');
								$('#inversionID').focus();
								mensajeSis("La Inversión no ha sido Autorizada");
							}
	
	
						if (varError > 0){
							$(jqInversion).focus();
							$(jqInversion).select();
						}
						$('#telefono').setMask('phone-us');
						if(funcionHuella == 'S' && autorizaHuellaCliente == 'S'){
							consultaHuellaCliente();
						}
					}else{
						mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
						$(jqInversion).focus();
						$(jqInversion).select();
					}
				}else{
					mensajeSis("La Inversión no Existe.");
					$(jqInversion).focus();
					$(jqInversion).select();
				}
			});
			}
		}
	}

	function validaEstatus() {
		var estatus=$('#estatus').val();
		var Alta 	="A";
		var Vigente ="N";
		var Pagada ="P";
		var Cancelada 	="C";
		var Vencida="V";
		setTimeout("$('#cajaLista').hide();", 200);

		if(estatus == Alta){
					 $('#estatus').val('ALTA');
		}
		if(estatus == Vigente){

			 $('#estatus').val('VIGENTE');
			}
		if(estatus == Pagada){

			 $('#estatus').val('PAGADA');
		}
		if(estatus == Cancelada){

			$('#estatus').val('CANCELADA');
		}
		if(estatus == Vencida){

			$('#estatus').val('VENCIDA');
		}
	}


	function consultaCliente(idControl) {

		var jqInversion = eval("'#" + idControl + "'");
		var numCliente = $(jqInversion).val();
		var conCliente = catTipoConsultaCliente.paraInversiones;
		var rfc = ' ';

		if(numCliente!='0'){
			setTimeout("$('#cajaLista').hide();", 200);
			if(numCliente != '' && !isNaN(numCliente)){
				clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
							if(cliente!=null){
								listaPersBloqBean = consultaListaPersBloq(numCliente, esCliente, 0, 0);
								consultaSPL = consultaPermiteOperaSPL(numCliente,'LPB',esCliente);
								if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
								$('#nombreCompleto').val(cliente.nombreCompleto);
								$('#telefono').val(cliente.telefonoCasa);
								$('#telefono').setMask('phone-us');
								}else{
									mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
									
									$('#clienteID').focus();
									$('#clienteID').val('');
									$('#nombreCompleto').val('');
									$('#direccion').val('');
									$('#telefono').val('');
								}
							}
					});
				}
		}
	}

	function consultaDireccion(idControl) {
		var jqInversion = eval("'#" + idControl + "'");
		var numCliente = $(jqInversion).val();

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

	function consultaTipoInversion(){
		var tipoInversion = $('#tipoInversionID').val();
		setTimeout("$('#cajaLista').hide();", 200);

		var tipoInversionBean = {
                'tipoInvercionID':tipoInversion,
                'monedaId': $('#monedaID').val()
        };

			if(tipoInversion != 0){
				tipoInversionesServicio.consultaPrincipal(catTipoConsultaTipoInversion.principal,
																		 tipoInversionBean, function(tipoInver){

					if(tipoInver!=null){
						$('#descripcion').val(tipoInver.descripcion);

						calculaCondiciones();
					}
				});
			}
	}

	/* Funciones de validaciones y calculos*/
	function consultaCtaCliente(cuentaID) {
        var numCta = cuentaID;
        var CuentaAhoBeanCon = {
        		'cuentaAhoID':numCta,
        		'clienteID':$('#clienteID').val()
        };
        setTimeout("$('#cajaLista').hide();", 200);

        if(numCta != '' && !isNaN(numCta)){
                cuentasAhoServicio.consultaCuentasAho(catTipoConsultaCuenta.conSaldo,
                													CuentaAhoBeanCon,function(cuenta) {
                	if(cuenta!=null){
							$('#totalCuenta').val(cuenta.saldoDispon);
                    	$('#totalCuenta').formatCurrency({colorize: true, positiveFormat: '%n', roundToDecimalPlace: -1});
                    	$('#tipoMoneda').html(cuenta.descripcionMoneda);
                    	$('#monedaID').val(cuenta.monedaID);
							$('#tipoMonedaInv').html(cuenta.descripcionMoneda);
                    	$('#monto').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
                		consultaCliente("clienteID");
                		consultaDireccion("clienteID");
                		validaEstatus();
                		consultaTipoInversion();
                	}else{
                		mensajeSis("No Existe la Cuenta de Ahorro");
                	}
                });
        }

	}

	function calculaCondiciones(){
		var interGenerado =$('#saldoProvision').val();
		var interRetener;
		var interRecibir;
		var total;

		if($('#tasaISR').asNumber()<=$('#tasa').asNumber()){
			$('#tasaNeta').val( $('#tasa').asNumber() - $('#tasaISR').asNumber());
		}else{
			$('#tasaNeta').val(0.00);
		}
		$('#tasaNeta').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2	});
		diasBase = parametroBean.diasBaseInversion;
		//interGenerado = (($('#monto').asNumber() * $('#tasa').asNumber() * $('#diasTrans').asNumber()) / (diasBase*100));

		//$('#interesGenerado').val(interGenerado);
		//$('#saldoProvision').val(interGenerado);
		$('#interesGenerado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

		diasBase = parametroBean.diasBaseInversion;
		salarioMinimo = parametroBean.salMinDF;
		var salarioMinimoGralAnu = parametroBean.salMinDF * 5 * parametroBean.diasBaseInversion; // Salario minimo General Anualizado
		// SI EL MONTO DE INVERSION es MAYOR O IGUAL A 5 Salario minimo General Anualizado Distrito Federal segun DF,(SMAGDF),
		//entonces se aplica el calculo de ISR PERO SOBRE EL EXCEDENTE DE CAPITAL NO SOBRE EL CAPITAL ORIGINAL,
		// si no es CERO
		// Al pagar intereses a una persona moral siempre se le debe retener ISR sobre el monto total sin contemplar exención alguna.
		var vartipoPersona = '';

		clienteServicio.consulta(1,$('#clienteID').val(),{ async: false, callback:function(cliente) {
			if(cliente!=null){
				vartipoPersona=cliente.tipoPersona;
			}
		}});

		if($('#monto').asNumber()> salarioMinimoGralAnu || vartipoPersona == 'M' ){
			if(vartipoPersona = 'M'){
				interRetener = (($('#monto').asNumber() * $('#tasaISR').val() * $('#diasTrans').val()) / (diasBase*100));
			}else{
				interRetener = ((($('#monto').asNumber()-salarioMinimoGralAnu ) * $('#tasaISR').val() * $('#diasTrans').val()) / (diasBase*100));
			}

		}else{
			interRetener = 0.00;
		}

		$('#monto').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#saldoProvision').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#interesRetener').val(interRetener);
		$('#interesRetener').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

		interRecibir = interGenerado - interRetener;

		$('#interesRecibir').val(interRecibir);
		$('#interesRecibir').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

		total = $('#monto').asNumber() + interRecibir;

		$('#granTotal').val(total);
		$('#granTotal').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

	}


	/* valida si las inversiones estan respaldando a un credito  */
	function validaInversionEnGarantia(numInversion){
		varGarantizadoInv = 0;
		var bean={
			'inversionID':numInversion
		};
		invGarantiaServicio.consulta(5,bean,function(inverGaran){
			if(inverGaran != null){
				$('#creditosInvGar').val(inverGaran.creditosRelacionados);
			}else{
				$('#creditosInvGar').val("");
			}
		});
	}

	function validaAutorizacionHuellaCliente(){
		paramGeneralesServicio.consulta(35,{},{async: false, callback:function(parametro) {
			if (parametro != null) {
				autorizaHuellaCliente = parametro.valorParametro;
			} else {
				autorizaHuellaCliente = 'N';
				mensajeSis('Ha ocurrido un error al consultar los parámetros del sistema.');
			}
		}});
	}

	// función para consultar si el cliente ya tiene huella digital registrada
	function consultaHuellaCliente(){

		var numCliente=$('#clienteID').val();
		if(numCliente != '' && !isNaN(numCliente )){
			var huellaDigitalBean = {
				'personaID'	  :$('#clienteID').val(),
				'cuentaAhoID' :$('#cuentaAhoID').val()
			};

			huellaDigitalServicio.consulta(catHuellaDigital.noHuellas, huellaDigitalBean, {
				async: false,
				callback:function(huellaDigitalBeanResponse) {
					if (huellaDigitalBeanResponse != null){
						if (huellaDigitalBeanResponse.noHuellas == 0 || huellaDigitalBeanResponse.noHuellas == '0'){
							mensajeSis("No es posible realizar la operación. <br>El cliente no tiene una huella registrada.");
							huellaCliente = 'N';
							deshabilitaBoton('cancela', 'submit');
							return false;
						}else {
							huellaCliente = 'S';
							habilitaBoton('cancela', 'submit');
						}
					}else {
						mensajeSis("Ha ocurrido un error al consultar el No. de Huellas del cliente y los firmantes.");
					}
				},
				errorHandler : function(message, exception) {
					mensajeSis("Error en Consulta de Huellas Digitales del Cliente.<br>" + message + ":" + exception);
				}
			});
		}
	}
});

// funcion de exito para pantalla de vencimiento anticipado de inversion
function funcionExitoVencimAnt(){
	$('#creditosInvGar').val("");
	inicializaForma('formaGenerica','inversionID');
	deshabilitaBoton('cancela', 'submit');
}

//funcion de fallo para pantalla de vencimiento anticipado de inversion
function funcionFalloVencimAnt(){

}

/* funcion para validar si la inversion tiene creditos en garantia*/
function validaCreditosInversionesEnGarantia(){
	var procedeSubmit = false;
	if($.trim($('#creditosInvGar').val())== ""){
		procedeSubmit = true;
	}else{
		var confirmar=confirm("La Inversión se encuentra Comprometida con el(los) Crédito(s): "+$('#creditosInvGar').val()+" \nEl(Los) Crédito(s) Quedarán Desprotegidos. ¿Desea Continuar?");
		if (confirmar == true) {
			// si pulsamos en aceptar
			procedeSubmit = true;
		}else{
			procedeSubmit = false;
		}
	}
	return procedeSubmit;
}