$(document).ready(
		function() {
			$("#clienteID").focus();
			var parametroBean = consultaParametrosSession();	
			$('#estatus').attr("disabled",true);
			$('#nombreCompleto').attr("disabled",true);
			$('#email').attr("disabled",true);
			$('#fechaBloqueo').attr("disabled",true);

			$('input, select').focus(function() {
				esTab = false;
			});

			$('input ,select').bind('keydown', function(e) {
				if (e.which == 9 && !e.shiftKey) {
					esTab = true;
				}
			});

			$('input ,select, textarea').blur(function() {
				if ($(this).attr('id') == $('#formaGenerica :input:enabled:visible:last').attr('id') && esTab) {
					setTimeout(function() {
						$('#formaGenerica :input:enabled:visible:first').focus();
					}, 0);
				}
			});


			//ACTIVO:1  || INACTIVO:2 || BLOQUEADO:3 || CANCELADO 4
			var catTipoActualizaUsuario = {
			  		'bloqueado_activo':8,
			  		'activo_bloqueado':7
				};

			var bloqueado ='B';
			// ------------------------- Metodos y Manejo de
			// Eventos-----------------------------------------

			$.validator.setDefaults({
	            submitHandler : function(event) { 
	                    grabaFormaTransaccionRetrollamada(event,'formaGenerica', 'contenedorForma','mensaje', 'true', 'clienteID',"exitoTransUsuario", 'falloTransUsuario');
	            }
			});	
			$('#formaGenerica').validate({
				rules: {
					estatus: {
						required: true
					}
					
				},
				messages: {
					estatus: {
						required: 'Especificar Estatus'
					}
				}		
			});
			$('#clienteID').bind('keyup',function(e) {
				if ($('#clienteID').val().length < 3) {
				} else {
					lista('clienteID', '3', '1','clienteID',$('#clienteID').val(),'listaBAMUsuarios.htm');
				}
			});
						
			$('#actualiza').click(function() {

				var numero=$('#clienteID').val();
				$('#idClienteAux').val(numero);
				var statusFinal = $('#estatusFinal').val();
				if(statusFinal==bloqueado){
				$('#tipoTransaccion').val(catTipoActualizaUsuario.activo_bloqueado);
				}else{				
				$('#tipoTransaccion').val(catTipoActualizaUsuario.bloqueado_activo);
				$('#fechaBloqueo').val('');
				$('#motivoBloqueo').val('');
	
				}
			});
			
			$('#estatusFinal').mouseout(function() {
				var status = $('#estatusFinal').val();
		  		if(status == bloqueado){
		  			$('#bloqueolblfe').show();
		  			$('#bloqueoinfe').show();
		  			$('#bloqueoUserMotivo').show();
		  			$('#bloqueoUserM').show();
		  		}else{
		  			$('#bloqueolblfe').hide();
		  			$('#bloqueoinfe').hide();
		  			$('#bloqueoUserMotivo').hide();
		  			$('#bloqueoUserM').hide();				
		  		}  
			});	
			
			deshabilitaBoton('actualiza', 'submit');
			agregaFormatoControles('formaGenerica');

			$('#clienteID').blur(function() {
				validaUsuario('clienteID');
			});
			
			$('#estatusFinal').change(function(){
				var estatusActual = $('#estatus').val();
				var estatusFinal = $('#estatusFinal').val();

				if (estatusFinal == estatusActual){
					deshabilitaBoton('actualiza', 'submit');	
				}else {
					habilitaBoton('actualiza', 'submit');	
				}
			});


			function validaUsuario(control) {
				var usuarioID = $('#clienteID').val();
				if (usuarioID == '0') {
					limpiarDatos();
				} else {					

					if (usuarioID != '' && !isNaN(usuarioID)) {
						usuariosServicio.consultaUsuarios(1,usuarioID,function(usuarios) {
									if (usuarios != null) {
										$('#email').val(usuarios.email);							
										$('#fechaUltimoAcceso').val(usuarios.fechaUltimoAcceso);
										$('#fechaBloqueo').val(usuarios.fechaBloqueo);
										$('#motivoBloqueo').val(usuarios.motivoBloqueo);
										$('#estatusFinal').attr("disabled",false);
										// CARGAR EL ESTATUS DEL
										// USUARIO
										status = usuarios.estatus;										
										if (status == 'A') {
								  			$('#bloqueolblfe').hide();
								  			$('#bloqueoinfe').hide();
								  			$('#bloqueoUserMotivo').hide();
								  			$('#bloqueoUserM').hide();
											$('#estatus').val("A");
											//$('#estatus').attr("disabled",false);
											$('#estatus> option[value="A"]').attr('selected', true);
											$('#fechaBloqueo').val(parametroBean.fechaSucursal);
										} else if (status == 'B') {
								  			$('#bloqueolblfe').show();
								  			$('#bloqueoinfe').show();
								  			$('#bloqueoUserMotivo').show();
								  			$('#bloqueoUserM').show();
								  			//	$('#estatus').attr("disabled",false);
											$('#estatus').val("B");
											$('#estatus> option[value="B"]').attr('selected', true);
										} else if(status == 'I'){
											mensajeSis('El usuario no se puede bloquear, actualmente se encuentra inactivo');
								  			$('#estatus').attr("disabled",true);   
								  			deshabilitaBoton('actualiza', 'submit');	
								  			$('#estatus').val("I");
											deshabilitaBoton('actualiza', 'submit');
											
										}else{
											mensajeSis('El usuario no se puede bloquear, actualmente se encuentra cancelado');
								  			$('#estatus').attr("disabled",true); 
								  			$('#estatusFinal').attr("disabled",true); 
								  			deshabilitaBoton('actualiza', 'submit');	
										}

											
										// CARGAR EL NOMBRE DEL CLIENTE
										var idCliente = usuarios.clienteID;
										clienteServicio.consulta(1,idCliente,function(cliente) {
											$('#nombreCompleto').val(cliente.nombreCompleto);
												});
									} else {
										mensajeSis("No Existe el usuario");
										limpiarDatos();
										$("#clienteID").focus();
									}
								});
					}else{
						$('#clienteID').val('');
						limpiarDatos();
					}
				}

			}

			// ------------ Validaciones de la Forma
			$('#formaGenerica').validate({
				rules: {
					estatus: {
						required: true
					},
					motivoBloqueo: {
						required : function() {return $('#estatus').val() == 'B';},
					}

					
				},
				messages: {
					estatus: {
						required: 'Especificar Estatus'
					},
					motivoBloqueo: {
						required: 'Especificar Motivo de Bloqueo'
					}
				}		
			});

		});//	FIN VALIDACIONES 

function limpiarDatos() {	
	$('#email').val('');
	$('#fechaUltimoAcceso').val('');
	$('#fechaBloqueo').val('');
	$('#estatus').val('');
	$('#estatusFinal').val('');
	$('#motivoBloqueo').val('');
	$('#nombreCompleto').val('');
}

function exitoTransUsuario() {
	limpiarDatos();
	deshabilitaBoton('actualiza', 'submit');
}

function falloTransUsuario() {
	console.log("FALLO TRANSACCION USUARIO");
}


