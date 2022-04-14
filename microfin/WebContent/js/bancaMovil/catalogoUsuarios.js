var estatus;
var estatusSes;
var esTab = false;

$(document).ready(
		function() {
			
			consultaImagenes();
			var parametroBean = consultaParametrosSession();		
			
			$("#clienteID").focus();
			
			var catTipoTransaccionUsuario = {
					'agrega' : '1',
					'modifica' : '2'
			};
			
			deshabilitaBoton('modifica', 'submit');
			deshabilitaBoton('agrega', 'submit');
			agregaFormatoControles('formaGenerica');
			
			$('input, select').focus(function() {
				esTab = false;
			});

			$('input ,select').bind('keydown', function(e) {
				if (e.which == 9 && !e.shiftKey) {
					esTab = true;
				}
			});

			$('input ,select, radio').blur(function() {
				
				if ($(this).attr('id') == $('#formaGenerica :input:enabled:visible:last').attr('id') && esTab) {
					setTimeout(function() {
						$('#formaGenerica :input:enabled:visible:first').focus();
					}, 0);
				}
			});

			$('#clienteID').blur(function() {
				validaUsuario('clienteID');
			});

			$('#preguntaSecretaID').blur(
			function() {
				var idPregunta = $('#preguntaSecretaID').val();
				var clienteID = $('#clienteID').val();
					if (clienteID != '' && !isNaN(clienteID) ) {
						preguntaServicio.consulta(1,idPregunta,function(pregunta) {
							if (pregunta!= null ) {
								$('#redaccion').val(pregunta.redaccion);
							} else {
								mensajeSis("No Existe la Pregunta");
								$('#redaccion').val("");
								$('#preguntaSecretaID').val("");
								$('#preguntaSecretaID').focus();
							}
						});
					}
			});
			

			$('#clienteID').focus(function() {
				$('#nombreCompleto').val('');
			});

			
			$('#clienteID').bind('keyup',function(e) {
				if ($('#clienteID').val().length < 3) {
					$('#cajaLista').hide();
				} else {
					lista('clienteID', '3', '1','nombreCompleto',$('#clienteID').val(),'listaCliente.htm');
				}
			});
				
			
			$('#preguntaSecretaID').bind('keyup',function(e) {
					if ($('#preguntaSecretaID').val().length < 3) {
						$('#cajaLista').hide();
					} else {
						lista('preguntaSecretaID', '3', '1', 'redaccion', $('#preguntaSecretaID').val(),'listaPreguntas.htm');
					}
			});


			function validaUsuario(control) {
				
				var clienteID = $('#clienteID').val();
				
				if(clienteID == '0'){
					limpiarDatos();
					mensajeSis("Es requerido un número de cliente");
					return ;
				}
				
					if (clienteID != '' && !isNaN(clienteID)) {
						usuariosServicio.consultaUsuarios(1,clienteID,function(usuarios) {
							
									if (usuarios != null) {
										deshabilitaBoton('agrega', 'submit');
										
										$('#usuarioID').val(usuarios.usuarioID);
										$('#imei').val(usuarios.imei);
										$('#fechaCancel').val(usuarios.fechaCancel);
										$('#motivoCancel').val(usuarios.motivoCancel);
										$('#fechaBloqueo').val(usuarios.fechaBloqueo);
										$('#motivoBloqueo').val(usuarios.motivoBloqueo);
										$('#primerNombre').val(usuarios.primerNombre);
										$('#segundoNombre').val(usuarios.segundoNombre);
										$('#apellidoPaterno').val(usuarios.apellidoPaterno);
										$('#apellidoMaterno').val(usuarios.apellidoMaterno);
										$('#clienteID').val(usuarios.clienteID);
										$('#nombreCompleto').val(usuarios.nombreCompleto);
										$('#email').val(usuarios.email);
										$('#telefono').val(usuarios.telefono);
										$('#clave').val(usuarios.clave);
										$('#contrasenia').val(usuarios.contrasenia);
										$('#fraseBienvenida').val(usuarios.fraseBienvenida);
										$('#preguntaSecretaID').val(usuarios.preguntaSecretaID);
										$('#respuestaPregSecreta').val(usuarios.respuestaPregSecreta);
										$('#fechaUltimoAcceso').val(usuarios.fechaUltimoAcceso);
										$('#estatus').val(usuarios.estatus);
										$('#fechaCreacion').val(usuarios.fechaCreacion);
										$('#estatusSesion').val(usuarios.estatusSesion);
										$('#servicioBancaMov').val(usuarios.servicioBancaMov);
										$('#servicioBancaWeb').val(usuarios.servicioBancaWeb);
										$('#loginsFallidos').val(usuarios.loginsFallidos);
										$('#imagenPhishingID').val(usuarios.imgCliente);
										
										$('#contrasenia').val(usuarios.contrasenia);
										
										$('#imgCliente').attr("src","data:image/jpg;base64,"+usuarios.imgCliente);
										deshabilitaBoton('imgCliente', 'submit');
										deshabilitaControl('imgCliente');

										estatus = usuarios.estatus;
										if (estatus == 'A') {
											$('#estatus').val("ACTIVO");
										}else if (estatus == 'B') {
											$('#estatus').val("BLOQUEADO");
										} else {
											$('#estatus').val("CANCELADO");
										}
										
										estatusSes = usuarios.estatusSesion;
										if (estatusSes == 'A') {
											$('#estatusSesion').val("ACTIVO");
										}else if (estatusSes == 'I') {
											$('#estatusSesion').val("INACTIVO");
										} else {
											$('#estatusSesion').val("INACTIVO");
										}
										
										if(usuarios.servicioBancaWeb == "S"){
											$('#servicioBancaWebS').attr('checked', true);
										}else{
											$('#servicioBancaWebN').attr('checked', true);
										}
										if(usuarios.servicioBancaMov == "S"){
											$('#servicioBancaMovS').attr('checked', true);
										}else{
											$('#servicioBancaMovN').attr('checked', true);
										}
										
										var idPregunta = usuarios.preguntaSecretaID;
										preguntaServicio.consulta(1,idPregunta,function(pregunta) {
											
											if(pregunta != null){
												$('#redaccion').val(pregunta.redaccion);
											}
											
										});
										validador.resetForm();
										$('#contrasenia').attr('disabled', 'disabled');
										$('#telefono').attr('disabled','disabled');
										
										habilitaBoton('modifica','submit');
										$("#telefono").focus();

									} else {
										limpiarDatos();
										//Si no se encuentra en la tabla de usuarios  
										///Pero si se encuentra como un cliente
										clienteServicio.consulta(1,clienteID,function(cliente) {
											if (cliente != null) {
											mensajeSis("El cliente aún no cuenta con el servicio, a continuación puedes agregarlo");	
											habilitaBoton('agrega', 'submit');
											deshabilitaBoton('modifica', 'submit');
											$('#nombreCompleto').val(cliente.nombreCompleto);
											
											$('#primerNombre').val(cliente.primerNombre);
											$('#segundoNombre').val(cliente.segundoNombre);
											$('#apellidoPaterno').val(cliente.apellidoPaterno);
											$('#apellidoMaterno').val(cliente.apellidoMaterno);
											
											$('#email').val(cliente.correo);
											$('#telefono').val(cliente.telefonoCelular);
											$('#teléfono').focus();
											$('#teléfono').select();
											habilitaBoton('imgCliente', 'submit');
											habilitaControl('imgCliente');
											$("#imgCliente").removeAttr("disabled");
											 
											$('#contrasenia').removeAttr('disabled');
											$('#telefono').removeAttr('disabled');
											$('#estatus').val("ACTIVO");
											$('#estatusSesion').val("INACTIVO");
											
											$('#loginsFallidos').val("0");
											$("#fechaUltimoAcceso").val("1900-01-01");
											$("#fechaCreacion").val(parametroBean.fechaAplicacion);
											
											}else{
												mensajeSis("El cliente no existe");
												$('#clienteID').val('');
												$('#clienteID').focus();
												deshabilitaBoton('agrega', 'submit');
												deshabilitaBoton('modifica', 'submit');
												limpiarDatos();
												$('#clienteID').val('');
											}
										});									
									} 
								});
					}else{
						$('#clienteID').val('');
						limpiarDatos();
					}				
			}

			$('#agrega').attr('tipoTransaccion', '1');
			$('#modifica').attr('tipoTransaccion', '2');

			$('#agrega').click(
					function() {
						$('#tipoTransaccion').val(catTipoTransaccionUsuario.agrega);
						$('#estatus').val("A");
						$('#estatusSesion').val("I");
						
						estatus = $('#estatus').val();
						estatusSes = $('#estatusSesion').val();
					});

			$('#modifica').click(
					function() {
						$('#tipoTransaccion').val(catTipoTransaccionUsuario.modifica);
						
						estatus = $('#estatus').val();
						if (estatus == 'ACTIVO') {
							$('#estatus').val("A");
						}else if (estatus == 'BLOQUEADO') {
							$('#estatus').val("B");
						} else {
							$('#estatus').val("C");
						}
						
						estatusSes = $('#estatusSesion').val();
						if (estatusSes == 'ACTIVO') {
							$('#estatusSesion').val("A");
						}else if (estatusSes == 'INACTIVO') {
							$('#estatusSesion').val("I");
						} else {
							$('#estatusSesion').val("I");
						}
						
					});

			$.validator.setDefaults({
				submitHandler : function(event) {
					grabaFormaTransaccionRetrollamada(event,'formaGenerica', 'contenedorForma','mensaje', 'true', 'clienteID','exitoTransUsuario', 'falloTransUsuario');
				},
				invalidHandler: function(event, validator) {
					falloTransUsuario();
				}
				
			});

			// ------------ Validaciones de la Forma
			var validador =$('#formaGenerica').validate({
				rules : {
					preguntaSecretaID :{
						required: true
					},
					respuestaPregSecreta :{
						required: true
					},
					clienteID :{
						required: true
					},
					primerNombre :{
						required: true
					},
					apellidoPaterno :{
						required: true
					},
					clave :{
						required: true
					},
					contrasenia :{
						required: true
					},
					fraseBienvenida :{
						required: true
					},
					telefono :{
						required: true
					},
					email :{
						required: true
					}
				},

				messages : {
					preguntaSecretaID :{
						required: "Especificar número de pregunta secreta."
					},
					respuestaPregSecreta :{
						required: "Especificar la respuesta de pregunta secretas."
					},
					clienteID :{
						required: "Especificar el número de cliente."
					},
					primerNombre :{
						required: "Especificar el primer nombre."
					},
					apellidoPaterno :{
						required: "Especificar el apellido paterno."
					},
					clave :{
						required: "Especificar la clave de usuario"
					},
					contrasenia :{
						required: "Especificar la contraseña de usuario."
					},
					fraseBienvenida :{
						required: "Especificar la frase de bienvenida."
					},
					telefono :{
						required: "Especificar el teléfono de usuario."
					},
					email :{
						required: "Especificar el email de usuario."
					}
				}
			});
		}
);

function limpiarDatos() {

	$('#imei').val("");
	$('#fechaCancel').val("");
	$('#motivoCancel').val("");
	$('#fechaBloqueo').val("");
	$('#motivoBloqueo').val("");
	$('#primerNombre').val("");
	$('#segundoNombre').val("");
	$('#apellidoPaterno').val("");
	$('#apellidoMaterno').val("");
	$('#nombreCompleto').val("");
	$('#email').val("");
	$('#telefono').val("");
	$('#clave').val("");
	$('#contrasenia').val("");
	$('#fraseBienvenida').val("");
	$('#preguntaSecretaID').val("");
	$('#respuestaPregSecreta').val("");
	$('#fechaUltimoAcceso').val("");
	$('#estatus').val("");
	$('#fechaCreacion').val("");
	$('#estatusSesion').val("");
	$('#servicioBancaMov').val("");
	$('#servicioBancaWeb').val("");
	$('#loginsFallidos').val("");
	$('#imagenPhishingID').val("");
	$('#contrasenia').val("");
	$('#estatus').val("");
	$('#estatusSesion').val("");
	$('#servicioBancaWebN').attr('checked', true);
	$('#servicioBancaMovN').attr('checked', true);
	$('#nombrePerfil').val("");
	$('#redaccion').val("");
	$('#imgCliente').attr("src","images/usuario_defecto.png");
}

function habilitaControles() {
	habilitaControl('email');
	habilitaControl('telefono');
	habilitaControl('fechaUltimoAcceso');
	habilitaControl('fechaCancelacion');
	habilitaControl('fechaBloqueo');
	habilitaControl('motivoBloqueo');
	habilitaControl('motivoCancelacion');
	habilitaControl('fechaCreacion');
	habilitaControl('respuestaPregSecreta');
	habilitaControl('preguntaSecretaID');
	habilitaControl('imagenPhishingID');
	habilitaControl('tokenID');
	habilitaControl('imagenLoginID');
}

function deshabilitaControles() {
	deshabilitaControl('fechaUltimoAcceso');
	deshabilitaControl('estatus');
	deshabilitaControl('fechaCreacion');
	deshabilitaControl('clienteID');
	deshabilitaControl('nombreCompleto');
	deshabilitaControl('folioSerie');
	deshabilitaControl('nombrePerfil');
}

function exitoTransUsuario() {
	inicializaForma("formaGenerica", "clienteID");
	limpiarDatos();
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
}

function falloTransUsuario() {
	
	if (estatus == 'A') {
		$('#estatus').val("ACTIVO");
	}else if (estatus == 'B') {
		$('#estatus').val("BLOQUEADO");
	} else {
		$('#estatus').val("CANCELADO");
	}
	
	if (estatusSes == 'A') {
		$('#estatusSesion').val("ACTIVO");
	}else if (estatusSes == 'I') {
		$('#estatusSesion').val("INACTIVO");
	} else {
		$('#estatusSesion').val("INACTIVO");
	}
}

function cambiarImagen(imagenID){
	$('#imgCliente').attr("src","data:image/jpg;base64,"+imagenID);
	$('#imagenPhishingID').val(imagenID);
}

$( "#imgCliente" ).click(function() {
	  if ( $('#imgCliente').is('[disabled]') ){
		  mensajeSis('Personalize su imagen desde su banca móvil para una mejor experiencia');
	  }else{
		  registrarImagen();
	  }
	});

function registrarImagen() {
	$('#conteImagenPhishing').html(); 
	$.blockUI({message: $('#conteImagenPhishing'),
		   css: { 
			   top:  	($(window).height())/5 + 'px', 
			   left:	100 + 'px', 
			   width: 	($(window).width())-200 + 'px'
		   	} 
	});
	$('#conteImagenPhishing').attr('title','Clic para Desbloquear').click($.unblockUI);
}

function consultaImagenes(){
	var params = {};		
	params['tipoLista'] = 1;
	params['identificador'] = 2;
	$.post("listaImagenesAnt.htm", params, function(data){		
				$('#conteImagenPhishing').html(data);
	});
}	
