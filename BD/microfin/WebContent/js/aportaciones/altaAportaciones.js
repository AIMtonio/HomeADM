var estatus ='';
var filas;
var filasTotal = 0;
var contadorCte = "";
var calificacionCli = "";
var sucursalCli = "";
var generarFormatoAnexo=true;
var productoInvercamex=99999;
var esTab = true;
var parametroBean = consultaParametrosSession();
var estatusISR ='';
var tasafijaOrig=0;
var montoGlobal = 0;
var diasPago = '';
var capitalizaInteres = '';
var tipoReinver='';
var diaEspPago='';
var capInt='';
var tipoPagoAp='';
var opcionAp='';
var simulador=false;
var minimoApertura=0.00;
var plazoUsuario =0;

$(document).ready(function() {
	// Definicion de Constantes y Enums
	var diasBase = parametroBean.diasBaseInversion;
	var salarioMinimo = parametroBean.salMinDF;
	var diaHabilSiguiente = '1'; // indica dia habil Siguiente
	var pusoFecha=0;
	$('#tdCajaRetiro').hide();
	mostrarElementoPorClase('tablaComentario',false);
	funcionInicializaAltaAportaciones(); // funcion que inicializa el formulario de alta
	$('#lbldiasPago').hide();
	$('#diasPagoInt').hide();
	$('#tdPlazoOriginalIn').hide();
	$('#plazoOriginalIn').val('');
	$('#lblDiaPagInteres').hide();
	$('#inputDiaPagInt').hide();
	$('#lblDiaCapInteres').show();
	$('#inputDiaCapInt').show();
	$('#capitaliza').append(new Option('SELECCIONAR', '', true, true));
	$('#reinvertirPost').hide();
	$('#reinvPost').hide();
	$('#lblCant').hide();
	$('#cantidadReno').hide();
	$('#lblInvRenovar').hide();
	$('#invRenovar').hide();
	$('.ui-datepicker-trigger').hide();

	var catTipoTransaccionAportacion = {
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
	var catTipoConsultaAportacion = {
		'principal' : 1
	};
	var catTipoConsultaTipoAportacion = {
		'principal':1,
		'general' : 2
	};
	var catTipoListaTipoAportacion = {
		'principal':1
	};
	var catTipoListaCuentas = {
		'foranea': '2'
	};
	var catTipoConsultaCuentas = {
		'conSaldo': 5
	};
	var catTipoConsultaCliente = {
		'paraAportaciones': 25
	};
	var catTipoListaAportacion = {
		'principal': 1
	};
	var catTipoListaCambioTasa = {
		'principal': 16
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
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','aportacionID','exito','error');
			}
		}
	});

	/* EVENTOS DE LOS BOTONES  */
	$('#agrega').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionAportacion.agrega);
		$('#tipoTransaccion1').val("");
		habilitaControl('reinvertirPost');
		habilitaControl('tipoReinversion');
		verificaSimulacion();

		if ($('#tipoPagoInt').val()=='E') {
			var plazoOrig=$('#plazoOriginalIn').val();
			$('#plazoOriginal').val(plazoOrig);
		}

		if($('#tasaFija').val() != "" && $('#espTasa').val() == 'S'){
			var tasaMax=parseFloat(tasafijaOrig)+$('#maxPuntos').asNumber();
			var tasaMin=parseFloat(tasafijaOrig)-$('#minPuntos').asNumber();
			if( $('#tasaFija').asNumber() > parseFloat(Number(tasaMax).toFixed(2)) ||
				$('#tasaFija').asNumber() < parseFloat(Number(tasaMin).toFixed(2))){
				if(confirm("Al asignar una tasa superior o inferior a los límites permitidos, la inversión requerirá un proceso de autorización especial.")){
					return true;
				}else{
					$('#tasaFija').val(tasafijaOrig);
					return false;
				}
			}

		}
	});

	$('#modificar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionAportacion.modifica);
		habilitaControl('reinvertirPost');
		habilitaControl('tipoReinversion');
		verificaSimulacion();
		if ($('#tipoPagoInt').val()=='E') {
			var plazoOrig=$('#plazoOriginalIn').val();
			$('#plazoOriginal').val(plazoOrig);
		}

		if($('#tasaFija').val() != "" && $('#espTasa').val() == 'S'){
			var tasaMax=parseFloat(tasafijaOrig)+$('#maxPuntos').asNumber();
			var tasaMin=parseFloat(tasafijaOrig)-$('#minPuntos').asNumber();
			if( $('#tasaFija').asNumber() > parseFloat(Number(tasaMax).toFixed(2)) ||
				$('#tasaFija').asNumber() < parseFloat(Number(tasaMin).toFixed(2))){
				if(confirm("Al asignar una tasa superior o inferior a los límites permitidos, la inversión requerirá un proceso de autorización especial.")){
					return true;
				}else{
					$('#tasaFija').val(tasafijaOrig);
					return false;
				}
			}

		}
	});

	$('#simular').click(function() {
		if ($('#tipoPagoInt').val()=='E') {
			if($('#capitaliza').val()!=''){
				consultaSimulador();
			}else {
				mensajeSis('Especifique si capitaliza interés.');
				$('#capitaliza').focus();
			}
		}else {
			consultaSimulador();
		}
	});

	$('#tasaFija').blur(function(){
		$('#tasaFija').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
	});
	

	/* EVENTOS DE LAS CAJAS DE TEXTO */
	$('#aportacionID').blur(function(){
		if(!isNaN($('#aportacionID').val())){
			validaAportacion(this.id);
		}
	});

	$('#aportacionID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreCliente";
		camposLista[1] = "estatus";
		parametrosLista[0] = $('#aportacionID').val();
		parametrosLista[1] = 'A';

		lista('aportacionID', 1, catTipoListaAportacion.principal, camposLista, parametrosLista, 'listaAportaciones.htm');
	});

	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '2', '40', 'nombreCompleto',$('#clienteID').val(), 'listaCliente.htm');
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

	$('#tipoAportacionID').blur(function() {
		if(esTab==true  &  !isNaN($('#tipoAportacionID').val())){
			validaTipoAportacion($('#tipoAportacionID').val());
			limpiaCondiciones();
			$('#monto').val('');
		}
	});

	$('#tipoPagoInt').change(function() {
		var tipoPagoInt =$('#tipoPagoInt').val();
		$('#diasPeriodo').val('');
		$('#diasPagoInt').val('');
		$('#capitaliza').val('');
		muestraCampoDias(tipoPagoInt);
		limpiaCondiciones();
		$('#monto').val('');
		muestraCampoDiasPago(tipoPagoInt,diasPago);
	});

	$('#tipoAportacionID').bind('keyup',function(e){
		 var camposLista = new Array();
		 var parametrosLista = new Array();
		 camposLista[0] = "descripcion";
		 parametrosLista[0] = $('#tipoAportacionID').val();

		lista('tipoAportacionID', 2, catTipoListaTipoAportacion.principal, camposLista,
				 parametrosLista, 'listaTiposAportaciones.htm');
	});

	$('#reinvertirVenSi').click(function(){
		$('#tipoReinversion').show();
		$('#tdTipoReinversion').show();
		habilitaControl('tipoReinversion');
	});

	$('#reinvertirVenNo').click(function(){
		$('#tipoReinversion').hide();
		$('#tdTipoReinversion').hide();
		deshabilitaControl('tipoReinversion');
	});
	$('#reinvertirPost').click(function(){
		$('#tipoReinversion').hide();
		$('#tdTipoReinversion').hide();
		deshabilitaControl('tipoReinversion');
	});
	$('#cajaRetiro').bind('keyup',function(e) {
		lista('cajaRetiro', '2', '6', 'nombreSucurs', $('#cajaRetiro').val(), 'listaSucursales.htm');
	});
	$('#cajaRetiro').blur(function() {
		consultaSucursalCAJA()
	});
	
	$('#notas').blur(function(){
		limpiarCaracterEscape(this.id, 500);
	});

	$('#plazoOriginalIn').bind('keyup',function(e) {
		// Valida que solo acepte números
		var objRegExpD=/^[0-9\t]+$/;
		var cad=$('#plazoOriginalIn').val();
			if (!objRegExpD.test(cad)){
				$('#plazoOriginalIn').val('');
				return false;
			}
	});

	$('#plazoOriginal').bind('keyup',function(e) {
		// Valida que solo acepte números
		var objRegExpD=/^[0-9\t]+$/;
		var cad=$('#plazoOriginal').val();
			if (!objRegExpD.test(cad)){
				$('#plazoOriginal').val('');
				return false;
			}
	});

	$('#plazoOriginalIn').change(function() {
		plazoUsuario=$('#plazoOriginalIn').val();
		consultarPlazoFechaVencimProg();
		ocultarSimulador();
	});

	$('#opcionAport').change(function(){
		muestraOcultaCantidad();
	});

	$('#aperturaAport').change(function(){
		if ($('#aperturaAport').val() == 'FP') {
			habilitaControl('fechaInicio');
			$('.ui-datepicker-trigger').show();
		}else {
			deshabilitaControl('fechaInicio');
			$('.ui-datepicker-trigger').hide();
			$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	});

	$('#fechaInicio').change(function(){
		var Xfecha= $('#fechaInicio').val();
		var Yfecha= parametroBean.fechaSucursal;

		if ($('#aperturaAport').val() == 'FP') {
			if(esFechaValida(Xfecha)){
				if(Xfecha ==''){
					$('#fechaInicio').val(Yfecha);
				}
				if ( fechaMayorIgual(Xfecha, Yfecha) ){
					mensajeSis("La Fecha de Inicio no puede ser menor a la fecha del sistema.")	;
					$('#fechaInicio').val(Yfecha);
					$('#fechaInicio').focus();
				}else {
					if ($('#tipoPagoInt').val()=='V') {
						consultarPlazoFechaVencimiento();
					}else {
						consultarPlazoFechaVencimProg();
					}
					$('#fechaInicio').focus();
				}
				
			}else{
				$('#fechaInicio').val(Yfecha);
				$('#fechaInicio').focus();
			}
		}
	});

	$('#invRenovar').bind('keyup',function(e) {
		// Valida que solo acepte números
		var objRegExpR=/^[0-9\t]+$/;
		var cadR=$('#invRenovar').val();
			if (!objRegExpR.test(cadR)){
				$('#invRenovar').val('');
				return false;
			}
	});

	$('#cantidadReno').bind('keyup',function(e) {
		// Valida que solo acepte números y un punto decimal 
		var objRegExpC=/^(([0-9]+\,*[0-9]*)*\.?[0-9]*)$/;
		var cadC=$('#cantidadReno').val();
			if (!objRegExpC.test(cadC)){
				$('#cantidadReno').val('');
				return false;
			}
	});
	
	/****** Controles principales *****************/
	$('#monto').change(function(){
		ocultarSimulador();
	});

	$('#tipoPagoInt').change(function(){
		ocultarSimulador();
	});

	$('#capitaliza').change(function(){
		ocultarSimulador();
	});

	$('#diasPagoInt').change(function(){
		ocultarSimulador();
		$('#plazoOriginalIn').val(plazoUsuario);
		consultarPlazoFechaVencimProg()
	});

	$('#monto').blur(function(){
		var tipoAportacion=$('#tipoAportacionID').asNumber();
		if(tipoAportacion>0){
			if ($('#monto').val()!='') {
				if($('#monto').asNumber() <= $('#totalCuenta').asNumber() || $('#aperturaAport').val() == 'FP'){
					if ($('#monto').asNumber() >= minimoApertura) {
						pusoFecha=2;
						CalculaValorTasa('monto', false);
					}else {
						mensajeSis("El Monto de la Aportación es Menor al mínimo de apertura.");
						$('#monto').focus();
						$('#monto').val('');
					}
					
				}else {
					mensajeSis("El Monto de la Aportación es Superior al Saldo en la Cuenta.");
					$('#monto').focus();
					$('#monto').val('');
				}
			}
		}else {
			mensajeSis('Especifique el Tipo de Aportación.');
			$('#tipoAportacionID').focus();
			$('#tipoAportacionID').val('');
		}
	});

	$('#plazoOriginal').change(function(){
		consultarPlazoFechaVencimiento();
	});

	function consultarPlazoFechaVencimiento(){ // sandra
		var sabDom	='SD';
		var diaInhabil = $('#diaInhabil').val();
		var tipoConsulta = 6;
		if($('#fechaInicio').val()!= ''){
			if(($('#plazoOriginal').val() != '' && $('#monto').val() != 0) ){
				var plazo='';
				if ($('#tipoPagoInt').val()=='E') {
					plazo=$('#plazoOriginalIn').val();
				}else{
					plazo=$('#plazoOriginal').val();
				}

				var opeFechaBean = {
					'primerFecha':($('#aperturaAport').val()=="FA")?parametroBean.fechaSucursal: $('#fechaInicio').val(),
					'numeroDias':plazo,
					'diaInhabil':$('#diaInhabil').val(),
					'diaPago'	:$('#diasPagoInt').val()
				};
				operacionesFechasServicio.realizaOperacion(opeFechaBean,tipoConsulta,function(data) {
					if(data!=null){
						$('#fechaVencimiento').val(data.fechaHabil);
						$('#plazo').val(data.diasEntreFechas);
						CalculaValorTasa('monto', false);// CALCULA la Tasa de Aportación
					}else{
						mensajeSis("Error al Consultar Fechas. Intente nuevamente.");
					}
				});
			}else{
				if($('#monto').val() == 0 || $('#monto').val() == ''){
					mensajeSis('Indique un Monto Mayor a 0.');
					$('#monto').focus();
					limpiaCondiciones();
				}else{
					if($('#plazoOriginal').val() == '' && $('#plazoOriginalIn').val() == ''){
						limpiaCondiciones();
						mensajeSis('El Plazo está Vacío.');
					}
				}
			}
		}else{
			mensajeSis("La Fecha de inicio no debe de estar vacía.");
			$('#aportacionID').focus();
		}


	}

	// consultar fecha de vencimiento programada
	function consultarPlazoFechaVencimProg(){
		var sabDom	='SD';
		var diaInhabil = $('#diaInhabil').val();
		var tipoConsulta = 5;
		if($('#fechaInicio').val()!= ''){
			if($('#plazoOriginalIn').val() != '' && $('#monto').val() != 0){
				var plazo='';
				if ($('#tipoPagoInt').val()=='E') {
					plazo=$('#plazoOriginalIn').val();
				}else{
					plazo=$('#plazoOriginal').val();
				}

				var opeFechaBean = {
					'primerFecha':($('#aperturaAport').val()=="FA")?parametroBean.fechaSucursal: $('#fechaInicio').val(),
					'numeroDias':plazo,
					'diaInhabil':$('#diaInhabil').val(),
					'diaPago'	:$('#diasPagoInt').val()
				};
				operacionesFechasServicio.realizaOperacion(opeFechaBean,tipoConsulta,function(data) {
					if(data!=null){
						$('#fechaVencimiento').val(data.fechaHabil);
						//Se llama a la función que obtiene los dias, solo en caso que la aportación sea de una sola cuota
						var diaEntre = obtenerDias($('#fechaInicio').val(),$('#fechaVencimiento').val());
						if( diaEntre > 0 ){
							plazo=diaEntre;
							$('#plazoOriginalIn').val(diaEntre);
						}
						$('#plazo').val(data.diasEntreFechas);
						CalculaValorTasa('monto', false);// CALCULA la Tasa de Aportación
					}else{
						mensajeSis("Error al Consultar Fechas. Intente nuevamente.");
					}
				});
			}else{
				if($('#monto').val() == 0 || $('#monto').val() == ''){
					mensajeSis('Indique un Monto Mayor a 0.');
					$('#monto').focus();
					limpiaCondiciones();
				}else{
					if($('#plazoOriginal').val() == '' && $('#plazoOriginalIn').val() == ''){
						limpiaCondiciones();
						mensajeSis('El Plazo está Vacío.');
					}
				}
			}
		}else{
			mensajeSis("La Fecha de inicio no debe de estar vacía.");
			$('#aportacionID').focus();
		}


	}

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			clienteID: 'required',
			cuentaAhoID: 'required',
			tipoAportacionID: 'required',
			monto: {
					required: true,
					number:true
			},
			fechaVencimiento: {
				required :true
			},
			fechaInicio: {
				required :true
			},
			plazoOriginal: {
				required : function() {return $('#tipoPagoInt').val() != 'E';}
			},
			tipoPagoInt: 'required',
			cajaRetiro: function() {
				return generarFormatoAnexo;
			},
			diasPeriodo: {
				required : function() {return $('#tipoPagoInt').val() == 'P';}
			},
			tasaFija:{
				required : function() {return $('#espTasa').val() == 'S';}
			},
			diasPagoInt: {
				required : function() {return $('#tipoPagoInt').val() == 'E';}
			},
			plazoOriginalIn: {
				required : function() {return $('#tipoPagoInt').val() == 'E';}
			},
			capitaliza: {
				required : function() {return $('#tipoPagoInt').val() == 'E';}
			},
			invRenovar: {
				required : function() {return $('#invRenovar').is(":visible");}
			},
			cantidadReno: {
				required : function() {return $('#cantidadReno').is(":visible");}
			}
		},

		messages: {
			clienteID: 'Especifique número de '+$('#socioCliente').val()+'.',
			cuentaAhoID: 'Especifique la cuenta.',
			tipoAportacionID:'Especifique el tipo de Aportación.',
			monto: {
				required: 'Especifique monto.',
				number:'Sólo Números.'
			},
			fechaVencimiento:{
				required :'Especifique la fecha de vencimiento.'
			},
			fechaInicio: {
				required :'Especifique la fecha de Inicio.'
			},
			plazoOriginal: 'Especifique el plazo de la Aportación.',
			tipoPagoInt: 'Especifique un Tipo de Pago.',
			cajaRetiro: 'Especifique la Caja de Retiro.',
			diasPeriodo: {
				required : 'Especifique el Número de Días de Periodo.'
			},
			tasaFija:{
				required : 'Especifique Tasa Bruta.'
			},
			diasPagoInt: {
				required : 'Especifique el Número de Días de Pago.'
			},
			plazoOriginalIn: {
				required : 'Especifique el plazo.'
			},
			capitaliza: {
				required : 'Especifique si capitaliza interés.'
			},
			invRenovar: {
				required : 'Especifique Inv. Renovar'
			},
			cantidadReno: {
				required : 'Especifique Cantidad de Renovación'
			}
		},
	});


    /* Valida el tipo de AportaciónS cuando se encuentre parametrizado dia inhábil: Sabado y Domingo
     * para que no se registren Aportaciones el día Sábado */
	function validaSabadoDomingo(){
		var fecha = parametroBean.fechaSucursal;
		var diaInhabil = $('#diaInhabil').val();
		var aportacion = $('#aportacionID').val();
		var sabDom	='SD';
		var noEsFechaHabil = 'N';
		var tipoAportacionID = $('#tipoAportacionID').val();
		var diaInhabilBean = {
				'fecha': fecha,
				'numeroDias': 0,
				'salidaPantalla':'S',
		};
		if (aportacion == 0){
			if (diaInhabil == sabDom){
				var sabado = 'Sábado y Domingo';
				diaFestivoServicio.calculaDiaFestivo(3,diaInhabilBean,function(data){
					if(data!=null){
						$('#esDiaHabil').val(data.esFechaHabil);
						if($('#esDiaHabil').val() == noEsFechaHabil){
							mensajeSis("El Tipo de Aportación seleccionado no puede asignarse en: " + sabado +
									" por tal motivo  no se puede registrar la Aportación.");
							$('#tipoAportacionID').focus();
							$('#tipoAportacionID').select();
							$('#tipoAportacionID').val('');
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

	function validaAportacion(idControl){
		var jqAportacion = eval("'#" + idControl + "'");
		var numAportacion = $(jqAportacion).val();
		$('#contenedorSim').hide();
		$('#contenedorSimulador').hide();
		simulador=false;
		if(numAportacion == '0'){
			$('#cuentaAhoID').val("");
			habilita();
			habilitaBoton('agrega', 'submit');
			habilitaBoton('simular', 'submit');
			deshabilitaBoton('modificar', 'submit');
			inicializaForma('formaGenerica','aportacionID');
			$('#reinvertirVenSi').attr('checked',false);
			$('#reinvertirVenNo').attr('checked',false);
			$('#cuentaAhoID').val("");
			$('#plazo').val("");
			$('#plazoOriginal').val('');
			$('#interesRecibir').val("");
			$('#interesRetener').val("");
			$('#tipoPagoInt').val("");
			$('#fechaInicio').val(parametroBean.fechaSucursal);
			mostrarElementoPorClase('tablaComentario',false);
			tasafijaOrig=0;
			deshabilitaControl('tasaFija');
			$("#elimBr").remove();
			$('#lbldiasPago').hide();
			cargaComboOpciones();
			$('#reinvertirPost').hide();
			$('#reinvPost').hide();
			$('#tdReinvertirVenNo').show();
			$('#reinvertirVenNo').show();
			$('#reinvVencNo').show();
			$('#reinvertirVenSi').show();
			$('#reinvVenc').show();
			muestraCampoDiasPago(tipoPagoInt,diasPago);
			$('#tdInvRenovar').hide();
			$('#lblInvRenovar').hide();
			$('#invRenovar').val('');
			$('#lblCant').hide();
			$('#tdCantidadReno').hide();
			$('#cantidadReno').val('');
			$('#aperturaAport').val('FA');
			deshabilitaControl('fechaInicio');
			$('.ui-datepicker-trigger').hide();
		}else{
			if(numAportacion != '' && numAportacion >0  && esTab == true){
				var AportacionBean = {
					'aportacionID' : numAportacion
				};
				aportacionesServicio.consulta(catTipoConsultaAportacion.principal, AportacionBean, { async: false, callback: function(aportacion){
					if(aportacion!=null){
						
						if (aportacion.aperturaAport == 'FP') {
							$('#aperturaAport').val(aportacion.aperturaAport).selected = true;
						}else {
							$('#aperturaAport').val('FA').selected = true;
						}

						if (aportacion.tipoPagoInt=='E') {
							diaEspPago=aportacion.diasPagoInt;
							capInt=aportacion.capitaliza;
							$('#tdPlazoOriginal').hide();
							$('#plazoOriginal').hide();
							$('#tdPlazoOriginalIn').show();
							$('#plazoOriginalIn').show();
							$('#plazoOriginalIn').val(aportacion.plazoOriginal);
							muestraCampoDiasPago(aportacion.tipoPagoInt,diasPago,aportacion.capitaliza,
												aportacion.diasPagoInt,aportacion.opcionAport);
							if (aportacion.reinversion == 'F') {
								$('#reinvertirVenSi').hide();
								$('#reinvertirVenNo').hide();
								$('#tdReinvertirVenNo').hide();
								$('#reinvVenc').hide();
								$('#reinvVencNo').hide();
								$('#reinvertirPost').attr('checked', true);
								$('#reinvertirPost').show();
								$('#reinvPost').show();
								deshabilitaControl('reinvertirPost');
							}
						}else{
							$('#plazoOriginal').val(aportacion.plazoOriginal);
							inicializaDifProgramado()
						}

						// Reinversion posterior
						if (aportacion.reinversion == 'F') {
								$("#reinvertirVenSi").attr("checked", false);
								$("#reinvertirVenNo").attr("checked", false);
								$('#reinvertirPost').attr('checked', true);
								$('#reinvertirPost').show();
								$('#reinvPost').show();
						}

						$('#notas').val(aportacion.notas);
						$('#cuentaAhoID').val(aportacion.cuentaAhoID);
						$('#tipoAportacionID').val(aportacion.tipoAportacionID);
						$('#monto').val(aportacion.monto);
						$('#plazo').val(aportacion.plazo);

						$('#fechaInicio').val(aportacion.fechaInicio);
						$('#fechaVencimiento').val(aportacion.fechaVencimiento);
						if ($('#plazoOriginal').val()==""){
							$('#plazoOriginal').append($('<option>', {
								    value: aportacion.plazoOriginal,
								    text: aportacion.plazoOriginal
								}));
							$('#plazoOriginal').val(aportacion.plazoOriginal);

						}
						if($('#espTasa').val()=='S'){
								habilitaControl('tasaFija');
						}
						$('#tasaFija').val(aportacion.tasaFija);
						$('#tasaFija').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
						tasafijaOrig=$('#tasaFija').val();
						$('#tasaISR').val(aportacion.tasaISR);
						$('#tasaNeta').val(aportacion.tasaNeta);
						$('#valorGat').val(aportacion.valorGat);
						estatusISR = aportacion.estatusISR;
						$('#interesGenerado').val(aportacion.interesGenerado);
						$('#interesRetener').val(aportacion.interesRetener);
						$('#interesRecibir').val(aportacion.interesRecibir);
						$('#valorGatReal').val(aportacion.valorGatReal);
						$('#granTotal').val(aportacion.totalRecibir);
						$('#cajaRetiro').val(aportacion.cajaRetiro);
						$('#pagoIntCal').val(aportacion.pagoIntCal);
						mostrarElementoPorClase('trMontoGlobal',aportacion.tasaMontoGlobal);
						$('#montoGlobal').val(aportacion.montoGlobal);

						consultaSucursalCAJA();
						consultaCtaAho(aportacion.cuentaAhoID);
						consultaCliente(aportacion.clienteID, aportacion.estatus);

						if(aportacion.aportacionMadreID !=0){
							mensajeSis("La Aportación se encuentra Anclada y no puede ser Modificada.");
							deshabilitaControl('tasaFija');
							deshabilitaBoton('agrega', 'submit');
							deshabilitaBoton('modificar', 'submit');
							deshabilitaBoton('simular', 'submit');
							deshabilita();
						}else{
							if(aportacion.estatus == 'A'){
								if(aportacion.fechaInicio != parametroBean.fechaSucursal && aportacion.aperturaAport=='FA'){
									mensajeSis("La Aportación no es del Día de Hoy.");
									deshabilitaBoton('agrega', 'submit');
									deshabilitaBoton('modificar', 'submit');
									deshabilitaBoton('simular', 'submit');
									deshabilitaControl('tasaFija');
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
								deshabilitaControl('tasaFija');
								deshabilita();
								if(aportacion.estatus == 'N'){
									mensajeSis("La Aportación ha sido cargada a cuenta y no puede ser Modificada.");
								}else if(aportacion.estatus == 'C'){
									mensajeSis("La Aportación ha sido cancelada y no puede ser Modificada.");
								}else if(aportacion.estatus == 'P'){
									mensajeSis("La Aportación se encuentra Pagada (Abonado a Cuenta).");
								}else if(aportacion.estatus == 'V'){
									mensajeSis("La Aportación se encuentra Vencida y no puede ser Modificada.");
								}
							}
						}

						validaTipoAportacionMod(aportacion.tipoAportacionID, aportacion.reinvertir, aportacion.reinversion,aportacion.tipoPagoInt,aportacion.diasPeriodo);

						$('#telefono').setMask('phone-us');
						$('#monto').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
						agregaFormatoControles('formaGenerica');

						// Si existen comentarios de la aportación los carga en el campo
						if(parseInt(aportacion.comentarios) > 0){
							$('#comentAport').val('');
							aportacionesServicio.lista(catTipoListaCambioTasa.principal,AportacionBean,function(comentarios){
								if(comentarios != null){
									comentarios.forEach(function(coment) {
										var aux=$('#comentAport').val();
										$('#comentAport').val(aux +""+ coment.desComentarios.toString()+"\n");
									});
								}
							});
							mostrarElementoPorClase('tablaComentario',true);
						}else{
							mostrarElementoPorClase('tablaComentario',false);
						}

						opcionAp=aportacion.opcionAport;
						cargaComboOpciones();

						setTimeout(function(){
							muestraOcultaCantidad(aportacion.cantidadReno,aportacion.invRenovar);
						},300);
						if (aportacion.tipoPagoInt!='E') {
							$('#capitaliza').each(function() {
								$('#capitaliza option').remove();
							})
							$('#capitaliza').append(new Option('SELECCIONAR', '', true, true));
							deshabilitaControl('capitaliza');

						}else {
							if (aportacion.estatus=='A') {
								habilitaControl('capitaliza');
							}
						}
					}else{
						mensajeSis("La Aportación no existe.");
						$('#aportacionID').focus();
						$('#aportacionID').val('');
					}
				}});
			}
		}
	}



	/* CONSULTAR CLIENTE */
	function consultaCliente(numCliente, estatusAport) {
		var rfc = ' ';
		var NOPagaISR = 'N';
		if (numCliente != '0') {
			setTimeout("$('#cajaLista').hide();", 200);
			if (alertaCte(numCliente) != 999) {
				if (numCliente != '' && !isNaN(numCliente)) {
					if ($('#aportacionID').val() == 0) {
						funcionLimpiar();
					}
					clienteServicio.consulta(catTipoConsultaCliente.paraAportaciones, numCliente, rfc, {
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
								$('#tasaISR').val(cliente.tasaISR);

								if (cliente.validaTasa == 'S') {
									if(Number(cliente.tasaISR) == 0){
										deshabilitaBoton('modificar', 'submit');
										deshabilitaBoton('agrega', 'submit');
										deshabilitaBoton('simular', 'submit');
										mensajeSis("El País de Residencia del " + $('#socioCliente').val() +
												"<br>No Cuenta con un esquema de<br>"+
												cargaLinkExterno('Tasas ISR para Residentes en el Extranjero', 'tasasISRExtVista.htm') +
												"<br><br>País de Residencia: <b>" + cliente.paisResidencia + "</b>.");
										$('#clienteID').focus();
									} else {
										consultaDireccion(cliente.numero);
										consultaHuellaCliente();

										if (estatusAport == 'A' || estatusAport == undefined) {
											consultaDatosAdicionales(cliente.numero);
										}
										if($('#aportacionID').asNumber()>0){
											habilitaBoton('modificar', 'submit');
										} else {
											habilitaBoton('agrega', 'submit');
										}
										habilitaBoton('simular', 'submit');
									}
								} else {
									consultaDireccion(cliente.numero);
									consultaHuellaCliente();

									if (estatusAport == 'A' || estatusAport == undefined) {
										consultaDatosAdicionales(cliente.numero);
									}

									if (cliente.estatus == "I") {
										deshabilitaBoton('modificar', 'submit');
										deshabilitaBoton('agrega', 'submit');
										mensajeSis("El " + $('#socioCliente').val() + " se encuentra Inactivo.");
										$('#clienteID').focus();
									}
									agregaFormatoControles('formaGenerica');
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
					
					var saldoDec=cuenta.saldoDispon;
					saldoDec=saldoDec.replace(/\,/g, '');
					if((cuenta.saldoDispon!=null && Number(saldoDec)>0) || $('#aperturaAport').val() == 'FP'){
						$('#cuentaAhoID').val(cuenta.cuentaAhoID);
            			$('#totalCuenta').val(cuenta.saldoDispon);
                		$('#tipoMoneda').html(cuenta.descripcionMoneda);
                		$('#tipoMonedaInv').html(cuenta.descripcionMoneda);
                		$('#monedaID').val(cuenta.monedaID);
                		if(cuenta.estatus != catStatusCuenta.activa){
                			mensajeSis("La Cuenta no esta Activa.");
	              			$('#cuentaAhoID').focus();
	  		          		$('#cuentaAhoID').val('');
                		}
					}else{
						mensajeSis("La Cuenta no tiene saldo Disponible.");
						$('#cuentaAhoID').focus();
						$('#cuentaAhoID').select();
					}
				}else{
					mensajeSis("La Cuenta no Existe.");
					$('#totalCuenta').val("");
					$('#cuentaAhoID').focus();
					$('#cuentaAhoID').val('');
				}
			}});
		}
	}

	function validaTipoAportacion(tipAportacion){
		var TipoAportacionBean ={
			'tipoAportacionID' :tipAportacion
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(tipAportacion != '' && !isNaN(tipAportacion) ){
			if(tipAportacion != 0){
				tiposAportacionesServicio.consulta(catTipoConsultaTipoAportacion.general,TipoAportacionBean, { async: false, callback: function(tipoAportacion){
					if(tipoAportacion!=null){
						$('#tasaFV').val(tipoAportacion.tasaFV);
						mostrarSeccionTasa(tipoAportacion.tasaFV); //Funcion para mostrar la seccion de tasa correcta
						$('#descripcion').val(tipoAportacion.descripcion);
						$('#tipoAportacionID').val(tipoAportacion.tipoAportacionID);
						$('#diaInhabil').val(tipoAportacion.diaInhabil);
						$('#pagoIntCal').val(tipoAportacion.pagoIntCal);
						validaSabadoDomingo();
						evaluaReinversion(tipoAportacion.reinversion,tipoAportacion.reinvertir);
						// se llenan los valores de los combos segun lo parametrizado
						consultaComboFormaPago(tipoAportacion.tipoPagoInt,tipoAportacion.diasPeriodo);
						$('#espTasa').val(tipoAportacion.especificaTasa);
						if ($('#espTasa').val()=='S') {
							habilitaControl('tasaFija');
						}else {
							deshabilitaControl('tasaFija');
						}
						minimoApertura=tipoAportacion.minimoApertura;
						$('#maxPuntos').val(tipoAportacion.maxPuntos);
						$('#minPuntos').val(tipoAportacion.minPuntos);
						diasPago=tipoAportacion.diasPago;
						capitalizaInteres=tipoAportacion.pagoIntCapitaliza;
						$('#lbldiasPago').hide();
						$('#diasPagoInt').hide();
						$('#tdPlazoOriginalIn').hide();
						$('#tdPlazoOriginal').show();
						$('#plazoOriginal').show();
						$('#plazoOriginalIn').val('');
						$('#capitaliza').val('');
						// se eliminan los tipos de pago que se tenian
						$('#capitaliza').each(function() {
							$('#capitaliza option').remove();
						});

						tipoReinver=tipoAportacion.reinversion;
						if (tipoAportacion.reinversion == 'E') {
							$('#reinvertirVenSi').hide();
							$('#reinvertirVenNo').hide();
							$('#tdReinvertirVenNo').hide();
							$('#reinvVenc').hide();
							$('#reinvVencNo').hide();
							$('#reinvertirPost').attr('checked', true);
							$('#reinvertirPost').show();
							$('#reinvPost').show();
							deshabilitaControl('reinvertirPost');
						}else{
							$('#reinvertirVenSi').show();
							$('#reinvertirVenNo').show();
							$('#tdReinvertirVenNo').show();
							$('#reinvVenc').show();
							$('#reinvVencNo').show();
							$("#elimBr").remove();
							$('#reinvertirPost').hide();
							$('#reinvPost').hide();
							if (tipoAportacion.reinversion == 'I'){
								$("#reinvVenc").after('<br id="elimBr">');
								$('#reinvertirPost').show();
								$('#reinvPost').show();
							}
						}
					}else{
						$('#descripcion').val('');
						$('#diaInhabil').val('');
						mensajeSis("El tipo de Aportación no Existe.");
						$('#tipoAportacionID').focus();
						$('#tipoAportacionID').val('');
						$('#pagoIntCal').val('');
						$('#tdPlazoOriginalIn').hide();
						$('#plazoOriginalIn').val('');
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
				case "E":// PROGRAMADO
					tipoPagoDescrip = 'PROGRAMADO';
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

	// funcion que llena el combo de tipos de interes cuando se consulta el aportacion
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
			}else{
				$('#diasPeriodo').hide();
				$('#lbldiasPeriodo').hide();
			}
		}
	}

	function muestraCampoDiasPago(tipoPagoInt,diasPag,capitaliza,diaPago,opcionAport){
		var tipoPago  = eval("'" + tipoPagoInt + "'");
		var Programado ='E';
		if ($('#aportacionID').asNumber() == 0) {
			if (tipoPago == 'E') {
				// se eliminan los tipos de pago que se tenian
				$('#diasPagoInt').each(function() {
					$('#diasPagoInt option').remove();
				})

				var diasPag = diasPag.split(',');
				var tamanio = diasPag.length;

				for ( var i = 0; i < tamanio; i++) {
					if(diasPag[i]!=null && diasPag[i]!=''){
						$('#diasPagoInt').append(
							new Option(diasPag[i], diasPag[i], true,
									true));
						$('#diasPagoInt').val(diasPag[0]).selected = true;
					}
				}

				$('#lbldiasPago').show();
				$('#diasPagoInt').show();
				$('#diasPagoInt').focus();

				$('#plazoOriginal').hide();
				$('#plazoOriginalIn').show();

				$('#tdPlazoOriginal').hide();
				$('#tdPlazoOriginalIn').show();

				$('#capitaliza').each(function() {
					$('#capitaliza option').remove();
				})
				if(capitalizaInteres=='S'){
				$('#capitaliza').append(
						new Option('SI', 'S', true,
								true));

				}else if (capitalizaInteres=='N') {
					$('#capitaliza').append(
								new Option('NO', 'N', true,
										true));
				}else{
					$('#capitaliza').append(
						new Option('SELECCIONAR', '', true, true));
					$('#capitaliza').append(
						new Option('SI', 'S', true,
								true));
					$('#capitaliza').append(
								new Option('NO', 'N', true,
										true));
					$('#capitaliza').val('SELECCIONAR').selected = true;
					habilitaControl('capitaliza');
				}

				$('#lblDiaCapInteres').show();
				$('#inputDiaCapInt').show();

			}else{
				$('#lbldiasPago').hide();
				$('#diasPagoInt').hide();
				$('#tdPlazoOriginal').show();
				$('#tdPlazoOriginalIn').hide();
				$('#plazoOriginal').show();
				$('#plazoOriginalIn').hide();
				$('#plazoOriginalIn').val('');
				$('#capitaliza').each(function() {
					$('#capitaliza option').remove();
				})
				$('#capitaliza').append(new Option('SELECCIONAR', '', true, true));
				deshabilitaControl('capitaliza');
			}
		}else{
			if (tipoPago == 'E') {

				diaEspPago=diaPago;
				capInt=capitaliza;

				$('#lbldiasPago').show();
				$('#diasPagoInt').show();

				$('#tdPlazoOriginal').hide();
				$('#tdPlazoOriginalIn').show();

				$('#plazoOriginal').hide();
				$('#plazoOriginalIn').show();

				$('#lblDiaCapInteres').show();
				$('#inputDiaCapInt').show();

				// se eliminan los tipos de pago que se tenian
				$('#diasPagoInt').each(function() {
					$('#diasPagoInt option').remove();
				})

				var diasPag = diasPag.split(',');
				var tamanio = diasPag.length;

				for ( var i = 0; i < tamanio; i++) {
					if(diasPag[i]!=null && diasPag[i]!=''){
						$('#diasPagoInt').append(
							new Option(diasPag[i], diasPag[i], true,
									true));
					}
				}

				if (diaEspPago != undefined && diaEspPago !='' ) {
					$('#diasPagoInt').val(diaEspPago).selected = true;
				}else {
					$('#diasPagoInt').val(diasPag[0]).selected = true;
				}

				$('#capitaliza').each(function() {
					$('#capitaliza option').remove();
				})
				if(capitalizaInteres=='S'){
				$('#capitaliza').append(
						new Option('SI', 'S', true,
								true));

				}else if (capitalizaInteres=='N') {
					$('#capitaliza').append(
								new Option('NO', 'N', true,
										true));
				}else{
					$('#capitaliza').append(
						new Option('SELECCIONAR', '', true, true));
					$('#capitaliza').append(
						new Option('SI', 'S', true,
								true));
					$('#capitaliza').append(
								new Option('NO', 'N', true,
										true));
					if (capInt != undefined && capInt != '') {}
					$('#capitaliza').val(capInt).selected = true;
					habilitaControl('capitaliza');
				}
			}else{
				$('#lbldiasPago').hide();
				$('#diasPagoInt').hide();
				
				$('#plazoOriginalIn').hide();
				$('#plazoOriginalIn').val('');
				$('#tdPlazoOriginalIn').hide();

				$('#plazoOriginal').val('');
				$('#plazoOriginal').show();
				$('#tdPlazoOriginal').show();

				$('#capitaliza').each(function() {
					$('#capitaliza option').remove();
				})
				$('#capitaliza').append(new Option('SELECCIONAR', '', true, true));
				deshabilitaControl('capitaliza');
			}

			tipoPagoAp=tipoPago;

		}
	}

	function cargaCombos (tipoPago,dias,capitaliza) {
		if (tipoPagoAp == 'E') {
				// se eliminan días que se tenian de pago
				$('#diasPagoInt').each(function() {
					$('#diasPagoInt option').remove();
				})

				var diasPag = dias.split(',');
				var tamanio = diasPag.length;

				for ( var i = 0; i < tamanio; i++) {
					if(diasPag[i]!=null && diasPag[i]!=''){
						$('#diasPagoInt').append(
							new Option(diasPag[i], diasPag[i], true,
									true));
						$('#diasPagoInt').val(diaEspPago).selected = true;
					}
				}

			// cargar combo de capitalización
			$('#capitaliza').each(function() {
					$('#capitaliza option').remove();
			})
			if(capitaliza=='S'){
			$('#capitaliza').append(
					new Option('SI', 'S', true,
							true));

			}else if (capitaliza=='N') {
				$('#capitaliza').append(
							new Option('NO', 'N', true,
									true));
			}else{
				$('#capitaliza').append(
					new Option('SELECCIONAR', '', true, true));
				$('#capitaliza').append(
					new Option('SI', 'S', true,
							true));
				$('#capitaliza').append(
							new Option('NO', 'N', true,
									true));
				$('#capitaliza').val(capInt).selected = true;
			}
		}else{
			$('#capitaliza').each(function() {
					$('#capitaliza option').remove();
			});
			$('#capitaliza').append(
					new Option('SELECCIONAR', '', true, true));
		}
	}



	function validaTipoAportacionMod(tipAportacion, reinvertir, reinversion, tipoPagoInt, diasPeriodo){
		var TipoAportacionBean ={
			'tipoAportacionID' :tipAportacion
		};
		if(tipAportacion != '' && !isNaN(tipAportacion) ){
			if(tipAportacion != 0){
				tiposAportacionesServicio.consulta(catTipoConsultaTipoAportacion.general,
													TipoAportacionBean, { async: false, callback: function(tipoAportacion){
					if(tipoAportacion!=null){
						$('#tasaFV').val(tipoAportacion.tasaFV);
						$('#espTasa').val(tipoAportacion.especificaTasa);
						$('#maxPuntos').val(tipoAportacion.maxPuntos);
						$('#minPuntos').val(tipoAportacion.minPuntos);
						mostrarSeccionTasa(tipoAportacion.tasaFV); //Funcion para mostrar la seccion de tasa correcta
						$('#descripcion').val(tipoAportacion.descripcion);
						$('#tipoAportacionID').val(tipoAportacion.tipoAportacionID);
						$('#diaInhabil').val(tipoAportacion.diaInhabil);
						diasPago=tipoAportacion.diasPago;
						capitalizaInteres=tipoAportacion.pagoIntCapitaliza;
						if(tipoAportacion.reinversion == 'I'){
							evaluaReinversionMod(reinvertir,reinversion,tipoAportacion.reinvertir,tipoAportacion.reinversion);
						}else{
							if(tipoAportacion.reinversion == 'S' && reinversion == 'S'){
								if(tipoAportacion.reinvertir == 'I'){
									evaluaReinversionMod(reinvertir,reinversion,tipoAportacion.reinvertir,tipoAportacion.reinversion);
								}else{
									if(tipoAportacion.reinvertir == reinvertir){
										evaluaReinversionMod(reinvertir,reinversion,tipoAportacion.reinvertir,tipoAportacion.reinversion);
									}else{
										evaluaReinversion(tipoAportacion.reinversion,tipoAportacion.reinvertir);
										mensajeSis('Las Condiciones de Reinversión no Coinciden.');
									}
								}
							}else{
								if(tipoAportacion.reinversion == 'N' && reinversion == 'N'){
									evaluaReinversionMod(reinvertir,reinversion,tipoAportacion.reinvertir,tipoAportacion.reinversion);
								}else{
									if (tipoAportacion.reinversion == 'E' && reinversion == 'F') {
										evaluaReinversionMod(reinvertir,reinversion,tipoAportacion.reinvertir,tipoAportacion.reinversion);
									}else{
										evaluaReinversion(tipoAportacion.reinversion,tipoAportacion.reinvertir);
										mensajeSis('Las Condiciones de Reinversión no Coinciden.');
									}

								}
							}

						}

						consultaComboTipoPagoCon(tipoAportacion.tipoPagoInt,tipoPagoInt,tipoAportacion.diasPeriodo,diasPeriodo);
						cargaCombos(tipoAportacion.tipoPagoInt,tipoAportacion.diasPago,tipoAportacion.pagoIntCapitaliza)
					}else{
						$('#descripcion').val('');
						$('#diaInhabil').val('');
						mensajeSis("El tipo de Aportación no Existe.");
						$('#tipoAportacionID').focus();
						$('#tipoAportacionID').val('');
					}
				  }
				});
			}
		}
	}


	// funcion que llena el combo de tipos de interes cuando se consulta la aportación
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
				case "E":// PROGRAMADO
					tipoPagoDescrip = 'PROGRAMADO';
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

	// funcion que llena el combo de tipos de interes cuando se consulta el aportacion
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
	 * @param consultaAportaciones Valor boleano que indica que la función fue llamada al consultar una Aportación existente.
	 * @author avelasco
	 */
	function CalculaValorTasa(idControl, consultaAportaciones){
		var jqControl = eval("'#" + idControl + "'");
		consultaMontoGlobal();
		var tipoCon = 2;
		if($(jqControl).asNumber() <= $('#totalCuenta').asNumber() || $('#aperturaAport').val()=='FP'){
			if($('#plazo').val() != '' && $('#plazo').val() != 0
					&& $(jqControl).val() != '' && $(jqControl).val() != 0){
				var variables = creaBeanTasaAportacion();
				tasasAportacionesServicio.consulta(tipoCon,variables, { async: false, callback: function(porcentaje){
					if((porcentaje.tasaAnualizada !=0 && porcentaje.tasaAnualizada != null)  || (porcentaje.tasaBase>0 && porcentaje.tasaBase != null)){
						if($('#tasaFV').val()=='F' && porcentaje.tasaAnualizada>0){
							// si especifica tasa se habilita el campo tasa bruta
							if($('#espTasa').val()=='S'){
								habilitaControl('tasaFija');
							}
							$('#tasaFija').val(porcentaje.tasaAnualizada);
							$('#tasaFija').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
							tasafijaOrig=$('#tasaFija').val();
							$('#calculoInteres').val('1');
							$('#tasaBaseID').val('0');
							$('#sobreTasa').val('0.0');
							$('#pisoTasa').val('0.0');
							$('#techoTasa').val('0.0');
							$('#valorTasaBaseID').val('0.0');
						}
						if($('#tasaFV').val()=='V' && porcentaje.tasaBase>0){
							$('#tasaFija').val(porcentaje.tasaAnualizada);
							$('#tasaFija').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
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
						if(!isNaN($('#aportacionID').val())){
							if ($('#aportacionID').asNumber()==0 ||$('#aportacionID').val()==''){
								habilitaBoton('agrega', 'submit');
								habilita();
							}
						}
						if(!consultaAportaciones){
							inicializaValoresCamposInteres();
						}
					}else{
						mensajeSis("No existe una Tasa Anualizada.");
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
			params['plazoOriginal']	= ($('#tipoPagoInt').val()=="E")?$('#plazoOriginalIn').val(): $('#plazoOriginal').val();
			params['capitaliza']	= ($('#tipoPagoInt').val()=="E")?$('#capitaliza').val():'';

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
					$("#varSaldoCapital").text(formatoMonedaVariable(varTotalCapital,true));
					$("#varTotalCapital").text(formatoMonedaVariable(varTotalCapital,true));
					$("#varTotalInteres").text(formatoMonedaVariable(varTotalInteres,true));
					$("#varTotalISR").text(formatoMonedaVariable(varTotalISR,true));
					$("#varTotalFinal").text(formatoMonedaVariable(varTotalFinal,true));
					agregaFormatoControles('formaGenerica');
					simulador=true;
				}else{
					ocultarSimulador();
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

	function creaBeanTasaAportacion(){
		var tasasAportacionBean = {
				'tipoAportacionID': $('#tipoAportacionID').val(),
				'plazo' 		  : ($('#tipoPagoInt').val()=="E")?$('#plazoOriginalIn').val(): $('#plazoOriginal').val(),
				'monto' 		  : (Number(montoGlobal)>0?$('#montoGlobal').asNumber():$('#monto').asNumber()),
				'calificacion' 	  :  calificacionCli ,
				'sucursalID'  	  :  parametroBean.sucursal
		};
		return tasasAportacionBean;
	}

	function calculaCondicionesAportacion(){
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
				$('#tasaFija').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2	});
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
		$('#tipoAportacionID').val("");
		$('#descripcion').val("");
		$('#diaInhabil').val("");
		$('#totalCuenta').val("");
		$('#tipoPagoInt').val("");
		$('#diasPeriodo').hide();
		$('#diasPeriodo').val('');
		$('#lbldiasPeriodo').hide();
		$('#pagoIntCal').val('');
		deshabilitaControl('tasaFija');
	}

	function limpiaCondiciones() {
		$('#plazoOriginal').val('');
		$('#plazoOriginalIn').val('');
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
		ocultaMontoGlobal(true);
		cargaComboOpciones ();
		$('#lblCant').hide();
		$('#cantidadReno').hide();
		$('#cantidadReno').val('');
		$('#lblInvRenovar').hide();
		$('#invRenovar').hide();
		$('#invRenovar').val('');
		if ($('#tipoPagoInt').val() != 'E') {
			$('#capitaliza').each(function() {
					$('#capitaliza option').remove();
			})
			$('#capitaliza').append(new Option('SELECCIONAR', '', true, true));
		}
	}

	function deshabilita(){
		deshabilitaControl('clienteID');
		deshabilitaControl('cuentaAhoID');
		deshabilitaControl('tipoAportacionID');
		deshabilitaControl('monto');
		deshabilitaControl('tipoPagoInt');
		deshabilitaControl('plazoOriginal');
		ocultaMontoGlobal(true);
		deshabilitaControl('diasPagoInt');
		deshabilitaControl('capitaliza');
		deshabilitaControl('plazoOriginalIn');
		deshabilitaControl('cantidadReno');
		deshabilitaControl('opcionAport');
		deshabilitaControl('notas');
		deshabilitaControl('invRenovar');
		deshabilitaControl('reinvertirVenNo');
		deshabilitaControl('reinvertirPost');
		deshabilitaControl('reinvertirVenSi');
		deshabilitaControl('aperturaAport');
		$('.ui-datepicker-trigger').hide();
		deshabilitaControl('fechaInicio');
	}

	function habilita(){
		habilitaControl('clienteID');
		habilitaControl('cuentaAhoID');
		habilitaControl('tipoAportacionID');
		habilitaControl('monto');
		habilitaControl('tipoPagoInt');
		habilitaControl('plazoOriginal');
		habilitaControl('diasPagoInt');
		if ($('tipoPagoInt').val()=='E') {
			habilitaControl('capitaliza');
		}
		habilitaControl('plazoOriginalIn');
		habilitaControl('cantidadReno');
		habilitaControl('opcionAport');
		habilitaControl('notas');
		habilitaControl('invRenovar');
		habilitaControl('aperturaAport');
		if ($('#aperturaAport').val()=='FP') {
			$('.ui-datepicker-trigger').show();
			habilitaControl('fechaInicio');
		}
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
						if($("#aportacionID").val() == 0){
							habilitaBoton('agrega','submit');
						}
					}
				}else{
					if($("#aportacionID").val() == 0){
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
				mensajeSis("No Existe Tasa Base.");
			}
		}});
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

		/*Se consulta el total de AportaciónS del cliente */
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
		$('#reinvertirPost').attr('checked',false);
		if (reinversion == 'S') {
			habilitaControl('reinvertirVenSi');
			deshabilitaControl('reinvertirVenNo');
			deshabilitaControl('reinvertirPost');
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
			habilitaControl('reinvertirPost');
			$('#tipoReinversion').hide();
		}
		if (reinversion == 'N') {
			dwr.util.removeAllOptions('tipoReinversion');

			deshabilitaControl('reinvertirVenSi');
			habilitaControl('reinvertirVenNo');
			deshabilitaControl('reinvertirPost');
			$('#tipoReinversion').hide();
		}
		if (reinversion == 'E') {
			dwr.util.removeAllOptions('tipoReinversion');
			dwr.util.addOptions( "tipoReinversion", {'E':'POSTERIOR'});
			$('#tipoReinversion').hide();
		}
	};

	function evaluaReinversionMod(reinvertir,reinversion,reinvertir2,reinversion2){
		if(reinversion == 'S'){
			$("#reinvertirVenSi").attr("checked", true);
			$("#reinvertirVenNo").attr("checked", false);
			$("#reinvertirPost").attr("checked", false);
			$('#tipoReinversion').show();
			habilitaControl('reinvertirVenSi');
			if(reinversion2 == 'I'){
				habilitaControl('reinvertirVenNo');
				habilitaControl('reinvertirPost');
			}else{
				deshabilitaControl('reinvertirVenNo');
				deshabilitaControl('reinvertirPost');
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
				habilitaControl('reinvertirPost');
			}else{
				deshabilitaControl('reinvertirVenSi');
				deshabilitaControl('reinvertirPost');
			}
			habilitaControl('reinvertirVenNo');
			$("#reinvertirVenSi").attr("checked", false);
			$("#reinvertirPost").attr("checked", false);
			$("#reinvertirVenNo").attr("checked", true);
			$('#tipoReinversion').hide();
			dwr.util.removeAllOptions('tipoReinversion');
			dwr.util.addOptions('tipoReinversion', {'C':'SOLO CAPITAL','CI':'CAPITAL MAS INTERES'});
		}
		if (reinversion == 'F') {
			$("#reinvertirVenSi").attr("checked", false);
			$("#reinvertirVenNo").attr("checked", false);
			$("#reinvertirPost").attr("checked", true);
			dwr.util.removeAllOptions('tipoReinversion');
			dwr.util.addOptions( "tipoReinversion", {'C':'SOLO CAPITAL', 'CI': 'CAPITAL MAS INTERES'});
			$('#tipoReinversion').hide();
		}
		if (reinversion2 == 'I') {
			$("#elimBr").remove();
			$("#reinvVenc").after('<br id="elimBr">');
			$('#reinvertirPost').show();
			$('#reinvPost').show();
		}else {
			$("#elimBr").remove();
			$('#reinvertirPost').hide();
			$('#reinvPost').hide();
		}

		if (reinversion2 == 'E') {
			$('#reinvertirVenSi').hide();
			$('#reinvertirVenNo').hide();
			$('#tdReinvertirVenNo').hide();
			$('#reinvVenc').hide();
			$('#reinvVencNo').hide();
			$('#reinvertirPost').attr('checked', true);
			$('#reinvertirPost').show();
			$('#reinvPost').show();
			deshabilitaControl('reinvertirPost');
		}else{
			$('#reinvertirVenSi').show();
			$('#reinvertirVenNo').show();
			$('#tdReinvertirVenNo').show();
			$('#reinvVenc').show();
			$('#reinvVencNo').show();
			$("#elimBr").remove();
			$('#reinvertirPost').hide();
			$('#reinvPost').hide();
			if (reinversion2 == 'I'){
				$("#reinvVenc").after('<br id="elimBr">');
				$('#reinvertirPost').show();
				$('#reinvPost').show();
			}
		}
	}

	function validaRecursos(){
		if(!$('#reinvertirVenSi').is(':checked') && !$('#reinvertirVenNo').is(':checked') && !$('#reinvertirPost').is(':checked')){
			mensajeSis('Seleccione el Tipo de Reinversión.');
			$('#reinvertirVenSi').focus();
			return false;
		} else{
			return true;
		}
		return true;
	}

	/* FUNCION PARA INICIALIZAR EL FORMULARIO DE APORTACIONES */
	function funcionInicializaAltaAportaciones(){
		inicializaForma('formaGenerica','aportacionID');
		$("#aportacionID").focus();
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
		ocultaMontoGlobal(false);
		$('#reinvertirPost').hide();
		$('#reinvPost').hide();
		$('#tdReinvertirVenNo').show();
		$('#reinvertirVenSi').show();
		$('#reinvVenc').show();
	}
});


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
			inicializaForma('formaGenerica','aportacionID');
			$('#tipoReinversion').val("");
			$('#plazoOriginal').val("");
			$('#tipoPagoInt').val("");
			$('#diasPeriodo').hide();
			$('#diasPeriodo').val('');
			$('#lbldiasPeriodo').hide();
			$('#pagoIntCal').val('');
			ocultaMontoGlobal(true);
			deshabilitaControl('reinvertirPost');
			$('#reinvertirPost').hide();
			$('#reinvPost').hide();
			$('#tdReinvertirVenNo').show();
			$('#reinvertirVenNo').show();
			$('#reinvVencNo').show();
			$('#reinvertirVenSi').show();
			$('#reinvVenc').show();
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
	$('#tdCajaRetiro').hide();
	$('#nombreCaja').val('');
	$('#cajaRetiro').val('0');
	return true;
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

// función que valida numero decimal y solo permita dos digitos
function validaDigitos(e, idControl){
	  // Backspace = 8, Enter = 13, ’0′ = 48, ’9′ = 57, ‘.’ = 46

        key = e.keyCode ? e.keyCode : e.which;

        if (key == 8) return true;

        if (key > 47 && key < 58) {
          if (document.getElementById(idControl).value === "") return true;
          var existePto = (/[.]/).test(document.getElementById(idControl).value);
          if (existePto === false){
              regexp = /.[0-9]{9}$/;
          }
          else {
            regexp = /.[0-9]{2}$/;
          }

          return !(regexp.test(document.getElementById(idControl).value));
        }

        if (key == 46) {
          if (document.getElementById(idControl).value === "") return false;
          regexp = /^[0-9]+$/;
          return regexp.test(document.getElementById(idControl).value);
        }

        return false;
}

function truncaDosDecimales (valor) {
	var posPunto=valor.indexOf('.');
	return valor.substring(0, posPunto+3);
}
/**
 * Consulta 10: Consulta el monto total de los productos vigentes del cliente y/o de su
 * grupo familiar.
 * @author avelasco
 */
function consultaMontoGlobal(){
	var tipoAportacionID = $('#tipoAportacionID').val();
	var clienteID = $('#clienteID').val();
	var AportacionBean = {
		'aportacionID' : tipoAportacionID,
		'clienteID' : clienteID
	};
	aportacionesServicio.consulta(10, AportacionBean, { async: false, callback: function(aportacion){
		if(aportacion!=null){
			montoGlobal = aportacion.montoGlobal;
		} else {
			montoGlobal = 0;
		}
	}});
	$('#montoGlobal').val(($('#monto').asNumber()+Number(montoGlobal)).toFixed(2));
	mostrarElementoPorClase('trMontoGlobal',Number(montoGlobal)>0);
	agregaFormatoControles('formaGenerica');
}
/**
 * Oculta el renglon de monto global y limpia el monto.
 * @param limpia indica si limpia o no el campo monto global.
 * @author avelasco
 */
function ocultaMontoGlobal(limpia){
	if(limpia){
		$('#montoGlobal').val('');
	}
	mostrarElementoPorClase('trMontoGlobal',false);
}

// funcion para cargar las opciones del combo aportación
function cargaComboOpciones () {
	dwr.util.removeAllOptions('opcionAport');

	var tipoAportacionID = $('#tipoAportacionID').val();
	var aportacionID = $('#aportacionID').val();
	var AportacionBean = {
		'aportacionID' : tipoAportacionID
	};

	if(parseInt(aportacionID) >= 0){
		aportacionesServicio.lista(17,AportacionBean,function(opciones){
			if(opciones != null || opciones != undefined){
				if (opciones.length>0){
					opciones.forEach(function(element) {
					  $('#opcionAport').append(
										new Option(element.descOpcionaport, element.opcionAport, true,
										true));
					});
					if (parseInt(aportacionID)>0){
						$('#opcionAport').val(opcionAp).selected = true;
					}else {
						$('#opcionAport').val(opciones[0].opcionAport).selected = true;
					}
				}
			}
		});
	}else{
		dwr.util.removeAllOptions('opcionAport');
		deshabilitaControl('opcionAport');
		$('#opcionAport').val('');
	}


}

function muestraOcultaCantidad (valCant,invReno) {
	if ($('#opcionAport').val()=='2' || $('#opcionAport').val()=='3' ) {
		if ($('#reinvertirVenSi').is(':checked')==false) {
			$('#tdTipoReinversion').hide();
			$('#tipoReinversion').hide();
		}
		$('#lblCant').show();
		$('#cantidadReno').show();
		if (parseFloat(valCant) > 0) {
			$('#cantidadReno').val(valCant);
		}else {
			$('#cantidadReno').val('');
		}
		$('#lblInvRenovar').show();
		$('#invRenovar').show();
		if (parseInt(invReno) > 0) {
			$('#invRenovar').val(invReno);
		}else {
			$('#invRenovar').val('');
		}
		$('#tdInvRenovar').show();
		$('#tdCantidadReno').show();
		$('#cantidadReno').formatCurrency({ positiveFormat: '%n', roundToDecimalPlace: 2});
	}else if ($('#opcionAport').val()=='4') {
		$('#lblCant').hide();
		$('#cantidadReno').hide();
		$('#cantidadReno').val('');
		$('#lblInvRenovar').show();
		$('#invRenovar').show();
		if (parseInt(invReno) > 0) {
			$('#invRenovar').val(invReno);
		}else {
			$('#invRenovar').val('');
		}

		if ($('#reinvertirVenSi').is(':checked')==false) {
			$('#tdTipoReinversion').hide();
			$('#tipoReinversion').hide();
		}
		$('#tdCantidadReno').hide();
		$('#tdInvRenovar').show();
	}else {
		$('#lblCant').hide();
		$('#cantidadReno').hide();
		$('#cantidadReno').val('');
		$('#lblInvRenovar').hide();
		$('#invRenovar').hide();
		$('#invRenovar').val('');
		$('#tdTipoReinversion').hide();
		$('#tdCantidadReno').hide();
		$('#tdInvRenovar').hide();
		if ($('#reinvertirVenSi').is(':checked')) {
			$('#tipoReinversion').show();
			$('#tdTipoReinversion').show();
		}
	}
}


function inicializaDifProgramado () {


	$('#capitaliza').val('');
	$('#lbldiasPago').hide();
	$('#diasPagoInt').hide();
	$('#diasPagoInt').each(function() {
		$('#diasPagoInt option').remove();
	});

	$('#tdReinvertirVenNo').show();
	$('#reinvertirVenNo').show();
	$('#reinvVencNo').show();
	$('#reinvertirVenSi').show();
	$('#reinvVenc').show();
	habilitaControl('reinvertirPost');

	$('#tdPlazoOriginal').show();
	$('#plazoOriginal').show();
	$('#tdPlazoOriginalIn').hide();
	$('#plazoOriginalIn').hide();
}

function fechaMayorIgual(fecha1, fecha2){

    //Split de las fechas recibidas para separarlas
    var x = fecha1.split("-");
    var z = fecha2.split("-");

    //Comparamos las fechas
    if (Date.parse(fecha1) >= Date.parse(fecha2)){
    	return false;
    }else{
    	return true;
    }
}

function ocultarSimulador(){
	$('#contenedorSimulador').html("");
	$('#contenedorSim').hide();
	$('#contenedorSimulador').hide();
}

function verificaSimulacion () {
	if (simulador==false) {
			mensajeSis("Se Requiere Simular el Calendario.");
			return false;
	}
}

function obtenerDias(fechaInicial, fechaFinal) {
	dt1 = new Date(fechaInicial);
	dt2 = new Date(fechaFinal);
	
	var diasCuota=0;
	var dPag=$('#diasPagoInt').val();
	var fechPagCuota=new Date(dt1.getFullYear(),dt1.getMonth()+1,dPag);

	if (fechPagCuota >= dt2) {
		// Indica que es solo una cuota
		diasCuota = Math.floor((Date.UTC(fechPagCuota.getFullYear(), fechPagCuota.getMonth(), fechPagCuota.getDate()) - 
					Date.UTC(dt1.getFullYear(), dt1.getMonth(), dt1.getDate()) ) 
					/(1000 * 60 * 60 * 24));
	}
	return diasCuota - 1;
}
