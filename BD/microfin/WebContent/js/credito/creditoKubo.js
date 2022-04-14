$("input#solicitudCreditoID").focusout(function(){
    var value = $(this).val();

    if(value != '0') { 
       $("input#fechaInicio").get(0).type = 'text';
        $("input#fechaInicio").attr('default');
    }
}); 


$(document).ready(function() { 
	esTab = true;
	var parametroBean = consultaParametrosSession();   
	var pagoFinAni;
	var pagoFinAniInt;
	var diaHabilSig;
	var ajustaFecAmo; 
	var ajusFecExiVen;   
	var tipoLista; 
	var transaccionGeneralC='C';
	var transaccionGeneralF='F';
	var MontoIni=0;
	var montoOriginal =0;
	
	
	$('#clienteInstitucion').val(parametroBean.clienteInstitucion);
	$('#cuentaInstitucion').val(parametroBean.cuentaInstitucion);   
	//Definicion de Constantes y Enums  
	var catTipoTransaccionCredito = {   
  		'agrega':'1',
  		'modifica':'2',
  		'simulador':'9'
  	}; 
	
	var catTipoConsultaCredito = { 
  		'principal'	: 1,
  		'foranea'	: 2,
  		'prodSinLin'	:3 
	};	 
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	 deshabilitaBoton('modifica', 'submit');
	// $('#tipoTransaccionSF').val(0);
	
	$(':text').focus(function() {	
	 	esTab = false; 
	});
	
	agregaFormatoControles('formaGenerica');
	agregaFormatoControles('gridDetalle');
	
	$.	validator.setDefaults({
		submitHandler: function(event) { //alert('transaccion sol fond'+$('#tipoTransaccionSF').val());
		//alert('transaccion credito'+$('#tipoTransaccion').val());
			if($('#tipoTransaccionSF').val()=='11'){// alert('graba solicitud fondeo ');
			//if($('#transaccionGeneral').val()==transaccionGeneralF){	  	
			//alert($('#transaccionGeneral').val()); 
	 			grabaFormaTransaccion(event, 'formaGenerica2', 'contenedorForma', 'mensaje','true','porcentaje'); 
	 			alert("Fondeo Completado");
	 			deshabilitaBoton('grabaSF');
				habilitaBoton('agrega');
				$('agrega').focus(); 
	 			esTab=true; 
	 			consultaSolicitudCred('solicitudCreditoID');
	 			habilitaBoton('agrega');
	  		}
			//if($('#transaccionGeneral').val()==transaccionGeneralC){ //al
			//alert($('#transaccionGeneral').val()); 
	  		if($('#tipoTransaccionSF').val()=='0'){ 
	  			var soli = $('#solicitudCreditoID').val();
				if(soli != '0'){ 
			 		$('#calendarioIrreg').val('N'); 
				}
					grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID');
				$('#contenedorSimulador').html("");
	  		}
	   }
	});	 
	
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccionSF').val('0');
		//$('#transaccionGeneral').val('C');
		$('#tipoTransaccion').val(catTipoTransaccionCredito.agrega);
				var fechaAplicacion = parametroBean.fechaAplicacion;
				var fechaIniForm = $('#fechaInicio').val();
				var fechaVenForm = $('#fechaVencimien').val();
				if(fechaIniForm < fechaAplicacion){ 
					alert("Fecha es menor a la del Sistema ");
					event.preventDefault();
				}
				if(fechaVenForm < fechaIniForm){
					alert("Fecha de Inicio es Inferior a la de Vencimiento  ");
					event.preventDefault();
				}
			
				
	});
	
	$('#modifica').click(function() {	
		$('#tipoTransaccionSF').val('0');	 
		$('#tipoTransaccion').val(catTipoTransaccionCredito.modifica);
				var fechaAplicacion = parametroBean.fechaAplicacion;
				var fechaIniForm = $('#fechaInicio').val();
				var fechaVenForm = $('#fechaVencimien').val();
				if(fechaIniForm < fechaAplicacion){
					alert("Fecha es menor a la del Sistema ");
					event.preventDefault();
				}
				if(fechaVenForm < fechaIniForm){
					alert("Fecha de Inicio es Inferior a la de Vencimiento  ");
					event.preventDefault();
				}
	});
	
	$('#grabaSF').click(function() {	  
		 //$('#transaccionGeneral').val('F');	
		  $('#tipoTransaccion').val('0');	
		// $('#tipoTransaccion').val(catTipoTransaccionCredito.agrega); 
		$('#tipoTransaccionSF').val('11');   
		var solicitud = $('#solicitudCreditoID').val();
		var tasaF = $('#tasaFija').val();  
		var montoFondear = $('#montoCredito').val();  
			if(solicitud == '0' || solicitud == ''){
				$('#tasa').val(tasaF);
				$('#porcentaje').val('100.00');
				$('#monto').val(montoFondear);
			}
	});
	
	$('#creditoID').bind('keyup',function(e){
		lista('creditoID', '2', '1', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
		 
	});
	
	$('#creditoID').blur(function() { 
  		validaCredito(this.id); 
	});
	
	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	}); 
	 
	$('#clienteID').blur(function() {
  		consultaCliente(this.id);
	});

	$('#soliCredID').blur(function() {
  		fondeoInver();
	}); 
	 
	$('#calcInteresID').blur(function() {
		validaTipoPago();
		ValidaCalcInteres(this.id);
		
	}); 
	
	$('#tipoFondeo').val('P'); 
	
	consultaMoneda();
	
	
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
	

	$('#lineaCreditoID').blur(function() {
		esTab=true; 
  		consultaLineaCredito(this.id);
  		

	}); 
        //Consulta Tasa Base al perder el Foco
   $('#tasaBase').blur(function() {
		if($('#tasaBase').val() !=0){
	   	consultaTasaBase(this.id); 
	   }
   });
        // Buscar Tasa Base por Nombre        
	$('#tasaBase').bind('keyup',function(e){
		if(this.value.length >= 2){
			lista('tasaBase', '2', '1', 'nombre', $('#tasaBase').val(), 'tasaBaseLista.htm');
		}				       
	}); 
	
	$('#producCreditoID').bind('keyup',function(e){  
		//if(this.value.length >= 2){
			lista('producCreditoID', '1', '3', 'descripcion', $('#producCreditoID').val(), '	listaProductosCredito.htm');
	//	}				       
	}); 	

	$('#producCreditoID').blur(function() {
  		consultaProducCredito(this.id);
		MontoIni= 0; // ṕara inicializar valor de monto de credito cuando se cambia el producto
	});
 
	
	$('#frecuenciaInt').blur(function() {
  		validaFrecuenciaInt(this.id);
	}); 
 
	$('#frecuenciaCap').blur(function() { 
  		validaFrecuenciaCap(this.id);
		
	});

	
	$('#tipoPagoCapital').click(function() { 
		validaTipoPago();
		$('#recalculo').hide(); 
	});
	$('#tipoPagoCapital2').click(function() { 
		if($('#tipoPagoCapital2').is(':checked')){  
	 		habilitaControl('frecuenciaInt'); 
	 		$('#recalculo').hide();    
      }  
	}); 
	$('#tipoPagoCapital3').click(function() { 
		if($('#tipoPagoCapital3').is(':checked')){   
			habilitaControl('frecuenciaInt'); 
			$('#recalculo').show();    
      }  
	});
	
	$('#calendIrregular').click(function(){
		 
		if($('#calendIrregular').is(':checked')){
				deshabilitaControl('tipoPagoCapital');
				deshabilitaControl('tipoPagoCapital2');
				deshabilitaControl('tipoPagoCapital3');
			} 
		else{ $('#tipoPagoCapital').removeAttr('disabled');
				$('#tipoPagoCapital2').removeAttr('disabled');
				$('#tipoPagoCapital3').removeAttr('disabled');//disabled
			}
		
		});
	
	
   $('#simular').click(function() {	
   
	//	$('#contenedorSimulador').show();
	/*$('#mensaje').html('<img src="images/barras.jpg" alt=""/>'); 
	$('#contenedorForma').block({
			message: $('#mensaje'),
			css: {border:		'none',
		 			background:	'none'}  
	});*/ 
 
		simulador();	
	});	 

	
	$('#solicitudCreditoID').bind('keyup',function(e){  
		if(this.value.length >= 0){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "clienteID";
		 	parametrosLista[0] = $('#solicitudCreditoID').val();
					
			lista('solicitudCreditoID', '1', '2', camposLista, parametrosLista, 'listaSolicitudCredito.htm');
		}				       
	});	
	 
	 
	$('#solicitudCreditoID').blur(function() {
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
		linea = $('#lineaCreditoID').val();
		if(linea != 0 && linea != ''){ 
  			consultaMonto(this.id);
		} 
	 	var numCredito = $('#creditoID').val();
		 if(numCredito == 0){

		 	quitaFormatoControles('formaGenerica');
			var monto =$('#montoCredito').val();
			var montoConv = parseFloat(monto);
			var MontoInic = parseFloat(MontoIni);
			montoConv.toFixed(2);
			MontoInic.toFixed(2);
			if(MontoInic != montoConv){ 
				//alert("monto ini "+MontoInic+ " monto actual"+montoConv);
				consultaComisionAper();
			}
	
		}
	
		if(numCredito != 0){
			validaMontoCredito(this.id);
		}
 		agregaFormatoControles('formaGenerica');
		
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
	
	 $('#fechaInicio').bind('keyup',function(e){
	//	agregaFormatoControles('formaGenerica');			
 	});
 		 
 $('#fechaInicio').blur(function() {
		//agregaFormatoControles('formaGenerica');	
	 	var fechaAplicacion = parametroBean.fechaAplicacion;
		var fechInicio =  $('#fechaInicio').val();
		if ( fechInicio < fechaAplicacion &&  fechInicio != '' ){
			alert('La fecha de Inicio no puede ser inferior a la del sistema');
			 $('#fechaInicio').focus();
			 $('#fechaInicio').select();				
		}
	});
	
	 $('#fechaVencimien').bind('keyup',function(e){
	 	var fechaAplicacion = parametroBean.fechaAplicacion;
		var fechInicio =  $('#fechaInicio').val();
		if ( fechInicio < fechaAplicacion ){
			alert('La fecha de Inicio no puede ser inferior a la del sistema');
			 $('#fechaInicio').focus();		
			 $('#fechaInicio').select();		
		}
	});
	
	 $('#fechaVencimien').blur(function() {
	 	var fechaAplicacion = parametroBean.fechaAplicacion;
		var fechInicio =  $('#fechaInicio').val();
		if ( fechInicio < fechaAplicacion &&  fechInicio != '' ){
			alert('La fecha de Inicio no puede ser inferior a la del sistema');
			 $('#fechaInicio').focus();
			 $('#fechaInicio').select();				
		}
		
	});
	
	
function convertDate(stringdate)
{ 
    // Internet Explorer does not like dashes in dates when converting, 
    // so lets use a regular expression to get the year, month, and day 
    var DateRegex = /([^-]*)-([^-]*)-([^-]*)/;
    var DateRegexResult = stringdate.match(DateRegex);
    var DateResult;
    var StringDateResult = "";
 
    // try creating a new date in a format that both Firefox and Internet Explorer understand
    try
    {
        DateResult = new Date(DateRegexResult[2]+"/"+DateRegexResult[3]+"/"+DateRegexResult[1]);
    } 
    // if there is an error, catch it and try to set the date result using a simple conversion
    catch(err) 
    { 
        DateResult = new Date(stringdate); 
    } 

    // format the date properly for viewing
    StringDateResult = (DateResult.getMonth()+1)+"/"+(DateResult.getDate()+1)+"/"+(DateResult.getFullYear());

    return StringDateResult;
}	
	
	
	$('#calcInteresID').bind('keyup',function(e){ 
		var fechInicio =  $('#fechaInicio').val();
		var fechaVenForm = $('#fechaVencimien').val(); 
		
		convertDate(fechInicio);
		convertDate(fechaVenForm);

				if(fechaVenForm < fechInicio){ 
					alert("Fecha de Inicio debe ser superior a la de Vencimiento  ");
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
					alert("Fecha de Vencimiento debe ser superior a la de Inicio");
					 $('#fechaVencimien').focus();
					 $('#fechaVencimien').select();
				}
	}); 	

	$('#cuentaID').blur(function() {
		esTab=true;
  		consultaCta(this.id);
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
				required: true,
				numeroMayorCero: true
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
				required: 'Especificar Monto',
				numeroMayorCero: 'Cantidad Incorrecta'
			}
			
		}		
	});
	
	$('#formaGenerica2').validate({
		rules: {
			porcentaje: 'required'
		},
		 
		messages: {
			porcentaje: 'Especifique Concepto'
		}		
	}); 
	
	
	//------------ Validaciones de Controles -------------------------------------
	
		function validaCredito(control) {
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) && esTab){
			
			if(numCredito=='0'){ 
				$('#clienteInstitucion').val(parametroBean.clienteInstitucion); 
				$('#cuentaInstitucion').val(parametroBean.cuentaInstitucion);   
				habilitaBoton('agrega', 'submit');	
				$('#contenedorFondeo').hide();
				deshabilitaBoton('modifica', 'submit');
				inicializaForma('formaGenerica','creditoID' )
				consultaParametros();
				$('#monedaID').val('-1');
				estableceParametrosKubo();
				quitaParametrosKubo();
			
			} else { 
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				var creditoBeanCon = { 
  				'creditoID':$('#creditoID').val()
				};
				creditosServicio.consulta(catTipoConsultaCredito.principal,creditoBeanCon,function(credito) {
						if(credito!=null){ 
							dwr.util.setValues(credito);
													 	
							deshabilitaBoton('agrega', 'submit');
							habilitaBoton('modifica', 'submit');
							esTab=true;
							
							$('#producCreditoID').val(credito.producCreditoID);
							consultaProducCredito('producCreditoID');
							$('#tasaFija').val(credito.tasaFija);	
							consultaCliente('clienteID'); 
							
							//consultaSaldoLinea('lineaFondeo'); 
							consultaInstituFondeo('institFondeoID');	
							consultaLineaCredito('lineaCreditoID');	
							ValidaCalcInteres('calcInteresID');
							
							esTab=true;  
							$('#solicitudCreditoID').val(credito.solicitudCreditoID);
							consultaSolicitudCred('solicitudCreditoID');
							$('#cuentaID').val(credito.cuentaID);
							consultaCta('cuentaID');
							if(credito.tasaBase !=0){
								consultaTasaBase('tasaBase');///	
							}	 
							
								if(credito.fechaInhabil=='S'){				
										$('#fechaInhabil').attr("checked","1") ;
										$('#fechaInhabil2').attr("checked",false) ;
									}   
									else{
									if(credito.fechaInhabil=='A')
										$('#fechaInhabil2').attr("checked","1") ;
										$('#fechaInhabil').attr("checked",false) ;
								}
								 
								if(credito.ajusFecExiVen=='S'){							
										$('#ajusFecExiVen').attr("checked","1") ;
										$('#ajusFecExiVen2').attr("checked",false) ;
									} 
									else{
									if(credito.ajusFecExiVen=='N') 
										$('#ajusFecExiVen').attr("checked",false) ;
										 $('#ajusFecExiVen2').attr("checked","1") ;
										
								} 
								
								if(credito.calendIrregular=='S'){							
										$('#calendIrregular').attr("checked","1") ;
										deshabilitaControl('tipoPagoCapital');
										deshabilitaControl('tipoPagoCapital2');
										deshabilitaControl('tipoPagoCapital3');

								}
								else{ 
									if(credito.calendIrregular=='N')	
										$('#calendIrregular').attr("checked",false) ;
										$('#tipoPagoCapital').removeAttr('disabled');
										$('#tipoPagoCapital2').removeAttr('disabled');
										$('#tipoPagoCapital3').removeAttr('disabled');
				
									}
									
								if(credito.ajusFecUlVenAmo=='S'){		
										$('#ajusFecUlVenAmo').attr("checked","1") ;
										$('#ajusFecUlVenAmo2').attr("checked",false) ;
									}  
									else{ 
									if(credito.ajusFecUlVenAmo=='N')
										$('#ajusFecUlVenAmo').attr("checked",false) ;
										$('#ajusFecUlVenAmo2').attr("checked","1") ;

								}
									
								if(credito.diaPagoInteres=='F'){		
										$('#diaPagoInteres').attr("checked","1") ;
										$('#diaPagoInteres2').attr("checked",false) ;
									}  
									else{
									if(credito.diaPagoInteres=='A') 
										$('#diaPagoInteres2').attr("checked","1") ;
										$('#diaPagoInteres').attr("checked",false) ;
								}	
								
								if(credito.diaPagoCapital=='F'){		
										$('#diaPagoCapital').attr("checked","1") ;
										$('#diaPagoCapital2').attr("checked",false) ;
									}  
									else{ 
									if(credito.diaPagoCapital=='A') 
										$('#diaPagoCapital2').attr("checked","1") ;
										$('#diaPagoCapital').attr("checked",false) ;
								}		
								 
								if(credito.tipoPagoCapital=='C'){				
										$('#tipoPagoCapital').attr("checked","1") ;
										$('#tipoPagoCapital2').attr("checked",false) ;
										$('#tipoPagoCapital3').attr("checked",false) ;
									}  
									else
									if(credito.tipoPagoCapital=='I'){
										$('#tipoPagoCapital').attr("checked",false) ;
										$('#tipoPagoCapital2').attr("checked","1") ;
										$('#tipoPagoCapital3').attr("checked",false) ;
									}		 
									else
									if(credito.tipoPagoCapital=='L'){
										$('#tipoPagoCapital').attr("checked",false) ;
										$('#tipoPagoCapital2').attr("checked",false) ;
										$('#tipoPagoCapital3').attr("checked","1") ;
									}		 					
										validaTipoPago();
							$('#producCreditoID').val(credito.producCreditoID);
							
							deshabilitaBoton('agrega', 'submit');
							habilitaBoton('modifica', 'submit');
							var solicitud = $('#solicitudCreditoID').val(); 
							/*if(solicitud != '0' ){
								var nTransac = $('#numTransacSim').val(); 
								if(nTransac != '' || nTransac != 0){ 
									deshabilitaBoton('modifica');   
								}
							}*/ 
							var status = credito.estatus;
							if(status != 'I'){
							deshabilitaBoton('modifica'); 
							deshabilitaBoton('agrega'); 
							}
							 montoOriginal = credito.montoCredito; // para comision apert
								MontoIni =montoOriginal;
						}else{
							
							alert("No Existe el Credito");
							deshabilitaBoton('modifica', 'submit');
   						deshabilitaBoton('agrega', 'submit');
								$('#creditoID').focus();
								$('#creditoID').select();	
																			
							}
				});
						
			}
												
		}
	}
	
	 
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		
		
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipConPrincipal,numCliente,function(cliente) {
						if(cliente!=null){
							$('#clienteID').val(cliente.numero)							
							$('#nombreCliente').val(cliente.nombreCompleto);
							$('#pagaIVACte').val(cliente.pagaIVA);
							$('#sucursalCte').val(cliente.sucursalOrigen);
							 
							
						}else{
							alert("Cliente No Valido");
							$('#clienteID').focus();
							$('#clienteID').select();	
						}    	 						
				});
			} 
		}
		
	
		
		function consultaInstituFondeo(idControl) {
		var jqInst = eval("'#" + idControl + "'");
		var numInst = $(jqInst).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		
		if(numInst != '' && !isNaN(numInst) && esTab){
			var instFondeoBeanCon = { 
  				'institutFondID':numInst
				}; 
				fondeoServicio.consulta(catTipoConsultaCredito.principal,instFondeoBeanCon,function(instFondeo) {
						if(instFondeo!=null){
							$('#nombreInst').val(instFondeo.nombreInstitFon);
																			
						}else{
							
							alert("No Existe la Institucion de Fondeo");												
							}
				});
			}
		}
		
		
		function ValidaCalcInteres(idControl) {
        validaTipoPago();
		var jqCalc = eval("'#" + idControl + "'");
		var numCalc = $(jqCalc).val();	 
		var cal=  $('#calcInteresID');
		
			if(numCalc!=1){ 
			deshabilitaControl('tipoPagoCapital');
			$('#tipoPagoCapital').attr("checked",false) ;
			}else{
			habilitaControl('tipoPagoCapital');
			//$('#tipoPagoCapital').attr("checked","1");
			} 
			
			if(numCalc==1){
			$('#tasaFija').removeAttr('disabled');
			
			deshabilitaControl('tasaBase');
			deshabilitaControl('sobreTasa');
			deshabilitaControl('pisoTasa');
			deshabilitaControl('techoTasa');
		   $('#tasaBase').val('');
 			$('#sobreTasa').val('');
 			$('#pisoTasa').val(''); 
			$('#techoTasa').val('');
			habilitaControl('tipoPagoCapital');
		//	$('#tipoPagoCapital').attr("checked","1");
			}
			else{
			deshabilitaControl('tipoPagoCapital'); 
			$('#tipoPagoCapital').attr("checked",false) ;
			$('#tasaFija').val('');
			}  
			if(numCalc==2){
			 $('#tasaBase').removeAttr('disabled');
			 $('#sobreTasa').removeAttr('disabled');
 			 $('#pisoTasa').removeAttr('disabled');
  			 $('#techoTasa').removeAttr('disabled');
			deshabilitaControl('tasaFija');
			deshabilitaControl('pisoTasa');
			deshabilitaControl('techoTasa');
			}
			
			if(numCalc==3){
			 $('#tasaFija').removeAttr('disabled');
			 $('#pisoTasa').removeAttr('disabled');
 			 $('#techoTasa').removeAttr('disabled');
			 deshabilitaControl('tasaFija');
		    deshabilitaControl('tipoPagoCapital');
			$('#tipoPagoCapital').attr("checked",false) ;
			}
			
		}
		
		 
		function validaTipoPago() { 
			if($('#tipoPagoCapital').is(':checked')){ //  alert('crec');
				 deshabilitaControl('frecuenciaInt');  
				//checar debe ser igual en crecientes que el capital$('#frecuenciaInt').val('1'); 
				deshabilitaControl('diaPagoInteres'); 
				deshabilitaControl('diaPagoInteres2'); 
				$('#diaPagoInteres2').attr("checked",false);  
				$('#diaPagoInteres').attr("checked",false);
				deshabilitaControl('diaMesInteres');    
				//$('#diaMesInteres').val(''); 
        } else 
        	if($('#tipoPagoCapital2').is(':checked')){  // alert('iiiiguales');
	 			habilitaControl('frecuenciaInt');     
                } 
 			else
        	if($('#tipoPagoCapital3').is(':checked')){  // alert('libres');
				 habilitaControl('frecuenciaInt');       
          }
                
	 }
	 
		
		
		function validaFrecuenciaInt(idControl) {
			var jqfrecInt = eval("'#" + idControl + "'");
			var frecInt = $(jqfrecInt).val();	 
				if(frecInt=='P'){ 
				habilitaControl('periodicidadInt');
				deshabilitaControl('diaPagoInteres'); 
				deshabilitaControl('diaPagoInteres2'); 
				$('#diaPagoInteres2').attr("checked",false);  
				$('#diaPagoInteres').attr("checked",false); 
				deshabilitaControl('diaMesInteres'); 
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
		
		function validaFrecuenciaCap(idControl) { 
			var jqfrecCap = eval("'#" + idControl + "'");
			var frecCap = $(jqfrecCap).val();
			var tp2= $('#tipoPagoCapital2').val();
			var tp = $('#tipoPagoCapital').val(); 
			var frecInt = $('#frecuenciaInt').val();//alert(tp2);
				if(tp=='C'){
					
					deshabilitaControl('diaPagoCapital'); 
					deshabilitaControl('diaPagoCapital2');
					$('#frecuenciaInt').val(frecCap);
					frecInt= $('#frecuenciaInt').val();

					
				 }else{ 
				/* $('#tipoPagoCapital').val(tp);*/  
				$('#tipoPagoCapital').val('');  
				 } 
				  
				if(frecCap=='P'){
					habilitaControl('periodicidadCap');
					deshabilitaControl('diaPagoCapital');
					deshabilitaControl('diaPagoCapital2');
					$('#diaPagoCapital2').attr("checked",false);
					$('#diaPagoCapital').attr("checked",false);
					deshabilitaControl('diaMesCapital'); 
					$('#diaMesCapital').val('');   
				}else{
					deshabilitaControl('periodicidadCap'); 
					habilitaControl('diaPagoCapital'); 
					habilitaControl('diaPagoCapital2');
					$(':radio').change(function () {
					 if($('#diaPagoCapital2').is(':checked')){  
//                if($('#diaPagoCapital2').checked){  
                  habilitaControl('diaMesCapital');         
                
                } else{
            
                  deshabilitaControl('diaMesCapital');  
						$('#diaMesCapital').val('0');        
                }
        		});		
				} 
				
				if(frecCap == 'S'){
					$('#periodicidadCap').val('7');
					$('#diaPagoCapital').attr("checked","1") ;
				}
				if(frecInt == 'S'){
					$('#periodicidadInt').val('7');
					$('#diaPagoCapital').attr("checked","1") ;
				}
				if(frecCap == 'C'){
					$('#periodicidadCap').val('14');
					$('#diaPagoCapital').attr("checked","1") ;
				}	
				if(frecInt == 'C'){
					$('#periodicidadInt').val('14');
					$('#diaPagoCapital').attr("checked","1") ;
				}
				if(frecCap == 'Q'){
					$('#periodicidadCap').val('15');
					$('#diaPagoCapital').attr("checked","1") ;
				}
				if(frecInt == 'Q'){
					$('#periodicidadInt').val('15');
					$('#diaPagoCapital').attr("checked","1") ;
				}	
				if(frecCap == 'M'){
					$('#periodicidadCap').val('30');
				}
				if(frecInt == 'M'){
					$('#periodicidadInt').val('30');
				}	
				if(frecCap == 'B'){
					$('#periodicidadCap').val('60');
				}	
				if(frecInt == 'B'){
					$('#periodicidadInt').val('60');
				}	
				if(frecCap == 'T'){
					$('#periodicidadCap').val('90');
				}	
				if(frecInt == 'T'){
					$('#periodicidadInt').val('90');
				}
				if(frecCap == 'R'){
					$('#periodicidadCap').val('120');
				}
				if(frecInt == 'R'){
					$('#periodicidadInt').val('120');
				}	
				if(frecCap == 'E'){
					$('#periodicidadCap').val('180');
				}
				if(frecInt == 'E'){
					$('#periodicidadInt').val('180');
				}	
				if(frecCap == 'A'){
					$('#periodicidadCap').val('360');
				}
				if(frecInt == 'A'){
					$('#periodicidadInt').val('360');
				}		
				
		}	
		
		
		function consultaSolicitudCred(idControl) {  
	 
		var jqSolCred = eval("'#" + idControl + "'");
		var numSolicitud = $(jqSolCred).val();	
		var tipConAlta = 3;		
		esTab=true;  
 
		var SolicitudBeanCon = { 
  				'solicitudCreditoID':numSolicitud,
				};
		setTimeout("$('#cajaLista').hide();", 200);	 
			 
		if(numSolicitud != '' && !isNaN(numSolicitud) && esTab){
			solicitudCredServicio.consulta(tipConAlta,SolicitudBeanCon,function(solicitudCred) { 
				  
						if(solicitudCred!=null){
							if(solicitudCred.creditoID != 0){
								alert("La Solicitud ya esta ligada  al Credito: "+solicitudCred.creditoID);
								$('#solicitudCreditoID').focus();
								deshabilitaBoton('grabaSF');   
							}
					
							 
							var status = solicitudCred.estatus;
							if(status !='D'){ 
								$('#grabaSF').show();
								esTab=true;  
									$('#montoCredito').val(solicitudCred.montoAutorizado);	
									$('#montoCredito').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});					
									$('#monedaID').val(solicitudCred.monedaID); 
									$('#fechaInicio').val(solicitudCred.fechaIniCre);    
									$('#fechaVencimien').val(solicitudCred.fechaVenCre); 
									$('#calcInteresID').val(solicitudCred.calInt); 
									$('#tasaFija').val(solicitudCred.tasaActiva); 
									$('#producCreditoID').val(solicitudCred.productoCreditoID);
									$('#factorMora').val(solicitudCred.factorMora);
									$('#clienteID').val(solicitudCred.clienteID); 
									$('#montoComision').val(solicitudCred.montoComApert); 
									$('#IVAComApertura').val(solicitudCred.ivaComApert); 
									
									consultaClienteSolici('clienteID');
									//consultaCliente('clienteID');
									consultaProducCredito('producCreditoID'); 
									//$('#lineaCreditoID').val('0');
									deshabilitaControl('lineaCreditoID');  
									deshabilitaControl('clienteID');
									$('#producCreditoID').attr('disabled',true);
									deshabilitaControl('producCreditoID');
									deshabilitaControl('montoCredito');
									 
									deshabilitaControl('fechaInicio');
									deshabilitaControl('fechaVencimien');
									deshabilitaControl('tasaFija');
									deshabilitaControl('frecuenciaCap');
									deshabilitaControl('diaPagoCapital');
									deshabilitaControl('diaPagoCapital2');	
	 
									estableceParametrosKubo();
									 if(solicitudCred.fechaHabilT=='S'){		 	 	
												$('#fechaInhabil').attr("checked","1") ;
												$('#fechaInhabil2').attr("checked",false) ;
											}  
									else{  
										if(solicitudCred.fechaHabilT=='A') 
												$('#fechaInhabil2').attr("checked","1") ;
												$('#fechaInhabil').attr("checked",false) ;
									}
									if(solicitudCred.ajuFecExVen=='S'){			 	 			
												$('#ajusFecExiVen').attr("checked","1") ;
												$('#ajusFecExiVen2').attr("checked",false) ;
											} 
									else{ 
										if(solicitudCred.ajuFecExVen=='N') 
												$('#ajusFecExiVen2').attr("checked","1") ; 
												$('#ajusFecExiVen').attr("checked",false) ;
									} 
									/*if(solicitudCred.ajFecUlAmoVen=='S'){		
												$('#ajusFecUlVenAmo').attr("checked","1") ; 
												$('#ajusFecUlVenAmo2').attr("checked",false) ;
											}  
									else{ 
										if(solicitudCred.ajFecUlAmoVen=='N')
												$('#ajusFecUlVenAmo2').attr("checked","1") ;
												$('#ajusFecUlVenAmo').attr("checked",false) ; 
									} */ 
									if(solicitudCred.tipoPagCapital=='C'){				 
												$('#tipoPagoCapital').attr("checked","1") ;
												$('#tipoPagoCapital2').attr("checked",false) ;
												$('#tipoPagoCapital3').attr("checked",false) ;
											}   
									else  
										if(solicitudCred.tipoPagCapital=='I'){ 
												$('#tipoPagoCapital').attr("checked",false) ;  
												$('#tipoPagoCapital2').attr("checked","1") ;
												$('#tipoPagoCapital3').attr("checked",false) ;
										}		
									else 
										if(solicitudCred.tipoPagCapital=='L'){
												$('#tipoPagoCapital').attr("checked",false) ;
												$('#tipoPagoCapital2').attr("checked",false) ;
												$('#tipoPagoCapital3').attr("checked","1") ; 
										}	  
									$('#frecuenciaCap').val(solicitudCred.periodicidad);
									$('#frecuenciaInt').val(solicitudCred.periodicidad);
										 validaTipoPago();
										deshabilitaControl('tasaBase');  
										deshabilitaControl('sobreTasa'); 
										deshabilitaControl('pisoTasa'); 
										deshabilitaControl('techoTasa'); 
										var tasaF =	$('#tasaFija').val();
										$('#tasa').val(tasaF);
										$('#porcentaje').val(solicitudCred.porcentSolCre);
										$('#porcentaje').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
										$('#monto').val(solicitudCred.montoAfondear);
										$('#monto').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
										var solicitud =$('#solicitudCreditoID').val();
										var moned =$('#monedaID').val();
										var fechaI =$('#fechaInicio').val(); 
										var cuenta =$('#cuentaID').val();  
										$('#solCredID').val(solicitud);    
										$('#moneda').val(moned); 
				   					$('#fechaIni').val(fechaI); 
				   					$('#cuenta').val(cuenta); 
										$('#diaPagoCapital2').attr("checked","1") ; 	
										var diaPag = $('#diaPagoInteres2').val();
								 		var frec = $('#frecuenciaCap').val();

								  		if(frec == 'M' ){
								  			if(diaPag == 'A'){ 
								  	
								  				var fe=parametroBean.fechaAplicacion;
												var fech =fe.substring(8,10);
												$('#diaMesCapital').val(fech); 
											}
										} 	
											
										fondeoInver();  
										var porcentajeFon = parseFloat(solicitudCred.porcentSolCre); 
										if(porcentajeFon == 0.00){ 
											deshabilitaBoton('grabaSF');   
										} 
										if(porcentajeFon!= 0.00){  
											deshabilitaBoton('agrega');   
										}
								}else{  
									var tasaF =	$('#tasaFija').val();
									var porcentajeFon = parseFloat(solicitudCred.porcentSolCre);  
									$('#tasa').val(tasaF);
									$('#porcentaje').val(porcentajeFon);
									$('#monto').val(solicitudCred.montoAfondear);
									if(porcentajeFon == 0.00){ 
										deshabilitaBoton('grabaSF');   
									}
									/* var status = $('#estatus').val();
									if(status == 'I'){  
									alert("La solicitud de credito ya fue desembolsada");	
									deshabilitaControl('tasaBase');
									$('#solicitudCreditoID').focus();
									$('#solicitudCreditoID').select();
									}*/
										 
							}
				
							
						}else{  	 

							 if(numSolicitud == '0' || numSolicitud =='' ){
									$('#fechaInicio').datepicker({
													changeMonth: true,
													changeYear: true,
											 		dateFormat: 'yy-mm-dd' ,
													minDate: new Date(1900, 1 - 1, 1), 
													yearRange: '-100:+10'
									});
									 $('#fechaInicio').datepicker($.datepicker.regional['es']);
									 $('#fechaVencimien').datepicker({
													changeMonth: true,
													changeYear: true,
													dateFormat: 'yy-mm-dd' ,
													minDate: new Date(1900, 1 - 1, 1), 
													yearRange: '-100:+10'
												}); 
									 $('#fechaVencimien').datepicker($.datepicker.regional['es']);
										 habilitaControl('clienteID'); 
			 							 habilitaControl('lineaCreditoID'); 
			 							
		 									var credito =  $('#creditoID').val(); 
											if(credito == '0'){
										 		inicializaForma('formaGenerica','creditoID' );
										 	} 
										 consultaParametros();
										 $('#clienteID').focus();
										 $('#contenedorFondeo').html("");
										 $('#contenedorFondeo').hide();
										  habilitaControl('fechaVencimien');
											var tasaF = $('#tasaFija').val();  
										 	var montoFondear = $('#montoCredito').val(); 
											$('#tasa').val(tasaF);
											$('#porcentaje').val('100.00');
											$('#monto').val(montoFondear);
											$('#grabaSF').hide();
											estableceParametrosKubo(); 
										 	quitaParametrosKubo();
							 }else{  
							 
								alert("No Existe la solicitud");
									$('#solicitudCreditoID').focus();
									$('#solicitudCreditoID').select();
							  		habilitaControl('tasaBase'); 
									habilitaControl('sobreTasa'); 
									habilitaControl('pisoTasa'); 
									habilitaControl('techoTasa');
								} 
						}    	 						
				});
			}
		 
		} 
 
	
		function consultaMoneda() {			
  			dwr.util.removeAllOptions('monedaID'); 
			
			dwr.util.addOptions('monedaID', {0:'Seleciona'});
			monedasServicio.listaCombo(3, function(monedas){
			dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
			});
		}
	 
	 
	function consultaLineaCredito(idControl) {
		quitaParametrosKubo();
		var jqLinea  = eval("'#" + idControl + "'");
		var lineaCred = $(jqLinea).val();	
		
		var lineaCreditoBeanCon = {
			'lineaCreditoID'	:lineaCred
		}; 

		setTimeout("$('#cajaLista').hide();", 200);
		if(lineaCred=='0' || lineaCred==''){
			$('#producCreditoID').attr('disabled',false);
			 $('#producCreditoID').focus();
			 $('#cuentaID').attr('disabled',false);
 
			$('#saldoLineaCred').val("");
			  var credito =  $('#creditoID').val();  
			 if(credito == '0'){
				 $('#producCreditoID').val(""); 
				 $('#nombreProd').val("");
				 $('#clasificacion').val(""); 
				 $('#DescripClasific').val("");
				 $('#cuentaID').val(""); 
				 $('#saldoLineaCred').val("");	
			}
			 
			 habilitaControl('fechaVencimien'); 
			 habilitaControl('montoCredito'); 
			 habilitaControl('fechaInicio'); 

			} 
			
		if(lineaCred != '' && !isNaN(lineaCred) && esTab){

			lineasCreditoServicio.consulta(catTipoConsultaCredito.principal,lineaCreditoBeanCon,function(linea) {
					if(linea!=null){
						esTab=true; 
						var cte = parseInt(linea.clienteID);
						var cliente = $('#clienteID').asNumber();
						if(cte != cliente){
							alert("La linea no corresponde al cliente");
							$('#lineaCreditoID').focus();
							$('#lineaCreditoID').val("");
							//$('#saldoLineaCred').val('0');	

 						}else{
							$('#producCreditoID').val(linea.productoCreditoID);
							$('#cuentaID').val(linea.cuentaID); 
							$('#monedaID').val(linea.monedaID);
							deshabilitaControl('cuentaID');
							consultaProducCredito('producCreditoID');
							$('#saldoLineaCred').val(linea.saldoDisponible);	
							$('#saldoLineaCred').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
							var linea = $('#lineaCreditoID').val();
							deshabilitaControl('producCreditoID');
						}
						
					}	
					else
						if(lineaCred!='' || lineaCred != '0' )	{					
							alert("No Existe la linea");
							$('#lineaCreditoID').focus();		
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
							alert("No Existe la tasa base");
							$('#tasaBaseID').focus();
							$('#tasaBaseID').selected();								
							}
				});
			}									
		}
		
	function consultaProducCredito(idControl) {  
		var jqProdCred  = eval("'#" + idControl + "'");
		var ProdCred = $(jqProdCred).val();			
		var ProdCredBeanCon = {
  			'producCreditoID':ProdCred 
		}; 
		setTimeout("$('#cajaLista').hide();", 200);
		var linea =$('#lineaCreditoID').val();
		 

			if(ProdCred != '' && !isNaN(ProdCred) && esTab){		
				productosCreditoServicio.consulta(catTipoConsultaCredito.principal,ProdCredBeanCon,function(prodCred) {
					if(prodCred!=null){
						esTab=true;		
						$('#nombreProd').val(prodCred.descripcion);
						$('#clasificacion').val(prodCred.clasificacion);
						$('#factorMora').val(prodCred.factorMora);
						// consultaClasificCredito('clasificacion');
						
						consultaDescripClaRepReg('clasificacion'); 
			 	 		
					}else{							
						alert("No Existe el Producto de Credito");
						$('#producCreditoID').focus();
						$('#producCreditoID').select();																					
					}
			});
			}				 					
	}
	
	
	
	function consultaComisionAper() { 
		var ProdCred = $('#producCreditoID').val();		
		var ProdCredBeanCon = {
  			'producCreditoID':ProdCred 
		}; 
		setTimeout("$('#cajaLista').hide();", 200);
			if(ProdCred != '' && !isNaN(ProdCred) && esTab){	
				productosCreditoServicio.consulta(catTipoConsultaCredito.principal,ProdCredBeanCon,function(prodCred) {
					if(prodCred!=null){
						esTab=true;		
						quitaFormatoControles('formaGenerica');
						var solCred = $('#solicitudCreditoID').val();
						
						if (solCred == "" ||solCred == 0 ){
							var tipoComAper = prodCred.tipoComXapert;
							var porcentaje = prodCred.montoComXapert;
							var formaCobro = prodCred.formaComApertura;
							quitaFormatoControles('formaGenerica');
							var montoCre = $('#montoCredito').val();
							
						// si el tipo es porcentaje hace el calculo del monto y por deduccion
							if(formaCobro == 'D'){ 
								if(tipoComAper == 'P'){
									var montoComis = montoCre * (porcentaje/100);
									 $('#montoComision').val(montoComis);				
										consultaIVASucursal2();
										MontoIni = montoCre; 
								} 
								if(tipoComAper == 'M'){
									 $('#montoComision').val(porcentaje);
										consultaIVASucursal2();
										MontoIni = montoCre; 
								} 
							}	
							// si el tipo es monto y forma de cobro por Financiamiento 
							if(formaCobro == 'F'){
						 
								if(tipoComAper == 'P'){
									var montoComis = montoCre * (porcentaje/100);
									montoComis.toFixed(2); 
									$('#montoComision').val(montoComis);
									
									 
									var montoCredConv = parseFloat(montoCre);
									montoCredConv.toFixed(2); 
									var montoCredAjus= (montoCredConv + montoComis);
									$('#montoCredito').val(montoCredAjus);
									MontoIni=  montoCredAjus;
									consultaIVASucursal();
									
									/*var porcForm = 1 -(porcentaje/100);
									var montoCredAjus= (montoCre/porcForm);
									var montoComAjus = montoCredAjus *(porcentaje/100);*/
									
									
									
										
								}	
								if(tipoComAper == 'M'){
									var montoCreConv = parseFloat(montoCre); 
									var porcenConv = parseFloat(porcentaje);
 					
									var montoCredAjus= (montoCreConv + porcenConv); 
									$('#montoCredito').val(montoCredAjus);
									$('#montoComision').val(porcentaje);
										MontoIni =montoCredAjus;
									consultaIVASucursal();
								}								 
							}
						}
							
					}	 				
			});
			}	
	}


		function consultaIVASucursal() {
			var numSucursal = $('#sucursalCte').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numSucursal != '' && !isNaN(numSucursal) && esTab){
				
				sucursalesServicio.consultaSucursal(catTipoConsultaCredito.principal,numSucursal,function(sucursal) { 
						if(sucursal!=null){
							var pIVA = $('#pagaIVACte').val();
							
							var iva = sucursal.IVA;
							
							var monto = $('#montoComision').val();	
							if(pIVA == 'S'){
								var ivaCalc =	(monto	* iva);
								$('#IVAComApertura').val(ivaCalc);
								var montoCredito = $('#montoCredito').val();
								var ivaConver = parseFloat(ivaCalc);
								ivaConver.toFixed(2); 
								var montoConver = parseFloat(montoCredito); 	

								var MontoAjust = (montoConver + ivaConver);

								 $('#montoCredito').val(MontoAjust);
								 MontoIni = MontoAjust; // para verficar despues si cmabio el monto 
								  				
							}	
							if(pIVA == 'N'){
								$('#IVAComApertura').val('0');
							}		
						} 
					});
			}
		}


// Para cuando el tipo de cobro es por deduccion no suma la comision ni el iva
		function consultaIVASucursal2() {
		var numSucursal = $('#sucursalCte').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numSucursal != '' && !isNaN(numSucursal) && esTab){
				
				sucursalesServicio.consultaSucursal(catTipoConsultaCredito.principal,numSucursal,function(sucursal) { 
						if(sucursal!=null){
							var pIVA = $('#pagaIVACte').val();
							
							var iva = sucursal.IVA;
							var monto = $('#montoComision').val();	
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
		
		
	
	function validaMontoCredito(control) {
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
				var creditoBeanCon = { 
  				'creditoID':$('#creditoID').val()
				}; 
				creditosServicio.consulta(catTipoConsultaCredito.principal,creditoBeanCon,function(credito) {
						if(credito!=null){ 
						
							quitaFormatoControles('formaGenerica');
							var monto = $('#montoCredito').val();	
							if(MontoIni != monto){
								esTab=true;
								montoOriginal= monto; 
								consultaComisionAper(); 
								
							}
						}	
					
				});
	}
			 			
						
						
							
		
	
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

						
						esTab=true;							
					}else{							
						alert("No Existe la Clasificación");
						$('#clasificacion').focus();
						$('#clasificacion').select();																			
					}
				});
			}
			
		}

 consultaParametros();
   
	function consultaParametros(){
	var credito = $('#creditoID').val(); 
		if(credito == 0){
		$('#fechaInicio').val(parametroBean.fechaSucursal);
		}   
   }   
   
   
		
	function simulador(){	
		var params = {};
		var valDiaPago=false;
		if($('#calendIrregular').is(':checked')){ // Anterirormente validaba $('#tipoPagoCapital4').is(':checked')
		///alert("calend");
			mostrarGridLibres();
		}
		else{
			 
			//alert("otro tipo");
			quitaFormatoControles('formaGenerica');
				
			if($('#calcInteresID').val()==1 ) {
				if($('#tipoPagoCapital').is(':checked')){
					tipoLista=1;
					//alert(tipoLista);
				}
			}
			
			if($('#calcInteresID').val()==1 ) {
				if($('#tipoPagoCapital2').is(':checked')){
					tipoLista=2;
					//alert(tipoLista);
				}
			}else{	 
				if($('#tipoPagoCapital2').is(':checked')){
					tipoLista=4;
					//alert(tipoLista);
				}		
			}		
			
			
			if($('#calcInteresID').val()==1 ) {
				if($('#tipoPagoCapital3').is(':checked')){
					tipoLista=3;
					//alert(tipoLista);
				}
			}else{	
				if($('#tipoPagoCapital3').is(':checked')){
					tipoLista=5;
					//alert(tipoLista); 
				}		
			}		
			
			params['tipoLista'] = tipoLista; 
		
			if(tipoLista == 1){ 
				if($('#frecuenciaCap').val() =='M' || $('#frecuenciaCap').val() =='B' || $('#frecuenciaCap').val() =='T' 
					|| $('#frecuenciaCap').val() =='R'|| $('#frecuenciaCap').val() =='E'){
									//alert('entra validacion');
						////aqui tu validacion
					if(($('#diaPagoCapital2').is(':checked')) != true &&($('#diaPagoCapital').is(':checked')) != true ){
						alert("Debe Seleccionar un dia de pago.");
						valDiaPago =false;
					}	
					else { 
						if(($('#diaPagoCapital2').is(':checked')) == true ){
							if($('#diaMesCapital').val() ==''||$('#diaMesCapital').val() ==' '|| $('#diaMesCapital').val() ==null || $('#diaMesCapital').val() =='0'){
								alert("Especifique dia del mes.");
								valDiaPago =false; 
							}else{
								valDiaPago =true;
							}
						}else{valDiaPago =true;}
					}			
				} 
				else{valDiaPago =true;}
			}else{
				if(tipoLista == 2 ||tipoLista ==3||tipoLista ==4||tipoLista ==5){
					if($('#frecuenciaCap').val() =='M' || $('#frecuenciaCap').val() =='B' || $('#frecuenciaCap').val() =='T' 
							|| $('#frecuenciaCap').val() =='R'|| $('#frecuenciaCap').val() =='E'||
						
							$('#frecuenciaInt').val() =='M' || $('#frecuenciaInt').val() =='B' || $('#frecuenciaInt').val() =='T' 
							|| $('#frecuenciaInt').val() =='R'|| $('#frecuenciaInt').val() =='E'){
														
						if(($('#diaPagoCapital').is(':checked') != true && 
								$('#diaPagoCapital2').is(':checked') != true)||
								($('#diaPagoInteres').is(':checked') != true && 
								$('#diaPagoInteres2').is(':checked') != true)){
								alert('Debe Seleccionar un dia de pago.');
								valDiaPago =false;
						}	
						else {
							if($('#diaPagoCapital2').is(':checked') == true){
								if($('#diaMesCapital').val() ==''||$('#diaMesCapital').val() ==' '|| $('#diaMesCapital').val() ==null || $('#diaMesCapital').val() =='0'){
									alert("Especifique dia del mes capital.");
									valDiaPago =false; 
								}else{
									valDiaPago =true; 
								}
							}else{valDiaPago =true;} 
							if(valDiaPago){
								if($('#diaPagoInteres2').is(':checked')){
									if($('#diaMesInteres').val() ==''||$('#diaMesInteres').val() ==' '|| $('#diaMesInteres').val() ==null || $('#diaMesInteres').val() =='0'){
										alert("Especifique dia del mes Interes.");
										valDiaPago =false; 
									}else{
										valDiaPago =true;
									}
								}else{valDiaPago =true;} 
							}
						}								
					}
					else{valDiaPago =true;}
				}
						 
			}
			
			if(valDiaPago){
		
				if($('#diaPagoCapital').is(':checked')){		 
					pagoFinAni= $('#diaPagoCapital').val();
				}
				if($('#diaPagoCapital2').is(':checked')){				 
					pagoFinAni= $('#diaPagoCapital2').val();
				}
			
			
				if($('#diaPagoInteres').is(':checked')){		 
					pagoFinAniInt= $('#diaPagoInteres').val(); 
				}
				if($('#diaPagoInteres2').is(':checked')){				 
					pagoFinAniInt= $('#diaPagoInteres2').val();
				}
				
			
				if($('#fechaInhabil').is(':checked')){	
					//alert('f1'+$('#fechaInhabil').val());				 
					diaHabilSig= $('#fechaInhabil').val();
				}
				if($('#fechaInhabil2').is(':checked')){ 
				//alert($('f2'+'#fechaInhabil2').val());		
					diaHabilSig= $('#fechaInhabil2').val();
				}
				
				if($('#ajusFecExiVen').is(':checked')){   
					ajusFecExiVen= $('#ajusFecExiVen').val();
				}
				if($('#ajusFecExiVen2').is(':checked')){  	 
					ajusFecExiVen= $('#ajusFecExiVen2').val();
				}
				
				if($('#ajusFecUlVenAmo').is(':checked')){  	 
					ajustaFecAmo= $('#ajusFecUlVenAmo').val();
				}
				if($('#ajusFecUlVenAmo2').is(':checked')){  	 
					ajustaFecAmo= $('#ajusFecUlVenAmo2').val();
				}
				
					//diaPagoInteres2
				//alert("pagoFinAni "+pagoFinAni+" diaHabilSig "+diaHabilSig+" ajustaFecAmo "+ajustaFecAmo+" ajusFecExiVen "+ajusFecExiVen);
				  
				params['montoCredito'] 	= $('#montoCredito').val();
				params['tasaFija']		=  $('#tasaFija').val();
				params['frecuenciaCap'] = $('#frecuenciaCap').val();
				params['frecuenciaInt'] = $('#frecuenciaInt').val();
				params['periodicidadCap'] = $('#periodicidadCap').val(); 
				params['periodicidadInt'] = $('#periodicidadInt').val();
				params['diaPagoCapital'] = pagoFinAni;
				params['diaPagoInteres'] = pagoFinAniInt;
				params['diaMesCapital'] = $('#diaMesCapital').val(); 
				params['diaMesInteres'] = $('#diaMesInteres').val(); 
				params['fechaInicio'] = $('#fechaInicio').val();
				params['fechaVencimien'] = $('#fechaVencimien').val();
				params['producCreditoID'] = $('#producCreditoID').val();
				params['clienteID'] = $('#clienteID').val();
				params['fechaInhabil'] = diaHabilSig;
				params['ajusFecUlVenAmo'] = ajustaFecAmo; 
				params['ajusFecExiVen'] = ajusFecExiVen;
				params['numTransacSim'] = $('#numTransacSim').val();
				params['montoComision'] = $('#montoComision').val();
					 		
				
				params['empresaID'] = parametroBean.empresaID;
				params['usuario'] = parametroBean.numeroUsuario;
				params['fecha'] = parametroBean.fechaSucursal;
				params['direccionIP'] = parametroBean.IPsesion;
				params['sucursal'] = parametroBean.sucursal;
				
			if($('#frecuenciaCap').val()== 1){
				alert("Debe Seleccionar la Frecuencia.");
			}else{
				BloquearPantallaAmortizacion();
			}	
				
				$.post("simPagCredito.htm", params, function(data){
					
					if(data.length >0 || data != null) { 
						
						$('#contenedorSimulador').html(data); 
						 $('#contenedorSimulador').show();
						var valorTransaccion = $('#transaccion').val();
						var cuot = $('#cuotas').val();  
						$('#numTransacSim').val(valorTransaccion); 
						$('#numAmortizacion').val(cuot);
						var jqFechaVen = eval("'#fech'");
						$('#fechaVencimien').val($(jqFechaVen).val()); 	
						var vCat = $('#valorCat').val();  
						$('#cat').val(vCat);  
					}else{
						$('#contenedorSimulador').html("");
						 $('#contenedorSimulador').show();
					}
					$('#contenedorForma').unblock();
				});  
			}
		}
	
	
	}//fin funcion simulador()

  
 // funcion para llenar grid de solicitud de Kubo  
  function fondeoInver(){	
		
	var params = {};
	
	params['solicitudCreditoID'] = $('#solicitudCreditoID').val();
	params['tipoLista'] = 2;
	params['empresaID'] = parametroBean.empresaID; 
	params['usuario'] = parametroBean.numeroUsuario;
	params['fecha'] = parametroBean.fechaSucursal;
	params['direccionIP'] = parametroBean.IPsesion;
	params['sucursal'] = parametroBean.sucursal;
	params['numTransacSim'] = parametroBean.NumTransaccion;	
	
		$.post("fondeoKuboGrid.htm", params, function(data){		
				if(data.length >0) {
					$('#contenedorFondeo').html(data);
					$('#contenedorFondeo').show(); 
				}else{
					$('#contenedorFondeo').html(""); 
					$('#contenedorFondeo').show();
				}
		});
   }


	
});

/*
function  ocultarSimulador(cuotas, numTransaccion) {	
	
	$('#contenedorSimulador').hide();
	if(cuotas != '' || cuotas != null){
		//alert(cuotas);
	$('#numAmortizacion').val(cuotas);	 
	$('#numTransacSim').val(numTransaccion);
		
	var jqFechaVen = eval("'#fechaVencim" +cuotas+ "'");	
	//alert($(jqFechaVen).val());
	if($('#ajusFecUlVenAmo2').is(':checked')){		  	 
		$('#fechaVencimien').val($(jqFechaVen).val());	
			
	}
	}

}	*/
 
function crearMontosCapital(numTransac){	
	var mandar = verificarvacios();
	if(mandar!=1){
		var suma =	sumaCapital(); 
		if(suma !=1){  		  		
	   	quitaFormatoControles('gridDetalle');
			var numAmortizacion = $('input[name=consecutivoID]').length;
			$('#montosCapital').val("");
			for(var i = 1; i <= numAmortizacion; i++){
				controlQuitaFormatoMoneda("capital"+i+"");
				if(document.getElementById("capital"+i+"").value!="0"){
					if(i == 1){ 
					$('#montosCapital').val($('#montosCapital').val() +
												//document.getElementById("consecutivoID"+i+"").value + '-' +
												i + ']' +
												document.getElementById("capital"+i+"").value + ']' +
												numTransac);
					}else{
					$('#montosCapital').val($('#montosCapital').val() + '[' +
												i + ']' +
												document.getElementById("capital"+i+"").value + ']' +
												numTransac);
					}	
				}
			}
			return 2; 
		}
	}
	else{
		alert("Especifique Capital"); 
		return 1; 
	}
}

function verificarvacios(){	
	//quitaFormatoControles('gridDetalle');
	var numAmortizacion = $('input[name=consecutivoID]').length;
	$('#montosCapital').val("");
	 
	for(var i = 1; i <= numAmortizacion; i++){
		// controlQuitaFormatoMoneda("capital"+i+"");
		var valCapital = document.getElementById("capital"+i+"").value;
 		if (valCapital ==" " ){
 			document.getElementById("capital"+i+"").focus();				
			$("capital"+i).addClass("error");	 
 			return 1; 
 		}else{return 2; }
	}
}


function simuladorPagosLibres(numTransac){	
	var mandar = crearMontosCapital(numTransac);
	var diaHabilSig;
	if(mandar==2){   		  		
   	var params = {};
		 
		quitaFormatoControles('formaGenerica');
			
		if($('#calcInteresID').val()==1 ) {
			if($('#tipoPagoCapital').is(':checked')){
				tipoLista=1;
			}
		}
		
		if($('#calcInteresID').val()==1 ) {
			if($('#tipoPagoCapital2').is(':checked')){
				tipoLista=2;
			}
		}else{	
			if($('#tipoPagoCapital2').is(':checked')){
				tipoLista=4;
			}		 
		}		
		
		
		if($('#calcInteresID').val()==1 ) {
			if($('#tipoPagoCapital3').is(':checked')){
				tipoLista=3;
			}
		}else{	
			if($('#tipoPagoCapital3').is(':checked')){
				tipoLista=5;
			}		 
		}
		
		if($('#fechaInhabil').is(':checked')){	
				//alert('f1'+$('#fechaInhabil').val());				 
				diaHabilSig= $('#fechaInhabil').val();
			}
			if($('#fechaInhabil2').is(':checked')){ 
			//alert($('f2'+'#fechaInhabil2').val());		
				diaHabilSig= $('#fechaInhabil2').val();
			}
					 
		params['tipoLista'] = tipoLista;
		params['montoCredito'] 	= $('#montoCredito').val();
		params['tasaFija']		=  $('#tasaFija').val();
		params['producCreditoID'] = $('#producCreditoID').val();
		params['clienteID'] 		= $('#clienteID').val();
		params['fechaInhabil']	= diaHabilSig;
		params['empresaID'] = parametroBean.empresaID;
		params['usuario'] = parametroBean.numeroUsuario;
		params['fecha'] = parametroBean.fechaSucursal;
		params['direccionIP'] = parametroBean.IPsesion;
		params['sucursal'] = parametroBean.sucursal;
		params['numTransaccion'] = numTransac;
		params['numTransacSim'] = $('#numTransacSim').val();
		 
		
		params['montosCapital'] 		= $('#montosCapital').val();
		
		
		$.post("simPagLibresCredito.htm", params, function(data){
			if(data.length >0) {
				$('#contenedorSimulador').html(data); 
				$('#contenedorSimulador').show();
				
				var valorTransaccion = $('#transaccion').val();
				$('#numTransacSim').val(valorTransaccion);
			}else{
				$('#contenedorSimulador').html("");
				$('#contenedorSimulador').show();
			}
				 
		}); 	
	}
}

// funcion para verificar que la suma del capital sea igual que la del monto
function sumaCapital(){
	var jqCapital; 	
	var suma;
	var contador = 1;
	var capital; 
	esTab=true; 
	suma= parseFloat(0);
	 
  	$('input[name=capital]').each(function() {
		jqCapital = eval("'#" + this.id + "'");
		capital= $(jqCapital).asNumber(); 
		if(capital != '' && !isNaN(capital) && esTab){
			suma = parseFloat(suma) + parseFloat(capital);
			contador = contador + 1;	
			$(jqCapital).formatCurrency({
				positiveFormat: '%n', 
				roundToDecimalPlace: 2	
			});		
		}
		else {
			$(jqCapital).val(0);
		}
	});
	 
	if (suma== $('#montoCredito').asNumber() ) {
		 habilitaBoton('continuar', 'submit');
	} 
	else{
		alert("La suma de Capital no es igual al monto"); 
		 deshabilitaBoton('continuar', 'submit');
		 return 1;  
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
		
		quitaFormatoControles('formaGenerica');
			
		if($('#calcInteresID').val()==1 ) {
			if($('#tipoPagoCapital').is(':checked')){
				tipoLista=1;
			} 
		}
		
		if($('#calcInteresID').val()==1 ) {
			if($('#tipoPagoCapital2').is(':checked')){
				tipoLista=2;
			}
		}else{	
			if($('#tipoPagoCapital2').is(':checked')){
				tipoLista=4;
			}		
		}		 
		
		
		if($('#calcInteresID').val()==1 ) {
			if($('#tipoPagoCapital3').is(':checked')){
				tipoLista=3;
			}
		}else{	
			if($('#tipoPagoCapital3').is(':checked')){
				tipoLista=5;
			}		 
		}		
		params['tipoLista'] = tipoLista;
		params['montoCredito'] 	= $('#montoCredito').val();
		params['producCreditoID'] = $('#producCreditoID').val();
		params['clienteID'] 		= $('#clienteID').val();
		 
		params['empresaID'] = parametroBean.empresaID;
		params['usuario'] = parametroBean.numeroUsuario;
		params['fecha'] = parametroBean.fechaSucursal;
		params['direccionIP'] = parametroBean.IPsesion;
		params['sucursal'] = parametroBean.sucursal;
		params['numTransaccion'] = numTransac;
		params['numTransacSim'] = numTransac;
		
		
		params['montosCapital'] 		= $('#montosCapital').val();
		
		 
		$.post("simPagLibresCredito.htm", params, function(data){
			if(data.length >0) {
				$('#contenedorSimulador').html(data); 
				$('#contenedorSimulador').show();
				
				var valorTransaccion = $('#transaccion').val();
				$('#numTransacSim').val(valorTransaccion);
				alert("Datos Guardados");
			}else{
				$('#contenedorSimulador').html("");
				$('#contenedorSimulador').show();
			}
				
		}); 	
	} 
	
}

function mostrarGridLibres(){	
	var data;
	      
	data = '<input type="hidden" value="0" name="numeroDetalle" id="numeroDetalle" />'+
			'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+                 
	'<legend>Simulador de Amortizaciones</legend>'+	 
		'<form id="gridDetalle" name="gridDetalle">'+
			'<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">'+
				'<tr>'+
					'<td class="label">'+ 
				   	'<label for="lblNumero">Numero</label>'+ 
					'</td>'+ 
					'<td class="label">'+ 
				   	'<label for="lblNumero">Fecha Inicio</label>'+ 
					'</td>'+
					'<td class="label">'+ 
						'<label for="lblCR">Fecha Vencimiento</label>'+ 
			  		'</td>'+	
					'<td class="label">'+ 
						'<label for="lblCuenta">Fecha Pago</label>'+ 
			  		'</td>'+ 
			  		'<td class="label">'+ 
		         	'<label for="lblReferencia">Capital</label>'+ 
		     		'</td>'+ 
		     		'<td class="label">'+  
		         	'<label for="lblDescripcion">Interes</label>'+ 
		     		'</td>'+ 
		     		'<td class="label">'+ 
		         	'<label for="lblCargos">Iva Interes</label>'+ 
		     		'</td>'+ 
		     		'<td class="label">'+  
		         	'<label for="lblTotalPag">Total Pago</label>'+ 
		     		'</td>'+ 
		     		'<td class="label">'+ 
		         	'<label for="lblSaldoCap">Saldo Capital</label>'+ 
		     		'</td>'+ 
				'</tr>'+
				'<tr>'+
					'<table colspan="5" align="right">'+
						'<tr>'+
							'<td align="right">'+
 		
								'<button type="button" class="submit" id="calcular" tabindex="37"  onclick="simuladorLibresCapFec();">Calcular</button>'+ 		
							'</td>'+
						'</tr>'+
					'</table>'+ 
				'</tr>'+
			'</table>'+
		'</form>'+
	'</fieldset>'; 

	
	$('#contenedorSimulador').html(data); 
	$('#contenedorSimulador').show();
	agregaFormatoControles('gridDetalle');			 
	mostrarGridLibres2();
}						

function mostrarGridLibres2(){	
		
		agregaFormatoControles('gridDetalle');

		var numeroFila = document.getElementById("numeroDetalle").value;
		var nuevaFila = parseInt(numeroFila) + 1;
		var filaAnterior = parseInt(nuevaFila) - 1;		
      var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
   	if(numeroFila == 0){ 
    		tds += '<td><input id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="4" value="1" readOnly="true" disabled="true"/></td>';
			tds += '<td><input id="fechaInicio'+nuevaFila+'"  name="fechaInicio" size="12" value="'+ $('#fechaInicio').val()+'" readOnly="true" disabled="true"/></td>';
			tds += '<td><input id="fechaVencim'+nuevaFila+'" name="fechaVencim" size="12" value="" esCalendario="true" onblur="comparaFechas('+nuevaFila+')"  /></td>';
			tds += '<td><input id="fechaExigible'+nuevaFila+'" name="fechaExigible" size="12" value=" " readOnly="true" disabled="true"/></td>';
			tds += '<td><input id="capital'+nuevaFila+'" name="capital" size="10" value="" esMoneda="true"/></td>';
			tds += '<td><input id="interes'+nuevaFila+'" name="interes" size="10" value="" esMoneda="true" readOnly="true" disabled="true"/></td>';
			tds += '<td><input id="ivaInteres'+nuevaFila+'" name="ivaInteres" size="10" align="right" value=" " esMoneda="true" readOnly="true" disabled="true"/></td>';
			tds += '<td><input id="totalPago'+nuevaFila+'" name="totalPago" size="10" align="right" value=" " esMoneda="true" readOnly="true" disabled="true"/></td>';
			tds += '<td><input id="saldoInsoluto'+nuevaFila+'" name="saldoInsoluto" size="10" align="right" value=" " esMoneda="true" readOnly="true" disabled="true"/>'; 
			 
    	} else{     		
			var valor = parseInt(document.getElementById("consecutivoID"+numeroFila+"").value) + 1;
    		tds += '<td><input id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="4" value="'+valor+'" autocomplete="off" readOnly="true" disabled="true"/></td>';
    		tds += '<td><input id="fechaInicio'+nuevaFila+'"  name="fechaInicio" size="12" value="'+ $('#fechaVencim'+filaAnterior).val()+'" readOnly="true" disabled="true"/></td>';
			tds += '<td><input id="fechaVencim'+nuevaFila+'" name="fechaVencim" size="12" value="" esCalendario="true" onblur="comparaFechas('+nuevaFila+')" /></td>';
			tds += '<td><input id="fechaExigible'+nuevaFila+'" name="fechaExigible" size="12" value="" readOnly="true" disabled="true"/></td>';
			tds += '<td><input id="capital'+nuevaFila+'" name="capital" size="10" value="" esMoneda="true"/></td>';
			tds += '<td><input id="interes'+nuevaFila+'" name="interes" size="10" value="" esMoneda="true" readOnly="true" disabled="true"/></td>';
			tds += '<td><input id="ivaInteres'+nuevaFila+'" name="ivaInteres" size="10" align="right" value="" esMoneda="true" readOnly="true" disabled="true"/></td>';
			tds += '<td><input id="totalPago'+nuevaFila+'" name="totalPago" size="10" align="right" value="" esMoneda="true" readOnly="true" disabled="true"/></td>';
			tds += '<td><input id="saldoInsoluto'+nuevaFila+'" name="saldoInsoluto" size="10" align="right" value="" esMoneda="true" readOnly="true" disabled="true"/>'; 
		
    	}
    	tds += '<input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaAmort(this)"/>';
    	tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevaAmort()"/></td>';
	   tds += '</tr>';
	   
	   
    	document.getElementById("numeroDetalle").value = nuevaFila;    	
    	$("#miTabla").append(tds);
	
	
	
}	 

function agregaNuevaAmort(){
	
	agregaFormatoControles('gridDetalle');
	var numeroFila = document.getElementById("numeroDetalle").value;
	var nuevaFila = parseInt(numeroFila) + 1;
		var filaAnterior = parseInt(nuevaFila) - 1;			
   var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
 	 	  
	if(numeroFila == 0){
 		tds += '<td><input id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="4" value="1" readOnly="true" disabled="true"/></td>';
		tds += '<td><input id="fechaInicio'+nuevaFila+'"  name="fechaInicio" size="12" value="'+ $('#fechaInicio').val()+'" readOnly="true" disabled="true"/></td>';
		tds += '<td><input id="fechaVencim'+nuevaFila+'" name="fechaVencim" size="12" value="" esCalendario="true" onblur="comparaFechas('+nuevaFila+')"  /></td>';
		tds += '<td><input id="fechaExigible'+nuevaFila+'" name="fechaExigible" size="12" value="" readOnly="true" disabled="true"/></td>';
		tds += '<td><input id="capital'+nuevaFila+'" name="capital" size="10" value="" esMoneda="true"/></td>';
		tds += '<td><input id="interes'+nuevaFila+'" name="interes" size="10" value="" esMoneda="true" readOnly="true" disabled="true"/></td>';
		tds += '<td><input id="ivaInteres'+nuevaFila+'" name="ivaInteres" size="10" align="right" value=" " esMoneda="true" readOnly="true" disabled="true"/></td>';
		tds += '<td><input id="totalPago'+nuevaFila+'" name="totalPago" size="10" align="right" value=" " esMoneda="true" readOnly="true" disabled="true"/></td>';
		tds += '<td><input id="saldoInsoluto'+nuevaFila+'" name="saldoInsoluto" size="10" align="right" value=" " esMoneda="true" readOnly="true" disabled="true"/>'; 
		 
 	} else{    		 
		var valor = parseInt(document.getElementById("consecutivoID"+numeroFila+"").value) + 1;
 		tds += '<td><input id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="4" value="'+valor+'" autocomplete="off" readOnly="true" disabled="true" /></td>';
 		tds += '<td><input id="fechaInicio'+nuevaFila+'"  name="fechaInicio" size="12" value="'+ $('#fechaVencim'+filaAnterior).val()+'" readOnly="true" disabled="true"/></td>';
		tds += '<td><input id="fechaVencim'+nuevaFila+'" name="fechaVencim" size="12" value="" esCalendario="true" onblur="comparaFechas('+nuevaFila+')" /></td>';
		tds += '<td><input id="fechaExigible'+nuevaFila+'" name="fechaExigible" size="12" value="" readOnly="true" disabled="true"/></td>';
		tds += '<td><input id="capital'+nuevaFila+'" name="capital" size="10" value="" esMoneda="true"/></td>';
		tds += '<td><input id="interes'+nuevaFila+'" name="interes" size="10" value="" esMoneda="true" readOnly="true" disabled="true"/></td>';
		tds += '<td><input id="ivaInteres'+nuevaFila+'" name="ivaInteres" size="10" align="right" value="" esMoneda="true" readOnly="true" disabled="true"/></td>';
		tds += '<td><input id="totalPago'+nuevaFila+'" name="totalPago" size="10" align="right" value="" esMoneda="true" readOnly="true" disabled="true"/></td>';
		tds += '<td><input id="saldoInsoluto'+nuevaFila+'" name="saldoInsoluto" size="10" align="right" value="" esMoneda="true" readOnly="true" disabled="true"/>'; 
	}
 	tds += '<input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaAmort(this)"/>';
 	tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevaAmort()"/></td>';
   tds += '</tr>';
  
 	document.getElementById("numeroDetalle").value = nuevaFila;    	
 	$("#miTabla").append(tds);
 	
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
	
	var jqConsecutivoIDAnt = eval("'#consecutivoID" + String(eval(parseInt(numeroID)-1)) + "'");				
	var jqConsecutivoIDSig = eval("'#consecutivoID" + String(eval(parseInt(numeroID)+1)) + "'");										  
		
	//Si es el primer Elemento
	if ($(jqConsecutivoID).attr("id") == $("input[name=consecutivoID]:first-child").attr("id")){
		$(jqConsecutivoIDSig).val("1");				
	}else if($(jqConsecutivoIDSig).val()!= null && $(jqConsecutivoIDSig).val()!= undefined) {
		//Valida Antes de actualizar, que si exista un sig elemento
		for (i=(parseInt(numeroID)+1);i<=$("#numeroDetalle").val();i++){
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

/*Para ejecutar el simulador de pagos libres de capital y fecha*/
function simuladorLibresCapFec(){	
	var mandar = crearMontosCapitalFecha();
	if(mandar==2){   		  		 
   	var params = {};	
		
		quitaFormatoControles('formaGenerica');
			
		if($('#calcInteresID').val()==1 ) {
			if($('#tipoPagoCapital').is(':checked')){
				tipoLista=1;
			}
		}
		
		if($('#calcInteresID').val()==1 ) {
			if($('#tipoPagoCapital2').is(':checked')){
				tipoLista=2;
			}
		}else{	
			if($('#tipoPagoCapital2').is(':checked')){ 
				tipoLista=4;
			}		
		}		
		
		
		if($('#calcInteresID').val()==1 ) {
			if($('#tipoPagoCapital3').is(':checked')){
				tipoLista=3;
			}
		}else{	
			if($('#tipoPagoCapital3').is(':checked')){
				tipoLista=5;
			}		
		}		
		
		if($('#calcInteresID').val()==1 ) { 
			if($('#calendIrregular').is(':checked')){
				tipoLista=7;
			}
		}else{	
			if($('#calendIrregular').is(':checked')){
				tipoLista=8;
			}		
		}		
		
		if($('#fechaInhabil').is(':checked')){	
				//alert('f1'+$('#fechaInhabil').val());				 
				diaHabilSig= $('#fechaInhabil').val();
			}
			if($('#fechaInhabil2').is(':checked')){  
			//alert($('f2'+'#fechaInhabil2').val());		
				diaHabilSig= $('#fechaInhabil2').val();
			}
		
		//alert('Tipo Lista: '+ tipoLista +' MontoCred: '+  $('#montoCredito').val() +' FechaInha: '+ diaHabilSig);
		
		params['tipoLista'] = tipoLista;
		params['montoCredito'] 	= $('#montoCredito').val();
		params['tasaFija']		=  $('#tasaFija').val();
		params['producCreditoID'] = $('#producCreditoID').val();
		params['clienteID'] 		= $('#clienteID').val();
		params['fechaInhabil']	= diaHabilSig;  
		params['empresaID'] = parametroBean.empresaID;
		params['usuario'] = parametroBean.numeroUsuario;
		params['fecha'] = parametroBean.fechaSucursal;
		params['direccionIP'] = parametroBean.IPsesion; 
		params['sucursal'] = parametroBean.sucursal; 
		
		
		params['montosCapital'] 		= $('#montosCapital').val();
		
		
		$.post("simPagLibresCredito.htm", params, function(data){
			if(data.length >0) {
				$('#contenedorSimulador').html(data); 
				$('#contenedorSimulador').show();
				
				var valorTransaccion = $('#transaccion').val();
				$('#numTransacSim').val(valorTransaccion);
			}else{
				$('#contenedorSimulador').html(""); 
				$('#contenedorSimulador').show();
			}
				
		}); 	 
	}
}


function crearMontosCapitalFecha(){	
	var mandar = verificarvaciosCapFec();
	var regresar;
	if(mandar!=1){  
		var suma =	sumaCapital();  
		if(suma !=1){  		  		
	   	quitaFormatoControles('gridDetalle');
			var numAmortizacion = $('input[name=consecutivoID]').length;
			$('#montosCapital').val("");
			for(var i = 1; i <= numAmortizacion; i++){
				controlQuitaFormatoMoneda("capital"+i+"");
				if(document.getElementById("capital"+i+"").value!="0"){
					if(i == 1){
					$('#montosCapital').val($('#montosCapital').val() +
												//document.getElementById("consecutivoID"+i+"").value + '-' +
												i + ']' +
												document.getElementById("capital"+i+"").value+ ']' +
												document.getElementById("fechaInicio"+i+"").value+ ']' +
												document.getElementById("fechaVencim"+i+"").value );
					}else{
					$('#montosCapital').val($('#montosCapital').val() + '[' +
												i + ']' +
												document.getElementById("capital"+i+"").value+ ']' +
												document.getElementById("fechaInicio"+i+"").value+ ']' +
												document.getElementById("fechaVencim"+i+"").value );
					}	
				} 
			}
			regresar= 2; 
		}
		else {regresar= 1; }
	}
	return regresar;
}
 

function verificarvaciosCapFec(){	 
	//quitaFormatoControles('gridDetalle');
	var numAmortizacion = $('input[name=consecutivoID]').length; 
	$('#montosCapital').val("");
	var regresar;
	for(var i = 1; i <= numAmortizacion; i++){
		// controlQuitaFormatoMoneda("capital"+i+"");
		var jqCapital = eval("'#capital" +i + "'");
		var jqfechaInicio = eval("'#fechaInicio" +i + "'");
		var jqfechaVencim = eval("'#fechaVencim" +i + "'");
		var valCapital = document.getElementById("capital"+i).value;
		var valFecIni = document.getElementById("fechaInicio"+i).value;
		var valFecVen = document.getElementById("fechaVencim"+i).value;
 		if (valFecIni =="" ){
 			document.getElementById("fechaInicio"+i).focus();				 
			$(jqfechaInicio).addClass("error");	 
 			regresar= 1; 
			alert("Especifique Fecha de Inicio");
			i= numAmortizacion+2;
 		}else{regresar= 3;
 			$(jqfechaInicio).removeClass("error");	   	
 		}
 		  
 		if (valFecVen =="" ){
 			document.getElementById("fechaVencim"+i).focus();			 
			$(jqfechaVencim).addClass("error");	 
			alert("Especifique Fecha de Vencimiento");
 			regresar= 1; 
 			i= numAmortizacion+2;
 		}else{regresar= 4;
 			$(jqfechaVencim).removeClass("error");	  
 		}
 		
 		if (valCapital =="" ){
 			document.getElementById("capital"+i).focus();				  
			$(jqCapital).addClass("error");	  
 			regresar= 1; 
			i= numAmortizacion+2; 
 			alert("Especifique Capital"); 
 		}else{regresar= 2;
			$(jqCapital).removeClass("error");	   		
 		}
	}
	return regresar; 
}

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
     
   if (yYear<xYear ){  
		alert("la fecha de Vencimiento debe ser Mayor a la Fecha de Inicio");
     	document.getElementById("fechaVencim"+fila).focus();		 
		$(jqFechaVen).addClass("error");	 
   }else{
   	if (xYear == yYear){    
      	if (yMonth<xMonth){  
         	alert("la fecha de Vencimiento debe ser Mayor a la Fecha de Inicio");
        		document.getElementById("fechaVencim"+fila).focus();				 
				$(jqFechaVen).addClass("error");	  
        	}else  
        {   
          if (xMonth == yMonth)  
          {  
            if (yDay<xDay||yDay==xDay)   
            {
					alert("la fecha de Vencimiento debe ser Mayor a la Fecha de Inicio");
					document.getElementById("fechaVencim"+fila).focus();		
					$(jqFechaVen).addClass("error");	  
            }	
          }	
        }   
         
       }
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

	function estableceParametrosKubo(){
		$('#calcInteresID').val('1');	
		$('#fechaInhabil').attr("checked","1"); 
		$('#fechaInhabil2').attr("checked",false) ; 
		$('#ajusFecExiVen2').attr("checked","1"); 
		$('#ajusFecExiVen').attr("checked",false);
		/*$('#ajusFecUlVenAmo').attr("checked","1");
		$('#ajusFecUlVenAmo2').attr("checked",false);*/
		$('#tipoPagoCapital').attr("checked","1");
		$('#tipoPagoCapital2').attr("checked",false);
		$('#tipoPagoCapital3').attr("checked",false); 
		deshabilitaControl('calcInteresID');
		deshabilitaControl('fechaInhabil');
		deshabilitaControl('fechaInhabil2');
		deshabilitaControl('ajusFecExiVen');
		deshabilitaControl('ajusFecExiVen2');
		/*deshabilitaControl('ajusFecUlVenAmo');
		deshabilitaControl('ajusFecUlVenAmo2');*/
		deshabilitaControl('tipoPagoCapital');
		deshabilitaControl('tipoPagoCapital2');
		deshabilitaControl('tipoPagoCapital3');
		deshabilitaControl('calendIrregular'); 
		deshabilitaControl('cuentaID');
	

 
		} 
		
	function quitaParametrosKubo(){
		habilitaControl('calcInteresID'); 
		habilitaControl('fechaInhabil');
		habilitaControl('fechaInhabil2'); 
		habilitaControl('ajusFecExiVen'); 
		habilitaControl('ajusFecExiVen2');
		/*habilitaControl('ajusFecUlVenAmo');
		habilitaControl('ajusFecUlVenAmo2');*/
		habilitaControl('tipoPagoCapital');
		habilitaControl('tipoPagoCapital2');
		habilitaControl('tipoPagoCapital3');
		habilitaControl('tipoPagoCapital3');
		habilitaControl('cuentaID');
		habilitaControl('calendIrregular'); 
		$('#calendIrregular').attr("checked",false);   
	} 
 
	function consultaMonto(idControl){
		var jqNumMonto = eval("'#" + idControl + "'");
		var monto = $(jqNumMonto).asNumber();
		var saldo = $('#saldoLineaCred').asNumber();

		if(monto > saldo){ 
			alert("El monto del credito no puede ser mayor al Saldo de la linea.");
			$('#montoCredito').focus();
			$('#montoCredito').select();		
		}
	
	}
	 
	 function consultaCta(idControl) {
		var jqCta  = eval("'#" + idControl + "'");
		var numCta = $(jqCta).val();
		//var c=$('#clienteID').val();

			var CuentaAhoBeanCon = {
			'cuentaAhoID'	:numCta,
			'clienteID'		:$('#clienteID').val()
		};
		var conCta =3;
		setTimeout("$('#cajaLista').hide();", 200);		 
		if(numCta != '' && !isNaN(numCta) && esTab){
			cuentasAhoServicio.consultaCuentasAho(3,CuentaAhoBeanCon,function(cuenta) {
						if(cuenta!=null){ 
							 var cte = $('#clienteID').asNumber();
							 var client = parseFloat(cuenta.clienteID);
							$('#monedaID').val(cuenta.monedaID);
							if(client != cte ){
								alert("La cuenta no corresponde con el Cliente");
								$('#cuentaID').focus();
								$('#cuentaID').val("");
							}
													
						}else{
							alert("No Existe la cuenta");
							
							$('#cuentaID').focus();
							$('#cuentaID').select();						
						}
				});
		}	 
	} 


 function consultaCuentaPrincipal() {
		var cte = $('#clienteID').val();
			var CuentaAhoBeanCon = { 
			'clienteID'		:cte
		};
		var conCta =14;
		setTimeout("$('#cajaLista').hide();", 200);		
		if(cte != '' && !isNaN(cte) && esTab){
			cuentasAhoServicio.consultaCuentasAho(14,CuentaAhoBeanCon,function(cuenta) {
						if(cuenta!=null){
							 esTab="true"; 
							$('#cuentaID').val(cuenta.cuentaAhoID); 
							consultaClienteSolici('clienteID');
						}else{
							alert("El Cliente no tiene una Cuenta principal");
							deshabilitaBoton('grabaSF'); 
							deshabilitaBoton('graba'); 
							$('#cuentaID').focus();
							$('#cuentaID').select();						
						}
				});
		}	
	}  
	
	
	function consultaClienteSolici(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
						if(cliente!=null){
							$('#clienteID').val(cliente.numero)							
							$('#nombreCliente').val(cliente.nombreCompleto);
							habilitaBoton('grabaSF'); 
							habilitaBoton('graba'); 
						consultaCuentaPrincipal()
						}else{
							alert("La Solicitud de Credito no tiene un Cliente Valido");
							deshabilitaBoton('grabaSF'); 
							deshabilitaBoton('graba'); 
							$('#solicitudCreditoID').focus();
							$('#solicitudCreditoID').select();	
						}    	 						
				});
			} 
		}
	

function BloquearPantallaAmortizacion(){
	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>'); 
		$('#contenedorForma').block({
				message: $('#mensaje'),
				css: {border:		'none',
			 			background:	'none'}  
	});
			
}
