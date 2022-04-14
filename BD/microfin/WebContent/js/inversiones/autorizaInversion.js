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
	var esTab = true;
	$('#statusSrvHuella').hide();
	var serverHuella = new HuellaServer({
		fnHuellaValida:	function(datos){
			grabaFormaTransaccionRetrollamada({}, 'formaGenerica', 'contenedorForma', 'mensaje','false','inversionID', 'funcionExitoAutoriza', 'funcionFalloAutoriza');
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

	if(funcionHuella == 'S' && autorizaHuellaCliente == 'S'){
		$('#statusSrvHuella').show();
	}

	$('#inversionID').focus();
	$('#fecha').html(parametroBean.fechaSucursal);
	deshabilitaBoton('autoriza', 'submit');
	deshabilitaBoton('imprime', 'submit');
	agregaFormatoControles('formaGenerica');

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

	var catTipoConsultaInversion = {
		'principal' : 1
	};
	var catTipoTransaccion = {
		'autoriza':6
	};
	var catTipoConsultaCuenta = {
			'conSaldo': 5
	};
	var catTipoConsultaCliente = {
		'paraInversiones': 6
	};
	var catTipoConsultaTipoInversion = {
		'principal' : 1
	};
	var catTipoListaInversion = {
		'principal': 1
	};
	var catStatusInversion = {
		'alta':		'A',
		'cargada': 	'N',
		'pagada': 	'P',
		'cancelada':'C'
	};


	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada({}, 'formaGenerica', 'contenedorForma', 'mensaje','false','inversionID', 'funcionExitoAutoriza', 'funcionFalloAutoriza');
		}
	});

	$('#autoriza').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.autoriza);
		if(funcionHuella == 'S' && autorizaHuellaCliente == 'S'){
			consultaHuellaCliente();
			if(huellaCliente == 'S'){
				serverHuella.muestraFirmaAutorizacion();
				return false;
			}
		}
	});

	$('#inversionID').blur(function(){
		if(esTab){
			consultaValOperacion($('#inversionID').val());
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

			lista('inversionID', 2, catTipoListaInversion.principal, camposLista, parametrosLista, 'listaInversiones.htm');
		}
	});

	$('#imprime').click(function() {
		deshabilitaBoton('imprime', 'submit');
		if( parseInt($('#numeroMensaje').val()) == 0){
			var inversionID = $('#inversionID').val();
			var monedaID = $('#monedaID').val();
			var nombreInstitucion =  parametroBean.nombreInstitucion;
			var monto =  ($('#monto').formatCurrency({
								positiveFormat: '%n',
								roundToDecimalPlace: 2
								})).asNumber();
			var fechaEmision = parametroBean.fechaSucursal;
			var dirInst = parametroBean.direccionInstitucion;
			var RFCInst = parametroBean.rfcInst;
			var telInst = parametroBean.telefonoLocal;
			var gerente	= parametroBean.gerenteGeneral;
			var presidente = parametroBean.representanteLegal; // se cambio el presidentecondejo por representanteLegal
			var usuario	= parametroBean.nombreUsuario;
			var sucursalID = parametroBean.sucursal;

			var liga = 'pagareInversionRep.htm?inversionID='+inversionID +
						  '&monedaID=' + monedaID + '&nombreInstitucion=' + nombreInstitucion  + '&monto=' + monto
						  +'&direccionInstit='+dirInst+'&RFCInstit='+RFCInst+'&telefonoInst='+telInst+'&fechaActual='+fechaEmision
						  +'&nombreGerente='+gerente+'&nombrePresidente='+presidente+'&nombreUsuario='+usuario+'&sucursalID='+sucursalID;
			$('#enlace').attr('href',liga);

		}else{
			mensajeSis("Existieron Errores al Autorizar la Inversión.");
			$('#inversionID').focus();
			$('#inversionID').select();
			return false;
		}
	});



	$('#tasaISR').blur(function() {
		$('#tasaISR').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
		});

		$('#tasaNeta').blur(function() {
		$('#tasaNeta').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
		});

		$('#tasa').blur(function() {
		$('#tasa').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
	});

	/* CONSULTA OPERACION */
	function consultaValOperacion(instrumentoID) {
		setTimeout("$('#cajaLista').hide();", 200);
		operacionBean = {
			'instrumentoID'	: instrumentoID,
			'pantallaOrigen'	: "AI"
		};
		//constulta la operacion
		operacionesCapitalNetoServicio.consulta(2, operacionBean, function(datos) {
			if(datos != null) {
				if(datos.estatusOper=='SIN PROCESAR'){
					mensajeSis(datos.mensaje);
					deshabilitaBoton('autoriza', 'submit');
				}else{
					validaInversion('inversionID');
				}
			}else{
				validaInversion('inversionID');
			}
		});

	}

	function validaInversion(idControl){
		var jqInversion = eval("'#" + idControl + "'");
		var numInversion = $(jqInversion).val();
		var InversionBean = {
			'inversionID' : numInversion
		};
		if(numInversion != 0 && numInversion != ''){
			if(esTab){
				deshabilitaBoton('imprime', 'submit');
				deshabilitaBoton('autoriza', 'submit');
				inicializaForma('formaGenerica','inversionID');
				inversionServicioScript.consulta(catTipoConsultaInversion.principal, InversionBean, function(inversionCon){
				if(inversionCon!=null){
					consultaCtaCliente(inversionCon.cuentaAhoID);
					var estatus = inversionCon.estatus;
					var varError = 1;
					dwr.util.setValues(inversionCon);
					if(estatus == catStatusInversion.cancelada){
						mensajeSis("La Inversión se Encuentra Cancelada.");
					}
					if(estatus == catStatusInversion.cargada){
						mensajeSis("La Inversión se Encuentra Autorizada.");
					}
					if(estatus == catStatusInversion.pagada){
						mensajeSis("La Inversión ya fue Pagada (Abonada a Cuenta).");
					}
					if(estatus == catStatusInversion.alta){
						if(inversionCon.fechaInicio != parametroBean.fechaSucursal){
							mensajeSis("La Inversión no es del Día de Hoy.");
						}else{
							varError = 0;
							habilitaBoton('autoriza', 'submit');
							$('#autoriza').focus();
						}
					}
					if (varError > 0){
						$(jqInversion).focus();
						$(jqInversion).select();
					}$('#telefono').setMask('phone-us');
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
							consultaEstatusCliente('clienteID');
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
				tipoInversionesServicio.consultaPrincipal(catTipoConsultaTipoInversion.principal, tipoInversionBean, function(tipoInver){
					if(tipoInver!=null){
						$('#descripcion').val(tipoInver.descripcion);

						calculaCondiciones();
					}
				});
			}
	}

	function consultaCtaCliente(cuentaID) {
		var numCta = cuentaID;
		var CuentaAhoBeanCon = {
				'cuentaAhoID':numCta,
				'clienteID':$('#clienteID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if(numCta != '' && !isNaN(numCta)){
			  cuentasAhoServicio.consultaCuentasAho(catTipoConsultaCuenta.conSaldo,CuentaAhoBeanCon,function(cuenta) {
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
		total = $('#monto').asNumber() + $('#interesRecibir').asNumber();
		$('#tasa').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
		if($('#tasaNeta').asNumber() <0){
			$('#tasaNeta').val(0.00);
		}
		$('#tasaNeta').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#tasaISR').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#interesGenerado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#interesRetener').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#interesRecibir').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		$('#granTotal').val(total);
		$('#granTotal').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	}

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			noCliente: 'required',
			cuentaAhoID: 'required',
			tipoInversionID: 'required',
			monto: 'required',
			plazo: 'required',
			fechaVencimiento: 'required'

		},

		messages: {
			noCliente: 'Especifique número de cliente',
			cuentaAhoID: 'Especifique la cuenta del cliente',
			tipoInversionID:'Especifique el tipo de inversión',
			monto:'La cantidad a invertir esta vacía',
			plazo:'Indicar el plazo de la inversión',
			fechaVencimiento:'Indicar fecha de vencimiento'
		}
	});

	// funcion que consuta el estatus del cliente
	function consultaEstatusCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var tipConForanea = 1;
		setTimeout("$('#cajaLista').hide();", 200);

		if(numCliente != '' && !isNaN(numCliente) ){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
				if(cliente!=null){

					  if (cliente.estatus=="I"){
							deshabilitaBoton('autoriza','submit');
							deshabilitaBoton('imprime','submit');
							mensajeSis("El Cliente se encuentra Inactivo.");
							$('#inversionID').focus();

						}else{
							habilitaControl('beneficiarioInver');
							habilitaControl('beneficiarioSocio');
						}

				}else{
					mensajeSis("No Existe el Cliente.");
					$('#clienteID').val('');
					$('#nombreCliente').val('');
				}
			});
		}
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
							deshabilitaBoton('autoriza', 'submit');
							return false;
						}else {
							huellaCliente = 'S';
							habilitaBoton('autoriza', 'submit');
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


function funcionExitoAutoriza(){
	if($('#numeroMensaje').val()){
		inicializaForma('formaGenerica','inversionID');
		deshabilitaBoton('autoriza', 'submit');
		habilitaBoton('imprime', 'boton');
	}
}

function funcionFalloAutoriza(){
}

