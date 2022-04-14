var parametroBean = consultaParametrosSession();

$(document).ready(function() {

    esTab = false;

    $(':text').focus(function() {
        esTab = false;
    });

    $(':text').bind('keydown', function(e) {
        if (e.which == 9 && !e.shiftKey) {
            esTab = true;
        }
    });
    var catTipoConPresupSucur = {
        'principal': 1,
        'foranea': 2,
        'folioOpe': 3
    };

    var tipoTransacPresuSucur = {
        'alta': 1,
        'modifica': 2
    };
    var grabarComo = {
        'Pendiente': 'P',
        'Cerrado': 'C'
    };

    var catTipoListaTipoGasto = {
        'principal': 1
    };

    var catTipoConsultaTipoGasto = {
        'principal': 1
    };

    //------------ Metodos y Manejo de Eventos -----------------------------------------
    parametroBean = consultaParametrosSession();
    //inicializacion 
    $('#fechaPresupuesto').val(obtenDia());
    $('#folio').focus();
    describeMesPres(obtenDia());
    deshabilitaControl('fechaOperacion');
    deshabilitaControl('fechaPresupuesto');

    //	ActualizarDatosPres();
    //perfilUsuario
    if (parametroBean.numeroUsuario != $('#usuario').val()) {
        $('#estatusPet').attr("disabled", "true");
        $('#grabarCerrado').hide();
        $('#grabar').val('Grabar');
    }

    function ActualizarDatosPres() {
        $('#usuario').val(parametroBean.numeroUsuario);
        $('#nombreUsuario').val(parametroBean.nombreUsuario);
        $('#sucursal').val(parametroBean.sucursal);
        $('#sucursalNombre').val(parametroBean.nombreSucursal);
        $('#fecha').val(obtenDia());
        $('#fechaOperacion').val(obtenDia());

        if (parametroBean.perfilUsuario != parametroBean.rolTesoreria) { //--
            $('#estatusPet').attr("disabled", "true");
            $('#grabarCerrado').hide();
            $('#grabar').val('Grabar');

        }

    }


    //Fecha Del sistema


    deshabilitaBoton('grabar', 'submit');
    deshabilitaBoton('modificar', 'submit');
    $('#tableCon').hide();

    if (parametroBean.perfilUsuario != parametroBean.rolTesoreria && parametroBean.perfilUsuario != parametroBean.rolAdminTeso) { //--
        $('#fechaPresupuesto').change(function() {

            var fecha = $('#fechaPresupuesto').val();
            var fechaActual = obtenDia();

            var array = fecha.split('-');
            var arrayAct = fechaActual.split('-');
            var mes = array[1];
            var anio = array[0];

            describeMesPres(fecha);
            var PreSucursalBean = {
                'folio': 0,
                'mesPresupuesto': mes,
                'anioPresupuesto': anio,
                'sucursal': parametroBean.sucursal
            };
            consulaPresuMeasActual(PreSucursalBean);

        });
    }

    if (parametroBean.perfilUsuario == parametroBean.rolTesoreria || parametroBean.perfilUsuario == parametroBean.rolAdminTeso) { //--
        $('#fechaPresupuesto').change(function() {
            limpiaEncabezado();
        });
    }

    function describeMesPres(fecha) {
        var array = fecha.split('-');

        descripcionMes(array[1], array[0]);

    }

    function diasLimite() {
        var fecha = obtenDia();
        var array = fecha.split('-');
        var ultiDia = ultimoDia(array[2], array[1], array[0]);
        var dias = parseInt(ultiDia) - parseInt(array[2]);
        if (dias > 0) {
            var label = '<label for="lblfecha" id="lblFechaLim"> Faltan :' + dias + ' días para finalizar la captura</label>';
            $('#lblFechaLim').replaceWith(label);

        }

    }

    function diasLimiteDob(arrayLim) {
        var fecha = obtenDia();
        var array = fecha.split('-');
        var ultiDia = ultimoDiaDob(array[2], array[1], array[0], arrayLim[2], arrayLim[1], arrayLim[0]);
        var dias = parseInt(ultiDia) - parseInt(array[2]);
        if (dias > 0) {
            var label = '<label for="lblfecha" id="lblFechaLim"> Faltan :' + dias + ' días para finalizar la captura</label>';
            $('#lblFechaLim').replaceWith(label);

        }

    }

    function descripcionMes(mes, anio) {
        $('#mesPresupuesto').val(mes); //hidden
        $('#anioPresupuesto').val(anio); //hidden 
        var nombreMes = regresaMes(mes);
        var label = '<label id="lblMesPresup" >' + nombreMes + " de " + anio + '</label>';
        $('#lblMesPresup').replaceWith(label);
    }
    agregaFormatoControles('formaGenerica');


    $.validator.setDefaults({
        submitHandler: function(event) {
            if ($('#numeroDetalle').val() > 0) {
                if (existenMontosCero() == false) {

                    grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'folio');

                    deshabilitaBoton('grabar', 'submit');
                    deshabilitaBoton('grabarCerrado', 'submit');
                    deshabilitaBoton('modificar', 'submit');
                    tablaVacia();
                } else {
                    mensajeSis("Los montos no deben estar vacios");
                    return false;
                }

            } else mensajeSis("No ha agregado presupuestos");
        }
    });

    $('#grabar').click(function(event) {

        $('#estatusPre').val(grabarComo.Pendiente);

        $('#tipoTransaccion').val(tipoTransacPresuSucur.alta);
    });

    $('#grabarCerrado').click(function(event) {
        if (confirm("Al cerrar ya no podrá agregar más conceptos al presupuesto de este mes. ¿Esta seguro que desea cerrar el presupuesto?")) {
            if ($('#estatusPre').val() == 'N') { // N= nuevo ..que no ha sido guardado

                $('#estatusPre').val(grabarComo.Cerrado);
                $('#tipoTransaccion').val(tipoTransacPresuSucur.alta);
            }

            if ($('#estatusPre').val() == 'P') { // P= Pendiente Se modifica,

                $('#estatusPre').val(grabarComo.Cerrado);
                $('#tipoTransaccion').val(tipoTransacPresuSucur.modifica);
            }
        } else {
            return false;
        }

    });

    $('#modificar').click(function(event) { //llll							
        $('#tipoTransaccion').val(tipoTransacPresuSucur.modifica);
        var mandar = verificarObservaciones();
        if (mandar == 1) {
            mensajeSis("Ingrese la observación");
            event.preventDefault();
        }
    });

    $('#agregar').click(function(event) {
        if (validaPlantilla() == true) {
            var monto = $('#montoPet').asNumber();
            var conceptoNuevo = $('#conceptoID').val();
            if (existeConceptoEnGrid(conceptoNuevo) == false) {
                if (monto > 0) {
                    agregaNuevoDetalle();
                    $('#tableCon').show();
                } else {
                    mensajeSis("El monto no debe ser menor o igual a $0.00");
                }
            }

        }

    });


    $('#folio').blur('onkeypress', function(e) {
        if (esTab) {
            validaFolio(this.id);
        }

    });

    $('#montoPet').blur('onkeypress', function(e) {
        var monto = $('#montoPet').asNumber();

        if ($('#montoPet').val() != '') {
            if (monto <= 0) {
                mensajeSis("El monto no debe ser menor o igual a $0.00");
                $('#montoPet').val('');
                $('#montoPet').focus();

            }
        }

    });
    $('#grabar').attr('tipoTransaccion', '1');



    $('#conceptoID').blur(function(e) {
        if (esTab) $('#cajaLista').hide();
        if (esTab) {
            consultaTipoGasto(this.id);

        }

    });

    $('#conceptoID').bind('keyup', function(e) {

        if (this.value.length >= 2) {
            var camposLista = new Array();
            var parametrosLista = new Array();

            camposLista[0] = "descripcionTG";
            parametrosLista[0] = $('#conceptoID').val();



            lista('conceptoID', '1', catTipoListaTipoGasto.principal, camposLista, parametrosLista, 'requisicionTipoGastoListaVista.htm');
        }
    });

    //

    if (parametroBean.perfilUsuario == parametroBean.rolTesoreria || parametroBean.perfilUsuario == parametroBean.rolAdminTeso) { //--
        $('#folio').bind('keyup', function(e) {

            if (this.value.length >= 1) {
                var camposLista = new Array();
                var parametrosLista = new Array();

                camposLista[0] = "nombreSucursal";
                parametrosLista[0] = $('#folio').val();
                camposLista[1] = "fecha";
                parametrosLista[1] = $('#fechaPresupuesto').val();

                lista('folio', '1', '1', camposLista, parametrosLista, 'partidaPresupuestoLista.htm');
            }
        });

        $('#fechaPresupuesto').change(function() {

            var fecha = $('#fechaPresupuesto').val();
            describeMesPres(fecha);

        });
    }
    //---------Funciones
    function validaPlantilla() {
        if ($('#conceptoID').val() == '') return false;
        if ($('montoPet').val() == '') return false;
        if ($('descripcionPet').val() == '') return false;

        return true;
    }

    function consultaTipoGasto(idControl) {
        var jqTipoGasto = eval("'#" + idControl + "'");
        var numTipoGasto = $(jqTipoGasto).val();
        esTab = true;
        if (numTipoGasto != '' && !isNaN(numTipoGasto)) {
            var RequisicionTipoGastoListaBean = {
                'tipoGastoID': numTipoGasto
            };
            requisicionGastosServicio.consultaTipoGasto(catTipoConsultaTipoGasto.principal, RequisicionTipoGastoListaBean, {
                async: false,
                callback: function(tipoGastoCon) {

                    if (tipoGastoCon != null) {
                        if (existeConceptoEnGrid(numTipoGasto)) {
                            mensajeSis("Ya existe un presupuesto con el concepto: " + tipoGastoCon.descripcionTG);
                            $('#conceptoID').focus();
                            $('#conceptoID').val('');
                            $('#conceptoDescri').val('');

                        } else {
                            $('#conceptoDescri').val(tipoGastoCon.descripcionTG);
                        }
                    } else {
                        mensajeSis("No existe el Tipo de Gasto");
                        $('#conceptoID').focus();
                        $('#conceptoID').val('');
                        $('#conceptoDescri').val('');
                    }
                }
            });
        } else {
            mensajeSis("No existe el Tipo de Gasto");
            $('#conceptoID').focus();
            $('#conceptoID').val('');
            $('#conceptoDescri').val('');
        }
    }

    function agregaDescGasto() {
        var i = 1,
            totalDet;
        totalDet = $('#numeroDetalle').val();

        for (i = 1; i <= totalDet; i++) {
            tipoDet = eval("'#concepto" + i + "'");
            tipoDescrip = eval("'#conceptoDes" + i + "'");
            getDescripcionGasto($(tipoDet).val(), tipoDescrip);

        }
    }

    function getDescripcionGasto(tipoGasto, tipoDescrip) {
        var descripcion;

        var RequisicionTipoGastoListaBean = {
            'tipoGastoID': tipoGasto
        };

        requisicionGastosServicio.consultaTipoGasto(catTipoConsultaTipoGasto.principal, RequisicionTipoGastoListaBean, function(tipoGastoCon) {
            if (tipoGastoCon != null) {

                descripcion = tipoGastoCon.descripcionTG;
                $(tipoDescrip).val(descripcion);
            } else {
                mensajeSis("No existe la descripcion del Tipo de Gasto");

            }
        });


    }

    function validaFolio(control) {
        var jqFolio = eval("'#" + control + "'");
        var numFolio = $(jqFolio).val();
        setTimeout("$('#cajaLista').hide();", 200);
        if (numFolio != '' && !isNaN(numFolio)) {

            deshabilitaBoton('grabar', 'submit');

            var val_folioID = $(jqFolio).val();

            if (val_folioID != '0') { // si existe el presupuesto {
                var PreSucursalBean = {
                    'folio': $(jqFolio).val(),
                    'sucursal': parametroBean.sucursal
                };
                habilitaBoton('modificar', 'submit');
                habilitaBoton('grabarCerrado', 'submit');

                //ActualizarDatosPres(); 
                presupSucursalServicio.consulta(catTipoConPresupSucur.folioOpe, PreSucursalBean,
                    function(preBean) {

                        if (preBean != null) {

                            if (preBean.sucursal == parametroBean.sucursal || parametroBean.perfilUsuario == parametroBean.rolTesoreria || parametroBean.perfilUsuario == parametroBean.rolAdminTeso) { //--
                                dwr.util.setValues(preBean);
                                var fechaDeOp = preBean.fecha;
                                var estatusPre = preBean.estatusPre;
                                var mesPre = "";

                                if (preBean.mesPresupuesto < 10) {
                                    mesPre += '0' + preBean.mesPresupuesto;
                                } else {
                                    mesPre = preBean.mesPresupuesto;
                                }

                                var rol = parametroBean.perfilUsuario;

                                $('#estatusPre').val(estatusPre);
                                $('#sucursal').val(preBean.sucursal);

                                $('#fechaOperacion').val(fechaDeOp.substr(0, 10)); //sin formato (yyyy-mm-dd hh-mm-ss)
                                descripcionMes(mesPre, preBean.anioPresupuesto);
                                var fechaPresup = preBean.anioPresupuesto + '-' + mesPre + '-01';
                                $('#fechaPresupuesto').val(fechaPresup);
                                if (consultaEsFechaMenor(preBean.anioPresupuesto, mesPre, 1) == true) {
                                    rol = 0;
                                    ocultaBotones();
                                }

                                if (estatusPre == 'P') {
                                    $('#estatusVista').val("En proceso");
                                    muestraBotones();
                                    if (parametroBean.numeroUsuario == preBean.usuario) {
                                        $('#plantillaCaptura').show();
                                        limpiaPlantilla();
                                    } else {
                                        $('#plantillaCaptura').hide();
                                    }
                                }
                                if (estatusPre == 'C') {
                                    $('#estatusVista').val("Finalizado");
                                    $('#plantillaCaptura').hide();
                                    if (parametroBean.perfilUsuario != parametroBean.rolTesoreria && parametroBean.perfilUsuario != parametroBean.rolAdminTeso) { //--
                                        ocultaBotones();
                                        rol = 0;
                                    }

                                    $('#agregar').hide();
                                }
                                $('#grabarCerrado').val('Modificar y Cerrar');
                                consultaNombreSucursal('sucursal');

                                pegaHtml($('#folio').val(), rol);
                                $('#tableCon').show();
                                agregaFormatoControles('formaGenerica');

                            } //FIN IF != SUCURSAL
                            else {
                                if (preBean.sucursal != parametroBean.sucursal) {
                                    mensajeSis("El Presupuesto no pertenece a esta Sucursal.");
                                    $('#folio').val('0');
                                    validaFolio('folio');
                                }
                            }
                        } else {
                            if (preBean == null) {
                                mensajeSis("No existe el folio introducido.");
                                $('#folio').focus();
                                limpiaEncabezado();

                            }

                        }
                    }); //fin consulta
            } //fin if != 0 }
            if (val_folioID == '0') {
                var PreSucursalBean = {
                    'folio': 0,
                    'mesPresupuesto': obtenMes(),
                    'anioPresupuesto': obtenAnio(),
                    'sucursal': parametroBean.sucursal
                };
                consulaPresuMeasActual(PreSucursalBean);

            } //fin else

        } else {
            mensajeSis("No existe el folio introducido.");
            $('#folio').focus();
            limpiaEncabezado();
        }


        //fin if 	

    } //funcion accion

    function consulaPresuMeasActual(PreSucursalBean) {


        habilitaBoton('modificar', 'submit');
        //ActualizarDatosPres();

        presupSucursalServicio.consulta(catTipoConPresupSucur.principal, PreSucursalBean,
            function(preBean) {
                if (preBean != null) {
                    dwr.util.setValues(preBean);
                    var fechaDeOp = preBean.fecha;
                    var estatusPre = preBean.estatusPre;
                    var rol = parametroBean.perfilUsuario;

                    $('#estatusPre').val(estatusPre);
                    $('#sucursal').val(preBean.sucursal);
                    $('#fechaOperacion').val(fechaDeOp.substr(0, 10)); //sin formato (yyyy-mm-dd hh-mm-ss)
                    var mesPre = "";

                    if (preBean.mesPresupuesto < 10) {
                        mesPre += '0' + preBean.mesPresupuesto;
                    } else {
                        mesPre = preBean.mesPresupuesto;
                    }
                    descripcionMes(mesPre, preBean.anioPresupuesto);

                    if (consultaEsFechaMenor(preBean.anioPresupuesto, mesPre, 1) == true) {
                        rol = 0;
                        ocultaBotones();
                    }

                    if (estatusPre == 'P') {
                        $('#estatusVista').val("En proceso");
                        muestraBotones();
                        if (parametroBean.numeroUsuario == preBean.usuario) {
                            $('#plantillaCaptura').show();
                            limpiaPlantilla();
                        } else {
                            $('#plantillaCaptura').hide();
                        }
                    }
                    if (estatusPre == 'C') {
                        $('#estatusVista').val("Finalizado");
                        $('#plantillaCaptura').hide();
                        if (parametroBean.perfilUsuario != parametroBean.rolTesoreria && parametroBean.perfilUsuario != parametroBean.rolAdminTeso) { //--
                            ocultaBotones();
                            rol = 0;
                        }

                        $('#agregar').hide();
                    }
                    $('#grabarCerrado').val('Modificar y Cerrar');
                    consultaNombreSucursal('sucursal');

                    pegaHtml($('#folio').val(), rol);
                    $('#tableCon').show();
                    agregaFormatoControles('formaGenerica');
                    $('#conceptoID').focus();
                } else {
                    if (confirm("No existe Presupuesto del mes de " + regresaMes(PreSucursalBean.mesPresupuesto) + ". ¿Desea registrar un nuevo presupuesto?")) {
                        if (consultaEsFechaMenor(PreSucursalBean.anioPresupuesto, PreSucursalBean.mesPresupuesto, 1) == true) {
                            mensajeSis("Imposible crear presupuesto de meses pasados");

                            $('#folio').val('0');
                            esTab = true;
                            validaFolio('folio');
                        } else {
                            nuevoPresupuesto();
                            $('#folio').val('0');
                            $('#conceptoID').focus();

                            descripcionMes(PreSucursalBean.mesPresupuesto, PreSucursalBean.anioPresupuesto);

                        }

                    } else {
                        validaFolio('folio');
                    }


                }
            }); //	
    }

    function limpiaPlantilla() {
        $('#conceptoID').val('');
        $('#conceptoDescri').val('');
        $('#montoPet').val('');
        $('#descripcionPet').val('');
    }

    function ocultaBotones() {
        $('#grabar').hide();
        $('#grabarCerrado').hide();
        $('#modificar').hide();
        $('#agregar').hide();
    }

    function darPermisosEscritura() { //lore
        var usuarioActual = parametroBean.numeroUsuario;
        var UsuarioCreador = $('#usuario').val();

        if (usuarioActual == UsuarioCreador) {

            var filas = document.getElementById("numeroDetalle").value;

            for (var i = filas; i > 0; i--) {
                var jqMonto = eval("'#monto" + i + "'");
                var jqDescripcion = eval("'#descripcion" + i + "'");
                var jqEstatus = eval("'#estatus" + i + "'");
                if ($(jqEstatus).val() == 'S') {
                    $(jqMonto).removeAttr("readOnly");
                    $(jqDescripcion).removeAttr("readOnly");
                } else {
                    agregaDisabled(jqMonto);
                    agregaDisabled(jqDescripcion);
                    agregaDisabled($('#concept' + i));
                    agregaDisabled($('#estatusDes' + i));
                    agregaDisabled($('#observaciones' + i));
                }
            }
        }
        //Validando si no son roles tesoreria no deja modificar 
        if (usuarioActual != UsuarioCreador) {
            if (parametroBean.perfilUsuario != parametroBean.rolTesoreria) {
                if (parametroBean.perfilUsuario != parametroBean.rolAdminTeso) {
                    ocultaBotones(); //-- 
                } else {
                    muestraBotones();
                }
            } else {
                muestraBotones();
            }
            $('input[name=elimina]').each(function() {
                var jqCicElim = eval("'#" + this.id + "'");
                $(jqCicElim).hide();
            });
        }

        $('input[name=monto]').each(function() {
            var jqCicElim = eval("'#" + this.id + "'");
            $(jqCicElim).formatCurrency({
                positiveFormat: '%n',
                roundToDecimalPlace: 2
            });
        });
    }

    function agregaDisabled(idControl) {
        $(idControl).css({
            'background-color': '#E6E6E6',
            "color": "#6E6E6E"
        });
        $(idControl).css({
            'background-color': '#E6E6E6',
            "color": "#6E6E6E"
        });
    }

    function muestraBotones() {
        $('#grabar').show();
        if (parametroBean.numeroUsuario == $('#usuario').val()) { //if(parametroBean.Usuario==9){
            $('#grabarCerrado').show();
        }
        $('#modificar').show();
        $('#agregar').show();
    }

    function nuevoPresupuesto() {
        var nuevoPreSuc = $('#folio').val();
        var fechaPresup = $('#fechaPresupuesto').val();
        limpiaForm('#formaGenerica');
        $('#folio').val(0);
        habilitaBoton('grabar', 'submit');
        deshabilitaBoton('modificar', 'submit');
        $('#usuario').val(parametroBean.numeroUsuario);
        $('#nombreUsuario').val(parametroBean.nombreUsuario);
        $('#sucursal').val(parametroBean.sucursal);
        $('#sucursalNombre').val(parametroBean.nombreSucursal);
        $('#fecha').val(obtenDia());
        $('#fechaOperacion').val(obtenDia());
        $('#estatusPre').val('N');
        $('#estatusVista').val('Nuevo Presupuesto');
        $('#grabarCerrado').val('Grabar y Cerrar');
        tablaVacia();
        $('#tableCon').hide();
        muestraBotones();
        describeMesPres(obtenDia());
        $('#conceptoID').val('');
        $('#plantillaCaptura').show();
        $('#fechaPresupuesto').val(fechaPresup);
        //	 diasLimite();


    }

    function pegaHtml(folioOperacion, rol) {
        var usuarioActual = parametroBean.numeroUsuario;
        var UsuarioCreador = $('#usuario').val();


        if (!isNaN(folioOperacion)) {
            var params = {};
            //mensajeSis(folioOperacion);
            params['folio'] = folioOperacion;
            params['tipoConsulta'] = catTipoConPresupSucur.principal;
            params['rolUsuario'] = rol;
            params['rolTesoreria'] = parametroBean.rolTesoreria; //-- enviando roltesoreria para que lo lea el controlador
            params['rolTesoreriaAdmin'] = parametroBean.rolAdminTeso; //-- enviando rolAdminteso para que lo lea el controlador

            $.post("presupSucursalGrid.htm", params, function(data) {
                if (data.length > 0 && folioOperacion != '') {
                    $('#tableCon').replaceWith(data);
                    agregaDescripConceptos();
                    agregaDescGasto();
                    darPermisosEscritura();
                    agregaFormatoControles('formaGenerica');
                    if (existenPorAutorizar() == false) {
                        if (usuarioActual != UsuarioCreador) {
                            ocultaBotones();
                        };
                    }
                } else {
                    mensajeSis('No se han encontrado movimientos con los datos proporcionados');
                    $('#folioOperacion').val("");
                }
            });
        }
    } //fin funcion pega Html



    function consultaNombreSucursal(control) {

        var jqSuc = eval("'#" + control + "'");
        var numSuc = $(jqSuc).val();

        sucursalesServicio.consultaSucursal(catTipoConPresupSucur.principal, numSuc,
            function(sucBean) {
                if (sucBean != null) {
                    $('#sucursalNombre').val(sucBean.nombreSucurs);
                } else {
                    mensajeSis("No se encontro la sucursal");
                }

            });
    } //fin uncion consultaNombreSucursal

    function tablaVacia() {
        var filas = document.getElementById("numeroDetalle").value;
        for (var i = filas; i > 0; i--) {
            var jqTr = eval("'#renglon" + i + "'");
            $(jqTr).remove();
        }
        $('#numeroDetalle').val(0);


    }

    function existenPreSolicitados() {
        var filas = document.getElementById("numeroDetalle").value;
        var existeSolicitado = false;
        for (var i = filas; i > 0; i--) {
            var jqTr = eval("'#estatus" + i + "'");
            var estatus = $(jqTr).val();
            if (estatus == 'S') {
                existeSolicitado = true;
            }
        }
        return existeSolicitado;
    }

    function existeConceptoEnGrid(conceptoNuevo) {
        var filas = document.getElementById("numeroDetalle").value;

        var existeConcepto = false;
        for (var i = filas; i > 0; i--) {
            var jqConcpGrid = eval("'#concepto" + i + "'");
            var jqDescGrid = eval("'#descripcion" + i + "'");
            var jqEstatus = eval("'#estatus" + i + "'");

            var estatus = $(jqEstatus).val();
            var concepto = $(jqConcpGrid).val();
            if (concepto == conceptoNuevo) {
                //  if(concepto==conceptoNuevo && estatus=='S'){
                existeConcepto = true;
                $(jqDescGrid).focus();
            }
        }
        return existeConcepto;
    }

    function agregaDescripConceptos() {
        var filas = document.getElementById("numeroDetalle").value;
        for (var i = filas; i > 0; i--) {
            var jqConcepto = eval("'#concepto" + i + "'");
            var jqConcepDesc = eval("'#concept" + i + "'");
            var tipoGasto = $(jqConcepto).val();
            getDescripcionGasto(tipoGasto, jqConcepDesc);

        }
    }

    function obtenDia() {

        return parametroBean.fechaSucursal;
    }

    function obtenMes() {
        var fecha = parametroBean.fechaSucursal;
        var array = fecha.split('-');
        var mes = array[1];
        return mes;
    }

    function obtenAnio() {
        var fecha = parametroBean.fechaSucursal;
        var array = fecha.split('-');
        var anio = array[0];
        return anio;
    }
    $('#formaGenerica').validate({
        rules: {
            folio: {
                required: true
            },

        },
        messages: {
            folio: {
                required: 'Introduzca el Folio a consultar'
            },


        }
    });

    function regresaMes(numMes) {

        var mes = '';
        switch (numMes) {
            case '01':
                mes = "Enero";
                break;
            case '02':
                mes = "Febrero";
                break;
            case '03':
                mes = "Marzo";
                break;
            case '04':
                mes = "Abril";
                break;
            case '05':
                mes = "Mayo";
                break;
            case '06':
                mes = "Junio";
                break;
            case '07':
                mes = "Julio";
                break;
            case '08':
                mes = "Agosto";
                break;
            case '09':
                mes = "Septiembre";
                break;
            case '10':
                mes = "Octubre";
                break;
            case '11':
                mes = "Noviembre";
                break;
            case '12':
                mes = "Diciembre";
                break;
            default:
                mes = '';
        }
        return mes;
    }

    function consultaEsFechaMenor(y, m, d) {

        var fechaSistema = parametroBean.fechaSucursal;
        var array = fechaSistema.split('-');
        var anio = array[0];
        var mes = array[1];
        var dia = array[2];

        if (anio > y) {
            return true;
        } else {
            if (anio == y) {
                if (mes > m) {
                    return true;
                } else {
                    return false;
                }
            } else {
                return false;
            }
        }
    }

    function ultimoDia(dia, mes, anio) {
        dia = parseInt(dia);

        while (checkdate(mes, dia + 1, anio)) {

            dia++;

        }
        return dia;
    }


    function checkdate(m, d, y) {
        return m > 0 && m < 13 && y > 0 && y < 32768 && d > 0 && d <= (new Date(y, m, 0)).getDate();
    }

    function ultimoDiaDob(dia, mes, anio, dia2, mes2, anio2) {
        dia = parseInt(dia);

        while (checkdateDoble(mes, dia + 1, anio, dia2, mes2, anio2)) {

            dia++;

        }
        return dia;
    }

    function checkdateDoble(m, d, y, m2, d2, y2) {
        return m > 0 && m < 13 && y > 0 && y < 32768 && d > 0 && d <= (new Date(y2, m2, 0)).getDate();
    }



    function existenPorAutorizar() {
        var existen = false;

        $('select[name=estatus]').each(function() {
            var jqEstatus = eval("'#" + this.id + "'");

            if ($(jqEstatus).val() == 'S') {
                existen = true;

            }

        });

        return existen;
    }

    function existenMontosCero() {
        var existen = false;

        $('input[name=monto]').each(function() {
            var jqMonto = eval("'#" + this.id + "'");

            if ($(jqMonto).val() == '') {
                existen = true;
            }

        });

        return existen;
    }

    function limpiaTablaGrids() {

        var tabla = '<div id="tableCon">';
        tabla += '<c:set var="listaResultado"  value="${listaResultado[0]}"/>';
        tabla += '<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">';
        tabla += '<tbody>	<tr align="center">';
        tabla += ' <td class="label"> <label for="lblNumero"></label> </td>';
        tabla += '<td class="label"> 	<label for="lblCuenta">Concepto</label> </td> ';
        tabla += '<td class="label"> 	<label for="lblDescripcion">Descripci&oacute;n</label> 	</td>';
        tabla += '<td class="label" > <label for="lblEstatus">Estatus</label> </td>';
        tabla += '<td class="label" > <label for="lblMonto">Monto</label> </td>  ';
        tabla += '<td class="label" > <label for="lblobservaciones">Observaciones</label> </td>  ';
        tabla += '</tr></tbody>';
        tabla += '</table>';
        tabla += '<input type="hidden" value="0" name="numeroDetalle" id="numeroDetalle" />';
        tabla += '</div>';

        $('#tableCon').replaceWith(tabla);

    }

    function limpiaEncabezado() {
        deshabilitaBoton('grabar', 'submit');
        deshabilitaBoton('modificar', 'submit');
        $('#folio').val('');
        $('#usuario').val('');
        $('#nombreUsuario').val('');
        $('#sucursal').val('');
        $('#sucursalNombre').val('');
        $('#fechaOperacion').val('');
        $('#estatusVista').val('');

        tablaVacia();
        $('#tableCon').hide();
        $('#folio').focus();

    }


    //Grid de PResupuestos 
    //fucnion que checa si el estatus =Cancelado pondra como obligatorio el campo de Observaciones
    function verificarObservaciones() {
        var cancelado = 'C';
        var numPresupuestos = consultaFilas();

        for (var i = 1; i <= numPresupuestos; i++) {
            var valorEstatus = $("#estatus" + i + "").val();
            var observacion = $("#observaciones" + i + "").val();
            if (observacion == "") {

                if (valorEstatus == cancelado) {
                    $('#observaciones' + i).focus();
                    $(observacion).addClass("error");
                    return 1;
                }
            }

        }
    }
    // consulta Filas del Grid de  PResupuestos
    function consultaFilas() {
        var totales = 0;
        $('tr[name=renglon]').each(function() {
            totales++;

        });
        return totales;
    }

});

/////////////////////////////////////////////////
/////  fin de jquery ///////////////////////////
////////////////////////////////////////////////