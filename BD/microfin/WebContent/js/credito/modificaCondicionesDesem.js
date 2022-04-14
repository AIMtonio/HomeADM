$(document).ready(function() {
	esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionCredito = {
  	  		'modifica':'17'};
	
	var catTipoActualizacionCredito = {
  	  		'modifica':'7'};
	
	var catTipoConsultaCredito = {
  		'principal'	: 11
  		
	};	
	
		//------------ Msetodos y Manejo de Eventos -----------------------------------------
    deshabilitaBoton('modifica', 'submit');
    $('#creditoID').focus();
    var estatusCredito = "";
    var montoCredito = "";
    var creditoModificado = "";
    var modificaMontoCred = "";
    $('#tdMontoCredito').hide();
    
    validaModificaMontoCred();
    
    agregaFormatoControles('formaGenerica');
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	//Muestra la lista Lista	
	$('#creditoID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();			
		camposLista[0] = "creditoID"; 
		parametrosLista[0] = $('#creditoID').val();
		lista('creditoID', '2', '6', camposLista, parametrosLista, 'ListaCredito.htm');
	});
	
	$.validator.setDefaults({
		submitHandler : function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','creditoID','funcionExito','funcionError');
		}
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionCredito.modifica);
		$('#tipoActualizacion').val(catTipoActualizacionCredito.modifica);
		
		
		$('#producCreditoID').val('');
		$('#nombreProducto').val("");
		$('#clienteID').val("");
		$('#nombreCliente').val("");
		$('#cuentaID').val("");
		$('#descripcionCuenta').val("");
		$('#sucursal').val("");
		$('#nombreSucursal').val("");
		$('#solicitudCreditoID').val("");
		$('#grupoID').val("");
		$('#descripcionGrupo').val("");
		$('#estatus').val("");
		$('#ciclo').val("");	
	});	
	
	$('#creditoID').blur(function() {
		validaCredito(this.id); 
	});
	
	// VALIDA EL MONTO A MODIFICAR
	$('#montoCredito').blur(function() {
		var montoCred = $('#montoCredito').asNumber();

		if(estatusCredito == "A"){

			if((montoCred > montoCredito || montoCred < montoCredito)){
				mensajeSis("Para modificar el Monto el estatus del Crédito debe estar INACTIVO.");
				deshabilitaBoton('modifica', 'submit');
				$('#montoCredito').focus();
				$('#montoCredito').val(montoCredito);
			}

			else if(montoCred == montoCredito){
				habilitaBoton('modifica', 'submit');
			}
		}

		if(estatusCredito == "I"){
			consultaCredMontoAutoMod();
			if(creditoModificado == ''){
				if(montoCred > montoCredito){
					mensajeSis("El Monto Especificado No debe ser Mayor al Monto Autorizado del Crédito.");
					deshabilitaBoton('modifica', 'submit');
					$('#montoCredito').focus();
					$('#montoCredito').val(montoCredito);
				}else{
					habilitaBoton('modifica', 'submit');
				}
			}

			if (montoCred == 0) {
				mensajeSis("El Monto Especificado debe ser Mayor a Cero.");
				deshabilitaBoton('modifica', 'submit');
				$('#montoCredito').focus();
				$('#montoCredito').val(montoCredito);
			}

			if(montoCred <= montoCredito && montoCred > 0){
				habilitaBoton('modifica', 'submit');
			}
		}

	});


	// ------------ Validaciones de la Forma
	$('#formaGenerica').validate({	
		rules: {
			creditoID: {
				required: true,
				numeroPositivo: true
							
			},
			tipoDispersion: {
				required: true
				
			}
		},
			messages: {
				creditoID: {
					required: 'Especificar No.Crédito',
					numeroPositivo: 'Solo Números'
					
				},
				tipoDispersion:{
					required:'Especificar Tipo de Dispersión'
				}
			}
			
			});
	

	//------------ Validaciones de Controles -------------------------------------
	
	function validaCredito(control) {
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito)){
		if(numCredito==null){
				
			deshabilitaBoton('modifica', 'submit');

			$('#producCreditoID').val('');
			$('#nombreProducto').val("");
			$('#clienteID').val("");
			$('#nombreCliente').val("");
			$('#cuentaID').val("");
			$('#descripcionCuenta').val("");
			$('#sucursal').val("");
			$('#nombreSucursal').val("");
			$('#solicitudCreditoID').val("");
			$('#grupoID').val("");
			$('#descripcionGrupo').val("");
			$('#tipoDispersion').val("");
			$('#estatus').val("");
			$('#ciclo').val("");
			$('#tipoDispersion').val("");
			$('#montoCredito').val("");
			
		
		} else {
			 
			habilitaBoton('modifica', 'submit');
			
			var creditoBeanCon = { 
	  				'creditoID':numCredito
					};
					setTimeout("$('#cajaLista').hide();", 200);
					creditosServicio.consulta(catTipoConsultaCredito.principal,creditoBeanCon,function(credito) {
					if(credito!=null){	
											
						$('#producCreditoID').val(credito.producCreditoID);						
						$('#clienteID').val(credito.clienteID);							
						$('#cuentaID').val(credito.cuentaID);
						$('#sucursal').val(credito.sucursal);
						$('#solicitudCreditoID').val(credito.solicitudCreditoID);
						$('#tipoDispersion').val(credito.tipoDispersion).selected = true;
						$('#grupoID').val(credito.grupoID);	
						
						esTab= true;
						consultaProducCredito(credito.producCreditoID);
						consultaCta(credito.cuentaID);
						validaEstatusCredito(credito.estatus);
						consultaSucursal(credito.sucursal);
						consultaCliente('clienteID');						
						consultaGrupo('grupoID');		
						$('#ciclo').val(credito.cicloGrupo);
												
						if(credito.estatus =='A' || credito.estatus =='I'){							
						habilitaBoton('modifica', 'submit');
						}else{							
						mensajeSis("Solo se pueden modificar Créditos Autorizados o Inactivos.");
						deshabilitaBoton('modifica', 'submit');
						}
						
						estatusCredito = credito.estatus;
						montoCredito = credito.montoCredito;
						
						validaModificaMontoCred();
						if(modificaMontoCred == "S"){
							consultaCredMontoAutoMod();
							$('#montoCredito').val(credito.montoCredito);
						}else{
							$('#montoCredito').val(0.00);
						}
						
						$('#montoCredito').formatCurrency({
							positiveFormat: '%n', roundToDecimalPlace: 2
						});
						
					}else{						
						mensajeSis("El Cŕedito No existe");			
						$('#producCreditoID').val('');
						$('#nombreProducto').val("");
						$('#clienteID').val("");
						$('#nombreCliente').val("");
						$('#cuentaID').val("");
						$('#descripcionCuenta').val("");
						$('#sucursal').val("");
						$('#nombreSucursal').val("");
						$('#solicitudCreditoID').val("");
						$('#grupoID').val("");
						$('#descripcionGrupo').val("");
						$('#tipoDispersion').val("");
						$('#estatus').val("");
						$('#ciclo').val("");
						$('#tipoDispersion').val("");
						$('#montoCredito').val("");
						deshabilitaBoton('modifica', 'submit');
						$('#creditoID').val("");	
						$('#creditoID').focus();	
					
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
							//$('#clienteID').val(credito.clienteID);						
							$('#nombreCliente').val(cliente.nombreCompleto);
							
							 
							
						}else{
							$('#nombreCliente').val("");
						
						}    	 						
				});
			} 
		}

	
	function consultaProducCredito(idControl) {  
		var ProdCred = idControl;
		var conTipoCta=2;
		var ProdCredBeanCon = {
  			'producCreditoID':ProdCred 
		}; 
		setTimeout("$('#cajaLista').hide();", 200);
		if(ProdCred != '' && !isNaN(ProdCred) ){		
			productosCreditoServicio.consulta(conTipoCta,ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){
					$('#nombreProducto').val(prodCred.descripcion);
				}else{							
					$('#nombreProducto').val("");
				}
			});
		}			 					
	}
	
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
		}	
		if(var_estatus == estatusAutorizado){
			$('#estatus').val('AUTORIZADO');
		}
		if(var_estatus == estatusVigente){
			$('#estatus').val('VIGENTE');
		}
		if(var_estatus == estatusPagado){
			$('#estatus').val('PAGADO');
			deshabilitaBoton('graba', 'submit');
		}
		if(var_estatus == estatusCancelada){
			$('#estatus').val('CANCELADO');
		}
		if(var_estatus == estatusVencido){
			$('#estatus').val('VENCIDO');
		}
		if(var_estatus == estatusCastigado){
			$('#estatus').val('CASTIGADO');
		}		
	}
	

	function consultaGrupo(idControl) {
		var jqGrupo = eval("'#" + idControl + "'");
		var numGrupo = $(jqGrupo).val();	
		var tipConPrincipal = 1;
		var grupoBeanCon = { 
  				'grupoID':numGrupo		  				
			};
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numGrupo != '' && !isNaN(numGrupo) && esTab){
			gruposCreditoServicio.consulta(tipConPrincipal,grupoBeanCon,function(grupos) {
				if(grupos!=null){		
							esTab=true;
							$('#descripcionGrupo').val(grupos.nombreGrupo);
						}else{
							$('#descripcionGrupo').val("");
						}
				});
			}
		}	
	
	
	function consultaSucursal(idControl) {
		var numSucursal = idControl;	
		var conSucursal=2;
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numSucursal != '' && !isNaN(numSucursal)){
			sucursalesServicio.consultaSucursal(conSucursal,numSucursal,function(sucursal) {
						if(sucursal!=null){		
							$('#nombreSucursal').val(sucursal.nombreSucurs);
																	
						}else{							
							$('#nombreSucursal').val("");
						}    						
				});
			}
	}
	
	
	function consultaCta(idControl) {
		var numCta = idControl;
        var conCta = 3;   
        var CuentaAhoBeanCon = {
        		'cuentaAhoID':numCta,
        		'clienteID':$('#clienteID').val()
        };
        setTimeout("$('#cajaLista').hide();", 200);
        if(numCta != '' && !isNaN(numCta)){
        	cuentasAhoServicio.consultaCuentasAho(conCta, CuentaAhoBeanCon,function(cuenta) {
        		if(cuenta!=null){         			
        			consultaTipoCta(cuenta.tipoCuentaID);
                   
        		}else{        			
        			$('#descripcionCuenta').val("");
        		}
        	});                                                                                                                        
        }
	}
	
	function consultaTipoCta(idControl) {
		var numTipoCta = idControl;	
		var conTipoCta=2;
		var TipoCuentaBeanCon = {
  			'tipoCuentaID':numTipoCta
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numTipoCta != '' && !isNaN(numTipoCta)){
			tiposCuentaServicio.consulta(conTipoCta, TipoCuentaBeanCon,function(tipoCuenta) {
				if(tipoCuenta!=null){
					$('#descripcionCuenta').val(tipoCuenta.descripcion);							
				}else{
					$('#descripcionCuenta').val("");	
				}    						
			});
		}
	}
	
	// Funcion para validar si se realiza modificacion del Monto de Credito
	function validaModificaMontoCred(){
		paramGeneralesServicio.consulta(30,{},function(parametro){
			if (parametro != null) {
				modificaMontoCred = parametro.valorParametro;
				if(modificaMontoCred == 'S'){
					$('#tdMontoCredito').show();
				}
				else {
					$('#tdMontoCredito').hide();
				}
			}
		});
	}
	
	//Función para consultar los créditos con montos autorizados modificados
	function consultaCredMontoAutoMod(){
		var creditoID = $('#creditoID').val();
		var montoCred = $('#montoCredito').asNumber();
		var tipoConsulta = 43;
		var creditoBeanCon = {
			'creditoID'	:creditoID
		};

		setTimeout("$('#cajaLista').hide();", 200);

		if(creditoID != '' && !isNaN(creditoID)){
			creditosServicio.consulta(tipoConsulta,creditoBeanCon,function(creditos) {
				if(creditos != null){
					creditoModificado = 'S';
					if(montoCred > creditos.montoCredito){
						mensajeSis("El Monto Modificado No debe ser Mayor al Monto Original del Crédito.");
						habilitaBoton('modifica', 'submit');
						$('#montoCredito').focus();
						$('#montoCredito').val(creditos.montoCredito);
					}
				}
			});
		}
	}
});

//funcion que se ejecuta cuando el resultado fue un éxito
function funcionExito(){
	limpiaFormaCompleta('formaGenerica', true, ['creditoID']);
	$("#creditoID").focus();
}

//funcion que se ejecuta cuando el resultado fue error
//diferente de cero
function funcionError(){
	$("#creditoID").focus();
	$('#tipoDispersion').val("");
	$('#montoCredito').val("");
}