var esTab = false;

$(document).ready(
		
		function() {
			$("#clienteID").focus();
			var parametroBean = consultaParametrosSession();
			deshabilitaBoton('cancelar', 'submit');	
			ocultaEtiquetas();
			//ACTIVO:0  || INACTIVO:1 || BLOQUEADO:2 || CANCELADO 3
			var catTipoActualizaUsuario = {
					'activo':11,
			  		'cancelado':10
				};

			var cancelado ='C';
			// ------------------------- Metodos y Manejo de
			// Eventos-----------------------------------------

			$.validator.setDefaults({
	            submitHandler: function(event) { 
	                    grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','clienteID'); 
	            }
			});
			
			$('#cancelar').click(function() {
				var numero=$('#clienteID').val();
				$('#idClienteAux').val(numero);
				var status = $('#estatus').val();
				if(status==cancelado){
					$('#tipoTransaccion').val(catTipoActualizaUsuario.cancelado);
					}else{
					$('#fechaCancelacion').val('');
					$('#motivoCancelacion').val('');
					$('#tipoTransaccion').val(catTipoActualizaUsuario.activo);	
					} 
			});
			
			$('#estatus').mouseout(function() {
				var status = $('#estatus').val();
		  		if(status == cancelado){
		  		muestraEtiquetas();
		  		//habilitaBoton('cancelar');
		  		}else{
		  		ocultaEtiquetas();
		  		}  
			});	
			
			deshabilitaBoton('cancelar', 'submit');
			agregaFormatoControles('formaGenerica');
			
			
			$('input, select').focus(function() {
				esTab = false;
			});

			$('input ,select').bind('keydown', function(e) {
				if (e.which == 9 && !e.shiftKey) {
					esTab = true;
				}
			});

			$('input, select, textarea').blur(function() {
				
				if ($(this).attr('id') == $('#formaGenerica :input:enabled:visible:last').attr('id') && esTab) {
					setTimeout(function() {
						$('#formaGenerica :input:enabled:visible:first').focus();
					}, 0);
				}
			});
			
			$('#clienteID').blur(function() {
				validaUsuario('clienteID');
			});

			$('#clienteID').bind('keyup',function(e) {
				if ($('#clienteID').val().length < 3) {
					$('#cajaLista').hide();
				} else {
					lista('clienteID', '3', '1', 'clienteID',$('#clienteID').val(),'listaBAMUsuarios.htm');
				}
			});

			var estatusActual = '';

				$('#estatus').change(function(){
					
					habilitaBoton('cancelar', 'submit');
					
					estatus = $('#estatus').val();
					estatusActual = estatus;
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
										$('#fechaCancelacion').val(usuarios.fechaCancel);
										$('#motivoCancelacion').val(usuarios.motivoCancel);

										// CARGAR EL ESTATUS DEL
										// USUARIO
										status = usuarios.estatus;	
																			
										if (status == 'A') {	
											ocultaEtiquetas();
											$('#estatus').attr("disabled",false);
											$('#estatus').val("A");
											$('#estatus> option[value="A"]').attr('selected', true);
										} else if (status == 'B') {
											muestraEtiquetas();
								  			$('#estatus').attr("disabled",false);
											$('#estatus').val("B");
											$('#estatus> option[value="B"]').attr('selected', true);
											$('#motivoCancelacion').val('');
											$('#fechaCancelacion').val('');
										} else if(status == 'I'){
											muestraEtiquetas();
								  			$('#estatus').attr("disabled",false);
											$('#estatus').val("C");
											$('#estatus> option[value="C"]').attr('selected', true);
											$('#motivoCancelacion').val('');
											$('#fechaCancelacion').val('');
										}else if (status == 'C'){
											muestraEtiquetas();
											$('#estatus').attr("disabled",false);
											$('#estatus').val("C");
											$('#estatus> option[value="C"]').attr('selected', true);


										}
										// CARGAR EL NOMBRE DEL CLIENTE
										var idCliente = usuarios.clienteID;
										clienteServicio.consulta(1,idCliente,function(cliente) {
											$('#nombreCompleto').val(cliente.nombreCompleto);
										});
										
										deshabilitaBoton('cancelar', 'submit');	
										
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

			$.validator.setDefaults({
				submitHandler : function(event) {
					grabaFormaTransaccionRetrollamada(event,'formaGenerica', 'contenedorForma','mensaje', 'true', 'clienteID','exitoTransUsuario', 'falloTransUsuario');
				}
			});

			// ------------ Validaciones de la Forma
			$('#formaGenerica').validate({
				rules: {
					estatus: {
						required: true
					},
					motivoCancelacion: {
						required : function() {return $('#estatus').val() == 'C';},
					}

					
				},
				messages: {
					estatus: {
						required: 'Especificar Estatus'
					},
					motivoCancelacion: {
						required: 'Especificar Motivo de cancelación'
					}
				}		
			});

		});//	FIN VALIDACIONES 


function ocultaEtiquetas() {
	$('#motInfo').hide();
	$('#fechInfo').hide();
	$('#fechaCancelacion').hide();
	$('#motivoCancelacion').hide();
	$('#motivoCancelacion').val('');
	$('#fechaCancelacion').val('');
}
function muestraEtiquetas() {
	$('#fechaCancelacion').show();
	$('#motivoCancelacion').show();
	$('#motInfo').show();
	$('#fechInfo').show();
	
	if($("#fechaCancelacion").val() === ""){
		$("#fechaCancelacion").val(parametroBean.fechaAplicacion);
	}
	
}
function limpiarDatos() {
	$('#email').val('');
	$('#fechaUltimoAcceso').val('');
	$('#fechaCancelacion').val('');
	$('#estatus').val('');
	$('#motivoCancelacion').val('');
	$('#nombreCompleto').val('');
}

function exitoTransUsuario() {
	estatusActual = $("#estatus").val();
	$("#clienteID").val($('#idClienteAux').val());
	limpiarDatos();
	deshabilitaBoton('cancelar', 'submit');	
}

function falloTransUsuario() {
	console.log("FALLO TRANSACCION USUARIO");
}
