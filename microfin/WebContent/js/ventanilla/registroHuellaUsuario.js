$(document).ready(function() {

	var sexoObj = {
		'M' : 'MASCULINO',
		'F' : 'FEMENINO'
	}
	var tiposPersonaObj = {
		'M' : 'MORAL',
		'A' : 'FÍSICA CON ACT. EMPRESARIAL',
		'F' : 'FÍSICA SIN ACT. EMPRESARIAL',
	}
	var dedosObj = {
		'N' : 'MEÑIQUE',
		'A' : 'ANULAR',
		'M' : 'MEDIO',
		'I' : 'INDICE',
		'P' : 'PULGAR'
	}

	var serverHuella = new HuellaServer({
		fnGrabarHuella: function (datos) {

			mensajeSis(datos.mensajeRespuesta);
			consultaHuellaUsuario($('#ctrlUsuarioID').val());
		}
	});

	$('#usuarioID').focus();
	deshabilitaBoton('grabar', 'submit');

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});

	$.validator.setDefaults({
		submitHandler: function (event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'usuarioID', 'funcionResultadoExitoso', 'funcionResultadoFallido');
		}
	});

	$('#usuarioID').bind('keyup',function(e){
		lista('usuarioID', '3', '1', 'nombreCompleto', $('#usuarioID').val(), 'listaUsuario.htm');
	});

	$('#usuarioID').blur(function() {

		setTimeout("$('#cajaLista').hide();", 200);
		var usuarioID = $(this).val().replace(/\s/g, '');

		if (esTab) {
			limpiaFormulario();

			if (+usuarioID != 0) {
				consultaUsuario(usuarioID);
			}
		}
  	});

	$('#grabar').click(function(){
		funcionMostrarFirma($('#nombreCompleto').val());
	});

	function consultaUsuario(usuarioID) {

		if ((+usuarioID > 0) != true) {
			$('#usuarioID').focus();
			mensajeSis("El número de usuario ingresado es incorrecto <br> Debe ser una valor númerico");
			return;
		}

		bloquearPantalla();
		usuarioServicios.consulta(1,{'usuarioID':usuarioID},function(usuario) {

			if (usuario == null) {
				$('#usuarioID').focus();
				mensajeSis("El usuario de servicios ingresado no existe.");
				return;
			}

			$('#usuarioID').val(usuario.usuarioID);
			$('#ctrlUsuarioID').val(usuario.usuarioID);
			$('#nombreCompleto').val(usuario.nombreCompleto);
			$('#tipoPersona').val(tiposPersonaObj[usuario.tipoPersona]);
			$('#sexo').val(sexoObj[usuario.sexo]);
			$('#fechaNacimiento').val(usuario.fechaNacimiento);

			consultaHuellaUsuario(usuario.usuarioID);
			desbloquearPantalla();
		});
	}

	function consultaHuellaUsuario(usuarioID) {

		huellaDigitalServicio.consulta(6, { 'personaID': usuarioID }, {
			async: false, callback: function (usuario) {

				if (usuario != null) {
					$('#dedoHuellaUno').val(dedosObj[usuario.dedoHuellaUno] || '');
					$('#dedoHuellaDos').val(dedosObj[usuario.dedoHuellaDos] || '');
					$('#grabar').val('Modificar Huella');
					serverHuella.tipoRegistroHuella = 'modificar'
				}
				$('#Estatus_Registro_Huella').html(serverHuella.estatus_huella_digital[usuario?.estatus || ''].html);
				habilitaBoton('grabar', 'submit');
			}
		});
	}

	function funcionMostrarFirma(nombreUsuarioServicios) {

		var usuarioID = $('#ctrlUsuarioID').val();
		$('#usuarioID').val(usuarioID);
		var IDCta = 'N/A';
		var nomCta = '';
		$('#apletHuella').width(800);
		$('#apletHuella').height(700);

		if (!serverHuella.estaConectado) {
			mensajeSis("La aplicación de Huella Digital no se está ejecutando en este equipo." +
				" Revise que la aplicación se encuentre activa y vuelva a intentarlo");
			return;
		}

		huellaDigitalServicio.consulta(6, { 'personaID': usuarioID }, function (usuarioServicio) {

			serverHuella.enrolamientoUsuarioServicios(
				nombreUsuarioServicios,
				IDCta,
				nomCta,
				usuarioServicio?.personaID || usuarioID,
				usuarioServicio?.dedoHuellaUno || '',
				usuarioServicio?.dedoHuellaDos || ''

			);
		});
	}

	function limpiaFormulario() {

		limpiaFormaCompleta('formaGenerica', true, ['usuarioID']);
		$('#Estatus_Registro_Huella').empty();
		$('#grabar').val('Registrar Huella');
		deshabilitaBoton('grabar','submit');
		serverHuella.tipoRegistroHuella = 'registrar';
	}
});