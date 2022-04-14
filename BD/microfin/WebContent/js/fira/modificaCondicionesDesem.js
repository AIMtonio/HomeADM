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
		lista('creditoID', '1', '6', camposLista, parametrosLista, 'ListaCredito.htm');
	});
	
	$.validator.setDefaults({
		submitHandler : function(event) {
			grabaFormaTransaccion(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','creditoID');
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
		$('#sucursalID').val("");
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
			$('#sucursalID').val("");
			$('#nombreSucursal').val("");
			$('#solicitudCreditoID').val("");
			$('#grupoID').val("");
			$('#descripcionGrupo').val("");
			$('#tipoDispersion').val("");
			$('#estatus').val("");
			$('#ciclo').val("");
			
		
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
						
					}else{						
						mensajeSis("El Cŕedito No existe");			
						$('#producCreditoID').val('');
						$('#nombreProducto').val("");
						$('#clienteID').val("");
						$('#nombreCliente').val("");
						$('#cuentaID').val("");
						$('#descripcionCuenta').val("");
						$('#sucursalID').val("");
						$('#nombreSucursal').val("");
						$('#solicitudCreditoID').val("");
						$('#grupoID').val("");
						$('#descripcionGrupo').val("");
						$('#tipoDispersion').val("");
						$('#estatus').val("");
						$('#ciclo').val("");			
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
});