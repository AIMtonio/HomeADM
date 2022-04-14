$(document).ready(function() {
	esTab = true;
	 
	//Definicion de Constantes, Variables  y Enums
	var catTipoTransaccionCre = {
  		'grabar'	:'1',
	};
	var parametroBean = consultaParametrosSession(); ;
	var divCajaLista = $('#cajaLista');
	var fechaSistema ="";
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	inicializarCampos();
	
	$(':text').focus(function() {	
	 	esTab = false;
	});

	$.validator.setDefaults({
      submitHandler: function(event) {
    	  var vacio = validaVacios();
    	  //var modificados = validaModificados();
			if(vacio==1 ){
				alert("Existen Montos Vacios");
			}
//			else if(modificados==1){
//				alert("No Existen Datos Modificados");
//			}
			else{
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','creditoFondeoID','funcionExito','funcionFallo');
    	       }
      }
   });				

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#institutFondID').bind('keyup',function(e){
		lista('institutFondID', '2', '1', 'nombreInstitFon', $('#institutFondID').val(), 'intitutFondeoLista.htm');
	});

	$('#institutFondID').blur(function() { 
  		esTab=true;
		validaInstitucion(); 
	});
	
	$('#lineaFondeoID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "descripLinea";
		camposLista[1] = "institutFondID";


		parametrosLista[0] = $('#lineaFondeoID').val();
		parametrosLista[1] = $('#institutFondID').val();
		
		lista('lineaFondeoID', '2', '2', camposLista, parametrosLista, 'listaLineasFondeador.htm');
	});
	
	$('#lineaFondeoID').blur(function() { 
		validaLineaFondeo(this.id); 
	});
	
	$('#creditoFondeoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "nombreInstitFon";
			camposLista[1] = "lineaFondeoID";
			camposLista[2] = "institutFondID";
	      			
			parametrosLista[0] = $('#creditoFondeoID').val();
			parametrosLista[1] = $('#lineaFondeoID').val();
			parametrosLista[2] = $('#institutFondID').val();
			
			lista('creditoFondeoID', '1', '2', camposLista, parametrosLista, 'listaCreditoFondeo.htm');
		}				       
	});	
	
	$('#creditoFondeoID').blur(function(){
		validaCreditoFondeo();
	});

	//Clic a boton grabar
	$('#grabar').click(function() {
		crearAjuste();
		$('#tipoTransaccion').val(catTipoTransaccionCre.grabar);
	});

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			creditoFondeoID: 'required'	,
			
			institutFondID: {	number: true,
								required: true},
			lineaFondeoID: {	number: true,
								required: true}
																						
		},
		messages: {
			creditoFondeoID: 'Especifique Número de Crédito Pasivo',
			institutFondID: {	number: 'Soló números',
								required: 'Indique la Institución de Fondeo'},
			lineaFondeoID: {	number: 'Soló números',
								required: 'Indique la Linea de Fondeo'}																						
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------

	function validaInstitucion() {
	var numInst = $('#institutFondID').val();
	setTimeout("$('#cajaLista').hide();", 200);
	esTab=true;
	if(numInst != '' && !isNaN(numInst) && esTab){
		if(numInst=='0'){
			alert("No Existe la Institucion de Fondeo");
		} else {
			var instFondeoBeanCon = { 
				'institutFondID':numInst  				
			};
			fondeoServicio.consulta(1,instFondeoBeanCon,function(instFondeo) {
					if(instFondeo!=null){
						$('#nombreInstitFondeo').val(instFondeo.nombreInstitFon);
					}else{
						
						alert("No Existe la Institucion de Fondeo");
							$('#institutFondID').focus();
							$('#institutFondID').val('');
							$('#nombreInstitFondeo').val('');
							$('#gridAmortiCredFonMovs').hide();
						}
			});		
		}
	  }										
	}

	function validaLineaFondeo(control) {
		var numLinea = $('#lineaFondeoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		var numInstitut = $('#institutFondID').val();
		esTab=true;
		if(numLinea != '' && !isNaN(numLinea) && esTab){
			if(numLinea=='0'){
				alert("No existe la linea de Fondeo");
				$('#lineaFondeoID').val("");
					$('#lineaFondeoID').focus();
					$('#descripLinea').val("");
				}else {
				var lineaFondBeanCon = { 
						'lineaFondeoID':$('#lineaFondeoID').val()
				};
				lineaFonServicio.consulta(3,lineaFondBeanCon,function(lineaFond) {
					if(lineaFond!=null){
						var lineafondeo = lineaFond.institutFondID;
						if(lineafondeo==numInstitut){
							$('#descripLinea').val(lineaFond.descripLinea);
						}else{
							alert("La linea de Fondeo no Corresponde con la Institución");
							$('#lineaFondeoID').val("");
	   						$('#lineaFondeoID').focus();
	   						$('#descripLinea').val("");
	   						$('#gridAmortiCredFonMovs').hide();
						}
					}else{
						alert("No Existe la Linea Fondeador");
   						$('#lineaFondeoID').val("");
   						$('#lineaFondeoID').focus();
   						$('#descripLinea').val("");
   						$('#gridAmortiCredFonMovs').hide();
					}
				});
			}
		}
	}
	
	function validaCreditoFondeo(){
		var numCredito = $('#creditoFondeoID').val();
		var numInstitut = $('#institutFondID').val();
		var numLinea = $('#lineaFondeoID').val();
		var ajuste = 3;
		setTimeout("$('#cajaLista').hide();", 200);
		esTab=true;
		if(numCredito != '' && !isNaN(numCredito) && esTab){
			if(numCredito=='0'){
				alert("No existe el Credito Pasivo");
				$('#creditoFondeoID').focus();
				$('#creditoFondeoID').val("");
				inicializarCampos();
				}else {
				var creditoFondBeanCon = { 
						'creditoFondeoID':numCredito
				};
				creditoFondeoServicio.consulta(ajuste,creditoFondBeanCon,function(creditoFond) {
					if(creditoFond!=null){
						var lineaFon = creditoFond.lineaFondeoID;
						var institfon = creditoFond.institutFondID;
						if(lineaFon==numLinea && numInstitut == institfon){
							$('#monedaID').val(creditoFond.monedaID);
		   					consultaMoneda('monedaID');				
		   					var pagIVA = creditoFond.pagaIva;
							if(pagIVA == "S"){
								$('#pagaIVA').val('SI');
													}
							else if(pagIVA == "N"){
								$('#pagaIVA').val('NO');
							}
							var estatus = creditoFond.estatus;
							if(estatus == "N"){
								$('#estatus').val('VIGENTE');
													}
							else if(estatus == "P"){
								$('#estatus').val('PAGADO');
								deshabilitaBoton('condonar', 'submit');
							}
							//$('#pagoExigible').val(credito.);
							$('#saldoCapVigent').val(creditoFond.saldoCapVigente);
							$('#saldoCapAtrasad').val(creditoFond.saldoCapAtrasad);
							$('#totalCapital').val(creditoFond.totalCapital);
							$('#saldoInterOrdin').val(creditoFond.saldoInteres);
							$('#saldoInterAtras').val(creditoFond.saldoInteresAtra);
							$('#saldoInterProvi').val(creditoFond.provisionAcum);
							$('#totalInteres').val(creditoFond.totalInteres);
							
							$('#saldoIVAInteres').val(creditoFond.saldoIVAInteres);
							$('#saldoMoratorios').val(creditoFond.saldoMoratorio);
							$('#saldoIVAMorator').val(creditoFond.saldoIVAMora);
							
							$('#saldoComFaltPago').val(creditoFond.saldoComFaltPag);
							$('#saldoOtrasComis').val(creditoFond.saldoOtrasComis);
							$('#totalComisi').val(creditoFond.totalComisi);
							$('#salIVAComFalPag').val(creditoFond.saldoIVAComFal);
							$('#saldoIVAComisi').val(creditoFond.saldoIVAComisi);
							$('#totalIVACom').val(creditoFond.totalIVACom);
							$('#adeudoTotal').val(creditoFond.adeudoTotal);
							listaGridCreditoFon(2);
							consultaExigible();
						}else{
							alert("El Credito no Corresponde con la Institución y la Linea de Fondeo");
							$('#creditoFondeoID').focus();
							$('#creditoFondeoID').val("");
							inicializarCampos();
							$('#gridAmortiCredFonMovs').hide();
						}
					}else{
						alert("No Existe el Credito de Fondeo");
						$('#creditoFondeoID').focus();
						$('#creditoFondeoID').val("");
						inicializarCampos();
						$('#gridAmortiCredFonMovs').hide();
					}
				});
			}
		}
	}
	
	//** funciones para el pago de credito***
	
	function consultaExigible(){
		var numCredito = $('#creditoFondeoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito)){
			var Con_PagoCred = 4;
			var creditoFonBeanCon = { 
				'creditoFondeoID':numCredito,
  			};
			creditoFondeoServicio.consulta(Con_PagoCred,creditoFonBeanCon,function(credito) {
  				if(credito!=null){ 
			/*	$('#saldoCapVigent').val(credito.saldoCapVigent);  
				$('#saldoCapAtrasad').val(credito.saldoCapAtrasad);  
				$('#saldoCapVencido').val(credito.saldoCapVencido);
				$('#saldCapVenNoExi').val(credito.saldCapVenNoExi);    
				$('#totalCapital').val(credito.totalCapital);  
				$('#saldoInterOrdin').val(credito.saldoInterOrdin);
				$('#saldoInterAtras').val(credito.saldoInterAtras);
				$('#saldoInterAtras').val(credito.saldoInterAtras);
				$('#saldoInterVenc').val(credito.saldoInterVenc);
				$('#saldoInterProvi').val(credito.saldoInterProvi);
				$('#saldoIntNoConta').val(credito.saldoIntNoConta);
				$('#totalInteres').val(credito.totalInteres);
				$('#saldoIVAInteres').val(credito.saldoIVAInteres);
				$('#saldoMoratorios').val(credito.saldoMoratorios);
				$('#saldoIVAMorator').val(credito.saldoIVAMorator);
				$('#saldoComFaltPago').val(credito.saldoComFaltPago);
				$('#saldoOtrasComis').val(credito.saldoOtrasComis);
				$('#totalComisi').val(credito.totalComisi);  
				$('#salIVAComFalPag').val(credito.salIVAComFalPag);
				$('#saldoIVAComisi').val(credito.saldoIVAComisi);
				$('#totalIVACom').val(credito.totalIVACom);*/
				$('#pagoExigible').val(credito.pagoExigible);	
				agregaFormatoControles('formaGenerica');
  				}else{
  					deshabilitaBoton('condonar', 'submit');
  					$('#montoTotExigible').val("0.00");
  					$('#pagoExigible').val("0.00");
  					$('#saldoCapVigent').val("0.00");
  					$('#saldoCapAtrasad').val("0.00");
  					$('#saldoCapVencido').val("0.00");
  					$('#saldCapVenNoExi').val("0.00");
  					$('#totalCapital').val("0.00");
  					$('#saldoInterOrdin').val("0.00");
  					$('#saldoInterAtras').val("0.00");
  					$('#saldoInterVenc').val("0.00");
  					$('#saldoInterProvi').val("0.00");
  					$('#saldoIntNoConta').val("0.00");
  					$('#totalInteres').val("0.00");
  					$('#saldoIVAInteres').val("0.00");
  					$('#saldoMoratorios').val("0.00");
  					$('#saldoIVAMorator').val("0.00");
  					$('#saldoComFaltPago').val("0.00");
  					$('#saldoOtrasComis').val("0.00");
  					$('#totalComisi').val("0.00");
  					$('#salIVAComFalPag').val("0.00");
  					$('#saldoIVAComisi').val("0.00");
  					$('#totalIVACom').val("0.00");  					
  				}
  			});
		}
	}
	

	function consultaMoneda(idControl) {
		var jqMoneda = eval("'#" + idControl + "'");
		var numMoneda = $(jqMoneda).val();	
		var conMoneda=2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numMoneda != '' && !isNaN(numMoneda)){
			monedasServicio.consultaMoneda(conMoneda,numMoneda,function(moneda) {
				if(moneda!=null){
					$('#monedaDes').val(moneda.descripcion);										
				}else{
					alert("No Existe el Tipo de Moneda");
					$('#monedaDes').val('');
					$(jqMoneda).focus();
					$('#gridAmortiCredFonMovs').hide();
				}
			});
		}
	}
	
	function listaGridCreditoFon(control){
		var tipoLista = control;
//		$("#imprimirDetalle").show();
//		$("#imprimirDetalleEx").show();
//		$("#grabar").show();
//		$("#grabar").removeAttr('disabled');
//		deshabilitaBoton('imprimirDetalle');
//		deshabilitaBoton('imprimirDetalleEx');
//		habilitaBoton('grabar');
		var params = {};
		params['creditoFondeoID'] = $('#creditoFondeoID').val();
		params['tipoLista'] = tipoLista;
		$.post("amortizaGridMovimiento.htm", params, function(data){
				if(data.length >0) {		
						$('#gridAmortiCredFonMovs').html(data);
						$('#gridAmortiCredFonMovs').show();
						document.getElementById(deshabilitaEstatusPag());
						habilitaBoton('grabar', 'submit');
						//deshabilitaEstatusPag();
				}else{				
						$('#gridAmortiCredFonMovs').html("");
						$('#gridAmortiCredFonMovs').show();
						deshabilitaBoton('grabar', 'submit');
				}	
		});	
		
	}
	
	
	function crearAjuste(){	
		var mandar = validaVacios();
		if(mandar!=1){   		  		
	   	quitaFormatoControles('gridAmortiCredFonMovs');
			var numDetalle = $('input[name=amortizacionID]').length;
			var modificado;
			var altaPoliza = 0;
			$('#detalleAjuste').val("");
			for(var i = 1; i <= numDetalle; i++){
				modificado = document.getElementById("campoModificado"+i+"").value;
				if(modificado=="S"){
					if(altaPoliza == 0){
						varAltaPoliza = 'S';
						altaPoliza =1;
					}else{
						varAltaPoliza = 'N';
					}
					if(i == 1){
						
					$('#detalleAjuste').val($('#detalleAjuste').val() +
							document.getElementById("amortizacionID"+i+"").value + ']' +
							document.getElementById("estatusAmortiza"+i+"").value + ']' + 
							document.getElementById("interes"+i+"").value + ']' + 
							document.getElementById("saldoMoratorios"+i+"").value + ']' +  
							document.getElementById("saldoComFaltaPago"+i+"").value + ']' + 
							document.getElementById("saldoOtrasComisiones"+i+"").value + ']' +
							varAltaPoliza);
					}else{
					$('#detalleAjuste').val($('#detalleAjuste').val() + '[' +
							document.getElementById("amortizacionID"+i+"").value + ']' +
							document.getElementById("estatusAmortiza"+i+"").value + ']' + 
							document.getElementById("interes"+i+"").value + ']' + 
							document.getElementById("saldoMoratorios"+i+"").value + ']' +  
							document.getElementById("saldoComFaltaPago"+i+"").value + ']' + 
							document.getElementById("saldoOtrasComisiones"+i+"").value + ']' +
							varAltaPoliza);			
					}
				 }	
			}
			//alert("string ajustesmodificados"+$('#detalleAjuste').val());
		}
		return mandar; 
	}
	
	function validaVacios(){
		var conta = 0;
		var numDetalle = $('input[name=amortizacionID]').length;
		var jqInteres; 
		var jqMoratorio; 
		var jqSaldoComFalta; 
		var jqOtrasComis ;
		
		for(var i = 1; i <= numDetalle; i++){
			jqInteres = eval("'#interes" + numDetalle + "'");
			jqMoratorio = eval("'#saldoMoratorios" + numDetalle + "'");
			jqSaldoComFalta = eval("'#saldoComFaltaPago" + numDetalle + "'");
			jqOtrasComis = eval("'#saldoOtrasComisiones" + numDetalle + "'");
			jqModificado = eval("'#campoModificado" + numDetalle + "'");
			
			if($(jqInteres).val()==''){
			$(jqInteres).focus();
		    conta = 1;
		    return conta;
			}
			if($(jqMoratorio).val()==''){
				$(jqMoratorio).focus();			
			    conta = 1;
			    return conta;
			}
			if($(jqSaldoComFalta).val()==''){
				$(jqSaldoComFalta).focus();
			    conta = 1;
			    return conta;
			}
			if($(jqOtrasComis).val()==''){
				$(jqOtrasComis).focus();
			    conta = 1;
			    return conta;
			}
		}
	}
	
	function validaModificados(){
		var modifi = 0;
		var numDetalle = $('input[name=amortizacionID]').length;
		var jqModificado; 
		
		for(var i = 1; i <= numDetalle; i++){
			jqModificado = eval("'#campoModificado" + numDetalle + "'");
			
			if($(jqModificado).val()=='N'){
			     modif = 1;
			}else if($(jqModificado).val()=='S'){
				modif = 0;
			}
		}
	    return modifi;
	}
	//-------------------------------------
	
	function inicializarCampos() {
		
		$('#adeudoTotal').val("0.00");
		$('#montoTotDeuda').val("0.00");
		$('#montoTotExigible').val("0.00");
		$('#pagoExigible').val("0.00");
		$('#saldoCapVigent').val("0.00");
		$('#saldoCapAtrasad').val("0.00");
		$('#saldoCapVencido').val("0.00");
		$('#saldCapVenNoExi').val("0.00");
		$('#totalCapital').val("0.00");
		$('#saldoInterOrdin').val("0.00");
		$('#saldoInterAtras').val("0.00");
		$('#saldoInterVenc').val("0.00");
		$('#saldoInterProvi').val("0.00");
		$('#saldoIntNoConta').val("0.00");
		$('#totalInteres').val("0.00");
		$('#saldoIVAInteres').val("0.00");
		$('#saldoMoratorios').val("0.00");
		$('#saldoIVAMorator').val("0.00");
		$('#saldoComFaltPago').val("0.00");
		$('#saldoOtrasComis').val("0.00");
		$('#totalComisi').val("0.00");
		$('#salIVAComFalPag').val("0.00");
		$('#saldoIVAComisi').val("0.00");
		$('#totalIVACom').val("0.00");
		

		$('#montoComisiones').val("0.00");
		$('#montoMoratorios').val("0.00");
		$('#montoInteres').val("0.00");
		$('#montoCapital').val("0.00");

		$('#porceComisiones').val("0.0000");
		$('#porceMoratorios').val("0.0000");
		$('#porceInteres').val("0.0000");
		$('#porceCapital').val("0.0000");

		$('#montoComisionesPer').val("0.00");
		$('#montoMoratoriosPer').val("0.00");
		$('#montoInteresPer').val("0.00");
		$('#montoCapitalPer').val("0.00");

		$('#porceComisionesPer').val("0.0000");
		$('#porceMoratoriosPer').val("0.0000");
		$('#porceInteresPer').val("0.0000");
		$('#porceCapitalPer').val("0.0000");

		$('#numMaxCondona').val("0");     
		deshabilitaBoton('grabar', 'submit');
	}
	
});

function deshabilitaEstatusPag(){
	var numDetalle = $('input[name=amortizacionID]').length;

	for(var i = 1; i <= numDetalle; i++){
		var estatus = eval("'#estatus" + i + "'");
		var estatusValor = $(estatus).val();
		if(estatusValor == "VIGENTE" || estatusValor ==  "VENCIDO"){

		var interes = eval("'#interes" + i + "'");
		$(interes).removeAttr('disabled');
		$(interes).removeAttr('readOnly');
		
		var saldoMora = eval("'#saldoMoratorios" + i + "'");
		$(saldoMora).removeAttr('disabled');
		$(saldoMora).removeAttr('readOnly');
		
		var saldoComFalP = eval("'#saldoComFaltaPago" + i + "'");
		$(saldoComFalP).removeAttr('disabled');
		$(saldoComFalP).removeAttr('readOnly');
		
//		var saldoOtrasCom = eval("'#saldoOtrasComisiones" + i + "'");
//		$(saldoOtrasCom).removeAttr('disabled');
//		$(saldoOtrasCom).removeAttr('readOnly');
		}
		if(estatusValor == "PAGADA"){
		
		}
	  }  
	}

	function validaCapital (idControl){
		var jCapital = eval("'#" + idControl + "'");
		var numeroID=idControl.substr(7);
	}

	function validaInteres (idControl){
		var jInteres = eval("'#" + idControl + "'");
		var numeroID=idControl.substr(7);
		var modificado = eval("'#campoModificado" + numeroID + "'");
		$(modificado).val('S');
	}

	function validaSaldoMora (idControl){
		var jSaldMora = eval("'#" + idControl + "'");
		var numeroID=idControl.substr(15);
		var modificado = eval("'#campoModificado" + numeroID + "'");
		$(modificado).val('S');
	}

	function validaSaldoComFaltPag (idControl){
		var jSaldComFP = eval("'#" + idControl + "'");
		var numeroID=idControl.substr(17);
		var modificado = eval("'#campoModificado" + numeroID + "'");
		$(modificado).val('S');
	}

	function validaSaldoOtrasCom (idControl){
		var jSaldoOtrasCom = eval("'#" + idControl + "'");
		var numeroID=idControl.substr(20);
		var modificado = eval("'#campoModificado" + numeroID + "'");
		$(modificado).val('S');
	}

//funcion para validar cuando un campo toma el foco
function validaFocoInputMoneda(controlID){
	 jqID = eval("'#" + controlID + "'");
	 if($(jqID).asNumber()>0){
		 $(jqID).select();
	 }else{
		 $(jqID).val("");
	 }
}

function funcionExito(){
	esTab=true;
	agregaFormatoControles('gridAmortiCredFonMovs');
	validaCreditoFondeo();
}

function funcionFallo(){
	
}