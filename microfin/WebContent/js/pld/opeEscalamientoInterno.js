var proceso = {
    'OPERACION': 'OPERACION'
};
$(document).ready(function() {
    esTab = true;
    //Definicion de Constantes y Enums
    var catTipoActualizacionOpeEscalamientoVista = {
        'estatus': '1'
    };

    $(".motivosEscala").hide();

    var varResultadoOperacion = '';
    var clickAdjuntar = 0;
    var varclaveJustificacion = '';
    var valorclaveJustificacion = '';
    var varConsulta = '';
    var autorizar = 0;
    var OperacionID = 0;
    //------------ Metodos y Manejo de Eventos -----------------------------------------
    agregaFormatoControles('formaGenerica');

    $.validator.setDefaults({
        submitHandler: function(event) {
            //grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','procesoEscalamientoID');
        }
    });

    $('#gridArchivosClienteOpe').html("");
    $('#gridArchivosClienteOpe').hide();
    $('#procesoEscalamientoID').focus();

    $(':text').focus(function() {
        esTab = false;
    });

    $(':text').bind('keydown', function(e) {
        if (e.which == 9 && !e.shiftKey) {
            esTab = true;
        }
    });

    $('#autorizar').click(function() {
        OperacionID = $('#folioOperacionID').asNumber();
        if (OperacionID > 0) {
            habilitarEditables();
            autorizar = 1;
            $('#divGuardar').show();
            varResultadoOperacion = 'A';
            $('#resultadoRevision').val(varResultadoOperacion);
            consultaClaveJutificacion();
            clickAdjuntar = 0;
            varConsulta = 0;
            //$('#gridArchivosClienteOpe').html("");
            $('#gridArchivosClienteOpe').hide();
            if ($('#resultadoRev').val() == 'EN SEGUIMIENTO') {
                consultaArchivClienteOpEliminar();
            }
        }
    });

    $('#pendiente').click(function() {
        OperacionID = $('#folioOperacionID').asNumber();
        if (OperacionID > 0) {
            autorizar = 0;
            habilitarEditables();
            $('#divGuardar').show();
            varResultadoOperacion = 'S';
            $('#resultadoRevision').val(varResultadoOperacion);
            consultaClaveJutificacion();
            $('#gridSolFondeo').hide();
            clickAdjuntar = 0;
            varConsulta = 0;
            //$('#gridArchivosClienteOpe').html("");
            $('#gridArchivosClienteOpe').hide();
            if ($('#resultadoRev').val() == 'EN SEGUIMIENTO') {
                consultaArchivClienteOpEliminar();
            }
        }
    });

    $('#rechazar').click(function() {
        OperacionID = $('#folioOperacionID').asNumber();
        if (OperacionID > 0) {
            autorizar = 0;
            habilitarEditables();
            $('#divGuardar').show();
            varResultadoOperacion = 'R';
            $('#resultadoRevision').val(varResultadoOperacion);
            consultaClaveJutificacion();
            $('#gridSolFondeo').hide();
            clickAdjuntar = 0;
            varConsulta = '0';
            if ($('#resultadoRev').val() == 'EN SEGUIMIENTO') {
                consultaArchivClienteOpEliminar();
            }
        }
    });

    $('#consultar').click(function() {
        OperacionID = $('#folioOperacionID').asNumber();
        if (OperacionID > 0) {
            autorizar = 0;
            $('#divGuardar').show();
            $('#gridSolFondeo').hide();
            deshabilitarEditables();
            clickAdjuntar = 0;
            varConsulta = '1';
            consultaArchivClienteOp();
            $('#gridArchivosClienteOpe').show();
            $('#claveJustificacion').val(valorclaveJustificacion).selected = true;
        }
    });

    $('#guardar').click(function(event) {
        var archCteBean = {
            'clienteID': $('#clienteID').val()
        };

        setTimeout("$('#cajaLista').hide();", 200);
        if ($('#claveJustificacion').val() == '' || $('#notasComentarios').val() == '') {
            $('#tipoActualizacion').val(catTipoActualizacionOpeEscalamientoVista.estatus);
        } else {
            clienteArchivosServicio.consulta(9, archCteBean, function(cliente) {
                if (cliente != null) {
                    $('#tipoActualizacion').val(catTipoActualizacionOpeEscalamientoVista.estatus);
                    $('#autorizacion').val(autorizar);
                    grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'procesoEscalamientoID');
                } else {
                    //event.preventDefault();
                    confirmarGuardar(event);
                }
            });
        }
    });

    $('#btnAdjArchivos').click(function() {
        clickAdjuntar = 1;
        subirArchivos($('#clienteID').val());
    });

    $('#guardar').attr('tipoActualizacion', '1');

    $('#folioOperacionID').blur(function() {
        esTab = true;
        consultaOperacionesEscala(this.id);
        varConsulta = 0;
        //$('#divGuardar').show();
        if (varConsulta > 0) {
            $('#claveJustificacion').val(valorclaveJustificacion).selected = true;
            $('#gridArchivosClienteOpe').show();
        } else {
            $('#gridArchivosClienteOpe').hide();
        }
        $('#consultar').focus();
        deshabilitarEditables();
        $('#divGuardar').hide();
    });

    $('#procesoEscalamientoID').change(function() {
        limpiaForma();
    });

    $('#folioOperacionID').bind('keyup', function(e) {
        if (this.value.length >= 0) {
            var camposLista = new Array();
            var parametrosLista = new Array();

            camposLista[0] = "procesoEscalamientoID";
            camposLista[1] = "nombreCliente";
            parametrosLista[0] = $('#procesoEscalamientoID').val();
            parametrosLista[1] = $('#folioOperacionID').val();
            if ($('#procesoEscalamientoID').val() == proceso.OPERACION) {
                lista('folioOperacionID', '1', '2', camposLista, parametrosLista, 'opeEscalamientoInternoListaVista.htm');
            } else {
                lista('folioOperacionID', '1', '1', camposLista, parametrosLista, 'opeEscalamientoInternoListaVista.htm');
            }


        }
    });

    // llamada a metodos
    consultaProcesoEscalamiento();
    var parametroBean = consultaParametrosSession();
    $('#funcionarioUsuarioID').val(parametroBean.numeroUsuario);
    $('#fechaGestion').val(parametroBean.fechaSucursal);


    //------------ Validaciones de la Forma -------------------------------------
    $('#formaGenerica').validate({

        rules: {
            procesoEscalamientoID: 'required',
            folioOperacionID: 'required',
            claveJustificacion: 'required',
            notasComentarios: 'required'
        },

        messages: {

            procesoEscalamientoID: 'Especifique Proceso de Escalamiento',
            folioOperacionID: 'Especifique Operación',
            claveJustificacion: 'Especifique Justificación',
            notasComentarios: 'Especifique Detalle de la Decisión'
        }
    });


    //------------ Validaciones de Controles -------------------------------------

    function consultaOperacionesEscala(idControl) {
        var jqfolio = eval("'#" + idControl + "'");
        var folioOpe = $(jqfolio).val();
        var OpEscalaBeanCon = {
            'folioOperacionID': folioOpe,
            'procesoEscalamientoID': $('#procesoEscalamientoID').val()
        };
        var consultaPrincipal = 1;
        setTimeout("$('#cajaLista').hide();", 200);

        if (folioOpe != '' && !isNaN(folioOpe) && esTab) {
            opeEscalamientoInternoServicio.consulta(consultaPrincipal, OpEscalaBeanCon, function(opeEscalaInt) {
                if (opeEscalaInt != null) {
                    varConsulta = 1;
                    dwr.util.setValues(opeEscalaInt);
                    varclaveJustificacion = opeEscalaInt.claveJustificacion;
                    varResultadoOperacion = opeEscalaInt.resultadoRevision;
                    if (opeEscalaInt.resultadoRevision == 'S') {
                        $('#resultadoRev').val('EN SEGUIMIENTO');
                        habilitaBoton('guardar', 'submit');
                        habilitaBoton('btnAdjArchivos', 'submit');
                        habilitaBoton('autorizar', 'submit');
                        habilitaBoton('pendiente', 'submit');
                        habilitaBoton('rechazar', 'submit');
                    }
                    if (opeEscalaInt.resultadoRevision == 'R') {
                        $('#resultadoRev').val('RECHAZADA');
                        deshabilitaBoton('guardar', 'submit');
                        deshabilitaBoton('btnAdjArchivos', 'submit');
                        deshabilitaBoton('autorizar', 'submit');
                        deshabilitaBoton('pendiente', 'submit');
                        deshabilitaBoton('rechazar', 'submit');
                    }
                    if (opeEscalaInt.resultadoRevision == 'A') {
                        $('#resultadoRev').val('AUTORIZADA');
                        deshabilitaBoton('guardar', 'submit');
                        deshabilitaBoton('btnAdjArchivos', 'submit');
                        deshabilitaBoton('autorizar', 'submit');
                        deshabilitaBoton('pendiente', 'submit');
                        deshabilitaBoton('rechazar', 'submit');
                    }
                    consultaSucursal('sucursalDeteccion');
                    if (opeEscalaInt.fechaGestion == '1900-01-01') {
                        $('#funcionarioUsuarioID').val(parametroBean.numeroUsuario);
                        $('#fechaGestion').val(parametroBean.fechaSucursal);
                    }

                    if (parseInt(opeEscalaInt.matchNivelRiesgo) > 0) {
                        $(".motivosEscala").hide();
                        $(".motivoAltoRiesgo").show();
                    } else {
                        $(".motivosEscala").show();
                        $(".motivoAltoRiesgo").hide();
                    }

                    valorclaveJustificacion = opeEscalaInt.claveJustificacion;
                    consultaUsuario('funcionarioUsuarioID');
                    //consultaArchivClienteOp();
                    consultaClaveJutificacion();
                    $('#claveJustificacion').val(valorclaveJustificacion).selected = true;
                } else {
                    mensajeSis("No Existe la Operación");
                    limpiaForma();
                    $(jqfolio).focus();
                }
            });
        }
    }

    function consultaSucursal(idControl) {
        var jqSucursal = eval("'#" + idControl + "'");
        var numSucursal = $(jqSucursal).val();
        var conSucursal = 2;
        setTimeout("$('#cajaLista').hide();", 200);
        if (numSucursal != '' && !isNaN(numSucursal)) {
            sucursalesServicio.consultaSucursal(conSucursal, numSucursal, function(sucursal) {
                if (sucursal != null) {
                    $('#descripSucursal').val(sucursal.nombreSucurs);
                }
            });
        }
    }

    function consultaUsuario(idControl) {
        var jqUsu = eval("'#" + idControl + "'");
        var numUsuario = $(jqUsu).val();
        var usuarioBeanCon = {
            'usuarioID': numUsuario
        };
        setTimeout("$('#cajaLista').hide();", 200);
        if (numUsuario != '' && !isNaN(numUsuario) && esTab) {
            usuarioServicio.consulta(1, usuarioBeanCon, function(usuario) {
                if (usuario != null) {
                    $('#nombreUsuGestion').val(usuario.nombreCompleto);
                } else {
                    $('#nombreUsuGestion').val("");
                }
            });
        }
    }

    function deshabilitarEditables() {
        deshabilitaControl('claveJustificacion');
        deshabilitaControl('solSegAdiSi');
        deshabilitaControl('solSegAdiNo');
        deshabilitaControl('notasComentarios');
        deshabilitaBoton('guardar', 'submit');
        deshabilitaBoton('btnAdjArchivos', 'submit');
    }

    function habilitarEditables() {
        habilitaControl('claveJustificacion');
        habilitaControl('solSegAdiSi');
        habilitaControl('solSegAdiNo');
        habilitaControl('notasComentarios');
        habilitaBoton('guardar', 'submit');
        habilitaBoton('btnAdjArchivos', 'submit');
    }



    // funcion para llenar el combo de procesos de escalamiento
    function consultaProcesoEscalamiento() {
        dwr.util.removeAllOptions('procesoEscalamientoID');
        dwr.util.addOptions('procesoEscalamientoID', {
            '': 'SELECCIONAR'
        });
        procesoEscalamientoInternoServicio.listaCombo(1, function(procesoEscala) {
            dwr.util.addOptions('procesoEscalamientoID', procesoEscala, 'procesoEscalamientoID', 'descripcion');
        });
    }

    // funcion para llenar el combo de procesos de escalamiento
    function consultaClaveJutificacion() {
        var resultadoOp = {
            'resultadoOpeEscalaIntID': varResultadoOperacion
        };
        dwr.util.removeAllOptions('claveJustificacion');
        dwr.util.addOptions('claveJustificacion', {
            '': 'SELECCIONAR'
        });
        clavesPorResultadoOpeEscIntServicio.listaCombo(1, resultadoOp, function(claveJus) {
            dwr.util.addOptions('claveJustificacion', claveJus, 'claveJustificacionOpeEscalaIntID', 'descripcionJustificacionOpeEscalaInt');
        });

        if (varConsulta == 1) {
            $('#claveJustificacion').val(valorclaveJustificacion).selected = true;

        }
    }

    function consultaArchivClienteOp() {
        if ($('#clienteID').val() == null || $('#clienteID').val() == '') {

        } else {
            var params = {};
            params['tipoLista'] = 5;
            params['clienteID'] = $('#clienteID').val();
            params['prospectoID'] = "0";
            params['tipoDocumento'] = '9';
            params['opcionElimina'] = '2';

            $.post("opeEscalamientoInternoFileUploadGridVista.htm", params, function(data) {
                if (data.length > 0) {
                    $('#gridArchivosClienteOpe').html(data);
                    $('#gridArchivosClienteOpe').show();
                } else {
                    $('#gridArchivosClienteOpe').html("");
                    $('#gridArchivosClienteOpe').hide();
                }
            });
        }
    }

    function confirmarGuardar(event) {
        $('#tipoActualizacion').val('1');
        confirmar = confirm("¿Deseas guardar sin adjuntar Archivos?");
        if (confirmar == true) {
            // si pulsamos en aceptar
            $('#tipoActualizacion').val('1');
            $('#autorizacion').val(autorizar);
            grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'procesoEscalamientoID');

        } else {
            subirArchivos($('#clienteID').val());
        }

    }
});

function consultaArchivClienteOpEliminar() {
    if ($('#clienteID').val() == null || $('#clienteID').val() == '') {

    } else {
        var params = {};
        params['tipoLista'] = 5;
        params['clienteID'] = $('#clienteID').val();
        params['prospectoID'] = "0";
        params['tipoDocumento'] = '9';
        params['opcionElimina'] = '1';


        $.post("opeEscalamientoInternoFileUploadGridVista.htm", params, function(data) {
            if (data.length > 0) {
                $('#gridArchivosClienteOpe').html(data);
                $('#gridArchivosClienteOpe').show();
            } else {
                $('#gridArchivosClienteOpe').html("");
                $('#gridArchivosClienteOpe').hide();
            }
        });
    }
}

var ventanaArchivos = "";

function subirArchivos(Cte) {
    var url = "opeEscalamientoIntFileUploadVista.htm?Cte=" + Cte;
    var leftPosition = (screen.width) ? (screen.width - 850) / 2 : 0;
    var topPosition = (screen.height) ? (screen.height - 500) / 2 : 0;

    ventanaArchivos = window.open(url, "PopUpSubirArchivo", "width=980,height=340,scrollbars=yes,status=yes,location=false,addressbar=false,menubar=0,toolbar=0" +
        "left=" + leftPosition +
        ",top=" + topPosition +
        ",screenX=" + leftPosition +
        ",screenY=" + topPosition);

}

function cerrarVentanaArchivos() {
    //la referencia de la ventana es el objeto window del popup. Lo utilizo para acceder al método close
    ventanaArchivos.close();
}




function verArchivosCliente(id, idTipoDoc, idarchivo, recurso) {
    var varClienteVerArchivo = $('#clienteID').val();
    var varTipoDocVerArchivo = idTipoDoc;
    var varTipoConVerArchivo = 10;
    var parametros = "?clienteID=" + varClienteVerArchivo + "&prospectoID=0" + "&tipoDocumento=" +
        varTipoDocVerArchivo + "&tipoConsulta=" + varTipoConVerArchivo + "&recurso=" + recurso;
    var pagina = "clientesVerArchivos.htm" + parametros;
    var idrecurso = eval("'#recursoCteInput" + id + "'");
    var extensionArchivo = $(idrecurso).val().substring($(idrecurso).val().lastIndexOf('.'));
    extensionArchivo = extensionArchivo.toLowerCase();
    if (extensionArchivo == ".jpg" || extensionArchivo == ".png" || extensionArchivo == ".jpeg" || extensionArchivo == ".gif") {
        $('#imgCliente').attr("src", pagina);
        $('#imagenCte').html();
        // $.blockUI({message: $('#imagenCte')});
        $.blockUI({
            message: $('#imagenCte'),
            css: {
                top: ($(window).height() - 400) / 2 + 'px',
                left: ($(window).width() - 400) / 2 + 'px',
                width: '400px'
            }
        });
        $('.blockOverlay').attr('title', 'Clic para Desbloquear').click($.unblockUI);
    } else {
        window.location = pagina;
        $('#imagenCte').hide();
    }
}

function eliminaArchivo(clienteArchivosID) {
    confirmarEliminar(clienteArchivosID);
}


function confirmarEliminar(folioDocumento) {
    confirmar = confirm("¿Deseas eliminar el archivo?");
    if (confirmar) {
        // si pulsamos en aceptar
        var bajaFolioDocumentoCliente = 1;
        var clienteArchivoBean = {
            'clienteID': $('#clienteID').val(),
            'clienteArchivosID': folioDocumento
        };
        $('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
        $('#contenedorForma').block({
            message: $('#mensaje'),
            css: {
                border: 'none',
                background: 'none'
            }
        });
        clienteArchivosServicio.bajaArchivosCliente(bajaFolioDocumentoCliente, clienteArchivoBean, function(mensajeTransaccion) {
            if (mensajeTransaccion != null) {
                mensajeSis(mensajeTransaccion.descripcion);
                $('#contenedorForma').unblock();
                consultaArchivClienteOpEliminar();
            } else {
                mensajeSis("Ocurrió un Error al Eliminar el Documento.");
            }
        });
    } else {
        event.preventDefault();
    }
}

function limpiaForma() {
    inicializaForma('formaGenerica', 'procesoEscalamientoID');
    $('#gridArchivosClienteOpe').html("");
    $('#gridArchivosClienteOpe').hide();
    $('#divGuardar').hide();
    $('#procesoEscalamientoID').focus();
    $(".motivosEscala").hide();
    $(".motivoAltoRiesgo").show();
}

function resultadoPopUp() {
    consultaArchivClienteOpEliminar();
}