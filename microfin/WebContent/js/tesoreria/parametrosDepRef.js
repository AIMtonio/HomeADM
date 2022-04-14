var esTab;
//INICIO document.ready
$(document).ready(function() {
	inicializaPantalla();
	consultaProductosCredito();
	$('#tipoArchivo').focus();
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
			'modificar':'1'
	};

	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','tipoArchivo','funcionExito','funcionError');
		}
	});

	$('#lecturaAutomSI').click(function(){
		$('#rutaArchivos').attr('disabled',false);
		$('#tiempoLectura').attr('disabled',false);
	});

	$('#lecturaAutomNO').click(function(){
		$('#rutaArchivos').val('');
		$('#tiempoLectura').val('');
		$('#rutaArchivos').attr('disabled',true);
		$('#tiempoLectura').attr('disabled',true);
	});

	$('#cobranzaRefSI').click(function(){
		$('#cobranzaRefSI').attr("checked",true);
		$('#cobranzaRefNO').attr("checked",false);
		$('#cobranzaRef').val("S");
	});

	$('#cobranzaRefNO').click(function(){
		$('#cobranzaRefNO').attr("checked",true);
		$('#cobranzaRefSI').attr("checked",false);
		$('#cobranzaRef').val("N");
	});

	$('#grabar').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.modificar);
	});

	$('#productoCreditoID').blur(function(){
		consultaParamCobranzaRef();
	});

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			tipoArchivo:{
				required: true
			}
		},
		messages: {
			tipoArchivo:{
				required: 'Seleccione un tipo de Archivo'
			}
		}
	});
}); //FIN document.ready

	function consultaParametros(){
		var conPrincipal = 1;
		var consecutivoID = $('#tipoArchivo').val();

		if(consecutivoID > 0){
			$('#consecutivoID').val(consecutivoID);

			var ParametrosBeanCon = {
				'consecutivoID': consecutivoID
			};

			parametrosDepRefServicio.consulta(ParametrosBeanCon, conPrincipal, function(parametrosDepRef) {
				if(parametrosDepRef!=null){
					$('#consecutivoID').val(parametrosDepRef.consecutivoID);
					$('#descripcionArch').val(parametrosDepRef.descripcionArch);
					$('#pagoVar').val(parametrosDepRef.pagoCredAutom);
					$('#exigibleVar').val(parametrosDepRef.exigible);
					$('#sobranteVar').val(parametrosDepRef.sobrante);
					checarOpciones(parametrosDepRef);
					if(consecutivoID>1){
						$('#aplicDepAutom').show();
					}else{
						$('#aplicDepAutom').hide();
					}
					secciondepositosAutomaticos(parametrosDepRef);
				}else{

				}
			});
		}
	}

	function funcionExito(){
		inicializaPantalla();
		$('#tipoArchivo').focus();
	}

	function checarOpciones(parametrosDepRef){
		var pagoCred = parametrosDepRef.pagoCredAutom;
		var exigible = parametrosDepRef.exigible;
		var sobrante = parametrosDepRef.sobrante;

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
	}

	function secciondepositosAutomaticos(parametrosDepRef){
		var lecturaAut = parametrosDepRef.lecturaAutom;

		if(lecturaAut == 'S'){
			$('#lecturaAutomSI').attr("checked",true);
			$('#lecturaAutomNO').attr("checked",false);
			$('#rutaArchivos').val(parametrosDepRef.rutaArchivos);
			$('#tiempoLectura').val(parametrosDepRef.tiempoLectura);
			$('#rutaArchivos').attr('disabled',false);
			$('#tiempoLectura').attr('disabled',false);
		}
		if(lecturaAut == 'N'){
			$('#lecturaAutomSI').attr("checked",false);
			$('#lecturaAutomNO').attr("checked",true);
			$('#rutaArchivos').val('');
			$('#tiempoLectura').val('');
			$('#rutaArchivos').attr('disabled',true);
			$('#tiempoLectura').attr('disabled',true);
		}

	}

	function inicializaPantalla(){
		$('#pagoCredAutomSI').attr("checked",false);
		$('#pagoCredAutomNO').attr("checked",false);
		$('#abonoCta').attr("checked",false);
		$('#prepagoCred').attr("checked",false);
		$('#ahorro').attr("checked",false);
		$('#sobranteprepagoCred').attr("checked",false);
		$('[name=tipoArchivo]').val('');
		$('#rutaArchivos').val('');
		$('#tiempoLectura').val('');
		$('#lecturaAutomSI').attr("checked",false);
		$('#lecturaAutomNO').attr("checked",false);
		$('#aplicDepAutom').hide();
		$('#cobranzaRefSI').attr("checked",false);
		$('#cobranzaRefNO').attr("checked",false);
		$('#cobranzaRef').val("");
		$('#productoCreditoID').val("");
	}

	function funcionError(){

	}

	function consultaProductosCredito() {
		dwr.util.removeAllOptions('productoCreditoID');
		dwr.util.addOptions('productoCreditoID', {"":'SELECCIONAR'});
		productosCreditoServicio.listaCombo(16, function(producto){
			dwr.util.addOptions('productoCreditoID', producto, 'producCreditoID', 'descripcion');
		});
	}

	function consultaParamCobranzaRef(){
		var conPrincipal = 2;
		var consecutivoID = $('#tipoArchivo').val();
		var productoCreditoID = $('#productoCreditoID').val();

		if(consecutivoID > 0 && productoCreditoID > 0){
			var parametrosBeanCon = {
				'consecutivoID': consecutivoID,
				'productoCreditoID' : productoCreditoID
			};

			parametrosDepRefServicio.consulta(parametrosBeanCon, conPrincipal, function(parametrosCobranzaRef) {
				if(parametrosCobranzaRef!=null){
					if (parametrosCobranzaRef.cobranzaRef == 'S'){
						$('#cobranzaRefSI').attr("checked",true);
						$('#cobranzaRefNO').attr("checked",false);
						$('#cobranzaRef').val("S");
					}

					if (parametrosCobranzaRef.cobranzaRef == 'N'){
						$('#cobranzaRefSI').attr("checked",false);
						$('#cobranzaRefNO').attr("checked",true);
						$('#cobranzaRef').val("N");
					}
				}
			});
		}
	}