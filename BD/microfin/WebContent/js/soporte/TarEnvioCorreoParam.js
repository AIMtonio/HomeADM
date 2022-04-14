	$(document).ready(function () {

		consultaGrid();

		$('#RemitenteID').focus();

		esTab = true;

		//Definicion de Constantes y Enums
		var catTipoTransaccionCorreo = {
			'agrega': '1',
			'modifica': '2',
			'baja': '3',
		};

		var catTipoConsultaCorreo = {
			'principal': 1,
			'foranea': 2
		};

		//------------ Metodos y Manejo de Eventos -----------------------------------------

		deshabilitaBoton('modifica', 'submit');
		deshabilitaBoton('agrega', 'submit');
		deshabilitaBoton('elimina', 'submit');
		agregaFormatoControles('formaGenerica');

		$(':text').focus(function () {
			esTab = false;
		});

		$.validator.setDefaults({
			submitHandler: function (event) {
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'RemitenteID', 'exito', 'fallo');
			}
		});

		$(':text').bind('keydown', function (e) {
			if (e.which == 9 && !e.shiftKey) {
				esTab = true;
			}
		});


		$('#agrega').click(function () {
			$('#tipoTransaccion').val(catTipoTransaccionCorreo.agrega);
		});

		$('#modifica').click(function () {

			$('#tipoTransaccion').val(catTipoTransaccionCorreo.modifica);
		});

		$('#elimina').click(function () {

			$('#tipoTransaccion').val(catTipoTransaccionCorreo.baja);
		});


		$('#RemitenteID').blur(function () {
			esTab = true;
			validaCorreo(this.id);
		});

		$('#RemitenteID').bind('keyup', function (e) {
			if (this.value.length >= 2) {
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "descripcion";
				parametrosLista[0] = $('#RemitenteID').val();
				lista('RemitenteID', '1', '1', camposLista, parametrosLista, 'listacorreo.htm');
			}
		});



		//------------ Validaciones de la Forma -------------------------------------
		$('#formaGenerica').validate({
			rules: {
				Descripcion: {
					required: true
				},

				ServidorSMTP: {
					required: true
				},

				PuertoServerSMTP: {
					required: true
				},

				TipoSeguridad: {
					required: true
				},
				CorreoSalida: {
					required: true
				},
				ConAutentificacion: {
					required: true
				},
				Contrasenia: {
					required : function() {
						return $('#ConAutentificacionS:checked').val() == 'S'
					}
				}
			},
			messages: {
				Descripcion: {
					required: 'Especificar Descripción'
				},

				ServidorSMTP: {
					required: 'Especificar Servidor SMTP'
				},

				PuertoServerSMTP: {
					required: 'Especificar Puerto del Servidor SMTP'
				},

				TipoSeguridad: {
					required: 'Especificar Tipo de Seguridad'
				},

				CorreoSalida: {
					required: 'Especificar Correo de Salida'
				},
				ConAutentificacion: {
					required: 'Especificar la Autentificación'
				},
				Contrasenia: {
					required: 'Especificar la Contraseña'
				}
			}
		});

		//------------ Validaciones de Controles -------------------------------------

		//------------ Funcion Valida Usuarios-----------------------------------

		function validaCorreo(idControl) {
			var jqCorreo = eval("'#" + idControl + "'");
			var numCorreo = $(jqCorreo).val();
			
			setTimeout("$('#cajaLista').hide();", 200);

			if (numCorreo != '' && !isNaN(numCorreo) && esTab) {
				if (numCorreo == '0') {

					habilitaBoton('agrega', 'submit');
					deshabilitaBoton('modifica', 'submit');
					deshabilitaBoton('elimina', 'submit');

					inicializaForma('formaGenerica', 'RemitenteID');

				} else {
					deshabilitaBoton('agrega', 'submit');
					habilitaBoton('modifica', 'submit');
					habilitaBoton('elimina', 'submit');


					var TarEnvioCorreoParamBeanCon = {
						'remitenteID': numCorreo
					};

					tarEnvioCorreoParamServicio.consulta(catTipoConsultaCorreo.principal, TarEnvioCorreoParamBeanCon, function (Correo) {

						if (Correo != null) {
							$('#ServidorSMTP').val(Correo.servidorSMTP);
							$('#Descripcion').val(Correo.descripcion);
							$('#PuertoServerSMTP').val(Correo.puertoServerSMTP);
							$('#TipoSeguridad').val(Correo.tipoSeguridad);
							$('#CorreoSalida').val(Correo.correoSalida);

							$('#Contrasenia').val(Correo.contrasenia);
							$('#Estatus').val(Correo.estatus);
							$('#Comentario').val(Correo.comentario);
							$('#AliasRemitente').val(Correo.aliasRemitente);
							$('#TamanioMax').val(Correo.tamanioMax);
							$('#Tipo').val(Correo.tipo);
							$('#ConAutentificacion').val(Correo.conAutentificacion).checked = true;
							if (Correo.conAutentificacion == 'N') {
								$('#ConAutentificacionN').attr("checked", "1");
							} else {
								$('#ConAutentificacionS').attr("checked", "1");
							}
						} else {
							mensajeSis("No Existe el Correo");
							deshabilitaBoton('modifica', 'submit');
							deshabilitaBoton('agrega', 'submit');
							deshabilitaBoton('modifica', 'submit');
							habilitaBoton('buscar', 'submit');
							limpiarCampos();
							$('#RemitenteID').focus();
							$('#RemitenteID').val('');
						}
					});
				}
			}
		}
	});

	// fin document ready
	function consultaGrid() {
		var params = {};
		params['tipoLista'] = 2;

		$.post("listacorreogrid.htm", params, function (data) {
			if (data.length > 0) {

				$('#gridcorreo').show();
				$('#gridcorreo').html(data);

			}
		});
	}

	function soloNumeros(e) {
		var key = window.Event ? e.which : e.keyCode
		return (key >= 48 && key <= 57)
	}

	function soloLetrasYNum(idControl, campo) {
		if (!/^([a-zA-Z0-9])*$/.test(campo)) {
			mensajeSis("Solo caracteres alfanuméricos");
			$('#' + idControl).focus();
			$('#' + idControl).val('');
		}
	}

	function limpiarCampos() {
		$('#Descripcion').val('');
		$('#ServidorSMTP').val('');
		$('#PuertoServerSMTP').val('');
		$('#TipoSeguridad').val('');
		$('#CorreoSalida').val('');
		$('#ConAutentificacionS').attr('checked', true);
		$('#ConAutentificacionN').attr('checked', false);
		$('#Contrasenia').val('');
		$('#Estatus').val('');
		$('#Comentario').val('');
		$('#AliasRemitente').val('');
		$('#TamanioMax').val('');
		$('#Tipo').val('');

		consultaGrid();
	}

	function exito() {
		limpiarCampos();
	}

	function fallo() {

	}
