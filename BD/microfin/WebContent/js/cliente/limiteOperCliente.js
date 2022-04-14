$(document).ready(function(){	
	esTab = true;
	var tab2 = false;		
	
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});	
	
	//Definicion de Constantes y Enums  
	var tipoActualizacion= {
			'ninguna': '0',
			'bloquear': '1',
			'desbloquear': '2'					
		};
	
	var tipoTransaccion= {			
			'grabar': '1',
			'modificar': '2'					
		};
				
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaControl('bancaMovil1');
	deshabilitaControl('bancaMovil2');			
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('modificar', 'submit');
	$('#trMontoMaxBcaMovil').hide();
	$('#limiteOperID').focus();	

	$('#grabar').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.grabar);
		$('#tipoActualizacion').val(tipoActualizacion.ninguna);
	});
	
	$('#modificar').click(function() {
		$('#tipoTransaccion').val(tipoTransaccion.modificar);
		$('#tipoActualizacion').val(tipoActualizacion.ninguna);
	});
	
	$('#limiteOperID').bind('keyup',function(e) { 
		var camposLista = new Array(); 
	    var parametrosLista = new Array(); 
	    	camposLista[0] = "nombreCompleto";
	    	parametrosLista[0] = $('#limiteOperID').val();
		lista('limiteOperID', '3', '1', camposLista, parametrosLista, 'listaLimiteOperCliente.htm');
	});
			
	$('#limiteOperID').blur(function() {				
		if(isNaN($('#limiteOperID').val())){
			limpiaCampos();				
			
			deshabilitaBoton('grabar', 'submit');
			deshabilitaBoton('modificar', 'submit');					
		}else{			
			consultaUsuaReg();
		}
	});
	
	$('#clienteID').bind('keyup',function(e) { 
		lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	

	$('#clienteID').blur(function() {				
		if(!isNaN($('#clienteID').val()) && $('#clienteID').asNumber() >0){
			consultaClientePantalla();				
		}else{
			$('#empresaID').focus();				
		}							
	});	
	

	$('#bancaMovil1').click(function() {				
		$('#trMontoMaxBcaMovil').show();	
		$('#bancaMovil1').focus();
		
	});
	$('#bancaMovil2').click(function() {	
		$('#trMontoMaxBcaMovil').hide();	
		$('#monMaxBcaMovil').val('0.00');	
		$('#bancaMovil2').focus();
	});
	
	
	$.validator.setDefaults({
		submitHandler : function(event) {	
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica',
					'contenedorForma', 'mensaje', 'true',
					'limiteOperID', 'funcionExito',
					'funcionError');				
		}
	});
	 
	//------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({

		rules: {
			monMaxBcaMovil:{
				required: function() {return $('#bancaMovil1:checked').val() == 'S';},	
				number: true,
			},
		},		
		messages: {
			monMaxBcaMovil:{
				required:'Especificar Monto Máximo',	
				number : 'Sólo Números'
			},			
		}		
	});

	//------------ Validaciones de Controles -------------------------------------
	
});		

function consultaUsuaReg() {
	var numOperID = $('#limiteOperID').val();
		
	var tipConPantalla = 1;
	var limitesOperBen = {
		'limiteOperID' : numOperID
	};
	setTimeout("$('#cajaLista').hide();", 200);	
	if (numOperID != '' && !isNaN(numOperID) && esTab) { 
		
		if(numOperID =='0'){
			$("#formaGenerica").validate().resetForm();	
			$("#formaGenerica").find(".error").removeClass("error");			
			limpiaCampos();			
			habilitaControl('clienteID');
			$('#clienteID').focus();
			deshabilitaControl('bancaMovil1');
			deshabilitaControl('bancaMovil2');			
			deshabilitaBoton('grabar', 'submit');			
			deshabilitaBoton('modificar', 'submit');			
						
		}else{		
			$("#formaGenerica").validate().resetForm();	
			$("#formaGenerica").find(".error").removeClass("error");
			
			deshabilitaControl('bancaMovil1');
			deshabilitaControl('bancaMovil2');			
			deshabilitaBoton('grabar', 'submit');
			deshabilitaControl('clienteID');
		
			limiteOperClienteServicio.consulta(tipConPantalla, limitesOperBen,{ async: false, callback:
					function(conLimite){							
						if (conLimite != null){							
							$('#limiteOperID').val(conLimite.limiteOperID);
							$('#clienteID').val(conLimite.clienteID);
							$('#nombreCompleto').val(conLimite.nombreCompleto);
							$('#monMaxBcaMovil').val(conLimite.monMaxBcaMovil);							
							
							habilitaBoton('modificar', 'submit');
							habilitaControl('bancaMovil1');
							habilitaControl('bancaMovil2');	
							
							if (conLimite.bancaMovil == 'S') {					
								$('#bancaMovil1').attr('checked', true);
								$('#bancaMovil2').attr('checked', false);
								$('#trMontoMaxBcaMovil').show();
								$('#bancaMovil1').focus();
							}
							if (conLimite.bancaMovil == 'N') {					
								$('#bancaMovil1').attr('checked', false);
								$('#bancaMovil2').attr('checked', true);
								$('#trMontoMaxBcaMovil').hide();
								$('#bancaMovil2').focus();
							}						
																		
	
						} else {
							mensajeSis("No Existe Usuario");
							$('#solicitudCreditoID').focus();
							limpiaCampos();
							deshabilitaBoton('grabar', 'submit');
							deshabilitaBoton('modificar', 'submit');
							deshabilitaControl('clienteID');					
						}	
						
						
					}			
			});
		}		
		
	}
}


function consultaClientePantalla(){	
	var numCliente = $('#clienteID').val();		
	var tipConPantalla = 5;
	var rfc = ' ';

	setTimeout("$('#cajaLista').hide();", 200);
	if (numCliente != '' && !isNaN(numCliente) && esTab) { 
		clienteServicio.consulta(tipConPantalla,numCliente,rfc,{ async: false, callback:function(cliente){					
					if (cliente != null){										
						$('#clienteID').val(cliente.numero);
						$('#nombreCompleto').val(cliente.nombreCompleto);						
						
						if(cliente.estatus == 'A'){
							habilitaControl('bancaMovil1');
							habilitaControl('bancaMovil2');
							$('#bancaMovil2').focus();
							habilitaBoton('grabar', 'submit');	
						}
						
						if(cliente.estatus == 'I'){
							mensajeSis('El Cliente se encuentra Inactivo');							
							limpiaCampos();	
							deshabilitaControl('bancaMovil1');
							deshabilitaControl('bancaMovil2');
							deshabilitaBoton('grabar', 'submit');	
							deshabilitaBoton('modificar', 'submit');
							deshabilitaControl('clienteID');
						}						
						if(cliente.estatus == 'C'){
							mensajeSis('El Cliente se encuentra Cancelado');							
							limpiaCampos();	
							deshabilitaControl('bancaMovil1');
							deshabilitaControl('bancaMovil2');
							deshabilitaBoton('grabar', 'submit');	
							deshabilitaBoton('modificar', 'submit');
							deshabilitaControl('clienteID');
						}
						
						if(cliente.estatus == 'B'){
							mensajeSis('El Cliente se encuentra Bloqueado');							
							limpiaCampos();
							deshabilitaControl('bancaMovil1');
							deshabilitaControl('bancaMovil2');
							deshabilitaBoton('grabar', 'submit');	
							deshabilitaBoton('modificar', 'submit');
							deshabilitaControl('clienteID');
						}						
	
					} else {
						mensajeSis("No Existe el Cliente");						
						limpiaCampos();
						deshabilitaControl('bancaMovil1');
						deshabilitaControl('bancaMovil2');
						deshabilitaBoton('grabar', 'submit');	
						deshabilitaBoton('modificar', 'submit');
						deshabilitaControl('clienteID');						
											
					}						
					
				}		
		});
			
	}
}

function limpiaCampos(){
	inicializaForma('formaGenerica','limiteOperID');	
	$('#limiteOperID').focus();
	$('#limiteOperID').select();
	$('#clienteID').val('');
	$('#nombreCompleto').val('');	
	$('#trMontoMaxBcaMovil').hide();
	$('#monMaxBcaMovil').val('0.00');	
}

function funcionExito() {
	inicializaForma('formaGenerica','limiteOperID');	
    $('#clienteID').val('');
	$('#nombreCompleto').val('');	
	$('#trMontoMaxBcaMovil').hide();
	$('#monMaxBcaMovil').val('0.00');	
}

function funcionError() {	
	limpiaCampos();
}
