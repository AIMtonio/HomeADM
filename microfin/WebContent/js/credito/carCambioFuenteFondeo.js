var nomClavePresupID = "";

var catTipoTransaccionFondeo = {
	'cambiarFondeo' : '2',
};


$(document).ready(function(){
	esTab = true;

	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('cambiar', 'submit');

	$.validator.setDefaults({submitHandler : function(event) {
		grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','creditoID','exitoTransParametro','falloTransParametro');
		}
	});

	/***********MANEJO DE EVENTOS******************/
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab = true;
		}
	});

	$('#cambiar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionFondeo.cambiarFondeo);
	});

	$('#creditoID').bind('keyup', function(e){
		limpia();
		lista('creditoID', '2', '57', 'nombreCliente', $('#creditoID').val(), 'ListaCredito.htm');
	});

	$('#creditoID').blur(function(){
		var creditoID = $('#creditoID').val();
		if (esTab) {
			if(creditoID > 0 && creditoID != null){
				consultaCredito(this.id);
			}else if(creditoID != ""){
				mensajeSis("Especifique una Crédito Válido.");
				deshabilitaBoton('cambiar', 'submit');
			}
		}
	});

	$('#institutFondActID').bind('keyup',function(e){
		$('#nombreFondeoAct').val("");
		$('#descripLineaAct').val("");
		$('#lineaFondeoAct').val("");
		lista('institutFondActID', '1', '1', 'nombreInstitFon', $('#institutFondActID').val(), 'intitutFondeoLista.htm');
	});

	$('#institutFondActID').blur(function(){
		var institFondeoIDAct = $('#institutFondActID').val();
		if (esTab) {
			if(institFondeoIDAct >= 0 && institFondeoIDAct != null){
				consultaFondeador(this.id);
				if(institFondeoIDAct == 0){
					$('#lineaFondeoAct').val("0");
					$('#descripLineaAct').val("RECURSOS PROPIOS");
					$('#creditoFondeoActID').val("0");
					$('#desFolioPasivoAct').val("RECURSOS PROPIOS");
					deshabilitaControl('lineaFondeoAct');
					deshabilitaControl('creditoFondeoActID');
				}
			}else if(institFondeoIDAct != ""){
				mensajeSis("Especifique una Institución de Fondeo Válido.");
				deshabilitaBoton('cambiar', 'submit');
				$('#nombreFondeoAct').val("");
				$('#institutFondActID').val("");
				$('#descripLineaAct').val("");
				$('#lineaFondeoAct').val("");
				$('#institutFondActID').focus();
			}
		}
	});

	$('#lineaFondeoAct').bind('keyup',function(e){
		$('#descripLineaAct').val("");
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "descripLinea";
		camposLista[1] = "institutFondID";
		parametrosLista[0] = $('#lineaFondeoAct').val();
		parametrosLista[1] = $('#institutFondActID').val();
		listaAlfanumerica('lineaFondeoAct', '0', '2', camposLista, parametrosLista, 'listaLineasFondeador.htm');
	});

	$('#lineaFondeoAct').blur(function() {
		var lineaFondeoAct = $('#lineaFondeoAct').val();
		if(esTab){
			if(lineaFondeoAct > 0 && lineaFondeoAct != null) {
				consultaLineaFondeo(this.id);
			}else if(lineaFondeoAct != "" && lineaFondeoAct != "0"){
				mensajeSis("Especifique una Linea de Fondeo Válido.");
				$('#descripLineaAct').val("");
				$('#lineaFondeoAct').val("");
				$('#lineaFondeoAct').focus();
			}
		}
	});

	$('#creditoFondeoActID').bind('keyup',function(e){
		$('#desFolioPasivoAct').val("");
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "nombreLineaFon";
		parametrosLista[0] = $('#creditoFondeoActID').val();
		camposLista[1] = "lineaFondeoID";
		parametrosLista[1] = $('#lineaFondeoAct').val();
		camposLista[2] = "institutFondID";
		parametrosLista[2] = $('#institutFondActID').val();

		lista('creditoFondeoActID', '1', '6', camposLista, parametrosLista, 'listaCreditoFondeo.htm');
	});

	$('#creditoFondeoActID').blur(function() { 
		var folioPasivoAct = $('#creditoFondeoActID').val();
		if(esTab){
			if(folioPasivoAct > 0 && folioPasivoAct != null) {
				validaCreditoPasivo(this.id);
			}else if(folioPasivoAct != "" && folioPasivoAct != "0"){
				mensajeSis("Especifique un Folio Pasivo de Fondeo Válido.");
				$('#creditoFondeoActID').val("");
				$('#desFolioPasivoAct').val("");
				$('#creditoFondeoActID').focus();
			}
		}
	});

	$('#formaGenerica').validate({
		rules : {
		},

		messages : {
		}
	});
});

	function exitoTransParametro(){
		limpia();
	}

	function falloTransParametro(){

	}


	/* ================ CONSULTA DE INFORMACION DE CREDITO A FONDEAR =============== */
	function consultaCredito(controlID){
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) && esTab){
			var creditoBeanCon = {
				'creditoID':$('#creditoID').val()
			};

			creditosServicio.consulta(49, creditoBeanCon,function(credito) {
				if(credito!=null){
					$('#clienteID').val(credito.clienteID);
					consultaCliente(credito.clienteID);
					
					$('#cuentaID').val(credito.cuentaID);
					
					if(credito.estatus == 'V'){
						$('#estatus').val('VIGENTE');
					}
					
					if(credito.estatus == 'B'){
						$('#estatus').val('VENCIDO');
					}
					
					$('#producCreditoID').val(credito.producCreditoID);
					$('#descripProducto').val(credito.nombreProducto);
					$('#institFondeoIDAnt').val(credito.institFondeoID);
					$('#nombreFondeoAnt').val(credito.nombreInstitFon);
					$('#lineaFondeoAnt').val(credito.lineaFondeo);
					$('#descripLineaFonAnt').val(credito.descripLinea);
					$('#folioPasivoAnt').val(credito.creditoFondeoID);
					$('#desFolioPasivoAnt').val(credito.folioPasivo);
					habilitaBoton('cambiar', 'submit');

				}else{
					deshabilitaBoton('cambiar', 'submit');
					mensajeSis("No Existe el Crédito");
					$('#creditoID').focus();
					$('#creditoID').val('');
					$('#creditoID').val("");
				}
			});
		}
	}

	function consultaCliente(clienteID) {
		var numCliente = clienteID;
		var tipConForanea = 2;

		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
				if(cliente!=null){
					$('#nombreCliente').val(cliente.nombreCompleto);
				}});
			}
	}
	
	function consultaFondeador(control) {
		var numInst = eval("'#" + control + "'");
		var insFondeador = $(numInst).val();
		setTimeout("$('#cajaLista').hide();", 200);
		var instFondeoBeanCon = {
			'institutFondID' : insFondeador
		};

		if (insFondeador != '' && !isNaN(insFondeador)) {
			fondeoServicio.consulta(1, instFondeoBeanCon, {async : false,callback : function(instFondeo) {
				if (instFondeo != null) {
					habilitaControl('lineaFondeoAct');
					habilitaControl('creditoFondeoActID');
					if(instFondeo.estatus == 'I') {
						mensajeSis("La Institución de Fondeo se Encuentra Inactiva.");
						if(insFondeador != "0"){
							$('#nombreFondeoAct').val("");
							$('#lineaFondeoAct').val("");
							$('#descripLineaAct').val("");
							$('#creditoFondeoActID').val("");
							$('#desFolioPasivoAct').val("");
						}
						deshabilitaBoton('cambiar', 'submit');
						$('#institutFondActID').focus();
					}

					if(instFondeo.estatus == 'A'){
						$('#nombreFondeoAct').val(instFondeo.nombreInstitFon);
						if(insFondeador != "0"){
							$('#lineaFondeoAct').val("");
							$('#descripLineaAct').val("");
							$('#creditoFondeoActID').val("");
							$('#desFolioPasivoAct').val("");
						}
						habilitaBoton('cambiar', 'submit');
					}

				} else {
					mensajeSis("No Existe la Institución de Fondeo");
					deshabilitaBoton('cambiar', 'submit');
					$('#nombreFondeoAct').val("");
					$('#lineaFondeoAct').val("");
					$('#descripLineaAct').val("");
					$('#institutFondActID').focus();
				}
			}});
		}
	}

	// consulta de la linea de fondeo
	function consultaLineaFondeo(idControl){
		var jqLineaFon = eval("'#" + idControl + "'");
		var numLinea = $(jqLineaFon).val();
		var tipoCon = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		var lineaFondBeanCon = {
			'lineaFondeoID' : numLinea
		};

		if (numLinea != '' && !isNaN(numLinea)) {
			lineaFonServicio.consulta(tipoCon, lineaFondBeanCon,{ async: false, callback:  function(lineaFond) {
				if (lineaFond != null) {
					var saldoLineaFondeo = lineaFond.saldoLinea;
					var institutFondActID = $('#institutFondActID').val();
					if(institutFondActID != lineaFond.institutFondID){
						mensajeSis("La Linea de Fondeo no Corresponde con la Institución");
						$('#lineaFondeoAct').val("");
						$('#descripLineaAct').val("");
						$('#lineaFondeoID').focus();
					}else{
						if(parseFloat(saldoLineaFondeo) == 0){
							mensajeSis("El Saldo de la Línea es Insuficiente.");
							deshabilitaBoton('cambiar', 'submit');
							$('#lineaFondeoAct').focus();
						}else{
							$('#descripLineaAct').val(lineaFond.descripLinea);
							habilitaBoton('cambiar', 'submit');
						}
					}
				}else {
					mensajeSis("No Existe la Línea de Fondeo");
					$('#lineaFondeoAct').focus();
					$('#descripLineaAct').val("");
				}
			}});
		}
	}// fin consultaLineaFondeo

	function validaCreditoPasivo(controlID){ 
		var varCreditoPasivo = $('#creditoFondeoActID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(varCreditoPasivo != '' && !isNaN(varCreditoPasivo)){
			var creditoBeanCon = {
				'creditoFondeoID':varCreditoPasivo
			};
			creditoFondeoServicio.consulta(1, creditoBeanCon,{ async: false, callback: function(creditoPasivo) {
				if(creditoPasivo!=null){
					var numInstitut = $('#institutFondActID').val();
					var numLinea = $('#lineaFondeoAct').val();
					
					var lineaFon = creditoPasivo.lineaFondeoID;
					var institfon = creditoPasivo.institutFondID;
					
					if(lineaFon == numLinea && numInstitut == institfon){
						$('#desFolioPasivoAct').val(creditoPasivo.folio);
					}
					else{
						mensajeSis("El Crédito no Corresponde con la Institución y la Linea de Fondeo");
						$('#creditoFondeoActID').focus();
						$('#creditoFondeoActID').val("");
					}
				}else{
					mensajeSis("No Existe el Folio Pasivo");
					$('#creditoFondeoActID').val("");
					$('#desFolioPasivoAct').val("");
					$('#creditoFondeoActID').focus();
				}
			}});
		}
	}

	function limpia(){
		$('#clienteID').val("");
		$('#nombreCliente').val("");
		$('#cuentaID').val("");
		$('#estatus').val("");
		$('#producCreditoID').val("");
		$('#descripProducto').val("");
		$('#institFondeoIDAnt').val("");
		$('#nombreFondeoAnt').val("");
		$('#lineaFondeoAnt').val("");
		$('#descripLineaFonAnt').val("");
		$('#folioPasivoAnt').val("");
		$('#desFolioPasivoAnt').val("");
		$('#creditoFondeoActID').val("");
		$('#desFolioPasivoAct').val("");
		$('#lineaFondeoAct').val("");
		$('#descripLineaAct').val("");
		$('#nombreFondeoAct').val("");
		$('#institutFondActID').val("");
	}