var meses = ['ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO',
    'JULIO', 'AGOSTO', 'SEPTIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE'];

$(document).ready(function () {

	esTab = true;

	var parametrosBean = consultaParametrosSession();
	$('#fecha').val(parametrosBean.fechaSucursal);
	$('#usuarioAutoriza').val(parametrosBean.numeroUsuario);

	// Definicion de Constantes y Enums
	var catTipoTransaccionPagoRemesa = {
		'transferencia': '1',
	};

	// ------------ Metodos y Manejo de Eventos
	// -----------------------------------------
	deshabilitarBotones();

	$(':text').focus(function () {
		esTab = false;
	});

	$(':text').bind('keydown', function (e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$('#cartaAutorizacion').click(function () {

        generarCarta();
    });

	$('#procesar').click(function () {

		$('#tipoTransaccion').val(catTipoTransaccionPagoRemesa.transferencia);
		guardarDatosRemesas();

	});

	$.validator.setDefaults({
		submitHandler: function (event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'false', 'false', 'funcionExitoPagoRemesa', 'funcionErrorPagoRemesa');
		}
	});

	$('#formaGenerica').validate({

		rules: {

		},
		messages: {

		}
	});

	cargaGridPagoRemesasTraspasos();
});

function cargaGridPagoRemesasTraspasos() {

	$('#cantAurotizar').val('0');
	$('#montoAurotizar').val('0.0');
	$('#gridPagoRemesasTraspasosSPEI').html("");
	$('#gridPagoRemesasTraspasosSPEI').hide();
	deshabilitarBotones();
	consultaPagoRemesa();
}

//funcion para consultar los anticipos de los proveedores
function consultaPagoRemesa() {

	bloquearPantalla();
	$.post("gridPagoRemesasTraspasosSPEI.htm", {'tipoLista':1}, function (data) {

		if (data.length > 0) {
			$('#gridPagoRemesasTraspasosSPEI').html(data);
			$('#gridPagoRemesasTraspasosSPEI').show();
			agregaFormatoControles('formaGenerica');

			if ($('#speiTransID1').val() == undefined) {
				mensajeSis("No se tienen Transferencias SPEI Pendientes");
			} else {
				desbloquearPantalla();
			}
		} else {
			$('#gridPagoRemesasTraspasosSPEI').html("");
			$('#gridPagoRemesasTraspasosSPEI').hide();
			mensajeSis("No se tienen Pagos por Autorizar");
		}
	});
}

// función que se ejecuta al seleccionar la opción Todos del GRID.
function seleccionarTodos (check) {

    if ($(check).is(':checked')) {
        $('#tablaGrid .checkRemesa').attr('checked', true);
        sumarRemesas();
    } else {
        $('#tablaGrid .checkRemesa').attr('checked', false);
        deshabilitarBotones();
        $('#cantAurotizar').val('0');
        $('#montoAurotizar').val('0.00');
    }
}

// función que se ejecuta al interactuar con los checkbox del GRID.
function sumarRemesas() {

    deshabilitarBotones();
    var seleccionados = $("#tbodyRemesas").find('.checkRemesa:checked');
    var cantidadRemesas = seleccionados.length || 0;
    var montoTotal = 0.00;

    if (cantidadRemesas > 0) {
        habilitaBoton('cartaAutorizacion', 'button');
    }

    seleccionados.closest('tr').each(function () {
        var monto = (+$(this).find('td > input.montoRemesa').val().replace(/[,]/g, ''));
        montoTotal = montoTotal + monto;
    });

    $('#cantAurotizar').val(cantidadRemesas);
    $('#montoAurotizar').val(montoTotal || 0.00);
    agregaFormatoControles('formaGenerica');

    $("#seleccionaTodos").attr("checked", $(".checkRemesa").length == seleccionados.length);
}

function guardarDatosRemesas() {

	var numCodigo = $('input[name=consecutivoID]').length;
	$('#datosGrid').val("");

	for (var i = 1; i <= numCodigo; i++) {
		if ($('#' + "enviar" + i + "").attr('checked') == true) {
			if (i == 1) {
				$('#datosGrid').val($('#datosGrid').val() +
					document.getElementById("usuarioAutoriza").value + ']' +
					document.getElementById("speiTransID" + i + "").value + ']' +
					document.getElementById("cuentaAho" + i + "").value + ']' +
					document.getElementById("clienteID" + i + "").value + ']' +
					document.getElementById("monto" + i + "").value + ']');

			} else {
				$('#datosGrid').val($('#datosGrid').val() + '[' +
					document.getElementById("usuarioAutoriza").value + ']' +
					document.getElementById("speiTransID" + i + "").value + ']' +
					document.getElementById("cuentaAho" + i + "").value + ']' +
					document.getElementById("clienteID" + i + "").value + ']' +
					document.getElementById("monto" + i + "").value + ']');
			}
		}
	}
}

function deshabilitarBotones() {

	deshabilitaBoton('procesar', 'submit');
	deshabilitaBoton('cartaAutorizacion', 'button');
}

function generarCarta() {

    var checkSeleccionados = $("#tbodyRemesas").find('input[name=enviar]:checked');
    var remesasArr = [];

    if (checkSeleccionados.length < 1) {
        mensajeSis("No se ha seleccionado ninguna remesa para generar la carta de autorización.");
        return;
    }

	var fecha = new Date();
	var horaActual = fecha.getHours() + ":" + fecha.getMinutes() + ":" + fecha.getSeconds();
	var fechaHora = parametroBean.fechaSucursal + " " +horaActual;

    checkSeleccionados.closest('tr').each(function () {
		var cuentaClabe =  $(this).find('td > input[name=clabeCli]').val();
		var banco = $(this).find('td > input[name=banco]').val();
		var sucursal = $(this).find('td > input[name=sucursal]').val();
		var monto = $(this).find('td > input[name=monto]').val();

		remesasArr.push({
			'cuentaClabe': cuentaClabe,
			'banco': banco,
			'sucursal': sucursal,
			'fechaHora': fechaHora,
			'monto': monto,
			'ivaPorPagar': '0.0',
			'comision': '0.0',
			'conceptoPago': 'REMESASWS',
			'totalCargo': monto
		});
    });

    var tituloCarta = 'ABONO A CUENTA';
    var lugarSucursal = parametroBean.direccionInstitucion.toUpperCase();
    var fechaSucursal = fechaLetras(parametroBean.fechaSucursal);
    var nombreInstitucion = parametroBean.nombreInstitucion.toUpperCase();
    var sucursal = parametroBean.nombreSucursal;
    var nombreCliente = $('#nombreRemesedora1').val().toUpperCase();
    var razonSocial = $('#razonSocialRemesedora1').val().toUpperCase();
    var clienteID = $('#clienteIDRemesedora1').val().toUpperCase();
    var tipoCuenta = $('#tipoCuentaRemesedora1').val().toUpperCase();
    var cuentaAhoID = $('#cuentaRemesedora1').val().toUpperCase();
    var nomUsuario = parametroBean.nombreUsuario.toUpperCase();
	var montoTotal = $('#montoAurotizar').val();

    try {
        generarCartaAutorizacion(2, tituloCarta, lugarSucursal, fechaSucursal, nombreInstitucion, sucursal, nombreCliente, razonSocial, clienteID, tipoCuenta, cuentaAhoID, montoTotal, remesasArr, nomUsuario);
        habilitaBoton('procesar', 'submit');
    } catch (e) {
        mensajeSis("Ocurrió un error al tratar de generar la carta de autorización.");
    }
}

function fechaLetras(fecha) {

    var fechaArray = fecha.split('-');
    var fechaLetras = fechaArray[2] + ' DE ' + meses[+fechaArray[1] - 1] + ' DEL ' + fechaArray[0];

    return fechaLetras;
}

function funcionExitoPagoRemesa() {

	consultaPagoRemesa();
	$('#montoAurotizar').val('0.00');
	$('#cantAurotizar').val('0');
	deshabilitarBotones();
}

function funcionErrorPagoRemesa() {
}