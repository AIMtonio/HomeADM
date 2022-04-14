var subdominio = '';
var subdominioComp = '';
var estMulticompania = 'I';
var estActiva = 'A';
var esTab = true;

$(document).ready(function() {
	esTab = false;


	var codigoError = getUrlParameter('error');

	if (codigoError == 8) {
		mensajeSisRetro({
			mensajeAlert: 'La Vigencia de su Licencia ha expirado. <br>Comuníquese con EFISYS.',
			muestraBtnAceptar: true,
			muestraBtnCancela: false,
			muestraBtnCerrar: false,
			txtAceptar: 'Aceptar',
			txtCabecera: 'Estimado Usuario:',
			funcionAceptar: function() {
			},
			funcionCancelar: function() { },
			funcionCerrar: function() { }
		});
	}


	var codeHtmlUsConcur = "<label id='lblMensajeLogin' class='error'>El Usuario ya tiene una sesi&oacute;n abierta</BR> o en su &uacute;ltimo acceso no Cerr&oacute; la Aplicaci&oacute;n Correctamente.</label>";
	var codeHtmlSesAbierta = "<label id='lblMensajeLogin' class='error'>Ya hay una sesion abierta en esta Computadora</label>";
	var codeHtmlLoginFailed = "<label id='lblMensajeLogin' class='error'>Usuario Incorrecto</label>";
	var codeHtmlUserBlock = "<label id='lblMensajeLogin' class='error'>Usuario Bloqueado</label>";
	var codeHtmlUserCancel = "<label id='lblMensajeLogin' class='error'>Usuario Cancelado</label>";
	var codeHtmlIntentos = "<label id='lblMensajeLogin' class='error'>No. Accesos Incorrectos:  ";
	var codeHtmlErrorConsultaSession = "<label id='lblMensajeLogin' class='error'>Problemas al Consultar si el Usuario esta Logeado</label>";
	var codeHtmlClaveCaduca = "<label id='lblMensajeLogin' class='error'>La Vigencia de su Licencia ha expirado. Comuniquese con EFISYS.</label>";


	var usuarioBean = { 'clave': '' };
	var urlSAFI = window.location.host.split('.');
	companiaServicio.consulta(2, usuarioBean, function(compania) {

		if (compania != null) {
			estMulticompania = compania.estMulticompania;


			if (estMulticompania == estActiva) {
				subdominio = urlSAFI[0] == 'www' ? urlSAFI[1] : urlSAFI[0];
				subdominioComp = '';
			}
		}
	});


	var catTipoConsultaUsuario = {
		'clave': 3,
		'key': 4,
		'multiBD': 14
	};




	var estatusUsuario = {
		'Activo': 'A',
		'Bloqueado': 'B',
		'Cancelado': 'C',
		'Inactivo': 'I'
	};

	var usuarioLogeado = {
		'Si': 'S',
		'No': 'N'
	};

	var claveValida = {
		'Si': 'S',
		'No': 'N',
	};
	deshabilitaBoton('submitBtn', 'submit');
	var serverHuella = new HuellaServer({

		fnHuellaValida: function(datos) {
			$('#contraseniaId').val('HD>>' + datos.tokenHuella);


			$('#submitBtn').click();
		},
		fnHuellaInvalida: function(datos) {
			$('#mensajeLogin').html("</BR><label class='error'>Huella Invalida</label>")
			return false;
		}
	});

	$('#loginName').focus();

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	$('#submitBtn').click(function() {
		serverHuella.cancelarOperacionActual();
	});

	$('#loginName').blur(function() {
		validaUsuario(this);
	});

	$('#multi').change(function() {
		var bd = this.value;
		var usuarioBean = {
			'clave': bd
		}
		usuarioServicio.consulta(catTipoConsultaUsuario.multiBD, usuarioBean, function(usuario) {
			alert(usuario)
		});
	});


	/* *** Valida que el usuario de multicompañia corresponda
	*  *** con el usuario que se esta loageando
	*/
	$('#loginForm').submit(function(e) {
		if (estMulticompania == estActiva) {
			if (subdominio != subdominioComp) {
				return false;
			} else {
				return true;
			}
		} else {
			return true;
		}
	});




	function validaUsuario(control) {
		var accedeHuella = 'N';
		var accederAutorizar = 'A';
		var huella_nombreCompleto, huella_usuarioID, huella_OrigenDatos;
		serverHuella.cancelarOperacionActual();
		$('#statusSrvHuella').hide();
		$('#contraseniaId').show();
		$('#submitBtn').show();
		$('#textoAyuda').html('Favor de Especificar Número de Usuario y Password:');
		deshabilitaBoton('submitBtn', 'submit');
		var claveUsuario = $('#loginName').val();
		if (claveUsuario != '' && esTab) {
			var usuarioBean = {
				'clave': claveUsuario
			};

			var controlBean = {
				'clienteID': ''
			};


			var varVerImgCte = "";
			companiaServicio.consulta(1, usuarioBean, {
				callback: function(compania) {

					if (compania == null) {
						return false;
					}


					if (estMulticompania == estActiva) {
						if (compania.subdominio != subdominio) {
							$('#mensajeLogin').html(codeHtmlLoginFailed);
							$('#mensajeLogin').show();

							$('#loginName').focus();
							$('#loginName').select();
							return false;
						}
					}


					subdominioComp = compania.subdominio;


					usuarioServicio.consulta(catTipoConsultaUsuario.clave, usuarioBean, {
						callback: function(usuario) {
							if (usuario != null) {
								accedeHuella = usuario.accedeHuella;
								huella_nombreCompleto = usuario.clave;
								huella_usuarioID = usuario.usuarioID;
								huella_OrigenDatos = usuario.origenDatos;
								accederAutorizar = usuario.accederAutorizar;
								var controlBean = {
									'clienteID': '',
									'origenDatos': usuario.origenDatos
								};
								$('#nombreEmpresa').html("</BR><label class='error'>" + usuario.razonSocial + ".</label>");
								$('#nombreEmpresa').show();
								if (usuario.estatusSesion == estatusUsuario.Activo) {
									$('#mensajeLogin').html(codeHtmlUsConcur);
								} else if (usuario.estatus == estatusUsuario.Bloqueado) {
									$('#mensajeLogin').html(codeHtmlUserBlock);
								} else if (usuario.estatus == estatusUsuario.Cancelado) {
									$('#mensajeLogin').html(codeHtmlUserCancel);
								} else if (usuario.estatus == estatusUsuario.Activo) {
									if (usuario.loginsFallidos > 0) {
										$('#mensajeLogin').html(codeHtmlIntentos + usuario.loginsFallidos + " " + "</label>");
									} else {
										$('#mensajeLogin').html("");
									}
									usuarioServicio.consultaUsuarioLogeado(claveUsuario, {
										callback: function(estaLogeado) {
											if (estaLogeado != null) {
												if (estaLogeado == usuarioLogeado.Si) {
													$('#mensajeLogin').html(codeHtmlUsConcur);
												} else {
													controlClaveServicio.consulta(catTipoConsultaUsuario.key, controlBean, {
														callback: function(control) {
															if (control != null) {
																if (control.activo.trim() == claveValida.No) {
																	$('#mensajeLogin').html(codeHtmlClaveCaduca);
																	$('#mensajeLogin').show();
																}
																else {

																	if (accedeHuella == "S" && accederAutorizar != "C") {
																		$('#statusSrvHuella').show(500);
																		$('#mensajeLogin').html("");
																		$('#mensajeLogin').show();
																		$('#textoAyuda').html('Favor de Especificar Número de Usuario, Password o Huella Digital');

																		if (accederAutorizar == "H") {
																			$('#contraseniaId').hide();
																			$('#submitBtn').hide();
																			$('#textoAyuda').html('Favor de Especificar Número de Usuario y Huella Digital');
																		}

																		serverHuella.funcionMostrarFirmaUsuario(
																			huella_nombreCompleto, huella_usuarioID, huella_OrigenDatos, false
																		);
																	} else {
																		$('#statusSrvHuella').hide();
																	}

																	habilitaBoton('submitBtn', 'submit');
																}
															}
														}, errorHandler: function(message) {
															if (message == "No data received from server") {
																deshabilitaControl('loginName');
																deshabilitaControl('contraseniaId');
																mensajeSisRetro({
																	mensajeAlert: 'La conexión con el servidor ha expirado.',
																	muestraBtnAceptar: true,
																	muestraBtnCancela: true,
																	txtAceptar: 'Recargar',
																	txtCancelar: 'Cancelar',
																	funcionAceptar: function() {
																		location.reload();
																	},
																	funcionCancelar: function() {
																		habilitaControl('loginName');
																		habilitaControl('contraseniaId');
																		$("#loginName").focus();
																	}
																});
															}
														}
													});

												}
											} else {
												$('#mensajeLogin').html(codeHtmlErrorConsultaSession);
											}
										}
									});
								}
								$('#mensajeLogin').show();



							} else {
								deshabilitaBoton('submitBtn', 'submit');

								$('#mensajeLogin').html(codeHtmlLoginFailed);
								$('#mensajeLogin').show();

								$('#loginName').focus();
								$('#loginName').select();
							}
						}, errorHandler: function(message) {
							if (message == "No data received from server") {
								deshabilitaControl('loginName');
								deshabilitaControl('contraseniaId');
								mensajeSisRetro({
									mensajeAlert: 'La conexión con el servidor ha expirado.',
									muestraBtnAceptar: true,
									muestraBtnCancela: true,
									txtAceptar: 'Recargar',
									txtCancelar: 'Cancelar',
									funcionAceptar: function() {
										location.reload();
									},
									funcionCancelar: function() {
										habilitaControl('loginName');
										habilitaControl('contraseniaId');
										$("#loginName").focus();
									}
								});
							}
						}
					});
				}
			});
		}
	}
});
function carga() {
	$("#loginName").removeAttr("disabled");
	$("#contraseniaId").removeAttr("disabled");
}

function validaConexion(message) {

}

function getUrlParameter(sParam) {
	var sPageURL = decodeURIComponent(window.location.search.substring(1)),
		sURLVariables = sPageURL.split('&'),
		sParameterName,
		i;

	for (i = 0; i < sURLVariables.length; i++) {
		sParameterName = sURLVariables[i].split('=');

		if (sParameterName[0] === sParam) {
			return sParameterName[1] === undefined ? true : sParameterName[1];
		}
	}
};


function removeParam(key, sourceURL) {
	var rtn = sourceURL.split("?")[0],
		param,
		params_arr = [],
		queryString = (sourceURL.indexOf("?") !== -1) ? sourceURL.split("?")[1] : "";
	if (queryString !== "") {
		params_arr = queryString.split("&");
		for (var i = params_arr.length - 1; i >= 0; i -= 1) {
			param = params_arr[i].split("=")[0];
			if (param === key) {
				params_arr.splice(i, 1);
			}
		}
		rtn = rtn + "?" + params_arr.join("&");
	}
	return rtn;
}
