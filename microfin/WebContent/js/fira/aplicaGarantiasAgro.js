var parametroBean = consultaParametrosSession(); 
var porcentajeApli = 0;
var tipoConsultaSaldo = 0;
var montoTotalSinGar = 0;
var cobraAccesorios = 'N';

var var_numConsultaParamSis = { 
  		'principal'	: 1
	};
$(document).ready(function(){
	$("#creditoID").focus();
	
	
	//Definición de constantes y Enums
	esTab = true;
	  
	var catTipoConsultaCredito = { 
  		'principal'	: 1
	};	

	var catTipoConsultaLineaCreditoAgro = { 
		'principal'				: 4
	};	
			
	var catTipoTranCredito = { 
  		'aplicaGarantias': 2, 
  		'cancelarGarantia':13
	};		
	//-----------------------Métodos y manejo de eventos-----------------------
	deshabilitaBoton('amortiza', 'submit');
	deshabilitaBoton('movimientos', 'submit');
	deshabilitaBoton('aplicar', 'submit');  
	deshabilitaBoton('cancelar', 'submit');	
	deshabilitaControl('totalAdeudo');
	deshabilitaControl('programaEsp');

	$('#fechaSistema').val(parametroBean.fechaAplicacion);

	agregaFormatoControles('formaGenerica');
	inicializaForma('formaGenerica','creditoID');

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
   			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','numeroTransaccion','funcionExitoPago','funcionFalloPago');	   	    		
	   	    	
   		}
    });	
   	
  
	$('#amortiza').click(function(){
		consultaGridAmortizaciones();
	});
	
	$('#movimientos').click(function(){
		consultaGridMovimientos();
	});
	
	$('#aplicar').click(function(){
		var saldo = $('#garantiaAplicar').asNumber();
		consultaSaldo(saldo,tipoConsultaSaldo);
		$('#tipoTransaccion').val(catTipoTranCredito.aplicaGarantias);
	});
	
	$('#cancelar').click(function(){
		$('#tipoTransaccion').val(catTipoTranCredito.cancelarGarantia);
	});
	
		
	$('#creditoID').bind('keyup', function(e){
		lista('creditoID', '2', '49', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
	});

		

	$('#creditoID').blur(function(){
		if(isNaN($('#creditoID').val()) ){
			$('#creditoID').val("");
			$('#creditoID').focus();
		}
		else{
			if(esTab){
				consultaCredito(this.id);
				esTab = false;
			}
		 
	 }
	});
	
	$('#observacion').blur(function(){
		var texto = $('#observacion').val();
		texto = texto.replace(/[\n\r\t\f\b]/g, " ");
		$('#observacion').val(texto.slice(0, 500));
	});


	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
		rules: {
			creditoID: {
				required: true
			},
			observacion: {required :function() {
				if($("#tipoTransaccion").val() == 2 ) return true; else return false;}
			},
			creditoContFondeador: {
				required :function() {
					if($("#tipoTransaccion").val() == 2 ) return true; else return false;}
			},
			acreditadoIDFIRA: {
				required :function() {
					if($("#tipoTransaccion").val() == 2 ) return true; else return false;}
			}
		},
		messages: {
			creditoID: {
				required: 'Indique Número de  Crédito'
			},
			observacion: {
				required: 'Indique la Causa de Pago'
			},
			creditoContFondeador: {
				required: 'Indique el Número de Crédito Contigente'
			},
			acreditadoIDFIRA: {
				required: 'Indique el Número de Acréditado'
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
			var creditoBean = { 
					'creditoID':$('#creditoID').val(),
			};

			$('#gridAmortizacion').hide();
  			$('#gridMovimientos').hide();
  			$('#creditoContFondeador').val('');
  			$('#observacion').val('');

  			$('#acreditadoIDFIRA').val('');
  			$('#observacion').val('');
			habilitaControl('observacion');
			habilitaControl('creditoContFondeador');
			habilitaControl('acreditadoIDFIRA');
  			
  			garantiaFiraServicio.consulta(1,creditoBean,function(garantias) {
  				if(garantias.existeGtia == 'N'){
		   			creditosServicio.consulta(31,creditoBeanCon,function(credito) {
						if(credito!=null){
							esTab=true;	
							if(credito.esAgropecuario == 'S'){
								if(credito.tipoGarantiaFIRAID > 0){
									if(credito.estatusGarantiaFIRA == 'A'){
										if(credito.diasFaltaPago >= 1){
											if(credito.diasFaltaPago <= 120){
												if(credito.montoMinisPen == 0){
													
													if(credito.fechaProxPago == '1900-01-01'){
								   						$('#fechaProxPago').val("");
								   					}
														
													$('#creditoID').val(credito.creditoID);
													$('#clienteID').val(credito.clienteID);
													$('#cuentaID').val(credito.cuentaID);
													$('#estatus').val(credito.estatus);
													$('#garantiaLiquida').val(credito.montoGarLiq);
													$('#monedaID').val(credito.monedaID);
													$('#diasFaltaPago').val(credito.diasFaltaPago);
													$('#tasaFija').val(credito.tasaFija);
													$('#fechaProxPago').val(credito.fechaProxPago);
													$('#lineaCreditoID').val(credito.lineaCreditoID);
													$('#producCreditoID').val(credito.producCreditoID);
													$('#programaEsp').val(0.00);
													$('#estatusGarantia').val(credito.estatusGarantiaFIRA);
													$('#tipoGarantiaID').val(credito.tipoGarantiaFIRAID);

													$('#garantiaLiquida').formatCurrency({
														positiveFormat: '%n',  
														negativeFormat: '%n',
														roundToDecimalPlace: 2	
													});

													
													if(credito.tipoGarantiaFIRAID == 1){
														if($('#garantiaLiquida').asNumber() > 0){
															porcentajeApli = 0.45;
														}else{
															porcentajeApli = 0.50;
														}
															
														tipoConsultaSaldo = 11;
														$('#fega').attr('checked',true);
														$('#fonaga').attr('checked',false);
													}else if(credito.tipoGarantiaFIRAID == 2){
														$('#fega').attr('checked',false);
														$('#fonaga').attr('checked',true);
														porcentajeApli = 0.90;
														tipoConsultaSaldo = 12;														
													}else if(credito.tipoGarantiaFIRAID == 3){
														$('#fega').attr('checked',true);
														$('#fonaga').attr('checked',true);
														porcentajeApli = 0.90;
														tipoConsultaSaldo = 12;
													}
													$('#acreditadoIDFIRA').val(credito.acreditadoIDFIRA);

													$('#programaEsp').formatCurrency({
														positiveFormat: '%n',  
														negativeFormat: '%n',
														roundToDecimalPlace: 2	
													});	
														$('#porcentajeGtia').val(porcentajeApli);
														consultaCliente('clienteID');			
														consultaMoneda('monedaID');							
														consultaLineaCredito('lineaCreditoID');	
														consultaCta('cuentaID',credito.grupoID);
														consultaProducCredito('producCreditoID');				
														var estatus = credito.estatus;
														validaEstatusCredito(estatus);	
																		
								  					consultaFiniquitoLiqAnticipada(credito.grupoID,$('#garantiaLiquida').asNumber(),$('#porcentajeGtia').asNumber());
												}else{
								  					inicializaForma('formaGenerica','creditoID');
													$('#pagaIVA').val("");
													mensajeSis("El Crédito Tiene Ministraciones Pendientes, No es Posible Aplicar las Garantías.");
													deshabilitaBoton('aplicar','submit');
													habilitaBoton('cancelar','submit');
													deshabilitaBoton('movimientos','submit');
													deshabilitaBoton('amortiza','submit');
													$('#creditoID').focus();
													$('#creditoID').select();
													limpiaCampos();
												}
											}else{
												$('#pagaIVA').val("");
												inicializaForma('formaGenerica','creditoID');
												mensajeSis("El Crédito Tiene mas de 120 días de Atraso, no se Puede Aplicar las Garantías.");
												deshabilitaBoton('aplicar','submit');
												deshabilitaBoton('cancelar','submit');
												deshabilitaBoton('movimientos','submit');
												deshabilitaBoton('amortiza','submit');
												$('#creditoID').focus();
												$('#creditoID').select();
												limpiaCampos();
											}
											
										}else if(credito.diasFaltaPago < 1){
											inicializaForma('formaGenerica','creditoID');
											$('#pagaIVA').val("");
											mensajeSis("El Crédito no Tiene Días de Atraso, No se Pueden Aplicar las  Garantías.");
											deshabilitaBoton('aplicar','submit');
											habilitaBoton('cancelar','submit');
											deshabilitaBoton('movimientos','submit');
											deshabilitaBoton('amortiza','submit');
											$('#creditoID').focus();
											$('#creditoID').select();
											limpiaCampos();
										}
									}else if(credito.estatusGarantiaFIRA =='I'){
					  					
					  					inicializaForma('formaGenerica','creditoID');
										$('#pagaIVA').val("");
										mensajeSis("Las Garantías FIRA Relacionadas al Crédito no están Autorizadas.");
										deshabilitaBoton('aplicar','submit');
										deshabilitaBoton('cancelar','submit');
										deshabilitaBoton('movimientos','submit');
										deshabilitaBoton('amortiza','submit');
										$('#creditoID').focus();
										$('#creditoID').select();
										limpiaCampos();
										
									}else if(credito.estatusGarantiaFIRA =='C'){
					  					
					  					inicializaForma('formaGenerica','creditoID');
										$('#pagaIVA').val("");
										mensajeSis("Las Garantías FIRA Relacionadas al Crédito Estan Canceladas.");
										deshabilitaBoton('aplicar','submit');
										deshabilitaBoton('cancelar','submit');
										deshabilitaBoton('movimientos','submit');
										deshabilitaBoton('amortiza','submit');
										$('#creditoID').focus();
										$('#creditoID').select();
										limpiaCampos();
									}
									else if(credito.estatusGarantiaFIRA =='P'){
					  					
					  					inicializaForma('formaGenerica','creditoID');
										$('#pagaIVA').val("");
										mensajeSis("Las Garantías FIRA Relacionadas al Crédito ya Fueron Aplicadas.");
										deshabilitaBoton('aplicar','submit');
										deshabilitaBoton('cancelar','submit');
										deshabilitaBoton('movimientos','submit');
										deshabilitaBoton('amortiza','submit');
										$('#creditoID').focus();
										$('#creditoID').select();
										limpiaCampos();
									}
		
								}else{
				  					
				  					inicializaForma('formaGenerica','creditoID');
									$('#pagaIVA').val("");
									mensajeSis("El Crédito no Tiene Contratadas Garantías FIRA.");
									deshabilitaBoton('aplicar','submit');
									deshabilitaBoton('cancelar','submit');
									deshabilitaBoton('movimientos','submit');
									deshabilitaBoton('amortiza','submit');
									$('#creditoID').focus();
									$('#creditoID').select();
									limpiaCampos();
								}
								
							}else{
								inicializaForma('formaGenerica','creditoID');
								$('#pagaIVA').val("");
								mensajeSis("El Crédito No es Agropecuario.");
								deshabilitaBoton('aplicar','submit');
								deshabilitaBoton('cancelar','submit');
								deshabilitaBoton('movimientos','submit');
								deshabilitaBoton('amortiza','submit');
								$('#creditoID').focus();
								$('#creditoID').select();
								limpiaCampos();
								
							}
									
							
						}else{
							inicializaForma('formaGenerica','creditoID');
							$('#pagaIVA').val("");
							mensajeSis("No Existe el Crédito.");
							deshabilitaBoton('aplicar','submit');
							deshabilitaBoton('cancelar','submit');
							deshabilitaBoton('movimientos','submit');
							deshabilitaBoton('amortiza','submit');
							$('#creditoID').focus();
							$('#creditoID').select();	
							limpiaCampos();
							
						}
					});
  				}else if (garantias.existeGtia != 'N'){
  					inicializaForma('formaGenerica','creditoID');
					$('#pagaIVA').val("");
					mensajeSis("La Aplicación de Garantías ya fue Realizada.");
					deshabilitaBoton('aplicar','submit');
					deshabilitaBoton('cancelar','submit');
					deshabilitaBoton('movimientos','submit');
					deshabilitaBoton('amortiza','submit');
					$('#creditoID').focus();
					$('#creditoID').select();
					limpiaCampos();
  					
  				}
  			});
		}
	}
	
	
	//Funcion para consultar los saldos
	function consultaFiniquitoLiqAnticipada(grupoID, montoGL,porcentajeApli){
		var numCredito = $('#creditoID').val();
		if(numCredito != '' && !isNaN(numCredito) ){
			var Con_PagoCred = 17;
			var creditoBeanCon = { 
					'creditoID':$('#creditoID').val(),
					'fechaActual':$('#fechaSistema').val()
					};
			var grupoBeanCon = { 
			  		'grupoID':grupoID
					};
			
			$('#gridAmortizacion').hide();
			$('#gridMovimientos').hide();
			creditosServicio.consulta(Con_PagoCred,creditoBeanCon,function(credito) {//catTipoConsultaCredito.saldos
				if(credito!=null){
						$('#saldoCapVigent').val(credito.saldoCapVigent);  
						$('#saldoCapAtrasad').val(credito.saldoCapAtrasad);  
						$('#saldoCapVencido').val(credito.saldoCapVencido);
						$('#saldCapVenNoExi').val(credito.saldCapVenNoExi);    
						$('#totalCapital').val(credito.totalCapital);  
						$('#saldoInterOrdin').val(credito.saldoInterOrdin);
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
						$('#saldoAdmonComis').val(credito.saldoAdmonComis);	
						$('#saldoIVAAdmonComisi').val(credito.saldoIVAAdmonComisi);	
						$('#totalAdeudo').val(credito.adeudoTotal);
						$('#montoTotCredSinIVA').val(credito.adeudoTotalSinIVA);
						
						
						$('#montoTotCredSinIVA').formatCurrency({
							positiveFormat: '%n',  
							negativeFormat: '%n',
							roundToDecimalPlace: 2	
						});	

						if(montoGL < $('#totalAdeudo').val(credito.adeudoTotal).asNumber() ){
							$('#garantiaAplicar').val(($('#totalAdeudo').asNumber()-montoGL)*porcentajeApli);

							montoTotalSinGar = $('#totalAdeudo').asNumber()-montoGL;

						}else{
							$('#garantiaAplicar').val(0);
							montoTotalSinGar = $('#totalAdeudo').asNumber();
						}
						var saldo = $('#garantiaAplicar').val();
						
						$('#garantiaAplicar').formatCurrency({
							positiveFormat: '%n',  
							negativeFormat: '%n',
							roundToDecimalPlace: 2	
						});	
						
						if(grupoID > 0){
							
							gruposCreditoServicio.consulta(11,grupoBeanCon,function(grupos) {
								if(grupos!=null){ 
									habilitaBoton('aplicar','submit');
									habilitaBoton('amortiza', 'submit');
									habilitaBoton('movimientos', 'submit');
									habilitaBoton('cancelar','submit');
									
								}else{ 
									mensajeSis("El Crédito es Grupal, no se ha Realizado el Rompimiento del Grupo, no se Puede Aplicar las Garantías.");
									$('#creditoID').val("");
									$('#creditoID').focus();
									inicializaForma('formaGenerica','creditoID');
									limpiaCampos();
									$('#clienteID').val("");
									$('#nombreCliente').val("");
									$('#cuentaID').val("");
									$('#nomCuenta').val("");
									$('#saldoCta').val("");
									$('#fechaProxPago').val("");
									deshabilitaBoton('movimientos','submit');	
									deshabilitaBoton('amortiza','submit');	
									deshabilitaBoton('aplicar','submit');
									deshabilitaBoton('cancelar','submit');				
									}
								});	
							
						}else{							
							habilitaBoton('aplicar','submit');
							habilitaBoton('amortiza', 'submit');
							habilitaBoton('movimientos', 'submit');
							habilitaBoton('cancelar','submit');
						}
				}else{
					mensajeSis("No Existe el Crédito.");
					$('#pagaIVA').val("");
				}
			});
		}
	}
	
	$('#garantiaAplicar').blur(function(event){
		if(montoTotalSinGar < $('#garantiaAplicar').asNumber()){
			$('#garantiaAplicar').val(montoTotalSinGar);
			$('#garantiaAplicar').formatCurrency({
							positiveFormat: '%n',  
							negativeFormat: '%n',
							roundToDecimalPlace: 2	
						});	
			$('#garantiaAplicar').focus();
			mensajeSis("No es Posible Aplicar Garanía Fira Mayor al (Total Adeudo - Garantía Liquida)");

		}
	});
	
	function consultaSaldo(saldoAplicar,tipoConsulta){
		var bean = { 
				'empresaID'		: 1		
			};
		
		paramGeneralesServicio.consulta(tipoConsulta, bean, function(parametro) {
				if (parametro != null){	
					var saldoGtia = parseFloat(parametro.valorParametro);
					if(saldoGtia >= saldoAplicar){
						
					}
					else{
						inicializaForma('formaGenerica','creditoID');
						$('#pagaIVA').val("");
						mensajeSis("No hay Saldo Suficiente para Aplicar la Garantía.");
						deshabilitaBoton('aplicar','submit');
						habilitaBoton('cancelar','submit');
						deshabilitaBoton('movimientos','submit');
						deshabilitaBoton('amortiza','submit');
						$('#creditoID').focus();
						$('#creditoID').select();
						limpiaCampos();						
						
					}
				}	
		});
	}
	
	
	//Funcion para consultar el nombre del cliente
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConPagoCred = 8;	 
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(tipConPagoCred,numCliente,function(cliente) {
				if(cliente!=null){	
					$('#clienteID').val(cliente.numero);						
					$('#nombreCliente').val(cliente.nombreCompleto);
					$('#pagaIVA').val(cliente.pagaIVA);
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
		
		//Funcion para consultar la linea de crédito 
	function consultaLineaCredito(idControl) {
		var jqLinea  = eval("'#" + idControl + "'");
		var lineaCred = $(jqLinea).val();	
		var lineaCreditoBeanCon = {
			'lineaCreditoID'	:lineaCred
		};
		if(lineaCred != '' && !isNaN(lineaCred)){
			lineasCreditoServicio.consulta(catTipoConsultaLineaCreditoAgro.principal,lineaCreditoBeanCon,function(linea) {
				if(linea!=null){
					var estatus = linea.estatus;
					$('#saldoDisponible').val(linea.saldoDisponible);
					$('#dispuesto').val(linea.dispuesto);
					$('#numeroCreditos').val(linea.numeroCreditos);
					validaEstatusLineaCred(estatus);
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
					cobraAccesorios = prodCred.cobraAccesorios;
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
		habilitaBoton('cancelar', 'submit');
		
		if(var_estatus == estatusInactivo){
			$('#estatus').val('INACTIVO');
			deshabilitaBoton('aplicar', 'submit');
		}	
		if(var_estatus == estatusAutorizado){
			$('#estatus').val('AUTORIZADO');
			deshabilitaBoton('aplicar', 'submit');
		}
		if(var_estatus == estatusVigente){
			$('#estatus').val('VIGENTE');
			habilitaBoton('aplicar', 'submit');
		}
		if(var_estatus == estatusPagado){
			$('#estatus').val('PAGADO');
			deshabilitaBoton('aplicar', 'submit');
		}
		if(var_estatus == estatusCancelada){
			$('#estatus').val('CANCELADO');							
			deshabilitaBoton('aplicar', 'submit');
		}
		if(var_estatus == estatusVencido){
			$('#estatus').val('VENCIDO');							
			habilitaBoton('aplicar', 'submit');
		}
		if(var_estatus == estatusCastigado){
			$('#estatus').val('CASTIGADO');							
			deshabilitaBoton('aplicar', 'submit');
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
            cuentasAhoServicio.consultaCuentasAho(conCta, CuentaAhoBeanCon,function(cuenta) {
            	if(cuenta!=null){ 
            		$('#nomCuenta').val(cuenta.descripcionTipoCta);
            		if (grupoID>0){
            			$('#saldoCta').val("");
            		}else{
            			consultaSaldoCta('cuentaID');
            		}
            	}else{
            		mensajeSis("No Existe la Cuenta de Ahorro.");
            	}
            });                                                                                                                        
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
       		cuentasAhoServicio.consultaCuentasAho(conCta,CuentaAhoBeanCon,function(cuenta) {
                	if(cuenta!=null){                 	               		
						$('#saldoCta').val(cuenta.saldoDispon);            
                	}else{
                		mensajeSis("No Existe la Cuenta de Ahorro.");
                	}
                });                                                                                                                        
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
	
}); //Fin de Document Ready

	//Funcion que se ejecuta cuanto hay exito de la transaccion
	function funcionExitoPago(){
		deshabilitaBoton('amortiza', 'submit');
		deshabilitaBoton('movimientos', 'submit');
		deshabilitaBoton('aplicar', 'submit');
		deshabilitaBoton('cancelar', 'submit');
		deshabilitaControl('observacion');
		deshabilitaControl('creditoContFondeador');
		deshabilitaControl('acreditadoIDFIRA');
		$('#pagaIVA').val("");
		$('#tipoTransaccion').val('');
	}

	//Funcion que se ejecuta cuanto hay una falla de la transaccion
	function funcionFalloPago(){
		$('#pagaIVA').val("");
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

	function limpiaCampos(){
		$('#saldoCapVigent').val('');  
		$('#saldoCapAtrasad').val('');  
		$('#saldoCapVencido').val('');
		$('#saldCapVenNoExi').val('');    
		$('#totalCapital').val('');  
		$('#saldoInterOrdin').val('');
		$('#saldoInterAtras').val('');
		$('#saldoInterVenc').val('');
		$('#saldoInterProvi').val('');
		$('#saldoIntNoConta').val('');
		$('#totalInteres').val('');
		$('#saldoIVAInteres').val('');
		$('#saldoMoratorios').val('');
		$('#saldoIVAMorator').val('');
		$('#saldoComFaltPago').val('');
		$('#saldoOtrasComis').val('');
		$('#totalComisi').val('');
		$('#salIVAComFalPag').val('');
		$('#saldoIVAComisi').val('');
		$('#totalIVACom').val('');		
		$('#saldoAdmonComis').val('');	
		$('#saldoIVAAdmonComisi').val('');	
		$('#totalAdeudo').val('');
		$('#montoTotCredSinIVA').val('');
		$('#creditoContFondeador').val('');
		$('#acreditadoIDFIRA').val('');
		$('#observacion').val('');
	}

	

	