$(document).ready(function() {

	var catTipoTransaccionVen = {
		'transferenciaCuenta':'1'
	};
	var EsCliente = 'CTE';
	var parametroBean = consultaParametrosSession();
	$('#sucursalID').val(parametroBean.sucursal);
	$('#fechaSistema').val(parametroBean.fechaAplicacion);
	$('#numeroCaja').val(parametroBean.cajaID);
	deshabilitaControl('monto');
	deshabilitaControl('referencia');
	deshabilitaControl('cuentaAhoIDRecepcion');

	$('#cuentaAhoID').focus();
	deshabilitaBoton('graba', 'submit');

	esTab = true;

	$(':text').focus(function() {
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true','cuentaAhoID', 'funcionExito', 'funcionError');
		}
	});

	$('#graba').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionVen.transferenciaCuenta);
		$('#tipoOperacion').val('10');
	});


	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	//EVENTOS TRANSFERENCIA ENTRE CUENTAS
	$('#cuentaAhoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "clienteID";
			camposLista[1] = "nombreCompleto";
			parametrosLista[0] = 0;
			parametrosLista[1] = $('#cuentaAhoID').val();

			listaAlfanumerica('cuentaAhoID', '2', '13', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
		}
	});

	$('#cuentaAhoID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if(esTab){
			cargoCuentaTrans(this.id);
			if(($('#cuentaAhoIDRecepcion').asNumber() == $('#cuentaAhoID').asNumber()) && $('#cuentaAhoIDRecepcion').asNumber() > 0){
				mensajeSis("La Cuenta Destino es Igual a la Cuenta Origen.");
				deshabilitaBoton('graba', 'submit');
				$('#cuentaAhoID').focus();
			}
			$('#numeroTransaccion').val("");
			$('#numeroMensaje').val("1");
			$('#impTicket').hide();
		}
	});

	$('#monto').blur(function() {
		if( $('#monto').asNumber() > 0 &&  $('#monto').asNumber() <= $('#saldoDisponble').asNumber()
			&& $('#cuentaAhoIDRecepcion').val() > 0 && $('#cuentaAhoID').asNumber() >0
			&& ($('#cuentaAhoIDRecepcion').val() != $('#cuentaAhoID').asNumber())){
			habilitaBoton('graba', 'submit');
		}else if($('#monto').asNumber() <= 0 && esTab){
			mensajeSis("El Monto Debe ser Mayor a 0.");
			deshabilitaBoton('graba', 'submit');
		}else if($('#monto').asNumber() > $('#saldoDisponble').asNumber() && esTab){
			mensajeSis("El Monto No debe ser Mayor al Saldo Disponible.");
			$('#monto').focus();
			deshabilitaBoton('graba', 'submit');
		}

		$('#numeroTransaccion').val("");
		$('#numeroMensaje').val("1");
	});

	$('#cuentaAhoIDRecepcion').change(function() {
		if(($('#cuentaAhoIDRecepcion').asNumber() == $('#cuentaAhoID').asNumber() ) && $('#cuentaAhoID').asNumber() > 0){
			mensajeSis("La Cuenta Destino es Igual a la Cuenta Origen.");
			deshabilitaBoton('graba', 'submit');
			$('#cuentaAhoIDRecepcion').focus();
		}else if($('#cuentaAhoIDRecepcion').asNumber() <= 0){
			deshabilitaBoton('graba', 'submit');
		}
			else if($('#monto').asNumber() > 0 &&  $('#monto').asNumber() <= $('#saldoDisponble').asNumber() && $('#cuentaAhoIDRecepcion').asNumber() > 0){
				consultaClienteCtaTransfers('cuentaAhoIDRecepcion');

		}

		$('#numeroTransaccion').val("");
		$('#numeroMensaje').val("1");
		$('#impTicket').hide();
	});


	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			cuentaAhoID: {
				required : true
			},
			referencia: {
				required : true
			},
			monto: {
				required : true,
				number : true
			},
			cuentaAhoIDRecepcion: {
				required: true
			}
		},
		messages: {
			cuentaAhoID: {
				required: 'Especifica el Número de Cuenta.'
			},
			referencia: {
				required: 'Especifica la Referencia.'
			},
			monto: {
				required: 'Especifique el Monto.',
				number: 'Sólo Números.'
			},
			cuentaAhoIDRecepcion: {
				required: 'Especifica el Número de Cuenta Destino.'
			}
		}
	});

	// FUNCIONES PARA LA TRANSFERENCIA ENTRE CUENTAS
	function cargoCuentaTrans(idControl) { //abonoCuentaTrans
		var jqCta = eval("'#" + idControl + "'");
		var numCta = $(jqCta).val();
		var tipConCampos = 4;
		var CuentaAhoBeanCon = {
			'cuentaAhoID' : numCta
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if (numCta != '' && !isNaN(numCta)) {
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon, function(cuenta) {
				if (cuenta != null) {
					$('#tipoCuentaID').val(cuenta.descripcionTipoCta);
					$('#cuentaAhoID').val(cuenta.cuentaAhoID);
					$('#clienteID').val(cuenta.clienteID);

					var cliente = $('#clienteID').asNumber();
					if (cliente > 0) {
						listaPersBloqBean = consultaListaPersBloq(cliente, EsCliente, cuenta.cuentaAhoID, 0);
						if (listaPersBloqBean.estaBloqueado != 'S') {
							expedienteBean = consultaExpedienteCliente(cliente);
							if (expedienteBean.tiempo <= 1) {
								if (alertaCte(cliente) != 999) {
									habilitaControl('monto');
									habilitaControl('referencia');
									habilitaControl('cuentaAhoIDRecepcion');
									consultaCuentaTransfer(cuenta.clienteID);
									$('#etiquetaCuentaCargo').val(cuenta.etiqueta);
									consultaClienteCuenta('clienteID', 'nombreClienteT');
									consultaSaldoCtaCargoTrans('cuentaAhoID', cuenta.clienteID);
									$('#monto').val('');
									$('#referencia').val('');
									$('#sucursalID').val(parametroBean.sucursal);
									$('#fechaSistema').val(parametroBean.fechaAplicacion);
									$('#numeroCaja').val(parametroBean.cajaID);
									$('#monto').focus();
								}
							} else {
								mensajeSis('Es necesario Actualizar el Expediente del ' + $('#alertSocio').val() + ' para Continuar.');
								$('#cuentaAhoID').focus();
								$('#cuentaAhoID').select();
								$('#saldoDisponble').val('');
								$('#clienteID').val('');
								$('#nombreClienteT').val('');
								$('#tipoCuentaID').val('');
								$('#monto').val('');
								$('#monedaID').val('');
								$('#descripcionMoneda').val('');
								$('#referencia').val('');
							}
						} else {
							mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
							$('#cuentaAhoID').focus();
							$('#cuentaAhoID').select();
							$('#saldoDisponble').val('');
							$('#clienteID').val('');
							$('#nombreClienteT').val('');
							$('#tipoCuentaID').val('');
							$('#monto').val('');
							$('#monedaID').val('');
							$('#descripcionMoneda').val('');
							$('#referencia').val('');
						}
					}
				} else {
					mensajeSis("No Existe la Cuenta de Ahorro.");
					$('#cuentaAhoID').focus();
					$('#cuentaAhoID').select();
					$('#saldoDisponble').val('');
					$('#clienteID').val('');
					$('#nombreClienteT').val('');
					$('#tipoCuentaID').val('');
					$('#monto').val('');
					$('#monedaID').val('');
					$('#descripcionMoneda').val('');
					$('#referencia').val('');

				}
			});
		} else {
			$('#saldoDisponble').val('');
			$('#clienteID').val('');
			$('#nombreClienteT').val('');
			$('#tipoCuentaID').val('');
			$('#monto').val('');
			$('#monedaID').val('');
			$('#descripcionMoneda').val('');
			$('#referencia').val('');
		}
	}

	function consultaCuentaTransfer(numClienteT) {
		var cuentaTranferBean = {
			'clienteID'	:numClienteT
		};

		dwr.util.removeAllOptions('cuentaAhoIDRecepcion');
		dwr.util.addOptions('cuentaAhoIDRecepcion', {'':'SELECCIONAR'});
		cuentasTransferServicio.listaCombo( 3,cuentaTranferBean, {
			async: false, callback:function(cuenta){
				dwr.util.addOptions('cuentaAhoIDRecepcion',cuenta, 'cuentaTranID', 'ctaNomCompletTipoCta');
			}
		});
	}

	function consultaClienteCuenta(idControl,campoNomClie) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var conCliente = 5;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
				if(cliente!=null){
					$('#'+campoNomClie).val(cliente.nombreCompleto);
				}else{
					mensajeSis("No Existe el " + $('#alertSocio').val());
					$(jqCliente).focus();
				}
			});
		}
	}

	function consultaSaldoCtaCargoTrans(idControl,numCte) {
		var jqCta  = eval("'#" + idControl + "'");
		var numCta = $(jqCta).val();
		var tipConCampos = 5;
		var CuentaAhoBeanCon = {
			'cuentaAhoID'	:numCta,
			'clienteID'		:numCte
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if(numCta != '' && !isNaN(numCta)){
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
				if(cuenta!=null){
					$('#saldoDisponble').val(cuenta.saldoDispon);
					$('#descripcionMoneda').val(cuenta.descripcionMoneda);
					$('#monedaID').val(cuenta.monedaID);
				}else{
					mensajeSis("No Existe la Cuenta de Ahorro o No Corresponde a ese " + $('#alertSocio').val());
					$('#cuentaAhoID').focus();
					$('#cuentaAhoID').select();
				}
			});
		}
	}

	// funcion para saber el cliente al que se le hará la transferencia
	function consultaClienteCtaTransfers(idControl){
		var jqCtaTrans  = eval("'#" + idControl + "'");
		var numCtaTransferencia = $(jqCtaTrans).val();
		var tipConCampos= 4;
		var CuentaAhoBeanCon = {
			'cuentaAhoID' : numCtaTransferencia
		};

		if(numCtaTransferencia != '' && !isNaN(numCtaTransferencia)){
			setTimeout("$('#cajaLista').hide();", 200);
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cteTransferCta) {
				if(cteTransferCta!=null){
					$('#numClienteTCtaRecep').val(cteTransferCta.clienteID);
					$('#etiquetaCuentaAbono').val(cteTransferCta.etiqueta);
					$('#tipoTransaccion').val(catTipoTransaccionVen.transferenciaCuenta);
					habilitaBoton('graba', 'submit');
				} else {
					$('#numClienteTCtaRecep').val('');
					$('#etiquetaCuentaAbono').val('');
					mensajeSis("No Existe la Cuenta de Ahorro.");
					$('#cuentaAhoIDRecepcion').select();
				}
			});
		}
	}

	// funcion para  imprimir los tickets imm
	function imprimirTicketTransaccion(BotonOrigen){

		var impresionTransfCuenta={
		    'folio' 	        :$('#numeroTransaccion').val(),
	        'tituloOperacion' 	:'TRASPASO ENTRE CUENTAS',
	        'clienteID' 		:$('#clienteID').val(),
	        'nomCliente' 		:$('#nombreClienteT').val(),
	        'referencia' 		:$('#referencia').val(),
	        'cuentaRetiro' 		:$('#cuentaAhoID').val(),
	        'etiquetaCtaRet' 	:$('#etiquetaCuentaCargo').val(),
	        'tipoCtaRetiro' 	:$('#tipoCuentaID').val(),
	        'cuentaDeposito' 	:$('#cuentaAhoIDRecepcion').val(),
		    'etiquetaCtaDep' 	:$('#etiquetaCuentaAbono').val(),
		    'tipoCtaAbono' 	    :$('#tipoCuentaTC').val(),
		    'monto' 	    	:$('#monto').val(),
		    'moneda'            :monedaBase,
		};

		imprimeTicketTransferencia(impresionTransfCuenta);

	}
});

function funcionExito(){
	$('#referencia').val('');
	$('#monto').val('');
	$('#saldoDisponble').val('');
	$('#monedaID').val('');
	$('#descripcionMoneda').val('');
	$('#nombreClienteT').val('');
	$('#clienteID').val('');
	$('#tipoCuentaID').val('');
	$('#etiquetaCuentaCargo').val('');
	$('#etiquetaCuentaAbono').val('');
	$('#numClienteTCtaRecep').val('');
	$('#sucursalID').val('');
	$('#fechaSistema').val('');
	$('#numeroCaja').val('');
	$('#tipoTransaccion').val('');
	$('#tipoOperacion').val('');
	deshabilitaBoton('graba', 'submit');
	deshabilitaControl('monto');
	deshabilitaControl('referencia');
	deshabilitaControl('cuentaAhoIDRecepcion');
	dwr.util.removeAllOptions('cuentaAhoIDRecepcion');
	dwr.util.addOptions('cuentaAhoIDRecepcion', {'':'SELECCIONAR'});
}


function funcionError(){
}