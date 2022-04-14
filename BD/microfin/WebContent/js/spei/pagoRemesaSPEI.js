var razonSocialCliente = '';
var tipoCuentaCliente = '';
var meses = ['ENERO', 'FEBRERO', 'MARZO', 'ABRIL', 'MAYO', 'JUNIO',
    'JULIO', 'AGOSTO', 'SEPTIEMBRE', 'OCTUBRE', 'NOVIEMBRE', 'DICIEMBRE'];

$(document).ready(function () {

    esTab = true;
    var parametroBean = consultaParametrosSession();
    $('#tipoBusqueda').focus();
    deshabilitarBotones();
    $('#fecha').val(parametroBean.fechaSucursal);
    $('#usuarioAutoriza').val(parametroBean.nombreUsuario);

    // Definicion de Constantes y Enums
    var catTipoTransaccionPagoRemesa = {
        'recepcion': '1',
        'agente': '2',
        'cancelacion': '3'
    };

    // Metodos y Manejo de Eventos
    $(':text').focus(function () {
        esTab = false;
    });

    $(':text').bind('keydown', function (e) {
        if (e.which == 9 && !e.shiftKey) {
            esTab = true;
        }
    });

    $.validator.setDefaults({
        submitHandler: function (event) {

            $('#cuentaAhoID').val($('#ctrlCuentaAhoID').val());
            grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'false', 'false', 'funcionExitoPagoRemesa', 'funcionErrorPagoRemesa');
        }
    });

    $('#tipoBusqueda').change(function () {

        reinciciarPantalla();

        switch($(this).val()) {
            case '1':
                $('#buscar').show();
                $('#buscar').focus();
            break;

            case '2':
                $('#agenteSpei').show();
                $('#cuentaAhoID').focus();
            break;
        }
    });

    $('#buscar').click(function () {

        limpiarCampos();
        var tipoBusqueda = $('#tipoBusqueda').val();

        if (tipoBusqueda == '1') {

            consultaPagoRemesaGrid({'tipoLista': tipoBusqueda});
        } else {
            mensajeSis("Seleccionar tipo de busqueda REMESAS SPEI.");
        }
    });

    $('#cuentaAhoID').bind('keyup', function () {

        lista('cuentaAhoID', '2', '3', 'clienteID', $('#cuentaAhoID').val(), 'pagoRemesasListaVista.htm');
    });

    $('#cuentaAhoID').blur(function () {

        setTimeout("$('#cajaLista').hide();", 200);
        var cuentaAhoID = $(this).val().replace(/\s/g, '');

        if (esTab) {
            limpiarCamposAgentes();
            deshabilitaBoton('buscarAge', 'submit');

            if (+cuentaAhoID != 0) {
                consultaCuentaRemesas(cuentaAhoID);
            }
        }
    });

    $('#buscarAge').click(function () {

        var tipoBusqueda = $('#tipoBusqueda').val();

        if (tipoBusqueda == '2') {

            var cuentaAhoID = $('#ctrlCuentaAhoID').val();
            $('#cuentaAhoID').val(cuentaAhoID);

            var parametrosObj = {
                'tipoLista': tipoBusqueda,
                'cuentaAhoID': cuentaAhoID
            }
            limpiarCampos();
            consultaPagoRemesaGrid(parametrosObj);
        } else {
            mensajeSis("Seleccionar el tipo de busqueda AGENTES SPEI.");
        }
    });

    $('#cartaAutorizacion').click(function () {

        generarCarta();
    });

    $('#procesar').click(function () {

        var tipoBusqueda = +$('#tipoBusqueda').val();

        if (tipoBusqueda != 1 && tipoBusqueda != 2) {
            mensajeSis('Favor de seleccionar un tipo de busqueda válido.');
            return;
        }

        switch (tipoBusqueda) {
            case 1:
                $('#tipoTransaccion').val(catTipoTransaccionPagoRemesa.recepcion);
                prepararDatosRemesas();
                break
            case 2:
                $('#tipoTransaccion').val(catTipoTransaccionPagoRemesa.agente);
                prepararDatosAgentes();
                break;
        }
    });

    $('#cancelar').click(function () {

        $('#tipoTransaccion').val(catTipoTransaccionPagoRemesa.cancelacion);
        prepararDatosRemesas();
    });


    // Validaciones de la Forma
    $('#formaGenerica').validate({

        rules: {
            cuentaAhoID: {
                required: function () {
                    return $('#tipoBusqueda').val() == '2';
                }
            },
            clienteID: {
                required: function () {
                    return $('#tipoBusqueda').val() == '2';
                }
            },
            saldoDisp: {
                required: function () {
                    return $('#tipoBusqueda').val() == '2';
                }
            }

        },
        messages: {
            cuentaAhoID: {
                required: 'Especifique Cuenta de Ahorro'
            },
            clienteID: {
                required: 'Especifique Numero de Cliente'
            },
            saldoDisp: {
                required: 'Especifique Saldo Disponible'
            }
        }
    });

    // función para validar la cuenta.
    function consultaCuentaRemesas(cuentaAhoID) {

        if (+cuentaAhoID > 0 == false) {
            $('#cuentaAhoID').focus();
            mensajeSis("La cuenta de ahorro ingresada es incorrecta <br> Debe ser una valor númerico.");
            return;
        }

        bloquearPantalla();
        pagoRemesaSPEIServicio.consulta(2, { 'cuentaAhoID': cuentaAhoID }, function (cuenta) {

            if (cuenta != null && (validacionesCuenta(cuenta) == false || validacionesCliente(cuenta) == false)) {
                return;
            }

            if (cuenta == null) {
                mensajeSis("No existen remesas para la cuenta de ahorro ingresada.");
                $('#cuentaAhoID').focus();
                return;
            }

            $('#cuentaAhoID').val(cuenta.cuentaAho);
            $('#ctrlCuentaAhoID').val(cuenta.cuentaAhoID);
            $('#clienteID').val(cuenta.clienteID);
            $('#nombreOrd').val(cuenta.nombreOrd);
            $('#saldoDisp').val(cuenta.saldoDisponible);
            habilitaBoton('buscarAge', 'submit');
            $('#buscarAge').focus();
            agregaFormatoControles('formaGenerica');
            desbloquearPantalla();

            razonSocialCliente = cuenta.razonSocial;
            tipoCuentaCliente = cuenta.tipoCuenta;
        });
    }

    function validacionesCuenta(cuenta) {

        if (cuenta.cuentaAhoID > 0 == false) {
            $('#cuentaAhoID').focus();
            mensajeSis("La cuenta de ahorro ingresada no existe.");
            return;
        }

        if (validacionEstCuenta == false) {
            return;
        }

        if (+cuenta.saldoDisponible > 0 != true) {
            $('#cuentaAhoID').focus();
            mensajeSis("La cuenta no tiene saldo disponible.");
            return;
        }

        return true;
    }

    // función para validar el estatus de la cuenta.
    function validacionEstCuenta() {

        var estatusAutorizado = false;

        switch (cuenta.estatusCuenta) {
            case 'A':
                estatusAutorizado = true;
                break;
            case 'R':
                $('#cuentaAhoID').focus();
                mensajeSis("La cuenta de ahorro ingresada NO está autorizada.");
                break;
            case 'C':
                $('#cuentaAhoID').focus();
                mensajeSis("La cuenta de ahorro ingresada está cancelada.");
                break;
            case 'B':
                $('#cuentaAhoID').focus();
                mensajeSis("La cuenta de ahorro ingresada está bloqueada.");
                break;
            case 'I':
                $('#cuentaAhoID').focus();
                mensajeSis("La cuenta de ahorro ingresada está inactiva.");
                break;
            default:
                $('#cuentaAhoID').focus();
                mensajeSis("Ocurrió un error en la validación del estatus de la cuenta.");
                break;
        }

        return estatusAutorizado;
    }

    function validacionesCliente(cuenta) {

        if (cuenta.clienteID > 0 == false) {
            $('#cuentaAhoID').focus();
            mensajeSis("El cliente no existe en los registros.");
            return;
        }

        var estatusAutorizado = false;

        switch (cuenta.estatusOrd) {
            case 'A':
                estatusAutorizado = true;
                break;
            case 'I':
                $('#cuentaAhoID').focus();
                mensajeSis("El cliente se encuentra inactivo.");
                break;
            case 'C':
                $('#cuentaAhoID').focus();
                mensajeSis("El cliente se encuentra cancelado.");
                break;
            case 'B':
                $('#cuentaAhoID').focus();
                mensajeSis("El cliente se encuentra bloqueado.");
                break;
            default:
                $('#cuentaAhoID').focus();
                mensajeSis("Ocurrió un error en la validación del estatus del cliente.");
                break;
        }

        return estatusAutorizado;
    }

    // funcion para consultar y obtener el grid con las remesas.
    function consultaPagoRemesaGrid(parametrosObj) {

        bloquearPantalla();
        $.post("gridPagoRemesaSPEI.htm", parametrosObj, function (grid) {

            if (grid.length > 0) {
                $('#gridPagoRemesaSPEI').html(grid);
                $('#gridPagoRemesaSPEI').show();
                agregaFormatoControles('formaGenerica');
            }
            desbloquearPantalla();
        });
    }

    function limpiarCampos() {

        $('#gridPagoRemesaSPEI').html("");
        $('#gridPagoRemesaSPEI').hide();
        $('#cantAurotizar').val('0');
        $('#montoAurotizar').val('0.00');
        deshabilitarBotones();
    }

    function limpiarCamposAgentes() {

        limpiaFormaCompleta('formaGenerica', true, ['usuarioAutoriza', 'tipoBusqueda', 'fecha', 'cuentaAhoID']);
        limpiarCampos();
    }

});

function reinciciarPantalla() {

    limpiaFormaCompleta('formaGenerica', true, ['usuarioAutoriza', 'tipoBusqueda', 'fecha']);
    $('#gridPagoRemesaSPEI').html('');
    $('#gridPagoRemesaSPEI').hide();
    $('#buscar').hide();
    $('#agenteSpei').hide();
    deshabilitaBoton('buscarAge', 'submit');
    deshabilitarBotones();
}

function deshabilitarBotones() {

    deshabilitaBoton('procesar', 'submit');
    deshabilitaBoton('cancelar', 'submit');
    deshabilitaBoton('cartaAutorizacion', 'button');
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

// función para preparar datos (REMESAS SPEI y/o Cancelación).
function prepararDatosRemesas() {

    var seleccionados = $("#tbodyRemesas").find('.checkRemesa:checked');

    if (seleccionados.length < 1) {
        mensajeSis("No se ha seleccionado ninguna remesa.");
        return;
    }

    var numCodigo = $('input[name=consecutivoID]').length;

    $('#datosGrid').val("");

    for (var i = 1; i <= numCodigo; i++) {

        if ($('#' + "enviar" + i + "").attr('checked') == true) {
            console.log($('#datosGrid').val());
            if (i == 1) {
                $('#datosGrid').val($('#datosGrid').val() +
                    parametroBean.nombreUsuario + ']' +
                    document.getElementById("speiRemID" + i).value + ']' +
                    ' ');


            } else {
                $('#datosGrid').val($('#datosGrid').val() + '[' +
                    parametroBean.nombreUsuario + ']' +
                    document.getElementById("speiRemID" + i).value + ']' +
                    ' ');
            }
        }
    }
}

// función para preparar datos (AGENTES SPEI).
function prepararDatosAgentes() {

    var seleccionados = $("#tbodyRemesas").find('.checkRemesa:checked');
    var montoTotal = +$('#montoAurotizar');
    var saldoDisponible = +$('#saldoDisp').val();

    if (seleccionados.length < 1) {
        mensajeSis("No se ha seleccionado ninguna remesa para envíar.");
        return;
    }

    if (saldoDisponible <= montoTotal) {
        mensajeSis("El monto a pagar rebasa el saldo disponible.");
        return;
    }

    var numCodigo = $('input[name=consecutivoID]').length;

    $('#datosGrid').val("");

    for (var i = 1; i <= numCodigo; i++) {

        if ($('#' + "enviar" + i + "").attr('checked') == true) {
            if (i == 1) {
                $('#datosGrid').val($('#datosGrid').val() +
                    document.getElementById("usuarioAutoriza").value + ']' +
                    document.getElementById("speiRemID" + i + "").value + ']' +
                    document.getElementById("cuentaAhoID").value + ']' +
                    document.getElementById("clienteID").value + ']' +
                    ' ');


            } else {
                $('#datosGrid').val($('#datosGrid').val() + '[' +
                    document.getElementById("usuarioAutoriza").value + ']' +
                    document.getElementById("speiRemID" + i + "").value + ']' +
                    document.getElementById("cuentaAhoID").value + ']' +
                    document.getElementById("clienteID").value + ']' +
                    ' ');

            }
        }
    }
}

function funcionExitoPagoRemesa() {
    $('#tipoBusqueda').val('');
    reinciciarPantalla();
}

function generarCarta() {

    var checkSeleccionados = $("#gridPagoRemesaSPEI").find('input[name=enviar]:checked');
    var speiRemesasArr = [];

    if (checkSeleccionados.length < 1) {
        mensajeSis("No se ha seleccionado ninguna remesa para generar la carta de autorización.");
        return;
    }

    checkSeleccionados.closest('tr').each(function () {
        var speiRemesaID = $(this).find('td > input[name=speiRemID]').val();
        speiRemesasArr.push({ 'SpeiRemesaID': +speiRemesaID });
    });

    var speiRemesas = JSON.stringify(speiRemesasArr);

    var tituloCarta = 'TRANSFERENCIA ELECTRÓNICA(SPEI)';
    var lugarSucursal = parametroBean.direccionInstitucion.toUpperCase();
    var fechaSucursal = fechaLetras(parametroBean.fechaSucursal);
    var nombreInstitucion = parametroBean.nombreInstitucion.toUpperCase();
    var sucursal = parametroBean.nombreSucursal;
    var nombreCliente = $('#nombreOrd').val().toUpperCase();
    var razonSocial = razonSocialCliente.toUpperCase();
    var clienteID = $('#clienteID').val().toUpperCase();
    var tipoCuenta = tipoCuentaCliente.toUpperCase();
    var cuentaAhoID = $('#ctrlCuentaAhoID').val().toUpperCase();
    var nomUsuario = parametroBean.nombreUsuario.toUpperCase();

    try {
        generarCartaAutorizacion(1, tituloCarta, lugarSucursal, fechaSucursal, nombreInstitucion, sucursal, nombreCliente, razonSocial, clienteID, tipoCuenta, cuentaAhoID, '', speiRemesas, nomUsuario);
        habilitaBoton('procesar', 'submit');
        habilitaBoton('cancelar', 'submit');
    } catch (e) {
        mensajeSis("Ocurrió un error al tratar de generar la carta de autorización.");
    }
}

function fechaLetras(fecha) {

    var fechaArray = fecha.split('-');
    var fechaLetras = fechaArray[2] + ' DE ' + meses[+fechaArray[1] - 1] + ' DEL ' + fechaArray[0];

    return fechaLetras;
}

function funcionErrorPagoRemesa() {

}