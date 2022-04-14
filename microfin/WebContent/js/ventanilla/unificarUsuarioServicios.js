$(document).ready(function() {

	var esTab = false;
	var sexoObj = {
		'M': 'MASCULINO',
		'F': 'FEMENINO'
	};
	var transaccionUnificar = 3;
	var actualizacionUnificar = 2;

    deshabilitaBoton('grabar', 'submit');
    $('#usuarioID').focus();

    $(':text').bind('keydown', function(e) {
		esTab = (e.which == 9 && !e.shiftKey);
	});

	$(':text').focus(function() {
		esTab = false;
	});

	$.validator.setDefaults({
		submitHandler: function (event) {

			if (prepararUsuarios()) {

				$('#usuarioID').val($('#ctrlUsuarioID').val());
				$('#tipoTransaccion').val(transaccionUnificar);
				$('#tipoActualizacion').val(actualizacionUnificar);

				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'usuarioID', "transaccionRealizada", "transaccionRealizada");
			}
		}
	});

	$('#usuarioID').bind('keyup',function(e) {
		lista('usuarioID', '3', '5', 'nombreCompleto', $('#usuarioID').val(), 'listaUsuario.htm');
	});

	$('#usuarioID').blur(function () {
		setTimeout("$('#cajaLista').hide();", 200);
		var usuarioID = $('#usuarioID').val().replace(/\s/g, '');

		if (esTab && +usuarioID >= 0) {
			limpiarCampos();
			consultaUsuario(usuarioID);
		}
	});

	$('#checkTodos').change(function () {

		if($(this).is(':checked')) {
			$(".check").attr("checked", true);
			habilitaBoton('grabar', 'submit');
		} else {
			$(".check").attr("checked", false);
			deshabilitaBoton('grabar', 'submit');
		}
	});

    $('#formaGenerica').validate({
		rules: {
			usuarioID: {
				required: true
			}
		},
		messages: {
			usuarioID: {
				required: 'El Número es requerido.'
			}
		}
	});

	function consultaUsuario(usuarioID) {

		if ((+usuarioID > 0) != true || esTab == false) {
			return;
		}

		bloquearPantalla();
		usuarioServicios.consulta(5, { 'usuarioID': usuarioID }, function (usuario) {

			if (usuario == null) {
				$('#usuarioID').focus();
				mensajeSis("El usuario de servicios ingresado no existe.");
				return;
			}

			llenarCampos(usuario);
			listaCoincidencias(usuario.usuarioID);
			desbloquearPantalla();
		});
	}

	function llenarCampos(usuario) {

		$('#usuarioID').val(usuario.usuarioID);
		$('#ctrlUsuarioID').val(usuario.usuarioID);
		$('#nombreCompleto').val(usuario.nombreCompleto);
		$('#RFC').val(usuario.RFC);
		$('#CURP').val(usuario.CURP);
		$('#sexo').val(sexoObj[usuario.sexo]);
		$('#fechaNacimiento').val(usuario.fechaNacimiento);
	}

	function listaCoincidencias(usuarioID) {

		usuarioServicios.lista(4, { 'usuarioID': usuarioID }, {
			async: false, callback: function (coincidencias) {

				$('#listaCoincidencias').show();

				if (coincidencias == null || coincidencias.length <= 0) {
					$('#tblCoincidencias').hide();
					$('#sinCoincidencias').show();
					return;
				}

				mostrarCoincidencias(coincidencias);
			}
		});
	}

	function mostrarCoincidencias(coincidencias) {

		var indice = 1;

		for (var usuario of coincidencias) {
			var tr =
			'<tr>' +
				'<td><input type="text" disabled size="05" value="'+indice+'" id="num'+indice+'"></td>' +
				'<td><input type="text" disabled size="10" value="'+usuario.usuarioID+'" id="usuario'+indice+'" class="usuarioID"></td>' +
				'<td><input type="text" disabled size="40" value="'+usuario.nombreCompleto+'" id="nombre'+indice+'"></td>' +
				'<td><input type="text" disabled size="17" value="'+usuario.RFC+'" id="'+indice+'"rfc></td>' +
				'<td><input type="text" disabled size="25" value="'+usuario.CURP+'" id="'+indice+'"curp></td>' +
				'<td><input type="text" disabled size="14" value="'+usuario.coincidencia+' %" id="coincidencia'+indice+'"></td>' +
				'<td style="text-align: center;"><input type="checkbox" title="Unificar" class="check"' +
				'style="cursor: pointer;" onchange="seleccionUsuario(this)" tabindex="'+(indice + 2)+'"></td>' +
			'</tr>';

			$("#tbodyCoincidencias").append(tr);
			indice++;
		}
		$('#grabar').attr('tabindex', indice + 2);
		$('#checkTodos').focus();
	}

	function prepararUsuarios() {

		var checSeleccionados = $("#tbodyCoincidencias").find('.check:checked');
		var usuariosID = '';

		if (checSeleccionados.length < 1) {
			mensajeSis("No se ha seleccionado ningun usuario de servicios para unificar.");
			return false;
		}

		checSeleccionados.closest('tr').each(function () {
			var usuarioID = $(this).find("td > input.usuarioID").val();
			usuariosID = usuariosID + usuarioID + ',';
		});

		usuariosID = usuariosID.replace(/.$/, '');
		$('#usuariosID').val(usuariosID);

		return true;
	}
});

function limpiarCampos() {

	deshabilitaBoton('grabar', 'submit');
	$('#tbodyCoincidencias').empty();
	$('#listaCoincidencias').hide();
	$('#tblCoincidencias').show();
	$('#sinCoincidencias').hide();
	limpiaFormaCompleta('formaGenerica', true, ['usuarioID']);
}

// función que se ejecuta al interactuar con los checkbox de los usuarios de servicios
function seleccionUsuario (checkbox) {

	var seleccionados = $("#tbodyCoincidencias").find('.check:checked').length;

	if ($(checkbox).is(':checked')) {

		if ($(".check").length == seleccionados) {
			$("#checkTodos").attr("checked", true);
		}
		habilitaBoton('grabar', 'submit');
	} else {

		if (seleccionados < 1) {
			deshabilitaBoton('grabar', 'submit');
		}
		$("#checkTodos").attr("checked", false);
	}
}

function transaccionRealizada() {
	limpiarCampos();
};