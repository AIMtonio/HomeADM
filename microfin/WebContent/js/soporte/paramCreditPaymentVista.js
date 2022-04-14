var esTab;
//INICIO document.ready
$(document).ready(function() {
	inicializaPantalla();
	consultaProductosCredito();
	$('#producCreditoID').focus();
	esTab = true;

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	var tipoTransaccion = {
		'alta':'1',
		'modificar':'2'
	};

	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','producCreditoID','funcionExito','funcionError');
		}
	});

	$('#cobranzaRefSI').click(function(){
		$('#cobranzaRefSI').attr("checked",true);
		$('#cobranzaRefNO').attr("checked",false);
		$('#aplicaCobranzaRef').val("S");
	});

	$('#cobranzaRefNO').click(function(){
		$('#cobranzaRefNO').attr("checked",true);
		$('#cobranzaRefSI').attr("checked",false);
		$('#aplicaCobranzaRef').val("N");
	});

	$('#grabar').click(function() {
		var paramCreditPaymentID = $('#paramCreditPaymentID').val();
		if (paramCreditPaymentID == 0){
			$('#tipoTransaccion').val(tipoTransaccion.alta);
		}

		if (paramCreditPaymentID > 0){
			$('#tipoTransaccion').val(tipoTransaccion.modificar);
		}

	});

	$('#producCreditoID').blur(function(){
		consultaParametros();
	});

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
		},
		messages: {
		}
	});
}); //FIN document.ready

	function consultaParametros(){
		var conPrincipal = 1;
		var producCreditoID = $('#producCreditoID').val();

		if(producCreditoID > 0){
			var parametrosBeanCon = {
				'producCreditoID': producCreditoID
			};

			paramCreditPaymentServicio.consulta(parametrosBeanCon, conPrincipal, function(parametrosCreditPayment) {
				if(parametrosCreditPayment !=null){
					$('#paramCreditPaymentID').val(parametrosCreditPayment.paramCreditPaymentID);
					checarOpciones(parametrosCreditPayment);
				}else{
					$('#paramCreditPaymentID').val(0);
					$('#pagoCredAutomSI').attr("checked",false);
					$('#pagoCredAutomNO').attr("checked",false);
					$('#abonoCta').attr("checked",false);
					$('#prepagoCred').attr("checked",false);
					$('#ahorro').attr("checked",false);
					$('#sobranteprepagoCred').attr("checked",false);
					$('#cobranzaRefSI').attr("checked",false);
					$('#cobranzaRefNO').attr("checked",false);
				}
			});
		}
	}

	function funcionExito(){
		inicializaPantalla();
	}

	function checarOpciones(parametrosCreditPayment){
		var pagoCred = parametrosCreditPayment.pagoCredAutom;
		var exigible = parametrosCreditPayment.exigible;
		var sobrante = parametrosCreditPayment.sobrante;
		var aplicaCobranzaRef = parametrosCreditPayment.aplicaCobranzaRef;

		if(pagoCred == 'S'){
			$('#pagoCredAutomSI').attr("checked",true);
			$('#pagoCredAutomNO').attr("checked",false);
		}
		if(pagoCred == 'N'){
			$('#pagoCredAutomSI').attr("checked",false);
			$('#pagoCredAutomNO').attr("checked",true);
		}

		if(exigible == 'A'){
			$('#abonoCta').attr("checked",true);
			$('#prepagoCred').attr("checked",false);
		}
		if(exigible == 'P'){
			$('#abonoCta').attr("checked",false);
			$('#prepagoCred').attr("checked",true);
		}

		if(sobrante == 'A'){
			$('#ahorro').attr("checked",true);
			$('#sobranteprepagoCred').attr("checked",false);
		}
		if(sobrante == 'P'){
			$('#ahorro').attr("checked",false);
			$('#sobranteprepagoCred').attr("checked",true);
		}

		if(aplicaCobranzaRef == 'S'){
			$('#cobranzaRefSI').attr("checked",true);
			$('#cobranzaRefNO').attr("checked",false);
		}
		if(aplicaCobranzaRef == 'N'){
			$('#cobranzaRefSI').attr("checked",false);
			$('#cobranzaRefNO').attr("checked",true);
		}

	}

	function inicializaPantalla(){
		$('#pagoCredAutomSI').attr("checked",false);
		$('#pagoCredAutomNO').attr("checked",false);
		$('#abonoCta').attr("checked",false);
		$('#prepagoCred').attr("checked",false);
		$('#ahorro').attr("checked",false);
		$('#sobranteprepagoCred').attr("checked",false);
		$('#cobranzaRefSI').attr("checked",false);
		$('#cobranzaRefNO').attr("checked",false);
		$('#aplicaCobranzaRef').val("");
		$('#producCreditoID').val("");
		$('#paramCreditPaymentID').val(0);
	}

	function funcionError(){

	}

	function consultaProductosCredito() {
		dwr.util.removeAllOptions('producCreditoID');
		dwr.util.addOptions('producCreditoID', {"":'SELECCIONAR'});
		productosCreditoServicio.listaCombo(16, function(producto){
			dwr.util.addOptions('producCreditoID', producto, 'producCreditoID', 'descripcion');
		});
	}

