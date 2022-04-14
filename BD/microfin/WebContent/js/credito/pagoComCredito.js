var parametroBean = consultaParametrosSession(); 
var fechaSistemaTicket= parametroBean.fechaAplicacion;
var var_empresaID = 1;		// Id de empresa por default
var var_pagoIntVertical = ""; // Indica si exige el total del adeudo de interes o si se puede pagar en parcialidades
var cobraAccesorios = 'N';
var montoAccesorios = 0.00;
var montoIVAAccesorios = 0.00;
var cobraAccesoriosGen = 'N';
var montoComision = 0.00;
var varSucurCli = 0;
var valor1 = '';
var valor2 = '';

var var_numConsultaParamSis = { 
  		'principal'	: 1
	};



$(document).ready(function(){
	$("#creditoID").focus();
	
	consultaParametrosSistema();
	consultaCobraAccesorios();
	
	
	//Definición de constantes y Enums
	esTab = true;
	  
	var catTipoConsultaCredito = { 
  		'principal'	: 1,
  		'foranea'	: 2,
  		'pago'		: 7 
	};	
			
	var catTipoTranCredito = { 
  		'pagoComCargoCtaInd' :26, // Pago de Comisiones Invidual
  		'pagoComCargoCtaMasivo' :27, // Pago de Comisiones Invidual
	};		
	//-----------------------Métodos y manejo de eventos-----------------------
	var montoPagarMayor = 1;
	deshabilitaBoton('amortiza', 'submit');
	deshabilitaBoton('movimientos', 'submit');
	deshabilitaBoton('pagar', 'submit');  	
	$('#impTicket').hide();
	$('#fechaSistema').val(parametroBean.fechaAplicacion);

	agregaFormatoControles('formaGenerica');

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
   			var tipoCobro =  $('#tipoCobro').val();

   			if(tipoCobro == 'I'){
   	    			$('#tipoTransaccion').val(catTipoTranCredito.pagoComCargoCtaInd);	
   	    			// Valida que haya saldo suficiente en la cuenta al cual se hara el cargo
   	    			if(montoPagarMayor == 1){
   	    		

	   	    			if($('#montoPagar').asNumber() > 0){	   	    			
			   	    		if($('#montoPagar').asNumber() <= $('#pagoExigible').asNumber() ){ 
			   	    			var comisionApertura = $('#montoComApertura').asNumber()+$('#IVAComisionApert').asNumber();
			   	    			var comisionSeguro = $('#saldoSeguroCuota').asNumber()+$('#saldoIVASeguroCuota').asNumber();			   	    			
			   	    			var comisionFaltaPago =$('#saldoComFaltPago').asNumber()+$('#salIVAComFalPag').asNumber();
			   	    			var comisionAnualidad =$('#saldoComAnual').asNumber()+$('#saldoComAnualIVA').asNumber();

			   	    			var tipoComision = $('#tipoComision').val();
			   	    			var valorComision = $('#tipoComision').asNumber();

			   	    			if(valorComision ==  0){
			   	    				if(tipoComision == 'CA'){
			   	    				valor1 = $('#montoComApertura').asNumber();
			   	    				valor2 = $('#IVAComisionApert').asNumber();
				   	    			}

				   	    			if(tipoComision == 'PS'){
				   	    				valor1 = $('#saldoSeguroCuota').asNumber();
				   	    				valor2 = $('#saldoIVASeguroCuota').asNumber();
				   	    			}

				   	    			if(tipoComision == 'FP'){
				   	    				valor1 = $('#saldoComFaltPago').asNumber();
				   	    				valor2 = $('#salIVAComFalPag').asNumber();
				   	    			}

				   	    			if(tipoComision == 'AN'){
				   	    				valor1 = $('#saldoComAnual').asNumber();
				   	    				valor2 = $('#saldoComAnualIVA').asNumber();
				   	    			}

			   	    			}else{
			   	    				valor1 = $('#otrasComAnt').asNumber();
			   	    				valor2 = $('#otrasComAntIVA').asNumber();
			   	    			}
			   	    			
			   	    			
			   	    			calculosyOperacionesDosDecimalesSuma(valor1, valor2);
			   	    			
			   	    			if($('#montoPagar').asNumber()>montoComision) {
			   	    				mensajeSis("El monto a Pagar es Mayor al Adeudo de la Comisión");
			   	    			}
			   	    			else{
			   	    				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','numeroTransaccion','funcionExitoPago','funcionFalloPago');
			   	    			}   		

			    	    	
			   	    		}else{
			   	    			mensajeSis('El Monto a Pagar No debe ser Mayor al Total Adeudo de Comisiones.');
			   	    			$('#montoPagar').focus();
			   	    		}
			   	    	
	   	    			} else{
		   	    			mensajeSis('El Monto a Pagar debe ser Mayor Cero.');
		   	    			$('#montoPagar').focus();
	   	    			}
   	    			}
   	    		}else{
   	    			$('#tipoTransaccion').val(catTipoTranCredito.pagoComCargoCtaMasivo);
   	    			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','numeroTransaccion','funcionExitoPago','funcionFalloPago');
   	    		} 
   			
   		}
    });	
   	

   
	$('#montoPagar').blur(function(){
		if($('#montoPagar').asNumber() > $('#saldoCta').asNumber()){
			mensajeSis("El Saldo de la Cuenta es Insuficiente.");
			$('#montoPagar').val(0.00);
			$('#montoPagar').focus();
			montoPagarMayor = 2;
		}else{
			montoPagarMayor = 1;			
		}		
	});

  
	$('#amortiza').click(function(){
		consultaGridAmortizaciones();
	});
	
	$('#movimientos').click(function(){
		consultaGridMovimientos();
	});
		
	$('#creditoID').bind('keyup', function(e){
		lista('creditoID', '2', '44', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
	});
	
	$('#tipoCobro').click(function() {		
		$('#montoPagar').val("");
		$('#tipoCobro').val("I");
		$('#tipoComision').val("");
		$('#pagaIVA').val("");
		$('#creditoID').val("");
		deshabilitaBoton('pagar', 'submit');


		habilitaControl('montoPagar');
		habilitaControl('tipoComision');
		habilitaControl('creditoID');
		mostrarForma();
		
	});
	
	$('#tipoCobro2').click(function() {				
		funcionExito();
		deshabilitaControl('montoPagar');
		deshabilitaControl('creditoID');
		deshabilitaBoton('pagar', 'submit');
		deshabilitaBoton('amortiza', 'submit');
		deshabilitaBoton('movimientos', 'submit');
		

		
		$('#tipoCobro').val("M");
		$('#montoPagar').val("");
		$('#tipoComision').val("");
		$('#pagaIVA').val("");
		$('#creditoID').val("");		
		ocultarForma();		
				
	});

		

	$('#creditoID').blur(function(){
		if(isNaN($('#creditoID').val()) ){
			$('#creditoID').val("");
			$('#creditoID').focus();
		}
		else{
			if(esTab){			
				montoAccesorios = 0.00;
				montoIVAAccesorios = 0.00;

				consultaCredito(this.id);				
				esTab = false;
			}
		 
	 }
	});

	$('#tipoComision').blur(function() {		
		$('#montoPagar').focus();
		
		if(cobraAccesoriosGen == 'S'){
			var accesorioID = $('#tipoComision option:selected').val();
			$('#accesorioID').val(accesorioID);

			if(accesorioID > 0){
				montoAccesorios = 0.00;
				montoIVAAccesorios = 0.00;
				consultaAccesorio(this.id);
			}

		}
		
	}); 
	



	$('#tipoComisionM').change(function() {
		consultaGridCreditos();	
		var tipoComision = $('#tipoComisionM').val();
		if(tipoComision == ""){
			deshabilitaBoton('pagar', 'submit');
		}
		else{
			habilitaBoton('pagar', 'submit');
		}
			
			
	}); 
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
		rules: {
			creditoID: {
				required: true
			},
			montoPagar: {
				required: true,
				number: true
			}
	
		},
		messages: {
			creditoID: {
				required: 'Indique Número de Crédito'
			},
			montoPagar: {
				required: 'Indique Monto a Pagar',
				number: 'Solo Digitos Numericos'
			}
		}		
	});
	
	//-------------Validaciones de controles---------------------					
	//Funcion para consultar el credito
	function consultaCredito(controlID){ 
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito)){
			var creditoBeanCon = { 
					'creditoID':$('#creditoID').val(),
					'fechaActual':$('#fechaSistema').val()
			};

			$('#gridAmortizacion').hide();
  			$('#gridMovimientos').hide();
  			$('#impTicket').hide();
  			
   			creditosServicio.consulta(28,creditoBeanCon,{ async: false, callback:function(credito) {//catTipoConsultaCredito.saldos
				if(credito!=null){
					esTab=true;	

					$('#montoComApertura').val(credito.montoComApertura);
					$('#IVAComisionApert').val(credito.IVAComisionApert);
					$('#clienteID').val(credito.clienteID);
					$('#cuentaID').val(credito.cuentaID);
					consultaCreditoPrincipal();

					
					$('#tipoCobro').attr("checked","1");
					if(credito.fechaProxPago == '1900-01-01'){
   						$('#fechaProxPago').val("");
   					}
				
						consultaCliente('clienteID');	
						consultaCta('cuentaID',credito.grupoID);
						consultaMoneda('monedaID');		
						consultaProducCredito('producCreditoID');	
						var estatus = credito.estatus;
						validaEstatusCredito(estatus);
						consultaLineaCredito(credito.creditoID,credito.lineaCreditoID);
  						consultaExigible();
  						consultaFiniquitoLiqAnticipadaSoloAdeudo();  // consultamos para realizar la validacion.
				}else{
					inicializaForma('formaGenerica','creditoID');
					$('#pagaIVA').val("");
					mensajeSis("No Existe el Crédito.");
					deshabilitaBoton('pagar','submit');
					deshabilitaBoton('movimientos','submit');
					deshabilitaBoton('amortiza','submit');
					$('#creditoID').focus();
					$('#creditoID').select();	
					
				}
			}});
		}
	}
	function llenaCombo(){
		var CreditoID =  $('#creditoID').val();
		$('#tipoComision')
		    .find('option')
		    .remove()
		    .end()
		    .append('<option value="">SELECCIONAR</option>')
		    .val('')
		;

		var comFaltaPago = $('#saldoComFaltPago').val();
		var comSeguroCuota = $('#saldoSeguroCuota').val();
		var comAperturaCred = $('#montoComApertura').val();
		var saldoComAnual = $('#saldoComAnual').val();	
		var accesoriosCred = $('#otrasComAnt').val();
		var comAnualLin = $('#comAnualLin').val();

		if(comFaltaPago != '0.00'){
			$('#tipoComision').append('<option value="FP" selected="selected">COMISI&Oacute;N POR FALTA DE PAGO</option>');
		}
		if(comSeguroCuota != '0.00'){
			$('#tipoComision').append('<option value="PS" selected="selected">COMISI&Oacute;N SEGURO POR CUOTA</option>');
		}
		if(comAperturaCred != '0.00'){
			$('#tipoComision').append('<option value="CA" selected="selected">COMISI&Oacute;N POR APERTURA</option>');
		}
		if(saldoComAnual != '0.00' && comAnualLin=='0.00'){
			$('#tipoComision').append('<option value="AN">COMISI&Oacute;N POR ANUALIDAD</option>');
		}
		if (comAnualLin != '0.00') {
			$('#tipoComision').append('<option value="AN">COMISI&Oacute;N ANUAL L&Iacute;NEA CR&Eacute;DITO</option>');
		}

		if(cobraAccesoriosGen == 'S'){
			if(accesoriosCred != '0.00'){
				consultaAccesoriosCred();

				$('#otrasComAnt').val(montoAccesorios);
				$('#otrasComAntIVA').val(montoIVAAccesorios);

				$('#otrasComAnt').formatCurrency({
					positiveFormat: '%n',  
					negativeFormat: '%n',
					roundToDecimalPlace: 2	
				});	

				$('#otrasComAntIVA').formatCurrency({
					positiveFormat: '%n',  
					negativeFormat: '%n',
					roundToDecimalPlace: 2	
				});

			
			}
		}


	}

function consultaExigible(){
	var numCredito = $('#creditoID').val();
	setTimeout("$('#cajaLista').hide();", 200);
	$('#exigibleDiaPago').val();
	if(numCredito != '' && !isNaN(numCredito)){
		var Con_PagoCred = 8;
		var creditoBeanCon = { 
			'creditoID':$('#creditoID').val(),
			'fechaActual':$('#fechaSistema').val()
		};
  				
		$('#gridAmortizacion').hide();
		$('#gridMovimientos').hide();
		creditosServicio.consulta(Con_PagoCred,creditoBeanCon,{ async: false, callback:function(credito) {//catTipoConsultaCredito.saldos
			if(credito!=null){
				
				$('#saldoCapVigent').val(credito.saldoCapVigent);  
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
				$('#totalIVACom').val(credito.totalIVACom);
				//SEGURO CUOTA
				$('#saldoSeguroCuota').val(credito.saldoSeguroCuota);
				$('#saldoIVASeguroCuota').val(credito.saldoIVASeguroCuota);
				//FIN SEGURO CUOTA
				//COMISION ANUAL
				$('#saldoComAnual').val(credito.saldoComAnual);
				$('#saldoComAnualIVA').val(credito.saldoComAnualIVA);
				//FIN COMISION ANUAL	

				
				
				$('#exigibleAlDia').val(credito.totalExigibleDia);
				$('#montoProyectado').val(credito.totalCuotaAdelantada);
				$('#exigibleDiaPago').val(credito.totalExigibleDia);
							
				$('#saldoSeguroCuota').val(credito.saldoSeguroCuota);
				$('#saldoIVASeguroCuota').val(credito.saldoIVASeguroCuota);

				$('#lblCuotasAtraso').hide();
				$('#cuotasAtraso').hide();
				$('#lblMontoNoCartVencida').hide();
				$('#montoNoCartVencida').hide();
				$('#cuotasAtraso').val('');
				$('#montoNoCartVencida').val('');
					
				if($('#prorrateoPago').val()=='S'){
					$('#ultCuotaPagada').val(credito.ultCuotaPagada);										
					$('#fechaUltCuotaPagada').val(credito.fechaUltCuota);
						
					$('#lblUltCuotaPagada').show();
					$('#ultCuotaPagada').show();
					$('#lblFechaUltCuotaPagada').show();
					$('#fechaUltCuotaPagada').show();
								
					if($('#estatus').val()=='VIGENTE'){
						$('#lblCuotasAtraso').show();
						$('#cuotasAtraso').show();
						$('#cuotasAtraso').val(credito.cuotasAtraso);
						$('#lblMontoNoCartVencida').show();
						$('#montoNoCartVencida').show();
						if(credito.cuotasAtraso==0 || credito.cuotasAtraso==1){
							$('#montoNoCartVencida').val('0.00');
						}else if(credito.cuotasAtraso>1){
							$('#montoNoCartVencida').val(credito.totalPrimerCuota);
						}
					}
				}else if($('#prorrateoPago').val()=='N'){						
					$('#lblUltCuotaPagada').hide();						
					$('#ultCuotaPagada').hide();						
					$('#lblFechaUltCuotaPagada').hide();
					$('#fechaUltCuotaPagada').hide();						
					$('#ultCuotaPagada').val('');
					$('#fechaUltCuotaPagada').val('');
				}		
					$('#montoComApertura').formatCurrency({
						positiveFormat: '%n',  
						negativeFormat: '%n',
						roundToDecimalPlace: 2	
					});			

					$('#IVAComisionApert').formatCurrency({
						positiveFormat: '%n',  
						negativeFormat: '%n',
						roundToDecimalPlace: 2	
					});		
					
					$('#exigibleAlDia').formatCurrency({
						positiveFormat: '%n',  
						negativeFormat: '%n',
						roundToDecimalPlace: 2	
					});	
					$('#montoProyectado').formatCurrency({
						positiveFormat: '%n',  
						negativeFormat: '%n',
						roundToDecimalPlace: 2	
					});
					$('#montoNoCartVencida').formatCurrency({
						positiveFormat: '%n',  
						negativeFormat: '%n',
						roundToDecimalPlace: 2	
					});
					$('#saldoAdmonComis').val("0.00");
					$('#saldoIVAAdmonComisi').val("0.00");		
								
					$('#labelPagoExigiblePC').show();  
					$('#pagoExigible').show();
					if($('#grupoID').val() > 0){  
						$('#labelPagoExiGrupoPC').show();  
						$('#montoTotExigiblePC').show();  
					}
					$('#labelTotalAdeGrupalPC').hide();
					$('#montoTotDeudaPC').hide();
					$('#labelTotalAdeudoPC').hide();



					llenaCombo();			
				$('#pagoExigible').val($('#totalComisi').asNumber()+$('#totalIVACom').asNumber()+
											   $('#montoComApertura').asNumber()+$('#IVAComisionApert').asNumber()+
											   $('#otrasComAnt').asNumber()+$('#otrasComAntIVA').asNumber());
						
						$('#pagoExigible').formatCurrency({
							positiveFormat: '%n',  
							negativeFormat: '%n',
							roundToDecimalPlace: 2	
						});	
						
					var saldoCuenta = $('#saldoCta').val();				

					if(saldoCuenta == '0.00'){
						deshabilitaControl('tipoComision');
						deshabilitaControl('montoPagar');
						deshabilitaBoton('pagar', 'submit');
					}
					else{
						var montoExigible = $('#pagoExigible').val();
					
						if(montoExigible == '0.00'){
							deshabilitaBoton('pagar', 'submit');
						}
						else{
							habilitaControl('tipoComision');
							habilitaControl('montoPagar');
							habilitaBoton('pagar', 'submit');
						}
						
					}
				
					

								
					habilitaBoton('amortiza', 'submit');
					habilitaBoton('movimientos', 'submit');	
				}
				else{
					mensajeSis("No Existe");
					deshabilitaBoton('pagar', 'submit');
				}
			}
		});
		}
	}


	
/* *******  Funcion Usada para la Validacion del monto en el Pago de la Couta            */
	function consultaFiniquitoLiqAnticipadaSoloAdeudo(){
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) ){
			var Con_PagoCred = 17;
			var creditoBeanCon = { 
					'creditoID':$('#creditoID').val(),
					'fechaActual':$('#fechaSistema').val()
					};
			creditosServicio.consulta(Con_PagoCred,creditoBeanCon,function(credito) {//catTipoConsultaCredito.saldos
				if(credito!=null){
					$('#adeudoTotal').val(credito.adeudoTotal);	 	
				}
			});
		}
	}
	
	//Funcion para consultar el nombre del cliente
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConPagoCred = 1;	 
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(tipConPagoCred,numCliente,function(cliente) {
				if(cliente!=null){	
					$('#clienteID').val(cliente.numero);						
					$('#nombreCliente').val(cliente.nombreCompleto);
					$('#pagaIVA').val(cliente.pagaIVA);
					varSucurCli = cliente.sucursalOrigen;
				}else{
					mensajeSis("No Existe el Cliente.");
					$('#clienteID').focus();
					$('#clienteID').select();	
					$('#nombreCliente').val("");
					$('#pagaIVA').val("");
				}    	 						
			});
		}
	}

	//funcion para consultar el tipo de moneda
	function consultaMoneda(idControl) {
		var jqMoneda = eval("'#" + idControl + "'");
		var numMoneda = $(jqMoneda).val();	
		var conMoneda=2;
		if(numMoneda != '' && !isNaN(numMoneda)){
			monedasServicio.consultaMoneda(conMoneda,numMoneda,function(moneda) {
				if(moneda!=null){							
					$('#monedaDes').val(moneda.descripcion);										
				}else{
					mensajeSis("No Existe el Tipo de Moneda.");
					$('#monedaDes').val('');
					$(jqMoneda).focus();
				}
			});
		}
	}

	//Funcion para consultar el producto
	function consultaProducCredito(idControl) {	
		var jqProdCred  = eval("'#" + idControl + "'");
		var numProdCre = $(jqProdCred).val();			

		var conTipoCta=2;
		var ProdCredBeanCon = {
  			'producCreditoID':numProdCre
		};
		if(numProdCre != '' && !isNaN(numProdCre)){
			productosCreditoServicio.consulta(conTipoCta, ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){			
					$('#descripProducto').val(prodCred.descripcion);		
					$('#prorrateoPago').val(prodCred.prorrateoPago);		
				}else{
					$('#'+id).focus();
				}    						
			});
		}
	}
	

	//Funcion para validar el estatus del credito	
	function validaEstatusCredito(var_estatus) {
		var estatusInactivo 	="I";		
		var estatusAutorizado 	="A";
		var estatusVigente		="V";
		var estatusPagado		="P";
		var estatusCancelada 	="C";		
		var estatusVencido		="B";
		var estatusCastigado 	="K";		
		
		if(var_estatus == estatusInactivo){
			$('#estatus').val('INACTIVO');
			habilitaBoton('pagar', 'submit');
		}	
		if(var_estatus == estatusAutorizado){
			$('#estatus').val('AUTORIZADO');
			habilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusVigente){
			$('#estatus').val('VIGENTE');
			habilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusPagado){
			$('#estatus').val('PAGADO');
			deshabilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusCancelada){
			$('#estatus').val('CANCELADO');							
			habilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusVencido){
			$('#estatus').val('VENCIDO');							
			habilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusCastigado){
			$('#estatus').val('CASTIGADO');							
			habilitaBoton('pagar', 'submit');
		}		
	}
	
	//Funcion para validar el estatus de la linea de credito
	function validaEstatusLineaCred(var_estatus) {
		var estatusActivo 		="A";
		var estatusBloqueado 	="B";
		var estatusCancelada 	="C";
		var estatusInactivo 	="I";
		var estatusRegistrada	="R";
	
		if(var_estatus == estatusActivo){
			 $('#estatusLinCred').val('ACTIVO');
		}
		if(var_estatus == estatusBloqueado){
			 $('#estatusLinCred').val('BLOQUEADO');
		}
		if(var_estatus == estatusCancelada){
			 $('#estatusLinCred').val('CANCELADO');
		}
		if(var_estatus == estatusInactivo){
			 $('#estatusLinCred').val('INACTIVO');
		}
		if(var_estatus == estatusRegistrada){
			 $('#estatusLinCred').val('REGISTRADO');
		}		
	}
	
	//Funcion para consultar la descripcion del tipo de cuenta
	function consultaCta(idControl,grupoID) {
		var jqnumCta  = eval("'#" + idControl + "'");
		var numCta = $(jqnumCta).val();	 
        var conCta = 4;   
        
        var CuentaAhoBeanCon = {
        		'cuentaAhoID':numCta,
        		'clienteID':$('#clienteID').val()
        };
        if(numCta != '' && !isNaN(numCta)){
            cuentasAhoServicio.consultaCuentasAho(conCta, CuentaAhoBeanCon,{ async: false, callback:function(cuenta) {
            	if(cuenta!=null){ 
            		$('#nomCuenta').val(cuenta.descripcionTipoCta);
            		if (grupoID>0){
            			consultaSaldoCta('cuentaID');
            		}else{
            			consultaSaldoCta('cuentaID');
            		}
            	}else{
            		mensajeSis("No Existe la Cuenta de Ahorro.");
            	}
            }});                                                                                                                        
        }  
	}

	//Funcion para Consultar el saldo de la cuenta 
	function consultaSaldoCta(idControl) {
		var jqnumCta  = eval("'#" + idControl + "'");
		var numCta = $(jqnumCta).val();	 
        var conCta = 5;   
        var CuentaAhoBeanCon = {
        		'cuentaAhoID':numCta,
        		'clienteID':$('#clienteID').val()
        };
        if(numCta != '' && !isNaN(numCta)){
       		cuentasAhoServicio.consultaCuentasAho(conCta,CuentaAhoBeanCon,{ async: false, callback:function(cuenta) {
                	if(cuenta!=null){                 	               		
						$('#saldoCta').val(cuenta.saldoDispon);            
                	}else{
                		mensajeSis("No Existe la Cuenta de Ahorro.");
                	}
                }});                                                                                                                        
        }        
	}
	
	
	
	//Grid Amortizaciones
	function consultaGridAmortizaciones(){
		var params = {};
		params['creditoID'] = $('#creditoID').val();
		params['tipoLista'] = 2;
		params['cobraSeguroCuota'] 	= $('#cobraSeguroCuota option:selected').val();
		params['cobraAccesorios'] = cobraAccesorios;

		$('#gridMovimientos').hide();
		$.post("consultaCredAmortiGridVista.htm", params, function(data){		
				if(data.length >0) {
					$('#gridAmortizacion').html(data);
					$('#gridAmortizacion').show();
					agregaFormatoControles('gridDetalle');
					agregaFormatoControles('gridDetalleMov'); 
					agregaFormatoControles('formaGenerica2');
					if ($('#siguiente').is(':visible') && $('#anterior').is(':visible')==false){
						$('#filaTotales').hide();	
					}

					if ($('#siguiente').is(':visible')==false && $('#anterior').is(':visible')==false){
						$('#filaTotales').show();	
					}
					muestraDescTasaVar('');
				}else{
					$('#gridAmortizacion').html("");
					$('#gridAmortizacion').show();
				}
		});
		agregaFormatoControles('formaGenerica');
	}
	
	//Grid movimientos
	function consultaGridMovimientos(){
		var params = {};
		params['creditoID'] = $('#creditoID').val();		
		params['tipoLista'] = 1;
		$('#gridAmortizacion').hide();
		$.post("creditoConsulMovsGridVista.htm", params, function(data){		
				if(data.length >0) {
					$('#gridMovimientos').html(data);
					$('#gridMovimientos').show(); 
					agregaFormatoControles('gridDetalle');
					agregaFormatoControles('gridDetalleMov');
					agregaFormatoControles('formaGenerica3');
				}else{
					$('#gridMovimientos').html("");
					$('#gridMovimientos').show();
				}
		});
		agregaFormatoControles('formaGenerica');
	}

	function consultaLineaCredito(CreditoID,LineaCreditoID){
		var porcentajeIVA = 0.00;
		var lineaCreditoBeanCon = {
			'lineaCreditoID'	: LineaCreditoID
		};

		if (LineaCreditoID!=0 && $('#pagaIVA').val()=='S') {

			sucursalesServicio.consultaSucursal(1,varSucurCli,{ 
				async: false, 
				callback: function(sucursal) {
					porcentajeIVA = sucursal.IVA;
				}
			});

			lineasCreditoServicio.consulta(1,lineaCreditoBeanCon,{
				async : false,
				callback : function(linea) {
					if (linea!=null) {
						$("#comAnualLin").val(linea.comisionAnual);
						$("#IVAComAnualLin").val($("#comAnualLin").asNumber()*porcentajeIVA);
						$("#IVAComAnualLin").formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2	
						});
					}
				}
			});
		}else{
			$("#comAnualLin").val('0.00');
			$("#IVAComAnualLin").val('0.00');
		}
	}
	
}); //Fin de Document Ready

	//Funcion que se ejecuta cuanto hay exito de la transaccion
	function funcionExitoPago(){
		var tipoCobro = $('#tipoCobro').val();
		if(tipoCobro== 'I'){
			var tipoComision = $('#tipoComision').val();
			$('#impTicket').show();
		
			if(tipoComision == 'FP' || tipoComision == 'PS' || tipoComision == 'AN'){
				imprimeTicketPago();	
			}
			if(tipoComision == 'CA'){
				imprimeTicketComAp();
			}
			
			$('#tipoComision').val("");	
			$('#tipoComision')
		    .find('option')
		    .remove()
		    .end()
		    .append('<option value="">SELECCIONAR</option>')
		    .val('');
		    $('#tipoCobro').attr("checked",true);
			$('#tipoCobro2').attr("checked",false);
			deshabilitaBoton('impTicket', 'submit');
		}
		else{
			$('#tipoCobro2').attr("checked",true);
			$('#tipoCobro').attr("checked",false);
		}
		
		
		deshabilitaBoton('amortiza', 'submit');
		deshabilitaBoton('movimientos', 'submit');
		deshabilitaBoton('pagar', 'submit');
	
		funcionExito();
		$('#contenedorMsg').css("width","275px");
		$('#contenedorMsg').css("left","-75px");
		

	}

	//Funcion que se ejecuta cuanto hay una falla de la transaccion
	function funcionFalloPago(){
		$('#pagaIVA').val("");
		$('#contenedorMsg').css("width","275px");
		$('#contenedorMsg').css("left","-75px");
	}

	function funcionExito(){
		$('#pagaIVA').val("");		
		$('#tipoComisionM').val("");		
		$('#clienteID').val("");
		$('#nombreCliente').val("");
		$('#pagaIVA').val("");
		$('#cuentaID').val("");
		$('#nomCuenta').val("");
		$('#saldoCta').val("");
		$('#estatus').val("");
		$('#montoPagar').val("");
		$('#adeudoTotal').val("");
		$('#pagoExigible').val("");
		$('#cobraSeguroCuota').val("");
		$('#saldoCapVigent').val("");
		$('#saldoCapAtrasad').val("");
		$('#saldoCapVencido').val("");
		$('#saldCapVenNoExi').val("");
		$('#totalCapital').val("");
		$('#saldoInterOrdin').val("");
		$('#saldoInterAtras').val("");
		$('#saldoInterVenc').val("");
		$('#saldoInterProvi').val("");
		$('#saldoIntNoConta').val("");
		$('#totalInteres').val("");
		$('#saldoIVAInteres').val("");
		$('#saldoMoratorios').val("");
		$('#saldoIVAMorator').val("");	
		$('#saldoComFaltPago').val("");
		$('#saldoOtrasComis').val("");
		$('#saldoAdmonComis').val("");
		$('#totalComisi').val("");
		$('#salIVAComFalPag').val("");
		$('#saldoIVAComisi').val("");
		$('#saldoIVAAdmonComisi').val("");
		$('#totalIVACom').val("");
		$('#montoComApertura').val("");
		$('#IVAComisionApert').val("");
		$('#otrasComAnt').val("");
		$('#otrasComAntIVA').val("");
		//SEGURO CUOTA
		$('#saldoSeguroCuota').val("");
		$('#saldoIVASeguroCuota').val("");
		//FIN SEGURO CUOTA
		//COMISION ANUAL
		$('#saldoComAnual').val("");
		$('#saldoComAnualIVA').val("");
		//FIN COMISION ANUAL
	}

	function ocultaPagoCuotas(){
		$('#lblUltCuotaPagada').hide();
		$('#ultCuotaPagada').hide();
		$('#lblFechaUltCuotaPagada').hide();
		$('#fechaUltCuotaPagada').hide();
		$('#lblCuotasAtraso').hide();
		$('#cuotasAtraso').hide();
		$('#lblMontoNoCartVencida').hide();
		$('#montoNoCartVencida').hide();	
		$('#ultCuotaPagada').val('');
		$('#fechaUltCuotaPagada').val('');
		$('#cuotasAtraso').val('');
		$('#montoNoCartVencida').val('');
	}
	
	function muestraPagoCuotas(){
		$('#lblUltCuotaPagada').show();
		$('#ultCuotaPagada').show();
		$('#lblFechaUltCuotaPagada').show();
		$('#fechaUltCuotaPagada').show();
		$('#lblCuotasAtraso').show();
		$('#cuotasAtraso').show();
		$('#lblMontoNoCartVencida').show();
		$('#montoNoCartVencida').show();
	}
	
	//Funciones que se ocupan en el grid
	function totalizaCap(){
		 var suma=0;
			$('input[name=capital]').each(function() {
				var numero= this.id.substr(7,this.id.length);
				var totalCap = eval("'capital" + numero+ "'");
				var capital=$('#'+totalCap).asNumber();
					suma = suma+capital;	
				});
					return suma;
			}
	
	function totalizaInteres(){
		 var suma=0;
			$('input[name=interes]').each(function() {
				var numero= this.id.substr(7,this.id.length);
				var totalCap = eval("'interes" + numero+ "'");
				var capital=$('#'+totalCap).asNumber();
					suma = suma+capital;	
				});
					return suma;
			}
	function totalizaIva(){
		 var suma=0;
			$('input[name=ivaInteres]').each(function() {
				var numero= this.id.substr(10,this.id.length);
				var totalCap = eval("'interes" + numero+ "'");
				var capital=$('#'+totalCap).asNumber();
					suma = suma+capital;	
				});
					return suma;
			}

	
	// - Consulta parametros del sistema para verificar si la empresa esta configurada que requiere huella digital y parametros de renovaciones - //
	function consultaParametrosSistema() {		
		var bean = {
				'empresaID'	: var_empresaID
		};
		parametrosSisServicio.consulta(var_numConsultaParamSis.principal, bean, { async: false, callback: function(parametrosSisBean) {
			if (parametrosSisBean != null) {
				var_pagoIntVertical = parametrosSisBean.pagoIntVertical; 
			}
		}
		});
	}
	
	
	
	$('#impTicket').click(function(){
		reimprimirTicket();
	});

	function imprimeTicketPago(){
		var tituloOperacion=  'PAGO COMISIONES DE CREDITO CON CARGO A CUENTA';
		var nombreGrupo = '';
		var cicloGrupo = 0;
		
		var productoCredito=$('#producCreditoID').val()+"   "+$('#descripProducto').val();	
			window.open('RepTicketPagoCredito.htm?fechaSistemaP='+fechaSistemaTicket+
					'&monto='+$('#montoPagar').val()+'&nombreInstitucion='+parametroBean.nombreInstitucion+'&numeroSucursal='+
					parametroBean.sucursal+'&nombreSucursal='+ parametroBean.nombreSucursal+'&varCreditoID='+$('#creditoID').val()+
					'&numCopias='+1+'&varFormaPago='+"Cargo a Cuenta"+'&numTrans='+$('#numeroTransaccion').val()+
					'&moneda='+$('#monedaDes').val()+'&productoCred='+productoCredito+'&grupo='+nombreGrupo+'&ciclo='+
					cicloGrupo+'&tituloOperacion='+tituloOperacion+'&edoMunSucursal='+parametroBean.edoMunSucursal, '_blank');		
	}


	function reimprimirTicket(){
		var tituloOperacion = 'PAGO COMISIONES DE CREDITO CON CARGO A CUENTA';
		var nombreGrupo = '';
		var cicloGrupo = 0;

		var productoCredito=$('#producCreditoID').val()+"   "+$('#descripProducto').val();	
		$('#enlaceTicket').attr('href','RepTicketPagoCredito.htm?fechaSistemaP='+fechaSistemaTicket+
					'&monto='+$('#montoPagar').val()+'&nombreInstitucion='+parametroBean.nombreInstitucion+'&numeroSucursal='+
					parametroBean.sucursal+'&nombreSucursal='+ parametroBean.nombreSucursal+'&varCreditoID='+$('#creditoID').val()+
					'&numCopias='+1+'&varFormaPago='+"Cargo a Cuenta"+'&numTrans='+$('#numeroTransaccion').val()+
					'&moneda='+$('#monedaDes').val()+'&productoCred='+productoCredito+'&grupo='+nombreGrupo+'&ciclo='+
					cicloGrupo+'&tituloOperacion='+tituloOperacion+'&edoMunSucursal='+parametroBean.edoMunSucursal, '_blank');		
	}
	function imprimeTicketComAp(){
		var tituloOperacion=  'PAGO COMISIONES DE CREDITO CON CARGO A CUENTA';
		var nombreGrupo = '';
		var cicloGrupo = 0;
		var total = 0.00;
		var iva = 0.00;
		
		var saldoCuenta = $('#saldoCta').asNumber();
		var montoPagar = $('#montoPagar').asNumber();
		var montoComision = 0.00;
		if(saldoCuenta >= montoPagar){
			total = montoPagar;

			montoComision = total/1.16;
			iva = total-montoComision;
		}
		else{
			total = montoPagar - saldoCuenta;
			montoComision = total/1.16;
			iva = total-montoComision;
		}
				
		
		var productoCredito=$('#producCreditoID').val()+"   "+$('#descripProducto').val();	
			window.open('RepTicketPagoComApCredito.htm?fechaSistemaP='+fechaSistemaTicket+
					'&monto='+$('#montoPagar').val()+
					'&nombreInstitucion='+parametroBean.nombreInstitucion
					+'&numeroSucursal='+parametroBean.sucursal+'&nombreSucursal='
					+ parametroBean.nombreSucursal+'&varCreditoID='+$('#creditoID').val()+
					'&numCopias='+1+'&varFormaPago='+"Cargo a Cuenta"+
					'&numTrans='+$('#numeroTransaccion').val()+
					'&moneda='+$('#monedaDes').val()+'&productoCred='+productoCredito+
					'&grupo='+nombreGrupo+'&ciclo='+cicloGrupo
					+'&tituloOperacion='+tituloOperacion+'&edoMunSucursal='
					+parametroBean.edoMunSucursal
					+'&clienteID='+$('#clienteID').val()
					+'&nombreCliente='+$('#nombreCliente').val()
					+'&cuentaID='+$('#cuentaID').val()
					+'&nomCuenta='+$('#nomCuenta').val()
					+'&montoPagar='+ montoPagar
					+'&totalComAper='+montoComision
					+'&IVAComisionApert='+iva
					, '_blank');		
	
	}

	//Grid movimientos
	function consultaGridCreditos(){
		var params = {};
		params['creditoID'] = $('#tipoComisionM').val();		
		params['tipoLista'] = 45;
		$.post("listaCreditosGridVista.htm", params, function(data){
				if(data.length >0) {
					$('#divListaCreditos').html(data);
					$('#divListaCreditos').hide();	
					$('#fieldsetLisCred').hide();
					var numFilas=consultaFilas();						
					if(numFilas == 0 ){
						$('#divListaCreditos').html("");
						$('#divListaCreditos').hide();	
						$('#fieldsetLisCred').hide();
						deshabilitaBoton('pagar', 'submit');
					}
				}else{
					$('#divListaCreditos').html("");
					$('#divListaCreditos').hide();	
					$('#fieldsetLisCred').hide();
					deshabilitaBoton('pagar', 'submit');
				}
		});
		agregaFormatoControles('formaGenerica');
	}

	function mostrarForma(){
		$('#pagoIndividual').show();
		$('#pagoMasivo').hide();

		$('#comisionesAnticipadas').show();
		$('#detalleCredito').show();
		$('#amortiza').show();
		$('#movimientos').show();

		$('#comisionAnualLinea').show();

	}
	function ocultarForma(){
		$('#pagoIndividual').hide();
		$('#pagoMasivo').show();

		$('#comisionesAnticipadas').hide();
		$('#detalleCredito').hide();
		$('#amortiza').hide();
		$('#movimientos').hide();

		$('#comisionAnualLinea').hide();
		
	}
	function consultaFilas(){
	var totales=0;
	$('tr[name=renglons]').each(function() {
		totales++;
		
	});
	return totales;
}


function consultaCreditoPrincipal() {
	var numCredito = $('#creditoID').val();
	var fechaAplicacion = parametroBean.fechaAplicacion;
	setTimeout("$('#cajaLista').hide();", 200);
				
	if(numCredito != '' && !isNaN(numCredito) ){
		var creditoBeanCon = {
				'creditoID':$('#creditoID').val()
		};			
		creditosServicio.consulta(1,creditoBeanCon,{ async: false, callback: function(credito) {
			if(credito!=null){
				cobraAccesorios = credito.cobraAccesorios;								  
			}else{
					mensajeSis("No Existe el Crédito.");
					$('#creditoID').focus();
					$('#creditoID').val("");
					
			}
		}});										
	}
}	
		

// funcion que llena el combo de accesorios cuando se consulta el credito
function consultaAccesoriosCred() {
	var accesoriosBean = {
						'creditoID' : $('#creditoID').val()
				};
	esquemaOtrosAccesoriosServicio.listaCombo(4,accesoriosBean,{ async: false, callback:function(accesoriosBean) {
		for ( var i = 0; i < accesoriosBean.length; i++) {
			$('#tipoComision').append(new Option(accesoriosBean[i].nombreCorto,accesoriosBean[i].accesorioID,false));
			montoAccesorios =  Number(montoAccesorios) + Number(accesoriosBean[i].montoAccesorio);
			montoIVAAccesorios = Number(montoIVAAccesorios) + Number(accesoriosBean[i].montoIVAAccesorio);

			
		}


	}});
}



function consultaAccesorio(idControl) {
	var jqAccesorio  = eval("'#" + idControl + "'");
	var numAccesorio = $(jqAccesorio).val();
	var credito = 	 $('#creditoID').val();
    var conAccesorio = 2;   
    var DetalleAccesoriosBeanCon = {
    		'accesorioID':numAccesorio,
    		'creditoID': credito
    };
    if(numAccesorio != '' && !isNaN(numAccesorio)){
   		esquemaOtrosAccesoriosServicio.consulta(conAccesorio,DetalleAccesoriosBeanCon,{ 
   			async: false, 
   			callback:function(accesorio) {
            	if(accesorio!=null){    
					$('#otrasComAnt').val(accesorio.saldoAccesorio);
					$('#otrasComAntIVA').val(accesorio.saldoIVAAccesorio); 

					$('#otrasComAnt').formatCurrency({
						positiveFormat: '%n',  
						negativeFormat: '%n',
						roundToDecimalPlace: 2	
					});	

					$('#otrasComAntIVA').formatCurrency({
						positiveFormat: '%n',  
						negativeFormat: '%n',
						roundToDecimalPlace: 2	
					});      
            	}else{
            		mensajeSis("No Existen Accesorios Relacionados al Credito.");
            	}
            }
        });                                                                                                                        
    }        
}

function consultaCobraAccesorios(){
	var tipoConsulta = 24;
	var bean = { 
			'empresaID'		: 1		
		};
	
	paramGeneralesServicio.consulta(tipoConsulta, bean, { async: false, callback:function(parametro) {
			if (parametro != null){	
				cobraAccesoriosGen = parametro.valorParametro;
				
				
			}else{
				cobraAccesoriosGen = 'N';
			}
			
	}});
}


/*
 * FUNCION PARA HACER OPERACION DE SUMA DE LA COMISION
 * EL RESULTADO REDONDEADO CON DOS DECIMALES
 */
function calculosyOperacionesDosDecimalesSuma(valor1, valor2) {
	var calcOperBean = {
			'valorUnoA' : valor1,
			'valorDosA' : valor2,
			'valorUnoB' : 0,
			'valorDosB' : 0,
			'numeroDecimales' : 2
	};
	setTimeout("$('#cajaLista').hide();", 200);
	calculosyOperacionesServicio.calculosYOperaciones(3,calcOperBean,{ async: false, callback:function(valoresResultado) {
		if (valoresResultado != null) {
			montoComision = valoresResultado.resultadoDosDecimales;
			
		}
	}});
}