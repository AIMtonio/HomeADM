$(document).ready(
		function() {
		
			var esTab = true;
			
			var parametroBean = consultaParametrosSession();	
			
			$("#preguntaSecretaID").focus();

			// Definicion de Constantes y Enums
			var catTipoTransaccionPregunta = {
					'agrega' : '1',
					'modifica' : '2'
			};
			
			$(':text').focus(function() {
				esTab = false;
			});

			$(':text').bind('keydown', function(e) {
				if (e.which == 9 && !e.shiftKey) {
					esTab = true;
				}
			});
			
			$('input , textarea').blur(function() {
				
				if ($(this).attr('id') == $('#formaGenerica :input:enabled:visible:last').attr('id') && esTab) {
					setTimeout(function() {
						$('#formaGenerica :input:enabled:visible:first').focus();
					}, 0);
				}
			});

			// ------------------------- Metodos y Manejo de
			// Eventos-----------------------------------------
			deshabilitaBoton('modifica', 'submit');
			$("#preguntaSecretaID").val("0");
			//deshabilitaBoton('agrega', 'submit');
			agregaFormatoControles('formaGenerica');

			$('#preguntaSecretaID').blur(function() {
				validaPregunta('preguntaSecretaID');
			});

			$('#preguntaSecretaID').bind('keyup',function(e) {
						if ($('#preguntaSecretaID').val().length < 3) {
							$('#cajaLista').hide();
						} else {
							lista('preguntaSecretaID', '3', '1', 'redaccion', $('#preguntaSecretaID').val(),'listaPreguntas.htm');
						}
					});

			function validaPregunta(control) {
				var numPregunta = $('#preguntaSecretaID').val();
				if (numPregunta == '0') {
					habilitaBoton('agrega', 'submit');
					deshabilitaBoton('modifica', 'submit');
					$('#redaccion').val('');
				} else {
					deshabilitaBoton('agrega', 'submit');

					if (numPregunta != '' && !isNaN(numPregunta)) {
						preguntaServicio.consulta(1, numPregunta,function(pregunta) {
							if (pregunta != null) {
								$('#preguntaSecretaID').val(pregunta.preguntaSecretaID);
								$('#redaccion').val(pregunta.redaccion);
								
								habilitaBoton('modifica', 'submit');

							} else {
								mensajeSis("La Pregunta no existe");
								limpiarDatos();
								$('#preguntaSecretaID').val('');
								$("#preguntaSecretaID").focus();
							}
						});
					}
					else {
						
						limpiarDatos();
					}
				}
			}

			$('#agrega').attr('tipoTransaccion', '1');
			$('#modifica').attr('tipoTransaccion', '2');

			$('#agrega').click(function() {
				$('#tipoTransaccion').val(catTipoTransaccionPregunta.agrega);

			});

			$('#modifica').click(function() {
				$('#tipoTransaccion').val(catTipoTransaccionPregunta.modifica);
			});

			$.validator.setDefaults({
				submitHandler : function(event) {
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','preguntaSecretaID', 'exitoTransPregunta','falloTrasPregunta');
				}
			});

			// ------------ Validaciones de la Forma
			$('#formaGenerica').validate({
				rules : {
					preguntaSecretaID : {
						required : false,
					},

					redaccion : {
						required : true,
						minlength : 15
					},
				},

				messages : {
					preguntaSecretaID: {
						required : 'Campo requerido'
					},
					
					redaccion : {
						required : 'Demasiado corto',
						minlength : 'Al menos 15 caracteres'
					},				
				}
			});

		});// FIN VALIDACIONES

function limpiarDatos() {
	$('#preguntaSecretaID').val('');
	$('#redaccion').val('');
}

function exitoTransPregunta() {
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');
	inicializaForma("formaGenerica", "preguntaSecretaID");
	
}

function falloTrasPregunta() {
	console.log("FALLO");
}
