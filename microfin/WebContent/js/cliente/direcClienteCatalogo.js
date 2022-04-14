$(document).ready(function() {
    esTab = true;
    var exito = 0;
    $('#clienteID').focus();
    var permiteResidentesExt = '';
    var paisResidencia = '';
    expedienteBean = {
        'clienteID': 0,
        'tiempo': 0,
        'fechaExpediente': '1900-01-01',
    };
    listaPersBloqBean = {
        'estaBloqueado': 'N',
        'coincidencia': 0
    };
    var esCliente = 'CTE';
    var esUsuario = 'USS';
    //Definicion de Constantes y Enums  
    var catTipoTransaccionDirCliente = {
        'agrega': '1',
        'modifica': '2',
        'elimina': '3'
    };

    var catTipoConsultaDirCliente = {
        'principal': 1,
        'foranea': 2,
        'comboBox': 3,
        'oficial': 4,
        'verOficial': 5,
        'fiscal': 10
    };

    //------------ Metodos y Manejo de Eventos -----------------------------------------
    deshabilitaBoton('modifica', 'submit');
    deshabilitaBoton('agrega', 'submit');
    deshabilitaBoton('elimina', 'submit');
    if ($('#flujoCliNumCli').val() != undefined) {
        if (!isNaN($('#flujoCliNumCli').val())) {
            var numCliFlu = Number($('#flujoCliNumCli').val());
            if (numCliFlu > 0) {
                $('#clienteID').val($('#flujoCliNumCli').val());
                consultaCliente('clienteID');
                if ($('#flujoCliDirOfi').val() != undefined) {
                    if (!isNaN($('#flujoCliDirOfi').val())) {
                        var numDirFlu = Number($('#flujoCliDirOfi').val());
                        if (numDirFlu > 0) {
                            $('#direccionID').val($('#flujoCliDirOfi').val());
                            validaDirCliente();
                            esTab = false;
                        } else {
                            $('#direccionID').val('0');
                            $('#direccionID').focus().select();
                        }
                    }
                }
            } else {
                mensajeSis('No se puede Agregar Dirección sin ' + $('#alertSocio').val());
            }
        }
    }

    // se llama la funcion que llena el combo de tipo de direccion
    llenarComboTipoDireccion();

    $('#tdDireccion').hide();

    $(':text').focus(function() {
        esTab = false;
    });

    $.validator.setDefaults({
        submitHandler: function(event) {

            grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'direccionID', 'funcionExitoDir',
                'funcionFalloDir');

        }
    });

    $(':text').bind('keydown', function(e) {
        if (e.which == 9 && !e.shiftKey) {
            esTab = true;
        }
    });

    $('#agrega').click(function() {
        $('#tipoTransaccion').val(catTipoTransaccionDirCliente.agrega);
    });

    $('#modifica').click(function() {
        $('#tipoTransaccion').val(catTipoTransaccionDirCliente.modifica);
    });

    $('#elimina').click(function() {
        $('#tipoTransaccion').val(catTipoTransaccionDirCliente.elimina);
    });

    $('#direccionID').bind('keyup', function(e) {
        var camposLista = new Array();
        var parametrosLista = new Array();

        camposLista[0] = "clienteID";
        camposLista[1] = "direccionCompleta";
        parametrosLista[0] = $('#clienteID').val();
        parametrosLista[1] = $('#direccionID').val();
        lista('direccionID', '0', '1', camposLista, parametrosLista, 'listaDireccion.htm');
    });

    $('#paisID').bind('keyup', function() {
        lista('paisID', '2', '1', 'nombre', $('#paisID').val(), 'listaPaises.htm');
    });

    $('#direccionID').blur(function() {
        validaDirCliente();

    });

    $('#clienteID').bind('keyup', function(e) {
        lista('clienteID', '2', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
    });

    $('#buscarMiSuc').click(function() {
        listaCte('clienteID', '3', '19', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
    });
    $('#buscarGeneral').click(function() {
        listaCte('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
    });

    $('#clienteID').blur(function() {
        setTimeout("$('#cajaLista').hide();", 200);
        var cliente = $('#clienteID').asNumber();
        if (cliente > 0) {
            listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, 0, 0);
            if (listaPersBloqBean.estaBloqueado != 'S') {
                expedienteBean = consultaExpedienteCliente($('#clienteID').val());
                if (expedienteBean.tiempo <= 1) {
                    if (alertaCte(cliente) != 999) {
                        consultaCliente(this.id);
                    }
                } else {
                    mensajeSis('Es necesario Actualizar el Expediente del ' + $('#alertSocio').val() + ' para Continuar');
                    limpiaCampos();
                    inicializaForma('formaGenerica', 'clienteID');
                    $('#clienteID').focus();
                    $('#clienteID').val('');
                }
            } else {
                mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación');
                limpiaCampos();
                inicializaForma('formaGenerica', 'clienteID');
                $('#clienteID').focus();
                $('#clienteID').val('');
            }
        }
    });

    $('#estadoID').bind('keyup', function(e) {
        lista('estadoID', '2', '1', 'nombre', $('#estadoID').val(), 'listaEstados.htm');
    });

    $('#estadoID').blur(function() {
        if (esTab) { // IALDANA Solicitud del cliente T_13315
            consultaEstado(this.id);
            consultaDirecCompleta();
        }
    });

    $('#municipioID').bind('keyup', function(e) {
        var camposLista = new Array();
        var parametrosLista = new Array();

        camposLista[0] = "estadoID";
        camposLista[1] = "nombre";


        parametrosLista[0] = $('#estadoID').val();
        parametrosLista[1] = $('#municipioID').val();

        lista('municipioID', '2', '1', camposLista, parametrosLista, 'listaMunicipios.htm');
    });

    $('#localidadID').bind('keyup', function(e) {
        var camposLista = new Array();
        var parametrosLista = new Array();

        camposLista[0] = "estadoID";
        camposLista[1] = 'municipioID';
        camposLista[2] = "nombreLocalidad";


        parametrosLista[0] = $('#estadoID').val();
        parametrosLista[1] = $('#municipioID').val();
        parametrosLista[2] = $('#localidadID').val();

        lista('localidadID', '2', '1', camposLista, parametrosLista, 'listaLocalidades.htm');
    });

    $('#coloniaID').bind('keyup', function(e) {
        var camposLista = new Array();
        var parametrosLista = new Array();

        camposLista[0] = "estadoID";
        camposLista[1] = 'municipioID';
        camposLista[2] = "asentamiento";

        parametrosLista[0] = $('#estadoID').val();
        parametrosLista[1] = $('#municipioID').val();
        parametrosLista[2] = $('#coloniaID').val();

        lista('coloniaID', '2', '1', camposLista, parametrosLista, 'listaColonias.htm');
    });

    $('#municipioID').blur(function() {
    	if(esTab){// IALDANA Solicitud del cliente T_13315
        consultaMunicipio(this.id);
        consultaDirecCompleta();
        }
    });
    $('#localidadID').blur(function() {
       if(esTab){
        	consultaLocalidad(this.id);
        	consultaDirecCompleta();
        }
    });
    $('#coloniaID').blur(function() {
        consultaColonia(this.id);
        consultaDirecCompleta();
    });

    $('#piso').blur(function() {
        consultaDirecCompleta(this.id);
    });

    $('#CP').blur(function() {
        consultaDirecCompleta(this.id);
    });

    $('#lote').blur(function() {
        consultaDirecCompleta(this.id);

    });

    $('#manzana').blur(function() {
        consultaDirecCompleta(this.id);

    });

    $('#calle').blur(function() {
        consultaDirecCompleta(this.id);
    });

    $('#numInterior').blur(function() {
        consultaDirecCompleta(this.id);
    });

    $('#verMapa').click(function() {
        consultaDirecMapa();

    });

    $('#paisID').val('700');
    $('#aniosRes').val('1');
    funcionConsultaPais();

    $('#paisID').blur(function() {
        if (esTab) {
            funcionConsultaPais();
        }

        if (esTab && $('#paisID').val() != '700') {
            $('#estadoID').val('0');
            $('#municipioID').val('0');
            $('#localidadID').val('0');
            $('#coloniaID').val('0');

            consultaEstado('estadoID');
            consultaMunicipio('municipioID');
            consultaLocalidad('localidadID');
            consultaColonias('coloniaID');

            $('#estadoID').attr('disabled', true);
            $('#municipioID').attr('disabled', true);
            $('#localidadID').attr('disabled', true);
            $('#coloniaID').attr('disabled', true);
        } else {
            $('#estadoID').removeAttr('disabled');
            $('#municipioID').removeAttr('disabled');
            $('#localidadID').removeAttr('disabled');
            $('#coloniaID').removeAttr('disabled');
        }
    });

    $('#aniosRes').blur(function() {
        var aniosRes = $('#aniosRes').val();

        if (!/^[0-9]+$/.test(aniosRes) || aniosRes < 1) {
            mensajeSis('El Año de Residencia Debe ser un Número Entero y Mayor a 0');
            $('#aniosRes').val('1');
            $('#aniosRes').focus();
        }
    });

    //------------ Validaciones de la Forma -------------------------------------
    $('#formaGenerica').validate({
        rules: {
            clienteID: {
                required: true,
                minlength: 1
            },
            direccionID: {
                required: false,
                minlength: 1
            },
            tipoDireccionID: {
                required: true,
                minlength: 1
            },
            localidadID: {
                required: function() { return $('#valorResidentesExt').val() == 'N' ? true : false; },
            },
            estadoID: {
                required: function() { return $('#valorResidentesExt').val() == 'N' ? true : false; },
            },
            municipioID: {
                required: function() { return $('#valorResidentesExt').val() == 'N' ? true : false; },
            },
            calle: {
                required: function() { return $('#valorResidentesExt').val() == 'N' ? true : false; },
                minlength: 1
            },
            coloniaID: {
                required: function() { return $('#valorResidentesExt').val() == 'N' ? true : false; },
            },
            CP: {
                required: function() { return $('#valorResidentesExt').val() == 'N' ? true : false; },
                minlength: 5,
                maxlength: 6
            },
            numeroCasa: {
                required: function() { return $('#valorResidentesExt').val() == 'N' && $('#lote').val() == '' && $('#manzana').val() == '' ? true : false; },
                minlength: 1
            },
            piso: {
                maxlength: 50
            },
            manzana: {
                maxlength: 50
            },
            lote: {
                maxlength: 50
            },
            primEntreCalle: {
                required: function() { return $('#valorResidentesExt').val() == 'N' ? true : false; },
            },
            direccionCompleta: {
                required: function() { return $('#valorResidentesExt').val() == 'S' ? true : false; },
            },
            paisID: {
                required: function() { return $('#valorResidentesExt').val() == 'N' ? true : false; }
            },
            aniosRes: {
                required: true
            }
        },
        messages: {
            clienteID: {
                required: 'Especificar Nombre.',
                minlength: 'Mínimo un Caracter.'
            },
            tipoDireccionID: {
                required: 'Especificar Tipo de Dirección.',
                minlength: 'Mínimo un Caracter.'
            },
            localidadID: {
                required: 'Especificar Localidad.'
            },
            estadoID: {
                required: 'Especificar Estado.'
            },
            municipioID: {
                required: 'Especificar Municipio.'
            },
            calle: {
                required: 'Especificar Calle.',
                minlength: 'Especificar Calle.'
            },

            coloniaID: {
                required: 'Especificar Colonia.'
            },
            CP: {
                required: 'Especificar C.P.',
                minlength: 'Mínimo 5 Caracteres.',
                maxlength: 'Máximo 6 Caracteres.'
            },
            numeroCasa: {
                required: 'Especificar Número Ext.',
                minlength: 'Mínimo un Caracter.'
            },
            piso: {
                maxlength: 'Máximo 50 Caracteres.'
            },
            manzana: {
                maxlength: 'Máximo 50 Caracteres.'
            },
            lote: {
                maxlength: 'Máximo 50 Caracteres.'
            },
            primEntreCalle: {
                required: 'Especificar Primer Entre Calle.'
            },
            direccionCompleta: {
                required: 'Especifique Dirección Completa.'
            },
            paisID: {
                required: 'Especifique País'
            },
            aniosRes: {
                required: 'Especifique Años Residencia'
            }

        }
    });

    //------------ Validaciones de Controles -------------------------------------
    function validaDirCliente() {
        var numDireccion = $('#direccionID').val();
        setTimeout("$('#cajaLista').hide();", 200);
        if (numDireccion != '' && !isNaN(numDireccion) && esTab) {
            if (numDireccion == '0') {
                $('#mapDiv').hide();
                consultaCliente('clienteID');
                habilitaBoton('agrega', 'submit');
                deshabilitaBoton('modifica', 'submit');
                deshabilitaBoton('elimina', 'submit');
                inicializaForma('formaGenerica', 'clienteID');
            } else {
                deshabilitaBoton('agrega', 'submit');
                habilitaBoton('modifica', 'submit');
                habilitaBoton('elimina', 'submit');
                var direccionesCliente = {
                    'clienteID': $('#clienteID').val(),
                    'direccionID': $('#direccionID').val()
                };
                direccionesClienteServicio.consulta(catTipoConsultaDirCliente.principal, direccionesCliente, function(direccion) {
                    if (direccion != null) {
                        dwr.util.setValues(direccion);
                        $('#nombreEstado').val(direccion.estadoID);
                        consultaEstado('nombreEstado');
                        $('#nombreMuni').val(direccion.municipioID);
                        consultaMunicipio('nombreMuni');
                        $('#nombrelocalidad').val(direccion.localidadID);
                        consultaLocalidad('nombrelocalidad');
                        $('#nombreColonia').val(direccion.asentamiento);
                        consultaColonias('coloniaID');
                        $('#CP').val(direccion.CP);

                        $('#tipoDireccionID').val(direccion.tipoDireccionID).selected = true;
                        if (direccion.oficial == 'S') {
                            $('#oficial').attr("checked", "1");
                        } else {
                            $('#oficial').attr("checked", false);
                        }
                        if (direccion.fiscal == 'S') {
                            $('#fiscal').attr("checked", "1");
                        } else {
                            $('#fiscal').attr("checked", false);
                        }

                    } else {
                        mensajeSis("No Existe la Dirección del " + $('#alertSocio').val());
                        deshabilitaBoton('modifica', 'submit');
                        deshabilitaBoton('agrega', 'submit');
                        deshabilitaBoton('elimina', 'submit');
                        $('#direccionID').focus();
                        $('#direccionID').select();
                        $('#tipoDireccionID').val("");
                        inicializaForma('formaGenerica', 'clienteID');
                    }
                });

            }
        }
    }

    $('#oficial').click(function() {
        var numDireccion = $('#direccionID').asNumber();
        var direccionesCliente = {
            'clienteID': $('#clienteID').val(),
            'tipoDireccionID': $('#tipoDireccionID option:selected').val(),
            'direccionID': $('#direccionID').val()
        };
        direccionesClienteServicio.consulta(catTipoConsultaDirCliente.oficial, direccionesCliente, function(direccion) {
            if (direccion != null) {
                if (direccion.oficial != 'N') {
                    if (numDireccion != direccion.direccionID) {
                        if ($('#oficial').is(':checked')) {
                            var dirCompleta = direccion.direccionCompleta;
                            if (confirm('El ' + $('#alertSocio').val() + ' ya cuenta con una Dirección Oficial: ' + dirCompleta)) {
                                $('#oficial').attr('checked', false);
                            } else {
                                if (direccion.direccionID == parseInt($('#direccionID').val())) {
                                    $('#oficial').attr('checked', true);
                                } else {
                                    $('#oficial').attr('checked', false);
                                }
                            }
                        } else {
                            if (numDireccion == 0) {
                                habilitaBoton('agrega', 'submit');
                            } else {
                                habilitaBoton('modifica', 'submit');
                            }
                        }
                    }
                }
            }
        });
    });
    $('#fiscal').click(function() {
        var numDireccionF = $('#direccionID').asNumber();
        var direccionesClienteF = {
            'clienteID': $('#clienteID').val(),
            'tipoDireccionID': $('#tipoDireccionID option:selected').val(),
            'direccionID': $('#direccionID').val()
        };
        direccionesClienteServicio.consulta(catTipoConsultaDirCliente.fiscal, direccionesClienteF, function(direccion) {
            if (direccion != null) {
                if (direccion.fiscal != 'N') {
                    if (numDireccionF != direccion.direccionID) {
                        if ($('#fiscal').is(':checked')) {
                            var dirCompleta = direccion.direccionCompleta;
                            if (confirm('El ' + $('#alertSocio').val() + ' ya cuenta con una Dirección Fiscal: ' + dirCompleta)) {
                                $('#fiscal').attr('checked', false);
                            } else {
                                if (direccion.direccionID == parseInt($('#direccionID').val())) {
                                    $('#fiscal').attr('checked', true);
                                } else {
                                    $('#fiscal').attr('checked', false);
                                }
                            }
                        } else {
                            if (numDireccionF == 0) {
                                habilitaBoton('agrega', 'submit');
                            } else {
                                habilitaBoton('modifica', 'submit');
                            }
                        }
                    }
                }
            }
        });
    });

    function funcionConsultaPais() {
        var conPais = 2;
        var numPais = $('#paisID').val();

        if (numPais != '' && !isNaN(numPais)) {
            paisesServicio.consultaPaises(conPais, numPais, function(pais) {
                if (pais != null) {
                    $('#nombrePais').val(pais.nombre);
                } else {
                    mensajeSis('No existe el país');
                    $('#paisID').val('');
                }
            });
        } else {
            $('#paisID').val('');
        }
    }

    function consultaCliente(idControl) {
        var jqCliente = eval("'#" + idControl + "'");
        var numCliente = $(jqCliente).val();
        var tipConForanea = 1;
        setTimeout("$('#cajaLista').hide();", 200);
        if (numCliente != '' && !isNaN(numCliente) && esTab) {
            clienteServicio.consulta(tipConForanea, numCliente, function(cliente) {
                if (cliente != null) {
                    $('#clienteID').val(cliente.numero);
                    paisResidencia = cliente.paisResidencia;
                    $('#nombreCliente').val(cliente.nombreCompleto);
                    inicializaForma('formaGenerica', 'clienteID');
                    $('#direccionID').val("");
                    $('#tipoDireccionID').val("");
                    $('#mapDiv').hide();
                    if (cliente.estatus == "I") {

                        deshabilitaBoton('modifica', 'submit');
                        deshabilitaBoton('agrega', 'submit');
                        deshabilitaBoton('elimina', 'submit');
                        mensajeSis("El " + $('#alertSocio').val() + " se encuentra Inactivo");
                    }
                    validaPermiteResidentesExt();
                } else {
                    mensajeSis("No Existe el " + $('#alertSocio').val());
                    $('#clienteID').focus();
                    $('#clienteID').select();
                    inicializaForma('formaGenerica', 'clienteID');
                    limpiaCampos();
                    $('#mapDiv').hide();
                }
            });
        }
    }

    function consultaEstado(idControl) {
        var jqEstado = eval("'#" + idControl + "'");
        var numEstado = $(jqEstado).val();
        var tipConForanea = 2;
        setTimeout("$('#cajaLista').hide();", 200);
        if (numEstado != '' && !isNaN(numEstado)) {
            estadosServicio.consulta(tipConForanea, numEstado, {
                async: false,
                callback: function(estado) {
                    if (estado != null) {
                        $('#nombreEstado').val(estado.nombre);
                    } else {
                        mensajeSis("No Existe el Estado");
                        $('#nombreEstado').val("");
                        $('#estadoID').val("");
                        $('#estadoID').focus();
                        $('#estadoID').select();
                    }
                }
            });
        }
    }

    function consultaMunicipio(idControl) {
        var jqMunicipio = eval("'#" + idControl + "'");
        var numMunicipio = $(jqMunicipio).val();
        var numEstado = $('#estadoID').val();
        var tipConForanea = 2;
        setTimeout("$('#cajaLista').hide();", 200);
        if (numMunicipio != '' && !isNaN(numMunicipio)) {
            if (numEstado != '') {
                municipiosServicio.consulta(tipConForanea, numEstado, numMunicipio, {
                    async: false,
                    callback: function(municipio) {
                        if (municipio != null) {
                            $('#nombreMuni').val(municipio.nombre);
                            $('#nombreCiudad').val(municipio.ciudad);
                        } else {
                            mensajeSis("No Existe el Municipio");
                            $('#nombreMuni').val("");
                            $('#nombreCiudad').val("");
                            $('#municipioID').val("");
                            $('#municipioID').focus();
                            $('#municipioID').select();
                        }
                    }
                });

            } else {
                mensajeSis("Especificar Estado");
                $('#estadoID').focus();
            }
        } else {
            if (isNaN(numMunicipio) && esTab) {
                mensajeSis("No Existe el Municipio");
                $('#nombreMuni').val("");
                $('#nombreCiudad').val("");
                $('#municipioID').val("");
                $('#municipioID').focus();
                $('#municipioID').select();

            }
        }
    }

    function consultaLocalidad(idControl) {
        var jqLocalidad = eval("'#" + idControl + "'");
        var numLocalidad = $(jqLocalidad).val();
        var numMunicipio = $('#municipioID').val();
        var numEstado = $('#estadoID').val();
        var tipConPrincipal = 1;
        setTimeout("$('#cajaLista').hide();", 200);
        if (numLocalidad != '' && !isNaN(numLocalidad)) {
            if (numEstado != '' && numMunicipio != '') {
                localidadRepubServicio.consulta(tipConPrincipal, numEstado, numMunicipio, numLocalidad, {
                    async: false,
                    callback: function(localidad) {
                        if (localidad != null) {
                            $('#nombrelocalidad').val(localidad.nombreLocalidad);
                        } else {
                            mensajeSis("No Existe la Localidad");
                            $('#nombrelocalidad').val("");
                            $('#localidadID').val("");
                            $('#localidadID').focus();
                            $('#localidadID').select();
                        }
                    }
                });
            } else {
                if (numEstado == '') {
                    mensajeSis("Especificar Estado");
                    $('#estadoID').focus();
                } else {
                    mensajeSis("Especificar Municipio");
                    $('#municipioID').focus();
                }
            }

        }
    }
    //consulta Colonia y CP
    function consultaColonia(idControl) {
        var jqColonia = eval("'#" + idControl + "'");
        var numColonia = $(jqColonia).val();
        var numEstado = $('#estadoID').val();
        var numMunicipio = $('#municipioID').val();
        var tipConPrincipal = 1;
        setTimeout("$('#cajaLista').hide();", 200);
        if (numColonia != '' && !isNaN(numColonia)) {
            coloniaRepubServicio.consulta(tipConPrincipal, numEstado, numMunicipio, numColonia, {
                async: false,
                callback: function(colonia) {
                    if (colonia != null) {
                        $('#nombreColonia').val(colonia.asentamiento);
                        $('#CP').val(colonia.codigoPostal);
                    } else {
                        mensajeSis("No Existe la Colonia");
                        $('#nombreColonia').val("");
                        $('#coloniaID').val("");
                        $('#coloniaID').focus();
                        $('#coloniaID').select();
                    }
                }
            });
        } else {
            $('#nombreColonia').val("");
        }
    }

    //solo consulta colonias
    function consultaColonias(idControl) {
        var jqColonia = eval("'#" + idControl + "'");
        var numColonia = $(jqColonia).val();
        var numEstado = $('#estadoID').val();
        var numMunicipio = $('#municipioID').val();
        var tipConPrincipal = 1;
        setTimeout("$('#cajaLista').hide();", 200);
        if (numColonia != '' && !isNaN(numColonia) && esTab) {
            coloniaRepubServicio.consulta(tipConPrincipal, numEstado, numMunicipio, numColonia, function(colonia) {
                if (colonia != null) {
                    $('#nombreColonia').val(colonia.asentamiento);
                } else {
                    mensajeSis("No Existe la Colonia");
                    $('#nombreColonia').val("");
                    $('#coloniaID').val("");
                    $('#coloniaID').focus();
                    $('#coloniaID').select();
                }
            });
        }
    }

    function consultaDirecCompleta() {
        var ca = $('#calle').val();
        var nu = $('#numeroCasa').val();
        var ni = $('#numInterior').val();
        var pis = $('#piso').val();
        var co = $('#nombreColonia').val();
        var cp = $('#CP').val();
        var nm = $('#nombreMuni').val();
        var ne = $('#nombreEstado').val();
        var lot = $('#lote').val();
        var man = $('#manzana').val();

        var dirCom = ca;
        if (nu != '') {
            dirCom = (dirCom + ", No. " + nu);
        }
        if (ni != '') {
            dirCom = (dirCom + ", INTERIOR " + ni);
        }
        if (pis != '') {
            dirCom = (dirCom + ", PISO " + pis);
        }
        if (lot != '') {
            dirCom = (dirCom + ", LOTE " + lot);
        }
        if (man != '') {
            dirCom = (dirCom + ", MANZANA " + man);
        }
        if (co != '') {
            dirCom = (dirCom + ", COL. " + co);
        }
        dirCom = (dirCom + ", C.P. " + cp + ", " + nm + ", " + ne + ".");
        $('#direccionCompleta').val(dirCom.toUpperCase());
    }

    function consultaDirecMapa() {
        var ca = $('#calle').val();
        var nu = $('#numeroCasa').val();
        var co = $('#nombreColonia').val();
        var nm = $('#nombreMuni').val();
        var ne = $('#nombreEstado').val();

        var dirCom = ca;
        if (nu != '') {
            dirCom = (dirCom + "" + nu);
        }
        dirCom = (dirCom + ", " + co + ", " + nm + ", " + ne);
        $('#direccionMapa').val(dirCom);
        if ($('#latitud').val() != '' && $('#longitud').val() != '') {
            var latitud = $('#latitud').val();
            var longitud = $('#longitud').val();
            muestraMapa('mapDiv', latitud, longitud);
        } else {
            mostrarLatitudLongitud($('#direccionMapa').val(), 'mapDiv');


        }
    }

    // funcion para limpiar los campos
    function limpiaCampos() {
        $('#nombreCliente').val("");
        $('#direccionID').val("");
        $('#tipoDireccionID').val("");
    }

    // Funcion para validar el registro de personas residentes en el extranjero
    function validaPermiteResidentesExt() {
        paramGeneralesServicio.consulta(31, {}, function(parametro) {
            if (parametro != null) {
                permiteResidentesExt = parametro.valorParametro;
                if (permiteResidentesExt == 'S' && (paisResidencia != '700' && paisResidencia != '999')) {
                    $('#tdSeparador').hide();
                    $('#tdEntidad').hide();
                    $('#tdEstado').hide();
                    $('#trMuniLoc').hide();
                    $('#trColCiudad').hide();
                    $('#trCalleNumero').hide();
                    $('#trPrimerSegundaCalle').hide();
                    $('#trCodigoLatitud').hide();
                    $('#trLongitud').hide();
                    $('#lblDescripcion').hide();
                    $('#tdDescripcion').hide();
                    $('#tdSeparadorCheck').hide();
                    $('#trLoteManzana').hide();
                    $('#tdDireccion').show();
                    $('#tdDireccionMapa').hide();
                    $('#verMapa').hide();
                    $('#mapDiv').hide();
                    habilitaControl('direccionCompleta');
                    $('#valorResidentesExt').val("S");
                } else {
                    $('#tdSeparador').show();
                    $('#tdEntidad').show();
                    $('#tdEstado').show();
                    $('#trMuniLoc').show();
                    $('#trColCiudad').show();
                    $('#trCalleNumero').show();
                    $('#trPrimerSegundaCalle').show();
                    $('#trCodigoLatitud').show();
                    $('#trLongitud').show();
                    $('#lblDescripcion').show();
                    $('#tdDescripcion').show();
                    $('#tdSeparadorCheck').show();
                    $('#trLoteManzana').show();
                    $('#tdDireccion').hide();
                    $('#tdDireccionMapa').show();
                    $('#verMapa').show();
                    deshabilitaControl('direccionCompleta');
                    $('#valorResidentesExt').val("N");
                }
            }
        });
    }
});



//funcion que simplemente actualiza los campos del formulario
function actualizarPosicion(latLng) {
    $('#latitud').val(latLng.lat());
    $('#longitud').val(latLng.lng());
}

// funcion que muestra la latitud y longitud a partir de la direccion indicada
function mostrarLatitudLongitud(address, map) {
    var geocoder = null;
    var map = new google.maps.Map(document.getElementById("mapDiv"));
    var address = document.getElementById('direccionMapa').value;
    map.setOptions({
        navigationControl: true,
        navigationControlOptions: { style: google.maps.NavigationControlStyle.SMALL }
    });

    geocoder = new google.maps.Geocoder();
    geocoder.geocode({ 'address': address }, function(results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
            var latitude = results[0].geometry.location.lat();
            var longitude = results[0].geometry.location.lng();
            $('#latitud').val(latitude);
            $('#longitud').val(longitude);
            muestraMapa('mapDiv', latitude, longitude);
        } else {
            mensajeSis("Petición no Realizada");
        }
    });
}



//Funcion que Muestra el Mapa, segun la API de Google Maps
//Parametros: div, es la division en la forma donde se mostrara el mapa
//latitud: coordenada de latitud a 6 decimales
//longitud: coordenada de longitud a 6 decimales
function muestraMapa(div, latitud, longitud) {
    var mapDiv = document.getElementById(div);
    var mapDivJQ = eval("'#" + div + "'");

    var latlng = new google.maps.LatLng(latitud, longitud);

    var options = {
        center: latlng,
        zoom: 17,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        mapTypeControl: true,
        scaleControl: true,
        mapTypeControlOptions: {
            mapTypeIds: [
                google.maps.MapTypeId.ROADMAP,
                google.maps.MapTypeId.SATELLITE
            ],
            position: google.maps.ControlPosition.TOP_RIGHT,
            style: google.maps.MapTypeControlStyle.DROPDOWN_MENU

        },
        disableDefaultUI: true,
        navigationControl: true,
        streetViewControl: true,
        draggableCursor: 'move',
        draggingCursor: 'move',
    };
    var map = new google.maps.Map(mapDiv, options);

    var marker = new google.maps.Marker({
        position: new google.maps.LatLng(latitud, longitud),
        map: map,
        draggable: true //que el marcador se pueda arrastrar
    });

    //Añado un listener para cuando el markador se termine de arrastrar
    //actualize el formulario con las nuevas coordenadas
    google.maps.event.addListener(marker, 'dragend', function() {
        actualizarPosicion(marker.getPosition());
    });
    $(mapDivJQ).show();
}

function funcionExitoDir() {
    inicializaForma('formaGenerica', 'direccionID');
    $('#tipoDireccionID').val("");
    deshabilitaBoton('modifica', 'submit');
    deshabilitaBoton('agrega', 'submit');
    deshabilitaBoton('elimina', 'submit');

    $('#mapDiv').hide();
    if ($('#flujoCliNumCli').val() != undefined) {
        $('#flujoCliDirOfi').val($('#direccionID').val());
        $('#direccionCompleta').text($('#direccionCompleta').text());

    }

}

function funcionFalloDir() {

}

// funcion para llenar combo de tipo de direccion
function llenarComboTipoDireccion() {
    dwr.util.removeAllOptions('tipoDireccionID');
    tiposDireccionServicio.listaCombo(3, function(tdirecciones) {
        dwr.util.addOptions('tipoDireccionID', { '': 'SELECCIONAR' });
        dwr.util.addOptions('tipoDireccionID', tdirecciones, 'tipoDireccionID', 'descripcion');
    });
}
