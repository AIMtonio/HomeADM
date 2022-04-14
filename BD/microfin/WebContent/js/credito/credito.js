            var tab2 = false;
            var financiado = "FINANCIAMIENTO";// tipo de pago del Seguro de Vida
            var deduccion = "DEDUCCION";// tipo de pago del Seguro de Vida
            var anticipado = "ANTICIPADO";// tipo de pago del Seguro de Vida
            var programado  = "PROGRAMADO"; // Forma de cobro de la comision por apertura
            var montoinicial = 0;// monto inicial original
            var plazoInicial=0; // plazoID inicial
            var montoFinal=0; // Guarda el monto de credito ya con Seguro de Vida,Comision por Apertura y Iva de la Comision por Apertura.
            var comisionInicial=0; //Guarada el monto inicial de la comision.
            var costoSeguroVidaCredito = 0;// costo del seguro de vida
            var seguroInicial=0;
           
            
            
            

            var requiereSeg = "0";
            var numeroDias = 0; // numero de dias entre fechas
            var procedeSubmit = 1;
            var procede = 1;
            var consultaTasa='';

            var parametroBean = consultaParametrosSession();
            var usuario = parametroBean.numeroUsuario;
            var fechaSucursal = parametroBean.fechaSucursal;
            var diaSucursal = parametroBean.fechaSucursal.substring(8, 10);

            var cuentaPrincipalActiva = '';
            var productoCreSolici = '';
            var lineaCreSi = "0"; // variable que indica si entro a consultar la linea de credito
            var productoCredAnte = ""; // Guarda el número del producto de crédio anterior
            var contadorProduc = 0;
            var contasa = 0;
            var tipoPrepCre="";
            var AltaCredito ='C';
            var inicioAfuturo = ''; // indica si el producto de credito permite el desembolso anticipado del credito
            var diasMaximo = 0; // Indica el maximo numero dias a los que se puede desembolsar un credito antes de su fecha de inicio
            var estatusSimulacion = false ; // indica si ya se realizó la simulación
            $('#pantalla').val(AltaCredito);
            var modalidad; //modalidad de pago de seguro de vida en producto de crédito
            var tipoPagoSeg = ""; //Tipo de Pago de Seguro de Vida
            var esquemaSeguro;
            var prodCredito;
            var factorRS;
            var porcentajeDesc;
            var montoPol;
            var descuentoSeg;
            var pagoSeg;
            var dias;
            var productoCredito;
            var TasaFijaID = 1; // ID de la formula para tasa fija (FORMTIPOCALINT)
            var TasaBasePisoTecho = 3; // ID de la formula para tasa base con piso y techo (FORMTIPOCALINT)
            var hayTasaBase = false; // Indica la existencia de una tasa base
            var VarTasaFijaoBase = 'Tasa Fija Anualizada'; // Texto que indica si se trata de tasa fija o tasa base actual (alert)
            var var_TipoCredito = {
                    'NUEVO'             : 'N',
                    'RENOVACION'        : 'O',
                    'REESTRUCTURA'      : 'R',
                    'NUEVODES'          : 'NUEVO',
                    'RENOVACIONDES'     : 'RENOVACIÓN',
                    'REESTRUCTURADES'   : 'REESTRUCTURA',
                    'REACREDITAMIENTODES' : 'REACREDITAMIENTO'
            };
            var valorTasaBase   = 0  //Valor de la tasa base cuando el calculo de interes es de tipo 2,3,4.
            var permiteSolicitudProspecto = 'S';
            var var_permiteProspecto    ='N';
            var frecuenciaQuincenal = 'Q';
            var diaPagoQuincenalCal = '';
            var labelDiaPago = '';
            var textoDiaPago = '';
            var cobroXApertura = '';
            var pIVA = '';
            var iva = 0.00;
            var manejaConvenio = 'N';
            var noSeguirPro = false;

            var expedienteBean = {
                    'clienteID' : 0,
                    'tiempo' : 0,
                    'fechaExpediente' : '1900-01-01',
            };

            var listaPersBloqBean = {
                    'estaBloqueado' :'N',
                    'coincidencia'  :0
            };
            
            var consultaSPL = {
            		'opeInusualID' : 0,
            		'numRegistro' : 0,
            		'permiteOperacion' : 'S',
            		'fechaDeteccion' : '1900-01-01'
            };
            
            var esCliente           ='CTE';
            var esUsuario           ='USS';
            var esProspecto			= 'PRO';

            var catDiaPagoQuinc = {
                'Indistinto'    : 'I',
                'DiaQuincena'   : 'D',
                'Quincenal'     : 'Q'
            };
            var pagosXReferencia = '';
            var cobraAccesoriosGen = 'N';
            var cobraAccesorios = 'N';
            var cicloCliente = 0;
            var cobraGarantiaFinanciada = "N";
            //Variables para servicios adicionales
            var aplicaServicioSi = 'S';
            var enteroCero = '0';
            var listaServiciosAdicionales = [];
            var estatusCredito = '';
            var esNomina = 'N';


            $(document).ready(function() {
                deshabilitaControlesAlta();
                deshabilitaControl('tipoPrepago');
                inicializaValores();
                consultaParametros();
                consultaSICParam();
                 consultaManejaConvenios();
                esTab = true;
                var tipoLista = 0;
                var MontoIni = 0;
                var NumCuotas = 0;
                var NumCuotasInt = 0;
                var MontoMaxCre = 0.0;
                var MontoMinCre = 0.0;



                $('#clienteInstitucion').val(parametroBean.clienteInstitucion);
                $('#cuentaInstitucion').val(parametroBean.cuentaInstitucion);

                $('#datosNomina').hide();
                $('#institucionNominaID').val("");
                $('#nombreInstit').val("");
                $('#convenioNominaID').val("");
                $('#desConvenio').val("");
                if(manejaConvenio=='S'){
                listaCatQuinquenios();
                }
                $('.quinquenios').hide();
                $('.folioSolici').hide();
                $('#folioSolici').val("");
                dwr.util.removeAllOptions('quinquenioID');
                dwr.util.addOptions('quinquenioID',{'':'SELECCIONAR'});

                // Definicion de Constantes y Enums
                var catTipoTransaccionCredito = {
                        'agrega' : '1',
                        'modifica' : '2',
                        'simulador' : '9'
                };

                var catTipoConsultaCredito = {
                        'principal' : 1,
                        'foranea' : 2,
                        'prodSinLin' : 3
                };

                var catOperacFechas = {// Operaciones Entre Fechas
                        'sumaDias' : 1,
                        'restaFechas' : 2
                };

                tipoConAccesorio = {
                        'producto'  : 38,
                        'plazo'     : 39
                    };


                // ------------ Metodos y Manejo de Eventos -----------------------------------------
                deshabilitaBoton('modifica', 'submit');
                $('#reqSeguroVidaSi').attr("checked", false);
                $('#reqSeguroVidaNo').attr("checked", false);
                deshabilitaControl('reqSeguroVidaSi');
                deshabilitaControl('reqSeguroVidaNo');
                deshabilitaControl('relacionado');
                $('#reqSeguroVida').val('N');
                $('#trMontoSeguroVida').hide('slow');
                $('#trBeneficiario').hide('slow');
                $('#trParentesco').hide('slow');
                $('#tipoFondeo').attr("checked", true);
                $('#prepagos').hide();
                $('#prepagoslbl').hide();
                mostrarLabelTasaFactorMora('');
                $('#fieldOtrasComisiones').hide();

                $(':text').focus(function() {
                    esTab = false;
                });

                agregaFormatoControles('formaGenerica');

                // ------------ Llenar combo Formulas Calculo Interes -----------------------------------------
                consultaComboCalInteres();
                validaMonitorSolicitud();
                validaPagosXReferencia();
                consultaCobraAccesorios();
                consultaCobraGarantiaFinanciada();

                $.validator.setDefaults({submitHandler : function(event) {

                    if(($("#tipoTransaccion").val() == 1 || $("#tipoTransaccion").val() == 2) && estatusSimulacion == false){
                        mensajeSis("Se Requiere Simular las Amortizaciones.");
                    }
                    else{
                        procedeSubmit = validaCamposRequeridos();
                        if (procedeSubmit == 0) {
                            procedeSubmit  = validaUltimaCuotaCapSimulador();
                            if(procedeSubmit == 0 ){
                                grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma','mensaje', 'true', 'creditoID',
                                        'accionInicializaRegresoExitoso','accionInicializaRegresoFallo');
                            }
                        }
                    }
                }
                });

                $(':text').bind('keydown', function(e) {
                    if (e.which == 9 && !e.shiftKey) {
                        esTab = true;
                    }
                });

                $('#agrega').click(function() {
                    var solCre = $('#solicitudCreditoID').val();
                    if (solCre > 0) {
                        habilitaControl('direccionBen');
                    }
                    establecerAplicaServiciosAdicionales();
                    $('#tipoTransaccion').val(catTipoTransaccionCredito.agrega);
                });

                $('#modifica').click(function() {
                    var solCre = $('#creditoID').val();
                    if (solCre > 0) {
                        habilitaControl('direccionBen');
                    }
                    establecerAplicaServiciosAdicionales();
                    $('#tipoTransaccion').val(
                            catTipoTransaccionCredito.modifica);
                });

                $('#creditoID').bind('keyup',function(e) {
                    lista('creditoID', '2', '11','creditoID', $('#creditoID').val(),'ListaCredito.htm');
                });


                /*Valida que sea un nuevo credito para deshabilitar los controles de la
                 * solictud y el cliente*/
                $('#creditoID').bind('keyup',function(e) {

                    if($('#creditoID').val() == 0){
                        habilitaControl('solicitudCreditoID');
                        habilitaControl('clienteID');

                    }
                });


                $('#creditoID').blur(function() {
                    estatusSimulacion = false ;
                    deshabilitaControl('cuentaCLABE');

                    if (isNaN($('#creditoID').val())) {

                        $('#creditoID').val("");
                        $('#creditoID').focus();
                        inicializaValores();
                        inicializaCombos();
                        tab2 = false;

                    } else {
                        if ($('#creditoID').asNumber()==0 && esTab) {
                            $('#divComentarios').show();
                            inicializaValores();
                            inicializaCombos();
                            inicializaCombosCredito();
                            incializaCamposNuevoCredito();
                        
                             habilitaBoton('autorizar','submit');
                            
                            $('#contenedorFondeo').hide();
                            deshabilitaBoton('modifica', 'submit');
                            consultaParametros();
                            $('#destinCredFRID').val('');
                            $('#descripDestinoFR').val('');
                            consultaSICParam();

                        }else{
                            if (tab2 == false) {
                                esTab = true;
                                validaCredito(this.id);
                                consultaEsquemaSeguroVidaForanea($('#producCreditoID').val(),tipoPagoSeg);


                                $('#divComentarios').show();

                            }

                        }
                    }
                });


                $('#clienteID').bind('keyup',function(e) {
                    lista('clienteID', '3', '1', 'nombreCompleto',$('#clienteID').val(),'listaCliente.htm');
                });

                $('#buscarMiSuc').click(function(){
                    listaCte('clienteID', '3', '19', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
                });
                $('#buscarGeneral').click(function(){
                    listaCte('clienteID', '3', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
                });


                $('#clienteID').blur(function() {
                    if(($('#clienteID').val()!='0' || $('#clienteID').val()!='') && esTab){
                        consultaTasa = 'S';

                        var clienteBloq = $('#clienteID').asNumber();
                        if(clienteBloq>0){
                            listaPersBloqBean = consultaListaPersBloq(clienteBloq, esCliente, 0, 0);
                            if(listaPersBloqBean.estaBloqueado!='S'){
                                consultaCliente(this.id,consultaTasa);
                            } else {
                                mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
                                $('#clienteID').focus();
                                $('#clienteID').val('');
                                $('#nombreCliente').val('');
                            }
                        }
                    }
                });

                $('#lineaCreditoID').bind('keyup',function(e) {
                    if (this.value.length >= 0) {
                        var camposLista = new Array();
                        var parametrosLista = new Array();
                        camposLista[0] = "clienteID";
                        camposLista[1] = "productoCreditoID";
                        parametrosLista[0] = $('#clienteID').val();
                        parametrosLista[1] = $('#producCreditoID').val();
                        lista('lineaCreditoID', '1', '2',camposLista, parametrosLista,'lineasCreditoAltaCredLista.htm');
                    }
                });


                $('#lineaCreditoID').blur(function() {
                    if( !isNaN($('#lineaCreditoID').val())) {
                        consultaLineaCredito(this.id);
                        if(modalidad == 'T'){
                        consultaEsquemaSeguroVidaForanea($('#producCreditoID').val(),$('#forCobroSegVida').val());
                        }

                    }

                });

                // Consulta Tasa Base al perder el Foco
                $('#tasaBase').blur(function() {
                    if ($('#tasaBase').val() != 0) {
                        consultaTasaBase(this.id,true);
                    } else {
                        hayTasaBase = false;
                        $('#tasaBase').val('');
                        $('#desTasaBase').val('');
                        $('#tasaFija').val('').change();
                    }
                });
                // Buscar Tasa Base por Nombre
                $('#tasaBase').bind('keyup',function(e) {
                    if (this.value.length >= 2) {
                        lista('tasaBase', '2', '1', 'nombre', $('#tasaBase').val(),'tasaBaseLista.htm');
                    }
                });

                $('#sobreTasa').blur(function() {
                    if(hayTasaBase){
                        $('#tasaFija').val(parseFloat(valorTasaBase) + $('#sobreTasa').asNumber()).change();
                        $('#tasaFija').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
                    } else {
                        $('#tasaFija').val('').change();
                    }
                });

                $('#tasaFija').change(function() {
                    vuelveaSimular();
                });

                $('#producCreditoID').bind('keyup',function(e) {
                    lista('producCreditoID', '1', '3','descripcion', $('#producCreditoID').val(),'listaProductosCredito.htm');
                });

                $('#producCreditoID').blur(function() {
                    if($('#producCreditoID').val()!='' || $('#producCreditoID').val()!='0' ){
                        MontoIni = 0; // inicializar valor de monto de credito cuando se cambia el producto
                        if($('#lineaCreditoID').val()=='' || $('#lineaCreditoID').val()=='0'){
                            consultaProducCredito(this.id);

                        }else {
                            validaProductoLineaCredito('lineaCreditoID');

                        }
                        ValidaCalcInteres('calcInteresID');

                    }
                });

                $('#fechaInhabil1').click(function() {
                    $('#fechaInhabil2').attr('checked', false);
                    $('#fechaInhabil1').attr('checked', true);
                    $('#fechaInhabil').val("S");
                    $('#fechaInhabil1').focus();
                });

                $('#fechaInhabil2').click(function() {
                    $('#fechaInhabil1').attr('checked', false);
                    $('#fechaInhabil2').attr('checked', true);
                    $('#fechaInhabil').val("A");
                    $('#fechaInhabil2').focus();
                });

                $('#frecuenciaCap').change(function() {
                    validarEventoFrecuencia();
                    validaPeriodicidad();
                    consultaFechaVencimiento('plazoID');
                });

                $('#frecuenciaCap').blur(function() {
                    validarEventoFrecuencia();
                    validaPeriodicidad();
                    consultaFechaVencimiento('plazoID');
                });

                $('#frecuenciaInt').change(function() {
                    validarEventoFrecuencia();
                    validaPeriodicidad();
                    consultaCuotasInteres('plazoID');
                });
                $('#frecuenciaInt').blur(function() {
                    validarEventoFrecuencia();
                    validaPeriodicidad();
                    consultaCuotasInteres('plazoID');
                });

                $('#diaPagoCapital1').click(function() {
                    $('#diaPagoCapital2').attr('checked',false);
                    $('#diaPagoCapital1').attr('checked',true);
                    $('#diaPagoCapital').val('F');
                    deshabilitaControl('diaMesCapital');
                    $('#diaMesCapital').val("");

                    if ($('#tipoPagoCapital').val() == 'C' ||  $('#perIgual').val() == 'S') {
                        $('#diaPagoInteres2').attr('checked', false);
                        $('#diaPagoInteres1').attr('checked', true);
                        $('#diaPagoInteres').val('F');
                        deshabilitaControl('diaMesInteres');
                        $('#diaMesInteres').val("");
                    }
                });

                $('#diaPagoCapital2').click(function() {
                    $('#diaPagoCapital1').attr('checked',false);
                    $('#diaPagoCapital2').attr('checked',true);
                    $('#diaPagoCapital').val('D'); // Por default se asigna dia del mes
                    $('#diaMesCapital').val(diaSucursal);

                    if ($('#diaPagoProd').val() =="D" || $('#diaPagoProd').val() =="I") { // solo si es Dia del mes o Indistinto se habilita la caja
                        habilitaControl('diaMesCapital');
                    }
                    else {
                        deshabilitaControl('diaMesCapital');
                    }

                    if ($('#tipoPagoCapital').val() == 'C' ||  $('#perIgual').val() == 'S') {
                        $('#diaPagoInteres1').attr('checked', false);
                        $('#diaPagoInteres2').attr('checked', true);
                        deshabilitaControl('diaMesInteres');
                        $('#diaMesInteres').val(diaSucursal);
                        $('#diaPagoInteres').val('D');
                    }
                });


                $('#diaPagoInteres1').click(function() {
                    $('#diaPagoInteres2').attr('checked',false);
                    $('#diaPagoInteres1').attr('checked',true);
                    $('#diaPagoInteres').val('F');
                    deshabilitaControl('diaMesInteres');
                    $('#diaMesInteres').val("");

                });

                $('#diaPagoInteres2').click(function() {
                    $('#diaPagoInteres1').attr('checked', false);
                    $('#diaPagoInteres2').attr('checked', true);
                    $('#diaPagoInteres').val($('#diaPagoProd').val());
                    $('#diaPagoInteres1').attr('checked',false);
                    $('#diaPagoInteres2').attr('checked',true);
                    $('#diaPagoInteres').val('D'); // Por default se asigna dia del mes
                    $('#diaMesInteres').val(diaSucursal);

                    if ($('#diaPagoProd').val() =="D" || $('#diaPagoProd').val() =="I") { // solo si es Dia del mes o Indistinto se habilita la caja
                        habilitaControl('diaMesInteres');
                    }
                    else {
                        deshabilitaControl('diaMesInteres');
                    }
                });

            $('#periodicidadCap').blur(function() {
                    if(parseInt(this.value) > 0){
                        if($("#frecuenciaCap").val() == 'P'){
                            $("#numAmortizacion").val(parseInt(parseInt($("#noDias").val()) / parseInt(this.value)));
                        }
                        if ($('#tipoPagoCapital').val() == 'C' || $( '#perIgual').val() == 'S') {
                            $('#periodicidadInt').val($('#periodicidadCap').val());
                            $('#numAmortInteres').val($('#numAmortizacion').val());
                        }
                    }
                    else{
                        if($("#frecuenciaCap").val() != ''){
                            if($("#frecuenciaCap").val() != 'L'){
                                mensajeSis("Indique la Periodicidad de Capital.");
                                this.focus();
                            }
                        }
                    }
                });

                $('#periodicidadInt').blur(function() {
                    if(parseInt(this.value) > 0){
                        if($("#frecuenciaInt").val() == 'P'){
                            $("#numAmortInteres").val(parseInt(parseInt($("#noDias").val()) / parseInt(this.value)));
                        }
                    }
                    else{
                        if($("#frecuenciaInt").val() != ''){
                            if($("#frecuenciaInt").val() != 'L'){
                                mensajeSis("Indique la Periodicidad de Interés.");
                                this.focus();
                            }
                        }
                    }
                });


                $('#ajusFecUlVenAmo1').click(function() {
                    $('#ajusFecUlVenAmo2').attr('checked', false);
                    $('#ajusFecUlVenAmo1').attr('checked', true);
                    $('#ajusFecUlVenAmo').val("S");
                    $('#ajusFecUlVenAmo1').focus();
                });

                $('#ajusFecUlVenAmo2').click(function() {
                    $('#ajusFecUlVenAmo1').attr('checked', false);
                    $('#ajusFecUlVenAmo2').attr('checked', true);
                    $('#ajusFecUlVenAmo').val("N");
                    $('#ajusFecUlVenAmo2').focus();
                });



            $('#tipoPagoCapital').change(function() {
                    estatusSimulacion = false;
                    validaTipoPago();
            });

            $('#tipoPagoCapital').blur(function() {
                validaTipoPago();
                $('#recalculo').hide();
            });

            $('#calendIrregularCheck').click(function() {

            if ($('#calendIrregularCheck').is(':checked')) {
                $('#calendIrregular').val("S");
                deshabilitaControl('frecuenciaInt');
                deshabilitaControl('frecuenciaCap');
                deshabilitaControl('tipoPagoCapital');
                $('#frecuenciaInt').val('L').selected = true;
                $('#frecuenciaCap').val('L').selected = true;
                $('#tipoPagoCapital').val('L').selected = true;
                $("#numAmortInteres").val('1');
                $("#numAmortizacion").val('1');
                deshabilitaControl('numAmortInteres');
                deshabilitaControl('numAmortizacion');
            } else {
                $('#calendIrregular').val("N");
                $('#frecuenciaInt').val('').selected = true;
                $('#frecuenciaCap').val('').selected = true;
                habilitaControl('frecuenciaInt');
                habilitaControl('frecuenciaCap');
                habilitaControl('tipoPagoCapital');
                habilitaControl('numAmortizacion');

                if($("#tipoPagoCapital").val() == 'C' || $('#perIgual').val() == 'S' ) {
                    deshabilitaControl('numAmortInteres');
                }else{
                    habilitaControl('numAmortInteres');
                }
            }

            $('#numTransacSim').val("0");
        });

                $('#simular').click(function() {
                    if ($('#tasaFija').asNumber() != '0' || $('#tasaFija').val() == ''){
                        if($('#tipoPagoCapital').val() == "L"){
                            if($('#creditoID').asNumber()>0 || $('#solicitudCreditoID').asNumber()>0 ){
                                if($('#numTransacSim').asNumber() >0){
                                    consultaSolCredLibre();
                                }else{
                                    simulador();
                                }
                            }else{
                                simulador();
                            }
                        }else{
                            if(($('#frecuenciaCap').val().trim() == frecuenciaQuincenal
                                && $('#diaMesCapital').asNumber() == 0 && $("#tipoCredito").val()=='R') ||
                                ($('#frecuenciaInt').val().trim() == frecuenciaQuincenal
                                && $('#diaMesInteres').asNumber() == 0  && $("#tipoCredito").val()=='R')){
                                mensajeSis('Indicar el Día de Pago para poder Simular.');
                            } else {
                                simulador();
                            }
                        }
                    } else {
                        mensajeSis('No tiene '+VarTasaFijaoBase);
                        $('#tasaFija').select();
                    }


                });

                $('#solicitudCreditoID').bind('keyup',function(e) {
                    if (this.value.length >= 0) {
                        var camposLista = new Array();
                        var parametrosLista = new Array();
                        camposLista[0] = "clienteID";
                        parametrosLista[0] = $('#solicitudCreditoID').val();
                        lista('solicitudCreditoID', '1', '7',camposLista, parametrosLista,'listaSolicitudCredito.htm');
                    }
                });

                $('#solicitudCreditoID').blur(function() {

                    var cadena = $('#solicitudCreditoID').asNumber();
                    expresionRegular = /^([0-9,%])*$/;

                    if (esTab && (!expresionRegular.test(cadena) || cadena == 0)){
                        $('#solicitudCreditoID').val('');
                        $('#solicitudCreditoID').focus();
                        mensajeSis("Ingrese una solicitud.");
                    }


                    if ($('#solicitudCreditoID').asNumber() > '0'  && $('#creditoID').asNumber() >= 0) {
                        // alta de credito con solicitud
                        consultaSolicitudCred(this.id);

                        if(tipoPagoSeg == 'A'){
                            $("#tipPago option[value="+ tipoPagoSeg +"]").attr("selected",true);
                            }
                            if(tipoPagoSeg == 'F'){
                            $("#tipPago option[value="+ tipoPagoSeg +"]").attr("selected",true);

                            }
                            if(tipoPagoSeg == 'D'){
                            $("#tipPago option[value="+ tipoPagoSeg +"]").attr("selected",true);

                            }
                            if(tipoPagoSeg == 'O'){
                            $("#tipPago option[value="+ tipoPagoSeg +"]").attr("selected",true);

                            }

                            consultaEsquemaSeguroVidaForanea($('#producCreditoID').val(), $('#forCobroSegVida').val());
                    }
                    else{
                        setTimeout("$('#cajaLista').hide();", 200);
                    }
                });

                $('#cuentaID').bind('keyup',function(e) {
                    var camposLista = new Array();
                    var parametrosLista = new Array();
                    camposLista[0] = "clienteID";
                    parametrosLista[0] = $('#clienteID').val();
                    lista('cuentaID', '1', '2', camposLista, parametrosLista,'cuentasAhoListaVista.htm');
                });


                $('#creditoID').focus();



                $('#montoCredito').blur(function() {
                    if($('#montoCredito').asNumber()>0){
                            if($('#plazoID').val()!='0' && $('#plazoID').val()!=''){
                                agregaFormatoControles('formaGenerica');
                                esmoneda = "true";
                                validaMontoCredito();
                        }


                        if(inicioAfuturo == 'S'){
                            $('#fechaInicioAmor').focus();
                        }
                        else {
                                $('#plazoID').focus();
                             }
                    }
                });


                $('#montoCredito').keyup(function(e) {
                    if(vlidarTeclas(e)){
                        montoinicial = $('#montoCredito').asNumber();
                    }
                });


                 function vlidarTeclas(tecla){
                     var aceptado = false;
                        if((tecla.keyCode >= 48 && tecla.keyCode <= 57) ||  // teclas numercias
                            (tecla.keyCode >= 96 && tecla.keyCode <= 105) || // panel teclado numerico
                            (tecla.keyCode == 190) || (tecla.keyCode == 110) || (tecla.keyCode == 8)){ // punto, retroceso
                            aceptado = true;
                        }
                        return aceptado;
                 }



                $('#tasaFija').blur(function() {
                    var solicitud = $('#solicitudCreditoID').val();
                    var tasaF = $('#tasaFija').val();
                    if (solicitud == '0' || solicitud == '') {
                        $('#tasa').val(tasaF);
                        $('#porcentaje').val('100.00');
                    }
                });



                $('#fechaVencimien').bind('keyup',function(e) {
                    var fechaAplicacion = parametroBean.fechaAplicacion;
                    var fechInicio = $('#fechaInicio').val();
                    if (fechInicio < fechaAplicacion) {
                        mensajeSis('La fecha de Inicio no puede ser inferior a la del sistema');
                        $('#fechaInicio').focus();
                        $('#fechaInicio').select();
                    }
                });

                $('#fechaVencimien').blur(function() {
                    var fechaAplicacion = parametroBean.fechaAplicacion;
                    var fechInicio = $('#fechaInicio').val();
                    if (fechInicio < fechaAplicacion && fechInicio != '') {
                        mensajeSis('La fecha de Inicio no puede ser inferior a la del sistema');
                        $('#fechaInicio').focus();
                        $('#fechaInicio').select();
                    }
                });


                function convertDate(stringdate) {
                    var DateRegex = /([^-]*)-([^-]*)-([^-]*)/;
                    var DateRegexResult = stringdate.match(DateRegex);
                    var DateResult;
                    var StringDateResult = "";

                    try {
                        DateResult = new Date(DateRegexResult[2] + "/"
                                + DateRegexResult[3] + "/"
                                + DateRegexResult[1]);
                    } catch (err) {
                        DateResult = new Date(stringdate);
                    }

                    StringDateResult = (DateResult.getMonth() + 1) + "/"
                    + (DateResult.getDate() + 1) + "/"
                    + (DateResult.getFullYear());

                    return StringDateResult;
                }

                $('#calcInteresID').bind('keyup',function(e) {
                    var fechInicio = $('#fechaInicioAmor').val();
                    var fechaVenForm = $('#fechaVencimien').val();
                    convertDate(fechInicio);
                    convertDate(fechaVenForm);
                    if (fechaVenForm < fechInicio) {
                        mensajeSis("Fecha de Inicio debe ser superior a la de Vencimiento  ");
                        $('#fechaVencimien').focus();
                        $('#fechaVencimien').select();
                    }
                });

                $('#calcInteresID').blur(function() {
                    var fechInicio = $('#fechaInicioAmor').val();
                    var fechaVenForm = $('#fechaVencimien').val();
                    convertDate(fechInicio);
                    convertDate(fechaVenForm);
                    if (fechaVenForm < fechInicio) {
                        mensajeSis("Fecha de Vencimiento debe ser superior a la de Inicio");
                        $('#fechaVencimien').focus();
                        $('#fechaVencimien').select();
                    }
                });


                $('#cuentaID').blur(function() {
                    esTab = true;
                    consultaCta(this.id);
                });



                $('#plazoID').change(function() {
                    if($('#plazoID').val()!=''){
                        if($('#montoCredito').asNumber()>0){
                            //if(montoFinal.toFixed(2) != $('#montoCredito').asNumber().toFixed(2)  || plazoInicial!=$('#plazoID').val() ){
                                //consultaFechaVencimiento(this.id);
                                //consultaPorcentajeGarantiaLiquida('montoCredito');
                                validaMontoCredito();
                                plazoInicial=$('#plazoID').val();

                            //}
                        }
                    }
                });

                $('#plazoID').blur(function() {
                    if($('#plazoID').val()!=''){
                        if($('#montoCredito').asNumber()>0){
                            //if(montoFinal.toFixed(2) !=$('#montoCredito').asNumber().toFixed(2)  || plazoInicial!=$('#plazoID').val() ){
                                //consultaFechaVencimiento(this.id);
                                //consultaPorcentajeGarantiaLiquida('montoCredito');
                                validaMontoCredito();
                                consultaFechaVencimiento(this.id);
                                plazoInicial=$('#plazoID').val();

                        //  }
                        }
                    }
                });

                $('#tipoConsultaSICBuro').click(function() {
                    $('#tipoConsultaSICBuro').attr("checked",true);
                    $('#tipoConsultaSICCirculo').attr("checked",false);
                    $('#consultaBuro').show();
                    $('#consultaCirculo').hide();
                    $('#folioConsultaCC').val('');
                    $('#tipoConsultaSIC').val('BC');

                });

                $('#tipoConsultaSICCirculo').click(function() {
                    $('#tipoConsultaSICBuro').attr("checked",false);
                    $('#tipoConsultaSICCirculo').attr("checked",true);
                    $('#consultaBuro').hide();
                    $('#consultaCirculo').show();
                    $('#folioConsultaBC').val('');
                    $('#tipoConsultaSIC').val('CC');

                });

                $('#institFondeoID').bind('keyup',function(e) {
                    lista('institFondeoID', '2', '1','nombreInstitFon', $('#institFondeoID').val(),'intitutFondeoLista.htm');
                });

                $('#institFondeoID').blur(function() {
                    consultaInstitucionFondeo(this.id);
                });

                $('#lineaFondeo').bind('keyup',function(e) {
                    lista('lineaFondeo', '2', '1', 'descripLinea',$('#lineaFondeo').val(),'listaLineasFondeador.htm');
                });

                $('#lineaFondeo').blur(function() {
                    consultaLineaFondeo(this.id);
                });

                $('#tipoFondeo').click(function() {
                    deshabilitaControl('institFondeoID');
                    deshabilitaControl('lineaFondeo');
                    $('#institFondeoID').val("0");
                    $('#lineaFondeo').val("0");
                    $('#descripFondeo').val("");
                    $('#descripLineaFon').val("");
                    $('#saldoLineaFon').val("0");

                });
                $('#tipoFondeo2').click(function() {
                    $('#tipoFondeo').attr("checked",false);
                    $('#tipoFondeo2').attr("checked",true);
                    habilitaControl('institFondeoID');
                    habilitaControl('lineaFondeo');
                });

                $('#destinoCreID').bind('keyup',function(e) {
                    lista('destinoCreID', '2', '1', 'destinoCreID',$('#destinoCreID').val(),'listaDestinosCredito.htm');
                });

                $('#destinoCreID').blur(function() {
                    consultaDestinoCredito(this.id);
                });

                // valida que el numero de cuotas sólo se modifique +1 cuota, -1 cuota de la calculada
                $('#numAmortizacion').blur(function() {
                    if($("#frecuenciaCap").val() != ""){
                            if(parseInt(this.value) > 0){
                                var nuevoNumCuotas = $('#numAmortizacion').asNumber();
                                var valorMayor = parseInt(NumCuotas) + 1;
                                var valorMenor = parseInt(NumCuotas) - 1;

                            if ($('#tipoPagoCapital').val() != "L" && $('#frecuenciaCap').val() != "P") {
                                if (nuevoNumCuotas > valorMayor) {
                                    $('#numAmortizacion').val(NumCuotas);
                                    mensajeSis("Sólo Una Cuota Más");
                                    $('#numAmortizacion').focus();
                                } else {
                                        if (nuevoNumCuotas < valorMenor) {
                                            $('#numAmortizacion').val(NumCuotas);
                                            mensajeSis("Sólo Una Cuota Menos");
                                            $('#numAmortizacion').focus();
                                        } else {
                                            if (nuevoNumCuotas <= valorMenor) {
                                                $('#error2').hide();
                                            } else {
                                                if ($('#tipoPagoCapital').val() == 'C' || $('#perIgual').val() == 'S') {
                                                    $('#numAmortInteres').val($('#numAmortizacion').val());

                                                }
                                                    consultaFechaVencimientoCuotas('numAmortizacion');

                                            }
                                        }
                                }

                            } else {

                            // valida q el numero de cuotas tecleado * periodicidad no superen el numero de dias del plazo
                                    if ($('#frecuenciaCap').val() == "P" || ($('#tipoPagoCapital').val() == "L" && $("#calendIrregularCheck").is(':checked') == false)) {
                                        var diasCalculados = parseInt(this.value) * parseInt($("#periodicidadCap").val());
                                        if(parseInt(diasCalculados) > parseInt($("#noDias").val())){
                                            mensajeSis("El Número de Cuotas es Incorrecto Para el Plazo y Frecuencia de Capital Indicados.");
                                            this.focus();
                                            this.select();
                                        }
                                    }

                                    if ($('#tipoPagoCapital').val() == 'C' || $('#perIgual').val() == 'S') {
                                        $('#numAmortInteres').val($('#numAmortizacion').val());
                                    }
                            }
                        }
                        else{
                            mensajeSis("Indique el Número de Cuotas.");
                            this.focus();
                        }
                    }
                });

                // valida que el numero de cuotas sólo se modifique +1 cuota, -1 cuota de la calculada
                $('#numAmortInteres').blur(function() {
                    if($("#frecuenciaInt").val() != ""){
                        if(parseInt(this.value) > 0){
                                var nuevoNumCuotas = $('#numAmortInteres').asNumber();
                                var valorMayor = parseInt(NumCuotasInt) + 1;
                                var valorMenor = parseInt(NumCuotasInt) - 1;

                                if ($('#tipoPagoCapital').val() != "L" && $('#frecuenciaInt').val() != "P") {
                                    if (nuevoNumCuotas > valorMayor) {
                                        $('#numAmortInteres').val(NumCuotasInt);
                                        mensajeSis("Sólo Una Cuota Más");
                                        $('#numAmortInteres').focus();
                                    } else {
                                            if (nuevoNumCuotas < valorMenor) {
                                                $('#numAmortInteres').val(NumCuotasInt);
                                                mensajeSis("Sólo Una Cuota Menos");
                                                $('#numAmortInteres').focus();
                                            } else {
                                                    if (nuevoNumCuotas <= valorMenor) {
                                                        $('#error2').hide();

                                                    } else {
                                                            if ($('#tipoPagoCapital').val() == 'C' || $('#perIgual').val() == 'S') {
                                                                $('#numAmortInteres').val($('#numAmortizacion').val());
                                                            }
                                                            consultaFechaVencimientoCuotas('numAmortizacion');
                                                    }

                                            }
                                        }

                                } else {

                                    // valida q el numero de cuotas tecleado * periodicidad no superen el numero de dias del plazo
                                        if ($('#frecuenciaInt').val() == "P" || ($('#tipoPagoCapital').val() == "L" && $("#calendIrregularCheck").is(':checked') == false)) {
                                            var diasCalculados = parseInt(this.value) * parseInt($("#periodicidadInt").val());
                                            if(parseInt(diasCalculados) > parseInt($("#noDias").val())){
                                                mensajeSis("El Número de Cuotas es Incorrecto Para el Plazo y Frecuencia de Interés Indicados.");
                                                this.focus();
                                                this.select();
                                            }
                                        }

                                        if ($('#tipoPagoCapital').val() == 'C' || $('#perIgual').val() == 'S') {
                                            $('#numAmortInteres').val($('#numAmortizacion').val());
                                        }
                                        //  consultaFechaVencimientoCuotas('numAmortizacion');
                                }
                            }
                            else{
                                mensajeSis("Indique el Número de Cuotas.");
                                this.focus();
                            }
                    }
                });



                $('#parentescoID').bind('keyup',function(e) {
                    if (this.value.length >= 2) {
                        lista('parentescoID', '2', '1','descripcion', $('#parentescoID').val(),'listaParentescos.htm');
                    }
                });

                $('#parentescoID').blur(function() {
                    consultaParentesco(this.id);
                });

                $('#tipoDispersion').blur(function() {
                    if ($('#tipoDispersion').val() == 'S') {
                        habilitaControl('cuentaCLABE');
                        $('#cuentaCLABE').focus();
                    }else {
                        deshabilitaControl('cuentaCLABE');
                        $('#cuentaCLABE').val('');
                        if($('#reqSeguroVidaNo').is(':checked')) {
                        $('#ajusFecExiVen1').focus();

                        }else{
                            if(modalidad == 'T'){
                            $('#tipPago').focus();
                            }else{
                                if(modalidad == 'U'){
                                    $('#beneficiario').focus();
                                 }

                            }
                        }

                        if(requiereSeg == 'N'){
                            if($('#tasaBase').is(':enabled')){
                                $('#tasaBase').focus();
                            } else {
                                $('#tipoPagoCapital').focus();
                            }
                        }
                    }
                });

                $('#cuentaCLABE').blur(
                        function() {
                            if ($('#cuentaCLABE').val() == ""
                                && $('#tipoDispersion').val() == 'S') {
                                mensajeSis("Cuenta CLABE requerida");
                                $('#tipoDispersion').focus();
                            } else {
                                // valida que los primeros tres digitos de
                                // la cuenta clabe correspondan con alguna
                                // institucion
                                validaSpei(this.id, this.id);
                            }
                        });


                $("#fechaInicioAmor").blur(function (){
                if(!$("#fechaInicioAmor").is('[readonly]')){
                    var dias;

                    if(this.value != ""){

                        if(esFechaValida(this.value)== true){
                            dias  =  restaFechas(parametroBean.fechaAplicacion, this.value);

                                if(parseInt(dias) < 0 ){
                                    mensajeSis("La Fecha de Inicio No debe ser Menor a la Fecha del Sistema.");
                                        this.value= parametroBean.fechaAplicacion ;
                                        $("#fechaInicio").val(this.value);
                                        this.focus();
                                }else{

                                    if(parseInt(dias) <= diasMaximo ){

                                        if(!$("#calendIrregularCheck").is(':checked')){ // Empiece a pagar en NO aplica para pagos de capital LIBRES
                                            consultaFechaVencimiento('plazoID');
                                            $("#fechaInicio").val(this.value);
                                        }

                                        else{

                                            if(this.value != parametroBean.fechaAplicacion){

                                                mensajeSis("La Fecha de Inicio de Primer Amortización \nNo Puede Ser Diferente a la Fecha Actual \nCuando el Calendario de Pagos es Irregular.");

                                                this.value= $("#fechaInicio").val();

                                                this.focus();

                                            }

                                        }

                                    }else{

                                        mensajeSis("La Fecha de Pago puede Iniciar en Máximo " + diasMaximo + " Días.");
                                        this.value= parametroBean.fechaAplicacion ;
                                        this.focus();
                                    }

                            }

                        }
                        else{
                            this.value= parametroBean.fechaAplicacion ;
                            this.focus();
                        }
                    }
                }
            });

                $("#fechaInicioAmor").change(function (){
                    this.focus();
                });


                //Eventos para tipo de pago del seguro de vida
                $('#tipoPagoSelect').hide();


                $('#tipPago')
                .change(
                        function() {
                             if($('#tipPago option:selected').text() == "ADELANTADO"){
                                 $('#forCobroSegVida').val("A");
                                 var formPagOtro =  "A";
                                 var esqSegVida = esquemaSeguro;
                                    consultaEsquemaSeguroVida(esqSegVida, formPagOtro);



                             }else{ if($('#tipPago option:selected').text() == "FINANCIAMIENTO"){
                                 $('#forCobroSegVida').val("F");
                                 var formPagOtro =  "F";
                                 var esqSegVida = esquemaSeguro;
                                    consultaEsquemaSeguroVida(esqSegVida, formPagOtro);


                                    }else{
                                         if($('#tipPago option:selected').text() == "DEDUCCION"){
                                             $('#forCobroSegVida').val("D");
                                             var formPagOtro =  "D";
                                             var esqSegVida = esquemaSeguro;
                                                consultaEsquemaSeguroVida(esqSegVida, formPagOtro);


                                    }else{
                                         if($('#tipPago option:selected').text() == "OTRO"){
                                             $('#forCobroSegVida').val("O");
                                             var formPagOtro = "O";
                                             var esqSegVida = esquemaSeguro;
                                                consultaEsquemaSeguroVida(esqSegVida, formPagOtro);
                                    }
                                }
                            }
                        }

                        consultaPorcentajeGarantiaLiquida('montoCredito');

                });



                $('#tipPago').blur(function() {
                esTab = true;
                    var reqseg = $('#reqSeguroVida').val();
                    calculoCostoSeguroTipoPago(reqseg);
                    consultaPorcentajeGarantiaLiquida('montoCredito');
                });



                // ------------ Validaciones de la Forma
                // -------------------------------------

                $('#formaGenerica').validate({
                    rules : {
                        clienteID : {
                            required : true
                        },
                        solicitudCreditoID: {
                            required : true
                        },
                        cuentaID : {
                            required : true
                        },
                        fechaInicio : {
                            required : true,
                            date : true
                        },
                        fechaVencimien : {
                            required : true,
                            date : true
                        },
                        montoCredito : {
                            required : true
                        },
                        plazoID : {
                            required : true,
                            numeroMayorCero : true
                        },
                        tipoPagoCapital : {
                            required : true

                        },
                        frecuenciaCap : {
                            required : true
                        },
                        producCreditoID : 'required',
                        destinoCreID : 'required',
                        tipoDispersion : 'required',
                        beneficiario : {
                            required : function() {
                                return $('#reqSeguroVidaSi').is(':checked');
                            }
                        },
                        direccionBen : {
                            required : function() {
                                return $('#reqSeguroVidaSi').is(':checked');
                            }
                        },
                        parentescoID : {
                            required : function() {
                                return $('#reqSeguroVidaSi').is(':checked');
                            }
                        },
                        tipPago :{
                            required: function() {
                                return $('#reqSeguroVidaSi').is(':checked') && modalidad == 'T';
                            }
                        },
                        tasaBase :{
                            required: function() {
                                return $('#tasaBase').is(':enabled');
                            }
                        },
                        sobreTasa :{
                            required: function() {
                                return $('#sobreTasa').is(':enabled');
                            }
                        },
                        referenciaPago : {
                            required: function(){
                                if (pagosXReferencia=='S') {
                                    return 0;
                                }else{
                                    return 1;
                                }
                            }
                        }
                    },
                    messages : {
                        clienteID : {
                            required : 'Especificar cliente'
                        },
                        solicitudCreditoID: {
                            required : 'Especificar la solicitud'
                        },
                        cuentaID : {
                            required : 'Especificar cuenta'
                        },
                        destinoCreID : 'Especifique Destino de Crédito.',
                        fechaInicio : {
                            required : 'Especificar Fecha',
                            date : 'Fecha Incorrecta'
                        },
                        producCreditoID : 'Especificar Producto de Crédito',
                        fechaVencimien : {
                            required : 'Especificar Fecha',
                            date : 'Fecha Incorrecta'
                        },
                        montoCredito : {
                            required : 'Especificar Monto'
                        },
                        plazoID : {
                            required : 'Especificar Plazo',
                            numeroMayorCero : 'Plazo esta vacio'
                        },
                        tipoPagoCapital : {
                            required : 'Especificar Tipo de Pago'
                        },
                        frecuenciaCap : {
                            required : 'Especificar Frecuencia'
                        },
                        tipoDispersion : 'Especifique Dispersión',
                        beneficiario : {
                            required : 'Especifique el Nombre del Beneficiario'
                        },
                        direccionBen : {
                            required : 'Especifique la Direccion del Beneficiario'
                        },
                        parentescoID : {
                            required : 'Especifique el Prospecto'
                        },
                        tipPago :{
                            required: 'Especifique el Tipo de Pago'
                        },
                        tasaBase :{
                            required: 'Especificar la Tasa Base.'

                        },
                        sobreTasa :{
                            required: 'Especificar la Sobre Tasa.'

                        },
                        referenciaPago :{
                            required: 'Especificar la Referencia de Pago para Crédito'
                        }
                    }
                });

                $('#formaGenerica2').validate({
                    rules : {
                        porcentaje : 'required'
                    },
                    messages : {
                        porcentaje : 'Especifique Concepto'
                    }

                });

                // ------------ Validaciones de Controles
                // -------------------------------------


                function validaMonitorSolicitud() {
                    // seccion para validar si la pantalla fue llamada desde la pantalla de Monitor de Solicitud
                    if ($('#monitorSolicitud').val() != undefined) { //Valida el valor del campo en la pantalla
                        var solicitud = $('#numSolicitud').val();
                        $('#creditoID').val('0');
                        var sol = "solicitudCreditoID";
                        $('#solicitudCreditoID').val(solicitud);
                        $('#divComentarios').show();
                        consultaSolicitudCred(sol);
                        $('#solicitudCreditoID').focus();
                    }
                }



                function validaCredito(control) {
                    var Comercial = 'C';
                    var Consumo = 'O';
                    inicializaCombos();
                    var numCredito = $('#creditoID').val();
                    MontoMaxCre = 0;
                    MontoMinCre = 0;
                    tipoPrepCre="";
                    setTimeout("$('#cajaLista').hide();", 200);
                    if (numCredito != '' && $('#creditoID').asNumber() != 0 && !isNaN(numCredito) && esTab) {
                        // ingreso por cero (cuando es un credito nuevo)
                        if ($('#creditoID').asNumber() == '0') {
                            habilitaControl('solicitudCreditoID');
                            $('#clienteInstitucion').val(parametroBean.clienteInstitucion);
                            $('#cuentaInstitucion').val(parametroBean.cuentaInstitucion);
                             
                              habilitaBoton('agrega', 'submit');
                              
                            $('#contenedorFondeo').hide();
                            deshabilitaBoton('modifica', 'submit');
                            inicializaValores();
                            consultaParametros();
                            $('#monedaID').val('1');
                            $('#contenedorSimulador').html("");
                            $('#contenedorSimulador').hide();
                            $('#cicloCliente').val('');
                            $('#tipoPagoSeguro').val('');
                            consultaSICParam();
                            
                            
                        } else {
                            // consulta del credito
                            deshabilitaBoton('agrega', 'submit');

                             habilitaBoton('modifica', 'submit');
                              
                            
                            var creditoBeanCon = {
                                    'creditoID' : $('#creditoID').val()
                            };
                            creditosServicio.consulta(catTipoConsultaCredito.principal,creditoBeanCon, { async: false, callback: function(credito) {
                                if (credito != null) {
                                	listaPersBloqBean = consultaListaPersBloq(credito.clienteID, esCliente, 0, 0);
            						consultaSPL = consultaPermiteOperaSPL(credito.clienteID,'LPB',esCliente);
            						if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
                                    $('#institucionNominaID').val(credito.institucionNominaID);
                                    $('#convenioNominaID').val(credito.convenioNominaID);
                                    $('#folioSolici').val(credito.folioSolici);
                                    $('#quinquenioID').val(credito.quinquenioID);
                                    $('#clabeDomiciliacion').val(credito.clabeDomiciliacion);

                                    agregaFormatoControles('formaGenerica');
                                    dwr.util.setValues(credito);
                                    montoinicial = $("#montoCredito").asNumber();
                                    montoFinal = $("#montoCredito").asNumber();
                                    $('#aporteCliente').val(credito.aporteCliente);
                                    $('#montoFOGAFI').val(credito.montoFOGAFI);

                                    consultaMontoCredGarFinanciada(credito.creditoID)

                                    if(cobraGarantiaFinanciada == 'S'){
                                        $('#garantiaFinanciada').show();
                                    }
                                    else{
                                        $('#garantiaFinanciada').hide();
                                    }
                                    $('#diaMesCapital').val(credito.diaMesCapital);
                                    $('#producCreditoID').val(credito.producCreditoID);
                                    $('#montoSeguroVida').val(credito.montoSeguroVida);
                                    tipoPrepCre=credito.tipoPrepago;
                                    tipoPagoSeg = credito.forCobroSegVida; //tipo de pago del monto de seguro de vida
                                    var esReacreditado = credito.esReacreditado;


                                    if(credito.tipoCredito == var_TipoCredito.NUEVO){
                                        $("#tipoCredito").val(var_TipoCredito.NUEVO);
                                        $("#tipoCreditoDes").val(var_TipoCredito.NUEVODES);

                                    }

                                    if((credito.tipoCredito == var_TipoCredito.RENOVACION) && esReacreditado == "N"){
                                        $("#tipoCredito").val(var_TipoCredito.RENOVACION);
                                        $("#tipoCreditoDes").val(var_TipoCredito.RENOVACIONDES);
                                    }

                                    if((credito.tipoCredito == var_TipoCredito.RENOVACION) && esReacreditado == "S"){
                                        $("#tipoCredito").val(var_TipoCredito.RENOVACION);
                                        $("#tipoCreditoDes").val(var_TipoCredito.REACREDITAMIENTODES);
                                    }

                                    if(credito.tipoCredito == var_TipoCredito.REESTRUCTURA){
                                        $("#tipoCredito").val(var_TipoCredito.REESTRUCTURA);
                                        $("#tipoCreditoDes").val(var_TipoCredito.REESTRUCTURADES);
                                    }

                                    //validaciones para consultaSIC
                                    if (credito.tipoConsultaSIC != "" && credito.tipoConsultaSIC != null) {
                                        $('#comentariosEjecutivo').show();
                                        if (credito.tipoConsultaSIC == "BC") {
                                            $('#tipoConsultaSICBuro').attr("checked",true);
                                            $('#tipoConsultaSICCirculo').attr("checked",false);
                                            $('#consultaBuro').show();
                                            $('#consultaCirculo').hide();
                                            $('#folioConsultaCC').val('');
                                        }else if (credito.tipoConsultaSIC == "CC") {
                                            $('#tipoConsultaSICBuro').attr("checked",false);
                                            $('#tipoConsultaSICCirculo').attr("checked",true);
                                            $('#consultaBuro').hide();
                                            $('#consultaCirculo').show();
                                            $('#folioConsultaBC').val('');
                                        }
                                    } else {
                                        //mostrar por defecto valor de parametrossis
                                        consultaSICParam();
                                    }

                                    if(credito.calcInteresID == '2' || credito.calcInteresID == '3' || credito.calcInteresID == '4'){
                                        consultaTasaBase('tasaBase',false);
                                    }
                                    setCalcInteresID(credito.calcInteresID);
                                    consultaProducCreditoForanea( credito.producCreditoID,'no');
                                    if(cobraAccesoriosGen == 'N'){
                                        muestraGridAccesorios();
                                    }


                                    esTab = true;
                                    $('#tasaFija').val(credito.tasaFija).change();

                                    consultaTasa = 'N';
                                    consultaCliente('clienteID',consultaTasa);
                                    asignaInstFondeoID('institFondeoID',credito.institFondeoID);
                                    consultaLineaCredito('lineaCreditoID');
                                    ValidaCalcInteres('calcInteresID');
                                    $('#solicitudCreditoID').val(credito.solicitudCreditoID);
                                    $('#cuentaID').val(credito.cuentaID);
                                    consultaCta('cuentaID');
                                    consultaBeneficiario('creditoID'); // CONSULTA BENEFICIARIO DEL CREDITO
                                    if (credito.tasaBase != 0) {
                                        consultaTasaBase('tasaBase',false);
                                    }

                                    if (credito.fechaInhabil == 'S') {
                                        $('#fechaInhabil1').attr("checked","1");
                                        $('#fechaInhabil2').attr("checked",false);
                                        $('#fechaInhabil').val("S");
                                    } else {
                                        $('#fechaInhabil2').attr("checked","1");
                                        $('#fechaInhabil1').attr("checked",false);
                                        $('#fechaInhabil').val("A");
                                    }

                                    if (credito.ajusFecExiVen == 'S') {
                                        $('#ajusFecExiVen1').attr("checked","1");
                                        $('#ajusFecExiVen2').attr("checked",false);
                                        $('#ajusFecExiVen').val("S");
                                    } else {
                                        $('#ajusFecExiVen1').attr("checked",false);
                                        $('#ajusFecExiVen2').attr("checked","1");
                                        $('#ajusFecExiVen').val("N");
                                    }
                                    if (credito.calendIrregular == 'S') {
                                        $('#calendIrregularCheck').attr("checked","1");
                                        $('#calendIrregular').val("S");
                                        deshabilitaControl('tipoPagoCapital');
                                        deshabilitaControl('frecuenciaInt');
                                        deshabilitaControl('frecuenciaCap');
                                        deshabilitaControl('numAmortInteres');
                                        deshabilitaControl('numAmortizacion');

                                    } else {
                                        $('#calendIrregularCheck').attr("checked",false);
                                        $('#calendIrregular').val("N");
                                        if(credito.tipoPagoCapital == 'C' || $('#perIgual').val() == 'S' ) {
                                            deshabilitaControl('numAmortInteres');
                                        }else{
                                            habilitaControl('numAmortInteres');
                                        }
                                    }

                                    if (credito.ajusFecUlVenAmo == 'S') {
                                        $('#ajusFecUlVenAmo1').attr("checked","1");
                                        $('#ajusFecUlVenAmo2').attr("checked",false);
                                        $('#ajusFecUlVenAmo').val("S");
                                    } else {
                                        $('#ajusFecUlVenAmo1').attr("checked",false);
                                        $('#ajusFecUlVenAmo2').attr("checked","1");
                                        $('#ajusFecUlVenAmo').val("N");
                                    }

                                    // Si no es Quincenal.
                                    if(credito.frecuenciaInt != frecuenciaQuincenal){
                                        textoDiaPago = 'Día del Mes';
                                        if (credito.diaPagoInteres == 'F') {
                                            $('#diaPagoInteres1').attr("checked","1");
                                            $('#diaPagoInteres2').attr("checked",false);
                                        } else {
                                            $('#diaPagoInteres2').attr("checked","1");
                                            $('#diaPagoInteres1').attr("checked",false);
                                            $('#diaMesInteres').val(credito.diaMesInteres);
                                        }
                                        $('#divDiaPagoIntMes').show();
                                        $('#divDiaPagoIntQuinc').hide();
                                    } else {// Si es Quincenal.
                                        textoDiaPago = 'Día de Pago';
                                        if (credito.diaPagoInteres == 'D') {
                                            $('#diaPagoInteresD').attr('checked',true);
                                            $('#diaPagoInteresQ').attr('checked',false);
                                            $('#diaDosQuincInt').val(Number(credito.diaMesInteres) + 15);
                                            $('#diaDosQuincInt').show();
                                        } else {
                                            $('#diaPagoInteresD').attr('checked',false);
                                            $('#diaPagoInteresQ').attr('checked',true);
                                            $('#diaDosQuincInt').val('0');
                                            $('#diaDosQuincInt').hide();
                                        }
                                        $('#divDiaPagoIntMes').hide();
                                        $('#divDiaPagoIntQuinc').show();
                                    }
                                    $('#diaPagoInteres').val(credito.diaPagoInteres);
                                    $('#labelDiaInteres').text(textoDiaPago+': ');

                                    // Si no es Quincenal.
                                    if(credito.frecuenciaCap != frecuenciaQuincenal){
                                        textoDiaPago = 'Día del Mes';
                                        if (credito.diaPagoCapital == 'F') {
                                            $('#diaPagoCapital1').attr("checked","1");
                                            $('#diaPagoCapital2').attr("checked",false);
                                        }else {
                                            $('#diaPagoCapital2').attr("checked","1");
                                            $('#diaPagoCapital1').attr("checked",false);
                                            $('#diaMesCapital').val(credito.diaMesCapital);
                                        }
                                        $('#divDiaPagoCapMes').show();
                                        $('#divDiaPagoCapQuinc').hide();
                                    } else {// Si es Quincenal.
                                        textoDiaPago = 'Día de Pago';
                                        if (credito.diaPagoCapital == 'D') {
                                            $('#diaPagoCapitalD').attr('checked',true);
                                            $('#diaPagoCapitalQ').attr('checked',false);
                                            $('#diaDosQuincCap').val(Number(credito.diaMesCapital) + 15);
                                            $('#diaDosQuincCap').show();
                                        } else {
                                            $('#diaPagoCapitalQ').attr('checked',true);
                                            $('#diaPagoCapitalD').attr('checked',false);
                                            $('#diaDosQuincCap').val('0');
                                            $('#diaDosQuincCap').hide();
                                        }
                                        $('#divDiaPagoCapMes').hide();
                                        $('#divDiaPagoCapQuinc').show();
                                    }
                                    $('#diaPagoCapital').val(credito.diaPagoCapital);
                                    $('#diaPagoProd').val(credito.diaPagoProd);
                                    $('#labelDiaCapital').text(textoDiaPago+': ');

                                    asignaTipoFondeo(credito.tipoFondeo);
                                    consultaLineaFondeo('lineaFondeo');
                                    $('#producCreditoID').val(credito.producCreditoID);
                                    deshabilitaBoton('agrega','submit');
                                    
                                     habilitaBoton('modifica', 'submit');
                                      
                                    var solicitud = $('#solicitudCreditoID').val();
                                    var status = credito.estatus;
                                    if(status == 'I' || status == 'A'){
                                        habilitaControl('cuentaCLABE');
                                    }

                                    if (status != 'I') {
                                        $('#simular').hide();
                                        deshabilitaControl('solicitudCreditoID');
                                        deshabilitaBoton('modifica');
                                        deshabilitaBoton('agrega');
                                        deshabilitaControlesNoInactivo();
                                        validaTipoPago("N");
                                    } else {
                                        if (status == 'I' && solicitud == 0) {
                                            habilitaBoton('modifica');
                                            deshabilitaBoton('agrega');
                                            habilitaControlesDarAlta();
                                            validaTipoPago("S");
                                            habilitaControl('calendIrregularCheck');
                                            habilitaControl('cuentaCLABE');
                                        }
                                        if (status == 'I' && solicitud != 0) {
                                            habilitaBoton('modifica');
                                            deshabilitaBoton('agrega');
                                            deshabilitaControlesNoInactivo();
                                            validaTipoPago("N");
                                            deshabilitaControl('calendIrregularCheck');
                                            habilitaControl('cuentaCLABE');
                                        }

                                    }

                                    MontoIni = credito.montoCredito;
                                    consultaDestinoCreditoSolicitud('destinoCreID');
                                    if(credito.flujoOrigen == "C"){
                                        credito.tipoDispersion = "E";
                                    }
                                    consultaCalendarioPorProductoCredito(credito.producCreditoID,credito.tipoPagoCapital,credito.frecuenciaCap,
                                            credito.frecuenciaInt,credito.plazoID,credito.tipoDispersion);


                                    NumCuotasInt = credito.numAmortInteres; // asigna el valor de numero de cuotas de interes
                                    $('#cat').formatCurrency({
                                        positiveFormat : '%n',
                                        roundToDecimalPlace : 1
                                    });

                                    $('#numTransacSim').val(credito.numTransacSim);
                                    $('#numAmortizacion').val(credito.numAmortizacion);
                                    $('#numAmortInteres').val(credito.numAmortInteres);

                                    // campo de Clasificacion del Destino
                                    $('#clasiDestinCred').val(credito.clasiDestinCred);
                                    if (credito.clasiDestinCred == Comercial) {
                                        $('#clasificacionDestin1').attr("checked",true);
                                        $('#clasificacionDestin2').attr("checked",false);
                                        $('#clasificacionDestin3').attr("checked",false);

                                    } else if (credito.clasiDestinCred == Consumo) {
                                        $('#clasificacionDestin1').attr("checked",false);
                                        $('#clasificacionDestin2').attr("checked",true);
                                        $('#clasificacionDestin3').attr("checked",false);

                                    } else {
                                        $('#clasificacionDestin1').attr("checked",false);
                                        $('#clasificacionDestin2').attr("checked",false);
                                        $('#clasificacionDestin3').attr("checked",true);
                                    }


                                    if (credito.forCobroSegVida == 'F') {
                                        $('#tipoPagoSeguro').val("FINANCIAMIENTO");

                                    } else {
                                        if (credito.forCobroSegVida == 'D') {
                                            $(
                                            '#tipoPagoSeguro')
                                            .val(
                                                    "DEDUCCION");
                                        } else {
                                            if (credito.forCobroSegVida == 'A') {
                                                $(
                                                '#tipoPagoSeguro')
                                                .val(
                                                        "ADELANTADO");
                                            }
                                        }
                                    }

                                    if(modalidad = 'T'){
                                    consultaTiposPago(credito.productoCreditoID,esquemaSeguro, credito.forCobroSegVida);
                                    consultaEsquemaSeguroVidaForanea(credito.productoCreditoID, credito.forCobroSegVida);

                                    }

                                //Termina forma de cobro de seguro de vida


                                    if(credito.forCobroSegVida == 'F'){
                                        montoinicial = parseFloat(montoinicial) - parseFloat(credito.montoSeguroVida);
                                    }
                                    if(credito.forCobroComAper == 'F'){
                                        montoinicial = parseFloat(montoinicial) - parseFloat(credito.montoComision);
                                        montoinicial = parseFloat(montoinicial) - parseFloat(credito.IVAComApertura);
                                    }


                                    agregaFormatoControles('formaGenerica');
                                }else{
                                	mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
                                	 deshabilitaBoton('modifica','submit');
                                     deshabilitaBoton('agrega','submit');
                                     $('#creditoID').focus();
                                     $('#creditoID').val("");
                                     tab2 = false;
                                     montoinicial = 0;
                                }
                                } else {
                                    mensajeSis("No Existe el Credito");
                                    deshabilitaBoton('modifica','submit');
                                    deshabilitaBoton('agrega','submit');
                                    $('#creditoID').focus();
                                    $('#creditoID').val("");
                                    tab2 = false;
                                    montoinicial = 0;
                                }
                            }});
                        }
                    }
                }

                /* consulta de cliente se ejecuta solo cuando pierde el foco el campo cliente y en la consulta del credito*/
                function consultaCliente(idControl,     consultarTasaCredito ) {
                    var jqCliente = eval("'#" + idControl + "'");
                    var numCliente = $(jqCliente).val();

                    var tipConPrincipal = 1;
                    setTimeout("$('#cajaLista').hide();", 200);

                    if (numCliente != '' && !isNaN(numCliente) && numCliente != '0') {
                        clienteServicio.consulta(tipConPrincipal,numCliente,function(cliente) {
                            if (cliente != null) {
                            	
                                $('#clienteID').val(cliente.numero);
                                $('#nombreCliente').val(cliente.nombreCompleto);
                                $('#pagaIVACte').val(cliente.pagaIVA);
                                $('#sucursalCte').val(cliente.sucursalOrigen);
                                consultacicloCliente();
                                $('#calificaCliente').val(cliente.calificaCredito);

                                if(cliente.calificaCredito=='N'){
                                    $('#calificaCredito').val('NO ASIGNADA');
                                }
                                if(cliente.calificaCredito=='A'){
                                    $('#calificaCredito').val('EXCELENTE');
                                }
                                if(cliente.calificaCredito=='C'){
                                    $('#calificaCredito').val('REGULAR');
                                }
                                if(cliente.calificaCredito=='B'){
                                    $('#calificaCredito').val('BUENA');
                                }

                                // Consultamos la tasa si ya tenemos los datos necesarios
                                if($('#clienteID').asNumber() >0 && $('#producCreditoID').asNumber() >0
                                        && $('#calificaCliente').val() != '' && $('#montoCredito').asNumber() > 0
                                        && ($('#cicloCliente').asNumber() > 0 || $('#cicloClienteGrupal').asNumber() > 0)
                                        && consultarTasaCredito == 'S'){


                                    esTab =true;
                                    consultaTasaCredito($('#montoCredito').asNumber());
                                }
                                if($('#creditoID').val()==''||$('#creditoID').val()=='0'){
                                    if (cliente.estatus=="I"){
                                        deshabilitaBoton('agrega','submit');
                                        deshabilitaBoton('modifica','submit');
                                        mensajeSis("El Cliente se encuentra Inactivo");
                                        $('#calificaCredito').val('');
                                        $('#cuentaID').val('');
                                        $('#clienteID').focus();
                                        $('#clienteID').val('');
                                        $('#nombreCliente').val('');
                                    }
                                }else{
                                    if (cliente.estatus=="I"){
                                        deshabilitaBoton('agrega','submit');
                                        deshabilitaBoton('modifica','submit');
                                        mensajeSis("El Cliente se encuentra Inactivo");

                                    }
                                }
                            
                            } else {

                                mensajeSis("Cliente No Válido");
                                $('#clienteID').focus();
                                $('#clienteID').select();
                            }
                        });
                    } else {
                        mensajeSis("Cliente No Válido");
                        $('#clienteID').focus();
                        $('#clienteID').select();
                    }
                }


                // valida calculo de interes
                function ValidaCalcInteres(idControl) {
                    validaTipoPago();
                    var jqCalc = eval("'#" + idControl + "'");
                    var numCalc = $(jqCalc).val();
                    habilitaCamposTasa(numCalc);
                }

                // --- FUNCIONES PARA SECCION DE CALENDARIO DE PAGOS funcion para cambiar los controles dependiendo de el tipo de pago de capital seleccionado
                function validaTipoPago() {

                    switch ($('#tipoPagoCapital').val()) {
                        // si el tipo de pago de capital es CRECIENTES
                        case "C":
                                deshabilitarCalendarioPagosInteres();
                                igualarCalendarioInteresCapital();

                            break;
                        // si el tipo de pago de capital es IGUALES
                        case "I":
                                if ($('#perIgual').val() == 'S') {
                                    // se llama funcion para igualar calendarios
                                    igualarCalendarioInteresCapital();
                                    deshabilitarCalendarioPagosInteres();

                                }else{
                                    habilitarCalendarioPagosInteres();
                                }
                            break;

                        // si el tipo de pago de capital es LIBRES
                        case "L":
                                if ($('#perIgual').val() == 'S') {
                                    // se llama funcion para igualar calendarios
                                    igualarCalendarioInteresCapital();
                                    deshabilitarCalendarioPagosInteres();

                                }else{
                                    habilitarCalendarioPagosInteres();
                                }

                            break;

                        default:
                                habilitarCalendarioPagosInteres();
                                igualarCalendarioInteresCapital();
                        break;
                    }
                }


                /*FUNCION PARA IGUALAR CALENDARIO EN PAGOS CRECIENTES O QUE PERMITEN IGUALDAD.*/
                function igualarCalendarioInteresCapital() {
                    if ($('#perIgual').val() == 'S') {
                        deshabilitaControl('frecuenciaInt');
                        deshabilitaControl('numAmortInteres');
                        deshabilitaControl('diaMesInteres');
                        deshabilitaControl('diaPagoInteres1');
                        deshabilitaControl('diaPagoInteres2');
                        $('#frecuenciaInt').val($('#frecuenciaCap').val()).selected = true;
                        $('#numAmortInteres').val($('#numAmortizacion').val());
                        $('#periodicidadInt').val($('#periodicidadCap').val());
                        $('#diaMesInteres').val($('#diaMesCapital').val());

                        if ($('#diaPagoCapital1').is(':checked')) {
                            $('#diaPagoInteres2').attr('checked', false);
                            $('#diaPagoInteres1').attr('checked', true);
                            $('#diaPagoInteres').val("F");
                        } else {
                                if ($('#diaPagoCapital2').is(':checked')) {
                                    $('#diaPagoInteres1').attr('checked', false);
                                    $('#diaPagoInteres2').attr('checked', true);
                                    $('#diaPagoInteres').val("D");
                                }
                        }
                    }


                }



                // funcion para eventos cuando se selecciona dia de pago de interes por aniversario o fin de mes, dependiendo de la frecuencia.
                function validarEventoFrecuencia() {

                    switch ($('#tipoPagoCapital').val()) {
                        // si el tipo de pago de capital es CRECIENTES
                        case "C":
                                habilitaControl('numAmortizacion');
                                deshabilitaControl('periodicidadCap');

                                if ($('#frecuenciaCap').val() == 'S' || $('#frecuenciaCap').val() == 'C' || $('#frecuenciaCap').val() == 'Q'
                                    || $('#frecuenciaCap').val() == 'A') {
                                    if ($('#diaPagoCapital1').is(':checked')) {
                                        $('#diaPagoCapital1').attr("checked", true);
                                        $('#diaPagoCapital2').attr("checked", false);
                                        $('#diaMesCapital').val('');
                                    } else {
                                            $('#diaPagoCapital2').attr("checked", true);
                                            $('#diaPagoCapital1').attr("checked", false);
                                            $('#diaMesCapital').val(diaSucursal);
                                    }
                                } else {
                                        if ($('#frecuenciaCap').val() == 'P') {
                                            if ($('#diaPagoCapital1').is(':checked')) {
                                                $('#diaPagoCapital1').attr("checked",true);
                                                $('#diaPagoCapital2').attr("checked",false);
                                                $('#diaMesCapital').val('');
                                            } else {
                                                $('#diaPagoCapital2').attr("checked",true);
                                                $('#diaPagoCapital1').attr("checked",false);
                                                $('#diaMesCapital').val(diaSucursal);
                                            }

                                            habilitaControl('periodicidadCap');

                                        } else {
                                            // si el tipo de pago es UNICO se  deshabilitan las cajas para indicar numero de cuotas
                                            if ($('#frecuenciaCap').val() == 'U') {
                                                deshabilitaControl('numAmortizacion');
                                                $('#numAmortizacion').val("1");
                                                mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
                                                $('#frecuenciaCap').focus();
                                                $('#periodicidadCap').val($('#noDias').val());

                                                if ($('#diaPagoCapital1').is(':checked')) {
                                                    $('#diaPagoCapital1').attr("checked",true);
                                                    $('#diaPagoCapital2').attr("checked", false);
                                                    $('#diaMesCapital').val("");
                                                } else {
                                                    if ($('#diaPagoCapital2').is(':checked')) {
                                                        $('#diaPagoCapital2').attr("checked",true);
                                                        $('#diaPagoCapital1').attr("checked", false);
                                                        $('#diaMesCapital').val(diaSucursal);
                                                    }
                                            }

                                        } else {
                                            if ($('#diaPagoCapital1').is(':checked')) {
                                                $('#diaPagoCapital1').attr("checked",true);
                                                $('#diaPagoCapital2').attr("checked", false);
                                                $('#diaMesCapital').val("");

                                            } else {

                                                if ($('#diaPagoCapital2').is(':checked')) {
                                                    $('#diaPagoCapital2').attr("checked",true);
                                                    $('#diaPagoCapital1').attr("checked", false);
                                                    $('#diaMesCapital').val(diaSucursal);

                                                }
                                            }
                                        }
                                    }
                                }


                                // se llama funcion para igualar calendarios
                                igualarCalendarioInteresCapital();
                                deshabilitarCalendarioPagosInteres();

                            break;



                        // si el tipo de pago de capital es IGUALES
                        case "I":
                                habilitaControl('numAmortizacion');
                                deshabilitaControl('periodicidadCap');

                                if ($('#frecuenciaCap').val() == 'S' || $('#frecuenciaCap').val() == 'C' || $('#frecuenciaCap').val() == 'Q'
                                     || $('#frecuenciaCap').val() == 'A') {
                                        if ($('#diaPagoCapital1').is(':checked')) {
                                            $('#diaPagoCapital1').attr("checked", true);
                                            $('#diaPagoCapital2').attr("checked", false);
                                            $('#diaMesCapital').val('');
                                        } else {
                                            $('#diaPagoCapital2').attr("checked", true);
                                            $('#diaPagoCapital1').attr("checked", false);
                                            $('#diaMesCapital').val(diaSucursal);
                                        }
                                } else {
                                        if ($('#frecuenciaCap').val() == 'P') {
                                            if ($('#diaPagoCapital1').is(':checked')) {
                                                $('#diaPagoCapital1').attr("checked",true);
                                                $('#diaPagoCapital2').attr("checked",false);
                                                $('#diaMesCapital').val('');
                                            } else {
                                                $('#diaPagoCapital2').attr("checked",true);
                                                $('#diaPagoCapital1').attr("checked",false);
                                                $('#diaMesCapital').val(diaSucursal);
                                            }
                                            habilitaControl('periodicidadCap');
                                        } else {
                                            if ($('#frecuenciaCap').val() == 'U') {
                                                deshabilitaControl('numAmortizacion');
                                                $('#numAmortizacion').val("1");
                                                $('#periodicidadCap').val($('#noDias').val());


                                                if ($('#diaPagoCapital1').is(':checked')) {
                                                    $('#diaPagoCapital1').attr("checked",true);
                                                    $('#diaPagoCapital2').attr("checked", false);
                                                    $('#diaMesCapital').val("");

                                                } else {

                                                        if ($('#diaPagoCapital2').is(':checked')) {
                                                            $('#diaPagoCapital2').attr("checked",true);
                                                            $('#diaPagoCapital1').attr("checked", false);
                                                            $('#diaMesCapital').val(diaSucursal);

                                                        }

                                                }

                                            } else {

                                                    if ($('#diaPagoCapital1').is(':checked')) {
                                                        $('#diaPagoCapital1').attr("checked",true);
                                                        $('#diaPagoCapital2').attr("checked", false);
                                                        $('#diaMesCapital').val('');

                                                    } else {
                                                            if ($('#diaPagoCapital2').is(':checked')) {
                                                                $('#diaPagoCapital2').attr("checked",true);
                                                                $('#diaPagoCapital1').attr("checked", false);
                                                                $('#diaMesCapital').val(diaSucursal);
                                                            }
                                                    }
                                            }
                                        }
                                    }





                                // Verifica el producto iguala el calendario de interes al de capital
                                if ($('#perIgual').val() != 'S') {
                                    habilitarCalendarioPagosInteres();
                                    if ($('#frecuenciaInt').val() == 'S' || $('#frecuenciaInt').val() == 'C' || $('#frecuenciaInt').val() == 'Q'
                                        || $('#frecuenciaInt').val() == 'A' || $('#frecuenciaInt').val() == 'D') {

                                        deshabilitaControl('periodicidadInt');
                                        habilitaControl('numAmortInteres');

                                    } else {

                                        if ($('#frecuenciaInt').val() == 'P') {
                                            if ($('#diaPagoInteres1').is(':checked')) {
                                                $('#diaPagoInteres1').attr("checked",true);
                                                $('#diaPagoInteres2').attr("checked",false);
                                                $('#diaMesInteres').val(diaSucursal);

                                            } else {
                                                    $('#diaPagoInteres1').attr("checked",true);
                                                    $('#diaPagoInteres2').attr("checked",false);
                                                    $('#diaMesInteres').val('');
                                            }
                                            habilitaControl('periodicidadInt');
                                            habilitaControl('numAmortInteres');

                                        } else {

                                                if ($('#frecuenciaInt').val() == 'U') {
                                                    $('#numAmortInteres').val("1");
                                                    deshabilitaControl('numAmortInteres');
                                                    deshabilitaControl('periodicidadInt');
                                                    $('#periodicidadInt').val($('#noDias').val());


                                                    if ($('#diaPagoInteres1').is(':checked')) {
                                                        $('#diaPagoInteres1').attr("checked",true);
                                                        $('#diaPagoInteres2').attr("checked", false);
                                                        $('#diaMesInteres').val("");
                                                    } else {

                                                            if ($('#diaPagoInteres2').is(':checked')) {
                                                                $('#diaPagoInteres2').attr("checked",true);
                                                                $('#diaPagoInteres1').attr("checked", false);
                                                                $('#diaMesInteres').val(diaSucursal);
                                                            }
                                                    }


                                                }else{
                                                        habilitaControl('numAmortInteres');
                                                        if ($('#diaPagoInteres1').is(':checked')) {
                                                            $('#diaPagoInteres1').attr("checked",true);
                                                            $('#diaPagoInteres2').attr("checked",false);
                                                            $('#diaPagoInteres').val('F');
                                                            $('#diaMesInteres').val("");

                                                        } else {

                                                                if ($('#diaPagoInteres2').is(':checked')) {
                                                                    $('#diaPagoInteres1').attr("checked",false);
                                                                    $('#diaPagoInteres2').attr("checked",true);
                                                                    $('#diaPagoInteres').val('D');
                                                                    $('#diaMesInteres').val(diaSucursal);

                                                                }
                                                        }
                                                }
                                        }
                                    }


                                    // solo si el producto de credito indica que el dia de pago es Indistinto

                                    if($('#diaPagoProd').val() == 'I' && $('#diaPagoInteres2').is(':checked')){

                                        habilitaControl('diaMesInteres');

                                        habilitaControl('diaPagoInteres1');

                                        habilitaControl('diaPagoInteres2');
                                    }
                                    // solo si el producto de credito indica que el dia de pago es Dia del mes

                                    if($('#diaPagoProd').val() == 'D'){
                                        habilitaControl('diaMesInteres');
                                    }

                                    }
                                    else { // SI IGUALA CALENDARIOS (Interes con Capital)
                                        igualarCalendarioInteresCapital();
                                        deshabilitarCalendarioPagosInteres();
                                    }
                            break;



                        // si el tipo de pago de capital es LIBRES
                        case "L":
                                habilitaControl('numAmortizacion');
                                deshabilitaControl('periodicidadCap');

                                if ($('#frecuenciaCap').val() == 'S' || $('#frecuenciaCap').val() == 'C' || $('#frecuenciaCap').val() == 'Q'
                                     || $('#frecuenciaCap').val() == 'A') {

                                    if ($('#diaPagoCapital1').is(':checked')) {
                                        $('#diaPagoCapital1').attr("checked", true);
                                        $('#diaPagoCapital2').attr("checked", false);
                                        $('#diaMesCapital').val('');

                                    } else {
                                        $('#diaPagoInteres2').attr('checked', true);
                                        $('#diaPagoCapital2').attr("checked", true);
                                        $('#diaPagoCapital1').attr("checked", false);
                                        $('#diaMesCapital').val(diaSucursal);
                                            }
                                } else {

                                    if ($('#frecuenciaCap').val() == 'P') {
                                        if ($('#diaPagoCapital1').is(':checked')) {
                                            $('#diaPagoCapital1').attr("checked",true);
                                            $('#diaPagoCapital2').attr("checked",false);
                                            $('#diaMesCapital').val('');
                                        } else {
                                            $('#diaPagoCapital2').attr("checked",true);
                                            $('#diaPagoCapital1').attr("checked",false);
                                            $('#diaMesCapital').val(diaSucursal);
                                        }
                                        habilitaControl('periodicidadCap');

                                    } else {

                                    if ($('#frecuenciaCap').val() == 'U') {
                                        $('#numAmortizacion').val("1");
                                        deshabilitaControl('numAmortizacion');
                                        deshabilitaControl('periodicidadInt');
                                        $('#periodicidadCap').val($('#noDias').val());

                                        if ($('#diaPagoCapital1').is(':checked')) {
                                            $('#diaPagoCapital1').attr("checked",true);
                                            $('#diaPagoCapital2').attr("checked", false);
                                            $('#diaMesCapital').val("");

                                        } else {
                                                if ($('#diaPagoCapital2').is(':checked')) {
                                                    $('#diaPagoCapital2').attr("checked",true);
                                                    $('#diaPagoCapital1').attr("checked", false);
                                                    $('#diaMesCapital').val(diaSucursal);
                                                }
                                        }


                                    } else {
                                        if($('#frecuenciaCap').val() == 'D'){
                                            mensajeSis("No se permiten Frecuencias Decenales con pagos de Capital Libres");
                                            $('#frecuenciaInt').val('S');
                                            $('#frecuenciaCap').val('S');
                                            return false;
                                        }else{
                                            if ($('#diaPagoCapital1').is(':checked')) {
                                                    $('#diaPagoCapital1').attr("checked",true);
                                                    $('#diaPagoCapital2').attr("checked", false);
                                                    $('#diaMesCapital').val('');
                                                } else {
                                                        if ($('#diaPagoCapital2').is(':checked')) {
                                                            $('#diaPagoCapital2').attr("checked",true);
                                                            $('#diaPagoCapital1').attr("checked", false);
                                                            $('#diaMesCapital').val(diaSucursal);
                                                        }
                                                }
                                        }

                                    }
                                }
                        }




                                // Verifica el producto iguala el calendario de interes al de capital
                                if ($('#perIgual').val() != 'S') {
                                    habilitarCalendarioPagosInteres();
                                    if ($('#frecuenciaInt').val() == 'S' || $('#frecuenciaInt').val() == 'C' || $('#frecuenciaInt').val() == 'Q'
                                        || $('#frecuenciaInt').val() == 'A' || $('#frecuenciaInt').val() == 'D') {

                                        deshabilitaControl('periodicidadInt');
                                        habilitaControl('numAmortInteres');

                                    } else {

                                        if ($('#frecuenciaInt').val() == 'P') {
                                            if ($('#diaPagoInteres1').is(':checked')) {
                                                $('#diaPagoInteres1').attr("checked",true);
                                                $('#diaPagoInteres2').attr("checked",false);
                                                $('#diaMesInteres').val(diaSucursal);

                                            } else {
                                                    $('#diaPagoInteres1').attr("checked",true);
                                                    $('#diaPagoInteres2').attr("checked",false);
                                                    $('#diaMesInteres').val('');
                                            }

                                            habilitaControl('periodicidadInt');
                                            habilitaControl('numAmortInteres');

                                        } else {
                                                if ($('#frecuenciaInt').val() == 'U') {
                                                    $('#numAmortInteres').val("1");
                                                    deshabilitaControl('numAmortInteres');
                                                    $('#periodicidadInt').val($('#noDias').val());

                                                    if ($('#diaPagoInteres1').is(':checked')) {
                                                        $('#diaPagoInteres1').attr("checked",true);
                                                        $('#diaPagoInteres2').attr("checked", false);
                                                        $('#diaMesInteres').val("");

                                                    } else {
                                                            if ($('#diaPagoInteres2').is(':checked')) {
                                                                $('#diaPagoInteres2').attr("checked",true);
                                                                $('#diaPagoInteres1').attr("checked", false);
                                                                $('#diaMesInteres').val(diaSucursal);
                                                            }
                                                    }

                                                }else{
                                                        habilitaControl('numAmortInteres');
                                                        if ($('#diaPagoInteres1').is(':checked')) {
                                                            $('#diaPagoInteres1').attr("checked",true);
                                                            $('#diaPagoInteres2').attr("checked",false);
                                                            $('#diaPagoInteres').val('F');
                                                            $('#diaMesInteres').val("");

                                                        } else {
                                                                if ($('#diaPagoInteres2').is(':checked')) {
                                                                    $('#diaPagoInteres1').attr("checked",false);
                                                                    $('#diaPagoInteres2').attr("checked",true)
                                                                    $('#diaPagoInteres').val('D');
                                                                    $('#diaMesInteres').val(diaSucursal);

                                                                }
                                                        }
                                                }
                                        }
                                }


                            // solo si el producto de credito indica que el dia de pago es Indistinto

                            if($('#diaPagoProd').val() == 'I' && $('#diaPagoInteres2').is(':checked')){
                                    habilitaControl('diaMesInteres');
                                    habilitaControl('diaPagoInteres1');
                                    habilitaControl('diaPagoInteres2');
                            }
                            // solo si el producto de credito indica que el dia de pago es Dia del mes
                            if($('#diaPagoProd').val() == 'D'){
                                habilitaControl('diaMesInteres');
                            }

                        }
                        else { // SI IGUALA CALENDARIOS (Interes con Capital)
                            igualarCalendarioInteresCapital();
                            deshabilitarCalendarioPagosInteres();
                        }
                            break;
                    }
                    validarEsquemaCobroSeguro();
                } // FIN validarEventoFrecuencia()




                // asigna en dias la periodicidad, dependiendo de la frecuencia seleccionada
                function validaPeriodicidad() {
                    switch ($('#frecuenciaCap').val()) {
                        case "S": // SI ES SEMANAL
                            $('#periodicidadCap').val('7');
                            break;
                        case "D": // SI ES DECENAL
                            $('#periodicidadCap').val('10');
                            break;
                        case "C": // SI ES CATORCENAL
                            $('#periodicidadCap').val('14');
                            break;
                        case "Q": // SI ES QUINCENAL
                            $('#periodicidadCap').val('15');
                            break;
                        case "M": // SI ES MENSUAL
                            $('#periodicidadCap').val('30');
                            break;
                        case "B": // SI ES BIMESTRAL
                            $('#periodicidadCap').val('60');
                            break;
                        case "T": // SI ES TRIMESTRAL
                            $('#periodicidadCap').val('90');
                            break;
                        case "R": // SI ES TETRAMESTRAL
                            $('#periodicidadCap').val('120');
                            break;
                        case "E": // SI ES SEMANAL
                            $('#periodicidadCap').val('180');
                            break;
                        case "A": // SI ES ANUAL
                            $('#periodicidadCap').val('360');
                            break;
                        case "L": // SI ES LIBRE
                            $('#periodicidadCap').val('');
                            break;
                        case "P": // SI ES PERIODO
                            $('#periodicidadCap').val($("#noDias").val());
                            break;
                        case "U": // SI ES UNICO
                            $('#periodicidadCap').val($("#noDias").val());
                            break;
                        default: // SI ES DEFAULT
                            $('#periodicidadCap').val('');
                            break;
                    }

                    switch ($('#frecuenciaInt').val()) {
                        case "S": // SI ES SEMANAL
                            $('#periodicidadInt').val('7');
                            break;
                        case "D": // SI ES DECENAL
                            $('#periodicidadInt').val('10');
                            break;
                        case "C": // SI ES CATORCENAL
                            $('#periodicidadInt').val('14');
                            break;
                        case "Q": // SI ES QUINCENAL
                            $('#periodicidadInt').val('15');
                            break;
                        case "M": // SI ES MENSUAL
                            $('#periodicidadInt').val('30');
                            break;
                        case "B": // SI ES BIMESTRAL
                            $('#periodicidadInt').val('60');
                            break;
                        case "T": // SI ES TRIMESTRAL
                            $('#periodicidadInt').val('90');
                            break;
                        case "R": // SI ES TETRAMESTRAL
                            $('#periodicidadInt').val('120');
                            break;
                        case "E": // SI ES SEMANAL
                            $('#periodicidadInt').val('180');
                            break;
                        case "A": // SI ES ANUAL
                            $('#periodicidadInt').val('360');
                            break;
                        case "L": // SI ES LIBRE
                            $('#periodicidadInt').val('');
                            break;
                        case "P": // SI ES PERIODO
                            $('#periodicidadInt').val($("#noDias").val());
                            break;
                        case "U": // SI ES UNICO
                            $('#periodicidadInt').val($("#noDias").val());
                            break;
                        default: // DEFAULT
                            $('#periodicidadInt').val('');
                            break;
                    }
                } // FIN validaPeriodicidad()




                // funcion para deshabilitar la seccion del calendario de pagos que corresponde con interes
                function deshabilitarCalendarioPagosInteres() {
                    deshabilitaControl('numAmortInteres');
                    deshabilitaControl('frecuenciaInt');
                    deshabilitaControl('periodicidadInt');

                    if($('#diaPagoProd').val() != 'I' || $('#perIgual').val() == 'S'){
                        deshabilitaControl('diaPagoInteres1');
                        deshabilitaControl('diaPagoInteres2');
                    }

                    if($('#diaPagoProd').val() != 'D' || $('#perIgual').val() == 'S'){
                        deshabilitaControl('diaMesInteres');
                    }
                }



                // funcion para habilitar la seccion del calendario de pagos que corresponde con interes
                function habilitarCalendarioPagosInteres() {
                    habilitaControl('frecuenciaInt');
                    habilitaControl('numAmortInteres');

                    if($('#diaPagoProd').val() == 'I' && $('#perIgual').val() != 'S' && $("#tipoPagoCapital").val() != 'C'){
                        habilitaControl('diaPagoInteres1');
                        habilitaControl('diaPagoInteres2');
                    }
                    if(($('#diaPagoProd').val() == 'D' || ($('#diaPagoProd').val() == 'I' && $('#diaPagoInteres2').is(':checked')))
                        && $('#perIgual').val() != 'S' && $("#tipoPagoCapital").val() != 'C'){
                            habilitaControl('diaMesInteres');
                        }

                    if($("#frecuenciaInt").val() == 'P' && $('#perIgual').val() != 'S' && $("#tipoPagoCapital").val() != 'C'){
                        habilitaControl('periodicidadInt');
                    }

                }

                // consulta de solicitud de credito (creditos porsolicitud)
                function consultaSolicitudCred(idControl) {

                    var Comercial = 'C';
                    var Consumo = 'O';
                    var recursosPropios = 'P';
                    var jqSolCred = eval("'#" + idControl + "'");
                    var numSolicitud = $(jqSolCred).val();
                    var tipCon = 1;

                    esTab = true;
                    var SolicitudBeanCon = {
                        'solicitudCreditoID' : numSolicitud,
                    };
                    setTimeout("$('#cajaLista').hide();", 200);

                    if (numSolicitud != '' && !isNaN(numSolicitud) && esTab && numSolicitud != '0') {
                        incializaCamposSolicitud();
                        consultaSICParam();
                        $('#creditoID').val('0');
                        solicitudCredServicio.consulta(tipCon,SolicitudBeanCon, { async: false, callback: function(solicitudCred) {
                            if (solicitudCred != null) {
                            	
            						listaPersBloqBean = consultaListaPersBloq(solicitudCred.clienteID, esCliente, 0, 0);
            						consultaSPL = consultaPermiteOperaSPL(solicitudCred.clienteID,'LPB',esCliente);
            						
	            				if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
	            					
	                                consultaProducCreditoProspecto(solicitudCred.productoCreditoID);
	                                if(var_permiteProspecto == permiteSolicitudProspecto && Number(solicitudCred.clienteID)==0){
	                                    mensajeSis('El Prospecto debe ser Cliente.');
	                                    deshabilitaBoton('agrega');
	                                    $('#solicitudCreditoID').val('');
	                                    $('#solicitudCreditoID').focus();
	                                    $('#creditoID').val('0');
	                                } else {
	                                    $('#forCobroSegVida').val(solicitudCred.forCobroSegVida);
	
	                                     if(solicitudCred.forCobroSegVida != '' || solicitudCred.forCobroSegVida != null ){
	                                         dwr.util.removeAllOptions('tipPago');
	                                         consultaTiposPagoSol(solicitudCred.productoCreditoID,esquemaSeguro,solicitudCred.forCobroSegVida);
	                                        }
	
	                                    if (solicitudCred.solicitudCreditoID >0){
	
	                                        deshabilitaControlesSolicitud();
	                                        if (solicitudCred.creditoID != 0) {
	                                            deshabilitaBoton('agrega','submit');
	                                        }
	                                        var status = solicitudCred.estatus;
	
	                                        if(status == 'A'){
	                                            deshabilitaControl('calendIrregularCheck');
	                                        }
	                                        else{
	                                            habilitaControl('calendIrregularCheck');
	                                        }
	
	                                        // valida que la solicitud este autorizada
	                                        if (status == 'I' || status == 'L'|| status == 'C' || status == 'R' ) { /*=LIBERADA,  C=CANCELACION*/
	                                            if(status == 'I'|| status == 'L' ){
	                                                mensajeSis("La Solicitud no ha sido Autorizada");
	                                                $('#solicitudCreditoID').focus();
	                                                $('#solicitudCreditoID').select();
	                                                deshabilitaControl('lineaCreditoID');
	                                            }else{
	                                                if(status == 'C'){
	                                                    mensajeSis("La Solicitud se encuentra Cancelada ");
	                                                    $('#solicitudCreditoID').focus();
	                                                    $('#solicitudCreditoID').select();
	                                                    deshabilitaControl('lineaCreditoID');
	                                                }else{
	                                                    if(status == 'R'){
	                                                        mensajeSis("La Solicitud se encuentra Rechazada ");
	                                                        $('#solicitudCreditoID').focus();
	                                                        $('#solicitudCreditoID').select();
	                                                        deshabilitaControl('lineaCreditoID');
	                                                    }
	                                                }
	                                            }
	                                        } else {// valida que la solicitud este autorizada y no desembolsada
	                                            if ( status != 'I') {
	                                                esTab = true;
	                                                dwr.util.setValues(solicitudCred);
	                                                $('#institucionNominaID').val(solicitudCred.institucionNominaID);
	                                                $('#convenioNominaID').val(solicitudCred.convenioNominaID);
	                                                $('#folioSolici').val(solicitudCred.folioSolici);
	                                                $('#quinquenioID').val(solicitudCred.quinquenioID);
	                                                $('#clabeDomiciliacion').val(solicitudCred.clabeDomiciliacion);                                               
	
	                                                var esReacreditado = solicitudCred.esReacreditado;
	
	                                                if(solicitudCred.tipoCredito == var_TipoCredito.NUEVO){
	                                                    $("#tipoCredito").val(var_TipoCredito.NUEVO);
	                                                    $("#tipoCreditoDes").val(var_TipoCredito.NUEVODES);
	                                                }
	
	                                                if((solicitudCred.tipoCredito == var_TipoCredito.RENOVACION) && esReacreditado == "N"){
	                                                    $("#tipoCredito").val(var_TipoCredito.RENOVACION);
	                                                    $("#tipoCreditoDes").val(var_TipoCredito.RENOVACIONDES);
	                                                }
	
	                                                if((solicitudCred.tipoCredito == var_TipoCredito.RENOVACION) && esReacreditado == "S"){
	                                                    $("#tipoCredito").val(var_TipoCredito.RENOVACION);
	                                                    $("#tipoCreditoDes").val(var_TipoCredito.REACREDITAMIENTODES);
	                                                }
	
	                                                if(solicitudCred.tipoCredito == var_TipoCredito.REESTRUCTURA){
	                                                    $("#tipoCredito").val(var_TipoCredito.REESTRUCTURA);
	                                                    $("#tipoCreditoDes").val(var_TipoCredito.REESTRUCTURADES);
	                                                }
	
	
	                                                $('#tasaBase').val(parseInt(solicitudCred.tasaBase));
	
	                                                consultaMontoFOGAFI();
	
	                                                if(cobraGarantiaFinanciada == 'S'){
	                                                    $('#garantiaFinanciada').show();
	                                                }
	                                                else{
	                                                    $('#garantiaFinanciada').hide();
	                                                }
	                                                //validaciones para consultaSIC
	                                                if (solicitudCred.tipoConsultaSIC != "" && solicitudCred.tipoConsultaSIC != null) {
	                                                    $('#comentariosEjecutivo').show();
	                                                    if (solicitudCred.tipoConsultaSIC == "BC") {
	                                                        $('#tipoConsultaSICBuro').attr("checked",true);
	                                                        $('#tipoConsultaSICCirculo').attr("checked",false);
	                                                        $('#consultaBuro').show();
	                                                        $('#consultaCirculo').hide();
	                                                        $('#folioConsultaCC').val('');
	                                                    }else if (solicitudCred.tipoConsultaSIC == "CC") {
	                                                        $('#tipoConsultaSICBuro').attr("checked",false);
	                                                        $('#tipoConsultaSICCirculo').attr("checked",true);
	                                                        $('#consultaBuro').hide();
	                                                        $('#consultaCirculo').show();
	                                                        $('#folioConsultaBC').val('');
	                                                    }
	                                                } else {
	                                                    //mostrar por defecto valor de parametrossis
	                                                    consultaSICParam();
	                                                }
	
	                                                if(solicitudCred.calcInteresID == '2' || solicitudCred.calcInteresID == '3' || solicitudCred.calcInteresID == '4'){
	                                                        consultaTasaBase('tasaBase',false);
	                                                    }
	
	
	                                                if(solicitudCred.creditoID >0){
	                                                    validaCredito('creditoID');
	                                                }
	                                                if (lineaCreSi == "1") {
	                                                    lineaCreSi = "0";
	                                                        $('#producCreditoID').val(solicitudCred.productoCreditoID);
	                                                        $('#montoCredito').val(solicitudCred.montoAutorizado);
	                                                        $('#montoCredito').formatCurrency({
	                                                            positiveFormat : '%n',
	                                                            roundToDecimalPlace : 2
	                                                        });
	                                                        $('#fechaInicio').val(solicitudCred.fechaInicio);
	                                                        $('#fechaInicioAmor').val(solicitudCred.fechaInicioAmor);
	                                                        $('#fechaVencimien').val(solicitudCred.fechaVencimiento);
	                                                        $('#montoComision').val(solicitudCred.montoComApert);
	                                                        $('#IVAComApertura').val(solicitudCred.ivaComApert);
	                                                        $('#cat').val(solicitudCred.CAT);
	                                                        $('#cat').formatCurrency({
	                                                            positiveFormat : '%n',
	                                                            roundToDecimalPlace : 1
	                                                        });
	                                                        $('#estatus').val('I');
	                                                        $('#numAmortizacion').val(solicitudCred.numAmortizacion);
	
	                                                        if(solicitudCred.flujoOrigen == "C"){
	                                                            solicitudCred.tipoDispersion = "E";
	                                                        }
	                                                        consultaCalendarioPorProductoCredito(
	                                                                solicitudCred.productoCreditoID,
	                                                                solicitudCred.tipoPagoCapital,
	                                                                solicitudCred.frecuenciaCap,
	                                                                solicitudCred.frecuenciaInt,
	                                                                solicitudCred.plazoID,
	                                                                solicitudCred.tipoDispersion);
	
	
	                                                    consultaProducCreditoForanea(solicitudCred.productoCreditoID,'no');
	
	                                                    consultaDestinoCreditoSolicitud('destinoCreID');
	                                                    consultaComboPlazos(solicitudCred.plazoID);
	                                                    asignaInstFondeoID('institFondeoID',solicitudCred.institutFondID);
	                                                    $('#lineaFondeo').val(solicitudCred.lineaFondeoID);
	                                                    $('#clasiDestinCred').val(solicitudCred.clasifiDestinCred);
	
	                                                    if (solicitudCred.clasifiDestinCred == Comercial) {
	                                                        $('#clasificacionDestin1').attr("checked",true);
	                                                        $('#clasificacionDestin2').attr("checked",false);
	                                                        $('#clasificacionDestin3').attr("checked",false);
	                                                    } else if (solicitudCred.clasifiDestinCred == Consumo) {
	                                                        $('#clasificacionDestin1').attr("checked",false);
	                                                        $('#clasificacionDestin2').attr("checked",true);
	                                                        $('#clasificacionDestin3').attr("checked",false);
	                                                    } else {
	                                                        $('#clasificacionDestin1').attr("checked",false);
	                                                        $('#clasificacionDestin2').attr("checked",false);
	                                                        $('#clasificacionDestin3').attr("checked",true);
	                                                    }
	                                                    asignaTipoFondeo(solicitudCred.tipoFondeo);
	                                                    if (solicitudCred.tipoFondeo != recursosPropios) {
	                                                        consultaLineaFondeo('lineaFondeo');
	                                                    }
	                                                    if (solicitudCred.forCobroComAper == 'F') {
	                                                        $('#formaComApertura').val(financiado);
	                                                    }else{
	                                                        if (solicitudCred.forCobroComAper == 'D') {
	                                                            $('#formaComApertura').val(deduccion);
	                                                        }else{
	                                                            if (solicitudCred.forCobroComAper == 'A') {
	                                                                $('#formaComApertura').val(anticipado);
	                                                            }
	                                                            else{
	                                                                if (solicitudCred.forCobroComAper == 'P') {
	                                                                    $('#formaComApertura').val(programado);
	                                                                }
	                                                            }
	                                                        }
	                                                    }
	                                                    deshabilitaControl('fechaInhabil1');
	                                                    deshabilitaControl('fechaInhabil2');
	                                                    deshabilitaControl('ajusFecExiVen1');
	                                                    deshabilitaControl('ajusFecExiVen2');
	                                                    deshabilitaControl('ajusFecUlVenAmo1');
	                                                    deshabilitaControl('ajusFecUlVenAmo2');
	
	
	
	                                                    $('#forCobroSegVida').val(solicitudCred.forCobroSegVida);
	
	                                                    if(modalidad == 'U'){
	
	                                                        if (solicitudCred.forCobroSegVida == 'F') {
	                                                            $('#tipoPagoSeguro').val("F");
	
	                                                        } else {
	                                                            if (solicitudCred.forCobroSegVida == 'D') {
	                                                                $('#tipoPagoSeguro').val("D");
	                                                            } else {
	                                                                if (solicitudCred.forCobroSegVida == 'A') {
	                                                                    $('#tipoPagoSeguro').val("A");
	                                                                }
	                                                            }
	                                                        }
	                                                        }else{
	
	                                                            if(modalidad == 'T'){
	                                                                if(solicitudCred.forCobroSegVida == 'A'){
	                                                                    $("#tipPago option[value="+ solicitudCred.forCobroSegVida  +"]").attr("selected",true);
	                                                                    }
	                                                                    if(solicitudCred.forCobroSegVida == 'F'){
	                                                                    $("#tipPago option[value="+ solicitudCred.forCobroSegVida  +"]").attr("selected",true);
	
	                                                                    }
	                                                                    if(solicitudCred.forCobroSegVida == 'D'){
	                                                                    $("#tipPago option[value="+ solicitudCred.forCobroSegVida  +"]").attr("selected",true);
	
	                                                                    }
	                                                                    if(solicitudCred.forCobroSegVida == 'O'){
	                                                                    $("#tipPago option[value="+ solicitudCred.forCobroSegVida  +"]").attr("selected",true);
	
	                                                                    }
	                                                                    consultaEsquemaSeguroVidaForanea(solicitudCred.productoCreditoID, solicitudCred.forCobroSegVida);
	
	
	                                                        }
	                                                    }
	
	
	                                                    if (solicitudCred.fechInhabil == 'S') {
	                                                        $('#fechaInhabil1').attr("checked","1");
	                                                        $('#fechaInhabil2').attr("checked",false);
	                                                        $('#fechaInhabil').val("S");
	                                                    } else {
	                                                        $('#fechaInhabil2').attr("checked","1");
	                                                        $('#fechaInhabil1').attr("checked",false);
	                                                        $('#fechaInhabil').val("A");
	                                                    }
	
	                                                    if (solicitudCred.ajusFecExiVen == 'S') {
	                                                        $('#ajusFecExiVen1').attr("checked","1");
	                                                        $('#ajusFecExiVen2').attr("checked",false);
	                                                        $('#ajusFecExiVen').val("S");
	                                                    } else {
	                                                        $('#ajusFecExiVen2').attr("checked","1");
	                                                        $('#ajusFecExiVen1').attr("checked",false);
	                                                        $('#ajusFecExiVen').val("N");
	                                                    }
	                                                    if (solicitudCred.ajFecUlAmoVen == 'S') {
	                                                        $('#ajusFecUlVenAmo1').attr("checked","1");
	                                                        $('#ajusFecUlVenAmo2').attr("checked",false);
	                                                        $('#ajusFecUlVenAmo').val("S");
	                                                    } else {
	                                                        $('#ajusFecUlVenAmo2').attr("checked","1");
	                                                        $('#ajusFecUlVenAmo1').attr("checked",false);
	                                                        $('#ajusFecUlVenAmo').val("N");
	                                                    }
	                                                    // Si no es Quincenal.
	                                                    if(solicitudCred.frecuenciaInt != frecuenciaQuincenal){
	                                                        textoDiaPago = 'Día del Mes';
	                                                        if (solicitudCred.diaPagoInteres == 'F') {
	                                                            $('#diaPagoInteres1').attr("checked","1");
	                                                            $('#diaPagoInteres2').attr("checked",false);
	                                                        } else {
	                                                            $('#diaPagoInteres2').attr("checked","1");
	                                                            $('#diaPagoInteres1').attr("checked",false);
	                                                        }
	                                                        $('#divDiaPagoIntMes').show();
	                                                        $('#divDiaPagoIntQuinc').hide();
	                                                    } else {// Si es Quincenal.
	                                                        textoDiaPago = 'Día de Pago';
	                                                        if (solicitudCred.diaPagoInteres == 'D') {
	                                                            $('#diaPagoInteresD').attr('checked',true);
	                                                            $('#diaPagoInteresQ').attr('checked',false);
	                                                            $('#diaDosQuincInt').val(Number(solicitudCred.diaMesInteres) + 15);
	                                                            $('#diaDosQuincInt').show();
	                                                        } else {
	                                                            $('#diaPagoInteresD').attr('checked',false);
	                                                            $('#diaPagoInteresQ').attr('checked',true);
	                                                            $('#diaDosQuincInt').val('0');
	                                                            $('#diaDosQuincInt').hide();
	                                                        }
	                                                        $('#divDiaPagoIntMes').hide();
	                                                        $('#divDiaPagoIntQuinc').show();
	                                                    }
	                                                    $('#labelDiaInteres').text(textoDiaPago+': ');
	                                                    // Si no es Quincenal.
	                                                    if(solicitudCred.frecuenciaCap != frecuenciaQuincenal){
	                                                        textoDiaPago = 'Día de Pago';
	                                                        if (solicitudCred.diaPagoCapital == 'F') {
	                                                            $('#diaPagoCapital1').attr("checked","1");
	                                                            $('#diaPagoCapital2').attr("checked",false);
	                                                        } else {
	                                                            $('#diaPagoCapital2').attr("checked","1");
	                                                            $('#diaPagoCapital1').attr("checked",false);
	                                                        }
	                                                        $('#divDiaPagoCapMes').show();
	                                                        $('#divDiaPagoCapQuinc').hide();
	                                                    } else {// Si es Quincenal.
	                                                        if (solicitudCred.diaPagoCapital == 'D') {
	                                                            $('#diaPagoCapitalD').attr('checked',true);
	                                                            $('#diaPagoCapitalQ').attr('checked',false);
	                                                            $('#diaDosQuincCap').val(Number(solicitudCred.diaMesCapital) + 15);
	                                                            $('#diaDosQuincCap').show();
	                                                        } else {
	                                                            $('#diaPagoCapitalQ').attr('checked',true);
	                                                            $('#diaPagoCapitalD').attr('checked',false);
	                                                            $('#diaDosQuincCap').val('0');
	                                                            $('#diaDosQuincCap').hide();
	                                                        }
	                                                        $('#divDiaPagoCapMes').hide();
	                                                        $('#divDiaPagoCapQuinc').show();
	                                                    }
	
	                                                    $('#diaPagoCapital').val(solicitudCred.diaPagoCapital );
	                                                    $('#diaPagoInteres').val(solicitudCred.diaPagoInteres );
	                                                    $('#labelDiaCapital').text(textoDiaPago+': ');
	
	                                                    if (solicitudCred.frecuenciaInt == null) {
	                                                        $('#frecuenciaInt').val('');
	                                                    }
	                                                    $('#tipoPagoCapital').val(solicitudCred.tipoPagoCapital);
	                                                    $('#cat').formatCurrency({
	                                                        positiveFormat : '%n',
	                                                        roundToDecimalPlace : 1
	                                                    });
	
	                                                    consultaBeneficiarioSolicitud('solicitudCreditoID'); // CONSULTA BENEFICIARIO DE LA SOLICITUD DEL CREDITO
	                                                    if (solicitudCred.relacionado == 0) {
	                                                        $('#relacionado').val("");
	                                                    }
	
	                                                    if (solicitudCred.calendIrregular == 'S') {
	                                                        $('#calendIrregularCheck').attr("checked","true");
	                                                        $('#calendIrregular').val("S");
	                                                        deshabilitaControl('tipoPagoCapital');
	                                                        deshabilitaControl('frecuenciaInt');
	                                                        deshabilitaControl('frecuenciaCap');
	                                                    } else {
	                                                        $('#calendIrregularCheck').attr("checked",false);
	                                                        $('#calendIrregular').val("N");
	                                                        habilitaControl('tipoPagoCapital');
	                                                        habilitaControl('frecuenciaInt');
	                                                        habilitaControl('frecuenciaCap');
	                                                    }
	
	
	                                                } else {
	                                                    consultaProducCreditoProspecto(solicitudCred.productoCreditoID);
	                                                        lineaCreSi = "0";
	                                                        $('#producCreditoID').val(solicitudCred.productoCreditoID);
	                                                        $('#montoCredito').val(solicitudCred.montoAutorizado);
	                                                        montoinicial = $("#montoCredito").asNumber();
	                                                        $('#montoCredito').formatCurrency({
	                                                            positiveFormat : '%n',
	                                                            roundToDecimalPlace : 2
	                                                        });
	                                                        $('#fechaInicio').val(solicitudCred.fechaInicio);
	                                                        $('#fechaInicioAmor').val(solicitudCred.fechaInicioAmor);
	                                                        $('#fechaVencimien').val(solicitudCred.fechaVencimiento);
	                                                        $('#montoComision').val(solicitudCred.montoComApert);
	                                                        $('#IVAComApertura').val(solicitudCred.ivaComApert);
	                                                        $('#cat').val(solicitudCred.CAT);
	                                                        $('#cat').formatCurrency({
	                                                                positiveFormat : '%n',
	                                                                roundToDecimalPlace : 1
	                                                            });
	                                                        $('#estatus').val('I');
	                                                        $('#numAmortizacion').val(solicitudCred.numAmortizacion);
	                                                        consultaClienteSolici('clienteID');
	                                                        consultaCalificacion('clienteID');//consulta la calificacion del cliente
	                                                        if(solicitudCred.flujoOrigen == "C"){
	                                                            solicitudCred.tipoDispersion = "E";
	                                                        }
	                                                        consultaCalendarioPorProductoCredito(
	                                                                solicitudCred.productoCreditoID,
	                                                                solicitudCred.tipoPagoCapital,
	                                                                solicitudCred.frecuenciaCap,
	                                                                solicitudCred.frecuenciaInt,
	                                                                solicitudCred.plazoID,
	                                                                solicitudCred.tipoDispersion);
	
	                                                        consultaProducCreditoForanea(solicitudCred.productoCreditoID,'no');
	                                                        consultaDestinoCreditoSolicitud('destinoCreID');
	                                                        consultaComboPlazos(solicitudCred.plazoID);
	                                                        asignaInstFondeoID('institFondeoID',solicitudCred.institutFondID);
	                                                        $('#lineaFondeo').val(solicitudCred.lineaFondeoID);
	
	                                                        $('#clasiDestinCred').val(solicitudCred.clasifiDestinCred);
	                                                        if (solicitudCred.clasifiDestinCred == Comercial) {
	                                                            $('#clasificacionDestin1').attr("checked",true);
	                                                            $('#clasificacionDestin2').attr("checked",false);
	                                                            $('#clasificacionDestin3').attr("checked",false);
	
	                                                        } else if (solicitudCred.clasifiDestinCred == Consumo) {
	                                                            $('#clasificacionDestin1').attr("checked",false);
	                                                            $('#clasificacionDestin2').attr("checked",true);
	                                                            $('#clasificacionDestin3').attr("checked",false);
	
	                                                        } else {
	                                                            $('#clasificacionDestin1').attr("checked",false);
	                                                            $('#clasificacionDestin2').attr("checked",false);
	                                                            $('#clasificacionDestin3').attr("checked",true);
	                                                        }
	                                                        asignaTipoFondeo(solicitudCred.tipoFondeo);
	                                                        if (solicitudCred.tipoFondeo != recursosPropios) {
	                                                            consultaLineaFondeo('lineaFondeo');
	                                                        }
	
	                                                        if (solicitudCred.forCobroComAper == 'F') {
	                                                            $('#formaComApertura').val(financiado);
	                                                        }
	                                                        if (solicitudCred.forCobroComAper == 'D') {
	                                                            $('#formaComApertura').val(deduccion);
	                                                        }
	                                                        if (solicitudCred.forCobroComAper == 'A') {
	                                                            $('#formaComApertura').val(anticipado);
	                                                        }
	                                                        if (solicitudCred.forCobroComAper == 'P') {
	                                                            $('#formaComApertura').val(programado);
	                                                        }
	
	                                                        deshabilitaControl('fechaInhabil1');
	                                                        deshabilitaControl('fechaInhabil2');
	                                                        deshabilitaControl('ajusFecExiVen1');
	                                                        deshabilitaControl('ajusFecExiVen2');
	                                                        deshabilitaControl('ajusFecUlVenAmo1');
	                                                        deshabilitaControl('ajusFecUlVenAmo2');
	
	                                                        if (solicitudCred.fechInhabil == 'S') {
	                                                            $('#fechaInhabil1').attr("checked","1");
	                                                            $('#fechaInhabil2').attr("checked",false);
	                                                            $('#fechaInhabil').val("S");
	                                                        } else {
	                                                            $('#fechaInhabil2').attr("checked","1");
	                                                            $('#fechaInhabil1').attr("checked",false);
	                                                            $('#fechaInhabil').val("A");
	                                                        }
	
	                                                        if (solicitudCred.ajusFecExiVen == 'S') {
	                                                            $('#ajusFecExiVen1').attr("checked","1");
	                                                            $('#ajusFecExiVen2').attr("checked",false);
	                                                            $('#ajusFecExiVen').val("S");
	                                                        } else {
	                                                            $('#ajusFecExiVen2').attr("checked","1");
	                                                            $('#ajusFecExiVen1').attr("checked",false);
	                                                            $('#ajusFecExiVen').val("N");
	                                                        }
	                                                        if (solicitudCred.ajFecUlAmoVen == 'S') {
	                                                            $('#ajusFecUlVenAmo1').attr("checked","1");
	                                                            $('#ajusFecUlVenAmo2').attr("checked",false);
	                                                            $('#ajusFecUlVenAmo').val("S");
	                                                        } else {
	                                                            $('#ajusFecUlVenAmo2').attr("checked","1");
	                                                            $('#ajusFecUlVenAmo1').attr("checked",false);
	                                                            $('#ajusFecUlVenAmo').val("N");
	                                                        }
	
	                                                        // Si no es Quincenal.
	                                                        if(solicitudCred.frecuenciaInt != frecuenciaQuincenal){
	                                                            textoDiaPago = 'Día del Mes';
	                                                            if (solicitudCred.diaPagoInteres == 'F') {
	                                                                $('#diaPagoInteres1').attr("checked","1");
	                                                                $('#diaPagoInteres2').attr("checked",false);
	                                                            } else {
	                                                                $('#diaPagoInteres2').attr("checked","1");
	                                                                $('#diaPagoInteres1').attr("checked",false);
	                                                            }
	                                                            $('#divDiaPagoIntMes').show();
	                                                            $('#divDiaPagoIntQuinc').hide();
	                                                        } else {// Si es Quincenal.
	                                                            textoDiaPago = 'Día de Pago';
	                                                            if (solicitudCred.diaPagoInteres == 'D') {
	                                                                $('#diaPagoInteresD').attr('checked',true);
	                                                                $('#diaPagoInteresQ').attr('checked',false);
	                                                                $('#diaDosQuincInt').val(Number(solicitudCred.diaMesInteres) + 15);
	                                                                $('#diaDosQuincInt').show();
	                                                            } else {
	                                                                $('#diaPagoInteresD').attr('checked',false);
	                                                                $('#diaPagoInteresQ').attr('checked',true);
	                                                                $('#diaDosQuincInt').val('0');
	                                                                $('#diaDosQuincInt').hide();
	                                                            }
	                                                            $('#divDiaPagoIntMes').hide();
	                                                            $('#divDiaPagoIntQuinc').show();
	                                                        }
	                                                        $('#labelDiaInteres').text(textoDiaPago+': ');
	                                                        // Si no es Quincenal.
	                                                        if(solicitudCred.frecuenciaCap != frecuenciaQuincenal){
	                                                            textoDiaPago = 'Día de Pago';
	                                                            if (solicitudCred.diaPagoCapital == 'F') {
	                                                                $('#diaPagoCapital1').attr("checked","1");
	                                                                $('#diaPagoCapital2').attr("checked",false);
	                                                            } else {
	                                                                $('#diaPagoCapital2').attr("checked","1");
	                                                                $('#diaPagoCapital1').attr("checked",false);
	                                                            }
	                                                            $('#divDiaPagoCapMes').show();
	                                                            $('#divDiaPagoCapQuinc').hide();
	                                                        } else {// Si es Quincenal.
	                                                            textoDiaPago = 'Día de Pago';
	                                                            if (solicitudCred.diaPagoCapital == 'D') {
	                                                                $('#diaPagoCapitalD').attr('checked',true);
	                                                                $('#diaPagoCapitalQ').attr('checked',false);
	                                                                $('#diaDosQuincCap').val(Number(solicitudCred.diaMesCapital) + 15);
	                                                                $('#diaDosQuincCap').show();
	                                                            } else {
	                                                                $('#diaPagoCapitalQ').attr('checked',true);
	                                                                $('#diaPagoCapitalD').attr('checked',false);
	                                                                $('#diaDosQuincCap').val('0');
	                                                                $('#diaDosQuincCap').hide();
	                                                            }
	                                                            $('#divDiaPagoCapMes').hide();
	                                                            $('#divDiaPagoCapQuinc').show();
	                                                        }
	
	                                                        $('#diaPagoCapital').val(solicitudCred.diaPagoCapital );
	                                                        $('#diaPagoInteres').val(solicitudCred.diaPagoInteres );
	                                                        $('#labelDiaCapital').text(textoDiaPago+': ');
	
	                                                        if (solicitudCred.frecuenciaInt == null) {
	                                                            $('#frecuenciaInt').val('');
	                                                        }
	
	                                                        $('#tipoPagoCapital').val(solicitudCred.tipoPagoCapital);
	                                                        deshabilitaControl('tipoPagoCapital');
	
	                                                    asignaTipoFondeo(solicitudCred.tipoFondeo);
	                                                        $('#cat').formatCurrency({
	                                                            positiveFormat : '%n',
	                                                            roundToDecimalPlace : 1
	                                                        });
	
	
	                                                        consultaBeneficiarioSolicitud('solicitudCreditoID'); // CONSULTA BENEFICIARIO DE LA SOLICITUD DEL CREDITO
	
	                                                        if (solicitudCred.calendIrregular == 'S') {
	                                                            $('#calendIrregularCheck').attr("checked","true");
	                                                            $('#calendIrregular').val("S");
	                                                            deshabilitaControl('tipoPagoCapital');
	                                                            deshabilitaControl('frecuenciaInt');
	                                                            deshabilitaControl('frecuenciaCap');
	                                                        } else {
	                                                            $('#calendIrregularCheck').attr("checked",false);
	                                                            $('#calendIrregular').val("N");
	                                                            habilitaControl('tipoPagoCapital');
	                                                            habilitaControl('frecuenciaInt');
	                                                            habilitaControl('frecuenciaCap');
	                                                        }
	
	                                                        if (solicitudCred.relacionado == 0) {
	                                                            $('#relacionado').val("");
	                                                        }
	
	
	
	                                                        $('#forCobroSegVida').val(solicitudCred.forCobroSegVida);
	
	                                                        if(modalidad == 'U'){
	
	                                                            if (solicitudCred.forCobroSegVida == 'F') {
	                                                                $('#tipoPagoSeguro').val("FINANCIAMIENTO");
	
	                                                            } else {
	                                                                if (solicitudCred.forCobroSegVida == 'D') {
	                                                                    $('#tipoPagoSeguro').val("DEDUCCION");
	                                                                } else {
	                                                                    if (solicitudCred.forCobroSegVida == 'A') {
	                                                                        $('#tipoPagoSeguro').val("ANTICIPADO");
	                                                                    }
	                                                                }
	                                                            }
	                                                            }else{
	
	                                                                    if(modalidad == 'T'){
	                                                                        if(solicitudCred.forCobroSegVida == 'A'){
	                                                                            $("#tipPago option[value="+ solicitudCred.forCobroSegVida  +"]").attr("selected",true);
	                                                                            }
	                                                                            if(solicitudCred.forCobroSegVida == 'F'){
	                                                                            $("#tipPago option[value="+ solicitudCred.forCobroSegVida  +"]").attr("selected",true);
	
	                                                                            }
	                                                                            if(solicitudCred.forCobroSegVida == 'D'){
	                                                                            $("#tipPago option[value="+ solicitudCred.forCobroSegVida  +"]").attr("selected",true);
	
	                                                                            }
	                                                                            if(solicitudCred.forCobroSegVida == 'O'){
	                                                                            $("#tipPago option[value="+ solicitudCred.forCobroSegVida  +"]").attr("selected",true);
	
	                                                                            }
	                                                                            consultaEsquemaSeguroVidaForanea(solicitudCred.productoCreditoID, solicitudCred.forCobroSegVida);
	
	
	                                                                        }
	
	                                                                }
	
	
	
	                                                        if(solicitudCred.forCobroSegVida == 'F'){
	                                                            montoinicial = parseFloat(montoinicial) - parseFloat(solicitudCred.montoSeguroVida);
	                                                        }
	                                                        if(solicitudCred.forCobroComAper == 'F'){
	                                                            montoinicial = parseFloat(montoinicial) - parseFloat(solicitudCred.montoComApert);
	                                                            montoinicial = parseFloat(montoinicial) - parseFloat(solicitudCred.ivaComApert);
	                                                        }
	                                                        if(validaAccesorios(tipoConAccesorio.producto)==true && cobraAccesorios == 'S'){
	                                                            muestraGridAccesorios();
	                                                        }
	
	                                                }
	                                            } else {
	                                                mensajeSis("La solicitud no ha sido Autorizada.");
	                                                $('#solicitudCreditoID').focus();
	                                                $('#solicitudCreditoID').select();
	                                                deshabilitaControl('lineaCreditoID');
	                                                montoinicial = 0;
	                                            }
	                                        }
	                                        deshabilitaControlesSolicitud();
	
	                                        if (solicitudCred.creditoID != 0) {
	                                            deshabilitaBoton('agrega','submit');
	                                            habilitaBoton('modifica',   'submit');
	                                        } else {
	
	                                            
	                                             habilitaBoton('agrega','submit');
	                                              
	                                            deshabilitaBoton('modifica','submit');
	                                        }
	                                    }else{
	                                        if (numSolicitud != '0') {
	                                            deshabilitaBoton('agrega','submit');
	                                            mensajeSis("No Existe la solicitud");
	                                            $('#solicitudCreditoID').focus();
	                                            $('#solicitudCreditoID').select();
	                                            habilitaControlesSolicitud();
	                                            incializaCamposSolicitud();
	                                            consultaSICParam();
	                                            inicializaCombos();
	                                            inicializaCombosCredito();
	                                            montoinicial = 0;
	                                        }
	                                    }
	                            }
	                      }else{
                            	mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
                            	deshabilitaBoton('agrega','submit');
                                $('#solicitudCreditoID').focus();
                                $('#solicitudCreditoID').val('');
                                habilitaControlesSolicitud();
                                incializaCamposSolicitud();
                                consultaSICParam();
                                inicializaCombos();
                                inicializaCombosCredito();
                            }
                            } else {
                                if (numSolicitud != '0') {
                                    deshabilitaBoton('agrega','submit');
                                    mensajeSis("No Existe la solicitud");
                                    $('#solicitudCreditoID').focus();
                                    $('#solicitudCreditoID').select();
                                    habilitaControlesSolicitud();
                                    incializaCamposSolicitud();
                                    consultaSICParam();
                                    inicializaCombos();
                                    inicializaCombosCredito();
                                }
                            }
                        }});
                    }else {
                        $('#solicitudCreditoID').focus();
                    }

                }

                // consulta de linea de credito
                function consultaLineaCredito(idControl) {
                    var jqLinea = eval("'#" + idControl + "'");
                    var lineaCred = $(jqLinea).asNumber();

                    var lineaCreditoBeanCon = {
                            'lineaCreditoID' : lineaCred
                    };
                    setTimeout("$('#cajaLista').hide();", 200);
                    esTab = true;
                    if (lineaCred == '0' && esTab) {  // SIN LINEA
                        $('#cuentaID').val('');
                        if ($('#solicitudCreditoID').val() == '' || $('#solicitudCreditoID').asNumber() == '0') { // sin solicitud

                            habilitaControl('producCreditoID');
                            consultaCuentaPrincipal();
                            $('#saldoLineaCred').val("");
                            if ($('#creditoID').asNumber() == '0') {
                                $('#producCreditoID').val("");
                                $('#nombreProd').val("");
                                $('#clasificacion').val("");
                                $('#DescripClasific').val("");
                                $('#saldoLineaCred').val("");
                                $('#producCreditoID').focus();
                                $('#producCreditoID').select();
                            }
                            habilitaControl('montoCredito');
                        }else {                             // sin linea y con con solicitud
                            $('#saldoLineaCred').val("");
                            if ($('#cuentaID').val() == '' || $('#cuentaID').asNumber() ==0) {
                                consultaCuentaPrincipal();
                            }else{
                                $('#simular').focus();
                                $('#simular').select();
                            }
                        }
                    }else{                              // CON LINEA
                        if (lineaCred != '' && !isNaN(lineaCred) && esTab && lineaCred > 0) {
                            habilitaControl('producCreditoID');
                            //habilitaControl('cuentaID');
                            lineasCreditoServicio.consulta(catTipoConsultaCredito.principal,lineaCreditoBeanCon,function(linea) {
                                if (linea != null) {

                                    lineaCreSi = "1";
                                    esTab = true;
                                    var cte = parseInt(linea.clienteID);
                                    var cliente = $('#clienteID').asNumber();
                                    if(linea.estatus != 'A'){
                                        mensajeSis('La línea de Crédito no esta Autorizada');
                                        $('#lineaCreditoID').val("");
                                        $('#lineaCreditoID').focus();
                                        lineaCreSi = "0";
                                    }else{
                                        if (cte != cliente) {
                                            mensajeSis("La línea no corresponde al Cliente");
                                            $('#lineaCreditoID').val("");
                                            $('#lineaCreditoID').focus();
                                            lineaCreSi = "0";
                                        } else {
                                            if ($('#producCreditoID').asNumber()>0) {   //si hay Producto de credito LLLLL
                                                if ($('#producCreditoID').val() == linea.productoCreditoID) {
                                                    $('#cuentaID').val('');
                                                    validaCuentaLineaCredito(linea.cuentaID);
                                                    esTab = true;
                                                    $('#producCreditoID').val(linea.productoCreditoID);
                                                    if($('#creditoID').asNumber()==0 && $('#solicitudCreditoID').asNumber() <=0){
                                                        consultaProducCredito('producCreditoID');
                                                    }
                                                    $('#saldoLineaCred').val(linea.saldoDisponible);
                                                    $('#comAnualLin').val(linea.comisionAnual);
                                                    valMontoComAnualLinea(linea);
                                                } else {
                                                    if ($('#solicitudCreditoID').val() != 0) {
                                                        mensajeSis("El Producto de Crédito de la Solicitud no Coincide con el de la Línea de Crédito");
                                                        $('#lineaCreditoID').val("");
                                                        $('#lineaCreditoID').focus();
                                                        $('#lineaCreditoID').select();

                                                    } else {
                                                        mensajeSis("El Producto de Crédito no Coincide con el de la Línea de Crédito");
                                                        $('#producCreditoID').val("");
                                                        $('#nombreProd').val("");
                                                        $('#producCreditoID').focus();
                                                        $('#producCreditoID').select();
                                                    }
                                                }
                                            }else{
                                                esTab = true;
                                                $('#producCreditoID').val(linea.productoCreditoID);
                                                if($('#creditoID').asNumber()==0){
                                                    consultaProducCredito('producCreditoID');
                                                }
                                                validaCuentaLineaCredito(linea.cuentaID);
                                                $('#saldoLineaCred').val(linea.saldoDisponible);
                                                $('#comAnualLin').val(linea.comisionAnual);
                                                valMontoComAnualLinea(linea);
                                            }
                                        }
                                    }
                                } else if (lineaCred != '' && lineaCred != '0') {
                                    mensajeSis("No Existe la linea");
                                    $('#lineaCreditoID').val("");
                                    $('#lineaCreditoID').focus();
                                }
                            });

                        }else{
                            $('#lineaCreditoID').val('');
                            $('#saldoLineaCred').val('0.00');
                        }
                    }
                }

                function valMontoComAnualLinea(linea){
                    // cobroXApertura
                    var montoComApert = $('#montoComision').asNumber();
                    var montoIVAComApert = $('#IVAComApertura').asNumber();

                    // formaCobroSegVida
                    var reqSeguroVida = $('#reqSeguroVida').val();
                    var montoSeguroVida = 0.00;

                    // Monto Credito
                    var montoCredito = $('#montoCredito').asNumber();

                    // pIVA
                    // iva
                    var montoComAnualLin = 0.00;
                    var montoIVAComAnualLin = 0.00;
                    if (linea.cobraComAnual=='S'){
                        montoComAnualLin = linea.comisionAnual;
                        if (pIVA=='S') {
                            montoIVAComAnualLin = Number(linea.comisionAnual) * Number(iva);
                        }
                    }

                    var accesoriosBeanCon = {
                        'solicitudCreditoID' : $('#solicitudCreditoID').val()
                    };
                    var montoAccesorios = 0.0;

                    if(cobraAccesoriosGen=='S' && cobraAccesorios=='S'){
                        esquemaOtrosAccesoriosServicio.listaCombo(5,accesoriosBeanCon,{ async: false, callback:function(accesoriosBean) {

                                if(accesoriosBean!=null){

                                    for(var i=0; i<accesoriosBean.length; i++ ){
                                        montoAccesorios += Number(accesoriosBean[i].montoAccesorio) + Number(accesoriosBean[i].montoIVAAccesorio);
                                    }

                                }
                            }
                        });
                    }

                    if (cobroXApertura!='D') {
                        montoComApert = 0.00;
                        montoIVAComApert = 0.00;
                    }
                    if (reqSeguroVida=='S' && formaCobroSegVida=='D') {
                        montoSeguroVida = $('#montoSeguroVida').asNumber();
                    }


                    var difMontoCredito = montoCredito - montoComApert - montoIVAComApert - montoSeguroVida - montoAccesorios;

                    if (linea.comisionCobrada=='N' && (difMontoCredito - montoIVAComAnualLin - montoComAnualLin)<0.00) {
                        mensajeSis("El Monto del Crédito es Insuficiente para cubrir el Monto de la Comisión por Anualidad de su Línea de Crédito.");
                        setTimeout("$('#lineaCreditoID').focus()",0);
                    }

                }

                // consulta de linea de credito
                function validaProductoLineaCredito(idControl) {
                    var jqLinea = eval("'#" + idControl + "'");
                    var lineaCred = $(jqLinea).asNumber();
                    var lineaCreditoBeanCon = {
                            'lineaCreditoID' : lineaCred
                    };
                    setTimeout("$('#cajaLista').hide();", 200);
                    if (lineaCred > '0' || lineaCred != ''  && esTab) {
                        if (lineaCred != '' && !isNaN(lineaCred) && esTab && lineaCred > 0) {
                            lineasCreditoServicio.consulta(catTipoConsultaCredito.principal,lineaCreditoBeanCon,function(linea) {
                                if (linea != null) {
                                    if ($('#producCreditoID').val() != linea.productoCreditoID) {
                                        if($('#solicitudCreditoID').asNumber() == 0 && $('#lineaCreditoID').asNumber() >0){
                                            if($('#producCreditoID').val() != linea.productoCreditoID && $('#producCreditoID').val()!= ''){
                                                mensajeSis("El Producto de Crédito no Coincide con el de la Línea de Crédito");
                                                $('#producCreditoID').val("");
                                                $('#nombreProd').val("");
                                                $('#producCreditoID').focus();
                                                $('#producCreditoID').select();
                                            }else{
                                                $('#producCreditoID').val(linea.productoCreditoID);
                                                $('#monedaID').val(linea.monedaID);
                                                $('#saldoLineaCred').val(linea.saldoDisponible);
                                                $('#saldoLineaCred').formatCurrency(
                                                        {
                                                            positiveFormat : '%n',
                                                            roundToDecimalPlace : 2
                                                        });
                                                validaMontoLineaCredito($('#montoCredito').asNumber());
                                                // Consultamos la tasa si ya tenemos los datos necesarios   XX.XX
                                                if($('#clienteID').asNumber() >0 && $('#producCreditoID').asNumber() >0
                                                        && $('#calificaCliente').val() != '' && $('#montoCredito').asNumber() > 0
                                                        && ($('#cicloCliente').asNumber() > 0 || $('#cicloClienteGrupal').asNumber() > 0)){
                                                    esTab =true;
                                                    consultaTasaCredito($('#montoCredito').asNumber());
                                                }

                                            }
                                        }else{
                                            if($('#creditoID').asNumber()==0){
                                                consultaProducCredito('producCreditoID');
                                            }
                                        }
                                    }
                                }else if (lineaCred != '' && lineaCred != '0') {
                                    mensajeSis("No Existe la linea");
                                    $('#lineaCreditoID').focus();
                                }
                            });
                        }else{
                            $('#lineaCreditoID').val('0');
                            $('#saldoLineaCred').val('0.00');
                        }
                    }
                }

                function validaCuentaLineaCredito(lineaCuenta){
                    if ($('#cuentaID').val() != '' || $('#cuentaID').asNumber() >0) {
                        if ($('#cuentaID').asNumber()  != lineaCuenta) {
                            mensajeSis('El Número de Cuenta del Cliente no Coincide con el de la línea de crédito');
                            $('#cuentaID').focus();
                            $('#cuentaID').select();
                        }
                    }else{
                        $('#cuentaID').val(lineaCuenta);
                    }
                }

                // Consulta Tasa Base
                function consultaTasaBase(idControl, desdeInput) {
                    var jqTasa = eval("'#" + idControl + "'");
                    var tasaBase = $(jqTasa).asNumber();
                    var TasaBaseBeanCon = {
                            'tasaBaseID' : tasaBase
                    };
                    setTimeout("$('#cajaLista').hide();", 200);

                    if (tasaBase > 0 && esTab) {
                        tasasBaseServicio.consulta(1, TasaBaseBeanCon, function(tasasBaseBean) {
                            if (tasasBaseBean != null) {
                                hayTasaBase = true;
                                $('#desTasaBase').val(tasasBaseBean.nombre);
                                valorTasaBase = tasasBaseBean.valor;
                                if(desdeInput){
                                    $('#tasaFija').val(valorTasaBase).change();
                                }
                                $('#tasaFija').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
                            } else {
                                hayTasaBase = false;
                                mensajeSis("No Existe la Tasa Base.");
                                $('#tasaBase').focus();
                                $('#tasaBase').val('');
                                $('#desTasaBase').val('');
                                $('#tasaFija').val('').change();
                            }
                        });
                    }
                }

                // consulta de productos de credito
                function consultaProducCredito(idControl) {
                    var si = 'S';
                    var jqProdCred = eval("'#" + idControl + "'");
                    var ProdCred = $(jqProdCred).val();
                    var ProdCredBeanCon = {
                            'producCreditoID' : ProdCred
                    };
                    setTimeout("$('#cajaLista').hide();", 200);
                    if (ProdCred != '' && !isNaN(ProdCred) && esTab) {
                        productosCreditoServicio.consulta(catTipoConsultaCredito.principal,ProdCredBeanCon,function(prodCred) {
                            if (prodCred != null) {
                                    mostrarLabelTasaFactorMora(prodCred.tipCobComMorato);
                                    // SEGUROS
                                    $('#cobraSeguroCuota').val(prodCred.cobraSeguroCuota).selected = true;
                                    $('#cobraIVASeguroCuota').val(prodCred.cobraIVASeguroCuota).selected = true;
                                    // FIN SEGUROS
                               
                                esNomina = prodCred.productoNomina;
                                if (esNomina == 'S'){
                                	obtenerServiciosAdicionales();
                                }
                                productoCredito = prodCred.producCreditoID;
                                var_permiteProspecto=prodCred.permiteAutSolPros;
                                if(prodCred.manejaLinea == 'S'){

                                    if($('#lineaCreditoID').val() == ''){

                                        mensajeSis("Especificar Línea de Crédito.");
                                        $('#lineaCreditoID').val("");
                                        $('#lineaCreditoID').focus();


                                    }
                                }




                                if (prodCred.reqSeguroVida == 'S') {
                                    ++contadorProduc;
                                    $('#montoSeguroVida').val("");
                                    $('#montoCredito').val(montoinicial);
                                    modalidad = prodCred.modalidad;
                                    esquemaSeguro = prodCred.esquemaSeguroID;
                                    consultaTiposPago(prodCred.producCreditoID,prodCred.esquemaSeguroID, "");

                                    if(prodCred.modalidad == "T"){
                                        descuentoSeg = prodCred.descuentoSeguro;
                                        $('#ltipoPago').hide();
                                        $('#tipoPagoSeguro').hide();
                                        $('#tipoPagoSelect').show();
                                        $('#forCobroSegVida').val("");

                                        }else{
                                            if(prodCred.modalidad == "U"){
                                            descuentoSeg = prodCred.descuentoSeguro;

                                            $('#ltipoPago').show();
                                            $('#tipoPagoSeguro').show();
                                            $('#tipoPagoSelect').hide();
                                            $('#forCobroSegVida').val(prodCred.tipoPagoSeguro);

                                            }
                                        }


                                } else {
                                    contaendorProduc = 0;
                                    $('#montoSeguroVida').val("");
                                    $('#montoCredito').val(montoinicial);
                                    $('#tipoPagoSelect').hide();
                                }
                                if(prodCred.permitePrepago='S'){

                                    if (tipoPrepCre == "")
                                        $('#tipoPrepago').val(prodCred.tipoPrepago);
                                    else
                                        $('#tipoPrepago').val(tipoPrepCre);
                                    $('#prepagos').show();
                                    $('#prepagoslbl').show();

                                }else{
                                    $('#prepagos').hide();
                                    $('#prepagoslbl').hide();
                                }
                                esTab = true;
                                // valida que el grupo no se grupal, en caso contrario manda error
                                if (prodCred.esGrupal == 'S') {
                                    mensajeSis("Producto de Crédito Reservado para Créditos Grupales.");
                                    inicializaValores();
                                    inicializaCombos();
                                    consultaSICParam();
                                    deshabilitaBoton('agrega','submit');
                                    deshabilitaBoton('modifica','submit');
                                    $('#producCreditoID').val('');
                                    $('#nombreProd').val('');
                                    $('#clasificacion').val('');
                                    $('#DescripClasific').val('');
                                    $('#producCreditoID').focus();
                                    $('#direccionBen').val('');
                                    $('#beneficiario').val('');
                                    $('#parentescoID').val('');
                                    $('#parentesco').val('');
                                    $('#reqSeguroVidaSi').attr("checked",false);
                                    $('#reqSeguroVidaNo').attr("checked",true);
                                    $('#reqSeguroVida').val('N');
                                    $('#cicloCliente').val('');
                                    $('#tipoPagoSeguro').val('');
                                } else {
                                    var credito = $('#creditoID').val();
                                    var solCredito = $('#solicitudCreditoID').val();
                                    $('#nombreProd').val(prodCred.descripcion);
                                    if (solCredito == '0'
                                        || solCredito == '') {
                                        $('#clasificacion').val(prodCred.clasificacion);
                                        $('#factorMora').val(prodCred.factorMora);
                                        setCalcInteresID(prodCred.calcInteres,false);
                                        ValidaCalcInteres('calcInteresID');
                                        if ($('#tipoFondeo2').attr("checked") == true) {
                                            asignaInstFondeoID('institFondeoID',prodCred.institutFondID);
                                        }
                                        $('#tipoCalInteres').val(prodCred.tipoCalInteres);
                                        if(prodCred.tipoCalInteres == '2'){
                                            $('#tipoPagoCapital').val('I').selected = true;
                                        }
                                        deshabilitaControl('tipoCalInteres');
                                        $('#factorRiesgoSeguro').val(prodCred.factorRiesgoSeguro);
                                        requiereSeg = prodCred.reqSeguroVida; // GUARDA EL VALOR SI TIENE SEGURO O NO

                                        consultaPorcentajeGarantiaLiquida('producCreditoID');

                                        $('#forCobroSegVida').val(prodCred.tipoPagoSeguro);
                                        $('#montoPolSegVida').val(prodCred.montoPolSegVida);

                                        // forma de pago del producto de credito
                                        switch (prodCred.formaComApertura) {
                                        case "F": // si el tipo de pago es CRECIENTES
                                            $('#formaComApertura').val(financiado);
                                            break;
                                        case "D":// si el tipo de pago es IGUALES
                                            $('#formaComApertura').val(deduccion);
                                            cobroXApertura = prodCred.formaComApertura;
                                            break;
                                        case "A": // si el tipo de pago es LIBRES
                                            $('#formaComApertura').val(anticipado);
                                            break;
                                        case "P": // si el tipo de pago es PROGRAMADO
                                            $('#formaComApertura').val(programado);
                                            break;
                                        default:
                                            $('#formaComApertura').val(prodCred.formaComApertura);
                                        }

                                        // forma de pago del seguro de vida
                                        switch (prodCred.tipoPagoSeguro) {
                                        case "F": // si el tipo de pago es CRECIENTES
                                            $('#tipoPagoSeguro').val(financiado);
                                            break;
                                        case "D":// si el tipo de pago es IGUALES
                                            $('#tipoPagoSeguro').val(deduccion);
                                            formaCobroSegVida = prodCred.tipoPagoSeguro;
                                            break;
                                        case "A": // si el tipo de pago es LIBRES
                                            $('#tipoPagoSeguro').val(anticipado);
                                            break;
                                        default:
                                            $('#tipoPagoSeguro').val(prodCred.tipoPagoSeguro);
                                        }

                                    }
                                    consultaComisionAper();
                                    if (credito == '0' && solCredito != '0') {
                                        asignaInstFondeoID('institFondeoID',prodCred.institutFondID);
                                    }
                                    if (prodCred.calcInteres == 1) {
                                        deshabilitaControl('calcInteresID');
                                        deshabilitaControl('tasaFija');
                                        deshabilitaControl('pisoTasa');
                                        deshabilitaControl('tasaBase');
                                        deshabilitaControl('sobreTasa');
                                        deshabilitaControl('techoTasa');
                                    }
                                    consultaDescripClaRepReg('clasificacion');
                                    habilitaControl('direccionBen');
                                    habilitaControl('beneficiario');
                                    habilitaControl('parentescoID');
                                    // asignacion de variables de los valores montos: mÃ­nimo, mÃ¡ximo, y la forma de comision
                                    // por apertura permitido por el producto de credito para sus correspondientes validaciones del
                                    // monto de crÃ©dito
                                    MontoMaxCre = prodCred.montoMaximo;
                                    MontoMinCre = prodCred.montoMinimo;

                                    if (prodCred.reqSeguroVida == si) {
                                        $('#trMontoSeguroVida').show('slow');
                                        $('#trBeneficiario').show('slow');
                                        $('#trParentesco').show('slow');
                                        $('#reqSeguroVidaSi').attr("checked",true);
                                        $('#reqSeguroVidaNo').attr("checked",false);
                                        $('#reqSeguroVida').val('S');
                                    } else {
                                        $('#tipoPagoSeguro').val('');
                                        $('#montoSeguroVida').val('');
                                        $('#beneficiario').val('');
                                        $('#parentescoID').val('');
                                        $('#parentesco').val('');
                                        $('#direccionBen').val('');

                                        $('#trMontoSeguroVida').hide();
                                        $('#trBeneficiario').hide();
                                        $('#trParentesco').hide();
                                        $('#reqSeguroVidaSi').attr("checked",false);
                                        $('#reqSeguroVidaNo').attr("checked",true);
                                        $('#reqSeguroVida').val('N');
                                    }
                                }
                                consultaCalendarioPorProducto(idControl); // CONSULTA EL CALENDARIO DE PRODUCTO DE CREDITO

                                // Consultamos la tasa si ya tenemos los datos necesarios
                                if($('#clienteID').asNumber() >0 && $('#producCreditoID').asNumber() >0
                                        && $('#calificaCliente').val() != '' && $('#montoCredito').asNumber() > 0
                                        && ($('#cicloCliente').asNumber() > 0 || $('#cicloClienteGrupal').asNumber() > 0)){
                                    esTab =true;
                                    consultaTasaCredito($('#montoCredito').asNumber());
                                }



                                // valida si el credito puede tener un desembolso anticipado
                                $('#fechaInicioAmor').val(parametroBean.fechaAplicacion);
                                if(prodCred.inicioAfuturo == 'S'){
                                    habilitaControl('fechaInicioAmor');
                                    $("#fechaInicioAmor").datepicker({
                                        showOn: "button",
                                        buttonImage: "images/calendar.png",
                                        buttonImageOnly: true,
                                        changeMonth: true,
                                        changeYear: true,
                                        dateFormat: 'yy-mm-dd',
                                        yearRange: '-100:+10'
                                    });

                                    inicioAfuturo = 'S';
                                    diasMaximo = prodCred.diasMaximo;
                                }else{
                                    deshabilitaControl('fechaInicioAmor');
                                    $("#fechaInicioAmor").datepicker("destroy");

                                    inicioAfuturo = 'N';
                                    diasMaximo = 0;
                                }

                            } else {
                                mensajeSis("No Existe el Producto de Crédito");
                                // SEGUROS
                                $('#cobraSeguroCuota').val('N').selected = true;
                                $('#cobraIVASeguroCuota').val('N').selected = true;
                                $('#montoSeguroCuota').val('');
                                // FIN SEGUROS
                                $('#producCreditoID').val("");
                                $('#producCreditoID').focus();
                                $('#producCreditoID').select();
                                deshabilitaControl('direccionBen');
                                deshabilitaControl('beneficiario');
                                deshabilitaControl('parentescoID');

                                deshabilitaControl('fechaInicioAmor');
                                $("#fechaInicioAmor").datepicker("destroy");
                                inicioAfuturo = 'N';
                                diasMaximo = 0;
                            }
                        });
                    }

                    agregaFormatoControles('formaGenerica');
                }

                function consultaProducCreditoProspecto(ProductoID) {
                    var si = 'S';
                    var ProdCred = Number(ProductoID);
                    var ProdCredBeanCon = {
                            'producCreditoID' : ProdCred
                    };
                    setTimeout("$('#cajaLista').hide();", 200);
                    if (ProdCred > 0 ) {
                        productosCreditoServicio.consulta(catTipoConsultaCredito.principal,ProdCredBeanCon,{ async: false, callback:function(prodCred) {
                            if (prodCred != null) {
                                var_permiteProspecto=prodCred.permiteAutSolPros;
                                cobraAccesorios = prodCred.cobraAccesorios;
                                esNomina = prodCred.productoNomina;
                            	if (esNomina == 'S'){
                            		obtenerServiciosAdicionales();
                            	}
                            } else {
                                var_permiteProspecto='N';
                            }
                        }});
                    }

                    agregaFormatoControles('formaGenerica');
                }

                // consulta foranea del producto de credito utilizada en la consulta de la solicitud de credito
                function consultaProducCreditoForanea(producto, varfecha) {
                    var ProdCredBeanCon = {
                            'producCreditoID' : producto
                    };
                    setTimeout("$('#cajaLista').hide();", 200);
                    if (producto != '' && !isNaN(producto)) {
                        productosCreditoServicio.consulta(catTipoConsultaCredito.principal,ProdCredBeanCon,
                            function(prodCred) {
                                    if (prodCred != null) {
                                    	
                                    	esNomina = prodCred.productoNomina;
                                    	if (esNomina == 'S'){
                                    		obtenerServiciosAdicionales();
                                    	}
                                        // SEGUROS
                                        // AQUI NO SE DEBE DE RESETEAR SI COBRA O NO SEGURO YA QUE DEBE QUEDARSE
                                        // CON EL DATO QUE TRAE LA SOLICITUD
                                        $('#nombreProd').val(prodCred.descripcion);
                                        $('#descripProducto').val(prodCred.descripcion);

                                        consultaPorcentajeGarantiaLiquida('producCreditoID');
                                        if(prodCred.productoNomina=="S") {
                                            if(manejaConvenio=='S'){
                                            $('#datosNomina').show();
                                            consultaNomInstit();
                                            
                                            consultaConvenioNomina();
                                            }else{
                                                $('#datosNomina').hide();
                                                $('.quinquenios').hide();
                                            }
                                        }else{
                                            $('#datosNomina').hide();
                                            $('#institucionNominaID').val("");
                                            $('#nombreInstit').val("");
                                            $('#convenioNominaID').val("");
                                            $('#desConvenio').val("");
                                            $('.quinquenios').hide();
                                            $('.folioSolici').hide();
                                            $('#folioSolici').val("");
                                            if(manejaConvenio=='S'){
                                            dwr.util.removeAllOptions('quinquenioID');
                                            dwr.util.addOptions('quinquenioID',{'':'SELECCIONAR'});
                                            }
                                        }
                                        if(prodCred.permitePrepago == 'S'){

                                            $('#prepagos').show();
                                            $('#prepagoslbl').show();
                                            if (tipoPrepCre == "")
                                                $('#tipoPrepago').val(prodCred.tipoPrepago);
                                            else{
                                                $('#tipoPrepago').val(tipoPrepCre);

                                            }
                                        }else{
                                            $('#prepagos').hide();
                                            $('#prepagoslbl').hide();
                                        }

                                        if(cobraAccesoriosGen == 'N'){
                                            cobraAccesorios =   prodCred.cobraAccesorios;
                                        }
                                        MontoMaxCre = prodCred.montoMaximo;
                                        MontoMinCre = prodCred.montoMinimo;
                                        asignaInstFondeoID('institFondeoID',prodCred.institutFondID);
                                        requiereSeg = prodCred.reqSeguroVida; // GUARDA EL VALOR SI TIENE SEGURO O NO
                                        if (prodCred.reqSeguroVida == 'S') {
                                            $('#reqSeguroVidaSi').attr("checked",true);
                                            $('#reqSeguroVidaNo').attr("checked",false);
                                            $('#reqSeguroVida').val("S");
                                            if (varfecha != 'no') {
                                                calculaNodeDias(varfecha);

                                                habilitaControl('direccionBen');
                                                habilitaControl('beneficiario');
                                                habilitaControl('parentescoID');
                                                habilitaControl('parentesco');
                                            } else {

                                                deshabilitaControl('direccionBen');
                                                deshabilitaControl('beneficiario');
                                                deshabilitaControl('parentescoID');
                                                deshabilitaControl('parentesco');
                                            }


                                            modalidad = prodCred.modalidad;
                                            esquemaSeguro = prodCred.esquemaSeguroID;
                                            $('#esquemaSeguroID').val(prodCred.esquemaSeguroID);

                                            if(prodCred.modalidad == "T"){
                                            descuentoSeg = prodCred.descuentoSeguro;
                                                $('#ltipoPago').hide();
                                                $('#tipoPagoSeguro').hide();
                                                $('#tipoPagoSelect').show();

                                                }else{
                                                    descuentoSeg = prodCred.descuentoSeguro;
                                                    if(prodCred.modalidad == "U"){
                                                    $('#ltipoPago').show();
                                                    $('#tipoPagoSeguro').show();
                                                    $('#tipoPagoSelect').hide();
                                                    }
                                                }

                                        } else {
                                            $('#reqSeguroVidaSi').attr("checked",false);
                                            $('#reqSeguroVidaNo').attr("checked",true);
                                            $('#reqSeguroVida').val("N");
                                            $('#ajusFecExiVen1').focus();
                                        }

                                        // esconde o muestra los elementos de cuando requiere seguro de vida
                                        validaSiseguroVida(prodCred.reqSeguroVida);

                                        if (esTab==true &&  parseInt($('#solicitudCreditoID').val()) > 0 ) {
                                            $('#lineaCreditoID').focus();
                                        }
                                        $('#factorRiesgoSeguro').val(prodCred.factorRiesgoSeguro);


                                        if(prodCred.modalidad == "U"){
                                            $('#forCobroSegVida').val(prodCred.tipoPagoSeguro);
                                            }else{
                                                $('#forCobroSegVida').val("");
                                                if(prodCred.modalidad == "T"){

                                                     if($('#tipPago option:selected').text() == "ADELANTADO"){
                                                         $('#forCobroSegVida').val("A");

                                                     }else{}

                                                     if($('#tipPago option:selected').text() == "FINANCIAMIENTO"){
                                                         $('#forCobroSegVida').val("F");

                                                     }else{}

                                                     if($('#tipPago option:selected').text() == "DEDUCCION"){
                                                         $('#forCobroSegVida').val("D");

                                                     }else{}

                                                     if($('#tipPago option:selected').text() == "OTRO"){
                                                         $('#forCobroSegVida').val("O");

                                                     }else{}
                                                     consultaEsquemaSeguroVidaForanea(prodCred.producCreditoID, tipoPagoSeg);


                                                    }
                                                }


                                        $('#montoPolSegVida').val(prodCred.montoPolSegVida);


                                        // forma de pago del seguro
                                        // de vida
                                        if(prodCred.modalidad == 'U'){
                                        if (prodCred.tipoPagoSeguro == 'F') {
                                            $('#tipoPagoSeguro').val(financiado);
                                        } else {
                                            if (prodCred.tipoPagoSeguro == 'D') {
                                                $('#tipoPagoSeguro').val(deduccion);
                                            } else {
                                                if (prodCred.tipoPagoSeguro == 'A') {
                                                    $('#tipoPagoSeguro').val(anticipado);
                                                }
                                            }
                                        }

                                        }else{
                                            if(prodCred.modalidad == 'T'){
                                                if(tipoPagoSeg == 'A'){
                                                    $('#tipPago').val('A');

                                                }else{
                                                    if(tipoPagoSeg == 'F'){
                                                        $('#tipPago').val('F');
                                                    }else{

                                                        if(tipoPagoSeg == 'D'){
                                                            $('#tipPago').val('D');

                                                        }else{
                                                            if(tipoPagoSeg == 'O'){
                                                                $('#tipPago').val('O');

                                                            }else{}
                                                        }
                                                    }
                                                }
                                            }
                                        }




                                        // forma de pago del producto de credito
                                        switch (prodCred.formaComApertura) {
                                        case "F": // si el tipo de pago es CRECIENTES
                                            $('#formaComApertura').val(financiado);
                                            break;
                                        case "D":// si el tipo de pago es IGUALES
                                            $('#formaComApertura').val(deduccion);
                                            cobroXApertura = prodCred.formaComApertura;
                                            break;
                                        case "A": // si el tipo de pago es LIBRES
                                            $('#formaComApertura').val(anticipado);
                                            break;
                                        case "P": // si el tipo de pago es programado
                                            $('#formaComApertura').val(programado);
                                            break;
                                        default:
                                            $('#formaComApertura').val(prodCred.formaComApertura);
                                        }


                                        // valida si el producto de credito puede tener un desembolso anticipado
                                        if(prodCred.inicioAfuturo == 'S'){
                                            habilitaControl('fechaInicioAmor');
                                            $("#fechaInicioAmor").datepicker({
                                                showOn: "button",
                                                buttonImage: "images/calendar.png",
                                                buttonImageOnly: true,
                                                changeMonth: true,
                                                changeYear: true,
                                                dateFormat: 'yy-mm-dd',
                                                yearRange: '-100:+10'
                                            });

                                            inicioAfuturo = 'S';
                                            diasMaximo = prodCred.diasMaximo;
                                        }else{
                                            deshabilitaControl('fechaInicioAmor');
                                            $("#fechaInicioAmor").datepicker("destroy");

                                            inicioAfuturo = 'N';
                                            diasMaximo = 0;
                                        }


                                    } else {
                                        mensajeSis("No Existe el Producto de Credito");
                                        // SEGUROS
                                        $('#cobraSeguroCuota').val('N').selected = true;
                                        $('#cobraIVASeguroCuota').val('N').selected = true;
                                        $('#montoSeguroCuota').val('');
                                        // FIN SEGUROS
                                        $('#producCreditoID').focus();
                                        $('#producCreditoID').select();

                                        deshabilitaControl('fechaInicioAmor');
                                        $("#fechaInicioAmor").datepicker("destroy");
                                        inicioAfuturo = 'N';
                                        diasMaximo = 0;
                                    }
                                });
                    }
                }




                /* FUNCION PARA OBTENER EL PORCENTAJE DE GARANTIA LIQUIDA PARA PRODUCTO DE CREDITO */
                function consultaPorcentajeGarantiaLiquida(controlID) {
                    var jqControl = eval("'#" + controlID + "'");
                    var tipoCon = 5;
                    var producCreditoID = $("#producCreditoID").val();
                    var productoCreditoBean = {
                            'producCreditoID'   :producCreditoID
                    };

                    // verifica que el producto de credito en pantalla requiere garantia liquida */
                    productosCreditoServicio.consulta(tipoCon,productoCreditoBean,function(respuesta) {
                        if (respuesta != null && respuesta.requiereGarantia== 'S') {
                            var clienteID = 0;
                            var calificaCli = $('#calificaCliente').val();
                            var monto = $("#montoCredito").asNumber();

                            // verifica que los datos necesario para la consulta NO esten vacios..
                            if(parseInt(producCreditoID)>0 && calificaCli != '' && parseFloat(monto) > 0){
                                tipoCon = 1;
                                var bean = {
                                        'producCreditoID'   :producCreditoID,
                                        'clienteID' :clienteID,
                                        'calificacion': calificaCli,
                                        'montoSolici'   :monto
                                };


                                // obtiene el porcentaje de garantia liquida
                                esquemaGarantiaLiqServicio.consulta(tipoCon,bean,function(respuesta) {
                                    if (respuesta != null) {
                                        $('#porcGarLiq').val(respuesta.porcentaje);
                                        $('#porcentaje').val(respuesta.porcentaje);

                                        //ejecuta cuando es un credito nuevo nueva
                                        if($("#solicitudCreditoID").val() == 0 || $("#solicitudCreditoID").val() ==''){
                                            // calcula el nuevo monto de aportacion del cliente
                                            calPorceGaranLiquida(respuesta.porcentaje);
                                        }
                                    }
                                    else{
                                        mensajeSis("No existe un Esquema de Garantía Líquida para el Producto de Crédito, Calificación del cliente y Monto indicado");
                                        $(jqControl).focus();
                                        $(jqControl).select();
                                    }
                                });
                            }
                        }
                        // si el producto de credito no requiere garantia liquida
                        else{
                            $('#porcGarLiq').val('0.00');
                            $('#porcentaje').val('0.00');
                            $('#aporteCliente').val('0.00');
                        }
                    });

                }




                // funcion que calcula la comision por apertura de credito
                // en base a las condiciones del producto de credito y el
                // monto solicitado
                function consultaComisionAper() {

                    var ProdCred = $('#producCreditoID').val();
                    var ProdCredBeanCon = {
                            'producCreditoID' : ProdCred
                    };
                    setTimeout("$('#cajaLista').hide();", 200);
                    if (ProdCred != '' && !isNaN(ProdCred) && esTab) {

                        productosCreditoServicio.consulta(catTipoConsultaCredito.principal,ProdCredBeanCon,{ async: false, callback: function(prodCred) {
                            if (prodCred != null) {
                                esTab = true;

                                if ($('#solicitudCreditoID').val() == ""|| $('#solicitudCreditoID').val()== 0) {
                                    var montoCre = $('#montoCredito').asNumber();
                                    // si el tipo es porcentaje hace el calculo del monto y por deduccion
                                    if (prodCred.montoComXapert > 0) {
                                        if (prodCred.formaComApertura == 'D') {
                                            if (prodCred.tipoComXapert == 'P') {
                                                $('#montoComision').val(montoinicial* (prodCred.montoComXapert / 100));
                                                $('#montoComision').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

                                                if ($('#montoComision').val()=='0'){
                                                    $('#montoComision').val('0.00');
                                                    $('#IVAComApertura').val('0.00');
                                                }
                                                consultaIVASucursal2();

                                            } else {
                                                if (prodCred.tipoComXapert == 'M') {
                                                    $('#montoComision').val(prodCred.montoComXapert);
                                                    $('#montoComision').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
                                                    consultaIVASucursal2();
                                                }
                                            }

                                        } else {    // si el tipo es monto y forma de cobro por Financiamiento
                                            if (prodCred.formaComApertura == 'F') {
                                                if (prodCred.tipoComXapert == 'P') { // el cobro de la comision es un porcentaje del monto de credito

                                                        var montoComis = montoinicial * (prodCred.montoComXapert / 100);
                                                        montoComis.toFixed(2);
                                                        $('#montoComision').val(montoComis);
                                                        $('#montoComision').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

                                                        var montoCredConv = (montoinicial);
                                                        montoCredConv.toFixed(2);
                                                        var montoCredAjus = (montoCredConv + montoComis);

                                                        /*if($("#tipoPagoSeguro").val() == 'FINANCIAMIENTO'){
                                                            montoCredAjus += parseFloat($("#montoSeguroVida").asNumber());
                                                        }*/

                                                            //calculoCostoSeguroTipoPago('S');

                                                        if($("#forCobroSegVida").val() == 'F'){
                                                            montoCredAjus = Number(montoCredAjus) + parseFloat($("#montoSeguroVida").asNumber());

                                                        }

                                                        $('#montoCredito').val(montoCredAjus);

                                                        if ($('#montoComision').val()=='0'){
                                                            $('#montoComision').val('0.00');
                                                            $('#IVAComApertura').val('0.00');
                                                        }
                                                        consultaIVASucursal();

                                                } else {
                                                        if (prodCred.tipoComXapert == 'M') { // el cobro de la comision es por monto fijo
                                                            if($('#montoCredito').asNumber()>0){
                                                                var montoCredAjus = parseFloat( parseFloat(montoinicial)  + parseFloat(prodCred.montoComXapert));

                                                                if($("#forCobroSegVida").val() == 'F'){
                                                                    montoCredAjus = Number(montoCredAjus) + parseFloat($("#montoSeguroVida").asNumber());
                                                                }

                                                                    $('#montoCredito').val(montoCredAjus);
                                                                    MontoIni = montoCredAjus;
                                                                    consultaIVASucursal();

                                                                $('#montoComision').val(prodCred.montoComXapert);
                                                                $('#montoComision').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

                                                            }

                                                        }
                                                }
                                            }
                                            // si el tipo es monto y forma de cobro por Anticipado
                                            if (prodCred.formaComApertura == 'A') {
                                                if(prodCred.tipoComXapert == 'P'){
                                                    var montoComis = montoCre * (prodCred.montoComXapert/100);
                                                    $('#montoComision').val(montoComis);
                                                    $('#montoComision').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
                                                    if ($('#montoComision').val()=='0'||prodCred.montoComXapert =='0'){
                                                        $('#montoComision').val('0.00');
                                                        $('#IVAComApertura').val('0.00');
                                                    }
                                                    consultaIVASucursal2();
                                                }else{
                                                    // si es por monto
                                                    if(prodCred.tipoComXapert == 'M'){
                                                        montoComis = prodCred.montoComXapert;
                                                        $('#montoComision').val(prodCred.montoComXapert);
                                                        $('#montoComision').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
                                                        consultaIVASucursal2();
                                                    }
                                                }
                                            }

                                            // si el tipo es monto y la forma de cobro es PROGRAMADO
                                            if (prodCred.formaComApertura == 'P') {
                                                if(prodCred.tipoComXapert == 'P'){
                                                    var montoComis = montoCre * (prodCred.montoComXapert/100);
                                                    $('#montoComision').val(montoComis);
                                                    $('#montoComision').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
                                                    if ($('#montoComision').val()=='0'||prodCred.montoComXapert =='0'){
                                                        $('#montoComision').val('0.00');
                                                        $('#IVAComApertura').val('0.00');
                                                    }
                                                    consultaIVASucursal2();
                                                }else{
                                                    // si es por monto
                                                    if(prodCred.tipoComXapert == 'M'){
                                                        montoComis = prodCred.montoComXapert;
                                                        $('#montoComision').val(prodCred.montoComXapert);
                                                        $('#montoComision').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
                                                        consultaIVASucursal2();
                                                    }
                                                }
                                            }
                                        }
                                        if ($('#montoComision').val()=='0'){
                                            $('#montoComision').val('0.00');
                                            $('#IVAComApertura').val('0.00');
                                        }
                                    }else{ // termina if (prodCred.montoComXapert > 0)
                                        $('#montoComision').val('0.00');
                                        $('#IVAComApertura').val('0.00');
                                    }
                                }
                                agregaFormatoControles('formaGenerica');

                                } // termina if (prodCred != null)
                            }
                        });
                    }

                }





                // funcion que calcula el IVA de la comision por apertura de credito de acuerdo a la sucursal del cliente
                // Utilizada cuando el tipo de cobro es por financiamiento (suma la comision ni el iva al monto original del credito)
                function consultaIVASucursal() {

                    var numSucursal = $('#sucursalCte').val();
                    setTimeout("$('#cajaLista').hide();", 200);
                    if (numSucursal != '' && !isNaN(numSucursal) && esTab) {
                        sucursalesServicio.consultaSucursal(catTipoConsultaCredito.principal,numSucursal,{ async: false, callback: function(sucursal) {
                            if (sucursal != null) {
                                pIVA = $('#pagaIVACte').val();
                                iva = sucursal.IVA;
                                var monto = $('#montoComision').asNumber();
                                var montoCredito = parseFloat( parseFloat(montoinicial) + parseFloat(monto));

                                /*if($("#tipoPagoSeguro").val() == 'FINANCIAMIENTO'){
                                    montoCredito += parseFloat($("#montoSeguroVida").asNumber());
                                }*/

                                if($("#forCobroSegVida").val() == 'F'){
                                    montoCredito = Number(montoCredito) + parseFloat($("#montoSeguroVida").asNumber());
                                    }


                                if (pIVA == 'S'  ) {
                                    var ivaCalc = parseFloat(monto) * parseFloat(iva);
                                    ivaCalc.toFixed(2);
                                    $('#IVAComApertura').val(ivaCalc);
                                    $('#IVAComApertura').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});

                                    montoCredito = Number(montoCredito) + parseFloat(ivaCalc);

                                    $('#montoCredito').val(montoCredito);
                                    montoFinal=$('#montoCredito').asNumber();
                                    $('#montoCredito').formatCurrency(
                                            {
                                                positiveFormat : '%n',
                                                negativeFormat : '%n',
                                                roundToDecimalPlace : 2
                                            });
                                    comisionInicial=$('#montoComision').asNumber();
                                }
                                if (pIVA == 'N') {
                                    $('#IVAComApertura').val('0.00');
                                }

                            }
                          }
                        });
                    }
                }

                // funcion que calcula el IVA de la comision por apertura de credito de acuerdo a la sucursal del cliente
                // Utilizada cuando el tipo de cobro es por deduccion (no suma la comision ni el iva al monto original del credito)
                function consultaIVASucursal2() {
                    var numSucursal = $('#sucursalCte').val();
                    setTimeout("$('#cajaLista').hide();", 200);
                    if (numSucursal != '' && !isNaN(numSucursal) && esTab) {

                        sucursalesServicio.consultaSucursal(catTipoConsultaCredito.principal,numSucursal, function(sucursal) {
                            if (sucursal != null) {
                                pIVA = $('#pagaIVACte').val();

                                iva = sucursal.IVA;
                                var monto = $('#montoComision').asNumber();

                                if (pIVA == 'S') {
                                    var ivaCalc = (monto * iva);
                                    $('#IVAComApertura').val(ivaCalc);
                                    $('#IVAComApertura').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
                                }
                                if (pIVA == 'N') {
                                    $('#IVAComApertura').val('0.00');
                                }
                            }
                        });
                    }
                }

                // consulta la descripcion segun reportes regularios
                function consultaDescripClaRepReg(idControl) {
                    var jqClasific = eval("'#" + idControl + "'");
                    var Clasific = $(jqClasific).val();
                    var clasificBeanCon = {
                            'clasifRegID' : Clasific
                    };
                    if (Clasific != '' && !isNaN(Clasific) && esTab) {

                        clasifrepregServicio
                        .consulta(
                                catTipoConsultaCredito.principal,
                                clasificBeanCon,
                                function(ClasificRep) {

                                    if (ClasificRep != null) {

                                        $('#DescripClasific')
                                        .val(
                                                ClasificRep.descripcion);

                                        esTab = true;
                                    } else {
                                        mensajeSis("No Existe la Clasificación");
                                        $('#clasificacion').focus();
                                        $('#clasificacion')
                                        .select();
                                    }
                                });
                    }

                }

                function consultaParametros() {
                    var credito = $('#creditoID').val();
                    if (credito == 0) {
                        $('#fechaInicio').val(parametroBean.fechaSucursal);
                        $('#fechaInicioAmor').val(parametroBean.fechaSucursal);
                    }
                }

                // valida que los datos que se requieren para generar el
                // simulador de  amortizaciones
                function validaDatosSimulador() {
                    if ($.trim($('#producCreditoID').val()) == "") {
                        mensajeSis("Producto De Crédito Vací­o");
                        $('#producCreditoID').focus();
                        datosCompletos = false;
                    } else {
                        if ($.trim($('#clienteID').val()) == "") {
                            mensajeSis("El Cliente Está Vacío");
                            $('#clienteID').focus();
                            datosCompletos = false;
                        } else {
                            if ($('#fechaInicioAmor').val() == '') {
                                mensajeSis("Fecha de Inicio Amortizacion Vacía");
                                $('#fechaInicioAmor').focus();
                                datosCompletos = false;
                            } else {
                                if ($('#fechaVencimien').val() == '') {
                                    mensajeSis("Fecha de Vencimiento Vacía");
                                    $('#fechaVencimien').focus();
                                    datosCompletos = false;
                                } else {
                                    if ($('#tipoPagoCapital').val() == '') {
                                        mensajeSis("El Tipo de Pago de Capital Está Vací­o.");
                                        $('#tipoPagoCapital').focus();
                                        datosCompletos = false;
                                    } else {
                                        if ($('#frecuenciaCap').val() == 'U'
                                            && $('#tipoPagoCapital').val() != 'I') {
                                            mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
                                            $('#frecuenciaCap').val("");
                                            $('#frecuenciaCap').focus();
                                            datosCompletos = false;
                                        } else {
                                            /* se valida que si el tipo de pago de capital es libre, no se pueda escoger como frecuencia
                                             * la opcion de libre */
                                            if ($('#frecuenciaInt').val() == "L"  && $('#calendIrregular').val() == "N") {
                                                mensajeSis("La Frecuencia de Interés Libre sólo Aplica para Calendario Irregular.");
                                                $('#frecuenciaInt').focus();
                                                $('#frecuenciaInt').val("");
                                                datosCompletos = false;
                                            }else{
                                                if ($('#frecuenciaCap').val() == "L" && $('#calendIrregular').val() == "N") {
                                                    mensajeSis("La Frecuencia de Capital Libre sólo Aplica para Calendario Irregular.");
                                                    $('#frecuenciaCap').focus();
                                                    $('#frecuenciaCap').val("");
                                                    datosCompletos = false;
                                                }else{
                                                    if ($('#calcInteresID').val() != "") {
                                                        if ($('#calcInteresID').val() == '1') {
                                                            if ($('#tasaFija').val() == '' || $('#tasaFija').val() == '0') {
                                                                mensajeSis("Tasa de Interés Vací­a.");
                                                                $('#tasaFija').focus();
                                                                datosCompletos = false;
                                                            } else {
                                                                if ($('#montoCredito').asNumber() <= "0") {
                                                                    mensajeSis("El Monto Está Vacío.");
                                                                    $('#montoCredito').focus();
                                                                    datosCompletos = false;
                                                                } else {
                                                                    datosCompletos = true;
                                                                }
                                                            }
                                                        }else{
                                                            if ($('#calcInteresID').val() == '2' || $('#calcInteresID').val() == '3' ||  $('#calcInteresID').val() == '4') {

                                                                if($('#tasaBase').val() == '' || $('#desTasaBase').val() == ''){
                                                                    mensajeSis("Tasa Base de Interés Vací­a.");
                                                                    $('#tasaBase').focus();
                                                                    datosCompletos = false;
                                                                }else{
                                                                    if($('#sobreTasa').val() == ''){
                                                                        mensajeSis("Sobre Tasa de Interés Vací­a.");
                                                                        $('#sobreTasa').focus();
                                                                        datosCompletos = false;
                                                                    }else{
                                                                        if($('#calcInteresID').val() == '3'){
                                                                            if($('#techoTasa').val() == ''){
                                                                                mensajeSis("Techo de Tasa Base de Interés Vací­a.");
                                                                                $('#techoTasa').focus();
                                                                                datosCompletos = false;
                                                                            }else{
                                                                                if($('#pisoTasa').val() == ''){
                                                                                    mensajeSis("Piso de Tasa Base de Interés Vací­a.");
                                                                                    $('#pisoTasa').focus();
                                                                                    datosCompletos = false;
                                                                                }else{
                                                                                    datosCompletos = true;
                                                                                }
                                                                            }
                                                                        }else{
                                                                            datosCompletos = true;
                                                                        }
                                                                    }

                                                                }
                                                            }
                                                        }
                                                    } else {
                                                        mensajeSis("Seleccionar Tipo Cal. Interés");
                                                        $('#calcInteresID').focus();
                                                        datosCompletos = false;
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    return datosCompletos;
                }

                // llamada al cotizador de amortizaciones
                function simulador(){
                    parametroBean = consultaParametrosSession();
                    var fechaIni = parametroBean.fechaAplicacion;
                    var params = {};
                    if((Date.parse($('#fechaInicioAmor').val())) < (Date.parse(fechaIni))){
                        $('#fechaInicioAmor').val(fechaIni);
                    }
                    else{
                        fechaIni = parametroBean.fechaAplicacion;
                    }

                    $('#fechaInicio').val(fechaIni);
                    estatusSimulacion = true;

                    if($('#calendIrregularCheck').is(':checked')){
                        mostrarGridLibresEncabezado();
                        //Agregamos la validación para mandar los valores en caso de seleccionar dias
                        if ($('#diaPagoCapital1').is(':checked')) {
                            auxDiaPagoCapital = "F";
                        }
                        else{
                            auxDiaPagoCapital = "D";
                        }
                        if ($('#diaPagoInteres1').is(':checked')) {
                            auxDiaPagoInteres = "F";
                        }else{
                            auxDiaPagoInteres = "D";
                        }
                    }else{
                        ejecutarLlamada = validaDatosSimulador();

                        if(ejecutarLlamada == true){

                            if($('#calcInteresID').val()==1 ) {
                                if($('#tipoCalInteres').val() == '2'){
                                    tipoLista=11;
                                    $('#tipoPagoCapital').val('I').selected = true;
                                }else{
                                    switch($('#tipoPagoCapital').val()){
                                    case "C": // si el tipo de pago es CRECIENTES
                                        tipoLista = 1;
                                        break;
                                    case "I" :// si el tipo de pago es IGUALES
                                        tipoLista = 2;
                                        break;
                                    case  "L": // si el tipo de pago es LIBRES
                                        tipoLista = 3;
                                        break;
                                    default:
                                        tipoLista = 1;
                                    }
                                }
                            }else{
                                //si el tipo de calculo de interes es MontoOriginal (saldos globales)se valida tipo de Lista
                                if ($('#tipoCalInteres').val() == '2') {
                                if($('#tipoPagoCapital').val() == 'I'){

                                    tipoLista = 11;
                                }else{
                                    mensajeSis("Solo se permiten pagos de capital Iguales");
                                    return false;

                                }
                            } else {
                                switch ($('#tipoPagoCapital').val()) {
                                case "C": // si el tipo de pago es  // CRECIENTES
                                    mensajeSis("No se permiten pagos de capital Crecientes");
                                    return false;
                                    break;
                                case "I":// si el tipo de pago es // IGUALES
                                    tipoLista = 2;
                                    break;
                                case "L": // si el tipo de pago es // LIBRES
                                    tipoLista = 5;
                                    mensajeSis("No se permiten pagos de capital Libres");
                                    return false;
                                    break;
                                default:
                                    tipoLista = 2;
                                }
                            }
                            }

                            if($('#tipoPagoCapital').val() == 'L' & ($('#frecuenciaCap').val() =="D" || $('#frecuenciaInt').val()=="D")  ){
                                    mensajeSis("No se permiten Frecuencias Decenales con pagos de Capital Libres");
                                    $('#frecuenciaInt').val('S');
                                    $('#frecuenciaCap').val('S');
                                    return false;
                            }

                            if($('#tipoCalInteres').val() == '2'  & ($('#frecuenciaCap').val() =="D" || $('#frecuenciaInt').val()=="D") ){
                                mensajeSis("No se permiten Frecuencias Decenales con calculos de Interés de Tipo Monto Original");
                                $('#frecuenciaInt').val('S');
                                $('#frecuenciaCap').val('S');
                                return false;
                            }

                            // Inicio diaPagoCapital por AZamora
                            if ($('#diaPagoCapital1').is(':checked')) {
                                auxDiaPagoCapital = "F";
                            }
                            else{
                                auxDiaPagoCapital = "D";
                            }
                            if ($('#diaPagoInteres1').is(':checked')) {
                                auxDiaPagoInteres = "F";
                            }else{
                                auxDiaPagoInteres = "D";
                            }
                            // Fin diaPagoCapital por AZamora

                            params['tipoLista'] = tipoLista;

                            if($.trim($('#frecuenciaCap').val())!=""){
                                if(tipoLista == 1){
                                    // si se trata de una frecuencia de capital : MENSUAL, BIMESTRAL, TRIMESTRAL, TETRAMESTRAL, SEMESTRAL
                                    if($('#frecuenciaCap').val() =='M' || $('#frecuenciaCap').val() =='B' || $('#frecuenciaCap').val() =='T'
                                        || $('#frecuenciaCap').val() =='R'|| $('#frecuenciaCap').val() =='S'){
                                        // Si el dia de pago no esta definido
                                        if(($('#diaPagoCapital2').is(':checked')) != true &&($('#diaPagoCapital1').is(':checked')) != true ){
                                            mensajeSis("Debe Seleccionar un día de pago.");
                                            datosCompletos = false;
                                        }else{
                                            // si el dia de pago seleccionado es dia del mes
                                            if(($('#diaPagoCapital2').is(':checked')) == true && ($('#frecuenciaCap').val() =='M' || $('#frecuenciaCap').val() =='Q') ){
                                                if($.trim($('#diaMesCapital').val()) ==''|| $('#diaMesCapital').val() ==null || $('#diaMesCapital').val() =='0'){
                                                    mensajeSis("Especifique día del mes.");
                                                    $('#diaMesCapital').focus();
                                                    datosCompletos = false;
                                                }else{
                                                    // valida que el numero de amortizaciones no este vacio
                                                    if($('#numAmortizacion').asNumber() == 0){
                                                        mensajeSis("Número de cuotas vacío");
                                                        $('#numAmortizacion').focus();
                                                        datosCompletos = false;
                                                    }else{
                                                        datosCompletos = true;
                                                    }
                                                }
                                            }else{
                                                // valida que el numero de amortizaciones no este vacio
                                                if($('#numAmortizacion').asNumber() == 0){
                                                    mensajeSis("Número de cuotas vacío");
                                                    $('#numAmortizacion').focus();
                                                    datosCompletos = false;
                                                }else{
                                                    datosCompletos = true;
                                                }
                                            }
                                        }
                                    }else{
                                        if($('#numAmortizacion').asNumber() == 0){
                                            mensajeSis("Número de cuotas vacío");
                                            $('#numAmortizacion').focus();
                                            datosCompletos = false;
                                        }else{
                                            datosCompletos = true;
                                        }
                                    }
                                }else{
                                    if(tipoLista == 2 ||tipoLista ==3||tipoLista ==4||tipoLista ==5 ||tipoLista ==11){
                                        if($.trim($('#frecuenciaCap').val())!=""){
                                            if($.trim($('#frecuenciaInt').val())!=""){
                                                if($('#frecuenciaCap').val() =='M' || $('#frecuenciaCap').val() =='B'
                                                    || $('#frecuenciaCap').val() =='T'|| $('#frecuenciaCap').val() =='R'|| $('#frecuenciaCap').val() =='S'
                                                        || $('#frecuenciaInt').val() =='M'|| $('#frecuenciaInt').val() =='B'|| $('#frecuenciaInt').val() =='T'
                                                            || $('#frecuenciaInt').val() =='R'|| $('#frecuenciaInt').val() =='S'){
                                                    // Valida que este seleccionado el dia de pago para capital e interes
                                                    if(($('#diaPagoCapital1').is(':checked') != true && $('#diaPagoCapital2').is(':checked') != true)
                                                            ||($('#diaPagoInteres1').is(':checked') != true && $('#diaPagoInteres2').is(':checked') != true)){
                                                        mensajeSis('Debe Seleccionar un día de pago.');
                                                        datosCompletos = false;
                                                    }else {
                                                        // si el dia de pago seleccionado es dia del mes
                                                        if($('#diaPagoCapital2').is(':checked') == true && ($('#frecuenciaCap').val() =='M' || $('#frecuenciaCap').val() =='Q')){
                                                            if($.trim($('#diaMesCapital').val()) ==''||$('#diaMesCapital').val() ==null || $('#diaMesCapital').val() =='0'){
                                                                mensajeSis("Especifique día del mes capital.");
                                                                datosCompletos = false;
                                                            }else{
                                                                if(($.trim($('#diaMesInteres').val()) ==''||$('#diaMesInteres').val() ==null || $('#diaMesInteres').val() =='0')
                                                                        && $('#diaPagoInteres2').is(':checked') == true){
                                                                    mensajeSis("Especifique día del mes Interés.");
                                                                    datosCompletos = false;
                                                                }else{
                                                                    // valida que el numero de amortizaciones no este vacio
                                                                    if($('#numAmortizacion').asNumber() == 0){
                                                                        mensajeSis("Número de cuotas vacío");
                                                                        datosCompletos = false;
                                                                    }else{
                                                                        datosCompletos = true;
                                                                    }
                                                                }
                                                            }
                                                        }else{
                                                            // valida que el numero de amortizaciones no este vacio
                                                            if($('#numAmortizacion').asNumber() == 0){
                                                                mensajeSis("Número de cuotas vacío");
                                                                datosCompletos = false;
                                                            }else{
                                                                // valida que el nÃºmero de amortizaciones no este vacio
                                                                if($('#numAmortInteres').asNumber() == 0){
                                                                    mensajeSis("Especificar Número de Cuotas de Interés.");
                                                                    $('#numAmortInteres').focus();
                                                                    datosCompletos =false;
                                                                }else{
                                                                    datosCompletos =true;
                                                                }
                                                            }
                                                        }
                                                    }
                                                }else{
                                                    // valida que el numero de amortizaciones no este vacio
                                                    if($('#numAmortizacion').asNumber() == 0){
                                                        mensajeSis("Número de cuotas vacío");
                                                        datosCompletos = false;
                                                    }else{
                                                        // valida que el nÃºmero de amortizaciones no este vacio
                                                        if($('#numAmortInteres').asNumber() == 0){
                                                            mensajeSis("Especificar Número de Cuotas de Interés.");
                                                            $('#numAmortInteres').focus();
                                                            datosCompletos =false;
                                                        }else{
                                                            datosCompletos =true;
                                                        }
                                                    }
                                                }
                                            }else{
                                                mensajeSis("Seleccionar Frecuencia de Interés.");
                                                $('#frecuenciaInt').focus();
                                                datosCompletos = false;
                                            }
                                        }else{
                                            mensajeSis("Seleccionar Frecuencia de Capital.");
                                            $('#frecuenciaCap').focus();
                                            datosCompletos = false;
                                        }
                                    }
                                }



                                if(datosCompletos){
                                    //Inicio Segemtno agregado Quincenal por AZamora
                                    if ($('#diaPagoCapital1').is(':checked')) {
                                        auxDiaPagoCapital = "F";
                                    }
                                    else{
                                        auxDiaPagoCapital = "D";
                                    }
                                    if ($('#diaPagoInteres1').is(':checked')) {
                                        auxDiaPagoInteres = "F";
                                    }else{
                                        auxDiaPagoInteres = "D";
                                    }

                                    /* Validaciones Quincenal para el simulador*/
                                    if ( $('#frecuenciaCap').val() == 'Q'  && $('#diaPagoCapitalD').is(':checked')) {
                                        auxDiaPagoCapital = "D";
                                    }
                                    if ( $('#frecuenciaInt').val() == 'Q'  && $('#diaPagoInteresD').is(':checked')) {
                                        auxDiaPagoInteres = "D";
                                    }

                                    if ( $('#frecuenciaCap').val() == 'Q'  && $('#diaPagoCapitalQ').is(':checked')) {
                                        auxDiaPagoCapital = "Q";
                                    }
                                    if ( $('#frecuenciaInt').val() == 'Q'  && $('#diaPagoInteresQ').is(':checked')) {
                                        auxDiaPagoInteres = "Q";
                                    }
                                    /* Validaciones Quincenal */

                                    //Fin Segemtno agregado Quincenal por AZamora

                                    params['montoCredito']      = $('#montoCredito').asNumber();

                                    if($('#calcInteresID').val() == '1'){
                                        params['tasaFija']       = $('#tasaFija').val();
                                    }else{
                                        params['tasaFija']       = parseFloat(valorTasaBase) + $('#sobreTasa').asNumber();
                                    }

                                    params['frecuenciaCap']     = $('#frecuenciaCap').val();
                                    params['frecuenciaInt']     = $('#frecuenciaInt').val();
                                    params['periodicidadCap']   = $('#periodicidadCap').val();
                                    params['periodicidadInt']   = $('#periodicidadInt').val();
                                    params['producCreditoID']   = $('#producCreditoID').val();
                                    params['clienteID']         = $('#clienteID').val();
                                    params['montoComision']     = $('#montoComision').asNumber();
                                    params['diaPagoCapital']    = auxDiaPagoCapital; // Variables agregadas para el diaPagoCapital por AZamora
                                    params['diaPagoInteres']    = auxDiaPagoInteres; // Variables agregadas para el diaPagoInteres por AZamora
                                    params['diaPagoCapital']    = $('#diaPagoCapital').val();
                                    params['diaPagoInteres']    = $('#diaPagoInteres').val();
                                    params['diaMesCapital']     = $('#diaMesCapital').val();
                                    params['diaMesInteres']     = $('#diaMesInteres').val();
                                    params['fechaInicio']       = $('#fechaInicioAmor').val();
                                    params['numAmortizacion']   = $('#numAmortizacion').asNumber();
                                    params['numAmortInteres']   = $('#numAmortInteres').asNumber();
                                    params['fechaInhabil']      = $('#fechaInhabil').val();

                                    params['ajusFecUlVenAmo']   = $('#ajusFecUlVenAmo').val();
                                    params['ajusFecExiVen']     = $('#ajusFecExiVen').val();
                                    params['montoGarLiq']       = $('#aporteCliente').asNumber();
                                    params['numTransacSim']     = '0';
                                    params['empresaID']         = parametroBean.empresaID;
                                    params['usuario']           = parametroBean.numeroUsuario;
                                    params['fecha']             = parametroBean.fechaSucursal;
                                    params['direccionIP']       = parametroBean.IPsesion;
                                    params['sucursal']          = parametroBean.sucursal;
                                    params['cobraSeguroCuota']  = $('#cobraSeguroCuota option:selected').val();
                                    params['cobraIVASeguroCuota']   = $('#cobraIVASeguroCuota option:selected').val();
                                    params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
                                    params['plazoID']           = $('#plazoID').val();
                                    params['tipoOpera']         = 1;
                                    params['cobraAccesorios']   = cobraAccesorios;
                                    params['comAnualLin']       = $('#comAnualLin').val();
                                    params['convenioNominaID']  = $('#convenioNominaID').asNumber();

                                    var numeroError = 0;
                                    var mensajeTransaccion = "";
                                    bloquearPantallaAmortizacion();
                                    if($('#tipoPagoCapital').val()!="L"){
                                        $.post("simPagCredito.htm",params,function(data) {
                                            if (data.length > 0 || data != null) {
                                                $('#contenedorSimulador').html(data);
                                                if ( $("#numeroErrorList").length ) {
                                                    numeroError = $('#numeroErrorList').asNumber();
                                                    mensajeTransaccion = $('#mensajeErrorList').val();
                                                }

                                                if(numeroError==0){
                                                    $('#contenedorSimulador').show();
                                                    $('#contenedorSimuladorLibre').html("");
                                                    $('#contenedorSimuladorLibre').hide();
                                                    $('#numTransacSim').val($('#transaccion').val());

                                                    // actualiza la nueva fecha de vencimiento que devuelve el cotizador
                                                    var jqFechaVen = eval("'#fech'");
                                                    $('#fechaVencimien').val($(jqFechaVen).val());

                                                    // asigna el valor de cat devuelto por el cotizador
                                                    $('#cat').val($('#valorCat').val());

                                                    $('#cat').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 1});

                                                    // asigna el valor de monto de la cuota devuelto por el cotizador
                                                    if($('#tipoPagoCapital').val() == 'C'){
                                                        $('#montoCuota').val($('#valorMontoCuota').val());
                                                    }else{
                                                        $('#montoCuota').val('0.00');
                                                    }

                                                    // actualiza el numero de cuotas generadas por el cotizador
                                                    $('#numAmortInteres').val($('#valorCuotasInt').val());
                                                    $('#numAmortizacion').val($('#cuotas').val());
                                                    NumCuotas =  $('#cuotas').val();  // se utiliza para saber si agregar una cuota mas o restar una

                                                    // Si el tipo de capital es iguales o saldos globales devuelve numero de cuotas de interes
                                                    if($('#tipoPagoCapital').val() == 'I' || tipoLista== 11){
                                                        $('#numAmortInteres').val($('#valorCuotasInt').val());
                                                        NumCuotasInt = $('#valorCuotasInt').val(); //  se utiliza para saber si agregar una cuota mas o restar una
                                                    }

                                                    if(requiereSeg=='S' &&  $.trim($('#fechaVencimien').val()) != ""){
                                                        //calculaNodeDias($(jqFechaVen).val()); //ljuarez Se comenta esta linea a peticion de Fchia 13/10/2014 con consentimiento de QA

                                                        // calculaNodeDias($(jqFechaVen).val()); //cjeronimo Se descomenta esta linea a peticion de sjimenez y amartinez 11/12/2014 con consentimiento de QA

                                                        // calculaNodeDias($(jqFechaVen).val()); // se comenta esta linea a peticion de sjimenez para que el nuevo calculo de seguro

                                                        // lo haga hasta el pagare y no se incremente el monto de credito cada vez que se haga una simulacion en esta pantalla
                                                    }
                                                    habilitarBotonesCre();
                                                    if ($('#siguiente').is(':visible') && $('#anterior').is(':visible')==false){
                                                        $('#filaTotales').hide();
                                                    }

                                                    if ($('#siguiente').is(':visible')==false && $('#anterior').is(':visible')==false){
                                                        $('#filaTotales').show();
                                                    }


                                                    $('#imprimirRep').hide(); // uuuu

                                                    if ($('#tipoCalInteres').val() == '2' && $('#tipoPagoCapital').val() == "I") {
                                                        $('#montoCuota').val($('#valorMontoCuota').val());
                                                        $('#montoCuota').formatCurrency({
                                                            positiveFormat : '%n',
                                                            roundToDecimalPlace : 2
                                                        });
                                                    }
                                                    
                                                    if ($('#tipoCalInteres').val() == '2' && cobraAccesorios == 'S') {
                                                        desgloseOtrasComisiones($('#numTransacSim').val());
                                                    }
                                                }
                                            } else{
                                                $('#contenedorSimulador').html("");
                                                $('#contenedorSimulador').hide();
                                                $('#contenedorSimuladorLibre').html("");
                                                $('#contenedorSimuladorLibre').hide();
                                            }
                                            $('#contenedorForma').unblock();
                                            agregaFormatoControles('formaGenerica');

                                            /****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
                                            if(numeroError!=0){
                                                $('#contenedorForma').unblock({fadeOut: 0,timeout:0});
                                                mensajeSisError(numeroError,mensajeTransaccion);
                                            }
                                            /**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
                                        });
                                    }else{
                                        $.post("simPagLibresCapCredito.htm", params, function(data){ // todo
                                            if(data.length >0 || data != null) {
                                                $('#contenedorSimuladorLibre').html(data);
                                                if ( $("#numeroErrorList").length ) {
                                                    numeroError = $('#numeroErrorList').asNumber();
                                                    mensajeTransaccion = $('#mensajeErrorList').val();
                                                }
                                                if(numeroError==0){
                                                    $('#contenedorSimuladorLibre').show();
                                                    $('#contenedorSimulador').html("");
                                                    $('#contenedorSimulador').hide();
                                                    $('#numTransacSim').val($('#transaccion').val());
                                                    // actualiza la nueva fecha de vencimiento que devuelve el cotizador
                                                    var jqFechaVen = eval("'#fech'");
                                                    $('#fechaVencimien').val($(jqFechaVen).val());


                                                    $('#montoCuota').val("0.0");

                                                    // actualiza el numero de cuotas generadas por el cotizador
                                                    $('#numAmortInteres').val($('#valorCuotasInt').val());
                                                    $('#numAmortizacion').val($('#cuotas').val());
                                                    calculaDiferenciaSimuladorLibre();
                                                    calculoTotalCapital();
                                                    calculoTotalInteres();
                                                    calculoTotalIva();

                                                    $('#imprimirRep').hide(); // uuuu

                                                    $("#cat").val($('#valorCat').val());
                                                    $('#cat').formatCurrency({
                                                                positiveFormat : '%n',
                                                                roundToDecimalPlace : 1
                                                            });
                                                    
                                                    if ($('#tipoCalInteres').val() == '2' && cobraAccesorios == 'S') {
                                                        desgloseOtrasComisiones($('#numTransacSim').val());
                                                    }
                                                }
                                            }else{
                                                $('#contenedorSimuladorLibre').html("");
                                                $('#contenedorSimuladorLibre').hide();
                                                $('#contenedorSimulador').html("");
                                                $('#contenedorSimulador').hide();
                                            }
                                            $('#contenedorForma').unblock();
                                            agregaFormatoControles('formaGenerica');


                                            /****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
                                            if(numeroError!=0){
                                                $('#contenedorForma').unblock({fadeOut: 0,timeout:0});
                                                mensajeSisError(numeroError,mensajeTransaccion);
                                            }
                                            /**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/

                                            deshabilitaBoton('agrega','submit');
                                            deshabilitaBoton('modifica','submit');
                                        });
                                    }

                                }
                            }else{
                                mensajeSis("Seleccionar Frecuencia de Capital.");
                                $('#frecuenciaCap').focus();
                                datosCompletos = false;
                            }
                        }
                    }
                }// fin funcion simulador()

                // Función para consultar los Dias Requeridos en la Primera AMortización para Solicitudes con Tipo de Pago de Capital: LIBRES
                function consultaSolCredLibre() {
                    var numSolicitud = $('#solicitudCreditoID').asNumber();
                    var tipoConsulta = 14;

                    var SolCredBeanCon ={
                         'solicitudCreditoID' : numSolicitud
                    };

                    setTimeout("$('#cajaLista').hide();", 200);
                    if(numSolicitud != '' && !isNaN(numSolicitud)){
                        solicitudCredServicio.consulta(tipoConsulta,SolCredBeanCon,function(solicitud) {
                            if(solicitud.valorParametro == "S"){

                                if(solicitud.diasReqPrimerAmor > 0 ){
                                    if(solicitud.fechaActual > solicitud.fechaVencimiento){
                                        mensajeSis('La Solicitud Tiene Pagos de Capital Libre, <br>No es posible Autorizar la Solicitud de Crédito, la Fecha del Sistema es mayor a la Fecha de Vencimiento de la Primera Amortización.');
                                    }
                                    else if(parseInt(solicitud.numDiasVenPrimAmor) < parseInt(solicitud.diasReqPrimerAmor)){
                                        mensajeSis('La Solicitud Tiene Pagos de Capital Libre, los Días Mínimos Requeridos para la Primera Amortización son '+solicitud.diasReqPrimerAmor+ ' días.');
                                    }
                                    else if(solicitud.fechaActual == solicitud.fechaVencimiento){
                                        mensajeSis('La Solicitud Tiene Pagos de Capital Libre, No es posible Simular el Crédito, la Fecha de Vencimiento de la Primera Amortización es igual a la Fecha del Sistema.');
                                    }
                                    else {
                                        consultaSimulador();
                                    }
                                }else{
                                    mensajeSis('La Solicitud Tiene Pagos de Capital Libre, los Días Requeridos para la Primera Amortización No se encuentra Registrada.');
                                }

                            }else{
                                consultaSimulador();
                            }
                        });
                    }
                }

                // llamada al sp que consulta el simulador de amortizaciones
                function consultaSimulador(){
                    var fechaIni = $('#fechaInicioAmor').val();
                    $('#fechaInicio').val(fechaIni);

                    if((Date.parse($('#fechaInicioAmor').val())) < (Date.parse(parametroBean.fechaAplicacion))){
                        $('#fechaInicioAmor').val(parametroBean.fechaAplicacion);
                        var fechaIni = $('#fechaInicioAmor').val();
                        $('#fechaInicio').val(fechaIni);

                    }
                    estatusSimulacion = true;
                    $("#montoCuota").val('0.00');
                    $("#cat").val('0.0');
                    var params = {};
                    if($('#solicitudCreditoID').asNumber()>0 ){
                        tipoLista = 9;
                    }else{
                        if($('#calendIrregularCheck').is(':checked')){
                            // calendario irregular
                            tipoLista = 7;
                        }else{
                            if($('#calcInteresID').val()==1 ) {
                                switch($('#tipoPagoCapital').val()){
                                case "C": // si el tipo de pago es CRECIENTES
                                    tipoLista = 1;
                                    break;
                                case "I" :// si el tipo de pago es IGUALES
                                    tipoLista = 2;
                                    break;
                                case  "L": // si el tipo de pago es LIBRES
                                    tipoLista = 3;
                                    break;
                                default:
                                    tipoLista = 1;
                                }
                            }else{
                                //si el tipo de calculo de interes es MontoOriginal (saldos globales)se valida tipo de Lista
                                if ($('#tipoCalInteres').val() == '2') {
                                if($('#tipoPagoCapital').val() == 'I'){

                                    tipoLista = 11;
                                }else{
                                    mensajeSis("Solo se permiten pagos de capital Iguales");
                                    return false;

                                }
                            } else {
                                switch ($('#tipoPagoCapital').val()) {
                                case "C": // si el tipo de pago es  // CRECIENTES
                                    mensajeSis("No se permiten pagos de capital Crecientes");
                                    return false;
                                    break;
                                case "I":// si el tipo de pago es // IGUALES
                                    tipoLista = 2;
                                    break;
                                case "L": // si el tipo de pago es // LIBRES
                                    tipoLista = 5;
                                    mensajeSis("No se permiten pagos de capital Libres");
                                    return false;
                                    break;
                                default:
                                    tipoLista = 4;
                                }
                            }
                            }
                        }
                    }

                    validarEventoFrecuencia();

                    params['tipoLista'] = tipoLista;

                    params['numTransacSim']     = $('#numTransacSim').asNumber();
                    bloquearPantallaAmortizacion();
                    params['cobraSeguroCuota']  = $('#cobraSeguroCuota option:selected').val();
                    params['cobraIVASeguroCuota']   = $('#cobraIVASeguroCuota option:selected').val();
                    params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
                    params['plazoID']           = $('#plazoID').val();
                    params['tipoOpera']     = 1;
                    params['cobraAccesorios']   = cobraAccesorios;

                    var numeroError = 0;
                    var mensajeTransaccion = "";
                     $.post("listaSimuladorConsulta.htm",params,function(data) {
                        if (data.length > 0 || data != null) {
                            $('#contenedorSimuladorLibre').html(data);
                            if ( $("#numeroErrorList").length ) {
                                numeroError = $('#numeroErrorList').asNumber();
                                mensajeTransaccion = $('#mensajeErrorList').val();
                            }
                                if(numeroError==0){
                                $('#contenedorSimuladorLibre').show();
                                $('#contenedorSimulador').html("");
                                $('#contenedorSimulador').hide();
                                $('#totalCap').val(totalizaCap());
                                $('#totalInt').val(totalizaInt());
                                $('#totalIva').val(totalizaIva());
                                $('#totalCap').formatCurrency({
                                    positiveFormat : '%n',
                                    roundToDecimalPlace : 2
                                });
                                $('#totalInt').formatCurrency({
                                    positiveFormat : '%n',
                                    roundToDecimalPlace : 2
                                });
                                $('#totalIva').formatCurrency({
                                    positiveFormat : '%n',
                                    roundToDecimalPlace : 2
                                });
                                $('#imprimirRep').hide();
                                $("#cat").val($('#valorCat').val());
                                $('#cat').formatCurrency({
                                            positiveFormat : '%n',
                                            roundToDecimalPlace : 1
                                    });

                                $('tr[name=renglon]').each(function() {
                                    var numero= this.id.substr(7,this.id.length);
                                    var jqFecha = eval("'#fechaVencim" + numero+ "'");
                                    var jqFechaVen ="";
                                    var jqFechaVen = $(jqFecha).val();
                                    var numFilas = consultaFilas();

                                    maxRegistro = 0;

                                    for(var i=0,len=numero.length;i<len;i++){
                                        if(maxRegistro < numero[i]){
                                            maxRegistro = numero[i];
                                        }
                                    }
                                    // actualiza la nueva fecha de vencimiento que devuelve el cotizador
                                    if(numFilas == maxRegistro) {
                                        var jqFechaFin ="";
                                        var jqFechaFin = $(jqFecha).val();
                                        $('#fechaVencimien').val(jqFechaFin);
                                    }

                                });
                            }
                        } else{
                            $('#contenedorSimuladorLibre').html("");
                            $('#contenedorSimuladorLibre').hide();
                            $('#contenedorSimulador').html("");
                            $('#contenedorSimulador').hide();
                        }
                        $('#contenedorForma').unblock();
                        agregaFormatoControles('formaGenerica');
                        /****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
                        if(numeroError!=0){
                            $('#contenedorForma').unblock({fadeOut: 0,timeout:0});
                            mensajeSisError(numeroError,mensajeTransaccion);
                        }
                        /**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
                    });

                }// fin funcion consultaSimulador()


                // Consulta total de filas del grid
                function consultaFilas(){
                    var totales=0;
                    $('tr[name=renglon]').each(function() {
                        totales++;
                    });
                    return totales;
                }

                function simuladorPagosLibresTasaVar(numTransac, cuotas) {
                    var mandar = crearMontosCapital(numTransac);
                    $('#numAmortizacion').val(cuotas);
                    $('#numTransacSim').val(numTransac);
                    var jqFechaVen = eval("'#fechaVencim" + cuotas + "'");
                    if ($('#ajusFecUlVenAmo2').is(':checked')) {
                        $('#fechaVencimien').val($(jqFechaVen).val());
                    }
                    if (mandar == 2) {
                        var params = {};

                        quitaFormatoControles('formaGenerica');

                        if ($('#calcInteresID').val() == 1) {
                            if ($('#tipoPagoCapital').is(':checked')) {
                                tipoLista = 1;
                            }
                        }

                        params['tipoLista'] = tipoLista;
                        params['montoCredito'] = $('#montoCredito').val();
                        params['producCreditoID'] = $('#producCreditoID').val();
                        params['clienteID'] = $('#clienteID').val();

                        params['empresaID'] = parametroBean.empresaID;
                        params['usuario'] = parametroBean.numeroUsuario;
                        params['fecha'] = parametroBean.fechaSucursal;
                        params['direccionIP'] = parametroBean.IPsesion;
                        params['sucursal'] = parametroBean.sucursal;
                        params['numTransaccion'] = $('#numTransacSim').val();
                        params['numTransacSim'] = $('#numTransacSim').val();

                        params['montosCapital'] = $('#montosCapital').val();
                        params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
                        params['plazoID']           = $('#plazoID').val();
                        params['tipoOpera']     = 1;
                        params['cobraAccesorios']   = cobraAccesorios;

                        var numeroError = 0;
                        var mensajeTransaccion = "";
                        $.post("simPagLibresCredito.htm", params, function(data) {
                            if (data.length > 0) {
                                $('#contenedorSimulador').html(data);
                                if ( $("#numeroErrorList").length ) {
                                    numeroError = $('#numeroErrorList').asNumber();
                                    mensajeTransaccion = $('#mensajeErrorList').val();
                                }
                                if(numeroError==0){
                                    $('#contenedorSimulador').show();

                                    var valorTransaccion = $('#transaccion').val();
                                    $('#numTransacSim').val(valorTransaccion);
                                    mensajeSis("Datos Guardados");
                                    $('#totalCap').val(totalizaCap());
                                    $('#totalInt').val(totalizaInt());
                                    $('#totalIva').val(totalizaIva());
                                    $('#totalCap').formatCurrency({
                                        positiveFormat : '%n',
                                        roundToDecimalPlace : 2
                                    });
                                    $('#totalInt').formatCurrency({
                                        positiveFormat : '%n',
                                        roundToDecimalPlace : 2
                                    });
                                    $('#totalIva').formatCurrency({
                                        positiveFormat : '%n',
                                        roundToDecimalPlace : 2
                                    });
                                    $('#imprimirRep').hide(); // uuuu
                                }
                            } else {
                                $('#contenedorSimulador').html("");
                                $('#contenedorSimulador').show();
                            }
                            agregaFormatoControles('formaGenerica');
                            /****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
                            if(numeroError!=0){
                                $('#contenedorForma').unblock({fadeOut: 0,timeout:0});
                                mensajeSisError(numeroError,mensajeTransaccion);
                            }
                            /**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
                        });
                    }

                }




                // valida que el monto del credito no sea mayor al saldo de
                // la linea (creditos con linea)
                function consultaMonto(idControl) {
                    var jqNumMonto = eval("'#" + idControl + "'");
                    var monto = $(jqNumMonto).asNumber();
                    var saldo = $('#saldoLineaCred').asNumber();

                    if (monto > saldo) {
                        mensajeSis("El monto del credito no puede ser mayor al Saldo de la linea.");
                        $('#montoCredito').focus();
                        $('#montoCredito').select();
                    }

                }

                // consulta cuenta del cliente
                function consultaCta(idControl) {
                    var jqCta = eval("'#" + idControl + "'");
                    var numCta = $(jqCta).val();

                    var CuentaAhoBeanCon = {
                            'cuentaAhoID' : numCta,
                            'clienteID' : $('#clienteID').val()
                    };
                    setTimeout("$('#cajaLista').hide();", 200);
                    if (numCta != '' && !isNaN(numCta) && esTab) {
                        cuentasAhoServicio.consultaCuentasAho(3,CuentaAhoBeanCon,function(cuenta) {
                            if (cuenta != null) {
                                var cte = $('#clienteID').asNumber();
                                var client = parseFloat(cuenta.clienteID);
                                $('#monedaID').val(cuenta.monedaID);
                                if (client != cte) {
                                    mensajeSis("La cuenta no corresponde con el Cliente");
                                    $('#cuentaID').focus();
                                    $('#cuentaID').val("");
                                }else{
                                    if($('#lineaCreditoID').asNumber() != 0){
                                        esTab = true;
                                        consultaLineaCredito('lineaCreditoID');
                                    }
                                    consultacicloCliente();// Consulta del Ciclo del Cliente
                                }
                            }else {
                                mensajeSis("No Existe la cuenta");
                                $('#cuentaID').focus();
                                $('#cuentaID').select();
                            }
                        });
                    }
                }

                // consulta la cuenta principal del cliente
                function consultaCuentaPrincipal() {

                    var cte = $('#clienteID').val();
                    var CuentaAhoBeanCon = {
                            'clienteID'     :cte
                    };
                    setTimeout("$('#cajaLista').hide();", 200);
                    if(cte != '' && !isNaN(cte) && cte > 0){
                        cuentasAhoServicio.consultaCuentasAho(15,CuentaAhoBeanCon,function(cuenta) {
                            if(cuenta!=null){
                                $('#cuentaID').val(cuenta.cuentaAhoID);
                            }else{
                                mensajeSis("El Cliente no tiene una Cuenta principal Activa");
                                deshabilitaBoton('graba');
                                $('#cuentaID').focus();
                                $('#cuentaID').select();
                            }
                        });
                    }
                }

                // Asigna valor por default a consultaSIC
                function consultaSICParam() {
                    var parametrosSisCon ={
                            'empresaID' : 1
                    };
                    setTimeout("$('#cajaLista').hide();", 200);
                    parametrosSisServicio.consulta(1,parametrosSisCon, function(parametroSistema) {
                        if (parametroSistema != null) {
                            if (parametroSistema.conBuroCreDefaut == 'B') { // si tiene por default Buro
                                $('#tipoConsultaSICBuro').attr("checked",true);
                                $('#tipoConsultaSICCirculo').attr("checked",false);
                                $('#consultaBuro').show();
                                $('#consultaCirculo').hide();
                                $('#folioConsultaCC').val('');
                                $('#tipoConsultaSIC').val('BC');

                            }else if (parametroSistema.conBuroCreDefaut == 'C'){    // si tiene por default Circulo
                                $('#tipoConsultaSICBuro').attr("checked",false);
                                $('#tipoConsultaSICCirculo').attr("checked",true);
                                $('#consultaBuro').hide();
                                $('#consultaCirculo').show();
                                $('#folioConsultaBC').val('');
                                $('#tipoConsultaSIC').val('CC');
                            }
                        }
                    });
                }


                // Solo se ejecuta cuando consulta el cliente de la solicitud de credito
                function consultaClienteSolici(idControl) {
                    var jqCliente = eval("'#" + idControl + "'");
                    var numCliente = $(jqCliente).val();
                    var tipConForanea = 2;
                    setTimeout("$('#cajaLista').hide();", 200);
                    if (numCliente != '' && !isNaN(numCliente) && esTab) {
                        clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
                            if (cliente != null) {
                                $('#clienteID').val(cliente.numero);
                                $('#nombreCliente').val(cliente.nombreCompleto);
                                consultacicloCliente();

                                 habilitaBoton('grabaSF');
                                 habilitaBoton('graba');
                               
                                
                            } else {
                                if(var_permiteProspecto == permiteSolicitudProspecto){
                                    mensajeSis('El Prospecto debe ser Cliente');
                                    deshabilitaBoton('agrega');
                                } else {
                                    mensajeSis("La Solicitud de Credito no tiene un Cliente Valido");
                                    deshabilitaBoton('grabaSF');
                                    deshabilitaBoton('graba');
                                    $('#solicitudCreditoID').focus();
                                    $('#solicitudCreditoID').select();
                                }

                            }
                        });
                    }
                }

                // consulta de la tasa de credito
                function consultaTasaCredito(idControl) {
                    var monto = idControl;
                    var cte = $('#clienteID').val();
                    var numCred = ''; // variable numero del ciclo del
                    // Cliente
                    var esGrup = 'S'; // Si
                    var cicloCte = $('#cicloCliente').asNumber();
                    var cicloCteGrup = $('#cicloClienteGrupal').asNumber();
                    var producCredesGrup = $('#esGrupal').val();
                    var producCredPondeGrup = $('#tasaPonderaGru').val();
                    if (cte == '') {
                        $('#clienteID').val('0');
                        $('#pagaIVACte').val('S');
                    }
                    if (cicloCteGrup != 0 && producCredesGrup == esGrup
                            && producCredPondeGrup == esGrup) {// If para
                        // tomar el valor si el producto de credito es grupal y ademas que si sea ponderado
                        numCred = cicloCteGrup;
                    } else {
                        numCred = cicloCte;
                    }
                    setTimeout("$('#cajaLista').hide();", 200);
                    var credBeanCon = {
                            'clienteID'         : $('#clienteID').asNumber(),
                            'sucursal'      : parametroBean.sucursal,
                            'producCreditoID'   : $('#producCreditoID').asNumber(),
                            'montoCredito'      : monto,
                            'calificaCliente'   : $('#calificaCliente').val(),
                            'plazoID'       : $('#plazoID').val()

                    };
                    if (monto != '' && !isNaN(monto)) {
                        creditosServicio.consultaTasa(numCred,credBeanCon,function(tasas) {
                            if (tasas != null) {
                                if (tasas.valorTasa > 0) {
                                    $('#tasaFija').val(tasas.valorTasa).change();

                                } else {
                                    $('#tasaFija').val("0.00").change();
                                    mensajeSis("No Hay una Tasa Parametrizada para los Valores Indicados.");
                                    $('#montoCredito').val(montoinicial);
                                    $('#plazoID').val('').selected = true;
                                    $('#plazoID').focus();
                                    montoFinal=0;
                                    ++contasa;
                                }
                                $('#montoCredito').formatCurrency({
                                    positiveFormat : '%n',
                                    negativeFormat : '%n',
                                    roundToDecimalPlace : 2
                                });
                            } else {
                                mensajeSis("No Hay una Tasa Parametrizada para los Valores Indicados.");
                                $('#tasaFija').val('0.00').change();
                                $('#montoCredito').val(montoinicial);
                                $('#plazoID').val('').selected = true;
                                $('#plazoID').focus();
                                montoFinal=0;
                            }
                        });
                    }
                }

                /*
                 * Metodo para consultar las condiciones del calendario segun el tipo de producto seleccionado y sólo se ocupa
                 * cuando se trata de una solicitud nueva para dar de alta, se dispara cuando el producto de credito pierde el foco */

                function consultaCalendarioPorProducto(idControl) {
                    var jqproducto = eval("'#" + idControl + "'");
                    var producto = $(jqproducto).val();
                    var TipoConPrin = 1;
                    var calendarioBeanCon = {
                            'productoCreditoID' : producto
                    };
                    setTimeout("$('#cajaLista').hide();", 200);
                    if (producto != '' && !isNaN(producto) && esTab) {
                        calendarioProdServicio.consulta(TipoConPrin,calendarioBeanCon,function(calendario) {
                        if (calendario != null) {
                            if (calendario.fecInHabTomar == 'S') {
                                $('#fechInhabil1').attr('checked',true);
                                $('#fechInhabil2').attr("checked",false);
                                habilitaControl('fechInhabil1');
                                deshabilitaControl('fechInhabil2');
                                $('#fechInhabil').val("S");
                                } else {
                                    $('#fechInhabil2').attr('checked',true);
                                    $('#fechInhabil1').attr("checked",false);
                                    deshabilitaControl('fechInhabil1');
                                    habilitaControl('fechInhabil2');
                                    $('#fechInhabil').val("A");
                                }


                                if (calendario.ajusFecExigVenc == 'S') {
                                    $('#ajusFecExiVen1').attr('checked',true);
                                    $('#ajusFecExiVen2').attr("checked",false);
                                    $('#ajusFecExiVen').val("S");
                                    habilitaControl('ajusFecExiVen1');
                                    deshabilitaControl('ajusFecExiVen2');
                                } else {
                                    $('#ajusFecExiVen1').attr("checked",false);
                                    $('#ajusFecExiVen2').attr('checked',true);
                                    $('#ajusFecExiVen').val("N");
                                    deshabilitaControl('ajusFecExiVen1');
                                    habilitaControl('ajusFecExiVen2');
                                }


                                if (calendario.permCalenIrreg == 'S') {
                                    $('#calendIrregular').val("N");
                                    habilitaControl('calendIrregularCheck');
                                    $('#calendIrregularCheck').attr("checked",false);
                                } else {
                                    if (calendario.permCalenIrreg == 'N' && $('#estatus').val() == 'I') {
                                        deshabilitaControl('calendIrregularCheck');
                                    }
                                    $('#calendIrregularCheck').attr('checked',false);
                                    $('#calendIrregular').val("N");
                                }

                                if (calendario.ajusFecUlAmoVen == 'S') {
                                    $('#ajusFecUlVenAmo1').attr("checked","1");
                                    $('#ajusFecUlVenAmo2').attr("checked",false);
                                    $('#ajusFecUlVenAmo').val("S");
                                    habilitaControl('ajusFecUlVenAmo1');
                                    deshabilitaControl('ajusFecUlVenAmo2');
                                } else {
                                    $('#ajusFecUlVenAmo1').attr("checked",false);
                                    $('#ajusFecUlVenAmo2').attr('checked',true);
                                    $('#ajusFecUlVenAmo').val("N");
                                    deshabilitaControl('ajusFecUlVenAmo1');
                                    habilitaControl('ajusFecUlVenAmo2');
                                }

                                if (calendario.iguaCalenIntCap == 'S') {
                                    $('#perIgual').val("S");
                                    deshabilitaControl('frecuenciaInt');
                                    deshabilitaControl('numAmortInteres');
                                    $("#numAmortInteres").val($("#numAmortizacion").val());

                                } else {

                                    if (calendario.iguaCalenIntCap == 'N') {
                                        $('#perIgual').val("N");
                                        habilitaControl('frecuenciaInt');
                                        habilitaControl('numAmortInteres');
                                    }

                                }


                                // VALIDA el dia de pago de capital
                                switch (calendario.diaPagoCapital) {

                                case "F": // SI ES FIN DE MES
                                        $('#diaPagoProd').val("F");
                                        habilitaControl('diaPagoCapital1');
                                        deshabilitaControl('diaPagoCapital2');
                                        $('#diaPagoCapital1').attr('checked',true);
                                        $('#diaPagoCapital2').attr('checked',false);
                                        $('#diaPagoCapital').val("F");
                                        deshabilitaControl('diaMesCapital');
                                        $('#diaMesCapital').val('');

                                            deshabilitaControl('diaPagoInteres1');
                                            deshabilitaControl('diaPagoInteres2');
                                            $('#diaPagoInteres1').attr('checked',true);
                                            $('#diaPagoInteres2').attr('checked',false);
                                            $('#diaPagoInteres').val("F");
                                            $('#diaMesInteres').val('');
                                            deshabilitaControl('diaMesInteres');
                                    break;

                                case "A": // SI ES POR ANIVERSARIO
                                        $('#diaPagoProd').val("A");
                                        deshabilitaControl('diaPagoCapital1');
                                        deshabilitaControl('diaPagoCapital2');
                                        $('#diaPagoCapital2').attr('checked',true);
                                        $('#diaPagoCapital1').attr('checked',false);
                                        $('#diaMesCapital').val(diaSucursal);
                                        $('#diaPagoCapital').val("D");
                                        deshabilitaControl('diaMesCapital');

                                            deshabilitaControl('diaPagoInteres1');
                                            deshabilitaControl('diaPagoInteres2');
                                            $('#diaPagoInteres2').attr('checked',true);
                                            $('#diaPagoInteres1').attr('checked',false);
                                            $('#diaPagoInteres').val("D");
                                            $('#diaMesInteres').val(diaSucursal);
                                            deshabilitaControl('diaMesInteres');

                                    break;

                                case "D": // DIA DEL MES
                                        $('#diaPagoProd').val("D");
                                        deshabilitaControl('diaPagoCapital1');
                                        deshabilitaControl('diaPagoCapital2');
                                        $('#diaPagoCapital2').attr('checked',true);
                                        $('#diaPagoCapital1').attr('checked',false);
                                        $('#diaPagoCapital').val("D");
                                        habilitaControl('diaMesCapital');
                                        $('#diaMesCapital').val(diaSucursal);

                                            deshabilitaControl('diaPagoInteres1');
                                            deshabilitaControl('diaPagoInteres2');
                                            $('#diaPagoInteres2').attr('checked',true);
                                            $('#diaPagoInteres1').attr('checked',false);
                                            $('#diaPagoInteres').val("D");
                                            $('#diaMesInteres').val(diaSucursal);
                                            habilitaControl('diaMesInteres');


                                    break;

                                case "I": // SI ES INDISTINTO
                                        $('#diaPagoProd').val("I");
                                        habilitaControl('diaPagoCapital1');
                                        habilitaControl('diaPagoCapital2');
                                        $('#diaPagoCapital1').attr('checked',true);
                                        $('#diaPagoCapital2').attr('checked',false);
                                        $('#diaPagoCapital').val("F");
                                        deshabilitaControl('diaMesCapital'); // se deshabilita xq por default se cheque fin de mes
                                        $('#diaMesCapital').val('');

                                            habilitaControl('diaPagoInteres1');
                                            habilitaControl('diaPagoInteres2');
                                            $('#diaPagoInteres1').attr('checked',true);
                                            $('#diaPagoInteres2').attr('checked',false);
                                            $('#diaPagoInteres').val("F");
                                            $('#diaMesInteres').val('');
                                            deshabilitaControl('diaMesInteres');

                                            if (calendario.iguaCalenIntCap == 'S') {
                                                deshabilitaControl('diaPagoInteres1');
                                                deshabilitaControl('diaPagoInteres2');
                                            }

                                    break;

                                default:
                                        $('#diaPagoProd').val("I");
                                        habilitaControl('diaPagoCapital1');
                                        habilitaControl('diaPagoCapital2');
                                        $('#diaPagoCapital1').attr('checked',true);
                                        $('#diaPagoCapital2').attr('checked',false);
                                        $('#diaPagoCapital').val("F");
                                        deshabilitaControl('diaMesCapital');
                                        $('#diaMesCapital').val('');

                                            habilitaControl('diaPagoInteres1');
                                            habilitaControl('diaPagoInteres2');
                                            $('#diaPagoInteres1').attr('checked',true);
                                            $('#diaPagoInteres2').attr('checked',false);
                                            $('#diaPagoInteres').val("F");
                                            $('#diaMesInteres').val('');
                                            deshabilitaControl('diaMesInteres');

                                            if (calendario.iguaCalenIntCap == 'S') {
                                                deshabilitaControl('diaPagoInteres1');
                                                deshabilitaControl('diaPagoInteres2');
                                            }
                                break;

                        }

                                consultaComboTipoPagoCap(calendario.tipoPagoCapital);
                                consultaComboFrecuencias(calendario.frecuencias);
                                consultaComboPlazos(calendario.plazoID);
                                consultaComboTipoDispersion(calendario.tipoDispersion);
                } else {
                        mensajeSis("No Existe un Calendario de Pagos para el Producto de Crédito Indicado.");
                    }
            });
        }
    }

                /* Metodo para consultar las condiciones del calendario segun el tipo de producto seleccionado y sólo se ocupa
                 * cuando se trata de una consulta */
                function consultaCalendarioPorProductoCredito(producto,valorTipoPagoCapital, valorFrecuenciaCap,valorFrecuenciaInt, valorPlazoID,valorTipoDispersion) {
                    var TipoConPrin = 1;
                    var calendarioBeanCon = {
                            'productoCreditoID' : producto
                    };
                    setTimeout("$('#cajaLista').hide();", 200);
                    if (producto != '' && !isNaN(producto)) {
                        calendarioProdServicio.consulta(TipoConPrin,calendarioBeanCon,function(calendario) {
                        if (calendario != null) {
                            if (calendario.fecInHabTomar == 'S') {
                                habilitaControl('fechaInhabil1');
                                deshabilitaControl('fechaInhabil2');
                            } else {
                                deshabilitaControl('fechaInhabil1');
                                habilitaControl('fechaInhabil2');
                            }

                            if (calendario.ajusFecExigVenc == 'S') {
                                habilitaControl('ajusFecExiVen1');
                                deshabilitaControl('ajusFecExiVen2');
                            } else {
                                deshabilitaControl('ajusFecExiVen1');
                                habilitaControl('ajusFecExiVen2');
                            }

                            if (calendario.permCalenIrreg == 'S') {
                            /*
                            deshabilitaControl('tipoPagoCapital');

                            deshabilitaControl('frecuenciaInt');

                            deshabilitaControl('frecuenciaCap');   */
                            } else {
                                if (calendario.permCalenIrreg == 'N' && $('#estatus').val() == 'I'&&  $('#solicitudCreditoID').asNumber()<= 0) {
                                    deshabilitaControl('calendIrregularCheck');                                                                     /*
                                    deshabilitaControl('tipoPagoCapital');
                                    deshabilitaControl('frecuenciaInt');
                                    deshabilitaControl('frecuenciaCap'); */
                                }
                            }

                            if (calendario.ajusFecUlAmoVen == 'S') {
                                habilitaControl('ajusFecUlVenAmo1');
                                deshabilitaControl('ajusFecUlVenAmo2');
                            } else {
                                deshabilitaControl('ajusFecUlVenAmo1');
                                habilitaControl('ajusFecUlVenAmo2');
                            }


                            // VALIDA el dia de pago de capital
                            switch (calendario.diaPagoCapital) {
                                case "F": // SI ES FIN DE MES

                                    $('#diaPagoProd').val("F");
                                    habilitaControl('diaPagoCapital1');
                                    deshabilitaControl('diaPagoCapital2');
                                    deshabilitaControl('diaMesCapital');

                                    deshabilitaControl('diaPagoInteres1');
                                    deshabilitaControl('diaPagoInteres2');
                                    deshabilitaControl('diaMesInteres');
                                    break;
                            case "A": // SI ES POR ANIVERSARIO

                                    $('#diaPagoProd').val("A");
                                    deshabilitaControl('diaPagoCapital1');
                                    deshabilitaControl('diaPagoCapital2');
                                    deshabilitaControl('diaMesCapital');

                                    deshabilitaControl('diaPagoInteres1');
                                    deshabilitaControl('diaPagoInteres2');
                                    deshabilitaControl('diaMesInteres');
                                    break;
                            case "D": // DIA DEL MES

                                $('#diaPagoProd').val("D");
                                deshabilitaControl('diaPagoCapital1');
                                deshabilitaControl('diaPagoCapital2');

                                deshabilitaControl('diaPagoInteres1');
                                deshabilitaControl('diaPagoInteres2');

                                if ($('#diaPagoCapital1').is(':checked')) {
                                    deshabilitaControl('diaMesCapital');
                                    deshabilitaControl('diaMesInteres');
                                }else{
                                    habilitaControl('diaMesCapital');
                                    habilitaControl('diaMesInteres');
                                }
                                break;

                            case "I": // SI ES INDISTINTO

                                $('#diaPagoProd').val("I");
                                habilitaControl('diaPagoCapital1');
                                habilitaControl('diaPagoCapital2');

                                habilitaControl('diaPagoInteres1');
                                habilitaControl('diaPagoInteres2');

                            if ($('#diaPagoCapital1').is(':checked')) {
                                deshabilitaControl('diaMesCapital');
                                deshabilitaControl('diaMesInteres');
                            }else{
                                habilitaControl('diaMesCapital');
                                habilitaControl('diaMesInteres');
                            }

                            if (calendario.iguaCalenIntCap == 'S') {
                                deshabilitaControl('diaPagoInteres1');
                                deshabilitaControl('diaPagoInteres2');
                            }

                            break;
                        default:

                                $('#diaPagoProd').val("I");
                                habilitaControl('diaPagoCapital1');
                                deshabilitaControl('diaPagoCapital2');
                                deshabilitaControl('diaMesCapital');

                                deshabilitaControl('diaPagoInteres1');
                                deshabilitaControl('diaPagoInteres2');
                                deshabilitaControl('diaMesInteres');
                                break;
                    }

                    if (calendario.iguaCalenIntCap == 'S') {
                            $('#perIgual').val("S");// se llama funcion para deshabilitar calendario de interes
                            deshabilitarCalendarioPagosInteres();
                    } else {
                            if (calendario.iguaCalenIntCap == 'N') {
                                $('#perIgual').val("N");
                            }
                    }

                    // cuando el credito es por solicitud de credito tambien se bloque el calendario de capital
                    if(parseInt($("#solicitudCreditoID").val()) > 0 ){
                        deshabilitaControl('diaPagoCapital1');
                        deshabilitaControl('diaPagoCapital2');
                        deshabilitaControl('diaMesCapital');
                    }

                    // se consultan los valores que trae la solicitud
                    consultaComboTipoPagoCapCredito(calendario.tipoPagoCapital,valorTipoPagoCapital);
                    consultaComboFrecuenciasCredito(calendario.frecuencias,valorFrecuenciaCap,valorFrecuenciaInt);
                    consultaComboPlazosCredito( calendario.plazoID, valorPlazoID); // se llena el combo de plazos
                    consultaComboTipoDispersionCredito( calendario.tipoDispersion,valorTipoDispersion); // se llena el combo de tipo de dispersion
                } else {
                        mensajeSis("No Existe un Calendario de Pagos para el Producto de Crédito Indicado.");
                }
            });
        }
    }

                // funcion que llena el combo de plazos, de acuerdo al producto sólo cuando se trata de un credito nuevo
                function consultaComboPlazos(varPlazos) {
                    // se eliminan los tipos de pago que se tenian
                    $('#plazoID').each(function() {
                        $('#plazoID option').remove();
                    });
                    // se agrega la opcion por default
                    $('#plazoID').append(
                            new Option('SELECCIONAR', '', true, true));

                    if (varPlazos != null) {
                        var plazo = varPlazos.split(',');
                        var tamanio = plazo.length;
                        plazosCredServicio.listaCombo(3, {
                        async : false,
                        callback :function(plazoCreditoBean) {
                                    for ( var i = 0; i < tamanio; i++) {
                                        for ( var j = 0; j < plazoCreditoBean.length; j++) {
                                            if (plazo[i] == plazoCreditoBean[j].plazoID) {
                                                $('#plazoID').append(new Option(plazoCreditoBean[j].descripcion,plazo[i],true,true));
                                                $('#plazoID').val(varPlazos).selected = true;
                                                break;
                                            }
                                        }
                                    }
                                }});


                    }
                }

                // funcion que llena el combo de plazos, de acuerdo al
                // producto
                // se usa cuando se consulta un credito
                function consultaComboPlazosCredito(varPlazos, plazoValor) {
                    // se eliminan los tipos de pago que se tenian
                    $('#plazoID').each(function() {
                        $('#plazoID option').remove();
                    });
                    // se agrega la opcion por default
                    $('#plazoID').append(
                            new Option('SELECCIONAR', '', true, true));
                    if (varPlazos != null) {
                        var plazo = varPlazos.split(',');
                        var tamanio = plazo.length;
                        plazosCredServicio
                        .listaCombo(
                                3,
                                function(plazoCreditoBean) {
                                    for ( var i = 0; i < tamanio; i++) {
                                        for ( var j = 0; j < plazoCreditoBean.length; j++) {
                                            if (plazo[i] == plazoCreditoBean[j].plazoID) {
                                                $('#plazoID')
                                                .append(
                                                        new Option(
                                                                plazoCreditoBean[j].descripcion,
                                                                plazo[i],
                                                                true,
                                                                true));
                                                $('#plazoID').val(
                                                        plazoValor).selected = true;
                                                break;
                                            }
                                        }
                                    }
                                });
                    }
                }

                // funcion que llena el combo de tipo de pago capital, de acuerdo al producto
                // se usa sólo cuando se trata de una solicitud nueva que se dara de alta
                function consultaComboTipoPagoCap(tipoPago) {
                    // se eliminan los tipos de pago que se tenian
                    $('#tipoPagoCapital').each(function() {
                        $('#tipoPagoCapital option').remove();
                    });
                    // se agrega la opcion por default
                    $('#tipoPagoCapital').append(
                            new Option('SELECCIONAR', '', true, true));

                    if (tipoPago != null) {
                        var tpago = tipoPago.split(',');
                        var tamanio = tpago.length;
                        for ( var i = 0; i < tamanio; i++) {
                            var pagDescrip = '';

                            switch (tpago[i]) {
                            case "C": // si el tipo de pago es CRECIENTES
                                pagDescrip = 'CRECIENTES';
                                break;
                            case "I":// si el tipo de pago es IGUALES
                                pagDescrip = 'IGUALES';
                                break;
                            case "L": // si el tipo de pago es LIBRES
                                pagDescrip = 'LIBRES';
                                break;
                            default:
                                pagDescrip = 'CRECIENTES';
                            }
                            $('#tipoPagoCapital').append(
                                    new Option(pagDescrip, tpago[i], true,
                                            true));
                            if($('#tipoCalInteres').val() == '2'){
                                $('#tipoPagoCapital').val('I').selected = true;
                                deshabilitaControl('tipoPagoCapital');
                            }else{
                                $('#tipoPagoCapital').val('').selected = true;   // se selecciona la opcion por defaul
                                habilitaControl('tipoPagoCapital');
                            }
                        }
                    }
                }

                // funcion que llena el combo de tipo de pago capital, de
                // acuerdo al producto
                // se usa sólo cuando se trata de una consulta de solicitud
                function consultaComboTipoPagoCapCredito(tipoPago, valor) {
                    if (tipoPago != null) {
                        // se eliminan los tipos de pago que se tenian
                        $('#tipoPagoCapital').each(function() {
                            $('#tipoPagoCapital option').remove();
                        });
                        // se agrega la opcion por default
                        $('#tipoPagoCapital').append(
                                new Option('SELECCIONAR', '', true, true));

                        var tpago = tipoPago.split(',');
                        var tamanio = tpago.length;
                        for ( var i = 0; i < tamanio; i++) {
                            var pagDescrip = '';
                            switch (tpago[i]) {
                            case "C": // si el tipo de pago es CRECIENTES
                                pagDescrip = 'CRECIENTES';
                                break;
                            case "I":// si el tipo de pago es IGUALES
                                pagDescrip = 'IGUALES';
                                break;
                            case "L": // si el tipo de pago es LIBRES
                                pagDescrip = 'LIBRES';
                                break;
                            default:
                                pagDescrip = 'CRECIENTES';
                            }
                            $('#tipoPagoCapital').append(
                                    new Option(pagDescrip, tpago[i], true,
                                            true));
                            $('#tipoPagoCapital').val(valor).selected = true; // se selecciona la opcion por defaul
                        }
                    }
                }

                // funcion que llena el combo de Frecuencias, de acuerdo al
                // producto
                // se utiliza sólo cuando se da de alta una solicitud de
                // credito nueva.
                function consultaComboFrecuencias(frecuencia) {
                    if (frecuencia != null) {
                        // se eliminan los tipos de pago que se tenian
                        $('#frecuenciaCap').each(function() {
                            $('#frecuenciaCap option').remove();
                        });
                        // se agrega la opcion por default
                        $('#frecuenciaCap').append(
                                new Option('SELECCIONAR', '', true, true));

                        // se eliminan los tipos de pago que se tenian
                        $('#frecuenciaInt').each(function() {
                            $('#frecuenciaInt option').remove();
                        });
                        // se agrega la opcion por default
                        $('#frecuenciaInt').append(
                                new Option('SELECCIONAR', '', true, true));

                        var frec = frecuencia.split(',');
                        var tamanio = frec.length;

                        for ( var i = 0; i < tamanio; i++) {
                            var frecDescrip = '';

                            switch (frec[i]) {
                            case "S": // SEMANAL
                                frecDescrip = 'SEMANAL';
                                break;
                            case "C":// CATORCENAL
                                frecDescrip = 'CATORCENAL';
                                break;
                            case "D":// CATORCENAL
                                frecDescrip = 'DECENAL';
                                break;
                            case "Q": // QUINCENAL
                                frecDescrip = 'QUINCENAL';
                                break;
                            case "M": // MENSUAL
                                frecDescrip = 'MENSUAL';
                                break;
                            case "B": // BIMESTRAL
                                frecDescrip = 'BIMESTRAL';
                                break;
                            case "T": // TRIMESTRAL
                                frecDescrip = 'TRIMESTRAL';
                                break;
                            case "R": // TETRAMESTRAL
                                frecDescrip = 'TETRAMESTRAL';
                                break;
                            case "E": // SEMESTRAL
                                frecDescrip = 'SEMESTRAL';
                                break;
                            case "A": // ANUAL
                                frecDescrip = 'ANUAL';
                                break;
                            case "P": // PERIODO
                                frecDescrip = 'PERIODO';
                                break;
                            case "U": // PAGO UNICO
                                frecDescrip = 'PAGO UNICO';
                                break;
                            case "L": // PAGO UNICO
                                frecDescrip = 'LIBRE';
                                break;
                            default:
                                frecDescrip = 'SEMANAL';
                            }
                            $('#frecuenciaCap').append(new Option(frecDescrip, frec[i], true,true));
                            $('#frecuenciaInt').append(
                                    new Option(frecDescrip, frec[i], true,
                                            true));
                            $('#frecuenciaCap').val('').selected = true;
                            $('#frecuenciaInt').val('').selected = true;
                        }
                    }
                }

                // funcion que llena el combo de Frecuencias, de acuerdo al producto se utiliza sólo cuando se consulta una solicitud de credito
                function consultaComboFrecuenciasCredito(frecuencia,
                        valorCap, valorInt) {
                    if (frecuencia != null) {
                        // se eliminan los tipos de pago que se tenian
                        $('#frecuenciaCap').each(function() {
                            $('#frecuenciaCap option').remove();
                        });
                        // se agrega la opcion por default
                        $('#frecuenciaCap').append(
                                new Option('SELECCIONAR', '', true, true));

                        // se eliminan los tipos de pago que se tenian
                        $('#frecuenciaInt').each(function() {
                            $('#frecuenciaInt option').remove();
                        });
                        // se agrega la opcion por default
                        $('#frecuenciaInt').append(
                                new Option('SELECCIONAR', '', true, true));

                        var frec = frecuencia.split(',');
                        var tamanio = frec.length;

                        for ( var i = 0; i < tamanio; i++) {
                            var frecDescrip = '';

                            switch (frec[i]) {
                            case "S": // SEMANAL
                                frecDescrip = 'SEMANAL';
                                break;
                            case "D": // DECENAL
                                frecDescrip = 'DECENAL';
                                break;
                            case "C":// CATORCENAL
                                frecDescrip = 'CATORCENAL';
                                break;
                            case "Q": // QUINCENAL
                                frecDescrip = 'QUINCENAL';
                                break;
                            case "M": // MENSUAL
                                frecDescrip = 'MENSUAL';
                                break;
                            case "B": // BIMESTRAL
                                frecDescrip = 'BIMESTRAL';
                                break;
                            case "T": // TRIMESTRAL
                                frecDescrip = 'TRIMESTRAL';
                                break;
                            case "R": // TETRAMESTRAL
                                frecDescrip = 'TETRAMESTRAL';
                                break;
                            case "E": // SEMESTRAL
                                frecDescrip = 'SEMESTRAL';
                                break;
                            case "A": // ANUAL
                                frecDescrip = 'ANUAL';
                                break;
                            case "P": // PERIODO
                                frecDescrip = 'PERIODO';
                                break;
                            case "U": // PAGO UNICO
                                frecDescrip = 'PAGO UNICO';
                                break;
                            case  "L": // PAGO LIBRE
                                frecDescrip = 'LIBRE';
                                break;
                            default:
                                frecDescrip = 'SEMANAL';
                            }
                            $('#frecuenciaCap').append(
                                    new Option(frecDescrip, frec[i], true,
                                            true));
                            $('#frecuenciaInt').append(
                                    new Option(frecDescrip, frec[i], true,
                                            true));
                            $('#frecuenciaCap').val(valorCap).selected = true;
                            $('#frecuenciaInt').val(valorInt).selected = true;
                        }
                    }
                }

                // funcion que llena el combo tipo dispersion, de acuerdo al producto se usa cuando se da de alta una solicitud nueva
                function consultaComboTipoDispersion(tiposDispersion) {
                    if (tiposDispersion != null) {
                        // se eliminan los tipos de pago que se tenian
                        $('#tipoDispersion').each(function() {
                            $('#tipoDispersion option').remove();
                        });
                        // se agrega la opcion por default
                        $('#tipoDispersion').append(
                                new Option('SELECCIONAR', '', true, true));

                        var tipoDispersion = tiposDispersion.split(',');
                        var tamanio = tipoDispersion.length;
                        for ( var i = 0; i < tamanio; i++) {
                            switch (tipoDispersion[i]) {
                            case "S": // SPEI
                                disperDescrip = 'SPEI';
                                break;
                            case "C":// CHEQUE
                                disperDescrip = 'CHEQUE';
                                break;
                            case "O": // ORDEN DE PAGO
                                disperDescrip = 'ORDEN DE PAGO';
                                break;
                            case "E": // EFECTIVO
                                disperDescrip = 'EFECTIVO';
                                break;
                            case "A": // EFECTIVO
                                disperDescrip = 'TRAN. SANTANDER';
                                break;
                            default:
                                disperDescrip = 'SPEI';
                            }

                            $('#tipoDispersion').append(
                                    new Option(disperDescrip,
                                            tipoDispersion[i], true, true));
                            $('#tipoDispersion').val('').selected = true;
                        }
                    }
                }

                // funcion que llena el combo tipo dispersion, de acuerdo al producto se usa cuando se consulta una solicitud de credito
                function consultaComboTipoDispersionCredito(
                        tiposDispersion, valor) {
                    if (tiposDispersion != null) {
                        // se eliminan los tipos de pago que se tenian
                        $('#tipoDispersion').each(function() {
                            $('#tipoDispersion option').remove();
                        });
                        // se agrega la opcion por default
                        $('#tipoDispersion').append(
                                new Option('SELECCIONAR', '', true, true));

                        var tipoDispersion = tiposDispersion.split(',');
                        var tamanio = tipoDispersion.length;
                        for ( var i = 0; i < tamanio; i++) {
                            switch (tipoDispersion[i]) {
                            case "S": // SPEI
                                disperDescrip = 'SPEI';
                                break;
                            case "C":// CHEQUE
                                disperDescrip = 'CHEQUE';
                                break;
                            case "O": // ORDEN DE PAGO
                                disperDescrip = 'ORDEN DE PAGO';
                                break;
                            case "E": // EFECTIVO
                                disperDescrip = 'EFECTIVO';
                                break;
                            case "A": // TRAN. SANTANDER
                                disperDescrip = 'TRAN. SANTANDER';
                                break;
                            default:
                                disperDescrip = 'SPEI';
                            }

                            $('#tipoDispersion').append(
                                    new Option(disperDescrip,
                                            tipoDispersion[i], true, true));
                            $('#tipoDispersion').val(valor).selected = true;
                        }
                    }
                }
                // funcion que deshabilita parametros calendario de producto
                // de credito
                function deshabilitaParamCalendario() {
                    deshabilitaControl('fechaInhabil1');
                    deshabilitaControl('fechaInhabil2');
                    deshabilitaControl('ajusFecExiVen1');
                    deshabilitaControl('ajusFecExiVen2');
                    deshabilitaControl('diaPagoInteres2');
                    deshabilitaControl('ajusFecUlVenAmo1');
                    deshabilitaControl('ajusFecUlVenAmo2');
                    deshabilitaControl('fechaVencimien');
                }

                // consulta de la fecha de vencimiento en base al plazo
                function consultaFechaVencimiento(idControl) {

                    var jqPlazo = eval("'#" + idControl + "'");
                    var plazo = $(jqPlazo).val();
                    var tipoCon = 3;
                    var PlazoBeanCon = {
                            'plazoID' : plazo,
                            'fechaActual' : $('#fechaInicioAmor').val(),
                            'frecuenciaCap' : $('#frecuenciaCap').val()
                    };
                    if (plazo == '') {
                        $('#fechaVencimien').val("");
                        consultaComisionAper();

                    } else {
                        plazosCredServicio.consulta(tipoCon,PlazoBeanCon,function(plazos) {
                            if (plazos != null) {
                                $('#fechaVencimien').val(plazos.fechaActual);
                                if ($('#frecuenciaCap').val() != "U") {
                                    $('#numAmortizacion').val(plazos.numCuotas);

                                    if ($('#tipoPagoCapital').val() == 'C') {
                                        $('#numAmortInteres').val(plazos.numCuotas);
                                        NumCuotasInt = plazos.numCuotas; // se utiliza para saber cuando se agrega o quita una cuota
                                    } else {
                                        $('#numAmortizacion').val(plazos.numCuotas);
                                        if ($('#perIgual').val() == "S") {
                                            $('#numAmortInteres').val(plazos.numCuotas);
                                            NumCuotasInt = plazos.numCuotas; // se utiliza para saber cuando se agrega o quita unacuota
                                        } else {
                                            consultaCuotasInteres('plazoID');
                                        }
                                    }
                                    NumCuotas = plazos.numCuotas; // utiliza para saber cuando se agrega o quita una cuota calculo de numero de dias
                                    calculaNodeDias(plazos.fechaActual);

                                } else {
                                    $('#numAmortizacion').val("1");
                                    NumCuotas = 1; // se utiliza para saber cuando se agrega o quita una cuota
                                    calculaNodeDias(plazos.fechaActual);
                                }
                                fechaVencimientoInicial = plazos.fechaActual;
                                consultaComisionAper();
                            }else{

                                consultaComisionAper();
                            }
                        });
                    }

                }// fin consultaFechaVencimiento

                function consultaDestinoCredito(idControl) {
                    var Comercial = 'C';
                    var Consumo = 'O';

                    var jqDestino = eval("'#" + idControl + "'");
                    var DestCred = $(jqDestino).val();
                    var tipoCon = 2;
                    var DestCredBeanCon = {
                            'destinoCreID' : DestCred
                    };
                    setTimeout("$('#cajaLista').hide();", 200);
                    if (DestCred != '' && !isNaN(DestCred) && esTab) {
                        destinosCredServicio .consulta( tipoCon, DestCredBeanCon, function(destinos) {
                            if (destinos != null) {
                                $('#descripDestino').val(destinos.descripcion);
                                $('#descripDestinoFR').val(destinos.desCredFR);
                                $('#descripDestinoFOMUR').val(destinos.desCredFOMUR);
                                $('#destinCredFRID').val(destinos.destinCredFRID);
                                $('#destinCredFOMURID').val(destinos.destinCredFOMURID);
                                $('#clasiDestinCred').val(destinos.clasificacion);
                                if (destinos.clasificacion == Comercial) {
                                    $('#clasificacionDestin1').attr("checked",true);
                                    $('#clasificacionDestin2').attr("checked",false);
                                    $('#clasificacionDestin3').attr("checked",false);
                                } else if (destinos.clasificacion == Consumo) {
                                    $('#clasificacionDestin1').attr("checked",false);
                                    $('#clasificacionDestin2').attr("checked",true);
                                    $('#clasificacionDestin3').attr("checked",false);
                                } else {
                                    $('#clasificacionDestin1').attr("checked",false);
                                    $('#clasificacionDestin2').attr("checked",false);
                                    $('#clasificacionDestin3').attr("checked",true);
                                }
                            }else {
                                mensajeSis("No Existe el Destino de Crédito");
                                $('#destinoCreID').focus();
                                $('#destinoCreID').select();
                                $('#destinoCreID').val("");
                                $('#descripDestino').val("");
                            }
                        });
                    }
                }// fin consultaDestinoCredito

                // -----------consulta el destino de credito, este  metodo se llama
                // cuando se consulta la solicitud ya que para consultar se consulta
                // el campo de Clasificacion que se encuentra en la tabla de
                // solictud de credito o credito . y no la de
                // la tabla de DESTINOSCREDITO
                function consultaDestinoCreditoSolicitud(idControl) {
                    var jqDestino = eval("'#" + idControl + "'");
                    var DestCred = $(jqDestino).val();
                    var tipoCon = 2;
                    var DestCredBeanCon = {
                            'destinoCreID' : DestCred
                    };
                    setTimeout("$('#cajaLista').hide();", 200);
                    if (DestCred != '' && !isNaN(DestCred) && esTab) {
                        destinosCredServicio.consulta(tipoCon,DestCredBeanCon,function(destinos) {
                            if (destinos != null) {
                                $('#descripDestino').val(destinos.descripcion);
                                $('#descripDestinoFR').val(destinos.desCredFR);
                                $('#descripDestinoFOMUR').val(destinos.desCredFOMUR);
                                $('#destinCredFRID').val(destinos.destinCredFRID);
                                $('#destinCredFOMURID').val(destinos.destinCredFOMURID);
                            }else {
                                mensajeSis("No Existe el Destino de Crédito");
                                $('#destinoCreID').focus();
                                $('#destinoCreID').select();
                            }
                        });
                    }
                }// fin consultaDestinoCreditoSolicitud


                // consulta de la linea de fondeo
                function consultaLineaFondeo(idControl) {
                    $('#tipoFondeo2').click();
                    var jqLineaFon = eval("'#" + idControl + "'");
                    var numLinea = $(jqLineaFon).val();
                    var tipoCon = 1;
                    setTimeout("$('#cajaLista').hide();", 200);
                    if (numLinea != '' && !isNaN(numLinea) && esTab) {
                        var lineaFondBeanCon = {
                                'lineaFondeoID' : numLinea
                        };

                        lineaFonServicio.consulta(tipoCon,lineaFondBeanCon,function(lineaFond) {
                            if (lineaFond != null) {
                                $('#lineaFondeo').val(lineaFond.lineaFondeoID);
                                $('#descripLineaFon').val(lineaFond.descripLinea);
                                $('#saldoLineaFon').val(lineaFond.saldoLinea);
                                $('#institutFondID').val(lineaFond.institutFondID);
                                $('#tasaPasiva').val(lineaFond.tasaPasiva);
                                $('#folioFondeo').val(lineaFond.folioFondeo);

                                $('#saldoLineaFon').formatCurrency({
                                    positiveFormat : '%n',
                                    roundToDecimalPlace : 2
                                });
                                validaCreditoSaldoLineaFondeo();
                            } else {
                                var linea = $('#lineaFondeo').val();
                                if (linea != '0') {
                                    mensajeSis("No Existe la Linea Fondeador");
                                    $('#lineaFondeo').focus();
                                    $('#lineaFondeo').select();
                                }
                            }
                        });
                    }
                }// fin consultaLineaFondeo

                // valida el saldo de la linea de fondeo
                function validaCreditoSaldoLineaFondeo() {
                    quitaFormatoControles('formaGenerica');
                    var saldoLinFon = $('#saldoLineaFon').val();
                    var montoCred = $('#montoCredito').val();
                    var saldo = parseFloat(saldoLinFon);
                    var monto = parseFloat(montoCred);
                    agregaFormatoControles('formaGenerica');
                    if (monto > saldo) {
                        mensajeSis("La Linea de Fondeo no tiene Saldo suficiente");
                    }
                }// fin validaCreditoSaldoLineaFondeo

                // funcion para deshabilitar los controles de la solicitud
                // de credito (cuando son creditos por solicitud)
                function deshabilitaControlesSolicitud() {
                    habilitaControl('lineaCreditoID');
                    deshabilitaControl('clienteID');
                    //deshabilitaControl('cuentaID');
                    deshabilitaControl('destinoCreID');
                    deshabilitaControl('producCreditoID');
                    deshabilitaControl('montoCredito');
                    deshabilitaControl('monedaID');
                    deshabilitaControl('relacionado');
                    deshabilitaControl('plazoID');
                    deshabilitaControl('tipoDispersion');
                    deshabilitaControl('tipoPagoCapital');
                    deshabilitaControl('frecuenciaCap');
                    deshabilitaControl('frecuenciaInt');
                    deshabilitaControl('diaPagoCapital1');
                    deshabilitaControl('diaPagoCapital2');
                    deshabilitaControl('diaPagoCapitalD');
                    deshabilitaControl('diaPagoCapitalQ');
                    deshabilitaControl('diaPagoInteres1');
                    deshabilitaControl('diaPagoInteres2');
                    deshabilitaControl('diaPagoInteresD');
                    deshabilitaControl('diaPagoInteresQ');
                    deshabilitaControl('diaMesInteres');
                    deshabilitaControl('diaMesCapital');
                    deshabilitaControl('tipoFondeo');
                    deshabilitaControl('tipoFondeo2');
                    deshabilitaControl('lineaFondeo');
                    deshabilitaControl('institFondeoID');
                    deshabilitaControl('tasaFija');
                    deshabilitaControl('numAmortizacion');
                    deshabilitaControl('diaMesInteres');
                    deshabilitaControl('diaMesCapital');
                    deshabilitaControl('tipPago');
                }

                // funcion para habilitar los controles de la solicitud de
                // credito (cuando son creditos por solicitud)
                function habilitaControlesSolicitud() {
                    habilitaControl('lineaCreditoID');
                    habilitaControl('clienteID');
                    habilitaControl('cuentaID');
                    habilitaControl('destinoCreID');
                    habilitaControl('producCreditoID');
                    habilitaControl('montoCredito');
                    habilitaControl('plazoID');
                    habilitaControl('tipoDispersion');
                    habilitaControl('cuentaCLABE');
                    habilitaControl('tipoPagoCapital');
                    habilitaControl('frecuenciaCap');
                    habilitaControl('frecuenciaInt');
                    habilitaControl('diaPagoCapital1');
                    habilitaControl('diaPagoCapital2');
                    habilitaControl('diaPagoCapitalD');
                    habilitaControl('diaPagoCapitalQ');
                    habilitaControl('diaPagoInteres1');
                    habilitaControl('diaPagoInteres2');
                    habilitaControl('diaPagoInteresD');
                    habilitaControl('diaPagoInteresQ');
                    habilitaControl('diaMesInteres');
                    habilitaControl('diaMesCapital');
                    habilitaControl('tipoFondeo');
                    habilitaControl('tipoFondeo2');
                    habilitaControl('institFondeoID');
                    habilitaControl('lineaFondeo');
                    habilitaControl('numAmortizacion');
                    habilitaControl('diaMesInteres');
                    habilitaControl('diaMesCapital');
                    habilitaControl('tipPago');
                }

                // funcion para habilitar los controles cuando es un alta de
                // credito
                function habilitaControlesAlta() {
                    habilitaControl('monedaID');
                    habilitaControl('fechaInicioAmor');
                    habilitaControl('clienteID');
                    habilitaControl('cuentaID');
                    habilitaControl('tipoFondeo');
                    habilitaControl('tipoFondeo2');
                    habilitaControl('lineaFondeo');
                    habilitaControl('producCreditoID');
                    habilitaControl('destinoCreID');
                    habilitaControl('calcInteresID');
                    habilitaControl('fechaInhabil1');
                    habilitaControl('fechaInhabil2');
                    habilitaControl('tasaFija');
                    habilitaControl('frecuenciaCap');
                    habilitaControl('frecuenciaInt');
                    habilitaControl('montoCredito');
                    habilitaControl('ajusFecExiVen1');
                    habilitaControl('ajusFecExiVen2');
                    habilitaControl('ajusFecUlVenAmo1');
                    habilitaControl('ajusFecUlVenAmo2');
                    habilitaControl('montoCuota');
                    habilitaControl('numAmortInteres');
                    habilitaControl('numAmortizacion');
                    $('#numAmortInteres').val($('#numAmortInteres').asNumber());
                    $('#numAmortizacion').val($('#numAmortizacion').asNumber());
                    deshabilitaControl('relacionado');
                    habilitaControl('tipPago');

                }

                // funcion para habilitar los controles cuando es un alta de
                // credito
                function habilitaControlesDarAlta() {
                    habilitaControl('clienteID');
                    habilitaControl('cuentaID');
                    habilitaControl('tipoFondeo');
                    habilitaControl('tipoFondeo2');
                    habilitaControl('institFondeoID');
                    habilitaControl('lineaFondeo');
                    habilitaControl('producCreditoID');
                    habilitaControl('destinoCreID');
                    if($('#calendIrregular').val() == 'N'){
                        habilitaControl('tipoPagoCapital');
                        habilitaControl('frecuenciaCap');
                        habilitaControl('frecuenciaInt');
                    }else{
                        deshabilitaControl('tipoPagoCapital');
                        deshabilitaControl('frecuenciaCap');
                        deshabilitaControl('frecuenciaInt');
                    }

                    habilitaControl('montoCredito');
                    habilitaControl('tipoDispersion');
                    habilitaControl('plazoID');
                    habilitaControl('numAmortizacion');
                    habilitaControl('lineaCreditoID');
                    deshabilitaControl('relacionado');
                    $('#simular').show();
                    habilitaControl('tipPago');

                }

                // consulta la fecha de vencimiento si se cambia el valor de
                // la cuota de capital cambia
                function consultaFechaVencimientoCuotas(idControl) {
                    var jqPlazo = eval("'#" + idControl + "'");
                    var plazo = $(jqPlazo).val();
                    var tipoCon = 4;

                    var PlazoBeanCon = {
                            'frecuenciaCap' : $('#frecuenciaCap').val(),
                            'numCuotas' : $('#numAmortizacion').val(),
                            'periodicidadCap' : $('#periodicidadCap').val(),
                            'fechaActual' : $('#fechaInicioAmor').val()
                    };
                    if (plazo == '0') {
                        $('#fechaVencimien').val("");
                    } else {
                        plazosCredServicio.consulta(tipoCon, PlazoBeanCon,
                                function(plazos) {
                            if (plazos != null) {
                                $('#fechaVencimien').val(
                                        plazos.fechaActual);
                            }
                        });
                    }
                }

                // consulta las cuotas de interes
                function consultaCuotasInteres(idControl) {
                    var jqPlazo = eval("'#" + idControl + "'");
                    var plazo = $(jqPlazo).val();
                    var tipoCon = 3;

                    var PlazoBeanCon = {
                            'plazoID' : plazo,
                            'fechaActual' : $('#fechaInicioAmor').val(),
                            'frecuenciaCap' : $('#frecuenciaInt').val()
                    };
                    if (plazo == '0') {
                        $('#fechaVencimien').val("");
                    } else {
                        plazosCredServicio.consulta(tipoCon, PlazoBeanCon,
                                function(plazos) {
                            if (plazos != null) {
                                $('#numAmortInteres').val(
                                        plazos.numCuotas);
                                NumCuotasInt = plazos.numCuotas;
                            }
                        });
                    }
                }

                function consultaParentesco(idControl) {
                    var jqParentesco = eval("'#" + idControl + "'");
                    var numParentesco = $(jqParentesco).val();
                    var tipConPrincipal = 1;
                    setTimeout("$('#cajaLista').hide();", 200);
                    var ParentescoBean = {
                            'parentescoID' : numParentesco
                    };
                    if (numParentesco != '' && !isNaN(numParentesco)) {
                        parentescosServicio.consultaParentesco(
                                tipConPrincipal, ParentescoBean, function(
                                        parentesco) {
                                    if (parentesco != null) {
                                        $('#parentesco').val(
                                                parentesco.descripcion);
                                    } else {
                                        mensajeSis("No Existe el Parentesco");
                                        $(jqParentesco).focus();
                                    }
                                });
                    }
                }

                function validaSiseguroVida(segurodeVida) {
                    if (segurodeVida == 'S') {// si lleva seguro de vida
                        $('#trMontoSeguroVida').show();
                        $('#trBeneficiario').show();
                        $('#trParentesco').show();
                        $('#reqSeguroVidaSi').attr("checked", true);
                        $('#reqSeguroVidaNo').attr("checked", false);
                        $('#reqSeguroVida').val('S');
                    }else{// no lleva seguro de vida
                        $('#trMontoSeguroVida').hide();
                        $('#trBeneficiario').hide();
                        $('#trParentesco').hide();
                        $('#reqSeguroVidaSi').attr("checked", false);
                        $('#reqSeguroVidaNo').attr("checked", true);
                        $('#reqSeguroVida').val('N');
                    }

                }

                // calcula el numero de dias entre las fecha inicio y fecha final
                function calculaNodeDias(varfechaCal) {

                    if ($('#fechaInicioAmor').val() != '') {
                        var tipoCons = 1;
                        var PlazoBeanCon = {
                                'plazoID' : $('#plazoID').val()
                        };
                        plazosCredServicio.consulta(tipoCons, PlazoBeanCon, { async: false, callback: function(plazos)  {
                                    if (plazos != null) {
                                        // número de dias de la fecha inicial a la fecha de vencimiento.
                                        $('#noDias').val(plazos.dias);

                                        if ($('#reqSeguroVida').val() == 'S' ) {

                                            calculoCostoSeguro('S'); // calcula


                                        }
                                        else{
                                        }
                                        // si la frecuencia es Pago UNICO los dias que hay de diferencia seran
                                        // las periodicidades de  capital e interes
                                        if ($('#frecuenciaCap').val() == "U") {
                                            $('#periodicidadCap').val(plazos.dias);
                                            if($('#perIgual').val() == 'S'){
                                                $('#periodicidadInt').val(plazos.dias);
                                            }
                                        }
                                    }
                        }
                    });
                }
            }


                // FUNCION PARA CALCULAR EL MONTO DEL SEGURO DE VIDA DEPENDIENDO DEL MONTO INICIAL DEL CREDITO
                function calculoCostoSeguro(segVida) {

                    var montoTotalCalculado = montoinicial;

                    if($("#plazoID").val() != '' && $("#producCreditoID").val() != ''){

                        agregaFormatoControles('formaGenerica');
                        numeroDias = $('#noDias').val();
                        var pagoseguro = $('#forCobroSegVida').val();
                        var costoSeguroVida = 0;
                        var montocom = $('#montoComision').asNumber();
                        var ivaComAper = $('#IVAComApertura').asNumber();
                        var factRiesgo = $('#factorRiesgoSeguro').val();
                        var montoDescuento = 0;
                        var montoOriginal = 0;


                        if (segVida == 'S' ) {

                            //consultaFechaVencimiento(this.id);
                            if(modalidad == 'U'){
                            var descSeguro = (descuentoSeg / 100);

                                costoSeguroVida = (factRiesgo / 7)  * montoinicial * numeroDias;
                                montoOriginal = costoSeguroVida;

                                $('#montoSegOriginal').val(montoOriginal);
                                $('#descuentoSeguro').val(descuentoSeg);

                                montoDescuento = costoSeguroVida-(costoSeguroVida * descSeguro);
                                costoSeguroVida = montoDescuento;

                                    $('#montoSeguroVida').val(costoSeguroVida.toFixed(2));

                                    if (pagoseguro == 'F') {
                                        montoTotalCalculado = Number(montoTotalCalculado) + parseFloat(costoSeguroVida);
                                        montoFinal=$('#montoCredito').asNumber();
                                        seguroInicial=$('#montoSeguroVida').asNumber();
                                        agregaFormatoControles('formaGenerica');
                                    }


                                    if($("#formaComApertura").val()=='FINANCIAMIENTO'){
                                        montoTotalCalculado = Number(montoTotalCalculado) + parseFloat(montocom);
                                        montoTotalCalculado = Number(montoTotalCalculado) + parseFloat(ivaComAper);
                                    }


                                    $('#reqSeguroVidaSi').attr("checked", true);
                                    $('#reqSeguroVidaNo').attr("checked", false);
                                    $('#reqSeguroVida').val('S');

                                    $('#montoCredito').val(Number(montoTotalCalculado).toFixed(2));
                                    montoFinal = $('#montoCredito').asNumber();
                                    agregaFormatoControles('formaGenerica');


                            }else{
                                if(modalidad == "T"){

                                calculoCostoSeguroTipoPago('S');
                                }
                            }

                        } else {
                            $('#montoSeguroVida').val("0.00");
                            $('#montoCredito').val(Number(montoTotalCalculado).toFixed(2));
                            montoFinal = $('#montoCredito').asNumber();
                            agregaFormatoControles('formaGenerica');

                            $('#reqSeguroVidaSi').attr("checked", false);
                            $('#reqSeguroVidaNo').attr("checked", true);

                        }


                    }else{
                        $('#montoSeguroVida').val("0.00");
                        $('#montoCredito').val(Number(montoTotalCalculado).toFixed(2));
                        montoFinal = $('#montoCredito').asNumber();
                        agregaFormatoControles('formaGenerica');
                    }

                }



                // calculo del seguro por tipo de pago

                function calculoCostoSeguroTipoPago(segVida) {
                    var montoTotalCalculado = montoinicial;
                    if($("#plazoID").val() != '' && $("#producCreditoID").val() != ''){

                        agregaFormatoControles('formaGenerica');
                        numeroDias = $('#noDias').val();

                        var costoSeguroVida = 0;
                        var montocom = $('#montoComision').asNumber();
                        var ivaComAper = $('#IVAComApertura').asNumber();

                        $('#factorRiesgoSeguro').val(factorRS);
                        var factorRiesgo = $('#factorRiesgoSeguro').val();
                        var factRiesgo = $('#factorRiesgoSeguro').asNumber();

                        var montoDescuento = 0;
                        var montoOriginal = 0;

                        if (segVida == 'S' ) {
                            if(modalidad == 'T'){

                            var pagoseguro = $('#forCobroSegVida').val();
                            var esqSeguVida = esquemaSeguro;
                            consultaEsquemaSeguroVida(esqSeguVida,pagoseguro);


                            if(factorRS == 0){
                                $('#montoSeguroVida').val("0.00");
                                $('#tipPago').val("");

                                    }


                                var descSeguro = (porcentajeDesc / 100);

                                costoSeguroVida = (factRiesgo / 7)  * montoinicial * numeroDias;
                                montoOriginal = costoSeguroVida;
                                $('#montoSegOriginal').val(montoOriginal);
                                $('#descuentoSeguro').val(porcentajeDesc);


                                montoDescuento = costoSeguroVida-(costoSeguroVida * descSeguro);
                                costoSeguroVida = montoDescuento;


                                    $('#montoSeguroVida').val(montoDescuento.toFixed(2));

                                    if (pagoseguro == 'F') {

                                        montoTotalCalculado = Number(montoTotalCalculado) + parseFloat(costoSeguroVida);
                                        montoFinal=$('#montoCredito').asNumber();
                                        seguroInicial=$('#montoSeguroVida').asNumber();
                                        agregaFormatoControles('formaGenerica');
                                    }


                                    if($("#formaComApertura").val()=='FINANCIAMIENTO'){

                                        montoTotalCalculado = Number(montoTotalCalculado) + parseFloat(montocom);
                                        montoTotalCalculado = Number(montoTotalCalculado) + parseFloat(ivaComAper);
                                    }


                                    $('#reqSeguroVidaSi').attr("checked", true);
                                    $('#reqSeguroVidaNo').attr("checked", false);
                                    $('#reqSeguroVida').val('S');

                                    $('#montoCredito').val(Number(montoTotalCalculado).toFixed(2));
                                    montoFinal = $('#montoCredito').asNumber();
                                    agregaFormatoControles('formaGenerica');


                        } else {
                            $('#montoSeguroVida').val("0.00");
                            $('#montoCredito').val(Number(montoTotalCalculado).toFixed(2));
                            montoFinal = $('#montoCredito').asNumber();
                            agregaFormatoControles('formaGenerica');

                            $('#reqSeguroVidaSi').attr("checked", false);
                            $('#reqSeguroVidaNo').attr("checked", true);
                        }

                        }else{
                            $('#montoCredito').val(Number(montoTotalCalculado).toFixed(2));
                            montoFinal = $('#montoCredito').asNumber();
                            agregaFormatoControles('formaGenerica');
                        }//termina condicion de modalidad

                    }else{
                        $('#montoSeguroVida').val("0.00");
                        $('#montoCredito').val(Number(montoTotalCalculado).toFixed(2));
                        montoFinal = $('#montoCredito').asNumber();
                        agregaFormatoControles('formaGenerica');
                    }

                   }


                /// termina funcon para el calculo del seguro de vida por tipo de pago




                // FUNCION PARA CALCULAR EL MONTO DE LA GARANTÍA LÍQUIDA DEL CRÉDITO
                function calPorceGaranLiquida(garanLiquida) {
                    // SE LLAMA A FUNCION PARA HACER LA OPERACION
                    calculosyOperacionesDosDecimalesMultiplicacion(
                            $("#montoCredito").asNumber(), (garanLiquida / 100));
                }



                // CONSULTA DEL BENEFICIARIO DEL SEGURO DE VIDA DEL CRÉDITO
                function consultaBeneficiario(idControl) {
                    var jqCred = eval("'#" + idControl + "'");
                    var Credito = $(jqCred).val();
                    var SeguroVidaBean = {
                            'creditoID' : Credito
                    };
                    setTimeout("$('#cajaLista').hide();", 200);
                    if (Credito != '' && !isNaN(Credito) && esTab) {
                        seguroVidaServicio.consulta(catTipoConsultaCredito.foranea, SeguroVidaBean,
                                function(seguro) {
                                    if (seguro != null) {
                                        $('#seguroVidaID').val(seguro.seguroVidaID);
                                        $('#direccionBen').val(seguro.direccionBeneficiario);
                                        $('#beneficiario').val(seguro.beneficiario);
                                        $('#parentescoID').val(seguro.relacionBeneficiario);
                                        $('#parentesco').val(seguro.descriRelacionBeneficiario);
                                        deshabilitaControl('direccionBen');
                                        deshabilitaControl('beneficiario');
                                        deshabilitaControl('parentescoID');
                                        deshabilitaControl('parentesco');

                                    } else {

                                        $('#direccionBen').val('');
                                        $('#beneficiario').val('');
                                        $('#parentescoID').val('');
                                        $('#parentesco').val('');
                                        deshabilitaControl('direccionBen');
                                        deshabilitaControl('beneficiario');
                                        deshabilitaControl('parentescoID');
                                        deshabilitaControl('parentesco');
                                    }
                                });
                    }
                }

                // CONSULTA DEL BENEFICIARIO DEL SEGURO DE VIDA DEL CRÉDITO
                // por solicitud
                function consultaBeneficiarioSolicitud(idControl) {
                    var jqCred = eval("'#" + idControl + "'");
                    var Credito = $(jqCred).val();
                    var SeguroVidaBean = {
                            'solicitudCreditoID' : Credito
                    };
                    setTimeout("$('#cajaLista').hide();", 200);
                    if (Credito != '' && !isNaN(Credito) && esTab) {
                        seguroVidaServicio
                        .consulta(
                                2,
                                SeguroVidaBean,
                                function(seguro) {
                                    if (seguro != null) {

                                        $('#direccionBen')
                                        .val(
                                                seguro.direccionBeneficiario);
                                        $('#beneficiario')
                                        .val(
                                                seguro.beneficiario);
                                        $('#parentescoID')
                                        .val(
                                                seguro.relacionBeneficiario);
                                        $('#parentesco')
                                        .val(
                                                seguro.descriRelacionBeneficiario);
                                        deshabilitaControl('direccionBen');
                                        deshabilitaControl('beneficiario');
                                        deshabilitaControl('parentescoID');
                                        deshabilitaControl('parentesco');

                                        $('#forCobroSegVida').val(seguro.forCobroSegVida);

                                        if(modalidad == 'U'){

                                        if (seguro.forCobroSegVida == 'F') {
                                            $('#tipoPagoSeguro').val(
                                            "FINANCIAMIENTO");
                                        }
                                        if (seguro.forCobroSegVida == 'D') {
                                            $('#tipoPagoSeguro').val("DEDUCCION");
                                        }
                                        if (seguro.forCobroSegVida == 'A') {
                                            $('#tipoPagoSeguro').val("ANTICIPADO");
                                        }

                                        }else{
                                            if(modalidad == 'T'){

                                            if (seguro.forCobroSegVida == 'F') {
                                                $('#tipPago').val("F");

                                            }
                                            if (seguro.forCobroSegVida == 'D') {
                                                $('#tipPago').val("D");
                                            }
                                            if (seguro.forCobroSegVida == 'A') {
                                                $('#tipPago').val("A");
                                            }
                                            if (seguro.forCobroSegVida == 'O') {
                                                $('#tipPago').val("O");
                                            }

                                        }
                                    }


                                    } else {

                                        $('#direccionBen').val('');
                                        $('#beneficiario').val('');
                                        $('#parentescoID').val('');
                                        $('#parentesco').val('');
                                        deshabilitaControl('direccionBen');
                                        deshabilitaControl('beneficiario');
                                        deshabilitaControl('parentescoID');
                                        deshabilitaControl('parentesco');
                                    }
                                });
                    }
                }
                // se ejecuta desde la consulta del cliente consultaCliente() y consultaClienteSolici()
                function consultacicloCliente() {
                    var CicloCreditoBean = {
                            'clienteID' : $('#clienteID').asNumber(),
                            'prospectoID' : $('#prospectoID').asNumber(),
                            'productoCreditoID' : $('#producCreditoID')
                            .asNumber(),
                            'grupoID' : $('#grupoID').asNumber()
                    };

                    setTimeout("$('#cajaLista').hide();", 200);
                    solicitudCredServicio.consultaCiclo(CicloCreditoBean,{async: false, callback: function(cicloCreditoCte) {
                        if (cicloCreditoCte != null) {
                            $('#cicloCliente').val(cicloCreditoCte.cicloCliente);
                            $('#cicloClienteGrupal').val(cicloCreditoCte.cicloPondGrupo);
                            cicloCliente = cicloCreditoCte.cicloCliente;
                            if (cicloCreditoCte.cicloPondGrupo != 0) {
                                $('#lbcicloscaja').show('slow');
                                $('#lbciclos').show('slow');
                            } else {
                                $('#lbcicloscaja').hide('slow');
                                $('#lbciclos').hide('slow');
                            }
                        } else {
                            mensajeSis('No hay Ciclo para el Cliente');
                        }
                    }});
                }

                function validaMontoLineaCredito(monto) {
                    if (lineaCreSi == "1") {
                        if (Number(monto) > Number($('#saldoLineaCred').asNumber())) {
                            mensajeSis("El Monto no Puede ser Mayor al Saldo de Línea");
                            $('#montoCredito').val('0');
                            $('#montoComision').val('0.00');
                            $('#montoSeguroVida').val('0.00');
                            $('#montoCredito').focus();
                            $('#montoCredito').select();
                            montoFinal = 0;
                            plazoInicial = 0;
                        }else{

                            consultaTasaCredito(monto);
                            consultaFechaVencimiento('plazoID');
                        }
                    }else{
                        //consultaComisionAper();
                        consultaTasaCredito(monto);
                        consultaFechaVencimiento('plazoID');
                        $('#saldoLineaCred').val('0.00');
                    }
                }

                // valida que la cuenta CLABE este bien formada
                function validaSpei(valor, cuentaClabe) {
                    agregaFormatoNumMaximo('formaGenerica');
                    var numero = document.getElementById(cuentaClabe).value;
                    var tipoDisper = $('#tipoDispersion').val();
                    if (tipoDisper == 'S' && numero != '') {
                        if (isNaN(numero)) {
                            mensajeSis("Ingresar sólo números");
                            $('#cuentaCLABE').select();
                        }
                        if (numero.length == 18 && numero != '') {
                            if (!isNaN(numero)) {
                                var institucion = numero.substr(0, 3);
                                var tipoConsulta = 3;
                                var DispersionBean = {
                                        'institucionID' : institucion
                                };
                                institucionesServicio.consultaInstitucion(tipoConsulta,DispersionBean,function(data) {
                                    if (data == null) {
                                        mensajeSis('La cuenta clabe no coincide con ninguna Institución Financiera registrada');
                                        document.getElementById(cuentaClabe).focus();
                                    }
                                });
                            }
                        } else {
                            mensajeSis("La cuenta clable debe de tener 18 caracteres");
                            document.getElementById(cuentaClabe).focus();
                        }
                    }
                    return false;
                }

                /*
                 * FUNCION PARA HACER OPERACION DE MULTIPLICACION Y OBTENER
                 * EL RESULTADO REDONDEADO CON DOS DECIMALES
                 */
                function calculosyOperacionesDosDecimalesMultiplicacion(valor1, valor2) {
                    var calcOperBean = {
                            'valorUnoA' : 0,
                            'valorDosA' : 0,
                            'valorUnoB' : valor1,
                            'valorDosB' : valor2,
                            'numeroDecimales' : 2
                    };
                    setTimeout("$('#cajaLista').hide();", 200);
                    calculosyOperacionesServicio.calculosYOperaciones(2,calcOperBean,function(valoresResultado) {
                        if (valoresResultado != null) {
                            $('#aporteCliente')
                            .val(valoresResultado.resultadoCuatroDecimales);
                            $('#montoCredito').formatCurrency({
                                positiveFormat : '%n',
                                negativeFormat : '%n',
                                roundToDecimalPlace : 2
                            });
                            agregaFormatoControles('formaGenerica');
                        } else {
                            mensajeSis('Indique el monto de nuevo.');
                            $('#aporteCliente').val("0.00");
                        }
                    });
                }


                /* consulta de calificación del cliente se ejecuta solo cuando se trata de una solicitud */
                function consultaCalificacion(idControl) {
                    var jqCliente = eval("'#" + idControl + "'");
                    var numCliente = $(jqCliente).val();

                    var tipConPrincipal = 1;
                    setTimeout("$('#cajaLista').hide();", 200);

                    if (numCliente != '' && !isNaN(numCliente)) {
                        clienteServicio.consulta(tipConPrincipal,numCliente,function(cliente) {
                            if (cliente != null) {
                                if(cliente.calificaCredito=='N'){
                                    $('#calificaCredito').val('NO ASIGNADA');
                                }
                                if(cliente.calificaCredito=='A'){
                                    $('#calificaCredito').val('EXCELENTE');
                                }
                                if(cliente.calificaCredito=='C'){
                                    $('#calificaCredito').val('REGULAR');
                                }
                                if(cliente.calificaCredito=='B'){
                                    $('#calificaCredito').val('BUENA');
                                }

                            } else {
                                mensajeSis("Cliente No Válido");
                                $('#clienteID').focus();
                                $('#clienteID').select();
                            }
                        });
                    }
                }

                function validaMontoCredito(){

                        if ($('#montoCredito').asNumber() > MontoMaxCre) {
                                agregaFormatoControles('formaGenerica');
                                $('#montoCredito').val(MontoMaxCre);
                                $('#montoCredito').formatCurrency({
                                    positiveFormat : '%n',
                                    negativeFormat : '%n',
                                    roundToDecimalPlace : 2
                                });
                                mensajeSis('El Monto Solicitado no debe ser Mayor a '+ $('#montoCredito').val());
                                $('#montoCredito').val('');
                                $('#montoCredito').focus();
                                $('#montoCredito').select();
                                montoFinal=0;
                                montoinicial=0;
                            } else {
                                    if ($('#montoCredito').asNumber() < MontoMinCre) {
                                        agregaFormatoControles('formaGenerica');
                                        $('#montoCredito').val(MontoMinCre);
                                        $('#montoCredito').formatCurrency({
                                            positiveFormat : '%n',
                                            negativeFormat : '%n',
                                            roundToDecimalPlace : 2
                                        });
                                        var MontFormat = $('#montoCredito').asNumber();
                                        mensajeSis('El Monto  no debe ser Menor a ' + MontFormat);
                                        $('#montoCredito').val('');
                                        $('#montoCredito').select();
                                        $('#montoCredito').focus();
                                        montoFinal=0;
                                        montoinicial=0;
                                    } else {
                                        validaMontoLineaCredito($('#montoCredito').asNumber());
                                        consultaComisionAper();
                                        consultaPorcentajeGarantiaLiquida('montoCredito');
                                    }
                            }


                        agregaFormatoControles('formaGenerica');
                        var cte = $('#clienteID').val();
                        var estatus = $('#estatus').val();
                        if (cte == '0' || estatus == 'I') {
                            $('#sucursalCte').val(
                                    parametroBean.sucursal);
                        }
                        var credito = $('#creditoID').val();

                        if (credito == '0' || credito == 'I') {
                            esTab = true;
                            var monto = $('#montoCredito').asNumber();
                            var MontoInic = MontoIni;
                            monto.toFixed(2);
                            agregaFormatoControles('formaGenerica');
                        }

                        agregaFormatoControles('formaGenerica');
                        $('#montoCredito').formatCurrency({
                            positiveFormat : '%n',
                            negativeFormat : '%n',
                            roundToDecimalPlace : 2
                        });
                }

                   if(manejaConvenio=='S')
                      {
                         if(noSeguirPro==true){
                             deshabilitaBoton('modifica');
                             deshabilitaBoton('agrega');
                             deshabilitaBoton('simular');
                            }
                     }

            });


            //funcion para deshabilitar los controles cuando es un alta de credito
            function deshabilitaControlesAlta() {
                deshabilitaControl('monedaID');
            //  deshabilitaControl('fechaInicio');
                deshabilitaControl('tipoCalInteres');
                deshabilitaControl('calcInteresID');
                deshabilitaControl('fechaInhabil1');
                deshabilitaControl('fechaInhabil2');
                deshabilitaControl('calendIrregularCheck');
                deshabilitaControl('ajusFecExiVen1');
                deshabilitaControl('ajusFecUlVenAmo1');
                deshabilitaControl('ajusFecExiVen2');
                deshabilitaControl('ajusFecUlVenAmo2');
                deshabilitaControl('montoCuota');
                deshabilitaControl('numAmortInteres');
                deshabilitaControl('numAmortizacion');
                deshabilitaControl('tasaFija');
            }

            //funcion para deshabilitar los controles cuando un credito no esta inactivo (autorizado,desembolsado)
            function deshabilitaControlesNoInactivo() {
                deshabilitaControl('monedaID');
                deshabilitaControl('tipoCalInteres');
                deshabilitaControl('calcInteresID');
                deshabilitaControl('fechaInhabil1');
                deshabilitaControl('fechaInhabil2');
                deshabilitaControl('calendIrregularCheck');
                deshabilitaControl('ajusFecExiVen1');
                deshabilitaControl('ajusFecUlVenAmo1');
                deshabilitaControl('ajusFecExiVen2');
                deshabilitaControl('ajusFecUlVenAmo2');
                deshabilitaControl('montoCuota');
                deshabilitaControl('numAmortInteres');
                deshabilitaControl('numAmortizacion');
                deshabilitaControl('tasaFija');
                //deshabilitaControl('lineaCreditoID');
                deshabilitaControl('clienteID');
                deshabilitaControl('cuentaID');
                deshabilitaControl('destinoCreID');
                deshabilitaControl('producCreditoID');
                deshabilitaControl('montoCredito');
                deshabilitaControl('plazoID');
                deshabilitaControl('tipoDispersion');
                deshabilitaControl('tipoPagoCapital');
                deshabilitaControl('frecuenciaCap');
                deshabilitaControl('frecuenciaInt');
                deshabilitaControl('diaPagoCapital1');
                deshabilitaControl('diaPagoCapital2');
                deshabilitaControl('diaPagoCapitalD');
                deshabilitaControl('diaPagoCapitalQ');
                deshabilitaControl('diaPagoInteres1');
                deshabilitaControl('diaPagoInteres2');
                deshabilitaControl('diaPagoInteresD');
                deshabilitaControl('diaPagoInteresQ');
                deshabilitaControl('diaMesInteres');
                deshabilitaControl('diaMesCapital');
                deshabilitaControl('tipoFondeo');
                deshabilitaControl('tipoFondeo2');
                deshabilitaControl('lineaFondeo');
                deshabilitaControl('institFondeoID');
                deshabilitaControl('tipPago');

            }

            //funcion que inicializa los combos de frecuencia,plazos,tipo de
            //pago,dispersion.
            function inicializaCombosCredito() {
                $('#tipoDispersion').val('');
                $('#tipoCalInteres').val('');
                $('#calcInteresID').val('');
                $('#plazoID').val('');
                $('#tipPago').val('');

            }
            //funcion que inicializa los combos del calendario de pagos
            function inicializaCombos() {
                $('#tipoPagoCapital').each(function() {
                    $('#tipoPagoCapital option').remove();
                });
                $('#tipoPagoCapital').append(new Option('SELECCIONAR', '', true, true));

                $('#frecuenciaCap').each(function() {
                    $('#frecuenciaCap option').remove();
                });
                $('#frecuenciaCap').append(new Option('SELECCIONAR', '', true, true));

                $('#frecuenciaInt').each(function() {
                    $('#frecuenciaInt option').remove();
                });
                $('#frecuenciaInt').append(new Option('SELECCIONAR', '', true, true));

                $('#plazoID').each(function() {
                    $('#plazoID option').remove();
                });
                $('#plazoID').append(new Option('SELECCIONAR', '', true, true));

                $('#tipoDispersion').each(function() {
                    $('#tipoDispersion option').remove();
                });
                $('#tipoDispersion').append(new Option('SELECCIONAR', '', true, true));
            }

            //funcion a ejecutar cuando se realizo con exito una transaccion
            function accionInicializaRegresoExitoso() {
                $('#contenedorSimulador').html("");
                limpiarServiciosAdicionales();
                agregaFormatoControles('formaGenerica');

            }
            //funcion a ejecutar cuando se realizo con errores una transaccion
            function accionInicializaRegresoFallo() {
                var solicitud = $('#solicitudCreditoID').val();
                if (solicitud != 0) {
                    deshabilitaControlesNoInactivo();
                }
                deshabilitaControlesAlta();
                tab2 = false;
            }

            //valida vacios cuando se hace el submit de una solicitud
            function validaCamposRequeridos() {
                var fechaAplicacion = parametroBean.fechaAplicacion;
                var fechaIniForm = $('#fechaInicioAmor').val();
                var fechaVenForm = $('#fechaVencimien').val();
                if (fechaIniForm < fechaAplicacion) {
                    mensajeSis("Fecha es menor a la del Sistema ");
                    procede = 1;
                } else {
                    if (fechaVenForm < fechaIniForm) {
                        mensajeSis("Fecha de Inicio es Inferior a la de Vencimiento  ");
                        procede = 1;
                    } else {
                        if ($('#numTransacSim').asNumber() == '0' || $('#numTransacSim').asNumber() == '') {
                            mensajeSis("Se requiere Simular las Amortizaciones");
                            procede = 1;
                        } else {
                            if ($('#frecuenciaCap').val() == '0' || $('#frecuenciaCap').val() == "") {
                                mensajeSis("La Frecuencia de Capital Está Vacío.");
                                esTab = true;
                                $('#frecuenciaCap').focus();
                                procede = 1;
                            } else {
                                if ($('#tipoPagoCapital').val() == '0') {
                                    mensajeSis("El Tipo de Pago Está Vacío.");
                                    esTab = true;
                                    procede = 1;
                                } else {
                                    if ($('#diaPagoCapital2').is(':checked') && $('#diaMesCapital').asNumber() == 0 && ($('#frecuenciaCap').val() =='M' || $('#frecuenciaCap').val() =='Q')) {
                                        mensajeSis("Especificar Día Mes Capital.");
                                        $('#diaMesCapital').focus();
                                        procede = 1;
                                    } else {
                                        //

                                        if ($('#frecuenciaInt').val() == '' || $('#frecuenciaInt').val() == ""  && $('#tipoPagoCapital').val() != "C") {
                                            mensajeSis("Especifique Frecuencia de Interés.");
                                            $('#frecuenciaInt').focus();
                                            procede = 1;
                                        } else {
                                            if ($('#numAmortInteres').val() == '0' || $('#numAmortInteres').val() == "") {
                                                if($('#calendIrregular').val()== "S"){
                                                    mensajeSis("Es necesario Calcular de nuevo las Amortizaciones.");
                                                    $('#calcular').focus();
                                                    procede = 1;
                                                }else{
                                                    mensajeSis("Numero de Cuotas de Interés Vacio.");
                                                    $('#numAmortInteres').focus();
                                                    procede = 1;
                                                }
                                            } else {
                                                if ($('#diaPagoInteres2').is(':checked') && $('#diaMesInteres').asNumber() == 0  && $('#tipoPagoCapital').val() != "C" && ($('#frecuenciaCap').val() =='M' || $('#frecuenciaCap').val() =='Q')) {
                                                    mensajeSis("Especificar Día Mes Interés.");
                                                    $('#diaMesInteres').focus();
                                                    procede = 1;
                                                } else {
                                                    if ($('#producCreditoID').asNumber() == '0' || $('#producCreditoID').val() == '') {
                                                        mensajeSis("El Producto de Crédito Está Vacío.");
                                                        procede = 1;
                                                    } else {
                                                        if ($('#destinoCreID').asNumber() == '0'|| $('#destinoCreID').val() == '') {
                                                            mensajeSis("El Destino de Crédito Está Vacío.");
                                                            $('#destinoCreID').focus();
                                                            procede = 1;
                                                        } else {
                                                            if ($('#tipoDispersion').val() == '') {
                                                                mensajeSis("El Tipo de Dispersion Está Vacío.");
                                                                $('#tipoDispersion').focus();
                                                                procede = 1;
                                                            } else {
                                                                if ($('#frecuenciaCap').val() == 'U') {
                                                                    if ($('#tipoPagoCapital').val() != "I") {
                                                                        mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
                                                                        procede = 1;
                                                                    } else {
                                                                        procede = 0;
                                                                    }
                                                                } else {
                                                                    procede = 0;
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }

                                    }
                                }
                            }
                        }
                    }
                }
                return procede;
            }

            //funcion para deshabilitar la seccion del calendario de pagos que corresponde
            //con interes
            function deshabilitarCalendarioPagosInteres() {
                deshabilitaControl('numAmortInteres');
                deshabilitaControl('frecuenciaInt');
                deshabilitaControl('diaMesInteres');
                deshabilitaControl('diaPagoInteres1');
                deshabilitaControl('diaPagoInteres2');
                deshabilitaControl('periodicidadInt');
            }

            //funcion que iniciliza valores de la forma
            function inicializaValores() {

                montoinicial=0;
                $('#contenedorSimulador').html("");
                $('#contenedorSimulador').hide();
                $('#reqSeguroVidaNo').attr('checked', true);
                $('#reqSeguroVidaSi').attr("checked", false);
                $('#reqSeguroVida').val('N');

                // inicializa radios de valores del calendario de pagos *****
                $('#fechaInhabil').val("S");
                $('#fechaInhabil1').attr('checked', true);
                $('#fechaInhabil2').attr("checked", false);

                $('#ajusFecExiVen1').attr('checked', false);
                $('#ajusFecExiVen2').attr("checked", true);
                $('#ajusFecExiVen').val("S");

                $('#calendIrregularCheck').attr("checked", false);
                $('#calendIrregular').val("N");

                $('#ajusFecUlVenAmo1').attr('checked', true);
                $('#ajusFecUlVenAmo2').attr("checked", false);
                $('#ajusFecUlVenAmo').val("S");

                $('#diaMesCapital').val("");
                $('#diaMesInteres').val("");

                $('#diaPagoCapital1').attr('checked', true);
                $('#diaPagoCapital2').attr('checked', false);
                $('#diaPagoCapital').val("F");

                $('#diaPagoInteres1').attr('checked', true);
                $('#diaPagoInteres2').attr('checked', false);
                $('#diaPagoInteres').val("F");
                $('#calificaCredito').val("");

                tipoPrepCre="";
                $('#prepagos').hide();
                $('#prepagoslbl').hide();
                $('#tipoPrepago').val('');
                $('#tipoPagoSelect').hide();
                consultaMoneda();

                $("#tipoCredito").val(var_TipoCredito.NUEVO);
                $("#tipoCreditoDes").val(var_TipoCredito.NUEVODES);
                $('#datosNomina').hide();
                $('.folioSolici').hide();
            }

            function incializaCamposNuevoCredito(){
                $('#creditoID').val('0');
                $('#solicitudCreditoID').val('');
                $('#clienteID').val('');
                $('#nombreCliente').val('');
                $('#lineaCreditoID').val('');
                $('#producCreditoID').val('');
                $('#nombreProd').val('');
                $('#cuentaID').val('');
                $('#saldoLineaCred').val('0.00');
                $('#relacionado').val('');
                $('#destinoCreID').val('');
                $('#descripDestino').val('');
                $('#destinCredFOMURID').val('');
                $('#descripDestinoFOMUR').val('');
                $('#montoCredito').val('');
                $('#fechaVencimien').val('');
                $('#factorMora').val('');
                $('#cuentaCLABE').val('');
                $('#formaComApertura').val('');
                $('#montoComision').val('');
                $('#IVAComApertura').val('');
                $('#porcGarLiq').val('');
                $('#aporteCliente').val('0.00');
                $('#cicloCliente').val('');
                $('#tasaFija').val('');
                $('#tasaBase').val('');
                $('#desTasaBase').val('');
                $('#tasaFija').val('');
                $('#sobreTasa').val('');
                $('#pisoTasa').val('');
                $('#techoTasa').val('');
                $('#periodicidadInt').val('');
                $('#periodicidadCap').val('');
                $('#diaMesInteres').val('');
                $('#diaMesCapital').val('');
                $('#numAmortInteres').val('');
                $('#numAmortizacion').val('');
                $('#montoCuota').val('');
                $('#cat').val('');
                $('#institFondeoID').val('');
                $('#descripFondeo').val('');
                $('#lineaFondeo').val('');
                $('#descripLineaFon').val('');
                $('#saldoLineaFon').val('');
                $('#tasaPasiva').val('');
                $('#folioFondeo').val('');
                $('#beneficiario').val('');
                $('#montoSeguroVida').val('');
                $('#parentescoID').val('');
                $('#parentesco').val('');
                $('#direccionBen').val('');
                $('#creditoID').focus('');
                $('#creditoID').select('');
                $('#trMontoSeguroVida').hide();
                $('#trBeneficiario').hide();
                $('#trParentesco').hide();
                $('#tipPago').val('');
                $('#tipoPagoSelect').hide();
                $('#simular').show();
                $('#folioConsultaBC').val('');
                $('#folioConsultaCC').val('');
                $('#institucionNominaID').val('');
                $('#nombreInstit').val('');
                $('#convenioNominaID').val('');
                $('#desConvenio').val('');
                $('#folioSolici').val('');

            }

            function incializaCamposSolicitud(){
                $('#clienteID').val('');
                $('#nombreCliente').val('');
                $('#lineaCreditoID').val('');
                $('#producCreditoID').val('');
                $('#nombreProd').val('');
                $('#cuentaID').val('');
                $('#saldoLineaCred').val('0.00');
                $('#relacionado').val('');
                $('#destinoCreID').val('');
                $('#descripDestino').val('');
                $('#destinCredFOMURID').val('');
                $('#descripDestinoFOMUR').val('');
                $('#montoCredito').val('');
                $('#fechaVencimien').val('');
                $('#factorMora').val('');
                $('#cuentaCLABE').val('');
                $('#formaComApertura').val('');
                $('#montoComision').val('');
                $('#IVAComApertura').val('');
                $('#porcGarLiq').val('');
                $('#aporteCliente').val('0.00');
                $('#cicloCliente').val('');
                $('#tasaFija').val('');
                $('#tasaBase').val('');
                $('#desTasaBase').val('');
                $('#tasaFija').val('');
                $('#sobreTasa').val('');
                $('#pisoTasa').val('');
                $('#techoTasa').val('');
                $('#periodicidadInt').val('');
                $('#periodicidadCap').val('');
                $('#diaMesInteres').val('');
                $('#diaMesCapital').val('');
                $('#numAmortInteres').val('');
                $('#numAmortizacion').val('');
                $('#montoCuota').val('');
                $('#cat').val('');
                $('#institFondeoID').val('');
                $('#descripFondeo').val('');
                $('#lineaFondeo').val('');
                $('#descripLineaFon').val('');
                $('#saldoLineaFon').val('');
                $('#tasaPasiva').val('');
                $('#folioFondeo').val('');
                $('#beneficiario').val('');
                $('#montoSeguroVida').val('');
                $('#parentescoID').val('');
                $('#parentesco').val('');
                $('#direccionBen').val('');
                //$('#trMontoSeguroVida').hide('slow');
                //$('#trBeneficiario').hide('slow');
                //$('#trParentesco').hide('slow');
                $('#tipPago').val('');
                $('#tipoPagoSelect').hide();

                $('#lineaCreditoID').focus('');
                $('#lineaCreditoID').select('');

                $("#destinCredFRID").val('');
                $("#descripDestinoFR").val('');
                $("#calificaCredito").val('');
                $("#contenedorSimulador").html('');
                $("#tipoCredito").val(var_TipoCredito.NUEVO);
                $("#tipoCreditoDes").val(var_TipoCredito.NUEVODES);
                $('#folioConsultaBC').val('');
                $('#folioConsultaCC').val('');
            }

            //consulta de monedas
            function consultaMoneda() {
                dwr.util.removeAllOptions('monedaID');
                dwr.util.addOptions('monedaID', {
                    0 : 'SELECCIONA'
                });
                monedasServicio.listaCombo(3, function(monedas) {
                    dwr.util.addOptions('monedaID', monedas,'monedaID', 'descripcion');
                    $('#monedaID').val(1).selected = true;
                });
            }


            /* *******************************************************************************************
             * *****************************CALENDARIO IRREGULAR *****************************************
             * ********************************************************************************************/
            /*simulador de pagos libres de capital*/
            function simuladorPagosLibres(numTransac){
                $('#numTransacSim').val(numTransac);
                var procedeCalculo = validaUltimaCuotaCapSimulador();
                if(procedeCalculo == 0){
                    var mandar = crearMontosCapital(numTransac);
                    var diaHabilSig;
                    if(mandar==2){
                        var params = {};
                        if($('#calcInteresID').val()==1 ) {
                            switch($('#tipoPagoCapital').val()){
                            case "C": // SI ES CRECIENTE
                                tipoLista=1;
                                break;
                            case "I": // SI ES IGUAL
                                tipoLista=2;
                                break;
                            case "L": // SI ES LIBRE
                                tipoLista=3;
                                break;
                            default :
                                tipoLista=1;
                            break;
                            }
                        }else{
                            switch($('#tipoPagoCapital').val()){
                            case "I": // SI ES IGUAL
                                tipoLista=4;
                                break;
                            case "L": // SI ES LIBRE
                                tipoLista=5;
                                break;
                            default :
                                tipoLista=4;
                            break;
                            }
                        }

                        diaHabilSig= $('#fechInhabil').val();

                        params['tipoLista']         = tipoLista;
                        params['montoCredito']      = $('#montoCredito').asNumber();
                        params['tasaFija']          =  $('#tasaFija').val();
                        params['producCreditoID']   = $('#producCreditoID').val();
                        params['clienteID']         = $('#clienteID').val();
                        params['fechaInhabil']      = diaHabilSig;
                        params['empresaID']         = parametroBean.empresaID;
                        params['usuario']           = parametroBean.numeroUsuario;
                        params['fecha']             = parametroBean.fechaSucursal;
                        params['direccionIP']       = parametroBean.IPsesion;
                        params['sucursal']          = parametroBean.sucursal;
                        params['numTransaccion']    = $('#numTransacSim').val();
                        params['numTransacSim']     = $('#numTransacSim').val();
                        params['montosCapital']     = $('#montosCapital').val();
                        params['montoComision']     = $('#montoComApert').asNumber();
                        params['cobraSeguroCuota']  = $('#cobraSeguroCuota option:selected').val();
                        params['cobraIVASeguroCuota']   = $('#cobraIVASeguroCuota option:selected').val();
                        params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
                        params['plazoID']           = $('#plazoID').val();
                        params['tipoOpera']     = 1;
                        params['cobraAccesorios']   = cobraAccesorios;

                        bloquearPantallaAmortizacion();
                        var numeroError = 0;
                        var mensajeTransaccion = "";
                        $.post("simPagLibresCredito.htm", params, function(data){
                            if(data.length >0) {
                                $('#contenedorSimulador').html("");
                                $('#contenedorSimulador').hide();
                                $('#contenedorSimuladorLibre').html(data);
                                if ( $("#numeroErrorList").length ) {
                                    numeroError = $('#numeroErrorList').asNumber();
                                    mensajeTransaccion = $('#mensajeErrorList').val();
                                }
                                if(numeroError==0){
                                    $('#contenedorSimuladorLibre').show();
                                    var valorTransaccion = $('#transaccion').val();
                                    $('#numTransacSim').val(valorTransaccion);
                                    $('#contenedorForma').unblock();
                                    // actualiza el numero de cuotas generadas por el cotizador
                                    $('#numAmortInteres').val($('#valorCuotasInteres').val());
                                    $('#numAmortizacion').val($('#valorCuotasCapital').val());
                                    // actualiza la nueva fecha de vencimiento que devuelve el cotizador
                                    var jqFechaVen = eval("'#valorFecUltAmor'");
                                    $('#fechaVencimien').val($(jqFechaVen).val());
                                    habilitarBotonesCre();
                                    $('#totalCap').val(totalizaCap());
                                    $('#totalInt').val(totalizaInt());
                                    $('#totalIva').val(totalizaIva());
                                    $('#totalCap').formatCurrency({
                                        positiveFormat : '%n',
                                        roundToDecimalPlace : 2
                                    });
                                    $('#totalInt').formatCurrency({
                                        positiveFormat : '%n',
                                        roundToDecimalPlace : 2
                                    });
                                    $('#totalIva').formatCurrency({
                                        positiveFormat : '%n',
                                        roundToDecimalPlace : 2
                                    });

                                    $('#cat').val($('#valorCat').val());
                                    $('#cat').formatCurrency({
                                        positiveFormat : '%n',
                                        roundToDecimalPlace : 1
                                    });

                                    $('#imprimirRep').hide(); // uuuu
                                }
                            }else{
                                $('#contenedorSimulador').html("");
                                $('#contenedorSimulador').show();
                            }
                            agregaFormatoControles('formaGenerica');
                            /****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
                            if(numeroError!=0){
                                $('#contenedorForma').unblock({fadeOut: 0,timeout:0});
                                mensajeSisError(numeroError,mensajeTransaccion);
                            }
                            /**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
                        });
                    }
                }

            }// fin simuladorPagosLibres

            function mostrarGridLibresEncabezado(){
                var data;

                $("#montoCuota").val('0.00');
                $("#cat").val('0.0000');

                data = '<input type="hidden" value="0" name="numeroDetalle" id="numeroDetalle" />'+
                '<fieldset class="ui-widget ui-widget-content ui-corner-all">'+
                '<legend>Simulador de Amortizaciones</legend>'+
                '<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">'+
                '<tr>'+
                '<td class="label" align="center"><label for="lblNumero">N&uacute;mero</label></td>'+
                '<td class="label" align="center"><label for="lblFecIni">Fecha Inicio</label></td>'+
                '<td class="label" align="center"><label for="lblFecFin">Fecha Vencimiento</label> </td>    '+
                '<td class="label" align="center"><label for="lblFecPag">Fecha Pago</label></td>'+
                '<td class="label" align="center"><label for="lblCapital">Capital</label></td> '+
                '<td class="label" align="center"><label for="lblDescripcion">Inter&eacute;s</label></td> '+
                '<td class="label" align="center"><label for="lblCargos">Iva Inter&eacute;s</label></td> '+
                '<td class="label" align="center"><label for="lblTotalPag">Total Pago</label></td> '+
                '<td class="label" align="center"><label for="lblSaldoCap">Saldo Capital</label></td> '+
                '<td class="label" align="center"><label for="lblAgregaElimina"></label></td> '+
                '</tr>'+
                '</table>'+
                '</fieldset>';

                $('#contenedorSimuladorLibre').html(data);
                $('#contenedorSimuladorLibre').show();
                $('#contenedorSimulador').html("");
                $('#contenedorSimulador').hide();
                mostrarGridLibresDetalle();
            }

            function mostrarGridLibresDetalle(){
                var numeroFila = document.getElementById("numeroDetalle").value;
                var nuevaFila = parseInt(numeroFila) + 1;
                var filaAnterior = parseInt(nuevaFila) - 1;
                var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
                var valorDiferencia = $('#diferenciaCapital').asNumber();
                if(numeroFila == 0){
                    tds += '<td><input type="text" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="4" value="1" readonly="true" disabled="true"/></td>';
                    tds += '<td><input type="text" id="fechaInicio'+nuevaFila+'"  name="fechaInicio" size="15" value="'+ $('#fechaInicioAmor').val()+'" readonly="true" disabled="true"/></td>';
                    tds += '<td align="center"><input type="text" id="fechaVencim'+nuevaFila+'" name="fechaVencim" size="15" value="" onblur="comparaFechas(this.id)"  /></td>';
                    tds += '<td align="center"><input type="text" id="fechaExigible'+nuevaFila+'" name="fechaExigible" size="15" value=" " readonly="true" disabled="true"/></td>';
                    tds += '<td><input type="text" id="capital'+nuevaFila+'" name="capital" size="18" style="text-align: right;" value="" esMoneda="true"'
                    + '  onblur="agregaFormatoMonedaGrid(this.id);calculaDiferenciaSimuladorLibre()"/></td>';
                    tds += '<td><input type="text" id="interes'+nuevaFila+'" name="interes" size="18" style="text-align: right;" value="" esMoneda="true" readonly="true" disabled="true"/></td>';
                    tds += '<td><input type="text" id="ivaInteres'+nuevaFila+'" name="ivaInteres" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
                    tds += '<td><input type="text" id="totalPago'+nuevaFila+'" name="totalPago" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
                    tds += '<td><input type="text" id="saldoInsoluto'+nuevaFila+'" name="saldoInsoluto" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';

                } else{
                    $('#trBtnCalcular').remove();
                    $('#trDiferenciaCapital').remove();
                    $('#filaTotales').remove();
                    var valor = parseInt(document.getElementById("consecutivoID"+numeroFila+"").value) + 1;
                    tds += '<td><input type="text" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="4" value="'+valor+'" autocomplete="off" readonly="true" disabled="true"/></td>';
                    tds += '<td><input type="text" id="fechaInicio'+nuevaFila+'"  name="fechaInicio" size="15" value="'+ $('#fechaVencim'+filaAnterior).val()+'" readonly="true" disabled="true"/></td>';
                    tds += '<td align="center"><input type="text" id="fechaVencim'+nuevaFila+'" name="fechaVencim" size="15" value="" onblur="comparaFechas(this.id)" /></td>';
                    tds += '<td align="center"><input type="text" id="fechaExigible'+nuevaFila+'" name="fechaExigible" size="15" value="" readonly="true" disabled="true"/></td>';
                    tds += '<td><input type="text" id="capital'+nuevaFila+'" name="capital" size="18" style="text-align: right;" value="" esMoneda="true"'
                    + '  onblur="agregaFormatoMonedaGrid(this.id);calculaDiferenciaSimuladorLibre()"/></td>';
                    tds += '<td><input type="text" id="interes'+nuevaFila+'" name="interes" size="18" style="text-align: right;" value="" esMoneda="true" readonly="true" disabled="true"/></td>';
                    tds += '<td><input type="text" id="ivaInteres'+nuevaFila+'" name="ivaInteres" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
                    tds += '<td><input type="text" id="totalPago'+nuevaFila+'" name="totalPago" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
                    tds += '<td><input type="text" id="saldoInsoluto'+nuevaFila+'" name="saldoInsoluto" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';

                }
                tds += '<td nowrap="nowrap"><input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaAmort(this)"/>';
                tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevaAmort()"/></td>';
                tds += '</tr>';
                tds += '<tr id="trDiferenciaCapital" >'+
                '<td colspan="4" align="right"><label for="Diferencia">Diferencia: </label></td>'+
                '<td  id="inputDiferenciaCap">'+
                '<input type="text" id="diferenciaCapital" name="diferenciaCapital" size="18" style="text-align: right;" value="'+valorDiferencia+'" esMoneda="true" readonly="true" disabled="true"/>'+
                '</td>'+
                '<td colspan="5"></td>'+
                '</tr>';
                tds += '<tr id="trBtnCalcular" >'+
                '<td  id="btnCalcularLibre" colspan="10" align="right">'+
                '<input type="button" class="submit" id="calcular" tabindex="37"  onclick="simuladorLibresCapFec();" value="Calcular"/>'+
                '</td>'+
                '</tr>';

                document.getElementById("numeroDetalle").value = nuevaFila;
                $('#miTabla').append(tds);
                sugiereFechaSimuladorLibre();
                deshabilitaBoton('agrega','submit');
                deshabilitaBoton('modifica','submit');
            }

            function agregaNuevaAmort(){
                var numeroFila = document.getElementById("numeroDetalle").value;
                var nuevaFila = parseInt(numeroFila) + 1;
                var filaAnterior = parseInt(nuevaFila) - 1;
                var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
                var valorDiferencia = $('#diferenciaCapital').asNumber();
                if(numeroFila == 0){
                    $('#trBtnCalcular').remove();
                    $('#trDiferenciaCapital').remove();
                    $('#filaTotales').remove();
                    tds += '<td><input type="text" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="4" value="1" readonly="true" disabled="true"/></td>';
                    tds += '<td align="center"><input type="text" id="fechaInicio'+nuevaFila+'"  name="fechaInicio" size="15" value="'+ $('#fechaInicioAmor').val()+'" readonly="true" disabled="true"/></td>';
                    tds += '<td align="center"><input type="text" id="fechaVencim'+nuevaFila+'" name="fechaVencim" size="15" value="" onblur="comparaFechas(this.id);"  /></td>';
                    tds += '<td align="center"><input type="text" id="fechaExigible'+nuevaFila+'" name="fechaExigible" size="15" value="" readonly="true" disabled="true"/></td>';
                    tds += '<td><input type="text" id="capital'+nuevaFila+'" name="capital" size="18" style="text-align: right;" value="" esMoneda="true" '
                    + '  onblur="agregaFormatoMonedaGrid(this.id);calculaDiferenciaSimuladorLibre()"/></td>';
                    tds += '<td><input type="text" id="interes'+nuevaFila+'" name="interes" size="18" style="text-align: right;" value="" esMoneda="true" readonly="true" disabled="true"/></td>';
                    tds += '<td><input type="text" id="ivaInteres'+nuevaFila+'" name="ivaInteres" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
                    tds += '<td><input type="text" id="totalPago'+nuevaFila+'" name="totalPago" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
                    tds += '<td><input type="text" id="saldoInsoluto'+nuevaFila+'" name="saldoInsoluto" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';

                } else{
                    $('#trBtnCalcular').remove();
                    $('#trDiferenciaCapital').remove();
                    $('#filaTotales').remove();
                    var valor = parseInt(document.getElementById("consecutivoID"+numeroFila+"").value) + 1;
                    tds += '<td><input type="text" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="4" value="'+valor+'" autocomplete="off" readonly="true" disabled="true" /></td>';
                    tds += '<td align="center"><input type="text" id="fechaInicio'+nuevaFila+'"  name="fechaInicio" size="15" value="'+ $('#fechaVencim'+filaAnterior).val()+'" readonly="true" disabled="true"/></td>';
                    tds += '<td align="center"><input type="text" id="fechaVencim'+nuevaFila+'" name="fechaVencim" size="15" value="" onblur="comparaFechas(this.id)" /></td>';
                    tds += '<td align="center"><input type="text" id="fechaExigible'+nuevaFila+'" name="fechaExigible" size="15" value="" readonly="true" disabled="true"/></td>';
                    tds += '<td><input type="text" id="capital'+nuevaFila+'" name="capital" size="18" style="text-align: right;" value="" esMoneda="true" '
                    + '  onblur="agregaFormatoMonedaGrid(this.id);calculaDiferenciaSimuladorLibre()"/></td>';
                    tds += '<td><input type="text" id="interes'+nuevaFila+'" name="interes" size="18" style="text-align: right;" value="" esMoneda="true" readonly="true" disabled="true"/></td>';
                    tds += '<td><input type="text" id="ivaInteres'+nuevaFila+'" name="ivaInteres" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
                    tds += '<td><input type="text" id="totalPago'+nuevaFila+'" name="totalPago" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
                    tds += '<td><input type="text" id="saldoInsoluto'+nuevaFila+'" name="saldoInsoluto" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
                }
                tds += '<td nowrap="nowrap"><input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaAmort(this)"/>';
                tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevaAmort()"/></td>';
                tds += '</tr>';
                tds += '<tr id="trDiferenciaCapital" >'+
                '<td colspan="4" align="right"><label for="Diferencia">Diferencia: </label></td>'+
                '<td  id="inputDiferenciaCap">'+
                '<input type="text" id="diferenciaCapital" name="diferenciaCapital" size="18" style="text-align: right;" value="'+valorDiferencia+'" esMoneda="true" readonly="true" disabled="true"/>'+
                '</td>'+
                '<td colspan="5"></td>'+
                '</tr>';
                tds += '<tr id="trBtnCalcular" >'+
                '<td  id="btnCalcularLibre" colspan="10" align="right">'+
                '<input type="button" class="submit" id="calcular" value="Calcular" tabindex="37"  onclick="simuladorLibresCapFec();" />'+
                '</td>'+
                '</tr>';

                document.getElementById("numeroDetalle").value = nuevaFila;
                $("#miTabla").append(tds);
                sugiereFechaSimuladorLibre();
                calculaDiferenciaSimuladorLibre();
                calculoTotalCapital();
                calculoTotalInteres();
                calculoTotalIva();

                return false;
            }

            /* funcion para eliminar una amortizacion  */
            function eliminaAmort(control){
                var contador = 1;
                var numeroID = control.id;
                var jqTr = eval("'#renglon" + numeroID + "'");

                var jqConsecutivoID = eval("'#consecutivoID" + numeroID + "'");
                var jqFechaInicio = eval("'#fechaInicio" + numeroID + "'");
                var jqFechaVencim = eval("'#fechaVencim" + numeroID + "'");
                var jqFechaExigible = eval("'#fechaExigible" + numeroID + "'");
                var jqCapital = eval("'#capital" + numeroID + "'");
                var jqInteres = eval("'#interes" + numeroID + "'");
                var jqIvaInteres = eval("'#ivaInteres" + numeroID + "'");
                var jqTotalPago = eval("'#totalPago" + numeroID + "'");
                var jqSaldoInsoluto = eval("'#saldoInsoluto" + numeroID + "'");
                var jqElimina = eval("'#" + numeroID + "'");
                var jqAgrega = eval("'#agrega" + numeroID + "'");

                /* FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y
                 * LAS FILAS CONTINUEN DE MANERA COHERENTE.*/
                var continuar = ajustaValoresFechaElimina(numeroID,jqFechaInicio);

                if(continuar==1){
                    $(jqConsecutivoID).remove();
                    $(jqFechaInicio).remove();
                    $(jqFechaVencim).remove();
                    $(jqFechaExigible).remove();
                    $(jqCapital).remove();
                    $(jqInteres).remove();
                    $(jqIvaInteres).remove();
                    $(jqTotalPago).remove();
                    $(jqSaldoInsoluto).remove();
                    $(jqElimina).remove();
                    $(jqAgrega).remove();
                    $(jqTr).remove();


                    // se asigna el numero de detalle que quedan
                    var elementos = document.getElementsByName("renglon");
                    $('#numeroDetalle').val(elementos.length);
                    /*SE COMPARA SI QUEDA MAS DE UNA FILA */
                    if($('#numeroDetalle').asNumber()>0){
                        //Reordenamiento de Controles
                        contador = 1;
                        var numero= 0;
                        $('tr[name=renglon]').each(function() {
                            numero= this.id.substr(7,this.id.length);
                            var jqRenglonCiclo  = eval("'renglon" + numero+ "'");
                            var jqNumeroCiclo = eval("'consecutivoID" + numero + "'");
                            var jqFechaInicio   = eval("'fechaInicio" + numero + "'");
                            var jqFechaVencim   = eval("'fechaVencim" + numero + "'");
                            var jqAgrega        = eval("'agrega" + numero + "'");
                            var jqFechaExigible = eval("'fechaExigible" + numero + "'");
                            var jqCapital       = eval("'capital" + numero + "'");
                            var jqInteres       = eval("'interes" + numero + "'");
                            var jqIvaInteres    = eval("'ivaInteres" + numero + "'");
                            var jqTotalPago     = eval("'totalPago" + numero + "'");
                            var jqSaldoInsoluto = eval("'saldoInsoluto" + numero + "'");

                            var jqElimina = eval("'" + numero + "'");

                            document.getElementById(jqNumeroCiclo).setAttribute('value',  contador);

                            document.getElementById(jqRenglonCiclo).setAttribute('id', "renglon" + contador);
                            document.getElementById(jqNumeroCiclo).setAttribute('id', "consecutivoID" + contador);
                            document.getElementById(jqFechaInicio).setAttribute('id', "fechaInicio" + contador);
                            document.getElementById(jqFechaVencim).setAttribute('id', "fechaVencim" + contador);
                            document.getElementById(jqAgrega).setAttribute('id', "agrega" + contador);
                            document.getElementById(jqFechaExigible).setAttribute('id', "fechaExigible" + contador);
                            document.getElementById(jqCapital).setAttribute('id', "capital" + contador);
                            document.getElementById(jqInteres).setAttribute('id', "interes" + contador);
                            document.getElementById(jqIvaInteres).setAttribute('id', "ivaInteres" + contador);
                            document.getElementById(jqTotalPago).setAttribute('id', "totalPago" + contador);
                            document.getElementById(jqSaldoInsoluto).setAttribute('id', "saldoInsoluto" + contador);

                            document.getElementById(jqElimina).setAttribute('id',  contador);

                            contador = parseInt(contador + 1);
                        });
                        calculaDiferenciaSimuladorLibre();
                        calculoTotalCapital();
                        calculoTotalInteres();
                        calculoTotalIva();
                    }else{
                        /*si el usuario elimina la ultima fila, se agrega una fila nueva*/
                        agregaNuevaAmort();
                    }
                }
            }

            /* funcion para sugerir fecha y monto de acuerdo  a lo que ya se
             * habia indicado en el formulario.*/
            function sugiereFechaSimuladorLibre(){
                var numDetalle = $('input[name=fechaVencim]').length;
                var varFechaVenID = eval("'#fechaVencim"+numDetalle+"'");
                $(varFechaVenID).val($('#fechaVencimien').val());
                $(varFechaVenID).focus();
                var varCapitalID = eval("'#capital"+numDetalle+"'");
                if(numDetalle>1){
                    $(varCapitalID).val($('#diferenciaCapital').val());
                    $('#diferenciaCapital').val("0.00");
                    $(varCapitalID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
                }else{
                    $(varCapitalID).val($('#montoCredito').val());
                    $(varCapitalID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
                }
            }

            function verificarvaciosCapFec(){
                var numAmortizacion = $('input[name=capital]').length;
                $('#montosCapital').val("");
                var regresar =1;
                for(var i = 1; i <= numAmortizacion; i++){
                    var jqfechaInicio = eval("'#fechaInicio" +i + "'");
                    var jqfechaVencim = eval("'#fechaVencim" +i + "'");
                    var valFecIni = document.getElementById("fechaInicio"+i).value;
                    var valFecVen = document.getElementById("fechaVencim"+i).value;
                    if (valFecIni =="" ){
                        document.getElementById("fechaInicio"+i).focus();
                        $(jqfechaInicio).addClass("error");
                        regresar= 1;
                        mensajeSis("Especifique Fecha de Inicio");
                        i= numAmortizacion+2;
                    }else{regresar= 3;
                    $(jqfechaInicio).removeClass("error");
                    }

                    if (valFecVen =="" ){
                        document.getElementById("fechaVencim"+i).focus();
                        $(jqfechaVencim).addClass("error");
                        mensajeSis("Especifique Fecha de Vencimiento");
                        regresar= 1;
                        i= numAmortizacion+2;
                    }else{regresar= 4;
                    $(jqfechaVencim).removeClass("error");
                    }
                }
                return regresar;
            }

            //funcion para validar que la fecha de vencimiento indicada sea mayor a la de inicio
            function comparaFechas(varid){
                var fila = varid.substr(11,varid.length);
                var jqFechaIni = eval("'#fechaInicio" +fila + "'");
                var jqFechaVen = eval("'#fechaVencim" +fila + "'");

                var fechaIni = $(jqFechaIni).val();
                var fechaVen = $(jqFechaVen).val();
                var xYear=fechaIni.substring(0,4);
                var xMonth=fechaIni.substring(5, 7);
                var xDay=fechaIni.substring(8, 10);
                var yYear=fechaVen.substring(0,4);
                var yMonth=fechaVen.substring(5, 7);
                var yDay=fechaVen.substring(8, 10);
                if($(jqFechaVen).val()!= ""){
                    if(esFechaValida($(jqFechaVen).val())){
                        if(validaFechaVencimientoGrid($(jqFechaVen).val(), $('#fechaVencimien').val(), jqFechaVen, fila)){
                            if (yYear<xYear ){
                                mensajeSis("La Fecha Indicada debe ser Mayor a la Fecha de Inicio.");
                                document.getElementById("fechaVencim"+fila).focus();
                                $(jqFechaVen).addClass("error");
                            }else{
                                if (xYear == yYear){
                                    if (yMonth<xMonth){
                                        mensajeSis("La Fecha Indicada debe ser Mayor a la Fecha de Inicio.");
                                        document.getElementById("fechaVencim"+fila).focus();
                                        $(jqFechaVen).addClass("error");
                                    }else{
                                        if (xMonth == yMonth){
                                            if (yDay<xDay||yDay==xDay){
                                                mensajeSis("La Fecha Indicada debe ser Mayor a la Fecha de Inicio.");
                                                document.getElementById("fechaVencim"+fila).focus();
                                                $(jqFechaVen).addClass("error");
                                            }else{
                                                /* FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y
                                                 * LAS FILAS CONTINUEN DE MANERA COHERENTE.*/
                                                comparaFechaModificadaSiguiente(fila,jqFechaVen, jqFechaIni);
                                            }
                                        }else{
                                            /* FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y
                                             * LAS FILAS CONTINUEN DE MANERA COHERENTE.*/
                                            comparaFechaModificadaSiguiente(fila,jqFechaVen, jqFechaIni);

                                        }
                                    }
                                }else{
                                    /* FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y
                                     * LAS FILAS CONTINUEN DE MANERA COHERENTE.*/
                                    comparaFechaModificadaSiguiente(fila,jqFechaVen, jqFechaIni);
                                }
                            }
                        }else{
                            $(jqFechaVen).focus();
                        }
                    }else{
                        $(jqFechaVen).focus();
                    }
                }
            }

            //funcion para validar que la fecha de vencimiento No sea mayor a la de vencimiento calculada por los plazos.
            function validaFechaVencimientoGrid(fechaVenGrid, fechaVenCred, jqFechaVen, fila){
                var xYear=fechaVenCred.substring(0,4);
                var xMonth=fechaVenCred.substring(5, 7);
                var xDay=fechaVenCred.substring(8, 10);

                var yYear=fechaVenGrid.substring(0,4);
                var yMonth=fechaVenGrid.substring(5, 7);
                var yDay=fechaVenGrid.substring(8, 10);

                if(esFechaValida(fechaVenGrid)){
                    if (yYear>xYear ){
                        mensajeSis("La Fecha debe ser Menor o Igual a la Fecha de Vencimiento");
                        document.getElementById("fechaVencim"+fila).focus();
                        $(jqFechaVen).addClass("error");
                        return false;
                    }else{
                        if (xYear == yYear){
                            if (yMonth>xMonth){
                                mensajeSis("La Fecha debe ser Menor o Igual a la Fecha de Vencimiento");
                                document.getElementById("fechaVencim"+fila).focus();
                                $(jqFechaVen).addClass("error");
                                return false;
                            }else{
                                if (xMonth == yMonth){
                                    if (yDay>xDay){
                                        mensajeSis("La Fecha debe ser Menor o Igual a la Fecha de Vencimiento");
                                        document.getElementById("fechaVencim"+fila).focus();
                                        $(jqFechaVen).addClass("error");
                                        return false;
                                    }
                                }
                            }
                        }
                    }
                }else{
                    $(jqFechaVen).focus();
                }
                return true;
            }

            /* funcion para calcular la diferencia del monto con lo que se va poniendo en
             * el grid de pagos libres.*/
            function calculaDiferenciaSimuladorLibre(){
                var sumaMontoCapturado = 0;
                var diferenciaMonto = 0;
                var numero = 0;
                var varCapitalID = "";
                var muestraAlert = true;
                $('input[name=capital]').each(function() {
                    numero= this.id.substr(7,this.id.length);
                    numDetalle = $('input[name=capital]').length;
                    varCapitalID = eval("'#capital"+numero+"'");
                    sumaMontoCapturado = sumaMontoCapturado + $(varCapitalID).asNumber();

                    if(sumaMontoCapturado > $('#montoCredito').asNumber()){
                        if(muestraAlert){
                            mensajeSis("La suma de Montos de Capital debe ser Igual al Monto Solicitado.");
                            muestraAlert = false;
                        }
                        $(varCapitalID).val("");
                        $(varCapitalID).select();
                        $(varCapitalID).focus();
                        $(varCapitalID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
                        return false;
                    }else{
                        diferenciaMonto = $('#montoCredito').asNumber() -  sumaMontoCapturado.toFixed(2);
                        $('#diferenciaCapital').val(diferenciaMonto);
                        $('#diferenciaCapital').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
                        $(varCapitalID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
                    }
                });
            }

            //funcion para validar la fecha
            function esFechaValida(fecha){

                if (fecha != undefined && fecha.value != "" ){
                    var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
                    if (!objRegExp.test(fecha)){
                        mensajeSis("Formato de Fecha No Válido (aaaa-mm-dd)");
                        return false;
                    }

                    var mes=  fecha.substring(5, 7)*1;
                    var dia= fecha.substring(8, 10)*1;
                    var anio= fecha.substring(0,4)*1;

                    switch(mes){
                    case 1: case 3:  case 5: case 7: case 8: case 10: case 12:
                        numDias=31;
                        break;
                    case 4: case 6: case 9: case 11:
                        numDias=30;
                        break;
                    case 2:
                        if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
                        break;
                    default:
                        mensajeSis("Fecha Introducida es Errónea");
                    return false;
                    }
                    if (dia>numDias || dia==0){
                        mensajeSis("Fecha Introducida es Errónea");
                        return false;
                    }
                    return true;
                }
            }
            function comprobarSiBisisesto(anio){
                if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
                    return true;
                }
                else {
                    return false;
                }
            }

            /* Cancela las teclas [ ] en el formulario*/
            document.onkeypress = pulsarCorchete;
            function pulsarCorchete(e) {
                tecla=(document.all) ? e.keyCode : e.which;
                if(tecla==91 || tecla==93){
                    return false;
                }
                return true;
            }

            //funcion para poner el formato de moneda en el Grid
            function agregaFormatoMonedaGrid(controlID){
                jqID = eval("'#"+controlID+"'");
                $(jqID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
            }


            /*Para ejecutar el simulador de pagos libres de capital y fecha cuando das clic en el
             * boton calcular*/
            function simuladorLibresCapFec(){
                var mandar = "";
                var procedeCalculo = validaUltimaCuotaCapSimulador();
                if(procedeCalculo == 0){
                    mandar = crearMontosCapitalFecha();
                    if(mandar==2){
                        var params = {};
                        if($('#calcInteresID').val()==1 ) {
                            if($('#calendIrregularCheck').is(':checked')){
                                tipoLista = 7;
                            }else{
                                switch($('#tipoPagoCapital').val()){
                                case "C": // si el tipo de pago es CRECIENTES
                                    tipoLista = 1;
                                    break;
                                case "I" :// si el tipo de pago es IGUALES
                                    tipoLista = 2;
                                    break;
                                case  "L": // si el tipo de pago es LIBRES
                                    tipoLista = 3;
                                    break;
                                default:
                                    tipoLista = 1;
                                }
                            }
                        }else{
                            if($('#calendIrregularCheck').is(':checked')){
                                tipoLista=8;
                            }else{
                                switch($('#tipoPagoCapital').val()){
                                case "I" :// si el tipo de pago es IGUALES
                                    tipoLista = 4;
                                    break;
                                case  "L": // si el tipo de pago es LIBRES
                                    tipoLista = 5;
                                    break;
                                default:
                                    tipoLista = 4;
                                }
                            }
                        }

                        // Inicio diaPagoCapital por AZamora
                        if ($('#diaPagoCapital1').is(':checked')) {
                                auxDiaPagoCapital = "F";
                        }
                        else{
                            auxDiaPagoCapital = "D";
                        }
                        if ($('#diaPagoInteres1').is(':checked')) {
                            auxDiaPagoInteres = "F";
                        }else{
                            auxDiaPagoInteres = "D";
                        }
                        // Fin diaPagoCapital por AZamora

                        params['tipoLista']     = tipoLista;
                        params['montoCredito']      = $('#montoCredito').asNumber();
                        params['tasaFija']      = $('#tasaFija').asNumber();
                        params['fechaInhabil']  = $('#fechaInhabil').val();
                        params['empresaID']     = parametroBean.empresaID;
                        params['usuario']       = parametroBean.numeroUsuario;
                        params['fecha']         = parametroBean.fechaSucursal;
                        params['direccionIP']   = parametroBean.IPsesion;
                        params['sucursal']      = parametroBean.sucursal;
                        params['montosCapital'] = $('#montosCapital').val();
                        params['pagaIva']       = $('#pagaIva').val();
                        params['iva']           = $('#iva').asNumber();
                        params['producCreditoID']   = $('#producCreditoID').val();
                        params['clienteID']         = $('#clienteID').val();
                        params['montoComision']     = $('#montoComision').asNumber();
                        params['cobraSeguroCuota']  = $('#cobraSeguroCuota option:selected').val();
                        params['cobraIVASeguroCuota']   = $('#cobraIVASeguroCuota option:selected').val();
                        params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
                        params['plazoID']           = $('#plazoID').val();
                        params['tipoOpera']     = 1;
                        params['cobraAccesorios']   = cobraAccesorios;

                        bloquearPantallaAmortizacion();
                        var numeroError = 0;
                        var mensajeTransaccion = "";
                        $.post("simPagLibresCredito.htm", params, function(data){
                            if(data.length >0) {
                                $('#contenedorSimulador').html("");
                                $('#contenedorSimulador').hide();
                                $('#contenedorSimuladorLibre').html(data);
                                if ( $("#numeroErrorList").length ) {
                                    numeroError = $('#numeroErrorList').asNumber();
                                    mensajeTransaccion = $('#mensajeErrorList').val();
                                }
                                if(numeroError==0){
                                    $('#contenedorSimuladorLibre').show();
                                    var valorTransaccion = $('#transaccion').val();
                                    $('#numTransacSim').val(valorTransaccion);
                                    // actualiza la nueva fecha de vencimiento que devuelve el cotizador
                                    var jqFechaVen = eval("'#valorFecUltAmor'");
                                    $('#fechaVencimien').val($(jqFechaVen).val());

                                    // se asigna el numero de cuotas calculadas
                                    $('#numAmortizacion').val($('#valorCuotasCapital').val());
                                    $('#numAmortInteres').val($('#valorCuotasInteres').val());

                                    // se debloquea el contenedor
                                    $('#contenedorForma').unblock();
                                    habilitarBotonesCre();
                                    $('#totalCap').val(totalizaCap());
                                    $('#totalInt').val(totalizaInt());
                                    $('#totalIva').val(totalizaIva());
                                    $('#totalCap').formatCurrency({
                                        positiveFormat : '%n',
                                        roundToDecimalPlace : 2
                                    });
                                    $('#totalInt').formatCurrency({
                                        positiveFormat : '%n',
                                        roundToDecimalPlace : 2
                                    });
                                    $('#totalIva').formatCurrency({
                                        positiveFormat : '%n',
                                        roundToDecimalPlace : 2
                                    });
                                    $('#cat').val($('#valorCat').val());
                                    $('#cat').formatCurrency({
                                        positiveFormat : '%n',
                                        roundToDecimalPlace : 1
                                    });
                                    $('#imprimirRep').hide(); // uuuu
                                }
                            }else{
                                $('#contenedorSimulador').html("");
                                $('#contenedorSimulador').hide();
                                $('#contenedorSimuladorLibre').html("");
                                $('#contenedorSimuladorLibre').hide();
                            }
                            agregaFormatoControles('formaGenerica');
                            /****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
                            if(numeroError!=0){
                                $('#contenedorForma').unblock({fadeOut: 0,timeout:0});
                                mensajeSisError(numeroError,mensajeTransaccion);
                            }
                            /**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
                        });
                    }
                }
            }


            function crearMontosCapitalFecha(){
                var mandar = verificarvaciosCapFec();
                var regresar = 1;
                if(mandar!=1){
                    var suma =  sumaCapital();
                    if(suma !=1){
                        var numAmortizacion = $('input[name=capital]').length;
                        $('#montosCapital').val("");
                        for(var i = 1; i <= numAmortizacion; i++){
                            var idCapital=eval("'#capital"+i+"'");
                            if(i == 1){
                                $('#montosCapital').val($('#montosCapital').val() +
                                        i + ']' +
                                        $(idCapital).asNumber()+ ']' +
                                        document.getElementById("fechaInicio"+i+"").value+ ']' +
                                        document.getElementById("fechaVencim"+i+"").value );
                            }else{
                                $('#montosCapital').val($('#montosCapital').val() + '[' +
                                        i + ']' +
                                        $(idCapital).asNumber()+ ']' +
                                        document.getElementById("fechaInicio"+i+"").value+ ']' +
                                        document.getElementById("fechaVencim"+i+"").value );
                            }
                        }
                        regresar= 2;
                    }
                    else {regresar= 1; }
                }
                return regresar;
            }

            //funcion para verificar que la suma del capital sea igual que la del monto
            function sumaCapital(){
                var jqCapital;
                var suma = 0;
                var contador = 1;
                var capital;
                esTab=true;
                $('input[name=capital]').each(function() {
                    jqCapital = eval("'#" + this.id + "'");
                    capital= $(jqCapital).asNumber();
                    if(capital != '' && !isNaN(capital) && esTab){
                        suma = suma + capital;
                        contador = contador + 1;
                        $(jqCapital).formatCurrency({
                            positiveFormat: '%n',
                            roundToDecimalPlace: 2
                        });
                    }else{
                        $(jqCapital).val(0);
                    }
                });
                if (suma!= $('#montoCredito').asNumber() ) {
                    mensajeSis("La suma de Montos de Capital debe ser Igual al Monto Solicitado.");
                    return 1;
                }
            }

            function crearMontosCapital(numTransac){
                var suma =  sumaCapital();
                var idCapital="";
                if(suma !=1){
                    $('#montosCapital').val("");
                    for(var i = 1; i <= $('input[name=capital]').length; i++){
                        idCapital = eval("'#capital"+i+"'");
                        if($(idCapital).asNumber()>="0"){
                            if(i == 1){
                                $('#montosCapital').val($('#montosCapital').val() +
                                        i + ']' +
                                        $(idCapital).asNumber() + ']' +
                                        numTransac);
                            }else{
                                $('#montosCapital').val($('#montosCapital').val() + '[' +
                                        i + ']' +
                                        $(idCapital).asNumber() + ']' +
                                        numTransac);
                            }
                        }
                    }
                    return 2;
                }
            }

            //funcion que bloque la pantalla mientras se cotiza
            function bloquearPantallaAmortizacion() {
                $('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
                $('#contenedorForma').block({
                    message : $('#mensaje'),
                    css : {
                        border : 'none',
                        background : 'none'
                    }
                });

            }
            //agrega el scroll al div de simulador de pagos libres de capital
            $('#contenedorSimuladorLibre').scroll(function() {

            });


            /* FUNCION PARA VALIDAR QUE LA ULTIMA CUOTA DE CAPITAL EN EL COTIZADOR DE
             * PAGOS LIBRES EN CAPITAL O IRREGULAR
             * NO SEA CERO.*/
            function validaUltimaCuotaCapSimulador(){
                var procede = 0;
                if($('#tipoPagoCapital').val()=="L"){
                    var numAmortizacion = $('input[name=capital]').length;
                    for(var i = 1; i <= numAmortizacion; i++){
                        if(i== numAmortizacion ){
                            var idCapital = eval("'#capital"+i+"'");
                            if($(idCapital).asNumber()==0 ){
                                document.getElementById("capital"+i+"").focus();
                                document.getElementById("capital"+i+"").select();
                                $("capital"+i).addClass("error");
                                mensajeSis("La Última Cuota de Capital no puede ser Cero.");
                                procede = 1;
                            }else{
                                if($('#diferenciaCapital').asNumber() == 0 ){
                                    procede = 0;
                                }else{
                                    mensajeSis(" La Suma de capital en Amortizaciones debe ser igual al Monto Solicitado.");
                                    procede = 1;
                                }
                            }
                        }else{
                            if($('#diferenciaCapital').asNumber() == 0 ){
                                procede = 0;
                            }else{
                                mensajeSis(" La Suma de capital en Amortizaciones debe ser igual al Monto Solicitado.");
                                procede = 1;
                            }
                        }
                    }
                }else{
                    /* se valida que si el tipo de pago de capital es libre, no se pueda escoger como frecuencia
                     * la opcion de libre */
                    if ($('#frecuenciaInt').val() == "L" &&  $('#calendIrregular').val() == "N") {
                        mensajeSis("La Frecuencia de Interés Libre sólo Aplica para Calendario Irregular.");
                        $('#frecuenciaInt').focus();
                        $('#frecuenciaInt').val("");
                        procede = 1;
                    }else{
                        if ($('#frecuenciaCap').val() == "L" &&  $('#calendIrregular').val() == "N") {
                            mensajeSis("La Frecuencia de Capital Libre sólo Aplica para Calendario Irregular.");
                            $('#frecuenciaCap').focus();
                            $('#frecuenciaCap').val("");
                            procede = 1;
                        }else{
                            procede = 0;
                        }
                    }
                }
                return procede;
            }




            /* FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y
             * LAS FILAS CONTINUEN DE MANERA COHERENTE.*/
            function ajustaValoresFechaElimina(numeroID,jqFechaInicio){
                var idCajaRenom     = "";
                var siguiente       = 0;
                var anterior        = 0;
                var continuar       = 0;
                var numFilas        = $('input[name=fechaVencim]').length;

                if(numeroID <= numFilas ){
                    if(numeroID == 1){
                        siguiente = parseInt(numeroID) + parseInt(1);
                        idCajaRenom = eval("'#fechaInicio"+siguiente+"'");
                        $(idCajaRenom).val($(jqFechaInicio).val());
                        continuar = 1;
                    }else{
                        if(numeroID < numFilas){
                            siguiente = parseInt(numeroID) + parseInt(1);
                            anterior = parseInt(numeroID) - parseInt(1);
                            idCajaRenom = eval("'#fechaInicio"+siguiente+"'");
                            jqFechaVencim = eval("'#fechaVencim"+anterior+"'");
                            $(idCajaRenom).val($(jqFechaVencim).val());
                            continuar = 1;
                        }else{
                            if(numeroID == numFilas){
                                continuar = 1;
                            }
                        }
                    }
                }
                return continuar;
            }




            /* FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y
             * LAS FILAS CONTINUEN DE MANERA COHERENTE.*/
            function ajustaValoresFechaModifica(numeroID,jqFechaInicio){
                var idCajaRenom     = "";
                var siguiente       = 0;
                var continuar       = 0;
                var numFilas        = $('input[name=fechaVencim]').length;

                if(numeroID <= numFilas ){
                    if(numeroID < numFilas){
                        siguiente = parseInt(numeroID) + parseInt(1);
                        idCajaRenom = eval("'#fechaInicio"+siguiente+"'");
                        jqFechaVencim = eval("'#fechaVencim"+numeroID+"'");
                        $(idCajaRenom).val($(jqFechaVencim).val());
                        continuar = 1;
                    }else{
                        if(numeroID == numFilas){
                            continuar = 1;
                        }
                    }
                }
                return continuar;
            }


            /* FUNCION PARA VALIDAR QUE LA FECHA DE VENCIMIENTO
             * MODIFICADA NO SEA MAYO A LA FECHA DE VENCIMIENTO SIGUIENTE*/
            function comparaFechaModificadaSiguiente(varid, jqFechaVen ,jqFechaInicio){
                var siguiente = parseInt(varid) + parseInt(1);
                var numFilas        = $('input[name=fechaVencim]').length;
                if(varid < numFilas ){
                    var jqFechaVenSiguiente = eval("'#fechaVencim" +siguiente + "'");

                    var fechaIni = $(jqFechaVen).val();
                    var fechaVen = $(jqFechaVenSiguiente).val();
                    var xYear=fechaIni.substring(0,4);
                    var xMonth=fechaIni.substring(5, 7);
                    var xDay=fechaIni.substring(8, 10);
                    var yYear=fechaVen.substring(0,4);
                    var yMonth=fechaVen.substring(5, 7);
                    var yDay=fechaVen.substring(8, 10);
                    if($(jqFechaVen).val()!= ""){
                        if(esFechaValida($(jqFechaVen).val())){
                            if(validaFechaVencimientoGrid($(jqFechaVen).val(), $('#fechaVencimien').val(), jqFechaVen, varid)){
                                if (yYear<xYear ){
                                    mensajeSis("La Fecha Indicada debe ser Menor a la Fecha de Vencimiento \nde la siguiente Amortizazion.");
                                    document.getElementById("fechaVencim"+varid).focus();
                                    $(jqFechaVen).addClass("error");
                                }else{
                                    if (xYear == yYear){
                                        if (yMonth<=xMonth){
                                            if (xMonth == yMonth){
                                                if (yDay<=xDay||yDay==xDay){
                                                    mensajeSis("La Fecha Indicada debe ser Menor a la Fecha de Vencimiento \nde la siguiente Amortizazion.");
                                                    document.getElementById("fechaVencim"+varid).focus();
                                                    $(jqFechaVen).addClass("error");
                                                }else{
                                                    ajustaValoresFechaModifica(varid,jqFechaInicio);
                                                }
                                            }else{
                                                ajustaValoresFechaModifica(varid,jqFechaInicio);
                                            }
                                        }else{
                                            ajustaValoresFechaModifica(varid,jqFechaInicio);
                                        }
                                    }else{
                                        ajustaValoresFechaModifica(varid,jqFechaInicio);
                                    }
                                }
                            }else{
                                $(jqFechaVen).focus();
                            }
                        }else{
                            $(jqFechaVen).focus();
                        }
                    }
                }
            }  // fin comparaFechaModificadaSiguiente


            function habilitarBotonesCre(){
                if($('#creditoID').val()== '0'){
                    
                    habilitaBoton('agrega', 'submit');
                    deshabilitaBoton('modifica', 'submit');
                }else{
                    deshabilitaBoton('agrega','submit');

                    habilitaBoton('modifica','submit');     
                    
                }
            }


            /*
             * funcion para validar cuando un campo  toma el foco
             y es moneda, se necesita que se ponga el campo limpio cuando su valor es cero o seleccione elvalor si es
             mayor que cero.*/
            function validaFocoInputMoneda(controlID){
                jqID = eval("'#" + controlID + "'");
                if($(jqID).asNumber()>0){
                    $(jqID).select();
                }else{
                    $(jqID).val("");
                }
            }


            function totalizaCap(){
                var suma=0;
                $('input[name=capital]').each(function() {
                    var numero = this.id.substr(7, this.id.length);
                    var Cap= eval("'#capital" + numero + "'");
                    var capital=$(Cap).asNumber();
                    suma=suma+capital;
                });
                return suma;
            }


            function totalizaInt(){
                var suma=0;
                $('input[name=interes]').each(function() {
                    var numero = this.id.substr(7, this.id.length);
                    var Cap= eval("'#interes" + numero + "'");
                    var capital=$(Cap).asNumber();
                    suma=suma+capital;
                });
                return suma;
            }


            function totalizaIva(){
                var suma=0;
                $('input[name=ivaInteres]').each(function() {
                    var numero = this.id.substr(10, this.id.length);
                    var Cap= eval("'#ivaInteres" + numero + "'");
                    var capital=$(Cap).asNumber();
                    suma=suma+capital;
                });
                return suma;
            }

            function calculoTotalCapital() {
                var sumaMontoCapturado = 0;
                var numero = 0;
                var varCapitalID = "";
                var muestraAlert = true;
                $('input[name=capital]').each(function() {
                            numero = this.id.substr(7, this.id.length);
                            numDetalle = $('input[name=capital]').length;
                            varCapitalID = eval("'#capital" + numero + "'");
                            sumaMontoCapturado = sumaMontoCapturado + $(varCapitalID).asNumber();

                            if (sumaMontoCapturado > $('#montoCredito').asNumber()) {
                                if (muestraAlert) {
                                    mensajeSis("La suma de Montos de Capital debe ser Igual al Monto Solicitado.");
                                    muestraAlert = false;
                                }
                                $(varCapitalID).val("");
                                $(varCapitalID).select();
                                $(varCapitalID).focus();
                                $(varCapitalID).formatCurrency({
                                    positiveFormat : '%n',
                                    roundToDecimalPlace : 2
                                });
                                return false;
                            } else {
                                sumaMonto= sumaMontoCapturado.toFixed(2);
                                $('#totalCap').val(sumaMonto);
                                $('#totalCap').formatCurrency({
                                    positiveFormat : '%n',
                                    roundToDecimalPlace : 2
                                });
                                $(varCapitalID).formatCurrency({
                                    positiveFormat : '%n',
                                    roundToDecimalPlace : 2
                                });
                            }
                        });
            }


            function calculoTotalInteres() {
                var sumaMontoCapturado = 0;
                var sumaMontos = 0;
                var numero = 0;
                var varCapitalID = "";
                $('input[name=capital]').each(function() {
                            numero = this.id.substr(7, this.id.length);
                            numDetalle = $('input[name=interes]').length;
                            varCapitalID = eval("'#interes" + numero + "'");
                            sumaMontoCapturado = sumaMontoCapturado + $(varCapitalID).asNumber();
                                sumaMonto= sumaMontoCapturado.toFixed(2);
                                $('#totalInt').val(sumaMonto);
                                $('#totalInt').formatCurrency({
                                    positiveFormat : '%n',
                                    roundToDecimalPlace : 2
                                });
                                $(varCapitalID).formatCurrency({
                                    positiveFormat : '%n',
                                    roundToDecimalPlace : 2
                                });
                        });
            }

            function calculoTotalIva() {
                var sumaMontoCapturado = 0;
                var sumaMontos = 0;
                var numero = 0;
                var varCapitalID = "";
                $('input[name=ivaInteres]').each(function() {
                            numero = this.id.substr(10, this.id.length);
                            numDetalle = $('input[name=ivaInteres]').length;
                            varCapitalID = eval("'#ivaInteres" + numero + "'");
                            sumaMontoCapturado = sumaMontoCapturado + $(varCapitalID).asNumber();
                                sumaMonto= sumaMontoCapturado.toFixed(2);
                                $('#totalIva').val(sumaMonto);
                                $('#totalIva').formatCurrency({
                                    positiveFormat : '%n',
                                    roundToDecimalPlace : 2
                                });
                                $(varCapitalID).formatCurrency({
                                    positiveFormat : '%n',
                                    roundToDecimalPlace : 2
                                });
                        });
            }




            // Función para calcular los días transcurridos entre dos fechas
            function restaFechas(fAhora,fEvento) {

                var ahora = new Date(fAhora);
                var evento = new Date(fEvento);
                var tiempo = evento.getTime() - ahora.getTime();
                var dias = Math.floor(tiempo / (1000 * 60 * 60 * 24));

                return dias;
             }



            //Funciones para consultas de seguro de vida

            function consultaEsquemaSeguroVida(esq,tipoPAg){
                var prodCre = $('#productoCreditoID').val();
                var esquemaSeguroVid = esq;
                var tipPagoSegu = $('#forCobroSegVida').val();


                var esquemaSeguroBean = {
                        'producCreditoID' : prodCre,
                        'esquemaSeguroID' : esquemaSeguroVid,
                        'tipoPagoSeguro'  : tipPagoSegu
                };

                var tipoConsulta = 3;
                esquemaSeguroVidaServicio.consulta(tipoConsulta,esquemaSeguroBean,function(esquema) {
                            if (esquema != null) {
                                factorRS = esquema.factorRiesgoSeguro;
                                porcentajeDesc = esquema.descuentoSeguro;
                                montoPol = esquema.montoPolSegVida;
                                $('#montoPolSegVida').val(montoPol);

                        }else{
                                    factorRS = 0;
                                    porcentajeDesc = 0.00;
                                    montoPol = 0.00;


                                }
                    });

                }


            function consultaEsquemaSeguroVidaForanea(prod, tiPago){
                //var prodCre = $('#producCreditoID').val();
                var prodCre = prod;
                var esquemaSeguroVid = $('#esquemaSeguroID').val();
                var tipPagoSegu = tiPago;
                $('#forCobroSegVida').val(tiPago);

                var esquemaSeguroBean = {
                        'producCreditoID'   : prodCre,
                        'esquemaSeguroID'   : esquemaSeguroVid,
                        'tipoPagoSeguro'    : tipPagoSegu
                };

                var tipoConsulta = 4;
                esquemaSeguroVidaServicio.consulta(tipoConsulta,esquemaSeguroBean,function(esquema) {
                            if (esquema != null) {
                                factorRS = esquema.factorRiesgoSeguro;
                                porcentajeDesc = esquema.descuentoSeguro;
                                montoPol = esquema.montoPolSegVida;

                                if(modalidad == 'T'){
                                    $('#montoPolSegVida').val(esquema.montoPolSegVida);
                                    $('#descuentoSeguro').val(esquema.descuentoSeguro);
                                }else{}

                        }else{

                                    factorRS = 0;
                                    porcentajeDesc = 0.00;
                                    montoPol = 0.00;

                                }

                });
            }


            function consultaTiposPago(prod,esq,varTipoPagoSeguro) {
                var prodCre = $('#producCreditoID').val();
                    var esquemaSeguroVid = esq;

                    var esquemaSeguroBean= {
                            'producCreditoID' : prodCre,
                            'esquemaSeguroID' : esquemaSeguroVid
                };

                var tipoLista  = 4;
                        dwr.util.removeAllOptions('tipPago');
                            esquemaSeguroVidaServicio.lista(esquemaSeguroBean, tipoLista, function(esquemasSeguroVida){
                                $('#tipPago').append(new Option('SELECCIONAR', "", true, true));

                                    for (var i = 0; i < esquemasSeguroVida.length; i++){
                                            $('#tipPago').append(new Option(esquemasSeguroVida[i].descTipPago, esquemasSeguroVida[i].tipoPagoSeguro));

                                            if(varTipoPagoSeguro == esquemasSeguroVida[i].tipoPagoSeguro){
                                                $('#tipPago').val(varTipoPagoSeguro).select();
                                            }
                                    }
                            });
            }




            function consultaTiposPagoSol(prod,esq, varForCobroSegVida) {
                dwr.util.removeAllOptions('tipPago');
                var prodCre = prod;
                var esquemaSeguroVid = esq;

                var esquemaSeguroBean= {
                        'producCreditoID' : prodCre,
                        'esquemaSeguroID' : esquemaSeguroVid
                };

                var tipoLista  = 4;
                dwr.util.addOptions('tipPago',{'':'SELECCIONAR'});
                esquemaSeguroVidaServicio.lista(esquemaSeguroBean, tipoLista, function(tipoPuestos){
                dwr.util.addOptions('tipPago', tipoPuestos, 'tipoPagoSeguro','descTipPago');
               });
                consultaEsquemaSeguroVidaForanea(prod,varForCobroSegVida);

            }

            // funcion que llena el combo de calcInteres
            function consultaComboCalInteres() {
                dwr.util.removeAllOptions('calcInteresID');
                formTipoCalIntServicio.listaCombo(1, { async: false, callback: function(formTipoCalIntBean){
                    dwr.util.addOptions('calcInteresID', {'':'SELECCIONAR'});
                    dwr.util.addOptions('calcInteresID', formTipoCalIntBean, 'formInteresID', 'formula');
                }});
            }

            // Funcion que cambia la etiqueta de Tasa Fija Actualizada por Tasa Base Actual
            function setCalcInteresID(calcInteres,iniciaCampos){
                $('#calcInteresID').val(calcInteres);
                if(TasaFijaID==calcInteres){
                    VarTasaFijaoBase = 'Tasa Fija Anualizada';
                } else {
                    VarTasaFijaoBase = 'Tasa Base Actual';
                }
                $('#lblTasaFija').text(VarTasaFijaoBase+': ');
                if(iniciaCampos){
                    limpiaCamposTasaInteres();
                }
                habilitaCamposTasa(calcInteres);
            }

            // Funcion que limpia los campos de Tasas
            function limpiaCamposTasaInteres(){
                $('#tasaBase').val('');
                $('#desTasaBase').val('');
                $('#tasaFija').val('');
                $('#sobreTasa').val('');
                $('#pisoTasa').val('');
                $('#techoTasa').val('');
            }

            // Funcion que habilita y da formato de tasa dependiendo del calculo de interes
            function habilitaCamposTasa(calcInteresID){
                if (calcInteresID == TasaFijaID) {
                    deshabilitaControl('tasaFija');
                    deshabilitaControl('pisoTasa');
                    deshabilitaControl('tasaBase');
                    deshabilitaControl('sobreTasa');
                    deshabilitaControl('techoTasa');
                    $('#tasaBase').val('');
                    $('#desTasaBase').val('');
                    $('#sobreTasa').val('');
                    $('#pisoTasa').val('');
                    $('#techoTasa').val('');
                }

                if (calcInteresID == 2 || calcInteresID == 4 ){
                    deshabilitaControl('tasaFija');
                    deshabilitaControl('pisoTasa');
                    habilitaControl('tasaBase');
                    habilitaControl('sobreTasa');
                    deshabilitaControl('techoTasa');
                }

                if (calcInteresID == TasaBasePisoTecho){
                    deshabilitaControl('tasaFija');
                    habilitaControl('pisoTasa');
                    habilitaControl('tasaBase');
                    habilitaControl('sobreTasa');
                    habilitaControl('techoTasa');
                }
                $('#tasaFija').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
                $('#pisoTasa').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
                $('#sobreTasa').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
                $('#techoTasa').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
            }

            /* Funcion que pone las banderas para que se solicite de nuevo la simulación
             * por cambio en tasas y oculta/limpia los simuladores */
            function vuelveaSimular(){
                $("#numTransacSim").val('');
                estatusSimulacion = false ;
                $('#contenedorSimulador').html("");
                $('#contenedorSimulador').hide();
                $('#contenedorSimuladorLibre').html("");
                $('#contenedorSimuladorLibre').hide();
            }


function mostrarLabelTasaFactorMora(tipoFactorMora){
    if(tipoFactorMora == 'T'){
        $('#lblveces').hide();
        $('#lblTasaFija').show();

    }else if (tipoFactorMora == 'N') {
        $('#lblveces').show();
        $('#lblTasaFija').hide();
    }else{
        $('#lblveces').hide();
        $('#lblTasaFija').hide();
    }
}

function validarEsquemaCobroSeguro(){
    var tipoConPrincipal = 1;
    var productoCreditoID = $('#producCreditoID').asNumber();
    var frecuenciaInt = $("#frecuenciaInt option:selected").val();
    var frecuenciaCap = $("#frecuenciaCap option:selected").val();
    var esquemaSeguroBean = {
        'producCreditoID':  productoCreditoID,
        'frecuenciaCap': frecuenciaCap,
        'frecuenciaInt': frecuenciaInt,
    }
    $('#montoSeguroCuota').val(0);

    if($('#cobraSeguroCuota option:selected').val() == 'S'){
        if(productoCreditoID>0){
            if(frecuenciaCap!=""){
                if(frecuenciaInt!=""){
                    esquemaSeguroServicio.consulta(esquemaSeguroBean,tipoConPrincipal,
                            { async: false, callback: function(esquemaBean) {
                        if(esquemaBean!=null){
                            $('#montoSeguroCuota').val(esquemaBean.monto);
                        } else {
                            mensajeSis('No Existe Parametrizado el Monto de Seguro Para esta Frecuencia.');
                            $('#montoSeguroCuota').val("");
                            return false;
                        }
                    }});
                } else {
                    $('#frecuenciaInt').focus();
                    $('#montoSeguroCuota').val("");
                }
            } else {
                $('#frecuenciaCap').focus();
                $('#montoSeguroCuota').val("");
            }
        } else {
            $('#productoCreditoID').focus();
            $('#montoSeguroCuota').val("");
        }
    } else {
        $('#montoSeguroCuota').val("0");
        return true;
    }
    return false;
}

function asignaInstFondeoID(idControl, nuevoValor){
    var jqInstituto = eval("'#" + idControl + "'");
    var numInstituto = $(jqInstituto).val();
    if((Number(numInstituto)==0 && Number(nuevoValor)>0) || (Number(numInstituto)==Number(nuevoValor))){
        $(jqInstituto).val(nuevoValor);
        consultaInstitucionFondeo(idControl);
    }
}

// consulta de la institucion de fondeo
function consultaInstitucionFondeo(idControl) {
    var jqInstituto = eval("'#" + idControl + "'");
    var numInstituto = $(jqInstituto).val();
    var tipoCon = 2;
    var instFondeoBeanCon = {
            'institutFondID' : numInstituto
    };
    setTimeout("$('#cajaLista').hide();", 200);
    if (numInstituto != '' && !isNaN(numInstituto) && esTab) {
        fondeoServicio.consulta(tipoCon,instFondeoBeanCon,function(instituto) {
            if (instituto != null) {
                $('#descripFondeo').val(instituto.nombreInstitFon);
                $('#institFondeoID').val(numInstituto);

            } else {
            	var institucion = $('#institFondeoID').val();
                if (institucion != '0' && institucion != '') {
                    mensajeSis("No Existe la Institución");
                    $('#institFondeoID').focus();
                    $('#institFondeoID').select();
                }
                
            }
        });
    }
}
function asignaTipoFondeo(tipoFondeo){
    if (tipoFondeo == 'P') {
        $('#tipoFondeo').attr("checked",true);
        $('#tipoFondeo2').attr("checked",false);
        $('#institFondeoID').val("");
        $('#lineaFondeo').val("");
        $('#descripFondeo').val("");
        $('#descripLineaFon').val("");
        $('#saldoLineaFon').val("");
        deshabilitaControl('institFondeoID');
        deshabilitaControl('lineaFondeo');
    }
    if (tipoFondeo == 'F') {
        $('#tipoFondeo').attr("checked",false);
        $('#tipoFondeo2').attr("checked",true);
    }
}

function validaPagosXReferencia(){
    paramGeneralesServicio.consulta(23,{},function(parametro){
        if (parametro!=null) {
            if (parametro.valorParametro=='N') {
                pagosXReferencia = parametro.valorParametro;
                deshabilitaControl('referenciaPago');
            }else{
                pagosXReferencia = parametro.valorParametro;
                habilitaControl('referenciaPago');
            }
        }
    });
}

function validaLetraNum(e){
    var tecla = (document.all) ? e.keyCode : e.which;

    if(tecla==8){
        return true;
    }
    var teclasPermitidas = /[A-Za-z0-9]/;
    var teclaFinal = String.fromCharCode(tecla);
    return teclasPermitidas.test(teclaFinal);
}


//Valida que existan Accesorios parametrizados para el producto de crédito
function validaAccesorios(tipoCon){
    var valAccesorios = false;
    var paramCon = {};

    paramCon['cicloCliente'] = cicloCliente;
    paramCon['producCreditoID'] = $('#producCreditoID').val();
    if(tipoCon==38){
        creditosServicio.consulta(tipoCon, paramCon, {
            async : false,
            callback : function(accesorios) {
                if (accesorios != null) {
                    valAccesorios = true;
                }
            }
        });
    }else if (tipoCon==39){
        paramCon['plazoID'] = $('#plazoID').val();
        paramCon['montoPorDesemb'] = $('#montoSolici').val();
        paramCon['convenioNominaID'] = $('#convenioNominaID').val();
        creditosServicio.consulta(tipoCon, paramCon, {
            async : false,
            callback : function(accesorios) {
                if (accesorios != null) {
                    valAccesorios = true;
                }
            }
        });
    }

    return valAccesorios;
}

function muestraGridAccesorios(){
    var numCredito = $('#creditoID').val();
    var params = {};
    if(numCredito > 0){
        params['creditoID'] =  numCredito;

    }
    params['tipoLista'] = 3;
    params['solicitudCreditoID'] =  $('#solicitudCreditoID').val();



    $.post("accesoriosGridVista.htm", params, function(data) {
        if (data.length > 0) {
            $('#divAccesoriosCred').html(data);
            var numFilas = consultaFilasAccesorios();
            if (numFilas == 0) {
                $('#divAccesoriosCred').html("");
                $('#divAccesoriosCred').show();
                $('#fieldOtrasComisiones').hide();

            } else {

                $('#divAccesoriosCred').show();
                $('#fieldOtrasComisiones').show();
                agregaFormatoControles('gridDetalleDiv');
                asignaValoresAccesorios();
            }

        } else {
            $('#divAccesoriosCred').html("");
            $('#divAccesoriosCred').show();
            $('#fieldOtrasComisiones').hide();


        }
    });


}

function asignaValoresAccesorios() {

    $("input[name=formaCobro]").each(function(i) {
        var numero = this.id.replace(/\D/g,'');
        var jqIdChecked = eval("'formaCobro" + numero + "'");


        var formaCobro = document.getElementById(jqIdChecked).value;
        if (formaCobro == 'F') {
            $('#formaCobro' + numero).val('FINANCIAMIENTO');
        }
        if (formaCobro == 'A') {
            $('#formaCobro' + numero).val('ANTICIPADO');
        }
        if (formaCobro == 'D') {
            $('#formaCobro' + numero).val('DEDUCCION');
        }
    });


    $("input[name=montoAccesorio]").each(function(i) {
        var numero = this.id.replace(/\D/g,'');
        var jqIdChecked = eval("'montoAccesorio" + numero + "'");


        agregaFormatoMonedaGrid(jqIdChecked)
    });

    $("input[name=montoIVAAccesorio]").each(function(i) {
        var numero = this.id.replace(/\D/g,'');
        var jqIdChecked = eval("'montoIVAAccesorio" + numero + "'");


        agregaFormatoMonedaGrid(jqIdChecked)
    });

}

//Función consulta el total de creditos en la lista
function consultaFilasAccesorios() {
    var totales = 0;
    $('tr[name=renglonAccesorio]').each(function() {
        totales++;

    });
    return totales;
}

function consultaCobraAccesorios(){
    var tipoConsulta = 24;
    var bean = {
            'empresaID'     : 1
        };

    paramGeneralesServicio.consulta(tipoConsulta, bean, { async: false, callback:function(parametro) {
            if (parametro != null){
                cobraAccesoriosGen = parametro.valorParametro;


            }else{
                cobraAccesoriosGen = 'N';
            }

    }});
}

function consultaCobraGarantiaFinanciada(){
    var tipoConsulta = 26;
    var bean = {
            'empresaID'     : 1
        };

    paramGeneralesServicio.consulta(tipoConsulta, bean, { async: false, callback:function(parametro) {
            if (parametro != null){
                cobraGarantiaFinanciada = parametro.valorParametro;

            }else{
                cobraGarantiaFinanciada = 'N';
            }

    }});
}


function consultaMontoFOGAFI() {
    var SolCredBeanCon ={
         'solicitudCreditoID' : $('#solicitudCreditoID').val()
    };
    var numCliente = $('#clienteID').val();
    setTimeout("$('#cajaLista').hide();", 200);
    if(numCliente != '' && !isNaN(numCliente)){
        solicitudCredServicio.consulta(13,SolCredBeanCon,function(solicitud) {
            if(solicitud!=null){

                if(solicitud.montoFOGAFI >0){
                    $('#garantiaFinanciada').show();
                    $('#montoFOGAFI').val(solicitud.montoFOGAFI);
                    $('#modalidadFOGAFI').val(solicitud.modalidadFOGAFI);
                    $('#porcentajeFOGAFI').val(solicitud.porcentajeFOGAFI);
                    $('#montoFOGAFI').formatCurrency({
                        positiveFormat : '%n',
                        roundToDecimalPlace : 2
                    });
                }

            }
        });
    }
}


//Valida que existan Accesorios parametrizados para el producto de crédito
function consultaMontoCredGarFinanciada(creditoID){
    var paramCon = {};
    tipoConsultaCre = 41;

    paramCon['creditoID'] = creditoID;
        creditosServicio.consulta(tipoConsultaCre, paramCon, {
            async : false,
            callback : function(credito) {
                if (credito != null) {
                    $('#montoFOGAFI').val(credito.montoPorcGL);
                    $('#modalidadFOGAFI').val(credito.modalidadFOGAFI);
                    $('#porcentajeFOGAFI').val(credito.porcentajeFOGAFI);

                }
            }
        });

}


//Metodo Para consultar si se maneja convenios
function consultaManejaConvenios(){
    var tipoConsulta = 36;
    var bean = {
            'empresaID'     : 1
        };

    paramGeneralesServicio.consulta(tipoConsulta, bean, { async: false, callback:function(parametro) {
            if (parametro != null){
                manejaConvenio = parametro.valorParametro;
            }else {
                manejaConvenio = 'N';
            }

    }});
}


//CONVENIOS
            function consultaFechaLimite(institucionID, convenioID){
                var calendarioIngresosBean = {
                    'institNominaID': institucionID,
                    'convenioNominaID': convenioID,
                    'anio': 0,
                    'estatus': "",
                };
                setTimeout("$('#cajaLista').hide();", 200);
                calendarioIngresosServicio.consulta(3, calendarioIngresosBean, function(resultado) {
                    if(resultado != null) {
                        $("#fechaLimEnvIns").val(resultado.fechaLimiteEnvio);
                        $(".fechaLimiteEnvio").show();
                    }else{
                        $(".fechaLimiteEnvio").hide();
                        $("#fechaLimEnvIns").val("");
                        $("#institucionNominaID").focus();
                        mensajeSis("El convenio de la institución seleccionada <b>no cuenta con un esquema de calendario autorizado</b> del presente año.");
                    }
                });
            }


            function consultaConvenioNomina(convenioID) {
                var convenioBean = {
                    'convenioNominaID': $('#convenioNominaID').val()
                };
                var convenioID = $('#convenioNominaID').val();
                var institucion = $('#institucionNominaID').val();
                setTimeout("$('#cajaLista').hide();", 200);
                conveniosNominaServicio.consulta(1, convenioBean, function(resultado) {
                    if (resultado != null) {
                        $("#desConvenio").val(resultado.descripcion);
                        if (resultado.requiereFolio=="S") {
                            $('.folioSolici').show();
                        }
                        else{
                            $('.folioSolici').hide();
                            $('#folioSolici').val("");
                        }
                        if (resultado.manejaQuinquenios=="S") {
                            existeEsquemaQConvenio(institucion,convenioID);
                        }
                        else{
                            $(".quinquenios").hide();
                            $("#quinquenioID").val("");
                        }
                        if(resultado.domiciliacionPagos=="S"){
                            $('.ClabeDomiciliacion').show();
                        }
                        else{
                            $('.ClabeDomiciliacion').hide();
                            $('#clabeDomiciliacion').val('');
                        }
                        if (resultado.manejaCalendario == 'S'){
                            consultaFechaLimite();
                        }
                        
                    } else {
                        $("#convenioNominaID").val("");
                        $("#desConvenio").val("");
                        $(".fechaLimiteEnvio").hide();
                        $("#fechaLimEnvIns").val("");
                        $(".quinquenios").hide();
                        $('.folioSolici').hide();
                        $('#folioSolici').val("");
                        dwr.util.removeAllOptions('quinquenioID');
                        dwr.util.addOptions('quinquenioID',{'':'SELECCIONAR'});
                    }
                });
            }

            function consultaNomInstit() {
                var tipoCon = 1;
                var institucion=$('#institucionNominaID').val();

                if (institucion != ''  && !isNaN(institucion) && institucion >0){
                    var institNominaBean = {
                            'institNominaID' : institucion
                    };
                    institucionNomServicio.consulta(tipoCon, institNominaBean, function(institucionNomina) {
                        if (institucionNomina != null){
                            $('#nombreInstit').val(institucionNomina.nombreInstit);
                            if (esNomina == 'S'){
                            	obtenerServiciosAdicionales();
                            }
                        }
                        else {
                            mensajeSis("La Empresa de Nómina no Existe.");
                            $("#fechaLimEnvIns").val("");
                            $(".fechaLimiteEnvio").hide();
                            $('#nombreInstit').val('');
                            $('#institucionNominaID').val('');
                            $('#institucionNominaID').focus();
                        }
                    });
                } else {
                    $('#nombreInstit').val('');
                }
            }
            function listaCatQuinquenios() {
                dwr.util.removeAllOptions('quinquenioID');
                var catQinqueniosBean ={
                    'descripcion': "",
                    'descripcionCorta' : ""
                }
                var tipoLista  = 1;
                dwr.util.addOptions('quinquenioID',{'':'SELECCIONAR'});
                catQuinqueniosServicio.lista(tipoLista, catQinqueniosBean, function(quinquenios){
                    dwr.util.addOptions('quinquenioID', quinquenios, 'quinquenioID', 'descripcionCorta');

                });
            }


            function consultaFechaLimite(){
                var calendarioIngresosBean = {
                    'institNominaID': $('#institucionNominaID').val(),
                    'convenioNominaID': $('#convenioNominaID').val(),
                    'anio': 0,
                    'estatus': "",
                };
                setTimeout("$('#cajaLista').hide();", 200);
                calendarioIngresosServicio.consulta(3, calendarioIngresosBean, function(resultado) {
                    if(resultado != null) {
                        $("#fechaLimEnvIns").val(resultado.fechaLimiteEnvio);
                        $(".fechaLimiteEnvio").show();
                    }else{
                        $(".fechaLimiteEnvio").hide();
                        $("#fechaLimEnvIns").val("");
                        $("#institucionNominaID").focus();
                        mensajeSis("El convenio de la institución seleccionada <b>no cuenta con un esquema de calendario autorizado</b> del presente año.");
                    }
                });
            }

            
            function existeEsquemaQConvenio(institucionID, convenioID){
                
                var esquemaQBean = {
                    'institNominaID': institucionID,
                    'convenioNominaID': convenioID
                };
                setTimeout("$('#cajaLista').hide();", 200);
                esquemaQuinqueniosServicio.consulta(3, esquemaQBean,{ async: false, callback: function(resultado) {
               
                    if(resultado != null) {
                        if(resultado.cantidad > 0){
                         
                            $(".quinquenios").show();
                            noSeguirPro= false;

                        }else{
                           
                            deshabilitaBoton('autorizar','submit');
                            deshabilitaBoton('simular','submit');
                            deshabilitaBoton('agregar','submit');
                            noSeguirPro = true;
                            mensajeSis("El convenio de la Empresa Nómina no cuenta con un Esquema de Quinquenios parametrizado");
                        }
                        
                    }
                    
                }});
            }
            
            function obtenerServiciosAdicionalesAll(productoCreditoID, institNominaID){
            	
            	if(productoCreditoID == '' || isNaN(productoCreditoID)){
            		productoCreditoID = '0';
            	}
            	
            	if(institNominaID == '' || isNaN(institNominaID)){
            		institNominaID = '0';
            	}
            	
            	if (productoCreditoID == '0' && institNominaID == '0'){
            		return;
            	}
            	var servicioAdicionalesBean = {
            	    'productoCreditoID': productoCreditoID,
            	    'institucionNominaID': institNominaID
            	};
            	var tipoConsulta = 2 //por ProductoCreditoID;
            	listaServiciosAdicionales = [];
            	setTimeout("$('#cajaLista').hide();", 200);
            	serviciosAdicionalesServicio.lista(servicioAdicionalesBean, tipoConsulta, function(resultado) {
            	    if(resultado != null) {
            	    	resultado.forEach(function (element){
            	    		listaServiciosAdicionales.push({ servicioID: element.servicioID, descripcion: element.descripcion });
            	    	});	       
            	    }
            	    showServiciosAdicionales();
            	});
            }

            function obtenerServiciosAdicionales(){
            	limpiarServiciosAdicionales();
            	setTimeout(function(){  
            		var productoCreditoID = $('#producCreditoID').val();
                	var institNominaID = $('#institucionNominaID').val();
                	obtenerServiciosAdicionalesAll(productoCreditoID, institNominaID);
            	}, 500);
            }


            function aplicaServiciosAdicionales(solicitudCredito){
            	var aplica = false;
            	if (solicitudCredito.aplicaDesServicio != undefined && solicitudCredito.aplicaDesc === aplicaServicioSi){
            		aplica = true;
            	}
            	return aplica;
            }

            function showServiciosAdicionales(control){

            	if(listaServiciosAdicionales.length > 0){
            		listaServiciosAdicionales = removerDuplicadosServiciosAdicionales(listaServiciosAdicionales);
            	}
            	
            	var solicitudCreditoID = $('#solicitudCreditoID').val();
            	if(solicitudCreditoID == '' || isNaN(solicitudCreditoID)){
            		solicitudCreditoID = '0';
            	}
            		
            	var creditoID = $('#creditoID').val();
            	if(creditoID == '' || isNaN(creditoID)){
        			creditoID = '0';
            	}
        		
            	var html = '';
            	//Si el crédito es nuevo y sin solicitud de credito
            	if(creditoID == '0' && solicitudCreditoID == '0'){
            		html += '<td class="label" nowrap="nowrap"><div class="contenedor-servicios">';
            		listaServiciosAdicionales.forEach(function (element, index, array){
            			html += '<div class="contenedor-servicios-item">';
            		   	html += '<label for="lblsolicitud">Aplica '; 
            		   	html += element.descripcion; 
            		   	html += ':</label>';
            		   	html += '&nbsp;Si&nbsp;<input class="serviciosAdiC" type="radio" id="servicio-'+ element.servicioID +'-si" name="servicioAdiC'+ element.servicioID +'" value="' + element.servicioID + '">&nbsp;';
            		   	html += 'No&nbsp;<input class="serviciosAdiC" type="radio" id="servicio-'+ element.servicioID +'-no" name="servicioAdiC'+ element.servicioID +'" value="0" checked="checked">&nbsp;&nbsp;';
            		   	html += '</div>';
            		});	    
            		html += '</div></td>';
            		$('#divServiciosAdic').html(html);
            		$('#fieldServicioAdic').show();
            	}else{
            		//Si ya existe la solicitud de crédito
            		var serviciosSolCredBean = {
            				'solicitudCreditoID': solicitudCreditoID,
            				'creditoID': creditoID
            		};
            		
            		var tipoConsulta = 2; //por SolicitudCreditoID/CreditoID 
            		setTimeout("$('#cajaLista').hide();", 200);
            		//Obtener servicios adicionales que ha registrado
            		serviciosSolCredServicio.lista(tipoConsulta, serviciosSolCredBean, function(resultado) {
            		    if(resultado != null) {
            		    	var desactiva = '';
            		    	//V = Vigente
            			    if (estatusCredito == 'V') { 
            			    	 desactiva = 'disabled';
            			    }
            		    	resultado.forEach(function (elementRegistro){
            		    		listaServiciosAdicionales.forEach(function (element){
            		    			if (elementRegistro.servicioID == element.servicioID){
            		    				element.checked = 'S';
            		    			}else{
            		    				element.checked = 'N';
            		    			}
            		    		}, elementRegistro);
            		    	});	     
            		    	//Marcamos con checked los elementos que si tienen registrados
            		    	html += '<td class="label" nowrap="nowrap"><div class="contenedor-servicios">';
            				listaServiciosAdicionales.forEach(function (element, index, array){
            					html += '<div class="contenedor-servicios-item">';
            				   	html += '<label for="lblsolicitud">Aplica '; 
            				   	html += element.descripcion; 
            				   	html += ':</label>';
            				   
            				   	if (element.checked === 'S'){
            				   		html += '&nbsp;<label class="label">Si</label>&nbsp;<input class="serviciosAdiC" type="radio" id="servicio-'+ element.servicioID +'-si" name="servicioAdiC'+ element.servicioID +'" value="' + element.servicioID + '" checked="checked" ' + desactiva + '>&nbsp;';
            					   	html += '<label class="label">No</label>&nbsp;<input class="serviciosAdiC" type="radio" id="servicio-'+ element.servicioID +'-no" name="servicioAdiC'+ element.servicioID +'" value="0" ' + desactiva + '>&nbsp;&nbsp;';
            					   	html += '</div>';
            				   	}else{
            				   		html += '&nbsp;<label class="label">Si</label>&nbsp;<input class="serviciosAdiC" type="radio" id="servicio-'+ element.servicioID +'-si" name="servicioAdiC'+ element.servicioID +'" value="' + element.servicioID + '" ' + desactiva + '>&nbsp;';
            					   	html += '<label class="label">No</label>&nbsp;<input class="serviciosAdiC" type="radio" id="servicio-'+ element.servicioID +'-no" name="servicioAdiC'+ element.servicioID +'" value="0" checked="checked" ' + desactiva + '>&nbsp;&nbsp;';
            					   	html += '</div>';
            				   	}
            				});	    
            				html += '</div></td>';
            		    }else{
            		    	//Si no tiene servicios registrados se llama a la lista normal
            		    	html += '<td class="label" nowrap="nowrap"><div class="contenedor-servicios">';
            				listaServiciosAdicionales.forEach(function (element, index, array){
            					html += '<div class="contenedor-servicios-item">';
            				   	html += '<label for="lblsolicitud">Aplica '; 
            				   	html += element.descripcion; 
            				   	html += ':</label>';
            				   	html += '&nbsp;<label class="label">Si</label>&nbsp;<input class="serviciosAdiC" type="radio" id="servicio-'+ element.servicioID +'-si" name="servicioAdiC'+ element.servicioID +'" value="' + element.servicioID + '" ' + desactiva + '>&nbsp;';
            				   	html += '<label class="label">No</label>&nbsp;<input class="serviciosAdiC" type="radio" id="servicio-'+ element.servicioID +'-no" name="servicioAdiC'+ element.servicioID +'" value="0" checked="checked" ' + desactiva + '>&nbsp;&nbsp;';
            				   	html += '</div>';
            				});	    
            				html += '</div></td>';
            		    }
            		
            		    $('#divServiciosAdic').html(html);
            			$('#fieldServicioAdic').show();
            		});
            	}
            }

            function removerDuplicadosServiciosAdicionales(listaServicioAdicionales){
            	var serviciosAdicionalesUnique = new Set();
            	var serviciosAdicionales = [];
            	
            	listaServicioAdicionales.forEach(function(element){
            		serviciosAdicionalesUnique.add(JSON.stringify(element));
            	});
            	
            	serviciosAdicionalesUnique.forEach(function(element){
            		serviciosAdicionales.push(JSON.parse(element));
            	});
            	
            	return serviciosAdicionales;
            }

            function obtenerServiciosAdicChecked() {
            	var checkboxes = $('input:radio:checked.serviciosAdiC');
            	var checkboxesChecked = [];
             
            	for (var i=0; i<checkboxes.length; i++) {
            		if (checkboxes[i].value !== '0'){
            			checkboxesChecked.push({ servicioID: checkboxes[i].value });
            		}
            	}
              
              return checkboxesChecked.length > 0 ? checkboxesChecked : [];
            }

            function limpiarServiciosAdicionales(){
            	listaServiciosAdicionales = [];
            	$('#divServiciosAdic').empty();
            	$('#fieldServicioAdic').hide();
            }

            function listaServiciosAdicionalesACadena(listaServiciosAdicionales){
            	var cadena = '';
            	listaServiciosAdicionales.forEach(function(element, index, array){
            		cadena += element.servicioID;
            		if (index + 1 < array.length){
            			cadena +=  ',';
            		}
            	});
            	return cadena;
            }

            function establecerAplicaServiciosAdicionales(){
            	var serviciosAdicionales = listaServiciosAdicionalesACadena(obtenerServiciosAdicChecked());
            	$('#serviciosAdicionales').val(serviciosAdicionales);
            	if(serviciosAdicionales != ''){
            		$('#aplicaDescServicio').val('S'); //Si
            	}else{
            		$('#aplicaDescServicio').val('N'); //No
            	}
            }

            function desgloseOtrasComisiones(numTransacSim){
            	var listaDesglose = 6;
            	var beanEntrada = {
            			'creditoID':0,
            			'numTransacSim':numTransacSim
            	};
            	esquemaOtrosAccesoriosServicio.lista(listaDesglose, beanEntrada, function(resultado) {
            		if (resultado != null && resultado.length > 0) {

            			var numRegistros = resultado.length;
            			var numAmorAcc = resultado[0].numAmortizacion;
            			var numAccesorios = resultado[0].contadorAccesorios;

            			if (parseInt(numAccesorios) > 0){
            				$('#tdLabelOtrasComis').remove();
            				$('#tdLabelIvaOtrasComis').remove();
            				$('#tdTotalOtrasComis').remove();
            				$('#tdTotalIvaOtrasComis').remove();
            			}

            			var contadorItera = 0;

            			// Itera por accesorio
            			for (var contAcc = 0; contAcc < numAccesorios; contAcc++){

            				var encabezadoLista = resultado[contadorItera].encabezadoLista;
            				var encabezados = encabezadoLista.split(',');
            				var numEncabezados = encabezados.length;

            				// Se inserta el encabezado por comision
            				for (var enc = 0; enc < numEncabezados; enc++){
            					var elemento = encabezados[enc];
            					var encabezado = '<td class="label" align="center"><label for="lblDesglose">'+ elemento +'</label></td>';
            					$(encabezado).insertBefore("#tdEncabezadoAccesorios");
            				}

            				// Se insertan los montos por concepto y por cuota
            				for (var amorAcc = 0; amorAcc < numAmorAcc; amorAcc++){

            					var renglonID = amorAcc + 1;

            					$('#tdOtrasComisiones' + renglonID).remove();
            					$('#tdIvaOtrasComisiones' + renglonID).remove();					

            					var montoCuotaAcc = resultado[contadorItera].montoCuota;
            					var colMontoCuotaAcc = '<td><input id="montoCuotaAcc' + contadorItera +'"  size="18" style="text-align: right;" type="text" value="' + montoCuotaAcc + '" readonly="readonly" esMoneda="true" /></td>';
            					$(colMontoCuotaAcc).insertBefore("#tdMontosAccesorios" + renglonID);
            					var montoIVACuotaAcc = resultado[contadorItera].montoIVACuota;
            					var colMontoIVACuotaAcc = '<td><input id="montoIVACuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + montoIVACuotaAcc + '" readonly="readonly" esMoneda="true" /></td>';
            					$(colMontoIVACuotaAcc).insertBefore("#tdMontosAccesorios" + renglonID);

            					if (resultado[contadorItera].generaInteres == 'S'){
            						var montoIntCuotaAcc = resultado[contadorItera].montoIntCuota;
            						var colMontoIntCuotaAcc = '<td><input id="montoIntCuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + montoIntCuotaAcc + '" readonly="readonly" esMoneda="true" /></td>';
            						$(colMontoIntCuotaAcc).insertBefore("#tdMontosAccesorios" + renglonID);
            						var montoIvaIntCuotaAcc = resultado[contadorItera].montoIVAIntCuota;
            						var colMontoIvaIntCuotaAcc = '<td><input id="montoIvaIntCuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + montoIvaIntCuotaAcc + '" readonly="readonly" esMoneda="true" /></td>';
            						$(colMontoIvaIntCuotaAcc).insertBefore("#tdMontosAccesorios" + renglonID);
            					}

            					// Insercion de totales
            					if ((amorAcc + 1) == numAmorAcc) {
            						var montoTotalAcc = resultado[contadorItera].montoAccesorio;
            						var colTotalMontoCuotaAcc = '<td><input id="totalMontoCuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + montoTotalAcc + '" readonly="readonly" esMoneda="true" /></td>';
            						$(colTotalMontoCuotaAcc).insertBefore("#tdTotalVacio");
            						var ivaTotalAcc = resultado[contadorItera].montoIVAAccesorio;
            						var colTotalMontoIVACuotaAcc = '<td><input id="totalMontoIVACuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + ivaTotalAcc + '" readonly="readonly" esMoneda="true" /></td>';
            						$(colTotalMontoIVACuotaAcc).insertBefore("#tdTotalVacio");

            						if (resultado[contadorItera].generaInteres == 'S'){
            							var interesTotalAcc = resultado[contadorItera].montoInteres;
            							var colTotalMontoIntCuotaAcc = '<td><input id="totalMontoIntCuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + interesTotalAcc + '" readonly="readonly" esMoneda="true" /></td>';
            							$(colTotalMontoIntCuotaAcc).insertBefore("#tdTotalVacio");
            							var ivaInteresTotalAcc = resultado[contadorItera].montoIVAInteres;
            							var colTotalMontoIvaIntCuotaAcc = '<td><input id="totalMontoIvaIntCuotaAcc' + contadorItera +'" size="18" style="text-align: right;" type="text" value="' + ivaInteresTotalAcc + '" readonly="readonly" esMoneda="true" /></td>';
            							$(colTotalMontoIvaIntCuotaAcc).insertBefore("#tdTotalVacio");
            						}
            					}

            					contadorItera += 1;
            				}	
            			}
            		}
            	});
            }
