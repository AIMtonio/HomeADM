
$(document).ready(function() {
	esTab = true;
	
	$("#numero").focus();

	//Definicion de Constantes y Enums  
	var catTipoTransaccionCliente= {
	  		'modificar': '7'
	}; 

	

//------------ Metodos y Manejo de Eventos -----------------------------------------
  	
  	$(':text').focus(function() {	
	 	esTab = false;
	});
	
  	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','numero');
	  	}
	});	
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	deshabilitaBoton('modifica','submit');

	
    $('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionCliente.modificar);
		exito();
	});

	$('#numero').bind('keyup',function(e) { 
		lista('numero', '2', '1', 'nombreCompleto', $('#numero').val(), 'listaCliente.htm');
	});
	
	
	$('#promotorNue').bind('keyup',function(e) { 
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "promotorID";
		camposLista[1] = "nombrePromotor";
		camposLista[2] = "sucursalID";
		parametrosLista[0] = $('#promotorNue').val();
		parametrosLista[1] = $('#promotorNue').val();
		parametrosLista[2] = $('#sucursalID').val(); 
		lista('promotorNue', '1', '4',camposLista, parametrosLista, 'listaPromotores.htm');
		
	});
	
	
	$('#numero').focus();
        

    $('#numero').blur(function(){
    	consultaCliente(this.id);
		$('#promotorNue').val('');
		$('#nombPromotorNue').val('');	

    });
    

    $('#promotorNue').blur(function(){
    	if($('#numero').val() != null){
    consultaNomPromotorN(this.id);
    	}
    	
    	else{
    		mensajeSis("Especifique un Cliente");
    	}
  
 });
    
    
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
		rules: {
			numero: {
				required: true
			},
			
				
			promotorNue: { 
				required: true
					 
			}
		},
		messages: {
			numero: {
				required: 'Especificar Número de Cliente'
			},
			promotorNue: { 
				required: 'Expecificar Número de Promotor'
					 
			}
					
		}			
	});

	// funciones

	
	
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		setTimeout("$('#cajaLista').hide();", 200);
		
		if (numCliente != '' && !isNaN(numCliente) && esTab) {

			clienteServicio.consulta(1, numCliente, function(
					cliente) {
				if (cliente != null) {
					$('#numero').val(cliente.numero);
					$('#nombreCliente').val(cliente.nombreCompleto);
					$('#fechaNacimiento').val(cliente.fechaNacimiento);
					consultaDireccion('numero');
					$('#sucursalID').val(cliente.sucursalOrigen);
					consultaSucursal('sucursalID');
					$('#promotorAct').val(cliente.promotorActual);
					consultaNomPromotorA('promotorAct');
					$('#promotorNue').focus();
					deshabilitaBoton('modifica','submit');


				} else {
					mensajeSis("No Existe el Cliente");
					limpiaForma();
					deshabilitaBoton('modifica','submit');
					$('#numero').focus();

				}
			});
		}
		
		else{
			deshabilitaBoton('modifica','submit');
			$('#numero').focus();
			limpiaForma();
			
		}
	}
	
	
	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();
		var conSucursal = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numSucursal != '' && !isNaN(numSucursal)) {
			sucursalesServicio.consultaSucursal(conSucursal,
					numSucursal, function(sucursal) {
						if (sucursal != null) {
							$('#nombreSucursal').val(
									sucursal.nombreSucurs);
						} else {
							mensajeSis("No Existe la Sucursal");
							limpiaForma();
							$('#numero').focus();

						}
					});
		         }
	         }
	
	
	function consultaNomPromotorA(idControl) {
		var jqPromotor = eval("'#" + idControl + "'");
		var numPromotor = $(jqPromotor).val();
		var tipConForanea = 2;
		var promotor = {
			'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPromotor != '' && !isNaN(numPromotor)) {
			promotoresServicio.consulta(tipConForanea,promotor, function(promotor) {
				if (promotor != null) {
						$('#nombrePromotor').val(
							promotor.nombrePromotor);
										
				} else {
					mensajeSis("No Existe el Promotor");
					$('#promotorAct').val('');
					$('#nombrePromotor').val('');
				}
			});
		}
	}
	
	
	function consultaNomPromotorN(idControl) {
		var jqPromotor = eval("'#" + idControl + "'");
		var numPromotor = $(jqPromotor).val();
		var tipConForanea = 1;
		var promotor = {
			'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPromotor != '' && !isNaN(numPromotor) && esTab) {
			promotoresServicio.consulta(tipConForanea,promotor, function(promotor) {
				if (promotor != null) {
						$('#nombPromotorNue').val(
							promotor.nombrePromotor);
						
						if(	$('#promotorAct').val() != $('#promotorNue').val()){
						habilitaBoton('modifica','submit');
						}  else{
							mensajeSis("El nuevo promotor debe ser distinto.");
							$('#promotorNue').val('');
							$('#nombPromotorNue').val('');
							deshabilitaBoton('modifica', 'submit');
							$('#promotorNue').focus();							
						}
										
				} else {
					mensajeSis("No Existe el Promotor");
					$('#promotorNue').val('');
					$('#nombPromotorNue').val('');
					deshabilitaBoton('modifica', 'submit');
					$('#promotorNue').focus();

				}
			});
		}
	}
	

	
	function consultaDireccion(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var client = $(jqCliente).val();
		var tipConOficial= 3;
		var direccionesCliente = {
			'clienteID' : client,
		
		};
		
		setTimeout("$('#cajaLista').hide();", 200);
			
		direccionesClienteServicio.consulta(tipConOficial,direccionesCliente,function(direccion) {
			
		if (direccion != null) {
		$('#direccionCompleta').val(direccion.direccionCompleta);
										
				} else {
					mensajeSis("No Existe la dirección");
					$('#direccionCompleta').val('');
					$('#promotorNue').focus();

				}
			});
		
	}

	
	  function limpiaForma(){
			$('#numero').val('');
		    $('#nombreCliente').val('');
			$('#fechaNacimiento').val('');
			$('#direccionCompleta').val('');
			$('#sucursalID').val('');
			$('#nombreSucursal').val('');
			$('#promotorAct').val('');
			$('#nombrePromotor').val('');
			$('#promotorNue').val('');
			$('#nombPromotorNue').val('');
	  }
	  
	  

	  function exito(){
		    $('#nombreCliente').val('');
			$('#nombreSucursal').val('');
			$('#nombrePromotor').val('');
			$('#nombPromotorNue').val('');
	  }
	    
});