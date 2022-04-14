var huellaProductos = '';
var nSolicitudSelec = 0;
var validacion_maxminExitosa = false;
var Comercial = 'C';
var Consumo = 'O';
var financiado = "FINANCIAMIENTO";
var TasaFijaID = 1; // ID de la formula para tasa fija (FORMTIPOCALINT)
var TasaBasePisoTecho = 3; // ID de la formula para tasa base con piso y techo (FORMTIPOCALINT)
var hayTasaBase = false; // Indica la existencia de una tasa base
var VarTasaFijaoBase = 'Tasa Fija Anualizada'; // Texto que indica si se trata de tasa fija o tasa base actual (alert)
var deduccion = "DEDUCCION";
var anticipado = "ANTICIPADO";
var programado = "PROGRAMADO";
var costoSeguroVidaCredito = 0;// costo del seguro de vida
var numeroDias = 0; // numero de dias entre fechas
var montoGaranLiq = 0;
var requiereSeg = ""; // indica si requiere o no seguro de vida
var calculaTasa = "";
//declaracion de variables que se ocupan para no recalcular el monto
//a menos que este haya cambiado
var montoSolicitudBase = 0;// monto de la solciitud original (sin accesorios * Com. apertura, Seguro de vida)
var plazoBase=0;//Plazo del credito seleccionado en un inicio por el usuario
var montoComApeBase = 0; // monto de la comision por apertura
var montoIvaComApeBase = 0; // monto del iva de la comision por apertura
var formaCobroComApe = ""; // forma de cobro de la comision por apertura (adelantada, financiamiento, deduccion)
var montoComIvaSol = 0; // monto que incluye el iva, la comision por apertura
// seg vida

//variables que se ocupan como base para saber si los datos seleccionados
//an cambiado y se ejecuten ciertas consultas
var clienteIDBase = 0; // numero de cliente que escoge en un inicio el usuario
var productoIDBase = 0; // numero de producto que escoge en un inicio el usuario
var prospectoIDBase = 0; // numero de prospecto que escoge en un inicio el
// usuario
var grupoIDBase = 0; // numero de grupo que en un inicio se escoge (se usa
// cuando es pantalla individual)
var solicitudIDBase = 0; // numero de solicitud que se indica

//variables que se utilizan para validar el monto minimo o maximo de la
//solicitud
//toman sus valores al consultar el producto de credito
var montoMaxSolicitud = 0.0; // indica el monto maximo que puede escoger en
// la solicitud
var montoMinSolicitud = 0.0; // indica el monto minimo que puede escoger en
// la solicitud

//variables que sirven como base para recalculor el monto del seguro de vida
var fechaVencimientoInicial = "";

//declaracion de variables que sirven como banderas.
var continuar = 0;
var productoCreditoGuardado = 0; // Número del Producto de Credito (Se usa
// solo para la consulta de una Solicitud
// individual)
var procede = 1;
var procedeSubmit = 1;

var parametroBean = consultaParametrosSession();
var usuario = parametroBean.numeroUsuario;
var fechaSucursal = parametroBean.fechaSucursal;
var diaSucursal = parametroBean.fechaSucursal.substring(8, 10);
var diaPagInter = '';
var pagoFinAni = "";
var pagoFinAniInt = "";
var diaHabilSig = "";
var ajustaFecAmo = "";
var ajusFecExiVen = "";
var tipoLista = 0;
var NumCuotas = 0; // se utiliza para saber cuando se agrega o quita una cuota
var NumCuotasInt = 0; // se utiliza para saber cuando se agrega o quita una
var funcionHuella=parametroBean.funcionHuella;
var calificacionCliente = "0.00";  // calificacion numerica del cliente
var cambiarPromotor = parametroBean.cambiaPromotor;
// cuota
var PanSolicitudCredito ='S';
var inicioAfuturo = ''; // indica si el producto de credito permite el desembolso anticipado del credito
var diasMaximo = 0; // Indica el maximo numero dias a los que se puede desembolsar un credito antes de su fecha de inicio
var solicitudEstatus;
var estatusSimulacion = false ; // indica si ya se realizó la simulación
var solicitudPromotor;
var auxDiaPagoCapital;  // variable auxiliar para indicar el dia de pago de capital
var auxDiaPagoInteres; // variable auxiliar para indicar el dia de pago de interes
var modalidad;
var tipoPagoSeg = "";
var esquemaSeguro;
var prodCredito;
var factorRS;
var porcentajeDesc;
var montoPol;
var descuentoSeg;
var pagoSeg;
var dias;
var datosCompletos  = false;
var valorTasaBase   = 0  //Valor de la tasa base cuando el calculo de interes es de tipo 2,3,4.
var permiteSolicitudProspecto = 'S';
var tipoFactorMora = '';
var esNomina = 'N';
var numeroDias = 0;
var frecuenciaMensual = 'M';
var frecuenciaQuincenal = 'Q';
var diaPagoQuincenalCal = '';
var porcentaje = 0.00;
var esAutomatico = 'N';
var tipoAutomatico = '';
var montoMaximoValido = 0.00;
var tasaInversion = 0;
var tasaCuenta = 0;
var tasaTotal   = 0;
var tasaProdCred = 0;
var fechaVencimientoInv = "";
var diasPlazoCredito = 0;
var varGarantizadoInv   = 0;
var montoInversion = 0.00;
var montoEnGarantia = 0.00;
var montoDisponible = 0.00;
var numeroHabitantes = 0;
var numeroHabitantesLocalidad = 0;
var financiamientoRural = 'N';
var grabaTransaccion = 0;
var cobraAccesoriosGen = 'N';
var cobraAccesorios = 'N';
var cicloCliente = 0;
var cobraGarantiaFinanciada = "N";
var CliEspefi = 26 ;
var numeroCliente=0;
var NumClienteConsol = 10;

var restringebtnLiberacionSol = '';
var primerRolFlujoSolID = 0;
var segundoRolFlujoSolID = 0;
var usuarioID =  parametroBean.numeroUsuario;
var rolUsuarioID = 0;
var manejaConvenio = 'N';
var manejaQuin = 'N';
var domiciPagos='N';

//Variables para servicios adicionales
var aplicaServicioSi = 'S';
var enteroCero = '0';
var listaServiciosAdicionales = [];
var estatusSolicitudCredito = '';

var reqInstruDispersion= '';
var manejaCalendario = '';

tipoConAccesorio = {
    'producto'  : 38,
    'plazo'     : 39
};

expedienteBean = {
        'clienteID' : 0,
        'tiempo' : 0,
        'fechaExpediente' : '1900-01-01',
};

listaPersBloqBean = {
        'estaBloqueado' :'N',
        'coincidencia'  :0
};

consultaSPL = {
		'opeInusualID' : 0,
		'numRegistro' : 0,
		'permiteOperacion' : 'S',
		'fechaDeteccion' : '1900-01-01'
};

var esCliente           ='CTE';
var esUsuario           ='USS';
var esProspecto			='PRO';

$('#pantalla').val(PanSolicitudCredito);
var catTipoConsultaInversion = {
        'principal' : 1
    };

var catStatusInversion = {
    'alta':     'A',
    'vigente':  'N',
    'pagada':   'P',
    'cancelada':'C'
};

var catDiaPagoQuinc = {
    'Indistinto'    : 'I',
    'DiaQuincena'   : 'D',
    'Quincenal'     : 'Q'
};

//variables para esquemas por convenio
var manejaEsqConvenio = false;
var cobraComisionApertConvenio = false;
var cobraMoraConvenio = false;
var esqCobroComApert = {};
var editaSucursal = "N";
var diaSistema  = "";
$(document).ready(
        function() {
            esTab = true;

            var productoCredito = 0;


            // Definicion de Constantes y Enums
            var catTipoConsultaSolicitud = {
                    'principal' : 1,
                    'foranea' : 2
            };

            var catTipoTranSolicitud = {
                    'agrega' : 1,
                    'modifica' : 2,
                    'actualiza' : 3
            };

            var catTipoActSolicitud = {
                    'liberar' : 5
            };

            var catTipoConsultaSeguroVida = {
                    'principal' : 1,
                    'foranea' : 2
            };

            var catTipoListaInversion = {
                    'inversionVigente': 7
                };

            var catStatusInversion = {
                    'alta':     'A',
                    'vigente':  'N',
                    'pagada':   'P',
                    'cancelada':'C'
                };
            diaSistema = parametroBean.fechaAplicacion.substring(8,10);
            //Métodos para el Manejo de Convenios
            consultaManejaConvenios();


            // ------------ Metodos y Manejo de Eventos Solicitud Grupal  -----------------------------------------
            muestraSeccionSeguroCuota();
            agregaFormatoControles('formaGenerica');
            $('#sucursalID').val(parametroBean.sucursal);
            deshabilitaBoton('modificar', 'submit');
            deshabilitaBoton('agregar', 'submit');
            validaEmpresaID(); //Se consulta parametro de huella por producto.
            consultaComboCalInteres(); //llena el combo para la formula del calculo de intereses
            mostrarLabelTasaFactorMora('');
            consultaSICParam();
            ocultaCamposAutomatico();
            consultaCobraAccesorios();
            consultaCobraGarantiaFinanciada();

            consultaRolesLiberaRechazaSol();
            consultaRolUssuario();
            deshabilitaControl('folioCtrl');
            $('#fieldOtrasComisiones').show();
            $('#fieldServicioAdic').show();


            ClienteEspeficio();
             if(manejaConvenio=='S'){
            listaCatQuinquenios();
             }

            $("#convenios").hide();
            $(".folioSolici").hide();
            $("#folioSolici").val("");
            $(".quinquenios").hide();
            $("#quinquenioID").val("");
            $(".fechaLimiteEnvio").hide();
            $("#fechaLimEnvIns").val("");
            $('#clabeDomiciliacion').val('');
            $('.ClabeDomiciliacion').hide();

            $('#ctaClabeTxt').hide();
            $('#ctaClabeInput').hide();
            $('#tipoSantander').attr("checked",true);
            $('#tipoOtroBanco').attr("checked",false);
            $('#dispSantander').hide();
            $('#tipoCtaSantander').val('');
            $('#ctaSantander').val('');
            $('#ctaClabeDisp').val('');



            if(numeroCliente == NumClienteConsol){
                $('#complementoSeguroVida').show();
                $('#complementoSeguroVida2').show();
            }else{
                $('#complementoSeguroVida').hide();
                $('#complementoSeguroVida2').hide();
            }





            // si ya hay una solicitud en el grupo.
            if ($('#numSolicitud').asNumber() >= 0) { // numSolicitud
                // hace  referencia a  jsp  solicitudCreditoGrupalCatalogoVista.jsp

                var numSolicitud = $('#numSolicitud').val();

                nSolicitudSelec = numSolicitud;

                $('#solicitudCreditoID').val(numSolicitud);
                $('#solicitudCreditoID').focus().select();


                if ($('#puedeAgregarSolicitudes').val() == 'N') {// puedeAgregarSolicitudes
                    // hace referencia  a  jsp  solicitudCreditoGrupalCatalogoVista.jsp
                    deshabilitaControl('solicitudCreditoID');
                }

                // eventos para cliente

                $('#clienteID').bind('keyup',function(e){
                    lista('clienteID', '3', '14', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
                });


                $('#buscarMiSuc').click(function(){
                    listaCte('clienteID', '3', '26', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
                });
                $('#buscarGeneral').click(function(){
                    listaCte('clienteID', '3', '14', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
                });


                esTab = true;
                validaSolicitudCredito('solicitudCreditoID');

                if ($('#productoCreditoID').val() == ''){
                	productoCredito = $('#prodCreditoID').val();
                    $('#productoCreditoID').val(productoCredito);
                }
                // si la lista esta vacia  puede puede modificar el  producto de credito para que se instancien al  grupo
                if (productoCredito != 0){
                    deshabilitaControl('productoCreditoID');
                }
                $('#liberar').hide();

                if ($('#grupo').val() != undefined) {
                    funcionMuestraDivGrupo();
                } else {
                    funcionOcultaDivGrupo();
                }
            } else {
                iniciaPantallaSolicitudGrupal();
                deshabilitaBoton('agregar', 'submit');
                deshabilitaBoton('modificar', 'submit');
                deshabilitaBoton('liberar', 'submit');
                $('#liberar').hide();
                $('#simular').hide();
                $('#trMontoSeguroVida').hide();
                $('#trBeneficiario').hide();
                $('#trParentesco').hide();
            }
            // Fin Metodos y Manejo de Eventos Solicitud Grupal





            // -------------------------- Metodos y Manejo de Eventos -----------------------------------------

            $.validator.setDefaults({submitHandler : function(event) {
                if(($("#tipoTransaccion").val() == 1 || $("#tipoTransaccion").val() == 2) && estatusSimulacion == false &&
                        $("#tipoPagoCapital").val() != 'L'){
                    mensajeSis("Se Requiere Simular las Amortizaciones.");
                }
                else{
                    procedeSubmit = validaCamposRequeridos();
                    if($("#tipoFondeo2").is(':checked')){
                        if(financiamientoRural == 'S'){
                            evaluaFinanciamientoRural();
                        }

                    }

                    if (procedeSubmit == 0 && grabaTransaccion == 0) {
                        procedeSubmit = validaUltimaCuotaCapSimulador();
                        if (procedeSubmit == 0) {
                            if(manejaConvenio=='S'){
                            consultaEsquemaQuinquenio();}
                            else{grabarTransaccion({});}
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

            $(':text').focus(function() {
                esTab = false;
            });

            $('#agregar').click(function() {
            	establecerAplicaServiciosAdicionales();
                $('#tipoTransaccion').val(catTipoTranSolicitud.agrega);
                $('#tipoActualizacion').val('0');
            });

            $('#modificar').click(function() {
            	establecerAplicaServiciosAdicionales();
                $('#tipoTransaccion').val(catTipoTranSolicitud.modifica);
                $('#tipoActualizacion').val('0');
            });

            $('#liberar').click(function() {
                $('#tipoTransaccion').val(catTipoTranSolicitud.actualiza);
                $('#tipoActualizacion').val(catTipoActSolicitud.liberar);
            });

            $("#convenioNominaID").blur(function(event) {
                if(manejaConvenio=='S'){
                consultaConvenioNomina($("#convenioNominaID").val());
                }
            });

            // eventos para cliente
    $('#clienteID').blur(function() {
        setTimeout("$('#cajaLista').hide();", 200);
        var prospec = $('#prospectoID').val();
        var clienteBloq = $('#clienteID').asNumber();
        if (clienteBloq > 0) {
            listaPersBloqBean = consultaListaPersBloq(clienteBloq, esCliente, 0, 0);
            consultaSPL = consultaPermiteOperaSPL(clienteBloq,'LPB',esCliente);
			if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
                expedienteBean = consultaExpedienteCliente($('#clienteID').val());
                if (expedienteBean.tiempo <= 1) {
                    if (alertaCte(clienteBloq) != 999) {
                        if (prospec == '0' || prospec == '') {
                            if ($('#clienteID').val() == '0' || $('#clienteID').val() == '' && esTab == true) {
                                mensajeSis("Especificar " + $('#alertSocio').val() + " o Prospecto.");
                                $('#prospectoID').focus();
                                $('#nombreCte').val("");
                                $('#promotorID').val("");
                                $('#nombrePromotor').val("");
                            }
                        }

                        if (isNaN($('#clienteID').val())) {
                            $('#clienteID').val("");
                            $('#clienteID').focus();
                            $('#nombreCte').val("");
                            $('#promotorID').val("");
                            $('#nombrePromotor').val("");
                            $('#prospectoID').val("");
                            $('#nombreProspecto').val("");
                        } else {

                            if (clienteIDBase != $('#clienteID').asNumber() || $.trim($('#clienteID').val()) != "") {
                                clienteIDBase = $('#clienteID').asNumber();
                                calculaTasa = 'S';
                                consultaCliente($('#clienteID').val(), calculaTasa);

                                validaDatosGrupales('productoCreditoID', Number($('#solicitudCreditoID').val()), Number($('#prospectoID').val()), Number($('#clienteID').val()), Number($('#productoCreditoID').val()), Number($('#grupoID').val()));

                                consultaPorcentajeGarantiaLiquida(this.id);


                                if(cobraGarantiaFinanciada == 'S'){
                                    consultaPorcentajeFOGAFI(this.id);
                                }
                            }
                        }
                    }
                } else {
                    mensajeSis('Es necesario Actualizar el Expediente del ' + $('#alertSocio').val() + ' para Continuar.');
                    $('#clienteID').val("");
                    $('#clienteID').focus();
                    $('#nombreCte').val("");
                    $('#promotorID').val("");
                    $('#nombrePromotor').val("");
                    $('#prospectoID').val("");
                    $('#nombreProspecto').val("");
                }
            } else {
                mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
                $('#clienteID').val("");
                $('#clienteID').focus();
                $('#nombreCte').val("");
                $('#promotorID').val("");
                $('#nombrePromotor').val("");
                $('#prospectoID').val("");
                $('#nombreProspecto').val("");
            }
        }
    });

            // eventos para prospecto
            $('#prospectoID').bind('keyup',function(e) {
                lista('prospectoID', '1', '1', 'prospectoID', $('#prospectoID').val(), 'listaProspecto.htm');
            });

            $('#prospectoID').blur(function() {
                if (prospectoIDBase != $('#prospectoID').asNumber() && $.trim($('#prospectoID').val()) != "" && esTab == true) {
                    prospectoIDBase = $('#prospectoID').asNumber();
                    consultaProspecto(this.id);
                    validaDatosGrupales('productoCreditoID',Number($('#solicitudCreditoID').val()),
                            Number($('#prospectoID').val()),Number($('#clienteID').val()),
                                            Number($('#productoCreditoID').val()), Number($('#grupoID').val()));
                    consultaPorcentajeGarantiaLiquida(this.id);
                    if(cobraGarantiaFinanciada == 'S'){
                        consultaPorcentajeFOGAFI(this.id);
                    }
                }
                if ($('#prospectoID').val() == '' || $('#prospectoID').val() == '0') {
                    $('#nombreProspecto').val('');
                    habilitaControl('clienteID');
                }

            });

            // eventos para producto de credito
            $('#productoCreditoID').bind('keyup',function(e) {
                        lista('productoCreditoID', '1', '15','descripcion', $('#productoCreditoID').val(),'listaProductosCredito.htm');
            });

            $('#productoCreditoID').focus(function() {
                if ($('#prospectoID').asNumber() == '0') {
                    if ($('#clienteID').asNumber() == '0') {
                        mensajeSis("Especificar "+$('#alertSocio').val()+" o Prospecto");
                        $('#prospectoID').focus();
                        $('#nombreCte').val("");
                        $('#promotorID').val("");
                        $('#nombrePromotor').val("");
                    }
                if(funcionHuella=="S" && huellaProductos=="S" ){
                        consultaHuellaCliente();
                }
                }
            });

            $('#productoCreditoID').blur(function() {
                if (isNaN($('#productoCreditoID').val() && esTab == true)) {
                    $('#productoCreditoID').val("");
                    $('#productoCreditoID').focus();
                    $('#descripProducto').val("");
                    limpiarServiciosAdicionales();
                } else {
                    if ($('#productoCreditoID').asNumber()>0 && $.trim($('#productoCreditoID').val()) != "" ) {
                        if (esTab == true) {
                            productoIDBase = $('#productoCreditoID').asNumber();

                            // si la solicitud es cero (se trata de una nueva solicitud)
                            if ($('#solicitudCreditoID').asNumber() == 0) {
                                consultaProducCredito(this.id, true);
                                validaDatosGrupales('productoCreditoID',Number($('#solicitudCreditoID').val()),
                                        Number($('#prospectoID').val()),Number($('#clienteID').val()),
                                        Number($('#productoCreditoID').val()),
                                        Number($('#grupoID').val()));
                            } else {
                                consultaProducCredito(this.id, true);
                            }
                            if(cobraAccesorios=='S' && validaAccesorios(tipoConAccesorio.producto)==false){
                                mensajeSis("No existen Accesorios parametrizados para el Producto de Crédito.");
                                setTimeout("$('#productoCreditoID').focus();",0);
                            }
                            else{
                                if(validaAccesorios(tipoConAccesorio.producto)==true && cobraAccesorios == 'S'){
                                    muestraGridAccesorios();
                                }

                            }
                        }
                    }
                }
            });

            $('#grupoID').blur(function() {
                if (isNaN($('#grupoID').val())&& esTab == true) {
                            $('#grupoID').val("");
                            $('#grupoID').focus();
                            $('#nombreGr').val("");
                            grupoIDBase = 0;
                        } else {
                            if (grupoIDBase != $('#grupoID').asNumber() && $.trim($('#grupoID').val()) != "") {
                                if (esTab == true) {
                                    grupoIDBase = $('#grupoID').val();
                                    consultaGrupo(this.id);
                                    validaDatosGrupales('productoCreditoID',Number($('#solicitudCreditoID').val()), Number($('#prospectoID').val()),Number($('#clienteID').val()),
                                            Number($('#productoCreditoID').val()),Number($('#grupoID').val()));
                                }
                            }
                        }

                    });


            $("#fechaInicioAmor").blur(function (){
                if(!$("#fechaInicioAmor").is('[readonly]')){
                    var dias;

                    if(this.value != ""){
                        if(esFechaValida(this.value,"fechaInicioAmor")== true){
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

            $('#grupoID').bind('keyup', function(e) {
                if ($('#grupo').val() == undefined) {
                    if (this.value.length >= 2) {
                        var camposLista = new Array();
                        var parametrosLista = new Array();
                        camposLista[0] = "nombreGrupo";
                        parametrosLista[0] = $('#grupoID').val();
                        listaAlfanumerica('grupoID', '1', '1',camposLista, parametrosLista,'listaGruposCredito.htm');
                    }
                }
            });

            $('#destinoCreID').bind('keyup',function(e) {
                if ( !isNaN($('#productoCreditoID').val()) ) {
                    var camposLista = new Array();
                    var parametrosLista = new Array();
                    camposLista[0] = 'destinoCreID';
                    camposLista[1] = 'producCreditoID';
                    parametrosLista[0] = $('#destinoCreID').val();
                    parametrosLista[1] = $('#productoCreditoID').val();
                    lista('destinoCreID', '2', '2', camposLista, parametrosLista,'listaDestinosCredito.htm');
                }
            });

            $('#destinoCreID').blur(function() {
                if (isNaN($('#destinoCreID').val())) {
                    $('#destinoCreID').val("");
                    $('#destinoCreID').focus();
                    $('#descripDestino').val("");
                } else {
                    esTab = true;
                    consultaDestinoCredito(this.id);
                }
            });

            $('#promotorID').bind('keyup',function(e) {
                var numLista = 10;
                var camposLista = new Array();
                var parametrosLista = new Array();
                camposLista[0] = 'nombrePromotor';
                camposLista[1] = 'sucursalID';
                parametrosLista[0] = $('#promotorID').val();
                parametrosLista[1] = $('#sucursalCte').val();

                if(editaSucursal=="S"){
                    numLista = 4;
                }
                lista('promotorID', '1', numLista, camposLista,parametrosLista,'listaPromotores.htm');
            });

            $('#promotorID').blur(function() {
                if(isNaN($('#promotorID').val()) || $('#promotorID').val()==""){
                    $('#promotorID').val('');
                    $('#nombrePromotor').val('');
                    $('#promotorID').focus();
                }else{
                    consultaPromotor(this.id, true);
                }

            });

            $('#solicitudCreditoID').bind('keyup',function(e) {
                        if (this.value.length >= 0) {
                            var camposLista = new Array();
                            var parametrosLista = new Array();

                            camposLista[0] = "clienteID";
                            parametrosLista[0] = $('#solicitudCreditoID').val();

                            lista('solicitudCreditoID', '1', '1',camposLista, parametrosLista,'listaSolicitudCredito.htm');
                        }
                    });

            $('#plazoID').change(function() {

                consultaFechaVencimiento(this.id);

            });

            $('#quinquenioID').blur(function() {
                if(manejaConvenio=='S')
                    {  if(manejaQuin == 'S'){
                             plazoCorrectoEsquemaQ();
                         }
                    }
            });

            $('#plazoID').blur(function() {
                    if($('#plazoID').val()!='0' && $('#plazoID').val()!=''){

                         if(manejaConvenio=='S')
                             {  if(manejaQuin == 'S')
                                 {
                                    plazoCorrectoEsquemaQ();
                                 }
									// valida esquema de comision apertura  por convenio
  					             if(manejaEsqConvenio){
      					            validaComApertPlazo();
                             	 }
                               }

                        if($('#montoSolici').val()!='0' && $('#montoSolici').val()!=''){
                            calculoCostoSeguro();
                            consultaFechaVencimiento(this.id);
                            consultaPorcentajeGarantiaLiquida('montoSolici');
                            if(cobraGarantiaFinanciada == 'S'){
                                consultaPorcentajeFOGAFI('montoSolici');
                            }
                            if(esAutomatico== 'S'){
                                calculoTasasAutomaticos();
                            }
                            if(cobraAccesorios=='S' && manejaConvenio=='N' && validaAccesorios(tipoConAccesorio.plazo)==false){
                                mensajeSis("No existen Accesorios parametrizados para el Plazo y Producto de Crédito.");
                                setTimeout("$('#montoSolici').focus();",0);
                            }
                            if(cobraAccesorios=='S' && manejaConvenio =='S' && validaAccesorios(tipoConAccesorio.plazo)==false){
                                cobraAccesorios = 'N';
                            }
                            else{
                                if(validaAccesorios(tipoConAccesorio.plazo)==true && cobraAccesorios == 'S'){
                                    muestraGridAccesorios();
                                }
                            }

                        }
                        else{
                            mensajeSis('Especifique el Monto Solicitado');
                            $('#montoSolici').focus();
                        }

                    }
                    else{
                        mensajeSis("Especificar el Plazo del Crédito");
                        $('#plazoID').focus();

                    }

            });



            $('#montoSolici').blur(function() {
                if ($('#montoSolici').val() != '' && esTab==true) {
                    // si el producto de credito no se ha especificado se solicita indicarlo
                    if ($('#productoCreditoID').val() == '') {
                        mensajeSis("Especificar Producto de Crédito");
                        $('#productoCreditoID').focus();
                        $('#montoSolici').val("0.00");
                        montoSolicitudBase = 0.00;

                    } else {

                            if(inicioAfuturo == 'S'){
                                $('#fechaInicioAmor').focus();
                            }
                            else {
                                    $('#plazoID').focus();
                                }

                            /*consulta el porcentaje de GL de la tabla de esquemas de garantia liquida */
                            if($('#plazoID').val()!='0' && $('#plazoID').val()!=''){
                                calculaNodeDias($('#plazoID').val());

                            }
                            consultaPorcentajeGarantiaLiquida(this.id);
                            if(cobraGarantiaFinanciada == 'S'){
                                consultaPorcentajeFOGAFI();
                            }


                            validaAutomatico();
                            if(esAutomatico== 'S' && tipoAutomatico== 'I'){
                                calculoCostoSeguro();
                                consultaFechaVencimiento('plazoID');
                                consultaPorcentajeGarantiaLiquida('montoSolici');
                                if(cobraGarantiaFinanciada == 'S'){
                                    consultaPorcentajeFOGAFI('montoSolici');
                                }
                                calculoTasasAutomaticos();
                            }

                            if(validaAccesorios(tipoConAccesorio.producto)==true && cobraAccesorios == 'S' && $('#solicitudCre1').asNumber() > 0){
                                muestraGridAccesorios();
                            }



                        }

                }
                $('#montoSolici').formatCurrency({
                    positiveFormat : '%n',
                    roundToDecimalPlace : 2
                });


                if($('#auxTipPago').val() != ""){
                    var aux = $('#auxTipPago').val();
                    $('#forCobroSegVida').val(aux);
                    calculoCostoSeguro();
                    calculaMontoGarantiaLiquida($('#porcGarLiq').asNumber());
                    if(cobraGarantiaFinanciada == 'S'){
                        calculaMontoGarantiaFinanciada($('#porcentajeFOGAFI').asNumber());
                    }

                }



            });
            $('#montoSolici').change(function(){

                if($('#montoSolici').val() != '' && isNaN($('#montoSolici').val()) && esTab== false){

                    consultaPorcentajeGarantiaLiquida(this.id);
                    if(cobraGarantiaFinanciada == 'S'){
                        consultaPorcentajeFOGAFI(this.id);
                    }
                    validaAutomatico();
                }
            });



            $('#institutFondID').bind('keyup',function(e) {
                        lista('institutFondID', '1', '1','nombreInstitFon', $('#institutFondID').val(),'intitutFondeoLista.htm');
            });

            $('#institutFondID').blur(function() {
                consultaInstitucionFondeo(this.id);
            });

            $('#lineaFondeoID').bind('keyup',function(e) {
                        lista('lineaFondeoID', '2', '1','descripLinea', $('#lineaFondeoID').val(),'listaLineasFondeador.htm');
            });

            $('#lineaFondeoID').change(function() {
                if (isNaN($('#lineaFondeoID').val())) {
                    $('#lineaFondeoID').val("");
                    $('#lineaFondeoID').focus();
                    $('#descripLineaFon').val('');
                    $('#saldoLineaFon').val('');
                    $('#tasaPasiva').val('');
                } else {
                    esTab = true;
                    consultaLineaFondeo(this.id);
                }
            });

            $('#lineaFondeoID').blur(function() {
                if (isNaN($('#lineaFondeoID').val())) {
                    $('#lineaFondeoID').val("");
                    $('#lineaFondeoID').focus();
                    $('#descripLineaFon').val('');
                    $('#saldoLineaFon').val('');
                    $('#tasaPasiva').val('');
                } else {
                    if (esTab == true) {
                        consultaLineaFondeo(this.id);
                    }
                }
            });

            $('#tipoFondeo').click(function() {
                deshabilitaControl('institutFondID');
                deshabilitaControl('lineaFondeoID');
                $('#institutFondID').val("0");
                $('#lineaFondeoID').val("0");
                $('#descripFondeo').val("");
                $('#descripLineaFon').val("");
                $('#saldoLineaFon').val("");
                $('#tasaPasiva').val("");
                grabaTransaccion = 0;
            });

            $('#tipoFondeo2').click(function() {
                habilitaControl('lineaFondeoID');
                consultaInstitucionFondeo('institutFondID');
            });

            $('#tipoDispersion').blur(function() {
                if ($('#tipoDispersion').val() == 'S') {
                    habilitaControl('cuentaCLABE');
                    $('#cuentaCLABE').focus();
                } else {
                    deshabilitaControl('cuentaCLABE');
                    $('#cuentaCLABE').val('');

                }

                if($('#tipoDispersion').val() == 'A' && reqInstruDispersion != 'S'){
                	$('#dispSantander').show();
                	$('#tipoSantander').attr('checked',true);
                	$('#tipoOtroBanco').attr('checked',false);
                	$('#ctaSantander').val('');
                	$('#ctaClabeDisp').val('');
                	$('#ctaClabeTxt').hide();
                    $('#ctaClabeInput').hide();
                    $('#tipoCtaSantander').val('A');
                    $('#ctaSantander').focus();
                }else{
                	$('#dispSantander').hide();
                	$('#tipoSantander').attr('checked',true);
                	$('#tipoOtroBanco').attr('checked',false);
                	$('#ctaSantander').val('');
                	$('#ctaClabeDisp').val('');
                	$('#ctaClabeTxt').hide();
                    $('#ctaClabeInput').hide();
                    $('#tipoCtaSantander').val('');
                }

                consultaPorcentajeGarantiaLiquida('montoSolici');
                if(cobraGarantiaFinanciada == 'S'){
                        consultaPorcentajeFOGAFI('montoSolici');
                }
                if(esAutomatico== 'S'){
                    calculoTasasAutomaticos();
                }

            });

            $('#cuentaCLABE').blur(function() {
                if ($('#cuentaCLABE').val() == "" && $('#tipoDispersion').val() == 'S') {
                    mensajeSis("Cuenta CLABE requerida");
                    $('#tipoDispersion').focus();
                } else {
                    // valida que los primeros tres digitos de  la cuenta clabe correspondan con alguna  institucion
                    validaSpei(this.id, this.id);
                }
            });

            /**
             * SESSION PARA DISPERSION POR SANTANDER
             */
            $('#tipoSantander').click(function(){
            	$('#tipoSantander').attr('checked',true);
            	$('#tipoOtroBanco').attr('checked',false);
            	$('#ctaSantander').val('');
            	$('#ctaClabeDisp').val('');
            	$('#ctaClabeTxt').hide();
                $('#ctaClabeInput').hide();
                $('#lblCuentaCLABE').show();
    			$('#inputCuentaCLABE').show();
                $('#ctaSantanderTxt').show();
                $('#ctaSantanderInput').show();
                $('#tipoCtaSantander').val('A');
            });

            $('#tipoOtroBanco').click(function(){
            	$('#tipoSantander').attr('checked',false);
            	$('#tipoOtroBanco').attr('checked',true);
            	$('#ctaSantander').val('');
            	$('#ctaClabeDisp').val('');
            	$('#ctaClabeTxt').show();
                $('#ctaClabeInput').show();
                $('#lblCuentaCLABE').hide();
    			$('#inputCuentaCLABE').hide();

                $('#ctaSantanderTxt').hide();
                $('#ctaSantanderInput').hide();
                $('#tipoCtaSantander').val('O');
            });

            $('#ctaClabeDisp').blur(function(){
            	validaCtaClabe(this.id);
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

            $('#parentescoID').bind( 'keyup', function(e) {
                if (this.value.length >= 2) {
                    lista('parentescoID', '2', '1', 'descripcion', $('#parentescoID').val(), 'listaParentescos.htm');
                }
            });

            $('#parentescoID').blur(function() {
                consultaParentesco(this.id);
            });

            $('#solicitudCreditoID').blur(function() {
                deshabilitaControl('sucursalCte');
                consultaRolesLiberaRechazaSol();
                estatusSimulacion = false ;
                if ((isNaN($('#solicitudCreditoID').val()) || $('#solicitudCreditoID').val()==0) && esTab == true) {
                    $('#solicitudCreditoID').val("0");
                    inicializaValoresNuevaSolicitud();
                    muestraSeccionSeguroCuota();
                    limpiarServiciosAdicionales();
                    //METODO EDITA SUCURSAL
                    consultaModificaSuc(true);
                    habilitaInputsSolGrupal();
                    validaSolicitudCredito(this.id);//RLAVIDA_AJUSTE_TICKET_13690 PARA CONSULTAR PRIMEROS VALORES DE LA SOLICITUD GRUPAL
                } else {
                    if ($.trim($('#solicitudCreditoID').val()) != "" && esTab == true) {

                        validaSolicitudCredito(this.id);
                        if((listaPersBloqBean.estaBloqueado == 'N' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
                        	consultaEsquemaSeguroVidaForanea(tipoPagoSeg);
                            validacion_maxminExitosa = false;
                            validaDatosGrupales('productoCreditoID',Number($('#solicitudCreditoID').val()),
                                    Number($('#prospectoID').val()),Number($('#clienteID').val()),
                                                    Number($('#productoCreditoID').val()),
                                                    Number($('#grupoID').val()));
                            validacionAccesorios();
                        }


                    }

                }

            });


            $('#lblnomina').hide();
            $('#institNominaID').hide();
            $('#lblFolioCtrl').hide();
            $('#folioCtrlCaja').hide();
            $('#sep').hide();

            $('#institucionNominaID').bind('keyup', function(e) {
                var camposLista = new Array();
                var parametrosLista = new Array();
                camposLista[0] = 'institNominaID';
                camposLista[1] = 'clienteID';
                parametrosLista[0] = $('#institucionNominaID').val();
                parametrosLista[1] = $('#clienteID').val();
                if(manejaConvenio=='S'){
                    lista('institucionNominaID', '2', '2', camposLista, parametrosLista,'institucionesNomina.htm');
                }else{
                    lista('institucionNominaID', '2', '1', camposLista, parametrosLista,'institucionesNomina.htm');
                }

            });

            $('#institucionNominaID').blur(function() {
                $(".quinquenios").hide();
                if($('#institucionNominaID').val().trim()=="" && esNomina== 'S' && esTab ==true){
                    mensajeSis("La Empresa de Nómina esta Vacía.");
                    $('#institucionNominaID').focus();
                    if (esNomina === 'S'){
                    	obtenerServiciosAdicionales();
                    }
                } else {
                    consultaNomInstit();
                    if(manejaConvenio == 'S')
                    {
                    	esComApertPorConvenio();
                    }
                }
            });


            $('#inversionID').bind('keyup',function(e){
                if(this.value.length >= 3){

                     var camposLista = new Array();
                     var parametrosLista = new Array();
                     camposLista[0] = "etiqueta";
                     camposLista[1] = "clienteID";
                     parametrosLista[0] = $('#inversionID').val();
                     parametrosLista[1] = $('#clienteID').val();

                    lista('inversionID', 2, catTipoListaInversion.inversionVigente, camposLista, parametrosLista, 'listaInversiones.htm');
                }
            });

            $('#inversionID').blur(function(){
                validaInversion(this.id);
                deshabilitaControl('plazoID');
            });

            $('#cuentaAhoID').bind('keyup', function(e) {

                if (this.value.length >= 2) {
                        var camposLista = new Array();
                        var parametrosLista = new Array();
                        camposLista[0] = "cuentaAhoID";
                        camposLista[1] = "clienteID";
                        parametrosLista[0] = $('#cuentaAhoID').val();
                        parametrosLista[1] = $('#clienteID').val();
                        listaAlfanumerica('cuentaAhoID', '3', '20', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');


                }
            });

            $('#cuentaAhoID').blur(function() {
                validaCtaAho(this.id);

            });

            // ------------------------- EVENTOS PARA SECCION DE CALENDARIO DE PAGOS -------------------------------- //
            $('#fechInhabil1').click(function() {
                $('#fechInhabil2').attr('checked', false);
                $('#fechInhabil1').attr('checked', true);
                $('#fechInhabil').val("S");
                $('#fechInhabil1').focus();
            });

            $('#fechInhabil2').click(function() {
                $('#fechInhabil1').attr('checked', false);
                $('#fechInhabil2').attr('checked', true);
                $('#fechInhabil').val("N");
                $('#fechInhabil2').focus();
            });

            $('#ajusFecExiVen1').click(function() {
                $('#ajusFecExiVen2').attr('checked', false);
                $('#ajusFecExiVen1').attr('checked', true);
                $('#ajusFecExiVen').val("S");
                $('#ajusFecExiVen1').focus();
            });

            $('#ajusFecExiVen2').click(function() {
                $('#ajusFecExiVen1').attr('checked', false);
                $('#ajusFecExiVen2').attr('checked', true);
                $('#ajusFecExiVen').val("N");
                $('#ajusFecExiVen2').focus();
            });

            $('#ajFecUlAmoVen1').click(function() {
                $('#ajFecUlAmoVen2').attr('checked', false);
                $('#ajFecUlAmoVen1').attr('checked', true);
                $('#ajFecUlAmoVen').val("S");
                $('#ajFecUlAmoVen1').focus();
            });

            $('#ajFecUlAmoVen2').click(function() {
                $('#ajFecUlAmoVen1').attr('checked', false);
                $('#ajFecUlAmoVen2').attr('checked', true);
                $('#ajFecUlAmoVen').val("N");
                $('#ajFecUlAmoVen2').focus();
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
            $('#diaPagoCapital1').blur( function() {
                var frecuenciaCapital = $('#frecuenciaCap').val();
                consultarFrecuencia(frecuenciaCapital);
                if($("#diaPagoCapital1").is(':checked') && frecuenciaCapital ==frecuenciaMensual){
                    deshabilitaControl('diaMesCapital');
                }
            });

            $('#diaPagoCapital2').blur( function() {
                var frecuenciaCapital = $('#frecuenciaCap').val();
                if($("#diaPagoCapital1").is(':checked') && frecuenciaCapital ==frecuenciaMensual){
                    deshabilitaControl('diaMesCapital');
                }
            });

            $('input[name="diaPagoCapital3"]').change(function (event){
                var diaPagoCapital3 = $('input[name="diaPagoCapital3"]:checked').val();
                if(diaPagoCapital3 == 'D'){
                    habilitaControl('diaMesCapital');
                    $('#diaMesCapital').val('');
                    $('#diaDosQuincCap').show();
                }
                if(diaPagoCapital3 == 'Q'){
                    deshabilitaControl('diaMesCapital');
                    $('#diaMesCapital').val('15');
                    $('#diaDosQuincCap').hide();
                }
                $('#diaDosQuincCap').val('');
                $('#diaPagoCapital').val(diaPagoCapital3);


                // GHERNANDEZ
                 if(manejaConvenio=='S' && $("#frecuenciaCap").val()=='Q' && numeroCliente==38){

                    $("#diaMesCapital").val(1);
                    var diaMesCapital = $('#diaMesCapital').val();
                    $('#diaDosQuincCap').val(Number(diaMesCapital) + 15);
                    deshabilitaControl('diaMesCapital');
                    deshabilitaControl('diaDosQuincCap');

                 }

                 // FIN GHERNANDEZ


            });

            $('#diaPagoCapitalQ').click(function(){
                igualaPagoCaptal();
            });

            $('#diaPagoCapitalD').click(function(){
                igualaPagoCaptal();
            });

            $('input[name="diaPagoInteres3"]').change(function (event){
                var diaPagoInteres3 = $('input[name="diaPagoInteres3"]:checked').val();
                // Si no es crecientes.
                if($('#tipoPagoCapital').val() != 'C'){
                    if(diaPagoInteres3 == 'D'){
                        habilitaControl('diaMesInteres');
                        $('#diaMesInteres').val('');
                        $('#diaDosQuincInt').show();
                    }
                    if(diaPagoInteres3 == 'Q'){
                        deshabilitaControl('diaMesInteres');
                        $('#diaMesInteres').val('15');
                        $('#diaDosQuincInt').hide();
                        $('#diaDosQuincInt').val('');
                    }
                } else {// Si es Crecientes.
                    if(diaPagoInteres3 == 'D'){
                        deshabilitaControl('diaMesInteres');
                        $('#diaMesInteres').val(($('#diaMesCapital').asNumber() == 15 ? '' : $('#diaMesCapital').val()));
                        $('#diaDosQuincInt').val($('#diaDosQuincCap').val());
                        $('#diaDosQuincInt').show();
                    }
                    if(diaPagoInteres3 == 'Q'){
                        deshabilitaControl('diaMesInteres');
                        $('#diaMesInteres').val('15');
                        $('#diaDosQuincInt').hide();
                        $('#diaDosQuincInt').val('');
                    }
                }
                $('#diaPagoInteres').val(diaPagoInteres3);
            });

            $('#diaPagoInteresQ').click(function(){
                $('input[name="diaPagoInteres3"]').change();
            });

            $('#diaPagoInteresD').click(function(){
                habilitaControl('diaMesInteres');
                $('#diaMesInteres').val('');
                $('#diaDosQuincInt').val('');
                $('#diaDosQuincInt').show();
            });

            $('#diaMesCapital').blur(function() {
                var tipoFrecuencia = $('#frecuenciaCap').val();
                var diaMesCapital = $('#diaMesCapital').val();
                if(tipoFrecuencia != 'Q'){
                    if(this.value != ""){
                        if(parseInt(this.value) <= 31){
                            if ($('#tipoPagoCapital').val() == 'C' || $('#perIgual').val() == 'S') {
                                $('#diaMesInteres').val($('#diaMesCapital').val());
                            }
                        }else{
                            mensajeSis("El Día de Mes Indicado es Incorrecto.");
                            this.focus();
                            this.select();
                        }
                    }
                } else { // Si la frecuencia es Quincenal, se le suman quince días.
                    if(Number(diaMesCapital) < 1 || Number(diaMesCapital) > 13){
                        mensajeSis('El Día de Pago debe ser Mayor a 0 y Menor o Igual a 13.')
                        $('#diaMesCapital').val('');
                        $('#diaDosQuincCap').val('');
                    } else {
                        $('#diaDosQuincCap').val(Number(diaMesCapital) + 15);
                        var tipoPagoCapital = $('#tipoPagoCapital').val();
                        if(tipoPagoCapital == 'C' || ( tipoPagoCapital == 'I' &&  $('#perIgual').val() == 'S')){
                            $('#diaMesInteres').val(diaMesCapital);
                            $('#diaDosQuincInt').val(Number(diaMesCapital) + 15);
                        }
                        // cuando Tipo de Pago de Capital:Libre, Capital;Frecuencia: Quincenal
                        if(tipoPagoCapital == 'L'){
                            $('#diaMesInteres').val(diaMesCapital);
                            $('#diaDosQuincInt').val(Number(diaMesCapital) + 15);
                        }
                    }
                }
            });

            $('#diaMesInteres').blur(function() {
                var tipoFrecuencia = $('#frecuenciaInt').val();
                var diaMesInteres = $('#diaMesInteres').val();
                if(tipoFrecuencia != 'Q'){
                    if(this.value != ""){
                        if(parseInt(this.value) > 31){
                            mensajeSis("El Día de Mes Indicado es Incorrecto.");
                            this.focus();
                            this.select();
                        }
                    }
                } else { // Si la frecuencia es Quincenal, se le suman quince días.
                    if(Number(diaMesInteres) < 1 || Number(diaMesInteres) > 13){
                        mensajeSis('El Día de Pago debe ser Mayor a 0 y Menor o Igual a 13.')
                        $('#diaMesInteres').val('');
                        $('#diaDosQuincInt').val('');
                    } else {
                        $('#diaDosQuincInt').val(Number(diaMesInteres) + 15);
                    }
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


            $('#calendIrregularCheck').click(function() {
                if ($('#calendIrregularCheck').is(':checked')) {
                    $('#calendIrregular').val("S");
                    $("#fechaInicioAmor").val($("#fechaInicio").val());
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
                    validarEsquemaCobroSeguro();
                } else {
                    $('#calendIrregular').val("N");
                    $('#frecuenciaInt').val('').selected = true;
                    $('#frecuenciaCap').val('').selected = true;
                    $("#montoSeguroCuota").val('');
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


            $('#tipoPagoCapital').change(function() {
                estatusSimulacion = false;
                validaTipoPago();
            });

            $('#tipoPagoCapital').blur(function() {
                validaTipoPago();
            });

            $('#frecuenciaCap').change(function() {
                var frecuenciaCapital = $('#frecuenciaCap').val();
                consultarFrecuencia(frecuenciaCapital);
                validarEventoFrecuencia();
                validaPeriodicidad();
                consultaFechaVencimiento('plazoID');
                setDiaPagoFrecuencia(this.id, diaPagoQuincenalCal);
                if(frecuenciaCapital != 'Q'){
                    $('#diaDosQuincInt').hide();
                    $('#diaDosQuincInt').val('');
                }
                verificaPagoCapInt ();
            });

            $('#frecuenciaCap').blur(function() {
                var frecuenciaCapital = $('#frecuenciaCap').val();
                consultarFrecuencia(frecuenciaCapital);
                validarEventoFrecuencia();
                validaPeriodicidad();
                consultaFechaVencimiento('plazoID');
                setDiaPagoFrecuencia(this.id, diaPagoQuincenalCal);

                var fecha = parametroBean.fechaAplicacion;
                validaDiasCobro();


                var fechaCalculada = sumaDiasFechaHabil(3,fecha, numeroDias, 0, 'S');

                $("#fechaCobroComision").val(fechaCalculada.fecha);

                if(frecuenciaCapital != 'Q'){
                    $('#diaDosQuincInt').hide();
                    $('#diaDosQuincInt').val('');
                }
                verificaPagoCapInt ();
            });

            $('#frecuenciaInt').change(function(event) {
                validarEventoFrecuencia();
                validaPeriodicidad();
                consultaCuotasInteres('plazoID');
                setDiaPagoFrecuencia(this.id, diaPagoQuincenalCal);
            });
            $('#frecuenciaInt').blur(function(event) {
                validarEventoFrecuencia();
                validaPeriodicidad();
                consultaCuotasInteres('plazoID');
            });

            $('#tipoConsultaSICBuro').click(function() {
                $('#tipoConsultaSICBuro').attr("checked",true);
                $('#tipoConsultaSICCirculo').attr("checked",false);
                $('#consultaBuro').show();
                $('#consultaCirculo').hide();
                $('#folioConsultaCC').val('');
                $('#folioConsultaBC').focus();
                $('#tipoConsultaSIC').val('BC');

            });

            $('#tipoConsultaSICCirculo').click(function() {
                $('#tipoConsultaSICBuro').attr("checked",false);
                $('#tipoConsultaSICCirculo').attr("checked",true);
                $('#consultaBuro').hide();
                $('#consultaCirculo').show();
                $('#folioConsultaBC').val('');
                $('#folioConsultaCC').focus();
                $('#tipoConsultaSIC').val('CC');

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
                                                        consultaFechaVencimientoCuotas('numAmortInteres');
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
                                    consultaFechaVencimientoCuotas('numAmortInteres');
                            }
                        }
                        else{
                            mensajeSis("Indique el Número de Cuotas.");
                            this.focus();
                        }
                }
            });


            $('#simular').click(function(event) {
                if ($('#tasaFija').asNumber() > 0){
                    if ($('#solicitudCreditoID').asNumber() > 0 && $('#tipoPagoCapital').val() == "L") {
                        if ($('#numTransacSim').asNumber() > 0) {
                            consultaSimulador();
                        } else {
                            simulador();
                        }
                    } else {
                        if(($('#frecuenciaCap').val().trim() == frecuenciaQuincenal
                            && $('#diaMesCapital').asNumber() == 0) ||
                            ($('#frecuenciaInt').val().trim() == frecuenciaQuincenal
                            && $('#diaMesInteres').asNumber() == 0)){
                            if(manejaConvenio=="N"){
                                mensajeSis('Indicar el Día de Pago para poder Simular.');
                            }

                        } else {
                            simulador();
                        }
                    }

                }else {
                    mensajeSis('Especificar '+VarTasaFijaoBase);
                    $('#tasaFija').select();
                }
            });
            // ------ FIN EVENTOS PARA SECCION DE CALENDARIO DE PAGOS

            $('#solicitudCreditoID').blur(function() {
                if($('#solicitudCreditoID').val() != null && $('#solicitudCreditoID').val() != ''
                    && $('#solicitudCreditoID').val() != '' && esTab){
                consultaCambiaPromotor();
            }

            });


            $('#tipoPagoSelect').hide();
            $('#tipoPagoSelect2').hide();


            $('#tipPago').change(function() {
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

                consultaPorcentajeGarantiaLiquida('montoSolici');
                if(cobraGarantiaFinanciada == 'S'){
                    consultaPorcentajeFOGAFI('montoSolici');
                }


            });



            $('#tipPago').blur(function() {
                calculaNodeDias($('#fechaVencimiento').val());
                consultaPorcentajeGarantiaLiquida('montoSolici');

                if(cobraGarantiaFinanciada == 'S'){
                    consultaPorcentajeFOGAFI('montoSolici');
                }


            });


            $('#montoSolici').keyup(function(e) {
                if(validarTeclas(e)){
                    montoSolicitudBase = $('#montoSolici').asNumber();
                }
            });


             function validarTeclas(tecla){
                 var aceptado = false;
                    if((tecla.keyCode >= 48 && tecla.keyCode <= 57) ||  // teclas numercias
                        (tecla.keyCode >= 96 && tecla.keyCode <= 105) || // panel teclado numerico
                        (tecla.keyCode == 190) || (tecla.keyCode == 110) || (tecla.keyCode == 8)){ // punto, retroceso
                        aceptado = true;
                    }
                    return aceptado;
             }


             $('#fechaInicio').blur(function(e) {
                 consultaPorcentajeGarantiaLiquida('productoCreditoID');
                 if(cobraGarantiaFinanciada == 'S'){
                    consultaPorcentajeFOGAFI('productoCreditoID');
                }

                 if(esAutomatico== 'S'){
                    calculoTasasAutomaticos();
                }
             });

             $('#tasaNivel').change(function(e) {
                 $("#tasaFija").val($('#tasaNivel').val());
             });

            //Lista de Cuentas Clabes del Cliente para Domiciliación
             $('#clabeDomiciliacion').bind('keyup',function(){
                    var camposLista = new Array();
                    var parametrosLista = new Array();
                    camposLista[0]='clienteID';
                    camposLista[1]='tipoCuenta';
                    parametrosLista[0]=$('#clienteID').val();
                    parametrosLista[1]='E';
                 lista('clabeDomiciliacion', '2', '8', camposLista,parametrosLista,'cuentasDestinoLista.htm');
             });


            //Consulta de Cuentas Clabes de Domiciliación
             $('#clabeDomiciliacion').blur(function(){
                 validaCuentaDomiciliado(this.id);
             });


            $('#cobertura').formatCurrency({
                positiveFormat : '%n',
                roundToDecimalPlace : 2
            });
            $('#prima').formatCurrency({
                positiveFormat : '%n',
                roundToDecimalPlace : 2
            });



    // --------------------------------- Validaciones de la Forma -------------------------------------
            $('#formaGenerica').validate(
                    {
                        rules : {
                            productoCreditoID : 'required',
                            promotorID : 'required',
                            tipoPagoCapital : 'required',
                            frecuenciaCap : {
                                required : function() {
                                    return $('#frecuenciaCap').val() == '0';
                                }
                            },
                            plazoID : 'required',
                            cuentaCLABE : {
                                required : function() {
                                    return $('#tipoDispersion').val() == 'S';
                                },
                                number : true,
                                maxlength : 18
                            },
                            tipoDispersion : 'required',
                            numAmortizacion : 'required',
                            montoSolici : 'required',
                            proyecto : 'required',
                            destinoCreID : 'required',
                            calcInteresID : 'required',
                            tipoIntegrante : {
                                required : function() {
                                    return $('#grupo').val() != undefined;
                                }
                            },
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
                            tasaFija : {
                                required : function() {
                                    return $('#tasaFija').asNumber() <= 0;
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
                            montoMaximo: {
                                required: function() { return esAutomatico == 'S'; }
                            },
                            inversionID: {
                                required: function() { return esAutomatico == 'S' && tipoAutomatico == "I"; }
                            },
                            cuentaAhoID: {
                                required: function() {  return esAutomatico == 'S' && tipoAutomatico == "A"; }
                            },
                            cobertura:{
                                number: true
                            },
                            prima:{
                                number: true
                            },
                            vigencia:{
                                number: true
                            },
                            convenioNominaID : {
                                required : function() {
                                    return $('#institucionNominaID').val() != '0' && $('#institucionNominaID').val() != '' && $('#institucionNominaID').val() != null
                                    && manejaConvenio == 'S';
                                }
                            },
                            clabeDomiciliacion :{
                                required : function() {
                                    return $('#clabeDomiciliacion').val() == "" && domiciPagos == 'S' && manejaConvenio == 'S';
                                }

                            },
                            ctaSantander :{
                            	required : function(){
                            		return $('#ctaSantander').is(':visible');
                            	}
                            },
                            ctaClabeDisp : {
                            	required : function(){
                            		return $('#ctaClabeDisp').is(':visible');
                            	}
                            }

                        },

                        messages : {
                            productoCreditoID : 'Especifique Producto',
                            promotorID : 'Especifique un Promotor.',
                            tipoPagoCapital : 'Especifique Tipo Pago de Capital',
                            frecuenciaCap : 'Especifique Frecuencia',
                            plazoID : 'Especifique Plazos',
                            cuentaCLABE : {
                                required : 'Especificar cuenta CLABE.',
                                number : 'Soló Números.',
                                maxlength : 'Máximo 18 Números.'
                            },
                            tipoDispersion : 'Especifique Dispersión',
                            numAmortizacion : 'Especificar No de Cuotas',
                            montoSolici : 'Especificar Monto',
                            proyecto : 'Especificar Proyecto',
                            destinoCreID : 'Especifique Destino de Crédito.',
                            calcInteresID : 'Especifique Cálculo de Interés.',
                            tipoIntegrante : 'Especifique Cargo Integrante',
                            beneficiario : 'Especificar Nombre Completo',
                            direccionBen : 'Especificar Dirección',
                            parentescoID : 'Especificar Tipo de Parentesco',
                            // tasaFija :'Especifique la Tasa'
                            tasaFija : {
                                required : 'Especifique la Tasa'
                            },
                            fechaInicioAmor : {
                                date : 'Fecha Incorrecta'
                            },
                            tipPago :{
                                required: 'Especificar Tipo de Pago'

                            },
                            tasaBase :{
                                required: 'Especificar la Tasa Base.'

                            },
                            sobreTasa :{
                                required: 'Especificar la Sobre Tasa.'

                            },
                            montoMaximo : {
                                required : 'Especificar Monto Máximo.'
                            },
                            inversionID : {
                                required : 'Especifique Inversión.'
                            },
                            cuentaAhoID : {
                                required : 'Especifique Cuenta.'
                            },
                            cobertura:{
                                number:'Sólo Números.'
                            },
                            prima:{
                                number:'Sólo Números.'
                            },
                            vigencia:{
                                number:'Sólo Números.'
                            },
                            convenioNominaID:{
                                required : 'Especifique el convenio.'
                            },
                            clabeDomiciliacion:{
                            	required : 'Especifique Clabe Domiciliación'
                            },
                            ctaSantander :{
                            	required : 'Especifique Cuenta Santander'
                            },
                            ctaClabeDisp : {
                            	required : 'Especifique cuenta Clabe'
                            },
                            clabeDomiciliacion:{
                            	required : 'El campo es requerido'
                            }
                        }
                    });


            // funcion para calcular o recalcular,Com. Apertura, Seguro de Vida, tasa de interes y Garantia Liquida y otras validaciones
            function validaMontoSolicitudCredito() {
                // Si el monto de la solicitud de credito esta dentro de los montos permitidos por el producto de credito
                if (validaLimiteMontoSolicitado() == 1) {

                    // La comision por apertura se calculando tomando el monto base(monto original) de la solicitud de credito
                    if(cobraComisionApertConvenio){
				        consultaComisionAperConvenio();
                    }else{
                        consultaComisionAper();
                    }
                    // La tasa de interes se calcula tomando el monto total de la solicitud de credito
                    consultaTasaCredito($('#montoSolici').asNumber(),'montoSolici');
                    // La garantia liquida se calcula tomando el monto total de la solicitud de credito
                    calculaMontoGarantiaLiquida($('#porcGarLiq').asNumber());
                    if(cobraGarantiaFinanciada == 'S'){
                        calculaMontoGarantiaFinanciada($('#porcentajeFOGAFI').asNumber());
                    }
                }
            }



            // ----------------- FUNCIONES PARA SECCION DE CALENDARIO DE PAGOS   ------------------------------ //
            //  funcion para cambiar los controles dependiendo de el tipo  de pago de capital  seleccionado
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
                            $('#frecuenciaCap').val('');
                            $('#frecuenciaInt').val('');
                            $('#frecuenciaCap').change();
                            $('#frecuenciaInt').change();
                            habilitarCalendarioPagosInteres();
                            igualarCalendarioInteresCapital();
                    break;
                }
            }

            /* FUNCION PARA IGUALAR CALENDARIO EN PAGOS CRECIENTES O QUE  PERMITEN IGUALDAD.*/
            function igualarCalendarioInteresCapital() {
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
                igualaPagoCaptal();
            }

            // funcion para eventos cuando se selecciona dia de pago de  interes  por aniversario o fin de mes, dependiendo de la frecuencia.
            function validarEventoFrecuencia() {
                switch ($('#tipoPagoCapital').val()) {
                // si el tipo de pago de capital es CRECIENTES
                case "C":
                    habilitaControl('numAmortizacion');
                    deshabilitaControl('periodicidadCap');
                    if($('#frecuenciaCap').val() == 'M' && $('#diaPagoCapital2').is(':checked') ){
                        habilitaControl('diaMesCapital');
                    }

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

                    if($('#frecuenciaCap').val() == 'M' && $('#diaPagoCapital2').is(':checked') ){
                        habilitaControl('diaMesCapital');
                    }

                    if ($('#frecuenciaCap').val() == 'S' || $('#frecuenciaCap').val() == 'C' || $('#frecuenciaCap').val() == 'Q'
                        || $('#frecuenciaCap').val() == 'A') {
                        if ($('#diaPagoCapital1').is(':checked')) {

                            $('#diaPagoCapital1').attr("checked", true);
                            $('#diaPagoCapital2').attr("checked", false);
                            $('#diaMesCapital').val('');
                        } else {
                                            $("#diaMesCapital").removeAttr("disabled");
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
                                                $("#diaMesCapital").removeAttr("disabled");
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
                                                            $("#diaMesCapital").removeAttr("disabled");
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
                                                            $("#diaMesCapital").removeAttr("disabled");
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
                            || $('#frecuenciaInt').val() == 'A') {

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

                    // si el tipo de pago de capital es LIBRES
                case "L":

                    habilitaControl('numAmortizacion');
                    deshabilitaControl('periodicidadCap');

                    if($('#frecuenciaCap').val() == 'M' && $('#diaPagoCapital2').is(':checked') ){
                        habilitaControl('diaMesCapital');
                    }

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
                            || $('#frecuenciaInt').val() == 'A') {

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
            case "D": // SI ES DECNAL
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


    // funcion para deshabilitar la seccion del calendario de  pagos que corresponde con interes
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

        if($("#frecuenciaInt").val() == frecuenciaQuincenal && $('#perIgual').val() != 'S'
            && $("#tipoPagoCapital").val() != 'C'){
            habilitaControl('diaPagoInteresD');
            habilitaControl('diaPagoInteresQ');
            if($('#diaPagoInteresD').is(':checked')){
                habilitaControl('diaMesInteres');
                $('#diaDosQuincInt').show();
            } else {
                deshabilitaControl('diaMesInteres');
                $('#diaMesInteres').val('15');
                $('#diaDosQuincInt').hide();
            }
        }

    }

            // valida que los datos que se requieren para generar el simulador de amortizaciones esten indicados.
            function validaDatosSimulador() {
                if ($.trim($('#productoCreditoID').val()) == "") {
                    mensajeSis("Producto De Crédito Vací­o");
                    $('#productoCreditoID').focus();
                    datosCompletos = false;
                } else {
                    if ($.trim($('#clienteID').asNumber()) <= "0" && $.trim($('#prospectoID').asNumber()) <= "0") {
                        mensajeSis("Especificar "+$('#alertSocio').val()+" o Prospecto.");
                        $('#prospectoID').focus();
                        datosCompletos = false;
                    } else {
                        if ($('#fechaInicioAmor').val() == '') {
                            mensajeSis("Fecha de Inicio Amotización Vacía");
                            $('#fechaInicioAmor').focus();
                            datosCompletos = false;
                        } else {
                            if ($('#fechaVencimiento').val() == '') {
                                mensajeSis("Fecha de Vencimiento Vacía");
                                $('#fechaVencimiento').focus();
                                datosCompletos = false;
                            } else {
                                if ($('#tipoPagoCapital').val() == '') {
                                    mensajeSis("El Tipo de Pago de Capital Está Vací­o.");
                                    $('#tipoPagoCapital').focus();
                                    datosCompletos = false;
                                } else {
                                    if ($('#frecuenciaCap').val() == 'U' && $('#tipoPagoCapital').val() != 'I') {
                                        mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
                                        $('#tipoPagoCapital').focus();
                                        datosCompletos = false;
                                    } else {
                                        /* se valida que si el tipo de pago de capital es libre, no se pueda escoger como frecuencia la opcion de libre */
                                        if ($('#frecuenciaInt').val() == "L" && $('#calendIrregular').val() == "N") {
                                            mensajeSis("La Frecuencia de Interés Libre sólo Aplica para Calendario Irregular.");
                                            $('#frecuenciaInt').focus();
                                            $('#frecuenciaInt').val("");
                                            datosCompletos = false;
                                        } else {
                                            if ($('#frecuenciaCap').val() == "L" && $('#calendIrregular').val() == "N") {
                                                mensajeSis("La Frecuencia de Capital Libre sólo Aplica para Calendario Irregular.");
                                                $('#frecuenciaCap').focus();
                                                $('#frecuenciaCap').val("");
                                                datosCompletos = false;
                                            } else {
                                                if(cobraAccesorios=='S' && manejaConvenio=='N' && validaAccesorios(tipoConAccesorio.plazo)==false ){
                                                    mensajeSis("No existen Accesorios parametrizados para el Producto de Credito");
                                                    setTimeout("$('#productoCreditoID').focus();",0);
                                                    datosCompletos = false;
                                                }else{
                                                    if ($('#calcInteresID').val() != "") {
                                                        if ($('#calcInteresID').val() == '1') {
                                                            if ($('#tasaFija').val() == '' || $('#tasaFija').val() == '0') {
                                                                mensajeSis("Tasa de Interés Vací­a.");
                                                                $('#tasaFija').focus();
                                                                datosCompletos = false;
                                                            } else {
                                                                if ($('#montoSolici').asNumber() <= "0") {
                                                                    mensajeSis("El Monto Está Vacío.");
                                                                    $('#montoSolici').focus();
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
                                                        mensajeSis("Seleccionar Tipo Cal. Interés.");
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
                }
                return datosCompletos;
            }



            // llamada al cotizador de amortizaciones
            function simulador() {
                var fechaIni = parametroBean.fechaAplicacion;
                $('#fechaInicio').val(fechaIni);

                if((Date.parse($('#fechaInicioAmor').val())) < (Date.parse(parametroBean.fechaAplicacion))){
                    $('#fechaInicioAmor').val(parametroBean.fechaAplicacion);
                }
                estatusSimulacion = true;

                var params = {};

                if ($('#calendIrregularCheck').is(':checked')) {

                    mostrarGridLibresEncabezado();
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
                } else {
                    ejecutarLlamada = validaDatosSimulador();
                    if (ejecutarLlamada == true) {
                        if ($('#calcInteresID').val() == 1) {
                            if ($('#tipoCalInteres').val() == '2') {
                                tipoLista = 11;
                                $('#tipoPagoCapital').val('I').selected = true;
                            } else {
                                switch ($('#tipoPagoCapital').val()) {
                                case "C": // si el tipo de pago es // CRECIENTES
                                    tipoLista = 1;
                                    break;
                                case "I":// si el tipo de pago es // IGUALES
                                    tipoLista = 2;
                                    break;
                                case "L": // si el tipo de pago es // LIBRES
                                    tipoLista = 3;
                                    break;
                                default:
                                    tipoLista = 1;
                                }
                            }
                        } else {
                            // si el tipo de calculo de interes es MontoOriginal (saldos globales)se valida tipo de Lista
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


                        params['tipoLista'] = tipoLista;

                        if ($.trim($('#frecuenciaCap').val()) != "") {
                            if (tipoLista == 1) {
                                // si se trata de una frecuencia de  capital : MENSUAL, BIMESTRAL,  TRIMESTRAL, TETRAMESTRAL, SEMESTRAL
                                if ($('#frecuenciaCap').val() == 'M'
                                    || $('#frecuenciaCap').val() == 'B'
                                        || $('#frecuenciaCap').val() == 'T'
                                            || $('#frecuenciaCap').val() == 'R'
                                                || $('#frecuenciaCap').val() == 'S') {

                                    // Si el dia de pago no esta  definido
                                    if (($('#diaPagoCapital2').is(':checked')) != true && ($('#diaPagoCapital1').is(':checked')) != true) {
                                        mensajeSis("Debe Seleccionar un día de Pago.");
                                        datosCompletos = false;
                                    } else {
                                        // si el dia de pago seleccionado es dia del mes
                                        if (($('#diaPagoCapital2').is(':checked')) == true) {


                                                consultacalendario('productoCreditoID','1');

                                                                        if($('#tipoPagoCapital').val().trim() == 'C' || $('#perIgual').val().trim() == 'S' ||   $('#tipoPagoCapital').val().trim() == 'I'){

                                                                                consultacalendario('productoCreditoID','2');
                                                                        }


                                            if ($.trim($('#diaMesCapital').val()) == '' || $('#diaMesCapital').val() == null || $('#diaMesCapital').val() == '0') {
                                                mensajeSis("Especifique día del Mes.");
                                                $('#diaMesCapital').focus();
                                                datosCompletos = false;
                                            } else {
                                                // valida que el numero  de amortizaciones no  este vacio
                                                if ($('#numAmortizacion').asNumber() == 0) {
                                                    mensajeSis("Número de cuotas vacío");
                                                    $('#numAmortizacion').focus();
                                                    datosCompletos = false;
                                                } else {
                                                    datosCompletos = true;
                                                }
                                            }
                                        } else {
                                            // valida que el numero de amortizaciones no este vacio
                                            if ($('#numAmortizacion').asNumber() == 0) {
                                                mensajeSis("Número de Cuotas Vacío.");
                                                $('#numAmortizacion').focus();
                                                datosCompletos = false;
                                            } else {
                                                datosCompletos = true;
                                            }
                                        }
                                    }
                                } else {
                                    if ($('#numAmortizacion').asNumber() == 0) {
                                        mensajeSis("Número de Cuotas Vacío.");
                                        $('#numAmortizacion').focus();
                                        datosCompletos = false;
                                    } else {
                                        datosCompletos = true;
                                    }
                                }
                            } else {
                                if (tipoLista == 2 || tipoLista == 3 || tipoLista == 4
                                        || tipoLista == 5 || tipoLista == 11) {
                                    if ($.trim($('#frecuenciaCap').val()) != "") {
                                        if ($.trim($('#frecuenciaInt').val()) != "") {
                                            if ($('#frecuenciaCap').val() == 'M'
                                                        || $('#frecuenciaCap').val() == 'B'
                                                            || $('#frecuenciaCap').val() == 'T'
                                                                || $('#frecuenciaCap').val() == 'R'
                                                                    || $('#frecuenciaCap').val() == 'S'
                                                                        || $('#frecuenciaInt').val() == 'M'
                                                                            || $('#frecuenciaInt').val() == 'B'
                                                                                || $('#frecuenciaInt').val() == 'T'
                                                                                    || $('#frecuenciaInt').val() == 'R'
                                                                                        || $('#frecuenciaInt').val() == 'S'
                                                                                            || $('#frecuenciaInt').val() == 'D') {
                                                // Valida que este seleccionado el dia de pago para capital e interes
                                                if (($('#diaPagoCapital1').is(':checked') != true && $('#diaPagoCapital2').is(':checked') != true)
                                                || ($('#diaPagoInteres1').is(':checked') != true && $('#diaPagoInteres2').is(':checked') != true)) {
                                                    mensajeSis('Debe Seleccionar un día de Pago.');
                                                    datosCompletos = false;
                                                } else {
                                                    // si el dia de pago seleccionado es dia del mes
                                                    if ($('#diaPagoCapital2').is(':checked') == true) {
                                                        consultacalendario('productoCreditoID','1');
                                                        if($('#tipoPagoCapital').val().trim() == 'C' || $('#perIgual').val().trim() == 'S'
                                                            ||  $('#tipoPagoCapital').val().trim() == 'I')
                                                        {

                                                                consultacalendario('productoCreditoID','2');
                                                        }

                                                        if ($.trim($('#diaMesCapital').val()) == '' || $('#diaMesCapital').val() == null
                                                                || $('#diaMesCapital').val() == '0') {
                                                            mensajeSis("Especifique día del Mes Capital.");
                                                            datosCompletos = false;
                                                        } else {

                                                            if($('#tipoPagoCapital').val().trim() == 'C' || $('#perIgual').val().trim() == 'S' ||   $('#tipoPagoCapital').val().trim() == 'I'){
                                                                                                consultacalendario('productoCreditoID','2');
                                                                                                }

                                                            if (($.trim($('#diaMesInteres').val()) == '' || $('#diaMesInteres').val() == null || $('#diaMesInteres').val() == '0')
                                                                        && $('#diaPagoInteres2').is(':checked') == true) {
                                                                mensajeSis("Especifique día del Mes Interés.");
                                                                datosCompletos = false;
                                                            } else {
                                                                // valida que el numero de amortizaciones no este vacio
                                                                if ($('#numAmortizacion').asNumber() == 0) {
                                                                    mensajeSis("Número de Cuotas Vacío.");
                                                                    datosCompletos = false;
                                                                } else {
                                                                    datosCompletos = true;
                                                                }
                                                            }
                                                        }
                                                    } else {
                                                        // valida que el numero de amortizaciones no este vacio
                                                        if ($('#numAmortizacion').asNumber() == 0) {
                                                            mensajeSis("Número de Cuotas Vacío.");
                                                            datosCompletos = false;
                                                        } else {
                                                            // valida que el  nÃºmero de amortizaciones no este vacio
                                                            if ($('#numAmortInteres').asNumber() == 0) {
                                                                mensajeSis("Especificar Número de Cuotas de Interés.");
                                                                $('#numAmortInteres').focus();
                                                                datosCompletos = false;
                                                            } else {
                                                                datosCompletos = true;
                                                            }
                                                        }
                                                    }
                                                }
                                            } else {
                                                // valida que el numero de amortizaciones no este vacio
                                                if ($('#numAmortizacion').asNumber() == 0) {
                                                    mensajeSis("Número de Cuotas Vacío.");
                                                    datosCompletos = false;
                                                } else {
                                                    // valida que el numero de amortizaciones no este vacio
                                                    if ($('#numAmortInteres').asNumber() == 0) {
                                                        mensajeSis("Especificar Número de Cuotas de Interés.");
                                                        $('#numAmortInteres').focus();
                                                        datosCompletos = false;
                                                    } else {
                                                        datosCompletos = true;
                                                    }
                                                }
                                            }
                                        } else {
                                            mensajeSis("Seleccionar Frecuencia de Interés.");
                                            $('#frecuenciaInt').focus();
                                            datosCompletos = false;
                                        }
                                    } else {
                                        mensajeSis("Seleccionar Frecuencia de Capital.");
                                        $('#frecuenciaCap').focus();
                                        datosCompletos = false;
                                    }
                                }
                            }

                    if (datosCompletos) {
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

                                params['montoCredito']      = $('#montoSolici').asNumber();

                                if($('#calcInteresID').val() == '1'){

                                    params['tasaFija']          = $('#tasaFija').val();
                                }else{
                                    params['tasaFija']          = parseFloat(valorTasaBase) + $('#sobreTasa').asNumber();
                                }
                                params['frecuenciaCap']     = $('#frecuenciaCap').val();
                                params['frecuenciaInt']     = $('#frecuenciaInt').val();
                                params['periodicidadCap']   = $('#periodicidadCap').val();
                                params['periodicidadInt']   = $('#periodicidadInt').val();
                                params['producCreditoID']   = $('#productoCreditoID').val();
                                params['clienteID']         = $('#clienteID').val();
                                params['montoComision']     = $('#montoComApert').asNumber();
                                params['diaPagoCapital']    = auxDiaPagoCapital;
                                params['diaPagoInteres']    = auxDiaPagoInteres;
                                params['diaMesCapital']     = $('#diaMesCapital').val();
                                params['diaMesInteres']     = $('#diaMesInteres').val();
                                params['fechaInicio']       = $('#fechaInicioAmor').val();
                                params['numAmortizacion']   = $('#numAmortizacion').asNumber();
                                params['numAmortInteres']   = $('#numAmortInteres').asNumber();
                                params['fechaInhabil']      = $('#fechInhabil').val();
                                params['ajusFecUlVenAmo']   = $('#ajFecUlAmoVen').val();
                                params['ajusFecExiVen']     = $('#ajusFecExiVen').val();
                                params['montoGarLiq']       = $('#aporteCliente').asNumber();
                                params['numTransacSim']     = '0';
                                params['empresaID']         = parametroBean.empresaID;
                                params['usuario']           = parametroBean.numeroUsuario;
                                params['fecha']             = parametroBean.fechaSucursal;
                                params['direccionIP']       = parametroBean.IPsesion;
                                params['sucursal']          = $("#sucursalID").val();
                                params['cobraSeguroCuota']  = $('#cobraSeguroCuota option:selected').val();
                                params['cobraIVASeguroCuota']   = $('#cobraIVASeguroCuota option:selected').val();
                                params['montoSeguroCuota']  = $('#montoSeguroCuota').asNumber();
                                params['tipoCredito']       = $('#tipoCredito').val();
                                params['plazoID']           = $('#plazoID').val();
                                params['tipoOpera']         = 1;
                                params['cobraAccesorios']   = cobraAccesorios;
                                params['convenioNominaID']  = $('#convenioNominaID').asNumber();


                                bloquearPantallaAmortizacion();
                                var numeroError = 0;
                                var mensajeTransaccion = "";
                                if ($('#tipoPagoCapital').val() != "L") {
                                    $.post("simPagCredito.htm", params, function(data) {

                                        if (data.length > 0 || data != null) {
                                            $('#contenedorSimulador').html(data);
                                            if ($("#numeroErrorList").length) {
                                                numeroError = $('#numeroErrorList').asNumber();
                                                mensajeTransaccion = $('#mensajeErrorList').val();
                                            }
                                                    if(numeroError==0){
                                                    $('#contenedorSimulador').show();
                                                    $('#contenedorSimuladorLibre').html("");
                                                    $('#contenedorSimuladorLibre').hide();
                                                    $('#numTransacSim').val($('#transaccion').val());

                                                    // actualiza la nueva fecha de vencimiento que devuelve el simulador
                                                    var jqFechaVen = eval("'#fech'");
                                                    $('#fechaVencimiento').val($(jqFechaVen).val());

                                                    // asigna el valor de car decuelto por el simulador
                                                    $('#CAT').val($('#valorCat').val());
                                                    $('#CAT').formatCurrency({
                                                        positiveFormat : '%n',
                                                        roundToDecimalPlace : 1
                                                    });

                                                    // asigna el valor de monto de la cuota deulto por el simulador
                                                    if ($(
                                                    '#tipoPagoCapital').val() == "C") {
                                                        $('#montoCuota').val($('#valorMontoCuota').val());
                                                        $('#montoCuota').formatCurrency({
                                                            positiveFormat : '%n',
                                                            roundToDecimalPlace : 2
                                                        });
                                                    } else {
                                                        if ($('#frecuenciaCap').val() == "U" && $('#tipoPagoCapital').val() == "I") {
                                                            $('#montoCuota').val($('#valorMontoCuota').val());
                                                            $('#montoCuota').formatCurrency({
                                                                positiveFormat : '%n',
                                                                roundToDecimalPlace : 2
                                                            });
                                                        } else {
                                                            $('#montoCuota').val("0.00");
                                                        }
                                                    }
                                                    // actualiza el numero de cuotas generadas por el simulador
                                                    $('#numAmortInteres').val($('#valorCuotasInt').val());
                                                    $('#numAmortizacion').val($('#cuotas').val());
                                                    // se utiliza para saber si agregar 1 cuotas mas o restar 1
                                                    NumCuotas = $('#cuotas').val();

                                                    // Si el tipo de pago de capital es iguales o saldos gloables devuelve el numero de cuotas de interes
                                                    if ($('#tipoPagoCapital').val() == 'I' || tipoLista == 11) {
                                                        $('#numAmortInteres').val($('#valorCuotasInt').val());
                                                        // se utiliza para saber si agregar 1 cuotas mas o restar 1
                                                        NumCuotasInt = $('#valorCuotasInt').val();
                                                    }

                                                    if ($('#siguiente').is(':visible') && $('#anterior').is(':visible')==false){
                                                        $('#filaTotales').hide();
                                                    }

                                                    if ($('#siguiente').is(':visible')==false && $('#anterior').is(':visible')==false){
                                                        $('#filaTotales').show();
                                                    }
                                                    $('#ExportExcel').show();

                                                    if (manejaCalendario = 'S') {
                                                    	$('#fechaInicioAmor').val($('#fechaInicio1').val());
                                                    }
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
                                                } else {
                                                    $('#contenedorSimulador').html("");
                                                    $('#contenedorSimulador').hide();
                                                    $('#contenedorSimuladorLibre').html("");
                                                    $('#contenedorSimuladorLibre').hide();
                                                }
                                                $('#contenedorForma').unblock();

                                                /****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
                                                if(numeroError!=0){
                                                    $('#contenedorForma').unblock({fadeOut: 0,timeout:0});
                                                    mensajeSisError(numeroError,mensajeTransaccion);
                                                }
                                                /**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
                                        });
                                    habilitarBotonesSol();
                                } else {

                                    var numeroError = 0;
                                    var mensajeTransaccion = "";
                                    $.post("simPagLibresCapCredito.htm", params, function(data) { // todo

                                        if (data.length > 0 || data != null) {
                                            $('#contenedorSimuladorLibre').html(data);
                                            if ($("#numeroErrorList").length) {
                                                numeroError = $('#numeroErrorList').asNumber();
                                                mensajeTransaccion = $('#mensajeErrorList').val();
                                            }
                                                    if(numeroError==0){
                                                        $('#contenedorSimuladorLibre').show();
                                                        $('#contenedorSimulador').html("");
                                                        $('#contenedorSimulador').hide();
                                                        $('#numTransacSim').val($('#transaccion').val());
                                                        // actualiza la nueva fecha de vencimiento que devuelve el simulador
                                                        var jqFechaVen = eval("'#fech'");
                                                        $('#fechaVencimiento').val($(jqFechaVen).val());

                                                        // asigna el monto de la cuota devuelta por el simulador
                                                        $('#montoCuota').val($('#valorMontoCuota').val());
                                                        // actualiza el numero de cutoas de interes generadas por el simulador
                                                        $('#numAmortInteres').val($('#valorCuotasInt').val());
                                                        $('#numAmortizacion').val($('#cuotas').val());
                                                        calculaDiferenciaSimuladorLibre();
                                                        calculoTotalCapital();
                                                        calculoTotalInteres();
                                                        calculoTotalIva();
                                                        //calculoTotalSeguros();
                                                        $('#ExportExcel').show();
                                                        if ($('#tipoCalInteres').val() == '2' && cobraAccesorios == 'S') {
                                                            desgloseOtrasComisiones($('#numTransacSim').val());
                                                        }
                                                    }
                                                } else {
                                                    $('#contenedorSimuladorLibre').html("");
                                                    $('#contenedorSimuladorLibre').hide();
                                                    $('#contenedorSimulador').html("");
                                                    $('#contenedorSimulador').hide();
                                                }

                                                $('#contenedorForma').unblock();
                                                /****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
                                                if(numeroError!=0){
                                                    $('#contenedorForma').unblock({fadeOut: 0,timeout:0});
                                                    mensajeSisError(numeroError,mensajeTransaccion);
                                                }
                                                /**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
                                                deshabilitaBoton('modificar','submit');
                                                deshabilitaBoton('liberar','submit');
                                                deshabilitaBoton('agregar','submit');
                                                $('#liberar').hide();
                                            });
                                }


                            }
                        } else {
                            mensajeSis("Seleccionar Frecuencia de Capital.");
                            $('#frecuenciaCap').focus();
                            datosCompletos = false;
                        }
                    }
                }
            }// fin funcion simulador()

            function consultacalendario(idControl,consecutivo) {
                var jqproducto = eval("'#" + idControl + "'")
                var producto = $(jqproducto).val();
                var tipodiapago = consecutivo;
                var TipoConPrin = 1;
                var calendarioBeanCon = {
                        'productoCreditoID' : producto
                };
                setTimeout("$('#cajaLista').hide();", 200);
                if (producto != '' && !isNaN(producto) && esTab) {
                    calendarioProdServicio.consulta(TipoConPrin,calendarioBeanCon,{ async: false, callback:function(calendario) {
                            if (calendario.diaPagoCapital == 'A' && tipodiapago == '1') {
                                        $('#diaMesCapital').val(diaSucursal);

                            }
                            if (calendario.diaPagoCapital == 'A' && tipodiapago == '2'){
                                $('#diaMesInteres').val(diaSucursal);
                            }
                    }});
                }
            }


            // llamada al sp que consulta el simulador de amortizaciones
            function consultaSimulador() {

                var fechaIni = $('#fechaInicioAmor').val();
                $('#fechaInicio').val(fechaIni);

                if((Date.parse($('#fechaInicioAmor').val())) < (Date.parse(parametroBean.fechaAplicacion))){
                    $('#fechaInicioAmor').val(parametroBean.fechaAplicacion);
                    var fechaIni = $('#fechaInicioAmor').val();
                    $('#fechaInicio').val(fechaIni);
                }
                estatusSimulacion = true;
                var params = {};
                if ($('#calendIrregularCheck').is(':checked')) {
                    // calendario irregular
                    tipoLista = 7;
                } else {
                    if ($('#calcInteresID').val() == 1) {
                        switch ($('#tipoPagoCapital').val()) {
                        case "C": // si el tipo de pago es CRECIENTES
                            tipoLista = 1;
                            break;
                        case "I":// si el tipo de pago es IGUALES
                            tipoLista = 2;
                            break;
                        case "L": // si el tipo de pago es LIBRES
                            tipoLista = 3;
                            break;
                        default:
                            tipoLista = 1;
                        }
                    } else {
                        // si el tipo de calculo de interes es MontoOriginal (saldos globales)se valida tipo de Lista
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

                params['tipoLista'] = tipoLista;

                params['numTransacSim'] = $('#numTransacSim').asNumber();
                params['cobraSeguroCuota']  = $('#cobraSeguroCuota option:selected').val();
                params['cobraIVASeguroCuota']   = $('#cobraIVASeguroCuota option:selected').val();
                params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();

                bloquearPantallaAmortizacion();
                var numeroError = 0;
                var mensajeTransaccion = "";
                $.post("listaSimuladorConsulta.htm", params, function(data) {
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
                                    $('#fechaVencimiento').val(jqFechaFin);
                                }

                                });
                        }
                    } else {
                        $('#contenedorSimuladorLibre').html("");
                        $('#contenedorSimuladorLibre').hide();
                        $('#contenedorSimulador').html("");
                        $('#contenedorSimulador').hide();
                    }
                    $('#contenedorForma').unblock();
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

            // -------------------- FUNCIONES PARA SECCION DE CALENDARIO DE PAGOS ----------------------------------

            // consulta el tipo de integrante de la solicitud de credito
            function consultaTipoIntegrante() {
                var solicitud = $('#solicitudCreditoID').val();
                var grupoInteGruBeanCon = {
                        'solicitudCreditoID' : solicitud
                };
                var listaIntegrante = 3;
                setTimeout("$('#cajaLista').hide();", 200);
                if (solicitud != '' && !isNaN(solicitud) && esTab) {
                    integraGruposServicio.consulta(listaIntegrante,
                            grupoInteGruBeanCon, function(integrantes) {
                        if (integrantes != null) {
                            $('#tipoIntegrante').val(
                                    integrantes.cargo);
                        }
                    });
                }
            }

            // funcion consulta de grupos
            function consultaGrupo(idControl) {
                var jqGrupo = eval("'#" + idControl + "'");
                var grupo = $(jqGrupo).val();
                var grupoBeanCon = {
                        'grupoID' : grupo
                };
                setTimeout("$('#cajaLista').hide();", 200);
                if (grupo != '' && !isNaN(grupo) && esTab) {
                    gruposCreditoServicio.consulta(catTipoConsultaSolicitud.principal,grupoBeanCon,function(grupos) {
                            if (grupos != null) {
                                esTab = true;
                                $('#nombreGr').val(grupos.nombreGrupo);
                                //aqui se  obtiene  el grupo  de  consulta  para individual
                                sgrupo = grupo;
                                gruposCreditoServicio.consulta(8, grupoBeanCon, function( gruposint) {
                                    if (gruposint != null) {
                                        nintegrantes = Number(gruposint.tInt);
                                        nhombres = Number(gruposint.tH);
                                        nmujeres = Number(gruposint.tM);
                                        nmujeress = Number(gruposint.tMS);
                                    }
                                });
                                if ($('#grupo').val() == undefined && productoIDBase > 0
                                        && (clienteIDBase > 0 || prospectoIDBase > 0)) {
                                    consultacicloCliente();
                                }
                            } else {
                                if ($('#grupoID').val() != 0 && $('#grupoID') .val() != '') {
                                    mensajeSis("El Grupo no Existe");
                                    $('#nombreGr').val("");
                                    $('#tipoIntegrante').val("");
                                    $(jqGrupo).focus();
                                    grupoIDBase = 0;
                                }
                            }
                    });
                }
            }

            // ----------------------consulta la tasa base --------------------
            function consultaTasaBase(idControl, desdeInput) {
                var jqTasa = eval("'#" + idControl + "'");
                var tasaBase = $(jqTasa).asNumber();
                var TasaBaseBeanCon = {
                        'tasaBaseID' : tasaBase
                };
                setTimeout("$('#cajaLista').hide();", 200);

                if (tasaBase > 0 && esTab) {
                    tasasBaseServicio.consulta(1, TasaBaseBeanCon,{
                        async:false,
                        callback: function(tasasBaseBean) {
                            if (tasasBaseBean != null) {
                                hayTasaBase = true;
                                $('#desTasaBase').val(tasasBaseBean.nombre);
                                valorTasaBase = tasasBaseBean.valor;
                                if(desdeInput){
                                    $('#tasaFija').val($('#sobreTasa').asNumber() + Number(valorTasaBase)).change();
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
                        }
                    });

                    $("#tdTasaFija").show();
                    $('#tdTasaNivel').hide();

                }

            }

            // funcion para consultar una solicitud de credito
            function validaSolicitudCredito(idControl) {
                var jqSolicitud = eval("'#" + idControl + "'");
                var solCred = $(jqSolicitud).val();
                setTimeout("$('#cajaLista').hide();", 200);
                if (solCred != '' && !isNaN(solCred) && esTab) {
                    inicializaValoresNuevaSolicitud();
                    if (solCred == '0') {
                        // se trata de una solicitud de credito nueva
                        habilitaInputsSolGrupal(); // Funcion que Deshabilita los inputs de la  solicitud Grupal > 0 para que no se queden deshabilitados
                        if ($('#grupo').val() != undefined) {
                            if ($('#solicitudCre1').asNumber() > 0) {
                                consultaValoresPrimeraSolicitudGrupal($('#solicitudCre1').asNumber());
                                deshabilitaInputsSolGrupal();// Deshabilita los inputs  de la Solicitud  grupal  si la  solicitud no es  la primera
                            }
                        }
                        //Asigna valor defeult consulta SIC
                        consultaSICParam();
                    } else {
                        var SolCredBeanCon = {
                                'solicitudCreditoID' : solCred,
                                'usuario' : usuario
                        };
                        mostrarElementoPorClase('ocultarSeguroCuota',"N");
                        solicitudCredServicio.consulta(catTipoConsultaSolicitud.principal,SolCredBeanCon,{ async: false, callback:function(solicitud) {
                                    if (solicitud != null && solicitud.solicitudCreditoID != 0) {
                                    	if(solicitud.prospectoID != null && solicitud.prospectoID != 0){
	                                    	listaPersBloqBean = consultaListaPersBloq(solicitud.prospectoID, esProspecto, 0, 0);
	            							consultaSPL = consultaPermiteOperaSPL(solicitud.prospectoID,'LPB',esProspecto);
                                    	}else{
                                    		listaPersBloqBean = consultaListaPersBloq(solicitud.clienteID, esCliente, 0, 0);
	            							consultaSPL = consultaPermiteOperaSPL(solicitud.clienteID,'LPB',esCliente);
                                    	}

            							if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
	                                        consultaModificaSuc(false);
	                                    	estatusSolicitudCredito = solicitud.estatus;
	                                        solicitudPromotor = solicitud.promotorID;
	                                        $('#montoSeguroVida').val(solicitud.montoSeguroVida);
	                                        mostrarElementoPorClase('ocultarSeguroCuota',solicitud.cobraSeguroCuota);

	                                          if(solicitud.forCobroSegVida != ''){
	                                              consultaTiposPago(solicitud.productoCreditoID,esquemaSeguro,solicitud.forCobroSegVida);
	                                            }
                                            if (solicitud.flujoOrigen == 'C') {
                                                mensajeSis("La solicitud " + solCred + " es una Consolidaci&oacuten.<br>Favor de consultarla en el " + "<b><a onclick=\"$('#Contenedor').load('flujoIndividualConsolidacion.htm',function(response, status, xhr){" + "if(status == 'error') {$('#Contenedor').html(response);}});consultaSesion();\">Flujo Individual de Consolidación de Crédito. <img src=\"images/external.png\"></a></b>");
                                                $('#solicitudCreditoID').val("");
                                                $('#solicitudCreditoID').focus();
                                            } else if (solicitud.esReacreditado == 'S') {
                                                mensajeSis("La solicitud " + solCred + " es un Reacreditamiento.<br>Favor de consultarla en el " + "<b><a onclick=\"$('#Contenedor').load('flujoIndividualReacreditamientoVista.htm',function(response, status, xhr){" + "if(status == 'error') {$('#Contenedor').html(response);}});consultaSesion();\">Flujo Individual de Reacreditación. <img src=\"images/external.png\"></a></b>");
                                                $('#solicitudCreditoID').val("");
                                                $('#solicitudCreditoID').focus();
                                            } else if (solicitud.tipoCredito == 'R') {
                                                mensajeSis("La solicitud " + solCred + " es una Restructura.<br>Favor de consultarla en el " + "<b><a onclick=\"$('#Contenedor').load('flujoIndividualReestructura.htm',function(response, status, xhr){" + "if(status == 'error') {$('#Contenedor').html(response);}});consultaSesion();\">Flujo Individual de Reestructura. <img src=\"images/external.png\"></a></b>");
                                                $('#solicitudCreditoID').val("");
                                                $('#solicitudCreditoID').focus();
                                            } else if (solicitud.tipoCredito == 'O') {
                                                mensajeSis("La solicitud " + solCred + " es una Renovación.<br>Favor de consultarla en el " + "<b><a onclick=\"$('#Contenedor').load('flujoIndividualRenovacionVista.htm',function(response, status, xhr){" + "if(status == 'error') {$('#Contenedor').html(response);}});consultaSesion();\">Flujo Individual de Renovación. <img src=\"images/external.png\"></a></b>");
                                                $('#solicitudCreditoID').val("");
                                                $('#solicitudCreditoID').focus();
                                            } else
	                                        if (solicitud.grupoID == 0 && $('#grupo').val() != undefined) {
	                                            mensajeSis("La solicitud " + solCred + ", no es una solicitud grupal \nfavor de consultar en solicitudes individuales.");

	                                            $('#solicitudCreditoID').val("");
	                                            $('#solicitudCreditoID').focus();
	                                        } else {
	                                            if ($('#grupo').val() != solicitud.grupoID && $('#grupo').val() != undefined) {
	                                                mensajeSis("La solicitud "+ solCred+ ", no pertenece \n al grupo: "+ $('#nombreGrupo').val());
	                                                $('#solicitudCreditoID').val("");
	                                                $('#solicitudCreditoID').focus();
	                                            } else {

	                                                esTab = true;
	                                                dwr.util.setValues(solicitud);
	                                                if (solicitud.folioSolici!="" && solicitud.folioSolici!=null) {
	                                                    $(".folioSolici").show();
	                                                    $("#folioSolici").val(solicitud.folioSolici);
	                                                }else{
	                                                    $(".folioSolici").hide();
	                                                    $("#folioSolici").val("");
	                                                }
	                                                if(manejaConvenio=='S'){

	                                                    consultaConvenioNomina(solicitud.convenioNominaID);
	                                                    setTimeout(function(){

	                                                        if (solicitud.quinquenioID!="" && solicitud.quinquenioID>0 && solicitud.quinquenioID!=null) {
	                                                            $(".quinquenios").show();
	                                                            $("#quinquenioID").val(solicitud.quinquenioID);
	                                                        }
	                                                        else{
	                                                            $(".quinquenios").hide();
	                                                            $("#quinquenioID").val("");
	                                                        }

	                                                    },400);


	                                                }
	                                                $("#fechaInicio").val(solicitud.fechaInicio);
	                                                $('#fechaInicioAmor').val(solicitud.fechaInicioAmor);
	                                                $('#clabeDomiciliacion').val(solicitud.clabeDomiciliacion);
	                                                consultaCambiaPromotor();
	                                                // se asignan valores Base
	                                                montoComApeBase = solicitud.montoComApert;
	                                                montoIvaComApeBase = solicitud.ivaComApert;
	                                                clienteIDBase = solicitud.clienteID;
	                                                productoIDBase = solicitud.productoCreditoID;
	                                                prospectoIDBase = solicitud.prospectoID;
	                                                grupoIDBase = solicitud.grupoID;
	                                                solicitudIDBase = solicitud.solicitudCreditoID;
	                                                plazoBase = solicitud.plazoID;
	                                                fechaVencimientoInicial = "";
	                                                requiereSeg = "";

	                                                tipoPagoSeg = solicitud.forCobroSegVida; //tipo de pago del monto de seguro de vida
	                                                prodCredito =   solicitud.productoCreditoID;

	                                                if (solicitud.forCobroComAper == 'F') {
	                                                    $('#formaComApertura').val(financiado); ///XXXX


	                                                } else {
	                                                    if (solicitud.forCobroComAper == 'D') {
	                                                        $('#formaComApertura').val(deduccion);
	                                                    } else {
	                                                        if (solicitud.forCobroComAper == 'A') {
	                                                            $('#formaComApertura').val(anticipado);
	                                                        }
	                                                        else{
	                                                            if (solicitud.forCobroComAper == 'P') {
	                                                                $('#formaComApertura').val(programado);
	                                                            }
	                                                        }
	                                                    }
	                                                }

	                                                // forma de pago del seguro de vida

	                                                if(modalidad == 'U'){ //
	                                                if (solicitud.forCobroSegVida == 'F') {
	                                                    $('#tipoPagoSeguro').val(financiado); //XXXXX

	                                                } else {
	                                                    if (solicitud.forCobroSegVida == 'D') {
	                                                        $('#tipoPagoSeguro').val(deduccion);
	                                                    } else {
	                                                        if (solicitud.forCobroSegVida == 'A') {
	                                                            $('#tipoPagoSeguro').val(anticipado);
	                                                        }
	                                                    }
	                                                }
	                                                }else{
	                                                    if(modalidad == 'T'){
	                                                        calculaNodeDias(solicitud.fechaVencimiento);
	                                                        if (solicitud.forCobroSegVida == 'F') {
	                                                            $('#tipPago').val('F');
	                                                        } else {
	                                                            if (solicitud.forCobroSegVida == 'D') {
	                                                                $('#tipPago').val('D');
	                                                            } else {
	                                                                if (solicitud.forCobroSegVida == 'A') {
	                                                                    $('#tipPago').val('A');
	                                                                }else{

	                                                                    if (solicitud.forCobroSegVida == 'O') {
	                                                                        $('#tipPago').val('O');
	                                                                    }
	                                                                }
	                                                            }
	                                                        }

	                                                    consultaEsquemaSeguroVidaForanea(solicitud.forCobroSegVida);
	                                                    }
	                                                }


	                                                if (solicitud.forCobroSegVida == 'A') {
	                                                    montoSolicitudBase = solicitud.montoSolici;
	                                                } else {
	                                                    if (solicitud.forCobroSegVida == 'D') {
	                                                        montoSolicitudBase = solicitud.montoSolici;
	                                                    } else {
	                                                        if (solicitud.forCobroSegVida == 'F') {
	                                                            montoSolicitudBase =solicitud.montoSolici - solicitud.montoSeguroVida;
	                                                        }else{

	                                                            montoSolicitudBase = solicitud.montoSolici;
	                                                        }
	                                                    }
	                                                }

	                                                if (solicitud.forCobroComAper == 'D') {
	                                                    montoSolicitudBase = montoSolicitudBase;
	                                                } else {
	                                                    if (solicitud.forCobroComAper == 'F') {
	                                                        montoSolicitudBase = montoSolicitudBase - solicitud.montoComApert - solicitud.ivaComApert;
	                                                    }else{
	                                                        montoSolicitudBase = montoSolicitudBase;
	                                                    }
	                                                }

	                                                montoComIvaSol = solicitud.montoSolici;
	                                                $('#fechaVencimiento').val(solicitud.fechaVencimiento);
	                                                fechaVencimientoInicial = solicitud.fechaVencimiento;
	                                                $('#productoCreditoID').val(solicitud.productoCreditoID);
	                                                $('#aporteCliente').val(solicitud.aporteCliente);
	                                                $('#aporteCliente').formatCurrency({
	                                                            positiveFormat : '%n',
	                                                            roundToDecimalPlace : 2
	                                                });

	                                                consultaMontoFOGAFI();
	                                                $('#grupoID').val(solicitud.grupoID);

	                                                setCalcInteresID(solicitud.calcInteresID,false);
	                                                $('#tipoCalInteres').val(solicitud.tipoCalInteres).selected = true;

	                                                if (solicitud.calendIrregular == 'S') {
	                                                    $('#calendIrregularCheck').attr("checked","true");
	                                                    $('#calendIrregular').val("S");
	                                                    deshabilitaControl('tipoPagoCapital');
	                                                    deshabilitaControl('frecuenciaInt');
	                                                    deshabilitaControl('frecuenciaCap');
	                                                    deshabilitaControl('numAmortizacion');
	                                                    deshabilitaControl('numAmortInteres');
	                                                } else {
	                                                    $('#calendIrregularCheck').attr("checked",false);
	                                                    $('#calendIrregular').val("N");
	                                                    habilitaControl('tipoPagoCapital');
	                                                    deshabilitaControl('frecuenciaInt');
	                                                    habilitaControl('frecuenciaCap');
	                                                    habilitaControl('numAmortizacion');
	                                                    if(solicitud.tipoPagoCapital == 'C' || $('#perIgual').val() == 'S' ) {
	                                                        deshabilitaControl('numAmortInteres');
	                                                    }else{
	                                                        habilitaControl('numAmortInteres');
	                                                    }
	                                                }


	                                                if (solicitud.fechInhabil == 'S') {
	                                                    $('#fechInhabil').val("S");
	                                                    $('#fechInhabil1').attr('checked',true);
	                                                    $('#fechInhabil2').attr("checked",false);
	                                                } else {
	                                                    $('#fechInhabil2').attr('checked',true);
	                                                    $('#fechInhabil1').attr("checked",false);
	                                                    $('#fechInhabil').val("A");
	                                                }

	                                                if (solicitud.ajusFecExiVen == 'S') {
	                                                    $('#ajusFecExiVen1').attr('checked',true);
	                                                    $('#ajusFecExiVen2').attr("checked",false);
	                                                    $('#ajusFecExiVen').val("S");
	                                                } else {
	                                                    $('#ajusFecExiVen1').attr("checked",false);
	                                                    $('#ajusFecExiVen2').attr('checked',true);
	                                                    $('#ajusFecExiVen').val("N");
	                                                }

	                                                if (solicitud.ajFecUlAmoVen == 'S') {
	                                                    $('#ajFecUlAmoVen1').attr('checked',true);
	                                                    $('#ajFecUlAmoVen2').attr("checked",false);
	                                                    $('#ajFecUlAmoVen').val("S");
	                                                } else {
	                                                    $('#ajFecUlAmoVen1').attr("checked",false);
	                                                    $('#ajFecUlAmoVen2').attr('checked',true);
	                                                    $('#ajFecUlAmoVen').val("N");
	                                                }

	                                                $('#diaMesCapital').val(solicitud.diaMesCapital);
	                                                $('#diaMesInteres').val(solicitud.diaMesInteres);

	                                                // Si no es Quincenal.
	                                                if(solicitud.frecuenciaCap != frecuenciaQuincenal){
	                                                    if (solicitud.diaPagoCapital == 'F') {
	                                                        $('#diaPagoCapital1').attr('checked',true);
	                                                        $('#diaPagoCapital2').attr('checked',false);
	                                                    } else {
	                                                        $('#diaPagoCapital2').attr('checked',true);
	                                                        $('#diaPagoCapital1').attr('checked',false);
	                                                    }
	                                                    $('#divDiaPagoCapMes').show();
	                                                    $('#divDiaPagoCapQuinc').hide();
	                                                } else {// Si es Quincenal.
	                                                    if (solicitud.diaPagoCapital == 'D') {
	                                                        $('#diaPagoCapitalD').attr('checked',true);
	                                                        $('#diaPagoCapitalQ').attr('checked',false);
	                                                        $('#diaDosQuincCap').val(Number(solicitud.diaMesCapital) + 15);
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
	                                                $('#diaPagoCapital').val(solicitud.diaPagoCapital);
	                                                $('#diaPagoProd').val(solicitud.diaPagoCapital);

	                                                //  Si no es Quincenal.
	                                                if(solicitud.frecuenciaInt != frecuenciaQuincenal){
	                                                    if (solicitud.diaPagoInteres == 'F') {
	                                                        $('#diaPagoInteres1').attr('checked',true);
	                                                        $('#diaPagoInteres2').attr('checked',false);
	                                                    } else {
	                                                        $('#diaPagoInteres1').attr('checked',false);
	                                                        $('#diaPagoInteres2').attr('checked',true);
	                                                    }
	                                                    $('#divDiaPagoIntMes').show();
	                                                    $('#divDiaPagoIntQuinc').hide();
	                                                } else {// Si es Quincenal.
	                                                    if (solicitud.diaPagoInteres == 'D') {
	                                                        $('#diaPagoInteresD').attr('checked',true);
	                                                        $('#diaPagoInteresQ').attr('checked',false);
	                                                        $('#diaDosQuincInt').val(Number(solicitud.diaMesInteres) + 15);
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
	                                                $('#diaPagoInteres').val(solicitud.diaPagoInteres);

	                                                consultaCalendarioPorProductoSolicitud(solicitud.productoCreditoID,solicitud.tipoPagoCapital,
	                                                solicitud.frecuenciaCap,solicitud.frecuenciaInt,solicitud.plazoID,solicitud.tipoDispersion);
	                                                productoCreditoGuardado = solicitud.productoCreditoID;
	                                                consultaProducCreditoForanea(solicitud.productoCreditoID,'no', solicitud.convenioNominaID, false);

	                                                //Validacion para tipo de dispersion transferencia santander
	                                                if(solicitud.tipoDispersion=='A' && reqInstruDispersion !='S'){
	                                                		$('#dispSantander').show();
	                                                		if(solicitud.tipoCtaSantander == 'A'){
	                                                			$('#tipoSantander').attr('checked',true);
	                                                			$('#tipoOtroBanco').attr('checked',false);

	                                                			$('#ctaSantanderTxt').show();
	                                                			$('#ctaClabeTxt').hide();
	                                                			$('#ctaSantanderInput').show();
	                                                			$('#ctaClabeInput').hide();
	                                                			$('#ctaSantander').val(solicitud.ctaSantander);
	                                                			$('#ctaClabeDisp').val('');
	                                                			$('#lblCuentaCLABE').show();
	                                                			$('#inputCuentaCLABE').show();
	                                                		}

	                                                		if(solicitud.tipoCtaSantander == 'O'){
	                                                			$('#tipoSantander').attr('checked',false);
	                                                			$('#tipoOtroBanco').attr('checked',true);
	                                                			$('#ctaSantanderTxt').hide();
	                                                			$('#ctaClabeTxt').show();
	                                                			$('#ctaSantanderInput').hide();
	                                                			$('#ctaClabeInput').show();
	                                                			$('#lblCuentaCLABE').hide();
	                                                			$('#inputCuentaCLABE').hide();
	                                                			$('#ctaSantander').val('');
	                                                			$('#ctaClabeDisp').val(solicitud.ctaClabeDisp);
	                                                		}
	                                                		$('#tipoCtaSantander').val(solicitud.tipoCtaSantander);
	                                                }else{
	                                                	$('#tipoCtaSantander').val('');
	                                                	$('#ctaSantander').val('');
	                                        			$('#ctaClabeDisp').val('');
	                                                	$('#dispSantander').hide();
	                                                }


	                                                if(solicitud.esAutomatico == 'S'){
	                                                    if(solicitud.tipoAutomatico == 'I'){
	                                                        muestraInversion();
	                                                        $('#inversionID').val(solicitud.inversionID);
	                                                        validaInversion('inversionID');
	                                                    }
	                                                    if(solicitud.tipoAutomatico == 'A'){
	                                                        muestraCuentas();
	                                                        $('#cuentaAhoID').val(solicitud.cuentaAhoID);
	                                                        validaCtaAho('cuentaAhoID');
	                                                    }

	                                                    calculoTasasAutomaticos();
	                                                }
	                                                else{
	                                                    ocultaCamposAutomatico();
	                                                }

	                                                if(validaAccesorios(tipoConAccesorio.producto)==true && cobraAccesorios == 'S'){
	                                                    muestraGridAccesorios();
	                                                }


	                                                consultaBeneficiario('solicitudCreditoID');
	                                                calculaTasa = 'N';
	                                                consultaCliente(solicitud.clienteID,calculaTasa);
	                                                consultaProspecto('prospectoID');

	                                                consultaDestinoCreditoSolicitud('destinoCreID');

	                                                $('#factorRiesgoSeguro').val(solicitud.factorRiesgoSeguro);
	                                                $(  '#forCobroSegVida').val(solicitud.tipoPagoSeguro);
	                                                $('#montoPolSegVida').val(solicitud.montoPolSegVida);

	                                                if(modalidad == 'U'){
	                                                    if (solicitud.forCobroSegVida == 'F') {
	                                                        $('#tipoPagoSeguro').val(financiado);
	                                                    } else {
	                                                        if (solicitud.forCobroSegVida == 'D') {
	                                                            $('#tipoPagoSeguro').val(deduccion);
	                                                        } else {
	                                                            if (solicitud.forCobroSegVida == 'A') {
	                                                                $('#tipoPagoSeguro').val(anticipado);
	                                                            }
	                                                        }
	                                                    }

	                                                    }else{
	                                                        if(modalidad == 'T'){
	                                                        if (solicitud.forCobroSegVida == 'F') {
	                                                            $('#tipPago').val('F');
	                                                        } else {
	                                                            if (solicitud.forCobroSegVida == 'D') {
	                                                                $('#tipPago').val('D');

	                                                            } else {
	                                                                if (solicitud.forCobroSegVida == 'A') {
	                                                                    $('#tipPago').val('A');
	                                                                }else{
	                                                                    if (solicitud.forCobroSegVida == 'O') {
	                                                                        $('#tipPago').val('O');
	                                                                    }
	                                                                }
	                                                            }
	                                                        }

	                                                        //consultaEsquemaSeguroVidaForanea(solicitud.forCobroSegVida);

	                                                     }

	                                                    }// termina condicion de modalidad


	                                                consultaInstitucionFondeo('institutFondID');
	                                                consultaLineaFondeo('lineaFondeoID');

	                                                if (solicitud.estatus != 'I') {
	                                                    if (solicitud.estatus == 'A'
	                                                        || solicitud.estatus == 'D'
	                                                            || solicitud.estatus == 'L'
	                                                                || solicitud.estatus == 'C') {
	                                                        deshabilitaBoton('modificar','submit');
	                                                        deshabilitaBoton('liberar','submit');
	                                                        deshabilitaBoton('agregar','submit');
	                                                        $('#liberar').hide();
	                                                        $('#simular').hide();
	                                                        $('#fechaInicio').val(solicitud.fechaInicio);
	                                                        $('#fechaInicioAmor').val(solicitud.fechaInicioAmor);
	                                                        deshabilitaControl('direccionBen');
	                                                        deshabilitaControl('beneficiario');
	                                                        deshabilitaControl('parentescoID');
	                                                        deshabilitaControl('parentesco');
	                                                        deshabilitaControl('tipPago');

	                                                        // CARGA NIVEL DE CREDITO CON TASA

	                                                          cargaComboNiveles($("#sucursalID").val(),
	                                                                            solicitud.productoCreditoID,
	                                                                            $('#numCreditos').asNumber(),
	                                                                            solicitud.montoSolici,
	                                                                            $('#calificaCliente').val(),
	                                                                            solicitud.plazoID,
	                                                                            $('#institucionNominaID').val()
	                                                         );

	                                                        // ESTABLECE EL VALOR DE LA TASA DE LA SOLICITUD
	                                                        $('#tasaFija').val(solicitud.tasaFija).change();
	                                                        $('#tasaFija').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});

	                                                        //CUANDO TENGA OPCIONES EL COMBO SE MOSTRARA Y OCULTA EL CAMPO TASA
	                                                        if(document.getElementById("tasaNivel").length > 0){
	                                                            $("#tdTasaFija").hide();
	                                                            $('#tdTasaNivel').show();
	                                                            $('#tasaNivel').val($('#tasaFija').val());

	                                                        }else{// SI NO SE LLENA MOSTRARA EL VALOR DE LA TASA QUE SE OBTIENE Y NO EL COMBO
	                                                            $("#tdTasaFija").show();
	                                                            $('#tdTasaNivel').hide();
	                                                        }
	                                                    }

	                                                    deshabilitaInputs();
	                                                } else {
	                                                    // si la solicitud es inactiva valida que el promotor pueda liberar la solicitud de credito si corresponde
	                                                    // con la sucursal o si el promotor no atiende sucursal
	                                                    $('#sucursalPromotor').val(solicitud.sucursalPromotor);
	                                                    $('#promAtiendeSuc').val(solicitud.promAtiendeSuc);
	                                                    habilitaControl('tipPago');

	                                                    if (solicitud.sucursalID == solicitud.sucursalPromotor || solicitud.promAtiendeSuc == 'N') {
	                                                        // si se  trata de una solicitud individual entonces se muestra y habilita el boton de liberar,
	                                                        // en caso contrario se oculta si se trata de una solicitud individual entonces se muestra el
	                                                        // div de comentarios, en caso contrario se oculta
	                                                        if ($('#grupo').val() != undefined) {
	                                                            deshabilitaBoton('liberar','submit');
	                                                            $('#liberar').hide();
	                                                            $('#comentarios').hide();
	                                                            $('#comentario').hide();
	                                                            funcionMuestraDivGrupo();
	                                                        } else {
	                                                            if ($('#flujoIndividualBandera').val() == undefined) {

	                                                                // Validacion del boton Liberar
	                                                                if(restringebtnLiberacionSol == 'S'){
	                                                                    if(rolUsuarioID == primerRolFlujoSolID || rolUsuarioID == segundoRolFlujoSolID ){
	                                                                        $('#liberar').show();
	                                                                habilitaBoton('liberar','submit');
	                                                                    }else{
	                                                                        $('#liberar').hide();
	                                                                        deshabilitaBoton('liberarGrupal');
	                                                                    }
	                                                                }else{
	                                                                $('#liberar').show();
	                                                                    habilitaBoton('liberar','submit');
	                                                                }
	                                                                $('#comentarios').show();
	                                                                $('#comentario').show();
	                                                                funcionOcultaDivGrupo();
	                                                            } else {
	                                                                deshabilitaBoton('liberar','submit');
	                                                                $('#liberar').hide();
	                                                                $('#comentarios').show();
	                                                                $('#comentario').show();
	                                                                funcionOcultaDivGrupo();
	                                                            }
	                                                        }

	                                                        habilitaBoton('modificar','submit');
	                                                        deshabilitaBoton('agregar','submit');
	                                                        habilitaInputsAutorizada();
	                                                        if(esAutomatico == 'S' && tipoAutomatico == 'I'){
	                                                            deshabilitaControl('plazoID');
	                                                        }
	                                                        $('#simular').show();
	                                                        if((Date.parse($('#fechaInicioAmor').val())) < (Date.parse(parametroBean.fechaAplicacion))){
	                                                            $('#fechaInicioAmor').val(parametroBean.fechaAplicacion);
	                                                        }

	                                                        habilitaControlesSolicitudInactiva();
	                                                        // valida que no se pueda cambiar el grupo en la solicitud cuando es modificación
	                                                        if ($('#grupo').val() != undefined) {
	                                                            deshabilitaControl('productoCreditoID');
	                                                            deshabilitaControl('grupoID');
	                                                            habilitaControl('tipoIntegrante');
	                                                        } else {
	                                                            habilitaControl('productoCreditoID');
	                                                            habilitaControl('grupoID');
	                                                            habilitaControl('tipoIntegrante');
	                                                        }
	                                                        habilitaControl('direccionBen');
	                                                        habilitaControl('beneficiario');
	                                                        habilitaControl('parentescoID');

	                                                        // CARGA NIVEL DE CREDITO CON TASA

	                                                        cargaComboNiveles($("#sucursalID").val(),
	                                                                            solicitud.productoCreditoID,
	                                                                            $('#numCreditos').asNumber(),
	                                                                            solicitud.montoSolici,
	                                                                            $('#calificaCliente').val(),
	                                                                            solicitud.plazoID,
	                                                                            $('#institucionNominaID').val()
	                                                        );

	                                                        // ESTABLECE EL VALOR DE LA TASA DE LA SOLICITUD
	                                                        $('#tasaFija').val(solicitud.tasaFija).change();
	                                                        $('#tasaFija').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});

	                                                        //CUANDO TENGA OPCIONES EL COMBO SE MOSTRARA Y OCULTA EL CAMPO TASA
	                                                        if(document.getElementById("tasaNivel").length > 0){
	                                                            $("#tdTasaFija").hide();
	                                                            $('#tdTasaNivel').show();
	                                                            $('#tasaNivel').val($('#tasaFija').val());

	                                                        }else{// SI NO SE LLENA MOSTRARA EL VALOR DE LA TASA QUE SE OBTIENE Y NO EL COMBO
	                                                            $("#tdTasaFija").show();
	                                                            $('#tdTasaNivel').hide();
	                                                        }

	                                                    } else {
	                                                        $('#liberar').hide();
	                                                        deshabilitaBoton('liberar','submit');
	                                                        deshabilitaBoton('modificar','submit');
	                                                        deshabilitaBoton('agregar','submit');
	                                                        mensajeSis("El promotor que atiende la sucursal, no corresponde con la sucursal de la Solicitud");
	                                                    }
	                                                }

	                                                if(solicitud.calcInteresID == '2' || solicitud.calcInteresID == '3' || solicitud.calcInteresID == '4'){
	                                                    validaSobreTasa();
	                                                    $('#sobreTasa').val(solicitud.sobreTasa);
	                                                    consultaTasaBase('tasaBase',true);
	                                                }

	                                                if (solicitud.tipoFondeo == "P") {
	                                                    $('#tipoFondeo').attr('checked',true);
	                                                    $('#tipoFondeo2').attr("checked",false);
	                                                    deshabilitaControl('lineaFondeoID');
	                                                } else {
	                                                    if (solicitud.tipoFondeo == "F") {
	                                                        $('#tipoFondeo2').attr('checked',true);
	                                                        $('#tipoFondeo').attr("checked",false);
	                                                        habilitaControl('lineaFondeoID');
	                                                    }
	                                                }

	                                                if (solicitud.clasifiDestinCred == Comercial) {
	                                                    $('#clasificacionDestin1').attr("checked",true);
	                                                    $('#clasificacionDestin2').attr("checked",false);
	                                                    $('#clasificacionDestin3').attr("checked",false);
	                                                    $('#clasifiDestinCred').val('C');
	                                                } else if (solicitud.clasifiDestinCred == Consumo) {
	                                                    $('#clasificacionDestin1').attr("checked",false);
	                                                    $('#clasificacionDestin2').attr("checked",true);
	                                                    $('#clasificacionDestin3').attr("checked",false);
	                                                    $('#clasifiDestinCred').val('O');
	                                                } else {
	                                                    $('#clasificacionDestin1').attr("checked",false);
	                                                    $('#clasificacionDestin2').attr("checked",false);
	                                                    $('#clasificacionDestin3').attr("checked",true);
	                                                    $('#clasifiDestinCred').val('H');
	                                                }

	                                                if ($('#grupo').val() != undefined || (solicitud.grupoID > 0 && solicitud.grupoID != "" && solicitud.grupoID != null)) {
	                                                    consultaGrupo('grupoID');
	                                                    consultaTipoIntegrante();
	                                                }
	                                                $('#montoSolici').formatCurrency({
	                                                    positiveFormat : '%n',
	                                                    roundToDecimalPlace : 2
	                                                });
	                                                $('#montoAutorizado').formatCurrency({
	                                                    positiveFormat : '%n',
	                                                    roundToDecimalPlace : 2
	                                                });
	                                                $(
	                                                '#montoAutorizado').formatCurrency({
	                                                    positiveFormat : '%n',
	                                                    roundToDecimalPlace : 2
	                                                });
	                                                $('#montoCuota').formatCurrency({
	                                                    positiveFormat : '%n',
	                                                    roundToDecimalPlace : 2
	                                                });

	                                                $('#CAT').formatCurrency({
	                                                        positiveFormat : '%n',
	                                                        roundToDecimalPlace : 1
	                                                });

	                                                $('#cobertura').formatCurrency({
	                                                    positiveFormat : '%n',
	                                                    roundToDecimalPlace : 2
	                                                });
	                                                $('#prima').formatCurrency({
	                                                    positiveFormat : '%n',
	                                                    roundToDecimalPlace : 2
	                                                });

	                                                // valida que el comentario de ejecutivo contenga informacion para mostrarlo
	                                                if (solicitud.comentarioEjecutivo != "" && solicitud.comentarioEjecutivo != null) {
	                                                    $('#comentariosEjecutivo').show();
	                                                    $('#separa').show(); // separador
	                                                } else {
	                                                    $('#comentariosEjecutivo').hide();
	                                                    $('#separa').hide();
	                                                }
	                                                // se utiliza  para  saber cuando se agrega  o  quita  una cuota
	                                                NumCuotas = solicitud.numAmortizacion;
	                                                NumCuotasInt = solicitud.numAmortInteres;

	                                                //validaciones para consultaSIC
	                                                if (solicitud.tipoConsultaSIC != "" && solicitud.tipoConsultaSIC != null) {
	                                                    $('#comentariosEjecutivo').show();
	                                                    if (solicitud.tipoConsultaSIC == "BC") {
	                                                        $('#tipoConsultaSICBuro').attr("checked",true);
	                                                        $('#tipoConsultaSICCirculo').attr("checked",false);
	                                                        $('#consultaBuro').show();
	                                                        $('#consultaCirculo').hide();
	                                                        $('#folioConsultaCC').val('');
	                                                    }else if (solicitud.tipoConsultaSIC == "CC") {
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

	                                                if (esNomina === 'S'){
	                                                	obtenerServiciosAdicionales();
	                                                }
	                                            }
	                                        }

	                                        if(editaSucursal=="S"){
	                                            $('#sucursalCte').val(solicitud.sucursalID);
	                                            consultaSucursal('sucursalCte');
	                                        }
	                                    }else{
	                                    	 mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
	                                    	 inicializarSolicitud();
	                                         $('#solicitudCreditoID').focus();
	                                         $('#solicitudCreditoID').val("");
	                                    }
                                    } else {
                                        mensajeSis("La Solicitud de Credito No existe.");
                                        inicializarSolicitud();
                                        $('#solicitudCreditoID').focus();
                                        $('#solicitudCreditoID').val("");
                                    }

                            }   });

                    }
                }
            }


            // funcion para obtener los valores de la primera solicitud si ya existe una
            // sólo se ocupa para solicitudes grupales y cuando ya es la segunda que se da de alta.
            function consultaValoresPrimeraSolicitudGrupal(solCred) {
                setTimeout("$('#cajaLista').hide();", 200);
                if (solCred != '' && !isNaN(solCred) && esTab) {

                    if (solCred != '0') {
                        var SolCredBeanCon = {
                                'solicitudCreditoID' : solCred,
                                'usuario' : usuario
                        };
                        solicitudCredServicio.consulta(
                                catTipoConsultaSolicitud.principal,SolCredBeanCon,
                                function(solicitud) {
                                    if (solicitud != null && solicitud.solicitudCreditoID != 0) {
                                        esTab = true;

                                        if(cobraAccesoriosGen=='S'){
                                            cobraAccesorios=solicitud.cobraAccesorios;
                                        }
                                        // forma de pago del producto de credito com apertura
                                        if (solicitud.forCobroComAper == 'F') {
                                            $('#formaComApertura').val(financiado);
                                        } else {
                                            if (solicitud.forCobroComAper == 'D') {
                                                $('#formaComApertura').val(deduccion);
                                            } else {
                                                if (solicitud.forCobroComAper == 'A') {
                                                    $('#formaComApertura').val(anticipado);
                                                }
                                                else{
                                                    if (solicitud.forCobroComAper == 'P') {
                                                        $('#formaComApertura').val(programado);
                                                    }
                                                }
                                            }
                                        }

                                        /*campo auxiliar para la forma del cobro usado en el calculo del seguro de vida
                                         * cuando se da de alta la segunda solicitud grupal*/
                                        $('#auxTipPago').val(solicitud.forCobroSegVida);


                                        // forma de pago del seguro de vida
                                        if (solicitud.forCobroSegVida == 'F') {
                                            $('#tipoPagoSeguro').val(financiado);
                                            $('#forCobroSegVida').val("F");
                                        } else {
                                            if (solicitud.forCobroSegVida == 'D') {
                                                $('#tipoPagoSeguro').val(deduccion);
                                                $('#forCobroSegVida').val("D");

                                            } else {
                                                if (solicitud.forCobroSegVida == 'A') {
                                                    $('#tipoPagoSeguro').val(anticipado);
                                                    $('#forCobroSegVida').val("A");

                                                }else{
                                                    if (solicitud.forCobroSegVida == 'O') {
                                                        $('#forCobroSegVida').val("O");

                                                    }
                                                }
                                            }
                                        }



                                        // valores del calendario de pagos
                                        if (solicitud.fechInhabil == 'S') {
                                            $('#fechInhabil').val("S");
                                            $('#fechInhabil1').attr('checked',true);
                                            $('#fechInhabil2').attr("checked",false);
                                        } else {
                                            $('#fechInhabil2').attr('checked',true);
                                            $('#fechInhabil1').attr("checked",false);
                                            $('#fechInhabil').val("A");
                                        }

                                        if (solicitud.ajusFecExiVen == 'S') {
                                            $('#ajusFecExiVen1').attr('checked',true);
                                            $('#ajusFecExiVen2').attr("checked",false);
                                            $('#ajusFecExiVen').val("S");
                                        } else {
                                            $('#ajusFecExiVen1').attr("checked",false);
                                            $('#ajusFecExiVen2').attr('checked',true);
                                            $('#ajusFecExiVen').val("N");
                                        }

                                        if (solicitud.calendIrregular == 'S') {
                                            $('#calendIrregularCheck').attr('checked',true);
                                            $('#calendIrregular').val("S");
                                            deshabilitaControl('numAmortizacion');
                                            deshabilitaControl('numAmortInteres');
                                        } else {
                                            $('#calendIrregularCheck').attr("checked",false);
                                            $('#calendIrregular').val("N");
                                            habilitaControl('numAmortizacion');
                                            if(solicitud.tipoPagoCapital == 'C' || $('#perIgual').val() == 'S' ) {
                                                deshabilitaControl('numAmortInteres');
                                            }else{
                                                habilitaControl('numAmortInteres');
                                            }
                                        }

                                        if (solicitud.ajFecUlAmoVen == 'S') {
                                            $('#ajFecUlAmoVen1').attr('checked',true);
                                            $('#ajFecUlAmoVen2').attr("checked",false);
                                            $('#ajFecUlAmoVen').val("S");
                                        } else {
                                            $('#ajFecUlAmoVen1').attr("checked",false);
                                            $('#ajFecUlAmoVen2').attr('checked',true);
                                            $('#ajFecUlAmoVen').val("N");
                                        }

                                        // Si no es Quincenal.
                                        if(solicitud.frecuenciaCap != frecuenciaQuincenal){
                                            if (solicitud.diaPagoCapital == 'F') {
                                                $('#diaPagoCapital1').attr('checked',true);
                                                $('#diaPagoCapital2').attr('checked',false);
                                            } else {
                                                $('#diaPagoCapital2').attr('checked',true);
                                                $('#diaPagoCapital1').attr('checked',false);
                                            }
                                            $('#divDiaPagoCapMes').show();
                                            $('#divDiaPagoCapQuinc').hide();
                                        } else {// Si es Quincenal.
                                            if (solicitud.diaPagoCapital == 'D') {
                                                $('#diaPagoCapitalD').attr('checked',true);
                                                $('#diaPagoCapitalQ').attr('checked',false);
                                                $('#diaDosQuincCap').val(Number(solicitud.diaMesCapital) + 15);
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

                                        $('#diaPagoCapital').val(solicitud.diaPagoCapital);
                                        $('#diaPagoInteres').val(solicitud.diaPagoInteres);

                                        //  Si no es Quincenal.
                                        if(solicitud.frecuenciaInt != frecuenciaQuincenal){
                                            if (solicitud.diaPagoInteres == 'F') {
                                                $('#diaPagoInteres1').attr('checked',true);
                                                $('#diaPagoInteres2').attr('checked',false);
                                            } else {
                                                $('#diaPagoInteres1').attr('checked',false);
                                                $('#diaPagoInteres2').attr('checked',true);
                                            }
                                            $('#divDiaPagoIntMes').show();
                                            $('#divDiaPagoIntQuinc').hide();
                                        } else {// Si es Quincenal.
                                            if (solicitud.diaPagoInteres == 'D') {
                                                $('#diaPagoInteresD').attr('checked',true);
                                                $('#diaPagoInteresQ').attr('checked',false);
                                                $('#diaDosQuincInt').val(Number(solicitud.diaMesInteres) + 15);
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

                                        if (solicitud.tipoFondeo == "P") {
                                            $('#tipoFondeo').attr('checked',true);
                                            $('#tipoFondeo2').attr("checked",false);
                                            deshabilitaControl('lineaFondeoID');
                                        } else {
                                            if (solicitud.tipoFondeo == "F") {
                                                $('#tipoFondeo2').attr('checked',true);
                                                $('#tipoFondeo').attr("checked",false);
                                                habilitaControl('lineaFondeoID');
                                            }
                                        }

                                        if ($('#grupo').val() != undefined) {
                                            consultaGrupo('grupoID');
                                        }
                                        fechaVencimientoInicial = solicitud.fechaVencimiento;
                                        NumCuotas = solicitud.numAmortizacion;
                                        NumCuotasInt = solicitud.numAmortInteres;
                                        $('#fechaVencimiento').val(solicitud.fechaVencimiento);
                                        $('#productoCreditoID').val(solicitud.productoCreditoID);
                                        $('#grupoID').val(solicitud.grupoID);
                                        setCalcInteresID(solicitud.calcInteresID,false);
                                        $('#tipoCalInteres').val(solicitud.tipoCalInteres).selected = true;
                                        $('#diaMesCapital').val(solicitud.diaMesCapital);
                                        $('#diaMesInteres').val(solicitud.diaMesInteres);

                                        $('#numAmortizacion').val(solicitud.numAmortizacion);
                                        $('#numAmortInteres').val(solicitud.numAmortInteres);
                                        $('#periodicidadInt').val(solicitud.periodicidadInt);
                                        $('#periodicidadCap').val(solicitud.periodicidadCap);

                                        // se llena la parte del calendario y valores parametrizados en el producto
                                        // seleccionando los que se trajo de resultado la consulta
                                        consultaCalendarioPorProductoSolicitud(solicitud.productoCreditoID,solicitud.tipoPagoCapital,
                                                solicitud.frecuenciaCap,solicitud.frecuenciaInt,solicitud.plazoID,solicitud.tipoDispersion);
                                        consultaProducCreditoForanea(solicitud.productoCreditoID,solicitud.fechaVencimiento, solicitud.convenioNominaID, true);
                                    }
                                });
                    }
                }
            }

            function consultaAutomatico(idControl){
                var jqProdCred = eval("'#" + idControl + "'");
                var ProdCred = $(jqProdCred).val();
                var ProdCredBeanCon = {
                        'producCreditoID' : ProdCred
                };
                setTimeout("$('#cajaLista').hide();", 200);
                if (ProdCred != '' && !isNaN(ProdCred) && esTab) {
                    productosCreditoServicio.consulta(catTipoConsultaSolicitud.principal,ProdCredBeanCon,{
                            async : false,
                            callback: function(prodCred) {
                                if (prodCred != null) {
                                        esAutomatico = prodCred.esAutomatico;
                                        tipoAutomatico = prodCred.tipoAutomatico;
                                }}});
            }
            }

            // consulta el producto de credito sólo se ocupa cuando se trata del alta de una solicitud de crédito nueva.
            function consultaProducCredito(idControl, validaComAper) {
                var jqProdCred = eval("'#" + idControl + "'");
                var ProdCred = $(jqProdCred).val();
                var ProdCredBeanCon = {
                        'producCreditoID' : ProdCred
                };

                setTimeout("$('#cajaLista').hide();", 200);
                if (ProdCred != '' && !isNaN(ProdCred) && esTab) {
                    productosCreditoServicio.consulta(catTipoConsultaSolicitud.principal,ProdCredBeanCon,{
                            async : false,
                            callback: function(prodCred) {
                                if (prodCred != null) {
                                        mostrarLabelTasaFactorMora(prodCred.tipCobComMorato);
                                        // SEGUROS
                                        if($('#mostrarSeguroCuota').val()=='S'){
                                            $('#cobraSeguroCuota').val(prodCred.cobraSeguroCuota).selected = true;
                                            $('#cobraIVASeguroCuota').val(prodCred.cobraIVASeguroCuota).selected = true;
                                        } else {
                                            $('#cobraSeguroCuota').val("N").selected = true;
                                            $('#cobraIVASeguroCuota').val("N").selected = true;
                                        }
                                        // FIN SEGUROS
                                        if(cobraAccesoriosGen== 'S'){
                                            cobraAccesorios=prodCred.cobraAccesorios;
                                        }
                                        //NOMINA
                                        esNomina = prodCred.productoNomina;
                                        porcentaje = prodCred.porcMaximo;
                                        esAutomatico = prodCred.esAutomatico;
                                        tipoAutomatico = prodCred.tipoAutomatico;
                                        manejaCalendario = '';
                                        if(esAutomatico == 'S'){
                                            if(tipoAutomatico == 'I'){
                                                muestraInversion();
                                            }
                                            if(tipoAutomatico == 'A'){
                                                muestraCuentas();
                                            }
                                        }
                                        else{
                                            ocultaCamposAutomatico();
                                        }
                                        /*Se verifica primero si el producto de credito permite prospecto*/
                                        if($('#clienteID').asNumber()>0 || prodCred.permiteAutSolPros == permiteSolicitudProspecto){
                                            consultaRelacionCliente('productoCreditoID');
                                            modalidad = prodCred.modalidad;
                                            esquemaSeguro = prodCred.esquemaSeguroID;

                                            esTab = true;

                                            if (prodCred.productoNomina == "S") {
                                                $('#lblnomina').show();
                                                $('#institNominaID').show();
                                                $('#lblFolioCtrl').show();
                                                consultaEmpleado('clienteID');
                                                consultaEmpleadoProspecto('prospectoID');

                                                $('#folioCtrlCaja').show();
                                                $('#sep').show();
                                            } else {
                                                $('#lblnomina').hide();
                                                $('#institNominaID').hide();
                                                $('#lblFolioCtrl').hide();
                                                $('#folioCtrlCaja').hide();
                                                $('#sep').hide();
                                            }
                                            // si el producto de credito  que se esta consultando  no es grupal  y se esta ocupando desde
                                            // la pantalla de solicitud  grupal  se manda aviso para obligar al usuario a seleccionar producto grupal
                                            if (prodCred.esGrupal != "S" && $('#grupo') .val() != undefined) {
                                                mensajeSis("El producto de crédito seleccionado debe ser grupal.");
                                                $('#productoCreditoID').val("");
                                                $('#productoCreditoID').focus();
                                                $('#productoCreditoID').select();
                                                $('#descripProducto').val("");
                                                productoIDBase = 0;
                                            } else {
                                                consultacicloCliente();
                                                if(prodCred.productoNomina=="S") {
                                                    if(manejaConvenio == 'S') {
                                                        $("#convenios").show();
                                                        funcionConsultaEmpleadoNomina('clienteID');
                                                    }else{
                                                        $("#convenios").hide();
                                                    }
                                                }
                                                else{
                                                    $("#convenios").hide();
                                                    $("#convenioNominaID").val("")
                                                }

                                                $('#descripProducto').val(prodCred.descripcion);
                                                $('#factorMora').val(prodCred.factorMora);
                                                setCalcInteresID(prodCred.calcInteres,true);
                                                $('#tipoCalInteres').val(prodCred.tipoCalInteres);
                                                if (prodCred.tipoCalInteres == '2') {
                                                    $('#tipoPagoCapital').val('I').selected = true;
                                                }
                                                $('#institutFondID').val(prodCred.institutFondID);
                                                $('#esGrupal').val(prodCred.esGrupal);
                                                $('#tasaPonderaGru').val(prodCred.tasaPonderaGru);

                                                consultaPorcentajeGarantiaLiquida('productoCreditoID');

                                                if(cobraGarantiaFinanciada == 'S'){
                                                    consultaPorcentajeFOGAFI('productoCreditoID');
                                                }


                                                // forma de pago del producto de credito com apertura
                                                if(validaComAper){
                                                    if (prodCred.formaComApertura == 'F') {
                                                        $('#formaComApertura').val(financiado);
                                                    } else {
                                                        if (prodCred.formaComApertura == 'D') {
                                                            $('#formaComApertura').val(deduccion);
                                                        } else {
                                                            if (prodCred.formaComApertura == 'A') {
                                                                $('#formaComApertura').val(anticipado);
                                                            }
                                                            else{
                                                                if (prodCred.formaComApertura == 'P') {
                                                                    $('#formaComApertura').val(programado);
                                                                }
                                                            }
                                                        }
                                                    }
                                                }

                                                formaCobroComApe = prodCred.formaComApertura;
                                                montoMaxSolicitud = prodCred.montoMaximo;
                                                montoMinSolicitud = prodCred.montoMinimo;

                                                if (prodCred.institutFondID == '0') {
                                                    habilitaControl('tipoFondeo');
                                                    $('#tipoFondeo').attr('checked',true);
                                                    deshabilitaControl('lineaFondeoID');
                                                    $('#lineaFondeoID').val('0');
                                                }
                                                consultaInstitucionFondeo('institutFondID');

                                                // si el producto de credito es grupal, activa el input de grupo
                                                if (prodCred.esGrupal == 'S') {
                                                    // obtiene  individual  producto de  credito
                                                    max = Number(prodCred.maxIntegrantes);
                                                    min = Number(prodCred.minIntegrantes);
                                                    maxh = Number(prodCred.maxHombres);
                                                    minh = Number(prodCred.minHombres);
                                                    maxm = Number(prodCred.maxMujeres);
                                                    minm = Number(prodCred.minMujeres);
                                                    maxms = Number(prodCred.maxMujeresSol);
                                                    minms = Number(prodCred.minMujeresSol);

                                                    if ($('#grupo').val() != '' && $('#grupo').val() != undefined) {
                                                        deshabilitaControl('grupoID');
                                                    } else {
                                                        habilitaControl('grupoID');
                                                    }
                                                    habilitaControl('tipoIntegrante');
                                                } else {
                                                    deshabilitaControl('tipoIntegrante');
                                                    deshabilitaControl('grupoID');
                                                    $('#grupoID').val("");
                                                    $('#nombreGr').val("");
                                                    $('#tipoIntegrante').val("");
                                                }

                                                // GUARDA  EL VALOR  SI  TIENE SEGURO O NO
                                                requiereSeg = prodCred.reqSeguroVida;
                                                // esconde o muestra los elemento de cuando requiere seguro de vida
                                                validaSiseguroVida(prodCred.reqSeguroVida);

                                                if(prodCred.modalidad == "T"){
                                                    descuentoSeg = prodCred.descuentoSeguro;
                                                    $('#ltipoPago').hide();
                                                    $('#tipoPagoSeguro').hide();
                                                    $('#tipoPagoSelect').show();
                                                    $('#tipoPagoSelect2').show();

                                                    consultaTiposPago(prodCred.producCreditoID,prodCred.esquemaSeguroID,"");

                                                    }else{
                                                        if(prodCred.modalidad == "U"){
                                                        descuentoSeg = prodCred.descuentoSeguro;

                                                        $('#ltipoPago').show();
                                                        $('#tipoPagoSeguro').show();
                                                        $('#tipoPagoSelect').hide();
                                                        $('#tipoPagoSelect2').hide();
                                                        }
                                                    }

                                                // forma de pago del seguro de vida
                                                if(prodCred.modalidad == "U"){
                                                $('#factorRiesgoSeguro').val(prodCred.factorRiesgoSeguro);
                                                $('#forCobroSegVida').val(prodCred.tipoPagoSeguro);
                                                $('#montoPolSegVida').val(prodCred.montoPolSegVida);
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

                                                if(tipoPagoSeg == 'A'){
                                                    $('#tipPago').val('A');
                                                    }
                                                    if(tipoPagoSeg == 'F'){
                                                    $('#tipPago').val('F');
                                                    }
                                                    if(tipoPagoSeg == 'D'){
                                                    $('#tipPago').val('D');
                                                    }
                                                    if(tipoPagoSeg == 'O'){
                                                    $('#tipPago').val('O');
                                                    }
                                            }


                                            // consulta el calendario de pagos limite de monto, sólo cuando es una solicitud nueva
                                            validaLimiteMontoSolicitado();
                                            // valida la comision por apertura
                                            consultaComisionAper();
                                            // se llenan los valores de los combos segun lo parametrizado
                                            consultaCalendarioPorProducto('productoCreditoID');

                                            if ((clienteIDBase > 0 || prospectoIDBase > 0)&& montoSolicitudBase > 0) {
                                                consultaTasaCredito($('#montoSolici').asNumber(),'productoCreditoID');
                                            }

                                        }
                                        // verifica el credito podra tener un desembolso anticipado
                                        $('#fechaInicioAmor').val(parametroBean.fechaAplicacion);

                                        if(prodCred.inicioAfuturo == 'S'){
                                            $("#fechaInicioAmor").attr('readonly',false);
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
                                            $("#fechaInicioAmor").attr('readonly',true);
                                            $("#fechaInicioAmor").datepicker("destroy");

                                            inicioAfuturo = 'N';
                                            diasMaximo = 0;
                                        }
                                        financiamientoRural = prodCred.financiamientoRural;

                                    } else {
                                        mensajeSis("El Producto de Crédito No Permite Autorización de Solicitud Por Prospecto.");
                                        $('#productoCreditoID').focus();
                                        $('#productoCreditoID').select();
                                        $('#descripProducto').val("");
                                    }


                                    if (esNomina === 'S'){
                                    	obtenerServiciosAdicionales();
                                    }
                                    //obtenemos si requiere instruccion de dispersion
                                    reqInstruDispersion = prodCred.instruDispersion;

                                    if(prodCred.estatus == 'I'){
        								mensajeSis("El Producto "+ prodCred.descripcion+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
        								$('#productoCreditoID').focus();
        								deshabilitaBoton('agregar', 'submit');
        								deshabilitaBoton('modificar', 'submit');
        							}else{
        								 // si la solicitud es cero (se trata de una nueva solicitud)
                                        if ($('#solicitudCreditoID').asNumber() == 0) {
                                            habilitaBoton('agregar', 'submit');
                                        }
                                        if ($('#solicitudCreditoID').asNumber() > 0 && $('#estatus').val() == 'I') {
                                            habilitaBoton('modificar', 'submit');
                                        }
        							}

                                } else {
                                    mensajeSis("No Existe el Producto de Crédito");
                                    $('#productoCreditoID').val('');
                                    $('#productoCreditoID').focus();

                                    $('#descripProducto').val("");
                                    // SEGUROS
                                    $('#cobraSeguroCuota').val('N').selected = true;
                                    $('#cobraIVASeguroCuota').val('N').selected = true;
                                    $('#montoSeguroCuota').val('');
                                    productoIDBase = 0;

                                    $("#fechaInicioAmor").attr('readonly',true);
                                    $("#fechaInicioAmor").datepicker("destroy");
                                    inicioAfuturo = 'N';
                                    diasMaximo = 0;
                                    //resetea toda la parte del formulario sobre el producto e credito
                                    $('#destinoCreID').val('');
                                    $('#descripDestino').val('');
                                    $('#destinCredFOMURID').val('');
                                    $('#descripDestinoFOMUR').val('');
                                    $('#proyecto').val('');
                                    //resetea los vaores de la nomina
                                    $('#lblnomina').val('');
                                    $('#institNominaID').val('');
                                    $('#lblFolioCtrl').val('');
                                    $('#folioCtrlCaja').val('');

                                    $('#esGrupal').val('');
                                    $('#tasaPonderaGru').val('');
                                    $('#cicloClienteGrupal').val('');
                                    //oculta los campos refernte al nomina
                                    $('#lblnomina').hide();
                                    $('#institNominaID').hide();
                                    $('#lblFolioCtrl').hide();
                                    $('#folioCtrlCaja').hide();
                                    $('#sep').hide();
                                    //vuelve visible el campo de cicos preomedio grupal
                                    $('#lbciclos').show();
                                    $('#lbcicloscaja').show();
                                }
                            }
                        });
                }
            }

            // consulta foranea del producto de credito utilizada en la consulta de la solicitud de credito
            function consultaProducCreditoForanea(producto, varfecha, convenioID, validaComAper) {
                var convenio = convenioID;
                var ProdCredBeanCon = {
                        'producCreditoID' : producto
                };
                setTimeout("$('#cajaLista').hide();", 200);
                if (producto != '' && !isNaN(producto) && esTab) {
                    productosCreditoServicio.consulta(catTipoConsultaSolicitud.principal,ProdCredBeanCon, { async: false, callback: function(prodCred) {
                                if (prodCred != null) {
                                    mostrarLabelTasaFactorMora(prodCred.tipCobComMorato);

                                    porcentaje = prodCred.porcMaximo;
                                    esAutomatico = prodCred.esAutomatico;
                                    tipoAutomatico = prodCred.tipoAutomatico;
                                    financiamientoRural = prodCred.financiamientoRural;
                                    if(esAutomatico == 'S'){
                                        if(tipoAutomatico == 'I'){
                                            muestraInversion();
                                        }
                                        if(tipoAutomatico == 'A'){
                                            muestraCuentas();
                                        }
                                    }
                                    else{
                                        ocultaCamposAutomatico();
                                    }


                                    if(cobraAccesoriosGen == 'S'){
                                        cobraAccesorios =   prodCred.cobraAccesorios;
                                    }

                                    if (prodCred.productoNomina == "S") {
                                    	esNomina = 'S';
                                        $('#lblnomina').show();
                                        $('#institNominaID').show();
                                        $('#lblFolioCtrl').show();
                                        consultaEmpleado('clienteID');
                                        consultaEmpleadoProspecto('prospectoID');
                                        $('#folioCtrlCaja').show();
                                        $('#sep').show();

                                        if(manejaConvenio=='S'){
                                            $('#convenios').show();
                                            if(convenio != null && convenio != ""){
                                                 listaConveniosActivos(convenio);
                                            }
                                        }else{
                                            $('#convenios').hide();
                                        }
                                        consultaNomInstit(convenio);
                                    } else {
                                    	esNomina = 'N';
                                        $('#lblnomina').hide();
                                        $('#institNominaID').hide();
                                        $('#lblFolioCtrl').hide();
                                        $('#folioCtrlCaja').hide();
                                        $('#sep').hide();
                                        $('#convenios').hide();
                                        dwr.util.removeAllOptions('convenioNominaID');

                                    }
                                    $('#descripProducto')
                                    .val(prodCred.descripcion);

                                    montoMaxSolicitud = prodCred.montoMaximo;
                                    montoMinSolicitud = prodCred.montoMinimo;
                                    formaCobroComApe = prodCred.formaComApertura;


                                    $('#institutFondID').val(prodCred.institutFondID);
                                    $('#tasaPonderaGru').val(prodCred.tasaPonderaGru);
                                    $('#esGrupal').val(prodCred.esGrupal);
                                    requiereSeg = prodCred.reqSeguroVida;
                                    if (prodCred.reqSeguroVida == 'S') {
                                        if (varfecha != 'no') {
                                            calculaNodeDias(varfecha);
                                        }
                                        modalidad = prodCred.modalidad;
                                        esquemaSeguro = prodCred.esquemaSeguroID;
                                        $('#esquemaSeguroID').val(prodCred.esquemaSeguroID);

                                    }

                                     // esconde o muestra  los elemento de cuando requiere seguro de vida
                                    validaSiseguroVida(prodCred.reqSeguroVida);
                                    if (prodCred.reqSeguroVida == 'S') {
                                    if(prodCred.modalidad == "T"){
                                        $('#ltipoPago').hide();
                                        $('#tipoPagoSeguro').hide();
                                        $('#tipoPagoSelect').show();
                                        $('#tipoPagoSelect2').show();
                                        consultaEsquemaSeguroVidaForanea(tipoPagoSeg);

                                        }else{
                                            if(prodCred.modalidad == "U"){
                                            descuentoSeg = prodCred.descuentoSeguro;
                                            $('#ltipoPago').show();
                                            $('#tipoPagoSeguro').show();
                                            $('#tipoPagoSelect').hide();
                                            $('#tipoPagoSelect2').hide();
                                            }
                                        }
                                    }

                                    // forma de pago del producto de credito com apertura
                                    if(validaComAper){
                                        if (prodCred.formaComApertura == 'F') {
                                            $('#formaComApertura').val(financiado);
                                        } else {
                                            if (prodCred.formaComApertura == 'D') {
                                                $('#formaComApertura').val(deduccion);
                                            } else {
                                                if (prodCred.formaComApertura == 'A') {
                                                    $('#formaComApertura').val(anticipado);
                                                }else{
                                                    if (prodCred.formaComApertura == 'P') {
                                                        $('#formaComApertura').val(programado);
                                                    }
                                                }
                                            }
                                        }
                                    }


                                if(prodCred.modalidad == "U"){

                                    $('#factorRiesgoSeguro').val(prodCred.factorRiesgoSeguro);
                                    $('#forCobroSegVida').val(prodCred.tipoPagoSeguro);
                                    $('#montoPolSegVida').val(prodCred.montoPolSegVida);

                                    // forma de pago del seguro de vida
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

                                    if(prodCred.modalidad == "T"){

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

                                         if($('#tipPago option:selected').text() == "ADELANTADO"){
                                             $('#forCobroSegVida').val("A");
                                         }

                                         if($('#tipPago option:selected').text() == "FINANCIAMIENTO"){
                                             $('#forCobroSegVida').val("F");
                                         }

                                         if($('#tipPago option:selected').text() == "DEDUCCION"){
                                             $('#forCobroSegVida').val("D");
                                         }

                                         if($('#tipPago option:selected').text() == "OTRO"){
                                             $('#forCobroSegVida').val("O");
                                         }

                                        }

                                        consultaEsquemaSeguroVidaForanea(tipoPagoSeg);

                                    }

                                    // valida si el credito puede tener un desembolso anticipado

                                    if(prodCred.inicioAfuturo == 'S'){
                                        $("#fechaInicioAmor").attr('readonly',false);
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
                                        $("#fechaInicioAmor").attr('readonly',true);
                                        $("#fechaInicioAmor").datepicker("destroy");

                                        inicioAfuturo = 'N';
                                        diasMaximo = 0;
                                    }
                                    // obtenemos si requiere instruccion de dispersion
                                    reqInstruDispersion = prodCred.instruDispersion;

                                } else {
                                    mensajeSis("No Existe el Producto de Credito.");
                                    $('#productoCreditoID').focus();
                                    $('#productoCreditoID').select();

                                    $("#fechaInicioAmor").attr('readonly',true);
                                    $("#fechaInicioAmor").datepicker("destroy");
                                    // SEGUROS
                                    $('#cobraSeguroCuota').val('N').selected = true;
                                    $('#cobraIVASeguroCuota').val('N').selected = true;
                                    $('#montoSeguroCuota').val('');
                                    inicioAfuturo = 'N';
                                    diasMaximo = 0;
                                }
                            }});
                }
            }

            /*
             * Metodo para consultar las condiciones del calendario  segun el tipo de producto seleccionado y sólo se ocupa
             * cuando se trata de una solicitud nueva para dar de alta,  se dispara cuando el producto de credito pierde el foco
             */
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

                        if
                        (calendario.ajusFecExigVenc == 'S') {
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

                            $('#ajFecUlAmoVen1').attr('checked',true);
                            $('#ajFecUlAmoVen2').attr("checked",false);
                            $('#ajFecUlAmoVen').val("S");
                            habilitaControl('ajFecUlAmoVen1');
                            deshabilitaControl('ajFecUlAmoVen2');
                        } else {

                            $('#ajFecUlAmoVen1').attr("checked",false);
                            $('#ajFecUlAmoVen2').attr('checked',true);
                            $('#ajFecUlAmoVen').val("N");
                            deshabilitaControl('ajFecUlAmoVen1');
                            habilitaControl('ajFecUlAmoVen2');
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
                    seteaDiaPagoQuic(calendario.diaPagoQuincenal, calendario.iguaCalenIntCap);
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
                            $('#diaPagoCapital').val("A");
                            deshabilitaControl('diaMesCapital');

                                deshabilitaControl('diaPagoInteres1');
                                deshabilitaControl('diaPagoInteres2');
                                $('#diaPagoInteres2').attr('checked',true);
                                $('#diaPagoInteres1').attr('checked',false);
                                $('#diaPagoInteres').val("A");
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
                            deshabilitaControl('diaMesCapital'); // se deshabilita xq por default se chequea fin de mes
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
             * cuando se trata de una consulta de una solicitud
             */
            function consultaCalendarioPorProductoSolicitud(producto,valorTipoPagoCapital, valorFrecuenciaCap,
                    valorFrecuenciaInt, valorPlazoID,valorTipoDispersion) {

                var TipoConPrin = 1;
                var calendarioBeanCon = {
                        'productoCreditoID' : producto
                };
                setTimeout("$('#cajaLista').hide();", 200);

                if (producto != '' && !isNaN(producto)) {
                    calendarioProdServicio.consulta(TipoConPrin,calendarioBeanCon, { async: false, callback:function(   calendario) {

                    if (calendario != null) {

                        if (calendario.fecInHabTomar == 'S') {
                            habilitaControl('fechInhabil1');
                            deshabilitaControl('fechInhabil2');
                        } else {
                            deshabilitaControl('fechInhabil1');
                            habilitaControl('fechInhabil2');
                        }

                        if (calendario.ajusFecExigVenc == 'S') {
                            habilitaControl('ajusFecExiVen1');
                            deshabilitaControl('ajusFecExiVen2');
                        } else {
                            deshabilitaControl('ajusFecExiVen1');
                            habilitaControl('ajusFecExiVen2');
                        }

                        if (calendario.permCalenIrreg == 'S') {
                                habilitaControl('calendIrregularCheck');
                        } else {
                                if (calendario.permCalenIrreg == 'N' && $('#estatus').val() == 'I') {
                                    deshabilitaControl('calendIrregularCheck');
                                }
                        }

                        if (calendario.ajusFecUlAmoVen == 'S') {
                            habilitaControl('ajFecUlAmoVen1');
                            deshabilitaControl('ajFecUlAmoVen2');
                        } else {
                            deshabilitaControl('ajFecUlAmoVen1');
                            habilitaControl('ajFecUlAmoVen2');
                        }



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
                                $('#perIgual').val("S");

                                // se llama funcion para deshabilitar calendario de interes
                                deshabilitarCalendarioPagosInteres();
                        } else {
                                if (calendario.iguaCalenIntCap == 'N') {
                                    $('#perIgual').val("N");
                                }
                        }

                        // se consultan los valores que trae la solicitud

                                consultaComboTipoPagoCapSolicitud(calendario.tipoPagoCapital,valorTipoPagoCapital);
                                consultaComboFrecuenciasSolicitud(calendario.frecuencias,valorFrecuenciaCap,valorFrecuenciaInt);
                                consultaComboPlazosSolicitud(calendario.plazoID,valorPlazoID);
                                consultaComboTipoDispersionSolicitud(calendario.tipoDispersion,valorTipoDispersion);
                    } else {
                            mensajeSis("No Existe un Calendario de Pagos para el Producto de Crédito Indicado.");
                    }
                }});
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

                        if(esAutomatico == 'S' && tipoAutomatico == 'I'){
                            if(tpago[i] == 'I' || tpago[i] == 'L'){
                                $('#tipoPagoCapital').append(
                                new Option(pagDescrip, tpago[i], true,
                                        true));
                            }
                        }else{
                            $('#tipoPagoCapital').append(
                                new Option(pagDescrip, tpago[i], true,
                                        true));
                        }

                        if ($('#tipoCalInteres').val() == '2') {
                            $('#tipoPagoCapital').val('I').selected = true;
                            deshabilitaControl('tipoPagoCapital');
                        } else {
                            $('#tipoPagoCapital').val('').selected = true; // se
                            // selecciona
                            // la
                            // opcion
                            // por
                            // defaul
                            habilitaControl('tipoPagoCapital');
                        }

                    }
                }
            }
            //consulta el cliente
            function consultaCliente(numCliente, calcularTasaCredito ) {
                setTimeout("$('#cajaLista').hide();", 200);
                if(numCliente != '' && !isNaN(numCliente) ){
                    clienteServicio.consulta(1,numCliente,{ async: false, callback: function(cliente) {
                        if(cliente!=null){
                            $('#nombreCte').val(cliente.nombreCompleto);
                            if(cliente.esMenorEdad == "S"){
                                mensajeSis("El "+$('#alertSocio').val()+" es Menor, No es Posible Asignar Crédito.");
                                $('#clienteID').val("");
                                $('#clienteID').focus();
                                $('#nombreCte').val('');
                            }else{
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

                                if($('#grupo').val() == undefined){
                                    if( $.trim($('#productoCreditoID').val())!= "" ){
                                        consultacicloCliente();
                                    }
                                }else{
                                    if( $.trim($('#productoCreditoID').val())!= ""  &&  $.trim($('#grupoID').asNumber())> 0 ){
                                        consultacicloCliente();
                                    }
                                }

                                esTab=true;


                                $('#clienteID').val(cliente.numero);
                                $('#nombreCte').val(cliente.nombreCompleto);
                                $('#pagaIVACte').val(cliente.pagaIVA);

                                if(editaSucursal=="N" || (editaSucursal=="S" && $('#solicitudCreditoID').val() == 0)){
                                    $('#sucursalCte').val(cliente.sucursalOrigen);
                                }
                                if($('#solicitudCreditoID').val() == 0){
                                    $('#promotorID').val(cliente.promotorActual);
                                }else{
                                       $('#promotorID').val(solicitudPromotor);

                                    }


                                // Consultamos la tasa si ya tenemos los datos necesarios
                                if($('#clienteID').asNumber() >0 && $('#productoCreditoID').asNumber() >0
                                        && $('#calificaCliente').val() != '' && $('#montoSolici').asNumber() > 0
                                        && $('#sucursalID').asNumber() >0
                                        && ($('#numCreditos').asNumber() > 0 || $('#cicloClienteGrupal').asNumber() > 0 )
                                        && calcularTasaCredito =='S' && ((esNomina == 'S' && $('#institucionNominaID').val().trim()!="") || esNomina!='S')){
                                    esTab =true;
                                    consultaTasaCredito($('#montoSolici').asNumber(),'clienteID');
                                }

                                if($('#solicitudCreditoID').val()==''||$('#solicitudCreditoID').val()=='0'){
                                    if (cliente.estatus=="I"){

                                        deshabilitaBoton('agregar','submit');
                                        mensajeSis("El "+$('#alertSocio').val()+" se encuentra Inactivo");
                                        $('#clienteID').focus();
                                        $('#nombrePromotor').val('');
                                        $('#nombreCte').val('');
                                        $('#promotorID').val('');
                                        $('#sucursalCte').val('');
                                        $('#calificaCredito').val('');
                                        $('#nombreSucursal').val('');
                                        $('#clienteID').val('');

                                    }
                                }else{

                                    if (cliente.estatus=="I"){
                                        $('#liberar').hide();
                                        deshabilitaBoton('agregar','submit');
                                        deshabilitaBoton('modificar','submit');
                                        deshabilitaBoton('liberar','submit');
                                        mensajeSis("El "+$('#alertSocio').val()+" se Encuentra Inactivo.");
                                        $('#solicitudCreditoID').focus();
                                    }
                                }
                                consultaSucursal('sucursalCte');
                                consultaPromotor('promotorID', false);

                                if(cliente.estatus =='A'){
                                    consultaRelacionCliente('clienteID');
                                }

                            }
                        }else{
                            if($('#clienteID').asNumber() != '0'){
                                mensajeSis("El "+$('#alertSocio').val()+" especificado no Existe.");
                                $('#clienteID').val("");
                                $('#clienteID').focus();
                                $('#clienteID').select();
                                $('#calificaCredito').val('');

                            }
                            clienteIDBase = "";
                        }
                    }});
                    // consulta la calificacion numerica del cliente
                    clienteServicio.consulta(16,numCliente,function(cliente) {
                        if(cliente!=null){
                            calificacionCliente = cliente.calificacion;
                        }
                    });
                }
            }

            // funcion que llena el combo de tipo de pago capital, de  acuerdo al producto se usa sólo cuando se trata de una consulta de solicitud
            function consultaComboTipoPagoCapSolicitud(tipoPago, valor) {
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
                        $('#tipoPagoCapital').append(new Option(pagDescrip, tpago[i], true,true));
                        // se selecciona la opcion por default
                        $('#tipoPagoCapital').val(valor).selected = true;
                    }
                }
            }

            // funcion que llena el combo de Frecuencias, de acuerdo al producto
            // se utiliza sólo cuando se da de alta una solicitud de credito nueva.
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
                        case "L": // PAGO UNICO
                            frecDescrip = 'LIBRE';
                            break;
                        default:
                            frecDescrip = 'SEMANAL';
                        }


                        if(esAutomatico && tipoAutomatico == 'I'){
                            if(frec[i] == 'U' || frec[i] == 'L'){
                                $('#frecuenciaCap').append(
                                new Option(frecDescrip, frec[i], true,
                                        true));
                                $('#frecuenciaInt').append(
                                new Option(frecDescrip, frec[i], true,
                                        true));
                            }
                        }
                        else{
                            $('#frecuenciaCap').append(
                                new Option(frecDescrip, frec[i], true,
                                        true));
                            $('#frecuenciaInt').append(
                                new Option(frecDescrip, frec[i], true,
                                        true));
                        }
                        $('#frecuenciaCap').val('').selected = true;
                        $('#frecuenciaInt').val('').selected = true;
                    }

                }
            }



            // funcion que llena el combo de Frecuencias, de acuerdo al producto se utiliza sólo cuando se consulta una solicitud de credito
            function consultaComboFrecuenciasSolicitud(frecuencia,
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
                        case "L": // PAGO LIBRE
                            frecDescrip = 'LIBRE';
                            break;
                        default:
                            frecDescrip = 'SEMANAL';
                        }
                        $('#frecuenciaCap').append(new Option(frecDescrip, frec[i], true,true));
                        $('#frecuenciaInt').append(new Option(frecDescrip, frec[i], true,true));
                        $('#frecuenciaCap').val(valorCap).selected = true;
                        $('#frecuenciaInt').val(valorInt).selected = true;
                    }
                }
            }



            // funcion que llena el combo de plazos, de acuerdo al producto sólo cuando se trata de una solicitud de credito nueva
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
                    var tipoConsulta = 3;

                    if(esAutomatico == 'S' && tipoAutomatico == 'I'){
                        tipoConsulta = 6;
                    }
                    else{
                        if(esAutomatico == 'S' && tipoAutomatico == 'A'){
                            tipoConsulta = 7;
                        }
                        else{
                            tipoConsulta = 3;
                        }

                    }
                    plazosCredServicio.listaCombo(tipoConsulta,function(plazoCreditoBean) {
                                for ( var i = 0; i < tamanio; i++) {
                                    for ( var j = 0; j < plazoCreditoBean.length; j++) {
                                        if (plazo[i] == plazoCreditoBean[j].plazoID) {
                                            $('#plazoID').append(new Option(plazoCreditoBean[j].descripcion,plazo[i],true,true));
                                            $('#plazoID').val('').selected = true;
                                            break;
                                        }
                                    }
                                }
                            });
                }
            }

            // funcion que llena el combo de calcInteres
            function consultaComboCalInteres() {
                dwr.util.removeAllOptions('calcInteresID');
                formTipoCalIntServicio.listaCombo(1,function(formTipoCalIntBean){
                    dwr.util.addOptions('calcInteresID', {'':'SELECCIONAR'});
                    dwr.util.addOptions('calcInteresID', formTipoCalIntBean, 'formInteresID', 'formula');
                });
            }



            // funcion que llena el combo de plazos, de acuerdo al producto se usa cuando se consulta una solicitud de credito
            function consultaComboPlazosSolicitud(varPlazos, plazoValor) {
                // se eliminan los tipos de pago que se tenian
                $('#plazoID').each(function() {
                    $('#plazoID option').remove();
                });
                // se agrega la opcion por default
                $('#plazoID').append(
                        new Option('SELECCIONAR', '', true, true));
                consultaAutomatico('productoCreditoID');
                if (varPlazos != null) {
                    var plazo = varPlazos.split(',');
                    var tamanio = plazo.length;
                    var tipoConsulta = 3;

                    if(esAutomatico == 'S' && tipoAutomatico == 'I'){
                        tipoConsulta = 6;
                    }
                    else{
                        if(esAutomatico == 'S' && tipoAutomatico == 'A'){
                            tipoConsulta = 7;
                        }
                        else{
                            tipoConsulta = 3;
                        }
                    }
                    plazosCredServicio.listaCombo(tipoConsulta,{ async: false, callback:function(plazoCreditoBean) {
                                for ( var i = 0; i < tamanio; i++) {
                                    for ( var j = 0; j < plazoCreditoBean.length; j++) {
                                        if (plazo[i] == plazoCreditoBean[j].plazoID) {
                                            $('#plazoID').append(new Option(plazoCreditoBean[j].descripcion,plazo[i],true,true));
                                            $('#plazoID').val(plazoValor).selected = true;

                                            break;
                                        }
                                    }
                                }
                                var plazoCred = $('#plazoID').val();
                            }});
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

                        $('#tipoDispersion').append(new Option(disperDescrip,tipoDispersion[i], true, true));
                        $('#tipoDispersion').val('').selected = true;
                    }
                }
            }

            // funcion que llena el combo tipo dispersion, de acuerdo al  producto se usa cuando se consulta una solicitud de credito
            function consultaComboTipoDispersionSolicitud(
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
                        case "A": // TRANSFERENCIA SANTANDER
                            disperDescrip = 'TRAN. SANTANDER';
                            break;
                        default:
                            disperDescrip = 'SPEI';
                        }

                        $('#tipoDispersion').append(new Option(disperDescrip,tipoDispersion[i], true, true));
                        $('#tipoDispersion').val(valor).selected = true;
                    }
                }
            }

            // funcion que deshabilita parametros calendario consulta las cuotas de interes
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
                    $('#fechaVencimiento').val("");
                } else {
                    if($('#frecuenciaInt').val() != ""){
                    plazosCredServicio.consulta(tipoCon,PlazoBeanCon, function(plazos) {
                                if (plazos != null) {
                                    $('#numAmortInteres').val(plazos.numCuotas);
                                    // se utiliza para saber cuando se agrega o quita una cuota
                                    NumCuotasInt = parseInt(plazos.numCuotas);
                                }
                            });
                        }
                }
            }

            // consulta del promotor
            function consultaPromotor(idControl, valida) {
                var jqPromotor = eval("'#" + idControl + "'");
                var numPromotor = $(jqPromotor).val();
                var tipConForanea = 2;
                var promotor = {
                        'promotorID' : numPromotor
                };
                setTimeout("$('#cajaLista').hide();", 200);
                if (numPromotor != '' && !isNaN(numPromotor) && esTab) {
                    promotoresServicio.consulta(tipConForanea,promotor, function(promotor) {
                        if (promotor != null) {
                            $('#nombrePromotor').val(promotor.nombrePromotor);
                            if(valida && promotor.sucursalID != $('#sucursalCte').asNumber()){
                                mensajeSis("El Promotor "+$("#promotorID").val()+" no pertenece a la sucursal "+$('#sucursalCte').val());
                                 $(jqPromotor).val("");
                                 $("#nombrePromotor").val("");
                                 $("#sucursalCte").val("");
                                 $("#nombreSucursal").val("");
                                 $("#sucursalCte").focus();
                                 $("#sucursalCte").select();
                            }

                            if(editaSucursal=="S"){
                                 //CALCULO DE LA TASA
                                if($('#montoSolici').val()!=0 && $('#montoSolici').val()!="" && $('#plazoID').val()!="" && esAutomatico== 'S'){
                                    calculoTasasAutomaticos();
                                }
                                if($('#montoSolici').val()!=0 && $('#montoSolici').val()!="" && $('#plazoID').val()!="" && esAutomatico== 'N'  && esNomina =='N'){
                                    consultaTasaCredito($('#montoSolici').asNumber(),'montoSolici');
                                }
                            }
                        } else {
                            if ($('#promotorID').val() != 0 && $('#prospectoID').val() != 0) {
                                mensajeSis("No Existe el Promotor.");
                            }
                            $('#nombrePromotor').val("");
                        }
                    });
                }
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
                if (plazo == '' || plazo=='0') {
                    $('#fechaVencimiento').val("");
                } else {
                    plazosCredServicio.consulta(tipoCon,PlazoBeanCon,{ async: false, callback: function(plazos) {
                                if (plazos != null) {
                                    $('#fechaVencimiento').val(plazos.fechaActual);
                                    if ($('#frecuenciaCap').val() != "U") {
                                        $('#numAmortizacion').val(plazos.numCuotas);
                                        if ($('#tipoPagoCapital').val() == 'C') {
                                            $('#numAmortInteres').val(plazos.numCuotas);
                                            NumCuotasInt = plazos.numCuotas; // se utiliza para saber cuando se agrega o quita una cuota
                                        } else {
                                                $('#numAmortizacion').val(plazos.numCuotas);

                                                if ($('#perIgual').val() == "S") {
                                                    $('#numAmortInteres').val(plazos.numCuotas);

                                                    NumCuotasInt = plazos.numCuotas; // se utiliza para saber cuando se agrega o quita una cuota

                                                } else {
                                                        consultaCuotasInteres('plazoID');
                                                }
                                        }
                                        NumCuotas = plazos.numCuotas; //se
                                        // utiliza para saber cuando se agrega o quita una cuota calculo de numero de dias
                                        calculaNodeDias(plazos.fechaActual);
                                    } else {
                                        $('#numAmortizacion').val("1");
                                        NumCuotas = 1; // se utiliza para saber cuando se agrega o quita una cuota
                                        calculaNodeDias(plazos.fechaActual);
                                    }
                                    fechaVencimientoInicial = plazos.fechaActual;
                                }
                            }});
                }
            }

            // funcion que calcula la comision por apertura e iva de credito de acuerdo al producto de credito seleccionado
            function consultaComisionAper() {
                var ProdCred = $('#productoCreditoID').val();
                var ProdCredBeanCon = {
                        'producCreditoID' : ProdCred
                };
                setTimeout("$('#cajaLista').hide();", 200);
                if (ProdCred != '' && !isNaN(ProdCred) && esTab) {
                    productosCreditoServicio.consulta(catTipoConsultaSolicitud.principal,ProdCredBeanCon,{ async: false, callback: function(prodCred) {
                                if (prodCred != null) {
                                    mostrarLabelTasaFactorMora(prodCred.tipCobComMorato);
                                    esTab = true;
                                    formaCobroComApe = prodCred.formaComApertura;
                                    // si es por porcentaje
                                    if (prodCred.montoComXapert > 0) {
                                        if (prodCred.tipoComXapert == 'P') {
                                            montoComApeBase = montoSolicitudBase * (prodCred.montoComXapert / 100);
                                            $('#montoComApert').val(montoComApeBase);
                                            $('#montoComApert').formatCurrency({
                                                positiveFormat : '%n',
                                                roundToDecimalPlace : 2
                                            });
                                        } else {
                                            // si es por monto
                                            if (prodCred.tipoComXapert == 'M') {
                                                montoComApeBase = prodCred.montoComXapert;
                                                $('#montoComApert').val(prodCred.montoComXapert);
                                                $('#montoComApert').formatCurrency({
                                                    positiveFormat : '%n',
                                                    roundToDecimalPlace : 2
                                                });

                                            }
                                        }
                                    }
                                    // ya teniendo el monto de la comision se calcula el iva
                                    consultaIVASucursal();
                                }
                              }
                            });
                }
            }



            // funcion que calcula el IVA de la comision por apertura de
            // credito de acuerdo a la sucursal del cliente
            function consultaIVASucursal() {
                var numSucursal = $('#sucursalCte').val();
                setTimeout("$('#cajaLista').hide();", 200);
                if (numSucursal != '' && !isNaN(numSucursal) && esTab) {
                    sucursalesServicio.consultaSucursal(catTipoConsultaSolicitud.principal, numSucursal, { async: false, callback: function(sucursal) {
                                if (sucursal != null) {
                                    var iva = sucursal.IVA;
                                    // si el cliente paga iva
                                    if ($('#pagaIVACte').val() == 'S') {
                                        montoIvaComApeBase = (montoComApeBase * iva);
                                        $('#ivaComApert').val(montoIvaComApeBase);
                                        $('#ivaComApert').formatCurrency({
                                            positiveFormat : '%n',
                                            roundToDecimalPlace : 2
                                        });

                                    } else {
                                        // si el cliente no paga iva
                                        if ($('#pagaIVACte').val() == 'N') {
                                            $('#ivaComApert').val("0.00");
                                            montoIvaComApeBase = 0;
                                        }
                                    }
                                    // si es forma de cobro por Financiamiento
                                    if (formaCobroComApe == "F") {
                                        montoComIvaSol = parseFloat(montoComApeBase)+ parseFloat(montoIvaComApeBase)+ parseFloat(montoSolicitudBase);
                                        if (montoSolicitudBase > 0) {
                                            $('#montoSolici').val(montoComIvaSol);
                                            $('#montoSolici').formatCurrency({
                                                positiveFormat : '%n',
                                                roundToDecimalPlace : 2
                                            });
                                        }
                                    }

                                    calculaNodeDias($('#fechaVencimiento').val());
                                }
                              }
                            });
                }
            }

            // consulta el destino de credito metodo que se llama cuando pierde el foco la cajita de Destinos de credito
            function consultaDestinoCredito(idControl) {
                $('#clasifiDestinCred').val('');

                var jqDestino = eval("'#" + idControl + "'");
                var DestCred = $(jqDestino).val();
                var DestCredBeanCon = {
                        'producCreditoID' : $('#productoCreditoID').val(),
                        'destinoCreID' : DestCred
                };
                setTimeout("$('#cajaLista').hide();", 200);
                if (DestCred != '' && !isNaN(DestCred) && esTab) {
                    destinosCredServicio.consulta(3, DestCredBeanCon,function(destinos) {
                                if (destinos != null) {
                                    $('#descripDestino').val(destinos.descripcion.toUpperCase());
                                    $('#descripDestinoFR').val(destinos.desCredFR);
                                    $('#descripDestinoFOMUR').val(destinos.desCredFOMUR);
                                    $('#destinCredFRID').val(destinos.destinCredFRID);
                                    $('#destinCredFOMURID').val(destinos.destinCredFOMURID);

                                    if (destinos.clasificacion == Comercial) {
                                        $('#clasificacionDestin1').attr("checked",true);
                                        $('#clasificacionDestin2').attr("checked",false);
                                        $('#clasificacionDestin3').attr("checked",false);
                                        $('#clasifiDestinCred').val('C');
                                    } else if (destinos.clasificacion == Consumo) {
                                        $('#clasificacionDestin1').attr("checked",false);
                                        $('#clasificacionDestin2').attr("checked",true);
                                        $('#clasificacionDestin3').attr("checked",false);
                                        $('#clasifiDestinCred').val('O');
                                    } else {
                                        $('#clasificacionDestin1').attr("checked",false);
                                        $('#clasificacionDestin2').attr("checked",false);
                                        $('#clasificacionDestin3').attr("checked",true);
                                        $('#clasifiDestinCred').val('H');
                                    }
                                } else {
                                    mensajeSis("No Existe el Destino de Crédito.");
                                    $('#destinoCreID').focus();
                                    $('#destinoCreID').select();
                                    $('#destinoCreID').val("");
                                    $('#descripDestino').val("");
                                }
                            });
                }
            }

            // -----------consulta el destino de credito metodo se llama cuando se consulta la solicitud ya que para consultar se consulta
            // el campo de Clasificacion que se encuentra en la tabla de solictud de credito. y no la de la tabla de DESTINOSCREDITO
            function consultaDestinoCreditoSolicitud(idControl) {
                $('#clasifiDestinCred').val('');

                var jqDestino = eval("'#" + idControl + "'");
                var DestCred = $(jqDestino).val();
                var DestCredBeanCon = {
                        'destinoCreID' : DestCred
                };
                setTimeout("$('#cajaLista').hide();", 200);
                if (DestCred != '' && !isNaN(DestCred) && esTab) {
                    destinosCredServicio.consulta(2,DestCredBeanCon,
                            function(destinos) {
                                if (destinos != null) {
                                    $('#descripDestino').val(destinos.descripcion.toUpperCase());

                                    $('#descripDestinoFR').val(destinos.desCredFR);
                                    $('#descripDestinoFOMUR')
                                    .val(destinos.desCredFOMUR);

                                    $('#destinCredFRID').val(destinos.destinCredFRID);
                                    $('#destinCredFOMURID').val(destinos.destinCredFOMURID);

                                } else {
                                    mensajeSis("No Existe el Destino de Crédito.");
                                    $('#destinoCreID').focus();
                                    $('#destinoCreID').select();
                                    $('#descripDestino').val("");
                                }
                            });
                }
            }




            // -----------------consulta el prospecto----------------------------
            function consultaProspecto(idControl) {

                var jqProspecto = eval("'#" + idControl + "'");
                var numProspecto = $(jqProspecto).val();
                setTimeout("$('#cajaLista').hide();", 200);

                var prospectoBeanCon = {
                        'prospectoID' : numProspecto
                };

                tipoConProspForanea = 2;

                if (numProspecto != '' && !isNaN(numProspecto) && esTab) {
                    prospectosServicio.consulta(tipoConProspForanea,prospectoBeanCon,function(prospectos) {
                        if (prospectos != null) {
                        	listaPersBloqBean = consultaListaPersBloq(numProspecto, esProspecto, 0, 0);
							consultaSPL = consultaPermiteOperaSPL(numProspecto,'LPB',esProspecto);
							if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
                            if (prospectos.cliente != '' && prospectos.cliente != null) {
                                $('#clienteID').val(prospectos.cliente);
                                $('#nombreProspecto').val("");
                                $('#prospectoID').val("");
                                habilitaControl('clienteID');
                            } else {
                                soloLecturaControl('clienteID');
                                $('#clienteID').val('');
                                $('#nombreCte').val('');
                                $('#nombreProspecto').val(prospectos.nombreCompleto);
                                if(editaSucursal=="N" || (editaSucursal=="S" && $('#solicitudCreditoID').val() == 0)){
                                    $('#sucursalCte').val(parametroBean.sucursal);
                                }
                                esTab = true;
                                consultaSucursal('sucursalCte');
                                consultaCalificacion('prospectoID');
                                $('#productoCreditoID').focus();
                            }

                            consultaRelacionCliente('prospectoID');

                            if ($('#grupo').val() == undefined) {
                                if ($.trim($('#productoCreditoID').val()) != "") {
                                    consultacicloCliente();
                                }
                            } else {
                                if ($.trim($('#productoCreditoID').val()) != ""&& $.trim($('#grupoID').asNumber()) > 0) {
                                    consultacicloCliente();
                                }
                            }
                        }else{
                        	mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
                        	 $('#prospectoID').val('');
                             $('#prospectoID').focus();
                             $('#nombrePromotor').val('');
                        }
                        } else {
                            if ($('#prospectoID').asNumber() != '0') {
                                mensajeSis("No Existe el Prospecto.");
                                $('#prospectoID').val('');
                                $('#prospectoID').focus();
                                $('#nombrePromotor').val('');
                            }

                        }
                    });

                }
            }

            function consultaCalificacion(idControl) {
                var jqProspectos = eval("'#" + idControl + "'");
                var numProspectos = $(jqProspectos).val();
                setTimeout("$('#cajaLista').hide();", 200);
                var prospectoBeanCons = {
                        'prospectoID' : numProspectos
                };
                var tipoConProspCal = 4;
                prospectosServicio.consulta(tipoConProspCal,prospectoBeanCons,function(calificacion) {
                    if (calificacion != null) {
                        $('#calificaCliente').val(calificacion.calificaProspectos);
                        if (calificacion.calificaProspectos == 'N') {
                            $('#calificaCredito').val('NO ASIGNADA');
                        }
                        if (calificacion.calificaProspectos == 'A') {
                            $('#calificaCredito').val('EXCELENTE');
                        }
                        if (calificacion.calificaProspectos == 'C') {
                            $('#calificaCredito').val('REGULAR');
                        }
                        if (calificacion.calificaProspectos == 'B') {
                            $('#calificaCredito').val('BUENA');
                        }

                    } else {
                        mensajeSis("El Prospecto no tiene Calificación Asignada.");
                        $(jqProspectos).val('');
                    }
                });
            }



            //  ----------------consulta la institucion de fondeo----------------
            function consultaInstitucionFondeo(idControl) {
                var jqInstituto = eval("'#" + idControl + "'");
                var numInstituto = $(jqInstituto).val();
                var instFondeoBeanCon = {
                        'institutFondID' : numInstituto
                };
                setTimeout("$('#cajaLista').hide();", 200);
                if (numInstituto != '' && !isNaN(numInstituto) && esTab) {
                    fondeoServicio.consulta(catTipoConsultaSolicitud.foranea,instFondeoBeanCon,function(instituto) {
                        if (instituto != null) {

                            var jqValida = eval("'#tipoFondeo2'");
                            if ($(jqValida).is(':checked')) {
                                $('#descripFondeo').val(instituto.nombreInstitFon);
                            }else{

                                $('#institutFondID').val('');
                                $('#descripFondeo').val('');
                            }

                        } else {
                            if ($('#institutFondID').asNumber() > '0') {
                                if ($('#tipoFondeo').val() == 'P') {
                                    $('#institutFondID').val('');
                                    $('#descripFondeo').val('');

                                } else {
                                    mensajeSis("No Existe la Institución.");
                                    $('#institutFondID').focus();
                                    $('#institutFondID').select();
                                    $('#institutFondID').val('');
                                    $('#descripFondeo').val('');
                                }
                            }
                        }
                    });
                }
            }

            // ---------- consulta linea de fondeo ---------------------------
            function consultaLineaFondeo(control) {
                var numLinea = $('#lineaFondeoID').val();
                setTimeout("$('#cajaLista').hide();", 200);
                if (numLinea != '' && numLinea != '0' && !isNaN(numLinea) && esTab) {
                    var lineaFondBeanCon = {
                            'lineaFondeoID' : $('#lineaFondeoID').val()
                    };

                    lineaFonServicio.consulta(catTipoConsultaSolicitud.principal, lineaFondBeanCon, function(lineaFond) {
                        if (lineaFond != null) {
                            var fechInicio = $('#fechaInicio').val();
                            var fechUltAmorti = $('#valorFecUltAmor').val();
                            $('#descripLineaFon').val(lineaFond.descripLinea);
                            $('#saldoLineaFon').val(lineaFond.saldoLinea);
                            $('#institutFondID').val(lineaFond.institutFondID);
                            $('#tasaPasiva').val(lineaFond.tasaPasiva);
                            $('#folioFondeo').val(lineaFond.folioFondeo);

                            var instFondeo = $('#institutFondID').asNumber();
                            $('#saldoLineaFon').formatCurrency({
                                positiveFormat : '%n',
                                roundToDecimalPlace : 2
                            });

                            consultaInstitucionFondeo('institutFondID');
                            if (instFondeo != lineaFond.institutFondID && instFondeo > '0') {
                                mensajeSis("La Linea de Fondeo no Corresponde con la Institución.");
                                $('#lineaFondeoID').val('');
                                $('#institutFondID').val(instFondeo);
                                $('#descripLineaFon').val('');
                                $('#saldoLineaFon').val('');
                                $('#tasaPasiva').val('');
                                $('#lineaFondeoID').focus();
                            }

                            if (fechInicio < lineaFond.fechInicLinea && instFondeo > '0') {
                                mensajeSis("La Fecha de Registro es Inferior a la de Inicio de la Linea de Fondeo.");
                                $('#lineaFondeoID').focus();
                            }
                            if (fechInicio > lineaFond.fechaFinLinea && instFondeo > '0') {
                                mensajeSis("La Fecha de Registro es Superior a la de Fin de la Linea de Fondeo.");
                                $('#lineaFondeoID').focus();
                            }
                            var numTran = $('#numTransacSim').val();
                            if (numTran != '0' || numTran != '' && instFondeo > '0') {
                                if (fechUltAmorti > lineaFond.fechaMaxVenci) {
                                    mensajeSis("La Fecha de Vencimiento de la Última Amortización es Superior a la Fecha de Vencimiento la Linea de Fondeo.");
                                    $('#lineaFondeoID').focus();
                                }
                            }
                            quitaFormatoControles('formaGenerica');
                            var saldoLinFon = $('#saldoLineaFon').val();
                            var montoCred = $('#montoSolici').val();
                            var saldo = parseFloat(saldoLinFon);
                            var monto = parseFloat(montoCred);
                            agregaFormatoControles('formaGenerica');
                            if ($('#tipoFondeo2').is(':checked')) {
                                if (monto > saldo && instFondeo > '0') {
                                    mensajeSis("La Línea de Fondeo no tiene Saldo Suficiente.");
                                }
                            }
                        } else {
                            var linea = $('#lineaFondeoID').asNumber();
                            var instit = $('#institutFondID').asNumber();
                            if (linea > '0' && instit > '0') {
                                mensajeSis("No Existe la Linea Fondeador.");
                                $('#lineaFondeoID').focus();
                                $('#lineaFondeoID').select();
                                $('#lineaFondeoID').val('');
                                $('#institutFondID').val('');
                                $('#descripLineaFon').val('');
                                $('#saldoLineaFon').val('');
                                $('#tasaPasiva').val('');
                                $('#lineaFondeoID').focus();
                            }
                        }
                    });
                }
            }

            // ---------------------valida la linea de fondeo al hacer el submit---------------------
            function validaLineaFondeo() {
                var numLinea = $('#lineaFondeoID').val();
                setTimeout("$('#cajaLista').hide();", 200);
                if (numLinea != '' && !isNaN(numLinea) && esTab) {
                    var lineaFondBeanCon = {
                            'lineaFondeoID' : $('#lineaFondeoID').val()
                    };

                    lineaFonServicio.consulta(catTipoConsultaSolicitud.principal,lineaFondBeanCon,
                            function(lineaFond) {
                                if (lineaFond != null) {
                                    dwr.util.setValues(lineaFond);
                                    var fechInicio = $('#fechaInicio').val();
                                    var fechUltAmorti = $('#valorFecUltAmor').val();
                                    var instFondeo = $('#institutFondID').asNumber();
                                    $('#descripLineaFon').val(lineaFond.descripLinea);
                                    $('#saldoLineaFon').val(lineaFond.saldoLinea);
                                    $('#saldoLineaFon').formatCurrency({
                                        positiveFormat : '%n',
                                        roundToDecimalPlace : 2
                                    });
                                    if (instFondeo != lineaFond.institutFondID && instFondeo != '0') {
                                        mensajeSis("La Linea de Fondeo no Corresponde con la Institución.");
                                        $('#lineaFondeoID').val('');
                                        $('#institutFondID').val(instFondeo);
                                        $('#descripLineaFon').val('');
                                        $('#saldoLineaFon').val('');
                                        $('#tasaPasiva').val('');
                                        $('#lineaFondeoID').focus();
                                        procede = 1;
                                    } else {
                                        if (fechInicio < lineaFond.fechInicLinea && instFondeo != '0') {
                                            mensajeSis("La Fecha de Registro es Inferior a la de Inicio de la Linea de Fondeo.");
                                            $('#lineaFondeoID').focus();
                                            procede = 1;
                                        } else {
                                            if (fechInicio > lineaFond.fechaFinLinea && instFondeo != '0') {
                                                mensajeSis("La Fecha de Registro es Superior a la de Fin de la Linea de Fondeo.");
                                                $('#lineaFondeoID').focus();
                                                procede = 1;
                                            } else {
                                                if ($('#numTransacSim').asNumber() != '0' || $('#numTransacSim').val() != '' && instFondeo != '0') {
                                                    if (fechUltAmorti > lineaFond.fechaMaxVenci) {
                                                        mensajeSis("La Fecha de Vencimiento de la Última Amortización es Superior a la Fecha de Vencimiento la Linea de Fondeo.");
                                                        $('#lineaFondeoID').focus();
                                                        procede = 1;
                                                    } else {
                                                        if ($('#tipoFondeo2').is(':checked')) {
                                                            if ($('#montoSolici').asNumber() > $('#saldoLineaFon').asNumber() && instFondeo != '0') {
                                                                mensajeSis("La Linea de Fondeo no tiene Saldo Suficiente.");
                                                                procede = 1;
                                                            } else {
                                                                procede = 0;
                                                            }
                                                        } else {
                                                            procede = 0;
                                                        }
                                                    }
                                                } else {
                                                    if ($('#tipoFondeo2').is(':checked')) {
                                                        if ($('#montoSolici').asNumber() > $('#saldoLineaFon').asNumber() && instFondeo != '0') {
                                                            mensajeSis("La Linea de Fondeo no tiene Saldo Suficiente.");
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
                                } else {
                                    var linea = $('#lineaFondeoID').val();
                                    var instit = $('#institutFondID').val();
                                    if (linea != '0' && instit != '0') {
                                        mensajeSis("No Existe la Linea Fondeador.");
                                        $('#lineaFondeoID').focus();
                                        $('#lineaFondeoID').select();
                                        $('#lineaFondeoID').val('');
                                        $('#institutFondID').val('');
                                        $('#descripLineaFon').val('');
                                        $('#saldoLineaFon').val('');
                                        $('#tasaPasiva').val('');
                                        $('#lineaFondeoID').focus();
                                        procede = 1;
                                    }
                                }
                            });
                }
                return procede;
            }

            // -------------valida el saldo de la linea de fondeo-----------------------
            function validaCreditoSaldoLineaFondeo() {
                quitaFormatoControles('formaGenerica');
                var saldoLinFon = $('#saldoLineaFon').val();
                var montoCred = $('#montoSolici').val();
                var saldo = parseFloat(saldoLinFon);
                var monto = parseFloat(montoCred);
                var instFondeo = $('#institutFondID').asNumber();
                agregaFormatoControles('formaGenerica');
                if ($('#tipoFondeo2').is(':checked')) {
                    if (monto > saldo && instFondeo != '0') {
                        mensajeSis("La Linea de Fondeo no tiene Saldo Suficiente");
                        $('#lineaFondeoID').focus();
                        procede = 1;
                    } else {
                        procede = 0;
                    }
                } else {
                    procede = 0;
                }
                return procede;
            }

            // habilita controles de la solicitud de credito para poder modificarla si es inactiva
            function habilitaControlesSolicitudInactiva() {
                habilitaControl('clienteID');
                habilitaControl('institFondeoID');
                habilitaControl('lineaFondeo');
                habilitaControl('productoCreditoID');
                habilitaControl('destinoCreID');
            }

            // valida vacios cuando se hace el submit de una solicitud
            function validaCamposRequeridos() {
                if ($.trim($('#grupoID').val()) != ""
                    && $('#grupoID').asNumber() != "0") {
                    if ($('#tipoIntegrante').val() == "") {
                        mensajeSis("Especificar tipo de Integrante.");
                        $('#tipoIntegrante').focus();
                        procede = 1;
                    } else {
                        if ($('#frecuenciaCap').val() == 'U') {
                            if ($('#tipoPagoCapital').val() != "I") {
                                mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
                                procede = 1;
                            } else {
                                procede = validaCamposRequeridosSolicitud();
                            }
                        } else {
                            procede = validaCamposRequeridosSolicitud();
                        }
                    }
                } else {
                    if ($('#frecuenciaCap').val() == 'U') {
                        if ($('#tipoPagoCapital').val() != "I") {
                            mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
                            procede = 1;
                        } else {
                            procede = validaCamposRequeridosSolicitud();
                        }
                    } else {
                        procede = validaCamposRequeridosSolicitud();
                    }
                }
                return procede;
            }

            // valida vacios cuando se hace el submit de una solicitud
            function validaCamposRequeridosSolicitud() {
                // valida que la fecha de vencimiento no este vacia
                if ($('#fechaVencimiento').val() == "") {
                    mensajeSis("La Fecha de Vencimiento Está Vací­a.");
                    procede = 1;
                } else {
                    if ($('#numTransacSim').asNumber() == '0' || $('#numTransacSim').val() == '') {
                        mensajeSis("Se Requiere Simular las Amortizaciones.");
                        procede = 1;
                    } else {
                        if ($('#frecuenciaCap').val() == '0' || $('#frecuenciaCap').val() == "") {
                            mensajeSis("La Frecuencia de Capital Está Vacía.");
                            esTab = true;
                            $('#frecuenciaCap').focus();
                            procede = 1;
                        } else {
                            if ($('#tipoPagoCapital').val() == '0') {
                                mensajeSis("El Tipo de Pago Está Vacío, Se Reiniciarán los Valores Originales de la Solicitud.");
                                esTab = true;
                                consultaLineaFondeo('lineaFondeoID');
                                procede = 1;
                            } else {
                                if ($('#frecuenciaCap').val().trim() == frecuenciaMensual
                                        && $('#diaPagoCapital2').is(':checked') && $('#diaMesCapital').asNumber() == 0) {
                                    mensajeSis("Especificar Día Mes Capital.");
                                    $('#diaMesCapital').focus();
                                    procede = 1;
                                } else {
                                    if (($('#frecuenciaInt').val() == '0' || $('#frecuenciaInt').val()) == "" && $('#tipoPagoCapital').val() != "C") {
                                        mensajeSis("Especifique Frecuencia de Interés.");
                                        $('#frecuenciaInt').focus();
                                        procede = 1;
                                    } else {
                                        if ($('#numAmortInteres').asNumber() == '0') {
                                            if ($('#calendIrregular').val() == "S") {
                                                mensajeSis("Es Necesario Calcular de nuevo las Amortizaciones.");
                                                $('#calcular').focus();
                                                procede = 1;
                                            } else {
                                                mensajeSis("Numero de Cuotas de Interés Vacio.");
                                                $('#numAmortInteres').focus();
                                                procede = 1;
                                            }
                                        } else {
                                            if ($('#frecuenciaInt').val().trim() == frecuenciaMensual
                                                    && $('#diaPagoInteres2').is(':checked') && $('#diaMesInteres').asNumber() == 0 && $('#tipoPagoCapital').val() != "C") {
                                                mensajeSis("Especificar Día Mes Interés.");
                                                $('#diaMesInteres').focus();
                                                procede = 1;
                                            } else {
                                                if ($('#productoCreditoID').asNumber() == '0' || $('#productoCreditoID').val() == '') {
                                                    mensajeSis("El Producto de Crédito Está Vacío.");
                                                    procede = 1;
                                                } else {
                                                    if ($('#destinoCreID').asNumber() == '0' || $('#destinoCreID').val() == '') {
                                                        mensajeSis("El Destino de Crédito Está Vacío.");
                                                        $('#destinoCreID').focus();
                                                        procede = 1;
                                                    } else {
                                                        if ($('#tipoDispersion').val() == '0') {
                                                            mensajeSis("El Tipo de Dispersion Está Vacío.");
                                                            $('#tipoDispersion').focus();
                                                            procede = 1;
                                                        } else {
                                                            if ($('#tasaFija').asNumber() > 0) {
                                                                procede = validaCreditoSaldoLineaFondeo();
                                                                if (procede == 0) {
                                                                    procede = validaLineaFondeo();
                                                                }
                                                            } else {
                                                                mensajeSis("La "+VarTasaFijaoBase+" no es Válida.");
                                                                $('#tasaFija').focus();
                                                                procede = 1;
                                                            }
                                                        }
                                                    }
                                                    //valida si el producto de credito es de nomina
                                                    if($('#institNominaID').is(":visible")){
                                                        if($('#institucionNominaID').asNumber()==0){
                                                                mensajeSis("La Empresa de Nómina esta Vacía.");
                                                                $('#institucionNominaID').focus();
                                                                procede=1;
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

            // habilita los controles cuando una solicitud de credito  esta autorizada
            function habilitaInputsAutorizada() {
                habilitaControl('productoCreditoID');
                habilitaControl('destinoCreID');
                habilitaControl('proyecto');
                habilitaControl('montoSolici');
                habilitaControl('plazoID');
                habilitaControl('tipoDispersion');
                habilitaControl('lineaFondeoID');
            }

            // validaciones del monto solicitado
            function validaLimiteMontoSolicitado() {
                // se valida que el monto solicitado no sea mayor a lo parametrizado
                if ($('#montoSolici').asNumber() > montoMaxSolicitud) {
                    continuar = 0;
                    $('#montoSolici').val(montoMaxSolicitud);
                    $('#montoSolici').formatCurrency({
                        positiveFormat : '%n',
                        negativeFormat : '%n',
                        roundToDecimalPlace : 2
                    });
                    mensajeSis('El Monto Solicitado No debe ser Mayor a ' + $('#montoSolici').val());
                    $('#montoSolici').val('0.00');
                    montoSolicitudBase = 0.00;
                    $('#montoSolici').focus();

                } else {
                    // se valida que el monto no se sea menos a lo parametrizado
                    if ($('#montoSolici').asNumber() < montoMinSolicitud && $('#montoSolici').val() != "") {
                        continuar = 0;
                        $('#montoSolici').val(montoMinSolicitud);
                        $('#montoSolici').formatCurrency({
                            positiveFormat : '%n',
                            negativeFormat : '%n',
                            roundToDecimalPlace : 2
                        });
                        mensajeSis('El Monto Solicitado No debe ser Menor a ' + $('#montoSolici').val());
                        $('#montoSolici').val('0.00');
                        $('#montoSolici').focus();
                        montoSolicitudBase = 0.00;
                    } else {
                        continuar = 1;
                    }
                }
                return continuar;
            }

            // ------------------ valida que la cuenta CLABE este bien formada ---------------
            function validaSpei(valor, cuentaClabe) {
                agregaFormatoNumMaximo('formaGenerica');
                var numero = document.getElementById(cuentaClabe).value;
                var tipoDisper = $('#tipoDispersion').val();
                if (tipoDisper == 'S' && numero != '') {
                    if (isNaN(numero)) {
                        mensajeSis("Ingresar Sólo Números.");
                        $('#cuentaCLABE').select();
                    }
                    if (numero.length == 18 && numero != '') {
                        if (!isNaN(numero)) {
                            var institucion = numero.substr(0, 3);
                            var tipoConsulta = 3;
                            var DispersionBean = {
                                    'institucionID' : institucion
                            };
                            institucionesServicio.consultaInstitucion( tipoConsulta, DispersionBean,
                                    function(data) {
                                        if (data == null) {
                                            mensajeSis('La Cuenta Clabe No Coincide con Ninguna Institución Financiera Registrada.');
                                            document.getElementById(cuentaClabe).focus();
                                        }
                                    });
                        }
                    } else {
                        mensajeSis("La Cuenta Clable debe de Tener 18 Caracteres.");
                        document.getElementById(cuentaClabe).focus();
                    }
                }
                return false;
            }


            // -----------consulta el parentesco del beneficiario con el cliente---------------
            function consultaParentesco(idControl) {
                var jqParentesco = eval("'#" + idControl + "'");
                var numParentesco = $(jqParentesco).val();
                var tipConPrincipal = 1;
                setTimeout("$('#cajaLista').hide();", 200);
                var ParentescoBean = {
                        'parentescoID' : numParentesco
                };
                if (numParentesco != '' && !isNaN(numParentesco)) {
                    parentescosServicio.consultaParentesco(tipConPrincipal, ParentescoBean, function(parentesco) {
                                if (parentesco != null) {
                                    $('#parentesco').val(parentesco.descripcion);

                                } else {
                                    mensajeSis("No Existe el Parentesco.");
                                    $(jqParentesco).focus();
                                    $(jqParentesco).val("");
                                }
                            });
                }
            }



            function validaSiseguroVida(segurodeVida) {
                // si lleva seguro de vida
                if (segurodeVida == 'S') {
                    $('#trMontoSeguroVida').show();
                    $('#trBeneficiario').show();
                    $('#trParentesco').show();
                    $('#reqSeguroVidaSi').attr("checked", true);
                    $('#reqSeguroVidaNo').attr("checked", false);
                    $('#reqSeguroVida').val("S");
                } else {
                    // no lleva seguro de vida
                    if (segurodeVida == 'N') {
                        $('#trMontoSeguroVida').hide();
                        $('#trBeneficiario').hide();
                        $('#trParentesco').hide();
                        $('#tipoPagoSelect').hide();
                        $('#tipoPagoSelect2').hide();
                        $('#reqSeguroVidaSi').attr("checked", false);
                        $('#reqSeguroVidaNo').attr("checked", true);
                        $('#reqSeguroVida').val("N");
                    }
                }
            }


            // FUNCION PARA CALCULAR EL MONTO DE LA GARANTÍA LÍQUIDA DEL CRÉDITO
            function calculaMontoGarantiaLiquida(garanLiquida) {
                // calculo el monto de garantia liquida
                calculosyOperacionesDosDecimalesMultiplicacion($('#montoSolici').val(), (garanLiquida / 100));
            }

            // FUNCION PARA CALCULAR EL MONTO DE LA GARANTÍA FOGAFI DEL CRÉDITO
            function calculaMontoGarantiaFinanciada(garanLiquida) {
                // calculo el monto de garantia liquida
                calculosyOperacionesDosDecimalesMultiplicacionFOGAFI($('#montoSolici').val(), (garanLiquida / 100));
            }

            // CONSULTA DEL BENEFICIARIO DEL SEGURO DE VIDA DEL CRÉDITO
            function consultaBeneficiario(idControl) {
                var jqCred = eval("'#" + idControl + "'");
                var Credito = $(jqCred).val();
                var SeguroVidaBean = {
                        'solicitudCreditoID' : Credito
                };
                setTimeout("$('#cajaLista').hide();", 200);
                if (Credito != '' && !isNaN(Credito) && esTab) {
                    seguroVidaServicio.consulta(catTipoConsultaSeguroVida.foranea,SeguroVidaBean,
                            function(seguro) {
                                if (seguro != null) {
                                    $('#seguroVidaID').val(seguro.seguroVidaID);
                                    $('#direccionBen').val(seguro.direccionBeneficiario);
                                    $('#beneficiario')
                                    .val(seguro.beneficiario);
                                    $('#parentescoID').val(seguro.relacionBeneficiario);
                                    $('#parentesco').val(seguro.descriRelacionBeneficiario);
                                } else {
                                    $('#direccionBen').val('');
                                    $('#beneficiario').val('');
                                    $('#parentescoID').val('');
                                    $('#parentesco').val('');
                                }
                            });
                }
            }

            //FUNCION PARA OBTENER EL PORCENTAJE DE GARANTIA LIQUIDA  PARA PRODUCTO DE CREDITO
            function consultaPorcentajeGarantiaLiquida(controlID) {

                var jqControl = eval("'#" + controlID + "'");
                var tipoCon = 5;
                var producCreditoID = $("#productoCreditoID").val();
                var productoCreditoBean = {
                        'producCreditoID' : producCreditoID
                };

                // verifica que el producto de credito en pantalla requiere garantia liquida
                productosCreditoServicio.consulta(tipoCon,productoCreditoBean, { async: false, callback:function(respuesta) {
                    if (respuesta != null) {
                        if (respuesta.requiereGarantia == 'S') {
                            var clienteID = 0;
                            var calificaCli = $('#calificaCliente').val();
                            var monto = $("#montoSolici").asNumber();

                            // verifica que los datos necesario para la consulta NO esten vacios.
                            if (parseInt(producCreditoID) > 0 && calificaCli != '' && parseFloat(monto) > 0) {
                                tipoCon = 1;
                                var bean = {
                                        'producCreditoID' : producCreditoID,
                                        'clienteID' : clienteID,
                                        'calificacion' : calificaCli,
                                        'montoSolici' : monto
                                };

                                // obtiene el porcentaje de garantia liquida
                                esquemaGarantiaLiqServicio.consulta(tipoCon,bean,{ async: false, callback: function(respuesta) {
                                    if (respuesta != null) {

                                        $('#porcGarLiq').val(respuesta.porcentaje);
                                        $('#porcentaje').val(respuesta.porcentaje);

                                        // se ejecuta funcion que valida el monto indicado para la solicitud de credito
                                        validaMontoSolicitudCredito();

                                    } else {
                                        mensajeSis("No existe un Esquema de Garantía Líquida para el Producto de Crédito, Calificación del "+$('#alertSocio').val()+", Plazo y Monto indicado.");
                                        $(jqControl).focus();
                                        $(jqControl).select();
                                        $('#porcGarLiq').val('0.00');
                                        $('#porcentaje').val('0.00');
                                        $('#aporteCliente').val('0.00');
                                    }
                                  }
                                });
                            }
                            else {
                                $('#porcGarLiq').val('0.00');
                                $('#porcentaje').val('0.00');
                                $('#aporteCliente').val('0.00');
                                validaMontoSolicitudCredito();
                            }
                        } else {
                            $('#porcGarLiq').val('0.00');
                            $('#porcentaje').val('0.00');
                            $('#aporteCliente').val('0.00');
                            validaMontoSolicitudCredito();
                        }
                    } // termina comparacion si es null si el producto de credito no requiere garantia liquida
                    else {
                        $('#porcGarLiq').val('0.00');
                        $('#porcentaje').val('0.00');
                        $('#aporteCliente').val('0.00');
                    }
                  }
                });

            }


            //FUNCION PARA OBTENER EL PORCENTAJE DE GARANTIA FINANCIADA  PARA PRODUCTO DE CREDITO
            function consultaPorcentajeFOGAFI(controlID) {
                var jqControl = eval("'#" + controlID + "'");
                var tipoCon = 5;
                var producCreditoID = $("#productoCreditoID").val();
                var productoCreditoBean = {
                        'producCreditoID' : producCreditoID
                };


                // verifica que el producto de credito en pantalla requiere garantia liquida
                productosCreditoServicio.consulta(tipoCon,productoCreditoBean, { async: false, callback:function(respuesta) {
                    if (respuesta != null) {

                        if (respuesta.garantiaFOGAFI == 'S') {
                            $('#garantiaFinanciada').show();

                            var clienteID = 0;
                            var calificaCli = $('#calificaCliente').val();
                            var monto = $("#montoSolici").asNumber();
                            var modalidadFinanciada = respuesta.modalidadFOGAFI;

                            if(respuesta.modalidadFOGAFI != ""){
                                $('#modalidadFOGAFI').val(respuesta.modalidadFOGAFI);

                            }
                            else
                            {
                                $('#modalidadFOGAFI').val("");
                            }



                            // verifica que los datos necesario para la consulta NO esten vacios.
                            if (parseInt(producCreditoID) > 0 && calificaCli != '' && parseFloat(monto) > 0) {
                                tipoCon = 2;
                                var bean = {
                                        'producCreditoID' : producCreditoID,
                                        'clienteID' : clienteID,
                                        'calificacion' : calificaCli,
                                        'montoSolici' : monto
                                };

                                // obtiene el porcentaje de garantia liquida
                                esquemaGarantiaLiqServicio.consulta(tipoCon,bean,{ async: false, callback: function(respuesta) {
                                    if (respuesta != null) {
                                        $('#porcentajeFOGAFI').val(respuesta.porcentajeFOGAFI);
                                        $('#valorPorcFOGAFI').val(respuesta.porcentajeFOGAFI);

                                        // se ejecuta funcion que valida el monto indicado para la solicitud de credito
                                        validaMontoSolicitudCredito();

                                    } else {
                                        mensajeSis("No existe un Esquema de Garantía FOGAFI para el Producto de Crédito, Calificación del "+$('#alertSocio').val()+", Plazo y Monto indicado.");
                                        $(jqControl).focus();
                                        $(jqControl).select();
                                        $('#porcentajeFOGAFI').val('0.00');
                                        $('#valorPorcFOGAFI').val('0.00');
                                        $('#montoFOGAFI').val('0.00');
                                        $('#modalidadFOGAFI').val('');
                                    }
                                  }
                                });
                            }
                            else {
                                $('#porcentajeFOGAFI').val('0.00');
                                $('#valorPorcFOGAFI').val('0.00');
                                $('#montoFOGAFI').val('0.00');
                                $('#modalidadFOGAFI').val('');
                                validaMontoSolicitudCredito();
                            }
                        } else {
                            $('#porcentajeFOGAFI').val('0.00');
                            $('#valorPorcFOGAFI').val('0.00');
                            $('#montoFOGAFI').val('0.00');
                            $('#modalidadFOGAFI').val('');
                            $('#garantiaFinanciada').hide();
                            validaMontoSolicitudCredito();
                        }
                    } // termina comparacion si es null si el producto de credito no requiere garantia liquida
                    else {
                        $('#porcentajeFOGAFI').val('0.00');
                        $('#valorPorcFOGAFI').val('0.00');
                        $('#montoFOGAFI').val('0.00');
                        $('#modalidadFOGAFI').val('');
                    }
                  }
                });

            }


            function consultacicloCliente() {
                var CicloCreditoBean = {
                        'clienteID' : $('#clienteID').val(),
                        'prospectoID' : $('#prospectoID').val(),
                        'productoCreditoID' : $('#productoCreditoID').val(),
                        'grupoID' : $('#grupoID').val()
                };
                var solicitud = $('#solicitudCreditoID').val();
                var grupoInteGruBeanCon = {
                        'solicitudCreditoID' : solicitud
                };
                var listaIntegrante = 3;

                setTimeout("$('#cajaLista').hide();", 200);
                solicitudCredServicio.consultaCiclo(CicloCreditoBean, { async: false, callback:function(cicloCreditoCte) {
                            if (cicloCreditoCte != null) {
                                $('#numCreditos').val(cicloCreditoCte.cicloCliente);
                                $('#cicloClienteGrupal').val(cicloCreditoCte.cicloPondGrupo);
                                cicloCliente = cicloCreditoCte.cicloCliente;
                                if (solicitud != '' && !isNaN(solicitud)) {
                                    integraGruposServicio.consulta(listaIntegrante,grupoInteGruBeanCon, function(integrantes) {
                                        if (integrantes != null) {
                                            $('#lbcicloscaja').show();
                                            $('#lbciclos').show();
                                        }
                                        else{
                                            $('#lbcicloscaja').hide();
                                            $('#lbciclos').hide();
                                        }
                                    });
                                }

                            } else {
                                mensajeSis('No hay Ciclo para el '+$('#alertSocio').val()+'.');
                            }
                        }});

            }

            // funcion para llenar valores default de la pantalla
            function iniciaPantallaSolicitudGrupal() {
                if ($('#grupo').val() != undefined  && $('#solicitudCreditoID').asNumber() == '0') {
                    $('#grupoID').val($('#grupo').val());
                    $('#nombreGr').val($('#nombreGrupo').val());
                    grupoIDBase = $('#grupo').val();
                }
            }

            /* FUNCION PARA HACER OPERACION DE MULTIPLICACION Y OBTENER EL RESULTADO REDONDEADO CON DOS DECIMALES */
            function calculosyOperacionesDosDecimalesMultiplicacion(
                    valor1, valor2) {
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
                        $('#aporteCliente').val(Math.round(valoresResultado.resultadoCuatroDecimales*100)/100); // IALDANA T_15213 Se agrega redondeo
                        $('#montoSolici').formatCurrency({
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


    /* FUNCION PARA HACER OPERACION DE MULTIPLICACION Y OBTENER EL RESULTADO REDONDEADO CON DOS DECIMALES */
    function calculosyOperacionesDosDecimalesMultiplicacionFOGAFI(
            valor1, valor2) {
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
                $('#montoFOGAFI').val(valoresResultado.resultadoCuatroDecimales);
                $('#montoSolici').formatCurrency({
                    positiveFormat : '%n',
                    negativeFormat : '%n',
                    roundToDecimalPlace : 2
                });
                agregaFormatoControles('formaGenerica');
            } else {
                mensajeSis('Indique el monto de nuevo.');
                $('#montoFOGAFI').val("0.00");
            }
        });
    }


    // función para consultar si el cliente ya tiene huella digital registrada
    function consultaHuellaCliente(){
        var numCliente=$('#clienteID').val();
        if(numCliente != '' && !isNaN(numCliente )){
            var clienteIDBean = {
                'personaID':$('#clienteID').val()
                };
            huellaDigitalServicio.consulta(1,clienteIDBean,function(cliente) {
                if (cliente==null){
                    var huella=parametroBean.funcionHuella;
                    if(huella =="S"){
                    mensajeSis("El "+$('#alertSocio').val()+" no tiene Huella Registrada.\nFavor de Verificar.");
                    $('#clienteID').focus();
                    }
                }
            });
        }
    }

    //Consulta para ver si se requiere que el cliente tenga registrada su huella Digital
    function validaEmpresaID() {
        var numEmpresaID = 1;
        var tipoCon = 1;
        var ParametrosSisBean = {
                'empresaID' :numEmpresaID
        };
        parametrosSisServicio.consulta(tipoCon,ParametrosSisBean,function(parametrosSisBean) {
            if (parametrosSisBean != null) {
                if(parametrosSisBean.reqhuellaProductos !=null){
                        huellaProductos=parametrosSisBean.reqhuellaProductos;
                }else{
                    huellaProductos="N";
                }
            }
        });
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


    consultaCambiaPromotor();
    // CAMBIAR PROMOTOR PARAMETROSSIS
    function consultaCambiaPromotor() {
        if (cambiarPromotor == 'N'){
            soloLecturaControl('promotorID');
        }
        else{
            if (cambiarPromotor == 'S'){
                if($('#estatus').val() == 'I'){
                    habilitaControl('promotorID');
                }else{
                        soloLecturaControl('promotorID');
                      }
                }
            }

    }


}); //FIN READY

/* funcion para consultar empleado de nómina del cliente */
function consultaEmpleado(idControl) {
    var jqCliente = eval("'#" + idControl + "'");
    var numCliente = $(jqCliente).val();
    var tipConPrincipal = 1;
    setTimeout("$('#cajaLista').hide();", 200);
    if(numCliente != '' && !isNaN(numCliente) ){
        clienteServicio.consulta(tipConPrincipal,numCliente.trim(),function(cliente) {
            if(cliente!=null){
                $('#folioCtrl').val(cliente.noEmpleado);
            }
        });
    }
}


/* funcion para consultar la direccion oficial*/
function consultaEmpleadoProspecto(idControl) {
    var jqProspecto = eval("'#" + idControl + "'");
    var numProspecto = $(jqProspecto).val();
    var tipConPrincipal = 1;
    var prospectoBean ={
             'prospectoID' : numProspecto,
             'clienteID' : 0
        };
    setTimeout("$('#cajaLista').hide();", 200);
    if(numProspecto != '' && !isNaN(numProspecto) ){
        prospectosServicio.consulta(tipConPrincipal,prospectoBean,function(prospecto) {
            if(prospecto!=null){
                $('#folioCtrl').val(prospecto.noEmpleado);
            }
        });
    }
}

function verificarvacios() {
    // quitaFormatoControles('gridDetalle');
    var numAmortizacion = $('input[name=renglon]').length;
    $('#montosCapital').val("");

    for ( var i = 1; i <= numAmortizacion; i++) {
        // controlQuitaFormatoMoneda("capital"+i+"");
        var valCapital = document.getElementById("capital" + i + "").value;
        if (valCapital == " ") {
            document.getElementById("capital" + i + "").focus();
            $("capital" + i).addClass("error");
            return 1;
        } else {
            return 2;
        }
    }
}

function simuladorPagosLibresTasaVar(numTransac, cuotas) {
    var mandar = crearMontosCapital(numTransac);
    $('#numAmortizacion').val(cuotas);
    $('#numTransacSim').val(numTransac);
    var jqFechaVen = eval("'#fechaVencim" + cuotas + "'");
    if ($('#ajFecUlAmoVen2').is(':checked')) {
        $('#fechaVencimiento').val($(jqFechaVen).val());
    }
    if (mandar == 2) {
        var params = {};

        quitaFormatoControles('formaGenerica');

        if ($('#calcInteresID').val() == 1) {
            switch ($('#tipoPagoCapital').val()) {
            case "C": // SI ES CRECIENTE
                tipoLista = 1;
                break;
            case "I": // SI ES IGUAL
                tipoLista = 2;
                break;
            case "L": // SI ES LIBRE
                tipoLista = 3;
                break;
            default:
                tipoLista = 1;
            break;
            }
        } else {
            switch ($('#tipoPagoCapital').val()) {
            case "I": // SI ES IGUAL
                tipoLista = 2;
                break;
            case "L": // SI ES LIBRE
                tipoLista = 5;
                break;
            default:
                tipoLista = 2;
            break;
            }
        }

        params['tipoLista'] = tipoLista;
        params['montoCredito'] = $('#montoSolici').val();
        params['producCreditoID'] = $('#productoCreditoID').val();
        params['clienteID'] = $('#clienteID').val();

        params['empresaID'] = parametroBean.empresaID;
        params['usuario'] = parametroBean.numeroUsuario;
        params['fecha'] = parametroBean.fechaSucursal;
        params['direccionIP'] = parametroBean.IPsesion;
        params['sucursal'] = $("#sucursalID").val();
        params['numTransaccion'] = $('#numTransacSim').val();
        params['numTransacSim'] = $('#numTransacSim').val();

        params['montosCapital'] = $('#montosCapital').val();
        params['cobraSeguroCuota']  = $('#cobraSeguroCuota option:selected').val();
        params['cobraIVASeguroCuota']   = $('#cobraIVASeguroCuota option:selected').val();
        params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
        params['plazoID']           = $('#plazoID').val();
        params['tipoOpera']         = 1;
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
                $("#ExportarExcel").css({display:"block"});
                $("#imprimirRep").css({display:"block"});
            } else {
                $('#contenedorSimulador').html("");
                $('#contenedorSimulador').show();
            }
            /****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
            if(numeroError!=0){
                $('#contenedorForma').unblock({fadeOut: 0,timeout:0});
                mensajeSisError(numeroError,mensajeTransaccion);
            }
            /**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
        });
    }

}

function mostrarGridLibres() { // BORRAR
    var data;

    data = '<input type="hidden" value="0" name="numeroDetalle" id="numeroDetalle" />'
        + '<fieldset class="ui-widget ui-widget-content ui-corner-all">'
        + '<legend>Simulador de Amortizaciones</legend>'
        + '<form id="gridDetalle" name="gridDetalle">'
        + '<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">'
        + '<tr>'
        + '<td class="label" align="center"><label for="lblNumero">N&uacute;mero</label></td>'
        + '<td class="label" align="center"><label for="lblFecIni">Fecha Inicio</label></td>'
        + '<td class="label" align="center"><label for="lblFecFin">Fecha Vencimiento</label> </td>  '
        + '<td class="label" align="center"><label for="lblFecPag">Fecha Pago</label></td>'
        + '<td class="label" align="center"><label for="lblCapital">Capital</label></td> '
        + '<td class="label" align="center"><label for="lblDescripcion">Inter&eacute;s</label></td> '
        + '<td class="label" align="center"><label for="lblCargos">Iva Inter&eacute;s</label></td> '
        + '<td class="label" align="center"><label for="lblTotalPag">Total Pago</label></td> '
        + '<td class="label" align="center"><label for="lblSaldoCap">Saldo Capital</label></td> '
        + '</tr>' + '</table>' + '</form>' + '</fieldset>';

    $('#contenedorSimuladorLibre').html(data);
    $('#contenedorSimuladorLibre').show();
    $('#contenedorSimulador').html("");
    $('#contenedorSimulador').hide();
    agregaFormatoControles('gridDetalle');
    mostrarGridLibres2();
}

//funcion que consulta la fecha de vencimiento en base a ls cuotas
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
        $('#fechaVencimiento').val("");
    } else {
        plazosCredServicio.consulta(tipoCon, PlazoBeanCon, function(plazos) {
            if (plazos != null) {
                $('#fechaVencimiento').val(plazos.fechaActual);
                if (requiereSeg == 'S'
                    && $.trim($('#fechaVencimiento').val()) != ""
                        && $.trim($('#fechaVencimiento').val()) != null) {
                    calculaNodeDias(plazos.fechaActual);
                }
            }
        });
    }
}

//calcula el numero de dias del plazo seleccionado
function calculaNodeDias(varfechaVencimiento) {
    if ($('#fechaVencimiento').val() != '') {
        var tipoCons = 1;
        var PlazoBeanCon = {
                'plazoID' : $('#plazoID').val()
        };

            plazosCredServicio.consulta(tipoCons, PlazoBeanCon, { async: false, callback: function(plazos) {
            if (plazos != null) {
                $('#noDias').val(plazos.dias);// número de dias parametrizado en el plazo

                if (requiereSeg == 'S') {
                    calculoCostoSeguro(); // calcula el seguro de vida

                }

                if(parseInt($("#periodicidadCap").val()) > 0){
                    if(parseInt($("#periodicidadCap").val()) <= parseInt($('#noDias').val())){

                        if ($('#frecuenciaCap').val() == "U") {

                            $('#periodicidadCap').val(plazos.dias);
                            if ($("#tipoPagoCapital").val()=='C' || $('#perIgual').val() == 'S') {
                                $('#periodicidadInt').val(plazos.dias);
                            }
                        }
                    }else{
                        mensajeSis("La Periodicidad de Capital es Mayor al Número de Días del Plazo.");
                        $("#frecuenciaCap").focus();
                    }
                }

            }
          }
        });
    }
}



//FUNCION PARA CALCULAR EL MONTO DEL SEGURO DE VIDA DEPENDIENDO DE LA CANTIDAD DEL MONTO DE CRÉDITO
function calculoCostoSeguro() {
    agregaFormatoControles('formaGenerica');

    if(modalidad == 'U'){

        numeroDias = $('#noDias').val();
        var pagoseguro = $('#forCobroSegVida').val();

        var costoSeguroVida = 0;
        var factRiesgo = $('#factorRiesgoSeguro').asNumber();
        var SeguroVidadosDecimales = 0;
        var SeguroDescVidadosDecimales = 0;
        var montoDescuento = 0;
        var descSeguro = (descuentoSeg / 100);

        costoSeguroVida = (factRiesgo / 7) * montoSolicitudBase * numeroDias;
        montoDescuento = costoSeguroVida-(costoSeguroVida * descSeguro);

        SeguroVidadosDecimales = montoDescuento;
        SeguroDescVidadosDecimales = costoSeguroVida;

        montoComIvaSol= montoSolicitudBase;

        $('#montoSeguroVida').val(SeguroVidadosDecimales.toFixed(2));
        $('#montoSegOriginal').val(SeguroDescVidadosDecimales);
        $('#descuentoSeguro').val(descuentoSeg);

        // SI EL TIPO DE PAGO DEL SEGURO Es POR  FINANCIAMIENTO SE LE SUMA AL MONTO DE CREDITO EL SEGURO DE VIDA
        if (pagoseguro == 'F' && montoSolicitudBase>0) {
            montoComIvaSol += parseFloat(SeguroVidadosDecimales);
        }

        if($('#formaComApertura').val()=='FINANCIAMIENTO' && montoSolicitudBase>0 ){
            montoComIvaSol = Number(montoComIvaSol) + (parseFloat(montoComApeBase) + parseFloat(montoIvaComApeBase));
        }

        if(montoSolicitudBase >0 && Number(montoComIvaSol).toFixed(2) != $('#montoSolici').asNumber() ){
        $('#montoSolici').val(Number(montoComIvaSol).toFixed(2));
        }


    }else{
        calculoCostoSeguroTipoPago();
    }

    agregaFormatoControles('formaGenerica');

}



function calculoCostoSeguroTipoPago() {

        agregaFormatoControles('formaGenerica');

        if(modalidad == 'T'){
        var pagoseguroTip = $('#forCobroSegVida').val();
        var esqSeguVida = esquemaSeguro;

        consultaEsquemaSeguroVida(esqSeguVida,pagoseguroTip);

        if(factorRS == 0 && $('#ClienteID').val() == ""){
            $('#montoSeguroVida').val("0.00");
            $('#tipPago').val("");

            }

        numeroDias = $('#noDias').val();

        var pagoseguro = $('#forCobroSegVida').val();
        var costoSeguroVida = 0;

        $('#factorRiesgoSeguro').val(factorRS);
        var factorRiesgo = $('#factorRiesgoSeguro').val();
        var factRiesgo = $('#factorRiesgoSeguro').asNumber();
        var montoDescuento = 0;
        var descSeguro = (porcentajeDesc / 100) ;

        var SeguroVidadosDecimales = 0;
        var SeguroDescVidadosDecimales = 0;

        costoSeguroVida = (factRiesgo / 7) * montoSolicitudBase * numeroDias;
        montoDescuento = costoSeguroVida-(costoSeguroVida * descSeguro);

        SeguroVidadosDecimales = montoDescuento;
        SeguroDescVidadosDecimales = costoSeguroVida;


        montoComIvaSol= montoSolicitudBase;

        $('#montoSeguroVida').val(montoDescuento.toFixed(2));
        $('#montoSegOriginal').val(SeguroDescVidadosDecimales);
        $('#descuentoSeguro').val(porcentajeDesc);

    // Si el tipo de pago de seguro es por Financiamiento se le suma al monto solicitado
        if (pagoseguro == 'F' && montoSolicitudBase>0) {
            montoComIvaSol =  parseFloat(montoComIvaSol) + parseFloat(SeguroVidadosDecimales);
        }

        if($('#formaComApertura').val()=='FINANCIAMIENTO' && montoSolicitudBase>0 ){
            montoComIvaSol = Number(montoComIvaSol) + (parseFloat(montoComApeBase) + parseFloat(montoIvaComApeBase));
        }

        if(montoSolicitudBase >0 && Number(montoComIvaSol).toFixed(2) != $('#montoSolici').asNumber() ){
            $('#montoSolici').val(Number(montoComIvaSol).toFixed(2));
        }
    }else{
    // kzo  montoComIvaSol=$('#montoSolici').val(); provocaba que se duplicara el monto por com. aper
    }
        agregaFormatoControles('formaGenerica');

}





//inicializa la solicitud de credito
function inicializarSolicitud() {
    $('#solicitudCreditoID').focus();
    $('#solicitudCreditoID').select();
    inicializaValores(); // funcion que iniciliza valores de la forma
    inicializaVariables(); // funcion para inicializar las variables
    deshabilitaBoton('agregar', 'submit');
    deshabilitaBoton('modificar', 'submit');
    inicializaCombos();

    if ($('#grupo').val() != undefined) {
        consultaIntegrantesGrid();
        var solicitud = $('#solicitudCreditoID').val();
        $('#numSolicitud').val(solicitud);
    }

    validaFlujoIndividual();

    if ($('#numSolicitud').val() != undefined) {
        $('#numSolicitud').val($('#solicitudCreditoID').val());
        var SolCredBeanCon = {
                'solicitudCreditoID' : $('#solicitudCreditoID').val(),
                'usuario' : parametroBean.numeroUsuario
        };
        solicitudCredServicio.consulta(1,SolCredBeanCon,function(solicitud) {
            if (solicitud != null) {
                var ProdCredBeanCon = {
                        'producCreditoID' : solicitud.productoCreditoID
                };

                productosCreditoServicio.consulta(1,ProdCredBeanCon,function(prodCred) {
                    if (prodCred != null) {
                        validaProductoRequiereGarantia(prodCred.requiereGarantia);
                        validaProductoRequiereAvales(prodCred.requiereAvales);
                        if ($('#flujoIndividualBandera').val() != undefined) {
                            muestraPestanias();
                        }
                    }
                });
            }
        });
    }
}

//funcion que se ejecuta cuando surgio un error en la transaccion
function errorSolicitud() {
    agregaFormatoControles('formaGenerica');
}

//funcion para deshabilitar controles
function deshabilitaInputs() {
    deshabilitaControl('productoCreditoID');
    deshabilitaControl('destinoCreID');
    deshabilitaControl('proyecto');
    deshabilitaControl('montoSolici');
    deshabilitaControl('plazoID');
    deshabilitaControl('tipoDispersion');
    deshabilitaControl('lineaFondeoID');
    //deshabilitaControl('promotorID');
    deshabilitaControl('monedaID');
    deshabilitaControl('estatus');
    deshabilitaControl('sucursalID');
    deshabilitaControl('montoAutorizado');
    soloLecturaControl('fechaVencimiento');
    deshabilitaControl('factorMora');
    deshabilitaControl('montoComApert');
    deshabilitaControl('ivaComApert');
    deshabilitaControl('tipoCalInteres');
    deshabilitaControl('calcInteresID');
    deshabilitaControl('tasaBase');
    deshabilitaControl('tasaFija');
    deshabilitaControl('sobreTasa');
    deshabilitaControl('pisoTasa');
    deshabilitaControl('techoTasa');
    soloLecturaControl('fechaInicio');
    deshabilitaControl('cuentaID');
    deshabilitaControl('fechInhabil1');
    deshabilitaControl('fechInhabil2');
    deshabilitaControl('tasaFija');
    deshabilitaControl('periodicidadInt');
    deshabilitaControl('periodicidadCap');
    deshabilitaControl('ajusFecExiVen1');
    deshabilitaControl('ajusFecExiVen2');
    deshabilitaControl('ajFecUlAmoVen1');
    deshabilitaControl('ajFecUlAmoVen2');
    deshabilitaControl('numAmortInteres');
    deshabilitaControl('montoCuota');
    deshabilitaControl('lineaFondeoID');
    deshabilitaControl('tipPago');

    if(document.getElementById("tasaNivel").length > 0){
        $("#tdTasaFija").hide();
        $('#tdTasaNivel').show();
        $('#tasaNivel').val($('#tasaFija').val());
        deshabilitaControl('tasaNivel');
    }else{// SI NO SE LLENA MOSTRARA EL VALOR DE LA TASA QUE SE OBTIENE Y NO EL COMBO
        $("#tdTasaFija").show();
        $('#tdTasaNivel').hide();
    }

}

//Habilita inputs Generales de la Solicitud de Credito sin importar si es grupal(primera, diferente de primera) o individual
function habilitaInputsSolicitud() {
    habilitaControl('montoSolici');
    habilitaControl('beneficiario');
    habilitaControl('parentescoID');
    habilitaControl('direccionBen');
    habilitaControl('destinoCreID');
    habilitaControl('proyecto');

}
//deshabilita inputs de la solicitud grupal cuando las solicitud es >1
function deshabilitaInputsSolGrupal() {
    deshabilitaControl('tipoPagoCapital');
    deshabilitaControl('frecuenciaCap');
    deshabilitaControl('plazoID');
    deshabilitaControl('tipoDispersion');
    deshabilitaControl('tipPago');

}

function habilitaInputsSolGrupal() {
    habilitaControl('tipoPagoCapital');
    habilitaControl('frecuenciaCap');
    habilitaControl('plazoID');
    habilitaControl('tipoDispersion');
    habilitaControl('tipPago');

}
//funcion para inicializar los valores cuando se da de alta una nueva solicitud
function inicializaValoresNuevaSolicitud() {
    inicializaValores(); // funcion que iniciliza valores de la forma
    inicializaVariables(); // funcion para inicializar las variables
    inicializaCombos();
    /* Funcion que habilita los inputs generales de la solicitud sin importar si
     *  es grupal o individual. Excepto inputs que se deshabilitan en casos  especiales */
    habilitaInputsSolicitud();
    $('#sucursalID').val(parametroBean.sucursal);

    habilitaBoton('agregar', 'submit');
    deshabilitaBoton('modificar', 'submit');
    deshabilitaBoton('liberar', 'submit');
    $('#liberar').hide();
    $('#fechaRegistro').val(parametroBean.fechaAplicacion);
    $('#fechaInicio').val(parametroBean.fechaAplicacion);
    $('#fechaInicioAmor').val(parametroBean.fechaAplicacion);
    $('#fechaCobroComision').val(parametroBean.fechaAplicacion);
    $('#monedaID').val('1');
    $('#simular').show();
    $('#tipoPagoSelect').hide();
    $('#tipoPagoSelect2').hide();
    // SEGUROS
    $('#cobraSeguroCuota').val('N').selected = true;
    $('#cobraIVASeguroCuota').val('N').selected = true;
    $('#montoSeguroCuota').val('');


    if ($('#grupo').val() == undefined) {
        habilitaControl('productoCreditoID');
        habilitaControl('grupoID');
        habilitaControl('tipoIntegrante');
    } else {
        habilitaControl('tipoIntegrante');
    }

    $('#contenedorSimulador').html("");
    $('#contenedorSimulador').hide();
    $('#contenedorSimuladorLibre').html("");
    $('#contenedorSimuladorLibre').hide();
    dwr.util.removeAllOptions('sobreTasa');
    dwr.util.addOptions('sobreTasa', {"":'SELECCIONAR'});
    dwr.util.removeAllOptions('convenioNominaID');
    dwr.util.addOptions('convenioNominaID', {"":'SELECCIONAR'});
    $('#convenios').hide();
    limpiarServiciosAdicionales();
}

//funcion que iniciliza valores de la forma
function inicializaValores() {
    soloLecturaControl('fechaInicio');
    soloLecturaControl('fechaInicioAmor');
    soloLecturaControl('fechaVencimiento');
    $('#contenedorSimulador').html("");
    $('#contenedorSimulador').hide();

    $('#contenedorSimuladorLibre').html("");
    $('#contenedorSimuladorLibre').hide();

    $('#clienteID').val('');
    $('#nombreCte').val('');
    $('#productoCreditoID').val('');
    $('#descripProducto').val('');
    $('#promotorID').val('');
    $('#nombrePromotor').val('');
    $('#destinoCreID').val('');
    $('#descripDestino').val('');
    $('#destinCredFRID').val('');
    $('#descripDestinoFR').val('');
    $('#destinCredFOMURID').val('');
    $('#descripDestinoFOMUR').val('');
    $('#proyecto').val('');
    $('#numCreditos').val('');
    $('#cicloClienteGrupal').val('');
    $('#tasaPonderaGru').val('');
    $('#esGrupal').val('');
    $('#montoSolici').val('');
    montoSolicitudBase = 0.00;
    $('#montoAutorizado').val('');
    $('#fechaVencimiento').val('');
    $('#formaComApertura').val('');
    $('#forCobroComAper').val('');
    $('#montoComApert').val('');
    $('#ivaComApert').val('');
    $('#pagaIVACte').val('');
    $('#sucursalCte').val('');
    $('#nombreSucursal').val('');
    $('#porcGarLiq').val('');
    $('#aporteCliente').val('');
    $('#porcentaje').val('');
    $('#porcentajeFOGAFI').val('');
    $('#montoFOGAFI').val('');
    $('#valorPorcFOGAFI').val('');
    $('#forCobroSegVida').val('');
    $('#montoPolSegVida').val('');
    $('#noDias').val('');
    $('#montoSeguroVida').val('');
    $('#factorRiesgoSeguro').val('');
    $('#beneficiario').val('');
    $('#parentescoID').val('');
    $('#parentesco').val('');
    $('#direccionBen').val('');
    $('#desTasaBase').val('');
    $('#cuentaCLABE').val('');
    $('#prospectoID').val('');
    $('#nombreProspecto').val('');

    $('#calcInteresID').val('');
    $('#tipoCalInteres').val('');
    $('#tasaBase').val('');
    $('#tasaFija').val('');
    $('#sobreTasa').val('');
    $('#pisoTasa').val('');
    $('#techoTasa').val('');
    $('#factorMora').val("");
    $('#numAmortizacion').val("");
    $('#numAmortInteres').val("");

    $('#CAT').val("");
    $('#numTransacSim').val("");
    $('#periodicidadInt').val("");
    $('#periodicidadCap').val("");
    $('#frecuenciaInt').val("");
    $('#estatus').val("I");
    $('#montoCuota').val("");
    $('#factorMora').val("");
    $('#tipoDispersion').val("");
    $('#tipoIntegrante').val("");
    $('#comentarioEjecutivo').val("");
    $('#comentariosEjecutivo').hide();
    $('#diaMesCapital').val('');
    $('#diaMesInteres').val('');
    $('#tipoPagoSeguro').val('');

    $('#trMontoSeguroVida').hide();
    $('#trBeneficiario').hide();
    $('#trParentesco').hide();

    $('#reqSeguroVidaNo').attr('checked', true);
    $('#reqSeguroVidaSi').attr("checked", false);
    $('#reqSeguroVida').val('N');

    $('#cobertura').val('');
    $('#prima').val('');
    $('#vigencia').val('');

    // inicializa radios de valores del calendario de pagos *****
    $('#fechInhabil').val("S");
    $('#fechInhabil1').attr('checked', true);
    $('#fechInhabil2').attr("checked", false);

    $('#ajusFecExiVen1').attr('checked', false);
    $('#ajusFecExiVen2').attr("checked", true);
    $('#ajusFecExiVen').val("S");

    $('#calendIrregularCheck').attr("checked", false);
    $('#calendIrregular').val("N");

    $('#ajFecUlAmoVen1').attr('checked', true);
    $('#ajFecUlAmoVen2').attr("checked", false);
    $('#ajFecUlAmoVen').val("S");

    $('#diaMesCapital').val("");
    $('#diaMesInteres').val("");

    $('#diaPagoCapital1').attr('checked', true);
    $('#diaPagoCapital2').attr('checked', false);
    $('#diaPagoCapital').val("F");

    $('#diaPagoInteres1').attr('checked', true);
    $('#diaPagoInteres2').attr('checked', false);
    $('#diaPagoInteres').val("F");
    $('#calificaCredito').val("");
    $('#diaPagoCapitalD').attr('checked', false);
    $('#diaPagoCapitalQ').attr('checked', false);
    $('#diaPagoInteresD').attr('checked', false);
    $('#diaPagoInteresQ').attr('checked', false);
    $('#diaDosQuincCap').val("");
    $('#diaDosQuincInt').val("");
    $('#diaDosQuincInt').hide();

    $('#institucionNominaID').val("");
    $('#nombreInstit').val("");
    $('#lblnomina').hide();
    $('#institNominaID').hide();

    $('#folioCtrl').val("");
    $('#horarioVeri').val("");
    $('#lblFolioCtrl').hide();
    $('#folioCtrlCaja').hide();
    $('#sep').hide();
    $('#tipoPagoSelect').hide();
    $('#tipoPagoSelect2').hide();
    // SEGUROS
    $('#cobraSeguroCuota').val('N').selected = true;
    $('#cobraIVASeguroCuota').val('N').selected = true;
    $('#montoSeguroCuota').val('');


    $('#comentarios').show();
    $('#comentario').val('');
    $('#separa').hide();

    $('#folioConsultaBC').val('');
    $('#folioConsultaCC').val('');
    $('#fieldOtrasComisiones').hide();
    $('#fieldServicioAdic').hide();


    // valida si la pantalla fue llamada desde solicitud grupal para mantener el  numero de grupo o inicializarlo
    if ($('#grupo').val() != '' && $('#grupo').val() != undefined && $('#grupo').asNumber() != '0') {
        $('#grupoID').val($('#grupo').val());
        $('#nombreGr').val($('#nombreGrupo').val());
        // si el grupo ya esta y esta definido el producto de credito
        if ($('#productoCredito').asNumber() != 0) {
            $('#productoCreditoID').val($('#productoCredito').val());
            $('#descripProducto').val($('#nombreProducto').val());
            deshabilitaControl('productoCreditoID');
        }
    } else {
        habilitaControl('productoCreditoID');
        $('#grupoID').val("");
        $('#nombreGr').val("");
        $('#productoCreditoID').val("");
        $('#descripProducto').val("");

    }

    $("#tdTasaFija").show();
    $('#tdTasaNivel').hide();
    habilitaControl('tasaNivel');
    dwr.util.removeAllOptions('tasaNivel');

    $('#ctaClabeTxt').hide();
    $('#ctaClabeInput').hide();
    $('#tipoSantander').attr("checked",true);
    $('#tipoOtroBanco').attr("checked",false);
    $('#dispSantander').hide();
    $('#tipoCtaSantander').val('');
    $('#ctaSantander').val('');
    $('#ctaClabeDisp').val('');
	$('#clabeDomiciliacion').val('');
	$('.ClabeDomiciliacion').hide();

}

//funcion para inicializar las variables
function inicializaVariables() {
    montoSolicitudBase = 0; // monto original del credito(sin comision x apertura ni seguro de vida cuando estos son financiadas)
    montoComApeBase = 0; // monto de la comision por apertura
    montoIvaComApeBase = 0; // monto del iva de la comision por apertura
    formaCobroComApe = ""; // forma de cobro de la comision por apertura (adelantada, financiamiento, deduccion)
    montoComIvaSol = 0; // monto que incluye el iva, la comision por apertura  seg vida
    // variables que se ocupan como base para saber si los datos seleccionados an cambiado y se ejecuten ciertas consultas
    clienteIDBase = 0; // numero de cliente que escoge en un inicio el usuario
    productoIDBase = 0; // numero de producto que escoge en un inicio el usuario
    prospectoIDBase = 0; // numero de prospecto que escoge en un inicio el
    // usuario
    if ($('#grupo').val() == undefined
            && $('#solicitudCreditoID').asNumber() == '0') {
        grupoIDBase = 0; // numero de grupo que en un inicio se escoge (se usa cuando es pantalla individual)
    }
    solicitudIDBase = 0;

    // variables que se utilizan para validar el monto minimo o maximo de la
    // solicitud
    // toman sus valores al consultar el producto de credito
    montoMaxSolicitud = 0.0; // indica el monto maximo que puede escoger en
    // la solicitud
    montoMinSolicitud = 0.0; // indica el monto minimo que puede escoger en
    // la solicitud

    // variables que sirven como base para recalculor el monto del seguro de
    // vida
    fechaVencimientoInicial = "";
    requiereSeg = ""; // indica si requiere o no seguro de vida

    // declaracion de variables que sirven como banderas.
    continuar = 0;
	manejaEsqConvenio = false;
	cobraComisionApertConvenio = false;
	cobraMoraConvenio = false;
	esqCobroComApert = {};

}

//funcion que inicializa los combos, elimina los valores que tenia cargados y deja por default SELECCIONAR
function inicializaCombos() {
    $('#tipoPagoCapital').each(function() {
        $('#tipoPagoCapital option').remove();
    });
    $('#tipoPagoCapital').append(new Option('SELECCIONAR', '', true, true));

    $('#frecuenciaCap').each(function() {
        $('#frecuenciaCap option').remove();
    });
    $('#frecuenciaCap').append(new Option('SELECCIONAR', '', true, true));
    $('#frecuenciaCap').change();

    $('#frecuenciaInt').each(function() {
        $('#frecuenciaInt option').remove();
    });
    $('#frecuenciaInt').append(new Option('SELECCIONAR', '', true, true));
    $('#frecuenciaInt').change();

    $('#plazoID').each(function() {
        $('#plazoID option').remove();
    });
    $('#plazoID').append(new Option('SELECCIONAR', '', true, true));

    $('#tipoDispersion').each(function() {
        $('#tipoDispersion option').remove();
    });
    $('#tipoDispersion').append(new Option('SELECCIONAR', '', true, true));


    $('#convenioNominaID option').remove();

    $('#convenioNominaID').append(new Option('SELECCIONAR', '', true, true));

    $('#quinquenioID').hide();
}

function validaGrupoSolGrupal() {
    // seccion para validar si la pantalla fue llamada desde la pantalla  solicitud grupal(pivote) refresca los valores de
    // los integrantes, no eliminar, esto no afecta el comportamiento individual  de la pantalla

    if ($('#grupo').val() != undefined) {
        consultaIntegrantesGrid();
        var solicitud = $('#solicitudCreditoID').val();
        $('#numSolicitud').val(solicitud);
    } else {
        // $('#grupoID').val("");
    }

    if ($('#solicitudCreditoID').val() != undefined
            && $('#solicitudCreditoID').asNumber() == 0
            && $('#grupo').val() == undefined) {
        inicializarSolicitud();
    }

}

function validaFlujoIndividual() {
    // seccion para validar si la pantalla fue llamada desde la pantalla de  flujo individual(pivote) refresca los valores de
    // la solicitud no eliminar, esto no afecta el comportamiento individual de  la pantalla
    if ($('#flujoIndividualBandera').val() != undefined) {
        var solicitud = $('#solicitudCreditoID').val();
        $('#numSolicitud').val(solicitud);
        consultaDatosSolicitud();
    }
}

/* funcion para ocultar el numero de grupo, nombre e integrante */
function funcionOcultaDivGrupo() {
    $('#nombreGr').val("");
    $('#grupoID').val("");
    $('#tipoIntegrante').val("");
    $('#nombreGr').hide();
    $('#grupoID').hide();
    $('#tipoIntegrante').hide();
    $('#grupoDiv').hide();
}

/* funcion para mostrar el numero de grupo, nombre e integrante */
function funcionMuestraDivGrupo() {
    $('#nombreGr').show();
    $('#grupoID').show();
    $('#tipoIntegrante').show();
    $('#grupoDiv').show();
}

/////funcion para consultar y validar los datos grupales y guarda el error
function validaDatosGrupales(idControl, solicitud, prospecto, cliente,productoCre, grupo) {
    // id control se refiere al dato que esta tomando de el espacio select, input de la forma para procesar la informacion

    if (productoCre > 0) {
        // nuevo paso n 1 obtener los datos ya que tenemos grupo y producto de credito de credito
        var proCredBean = '';
        var max = Number(0);
        var maxh = Number(0);
        var maxm = Number(0);
        var maxms = Number(0);
        var minms = Number(0);
        var numeroi = Number(0);
        var numeroms = Number(0);
        var numerom = Number(0);
        var numeroh = Number(0);
        var conGrupo = 8;
        proCredBean = {
                'producCreditoID' : productoCre
        };
        productosCreditoServicio.consulta(4,proCredBean,function(procred) {
            if (procred != null) {
                if (procred.esGrupal == 'S') {
                    max = Number(procred.maxIntegrantes);
                    maxh = Number(procred.maxHombres);
                    maxm = Number(procred.maxMujeres);
                    maxms = Number(procred.maxMujeresSol);
                    minms = Number(procred.minMujeresSol);

                    if (grupo > 0) {
                        var GrupoBeanCon = {
                                'grupoID' : grupo
                        };
                        gruposCreditoServicio.consulta(conGrupo,GrupoBeanCon,function(grupo) {
                            if (grupo != null) {
                                numeroi = Number(grupo.tInt);
                                numeroms = Number(grupo.tMS);
                                numerom = Number(grupo.tM);
                                numeroh = Number(grupo.tH);

                                if ((max < (numeroi + 1)
                                        && solicitud == 0 || max < (numeroi)
                                        && solicitud != 0)
                                        && max > 0) {
                                    if (max < (numeroi + 1) && solicitud == 0) {
                                        mensajeSis('Se ha Alcanzado el Número Máximo de Integrantes para el Grupo.');
                                    } else {
                                        mensajeSis('Se ha Superado el Número Máximo de Integrantes para el Grupo. Verfique el Producto de Crédito.');
                                    }

                                    $('#solicitudCreditoID').val(nSolicitudSelec);
                                    setTimeout('$(solicitudCreditoID).focus().select();',0);
                                    validacion_maxminExitosa = true;
                                    deshabilitaBoton('agregar','submit');
                                    deshabilitaBoton('modificar','submit');
                                    deshabilitaBoton('liberar','submit');
                                    $('#simular').hide();
                                    $('#liberar').hide();
                                } else {
                                    if (maxms < numeroms) {
                                        if (maxms == 0) {
                                            mensajeSis('El Producto de Crédito no Admite Mujeres Solteras, Verifique las Solicitudes de este Grupo.');
                                        } else {
                                            mensajeSis('Se ha Superado el Número Máximo de Mujeres Solteras para el Grupo. Verfique el Producto de Crédito.');
                                        }

                                        if (cliente != 0) {
                                            setTimeout("$('#clienteID').focus().select();",0);
                                        } else {
                                            setTimeout("$('#prospectoID').focus().select();",0);
                                        }
                                        validacion_maxminExitosa = true;
                                        deshabilitaBoton('agregar','submit');
                                        deshabilitaBoton('modificar','submit');
                                        deshabilitaBoton('liberar','submit');
                                        $('#simular').hide();
                                        $('#liberar').hide();
                                    } else {
                                        if (maxm < numerom) {
                                            if (maxm == 0) {
                                                mensajeSis('El Producto de Crédito no Admite Mujeres, verifique las Solicitudes de este Grupo.');
                                            } else {
                                                mensajeSis('Se ha Superado el Número Máximo de Mujeres para el Grupo. Verfique el Producto de Crédito.');
                                            }

                                            if (cliente != 0) {
                                                setTimeout("$('#clienteID').focus().select();",0);
                                            } else {
                                                setTimeout("$('#prospectoID').focus().select();",0);
                                            }
                                            validacion_maxminExitosa = true;
                                            deshabilitaBoton('agregar','submit');
                                            deshabilitaBoton('modificar','submit');
                                            deshabilitaBoton('liberar','submit');
                                            $('#liberar').hide();
                                        } else {
                                            if (maxh < numeroh) {

                                                if (maxh == 0) {
                                                    mensajeSis('El Producto de Crédito no Admite Hombres, Verifique las Solicitudes de este Grupo.');
                                                } else {
                                                    mensajeSis('Se ha Superado el Número Máximo de Hombres para el Grupo. Verfique el Producto de Crédito.');
                                                }

                                                if (cliente != 0) {
                                                    setTimeout("$('#clienteID').focus().select();",0);
                                                } else {
                                                    setTimeout("$('#prospectoID').focus().select();",0);
                                                }
                                                validacion_maxminExitosa = true;
                                                deshabilitaBoton('agregar','submit');
                                                deshabilitaBoton('modificar','submit');
                                                deshabilitaBoton('liberar','submit');
                                                $('#liberar').hide();
                                            } else {
                                                if ((maxm - minms) < (numerom - numeroms)) {

                                                    if ((maxm - minms) == 0) {
                                                        mensajeSis('El Producto de Crédito Solo Admite Mujeres Solteras, Verifique las Solicitudes de este Grupo.');
                                                    } else {
                                                        mensajeSis('Se ha Superado el Número Máximo de Mujeres con Estado Civil Diferente de Solteras para el Grupo, verifique las solicitudes de este Grupo.');
                                                    }

                                                    if (cliente != 0) {
                                                        setTimeout("$('#clienteID').focus().select();",0);
                                                    } else {
                                                        setTimeout("$('#prospectoID').focus().select();",0);
                                                    }
                                                    validacion_maxminExitosa = true;
                                                    deshabilitaBoton('agregar','submit');
                                                    deshabilitaBoton('modificar','submit');
                                                    deshabilitaBoton('liberar','submit');
                                                    $('#liberar').hide();
                                                } else {

                                                    // paso numero 2 revisar si quiere agregar una nueva solicitud o es la misma la quiere modificar
                                                    if (solicitud > 0) {

                                                        // al parecer es la misma pero quiere modificarla hay que asegurarse
                                                        if (nSolicitudSelec == solicitud) {
                                                            if (nSolicitudSelec != 0) {
                                                                // las solicitudes son las misma asi que van a cambiar
                                                                // de prospecto a integrante o viceversa o un prospecto
                                                                // con integrante si es !=0 quiere decir si existia una                                                         // seleccionada
                                                                // solicitud, ahora ahy que comprobar que son los mismos
                                                                // cliente y prospecto
                                                                var usuario = parametroBean.numeroUsuario;
                                                                var SolCredBeanCon = {
                                                                        'solicitudCreditoID' : solicitud,
                                                                        'usuario' : usuario
                                                                };

                                                                solicitudCredServicio.consulta(1,SolCredBeanCon,function(solicitud) {
                                                                    if (solicitud != null) {
                                                                        if(cobraAccesoriosGen=='S'){
                                                                            cobraAccesorios=solicitud.cobraAccesorios;
                                                                        }
                                                                        if (solicitud.prospectoID != prospecto || solicitud.clienteID != cliente) {
                                                                            // aqui si anda modificando el prospecto o cliente y
                                                                            // aqui validamos esos nuevos datos primero sabe a quien
                                                                            // cambiaron le quitamos los datos del cliente o prospecto anterior del
                                                                            // cual se le cambio los datos seleccionamos el primero el cliente
                                                                            // y si no existe seleccionamos datos el prospecto
                                                                            if (Number(solicitud.prospectoID) != prospecto && Number(solicitud.clienteID) == cliente) {
                                                                                if (cliente != 0) {
                                                                                    clienteServicio.consulta(1,cliente.toString(),"",function(clientedes) {
                                                                                        if (clientedes != null) {
                                                                                            if (clientedes.sexo == 'F') {
                                                                                                if (clientedes.estadoCivil == 'S') {
                                                                                                    numeroms = numeroms - 1;
                                                                                                }
                                                                                                numerom = numerom - 1;
                                                                                            } else {
                                                                                                numeroh = numeroh - 1;
                                                                                            }
                                                                                            var beanprosig = {
                                                                                                    'prospectoID' : prospecto,
                                                                                                    'cliente' : cliente
                                                                                            };
                                                                                            prospectosServicio.consulta(2,beanprosig,function(prospdes) {
                                                                                                if (prospdes != null) {
                                                                                                    if (prospdes.sexo == 'F') {
                                                                                                        if (prospdes.estadoCivil == 'S') {
                                                                                                            numeroms = numeroms + 1;
                                                                                                        }
                                                                                                        numerom = numerom + 1;
                                                                                                    } else {
                                                                                                        numeroh = numeroh + 1;
                                                                                                    }

                                                                                                }
                                                                                                if (numeroi > max) {
                                                                                                    mensajeSis('Se ha Alcanzado el Número Máximo de Integrantes para el Grupo');
                                                                                                    if (cliente != 0) {
                                                                                                        setTimeout("$('#clienteID').focus().select();",0);
                                                                                                    } else {
                                                                                                        setTimeout("$('#prospectoID').focus().select();",0);
                                                                                                    }
                                                                                                    validacion_maxminExitosa = true;
                                                                                                    deshabilitaBoton('agregar','submit');
                                                                                                    deshabilitaBoton('modificar','submit');
                                                                                                    deshabilitaBoton('liberar','submit');
                                                                                                    $('#liberar').hide();
                                                                                                } else {
                                                                                                    if (numeroms > maxms) {
                                                                                                        if (cliente != 0) {
                                                                                                            setTimeout("$('#clienteID').focus().select();",0);
                                                                                                        } else {
                                                                                                            setTimeout("$('#prospectoID').focus().select();",0);
                                                                                                        }
                                                                                                        if (maxms == 0) {
                                                                                                            mensajeSis('El Producto de Crédito no Admite Mujeres Solteras.');
                                                                                                        } else {
                                                                                                            mensajeSis('Se ha Alcanzado el Número Máximo de Mujeres Solteras para el Grupo.');
                                                                                                        }
                                                                                                        validacion_maxminExitosa = true;
                                                                                                        deshabilitaBoton('agregar','submit');
                                                                                                        deshabilitaBoton('modificar','submit');
                                                                                                        deshabilitaBoton('liberar','submit');
                                                                                                        $('#liberar').hide();
                                                                                                    } else {
                                                                                                        if (numerom > maxm) {
                                                                                                            if (cliente != 0) {
                                                                                                                setTimeout("$('#clienteID').focus().select();",0);
                                                                                                            } else {
                                                                                                                setTimeout("$('#prospectoID').focus().select();",0);
                                                                                                            }
                                                                                                            if (maxm == 0) {
                                                                                                                mensajeSis('El Producto de Crédito no Admite Mujeres.');
                                                                                                            } else {
                                                                                                                mensajeSis('Se ha alcanzado el Número Máximo de Mujeres para el Grupo');
                                                                                                            }
                                                                                                            validacion_maxminExitosa = true;
                                                                                                            deshabilitaBoton('agregar','submit');
                                                                                                            deshabilitaBoton('modificar','submit');
                                                                                                            deshabilitaBoton('liberar','submit');
                                                                                                            $('#liberar').hide();
                                                                                                        } else {
                                                                                                            if (numeroh > maxh) {
                                                                                                                if (cliente != 0) {
                                                                                                                    setTimeout("$('#clienteID').focus().select();",0);
                                                                                                                } else {
                                                                                                                    setTimeout("$('#prospectoID').focus().select();",0);
                                                                                                                }
                                                                                                                if (maxh == 0) {
                                                                                                                    mensajeSis('El Producto de Crédito no Admite Hombres.');
                                                                                                                } else {
                                                                                                                    mensajeSis('Se ha Alcanzado el Número Máximo de Hombres para el Grupo.');
                                                                                                                }
                                                                                                                validacion_maxminExitosa = true;
                                                                                                                deshabilitaBoton('agregar','submit');
                                                                                                                deshabilitaBoton('modificar','submit');
                                                                                                                deshabilitaBoton('liberar','submit');
                                                                                                                $('#liberar').hide();
                                                                                                            } else {
                                                                                                                if ((maxm - minms) < (numerom - numeroms)) {
                                                                                                                    if (cliente != 0) {
                                                                                                                        setTimeout("$('#clienteID').focus().select();",0);
                                                                                                                    } else {
                                                                                                                        setTimeout("$('#prospectoID').focus().select();",0);
                                                                                                                    }
                                                                                                                    if ((maxm - minms) == 0) {
                                                                                                                        mensajeSis('El Producto de Crédito Solo Admite Mujeres Solteras.');
                                                                                                                    } else {
                                                                                                                        mensajeSis('Se ha Alcanzado el Número Máximo de Mujeres con Estado Civil Diferente de Solteras para el Grupo.');
                                                                                                                    }
                                                                                                                    validacion_maxminExitosa = true;
                                                                                                                    deshabilitaBoton('agregar','submit');
                                                                                                                    deshabilitaBoton('modificar','submit');
                                                                                                                    deshabilitaBoton('liberar','submit');
                                                                                                                    $('#liberar').hide();
                                                                                                                } else {
                                                                                                                    deshabilitaBoton('agregar','submit');
                                                                                                                    habilitaBoton('modificar','submit');
                                                                                                                }
                                                                                                            }

                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            });
                                                                                        }
                                                                                    });
                                                                                } else {
                                                                                    var beanprosant = {
                                                                                            'prospectoID' : solicitud.prospectoID,
                                                                                            'cliente' : solicitud.clienteID
                                                                                    };

                                                                                    var beanprosig = {
                                                                                            'prospectoID' : prospecto,
                                                                                            'cliente' : cliente
                                                                                    };

                                                                                    prospectosServicio.consulta(2,beanprosant,function(prospant) {
                                                                                        if (prospant != null) {
                                                                                            if (prospant.sexo == 'F') {
                                                                                                if (prospant.estadoCivil == 'S') {
                                                                                                    numeroms = numeroms - 1;
                                                                                                }
                                                                                                numerom = numerom - 1;
                                                                                            } else {
                                                                                                numeroh = numeroh - 1;
                                                                                            }
                                                                                        }
                                                                                        prospectosServicio.consulta(2,beanprosig,function(prospdes) {
                                                                                            if (prospdes != null) {
                                                                                                if (prospdes.sexo == 'F') {
                                                                                                    if (prospdes.estadoCivil == 'S') {
                                                                                                        numeroms = numeroms + 1;
                                                                                                    }
                                                                                                    numerom = numerom + 1;
                                                                                                } else {
                                                                                                    numeroh = numeroh + 1;
                                                                                                }

                                                                                            }
                                                                                            if (numeroi > max) {
                                                                                                mensajeSis('Se ha Alcanzado el Número Máximo de Integrantes para el Grupo.');
                                                                                                if (cliente != 0) {
                                                                                                    setTimeout("$('#clienteID').focus().select();",0);
                                                                                                } else {
                                                                                                    setTimeout("$('#prospectoID').focus().select();",0);
                                                                                                }
                                                                                                validacion_maxminExitosa = true;
                                                                                                deshabilitaBoton('agregar','submit');
                                                                                                deshabilitaBoton('modificar','submit');
                                                                                                deshabilitaBoton('liberar','submit');
                                                                                                $('#liberar').hide();
                                                                                            } else {
                                                                                                if (numeroms > maxms) {
                                                                                                    if (cliente != 0) {
                                                                                                        setTimeout("$('#clienteID').focus().select();",0);
                                                                                                    } else {
                                                                                                        setTimeout("$('#prospectoID').focus().select();",0);
                                                                                                    }

                                                                                                    if (maxms == 0) {
                                                                                                        mensajeSis('El Producto de Crédito no Admite Mujeres Solteras.');
                                                                                                    } else {
                                                                                                        mensajeSis('Se ha Alcanzado el Número Máximo de Mujeres Solteras para el Grupo.');
                                                                                                    }
                                                                                                    validacion_maxminExitosa = true;
                                                                                                    deshabilitaBoton('agregar','submit');
                                                                                                    deshabilitaBoton('modificar','submit');
                                                                                                    deshabilitaBoton('liberar','submit');
                                                                                                    $('#liberar').hide();
                                                                                                } else {
                                                                                                    if (numerom > maxm) {
                                                                                                        if (cliente != 0) {
                                                                                                            setTimeout("$('#clienteID').focus().select();",0);
                                                                                                        } else {
                                                                                                            setTimeout("$('#prospectoID').focus().select();",0);
                                                                                                        }

                                                                                                        if (maxm == 0) {
                                                                                                            mensajeSis('El Producto de Crédito no Admite Mujeres.');
                                                                                                        } else {
                                                                                                            mensajeSis('Se ha Alcanzado el Número Máximo de Mujeres para el Grupo.');
                                                                                                        }
                                                                                                        validacion_maxminExitosa = true;
                                                                                                        deshabilitaBoton('agregar','submit');
                                                                                                        deshabilitaBoton('modificar','submit');
                                                                                                        deshabilitaBoton('liberar','submit');
                                                                                                        $('#liberar').hide();
                                                                                                    } else {
                                                                                                        if (numeroh > maxh) {
                                                                                                            if (cliente != 0) {
                                                                                                                setTimeout("$('#clienteID').focus().select();",0);
                                                                                                            } else {
                                                                                                                setTimeout("$('#prospectoID').focus().select();",0);
                                                                                                            }

                                                                                                            if (maxh == 0) {
                                                                                                                mensajeSis('El Producto de Crédito no Admite Hombres.');
                                                                                                            } else {
                                                                                                                mensajeSis('Se ha Alcanzado el Número Máximo de Hombres para el Grupo.');
                                                                                                            }
                                                                                                            validacion_maxminExitosa = true;
                                                                                                            deshabilitaBoton('agregar','submit');
                                                                                                            deshabilitaBoton('modificar','submit');
                                                                                                            deshabilitaBoton('liberar','submit');
                                                                                                            $('#liberar').hide();
                                                                                                        } else {
                                                                                                            if ((maxm - minms) < (numerom - numeroms)) {
                                                                                                                if (cliente != 0) {
                                                                                                                    setTimeout("$('#clienteID').focus().select();",0);
                                                                                                                } else {
                                                                                                                    setTimeout("$('#prospectoID').focus().select();",0);
                                                                                                                }
                                                                                                                if ((maxm - minms) == 0) {
                                                                                                                    mensajeSis('El Producto de Crédito Solo Admite Mujeres Solteras.');
                                                                                                                } else {
                                                                                                                    mensajeSis('Se ha Alcanzado el Número Máximo de Mujeres con Estado Civil Diferente de Solteras para el Grupo.');
                                                                                                                }
                                                                                                                validacion_maxminExitosa = true;
                                                                                                                deshabilitaBoton('agregar','submit');
                                                                                                                deshabilitaBoton('modificar','submit');
                                                                                                                deshabilitaBoton('liberar','submit');
                                                                                                                $('#liberar').hide();
                                                                                                            } else {
                                                                                                                deshabilitaBoton('agregar','submit');
                                                                                                                habilitaBoton('modificar','submit');
                                                                                                                $('#simular').show();
                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            }
                                                                                        });
                                                                                    });
                                                                                }
                                                                            }
                                                                            if (Number(solicitud.prospectoID) == prospecto && Number(solicitud.clienteID) != cliente
                                                                                    || Number(solicitud.prospectoID) != prospecto && Number(solicitud.clienteID) != cliente) {
                                                                                if (Number(solicitud.clienteID) == 0) {
                                                                                    var beanpro = {
                                                                                            'prospectoID' : solicitud.prospectoID,
                                                                                            'cliente' : solicitud.clienteID
                                                                                    };
                                                                                    prospectosServicio.consulta(2,beanpro,function(prospant) {
                                                                                        if (prospant != null) {
                                                                                            if (prospant.sexo == 'F') {
                                                                                                if (prospant.estadoCivil == 'S') {
                                                                                                    numeroms = numeroms - 1;
                                                                                                }
                                                                                                numerom = numerom - 1;
                                                                                            } else {
                                                                                                numeroh = numeroh - 1;
                                                                                            }
                                                                                            clienteServicio.consulta(1,cliente.toString(),"",function(clientedes) {
                                                                                                if (clientedes != null) {
                                                                                                    if (clientedes.sexo == 'F') {
                                                                                                        if (clientedes.estadoCivil == 'S') {
                                                                                                            numeroms = numeroms + 1;
                                                                                                        }
                                                                                                        numerom = numerom + 1;
                                                                                                    } else {
                                                                                                        numeroh = numeroh + 1;
                                                                                                    }
                                                                                                    if (numeroi > max) {
                                                                                                        mensajeSis('Se ha Alcanzado el Número Máximo de Integrantes para el Grupo.');
                                                                                                        if (cliente != 0) {
                                                                                                            setTimeout("$('#clienteID').focus().select();",0);
                                                                                                        } else {
                                                                                                            setTimeout("$('#prospectoID').focus().select();",0);
                                                                                                        }
                                                                                                        validacion_maxminExitosa = true;
                                                                                                        deshabilitaBoton('agregar','submit');
                                                                                                        deshabilitaBoton('modificar','submit');
                                                                                                        deshabilitaBoton('liberar','submit');
                                                                                                        $('#liberar').hide();
                                                                                                    } else {
                                                                                                        if (numeroms > maxms) {
                                                                                                            if (cliente != 0) {
                                                                                                                setTimeout("$('#clienteID').focus().select();",0);
                                                                                                            } else {
                                                                                                                setTimeout("$('#prospectoID').focus().select();",0);
                                                                                                            }

                                                                                                            if (maxms == 0) {
                                                                                                                mensajeSis('El Producto de Crédito no Admite Mujeres Solteras.');
                                                                                                            } else {
                                                                                                                mensajeSis('Se ha Alcanzado el Número Máximo de Mujeres Solteras para el Grupo.');
                                                                                                            }
                                                                                                            validacion_maxminExitosa = true;
                                                                                                            deshabilitaBoton('agregar','submit');
                                                                                                            deshabilitaBoton('modificar','submit');
                                                                                                            deshabilitaBoton('liberar','submit');
                                                                                                            $('#liberar').hide();
                                                                                                        } else {
                                                                                                            if (numerom > maxm) {
                                                                                                                if (cliente != 0) {
                                                                                                                    setTimeout("$('#clienteID').focus().select();",0);
                                                                                                                } else {
                                                                                                                    setTimeout("$('#prospectoID').focus().select();",0);
                                                                                                                }

                                                                                                                if (maxm == 0) {
                                                                                                                    mensajeSis('El Producto de Crédito no Admite Mujeres.');
                                                                                                                } else {
                                                                                                                    mensajeSis('Se ha Alcanzado el Número Máximo de Mujeres para el Grupo.');
                                                                                                                }
                                                                                                                validacion_maxminExitosa = true;
                                                                                                                deshabilitaBoton('agregar','submit');
                                                                                                                deshabilitaBoton('modificar','submit');
                                                                                                                deshabilitaBoton('liberar','submit');
                                                                                                                $('#liberar').hide();
                                                                                                            } else {
                                                                                                                if (numeroh > maxh) {
                                                                                                                    if (cliente != 0) {
                                                                                                                        setTimeout("$('#clienteID').focus().select();",0);
                                                                                                                    } else {
                                                                                                                        setTimeout("$('#prospectoID').focus().select();",0);
                                                                                                                    }

                                                                                                                    if (maxh == 0) {
                                                                                                                        mensajeSis('El Producto de Crédito no Admite Hombres.');
                                                                                                                    } else {
                                                                                                                        mensajeSis('Se ha Alcanzado el Número Máximo de Hombres para el Grupo.');
                                                                                                                    }
                                                                                                                    validacion_maxminExitosa = true;
                                                                                                                    deshabilitaBoton('agregar','submit');
                                                                                                                    deshabilitaBoton('modificar','submit');
                                                                                                                    deshabilitaBoton('liberar','submit');
                                                                                                                    $('#liberar').hide();
                                                                                                                } else {
                                                                                                                    if ((maxm - minms) < (numerom - numeroms)) {
                                                                                                                        if (cliente != 0) {
                                                                                                                            setTimeout("$('#clienteID').focus().select();",
                                                                                                                                    0);
                                                                                                                        } else {
                                                                                                                            setTimeout(
                                                                                                                                    "$('#prospectoID').focus().select();",
                                                                                                                                    0);
                                                                                                                        }
                                                                                                                        if ((maxm - minms) == 0) {
                                                                                                                            mensajeSis('El Producto de Crédito Solo Admite Mujeres Solteras.');
                                                                                                                        } else {
                                                                                                                            mensajeSis('Se ha Alcanzado el Número Máximo de Mujeres con Estado Civil Diferente de Solteras para el Grupo.');
                                                                                                                        }
                                                                                                                        validacion_maxminExitosa = true;
                                                                                                                        deshabilitaBoton('agregar','submit');
                                                                                                                        deshabilitaBoton('modificar','submit');
                                                                                                                        deshabilitaBoton('liberar','submit');
                                                                                                                        $('#liberar').hide();
                                                                                                                    } else {
                                                                                                                        deshabilitaBoton('agregar','submit');
                                                                                                                        habilitaBoton('modificar','submit');
                                                                                                                        $('#simular').show();
                                                                                                                    }
                                                                                                                }
                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            });

                                                                                        }
                                                                                    });
                                                                                } else {

                                                                                    clienteServicio.consulta(1,solicitud.clienteID,"",function(clienteantes) {
                                                                                                if (clienteantes != null) {
                                                                                                    if (clienteantes.sexo == 'F') {
                                                                                                        if (clienteantes.estadoCivil == 'S') {
                                                                                                            numeroms = numeroms - 1;
                                                                                                        }
                                                                                                        numerom = numerom - 1;
                                                                                                    } else {
                                                                                                        numeroh = numeroh - 1;
                                                                                                    }

                                                                                                    clienteServicio.consulta(1,cliente.toString(),"",function(clientedes) {
                                                                                                                if (clientedes != null) {
                                                                                                                    if (clientedes.sexo == 'F') {
                                                                                                                        if (clientedes.estadoCivil == 'S') {
                                                                                                                            numeroms = numeroms + 1;
                                                                                                                        }
                                                                                                                        numerom = numerom + 1;
                                                                                                                    } else {
                                                                                                                        numeroh = numeroh + 1;
                                                                                                                    }
                                                                                                                    if (numeroi > max) {
                                                                                                                        mensajeSis('Se ha Alcanzado el Número Máximo de Integrantes para el Grupo.');
                                                                                                                        if (cliente != 0) {
                                                                                                                            setTimeout("$('#clienteID').focus().select();",0);
                                                                                                                        } else {
                                                                                                                            setTimeout("$('#prospectoID').focus().select();",0);
                                                                                                                        }
                                                                                                                        validacion_maxminExitosa = true;
                                                                                                                        deshabilitaBoton('agregar','submit');
                                                                                                                        deshabilitaBoton('modificar','submit');
                                                                                                                        deshabilitaBoton('liberar','submit');
                                                                                                                        $('#liberar').hide();
                                                                                                                    } else {
                                                                                                                        if (numeroms > maxms) {
                                                                                                                            if (cliente != 0) {
                                                                                                                                setTimeout("$('#clienteID').focus().select();",0);
                                                                                                                            } else {
                                                                                                                                setTimeout("$('#prospectoID').focus().select();",0);
                                                                                                                            }

                                                                                                                            if (maxms == 0) {
                                                                                                                                mensajeSis('El Producto de Crédito no Admite Mujeres Solteras.');
                                                                                                                            } else {
                                                                                                                                mensajeSis('Se ha Alcanzado el Número Máximo de Mujeres Solteras para el Grupo.');
                                                                                                                            }
                                                                                                                            validacion_maxminExitosa = true;
                                                                                                                            deshabilitaBoton('agregar','submit');
                                                                                                                            deshabilitaBoton('modificar','submit');
                                                                                                                            deshabilitaBoton('liberar','submit');
                                                                                                                            $('#liberar').hide();
                                                                                                                        } else {
                                                                                                                            if (numerom > maxm) {
                                                                                                                                if (cliente != 0) {
                                                                                                                                    setTimeout("$('#clienteID').focus().select();",0);
                                                                                                                                } else {
                                                                                                                                    setTimeout("$('#prospectoID').focus().select();",0);
                                                                                                                                }

                                                                                                                                if (maxm == 0) {
                                                                                                                                    mensajeSis('El Producto de Crédito no Admite Mujeres.');
                                                                                                                                } else {
                                                                                                                                    mensajeSis('Se ha Alcanzado el Número Máximo de Mujeres para el Grupo.');
                                                                                                                                }
                                                                                                                                validacion_maxminExitosa = true;
                                                                                                                                deshabilitaBoton('agregar','submit');
                                                                                                                                deshabilitaBoton('modificar','submit');
                                                                                                                                deshabilitaBoton('liberar','submit');
                                                                                                                                $('#liberar').hide();
                                                                                                                            } else {
                                                                                                                                if (numeroh > maxh) {
                                                                                                                                    if (cliente != 0) {
                                                                                                                                        setTimeout("$('#clienteID').focus().select();",0);
                                                                                                                                    } else {
                                                                                                                                        setTimeout("$('#prospectoID').focus().select();",0);
                                                                                                                                    }

                                                                                                                                    if (maxh == 0) {
                                                                                                                                        mensajeSis('El Producto de Crédito no Admite Hombres.');
                                                                                                                                    } else {
                                                                                                                                        mensajeSis('Se ha Alcanzado el Número Máximo de Hombres para el Grupo.');
                                                                                                                                    }
                                                                                                                                    validacion_maxminExitosa = true;
                                                                                                                                    deshabilitaBoton('agregar','submit');
                                                                                                                                    deshabilitaBoton('modificar','submit');
                                                                                                                                    deshabilitaBoton('liberar','submit');
                                                                                                                                    $('#liberar').hide();
                                                                                                                                } else {
                                                                                                                                    if ((maxm - minms) < (numerom - numeroms)) {
                                                                                                                                        if (cliente != 0) {
                                                                                                                                            setTimeout("$('#clienteID').focus().select();",0);
                                                                                                                                        } else {
                                                                                                                                            setTimeout("$('#prospectoID').focus().select();",0);
                                                                                                                                        }
                                                                                                                                        if ((maxm - minms) == 0) {
                                                                                                                                            mensajeSis('El Producto de Crédito Solo Admite Mujeres Solteras.');
                                                                                                                                        } else {
                                                                                                                                            mensajeSis('Se ha Alcanzado el Número Máximo de Mujeres con Estado Civil Diferente de Solteras para el Grupo.');
                                                                                                                                        }
                                                                                                                                        validacion_maxminExitosa = true;
                                                                                                                                        deshabilitaBoton('agregar','submit');
                                                                                                                                        deshabilitaBoton('modificar','submit');
                                                                                                                                        deshabilitaBoton('liberar','submit');
                                                                                                                                        $('#liberar').hide();
                                                                                                                                    } else {
                                                                                                                                        deshabilitaBoton('agregar','submit');
                                                                                                                                        habilitaBoton('modificar','submit');
                                                                                                                                        $('#simular').show();
                                                                                                                                    }
                                                                                                                                }
                                                                                                                            }
                                                                                                                        }
                                                                                                                    }
                                                                                                                }
                                                                                                            });
                                                                                                }
                                                                                            });
                                                                                }
                                                                            }
                                                                        } else {
                                                                            // listo si estan modificando la solicitud pero no es el prospecto ni el cliente
                                                                            // no hay nada que hacer aqui
                                                                        }
                                                                    } else {
                                                                        mensajeSis('La Solicitud No Existe.');
                                                                        validacion_maxminExitosa = true;
                                                                        deshabilitaBoton('agregar','submit');
                                                                        deshabilitaBoton('modificar','submit');
                                                                        deshabilitaBoton('liberar','submit');
                                                                        $('#liberar').hide();
                                                                    }
                                                                });
                                                            } else {
                                                                // sino, es que el grupo no tiene integrantes
                                                                mensajeSis('El Grupo No Tiene Integrantes');
                                                                validacion_maxminExitosa = true;
                                                                deshabilitaBoton('agregar','submit');
                                                                deshabilitaBoton('modificar','submit');
                                                                deshabilitaBoton('liberar','submit');
                                                                $('#liberar').hide();
                                                            }
                                                        } else {// revisamos si es una solicitud de credito hecha, que datos tiene al agregarla
                                                            if (prospecto != 0 && cliente == 0) {
                                                                var beanprosig = {
                                                                        'prospectoID' : prospecto,
                                                                        'cliente' : cliente
                                                                };
                                                                prospectosServicio.consulta(2,beanprosig,function(prospdes) {
                                                                            if (prospdes != null) {
                                                                                if (prospdes.sexo == 'F') {
                                                                                    if (prospdes.estadoCivil == 'S') {
                                                                                        numeroms = numeroms + 1;
                                                                                    }
                                                                                    numerom = numerom + 1;
                                                                                } else {
                                                                                    numeroh = numeroh + 1;
                                                                                }
                                                                            }
                                                                            if (numeroms > maxms) {
                                                                                if (cliente != 0) {
                                                                                    setTimeout("$('#clienteID').focus().select();",0);
                                                                                } else {
                                                                                    setTimeout("$('#prospectoID').focus().select();",0);
                                                                                }

                                                                                mensajeSis('La Solicitud de Crédito Grupal no Admite Mujeres Solteras');
                                                                                validacion_maxminExitosa = true;
                                                                                deshabilitaBoton('agregar','submit');
                                                                                deshabilitaBoton('modificar','submit');
                                                                                deshabilitaBoton('liberar','submit');
                                                                                $('#liberar').hide();
                                                                            } else {
                                                                                if (numerom > maxm) {
                                                                                    if (cliente != 0) {
                                                                                        setTimeout("$('#clienteID').focus().select();",0);
                                                                                    } else {
                                                                                        setTimeout("$('#prospectoID').focus().select();",0);
                                                                                    }

                                                                                    mensajeSis('La Solicitud de Crédito Grupal no Admite Mujeres.');
                                                                                    validacion_maxminExitosa = true;
                                                                                    deshabilitaBoton('agregar','submit');
                                                                                    deshabilitaBoton('modificar','submit');
                                                                                    deshabilitaBoton('liberar','submit');
                                                                                    $('#liberar').hide();
                                                                                } else {
                                                                                    if (numeroh > maxh) {
                                                                                        if (cliente != 0) {
                                                                                            setTimeout("$('#clienteID').focus().select();",0);
                                                                                        } else {
                                                                                            setTimeout("$('#prospectoID').focus().select();",0);
                                                                                        }

                                                                                        mensajeSis('La Solicitud de Crédito Grupal no Admite Hombres.');
                                                                                        validacion_maxminExitosa = true;
                                                                                        deshabilitaBoton('agregar','submit');
                                                                                        deshabilitaBoton('modificar','submit');
                                                                                        deshabilitaBoton('liberar','submit');
                                                                                        $('#liberar').hide();
                                                                                    } else {
                                                                                        deshabilitaBoton('agregar','submit');
                                                                                        habilitaBoton('modificar','submit');
                                                                                        $('#simular').show();
                                                                                    }
                                                                                }
                                                                            }
                                                                        });
                                                            }
                                                            if (cliente != 0) {
                                                                clienteServicio.consulta(1,cliente.toString(),"",function(clientedes) {
                                                                            if (clientedes != null) {
                                                                                if (clientedes.sexo == 'F') {
                                                                                    if (clientedes.estadoCivil == 'S') {
                                                                                        numeroms = numeroms + 1;
                                                                                    }
                                                                                    numerom = numerom + 1;
                                                                                } else {
                                                                                    numeroh = numeroh + 1;
                                                                                }

                                                                            }
                                                                            if (numeroms > maxms) {
                                                                                if (cliente != 0) {
                                                                                    setTimeout("$('#clienteID').focus().select();",0);
                                                                                } else {
                                                                                    setTimeout("$('#prospectoID').focus().select();",0);
                                                                                }

                                                                                mensajeSis('La Solicitud de Crédito Grupal no Admite Mujeres Solteras.');
                                                                                validacion_maxminExitosa = true;
                                                                                deshabilitaBoton('agregar','submit');
                                                                                deshabilitaBoton('modificar','submit');
                                                                                deshabilitaBoton('liberar','submit');
                                                                                $('#liberar').hide();
                                                                            } else {
                                                                                if (numerom > maxm) {
                                                                                    if (cliente != 0) {
                                                                                        setTimeout("$('#clienteID').focus().select();",0);
                                                                                    } else {
                                                                                        setTimeout("$('#prospectoID').focus().select();",0);
                                                                                    }

                                                                                    mensajeSis('La Solicitud de Crédito Grupal no Admite Mujeres.');
                                                                                    validacion_maxminExitosa = true;
                                                                                    deshabilitaBoton('agregar','submit');
                                                                                    deshabilitaBoton('modificar','submit');
                                                                                    deshabilitaBoton('liberar','submit');
                                                                                    $('#liberar').hide();
                                                                                } else {
                                                                                    if (numeroh > maxh) {
                                                                                        if (cliente != 0) {
                                                                                            setTimeout("$('#clienteID').focus().select();",0);
                                                                                        } else {
                                                                                            setTimeout("$('#prospectoID').focus().select();",0);
                                                                                        }

                                                                                        mensajeSis('La Solicitud de Crédito Grupal no Admite Hombres.');
                                                                                        validacion_maxminExitosa = true;
                                                                                        deshabilitaBoton('agregar','submit');
                                                                                        deshabilitaBoton('modificar','submit');
                                                                                        deshabilitaBoton('liberar','submit');
                                                                                        $('#liberar').hide();
                                                                                    } else {
                                                                                        if ((maxm - minms) < (numerom - numeroms)) {
                                                                                            if (cliente != 0) {
                                                                                                setTimeout("$('#clienteID').focus().select();",0);
                                                                                            } else {
                                                                                                setTimeout("$('#prospectoID').focus().select();",0);
                                                                                            }
                                                                                            if ((maxm - minms) == 0) {
                                                                                                mensajeSis('El Producto de Crédito Solo Admite Mujeres Solteras.');
                                                                                            } else {
                                                                                                mensajeSis('Se ha Alcanzado el Número Máximo de Mujeres con Estado Civil Diferente de Solteras para el Grupo.');
                                                                                            }
                                                                                            validacion_maxminExitosa = true;
                                                                                            deshabilitaBoton('agregar','submit');
                                                                                            deshabilitaBoton('modificar','submit');
                                                                                            deshabilitaBoton('liberar','submit');
                                                                                            $('#liberar').hide();
                                                                                        } else {
                                                                                            deshabilitaBoton('agregar','submit');
                                                                                            habilitaBoton('modificar','submit');
                                                                                            $('#simular').show();
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        });
                                                            }
                                                        }
                                                    } else {
                                                        // esta agregando una nueva solicitud, por lo cual no solo vamos a ver los nuevos datos ingresados

                                                        numeroi = numeroi + 1;
                                                        if (numeroi > max) {
                                                            mensajeSis('Se ha Alcanzado el Número Máximo de Integrantes para el Grupo.');
                                                            $('#solicitudCreditoID').val(nSolicitudSelec);
                                                            setTimeout("$('#solicitudCreditoID').focus().select();",0);
                                                        } else {
                                                            // seleccionamos primero el prospecto y luego el cliente
                                                            if (prospecto != 0 && cliente == 0) {
                                                                var beanprosig = {
                                                                        'prospectoID' : prospecto,
                                                                        'cliente' : cliente
                                                                };
                                                                prospectosServicio.consulta(2, beanprosig,function(prospdes) {
                                                                            if (prospdes != null) {
                                                                                if (prospdes.sexo == 'F') {
                                                                                    if (prospdes.estadoCivil == 'S') {
                                                                                        numeroms = numeroms + 1;
                                                                                    }
                                                                                    numerom = numerom + 1;
                                                                                } else {
                                                                                    numeroh = numeroh + 1;
                                                                                }
                                                                            }
                                                                            if (numeroms > maxms) {
                                                                                if (cliente != 0) {
                                                                                    setTimeout("$('#clienteID').focus().select();",0);
                                                                                } else {
                                                                                    setTimeout("$('#prospectoID').focus().select();",0);
                                                                                }

                                                                                if (maxms == 0) {
                                                                                    mensajeSis('El Producto de Crédito no Admite Mujeres Solteras.');
                                                                                } else {
                                                                                    mensajeSis('Se ha Alcanzado el Número Máximo de Mujeres Solteras para el Grupo.');
                                                                                }
                                                                                validacion_maxminExitosa = true;
                                                                                deshabilitaBoton('agregar','submit');
                                                                                deshabilitaBoton('modificar','submit');
                                                                                deshabilitaBoton('liberar','submit');
                                                                                $('#liberar').hide();
                                                                            } else {
                                                                                if (numerom > maxm) {
                                                                                    if (cliente != 0) {
                                                                                        setTimeout("$('#clienteID').focus().select();",0);
                                                                                    } else {
                                                                                        setTimeout("$('#prospectoID').focus().select();",0);
                                                                                    }

                                                                                    if (maxm == 0) {
                                                                                        mensajeSis('El Producto de Crédito no Admite Mujeres.');
                                                                                    } else {
                                                                                        mensajeSis('Se ha Alcanzado el Número Máximo de Mujeres para el Grupo.');
                                                                                    }
                                                                                    validacion_maxminExitosa = true;
                                                                                    deshabilitaBoton('agregar','submit');
                                                                                    deshabilitaBoton('modificar','submit');
                                                                                    deshabilitaBoton('liberar','submit');
                                                                                    $('#liberar').hide();
                                                                                } else {
                                                                                    if (numeroh > maxh) {
                                                                                        if (cliente != 0) {
                                                                                            setTimeout("$('#clienteID').focus().select();",0);
                                                                                        } else {
                                                                                            setTimeout("$('#prospectoID').focus().select();",0);
                                                                                        }

                                                                                        if (maxh == 0) {
                                                                                            mensajeSis('El Producto de Crédito no Admite Hombres.');
                                                                                        } else {
                                                                                            mensajeSis('Se ha Alcanzado el Número Máximo de Hombres para el Grupo.');
                                                                                        }
                                                                                        validacion_maxminExitosa = true;
                                                                                        deshabilitaBoton('agregar','submit');
                                                                                        deshabilitaBoton('modificar','submit');
                                                                                        deshabilitaBoton('liberar','submit');
                                                                                        $('#liberar').hide();
                                                                                    } else {
                                                                                        if ((maxm - minms) < (numerom - numeroms)) {
                                                                                            if (cliente != 0) {
                                                                                                setTimeout("$('#clienteID').focus().select();",0);
                                                                                            } else {
                                                                                                setTimeout("$('#prospectoID').focus().select();",0);
                                                                                            }
                                                                                            if ((maxm - minms) == 0) {
                                                                                                mensajeSis('El Producto de Crédito Solo Admite Mujeres Solteras.');
                                                                                            } else {
                                                                                                mensajeSis('Se ha Alcanzado el Número Máximo de Mujeres con Estado Civil Diferente de Solteras para el Grupo.');
                                                                                            }
                                                                                            validacion_maxminExitosa = true;
                                                                                            deshabilitaBoton('agregar','submit');
                                                                                            deshabilitaBoton('modificar','submit');
                                                                                            deshabilitaBoton('liberar','submit');
                                                                                            $('#liberar').hide();
                                                                                        } else {
                                                                                            habilitaBoton('agregar','submit');
                                                                                            deshabilitaBoton('modificar','submit');
                                                                                            $('#simular').show();
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        });
                                                            }
                                                            if (cliente != 0) {
                                                                clienteServicio.consulta(1,cliente.toString(),"",function(clientedes) {
                                                                            if (clientedes != null) {
                                                                                if (clientedes.sexo == 'F') {
                                                                                    if (clientedes.estadoCivil == 'S') {
                                                                                        numeroms = numeroms + 1;
                                                                                    }
                                                                                    numerom = numerom + 1;
                                                                                } else {
                                                                                    numeroh = numeroh + 1;
                                                                                }

                                                                            }
                                                                            if (numeroms > maxms) {
                                                                                if (cliente != 0) {
                                                                                    setTimeout("$('#clienteID').focus().select();",0);
                                                                                } else {
                                                                                    setTimeout("$('#prospectoID').focus().select();",0);
                                                                                }

                                                                                if (maxms == 0) {
                                                                                    mensajeSis('El Producto de Crédito no Admite Mujeres Solteras.');
                                                                                } else {
                                                                                    mensajeSis('Se ha Alcanzado el Número Máximo de Mujeres Solteras para el Grupo.');
                                                                                }
                                                                                validacion_maxminExitosa = true;
                                                                                deshabilitaBoton('agregar','submit');
                                                                                deshabilitaBoton('modificar','submit');
                                                                                deshabilitaBoton('liberar','submit');
                                                                                $('#liberar').hide();
                                                                            } else {
                                                                                if (numerom > maxm) {
                                                                                    if (cliente != 0) {
                                                                                        setTimeout("$('#clienteID').focus().select();",0);
                                                                                    } else {
                                                                                        setTimeout("$('#prospectoID').focus().select();",0);
                                                                                    }

                                                                                    if (maxm == 0) {
                                                                                        mensajeSis('El Producto de Crédito no Admite Mujeres.');
                                                                                    } else {
                                                                                        mensajeSis('Se ha Alcanzado el Número Máximo de Mujeres para el Grupo.');
                                                                                    }
                                                                                    validacion_maxminExitosa = true;
                                                                                    deshabilitaBoton('agregar','submit');
                                                                                    deshabilitaBoton('modificar','submit');
                                                                                    deshabilitaBoton('liberar','submit');
                                                                                    $('#liberar').hide();
                                                                                } else {
                                                                                    if (numeroh > maxh) {
                                                                                        if (cliente != 0) {
                                                                                            setTimeout("$('#clienteID').focus().select();",0);
                                                                                        } else {
                                                                                            setTimeout("$('#prospectoID').focus().select();",0);
                                                                                        }

                                                                                        if (maxh == 0) {
                                                                                            mensajeSis('El Producto de Crédito no Admite Hombres.');
                                                                                        } else {
                                                                                            mensajeSis('Se ha Alcanzado el Número Máximo de Hombres para el Grupo.');
                                                                                        }
                                                                                        validacion_maxminExitosa = true;
                                                                                        deshabilitaBoton('agregar','submit');
                                                                                        deshabilitaBoton('modificar','submit');
                                                                                        deshabilitaBoton('liberar','submit');
                                                                                        $('#liberar').hide();
                                                                                    } else {
                                                                                        if ((maxm - minms) < (numerom - numeroms)) {
                                                                                            if (cliente != 0) {
                                                                                                setTimeout("$('#clienteID').focus().select();",0);
                                                                                            } else {
                                                                                                setTimeout("$('#prospectoID').focus().select();",0);
                                                                                            }
                                                                                            if ((maxm - minms) == 0) {
                                                                                                mensajeSis('El Producto de Crédito Solo Admite Mujeres Solteras.');
                                                                                            } else {
                                                                                                mensajeSis('Se ha Alcanzado el Número Máximo de Mujeres con Estado Civil Diferente de Solteras para el Grupo.');
                                                                                            }
                                                                                            validacion_maxminExitosa = true;
                                                                                            deshabilitaBoton('agregar','submit');
                                                                                            deshabilitaBoton('modificar','submit');
                                                                                            deshabilitaBoton('liberar','submit');
                                                                                            $('#liberar').hide();
                                                                                        } else {
                                                                                            habilitaBoton('agregar','submit');
                                                                                            deshabilitaBoton('modificar','submit');
                                                                                            $('#simular').show();
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        });
                                                            }
                                                        }
                                                    }

                                                }
                                            }
                                        }
                                    }
                                }

                            } else {
                                mensajeSis('El Grupo No Existe.');
                                validacion_maxminExitosa = true;
                                deshabilitaBoton('agregar','submit');
                                deshabilitaBoton('modificar','submit');
                                deshabilitaBoton('liberar','submit');
                                $('#liberar').hide();
                            }
                        });
                    } else {
                        // mensajeSis('No se igresaron caracteres
                        // validos para el Número de Grupo ');
                    }
                }
            } else {
                mensajeSis('El Producto de Crédito Ingresado No existe.');
                validacion_maxminExitosa = true;
                deshabilitaBoton('agregar', 'submit');
                deshabilitaBoton('modificar', 'submit');
                deshabilitaBoton('liberar', 'submit');
                $('#liberar').hide();
            }
        });

    }
    // return validacion_maxminExitosa;
}





/* *****************************CALENDARIO IRREGULAR *****************************************/

/* simulador de pagos libres de capital */
function simuladorPagosLibres(numTransac) {

    $('#numTransacSim').val(numTransac);
    var procedeCalculo = validaUltimaCuotaCapSimulador();
    if (procedeCalculo == 0) {
        var mandar = crearMontosCapital(numTransac);
        var diaHabilSig;
        if (mandar == 2) {
            var params = {};
            if ($('#calcInteresID').val() == 1) {
                switch ($('#tipoPagoCapital').val()) {
                case "C": // SI ES CRECIENTE
                    tipoLista = 1;
                    break;
                case "I": // SI ES IGUAL
                    tipoLista = 2;
                    break;
                case "L": // SI ES LIBRE
                    tipoLista = 3;
                    break;
                default:
                    tipoLista = 1;
                break;
                }
            } else {
                switch ($('#tipoPagoCapital').val()) {
                case "I": // SI ES IGUAL
                    tipoLista = 4;
                    break;
                case "L": // SI ES LIBRE
                    tipoLista = 5;
                    break;
                default:
                    tipoLista = 4;
                break;
                }
            }

            params['tipoLista'] = tipoLista;
            params['montoCredito'] = $('#montoSolici').asNumber();
            params['tasaFija'] = $('#tasaFija').val();
            params['producCreditoID'] = $('#productoCreditoID').val();
            params['clienteID'] = $('#clienteID').val();
            params['fechaInhabil'] = $('#fechInhabil').val();
            params['empresaID'] = parametroBean.empresaID;
            params['usuario'] = parametroBean.numeroUsuario;
            params['fecha'] = parametroBean.fechaSucursal;
            params['direccionIP'] = parametroBean.IPsesion;
            params['sucursal'] = $("#sucursalID").val();
            params['numTransaccion'] = $('#numTransacSim').val();
            params['numTransacSim'] = $('#numTransacSim').val();
            params['montosCapital'] = $('#montosCapital').val();
            params['montoComision'] = $('#montoComApert').asNumber();
            params['cobraSeguroCuota']  = $('#cobraSeguroCuota option:selected').val();
            params['cobraIVASeguroCuota']   = $('#cobraIVASeguroCuota option:selected').val();
            params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
            params['plazoID']           = $('#plazoID').val();
            params['tipoOpera']     = 1;
            params['cobraAccesorios']   = cobraAccesorios;


            bloquearPantallaAmortizacion();
            var numeroError = 0;
            var mensajeTransaccion = "";
            $.post("simPagLibresCredito.htm", params, function(data) {
                if (data.length > 0) {
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
                        // actualiza la nueva fecha de vencimiento que devuelve el
                        // cotizador
                        var jqFechaVen = eval("'#valorFecUltAmor'");
                        $('#fechaVencimiento').val($(jqFechaVen).val());
                        // actualiza el numero de cuotas generadas por el cotizador
                        $('#numAmortInteres').val($('#valorCuotasInteres').val());
                        $('#numAmortizacion').val($('#valorCuotasCapital').val());
                        habilitarBotonesSol();
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

                        $('#CAT').val($('#valorCat').val());
                        $('#CAT').formatCurrency({
                            positiveFormat : '%n',
                            roundToDecimalPlace : 1
                        });
                        $("#ExportarExcel").css({display:"block"});
                        $("#imprimirRep").css({display:"block"});
                    }
                } else {
                    $('#contenedorSimulador').html("");
                    $('#contenedorSimulador').show();
                }
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

function mostrarGridLibresEncabezado() {
    var data;
    var cobraSeguroCuota = $('#cobraSeguroCuota option:selected').val();
    data = '<input type="hidden" value="0" name="numeroDetalle" id="numeroDetalle" />'
        + '<fieldset class="ui-widget ui-widget-content ui-corner-all">'
        + '<legend>Simulador de Amortizaciones</legend>'
        + '<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">'
        + '<tr>'
        + '<td class="label" align="center"><label for="lblNumero">N&uacute;mero</label></td>'
        + '<td class="label" align="center"><label for="lblFecIni">Fecha Inicio</label></td>'
        + '<td class="label" align="center"><label for="lblFecFin">Fecha Vencimiento</label> </td>  '
        + '<td class="label" align="center"><label for="lblFecPag">Fecha Pago</label></td>'
        + '<td class="label" align="center"><label for="lblCapital">Capital</label></td> '
        + '<td class="label" align="center"><label for="lblDescripcion">Inter&eacute;s</label></td> '
        + '<td class="label" align="center"><label for="lblCargos">IVA Inter&eacute;s</label></td> ';
        if(cobraSeguroCuota == 'S'){
            data += '<td class="label" align="center"><label for="lblSeguroCuota">Seguro</label></td> '
                 + '<td class="label" align="center"><label for="lblSeguroCuota">IVA Seguro</label></td> ';
        }

        if(cobraAccesoriosGen == 'S'){
            data += '<td class="label" align="center"><label for="lblComisiones">Comisiones</label></td> '
                 + '<td class="label" align="center"><label for="lblIVAOtrasComisiones">IVA Otras Comisiones</label></td> ';
        }
        data += '<td class="label" align="center"><label for="lblTotalPag">Total Pago</label></td> '
        + '<td class="label" align="center"><label for="lblSaldoCap">Saldo Capital</label></td> '
        + '<td class="label" align="center"><label for="lblAgregaElimina"></label></td> '
        + '</tr>' + '</table>' + '</fieldset>';

    $('#contenedorSimuladorLibre').html(data);
    $('#contenedorSimuladorLibre').show();
    $('#contenedorSimulador').html("");
    $('#contenedorSimulador').hide();
    mostrarGridLibresDetalle();
}

function mostrarGridLibresDetalle() {
    var cobraSeguroCuota = $('#cobraSeguroCuota option:selected').val();
    var numeroFila = document.getElementById("numeroDetalle").value;
    var nuevaFila = parseInt(numeroFila) + 1;
    var filaAnterior = parseInt(nuevaFila) - 1;
    var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
    var valorDiferencia = $('#diferenciaCapital').asNumber();
    var valorSumaCapital=$('#totalCap').asNumber();
    if (numeroFila == 0) {
        tds += '<td><input type="text" id="consecutivoID'+ nuevaFila+ '" name="consecutivoID" size="4" value="1" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="fechaInicio' + nuevaFila+ '"  name="fechaInicio" size="15" value="'+ $('#fechaInicioAmor').val()+ '" readonly="true" disabled="true"/></td>';
        tds += '<td align="center"><input type="text" id="fechaVencim'+ nuevaFila+ '" name="fechaVencim" size="15" value="" onblur="comparaFechas(this.id)"/></td>';
        tds += '<td align="center"><input type="text" id="fechaExigible'+ nuevaFila+ '" name="fechaExigible" size="15" value=" " readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="capital'+ nuevaFila+ '" name="capital" size="18" style="text-align: right;" value="" esMoneda="true"'+ '  onblur="agregaFormatoMonedaGrid(this.id);calculaDiferenciaSimuladorLibre()"/></td>';
        tds += '<td><input type="text" id="interes'+ nuevaFila+ '" name="interes" size="18" style="text-align: right;" value="" esMoneda="true" readonly="true"  disabled="true"/></td>';
        tds += '<td><input type="text" id="ivaInteres'+ nuevaFila+ '" name="ivaInteres" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
        if(cobraSeguroCuota == 'S'){
            tds += '<td><input id="montoSeguroCuota'+ nuevaFila+ '" name="montoSeguroCuotaSim" size="18" style="text-align: right;" type="text" style="text-align: right;" value="" readonly="readonly" disabled="disabled" esMoneda="true" /></td>';
            tds += '<td><input id="iVASeguroCuota'+ nuevaFila+ '" name="iVASeguroCuota" size="18" style="text-align: right;" type="text" style="text-align: right;" value="" readonly="readonly" disabled="disabled" esMoneda="true" /></td>';
        }
        if(cobraAccesoriosGen == 'S'){
            tds += '<td><input id="otrasComisiones'+ nuevaFila+ '" name="otrasComisiones" size="18" style="text-align: right;" type="text" style="text-align: right;" value="" readonly="readonly" disabled="disabled" esMoneda="true" /></td>';
            tds += '<td><input id="IVAotrasComisiones'+ nuevaFila+ '" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" style="text-align: right;" value="" readonly="readonly" disabled="disabled" esMoneda="true" /></td>';
        }
        tds += '<td><input type="text" id="totalPago'+ nuevaFila+ '" name="totalPago" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="saldoInsoluto'+ nuevaFila+ '" name="saldoInsoluto" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';

    } else {
        $('#trBtnCalcular').remove();
        $('#trDiferenciaCapital').remove();
        $('#filaTotales').remove();
        var valor = parseInt(document.getElementById("consecutivoID"
                + numeroFila + "").value) + 1;
        tds += '<td><input type="text" id="consecutivoID' + nuevaFila+ '" name="consecutivoID" size="4" value="' + valor+ '" autocomplete="off" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="fechaInicio' + nuevaFila+ '"  name="fechaInicio" size="15" value="'+ $('#fechaVencim' + filaAnterior).val()+ '" readonly="true" disabled="true"/></td>';
        tds += '<td align="center"><input type="text" id="fechaVencim'+ nuevaFila+ '" name="fechaVencim" size="15" value="" onblur="comparaFechas(this.id)" /></td>';
        tds += '<td align="center"><input type="text" id="fechaExigible'+ nuevaFila+ '" name="fechaExigible" size="15" value="" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="capital'+ nuevaFila+ '" name="capital" size="18" style="text-align: right;" value="" esMoneda="true" '+ '  onblur="agregaFormatoMonedaGrid(this.id);calculaDiferenciaSimuladorLibre()"/></td>';
        tds += '<td><input type="text" id="interes'+ nuevaFila+ '" name="interes" size="18" style="text-align: right;" value="" esMoneda="true" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="ivaInteres'+ nuevaFila+ '" name="ivaInteres" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
        if(cobraSeguroCuota == 'S'){
            tds += '<td><input id="montoSeguroCuota'+ nuevaFila+ '" name="montoSeguroCuotaSim" size="18" style="text-align: right;" type="text" style="text-align: right;" value="" readonly="readonly" disabled="disabled" esMoneda="true" /></td>';
            tds += '<td><input id="iVASeguroCuota'+ nuevaFila+ '" name="iVASeguroCuota" size="18" style="text-align: right;" type="text" style="text-align: right;" value="" readonly="readonly" disabled="disabled" esMoneda="true" /></td>';
        }
        if(cobraAccesoriosGen == 'S'){
            tds += '<td><input id="otrasComisiones'+ nuevaFila+ '" name="otrasComisiones" size="18" style="text-align: right;" type="text" style="text-align: right;" value="" readonly="readonly" disabled="disabled" esMoneda="true" /></td>';
            tds += '<td><input id="IVAotrasComisiones'+ nuevaFila+ '" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" style="text-align: right;" value="" readonly="readonly" disabled="disabled" esMoneda="true" /></td>';
        }
        tds += '<td><input type="text" id="totalPago'+ nuevaFila+ '" name="totalPago" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="saldoInsoluto'+ nuevaFila+ '" name="saldoInsoluto" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';

    }
    tds += '<td nowrap="nowrap"><input type="button" name="elimina" id="' + nuevaFila + '" value="" class="btnElimina" onclick="eliminaAmort(this)"/>';
    tds += '<input type="button" name="agrega" id="agrega' + nuevaFila + '" value="" class="btnAgrega" onclick="agregaNuevaAmort()"/></td>';
    tds += '</tr>';
    tds += '<tr id="filaTotales">' + '<td colspan="4" align="right"><label for="lblTotales">Totales: </label></td>';
    tds += '<td>' + '<input id="totalCap" name="totalCap"  size="18" readOnly="true" style="text-align: right;" value="' + valorSumaCapital + '"esMoneda="true"/>' + '</td>';
    tds += '</tr>';
    tds += '</tr>';
    tds += '<tr id="trDiferenciaCapital" >';
    tds += '<td colspan="4" align="right"><label for="Diferencia">Diferencia: </label></td>';
    tds += '<td  id="inputDiferenciaCap">' + '<input type="text" id="diferenciaCapital" name="diferenciaCapital" size="18" style="text-align: right;" value="' + valorDiferencia + '" esMoneda="true" readonly="true" disabled="true"/>' + '</td>';
    tds += '<td colspan="5"></td>';
    tds += '</tr>';
    tds += '<tr id="trBtnCalcular" >';
    tds += '<td  id="btnCalcularLibre" colspan="12" align="right">' + '<input type="button" class="submit" id="calcular" tabindex="37" value="Calcular" onclick="simuladorLibresCapFec();"/>' + '</td>';
    tds += '<td>' + '<input type="button" id="imprimirRep" class="submit" style="display:none;" value="Imprimir" onclick="generaReporte();"/>'+ '</td></tr>';

    document.getElementById("numeroDetalle").value = nuevaFila;
    $('#miTabla').append(tds);
    sugiereFechaSimuladorLibre();

    deshabilitaBoton('modificar', 'submit');
    deshabilitaBoton('liberar', 'submit');
    $('#liberar').hide();
    deshabilitaBoton('agregar', 'submit');
    agregaFormatoControles('formaGenerica');
}


function agregaNuevaAmort() {
    var cobraSeguroCuota = $('#cobraSeguroCuota option:selected').val();
    var numeroFila = document.getElementById("numeroDetalle").value;
    var nuevaFila = parseInt(numeroFila) + 1;
    var filaAnterior = parseInt(nuevaFila) - 1;
    var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
    var valorDiferencia = $('#diferenciaCapital').asNumber();
    var valorSumaCapital = $('#totalCap').asNumber();
    if (numeroFila == 0) {
        $('#trBtnCalcular').remove();
        $('#trDiferenciaCapital').remove();
        $('#filaTotales').remove();
        tds += '<td><input type="text" id="consecutivoID'+ nuevaFila+ '" name="consecutivoID" size="4" value="1" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="fechaInicio'+ nuevaFila + '"  name="fechaInicio" size="15" value="'+ $('#fechaInicioAmor').val()+ '" readonly="true" disabled="true"/></td>';
        tds += '<td align="center"><input type="text" id="fechaVencim'+ nuevaFila+ '" name="fechaVencim" size="15" value="" onblur="comparaFechas(this.id);"  /></td>';
        tds += '<td align="center"><input type="text" id="fechaExigible'+ nuevaFila+ '" name="fechaExigible" size="15" value="" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="capital' + nuevaFila + '" name="capital" size="18" style="text-align: right;" value="" esMoneda="true" ' + '  onblur="agregaFormatoMonedaGrid(this.id);calculaDiferenciaSimuladorLibre()"/></td>';
        tds += '<td><input type="text" id="interes' + nuevaFila + '" name="interes" size="18" style="text-align: right;" value="" esMoneda="true" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="ivaInteres' + nuevaFila + '" name="ivaInteres" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
        if(cobraSeguroCuota == 'S'){
            tds += '<td><input id="montoSeguroCuota'+ nuevaFila+ '" name="montoSeguroCuotaSim" size="18" style="text-align: right;" type="text" style="text-align: right;" value="" readonly="readonly" disabled="disabled" esMoneda="true" /></td>';
            tds += '<td><input id="iVASeguroCuota'+ nuevaFila+ '" name="iVASeguroCuota" size="18" style="text-align: right;" type="text" style="text-align: right;" value="" readonly="readonly" disabled="disabled" esMoneda="true" /></td>';
        }
        if(cobraAccesoriosGen == 'S'){
            tds += '<td><input id="otrasComisiones'+ nuevaFila+ '" name="otrasComisiones" size="18" style="text-align: right;" type="text" style="text-align: right;" value="" readonly="readonly" disabled="disabled" esMoneda="true" /></td>';
            tds += '<td><input id="IVAotrasComisiones'+ nuevaFila+ '" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" style="text-align: right;" value="" readonly="readonly" disabled="disabled" esMoneda="true" /></td>';
        }
        tds += '<td><input type="text" id="totalPago' + nuevaFila + '" name="totalPago" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="saldoInsoluto' + nuevaFila + '" name="saldoInsoluto" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';

    } else {
        $('#trBtnCalcular').remove();
        $('#trDiferenciaCapital').remove();
        $('#filaTotales').remove();
        var valor = parseInt(document.getElementById("consecutivoID"+ numeroFila + "").value) + 1;
        tds += '<td><input type="text" id="consecutivoID' + nuevaFila + '" name="consecutivoID" size="4" value="' + valor + '" autocomplete="off" readonly="true" disabled="true" /></td>';
        tds += '<td><input type="text" id="fechaInicio' + nuevaFila + '"  name="fechaInicio" size="15" value="' + $('#fechaVencim' + filaAnterior).val() + '" readonly="true" disabled="true"/></td>';
        tds += '<td align="center"><input type="text" id="fechaVencim' + nuevaFila + '" name="fechaVencim" size="15" value="" onblur="comparaFechas(this.id)" /></td>';
        tds += '<td align="center"><input type="text" id="fechaExigible' + nuevaFila + '" name="fechaExigible" size="15" value="" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="capital' + nuevaFila + '" name="capital" size="18" style="text-align: right;" value="" esMoneda="true"' + '  onblur="agregaFormatoMonedaGrid(this.id);calculaDiferenciaSimuladorLibre()"/></td>';
        tds += '<td><input type="text" id="interes' + nuevaFila + '" name="interes" size="18" style="text-align: right;" value="" esMoneda="true" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="ivaInteres' + nuevaFila + '" name="ivaInteres" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
        if(cobraSeguroCuota == 'S'){
            tds += '<td><input id="montoSeguroCuota'+ nuevaFila+ '" name="montoSeguroCuotaSim" size="18" style="text-align: right;" type="text" style="text-align: right;" value="" readonly="readonly" disabled="disabled" esMoneda="true" /></td>';
            tds += '<td><input id="iVASeguroCuota'+ nuevaFila+ '" name="iVASeguroCuota" size="18" style="text-align: right;" type="text" style="text-align: right;" value="" readonly="readonly" disabled="disabled" esMoneda="true" /></td>';
        }
        if(cobraAccesoriosGen == 'S'){
            tds += '<td><input id="otrasComisiones'+ nuevaFila+ '" name="otrasComisiones" size="18" style="text-align: right;" type="text" style="text-align: right;" value="" readonly="readonly" disabled="disabled" esMoneda="true" /></td>';
            tds += '<td><input id="IVAotrasComisiones'+ nuevaFila+ '" name="IVAotrasComisiones" size="18" style="text-align: right;" type="text" style="text-align: right;" value="" readonly="readonly" disabled="disabled" esMoneda="true" /></td>';
        }
        tds += '<td><input type="text" id="totalPago' + nuevaFila + '" name="totalPago" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="saldoInsoluto' + nuevaFila + '" name="saldoInsoluto" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
    }
    tds += '<td nowrap="nowrap"><input type="button" name="elimina" id="' + nuevaFila + '" value="" class="btnElimina" onclick="eliminaAmort(this)"/>' + '<input type="button" name="agrega" id="agrega' + nuevaFila + '" value="" class="btnAgrega" onclick="agregaNuevaAmort()"/></td>';
    tds += '</tr>';
    tds += '<tr id="filaTotales">' + '<td colspan="4" align="right"><label for="lblTotales">Totales: </label></td>';
    tds += '<td>'+'<input id="totalCap" name="totalCap"  size="18" readOnly="true" style="text-align: right;" value="' + valorSumaCapital + '"esMoneda="true"/>' + '</td>';
    tds += '</tr>';
    tds += '<tr id="trDiferenciaCapital" >';
    tds += '<td colspan="4" align="right"><label for="Diferencia">Diferencia: </label></td>';
    tds += '<td  id="inputDiferenciaCap">' + '<input type="text" id="diferenciaCapital" name="diferenciaCapital" size="18" style="text-align: right;" value="' + valorDiferencia + '" esMoneda="true" readonly="true" disabled="true"/>' + '</td>';
    tds += '<td colspan="5"></td>' + '</tr>';
    tds += '<tr id="trBtnCalcular" >';
    tds += '<td  id="btnCalcularLibre" colspan="12" align="right">' + '<input type="button" class="submit" id="calcular" tabindex="37" value="Calcular" onclick="simuladorLibresCapFec();"/>' + '</td>';
    tds += '<td>' + '<input type="button" id="imprimirRep" class="submit" style="display:none;" value="Imprimir" onclick="generaReporte();"/>'+ '</td></tr>';

    document.getElementById("numeroDetalle").value = nuevaFila;
    $("#miTabla").append(tds);
    sugiereFechaSimuladorLibre();
    calculaDiferenciaSimuladorLibre();
    calculoTotalCapital();
    calculoTotalInteres();
    calculoTotalIva();
    return false;
}

/* funcion para eliminar una amortizacion */
function eliminaAmort(control) {
    var contador = 1;
    var numeroID = control.id;
    var cobraSeguroCuota = $('#cobraSeguroCuota option:selected').val();
    var jqTr = eval("'#renglon" + numeroID + "'");

    var jqConsecutivoID = eval("'#consecutivoID" + numeroID + "'");
    var jqFechaInicio = eval("'#fechaInicio" + numeroID + "'");
    var jqFechaVencim = eval("'#fechaVencim" + numeroID + "'");
    var jqFechaExigible = eval("'#fechaExigible" + numeroID + "'");
    var jqCapital = eval("'#capital" + numeroID + "'");
    var jqInteres = eval("'#interes" + numeroID + "'");
    var jqIvaInteres = eval("'#ivaInteres" + numeroID + "'");
    var jqMontoSeguro = eval("'#montoSeguro" + numeroID + "'");
    var jqIVASeguroCuota = eval("'#iVASeguroCuota" + numeroID + "'");
    var jqMontoOtrasComisiones = eval("'#otrasComisiones" + numeroID + "'");
    var jqIVAOtrasComisiones = eval("'#IVAotrasComisiones" + numeroID + "'");
    var jqTotalPago = eval("'#totalPago" + numeroID + "'");
    var jqSaldoInsoluto = eval("'#saldoInsoluto" + numeroID + "'");
    var jqElimina = eval("'#" + numeroID + "'");
    var jqAgrega = eval("'#agrega" + numeroID + "'");

    /*
     * FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y
     * LAS FILAS CONTINUEN DE MANERA COHERENTE.
     */
    var continuar = ajustaValoresFechaElimina(numeroID, jqFechaInicio);

    if (continuar == 1) {
        $(jqConsecutivoID).remove();
        $(jqFechaInicio).remove();
        $(jqFechaVencim).remove();
        $(jqFechaExigible).remove();
        $(jqCapital).remove();
        $(jqInteres).remove();
        $(jqIvaInteres).remove();
        $(jqMontoSeguro).remove();
        $(jqIVASeguroCuota).remove();
        $(jqMontoOtrasComisiones).remove();
        $(jqIVAOtrasComisiones).remove();
        $(jqTotalPago).remove();
        $(jqSaldoInsoluto).remove();
        $(jqElimina).remove();
        $(jqAgrega).remove();
        $(jqTr).remove();

        // se asigna el numero de detalle que quedan
        var elementos = document.getElementsByName("renglon");
        $('#numeroDetalle').val(elementos.length);
        /* SE COMPARA SI QUEDA MAS DE UNA FILA */
        if ($('#numeroDetalle').asNumber() > 0) {
            // Reordenamiento de Controles
            contador = 1;
            var numero = 0;
            $('tr[name=renglon]').each(function() {
                numero = this.id.substr(7, this.id.length);
                var jqRenglonCiclo = eval("'renglon" + numero + "'");
                var jqNumeroCiclo = eval("'consecutivoID" + numero + "'");
                var jqFechaInicio = eval("'fechaInicio" + numero + "'");
                var jqFechaVencim = eval("'fechaVencim" + numero + "'");
                var jqAgrega = eval("'agrega" + numero + "'");
                var jqFechaExigible = eval("'fechaExigible" + numero + "'");
                var jqCapital = eval("'capital" + numero + "'");
                var jqInteres = eval("'interes" + numero + "'");
                var jqIvaInteres = eval("'ivaInteres" + numero + "'");
                if(cobraSeguroCuota == 'S'){
                    var jqMontoSeg = eval("'montoSeguroCuota" + numero + "'");
                    var jqiVASeguroCuo = eval("'iVASeguroCuota" + numero + "'");
                }
                if(cobraAccesoriosGen == 'S'){
                    var jqMontoSeg = eval("'otrasComisiones" + numero + "'");
                    var jqiVASeguroCuo = eval("'IVAotrasComisiones" + numero + "'");
                }
                var jqTotalPago = eval("'totalPago" + numero + "'");
                var jqSaldoInsoluto = eval("'saldoInsoluto" + numero + "'");
                var jqElimina = eval("'" + numero + "'");

                document.getElementById(jqNumeroCiclo).setAttribute('value', contador);
                document.getElementById(jqRenglonCiclo).setAttribute('id', "renglon" + contador);
                document.getElementById(jqNumeroCiclo).setAttribute('id', "consecutivoID" + contador);
                document.getElementById(jqFechaInicio).setAttribute('id', "fechaInicio" + contador);
                document.getElementById(jqFechaVencim).setAttribute('id', "fechaVencim" + contador);
                document.getElementById(jqAgrega).setAttribute('id', "agrega" + contador);
                document.getElementById(jqFechaExigible).setAttribute('id', "fechaExigible" + contador);
                document.getElementById(jqCapital).setAttribute('id', "capital" + contador);
                document.getElementById(jqInteres).setAttribute('id', "interes" + contador);
                document.getElementById(jqIvaInteres).setAttribute('id', "ivaInteres" + contador);
                if(cobraSeguroCuota == 'S'){
                    document.getElementById(jqMontoSeg).setAttribute('id', "montoSeguroCuotaSim" + contador);
                    document.getElementById(jqiVASeguroCuo).setAttribute('id', "iVASeguroCuota" + contador);
                }
                if(cobraAccesoriosGen == 'S'){
                    document.getElementById(jqMontoSeg).setAttribute('id', "otrasComisiones" + contador);
                    document.getElementById(jqiVASeguroCuo).setAttribute('id', "IVAotrasComisiones" + contador);
                }
                document.getElementById(jqTotalPago).setAttribute('id', "totalPago" + contador);
                document.getElementById(jqSaldoInsoluto).setAttribute('id', "saldoInsoluto" + contador);

                document.getElementById(jqElimina).setAttribute('id', contador);

                contador = parseInt(contador + 1);
            });
            calculaDiferenciaSimuladorLibre();
            calculoTotalCapital();
            calculoTotalInteres();
            calculoTotalIva();
        } else {
            /* si el usuario elimina la ultima fila, se agrega una fila nueva */
            agregaNuevaAmort();
        }
    }

}

/*
 * funcion para sugerir fecha y monto de acuerdo a lo que ya se habia indicado
 * en el formulario.
 */
function sugiereFechaSimuladorLibre() {
    var numDetalle = $('input[name=fechaVencim]').length;
    var varFechaVenID = eval("'#fechaVencim" + numDetalle + "'");
    $(varFechaVenID).val($('#fechaVencimiento').val());
    $(varFechaVenID).focus();
    var varCapitalID = eval("'#capital" + numDetalle + "'");
    if (numDetalle > 1) {
        $(varCapitalID).val($('#diferenciaCapital').val());
        $('#diferenciaCapital').val("0.00");
        $(varCapitalID).formatCurrency({
            positiveFormat : '%n',
            roundToDecimalPlace : 2
        });
    } else {
        $(varCapitalID).val($('#montoSolici').val());
        $(varCapitalID).formatCurrency({
            positiveFormat : '%n',
            roundToDecimalPlace : 2
        });
    }
}

function verificarvaciosCapFec() {
    var numAmortizacion = $('input[name=capital]').length;
    $('#montosCapital').val("");
    var regresar = 1;
    for ( var i = 1; i <= numAmortizacion; i++) {
        var jqfechaInicio = eval("'#fechaInicio" + i + "'");
        var jqfechaVencim = eval("'#fechaVencim" + i + "'");
        var valFecIni = document.getElementById("fechaInicio" + i).value;
        var valFecVen = document.getElementById("fechaVencim" + i).value;

        if (valFecIni == "") {
            document.getElementById("fechaInicio" + i).focus();
            $(jqfechaInicio).addClass("error");
            regresar = 1;
            mensajeSis("Especifique Fecha de Inicio");
            i = numAmortizacion + 2;
        } else {
            regresar = 3;
            $(jqfechaInicio).removeClass("error");
        }

        if (valFecVen == "") {
            document.getElementById("fechaVencim" + i).focus();
            $(jqfechaVencim).addClass("error");
            mensajeSis("Especifique Fecha de Vencimiento");
            regresar = 1;
            i = numAmortizacion + 2;
        } else {
            regresar = 4;
            $(jqfechaVencim).removeClass("error");
        }
    }
    return regresar;
}

//funcion para validar que la fecha de vencimiento indicada sea mayor a la de
//inicio
function comparaFechas(varid) {
    var fila = varid.substr(11, varid.length);
    var jqFechaIni = eval("'#fechaInicio" + fila + "'");
    var jqFechaVen = eval("'#fechaVencim" + fila + "'");

    var fechaIni = $(jqFechaIni).val();
    var fechaVen = $(jqFechaVen).val();
    var xYear = fechaIni.substring(0, 4);
    var xMonth = fechaIni.substring(5, 7);
    var xDay = fechaIni.substring(8, 10);
    var yYear = fechaVen.substring(0, 4);
    var yMonth = fechaVen.substring(5, 7);
    var yDay = fechaVen.substring(8, 10);
    if ($(jqFechaVen).val() != "") {
        if (esFechaValida($(jqFechaVen).val(), jqFechaVen)) {
            if (validaFechaVencimientoGrid($(jqFechaVen).val(), $(
            '#fechaVencimiento').val(), jqFechaVen, fila)) {
                if (yYear < xYear) {
                    mensajeSis("La Fecha Indicada debe ser Mayor a la Fecha de Inicio.");
                    document.getElementById("fechaVencim" + fila).focus();
                    $("#fechaVencim" + fila).val("");
                    $(jqFechaVen).addClass("error");
                } else {
                    if (xYear == yYear) {
                        if (yMonth < xMonth) {
                            mensajeSis("La Fecha Indicada debe ser Mayor a la Fecha de Inicio.");
                            document.getElementById("fechaVencim" + fila).focus();
                            $("#fechaVencim" + fila).val("");
                            $(jqFechaVen).addClass("error");

                        } else {
                            if (xMonth == yMonth) {
                                if (yDay < xDay || yDay == xDay) {
                                    mensajeSis("La Fecha Indicada debe ser Mayor a la Fecha de Inicio.");
                                    document.getElementById("fechaVencim" + fila).focus();
                                    $("#fechaVencim" + fila).val("");
                                    $(jqFechaVen).addClass("error");
                                } else {
                                    /* FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y LAS FILAS
                                     * CONTINUEN DE MANERA COHERENTE. */
                                    comparaFechaModificadaSiguiente(fila, jqFechaVen, jqFechaIni);
                                }
                            } else {
                                /*  FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y LAS FILAS
                                 * CONTINUEN DE MANERA COHERENTE. */
                                comparaFechaModificadaSiguiente(fila, jqFechaVen, jqFechaIni);

                            }
                        }
                    } else {
                        /*  FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE  MODIFICA O ELIMIMA Y LAS FILAS CONTINUEN DE MANERA
                         * COHERENTE.  */
                        comparaFechaModificadaSiguiente(fila, jqFechaVen, jqFechaIni);
                    }
                }
            } else {
                $(jqFechaVen).focus();
            }
        } else {
            $(jqFechaVen).focus();
        }
    }
}

//funcion para validar que la fecha de vencimiento No sea mayor a la de vencimiento calculada por los plazos.
function validaFechaVencimientoGrid(fechaVenGrid, fechaVenCred, jqFechaVen,
        fila) {
    var xYear = fechaVenCred.substring(0, 4);
    var xMonth = fechaVenCred.substring(5, 7);
    var xDay = fechaVenCred.substring(8, 10);

    var yYear = fechaVenGrid.substring(0, 4);
    var yMonth = fechaVenGrid.substring(5, 7);
    var yDay = fechaVenGrid.substring(8, 10);
    if (esFechaValida(fechaVenGrid)) {
        if (yYear > xYear) {
            mensajeSis("La Fecha debe ser Menor o Igual a la Fecha de Vencimiento.");
            document.getElementById("fechaVencim" + fila).focus();
            $(jqFechaVen).addClass("error");
            return false;
        } else {
            if (xYear == yYear) {
                if (yMonth > xMonth) {
                    mensajeSis("La Fecha debe ser Menor o Igual a la Fecha de Vencimiento.");
                    document.getElementById("fechaVencim" + fila).focus();
                    $(jqFechaVen).addClass("error");
                    return false;
                } else {
                    if (xMonth == yMonth) {
                        if (yDay > xDay) {
                            mensajeSis("La Fecha debe ser Menor o Igual a la Fecha de Vencimiento.");
                            document.getElementById("fechaVencim" + fila).focus();
                            $(jqFechaVen).addClass("error");
                            return false;
                        }
                    }
                }
            }
        }
    } else {
        $(jqFechaVen).focus();
    }
    return true;
}

/*  funcion para calcular la diferencia del monto con lo que se va poniendo en el  grid de pagos libres.  */
function calculaDiferenciaSimuladorLibre() {
    var sumaMontoCapturado = 0;
    var diferenciaMonto = 0;
    var numero = 0;
    var varCapitalID = "";
    var muestraAlert = true;
    $('input[name=capital]').each(function() {
                numero = this.id.substr(7, this.id.length);
                numDetalle = $('input[name=capital]').length;
                varCapitalID = eval("'#capital" + numero + "'");
                sumaMontoCapturado = sumaMontoCapturado
                + $(varCapitalID).asNumber();

                if (sumaMontoCapturado.toFixed(2) > $('#montoSolici').asNumber()) {
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
                    diferenciaMonto = $('#montoSolici').asNumber() - sumaMontoCapturado.toFixed(2);
                    $('#diferenciaCapital').val(diferenciaMonto);
                    $('#diferenciaCapital').formatCurrency({
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

// --------------- funcion para validar la fecha --------------------------
function esFechaValida(fecha, jcontrol) {
    if (fecha != undefined && fecha.value != "") {
        var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
        if (!objRegExp.test(fecha)) {
            mensajeSis("Formato de Fecha No Válido (aaaa-mm-dd).");
            $(jcontrol).val('');
            $(jcontrol).focus();
            return false;
        }

        var mes = fecha.substring(5, 7) * 1;
        var dia = fecha.substring(8, 10) * 1;
        var anio = fecha.substring(0, 4) * 1;

        switch (mes) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            numDias = 31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            numDias = 30;
            break;
        case 2:
            if (comprobarSiBisisesto(anio)) {
                numDias = 29;
            } else {
                numDias = 28;
            }
            ;
            break;
        default:
            mensajeSis("Fecha Introducida es Errónea.");
        return false;
        }
        if (dia > numDias || dia == 0) {
            mensajeSis("Fecha Introducida es Errónea.");
            return false;
        }
        return true;
    }
}

function comprobarSiBisisesto(anio) {
    if ((anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
        return true;
    } else {
        return false;
    }
}

/* Cancela las teclas [ ] en el formulario */
document.onkeypress = pulsarCorchete;
function pulsarCorchete(e) {
    tecla = (document.all) ? e.keyCode : e.which;
    if (tecla == 91 || tecla == 93) {
        return false;
    }
    return true;
}

//funcion para poner el formato de moneda en el Grid
function agregaFormatoMonedaGrid(controlID) {
    jqID = eval("'#" + controlID + "'");
    $(jqID).formatCurrency({
        positiveFormat : '%n',
        roundToDecimalPlace : 2
    });
}

/* Para ejecutar el simulador de pagos libres de capital y fecha cuando das clic en el boton calcular */
function simuladorLibresCapFec() {
    if(!validaFechas()){
        return false;
    }
    var mandar = "";
    var procedeCalculo = validaUltimaCuotaCapSimulador();
    if (procedeCalculo == "0") {
        mandar = crearMontosCapitalFecha();
        if (mandar == 2) {
            var params = {};
            if ($('#calcInteresID').val() == 1) {
                if ($('#calendIrregularCheck').is(':checked')) {
                    tipoLista = 7;
                } else {
                    switch ($('#tipoPagoCapital').val()) {
                    case "C": // si el tipo de pago es CRECIENTES
                        tipoLista = 1;
                        break;
                    case "I":// si el tipo de pago es IGUALES
                        tipoLista = 2;
                        break;
                    case "L": // si el tipo de pago es LIBRES
                        tipoLista = 3;
                        break;
                    default:
                        tipoLista = 1;
                    }
                }
            } else {
                if ($('#calendIrregularCheck').is(':checked')) {
                    tipoLista = 8;
                } else {
                    switch ($('#tipoPagoCapital').val()) {
                    case "I":// si el tipo de pago es IGUALES
                        tipoLista = 4;
                        break;
                    case "L": // si el tipo de pago es LIBRES
                        tipoLista = 5;
                        break;
                    default:
                        tipoLista = 4;
                    }
                }
            }

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

            params['tipoLista'] = tipoLista;
            params['montoCredito'] = $('#montoSolici').asNumber();
            params['tasaFija'] = $('#tasaFija').asNumber();
            params['fechaInhabil'] = $('#fechInhabil').val();
            params['empresaID'] = parametroBean.empresaID;
            params['usuario'] = parametroBean.numeroUsuario;
            params['fecha'] = parametroBean.fechaSucursal;
            params['direccionIP'] = parametroBean.IPsesion;
            params['sucursal'] = $("#sucursalID").val();
            params['montosCapital'] = $('#montosCapital').val();
            params['pagaIva'] = $('#pagaIva').val();
            params['iva'] = $('#iva').asNumber();
            params['producCreditoID'] = $('#productoCreditoID').val();
            params['clienteID'] = $('#clienteID').val();
            params['montoComision'] = $('#montoComApert').asNumber();
            params['cobraSeguroCuota']  = $('#cobraSeguroCuota option:selected').val();
            params['cobraIVASeguroCuota']   = $('#cobraIVASeguroCuota option:selected').val();
            params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
            params['plazoID']           = $('#plazoID').val();
            params['tipoOpera']     = 1;
            params['cobraAccesorios']   = cobraAccesorios;


            bloquearPantallaAmortizacion();
            var numeroError = 0;
            var mensajeTransaccion = "";
            $.post("simPagLibresCredito.htm", params, function(data) {

                if (data.length > 0) {
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
                        // actualiza la nueva fecha de vencimiento que devuelve el
                        // cotizador
                        var jqFechaVen = eval("'#valorFecUltAmor'");
                        $('#fechaVencimiento').val($(jqFechaVen).val());
                        $('#contenedorForma').unblock();
                        // actualiza el numero de cuotas generadas por el cotizador
                        $('#numAmortInteres').val($('#valorCuotasInteres').val());
                        $('#numAmortizacion').val($('#valorCuotasCapital').val());
                        habilitarBotonesSol();
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
                        $("#ExportarExcel").css({display:"block"});
                        $("#imprimirRep").css({display:"block"});
                        $('#CAT').val($('#valorCat').val());
                        $('#CAT').formatCurrency({
                            positiveFormat : '%n',
                            roundToDecimalPlace : 1
                        });
                    }
                } else {
                    $('#contenedorSimulador').html("");
                    $('#contenedorSimulador').hide();
                    $('#contenedorSimuladorLibre').html("");
                    $('#contenedorSimuladorLibre').hide();
                }
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

function validaFechas(){
    $('tr[name=renglon]').each(function() {
        var ID = this.id.substring(7);

        var jqFechaInicio = eval("'#fechaInicio" + ID + "'");
        var jqFechaVencim = eval("'#fechaVencim" + ID + "'");
        var jqFechaExigible = eval("'#fechaExigible" + ID + "'");
        var jqInteres = eval("'#interes" + ID + "'");
        var jqIvaInteres = eval("'#ivaInteres" + ID + "'");
        var jqTotalPago = eval("'#totalPago" + ID + "'");
        var jqSaldoInsoluto = eval("'#saldoInsoluto" + ID + "'");

        var fechaInicio = $(jqFechaInicio).val();
        var fechaVencim = $(jqFechaVencim).val();
        var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;

        if (!objRegExp.test(fechaVencim)) {
            mensajeSis("Formato de Fecha No Válido (aaaa-mm-dd).");
            $(jqFechaVencim).val('');
            $(jqFechaVencim).focus();
            return false;
        }

        if(fechaVencim < fechaInicio){
            $(jqFechaVencim).val('');
            $(jqFechaExigible).val('');
            $(jqInteres).val('');
            $(jqIvaInteres).val('');
            $(jqTotalPago).val('');
            $(jqSaldoInsoluto).val('');
            mensajeSis('La fecha de Vencimiento no puede ser Menor a la Fecha de Inicio.');
            $(jqFechaVencim).focus();
            return false;
        }
    });
    return true;
}

function crearMontosCapitalFecha() {
    var mandar = verificarvaciosCapFec();
    var regresar = 1;
    if (mandar != 1) {
        var suma = sumaCapital();
        if (suma != 1) {
            var numAmortizacion = $('input[name=capital]').length;
            $('#montosCapital').val("");
            for ( var i = 1; i <= numAmortizacion; i++) {
                var idCapital = eval("'#capital" + i + "'");
                if (i == 1) {
                    $('#montosCapital').val($('#montosCapital').val()
                            + i
                            + ']'
                            + $(idCapital).asNumber()
                            + ']'
                            + document.getElementById("fechaInicio" + i
                                    + "").value
                                    + ']'
                                    + document.getElementById("fechaVencim" + i
                                            + "").value);
                } else {
                    $('#montosCapital').val($('#montosCapital').val()
                            + '['
                            + i
                            + ']'
                            + $(idCapital).asNumber()
                            + ']'
                            + document.getElementById("fechaInicio" + i
                                    + "").value
                                    + ']'
                                    + document.getElementById("fechaVencim" + i
                                            + "").value);
                }
            }
            regresar = 2;
        } else {
            regresar = 1;
        }
    }
    return regresar;
}

//funcion para verificar que la suma del capital sea igual que la del monto
function sumaCapital() {
    var jqCapital;
    var suma = 0;
    var contador = 1;
    var capital;
    esTab = true;
    $('input[name=capital]').each(function() {
        jqCapital = eval("'#" + this.id + "'");
        capital = $(jqCapital).asNumber();
        if (capital != '' && !isNaN(capital) && esTab) {
            suma = suma + capital;
            contador = contador + 1;
            $(jqCapital).formatCurrency({
                positiveFormat : '%n',
                roundToDecimalPlace : 2
            });
        } else {
            $(jqCapital).val(0);
        }
    });
    if (suma.toFixed(2) != $('#montoSolici').asNumber()) {
        mensajeSis("La suma de Montos de Capital debe ser Igual al Monto Solicitado.");
        deshabilitaBoton('continuar', 'submit');
        return 1;
    }
}

function crearMontosCapital(numTransac) {
    var suma = sumaCapital();
    var idCapital = "";
    if (suma != 1) {
        $('#montosCapital').val("");
        for ( var i = 1; i <= $('input[name=capital]').length; i++) {
            idCapital = eval("'#capital" + i + "'");
            if ($(idCapital).asNumber() >= "0") {
                if (i == 1) {
                    $('#montosCapital').val(
                            $('#montosCapital').val() + i + ']'
                            + $(idCapital).asNumber() + ']'
                            + numTransac);
                } else {
                    $('#montosCapital').val(
                            $('#montosCapital').val() + '[' + i + ']'
                            + $(idCapital).asNumber() + ']'
                            + numTransac);
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

/*
 * FUNCION PARA VALIDAR QUE LA ULTIMA CUOTA DE CAPITAL EN EL COTIZADOR DE PAGOS
 * LIBRES EN CAPITAL O IRREGULAR NO SEA CERO.
 */
function validaUltimaCuotaCapSimulador() {
    var procede = 0;
    if ($('#tipoPagoCapital').val() == "L") {
        var numAmortizacion = $('input[name=capital]').length;
        for ( var i = 1; i <= numAmortizacion; i++) {
            if (i == numAmortizacion) {
                var idCapital = eval("'#capital" + i + "'");
                if ($(idCapital).asNumber() == 0) {
                    document.getElementById("capital" + i + "").focus();
                    document.getElementById("capital" + i + "").select();
                    $("capital" + i).addClass("error");
                    mensajeSis("La Última Cuota de Capital no puede ser Cero.");
                    procede = 1;
                } else {
                    if ($('#diferenciaCapital').asNumber() == 0) {
                        procede = 0;
                    } else {
                        mensajeSis(" La Suma de capital en Amortizaciones debe ser igual al Monto Solicitado.");
                        procede = 1;
                    }
                }
            } else {
                if ($('#diferenciaCapital').asNumber() == 0) {
                    procede = 0;
                } else {
                    mensajeSis(" La Suma de capital en Amortizaciones debe ser igual al Monto Solicitado.");
                    procede = 1;
                }
            }
        }
    } else {
        /*
         * se valida que si el tipo de pago de capital es libre, no se pueda  escoger como frecuencia la opcion de libre  */
        if ($('#frecuenciaInt').val() == "L"
            && $('#calendIrregular').val() == "N") {
            mensajeSis("La Frecuencia de Interés Libre sólo Aplica para Calendario Irregular.");
            $('#frecuenciaInt').focus();
            $('#frecuenciaInt').val("");
            procede = 1;
        } else {
            if ($('#frecuenciaCap').val() == "L"
                && $('#calendIrregular').val() == "N") {
                mensajeSis("La Frecuencia de Capital Libre sólo Aplica para Calendario Irregular.");
                $('#frecuenciaCap').focus();
                $('#frecuenciaCap').val("");
                procede = 1;
            } else {
                procede = 0;
            }
        }
    }
    return procede;
}

/*  FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y LAS  FILAS CONTINUEN DE MANERA COHERENTE.  */
function ajustaValoresFechaElimina(numeroID, jqFechaInicio) {
    var idCajaRenom = "";
    var siguiente = 0;
    var anterior = 0;
    var continuar = 0;
    var numFilas = $('input[name=fechaVencim]').length;

    if (numeroID <= numFilas) {
        if (numeroID == 1) {
            siguiente = parseInt(numeroID) + parseInt(1);
            idCajaRenom = eval("'#fechaInicio" + siguiente + "'");
            $(idCajaRenom).val($(jqFechaInicio).val());
            continuar = 1;
        } else {
            if (numeroID < numFilas) {
                siguiente = parseInt(numeroID) + parseInt(1);
                anterior = parseInt(numeroID) - parseInt(1);
                idCajaRenom = eval("'#fechaInicio" + siguiente + "'");
                jqFechaVencim = eval("'#fechaVencim" + anterior + "'");
                $(idCajaRenom).val($(jqFechaVencim).val());
                continuar = 1;
            } else {
                if (numeroID == numFilas) {
                    continuar = 1;
                }
            }
        }
    }
    return continuar;
}

/*  FUNCION PARA CAMBIAR EL VALOR SIGUIENTE DEL QUE SE MODIFICA O ELIMIMA Y LAS  FILAS CONTINUEN DE MANERA COHERENTE. */
function ajustaValoresFechaModifica(numeroID, jqFechaInicio) {
    var idCajaRenom = "";
    var siguiente = 0;
    var continuar = 0;
    var numFilas = $('input[name=fechaVencim]').length;

    if (numeroID <= numFilas) {
        if (numeroID < numFilas) {
            siguiente = parseInt(numeroID) + parseInt(1);
            idCajaRenom = eval("'#fechaInicio" + siguiente + "'");
            jqFechaVencim = eval("'#fechaVencim" + numeroID + "'");
            $(idCajaRenom).val($(jqFechaVencim).val());
            continuar = 1;
        } else {
            if (numeroID == numFilas) {
                continuar = 1;
            }
        }
    }
    return continuar;
}

/*  FUNCION PARA VALIDAR QUE LA FECHA DE VENCIMIENTO MODIFICADA NO SEA MAYO A LA  FECHA DE VENCIMIENTO SIGUIENTE */
function comparaFechaModificadaSiguiente(varid, jqFechaVen, jqFechaInicio) {
    var siguiente = parseInt(varid) + parseInt(1);
    var numFilas = $('input[name=fechaVencim]').length;
    if (varid < numFilas) {
        var jqFechaVenSiguiente = eval("'#fechaVencim" + siguiente + "'");

        var fechaIni = $(jqFechaVen).val();
        var fechaVen = $(jqFechaVenSiguiente).val();
        var xYear = fechaIni.substring(0, 4);
        var xMonth = fechaIni.substring(5, 7);
        var xDay = fechaIni.substring(8, 10);
        var yYear = fechaVen.substring(0, 4);
        var yMonth = fechaVen.substring(5, 7);
        var yDay = fechaVen.substring(8, 10);
        if ($(jqFechaVen).val() != "") {
            if (esFechaValida($(jqFechaVen).val(), jqFechaVen)) {
                if (validaFechaVencimientoGrid($(jqFechaVen).val(), $(
                '#fechaVencimiento').val(), jqFechaVen, varid)) {
                    if (yYear < xYear) {
                        mensajeSis("La Fecha Indicada debe ser Menor a la Fecha de Vencimiento \nde la siguiente Amortizazion.");
                        document.getElementById("fechaVencim" + varid).focus();
                        $(jqFechaVen).addClass("error");
                    } else {
                        if (xYear == yYear) {
                            if (yMonth <= xMonth) {
                                if (xMonth == yMonth) {
                                    if (yDay <= xDay || yDay == xDay) {
                                        mensajeSis("La Fecha Indicada debe ser Menor a la Fecha de Vencimiento \nde la siguiente Amortizazion.");
                                        document.getElementById("fechaVencim" + varid).focus();
                                        $(jqFechaVen).addClass("error");
                                    } else {
                                        ajustaValoresFechaModifica(varid, jqFechaInicio);
                                    }
                                } else {
                                    ajustaValoresFechaModifica(varid, jqFechaInicio);
                                }
                            } else {
                                ajustaValoresFechaModifica(varid, jqFechaInicio);
                            }
                        } else {
                            ajustaValoresFechaModifica(varid, jqFechaInicio);
                        }
                    }
                } else {
                    $(jqFechaVen).focus();
                }
            } else {
                $(jqFechaVen).focus();
            }
        }
    }
} // fin comparaFechaModificadaSiguiente



function consultaNomInstit(convenio) {

    deshabilitaControl('folioCtrl');
    var tipoCon = 1;
    if(manejaConvenio=='S'){
        tipoCon = 8;
        $('#folioCtrl').val("");
    }

    var institucion=$('#institucionNominaID').val();
    var cliente=$('#clienteID').val();
    if (institucion != ''  && !isNaN(institucion) && institucion >0 && esTab == true){
    var institNominaBean = {
            'institNominaID' : institucion,
            'clienteID' : cliente
    };
        institucionNomServicio.consulta(tipoCon, institNominaBean, function(institucionNomina) {
            if (institucionNomina != null){
                $('#nombreInstit').val(institucionNomina.nombreInstit);
                if(manejaConvenio=='S'){
                    $('#folioCtrl').val(institucionNomina.noEmpleado);
                    listaConveniosActivos(convenio);
                }
                if (esNomina === 'S'){
                	obtenerServiciosAdicionales();
                }
            }
            else {
                mensajeSis("La Empresa de Nómina no Existe.");
                $('#nombreInstit').val('');
                $('#institucionNominaID').val('');
                $('#institucionNominaID').focus();
                $('#folioCtrl').val("");
                if(manejaConvenio=='S'){
                dwr.util.removeAllOptions('convenioNominaID');
                dwr.util.addOptions('convenioNominaID', {'':'SELECCIONAR'});
                }
            }
        });
    } else {
        $('#nombreInstit').val('');
    }
}



function habilitarBotonesSol() {
    if ($('#solicitudCreditoID').val() == '0') {
        deshabilitaBoton('modificar', 'submit');
        deshabilitaBoton('liberar', 'submit');
        habilitaBoton('agregar', 'submit');
        $('#liberar').hide();

    } else {
        if ($('#estatus').val() != 'I') {
            if ($('#estatus').val() == 'A' || $('#estatus').val() == 'D'
                || $('#estatus').val() == 'L' || $('#estatus').val() == 'C') {
                deshabilitaBoton('modificar', 'submit');
                deshabilitaBoton('liberar', 'submit');
                deshabilitaBoton('agregar', 'submit');
                $('#liberar').hide();
            }
        } else {
            // si la solicitud es inactiva valida que el promotor pueda liberar la solicitud de credito si
            // corresponde con la sucursal  o si el promotor no atiende sucursal
            if ($('#sucursalID').asNumber() == $('#sucursalPromotor').val()
                    || $('#promAtiendeSuc').val() == 'N') {
                // si se trata de una solicitud individual entonces se muestra y  habilita
                // el boton de liberar, en caso contrario se oculta  si se trata de una solicitud individual entonces se muestra
                // el div  de comentarios, en caso contrario se oculta
                if ($('#grupo').val() != undefined) {
                    deshabilitaBoton('liberar', 'submit');
                    $('#liberar').hide();
                } else {
                    if ($('#flujoIndividualBandera').val() == undefined) {

                        // Validacion del boton Liberar
                        if(restringebtnLiberacionSol == 'S'){
                            if(rolUsuarioID == primerRolFlujoSolID || rolUsuarioID == segundoRolFlujoSolID ){
                                $('#liberar').show();
                                habilitaBoton('liberar', 'submit');
                            }else{
                                $('#liberar').hide();
                                deshabilitaBoton('liberar', 'submit');
                            }
                        }else{
                            $('#liberar').show();
                        habilitaBoton('liberar', 'submit');
                        }

                    } else {
                        $('#liberar').hide();
                        deshabilitaBoton('liberar', 'submit');
                    }
                }
                habilitaBoton('modificar', 'submit');
                deshabilitaBoton('agregar', 'submit');
                $('#simular').show();
            } else {
                $('#liberar').hide();
                deshabilitaBoton('liberar', 'submit');
                deshabilitaBoton('modificar', 'submit');
                deshabilitaBoton('agregar', 'submit');
            }
        }
    }
}

/*
 * Realiza las validaciones correspondientes para que se asigne un producto de credito correcto al cliente que solicita el credito
 */
function consultaRelacionCliente(controlID) {
    var tipoCon = 1;
    var beanParametros = {
            'empresaID' : 1

    };
    // Verifica que esta validacion este parametrizado como S = SI en  PARAMETROSIS
    parametrosSisServicio.consulta(tipoCon,beanParametros,function(parametros) {
                if (parametros != null && parametros.validaAutComite == 'S') {
                    tipoCon = 1;
                    var clienteID = $("#clienteID").val();
                    var prospectoID = $("#prospectoID").val();
                    var producCreditoID = $("#productoCreditoID").val();
                    var SiAutorizaComite = 'S';
                    var tipoCliente = '';

                    // verifica que el cliente y el producto de credito  sean válidos
                    if ((parseInt(clienteID) > 0 || parseInt(prospectoID) > 0) && producCreditoID != '' && producCreditoID != '0') {
                        if (clienteID == '' || clienteID == '0') {
                            clienteID = 0;
                            tipoCliente = 'Prospecto';
                        }
                        if (prospectoID == '' || prospectoID == '0') {
                            prospectoID = 0;
                            tipoCliente = $('#alertSocio').val();
                        }
                        var beanCliente = {
                                'clienteID' : clienteID,
                                'prospectoID' : prospectoID
                        };
                        var ProdCredBean = {
                                'producCreditoID' : producCreditoID

                        };

                        // consulta si el cliente es de tipo  Funcionario, Empleado, o si tiene relacion  con otro de tipo Funcionario o Empleado
                        relacionClienteServicio.consulta(tipoCon,beanCliente,function(respuesta) {

                                    if (respuesta != null) {
                                        productosCreditoServicio.consulta(tipoCon,ProdCredBean,
                                                function(prodCred) {
                                                    if (prodCred != null) {
                                                        if (prodCred.autorizaComite != SiAutorizaComite) {
                                                            if (controlID == 'clienteID') {
                                                                mensajeSis("El " + tipoCliente + " No Cumple con los Requerimientos del Producto de Crédito.");
                                                                $("#clienteID").val('');
                                                                $("#nombreCte").val('');
                                                                $("#clienteID").focus();
                                                            } else {
                                                                if (controlID == 'productoCreditoID') {
                                                                    mensajeSis("El Producto de Crédito No Aplica para las Características del " + tipoCliente + " Indicado.");
                                                                    $("#productoCreditoID").val('');
                                                                    $("#productoCreditoID").focus();
                                                                } else {
                                                                    mensajeSis("El Prospecto No cumple con los Requerimientos del Producto de Crédito.");
                                                                    $("#prospectoID").val('');
                                                                    $("#nombreProspecto").val('');
                                                                    $("#prospectoID").focus();
                                                                }
                                                            }
                                                        }
                                                    }
                                                });
                                    }
                                });
                    }
                }
            });
}

function calculoTotalCapital() {
    var sumaMontoCapturado = 0;
    var sumaMontos = 0;
    var numero = 0;
    var varCapitalID = "";
    var muestraAlert = true;
    $('input[name=capital]').each(function() {
                numero = this.id.substr(7, this.id.length);
                numDetalle = $('input[name=capital]').length;
                varCapitalID = eval("'#capital" + numero + "'");
                sumaMontoCapturado = sumaMontoCapturado + $(varCapitalID).asNumber();

                if (sumaMontoCapturado.toFixed(2) > $('#montoSolici').asNumber()) {
                    if (muestraAlert) {
                        mensajeSis("La Suma de Montos de Capital debe ser Igual al Monto Solicitado.");
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

function calculoTotalSeguros() {
    var sumaMontoCapturado = 0;
    var sumaMontos = 0;
    var numero = 0;
    var varCapitalID = "";
    $('input[name=montoSeguroCuotaSim]').each(function() {
                numero = this.id.substr(7, this.id.length);
                numDetalle = $('input[name=montoSeguroCuotaSim]').length;
                varCapitalID = eval("'#montoSeguroCuotaSim" + numero + "'");
                sumaMontoCapturado = sumaMontoCapturado + $(varCapitalID).asNumber();
                    sumaMonto= sumaMontoCapturado.toFixed(2);
                    $('#totalSeguroCuota').val(sumaMonto);
                    $('#totalSeguroCuota').formatCurrency({
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




/* Funcion que genera el reporte Proyeccion de Credito, para mostrar la tabla de amortizaciones generada por el simulador */
function generaReporte() {
    var clienteID = $("#clienteID").val();
    var nombreCliente = $("#nombreCte").val();
    var tipoReporte = 1; // PDF
    var nombreInstitucion = parametroBean.nombreInstitucion;
    var capitalPagar = $("#totalCap").asNumber();
    var interesPagar =  $("#totalInt").asNumber();
    var ivaPagar =  $("#totalIva").asNumber();
    var frecuencia = $("#frecuenciaCap").val();
    var frecuenciaInt = $("#frecuenciaInt").val();
    var frecuenciaDes =  $("#frecuenciaCap option:selected").html();
    var tasaFija = $("#tasaFija").val(); // tasa fija o tasa base

    var numCuotas = $("#numAmortizacion").asNumber();
    var numCuotasInt = $("#numAmortInteres").asNumber();
    var califCliente =  $("#calificaCredito").val() + "     " + calificacionCliente;
    var ejecutivo = parametroBean.nombreUsuario;
    var numTransaccion = $('#numTransacSim').val();
    var montoSol = $("#totalCap").asNumber();
    var periodicidad = $('#periodicidadCap').val();
    var periodicidadInt = $('#periodicidadInt').val();

    var diaPago = auxDiaPagoCapital;
    var diaPagoInt = auxDiaPagoInteres;
    var diaMes = $('#diaMesCapital').asNumber();
    var diaMesInt = $('#diaMesInteres').asNumber();

    var fechaInicio = $('#fechaInicioAmor').val();
    var producCreditoID = $('#productoCreditoID').val();
    var diaHabilSig = $('#fechInhabil').val();
    var ajustaFecAmo = $('#ajFecUlAmoVen').val();
    var ajusFecExiVen = $('#ajusFecExiVen').val();
    var comApertura= $("#montoComApert").asNumber();
    var calculoInt= $('#calcInteresID').val();
    var tipoCalculoInt= $('#tipoCalInteres').val();
    var tipoPagCap = $('#tipoPagoCapital').val();
    var cat = ($('#CAT').val()).replace(/\,/g,'');
    var leyenda = encodeURI($('#lblTasaVariable').text().trim());
    var plazoID = $("#plazoID").val();
    // SEGUROS
    var cobraSeguroCuota = $('#cobraSeguroCuota option:selected').val();
    var cobraIVASeguroCuota = $('#cobraIVASeguroCuota option:selected').val();
    var montoSeguroCuota = $('#montoSeguroCuota').asNumber();
    var convenio        = $('#convenioNominaID').asNumber();

    if(clienteID =='' || clienteID ==0 ){
        var clienteID = 0;
        var nombreCliente = $("#nombreProspecto").val();
    }
    if(periodicidad == ''){
        periodicidad = 0;
    }
    if(periodicidadInt == ''){
        periodicidadInt = 0;
    }
    if(diaMes == ''){
        diaMes = 0;
    }
    if(diaMesInt == ''){
        diaMesInt = 0;
    }
    if(cat == ''){
        cat = 0.0;
    }

    url = 'reporteProyeccionCredito.htm?clienteID='+clienteID
                                            + '&nombreCliente='+nombreCliente
                                            + '&tipoReporte='+tipoReporte
                                            + '&nombreInstitucion='+nombreInstitucion
                                            + '&totalCap='+capitalPagar
                                            + '&totalInteres='+interesPagar
                                            + '&totalIva='+ivaPagar
                                            + '&cat='+cat
                                            + '&califCliente='+califCliente
                                            + '&usuario='+ejecutivo
                                            + '&frecuencia='+frecuencia
                                            + '&frecuenciaInt='+frecuenciaInt
                                            + '&frecuenciaDes='+frecuenciaDes
                                            + '&tasaFija='+tasaFija
                                            + '&numCuotas='+numCuotas
                                            + '&numCuotasInt='+numCuotasInt
                                            + '&montoSol='+montoSol
                                            + '&periodicidad='+periodicidad
                                            + '&periodicidadInt='+periodicidadInt
                                            + '&diaPago='+diaPago
                                            + '&diaPagoInt='+diaPagoInt
                                            + '&diaMes='+diaMes
                                            + '&diaMesInt='+diaMesInt
                                            + '&fechaInicio='+fechaInicio
                                            + '&producCreditoID='+producCreditoID
                                            + '&diaHabilSig='+diaHabilSig
                                            + '&ajustaFecAmo='+ajustaFecAmo
                                            + '&ajusFecExiVen='+ajusFecExiVen
                                            + '&comApertura='+comApertura
                                            + '&calculoInt='+ calculoInt
                                            + '&tipoCalculoInt='+tipoCalculoInt
                                            + '&tipoPagCap='+tipoPagCap
                                            + '&numTransaccion='+numTransaccion
                                            + '&cobraSeguroCuota='+cobraSeguroCuota
                                            + '&cobraIVASeguroCuota='+cobraIVASeguroCuota
                                            + '&montoSeguroCuota='+montoSeguroCuota
                                            + '&leyendaTasaVariable='+leyenda
                                            + '&convenioNominaID='+convenio
                                            + '&cobraAccesorios='+cobraAccesorios
                                            + '&cobraAccesoriosGen='+cobraAccesoriosGen
                                            + '&plazoID='+plazoID;
                                            window.open(url, '_blank');

}



// Función para calcular los días transcurridos entre dos fechas
function restaFechas(fAhora,fEvento) {

    var ahora = new Date(fAhora);
    var evento = new Date(fEvento);
    var tiempo = evento.getTime() - ahora.getTime();
    var dias = Math.floor(tiempo / (1000 * 60 * 60 * 24));

    return dias;
 }



function consultaEsquemaSeguroVida(esq,tipoPAg){
    var prodCre = $('#productoCreditoID').val();
    var esquemaSeguroVid = esq;
    var tipPagoSegu = $('#forCobroSegVida').val();


    var esquemaSeguroBean = {
            'productoCreditoID' : prodCre,
            'esquemaSeguroID'   : esquemaSeguroVid,
            'tipoPagoSeguro'    : tipPagoSegu
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



function consultaEsquemaSeguroVidaForanea(tiPago){
    var prodCre = $('#productoCreditoID').val();
    var esquemaSeguroVid = $('#esquemaSeguroID').val();
    var tipPagoSegu = tiPago;
    $('#forCobroSegVida').val(tiPago);

    var esquemaSeguroBean = {
            'productoCreditoID' : prodCre,
            'esquemaSeguroID'   : esquemaSeguroVid,
            'tipoPagoSeguro'    : tipPagoSegu
    };

    var tipoConsulta = 2;
    esquemaSeguroVidaServicio.consulta(tipoConsulta,esquemaSeguroBean,function(esquema) {
        if (esquema != null) {
            factorRS = esquema.factorRiesgoSeguro;
            porcentajeDesc = esquema.descuentoSeguro;
            montoPol = esquema.montoPolSegVida;
            if(modalidad = 'T'){
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
    var prodCre = prod;
    var esquemaSeguroVid = esq;

    var esquemaSeguroBean= {
        'productoCreditoID' : prodCre,
        'esquemaSeguroID' : esquemaSeguroVid
    };
    var tipoLista  = 3;
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

    $("#tdTasaFija").show();
    $('#tdTasaNivel').hide();

    habilitaControl('tasaNivel');
    dwr.util.removeAllOptions('tasaNivel');
}

// Funcion que habilita y da formato de tasa dependiendo del calculo de interes
function habilitaCamposTasa(calcInteresID){
    if (calcInteresID == TasaFijaID) {
        deshabilitaControl('tasaFija');
        deshabilitaControl('pisoTasa');
        deshabilitaControl('tasaBase');
        deshabilitaControl('sobreTasa');
        deshabilitaControl('techoTasa');
    }

    if (calcInteresID == 2 || calcInteresID == 4 ){
        deshabilitaControl('tasaFija');
        deshabilitaControl('tasaBase');
        deshabilitaControl('pisoTasa');
        habilitaControl('sobreTasa');
        deshabilitaControl('techoTasa');
    }

    if (calcInteresID == TasaBasePisoTecho){
        deshabilitaControl('tasaFija');
        habilitaControl('pisoTasa');
        habilitaControl('sobreTasa');
        habilitaControl('techoTasa');
        deshabilitaControl('tasaBase');
    }
    $('#tasaFija').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
    $('#pisoTasa').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
    $('#techoTasa').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
    if($("#tasaNivel").length > 0){
        $("#tdTasaFija").hide();
        $('#tdTasaNivel').show();
        habilitaControl('tasaNivel');
    }else{// SI NO SE LLENA MOSTRARA EL VALOR DE LA TASA QUE SE OBTIENE Y NO EL COMBO
        $("#tdTasaFija").show();
        $('#tdTasaNivel').hide();
    }
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

function javaURLEncode(str) {
  return encodeURI(str)
    .replace(/%20/g, "+")
    .replace(/!/g, "%21")
    .replace(/'/g, "%27")
    .replace(/\(/g, "%28")
    .replace(/\)/g, "%29")
    .replace(/~/g, "%7E");
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
    var productoCreditoID = $('#productoCreditoID').asNumber();
    var frecuenciaInt = $("#frecuenciaInt option:selected").val();
    var frecuenciaCap = $("#frecuenciaCap option:selected").val();
    var mostrarSeguroCuota=$('#mostrarSeguroCuota').val();
    var cobraSeguroCuota=$('#cobraSeguroCuota option:selected').val();
    var esquemaSeguroBean = {
        'producCreditoID':  productoCreditoID,
        'frecuenciaCap': frecuenciaCap,
        'frecuenciaInt': frecuenciaInt,
    }
    $('#montoSeguroCuota').val(0);

    if(cobraSeguroCuota == 'S' && mostrarSeguroCuota == 'S'){
        if(productoCreditoID>0 ){
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

/**
 * Muestra los campos de seguro por cuota solo si generales tiene que Si
 */
function muestraSeccionSeguroCuota(){
    var con_paramSeccionEsp = 16;
    var parametrosSisCon ={
            'empresaID' : 1
    };
    $('#mostrarSeguroCuota').val("N");
    mostrarElementoPorClase('ocultarSeguroCuota',"N");
    parametrosSisServicio.consulta(con_paramSeccionEsp,parametrosSisCon,{ async: false,
        callback: function(varParamSistema) {
        if (varParamSistema != null) {
            var mostrarSeccionSeguros=varParamSistema.cobraSeguroCuota;
            $('#mostrarSeguroCuota').val(mostrarSeccionSeguros);
            mostrarElementoPorClase('ocultarSeguroCuota',mostrarSeccionSeguros);
            if(mostrarSeccionSeguros=='N'){
                $('#cobraSeguroCuota').val('N').selected = true;
                $('#cobraIVASeguroCuota').val('N').selected = true;
                $('#montoSeguroCuota').val('0.0');
            }
        } else {
            $('#mostrarSeguroCuota').val("N");
        }
    }});
}

function validaDiasCobro() {
        switch ($('#frecuenciaCap').val()) {
            case "S": // SI ES SEMANAL
                numeroDias = 7;
                break;
            case "D": // SI ES DECENAL
                numeroDias = 10;
                break;
            case "C": // SI ES CATORCENAL
                numeroDias = 14;
                break;
            case "Q": // SI ES QUINCENAL
                numeroDias = 15;
                break;
            case "M": // SI ES MENSUAL
                numeroDias = 30;
                break;
            case "B": // SI ES BIMESTRAL
                numeroDias = 60;
                break;
            case "T": // SI ES TRIMESTRAL
                numeroDias = 90;
                break;
            case "R": // SI ES TETRAMESTRAL
                numeroDias = 120;
                break;
            case "E": // SI ES SEMANAL
                numeroDias = 180;
                break;
            case "A": // SI ES ANUAL
                numeroDias = 360;
                break;
            case "L": // SI ES LIBRE
                numeroDias = 7;
                break;
            case "P": // SI ES PERIODO
                numeroDias = 7;
                break;
            case "U": // SI ES UNICO
                numeroDias = 7;
                break;
            default: // SI ES DEFAULT
                numeroDias = 7;
                break;
        }
 }

//FUNCION PARA LLENAR COMBO NIVEL
function cargaComboNiveles(sucu,prodCred,numCred,monto, calif,plazo,instiNomina) {
    var numLista = 3;
    var credBeanConsultaNiveles = {
            'sucursal' : sucu,
            'productoCreditoID' : prodCred,
            'numCreditos' : numCred,
            'montoCredito' : monto,
            'calificaCliente' : calif,
            'plazoID'           :plazo,
            'empresaNomina':    instiNomina
    };

    dwr.util.removeAllOptions('tasaNivel');
    nivelCreditoServicio.listaCombo(numLista,credBeanConsultaNiveles, { async: false, callback: function(bean) {
            dwr.util.addOptions('tasaNivel', bean, 'tasaNivel','descripcion');
    }});
    $("#tasaFija").val($('#tasaNivel').val());
}


function consultarFrecuencia(caracter){
    if(caracter != frecuenciaMensual || caracter != frecuenciaQuincenal){
        deshabilitaControl('diaMesCapital');
    }else{
        habilitaControl('diaMesCapital');
    }
}


/**
 * Función para validad la Cuenta Clabe
 */
function validaCuentaDomiciliado(idControl) {
    var jqClabe = eval("'#" + idControl + "'");
    var numClabe= $(jqClabe).val();
    var clienteID = $('#clienteID').asNumber();
    var numConsulta = 6;

    setTimeout("$('#cajaLista').hide();", 200);
    if (numClabe != '' && !isNaN(numClabe)) {

        var bean = {
            'clabe' : numClabe
        };
        cuentasTransferServicio.consulta(numConsulta,bean,{ async: false, callback: function(cuenta) {
            if (cuenta != null) {
                var cliente = cuenta.clienteID;
                var clabe = cuenta.clabe;
                var estatus = cuenta.estatusDomicilio;
                validaEstatusDomiciliacion(estatus);
                if(numClabe == clabe && clienteID != cliente){
                    mensajeSis("La Cuenta Clabe de Domiciliación pertenece al Cliente "+cliente+".");
                    $('#clabeDomiciliacion').focus();
                    $('#clabeDomiciliacion').val("");
                }
            } else {
                mensajeSis("La Cuenta Clabe de Domiciliación No Existe.");
                $('#clabeDomiciliacion').focus();
                $('#clabeDomiciliacion').val("");
            }
        }});
    }
}

/**
 * Función para validar el estatus de Domiciliación de la Cuenta Clabe
 */
function validaEstatusDomiciliacion(var_estatus) {
    var estatusBaja = "B";
    if(var_estatus == estatusBaja){
        mensajeSis("La Cuenta Clabe de Domiciliación se encuentra dado de Baja.");
        $('#clabeDomiciliacion').focus();
        $('#clabeDomiciliacion').val("");
    }
}

function validaInversion(idControl){
    var jqInversion = eval("'#" + idControl + "'");
    var numInversion = $(jqInversion).val();
    var InversionBean = {
        'inversionID' : numInversion
    };

    if(numInversion != 0 && numInversion != ''){
        if(esTab){
            inversionServicioScript.consulta(catTipoConsultaInversion.principal, InversionBean,{ async: false, callback: function(inversionCon){
            if(inversionCon!=null){
                var estatus = inversionCon.estatus;
                tasaInversion = inversionCon.tasa;
                fechaVencimientoInv = inversionCon.fechaVencimiento;
                validaTotalGarantizadoInv(numInversion);

                var montoInversion = inversionCon.monto;

                var montoEnGarantia = varGarantizadoInv;

                var montoDisponible = montoInversion - varGarantizadoInv;


                diasPlazoCredito = restaFechas($('#fechaInicioAmor').val(),fechaVencimientoInv);
                buscarSelect();

                if(estatus == catStatusInversion.cancelada){
                    mensajeSis("La Inversión se Encuentra Cancelada.");

                }

                if(estatus == catStatusInversion.pagada){
                    mensajeSis("La Inversión ya fue Pagada (Abonada a Cuenta).");
                }
                if(estatus == catStatusInversion.alta){
                    mensajeSis("La Inversión no ha sido autorizada.");
                }

                var montoMaximo = ((porcentaje * montoDisponible)/100);
                $("#montoMaximo").val(montoMaximo);
                montoMaximoValido = montoMaximo;



            }else{
                mensajeSis("La Inversión no Existe.");
                $(jqInversion).focus();
                $(jqInversion).select();
            }
        }});
        }
    }
}


// ------------ Validaciones de Controles
// -------------------------------------
function validaCtaAho(control) {
    var numCta = $('#cuentaAhoID').val();
    var clienteID = $('#clienteID').val();
    var tipoCtaProdAuto = 32;
    var CuentaAhoBeanCon = {
        'cuentaAhoID' : numCta,
        'clienteID' : clienteID
    };
    setTimeout("$('#cajaLista').hide();", 200);
    if (numCta != '' && !isNaN(numCta) ) {
        if (numCta == '0') {
            mensajeSis("Especifique Cuenta");
        } else {

            cuentasAhoServicio.consultaCuentasAho(tipoCtaProdAuto,CuentaAhoBeanCon, { async: false, callback:function(cuenta) {
            if (cuenta != null) {

                var saldoCta = cuenta.saldoDispon;
                tasaCuenta = cuenta.tasaRendimiento;

                if(cuenta.estatus != 'A'){
                    mensajeSis("La cuenta no esta activa.");
                }
                else{
                    var montoMaximo = ((porcentaje * saldoCta)/100);
                    $("#montoMaximo").val(montoMaximo);
                    agregarFormatoMoneda('montoMaximo');
                    var MontoMaximoCOnv = $("#montoMaximo").val();
                    montoMaximoValido = montoMaximo;


                }


            } else {
                mensajeSis("No Existe la Cuenta");
                $('#cuentaAhoID').val("");
                $('#cuentaAhoID').focus();
                $('#cuentaAhoID').select();
                $('#tiposCtaAlt').show();
                $('#tiposCtaCon').hide();
            }

        }});
        }
    }
}

function validaAutomatico(){
    if(esAutomatico == 'S'){
        controlQuitaFormatoMoneda('montoSolici');
        var montoSolicitado = $("#montoSolici").val();

        if(montoSolicitado > montoMaximoValido){
            mensajeSis("El Monto a Solicitar es Mayor al Monto Máximo Permitido");
            $("#montoSolici").val(0.00);
            $("#montoSolici").focus();
        }
        agregarFormatoMoneda('montoSolici');
    }
}

function calculoTasasAutomaticos()
{
    ClienteEspeficio();

    if(tipoAutomatico == 'I'){
        if(numeroCliente==CliEspefi){
        var tasaTotal = Number(tasaProdCred);
        }else{
            var tasaTotal   = Number(tasaInversion) + Number(tasaProdCred);
        }

    }
    if(tipoAutomatico == 'A'){
        if (numCliente == CliEspefi) {
            var tasaTotal = Number(tasaProdCred);
        }else{
        var tasaTotal   = Number(tasaCuenta) + Number(tasaProdCred);
            }
    }

    $("#tasaFija").val(tasaTotal);


}

function buscarSelect()
{
    // creamos un variable que hace referencia al select
    var select=document.getElementById("plazoID");

    // recorremos todos los valores del select
    for(var i=1;i<select.length;i++)
    {
        var buscar = select.options[i].text;
        buscar = buscar.replace(/\D/g,'');
        if( buscar== diasPlazoCredito)
        {
            // seleccionamos el valor que coincide
            select.selectedIndex=i;
        }
    }
}


/* valida el  total garantizado por inversion */
function validaTotalGarantizadoInv(numInversion){
    varGarantizadoInv = 0;
    var bean={
        'inversionID':numInversion
    };
    invGarantiaServicio.consulta(3,bean,{ async: false, callback:function(inverGaran){
        if(inverGaran != null){
            varGarantizadoInv  = parseFloat(inverGaran.totalGarInv);

        }else{
            varGarantizadoInv  = 0;
        }
    }});
}


function consultaNumeroHabitantes(){
    var tipoConsulta = 20;
    var bean = {
            'empresaID'     : 1
        };

    paramGeneralesServicio.consulta(tipoConsulta, bean, { async: false, callback:function(parametro) {
            if (parametro != null){
                numeroHabitantes = parametro.valorParametro;


            }else{
                numeroHabitantes = 0;
            }

    }});
}



function consultaDirCliente() {
    var direccionesCliente ={
         'clienteID' : $('#clienteID').val(),
         'direccionID': '0'

    };
    var numCliente = $('#clienteID').val();
    setTimeout("$('#cajaLista').hide();", 200);

    if(numCliente != '' && !isNaN(numCliente)){
        direccionesClienteServicio.consulta(16,direccionesCliente,{ async: false, callback:function(direccion) {
            if(direccion!=null){

                numeroHabitantesLocalidad = direccion.numeroHabitantes;
            }else{
                numeroHabitantesLocalidad = 0;
            }
        }});
    }
}

function evaluaFinanciamientoRural(){
    consultaNumeroHabitantes();
    consultaDirCliente();
    if(parseInt(numeroHabitantesLocalidad) > parseInt(numeroHabitantes)){
        grabaTransaccion = 1;
        mensajeSis("La Localidad del Cliente no cumple con el número de habitantes para el Financiamiento Rural");

    }else{
        grabaTransaccion = 0;
    }


}

//Valida que existan Accesorios parametrizados para el producto de crédito
function validaAccesorios(tipoCon){
    var valAccesorios = false;
    var paramCon = {};
    paramCon['cicloCliente'] = cicloCliente;
    paramCon['producCreditoID'] = $('#productoCreditoID').val();

    if(tipoCon==38){
        creditosServicio.consulta(tipoCon, paramCon, {
            async : false,
            callback : function(accesorios) {
                if (accesorios != null) {
                    if(accesorios.plazoID > 0 || accesorios.plazoID != "")
                    valAccesorios = true;

                }
            }
        });
    }else if (tipoCon==39){
        paramCon['plazoID'] = $('#plazoID').val();
        paramCon['montoPorDesemb'] = $('#montoSolici').asNumber();
        paramCon['convenioNominaID'] = $('#convenioNominaID').asNumber();
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


// -------------------------------------- funcion para poner el formato de moneda a un campo --------------------------------------- //
function agregarFormatoMoneda(controlID) {
    var jqControlID = eval("'#" + controlID + "'");
    $(jqControlID).formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 2 });
}

function ocultaCamposAutomatico(){
    $("#inversionIn").hide();
    $("#inversionLbl").hide();
    $("#cuentaAhorroLbl").hide();
    $("#cuentaAhorro").hide();
    $("#lblMontoMaximo").hide();
    $("#montoMaximo").hide();
    $("#separadorSol").hide();

}

function muestraCuentas(){
    $("#inversionIn").hide();
    $("#inversionLbl").hide();
    $("#cuentaAhorroLbl").show();
    $("#cuentaAhorro").show();
    $("#lblMontoMaximo").show();
    $("#montoMaximo").show();
    $("#separadorSol").show();
}

function muestraInversion(){
    $("#inversionIn").show();
    $("#inversionLbl").show();
    $("#cuentaAhorroLbl").hide();
    $("#cuentaAhorro").hide();
    $("#lblMontoMaximo").show();
    $("#montoMaximo").show();
    $("#separadorSol").show();

}



// Funcion que cambia la etiqueta de Día pago del mes o de la quincena.
function setDiaPagoFrecuencia(idControlFrec, valorDiaPago){
    var frecuencia = $('#'+idControlFrec).val();
    var labelDiaPago = '';
    var textoDiaPago = '';
    switch(frecuencia){
        case frecuenciaQuincenal:
            textoDiaPago = 'Día de Pago';
            if(idControlFrec == 'frecuenciaCap'){
                labelDiaPago = 'labelDiaCapital';
                $('#diaDosQuincCap').hide();
                $('#diaDosQuincCap').val('');
                $('#diaMesCapital').val('');
                $('#divDiaPagoCapMes').hide();
                $('#divDiaPagoCapQuinc').show();
                if(valorDiaPago == catDiaPagoQuinc.DiaQuincena){
                    habilitaControl('diaPagoCapitalD');
                    $('#diaPagoCapitalD').attr('checked', true);
                    $('input[name="diaPagoCapital3"]').change();
                    if(estaDeshabilitado('diaPagoCapitalD')){
                        deshabilitaControl('diaPagoCapitalD');
                    }
                }
                if(valorDiaPago == catDiaPagoQuinc.Quincenal){
                    habilitaControl('diaPagoCapitalQ');
                    $('#diaPagoCapitalQ').attr('checked', true);
                    $('input[name="diaPagoCapital3"]').change();
                    if(estaDeshabilitado('diaPagoCapitalQ')){
                        deshabilitaControl('diaPagoCapitalQ');
                    }
                }
            }
            if(idControlFrec == 'frecuenciaInt'){
                labelDiaPago = 'labelDiaInteres';
                $('#diaDosQuincInt').hide();
                $('#diaDosQuincInt').val('');
                $('#diaMesInteres').val('');
                $('#divDiaPagoIntMes').hide();
                $('#divDiaPagoIntQuinc').show();
            }
        break;
        default: // Cualquier otra frecuencia.
            textoDiaPago = 'Día del Mes';
            if(idControlFrec == 'frecuenciaCap'){
                labelDiaPago = 'labelDiaCapital';
                $('#diaDosQuincCap').hide();
                $('#diaDosQuincCap').val('');
                $('#diaMesCapital').val('');
                $('#divDiaPagoCapMes').show();
                $('#divDiaPagoCapQuinc').hide();
                $('#diaMesCapital').val(diaSucursal);
                $('#diaMesInteres').val(diaSucursal);
            }
            if(idControlFrec == 'frecuenciaInt'){
                labelDiaPago = 'labelDiaInteres';
                $('#diaDosQuincInt').hide();
                $('#diaDosQuincInt').val('');
                $('#diaMesInteres').val('');
                $('#divDiaPagoIntMes').show();
                $('#divDiaPagoIntQuinc').hide();
                $('#diaMesCapital').val(diaSucursal);
                $('#diaMesInteres').val(diaSucursal);
            }
        break;
    }
    $('#'+labelDiaPago).text(textoDiaPago+': ');
}
/* Iguala el comportamiento y valores del Capital al de Intereses para día de pago Quincenal.*/
function igualaPagoCaptal(){
    var tipoPagoCapital = $('#tipoPagoCapital').val();
    var diaPagoCapital3 = $('input[name="diaPagoCapital3"]:checked').val();
    var perIgualCI = $('#perIgual').val();
    habilitaControl('diaPagoInteresD');
    habilitaControl('diaPagoInteresQ');
    if($.trim($('#frecuenciaCap').val()) == frecuenciaQuincenal){
        if(tipoPagoCapital == 'C' || perIgualCI == 'S'){
                $('#divDiaPagoIntQuinc').show();
                $('#divDiaPagoIntMes').hide();
            if ($('#diaPagoCapitalD').is(':checked')) {
                $('#diaPagoInteresD').attr('checked', true);
                $('input[name="diaPagoInteres3"]').change();
                $('#diaDosQuincInt').val($('#diaDosQuincCap').val());
                $('#diaDosQuincInt').show();
            } else {
                $('#diaPagoInteresQ').attr('checked', true);
                $('#diaDosQuincInt').val('');
                $('#diaDosQuincInt').hide();
            }
            $('input[name="diaPagoInteres3"]').change();
            deshabilitaControl('diaMesInteres');
            deshabilitaControl('diaPagoInteresD');
            deshabilitaControl('diaPagoInteresQ');
        } else {
            habilitaControl('diaMesInteres');
            $('#diaMesCapital').val('');
            $('#diaDosQuincCap').val('');
            $('#diaDosQuincCap').show();
        }

        if ($("#frecuenciaCap").val()=='Q' && $('#diaPagoCapitalD').is(':checked')) {
                //GHERNANDEZ
                if(manejaConvenio=='S' && $("#frecuenciaCap").val()=='Q' && numeroCliente==38){
                        $("#diaMesCapital").val(1);
                        var diaMesCapital = $('#diaMesCapital').val();
                        $('#diaDosQuincCap').val(Number(diaMesCapital) + 15);
                        $("#diaMesInteres").val(1);
                        $('#diaDosQuincInt').val(Number(diaMesCapital) + 15);
                        deshabilitaControl('diaMesCapital');
                        deshabilitaControl('diaDosQuincCap');
                        deshabilitaControl('diaMesInteres');
                        deshabilitaControl('diaDosQuincInt');


                    }
                //FIN GHERNANDEZ
        }

    } else {
        habilitaControl('diaMesInteres');
        $('#diaMesCapital').val('');
        $('#diaDosQuincCap').val('');
        $('#diaDosQuincCap').hide();
        $('#divDiaPagoIntQuinc').hide();
        $('#divDiaPagoIntMes').show();
    }
}

function seteaDiaPagoQuic(diaPagoQuincenal, iguaCalenIntCap){
    // Valida el dia de pago quincenal.
    diaPagoQuincenalCal =  diaPagoQuincenal;
    iguaCalenIntCapCal =  iguaCalenIntCap;
    switch (diaPagoQuincenalCal) {
    case catDiaPagoQuinc.DiaQuincena:
        $('#diaPagoProd').val(catDiaPagoQuinc.DiaQuincena);
        $('#diaPagoCapital').val(catDiaPagoQuinc.DiaQuincena);
        $('#diaPagoInteres').val(catDiaPagoQuinc.DiaQuincena);
        $('#diaMesCapital').val('');
        $('#diaMesInteres').val('');
        $('#diaPagoCapitalD').click();
        deshabilitaControl('diaPagoCapitalD');
        deshabilitaControl('diaPagoCapitalQ');
        deshabilitaControl('diaMesCapital');
        deshabilitaControl('diaMesInteres');
        deshabilitaControl('diaPagoInteresD');
        deshabilitaControl('diaPagoInteresQ');
        break;
    case catDiaPagoQuinc.Quincenal:
        $('#diaPagoProd').val(catDiaPagoQuinc.Quincenal);
        $('#diaPagoCapital').val(catDiaPagoQuinc.Quincenal);
        $('#diaPagoInteres').val(catDiaPagoQuinc.Quincenal);
        $('#diaMesCapital').val('');
        $('#diaMesInteres').val('');
        $('#diaPagoCapitalQ').click();
        deshabilitaControl('diaPagoCapitalD');
        deshabilitaControl('diaPagoCapitalQ');
        deshabilitaControl('diaMesCapital');
        deshabilitaControl('diaMesInteres');
        deshabilitaControl('diaPagoInteresD');
        deshabilitaControl('diaPagoInteresQ');
        break;
    case catDiaPagoQuinc.Indistinto:
        $('#diaPagoProd').val(catDiaPagoQuinc.Indistinto);
        $('#diaPagoCapital').val(catDiaPagoQuinc.Quincenal);
        $('#diaPagoInteres').val(catDiaPagoQuinc.Quincenal);
        habilitaControl('diaPagoCapitalD');
        habilitaControl('diaPagoCapitalQ');
        habilitaControl('diaMesCapital');
        habilitaControl('diaMesInteres');
        habilitaControl('diaPagoInteresD');
        habilitaControl('diaPagoInteresQ');
        $('#diaPagoCapitalQ').click();
        break;
    default:
        $('#diaPagoProd').val(catDiaPagoQuinc.Indistinto);
        $('#diaPagoCapital').val(catDiaPagoQuinc.Quincenal);
        $('#diaPagoInteres').val(catDiaPagoQuinc.Quincenal);
        habilitaControl('diaPagoCapitalD');
        habilitaControl('diaPagoCapitalQ');
        habilitaControl('diaMesCapital');
        habilitaControl('diaMesInteres');
        habilitaControl('diaPagoInteresD');
        habilitaControl('diaPagoInteresQ');
        $('#diaPagoCapitalQ').click();
        break;
    }

    if (iguaCalenIntCap == 'S') {
        igualaPagoCaptal();
    }
}

function validaSobreTasa(){
    var credBeanCon = {
        'sucursalID'            : $('#sucursalID').val(),
        'productoCreditoID' : $('#productoCreditoID').val(),
        'montoInferior'     : $('#montoSolici').asNumber(),
        'calificacion'      : $('#calificaCliente').val(),
        'plazoID'           : $('#plazoID').val(),
        'institNominaID'    : $('#institucionNominaID').val(),
        'tasaFija'          : $('#tasaBase').val()
    };

    dwr.util.removeAllOptions('sobreTasa');
    esquemaTasasServicio.listaCombo(2,credBeanCon,{
        async:false,
        callback: function(esquemaTasas){
            dwr.util.addOptions('sobreTasa', {"":'SELECCIONAR'});
            dwr.util.addOptions('sobreTasa', esquemaTasas, 'sobreTasa', 'sobreTasa');
            if (esquemaTasas.length == 1) {
                $('#sobreTasa').val(esquemaTasas[0].sobreTasa);
            }
        }
    });
}


function muestraGridAccesorios(){
    var params = {};
    params['tipoLista'] = 2;
    params['producCreditoID'] =  $('#productoCreditoID').val();
    params['clienteID'] =  $('#clienteID').val();
    params['montoCredito'] =  $('#montoSolici').asNumber();
    params['plazoID'] =  $('#plazoID').val();
    params['institNominaID'] = $('#institucionNominaID').val();
    params['convenioID'] = $('#convenioNominaID').val();


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

function verificaPagoCapInt () {
    if($('#diaPagoInteres1').is(':checked')){
        deshabilitaControl('diaMesInteres');
    }else{
        habilitaControl('diaMesInteres');
    }
    if($('#diaPagoCapital1').is(':checked')){
        deshabilitaControl('diaMesCapital');
    }else{
        habilitaControl('diaMesCapital');
    }

    if ($("#frecuenciaCap").val()=='Q' && $('#diaPagoCapitalD').is(':checked')) {
        habilitaControl('diaMesCapital');
    }
    if ($("#frecuenciaCap").val()=='Q' && $('#diaPagoCapitalQ').is(':checked')) {
        deshabilitaControl('diaMesCapital');
        $('#diaMesCapital').val('15');
    }
    if ($("#frecuenciaCap").val()=='Q' && $('#diaPagoInteresQ').is(':checked') && $('#diaPagoInteres').val()=='Q') {
        deshabilitaControl('diaMesInteres');
    }
    if ($("#frecuenciaCap").val()=='Q' && $('#diaPagoInteres').val()=='D' && numeroCliente != 38) {
        $('#diaMesInteres').val('');
    }


    if ($("#frecuenciaCap").val()=='Q' && $('#diaPagoCapitalD').is(':checked') && numeroCliente==38) {
        //GHERNANDEZ
        if(manejaConvenio=='S' && $("#frecuenciaCap").val()=='Q'){

                $("#diaMesCapital").val(1);
                var diaMesCapital = $('#diaMesCapital').val();
                $('#diaDosQuincCap').val(Number(diaMesCapital) + 15);
                $("#diaMesInteres").val(1);
                $('#diaDosQuincInt').val(Number(diaMesCapital) + 15);
                deshabilitaControl('diaMesCapital');
                deshabilitaControl('diaDosQuincCap');
                deshabilitaControl('diaMesInteres');
                deshabilitaControl('diaDosQuincInt');
            }
        //FIN GHERNANDEZ
    }

    // si la Frecuencia es Mensual y el día de pago Capital esta configurado como Día Aniversario
    // se deshabilita el input diaMesCapital.
    if($("#frecuenciaCap").val()=='M' && $('#diaPagoProd').val()=='A'){
        deshabilitaControl('diaMesCapital');

        //Si permite igualdad en calendario de interes y capital. Deshabilita tambien el input diaMesInteres
        if($('#perIgual').val()=='S'){
            deshabilitaControl('diaMesInteres');
        }
    }


}

function ClienteEspeficio(){


        var tipoConsulta = 13;
        var cliente = 26;
            paramGeneralesServicio.consulta(tipoConsulta,{ async: false, callback: function(valor){
            if(valor!=null){

                    numeroCliente=valor.valorParametro;
                }
            }
        });
    }




function exportarExcel() {
    var tipoReporte         = 6; // reporte AMORTIZACIONES en la pantalla de Flujo de Solicitud Individual
    var tituloReporte       = 'AMORTIZACIONES SOLICITUD DE CREDITO';
    var usuario             = parametroBean.claveUsuario;

    var clienteID = $("#clienteID").val();
    var nombreCliente = $("#nombreCte").val();

    var nombreInstitucion = parametroBean.nombreInstitucion;
    var capitalPagar = $("#totalCap").asNumber();
    var interesPagar =  $("#totalInt").asNumber();
    var ivaPagar =  $("#totalIva").asNumber();
    var frecuencia = $("#frecuenciaCap").val();
    var frecuenciaInt = $("#frecuenciaInt").val();
    var frecuenciaDes =  $("#frecuenciaCap option:selected").html();
    var tasaFija = $("#tasaFija").val(); // tasa fija o tasa base

    var numCuotas = $("#numAmortizacion").asNumber();
    var numCuotasInt = $("#numAmortInteres").asNumber();
    var califCliente =  $("#calificaCredito").val() + "     " + calificacionCliente;
    var ejecutivo = parametroBean.nombreUsuario;
    var numTransaccion = $('#numTransacSim').val();
    var montoSol = $("#totalCap").asNumber();
    var periodicidad = $('#periodicidadCap').val();
    var periodicidadInt = $('#periodicidadInt').val();

    var diaPago = auxDiaPagoCapital;
    var diaPagoInt = auxDiaPagoInteres;
    var diaMes = $('#diaMesCapital').asNumber();
    var diaMesInt = $('#diaMesInteres').asNumber();

    var fechaInicio = $('#fechaInicioAmor').val();
    var producCreditoID = $('#productoCreditoID').val();
    var diaHabilSig = $('#fechInhabil').val();
    var ajustaFecAmo = $('#ajFecUlAmoVen').val();
    var ajusFecExiVen = $('#ajusFecExiVen').val();
    var comApertura= $("#montoComApert").asNumber();
    var calculoInt= $('#calcInteresID').val();
    var tipoCalculoInt= $('#tipoCalInteres').val();
    var tipoPagCap = $('#tipoPagoCapital').val();
    var cat = ($('#CAT').val()).replace(/\,/g,'');
    var leyenda = encodeURI($('#lblTasaVariable').text().trim());
    // SEGUROS
    var cobraSeguroCuota = $('#cobraSeguroCuota option:selected').val();
    var cobraIVASeguroCuota = $('#cobraIVASeguroCuota option:selected').val();
    var montoSeguroCuota = $('#montoSeguroCuota').asNumber();
    var plazoID = $('#plazoID').val();
    var convenio        = $('#convenioNominaID').asNumber();

    if(clienteID =='' || clienteID ==0 ){
        clienteID = 0;
        nombreCliente = $("#nombreProspecto").val();
    }
    if(periodicidad == ''){
        periodicidad = 0;
    }
    if(periodicidadInt == ''){
        periodicidadInt = 0;
    }
    if(diaMes == ''){
        diaMes = 0;
    }
    if(diaMesInt == ''){
        diaMesInt = 0;
    }
    if(cat == ''){
        cat = 0.0;
    }

      url = 'reporteProyeccionCredito.htm?clienteID='+clienteID
                                            + '&nombreCliente='+nombreCliente
                                            + '&tipoReporte='+tipoReporte

                                                    + '&nombreInstitucion='+nombreInstitucion
                                                    + '&totalCap='+capitalPagar
                                                    + '&totalInteres='+interesPagar
                                                    + '&totalIva='+ivaPagar
                                                    + '&cat='+cat

                                                    + '&califCliente='+califCliente
                                                    + '&usuario='+ejecutivo
                                                    + '&frecuencia='+frecuencia+'&frecuenciaInt='+frecuenciaInt
                                                    + '&frecuenciaDes='+frecuenciaDes

                                                    + '&tasaFija='+tasaFija
                                                    + '&numCuotas='+numCuotas
                                                    + '&numCuotasInt='+numCuotasInt +'&montoSol='+montoSol
                                                    + '&periodicidad='+periodicidad

                                                    + '&periodicidadInt='+periodicidadInt
                                                    + '&diaPago='+diaPago
                                                    + '&diaPagoInt='+diaPagoInt
                                                    + '&diaMes='+diaMes
                                                    + '&diaMesInt='+diaMesInt
                                                    + '&fechaInicio='+fechaInicio

                                                    + '&producCreditoID='+producCreditoID
                                                    + '&diaHabilSig='+diaHabilSig
                                                    + '&ajustaFecAmo='+ajustaFecAmo
                                                    + '&ajusFecExiVen='+ajusFecExiVen

                                                    + '&comApertura='+comApertura+'&calculoInt='+ calculoInt
                                                    + '&tipoCalculoInt='+tipoCalculoInt
                                                    + '&tipoPagCap='+tipoPagCap
                                                    + '&numTransaccion='+numTransaccion

                                                    + '&cobraSeguroCuota='+cobraSeguroCuota
                                                    + '&cobraIVASeguroCuota='+cobraIVASeguroCuota
                                                    + '&montoSeguroCuota='+montoSeguroCuota

                                                    + '&tipoReporte='+tipoReporte
                                                    +'&tituloReporte='+tituloReporte
                                                    +'&usuario='+usuario
                                                    +'&nombreInstitucion='+nombreInstitucion
                                                    + '&convenioNominaID='+convenio
                                                    + '&cobraAccesorios='+cobraAccesorios
                                                    + '&cobraAccesoriosGen='+cobraAccesoriosGen
                                                    + '&plazoID='+plazoID;
      window.open(url, '_blank');
}



function consultaMontoFOGAFI() {
    var SolCredBeanCon ={
         'solicitudCreditoID' : $('#solicitudCreditoID').val()
    };
    var numCliente = $('#clienteID').val();
    setTimeout("$('#cajaLista').hide();", 200);
    if(numCliente != '' && !isNaN(numCliente)){
        solicitudCredServicio.consulta(13,SolCredBeanCon,{
            async:false,
            callback:function(solicitud) {
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
            }
        });
    }
}


//Asigna valor de los roles configuraod para la liberacion y rechazo de solicitud de credito
function consultaRolesLiberaRechazaSol() {
    var parametrosSisCon ={
        'empresaID' : 1
    };
    parametrosSisServicio.consulta(24,parametrosSisCon,{ async: false, callback:function(parametroSistema) {
        if (parametroSistema != null) {
            restringebtnLiberacionSol = parametroSistema.restringebtnLiberacionSol;
            primerRolFlujoSolID = parametroSistema.primerRolFlujoSolID;
            segundoRolFlujoSolID = parametroSistema.segundoRolFlujoSolID;
        }
    }});
}

// METODO PARA CONSULTAR EL ROL DEL USUARIO
function consultaRolUssuario() {
    var numUsuario = usuarioID;
    if(numUsuario != '' && numUsuario > 0){
        var usuarioBean = {
            'usuarioID': numUsuario
        };
        usuarioServicio.consulta(14, usuarioBean, function(usuario) {
            if(usuario!=null){
                rolUsuarioID = usuario.rolID;
            }
        });
    }
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



function funcionConsultaEmpleadoNomina(idControl) {
    var jqControl = eval("'#" + idControl + "'");
    var beanEntrada = {
        'clienteID': $('#clienteID').val()
    };
    setTimeout("$('#cajaLista').hide();", 200);
    nominaEmpleadosServicio.consulta(4, beanEntrada, function(resultado) {
        if(resultado != null) {
            if(resultado.institNominaID==0 || resultado.institNominaID==null){
                mensajeSis('El '+$('#safilocaleCTE').val()+' No esta Relacionado a una <b>Institución de Nómina</b>.');
            }
            if(resultado.convenioNominaID==0 || resultado.convenioNominaID==null){
                mensajeSis('El '+$('#safilocaleCTE').val()+' No Cuenta con un <b>Convenio Asignado</b>.');
            }
        }
        else{
            mensajeSis('El '+$('#safilocaleCTE').val()+' No esta Relacionado a una <b>Institución de Nómina</b>.');
            $(jqControl).focus();
        }
    });
}

function listaConveniosActivos(convenioID) {
    beanEntrada = {
        'institNominaID': $('#institucionNominaID').val(),
        'clienteID': $('#clienteID').val()
    };

    conveniosNominaServicio.lista(4, beanEntrada, function(resultado) {
        dwr.util.removeAllOptions('convenioNominaID');
        if (resultado != null && resultado.length > 0) {
            dwr.util.addOptions('convenioNominaID', {'':'SELECCIONAR'});
            dwr.util.addOptions('convenioNominaID', resultado, 'convenioNominaID', 'descripcion');
            if (convenioID!="" && convenioID !=null) {
                consultaValidaConvenioNomina(convenioID);
            }
            return;
        }
        dwr.util.addOptions('convenioNominaID', {'': 'NO SE ENCONTRARON CONVENIOS ACTIVOS'});
    });
}

function consultaValidaConvenioNomina(convenioID) {
	var convenioBean = {
		'convenioNominaID': convenioID
	};
	setTimeout("$('#cajaLista').hide();", 200);

	if($('#convenioNominaID').val() != ''  || convenioID != ''){
		conveniosNominaServicio.consulta(1, convenioBean, function(resultado) {
			if(resultado != null) {
				$("#convenioNominaID").val(convenioID);
			}else{
				$(".quinquenios").hide();
				mensajeSis("El Número de Convenio No Existe.");
				dwr.util.addOptions('convenioNominaID', {'': 'SELECCIONAR'});
				$("#convenioNominaID").focus();
			}
		});
	}
}

function consultaConvenioNomina(convenioID) {

    var convenioBean = {
        'convenioNominaID': convenioID
    };
    var institucion = $('#institucionNominaID').val();
    setTimeout("$('#cajaLista').hide();", 200);
    if(convenioID != ''){
	    conveniosNominaServicio.consulta(1, convenioBean, { async: false, callback:function(resultado) {
	        if(resultado != null) {
	            if (resultado.requiereFolio=="S") {
	                $(".folioSolici").show();
	                $("#folioSolici").val("");
	            }
	            else{
	                $(".folioSolici").hide();
	                $("#folioSolici").val("");
	            }
	            if (resultado.manejaQuinquenios=="S") {

	                manejaQuin = 'S';
	                existeEsquemaQConvenio(institucion,convenioID);
	            }

	            else{
	                manejaQuin = 'N';

	                $(".quinquenios").hide();
	                $("#quinquenioID").val("");
	            }

	            manejaCalendario = '';
	            manejaCalendario = resultado.manejaCalendario;

	            if (resultado.manejaCalendario=="S") {
	                consultaFechaLimite(resultado.institNominaID, resultado.convenioNominaID);
	            }

	            if(resultado.domiciliacionPagos == 'S'){
	                domiciPagos = resultado.domiciliacionPagos;
	                $('.ClabeDomiciliacion').show();
	            }else{
	                $('#clabeDomiciliacion').val('');
	                $('.ClabeDomiciliacion').hide();
	            }

				consultaEsquemasConvenio(true,false);

	        }else{
	            $(".quinquenios").hide();
	            mensajeSis("El Número de Convenio No Existe.");
				$("#convenioNominaID").focus();
	        }
	    }});
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
            if(resultado.fechaPrimerAmorti !="1900-01-01"){
                $("#fechaInicioAmor").val(resultado.fechaPrimerAmorti);
            }
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
    esquemaQuinqueniosServicio.consulta(3, esquemaQBean, function(resultado) {

        if(resultado != null) {
            if(resultado.cantidad <= 0){

                 deshabilitaBoton('simular');
                 deshabilitaBoton('agregar');
                $("#convenioNominaID").val("");
                $("#convenioNominaID").focus();
                $(".quinquenios").hide();
                mensajeSis("El convenio de la Empresa Nómina no cuenta con un Esquema de Quinquenios parámetrizado.");
            }else
            {
             habilitaBoton('simular');
                habilitaBoton('agregar');
                $(".quinquenios").show();
                $("#quinquenioID").select();
                $("#quinquenioID").focus();
            }

        }

    });
}


function consultaEsquemaQuinquenio(){

    if($('#quinquenioID').val()!="" && $('#quinquenioID').val()!=null) {
        var quinquenio = $('#quinquenioID').asNumber();
        var plazos = "";
        var plazo = 0;
        var calendarioIngresosBean = {
            'institNominaID': $('#institucionNominaID').val(),
            'convenioNominaID': $('#convenioNominaID').val(),
            'sucursalID': $('#sucursalCte').val(),
            'quinquenioID': $('#quinquenioID').val(),
            'clienteID': $('#clienteID').val(),
        };

        setTimeout("$('#cajaLista').hide();", 200);

        esquemaQuinqueniosServicio.consulta(2, calendarioIngresosBean, function(resultado) {
            if(resultado != null) {

                //VALIDACION SI EL CONVENIO MANEJA QUINQUENIOS

                if (resultado.manejaQuinquenios=="S") {
                    plazos = resultado.plazoID;
                    plazo = $('#plazoID').val();
                    //VALIDACION SI EXISTE UN ESQUEMA DE QUINQUENIO CON EL QUIQUENIO SELECCIONADO
                    if (quinquenio != resultado.quinquenioID && resultado.quinquenioID!=null) {

                        if(plazos.indexOf(plazo)==0) {
                            mensajeSis("No existe un esquema con el plazo seleccionado");
                            $('#plazoID').focus();
                        }else{
                            mensajeSisRetro({
                                mensajeAlert : 'El cliente se encuentra en el quinquenio <b>'+resultado.desQuinquenio
                                                +'</b> y no aplica para este plazo del convenio <b>'+$('#plazoID option:selected').html()
                                                +'</b><br><b>¿Desea continuar con el registro?</b>',
                                muestraBtnAceptar: true,
                                muestraBtnCancela: true,
                                txtAceptar : 'SI',
                                txtCancelar : 'NO',
                                funcionAceptar : function(){
                                    grabarTransaccion({});
                                },
                                funcionCancelar : function(){// si no se pulsa en aceptar
                                    return false;
                                }
                            });
                        }

                    }else{
                        //VALIDACIONSI CUENTA CON UN ESQUEMA CON EL PLAZO SELECCIONADO
                        if(plazos.indexOf(plazo)==0) {
                            mensajeSis("No existe un esquema con el plazo seleccionado");
                            $('#plazoID').focus();
                        }else{
                            grabarTransaccion({});
                        }

                    }
                }else{grabarTransaccion({});}
            }
            else{
                mensajeSis("El quinquenio seleccionado no cuenta con un esquema");
                $('#quinquenioID').focus();
            }
        });
    }
    else{
        grabarTransaccion({});
    }

}



function plazoCorrectoEsquemaQ(){

    if($('#quinquenioID').val()!=null) {
        var quinquenio = $('#quinquenioID').asNumber();

        var calendarioIngresosBean = {
            'institNominaID': $('#institucionNominaID').val(),
            'convenioNominaID': $('#convenioNominaID').val(),
            'sucursalID': $('#sucursalCte').val(),
            'quinquenioID': $('#quinquenioID').val(),
            'clienteID': $('#clienteID').val(),
        };

        setTimeout("$('#cajaLista').hide();", 200);

        esquemaQuinqueniosServicio.consulta(2, calendarioIngresosBean,{ async: false, callback: function(resultado) {

            if(resultado != null) {
                var plazos = "";
                var plazo = 0;

                plazos = resultado.plazoID;
                plazo = $('#plazoID').val();
                //VALIDACION SI EXISTE UN ESQUEMA DE QUINQUENIO CON EL QUINQUENIO DEL CLIENTE
                if (resultado.quinquenioID!=null) {
                    if(plazos.indexOf(plazo)==0) {
                        if($('#plazoID').val()!=''){
                        mensajeSis('El cliente se encuentra en el quinquenio <b>'+resultado.desQuinquenio
                                    +'</b> y no aplica para este plazo del convenio <b>'+$('#plazoID option:selected').html()
                                    +'');
                        }
                    }

                }else{
                    if(plazos.indexOf(plazo)==0) {
                        mensajeSis("El quinquenio de cliente no tiene un esquema de Quinquenios");
                	}
                 }
             }
         else{
     	  if($('#plazoID').val()!='' && $('#quinquenioID').val() != ''){
            mensajeSis("No existe un esquema con el plazo seleccionado");
            }
              }


        }});
    }
}


function consultaEsquemasConvenio(validaMora,validaComApert)
{
	    beanEntrada = {
        'convenioNominaID': $('#convenioNominaID').val()
    };
    conveniosNominaServicio.consulta(1, beanEntrada, function(resultado) {
        if (resultado != null) {
			if(resultado.cobraComisionApert=='S')
				cobraComisionApertConvenio = true;
			else
				cobraComisionApertConvenio = false;
			if(resultado.cobraMora=='S')
				cobraMoraConvenio = true;
			else
				cobraMoraConvenio = false;
		  if(validaMora)
			{
				validaCobMoraConvenio();
			}
		  if(validaComApert)
			{
				validaComApertPlazo();
			}
        }
    });
}

function validaComApertPlazo()
{
	if(cobraComisionApertConvenio)
	plazoCorrectoEsquemaComApert();
}


function validaCobMoraConvenio()
{
	if(cobraMoraConvenio)
	convenioCorrectoEsqCobMora();
}

function esComApertPorConvenio()
{
  if($('#convenioNominaID').val()!=null && $('#convenioNominaID').val()!='0' && $('#institucionNominaID').val() != '') {
	var beanEsquema = {
			'institNominaID': $('#institucionNominaID').val(),
		    'producCreditoID': $('#productoCreditoID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
			esqComAperNominaServicio.consulta(1, beanEsquema, function(resultado) {
				if(resultado != null) {
							$('#esqComApertID').val(resultado.esqComApertID);
							if(resultado.manejaEsqConvenio) {
								manejaEsqConvenio = true;
							}
							else
							{
								manejaEsqConvenio = false;
							}
					}
			});
}
}

function plazoCorrectoEsquemaComApert(){

    if($('#convenioNominaID').val()!=null && $('#convenioNominaID').val()!='0') {
	var monto = Number($('#montoSolici').val().replace(',',''));
	var tipoComApert =  $('#formaComApertura').val();
	if(tipoComApert=='F' || tipoComApert == 'P' || tipoComApert == 'A')
	{
	var comApertProd = Number($('#montoComApert').val().replace(',',''));
	var ivaComApertProd = Number($('#ivaComApert').val().replace(',',''));
	monto = monto-comApertProd-ivaComApertProd;
	}
	setTimeout("$('#cajaLista').hide();", 200);

	var beanComApert = {
		'esqComApertID': $('#esqComApertID').val(),
	    'convenioNominaID': $('#convenioNominaID').val(),
		'plazoID': $('#plazoID').val(),
		'monto': monto,
	};
		comApertConvenioServicio.consulta(2, beanComApert, function(resultado) {
			if(resultado != null) {
				esqCobroComApert = resultado;
                  if (resultado.tipoComApert == 'P') {
                        montoComApeBase = montoSolicitudBase * (resultado.valor / 100);
                        $('#montoComApert').val(montoComApeBase);
                        $('#montoComApert').formatCurrency({
                            positiveFormat : '%n',
                            roundToDecimalPlace : 2
                        });
                    } else {
                        // si es por monto
                        if (resultado.tipoComApert == 'M') {
                            montoComApeBase = resultado.valor;
                            $('#montoComApert').val(resultado.valor);
                            $('#montoComApert').formatCurrency({
                                positiveFormat : '%n',
                                roundToDecimalPlace : 2
                            });

                        }
                    }
					// ya teniendo el monto de la comision se calcula el iva
                    formaCobroComApe = resultado.formCobroComAper;
                    montoMaxSolicitud = resultado.montoMax;
                    montoMinSolicitud = resultado.montoMin;
                    // forma de pago del producto de credito com apertura
                    if (resultado.formCobroComAper == 'F') {
                        $('#formaComApertura').val(financiado);
                    } else {
                        if (resultado.formCobroComAper == 'D') {
                            $('#formaComApertura').val(deduccion);
                        } else {
                            if (resultado.formCobroComAper == 'A') {
                                $('#formaComApertura').val(anticipado);
                            }
                            else{
                                if (resultado.formCobroComAper == 'P') {
                                    $('#formaComApertura').val(programado);
                                }
                            }
                        }
                    }
				calculaIVASucursal();
			}
			else
			{
				esqCobroComApert = null;
				mensajeSis('No existe configuración esquema Comisión Apertura Convenio-Plazo-Monto, es necesario configurarlo');
				$('#plazoID').focus();
			}
		});
	  }
}

function consultaComisionAperConvenio()
{
				if(esqCobroComApert != null) {
                  if (esqCobroComApert.tipoComApert == 'P') {
                        montoComApeBase = montoSolicitudBase * (esqCobroComApert.valor / 100);
                        $('#montoComApert').val(montoComApeBase);
                        $('#montoComApert').formatCurrency({
                            positiveFormat : '%n',
                            roundToDecimalPlace : 2
                        });
                    } else {
                        // si es por monto
                        if (esqCobroComApert.tipoComApert == 'M') {
                            montoComApeBase = esqCobroComApert.valor;
                            $('#montoComApert').val(esqCobroComApert.valor);
                            $('#montoComApert').formatCurrency({
                                positiveFormat : '%n',
                                roundToDecimalPlace : 2
                            });

                        }
                    }
					// ya teniendo el monto de la comision se calcula el iva
                        formaCobroComApe = esqCobroComApert.formCobroComAper;
                        montoMaxSolicitud = esqCobroComApert.montoMax;
                        montoMinSolicitud = esqCobroComApert.montoMin;
                            // forma de pago del producto de credito com apertura
                            if (esqCobroComApert.formCobroComAper == 'F') {
                                $('#formaComApertura').val(financiado);
                            } else {
                                if (esqCobroComApert.formCobroComAper == 'D') {
                                    $('#formaComApertura').val(deduccion);
                                } else {
                                    if (esqCobroComApert.formCobroComAper == 'A') {
                                        $('#formaComApertura').val(anticipado);
                                    }
                                    else{
                                        if (esqCobroComApert.formCobroComAper == 'P') {
                                            $('#formaComApertura').val(programado);
                                        }
                                    }
                                }
                            }
				calculaIVASucursal();
			}
}


           // funcion que calcula el IVA de la comision por apertura de
            // credito de acuerdo a la sucursal del cliente
            function calculaIVASucursal() {
                var numSucursal = $('#sucursalCte').val();
                setTimeout("$('#cajaLista').hide();", 200);
                if (numSucursal != '' && !isNaN(numSucursal) && esTab) {
                    sucursalesServicio.consultaSucursal(1, numSucursal, { async: false, callback: function(sucursal) {
                                if (sucursal != null) {
                                    var iva = sucursal.IVA;
                                    // si el cliente paga iva
                                    if ($('#pagaIVACte').val() == 'S') {
                                        montoIvaComApeBase = (montoComApeBase * iva);
                                        $('#ivaComApert').val(montoIvaComApeBase);
                                        $('#ivaComApert').formatCurrency({
                                            positiveFormat : '%n',
                                            roundToDecimalPlace : 2
                                        });

                                    } else {
                                        // si el cliente no paga iva
                                        if ($('#pagaIVACte').val() == 'N') {
                                            $('#ivaComApert').val("0.00");
                                            montoIvaComApeBase = 0;
                                        }
                                    }
                                    // si es forma de cobro por Financiamiento
                                    if (formaCobroComApe == "F") {
                                        montoComIvaSol = parseFloat(montoComApeBase)+ parseFloat(montoIvaComApeBase)+ parseFloat(montoSolicitudBase);
                                        if (montoSolicitudBase > 0) {
                                            $('#montoSolici').val(montoComIvaSol);
                                            $('#montoSolici').formatCurrency({
                                                positiveFormat : '%n',
                                                roundToDecimalPlace : 2
                                            });
                                        }
                                    }

                                    calculaNodeDias($('#fechaVencimiento').val());
                                }
                              }
                            });
                }
            }

function convenioCorrectoEsqCobMora(){
    if($('#convenioNominaID').val()!=null && $('#convenioNominaID').val()!='0') {
	var beanEsquema = {
			'institNominaID': $('#institucionNominaID').val(),
		    'producCreditoID': $('#productoCreditoID').val(),
		    'convenioNominaID': $('#convenioNominaID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);

			condicionProductoServicio.consulta(4, beanEsquema, function(resultado) {
				if(resultado != null) {
					if(resultado.valorMora!=null)
					{
						$('#factorMora').val(resultado.valorMora);
						mostrarLabelTasaFactorMora(resultado.tipoCobMora);
						return true;
					}
					else
					  mensajeSis('No existe configuración Convenio-Cobro Mora, es necesario configurarlo');
						$('#convenioNominaID').focus();
				}
				else
				{
					mensajeSis('No existe configuración Convenio-Cobro Mora, es necesario configurarlo');
					$('#convenioNominaID').focus();
				}
			});
    }
}



function grabarTransaccion(event){
    grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma','mensaje', 'true',
                        'solicitudCreditoID','inicializarSolicitud','errorSolicitud');
}

function obtenerServiciosAdicionalesAll(productoCreditoID, institNominaID){

	if(productoCreditoID == '' || isNaN(productoCreditoID)){
		productoCreditoID = '0';
	}

	if(institNominaID == '' || isNaN(institNominaID)){
		institNominaID = '0';
	}

	if (institNominaID == '0' && productoCreditoID == '0'){
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
		var productoCreditoID = $('#productoCreditoID').val();
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

function showServiciosAdicionales(){

	if(listaServiciosAdicionales.length > 0){
		listaServiciosAdicionales = removerDuplicadosServiciosAdicionales(listaServiciosAdicionales);
	}

	var solicitudCreditoID = $('#solicitudCreditoID').val();
	var html = '';
	//Si la solicitud de crédito es nueva
	if(solicitudCreditoID == '0'){
		html += '<td class="label" nowrap="nowrap"><div class="contenedor-servicios">';
		listaServiciosAdicionales.forEach(function (element, index, array){
			html += '<div class="contenedor-servicios-item">';
		   	html += '<label for="lblsolicitud">Aplica ';
		   	html += element.descripcion;
		   	html += ':</label>';
		   	html += '&nbsp;<label class="label">Si</label>&nbsp;<input class="serviciosAdiC" type="radio" id="servicio-'+ element.servicioID +'-si" name="servicioAdiC'+ element.servicioID +'" value="' + element.servicioID + '">&nbsp;';
		   	html += '<label class="label">No</label>&nbsp;<input class="serviciosAdiC" type="radio" id="servicio-'+ element.servicioID +'-no" name="servicioAdiC'+ element.servicioID +'" value="0" checked="checked">&nbsp;&nbsp;';
		   	html += '</div>';
		});
		html += '</div></td>';
		$('#divServiciosAdic').html(html);
		$('#fieldServicioAdic').show();
	}else{
		//Si ya existe la solicitud de crédito
		var serviciosSolCredBean = {
				'solicitudCreditoID': solicitudCreditoID,
		};

		var tipoConsulta = 2 //por SolicitudCreditoID;

		setTimeout("$('#cajaLista').hide();", 200);
		//Obtener servicios adicionales que ha registrado
		serviciosSolCredServicio.lista(tipoConsulta, serviciosSolCredBean, function(resultado) {
		    if(resultado != null) {
		    	var desactiva = '';
			    if (estatusSolicitudCredito == 'A'
                    || estatusSolicitudCredito == 'D'
                        || estatusSolicitudCredito == 'L'
                            || estatusSolicitudCredito == 'C') {
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

// ------------------ valida que la cuenta CLABE este bien formada ---------------
function validaCtaClabe(ctaClabe) {
    agregaFormatoNumMaximo('formaGenerica');
    var numero = document.getElementById(ctaClabe).value;
    var tipoDisper = $('#tipoDispersion').val();
    if (tipoDisper == 'A' && numero != '') {
        if (isNaN(numero)) {
            mensajeSis("Ingresar Sólo Números.");
            $('#ctaClabeDisp').select();
        }
        if (numero.length == 18 && numero != '') {
            if (!isNaN(numero)) {
                var institucion = numero.substr(0, 3);
                var tipoConsulta = 3;
                var DispersionBean = {
                        'institucionID' : institucion
                };
                institucionesServicio.consultaInstitucion( tipoConsulta, DispersionBean,
                        function(data) {
                            if (data == null) {
                                mensajeSis('La Cuenta Clabe No Coincide con Ninguna Institución Financiera Registrada.');
                                document.getElementById(ctaClabe).focus();
                            }
                        });
            }
        } else {
            mensajeSis("La Cuenta Clable debe de Tener 18 Caracteres.");
            document.getElementById(ctaClabe).focus();
        }
    }
    return false;
}

//Metodo para consultar si modifica sucursal
function consultaModificaSuc(habilita){
    var tipoConsulta = 58;
    var bean = {
            'empresaID'     : 1
        };
    paramGeneralesServicio.consulta(tipoConsulta, bean, { async: false, callback:function(parametro) {
		if (parametro != null && parametro.valorParametro=="S"){
			editaSucursal = parametro.valorParametro;
            if(habilita){
                habilitaControl('sucursalCte');
            }
		}else {
			editaSucursal = 'N';
			deshabilitaControl('sucursalCte');
		}

    }});
}

$('#sucursalCte').bind('keyup',function(e) {
    lista('sucursalCte', '1', '1','nombreSucurs', $('#sucursalCte').val(), 'listaSucursales.htm');
});

$('#sucursalCte').blur(function() {
    esTab = true;
    if(esTab && !isNaN($('#sucursalCte').val()) && $('#sucursalCte').asNumber()!=0){
        consultaSucursal(this.id);
    }else{
        $('#sucursalCte').val('');
		$('#nombreSucursal').val('');
        $('#sucursalCte').focus();
    }
});

$('#sucursalCte').change(function() {
    if(editaSucursal=="S"){
    	habilitaControl('promotorID');
        $('#promotorID').val("");
        $('#nombrePromotor').val("");
        $('#promotorID').focus();
    }
});
// -------------consulta la sucursal--------------------
function consultaSucursal(idControl) {
    var jqSucursal = eval("'#" + idControl + "'");
    var numSucursal = $(jqSucursal).val();
    var conSucursal = 2;
    setTimeout("$('#cajaLista').hide();", 200);
    if (numSucursal != '' && !isNaN(numSucursal) && esTab) {
        sucursalesServicio.consultaSucursal(conSucursal,
                numSucursal, function(sucursal) {
            if (sucursal != null) {
                $('#nombreSucursal').val(sucursal.nombreSucurs);
                if(editaSucursal=="S"){
                    $("#sucursalID").val(sucursal.sucursalID);
                }
            } else {
                mensajeSis("No Existe la Sucursal.");
                $("#sucursalCte").val("");
                $("#nombreSucursal").val("");
                $("#promotorID").val("");
                $("#nombrePromotor").val("");
                $("#sucursalCte").focus();
                $("#sucursalCte").select();
            }
        });
    }
}

// consulta la tasa de credito
function consultaTasaCredito(idControl, control) {
        var monto =  idControl;
        var cte = $('#clienteID').val();
        var numCred = ''; // variable numero del ciclo del Cliente
        var esGrup = 'S'; // Si
        var cicloCte = $('#numCreditos').asNumber();  // Ciclo individual del cliente
        var cicloCteGrup = $('#cicloClienteGrupal').asNumber();  // Ciclo grupal del cliente
        var producCredesGrup = $('#esGrupal').val();    // producto de credito es grupal si o no
        var producCredPondeGrup = $('#tasaPonderaGru').val(); // producto de credito pondera ciclo de cliente si o no
        if (cte == '') {
            $('#clienteID').val('0');
            $('#pagaIVACte').val('S');
        }

        // If para tomar el valor si el producto de credito es grupal y ademas que si sea ponderado
        if (cicloCteGrup != 0 && producCredesGrup == esGrup
                && producCredPondeGrup == esGrup) {

            numCred = cicloCteGrup;
            $('#numCreditos').val(cicloCteGrup);
        } else {
            numCred = cicloCte;
        }


        setTimeout("$('#cajaLista').hide();", 200);
        // bean para cuando es un cliente
        var credBeanCon = {
                'clienteID'         : $('#clienteID').val(),
                'sucursal'          : $('#sucursalID').val(),
                'producCreditoID'   : $('#productoCreditoID').val(),
                'montoCredito'      : monto,
                'calificaCliente'   : $('#calificaCliente').val(),
                'plazoID'           : $('#plazoID').val(),
                'empresaNomina':    $('#institucionNominaID').val(),
                'convenioNominaID': $('#convenioNominaID').val()

        };

        // bean para cuando no es un cliente y es un prospecto
        var credBeanConsulta = {
                'sucursal' : $('#sucursalID').val(),
                'producCreditoID' : $('#productoCreditoID').val(),
                'montoCredito' : monto,
                'calificaCliente' : $('#calificaCliente').val(),
                'plazoID'           : $('#plazoID').val(),
                'empresaNomina':    $('#institucionNominaID').val(),
                'convenioNominaID': $('#convenioNominaID').val()

        };

        // se ejecuta la función para buscar la tasa
        if (monto != '' && !isNaN(monto)) {


            // solo entra cuando se trata de un cliente
            if ($('#clienteID').val() != '0') {
                if($('#plazoID').val() != ''){
                creditosServicio.consultaTasa(numCred,credBeanCon, { async: false, callback: function(tasas) {
                    if (tasas != null) {

                        tasaProdCred = tasas.valorTasa;
                        if (tasas.valorTasa > 0) {
                            // CARGA NIVEL DE CREDITO CON TASA
                            cargaComboNiveles($('#sucursalID').val(),
                                                $('#productoCreditoID').val(),
                                                numCred,
                                                monto,
                                                $('#calificaCliente').val(),
                                                $('#plazoID').val(),
                                                $('#institucionNominaID').val()
                            );
                            //CUANDO TENGA OPCIONES EL COMBO SE MOSTRARA Y OCULTA EL CAMPO TASA
                            if(document.getElementById("tasaNivel").length > 0){
                                $("#tdTasaFija").hide();
                                $('#tdTasaNivel').show();
                            }else{// SI NO SE LLENA MOSTRARA EL VALOR DE LA TASA QUE SE OBTIENE Y NO EL COMBO

                                $('#tasaFija').val(tasas.valorTasa).change();
                                $("#tdTasaFija").show();
                                $('#tdTasaNivel').hide();
                            }
                            if ($('#calcInteresID').val() > 1 && manejaConvenio != 'S') {
                                $('#tasaBase').val(tasas.valorTasa);
                                validaSobreTasa();
                                esTab = true;
                                consultaTasaBase('tasaBase',true);
                            }
                        } else {
                            mensajeSis("No Hay una Tasa Parametrizada para los Valores Indicados.");
                            $('#montoSolici').val("0.00");
                            montoSolicitudBase = 0.00;
                            $('#tasaFija').val("0.00").change();
                            $('#montoSolici').focus();
                            $('#montoSolici').select();

                            if($('#grupo').val()!=undefined){
                                $('#montoSolici').focus();
                            }else{
                                $('#plazoID').val('');
                            }
                        }

                    } else {
                        mensajeSis("No Hay una Tasa Parametrizada para los Valores Indicados.");
                        $('#montoSolici').val("0.00");
                        montoSolicitudBase = 0.00;
                        $('#tasaFija').val('0.00').change();
                        $('#montoSolici').focus();
                        $('#montoSolici').select();
                    }
                }});
              }
                else{
                    $('#tasaFija').val("0.00").change();
                }
            }
            // solo entra cuando se trata de un Prospecto
            if ($('#prospectoID').val() != '0' && $('#prospectoID').val() != '') {
                if($('#plazoID').val() != ''){
                creditosServicio.consultaTasa(numCred,credBeanConsulta,function(tasas) {
                    if (tasas != null) {
                        if (tasas.valorTasa > 0) {
                            // CARGA NIVEL DE CREDITO CON TASA
                            cargaComboNiveles($('#sucursalID').val(),
                                                $('#productoCreditoID').val(),
                                                numCred,
                                                monto,
                                                $('#calificaCliente').val(),
                                                $('#plazoID').val(),
                                                $('#institucionNominaID').val()
                            );
                            //CUANDO TENGA OPCIONES EL COMBO SE MOSTRARA Y OCULTA EL CAMPO TASA
                            if(document.getElementById("tasaNivel").length > 0){
                                $("#tdTasaFija").hide();
                                $('#tdTasaNivel').show();
                            }else{// SI NO SE LLENA MOSTRARA EL VALOR DE LA TASA QUE SE OBTIENE Y NO EL COMBO
                                $('#tasaFija').val(tasas.valorTasa).change();
                                $("#tdTasaFija").show();
                                $('#tdTasaNivel').hide();
                            }
                            if ($('#calcInteresID').val() > 1) {
                                $('#tasaBase').val(tasas.valorTasa);
                                validaSobreTasa();
                                consultaTasaBase('tasaBase',true);
                            }
                        } else {
                            mensajeSis("No Hay una Tasa Parametrizada para los Valores Indicados.");
                            $('#montoSolici').val("0.00");
                            montoSolicitudBase = 0.00;
                            $('#tasaFija').val('0.00').change();
                            $('#' + control).focus();
                            $('#' + control).select();
                        }

                    } else {
                        mensajeSis("No Hay una Tasa Parametrizada para los Valores Indicados.");
                        $('#montoSolici').val("0.00");
                        montoSolicitudBase = 0.00;
                        $('#tasaFija').val('0.00').change();
                        $('#' + control).focus();
                        $('#' + control).select();
                    }
                });
              }
                else{
                    $('#tasaFija').val("0.00").change();
                }
            }
        }
}

function validacionAccesorios(){
    if(cobraAccesorios=='S' && manejaConvenio =='S' && validaAccesorios(tipoConAccesorio.plazo)==false){
        cobraAccesorios = 'N';
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