	var montoMinimo = 0;
	var montoMaximo = 0;
	var requiereGL = '';
	var contador = 0;	
	var numErr = 0;
	var errMsj = "";
	var numFilas = 0;
	var encontrado = [];
	var idMontoSol = [];
	var tipoComApertura;
	var montoComapertura; // monto en $ de la comision por apertura
	var formaComApertura; // anticipado, deduccion o financiado
	var tipoPlazo = 0;
	var amortizaciones = 0; // numero de amortizaciones para el capital
	var amortizacionesInt = 0; // numero de amortizaciones para el interes 
	var amortizacionReal = 0; // guarda el numero de amortizacion de capital que se calcula cuando se modifica el plazo o la frecuencia
	var amortizacionRealInt = 0; // guarda el numero de amortizacion de interes que se calcula cuando se modifica el plazo o la frecuencia
	var diaPagCapit	= ''; // especifica si el pago de capital un dia del mes o el último
	var modalidad;
	var tipoPagoSeg = "";
	var esquemaSeguro;
	var prodCredito;
	var factorRS;
	var porcentajeDesc;
	var montoPol;
	var descuentoSeg;
	var pagoSeg;
	var dias;
	var productoCredito;
	var montoComIvaSol = 0; // monto que incluye el iva, la comision por apertura
	var requiereSegurgoVida;  // Indica si se cobrara seguro de vida


$(document).ready(function(){
	$("#grupoID").focus();
	//Definición de constantes y Enums
	esTab = true;
	var parametroBean = consultaParametrosSession();
	var fechaSucursal = parametroBean.fechaSucursal;
	var diaSucursal = fechaSucursal.substring(8,10);
	var usuario= parametroBean.numeroUsuario;
	
	var catTipoConsultaCredito = { 
  		'principal'	: 1,
  		'foranea'	: 2,
  		'pago'		: 7 
	};	
			
	var catTipoTranCredito = { 
  		'actualizaCalendario'		: 4 ,
	};		
	//-----------------------Métodos y manejo de eventos-----------------------

	var procedePago = 2;
	var montoPagarMayor = 1;
	deshabilitaBoton('modificar', 'submit');
		
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	agregaFormatoControles('formaGenerica');
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});			
    
   	$.validator.setDefaults({
            submitHandler: function(event) { 
            	var valido = validaDatosGrid(2);
           		if(valido==true){ // valida que los montos de solicitud sean correctos (mayor a cero)
	            	procedeSubmit = validaCamposRequeridos();
					if(procedeSubmit == 0 ){ // raliza las validaciones generales
		            	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID','funcionExito','funcionFallo');
					} 
           		}
            }
    });	
   	
   	
   	$('#modificar').click(function() {
   		$('#tipoTransaccion').val(catTipoTranCredito.actualizaCalendario);   		
	});

   	
   	$('#grupoID').blur(function() {
		esTab= true;
		consultaGrupo($('#grupoID').val(), this.id, 'nombreGrupo');
		$('#conProd').val('');
	//	$('#productoCreditoID').trigger('blur'); comentado para q no consulte dobe vez los valores de la solicitud y no haga doble validacion
	});
	
	
	 $('#grupoID').bind('keyup',function(e){
		 if(this.value.length >= 2){ 
			var camposLista = new Array(); 
		    var parametrosLista = new Array(); 
		    	camposLista[0] = "nombreGrupo";
		    	parametrosLista[0] = $('#grupoID').val();
		 listaAlfanumerica('grupoID', '1', '1', camposLista, parametrosLista, 'listaGruposCredito.htm'); }
	 });
	 

	// eventos para seccion de calendario de pagos 
	$('#fechInhabil1').click(function(){
		$('#fechInhabil2').attr('checked',false);
		$('#fechInhabil1').attr('checked',true);
		$('#fechInhabil').val("S");
	});

	$('#fechInhabil2').click(function(){
		$('#fechInhabil1').attr('checked',false);
		$('#fechInhabil2').attr('checked',true);
		$('#fechInhabil').val("N");
	});
	
	$('#ajusFecExiVen1').click(function(){
		$('#ajusFecExiVen2').attr('checked',false);
		$('#ajusFecExiVen1').attr('checked',true);
		$('#ajusFecExiVen').val("S");
	});
	
	$('#ajusFecExiVen2').click(function(){
		$('#ajusFecExiVen1').attr('checked',false);
		$('#ajusFecExiVen2').attr('checked',true);
		$('#ajusFecExiVen').val("N");
	});
	
	$('#ajFecUlAmoVen1').click(function(){
		$('#ajFecUlAmoVen2').attr('checked',false);
		$('#ajFecUlAmoVen1').attr('checked',true);
		$('#ajFecUlAmoVen').val("S");
	});
	
	$('#ajFecUlAmoVen2').click(function(){
		$('#ajFecUlAmoVen1').attr('checked',false);
		$('#ajFecUlAmoVen2').attr('checked',true);
		$('#ajFecUlAmoVen').val("N");
	});
	
	$('#diaPagoInteres1').click(function(){
		$('#diaPagoInteres2').attr('checked',false);
		$('#diaPagoInteres1').attr('checked',true);
		$('#diaPagoInteres').val("F");
		deshabilitaControl('diaMesInteres');
		$('#diaMesInteres').val("");
	});
	
	$('#diaPagoInteres2').click(function(){
		$('#diaPagoInteres1').attr('checked',false);
		$('#diaPagoInteres2').attr('checked',true);
		$('#diaPagoInteres').val("A");
		habilitaControl('diaMesInteres');
		$('#diaMesInteres').val(diaSucursal);
	});
	
	$('#diaPagoCapital1').click(function(){
		$('#diaPagoCapital2').attr('checked', false);
		$('#diaPagoCapital1').attr('checked', true);
		$('#diaPagoCapital').val("F");
		$('#diaMesCapital').attr('disabled', 'disabled');
		$('#diaMesCapital').val("");
		if($('#tipoPagoCapital').val() == 'C' ||  $("#perIgual").val() == 'S' ){
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
		$('#diaPagoCapital').val("A");
		habilitaControl('diaMesCapital');
		$('#diaMesCapital').val(diaSucursal);
		if($('#tipoPagoCapital').val() == 'C' || $("#perIgual").val() == 'S' ){
			$('#diaPagoInteres1').attr('checked',false);
			$('#diaPagoInteres2').attr('checked',true);
			$('#diaPagoInteres').val("A");
			//habilitaControl('diaMesInteres');
			$('#diaMesInteres').val(diaSucursal);
		}
	});
	
	/*$('#calendIrregular').click(function(){
		if($('#calendIrregular').is(':checked')){
			deshabilitaControl('tipoPagoCapital');
		}else{ 
			habilitaControl('tipoPagoCapital');
		}
	});*/
	
	$('#tipoPagoCapital').change(function() { 
		validaTipoPago();  
	});

	$('#plazoID').change(function() {
		$('#conProd').val('S');
		consultaFechaVencimiento(this.id);

	}); 
	

	$('#frecuenciaCap').change(function() { 
		validarEventoFrecuencia();
		validaPeriodicidad();
		consultaFechaVencimiento('plazoID');
		
	}); 
	$('#frecuenciaInt').change(function() { 
		validarEventoFrecuencia();
		validaPeriodicidad();
		consultaCuotasInteres('plazoID');
	}); 
	$('#frecuenciaCap').blur(function() { 
		validarEventoFrecuencia();
		validaPeriodicidad();
		consultaFechaVencimiento('plazoID');
	}); 
	$('#frecuenciaInt').blur(function() { 
		validarEventoFrecuencia();
		validaPeriodicidad();
		consultaCuotasInteres('plazoID');
	}); 
	$('#numAmortizacion').change(function() {
		if($('#tipoPagoCapital').val() == 'C'){
			$('#numAmortInteres').val($('#numAmortizacion').val());
			amortizacionesInt = $('#numAmortizacion').val();
		}		
		consultaFechaVencimientoCuotas($('#plazoID').val(),$('#numAmortizacion').val());
	});
		
	$('#numAmortizacion').blur(function() {
		if($('#tipoPagoCapital').val() == 'C'){
			$('#numAmortInteres').val($('#numAmortizacion').val());
			amortizacionesInt = $('#numAmortizacion').val();
		}		
		consultaFechaVencimientoCuotas($('#plazoID').val(),$('#numAmortizacion').val());
	});
	
	$('#productoCreditoID').bind('keyup',function(e) {
		lista('productoCreditoID', '2', '8','descripcion', $('#productoCreditoID').val(),'listaProductosCredito.htm');
	});
  
	$('#productoCreditoID').blur(function() {
		var grupoID =  $('#grupoID').val();
		
		if( grupoID != ''){	
			if(parseInt(this.value) > 0){
				consultaProducCredito(this.value, 'productoCreditoID',grupoID);
			}
		}
		else{
			$('#grupoID').val('');
			$('#grupoID').focus();
			mensajeSis("Indique el Grupo de Créditos.");
		}
	}); 
	


	
	$("#periodicidadCap").blur(function (){	
		if(this.value != '' && !isNaN(this.value)){
			if(($("#tipoPagoCapital").val() == 'C' &&  $("#frecuenciaCap").val() == 'P') || $("#perIgual").val() == 'S'){
				$("#periodicidadInt").val(this.value);
			}
			
		}
	});
	
	
	$('#tipoPagoTr').hide();
	
	
	$('#tipPago')
	.change(
			function() {
				 if($('#tipPago option:selected').text() == "ADELANTADO"){
					 $('#forCobroSegVida').val("A");
					 var formPagOtro =  "A";
					 var esqSegVida = esquemaSeguro;
						consultaEsquemaSeguroVida($('#productoCreditoID').val(),esqSegVida, formPagOtro);
						
					 
				 }else{ if($('#tipPago option:selected').text() == "FINANCIAMIENTO"){
					 $('#forCobroSegVida').val("F");
					 var formPagOtro =  "F";
					 var esqSegVida = esquemaSeguro;
						consultaEsquemaSeguroVida($('#productoCreditoID').val(),esqSegVida, formPagOtro);
						
						}else{
							 if($('#tipPago option:selected').text() == "DEDUCCION"){
								 $('#forCobroSegVida').val("D");
								 var formPagOtro =  "D";
								 var esqSegVida = esquemaSeguro;
									consultaEsquemaSeguroVida($('#productoCreditoID').val(),esqSegVida, formPagOtro);
									
							
						}else{
							 if($('#tipPago option:selected').text() == "OTRO"){
								 $('#forCobroSegVida').val("O");
								 var formPagOtro = "O";
								 var esqSegVida = esquemaSeguro;
									consultaEsquemaSeguroVida($('#productoCreditoID').val(),esqSegVida, formPagOtro);
						}
					}
				}
			}
					$('#conProd').val('S');	 
	});
	
	
	
		$('#tipPago').blur(function() {
				validaEsquemaTasas($('#productoCreditoID').val());
				calculoCostoSeguro($('#productoCreditoID').val());
			});
	
	
	
	
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
		rules: {
			grupoID: {
				required: true
			},
			plazoID: {
				required: true
			},
			tipoPagoCapital: {
				required: true
			},
			productoCreditoID :{
				required: true 
			},
			periodicidadCap :{
				number: true 
			},
			tipPago :{
				required: function() {
					return $('#reqSeguroVidaSi').is(':checked') && modalidad == 'T';
				} 
			}
		},
		messages: {
			grupoID: {
				required: 'Especificar Grupo'
			},
			plazoID: {
				required: 'Especificar Plazo'
			},
			tipoPagoCapital: {
				required: 'Especificar Tipo Pago Capital'
			},
			productoCreditoID :{
				required: 'Especificar Producto de Crédito' 
			},
			periodicidadCap :{
				number: 'Solo Dígitos Numéricos' 
			},
			tipPago :{
				required: 'Especificar Tipo de Pago' 
			}
		}		
	});

	
//-------------Validaciones de controles---------------------
	
	///consulta GridIntegrantes////////////
	function consultaIntegrantesGrupo(valorGrupo, plazos, producto){	
		var numFilas = 0;
		var params = {};
		var consulta = 0 ; 
		params['tipoLista'] = 10;
		params['grupoID'] 	= valorGrupo;
		params['ciclo'] 	= 0; 
		params['controlIntegrante'] = 1;
		$.post("listaIntegrantesGpo.htm", params, function(data){
				if(data.length >0) {		
					$('#gridIntegrantes').html(data);
					$('#gridIntegrantes').show(400);	
					
					numFilas = cuentaFilasGrid();
					
					if(numFilas > 0){
						habilitaBoton('modificar', 'submit');
					}else{
						deshabilitaBoton('modificar', 'submit');
					}
					
					consultacicloCliente(producto);// Consulta el Ciclo del Cliente en relacion al produc indicado
					
					
					if($('#solicitudCre1').asNumber()!=0){
						if(consulta == 0){ 
							consultaValoresSolicitudCredito($('#solicitudCre2').asNumber(), plazos);
							consulta = 1; 
						}
					}
					
					validaDatosGrid(1);
					
				}else{	
					$('#gridIntegrantes').html("");
					$('#gridIntegrantes').hide(400);
				}
	
		});
	}		
	

	
	// Consulta de grupos 
	function consultaGrupo(valID, id, desGrupo) { 
		var jqDesGrupo  = eval("'#" + desGrupo + "'");
		var jqIDGrupo  = eval("'#" + id + "'");
		var numGrupo = valID;	
		var tipConGrupo= 1;
		var grupoBean = {
			'grupoID'	:numGrupo
		};
		setTimeout("$('#cajaLista').hide();", 200);
		
		requiereSegurgoVida = ''; 

		if(numGrupo != '' && !isNaN(numGrupo) && esTab){
			gruposCreditoServicio.consulta(tipConGrupo, grupoBean,function(grupo) {
				if(grupo!=null){	
					$(jqIDGrupo).val(grupo.grupoID);
					$(jqDesGrupo).val(grupo.nombreGrupo);
					$('#productoCreditoID').val(grupo.productoCre);
					$('#cicloActual').val(grupo.cicloActual);

					
					// valida que el grupo se encuentre abierto
					if(grupo.estatusCiclo == 'A'){
						$('#productoCreditoID').focus();

						consultaProducCredito(grupo.productoCre, 'productoCreditoID', grupo.grupoID);
						calculoCostoSeguro(grupo.productoCre);
					}else{ // si el grupo esta cerrado no permitira consultarlo
						if(grupo.estatusCiclo == 'C'){
							mensajeSis("El Grupo Indicado se Encuentra Cerrado.");
						}
						if(grupo.estatusCiclo == 'N'){
							mensajeSis("El Grupo Indicado No se ha Iniciado.");
						}
						$(jqIDGrupo).val("");
						$(jqIDGrupo).focus();
						$(jqDesGrupo).val("");
						$('#productoCreditoID').val("");
						$('#descripProducto').val("");
						$('#gridIntegrantes').html("");
						$('#gridIntegrantes').hide();
						inicializaCombos();
						inicializaForma('formaGenerica','grupoID');
						deshabilitaBoton('modificar', 'submit');
						plazos ='';	
					}
					
				}else{		
					mensajeSis("El Grupo Indicado No Existe.");
					$(jqIDGrupo).focus();
					$(jqDesGrupo).val("");
					$(jqIDGrupo).val("");
					$('#productoCreditoID').val("");
					$('#descripProducto').val("");
					$('#gridIntegrantes').html("");
					$('#gridIntegrantes').hide();
					inicializaCombos();
					inicializaForma('formaGenerica','grupoID');
					deshabilitaBoton('modificar', 'submit');
					plazos ='';					
				}
			});															
		}
	}	
	
	// consulta el producto de credito
	function consultaProducCredito(valorProducto, idControl, grupoID) {		
		var ProdCred =valorProducto;		
		var ProdCredBeanCon = {
				'producCreditoID':ProdCred 
		}; 
		setTimeout("$('#cajaLista').hide();", 200);  
		if(ProdCred != '' && ProdCred != '0' && !isNaN(ProdCred) && ProdCred >0 ){ 
			$("#productoCreditoID").attr('disabled', false); 
			productosCreditoServicio.consulta(catTipoConsultaCredito.principal,ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){
					tipoPlazo = 1;
						if(prodCred.esGrupal =='S'){
								esTab=true;	
								
								$('#prodCred').val(ProdCred);
								$('#forCoSegu').val(prodCred.tipoPagoSeguro);
								$('#descripProducto').val(prodCred.descripcion);
								$('#tasaPonderaGru').val(prodCred.tasaPonderaGru);	
								$('#modalid').val(prodCred.modalidad);
								$('#proCre').val(prodCred.producCreditoID);
								requiereSegurgoVida = prodCred.reqSeguroVida; 
								
								if($('#conProduc').val() == ''){
								$('#conProduc').val(prodCred.producCreditoID);
								}
								consultaCalendarioPorProducto(valorProducto, grupoID);
								
								montoMinimo = prodCred.montoMinimo;
								montoMaximo = prodCred.montoMaximo;
								
								requiereGL = prodCred.garantizado;
								tipoComApertura = prodCred.tipoComXapert;
								montoComapertura = prodCred.montoComXapert;
								formaComApertura  =prodCred.formaComApertura; 
								
							
								if(prodCred.reqSeguroVida =='S'){
									
									modalidad = prodCred.modalidad;
									esquemaSeguro = prodCred.esquemaSeguroID;
									if(prodCred.modalidad == 'T'){
									dwr.util.removeAllOptions('tipPago'); 
									consultaTiposPago(prodCred.producCreditoID,tipoPagoSeg);
									}
									
									$('#reqSeguroVidaSi').attr("checked",true);
									$('#reqSeguroVidaNo').attr("checked",false);
									$('#reqSeguroVida').val("S");
									
									$("#tdFormaCobSeguro").show(-2000);
									$("#tdMontoSeguro").show(-2000);
									$("#tipoPagoSeguro").show();
									$("#lblTipoPagoSeguro").show();
									
									if(modalidad == "T"){
										$('#lblTipoPagoSeguro').hide();
										$('#tipoPagoSeguro').hide();
										$('#tipoPagoTr').show();
									}else{
											if(modalidad == "U"){
												descuentoSeg = prodCred.descuentoSeguro;
												$('#factorRiesgoSeguro').val(prodCred.factorRiesgoSeguro);
												$('#lblTipoPagoSeguro').show();
												$('#tipoPagoSeguro').show();
												$('#tipoPagoTr').hide();
											}
									}
									
									if(modalidad == 'U'){
									$('#forCobroSegVida').val(prodCred.tipoPagoSeguro);
									//forma de pago del seguro de vida
									if(prodCred.tipoPagoSeguro=='F'){								
										$('#tipoPagoSeguro').val("FINANCIADO");
										 $('#forCobroSegVida').val("F");

									}else{
										if(prodCred.tipoPagoSeguro=='D'){								
											$('#tipoPagoSeguro').val("DEDUCCION");
											 $('#forCobroSegVida').val("D");

										}else{
											if(prodCred.tipoPagoSeguro=='A'){								
												$('#tipoPagoSeguro').val("ANTICIPADO");
												 $('#forCobroSegVida').val("A");

											}
										}
									}
								}else{
									if(modalidad == 'T'){
										
										 if($('#tipPago option:selected').text() == "ADELANTADO"){
											 $('#forCobroSegVida').val("A");
											 
										 }else{}
										 
										 if($('#tipPago option:selected').text() == "FINANCIAMIENTO"){
											 $('#forCobroSegVida').val("F");
											 
										 }else{}
										 
										 if($('#tipPago option:selected').text() == "DEDUCCION"){
											 $('#forCobroSegVida').val("D");
											 
										 }else{}
										 
										 if($('#tipPago option:selected').text() == "OTRO"){
											 $('#forCobroSegVida').val("O");
											 
										 }else{}
									 }
									
								}//termina 
									
									
								}else{
									$('#reqSeguroVidaSi').attr("checked",false);
									$('#reqSeguroVidaNo').attr("checked",true);
									$('#reqSeguroVida').val("N");
									
									$("#tdFormaCobSeguro").hide(-2000);
									$("#tdMontoSeguro").hide(-2000);
									$("#tipoPagoSeguro").hide();
									$("#lblTipoPagoSeguro").hide();
									$("#tipoPagoTr").hide();
								}
								
								habilitaBoton('modificar', 'submit');
								
						}
						else{
							mensajeSis("El Producto de Crédito Indicado No es Grupal.");							
							$('#descripProducto').val("");
							$('#productoCreditoID').val("");
							$('#productoCreditoID').focus();	
							productoIDBase = 0;
							plazos ='';
							deshabilitaBoton('modificar', 'submit');
							montoMinimo = 0;
							montoMaximo = 0;
							requiereGL = '';
							tipoComApertura = '';
							montoComapertura = 0.0; 
							formaComApertura  = ''; 
						}
				}else{							
					mensajeSis("No Existe el Producto de Crédito.");
					$('#productoCreditoID').focus();
					$('#productoCreditoID').select();	
					$('#descripProducto').val("");
					productoIDBase = 0;
					plazos ='';
					deshabilitaBoton('modificar', 'submit');
					montoMinimo = 0;
					montoMaximo = 0;
					requiereGL = '';
					tipoComApertura = '';
					montoComapertura = 0.0; 
					formaComApertura  = ''; 
				}
			});
		}	
		else{	
			if(esTab==true){
				$('#gridIntegrantes').hide(400);
				deshabilitaBoton('modificar', 'submit');
				$("#productoCreditoID").attr('disabled', true);
			}
			
			$('#productoCreditoID').val("");	
			$('#descripProducto').val("");
			productoIDBase = 0;
			plazos ='';
			montoMinimo = 0;
			montoMaximo = 0;
			requiereGL = '';
		}
	}
	
	/*Metodo para consultar las condiciones del calendario segun el tipo de producto seleccionado
	se dispara cuando el producto de credito pierde el foco*/
	function consultaCalendarioPorProducto(producto, grupoID) {  
//		inicializaCombos();
		var TipoConPrin = 1;
		var calendarioBeanCon = { 
				'productoCreditoID' :producto
		};

		setTimeout("$('#cajaLista').hide();", 200);
		if( producto != '' && !isNaN(producto) && esTab){
			calendarioProdServicio.consulta(TipoConPrin, calendarioBeanCon,function(calendario) {
				if(calendario!=null){ 
					diaMesCapit = 0;
					var tipoPago = calendario.tipoPagoCapital;					
					var frecuencia = calendario.frecuencias; 
					var plazos = calendario.plazoID;

					if(calendario.fecInHabTomar=='S'){				
						$('#fechInhabil').val("S") ;
						$('#fechInhabil1').attr("checked",true) ;
						$('#fechInhabil2').attr("checked",false) ;
						deshabilitaControl('fechInhabil1');
						deshabilitaControl('fechInhabil2');
					}else{		
						$('#fechInhabil').val("A") ;
						$('#fechInhabil2').attr("checked",true) ;
						$('#fechInhabil1').attr("checked",false) ;
						deshabilitaControl('fechInhabil1');
						deshabilitaControl('fechInhabil2');
					}

					if(calendario.ajusFecExigVenc=='S'){							
						$('#ajusFecExiVen').val("S") ;				
						$('#ajusFecExiVen1').attr("checked",true) ;
						$('#ajusFecExiVen2').attr("checked",false) ;
						deshabilitaControl('ajusFecExiVen2');
						deshabilitaControl('ajusFecExiVen1');
					} else{						
						$('#ajusFecExiVen').val("N") ;	
						$('#ajusFecExiVen1').attr("checked",false) ;
						$('#ajusFecExiVen2').attr("checked",true) ;		
						deshabilitaControl('ajusFecExiVen2');
						deshabilitaControl('ajusFecExiVen1');
					} 

					if(calendario.permCalenIrreg=='S'){							
						//$('#calendIrregular').attr("checked","1") ;
						deshabilitaControl('tipoPagoCapital');   
					}
					else{ 
						if(calendario.permCalenIrreg=='N'){	
							/*$('#calendIrregular').attr("checked",false) ;
							deshabilitaControl('calendIrregular');*/
							habilitaControl('tipoPagoCapital');
						}
					}

					if(calendario.ajusFecUlAmoVen=='S'){	 	
						$('#ajFecUlAmoVen').val("S") ;
						$('#ajFecUlAmoVen1').attr("checked",true) ;
						$('#ajFecUlAmoVen2').attr("checked",false) ;
						deshabilitaControl('ajFecUlAmoVen1');
						deshabilitaControl('ajFecUlAmoVen2');
					}  
					else{
						$('#ajFecUlAmoVen').val("N") ;
						$('#ajFecUlAmoVen2').attr("checked",true) ;
						$('#ajFecUlAmoVen1').attr("checked",false) ;
						deshabilitaControl('ajFecUlAmoVen1');
						deshabilitaControl('ajFecUlAmoVen2');
					}
					if(calendario.iguaCalenIntCap=='S'){		
						var permiteIgual = 'S';
						$('#perIgual').val(permiteIgual); 
						deshabilitaControl('frecuenciaInt');   

					} 
					if(calendario.iguaCalenIntCap=='N'){		
						var permiteIgual = 'N';
						$('#perIgual').val(permiteIgual);
						habilitaControl('frecuenciaInt');	
					}  

					consultaComboTipoPagoCap(calendario.tipoPagoCapital);		
					consultaComboFrecuencias(calendario.frecuencias);
					consultaIntegrantesGrupo(grupoID,  calendario.plazoID, producto);
					
					//variable global para mantener el dia de pago de capital por producto
					diaPagCapit = calendario.diaPagoCapital;
					
					// si el dia de pago de capital es el ultimo dia del mes 
					if(calendario.diaPagoCapital == 'F'){
						$('#diaPagoCapital1').attr('disabled',false);
						$('#diaPagoCapital2').attr('disabled', true);
						$('#diaMesCapital').attr('disabled', true);
					}					
					// si el dia de pago de capital es por Aniversario
					if(calendario.diaPagoCapital == 'A'){
						$('#diaPagoCapital1').attr('disabled',true);
						$('#diaPagoCapital2').attr('disabled', false);
						$('#diaMesCapital').attr('disabled',false);
						$('#diaMesCapital').val(diaSucursal);
					}
					// si el dia de pago de capital es un dia del mes especificado por el cliente
					if(calendario.diaPagoCapital == 'D'){
						$('#diaPagoCapital1').attr('disabled',true);
						$('#diaPagoCapital2').attr('disabled', false);
						$('#diaMesCapital').attr('disabled',false);
					}
					// si el dia de pago de capital es Indistinto
					if(calendario.diaPagoCapital == 'I'){
						$('#diaPagoCapital1').attr('disabled',false);
						$('#diaPagoCapital2').attr('disabled', false);
						$('#diaMesCapital').attr('disabled',false);					
					}
					
					// si el tipo de pago es crecientes el dia de pago capital es = al de interes
					if($("#tipoPagoCapital").val() == 'C' || calendario.iguaCalenIntCap =='S'){
						$('#diaPagoInteres1').attr('disabled',true);
						$('#diaPagoInteres2').attr('disabled',true);
						$('#diaMesInteres').attr('disabled',true);
					}

				}else{
					mensajeSis("No Existe Calendario Parametrizado para el Producto de Crédito Indicado.");
				}
			});
		}	
	}
	
	// funcion para cambiar los controles dependiendo de el tipo de pago de capital
	// seleccionado 
	function validaTipoPago() { 
		switch($('#tipoPagoCapital').val()){
			case "C": // si el tipo de pago es CRECIENTES 
				// si el tipo de pago es UNICO se deshabilitan las cajas para indicar numero de cuotas
				if($('#frecuenciaCap').val() == 'U' || $('#frecuenciaInt').val() == 'U' ){
					deshabilitarCalendarioPagosInteres();
					$('#numAmortizacion').val("1"); 
					amortizaciones = 1;
					$('#numAmortInteres').val("1");
					amortizacionesInt = 1;
					deshabilitaControl('numAmortizacion');
					deshabilitaControl('numAmortInteres'); 
					$('#periodicidadCap').val($('#noDias').val());
				    $('#periodicidadInt').val($('#noDias').val());					
				}else{
					deshabilitaControl('frecuenciaInt');
					$('#frecuenciaInt').val($('#frecuenciaCap').val()).selected = true;
					
					$('#numAmortInteres').val($('#numAmortizacion').val());
					amortizacionesInt = $('#numAmortizacion').val();
					deshabilitaControl('numAmortInteres');

					deshabilitaControl('diaMesInteres');
					$('#diaMesInteres').val($('#diaMesCapital').val());
		
					if($('#diaPagoCapital1').is(':checked')){  
						$('#diaPagoInteres2').attr('checked',false);
						$('#diaPagoInteres1').attr('checked',true);	
						$('#diaPagoInteres').val("F");					
					}else{
						if($('#diaPagoCapital2').is(':checked')){  
							$('#diaPagoInteres1').attr('checked',false);
							$('#diaPagoInteres2').attr('checked',true);		
							$('#diaPagoInteres').val("A");				
						}
					}

					deshabilitaControl('diaPagoInteres1');
					deshabilitaControl('diaPagoInteres2');
					$('#periodicidadInt').val($('#periodicidadCap').val());	
				}
			break;
			case "I" || "L"  :
				// si el tipo de pago es UNICO se deshabilitan las cajas para indicar numero de cuotas
				if($('#frecuenciaCap').val() == 'U' || $('#frecuenciaInt').val() == 'U' ){
					deshabilitarCalendarioPagosInteres();
					$('#numAmortizacion').val("1"); 
					amortizaciones = 1;
					$('#numAmortInteres').val("1");
					amortizacionesInt = 1;
					deshabilitaControl('numAmortizacion');
					deshabilitaControl('numAmortInteres'); 
					$('#periodicidadCap').val($('#noDias').val());
					$('#periodicidadInt').val($('#noDias').val());					
				}else{
					if($('#perIgual').val() =='S'){
						deshabilitaControl('frecuenciaInt');
						$('#frecuenciaInt').val($('#frecuenciaCap').val()).selected = true;
						
						$('#numAmortInteres').val($('#numAmortizacion').val());
						amortizacionesInt  = $('#numAmortizacion').val();
						deshabilitaControl('numAmortInteres');

						deshabilitaControl('diaMesInteres');
						$('#diaMesInteres').val($('#diaMesCapital').val());
			
						if($('#diaPagoCapital1').is(':checked')){  
							$('#diaPagoInteres2').attr('checked',false);
							$('#diaPagoInteres1').attr('checked',true);	
							$('#diaPagoInteres').val("F");					
						}else{
							if($('#diaPagoCapital2').is(':checked')){  
								$('#diaPagoInteres1').attr('checked',false);
								$('#diaPagoInteres2').attr('checked',true);		
								$('#diaPagoInteres').val("A");				
							}
						}

						deshabilitaControl('diaPagoInteres1');
						deshabilitaControl('diaPagoInteres2');
						$('#periodicidadInt').val($('#periodicidadCap').val());
					}else{
						deshabilitaControl('frecuenciaInt');
						$('#frecuenciaInt').val($('#frecuenciaCap').val()).selected = true;
						
						$('#numAmortInteres').val($('#numAmortizacion').val());
						amortizacionesInt = $('#numAmortizacion').val();
						deshabilitaControl('numAmortInteres');

						deshabilitaControl('diaMesInteres');
						$('#diaMesInteres').val($('#diaMesCapital').val());
			
						deshabilitaControl('diaPagoInteres1');
						deshabilitaControl('diaPagoInteres2');
						if($('#diaPagoCapital1').is(':checked')){  
							$('#diaPagoInteres2').attr('checked',false);
							$('#diaPagoInteres1').attr('checked',true);	
							$('#diaPagoInteres').val("F");					
						}else{
							if($('#diaPagoCapital2').is(':checked')){  
								$('#diaPagoInteres1').attr('checked',false);
								$('#diaPagoInteres2').attr('checked',true);	
								$('#diaPagoInteres').val("A");					
							}
						}
						$('#periodicidadInt').val($('#periodicidadCap').val());
						habilitaControl('frecuenciaInt');
						habilitaControl('numAmortInteres');
						habilitaControl('diaMesInteres');
						habilitaControl('diaPagoInteres1');
						habilitaControl('diaPagoInteres2');
					}
				}				
			break;
			default:	
				// si el tipo de pago es UNICO se deshabilitan las cajas para indicar numero de cuotas
				if($('#frecuenciaCap').val() == 'U' || $('#frecuenciaInt').val() == 'U' ){
					deshabilitarCalendarioPagosInteres();
					$('#numAmortizacion').val("1"); 
					amortizaciones = 1;
					$('#numAmortInteres').val("1");
					amortizacionesInt = 1;
					deshabilitaControl('numAmortizacion');
					deshabilitaControl('numAmortInteres'); 
					$('#periodicidadCap').val($('#noDias').val());
					$('#periodicidadInt').val($('#noDias').val());					
				}else{
					deshabilitaControl('frecuenciaInt');
					$('#frecuenciaInt').val($('#frecuenciaCap').val()).selected = true;
					
					$('#numAmortInteres').val($('#numAmortizacion').val());
					amortizacionesInt = $('#numAmortizacion').val();
					deshabilitaControl('numAmortInteres');
		
					deshabilitaControl('diaMesInteres');
					$('#diaMesInteres').val($('#diaMesCapital').val());
		
					deshabilitaControl('diaPagoInteres1');
					deshabilitaControl('diaPagoInteres2');
					if($('#diaPagoCapital1').is(':checked')){  
						$('#diaPagoInteres2').attr('checked',false);
						$('#diaPagoInteres1').attr('checked',true);	
						$('#diaPagoInteres').val("F");					
					}else{
						if($('#diaPagoCapital2').is(':checked')){  
							$('#diaPagoInteres1').attr('checked',false);
							$('#diaPagoInteres2').attr('checked',true);
							$('#diaPagoInteres').val("A");						
						}
					}

					$('#periodicidadInt').val($('#periodicidadCap').val());	
				}				
			break;			
		}
	}
	// funcion para eventos cuando se selecciona dia de pago de interes 
	//por aniversario o fin de mes, dependiendo de la frecuencia.
	function validarEventoFrecuencia() { 
		if($('#frecuenciaCap').val() == 'M' && (diaPagCapit == 'D' || diaPagCapit == 'I' )){
			$('#diaPagoCapital1').attr('disabled', false);
			$('#diaPagoCapital2').attr('disabled', false);
	    }
		
		switch($('#tipoPagoCapital').val()){
			case "C": // si el tipo de pago es CRECIENTES
				$('#frecuenciaInt').val($('#frecuenciaCap').val()).selected = true;
				deshabilitarCalendarioPagosInteres();
				if( $('#frecuenciaCap').val() == 'S' || $('#frecuenciaCap').val() == 'C'|| $('#frecuenciaCap').val() == 'Q' ||
				    $('#frecuenciaCap').val() == 'A' ){
							if($('#diaPagoInteres1').is(':checked')){ 
									$('#diaPagoInteres1').attr('checked',true);
									$('#diaPagoCapital1').attr("checked",true);
									$('#diaPagoInteres2').attr('checked',false);
									$('#diaPagoCapital2').attr("checked",false);
									$('#diaPagoInteres').val("F") ;
									$('#diaPagoCapital').val("F") ;
									$('#diaMesInteres').val('');
									$('#diaMesCapital').val('');  
							}else{
									$('#diaPagoInteres2').attr('checked',true);
									$('#diaPagoCapital2').attr("checked",true);
									$('#diaPagoInteres1').attr('checked',false);
									$('#diaPagoCapital1').attr("checked",false);
									$('#diaPagoInteres').val("A") ;
									$('#diaPagoCapital').val("A") ;
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
													$('#diaPagoCapital1').attr("checked",true);
													$('#diaPagoInteres2').attr('checked',false);
													$('#diaPagoCapital2').attr("checked",false);
													$('#diaPagoInteres').val("F") ;
													$('#diaPagoCapital').val("F") ;
													$('#diaMesInteres').val('');
													$('#diaMesCapital').val('');  
										}else{
													$('#diaPagoInteres2').attr('checked',true);
													$('#diaPagoCapital2').attr("checked",true);
													$('#diaPagoInteres1').attr('checked',false);
													$('#diaPagoCapital1').attr("checked",false);
													$('#diaPagoInteres').val("A") ;
													$('#diaPagoCapital').val("A") ;
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
													amortizaciones = 1;
													$('#numAmortInteres').val("1");
													amortizacionesInt = 1;
													deshabilitaControl('numAmortizacion');
													deshabilitaControl('numAmortInteres'); 
													$('#periodicidadCap').val($('#noDias').val());
													$('#periodicidadInt').val($('#noDias').val());							
										}else{
													habilitaControl('numAmortizacion');
													deshabilitaControl('numAmortInteres');			
													if($('#diaPagoCapital1').is(':checked')){ 
															$('#diaPagoCapital2').attr("checked",false) ; 
															$('#diaPagoCapital').val("F");			
															$('#diaMesCapital').val("");	
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
															$('#diaMesInteres').val(""); 	
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
			case "I" || "L": 
						// si el tipo de pago es UNICO se deshabilitan las cajas para indicar numero de cuotas
						if($('#frecuenciaCap').val() == 'U' ){
									if($('#tipoPagoCapital').val()!="I"){
											mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
									}
									$('#frecuenciaInt').val('U').selected = true;
									deshabilitarCalendarioPagosInteres();
									$('#numAmortizacion').val("1"); 
									amortizaciones = 1;
									$('#numAmortInteres').val("1");
									amortizacionesInt = 1;
									deshabilitaControl('numAmortizacion');
									deshabilitaControl('numAmortInteres'); 
									$('#periodicidadCap').val($('#noDias').val());
									$('#periodicidadInt').val($('#noDias').val());					
						}else{
		
									habilitaControl('numAmortizacion');
									habilitaControl('numAmortInteres');	
									if( $('#perIgual').val() !='S'){
											habilitarCalendarioPagosInteres();	
									}else{
												$('#frecuenciaInt').val($('#frecuenciaCap').val()).selected = true;
												if($('#diaPagoCapital1').is(':checked')){ 
														$('#diaPagoCapital2').attr("checked",false) ; 
														$('#diaPagoCapital').val("F");			
														$('#diaMesCapital').val("");	
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
														$('#diaMesInteres').val(""); 	
												}else{
														if($('#diaPagoInteres2').is(':checked')){  
															$('#diaPagoInteres').val("A");		
															$('#diaPagoInteres1').attr("checked",false) ;		
															$('#diaMesInteres').val(diaSucursal);   
														}
												}
									}
									 
									if( $('#frecuenciaInt').val() == 'S' || $('#frecuenciaInt').val() == 'C'|| $('#frecuenciaInt').val() == 'Q' ||
												$('#frecuenciaInt').val() == 'A' || $('#frecuenciaInt').val() == 'P' ){
												deshabilitaControl('diaPagoInteres1');
												deshabilitaControl('diaPagoInteres2');
												deshabilitaControl('diaMesInteres');
												deshabilitaControl('periodicidadInt');	
														
									}else{
											if($('#frecuenciaInt').val() == 'P' ){
												if( $('#perIgual').val() !='S'){
													habilitaControl('periodicidadInt');	
												}	
											}else{
													if($('#frecuenciaInt').val() == 'U' ){
															$('#numAmortizacion').val("1"); 
															amortizaciones = 1;
															$('#numAmortInteres').val("1");
															amortizacionesInt = 1;
															deshabilitaControl('numAmortizacion');
															deshabilitaControl('numAmortInteres'); 
															$('#periodicidadCap').val($('#noDias').val());
															$('#periodicidadInt').val($('#noDias').val());
													}else{
															if( $('#perIgual').val() !='S'){
																	$('#frecuenciaInt').val($('#frecuenciaCap').val()).selected = true;	
															}
													}
												}
									}
									
									if( $('#frecuenciaCap').val() == 'S' || $('#frecuenciaCap').val() == 'C'|| $('#frecuenciaCap').val() == 'Q' ||
											$('#frecuenciaCap').val() == 'A' ){
											deshabilitaControl('diaPagoCapital1');
											deshabilitaControl('diaPagoCapital2');
											deshabilitaControl('diaMesCapital');
											deshabilitaControl('periodicidadCap');
									}else{
												if($('#frecuenciaCap').val() == 'P' ){
														habilitaControl('periodicidadCap');
														deshabilitaControl('diaPagoCapital1');
														deshabilitaControl('diaPagoCapital2');		
												}else{				
															if($('#frecuenciaCap').val() == 'U' ){
																	$('#numAmortizacion').val("1"); 
																	amortizaciones = 1;
																	$('#numAmortInteres').val("1");
																	amortizacionesInt = 1;
																	deshabilitaControl('numAmortizacion');
																	deshabilitaControl('numAmortInteres'); 
																	$('#periodicidadCap').val($('#noDias').val());
																	$('#periodicidadInt').val($('#noDias').val());
															}else{
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
						}
			break;
		}
	} // FIN validarEventoFrecuencia()
	
	// funcion que llena el combo de tipo de pago capital, de acuerdo al producto 
	function consultaComboTipoPagoCap(tipoPago) {
		$('#tipoPagoCapital').each(function(){  
			$('#tipoPagoCapital option').remove();
		});
		
		$('#tipoPagoCapital').append(new Option('SELECCIONAR', '', true, true));  
		
		if(tipoPago != null){
			var tpago= tipoPago.split(',');
			var tamanio = tpago.length; 
			
			for (var i=0;i<tamanio;i++) {   
				var pag = tpago[i];
				var pagDescrip = '';
				switch(pag){
					case "C": // si el tipo de pago es CRECIENTES
						pagDescrip = 'CRECIENTES';
					break;
					case "I":
						pagDescrip = 'IGUALES';
					break;
					case "L":
						pagDescrip = 'LIBRES';
					break;
					default:		
						pagDescrip = 'IGUALES';
				}
				$('#tipoPagoCapital').append(new Option(pagDescrip, pag, true, true));  
			}  
		}
	}
	
	// funcion que llena el combo de Frecuencias, de acuerdo al producto 
	function consultaComboFrecuencias(frecuencia) {
		$('#frecuenciaCap').each(function(){  
			$('#frecuenciaCap option').remove();
		});
		$('#frecuenciaInt').each(function(){  
			$('#frecuenciaInt option').remove();
		});
		$('#frecuenciaCap').append(new Option('SELECCIONAR','', true, true));
		$('#frecuenciaInt').append(new Option('SELECCIONAR','', true, true));
		
		if(frecuencia != null){
			var frec= frecuencia.split(',');
			var tamanio = frec.length; 
			for (var i=0;i<tamanio;i++) {   
				var fre = frec[i];
				var frecDescrip = '';
				switch(fre){
					case "S":
						frecDescrip = 'SEMANAL';
					break;
					case "D":
						frecDescrip = 'DECENAL';
					break;
					case "C":
						frecDescrip = 'CATORCENAL';
					break;
					case "Q":
						frecDescrip = 'QUINCENAL';
					break;
					case "M":
						frecDescrip = 'MENSUAL';
					break;
					case "B":
						frecDescrip = 'BIMESTRAL';
					break;
					case "T":
						frecDescrip = 'TRIMESTRAL';
					break;
					case "R":
						frecDescrip = 'TETRAMESTRAL';
					break;
					case "E":
						frecDescrip = 'SEMESTRAL';
					break;
					case "A":
						frecDescrip = 'ANUAL';
					break;
					case "P":
						frecDescrip = 'PERIODO';
					break;
					case  "U": // PAGO UNICO
						frecDescrip = 'PAGO UNICO';
					break;
					default:		
						frecDescrip = '';
				}
				$('#frecuenciaCap').append(new Option(frecDescrip,fre, true, true));
				$('#frecuenciaInt').append(new Option(frecDescrip,fre, true, true));  
			} 
		}   
	}
	
	// funcion que llena el combo de plazos, de acuerdo al producto cccc
	function consultaComboPlazos(plazos,valorPlazo) {
		$('#plazoID').each(function(){  
			$('#plazoID option').remove();
		});
		if(plazos != null){ 
			var plazo= plazos.split(',');
			var tamanio = plazo.length;  
			plazosCredServicio.listaCombo(3, function(plazoCreditoBean){
				$('#plazoID').append(new Option('SELECCIONAR', '', true, true));
				for (var i=0;i<tamanio;i++) {
					for (var j = 0; j < plazoCreditoBean.length; j++){
						if(plazo[i]==plazoCreditoBean[j].plazoID){
							$('#plazoID').append(new Option(plazoCreditoBean[j].descripcion, plazo[i], true, true));
							
							if(tipoPlazo ==1){
								$('#plazoID').val(valorPlazo).select();				
							}										
							
							break;
						}				
					}
					
				}
			});
		}   
	}
	
	function consultaValoresSolicitudCredito(solCred, plazos){
		var SolCredBeanCon = {
				'solicitudCreditoID':solCred,
				'usuario': usuario
		}; 
		solicitudCredServicio.consulta(catTipoConsultaCredito.principal, SolCredBeanCon,function(solicitud) {
			$('#fechaInicio').val(solicitud.fechaInicio); 
			consultaComboPlazos(plazos,solicitud.plazoID);	
			
			if(modalidad == 'T'){ 
					consultaTiposPago($('#proCre').val(), solicitud.forCobroSegVida);
			}
			//consultaTiposPago(solicitud.productoCreditoID, solicitud.forCobroSegVida);

			$('#fechaVencimiento').val(solicitud.fechaVencimiento);
			$('#tipoPagoCapital').val(solicitud.tipoPagoCapital);			
			$('#frecuenciaCap').val(solicitud.frecuenciaCap);
			
			$('#frecuenciaInt').val(solicitud.frecuenciaInt);
			$('#periodicidadCap').val(solicitud.periodicidadCap);
			$('#periodicidadInt').val(solicitud.periodicidadInt);
			$('#numAmortInteres').val(solicitud.numAmortInteres);
			$('#numAmortizacion').val(solicitud.numAmortizacion);
			
			$('#forCobroSegVida').val(solicitud.forCobroSegVida);
			tipoPagoSeg = solicitud.forCobroSegVida;
			
			if($('#forCoSegu').val() != ''){
			var forCobSeVi = $('#forCoSegu').val();	
			$('#forCobroSegVida').val(forCobSeVi);
			}
			amortizaciones = solicitud.numAmortizacion;
			amortizacionesInt = solicitud.numAmortInteres;
			
			validaPeriodicidad();
			$('#noDias').val("");
		
			if(solicitud.ajusFecExiVen=='S'){							
				$('#ajusFecExiVen2').attr('checked',false);
				$('#ajusFecExiVen1').attr('checked',true);
				$('#ajusFecExiVen').val("S");
			}else{
				$('#ajusFecExiVen2').attr('checked',true);
				$('#ajusFecExiVen1').attr('checked',false);
				$('#ajusFecExiVen').val("N"); 
			} 
			/*if(solicitud.calendIrregular=='S'){							
				$('#calendIrregular').attr("checked","1") ;  
			}else{ 
				$('#calendIrregular').attr("checked",false);
			}*/
			if(solicitud.ajFecUlAmoVen=='S'){	 	
				$('#ajFecUlAmoVen2').attr('checked',false);
				$('#ajFecUlAmoVen1').attr('checked',true);
				$('#ajFecUlAmoVen').val("S");
			}  
			else{ 
				$('#ajFecUlAmoVen2').attr('checked',true);
				$('#ajFecUlAmoVen1').attr('checked',false);
				$('#ajFecUlAmoVen').val("N");
			}
			
			// si la frecuencia de capital es diferente de Mes, bloquea los campos necesarios
			if(solicitud.frecuenciaCap != 'M'){
				$('#diaPagoCapital1').attr('disabled',true);
				$('#diaPagoCapital2').attr('disabled',true);
				$('#diaMesCapital').attr('disabled',true);
			}else if(solicitud.frecuenciaCap == 'M' && solicitud.diaPagoCapital == 'F'){
				$('#diaMesCapital').attr('disabled',true);
			}	
			if(solicitud.frecuenciaCap == 'U'){
				$('#numAmortizacion').attr('disabled',true);
			}
			// si la frecuencia de capital es diferente de Mes, bloquea los campos necesarios
			if(solicitud.frecuenciaInt != 'M'){
				$('#diaPagoInteres1').attr('disabled',true);
				$('#diaPagoInteres2').attr('disabled',true);
				$('#diaMesInteres').attr('disabled',true);
			}else if(solicitud.frecuenciaInt == 'M' && solicitud.diaPagoInteres == 'F'){
				$('#diaMesCapital').attr('disabled',true);
			}
			if(solicitud.frecuenciaInt == 'U'){
				$('#numAmortInteres').attr('disabled',true);
			}
			
			if(solicitud.diaPagoCapital == 'F'){
				$('#diaPagoCapital2').attr('checked', false);
				$('#diaPagoCapital1').attr('checked', true);
				$('#diaPagoCapital').val("F");
				$('#diaMesCapital').val("");
			}else{
				$('#diaPagoCapital1').attr('checked', false);
				$('#diaPagoCapital2').attr('checked', true);
				$('#diaPagoCapital').val("A");
				$('#diaMesCapital').val(solicitud.diaMesCapital);
			}

			if(solicitud.diaPagoInteres == 'F'){
				$('#diaPagoInteres2').attr('checked',false);
				$('#diaPagoInteres1').attr('checked',true);
				$('#diaPagoInteres').val("F");
				$('#diaMesInteres').val("");
			}else{
				$('#diaPagoInteres1').attr('checked',false);
				$('#diaPagoInteres2').attr('checked',true);
				$('#diaPagoInteres').val("A");
				$('#diaMesInteres').val(solicitud.diaMesInteres);
			}
			
			if($('#tipoPagoCapital').val() == 'C' || $('#perIgual').val() == 'S' ) {
				$('#diaPagoInteres1').attr('disabled',true);
				$('#diaPagoInteres2').attr('disabled',true);
				$('#diaMesInteres').attr('disabled',true);
			}
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
			$('#fechaVencimiento').val("");
		}else{
			plazosCredServicio.consulta(tipoCon,PlazoBeanCon,function(plazos) { 
				if(plazos!=null){ 
					$('#numAmortInteres').val(plazos.numCuotas);
					amortizacionesInt = plazos.numCuotas;
					NumCuotasInt= plazos.numCuotas;
					amortizacionRealInt = plazos.numCuotas;
				}
			});
		}
	}
	

	
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
	
	
	$("#diaMesCapital").blur(function (){
		if( $('#perIgual').val() =='S' || $('#tipoPagoCapital').val() =='C'){
			$("#diaMesInteres").val(this.value);	
		}
	});
	
	// valida solo una cuota mas o una menos
	$('#numAmortInteres').blur(function(){
		if(this.value != '' && $("#frecuenciaInt").val() !='P'){
			if(parseInt(amortizacionRealInt) - parseInt(this.value) > 1){
				  mensajeSis('Solo Una Cuota Menos.');
				  $('#numAmortInteres').val(amortizacionesInt);
					$('#numAmortInteres').focus();
			}else{
						if(parseInt(this.value) - parseInt(amortizacionRealInt) > 1){
							mensajeSis('Solo Una Cuota Más.');
							$('#numAmortInteres').val(amortizacionesInt);
							$('#numAmortInteres').focus();
					    }
						else {
								if(parseInt(this.value)- 1 > amortizacionesInt ){							
									mensajeSis("Solo Una Cuota Más.");
									$('#numAmortInteres').val(amortizacionesInt);
									$('#numAmortInteres').focus();
								}
								if(parseInt(this.value) + 1 < amortizacionesInt ){
										mensajeSis("Solo Una Cuota Menos.");
										$('#numAmortInteres').val(amortizacionesInt);
										$('#numAmortInteres').focus();
								}
						}
			}
		}
		
	});	
	
	// valida solo una cuota mas o una menos
	$('#numAmortizacion').blur(function(){
		if(this.value != '' && $("#frecuenciaCap").val() !='P'){
			if(parseInt(amortizacionReal) - parseInt(this.value) > 1){
				mensajeSis('Solo Una Cuota Menos.');
				$('#numAmortizacion').val(amortizaciones);
				$('#numAmortizacion').focus();
			}else{
						if(parseInt(this.value) - parseInt(amortizacionReal) > 1){
							mensajeSis('Solo Una Cuota Más.');
							$('#numAmortizacion').val(amortizaciones);
							$('#numAmortizacion').focus();
					    }
						else {
								if(parseInt(this.value)- 1 > amortizaciones  ){
									mensajeSis("Solo Una Cuota Más.");
									$('#numAmortizacion').val(amortizaciones);
									$('#numAmortizacion').focus();
								}
								if(parseInt(this.value) + 1 < amortizaciones ){
									mensajeSis("Solo Una Cuota Menos.");
									$('#numAmortizacion').val(amortizaciones);
									$('#numAmortizacion').focus();
								}
						   }
				}
		}
	});
	
});//Fin de jquery


/* Funcion para calcular el monto de seguro, tambien actualiza el monto de solicitud de credito segun sea el caso en la forma de pago del seguro */
function calculoCostoSeguro(prodCredito){ 
	if($('#conProd').val() == 'S' || $('#conProduc').val() != prodCredito) { 
	if(modalidad == 'U'){
	var factRiesgo =$('#factorRiesgoSeguro').asNumber();
	var iva = parseFloat(parametroBean.ivaSucursal);   // el porcentaje esta en decimales, ej. 0.16 
	var descSeguro = (descuentoSeg / 100);

	$('tr[name=renglon]').each(function() {
			var costoSeguroVida= 0;
			var montoDescuento = 0;
			var montoComAperturaCred = parseFloat(montoComapertura);
			var numero= this.id.substring(7,this.id.length);
			var jqMontoComIva = eval("'#montoComIva" + numero+"'");
			var jqMontoSegVida = eval("'#montoSeguroVida" + numero+"'");
			var jqMontoSolicitudOriginal = eval("'#montoOriginal" + numero+"'");
			
			var jqMontoSolicitud = eval("'#montoSol" + numero+"'");

			var jqPagaIVA= eval("'#pagaIVA" + numero+"'");
			
			var jqDescuentoSeguro = eval("'#descuentoSeguro" + numero+"'");
			var jqMontoSegOriginal = eval("'#montoSegOriginal" + numero+"'");
			
			/* Calcula el monto de seguro */
			costoSeguroVida=(factRiesgo / 7) * $(jqMontoSolicitudOriginal).asNumber() * $('#noDias').asNumber();
			$(jqMontoSegOriginal).val(costoSeguroVida);	

			montoDescuento = costoSeguroVida-(costoSeguroVida * descSeguro);
			$(jqDescuentoSeguro).val(descuentoSeg);	


			//$(jqMontoSegVida).val(Math.round(costoSeguroVida * 100) / 100);
			$(jqMontoSegVida).val(montoDescuento);
			$(jqMontoSegVida).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
			

			/* Calcula el monto de comision por apertura */
			 if(tipoComApertura == 'P'){ // si el tipo de cobro de comision por apertura es un porcentaje, calcula el monto
				 var porcentajeComAper = parseFloat(montoComapertura /100);
				   montoComAperturaCred = parseFloat($(jqMontoSolicitudOriginal).asNumber()  * porcentajeComAper);
				}
			
			if($(jqPagaIVA).val() == 'S'){ // si el cliente paga iva
				montoComAperturaCred = parseFloat(montoComAperturaCred) + parseFloat((montoComAperturaCred * iva));				
			}
				
			montoComIvaSol = parseFloat($(jqMontoSolicitudOriginal).asNumber());
			
			/* Calcula el monto total de la solicitud (sumando el monto del seguro y de comision por apertura si el pc de credito lo requiere ) */
			if($('#forCobroSegVida').val() == 'F' && $(jqMontoSolicitudOriginal).asNumber() > 0){ 
					
				
				montoComIvaSol += parseFloat(montoDescuento);	
				
			}
			
			if( formaComApertura == 'F' && $(jqMontoSolicitudOriginal).asNumber() > 0){
					montoComIvaSol += parseFloat(montoComAperturaCred);
			}
			
			$(jqMontoSolicitud).val(montoComIvaSol);			
			$(jqMontoSolicitud).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
			agregaFormatoControles('formaGenerica');
	
	});
	
	}else{
		//validaEsquemaTasas();
		calculoCostoSeguroTipoPago(prodCredito);
	}
  }
}

// calculo de forma de pago del seguro de vida por tipo de pago 


/* Funcion para calcular el monto de seguro, tambien actualiza el monto de solicitud de credito segun sea el caso en la forma de pago del seguro */
function calculoCostoSeguroTipoPago(prodCredito){
	if(modalidad == 'T'){
	$('#factorRiesgoSeguro').val(factorRS);
	var factorRiesgo = $('#factorRiesgoSeguro').val();
	var factRiesgo = $('#factorRiesgoSeguro').asNumber();
	
	var iva = parseFloat(parametroBean.ivaSucursal);   // el porcentaje esta en decimales, ej. 0.16 
	var esqSeguVida = esquemaSeguro;
	var pagoseguroTip = $('#forCobroSegVida').val();
	var descSeguro=0;
	
	var esquemaSeguroVid = esquemaSeguro;
	var tipPagoSegu = $('#forCobroSegVida').val();

	var esquemaSeguroBean = {
			'productoCreditoID' : $('#prodCred').val(),
			'esquemaSeguroID' : esquemaSeguroVid,
			'tipoPagoSeguro'  : tipPagoSegu
	};
	
	var tipoConsulta = 3;
	esquemaSeguroVidaServicio.consulta(tipoConsulta,esquemaSeguroBean,function(esquema) {									
				if (esquema != null) {

					factorRS = esquema.factorRiesgoSeguro;
					porcentajeDesc = esquema.descuentoSeguro;
					descSeguro = (porcentajeDesc / 100);
				 	montoPol = esquema.montoPolSegVida;
				 	
				 	$('#montoPolSegVida').val(montoPol);
				 	$('tr[name=renglon]').each(function() {
						var costoSeguroVida= 0;
						var montoComAperturaCred = parseFloat(montoComapertura);
						var numero= this.id.substring(7,this.id.length);
						var jqMontoSegVida = eval("'#montoSeguroVida" + numero+"'");
						var jqMontoSolicitudOriginal = eval("'#montoOriginal" + numero+"'");
						var jqMontoSolicitud = eval("'#montoSol" + numero+"'");
						var jqPagaIVA= eval("'#pagaIVA" + numero+"'");
						var jqMontoComIva = eval("'#montoComIva" + numero+"'");
						var jqDescuentoSeguro = eval("'#descuentoSeguro" + numero+"'");
						var jqMontoSegOriginal = eval("'#montoSegOriginal" + numero+"'");
						
						var pagoseguro = $('#forCobroSegVida').val();
						var costoSeguroVida = 0;
						var montoDescuento = 0;

						/* Calcula el monto de seguro */
						costoSeguroVida=( esquema.factorRiesgoSeguro / 7) * $(jqMontoSolicitudOriginal).asNumber() * $('#noDias').asNumber();
						$(jqMontoSegOriginal).val(costoSeguroVida);	
						
						montoDescuento = costoSeguroVida-(costoSeguroVida * descSeguro);
						$(jqDescuentoSeguro).val(porcentajeDesc);	
						
						$(jqMontoSegVida).val(montoDescuento.toFixed(2));
						$(jqMontoSegVida).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
						
						
						/* Calcula el monto de comision por apertura */
						 if(tipoComApertura == 'P'){ // si el tipo de cobro de comision por apertura es un porcentaje, calcula el monto
							 var porcentajeComAper = parseFloat(montoComapertura /100);
							   montoComAperturaCred = parseFloat($(jqMontoSolicitudOriginal).asNumber()  * porcentajeComAper);
							   
							}
						
						if($(jqPagaIVA).val() == 'S'){ // si el cliente paga iva
							montoComAperturaCred = parseFloat(montoComAperturaCred) + parseFloat((montoComAperturaCred * iva));

						}
						montoComIvaSol = parseFloat($(jqMontoSolicitudOriginal).asNumber());
						
						/* Calcula el monto total de la solicitud (sumando el monto del seguro y de comision por apertura si el pc de credito lo requiere ) */
						if($('#forCobroSegVida').val() == 'F' && $(jqMontoSolicitudOriginal).asNumber() > 0){ 
								montoComIvaSol += parseFloat(montoDescuento);
								
						}
						
						if( formaComApertura == 'F' && $(jqMontoSolicitudOriginal).asNumber() > 0){
							montoComIvaSol += parseFloat(montoComAperturaCred); 
							
						}
						
						$(jqMontoSolicitud).val(montoComIvaSol);			
						$(jqMontoSolicitud).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
						agregaFormatoControles('formaGenerica');
				
				});

			}else{
			
						factorRS = 0;
						porcentajeDesc = 0.00;
					 	montoPol = 0.00;
					 	
						$('#montoSeguroVida').val("0.00");
						$('#forCobroSegVida').val("");
						$('#tipPago').val("");
					}
		
	});
	
	
	}else{
		
	}
	
}



//termina 




//funcion que inicializa los combos del calendario de pagos
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
}


//funcion que inicializa los combos del calendario de pagos
function funcionExito(){ 
	$('#gridIntegrantes').html("");
	$('#gridIntegrantes').hide();
	$('#productoCreditoID').val("");
	$('#descripProducto').val("");
	$('#gridIntegrantes').html("");
	$('#gridIntegrantes').hide();
	inicializaCombos();
	inicializaForma('formaGenerica','grupoID' );
	
}
//funcion que inicializa los combos del calendario de pagos
function funcionFallo(){ 
	agregaFormatoControles('formaGenerica');	
}

//valida vacios cuando se hace el submit de  una solicitud
function validaCamposRequeridos(){
	// valida que la fecha de vencimiento no este vacia
	if($('#fechaVencimiento').val() == ""){
		mensajeSis("La Fecha de Vencimiento Está Vací­a.");
		procede = 1;
	}else{
		if($('#frecuenciaCap').val() == '0' ||$('#frecuenciaCap').val() =="" ){
			mensajeSis("La Frecuencia de Capital Está Vacío.");
			esTab=true;
			$('#frecuenciaCap').focus();
			procede = 1; 
		}else{
			if($('#frecuenciaCap').val() == 'U' ){
				if($('#tipoPagoCapital').val()!="I"){
					mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
					procede = 1;
				}else{
					if($('#tipoPagoCapital').val() == ''){
						mensajeSis("El Tipo de Pago Está Vacío.");
						$('#tipoPagoCapital').focus();
						procede = 1; 
					}else{
						if($('#diaPagoCapital2').is(':checked') && $('#diaMesCapital').asNumber()==0 ){ 
							mensajeSis("Especificar Día Mes Capital.");
							$('#diaMesCapital').focus();
							procede = 1; 
						}else{
							if($('#tipoPagoCapital').val() != "C"){
								if($('#frecuenciaInt').val() == '0' ||$('#frecuenciaInt').val() ==""){
									mensajeSis("Especifique Frecuencia de Interés.");
									$('#frecuenciaInt').focus();
									procede = 1; 
								}else{
									if($('#numAmortInteres').val() == '0' ||$('#numAmortInteres').val() ==""){
										mensajeSis("Numero de Cuotas de Interés.");
										$('#numAmortInteres').focus();
										procede = 1; 
									}else{
										if($('#diaPagoInteres2').is(':checked') && $('#diaMesInteres').asNumber()==0 ){ 
											mensajeSis("Especificar Día Mes Interés.");
											$('#diaMesInteres').focus();
											procede = 1; 
										}else{
											procede = 0; 
										}
									}
								}
							}else{
								procede = 0; 
							} 
						}	
					}
				}
			}else{
				if($('#tipoPagoCapital').val() == ''){
					mensajeSis("El Tipo de Pago Está Vacío.");
					$('#tipoPagoCapital').focus();
					procede = 1; 
				}else{
					if($('#diaPagoCapital2').is(':checked') && $('#diaMesCapital').asNumber()==0 ){ 
						mensajeSis("Especificar Día Mes Capital.");
						$('#diaMesCapital').focus();
						procede = 1; 
					}else{
						if($('#tipoPagoCapital').val() != "C"){
							if($('#frecuenciaInt').val() == '0' ||$('#frecuenciaInt').val() ==""){
								mensajeSis("Especifique Frecuencia de Interés.");
								$('#frecuenciaInt').focus();
								procede = 1; 
							}else{
								if($('#numAmortInteres').val() == '0' ||$('#numAmortInteres').val() ==""){
									mensajeSis("Numero de Cuotas de Interés.");
									$('#numAmortInteres').focus();
									procede = 1; 
								}else{
									if($('#diaPagoInteres2').is(':checked') && $('#diaMesInteres').asNumber()==0 ){ 
										mensajeSis("Especificar Día Mes Interés.");
										$('#diaMesInteres').focus();
										procede = 1; 
									}else{
										procede = 0; 
									}
								}
							}
						}else{
							procede = 0; 
						} 
					}	
				}
			}
		}	
	}
	return procede; 
}


/* Consulta el Ciclo del Cliente */
function consultacicloCliente(producto){
	var numFilas = cuentaFilasGrid();
	var contador = 0;
	var numCanceladas = 0;
	$('tr[name=renglon]').each(function() {		
		
		var numero= this.id.substring(7,this.id.length);
		var jqCliente = eval("'#clienteID" + numero+"'");
		var jqProspecto = eval("'#prospectoID" + numero+"'");
		var jqCicloCte = eval("'#ciclo" + numero+"'");
		var jqEstatusSolicitud = eval("'#estatus" + numero+"'");
		
		if($(jqEstatusSolicitud).val() == 'C'){
			numCanceladas += 1;
			
			if(numCanceladas == numFilas){
				deshabilitaBoton('modificar','submit');
			}
		}
				
		var CicloCreditoBean = {
				'clienteID':$(jqCliente).val(),
				'prospectoID':$(jqProspecto).val(),
				'productoCreditoID':producto,
				'grupoID':$('#grupoID').val()
		}; 
		setTimeout("$('#cajaLista').hide();", 200);
		solicitudCredServicio.consultaCiclo(CicloCreditoBean,function(cicloCreditoCte) {
			contador += 1;
			if(cicloCreditoCte !=null){
				$(jqCicloCte).val(cicloCreditoCte.cicloCliente);
				
				if(parseInt(numFilas)  == parseInt(contador)){	
					validaEsquemaTasas(producto); // valida que haya un esquema de tasa para cada solicitud de credito
				}
				
			}else{
				mensajeSis('No hay Ciclo para el Cliente.');
			}
		});
	});	
}


function eliminarFila(control){	
	var numeroID = control;
	var jqRenglon = eval("'#renglon" + numeroID + "'");	
	var tr = ''; 	
		
		var jqsolicitudCre = eval("'#solicitudCre"+ numeroID +"'");
		var jqMontoOriginal = eval("'#montoOriginal"+ numeroID +"'");
		var jqMontoSol = eval("'#montoSol"+ numeroID +"'");
		
		tr += '<td> <input type="hidden" name="lSolicitudCre" value="' + $(jqsolicitudCre).val() +'" />  </td>';
		tr += '<td> <input type="hidden" name="lMontoOriginal" value="' + $(jqMontoOriginal).asNumber() +'" />  </td>';
		tr += '<td> <input type="hidden" name="lMontoSol" value="' + $(jqMontoSol).asNumber() +'" />  </td>';
		tr += '<td>  <input type="hidden" name="lEstatusSolici" value="E" id="estatus'+numeroID + '"/> </td>';
		tr += '<td>  <input type="hidden" name="lDescuentoSeguro" value="" id="descuentoSeguro'+numeroID + '"/> </td>';
		tr += '<td>  <input type="hidden" name="lMontoSegOriginal" value="" id="montoSegOriginal'+numeroID + '"/> </td>';

		$(jqRenglon).children().remove();   // borra todo lo que contiene		
		$(jqRenglon).append(tr);			// agrega el nuevo tr con los nuevos campos ocultos
}



/* funcion para validar esquema de tasas cuando se modifica el producto de credito  */
function validaEsquemaTasas(producCreditoID){
	contador = 0;		
	numFilas = cuentaFilasGrid();
	numErr = 0;
	encontrado = [];
	idMontoSol = [];
	errMsj = "No Existe Esquema de Tasa para la(s) Solicitud(es) de Crédito: ";
	var numero=0;
	var beanConsulta;
	var sucursalID = parametroBean.sucursal; 
	var jqSolicitudCred;
	var jqCalificaCredito;
	var jqNumCiclo;
	var jqMontoCredito;
	var numCiclo= 0;	
	var jqMontoSol;
	var jqMontoSegVida;
	var jqClienteID;
	var jqForCobroSegVida;
	var forCobroSegVida = $("#forCobroSegVida").val();
	var jqMontoSVOriginal;
	var jqEstatusSolicitud;
	
	if(forCobroSegVida=='D'){
		forCobroSegVida = 'DEDUCCCION';
	}else{
		if(forCobroSegVida=='A'){
			forCobroSegVida = 'ANTICIPADO';
		}else{
			if(forCobroSegVida=='F'){
			forCobroSegVida = 'FINANCIAMIENTO';
			}
			else{
				if(forCobroSegVida=='O'){
				forCobroSegVida = 'OTRO';
			    }
		     }
		 }
	}
	
	$('tr[name=renglon]').each(function() {			
			 numero= this.id.substring(7,this.id.length);			
			 
			 jqSolicitudCred = eval("'#solicitudCre" + numero+"'");
			 jqClienteID = eval("'#clienteID" + numero+"'");
			 jqMontoCredito = eval("'#montoSol" + numero+"'");
			 jqCalificaCredito = eval("'#calificaCredito" + numero+"'");		 
			 jqNumCiclo =  eval("'#ciclo" + numero+"'");	
			 jqMontoSol = eval("'#montoSol"+numero+"'");	
			 jqMontoSegVida = eval("'#montoSeguroVida"+numero+"'");	
			 jqMontoSVOriginal = eval("'#montoOriginal"+numero+"'");	
			 jqForCobroSegVida = eval("'#forCobroSegVida"+numero+"'");	
			 jqEstatusSolicitud = eval("'#estatus"+numero+"'");	
			 $(jqForCobroSegVida).val(forCobroSegVida);
			 
			 // solo valida si el estatus de la solicitud no es Cancelada o si la solicitud no ha sido eliminada del grid
			 if($(jqEstatusSolicitud).val() != 'C' && $(jqEstatusSolicitud).val() != 'E' ){						 				 
					 numCiclo = parseInt($(jqNumCiclo).val());
				
					 beanConsulta = { 
								'sucursal' 			: sucursalID, 
								'producCreditoID'	: producCreditoID,
								'montoCredito'		: $(jqMontoCredito).asNumber(),
								'calificaCliente'	: $(jqCalificaCredito).val()	,
								'solicitudID'		: $(jqSolicitudCred).val()
						};			 
					 		 
						
					 consultaTasa(numCiclo,beanConsulta,jqMontoSol, jqMontoSegVida,jqMontoSVOriginal, numero, producCreditoID);	
			 }else{
				 contador += 1;	
			 }
								 
	});
	
}


/* Realiza la consulta para cada solicitud de credito grupal para verificar si existe un esquema de tasa */
function consultaTasa(numCiclo,beanConsulta, jqMontoSol, jqMontoSegVida,jqMontoSVOriginal, numero, producCreditoID){		
		creditosServicio.consultaTasa(numCiclo,beanConsulta,function(tasas) { 
			 contador += 1;		  	
			
				if(tasas==null || parseFloat(tasas.valorTasa) <= parseFloat(0.0)){					
					numErr += 1;	
					idMontoSol.push(numero);
					$(jqMontoSol).attr('readonly', false);
					$(jqMontoSol).val('0.00');
					$(jqMontoSegVida).val('0.00');
					$(jqMontoSVOriginal).val('0.00');
					 
					if(contador <=1){
						encontrado.push(beanConsulta.solicitudID);
					}else{
						encontrado.push(beanConsulta.solicitudID);
					}				
				} 
								
				 // si ya termino de recorrer todas las filas del grid, verifica si encontro algun error en los esquemas de tasa y envia el mensaje
				 if(parseInt(numFilas) == parseInt(contador)){
					 if(parseInt(numErr) > 0){
						 validaDatosGrid(1);
						 idMontoSol= idMontoSol.sort(function(a, b){return a-b});
						 var jqPonerFoco = eval("'#montoSol"+idMontoSol[0]+"'");
							$(jqPonerFoco).focus();	
							
							encontrado = encontrado.sort(function(a, b){return a-b});
							 
							 $.each(encontrado, function (indice, solicitudID) { 
								 if(indice == 0){
									 errMsj += " " + solicitudID; 
								 }else{
									 errMsj += ", " + solicitudID; 
								 }
								
								}); 
							 
							 mensajeSis(errMsj);
					 }else{
						 if(requiereGL == 'S'){
							 validaEsquemaGarantiaLiquida();
						 }
					 }
					 
					 /* llama la funcion para que esta asu vez mande a llamar la funcion para recalcular el monto de seguro */
					 consultaFechaVencimiento('',producCreditoID);
				 }
				
		});
}


/* funcion para validar esquema de garantia liquida cuando se modifica el producto de credito */
function validaEsquemaGarantiaLiquida(){
	contador = 0;		
	numFilas = cuentaFilasGrid();
	numErr = 0;
	encontrado = [];
	idMontoSol = [];
	errMsj = "No Existe Esquema de Garantía Líquida para la(s) Solicitud(es) de Crédito: ";
	var numero=0;
	var beanConsulta;
	var tipoCon = 1;
	var jqSolicitudCred;
	var producCreditoID = $('#productoCreditoID').val(); 
	var jqCalificaCredito;
	var jqMontoSol;
	var jqMontoSegVida;
	var jqMontoSVOriginal;
	var jqClienteID;
	var jqEstatusSolicitud;
		
	$('tr[name=renglon]').each(function() {			
			 numero= this.id.substring(7,this.id.length);
			 			 
			 jqSolicitudCred = eval("'#solicitudCre" + numero+"'");
			 jqClienteID = eval("'#clienteID" + numero+"'");
			 jqMontoSol = eval("'#montoSol" + numero+"'");
			 jqCalificaCredito = eval("'#calificaCredito" + numero+"'");
			 jqMontoSegVida = eval("'#montoSeguroVida"+numero+"'");	
			 jqMontoSVOriginal = eval("'#montoOriginal"+numero+"'");
			 jqEstatusSolicitud = eval("'#estatus"+numero+"'");	
			 
			 // solo valida si el estatus de la solicitud no es Cancelada o si la solicitud no ha sido eliminada del grid
			 if($(jqEstatusSolicitud).val() != 'C' && $(jqEstatusSolicitud).val() != 'E' ){	
		
					 beanConsulta = { 
							 	'clienteID'			: $(jqClienteID).val(),
							 	'producCreditoID'	:$('#productoCreditoID').val(),
								'calificacion'		: $(jqCalificaCredito).val(),
								'montoSolici'		: $(jqMontoSol).asNumber(), //$(jqMontoSVOriginal).asNumber(),
								'solicitudID'		: $(jqSolicitudCred).val()
						};			 
					 		 
					 consultaGarantiaLiquida(tipoCon, beanConsulta, jqMontoSol, jqMontoSegVida, jqMontoSVOriginal,numero);
			 }else{
				 contador += 1;
			 }
								 
	});
	
}

function consultaGarantiaLiquida (tipoCon,beanConsulta, jqMontoSol, jqMontoSegVida, jqMontoSVOriginal,numero){	
	// obtiene el porcentaje de garantia liquida
	esquemaGarantiaLiqServicio.consulta(tipoCon,beanConsulta,function(respuesta) { 
		contador += 1;	
				if (respuesta == null || respuesta == undefined) {		
					numErr += 1;	
					idMontoSol.push(numero);	
					$(jqMontoSol).attr('readonly', false);
					$(jqMontoSol).val('0.00');
					$(jqMontoSegVida).val('0.00');
					$(jqMontoSVOriginal).val('0.00');
					 
					if(contador <=1){ 
						$(jqMontoSol).focus();	
						encontrado.push(beanConsulta.solicitudID);
					}else{
						encontrado.push(beanConsulta.solicitudID);
					}
				}
				
				
				 // si ya termino de recorrer todas las filas del grid, verifica si encontro algun error en los esquemas de GL y envia el mensaje
				 if(parseInt(numFilas) == parseInt(contador)){ 
					 if(parseInt(numErr) > 0){ 
						 idMontoSol= idMontoSol.sort(function(a, b){return a-b});
						 var jqPonerFoco = eval("'#montoSol"+idMontoSol[0]+"'");
							$(jqPonerFoco).focus();	
							encontrado = encontrado.sort(function(a, b){return a-b});
							 
							 $.each(encontrado, function (indice, solicitudID) {  
								 if(indice == 0){
									 errMsj += " " + solicitudID; 
								 }else{
									 errMsj += ", " + solicitudID; 
								 }
								
								}); 
							 
							 mensajeSis(errMsj);					
					 }
				 }
			});	
	
}


/* verifica el valor cuando el campo de monto de solicitud toma el foco, pone ceros por default */
function verificarEntrada(controlID){
	var jqMontoSol = eval("'#"+controlID + "'");
	var esReadonly = $(jqMontoSol).is('[readonly]');
	
	if(!esReadonly){
		$(jqMontoSol).val("0.00");
		agregaFormatoControles('formaGenerica');
	}
}


/* valida el monto capturado cuando una solicitud de credito no tiene un esquema de tasa o garantia liquida */
function validaNuevoMontoSolicitud(controlID){ 
	var beanConsulta;
	var tipoCon;
	var  numero= controlID.substring(8,controlID.length);
	var jqMontoSol = eval("'#"+controlID + "'");
	var jqMontoSeguro = eval("'#montoSeguroVida"+numero + "'");
	var jqMontoSVOriginal = eval("'#montoOriginal"+numero+"'");
	var montoSolicitado = $(jqMontoSol).asNumber();
	var producCreditoID = $('#productoCreditoID').val(); 
	var jqCalificaCredito;
	var jqClienteID;  
	var jqNumCiclo;
	var numCiclo= 0;
	var esReadonly = $(jqMontoSol).is('[readonly]');

//	var stackx = $.Callbacks();
	
		if(!esReadonly){
			if($(jqMontoSol).val().length <= 19){	
						if(montoSolicitado > 0 ){
							
							/* ============ Primero se valida que el nuevo monto ingresado caiga en el rango que ofrece el producto de credito =========== */
							if(parseFloat(montoSolicitado) < parseFloat(montoMinimo)){
								mensajeSis("El Monto Solicitado No puede ser Menor a "+montoMinimo);
								$(jqMontoSol).val('0.00');
								$(jqMontoSeguro).val('0.00');
								$(jqMontoSVOriginal).val('0.00');
								$(jqMontoSol).focus();
							}else{
									if(parseFloat(montoSolicitado) > parseFloat(montoMaximo)){
										mensajeSis("El Monto Solicitado No puede ser Mayor a "+montoMaximo);
										$(jqMontoSol).val('0.00');
										$(jqMontoSeguro).val('0.00');
										$(jqMontoSVOriginal).val('0.00');
										$(jqMontoSol).focus();
									}else{		


										/*  =================== SE REALIZA EL CALCULO DEL COSTO DE SEGURO DE VIDA Y COMISION POR APERTURA ANTES DE BUSCAR EL ESQUEMA DE TASA Y GAR LIQ.=====  */
													var factRiesgo =$('#factorRiesgoSeguro').asNumber();
													var iva = parseFloat(parametroBean.ivaSucursal);   // el porcentaje esta en decimales, ej. 0.16 
													var descSeguro = (descuentoSeg / 100);
													$('#factorRiesgoSeguro').val(factorRS);
													var factorRiesgo = $('#factorRiesgoSeguro').val();																				
													var esquemaSeguroVid = esquemaSeguro;
													var tipPagoSegu = $('#forCobroSegVida').val();

													var costoSeguroVida= 0;
													var montoComAperturaCred = parseFloat(montoComapertura);
												
													var jqMontoSegVida = eval("'#montoSeguroVida" + numero+"'");
													var jqPagaIVA= eval("'#pagaIVA" + numero+"'");
													var jqMontoComIva = eval("'#montoComIva" + numero+"'");
													var jqDescuentoSeguro = eval("'#descuentoSeguro" + numero+"'");
													var jqMontoSegOriginal = eval("'#montoSegOriginal" + numero+"'");
																		
													var pagoseguro = $('#forCobroSegVida').val();
													var montoDescuento = 0;



												/* ============================= Si el calculo del seguro es por  tipo de cobro unico ======================== */
												if(modalidad == 'U'){																	
															
															/* Calcula el monto de seguro */
															costoSeguroVida=(factRiesgo / 7) * $(jqMontoSol).asNumber() * $('#noDias').asNumber();
															$(jqMontoSegOriginal).val(costoSeguroVida);	

															montoDescuento = costoSeguroVida-(costoSeguroVida * descSeguro);
															$(jqDescuentoSeguro).val(descuentoSeg);	


															//$(jqMontoSegVida).val(Math.round(costoSeguroVida * 100) / 100);
															$(jqMontoSegVida).val(montoDescuento);
															$(jqMontoSegVida).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
															

															/* Calcula el monto de comision por apertura */
															 if(tipoComApertura == 'P'){ // si el tipo de cobro de comision por apertura es un porcentaje, calcula el monto
																 var porcentajeComAper = parseFloat(montoComapertura /100);
																   montoComAperturaCred = parseFloat($(jqMontoSol).asNumber()  * porcentajeComAper);
																}
															
															if($(jqPagaIVA).val() == 'S'){ // si el cliente paga iva
																montoComAperturaCred = parseFloat(montoComAperturaCred) + parseFloat((montoComAperturaCred * iva));				
															}
																
															montoComIvaSol = parseFloat($(jqMontoSol).asNumber());
															
															/* Calcula el monto total de la solicitud (sumando el monto del seguro y de comision por apertura si el pc de credito lo requiere ) */
															if($('#forCobroSegVida').val() == 'F' && $(jqMontoSol).asNumber() > 0){ 
																	
																
																montoComIvaSol += parseFloat(montoDescuento);	
																
															}
															
															if( formaComApertura == 'F' && $(jqMontoSol).asNumber() > 0){
																	montoComIvaSol += parseFloat(montoComAperturaCred);
															}
														
															$(jqMontoSol).val(montoComIvaSol);			
															$(jqMontoSol).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
															agregaFormatoControles('formaGenerica');
												}else{ 
														
												/* ============================ SI EL CALCULO DEL SEGURO ES POR ESQUEMAS ========================== */	
													if(modalidad == 'T'){ 	
															var esquemaSeguroBean = {
																			'productoCreditoID' : $('#prodCred').val(), //$('#productoCreditoID').val(),
																			'esquemaSeguroID' : esquemaSeguroVid,
																			'tipoPagoSeguro'  : tipPagoSegu
															};
																				
															var tipoConsulta = 3;
															esquemaSeguroVidaServicio.consulta(tipoConsulta,esquemaSeguroBean,{ async: false, callback: function(esquema) {									
																	if (esquema != null) { 
																		factorRS = esquema.factorRiesgoSeguro;
																		porcentajeDesc = esquema.descuentoSeguro;
																		descSeguro = (porcentajeDesc / 100);
																		montoPol = esquema.montoPolSegVida;																						

																		$('#montoPolSegVida').val(montoPol);
																				
																		/* Calcula el monto de seguro en este caso se usa el monto solicitud tota xq a este monto aun no se le ha sumado ningun accesorio*/
																		costoSeguroVida=( esquema.factorRiesgoSeguro / 7) * $(jqMontoSol).asNumber() * $('#noDias').asNumber();
																		$(jqMontoSegOriginal).val(costoSeguroVida);	
																		
																		montoDescuento = costoSeguroVida-(costoSeguroVida * descSeguro);
																		$(jqDescuentoSeguro).val(porcentajeDesc);	
																	
																		$(jqMontoSegVida).val(montoDescuento.toFixed(2));
																		$(jqMontoSegVida).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});																			
																		
																		/* Calcula el monto de comision por apertura */
																		 if(tipoComApertura == 'P'){ // si el tipo de cobro de comision por apertura es un porcentaje, calcula el monto
																			 var porcentajeComAper = parseFloat(montoComapertura /100);
																			   montoComAperturaCred = parseFloat($(jqMontoSol).asNumber()  * porcentajeComAper);																				   
																			}
																	
																		if($(jqPagaIVA).val() == 'S'){ // si el cliente paga iva
																			montoComAperturaCred = parseFloat(montoComAperturaCred) + parseFloat((montoComAperturaCred * iva));
																		}
																		montoComIvaSol = parseFloat($(jqMontoSol).asNumber());
																	
																		/* Calcula el monto total de la solicitud (sumando el monto del seguro y de comision por apertura si el pc de credito lo requiere ) */
																		if($('#forCobroSegVida').val() == 'F' && $(jqMontoSol).asNumber() > 0){ 
																				montoComIvaSol += parseFloat(montoDescuento);																					
																		}
																		
																		if( formaComApertura == 'F' && $(jqMontoSol).asNumber() > 0){
																			montoComIvaSol += parseFloat(montoComAperturaCred); 																				
																		}
																		
																		$(jqMontoSol).val(montoComIvaSol);		
																		$(jqMontoSol).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
																		agregaFormatoControles('formaGenerica');
																	}else{																							
																			factorRS = 0;
																			porcentajeDesc = 0.00;
																		 	montoPol = 0.00;
																		 	
																			$('#montoSeguroVida').val("0.00");
																			$('#forCobroSegVida').val("");
																			$('#tipPago').val("");
																		}
																}
																					
															});		
																				
														}
												}



										 jqClienteID = eval("'#clienteID" + numero+"'");
										 jqCalificaCredito = eval("'#calificaCredito" + numero+"'");

											/*  ========== Valida que exista un esquema de tasa para el nuevo monto ingresado ========= */
											 jqNumCiclo =  eval("'#ciclo" + numero+"'");							 				 
											 numCiclo = parseInt($(jqNumCiclo).val());				 
											 beanConsulta = { 
														'sucursal' 			: parametroBean.sucursal, 
														'producCreditoID'	: producCreditoID,
														'montoCredito'		: $(jqMontoSol).asNumber(),
														'calificaCliente'	: $(jqCalificaCredito).val()
												};
										  
											creditosServicio.consultaTasa(numCiclo,beanConsulta,function(tasas) {   
													if(tasas==null || parseFloat(tasas.valorTasa) <= parseFloat(0.0)){	
															mensajeSis("No Existe Esquema de Tasa para el Monto Especificado.");
															$(jqMontoSol).val('0.00');
															$(jqMontoSeguro).val('0.00');
															$(jqMontoSVOriginal).val('0.00');
															$(jqMontoSol).focus();
													}else{ 
																/*  ============ valida que exista un esquema de garantia liquida para el nuevo monto ingresado ======== */
																if(requiereGL == 'S'){  
																	tipoCon = 1;	
																		beanConsulta = { 
																			 	'clienteID'			: $(jqClienteID).val(),
																			 	'producCreditoID'	: producCreditoID,
																				'calificacion'		: $(jqCalificaCredito).val(),
																				'montoSolici'		: $(jqMontoSol).asNumber()																		};
																		esquemaGarantiaLiqServicio.consulta(tipoCon,beanConsulta,function(respuesta) {
																			contador += 1;	
																					if (respuesta == null) { 
																						mensajeSis("No Existe Esquema de Garantía Líquida para el Monto Especificado.");
																						$(jqMontoSol).val('0.00');
																						$(jqMontoSeguro).val('0.00');
																						$(jqMontoSVOriginal).val('0.00');
																						$(jqMontoSol).focus();
																					}else{  
																						$(jqMontoSVOriginal).val(montoSolicitado);
																					}
																			});
																 }else{
																	 $(jqMontoSVOriginal).val(montoSolicitado);																	 
																 }
													}
											});		

									}
							}
						}else{ 
							$(jqMontoSol).val('0.00');
							$(jqMontoSeguro).val('0.00');
							$(jqMontoSVOriginal).val('0.00');
						}
				}else{
					$(jqMontoSol).val('0.00');
					$(jqMontoSeguro).val('0.00');
					$(jqMontoSVOriginal).val('0.00');
					mensajeSis("Máximo 14 Dígitos y 2 Decimales.");	
					$(jqMontoSol).focus();
				}	
		}
}


// funcion para ocultar o mostrar los datos de seguro en el grid
function validaDatosGrid(tipoValidacion){	
	var numero=0;
	var jqTdMontoSeguro;
	var jqTdFormaPagSeguro;
	var jqMontoSol;
	var jqEstatusSol;
	var validaCamposSeguro = 1;
	var validaMontoSol = 2;
	var valido = true;
	var contador = 0;
	
	$('tr[name=renglon]').each(function() {
		numero= this.id.substring(7,this.id.length);
		
		/* ======== Validacioens de los campos de seguro ========== */
			if(tipoValidacion == validaCamposSeguro){
					jqTdMontoSeguro = eval("'#tdMontoSeguro" + numero+"'");
					jqTdFormaPagSeguro = eval("'#tdFormaCobSeguro" + numero+"'");	
				
						if($("#reqSeguroVidaNo").is(':checked')) {  
							$("#tdFormaCobSeguro").hide(-2000); 
							$("#tdMontoSeguro").hide(-2000); 
				           $(jqTdMontoSeguro).hide(-2000); 
				           $(jqTdFormaPagSeguro).hide(-2000); 
				        }else{
				        	$("#tdFormaCobSeguro").show(-2000); 
							$("#tdMontoSeguro").show(-2000); 
				        	$(jqTdMontoSeguro).show(-2000); 
					        $(jqTdFormaPagSeguro).show(-2000); 
				        }
			}else{
					/* ==== Validaciones del monto de solicitud ========== */
					if(tipoValidacion == validaMontoSol){
						jqMontoSol = eval("'#montoSol" + numero+"'");	
						jqEstatusSol = eval("'#estatus" + numero+"'");	
											
							if($(jqMontoSol).asNumber() <=0 && contador == 0 && $(jqEstatusSol).val() != 'E' && $(jqEstatusSol).val() != 'C') {  
								contador+=1;
								mensajeSis("El Monto de Solicitud No ha Sido Capturado.");
								$(jqMontoSol).focus();
								valido = false;
					        }
					}
							
		}
		 
	});
	return valido;
}	

/*    cuenta las filas de la tabla del grid       */
function cuentaFilasGrid(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
		totales++;		
	});
	return totales;
}


// consulta de la fecha de vencimiento en base al plazo
function consultaFechaVencimiento(idControl, producCreditoID){
	var valorCalculado =true;
	
	/* llega vacio para usarlo como bandera, xq esta funcion es llamada cuando se consulta el grupo
	 * pero se require q en esa ocacion no haga el calculo del numero de cuotas si no que solo setee lo que tiene registrado la solicitud
	*/
	if(idControl == ''){
		idControl = 'plazoID'
		valorCalculado = false;
	}
	var jqPlazo  = eval("'#" + idControl + "'");
	var plazo = $(jqPlazo).val();	
	var tipoCon=3;
	var PlazoBeanCon = { 
			'plazoID' :plazo, 
			'fechaActual' : $('#fechaInicio').val(),
			'frecuenciaCap' : $('#frecuenciaCap').val()
	};
	if(plazo == '0'){
		$('#fechaVencimiento').val("");
	}else{
		plazosCredServicio.consulta(tipoCon,PlazoBeanCon,function(plazos) { 
			if(plazos!=null){ 
				if($('#frecuenciaCap').val()!="U"){
					$('#fechaVencimiento').val(plazos.fechaActual);
					
					if(valorCalculado){
						$('#numAmortizacion').val(plazos.numCuotas);
						amortizaciones = plazos.numCuotas;
						if($('#tipoPagoCapital').val() == 'C' || $('#perIgual').val() =="S"){    
							$('#numAmortInteres').val(plazos.numCuotas);
							amortizacionesInt = plazos.numCuotas;
							amortizacionRealInt = plazos.numCuotas;
						}				
						
					}
					amortizacionReal = plazos.numCuotas;
					
					calculaNodeDias(plazos.fechaActual, producCreditoID);
					consultaFechaVencimientoCuotas(plazo, plazos.numCuotas );
				}else{
					$('#fechaVencimiento').val(plazos.fechaActual);
					$('#numAmortizacion').val("1"); 
					amortizaciones = 1;
					$('#numAmortInteres').val("1");
					amortizacionesInt = 1;
					amortizacionRealInt = 1;
					NumCuotas = 1; // se utiliza para saber cuando se agrega o quita una cuota
					NumCuotasInt = 1; // se utiliza para saber cuando se agrega o quita una cuota
					amortizacionReal = 1;
					calculaNodeDias(plazos.fechaActual, producCreditoID);
				}
			}
		});
	}
}

//funcion que consulta la fecha de vencimiento en base a ls cuotas
function consultaFechaVencimientoCuotas(plazo, numAmor){
	var prodCredit = $('#productoCreditoID').val();
	var tipoCon=4;
	var PlazoBeanCon = { 
			'frecuenciaCap' :$('#frecuenciaCap').val(), 
			'numCuotas': numAmor ,
			'periodicidadCap' : $('#periodicidadCap').val(),
			'fechaActual' : $('#fechaInicio').val()
	};
	if(plazo == '0'){
		$('#fechaVencimien').val("");
	}else{
		plazosCredServicio.consulta(tipoCon,PlazoBeanCon,function(plazos) { 
			if(plazos!=null){ 
				$('#fechaVencimiento').val(plazos.fechaActual);
				if($.trim($('#fechaVencimiento').val()) != "" && $.trim($('#fechaVencimiento').val()) != null){
					calculaNodeDias(plazos.fechaActual, prodCredit);
				}
			}
		});
	}
}


//	calcula el numero de dias entre las fecha inicio  y fecha final
function calculaNodeDias(varfechaVencimiento, prodCredit){	
	if ($('#fechaVencimiento').val() != '') {
				var tipoCons = 1;
				var PlazoBeanCon = {
						'plazoID' : $('#plazoID').val()
				};
				
					plazosCredServicio.consulta(tipoCons, PlazoBeanCon, function(plazos) {
					if (plazos != null) {
						$('#noDias').val(plazos.dias);// número de dias parametrizado en el plazo

						if (requiereSegurgoVida == 'S') {
							calculoCostoSeguro(); // calcula el seguro de vida

						} 
						
						if(parseInt($("#periodicidadCap").val()) > 0){
							if(parseInt($("#periodicidadCap").val()) <= parseInt($('#noDias').val())){
															
								if ($('#frecuenciaCap').val() == "U") {
									
									$('#periodicidadCap').val(plazos.dias);
									if ($("#tipoPagoCapital").val()=='C' || $('#perIgual').val() == 'S') {
										$('#periodicidadInt').val(plazos.dias);
									}
								}
							}else{
								mensajeSis("La Periodicidad de Capital es Mayor al Número de Días del Plazo.");
								$("#frecuenciaCap").focus();
							}	
						}
						
					}
				});
			}
}


function setFoco(){
	$("#plazoID").focus();
}





function consultaEsquemaSeguroVida(prodCredito,esq,tipoPAg){
	
	var esquemaSeguroVid = esq;
	var tipPagoSegu = $('#forCobroSegVida').val();

	var esquemaSeguroBean = {
			'productoCreditoID' : prodCredito,
			'esquemaSeguroID' : esquemaSeguroVid,
			'tipoPagoSeguro'  : tipPagoSegu
	};
	
	var tipoConsulta = 3;
	esquemaSeguroVidaServicio.consulta(tipoConsulta,esquemaSeguroBean,function(esquema) {									
				if (esquema != null) {

					factorRS = esquema.factorRiesgoSeguro;
					porcentajeDesc = esquema.descuentoSeguro;
				 	montoPol = esquema.montoPolSegVida;
				 	$('#montoPolSegVida').val(montoPol);


			}else{
			
						factorRS = 0;
						porcentajeDesc = 0.00;
					 	montoPol = 0.00;
					 	
						
					}
		
	});
	return factorRS;
}	

function consultaTiposPago(prod, tip) {
	dwr.util.removeAllOptions('tipPago'); 
	var prodCre = prod;

	var esquemaSeguroBean= {
			'productoCreditoID' : prodCre
	};
	
	var tipoLista  = 3;
	
	esquemaSeguroVidaServicio.lista(esquemaSeguroBean, tipoLista, function(tipoPuestos){
		dwr.util.removeAllOptions('tipPago'); 
		dwr.util.addOptions('tipPago',{'':'SELECCIONAR'});
		dwr.util.addOptions('tipPago', tipoPuestos, 'tipoPagoSeguro','descTipPago');
	
	$('#tipPago').val(tip).selected = true;

   });
	
}
