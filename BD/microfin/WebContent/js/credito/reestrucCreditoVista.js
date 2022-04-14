var tab2=false;
inicializaForma('formaGenerica','creditoID' );
$('#clienteID').val('');
$('#nombreCliente').val('');
$('#cuentaID').val("");
var procedeSubmit = 0;
var esTab = false;
var parametroBean = consultaParametrosSession();
var usuario= parametroBean.numeroUsuario;
var fechaSucursal = parametroBean.fechaSucursal;
var diaSucursal = parametroBean.fechaSucursal.substring(8,10);
var TasaFijaID = 1; // ID de la formula para tasa fija (FORMTIPOCALINT)
var TasaBasePisoTecho = 3; // ID de la formula para tasa base con piso y techo (FORMTIPOCALINT)
var hayTasaBase = false; // Indica la existencia de una tasa base
var VarTasaFijaoBase = 'Tasa Fija Anualizada'; // Texto que indica si se trata de tasa fija o tasa base actual (alert)
var valorTasaBase 	= 0  //Valor de la tasa base cuando el calculo de interes es de tipo 2,3,4.


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

var esCliente           ='CTE';


/**** Al Modificar este .JS  favor de Declarar las variables a utilizar ****/
$(document).ready(function() {
	parametroBean = consultaParametrosSession();
	fechaSucursal = parametroBean.fechaSucursal;
	diaSucursal = parametroBean.fechaSucursal.substring(8,10);
	var pagoFinAni="";
	var pagoFinAniInt="";
	var diaHabilSig="";
	var ajustaFecAmo= "";
	var ajusFecExiVen = "";
	var tipoLista = 0;
	var MontoIni=0;
	var montoOriginal =0;
	var NumCuotas = 0;
	var NumCuotasInt = 0;
	var MontoMaxCre = 0.0;
	var MontoMinCre = 0.0;
 	var TipCobroCAper = "";
	var plazo=0;
	var frecInt=0;
	var frecCap=0;
	var tipoPag=0;
	var tipoDisper=0;
	var diaMesCapit =0;
	var diaPagCapit ='';
	var diaMesInter =0;
	var diaPagInter ='';
	var varRelacionado = 0;
	procedeSubmit=0;
	var PanReestructura = 'R';
	$('#pantalla').val(PanReestructura);

	$('#creditoID').focus();
	//Definicion de Constantes y Enums
	var catTipoTransaccionCredito = {
  		'agrega':'19',
  		'modifica':'20',
  		'simulador':'9'
  	};

	var catTipoConsultaCredito = {
  		'principal'	: 1,
  		'foranea'	: 2,
  		'prodSinLin'	:3
	};

	var catOperacFechas = {// Operaciones Entre Fechas
			'sumaDias'		:1,
			'restaFechas'	:2
	};
	var TipoFormaCobroApertura={
			'Anticipado'	:'A',
			'Deduccion'		:'D',
			'Financiamiento':'F'
	};
	var TipoComisionApertura={
			'Monto'				:'M',
			'Procentaje'		:'P'
	};
	var FrecuenciaCapital	={
		'Semanal'	:	'S',
		'Decenal'	:   'D',
		'Catorcenal':	'C',
		'Quincenal'	:	'Q',
		'Mensual'	:	'M',
		'Periodo'	:	'P',
		'Bimestral'	:	'B',
		'Trimestral':	'T',
		'TetraMestral':	'R',
		'Semestral'	:	 'E',
		'Anual'		:	'A',
		'Unico'		:	'U'
	};
	var FrecuenciaIntereses ={
			'Semanal'	:	'S',
			'Decenal'	:   'D',
			'Catorcenal':	'C',
			'Quincenal'	:	'Q',
			'Mensual'	:	'M',
			'Periodo'	:	'P',
			'Bimestral'	:	'B',
			'Trimestral':	'T',
			'TetraMestral':	'R',
			'Semestral'	:	 'E',
			'Anual'		:	'A',
			'Unico'		:	'U'
	};
	var DiaPagoInteres	={
			'FinalDelMes'	:'F',
			'PorAniversario':'A'
	};
	var DiaPagoCapital	={
			'FinalDelMes'	:'F',
			'PorAniversario':'A' ,
			'DiaDelMes'		:'D',
			'Indistinto'	:'I'
	};

	var AjusteFechaExigibleVenc = {
			'SI'	:'S',
			'NO'	:'N'
	};
	var AjustaUltimaFechaVenAmort = {
			'SI'	:'S',
			'NO'	:'N'
	};
	var CalendarioIregular = {
			'SI'	:'S',
			'NO'	:'N'
	};
	var TipoPagoCapital	={
		'Crecientes'	:'C',
		'Iguales'		:'I',
		'Libres'		:'L'
	};
	var TipoFondeo	={
		'RecursosPropios'	:'P',
		'InstitucionFondeo'	:'F',
	};
	var EstatusCredito	={
			 'Inactivo'	:'I',
			 'Autorizado':'A',
			 'Vigente':	'V',
			 'Pagado':	'P',
			 'Cancelado':'C',
			 'Vencido':	'B',
			'Castigado':'K'
	};
	var EstatusSolicitudCred ={
			'Inactiva'	:'I',
			'Liberada'	:'L',
			'Autorizada':'A',
			'Vigente'	:'V',
			'Desembolsada':'D'
	};
	var PermitePagosIguales ={
			'SI'	:'S',
			'N'		:'N'
	};

	var IgualCalInteresCapital ={
			'SI'	:'S',
			'NO'	:'N'
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------

	inicializaForma('formaGenerica','creditoID' );
	consultaParametros();
	consultaMoneda();
	deshabilitaControlesAlta();
	deshabilitaBoton('modifica', 'submit');
	consultaComboCalInteres();

	// inicializa radios de  valores del calendario de pagos *****
	$('#fechaInhabil').val("S");
	$('#fechaInhabil1').attr('checked',true) ;
	$('#fechaInhabil2').attr("checked",false) ;

	$('#ajusFecExiVen1').attr('checked',false) ;
	$('#ajusFecExiVen2').attr("checked",true);
	$('#ajusFecExiVen').val(AjusteFechaExigibleVenc.SI);

	$('#calendIrregularCheck').attr("checked",false) ;
	$('#calendIrregular').val(CalendarioIregular.NO);

	$('#ajusFecUlVenAmo1').attr('checked',true) ;
	$('#ajusFecUlVenAmo2').attr("checked",false);
	$('#ajusFecUlVenAmo').val(AjustaUltimaFechaVenAmort.SI);

	$('#diaMesCapital').val("");
	$('#diaMesInteres').val("");

	$('#diaPagoCapital1').attr('checked',true);
	$('#diaPagoCapital2').attr('checked',false);
	$('#diaPagoCapital').val("F") ;

	$('#diaPagoInteres1').attr('checked',true);
	$('#diaPagoInteres2').attr('checked',false);
	$('#diaPagoInteres').val("F") ;

	$('#diaPagoProd').val("I"); // campo auxiliar para validar

	$(':text').focus(function() {
	 	esTab = false;
	});

	agregaFormatoControles('formaGenerica');
	agregaFormatoControles('gridDetalle');

	$.validator.setDefaults({
		submitHandler: function(event) {
			if(validaDatosRequeridos() == 1){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID','accionInicializaRegresoExitoso','accionInicializaRegresoFallo');
				deshabControles();
			}
	   }
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#agrega').click(function() {
		habControles();
		$('#tipoTransaccion').val(catTipoTransaccionCredito.agrega);
	});

	$('#modifica').click(function() {
		habControles();
		$('#tipoTransaccion').val(catTipoTransaccionCredito.modifica);
	});

	$('#creditoID').bind('keyup',function(e){
		lista('creditoID', '2', '35', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
	});


	$('#creditoID').blur(function() {
		if(isNaN($('#creditoID').val()) ){
			$('#creditoID').val("");
			$('#creditoID').focus();
			inicializaForma('formaGenerica','creditoID');
			inicializaCombos();
			limpiaCreditoRees();
			tab2 = false;
		 }else{

			validaCredito(this.id);
		}
	});

	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#clienteID').blur(function() {
		consultaClienteOrigen(this.id);
	});

	$('#lineaCreditoID').bind('keyup',function(e){
		if(this.value.length >= 0){
			var camposLista = new Array();
			var parametrosLista = new Array();

			camposLista[0] = "clienteID";
			camposLista[1] = "productoCreditoID";

		 	parametrosLista[0] = $('#clienteID').val();
			parametrosLista[1] = $('#producCreditoID').val();

			lista('lineaCreditoID', '1', '2', camposLista, parametrosLista, 'lineasCreditoAltaCredLista.htm');
		}
	});

	//Consulta Tasa Base al perder el Foco
	$('#tasaBase').blur(function() {
		if ($('#tasaBase').val() != 0) {
			consultaTasaBase(this.id,true);
		} else {
			hayTasaBase = false;
			$('#tasaBase').val('');
			$('#desTasaBase').val('');
			$('#tasaFija').val('').change();
		}
	});

	// Buscar Tasa Base por Nombre
	$('#tasaBase').bind('keyup',function(e){
		if(this.value.length >= 2){
			lista('tasaBase', '2', '1', 'nombre', $('#tasaBase').val(), 'tasaBaseLista.htm');
		}
	});

	$('#sobreTasa').blur(function() {
		if(hayTasaBase){
			$('#tasaFija').val(parseFloat(valorTasaBase) + $('#sobreTasa').asNumber()).change();
			$('#tasaFija').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
		} else {
			$('#tasaFija').val('').change();
		}
	});

	$('#tasaFija').change(function() {
		vuelveaSimular();
	});

	$('#producCreditoID').bind('keyup',function(e){
		lista('producCreditoID', '1', '3', 'descripcion', $('#producCreditoID').val(), '	listaProductosCredito.htm');
	});

	$('#producCreditoID').blur(function() {
  		consultaProducCredito(this.id);
		MontoIni= 0; // á¹ara inicializar valor de monto de credito cuando se cambia el producto
		//consultaCalendarioPorProducto(this.id);
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
		$('#diaPagoInteres1').attr('checked', false);
		$('#diaPagoInteres2').attr('checked', true);
		$('#diaPagoInteres').val($('#diaPagoProd').val());
		habilitaControl('diaMesInteres');
		$('#diaMesInteres').val(diaSucursal);
		$('#diaPagoInteres2').focus();
	});

	$('#diaPagoInteres1').change(function(){
		$('#diaPagoInteres2').attr('checked',false);
		$('#diaPagoInteres1').attr('checked',true);
		$('#diaPagoInteres').val("F");
		deshabilitaControl('diaMesInteres');
		$('#diaMesInteres').val("");
		$('#diaPagoInteres1').focus();
	});

	$('#diaPagoInteres2').change(function(){
		$('#diaPagoInteres1').attr('checked', false);
		$('#diaPagoInteres2').attr('checked', true);
		$('#diaPagoInteres').val($('#diaPagoProd').val());
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
		if($('#tipoPagoCapital').val() == 'C' || ($('#tipoPagoCapital').val() == 'I' && $('#perIgual').val() =='S') ){
			$('#diaPagoInteres2').attr('checked',false);
			$('#diaPagoInteres1').attr('checked',true);
			$('#diaPagoInteres').val("F");
			deshabilitaControl('diaMesInteres');
			$('#diaMesInteres').val("");
		}
	});

	$('#diaPagoCapital2').click(function(){
		$('#diaPagoCapital1').attr('checked',false);
		$('#diaPagoCapital2').attr('checked',true);
		$('#diaPagoCapital').val($('#diaPagoProd').val());
		$('#diaMesCapital').val(diaSucursal);

		if($('#diaPagoProd').val() != "A"){
			habilitaControl('diaMesCapital');
			if ($('#tipoPagoCapital').val() == 'C' || ($('#tipoPagoCapital').val() == 'I' && $('#perIgual').val() == 'S')) {
				$('#diaPagoInteres1').attr('checked', false);
				$('#diaPagoInteres2').attr('checked', true);
				$('#diaPagoInteres').val($('#diaPagoProd').val());
				deshabilitaControl('diaMesInteres');
				$('#diaMesInteres').val(diaSucursal);
			}
		}else{
			deshabilitaControl('diaMesCapital');
			$('#diaMesCapital').val(diaSucursal);
			if ($('#tipoPagoCapital').val() == 'C' || ($('#tipoPagoCapital').val() == 'I' && $('#perIgual').val() == 'S')) {
				$('#diaPagoInteres1').attr('checked', false);
				$('#diaPagoInteres2').attr('checked', true);
				$('#diaPagoInteres').val($('#diaPagoProd').val());
				deshabilitaControl('diaMesInteres');
				$('#diaMesInteres').val(diaSucursal);
			}
		}
	});

	$('#diaPagoCapital1').change(function(){
		$('#diaPagoCapital2').attr('checked', false);
		$('#diaPagoCapital1').attr('checked', true);
		$('#diaPagoCapital').val("F");
		deshabilitaControl('diaMesCapital');
		$('#diaMesCapital').val("");
		if($('#tipoPagoCapital').val() == 'C' || ($('#tipoPagoCapital').val() == 'I' && $('#perIgual').val() =='S') ){
			$('#diaPagoInteres2').attr('checked',false);
			$('#diaPagoInteres1').attr('checked',true);
			$('#diaPagoInteres').val("F");
			deshabilitaControl('diaMesInteres');
			$('#diaMesInteres').val("");
		}
	});

	$('#diaPagoCapital2').change(function(){
		$('#diaPagoCapital1').attr('checked',false);
		$('#diaPagoCapital2').attr('checked',true);
		$('#diaPagoCapital').val($('#diaPagoProd').val());

		if($('#diaPagoProd').val() != "A"){
			habilitaControl('diaMesCapital');
			if ($('#tipoPagoCapital').val() == 'C' || ($('#tipoPagoCapital').val() == 'I' && $('#perIgual').val() == 'S')) {
				$('#diaPagoInteres1').attr('checked', false);
				$('#diaPagoInteres2').attr('checked', true);
				$('#diaPagoInteres').val($('#diaPagoProd').val());
				habilitaControl('diaMesInteres');
				$('#diaMesInteres').val(diaSucursal);
			}
		}else{
			deshabilitaControl('diaMesCapital');
			$('#diaMesCapital').val(diaSucursal);
			if ($('#tipoPagoCapital').val() == 'C' || ($('#tipoPagoCapital').val() == 'I' && $('#perIgual').val() == 'S')) {
				$('#diaPagoInteres1').attr('checked', false);
				$('#diaPagoInteres2').attr('checked', true);
				$('#diaPagoInteres').val($('#diaPagoProd').val());
				deshabilitaControl('diaMesInteres');
				$('#diaMesInteres').val(diaSucursal);
			}
		}
	});

	$('#tipoPagoCapital').change(function() {
		validaTipoPago();
	});

	$('#tipoPagoCapital').blur(function() {
		validaTipoPago();
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
		consultaCuotasInteres('plazoID');
	});

	$('#periodicidadCap').blur(function(){
		if ($('#tipoPagoCapital').val() == 'C' || ($('#tipoPagoCapital').val() == 'I' && $('#perIgual').val() == 'S')) {
			$('#periodicidadInt').val($('#periodicidadCap').val());
		}
	});

	$('#diaMesCapital').blur(function(){
		if ($('#tipoPagoCapital').val() == 'C' || ($('#tipoPagoCapital').val() == 'I' && $('#perIgual').val() == 'S')) {
			$('#diaMesInteres').val($('#diaMesCapital').val());
		}
	});


	$('#simular').click(function() {
		if ($('#tasaFija').asNumber() != '0' || $('#tasaFija').val() == ''){
			if($('#tipoPagoCapital').val() == "L"){
				if($('#creditoID').asNumber()>0 || $('#solicitudCreditoID').asNumber()>0 ||$('#relacionado').asNumber()>0  ){
					if($('#numTransacSim').asNumber() >0){
						consultaSimulador();
					}else{
						simulador();
					}
				}else{
					simulador();
				}
			}else{
				simulador();
			}
		}
		else {
			mensajeSis('No tiene '+VarTasaFijaoBase);
			$('#tasaFija').select();
		}
	});


	$('#calendIrregularCheck').click(function(){
		if($('#calendIrregularCheck').is(':checked')){
			$('#calendIrregular').val("S");
			deshabilitaControl('frecuenciaInt');
			deshabilitaControl('frecuenciaCap');
			deshabilitaControl('tipoPagoCapital');
			$('#frecuenciaInt').val('L').selected = true;
			$('#frecuenciaCap').val('L').selected = true;
			$('#tipoPagoCapital').val('L').selected = true;
		}else{
			$('#calendIrregular').val("N");
			habilitaControl('frecuenciaInt');
			habilitaControl('frecuenciaCap');
			habilitaControl('tipoPagoCapital');
			$('#frecuenciaCap').val("").selected = true;
			$('#frecuenciaInt').val("").selected = true;
		}
		$('#numTransacSim').val("0");
	});


	$('#solicitudCreditoID').bind('keyup',function(e){
		if(this.value.length >= 0){
			var camposLista = new Array();
			var parametrosLista = new Array();

			camposLista[0] = "clienteID";
		 	parametrosLista[0] = $('#solicitudCreditoID').val();

			lista('solicitudCreditoID', '1', '7', camposLista, parametrosLista, 'listaSolicitudCredito.htm');
		}
	});


	$('#solicitudCreditoID').blur(function() {
		var solCre = $('#solicitudCreditoID').val();
		if(solCre == '0' || solCre == '' ){
			habilitaControlesSolicitud();
		}else{
			deshabilitaControlesSolicitud();
			}
  		consultaSolicitudCred(this.id);
	});

	$('#cuentaID').bind('keyup',function(e){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#clienteID').val();
			lista('cuentaID', '1', '2', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
	});


	$('#montoCredito').blur(function() {
		var monto =$('#montoCredito').asNumber();
		//valida monto de credito contra los montos permitidos por el producto de credito
		if(monto > MontoMaxCre){
			$('#montoCredito').val(MontoMaxCre);
			$('#montoCredito').formatCurrency({	positiveFormat: '%n', negativeFormat: '%n',  roundToDecimalPlace: 2	});
			var MontFormat = $('#montoCredito').val();
			mensajeSis('El Monto Solicitado no debe ser Mayor a '+ MontFormat);
			$('#montoCredito').val('');
			$('#montoCredito').focus();
			$('#montoCredito').select();
		}
		if(monto < MontoMinCre){
			$('#montoCredito').val(MontoMinCre);
			$('#montoCredito').formatCurrency({	positiveFormat: '%n', negativeFormat: '%n',  roundToDecimalPlace: 2	});
			var MontFormat = $('#montoCredito').val();
			mensajeSis('El Monto  no debe ser Menor a '+ MontFormat);
			$('#montoCredito').val('');
			$('#montoCredito').focus();
			$('#montoCredito').select();
		}
		var cte = $('#clienteID').val();
		var estatus = $('#estatus').val();
		if(cte == '0' || estatus == 'I' ){
			$('#sucursalCte').val(parametroBean.sucursal);
		}
		var credito = $('#creditoID').val();
		if(credito == '0' || credito == 'I'){  //PPP

			consultaTasaCredito(this.id);
			var monto =$('#montoCredito').asNumber();
			var MontoInic = MontoIni;
			monto.toFixed(2);
			MontoInic.toFixed(2);
			if(MontoInic.toFixed(2) != monto.toFixed(2) && TipCobroCAper == TipoFormaCobroApertura.Financiamiento){
				consultaComisionAper();
			}else{
				if(MontoInic.toFixed(2) != monto.toFixed(2) && TipCobroCAper != TipoFormaCobroApertura.Financiamiento){
					consultaComisionAper();
				}
			}
		}
		agregaFormatoControles('formaGenerica');
 		$('#IVAComApertura').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
 		$('#montoCredito').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
	});

	$('#tasaFija').blur(function() {
		var solicitud = $('#solicitudCreditoID').val();
		var tasaF = $('#tasaFija').val();
		var montoFondear = $('#montoCredito').val();
		if(solicitud == '0' || solicitud == ''){
			$('#tasa').val(tasaF);
			$('#porcentaje').val('100.00');
			$('#monto').val(montoFondear);
		}
	});

	$('#fechaInicio').blur(function() {
		consultaFechaVencimiento('plazoID');
	 	var fechaAplicacion = parametroBean.fechaAplicacion;
		var fechInicio =  $('#fechaInicio').val();
		if ( fechInicio < fechaAplicacion &&  fechInicio != '' ){
			mensajeSis('La fecha de Inicio no puede ser inferior a la del sistema');
			$('#fechaInicio').focus();
			$('#fechaInicio').select();
		}
	});

	$('#fechaVencimien').bind('keyup',function(e){
		var fechaAplicacion = parametroBean.fechaAplicacion;
		var fechInicio =  $('#fechaInicio').val();
		if ( fechInicio < fechaAplicacion ){
			mensajeSis('La fecha de Inicio no puede ser inferior a la del sistema');
			$('#fechaInicio').focus();
			$('#fechaInicio').select();
		}
	});

	$('#fechaVencimien').blur(function() {
		var fechaAplicacion = parametroBean.fechaAplicacion;
		var fechInicio =  $('#fechaInicio').val();
		if ( fechInicio < fechaAplicacion &&  fechInicio != '' ){
			mensajeSis('La fecha de Inicio no puede ser inferior a la del sistema');
			$('#fechaInicio').focus();
			$('#fechaInicio').select();
		}
	});

	function convertDate(stringdate){
		var DateRegex = /([^-]*)-([^-]*)-([^-]*)/;
	    var DateRegexResult = stringdate.match(DateRegex);
	    var DateResult;
	    var StringDateResult = "";
	    try{
	    	DateResult = new Date(DateRegexResult[2]+"/"+DateRegexResult[3]+"/"+DateRegexResult[1]);
	    }catch(err){
	    	DateResult = new Date(stringdate);
	    }
	    StringDateResult = (DateResult.getMonth()+1)+"/"+(DateResult.getDate()+1)+"/"+(DateResult.getFullYear());
	    return StringDateResult;
	}

	$('#calcInteresID').bind('keyup',function(e){
		var fechInicio =  $('#fechaInicio').val();
		var fechaVenForm = $('#fechaVencimien').val();
		convertDate(fechInicio);
		convertDate(fechaVenForm);
		if(fechaVenForm < fechInicio){
			mensajeSis("Fecha de Inicio debe ser superior a la de Vencimiento  ");
			$('#fechaVencimien').focus();
			$('#fechaVencimien').select();
		}
	});


	$('#calcInteresID').blur(function() {
		var fechInicio =  $('#fechaInicio').val();
		var fechaVenForm = $('#fechaVencimien').val();
		convertDate(fechInicio);
		convertDate(fechaVenForm);
		if(fechaVenForm < fechInicio){
			mensajeSis("Fecha de Vencimiento debe ser superior a la de Inicio");
			$('#fechaVencimien').focus();
			$('#fechaVencimien').select();
		}
	});

	$('#cuentaID').blur(function() {

  		consultaCta(this.id);
	});

	$('#plazoID').click(function() {
		NumCuotas=0;
		NumCuotasInt = 0;
		consultaFechaVencimiento(this.id);
	});

	$('#destinoCreID').bind('keyup',function(e){
		lista('destinoCreID', '2', '1', 'destinoCreID', $('#destinoCreID').val(), 'listaDestinosCredito.htm');
	});

	$('#destinoCreID').blur(function() {
		consultaDestinoCredito(this.id);
	});

	$('#numAmortizacion').change(function() {
		 //valida que el numero de cuotas solo se modifique +1 cuota, -1 cuota de la calculada
		 tab2=true;
		 var nuevoNumCuotas = $('#numAmortizacion').asNumber();
		 var valorMayor= parseInt(NumCuotas)+1;
		 var valorMenor= parseInt(NumCuotas)-1;
		 if($('#tipoPagoCapital').val() != "L" && $('#frecuenciaCap').val()!= "P"){
			 if(nuevoNumCuotas>valorMayor ){
			 	 $('#numAmortizacion').val(NumCuotas);
			 	 mensajeSis("Sólo una cuota mas");
				$('#numAmortizacion').focus();
			 }else{
				 $('#error').hide();
				 if(nuevoNumCuotas==valorMayor || nuevoNumCuotas == valorMenor ){
					 $('#error').hide();
				 }
			 }
			 if(nuevoNumCuotas<valorMenor){
				 $('#numAmortizacion').val(NumCuotas);
				 mensajeSis("Sólo una cuota menos");
				 $('#numAmortizacion').focus();
			 }else{
				 if(nuevoNumCuotas <= valorMenor){
					 $('#error2').hide();
				 }
			 }
			 var tipoPag = $('#tipoPagoCapital').val();
			 if(tipoPag == TipoPagoCapital.Crecientes){
				 $('#numAmortInteres').val($('#numAmortizacion').val());
			 }
		 }
		if ($('#tipoPagoCapital').val() == 'C' || ($('#tipoPagoCapital').val() == 'I' && $('#perIgual').val() == 'S')) {
			$('#numAmortInteres').val($('#numAmortizacion').val());
		}
		 consultaFechaVencimientoCuotas('numAmortizacion');
	});

	$('#numAmortizacion').blur(function() {
		var nuevoNumCuotas = $('#numAmortizacion').asNumber();
		var valorMayor= parseInt(NumCuotas)+1;
		var valorMenor= parseInt(NumCuotas)-1;
		//valida que el numero de cuotas solo se modifique +1 cuota, -1 cuota de la calculada
		if(tab2 == false){
			if($('#tipoPagoCapital').val() != "L" && $('#frecuenciaCap').val()!= "P"){
				if(nuevoNumCuotas>valorMayor ){
					$('#numAmortizacion').val(NumCuotas);
			 	 	mensajeSis("Sólo una cuota mas");
					$('#numAmortizacion').focus();
			 	}else{
			 		$('#error').hide();
			 		if(nuevoNumCuotas==valorMayor || nuevoNumCuotas == valorMenor ){
			 			$('#error').hide();
			 		}
			 	}
			 	if(nuevoNumCuotas<valorMenor){
			 		$('#numAmortizacion').val(NumCuotas);
			 		mensajeSis("Sólo una cuota menos");
			 		$('#numAmortizacion').focus();
			 	}else{
			 		if(nuevoNumCuotas <= valorMenor){
			 		 $('#error2').hide();
			 		}
			 	}
			 	var tipoPag = $('#tipoPagoCapital').val();
			 	if(tipoPag == TipoPagoCapital.Crecientes){
			 		$('#numAmortInteres').val($('#numAmortizacion').val());
			 	}
			}
			if ($('#tipoPagoCapital').val() == 'C' || ($('#tipoPagoCapital').val() == 'I' && $('#perIgual').val() == 'S')) {
				$('#numAmortInteres').val($('#numAmortizacion').val());
			}

			consultaFechaVencimientoCuotas('numAmortizacion');
		}
	});

	$('#numAmortInteres').blur(function() {
		//valida que el numero de cuotas solo se modifique +1 cuota, -1 cuota de la calculada
		var nuevoNumCuotas = parseInt($('#numAmortInteres').asNumber());
		var valorMayor= parseInt(NumCuotasInt)+1;
 		var valorMenor= parseInt(NumCuotasInt)-1;
 		if(tab2 == false){
 			if($('#tipoPagoCapital').val() != "L" && $('#frecuenciaInt').val()!= "P"){
 				if(nuevoNumCuotas>valorMayor ){
 	 				$('#numAmortInteres').val(NumCuotasInt);
 					mensajeSis("Sólo una cuota mas");
 					$('#numAmortInteres').focus();
 			 	}else{
 			 		$('#error').hide();
 			 		 if(nuevoNumCuotas==valorMayor || nuevoNumCuotas == valorMenor ){
 			 		 	$('#error').hide();
 			 		 	}
 			 	}
 			 	if(nuevoNumCuotas<valorMenor){
 			 	 		$('#numAmortInteres').val(NumCuotasInt);
 			 	 		mensajeSis("Sólo una cuota menos");
 						$('#numAmortInteres').focus();
 			 	}else{
 			 		if(nuevoNumCuotas <= valorMenor){
 			 			$('#error2').hide();
 			 		}
 			 	}
 			 	tipoPag = $('#tipoPagoCapital').val();
 			}

		}
	});

	$('#numAmortInteres').change(function() {
		//valida que el numero de cuotas solo se modifique +1 cuota, -1 cuota de la calculada
		tab2=true;
		var nuevoNumCuotas = $('#numAmortInteres').asNumber();
		var valorMayor= parseInt(NumCuotasInt)+1;
		var valorMenor= parseInt(NumCuotasInt)-1;
		if($('#tipoPagoCapital').val() != "L" && $('#frecuenciaInt').val()!= "P"){
			if(nuevoNumCuotas>valorMayor ){
				$('#numAmortInteres').val(NumCuotasInt);
				mensajeSis("Sólo una cuota mas");
				$('#numAmortInteres').focus();
			}else{
				$('#error').hide();
				if(nuevoNumCuotas==valorMayor || nuevoNumCuotas == valorMenor ){
					$('#error').hide();
				}
			}
			if(nuevoNumCuotas<valorMenor){
				$('#numAmortInteres').val(NumCuotasInt);
				mensajeSis("Sólo una cuota menos");
				$('#numAmortInteres').focus();
			}else{
				if(nuevoNumCuotas <= valorMenor){
					$('#error2').hide();
				}
			}
		}

	});

	$('#relacionado').focus(function() {
 		agregaFormatoControles('formaGenerica');
 		$('#IVAComApertura').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
 		$('#montoCredito').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
	});

	$('#relacionado').change(function() {

		if($('#relacionado').val() == ""){
			inicializaForma('formaGenerica','creditoID' );
			limpiaCreditoRees();
		}else{
			validaCreditoOrigen(this.id);
		}
 		agregaFormatoControles('formaGenerica');
 		$('#IVAComApertura').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
 		$('#montoCredito').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
	});

	$('#relacionado').blur(function() {

		if($('#relacionado').val() == ""){
			inicializaForma('formaGenerica','creditoID' );
			limpiaCreditoRees();
		}else{
			consultaExisteCredito(this.id);
		}
 		agregaFormatoControles('formaGenerica');
 		$('#IVAComApertura').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
 		$('#montoCredito').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
	});

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

	$('#ajusFecExiVen2').click(function() {
		$('#ajusFecExiVen1').attr("checked",false) ;
		$('#ajusFecExiVen2').attr("checked","1") ;
		$('#ajusFecExiVen').val(AjusteFechaExigibleVenc.NO);
	});

	$('#ajusFecExiVen1').click(function() {
		$('#ajusFecExiVen1').attr("checked","1") ;
		$('#ajusFecExiVen2').attr("checked",false) ;
		$('#ajusFecExiVen').val(AjusteFechaExigibleVenc.SI);
	});

	$('#ajusFecUlVenAmo1').click(function() {
		$('#ajusFecUlVenAmo1').attr("checked","1") ;
		$('#ajusFecUlVenAmo2').attr("checked",false) ;
		$('#ajusFecUlVenAmo').val(AjustaUltimaFechaVenAmort.SI) ;
	});

	$('#ajusFecUlVenAmo2').click(function() {
		$('#ajusFecUlVenAmo1').attr("checked",false) ;
		$('#ajusFecUlVenAmo2').attr("checked","1") ;
		$('#ajusFecUlVenAmo').val(AjustaUltimaFechaVenAmort.NO) ;
	});


	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			clienteID: {
				required: true
			},
			cuentaID: {
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
			montoCredito: {
				required: true
			},
			plazoID: {
				required: true,
				numeroMayorCero: true
			},
			tipoPagoCapital: {
				required: true

			},
			frecuenciaCap: {
				required: true
			},
			destinoCreID: {
				required: true

			},

			producCreditoID: {
			required: true

			},
			tipoDispersion : {
				required : true
			},
			tasaBase :{
				required: function() {
					return $('#tasaBase').is(':enabled');
				}
			},
			sobreTasa :{
				required: function() {
					return $('#sobreTasa').is(':enabled');
				}
			}
		},
		messages: {
			clienteID: {
				required: 'Especificar cliente'
			},
			cuentaID: {
				required: 'Especificar cuenta'
			},
			fechaInicio: {
				required: 'Especificar Fecha',
				date : 'Fecha Incorrecta'
			},
			fechaVencimien: {
				required: 'Especificar Fecha',
				date : 'Fecha Incorrecta'
			},
			montoCredito: {
				required: 'Especificar Monto'
			},
			plazoID: {
				required: 'Especificar Plazo',
				numeroMayorCero: 'Plazo esta vacio'
			},
			tipoPagoCapital: {
				required: 'Especificar Tipo de Pago'
			},
			frecuenciaCap: {
				required: 'Especificar Frecuencia'
			},
			destinoCreID: {
				required: 'Especifique Destino de Crédito.'
			},
			producCreditoID : {
				required : 'Especificar Producto de Crédito.',
			},
			tipoDispersion : {
				required : 'Especificar Dispersión.',
			},
			tasaBase :{
				required: 'Especificar la Tasa Base.'

			},
			sobreTasa :{
				required: 'Especificar la Sobre Tasa.'

			}
		}
	});

	//------------ Validaciones de Controles -------------------------------------
	function validaCredito(control) {
		var Comercial='C';
		var Consumo ='O';

		inicializaCombos();
		var numCredito = $('#creditoID').val();
		MontoMaxCre =0;
		MontoMinCre = 0;
		TipCobroCAper="";
		plazo=0;
		frecInt=0;
		frecCap=0;
		tipoPag=0;
		tipoDisper=0;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) && esTab){
			// ingreso por cero (cuando es un credito nuevo)
			if(numCredito=='0'){
				habilitaControl('solicitudCreditoID');
				inicializaForma('formaGenerica','creditoID' );
				habilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');
				inicializaForma('formaGenerica','creditoID' );
				consultaParametros();
				$('#monedaID').val('-1');
				$('#fechaInhabil1').attr("checked","1") ;
				$('#fechaInhabil2').attr("checked",false) ;
				$('#fechaInhabil').val("S");
				$('#contenedorSimulador').html("");
				habilitaControl('relacionado');
				limpiaCreditoRees();
			} else {
				// consulta del credito
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				var creditoBeanCon = {
						'creditoID':$('#creditoID').val()
				};
				creditosServicio.consulta(catTipoConsultaCredito.principal,creditoBeanCon,function(credito) {
					if(credito!=null){
						listaPersBloqBean = consultaListaPersBloq(credito.clienteID, esCliente, 0, 0);
						consultaSPL = consultaPermiteOperaSPL(credito.clienteID,'LPB',esCliente);
					
						if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
						dwr.util.setValues(credito);
						deshabilitaBoton('agrega', 'submit');
						habilitaBoton('modifica', 'submit');

						// consultaCalendarioPorProducto('producCreditoID',plazo);
						// se llena la parte del calendario y valores parametrizados en el
						// producto seleccionando los que se trajo de resultado la consulta
						consultaCalendarioPorProductoCredito( credito.producCreditoID, credito.tipoPagoCapital,
								credito.frecuenciaCap, credito.frecuenciaInt,credito.plazoID, credito.tipoDispersion);


						frecCap = credito.frecuenciaCap;
						frecInt = credito.frecuenciaInt;
						tipoPag = credito.tipoPagoCapital;
						tipoDisper = credito.tipoDispersion;
						$('#producCreditoID').val(credito.producCreditoID);
						$('#tasaFija').val(credito.tasaFija).change();
						valorTasaBase = credito.tasaFija;
						consultaCliente('clienteID');
						ValidaCalcInteres('calcInteresID');
						$('#solicitudCreditoID').val(credito.solicitudCreditoID);
						$('#cuentaID').val(credito.cuentaID);
						$('#fechaInhabil').val(credito.fechaInhabil);
						$('#ajusFecExiVen').val(credito.ajusFecExiVen);
						$('#ajusFecUlVenAmo').val(credito.ajusFecUlVenAmo);

						if(credito.relacionado!= "" || credito.relacionado > 0 || credito.relacionado != null){
							consultaCreditoOrigenCreado(credito.relacionado);
							deshabilitaControl('relacionado');

						}else{
							limpiaCreditoRees();
						}

						consultaCta('cuentaID');
						if(credito.tasaBase !=0){
							consultaTasaBase('tasaBase',false);
						}
						setCalcInteresID(credito.calcInteresID,false);

						if(credito.fechaInhabil=='S'){
							$('#fechaInhabil1').attr("checked","1") ;
							$('#fechaInhabil2').attr("checked",false) ;
							$('#fechaInhabil').val("S");
						}
						else{
							$('#fechaInhabil2').attr("checked","1") ;
							$('#fechaInhabil1').attr("checked",false) ;
							$('#fechaInhabil').val("A");
						}
						if(credito.ajusFecExiVen == AjusteFechaExigibleVenc.SI){
							$('#ajusFecExiVen1').attr("checked","1") ;
							$('#ajusFecExiVen2').attr("checked",false) ;
							$('#ajusFecExiVen').val(AjusteFechaExigibleVenc.SI);
						}else{
							$('#ajusFecExiVen1').attr("checked",false) ;
							$('#ajusFecExiVen2').attr("checked","1") ;
							$('#ajusFecExiVen').val(AjusteFechaExigibleVenc.NO);
						}
						if(credito.ajusFecUlVenAmo== AjustaUltimaFechaVenAmort.SI){
							$('#ajusFecUlVenAmo1').attr("checked","1") ;
							$('#ajusFecUlVenAmo2').attr("checked",false) ;
							$('#ajusFecUlVenAmo').val(AjustaUltimaFechaVenAmort.SI) ;
						}
						else{
							$('#ajusFecUlVenAmo1').attr("checked",false) ;
							$('#ajusFecUlVenAmo2').attr("checked","1") ;
							$('#ajusFecUlVenAmo').val(AjustaUltimaFechaVenAmort.NO) ;
						}

						if(credito.diaPagoInteres== "F"){
							$('#diaPagoInteres1').attr("checked","1") ;
							$('#diaPagoInteres2').attr("checked",false) ;
						}else{
							$('#diaPagoInteres2').attr("checked","1") ;
							$('#diaPagoInteres1').attr("checked",false) ;
						}

						if(credito.diaPagoCapital== "F"){
							$('#diaPagoCapital1').attr("checked",true) ;
							$('#diaPagoCapital2').attr("checked",false) ;
						}else{
							$('#diaPagoCapital2').attr("checked",true) ;
							$('#diaPagoCapital1').attr("checked",false) ;
							$('#diaMesCapital').val(credito.diaMesCapital);
						}

						$('#diaPagoInteres').val(credito.diaPagoInteres);
						$('#diaPagoCapital').val(credito.diaPagoCapital);
						//$('#plazoID').val(credito.plazoID).select();

						//$('#diaPagoProd').val(credito.diaPagoCapital); // campo auxiliar para validar

						if (credito.calendIrregular == 'S') {
							$('#calendIrregularCheck').attr("checked","1");
							$('#calendIrregular').val("S");
							deshabilitaControl('tipoPagoCapital');
							deshabilitaControl('frecuenciaInt');
							deshabilitaControl('frecuenciaCap');
						} else {
							$('#calendIrregularCheck').attr("checked",false);
							$('#calendIrregular').val("N");
							/*habilitaControl('tipoPagoCapital');
							habilitaControl('frecuenciaInt');
							habilitaControl('frecuenciaCap');*/
						}


						if(credito.tipoPagoCapital == TipoPagoCapital.Crecientes){
							$('#tipoPagoCapital').attr("checked","1") ;
						}else{
							if(credito.tipoPagoCapital== TipoPagoCapital.Iguales){
								$('#tipoPagoCapital').attr("checked",false) ;
							}else{
								if(credito.tipoPagoCapital== TipoPagoCapital.Libres){
									$('#tipoPagoCapital').attr("checked",false) ;
								}
								if(credito.tipoFondeo== TipoFondeo.RecursosPropios){
								}
								else{
									if(credito.tipoFondeo== TipoFondeo.InstitucionFondeo){
									}
								}
							}
						}

						validaTipoPago();
						$('#producCreditoID').val(credito.producCreditoID);
						deshabilitaBoton('agrega', 'submit');
						habilitaBoton('modifica', 'submit');
						var solicitud = $('#solicitudCreditoID').val();
						var status = credito.estatus;
						if(status != EstatusCredito.Inactivo ){
							deshabilitaControl('solicitudCreditoID');
							deshabilitaBoton('modifica');
							deshabilitaBoton('agrega');
							deshabilitaControlesNoInactivo();
						}else{
							if(status == EstatusCredito.Inactivo && solicitud ==0){
								habilitaBoton('modifica');
								deshabilitaBoton('agrega');
								habilitaControlesDarAlta();
							}
							if(status == EstatusCredito.Inactivo && solicitud !=0){
								habilitaBoton('modifica');
								deshabilitaBoton('agrega');
								deshabilitaControlesNoInactivo();
							}
						}
						montoOriginal = credito.montoCredito; // variable que almacena el monto origina solicitado (para calculos comision apertura)
						MontoIni =credito.montoCredito;
						$('#tipoDispersion').val(credito.tipoDispersion).selected = true;

						consultaDestinoCreditoSolicitud('destinoCreID');

						consultaProducCreditoConsultar(credito.producCreditoID);
						NumCuotasInt = credito.numAmortInteres; // asigna el valor de numero de cuotas de interes
						$('#cat').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
						$('#montoCuota').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
						$('#numTransacSim').val(credito.numTransacSim);
						$('#numAmortizacion').val(credito.numAmortizacion);
						$('#numAmortInteres').val(credito.numAmortInteres);
						if(credito.relacionado == 0){
							deshabilitaBoton('modifica');
							deshabilitaBoton('agrega');
							mensajeSis("El crédito indicado no es un crédito reestructura.");
							varRelacionado =1;
						}else{
							habilitaBoton('modifica');
							deshabilitaBoton('agrega');
							varRelacionado =0;
						}
						if(status != EstatusCredito.Inactivo){
							deshabilitaBoton('modifica');
							deshabilitaBoton('agrega');
						}

						$('#clasiDestinCred').val(credito.clasiDestinCred);
						if(credito.clasiDestinCred==Comercial){
							$('#clasificacionDestin1').attr("checked",true);
							$('#clasificacionDestin2').attr("checked",false);
							$('#clasificacionDestin3').attr("checked",false);

						}else if(credito.clasiDestinCred==Consumo){
							$('#clasificacionDestin1').attr("checked",false);
							$('#clasificacionDestin2').attr("checked",true);
							$('#clasificacionDestin3').attr("checked",false);

						}else{
							$('#clasificacionDestin1').attr("checked",false);
							$('#clasificacionDestin2').attr("checked",false);
							$('#clasificacionDestin3').attr("checked",true);
						}

						agregaFormatoControles('formaGenerica');
					}else{
						inicializaForma('formaGenerica','creditoID' );
						mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
						limpiaCreditoRees();
						inicializaCombos();
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
						$('#creditoID').val("");
						$('#creditoID').focus();
						$('#creditoID').select();
						tab2=false;
					}
					}else{
						mensajeSis("No Existe el Crédito");
						inicializaForma('formaGenerica','creditoID' );
						limpiaCreditoRees();
						inicializaCombos();
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
						$('#creditoID').val("");
						$('#creditoID').focus();
						$('#creditoID').select();
						tab2=false;
					}
				});
			}
		}
	}


	// funcion para precargar los valores del credito origen
	function validaCreditoOrigen(idControl) {

		inicializaCombos();
		var jqCredito  = eval("'#" + idControl + "'");
		var numCredito = $(jqCredito).val();
		TipCobroCAper="";
		//plazo=0;
		frecInt=0;
		frecCap=0;
		tipoPag=0;
		tipoDisper=0;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) && esTab){
			// ingreso por cero cuando no selecciona nada
			if(numCredito=='0'){
				inicializaForma('formaGenerica','creditoID' );
				deshabilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');
				inicializaForma('formaGenerica','creditoID' );
				consultaParametros();
				$('#monedaID').val('-1');
				$('#fechaInhabil1').attr("checked","1") ;
				$('#fechaInhabil2').attr("checked",false) ;
				$('#fechaInhabil').val("S");
				$('#contenedorSimulador').html("");
			} else {
				// consulta del credito
				deshabilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');
				var creditoBeanCon = {
						'creditoID':numCredito
				};
				creditosServicio.consulta(catTipoConsultaCredito.principal,creditoBeanCon,function(credito) {
					if(credito!=null){
						habilitaBoton('agrega', 'submit');
						deshabilitaBoton('modifica', 'submit');


						parametroBean = consultaParametrosSession();
						$('#estatusOrigen').val(credito.estatus);
						$('#fechaInicioOrigen').val(credito.fechaInicio);
						$('#fechaVenOrigen').val(credito.fechaVencimien);
						$('#totalAdeudoOrigen').val(credito.totalAdeudo);
						$('#totalExigibleOrigen').val(credito.totalExigible);
						$('#diasAtrasoOrigen').val(credito.diasFaltaPago);
						$('#fechaInicio').val(parametroBean.fechaSucursal);
						$('#clienteID').val(credito.clienteID);
						$('#producCreditoIDOrigen').val(credito.producCreditoID);
						$('#montoCredito').val(credito.totalAdeudo);
						$('#monedaID').val(credito.monedaID);
						$('#ajusFecExiVen').val(credito.ajusFecExiVen);
						$('#periodicidadInt').val(credito.periodicidadInt);
						$('#periodicidadCap').val(credito.periodicidadCap);
						$('#diaPagoInteres').val(credito.diaPagoInteres);
						$('#diaPagoCapital').val(credito.diaPagoCapital);
						$('#diaPagoProd').val(credito.diaPagoCapital); // campo auxiliar para validar

						$('#diaMesInteres').val(credito.diaMesInteres);
						$('#diaMesCapital').val(credito.diaMesCapital);
						$('#institFondeoID').val(credito.institFondeoID);
						$('#lineaFondeo').val(credito.lineaFondeo);
						$('#estatusOrigen').val(credito.estatus);
						$('#numTransacSim').val(credito.numTransacSim);
						$('#tipoFondeo').val(credito.tipoFondeo);
						$('#fechaAutoriza').val(credito.fechaAutoriza);
						$('#fechaInhabil').val(credito.fechaInhabil);
						$('#ajusFecExiVen').val(credito.ajusFecExiVen);
						$('#ajusFecUlVenAmo').val(credito.ajusFecUlVenAmo);
						num=credito.PlazoID;
						if(credito.tasaBase !=0){
							consultaTasaBase('tasaBase',false);
						}
						if(credito.fechaInhabil=='S'){
							$('#fechaInhabil1').attr("checked","1") ;
							$('#fechaInhabil2').attr("checked",false) ;
							$('#fechaInhabil').val("S");
						}
						else{
							$('#fechaInhabil2').attr("checked","1") ;
							$('#fechaInhabil1').attr("checked",false) ;
							$('#fechaInhabil').val("A");
						}
						if(credito.ajusFecExiVen== AjusteFechaExigibleVenc.SI){
							$('#ajusFecExiVen1').attr("checked","1") ;
							$('#ajusFecExiVen2').attr("checked",false) ;
							$('#ajusFecExiVen').val(AjusteFechaExigibleVenc.SI);
						}else{
							$('#ajusFecExiVen1').attr("checked",false) ;
							$('#ajusFecExiVen2').attr("checked","1") ;
							$('#ajusFecExiVen').val(AjusteFechaExigibleVenc.NO);
						}
						habilitaControl('tipoPagoCapital');
						if(credito.ajusFecUlVenAmo== AjustaUltimaFechaVenAmort.SI){
							$('#ajusFecUlVenAmo1').attr("checked","1") ;
							$('#ajusFecUlVenAmo2').attr("checked",false) ;
							$('#ajusFecUlVenAmo').val(AjustaUltimaFechaVenAmort.SI) ;
						}
						else{
							$('#ajusFecUlVenAmo1').attr("checked",false) ;
							$('#ajusFecUlVenAmo2').attr("checked","1") ;
							$('#ajusFecUlVenAmo').val(AjustaUltimaFechaVenAmort.NO) ;
						}
						if(credito.diaPagoInteres== "F"){
							$('#diaPagoInteres1').attr("checked","1") ;
							$('#diaPagoInteres2').attr("checked",false) ;
							$('#diaPagoInteres').val("F") ;
						}else{
							$('#diaPagoInteres2').attr("checked","1") ;
							$('#diaPagoInteres1').attr("checked",false) ;
						}
						if(credito.diaPagoCapital== "F"){
							$('#diaPagoCapital1').attr("checked","1") ;
							$('#diaPagoCapital2').attr("checked",false) ;
						}
						else{
							$('#diaPagoCapital2').attr("checked","1") ;
							$('#diaPagoCapital1').attr("checked",false) ;
							$('#diaMesCapital').val(credito.diaMesCapital);
						}

						$('#diaPagoInteres').val(credito.diaPagoInteres);
						$('#diaPagoCapital').val(credito.diaPagoCapital) ;
						//$('#diaPagoProd').val(credito.diaPagoCapital); // campo auxiliar para validar

						if (credito.calendIrregular == 'S') {
							$('#calendIrregularCheck').attr("checked","1");
							$('#calendIrregular').val("S");
							deshabilitaControl('tipoPagoCapital');
							deshabilitaControl('frecuenciaInt');
							deshabilitaControl('frecuenciaCap');
						} else {
							$('#calendIrregularCheck').attr("checked",false);
							$('#calendIrregular').val("N");
							/*habilitaControl('tipoPagoCapital');
							habilitaControl('frecuenciaInt');
							habilitaControl('frecuenciaCap');*/
						}

						if(credito.tipoPagoCapital== TipoPagoCapital.Crecientes){
							$('#tipoPagoCapital').attr("checked","1") ;
						}else{
							if(credito.tipoPagoCapital== TipoPagoCapital.Iguales){
								$('#tipoPagoCapital').attr("checked",false) ;
							}else{
								if(credito.tipoPagoCapital== TipoPagoCapital.Libres){
									$('#tipoPagoCapital').attr("checked",false) ;
								}
								if(credito.tipoFondeo== TipoFondeo.RecursosPropios){
								}else{
									if(credito.tipoFondeo== TipoFondeo.InstitucionFondeo){
									}
								}
							}
						}

						validaTipoPago();
						montoOriginal = credito.montoCredito; // variable que almacena el monto origina solicitado (para calculos comision apertura)
						MontoIni =credito.montoCredito;

						consultaTasaCredito('montoCredito');
						var monto =$('#montoCredito').asNumber();
						var MontoInic = MontoIni;


						if(MontoInic != monto && TipCobroCAper == TipoFormaCobroApertura.Financiamiento){
							consultaComisionAper();
						}else{
							if(MontoInic != monto && TipCobroCAper != TipoFormaCobroApertura.Financiamiento){
								consultaComisionAper();
							}
						}

						$('#tipoDispersion').val(credito.tipoDispersion).selected = true;
						consultaProducCreditoReestructura('producCreditoIDOrigen','nombreProdOrigen');
						NumCuotasInt = credito.numAmortInteres; // asigna el valor de numero de cuotas de interes
						$('#cat').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
						$('#montoCuota').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
						$('#numTransacSim').val(credito.numTransacSim);
						$('#numAmortizacion').val(credito.numAmortizacion);
						$('#numAmortInteres').val(credito.numAmortInteres);

						// se vuelven a consultar las condiciones del producto de credito con el que se generara el credito nuevo

						consultaProducCredito('producCreditoID');
						//consultaCalendarioPorProducto('producCreditoID',num);

						// se llena la parte del calendario y valores parametrizados en el
						// producto seleccionando los que se trajo de resultado la consulta
						consultaCalendarioPorProductoCredito( $('#producCreditoID').val(), credito.tipoPagoCapital,
								credito.frecuenciaCap, credito.frecuenciaInt,credito.plazoID, credito.tipoDispersion);

				 		$('#montoCredito').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
				 		$('#montoComision').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
				 		$('#IVAComApertura').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
						agregaFormatoControles('formaGenerica');
						varRelacionado =0;
					}else{
						mensajeSis("No Existe el Crédito");
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
						$('#creditoID').focus();
						$('#creditoID').select();
						tab2=false;
					}
				});
			}
		}
	}


	// funcion para consultar los valores del credito relacionado
	function consultaCreditoRelacionado(idControl) {
		var jqCredito  = eval("'#" + idControl + "'");
		var numCredito = $(jqCredito).val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) && esTab){
			// ingreso por cero cuando no selecciona nada
			if(numCredito=='0'){
				limpiaCreditoRees();
			} else {
				var creditoBeanCon = {
						'creditoID':numCredito
				};
				creditosServicio.consulta(catTipoConsultaCredito.principal,creditoBeanCon,function(credito) {
					if(credito!=null){

						parametroBean = consultaParametrosSession();
						$('#estatusOrigen').val(credito.estatus);
						$('#fechaInicioOrigen').val(credito.fechaInicio);
						$('#fechaVenOrigen').val(credito.fechaVencimien);
						$('#totalAdeudoOrigen').val(credito.totalAdeudo);
						$('#totalExigibleOrigen').val(credito.totalExigible);
						$('#diasAtrasoOrigen').val(credito.diasFaltaPago);
						$('#producCreditoIDOrigen').val(credito.producCreditoID);


						consultaProducCreditoReestructura('producCreditoIDOrigen','nombreProdOrigen');


					}else{
						mensajeSis("No Existe el Crédito");
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
						$('#creditoID').focus();
						$('#creditoID').select();
						tab2=false;
					}
				});
			}
		}
	}

	// funcion para validar si existe el cliente origen
	function consultaClienteOrigen(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var tipConPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipConPrincipal,numCliente,function(cliente) {
				if(cliente!=null){
					listaPersBloqBean = consultaListaPersBloq(numCliente, esCliente, 0, 0);
					consultaSPL = consultaPermiteOperaSPL(numCliente,'LPB',esCliente);
				
					if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
						if($('#relacionado').val() !="" ){
							inicializaForma('formaGenerica','creditoID' );
							$('#cuentaID').val("");
							limpiaCreditoRees();
						}
						$('#clienteID').val(cliente.numero);
						$('#nombreCliente').val(cliente.nombreCompleto);
						$('#pagaIVACte').val(cliente.pagaIVA);
						$('#sucursalCte').val(cliente.sucursalOrigen);
						consultaCreditoOrigen();

					}else{
						inicializaForma('formaGenerica','creditoID');
						mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
						$('#clienteID').focus();
						$('#clienteID').select();
						$('#clienteID').val("");
						$('nombreCliente').val("");
						$('cuentaID').val("");
						inicializaForma('formaGenerica','creditoID' );
						limpiaCreditoRees();
					}
				}else{
					mensajeSis("El cliente indicado no Existe");
					inicializaForma('formaGenerica','creditoID' );
					$('#clienteID').focus();
					$('#clienteID').select();
					$('#clienteID').val("");
					$('nombreCliente').val("");
					$('cuentaID').val("");
					inicializaForma('formaGenerica','creditoID' );
					limpiaCreditoRees();
				}
			});
		}
	}

	 // consulta de cliente
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var tipConPrincipal = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipConPrincipal,numCliente,function(cliente) {
				if(cliente!=null){
					$('#clienteID').val(cliente.numero);
					$('#nombreCliente').val(cliente.nombreCompleto);
					$('#pagaIVACte').val(cliente.pagaIVA);
					$('#sucursalCte').val(cliente.sucursalOrigen);
				}else{
					mensajeSis("El cliente indicado no Existe");
					$('#clienteID').focus();
					$('#clienteID').select();
				}
			});
		}
	}

	// valida calculo de interes
	function ValidaCalcInteres(idControl) {
		validaTipoPago();
		var jqCalc = eval("'#" + idControl + "'");
		var numCalc = $(jqCalc).val();
		habilitaCamposTasa(numCalc);
	}

	//	calcula el numero de dias entre las fecha inicio  y fecha final
	function calculaNodeDias(){
		if($('#fechaInicio').val()!= ''){
			var opeFechaBean = {
					'primerFecha':$('#fechaVencimien').val(),
					'segundaFecha':parametroBean.fechaSucursal
			};
			operacionesFechasServicio.realizaOperacion(opeFechaBean,catOperacFechas.restaFechas, function(data) {
				if(data!=null){
					$('#noDias').val(data.diasEntreFechas);// número de dias de la fecha inicial a la fecha de vencimiento.
					// las periodicidades de capital e interes
					if($('#frecuenciaCap').val()== FrecuenciaCapital.Unico){
						$('#periodicidadCap').val(data.diasEntreFechas);
						$('#periodicidadInt').val(data.diasEntreFechas);
					}
				}
			});
		}
	}

	// valida el tipo de pago de capital
	function validaTipoPago() {
		var tipoPag = $('#tipoPagoCapital').val();
		var permite = $('#perIgual').val();
		//frecInt = $('#frecuenciaInt').val();
		if(tipoPag == TipoPagoCapital.Crecientes){
			if($('#frecuenciaCap').val() == FrecuenciaCapital.Unico || $('#frecuenciaInt').val() == FrecuenciaIntereses.Unico ){
				deshabilitarCalendarioPagosInteres();
				$('#numAmortizacion').val("1");
				$('#numAmortInteres').val("1");
				deshabilitaControl('numAmortizacion');
				deshabilitaControl('numAmortInteres');
				$('#periodicidadCap').val($('#noDias').val());
				$('#periodicidadInt').val($('#noDias').val());
			}else{
				$('#numAmortInteres').val($('#numAmortizacion').val());
			}
			deshabilitaControl('frecuenciaInt');
			$('#frecuenciaInt').val($('#frecuenciaCap').val()).selected = true;
			deshabilitaControl('diaPagoInteres1');
			deshabilitaControl('diaPagoInteres2');
			deshabilitaControl('numAmortInteres');
			validaFrecuenciaCap();

		}
		if(tipoPag == TipoPagoCapital.Iguales || tipoPag== TipoPagoCapital.Libres){
			// si el tipo de pago es UNICO se deshabilitan las cajas para indicar numero de cuotas
			if($('#frecuenciaCap').val() == FrecuenciaCapital.Unico || $('#frecuenciaInt').val() == FrecuenciaIntereses.Unico ){
				deshabilitarCalendarioPagosInteres();
				$('#numAmortizacion').val("1");
				$('#numAmortInteres').val("1");
				deshabilitaControl('numAmortizacion');
				deshabilitaControl('numAmortInteres');
				$('#periodicidadCap').val($('#noDias').val());
				$('#periodicidadInt').val($('#noDias').val());
			}else{
				if(permite == 'S'){
					$('#frecuenciaInt').val('');
					$('#frecuenciaInt').val($('#frecuenciaCap').val());
					deshabilitaControl('frecuenciaInt');
					deshabilitaControl('numAmortInteres');
					$('#numAmortInteres').val($('#numAmortizacion').val());
					validaFrecuenciaCap();
					habilitaControl('diaPagoInteres');
				}
				if(permite == 'N'){
					habilitaControl('frecuenciaInt');
					habilitaControl('diaPagoInteres');
					habilitaControl('numAmortInteres');
				}
			}
		}

		if(tipoPag == TipoPagoCapital.Iguales ){
			var permiteIgual = $('#perIgual').val();
			if(permiteIgual == PermitePagosIguales.SI){
				deshabilitaControl('frecuenciaInt');
			}else{
				habilitaControl('frecuenciaInt');
			}
		}
	 }


	// valida la frecuencia de pago de interes
	function validaFrecuenciaInt(idControl) {
		var jqfrecInt = eval("'#" + idControl + "'");
		var frecInt = $(jqfrecInt).val();
			if(frecInt== FrecuenciaIntereses.Periodo){
			habilitaControl('periodicidadInt');
			deshabilitaControl('diaPagoInteres1');
			deshabilitaControl('diaPagoInteres2');
			deshabilitaControl('diaMesInteres');

			$('#diaPagoInteres2').attr("checked",false);
			$('#diaPagoInteres').attr("checked",false);
			$('#diaMesInteres').val('');
			}
			else{
			deshabilitaControl('periodicidadInt');
			$('#periodicidadInt').val('');
			habilitaControl('diaPagoInteres');
			habilitaControl('diaPagoInteres2');
			 $(':radio').change(function () {
          if($('#diaPagoInteres2').is(':checked')){
                   habilitaControl('diaMesInteres');
            }
            else
          if($('#diaPagoInteres').is(':checked')){
          		deshabilitaControl('diaMesInteres');
					$('#diaMesInteres').val('0');
            }
    		});
		}

	}

		// valida la frecuencia de pago de capital
		function validaFrecuenciaCap(idControl) {
			var jqfrecCap = eval("'#" + idControl + "'");
			var frecCap = $(jqfrecCap).val();
			var tp = $('#tipoPagoCapital').val();
			var frecInt = $('#frecuenciaInt').val();
			var permite = $('#perIgual').val();

				if(tp== TipoPagoCapital.Crecientes){
					// si el tipo de pago es UNICO se deshabilitan las cajas para indicar numero de cuotas
					if($('#frecuenciaCap').val() == FrecuenciaCapital.Unico ){
						mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
						$('#numAmortizacion').val("1");
						$('#numAmortInteres').val("1");
						deshabilitaControl('numAmortizacion');
						deshabilitaControl('numAmortInteres');
						$('#periodicidadCap').val($('#noDias').val());
						//$('#periodicidadInt').val($('#noDias').val());
					}else{

						$('#frecuenciaInt').val($('#frecuenciaCap').val());
						frecInt= $('#frecuenciaInt').val();
					}

				 }else{
				 	if(tp == TipoPagoCapital.Iguales){
				 		if($('#frecuenciaCap').val() == FrecuenciaCapital.Unico ){
							$('#numAmortizacion').val("1");
							$('#numAmortInteres').val("1");
							deshabilitaControl('numAmortizacion');
							deshabilitaControl('numAmortInteres');
							$('#periodicidadCap').val($('#noDias').val());
							//$('#periodicidadInt').val($('#noDias').val());
						}

				 		if(permite == PermitePagosIguales.SI){
				 			$('#frecuenciaInt').val('');
							$('#frecuenciaInt').val(frecCap);
							deshabilitaControl('frecuenciaInt');

						}else{
							habilitaControl('frecuenciaInt');
						}
					}
				 }

				if(frecCap== FrecuenciaCapital.Periodo){
					habilitaControl('periodicidadCap');
					deshabilitaControl('diaPagoCapital1');
					deshabilitaControl('diaPagoCapital2');

					$('#diaPagoCapital2').attr("checked",false);
					$('#diaPagoCapital1').attr("checked",false);
					deshabilitaControl('diaMesCapital');
					$('#diaMesCapital').val('');
				}
				// asigna en dias la periodicidad, dependiendo de la frecuencia seleccionada
				if(frecCap == FrecuenciaCapital.Semanal){
					$('#periodicidadCap').val('7');
				}
				if(frecInt == FrecuenciaIntereses.Semanal){
					$('#periodicidadInt').val('7');
				}
				if(frecCap == FrecuenciaCapital.Decenal){
					$('#periodicidadCap').val('10');
				}
				if(frecInt == FrecuenciaIntereses.Decenal){
					$('#periodicidadInt').val('10');
				}
				if(frecCap == FrecuenciaCapital.Catorcenal){
					$('#periodicidadCap').val('14');
				}
				if(frecInt == FrecuenciaIntereses.Catorcenal){
					$('#periodicidadInt').val('14');
				}
				if(frecCap == FrecuenciaCapital.Quincenal){
					$('#periodicidadCap').val('15');
				}
				if(frecInt == FrecuenciaIntereses.Quincenal){
					$('#periodicidadInt').val('15');
				}
				if(frecCap == FrecuenciaCapital.Mensual){
					$('#periodicidadCap').val('30');
				}
				if(frecInt == FrecuenciaIntereses.Mensual){
					$('#periodicidadInt').val('30');
				}
				if(frecCap == FrecuenciaCapital.Bimestral){
					$('#periodicidadCap').val('60');
				}
				if(frecInt == FrecuenciaIntereses.Bimestral){
					$('#periodicidadInt').val('60');
				}
				if(frecCap == FrecuenciaCapital.Trimestral){
					$('#periodicidadCap').val('90');
				}
				if(frecInt == FrecuenciaIntereses.Trimestral){
					$('#periodicidadInt').val('90');
				}
				if(frecCap == FrecuenciaCapital.TetraMestral){
					$('#periodicidadCap').val('120');
				}
				if(frecInt == FrecuenciaIntereses.TetraMestral){
					$('#periodicidadInt').val('120');
				}
				if(frecCap == FrecuenciaCapital.Semestral){
					$('#periodicidadCap').val('180');
				}
				if(frecInt == FrecuenciaIntereses.Semestral){
					$('#periodicidadInt').val('180');
				}
				if(frecCap == FrecuenciaCapital.Anual){
					$('#periodicidadCap').val('360');
				}
				if(frecInt == FrecuenciaIntereses.Anual){
					$('#periodicidadInt').val('360');
				}

				calculaNodeDias();
		}

	// consulta de solicitud de credito (creditos porsolicitud)
	function consultaSolicitudCred(idControl) {

		var Comercial='C';
		var Consumo ='O';

		var jqSolCred = eval("'#" + idControl + "'");
		var numSolicitud = $(jqSolCred).val();
		var tipCon = 1;

 		var SolicitudBeanCon = {
  				'solicitudCreditoID':numSolicitud,
 		};
 		setTimeout("$('#cajaLista').hide();", 200);
		if(numSolicitud != '' && !isNaN(numSolicitud) && esTab && numSolicitud != '0'){
			solicitudCredServicio.consulta(tipCon,SolicitudBeanCon,function(solicitudCred) {
				if(solicitudCred!=null){
					listaPersBloqBean = consultaListaPersBloq(solicitudCred.clienteID, esCliente, 0, 0);
					consultaSPL = consultaPermiteOperaSPL(solicitudCred.clienteID,'LPB',esCliente);
				
					if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
						deshabilitaControlesSolicitud();
						if(solicitudCred.creditoID != 0){
							deshabilitaBoton('agrega', 'submit');
						}
						var status = solicitudCred.estatus;
						//valida que la solicitud este autorizada
						if(status ==  EstatusSolicitudCred.Inactiva){
							mensajeSis("La Solicitud no ha sido Autorizada");
						}else{
							// valida que la solicitud este autorizada y no desembolsada
							if(status != EstatusSolicitudCred.Desembolsada && status != EstatusSolicitudCred.Inactiva){
	
								dwr.util.setValues(solicitudCred);
								if(solicitudCred.creditoID != 0){
									deshabilitaBoton('agrega', 'submit');
									habilitaBoton('modifica', 'submit');
								}else{
									habilitaBoton('agrega', 'submit');
									deshabilitaBoton('modifica', 'submit');
								}
								plazo = solicitudCred.plazoID;
								frecCap = solicitudCred.frecuenciaCap;
								frecInt = solicitudCred.frecuenciaInt;
	
								tipoPag = solicitudCred.tipoPagoCapital;
								tipoDisper = solicitudCred.tipoDispersion;
								$('#producCreditoID').val(solicitudCred.productoCreditoID);
								consultaCalendarioPorProducto('producCreditoID',plazo);
								$('#montoCredito').val(solicitudCred.montoAutorizado);
								$('#montoCredito').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
								$('#fechaInicio').val(solicitudCred.fechaInicio);
								$('#montoComision').val(solicitudCred.montoComApert);
								$('#IVAComApertura').val(solicitudCred.ivaComApert);
								$('#cat').val(solicitudCred.CAT);
								$('#estatus').val('I');
								$('#numAmortizacion').val(solicitudCred.numAmortizacion);
								consultaClienteSolici('clienteID');
								consultaProducCreditoForanea(solicitudCred.productoCreditoID);
								consultaDestinoCreditoSolicitud('destinoCreID');
								//$('#plazoID').val(solicitudCred.plazoID).select();
	
								$('#clasiDestinCred').val(solicitudCred.clasifiDestinCred);
								if(solicitudCred.clasifiDestinCred==Comercial){
									$('#clasificacionDestin1').attr("checked",true);
									$('#clasificacionDestin2').attr("checked",false);
									$('#clasificacionDestin3').attr("checked",false);
	
								}else if(solicitudCred.clasifiDestinCred==Consumo){
									$('#clasificacionDestin1').attr("checked",false);
									$('#clasificacionDestin2').attr("checked",true);
									$('#clasificacionDestin3').attr("checked",false);
	
								}else{
									$('#clasificacionDestin1').attr("checked",false);
									$('#clasificacionDestin2').attr("checked",false);
									$('#clasificacionDestin3').attr("checked",true);
								}
								setCalcInteresID(solicitudCred.calcInteresID,false);
								consultaTasaBase('tasaBase',false);
	
								deshabilitaControl('fechaInhabil1');
								deshabilitaControl('fechaInhabil2');
								deshabilitaControl('ajusFecExiVen1');
								deshabilitaControl('ajusFecExiVen2');
								deshabilitaControl('ajusFecUlVenAmo1');
								deshabilitaControl('ajusFecUlVenAmo2');
								$('#fechaInhabil').val(solicitudCred.fechInhabil);
								if(solicitudCred.fechInhabil=='S'){
									$('#fechaInhabil1').attr("checked","1") ;
									$('#fechaInhabil2').attr("checked",false) ;
									$('#fechaInhabil').val("S");
								}
								else{
									$('#fechaInhabil2').attr("checked","1") ;
									$('#fechaInhabil1').attr("checked",false) ;
									$('#fechaInhabil').val("A");
								}
								$('#ajusFecExiVen').val(solicitudCred.ajusFecExiVen);
								if(solicitudCred.ajusFecExiVen== AjusteFechaExigibleVenc.SI){
										$('#ajusFecExiVen1').attr("checked","1") ;
										$('#ajusFecExiVen2').attr("checked",false) ;
										$('#ajusFecExiVen').val(AjusteFechaExigibleVenc.SI);
									}else{
										$('#ajusFecExiVen1').attr("checked",false) ;
										$('#ajusFecExiVen2').attr("checked","1") ;
										$('#ajusFecExiVen').val(AjusteFechaExigibleVenc.NO);
									}
								$('#ajusFecUlVenAmo').val(solicitudCred.ajFecUlAmoVen);
								if(solicitudCred.ajFecUlAmoVen== AjustaUltimaFechaVenAmort.SI){
									$('#ajusFecUlVenAmo1').attr("checked","1") ;
									$('#ajusFecUlVenAmo2').attr("checked",false) ;
									$('#ajusFecUlVenAmo').val(AjustaUltimaFechaVenAmort.SI) ;
								}
								else{
									$('#ajusFecUlVenAmo1').attr("checked",false) ;
									$('#ajusFecUlVenAmo2').attr("checked","1") ;
									$('#ajusFecUlVenAmo').val(AjustaUltimaFechaVenAmort.NO) ;
								}
								if(solicitudCred.diaPagoInteres== "F"){
									$('#diaPagoInteres1').attr("checked","1") ;
									$('#diaPagoInteres2').attr("checked",false) ;
								}else{
									$('#diaPagoInteres2').attr("checked","1") ;
									$('#diaPagoInteres1').attr("checked",false) ;
								}
								if(solicitudCred.diaPagoCapital== "F"){
									$('#diaPagoCapital1').attr("checked","1") ;
									$('#diaPagoCapital2').attr("checked",false) ;
								}
								else{
									$('#diaPagoCapital2').attr("checked","1") ;
									$('#diaPagoCapital1').attr("checked",false) ;
									$('#diaMesCapital').val(solicitudCred.diaMesCapital);
								}
	
								$('#diaPagoInteres').val(solicitudCred.diaPagoInteres);
								$('#diaPagoCapital').val(solicitudCred.diaPagoCapital);
								$('#diaPagoProd').val(solicitudCred.diaPagoCapital); // campo auxiliar para validar
	
								if(solicitudCred.frecuenciaInt == null){
									$('#frecuenciaInt').val('0');
								}
								$('#tipoPagoCapital').val(solicitudCred.tipoPagoCapital) ;
								deshabilitaControl('tipoPagoCapital');
								if(solicitudCred.tipoFondeo == TipoFondeo.RecursosPropios){
								}
								if(solicitudCred.tipoFondeo == TipoFondeo.InstitucionFondeo){
								}
								$('#cat').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
								$('#montoCuota').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
							}
						}
						deshabilitaControlesSolicitud();
						$('#montoCredito').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
						$('#montoComision').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
						$('#IVAComApertura').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
					}else{
						inicializaForma('formaGenerica','creditoID');
						mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
						deshabilitaBoton('agrega', 'submit');
						$('#solicitudCreditoID').focus();
						$('#solicitudCreditoID').val('');
						habilitaControlesSolicitud();
					}
				}else{
					if(numSolicitud != '0' ){
						deshabilitaBoton('agrega', 'submit');
						mensajeSis("No Existe la solicitud");
						$('#solicitudCreditoID').focus();
						$('#solicitudCreditoID').select();
						habilitaControlesSolicitud();
					}
				}
			});
		}
	}

	// consulta de monedas
	function consultaMoneda() {
  		dwr.util.removeAllOptions('monedaID');
		dwr.util.addOptions('monedaID', {0:'SELECCIONAR'});
		monedasServicio.listaCombo(3, function(monedas){
		dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
		});
	}


	// Consulta Tasa Base
	function consultaTasaBase(idControl, desdeInput) {
		var jqTasa = eval("'#" + idControl + "'");
		var tasaBase = $(jqTasa).asNumber();
		var TasaBaseBeanCon = {
				'tasaBaseID' : tasaBase
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (tasaBase > 0 && esTab) {
			tasasBaseServicio.consulta(1, TasaBaseBeanCon, function(tasasBaseBean) {
				if (tasasBaseBean != null) {
					hayTasaBase = true;
					$('#desTasaBase').val(tasasBaseBean.nombre);
					valorTasaBase = tasasBaseBean.valor;

					if(desdeInput){
						$('#tasaFija').val(valorTasaBase).change();
					}
					$('#tasaFija').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
				} else {
					hayTasaBase = false;
					mensajeSis("No Existe la Tasa Base.");
					$('#tasaBaseID').focus();
					$('#tasaBaseID').val('');
					$('#desTasaBase').val('');
					$('#tasaFija').val('').change();
				}
			});
		}
	}

	 // consulta de productos de credito
	 function consultaProducCredito(idControl) {
		 var jqProdCred  = eval("'#" + idControl + "'");
		 var ProdCred = $(jqProdCred).val();
		 var ProdCredBeanCon = {
  			'producCreditoID':ProdCred
		 };
		 setTimeout("$('#cajaLista').hide();", 200);
		 if(ProdCred != '' && !isNaN(ProdCred) && esTab){
			 productosCreditoServicio.consulta(catTipoConsultaCredito.principal,ProdCredBeanCon,function(prodCred) {
				 if(prodCred!=null){

					//valida que el grupo no se grupal, en caso contrario manda error
					/*if(prodCred.esGrupal == 'S' ){
						alert("Producto de Crédito Reservado para Créditos Grupales.");
						inicializaForma('formaGenerica','creditoID');
						inicializaCombos();
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('modifica', 'submit');
						$('#producCreditoID').val('');
						$('#nombreProd').val('');
						$('#clasificacion').val('');
						$('#DescripClasific').val('');
						$('#producCreditoID').focus();
					}else{*/
						//var credito = $('#creditoID').val();
						var solCredito = $('#solicitudCreditoID').val();
						$('#nombreProd').val(prodCred.descripcion);
						if(solCredito == '0' || solCredito == '' ){
							$('#clasificacion').val(prodCred.clasificacion);
							$('#factorMora').val(prodCred.factorMora);
							setCalcInteresID(prodCred.calcInteres,false);
							$('#tipoCalInteres').val(prodCred.tipoCalInteres);
							deshabilitaControl('tipoCalInteres');
						}
						habilitaCamposTasa(prodCred.calcInteres);
						consultaDescripClaRepReg('clasificacion');
						//asignacion de variables de los valores montos: mÃ­nimo, mÃ¡ximo, y la forma de comision por apertura
						//permitido por el producto de credito para sus correspondientes validaciones del monto de crÃ©dito
						MontoMaxCre =prodCred.montoMaximo;
						MontoMinCre = prodCred.montoMinimo;
						TipCobroCAper =prodCred.formaComApertura;
					//}
					if (prodCred.esReestructura == "S"){
						habilitaBoton('agrega', 'submit');
					}else{
						mensajeSis("El producto de crédito no permite Reestructuras");
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('modifica', 'submit');
						$(jqProdCred).val("");
						$('#nombreProd').val("");
						$(jqProdCred).focus();
					}
				}else{
					mensajeSis("No Existe el Producto de Credito");
					$('#producCreditoID').focus();
					$('#producCreditoID').select();
				}
			});
		}
	}

	// funcion para mostar el producto de credito al consultarlo
	function consultaProducCreditoConsultar(producto) {
		var ProdCredBeanCon = {
				'producCreditoID':producto
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(producto != '' && !isNaN(producto) && esTab){
			productosCreditoServicio.consulta(catTipoConsultaCredito.principal,ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){

					// valida que el producto no sea grupal
					/*if(prodCred.esGrupal == 'S' ){
						alert("Producto de Crédito Reservado para Créditos Grupales.");
						inicializaForma('formaGenerica','creditoID');
						inicializaCombos();
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('modifica', 'submit');
						accionInicializaRegresoExitoso();
					}else{*/
						InstitucionFo = prodCred.institutFondID;
						$('#nombreProd').val(prodCred.descripcion);
						MontoMaxCre =prodCred.montoMaximo;
						MontoMinCre = prodCred.montoMinimo;
						TipCobroCAper =prodCred.formaComApertura;
						$('#porcentaje').val(prodCred.porcGarLiq);
						$('#calcInteresID').val(prodCred.calcInteres);
						$('#tipoCalInteres').val(prodCred.tipoCalInteres);


						consultaFrecuenciaInt(frecInt);
						consultaFrecuenciaCap(frecCap);
						consultaTipoPagoCap(tipoPag);
						consultaTipoDispersion(tipoDisper);
					//}
					if (prodCred.esReestructura == "S"){
						//habilitaBoton('agrega', 'submit');
					}else{
						mensajeSis("El producto de crédito no permite Reestructuras");
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('modifica', 'submit');
						$('#nombreProd').val("");
						$('#producCreditoID').val("");
						$('#producCreditoID').select();
					}

				}else{
					mensajeSis("No Existe el Producto de Credito");
					$('#producCreditoID').focus();
					$('#producCreditoID').select();
				}
			});
		}
	}


	// funcion para consultar el producto de credito cuando es una reestructura
	function consultaProducCreditoReestructura(idControl, nombreProd) {
		var jqProdCred  = eval("'#" + idControl + "'");
		var jqnombreProd  = eval("'#" + nombreProd + "'");
		var ProdCred = $(jqProdCred).val();
		var ProdCredBeanCon = {
  			'producCreditoID':ProdCred
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(ProdCred != '' && !isNaN(ProdCred) && esTab){
			productosCreditoServicio.consulta(catTipoConsultaCredito.principal,ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){

					$(jqnombreProd).val(prodCred.descripcion);
				}else{
					mensajeSis("No Existe el Producto de Crédito");
					$(jqProdCred).focus();
					$(jqProdCred).select();
					$(jqProdCred).val("");
				}
			});
		}
	}

	// consulta foranea de producto de credito (utilizada en la consulta de un credito existente)
	function consultaProducCreditoForanea(producto) { //ddddd
		var ProdCredBeanCon = {
				'producCreditoID':producto
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(producto != '' && !isNaN(producto) && esTab){
			productosCreditoServicio.consulta(catTipoConsultaCredito.principal,ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){

					// valida que el producto no sea grupal
					/*if(prodCred.esGrupal == 'S' ){
						alert("Producto de Crédito Reservado para Créditos Grupales.");
						inicializaForma('formaGenerica','creditoID');
						inicializaCombos();
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('modifica', 'submit');
						accionInicializaRegresoExitoso();
					}else{*/
						InstitucionFo = prodCred.institutFondID;
						$('#nombreProd').val(prodCred.descripcion);
						MontoMaxCre =prodCred.montoMaximo;
						MontoMinCre = prodCred.montoMinimo;
						TipCobroCAper =prodCred.formaComApertura;
						$('#porcentaje').val(prodCred.porcGarLiq);
						$('#calcInteresID').val(prodCred.calcInteres);
						$('#tipoCalInteres').val(prodCred.tipoCalInteres);

						consultaFrecuenciaInt(frecInt);
						consultaFrecuenciaCap(frecCap);
						consultaTipoPagoCap(tipoPag);
						consultaTipoDispersion(tipoDisper);
					//}
					if (prodCred.esReestructura == "S"){
						//habilitaBoton('agrega', 'submit');
					}else{
						mensajeSis("El producto de crédito no permite Reestructuras");
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('modifica', 'submit');
						$('#producCreditoIDOrigen').val("");
						$('#producCreditoIDOrigen').val("");
						$('#producCreditoIDOrigen').focus();
					}
				}else{
					mensajeSis("No Existe el Producto de Credito");
					$('#producCreditoID').focus();
					$('#producCreditoID').select();
				}
			});
		}
	}

	// funcion que calcula la comision por apertura de credito en base a las condiciones del producto de credito y el monto solicitado
	function consultaComisionAper() {

		var ProdCred = $('#producCreditoID').val();
		var ProdCredBeanCon = {
  			'producCreditoID':ProdCred
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(ProdCred != '' && !isNaN(ProdCred) && esTab){
			productosCreditoServicio.consulta(catTipoConsultaCredito.principal,ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){

					var solCred = $('#solicitudCreditoID').val();
					if (solCred == "" ||solCred == 0 ){
						var tipoComAper = prodCred.tipoComXapert;
						var porcentaje = prodCred.montoComXapert;
						var formaCobro = prodCred.formaComApertura;
						var montoCre = $('#montoCredito').asNumber();

						// si el tipo es monto y forma de cobro por Financiamiento
						if(formaCobro == TipoFormaCobroApertura.Financiamiento || formaCobro == TipoFormaCobroApertura.Deduccion){
							if(tipoComAper == TipoComisionApertura.Procentaje){
								var montoComis = montoCre * (porcentaje/100);
								montoComis.toFixed(2);
								$('#montoComision').val(montoComis);
								var montoCredConv = montoCre;
								montoCredConv.toFixed(2);
								var montoCredAjus= (montoCredConv + montoComis);
								$('#montoCredito').val(montoCredAjus);
								MontoIni=  montoCredAjus;
								consultaIVASucursal();
								$('#montoCredito').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
								$('#montoComision').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
								$('#IVAComApertura').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
							}
							if(tipoComAper == TipoComisionApertura.Monto){
								var montoCreConv = montoCre;
								var porcenConv = porcentaje;
								var montoCredAjus= (parseFloat(montoCreConv) + parseFloat(porcenConv));
								$('#montoCredito').val(montoCredAjus);
								$('#montoComision').val(porcentaje);
									MontoIni =montoCredAjus;
								consultaIVASucursal();
						 		$('#montoCredito').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
						 		$('#montoComision').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
						 		$('#IVAComApertura').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
							}
						}else{
							if (prodCred.formaComApertura == TipoFormaCobroApertura.Anticipado) {// si el tipo es porcentaje hace el calculo del monto y por deduccion
								if(prodCred.tipoComXapert == TipoComisionApertura.Procentaje){
									var montoComis = montoCre * (porcentaje/100);
									montoComis.toFixed(2);
									$('#montoComision').val(montoComis);

									$('#montoComision').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
									if ($('#montoComision').val()=='0'||prodCred.montoComXapert =='0'){
										$('#montoComision').val('0.00');
										$('#IVAComApertura').val('0.00');
									}
									consultaIVASucursal2();

								}else{
									// si es por monto
									if(prodCred.tipoComXapert == TipoComisionApertura.Monto){
										$('#montoComision').val(porcentaje);
										$('#montoComision').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
										 consultaIVASucursal2();

									}
								}
							}
						}

					}
				}
			});
		}

		agregaFormatoControles('formaGenerica');
 		$('#IVAComApertura').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
 		$('#montoCredito').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
	}

	// funcion que calcula el IVA de la comision por apertura de credito de acuerdo a la sucursal del cliente
	function consultaIVASucursal() {
		var numSucursal = $('#sucursalCte').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numSucursal != '' && !isNaN(numSucursal) && esTab){
			sucursalesServicio.consultaSucursal(catTipoConsultaCredito.principal,numSucursal,function(sucursal) {
				if(sucursal!=null){
					var pIVA = $('#pagaIVACte').val();
					var iva = sucursal.IVA;
					var monto = $('#montoComision').asNumber();
					if(pIVA == 'S'){
						var ivaCalc =	(monto	* iva);
						$('#IVAComApertura').val(ivaCalc);
						var montoCredito = $('#montoCredito').asNumber();
						var ivaConver = ivaCalc;
						ivaConver.toFixed(2);
						var montoConver = montoCredito;
						var MontoAjust = (montoConver + ivaConver);

						$('#montoCredito').val(MontoAjust);
				 		$('#montoCredito').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});

				 		$('#montoComision').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
				 		$('#IVAComApertura').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
				 		MontoAjust.toFixed(2);
						MontoIni = MontoAjust; // para verficar despues si cmabio el monto

					}
					if(pIVA == 'N'){
						$('#IVAComApertura').val('0');
					}
				}
			});
		}
	}

	// funcion que calcula el IVA de la comision por apertura de credito de acuerdo a la sucursal del cliente
	//Utilizada cuando el tipo de cobro es por deduccion (no suma la comision ni el iva al monto original del credito)
	function consultaIVASucursal2() {
		var numSucursal = $('#sucursalCte').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numSucursal != '' && !isNaN(numSucursal) && esTab){
			sucursalesServicio.consultaSucursal(catTipoConsultaCredito.principal,numSucursal,function(sucursal) {
				if(sucursal!=null){
					var pIVA = $('#pagaIVACte').val();
					var iva = sucursal.IVA;
					var monto = $('#montoComision').asNumber();
					if(pIVA == 'S'){
						var ivaCalc =	(monto	* iva);
						$('#IVAComApertura').val(ivaCalc);
					}
					if(pIVA == 'N'){
						$('#IVAComApertura').val('0');
					}
				}
			});
		}
	}


	// consulta la descripcion segun reportes regularios
	function consultaDescripClaRepReg(idControl){
		var jqClasific  = eval("'#" + idControl + "'");
		var Clasific = $(jqClasific).val();
			var clasificBeanCon = {
  				'clasifRegID': Clasific
			};
			if(Clasific != '' && !isNaN(Clasific) && esTab){

				clasifrepregServicio.consulta(catTipoConsultaCredito.principal, clasificBeanCon, function(ClasificRep){

				if(ClasificRep!=null){

						$('#DescripClasific').val(ClasificRep.descripcion);



					}else{
						mensajeSis("No Existe la Clasificación");
						$('#clasificacion').focus();
						$('#clasificacion').select();
					}
				});
			}
	}

	function consultaParametros(){
		var credito = $('#creditoID').val();
		if(credito == 0){
		$('#fechaInicio').val(parametroBean.fechaSucursal);
		}
	}

	// valida que los datos que se requieren para generar el
	// simulador de  amortizaciones
	function validaDatosSimulador() {
		if ($.trim($('#producCreditoID').val()) == "") {
			mensajeSis("Producto De Crédito Vací­o");
			$('#producCreditoID').focus();
			datosCompletos = false;
		} else {
			if ($.trim($('#clienteID').val()) == "") {
				mensajeSis("El Cliente Está Vacío");
				$('#clienteID').focus();
				datosCompletos = false;
			} else {
				if ($('#fechaInicio').val() == '') {
					mensajeSis("Fecha de Inicio Vacía");
					$('#fechaInicio').focus();
					datosCompletos = false;
				} else {
					if ($('#fechaVencimien').val() == '') {
						mensajeSis("Fecha de Vencimiento Vacía");
						$('#plazoID').focus();
						datosCompletos = false;
					} else {
						if ($('#tipoPagoCapital').val() == '') {
							mensajeSis("El Tipo de Pago de Capital Está Vací­o.");
							$('#tipoPagoCapital').focus();
							datosCompletos = false;
						} else {
							if ($('#frecuenciaCap').val() == 'U'
								&& $('#tipoPagoCapital').val() != 'I') {
								mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
								$('#frecuenciaCap').val("");
								$('#frecuenciaCap').focus();
								datosCompletos = false;
							} else {
								/* se valida que si el tipo de pago de capital es libre, no se pueda escoger como frecuencia
								 * la opcion de libre */
								if ($('#frecuenciaInt').val() == "L"  && $('#calendIrregular').val() == "N") {
									mensajeSis("La Frecuencia de Interés Libre sólo Aplica para Calendario Irregular.");
									$('#frecuenciaInt').focus();
									$('#frecuenciaInt').val("");
									datosCompletos = false;
								}else{
									if ($('#frecuenciaCap').val() == "L" && $('#calendIrregular').val() == "N") {
										mensajeSis("La Frecuencia de Capital Libre sólo Aplica para Calendario Irregular.");
										$('#frecuenciaCap').focus();
										$('#frecuenciaCap').val("");
										datosCompletos = false;
									}else{
										if ($('#calcInteresID').val() != "") {
											if ($('#calcInteresID')
													.val() == '1') {
												if ($('#tasaFija').val() == ''|| $('#tasaFija').val() == '0') {
													mensajeSis("Tasa de Interés Vací­a");
													$('#tasaFija').focus();
													datosCompletos = false;
												} else {
													if ($('#montoCredito').asNumber() <= "0") {
														mensajeSis("El Monto Está Vacío");
														$('#montoCredito').focus();
														datosCompletos = false;
													} else {
														datosCompletos = true;
													}
												}
											}
										} else {
											mensajeSis("Seleccionar Tipo Cal. Interés");
											$('#calcInteresID').focus();
											datosCompletos = false;
										}
									}
								}
							}
						}
					}
				}
			}
		}
		return datosCompletos;
	}

	// llamada al cotizador de amortizaciones
	function simulador(){
		var fechaIni = parametroBean.fechaAplicacion;
		$('#fechaInicio').val(fechaIni);
		var params = {};
		if($('#calendIrregularCheck').is(':checked')){
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
							tipoLista = 2;
						break;
						case  "L": // si el tipo de pago es LIBRES
							tipoLista = 3;
						break;
						default:
							tipoLista = 1;
					}
				}else{
					//si el tipo de calculo de interes es MontoOriginal (saldos globales)se valida tipo de Lista
					if($('#tipoCalInteres').val() == '2'){
						tipoLista=11;
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
				}

				if($('#tipoPagoCapital').val() == 'L' & ($('#frecuenciaCap').val() =="D" || $('#frecuenciaInt').val()=="D")  ){
									mensajeSis("No se permiten Frecuencias Decenales con pagos de Capital Libres");
									$('#frecuenciaInt').val('S');
									$('#frecuenciaCap').val('S');
									return false;
							}

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
													if(($.trim($('#diaMesInteres').val()) ==''||$('#diaMesInteres').val() ==null || $('#diaMesInteres').val() =='0')
															&& $('#diaPagoInteres2').is(':checked') == true){
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
						params['montoCredito']		= $('#montoCredito').asNumber();
						params['tasaFija']			= $('#tasaFija').val();
						params['frecuenciaCap']		= $('#frecuenciaCap').val();
						params['frecuenciaInt']		= $('#frecuenciaInt').val();
						params['periodicidadCap'] 	= $('#periodicidadCap').val();
						params['periodicidadInt'] 	= $('#periodicidadInt').val();
						params['producCreditoID']	= $('#producCreditoID').val();
						params['clienteID'] 		= $('#clienteID').val();
						params['montoComision']		= $('#montoComision').asNumber();
						params['diaPagoCapital'] 	= $('#diaPagoCapital').val();
						params['diaPagoInteres'] 	= $('#diaPagoInteres').val();
						params['diaMesCapital'] 	= $('#diaMesCapital').val();
						params['diaMesInteres'] 	= $('#diaMesInteres').val();
						params['fechaInicio'] 		= $('#fechaInicio').val();
						params['numAmortizacion'] 	= $('#numAmortizacion').asNumber();
						params['numAmortInteres'] 	= $('#numAmortInteres').asNumber();
						params['fechaInhabil']		= $('#fechaInhabil').val();

						params['ajusFecUlVenAmo']	= $('#ajusFecUlVenAmo').val();
						params['ajusFecExiVen']		= $('#ajusFecExiVen').val();
						params['numTransacSim'] 	= '0';
						params['empresaID'] 		= parametroBean.empresaID;
						params['usuario'] 			= parametroBean.numeroUsuario;
						params['fecha'] 			= parametroBean.fechaSucursal;
						params['direccionIP'] 		= parametroBean.IPsesion;
						params['sucursal'] 			= parametroBean.sucursal;
						params['cobraSeguroCuota'] 	= $('#cobraSeguroCuota option:selected').val();
						params['cobraIVASeguroCuota'] 	= $('#cobraIVASeguroCuota option:selected').val();
						params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
						params['cobraAccesorios']	= 'N';

						bloquearPantallaAmortizacion();
						var numeroError = 0;
						var mensajeTransaccion = "";
						if($('#tipoPagoCapital').val()!="L"){
							$.post("simPagCredito.htm",params,function(data) {
								if (data.length > 0 || data != null) {
									$('#contenedorSimulador').html(data);
							        if ($("#numeroErrorList").length) {
								        numeroError = $('#numeroErrorList').asNumber();
								        mensajeTransaccion = $('#mensajeErrorList').val();
							        }
								    if(numeroError==0){
								        $('#contenedorSimulador').show();
								        $('#contenedorSimuladorLibre').html("");
								        $('#contenedorSimuladorLibre').hide();
								        $('#numTransacSim').val($('#transaccion').val());

										// actualiza la nueva fecha de vencimiento que devuelve el cotizador
										var jqFechaVen = eval("'#fech'");
										$('#fechaVencimien').val($(jqFechaVen).val());

										// asigna el valor de cat devuelto por el cotizador
										$('#cat').val($('#valorCat').val());
										$('#cat').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

										// asigna el valor de monto de la cuota devuelto por el cotizador
										$('#montoCuota').val($('#valorMontoCuota').val());

										//$('#montoCuota').val("0.00");
										// actualiza el numero de cuotas generadas por el cotizador
										$('#numAmortInteres').val($('#valorCuotasInt').val());
										$('#numAmortizacion').val($('#cuotas').val());
										NumCuotas =  $('#cuotas').val();  // se utiliza para saber si agregar una cuota mas o restar una

										// Si el tipo de capital es iguales o saldos globales devuelve numero de cuotas de interes
										if($('#tipoPagoCapital').val() == 'I' || tipoLista== 11){
											$('#numAmortInteres').val($('#valorCuotasInt').val());
											NumCuotasInt = $('#valorCuotasInt').val(); //  se utiliza para saber si agregar una cuota mas o restar una
										}

										if($.trim($('#fechaVencimien').val()) != ""){
											calculaNodeDias($(jqFechaVen).val());
										}
										habilitarBotonesCre();
										if ($('#siguiente').is(':visible') && $('#anterior').is(':visible')==false){
											$('#filaTotales').hide();
										}

										if ($('#siguiente').is(':visible')==false && $('#anterior').is(':visible')==false){
											$('#filaTotales').show();
										}

										$('#imprimirRep').hide(); // uuuu
									}
								} else{
									$('#contenedorSimulador').html("");
									$('#contenedorSimulador').hide();
									$('#contenedorSimuladorLibre').html("");
									$('#contenedorSimuladorLibre').hide();
								}
								$('#contenedorForma').unblock();
								/****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
								if(numeroError!=0){
									$('#contenedorForma').unblock({fadeOut: 0,timeout:0});
									mensajeSisError(numeroError,mensajeTransaccion);
								}
								/**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
							});
						}else{
							$.post("simPagLibresCapCredito.htm", params, function(data){ // todo
								if(data.length >0 || data != null) {
									$('#contenedorSimuladorLibre').html(data);
									if ($("#numeroErrorList").length) {
								        numeroError = $('#numeroErrorList').asNumber();
								        mensajeTransaccion = $('#mensajeErrorList').val();
							        }
									if(numeroError==0){
										$('#contenedorSimuladorLibre').show();
										$('#contenedorSimulador').html("");
										$('#contenedorSimulador').hide();
										$('#numTransacSim').val($('#transaccion').val());
										// actualiza la nueva fecha de vencimiento que devuelve el cotizador
										var jqFechaVen = eval("'#fech'");
										$('#fechaVencimien').val($(jqFechaVen).val());

										// asigna el valor de monto de la cuota devuelto por el cotizador
										if($('#tipoPagoCapital').val() == "C"){
											$('#montoCuota').val($('#valorMontoCuota').val());
											$('#montoCuota').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
										}else{
											if($('#frecuenciaCap').val()=="U" && $('#tipoPagoCapital').val() == "I"){
												$('#montoCuota').val($('#valorMontoCuota').val());
												$('#montoCuota').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
											}else{
												$('#montoCuota').val("0.00");
											}
										}
										// actualiza el numero de cuotas generadas por el cotizador
										$('#numAmortInteres').val($('#valorCuotasInt').val());
										$('#numAmortizacion').val($('#cuotas').val());
										calculaDiferenciaSimuladorLibre();
										$('#imprimirRep').hide(); // uuuu
									}
								}else{
									$('#contenedorSimuladorLibre').html("");
									$('#contenedorSimuladorLibre').hide();
									$('#contenedorSimulador').html("");
									$('#contenedorSimulador').hide();
								}
								$('#contenedorForma').unblock();
								/****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
								if(numeroError!=0){
									$('#contenedorForma').unblock({fadeOut: 0,timeout:0});
									mensajeSisError(numeroError,mensajeTransaccion);
								}
								/**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
								deshabilitaBoton('agrega','submit');
								deshabilitaBoton('modifica','submit');
							});
						}
					}
				}else{
					mensajeSis("Seleccionar Frecuencia de Capital.");
					$('#frecuenciaCap').focus();
					datosCompletos = false;
				}
			}
		}
	}// fin funcion simulador()


	// llamada al sp que consulta el simulador de amortizaciones
	function consultaSimulador(){
		var params = {};
		if($('#solicitudCreditoID').asNumber()>0 ){
			tipoLista = 9;
		}else{
			if($('#calendIrregularCheck').is(':checked')){
				// calendario irregular
				tipoLista = 7;
			}else{
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
					//si el tipo de calculo de interes es MontoOriginal (saldos globales)se valida tipo de Lista
					if($('#tipoCalInteres').val() == '2'){
						tipoLista=11;
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
				}
			}
		}

		params['tipoLista'] = tipoLista;
		params['numTransacSim'] 	= $('#numTransacSim').asNumber();
		bloquearPantallaAmortizacion();
		var numeroError = 0;
		var mensajeTransaccion = "";
		$.post("listaSimuladorConsulta.htm",params,function(data) {
			if (data.length > 0 || data != null) {
				$('#contenedorSimuladorLibre').html(data);
				if ($("#numeroErrorList").length) {
			        numeroError = $('#numeroErrorList').asNumber();
			        mensajeTransaccion = $('#mensajeErrorList').val();
		        }
				if(numeroError==0){
					$('#contenedorSimuladorLibre').show();
					$('#contenedorSimulador').html("");
					$('#contenedorSimulador').hide();
					$('#imprimirRep').hide(); // uuuu
				}
			} else{
				$('#contenedorSimuladorLibre').html("");
				$('#contenedorSimuladorLibre').hide();
				$('#contenedorSimulador').html("");
				$('#contenedorSimulador').hide();
			}
			$('#contenedorForma').unblock();
			/****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
			if(numeroError!=0){
				$('#contenedorForma').unblock({fadeOut: 0,timeout:0});
				mensajeSisError(numeroError,mensajeTransaccion);
			}
			/**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
		});

	}// fin funcion consultaSimulador()

	function simuladorPagosLibresTasaVar(numTransac, cuotas) {
		var mandar = crearMontosCapital(numTransac);
		$('#numAmortizacion').val(cuotas);
		$('#numTransacSim').val(numTransac);
		var jqFechaVen = eval("'#fechaVencim" + cuotas + "'");
		if ($('#ajusFecUlVenAmo2').is(':checked')) {
			$('#fechaVencimien').val($(jqFechaVen).val());
		}
		if (mandar == 2) {
			var params = {};

			quitaFormatoControles('formaGenerica');

			if ($('#calcInteresID').val() == 1) {
				if ($('#tipoPagoCapital').is(':checked')) {
					tipoLista = 1;
				}
			}

			params['tipoLista'] = tipoLista;
			params['montoCredito'] = $('#montoCredito').val();
			params['producCreditoID'] = $('#producCreditoID').val();
			params['clienteID'] = $('#clienteID').val();

			params['empresaID'] = parametroBean.empresaID;
			params['usuario'] = parametroBean.numeroUsuario;
			params['fecha'] = parametroBean.fechaSucursal;
			params['direccionIP'] = parametroBean.IPsesion;
			params['sucursal'] = parametroBean.sucursal;
			params['numTransaccion'] = $('#numTransacSim').val();
			params['numTransacSim'] = $('#numTransacSim').val();

			params['montosCapital'] = $('#montosCapital').val();
			var numeroError = 0;
			var mensajeTransaccion = "";
			$.post("simPagLibresCredito.htm", params, function(
					data) {
				if (data.length > 0) {
					$('#contenedorSimulador').html(data);
					if ( $("#numeroErrorList").length ) {
						numeroError = $('#numeroErrorList').asNumber();
						mensajeTransaccion = $('#mensajeErrorList').val();
					}
					if(numeroError==0){
						$('#contenedorSimulador').show();
						var valorTransaccion = $('#transaccion').val();
						$('#numTransacSim').val(valorTransaccion);
						mensajeSis("Datos Guardados");
						$('#imprimirRep').hide(); // uuuu
					}
				} else {
					$('#contenedorSimulador').html("");
					$('#contenedorSimulador').show();
				}
				/****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
				if(numeroError!=0){
					$('#contenedorForma').unblock({fadeOut: 0,timeout:0});
					mensajeSisError(numeroError,mensajeTransaccion);
				}
				/**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
			});
		}

	}

 // valida que el monto del credito no sea mayor al saldo de la linea (creditos con linea)
	function consultaMonto(idControl){
		var jqNumMonto = eval("'#" + idControl + "'");
		var monto = $(jqNumMonto).asNumber();
		var saldo = $('#saldoLineaCred').asNumber();

		if(monto > saldo){
			mensajeSis("El monto del credito no puede ser mayor al Saldo de la linea.");
			$('#montoCredito').focus();
			$('#montoCredito').select();
		}

	}

	// consulta cuenta del cliente
	 function consultaCta(idControl) {
		var jqCta  = eval("'#" + idControl + "'");
		var numCta = $(jqCta).val();
		var CuentaAhoBeanCon = {
			'cuentaAhoID'	:numCta,
			'clienteID'		:$('#clienteID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCta != '' && !isNaN(numCta) && esTab){
			cuentasAhoServicio.consultaCuentasAho(3,CuentaAhoBeanCon,function(cuenta) {
						if(cuenta!=null){
							 var cte = $('#clienteID').asNumber();
							 var client = parseFloat(cuenta.clienteID);
							$('#monedaID').val(cuenta.monedaID);
							if(client != cte ){
								mensajeSis("La cuenta no corresponde con el Cliente");
								$('#cuentaID').focus();
								$('#cuentaID').val("");
							}

						}else{
							mensajeSis("No Existe la cuenta");

							$('#cuentaID').focus();
							$('#cuentaID').select();
						}
				});
		}
	}


	 // consulta la cuenta prinxipal del cliente
 function consultaCuentaPrincipal() {
		var cte = $('#clienteID').val();
			var CuentaAhoBeanCon = {
			'clienteID'		:cte
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(cte != '' && !isNaN(cte) && esTab){
			cuentasAhoServicio.consultaCuentasAho(14,CuentaAhoBeanCon,function(cuenta) {
						if(cuenta!=null){

							$('#cuentaID').val(cuenta.cuentaAhoID);
						}else{
							mensajeSis("El Cliente no tiene una Cuenta principal");

							deshabilitaBoton('graba');
							$('#cuentaID').focus();
							$('#cuentaID').select();
						}
				});
		}
	}

	//consulta el cliente de la solicitud de credito
	function consultaClienteSolici(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);

		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
						if(cliente!=null){
							$('#clienteID').val(cliente.numero);
							$('#nombreCliente').val(cliente.nombreCompleto);
							habilitaBoton('grabaSF');
							habilitaBoton('graba');
						consultaCuentaPrincipal();
						}else{
							mensajeSis("La Solicitud de Credito no tiene un Cliente Valido");
							deshabilitaBoton('grabaSF');
							deshabilitaBoton('graba');
							$('#solicitudCreditoID').focus();
							$('#solicitudCreditoID').select();
						}
				});
			}
		}

	// consulta de la tasa de credito
	function consultaTasaCredito(idControl) {

		var jqMonto = eval("'#" + idControl + "'");
		var monto = $(jqMonto).asNumber();
		var tipConTasas = 9;
		setTimeout("$('#cajaLista').hide();", 200);
		var credBeanCon = {
				'clienteID'			: $('#clienteID').val(),
				'sucursal' 			: parametroBean.sucursal,
				'producCreditoID'	: $('#producCreditoID').val(),
				'montoCredito'		: monto,
		};
		if(monto != '' && !isNaN(monto) && esTab){
			creditosServicio.consulta(tipConTasas,credBeanCon,function(tasas) {
				if(tasas!=null){

					$('#tasaFija').val(tasas.tasaFija).change();
					$('#tasaFija').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
				}else{
					$('#tasaFija').val('0').change();
				}
			});
		}
	}



	/*Metodo para consultar las condiciones del calendario segun el tipo de producto seleccionado*/
	function consultaCalendarioPorProducto(idControl,num) {

		inicializaCombos();
		var jqproducto  = eval("'#" + idControl + "'");
		var producto = $(jqproducto).val();
		var TipoConPrin = 1;
		var calendarioBeanCon = {
		'productoCreditoID' :producto
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if( producto != '' && !isNaN(producto) && esTab){
			calendarioProdServicio.consulta(TipoConPrin, calendarioBeanCon,function(calendario) {
				if(calendario!=null){
					inicializaCombos();
					deshabilitaParamCalendario();
					var tipoPago = calendario.tipoPagoCapital;
					var frecuencia = calendario.frecuencias;
					var plazos = calendario.plazoID;
					var tiposDispersion = calendario.tipoDispersion;
					$('#fechaInhabil').val(calendario.fecInHabTomar);
					if(calendario.fecInHabTomar=='S'){
						$('#fechaInhabil1').attr("checked","1") ;
						$('#fechaInhabil2').attr("checked",false) ;
						$('#fechaInhabil').val("S");
					}
					else{
						$('#fechaInhabil2').attr("checked","1") ;
						$('#fechaInhabil1').attr("checked",false) ;
						$('#fechaInhabil').val("A");
					}
					$('#ajusFecExiVen').val(calendario.ajusFecExigVenc);
					if(calendario.ajusFecExigVenc== AjusteFechaExigibleVenc.SI){
						$('#ajusFecExiVen1').attr("checked","1") ;
						$('#ajusFecExiVen2').attr("checked",false) ;
						$('#ajusFecExiVen').val(AjusteFechaExigibleVenc.SI);
					}else{
						$('#ajusFecExiVen1').attr("checked",false) ;
						$('#ajusFecExiVen2').attr("checked","1") ;
						$('#ajusFecExiVen').val(AjusteFechaExigibleVenc.NO);
					}
					$('#ajusFecUlVenAmo').val(calendario.ajusFecUlAmoVen);
					if(calendario.ajusFecUlAmoVen== AjustaUltimaFechaVenAmort.SI){
						$('#ajusFecUlVenAmo1').attr("checked","1") ;
						$('#ajusFecUlVenAmo2').attr("checked",false) ;
						$('#ajusFecUlVenAmo').val(AjustaUltimaFechaVenAmort.SI) ;
					}
					else{
						$('#ajusFecUlVenAmo1').attr("checked",false) ;
						$('#ajusFecUlVenAmo2').attr("checked","1") ;
						$('#ajusFecUlVenAmo').val(AjustaUltimaFechaVenAmort.NO) ;
					}
					if(calendario.iguaCalenIntCap ==IgualCalInteresCapital.SI){
						var permiteIgual = PermitePagosIguales.SI;
						$('#perIgual').val(permiteIgual);
					}
					if(calendario.iguaCalenIntCap == IgualCalInteresCapital.NO){
						var permiteIgual = PermitePagosIguales.NO;
						$('#perIgual').val(permiteIgual);
					}
					// consulta los combos dinamicos de acuerdo al producto
					consultaComboTipoPagoCap(tipoPago);
					consultaComboFrecuencias(frecuencia);
					consultaComboPlazos(plazos,num);
					consultaComboTipoDispersion(tiposDispersion);
					//variable global para mantener el dia de pago de capital por producto
					diaPagCapit = calendario.diaPagoCapital;

					$('#diaPagoProd').val(calendario.diaPagoCapital); // campo auxiliar para validar
					// VALIDA el dia de pago de capital
					switch (calendario.diaPagoCapital) {
						case "F": // SI ES FIN DE// MES
							habilitaControl('diaPagoCapital1');
							deshabilitaControl('diaPagoCapital2');
							$('#diaPagoCapital1').attr('checked',true);
							$('#diaPagoCapital2').attr('checked',false);
							$('#diaPagoCapital').val("F");
							deshabilitaControl('diaMesCapital');
							$('#diaMesCapital').val('');

							// si el tipo de pago es crecientes el dia de pago capital es = al de interes
							if ($('#tipoPagoCapital').val() == 'C' || ($('#tipoPagoCapital').val() == 'I' && $('#perIgual').val() == 'S')) {
								$('#diaPagoInteres1').attr('checked',true);
								$('#diaPagoInteres2').attr('checked',false);
								$('#diaPagoInteres').val("F");
								$('#diaMesInteres').val('');
								deshabilitaControl('diaMesInteres');
							}
							break;
						case "A": // SI ES POR ANIVERSARIO
							deshabilitaControl('diaPagoCapital1');
							habilitaControl('diaPagoCapital2');
							$('#diaPagoCapital2').attr('checked',true);
							$('#diaPagoCapital1').attr('checked',false);
							$('#diaMesCapital').val(diaSucursal);
							$('#diaPagoCapital').val("A");
							deshabilitaControl('diaMesCapital');
							if ($('#tipoPagoCapital').val() == 'C' || ($('#tipoPagoCapital').val() == 'I' && $('#perIgual').val() == 'S')) {
								deshabilitaControl('diaPagoInteres1');
								deshabilitaControl('diaPagoInteres2');
								$('#diaPagoInteres2').attr('checked',true);
								$('#diaPagoInteres1').attr('checked',false);
								$('#diaPagoInteres').val("A");
								$('#diaMesInteres').val(diaSucursal);
								deshabilitaControl('diaMesInteres');
							}
							break;
						case "D": // DIA DEL MES
							deshabilitaControl('diaPagoCapital1');
							deshabilitaControl('diaPagoCapital2');
							$('#diaPagoCapital2').attr('checked',true);
							$('#diaPagoCapital1').attr('checked',false);
							$('#diaPagoCapital').val("D");
							habilitaControl('diaMesCapital');
							$('#diaMesCapital').val(diaSucursal);
							if ($('#tipoPagoCapital').val() == 'C' || ($('#tipoPagoCapital').val() == 'I' && $('#perIgual').val() == 'S')) {
								deshabilitaControl('diaPagoInteres1');
								deshabilitaControl('diaPagoInteres2');
								$('#diaPagoInteres2').attr('checked',true);
								$('#diaPagoInteres1').attr('checked',false);
								$('#diaPagoInteres').val("D");
								$('#diaMesInteres').val(diaSucursal);
								habilitaControl('diaMesInteres');
							}
							break;
						case "I": // SI ES INDISTINTO
							$('#diaPagoCapital1').attr('checked',true);
							$('#diaPagoCapital2').attr('checked',false);
							$('#diaPagoCapital').val("F");
							habilitaControl('diaPagoCapital1');
							habilitaControl('diaPagoCapital2');
							$('#diaMesCapital').val('');
							habilitaControl('diaMesCapital');
							if ($('#tipoPagoCapital').val() == 'C' || $('#tipoPagoCapital').val() == 'I' && $('#perIgual').val() == 'S') {
								$('#diaPagoInteres1').attr('checked',true);
								$('#diaPagoInteres2').attr('checked',false);
								$('#diaPagoInteres').val("F");
								habilitaControl('diaPagoInteres1');
								habilitaControl('diaPagoInteres2');
								$('#diaMesInteres').val('');
								habilitaControl('diaMesInteres');
							}
							break;
						default:
							$('#diaPagoCapital1').attr('checked',true);
							$('#diaPagoCapital2').attr('checked',false);
							$('#diaPagoCapital').val("F");
							habilitaControl('diaPagoCapital1');
							habilitaControl('diaPagoCapital2');
							$('#diaMesCapital').val('');
							habilitaControl('diaMesCapital');
							if ($('#tipoPagoCapital').val() == 'C' || $('#tipoPagoCapital').val() == 'I' && $('#perIgual').val() == 'S') {
								$('#diaPagoInteres1').attr('checked',true);
								$('#diaPagoInteres2').attr('checked',false);
								$('#diaPagoInteres').val("F");
								habilitaControl('diaPagoInteres1');
								habilitaControl('diaPagoInteres2');
								$('#diaMesInteres').val('');
								habilitaControl('diaMesInteres');
							}
							break;
					}

				}else{
				}
			});
		}
	}

	/*
	 * Metodo para consultar las condiciones del calendario
	 * segun el tipo de producto seleccionado y sólo se ocupa
	 * cuando se trata de una consulta
	 */
	function consultaCalendarioPorProductoCredito(producto,
			valorTipoPagoCapital, valorFrecuenciaCap,
			valorFrecuenciaInt, valorPlazoID,
			valorTipoDispersion) {
		var TipoConPrin = 1;
		var calendarioBeanCon = {
				'productoCreditoID' : producto
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (producto != '' && !isNaN(producto)) {
			calendarioProdServicio.consulta(TipoConPrin,calendarioBeanCon,function(calendario) {
				if (calendario != null) {
					if (calendario.fecInHabTomar == 'S') {
						habilitaControl('fechaInhabil1');
						deshabilitaControl('fechaInhabil2');
					} else {
						deshabilitaControl('fechaInhabil1');
						habilitaControl('fechaInhabil2');
					}

					if (calendario.ajusFecExigVenc == 'S') {
						habilitaControl('ajusFecExiVen1');
						deshabilitaControl('ajusFecExiVen2');
					} else {
						deshabilitaControl('ajusFecExiVen1');
						habilitaControl('ajusFecExiVen2');
					}

					if (calendario.permCalenIrreg == 'S') {
						habilitaControl('calendIrregularCheck');
						deshabilitaControl('tipoPagoCapital');
						deshabilitaControl('frecuenciaInt');
						deshabilitaControl('frecuenciaCap');
					} else {
						if (calendario.permCalenIrreg == 'N' && $('#estatus').val() == 'I'
								&&  $('#solicitudCreditoID').asNumber()<= 0) {
							deshabilitaControl('calendIrregularCheck');
							deshabilitaControl('tipoPagoCapital');
							deshabilitaControl('frecuenciaInt');
							deshabilitaControl('frecuenciaCap');
						}
					}

					if (calendario.ajusFecUlAmoVen == 'S') {
						habilitaControl('ajusFecUlVenAmo1');
						deshabilitaControl('ajusFecUlVenAmo2');
					} else {
						deshabilitaControl('ajusFecUlVenAmo1');
						habilitaControl('ajusFecUlVenAmo2');
					}

					if (calendario.iguaCalenIntCap == 'S') {
						$('#perIgual').val("S");
						deshabilitaControl('frecuenciaInt');
					} else {
						if (calendario.iguaCalenIntCap == 'N') {
							$('#perIgual').val("N");
						}
					}

					// VALIDA el dia de pago de capital

					$('#diaPagoProd').val(calendario.diaPagoCapital); // campo auxiliar para validar
					switch (calendario.diaPagoCapital) {
					case "F": // SI ES FIN DE
						// MES
						habilitaControl('diaPagoCapital1');
						deshabilitaControl('diaPagoCapital2');
						deshabilitaControl('diaMesCapital');
						// si el tipo de pago es crecientes el dia de pago capital es = al  de interes
						if ($('#tipoPagoCapital').val() == 'C' || ($('#tipoPagoCapital').val() == 'I' && $('#perIgual').val() == 'S')) {
							deshabilitaControl('diaMesInteres');
						}
						break;
					case "A": // SI ES POR
						// ANIVERSARIO
						deshabilitaControl('diaPagoCapital1');
						habilitaControl('diaPagoCapital2');
						deshabilitaControl('diaMesCapital');
						if ($(
						'#tipoPagoCapital').val() == 'C'
							|| ($(
							'#tipoPagoCapital')
							.val() == 'I' && $(
							'#perIgual')
							.val() == 'S')) {
							deshabilitaControl('diaPagoInteres1');
							deshabilitaControl('diaPagoInteres2');
							deshabilitaControl('diaMesInteres');
						}
						break;
					case "D": // DIA DEL MES
						deshabilitaControl('diaPagoCapital1');
						deshabilitaControl('diaPagoCapital2');
						habilitaControl('diaMesCapital');
						if ($(
						'#tipoPagoCapital').val() == 'C'
							|| ($(
							'#tipoPagoCapital')
							.val() == 'I' && $(
							'#perIgual')
							.val() == 'S')) {
							deshabilitaControl('diaPagoInteres1');
							deshabilitaControl('diaPagoInteres2');
						}
						break;
					case "I": // SI ES
						// INDISTINTO
						habilitaControl('diaPagoCapital1');
						habilitaControl('diaPagoCapital2');
						habilitaControl('diaMesCapital');
						if ($(
						'#tipoPagoCapital').val() == 'C'
							|| $(
							'#tipoPagoCapital')
							.val() == 'I'
								&& $(
								'#perIgual')
								.val() == 'S') {
							habilitaControl('diaPagoInteres1');
							habilitaControl('diaPagoInteres2');
							habilitaControl('diaMesInteres');
						}
						break;
					default:
						habilitaControl('diaPagoCapital1');
					habilitaControl('diaPagoCapital2');
					habilitaControl('diaMesCapital');
					if ($(
					'#tipoPagoCapital')
					.val() == 'C'
						|| $(
						'#tipoPagoCapital').val() == 'I'
							&& $(
							'#perIgual')
							.val() == 'S') {
						habilitaControl('diaPagoInteres1');
						habilitaControl('diaPagoInteres2');
						habilitaControl('diaMesInteres');
					}
					break;
					}

					// se consultan los valores
					// que trae la solicitud
					consultaComboTipoPagoCapCredito(
							calendario.tipoPagoCapital,
							valorTipoPagoCapital); // se
					// llena
					// el
					// combo
					// de
					// tipos
					// de
					// pago
					// de
					// capital
					consultaComboFrecuenciasCredito(
							calendario.frecuencias,
							valorFrecuenciaCap,
							valorFrecuenciaInt); // se
					// llena el combo de Frecuencias, de interes y de capital
					consultaComboPlazosCredito( calendario.plazoID, valorPlazoID); // se llena el combo de plazos
					consultaComboTipoDispersionCredito( calendario.tipoDispersion, valorTipoDispersion); // se llena el combo de tipo de dispersion

				} else {
					mensajeSis("No existe un calendario de pagos para el producto de credito Indicado.");
				}
			});
		}
	}

	// funcion que llena el combo de plazos, de acuerdo al
	// producto
	// se usa cuando se consulta un credito
	function consultaComboPlazosCredito(varPlazos, plazoValor) {
		// se eliminan los tipos de pago que se tenian
		$('#plazoID').each(function() {
			$('#plazoID option').remove();
		});
		// se agrega la opcion por default
		$('#plazoID').append(
				new Option('SELECCIONAR', '', true, true));
		if (varPlazos != null) {
			var plazo = varPlazos.split(',');
			var tamanio = plazo.length;
			plazosCredServicio
			.listaCombo(
					3,
					function(plazoCreditoBean) {
						for ( var i = 0; i < tamanio; i++) {
							for ( var j = 0; j < plazoCreditoBean.length; j++) {
								if (plazo[i] == plazoCreditoBean[j].plazoID) {
									$('#plazoID')
									.append(
											new Option(
													plazoCreditoBean[j].descripcion,
													plazo[i],
													true,
													true));
									$('#plazoID').val(
											plazoValor).selected = true;
									break;
								}
							}
						}
					});
		}
	}


	// funcion que llena el combo tipo dispersion, de acuerdo al
	// producto
	// se usa cuando se consulta una solicitud de credito
	function consultaComboTipoDispersionCredito(
			tiposDispersion, valor) {
		if (tiposDispersion != null) {
			// se eliminan los tipos de pago que se tenian
			$('#tipoDispersion').each(function() {
				$('#tipoDispersion option').remove();
			});
			// se agrega la opcion por default
			$('#tipoDispersion').append(
					new Option('SELECCIONAR', '', true, true));

			var tipoDispersion = tiposDispersion.split(',');
			var tamanio = tipoDispersion.length;
			for ( var i = 0; i < tamanio; i++) {
				switch (tipoDispersion[i]) {
				case "S": // SPEI
					disperDescrip = 'SPEI';
					break;
				case "C":// CHEQUE
					disperDescrip = 'CHEQUE';
					break;
				case "O": // ORDEN DE PAGO
					disperDescrip = 'ORDEN DE PAGO';
					break;
				case "E": // EFECTIVO
					disperDescrip = 'EFECTIVO';
					break;
				default:
					disperDescrip = 'SPEI';
				}

				$('#tipoDispersion').append(
						new Option(disperDescrip,
								tipoDispersion[i], true, true));
				$('#tipoDispersion').val(valor).selected = true;
			}
		}
	}
	// funcion que llena el combo de tipo de pago capital, de
	// acuerdo al producto
	// se usa sólo cuando se trata de una consulta de solicitud
	function consultaComboTipoPagoCapCredito(tipoPago, valor) {
		if (tipoPago != null) {
			// se eliminan los tipos de pago que se tenian
			$('#tipoPagoCapital').each(function() {
				$('#tipoPagoCapital option').remove();
			});
			// se agrega la opcion por default
			$('#tipoPagoCapital').append(
					new Option('SELECCIONAR', '', true, true));

			var tpago = tipoPago.split(',');
			var tamanio = tpago.length;
			for ( var i = 0; i < tamanio; i++) {
				var pagDescrip = '';
				switch (tpago[i]) {
				case "C": // si el tipo de pago es CRECIENTES
					pagDescrip = 'CRECIENTES';
					break;
				case "I":// si el tipo de pago es IGUALES
					pagDescrip = 'IGUALES';
					break;
				case "L": // si el tipo de pago es LIBRES
					pagDescrip = 'LIBRES';
					break;
				default:
					pagDescrip = 'CRECIENTES';
				}
				$('#tipoPagoCapital').append(
						new Option(pagDescrip, tpago[i], true,
								true));
				$('#tipoPagoCapital').val(valor).selected = true; // se selecciona la opcion por defaul
			}
		}
	}

	// funcion que llena el combo de Frecuencias, de acuerdo al
	// producto
	// se utiliza sólo cuando se consulta una solicitud de
	// credito
	function consultaComboFrecuenciasCredito(frecuencia,
			valorCap, valorInt) {
		if (frecuencia != null) {
			// se eliminan los tipos de pago que se tenian
			$('#frecuenciaCap').each(function() {
				$('#frecuenciaCap option').remove();
			});
			// se agrega la opcion por default
			$('#frecuenciaCap').append(
					new Option('SELECCIONAR', '', true, true));

			// se eliminan los tipos de pago que se tenian
			$('#frecuenciaInt').each(function() {
				$('#frecuenciaInt option').remove();
			});
			// se agrega la opcion por default
			$('#frecuenciaInt').append(
					new Option('SELECCIONAR', '', true, true));

			var frec = frecuencia.split(',');
			var tamanio = frec.length;

			for ( var i = 0; i < tamanio; i++) {
				var frecDescrip = '';

				switch (frec[i]) {
				case "S": // SEMANAL
					frecDescrip = 'SEMANAL';
					break;
				case "D": // DECENAL
					frecDescrip = 'DECENAL';
					break;
				case "C":// CATORCENAL
					frecDescrip = 'CATORCENAL';
					break;
				case "Q": // QUINCENAL
					frecDescrip = 'QUINCENAL';
					break;
				case "M": // MENSUAL
					frecDescrip = 'MENSUAL';
					break;
				case "B": // BIMESTRAL
					frecDescrip = 'BIMESTRAL';
					break;
				case "T": // TRIMESTRAL
					frecDescrip = 'TRIMESTRAL';
					break;
				case "R": // TETRAMESTRAL
					frecDescrip = 'TETRAMESTRAL';
					break;
				case "E": // SEMESTRAL
					frecDescrip = 'SEMESTRAL';
					break;
				case "A": // ANUAL
					frecDescrip = 'ANUAL';
					break;
				case "P": // PERIODO
					frecDescrip = 'PERIODO';
					break;
				case "U": // PAGO UNICO
					frecDescrip = 'PAGO UNICO';
					break;
				case  "L": // PAGO LIBRE
					frecDescrip = 'LIBRE';
				break;
				default:
					frecDescrip = 'SEMANAL';
				}
				$('#frecuenciaCap').append(
						new Option(frecDescrip, frec[i], true,
								true));
				$('#frecuenciaInt').append(
						new Option(frecDescrip, frec[i], true,
								true));
				$('#frecuenciaCap').val(valorCap).selected = true;
				$('#frecuenciaInt').val(valorInt).selected = true;
			}
		}
	}

 	// funcion que llena el combo de tipo de pago capital, de acuerdo al producto
	function consultaComboTipoPagoCap(tipoPago) {
	if(tipoPago != null){
		var tpago= tipoPago.split(',');
		var tamanio = tpago.length;

		for (var i=0;i<tamanio;i++) {
			var pag = tpago[i];
			var pagDescrip = '';

			if(pag == TipoPagoCapital.Crecientes){
				pagDescrip = 'CRECIENTES';
			}

			if(pag == TipoPagoCapital.Iguales){
				pagDescrip = 'IGUALES';
			}

			if(pag == TipoPagoCapital.Libres){
				pagDescrip = 'LIBRES';
			}

			$('#tipoPagoCapital').append(new Option(pagDescrip, pag, true, true));

		}
	$('#tipoPagoCapital').val('').selected = true;
	}
	}

	// consulta el tipo de pago
	function consultaTipoPagoCap(tipoPago) {
		var tpago = tipoPago;
		$('#tipoPagoCapital').val(tpago).select();
		if(tpago == TipoPagoCapital.Crecientes){
			deshabilitaControl('frecuenciaInt');
		}
	}

	// funcion que llena el combo de Frecuencias, de acuerdo al producto
	// se utiliza sólo cuando se da de alta una solicitud de credito nueva.
	function consultaComboFrecuencias(frecuencia) {
		if(frecuencia != null){
			// se eliminan los tipos de pago que se tenian
			$('#frecuenciaCap').each(function(){
				$('#frecuenciaCap option').remove();
			});
			// se agrega la opcion por default
			$('#frecuenciaCap').append(new Option('SELECCIONAR', '', true, true));

			// se eliminan los tipos de pago que se tenian
			$('#frecuenciaInt').each(function(){
				$('#frecuenciaInt option').remove();
			});
			// se agrega la opcion por default
			$('#frecuenciaInt').append(new Option('SELECCIONAR', '', true, true));

			var frec= frecuencia.split(',');
			var tamanio = frec.length;

			for (var i=0;i<tamanio;i++) {
				var frecDescrip = '';

				switch(frec[i]){
					case "S": // SEMANAL
						frecDescrip = 'SEMANAL';
					break;
					case "D": // DECENAL
					frecDescrip = 'DECENAL';
					break;
					case "C" :// CATORCENAL
						frecDescrip = 'CATORCENAL';
					break;
					case  "Q": // QUINCENAL
						frecDescrip = 'QUINCENAL';
					break;
					case  "M": // MENSUAL
						frecDescrip = 'MENSUAL';
					break;
					case  "B": // BIMESTRAL
						frecDescrip = 'BIMESTRAL';
					break;
					case  "T": // TRIMESTRAL
						frecDescrip = 'TRIMESTRAL';
					break;
					case  "R": // TETRAMESTRAL
						frecDescrip = 'TETRAMESTRAL';
					break;
					case  "E": // SEMESTRAL
						frecDescrip = 'SEMESTRAL';
					break;
					case  "A": // ANUAL
						frecDescrip = 'ANUAL';
					break;
					case  "P": // PERIODO
						frecDescrip = 'PERIODO';
					break;
					case  "U": // PAGO UNICO
						frecDescrip = 'PAGO UNICO';
					break;
					default:
						frecDescrip = 'SEMANAL';
				}
				$('#frecuenciaCap').append(new Option(frecDescrip,frec[i], true, true));
				$('#frecuenciaInt').append(new Option(frecDescrip,frec[i], true, true));
				$('#frecuenciaCap').val('').selected = true;
				$('#frecuenciaInt').val('').selected = true;
			}
		}
	}
	// consulta la frecuencia de capital
	function consultaFrecuenciaCap(frecuencia) {
		var fre= frecuencia;
		$('#frecuenciaCap').val(fre).selected = true;
	}

		// consulta la frecuencia de interes
	function consultaFrecuenciaInt(frecuencia) {
		var fre= frecuencia;
		$('#frecuenciaInt').val(fre).select();
	}

	// funcion que llena el combo de plazos, de acuerdo al producto
	function consultaComboPlazos(plazos,num) {
		if(plazos != null){
			var plazo= plazos.split(',');
			var tamanio = plazo.length;
			plazosCredServicio.listaCombo(3, function(plazoCreditoBean){
				for (var i=0;i<tamanio;i++) {
					for (var j = 0; j < plazoCreditoBean.length; j++){
						if(plazo[i]==plazoCreditoBean[j].plazoID){
							$('#plazoID').append(new Option(plazoCreditoBean[j].descripcion,plazo[i],  true, true));
							break;

						}
					}
				}$('#plazoID').val(num).selected = true;
			});
		}
	}

	    // funcion que llena el combo tipo dispersion, de acuerdo al producto
	function consultaComboTipoDispersion(tiposDispersion) {
		if(tiposDispersion != null){
		var tipoDispersion= tiposDispersion.split(',');
		var tamanio = tipoDispersion.length;
		for (var i=0;i<tamanio;i++) {
			var tipoDisper = tipoDispersion[i];
			var disperDescrip = '';

			if(tipoDisper == 'S'){
				disperDescrip = 'SPEI';
			}

			if(tipoDisper == 'C'){
				disperDescrip = 'CHEQUE';
			}

			if(tipoDisper == 'O'){
				disperDescrip = 'ORDEN DE PAGO';
			}
			if(tipoDisper == 'E'){
				disperDescrip = 'EFECTIVO';
			}


			$('#tipoDispersion').append(new Option(disperDescrip, tipoDisper, true, true));

		}
		}
	$('#tipoDispersion').val('0').selected = true;

	}

		// consulta el tipo de dispersion
	function consultaTipoDispersion(tipoDispersion) {
		var tipoDisper= tipoDispersion;
		$('#tipoDispersion').val(tipoDisper).select();
	}

	// funcion que deshabilita parametros calendario de producto de credito
	function deshabilitaParamCalendario(){
		deshabilitaControl('fechaInhabil1');
		deshabilitaControl('fechaInhabil2');
		deshabilitaControl('ajusFecExiVen1');
		deshabilitaControl('ajusFecExiVen2');
		deshabilitaControl('ajusFecUlVenAmo1');
		deshabilitaControl('ajusFecUlVenAmo2');
		//deshabilitaControl('fechaVencimien');

	}

	// consulta de la fecha de vencimiento en base al plazo
	function consultaFechaVencimiento(idControl){
		var jqPlazo  = eval("'#" + idControl + "'");
		var plazo = $(jqPlazo).val();
		var tipoCon=3;
		var PlazoBeanCon = {
				'plazoID' :plazo,
				'fechaActual' : $('#fechaInicio').val(),
				'frecuenciaCap' : $('#frecuenciaCap').val()
		};
		if(plazo == ''){
			$('#fechaVencimien').val("");
		}else{
			plazosCredServicio.consulta(tipoCon,PlazoBeanCon,function(plazos){
				if(plazos!=null){
					//calculaNodeDias();
					$('#fechaVencimien').val(plazos.fechaActual);
					if($('#frecuenciaCap').val()!= "U"){
						$('#numAmortizacion').val(plazos.numCuotas);
						if($('#tipoPagoCapital').val() == 'C'){
							$('#numAmortInteres').val(plazos.numCuotas);
							NumCuotasInt = plazos.numCuotas; // se utiliza para saber cuando se agrega o quita una cuota
						}else{
							$('#numAmortizacion').val(plazos.numCuotas);
							if($('#tipoPagoCapital').val() == "I" || $('#perIgual').val() == "S"){
								$('#numAmortInteres').val(plazos.numCuotas);
								NumCuotasInt = plazos.numCuotas; // se utiliza para saber cuando se agrega o quita una cuota
							}else{
								consultaCuotasInteres('plazoID');
							}
						}
						NumCuotas = plazos.numCuotas; // se utiliza para saber cuando se agrega o quita una cuota
						// calculo de numero de dias
						calculaNodeDias(plazos.fechaActual);
					}else{
						$('#numAmortizacion').val("1");
						//$('#numAmortInteres').val("1");
						NumCuotas = 1; // se utiliza para saber cuando se agrega o quita una cuota
						//NumCuotasInt = 1; // se utiliza para saber cuando se agrega o quita una cuota
						calculaNodeDias(plazos.fechaActual);
					}
					fechaVencimientoInicial = plazos.fechaActual;
				}
			});
		}
	}



	// consulta del destino de credito
	function consultaDestinoCredito(idControl) {
		var Comercial='C';
		var Consumo ='O';

		var jqDestino  = eval("'#" + idControl + "'");
		var DestCred = $(jqDestino).val();
		var tipoCon=3;
		var DestCredBeanCon = {
			'producCreditoID' : $('#producCreditoID').val(),
  			'destinoCreID':DestCred
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(DestCred != '' && !isNaN(DestCred) && esTab){
				destinosCredServicio.consulta(tipoCon ,DestCredBeanCon,function(destinos) {
					if(destinos!=null){
						$('#descripDestino').val(destinos.descripcion);
						$('#descripDestinoFR').val(destinos.desCredFR);
						$('#descripDestinoFOMUR').val(destinos.desCredFOMUR);
						$('#destinCredFRID').val(destinos.destinCredFRID);
						$('#destinCredFOMURID').val(destinos.destinCredFOMURID);
						$('#clasiDestinCred').val(destinos.clasificacion);


						if(destinos.clasificacion==Comercial){
							$('#clasificacionDestin1').attr("checked",true);
							$('#clasificacionDestin2').attr("checked",false);
							$('#clasificacionDestin3').attr("checked",false);

						}else if(destinos.clasificacion==Consumo){
							$('#clasificacionDestin1').attr("checked",false);
							$('#clasificacionDestin2').attr("checked",true);
							$('#clasificacionDestin3').attr("checked",false);

						}else{
							$('#clasificacionDestin1').attr("checked",false);
							$('#clasificacionDestin2').attr("checked",false);
							$('#clasificacionDestin3').attr("checked",true);
						}



					}else{
						mensajeSis("No Existe el Destino de Credito");
						$('#destinoCreID').focus();
						$('#destinoCreID').select();
					}
			});
			}
	}



	// -----------consulta el destino de credito metodo se llama cuando se
	//				consulta la solicitud ya que para consultar se consulta el
	//				campo de  Clasificacion que se encuentra en la tabla de solictud de credito o credito . y no la de
	//				la tabla de DESTINOSCREDITO

	function consultaDestinoCreditoSolicitud(idControl) {
		var jqDestino  = eval("'#" + idControl + "'");
		var DestCred = $(jqDestino).val();
		var tipoCon=2;
		var DestCredBeanCon = {
  			'destinoCreID':DestCred
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(DestCred != '' && !isNaN(DestCred) && esTab){
				destinosCredServicio.consulta(tipoCon ,DestCredBeanCon,function(destinos) {
					if(destinos!=null){
						$('#descripDestino').val(destinos.descripcion);
						$('#descripDestinoFR').val(destinos.desCredFR);
						$('#descripDestinoFOMUR').val(destinos.desCredFOMUR);
						$('#destinCredFRID').val(destinos.destinCredFRID);
						$('#destinCredFOMURID').val(destinos.destinCredFOMURID);

					}else{
						mensajeSis("No Existe el Destino de Credito");
						$('#destinoCreID').focus();
						$('#destinoCreID').select();
					}
			});
			}
	}




// funcion para deshabilitar los controles de la solicitud de credito (cuando son creditos por solicitud)
	function deshabilitaControlesSolicitud(){
		deshabilitaControl('monedaID');


		deshabilitaControl('lineaCreditoID');
		deshabilitaControl('clienteID');
		deshabilitaControl('cuentaID');
		deshabilitaControl('destinoCreID');
		deshabilitaControl('producCreditoID');
		deshabilitaControl('montoCredito');

		deshabilitaControl('plazoID');
		deshabilitaControl('tipoDispersion');
		deshabilitaControl('tipoPagoCapital');
		deshabilitaControl('frecuenciaCap');
		deshabilitaControl('frecuenciaInt');
		deshabilitaControl('diaPagoCapital1');
		deshabilitaControl('diaPagoCapital2');
		deshabilitaControl('diaPagoInteres1');
		deshabilitaControl('diaPagoInteres2');
		deshabilitaControl('diaMesInteres');
		deshabilitaControl('diaMesCapital');
		deshabilitaControl('tasaFija');
		deshabilitaControl('numAmortizacion');
	}

	// funcion para habilitar los controles de la solicitud de credito (cuando son creditos por solicitud)
	function habilitaControlesSolicitud(){
		habilitaControl('lineaCreditoID');
		habilitaControl('clienteID');
		habilitaControl('cuentaID');
		habilitaControl('destinoCreID');
		habilitaControl('producCreditoID');
		habilitaControl('montoCredito');
		habilitaControl('plazoID');
		habilitaControl('tipoDispersion');
		habilitaControl('tipoPagoCapital');
		habilitaControl('frecuenciaCap');
		habilitaControl('frecuenciaInt');
		habilitaControl('diaPagoCapital1');
		habilitaControl('diaPagoCapital2');
		habilitaControl('diaPagoInteres1');
		habilitaControl('diaPagoInteres2');
		habilitaControl('diaMesInteres');
		habilitaControl('diaMesCapital');
		habilitaControl('numAmortizacion');
	}

	// funcion para habilitar los controles cuando es un alta de credito
	function habilitaControlesAlta(){
		habilitaControl('monedaID');


		//habilitaControl('fechaInicio');
		habilitaControl('clienteID');
		habilitaControl('cuentaID');
		habilitaControl('producCreditoID');
		habilitaControl('destinoCreID');
		habilitaControl('calcInteresID');
		habilitaControl('fechaInhabil1');
		habilitaControl('fechaInhabil2');
		habilitaControl('tasaFija');
		habilitaControl('frecuenciaCap');
		habilitaControl('frecuenciaInt');
		habilitaControl('montoCredito');
		habilitaControl('ajusFecExiVen1');
		habilitaControl('ajusFecExiVen2');
		habilitaControl('ajusFecUlVenAmo1');
		habilitaControl('ajusFecUlVenAmo2');
		habilitaControl('montoCuota');
		habilitaControl('numAmortInteres');
		habilitaControl('numAmortizacion');
		habilitaControl('tasaFija');
		habilitaControl('tasaFija');
		$('#numAmortInteres').val($('#numAmortInteres').asNumber());
		$('#numAmortizacion').val($('#numAmortizacion').asNumber());
	}

	// funcion para habilitar los controles cuando es un alta de credito
	function habilitaControlesDarAlta(){
		habilitaControl('tipoPagoCapital');
		habilitaControl('clienteID');
		habilitaControl('cuentaID');
		habilitaControl('producCreditoID');
		habilitaControl('destinoCreID');

		habilitaControl('frecuenciaCap');
		habilitaControl('frecuenciaInt');
		habilitaControl('montoCredito');
		habilitaControl('tipoDispersion');
		habilitaControl('plazoID');

		habilitaControl('numAmortizacion');
	}

	// consulta la fecha de vencimiento si se cambia el valor de la cuota de capital cambia
	function consultaFechaVencimientoCuotas(idControl){
		var jqPlazo  = eval("'#" + idControl + "'");
		var plazo = $(jqPlazo).val();
		var tipoCon=4;

		var PlazoBeanCon = {
			'frecuenciaCap'		: $('#frecuenciaCap').val(),
			'numCuotas'			: $('#numAmortizacion').val(),
			'periodicidadCap'	: $('#periodicidadCap').val(),
			'fechaActual'		: $('#fechaInicio').val()
		};
			if(plazo == '0'){
				$('#fechaVencimien').val("");
				calculaNodeDias();
			}else{
				plazosCredServicio.consulta(tipoCon,PlazoBeanCon,function(plazos) {
					if(plazos!=null){
						calculaNodeDias();
						$('#fechaVencimien').val(plazos.fechaActual);
					}
				});
			}
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
					$('#numAmortInteres').val(plazos.numCuotas);
					NumCuotasInt= parseInt(plazos.numCuotas);
					}
				});
			}
	}

	// funcion para llenar el combo de CreditoOrigen
	// muestra en un combo los creditos que correspondan al cliente
	// y que tengan un estatus vencido o vigente
	function consultaCreditoOrigen() {
		dwr.util.removeAllOptions('relacionado');
		dwr.util.addOptions('relacionado', {"":'SELECCIONAR'});
		var creditoBeanCon = {
  			'clienteID':$('#clienteID').val()
		};
		creditosServicio.listaCombo(9,creditoBeanCon, function(creditosVigVen){
			dwr.util.addOptions('relacionado', creditosVigVen, 'creditoID', 'creditoProducto');
		});
	}

	// consulta el credito relacionado de un credito ya reestructurado
	function consultaCreditoOrigenCreado(varRela) {
		dwr.util.removeAllOptions('relacionado');
		dwr.util.addOptions('relacionado', {"":'SELECCIONAR'});
		var creditoBeanCon = {
  			'clienteID':$('#clienteID').val()
		};
		creditosServicio.listaCombo(9,creditoBeanCon, function(creditosVigVen){
			dwr.util.addOptions('relacionado', creditosVigVen, 'creditoID', 'creditoProducto');
			$('#relacionado').val(varRela).selected = true;
			consultaCreditoRelacionado('relacionado');
		});

	}


	// Limpiar cajas credito a reestructurar
	function limpiaCreditoRees(){
		$('#relacionado').val("");
		$('#producCreditoIDOrigen').val("");
		$('#nombreProdOrigen').val("");
		$('#estatusOrigen').val("");
		$('#diasAtrasoOrigen').val("");
		$('#fechaInicioOrigen').val("");
		$('#fechaVenOrigen').val("");
		$('#totalAdeudoOrigen').val("");
		$('#totalExigibleOrigen').val("");

		dwr.util.removeAllOptions('relacionado');
		dwr.util.addOptions('relacionado', {"":'SELECCIONAR'});
	}

	// funcion para consultar si ya existe el credito indicado
	function consultaExisteCredito(idControl) {
		var jqRelacionado = eval("'#" + idControl + "'");
		var numCre = $(jqRelacionado).val();
		var tipConExiste = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		var reescre = {
 				'creditoOrigenID':numCre,
 		};
		if(numCre != '' && !isNaN(numCre) && esTab){
			reestrucCreditoServicio.consulta(tipConExiste,reescre,function(reescred) {
				if(reescred!=null){
					if(reescred.creditoDestinoID == $('#creditoID').val()){

					}else{
						if($('#creditoID').val() == 0){
							if(reescred.creditoOrigenID != 0){
								mensajeSis("El Crédito ya ha sido Reestructurado.");
								deshabilitaBoton('modifica', 'submit');
		   						deshabilitaBoton('agrega', 'submit');
		   						$('#relacionado').focus();
							}
						}
					}
				}
			});
		}
		agregaFormatoControles('formaGenerica');
 		$('#IVAComApertura').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
 		$('#montoCredito').formatCurrency({positiveFormat: '%n', negativeFormat: '%n', roundToDecimalPlace: 2});
	}

	// funcion para eventos cuando se selecciona dia de pago de interes
	//por aniversario o fin de mes, dependiendo de la frecuencia.
	function validarEventoFrecuencia() {
		switch($('#tipoPagoCapital').val()){
			case "C": // si el tipo de pago es CRECIENTES
				$('#frecuenciaInt').val($('#frecuenciaCap').val()).selected = true;
				deshabilitarCalendarioPagosInteres();
				$('#diaPagoInteres').val($('#diaPagoProd').val()) ;
				$('#diaPagoCapital').val($('#diaPagoProd').val()) ;
				if( $('#frecuenciaCap').val() == 'S' || $('#frecuenciaCap').val() == 'C'|| $('#frecuenciaCap').val() == 'Q' ||
						$('#frecuenciaCap').val() == 'A' ){
					if($('#diaPagoInteres1').is(':checked')){
						$('#diaPagoCapital1').attr("checked",true);
						$('#diaPagoCapital2').attr("checked",false);
						$('#diaPagoInteres1').attr('checked',true);
						$('#diaPagoInteres2').attr('checked',false);
						$('#diaMesInteres').val('');
						$('#diaMesCapital').val('');
					}else{
						$('#diaPagoInteres2').attr('checked',true);
						$('#diaPagoCapital2').attr("checked",true);
						$('#diaPagoInteres1').attr('checked',false);
						$('#diaPagoCapital1').attr("checked",false);
						$('#diaMesInteres').val(diaSucursal);
						$('#diaMesCapital').val(diaSucursal);
					}

					deshabilitaControl('diaPagoCapital1');
					deshabilitaControl('diaPagoCapital2');
					deshabilitaControl('frecuenciaInt');
					deshabilitaControl('diaPagoInteres1');
					deshabilitaControl('diaPagoInteres2');
					deshabilitaControl('diaMesInteres');
					deshabilitaControl('diaMesCapital');
					deshabilitaControl('periodicidadCap');
					deshabilitaControl('periodicidadInt');
					habilitaControl('numAmortizacion');
					deshabilitaControl('numAmortInteres');
				}else{
					if($('#frecuenciaCap').val() == 'P' ){
						if($('#diaPagoInteres1').is(':checked')){
							$('#diaPagoInteres1').attr('checked',true);
							$('#diaPagoInteres2').attr('checked',false);
							$('#diaPagoCapital1').attr("checked",true);
							$('#diaPagoCapital2').attr("checked",false);
							$('#diaMesInteres').val('');
							$('#diaMesCapital').val('');
						}else{
							$('#diaPagoInteres1').attr('checked',false);
							$('#diaPagoInteres2').attr('checked',true);
							$('#diaPagoCapital1').attr("checked",false);
							$('#diaPagoCapital2').attr("checked",true);
							$('#diaMesInteres').val(diaSucursal);
							$('#diaMesCapital').val(diaSucursal);
						}
						deshabilitaControl('diaPagoInteres1');
						deshabilitaControl('diaPagoInteres2');
						deshabilitaControl('periodicidadInt');
						habilitaControl('periodicidadCap');
						habilitaControl('numAmortizacion');
						deshabilitaControl('numAmortInteres');
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
							habilitaControl('numAmortizacion');
							deshabilitaControl('numAmortInteres');
							if($('#diaPagoCapital1').is(':checked')){
								$('#diaPagoCapital2').attr("checked",false) ;
								$('#diaMesCapital').val("");
							}else{
								if($('#diaPagoCapital2').is(':checked')){
									$('#diaPagoCapital1').attr("checked",false) ;
									$('#diaMesCapital').val(diaSucursal);
								}
							}
							if($('#diaPagoInteres1').is(':checked')){
								$('#diaPagoInteres2').attr("checked",false) ;
								$('#diaMesInteres').val("");
							}else{
								if($('#diaPagoInteres2').is(':checked')){
									$('#diaPagoInteres1').attr("checked",false) ;
									$('#diaMesInteres').val(diaSucursal);
								}
							}
						}
					}
				}
			break;
			case "I":
				$('#diaPagoInteres').val($('#diaPagoProd').val()) ;
				$('#diaPagoCapital').val($('#diaPagoProd').val()) ;
				// si el tipo de pago es UNICO se deshabilitan las
				// cajas para indicar numero de cuotas
				if ($('#frecuenciaCap').val() == 'U') {
					if ($('#tipoPagoCapital').val() != "I") {
						mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
					}
					$('#numAmortizacion').val("1");
					deshabilitaControl('numAmortizacion');
					$('#periodicidadCap').val($('#noDias').val());
					if($('#perIgual').val() == 'S'){
						$('#numAmortInteres').val("1");
						deshabilitaControl('numAmortInteres');
						$('#periodicidadInt').val($('#noDias').val());
						deshabilitarCalendarioPagosInteres();
						$('#frecuenciaInt').val('U').selected = true;
					}
				} else {

					habilitaControl('numAmortizacion');
					habilitaControl('numAmortInteres');
					if ($('#perIgual').val() != 'S') {
						habilitarCalendarioPagosInteres();
					} else {
						$('#frecuenciaInt').val(
								$('#frecuenciaCap').val()).selected = true;
						if ($('#diaPagoCapital1').is(':checked')) {
							$('#diaPagoCapital2').attr("checked",false);
							$('#diaMesCapital').val("");
						} else {
							if ($('#diaPagoCapital2').is(':checked')) {
								$('#diaPagoCapital1').attr("checked", false);
								$('#diaMesCapital').val(diaSucursal);
							}
						}
						if ($('#diaPagoInteres1').is(':checked')) {
							$('#diaPagoInteres2').attr("checked",false);
							$('#diaMesInteres').val("");
						} else {
							if ($('#diaPagoInteres2').is(':checked')) {
								$('#diaPagoInteres1').attr("checked", false);
								$('#diaMesInteres').val(diaSucursal);
							}
						}
					}

					if ($('#frecuenciaInt').val() == 'S'
						|| $('#frecuenciaInt').val() == 'C'
							|| $('#frecuenciaInt').val() == 'Q'
								|| $('#frecuenciaInt').val() == 'A'
									|| $('#frecuenciaInt').val() == 'P') {
						deshabilitaControl('diaPagoInteres1');
						deshabilitaControl('diaPagoInteres2');
						deshabilitaControl('diaMesInteres');
						deshabilitaControl('periodicidadInt');

					} else {
						if ($('#frecuenciaInt').val() == 'P') {
							if ($('#perIgual').val() != 'S') {
								habilitaControl('periodicidadInt');
							}
						} else {
							if ($('#frecuenciaCap').val() == 'U') {
								if ($('#tipoPagoCapital').val() != "I") {
									mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
								}
								$('#numAmortizacion').val("1");
								deshabilitaControl('numAmortizacion');
								$('#periodicidadCap').val($('#noDias').val());
								if($('#perIgual').val() == 'S'){
									$('#numAmortInteres').val("1");
									deshabilitaControl('numAmortInteres');
									$('#periodicidadInt').val($('#noDias').val());
									deshabilitarCalendarioPagosInteres();
									$('#frecuenciaInt').val('U').selected = true;
								}
							} else {
								if ($('#perIgual').val() == 'S') {
									$('#frecuenciaInt').val($('#frecuenciaCap').val()).selected = true;
								}
							}
						}
					}

					if ($('#frecuenciaCap').val() == 'S'
						|| $('#frecuenciaCap').val() == 'C'
							|| $('#frecuenciaCap').val() == 'Q'
								|| $('#frecuenciaCap').val() == 'A') {
						deshabilitaControl('diaPagoCapital1');
						deshabilitaControl('diaPagoCapital2');
						deshabilitaControl('diaMesCapital');
						deshabilitaControl('periodicidadCap');
					} else {
						if ($('#frecuenciaCap').val() == 'P') {
							habilitaControl('periodicidadCap');
							deshabilitaControl('diaPagoCapital1');
							deshabilitaControl('diaPagoCapital2');
						} else {
							if ($('#frecuenciaCap').val() == 'U') {
								if ($('#tipoPagoCapital').val() != "I") {
									mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
								}
								$('#numAmortizacion').val("1");
								deshabilitaControl('numAmortizacion');
								$('#periodicidadCap').val($('#noDias').val());
								if($('#perIgual').val() == 'S'){
									$('#numAmortInteres').val("1");
									deshabilitaControl('numAmortInteres');
									$('#periodicidadInt').val($('#noDias').val());
									deshabilitarCalendarioPagosInteres();
									$('#frecuenciaInt').val('U').selected = true;
								}
							} else {
								if ($('#diaPagoCapital1').is(
								':checked')) {
									$('#diaPagoCapital2').attr("checked", false);
									$('#diaMesCapital').val(diaSucursal);
								} else {
									if ($('#diaPagoCapital2').is(':checked')) {
										$('#diaPagoCapital1').attr("checked", false);
										$('#diaMesCapital').val(diaSucursal);
									}
								}
							}
						}
					}
				}
				break;
			case "L":
				$('#diaPagoInteres').val($('#diaPagoProd').val()) ;
				$('#diaPagoCapital').val($('#diaPagoProd').val()) ;
				// si el tipo de pago es UNICO se deshabilitan las
				// cajas para indicar numero de cuotas
				if ($('#frecuenciaCap').val() == 'U') {
					if ($('#tipoPagoCapital').val() != "I") {
						mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
					}
					$('#numAmortizacion').val("1");
					deshabilitaControl('numAmortizacion');
					$('#periodicidadCap').val($('#noDias').val());
					if($('#perIgual').val() == 'S'){
						$('#numAmortInteres').val("1");
						deshabilitaControl('numAmortInteres');
						$('#periodicidadInt').val($('#noDias').val());
						deshabilitarCalendarioPagosInteres();
						$('#frecuenciaInt').val('U').selected = true;
					}
				}else {

					habilitaControl('numAmortizacion');
					habilitaControl('numAmortInteres');
					if ($('#perIgual').val() != 'S') {
						habilitarCalendarioPagosInteres();
					} else {
						$('#frecuenciaInt').val(
								$('#frecuenciaCap').val()).selected = true;
						if ($('#diaPagoCapital1').is(':checked')) {
							$('#diaPagoCapital2').attr("checked",
									false);
							$('#diaPagoCapital').val("F");
							$('#diaMesCapital').val("");
						} else {
							if ($('#diaPagoCapital2')
									.is(':checked')) {
								$('#diaPagoCapital').val("A");
								$('#diaPagoCapital1').attr(
										"checked", false);
								$('#diaMesCapital')
								.val(diaSucursal);
							}
						}
						if ($('#diaPagoInteres1').is(':checked')) {
							$('#diaPagoInteres2').attr("checked",false);
							$('#diaMesInteres').val("");
						} else {
							if ($('#diaPagoInteres2').is(':checked')) {
								$('#diaPagoInteres1').attr("checked", false);
								$('#diaMesInteres').val(diaSucursal);
							}
						}
					}

					if ($('#frecuenciaInt').val() == 'S'
						|| $('#frecuenciaInt').val() == 'C'
							|| $('#frecuenciaInt').val() == 'Q'
								|| $('#frecuenciaInt').val() == 'A'
									|| $('#frecuenciaInt').val() == 'P') {
						deshabilitaControl('diaPagoInteres1');
						deshabilitaControl('diaPagoInteres2');
						deshabilitaControl('diaMesInteres');
						deshabilitaControl('periodicidadInt');

					} else {
						if ($('#frecuenciaInt').val() == 'P') {
							if ($('#perIgual').val() != 'S') {
								habilitaControl('periodicidadInt');
							}
						} else {
							if ($('#frecuenciaCap').val() == 'U') {
								if ($('#tipoPagoCapital').val() != "I") {
									mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
								}
								$('#numAmortizacion').val("1");
								deshabilitaControl('numAmortizacion');
								$('#periodicidadCap').val($('#noDias').val());
								if($('#perIgual').val() == 'S'){
									$('#numAmortInteres').val("1");
									deshabilitaControl('numAmortInteres');
									$('#periodicidadInt').val($('#noDias').val());
									deshabilitarCalendarioPagosInteres();
									$('#frecuenciaInt').val('U').selected = true;
								}
							}else {
								if ($('#perIgual').val() == 'S') {
									$('#frecuenciaInt').val(
											$('#frecuenciaCap')
											.val()).selected = true;
								}
							}
						}
					}

					if ($('#frecuenciaCap').val() == 'S'
						|| $('#frecuenciaCap').val() == 'C'
							|| $('#frecuenciaCap').val() == 'Q'
								|| $('#frecuenciaCap').val() == 'A') {
						deshabilitaControl('diaPagoCapital1');
						deshabilitaControl('diaPagoCapital2');
						deshabilitaControl('diaMesCapital');
						deshabilitaControl('periodicidadCap');
					} else {
						if ($('#frecuenciaCap').val() == 'P') {
							habilitaControl('periodicidadCap');
							deshabilitaControl('diaPagoCapital1');
							deshabilitaControl('diaPagoCapital2');
						} else {
							if ($('#frecuenciaCap').val() == 'U') {
								if ($('#tipoPagoCapital').val() != "I") {
									mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
								}
								$('#numAmortizacion').val("1");
								deshabilitaControl('numAmortizacion');
								$('#periodicidadCap').val($('#noDias').val());
								if($('#perIgual').val() == 'S'){
									$('#numAmortInteres').val("1");
									deshabilitaControl('numAmortInteres');
									$('#periodicidadInt').val($('#noDias').val());
									deshabilitarCalendarioPagosInteres();
									$('#frecuenciaInt').val('U').selected = true;
								}
							}else {
								if ($('#diaPagoCapital1').is(
								':checked')) {
									$('#diaPagoCapital2').attr(
											"checked", false);
									$('#diaPagoCapital').val("F");
									$('#diaMesCapital').val(
											diaSucursal);
								} else {
									if ($('#diaPagoCapital2').is(
									':checked')) {
										$('#diaPagoCapital').val(
										"A");
										$('#diaPagoCapital1').attr(
												"checked", false);
										$('#diaMesCapital').val(
												diaSucursal);
									}
								}
							}
						}
					}
				}
				break;
			}
		} // FIN validarEventoFrecuencia()


	// asigna en dias la periodicidad, dependiendo de la frecuencia seleccionada
	function validaPeriodicidad() {
		switch($('#frecuenciaCap').val()){
			case "S": // SI ES SEMANAL
				$('#periodicidadCap').val('7');
				break;
			case "D": // SI ES DECENAL
				$('#periodicidadCap').val('10');
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
			case "D": // SI ES DECENAL
				$('#periodicidadCap').val('10');
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

	function validaDatosRequeridos(){
		habilitaControl('montoCuota');
		habilitaControlesSolicitud();
		habilitaControl('tipoPagoCapital');
		var fechaAplicacion = parametroBean.fechaAplicacion;
		var fechaIniForm = $('#fechaInicio').val();
		var fechaVenForm = $('#fechaVencimien').val();
		if(fechaIniForm < fechaAplicacion){
			mensajeSis("Fecha es menor a la del Sistema ");
			deshabilitaControlesSolicitud();
			deshabilitaControlesAlta();
			procedeSubmit = 0;
		}else{
			if(fechaVenForm < fechaIniForm){
				mensajeSis("Fecha de Inicio es Inferior a la de Vencimiento  ");
				deshabilitaControlesSolicitud();
				deshabilitaControlesAlta();
				procedeSubmit = 0;
			}else{
				var numTran = $('#numTransacSim').val();
				if(numTran == '0' || numTran== '' ){
					mensajeSis("Se requiere Simular las Amortizaciones");

					habilitaControl('montoCuota');
					habilitaControlesSolicitud();
					habilitaControl('tipoPagoCapital');
					var fechaAplicacion = parametroBean.fechaAplicacion;
					var fechaIniForm = $('#fechaInicio').val();
					var fechaVenForm = $('#fechaVencimien').val();
					if(fechaIniForm < fechaAplicacion){
						mensajeSis("Fecha es menor a la del Sistema ");
						deshabilitaControlesSolicitud();
						deshabilitaControlesAlta();
						procedeSubmit = 0;
					}else{
						if(fechaVenForm < fechaIniForm){
							mensajeSis("Fecha de Inicio es Inferior a la de Vencimiento  ");
							deshabilitaControlesSolicitud();
							deshabilitaControlesAlta();
							procedeSubmit = 0;
						}else{
							var numTran = $('#numTransacSim').val();
							if(numTran == '0' || numTran== '' ){
								mensajeSis("Se requiere Simular las Amortizaciones");
								deshabilitaControlesSolicitud();
								deshabilitaControlesAlta();
								procedeSubmit = 0;
							}else{
								if($('#frecuenciaCap').val() == FrecuenciaCapital.Unico ){
									if($('#tipoPagoCapital').val()!= TipoPagoCapital.Iguales){
										mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
										procedeSubmit = 0;
									}else{
										procedeSubmit = 1;
									}
								}else{
									procedeSubmit = 1;
								}
							}
						}
					}
						deshabilitaControlesSolicitud();
					deshabilitaControlesAlta();
					procedeSubmit = 0;
				}else{
					if($('#frecuenciaCap').val() == FrecuenciaCapital.Unico ){
						if($('#tipoPagoCapital').val()!= TipoPagoCapital.Iguales){
							mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
							procedeSubmit = 0;
						}else{
							procedeSubmit = 1;
						}
					}else{
						procedeSubmit = 1;
					}
				}
			}
		}
		return procedeSubmit ;
	}
}); // fin Ready

// funcion para deshabilitar los controles cuando es un alta de credito
function deshabilitaControlesAlta(){
		deshabilitaControl('monedaID');
	//	deshabilitaControl('fechaInicio');
		deshabilitaControl('tipoCalInteres');
		deshabilitaControl('calcInteresID');
		deshabilitaControl('fechaInhabil1');
		deshabilitaControl('fechaInhabil2');
		deshabilitaControl('ajusFecExiVen1');
		deshabilitaControl('ajusFecUlVenAmo1');
		deshabilitaControl('ajusFecExiVen2');
		deshabilitaControl('ajusFecUlVenAmo2');
		deshabilitaControl('montoCuota');
		deshabilitaControl('numAmortInteres');
		deshabilitaControl('numAmortizacion');
		deshabilitaControl('tasaFija');
}


// funcion para deshabilitar los controles cuando un credito no esta inactivo (autorizado,desembolsado)
function deshabilitaControlesNoInactivo(){
	deshabilitaControl('monedaID');
	deshabilitaControl('tipoCalInteres');
	deshabilitaControl('calcInteresID');
	deshabilitaControl('fechaInhabil1');
	deshabilitaControl('fechaInhabil2');
	deshabilitaControl('ajusFecExiVen1');
	deshabilitaControl('ajusFecExiVen2');
	deshabilitaControl('ajusFecUlVenAmo1');
	deshabilitaControl('ajusFecUlVenAmo2');
	deshabilitaControl('montoCuota');
	deshabilitaControl('numAmortInteres');
	deshabilitaControl('numAmortizacion');
	deshabilitaControl('tasaFija');
	deshabilitaControl('lineaCreditoID');
	deshabilitaControl('clienteID');
	deshabilitaControl('cuentaID');
	deshabilitaControl('destinoCreID');
	deshabilitaControl('producCreditoID');
	deshabilitaControl('montoCredito');
	deshabilitaControl('plazoID');
//	deshabilitaControl('fechaInicio');
	deshabilitaControl('tipoDispersion');
	deshabilitaControl('tipoPagoCapital');
	deshabilitaControl('frecuenciaCap');
	deshabilitaControl('frecuenciaInt');
	deshabilitaControl('diaPagoCapital1');
	deshabilitaControl('diaPagoCapital2');
	deshabilitaControl('diaPagoInteres1');
	deshabilitaControl('diaPagoInteres2');
	deshabilitaControl('diaMesInteres');
	deshabilitaControl('diaMesCapital');
}

//funcion que inicializa los combos de frecuencia,plazos,tipo de pago,dispersion.
function inicializaCombosCredito(){
	$('#tipoDispersion').val('0');
	$('#tipoCalInteres').val('');
	$('#calcInteresID').val('-1');
	$('#plazoID').val('0');
	$('#monedaID').val('-1');
}

// funcion que inicializa los combos del calendario de pagos
function inicializaCombos(){
	$('#tipoPagoCapital').each(function(){
		$('#tipoPagoCapital option').remove();
		});
	$('#tipoPagoCapital').append(new Option('SELECCIONAR', '', true, true));


	$('#frecuenciaCap').each(function(){
		$('#frecuenciaCap option').remove();
		});
	$('#frecuenciaCap').append(new Option('SELECCIONAR', '', true, true));

	$('#frecuenciaInt').each(function(){
		$('#frecuenciaInt option').remove();
		});
	$('#frecuenciaInt').append(new Option('SELECCIONAR', '', true, true));

	$('#plazoID').each(function(){
		$('#plazoID option').remove();
		});
	$('#plazoID').append(new Option('SELECCIONAR', '0', true, true));

	$('#tipoDispersion').each(function(){
		$('#tipoDispersion option').remove();
		});
	$('#tipoDispersion').append(new Option('SELECCIONAR', '', true, true));
}

// funcion a ejecutar cuando se realizo con exito una transaccion
function accionInicializaRegresoExitoso(){
	$('#contenedorSimulador').html("");
	inicializaCombosCredito();
	inicializaCombos();
	tab2=false;
	$('#creditoID').focus();
	inicializaForma('formaGenerica','creditoID' );
}

// funcion a ejecutar cuando se realizo con errores una transaccion
function accionInicializaRegresoFallo(){
	var solicitud = 	$('#solicitudCreditoID').val();
	if(solicitud !=0){
		deshabilitaControlesNoInactivo();
	}else{
		deshabilitaControlesAlta();
		tab2=false;
	}
	$('#agrega').focus();

}

function habControles(){
//	habilitacontroles para que mande la consulta atravez del bean y una vez hecha la consulta se deshabilita denuevo
	 habilitaControl('monedaID');
	 habilitaControl('fechaInicio');
	 habilitaControl('calcInteresID');
	 habilitaControl('tasaFija');
	 habilitaControl('numAmortInteres');
	 habilitaControl('montoCuota');
	 habilitaControl('tipoCalInteres');
}
function deshabControles(){
//	habilitacontroles para que mande la consulta atravez del bean y una vez hecha la consulta se deshabilita denuevo
	 deshabilitaControl('monedaID');
	 deshabilitaControl('fechaInicio');
	 deshabilitaControl('calcInteresID');
	 deshabilitaControl('tasaFija');
	 deshabilitaControl('numAmortInteres');
	 deshabilitaControl('montoCuota');
	 deshabilitaControl('tipoCalInteres');
}




/* *******************************************************************************************
 * *****************************CALENDARIO IRREGULAR *****************************************
 * ********************************************************************************************/
/*simulador de pagos libres de capital*/
function simuladorPagosLibres(numTransac){
	$('#numTransacSim').val(numTransac);
	var procedeCalculo = validaUltimaCuotaCapSimulador();
	if(procedeCalculo == 0){
		var mandar = crearMontosCapital(numTransac);
		var diaHabilSig;
		if(mandar==2){
			var params = {};
			if($('#calcInteresID').val()==1 ) {
				switch($('#tipoPagoCapital').val()){
					case "C": // SI ES CRECIENTE
						tipoLista=1;
						break;
					case "I": // SI ES IGUAL
						tipoLista=2;
						break;
					case "L": // SI ES LIBRE
						tipoLista=3;
						break;
					default :
						tipoLista=1;
						break;
				}
			}else{
				switch($('#tipoPagoCapital').val()){
					case "I": // SI ES IGUAL
						tipoLista=4;
						break;
					case "L": // SI ES LIBRE
						tipoLista=5;
						break;
					default :
						tipoLista=4;
						break;
				}
			}

			diaHabilSig= $('#fechInhabil').val();

			params['tipoLista']			= tipoLista;
			params['montoCredito'] 		= $('#montoCredito').asNumber();
			params['tasaFija']			=  $('#tasaFija').val();
			params['producCreditoID'] 	= $('#producCreditoID').val();
			params['clienteID'] 		= $('#clienteID').val();
			params['fechaInhabil']		= diaHabilSig;
			params['empresaID'] 		= parametroBean.empresaID;
			params['usuario'] 			= parametroBean.numeroUsuario;
			params['fecha'] 			= parametroBean.fechaSucursal;
			params['direccionIP'] 		= parametroBean.IPsesion;
			params['sucursal'] 			= parametroBean.sucursal;
			params['numTransaccion']	= $('#numTransacSim').val();
			params['numTransacSim'] 	= $('#numTransacSim').val();
			params['montosCapital'] 	= $('#montosCapital').val();
			params['cobraSeguroCuota'] 	= $('#cobraSeguroCuota option:selected').val();
			params['cobraIVASeguroCuota'] 	= $('#cobraIVASeguroCuota option:selected').val();
			params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
			bloquearPantallaAmortizacion();
			var numeroError = 0;
			var mensajeTransaccion = "";
			$.post("simPagLibresCredito.htm", params, function(data){
				if(data.length >0) {
					$('#contenedorSimulador').html("");
					$('#contenedorSimulador').hide();
					$('#contenedorSimuladorLibre').html(data);
					if ( $("#numeroErrorList").length ) {
						numeroError = $('#numeroErrorList').asNumber();
						mensajeTransaccion = $('#mensajeErrorList').val();
					}
					if(numeroError==0){
						$('#contenedorSimuladorLibre').show();
						var valorTransaccion = $('#transaccion').val();
						$('#numTransacSim').val(valorTransaccion);
						$('#contenedorForma').unblock();
						// actualiza el numero de cuotas generadas por el cotizador
						$('#numAmortInteres').val($('#valorCuotasInteres').val());
						$('#numAmortizacion').val($('#valorCuotasCapital').val());
						// actualiza la nueva fecha de vencimiento que devuelve el cotizador
						var jqFechaVen = eval("'#valorFecUltAmor'");
						$('#fechaVencimien').val($(jqFechaVen).val());
						habilitarBotonesCre();
						$('#imprimirRep').hide(); // uuuu
					}
				}else{
					$('#contenedorSimulador').html("");
					$('#contenedorSimulador').show();
				}
				/****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
				if(numeroError!=0){
					$('#contenedorForma').unblock({fadeOut: 0,timeout:0});
					mensajeSisError(numeroError,mensajeTransaccion);
				}
				/**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
			});
		}
	}

}// fin simuladorPagosLibres

function mostrarGridLibresEncabezado(){
	var data;

	data = '<input type="hidden" value="0" name="numeroDetalle" id="numeroDetalle" />'+
	'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
	'<legend>Simulador de Amortizaciones</legend>'+
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
	 		'<td class="label" align="center"><label for="lblAgregaElimina"></label></td> '+
		'</tr>'+
	'</table>'+
	'</fieldset>';

	$('#contenedorSimuladorLibre').html(data);
	$('#contenedorSimuladorLibre').show();
	$('#contenedorSimulador').html("");
	$('#contenedorSimulador').hide();
	mostrarGridLibresDetalle();
}

function mostrarGridLibresDetalle(){
	var numeroFila = document.getElementById("numeroDetalle").value;
	var nuevaFila = parseInt(numeroFila) + 1;
	var filaAnterior = parseInt(nuevaFila) - 1;
	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	var valorDiferencia = $('#diferenciaCapital').asNumber();
	if(numeroFila == 0){
		tds += '<td><input type="text" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="4" value="1" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="fechaInicio'+nuevaFila+'"  name="fechaInicio" size="15" value="'+ $('#fechaInicio').val()+'" readonly="true" disabled="true"/></td>';
		tds += '<td align="center"><input type="text" id="fechaVencim'+nuevaFila+'" name="fechaVencim" size="15" value="" onblur="comparaFechas(this.id)"  /></td>';
		tds += '<td align="center"><input type="text" id="fechaExigible'+nuevaFila+'" name="fechaExigible" size="15" value=" " readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="capital'+nuevaFila+'" name="capital" size="18" style="text-align: right;" value="" esMoneda="true" onblur="calculaDiferenciaSimuladorLibre();"/></td>';
		tds += '<td><input type="text" id="interes'+nuevaFila+'" name="interes" size="18" style="text-align: right;" value="" esMoneda="true" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="ivaInteres'+nuevaFila+'" name="ivaInteres" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="totalPago'+nuevaFila+'" name="totalPago" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="saldoInsoluto'+nuevaFila+'" name="saldoInsoluto" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';

	} else{
		$('#trBtnCalcular').remove();
		$('#trDiferenciaCapital').remove();
		var valor = parseInt(document.getElementById("consecutivoID"+numeroFila+"").value) + 1;
		tds += '<td><input type="text" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="4" value="'+valor+'" autocomplete="off" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="fechaInicio'+nuevaFila+'"  name="fechaInicio" size="15" value="'+ $('#fechaVencim'+filaAnterior).val()+'" readonly="true" disabled="true"/></td>';
		tds += '<td align="center"><input type="text" id="fechaVencim'+nuevaFila+'" name="fechaVencim" size="15" value="" onblur="comparaFechas(this.id)" /></td>';
		tds += '<td align="center"><input type="text" id="fechaExigible'+nuevaFila+'" name="fechaExigible" size="15" value="" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="capital'+nuevaFila+'" name="capital" size="18" style="text-align: right;" value="" esMoneda="true" onblur="calculaDiferenciaSimuladorLibre();"/></td>';
		tds += '<td><input type="text" id="interes'+nuevaFila+'" name="interes" size="18" style="text-align: right;" value="" esMoneda="true" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="ivaInteres'+nuevaFila+'" name="ivaInteres" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="totalPago'+nuevaFila+'" name="totalPago" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="saldoInsoluto'+nuevaFila+'" name="saldoInsoluto" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';

	}
	tds += '<td nowrap="nowrap"><input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaAmort(this)"/>';
	tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevaAmort()"/></td>';
	tds += '</tr>';
	tds += '<tr id="trDiferenciaCapital" >'+
				'<td colspan="4" align="right"><label for="Diferencia">Diferencia: </label></td>'+
				'<td  id="inputDiferenciaCap">'+
					'<input type="text" id="diferenciaCapital" name="diferenciaCapital" size="18" style="text-align: right;" value="'+valorDiferencia+'" esMoneda="true" readonly="true" disabled="true"/>'+
				'</td>'+
				'<td colspan="5"></td>'+
			'</tr>';
	tds += '<tr id="trBtnCalcular" >'+
				'<td  id="btnCalcularLibre" colspan="10" align="right">'+
					'<button type="button" class="submit" id="calcular" tabindex="37"  onclick="simuladorLibresCapFec();">Calcular</button>'+
				'</td>'+
			'</tr>';

	document.getElementById("numeroDetalle").value = nuevaFila;
	$('#miTabla').append(tds);
	sugiereFechaSimuladorLibre();
	deshabilitaBoton('agrega','submit');
	deshabilitaBoton('modifica','submit');
}

function agregaNuevaAmort(){
	var numeroFila = document.getElementById("numeroDetalle").value;
	var nuevaFila = parseInt(numeroFila) + 1;
	var filaAnterior = parseInt(nuevaFila) - 1;
	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	var valorDiferencia = $('#diferenciaCapital').asNumber();
	if(numeroFila == 0){
		$('#trBtnCalcular').remove();
		$('#trDiferenciaCapital').remove();
		tds += '<td><input type="text" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="4" value="1" readonly="true" disabled="true"/></td>';
		tds += '<td align="center"><input type="text" id="fechaInicio'+nuevaFila+'"  name="fechaInicio" size="15" value="'+ $('#fechaInicio').val()+'" readonly="true" disabled="true"/></td>';
		tds += '<td align="center"><input type="text" id="fechaVencim'+nuevaFila+'" name="fechaVencim" size="15" value="" onblur="comparaFechas(this.id);"  /></td>';
		tds += '<td align="center"><input type="text" id="fechaExigible'+nuevaFila+'" name="fechaExigible" size="15" value="" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="capital'+nuevaFila+'" name="capital" size="18" style="text-align: right;" value="" esMoneda="true" onblur="calculaDiferenciaSimuladorLibre();" /></td>';
		tds += '<td><input type="text" id="interes'+nuevaFila+'" name="interes" size="18" style="text-align: right;" value="" esMoneda="true" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="ivaInteres'+nuevaFila+'" name="ivaInteres" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="totalPago'+nuevaFila+'" name="totalPago" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="saldoInsoluto'+nuevaFila+'" name="saldoInsoluto" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';

	} else{
		$('#trBtnCalcular').remove();
		$('#trDiferenciaCapital').remove();
		var valor = parseInt(document.getElementById("consecutivoID"+numeroFila+"").value) + 1;
		tds += '<td><input type="text" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="4" value="'+valor+'" autocomplete="off" readonly="true" disabled="true" /></td>';
		tds += '<td align="center"><input type="text" id="fechaInicio'+nuevaFila+'"  name="fechaInicio" size="15" value="'+ $('#fechaVencim'+filaAnterior).val()+'" readonly="true" disabled="true"/></td>';
		tds += '<td align="center"><input type="text" id="fechaVencim'+nuevaFila+'" name="fechaVencim" size="15" value="" onblur="comparaFechas(this.id)" /></td>';
		tds += '<td align="center"><input type="text" id="fechaExigible'+nuevaFila+'" name="fechaExigible" size="15" value="" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="capital'+nuevaFila+'" name="capital" size="18" style="text-align: right;" value="" esMoneda="true" onblur="calculaDiferenciaSimuladorLibre();"/></td>';
		tds += '<td><input type="text" id="interes'+nuevaFila+'" name="interes" size="18" style="text-align: right;" value="" esMoneda="true" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="ivaInteres'+nuevaFila+'" name="ivaInteres" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="totalPago'+nuevaFila+'" name="totalPago" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
		tds += '<td><input type="text" id="saldoInsoluto'+nuevaFila+'" name="saldoInsoluto" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
	}
	tds += '<td nowrap="nowrap"><input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaAmort(this)"/>';
	tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevaAmort()"/></td>';
	tds += '</tr>';
	tds += '<tr id="trDiferenciaCapital" >'+
				'<td colspan="4" align="right"><label for="Diferencia">Diferencia: </label></td>'+
				'<td  id="inputDiferenciaCap">'+
					'<input type="text" id="diferenciaCapital" name="diferenciaCapital" size="18" style="text-align: right;" value="'+valorDiferencia+'" esMoneda="true" readonly="true" disabled="true"/>'+
				'</td>'+
				'<td colspan="5"></td>'+
			'</tr>';
	tds += '<tr id="trBtnCalcular" >'+
				'<td  id="btnCalcularLibre" colspan="10" align="right">'+
					'<button type="button" class="submit" id="calcular" tabindex="37"  onclick="simuladorLibresCapFec();">Calcular</button>'+
				'</td>'+
			'</tr>';

	document.getElementById("numeroDetalle").value = nuevaFila;
	$("#miTabla").append(tds);
	sugiereFechaSimuladorLibre();
	calculaDiferenciaSimuladorLibre();

	return false;
}

/* funcion para eliminar una amortizacion  */
function eliminaAmort(control){
	var contador = 1;
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

	/* FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y
	 * LAS FILAS CONTINUEN DE MANERA COHERENTE.*/
	var continuar = ajustaValoresFechaElimina(numeroID,jqFechaInicio);

	if(continuar==1){
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


		// se asigna el numero de detalle que quedan
		var elementos = document.getElementsByName("renglon");
		$('#numeroDetalle').val(elementos.length);
		/*SE COMPARA SI QUEDA MAS DE UNA FILA */
		if($('#numeroDetalle').asNumber()>0){
			//Reordenamiento de Controles
			contador = 1;
			var numero= 0;
			$('tr[name=renglon]').each(function() {
				numero= this.id.substr(7,this.id.length);
				var jqRenglonCiclo 	= eval("'renglon" + numero+ "'");
				var jqNumeroCiclo = eval("'consecutivoID" + numero + "'");
				var jqFechaInicio	= eval("'fechaInicio" + numero + "'");
				var jqFechaVencim	= eval("'fechaVencim" + numero + "'");
				var jqAgrega		= eval("'agrega" + numero + "'");
				var jqFechaExigible = eval("'fechaExigible" + numero + "'");
				var jqCapital		= eval("'capital" + numero + "'");
				var jqInteres		= eval("'interes" + numero + "'");
				var jqIvaInteres	= eval("'ivaInteres" + numero + "'");
				var jqTotalPago		= eval("'totalPago" + numero + "'");
				var jqSaldoInsoluto = eval("'saldoInsoluto" + numero + "'");

				var jqElimina = eval("'" + numero + "'");

				document.getElementById(jqNumeroCiclo).setAttribute('value',  contador);

				document.getElementById(jqRenglonCiclo).setAttribute('id', "renglon" + contador);
				document.getElementById(jqNumeroCiclo).setAttribute('id', "consecutivoID" + contador);
				document.getElementById(jqFechaInicio).setAttribute('id', "fechaInicio" + contador);
				document.getElementById(jqFechaVencim).setAttribute('id', "fechaVencim" + contador);
				document.getElementById(jqAgrega).setAttribute('id', "agrega" + contador);
				document.getElementById(jqFechaExigible).setAttribute('id', "fechaExigible" + contador);
				document.getElementById(jqCapital).setAttribute('id', "capital" + contador);
				document.getElementById(jqInteres).setAttribute('id', "interes" + contador);
				document.getElementById(jqIvaInteres).setAttribute('id', "ivaInteres" + contador);
				document.getElementById(jqTotalPago).setAttribute('id', "totalPago" + contador);
				document.getElementById(jqSaldoInsoluto).setAttribute('id', "saldoInsoluto" + contador);

				document.getElementById(jqElimina).setAttribute('id',  contador);

				contador = parseInt(contador + 1);
			});
			calculaDiferenciaSimuladorLibre();
		}else{
			/*si el usuario elimina la ultima fila, se agrega una fila nueva*/
			agregaNuevaAmort();
		}
	}
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
		$(varCapitalID).val($('#montoCredito').val());
		$(varCapitalID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	}
}

function verificarvaciosCapFec(){
	var numAmortizacion = $('input[name=capital]').length;
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

//funcion para validar que la fecha de vencimiento indicada sea mayor a la de inicio
function comparaFechas(varid){
	var fila = varid.substr(11,varid.length);
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
	if($(jqFechaVen).val()!= ""){
		if(esFechaValida($(jqFechaVen).val())){
			if(validaFechaVencimientoGrid($(jqFechaVen).val(), $('#fechaVencimien').val(), jqFechaVen, fila)){
				if (yYear<xYear ){
					mensajeSis("La Fecha Indicada debe ser Mayor a la Fecha de Inicio.");
					document.getElementById("fechaVencim"+fila).focus();
					$(jqFechaVen).addClass("error");
				}else{
					if (xYear == yYear){
						if (yMonth<xMonth){
							mensajeSis("La Fecha Indicada debe ser Mayor a la Fecha de Inicio.");
							document.getElementById("fechaVencim"+fila).focus();
							$(jqFechaVen).addClass("error");
						}else{
							if (xMonth == yMonth){
								if (yDay<xDay||yDay==xDay){
									mensajeSis("La Fecha Indicada debe ser Mayor a la Fecha de Inicio.");
									document.getElementById("fechaVencim"+fila).focus();
									$(jqFechaVen).addClass("error");
								}else{
									/* FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y
									 * LAS FILAS CONTINUEN DE MANERA COHERENTE.*/
									comparaFechaModificadaSiguiente(fila,jqFechaVen, jqFechaIni);
								}
							}else{
								/* FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y
								 * LAS FILAS CONTINUEN DE MANERA COHERENTE.*/
								comparaFechaModificadaSiguiente(fila,jqFechaVen, jqFechaIni);

							}
						}
					}else{
						/* FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y
						 * LAS FILAS CONTINUEN DE MANERA COHERENTE.*/
						comparaFechaModificadaSiguiente(fila,jqFechaVen, jqFechaIni);
					}
				}
			}else{
				$(jqFechaVen).focus();
			}
		}else{
			$(jqFechaVen).focus();
		}
	}
}

//funcion para validar que la fecha de vencimiento No sea mayor a la de vencimiento calculada por los plazos.
function validaFechaVencimientoGrid(fechaVenGrid, fechaVenCred, jqFechaVen, fila){
	var xYear=fechaVenCred.substring(0,4);
	var xMonth=fechaVenCred.substring(5, 7);
	var xDay=fechaVenCred.substring(8, 10);

	var yYear=fechaVenGrid.substring(0,4);
	var yMonth=fechaVenGrid.substring(5, 7);
	var yDay=fechaVenGrid.substring(8, 10);

	if(esFechaValida(fechaVenGrid)){
		if (yYear>xYear ){
			mensajeSis("La Fecha debe ser Menor o Igual a la Fecha de Vencimiento");
			document.getElementById("fechaVencim"+fila).focus();
			$(jqFechaVen).addClass("error");
			return false;
		}else{
			if (xYear == yYear){
				if (yMonth>xMonth){
					mensajeSis("La Fecha debe ser Menor o Igual a la Fecha de Vencimiento");
					document.getElementById("fechaVencim"+fila).focus();
					$(jqFechaVen).addClass("error");
					return false;
				}else{
					if (xMonth == yMonth){
						if (yDay>xDay){
							mensajeSis("La Fecha debe ser Menor o Igual a la Fecha de Vencimiento");
							document.getElementById("fechaVencim"+fila).focus();
							$(jqFechaVen).addClass("error");
							return false;
						}
					}
				}
			}
		}
	}else{
		$(jqFechaVen).focus();
	}
	return true;
}

/* funcion para calcular la diferencia del monto con lo que se va poniendo en
 * el grid de pagos libres.*/
function calculaDiferenciaSimuladorLibre(){
	var sumaMontoCapturado = 0;
	var diferenciaMonto = 0;
	var numero = 0;
	var varCapitalID = "";
	var muestraAlert = true;
	$('input[name=capital]').each(function() {
		numero= this.id.substr(7,this.id.length);
		numDetalle = $('input[name=capital]').length;
		varCapitalID = eval("'#capital"+numero+"'");
		sumaMontoCapturado = sumaMontoCapturado + $(varCapitalID).asNumber();

		if(sumaMontoCapturado > $('#montoCredito').asNumber()){
			if(muestraAlert){
				menajeSis("La suma de Montos de Capital debe ser Igual al Monto Solicitado.");
				muestraAlert = false;
			}
			$(varCapitalID).val("");
			$(varCapitalID).select();
			$(varCapitalID).focus();
			$(varCapitalID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
			return false;
		}else{
			diferenciaMonto = $('#montoCredito').asNumber() -  sumaMontoCapturado.toFixed(2);
			$('#diferenciaCapital').val(diferenciaMonto);
			$('#diferenciaCapital').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
			$(varCapitalID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
		}
	});
}

//funcion para validar la fecha
function esFechaValida(fecha){

	if (fecha != undefined && fecha.value != "" ){
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)){
			mensajeSis("Formato de Fecha No Válido (aaaa-mm-dd)");
			return false;
		}

		var mes=  fecha.substring(5, 7)*1;
		var dia= fecha.substring(8, 10)*1;
		var anio= fecha.substring(0,4)*1;

		switch(mes){
			case 1: case 3:  case 5: case 7: case 8: case 10: case 12:
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


/*Para ejecutar el simulador de pagos libres de capital y fecha cuando das clic en el
 * boton calcular*/
function simuladorLibresCapFec(){
	var mandar = "";
	var procedeCalculo = validaUltimaCuotaCapSimulador();
	if(procedeCalculo == 0){
		mandar = crearMontosCapitalFecha();
		if(mandar==2){
			var params = {};
			if($('#calcInteresID').val()==1 ) {
				if($('#calendIrregularCheck').is(':checked')){
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
				if($('#calendIrregularCheck').is(':checked')){
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
			params['montoCredito'] 		= $('#montoCredito').asNumber();
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
			params['producCreditoID'] 	= $('#producCreditoID').val();
			params['clienteID'] 		= $('#clienteID').val();
			params['montoComision'] 	= $('#montoComision').asNumber();
			params['cobraSeguroCuota'] 	= $('#cobraSeguroCuota option:selected').val();
			params['cobraIVASeguroCuota'] 	= $('#cobraIVASeguroCuota option:selected').val();
			params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
			bloquearPantallaAmortizacion();
			var numeroError = 0;
			var mensajeTransaccion = "";
			$.post("simPagLibresCredito.htm", params, function(data){
				if(data.length >0) {
					$('#contenedorSimulador').html("");
					$('#contenedorSimulador').hide();
					$('#contenedorSimuladorLibre').html(data);
					if ( $("#numeroErrorList").length ) {
						numeroError = $('#numeroErrorList').asNumber();
						mensajeTransaccion = $('#mensajeErrorList').val();
					}
					if(numeroError==0){
						$('#contenedorSimuladorLibre').show();
						var valorTransaccion = $('#transaccion').val();
						$('#numTransacSim').val(valorTransaccion);
						// actualiza la nueva fecha de vencimiento que devuelve el cotizador
						var jqFechaVen = eval("'#valorFecUltAmor'");
						$('#fechaVencimien').val($(jqFechaVen).val());

						// se asigna el numero de cuotas calculadas
						$('#numAmortizacion').val($('#valorCuotasCapital').val());
						$('#numAmortInteres').val($('#valorCuotasInteres').val());

						// se debloquea el contenedor
						$('#contenedorForma').unblock();
						habilitarBotonesCre();
						$('#imprimirRep').hide(); // uuuu
					}
				}else{
					$('#contenedorSimulador').html("");
					$('#contenedorSimulador').hide();
					$('#contenedorSimuladorLibre').html("");
					$('#contenedorSimuladorLibre').hide();
				}
				/****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
				if(numeroError!=0){
					$('#contenedorForma').unblock({fadeOut: 0,timeout:0});
					mensajeSisError(numeroError,mensajeTransaccion);
				}
				/**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/

			});
		}
	}
}


function crearMontosCapitalFecha(){
	var mandar = verificarvaciosCapFec();
	var regresar = 1;
	if(mandar!=1){
		var suma =	sumaCapital();
		if(suma !=1){
			var numAmortizacion = $('input[name=capital]').length;
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

//funcion para verificar que la suma del capital sea igual que la del monto
function sumaCapital(){
	var jqCapital;
	var suma = 0;
	var contador = 1;
	var capital;

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
	if (suma!= $('#montoCredito').asNumber() ) {
		mensajeSis("La suma de Montos de Capital debe ser Igual al Monto Solicitado.");
		return 1;
	}
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

//funcion que bloque la pantalla mientras se cotiza
function bloquearPantallaAmortizacion() {
	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
	$('#contenedorForma').block({
		message : $('#mensaje'),
		css : {
			border : 'none',
			background : 'none'
		}
	});

}
// agrega el scroll al div de simulador de pagos libres de capital
$('#contenedorSimuladorLibre').scroll(function() {

});


/* FUNCION PARA VALIDAR QUE LA ULTIMA CUOTA DE CAPITAL EN EL COTIZADOR DE
 * PAGOS LIBRES EN CAPITAL O IRREGULAR
 * NO SEA CERO.*/
function validaUltimaCuotaCapSimulador(){
	var procede = 0;
	if($('#tipoPagoCapital').val()=="L"){
		var numAmortizacion = $('input[name=capital]').length;
		for(var i = 1; i <= numAmortizacion; i++){
			if(i== numAmortizacion ){
				var idCapital = eval("'#capital"+i+"'");
				if($(idCapital).asNumber()==0 ){
					document.getElementById("capital"+i+"").focus();
					document.getElementById("capital"+i+"").select();
					$("capital"+i).addClass("error");
					mensajeSis("La Última Cuota de Capital no puede ser Cero.");
					procede = 1;
				}else{
					if($('#diferenciaCapital').asNumber() == 0 ){
						procede = 0;
					}else{
						mensajeSis(" La Suma de capital en Amortizaciones debe ser igual al Monto Solicitado.");
						procede = 1;
					}
				}
			}else{
				if($('#diferenciaCapital').asNumber() == 0 ){
					procede = 0;
				}else{
					mensajeSis(" La Suma de capital en Amortizaciones debe ser igual al Monto Solicitado.");
					procede = 1;
				}
			}
		}
	}else{
		/* se valida que si el tipo de pago de capital es libre, no se pueda escoger como frecuencia
		 * la opcion de libre */
		if ($('#frecuenciaInt').val() == "L" &&  $('#calendIrregular').val() == "N") {
			mensajeSis("La Frecuencia de Interés Libre sólo Aplica para Calendario Irregular.");
			$('#frecuenciaInt').focus();
			$('#frecuenciaInt').val("");
			procede = 1;
		}else{
			if ($('#frecuenciaCap').val() == "L" &&  $('#calendIrregular').val() == "N") {
				mensajeSis("La Frecuencia de Capital Libre sólo Aplica para Calendario Irregular.");
				$('#frecuenciaCap').focus();
				$('#frecuenciaCap').val("");
				procede = 1;
			}else{
				procede = 0;
			}
		}
	}
	return procede;
}




/* FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y
 * LAS FILAS CONTINUEN DE MANERA COHERENTE.*/
function ajustaValoresFechaElimina(numeroID,jqFechaInicio){
	var idCajaRenom		= "";
	var siguiente		= 0;
	var anterior		= 0;
	var continuar		= 0;
	var numFilas		= $('input[name=fechaVencim]').length;

	if(numeroID <= numFilas ){
		if(numeroID == 1){
			siguiente = parseInt(numeroID) + parseInt(1);
			idCajaRenom = eval("'#fechaInicio"+siguiente+"'");
			$(idCajaRenom).val($(jqFechaInicio).val());
			continuar = 1;
		}else{
			if(numeroID < numFilas){
				siguiente = parseInt(numeroID) + parseInt(1);
				anterior = parseInt(numeroID) - parseInt(1);
				idCajaRenom = eval("'#fechaInicio"+siguiente+"'");
				jqFechaVencim = eval("'#fechaVencim"+anterior+"'");
				$(idCajaRenom).val($(jqFechaVencim).val());
				continuar = 1;
			}else{
				if(numeroID == numFilas){
					continuar = 1;
				}
			}
		}
	}
	return continuar;
}




/* FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y
 * LAS FILAS CONTINUEN DE MANERA COHERENTE.*/
function ajustaValoresFechaModifica(numeroID,jqFechaInicio){
	var idCajaRenom		= "";
	var siguiente		= 0;
	var continuar		= 0;
	var numFilas		= $('input[name=fechaVencim]').length;

	if(numeroID <= numFilas ){
		if(numeroID < numFilas){
			siguiente = parseInt(numeroID) + parseInt(1);
			idCajaRenom = eval("'#fechaInicio"+siguiente+"'");
			jqFechaVencim = eval("'#fechaVencim"+numeroID+"'");
			$(idCajaRenom).val($(jqFechaVencim).val());
			continuar = 1;
		}else{
			if(numeroID == numFilas){
				continuar = 1;
			}
		}
	}
	return continuar;
}


/* FUNCION PARA VALIDAR QUE LA FECHA DE VENCIMIENTO
 * MODIFICADA NO SEA MAYO A LA FECHA DE VENCIMIENTO SIGUIENTE*/
function comparaFechaModificadaSiguiente(varid, jqFechaVen ,jqFechaInicio){
	var siguiente = parseInt(varid) + parseInt(1);
	var numFilas		= $('input[name=fechaVencim]').length;
	if(varid < numFilas ){
		var jqFechaVenSiguiente = eval("'#fechaVencim" +siguiente + "'");

		var fechaIni = $(jqFechaVen).val();
		var fechaVen = $(jqFechaVenSiguiente).val();
		var xYear=fechaIni.substring(0,4);
		var xMonth=fechaIni.substring(5, 7);
		var xDay=fechaIni.substring(8, 10);
		var yYear=fechaVen.substring(0,4);
		var yMonth=fechaVen.substring(5, 7);
		var yDay=fechaVen.substring(8, 10);
		if($(jqFechaVen).val()!= ""){
			if(esFechaValida($(jqFechaVen).val())){
				if(validaFechaVencimientoGrid($(jqFechaVen).val(), $('#fechaVencimien').val(), jqFechaVen, varid)){
					if (yYear<xYear ){
						mensajeSis("La Fecha Indicada debe ser Menor a la Fecha de Vencimiento \nde la siguiente Amortizazion.");
						document.getElementById("fechaVencim"+varid).focus();
						$(jqFechaVen).addClass("error");
					}else{
						if (xYear == yYear){
							if (yMonth<=xMonth){
								if (xMonth == yMonth){
									if (yDay<=xDay||yDay==xDay){
										mensajeSis("La Fecha Indicada debe ser Menor a la Fecha de Vencimiento \nde la siguiente Amortizazion.");
										document.getElementById("fechaVencim"+varid).focus();
										$(jqFechaVen).addClass("error");
									}else{
										ajustaValoresFechaModifica(varid,jqFechaInicio);
									}
								}else{
									ajustaValoresFechaModifica(varid,jqFechaInicio);
								}
							}else{
								ajustaValoresFechaModifica(varid,jqFechaInicio);
							}
						}else{
							ajustaValoresFechaModifica(varid,jqFechaInicio);
						}
					}
				}else{
					$(jqFechaVen).focus();
				}
			}else{
				$(jqFechaVen).focus();
			}
		}
	}
}  // fin comparaFechaModificadaSiguiente


function habilitarBotonesCre(){
	if($('#creditoID').val()== '0'){
		habilitaBoton('agrega', 'submit');
		deshabilitaBoton('modifica', 'submit');
	}else{
		deshabilitaBoton('agrega','submit');
		habilitaBoton('modifica','submit');
	}
}


/*
 * funcion para validar cuando un campo  toma el foco
 y es moneda, se necesita que se ponga el campo limpio cuando su valor es cero o seleccione elvalor si es
 mayor que cero.*/
function validaFocoInputMoneda(controlID){
	jqID = eval("'#" + controlID + "'");
	if($(jqID).asNumber()>0){
		$(jqID).select();
	}else{
		$(jqID).val("");
	}
}
function totales(){
	$('input[name=fechaInicioGrid]').each(function() {
		var numero= this.id.substr(11,this.id.length);
		var jqcapital = eval("'amortizacionID" + numero+ "'");
		var fecha =eval("'fechaInicio"+numero+"'");
		var venc=eval("'fechaVencim"+numero+"'");
		var Exig=eval("'fechaExigible"+numero+"'");
		var pago=eval("'totalPago"+numero+"'");
		var saldo=eval("'saldoInsoluto"+numero+"'");

		if($('#'+fecha).val()==""){
			$('#'+jqcapital).hide();
			$('#'+fecha).hide();
			$('#'+venc).hide();
			$('#'+Exig).hide();
			$('#'+pago).hide();
			$('#'+saldo).hide();
		}
		});
	}


//funcion que llena el combo de calcInteres
function consultaComboCalInteres() {
	dwr.util.removeAllOptions('calcInteresID');
	formTipoCalIntServicio.listaCombo(1,function(formTipoCalIntBean){
		dwr.util.addOptions('calcInteresID', {'':'SELECCIONAR'});
		dwr.util.addOptions('calcInteresID', formTipoCalIntBean, 'formInteresID', 'formula');
	});
}

// Funcion que cambia la etiqueta de Tasa Fija Actualizada por Tasa Base Actual
function setCalcInteresID(calcInteres,iniciaCampos){
	$('#calcInteresID').val(calcInteres);
	calcInteres = Number(calcInteres);
	if(TasaFijaID==calcInteres){
		VarTasaFijaoBase = 'Tasa Fija Anualizada';
	} else {
		VarTasaFijaoBase = 'Tasa Base Actual';
	}
	$('#lblTasaFija').text(VarTasaFijaoBase+': ');
	if(iniciaCampos){
		limpiaCamposTasaInteres();
	}
	habilitaCamposTasa(calcInteres);
}

// Funcion que limpia los campos de Tasas
function limpiaCamposTasaInteres(){
	$('#tasaBase').val('');
	$('#desTasaBase').val('');
	$('#tasaFija').val('');
	$('#sobreTasa').val('');
	$('#pisoTasa').val('');
	$('#techoTasa').val('');
}

// Funcion que habilita y da formato de tasa dependiendo del calculo de interes
function habilitaCamposTasa(calcInteresID){
	if(calcInteresID != TasaFijaID){
		deshabilitaControl('tipoPagoCapital');
		$('#tipoPagoCapital').attr("checked",false) ;
	} else {
		habilitaControl('tipoPagoCapital');
	}

	if(calcInteresID == TasaFijaID){
		deshabilitaControl('calcInteresID');
		deshabilitaControl('tasaFija');
		deshabilitaControl('tasaBase');
		deshabilitaControl('sobreTasa');
		deshabilitaControl('pisoTasa');
		deshabilitaControl('techoTasa');
		$('#tasaBase').val('');
		$('#desTasaBase').val('');
		$('#sobreTasa').val('');
		$('#pisoTasa').val('');
		$('#techoTasa').val('');
		habilitaControl('tipoPagoCapital');
	} else {
		deshabilitaControl('tipoPagoCapital');
		$('#tipoPagoCapital').attr("checked",false) ;
		//$('#tasaFija').val('');
	}

	if(calcInteresID == 2 || calcInteresID == 4 ){
		habilitaControl('tasaBase');
		habilitaControl('sobreTasa');
		deshabilitaControl('tasaFija');
		deshabilitaControl('pisoTasa');
		deshabilitaControl('techoTasa');
	}

	if(calcInteresID == TasaBasePisoTecho){
		habilitaControl('pisoTasa');
		habilitaControl('techoTasa');
		deshabilitaControl('tasaFija');
		deshabilitaControl('tipoPagoCapital');
		$('#tipoPagoCapital').attr("checked",false) ;
	}

	$('#tasaFija').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
	$('#pisoTasa').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
	$('#sobreTasa').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
	$('#techoTasa').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
}

/* Funcion que pone las banderas para que se solicite de nuevo la simulación
 * por cambio en tasas y oculta/limpia los simuladores */
function vuelveaSimular(){
	$("#numTransacSim").val('');
	$('#contenedorSimulador').html("");
	$('#contenedorSimulador').hide();
	$('#contenedorSimuladorLibre').html("");
	$('#contenedorSimuladorLibre').hide();
}