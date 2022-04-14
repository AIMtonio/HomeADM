var nacionalidadUsuario = '';
var nivelRiesgoUsuario = '';

$(document).ready(function () {

	agregaFormatoControles('formaGenerica');
	var esTab = false;
	$('#usuarioID').focus();
    deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');
	var esUsuarioServ = 'USS'; // Tipo de persona Usuario de Servicios.
	$('#telefonoRefCom1').setMask('phone-us');
	$('#telefonoRefCom2').setMask('phone-us');
	$('#telefonoRefPers1').setMask('phone-us');
	$('#telefonoRefPers2').setMask('phone-us');
	var transaccionAlta = 1;		// Número de transacción para dar de alta.
	var transaccionModifica = 2;	// Número de transacción para modificar.
	mostrarOC();

    $(':text').bind('keydown', function(e) {
		esTab = (e.which == 9 && !e.shiftKey);
	});

	$(':text').focus(function() {
		esTab = false;
	});

	$.validator.setDefaults({
		submitHandler: function (event) {
			$('#usuarioID').val($('#ctrlUsuarioID').val());
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'usuarioID', "funcionExito", "funcionError");
		}
	});

	$('#agrega').click(function () {
		$('#tipoTransaccion').val(transaccionAlta);
	});

	$('#modifica').click(function () {
		$('#tipoTransaccion').val(transaccionModifica);
	});

	$('#usuarioID').bind('keyup',function(e) {
		lista('usuarioID', '3', '1', 'nombreCompleto', $('#usuarioID').val(), 'listaUsuario.htm');
	});

	$('#usuarioID').blur(function () {
		setTimeout("$('#cajaLista').hide();", 200);
		var usuarioID = $('#usuarioID').val().replace(/\s/g, '');

		if (esTab) {

			limpiarCampos();

			if (+usuarioID != 0) {
				consultaUsuario(usuarioID);
			}
		}
	});

	$('#btnDefinicionPEP').click(function () {
		$.blockUI({
			message : $('#modalDefinicionPEP')
		});
		$('.blockOverlay').attr('title', 'Clic para desbloquear').click($.unblockUI);
	});

	$('#tipoRelacionRefPers1').bind('keyup', function(e) {
		lista('tipoRelacionRefPers1', '2', '1', 'descripcion', $('#tipoRelacionRefPers1').val(), 'listaParentescos.htm');
	});

	$('#tipoRelacionRefPers1').blur(function () {
		setTimeout("$('#cajaLista').hide();", 200);
		if (esTab) {
			consultaParentesco(this, 'descRelacionRefPers1');
		}
	});

	$('#tipoRelacionRefPers2').bind('keyup', function(e) {
		lista('tipoRelacionRefPers2', '2', '1', 'descripcion', $('#tipoRelacionRefPers2').val(), 'listaParentescos.htm');
	});

	$('#tipoRelacionRefPers2').blur(function () {
		setTimeout("$('#cajaLista').hide();", 200);
		if (esTab) {
			consultaParentesco(this, 'descRelacionRefPers2');
		}
	});

	$("#tdPEPs input[name=PEPs]").change(function () {

		var valorPEPs = $(this).val();

		if (valorPEPs == 'S') {
			$('#tablaActividadEmp tr.camposFuncion').show();
		} else {
			$('#tablaActividadEmp tr.camposFuncion').hide();
			limpiarCamposFuncion();
		}

		camposNivelRiesgo(valorPEPs);
	});

	$("#tdParentescoPEP input[name=parentescoPEP]").change(function () {

		if ($(this).val() == 'S') {
			$('#tablaActividadEmp tr.camposDatosFamiliares').show();
		} else {
			$('#tablaActividadEmp tr.camposDatosFamiliares').hide();
			$('#nombreFamiliar').val();
			$('#aPaternoFamiliar').val();
			$('#aMaternoFamiliar').val();
		}
	});

	$("#tdImporta input[name=importa]").change(function () {

		if ($(this).val() == 'S') {
			$('#camposImporta').show();
		} else {
			$('#camposImporta').hide();
			$('#dolaresImporta1').attr('checked', false);
			$('#dolaresImporta2').attr('checked', false);
			$('#dolaresImporta3').attr('checked', false);
			$('#dolaresImporta4').attr('checked', false);
			$('#paisesImporta1').val('');
			$('#paisesImporta2').val('');
			$('#paisesImporta3').val('');
		}
	});

	$("#tdExporta input[name=exporta]").change(function () {

		if ($(this).val() == 'S') {
			$('#camposExporta').show();
		} else {
			$('#camposExporta').hide();
			$('#dolaresExporta1').attr('checked', false);
			$('#dolaresExporta2').attr('checked', false);
			$('#dolaresExporta3').attr('checked', false);
			$('#dolaresExporta4').attr('checked', false);
			$('#paisesExporta1').val('');
			$('#paisesExporta2').val('');
			$('#paisesExporta3').val('');
		}
	});

	$("#nivelRiesgo").change(function () {
		if ($(this).val() != '') {
			$('#evaluaXMatrizNO').attr('checked', true);
		}
	});

	$('#funcionID').bind('keyup', function (e) {
		lista('funcionID', '2', '1', 'descripcion', $('#funcionID').val(), 'listaFuncionPub.htm');
	});

	$('#funcionID').blur(function () {
		setTimeout("$('#cajaLista').hide();", 200);

		if (esTab) {
			$('#funcionDescripcion').val('');

			var funcionID = $('#funcionID').val().replace(/\s/g, '');

			if (+funcionID == 0) {
				return;
			}

			consultaFuncionPublica(funcionID);
		}
	});

	$('#fechaNombramiento').change(function () {

		var fecha = $(this).val().replace(/\s/g, '');

		if (validacion.esFechaValida(fecha)) {

			if (fecha > parametroBean.fechaSucursal) {
				$('#fechaNombramiento').focus();
				mensajeSis("La Fecha de nombramiento no puede ser mayor a la fecha del sistema.");
				$('#fechaNombramiento').val(parametroBean.fechaSucursal);
			}
		} else {
			$('#fechaNombramiento').focus();
			mensajeSis("Formato de la Fecha de nombramiento no válido <br> (aaaa-mm-dd)");
			$('#fechaNombramiento').val(parametroBean.fechaSucursal);
		}
	});

	$('#porcentajeAcciones').blur(function () {
		var porcentaje = $(this).val().replace(/[\s,]/g, '');

		if (porcentaje != '') {
			if (+porcentaje > 100) {
				$(this).val('');
				$(this).focus();
				mensajeSis("El porcentaje de acciones no puede ser mayor a 100 <br> (Campo opcional).");
				return;
			}

			if ((+porcentaje > 0) != true) {
				$(this).val('');
				$(this).focus();
				mensajeSis("El porcentaje de acciones debe ser mayor a 0 <br> (Campo opcional).");
				return;
			}
		}
	});

	$('#montoAcciones').blur(function () {
		var monto = $(this).val().replace(/[\s,]/g, '');

		if (monto != '' && (+monto > 0) != true) {
			$(this).val('');
			$(this).focus();
			mensajeSis("El monto de las acciones debe ser mayor a 0 <br> (Campo opcional).");
		}
	});

	$('#telefonoRefCom1').blur(function () {
		if (($(this).val().replace(/\s/g, '')) == '') {
			$('#extTelefonoRefCom1').val('');
		}
	});

	$('#extTelefonoRefCom1').blur(function () {
		if (($(this).val().replace(/\s/g, '')) != '') {
			if (($('#telefonoRefCom1').val().replace(/\s/g, '')) == '') {
				$('#telefonoRefCom1').focus();
				mensajeSis("El número teléfono está vacío.");
				$(this).val('');
			}
		}
	});

	$('#telefonoRefCom2').blur(function () {
		if (($(this).val().replace(/\s/g, '')) == '') {
			$('#extTelefonoRefCom2').val('');
		}
	});

	$('#extTelefonoRefCom2').blur(function () {
		if (($(this).val().replace(/\s/g, '')) != '') {
			if (($('#telefonoRefCom2').val().replace(/\s/g, '')) == '') {
				$('#telefonoRefCom2').focus();
				mensajeSis("El número teléfono está vacío.");
				$(this).val('');
			}
		}
	});

	$('#telefonoRefPers1').blur(function () {
		if (($(this).val().replace(/\s/g, '')) == '') {
			$('#extTelefonoRefPers1').val('');
		}
	});

	$('#extTelefonoRefPers1').blur(function () {
		if (($(this).val().replace(/\s/g, '')) != '') {
			if (($('#telefonoRefPers1').val().replace(/\s/g, '')) == '') {
				$('#telefonoRefPers1').focus();
				mensajeSis("El número teléfono está vacío.");
				$(this).val('');
			}
		}
	});

	$('#telefonoRefPers2').blur(function () {
		if (($(this).val().replace(/\s/g, '')) == '') {
			$('#extTelefonoRefPers2').val('');
		}
	});

	$('#extTelefonoRefPers2').blur(function () {
		if (($(this).val().replace(/\s/g, '')) != '') {
			if (($('#telefonoRefPers2').val().replace(/\s/g, '')) == '') {
				$('#telefonoRefPers2').focus();
				mensajeSis("El número teléfono está vacío.");
				$(this).val('');
			}
		}
	});

	$('#formaGenerica').validate({
		rules: {
			usuarioID: {
				required: true
			},
			razonSocial: {
				maxlength: 150
			},
			giro: {
				maxlength: 150
			},
			aniosOperacion: {
				number: true,
				maxlength: 2,
				min: 0
			},
			aniosGiro: {
				number: true,
				maxlength: 2,
				min: 0
			},
			porcentajeAcciones: {
				number: true
			},
			montoAcciones: {
				number: true,
			},
			numeroEmpleados: {
				number: true,
				maxlength: 5
			},
			serviciosProductos: {
				maxlength: 50
			},
			estadosPresencia: {
				number: true,
				maxlength: 2
			},
			importeVentas: {
				number: true,
				maxlength: 18
			},
			activos: {
				number: true,
				maxlength: 18
			},
			pasivos: {
				number: true,
				maxlength: 18
			},
			capitalContable: {
				number: true,
				maxlength: 18
			},
			capitalNeto: {
				number: true,
				maxlength: 18
			},
			nombreRefCom1: {
				maxlength: 150
			},
			noCuentaRefCom1: {
				number: true,
				maxlength: 15
			},
			direccionRefCom1: {
				maxlength: 500
			},
			telefonoRefCom1: {
				maxlength: 16
			},
			extTelefonoRefCom1: {
				number: true
			},
			nombreRefCom2: {
				maxlength: 150
			},
			noCuentaRefCom2: {
				number: true,
				maxlength: 15
			},
			direccionRefCom2: {
				maxlength: 500
			},
			telefonoRefCom2: {
				maxlength: 16
			},
			extTelefonoRefCom2: {
				number: true
			},
			bancoRefBanc1: {
				maxlength: 50
			},
			tipoCuentaRefBanc1: {
				maxlength: 50
			},
			noCuentaRefBanc1: {
				maxlength: 15,
				number: true
			},
			sucursalRefBanc1: {
				maxlength: 50
			},
			noTarjetaRefBanc1: {
				maxlength: 16,
				number: true
			},
			institucionRefBanc1: {
				maxlength: 50
			},
			institucionEntRefBanc1: {
				maxlength: 50
			},
			bancoRefBanc2: {
				maxlength: 50
			},
			tipoCuentaRefBanc2: {
				maxlength: 50
			},
			noCuentaRefBanc2: {
				maxlength: 15,
				number: true
			},
			sucursalRefBanc2: {
				maxlength: 50
			},
			noTarjetaRefBanc2: {
				maxlength: 16,
				number: true
			},
			institucionRefBanc2: {
				maxlength: 50
			},
			institucionEntRefBanc2: {
				maxlength: 50
			},
			nombreRefPers1: {
				maxlength: 150
			},
			domicilioRefPers1: {
				maxlength: 500
			},
			telefonoRefPers1: {
				maxlength: 16
			},
			extTelefonoRefPers1: {
				number: true,
				maxlength: 5
			},
			nombreRefPers2: {
				maxlength: 150
			},
			domicilioRefPers2: {
				maxlength: 500
			},
			telefonoRefPers2: {
				maxlength: 16
			},
			extTelefonoRefPers2: {
				number: true,
				maxlength: 5
			},
			principalFuenteIng: {
				maxlength: 100
			},
			preguntaUsuario1: {
				required: () => $('#camposUsuarioAltoRiesgo').is(':visible'),
				maxlength: 100
			},
			respuestaUsuario1: {
				required: () => $('#camposUsuarioAltoRiesgo').is(':visible'),
				maxlength: 200
			}
		},
		messages: {
			usuarioID: {
				required: 'El Número es requerido.'
			},
			razonSocial: {
				maxlength: 'Máximo 150 caracteres.'
			},
			giro: {
				maxlength: 'Máximo 150 caracteres.'
			},
			aniosOperacion: {
				number: 'Solo Números(Campo opcional).',
				maxlength: 'Máximo 2 caracteres.',
				min: 'Debe ser mayor o igual a cero'
			},
			aniosGiro: {
				number: 'Solo Números(Campo opcional).',
				maxlength: 'Máximo 2 caracteres.',
				min: 'Debe ser mayor o igual a cero'
			},
			porcentajeAcciones: {
				number: 'Solo Números(Campo opcional).'
			},
			montoAcciones: {
				number: 'Solo Números(Campo opcional).',
			},
			numeroEmpleados: {
				number: 'Solo Números(Campo opcional).',
				maxlength: 'Máximo 5 caracteres.'
			},
			serviciosProductos: {
				maxlength: 'Máximo 50 caracteres.'
			},
			estadosPresencia: {
				number: 'Solo Números(Campo opcional).',
				maxlength: 'Máximo 2 caracteres.'
			},
			importeVentas: {
				number: 'Solo Números(Campo opcional).',
				maxlength: 'Máximo 18 caracteres.'
			},
			activos: {
				number: 'Solo Números(Campo opcional).',
				maxlength: 'Máximo 18 caracteres.'
			},
			pasivos: {
				number: 'Solo Números(Campo opcional).',
				maxlength: 'Máximo 18 caracteres.'
			},
			capitalContable: {
				number: 'Solo Números(Campo opcional).',
				maxlength: 'Máximo 18 caracteres.'
			},
			capitalNeto: {
				number: 'Solo Números(Campo opcional).',
				maxlength: 'Máximo 18 caracteres.'
			},
			nombreRefCom1: {
				maxlength: 'Máximo 150 caracteres.'
			},
			noCuentaRefCom1: {
				number: 'Solo Números(Campo opcional).',
				maxlength: 'Máximo 15 caracteres.'
			},
			direccionRefCom1: {
				maxlength: 'Máximo 500 caracteres.'
			},
			telefonoRefCom1: {
				maxlength: 'Máximo 16 caracteres.'
			},
			extTelefonoRefCom1: {
				number: 'Solo Números(Campo opcional).',
			},
			nombreRefCom2: {
				maxlength: 'Máximo 150 caracteres.'
			},
			noCuentaRefCom2: {
				number: 'Solo Números(Campo opcional).',
				maxlength: 'Máximo 15 caracteres.'
			},
			direccionRefCom2: {
				maxlength: 'Máximo 500 caracteres.'
			},
			telefonoRefCom2: {
				maxlength: 'Máximo 16 caracteres.'
			},
			extTelefonoRefCom2: {
				number: 'Solo Números(Campo opcional).'
			},
			bancoRefBanc1: {
				maxlength: 'Máximo 50 caracteres.'
			},
			tipoCuentaRefBanc1: {
				maxlength: 'Máximo 50 caracteres.'
			},
			noCuentaRefBanc1: {
				maxlength: 'Máximo 15 caracteres.',
				number: 'Solo Números(Campo opcional).'
			},
			sucursalRefBanc1: {
				maxlength: 'Máximo 50 caracteres.'
			},
			noTarjetaRefBanc1: {
				maxlength: 'Máximo 16 caracteres.',
				number: 'Solo Números(Campo opcional).'
			},
			institucionRefBanc1: {
				maxlength: 'Máximo 50 caracteres.'
			},
			institucionEntRefBanc1: {
				maxlength: 'Máximo 50 caracteres.'
			},
			bancoRefBanc2: {
				maxlength: 'Máximo 50 caracteres.'
			},
			tipoCuentaRefBanc2: {
				maxlength: 'Máximo 50 caracteres.'
			},
			noCuentaRefBanc2: {
				maxlength: 'Máximo 15 caracteres.',
				number: 'Solo Números(Campo opcional).'
			},
			sucursalRefBanc2: {
				maxlength: 'Máximo 50 caracteres.'
			},
			noTarjetaRefBanc2: {
				maxlength: 'Máximo 16 caracteres.',
				number: 'Solo Números(Campo opcional).'
			},
			institucionRefBanc2: {
				maxlength: 'Máximo 50 caracteres.'
			},
			institucionEntRefBanc2: {
				maxlength: 'Máximo 50 caracteres.'
			},
			nombreRefPers1: {
				maxlength: 'Máximo 150 caracteres.'
			},
			domicilioRefPers1: {
				maxlength: 'Máximo 500 caracteres.'
			},
			telefonoRefPers1: {
				maxlength: 'Máximo 16 caracteres.',
			},
			extTelefonoRefPers1: {
				number: 'Solo Números(Campo opcional).',
				maxlength: 'Máximo 5 caracteres.'
			},
			nombreRefPers2: {
				maxlength: 'Máximo 150 caracteres.'
			},
			domicilioRefPers2: {
				maxlength: 'Máximo 500 caracteres.'
			},
			telefonoRefPers2: {
				maxlength: 'Máximo 16 caracteres.',
			},
			extTelefonoRefPers2: {
				number: 'Solo Números(Campo opcional).',
				maxlength: 'Máximo 5 caracteres.'
			},
			principalFuenteIng: {
				maxlength: 'Máximo 100 caracteres.'
			},
			preguntaUsuario1: {
				required : "Especifique una pregunta",
				maxlength : 'Máximo 100 Caracteres'
			},
			respuestaUsuario1: {
				required : "Especifique una respuesta",
				maxlength : 'Máximo 200 Caracteres'
			}
		}
	});

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

			var usuarioBloqueo = consultaListaPersBloq(usuarioID, esUsuarioServ, 0, 0);

			if (usuarioBloqueo.estaBloqueado == 'S') {
				$('#usuarioID').focus();
				mensajeSis("El usuario se encuentra en la lista de personas bloqueadas. <br> No se puede continuar con la operación.");
				return;
			}

			$('#nombreUsuario').val(usuario.nombreCompleto);
			$('#ctrlUsuarioID').val(usuario.usuarioID);
			nacionalidadUsuario = usuario.nacion;
			nivelRiesgoUsuario = usuario.nivelRiesgo;
			camposNivelRiesgo('N');
			consultaConocimientoUsuario(usuario.usuarioID);
		});
	}

	function consultaConocimientoUsuario(usuarioID) {

		conocimientoUsuarioServicios.consulta(1, { 'usuarioID': usuarioID }, function (conocimiento) {

			if (conocimiento == null) {
				$('#usuarioID').focus();
				mensajeSis("Ah ocurrido un error al consultar los conocimientos del usuario de servicios.");
				return;
			}

			if (+conocimiento.usuarioID > 0) {
				cargarRadioButtons(conocimiento);
				dwr.util.setValues(conocimiento);
				$('#ctrlUsuarioID').val(conocimiento.usuarioID);
				limpiarDatosDefault(conocimiento);
				agregaFormatoControles('formaGenerica');
				habilitaBoton('modifica', 'submit');
			} else {
				habilitaBoton('agrega', 'submit');
			}

			$('#nivelRiesgo').val(nivelRiesgoUsuario);
			desbloquearPantalla();
		});
	}

	function cargarRadioButtons(conocimiento) {

		if (conocimiento.PEPs == 'S') {
			$('#PEPsSI').change();
		}

		if (conocimiento.parentescoPEP == 'S') {
			$('#parentescoPEPSI').change();
		}

		if (conocimiento.importa == 'S') {
			$('#importaSI').change();
		}

		if (conocimiento.exporta == 'S') {
			$('#exportaSI').change();
		}
	}

	function limpiarDatosDefault(conocimiento) {

		if (conocimiento.fechaNombramiento == '1900-01-01') {
			$('#fechaNombramiento').val('');
		}

		if (conocimiento.funcionID == '0') {
			$('#funcionID').val('');
		}

		if (conocimiento.tipoRelacionRefPers1 == '0') {
			$('#tipoRelacionRefPers1').val('');
		}

		if (conocimiento.tipoRelacionRefPers2 == '0') {
			$('#tipoRelacionRefPers2').val('');
		}
	}

	function consultaParentesco(campo, idDescripcion) {

		var parentescoID = $(campo).val().replace(/\s/g, '');
		$('#' + idDescripcion).val('');

		if (+parentescoID == 0) {
			return;
		}

		if (+parentescoID > 0 != true) {
			$(campo).focus();
			mensajeSis("El tipo de relación ingresado es incorrecto <br> Debe ser un valor númerico.");
			return;
		}

		bloquearPantalla();
		parentescosServicio.consultaParentesco(1, {'parentescoID': parentescoID}, function(parentesco) {

			if (parentesco != null) {

				$(campo).val(+parentesco.parentescoID);
				$('#' + idDescripcion).val(parentesco.descripcion);
			} else {
				$(campo).focus();
				mensajeSis("El tipo de relación ingresado no existe.");
			}
			desbloquearPantalla();
		});
	}

	function camposNivelRiesgo(valorPEPs) {

		if (nivelRiesgoUsuario == 'A' || (nacionalidadUsuario == 'E' && valorPEPs == 'S')) {
			$("#camposUsuarioAltoRiesgo").show();
		} else {
			$("#camposUsuarioAltoRiesgo").hide();
			limpiarCamposAltoRiesgo();
		}
	}

	function limpiarCamposFuncion() {

		$('#funcionID').val('');
		$('#funcionDescripcion').val('');
		$('#fechaNombramiento').val('');
		$('#porcentajeAcciones').val('');
		$('#periodoCargo').val('');
		$('#montoAcciones').val('');
	}

	function limpiarCamposAltoRiesgo() {

		$('#preguntaUsuario1').val('');
		$('#respuestaUsuario1').val('');
		$('#preguntaUsuario2').val('');
		$('#respuestaUsuario2').val('');
		$('#preguntaUsuario3').val('');
		$('#respuestaUsuario3').val('');
		$('#preguntaUsuario4').val('');
		$('#respuestaUsuario4').val('');
	}

	function consultaFuncionPublica(funcionID) {

		if ((+funcionID > 0) != true) {
			$('#funcionID').focus();
			mensajeSis("La función ingresada es incorrecta <br> Debe ser una valor númerico.");
			return;
		}

		bloquearPantalla();
		funcionesPubServicio.consulta(1, {'funcionID': funcionID}, function (funcion) {

			if (funcion != null) {
				$('#funcionID').val(funcion.funcionID);
				$('#funcionDescripcion').val(funcion.descripcion);
				desbloquearPantalla();
			} else {
				$('#funcionID').focus();
				mensajeSis("La función ingresada no existe.");
			}
		});
	}
});

function validaNumero(e, tipoNumero) {
	var tecla = (document.all) ? e.keyCode : e.which;

	if (tecla == 8) {
		return true;
	}

	var teclasPermitidas;

	switch(tipoNumero){
		case 'entero':
			teclasPermitidas = /[0-9]/;
		break;
		case 'decimal':
			teclasPermitidas = /[,.0-9]/;
		break;
		case 'telefono':
			teclasPermitidas = /[-() 0-9]/;
		break;
		default:
			teclasPermitidas = /[0-9]/;
		break
	}

	var teclaFinal = String.fromCharCode(tecla);
	return teclasPermitidas.test(teclaFinal);
}

function limpiarCampos() {

	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('modifica', 'submit');
	limpiaFormaCompleta('formaGenerica', true, ['usuarioID']);
	nacionalidadUsuario = '';
	nivelRiesgoUsuario = '';
	reiniciarRadioButtons();
	$('tr.mostrarOC').hide();
}

function reiniciarRadioButtons() {

	$('#PEPsNO').attr('checked', true);
	$('#parentescoPEPNO').attr('checked', true);
	$('#importaNO').attr('checked', true);
	$('#exportaNO').attr('checked', true);
	$('#coberturaGeografica1').attr('checked', true);
	$('#ingAproxPorMes1').attr('checked', true);

	$('#PEPsNO').change();
	$('#parentescoPEPNO').change();
	$('#importaNO').change();
	$('#exportaNO').change();
}

function mostrarOC() {

	var numeroUsuario = parametroBean.numeroUsuario;

	parametrosSisServicio.consulta(1, { 'empresaID': 1 }, {
		async: false, callback: function (parametrosSisBean) {

			if (parametrosSisBean != null) {

				dwr.util.setValues(parametrosSisBean);
				var oficial = parametrosSisBean.oficialCumID;
				var puedeModificar = parametrosSisBean.modNivelRiesgo;

				if (+oficial == +numeroUsuario) {
					$('tr.mostrarOC').show();
					if (puedeModificar == 'S') {
						habilitaControl('nivelRiesgo');
					} else {
						deshabilitaControl('nivelRiesgo');
					}
				}
			}
		}, errorHandler: function (message) {
			mensajeSis('Error al Consultar los Parámetros Generales.');
			return false;
		}
	});
}

function funcionExito() {
	limpiarCampos();
}

function funcionError() {
}