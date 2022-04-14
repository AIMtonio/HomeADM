var estatus ='';
var filas;
var filasTotal = 0;
var contadorCte = "";
var calificacionCli = "";
var sucursalCli = "";
var generarFormatoAnexo=true;
var productoInvercamex=1;
var esTab = true;
var parametroBean = consultaParametrosSession();
var estatusISR ='';
$(document).ready(function() {
	// Definicion de Constantes y Enums
	var diasBase = parametroBean.diasBaseInversion;
	var salarioMinimo = parametroBean.salMinDF;
	var diaHabilSiguiente = '1'; // indica dia habil Siguiente
	var pusoFecha=0;
	$('#tdCajaRetiro').hide();
	funcionInicializaAltaCedes(); // funcion que inicializa el formulario de alta

	var catTipoTransaccionCede = {
	  		'agrega'  :1,
	  		'modifica': 2
	};
	var catOperacFechas = {
  		'sumaDias'		:1,
  		'restaFechas'	:2,
  		'venDiasSig'	:3,
  		'venDiasSigDom'	:4
	};
	var catStatusCuenta = {
		'activa':	'A'
	};
	var catTipoConsultaCede = {
		'principal' : 1
	};
	var catTipoConsultaTipoCede = {
		'principal':1,
		'general' : 2
	};
	var catTipoListaTipoCede = {
		'tipoCedesAct':3,
		'principal':1
	};
	var catTipoListaCuentas = {
		'foranea': '2'
	};
	var catTipoConsultaCuentas = {
		'conSaldo': 5
	};
	var catTipoConsultaCliente = {
		'paraCedes': 6
	};
	var catTipoListaCede = {
		'principal': 1
	};

	$(':text').focus(function() {
	 	esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	/* SUBMIT */
	$.validator.setDefaults({
		submitHandler: function(event) {
			if(validaRecursos()){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','cedeID','exito','error');
			}
		}
	});

	/* EVENTOS DE LOS BOTONES  */
	$('#agrega').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionCede.agrega);
		$('#tipoTransaccion1').val("");
	});

	$('#modificar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionCede.modifica);

	});

	$('#simular').click(function() {
		consultaSimulador();
	});

	/* EVENTOS DE LAS CAJAS DE TEXTO */
	$('#cedeID').blur(function(){
		if(!isNaN($('#cedeID').val())){
			validaCede(this.id);
		}
	});

	$('#cedeID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreCliente";
		camposLista[1] = "estatus";
		parametrosLista[0] = $('#cedeID').val();
		parametrosLista[1] = 'A';

		lista('cedeID', 1, catTipoListaCede.principal, camposLista, parametrosLista, 'listaCedes.htm');
	});

	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '2', '14', 'nombreCompleto',$('#clienteID').val(), 'listaCliente.htm');
	});

	$('#clienteID').blur(function(){
		consultaCliente($('#clienteID').val());
	});

	$('#cuentaAhoID').blur(function(){
		consultaCtaAho($('#cuentaAhoID').val());
	});

	$('#cuentaAhoID').bind('keyup',function(e){
        var camposLista = new Array();
        var parametrosLista = new Array();
        camposLista[0] = "clienteID";
        parametrosLista[0] = $('#clienteID').val();

        lista('cuentaAhoID', 1, catTipoListaCuentas.foranea, camposLista,
        			parametrosLista, 'cuentasAhoListaVista.htm');
	});

	$('#tipoCedeID').blur(function() {
		if(esTab==true  &  !isNaN($('#tipoCedeID').val())){
			ocultarCajaRetiro();
			validaTipoCede($('#tipoCedeID').val());
			limpiaCondiciones();
			$('#monto').val('');
		}
	});

	$('#tipoPagoInt').blur(function() {
		var tipoPagoInt =$('#tipoPagoInt').val();
		$('#diasPeriodo').val('');
		muestraCampoDias(tipoPagoInt);
	});

	$('#tipoCedeID').bind('keyup',function(e){
		 var camposLista = new Array();
		 var parametrosLista = new Array();
		 camposLista[0] = "descripcion";
		 parametrosLista[0] = $('#tipoCedeID').val();

		lista('tipoCedeID', 2, catTipoListaTipoCede.tipoCedesAct, camposLista,
				 parametrosLista, 'listaTiposCedes.htm');
	});

	$('#reinvertirVenSi').click(function(){
		$('#tipoReinversion').show();
		habilitaControl('tipoReinversion');
	});

	$('#reinvertirVenNo').click(function(){
		$('#tipoReinversion').hide();
		deshabilitaControl('tipoReinversion');
	});
	$('#cajaRetiro').bind('keyup',function(e) {
		lista('cajaRetiro', '2', '6', 'nombreSucurs', $('#cajaRetiro').val(), 'listaSucursales.htm');
	});
	$('#cajaRetiro').blur(function() {
		consultaSucursalCAJA()
	});

	/****** Controles principales *****************/
	$('#monto').blur(function(){
		var tipoCEDE=$('#tipoCedeID').asNumber();
		if(tipoCEDE>0){
			if($('#monto').asNumber() <= $('#totalCuenta').asNumber()){
				pusoFecha=2;
				CalculaValorTasa('monto', false);
				$('#plazoOriginal').focus();
			} else {
				mensajeSis("El monto del CEDE es superior al Saldo en la Cuenta");
				$('#monto').focus();
				$('#monto').val('');
			}
		}else {
			mensajeSis('Especifique el Tipo de Cede');
			$('#tipoCedeID').focus();
			$('#tipoCedeID').val('');
		}
	});

	$('#plazoOriginal').change(function(){
		consultarPlazoFechaVencimiento();
	});

	function consultarPlazoFechaVencimiento(){ // sandra
		var sabDom	='SD';
		var diaInhabil = $('#diaInhabil').val();
		var tipoConsulta = 3;
		if($('#fechaInicio').val()!= ''){
			if($('#plazoOriginal').val() != '' && $('#monto').val() != 0){
				var opeFechaBean = {
					'primerFecha':parametroBean.fechaSucursal,
					'numeroDias':$('#plazoOriginal').val()
				};
				if (diaInhabil == sabDom){
					tipoConsulta = catOperacFechas.venDiasSig;
				}else{
					tipoConsulta = catOperacFechas.venDiasSigDom;
				}
				operacionesFechasServicio.realizaOperacion(opeFechaBean,tipoConsulta,function(data) {
					if(data!=null){
						$('#fechaVencimiento').val(data.fechaHabil);
						$('#plazo').val(data.diasEntreFechas);
						CalculaValorTasa('monto', false);// CALCULA la Tasa de Cede
					}else{
						mensajeSis("Error al Consultar Fechas, intente nuevamente.");
					}
				});
			}else{
				if($('#monto').val() == 0 || $('#monto').val() == ''){
					mensajeSis('Indique un Monto Mayor a 0.');
					$('#monto').focus();
					limpiaCondiciones();
				}else{
					if($('#plazoOriginal').val() == ''){
						limpiaCondiciones();
						mensajeSis('El Plazo esta Vacío.');
					}
				}
			}
		}else{
			mensajeSis("La Fecha de inicio no debe de estar vacia.");
			$('#cedeID').focus();
		}


	}

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		ignore:  ":hidden",
		rules: {
			clienteID: 'required',
			cuentaAhoID: 'required',
			tipoCedeID: 'required',
			monto: {
					required: true,
					number:true
			},
			fechaVencimiento: {
				required :true
			},
			plazoOriginal: 'required',
			tipoPagoInt: 'required',
			cajaRetiro:{
				required: true,
			},
			diasPeriodo: {
				required : function() {return $('#tipoPagoInt').val() == 'P';}
			}
		},

		messages: {
			clienteID: 'Especifique número de '+$('#socioCliente').val()+'',
			cuentaAhoID: 'Especifique la cuenta',
			tipoCedeID:'Especifique el tipo de CEDE',
			monto: {
				required: 'Especifique monto',
				number:'Sólo Números'
			},
			fechaVencimiento:{
				required :'Especifique la fecha de vencimiento'
			},
			plazoOriginal: 'Especifique el plazo de la CEDE',
			tipoPagoInt: 'Especifique un Tipo de Pago',
			cajaRetiro: 'Especifique la Caja de Retiro',
			diasPeriodo: {
				required : 'Especifique el Número de Días de Periodo.'
			}
		},
	});


    /* Valida el tipo de CEDES cuando se encuentre parametrizado dia inhábil: Sabado y Domingo
     * para que no se registren CEDES el día Sábado */
	function validaSabadoDomingo(){
		var fecha = parametroBean.fechaSucursal;
		var diaInhabil = $('#diaInhabil').val();
		var cede = $('#cedeID').val();
		var sabDom	='SD';
		var noEsFechaHabil = 'N';
		var tipoCedeID = $('#tipoCedeID').val();
		var diaInhabilBean = {
				'fecha': fecha,
				'numeroDias': 0,
				'salidaPantalla':'S',
		};
		if (cede == 0){
			if (diaInhabil == sabDom){
				var sabado = 'Sábado y Domingo';
				diaFestivoServicio.calculaDiaFestivo(3,diaInhabilBean,function(data){
					if(data!=null){
						$('#esDiaHabil').val(data.esFechaHabil);
						if($('#esDiaHabil').val() == noEsFechaHabil){
							mensajeSis("El Tipo de CEDE seleccionado no puede asignarse en: " + sabado +
									" por tal motivo  no se puede registrar el CEDE.");
							$('#tipoCedeID').focus();
							$('#tipoCedeID').select();
							$('#tipoCedeID').val('');
							$('#descripcion').val('');
							$('#diaInhabil').val('');
							$('#esDiaHabil').val('');
							deshabilitaBoton('agrega', 'submit');
						}
					}
				});
			}
			else{
				habilitaBoton('agrega', 'submit');
			}
		}
	}

	function validaCede(idControl){
		var jqCede = eval("'#" + idControl + "'");
		var numCede = $(jqCede).val();
		$('#contenedorSim').hide();
		$('#contenedorSimulador').hide();
		if(numCede == '0'){
			$('#cuentaAhoID').val("");
			habilita();
			habilitaBoton('agrega', 'submit');
			habilitaBoton('simular', 'submit');
			deshabilitaBoton('modificar', 'submit');
			inicializaForma('formaGenerica','cedeID');
			$('#reinvertirVenSi').attr('checked',false);
			$('#reinvertirVenNo').attr('checked',false);
			$('#cuentaAhoID').val("");
			$('#plazo').val("");
			$('#plazoOriginal').val('');
			$('#interesRecibir').val("");
			$('#interesRetener').val("");
			$('#tipoPagoInt').val("");
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}else{
			deshabilitaBoton('agrega', 'submit');
			deshabilitaBoton('simular', 'submit');
			deshabilitaBoton('modificar', 'submit');
			if(numCede != '' && numCede >0  && esTab == true){
				var CedeBean = {
					'cedeID' : numCede
				};
				cedesServicio.consulta(catTipoConsultaCede.principal, CedeBean, { async: false, callback: function(cede){
					if(cede!=null){
						comboListaPlazos(cede.tipoCedeID);
						$('#cuentaAhoID').val(cede.cuentaAhoID);
						$('#tipoCedeID').val(cede.tipoCedeID);
						$('#monto').val(cede.monto);
						$('#plazo').val(cede.plazo);
						$('#plazoOriginal').val(cede.plazoOriginal);
						$('#fechaInicio').val(cede.fechaInicio);
						$('#fechaVencimiento').val(cede.fechaVencimiento);
						if ($('#plazoOriginal').val()==""){
							$('#plazoOriginal').append($('<option>', {
								    value: cede.plazoOriginal,
								    text: cede.plazoOriginal
								}));
							$('#plazoOriginal').val(cede.plazoOriginal);

						}
						$('#tasaFija').val(cede.tasaFija);
						$('#tasaISR').val(cede.tasaISR);
						$('#tasaNeta').val(cede.tasaNeta);
						$('#valorGat').val(cede.valorGat);
						estatusISR = cede.estatusISR;
						$('#interesGenerado').val(cede.interesGenerado);
						$('#interesRetener').val(cede.interesRetener);
						$('#interesRecibir').val(cede.interesRecibir);
						$('#valorGatReal').val(cede.valorGatReal);
						$('#granTotal').val(cede.totalRecibir);
						$('#cajaRetiro').val(cede.cajaRetiro);
						$('#pagoIntCal').val(cede.pagoIntCal);
						consultaSucursalCAJA();

						if(cede.cedeMadreID !=0){
							mensajeSis("El CEDE se encuentra Anclado y no puede ser Modificado");
							deshabilitaBoton('agrega', 'submit');
							deshabilitaBoton('modificar', 'submit');
							deshabilitaBoton('simular', 'submit');
							deshabilita();
						}else{
							if(cede.estatus == 'A'){
								if(cede.fechaInicio != parametroBean.fechaSucursal){
									mensajeSis("El CEDE no es del Día de Hoy");
									deshabilitaBoton('agrega', 'submit');
									deshabilitaBoton('modificar', 'submit');
									deshabilitaBoton('simular', 'submit');
									deshabilita();
								}else{
									habilitaBoton('modificar', 'submit');
									habilitaBoton('simular', 'submit');
									varError = 0;
									habilita();
								}
							}else{
								deshabilitaBoton('agrega', 'submit');
								deshabilitaBoton('modificar', 'submit');
								deshabilitaBoton('simular', 'submit');
								deshabilita();
								if(cede.estatus == 'N'){
									mensajeSis("El CEDE ha sido cargado a cuenta y no puede ser Modificado.");
								}else if(cede.estatus == 'C'){
									mensajeSis("El CEDE ha sido cancelado y no puede ser Modificado.");
								}else if(cede.estatus == 'P'){
									mensajeSis("El CEDE se encuentra Pagado (Abonado a Cuenta).");
								}else if(cede.estatus == 'V'){
									mensajeSis("El CEDE se encuentra Vencido y no puede ser Modificado.");
								}
							}
						}
						
						$('#estatusCede').val(cede.estatus);
						validaTipoCedeMod(cede.tipoCedeID, cede.reinvertir, cede.reinversion,cede.tipoPagoInt,cede.diasPeriodo);
						consultaCtaAho(cede.cuentaAhoID);
						consultaCliente(cede.clienteID, cede.estatus);
						CalculaValorTasa('monto',true);
						$('#telefono').setMask('phone-us');
						$('#monto').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
						agregaFormatoControles('formaGenerica');
					}else{
						mensajeSis("El CEDE no existe");
						$('#cedeID').focus();
						$('#cedeID').val('');
					}
				}});
			}
		}
	}



	/* CONSULTAR CLIENTE */
	function consultaCliente(numCliente, estatusCede) {
		var rfc = ' ';
		var NOPagaISR = 'N';
		if (numCliente != '0') {
			setTimeout("$('#cajaLista').hide();", 200);
			if (alertaCte(numCliente) != 999) {
				if (numCliente != '' && !isNaN(numCliente)) {
					if ($('#cedeID').val() == 0) {
						funcionLimpiar();
					}
					clienteServicio.consulta(catTipoConsultaCliente.paraCedes, numCliente, rfc, {
					async : false,
					callback : function(cliente) {
						if (cliente != null) {
							$('#clienteID').val(cliente.numero);
							$('#nombreCompleto').val(cliente.nombreCompleto);
							if (/*cliente.esMenorEdad == "N"*/1 == 1) {
								calificacionCli = cliente.calificaCredito;
								sucursalCli = cliente.sucursalOrigen;
								$('#telefono').val(cliente.telefonoCasa);
								$('#telefono').setMask('phone-us');
								if (cliente.pagaISR == NOPagaISR) {
									$('#tasaISR').val(0);
								} else {
									$('#tasaISR').val(parametroBean.tasaISR);
								}
								consultaDireccion(cliente.numero);
								consultaHuellaCliente();

								if (estatusCede == 'A' || estatusCede == undefined) {
									consultaDatosAdicionales(cliente.numero);
								}

								if (cliente.estatus == "I") {
									deshabilitaBoton('modificar', 'submit');
									deshabilitaBoton('agrega', 'submit');
									mensajeSis("El " + $('#socioCliente').val() + " se encuentra Inactivo");
									$('#clienteID').focus();
								}
							} else {
								mensajeSis("El " + $('#socioCliente').val() + " es Menor de Edad.");
								$('#clienteID').focus();
								$('#clienteID').val('');
								$('#nombreCompleto').val('');
								$('#direccion').val('');
								$('#telefono').val('');
							}
						} else {
							mensajeSis("El " + $('#socioCliente').val() + " No Existe.");
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
	}

	/* CONSULTAR DIRECCION */
	function consultaDireccion(numCliente) {
		var conOficial = 3;
		var direccionCliente = {
  			'clienteID':numCliente
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCliente != '' && !isNaN(numCliente)){
			direccionesClienteServicio.consulta(conOficial,direccionCliente, { async: false, callback: function(direccion) {
				if(direccion!=null){
					$('#direccion').val(direccion.direccionCompleta);
				}else{
					$('#direccion').val('');
				}
			}
			});
		}
	}


	function consultaCtaAho(numCta) {
		var CuentaAhoBeanCon = {
			'cuentaAhoID':numCta,
			'clienteID':$('#clienteID').val()
		};
		if(numCta != '' && !isNaN(numCta) ){
			cuentasAhoServicio.consultaCuentasAho(catTipoConsultaCuentas.conSaldo,CuentaAhoBeanCon, { async: false, callback: function(cuenta) {
				if(cuenta!=null){
					if(cuenta.saldoDispon!=null){
						$('#cuentaAhoID').val(cuenta.cuentaAhoID);
            			$('#totalCuenta').val(cuenta.saldoDispon);
                		$('#tipoMoneda').html(cuenta.descripcionMoneda);
                		$('#tipoMonedaInv').html(cuenta.descripcionMoneda);
                		$('#monedaID').val(cuenta.monedaID);
                		if(cuenta.estatus == catStatusCuenta.activa){
                			calculaCondicionesCede();
                		}else{
                			mensajeSis("La Cuenta no esta Activa");
	              			$('#cuentaAhoID').focus();
	  		          		$('#cuentaAhoID').val('');
                		}
					}else{
						mensajeSis("La Cuenta no tiene saldo Disponible");
						$('#cuentaAhoID').focus();
						$('#cuentaAhoID').select();
					}
				}else{
					mensajeSis("La Cuenta no Existe");
					$('#totalCuenta').val("");
					$('#cuentaAhoID').focus();
					$('#cuentaAhoID').val('');
				}
			}});
		}
	}

	function validaTipoCede(tipCede){
		var TipoCedeBean ={
			'tipoCedeID' :tipCede
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(tipCede != '' && !isNaN(tipCede) && esTab){
			if(tipCede != 0){
				tiposCedesServicio.consulta(catTipoConsultaTipoCede.general,TipoCedeBean, { async: false, callback: function(tipoCede){
					if(tipoCede!=null){
						if((tipoCede.estatus == 'I' && $('#estatusCede').val() == 'A') || (tipoCede.estatus == 'I' && $('#cedeID').val() == 0) ){
							$('#tipoCedeID').val('');
							$('#descripcion').val('');
							$('#diaInhabil').val('');
							$('#pagoIntCal').val('');
							$('#tipoCedeID').focus();
							$('#tasaFV').val('');
							dwr.util.removeAllOptions('plazoOriginal');
							dwr.util.addOptions( "plazoOriginal", {'':'SELECCIONAR'});
							dwr.util.removeAllOptions('tipoPagoInt');
							dwr.util.addOptions( "tipoPagoInt", {'':'SELECCIONAR'});
							mensajeSis("El Producto "+tipoCede.descripcion+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
						}else{
							comboListaPlazos(tipCede);
							$('#tasaFV').val(tipoCede.tasaFV);
							mostrarSeccionTasa(tipoCede.tasaFV); //Funcion para mostrar la seccion de tasa correcta
							$('#descripcion').val(tipoCede.descripcion);
							$('#tipoCedeID').val(tipoCede.tipoCedeID);
							$('#diaInhabil').val(tipoCede.diaInhabil);
							$('#pagoIntCal').val(tipoCede.pagoIntCal);
							validaSabadoDomingo();
							evaluaReinversion(tipoCede.reinversion,tipoCede.reinvertir);
							// se llenan los valores de los combos segun lo parametrizado
							consultaComboFormaPago(tipoCede.tipoPagoInt,tipoCede.diasPeriodo);
						}
					}else{
						$('#descripcion').val('');
						$('#diaInhabil').val('');
						mensajeSis("El tipo de CEDE no Existe.");
						$('#tipoCedeID').focus();
						$('#tipoCedeID').val('');
						$('#pagoIntCal').val('');
					}
				}});
			}
		}
	}



	// funcion que llena el combo de la forma de pago de interes
	function consultaComboFormaPago(tipoPagoInt,diasPeriodo) {
		if (tipoPagoInt != null) {
			$('#tipoPagoInt').each(function() {
				$('#tipoPagoInt option').remove();
			});
			// se agrega la opcion por default
			$('#tipoPagoInt').append(
					new Option('SELECCIONAR', '', true, true));

			var tipoPago = tipoPagoInt.split(',');
			var tamanio = tipoPago.length;

			for ( var i = 0; i < tamanio; i++) {
				var tipoPagoDescrip = '';

				switch (tipoPago[i]) {
				case "V": // VENCIMIENTO
					tipoPagoDescrip = 'AL VENCIMIENTO';
					break;
				case "F": // FIN DE MES
					tipoPagoDescrip = 'FIN DE MES';
					break;
				case "P":// PERIODO
					tipoPagoDescrip = 'POR PERIODO';
					break;
				default:
					tipoPagoDescrip = 'POR PERIODO';
				}
				$('#tipoPagoInt').append(
						new Option(tipoPagoDescrip, tipoPago[i], true,
								true));
				$('#tipoPagoInt').val('').selected = true;
			}
		}consultaComboDiasPer(diasPeriodo);
	}

	// funcion que llena el combo de tipos de interes cuando se consulta el cede
	function consultaComboDiasPer(diasPeriodo) {
		if (diasPeriodo != null) {
			// se eliminan los tipos de pago que se tenian
			$('#diasPeriodo').each(function() {
				$('#diasPeriodo option').remove();
			});
			// se agrega la opcion por default
			$('#diasPeriodo').append(
					new Option('SELECCIONAR', '', true, true));

			var diasPer = diasPeriodo.split(',');
			var tamanio = diasPer.length;

			for ( var i = 0; i < tamanio; i++) {
				var diasPerDescrip = '';
				diasPerDescrip = diasPer[i].concat(" Días");

				$('#diasPeriodo').append(
						new Option(diasPerDescrip, diasPer[i], true,
								true));
				$('#diasPeriodo').val('').selected = true;
			}
		}
	}



	function muestraCampoDias(tipoPagoInt){
		var tipoPago  = eval("'" + tipoPagoInt + "'");
		var Periodo ='P';
		var valor= tipoPago.split(",");
		for(var i=0; i< valor.length; i++){
			var tipoPagInt = valor[i];
			if(tipoPagInt == Periodo){
				$('#diasPeriodo').show();
				$('#lbldiasPeriodo').show();
				$('#diasPeriodo').focus();
			}else{
				$('#diasPeriodo').hide();
				$('#lbldiasPeriodo').hide();
			}
		}
	}

	function validaTipoCedeMod(tipCede, reinvertir, reinversion, tipoPagoInt, diasPeriodo){
		var TipoCedeBean ={
			'tipoCedeID' :tipCede
		};
		if(tipCede != '' && !isNaN(tipCede) ){
			if(tipCede != 0){
				tiposCedesServicio.consulta(catTipoConsultaTipoCede.general,
													TipoCedeBean, { async: false, callback: function(tipoCede){
					if(tipoCede!=null){
						$('#tasaFV').val(tipoCede.tasaFV);
						mostrarSeccionTasa(tipoCede.tasaFV); //Funcion para mostrar la seccion de tasa correcta
						$('#descripcion').val(tipoCede.descripcion);
						$('#tipoCedeID').val(tipoCede.tipoCedeID);
						$('#diaInhabil').val(tipoCede.diaInhabil);
						if(tipoCede.reinversion == 'I'){
							evaluaReinversionMod(reinvertir,reinversion,tipoCede.reinvertir,tipoCede.reinversion);
						}else{
							if(tipoCede.reinversion == 'S' && reinversion == 'S'){
								if(tipoCede.reinvertir == 'I'){
									evaluaReinversionMod(reinvertir,reinversion,tipoCede.reinvertir,tipoCede.reinversion);
								}else{
									if(tipoCede.reinvertir == reinvertir){
										evaluaReinversionMod(reinvertir,reinversion,tipoCede.reinvertir,tipoCede.reinversion);
									}else{
										evaluaReinversion(tipoCede.reinversion,tipoCede.reinvertir);
										mensajeSis('Las Condiciones de Reinversión no Coinciden.');
									}
								}
							}else{
								if(tipoCede.reinversion == 'N' && reinversion == 'N'){
									evaluaReinversionMod(reinvertir,reinversion,tipoCede.reinvertir,tipoCede.reinversion);
								}else{
									evaluaReinversion(tipoCede.reinversion,tipoCede.reinvertir);
									mensajeSis('Las Condiciones de Reinversión no Coinciden.');
								}
							}
						}
						consultaComboTipoPagoCon(tipoCede.tipoPagoInt,tipoPagoInt,tipoCede.diasPeriodo,diasPeriodo);
					}else{
						$('#descripcion').val('');
						$('#diaInhabil').val('');
						mensajeSis("El tipo de CEDE no Existe.");
						$('#tipoCedeID').focus();
						$('#tipoCedeID').val('');
					}
				  }
				});
			}
		}
	}


	// funcion que llena el combo de tipos de interes cuando se consulta el cede
	function consultaComboTipoPagoCon(tipoPagoInt,valorTipoPagoInt,diasPeriodo,valorDiasPeriodo) {
		if (tipoPagoInt != null) {
			// se eliminan los tipos de pago que se tenian
			$('#tipoPagoInt').each(function() {
				$('#tipoPagoInt option').remove();
			});
			// se agrega la opcion por default
			$('#tipoPagoInt').append(
					new Option('SELECCIONAR', '', true, true));

			var tipoPago = tipoPagoInt.split(',');
			var tamanio = tipoPago.length;

			for ( var i = 0; i < tamanio; i++) {
				var tipoPagoDescrip = '';

				switch (tipoPago[i]) {
				case "V": // AL VENCIMIENTO
					tipoPagoDescrip = 'AL VENCIMIENTO';
					break;
				case "F": // FIN MES
					tipoPagoDescrip = 'FIN DE MES';
					break;
				case "P":// PERIODO
					tipoPagoDescrip = 'POR PERIODO';
					break;
				default:
					tipoPagoDescrip = 'POR PERIODO';
				}
				$('#tipoPagoInt').append(
						new Option(tipoPagoDescrip, tipoPago[i], true,
								true));
				$('#tipoPagoInt').val(valorTipoPagoInt).selected = true;

			}

		}muestraCampoDiasCon(valorTipoPagoInt,diasPeriodo,valorDiasPeriodo);
	}

	function muestraCampoDiasCon(valorTipoPagoInt,diasPeriodo,valorDiasPeriodo){
		var valortipoPago  = eval("'" + valorTipoPagoInt + "'");
		var Periodo ='P';
		var valor= valortipoPago.split(",");
		for(var i=0; i< valor.length; i++){
			var vartipoPagInt = valor[i];
			if(vartipoPagInt == Periodo){
				$('#diasPeriodo').show();
				$('#lbldiasPeriodo').show();
			}else{
				$('#diasPeriodo').hide();
				$('#lbldiasPeriodo').hide();
			}
		}consultaComboDiasPerCon(diasPeriodo,valorDiasPeriodo);
	}

	// funcion que llena el combo de tipos de interes cuando se consulta el cede
	function consultaComboDiasPerCon(diasPeriodo,valorDiasPeriodo) {
		if (diasPeriodo != null) {
			// se eliminan los tipos de pago que se tenian
			$('#diasPeriodo').each(function() {
				$('#diasPeriodo option').remove();
			});
			// se agrega la opcion por default
			$('#diasPeriodo').append(
					new Option('SELECCIONAR', '', true, true));

			var diasPer = diasPeriodo.split(',');
			var tamanio = diasPer.length;

			for ( var i = 0; i < tamanio; i++) {
				var diasPerDescrip = '';
				diasPerDescrip = diasPer[i].concat(" Días");

				$('#diasPeriodo').append(
						new Option(diasPerDescrip, diasPer[i], true,
								true));
				$('#diasPeriodo').val(valorDiasPeriodo).selected = true;
			}
		}
	}


	/*Funcion para mostrar o ocultar la sección de tasa variable*/
	function mostrarSeccionTasa(tipoTasa){
		if(tipoTasa=='F'){
			ocultaTasaVariable();
		}else{
			if(tipoTasa=='V'){
				muestraTasaVariable();
			}else{
				mensajeSis("El tipo de tasa no es correcto "+ tipoTasa);
			}
		}
	}

	/**
	 * Funciones de validaciones y calculos
	 * @param idControl id del control monto.
	 * @param consultaCedes Valor boleano que indica que la función fue llamada al consultar un CEDE existente.
	 * @author avelasco
	 */
	function CalculaValorTasa(idControl, consultaCedes){
		var jqControl = eval("'#" + idControl + "'");
		var tipoCon = 2;
		var cantidad = creaBeanTasaCede();
		if(cantidad.monto <= $('#totalCuenta').asNumber()){
			if($('#plazo').val() != '' && $('#plazo').val() != 0
					&& $('#monto').val() != '' && $('#monto').val() != 0){
				var variables = creaBeanTasaCede();
				tasasCedesServicio.consulta(tipoCon,variables, { async: false, callback: function(porcentaje){
					if((porcentaje.tasaAnualizada !=0 && porcentaje.tasaAnualizada != null)  || (porcentaje.tasaBase>0 && porcentaje.tasaBase != null)){
						if($('#tasaFV').val()=='F' && porcentaje.tasaAnualizada>0){
							$('#tasaFija').val(porcentaje.tasaAnualizada);
							$('#tasaFija').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 4});
							$('#calculoInteres').val('1');
							$('#tasaBaseID').val('0');
							$('#sobreTasa').val('0.0');
							$('#pisoTasa').val('0.0');
							$('#techoTasa').val('0.0');
							$('#valorTasaBaseID').val('0.0');
						}
						if($('#tasaFV').val()=='V' && porcentaje.tasaBase>0){
							$('#tasaFija').val(porcentaje.tasaAnualizada);
							$('#tasaFija').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 4});
							$('#calculoInteres').val(porcentaje.calculoInteres);
							$('#tasaBaseID').val(porcentaje.tasaBase);
							$('#sobreTasa').val(porcentaje.sobreTasa);
							$('#pisoTasa').val(porcentaje.pisoTasa);
							$('#techoTasa').val(porcentaje.techoTasa);
							$('#valorTasaBaseID').val(porcentaje.tasaAnualizada);
							seleccionaCalculo(porcentaje.calculoInteres);
							validaTasaBase(porcentaje.tasaBase);
						}
						$('#valorGat').val(porcentaje.valorGat);
						$('#valorGatReal').val(porcentaje.valorGatReal);
						$('#valorGat').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 4});
						$('#valorGatReal').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 4});

						//Habilita los Botones de Grabar o Modificar
						if(!isNaN($('#cedeID').val())){
							if ($('#cedeID').asNumber()==0 ||$('#cedeID').val()==''){
								habilitaBoton('agrega', 'submit');
								habilita();
							}
						}
						if(!consultaCedes){
							inicializaValoresCamposInteres();
						}
					}else{
						mensajeSis("No existe una Tasa Anualizada");
						limpiaCondiciones();
						$('#plazoOriginal').val('');
						$('#monto').val('');
						$('#monto').focus();
					}
				}});
			}
		}
	}


	function seleccionaCalculo(calculoInteres){
		switch(calculoInteres){
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

	// Carga Grid, funcion para consultar el calendario de pagos de CEDE */
	function consultaSimulador(){
		if(validaSimulador() == 0){
			var params = {};
			params['tipoLista']		= 2;
			params['fechaInicio']	= $('#fechaInicio').val();
			params['fechaVencimiento'] = $('#fechaVencimiento').val();
			params['monto']			= $('#monto').asNumber();
			params['clienteID']		= $('#clienteID').val();
			params['tipoCedeID']	= $('#tipoCedeID').val();
			params['tasaFija']		= $('#tasaFija').val();
			params['tipoPagoInt']	= $('#tipoPagoInt').val();
			params['diasPeriodo']	= $('#diasPeriodo').val();
			params['pagoIntCal']	= $('#pagoIntCal').val();

			$.post("simuladorPagosCedes.htm", params, function(simular){
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
					$("#varTotalFinal").text(formatoMonedaVariable(varTotalFinal,true));
					$("#varTotalInteres").text(formatoMonedaVariable(varTotalInteres,true));
					$("#varTotalISR").text(formatoMonedaVariable(varTotalISR,true));
					$("#varTotalCapital").text(formatoMonedaVariable(varTotalCapital,true));

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
		if($('#tipoPagoInt').val() != 'V' &&  $('#tipoPagoInt').val() != 'F' &&  $('#tipoPagoInt').val() != 'P'){
			mensajeSis('Indique el Tipo de Pago.');
			$('#tipoPagoInt').focus();
			return 1;
		}
		if($('#monto').asNumber() <= 0){
			mensajeSis('Indique un Monto Mayor a 0.');
			$('#monto').focus();
			return 1;
		}
		if($('#plazoOriginal').asNumber() <= 0){
			mensajeSis('Indique un Plazo Mayor a 0.');
			$('#plazoOriginal').focus();
			return 1;
		}
		return 0;
	}

	function creaBeanTasaCede(){
		var tasasCedeBean = {
				'tipoCedeID' 	  : $('#tipoCedeID').val(),
				'plazo' 		  : $('#plazoOriginal').val(),
				'monto' 		  : $('#monto').asNumber(),
				'calificacion' 	  :  calificacionCli ,
				'sucursalID'  	  :  parametroBean.sucursal
		};
		return tasasCedeBean;
	}

	function calculaCondicionesCede(){
		if(estatusISR != 'A'){
			var interGenerado;
			var interRetener;
			var interRecibir;
			var total;
			var tasa;

			if($('#monto').asNumber()>0){
				if($('#tasaFV').val()=='V'){
					tasa=$('#valorTasaBaseID').asNumber();
				}
				if($('#tasaFV').val()=='F'){
					tasa=$('#tasaFija').asNumber();
				}
				if($('#tasaISR').asNumber()<=tasa){
					$('#tasaNeta').val( tasa - $('#tasaISR').asNumber());
					$('#tasaISR').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 4	});
				}else{
					$('#tasaNeta').val(0.00);
				}
				$('#tasaNeta').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 4});
				$('#tasaISR').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 4	});
				$('#tasaFija').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 4	});
				if(!isNaN(tasa) && tasa!=''){
					interGenerado = (($('#monto').asNumber() * tasa * $('#plazo').asNumber()) / (diasBase*100)).toFixed(2);
				}
				$('#interesGenerado').val(interGenerado);
				$('#interesGenerado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
				diasBase = parametroBean.diasBaseInversion;
				salarioMinimo = parametroBean.salMinDF;
				var salarioMinimoGralAnu = parametroBean.salMinDF * 5 * parametroBean.diasBaseInversion; // Salario minimo General Anualizado
				// SI EL MONTO DE INVERSION es MAYOR O IGUAL A 5 Salario minimo General Anualizado Distrito Federal segun DF,(SMAGDF),
				//entonces se aplica el calculo de ISR PERO SOBRE EL EXCEDENTE DE CAPITAL NO SOBRE EL CAPITAL ORIGINAL,
				// si no es CERO
				// Al pagar intereses a una persona moral siempre se le debe retener ISR sobre el monto total sin contemplar exención alguna.
				var vartipoPersona = '';

				clienteServicio.consulta(1,$('#clienteID').val(),function(cliente) {
					if(cliente!=null){
						vartipoPersona=cliente.tipoPersona;
					}
				});

				 if ($('#monto').asNumber() > salarioMinimoGralAnu || vartipoPersona == 'M') {
					 if(vartipoPersona == 'M'){
						 interRetener = (($('#monto').asNumber() * $('#tasaISR').val() * $('#plazo').val()) / (diasBase * 100)).toFixed(2);
					 }else{
						 interRetener = ((($('#monto').asNumber() - salarioMinimoGralAnu) * $('#tasaISR').val() * $('#plazo').val()) / (diasBase * 100)).toFixed(2);
					 }
				 } else {
					 interRetener = 0.00;
				 }


				$('#interesRetener').val(interRetener);
				$('#interesRetener').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

				interRecibir = interGenerado - interRetener;
				if(!isNaN(interRecibir)){
					$('#interesRecibir').val(interRecibir);
				}
				$('#interesRecibir').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

				total = $('#monto').asNumber() + interRecibir;

				$('#granTotal').val(total);
				$('#granTotal').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
			}
		}
	}

	function funcionLimpiar(){
		$('#cuentaAhoID').val("");
		$('#tipoCedeID').val("");
		$('#descripcion').val("");
		$('#diaInhabil').val("");
		$('#totalCuenta').val("");
		$('#tipoPagoInt').val("");
		$('#diasPeriodo').hide();
		$('#diasPeriodo').val('');
		$('#lbldiasPeriodo').hide();
		$('#pagoIntCal').val('');
	}

	function limpiaCondiciones() {
		$('#plazoOriginal').val('');
		$('#plazo').val("");
		$('#tasa').val("0.00");
		$('#tasaFija').val("0.00");
		$('#fechaVencimiento').val("");
		$('#interesRetener').val("0.00");
		$('#tasaNeta').val("0.00");
		$('#interesRecibir').val("0.00");
		$('#interesGenerado').val("0.00");
		$('#valorGat').val("");
		$('#valorGatReal').val("");
		$('#granTotal').val('');
	}

	function deshabilita(){
		deshabilitaControl('clienteID');
		deshabilitaControl('cuentaAhoID');
		deshabilitaControl('tipoCedeID');
		deshabilitaControl('monto');
	}

	function habilita(){
		habilitaControl('clienteID');
		habilitaControl('cuentaAhoID');
		habilitaControl('tipoCedeID');
		habilitaControl('monto');
	}

	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){
		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("formato de fecha no válido (aaaa-mm-dd)");
				return false;
			}
			var mes=  fecha.substring(5, 7)*1;
			var dia= fecha.substring(8, 10)*1;
			var anio= fecha.substring(0,4)*1;
			switch(mes){
			case 1: case 3:  case 5: case 7:
			case 8: case 10:
			case 12:
				numDias=31;
				break;
			case 4: case 6: case 9: case 11:
				numDias=30;
				break;
			case 2:
				if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
				break;
			default:
				mensajeSis("Fecha introducida errónea.");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea.");
				return false;
			}
			return true;
		}
	}

	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}else {
			return false;
		}
	}

	// función para consultar si el cliente ya tiene huella digital registrada
	function consultaHuellaCliente(){
		var numCliente=$('#clienteID').val();
		if(numCliente != '' && !isNaN(numCliente )){
			var clienteIDBean = {
				'personaID':$('#clienteID').val()
				};
			huellaDigitalServicio.consulta(1,clienteIDBean, { async: false, callback: function(cliente) {
				if (cliente==null){
					var huella=parametroBean.funcionHuella;
					if(huella =="S" && huellaProductos=="S"){
						mensajeSis("El Cliente no tiene Huella Registrada.\nFavor de Verificar.");
						$('#clienteID').focus();
						deshabilitaBoton('agrega','submit');
					}else{
						if($("#cedeID").val() == 0){
							habilitaBoton('agrega','submit');
						}
					}
				}else{
					if($("#cedeID").val() == 0){
						habilitaBoton('agrega','submit');
					}
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
				'empresaID'	:numEmpresaID
		};
		parametrosSisServicio.consulta(tipoCon,ParametrosSisBean, { async: false, callback:function(parametrosSisBean) {
			if (parametrosSisBean != null) {
				if(parametrosSisBean.reqhuellaProductos !=null){
					huellaProductos=parametrosSisBean.reqhuellaProductos;
				}else{
					huellaProductos="N";
				}
			}
		}});
	}

	function muestraTasaVariable(){
		$('#tdlblCalculoInteres').show();
		$('#tdcalculoInteres').show();
		$('#tdlblTasaBaseID').show();
		$('#tdDesTasaBaseID').show();
		$('#trVariable1').show();
	}

	function ocultaTasaVariable(){
		$('#tdlblCalculoInteres').hide();
		$('#tdcalculoInteres').hide();
		$('#tdlblTasaBaseID').hide();
		$('#tdDesTasaBaseID').hide();
		$('#trVariable1').hide();
	}

	function validaTasaBase(tasaBase){
		var TasaBaseBeanCon = {
  			'tasaBaseID':tasaBase
		};
		tasasBaseServicio.consulta(1,TasaBaseBeanCon , { async: false, callback: function(tasasBaseBean) {
			if(tasasBaseBean!=null){
				$('#destasaBaseID').val(tasasBaseBean.nombre);
			}else{
				mensajeSis("No Existe la tasa base");
			}
		}});
	}

	function consultaDatosAdicionales(numeroCli){
		var tipoCon = 25;
		var totalInv="";
		var totalCede="";

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
		}});

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
		}});

		/*Se consulta el total de CEDES del cliente */
		var CedeBean = {
				'clienteID': numeroCli
				};
		cedesServicio.consulta(3,CedeBean, { async: false, callback: function(cede) {
			if (cede != null) {
				if(cede.numCedes != "0"){
					totalCede = parseInt(cede.numCedes);
				}else{
					totalCede = 0;
				}
				contadorCte = contadorCte + totalCede ;
			}
		  }
		});

		if(contadorCte > 0){
			$('#ahorradorSAFI').val("S");
			$('#productoSAFI').val(contadorCte);

		}else{
			$('#ahorradorSAFI').val("N");
			$('#productoSAFI').val("");
		}
	}

	//------------ EVALUA INVERSION
	function evaluaReinversion(reinversion, tipoReinversion){
		dwr.util.removeAllOptions('tipoReinversion');
		$('#reinvertirVenSi').attr('checked',false);
		$('#reinvertirVenNo').attr('checked',false);
		if (reinversion == 'S') {
			habilitaControl('reinvertirVenSi');
			deshabilitaControl('reinvertirVenNo');
			$('#tipoReinversion').hide();
			if (tipoReinversion == "C") {
				dwr.util.addOptions( "tipoReinversion", {'C':'SOLO CAPITAL'});
			}else if(tipoReinversion == "CI"){
				dwr.util.addOptions( "tipoReinversion", {'CI': 'CAPITAL MAS INTERES'});
			}else{
				dwr.util.addOptions( "tipoReinversion", {'C':'SOLO CAPITAL', 'CI': 'CAPITAL MAS INTERES'});
			}
		}
		if (reinversion == 'I') {
			dwr.util.removeAllOptions('tipoReinversion');
			dwr.util.addOptions( "tipoReinversion", {'C':'SOLO CAPITAL', 'CI': 'CAPITAL MAS INTERES'});

			habilitaControl('reinvertirVenSi');
			habilitaControl('reinvertirVenNo');
			$('#tipoReinversion').hide();
		}
		if (reinversion == 'N') {
			dwr.util.removeAllOptions('tipoReinversion');

			deshabilitaControl('reinvertirVenSi');
			habilitaControl('reinvertirVenNo');
			$('#tipoReinversion').hide();
		}
	};

	function evaluaReinversionMod(reinvertir,reinversion,reinvertir2,reinversion2){
		if(reinversion == 'S'){
			$("#reinvertirVenSi").attr("checked", true);
			$("#reinvertirVenNo").attr("checked", false);
			$('#tipoReinversion').show();
			habilitaControl('reinvertirVenSi');
			if(reinversion2 == 'I'){
				habilitaControl('reinvertirVenNo');
			}else{
				deshabilitaControl('reinvertirVenNo');
			}
			if(reinvertir == 'I'){
				dwr.util.removeAllOptions('tipoReinversion');
				dwr.util.addOptions('tipoReinversion', {'C':'SOLO CAPITAL','CI':'CAPITAL MAS INTERES'});
				$('#tipoReinversion').val(reinvertir);
			}
			if(reinvertir == 'C'){
				dwr.util.removeAllOptions('tipoReinversion');
				dwr.util.addOptions('tipoReinversion', {'C':'SOLO CAPITAL'});
			}
			if(reinvertir == 'CI'){
				dwr.util.removeAllOptions('tipoReinversion');
				dwr.util.addOptions('tipoReinversion', {'CI':'CAPITAL MAS INTERES'});
			}
			if (reinvertir2 == 'I') {
				dwr.util.removeAllOptions('tipoReinversion');
				dwr.util.addOptions('tipoReinversion', {'C':'SOLO CAPITAL','CI':'CAPITAL MAS INTERES'});
			}
			$('#tipoReinversion').val(reinvertir);
		}
		if(reinversion == 'N'){
			if(reinversion2 == 'I'){
				habilitaControl('reinvertirVenSi');
			}else{
				deshabilitaControl('reinvertirVenSi');
			}
			habilitaControl('reinvertirVenNo');
			$("#reinvertirVenSi").attr("checked", false);
			$("#reinvertirVenNo").attr("checked", true);
			$('#tipoReinversion').hide();
			dwr.util.removeAllOptions('tipoReinversion');
			dwr.util.addOptions('tipoReinversion', {'C':'SOLO CAPITAL','CI':'CAPITAL MAS INTERES'});
		}
	}

	function validaRecursos(){
		if(!$('#reinvertirVenSi').is(':checked') && !$('#reinvertirVenNo').is(':checked')){
			mensajeSis('Seleccione el Tipo de Reinversión.');
			$('#reinvertirVenSi').focus();
			return false;
		} else{
			return true;
		}
		return true;
	}

	/* FUNCION PARA INICIALIZAR EL FORMULARIO DE CEDES */
	function funcionInicializaAltaCedes(){
		inicializaForma('formaGenerica','cedeID');
		$("#cedeID").focus();
		$('#contenedorSim').hide();
		$('#contenedorSimulador').hide();
		$('#direccion').val('');
		agregaFormatoControles('formaGenerica');
		deshabilitaBoton('agrega', 'submit');
		deshabilitaBoton('modificar', 'submit');
		deshabilitaBoton('simular', 'submit');
		validaEmpresaID(); // valida si se ocupa huella digital
		ocultaTasaVariable();
		$('#fechaInicio').val(parametroBean.fechaSucursal);
		$('#plazo').val('');
		$('#fechaVencimiento').val('');
		$('#tipoReinversion').hide();
		$('#reinvertirVenNo').attr('checked',true);
		$('#tipoPagoInt').val("");
		$('#diasPeriodo').hide();
		$('#diasPeriodo').val('');
		$('#lbldiasPeriodo').hide();
		$('#pagoIntCal').val('');

	}
});

//Funcion para cargar plazos
function comboListaPlazos(tipoCedeID){
	var varTipolista=1;
	dwr.util.removeAllOptions('plazoOriginal');
	dwr.util.addOptions( "plazoOriginal", {'':'SELECCIONAR'});
	if(tipoCedeID!='' ){
		var varBean = {
				'tipoInstrumentoID':28,
				'tipoProductoID' : tipoCedeID
		};
		plazosPorProductosServicio.lista(varTipolista, varBean ,{async: false, callback:function(plazosPorProductosConCaja){
			if(plazosPorProductosConCaja != null || plazosPorProductosConCaja != undefined){
				if (plazosPorProductosConCaja.length>0){
					dwr.util.addOptions('plazoOriginal', plazosPorProductosConCaja,'plazo','plazo');
				}else{
					mensajeSis('No Hay Plazos Registrados para este Tipo de CEDE');
				}
			}else{
				mensajeSis('No Hay Plazos Registrados para este Tipo de CEDE');
			}
		}});
	}else{
		mensajeSis('No se Establecio un Tipo de CEDE');
	}
}

function exito(){
	var jQmensaje = eval("'#ligaCerrar'");
	if($(jQmensaje).length > 0) {

		mensajeAlert=setInterval(function() {
		if($(jQmensaje).is(':hidden')) {
			clearInterval(mensajeAlert);

			deshabilitaBoton('agrega', 'submit');
			deshabilitaBoton('modificar', 'submit');
			deshabilitaBoton('simular', 'button');
			$('#contenedorSim').hide();
			$('#contenedorSimulador').hide();
			inicializaForma('formaGenerica','cedeID');
			$('#tipoReinversion').val("");
			$('#plazoOriginal').val("");
			$('#tipoPagoInt').val("");
			$('#diasPeriodo').hide();
			$('#diasPeriodo').val('');
			$('#lbldiasPeriodo').hide();
			$('#pagoIntCal').val('');
			}
        }, 50);
	}
}

function error(){}



function consultaSucursalCAJA() {
	if(!ocultarCajaRetiro()){
		var numSucursal = $('#cajaRetiro').val();
		var tipoConsulta = 8;
		setTimeout("$('#cajaLista').hide();", 200);
		if (generarFormatoAnexo && numSucursal != '' && !isNaN(numSucursal)) {
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
	var tipoProducto=$('#tipoCedeID').asNumber();
	generarFormatoAnexo = true;
	if(tipoProducto == productoInvercamex){
		$('#tdCajaRetiro').hide();
		$('#nombreCaja').val('');
		$('#cajaRetiro').val('0');
		generarFormatoAnexo = false;
		return true;
	} else {
		$('#tdCajaRetiro').show();
	}
	return false;
}
/**
 * Inicializa los valores para el interés generado, a retener, recibido y el total a recibir.
 * Éstos campos se actualizan después de realizar la simulación.
 * @author avelasco
 */
function inicializaValoresCamposInteres(){
	$("#granTotal").val('0.00');
	$("#interesGenerado").val('0.00');
	$("#interesRetener").val('0.00');
	$("#interesRecibir").val('0.00');
}