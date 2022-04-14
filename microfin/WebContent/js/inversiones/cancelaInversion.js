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
	var parametroBean = consultaParametrosSession();
	$('#statusSrvHuella').hide();

	var serverHuella = new HuellaServer({
		fnHuellaValida:	function(datos){
			grabaFormaTransaccionRetrollamada({}, 'formaGenerica', 'contenedorForma', 'mensaje','false','inversionID', 'funcionExito', 'funcionError');
		},
		fnHuellaInvalida: function(datos){
			mensajeSis("La huella del cliente/firmante no corresponde con el registro en el sistema.");
			deshabilitaBoton("grabar");
			return false;
		}
	});

	validaAutorizacionHuellaCliente();
	$('#fecha').html(parametroBean.fechaSucursal);
	var funcionHuella = parametroBean.funcionHuella;

	deshabilitaBoton('cancela', 'submit');
	agregaFormatoControles('formaGenerica');

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
			'principal' : 1
	};

	var catTipoConsultaTipoInversion = {
			'principal' : 1
	};
	var catTipoTransaccionInsersion = {
		'agrega'	:1,
		'cancela' :2
	};
	var catTipoConsultaCliente = {
		'paraInversiones': 6
	};
	var catTipoListaInversion = {
		'paraCancelacion': 3
	};
	var catStatusInversion = {
			'alta':		'A',
			'cargada': 	'N',
			'pagada': 	'P',
			'cancelada':'C'
	};

	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','inversionID','funcionExito','funcionError');
		}
	});

	$('#inversionID').focus();

	$('#cancela').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionInsersion.cancela);
		if(funcionHuella == 'S' && autorizaHuellaCliente == 'S'){
			consultaHuellaCliente();
			if(huellaCliente == 'S'){
				serverHuella.muestraFirmaAutorizacion();
				return false;
			}
		}
	});

	$('#inversionID').bind('keyup',function(e){
		if(this.value.length >= 3){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreCliente";
			camposLista[1] = "estatus";
			parametrosLista[0] = $('#inversionID').val();
			parametrosLista[1] = catStatusInversion.alta;
			lista('inversionID', 2, catTipoListaInversion.paraCancelacion, camposLista,parametrosLista, 'listaInversiones.htm');
		}
	});

	$('#inversionID').blur(function(){
		validaInversion(this.id);
	});
	$('#inversionID').focus(function(){
		deshabilitaBoton('cancela', 'submit');
	});

	$('#claveUsuarioAut').blur(function() {
		validaUsuario(this);
	});


	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			clienteID: 'required',
			cuentaAhoID: 'required',
			tipoInversionID: 'required',
			monto: 'required',
			plazo: 'required',
			fechaVencimiento: 'required'

		},

		messages: {
			clienteID: 'Especifique numero de cliente',
			cuentaAhoID: 'Especifique la cuenta del cliente',
			tipoInversionID:'Especifique el tipo de Inversion',
			monto:'La cantidad a invertir esta vacia',
			plazo:'Indicar el plazo de la inversion',
			fechaVencimiento:'Indicar fecha de vencimiento'
		}
	});

	//funciones consultas
	function validaInversion(idControl){
		var jqInversion = eval("'#" + idControl + "'");
		var numInversion = $(jqInversion).val();
		var InversionBean = {
			'inversionID' : numInversion
		};
		deshabilitaBoton('cancela', 'submit');
		if(numInversion != 0 && numInversion != '' && esTab){
				inicializaForma('formaGenerica','inversionID');
				inversionServicioScript.consulta(catTipoConsultaInversion.principal, InversionBean,function(inversionCon){
				if(inversionCon!=null){
					consultaCtaCliente(inversionCon.cuentaAhoID);
					var estatus = inversionCon.estatus;
					$('#estatus').val(inversionCon.estatus);
					var varError = 1;
					dwr.util.setValues(inversionCon);
					if(estatus == catStatusInversion.cancelada){
						mensajeSis("La Inversión se encuentra Cancelada.");
					}
					if(estatus == catStatusInversion.pagada){
						mensajeSis("La Inversión ya fue Pagada (Abonada a Cuenta).");
					}
					if(estatus == catStatusInversion.alta || estatus == catStatusInversion.cargada){
						if(inversionCon.fechaInicio != parametroBean.fechaSucursal){
							mensajeSis("La Inversión no es del Día de Hoy.");
						}else{
							varError = 0;
							habilitaBoton('cancela', 'submit');
							$('#cancela').focus();
						}
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
					mensajeSis("La Inversión no Existe.");
					$(jqInversion).focus();
					$(jqInversion).select();
				}
			});

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
									
									$('#inversionID').focus();
									$('#inversionID').select();
									$('#nombreCompleto').val('');
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
			cuentasAhoServicio.consultaCuentasAho(catTipoConsultaCuenta.conSaldo, CuentaAhoBeanCon,function(cuenta) {
				if(cuenta!=null){
						$('#totalCuenta').val(cuenta.saldoDispon);
					$('#totalCuenta').formatCurrency({colorize: true, positiveFormat: '%n', roundToDecimalPlace: -1});
					$('#tipoMoneda').html(cuenta.descripcionMoneda);
					$('#monedaID').val(cuenta.monedaID);
						$('#tipoMonedaInv').html(cuenta.descripcionMoneda);
					$('#monto').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					consultaCliente("clienteID");
					consultaDireccion("clienteID");
					consultaTipoInversion();
				}else{
					mensajeSis("No Existe la Cuenta de Ahorro.");
				}
			});
		}

	}

	function calculaCondiciones(){
		var total;
		total = $('#monto').asNumber() +$('#interesRecibir').asNumber();
		$('#tasaNeta').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 4});
		$('#tasaISR').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 4	});
		$('#tasa').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 4	});
		$('#interesGenerado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#interesRetener').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#interesRecibir').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#granTotal').val(total);
		$('#granTotal').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
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


function funcionExito(){
}

function funcionError(){
}