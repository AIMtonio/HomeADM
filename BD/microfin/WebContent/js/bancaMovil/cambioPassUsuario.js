$(document).ready(
		
		function() {
			$("#clienteID").focus();
			var parametroBean = consultaParametrosSession();
			
			

			//ACTIVO:0  || INACTIVO:1 || BLOQUEADO:2 || CANCELADO 3
			var catTipoActualizaUsuario = {
			  		'cambioPassword':4
				};
			
			var esTab = false;
			
			$('input, select').focus(function() {
				esTab = false;
			});

			$('input ,select').bind('keydown', function(e) {
				if (e.which == 9 && !e.shiftKey) {
					esTab = true;
				}
			});

			$('input ,select').blur(function() {
				if ($(this).attr('id') == $('#formaGenerica :input:enabled:visible:last').attr('id') && esTab) {
					setTimeout(function() {
						$('#formaGenerica :input:enabled:visible:first').focus();
					}, 0);
				}
			});
			// ------------------------- Metodos y Manejo de
						
			$('#actualizar').click(function() {
				var numero=$('#clienteID').val();
				$('#idClienteAux').val(numero);

				var pass=$('#nuevaContra').val();
				$('#newPassword').val(pass); 
				$('#tipoTransaccion').val(catTipoActualizaUsuario.cambioPassword); 
			});
			
			deshabilitaBoton('actualizar', 'submit');
			agregaFormatoControles('formaGenerica');

			$('#clienteID').blur(function() {
				validaUsuario('clienteID');
			});
			$('#Confirmacontra').blur(function() {
		  		validaNuevaContra(this.id);  
			});

			$('#clienteID').bind('keyup',function(e) {
				if ($('#clienteID').val().length < 3) {
					$('#cajaLista').hide();
				} else {
					lista('clienteID', '3', '1','clienteID',$('#clienteID').val(),'listaBAMUsuarios.htm');
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
										$('#telefono').val(usuarios.telefono);
										$('#contraseniaAnterior').val(usuarios.contrasenia);
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
					}
				}

			}

			$.validator.setDefaults({
				submitHandler : function(event) {
					grabaFormaTransaccionRetrollamada(event,'formaGenerica', 'contenedorForma','mensaje', 'true', 'clienteID','exitoTransUsuario', 'falloTransUsuario');
				}
			});

			// ------------ Validaciones de la Forma
			$('#formaGenerica').validate({
				rules: {
					clienteID: {
						required: true
					},
					nuevaContra: {
						required: true
					},
					Confirmacontra: {
						required : true
					}

					
				},
				messages: {
					clienteID: {
						required: 'Especifique cliente'
					},
					Confirmacontra: {
						required: 'Especifique contraseña'
					},
					nuevaContra: {
						required: 'Especifique contraseña'
					}
				}		
			});

		});//	FIN VALIDACIONES 

function validaNuevaContra(idControl) { 
	var jqconfContra = eval("'#" + idControl + "'");
	var confContra = $(jqconfContra).val();	
	var nContra= $('#nuevaContra').val();
	if(nContra != '' && confContra != ''){
		if(confContra!=nContra){    
			mensajeSis('Las contraseñas no coinciden');
			$('#nuevaContra').focus();
			$('#nuevaContra').val('');
			$('#Confirmacontra').val('');
			deshabilitaBoton('actualizar', 'submit');
		}else{
			habilitaBoton('actualizar', 'submit');
		}
	}
	
}


function limpiarDatos() {
	$('#email').val('');
	$('#Confirmacontra').val('');
	$('#nuevaContra').val('');
	$('#nombreCompleto').val('');
}

function exitoTransUsuario() {
	console.log("EXITO");
	$("#clienteID").val($('#idClienteAux').val());
	limpiarDatos();
	deshabilitaBoton('actualizar', 'submit');
	
}

function falloTransUsuario() {
	console.log("FALLO TRANSACCION USUARIO");
}
