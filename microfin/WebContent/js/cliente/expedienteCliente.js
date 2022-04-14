$(document).ready(function() {
	
	/*   ============ METODOS  Y MANEJO DE EVENTOS =============   */
	$('#clienteID').focus();
	/* consulta parametros de usuario y sesion */
	var parametrosBean = consultaParametrosSession();
	
	$("#usuarioID").val(parametrosBean.numeroUsuario);
	var fechaSistema = parametrosBean.fechaAplicacion;
	/*le da formato de moneda, calendario, etc */
	agregaFormatoControles('formaGenerica');
	
	deshabilitaBoton('grabar', 'submit');
	
	var tipoTransaccion= {
			'alta' : '1'
		};
	
	/* lista de ayudas para clientes */			
	$('#clienteID').bind('keyup',function(e) { 
		lista('clienteID', '2', '9', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#buscarMiSuc').click(function(){
		listaCte('clienteID', '3', '25', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	$('#buscarGeneral').click(function(){
		listaCte('clienteID', '3', '9', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	$('#clienteID').blur(function() {	
		var cliente=$('#clienteID').val();
		if(cliente !='' && !isNaN(cliente) ){
			 var LongCliente=$('#clienteID').val().length;
			 if(LongCliente>11){
				 var maxLongCliente=$('#clienteID').val();
				 var max=maxLongCliente.substring(0,10);
				 $('#clienteID').val(max);
			 }
		} 
  		consultaCliente(this.id);
	});
	
	/*asigna el tipo de transaccion */
	$('#grabar').click(function() {	
		$('#tipoTransaccion').val(tipoTransaccion.alta);
	});
	
	
	/*esta funcion esta en forma.js, verifica que el mensaje d error o exito aparezcan correctamente y que realizara despues de cada caso */
	$.validator.setDefaults({		
	    submitHandler: function(event) { 
			var confirmar = confirm('Confirmar Actualización de Expediente.');
			if(confirmar){
		    		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','clienteID',
			    			'funcionExitoTransaccion','funcionFalloTransaccion'); 
		    }
		}
	 });
	
	/* =============== VALIDACIONES DE LA FORMA ================= */
		$('#formaGenerica').validate({			
			rules: {
				clienteID :{
					required:true,
				}
			},		
			messages: {
				clienteID :{
					required:'Especificar Socio',
				}
			}		
		});
		
		/* =================== FUNCIONES ========================= */
			

				/* Consulta el cliente */
				function consultaCliente(idControl) {
					var jqCliente = eval("'#" + idControl + "'");
					var numCliente = $(jqCliente).val();
					var numConsulta = 1;
					var clienteActivo ='A';
					setTimeout("$('#cajaLista').hide();", 200);
					
					// si no esta vacio es un numero ejecutara la consulta del cliente
					if (numCliente != '' && !isNaN(numCliente)) {
					
						//constulta un cliente
						clienteServicio.consulta(numConsulta, numCliente, function(cliente) {
							//si el resultado obtenido de la consulta regreso un resultado
							if (cliente != null) {
								if(cliente.estatus == clienteActivo){
									inicializaForma('formaGenerica', 'clienteID');	
									habilitaBoton('grabar', 'submit');
										$("#clienteID").val(cliente.numero);
										$("#clienteIDDes").val(cliente.nombreCompleto);
										$("#sucursalOrigen").val(cliente.sucursalOrigen);
										$("#RFC").val(cliente.RFC);								
										$("#CURP").val(cliente.CURP);
										$("#razonSocial").val(cliente.razonSocial);
										$("#fechaNacimiento").val(cliente.fechaNacimiento);
										$("#fechaIngreso").val(cliente.fechaAlta);
										$("#edad").val(cliente.edad);
										$("#estatus").val('ACTIVO');
																		
										switch(cliente.tipoPersona ) {
										case 'M':
											$("#tipoPersona").val('MORAL');
											$("#trRazonSocial").show();
										    break;
										case 'A':
											$("#tipoPersona").val('FÍSICA CON ACTIVIDAD EMPRESARIAL');
											$("#trRazonSocial").hide();
										    break;
										case 'F':
											$("#tipoPersona").val('FÍSICA');
											$("#trRazonSocial").hide();
										    break;
										}									
										consultaSucursalOrigen(cliente.sucursalOrigen);
								  		consultaExpediente(cliente.numero);
									}
									else{
										inicializaForma('formaGenerica', 'clienteID');	
										$("#clienteID").focus();
										$("#clienteID").val('');
										$("#clienteIDDes").val('');
										mensajeSis("El Socio No esta Activo.");										
										deshabilitaBoton('grabar', 'submit');
									}
							}
							else{
								inicializaForma('formaGenerica', 'clienteID');	
								$("#clienteID").focus();
								$("#clienteID").val('');
								$("#clienteIDDes").val('');
								mensajeSis("El Socio No existe.");								
								deshabilitaBoton('grabar', 'submit');								
							}
						});
						
					}
				}
				
				
				/* Consulta la sucursal  */
				function consultaSucursalOrigen(numSucursal) {		
					var tipoConsulta = 2;
					setTimeout("$('#cajaLista').hide();", 200);
					
					if (numSucursal != '' && !isNaN(numSucursal)) {			
						sucursalesServicio.consultaSucursal(tipoConsulta,numSucursal, function(sucursal) {
							if (sucursal != null) {
								$('#sucursalOrigen').val(sucursal.sucursalID);	
									$('#sucursalOrigenDes').val(sucursal.nombreSucurs);	
								
							} else {
								mensajeSis("La Sucursal No Existe.");
								$('#sucursalOrigenDes').val('');
							}
						});
					}
				}
				
				/* Consulta el expediente del Cliente */
				function consultaExpediente(numCliente) {
					var tipoConsulta = 1;
					var beanCliente = {
						'clienteID' : numCliente
					}
					setTimeout("$('#cajaLista').hide();", 200);				
					
					if (numCliente != '' && !isNaN(numCliente)) {
						expedienteCliente.consulta(beanCliente, tipoConsulta, function(expediente) {
							if (expediente != null) {
								$('#fechaExp').val(expediente.fechaExpediente);
								$('#usuarioNom').val(expediente.usuarioNombre);	
								if(validaAnios(fechaSistema,expediente.fechaExpediente)){
									deshabilitaBoton('grabar', 'submit');
								} else {
									habilitaBoton('grabar', 'submit');
								}
							} else {
								$('#fechaExp').val('');
								$('#usuarioNom').val('');
								mensajeSis("Aún no se Actualiza el Expediente del Cliente.");								
							}
						});
					}
				}
				
	
});

function validaAnios(fechaAplicacion, fechaExpediente){
	//0|1|2|3|4|5|6|7|8|9|
	//2 0 1 2 / 1 1 / 2 0
	var xAnio=fechaAplicacion.substring(0,4);

	var yAnio=fechaExpediente.substring(0,4);
	var anios = xAnio - yAnio;
	if(anios<=1){
		return true;
	}else{
		return false;
	}
}

function funcionExitoTransaccion(){
	$('#clienteID').focus();
	deshabilitaBoton('grabar', 'submit');
}

function funcionFalloTransaccion(){
	//inicializaForma('formaGenerica', 'clienteID');
}