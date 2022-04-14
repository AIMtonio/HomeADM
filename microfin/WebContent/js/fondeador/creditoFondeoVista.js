var clienteEspecifico = 0;
$(document).ready(function() {
	esTab = true;
	var datosCompletos = false; 	// bandera para indicar si los datos de una funcion estan completos
	var ejecutarLlamada = 0;	// bandera para indicar si se ejecuta una funcion o no

	//Definicion de Constantes y Enums
	var catTipoTransaccionCreditoFondeo = {
			'agrega':'1',
			'modifica':'2',
			'simulador':'9'
	};

	var catTipoConsultaCreditoFondeo = {
			'principal'	: 1
	};

	var catTipoConsultaCtaNostro = {
			'resumen':4
	};
	var catOperacFechas = {// Operaciones Entre Fechas
			'sumaDias' : 1,
			'restaFechas' : 2
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------

	$('#creditoFondeoID').focus();

	$(':text').focus(function() {
		esTab = false;
	});
	consultaParametro();
	inicializarCampos();
	ocultarBotonPoliza();
	deshabilitaBoton('contrato', 'submit');
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('imprimir', 'submit');
	deshabilitaBoton('impPoliza', 'submit');
	deshabilitaBoton('cancelar', 'submit');
	llenaComboPlazoCredito();
	consultaMoneda();
	$('#imprimir').hide();
	$('#trFechaExigible').hide();
	$('#trFechaVencimiento').hide();
	$('#contrato').hide();


	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoFondeoID',
					'funcionExitoCreditoFondeo','funcionFalloCreditoFondeo');
		}
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#agrega').click(function() { // agrega validacion
		if ($('#tipoPagoCapital').val() == 'L') {
			sumaCapital(); // se agrego este metodo
		}

		if($('#fechaInicio').val() > parametroBean.fechaSucursal){
			mensajeSis('La Fecha de Inicio no Puede Ser Mayor a la del Sistema');
			$('#fechaInicio').val(parametroBean.fechaSucursal);
			$('#contenedorSimuladorLibre').html("");
			$('#contenedorSimuladorLibre').hide();
			$('#contenedorSimulador').html("");
			$('#contenedorSimulador').hide();
			$('#fechaInicio').focus();
			return;
		}
		$('#tipoTransaccion').val(catTipoTransaccionCreditoFondeo.agrega);
		botonClicModificar = "0";
	});


	$('#modifica').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionCreditoFondeo.modifica);
		botonClicModificar = "1";
	});

	$('#institutFondID').blur(function() {
		if(institucionFondeoInicial == 0 || institucionFondeoInicial != $('#institutFondID').val()){
			consultaInstitucionFondeo(this.id);
			validaInstitucion();
		}else{
			consultaInstitucionFondeoCredito(this.id);
		}
	});

	$('#institutFondID').bind('keyup',function(e){
		lista('institutFondID', '1', '1', 'nombreInstitFon', $('#institutFondID').val(), 'intitutFondeoLista.htm');
	});

	$('#institucionID').bind('keyup',function(e){
		listaAlfanumerica('institucionID', '1', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});

	$('#institucionID').blur(function() {
		if($('#institucionID').val()!=""){
			consultaInstitucion(this.id);
		}
	});
	/*evento para poner el foco en el campo tipofondeador */
	$('#folio').blur(function() {
		$('#tipoFondeador').focus();
	});


	$('#numCtaInstit').bind('keyup',function(e){
       	var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "institucionID";
		parametrosLista[0] = $('#institucionID').val();
		listaAlfanumerica('numCtaInstit', '0', '3', camposLista,parametrosLista, 'ctaNostroLista.htm');
	});

	$('#numCtaInstit').blur(function(){
   		if($('#numCtaInstit').val()!="" && $('#institucionID').val()!=""){
   			validaCtaNostroExiste('numCtaInstit','institucionID');
   		}
   	});

	$('#comDispos').blur(function(){
		calculaIVAComisionDis();
   	});

	$('#lineaFondeoID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "descripLinea";
		camposLista[1] = "institutFondID";
		parametrosLista[0] = $('#lineaFondeoID').val();
		parametrosLista[1] = $('#institutFondID').val();
		listaAlfanumerica('lineaFondeoID', '0', '2', camposLista, parametrosLista, 'listaLineasFondeador.htm');
	});

	$('#lineaFondeoID').blur(function() {
		consultaLineaFondeo(this.id);
	});

	$('#creditoFondeoID').blur(function() {
		habilitaControl('tipoFondeador');
		validaCreditoPasivo(this.id);
	});

	$('#creditoFondeoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreInstitFon";
			parametrosLista[0] = $('#creditoFondeoID').val();
			lista('creditoFondeoID', '1', '1', camposLista, parametrosLista, 'listaCreditoFondeo.htm');
		}
	});

	/*evento para poner el foco en el campo monto */

	$('#monto').blur(function() {
		validaCreditoSaldoLineaFondeo();

		if($('#siPagaIVA').is(':checked')){
			$('#iva').val((parametroBean.ivaSucursal*100).toFixed(2));
		}else{
			$('#iva').val(0.00);
		}

	});


	$('#calcInteresID').change(function() {
		if($('#calcInteresID').val()!= "1" ){
			$('#tasaBase').attr('readOnly',false);
			$('#sobreTasa').attr('readOnly',false);
			$('#techoTasa').attr('readOnly',false);
			$('#pisoTasa').attr('readOnly',false);
			$('#tasaFija').attr('readOnly',true);
			var tipoCon=1;
			var numLinea = $('#lineaFondeoID').val();
				var lineaFondBeanCon = {
						'lineaFondeoID':numLinea
				};
				lineaFonServicio.consulta(tipoCon,lineaFondBeanCon,function(lineaFond) {
					if(lineaFond!=null){
						$('#sobreTasa').val(lineaFond.tasaPasiva);
					}
				});
		}else{
			$('#tasaBase').attr('readOnly',true);
			$('#sobreTasa').attr('readOnly',true);
			$('#techoTasa').attr('readOnly',true);
			$('#pisoTasa').attr('readOnly',true);
			$('#tasaFija').attr('readOnly',false);

			$('#tasaBase').val("");
			$('#sobreTasa').val("");
			$('#techoTasa').val("");
			$('#pisoTasa').val("");
			$('#desTasaBase').val("");


		}
	});

	//Consulta Tasa Base al perder el Foco
	$('#tasaBase').blur(function() {
		if($('#tasaBase').asNumber() !=0){
			consultaTasaBase(this.id);
		}
		var TasaBaseBeanCon = {
				'tasaBaseID':$('#tasaBase').val()
			};
		var sobreTas = $('#sobreTasa').asNumber();
		var valorTasa = 0.0000;
		if($('#calcInteresID').val() == "2" ){
			tasasBaseServicio.consulta(1,TasaBaseBeanCon ,function(tasasBaseBean) {
				if(tasasBaseBean!=null){
					valorTasa = parseFloat(tasasBaseBean.valor);
				}
				var suma = (sobreTas + valorTasa);
				$('#tasaFija').val(suma);
			});

		}
		if($('#calcInteresID').val() == "4" ){
			tasasBaseServicio.consulta(2,TasaBaseBeanCon ,function(tasasBaseBean) {
				if(tasasBaseBean!=null){
					valorTasa = parseFloat(tasasBaseBean.valor);
				}
				var suma = (sobreTas + valorTasa);
				$('#tasaFija').val(suma);
			});

		}


	});

	// Buscar Tasa Base por Nombre
	$('#tasaBase').bind('keyup',function(e){
		if(this.value.length >= 2){
			lista('tasaBase', '2', '1', 'nombre', $('#tasaBase').val(), 'tasaBaseLista.htm');
		}
	});


	// eventos para corto o largo plazo
	$('#cortoPlazo').click(function(){
		$('#cortoPlazo').attr('checked',true);
		$('#largoPlazo').attr('checked',false);
		$('#plazoContable').val("C");
		$('#cortoPlazo').focus();
	});

	// eventos para corto o largo plazo
	$('#largoPlazo').click(function(){
		$('#cortoPlazo').attr('checked',false);
		$('#largoPlazo').attr('checked',true);
		$('#plazoContable').val("L");
		$('#largoPlazo').focus();
	});

	// eventos para seccion de calendario de pagos
	$('#fechaInhabil1').click(function(){
		$('#fechaInhabil2').attr('checked',false);
		$('#fechaInhabil1').attr('checked',true);
		$('#fechaInhabil').val("S");
		$('#fechaInhabil1').focus();
	});

	$('#fechaInhabil2').click(function(){
		$('#fechaInhabil1').attr('checked',false);
		$('#fechaInhabil2').attr('checked',true);
		$('#fechaInhabil').val("N");
		$('#fechaInhabil2').focus();
	});

	$('#ajusFecExiVen1').click(function(){
		$('#ajusFecExiVen2').attr('checked',false);
		$('#ajusFecExiVen1').attr('checked',true);
		$('#ajusFecExiVen').val("S");
		$('#ajusFecExiVen1').focus();
	});

	$('#ajusFecExiVen2').click(function(){
		$('#ajusFecExiVen1').attr('checked',false);
		$('#ajusFecExiVen2').attr('checked',true);
		$('#ajusFecExiVen').val("N");
		$('#ajusFecExiVen2').focus();
	});

	$('#ajusFecUlVenAmo1').click(function(){
		$('#ajusFecUlVenAmo2').attr('checked',false);
		$('#ajusFecUlVenAmo1').attr('checked',true);
		$('#ajusFecUlVenAmo').val("S");
		$('#ajusFecUlVenAmo1').focus();
	});

	$('#ajusFecUlVenAmo2').click(function(){
		$('#ajusFecUlVenAmo1').attr('checked',false);
		$('#ajusFecUlVenAmo2').attr('checked',true);
		$('#ajusFecUlVenAmo').val("N");
		$('#ajusFecUlVenAmo2').focus();
	});

	$('#diaPagoInteres1').click(function(){
		$('#diaPagoInteres2').attr('checked',false);
		$('#diaPagoInteres1').attr('checked',true);
		$('#diaPagoInteres').val("F");
		deshabilitaControl('diaMesInteres');
		$('#diaMesInteres').val("");
		$('#diaPagoInteres1').focus();
	});

	$('#diaPagoInteres2').click(function(){
		$('#diaPagoInteres1').attr('checked',false);
		$('#diaPagoInteres2').attr('checked',true);
		$('#diaPagoInteres').val("A");
		habilitaControl('diaMesInteres');
		$('#diaMesInteres').val(diaSucursal);
		$('#diaPagoInteres2').focus();
	});

	$('#diaPagoCapital1').click(function(){
		$('#diaPagoCapital2').attr('checked', false);
		$('#diaPagoCapital1').attr('checked', true);
		$('#diaPagoCapital').val("F");
		deshabilitaControl('diaMesCapital');
		$('#diaMesCapital').val("");
		if($('#tipoPagoCapital').val() == 'C'){
			$('#diaPagoInteres2').attr('checked',false);
			$('#diaPagoInteres1').attr('checked',true);
			$('#diaPagoInteres').val("F");
			deshabilitaControl('diaMesInteres');
			$('#diaMesInteres').val("");
		}
		$('#diaPagoCapital1').focus();
	});

	$('#diaPagoCapital2').click(function(){
		$('#diaPagoCapital1').attr('checked',false);
		$('#diaPagoCapital2').attr('checked',true);
		$('#diaPagoCapital').val("A");
		habilitaControl('diaMesCapital');
		$('#diaMesCapital').val(diaSucursal);
		if($('#tipoPagoCapital').val() == 'C'){
			$('#diaPagoInteres1').attr('checked',false);
			$('#diaPagoInteres2').attr('checked',true);
			$('#diaPagoInteres').val("A");
			habilitaControl('diaMesInteres');
			$('#diaMesInteres').val(diaSucursal);
		}
		$('#diaPagoCapital2').focus();
	});

	$('#periodicidadCap').blur(function(){
		if($('#tipoPagoCapital').val() == 'C'){
			$('#periodicidadInt').val($('#periodicidadCap').val());
		}
	});


	$('#calendIrregular').click(function() {
		if ($('#calendIrregular').is(':checked')) {
			deshabilitaControl('frecuenciaInt');
			deshabilitaControl('frecuenciaCap');
			deshabilitaControl('tipoPagoCapital');
			$('#tipoPagoCapital').val('L').selected = true;
			$('#frecuenciaInt').val('').selected = true;
			$('#frecuenciaCap').val('').selected =  true;
			$("#numAmortInteres").val('');
			$("#numAmortizacion").val('');
			$('#periodicidadInt').val('');
			$('#periodicidadCap').val('');
			$('#margenPriCuota').val('');
			$('#diaMesInteres').val('');
			$('#diaMesCapital').val('');
			deshabilitaControl('diaPagoInteres1');
			deshabilitaControl('diaPagoInteres2');
			deshabilitaControl('diaPagoCapital1');
			deshabilitaControl('diaPagoCapital2');
			deshabilitaControl('diaMesCapital');
			deshabilitaControl('diaMesInteres');
			deshabilitaControl('margenPriCuota');
			deshabilitaControl('numAmortInteres');
			deshabilitaControl('numAmortizacion');
		} else {
			$('#frecuenciaInt').val('').selected = true;
			$('#frecuenciaCap').val('').selected = true;
			habilitaControl('frecuenciaInt');
			habilitaControl('frecuenciaCap');
			habilitaControl('tipoPagoCapital');
			habilitaControl('numAmortizacion');

			if($("#tipoPagoCapital").val() == 'C' ) {
				deshabilitaControl('numAmortInteres');
			}else{
				habilitaControl('numAmortInteres');
			}
		}

		$('#numTransacSim').val("0");
	});




	$('#tipoPagoCapital').change(function() {
		validarEventoFrecuencia();
	});

	$('#plazoID').change(function() {
		if($('#plazoID').val()!= ""){
			consultaFechaVencimiento(this.id);
		}
	});

	$('#frecuenciaCap').change(function() {
		validarEventoFrecuencia();
		validaPeriodicidad();
		consultaFechaVencimiento('plazoID');
	});

	$('#frecuenciaCap').blur(function() {
		validarEventoFrecuencia();
		validaPeriodicidad();
		consultaFechaVencimiento('plazoID');
	});

	$('#frecuenciaInt').change(function() {
		validarEventoFrecuencia();
		validaPeriodicidad();
		consultaCuotasInteres('plazoID');
	});

	$('#frecuenciaInt').blur(function() {
		validarEventoFrecuencia();
		validaPeriodicidad();
		consultaFechaVencimiento('plazoID');
	});
	$('#capitalizaInteres').change(function(){
		if($('#capitalizaInteres').val()=='S' && $('#calendIrregular').is(':checked')== false){
				$('#tipoPagoCapital').val('I').seleted=false;
				deshabilitaControl('tipoPagoCapital');
				$('#frecuenciaCap').val('U').seleted=false;
				deshabilitaControl('frecuenciaCap');
				$('#frecuenciaInt').val().seleted=true;
				habilitaControl('frecuenciaInt');
				deshabilitaControl('margenPagIguales');

				}else if($('#calendIrregular').is(':checked')== false){
				habilitaControl('tipoPagoCapital');
				habilitaControl('frecuenciaCap');
		}
	});

	$('#tipoFondeador').change(function(){
			if($('#tipoFondeador').val()=='I'){
				$('#tipoFon').val('I');
			}else{
				$('#tipoFon').val('');
			}
	});


	// EVENTO DE CANBIO EN VALOR DE FECHA DE INICIO de credito pasivo
	$('#fechaInicio').change(function() {
		if ($('#fechaInicio').val()  != '' ){
				if($('#fechaInicio').val() > parametroBean.fechaSucursal){
					mensajeSis('La Fecha de Inicio no Puede Ser Mayor a la del Sistema');
					$('#fechaInicio').val(parametroBean.fechaSucursal);
					if ( $('#fechaInicio').val() < $('#fechInicLinea').val()){
						mensajeSis('La Fecha de Inicio del Crédito no puede ser Inferior \na la Fecha de Inicio de la Ventana de Disposición.');
						$('#fechaInicio').val($('#fechInicLinea').val());
						$('#fechaInicio').focus();
						$('#fechaInicio').select();
					}else{
						if ( $('#fechaInicio').val() > $('#fechaFinLinea').val()){
							mensajeSis('La Fecha de Inicio del Crédito no puede ser Superior \na la Fecha de Fin de la Ventana de Disposición.');
							$('#fechaInicio').val($('#fechaFinLinea').val());
							$('#fechaInicio').focus();
							$('#fechaInicio').select();
						}else{
							$('#fechaInicio').focus();
							if($('#plazoID').val()!= ""){
								consultaFechaVencimiento('plazoID');
							}
						}
					}
			}
		}
		$('#fechaContable').val($('#fechaInicio').val());
	});

	$('#numAmortizacion').change(function() {
		if($('#tipoPagoCapital').val() == 'C'){
			$('#numAmortInteres').val($('#numAmortizacion').val());
		}
		consultaFechaVencimientoCuotas('numAmortizacion');
	});

	$('#numAmortizacion').blur(function() {
		if($('#tipoPagoCapital').val() == 'C'){
			$('#numAmortInteres').val($('#numAmortizacion').val());
		}
		consultaFechaVencimientoCuotas('numAmortizacion');
	});

	$('#siPagaIVA').click(function(){
		var monedaID = $("#monedaID").val();
		if(monedaID != null && monedaID != 1) {
			$('#noPagaIVA').attr('checked',true);
			$('#siPagaIVA').attr('checked',false);
			$('#noPagaIVA').focus();
			$('#pagaIva').val("N");
			mensajeSis("El I.V.A solo aplica para moneda nacional.");
			return;
		}


		$('#noPagaIVA').attr('checked',false);
		$('#siPagaIVA').attr('checked',true);
		$('#pagaIva').val("S");
		$('#siPagaIVA').focus();
		$('#iva').val((parametroBean.ivaSucursal*100).toFixed(2));

	});

	$('#noPagaIVA').click(function(){
		$('#siPagaIVA').attr('checked',false);
		$('#noPagaIVA').attr('checked',true);
		$('#pagaIva').val("N");
		$('#noPagaIVA').focus();
		$('#iva').val('0.00');
	});
	$('#siPagaIVA').blur(function(){
		if($('#siPagaIVA').is(':checked')){
				$('#iva').val((parametroBean.ivaSucursal*100).toFixed(2));
			}else{
				$('#iva').val(0.00);
		}
	});
	$('#simular').click(function() {
		simulador();
	});

	// evento para generar reporte de la poliza
	$('#impPoliza').click(function(){
		$('#enlace').attr('href','RepPoliza.htm?polizaID='+numeroPoliza+'&fechaInicial='+parametroBean.fechaSucursal+
				'&fechaFinal='+parametroBean.fechaSucursal+'&nombreUsuario='+parametroBean.nombreUsuario);
	});

	// generación de contrato
	$('#contrato').click(function() {
		var tipoRep = 0;
		if($('#tipoFondeadorCred').val()=='M'){
			tipoRep = 2;
		}else{
			tipoRep = 1;
		}
		generaContratoPasivo(tipoRep);
	});

	//------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({
		rules: {
			creditoFondeoID: {
				required: true
			},
			fechaInicio: {
				required: true,
				date : true
			},
			fechaVencimien: {
				required: true,
				date : true
			},
			monto: {
				required: true,
				number: true
			},
			tipoPagoCapital: {
				required: true
			},
			plazoID: {
				required: true,
				numeroMayorCero: true
			},
			institutFondID: {
				required: true
			},
			lineaFondeoID: {
				required: true
			},
			tipoCalInteres: {
				required: true
			},
			calcInteresID: {
				required: true
			},
			nacionalidadInsDes: {
				required: function() { return $('#tiposFons').val()=='G';},
			},
			cobraISR: {
				required: true
			},
			tipoInstitID: {
				required: function() { return $('#tiposFons').val()=='G';},
			},
			numAmortizacion: {
				required: true
			},
			folio: {
				required: true
			},
			numCtaInstit:{
				required:true
			},
			tasaBase:{
				required: function(){return $('#calcInteresID').val() > 1 ;},
			}
		},
		messages: {
			creditoFondeoID: {
				required: 'Especifique Número'
			},
			fechaInicio: {
				required: 'Especifique Fecha',
				date : 'Fecha Incorrecta'
			},
			fechaVencimien: {
				required: 'Especifique Fecha',
				date : 'Fecha Incorrecta'
			},
			monto: {
				required: 'Especifique Monto',
				number: 'Cantidad Incorrecta'
			},
			tipoPagoCapital: {
				required: 'Especifique Tipo de Pago'
			},
			plazoID: {
				required: 'Especifique Plazo',
				numeroMayorCero: 'Plazo esta vacio'
			},
			institutFondID: {
				required: 'Especifique Institución de Fondeo',
			},
			lineaFondeoID: {
				required: 'Especifique Línea de Fondeo',
			},
			tipoCalInteres: {
				required: 'Especifique Tipo Cal. Interés.',
			},
			calcInteresID: {
				required: 'Especifique Cálculo de Interés',
			},
			nacionalidadInsDes: {
				required: 'Especifique Nacionalidad de Institucion',
			},
			cobraISR: {
				required: 'Especifique si Cobra o no ISR',
			},
			tipoInstitID: {
				required: 'Especifique Tipo de Institucion',
			},
			numAmortizacion: {
				required: 'Especifique Numero de Cuotas',
			},
			folio: {
				required: 'Especifique Folio',
			},
			numCtaInstit:{
				required:'Especifique Número de Cuenta de Institución'
			},
			tasaBase:{
				required:'Especifique Tasa Base'
			}
		}
	});


	//------------ Validaciones de Controles -------------------------------------
	// funcion para consultar el credito pasivo
	function validaCreditoPasivo(controlID){
		var jqCreditoID = eval("'#" + controlID + "'");
		var varCreditoPasivo = $(jqCreditoID).val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(varCreditoPasivo==0){
			habilitaBoton('agrega', 'submit');
			habilitaBoton('simular', 'submit');
			$('#simular').show();
			deshabilitaBoton('cancelar', 'submit');
			deshabilitaBoton('contrato', 'submit');
			$('#contrato').hide();
			inicializarCampos();
			consultaMoneda();
			habilitarCalendarioPagosInteres();
			ocultarBotonPoliza();
			$('#imprimir').hide();
			$('#calendIrregular').attr('checked',false);
		}else{
			if(varCreditoPasivo != '' && !isNaN(varCreditoPasivo) && esTab){
				var creditoBeanCon = {
						'creditoFondeoID':varCreditoPasivo
				};
	  			$('#contenedorSimulador').hide();
	  			creditoFondeoServicio.consulta(catTipoConsultaCreditoFondeo.principal, creditoBeanCon,function(creditoPasivo) {
					if(creditoPasivo!=null){
						if(varCreditoPasivo != varCreditoFondeoAgregado){
							ocultarBotonPoliza();
						}
						if(creditoPasivo.tipoFondeador=='I'){
							$('#imprimir').show();
							habilitaBoton('imprimir', 'submit');
						}else{
							$('#imprimir').hide();
							deshabilitaBoton('imprimir', 'submit');
						}
						dwr.util.setValues(creditoPasivo);
						esTab=true;
						consultaLineaFondeoCredito(creditoPasivo.lineaFondeoID);
						$('#tasaFija').val(creditoPasivo.tasaFija);
						$('#monto').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
						//habilitaBoton('modifica', 'submit');
						habilitaBoton('cancelar', 'submit');
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('simular', 'submit'); // si el credito pasivo ya existe  se oculta el boton simular
						$('#simular').hide();

						$('#plazoID').val(creditoPasivo.plazoID).selected = true;
						$('#frecuenciaInt').val(creditoPasivo.frecuenciaInt).selected = true;
						$('#frecuenciaCap').val(creditoPasivo.frecuenciaCap).selected = true;
						if(creditoPasivo.tipoPagoCapital=="C"){
							deshabilitarCalendarioPagosInteres();
						}
						if(creditoPasivo.fechaInhabil=='S'){
							$('#fechaInhabil1').attr('checked',true);
							$('#fechaInhabil2').attr('checked',false);
							$('#fechaInhabil').val("S");
						}  else{
							$('#fechaInhabil1').attr('checked',false);
							$('#fechaInhabil2').attr('checked',true);
							$('#fechaInhabil').val("A");
						}
						if(creditoPasivo.ajusFecExiVen=='S'){
							$('#ajusFecExiVen2').attr('checked',false);
							$('#ajusFecExiVen1').attr('checked',true);
							$('#ajusFecExiVen').val("S");
						}else{
							$('#ajusFecExiVen2').attr('checked',true);
							$('#ajusFecExiVen1').attr('checked',false);
							$('#ajusFecExiVen').val("N");
						}
						if(creditoPasivo.calendIrregular=='S'){
							$('#calendIrregular').attr("checked",true);
							deshabilitaControl('tipoPagoCapital');
						}else{
							$('#calendIrregular').attr("checked",false);
							habilitaControl('tipoPagoCapital');
						}
						if(creditoPasivo.ajusFecUlVenAmo=='S'){
							$('#ajusFecUlVenAmo2').attr('checked',false);
							$('#ajusFecUlVenAmo1').attr('checked',true);
							$('#ajusFecUlVenAmo').val("S");
						}else{
							$('#ajusFecUlVenAmo2').attr('checked',true);
							$('#ajusFecUlVenAmo1').attr('checked',false);
							$('#ajusFecUlVenAmo').val("N");
						}
						if(creditoPasivo.diaPagoCapital == 'F'){
							$('#diaPagoCapital2').attr('checked', false);
							$('#diaPagoCapital1').attr('checked', true);
							$('#diaPagoCapital').val("F");
							$('#diaMesCapital').val("");
						}else{
							$('#diaPagoCapital1').attr('checked', false);
							$('#diaPagoCapital2').attr('checked', true);
							$('#diaPagoCapital').val("A");
							$('#diaMesCapital').val(creditoPasivo.diaMesCapital);
						}

						if(creditoPasivo.diaPagoInteres == 'F'){
							$('#diaPagoInteres2').attr('checked',false);
							$('#diaPagoInteres1').attr('checked',true);
							$('#diaPagoInteres').val("F");
							$('#diaMesInteres').val("");
						}else{
							$('#diaPagoInteres1').attr('checked',false);
							$('#diaPagoInteres2').attr('checked',true);
							$('#diaPagoInteres').val("A");
							$('#diaMesInteres').val(creditoPasivo.diaMesInteres);
						}

						if(creditoPasivo.plazoContable == 'L'){
							$('#cortoPlazo').attr('checked',false);
							$('#largoPlazo').attr('checked',true);
							$('#plazoContable').val("L");
							$('#largoPlazo').focus();
						}else{
							$('#cortoPlazo').attr('checked',true);
							$('#largoPlazo').attr('checked',false);
							$('#plazoContable').val("C");
							$('#largoPlazo').focus();
						}

						$('input[name="siPagaIVA"]').attr('checked', (creditoPasivo.pagaIva=='S'));
						$('input[name="noPagaIVA"]').attr('checked', (creditoPasivo.pagaIva=='N'));
						$("#iva").val(creditoPasivo.iva);

						if(creditoPasivo.tasaBase !=0 && creditoPasivo.tasaBase  != ""){
							consultaTasaBase('tasaBase');
						}else{
							$('#desTasaBase').val("");
							$('#tasaBase').val("");
						}

						if(botonClicModificar != "0" ){
							ocultarBotonPoliza();
						}
						if(creditoPasivo.tipoInstitID==null || creditoPasivo.tipoInstitID==''||creditoPasivo.tipoInstitID==0){
							$('#tipo').hide();
						}else{
							$('#tipo').show();
						}
					}else{
						inicializarCampos();
						mensajeSis("No Existe el Crédito Pasivo");
						$('#creditoFondeoID').focus();
						$('#creditoFondeoID').select();
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('cancelar', 'submit');
						deshabilitaBoton('simular', 'submit'); // si el credito pasivo no existe  se oculta el boton simular
						$('#simular').hide();
						botonClicModificar = "1";
						ocultarBotonPoliza();

					}
				});
			}
		}
	}

	function consultaInstitucionFondeo(idControl) {
		setTimeout("$('#cajaLista').hide();", 200);
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		var instFondeoBeanCon = {
  				'institutFondID':numInstituto
				};

		if(numInstituto != '' && !isNaN(numInstituto) && esTab){
			fondeoServicio.consulta(2,instFondeoBeanCon,function(instituto) {

				if(instituto!=null){
					$('#nombreInstitFondeo').val(instituto.nombreInstitFon);
					$('#tipoInstitID').val(instituto.tipoInstitID);

					$('#tipoFondeadorCred').val(instituto.tipoFondeador);
					$('#institutFondIDCon').val(instituto.institutFondID);
					if(instituto.tipoInstitID==null || instituto.tipoInstitID==''){
						$('#tipo').hide();
					}else{
						$('#tipo').show();
					}
					$('#tipoInstitDes').val(instituto.descripcionTipoIns);
					$('#nacionalidadIns').val(instituto.nacionalidad);
					$('#nacionalidadInsDes').val(instituto.descripNacionalidad);
					$('#cobraISR').val(instituto.cobraISR).selected = true;
					if(instituto.cobraISR == 'S' ){
						$('#tasaISR').attr('readonly',false);
						$('#tasaISR').val(parametroBean.tasaISR);
						$('#tasaISR').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					}else{
						$('#tasaISR').attr('readonly',true);
						$('#tasaISR').val("0.00");
					}
					consultaTipoFondeador(numInstituto);
					$('#lineaFondeoID').val("");
					$('#folio').val("");
					$('#saldoLinea').val("");
					$('#descripLinea').val("");
					$('#tipoLinFondeaID').val("");
					$('#desTipoLinFondea').val("");
				}else{
					mensajeSis("No Existe la Institución");
					$('#institutFondID').focus();
					$('#institutFondID').select();
					$('#institutFondID').val("");
					$('#nombreInstitFondeo').val("");
					$('#lineaFondeoID').val("");
					$('#folio').val("");
					$('#saldoLinea').val("");
					$('#descripLinea').val("");
					$('#tipoLinFondeaID').val("");
					$('#desTipoLinFondea').val("");
					$('#tipoInstitID').val("");
				    $('#tipoInstitDes').val("");
					$('#nacionalidadIns').val("");
					$('#nacionalidadInsDes').val("");
					$('#cobraISR').val("");
					$('#tasaISR').val("");


				}
			});
		}
	}

	function consultaInstitucionFondeoCredito(idControl) {
		setTimeout("$('#cajaLista').hide();", 200);
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		var instFondeoBeanCon = {
  				'institutFondID':numInstituto
				};

		if(numInstituto != '' && !isNaN(numInstituto) && esTab){
			fondeoServicio.consulta(2,instFondeoBeanCon,function(instituto) {
				if(instituto!=null){
					institucionFondeoInicial = numInstituto;
					$('#nombreInstitFondeo').val(instituto.nombreInstitFon);
					$('#tipoInstitID').val(instituto.tipoInstitID);
					$('#tipoInstitDes').val(instituto.descripcionTipoIns);
					$('#nacionalidadIns').val(instituto.nacionalidad);
					$('#nacionalidadInsDes').val(instituto.descripNacionalidad);
					$('#cobraISR').val(instituto.cobraISR).selected = true;
					$('#tipoFondeadorCred').val(instituto.tipoFondeador);
					$('#institutFondIDCon').val(instituto.institutFondID);
					if(instituto.cobraISR == 'S' ){
						$('#tasaISR').attr('readonly',false);
						$('#tasaISR').val(parametroBean.tasaISR);
						$('#tasaISR').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					}else{
						$('#tasaISR').val("0.00");
						$('#tasaISR').attr('readonly',true);
					}
					consultaTipoFondeador(numInstituto);
				}else{
					mensajeSis("No Existe la Institución");
					institucionFondeoInicial = 0;


				}
			});
		}
	}

	function validaIVAMonedaID(monedaID) {
		if(monedaID != null && monedaID > 1) {
			$('input[name="siPagaIVA"]').attr('checked', false);
			$('input[name="noPagaIVA"]').attr('checked', true);
			$("#iva").val("0.00");
			$("#iva").attr('readonly', 'readonly');
			$('#pagaIva').val("N");
		}
		else {
			$('input[name="siPagaIVA"]').attr('checked', true);
			$('input[name="noPagaIVA"]').attr('checked', false);
			$('#iva').val((parametroBean.ivaSucursal*100).toFixed(2));
			$('#pagaIva').val("S");
		}
	}

	// consulta de la linea de fondeo
	function consultaLineaFondeo(idControl) {
		var jqLineaFon = eval("'#" + idControl + "'");
		var numLinea = $(jqLineaFon).val();
		var tipoCon=1;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numLinea != '' && !isNaN(numLinea) && esTab){
			var lineaFondBeanCon = {
					'lineaFondeoID':numLinea
			};
			lineaFonServicio.consulta(tipoCon,lineaFondBeanCon,function(lineaFond) {
				if(lineaFond!=null){
					var numInstitut = $('#institutFondID').val();
					var lineafondeo = lineaFond.institutFondID;
					if(lineafondeo==numInstitut){
						esTab = true;
						$('#descripLinea').val(lineaFond.descripLinea);
						$('#tipoLinFondeaID').val(lineaFond.tipoLinFondeaID);
						$('#institucionID').val(lineaFond.institucionID);
						$('#numCtaInstit').val(lineaFond.numCtaInstit);
						$('#cuentaClabe').val(lineaFond.cuentaClabe);
						$('#fechInicLinea').val(lineaFond.fechInicLinea);
						$('#fechaFinLinea').val(lineaFond.fechaFinLinea);
						$('#fechaMaxVenci').val(lineaFond.fechaMaxVenci);
						$('#factorMora').val(lineaFond.factorMora);
						$('#tasaFija').val(lineaFond.tasaFija);
						$('#saldoLinea').val(lineaFond.saldoLinea);
						$('#saldoLinea').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
						$('#refinancia').val(lineaFond.refinanciamiento);
						$('#calcInteresID').val(lineaFond.calcInteresID);
						$('#monedaID').val(lineaFond.monedaID);
						if(lineaFond.calcInteresID!=1){
							$('#tasaBase').val(lineaFond.tasaBase);
							consultaTasaBase('tasaBase');
							$('#sobreTasa').val(lineaFond.tasaPasiva);
							var TasaBaseBeanCon = {
									'tasaBaseID':lineaFond.tasaBase
								};
							if(lineaFond.calcInteresID ==2){
								tasasBaseServicio.consulta(3,TasaBaseBeanCon ,function(tasasBaseBean) {
									var sobreTas = parseFloat($('#sobreTasa').val());
									if(tasasBaseBean!=null){

										var valorTasa = parseFloat(tasasBaseBean.valor);
										var suma = (sobreTas + valorTasa);
										$('#tasaFija').val(suma);
									}else{

										$('#tasaFija').val(sobreTas);
									}
								});
							}else{
								var sobreTas = parseFloat($('#sobreTasa').val());
								tasasBaseServicio.consulta(2,TasaBaseBeanCon ,function(tasasBaseBean) {
									if(tasasBaseBean!=null){
										var valorTasa = parseFloat(tasasBaseBean.valor);
										var suma = (sobreTas + valorTasa);
										$('#tasaFija').val(suma);
									}else{
										$('#tasaFija').val(sobreTas);

									}
								});
							}

						}else{
							$('#tasaBase').val('');
							$('#sobreTasa').val('');
						}

						validaCreditoSaldoLineaFondeo();
						consultaInstitucionFondeoCredito('institutFondID');
						consultaTipoLinFondea('tipoLinFondeaID');
						consultaInstitucionLineaFondeo('institucionID');
						$('#tasaFija').val(lineaFond.tasaPasiva);
						validaIVAMonedaID(lineaFond.monedaID);
					}else{
						mensajeSis("La linea de Fondeo no Corresponde con la Institución");
					}

				}else{
					var linea = $('#lineaFondeoID').val();
					if(linea != '0' ){
						mensajeSis("No Existe la Linea Fondeador");
						$('#lineaFondeoID').focus();
						$('#lineaFondeoID').select();
						$('#lineaFondeoID').val("");
					}
				}
			});
		}
	}

	// consulta de la linea de fondeo
	function consultaLineaFondeoCredito(numLinea) {
		var tipoCon=1;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numLinea != '' && !isNaN(numLinea) && esTab){
			var lineaFondBeanCon = {
					'lineaFondeoID':numLinea
			};

			lineaFonServicio.consulta(tipoCon,lineaFondBeanCon,function(lineaFond) {
				if(lineaFond!=null){
					$('#descripLinea').val(lineaFond.descripLinea);
					$('#tipoLinFondeaID').val(lineaFond.tipoLinFondeaID);
					$('#saldoLinea').val(lineaFond.saldoLinea);
					$('#fechInicLinea').val(lineaFond.fechInicLinea);
					$('#fechaFinLinea').val(lineaFond.fechaFinLinea);
					$('#fechaMaxVenci').val(lineaFond.fechaMaxVenci);
					esTab = true;
					$('#saldoLinea').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					validaCreditoSaldoLineaFondeo();
					consultaInstitucionFondeoCredito('institutFondID');
					consultaTipoLinFondea('tipoLinFondeaID');
					consultaInstitucionLineaFondeo('institucionID');
				}else{
					var linea = $('#lineaFondeoID').val();
					if(linea != '0' ){
						mensajeSis("No Existe la Linea Fondeador");
						$('#lineaFondeoID').focus();
						$('#lineaFondeoID').select();
						$('#lineaFondeoID').val("");
					}
				}
			});
		}
	}

	// valida el saldo de la linea de fondeo
	function validaCreditoSaldoLineaFondeo(){
		if($('#monto').asNumber() > $('#saldoLinea').asNumber() && $('#creditoFondeoID').val()== "0"){
			mensajeSis("La Linea de Fondeo no tiene Saldo suficiente");
			$('#monto').focus();
			$('#monto').val("");
		}
	}

	// funcion para consultar el tipo de linea de fondeo
	function consultaTipoLinFondea(idControl) {
		var jqTipoLinea = eval("'#" + idControl + "'");
		var numTipoLinea = $(jqTipoLinea).val();
		var tipoLFondeoBeanCon = {
				'tipoLinFondeaID':numTipoLinea
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numTipoLinea != '' && !isNaN(numTipoLinea) && esTab && numTipoLinea != 0 ){
			tiposLineaFonServicio.consulta(2,tipoLFondeoBeanCon,function(tipoLinea) {
				if(tipoLinea!=null){
					$('#desTipoLinFondea').val(tipoLinea.descripcion);
				}else{
					mensajeSis("No Existe el Tipo");
					$(jqTipoLinea).focus();
					$(jqTipoLinea).select();
					$(jqTipoLinea).val('');
					$('#desTipoLinFondea').val('');
				}
			});
		}
	}

	//Consulta Tasa Base
	function consultaTasaBase(idControl) {
		var jqTasa  = eval("'#" + idControl + "'");
		var tasaBase = $(jqTasa).val();
		var TasaBaseBeanCon = {
				'tasaBaseID':tasaBase
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(tasaBase != '' && !isNaN(tasaBase) && esTab){
			tasasBaseServicio.consulta(1,TasaBaseBeanCon ,function(tasasBaseBean) {
				if(tasasBaseBean!=null){
					$('#desTasaBase').val(tasasBaseBean.nombre);
				}else{
					mensajeSis("No Existe la tasa base");
					$('#tasaBaseID').focus();
					$('#tasaBaseID').val("");
				}
			});
		}
	}

	// funcion para eventos cuando se selecciona dia de pago de interes
	//por aniversario o fin de mes, dependiendo de la frecuencia.
	function validarEventoFrecuencia() {
		switch($('#tipoPagoCapital').val()){
			case "C": // si el tipo de pago es CRECIENTES
				habilitaControl('margenPagIguales');
				$('#frecuenciaInt').val($('#frecuenciaCap').val()).selected = true;
				$('#periodicidadInt').val($('#periodicidadCap').val());
				$('#numAmortInteres').val($('#numAmortizacion').val());
				if($('#diaPagoCapital1').is(':checked')){
					$('#diaPagoInteres').val('F');
					$('#diaPagoInteres1').attr('checked',true);
					$('#diaPagoInteres2').attr('checked',false);
				}else if($('#diaPagoCapital2').is(':checked')){
					$('#diaPagoInteres').val('A');
					$('#diaPagoInteres2').attr('checked',true);
					$('#diaPagoInteres1').attr('checked',false);
				}
				deshabilitarCalendarioPagosInteres();
				habilitaControl('numAmortizacion');
				if( $('#frecuenciaCap').val() == 'S' || $('#frecuenciaCap').val() == 'C'|| $('#frecuenciaCap').val() == 'Q' ||
						$('#frecuenciaCap').val() == 'A' ){
					$('#diaMesInteres').val('');
					$('#diaMesCapital').val('');
					$('#diaPagoInteres1').attr('checked',true);
					$('#diaPagoCapital1').attr("checked",true);
					$('#diaPagoInteres2').attr('checked',false);
					$('#diaPagoCapital2').attr("checked",false);
					$('#diaPagoInteres').val("F") ;
					$('#diaPagoCapital').val("F") ;
					deshabilitaControl('diaPagoCapital1');
					deshabilitaControl('diaPagoCapital2');
					deshabilitaControl('frecuenciaInt');
					deshabilitaControl('diaPagoInteres1');
					deshabilitaControl('diaPagoInteres2');
					deshabilitaControl('diaMesInteres');
					deshabilitaControl('diaMesCapital');
					deshabilitaControl('periodicidadCap');
					deshabilitaControl('periodicidadInt');
				}else{
					if($('#frecuenciaCap').val() == 'P' ){
						$('#diaMesInteres').val('');
						$('#diaMesCapital').val('');
						$('#diaPagoInteres1').attr("checked",true) ;
						$('#diaPagoCapital1').attr("checked",true) ;
						$('#diaPagoInteres2').attr("checked",false) ;
						$('#diaPagoCapital2').attr("checked",false) ;
						$('#diaPagoInteres').val("F") ;
						$('#diaPagoCapital').val("F") ;
						deshabilitaControl('diaPagoInteres1');
						deshabilitaControl('diaPagoInteres2');
						deshabilitaControl('periodicidadInt');
						habilitaControl('periodicidadCap');

						deshabilitaControl('diaPagoCapital1');
						deshabilitaControl('diaPagoCapital2');

					}else{
						// si el tipo de pago es UNICO se deshabilitan las cajas para indicar numero de cuotas
						if($('#frecuenciaCap').val() == 'U' ){
							mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
							$('#numAmortizacion').val("1");
							$('#numAmortInteres').val("1");
							deshabilitaControl('numAmortizacion');
							deshabilitaControl('numAmortInteres');
							$('#periodicidadCap').val($('#noDias').val());
							$('#periodicidadInt').val($('#noDias').val());
						}else{
							habilitaControl('diaMesCapital');
							habilitaControl('diaPagoCapital1');
							habilitaControl('diaPagoCapital2');
							habilitaControl('numAmortizacion');
							habilitaControl('numAmortInteres');
							if($('#diaPagoCapital1').is(':checked')){
								$('#diaPagoCapital2').attr("checked",false) ;
								$('#diaPagoCapital').val("F");
								$('#diaMesCapital').val(diaSucursal);
							}else{
								if($('#diaPagoCapital2').is(':checked')){
									$('#diaPagoCapital').val("A");
									$('#diaPagoCapital1').attr("checked",false) ;
									$('#diaMesCapital').val(diaSucursal);
								}
							}
							if($('#diaPagoInteres1').is(':checked')){
								$('#diaPagoInteres2').attr("checked",false) ;
								$('#diaPagoInteres').val("F");
								$('#diaMesInteres').val(diaSucursal);
							}else{
								if($('#diaPagoInteres2').is(':checked')){
									$('#diaPagoInteres').val("A");
									$('#diaPagoInteres1').attr("checked",false) ;
									$('#diaMesInteres').val(diaSucursal);
								}
							}
						}
					}
				}
			break;
			case "I":
				habilitarCalendarioPagosInteres();
				deshabilitaControl('margenPagIguales');
				$('#margenPagIguales').val('');
				// si el tipo de pago es UNICO se trata de solo una cuota
				if ($('#frecuenciaCap').val() == 'U' || $('#frecuenciaInt').val() == 'U') {
					if ($('#frecuenciaCap').val() == 'U') {
						if ($('#tipoPagoCapital').val() != "I") {
							mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
						}
						$('#numAmortizacion').val("1");
						$('#periodicidadCap').val($('#noDias').val());
						deshabilitaControl('numAmortizacion');
					}else{
						frecuenciaIgualesNoUnico();
					}
					if ($('#frecuenciaInt').val() == 'U') {
						if ($('#tipoPagoCapital').val() != "I") {
							mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
						}
						$('#numAmortInteres').val("1");
						$('#periodicidadInt').val($('#noDias').val());
						deshabilitaControl('numAmortInteres');
					}else{
						frecuenciaIgualesNoUnico();
					}
				} else {
					frecuenciaIgualesNoUnico();
				}
			break;
			case "L":
				deshabilitaControl('margenPagIguales');
				$('#margenPagIguales').val('');
				if ($('#frecuenciaCap').val() == 'U' || $('#frecuenciaInt').val() == 'U') {
					if ($('#frecuenciaCap').val() == 'U') {
						if ($('#tipoPagoCapital').val() != "I") {
							mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
						}
						$('#numAmortizacion').val("1");
						$('#periodicidadCap').val($('#noDias').val());
						deshabilitaControl('numAmortizacion');
					}
					if ($('#frecuenciaInt').val() == 'U') {
						if ($('#tipoPagoCapital').val() != "I") {
							mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
						}
						$('#numAmortInteres').val("1");
						$('#periodicidadInt').val($('#noDias').val());
						habilitaControl('numAmortInteres');
					}
				} else {
					habilitaControl('frecuenciaInt');
					habilitaControl('numAmortInteres');
					habilitaControl('numAmortizacion');
					if($('#frecuenciaInt').val() == 'S' || $('#frecuenciaInt').val() == 'C'|| $('#frecuenciaInt').val() == 'Q' ||
							$('#frecuenciaInt').val() == 'A'  ){
						$('#diaMesInteres').val('');
						$('#diaPagoInteres1').attr("checked",true) ;
						$('#diaPagoInteres2').attr("checked",false) ;
						deshabilitaControl('diaPagoInteres1');
						deshabilitaControl('diaPagoInteres2');
						deshabilitaControl('diaMesInteres');
						deshabilitaControl('periodicidadInt');
						$('#diaPagoInteres').val("F") ;
					}else{
						if($('#frecuenciaInt').val() == 'P' ){
							$('#diaMesInteres').val('');
							$('#diaPagoInteres1').attr("checked",true) ;
							$('#diaPagoInteres2').attr("checked",false) ;
							$('#diaPagoInteres').val("F") ;
							habilitaControl('periodicidadInt');
						}else{
							habilitarCalendarioPagosInteres();
							if($('#diaPagoInteres1').is(':checked')){
								$('#diaPagoInteres2').attr("checked",false) ;
								$('#diaPagoInteres').val("F");
								$('#diaMesInteres').val(diaSucursal);
							}else{
								if($('#diaPagoInteres2').is(':checked')){
									$('#diaPagoInteres').val("A");
									$('#diaPagoInteres1').attr("checked",false) ;
									$('#diaMesInteres').val(diaSucursal);
								}
							}
						}
					}

					if( $('#frecuenciaCap').val() == 'S' || $('#frecuenciaCap').val() == 'C'|| $('#frecuenciaCap').val() == 'Q' ||
							$('#frecuenciaCap').val() == 'A' ){
						$('#diaMesCapital').val('');
						$('#diaPagoCapital1').attr("checked",true) ;
						$('#diaPagoCapital2').attr("checked",false) ;
						deshabilitaControl('diaPagoCapital1');
						deshabilitaControl('diaPagoCapital2');
						deshabilitaControl('diaMesCapital');
						deshabilitaControl('periodicidadCap');
						$('#diaPagoCapital').val("F") ;
					}else{
						if($('#frecuenciaCap').val() == 'P' ){
							$('#diaMesCapital').val('');
							$('#diaPagoCapital2').attr("checked",false) ;
							$('#diaPagoCapital1').attr("checked",true) ;
							$('#diaPagoCapital').val("F") ;
							deshabilitaControl('diaPagoCapital1');
							deshabilitaControl('diaPagoCapital2');
							habilitaControl('periodicidadCap');
						}else{
							habilitaControl('diaMesCapital');
							habilitaControl('diaPagoCapital1');
							habilitaControl('diaPagoCapital2');
							if($('#diaPagoCapital1').is(':checked')){
								$('#diaPagoCapital2').attr("checked",false) ;
								$('#diaPagoCapital').val("F");
								$('#diaMesCapital').val(diaSucursal);
							}else{
								if($('#diaPagoCapital2').is(':checked')){
									$('#diaPagoCapital').val("A");
									$('#diaPagoCapital1').attr("checked",false) ;
									$('#diaMesCapital').val(diaSucursal);
								}
							}
						}
					}
				}

			break;
		}
	} // FIN validarEventoFrecuencia()

	//para no repetir codigo en case de iguales
	function frecuenciaIgualesNoUnico(){

		habilitaControl('numAmortInteres');
		habilitaControl('numAmortizacion');
		if($('#frecuenciaInt').val() == 'S' || $('#frecuenciaInt').val() == 'C'|| $('#frecuenciaInt').val() == 'Q' ||
				$('#frecuenciaInt').val() == 'A' ){
			$('#diaMesInteres').val('');
			$('#diaPagoInteres1').attr("checked",true) ;
			$('#diaPagoInteres2').attr("checked",false) ;
			deshabilitaControl('diaPagoInteres1');
			deshabilitaControl('diaPagoInteres2');
			deshabilitaControl('diaMesInteres');
			deshabilitaControl('periodicidadInt');
			$('#diaPagoInteres').val("F") ;
		}else{
			if($('#frecuenciaInt').val() == 'P' ){
				$('#diaMesInteres').val('');
				$('#diaPagoInteres1').attr("checked",true) ;
				$('#diaPagoInteres2').attr("checked",false) ;
				$('#diaPagoInteres').val("F") ;
				habilitaControl('periodicidadInt');
			}else{
				habilitarCalendarioPagosInteres();
				if($('#diaPagoInteres1').is(':checked')){
					$('#diaPagoInteres2').attr("checked",false) ;
					$('#diaPagoInteres').val("F");
					$('#diaMesInteres').val(diaSucursal);
				}else{
					if($('#diaPagoInteres2').is(':checked')){
						$('#diaPagoInteres').val("A");
						$('#diaPagoInteres1').attr("checked",false) ;
						$('#diaMesInteres').val(diaSucursal);
					}
				}
			}
		}

		if( $('#frecuenciaCap').val() == 'S' || $('#frecuenciaCap').val() == 'C'|| $('#frecuenciaCap').val() == 'Q' ||
				$('#frecuenciaCap').val() == 'A' ){
			$('#diaMesCapital').val('');
			$('#diaPagoCapital1').attr("checked",true) ;
			$('#diaPagoCapital2').attr("checked",false) ;
			deshabilitaControl('diaPagoCapital1');
			deshabilitaControl('diaPagoCapital2');
			deshabilitaControl('diaMesCapital');
			deshabilitaControl('periodicidadCap');
			$('#diaPagoCapital').val("F") ;
		}else{
			if($('#frecuenciaCap').val() == 'P' ){
				$('#diaMesCapital').val('');
				$('#diaPagoCapital2').attr("checked",false) ;
				$('#diaPagoCapital1').attr("checked",true) ;
				$('#diaPagoCapital').val("F");
				deshabilitaControl('diaPagoCapital1');
				deshabilitaControl('diaPagoCapital2');
				habilitaControl('periodicidadCap');
			}else{
				habilitaControl('diaMesCapital');
				habilitaControl('diaPagoCapital1');
				habilitaControl('diaPagoCapital2');
				if($('#diaPagoCapital1').is(':checked')){
					$('#diaPagoCapital2').attr("checked",false) ;
					$('#diaPagoCapital').val("F");
					$('#diaMesCapital').val(diaSucursal);
				}else{
					if($('#diaPagoCapital2').is(':checked')){
						$('#diaPagoCapital').val("A");
						$('#diaPagoCapital1').attr("checked",false) ;
						$('#diaMesCapital').val(diaSucursal);
					}
				}
			}
		}


	}
	// asigna en dias la periodicidad, dependiendo de la frecuencia seleccionada
	function validaPeriodicidad() {
		switch($('#frecuenciaCap').val()){
			case "S": // SI ES SEMANAL
				$('#periodicidadCap').val('7');
				break;
			case "C": // SI ES CATORCENAL
				$('#periodicidadCap').val('14');
				break;
			case "Q": // SI ES QUINCENAL
				$('#periodicidadCap').val('15');
				break;
			case "M": // SI ES MENSUAL
				$('#periodicidadCap').val('30');
				break;
			case "B": // SI ES BIMESTRAL
				$('#periodicidadCap').val('60');
				break;
			case "T": // SI ES TRIMESTRAL
				$('#periodicidadCap').val('90');
				break;
			case "R": // SI ES TETRAMESTRAL
				$('#periodicidadCap').val('120');
				break;
			case "E": // SI ES SEMANAL
				$('#periodicidadCap').val('180');
				break;
			case "A": // SI ES ANUAL
				$('#periodicidadCap').val('360');
				break;

		}

		switch($('#frecuenciaInt').val()){
			case "S": // SI ES SEMANAL
				$('#periodicidadInt').val('7');
				break;
			case "C": // SI ES CATORCENAL
				$('#periodicidadInt').val('14');
				break;
			case "Q": // SI ES QUINCENAL
				$('#periodicidadInt').val('15');
				break;
			case "M": // SI ES MENSUAL
				$('#periodicidadInt').val('30');
				break;
			case "B": // SI ES BIMESTRAL
				$('#periodicidadInt').val('60');
				break;
			case "T": // SI ES TRIMESTRAL
				$('#periodicidadInt').val('90');
				break;
			case "R": // SI ES TETRAMESTRAL
				$('#periodicidadInt').val('120');
				break;
			case "E": // SI ES SEMANAL
				$('#periodicidadInt').val('180');
				break;
			case "A": // SI ES ANUAL
				$('#periodicidadInt').val('360');
				break;
		}
	}	// FIN validaPeriodicidad()


	// funcion para deshabilitar la seccion del calendario de pagos que corresponde con interes
	function deshabilitarCalendarioPagosInteres() {
		deshabilitaControl('numAmortInteres');
		deshabilitaControl('frecuenciaInt');
		deshabilitaControl('diaMesInteres');
		deshabilitaControl('diaPagoInteres1');
		deshabilitaControl('diaPagoInteres2');
		deshabilitaControl('periodicidadInt');
	}

	// funcion para habilitar la seccion del calendario de pagos que corresponde con interes
	function habilitarCalendarioPagosInteres() {
		habilitaControl('frecuenciaInt');
		habilitaControl('numAmortInteres');
		habilitaControl('diaMesInteres');
		habilitaControl('diaPagoInteres1');
		habilitaControl('diaPagoInteres2');
	}

	// funcion para llenar el combo de plazos
	function llenaComboPlazoCredito() {
		dwr.util.removeAllOptions('plazoID');
		dwr.util.addOptions('plazoID', {"":'SELECCIONAR'});
		plazosCredServicio.listaCombo(3, function(plazoCreditoBean){
			dwr.util.addOptions('plazoID', plazoCreditoBean, 'plazoID', 'descripcion');
		});
	}

	// consulta la fecha de vencimiento de acuerdo al plazo y frecuencia
	function consultaFechaVencimiento(idControl){
		var jqPlazo = eval("'#" + idControl + "'");
		var tipoCon	= 3;
		var PlazoBeanCon = {
				'plazoID' :$(jqPlazo).val(),
				'fechaActual' : $('#fechaInicio').val(),
				'frecuenciaCap' : $('#frecuenciaCap').val(),
				'periodicidadCap'	: $('#periodicidadCap').val()
		};
		if($(jqPlazo).val() == ""){
			$('#fechaVencimien').val("");
		}else{
			plazosCredServicio.consulta(tipoCon,PlazoBeanCon,function(plazos) {
				if(plazos!=null){
					if (plazos.fechaActual  != '' ){
						if ( plazos.fechaActual > $('#fechaMaxVenci').val()){
							mensajeSis('La Fecha de Vencimiento del Crédito no puede ser Superior \na la Fecha Máxima de Vencimiento de la Ventana de Disposición.'
									+'\nSeleccione un plazo diferente.');
							$('#fechaVencimien').val("");
							$('#plazoID').focus();
							$('#plazoID').select();
						}else{
							$('#fechaVencimien').val(plazos.fechaActual);
							if ($('#frecuenciaCap').val() != "U") {
								$('#numAmortizacion').val(plazos.numCuotas);
								if ($('#tipoPagoCapital').val() == 'C') {
									$('#numAmortInteres').val(plazos.numCuotas);
								} else {
									consultaCuotasInteres('plazoID');
								}
							} else {
								if ($('#tipoPagoCapital').val() == 'I') {
									$('#numAmortizacion').val("1");
									calculaNodeDias(plazos.fechaActual);
								}
							}
						}
					}
				}
			});
		}
	}

	// calcula el numero de dias entre las fecha inicio y fecha final
	function calculaNodeDias(varfechaCal) {
		if ($('#fechaInicio').val() != '') {
			var opeFechaBean = {
					'primerFecha' : $('#fechaVencimien').val(),
					'segundaFecha' : $('#fechaInicio').val()
			};

			if ($('#frecuenciaCap').val() == "U" || $('#frecuenciaCap').val() == "P" ) {
				var opeFechaBean = {
					'primerFecha'  : $('#fechaVencimien').val(),
					'segundaFecha' : $('#fechaInicio').val()
				};
			}

			operacionesFechasServicio.realizaOperacion(opeFechaBean,catOperacFechas.restaFechas,function(data) {
				if (data != null) {
					$('#noDias').val(data.diasEntreFechas);// número de dias de la fecha inicial a la fecha de vencimiento.
					// si la frecuencia es Pago UNICO los dias que hay de diferencia seran
					// las periodicidades de capital e interes
					if ($('#frecuenciaCap').val() == "U" || $('#frecuenciaCap').val() == "P" ) {
						$('#periodicidadCap').val(data.diasEntreFechas);
					}
				}
			});
		}
	}

	// calcula el numero de dias entre las fecha inicio y fecha final
	function calculaNodeDiasInteres(varfechaCal) {
		if ($('#fechaInicio').val() != '') {
			var opeFechaBean = {
					'primerFecha' : $('#fechaVencimien').val(),
					'segundaFecha' : $('#fechaInicio').val()
			};

			if ($('#frecuenciaInt').val() == "U" || $('#frecuenciaInt').val() == "P" ) {
				var opeFechaBean = {
					'primerFecha'  : $('#fechaVencimien').val(),
					'segundaFecha' : $('#fechaInicio').val()
				};
			}

			operacionesFechasServicio.realizaOperacion(opeFechaBean,catOperacFechas.restaFechas,function(data) {
				if (data != null) {
					$('#noDias').val(data.diasEntreFechas);// número de dias de la fecha inicial a la fecha de vencimiento.
					// si la frecuencia es Pago UNICO los dias que hay de diferencia seran
					// las periodicidades de capital e interes
					if ($('#frecuenciaInt').val() == "U" || $('#frecuenciaInt').val() == "P" ) {
						$('#periodicidadInt').val(data.diasEntreFechas);
					}
				}
			});
		}
	}

	// valida que los datos que se requieren para generar el simulador de
	// amortizaciones esten indicados.
	function validaDatosSimulador(){
		if($('#fechaInicio').val() == ''){
			mensajeSis("Fecha de Inicio Vacía");
			$('#fechaInicio').focus();
			datosCompletos = false;
		}else{
			if($('#fechaVencimien').val() == ''){
				mensajeSis("Fecha de Vencimiento Vacía");
				$('#fechaVencimien').focus();
				datosCompletos = false;
			}else{
				if($('#tipoPagoCapital').val() == ''){
					mensajeSis("Seleccionar Tipo de Pago de Capital.");
					$('#tipoPagoCapital').focus();
					datosCompletos = false;
				}else{
					if ($('#frecuenciaCap').val() == 'U'
						&& $('#tipoPagoCapital').val() != 'I') {
						mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
						$('#tipoPagoCapital').focus();
						datosCompletos = false;
					}else{
						if($('#calcInteresID').val()!=""){
							if($('#calcInteresID').val() == '1'){
								if($('#tasaFija').val() == '' || $('#tasaFija').val() == '0' ){
									mensajeSis("Tasa de Interés Vací­a");
									$('#tasaFija').focus();
									datosCompletos = false;
								}else{
									if($('#monto').asNumber() <= "0" ){
										mensajeSis("El Monto Está Vacío");
										$('#monto').focus();
										datosCompletos = false;
									}else{
										datosCompletos = true;
									}
								}
							}else{
								if($('#monto').asNumber() <= "0" ){
									mensajeSis("El Monto Está Vacío");
									$('#monto').focus();
									datosCompletos = false;
								}else{
									datosCompletos = true;
								}
							}
						}else{
							mensajeSis("Seleccionar Tipo Cal. Interés");
							$('#calcInteresID').focus();
							datosCompletos = false;
						}
					}
				}
			}
		}
		return datosCompletos;
	}


	// llamada al cotizador de amortizaciones
	function simulador(){
		var params = {};

		if($('#calendIrregular').is(':checked')){
			mostrarGridLibresEncabezado();
		}else{
			ejecutarLlamada = validaDatosSimulador();
			if(ejecutarLlamada == true){
				if($('#calcInteresID').val()==1 ) {

					switch($('#tipoPagoCapital').val()){
						case "C": // si el tipo de pago es CRECIENTES
							tipoLista = 1;
						break;
						case "I" :// si el tipo de pago es IGUALES
							if($('#capitalizaInteres').val()=='S'){
								tipoLista =11;
							}else{
								tipoLista = 2;
							}
						break;
						case  "L": // si el tipo de pago es LIBRES
							tipoLista = 3;
						break;
						default:
							tipoLista = 1;
					}
				}else{
					switch($('#tipoPagoCapital').val()){
						case "C": // si el tipo de pago es CRECIENTES
							mensajeSis("Con tasa variable, no se permiten pagos de capital Crecientes");
							tipoLista = 99 ;
						break;
						case "I" :// si el tipo de pago es IGUALES
							if($('#capitalizaInteres').val()=='S'){
								tipoLista =11;
							}else{
								tipoLista = 4;
							}

						break;
						case  "L": // si el tipo de pago es LIBRES
							tipoLista = 5;
						break;
						default:
							if($('#capitalizaInteres').val()=='S'){
								tipoLista =11;
							}else{
								tipoLista = 4;
							}
					}
				}
				if(tipoLista != 99 ){
					params['tipoLista'] = tipoLista;

					if($.trim($('#frecuenciaCap').val())!=""){
						if(tipoLista == 1){
							// si se trata de una frecuencia de capital : MENSUAL, BIMESTRAL, TRIMESTRAL, TETRAMESTRAL, SEMESTRAL
							if($('#frecuenciaCap').val() =='M' || $('#frecuenciaCap').val() =='B' || $('#frecuenciaCap').val() =='T'
								|| $('#frecuenciaCap').val() =='R'|| $('#frecuenciaCap').val() =='S'){
								// Si el dia de pago no esta definido
								if(($('#diaPagoCapital2').is(':checked')) != true &&($('#diaPagoCapital1').is(':checked')) != true ){
									mensajeSis("Debe Seleccionar un día de pago.");
									datosCompletos = false;
								}else{
									// si el dia de pago seleccionado es dia del mes
									if(($('#diaPagoCapital2').is(':checked')) == true ){
										if($.trim($('#diaMesCapital').val()) ==''|| $('#diaMesCapital').val() ==null || $('#diaMesCapital').val() =='0'){
											mensajeSis("Especifique día del mes.");
											$('#diaMesCapital').focus();
											datosCompletos = false;
										}else{
											// valida que el numero de amortizaciones no este vacio
											if($('#numAmortizacion').asNumber() == 0){
												mensajeSis("Número de cuotas vacío");
												$('#numAmortizacion').focus();
												datosCompletos = false;
											}else{
												datosCompletos = true;
											}
										}
									}else{
										// valida que el numero de amortizaciones no este vacio
										if($('#numAmortizacion').asNumber() == 0){
											mensajeSis("Número de cuotas vacío");
											$('#numAmortizacion').focus();
											datosCompletos = false;
										}else{
											datosCompletos = true;
										}
									}
								}
							}else{
								if($('#numAmortizacion').asNumber() == 0){
									mensajeSis("Número de cuotas vacío");
									$('#numAmortizacion').focus();
									datosCompletos = false;
								}else{
									datosCompletos = true;
								}
							}
						}else{
							if(tipoLista == 2 ||tipoLista ==3||tipoLista ==4||tipoLista ==5 ||tipoLista ==11){
								if($.trim($('#frecuenciaCap').val())!=""){
									if($.trim($('#frecuenciaInt').val())!=""){
										if($('#frecuenciaCap').val() =='M' || $('#frecuenciaCap').val() =='B'
											|| $('#frecuenciaCap').val() =='T'|| $('#frecuenciaCap').val() =='R'|| $('#frecuenciaCap').val() =='S'
											|| $('#frecuenciaInt').val() =='M'|| $('#frecuenciaInt').val() =='B'|| $('#frecuenciaInt').val() =='T'
											|| $('#frecuenciaInt').val() =='R'|| $('#frecuenciaInt').val() =='S'){
										// Valida que este seleccionado el dia de pago para capital e interes
											if(($('#diaPagoCapital1').is(':checked') != true && $('#diaPagoCapital2').is(':checked') != true)
													||($('#diaPagoInteres1').is(':checked') != true && $('#diaPagoInteres2').is(':checked') != true)){
												mensajeSis('Debe Seleccionar un día de pago.');
												datosCompletos = false;
											}else {
												// si el dia de pago seleccionado es dia del mes
												if($('#diaPagoCapital2').is(':checked') == true){
													if($.trim($('#diaMesCapital').val()) ==''||$('#diaMesCapital').val() ==null || $('#diaMesCapital').val() =='0'){
														mensajeSis("Especifique día del mes capital.");
														datosCompletos = false;
													}else{
														if($('#diaPagoInteres2').is(':checked') == true &&
																	($.trim($('#diaMesInteres').val()) ==''||$('#diaMesInteres').val() ==null || $('#diaMesInteres').val() =='0')){
															mensajeSis("Especifique día del mes Interés.");
															datosCompletos = false;
														}else{
															// valida que el numero de amortizaciones no este vacio
															if($('#numAmortizacion').asNumber() == 0){
																mensajeSis("Número de cuotas vacío");
																datosCompletos = false;
															}else{
																datosCompletos = true;
															}
														}
													}
												}else{
													// valida que el numero de amortizaciones no este vacio
													if($('#numAmortizacion').asNumber() == 0){
														mensajeSis("Número de cuotas vacío");
														datosCompletos = false;
													}else{
														// valida que el nÃºmero de amortizaciones no este vacio
														if($('#numAmortInteres').asNumber() == 0){
															mensajeSis("Especificar Número de Cuotas de Interés.");
															$('#numAmortInteres').focus();
															datosCompletos =false;
														}else{
															datosCompletos =true;
														}
													}
												}
											}
										}else{
											// valida que el numero de amortizaciones no este vacio
											if($('#numAmortizacion').asNumber() == 0){
												mensajeSis("Número de cuotas vacío");
												datosCompletos = false;
											}else{
												// valida que el nÃºmero de amortizaciones no este vacio
												if($('#numAmortInteres').asNumber() == 0){
													mensajeSis("Especificar Número de Cuotas de Interés.");
													$('#numAmortInteres').focus();
													datosCompletos =false;
												}else{
													datosCompletos =true;
												}
											}
										}
									}else{
										mensajeSis("Seleccionar Frecuencia de Interés.");
										$('#frecuenciaInt').focus();
										datosCompletos = false;
									}
								}else{
									mensajeSis("Seleccionar Frecuencia de Capital.");
									$('#frecuenciaCap').focus();
									datosCompletos = false;
								}
							}
						}
						if(datosCompletos){
							params['monto'] 			= $('#monto').asNumber();
							params['tasaFija']			= $('#tasaFija').asNumber();
							params['frecuenciaCap'] 	= $('#frecuenciaCap').val();
							params['frecuenciaInt'] 	= $('#frecuenciaInt').val();
							params['periodicidadCap'] 	= $('#periodicidadCap').val();
							params['periodicidadInt'] 	= $('#periodicidadInt').val();
							params['diaPagoCapital'] 	= $('#diaPagoCapital').val();
							params['diaPagoInteres'] 	= $('#diaPagoInteres').val();
							params['diaMesCapital'] 	= $('#diaMesCapital').val();
							params['diaMesInteres'] 	= $('#diaMesInteres').val();
							params['fechaInicio'] 		= $('#fechaInicio').val();
							params['numAmortizacion'] 	= $('#numAmortizacion').asNumber();
							params['numAmortInteres'] 	= $('#numAmortInteres').asNumber();
							params['fechaInhabil'] 		= $('#fechaInhabil').val();
							params['ajusFecUlVenAmo'] 	= $('#ajusFecUlVenAmo').val();
							params['ajusFecExiVen'] 	= $('#ajusFecExiVen').val();
							params['numTransacSim'] 	= '0';
							params['pagaIva'] 			= $('#pagaIva').val();
							params['iva'] 				= $('#iva').asNumber();
							params['cobraISR'] 			= $('#cobraISR').val();
							params['tasaISR'] 			= $('#tasaISR').asNumber();
							params['margenPagIguales'] 	= $('#margenPagIguales').val();
							params['margenPriCuota'] 	= $('#margenPriCuota').val();
							params['empresaID'] 		= parametroBean.empresaID;
							params['usuario'] 			= parametroBean.numeroUsuario;
							params['fecha'] 			= parametroBean.fechaSucursal;
							params['direccionIP'] 		= parametroBean.IPsesion;
							params['sucursal'] 			= parametroBean.sucursal;

							bloquearPantallaAmortizacion();
							if($('#tipoPagoCapital').val()!="L"){
								$.post("simPagCreditoFondeo.htm", params, function(data){
									if(data.length >0 || data != null) {
										$('#contenedorSimulador').html(data);
										$('#contenedorSimulador').show();
										$('#contenedorSimuladorLibre').html("");
										$('#contenedorSimuladorLibre').hide();
										$('#numTransacSim').val($('#transaccion').val());

										// actualiza la nueva fecha de vencimiento que devuelve el cotizador
										var jqFechaVen = eval("'#fech'");
										$('#fechaVencimien').val($(jqFechaVen).val());
										// asigna el valor de monto de la cuota devuelto por el cotizador
										$('#montoCuota').val($('#valorMontoCuota').val());
										$('#montoCuota').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
										// actualiza el numero de cuotas generadas por el cotizador
										$('#numAmortInteres').val($('#valorCuotasInt').val());
										$('#numAmortizacion').val($('#cuotas').val());
									}else{
										$('#contenedorSimulador').html("");
										$('#contenedorSimulador').hide();
										$('#contenedorSimuladorLibre').html("");
										$('#contenedorSimuladorLibre').hide();
									}
									$('#contenedorForma').unblock();
								});
							}else{
								$.post("simPagLibresCapCreditoFondeo.htm", params, function(data){
									if(data.length >0 || data != null) {
										$('#contenedorSimuladorLibre').html(data);
										$('#contenedorSimuladorLibre').show();
										$('#contenedorSimulador').html("");
										$('#contenedorSimulador').hide();
										$('#numTransacSim').val($('#transaccion').val());
										// actualiza la nueva fecha de vencimiento que devuelve el cotizador
										var jqFechaVen = eval("'#fech'");
										$('#fechaVencimien').val($(jqFechaVen).val());

										// asigna el valor de monto de la cuota devuelto por el cotizador
										$('#montoCuota').val($('#valorMontoCuota').val());
										$('#montoCuota').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
										// actualiza el numero de cuotas generadas por el cotizador
										$('#numAmortInteres').val($('#valorCuotasInt').val());
										$('#numAmortizacion').val($('#cuotas').val());
									}else{
										$('#contenedorSimuladorLibre').html("");
										$('#contenedorSimuladorLibre').hide();
										$('#contenedorSimulador').html("");
										$('#contenedorSimulador').hide();
									}
									$('#contenedorForma').unblock();
								});
							}
						}
					}else{
						mensajeSis("Seleccionar Frecuencia");
						$('#frecuenciaCap').focus();
						datosCompletos = false;
					}
				}
			}
		}
	}//fin funcion simulador()

	//	consulta la fecha de vencimiento si se cambia el valor de la cuota de capital cambia
	function consultaFechaVencimientoCuotas(idControl){
		var jqPlazo  = eval("'#" + idControl + "'");
		var plazo = $(jqPlazo).val();
		var tipoCon=4;
		var PlazoBeanCon = {
				'frecuenciaCap' 	:$('#frecuenciaCap').val(),
				'numCuotas' 		: $('#numAmortizacion').val(),
				'periodicidadCap'	: $('#periodicidadCap').val(),
				'fechaActual' 		: $('#fechaInicio').val()
		};
		if(plazo == '0'){
			$('#fechaVencimien').val("");
		}else{
			plazosCredServicio.consulta(tipoCon,PlazoBeanCon,function(plazos) {
				if(plazos!=null){
					if ( plazos.fechaActual > $('#fechaMaxVenci').val()){
						mensajeSis('La Fecha de Vencimiento del Crédito no puede ser Superior \na la Fecha Máxima de Vencimiento de la Ventana de Disposición.'
								+'\nSeleccione un plazo diferente.');
						$('#fechaVencimien').val("");
						$('#plazoID').focus();
						$('#plazoID').select();
					}else{
						$('#fechaVencimien').val(plazos.fechaActual);
					}
				}
			});
		}
	}

	// consulta de monedas
	function consultaMoneda() {
		dwr.util.removeAllOptions('monedaID');
		monedasServicio.listaCombo(3, function(monedas){
			dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
		});
	}

	// consulta las cuotas de interes
	function consultaCuotasInteres(idControl){
		var jqPlazo  = eval("'#" + idControl + "'");
		var plazo = $(jqPlazo).val();
		var tipoCon=3;
		var PlazoBeanCon = {
				'plazoID' :plazo,
				'fechaActual' : $('#fechaInicio').val(),
				'frecuenciaCap' : $('#frecuenciaInt').val()
		};
		if(plazo == '0'){
			$('#fechaVencimien').val("");
		}else{
			plazosCredServicio.consulta(tipoCon,PlazoBeanCon,function(plazos) {
				if(plazos!=null){
					if ($('#frecuenciaInt').val() == "U" && $('#tipoPagoCapital').val() == 'I') {
						$('#numAmortInteres').val("1");
						calculaNodeDias(plazos.fechaActual);
					}else{
						$('#numAmortInteres').val(plazos.numCuotas);
					}
				}
			});
		}
	}

	//Funcion de consulta para obtener el nombre de la institucion
	function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);
		var InstitutoBeanCon = {
			'institucionID':numInstituto
		};
		if(numInstituto != '' && !isNaN(numInstituto)){
			institucionesServicio.consultaInstitucion(2,InstitutoBeanCon,function(instituto){
				if(instituto!=null){
					$('#descripcionInstitucion').val(instituto.nombre);
					$('#numCtaInstit').val("");
					$('#cuentaClabe').val("");
				}else{
					mensajeSis("No existe la Institución");
					$('#institucionID').val('');
					$('#institucionID').focus();
					$('#descripcionInstitucion').val("");
					$('#numCtaInstit').val("");
					$('#cuentaClabe').val("");
				}
			});
		}
	}

	//Funcion de consulta para obtener el nombre de la institucion
	function consultaInstitucionLineaFondeo(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);
		var InstitutoBeanCon = {
			'institucionID':numInstituto
		};
		if(numInstituto != '' && !isNaN(numInstituto)){
			institucionesServicio.consultaInstitucion(2,InstitutoBeanCon,function(instituto){
				if(instituto!=null){
					$('#descripcionInstitucion').val(instituto.nombre);
				}else{
					mensajeSis("No existe la Institución");
					$('#institucionID').val('');
					$('#institucionID').focus();
					$('#descripcionInstitucion').val("");
					$('#numCtaInstit').val("");
					$('#cuentaClabe').val("");
				}
			});
		}
	}

	function validaCtaNostroExiste(numCta,institID){
  		var jqNumCtaInstit = eval("'#" + numCta + "'");
  		var jqInstitucionID = eval("'#" + institID + "'");
  		var numCtaInstit = $(jqNumCtaInstit).val();
  		var institucionID = $(jqInstitucionID).val();
  		var CtaNostroBeanCon = {
  				'institucionID':institucionID,
  				'numCtaInstit':numCtaInstit
  		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCtaInstit != '' && !isNaN(numCtaInstit) && institucionID != '' && !isNaN(institucionID) ){
			cuentaNostroServicio.consultaExisteCta(catTipoConsultaCtaNostro.resumen,CtaNostroBeanCon, function(ctaNostro){
				if(ctaNostro!=null){
					if(ctaNostro.estatus =='A'){
						$('#cuentaClabe').val(ctaNostro.cuentaClabe);
					}else{
	  					mensajeSis("El Número de Cuenta Bancaria esta Inactiva.");
						$('#numCtaInstit').focus();
					}
  				}else{
  					mensajeSis("El Número de Cuenta Bancaria no existe.");
					$('#numCtaInstit').focus();
					$('#cuentaClabe').val("");
  				}
  			});
  		}
  	}


	function calculaIVAComisionDis(){
		calculosyOperacionesDosDecimalesMultiplicacion($('#comDispos').asNumber(), parametroBean.ivaSucursal, 'ivaComDispos');
	}
	/*
	 * FUNCION PARA HACER OPERACION DE MULTIPLICACION Y OBTENER
	 * EL RESULTADO REDONDEADO CON DOS DECIMALES
	 */
	function calculosyOperacionesDosDecimalesMultiplicacion(valor1, valor2,controlID) {
  		var jqControl = eval("'#" + controlID + "'");
		var calcOperBean = {
				'valorUnoA' : valor1,
				'valorDosA' : valor2,
				'valorUnoB' : 0,
				'valorDosB' : 0,
				'numeroDecimales' : 2
		};
		setTimeout("$('#cajaLista').hide();", 200);
		calculosyOperacionesServicio.calculosYOperaciones(1,calcOperBean,function(valoresResultado) {
					if (valoresResultado != null) {
						$(jqControl).val(valoresResultado.resultadoDosDecimales);
						$(jqControl).formatCurrency({
									positiveFormat : '%n',
									negativeFormat : '%n',
									roundToDecimalPlace : 2
								});
					} else {
						mensajeSis('Indique el monto de nuevo.');
						$(jqControl).val("0.00");
					}
				});
	}
	// se imprime el contrato de inversionista
	$('#imprimir').click(function() {
		var tipoReporte = 2;
		var nombreInstitucion =  parametroBean.nombreInstitucion;
		var sucursal = parametroBean.sucursal;
		var fechaAc = parametroBean.fechaSucursal;
		var instit =$('#creditoFondeoID').val();
			$('#ligaImp').attr('href','contratoInv.htm?fechaActual='+fechaAc+'&creditoFondeoID='+instit+
					'&tipoReporte='+tipoReporte+'&sucursal='+sucursal+'&nombreInstitucion='+nombreInstitucion);
	});

	function validaInstitucion() {
		var numInst = $('#institutFondID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numInst != '' && !isNaN(numInst) && esTab){
				var instFondeoBeanCon = {
  				'institutFondID':$('#institutFondID').val()
				};
				fondeoServicio.consulta(catTipoConsultaCreditoFondeo.principal,instFondeoBeanCon,function(instFondeo) {
						if(instFondeo!=null){
							$('#tiposFons').val(instFondeo.tipoFondeador);
							$('#tipoFondeadorCred').val(instFondeo.tipoFondeador);
							$('#institutFondIDCon').val(instFondeo.institutFondID);
						}else{
							mensajeSis("No Existe la Institución de Fondeo");
							}
				});



		}
	}

	function generaContratoPasivo(tipoRep){

			var tipoReporte    		= tipoRep;
			var creditoFondeoID  	= $('#creditoFondeoID').val();
			var institutFondID    	= $('#institutFondIDCon').val();
			var nombreInstitucion 	=  parametroBean.nombreInstitucion;

			var pagina='contratoCredPasivo.htm?'+'tipoReporte='+tipoReporte+'&creditoFondeoID='+creditoFondeoID+
					'&institutFondID='+institutFondID+'&nombreInstitucion='+nombreInstitucion;
				window.open(pagina);

	}

	function consultaTipoFondeador(idControl) {
		var Gubernamental="G";

		var instFondeoBeanCon = {
  				'institutFondID':idControl
				};
		if(idControl != '' && !isNaN(idControl) && esTab){
			fondeoServicio.consulta(1,instFondeoBeanCon,function(instituto) {
				if(instituto!=null){
					if(instituto.tipoFondeador==Gubernamental){
						$('#tipoFondeador').val("F");
						deshabilitaControl('tipoFondeador');
					}else{
						habilitaControl('tipoFondeador');
					}
				}
			});
		}
	}

});

var varCreditoFondeoControl;
var varCreditoFondeoAgregado;
var parametroBean ;
var fechaSucursal = parametroBean.fechaSucursal;
var diaSucursal = parametroBean.fechaSucursal.substring(8,10);
var tipoLista = 0;	// indica el numero de lista que se ejecutara en el cotizador de amortizaciones
var institucionFondeoInicial = 0; // guarda el numero de institucion de fondeo que se consulta.
var numeroPoliza;
var botonClicModificar = 0;


//funcion a ejecutar cuando se realizo con exito una transaccion
function funcionExitoCreditoFondeo(){
	inicializarRadiosCalendarioPagos();
	agregaFormatoControles('formaGenerica');
	agregaFormatoControles('contenedorSimulador');
	deshabilitaBoton('agrega', 'submit');
	if(botonClicModificar == "0" ){
		numeroPoliza = $('#campoGenerico').val(); // se obtiene el numero de poliza generado en el proceso
		if(numeroPoliza>0){
			$('#contrato').show();
			$('#impPoliza').show();
			$('#enlace').attr('href');
			habilitaBoton('impPoliza', 'submit');
			habilitaBoton('contrato', 'button');
		}
		if($('#tipoFon').val()=='I'){
			$('#imprimir').show();
			habilitaBoton('imprimir', 'submit');
		}else{
			$('#imprimir').hide();
		}
	}else{
		if(botonClicModificar == "1" ){
			ocultarBotonPoliza();
		}
	}
	varCreditoFondeoAgregado = $('#consecutivo').val();
	inicializarCampos();
	$('#contenedorSimulador').html("");
	$('#contenedorSimulador').hide();
	$('#contenedorSimuladorLibre').html("");
	$('#contenedorSimuladorLibre').hide();
}
//funcion a ejecutar cuando se devolvio errores una transaccion
function funcionFalloCreditoFondeo(){
	ocultarBotonPoliza();
}

// funcion para ocultar poliza
function ocultarBotonPoliza(){
	botonClicModificar = "1";
	$('#impPoliza').hide();
	$('#enlace').removeAttr('href');
	deshabilitaBoton('impPoliza', 'submit');
	numeroPoliza = 0;

}

//funcion para inicializar los campos de calendario de pagos con
//valores por default
function inicializarRadiosCalendarioPagos(){
	// se selecciona por default dia habil siguiente
	$('#fechaInhabil2').attr('checked',false);
	$('#fechaInhabil1').attr('checked',true);
	$('#fechaInhabil').val("S");

	// se selecciona por default no ajustar fecha exigible a fecha de vencimiento
	$('#ajusFecExiVen1').attr('checked',false);
	$('#ajusFecExiVen2').attr('checked',true);
	$('#ajusFecExiVen').val("N");

	// se selecciona por default ajustar fecha de vencimiento a fecha de ultima amortizacion
	$('#ajusFecUlVenAmo2').attr('checked',false);
	$('#ajusFecUlVenAmo1').attr('checked',true);
	$('#ajusFecUlVenAmo').val("S");

	// se selecciona por default dia pago interes Fin de mes para  interes
	$('#diaPagoInteres1').attr('checked',false);
	$('#diaPagoInteres2').attr('checked',true);
	$('#diaMesInteres').val(diaSucursal);
	$('#diaPagoInteres').val("F");

	// se selecciona por default dia pago interes Fin de mes para capital
	$('#diaPagoCapital1').attr('checked',false);
	$('#diaPagoCapital2').attr('checked',true);
	$('#diaMesCapital').val(diaSucursal);
	$('#diaPagoCapital').val("A");

	// se selecciona por default que si paga IVA
	$('#noPagaIVA').attr('checked',false);
	$('#siPagaIVA').attr('checked',true);
	$('#pagaIva').val("S");

	// se selecciona por default corto plazo
	$('#cortoPlazo').attr('checked',true);
	$('#largoPlazo').attr('checked',false);
	$('#plazoContable').val("C");
}


//funcion para inicializar los combos por
//valores por default
function inicializarCombos(){
	$('#plazoID').val("0").selected = true;
	$('#tipoCalInteres').val("0").selected = true;
	$('#calcInteresID').val("0").selected = true;
	$('#tipoPagoCapital').val("0").selected = true;
	$('#frecuenciaInt').val("0").selected = true;
	$('#frecuenciaCap').val("0").selected = true;
	$('#capitalizaInteres').val("N").selected = true;

}

//funcion para inicializar los campos del formulario
function inicializarCampos(){
	parametroBean = consultaParametrosSession();
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaContable').val($('#fechaInicio').val());

	habilitaControl('tipoPagoCapital');
	agregaFormatoControles('formaGenerica');
	inicializarRadiosCalendarioPagos();
	inicializarCombos();

	$('#institutFondID').val("");
	$('#nombreInstitFondeo').val("");
	$('#lineaFondeoID').val("");
	$('#folio').val("");
	$('#saldoLinea').val("");

	$('#descripLinea').val("");
	$('#tipoLinFondeaID').val("");
	$('#desTipoLinFondea').val("");

	$('#fechInicLinea').val("");
	$('#fechaFinLinea').val("");
	$('#fechaMaxVenci').val("");
	$('#monto').val("");

	$('#fechaVencimien').val("");
	$('#factorMora').val("");
	$('#tasaBase').val("");
	$('#desTasaBase').val("");
	$('#tasaFija').val("");

	$('#sobreTasa').val("");
	$('#pisoTasa').val("");
	$('#techoTasa').val("");
	$('#margenPagIguales').val("");

	$('#periodicidadInt').val("");
	$('#diaMesInteres').val("");
	$('#numAmortInteres').val("");
	$('#periodicidadCap').val("");
	$('#diaMesCapital').val("");

	$('#numAmortizacion').val("");
	$('#montosCapital').val("");
	$('#montoCuota').val("");
	$('#institucionID').val("");
	$('#descripcionInstitucion').val("");
	$('#numCtaInstit').val("");
	$('#cuentaClabe').val("");

	$('#tipoInstitID').val("");
	$('#tipoInstitDes').val("");
	$('#nacionalidadIns').val("");
	$('#nacionalidadInsDes').val("");
	$('#cobraISR').val("");
	$('#tasaISR').val("");
	$('#comDispos').val("");
	$('#ivaComDispos').val("");

	$('#refinancia').val('N');



	habilitaControl('tipoPagoCapital');
	habilitaControl('frecuenciaCap');
}

//funcion para verificar que la suma del capital sea igual que la del monto
function sumaCapital(){
	var jqCapital;
	var suma = 0;
	var contador = 1;
	var capital;
	esTab=true;
	$('input[name=capital]').each(function() {
		jqCapital = eval("'#" + this.id + "'");
		capital= $(jqCapital).asNumber();
		if(capital != '' && !isNaN(capital) && esTab){
			suma = suma + capital;
			contador = contador + 1;
			$(jqCapital).formatCurrency({
				positiveFormat: '%n',
				roundToDecimalPlace: 2
			});
		}else{
			$(jqCapital).val(0);
		}
	});
	if (suma== $('#monto').asNumber() ) {
		habilitaBoton('continuar', 'submit');
	}else{
			if(suma==''){ // Validacion agregada
				mensajeSis("El Capital esta vacio, por favor de colocar un valor ");
			}else{
					mensajeSis("La suma de Capital no es igual al monto");
					deshabilitaBoton('continuar', 'submit');
				return 1;
			}
	}
}

//funcion que bloque la pantalla mientras se cotiza
function bloquearPantallaAmortizacion(){
	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
	$('#contenedorForma').block({
		message: $('#mensaje'),
		css: {	border:		'none',
				background:	'none'}
	});
}


function crearMontosCapital(numTransac){
		var suma =	sumaCapital();
		var idCapital="";
		if(suma !=1){
			$('#montosCapital').val("");
			for(var i = 1; i <= $('input[name=capital]').length; i++){
				idCapital = eval("'#capital"+i+"'");
				if($(idCapital).asNumber()>="0"){
					if(i == 1){
						$('#montosCapital').val($('#montosCapital').val() +
								i + ']' +
								$(idCapital).asNumber() + ']' +
								numTransac);
					}else{
						$('#montosCapital').val($('#montosCapital').val() + '[' +
								i + ']' +
								$(idCapital).asNumber() + ']' +
								numTransac);
					}
				}
			}
			return 2;
		}
}



//llamada al cotizador de pagos libres
function simuladorPagosLibres(numTransac){
	var mandar = crearMontosCapital(numTransac);
	if(mandar==2){
		var params = {};

		if($('#calcInteresID').val()==1 ) {
			switch($('#tipoPagoCapital').val()){
				case "C": // si el tipo de pago es CRECIENTES
					tipoLista = 1;
				break;
				case "I" :// si el tipo de pago es IGUALES
					tipoLista = 2;
				break;
				case  "L": // si el tipo de pago es LIBRES
					tipoLista = 3;
				break;
				default:
					tipoLista = 1;
			}
		}else{
			switch($('#tipoPagoCapital').val()){
				case "C": // si el tipo de pago es CRECIENTES
					mensajeSis("No se permiten pagos de capital Crecientes");
				break;
				case "I" :// si el tipo de pago es IGUALES
					tipoLista = 4;
				break;
				case  "L": // si el tipo de pago es LIBRES
					tipoLista = 5;
				break;
				default:
					tipoLista = 4;
			}
		}

		params['tipoLista']			= tipoLista;
		params['monto'] 			= $('#monto').asNumber();
		params['tasaFija']			= $('#tasaFija').asNumber();
		params['fechaInhabil']		= $('#fechaInhabil').val();
		params['empresaID'] 		= parametroBean.empresaID;
		params['usuario'] 			= parametroBean.numeroUsuario;
		params['fecha'] 			= parametroBean.fechaSucursal;
		params['direccionIP'] 		= parametroBean.IPsesion;
		params['sucursal'] 			= parametroBean.sucursal;
		params['numTransaccion'] 	= numTransac;
		params['numTransacSim'] 	= $('#numTransacSim').val();
		params['montosCapital']		= $('#montosCapital').val();
		params['margenPriCuota'] 	= $('#margenPriCuota').val();
		params['pagaIva'] 			= $('#pagaIva').val();
		params['iva'] 				= $('#iva').asNumber();
		bloquearPantallaAmortizacion();
		$.post("simPagLibresCreditoFondeo.htm", params, function(data){
			if(data.length >0 || data != null) {
				$('#contenedorSimulador').html("");
				$('#contenedorSimulador').hide();
				$('#contenedorSimuladorLibre').html(data);
				$('#contenedorSimuladorLibre').show();
				$('#numTransacSim').val($('#transaccion').val());
				// actualiza la nueva fecha de vencimiento que devuelve el cotizador
				var jqFechaVen = eval("'#valorFecUltAmor'"); // se cambio fech AEUAN
				$('#fechaVencimien').val($(jqFechaVen).val());
			}else{
				$('#contenedorSimuladorLibre').html("");
				$('#contenedorSimuladorLibre').hide();
				$('#contenedorSimulador').html("");
				$('#contenedorSimulador').hide();
			}
			$('#contenedorForma').unblock();

		});
	}
}


function simuladorPagosLibresTasaVar(numTransac,cuotas){
	var mandar = crearMontosCapital(numTransac);
	$('#numAmortizacion').val(cuotas);
	$('#numTransacSim').val(numTransac);
	var jqFechaVen = eval("'#fechaVencim" +cuotas+ "'");
	if($('#ajusFecUlVenAmo2').is(':checked')){
		$('#fechaVencimien').val($(jqFechaVen).val());
	}
	if(mandar==2){
		var params = {};
		if($('#calcInteresID').val()==1 ) {
			switch($('#tipoPagoCapital').val()){
				case "C": // si el tipo de pago es CRECIENTES
					tipoLista = 1;
				break;
				case "I" :// si el tipo de pago es IGUALES
					tipoLista = 2;
				break;
				case  "L": // si el tipo de pago es LIBRES
					tipoLista = 3;
				break;
				default:
					tipoLista = 1;
			}

		}else{
			switch($('#tipoPagoCapital').val()){
				case "I" :// si el tipo de pago es IGUALES
					tipoLista = 4;
				break;
				case  "L": // si el tipo de pago es LIBRES
					tipoLista = 5;
				break;
				default:
					tipoLista = 4;
			}
		}
		params['tipoLista'] 	= tipoLista;
		params['monto'] 		= $('#monto').asNumber();
		params['tasaFija']			= $('#tasaFija').asNumber();
		params['empresaID'] 	= parametroBean.empresaID;
		params['usuario']		 = parametroBean.numeroUsuario;
		params['fecha'] 		= parametroBean.fechaSucursal;
		params['direccionIP'] 	= parametroBean.IPsesion;
		params['sucursal'] 		= parametroBean.sucursal;
		params['numTransaccion']= numTransac;
		params['numTransacSim'] = numTransac;
		params['pagaIva'] 		= $('#pagaIva').val();
		params['iva'] 			= $('#iva').asNumber();
		params['margenPriCuota'] 	= $('#margenPriCuota').val();


		params['montosCapital']	= $('#montosCapital').val();
		bloquearPantallaAmortizacion();

		$.post("simPagLibresCreditoFondeo.htm", params, function(data){
			if(data.length >0) {
				$('#contenedorSimuladorLibre').html(data);
				$('#contenedorSimuladorLibre').show();
				$('#contenedorSimulador').html("");
				$('#contenedorSimulador').hide();

				var valorTransaccion = $('#transaccion').val();
				$('#numTransacSim').val(valorTransaccion);
				mensajeSis("Datos Guardados");
				// actualiza la nueva fecha de vencimiento que devuelve el cotizador
				var jqFechaVen = eval("'#fechaVencim" +cuotas+ "'");
				$('#fechaVencimien').val($(jqFechaVen).val());
			}else{
				$('#contenedorSimulador').html("");
				$('#contenedorSimulador').hide();
				$('#contenedorSimuladorLibre').html("");
				$('#contenedorSimuladorLibre').hide();
			}

		});
	}

}

function mostrarGridLibresEncabezado(){
	var data;

	data = '<input type="hidden" value="0" name="numeroDetalle" id="numeroDetalle" />'+
	'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
	'<legend>Simulador de Amortizaciones</legend>'+
	'<form id="gridDetalle" name="gridDetalle">'+
	'<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">'+
		'<tr>'+
			'<td class="label" align="center"><label for="lblNumero">N&uacute;mero</label></td>'+
			'<td class="label" align="center"><label for="lblFecIni">Fecha Inicio</label></td>'+
			'<td class="label" align="center"><label for="lblFecFin">Fecha Vencimiento</label> </td>	'+
			'<td class="label" align="center"><label for="lblFecPag">Fecha Pago</label></td>'+
	  		'<td class="label" align="center"><label for="lblCapital">Capital</label></td> '+
	 		'<td class="label" align="center"><label for="lblDescripcion">Inter&eacute;s</label></td> '+
	 		'<td class="label" align="center"><label for="lblCargos">Iva Inter&eacute;s</label></td> '+
	 		'<td class="label" align="center"><label for="lblTotalPag">Total Pago</label></td> '+
	 		'<td class="label" align="center"><label for="lblSaldoCap">Saldo Capital</label></td> '+
		'</tr>'+
	'</table>'+
	'</form>'+
	'</fieldset>';


	$('#contenedorSimuladorLibre').html(data);
	$('#contenedorSimuladorLibre').show();
	$('#contenedorSimulador').html("");
	$('#contenedorSimulador').hide();
	agregaFormatoControles('gridDetalle');
	mostrarGridLibresDetalle();
}

function mostrarGridLibresDetalle(){

	agregaFormatoControles('gridDetalle');

	var numeroFila = document.getElementById("numeroDetalle").value;
	var nuevaFila = parseInt(numeroFila) + 1;
	var filaAnterior = parseInt(nuevaFila) - 1;
	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	var valorDiferencia = $('#diferenciaCapital').asNumber();
	if(numeroFila == 0){
		tds += '<td><input type="text" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="4" value="1" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="fechaInicio'+nuevaFila+'"  name="fechaInicio" size="15" value="'+ $('#fechaInicio').val()+'" readonly="true" disabled="true"/></td>';
		tds += '<td align="center"><input type="text" id="fechaVencim'+nuevaFila+'" name="fechaVencim" size="15" value="" esCalendario="true" onblur="comparaFechas('+nuevaFila+')"  /></td>';
		tds += '<td align="center"><input type="text" id="fechaExigible'+nuevaFila+'" name="fechaExigible" size="15" value=" " readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="capital'+nuevaFila+'" name="capital" size="18" style="text-align: right;" value="" esMoneda="true" onblur="calculaDiferenciaSimuladorLibre();"/></td>';
		tds += '<td><input type="text" id="interes'+nuevaFila+'" name="interes" size="18" style="text-align: right;" value="" esMoneda="true" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="ivaInteres'+nuevaFila+'" name="ivaInteres" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="totalPago'+nuevaFila+'" name="totalPago" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="saldoInsoluto'+nuevaFila+'" name="saldoInsoluto" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/>';

	} else{
		$('#trBtnCalcular').remove();
		$('#trDiferenciaCapital').remove();
		var valor = parseInt(document.getElementById("consecutivoID"+numeroFila+"").value) + 1;
		tds += '<td><input type="text" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="4" value="'+valor+'" autocomplete="off" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="fechaInicio'+nuevaFila+'"  name="fechaInicio" size="15" value="'+ $('#fechaVencim'+filaAnterior).val()+'" readonly="true" disabled="true"/></td>';
		tds += '<td align="center"><input type="text" id="fechaVencim'+nuevaFila+'" name="fechaVencim" size="15" value="" esCalendario="true" onblur="comparaFechas('+nuevaFila+')" /></td>';
		tds += '<td align="center"><input type="text" id="fechaExigible'+nuevaFila+'" name="fechaExigible" size="15" value="" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="capital'+nuevaFila+'" name="capital" size="18" style="text-align: right;" value="" esMoneda="true" onblur="calculaDiferenciaSimuladorLibre();"/></td>';
		tds += '<td><input type="text" id="interes'+nuevaFila+'" name="interes" size="18" style="text-align: right;" value="" esMoneda="true" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="ivaInteres'+nuevaFila+'" name="ivaInteres" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="totalPago'+nuevaFila+'" name="totalPago" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="saldoInsoluto'+nuevaFila+'" name="saldoInsoluto" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/>';

	}
	tds += '<input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaAmort(this)"/>';
	tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevaAmort()"/></td>';
	tds += '</tr>';
	tds += '<tr id="trDiferenciaCapital" >'+
				'<td colspan="4" align="right"><label for="Diferencia">Diferencia: </label></td>'+
				'<td  id="inputDiferenciaCap">'+
					'<input type="text" id="diferenciaCapital" name="diferenciaCapital" size="18" style="text-align: right;" value="'+valorDiferencia+'" esMoneda="true"/>'+
				'</td>'+
				'<td colspan="4"></td>'+
			'</tr>';
	tds += '<tr id="trBtnCalcular" >'+
				'<td  id="btnCalcularLibre" colspan="9" align="right">'+
					'<button type="button" class="submit" id="calcular" tabindex="37"  onclick="simuladorLibresCapFec();">Calcular</button>'+
				'</td>'+
			'</tr>';

	document.getElementById("numeroDetalle").value = nuevaFila;
	$('#miTabla').append(tds);
	sugiereFechaSimuladorLibre();
}

function agregaNuevaAmort(){
	agregaFormatoControles('gridDetalle');
	var numeroFila = document.getElementById("numeroDetalle").value;
	var nuevaFila = parseInt(numeroFila) + 1;
	var filaAnterior = parseInt(nuevaFila) - 1;
	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	var valorDiferencia = $('#diferenciaCapital').asNumber();
	if(numeroFila == 0){
		$('#trBtnCalcular').remove();
		$('#trDiferenciaCapital').remove();
		tds += '<td><input type="text" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="4" value="1" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="fechaInicio'+nuevaFila+'"  name="fechaInicio" size="15" value="'+ $('#fechaInicio').val()+'" readonly="true" disabled="true"/></td>';
		tds += '<td align="center"><input type="text" id="fechaVencim'+nuevaFila+'" name="fechaVencim" size="15" value="" esCalendario="true" onblur="comparaFechas('+nuevaFila+');"  /></td>';
		tds += '<td align="center"><input type="text" id="fechaExigible'+nuevaFila+'" name="fechaExigible" size="15" value="" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="capital'+nuevaFila+'" name="capital" size="18" style="text-align: right;" value="" esMoneda="true" onblur="calculaDiferenciaSimuladorLibre();" /></td>';
		tds += '<td><input type="text" id="interes'+nuevaFila+'" name="interes" size="18" style="text-align: right;" value="" esMoneda="true" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="ivaInteres'+nuevaFila+'" name="ivaInteres" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="totalPago'+nuevaFila+'" name="totalPago" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="saldoInsoluto'+nuevaFila+'" name="saldoInsoluto" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/>';

	} else{
		$('#trBtnCalcular').remove();
		$('#trDiferenciaCapital').remove();
		var valor = parseInt(document.getElementById("consecutivoID"+numeroFila+"").value) + 1;
		tds += '<td><input type="text" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="4" value="'+valor+'" autocomplete="off" readonly="true" disabled="true" /></td>';
		tds += '<td><input type="text" id="fechaInicio'+nuevaFila+'"  name="fechaInicio" size="15" value="'+ $('#fechaVencim'+filaAnterior).val()+'" readonly="true" disabled="true"/></td>';
		tds += '<td align="center"><input type="text" id="fechaVencim'+nuevaFila+'" name="fechaVencim" size="15" value="" esCalendario="true" onblur="comparaFechas('+nuevaFila+')" /></td>';
		tds += '<td align="center"><input type="text" id="fechaExigible'+nuevaFila+'" name="fechaExigible" size="15" value="" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="capital'+nuevaFila+'" name="capital" size="18" style="text-align: right;" value="" esMoneda="true" onblur="calculaDiferenciaSimuladorLibre();"/></td>';
		tds += '<td><input type="text" id="interes'+nuevaFila+'" name="interes" size="18" style="text-align: right;" value="" esMoneda="true" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="ivaInteres'+nuevaFila+'" name="ivaInteres" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="totalPago'+nuevaFila+'" name="totalPago" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="saldoInsoluto'+nuevaFila+'" name="saldoInsoluto" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/>';
	}
	tds += '<input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaAmort(this)"/>';
	tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevaAmort()"/></td>';
	tds += '</tr>';
	tds += '<tr id="trDiferenciaCapital" >'+
				'<td colspan="4" align="right"><label for="Diferencia">Diferencia: </label></td>'+
				'<td  id="inputDiferenciaCap">'+
					'<input type="text" id="diferenciaCapital" name="diferenciaCapital" size="18" style="text-align: right;" value="'+valorDiferencia+'" esMoneda="true"/>'+
				'</td>'+
				'<td colspan="4"></td>'+
			'</tr>';
	tds += '<tr id="trBtnCalcular" >'+
				'<td  id="btnCalcularLibre" colspan="9" align="right">'+
					'<button type="button" class="submit" id="calcular" tabindex="37"  onclick="simuladorLibresCapFec();">Calcular</button>'+
				'</td>'+
			'</tr>';

	document.getElementById("numeroDetalle").value = nuevaFila;
	$("#miTabla").append(tds);
	sugiereFechaSimuladorLibre();

	return false;
}

function eliminaAmort(control){
	var numeroID = control.id;
	var jqTr = eval("'#renglon" + numeroID + "'");

	var jqConsecutivoID = eval("'#consecutivoID" + numeroID + "'");
	var jqFechaInicio = eval("'#fechaInicio" + numeroID + "'");
	var jqFechaVencim = eval("'#fechaVencim" + numeroID + "'");
	var jqFechaExigible = eval("'#fechaExigible" + numeroID + "'");
	var jqCapital = eval("'#capital" + numeroID + "'");
	var jqInteres = eval("'#interes" + numeroID + "'");
	var jqIvaInteres = eval("'#ivaInteres" + numeroID + "'");
	var jqTotalPago = eval("'#totalPago" + numeroID + "'");
	var jqSaldoInsoluto = eval("'#saldoInsoluto" + numeroID + "'");
	var jqElimina = eval("'#" + numeroID + "'");
	var jqAgrega = eval("'#agrega" + numeroID + "'");

	var jqConsecutivoIDSig = eval("'#consecutivoID" + String(eval(parseInt(numeroID)+1)) + "'");

	//Si es el primer Elemento
	if ($(jqConsecutivoID).attr("id") == $("input[name=consecutivoID]:first-child").attr("id")){
		$(jqConsecutivoIDSig).val("1");
	}else if($(jqConsecutivoIDSig).val()!= null && $(jqConsecutivoIDSig).val()!= undefined) {
		//Valida Antes de actualizar, que si exista un sig elemento
		for (var i=(parseInt(numeroID)+1);i<=$("#numeroDetalle").val();i++){
			jqConsecutivoIDSig = eval("'#consecutivoID" + i + "'");
			$(jqConsecutivoIDSig).val(numeroID);
			numeroID++;
		}
	}

	$(jqConsecutivoID).remove();
	$(jqFechaInicio).remove();
	$(jqFechaVencim).remove();
	$(jqFechaExigible).remove();
	$(jqCapital).remove();
	$(jqInteres).remove();
	$(jqIvaInteres).remove();
	$(jqTotalPago).remove();
	$(jqSaldoInsoluto).remove();
	$(jqElimina).remove();
	$(jqAgrega).remove();
	$(jqTr).remove();

	//Reordenamiento de Controles
	var contador = 1;
	$('input[name=consecutivoID]').each(function() {
		var jqCicCon = eval("'#" + this.id + "'");
		$(jqCicCon).attr("id", "consecutivoID" + contador);
		contador = contador + 1;
	});
	//Reordenamiento de Controles
	contador = 1;
	$('input[name=fechaInicio]').each(function() {
		var jqCicFi = eval("'#" + this.id + "'");
		$(jqCicFi).attr("id", "fechaInicio" + contador);
		contador = contador + 1;
	});
	contador = 1;
	//Reordenamiento de Controles
	$('tr[name=fechaVencim]').each(function() {
		var jqFechaVencim = eval("'#" + this.id + "'");
		$(jqFechaVencim).attr("id", "fechaVencim" + contador);
		contador = contador + 1;
	});

	contador = 1;
	//Reordenamiento de Controles
	$('tr[name=agrega]').each(function() {
		var jqAgrega = eval("'#" + this.id + "'");
		$(jqAgrega).attr("id", "agrega" + contador);
		contador = contador + 1;
	});
	//Reordenamiento de Controles
	contador = 1;
	$('input[name=fechaExigible]').each(function() {
		var jqFechaExigible = eval("'#" + this.id + "'");
		$(jqFechaExigible).attr("id", "fechaExigible" + contador);
		contador = contador + 1;
	});
	//Reordenamiento de Controles
	var contador = 1;
	$('input[name=capital]').each(function() {
		var jqCapital = eval("'#" + this.id + "'");
		$(jqCapital).attr("id", "capital" + contador);
		contador = contador + 1;
	});

	//Reordenamiento de Controles
	contador = 1;
	$('input[name=interes]').each(function() {
		var jqInteres = eval("'#" + this.id + "'");
		$(jqInteres).attr("id", "interes" + contador);
		contador = contador + 1;
	});
	contador = 1;
	//Reordenamiento de Controles
	var contador = 1;
	$('input[name=ivaInteres]').each(function() {
		var jqIvaInteres = eval("'#" + this.id + "'");
		$(jqIvaInteres).attr("id", "ivaInteres" + contador);
		contador = contador + 1;
	});
	//Reordenamiento de Controles
	contador = 1;
	$('input[name=totalPago]').each(function() {
		var jqTotalPago = eval("'#" + this.id + "'");
		$(jqTotalPago).attr("id", "totalPago" + contador);
		contador = contador + 1;
	});
	//Reordenamiento de Controles
	contador = 1;
	$('input[name=saldoInsoluto]').each(function() {
		var jqSaldoInsoluto = eval("'#" + this.id + "'");
		$(jqSaldoInsoluto).attr("id", "saldoInsoluto" + contador);
		contador = contador + 1;
	});
	contador = 1;
	//Reordenamiento de Controles
	$('input[name=elimina]').each(function() {
		var jqCicElim = eval("'#" + this.id + "'");
		$(jqCicElim).attr("id", contador);
		contador = contador + 1;
	});
	contador = 1;
	//Reordenamiento de Controles
	$('tr[name=renglon]').each(function() {
		var jqCicTr = eval("'#" + this.id + "'");
		$(jqCicTr).attr("id", "renglon" + contador);
		contador = contador + 1;
	});
	$('#numeroDetalle').val($('#numeroDetalle').val()-1);

}

/* funcion para sugerir fecha y monto de acuerdo  a lo que ya se
 * habia indicado en el formulario.*/
function sugiereFechaSimuladorLibre(){
	var numDetalle = $('input[name=fechaVencim]').length;
	var varFechaVenID = eval("'#fechaVencim"+numDetalle+"'");
	$(varFechaVenID).val($('#fechaVencimien').val());
	$(varFechaVenID).focus();
	var varCapitalID = eval("'#capital"+numDetalle+"'");
	if(numDetalle>1){
		$(varCapitalID).val($('#diferenciaCapital').val());
		$('#diferenciaCapital').val("0.00");
		$(varCapitalID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	}else{
		$(varCapitalID).val($('#monto').val());
		$(varCapitalID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	}
}

/* funcion para calcular la diferencia del monto con lo que se va poniendo en
 * el grid de pagos libres.*/
function calculaDiferenciaSimuladorLibre(){
	var sumaMontoCapturado = 0;
	var diferenciaMonto = 0;
	var numero = 0;
	var varCapitalID = "";
	$('input[name=capital]').each(function() {
		numero= this.id.substr(7,this.id.length);
		numDetalle = $('input[name=capital]').length;
		varCapitalID = eval("'#capital"+numero+"'");

		sumaMontoCapturado = sumaMontoCapturado + $(varCapitalID).asNumber();


		if(sumaMontoCapturado > $('#monto').asNumber()){
			mensajeSis("Los montos de las Cuotas deben sumar el monto del Capital.");
			$(varCapitalID).val("");
			$(varCapitalID).select();
			$(varCapitalID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		}else{
			diferenciaMonto = $('#monto').asNumber() -  sumaMontoCapturado.toFixed(2);
			$('#diferenciaCapital').val(diferenciaMonto);
			$('#diferenciaCapital').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
			$(varCapitalID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		}
	});
}

/*Para ejecutar el simulador de pagos libres de capital y fecha cuando das clic en el
 * boton calcular*/
function simuladorLibresCapFec(){
	var mandar = crearMontosCapitalFecha();
	if(mandar==2){
		var params = {};

		if($('#calcInteresID').val()==1 ) {
			if($('#calendIrregular').is(':checked')){
				tipoLista = 7;
			}else{
				switch($('#tipoPagoCapital').val()){
					case "C": // si el tipo de pago es CRECIENTES
						tipoLista = 1;
					break;
					case "I" :// si el tipo de pago es IGUALES
						tipoLista = 2;
					break;
					case  "L": // si el tipo de pago es LIBRES
						tipoLista = 3;
					break;
					default:
						tipoLista = 1;
				}
			}
		}else{
			if($('#calendIrregular').is(':checked')){
				tipoLista=8;
			}else{
				switch($('#tipoPagoCapital').val()){
					case "I" :// si el tipo de pago es IGUALES
						tipoLista = 4;
					break;
					case  "L": // si el tipo de pago es LIBRES
						tipoLista = 5;
					break;
					default:
						tipoLista = 4;
				}
			}
		}
		params['tipoLista'] 	= tipoLista;
		params['monto'] 		= $('#monto').asNumber();
		params['tasaFija']		= $('#tasaFija').asNumber();
		params['fechaInhabil']	= $('#fechaInhabil').val();
		params['empresaID'] 	= parametroBean.empresaID;
		params['usuario'] 		= parametroBean.numeroUsuario;
		params['fecha'] 		= parametroBean.fechaSucursal;
		params['direccionIP'] 	= parametroBean.IPsesion;
		params['sucursal'] 		= parametroBean.sucursal;
		params['montosCapital'] = $('#montosCapital').val();
		params['pagaIva'] 		= $('#pagaIva').val();
		params['iva'] 			= $('#iva').asNumber();

		$.post("simPagLibresCreditoFondeo.htm", params, function(data){
			if(data.length >0) {
				$('#contenedorSimulador').html("");
				$('#contenedorSimulador').hide();
				$('#contenedorSimuladorLibre').html(data);
				$('#contenedorSimuladorLibre').show();
				var valorTransaccion = $('#transaccion').val();
				$('#numTransacSim').val(valorTransaccion);
				//actualiza el numero de cuotas que devuelve el cotizador
				$('#numAmortInteres').val($('#numCuotasInt').val());
				$('#numAmortizacion').val($('#numCuotasCap').val());

				// actualiza la nueva fecha de vencimiento que devuelve el cotizador
				var numAmortizacion = $('input[name=consecutivoID]').length;
				var jqFechaVen = eval("'#fechaVencim"+numAmortizacion+"'");
				$('#fechaVencimien').val($(jqFechaVen).val());
			}else{
				$('#contenedorSimulador').html("");
				$('#contenedorSimulador').hide();
				$('#contenedorSimuladorLibre').html("");
				$('#contenedorSimuladorLibre').hide();
			}

		});
	}
}


function crearMontosCapitalFecha(){
	var mandar = verificarvaciosCapFec();
	var regresar = 1;
	if(mandar!=1){
		var suma =	sumaCapital();
		if(suma !=1){
			quitaFormatoControles('gridDetalle');
			var numAmortizacion = $('input[name=consecutivoID]').length;
			$('#montosCapital').val("");
			for(var i = 1; i <= numAmortizacion; i++){
				var idCapital=eval("'#capital"+i+"'");
				if(i == 1){
					$('#montosCapital').val($('#montosCapital').val() +
							i + ']' +
							$(idCapital).asNumber()+ ']' +
							document.getElementById("fechaInicio"+i+"").value+ ']' +
							document.getElementById("fechaVencim"+i+"").value );
				}else{
					$('#montosCapital').val($('#montosCapital').val() + '[' +
							i + ']' +
							$(idCapital).asNumber()+ ']' +
							document.getElementById("fechaInicio"+i+"").value+ ']' +
							document.getElementById("fechaVencim"+i+"").value );
				}
			}
			regresar= 2;
		}
		else {regresar= 1; }
	}
	return regresar;
}


function verificarvaciosCapFec(){
	var numAmortizacion = $('input[name=consecutivoID]').length;
	$('#montosCapital').val("");
	var regresar =1;
	for(var i = 1; i <= numAmortizacion; i++){

		var jqfechaInicio = eval("'#fechaInicio" +i + "'");
		var jqfechaVencim = eval("'#fechaVencim" +i + "'");

		var valFecIni = document.getElementById("fechaInicio"+i).value;
		var valFecVen = document.getElementById("fechaVencim"+i).value;
		if (valFecIni =="" ){
			document.getElementById("fechaInicio"+i).focus();
			$(jqfechaInicio).addClass("error");
			regresar= 1;
			mensajeSis("Especifique Fecha de Inicio");
			i= numAmortizacion+2;
		}else{regresar= 3;
		$(jqfechaInicio).removeClass("error");
		}

		if (valFecVen =="" ){
			document.getElementById("fechaVencim"+i).focus();
			$(jqfechaVencim).addClass("error");
			mensajeSis("Especifique Fecha de Vencimiento");
			regresar= 1;
			i= numAmortizacion+2;
		}else{regresar= 4;
		$(jqfechaVencim).removeClass("error");
		}

	}
	return regresar;
}

// funcion para validar que la fecha de vencimiento indicada sea mayor a la de inicio
function comparaFechas(fila){
	var jqFechaIni = eval("'#fechaInicio" +fila + "'");
	var jqFechaVen = eval("'#fechaVencim" +fila + "'");

	var fechaIni = $(jqFechaIni).val();
	var fechaVen = $(jqFechaVen).val();
	var xYear=fechaIni.substring(0,4);
	var xMonth=fechaIni.substring(5, 7);
	var xDay=fechaIni.substring(8, 10);
	var yYear=fechaVen.substring(0,4);
	var yMonth=fechaVen.substring(5, 7);
	var yDay=fechaVen.substring(8, 10);
	if($(jqFechaVen).val() != ''){
		if(esFechaValida($(jqFechaVen).val())){
			if (yYear<xYear ){
				mensajeSis("la fecha de Vencimiento debe ser Mayor a la Fecha de Inicio");
				document.getElementById("fechaVencim"+fila).focus();
				$(jqFechaVen).addClass("error");
			}else{
				if (xYear == yYear){
					if (yMonth<xMonth){
						mensajeSis("la fecha de Vencimiento debe ser Mayor a la Fecha de Inicio");
						document.getElementById("fechaVencim"+fila).focus();
						$(jqFechaVen).addClass("error");
					}else
					{
						if (xMonth == yMonth)
						{
							if (yDay<xDay||yDay==xDay)
							{
								mensajeSis("la fecha de Vencimiento debe ser Mayor a la Fecha de Inicio");
								document.getElementById("fechaVencim"+fila).focus();
								$(jqFechaVen).addClass("error");
							}
						}
					}

				}
			}
		}else{
			$(jqFechaVen).focus();
		}
	}
}


//funcion para validar la fecha
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
			mensajeSis("Fecha introducida errónea");
		return false;
		}
		if (dia>numDias || dia==0){
			mensajeSis("Fecha introducida errónea");
			return false;
		}
		return true;
	}
}
function comprobarSiBisisesto(anio){
	if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
		return true;
	}
	else {
		return false;
	}
}

/* Cancela las teclas [ ] en el formulario*/
document.onkeypress = pulsarCorchete;
function pulsarCorchete(e) {
	tecla=(document.all) ? e.keyCode : e.which;
	if(tecla==91 || tecla==93){
		return false;
	}
	return true;
}

// funcion para poner el formato de moneda en el Grid
function agregaFormatoMonedaGrid(controlID){
	jqID = eval("'#"+controlID+"'");
	$(jqID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
}

// agrega el scroll al div de simulador de pagos libres de capital
$('#contenedorSimuladorLibre').scroll(function() {

});

//Funcion para consultar parametro tabla PARAMGENERALES
function consultaParametro(){
	var tipoConsulta = 13;
	paramGeneralesServicio.consulta(tipoConsulta, function(valor){
		if(valor!=null){
			$('#numClienteEspec').val(valor.valorParametro);
			// ------------ Llenar combo Formulas Calculo Interes -----------------------------------------
			consultaComboCalInteres();
		}
	});
}

//funcion que llena el combo de calcInteres
function consultaComboCalInteres() {
	var varNumList = 1;
	clienteEspecifico = $('#numClienteEspec').val();
	// se eliminan los tipos de pago que se tenian
	$('#calcInteresID').each(function() {
		$('#calcInteresID option').remove();
	});
	// se agrega la opcion por default
	$('#calcInteresID').append(
			new Option('SELECCIONAR', '', true, true));
		//Clientes Mexi
		if(clienteEspecifico == 38 || clienteEspecifico == 39 || clienteEspecifico == 40 || clienteEspecifico == 41){
			varNumList = 2;
		}

		formTipoCalIntServicio.listaCombo(varNumList,function(formTipoCalIntBean) {
					for ( var j = 0; j < formTipoCalIntBean.length; j++) {
						$('#calcInteresID').append(new Option(formTipoCalIntBean[j].formula,formTipoCalIntBean[j].formInteresID,true,true));
						}
					$('#calcInteresID').val('').selected = true;

				});

}

var nav4 = window.Event ? true : false;
function IsNumber(evt){
	var key = nav4 ? evt.which : evt.keyCode;
	return (key <= 13 || (key >= 48 && key <= 57) );
}
function IsNumber1(evt){
	var key = nav4 ? evt.which : evt.keyCode;
	return (key <= 13 || key > 43 && key < 45 || (key >= 48 && key <= 57) || key > 45 && key < 47  );
}
function IsNumber2(evt){
	var key = nav4 ? evt.which : evt.keyCode;
	return (key <= 13 || key > 43 && key < 45 || (key >= 48 && key <= 57) || key > 45 && key < 47  );
}