var parametroBean = consultaParametrosSession(); 
var fechaSistemaTicket= parametroBean.fechaAplicacion;
var var_empresaID = 1;		// Id de empresa por default
var var_pagoIntVertical = ""; // Indica si exige el total del adeudo de interes o si se puede pagar en parcialidades
var cobraAccesorios = 'N';

var var_numConsultaParamSis = { 
  		'principal'	: 1
	};

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

$(document).ready(function(){
	$("#creditoID").focus();
	
	consultaParametrosSistema();
	
	
	//Definición de constantes y Enums
	esTab = true;
	  
	var catTipoConsultaCredito = { 
  		'principal'	: 1,
  		'foranea'	: 2,
  		'pago'		: 7 
	};	
			
	var catTipoTranCredito = { 
  		'pagoCredito'		: 23 ,
  		'pagoCreditoGrupal': 18 ,
  		'prepagoCredito': 21 ,
  		'prepagoCreditoGrupal' :22,// cambiar esto
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
   			// Valida que haya saldo suficiente en la cuenta al cual se hara el cargo
   	    	if(montoPagarMayor == 1){
   	    		$('#tipoTransaccion').val(catTipoTranCredito.pagoCredito);
   	    		
   	    		
   	    		if($('#montoPagar').asNumber() > 0){
		   	    		// valida que el total a pagar sea el total adeudo de intereses
		   	    		if(var_pagoIntVertical == "S"){
		   	    			if($('#montoPagar').asNumber() == $('#pagoExigible').asNumber() ){ 
			    	    			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','numeroTransaccion','funcionExitoPago','funcionFalloPago');
			    	    	}else{
			    	    		mensajeSis('El Monto a Pagar debe ser Igual al Total Adeudo de Intereses.');
			    	    		$('#montoPagar').focus();
			    	    	}
		   	    		// si no, si permite pagos por parcialidades
		   	    		}else if($('#montoPagar').asNumber() <= $('#pagoExigible').asNumber() ){ 
			    			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','numeroTransaccion','funcionExitoPago','funcionFalloPago');
		    	    	
		   	    		}else{
		   	    			mensajeSis('El Monto a Pagar No debe ser Mayor al Total Adeudo de Intereses.');
		   	    			$('#montoPagar').focus();
		   	    		}
		   	    	
   	    		} else{
   	    			mensajeSis('El Monto a Pagar debe ser Mayor Cero.');
   	    			$('#montoPagar').focus();
   	    		}
   	    	}
   		}
    });	
   	
	$('#montoPagar').blur(function(){
		if($('#montoPagar').asNumber() > $('#saldoCta').asNumber()){
			mensajeSis("El Saldo de la Cuenta es Insuficiente.");
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
		lista('creditoID', '2', '41', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
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
				required: 'Indique Número de  Crédito'
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
  			
   			creditosServicio.consulta(18,creditoBeanCon,function(credito) {//catTipoConsultaCredito.saldos
				if(credito!=null){
					listaPersBloqBean = consultaListaPersBloq(credito.clienteID, esCliente, 0, 0);
					consultaSPL = consultaPermiteOperaSPL(credito.clienteID,'LPB',esCliente);
				
					if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
						esTab=true;	
						dwr.util.setValues(credito);
						consultaCreditoPrincipal();
						if(credito.fechaProxPago == '1900-01-01'){
	   						$('#fechaProxPago').val("");
	   					}
						if (credito.grupoID>0){
							
						}else{
							consultaCliente('clienteID');			
							consultaMoneda('monedaID');							
							consultaLineaCredito('lineaCreditoID');	
							consultaCta('cuentaID',credito.grupoID);
							consultaProducCredito('producCreditoID');				
							var estatus = credito.estatus;
							validaEstatusCredito(estatus);	
						}					
	  					consultaFiniquitoLiqAnticipada(credito.grupoID);
				}else{
					inicializaForma('formaGenerica','creditoID');
					mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
					deshabilitaBoton('pagar','submit');
					deshabilitaBoton('movimientos','submit');
					deshabilitaBoton('amortiza','submit');
					$('#creditoID').focus();
					$('#creditoID').select();	
				}
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
			});
		}
	}
	

	
	//Funcion para consultar los saldos
	function consultaFiniquitoLiqAnticipada(grupoID){
		var numCredito = $('#creditoID').val();
		if(numCredito != '' && !isNaN(numCredito) ){
			var Con_PagoCred = 17;
			var creditoBeanCon = { 
					'creditoID':$('#creditoID').val(),
					'fechaActual':$('#fechaSistema').val()
					};
			$('#gridAmortizacion').hide();
			$('#gridMovimientos').hide();
			creditosServicio.consulta(Con_PagoCred,creditoBeanCon,function(credito) {//catTipoConsultaCredito.saldos
				if(credito!=null){
					$('#permiteFiniquito').val(credito.permiteFiniquito);
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
						//SEGURO CUOTA
						$('#saldoSeguroCuota').val(credito.saldoSeguroCuota);
						$('#saldoIVASeguroCuota').val(credito.saldoSeguroCuota);
						//FIN SEGURO CUOTA
						//COMISION ANUAL
						$('#saldoComAnual').val(credito.saldoComAnual);
						$('#saldoComAnualIVA').val(credito.saldoComAnualIVA);
						//FIN COMISION ANUAL
						$('#totalComisi').val(credito.totalComisi); 
						$('#salIVAComFalPag').val(credito.salIVAComFalPag);
						$('#saldoIVAComisi').val(credito.saldoIVAComisi);
						$('#totalIVACom').val(credito.totalIVACom);	
						$('#adeudoTotal').val(credito.adeudoTotal);	
						$('#saldoAdmonComis').val(credito.saldoAdmonComis);	
						$('#saldoIVAAdmonComisi').val(credito.saldoIVAAdmonComisi);
						$('#permiteFiniquito').val(credito.permiteFiniquito);						
						$('#pagoExigible').val($('#totalInteres').asNumber()+$('#saldoIVAInteres').asNumber()+
											   $('#saldoMoratorios').asNumber()+$('#saldoIVAMorator').asNumber());
						
						$('#pagoExigible').formatCurrency({
							positiveFormat: '%n',  
							negativeFormat: '%n',
							roundToDecimalPlace: 2	
						});	
						
						if(grupoID > 0){
							mensajeSis("El Crédito Indicado es Grupal.");
							$('#creditoID').val("");
							$('#creditoID').focus();
							inicializaForma('formaGenerica','creditoID');
							
							$('#clienteID').val("");
							$('#nombreCliente').val("");
							$('#cuentaID').val("");
							$('#nomCuenta').val("");
							$('#saldoCta').val("");
							$('#fechaProxPago').val("");
							deshabilitaBoton('movimientos','submit');	
							deshabilitaBoton('amortiza','submit');	
							deshabilitaBoton('pagar','submit');	
						}else{							
							
							if ($('#pagoExigible').asNumber()>0){
								habilitaBoton('pagar','submit');	
							}else{
								deshabilitaBoton('pagar','submit');	
							}
							habilitaBoton('amortiza', 'submit');
							habilitaBoton('movimientos', 'submit');
						}
				}else{
					mensajeSis("No Existe el Crédito.");
					$('#pagaIVA').val("");
				}
			});
		}
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
			lineasCreditoServicio.consulta(catTipoConsultaCredito.principal,lineaCreditoBeanCon,function(linea) {
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
		var estatusSuspendido 	="S";
		
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
		if(var_estatus == estatusSuspendido){
			$('#estatus').val('SUSPENDIDO');							
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
		imprimeTicketPago();
		deshabilitaBoton('amortiza', 'submit');
		deshabilitaBoton('movimientos', 'submit');
		deshabilitaBoton('pagar', 'submit');
		$('#pagaIVA').val("");
		$('#impTicket').show();
	}

	//Funcion que se ejecuta cuanto hay una falla de la transaccion
	function funcionFalloPago(){
		$('#pagaIVA').val("");
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
		var tituloOperacion=  'PAGO INTERESES DE CREDITO CON CARGO A CUENTA';
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
		var tituloOperacion = 'PAGO INTERESES DE CREDITO CON CARGO A CUENTA';
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


		var catTipoConsultaCredito = { 
		'principal'	: 1,
		'foranea'	: 2,
		'pago'		: 7 
  			};	

		function consultaCreditoPrincipal() {
			var numCredito = $('#creditoID').val();
			var fechaAplicacion = parametroBean.fechaAplicacion;
			var tipoConsultaCred = 1;
			setTimeout("$('#cajaLista').hide();", 200);
						
			if(numCredito != '' && !isNaN(numCredito) ){
				var creditoBeanCon = {
						'creditoID':$('#creditoID').val()
				};			
				creditosServicio.consulta(tipoConsultaCred,creditoBeanCon,{ async: false, callback: function(credito) {
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
		
			