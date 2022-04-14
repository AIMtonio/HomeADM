var funcionHuella = 'N';
var autorizaHuellaCliente = 'N';
var huellaCliente = 'N';

var listaPersBloqBean = {
	'estaBloqueado' :'N',
	'coincidencia'  :0
};

var consultaSPL = {
	'opeInusualID' : 0,
	'numRegistro' : 0,
	'permiteOperacion' : 'S',
	'fechaDeteccion' : '1900-01-01'
};

var esCliente ='CTE';
var operacionEnvioSpei = 100;
var parametroBean = consultaParametrosSession();
var TipoImpresion=parametroBean.tipoImpTicket;

$(document).ready(function() {
	esTab = true;
	$('#statusSrvHuella').hide();
	validaAutorizacionHuellaCliente();
	var funcionHuella = parametroBean.funcionHuella;
	if(funcionHuella == 'S' && autorizaHuellaCliente == 'S'){
		$('#statusSrvHuella').show();
	}

	var serverHuella = new HuellaServer({
		fnHuellaValida:	function(datos){
			grabaFormaTransaccionRetrollamada({}, 'formaGenerica', 'contenedorForma', 'mensaje','true','true','exitoTransaccionSpei','falloTransaccionSpei');
		},
		fnHuellaInvalida: function(datos){
			mensajeSis("La huella del cliente/firmante no corresponde con el registro en el sistema.");
			deshabilitaBoton("grabar");
			return false;
		}
	});

	//Definicion de Constantes y Enums
	var catTipoTranferSpei = {
		'graba' : '1',
	};


	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('graba', 'submit');
	deshabilitaBoton('imprimirCarta', 'submit');
	agregaFormatoControles('formaGenerica');

	$("#tipoPago").val('1');
	$('#tipoCuenta').val('E');
	$('#cuentaAhoID').focus();

	var nomUsuario = parametroBean.nombreUsuario;
	var nombre= nomUsuario.substr(0, 30);
	$("#usuarioEnvio").val(nombre);

	consultaHorario();

	$(':text').focus(function() {
		esTab = false;
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','true','exitoTransaccionSpei','falloTransaccionSpei');
		}
	});


	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#graba').click(function() {
		$('#tipoTransaccion').val(catTipoTranferSpei.graba);
		$('#tipoOperacion').val(6);
		if(funcionHuella == 'S' && autorizaHuellaCliente == 'S'){
				serverHuella.muestraFirmaAutorizacion();
				return false;
		}
	});


	$('#cuentaAhoID').bind('keyup',function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "clienteID";
		parametrosLista[0] = $('#cuentaAhoID').val();
		listaAlfanumerica('cuentaAhoID', '2', '3',camposLista, parametrosLista,'cuentasAhoListaVista.htm');
	});

	$('#cuentaAhoID').blur(function() {
		ocultaBtnImpTicket();
		if(isNaN($('#cuentaAhoID').val()) ){
			inicializaForma('formaGenerica', 'cuentaAhoID');
			$('#cuentaAhoID').val('');
			$('#cuentaAhoID').focus();
			}else{
			consultaCtaAhoAbono();
		}

	});

	$('#montoTransferir').blur(function() {
		if(esTab){
			calculaMonto();
		}
	});

	$('#pagarIVA').blur(function() {
		if($('#pagarIVA').asNumber() != ''){
		$('#pagarIVA').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
		}else {
			$('#pagarIVA').val('0.00');
		}
	});


	$('#instiReceptora').bind('keyup',function(e){
		lista('instiReceptora', '1', '1', 'nombre', $('#instiReceptora').val(), 'listaInstituciones.htm');
	});

	$('#tipoCtaBenSPEI').bind('keyup',function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "clienteID";
		camposLista[1] = "tipoCtaBenSPEI";
		parametrosLista[0] = $('#clienteID').val();
		parametrosLista[1] = $('#tipoCtaBenSPEI').val();
		lista('tipoCtaBenSPEI', '2', '4',camposLista,parametrosLista,'cuentasDestinoLista.htm');
	});

	$('#tipoCtaBenSPEI').blur(function() {
		if(isNaN($('#tipoCtaBenSPEI').val()) ){
			inicializaForma('formaGenerica', 'tipoCtaBenSPEI');
			$('#tipoCtaBenSPEI').val('');
			$('#tipoCtaBenSPEI').focus();
		}else{
			consultaCuentaTranfer();
		}
	});


	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			tipoPago:{required: true
			},
			cuentaAhoID:{required: true
			},
			clienteID:{required:true
			},
			montoTransferir:{required:true
			},
			ctaBenSPEI:{required:true
			},
			ctaBenSPEI:{required:true
			},
			instiReceptora:{required:true
			},
			nombreBeneficiario:{required:true
			},
			conceptoPago:{required:true
			},
			referenciaNum:{number:true
			}
		},

		messages: {
			tipoPago:{
				required:'Especificar Tipo de Pago'
			},
			cuentaAhoID:{
				required:'Especificar Cuenta'
			},
			clienteID:{
				required:'Especificar Cliente'
			},
			montoTransferir:{
				required:'Especificar Monto a Transferir'
			},
			ctaBenSPEI:{
				required:'Especificar Cuenta del Beneficiario'
			},
			instiReceptora:{
				required:'Especificar Banco'
			},
			nombreBeneficiario:{
				required:'Especificar Nombre del Beneficiario'
			},
			conceptoPago:{
				required:'Especificar Concepto de Pago'
			},
			referenciaNum:{
				number:'Solo Numeros'
			}
		}
	});

	//------------ Validaciones de Controles -------------------------------------



	// funcion para consultar la cuenta de ahorro
	function consultaCtaAhoAbono() {
		$("#usuarioEnvio").val(nombre);
		$('#claveRastreo').val('');
		$('#numTransaccion').val('');
		var numCta = $('#cuentaAhoID').val();
		var tipConCampos= 4;
		var CuentaAhoBeanCon = {
			'cuentaAhoID'	:numCta
		};

		if(numCta != '' && !isNaN(numCta)){
			if(esTab){
				setTimeout("$('#cajaLista').hide();", 200);
				cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
					if(cuenta!=null){
						listaPersBloqBean = consultaListaPersBloq(cuenta.clienteID, esCliente, cuenta.cuentaAhoID, 0);
						consultaSPL = consultaPermiteOperaSPL(cuenta.clienteID,'LPB',esCliente);

						if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
							limpiaCamposEvio();
							limpiaCamposTrans();
							limpiaCamposBenef();

							esTab= "true";
							var tipoCuenta = cuenta.tipoCuentaID;
							var estatusCliente = cuenta.estatus;
							var cuentaClabe = cuenta.clabe;

							$('#destipoCtaSPEI').val(cuenta.descripcionTipoCta);
							$('#cuentaAhoID').val(cuenta.cuentaAhoID);
							$('#clienteID').val(cuenta.clienteID);
							$('#monedaID').val(cuenta.monedaID);
							$('#desmoneda').val(cuenta.descripcionMoneda);
							$('#cuentaOrd').val(cuenta.clabe);
							$('#tipoCuentaOrd').val('40');
							consultaClientePantalla('clienteID',tipoCuenta, estatusCliente);

							if(estatusCliente == 'A'){
								participaSPEI(tipoCuenta, cuenta.clienteID);

							}

							if(estatusCliente == 'R'){
								deshabilitaBoton('graba', 'submit');
								deshabilitaBoton('imprimirCarta', 'submit');
								ocultaBtnImpTicket();
								$('#cuentaAhoID').focus();
								limpiaCamposTrans();
								limpiaCamposBenef();
								$('#comisionTrans').val('');
								$('#comisionIVA').val('');
								mensajeSis("La Cuenta NO esta Autorizada");
							}

							if(estatusCliente == 'C'){
								deshabilitaBoton('graba', 'submit');
								deshabilitaBoton('imprimirCarta', 'submit');
								ocultaBtnImpTicket();
								$('#cuentaAhoID').focus();
								limpiaCamposTrans();
								limpiaCamposBenef();
								$('#comisionTrans').val('');
								$('#comisionIVA').val('');
								mensajeSis("La Cuenta tiene Estatus Cancelado");

							}

							if(estatusCliente == 'B'){
								deshabilitaBoton('graba', 'submit');
								deshabilitaBoton('imprimirCarta', 'submit');
								ocultaBtnImpTicket();
								$('#cuentaAhoID').focus();
								limpiaCamposTrans();
								limpiaCamposBenef();
								$('#comisionTrans').val('');
								$('#comisionIVA').val('');
								mensajeSis("La Cuenta tiene Estatus Bloqueado");
							}

							if(estatusCliente == 'I'){
								deshabilitaBoton('graba', 'submit');
								deshabilitaBoton('imprimirCarta', 'submit');
								ocultaBtnImpTicket();
								$('#cuentaAhoID').focus();
								limpiaCamposTrans();
								limpiaCamposBenef();
								$('#comisionTrans').val('');
								$('#comisionIVA').val('');
								mensajeSis("La Cuenta tiene Estatus Inactivo");
							}

							if(cuentaClabe == ''){
								deshabilitaBoton('graba', 'submit');
								deshabilitaBoton('imprimirCarta', 'submit');
								ocultaBtnImpTicket();
								$('#cuentaAhoID').focus();
								limpiaCamposTrans();
								limpiaCamposBenef();
								$('#comisionTrans').val('');
								$('#comisionIVA').val('');
								mensajeSis("La Cuenta de Ahorro no tiene asignada una Cuenta Clabe");
							}
						}else{
							inicializaForma('formaGenerica', 'cuentaAhoID');
							mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
							$('#cuentaAhoID').focus();
							$('#cuentaAhoID').val('');
							deshabilitaBoton('graba', 'submit');
							deshabilitaBoton('imprimirCarta', 'submit');
							ocultaBtnImpTicket();
							limpiaCamposEvio();
							limpiaCamposTrans();
							limpiaCamposBenef();
							$('#comisionTrans').val('');
							$('#comisionIVA').val('');
						}
					}else{
						mensajeSis("No Existe la Cuenta de Ahorro");
						inicializaForma('formaGenerica', 'cuentaAhoID');
						$('#cuentaAhoID').focus();
						$('#cuentaAhoID').val('');
						deshabilitaBoton('graba', 'submit');
						deshabilitaBoton('imprimirCarta', 'submit');
						ocultaBtnImpTicket();
						limpiaCamposEvio();
						limpiaCamposTrans();
						limpiaCamposBenef();
						$('#comisionTrans').val('');
						$('#comisionIVA').val('');
					}
				});
			}
		}
	}

	// funcion para consultar el cliente
	function consultaClientePantalla(idControl, tipoCuenta, estatus) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var conCliente = 5;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente,numCliente,rfc,{
				async: false, callback:function(cliente){
					if(cliente!=null){
						$('#nombreOrd').val(cliente.nombreCompleto);
						$('#tipoPersonaSPEI').val(cliente.tipoPersona);
						$('#ordRFC').val(cliente.RFC);

						var tipoPersona = cliente.tipoPersona;
						if(cliente.estatus == 'A'){
							if(estatus == 'A'){
								consultaTipoCta(tipoCuenta, tipoPersona);
							}
						}

						if(cliente.estatus == 'I'){
							mensajeSis('El Cliente se encuentra Inactivo');
							$('#cuentaAhoID').focus();
							deshabilitaBoton('imprimirCarta');
							deshabilitaBoton('graba');
							ocultaBtnImpTicket();
						}

						if(cliente.estatus == 'C'){
							mensajeSis('El Cliente se encuentra Cancelado');
							$('#cuentaAhoID').focus();
							deshabilitaBoton('imprimirCarta');
							deshabilitaBoton('graba');
							ocultaBtnImpTicket();
						}

						if(cliente.estatus == 'B'){
							mensajeSis('El Cliente se encuentra Bloqueado');
							$('#cuentaAhoID').focus();
							deshabilitaBoton('imprimirCarta');
							deshabilitaBoton('graba');
							ocultaBtnImpTicket();
						}
					}else{
						mensajeSis("No Existe el Cliente");
						$('#cuentaAhoID').focus();
						deshabilitaBoton('imprimirCarta');
						deshabilitaBoton('graba');
						ocultaBtnImpTicket();
					}
				}
			});
		}
	}

	// funcion para consultar el saldo disponible de la cuenta
	function consultaSaldoCtaAho(numCte) {

		var numCta =$('#cuentaAhoID').val();
		var tipConCampos= 5;
		var CuentaAhoBeanCon = {
			'cuentaAhoID'	:numCta,
			'clienteID'		:numCte
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCta != '' && !isNaN(numCta)){
			if(esTab){
				cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
					if(cuenta!=null){
						var saldoDip = cuenta.saldoDispon;
						if(saldoDip == '0.00'){
							mensajeSis("La Cuenta no tiene Saldo Disponible");
							$('#saldoDisp').val('0.00');
							$('#cuentaAhoID').focus();
							deshabilitaBoton('graba', 'submit');
							deshabilitaBoton('imprimirCarta', 'submit');
							ocultaBtnImpTicket();
						}else{
							$('#saldoDisp').val(cuenta.saldoDispon);
							if($('#cuentaOrd').val() != ''){
								habilitaBoton('imprimirCarta', 'submit');
								deshabilitaBoton('graba', 'submit');
								ocultaBtnImpTicket();
							}

						}

					}else{
						mensajeSis("No Existe la cuenta de ahorro o no corresponde a ese cliente");
						$('#cuentaAhoID').focus();
						$('#cuentaAhoID').select();
						deshabilitaBoton('graba', 'submit');
						deshabilitaBoton('imprimirCarta', 'submit');
						ocultaBtnImpTicket();
					}
				});
			}
		}
	}

	// consulta tipo de cuenta
	function consultaTipoCta(numTipoCta, persona) {
		var tipoPersona = persona;
		var numCta = $('#cuentaAhoID').val();
		var conTipoCta = 4;
		var TipoCuentaBeanCon = {
			'tipoCuentaID' : numTipoCta
		};
		if (numCta == 0) {
			$(tipoCuentaID).removeAttr('disabled');
		}
		setTimeout("$('#cajaLista').hide();", 200);
		if (numTipoCta != '' && !isNaN(numTipoCta)) {
			tiposCuentaServicio.consulta(conTipoCta,TipoCuentaBeanCon, function(tipoCuenta) {
				if (tipoCuenta != null) {
					if(tipoPersona == 'F' || tipoPersona == 'A'){
						var comPerFis = tipoCuenta.comSpeiPerFis;
						var ivaComPerFis = (comPerFis * .16);

						$('#comisionTrans').val(comPerFis);
						$('#comisionIVA').val(ivaComPerFis);
						$('#comisionTrans').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
						$('#comisionIVA').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});

					}
					if(tipoPersona == 'M'){
						var comPerMor = tipoCuenta.comSpeiPerMor;
						var ivaComPerMor = (comPerMor * .16);
						$('#comisionTrans').val(comPerMor);
						$('#comisionIVA').val(ivaComPerMor);
						$('#comisionTrans').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
						$('#comisionIVA').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
					}


				} else {
					$(jqTipoCta).focus();
				}
			});
		}
	}

	// funcion para validar que el tipo de cuenta participe en spei
	function participaSPEI(numTipoCta, numCte) {
		var tipoCon = 4;
		var tiposCuenta = {
			'tipoCuentaID' : numTipoCta
		};
		tiposCuentaServicio.consulta(tipoCon,tiposCuenta,{
			async: false, callback:function(tiposCuenta) {
				if (tiposCuenta != null) {
					if (tiposCuenta.participaSpei != 'S') {
					mensajeSis("El Tipo de Cuenta no Participa en SPEI");
					$('#cuentaAhoID').focus();
					} else {
						consultaSaldoCtaAho(numCte);
						}
				}
			}
		});
	}


	// calcula el monto
	function calculaMonto() {
		var cuentaSPEI = $('#cuentaAhoID').val();
		var montoTransfer = $('#montoTransferir').asNumber();
		$('#montoTransferir').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});

		if(cuentaSPEI != ''){
			if(montoTransfer != '' && montoTransfer != '0'){
				var totalMontoTrans = ($('#montoTransferir').asNumber()+$('#comisionTrans').asNumber()+$('#comisionIVA').asNumber());
				var saldoDisponible = $('#saldoDisp').asNumber();


				if(totalMontoTrans > saldoDisponible){
					mensajeSis("El Monto es Superior al Saldo Disponible.");
					 $('#montoTransferir').focus();
					 $('#montoTransferir').val('');
					 $('#totalCargoCuenta').val('');
					 $('#totalCargoLetras').val('');

				}else{
					consultaParametrsosSpei(montoTransfer);
					$('#totalCargoCuenta').val(totalMontoTrans);
					$('#totalCargoLetras').val(totalMontoTrans);
					$('#totalCargoCuenta').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#pagarIVA').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});

				}
			}else {
				mensajeSis('Especificar Monto de la Transferencia');
				$('#montoTransferir').focus();
				$('#montoTransferir').val('');
				$('#totalCargoCuenta').val('');
				$('#totalCargoLetras').val('');
			}
		}
	}

	// consulta cuantas a tranferir
	function consultaCuentaTranfer() {
		$("#usuarioEnvio").val(nombre);

		var cuentasTranfer = $('#tipoCtaBenSPEI').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if (cuentasTranfer != '' && !isNaN(cuentasTranfer)) {

			var Baja="B";
			var Autorizado="A";
			var cuentas = {
				'clienteID' : $('#clienteID').val(),
				'cuentaTranID' : $('#tipoCtaBenSPEI').val()
			};

			cuentasTransferServicio.consulta(2,cuentas,function(cuenta) {
				if (cuenta != null) {
					if (cuenta.estatus == Baja) {
						$('#estatus').val('BAJA');
						mensajeSis("La cuenta fue Cancelada");
						$('#tipoCtaBenSPEI').focus();
						$('#tipoCtaBenSPEI').val('');

					}else{
						if(cuenta.estatus == Autorizado) {
							$('#tipoCuentaBen').val(cuenta.tipoCuentaSpei);
							$('#cuentaBeneficiario').val(cuenta.clabe);
							$('#instiReceptora').val(cuenta.institucionID);
							$('#nombreBeneficiario').val(cuenta.beneficiario);
							$('#beneficiarioRFC').val(cuenta.beneficiarioRFC);

						}
					}
					consultaInstitucion('instiReceptora');

					if(cuenta.tipoCuenta != 'E'){
						mensajeSis("No es un Tipo de Cuenta Externa");
						$('#tipoCtaBenSPEI').select();
						$('#tipoCtaBenSPEI').focus();
						$('#tipoCtaBenSPEI').val('');
						limpiaCamposTrans();
						limpiaCamposBenef();
					}

				} else {
					mensajeSis("No Existe la Cuenta Destino");
					$('#tipoCtaBenSPEI').focus();
					limpiaCamposTrans();
					limpiaCamposBenef();
				}
			});

		}

		if (cuentasTranfer != '' && isNaN(cuentasTranfer) && esTab) {
			mensajeSis("No Existe la Cuenta Destino");
			$('#instiReceptora').val('');
			$('#desbancoSPEI').val('');
			$('#clabe').val('');
			$('#beneficiario').val('');
			$('#alias').val('');
		}
	}

	// Funcion de consulta para obtener el nombre de la
	// institucion
	function consultaInstitucion(idControl) {

		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();

		setTimeout("$('#cajaLista').hide();", 200);
		var InstitutoBeanCon = {
			'institucionID' : numInstituto
		};

		if (Number(numInstituto)>0 && !isNaN(numInstituto)) {
			institucionesServicio.consultaInstitucion(4,InstitutoBeanCon, function(instituto) {
				if (instituto != null) {
					$('#desbancoSPEI').val(instituto.nombre);
				} else {
					mensajeSis("No existe la Institución");
					$('#instiReceptora').val('');
					$('#instiReceptora').focus();
					$('#desbancoSPEI').val("");
				}
			});
		}
	}

	/* se imprime el reporte de autorizacion de SPEI*/
	$('#imprimirCarta').click(function() {

		if($('#tipoCtaBenSPEI').val() == '') {
			mensajeSis("Especificar Cuenta Destino");
			$('#tipoCtaBenSPEI').focus();
		}
		else if($('#montoTransferir').val() == ''){
			mensajeSis("Especificar Monto a Transferir");
			$('#montoTransferir').focus();
		}
		else if($('#conceptoPago').val() == ''){
			mensajeSis("Especificar Concepto de Pago");
			$('#conceptoPago').focus();
		}else{

			if($('#claveRastreo').val() == ''){
				habilitaBoton('graba', 'submit');
			}else {
				deshabilitaBoton('graba', 'submit');
				ocultaBtnImpTicket();
			}

			parametroBean = consultaParametrosSession();

			var cuentaAho = $('#cuentaAhoID').val();
			var cliente = $('#clienteID').val();
			var nombreInstitucion	= parametroBean.nombreInstitucion;
			var varFechaSistema		= parametroBean.fechaSucursal;
			var sucursal			= parametroBean.sucursal;
			var nomSucursal 		= parametroBean.nombreSucursal;
			var edoMunSuc	        = parametroBean.edoMunSucursal;
			var nombreCliente = $('#nombreOrd').val();
			var totalCargo = $('#totalCargoCuenta').val();
			var totalLetras = $('#totalCargoLetras').val();
			var beneficiario = $('#nombreBeneficiario').val();
			var ctaClaveBen = $('#cuentaBeneficiario').val();
			var bancoBen = $('#instiReceptora').val();
			var nomBancoBen = $('#desbancoSPEI').val();
			var montoSpei = $('#montoTransferir').val();
			var ivaPagar = $('#pagarIVA').val();
			var comisionTransfer = $('#comisionTrans').val();
			var ivaComision = $('#comisionIVA').val();
			var referencia = $('#conceptoPago').val();
			var moneda = $('#monedaID').val();


			fecha =$('#fecha').val();
			window.open('ReporteAutorizaSpei.htm?cuentaAhoID='+cuentaAho+
				'&clienteID='+cliente+
				'&nombreInstitucion='+nombreInstitucion+
				'&fechaSistema='+varFechaSistema+
				'&sucursal='+sucursal+
				'&nomSucursal='+nomSucursal+
				'&nombreOrd='+nombreCliente+
				'&totalCargoCuenta='+totalCargo+
				'&totalCargoLetras='+totalLetras+
				'&nombreBeneficiario='+beneficiario+
				'&cuentaBeneficiario='+ctaClaveBen+
				'&instiReceptora='+bancoBen+
				'&desbancoSPEI='+nomBancoBen+
				'&montoTransferir='+montoSpei+
				'&pagarIVA='+ivaPagar+
				'&comisionTrans='+comisionTransfer+
				'&comisionIVA='+ivaComision+
				'&conceptoPago='+referencia+
				'&monedaID='+moneda+
				'&edoMunSucursal='+edoMunSuc,'_blank');
		}
	});

	// consulta parametrosspei para traer el monto permitido
	function consultaParametrsosSpei(montoTransfer) {
		var numEmpresa = 1;
		var tipConsulta = 1;
		var EmpresaBeanCon = {
				'empresaID'	:numEmpresa
			};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numEmpresa != '' && !isNaN(numEmpresa)){
			parametrosSpeiServicio.consulta(tipConsulta, EmpresaBeanCon,function(parametros) {
				if(parametros!=null){
				  var montoPermitido = parametros.monMaxSpeiVen;
					if(montoTransfer > montoPermitido){
						mensajeSis("La Cantidad es Superior al Monto Permitido");
						$('#montoTransferir').val('');
						$('#montoTransferir').focus();
						limpiaCamposTrans();
					}

				}else{
					mensajeSis("No Existe el Tipo Empresa");

				}
			});
		}
	}

	// consulta parametrosspei para traer el el horario de operacion spei
	function consultaHorario() {
		var numEmpresa = 1;
		var tipConsulta = 1;
		var EmpresaBeanCon = {
				'empresaID'	:numEmpresa
			};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numEmpresa != '' && !isNaN(numEmpresa)){
			parametrosSpeiServicio.consulta(tipConsulta, EmpresaBeanCon,function(parametros) {
				if(parametros!=null){

					var horarioInicioOper = parametros.horarioInicio;
					var horarioFinOper = parametros.horarioFin;
					var horaActual = horaSistem();

					if(horaActual >= horarioInicioOper && horaActual <= horarioFinOper){
					}else{
						mensajeSis("El Usuario no puede Operar, esta fuera del Horario de Operaciones SPEI");
						deshabilitaControl('cuentaAhoID');
						deshabilitaControl('tipoCtaBenSPEI');
						deshabilitaControl('montoTransferir');
						deshabilitaControl('pagarIVA');
						deshabilitaControl('conceptoPago');
						deshabilitaControl('referenciaNum');
					}

				}else{
					mensajeSis("No se encuentra parametrizado el Horario de SPEI");

				}
			});
		}
	}

	function limpiaCamposEvio(){
		//ENVIO
		$('#clienteID').val('');
		$('#nombreOrd').val('');
		$('#destipoCtaSPEI').val('');
		$('#monedaID').val('');
		$('#desmoneda').val('');
		$('#saldoDisp').val('');
	}

	function limpiaCamposTrans(){
		//TRANSFERENCIA
		$('#clabeRastreoSPEI').val('');
		$('#destipoOperSPEI').val('');
		$('#montoTransferir').val('');
		$('#pagarIVA').val('');
		$('#totalCargoCuenta').val('');
		$('#totalCargoLetras').val('');
		$('#clabeRastreo').val('');
		$('#conceptoPago').val('');
		$('#referenciaNum').val('');
	}

	function limpiaCamposBenef(){
		//BENEFICIARIO
		$('#tipoCtaBenSPEI').val('');
		$('#destipoCtaBenSPEI').val('');
		$('#cuentaBeneficiario').val('');
		$('#instiReceptora').val('');
		$('#desbancoSPEI').val('');
		$('#nombreBeneficiario').val('');
		$('#beneficiarioRFC').val('');
		$('#referenciaSPEI').val('');
	}

	//Consulta los paramtros de huella
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
			var clienteIDBean = {
				'personaID':$('#clienteID').val()
			};

			huellaDigitalServicio.consulta(1,clienteIDBean,{async: false, callback:function(cliente) {
				if (cliente == null){
					mensajeSis("No es posible realizar la operación. <br>El cliente no tiene un huella registrada.");
					huellaCliente = 'N';
					deshabilitaBoton('autoriza', 'submit');
					return false;
				}else {
					huellaCliente = 'S';
					habilitaBoton('autoriza', 'submit');
				}
			}});
		}
	}
});


function exitoTransaccionSpei(){
	$('#comisionTrans').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#comisionIVA').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#montoTransferir').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#totalCargoCuenta').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
	$('#pagarIVA').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
	deshabilitaBoton('graba', 'submit');
	deshabilitaBoton('imprimirCarta', 'submit');

	clave = $('#campoGenerico').val();
	$('#claveRastreo').val(clave);

	transaccion = $('#consecutivo').val();
	$('#numTransaccion').val(transaccion);
	$('#numeroTransaccion').val(transaccion);

	imprimirTicketVentanilla();
	parametroBean = consultaParametrosSession();
	if(parametroBean.mostrarBtnResumen == 'S'){
		campoPantalla = 'clienteID';
		$('#imprimirResumen').show();
		habilitaBoton('imprimirResumen', 'submit');
	}
}

function falloTransaccionSpei(){
}


//funcion que se carga cuando se realiza una transaccion para imprimir el ticket
function imprimirTicketVentanilla(){
	var TipoImpresion=parametroBean.tipoImpTicket;
	var ticket='T';
	if(TipoImpresion !=ticket){
		parametroBean = consultaParametrosSession();

		var cuentaAho = $('#cuentaAhoID').val();
		var cliente = $('#clienteID').val();
		var nombreInstitucion	= parametroBean.nombreInstitucion;
		var sucursal			= parametroBean.sucursal;
		var nomSucursal 		= parametroBean.nombreSucursal;
		var edoMunSuc	        = parametroBean.edoMunSucursal;
		var fecha=parametroBean.fechaSucursal;
		var fechaHora = fecha+"  " +horaSistem();
		var caja=parametroBean.cajaID;
		var claveUsuario=parametroBean.claveUsuario;

		var nombreCliente = $('#nombreOrd').val();
		var totalCargo = $('#totalCargoCuenta').val();
		var totalLetras = $('#totalCargoLetras').val();
		var beneficiario = $('#nombreBeneficiario').val();
		var ctaClaveBen = $('#cuentaBeneficiario').val();
		var bancoBen = $('#instiReceptora').val();
		var nomBancoBen = $('#desbancoSPEI').val();
		var montoSpei = $('#montoTransferir').val();
		var ivaPagar = $('#pagarIVA').val();
		var comisionTransfer = $('#comisionTrans').val();
		var ivaComision = $('#comisionIVA').val();
		var referencia = $('#conceptoPago').val();
		var moneda = $('#monedaID').val();
		var folio = $('#numTransaccion').val();
		var claveRastreo = $('#claveRastreo').val();

		fecha =$('#fecha').val();
		window.open('TransferenciaSpeiTicket.htm?cuentaAhoID='+cuentaAho+
				'&clienteID='+cliente+
				'&nombreInstitucion='+nombreInstitucion+
				'&fechaSistema='+fechaHora+
				'&sucursal='+sucursal+
				'&nomSucursal='+nomSucursal+
				'&nombreOrd='+nombreCliente+
				'&totalCargoCuenta='+totalCargo+
				'&totalCargoLetras='+totalLetras+
				'&nombreBeneficiario='+beneficiario+
				'&cuentaBeneficiario='+ctaClaveBen+
				'&instiReceptora='+bancoBen+
				'&desbancoSPEI='+nomBancoBen+
				'&montoTransferir='+montoSpei+
				'&pagarIVA='+ivaPagar+
				'&comisionTrans='+comisionTransfer+
				'&comisionIVA='+ivaComision+
				'&conceptoPago='+referencia+
				'&monedaID='+moneda+
				'&caja='+caja+
				'&claveUsuario='+claveUsuario+
				'&edoMunSucursal='+edoMunSuc+
				'&folio='+folio+
				'&claveRastreo='+claveRastreo,'_blank');
	}else{
		imprimeTicketSpei();
	}
}

function imprimeTicketSpei(){

	var  impresionTransSpeiBean = {

		'tituloOperacion'	:'TRANSFERENCIA SPEI',
		'folio'				:$('#numTransaccion').val(),
		'claveRastreo'		:$('#claveRastreo').val(),
		'numCuenta'			:$('#cuentaAhoID').val(),
		'clienteID' 		:$('#clienteID').val(),
		'nombreCliente'		:$('#nombreOrd').val(),

		'cuentaBeneficiario':$('#cuentaBeneficiario').val(),
		'desbancoSPEI'		:$('#desbancoSPEI').val(),
		'nombreBeneficiario':$('#nombreBeneficiario').val(),

		'montoTransferir'	:$('#montoTransferir').val(),
		'pagarIVA'			:$('#pagarIVA').val(),
		'comisionTrans'		:$('#comisionTrans').val(),
		'comisionIVA'		:$('#comisionIVA').val(),
		'totalCargoCuenta'	:$('#totalCargoCuenta').val(),

	};

	impTicketTransferenciaSpei(impresionTransSpeiBean);
}

//funcion para obtener la hora del sistema
function horaSistem(){
	var Digital=new Date();
	var hours=Digital.getHours();
	var minutes=Digital.getMinutes();
	var seconds=Digital.getSeconds();
	if (hours<=9)
		hours="0"+hours;
	if (minutes<=9)
		minutes="0"+minutes;
	if (seconds<=9)
		seconds="0"+seconds;
	return  hours+":"+minutes+":"+seconds;
}

// valida los caracteres permitidos para el concepto de pago
function validadorCaracteres(e){
	key=(document.all) ? e.keyCode : e.which;
	if (key < 32 || key > 59){

		if (key >= 63 && key <= 90 ){
			return true;
		}
		else if (key >= 97 && key <= 122 ){
			return true;
		}
		else if (key >= 160 && key <= 165 ){
			return true;
		}
		else if (key == 92 || key == 95 || key == 130 || key == 168 || key == 173 ){
			return true;
		}
		else if (key==8 || key == 0){
			return true;
		}
		else
			return false;
	}
}

// valida que solo se acenten numeros para la referencia
function validadorNumeros(e){
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57){
		if (key==8 || key == 0){
			return true;
		}
		else
			return false;
	}
}

function ocultaBtnImpTicket(){
	$('#imprimirResumen').hide();
	deshabilitaBoton('imprimirResumen', 'submit');
}