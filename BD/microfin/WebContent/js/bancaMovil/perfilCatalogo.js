$(document).ready(
		function() {

			var parametroBean = consultaParametrosSession();

			$("#perfilID").focus();
			// Definicion de Constantes y Enums
			var catTipoTransaccionPerfil = {
					'agrega' : '1',
					'modifica' : '2'
			};

			var catTipoConsultaPerfil = {
					'principal' : '1'
			};

			// ------------------------- Metodos y Manejo de
			// Eventos-----------------------------------------
			deshabilitaBoton('modifica', 'submit');
			deshabilitaBoton('agrega', 'submit');
			agregaFormatoControles('formaGenerica');

			$('#perfilID').blur(function() {
				validaPerfil('perfilID');
				$('#cajaLista').hide();
			});

			$('#perfilID').bind('keyup',function(e) {
						if ($('#perfilID').val().length < 3) {
							$('#cajaLista').hide();
						} else {
							lista('perfilID', '3', '1', 'nombrePerfil', $('#perfilID').val(),'listaPerfiles.htm');
						}
					});

			function validaPerfil(control) {
				var numPerfil = $('#perfilID').val();
				if (numPerfil == '0') {
					habilitaBoton('agrega', 'submit');
					deshabilitaBoton('modifica', 'submit');
					$('#nombrePerfil').val('');
					$('#descripcion').val('');
					$('#costoPrimeraVez').val('');
					$('#costoMensual').val('');
					$('#accesoConToken').val('N');
					$('#transacConToken').val('N');
				} else {
					deshabilitaBoton('agrega', 'submit');
					if (numPerfil != '' && !isNaN(numPerfil)) {
						perfilServicio.consulta(1, numPerfil,function(perfil) {
							if (perfil != null) {	
								$('#perfilID').val(perfil.perfilID);
								$('#nombrePerfil').val(perfil.nombrePerfil);
								$('#descripcion').val(perfil.descripcion);
								$('#costoPrimeraVez').val(perfil.costoPrimeraVez);
								$('#costoMensual').val(perfil.costoMensual);

								if (perfil.accesoConToken == 'S') {
									$('#accesoConToken1').attr('checked', true);
								} else {
									$('#accesoConToken2').attr('checked', true);
								}

								if (perfil.transacConToken == 'S') {
									$('#transacConToken1').attr('checked', true);
								} else {
									$('#transacConToken2').attr('checked', true);
								}

								habilitaBoton('modifica', 'submit');

							} else {
								mensajeSis("No Existe el perfil");
								$('#perfilID').val('');
								$("#perfilID").focus();
							}
						});
							
						
					}else{
						$('#perfilID').val('');
						limpiarDatos();
					}
				}

			}

			$('#agrega').attr('tipoTransaccion', '1');
			$('#modifica').attr('tipoTransaccion', '2');

			$('#agrega').click(function() {
				console.log("Se pulso agregar");
				$('#tipoTransaccion').val(catTipoTransaccionPerfil.agrega);

			});

			$('#modifica').click(function() {
				console.log("Se pulso modificar");
				$('#tipoTransaccion').val(catTipoTransaccionPerfil.modifica);
			});

			$.validator.setDefaults({
				submitHandler : function(event) {
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','perfilID', 'exitoTransPerfil','falloTransPerfil');
					parametroBean = consultaParametrosSession();
				}
			});

			// ------------ Validaciones de la Forma
			$('#formaGenerica').validate({
				rules : {
					perfilID : {
						required : false,
					},

					nombrePerfil : {
						required : true,
						minlength : 2
					},

					descripcion : {
						required : true,
						minlength : 10
					},

					costoPrimeraVez : {
						required : true,
					},

					costoMensual : {
						required : true,
					},

					accesoConToken : {
						required : true,
					},

					transacConToken : {
						required : true,
					},
				},

				messages : {
					perfilID: {
						required : 'Campo requerido'
					},
					
					nombrePerfil : {
						required : 'Especificar nombre',
						minlength : 'Al menos dos Caracteres'
					},
					descripcion : {
						required : 'Especifique una descripcion',
						minlength : 'Al menos 10 Caracteres'
					},
					costoPrimeraVez : {
						required : 'Especifique costo primera vez puede ser 0'
					},
					costoMensual : {
						required : 'Especifique costo primera vez puede ser 0'
					},
					accesoConToken : {
						required : 'Especifique',
					},
					TransacConToken : {
						required : 'Especifique',
					}
				}
			});

		});// FIN VALIDACIONES

function limpiarDatos() {
	$('#nombrePerfil').val('');
	$('#descripcion').val('');
	$('#costoPrimeraVez').val('');
	$('#costoMensual').val('');
	$('#accesoConToken').val('N');
	$('#transacConToken').val('N');
}

function exitoTransPerfil() {
	console.log("EXITO");
	inicializaForma("formaGenerica", "perfilID");
	limpiarDatos();
	
}

function falloTrasPerfil() {
	console.log("FALLO");
}
