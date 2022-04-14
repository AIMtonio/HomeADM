var filas;
var filasTotal = 0;
var TasaFijaID = 1;

var productoCredOID;
var tipoPagoSeguroID;
var botonClic = 0;

var factorR;
var descuentoS;
var MontoP;
var modalidad;

var catFormTipoCalInt = {
		'principal'	: 1,
};

var tipoInstitucion = 0; // Para determinar si es SOFIPO o SOFOM, SOCAP
var tipoSOFIPO		= 3; // Clave del Tipo de Institucion SOFIPO

var Enum_Constantes ={
	'SI' : 'S',
	'NO' : 'N'
};
$(document).ready(function() {
	esTab = true;
	esGrupalVG = false;
	//grupo de variables globales para la validacion en productosCreditoCatalogovista.jsp
	min = 0;
	max = 0;
	minh = 0;
	maxh = 0;
	minm = 0;
	maxm = 0;
	minms = 0;
	maxms = 0;
	//Definicion de Constantes y Enums
	var catTipoProductoCredito = {
			'principal'	: 1,
			'foranea'	: 2
	};
	var catTipoTransaccionProducCred = {
			'alta' : 1,
			'modifica': 2
	};

	var tipoTransaccionGrid= {
			'alta' : 1,
			'actualizar' :2,
			'baja' : 3
	};
	consultaTipoInstitucion();

	var parametroBean = consultaParametrosSession();
	var productoCredito;
	$('#tdDiasMaximo').hide(400);
	$('#labelDiasMaximo').html('');
	$('#diasMaximo').val('0');

	var formSegVida = 1;
	var botonClic = 0;

	$('select').css('background-color','#FFFFFF');
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('graba', 'submit');
	deshabilitaBoton('grabar', 'submit');

	//------------ llena el combo para la Formula de Calculo de Interés -----------------------------------------
	consultaComboCalInteres();
	muestraCamposTasa(0);

	deshabilitagrupales();
	$('#prepago').hide();
	$('#divGrid').hide();
	$('#mostrarMinReferencias1').hide();
	$('#mostrarMinReferencias2').hide();
	$('#financiamientoRural1').attr("checked",true);

	$('#calcInteres').change(function(){
		consultaTasaBase($(this).val());
		muestraCamposTasa($(this).val());
	});

	$('#eMujeres').click(function () {
		$('#eHombres').attr("checked",false) ;
		$('#gMixto').attr("checked",false) ;
		$('#gIntegrantes').hide();
		$('#gMujeres').show();
		$('#gMujeresS').show();
		$('#gHombres').hide();
		$('#minHombres').attr('readonly',true);
		var tmp_max	= maxm;
		var tmp_min	= minm;
		var	tmp_maxm = maxm;
		var	tmp_minm = minm;
		var	tmp_maxms = maxms;
		var	tmp_minms = minms;
		inicializaGrupalesIntegrantes();
		max		=	tmp_max;
		min		=	tmp_min;
		maxm	=	tmp_maxm;
		minm	=	tmp_minm;
		maxms	=	tmp_maxms;
		minms	=	tmp_minms;
		muestraGrupalesIntegrantes();
	});
	$('#eHombres').click(function () {
		$('#eMujeres').attr("checked",false) ;
		$('#gMixto').attr("checked",false) ;
		$('#gIntegrantes').hide();
		$('#gMujeres').hide();
		$('#gMujeresS').hide();
		$('#gHombres').show();
		$('#minHombres').removeAttr('readonly');
		$('#maxHombres').removeAttr('readonly');
		var tmp_max	= maxh;
		var tmp_min	= minh;
		var	tmp_maxh = maxh;
		var	tmp_minh = minh;
		inicializaGrupalesIntegrantes();
		max		=	tmp_max;
		min		=	tmp_min;
		maxh	=	tmp_maxh;
		minh	=	tmp_minh;
		muestraGrupalesIntegrantes();
	});
	$('#gMixto').click(function () {
		$('#eMujeres').attr("checked",false) ;
		$('#eHombres').attr("checked",false) ;
		$('#gIntegrantes').show();
		$('#gMujeres').show();
		$('#gMujeresS').show();
		$('#gHombres').show();
		$('#maxHombres').removeAttr('readonly');
		$('#minHombres').attr('readonly',true);
	});

	$('#modificarPrepago2').attr("checked",true);
	$('#permitePrepago').val("");
	$('#tipoPrepago').val("");
	actualizaFormatoseisDecimales('formaGenerica');
	$('#fechaInscripcion').change(function() {
		var Xfecha= $('#fechaInscripcion').val();

		if(FechaValida(Xfecha)){
			$('#fechaInscripcion').val(parametroBean.fechaSucursal);
			$('#fechaInscripcion').select();
			$('#fechaInscripcion').focus();
		}

	});

	$("#raIniCicloGrup").blur(
			function(){
				if( $("#raIniCicloGrup").asNumber() > $("#raIniCicloGrup").asNumber()){
					mensajeSis('Inserta valores correctos');
					$("#raIniCicloGrup").val(0);
					$("#raIniCicloGrup").val(0);
				}

			});

	$("#raFinCicloGrup").blur(
			function(){
				if( $("#raIniCicloGrup").asNumber() > $("#raIniCicloGrup").asNumber()){
					mensajeSis('Inserta valores correctos');
					$("#raIniCicloGrup").val(0);
				}
			}      	);


	$("#validaCapConta").click (function(){
		var Si='S';
		var No='N';

		if ( $("#validaCapConta").val()==No){
			$("#porcMaxCapConta").attr('disabled', false);

		}
		if ( $("#validaCapConta").val()==Si){
			$("#porcMaxCapConta").attr('disabled', false);


		}

	});

	$("#fechaInscripcion").change(function (){
		this.focus();
	});

	$("#maximoIntegrantes").change(function(){
		min = 0;
		minh = 0;
		maxh = 0;
		minm = 0;
		maxm = 0;
		minms = 0;
		maxms = 0;
		$('#minimoIntegrantes').val(min);
		$('#minHombres').val(minh);
		$('#maxHombres').val(maxh);
		$('#minMujeres').val(minm);
		$('#maxMujeres').val(maxm);
		$('#minMujeresSol').val(minms);
		$('#maxMujeresSol').val(maxms);
		max=Number($('#maximoIntegrantes').val());
		$("#maxHombres").removeAttr('readonly');
		$("#minMujeres").removeAttr('readonly');
	});

	$("#minimoIntegrantes").change(function(){
		$("#maxHombres").removeAttr('readonly');
		$("#minMujeres").removeAttr('readonly');
	});

	$("#maximoIntegrantes").blur(function(){
		validaGrupalIntegrantes();
	});
	$("#minimoIntegrantes").blur(function(){
		validaGrupalIntegrantes();
	});
	$("#maxMujeres").blur(function(){
		if($('#eMujeres').is(':checked')) {
			$("#maximoIntegrantes").val($("#maxMujeres").val());
		}else{
			if($('#gMixto').is(':checked')&& max == min && max> Number($("#maxMujeres").val())){
				maxm = Number($("#maxMujeres").val());
				minm = maxm;
				$("#minMujeres").val(minm);
				maxh = max-maxm;
				$("#maxHombres").val(maxh);
				minh = min-minm;
				$("#minHombres").val(minh);
			}
		}
		validaGrupalIntegrantes();
	});
	$("#minMujeres").blur(function(){
		if($('#gMixto').is(':checked')) {
			minm = Number($("#minMujeres").val());
			if(max == maxm && min == 0 && minm == 0 )
			{	minh=0;
			$("#minMujeresSol").val( 0 );
			$("#maxMujeresSol").val( max );
			$("#minHombres").val( 0 );
			$("#maxHombres").val( max );
			}else{
				if(max>=minm){
					maxh = max - minm;
					$("#maxHombres").val( maxh );
					if(maxh==0 || max == min){
						$("#maxHombres").attr('readonly',true);
					}else{
						$("#maxHombres").removeAttr('readonly');
					}
				}

				if(max>=maxm){
					minh = max - maxm;

					$("#minHombres").val( minh );

				}
			}
		}
		if($('#eMujeres').is(':checked')) {
			minm=$("#minMujeres").val();
			$("#minimoIntegrantes").val(minm);
		}
		validaGrupalIntegrantes();

	});
	$("#maxMujeresSol").blur(function(){
		validaGrupalIntegrantes();

	});
	$("#minMujeresSol").blur(function(){
		validaGrupalIntegrantes();
	});
	$("#maxHombres").blur(function(){
		if($('#gMixto').is(':checked')) {
			if(max == Number($("#maxHombres").val()) && max == maxms && max == maxm && minm == 0 && minms == 0)
			{	minh = 0;
			$("#minHombres").val(minh);
			}else{
				minh = (max - maxm);
				$("#minHombres").val(minh);
			}

		}
		if($('#eHombres').is(':checked')) {
			maxh=$("#maxHombres").val();
			$("#maximoIntegrantes").val(maxh);
		}
		validaGrupalIntegrantes();
	});
	$("#minHombres").blur(function(){
		if($('#eHombres').is(':checked')) {
			minh=$("#minHombres").val();
			$("#minimoIntegrantes").val(minh);
		}
		validaGrupalIntegrantes();
	});

	$(':text').focus(function() {
		esTab = false;
	});

	agregaFormatoControles('formaGenerica');
	agregaFormatoControles('formaGenerica1');



	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
			var transacion = $('#tipoTransaccionGrid').val();
			if(transacion  == tipoTransaccionGrid.alta || transacion  == tipoTransaccionGrid.actualizar){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica1', 'contenedorForma', 'mensaje','true','reqSeguroVida','funcionExitoGrid','funcionFalloGrid');
			}else{
				var transacion = $('#tipoTransaccion').val();
				if(transacion  == catTipoTransaccionProducCred.modifica  || transacion  == catTipoTransaccionProducCred.alta){

					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','producCreditoID','funcionExitoProducto','funcionFalloProducto');
				}else{}
			}
		}
	});

	$('#agrega').click(function() {
		botonClic = 0;
		$('#tipoTransaccionGrid').val(0);

		if($('#esGrupal').val()=='S'){
			if(validaGrupalIntegrantes() == 5){
				if(max==0 && min==0){

					mensajeSis('Especificar datos grupales.');
					return false;
				}
			}else{return false;}
		}


		if($('#esGrupal').val()=='N'){
			$('#prorrateoPago').val('N');
		}

		$('#tipoTransaccion').val(catTipoTransaccionProducCred.alta);

		if ($('#montoMinimo').asNumber() > $('#montoMaximo').asNumber()){
			mensajeSis("El Monto Mínimo no debe ser Mayor al Máximo");
			$('#montoMaximo').focus();
			$('#montoMaximo').select();
			event.preventDefault();
		}
	});

	$('#modifica').click(function() {
		botonClic = 0;
		var consultaFil = consultaFilas();
		$('#tipoTransaccionGrid').val(0);
		if($('#esGrupal').val()=='N'){
			$('#prorrateoPago').val('N');
		}
		if($('#esGrupal').val()=='S'){
			var val = validaGrupalIntegrantes();

			if(val == 5){
				if(max==0 && min==0){
					mensajeSis('Especificar datos grupales.');
					return false;
				}
			}else{

				return false;
			}
		}

		$('#tipoTransaccion').val(catTipoTransaccionProducCred.modifica);

		if ($('#montoMinimo').asNumber() > $('#montoMaximo').asNumber()){
			mensajeSis("El Monto Mínimo no debe ser Mayor al Máximo");
			$('#montoMaximo').focus();
			$('#montoMaximo').select();
			event.preventDefault();
		}

		if($('#tipoPago').is(':checked') && consultaFil == 0) {
			mensajeSis("Agregar por lo menos un Esquema para el Seguro de Vida.");
			deshabilitaBoton('graba');
			$('#agregar').focus();
			event.preventDefault();
		}

	});

	$('#graba').click(function() {
		var consultaFil = consultaFilas();
		if($('#tipoPago').is(':checked') && consultaFil == 0) {
			mensajeSis("Agregar por lo menos un Esquema para el Seguro de Vida.");
			$('#tipoTransaccionGrid').val(0);
			deshabilitaBoton('graba');
			$('#agregar').focus();
		}else{
			$('#productCreditoID').val(productoCredOID);
			$('#tipoTransaccionGrid').val(tipoTransaccionGrid.alta);
			$('#tipoTransaccion').val(0);
		}
	});


	$('#grabar').click(function() {
		$('#productCreditoID').val(productoCredOID);
		$('#tipoTransaccionGrid').val(tipoTransaccionGrid.actualizar);
		$('#tipoTransaccion').val(0);

	});

	$('#ahoVoluntario').click(function() {
		if($('#ahoVoluntario').val() == 'S'){
			$('#mto').show();
			$('#porAhoVol').show();

		}
		if($('#ahoVoluntario').val() == 'N'){
			$('#mto').hide();
			$('#porAhoVol').hide();
			$('#porAhoVol').val(0);
		}
	});

	$('#montoMaximo').blur(function() {
		if (validaMontoMaximo(this.id) == false){
			mensajeSis("El Monto Mínimo no debe ser Mayor al Máximo");
			$('#montoMaximo').focus();
			$('#montoMaximo').select();
		}
	});

	$('#montoMinimo').blur(function() {
		if (validaMontoMinimo(this.id) == false && $('#montoMaximo').val()!=0){
			mensajeSis("El Monto Mínimo no debe ser Mayor al Máximo");
			$('#montoMinimo').focus();
			$('#montoMinimo').select();
		}
	});

	$('#producCreditoID').blur(function() {
		habilitaControl('unico');
		habilitaControl('tipoPago');
		habilitaControl('factorRiesgoSeguro');
		inicializaGrupalesIntegrantes();
		validaProductoCredito(this.id);

	});



	$('#factorRiesgoSeguro').blur(function() {
		var factorSeg = $('#factorRiesgoSeguro').val();
		$('#factorRiesgoSeg').val(factorSeg);
	});

	$('#tipoPagoSeguro').blur(function() {
		var tipoPagoSegu = $('#tipoPagoSeguro').val();
		$('#tipoPagoSeg').val(tipoPagoSegu);

	});

	$('#descuentoSeguro').blur(function() {
		var desSegu = $('#descuentoSeguro').val();
		$('#descSeguro').val(desSegu);
	});

	$('#montoPolSegVida').blur(function() {
		var montPolSegu = $('#montoPolSegVida').val();
		$('#montoPol').val(montPolSegu);
	});



	$('#producCreditoID').bind('keyup',function(e){
		lista('producCreditoID', '2', '10', 'descripcion', $('#producCreditoID').val(), 'listaProductosCredito.htm');
	});

	$('#clasificacion').blur(function(){
		consultaDescripClaRepReg(this.id);
	});

	$('#tipoContratoBC').blur(function() {
		consultaTipoContrato(this.id);
	});


	$('#clasificacion').bind('keyup', function(e){

		lista('clasificacion', '2', '1', 'descripcion', $('#clasificacion').val(), 'listaClasRepReg.htm' );

	});



	$('#tipoContratoBC').bind('keyup',function(e){
		if(this.value.length >= 2){ var camposLista = new Array(); var
		parametrosLista = new Array(); camposLista[0] = "descripcion";
		parametrosLista[0] = $('#tipoContratoBC').val();
		listaAlfanumerica('tipoContratoBC', '1', '1', camposLista, parametrosLista, 'listaTipoContrato.htm');
		};});


	$('#tipoContratoCCID').blur(function() {
		consultaTipoContratoCirculoCredito(this.id);
	});

	$('#tipoContratoCCID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "descripcion";
			parametrosLista[0] = $('#tipoContratoCCID').val();
			listaAlfanumerica('tipoContratoCCID', '1', '1', camposLista, parametrosLista, 'listaCirculoCreTipCon.htm');
		};
	});

	$('#institutFondID').bind('keyup',function(e){
		//lista('institutFondID', '2', '1', 'descripFondeo', $('#institutFondID').val(), 'intitutFondeoLista.htm');
		lista('institutFondID', '2', '1', 'nombreInstitFon', $('#institutFondID').val(), 'intitutFondeoLista.htm');

	});

	$('#institutFondID').blur(function() {
		consultaInstitucionFondeo(this.id);
	});

	$('#garantizado').blur(function() {
		if($('#garantizado').val() == 'S'){
			$('#porcGarLiq').removeAttr('disabled');
		}else{
			$('#porcGarLiq').attr('disabled','disabled');
			$('#porcGarLiq').val('');
		}
	});

	$('#esGrupal').change(function() { //se inicializan las varables grupales cuando cambia el estado de grupal

		if($('#esGrupal').val() == 'N'){
			inicializaGrupalesIntegrantes();
			deshabilitagrupales();
		}
		if($('#esGrupal').val() == 'S'){
			inicializaGrupalesIntegrantes();
			habilitagrupales();
			$('#inicioAfuturoNo').attr("checked",true);
			$('#tdDiasMaximo').hide(400);
			$('#labelDiasMaximo').html('');
			$('#diasMaximo').val('0');
		}
	});

	//--------------------AJUSTE REQUIERE GARANTIA-----------------------------
	$('#requiereGarantia').change(function() {
		validaGarantia();
	});

	//--------------------AJUSTE PROCESO VALIDACIÓN AVALES---------------------
	$('#requiereAvales').change(function() {
		validaAvales();
	});

	$('#requiereReferencias').change(function() {
		validaReferencias();
	});

	//AVALES CRUZADOS
	$('#perAvaCruzados').change(function() {
		permiteInterAvales();
	});
	$('#perAvaCruzados').blur(function() {
		permiteInterAvales();
	});

	//	Seguro de vida
	$('#reqSeguroVida').click(function() {

		$('#reqSeguroVida').attr("disabled",false);
		$('#reqSeguroVida2').attr("disabled",false);
		$('#grabar').show();

		habilitaControl('unico');
		habilitaControl('tipoPago');
		habilitaControl('tipoPagoSeguro');
		habilitaControl('descuentoSeguro');
		habilitaControl('factorRiesgoSeguro');
		habilitaControl('montoPolSegVida');


		var siSeguro= $('#reqSeguroVida').val();
		var tipoPa = 	$('#tipoPagoSeguro').val();
		$('#reqSeguroV').val('S');

		$('#reqSeguroVida').attr("checked",true);
		$('#reqSeguroVida2').attr("checked",false);
		$('#unico').attr("checked",true);
		$('#tipoPago').attr("checked",false);
		$('#modalid').val('U');

		$('#divGrid').hide();
		$('#Seguro1').show();
		$('#Seguro2').show();
		$('#Seguro3').show();

		$('#tipoPagoSeguro').val('');
		$('#factorRiesgoSeguro').val('');
		$('#descuentoSeguro').val('');
		$('#montoPolSegVida').val('');
		$('#factorRiesgoSeguro').focus();
		validasiSegurodeVida('S');
		$('#unico').focus();
		$('#tipoPagoSeg').val(tipoPa);
	});

	$('#reqSeguroVida2').click(function() {
		var noSeguro = $('#reqSeguroVida2').val();
		$('#reqSeguroV').val('N');

		$('#divGrid').hide();
		$('#Seguro1').show();
		$('#Seguro2').show();
		$('#Seguro3').show();


		$('#reqSeguroVida2').attr("checked",true);
		$('#reqSeguroVida').attr("checked",false);
		$('#unico').attr("checked",false);
		$('#tipoPago').attr("checked",false);
		validasiSegurodeVida('N');
	});

	$('#permitePrepago').change(function(){
		var permitePrepago=$('#permitePrepago').val();
		if(permitePrepago == "S"){
			$('#prepago').show();
			$('#tipoPrepago').val('U');
		}else{
			$('#prepago').hide();
			$('#modificarPrepago2').attr("checked",true);
			$('#tipoPrepago').val('');
		}
	});


	$('#manejaLinea').change(function() {
		var numProdCredito = $('#producCreditoID').val();
		var manejaLinea = $('#manejaLinea').val();
		if(productoCredito == 'N'){
			if(manejaLinea == 'N'){
				$('#esRevolvente').val('N');
				$('#afectacionContable').val('N');
				$('#esRevolvente').attr('disabled', true);
				$('#afectacionContable').attr('disabled', true);
			}else{
				$('#esRevolvente').val('S');
				$('#afectacionContable').val('S');
				$('#esRevolvente').attr('disabled', false);
				$('#afectacionContable').attr('disabled', false);
			}
		} else{if(productoCredito == 'C'){
			if(manejaLinea == 'N'){
				$('#esRevolvente').val('N');
				$('#afectacionContable').val('N');
				$('#esRevolvente').attr('disabled', true);
				$('#afectacionContable').attr('disabled', true);
			}else{
				$('#esRevolvente').attr('disabled', false);
				$('#afectacionContable').attr('disabled', false);
			}
		}}

	});
	$('#inicioAfuturoSi').click(function() {
		if($("#esGrupal").val() == 'N'){
			$('#tdDiasMaximo').show(400);
			$('#labelDiasMaximo').html('D&iacute;as M&aacute;ximos Permitidos:');
			$('#diasMaximo').val('');
		}
		else{
			mensajeSis('La Condición No Aplica para Productos de Crédito Grupal.');
			$('#inicioAfuturoNo').attr("checked",true);
		}
	});
	$('#inicioAfuturoNo').click(function() {
		$('#tdDiasMaximo').hide(400);
		$('#labelDiasMaximo').html('');
		$('#diasMaximo').val('0');
	});
	$('#diasMaximo').blur(function () {
		$('#diasMaximo').formatCurrency({
			positiveFormat : '%n',
			negativeFormat : '%n',
			roundToDecimalPlace : 0
		});
	});


	$('#unico').click(function() {
		$('#modalid').val('U');
		$('#reqSeguroV').val('S');

		var tipoPagoSegur = $('#tipoPagoSeguro').val();
		$('#tipoPagoSeg	').val(tipoPagoSegur);

		$('#unico').attr("checked",true);
		$('#tipoPago').attr("checked",false);
		$('#grabar').show();

		if(factorR == 0.000000){
			$('#factorRiesgoSeguro').val('');
		}
		if(descuentoS == 0.00){
			$('#descuentoSeguro').val('');
		}
		if(MontoP == 0.00){
			$('#montoPolSegVida').val('');
		}
		habilitaBoton('grabar');
		validasiSegurodeVida('S');
		$('#factorRiesgoSeguro').focus();
	});

	$('#tipoPago').click(function() {
		$('#modalid').val('T');
		$('#reqSeguroV').val('S');
		$('#unico').attr("checked",false);
		$('#tipoPago').attr("checked",true);
		validasiSegurodeVida('S');
		$('#agregar').focus();
	});


	$('#producCreditoID').focus();

	$('#reqConsolidacionAgro').change(function() {
		if( $('#reqConsolidacionAgro').val() == 'S' ){
			mostrarFechaDesembolso(1, "");
		} else{
			mostrarFechaDesembolso(0, "");
		}
	});

	//------------ Validaciones de la Forma -------------------------------------

	function mostrarFechaDesembolso(tipoOperacion, asignaValor){
		if( tipoOperacion == 1){
			$('#fechaDesembolso').show();
			$('#lblFechaDesembolso').show();

			if( asignaValor == ""){
				$('#fechaDesembolso').val("");
			}

		} else {
			$('#fechaDesembolso').hide();
			$('#lblFechaDesembolso').hide();
			$('#fechaDesembolso').val("N");
		}
	}


	$('#formaGenerica').validate({
		ignore: ":hidden",
		rules: {

			producCreditoID: {
				required: true
			},
			descripcion: {
				required: true
			},
			factorMora: {
				required: true,
				numeroPositivo: true
			},

			montoComXapert: {
				required: true,
				numeroPositivo: false
			},
			clasificacion: {
				required: true
			},
			cantidadAvales: {
				required: function() {return $('#perAvaCruzados').val() == 'S' ;},
				number: true,
				maxlength:10
			},
			//
			montoMinimo: {
				required: true,
				number: true,
				maxlength:16
			},
			montoMaximo: {
				required: true,
				number: true,
				maxlength:16
			},
			margenPagIgual: {
				required: true,
				numeroPositivo: true
			},
			graciaFaltaPago: {
				required: true,
				numeroPositivo: true
			},
			graciaMoratorios: {
				required: true,
				numeroPositivo: true
			},
			diasSuspesion: {
				required: true,
				numeroPositivo: true
			},
			porAhoVol: {
				required: function() {return $('#ahoVoluntario').val()=='S';},
				numeroPositivo: true
			},

			tipoContratoBCID: {
				required: true
			},
			relGarantCred: {
				required: function() {return $('#requiereGarantia').val()=='S' || $('#requiereGarantia').val()=='I';}
			},
			perAvaCruzados: {
				required: function() {return $('#requiereAvales').val()=='S' || $('#requiereAvales').val()=='I' ;}
			},
			perGarCruzadas: {
				required: function() {return $('#requiereGarantia').val()=='S' || $('#requiereGarantia').val()=='I';}
			}
			,
			registroRECA: {
				required: function() {return $('#registroRECA').val()=='' && isNullFullRECA();}
			}
			,
			fechaInscripcion: {
				required: function() {return isNullFullRECA() && $('#fechaInscripcion').val()== '';}
			}
			,
			nombreComercial: {
				required: function() {return isNullFullRECA() && $('#nombreComercial').val()== '';}
			},
			tipoCredito: {
				required: function() {return isNullFullRECA() && $('#tipoCredito').val()== '';}
			}
			,
			minimoIntegrantes: {
				required: function() {return $('#esGrupal').val() == 'S' ;}
			}
			,
			maximoIntegrantes: {
				required: function() {return $('#esGrupal').val() == 'S'; }
			}
			,
			minHombres: {
				required: function() {return $('#esGrupal').val() == 'S';}
			}
			,
			maxHombres: {
				required: function() {return $('#esGrupal').val() == 'S';}
			}
			,
			minMujeres: {
				required: function() {return $('#esGrupal').val() == 'S';}
			}
			,
			maxMujeres: {
				required: function() {return $('#esGrupal').val() == 'S';}
			}
			,
			minMujeresSol: {
				required: function() {return $('#esGrupal').val() == 'S' ;}
			}
			,
			maxMujeresSol: {
				required: function() {return $('#esGrupal').val() == 'S';}
			}
			,
			raIniCicloGrup: {
				required: function() {return $('#esGrupal').val() == 'S'; }
			},
			raFinCicloGrup: {
				required: function() {return $('#esGrupal').val() == 'S'; }
			},
			porcMaxCapSoc:{
				number: true
			},
			inicioAfuturo: {
				required : true
			},
			diasMaximo: {
				required:function() {return $('#inicioAfuturoSi').is(':checked');}
			},
			esReestructura: {
				required : true
			},
			permiteAutSolPros: {
				required : true
			},
			requiereReferencias: {
				required : true
			},
			minReferencias:{
				required : function() {return $('#requiereReferencias').val() == 'S'; }
			},
			calcInteres : {
				required : true
			},
			claveRiesgo : {
				required : true
			},
			tipoCalInteres : {
				required : true
			},
			claveCNBV: {
				validaCNBV : true
			},
			requiereCheckList: {
				required : true
			},
			reqConsolidacionAgro: {
				required : true
			},
			fechaDesembolso:{
				required : function() {return $('#reqConsolidacionAgro').val() == 'S'; }
			}
		},
		messages: {

			producCreditoID: {
				required: 'Introduzca Numero del Producto de Credito'
			},

			descripcion: {
				required: 'Especifique una descripción'
			},
			factorMora: {
				required: 'Especificar Factor Mora',
				numeroPositivo: 'Cantidad Incorrecta'
			},
			clasificacion: {
				required: 'Especificar Clasificación'
			},
			cantidadAvales: {
				required: 'Especificar Cantidad de Avales',
				number: 'Cantidad Incorrecta',
				maxlength:'Maximo 10 Numeros'
			},
			//
			montoMinimo: {
				required: 'Especificar Monto Máximo',
				numeroPositivo: 'Cantidad Incorrecta',
				maxlength:'Maximo 12 Numeros'
			},
			montoMaximo: {
				required: 'Especificar Monto Mínimo',
				number: 'Cantidad Incorrecta',
				maxlength:'Máximo 12 Números'
			},

			montoComXapert: {
				required: 'Especificar Monto Máximo',
				numeroPositivo: 'Cantidad Incorrecta'
			},
			margenPagIgual: {
				required: 'Especificar Margen Pagos',
				numeroPositivo: 'Cantidad Incorrecta'
			},
			graciaFaltaPago: {
				required: 'Especificar Días de Gracia',
				numeroPositivo: 'Cantidad Incorrecta'
			},
			graciaMoratorios: {
				required: 'Epecificar Días de Gracia Moratorios',
				numeroPositivo: 'Cantidad Incorrecta'
			},
			diasSuspesion: {
				required: 'Especificar Días de Suspensión',
				numeroPositivo: 'Cantidad Incorrecta'
			},
			porAhoVol: {
				required: 'Especificar Monto ',
				numeroPositivo: 'Cantidad Incorrecta'
			},

			tipoContratoBCID: {
				required: 'Especificar Tipo de Contrato'
			},
			perRompimGrup: {
				required: 'Especificar Si Permite'
			},
			relGarantCred: {
				required: 'Especificar Relación Garantía'
			},
			perAvaCruzados: {
				required: 'Especificar Permite Avales'
			},
			perGarCruzadas: {
				required: 'Especificar Permite Garantía'
			},
			registroRECA: {
				required: 'Especificar No. Registro RECA'
			}
			,
			fechaInscripcion: {
				required: 'Especificar Fecha Inscripción'
			}
			,
			nombreComercial: {
				required: 'Especificar Nombre Comercial'
			},
			tipoCredito:{
				required: 'Especificar Tipo Crédito'
			}
			,
			minimoIntegrantes: {
				required: 'Especificar el mínimo de integrantes',
				numeroPositivo: 'Cantidad Incorrecta'
			}
			,
			maximoIntegrantes: {
				required: 'Especificar el mínimo de integrantes',
			}
			,
			minHombres: {
				required: 'Especificar el mínimo de hombres',
				numeroPositivo: 'Cantidad Incorrecta'}
			,
			maxHombres: {
				required: 'Especificar el máximo de hombres',
				numeroPositivo: 'Cantidad Incorrecta'			}
			,
			minMujeres: {
				required: 'Especificar el mínimo de mujeres',
				numeroPositivo: 'Cantidad Incorrecta'			}
			,
			maxMujeres: {
				required: 'Especificar el máximo de mujeres',
				numeroPositivo: 'Cantidad Incorrecta'			}
			,
			minMujeresSol: {
				required: 'Especificar el mínimo de mujeres solteras',
				numeroPositivo: 'Cantidad Incorrecta'			}
			,
			maxMujeresSol: {
				required: 'Especificar el máximo de mujeres mujeres',
				numeroPositivo: 'Cantidad Incorrecta'			}
			,
			raIniCicloGrup: {
				required: 'Especificar el Rango Inicial Ciclo Grupal',
				numeroPositivo: 'Cantidad Incorrecta'			}
			,
			raFinCicloGrup: {
				required: 'Especificar el Rango Final Ciclo Grupal',
				numeroPositivo: 'Cantidad Incorrecta'			},
			porcMaxCapSoc:{
				number: 'Solo Números'
			},
			inicioAfuturo: {
				required : 'Especificar'
			},
			diasMaximo: {
				required: 'Especifica Días'
			},
			esReestructura: {
				required : 'Especificar'
			},
			permiteAutSolPros: {
				required : 'Especificar'
			},
			requiereReferencias: {
				required : 'Especificar'
			},
			minReferencias: {
				required : 'Especificar'
			},
			calcInteres : {
				required : 'Especificar el Cálculo de Interés.'
			},
			claveRiesgo : {
				required : 'Especificar el Nivel de Riesgo.'
			},
			tipoCalInteres : {
				required : 'Especificar el Tipo Cálculo de Interés.'
			},
			requiereCheckList: {
				required : 'Especificar Requiere CheckList.'
			},
			reqConsolidacionAgro: {
				required : 'Especificar Requiere Consolidación.'
			},
			fechaDesembolso:{
				required : 'Especificar Fecha Desembolso.'
			}
		}
	});



	$('#formaGenerica1').validate({
		rules: {

			factorRiesgoSeguro:{
				required:function() {return $('#reqSeguroVida').is(':checked') && $('#unico').is(':checked');}
			},

			montoPolSegVida:{
				required:function() {return $('#reqSeguroVida').is(':checked') && $('#unico').is(':checked');}
			},

			descuentoSeguro:{
				required:function() {return $('#reqSeguroVida').is(':checked') && $('#unico').is(':checked');}
			},
		},
		messages: {

			factorRiesgoSeguro:{
				required: 'Especificar Factor de Riesgo.'
			},
			montoPolSegVida:{
				required: 'Especificar Monto de Poliza.'
			},
			descuentoSeguro:{
				required: 'Especificar Descuento de Seguro.'
			}
		}
	});


	//------------ Validaciones de Controles -------------------------------------


	function validaMontoMaximo(control) {
		var valorMinimo = $('#montoMinimo').asNumber();
		var valorMaximo = $('#montoMaximo').asNumber();

		var valida = true;
		if(esTab && (valorMinimo > valorMaximo)){
			valida = false;
		}
		return valida;
	}
	function validaMontoMinimo(control) {
		var valorMinimo = $('#montoMinimo').asNumber();
		var valorMaximo = $('#montoMaximo').asNumber();
		var valida = true;

		if(esTab && (valorMinimo > valorMaximo)){
			valida = false;
		}
		return valida;
	}


	function validaProductoCredito(control) {
		var numProdCredito = $('#producCreditoID').val();
		var No = 'N';
		var Si = 'S';
		$('#prepago').hide();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numProdCredito != '' && !isNaN(numProdCredito) && esTab){
			deshabilitagrupales();

			if(numProdCredito=='0'){
				habilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');
				deshabilitaBoton('grabar', 'submit');
				$('#tipoPagoSeg').val('');

				inicializaForma('formaGenerica','producCreditoID' );
				inicializaForma('formaGenerica1','reqSeguroVida' );

				limpiaForma();
				limpiaFormaSeguro();

				limpiarDatos();

				$('#producCreditoID').val("");
				$('#producCreditoID').focus();


			}else {
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				var prodCreditoBeanCon = {
						'producCreditoID':$('#producCreditoID').val()
				};
				productosCreditoServicio.consulta(catTipoProductoCredito.principal,prodCreditoBeanCon,function(prodCred) {

					if(prodCred!=null){
						if(prodCred.esAgropecuario==Enum_Constantes.SI){
							productoCredOID = prodCred.producCreditoID;
							$('#reqSeguro').val(prodCred.reqSeguroVida);
							$('#reqSeguroV').val(prodCred.reqSeguroVida);
							$('#modalid').val(prodCred.modalidad);
							$('#modalidadPago').val(prodCred.modalidad);

							$('#factorRiesgoSeg').val(prodCred.factorRiesgoSeguro);
							$('#tipoPagoSeg').val(prodCred.tipoPagoSeguro);
							$('#descSeguro').val(prodCred.descuentoSeguro);
							$('#montoPol').val(prodCred.montoPolSegVida);
							$('#claveCNBV').val(prodCred.claveCNBV);

							productoCredito = 'C';
							deshabilitaBoton('agrega', 'submit');
							habilitaBoton('modifica', 'submit');
							dwr.util.setValues(prodCred);
							$('#esRevolvente').val('N');
							$('#afectacionContable').val('N');
							$('#manejaLinea').val('N');

							if(prodCred.permitePrepago == 'S')
								$('#prepago').show();
							else
								$('#prepago').hide();
							if(prodCred.modificarPrepago=='S')
								$('#modificarPrepago').attr("checked",true);
							else
								$('#modificarPrepago2').attr("checked",true);
							//Establece Formato Controles

							if(prodCred.fechaInscripcion == '1900-01-01'){

								$('#fechaInscripcion').val('');

							}

							actualizaFormatosMoneda('formaGenerica');

							if(prodCred.ahoVoluntario=='S'){
								$('#mto').show();
								$('#porAhoVol').show();
							}
							if(prodCred.ahoVoluntario=='N'){
								$('#mto').hide();
								$('#porAhoVol').hide();
								$('#porAhoVol').val(0);

							}

							if( $('#reqConsolidacionAgro').val() == 'S' ){
								mostrarFechaDesembolso(1, prodCred.fechaDesembolso);
							} else{
								mostrarFechaDesembolso(0, "");
							}

							esTab=true;
							$('#clasificacion').val(prodCred.clasificacion);
							consultaDescripClaRepReg('clasificacion');

							$('#calcInteres').val(prodCred.calcInteres);
							consultaTasaBase(prodCred.calcInteres);
							muestraCamposTasa(prodCred.calcInteres);
							consultaTipoContrato('tipoContratoBC');
							consultaTipoContratoCirculoCredito('tipoContratoCCID');
							consultaInstitucionFondeo('institutFondID');
							$('#esGrupal').val(prodCred.esGrupal).change();
							if(prodCred.esGrupal== 'S'){
								max = Number(prodCred.maxIntegrantes);
								min = Number(prodCred.minIntegrantes);
								maxh = Number(prodCred.maxHombres);
								minh = Number(prodCred.minHombres);
								maxm = Number(prodCred.maxMujeres);
								minm = Number(prodCred.minMujeres);
								maxms = Number(prodCred.maxMujeresSol);
								minms = Number(prodCred.minMujeresSol);
								$('#tasaPonderaGru').val(		prodCred.tasaPonderaGru);
								$('#perRompimGrup').val(		prodCred.perRompimGrup);
								$('#raIniCicloGrup').val(		prodCred.raIniCicloGrup);
								$('#raFinCicloGrup').val(		prodCred.raFinCicloGrup);
								habilitagrupales();
								muestraGrupalesIntegrantes();
							}
							else{deshabilitagrupales();}

							factorR	   = prodCred.factorRiesgoSeguro;
							descuentoS = prodCred.descuentoSeguro;
							MontoP 	   = prodCred.montoPolSegVida;
							$('#mostrarReqReferencias1').hide();
							if (prodCred.reqSeguroVida == 'S') {
								$('#reqSeguroVida').attr("checked",true);
								$('#reqSeguroVida2').attr("checked",false);
								modalidad = prodCred.modalidad;

								if(prodCred.modalidad == 'U'){
									$('#unico').attr("checked", true);
									$('#tipoPago').attr("checked", false);
									$('#grabar').show();
									habilitaBoton('grabar', 'submit');

									habilitaControl('unico');
									habilitaControl('tipoPago');
									habilitaControl('tipoPagoSeguro');
									habilitaControl('descuentoSeguro');
									habilitaControl('montoPolSegVida');
									validasiSegurodeVida('S');
									habilitaBoton('grabar', 'submit');

								}else{
									if(prodCred.modalidad == 'T'){
										$('#unico').attr("checked", false);
										$('#tipoPago').attr("checked", true);
										habilitaControl('unico');
										habilitaControl('tipoPago');
										mostrarGridEsquemas(productoCredOID);

									}else{
										$('#unico').attr("checked", false);
										$('#tipoPago').attr("checked", false);
									}
									validasiSegurodeVida('S');
								}
							}
							else{
								$('#reqSeguroVida2').attr("checked",true);
								$('#reqSeguroVida').attr("checked",false);
								$('#unico').attr("checked", false);
								$('#tipoPago').attr("checked", false);
								deshabilitaBoton('grabar', 'submit');
								validasiSegurodeVida('N');
							}



							if(prodCred.inicioAfuturo == 'S'){
								$('#labelDiasMaximo').html('D&iacute;as M&aacute;ximos Permitidos:');
								$('#tdDiasMaximo').show();
								$('#tdDiasMaximo').val(prodCred.diasMaximo);
							}else{
								$('#labelDiasMaximo').html('');
								$('#tdDiasMaximo').hide();
								$('#diasMaximo').val('0');
							}

							if(prodCred.requiereGarantia == No){
								$('#perGarCruzadas').attr('disabled','disabled');
							}else {
								$('#perGarCruzadas').attr('disabled', false);
							}

							if(prodCred.requiereAvales == No){
								$('#perAvaCruzados').attr('disabled','disabled');
								$('#intercambioAvalesRatioSi').attr('disabled','disabled');
								$('#intercambioAvalesRatioNo').attr('disabled',false);
							}else {
								$('#perAvaCruzados').attr('disabled', false);
								$('#intercambioAvalesRatioSi').removeAttr('disabled');
							}

							if(prodCred.perAvaCruzados == Si){
								$('#cantidadAvales').removeAttr('disabled');
							}else {
								$('#cantidadAvales').attr('disabled','disabled');
							}

							if(prodCred.financiamientoRural == 'S'){
								$('#financiamientoRural1').attr("checked",true);
								$('#financiamientoRural2').attr("checked",false);
							}
							else{
								$('#financiamientoRural1').attr("checked",false);
								$('#financiamientoRural2').attr("checked",true);
							}

							validaReferencias();
							$('#calculoRatios2').attr("checked",true);
						}else{
							deshabilitaBoton('modifica', 'submit');
							deshabilitaBoton('agrega', 'submit');
							deshabilitaBoton('grabar', 'submit');
							inicializaForma('formaGenerica','producCreditoID' );
							inicializaForma('formaGenerica1','reqSeguroVida' );
							$('#reqSeguro').val('N');
							limpiaForma();
							limpiaFormaSeguro();
							limpiarDatos();
							mensajeSis('El Producto de Crédito no es Agropecuario.');
							$('#producCreditoID').select();
						}
					}else{
						productoCredito = 'N';
						deshabilitaBoton('modifica', 'submit');
						habilitaBoton('agrega', 'submit');
						habilitaBoton('grabar', 'submit');
						inicializaForma('formaGenerica','producCreditoID' );
						inicializaForma('formaGenerica1','reqSeguroVida' );
						$('#reqSeguro').val('N');
						limpiaForma();
						limpiaFormaSeguro();

						limpiarDatos();

					}


					if ( $("#validaCapConta").val()==No){
						$("#porcMaxCapConta").attr('disabled', true);
						$("#porcMaxCapConta").val(0);
					}


					if ( $("#validaCapConta").val()==Si){
						$("#porcMaxCapConta").attr('disabled', false);
					}

				});
			}
		}
	}



	function consultaDescripClaRepReg(idControl){
		var jqClasific  = eval("'#" + idControl + "'");
		var Clasific = $(jqClasific).val();
		var clasificBeanCon = {
				'clasifRegID': Clasific
		};
		if(Clasific != '' && !isNaN(Clasific) && esTab){

			clasifrepregServicio.consulta(catTipoProductoCredito.principal, clasificBeanCon, function(ClasificRep){

				if(ClasificRep!=null){

					$('#descripClasifica').val(ClasificRep.descripcion);
					$('#tipo').val(ClasificRep.segmento);

					esTab=true;
				}else{
					mensajeSis("No Existe la Clasificación");
					$('#clasificacion').focus();
					$('#clasificacion').select();
				}
			});
		}

	}




	//----------Funcion consultaTipoContratoBC---------------------//
	function consultaTipoContrato(idControl) {
		var jqTipCont = eval("'#" + idControl + "'");
		var numTipoCont = $(jqTipCont).val();
		var conTipCont = 1;
		var TipoContratoBCBeanCon = {
				'tipoContratoBCID':numTipoCont
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numTipoCont != ''  && esTab) {
			tipoContratoBCServicio.consulta(conTipCont,
					TipoContratoBCBeanCon, function(contrato) {
				if (contrato != null) {
					$('#descContrato').val(contrato.descripcion);
				}
				else{
					mensajeSis("No existe el Contrato "+ numTipoCont);
					$('#descContrato').val("");
					$('#tipoContratoBC').focus();
					$('#tipoContratoBC').select();
				}
			});
		}
	}


	//----------Funcion consultaTipoContratoBC---------------------//
	function consultaTipoContratoCirculoCredito(idControl) {
		var jqTipCont = eval("'#" + idControl + "'");
		var numTipoCont = $(jqTipCont).val();
		var conTipCont = 1;
		var TipoContratoBCBeanCon = {
				'tipoContratoCCID':numTipoCont
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numTipoCont != ''  && esTab) {
			circuloCreTipConServicio.consulta(conTipCont,
					TipoContratoBCBeanCon, function(contrato) {
				if (contrato != null) {
					$('#tipoContratoCCIDDes').val(contrato.descripcion);
				}
				else{
					mensajeSis("No Existe el Contrato "+ numTipoCont);
					$('#tipoContratoCCIDDes').val("");
					$('#tipoContratoCCID').focus();
					$('#tipoContratoCCID').select();
				}
			});
		}
	}


	function consultaInstitucionFondeo(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		var instFondeoBeanCon = {
				'institutFondID':numInstituto
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numInstituto != '' && !isNaN(numInstituto) && esTab){
			fondeoServicio.consulta(catTipoProductoCredito.foranea,instFondeoBeanCon,function(instituto) {
				if(instituto!=null){
					$('#descripFondeo').val(instituto.nombreInstitFon);

				}else{
					mensajeSis("No Existe la Institución");
					$('#institutFondID').focus();
					$('#institutFondID').select();
					$('#institutFondID').val('');
					$('#descripFondeo').val('');
				}
			});
		}else{
			$('#descripFondeo').val('');
		}
	}



	function validasiSegurodeVida(valor){
		$('#reqSeguro').val(valor);
		if(valor == 'S'){
			$('#unico').attr('disabled',false);
			$('#tipoPago').attr('disabled',false);

			if($('#unico').is(':checked')) {
				$('#divGrid').hide(400);
				$('#Seguro1').show();
				$('#Seguro2').show();
				$('#Seguro3').show();
				$('#modalid').val('U');

				habilitaControl('unico');
				habilitaControl('tipoPago');
				habilitaControl('tipoPagoSeguro');
				habilitaControl('descuentoSeguro');
				habilitaControl('factorRiesgoSeguro');
				habilitaControl('montoPolSegVida');

				$('#modalidadPago').val('U');
				habilitaBoton('grabar', 'submit');


			}else{
				$('#modalid').val('T');
				$('#divGrid').show(400);
				mostrarGridEsquemas(productoCredOID);
				$('#Seguro1').hide();
				$('#Seguro2').hide();
				$('#Seguro3').hide();
				$('#modalidadPago').val('T');

				$('#esquemaSegVidID').val(0);
				$('#factorRiesgoSeg').val('');
				$('#tipoPagoSeg').val('');
				$('#descSeguro').val('');
				$('#montoPol').val('');

				$('#factorRiesgoSeguro').val('');
				$('#tipoPagoSeguro').val('');
				$('#descuentoSeguro').val('');
				$('#montoPolSegVida').val('');

			}

		}else{
			$('#modalid').val('');
			$('#modalidadPago').val('');
			$('#divGrid').hide();
			$('#Seguro1').show();
			$('#Seguro2').show();
			$('#Seguro3').show();

			deshabilitaControl('unico');
			deshabilitaControl('tipoPago');
			deshabilitaControl('tipoPagoSeguro');
			deshabilitaControl('descuentoSeguro');
			deshabilitaControl('factorRiesgoSeguro');
			deshabilitaControl('montoPolSegVida');

			$('#tipoPagoSeguro').val('');
			$('#factorRiesgoSeguro').val('');
			$('#descuentoSeguro').val('');
			$('#montoPolSegVida').val('');

			$('#factorRiesgoSeg').val('');
			$('#tipoPagoSeg').val('');
			$('#descSeguro').val('');
			$('#montoPol').val('');
		}
	}





	// Carga Grid, funcion para consultar los esquemas de Seguro de vida para un prodcuto de credito */
	function mostrarGridEsquemas(producCreditoID){
		var numFilas;
		var params = {};
		params['tipoLista'] = 2;
		params['productCreditoID'] = producCreditoID;

		$.post("esquemaSeguroVidaGridVista.htm", params, function(esquemas){

			if(esquemas.length >0) {
				$('#tablaGrid').html(esquemas);
				agregaFormatoControles('formaGenerica1');
				numFilas = consultaFilas();
				if(parseInt(numFilas)>0){
					habilitaBoton('graba');

					filas = numFilas;
					if(parseInt(numFilas) == 4){
						deshabilitaBoton('agregar');

					}
				}
			}else{
				$('#tablaGrid').html("");
				$('#tablaGrid').hide();

			}
		});

	}

});




//validaciones en grupales
//Inicializa tanto los datos de pantalla como variables globales
function inicializaGrupalesIntegrantes(){
	min = 0;
	max = 0;
	minh = 0;
	maxh = 0;
	minm = 0;
	maxm = 0;
	minms = 0;
	maxms = 0;
	$('#minimoIntegrantes').val(min);
	$('#maximoIntegrantes').val(max);
	$('#minHombres').val(minh);
	$('#maxHombres').val(maxh);
	$('#minMujeres').val(minm);
	$('#maxMujeres').val(maxm);
	$('#minMujeresSol').val(minms);
	$('#maxMujeresSol').val(maxms);
}
//Inicializa tanto los datos de pantalla como variables globales
function obtenGrupalesIntegrantes(){
	min = Number($('#minimoIntegrantes').val());
	max = Number($('#maximoIntegrantes').val());
	minh = Number($('#minHombres').val());
	maxh = Number($('#maxHombres').val());
	minm = Number($('#minMujeres').val());
	maxm = Number($('#maxMujeres').val());
	minms = Number($('#minMujeresSol').val());
	maxms = Number($('#maxMujeresSol').val());

}
//muestra los valores de las varibles globlales a pantalla
function muestraGrupalesIntegrantes(){
	$('#minimoIntegrantes').val(min);
	$('#maximoIntegrantes').val(max);
	$('#minHombres').val(minh);
	$('#maxHombres').val(maxh);
	$('#minMujeres').val(minm);
	$('#maxMujeres').val(maxm);
	$('#minMujeresSol').val(minms);
	$('#maxMujeresSol').val(maxms);
}
//funcion para validar toda la forma de grupales
function validaGrupalIntegrantes(){
	obtenGrupalesIntegrantes();
	var paso = 1;
	if( $('#eMujeres').is(':checked')||$('#eHombres').is(':checked') || min <= max){//verifica que el Maximo de integrantes sea mayor o igual que el Mínimo de integrantes
		paso = 2;
		if	($('#eHombres').is(':checked')||(minm <= max) && (maxm <= max) && ( minm <= maxm ) ){//la misma comparacion que el paso 2 pero con los minimos y maximos de mujeres
			paso = 3;
			if($('#eHombres').is(':checked')||(minms <= maxm) && (maxms <= maxm) && ( minms <= maxms ) )
			{	paso = 4;
			if(	$('#eMujeres').is(':checked')||
					(
							(maxh <= max - minm)&&(maxh >= max - maxm) ||
							max == maxh && max == maxms && max == maxm && minm == 0 && minms == 0) &&  minh <= maxh )
			{	//compara que el mínimo y maximo de integrantes sean mayores al minimo y máximo de hombres y ademas que el maximo de hombres sea mayor que el minimo de integrantes

				paso = 5;

			}
			}
		}
	}
	//son los pasos donde se quedaron y muestra el error segun el paso donde se quedo, se hace el focus para que se modifique el ultimo valor escrito e inicializa todos los demas valores para ayudar a corregir
	if(paso == 4){

		if(maxh>max){
			mensajeSis('El No. Máximo de Hombres no puede ser Mayor al No. Máximo de Integrantes. ' );
			$('#maxHombres').focus();
			$('#maxHombres').select();
			setTimeout("$('#maxHombres').focus().val('0')",0);
		} else
			if(maxh < minh && $('#eHombres').is(':checked')){
				mensajeSis('El No. Mínimo de Hombres no puede ser Mayor al No. Máximo de Hombres.' );
				setTimeout("$('#minHombres').focus().val('0')",0);

			}else
				if(maxh < minh && $('#gMixto').is(':checked')){
					mensajeSis('El No. Mínimo de Hombres no puede ser Mayor al No. Máximo de Hombres.' );
					setTimeout("$('#maxHombres').focus().val('0')",0);

				}else
					if(maxh>max - minm){
						mensajeSis('El No. Máximo de Hombres no puede ser Mayor a ' + Number(max - minm) +' Integrantes. ' );
						setTimeout("$('#maxHombres').focus().val('0')",0);
					}
	}
	if(paso == 3){
		if(maxms>maxm){
			mensajeSis('El No. Máximo de Mujeres Solteras no puede ser Mayor al No. Máximo de Mujeres. ' );
			setTimeout("$('#maxMujeresSol').focus().val('0')",0);
		}
		else{
			if(minms>maxms)
			{mensajeSis('El No. Mínimo de Mujeres Solteras no puede ser Mayor al No. Máximo de Mujeres Solteras. ' );
			}
			else{if(minms>maxm)
			{mensajeSis('El No. Mínimo de Mujeres Solteras no puede ser Mayor al No. Máximo de Mujeres. ' );}
			}
			setTimeout("$('#minMujeresSol').focus().val('0')",0);
		}
	}
	if(paso == 2){
		if (maxm > max){
			mensajeSis('El No. Máximo de Mujeres no puede ser Mayor al No. Máximo de Integrantes\n ');
			setTimeout("$('#maxMujeres').focus().val('0')",0);

		}
		else{
			if((minm > max)){mensajeSis('El No. Mínimo de Mujeres no puede ser Mayor al No. Máximo de Integrantes ');}else
				if(minm > maxm){mensajeSis('El No. Mínimo de Mujeres no puede ser Mayor al No. Máximo de Mujeres ');}
			setTimeout("$('#minMujeres').focus().val('0')",0);
		}

	}

	if(paso == 1 ){
		mensajeSis('El No. Mínimo de Integrantes no puede ser Mayor al Máximo de Integrantes. ' );
		setTimeout("$('#minimoIntegrantes').focus().val('0')",0);
	}

	muestraGrupalesIntegrantes();
	return paso;
}

function deshabilitagrupales(){//deshabilita los campos de grupales
	inicializaGrupalesIntegrantes();
	$('#grupales').hide();
	$('#gMujeres').hide();
	$('#gMujeresS').hide();
	$('#gHombres').hide();
	$('#esGrupal').val('N');
}
function habilitagrupales(){//habilita los campos de grupales
	$('#grupales').show(500);
	if((maxh!=0 && maxm==0)){
		$('#eHombres').click();
	}
	else{
		if((maxh!=0 && maxm!=0)){
			$('#gMixto').click();
		}else{
			$('#eMujeres').click();
		}
	}
}

// eventoparamensaje en RECA
function isNullFullRECA(){
	var regR = $('#registroRECA').val();
	var fechaI = $('#fechaInscripcion').val();
	var nomC = $('#nombreComercial').val();
	var tipC = $('#tipoCredito').val();
	if(		!((regR != '' && fechaI != '' && nomC != '' && tipC != '' )||(regR == '' && (fechaI == ''||fechaI == '1900-01-01') && nomC == '' && tipC == '' )))
	{		return true;	//me dice cuando algo esta es crito en uno o varios campos pero no en todos
	}else{		return false;		}  }

//aqui termina validacion de RECA pedir asesorias de optimisacion de codigo en js


/*funcion valida fecha formato (yyyy-MM-dd)*/
function FechaValida(fecha){

	var fecha2 = parametroBean.fechaSucursal;
	if(fecha == ""){return false;}
	if (fecha != undefined  ){

		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)){
			mensajeSis("formato de fecha no válido (aaaa-mm-dd)");
			return true;
		}

		var mes=  fecha.substring(5, 7)*1;
		var dia= fecha.substring(8, 10)*1;
		var anio= fecha.substring(0,4)*1;
		var mes2=  fecha2.substring(5, 7)*1;
		var dia2= fecha2.substring(8, 10)*1;
		var anio2= fecha2.substring(0,4)*1;
		if(anio>anio2 || anio==anio2&&mes>mes2 || anio==anio2&&mes==mes2&&dia>dia2 ){
			mensajeSis("Fecha introducida es mayor a la actual.");
			return true;
		}

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
		return true;
		}
		if (dia>numDias || dia==0){
			mensajeSis("Fecha introducida errónea.");
			return true;
		}
		return false;
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

function limpiaForma(){
	$('#modificarPrepago2').attr("checked",true);
	$('#permitePrepago').val("");
	$('#tipoPrepago').val("");
	$('#requiereReferencias').val("N");
	$('#mostrarMinReferencias1').hide();
	$('#mostrarMinReferencias2').hide();
	$('#mostrarReqReferencias1').hide();
	$('#requiereCheckList').val("S");
	$('#financiamientoRural').attr("checked",true);
	$('#reqConsolidacionAgro').val("");
	$('#fechaDesembolso').val("");
	muestraCamposTasa(0);
}



/* Agregar una nueva fila al Grid */
function agregarFila(){
	var numeroFila=consultaFilas();
	verificaFilas();
	var nuevaFila = parseInt(numeroFila) + 1;
	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	tds += '<input   type="hidden" id="consecutivoID'+nuevaFila+'" size="6"  value="'+nuevaFila+'" />';
	tds += '<td align="center"><select id="tipoPagoSeguro'+nuevaFila+'" name="ltipoPagoSeguro"  onblur="validaTipPago();" ><option value="">SELECCIONAR</option><option value="A">ADELANTADO</option><option value="F">FINANCIAMIENTO</option><option value="D">DEDUCCION</option><option value="O">OTRO</option></select> </td>';
	tds += '<td align="center"><input  type="text" id="factorRiesgoSeguro'+nuevaFila+'" name="lfactorRiesgoSeguro" size="22"  autocomplete="off" esMoneda="false" style="text-align:right;" seisDecimales="true" onClick="this.focus()"  onblur="validaFactorRiesgo();" /></td>';
	tds += '<td align="center"><input  type="text" id="descuentoSeguro'+nuevaFila+'" name="ldescuentoSeguro" size="22" autocomplete="off" esMoneda="true" style="text-align:right;" onClick="this.focus()" onblur="validaDescuento();" /> <label id="porciento'+nuevaFila+'" class="label">%</label> </td>';
	tds += '<td align="center"><input  type="text" id="montoPolSegVida'+nuevaFila+'" name="lmontoPolSegVida" size="10" value="" autocomplete="off" esMoneda="true" style="text-align:right;" onClick="this.focus()" onblur="validaMontoPoliza();" />	</td>';
	tds += '<td align="center"><input type="button" name="eliminar" id="'+nuevaFila+'"  value="" class="btnElimina" onclick="eliminarFila(this.id)" />';
	tds += '<input type="button" name="agrega" id="agrega'+nuevaFila+'"  value="" class="btnAgrega" onclick="agregarFila(); deshabilarBoton();"/></td>';
	tds += '</tr>';

	$("#miTabla").append(tds);
	habilitaBoton('graba');
	agregaFormatoControles('formaGenerica1');

	return false;
}


/* cuenta las filas de la tabla del grid */
function consultaFilas(){
	var totales=0;
	$('tr[name=renglon]').each(function() {

		totales++;
	});
	filasTotal = totales;
	return totales;
}


function verificaFilas(){
	if(filasTotal == 3){
		deshabilitaBoton('agregar');
		deshabilitaBoton('agrega1');
		deshabilitaBoton('agrega2');
		deshabilitaBoton('agrega3');
		deshabilitaBoton('agrega4');
	}
}

function deshabilarBoton(){
	var filasTo = consultaFilas();
	if(filasTo == 5){
		deshabilitaBoton('agrega4');
		$('#agrega5').remove();
		$('#5').remove();
		$('#montoPolSegVida5').remove();
		$('#descuentoSeguro5').remove();
		$('#factorRiesgoSeguro5').remove();
		$('#tipoPagoSeguro5').remove();
		$('#tipoPagoSeguro5').remove();
		$('#porciento5').remove();
		var esquemaI = $('#lesquemaSeguroID').val();
		eliminarFila5('5',esquemaI);

	}
}


function eliminarFila(control, esquema){
	var confirmar = confirm("Está seguro de Eliminar el Esquema de Seguro de Vida?");
	if (confirmar == true) {

		var contador = 0 ;
		var numeroID = control;
		var filasTotal = consultaFilas();
		if(filasTotal < 5){
			habilitaBoton('agregar');
			habilitaBoton('agrega1');
			habilitaBoton('agrega2');
			habilitaBoton('agrega3');
			habilitaBoton('agrega4');
		}

		eliminar(control, esquema);

		var jqRenglon = eval("'#renglon" + numeroID + "'");
		$(jqRenglon).remove();

		//Reordenamiento de Controles
		contador = 1;
		var numero= 0;
		$('tr[name=renglon]').each(function() {
			//numero =  this.id;
			numero= this.id.substr(7,this.id.length);

			var jqRenglon = eval("'#renglon"+numero+"'");
			var jqNumero = eval("'#consecutivoID"+numero+"'");
			var jqtipoPagoSeguro = eval("'#tipoPagoSeguro"+numero+"'");
			var jqfactorRiesgoSeguro= eval("'#factorRiesgoSeguro"+numero+"'");
			var jqdescuentoSeguro= eval("'#descuentoSeguro"+numero+"'");
			var jqmontoPolSegVida=eval("'#montoPolSegVida"+ numero+"'");
			var jqAgrega=eval("'#agrega"+ numero+"'");
			var jqElimina = eval("'#"+numero+ "'");

			$(jqNumero).attr('id','consecutivoID'+contador);
			$(jqtipoPagoSeguro).attr('id','tipoPagoSeguro'+contador);
			$(jqfactorRiesgoSeguro).attr('id','factorRiesgoSeguro'+contador);
			$(jqdescuentoSeguro).attr('id','descuentoSeguro'+contador);
			$(jqmontoPolSegVida).attr('id','montoPolSegVida'+contador);
			$(jqAgrega).attr('id','agrega'+contador);
			$(jqElimina).attr('id',contador);
			$(jqRenglon).attr('id','renglon'+ contador);
			contador = parseInt(contador + 1);
		});

	} else {}
}





function eliminarFila5(control, esquema){

	var contador = 0 ;
	var numeroID = control;
	var filasTotal = consultaFilas();
	if(filasTotal < 5){
		habilitaBoton('agregar');
		habilitaBoton('agrega1');
		habilitaBoton('agrega2');
		habilitaBoton('agrega3');
		habilitaBoton('agrega4');
	}

	eliminarEsquema5(control, esquema);

	var jqRenglon = eval("'#renglon" + numeroID + "'");
	$(jqRenglon).remove();

	//Reordenamiento de Controles
	contador = 1;
	var numero= 0;
	$('tr[name=renglon]').each(function() {
		//numero =  this.id;
		numero= this.id.substr(7,this.id.length);

		var jqRenglon = eval("'#renglon"+numero+"'");
		var jqNumero = eval("'#consecutivoID"+numero+"'");
		var jqtipoPagoSeguro = eval("'#tipoPagoSeguro"+numero+"'");
		var jqfactorRiesgoSeguro= eval("'#factorRiesgoSeguro"+numero+"'");
		var jqdescuentoSeguro= eval("'#descuentoSeguro"+numero+"'");
		var jqmontoPolSegVida=eval("'#montoPolSegVida"+ numero+"'");
		var jqAgrega=eval("'#agrega"+ numero+"'");
		var jqElimina = eval("'#"+numero+ "'");

		$(jqNumero).attr('id','consecutivoID'+contador);
		$(jqtipoPagoSeguro).attr('id','tipoPagoSeguro'+contador);
		$(jqfactorRiesgoSeguro).attr('id','factorRiesgoSeguro'+contador);
		$(jqdescuentoSeguro).attr('id','descuentoSeguro'+contador);
		$(jqmontoPolSegVida).attr('id','montoPolSegVida'+contador);
		$(jqAgrega).attr('id','agrega'+contador);
		$(jqElimina).attr('id',contador);
		$(jqRenglon).attr('id','renglon'+ contador);
		contador = parseInt(contador + 1);
	});

}


function eliminar(tipoPago, esquemaID){
	document.getElementById('tipoTransaccionGrid').value = 3;
	document.getElementById('tipoTransaccion').value = 0;

	var jqTipoPagoSeguro = eval('"#tipoPagoSeguro'+tipoPago+'"');
	var tipoPagoVal = $(jqTipoPagoSeguro).val();
	var tipoTransaccionGrid = 3;

	var paramBean = {
			'productCreditoID'	:productoCredOID,
			'esquemaSeguroID'   :esquemaID,
			'tipoPagoSeguro'    :tipoPagoVal
	};

	$('#contenedorForma').block({
		message: $('#mensaje'),
		css: {border:		'none',
			background:	'none'}
	});
	esquemaSeguroVidaServicio.grabaTransaccion(tipoTransaccionGrid, paramBean, function(mensajeTransaccion) {
		if(mensajeTransaccion!=null){
			mensajeSis(mensajeTransaccion.descripcion);
			$('#contenedorForma').unblock();
			funcionExitoGrid();
			document.getElementById("producCreditoID").focus();
		}else{
			mensajeSis("Ocurrio un Error al eliminar el Esquema de Seguro de Vida.");
		}
	});
}



function eliminarEsquema5(tipoPago, esquemaID){
	document.getElementById('tipoTransaccionGrid').value = 3;
	document.getElementById('tipoTransaccion').value = 0;

	var jqTipoPagoSeguro = eval('"#tipoPagoSeguro'+tipoPago+'"');
	var tipoPagoVal = $(jqTipoPagoSeguro).val();
	var tipoTransaccionGrid = 3;

	var paramBean = {
			'productCreditoID'	:productoCredOID,
			'esquemaSeguroID'   :esquemaID,
			'tipoPagoSeguro'    :tipoPagoVal
	};

	esquemaSeguroVidaServicio.grabaTransaccion(tipoTransaccionGrid, paramBean, function(mensajeTransaccion) {
		if(mensajeTransaccion!=null){
			$('#contenedorForma').unblock();
		}else{
			mensajeSis("Ocurrio un Error al eliminar el Esquema de Seguro de Vida.");
		}
	});
}


function limpiaFormaSeguro(){
	$('#divGrid').hide();
	$('#Seguro1').show();
	$('#Seguro2').show();
	$('#Seguro3').show();

	$('#reqSeguroVida2').attr("checked",true);
	$('#reqSeguroVida').attr("checked",false);
	$('#unico').attr("checked",false);
	$('#tipoPago').attr("checked",false);

	deshabilitaControl('unico');
	deshabilitaControl('tipoPago');
	deshabilitaControl('tipoPagoSeguro');
	deshabilitaControl('descuentoSeguro');
	deshabilitaControl('factorRiesgoSeguro');
	deshabilitaControl('montoPolSegVida');

	$('#modalid').val('');
	$('#modalidadPago').val('');
	$('#tipoPagoSeguro').val('');
	$('#factorRiesgoSeguro').val('');
	$('#descuentoSeguro').val('');
	$('#montoPolSegVida').val('');

}


// funcion para validar el factor de riesgo
function validaFactorRiesgo() {
	$('input[name=lfactorRiesgoSeguro]').each(function() {
		jqTipoMovID = eval("'#" + this.id + "'");
		if($(jqTipoMovID).asNumber() <=0){
			mensajeSis("El Factor de Riesgo está vacío.");
			$(jqTipoMovID).focus();
			$(jqTipoMovID).select();
		}else{
			if($(jqTipoMovID).asNumber() < 0){
				mensajeSis("El Factor de Riesgo es negativo.");
				$(jqTipoMovID).focus();
				$(jqTipoMovID).select();
			}
		}
	});
}


// funcion para validar el descuento de seguro
function validaDescuento() {
	$('input[name=ldescuentoSeguro]').each(function() {
		jqTipoMovID = eval("'#" + this.id + "'");
		if($(jqTipoMovID).val() == ''){
			mensajeSis("El Porcentaje de Descuento está vacío.");
			$(jqTipoMovID).focus();
			$(jqTipoMovID).select();
		}else{
			if($(jqTipoMovID).asNumber() < 0){
				mensajeSis("El Porcentaje de Descuento es negativo.");
				$(jqTipoMovID).focus();
				$(jqTipoMovID).select();
			}
		}
	});
}



function validaMontoPoliza() {
	$('input[name=lmontoPolSegVida]').each(function() {
		jqTipoMovID = eval("'#" + this.id + "'");
		if($(jqTipoMovID).val() == ''){
			mensajeSis("El Monto de Poliza está vacío.");
			$(jqTipoMovID).focus();
			$(jqTipoMovID).select();
		}else{
			if($(jqTipoMovID).asNumber() < 0){
				mensajeSis("El Monto de Poliza es negativo.");
				$(jqTipoMovID).focus();
				$(jqTipoMovID).select();
			}
		}
	});
}



function validaTipPago() {
	$('input[name=ltipoPagoSeguro]').each(function() {
		jqTipoMovID = eval("'#" + this.id + "'");
		if($(jqTipoMovID).val() == ''){
			mensajeSis("El Tipo de Pago está vacío.");
			$(jqTipoMovID).focus();
			$(jqTipoMovID).select();
		}
	});
}

function setFocoGrid() {
	$("#tipoPagoSeguro1").focus();
}

function validador(e){
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57){
		if (key==8 || key == 0){
			return true;
		}
		else
			return false;
	}
}

function funcionExitoProducto(){
}

function funcionFalloProducto(){
}

function funcionFalloGrid(){
	setFocoGrid();
}

function funcionExitoGrid(){

}
//---------------Función para limpiar el formulario--------------
function limpiarDatos(){
	$('#cobraIVAInteres').val('S');
	$('#cobraFaltaPago').val('S');
	$('#cobraMora').val('S');
	$('#cobraIVAMora').val('S');
	$('#tipCobComMorato').val('N');
	$('#tipo').val('C');
	$('#ahoVoluntario').val('S');
	$('#tipoComXapert').val('M');
	$('#formaComApertura').val('F');
	$('#calcInteres').val('');
	$('#tipoCalInteres').val('');
	$('#proyInteresPagAde').val('S');
	$('#permitePrepago').val('');
	$('#tipoPrepago').val('');

	$('#tipoPersona').val('F');
	$('#esGrupal').val('N').change();
	$('#requiereGarantia').val('S');
	$('#perGarCruzadas').val('');
	habilitaControl('perGarCruzadas');
	$('#requiereAvales').val('S');
	$('#perAvaCruzados').val('');
	habilitaControl('perAvaCruzados');
	$('#esReestructura').val('S');
	$('#autorizaComite').val('N');

	$('#esRevolvente').val('N');
	$('#afectacionContable').val('N');
	$('#manejaLinea').val('N');
	$('#validaCapConta').val('S');
	$('#claveRiesgo').val('');
	$('#calculoRatios2').attr("checked",true);
}


//---------------Función para validar si se requiere garantía--------------
function validaGarantia(){
	requiereGarantiaNo = 'N';
	requiereGarantiaSi = 'S';
	requiereGarantiaIn = 'I';

	if ($('#requiereGarantia').val() == requiereGarantiaSi || $('#requiereGarantia').val() == requiereGarantiaIn) {
		$('#perGarCruzadas').removeAttr('disabled');
		$('#perGarCruzadas').val("");
		$('#relGarantCred').removeAttr('disabled');
		$('#relGarantCred').val("");

		$('#relGarantCred').rules("add", {
			min: 0.0001,
		messages: {
			min: 'Relación Garantía Crédito mayor a 0.'
			}
		});


	} else {
		$('#perGarCruzadas').attr('disabled','disabled');
		$('#perGarCruzadas').val("N");

		$('#relGarantCred').attr('disabled','disabled');
		$('#relGarantCred').val("0");
	}

}

//---------------Función para validar si se Requiere Avales--------------
function validaAvales() {
	requiereAvalesNo = 'N';
	requiereAvalesSi = 'S';
	requiereAvalesIn = 'I';

	if ($('#requiereAvales').val() == requiereAvalesSi || $('#requiereAvales').val() == requiereAvalesIn) {

		$('#perAvaCruzados').val("");
		$('#perAvaCruzados').removeAttr('disabled');
		$('#cantidadAvales').val("");

		//HABILITAR INTERCAMBIO AVALES
		$('#intercambioAvalesRatioSi').removeAttr('disabled');
		$('#intercambioAvalesRatioNo').removeAttr('disabled');

		/*aqui*/


	} else {
		$('#perAvaCruzados').val("N");
		$('#perAvaCruzados').attr('disabled','disabled');
		$('#cantidadAvales').val("0");
		$('#cantidadAvales').attr('disabled','disabled');

		$('#intercambioAvalesRatioNo').attr("checked",true);
		$('#intercambioAvalesRatioSi').attr('disabled','disabled');

		$("label.error").hide();
		$(".error").removeClass("error");
	}
}

//---------------Función para validar si se permiten Intercambio de Avales--------------
function permiteInterAvales() {
	perAvaCruzadosNo = 'N';
	perAvaCruzadosSi = 'S';

	if ($('#perAvaCruzados').val() == perAvaCruzadosSi) {
		//$('#cantidadAvales').val("");
		$('#cantidadAvales').removeAttr('disabled');

		$('#cantidadAvales').rules("add", {
			min: 1,
		messages: {
			min: 'Cantidad de Avales debe ser mínimo 1'
			}
		});

	}
	else if($('#perAvaCruzados').val() == perAvaCruzadosNo) {
		$('#cantidadAvales').val("1");
		$('#cantidadAvales').attr('disabled','disabled');

		$("label.error").hide();
		$(".error").removeClass("error");
	}
	else {
		$('#cantidadAvales').val("");
		$('#cantidadAvales').attr('disabled','disabled');
		$("label.error").hide();
		$(".error").removeClass("error");
	}

}


//---------------  funcion que llena el combo de calcInteres  --------------
function consultaComboCalInteres() {
	dwr.util.removeAllOptions('calcInteres');
	formTipoCalIntServicio.listaCombo(catFormTipoCalInt.principal,function(formTipoCalIntBean){
		dwr.util.addOptions('calcInteres', {'':'SELECCIONAR'});
		dwr.util.addOptions('calcInteres', formTipoCalIntBean, 'formInteresID', 'formula');
	});
}

function validaReferencias(){
	requiereAvalesNo = 'N';
	requiereAvalesSi = 'S';
	requiereAvalesIn = 'I';

	if ($('#requiereReferencias').val() == requiereAvalesSi || $('#requiereReferencias').val() == requiereAvalesIn) {
		$('#mostrarMinReferencias1').show();
		$('#mostrarMinReferencias2').show();

	} else {
		$('#minReferencias').val("0");
		$('#mostrarMinReferencias1').hide();
		$('#mostrarMinReferencias2').hide();
		$("label.error").hide();
		$(".error").removeClass("error");
	}
}

function validaSoloNumero(e,elemento){//Recibe al evento
	var key;
	if(window.event){//Internet Explorer ,Chromium,Chrome
		key = e.keyCode;
	}else if(e.which){//Firefox , Opera Netscape
			key = e.which;
	}

	 if (key > 31 && (key < 48 || key > 57)) //se valida, si son números los deja
	    return false;
	 return true;
}

// consulta la tasa base del mes anterior
function consultaTasaBase(calcInteres) {
	calcInteres = Number(calcInteres);
	var campoTasaBase = $('#tasaBase').asNumber();

	var TasaBaseBeanCon = {
			'tasaBaseID' : '0'
	};
	/* Realiza la consulta si el calculo de interes es diferente de tasaFija/seleccionar
	 * y si el campo tasaBase se encuentra vacio */
	if(calcInteres>1 && campoTasaBase==0){
		tasasBaseServicio.consulta(2, TasaBaseBeanCon,function(tasasBaseBean) {
			if (tasasBaseBean != null) {
				$('#tasaBase').val(tasasBaseBean.tasaBaseID);
				$('#desTasaBase').val(tasasBaseBean.nombre);
				$('#valorTasaBase').val(tasasBaseBean.valor);
			} else {
				mensajeSis("No Existe una Tasa Base Registrada para el Mes Anterior.");
				$('#tasaBase').val('');
				$('#desTasaBase').val('');
				$('#valorTasaBase').val('');
			}
		});
	}
}

function muestraCamposTasa(calcInteresID){
	calcInteresID = Number(calcInteresID);
	// Si el calculo de interes es por tasaFija se ocultan campos de sobre tasa
	if(calcInteresID <= TasaFijaID){
		$('tr[name=tasaBase]').hide();
	} else if(calcInteresID != TasaFijaID){
		// Si es por tasa variable, se muestran
		$('tr[name=tasaBase]').show();
	}
}

// Consulta el tipo de institucion
function consultaTipoInstitucion() {
	var parametrosSisCon ={
 		 	'empresaID' : 1
	};
	parametrosSisServicio.consulta(15,parametrosSisCon, function(institucion) {
		if (institucion != null) {
			tipoInstitucion = institucion.tipoInstitID;

			if(tipoInstitucion == tipoSOFIPO){
				$('.tipoSofipo').show();
			}else{
				$('.tipoSofipo').hide();
			}
		}
	});
}

jQuery.validator.addMethod("validaCNBV",function(value, element) {
  return this.optional( element ) || /^[A-Za-z0-9]+$/.test( value );
}, 'Por favor ingresa una clave válida');