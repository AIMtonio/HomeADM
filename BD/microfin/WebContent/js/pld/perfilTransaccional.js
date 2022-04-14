var clienteSofi = 15;  // número de cliente que corresponde a SOFI EXPRESS.
var numeroCliente;

var Cat_TipoTransaccion = {
	'agrega': '1',
	'modifica': '2'
};

var catTipoConsultaCta = {
	'principal': 1,
	'foranea': 2
};

var listaHistoricaCliente = 1;
var listaHistoricaUsuario = 3;
var esTab = false;

$(document).ready(function() {

	numeroCliente = consultaClienteEspecifico();

	if (numeroCliente == clienteSofi) {
		$('#trTipoPerfil').show();
		$('#radioCliente').attr('checked', true);
	}

	$('#clienteID').focus();
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');
	agregaFormatoControles('formaGenerica');
	funcionCargaOrigenRec();
	funcionCargaDestinoRec();

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$.validator.setDefaults({
		submitHandler: function (event) {

			if (validaTipoPerfil()) {
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'clienteID', 'funcionExito', 'funcionError');
			}
		}
	});

	$('#formaGenerica').validate({
		rules : {
			clienteID : {
				required : () => $('#trCliente').is(':visible'),
                maxlength : 20000
			},
			usuarioID: {
				required : () => $('#trUsuarioServicios').is(':visible')
			},
			depositosMax : {
				number : true,
				required : true,
				maxlength : 19
			},
			comentarioOrigenRec : {
				maxlength : 600
			},
			comentarioDestRec : {
				maxlength : 600
			},
			retirosMax : {
				number : true,
				required : true,
				maxlength : 19
			},
			numDepositos : {
				number : true,
				required : true,
				maxlength : 14
			},
			numRetiros : {
				number : true,
				required : true,
				maxlength : 14
			},
			origenRecursos : {
				required : true
			},
			destinoRecursos : {
				required : true
			}
		},
		messages : {
			clienteID : {
				required : 'Especifique el Número del ' + $("#socioClienteAlert").val() + ".",
                maxlength : 'Máximo 20000 Carácteres'
			},
			usuarioID: {
				required: 'Número de usuario requerido.',
			},
			depositosMax : {
			number : 'Sólo Números.',
			required : 'Especifique la Cantidad de Depósitos.',
			maxlength : 'Máximo 19 Carácteres'
			},
			retirosMax : {
			number : 'Sólo Números.',
			required : 'Especifique la Cantidad de Retiros ',
			maxlength : 'Máximo 19 Carácteres.'
			},
			numDepositos : {
				number : 'Sólo Números',
				required : 'Especifique el Número de Depósitos.',
				maxlength : 'Máximo 9 Carácteres.'
			},
			numRetiros : {
				number : 'Sólo Números.',
				required : 'Especifique el Número de Retiros.',
				maxlength : 'Máximo 9 Carácteres.'
			},
			origenRecursos : {
				required : 'El Origen de los Recursos es Requerido.'
			},
			comentarioOrigenRec : {
				maxlength : 'Máximo 600 Carácteres.'
			},
			comentarioDestRec : {
				maxlength : 'Máximo 600 Carácteres.'
			},
			destinoRecursos : {
				required : 'El Destino de los Recursos es Requerido.'
			}
		}
	});

	// CS_IALDANA_TICKET_11330
	$('#clienteID').bind('keyup', function(e) {
		lista('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#clienteID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);

		if (esTab) {

			var clienteID = $(this).val().replace(/\s/g, '');
			inicializa();

			if (+clienteID != 0) {
				consultaCliente(clienteID);
			}
		}
	});

	$('#usuarioID').bind('keyup',function(e) {
		lista('usuarioID', '3', '1', 'nombreCompleto', $('#usuarioID').val(), 'listaUsuario.htm');
	});

	$('#usuarioID').blur(function () {
		setTimeout("$('#cajaLista').hide();", 200);

		if (esTab) {

			var usuarioID = $('#usuarioID').val().replace(/\s/g, '');
			inicializa();

			if (+usuarioID != 0) {
				consultaUsuario(usuarioID);
			}
		}
	});

	$('#tdTipoPerfil input[name=tipoPerfil]').change(function () {
		setTimeout("$('#cajaLista').hide();", 200);
		inicializa();

		if ($(this).val() == 'C') {
			$('#usuarioID').val('');
			$('#trUsuarioServicios').hide();
			$('#trCliente').show();
			$('#clienteID').focus();
		} else {
			$('#clienteID').val('');
			$('#trCliente').hide();
			$('#trUsuarioServicios').show();
			$('#usuarioID').focus();
		}
	});

	$('#agrega').click(function() {
		$('#tipoTransaccion').val(Cat_TipoTransaccion.agrega);
	});

	$('#modifica').click(function() {
		$('#tipoTransaccion').val(Cat_TipoTransaccion.modifica);
	});
});

function inicializa() {
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	limpiaFormaCompleta('formaGenerica',true,['clienteID','usuarioID','radioCliente','radioUsuario']);
	$('#historico').html("");
}

function ayuda(idDivMostrar) {
	$("#ayuda1").hide();
	$("#ayuda2").hide();
	$("#ayuda3").hide();
	$("#ayuda4").hide();
	$("#" + idDivMostrar).show();
	$.blockUI({
	message : $('#ContenedorAyuda'),
	css : {
	top : ($(window).height() - 400) / 2 + 'px',
	left : ($(window).width() - 400) / 2 + 'px',
	width : '400px'
	}
	});
	$('.blockOverlay').attr('title', 'Clic para Desbloquear').click(function() {
		$.unblockUI();
	});
}

function consultaCliente(clienteID) {

	if ((+clienteID > 0) != true) {
		$('#clienteID').focus();
		mensajeSis("El número de cliente ingresado es incorrecto <br> Debe ser una valor númerico");
		return;
	}

	bloquearPantalla();
	clienteServicio.consulta(1, clienteID, function (cliente) {

		if (cliente != null) {
			$("#nombreCliente").val(cliente.nombreCompleto);
			$('#ctrlClienteID').val(clienteID);
			consultaPerfilTranCliente(clienteID);
		} else {
			$('#clienteID').focus();
			mensajeSis("El " + $("#socioClienteAlert").val() + " ingresado no existe.");
		}
	});
}

// consulta perfil transaccional del cliente.
function consultaPerfilTranCliente(clienteID) {

	if (clienteID > 0) {

		perfilTransaccionalServicio.consulta({'clienteID' : clienteID}, 1, function(perfilTransaccional) {

			if (perfilTransaccional == null) {
				$('#clienteID').focus();
				mensajeSis("Ah ocurrido un error al consultar el perfil transaccional del cliente.");
				return;
			}

			if (+perfilTransaccional.clienteID > 0) {
				dwr.util.setValues(perfilTransaccional);
				$('#ctrlClienteID').val(perfilTransaccional.clienteID);
				agregaFormatoControles('formaGenerica');
				habilitaBoton('modifica', 'submit');
				consultaHistorica(listaHistoricaCliente, perfilTransaccional.clienteID);
			} else {
				habilitaBoton('agrega', 'submit');
				desbloquearPantalla();
			}
		});
	}
}

function consultaUsuario(usuarioID) {

	if ((+usuarioID > 0) != true) {
		$('#usuarioID').focus();
		mensajeSis("El número de usuario ingresado es incorrecto <br> Debe ser una valor númerico");
		return;
	}

	bloquearPantalla();
	usuarioServicios.consulta(6, { 'usuarioID': usuarioID }, function (usuario) {

		if (usuario == null) {
			$('#usuarioID').focus();
			mensajeSis("El usuario de servicios ingresado no existe.");
			return;
		}

		$('#nombreUsuario').val(usuario.nombreCompleto);
		$('#ctrlUsuarioID').val(usuario.usuarioID);

		consultaPerfilTranUsuario(usuario.usuarioID);
	});
}

// consulta perfil transaccional del usuario de servicios.
function consultaPerfilTranUsuario(usuarioID) {

	if (usuarioID > 0) {

		perfilTransaccionalServicio.consulta({'usuarioID': usuarioID}, 3, function(perfilTransaccional) {

			if (perfilTransaccional == null) {
				$('#usuarioID').focus();
				mensajeSis("Ah ocurrido un error al consultar el perfil transaccional del usuario de servicios.");
				return;
			}

			if (+perfilTransaccional.usuarioID > 0) {
				dwr.util.setValues(perfilTransaccional);
				$('#ctrlUsuarioID').val(perfilTransaccional.usuarioID);
				agregaFormatoControles('formaGenerica');
				habilitaBoton('modifica', 'submit');
				consultaHistorica(listaHistoricaUsuario, perfilTransaccional.usuarioID);
			} else {
				habilitaBoton('agrega', 'submit');
				desbloquearPantalla();
			}
		});
	}
}

function funcionCargaOrigenRec(){
	dwr.util.removeAllOptions('origenRecursos');
	perfilTransaccionalServicio.listaComboOrigenRec(1, function(beanLista){
		dwr.util.addOptions('origenRecursos', {'':'SELECCIONAR'});
		dwr.util.addOptions('origenRecursos', beanLista, 'catOrigenRecID', 'descripcion');
	});
}

function funcionCargaDestinoRec(){
	dwr.util.removeAllOptions('destinoRecursos');
	perfilTransaccionalServicio.listaComboDestRec(2, function(beanLista){
		dwr.util.addOptions('destinoRecursos', {'':'SELECCIONAR'});
		dwr.util.addOptions('destinoRecursos', beanLista, 'catDestinoRecID', 'descripcion');
	});
}

function consultaHistorica(tipoLista, personaID) {
	var params = {};
	params['tipoLista'] = tipoLista;

	switch (tipoLista) {
		case listaHistoricaCliente:
			params['clienteID'] = personaID;
		break;
		case listaHistoricaUsuario:
			params['usuarioID'] = personaID;
		break;
	}

	if (personaID > 0) {
		$.post("perfilTransaccionalGrid.htm", params, function (dat) {
			if (dat.length > 0) {
				$('#historico').html(dat);
				$('#historico').show();
			} else {
				$('#historico').html("");
				$('#historico').show();
			}
			desbloquearPantalla();
		});
	}
}

function consultaClienteEspecifico() {

	var numeroCliente = 0;

	paramGeneralesServicio.consulta(13, {
		async: false, callback: function (valor) {

			if (valor != null) {
				numeroCliente = valor.valorParametro;
			}
		}
	});

	return numeroCliente;
}

function validaTipoPerfil() {

	$('#clienteID').val($('#ctrlClienteID').val());
	$('#usuarioID').val('');

	if (numeroCliente != clienteSofi) {
		return true;
	}

	if ($('#radioCliente').is(':checked') == false && $('#radioUsuario').is(':checked') == false) {
		mensajeSis("Favor de seleccionar un tipo de perfil.");
		return false;
	}

	if ($('#radioUsuario').is(':checked')) {
		$('#usuarioID').val($('#ctrlUsuarioID').val());
		$('#clienteID').val('');
	}

	return true;
}

function funcionExito(){
	inicializa();
}

function funcionError(){

}