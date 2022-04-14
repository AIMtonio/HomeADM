var datosCompletos = false;
var manejaConvenio = 'N';
var manejaQuin = 'N';
var var_numTransaccion = {
    'agregar': 1,
    'modificar': 2,
    'actualizar': 3
};
var var_numActualizacion = {
    "liberar": 1
};
var var_numConsultaSolCredito = {
    "principal": 1,
    "cicloCliente": 3
};
var var_numConsultaCredito = {
    "creditoReestructurar": 23,
    "adeudoTotal": 7
};
var var_numConsultaCliente = {
    "principal": 1,
    "califCliente": 16
};
var var_numConsultaSucursal = {
    "principal": 1,
    "foranea": 2
};
var var_numConsultaPromotor = {
    "foranea": 2
};
var var_numConsultaDestinoCredito = {
    "foranea": 2
};
var var_numConsultaParamSis = {
    "principal": 1
};
var var_numConsultaRelacionCli = {
    "principal": 1
};
var var_numConsultaSeguroVida = {
    "foranea": 2
};
var var_numConsultaEsquemaSV = {
    "esquema": 2,
    "esquemas": 3
};
var var_numConsultaEsquemaGL = {
    "principal": 1,
};
var var_numConsultaProductoCre = {
    "principal": 1,
    "garantiaLiq": 5
};
var var_numConsultaEmpleadoNom = {
    "principal": 1
};
var var_numConsultaInstitucionFon = {
    "principal": 1,
    "foranea": 2
};
var var_numConsultaCalculoYopera = {
    "cuatroDecimales": 2
};
var var_numConsultaPlazosCredito = {
    "principal": 1,
    "fechaVenci": 3,
    "fechaVenciCuota": 4
};
var var_numConsultaHuellaDigital = {
    "principal": 1
};
var var_numListaPlazosCredito = {
    "listaCombo": 3
};
var var_Simulador = {
    "TasaFija_Crecientes": 1,
    "TasaFija_Iguales": 2,
    "TasaFija_Libres": 3,
    "NOTasaFija_Iguales": 4,
    "NOTasaFija_Libres": 5,
    "libres": 7,
    "interesMontoOriginal": 11
};
var var_destinoCredito = {
    'comercial': 'C',
    'consumo': 'O',
    'vivienda': 'H'
};
var var_CalifCliente = {
    "noAsignada": "N",
    "regular": "C",
    "buena": "B",
    "excelente": "A",
    "noAsignadaDes": "NO ASIGNADA",
    "regularDes": "REGULAR",
    "buenaDes": "BUENA",
    "excelenteDes": "EXCELENTE"
};
var var_ComApertura = {
    'PORCENTAJE': 'C',
    'MONTO': 'O'
};
var var_TipoTasa = {
    "TASAFIJA": 1,
    "TASAMASPUNTOS": 1
};
var var_PagoCapital = {
    "IGUALES": "I",
    "CRECIENTES": "C",
    "LIBRES": "L",
    "IGUALESDES": "IGUALES",
    "CRECIENTESDES": "CRECIENTES",
    "LIBRESDES": "LIBRES",
};
var var_Dispersion = {
    "SPEI": "S",
    "CHEQUE": "C",
    "ORDENPAGO": "L",
    "EFECTIVO": "E",
    "SPEIDES": "SPEI",
    "CHEQUEDES": "CHEQUE",
    "ORDENPAGODES": "ORDEN DE PAGO",
    "EFECTIVODES": "EFECTIVO",
};
var var_TipoReporte = {
    "PDF": 1
};
var var_Frecuencia = {
    "SEMANAL": "S",
    "DECENAL": "D",
    "CATORCENAL": "C",
    "QUINCENAL": "Q",
    "MENSUAL": "M",
    "BIMESTRAL": "B",
    "TRIMESTRAL": "T",
    "TETRAMESTRAL": "R",
    "SEMESTRAL": "E",
    "ANUAL": "A",
    "PERIODO": "P",
    "PAGOUNICO": "U",
    "LIBRE": "L",
    "SEMANALDES": "SEMANAL",
    "DECENALDES": "DECENAL",
    "CATORCENALDES": "CATORCENAL",
    "QUINCENALDES": "QUINCENAL",
    "MENSUALDES": "MENSUAL",
    "BIMESTRALDES": "BIMESTRAL",
    "TRIMESTRALDES": "TRIMESTRAL",
    "TETRAMESTRALDES": "TETRAMESTRAL",
    "SEMESTRALDES": "SEMESTRAL",
    "ANUALDES": "ANUAL",
    "PERIODODES": "PERIODO",
    "PAGOUNICODES": "PAGO UNICO",
    "LIBREDES": "LIBRE",
    "SEMANALDIAS": "7",
    "DECENALDIAS": "10",
    "CATORCENALDIAS": "14",
    "QUINCENALDIAS": "15",
    "MENSUALDIAS": "30",
    "BIMESTRALDIAS": "60",
    "TRIMESTRALDIAS": "90",
    "TETRAMESTRALDIAS": "120",
    "SEMESTRALDIAS": "180",
    "ANUALDIAS": "360"
};
var Constantes = {
    "SI": "S",
    "NO": "N",
    "CADENAVACIA": "",
    "ENTEROCERO": 0,
    "DECIMALCERO": "0.00",
    "VALORCERO": "0",
    "ESTATUSINACTIVO": "I",
    "ESTATUSACTIVO": "A",
    "ESTATUSVIGENTE": "V",
    "ESTATUSVENCIDO": "B",
    "FINANCIADO": "F",
    "DEDUCCION": "D",
    "ANTICIPADO": "A",
    "OTRO": "O",
    "FINANCIADODES": "FINANCIADO",
    "DEDUCCIONDES": "DEDUCCION",
    "ANTICIPADODES": "ANTICIPADO",
    "OTRODES": "OTRO",
    "SIGUIENTE": "S",
    "ANTERIOR": "A",
    "FINDEMES": "F",
    "DIADEMES": "D",
    "ANIVERSARIO": "A",
    "INDISTINTO": "I",
    "PROPIO": "P",
    "FONDEO": "F",
    "NUEVASOLICITUDCREDITO": 1,
    "EXISTESOLICITUDCREDITO": 2,
    "ESQUEMAS": "T",
    "PAGOUNICO": "U",
    "MONTOORIGINAL": "2",
    "SALDOINSOLUTO": "1",
    "MONEDAPESOS": "1",
    "REESTRUCTURACRE": "REESTRUCTURA DE CREDITO",
    "CREDITONUEVO": "N",
    "CREDITOREESTRUCTURADO": "R"
};
var tipoConAccesorio = {
    'producto': 38,
    'plazo': 39
};
var parametroBean = consultaParametrosSession();
var usuario = parametroBean.numeroUsuario;
var var_diaSucursal = parametroBean.fechaSucursal.substring(8, 10);
var var_clienteSocio = $("#clienteSocio").val(); // Guarda si el sistema maneja Clientes o Socios
var permiteCambioPromotor = parametroBean.cambiaPromotor; // indica si permite modificar el promotor de la solicitud de credito
var var_funcionHuella = parametroBean.funcionHuella; // Indica si el sistema valida funcionalidad de huella digital
var var_empresaID = 1; // Id de la empresa default
var SolicitudCredito = null; // Guarda el objeto completo de una solicitud de credito consultada
var ProductoCredito = null; // Guarda el objeto completo de un producto de credito
var var_montoSolicitudBase = 0; // monto original (sin comision ni seguro si estos fueran financiados)
var var_productoIDBase = 0; // Id del producto de credito base (el de la solicitud o el consultado)
var var_inicioAfuturo = ""; // Indica si el producto de credito permite desembolso anticipado
var var_diasMaximo = 0; // Indica el numero de dias maximo de desembolso anticipado
var var_DiaPagoCapital = ""; // Idica el dia pago de capital que se utiliza para simular D o F (dia del mes o fin de mes)
var var_DiaPagoInteres = ""; // Idica el dia pago de interes que se utiliza para simular D o F (dia del mes o fin de mes)
var var_requiereHuellaCreditos = ""; // Indica si el sistema valida funcion de huella para creditos
var var_numReestructuraPer = 0; // Indica el numero de veces permitido de reestructuras a un mismo credito
var var_capCubiertoReestruct = 0; // Indica el % de capital cubierto del credito para permitir reestructurarlo
var NumCuotas = 0; // se utiliza para saber cuando se agrega o quita una cuota de capital
var NumCuotasInt = 0; // se utiliza para saber cuando se agrega o quita una cuota de interes
var sucursalUsu = 0;
var TasaFijaID = 1; // ID de la formula para tasa fija (FORMTIPOCALINT)
var TasaBasePisoTecho = 3; // ID de la formula para tasa base con piso y techo (FORMTIPOCALINT)
var hayTasaBase = false; // Indica la existencia de una tasa base
var VarTasaFijaoBase = 'Tasa Fija Anualizada'; // Texto que indica si se trata de tasa fija o tasa base actual (alert)
var esCliente = 'CTE';
var clienteIDBase = 0; // numero de cliente que escoge en un inicio el usuario
var numCliente = [];
var validaCalendario = "";
var validaEstatus = "";
var estatusCred = "";
var fechaVencCred = "";
var procedeSubmit = 1;
var cobraAccesoriosGen = 'N';
var cobraAccesorios = 'N';
var numeroCliente = 0;
var NumClienteConsol = 10;

//variables para servicios adicionales
var aplicaServicioSi = 'S';
var enteroCero = '0';
var listaServiciosAdicionales = [];
var estatusSolicitudCredito = '';
var esNomina = 'N';
consultaReqValCalend();
var mensajeSistema = "";
var diaSistema  = parametroBean.fechaAplicacion.substring(8,10);;
var editaSucursal = "N";

consultaSPL = {
		'opeInusualID' : 0,
		'numRegistro' : 0,
		'permiteOperacion' : 'S',
		'fechaDeteccion' : '1900-01-01'
};

listaPersBloqBean = {
        'estaBloqueado' :'N',
        'coincidencia'  :0
};

//Metodo para consultar si modifica sucursal
function consultaModificaSuc(habilita){
    var tipoConsulta = 58;
    var bean = {
            'empresaID'     : 1
        };
    paramGeneralesServicio.consulta(tipoConsulta, bean, { async: false, callback:function(parametro) {
        if (parametro != null && parametro.valorParametro=="S"){
            if(habilita){
                habilitaControl('sucursalCte');
            }
            editaSucursal = parametro.valorParametro;
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

// ---------------------------------------------- Consulta la sucursal ------------------------------------------------ //
function consultaSucursal(idControl) {
    var jqSucursal = eval("'#" + idControl + "'");
    var sucursalID = $(jqSucursal).val();
    setTimeout("$('#cajaLista').hide();", 200);
    if (sucursalID != Constantes.CADENAVACIA && !isNaN(sucursalID)) {
        sucursalesServicio.consultaSucursal(var_numConsultaSucursal.foranea, sucursalID, {
            async: false,
            callback: function(sucursal) {
                if (sucursal != null) {
                    $(jqSucursal).val(sucursal.sucursalID);
                    $('#nombreSucursal').val(sucursal.nombreSucurs);
                    // se valida que la sucursal del cliente sea la misma que la sucursal del usuario que esta tramitando la reestructura
                    if (Number(sucursalID) != sucursalUsu && editaSucursal=="N") {
                        mensajeSis("La Sucursal del " + var_clienteSocio + " Debe ser Igual a la Sucursal del Usuario.");
                        $("#creditoID").focus();
                        $("#creditoID").select();
                        var primero = numCliente[0];
                        $('#clienteID').val(primero);
                    }
                    if(editaSucursal=="S"){
                        $("#sucursalID").val(sucursal.sucursalID);
                    }
                } else {
                    mensajeSis("No Existe la Sucursal.");
                    $("#sucursalCte").val(Constantes.CADENAVACIA);
	                $("#nombreSucursal").val(Constantes.CADENAVACIA);
	                $("#promotorID").val(Constantes.CADENAVACIA);
	                $("#nombrePromotor").val(Constantes.CADENAVACIA);
	                $("#sucursalCte").focus();
	                $("#sucursalCte").select();
                }
            }
        });
    }
}

function funcion(idControl) {
    var jqControl = eval("'#" + idControl + "'");
    var beanEntrada = {
        'clienteID': $('#clienteID').val()
    };
    setTimeout("$('#cajaLista').hide();", 200);
    nominaEmpleadosServicio.consulta(4, beanEntrada, function(resultado) {
        if (resultado != null) {
            if (resultado.institNominaID == 0 || resultado.institNominaID == null) {
                mensajeSis("El cliente no esta relacionado a una <b>Institución de Nómina</b>");
            }
            if (resultado.convenioNominaID == 0 || resultado.convenioNominaID == null) {
                mensajeSis("El cliente no cuenta con un <b>convenio asignado</b>");
            }
        } else {
            mensajeSis("El cliente no esta relacionado a una <b>Institución de Nómina</b>");
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
            dwr.util.addOptions('convenioNominaID', {
                '': 'SELECCIONAR'
            });
            dwr.util.addOptions('convenioNominaID', resultado, 'convenioNominaID', 'descripcion');
            if (convenioID != "" && convenioID != null) {
                consultaValidaConvenioNomina(convenioID);
            }
            return;
        }
        dwr.util.addOptions('convenioNominaID', {
            '': 'NO SE ENCONTRARON CONVENIOS ACTIVOS'
        });
    });
}

function consultaValidaConvenioNomina(convenioID) {
    $("#montoSolici").focus();
    if (convenioID == ''){
    	return;
    }

    var convenioBean = {
        'convenioNominaID': convenioID
    };
    var institucion = $('#institucionNominaID').val();
    setTimeout("$('#cajaLista').hide();", 200);
    conveniosNominaServicio.consulta(1, convenioBean, function(resultado) {
        if (resultado != null) {
            $("#convenioNominaID").val(convenioID);
            if (resultado.requiereFolio == "S") {
                $(".folioSolici").show();
            } else {
                $(".folioSolici").hide();
                $("#folioSolici").val("");
            }
            if (resultado.manejaQuinquenios == "S") {
                manejaQuin = 'S';
                 existeEsquemaQConvenio(institucion,convenioID);
            } else {
                manejaQuin = 'N';
                $(".quinquenios").hide();
                $("#quinquenioID").val("");
            }
            if (resultado.manejaCalendario == "S") {
                consultaFechaLimite(resultado.institNominaID, resultado.convenioNominaID);
            } else {
                $(".fechaLimiteEnvio").hide();
                $("#fechaLimEnvIns").val("");
            }

            // mostrar grid accesorios
            if(validaAccesorios(tipoConAccesorio.producto) && cobraAccesorios == 'S') {
            	muestraGridAccesorios();
            }
        } else {
            $(".quinquenios").hide();
            mensajeSis("El número de convenio no existe");
            dwr.util.addOptions('convenioNominaID', {
                '': 'SELECCIONAR'
            });
        }
    });
}

function listaCatQuinquenios() {
    dwr.util.removeAllOptions('quinquenioID');
    var catQinqueniosBean = {
        'descripcion': "",
        'descripcionCorta': ""
    };
    var tipoLista = 1;
    dwr.util.addOptions('quinquenioID', {
        '': 'SELECCIONAR'
    });
    catQuinqueniosServicio.lista(tipoLista, catQinqueniosBean, function(quinquenios) {
        dwr.util.addOptions('quinquenioID', quinquenios, 'quinquenioID', 'descripcionCorta');
    });
}
$("#convenioNominaID").blur(function(event) {
    if(manejaConvenio=='S'){
    consultaValidaConvenioNomina($("#convenioNominaID").val());
    }
});

function consultaFechaLimite(institucionID, convenioID) {
    var calendarioIngresosBean = {
        'institNominaID': institucionID,
        'convenioNominaID': convenioID,
        'anio': 0,
        'estatus': "",
    };
    setTimeout("$('#cajaLista').hide();", 200);
    calendarioIngresosServicio.consulta(3, calendarioIngresosBean, function(resultado) {
        if (resultado != null) {
            if(resultado.fechaPrimerAmorti !="1900-01-01"){
                $("#fechaInicioAmor").val(resultado.fechaPrimerAmorti);
            }
            $("#fechaLimEnvIns").val(resultado.fechaLimiteEnvio);
            $(".fechaLimiteEnvio").show();
        } else {
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
            if(resultado.cantidad <= 0 ){

                $("#convenioNominaID").val("");
                $("#convenioNominaID").focus();
                $(".quinquenios").hide();
                 deshabilitaBoton('simular');
                 deshabilitaBoton('agregar');
                mensajeSis("El convenio de la Empresa Nómina no cuenta con un Esquema de Quinquenios parámetrizado");
            }else
            {
                 habilitaBoton('simular');
                 habilitaBoton('agregar');
                $(".quinquenios").show();
                 if($("#solicitudCreditoID").val() == "" && $("#solicitudCreditoID").val() == 0)
                 {
                    $("#quinquenioID").val("");
                 }
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
                    //VALIDACION SI EXISTE UN ESQUEMA DE QUINQUENIO CON EL QUIQUENIO SELECCIONADO
                    if (quinquenio != resultado.quinquenioID && resultado.quinquenioID!=null) {
                         plazos = resultado.plazoID;
                         plazo = $('#plazoID').val();
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
                if(plazos.indexOf(plazo)==0){
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


function grabarTransaccion(event){
    grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'solicitudCreditoID', 'fnExitoTransaccion', 'fnErrorTransaccion');
}

$(document).ready(function() {
    $("#solicitudCreditoID").focus();
    $(':text').bind('keydown', function(e) {
        if (e.which == 9 && !e.shiftKey) {
            esTab = true;
        }
    });
    $(':text').focus(function() {
        esTab = false;
    });
    // ======================================== ACCIONES REALIZADAS AL CARGAR LA PANTALLA ============================================= //
    inicializaValoresPantalla();
    inicializaCamposPantalla();
    deshabilitaCamposPermanente();
    consultaParametrosSistema();
    muestraSeccionSeguroCuota();
    consultaComboCalInteres();
    consultaSICParam();
    consultaCobraAccesorios();
    ClienteEspecifico();
    consultaManejaConvenios();
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
    deshabilitaControl('folioCtrl');
    if (numeroCliente == NumClienteConsol) {
        $('#seguroVida').show();
    } else {
        $('#seguroVida').hide();
    }
    // ---------------------------- Al cargar esta pantalla se valida si el usuario indico un numero de solicitud en la pantalla de flujo
    // individual de renovaciones, para que automaticamente se consulte dicha solicitud en esta pantala -------------------------------- //
    if ($('#numSolicitud').asNumber() >= Constantes.ENTEROCERO) { // numSolicitud hace  referencia a  jsp  flujoIndividualRenovacionVista.jsp
        estatusSimulacion = false;
        var numSolicitud = $('#numSolicitud').val();
        $("#solicitudCreditoID").val(numSolicitud);
        if (numSolicitud != Constantes.CADENAVACIA && Number(numSolicitud) > Constantes.ENTEROCERO && !isNaN(numSolicitud)) {
            consultaSolicitudCredito("solicitudCreditoID");
        }
        $("#solicitudCreditoID").focus();
        $("#solicitudCreditoID").select();
    }
    // =================================================== MANEJO DE EVENTOS DE CAMPOS ======================================================= //
    $("#agregar").click(function() {
    	establecerAplicaServiciosAdicionales();
        $("#tipoTransaccion").val(var_numTransaccion.agregar);
        $("#tipoActualizacion").val(Constantes.VALORCERO);
    });
    $("#modificar").click(function() {
    	establecerAplicaServiciosAdicionales();
        $("#tipoTransaccion").val(var_numTransaccion.modificar);
        $("#tipoActualizacion").val(Constantes.VALORCERO);
    });
    $("#liberar").click(function() {
        $("#tipoTransaccion").val(var_numTransaccion.actualizar);
        $("#tipoActualizacion").val(var_numActualizacion.liberar);
    });
    $("#solicitudCreditoID").bind('keyup', function(e) {
        if (this.value.length >= 2) {
            var camposLista = new Array();
            var parametrosLista = new Array();
            camposLista[0] = "clienteID";
            parametrosLista[0] = $("#solicitudCreditoID").val();
            lista('solicitudCreditoID', '1', '1', camposLista, parametrosLista, 'listaSolicitudCredito.htm');
        }
    });
    $("#solicitudCreditoID").blur(function() {
        deshabilitaControl('sucursalCte');
        estatusSimulacion = false;
        if (this.value != Constantes.CADENAVACIA && Number(this.value) > Constantes.ENTEROCERO && !isNaN(this.value)) {
            consultaSolicitudCredito("solicitudCreditoID");
            muestraSeccionSeguroCuota();
        } else {
            //METODO EDITA SUCURSAL
            consultaModificaSuc(true);
            inicializaCamposPantalla();
            inicializaVariablesGlabales();
            consultaSICParam();
            if (this.value == Constantes.VALORCERO) {
                inicializaValoresNuevaSolicitud();
                consultaSICParam();
            } else {
                this.focus();
                this.select();
            }
        }
    });
    $("#creditoID").bind('keyup', function(e) {
        lista('creditoID', '2', '41', 'creditoID', $("#creditoID").val(), 'ListaCredito.htm');
    });
    $('#clienteID').bind('keyup', function(e) {
        var camposLista = new Array();
        var parametrosLista = new Array();
        camposLista[0] = "nombreCompleto";
        camposLista[1] = "creditoID";
        parametrosLista[0] = $('#clienteID').val();
        parametrosLista[1] = $('#creditoID').val();
        lista('clienteID', '2', '4', camposLista, parametrosLista, 'listaAvales.htm');
    });
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
                                /*validaDatosGrupales('productoCreditoID',Number($('#solicitudCreditoID')   .val()),
                                        Number($('#prospectoID').val()),
                                        Number($('#clienteID').val()),
                                        Number($('#productoCreditoID').val()),
                                        Number($('#grupoID').val()));*/
                                //consultaPorcentajeGarantiaLiquida(this.id);
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
    $("#creditoID").blur(function() {
        if (this.value != Constantes.CADENAVACIA && Number(this.value) > Constantes.ENTEROCERO && !isNaN(this.value)) {
            if (esTab == true) {
                consultaCredito(this);
            }
        }
    });
    $("#promotorID").bind('keyup', function(e) {
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
    $("#promotorID").blur(function() {
        if (esTab == true && !isNaN($('#promotorID').val()) && $('#promotorID').asNumber()>0) {
            consultaPromotor(this.id, true);
        }else{
            $('#promotorID').val('');
            $('#nombrePromotor').val('');
            $('#promotorID').focus();
        }
    });
    $("#institucionNominaID").bind('keyup', function(e) {
        var camposLista = new Array();
        var parametrosLista = new Array();
        camposLista[0] = 'institNominaID';
        camposLista[1] = 'clienteID';
        parametrosLista[0] = $('#institucionNominaID').val();
        parametrosLista[1] = $('#clienteID').val();
        lista('institucionNominaID', '2', '2', camposLista, parametrosLista, 'institucionesNomina.htm');
    });
    $("#institucionNominaID").blur(function() {
        $(".quinquenios").hide();
        consultaInstitucionNomina();
    });
    $("#fechaInicioAmor").change(function() {
        this.focus();
    });
    $("#fechaInicioAmor").blur(function() {
        var dias;
        if (this.value != Constantes.CADENAVACIA) {
            if (esFechaValida(this.value, "fechaInicioAmor") == true) {
                dias = restaFechas(parametroBean.fechaAplicacion, this.value);
                if (parseInt(dias) < Constantes.ENTEROCERO) {
                    mensajeSis("La Fecha de Inicio No debe ser Menor a la Fecha del Sistema.");
                    this.value = parametroBean.fechaAplicacion;
                    this.focus();
                } else {
                    if (parseInt(dias) <= var_diasMaximo) {
                        if (!$("#calendIrregularCheck").is(':checked')) { // Empiece a pagar en NO aplica para pagos de capital LIBRES
                            consultaFechaVencimiento('plazoID');
                        } else {
                            if (this.value != parametroBean.fechaAplicacion) {
                                mensajeSis("La Fecha de Inicio de Primer Amortización \nNo Puede Ser Diferente a la Fecha Actual \nCuando el Calendario de Pagos es Irregular.");
                                this.value = $("#fechaInicio").val();
                                this.focus();
                            }
                        }
                    } else {
                        mensajeSis("La Fecha de Pago puede Iniciar en Máximo " + var_diasMaximo + " Días.");
                        this.value = parametroBean.fechaAplicacion;
                        this.focus();
                    }
                }
            } else {
                this.value = parametroBean.fechaAplicacion;
                this.focus();
            }
        }
    });
    $("#plazoID").change(function() {

        if (this.value != Constantes.CADENAVACIA && parseFloat($("#montoSolici").val()) > Constantes.ENTEROCERO) {
            consultaFechaVencimiento(this.id);
            validaMontoSolicitudCredito(this.id);
            if (cobraAccesorios == 'S' && !validaAccesorios(tipoConAccesorio.plazo)) {
                mensajeSis("No existen Accesorios parametrizados para el Plazo y Producto de Crédito.");
                setTimeout("$('#plazoID').focus();", 0);
            }else if(cobraAccesorios == 'S' && validaAccesorios(tipoConAccesorio.plazo)){
            	muestraGridAccesorios();
            }
        }
    });


    $('#quinquenioID').blur(function() {
        if(manejaConvenio=='S')
            {  if(manejaQuin == 'S'){
                     plazoCorrectoEsquemaQ();
                 }
            }
    });

    $("#plazoID").blur(function() {

         if(manejaConvenio=='S')
         {  if(manejaQuin == 'S')
             {
                plazoCorrectoEsquemaQ();
              }
           }

        if (this.value != Constantes.CADENAVACIA && parseFloat($("#montoSolici").val()) > Constantes.ENTEROCERO) {
            consultaFechaVencimiento(this.id);
            validaMontoSolicitudCredito(this.id);
            if (cobraAccesorios == 'S' && !validaAccesorios(tipoConAccesorio.plazo)) {
                mensajeSis("No existen Accesorios parametrizados para el Plazo y Producto de Crédito.");
                setTimeout("$('#plazoID').focus();", 0);
            }else if(cobraAccesorios == 'S' && validaAccesorios(tipoConAccesorio.plazo)){
            	muestraGridAccesorios();
            }
        }
    });
    $('#sobreTasa').blur(function() {
        if ($('#sobreTasa').val() != '' && $('#sobreTasa').val() != '0') {
            $('#tasaFija').val(parseFloat(valorTasaBase) + $('#sobreTasa').asNumber()).change();
            $('#tasaFija').formatCurrency({
                positiveFormat: '%n',
                roundToDecimalPlace: 4
            });
        }
    });
    $("#calendIrregularCheck").click(function() {
        if ($("#calendIrregularCheck").is(':checked') == true) {
            $("#calendIrregular").val(Constantes.SI);
            $("#fechaInicioAmor").val($("#fechaInicio").val());
            deshabilitaControl('frecuenciaInt');
            deshabilitaControl('frecuenciaCap');
            deshabilitaControl('tipoPagoCapital');
            $("#frecuenciaInt").val(var_Frecuencia.LIBRE).selected = true;
            $("#frecuenciaCap").val(var_Frecuencia.LIBRE).selected = true;
            $("#tipoPagoCapital").val(var_PagoCapital.LIBRES).selected = true;
            $("#numAmortInteres").val('1');
            $("#numAmortizacion").val('1');
            deshabilitaControl('numAmortInteres');
            deshabilitaControl('numAmortizacion');
            validarEsquemaCobroSeguro();
        } else {
            $("#calendIrregular").val(Constantes.NO);
            $("#frecuenciaInt").val(Constantes.CADENAVACIA).selected = true;
            $("#frecuenciaCap").val(Constantes.CADENAVACIA).selected = true;
            $("#tipoPagoCapital").val(Constantes.CADENAVACIA).selected = true;
            $("#montoSeguroCuota").val('');
            habilitaControl('frecuenciaInt');
            habilitaControl('frecuenciaCap');
            habilitaControl('tipoPagoCapital');
            habilitaControl('numAmortizacion');
            if ($("#perIgual").val() == Constantes.SI) {
                deshabilitaControl('numAmortInteres');
            } else {
                habilitaControl('numAmortInteres');
            }
        }
        $("#numTransacSim").val(Constantes.VALORCERO);
    });
    $("#tipoPagoCapital").change(function() {
        estatusSimulacion = false;
        validaTipoPagoCapital();
    });
    $("#tipoPagoCapital").blur(function() {
        validaTipoPagoCapital();
    });
    $("#frecuenciaCap").change(function() {
        validarFrecuencia();
        validaPeriodicidad();
        consultaFechaVencimiento('plazoID');
    });
    $("#frecuenciaCap").blur(function() {
        validarFrecuencia();
        validaPeriodicidad();
        consultaFechaVencimiento('plazoID');
    });
    $("#frecuenciaInt").change(function() {
        validarFrecuencia();
        validaPeriodicidad();
        consultaCuotasInteres('plazoID');
    });
    $("#frecuenciaInt").blur(function() {
        validarFrecuencia();
        validaPeriodicidad();
        consultaCuotasInteres('plazoID');
    });
    $("#diaPagoInteres1").click(function() {
        $("#diaPagoInteres2").attr('checked', false);
        $("#diaPagoInteres1").attr('checked', true);
        $("#diaPagoInteres").val(Constantes.FINDEMES);
        deshabilitaControl('diaMesInteres');
        $("#diaMesInteres").val(Constantes.CADENAVACIA);
    });
    $("#diaPagoInteres2").click(function() {
        $("#diaPagoInteres1").attr('checked', false);
        $("#diaPagoInteres2").attr('checked', true);
        $("#diaPagoInteres").val($('#diaPagoProd').val());
        $("#diaPagoInteres1").attr('checked', false);
        $("#diaPagoInteres2").attr('checked', true);
        $("#diaPagoInteres").val(Constantes.DIADEMES); // Por default se asigna dia del mes
        $("#diaMesInteres").val(var_diaSucursal);
        if ($("#diaPagoProd").val() == Constantes.DIADEMES || $("#diaPagoProd").val() == Constantes.INDISTINTO) { // solo si es Dia del mes o Indistinto se habilita la caja
            habilitaControl('diaMesInteres');
        } else {
            deshabilitaControl('diaMesInteres');
        }
    });
    $("#diaPagoCapital1").click(function() {
        $("#diaPagoCapital2").attr('checked', false);
        $("#diaPagoCapital1").attr('checked', true);
        $("#diaPagoCapital").val(Constantes.FINDEMES);
        deshabilitaControl('diaMesCapital');
        $("#diaMesCapital").val(Constantes.CADENAVACIA);
        if ($("#tipoPagoCapital").val() == var_PagoCapital.CRECIENTES || $('#perIgual').val() == Constantes.SI) {
            $("#diaPagoInteres2").attr('checked', false);
            $("#diaPagoInteres1").attr('checked', true);
            $("#diaPagoInteres").val(Constantes.FINDEMES);
            deshabilitaControl('diaMesInteres');
            $("#diaMesInteres").val(Constantes.CADENAVACIA);
        }
    });
    $("#diaPagoCapital2").click(function() {
        $("#diaPagoCapital1").attr('checked', false);
        $("#diaPagoCapital2").attr('checked', true);
        $("#diaPagoCapital").val(Constantes.DIADEMES); // Por default se asigna dia del mes
        $("#diaMesCapital").val(var_diaSucursal);
        if ($("#diaPagoProd").val() == Constantes.DIADEMES || $("#diaPagoProd").val() == Constantes.INDISTINTO) { // solo si es Dia del mes o Indistinto se habilita la caja
            habilitaControl('diaMesCapital');
        } else {
            deshabilitaControl('diaMesCapital');
        }
        if ($("#tipoPagoCapital").val() == var_PagoCapital.CRECIENTES || $("#perIgual").val() == Constantes.SI) {
            $("#diaPagoInteres1").attr('checked', false);
            $("#diaPagoInteres2").attr('checked', true);
            deshabilitaControl('diaMesInteres');
            $("#diaMesInteres").val(var_diaSucursal);
            $("#diaPagoInteres").val(Constantes.DIADEMES);
        }
    });
    $("#diaMesInteres").blur(function() {
        if (this.value != Constantes.CADENAVACIA) {
            if (parseInt(this.value) > 31) {
                mensajeSis("El Día de Mes Indicado es Incorrecto.");
                this.focus();
                this.select();
            }
        }
    });
    $("#diaMesCapital").blur(function() {
        if (this.value != Constantes.CADENAVACIA) {
            if (parseInt(this.value) <= 31) {
                if ($("#tipoPagoCapital").val() == var_PagoCapital.CRECIENTES || $("#perIgual").val() == Constantes.SI) {
                    $("#diaMesInteres").val($("#diaMesCapital").val());
                }
            } else {
                mensajeSis("El Día de Mes Indicado es Incorrecto.");
                this.focus();
                this.select();
            }
        }
    });
    // valida que el numero de cuotas sólo se modifique +1 cuota, -1 cuota de la calculada
    $("#numAmortInteres").blur(function() {
        if ($("#frecuenciaInt").val() != Constantes.CADENAVACIA) {
            if (parseInt(this.value) > Constantes.ENTEROCERO) {
                var valorMayor = parseInt(NumCuotasInt) + 1;
                var valorMenor = parseInt(NumCuotasInt) - 1;
                if ($("#tipoPagoCapital").val() != var_PagoCapital.LIBRES && $("#frecuenciaInt").val() != var_Frecuencia.PERIODO) {
                    if (this.value > valorMayor) {
                        mensajeSis("Sólo Una Cuota Más.");
                        this.value = NumCuotasInt;
                        this.focus();
                        this.select();
                    } else {
                        if (this.value < valorMenor) {
                            mensajeSis("Sólo Una Cuota Menos.");
                            this.value = NumCuotasInt;
                            this.focus();
                            this.select();
                        } else {
                            if (this.value <= valorMenor) {
                                $("#error2").hide();
                            } else {
                                if ($("#tipoPagoCapital").val() == var_PagoCapital.RECIENTES || $('#perIgual').val() == Constantes.SI) {
                                    this.value = $("#numAmortizacion").val();
                                }
                                consultaFechaVencimientoCuotas('plazoID');
                            }
                        }
                    }
                } else {
                    // valida q el numero de cuotas tecleado * periodicidad no superen el numero de dias del plazo
                    if ($("#frecuenciaInt").val() == var_Frecuencia.PERIODO || ($("#tipoPagoCapital").val() == var_PagoCapital.LIBRES && $("#calendIrregularCheck").is(':checked') == false)) {
                        var diasCalculados = parseInt(this.value) * parseInt($("#periodicidadInt").val());
                        if (parseInt(diasCalculados) > parseInt($("#noDias").val())) {
                            mensajeSis("El Número de Cuotas es Incorrecto Para el Plazo y Frecuencia de Interés Indicados.");
                            this.focus();
                            this.select();
                        }
                    }
                    if ($("#tipoPagoCapital").val() == var_PagoCapital.CRECIENTES || $("#perIgual").val() == Constantes.SI) {
                        $("#numAmortInteres").val($("#numAmortizacion").val());
                    }
                    consultaFechaVencimientoCuotas('plazoID');
                }
            } else {
                mensajeSis("Indique el Número de Cuotas.");
                this.focus();
                this.select();
            }
        }
    });
    // valida que el numero de cuotas sólo se modifique +1 cuota, -1 cuota de la calculada
    $("#numAmortizacion").blur(function() {
        if ($("#frecuenciaCap").val() != Constantes.CADENAVACIA) {
            if (parseInt(this.value) > Constantes.ENTEROCERO) {
                var valorMayor = parseInt(NumCuotas) + 1;
                var valorMenor = parseInt(NumCuotas) - 1;
                if ($("#tipoPagoCapital").val() != var_PagoCapital.LIBRES && $('#frecuenciaCap').val() != var_Frecuencia.PERIODO) {
                    if (this.value > valorMayor) {
                        mensajeSis("Sólo Una Cuota Más.");
                        this.value = NumCuotas;
                        this.focus();
                        this.select();
                    } else {
                        if (this.value < valorMenor) {
                            mensajeSis("Sólo Una Cuota Menos.");
                            this.value = NumCuotas;
                            this.focus();
                            this.select();
                        } else {
                            if (this.value <= valorMenor) {
                                $("#error2").hide();
                            } else {
                                if ($("#tipoPagoCapital").val() == var_PagoCapital.CRECIENTES || $("#perIgual").val() == Constantes.SI) {
                                    $("#numAmortInteres").val(this.value);
                                }
                                consultaFechaVencimientoCuotas('plazoID');
                            }
                        }
                    }
                } else {
                    // valida q el numero de cuotas tecleado * periodicidad no superen el numero de dias del plazo
                    if ($("#frecuenciaCap").val() == var_Frecuencia.PERIODO || ($("#tipoPagoCapital").val() == var_PagoCapital.LIBRES && $("#calendIrregularCheck").is(':checked') == false)) {
                        var diasCalculados = parseInt(this.value) * parseInt($("#periodicidadCap").val());
                        if (parseInt(diasCalculados) > parseInt($("#noDias").val())) {
                            mensajeSis("El Número de Cuotas es Incorrecto Para el Plazo y Frecuencia de Capital Indicados.");
                            this.focus();
                            this.select();
                        }
                    }
                }
            } else {
                mensajeSis("Indique el Número de Cuotas.");
                this.focus();
            }
        }
    });
    $("#simular").click(function() {
        if ($('#tasaFija').asNumber() > Constantes.ENTEROCERO) {
            if ($("#solicitudCreditoID").asNumber() > Constantes.ENTEROCERO && $("#tipoPagoCapital").val() == var_PagoCapital.LIBRES) {
                if ($("#numTransacSim").asNumber() > Constantes.ENTEROCERO) {
                    consultaSimuladorLibres();
                } else {
                    simulador();
                }
            } else {
                simulador();
            }
        } else {
            mensajeSis('Especificar Tasa Fija Anualizada');
            this.focus();
        }
    });
    $('#tipoConsultaSICBuro').click(function() {
        $('#tipoConsultaSICBuro').attr("checked", true);
        $('#tipoConsultaSICCirculo').attr("checked", false);
        $('#consultaBuro').show();
        $('#consultaCirculo').hide();
        $('#folioConsultaCC').val('');
        $('#folioConsultaBC').focus();
        $('#tipoConsultaSIC').val('BC');
    });
    $('#tipoConsultaSICCirculo').click(function() {
        $('#tipoConsultaSICBuro').attr("checked", false);
        $('#tipoConsultaSICCirculo').attr("checked", true);
        $('#consultaBuro').hide();
        $('#consultaCirculo').show();
        $('#folioConsultaBC').val('');
        $('#folioConsultaCC').focus();
        $('#tipoConsultaSIC').val('CC');
    });
    // =============================== VALIDACION DE LA FORMA Y MANEJO DE TRANSACCIONES POST =============================== //
    $.validator.setDefaults({
        submitHandler: function(event) {
            if (($("#tipoTransaccion").val() == var_numTransaccion.agregar || $("#tipoTransaccion").val() == var_numTransaccion.modificar) && estatusSimulacion == false && $("#tipoPagoCapital").val() != var_PagoCapital.LIBRES) {
                mensajeSis("Se Requiere Simular las Amortizaciones.");
            } else {
                if (validaCamposRequeridos()) {
                    if (validaUltimaCuotaCapSimulador()) {
                        consultaReqValCalend();
                        procedeSubmit = validaCredito();
                        if (procedeSubmit == 0) {
                            if(manejaConvenio=='S'){
                            consultaEsquemaQuinquenio();
                            }else{
                                grabarTransaccion({});
                                }
                        }
                    }
                }
            }
        }
    });
    // --------------------------------- Validaciones de la Forma -------------------------------------
    $("#formaGenerica").validate({
        rules: {
            productoCreditoID: 'required',
            promotorID: 'required',
            tipoPagoCapital: 'required',
            frecuenciaCap: 'required',
            plazoID: 'required',
            numAmortizacion: 'required',
            montoSolici: 'required',
            proyecto: 'required',
            destinoCreID: 'required',
            calcInteresID: 'required',
            tasaFija: {
                required: function() {
                    return $("#tasaFija").asNumber() <= 0;
                }
            },
            relacionado: {
                required: true,
                min: 1
            },
            convenioNominaID: {
                required: function() {
                    return $('#institucionNominaID').val() != '0' && $('#institucionNominaID').val() != '' && $('#institucionNominaID').val() != null
                    && manejaConvenio == 'S';
                    }
            },
        },
        messages: {
            productoCreditoID: 'Especifique Producto',
            promotorID: 'Especifique un Promotor.',
            tipoPagoCapital: 'Especifique Tipo Pago de Capital',
            frecuenciaCap: 'Especifique Frecuencia',
            plazoID: 'Especifique Plazos',
            numAmortizacion: 'Especificar No de Cuotas',
            montoSolici: 'Especificar Monto',
            proyecto: 'Especificar Proyecto',
            destinoCreID: 'Especifique Destino de Crédito.',
            calcInteresID: 'Especifique Cálculo de Interés.',
            tasaFija: {
                required: 'Especifique la Tasa'
            },
            fechaInicioAmor: {
                date: 'Fecha Incorrecta'
            },
            relacionado: {
                required: 'Especifique Crédito a Reestructurar',
                min: 'Especifique Crédito a Reestructurar'
            },
            convenioNominaID: {
                required: 'Especifique el convenio.'
            }
        }
    });
    // =======================================      FUNCIONES Y MENTODOS      ========================================== //
    // -------------------  funcion para consultar una solicitud de credito de reestructura de credito -------------------- //
    function consultaSolicitudCredito(campoID) {
        var jqCampo = eval("'#" + campoID + "'");
        var var_solicitudCreditoID = $(jqCampo).val();
        var bean = {
            'solicitudCreditoID': var_solicitudCreditoID,
            'usuario': usuario
        };
        if(var_solicitudCreditoID>0){
            deshabilitaControl('sucursalCte');
            deshabilitaBoton('agregar', 'submit');		
        }
        setTimeout("$('#cajaLista').hide();", 200);
        if (var_solicitudCreditoID != Constantes.CADENAVACIA && !isNaN(var_solicitudCreditoID)) {
            mostrarElementoPorClase('ocultarSeguroCuota', "N");
            solicitudCredServicio.consulta(var_numConsultaSolCredito.principal, bean, {
                async: false,
                callback: function(solicitud) {
                    if (solicitud != null && solicitud.solicitudCreditoID != Constantes.ENTEROCERO) {
                    	
                    	listaPersBloqBean = consultaListaPersBloq(solicitud.clienteID, esCliente, 0, 0);
						consultaSPL = consultaPermiteOperaSPL(solicitud.clienteID,'LPB',esCliente);
						if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
	                        consultaModificaSuc(false);
	                    	estatusSolicitudCredito = solicitud.estatus;
	                        mostrarElementoPorClase('ocultarSeguroCuota', solicitud.cobraSeguroCuota);
	                        // se utiliza  para  saber cuando se agrega  o  quita  una cuota
	                        NumCuotas = solicitud.numAmortizacion;
	                        NumCuotasInt = solicitud.numAmortInteres;
						if (solicitud.flujoOrigen == 'C') {
							mensajeSis("La solicitud " + var_solicitudCreditoID + " es una Consolidaci&oacute;n.<br>Favor de consultarla en el " + "<b><a onclick=\"$('#Contenedor').load('flujoIndividualConsolidacion.htm',function(response, status, xhr){" + "if(status == 'error') {$('#Contenedor').html(response);}});consultaSesion();\">Flujo Individual de Consolidación de Crédito. <img src=\"images/external.png\"></a></b>");
							$('#solicitudCreditoID').val("");
							$('#solicitudCreditoID').focus();
						} else if (solicitud.flujoOrigen != 'C' && solicitud.tipoCredito == 'N') {
							mensajeSis("La solicitud " + var_solicitudCreditoID + " es Nueva.<br>Favor de consultarla en el " + "<b><a onclick=\"$('#Contenedor').load('flujoIndividual.htm',function(response, status, xhr){" + "if(status == 'error') {$('#Contenedor').html(response);}});consultaSesion();\">Flujo Sol. Individual. <img src=\"images/external.png\"></a></b>");
							$('#solicitudCreditoID').val("");
							$('#solicitudCreditoID').focus();
						} else if (solicitud.esReacreditado == 'S') {
							mensajeSis("La solicitud " + var_solicitudCreditoID + " es un Reacreditamiento.<br>Favor de consultarla en el " + "<b><a onclick=\"$('#Contenedor').load('flujoIndividualReacreditamientoVista.htm',function(response, status, xhr){" + "if(status == 'error') {$('#Contenedor').html(response);}});consultaSesion();\">Flujo Individual de Reacreditación. <img src=\"images/external.png\"></a></b>");
							$('#solicitudCreditoID').val("");
							$('#solicitudCreditoID').focus();
						} else if (solicitud.tipoCredito == 'O') {
							mensajeSis("La solicitud " + var_solicitudCreditoID + " es una Renovación.<br>Favor de consultarla en el " + "<b><a onclick=\"$('#Contenedor').load('flujoIndividualRenovacionVista.htm',function(response, status, xhr){" + "if(status == 'error') {$('#Contenedor').html(response);}});consultaSesion();\">Flujo Individual de Renovación. <img src=\"images/external.png\"></a></b>");
							$('#solicitudCreditoID').val("");
							$('#solicitudCreditoID').focus();
						} else if (parseInt(solicitud.grupoID) > Constantes.ENTEROCERO) {
	                            mensajeSis("No se Permite Solicitud de Crédito Grupal para Realizar una Reestructura de Crédito.");
	                            inicializaVariablesGlabales();
	                            inicializaValoresPantalla();
	                            inicializaCamposPantalla();
	                            consultaSICParam();
	                            $(jqCampo).focus();
	                            $(jqCampo).select();
	                        } else {
	                            dwr.util.setValues(solicitud);
	                            SolicitudCredito = solicitud;
	                            var_montoSolicitudBase = solicitud.montoSolici;
	                            if (solicitud.folioSolici != "" && solicitud.folioSolici != null) {
	                                $(".folioSolici").show();
	                                $("#folioSolici").val(solicitud.folioSolici);
	                            } else {
	                                $(".folioSolici").hide();
	                                $("#folioSolici").val("");
	                            }
	                            // No quitar estas dos instrucciones de este lugar
	                            $("#reqSeguroVida").val(Constantes.NO);
	                            $("#forCobroSegVida").val(Constantes.CADENAVACIA);
	                            // Si en la pantalla de solicitud de credito de reestructuras el usuario indica otro numero de solicitud, se debe actualizar
	                            // en la pantalla de flujo individual de reestructuras
	                            if ($('#flujoIndividualBandera').val() != undefined) {
	                                $('#numSolicitud').val($('#solicitudCreditoID').val());
	                            }
	                            if (solicitud.clasifiDestinCred == var_destinoCredito.comercial) {
	                                $('#clasificacionDestin1').attr("checked", true);
	                                $('#clasificacionDestin2').attr("checked", false);
	                                $('#clasificacionDestin3').attr("checked", false);
	                                $('#clasifiDestinCred').val(var_destinoCredito.comercial);
	                            } else if (solicitud.clasifiDestinCred == var_destinoCredito.consumo) {
	                                $('#clasificacionDestin1').attr("checked", false);
	                                $('#clasificacionDestin2').attr("checked", true);
	                                $('#clasificacionDestin3').attr("checked", false);
	                                $('#clasifiDestinCred').val(var_destinoCredito.consumo);
	                            } else {
	                                $('#clasificacionDestin1').attr("checked", false);
	                                $('#clasificacionDestin2').attr("checked", false);
	                                $('#clasificacionDestin3').attr("checked", true);
	                                $('#clasifiDestinCred').val(var_destinoCredito.vivienda);
	                            }
	                            if (solicitud.calendIrregular == Constantes.SI) {
	                                $('#calendIrregularCheck').attr("checked", true);
	                                $('#calendIrregular').val(Constantes.SI);
	                            } else {
	                                $('#calendIrregularCheck').attr("checked", false);
	                                $('#calendIrregular').val(Constantes.NO);
	                            }
	                            if (solicitud.fechInhabil == Constantes.SIGUIENTE) {
	                                $('#fechInhabil').val(Constantes.SIGUIENTE);
	                                $('#fechInhabil1').attr('checked', true);
	                                $('#fechInhabil2').attr("checked", false);
	                            } else {
	                                $('#fechInhabil2').attr('checked', true);
	                                $('#fechInhabil1').attr("checked", false);
	                                $('#fechInhabil').val(Constantes.ANTERIOR);
	                            }
	                            $('#diaPagoCapital').val(solicitud.diaPagoCapital);
	                            $('#diaPagoProd').val(solicitud.diaPagoCapital);
	                            if (solicitud.diaPagoCapital == Constantes.FINDEMES) {
	                                $('#diaPagoCapital1').attr('checked', true);
	                                $('#diaPagoCapital2').attr('checked', false);
	                            } else {
	                                $('#diaPagoCapital2').attr('checked', true);
	                                $('#diaPagoCapital1').attr('checked', false);
	                            }
	                            $('#diaPagoInteres').val(solicitud.diaPagoInteres);
	                            if (solicitud.diaPagoInteres == Constantes.FINDEMES) {
	                                $('#diaPagoInteres1').attr('checked', true);
	                                $('#diaPagoInteres2').attr('checked', false);
	                            } else {
	                                $('#diaPagoInteres1').attr('checked', false);
	                                $('#diaPagoInteres2').attr('checked', true);
	                            }
	                            if (solicitud.comentarioEjecutivo != Constantes.CADENAVACIA && solicitud.comentarioEjecutivo != null) {
	                                $('#comentariosEjecutivo').show();
	                                $('#separa').show(); // td separador
	                            } else {
	                                $('#comentariosEjecutivo').hide();
	                                $('#separa').hide();
	                            }
	                            if (solicitud.estatus == Constantes.ESTATUSINACTIVO) {
	                                $('#fechaInicio').val(parametroBean.fechaAplicacion);
	                                if ((Date.parse($('#fechaInicioAmor').val())) < (Date.parse(parametroBean.fechaAplicacion))) {
	                                    $('#fechaInicioAmor').val(parametroBean.fechaAplicacion);
	                                }
	                                $('#sucursalPromotor').val(solicitud.sucursalPromotor);
	                                $('#promAtiendeSuc').val(solicitud.promAtiendeSuc);
	                                habilitaControl('creditoID');
	                                $('#creditoID').focus();
	                            }
	                            consultaCliente(solicitud.clienteID);
	                            consultaDestinoCredito('destinoCreID');
	                            consultaCambiaPromotor();
	                            consultaProductoCredito('solicitudCreditoID', Constantes.EXISTESOLICITUDCREDITO, solicitud.convenioNominaID);
	
	                              if(manejaConvenio=='S'){
	                                    if (solicitud.quinquenioID!="" && solicitud.quinquenioID!=null) {
	
	                                        $(".quinquenios").show();
	                                        $("#quinquenioID").val(solicitud.quinquenioID);
	                                    }
	                                    else{
	
	                                        $(".quinquenios").hide();
	                                        $("#quinquenioID").val("");
	                                    }
	                                }
	
	                            // mostrar grid accesorios
	                            if(validaAccesorios(tipoConAccesorio.producto) && cobraAccesorios == 'S') {
	                            	muestraGridAccesorios();
	                            }
	
	                            if (solicitud.tipoConsultaSIC != "" && solicitud.tipoConsultaSIC != null) {
	                                $('#comentariosEjecutivo').show();
	                                if (solicitud.tipoConsultaSIC == "BC") {
	                                    $('#tipoConsultaSICBuro').attr("checked", true);
	                                    $('#tipoConsultaSICCirculo').attr("checked", false);
	                                    $('#consultaBuro').show();
	                                    $('#folioConsultaBC').val(solicitud.folioConsultaBC);
	                                    $('#consultaCirculo').hide();
	                                    $('#folioConsultaCC').val('');
	                                } else if (solicitud.tipoConsultaSIC == "CC") {
	                                    $('#tipoConsultaSICBuro').attr("checked", false);
	                                    $('#tipoConsultaSICCirculo').attr("checked", true);
	                                    $('#consultaBuro').hide();
	                                    $('#consultaCirculo').show();
	                                    $('#folioConsultaBC').val('');
	                                    $('#folioConsultaCC').val(solicitud.folioConsultaCC);
	                                }
	                            } else {
	                                //mostrar por defecto valor de parametrossis
	                                consultaSICParam();
	                            }
	                            if (solicitud.calcInteresID > 1) {
	                                consultaTasaBase('tasaBase', true);
	                                validaSobreTasa();
	                                $('#sobreTasa').val(solicitud.sobreTasa);
	                                setTimeout("$('#sobreTasa').blur();", 10);
	                                habilitaControl('sobreTasa');
	                            }
	                        }
	                        $('#CAT').formatCurrency({
	                            positiveFormat: '%n',
	                            roundToDecimalPlace: 1
	                        });
	
	                        if(editaSucursal=="S"){
								$('#sucursalCte').val(solicitud.sucursalID);
								consultaSucursal('sucursalCte');
							}
	                    }else{
	                    	 mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
	                    	 inicializaVariablesGlabales();
	                         inicializaValoresPantalla();
	                         inicializaCamposPantalla();
	                         consultaSICParam();
	                    }
                    } else {
                        mensajeSis("La Solicitud de Credito No Existe.");
                        inicializaVariablesGlabales();
                        inicializaValoresPantalla();
                        inicializaCamposPantalla();
                        consultaSICParam();
                    }
                }
            });
        }
    }

    function consultaCredito(evento) {
        consultaReqValCalend();
        var var_creditoID = evento.value;
        var var_montoPagado = Constantes.ENTEROCERO;
        var var_porcCapCubierto = Constantes.ENTEROCERO;
        var bean = {
            'creditoID': var_creditoID
        };
        setTimeout("$('#cajaLista').hide();", 200);
        if (var_creditoID != Constantes.CADENAVACIA && !isNaN(var_creditoID)) {
            creditosServicio.consulta(var_numConsultaCredito.creditoReestructurar, bean, {
                async: false,
                callback: function(credito) {
                    if (credito != null) {
                    	listaPersBloqBean = consultaListaPersBloq(credito.clienteID, esCliente, 0, 0);
                        consultaSPL = consultaPermiteOperaSPL(credito.clienteID,'LPB',esCliente);
            			if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
							if(credito.esAgropecuario == 'N'){
	                        var SolCredito = credito.solicitudCreditoID;
	                        if (SolCredito == 0) {
	                            dwr.util.setValues(credito);
	                            $("#creditoID").val(credito.creditoID);
	                            $('#sucursalID').val(sucursalUsu);
	                            $('#estatus').val(Constantes.ESTATUSINACTIVO).selected = true;
	                            $('#fechaRegistro').val(parametroBean.fechaAplicacion);
	                            $('#fechaInicioAmor').val(parametroBean.fechaAplicacion);
	                            $('#fechaInicio').val(parametroBean.fechaAplicacion);
	                            $('#fechaVencimiento').val(credito.fechaVencimien);
	                            $('#tasaFija').val(credito.tasaFija);
	                            $('#tasaBase').val(credito.tasaBase);
	                            $('#techoTasa').val(credito.techoTasa);
	                            $('#pisoTasa').val(credito.pisoTasa);
	                            $('#tipoDispersion').val('E');
	                            $('#tipoCredito').val('R');
	                            $('#tipoFondeo').val('P');
	                            $('#institutFondID').val(0);
	                            $('#lineaFondeoID').val(0);
	                            $('#saldoLineaFon').val(0);
	                            $('#tasaPasiva').val(0);
	                            $('#reqSeguroVida').val('N');
	                            estatusCred = credito.estatus;
	                            fechaVencCred = credito.fechaVencimien;
	                            if (credito.fechaVencimien < parametroBean.fechaAplicacion && validaCalendario == 'N') {
	                                deshabilitaBoton('agregar', 'submit');
	                                mensajeSis("La Fecha de Vencimiento debe ser Mayor a la Fecha de Inicio.");
	                                $('#creditoID').val(credito.creditoID);
	                                $('#creditoID').focus();
	                                $('#creditoID').select();
	                            } else {
	                                if (validaEstatus == 'S') {
	                                    var estatusCredito = credito.estatus;
	                                    if (estatusCredito == 'B') {
	                                        deshabilitaBoton('agregar', 'submit');
	                                        mensajeSis("La configuración del Sistema solo permite Reestructurar un Crédito Vigente.");
	                                        $('#creditoID').val(credito.creditoID);
	                                        $('#creditoID').focus();
	                                        $('#creditoID').select();
	                                    }
	                                }
	                            }
	                        } else {
	                            if($("#solicitudCreditoID").asNumber()==0){
	                                mensajeSisRetro({
	                                    mensajeAlert: 'Ya existe una solicitud para este crédito.',
	                                    muestraBtnAceptar: true,
	                                    muestraBtnCancela: false,
	                                    txtAceptar: 'Aceptar',
	                                    txtCancelar: '',
	                                    funcionAceptar: function() {
	                                        $('#solicitudCreditoID').val(SolCredito);
	                                        consultaSolicitudCredito("solicitudCreditoID");
	                                        muestraSeccionSeguroCuota();
	                                    }
	                                });
	                            }                            
	                        }
	                        var montoNotasCargo = 0;
	                        creditosServicio.consulta(var_numConsultaCredito.adeudoTotal, bean, {
	                            async: false,
	                            callback: function(adeudoCredito) {
	                                if (adeudoCredito != null) {
	                                    $("#montoSolici").val(parseFloat(adeudoCredito.saldoCapVencido.replace(',', '')) +
	                                    						parseFloat(adeudoCredito.saldCapVenNoExi.replace(',', '')) +
	                                    						parseFloat(adeudoCredito.saldoCapVigent.replace(',', '')) +
	                                    						parseFloat(adeudoCredito.saldoCapAtrasad.replace(',', '')) +
	                                    						parseFloat(adeudoCredito.saldNotasCargo.replace(',', '')));
	                                    agregarFormatoMoneda('montoSolici');
	                                } else {
	                                    $("#montoSolici").val(Constantes.DECIMALCERO);
	                                }
	                            }
	                        });
	
	                        // mostrar grid accesorios
	                        if(validaAccesorios(tipoConAccesorio.producto) && cobraAccesorios == 'S') {
	                        	muestraGridAccesorios();
	                        }
	                        consultaParametrosSistema();
							var montoCapitalizado = parseFloat(credito.montoCredito) + parseFloat(montoNotasCargo);
	                        var_montoPagado = parseFloat(montoCapitalizado) - $("#montoSolici").asNumber();
	                        var_porcCapCubierto = (var_montoPagado * 100) / parseFloat(montoCapitalizado);
	                        var_porcCapCubiertos = Math.round(var_porcCapCubierto * 100) / 100;
	                        // Solo se pueden reestructurar creditos individuales
	                        if (parseInt(credito.grupoID) <= Constantes.ENTEROCERO) {
	                            // Solo se puede reestructurar un credito vigente o vencido
	                            if (credito.estatus == Constantes.ESTATUSVIGENTE || credito.estatus == Constantes.ESTATUSVENCIDO) {
	                                // Solo se puede reestructurar un credito que no haya sido renovado
	                                if (credito.tipoCredito == Constantes.CREDITONUEVO || credito.tipoCredito == Constantes.CREDITOREESTRUCTURADO) {
	                                    // Solo se puede reestructurar un credito si ya fue cubierto el porcentaje de capital, segun el parametro en param. sistema
	                                    if (var_porcCapCubiertos >= var_capCubiertoReestruct) {
	                                        // Solo se puede reestructurar un credito si esta en el rango de reestructuras permitidas, segun el parmetro en param. sistema
	                                        if (credito.numReestructuras < var_numReestructuraPer) {
	                                            if (credito.clasifiDestinCred == var_destinoCredito.comercial) {
	                                                $('#clasificacionDestin1').attr("checked", true);
	                                                $('#clasificacionDestin2').attr("checked", false);
	                                                $('#clasificacionDestin3').attr("checked", false);
	                                                $('#clasifiDestinCred').val(var_destinoCredito.comercial);
	                                            } else if (credito.clasifiDestinCred == var_destinoCredito.consumo) {
	                                                $('#clasificacionDestin1').attr("checked", false);
	                                                $('#clasificacionDestin2').attr("checked", true);
	                                                $('#clasificacionDestin3').attr("checked", false);
	                                                $('#clasifiDestinCred').val(var_destinoCredito.consumo);
	                                            } else {
	                                                $('#clasificacionDestin1').attr("checked", false);
	                                                $('#clasificacionDestin2').attr("checked", false);
	                                                $('#clasificacionDestin3').attr("checked", true);
	                                                $('#clasifiDestinCred').val(var_destinoCredito.vivienda);
	                                            }
	                                            $("#destinoCreID").val(credito.destinoCreID);
	                                            if (credito.proyecto == Constantes.CADENAVACIA) {
	                                                $("#proyecto").val(Constantes.REESTRUCTURACRE);
	                                            } else {
	                                                $("#proyecto").val(credito.proyecto);
	                                            }
	                                            consultaCliente(credito.clienteID);
	                                            consultaDestinoCredito('destinoCreID');
	                                            $('#productoCreditoID').val(credito.producCreditoID);
	                                            consultaProductoCredito(credito.producCreditoID, Constantes.EXISTESOLICITUDCREDITO, credito.convenioNominaID);
	                                            $('#plazoID').val(credito.plazoID);
	                                            deshabilitaControl('productoCreditoID');
	                                            if (credito.tipoConsultaSIC != "" && credito.tipoConsultaSIC != null) {
	                                                $('#comentariosEjecutivo').show();
	                                                if (credito.tipoConsultaSIC == "BC") {
	                                                    $('#tipoConsultaSICBuro').attr("checked", true);
	                                                    $('#tipoConsultaSICCirculo').attr("checked", false);
	                                                    $('#consultaBuro').show();
	                                                    $('#folioConsultaBC').val(credito.folioConsultaBC);
	                                                    $('#consultaCirculo').hide();
	                                                    $('#folioConsultaCC').val('');
	                                                } else if (credito.tipoConsultaSIC == "CC") {
	                                                    $('#tipoConsultaSICBuro').attr("checked", false);
	                                                    $('#tipoConsultaSICCirculo').attr("checked", true);
	                                                    $('#consultaBuro').hide();
	                                                    $('#consultaCirculo').show();
	                                                    $('#folioConsultaBC').val('');
	                                                    $('#folioConsultaCC').val(credito.folioConsultaCC);
	                                                }
	                                            } else {
	                                                //mostrar por defecto valor de parametrossis
	                                                consultaSICParam();
	                                            }
	                                            if (credito.calcInteresID > 1) {
	                                                validaSobreTasa();
	                                                consultaTasaBase('tasaBase', true);
	                                                $('#sobreTasa').val(credito.sobreTasa);
	                                                habilitaControl('sobreTasa');
	                                            } else {
	                                                $('#tasaBase').val('');
	                                                $('#desTasaBase').val('');
	                                                $('#sobreTasa').val('');
	                                                deshabilitaControl('sobreTasa');
	                                            }
	                                        } else {
	                                            mensajeSis("El Crédito No se Puede Reestructurar. \n" + " Reestructuras Permitidas: " + var_numReestructuraPer + " \n Reestructuras Aplicadas: " + credito.numReestructuras);
	                                            $("#montoSolici").val(Constantes.DECIMALCERO);
	                                            $("#creditoID").val(credito.creditoID);
	                                            evento.focus();
	                                            evento.select();
	                                        }
	                                    } else {
	                                        var var_montoRequerido = parseFloat(montoCapitalizado) * (var_capCubiertoReestruct / 100);
	                                        var var_montoPendiente = var_montoRequerido - var_montoPagado;
	                                        mensajeSis("No se ha Cubierto el Porcentaje de Capital para Realizar Reestructura de Crédito. \n" + " Requerido: " + var_capCubiertoReestruct + " % \n Monto por Pagar: $ " + var_montoPendiente.toFixed(2));
	                                        $("#montoSolici").val(Constantes.DECIMALCERO);
	                                        $("#creditoID").val(credito.creditoID);
	                                        evento.focus();
	                                        evento.select();
	                                    }
	                                } else {
	                                    mensajeSis("No Puede Reestructurar un Crédito que ha Sido Renovado.");
	                                    $("#montoSolici").val(Constantes.DECIMALCERO);
	                                    evento.focus();
	                                    evento.select();
	                                }
	                            } else {
	                                mensajeSistema = "El Crédito a Reestructurar debe estar Vigente o Vencido.";
	                                if( validaEstatus == 'S' ){
	                                    mensajeSistema = "La configuración del Sistema solo permite Reestructurar un Crédito Vigente";
	                                }
	                                mensajeSis(mensajeSistema);
	                                $("#montoSolici").val(Constantes.DECIMALCERO);
	                                evento.focus();
	                                evento.select();
	                            }
	                        } else {
	                            mensajeSis("No se Permite Reestructura de Crédito Grupal.");
	                            $("#montoSolici").val(Constantes.DECIMALCERO);
	                            evento.focus();
	                            evento.select();
	                        }
							}else{
		   						mensajeSis("El Crédito <b>" + credito.creditoID + "</b> es Agropecuario.<br>El trámite debe realizarse en la pantalla <b>Solicitud Reestructura de Crédito Agro</b>:<br> " + "<b><a onclick=\"$('#Contenedor').load('solicitudCreditoReestAgro.htm',function(response, status, xhr){" + "if(status == 'error') {$('#Contenedor').html(response);}});consultaSesion();\"><img src=\"images/external.png\"></a></b>");
								$('#creditoID').focus();
		   					}
	                    }else{
	                    	 mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
	                    	 $("#montoSolici").val(Constantes.DECIMALCERO);
	                         evento.focus();
	                         evento.select();
	                    }
                    } else {
                        mensajeSis("El Credito No Existe.");
                        $("#montoSolici").val(Constantes.DECIMALCERO);
                        evento.focus();
                        evento.select();
                    }
                }
            });
        }
    }
    // --------------------------------------- Consulta las condiciones del producto de credito ---------------------------------- //
    function consultaProductoCredito(idControl, tipoConsulta, convenioID) {
        var jqControl = eval("'#" + idControl + "'");
        var producCreditoID = $("#productoCreditoID").val();
        var convenio = convenioID;
        var bean = {
            'producCreditoID': producCreditoID
        };
        setTimeout("$('#cajaLista').hide();", 200);
        if (producCreditoID != Constantes.CADENAVACIA && !isNaN(producCreditoID)) {
            productosCreditoServicio.consulta(var_numConsultaProductoCre.principal, bean, {
                async: false,
                callback: function(prodCred) {
                    if (prodCred != null) {
                        // SEGUROS
                        if ($('#mostrarSeguroCuota').val() == 'S') {
                            $('#cobraSeguroCuota').val(prodCred.cobraSeguroCuota).selected = true;
                            $('#cobraIVASeguroCuota').val(prodCred.cobraIVASeguroCuota).selected = true;
                        } else {
                            $('#cobraSeguroCuota').val("N").selected = true;
                            $('#cobraIVASeguroCuota').val("N").selected = true;
                        }
                        // FIN SEGUROS
                        ProductoCredito = prodCred;
                        $('#descripProducto').val(prodCred.descripcion);
                        // Si el producto es de nomina

                        if (cobraAccesoriosGen == 'S') {
                            cobraAccesorios = prodCred.cobraAccesorios;
                        }

                        if (prodCred.productoNomina == Constantes.SI) {
                        	 esNomina = prodCred.productoNomina;
                        	 if(esNomina == Constantes.SI){
                             	obtenerServiciosAdicionales();
                             }
                            $("#trNomina").show();
                            if(manejaConvenio=='S'){
                            $('#convenios').show();
                            if(convenio != null && convenio != ""){
                            listaConveniosActivos(convenio);}
                            }else{
                            	 $('#convenios').hide();
                            	}
                            esNomina = Constantes.SI;

                            consultaEmpleadoNomina('clienteID');
                        } else {
                            $("#trNomina").hide();
                            $('#convenios').hide();
                            dwr.util.removeAllOptions('convenioNominaID');
                        }
                        // verifica el credito podra tener un desembolso anticipado
                        if (prodCred.inicioAfuturo == Constantes.SI && ($("#solicitudCreditoID").asNumber() == Constantes.ENTEROCERO || $("#estatus").val() == Constantes.ESTATUSINACTIVO)) {
                            habilitaControl("fechaInicioAmor");
                            $("#fechaInicioAmor").datepicker({
                                showOn: "button",
                                buttonImage: "images/calendar.png",
                                buttonImageOnly: true,
                                changeMonth: true,
                                changeYear: true,
                                dateFormat: 'yy-mm-dd',
                                yearRange: '-100:+10'
                            });
                            var_inicioAfuturo = Constantes.SI;
                            var_diasMaximo = prodCred.diasMaximo;
                        } else {
                            deshabilitaControl("fechaInicioAmor");
                            $("#fechaInicioAmor").datepicker("destroy");
                            var_inicioAfuturo = Constantes.NO;
                            var_diasMaximo = Constantes.ENTEROCERO;
                        }
                        // ******************************************************************************** //
                        if (tipoConsulta == Constantes.NUEVASOLICITUDCREDITO) {
                            // Se Realizan las validaciones
                            if (prodCred.esGrupal == Constantes.SI) {
                                mensajeSis("El Producto de Crédito No Puede ser Grupal.");
                                var_productoIDBase = Constantes.ENTEROCERO;
                                $(jqControl).focus();
                                $(jqControl).select();
                            } else if (prodCred.esReestructura != Constantes.SI) {
                                mensajeSis("El Producto de Crédito No Permite Reestructuras.");
                                var_productoIDBase = Constantes.ENTEROCERO;
                                $(jqControl).focus();
                                $(jqControl).select();
                            }
                            $('#fechaInicioAmor').val(parametroBean.fechaAplicacion);
                            $('#factorMora').val(prodCred.factorMora);
                            $('#calcInteresID').val(prodCred.calcInteres);
                            $('#tipoCalInteres').val(prodCred.tipoCalInteres);
                            if (prodCred.tipoCalInteres == Constantes.MONTOORIGINAL) {
                                $('#tipoPagoCapital').val(var_PagoCapital.IGUALES).selected = true;
                            }
                            consultacicloCliente();
                            validaMontoSolicitudCredito('productoCreditoID');
                        } // Termina NUEVASOLICITUDCREDITO
                        // ******************************************************************************** //
                        else if (tipoConsulta == Constantes.EXISTESOLICITUDCREDITO) {
                            var_productoIDBase = prodCred.producCreditoID;
                        } // Termina EXISTESOLICITUDCREDITO
                        consultaCalendarioProductoCredito();
                        validaCamposPantalla();
                    } else {
                        mensajeSis("No Existe el Producto de Crédito.");
                        $('#productoCreditoID').focus();
                        $('#productoCreditoID').select();
                        $('#descripProducto').val(Constantes.CADENAVACIA);
                        // SEGUROS
                        $('#cobraSeguroCuota').val('N').selected = true;
                        $('#cobraIVASeguroCuota').val('N').selected = true;
                        $('#montoSeguroCuota').val('');
                        deshabilitaControl("fechaInicioAmor");
                        $("#fechaInicioAmor").datepicker("destroy");
                        var_inicioAfuturo = Constantes.NO;
                        var_diasMaximo = Constantes.NTEROCERO;
                        var_productoIDBase = Constantes.NTEROCERO;
                    }
                }
            });
        }
    }
    // ---------------------------- Consulta las condiciones del calendario de pagos del producto de credito ------------------------------//
    function consultaCalendarioProductoCredito() {
        var producCreditoID = $("#productoCreditoID").val();
        var calendarioIrregular;
        if (SolicitudCredito != null && SolicitudCredito.calendIrregular == Constantes.SI) {
            calendarioIrregular = Constantes.SI;
        } else {
            calendarioIrregular = Constantes.NO;
        }
        var bean = {
            'productoCreditoID': producCreditoID
        };
        setTimeout("$('#cajaLista').hide();", 200);
        if (producCreditoID != Constantes.CADENAVACIA && !isNaN(producCreditoID)) {
            calendarioProdServicio.consulta(var_numConsultaProductoCre.principal, bean, {
                async: false,
                callback: function(calendario) {
                    if (calendario != null) {
                        if (calendario.fecInHabTomar == Constantes.SI) {
                            $('#fechInhabil1').attr('checked', true);
                            $('#fechInhabil2').attr("checked", false);
                            $('#fechInhabil').val(Constantes.SIGUIENTE);
                        } else {
                            $('#fechInhabil2').attr('checked', true);
                            $('#fechInhabil1').attr("checked", false);
                            $('#fechInhabil').val(Constantes.ANTERIOR);
                        }
                        if (calendario.ajusFecExigVenc == Constantes.SI) {
                            $('#ajusFecExiVen').val(Constantes.SI);
                        } else {
                            $('#ajusFecExiVen').val(Constantes.NO);
                        }
                        if (calendario.ajusFecUlAmoVen == Constantes.SI) {
                            $('#ajFecUlAmoVen').val(Constantes.SI);
                        } else {
                            $('#ajFecUlAmoVen').val(Constantes.NO);
                        }
                        if (calendarioIrregular == Constantes.SI) {
                            $('#calendIrregularCheck').attr("checked", true);
                            $('#calendIrregular').val(Constantes.SI);
                        } else {
                            $('#calendIrregularCheck').attr('checked', false);
                            $('#calendIrregular').val(Constantes.NO);
                        }
                        if (calendario.permCalenIrreg == Constantes.SI) {
                            habilitaControl('calendIrregularCheck');
                        } else {
                            deshabilitaControl('calendIrregularCheck');
                        }
                        if (calendario.iguaCalenIntCap == Constantes.SI) {
                            $('#perIgual').val(Constantes.SI);
                            deshabilitaControl('frecuenciaInt');
                            deshabilitaControl('numAmortInteres');
                            $("#numAmortInteres").val($("#numAmortizacion").val());
                        } else {
                            $('#perIgual').val(Constantes.NO);
                            habilitaControl('frecuenciaInt');
                            habilitaControl('numAmortInteres');
                        }
                        // VALIDA el dia de pago de capital
                        switch (calendario.diaPagoCapital) {
                            case Constantes.FINDEMES:
                                $('#diaPagoProd').val(Constantes.FINDEMES);
                                habilitaControl('diaPagoCapital1');
                                deshabilitaControl('diaPagoCapital2');
                                $('#diaPagoCapital1').attr('checked', true);
                                $('#diaPagoCapital2').attr('checked', false);
                                $('#diaPagoCapital').val(Constantes.FINDEMES);
                                $('#diaMesCapital').val(Constantes.CADENAVACIA);
                                deshabilitaControl('diaMesCapital');
                                deshabilitaControl('diaPagoInteres1');
                                deshabilitaControl('diaPagoInteres2');
                                $('#diaPagoInteres1').attr('checked', true);
                                $('#diaPagoInteres2').attr('checked', false);
                                $('#diaPagoInteres').val(Constantes.FINDEMES);
                                $('#diaMesInteres').val(Constantes.CADENAVACIA);
                                deshabilitaControl('diaMesInteres');
                                break;
                            case Constantes.ANIVERSARIO:
                                $('#diaPagoProd').val(Constantes.ANIVERSARIO);
                                deshabilitaControl('diaPagoCapital1');
                                deshabilitaControl('diaPagoCapital2');
                                $('#diaPagoCapital2').attr('checked', true);
                                $('#diaPagoCapital1').attr('checked', false);
                                $('#diaMesCapital').val(var_diaSucursal);
                                $('#diaPagoCapital').val(Constantes.DIADEMES);
                                deshabilitaControl('diaMesCapital');
                                deshabilitaControl('diaPagoInteres1');
                                deshabilitaControl('diaPagoInteres2');
                                $('#diaPagoInteres2').attr('checked', true);
                                $('#diaPagoInteres1').attr('checked', false);
                                $('#diaPagoInteres').val(Constantes.DIADEMES);
                                $('#diaMesInteres').val(var_diaSucursal);
                                deshabilitaControl('diaMesInteres');
                                break;
                            case Constantes.DIDADEMES:
                                $('#diaPagoProd').val(Constantes.DIADEMES);
                                deshabilitaControl('diaPagoCapital1');
                                deshabilitaControl('diaPagoCapital2');
                                $('#diaPagoCapital2').attr('checked', true);
                                $('#diaPagoCapital1').attr('checked', false);
                                $('#diaPagoCapital').val(Constantes.DIADEMES);
                                $('#diaMesCapital').val(var_diaSucursal);
                                habilitaControl('diaMesCapital');
                                deshabilitaControl('diaPagoInteres1');
                                deshabilitaControl('diaPagoInteres2');
                                $('#diaPagoInteres2').attr('checked', true);
                                $('#diaPagoInteres1').attr('checked', false);
                                $('#diaPagoInteres').val(Constantes.DIADEMES);
                                $('#diaMesInteres').val(var_diaSucursal);
                                habilitaControl('diaMesInteres');
                                break;
                            case Constantes.INDISTINTO:
                                $('#diaPagoProd').val(Constantes.INDISTINTO);
                                habilitaControl('diaPagoCapital1');
                                habilitaControl('diaPagoCapital2');
                                $('#diaPagoCapital1').attr('checked', true);
                                $('#diaPagoCapital2').attr('checked', false);
                                $('#diaPagoCapital').val(Constantes.FINDEMES);
                                $('#diaMesCapital').val(Constantes.CADENAVACIA);
                                deshabilitaControl('diaMesCapital'); // se deshabilita xq por default se chequea fin de mes
                                habilitaControl('diaPagoInteres1');
                                habilitaControl('diaPagoInteres2');
                                $('#diaPagoInteres1').attr('checked', true);
                                $('#diaPagoInteres2').attr('checked', false);
                                $('#diaPagoInteres').val(Constantes.FINDEMES);
                                $('#diaMesInteres').val(Constantes.CADENAVACIA);
                                deshabilitaControl('diaMesInteres');
                                if (calendario.iguaCalenIntCap == Constantes.SI) {
                                    deshabilitaControl('diaPagoInteres1');
                                    deshabilitaControl('diaPagoInteres2');
                                }
                                break;
                        }
                        consultaComboPlazosCredito(calendario.plazoID);
                        consultaComboTipoPagoCapital(calendario.tipoPagoCapital);
                        consultaComboFrecuencias(calendario.frecuencias);
                    } else {
                        mensajeSis("No Existe un Calendario de Pagos para el Producto de Crédito Indicado.");
                    }
                }
            });
        }
    }
    //------------------------------------- consulta datos del cliente-socio --------------------------------------------//
    function consultaCliente(clienteID) {
        setTimeout("$('#cajaLista').hide();", 200);
        if (clienteID != Constantes.CADENAVACIA && !isNaN(clienteID)) {
            clienteServicio.consulta(var_numConsultaCliente.principal, clienteID, {
                async: false,
                callback: function(cliente) {
                    if (cliente != null) {
                        numCliente.push(cliente.numero);
                        $('#clienteID').val(cliente.numero);
                        $('#nombreCte').val(cliente.nombreCompleto);
                        $('#pagaIVACte').val(cliente.pagaIVA);
                        if(editaSucursal=="N" || (editaSucursal=="S" && $('#solicitudCreditoID').val() == 0)){
                            $('#sucursalCte').val(cliente.sucursalOrigen);
                            consultaSucursal('sucursalCte');
                        }
                        if (cliente.esMenorEdad == Constantes.SI) {
                            mensajeSis("El " + var_clienteSocio + " es Menor de Edad, No es Posible Asignar Crédito.");
                            $('#clienteID').focus();
                            $('#clienteID').select();
                            $('#nombreCte').val(Constantes.CADENAVACIA);
                        } else {
                            $('#calificaCliente').val(cliente.calificaCredito);
                            switch (cliente.calificaCredito) {
                                case var_CalifCliente.noAsignada:
                                    $('#calificaCredito').val(var_CalifCliente.noAsignadaDes);
                                    break;
                                case var_CalifCliente.excelente:
                                    $('#calificaCredito').val(var_CalifCliente.excelenteDes);
                                    break;
                                case var_CalifCliente.regular:
                                    $('#calificaCredito').val(var_CalifCliente.regularDes);
                                    break;
                                case var_CalifCliente.buena:
                                    $('#calificaCredito').val(var_CalifCliente.buendaDes);
                                    break;
                                default:
                                    $('#calificaCredito').val(Constantes.CADENAVACIA);
                                    break;
                            }
                            // la consulta de cliente es para solicitud de credito nueva
                            if ($('#solicitudCreditoID').val() == Constantes.CADENAVACIA || $('#solicitudCreditoID').val() == Constantes.VALORCERO) {
                                if (cliente.estatus == Constantes.ESTATUSINACTIVO) {
                                    deshabilitaBoton('agregar', 'submit');
                                    mensajeSis("El " + var_clienteSocio + " se Encuentra Inactivo.");
                                    $('#creditoID').focus();
                                    $('#creditoID').select();
                                    $('#nombrePromotor').val(Constantes.CADENAVACIA);
                                    $('#nombreCte').val(Constantes.CADENAVACIA);
                                    $('#promotorID').val(Constantes.CADENAVACIA);
                                    $('#sucursalCte').val(Constantes.CADENAVACIA);
                                    $('#calificaCredito').val(Constantes.CADENAVACIA);
                                    $('#nombreSucursal').val(Constantes.CADENAVACIA);
                                }
                            } else {
                                // la consulta de cliente es para una solicitud de credito existente
                                if (cliente.estatus == Constantes.ESTATUSINACTIVO) {
                                    deshabilitaBoton('agregar', 'submit');
                                    deshabilitaBoton('modificar', 'submit');
                                    deshabilitaBoton('liberar', 'submit');
                                    mensajeSis("El " + var_clienteSocio + " se Encuentra Inactivo.");
                                    $('#solicitudCreditoID').focus();
                                    $('#solicitudCreditoID').select();
                                }
                            }
                            if ($('#solicitudCreditoID').val() == Constantes.ENTEROCERO) {
                                $('#promotorID').val(cliente.promotorActual);
                            } else {
                                $('#promotorID').val(SolicitudCredito.promotorID);
                            }
                            consultaPromotor('promotorID', false);
                            consultacicloCliente();
                            if (var_funcionHuella == Constantes.SI && var_requiereHuellaCreditos == Constantes.SI) {
                                consultaHuellaCliente();
                            }
                        }
                    } else {
                        if ($('#clienteID').asNumber() != Constantes.VALORCERO) {
                            mensajeSis("El " + var_clienteSocio + " Especificado no Existe.");
                            $('#clienteID').focus();
                            $('#clienteID').select();
                            $('#calificaCredito').val(Constantes.CADENAVACIA);
                        }
                    }
                }
            });
            // consulta la calificacion numerica del cliente
            clienteServicio.consulta(var_numConsultaCliente.califCliente, clienteID, function(cliente) {
                if (cliente != null) {
                    calificacionCliente = cliente.calificacion;
                }
            });
        }
    }
    // --------------------------------------------- Consulta del promotor ------------------------------------------------- //
    function consultaPromotor(idControl, valida) {
        var jqPromotor = eval("'#" + idControl + "'");
        var promotorID = $(jqPromotor).val();
        var bean = {
            'promotorID': promotorID
        };
        setTimeout("$('#cajaLista').hide();", 200);
        if (promotorID != Constantes.CADENAVACIA && !isNaN(promotorID)) {
            promotoresServicio.consulta(var_numConsultaPromotor.foranea, bean, {
                async: false,
                callback: function(promotor) {
                    if (promotor != null) {
                        $(jqPromotor).val(promotor.promotorID);
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
                        //CALCULO DE LA TASA
                        if(editaSucursal=="S" && $('#montoSolici').val()!=0 && $('#montoSolici').val()!="" && $('#plazoID').val()!=""){
                            consultaTasaCredito($('#montoSolici').asNumber(),'montoSolici');
                        }
                    } else {
                        mensajeSis("No Existe el Promotor.");
                        $('#promotorID').focus();
                        $('#promotorID').select();
                        $('#nombrePromotor').val(Constantes.CADENAVACIA);
                    }
                }
            });
        } else {
            $('#promotorID').val(Constantes.CADENAVACIA);
            $('#nombrePromotor').val(Constantes.CADENAVACIA);
        }
    }
    // ------------------------------------- Consulta ciclo del cliente ----------------------------------------- //
    function consultacicloCliente() {
        var clienteID = $('#clienteID').val();
        var bean = {
            'clienteID': clienteID,
            'prospectoID': $('#prospectoID').val(),
            'productoCreditoID': $('#productoCreditoID').val(),
            'grupoID': $('#grupoID').val()
        };
        setTimeout("$('#cajaLista').hide();", 200);
        if (clienteID != Constantes.CADENAVACIA && clienteID > Constantes.ENTEROCERO && !isNaN(clienteID)) {
            solicitudCredServicio.consultaCiclo(bean, {
                async: false,
                callback: function(cicloCreditoCte) {
                    if (cicloCreditoCte != null) {
                        $('#numCreditos').val(cicloCreditoCte.cicloCliente);
                    } else {
                        mensajeSis("No hay Ciclo para el " + var_clienteSocio + ".");
                        $('#numCreditos').val(Constantes.VALORCERO);
                    }
                }
            });
        }
    }
    // ------------------------------- Consulta la tasa de interes para el credito -------------------------------------- //
    function consultaTasaCredito(monto, idControl) {
        setTimeout("$('#cajaLista').hide();", 200);
        var montoCredito = monto;
        var clienteID = $('#clienteID').val();
        var cicloCliente = $('#numCreditos').asNumber(); // Ciclo individual del cliente
        if (clienteID == Constantes.ENTEROCERO) {
            $('#clienteID').val(Constantes.VALORCERO);
            $('#pagaIVACte').val(Constantes.SI);
        }
        // bean para cuando es un cliente
        var beanCliente = {
            'clienteID': $('#clienteID').val(),
            'sucursal': $('#sucursalID').asNumber(),
            'producCreditoID': $('#productoCreditoID').val(),
            'montoCredito': montoCredito,
            'calificaCliente': $('#calificaCliente').val(),
            'plazoID': $('#plazoID').val(),
            'empresaNomina': $('#institucionNominaID').val(),
            'convenioNominaID': $('#convenioNominaID').val()
        };
        if (montoCredito != Constantes.CADENAVACIA && !isNaN(montoCredito)) {
            if ($('#clienteID').val() != Constantes.VALORCERO && !isNaN($('#clienteID').val())) {
                if ($('#productoCreditoID').val() != Constantes.VALORCERO && !isNaN($('#productoCreditoID').val())) {
                    if ($('#plazoID').val() != Constantes.CADENAVACIA) {
                        creditosServicio.consultaTasa(cicloCliente, beanCliente, {
                            async: false,
                            callback: function(tasas) {
                                if (tasas != null) {
                                    if (tasas.valorTasa > Constantes.ENTEROCERO) {
                                        $('#tasaFija').val(tasas.valorTasa);
                                    } else {
                                        mensajeSis("No Hay una Tasa Parametrizada para los Valores Indicados.");
                                        $('#tasaFija').val(Constantes.DECIMALCERO);
                                        $('#' + idControl).focus();
                                        $('#' + idControl).select();
                                    }
                                } else {
                                    mensajeSis("No Hay una Tasa Parametrizada para los Valores Indicados.");
                                    $('#tasaFija').val(Constantes.DECIMALCERO);
                                    $('#' + idControl).focus();
                                    $('#' + idControl).select();
                                }
                            }
                        });
                    } else {
                        $('#tasaFija').val(Constantes.DECIMALCERO);
                    }
                } else {
                    $('#tasaFija').val(Constantes.DECIMALCERO);
                }
            } else {
                $('#tasaFija').val(Constantes.DECIMALCERO);
            }
        } else {
            $('#tasaFija').val(Constantes.DECIMALCERO);
        }
    }
    // ------------------ Consulta el destino de credito, tambien Destino Crédito FR y Destino Crédito FOMUR  ---------------------- //
    function consultaDestinoCredito(idControl) {
        setTimeout("$('#cajaLista').hide();", 200);
        var jqDestino = eval("'#" + idControl + "'");
        var destinoCreID = $(jqDestino).val();
        var bean = {
            'destinoCreID': destinoCreID
        };
        if (destinoCreID != Constantes.CADENAVACIA && !isNaN(destinoCreID)) {
            destinosCredServicio.consulta(var_numConsultaDestinoCredito.foranea, bean, {
                async: false,
                callback: function(destinos) {
                    if (destinos != null) {
                        $('#descripDestino').val(destinos.descripcion);
                        $('#descripDestinoFR').val(destinos.desCredFR);
                        $('#descripDestinoFOMUR').val(destinos.desCredFOMUR);
                        $('#destinCredFRID').val(destinos.destinCredFRID);
                        $('#destinCredFOMURID').val(destinos.destinCredFOMURID);
                        if (destinos.clasificacion == var_destinoCredito.comercial) {
                            $('#clasificacionDestin1').attr("checked", true);
                            $('#clasificacionDestin2').attr("checked", false);
                            $('#clasificacionDestin3').attr("checked", false);
                            $('#clasifiDestinCred').val('C');
                        } else if (destinos.clasificacion == var_destinoCredito.consumo) {
                            $('#clasificacionDestin1').attr("checked", false);
                            $('#clasificacionDestin2').attr("checked", true);
                            $('#clasificacionDestin3').attr("checked", false);
                            $('#clasifiDestinCred').val('O');
                        } else {
                            $('#clasificacionDestin1').attr("checked", false);
                            $('#clasificacionDestin2').attr("checked", false);
                            $('#clasificacionDestin3').attr("checked", true);
                            $('#clasifiDestinCred').val('H');
                        }
                    } else {
                        mensajeSis("No Existe el Destino de Crédito.");
                        $('#solicitudCreditoID').focus();
                        $('#solicitudCreditoID').select();
                        $('#descripDestino').val(Constantes.CADENAVACIA);
                        $('#descripDestinoFR').val(Constantes.CADENAVACIA);
                        $('#descripDestinoFOMUR').val(Constantes.CADENAVACIA);
                        $('#destinCredFRID').val(Constantes.CADENAVACIA);
                        $('#destinCredFOMURID').val(Constantes.CADENAVACIA);
                    }
                }
            });
        }
    }
    // ------------------------------- Consulta el nombre de la institucion de nomina -----------------------------------  //
    function consultaInstitucionNomina() {
        deshabilitaControl('folioCtrl');
        $('#folioCtrl').val("");
        var tipoCon = 8;
        var institucionNominaID = $('#institucionNominaID').val();
        var cliente = $('#clienteID').val();
        var bean = {
            'institNominaID': institucionNominaID,
            'clienteID': cliente
        };
        setTimeout("$('#cajaLista').hide();", 200);
        if (institucionNominaID != Constantes.CADENAVACIA && !isNaN(institucionNominaID)) {
            institucionNomServicio.consulta(tipoCon, bean, {
                async: false,
                callback: function(institucionNomina) {
                    if (institucionNomina != null) {
                        $('#nombreInstit').val(institucionNomina.nombreInstit);
                        $('#folioCtrl').val(institucionNomina.noEmpleado);
                        if(manejaConvenio=='S'){
                        listaConveniosActivos();
                        }

                        if (esNomina === Constantes.SI){
                        	obtenerServiciosAdicionales();
                        }
                    } else {
                        mensajeSis("La Empresa de Nómina no Existe.");
                        $('#nombreInstit').val(Constantes.CADENAVACIA);
                        $('#institucionNominaID').focus();
                        $('#institucionNominaID').select();
                        $('#folioCtrl').val("");
                        if(manejaConvenio=='S'){
                        dwr.util.removeAllOptions('convenioNominaID');
                        }
                    }
                }
            });
        } else {
            $('#institucionNominaID').val(Constantes.CADENAVACIA);
            $('#nombreInstit').val(Constantes.CADENAVACIA);
        }
    }
    // ------------------- Consulta numero de empleado de nómina del cliente cuando el producto de credito es de Nomina ---------------------- //
    function consultaEmpleadoNomina() {
        var clienteID = $("#clienteID").val();
        setTimeout("$('#cajaLista').hide();", 200);
        if (clienteID != Constantes.CADENAVACIA && !isNaN(clienteID)) {
            clienteServicio.consulta(var_numConsultaEmpleadoNom.principal, clienteID, {
                async: false,
                callback: function(cliente) {
                    if (cliente != null) {
                        $('#folioCtrl').val(cliente.noEmpleado);
                    }
                }
            });
        }
    }
    // --------- Clacula o recalcula y Valida, tasa de interes y Garantia Liquida y otras validaciones --------//
    function validaMontoSolicitudCredito(controlID) {
        // Si el monto de la solicitud de credito esta dentro de los montos permitidos por el producto de credito
        if (validaLimiteMontoSolicitado(controlID)) {
            // La tasa de interes se calcula tomando el monto total de la solicitud de credito
            consultaTasaCredito($('#montoSolici').asNumber(), controlID);
            // La garantia liquida se calcula tomando el monto total de la solicitud de credito
            calculaGarantiaLiquida(controlID);
        }
    }
    // ----------------------------------------------- validaciones del monto solicitado  ---------------------------------------------------- //
    function validaLimiteMontoSolicitado(controlID) {
        var continuar = false;
        // se valida que el monto solicitado no sea mayor a lo parametrizado
        if ($('#montoSolici').asNumber() > parseFloat(ProductoCredito.montoMaximo)) {
            continuar = false;
            $('#montoSolici').val(ProductoCredito.montoMaximo);
            agregarFormatoMoneda('montoSolici');
            mensajeSis("El Monto Solicitado No debe ser Mayor a " + $('#montoSolici').val());
            $('#montoSolici').val(Constantes.DECIMALCERO);
            var_montoSolicitudBase = Constantes.ENTEROCERO;
            $('#' + controlID).focus();
            $('#' + controlID).select();
        } else {
            // se valida que el monto no se sea menos a lo parametrizado
            if ($('#montoSolici').asNumber() < parseFloat(ProductoCredito.montoMinimo) && $('#montoSolici').val() != Constantes.CADENAVACIA) {
                continuar = false;
                $('#montoSolici').val(ProductoCredito.montoMinimo);
                agregarFormatoMoneda('montoSolici');
                mensajeSis('El Monto Solicitado No debe ser Menor a ' + $('#montoSolici').val());
                $('#montoSolici').val(Constantes.DECIMALCERO);
                var_montoSolicitudBase = Constantes.ENTEROCERO;
                $('#' + controlID).focus();
                $('#' + controlID).select();
            } else {
                continuar = true;
            }
        }
        return continuar;
    }
    // ---------- Consulta el porcentaje de garantia liquida que corresponde pagar por el credito de acuerdo a la calif del cliente ---------- //
    function calculaGarantiaLiquida(controlID) {
        var jqControl = eval("'#" + controlID + "'");

        var producCreditoID = $("#productoCreditoID").val();
        var productoCreditoBean = {
            'producCreditoID': producCreditoID
        };
        // verifica que el producto de credito en pantalla requiere garantia liquida
        productosCreditoServicio.consulta(var_numConsultaProductoCre.garantiaLiq, productoCreditoBean, {
            async: false,
            callback: function(respuesta) {
                if (respuesta != null) {
                    if (respuesta.requiereGarantia == Constantes.SI) {
                        var clienteID = Constantes.ENTEROCERO;
                        var calificaCli = $('#calificaCliente').val();
                        var monto = $("#montoSolici").asNumber();
                        // verifica que los datos necesario para la consulta NO esten vacios.
                        if (parseInt(producCreditoID) > Constantes.ENTEROCERO && calificaCli != Constantes.CADENAVACIA && parseFloat(monto) > Constantes.ENTEROCERO) {
                            var bean = {
                                'producCreditoID': producCreditoID,
                                'clienteID': clienteID,
                                'calificacion': calificaCli,
                                'montoSolici': monto
                            };
                            // obtiene el porcentaje de garantia liquida
                            esquemaGarantiaLiqServicio.consulta(var_numConsultaEsquemaGL.principal, bean, {
                                async: false,
                                callback: function(respuesta) {
                                    if (respuesta != null) {
                                        $('#porcGarLiq').val(respuesta.porcentaje);
                                        $('#porcentaje').val(respuesta.porcentaje);
                                        // se realiza el calculo de GL, esta consulta devolvera el valor a 2 decimales
                                        var calcOperBean = {
                                            'valorUnoA': Constantes.ENTEROCERO,
                                            'valorDosA': Constantes.ENTEROCERO,
                                            'valorUnoB': $('#montoSolici').val(),
                                            'valorDosB': $('#porcGarLiq').asNumber() / 100,
                                            'numeroDecimales': 2
                                        };
                                        calculosyOperacionesServicio.calculosYOperaciones(var_numConsultaCalculoYopera.cuatroDecimales, calcOperBean, {
                                            async: false,
                                            callback: function(valoresResultado) {
                                                if (valoresResultado != null) {
                                                    $('#aporteCliente').val(valoresResultado.resultadoCuatroDecimales);
                                                    agregarFormatoMoneda('aporteCliente');
                                                } else {
                                                    mensajeSis("Ocurrio un Error al Calcular Monto de Garantía Líquida.");
                                                    $('#aporteCliente').val(Constantes.DECIMALCERO);
                                                }
                                            }
                                        });
                                    } else {
                                        mensajeSis("No Existe un Esquema de Garantía Líquida para el Producto de Crédito, Calificación del " + var_clienteSocio + ", Plazo y Monto Indicado.");
                                        $(jqControl).focus();
                                        $(jqControl).select();
                                        $('#porcGarLiq').val(Constantes.DECIMALCERO);
                                        $('#porcentaje').val(Constantes.DECIMALCERO);
                                        $('#aporteCliente').val(Constantes.DECIMALCERO);
                                    }
                                }
                            });
                        } else {
                            $('#porcGarLiq').val(Constantes.DECIMALCERO);
                            $('#porcentaje').val(Constantes.DECIMALCERO);
                            $('#aporteCliente').val(Constantes.DECIMALCERO);
                        }
                    } else {
                        $('#porcGarLiq').val(Constantes.DECIMALCERO);
                        $('#porcentaje').val(Constantes.DECIMALCERO);
                        $('#aporteCliente').val(Constantes.DECIMALCERO);
                    }
                } // termina comparacion si es null si el producto de credito no requiere garantia liquida
                else {
                    $('#porcGarLiq').val(Constantes.DECIMALCERO);
                    $('#porcentaje').val(Constantes.DECIMALCERO);
                    $('#aporteCliente').val(Constantes.DECIMALCERO);
                }
            }
        });
    }
    // --------------------------------- Consulta los plazos del calendario del producto de credito ------------------------------------ //
    function consultaComboPlazosCredito(datos) {
        dwr.util.removeAllOptions('plazoID');
        $('#plazoID').append(new Option('SELECCIONAR', "", true, true));
        if (datos != null) {
            var plazo = datos.split(',');
            var tamanio = plazo.length;
            plazosCredServicio.listaCombo(var_numListaPlazosCredito.listaCombo, {
                async: false,
                callback: function(plazoCreditoBean) {
                    for (var i = 0; i < tamanio; i++) {
                        for (var j = 0; j < plazoCreditoBean.length; j++) {
                            if (plazo[i] == plazoCreditoBean[j].plazoID) {
                                $('#plazoID').append(new Option(plazoCreditoBean[j].descripcion, plazo[i], false, true));
                                break;
                            }
                        }
                    }
                }
            });
            if (SolicitudCredito != null) {
                $('#plazoID').val(SolicitudCredito.plazoID).selected = true;
            } else {
                $('#plazoID').val(Constantes.CADENAVACIA).selected = true;
            }
        }
    }
    // -------------------- Consulta los tipos de pago de capital de acuerdo al calendario del producto de credito ------------------- //
    function consultaComboTipoPagoCapital(datos) {
        dwr.util.removeAllOptions('tipoPagoCapital');
        $('#tipoPagoCapital').append(new Option('SELECCIONAR', "", true, true));
        if (datos != null) {
            var tpago = datos.split(',');
            var tamanio = tpago.length;
            for (var i = 0; i < tamanio; i++) {

                switch (tpago[i]) {
                    case var_PagoCapital.CRECIENTES:
                        $('#tipoPagoCapital').append(new Option(var_PagoCapital.CRECIENTESDES, tpago[i], false, true));
                        break;
                    case var_PagoCapital.IGUALES:
                        $('#tipoPagoCapital').append(new Option(var_PagoCapital.IGUALESDES, tpago[i], false, true));
                        break;
                    case var_PagoCapital.LIBRES:
                        $('#tipoPagoCapital').append(new Option(var_PagoCapital.LIBRESDES, tpago[i], false, true));
                        break;
                }
            }
            if ($('#tipoCalInteres').val() == Constantes.MONTOORIGINAL) {
                $('#tipoPagoCapital').val(var_PagoCapital.IGUALES).selected = true;
                deshabilitaControl('tipoPagoCapital');
            } else {
                if (SolicitudCredito != null) {
                    $('#tipoPagoCapital').val(SolicitudCredito.tipoPagoCapital).selected = true;
                    if (SolicitudCredito.estatus == Constantes.ESTATUSINACTIVO) {
                        habilitaControl('tipoPagoCapital');
                    } else {
                        deshabilitaControl('tipoPagoCapital');
                    }
                } else {
                    $('#tipoPagoCapital').val(Constantes.CADENAVACIA).selected = true;
                    habilitaControl('tipoPagoCapital');
                }
            }
        }
    }
    // ------------------ Consulta las frecuencias de interes y de capital de acuerdo al calendario del producto de credito ----------------- //
    function consultaComboFrecuencias(datos) {
        dwr.util.removeAllOptions('frecuenciaCap');
        $('#frecuenciaCap').append(new Option('SELECCIONAR', "", true, true));
        dwr.util.removeAllOptions('frecuenciaInt');
        $('#frecuenciaInt').append(new Option('SELECCIONAR', "", true, true));
        if (datos != null) {
            var frecuencias = datos.split(',');
            var tamanio = frecuencias.length;
            for (var i = 0; i < tamanio; i++) {
                switch (frecuencias[i]) {
                    case var_Frecuencia.SEMANAL:
                        $('#frecuenciaCap').append(new Option(var_Frecuencia.SEMANALDES, frecuencias[i], false, true));
                        $('#frecuenciaInt').append(new Option(var_Frecuencia.SEMANALDES, frecuencias[i], false, true));
                        break;
                    case var_Frecuencia.DECENAL:
                        $('#frecuenciaCap').append(new Option(var_Frecuencia.DECENALDES, frecuencias[i], false, true));
                        $('#frecuenciaInt').append(new Option(var_Frecuencia.DECENALDES, frecuencias[i], false, true));
                        break;
                    case var_Frecuencia.CATORCENAL:
                        $('#frecuenciaCap').append(new Option(var_Frecuencia.CATORCENALDES, frecuencias[i], false, true));
                        $('#frecuenciaInt').append(new Option(var_Frecuencia.CATORCENALDES, frecuencias[i], false, true));
                        break;
                    case var_Frecuencia.QUINCENAL:
                        $('#frecuenciaCap').append(new Option(var_Frecuencia.QUINCENALDES, frecuencias[i], false, true));
                        $('#frecuenciaInt').append(new Option(var_Frecuencia.QUINCENALDES, frecuencias[i], false, true));
                        break;
                    case var_Frecuencia.MENSUAL:
                        $('#frecuenciaCap').append(new Option(var_Frecuencia.MENSUALDES, frecuencias[i], false, true));
                        $('#frecuenciaInt').append(new Option(var_Frecuencia.MENSUALDES, frecuencias[i], false, true));
                        break;
                    case var_Frecuencia.BIMESTRAL:
                        $('#frecuenciaCap').append(new Option(var_Frecuencia.BIMESTRALDES, frecuencias[i], false, true));
                        $('#frecuenciaInt').append(new Option(var_Frecuencia.BIMESTRALDES, frecuencias[i], false, true));
                        break;
                    case var_Frecuencia.TRIMESTRAL:
                        $('#frecuenciaCap').append(new Option(var_Frecuencia.TRIMESTRALDES, frecuencias[i], false, true));
                        $('#frecuenciaInt').append(new Option(var_Frecuencia.TRIMESTRALDES, frecuencias[i], false, true));
                        break;
                    case var_Frecuencia.TETRAMESTRAL:
                        $('#frecuenciaCap').append(new Option(var_Frecuencia.TETRAMESTRALDES, frecuencias[i], false, true));
                        $('#frecuenciaInt').append(new Option(var_Frecuencia.TETRAMESTRALDES, frecuencias[i], false, true));
                        break;
                    case var_Frecuencia.SEMESTRAL:
                        $('#frecuenciaCap').append(new Option(var_Frecuencia.SEMESTRALDES, frecuencias[i], false, true));
                        $('#frecuenciaInt').append(new Option(var_Frecuencia.SEMESTRALDES, frecuencias[i], false, true));
                        break;
                    case var_Frecuencia.ANUAL:
                        $('#frecuenciaCap').append(new Option(var_Frecuencia.ANUALDES, frecuencias[i], false, true));
                        $('#frecuenciaInt').append(new Option(var_Frecuencia.ANUALDES, frecuencias[i], false, true));
                        break;
                    case var_Frecuencia.PERIODO:
                        $('#frecuenciaCap').append(new Option(var_Frecuencia.PERIODODES, frecuencias[i], false, true));
                        $('#frecuenciaInt').append(new Option(var_Frecuencia.PERIODODES, frecuencias[i], false, true));
                        break;
                    case var_Frecuencia.PAGOUNICO:
                        $('#frecuenciaCap').append(new Option(var_Frecuencia.PAGOUNICODES, frecuencias[i], false, true));
                        $('#frecuenciaInt').append(new Option(var_Frecuencia.PAGOUNICODES, frecuencias[i], false, true));
                        break;
                    case var_Frecuencia.LIBRE:
                        $('#frecuenciaCap').append(new Option(var_Frecuencia.LIBREDES, frecuencias[i], false, true));
                        $('#frecuenciaInt').append(new Option(var_Frecuencia.LIBREDES, frecuencias[i], false, true));
                        break;
                }
                if (SolicitudCredito != null) {
                    $('#frecuenciaCap').val(SolicitudCredito.frecuenciaCap).selected = true;
                    $('#frecuenciaInt').val(SolicitudCredito.frecuenciaInt).selected = true;
                } else {
                    $('#frecuenciaCap').val(Constantes.CADENAVACIA).selected = true;
                    $('#frecuenciaInt').val(Constantes.CADENAVACIA).selected = true;
                }
            }
        }
    }
    // ------------------------------------ Consulta de la fecha de vencimiento en base al plazo ----------------------------------------- //
    function consultaFechaVencimiento(idControl) {
        var jqPlazo = eval("'#" + idControl + "'");
        var plazoID = $(jqPlazo).val();
        var bean = {
            'plazoID': plazoID,
            'fechaActual': $('#fechaInicioAmor').val(),
            'frecuenciaCap': $('#frecuenciaCap').val()
        };
        if (plazoID == Constantes.CADENAVACIA) {
            $('#fechaVencimiento').val(Constantes.CADENAVACIA);
        } else {
            plazosCredServicio.consulta(var_numConsultaPlazosCredito.fechaVenci, bean, {
                async: false,
                callback: function(plazos) {
                    if (plazos != null) {
                        $('#fechaVencimiento').val(plazos.fechaActual);
                        if ($('#frecuenciaCap').val() != var_Frecuencia.PAGOUNICO) {
                            $('#numAmortizacion').val(plazos.numCuotas);
                            NumCuotas = plazos.numCuotas; //se  utiliza para saber cuando se agrega o quita una cuota calculo de numero de dias
                            if ($('#tipoPagoCapital').val() == var_PagoCapital.CRECIENTES || $('#perIgual').val() == Constantes.SI) {
                                $('#numAmortInteres').val(plazos.numCuotas);
                                NumCuotasInt = plazos.numCuotas; // se utiliza para saber cuando se agrega o quita una cuota
                            } else {
                                consultaCuotasInteres('plazoID');
                            }
                        } else {
                            $('#numAmortizacion').val("1");
                            NumCuotas = 1; // se utiliza para saber cuando se agrega o quita una cuota
                        }
                        consultaDiasPlazo();
                    }
                }
            });
        }

        //GHERNANDEZ BUG #978
        if(manejaConvenio=='S' && $("#frecuenciaCap").val()=='Q' && numeroCliente==38){
            $("#diaMesCapital").val(1);
            var diaMesCapital = $('#diaMesCapital').val();
            $("#diaMesInteres").val(1);
            deshabilitaControl('diaMesCapital');
            deshabilitaControl('diaMesInteres');
        }else{
            habilitaControl('diaMesCapital');
            habilitaControl('diaMesInteres');
        }
        //FIN GHERNANDEZ 

    }
    // --------------- funcion que consulta la fecha de vencimiento en base a las cuotas (para pago unico y pago libres) -------------- //
    function consultaFechaVencimientoCuotas(idControl) {
        var jqPlazo = eval("'#" + idControl + "'");
        var plazoID = $(jqPlazo).val();
        var bean = {
            'frecuenciaCap': $('#frecuenciaCap').val(),
            'numCuotas': $('#numAmortizacion').val(),
            'periodicidadCap': $('#periodicidadCap').val(),
            'fechaActual': $('#fechaInicioAmor').val()
        };
        if (plazoID == Constantes.CADENAVACIA) {
            $('#fechaVencimiento').val(Constantes.CADENAVACIA);
        } else {
            plazosCredServicio.consulta(var_numConsultaPlazosCredito.fechaVenciCuota, bean, {
                async: false,
                callback: function(plazos) {
                    if (plazos != null) {
                        $('#fechaVencimiento').val(plazos.fechaActual);
                        consultaDiasPlazo(plazos.fechaActual);
                    }
                }
            });
        }
    }
    // -----------------------------------  Consulta las cuotas de interes ----------------------------------------- //
    function consultaCuotasInteres(idControl) {
        var jqPlazo = eval("'#" + idControl + "'");
        var plazoID = $(jqPlazo).val();
        var bean = {
            'plazoID': plazoID,
            'fechaActual': $('#fechaInicioAmor').val(),
            'frecuenciaCap': $('#frecuenciaInt').val()
        };
        if (plazoID == Constantes.ENTEROCERO) {
            $('#fechaVencimiento').val(Constantes.CADENAVACIA);
        } else {
            if ($('#frecuenciaInt').val() != Constantes.CADENAVACIA) {
                plazosCredServicio.consulta(var_numConsultaPlazosCredito.fechaVenci, bean, {
                    async: false,
                    callback: function(plazos) {
                        if (plazos != null) {
                            $('#numAmortInteres').val(plazos.numCuotas);
                            // se utiliza para saber cuando se agrega o quita una cuota
                            NumCuotasInt = parseInt(plazos.numCuotas);
                        }
                    }
                });
            }
        }
    }
    //------------------------------- Calcula el numero de dias del plazo seleccionado ----------------------------------------- //
    function consultaDiasPlazo() {
        if ($('#fechaVencimiento').val() != Constantes.CADENAVACIA) {
            var PlazoBeanCon = {
                'plazoID': $('#plazoID').val()
            };
            plazosCredServicio.consulta(var_numConsultaPlazosCredito.principal, PlazoBeanCon, {
                async: false,
                callback: function(plazos) {
                    if (plazos != null) {
                        $('#noDias').val(plazos.dias); // número de dias parametrizado en el plazo
                        if (parseInt($("#periodicidadCap").val()) > Constantes.ENTEROCERO) {
                            if (parseInt($("#periodicidadCap").val()) <= parseInt($('#noDias').val())) {
                                if ($('#frecuenciaCap').val() == var_Frecuencia.PAGOUNICO) {
                                    $('#periodicidadCap').val(plazos.dias);
                                    if ($("#tipoPagoCapital").val() == var_PagoCapital.CRECIENTES || $('#perIgual').val() == Constantes.SI) {
                                        $('#periodicidadInt').val(plazos.dias);
                                    }
                                }
                            } else {
                                mensajeSis("La Periodicidad de Capital es Mayor al Número de Días del Plazo.");
                                $("#frecuenciaCap").focus();
                            }
                        }
                    }
                }
            });
        }
    }
    // -------------------------------- Validacion de campos para el tipo de pago de capital ------------------------------------------- //
    function validaTipoPagoCapital() {
        switch ($('#tipoPagoCapital').val()) {
            case var_PagoCapital.CRECIENTES:
                deshabilitarCalendarioPagosInteres();
                igualarCalendarioInteresCapital();
                break;
            case var_PagoCapital.IGUALES:
                if ($('#perIgual').val() == Constantes.SI) {
                    // se llama funcion para igualar calendarios
                    igualarCalendarioInteresCapital();
                    deshabilitarCalendarioPagosInteres();
                } else {
                    habilitarCalendarioPagosInteres();
                }
                break;
            case var_PagoCapital.LIBRES:
                if ($('#perIgual').val() == Constantes.SI) {
                    // se llama funcion para igualar calendarios
                    igualarCalendarioInteresCapital();
                    deshabilitarCalendarioPagosInteres();
                } else {
                    habilitarCalendarioPagosInteres();
                }
                break;
                break;
        }
    }
    // ------- Iguala el calendario de interes al de capital cuando el tipo d pago de capital es crecientes o si el calendario iguala ----- //
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
            $('#diaPagoInteres').val(Constantes.FINDEMES);
        } else {
            if ($('#diaPagoCapital2').is(':checked')) {
                $('#diaPagoInteres1').attr('checked', false);
                $('#diaPagoInteres2').attr('checked', true);
                $('#diaPagoInteres').val(Constantes.FINDEMES);
            }
        }
    }
    // funcion para deshabilitar la seccion del calendario de  pagos que corresponde con interes
    function deshabilitarCalendarioPagosInteres() {
        deshabilitaControl('numAmortInteres');
        deshabilitaControl('frecuenciaInt');
        deshabilitaControl('periodicidadInt');
        if ($('#diaPagoProd').val() != Constantes.INDISTINTO || $('#perIgual').val() == Constantes.SI) {
            deshabilitaControl('diaPagoInteres1');
            deshabilitaControl('diaPagoInteres2');
        }
        if ($('#diaPagoProd').val() != Constantes.DIADEMES || $('#perIgual').val() == Constantes.SI) {
            deshabilitaControl('diaMesInteres');
        }
    }
    // funcion para habilitar la seccion del calendario de pagos que corresponde con interes
    function habilitarCalendarioPagosInteres() {
        habilitaControl('frecuenciaInt');
        habilitaControl('numAmortInteres');
        if ($('#diaPagoProd').val() == Constantes.INDISTINTO && $('#perIgual').val() != Constantes.SI && $("#tipoPagoCapital").val() != var_PagoCapital.CRECIENTES) {
            habilitaControl('diaPagoInteres1');
            habilitaControl('diaPagoInteres2');
        }
        if ($("#frecuenciaInt").val() == var_Frecuencia.PERIODO && $('#perIgual').val() != Constantes.SI && $("#tipoPagoCapital").val() != var_PagoCapital.CRECIENTES) {
            habilitaControl('periodicidadInt');
        }
        if (($('#diaPagoProd').val() == Constantes.DIADEMES || ($('#diaPagoProd').val() == Constantes.INDISTINTO && $('#diaPagoInteres2').is(':checked'))) && $('#perIgual').val() != Constantes.SI && $("#tipoPagoCapital").val() != var_PagoCapital.CRECIENTES) {
            habilitaControl('diaMesInteres');
        }
    }
    // ------------------------------------- Validaciones realizadas al moificar la frecuencia -------------------------------------- //
    function validarFrecuencia() {
        switch ($('#tipoPagoCapital').val()) {
            case var_PagoCapital.CRECIENTES:
                habilitaControl('numAmortizacion');
                deshabilitaControl('periodicidadCap');
                if ($('#frecuenciaCap').val() == var_Frecuencia.SEMENAL || $('#frecuenciaCap').val() == var_Frecuencia.CATORCENAL || $('#frecuenciaCap').val() == var_Frecuencia.QUINCENAL || $('#frecuenciaCap').val() == var_Frecuencia.ANUAL) {
                    if ($('#diaPagoCapital1').is(':checked')) {
                        $('#diaPagoCapital1').attr("checked", true);
                        $('#diaPagoCapital2').attr("checked", false);
                        $('#diaMesCapital').val(Constantes.CADENAVACIA);
                    } else {
                        $('#diaPagoCapital2').attr("checked", true);
                        $('#diaPagoCapital1').attr("checked", false);
                        $('#diaMesCapital').val(var_diaSucursal);
                    }
                } else {
                    if ($('#frecuenciaCap').val() == var_Frecuencia.PERIODO) {
                        if ($('#diaPagoCapital1').is(':checked')) {
                            $('#diaPagoCapital1').attr("checked", true);
                            $('#diaPagoCapital2').attr("checked", false);
                            $('#diaMesCapital').val(Constantes.CADENAVACIA);
                        } else {
                            $('#diaPagoCapital2').attr("checked", true);
                            $('#diaPagoCapital1').attr("checked", false);
                            $('#diaMesCapital').val(var_diaSucursal);
                        }
                        habilitaControl('periodicidadCap');
                    } else {
                        // si el tipo de pago es UNICO se  deshabilitan las cajas para indicar numero de cuotas
                        if ($('#frecuenciaCap').val() == var_Frecuencia.PAGOUNICO) {
                            deshabilitaControl('numAmortizacion');
                            $('#numAmortizacion').val("1");
                            mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
                            $('#frecuenciaCap').focus();
                            $('#periodicidadCap').val($('#noDias').val());
                            if ($('#diaPagoCapital1').is(':checked')) {
                                $('#diaPagoCapital1').attr("checked", true);
                                $('#diaPagoCapital2').attr("checked", false);
                                $('#diaMesCapital').val(Constantes.CADENAVACIA);
                            } else {
                                if ($('#diaPagoCapital2').is(':checked')) {
                                    $('#diaPagoCapital2').attr("checked", true);
                                    $('#diaPagoCapital1').attr("checked", false);
                                    $('#diaMesCapital').val(var_diaSucursal);
                                }
                            }
                        } else {
                            if ($('#diaPagoCapital1').is(':checked')) {
                                $('#diaPagoCapital1').attr("checked", true);
                                $('#diaPagoCapital2').attr("checked", false);
                                $('#diaMesCapital').val(Constantes.CADENAVACIA);
                            } else {
                                if ($('#diaPagoCapital2').is(':checked')) {
                                    $('#diaPagoCapital2').attr("checked", true);
                                    $('#diaPagoCapital1').attr("checked", false);
                                    $('#diaMesCapital').val(var_diaSucursal);
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
            case var_PagoCapital.IGUALES:
                habilitaControl('numAmortizacion');
                deshabilitaControl('periodicidadCap');
                if ($('#frecuenciaCap').val() == var_Frecuencia.SEMENAL || $('#frecuenciaCap').val() == var_Frecuencia.CATORCENAL || $('#frecuenciaCap').val() == var_Frecuencia.QUINCENAL || $('#frecuenciaCap').val() == var_Frecuencia.ANUAL) {
                    if ($('#diaPagoCapital1').is(':checked')) {
                        $('#diaPagoCapital1').attr("checked", true);
                        $('#diaPagoCapital2').attr("checked", false);
                        $('#diaMesCapital').val(Constantes.CADENAVACIA);
                    } else {
                        $('#diaPagoCapital2').attr("checked", true);
                        $('#diaPagoCapital1').attr("checked", false);
                        $('#diaMesCapital').val(var_diaSucursal);
                    }
                } else {
                    if ($('#frecuenciaCap').val() == var_Frecuencia.PERIODO) {
                        if ($('#diaPagoCapital1').is(':checked')) {
                            $('#diaPagoCapital1').attr("checked", true);
                            $('#diaPagoCapital2').attr("checked", false);
                            $('#diaMesCapital').val(Constantes.CADENAVACIA);
                        } else {
                            $('#diaPagoCapital2').attr("checked", true);
                            $('#diaPagoCapital1').attr("checked", false);
                            $('#diaMesCapital').val(var_diaSucursal);
                        }
                        habilitaControl('periodicidadCap');
                    } else {
                        if ($('#frecuenciaCap').val() == var_Frecuencia.PAGOUNICO) {
                            deshabilitaControl('numAmortizacion');
                            $('#numAmortizacion').val("1");
                            $('#periodicidadCap').val($('#noDias').val());
                            if ($('#diaPagoCapital1').is(':checked')) {
                                $('#diaPagoCapital1').attr("checked", true);
                                $('#diaPagoCapital2').attr("checked", false);
                                $('#diaMesCapital').val(Constantes.CADENAVACIA);
                            } else {
                                if ($('#diaPagoCapital2').is(':checked')) {
                                    $('#diaPagoCapital2').attr("checked", true);
                                    $('#diaPagoCapital1').attr("checked", false);
                                    $('#diaMesCapital').val(var_diaSucursal);
                                }
                            }
                        } else {
                            if ($('#diaPagoCapital1').is(':checked')) {
                                $('#diaPagoCapital1').attr("checked", true);
                                $('#diaPagoCapital2').attr("checked", false);
                                $('#diaMesCapital').val(Constantes.CADENAVACIA);
                            } else {
                                if ($('#diaPagoCapital2').is(':checked')) {
                                    $('#diaPagoCapital2').attr("checked", true);
                                    $('#diaPagoCapital1').attr("checked", false);
                                    $('#diaMesCapital').val(var_diaSucursal);
                                }
                            }
                        }
                    }
                }
                // Verifica si el producto iguala el calendario de interes al de capital
                if ($('#perIgual').val() != Constantes.SI) {
                    habilitarCalendarioPagosInteres();
                    if ($('#frecuenciaInt').val() == var_Frecuencia.SEMENAL || $('#frecuenciaInt').val() == var_Frecuencia.CATORCENAL || $('#frecuenciaInt').val() == var_Frecuencia.QUINCENAL || $('#frecuenciaInt').val() == var_Frecuencia.ANUAL) {
                        deshabilitaControl('periodicidadInt');
                        habilitaControl('numAmortInteres');
                    } else {
                        if ($('#frecuenciaInt').val() == var_Frecuencia.PERIODO) {
                            if ($('#diaPagoInteres1').is(':checked')) {
                                $('#diaPagoInteres1').attr("checked", true);
                                $('#diaPagoInteres2').attr("checked", false);
                                $('#diaMesInteres').val(var_diaSucursal);
                            } else {
                                $('#diaPagoInteres1').attr("checked", true);
                                $('#diaPagoInteres2').attr("checked", false);
                                $('#diaMesInteres').val(Constantes.CADENAVACIA);
                            }
                            habilitaControl('periodicidadInt');
                            habilitaControl('numAmortInteres');
                        } else {
                            if ($('#frecuenciaInt').val() == var_Frecuencia.PAGOUNICO) {
                                $('#numAmortInteres').val("1");
                                deshabilitaControl('numAmortInteres');
                                deshabilitaControl('periodicidadInt');
                                $('#periodicidadInt').val($('#noDias').val());
                                if ($('#diaPagoInteres1').is(':checked')) {
                                    $('#diaPagoInteres1').attr("checked", true);
                                    $('#diaPagoInteres2').attr("checked", false);
                                    $('#diaMesInteres').val(Constantes.CADENAVACIA);
                                } else {
                                    if ($('#diaPagoInteres2').is(':checked')) {
                                        $('#diaPagoInteres2').attr("checked", true);
                                        $('#diaPagoInteres1').attr("checked", false);
                                        $('#diaMesInteres').val(var_diaSucursal);
                                    }
                                }
                            } else {
                                habilitaControl('numAmortInteres');
                                if ($('#diaPagoInteres1').is(':checked')) {
                                    $('#diaPagoInteres1').attr("checked", true);
                                    $('#diaPagoInteres2').attr("checked", false);
                                    $('#diaPagoInteres').val(Constantes.FINDEMES);
                                    $('#diaMesInteres').val(Constantes.CADENAVACIA);
                                } else {
                                    if ($('#diaPagoInteres2').is(':checked')) {
                                        $('#diaPagoInteres1').attr("checked", false);
                                        $('#diaPagoInteres2').attr("checked", true);
                                        $('#diaPagoInteres').val(Constantes.DIADEMES);
                                        $('#diaMesInteres').val(var_diaSucursal);
                                    }
                                }
                            }
                        }
                    }
                    // solo si el producto de credito indica que el dia de pago es Indistinto
                    if ($('#diaPagoProd').val() == Constantes.INDISTINTO && $('#diaPagoInteres2').is(':checked')) {
                        habilitaControl('diaMesInteres');
                        habilitaControl('diaPagoInteres1');
                        habilitaControl('diaPagoInteres2');
                    }
                    // solo si el producto de credito indica que el dia de pago es Dia del mes
                    if ($('#diaPagoProd').val() == Constantes.DIADEMES) {
                        habilitaControl('diaMesInteres');
                    }
                } else { // SI IGUALA CALENDARIOS (Interes con Capital)
                    igualarCalendarioInteresCapital();
                    deshabilitarCalendarioPagosInteres();
                }
                break;
                // si el tipo de pago de capital es LIBRES
            case var_PagoCapital.LIBRES:
                habilitaControl('numAmortizacion');
                deshabilitaControl('periodicidadCap');
                if ($('#frecuenciaCap').val() == var_Frecuencia.SEMENAL || $('#frecuenciaCap').val() == var_Frecuencia.CATORCENAL || $('#frecuenciaCap').val() == var_Frecuencia.QUINCENAL || $('#frecuenciaCap').val() == var_Frecuencia.ANUAL) {
                    if ($('#diaPagoCapital1').is(':checked')) {
                        $('#diaPagoCapital1').attr("checked", true);
                        $('#diaPagoCapital2').attr("checked", false);
                        $('#diaMesCapital').val('');
                    } else {
                        $('#diaPagoInteres2').attr('checked', true);
                        $('#diaPagoCapital2').attr("checked", true);
                        $('#diaPagoCapital1').attr("checked", false);
                        $('#diaMesCapital').val(var_diaSucursal);
                    }
                } else {
                    if ($('#frecuenciaCap').val() == var_Frecuencia.PERIODO) {
                        if ($('#diaPagoCapital1').is(':checked')) {
                            $('#diaPagoCapital1').attr("checked", true);
                            $('#diaPagoCapital2').attr("checked", false);
                            $('#diaMesCapital').val(Constantes.CADENAVACIA);
                        } else {
                            $('#diaPagoCapital2').attr("checked", true);
                            $('#diaPagoCapital1').attr("checked", false);
                            $('#diaMesCapital').val(var_diaSucursal);
                        }
                        habilitaControl('periodicidadCap');
                    } else {
                        if ($('#frecuenciaCap').val() == var_Frecuencia.PAGOUNICO) {
                            $('#numAmortizacion').val("1");
                            deshabilitaControl('numAmortizacion');
                            deshabilitaControl('periodicidadInt');
                            $('#periodicidadCap').val($('#noDias').val());
                            if ($('#diaPagoCapital1').is(':checked')) {
                                $('#diaPagoCapital1').attr("checked", true);
                                $('#diaPagoCapital2').attr("checked", false);
                                $('#diaMesCapital').val(Constantes.CADENAVACIA);
                            } else {
                                if ($('#diaPagoCapital2').is(':checked')) {
                                    $('#diaPagoCapital2').attr("checked", true);
                                    $('#diaPagoCapital1').attr("checked", false);
                                    $('#diaMesCapital').val(var_diaSucursal);
                                }
                            }
                        } else {
                            if ($('#diaPagoCapital1').is(':checked')) {
                                $('#diaPagoCapital1').attr("checked", true);
                                $('#diaPagoCapital2').attr("checked", false);
                                $('#diaMesCapital').val(Constantes.CADENAVACIA);
                            } else {
                                if ($('#diaPagoCapital2').is(':checked')) {
                                    $('#diaPagoCapital2').attr("checked", true);
                                    $('#diaPagoCapital1').attr("checked", false);
                                    $('#diaMesCapital').val(var_diaSucursal);
                                }
                            }
                        }
                    }
                }
                // Verifica el producto iguala el calendario de interes al de capital
                if ($('#perIgual').val() != Constantes.SI) {
                    habilitarCalendarioPagosInteres();
                    if ($('#frecuenciaInt').val() == var_Frecuencia.SEMENAL || $('#frecuenciaInt').val() == var_Frecuencia.CATORCENAL || $('#frecuenciaInt').val() == var_Frecuencia.QUINCENAL || $('#frecuenciaInt').val() == var_Frecuencia.ANUAL) {
                        deshabilitaControl('periodicidadInt');
                        habilitaControl('numAmortInteres');
                    } else {
                        if ($('#frecuenciaInt').val() == var_Frecuencia.PERIODO) {
                            if ($('#diaPagoInteres1').is(':checked')) {
                                $('#diaPagoInteres1').attr("checked", true);
                                $('#diaPagoInteres2').attr("checked", false);
                                $('#diaMesInteres').val(var_diaSucursal);
                            } else {
                                $('#diaPagoInteres1').attr("checked", true);
                                $('#diaPagoInteres2').attr("checked", false);
                                $('#diaMesInteres').val('');
                            }
                            habilitaControl('periodicidadInt');
                            habilitaControl('numAmortInteres');
                        } else {
                            if ($('#frecuenciaInt').val() == var_Frecuencia.PAGOUNICO) {
                                $('#numAmortInteres').val("1");
                                deshabilitaControl('numAmortInteres');
                                $('#periodicidadInt').val($('#noDias').val());
                                if ($('#diaPagoInteres1').is(':checked')) {
                                    $('#diaPagoInteres1').attr("checked", true);
                                    $('#diaPagoInteres2').attr("checked", false);
                                    $('#diaMesInteres').val("");
                                } else {
                                    if ($('#diaPagoInteres2').is(':checked')) {
                                        $('#diaPagoInteres2').attr("checked", true);
                                        $('#diaPagoInteres1').attr("checked", false);
                                        $('#diaMesInteres').val(var_diaSucursal);
                                    }
                                }
                            } else {
                                habilitaControl('numAmortInteres');
                                if ($('#diaPagoInteres1').is(':checked')) {
                                    $('#diaPagoInteres1').attr("checked", true);
                                    $('#diaPagoInteres2').attr("checked", false);
                                    $('#diaPagoInteres').val(Constantes.DINDEMES);
                                    $('#diaMesInteres').val(Constantes.CADENAVACIA);
                                } else {
                                    if ($('#diaPagoInteres2').is(':checked')) {
                                        $('#diaPagoInteres1').attr("checked", false);
                                        $('#diaPagoInteres2').attr("checked", true);
                                        $('#diaPagoInteres').val(Constantes.DIADEMES);
                                        $('#diaMesInteres').val(var_diaSucursal);
                                    }
                                }
                            }
                        }
                    }
                    // solo si el producto de credito indica que el dia de pago es Indistinto
                    if ($('#diaPagoProd').val() == Constantes.INDISTINTO && $('#diaPagoInteres2').is(':checked')) {
                        habilitaControl('diaMesInteres');
                        habilitaControl('diaPagoInteres1');
                        habilitaControl('diaPagoInteres2');
                    }
                    // solo si el producto de credito indica que el dia de pago es Dia del mes
                    if ($('#diaPagoProd').val() == Constantes.DINDEMES) {
                        habilitaControl('diaMesInteres');
                    }
                } else { // SI IGUALA CALENDARIOS (Interes con Capital)
                    igualarCalendarioInteresCapital();
                    deshabilitarCalendarioPagosInteres();
                }
                break;
        }
        validarEsquemaCobroSeguro();
    } // FIN validarFrecuencia()
    // --------- ----------- Asigna en dias la periodicidad, dependiendo de la frecuencia seleccionada --------------------- //
    function validaPeriodicidad() {
        switch ($('#frecuenciaCap').val()) {
            case var_Frecuencia.SEMANAL:
                $('#periodicidadCap').val(var_Frecuencia.SEMANALDIAS);
                break;
            case var_Frecuencia.DECENAL:
                $('#periodicidadCap').val(var_Frecuencia.DECENALDIAS);
                break;
            case var_Frecuencia.CATORCENAL:
                $('#periodicidadCap').val(var_Frecuencia.CATORCENALDIAS);
                break;
            case var_Frecuencia.QUINCENAL:
                $('#periodicidadCap').val(var_Frecuencia.QUINCENALDIAS);
                break;
            case var_Frecuencia.MENSUAL:
                $('#periodicidadCap').val(var_Frecuencia.MENSUALDIAS);
                break;
            case var_Frecuencia.BIMESTRAL:
                $('#periodicidadCap').val(var_Frecuencia.BIMESTRALDIAS);
                break;
            case var_Frecuencia.TRIMESTRAL:
                $('#periodicidadCap').val(var_Frecuencia.TRIMESTRALDIAS);
                break;
            case var_Frecuencia.TETRAMESTRAL:
                $('#periodicidadCap').val(var_Frecuencia.TETRAMESTRALDIAS);
                break;
            case var_Frecuencia.SEMESTRAL:
                $('#periodicidadCap').val(var_Frecuencia.SEMESTRALDIAS);
                break;
            case var_Frecuencia.ANUAL:
                $('#periodicidadCap').val(var_Frecuencia.ANUALDIAS);
                break;
            case var_Frecuencia.LIBRE:
                $('#periodicidadCap').val(Constantes.CADENAVACIA);
                break;
            case var_Frecuencia.PERIODO:
                $('#periodicidadCap').val($("#noDias").val());
                break;
            case var_Frecuencia.PAGOUNICO:
                $('#periodicidadCap').val($("#noDias").val());
                break;
            default:
                $('#periodicidadCap').val(Constantes.CADENAVACIA);
                break;
        }
        switch ($('#frecuenciaInt').val()) {
            case var_Frecuencia.SEMANAL:
                $('#periodicidadInt').val(var_Frecuencia.SEMANALDIAS);
                break;
            case var_Frecuencia.DECENAL:
                $('#periodicidadInt').val(var_Frecuencia.DECENALDIAS);
                break;
            case var_Frecuencia.CATORCENAL:
                $('#periodicidadInt').val(var_Frecuencia.CATORCENALDIAS);
                break;
            case var_Frecuencia.QUINCENAL:
                $('#periodicidadInt').val(var_Frecuencia.QUINCENALDIAS);
                break;
            case var_Frecuencia.MENSUAL:
                $('#periodicidadInt').val(var_Frecuencia.MENSUALDIAS);
                break;
            case var_Frecuencia.BIMESTRAL:
                $('#periodicidadInt').val(var_Frecuencia.BIMESTRALDIAS);
                break;
            case var_Frecuencia.TRIMESTRAL:
                $('#periodicidadInt').val(var_Frecuencia.TRIMESTRALDIAS);
                break;
            case var_Frecuencia.TETRAMESTRAL:
                $('#periodicidadInt').val(var_Frecuencia.TETRAMESTRALDIAS);
                break;
            case var_Frecuencia.SEMESTRAL:
                $('#periodicidadInt').val(var_Frecuencia.SEMESTRALDIAS);
                break;
            case var_Frecuencia.ANUAL:
                $('#periodicidadInt').val(var_Frecuencia.ANUALDIAS);
                break;
            case var_Frecuencia.LIBRE:
                $('#periodicidadInt').val(Constantes.CADENAVACIA);
                break;
            case var_Frecuencia.PERIODO:
                $('#periodicidadInt').val($("#noDias").val());
                break;
            case var_Frecuencia.PAGOUNICO:
                $('#periodicidadInt').val($("#noDias").val());
                break;
            default:
                $('#periodicidadInt').val(Constantes.CADENAVACIA);
                break;
        }
    } // FIN validaPeriodicidad()
    // ----------- Consulta el simulador de amortizaciones de la solicitud cuando el tipo de pago de capital es LIBRES ------------ //
    function consultaSimuladorLibres() {
        estatusSimulacion = true;
        var params = {};
        if ($('#calendIrregularCheck').is(':checked')) {
            params['tipoLista'] = var_Simulador.libres;
            params['numTransacSim'] = $('#numTransacSim').asNumber();
            params['cobraSeguroCuota'] = $('#cobraSeguroCuota option:selected').val();
            params['cobraIVASeguroCuota'] = $('#cobraIVASeguroCuota option:selected').val();
            params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
            bloquearPantallaAmortizacion();
            var numeroError = 0;
            var mensajeTransaccion = "";
            $.post("listaSimuladorConsulta.htm", params, function(data) {
                if (data.length > Constantes.ENTEROCERO || data != null) {
                    $('#contenedorSimuladorLibre').html(data);
                    if ($("#numeroErrorList").length) {
                        numeroError = $('#numeroErrorList').asNumber();
                        mensajeTransaccion = $('#mensajeErrorList').val();
                    }
                    if (numeroError == 0) {
                        $('#contenedorSimuladorLibre').show();
                        $('#contenedorSimulador').html(Constantes.CADENAVACIA);
                        $('#contenedorSimulador').hide();
                        $('#totalCap').val(totalizaCapital());
                        $('#totalInt').val(totalizaInteres());
                        $('#totalIva').val(totalizaIva());
                        agregarFormatoMoneda('totalCap');
                        agregarFormatoMoneda('totalInt');
                        agregarFormatoMoneda('totalIva');
                        $('tr[name=renglon]').each(function() {
                            var numero = this.id.substr(7, this.id.length);
                            var jqFecha = eval("'#fechaVencim" + numero + "'");
                            var numFilas = consultaFilas();
                            maxRegistro = 0;
                            for (var i = 0, len = numero.length; i < len; i++) {
                                if (maxRegistro < numero[i]) {
                                    maxRegistro = numero[i];
                                }
                            }
                            // actualiza la nueva fecha de vencimiento que devuelve el cotizador
                            if (numFilas == maxRegistro) {
                                var jqFechaFin = "";
                                jqFechaFin = $(jqFecha).val();
                                $('#fechaVencimiento').val(jqFechaFin);
                            }
                        });
                    }
                } else {
                    $('#contenedorSimuladorLibre').html(Constantes.CADENAVACIA);
                    $('#contenedorSimuladorLibre').hide();
                    $('#contenedorSimulador').html(Constantes.CADENAVACIA);
                    $('#contenedorSimulador').hide();
                }
                $('#contenedorForma').unblock();
                /****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
                if (numeroError != 0) {
                    $('#contenedorForma').unblock({
                        fadeOut: 0,
                        timeout: 0
                    });
                    mensajeSisError(numeroError, mensajeTransaccion);
                }
                /**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
            });
        } else {
            mensajeSis("Indique Calendario Irregular.");
            $("#calendIrregularCheck").focus();
        }
    } // fin funcion consultaSimuladorLibres()
    // ---------------------------------------- Realiza la Simulacion del calendario de pagos ------------------------------------------- //
    function simulador() {
        estatusSimulacion = true;
        $('#fechaInicio').val(parametroBean.fechaAplicacion);
        if ((Date.parse($('#fechaInicioAmor').val())) < (Date.parse(parametroBean.fechaAplicacion))) {
            $('#fechaInicioAmor').val(parametroBean.fechaAplicacion);
        }
        var params = {};
        var tipoLista = Constantes.ENTEROCERO;
        if ($('#calendIrregularCheck').is(':checked')) {
            mostrarGridLibresEncabezado();
        } else {
            ejecutarLlamada = validaDatosSimulador();
            if (ejecutarLlamada == true) {
                if ($('#calcInteresID').val() == var_TipoTasa.TASAFIJA) {
                    if ($('#tipoCalInteres').val() == Constantes.MONTOORIGINAL) {
                        tipoLista = var_Simulador.interesMontoOriginal;
                        $('#tipoPagoCapital').val(var_PagoCapital.IGUALES).selected = true;
                    } else {
                        switch ($('#tipoPagoCapital').val()) {
                            case var_PagoCapital.CRECIENTES:
                                tipoLista = var_Simulador.TasaFija_Crecientes;
                                break;
                            case var_PagoCapital.IGUALES:
                                tipoLista = var_Simulador.TasaFija_Iguales;
                                break;
                            case var_PagoCapital.LIBRES:
                                tipoLista = var_Simulador.TasaFija_Libres;
                                break;
                        }
                    }
                } else {
                    // si el tipo de calculo de interes es MontoOriginal (saldos globales)se valida tipo de Lista
                    if ($('#tipoCalInteres').val() == Constantes.MONTOORIGINAL) {
                        tipoLista = var_Simulador.interesMontoOriginal;
                    } else {
                        switch ($('#tipoPagoCapital').val()) {
                            case var_PagoCapital.CRECIENTES:
                                mensajeSis("No se Permiten Pagos de Capital Crecientes.");
                                break;
                            case var_PagoCapital.IGUALES:
                                tipoLista = var_Simulador.NOTasaFija_Iguales;
                                break;
                            case var_PagoCapital.LIBRES:
                                tipoLista = var_Simulador.NOTasaFija_Libres;
                                break;
                        }
                    }
                }
                if ($('#tipoPagoCapital').val() == 'L' & ($('#frecuenciaCap').val() == "D" || $('#frecuenciaInt').val() == "D")) {
                    mensajeSis("No se permiten Frecuencias Decenales con pagos de Capital Libres");
                    $('#frecuenciaInt').val('S');
                    $('#frecuenciaCap').val('S');
                    return false;
                }
                params['tipoLista'] = tipoLista;
                if ($.trim($('#frecuenciaCap').val()) != Constantes.CADENAVACIA) {
                    if (tipoLista == 1) {
                        if ($('#frecuenciaCap').val() == var_Frecuencia.MENSUAL || $('#frecuenciaCap').val() == var_Frecuencia.BIMESTRAL || $('#frecuenciaCap').val() == var_Frecuencia.TRIMESTRAL || $('#frecuenciaCap').val() == var_Frecuencia.TETRAMESTRAL || $('#frecuenciaCap').val() == var_Frecuencia.SEMESTRAL) {
                            // Si el dia de pago no esta  definido
                            if (($('#diaPagoCapital2').is(':checked')) != true && ($('#diaPagoCapital1').is(':checked')) != true) {
                                mensajeSis("Debe Seleccionar un día de Pago.");
                                datosCompletos = false;
                            } else {
                                // si el dia de pago seleccionado es dia del mes
                                if (($('#diaPagoCapital2').is(':checked')) == true) {
                                    if ($.trim($('#diaMesCapital').val()) == Constantes.CADENAVACIA || $('#diaMesCapital').val() == null || $('#diaMesCapital').val() == Constantes.ENTEROCERO) {
                                        mensajeSis("Especifique día del Mes.");
                                        $('#diaMesCapital').focus();
                                        datosCompletos = false;
                                    } else {
                                        // valida que el numero  de amortizaciones no  este vacio
                                        if ($('#numAmortizacion').asNumber() == Constantes.ENTEROCERO) {
                                            mensajeSis("Número de Cuotas Vacío.");
                                            $('#numAmortizacion').focus();
                                            datosCompletos = false;
                                        } else {
                                            datosCompletos = true;
                                        }
                                    }
                                } else {
                                    // valida que el numero de amortizaciones no este vacio
                                    if ($('#numAmortizacion').asNumber() == Constantes.ENTEROCERO) {
                                        mensajeSis("Número de Cuotas Vacío.");
                                        $('#numAmortizacion').focus();
                                        datosCompletos = false;
                                    } else {
                                        datosCompletos = true;
                                    }
                                }
                            }
                        } else {
                            if ($('#numAmortizacion').asNumber() == Constantes.ENTEROCERO) {
                                mensajeSis("Número de Cuotas Vacío.");
                                $('#numAmortizacion').focus();
                                datosCompletos = false;
                            } else {
                                datosCompletos = true;
                            }
                        }
                    } else {
                        if (tipoLista == var_Simulador.TasaFija_Iguales || tipoLista == var_Simulador.TasaFija_Libres || tipoLista == var_Simulador.NOTasaFija_Iguales || tipoLista == var_Simulador.NOTasaFija_Libres || tipoLista == var_Simulador.interesMontoOriginal) {
                            if ($.trim($('#frecuenciaCap').val()) != Constantes.CADENAVACIA) {
                                if ($.trim($('#frecuenciaInt').val()) != Constantes.CADENAVACIA) {
                                    if ($('#frecuenciaCap').val() == var_Frecuencia.MENSUAL || $('#frecuenciaCap').val() == var_Frecuencia.BIMESTRAL || $('#frecuenciaCap').val() == var_Frecuencia.TRIMESTRAL || $('#frecuenciaCap').val() == var_Frecuencia.TETRAMESTRAL || $('#frecuenciaCap').val() == var_Frecuencia.SEMESTRAL || $('#frecuenciaInt').val() == var_Frecuencia.MENSUAL || $('#frecuenciaInt').val() == var_Frecuencia.BIMESTRAL || $('#frecuenciaInt').val() == var_Frecuencia.TRIMESTRAL || $('#frecuenciaInt').val() == var_Frecuencia.TETRAMESTRAL || $('#frecuenciaInt').val() == var_Frecuencia.SEMESTRAL) {
                                        // Valida que este seleccionado el dia de pago para capital e interes
                                        if (($('#diaPagoCapital1').is(':checked') != true && $('#diaPagoCapital2').is(':checked') != true) || ($('#diaPagoInteres1').is(':checked') != true && $('#diaPagoInteres2').is(':checked') != true)) {
                                            mensajeSis('Debe Seleccionar un día de Pago.');
                                            datosCompletos = false;
                                        } else {
                                            // si el dia de pago seleccionado es dia del mes
                                            if ($('#diaPagoCapital2').is(':checked') == true) {
                                                if ($.trim($('#diaMesCapital').val()) == Constantes.CADENAVACIA || $('#diaMesCapital').val() == null || $('#diaMesCapital').val() == Constantes.ENTEROCERO) {
                                                    mensajeSis("Especifique día del Mes para Capital.");
                                                    datosCompletos = false;
                                                } else {
                                                    if (($.trim($('#diaMesInteres').val()) == Constantes.CADENAVACIA || $('#diaMesInteres').val() == null || $('#diaMesInteres').val() == Constantes.ENTEROCERO) && $('#diaPagoInteres2').is(':checked') == true) {
                                                        mensajeSis("Especifique día del Mes para Interés.");
                                                        datosCompletos = false;
                                                    } else {
                                                        // valida que el numero de amortizaciones no este vacio
                                                        if ($('#numAmortizacion').asNumber() == Constantes.ENTEROCERO) {
                                                            mensajeSis("Número de Cuotas Vacío.");
                                                            datosCompletos = false;
                                                        } else {
                                                            datosCompletos = true;
                                                        }
                                                    }
                                                }
                                            } else {
                                                // valida que el numero de amortizaciones no este vacio
                                                if ($('#numAmortizacion').asNumber() == Constantes.ENTEROCERO) {
                                                    mensajeSis("Especificar Número de Cuotas de Capital.");
                                                    datosCompletos = false;
                                                } else {
                                                    // valida que el  nÃºmero de amortizaciones no este vacio
                                                    if ($('#numAmortInteres').asNumber() == Constantes.ENTEROCERO) {
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
                                        if ($('#numAmortizacion').asNumber() == Constantes.ENTEROCERO) {
                                            mensajeSis("Número de Cuotas Vacío.");
                                            datosCompletos = false;
                                        } else {
                                            // valida que el numero de amortizaciones no este vacio
                                            if ($('#numAmortInteres').asNumber() == Constantes.ENTEROCERO) {
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
                            var_DiaPagoCapital = Constantes.FINDEMES;
                        } else {
                            var_DiaPagoCapital = Constantes.DIADEMES;
                        }
                        if ($('#diaPagoInteres1').is(':checked')) {
                            var_DiaPagoInteres = Constantes.FINDEMES;
                        } else {
                            var_DiaPagoInteres = Constantes.DIADEMES;
                        }
                        if ($('#frecuenciaCap').val() == 'Q') {
                            var_DiaPagoCapital = Constantes.FINDEMES;
                            $('#diaPagoCapital').val(Constantes.FINDEMES);
                        }
                        if ($('#frecuenciaInt').val() == 'Q') {
                            var_DiaPagoInteres = Constantes.FINDEMES;
                            $('#diaPagoInteres').val(Constantes.FINDEMES);
                        }
                        params['montoCredito'] = $('#montoSolici').asNumber();
                        params['tasaFija'] = $('#tasaFija').val();
                        params['frecuenciaCap'] = $('#frecuenciaCap').val();
                        params['frecuenciaInt'] = $('#frecuenciaInt').val();
                        params['periodicidadCap'] = $('#periodicidadCap').val();
                        params['periodicidadInt'] = $('#periodicidadInt').val();
                        params['producCreditoID'] = $('#productoCreditoID').val();
                        params['clienteID'] = $('#clienteID').val();
                        params['montoComision'] = Constantes.DECIMALCERO;
                        params['diaPagoCapital'] = var_DiaPagoCapital;
                        params['diaPagoInteres'] = var_DiaPagoInteres;
                        params['diaMesCapital'] = $('#diaMesCapital').val();
                        params['diaMesInteres'] = $('#diaMesInteres').val();
                        params['fechaInicio'] = $('#fechaInicioAmor').val();
                        params['numAmortizacion'] = $('#numAmortizacion').asNumber();
                        params['numAmortInteres'] = $('#numAmortInteres').asNumber();
                        params['fechaInhabil'] = $('#fechInhabil').val();
                        params['ajusFecUlVenAmo'] = $('#ajFecUlAmoVen').val();
                        params['ajusFecExiVen'] = $('#ajusFecExiVen').val();
                        params['numTransacSim'] = Constantes.ENTEROCERO;
                        params['empresaID'] = parametroBean.empresaID;
                        params['usuario'] = parametroBean.numeroUsuario;
                        params['fecha'] = parametroBean.fechaSucursal;
                        params['direccionIP'] = parametroBean.IPsesion;
                        params['sucursal'] = parametroBean.sucursal;
                        params['cobraSeguroCuota'] = $('#cobraSeguroCuota option:selected').val();
                        params['cobraIVASeguroCuota'] = $('#cobraIVASeguroCuota option:selected').val();
                        params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
                        params['tipoCredito'] = $('#tipoCredito').val();
                        params['plazoID'] = $('#plazoID').val();
                        params['tipoOpera'] = 1;
                        params['cobraAccesorios'] = cobraAccesorios;
                        params['convenioNominaID']  = $('#convenioNominaID').asNumber();

                        bloquearPantallaAmortizacion();
                        var numeroError = 0;
                        var mensajeTransaccion = "";
                        if ($('#tipoPagoCapital').val() != var_PagoCapital.LIBRES) {
                            $.post("simPagCredito.htm", params, function(data) {
                                if ($("#numeroErrorList").length) {
                                    numeroError = $('#numeroErrorList').asNumber();
                                    mensajeTransaccion = $('#mensajeErrorList').val();
                                }
                                if (numeroError == 0) {
                                    if (data.length > Constantes.ENTEROCERO || data != null) {
                                        $('#contenedorSimulador').html(data);
                                        if ($("#numeroErrorList").length) {
                                            numeroError = $('#numeroErrorList').asNumber();
                                            mensajeTransaccion = $('#mensajeErrorList').val();
                                        }
                                        if (numeroError == 0) {
                                            $('#contenedorSimulador').show();
                                            $('#contenedorSimuladorLibre').html(Constantes.CADENAVACIA);
                                            $('#contenedorSimuladorLibre').hide();
                                            $('#numTransacSim').val($('#transaccion').val());
                                            // actualiza la nueva fecha de vencimiento que devuelve el simulador
                                            var jqFechaVen = eval("'#fech'");
                                            $('#fechaVencimiento').val($(jqFechaVen).val());
                                            // asigna el valor de car decuelto por el simulador
                                            $('#CAT').val($('#valorCat').val());
                                            $('#CAT').formatCurrency({
                                                positiveFormat: '%n',
                                                roundToDecimalPlace: 1
                                            });
                                            agregarFormatoMoneda('CAT');
                                            // asigna el valor de monto de la cuota deulto por el simulador
                                            if ($('#tipoPagoCapital').val() == var_PagoCapital.CRECIENTES) {
                                                $('#montoCuota').val($('#valorMontoCuota').val());
                                                agregarFormatoMoneda('montoCuota');
                                            } else {
                                                if ($('#frecuenciaCap').val() == var_Frecuencia.PAGOUNICO && $('#tipoPagoCapital').val() == var_PagoCapital.IGUALES) {
                                                    $('#montoCuota').val($('#valorMontoCuota').val());
                                                    agregarFormatoMoneda('montoCuota');
                                                } else {
                                                    $('#montoCuota').val(Constantes.DECIMALCERO);
                                                }
                                            }
                                            // actualiza el numero de cuotas generadas por el simulador
                                            $('#numAmortInteres').val($('#valorCuotasInt').val());
                                            $('#numAmortizacion').val($('#cuotas').val());
                                            // se utiliza para saber si agregar 1 cuotas mas o restar 1
                                            NumCuotas = $('#cuotas').val();
                                            // Si el tipo de pago de capital es iguales o saldos gloables devuelve el numero de cuotas de interes
                                            if ($('#tipoPagoCapital').val() == var_PagoCapital.IGUALES || tipoLista == var_Simulador.interesMontoOriginal) {
                                                $('#numAmortInteres').val($('#valorCuotasInt').val());
                                                // se utiliza para saber si agregar 1 cuotas mas o restar 1
                                                NumCuotasInt = $('#valorCuotasInt').val();
                                            }
                                            if ($('#siguiente').is(':visible') && $('#anterior').is(':visible') == false) {
                                                $('#filaTotales').hide();
                                            }
                                            if ($('#siguiente').is(':visible') == false && $('#anterior').is(':visible') == false) {
                                                $('#filaTotales').show();
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
                                        $('#contenedorSimulador').html(Constantes.CADENAVACIA);
                                        $('#contenedorSimulador').hide();
                                        $('#contenedorSimuladorLibre').html(Constantes.CADENAVACIA);
                                        $('#contenedorSimuladorLibre').hide();
                                    }
                                    $('#contenedorForma').unblock();
                                }
                                /****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
                                if (numeroError != 0) {
                                    $('#contenedorForma').unblock({
                                        fadeOut: 0,
                                        timeout: 0
                                    });
                                    mensajeSisError(numeroError, mensajeTransaccion);
                                }
                                /**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
                            });
                        } else {
                            var numeroError = 0;
                            var mensajeTransaccion = "";
                            $.post("simPagLibresCapCredito.htm", params, function(data) {
                                if (data.length > Constantes.ENTEROCERO || data != null) {
                                    $('#contenedorSimuladorLibre').html(data);
                                    if ($("#numeroErrorList").length) {
                                        numeroError = $('#numeroErrorList').asNumber();
                                        mensajeTransaccion = $('#mensajeErrorList').val();
                                    }
                                    if (numeroError == 0) {
                                        $('#contenedorSimuladorLibre').show();
                                        $('#contenedorSimulador').html(Constantes.CADENAVACIA);
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
                                        if ($('#tipoCalInteres').val() == '2' && cobraAccesorios == 'S') {
                                            desgloseOtrasComisiones($('#numTransacSim').val());
                                        }
                                    }
                                } else {
                                    $('#contenedorSimuladorLibre').html(Constantes.CADENAVACIA);
                                    $('#contenedorSimuladorLibre').hide();
                                    $('#contenedorSimulador').html(Constantes.CADENAVACIA);
                                    $('#contenedorSimulador').hide();
                                }
                                $('#contenedorForma').unblock();
                                /****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
                                if (numeroError != 0) {
                                    $('#contenedorForma').unblock({
                                        fadeOut: 0,
                                        timeout: 0
                                    });
                                    mensajeSisError(numeroError, mensajeTransaccion);
                                }
                                /**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
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
    } // fin funcion simulador()
    // ---------------- Valida que los datos que se requieren para generar el simulador de amortizaciones esten indicados. ---------------- //
    function validaDatosSimulador() {
        if ($.trim($('#productoCreditoID').val()) == Constantes.CADENAVACIA) {
            mensajeSis("Producto De Crédito Vací­o.");
            $('#productoCreditoID').focus();
            datosCompletos = false;
        } else {
            if ($.trim($('#clienteID').asNumber()) <= Constantes.ENTEROCERO) {
                mensajeSis("Especificar " + var_clienteSocio + ".");
                $('#creditoID').focus(); // se envia foco a credito xq el campo de cliente siempre esta deshabilitado
                datosCompletos = false;
            } else {
                if ($('#fechaInicioAmor').val() == Constantes.CADENAVACIA) {
                    mensajeSis("Fecha de Inicio Amotización Vacía.");
                    $('#fechaInicioAmor').focus();
                    datosCompletos = false;
                } else {
                    if ($('#fechaVencimiento').val() == Constantes.CADENAVACIA) {
                        mensajeSis("Fecha de Vencimiento Vacía.");
                        $('#fechaInicioAmor').focus();
                        datosCompletos = false;
                    } else {
                        if ($('#tipoPagoCapital').val() == Constantes.CADENAVACIA) {
                            mensajeSis("El Tipo de Pago de Capital Está Vací­o.");
                            $('#tipoPagoCapital').focus();
                            datosCompletos = false;
                        } else {
                            if ($('#frecuenciaCap').val() == var_Frecuencia.PAGOUNICO && $('#tipoPagoCapital').val() != var_PagoCapital.IGUALES) {
                                mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
                                $('#tipoPagoCapital').focus();
                                datosCompletos = false;
                            } else {
                                // se valida que si el tipo de pago de capital es libre, no se pueda escoger como frecuencia la opcion de libre
                                if ($('#frecuenciaInt').val() == var_Frecuencia.LIBRE && $('#calendIrregular').val() == Constantes.NO) {
                                    mensajeSis("La Frecuencia de Interés Libre sólo Aplica para Calendario Irregular.");
                                    $('#frecuenciaInt').focus();
                                    $('#frecuenciaInt').val(Constantes.CADENAVACIA);
                                    datosCompletos = false;
                                } else {
                                    if ($('#frecuenciaCap').val() == var_Frecuencia.LIBRE && $('#calendIrregular').val() == Constantes.NO) {
                                        mensajeSis("La Frecuencia de Capital Libre sólo Aplica para Calendario Irregular.");
                                        $('#frecuenciaCap').focus();
                                        $('#frecuenciaCap').val(Constantes.CADENAVACIA);
                                        datosCompletos = false;
                                    } else {
                                        if ($('#calcInteresID').val() != Constantes.CADENAVACIA) {
                                            if ($('#calcInteresID').val() == var_TipoTasa.TASAFIJA) {
                                                if ($('#tasaFija').val() == Constantes.CADENAVACIA || $('#tasaFija').val() == Constantes.ENTEROCERO) {
                                                    mensajeSis("Tasa de Interés Vací­a.");
                                                    $('#tasaFija').focus();
                                                    datosCompletos = false;
                                                } else {
                                                    if ($('#montoSolici').asNumber() <= Constantes.ENTEROCERO) {
                                                        mensajeSis("El Monto Está Vacío.");
                                                        $('#creditoID').focus();
                                                        datosCompletos = false;
                                                    } else {
                                                        datosCompletos = true;
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
        return datosCompletos;
    }
    // ------------------------- Muestra el encabezado del simulador de pagos para tipo de capital LIBRES ------------------------------ //
    function mostrarGridLibresEncabezado() {
        var data;
        data = '<input type="hidden" value="0" name="numeroDetalle" id="numeroDetalle" />' + '<fieldset class="ui-widget ui-widget-content ui-corner-all">' + '<legend>Simulador de Amortizaciones</legend>' + '<table id="miTabla" border="0" cellpadding="0" cellspacing="0" width="100%">' + '<tr>' + '<td class="label" align="center"><label for="lblNumero">N&uacute;mero</label></td>' + '<td class="label" align="center"><label for="lblFecIni">Fecha Inicio</label></td>' + '<td class="label" align="center"><label for="lblFecFin">Fecha Vencimiento</label> </td>  ' + '<td class="label" align="center"><label for="lblFecPag">Fecha Pago</label></td>' + '<td class="label" align="center"><label for="lblCapital">Capital</label></td> ' + '<td class="label" align="center"><label for="lblDescripcion">Inter&eacute;s</label></td> ' + '<td class="label" align="center"><label for="lblCargos">IVA Inter&eacute;s</label></td> ' + '<td class="label" align="center"><label for="lblSeguroCuota">Seguro</label></td> ' + '<td class="label" align="center"><label for="lblSeguroCuota">IVA Seguro</label></td> ' + '<td class="label" align="center"><label for="lblTotalPag">Total Pago</label></td> ' + '<td class="label" align="center"><label for="lblSaldoCap">Saldo Capital</label></td> ' + '<td class="label" align="center"><label for="lblAgregaElimina"></label></td> ' + '</tr>' + '</table>' + '</fieldset>';
        $('#contenedorSimuladorLibre').html(data);
        $('#contenedorSimuladorLibre').show();
        $('#contenedorSimulador').html(Constantes.CADENAVACIA);
        $('#contenedorSimulador').hide();
        mostrarGridLibresDetalle();
    }
    // ------------------------------------  Valida vacios cuando se hace el submit de una solicitud   ------------------------------- //
    function validaCamposRequeridos() {
        var procede = false;
        if ($("#fechaVencimiento").val() == Constantes.CADENAVACIA) {
            mensajeSis("La Fecha de Vencimiento Está Vací­a.");
            procede = false;
        } else {
            if ($("#numTransacSim").asNumber() == Constantes.ENTEROCERO || $('#numTransacSim').val() == Constantes.CADENAVACIA) {
                mensajeSis("Se Requiere Simular las Amortizaciones.");
                procede = false;
            } else {
                if ($("#frecuenciaCap").val() == Constantes.ENTEROCERO || $("#frecuenciaCap").val() == Constantes.CADENAVACIA) {
                    mensajeSis("La Frecuencia de Capital Está Vacía.");
                    $("#frecuenciaCap").focus();
                    procede = false;
                } else {
                    if ($("#tipoPagoCapital").val() == Constantes.ENTEROCERO) {
                        mensajeSis("El Tipo de Pago Está Vacío, Se Reiniciarán los Valores Originales de la Solicitud.");
                        procede = false;
                    } else {
                        if ($("#diaPagoCapital2").is(':checked') && $('#diaMesCapital').asNumber() == Constantes.ENTEROCERO) {
                            mensajeSis("Especificar Día Mes Capital.");
                            $('#diaMesCapital').focus();
                            procede = false;
                        } else {
                            //
                            if (($('#frecuenciaInt').val() == Constantes.ENTEROCERO || $('#frecuenciaInt').val()) == Constantes.CADENAVACIA && $('#tipoPagoCapital').val() != var_PagoCapital.CRECIENTES) {
                                mensajeSis("Especifique Frecuencia de Interés.");
                                $('#frecuenciaInt').focus();
                                procede = false;
                            } else {
                                if ($('#numAmortInteres').asNumber() == Constantes.ENTEROCERO) {
                                    if ($('#calendIrregular').val() == Constantes.SI) {
                                        mensajeSis("Es Necesario Calcular de nuevo las Amortizaciones.");
                                        $('#calcular').focus();
                                        procede = false;
                                    } else {
                                        mensajeSis("Número de Cuotas de Interés Vacio.");
                                        $('#numAmortInteres').focus();
                                        procede = false;
                                    }
                                } else {
                                    if ($('#diaPagoInteres2').is(':checked') && $('#diaMesInteres').asNumber() == Constantes.ENTEROCERO && $('#tipoPagoCapital').val() != var_PagoCapital.CRECIENTES) {
                                        mensajeSis("Especificar Día Mes Interés.");
                                        $('#diaMesInteres').focus();
                                        procede = false;
                                    } else {
                                        if ($('#productoCreditoID').asNumber() == Constantes.ENTEROCERO || $('#productoCreditoID').val() == Constantes.CADENAVACIA) {
                                            mensajeSis("El Producto de Crédito Está Vacío.");
                                            $('#productoCreditoID').focus();
                                            procede = false;
                                        } else {
                                            if ($('#destinoCreID').asNumber() == Constantes.ENTEROCERO || $('#destinoCreID').val() == Constantes.CADENAVACIA) {
                                                mensajeSis("El Destino de Crédito Está Vacío.");
                                                $('#creditoID').focus();
                                                procede = false;
                                            } else {
                                                if ($('#tipoDispersion').val() == Constantes.ENTEROCERO) {
                                                    mensajeSis("El Tipo de Dispersion Está Vacío.");
                                                    $('#tipoDispersion').focus();
                                                    procede = false;
                                                } else {
                                                    if ($('#tasaFija').asNumber() > Constantes.ENTEROCERO) {
                                                        if ($('#frecuenciaCap').val() == var_Frecuencia.PAGOUNICO) {
                                                            if ($('#tipoPagoCapital').val() != var_PagoCapital.IGUALES) {
                                                                mensajeSis("El Pago Único sólo Aplica para Pagos de Capital Iguales.");
                                                                procede = false;
                                                            } else {
                                                                procede = true;
                                                            }
                                                        } else {
                                                            procede = true;
                                                        }
                                                    } else {
                                                        mensajeSis("La Tasa Fija Anualizada no es Válida.");
                                                        procede = false;
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
    // ---------------------------------- Consulta si el cliente ya tiene huella digital registrada ------------------------------------- //
    function consultaHuellaCliente() {
        var clienteID = $('#clienteID').val();
        var estatusSolici = Constantes.CADENAVACIA;
        if (SolicitudCredito != null) {
            estatusSolici = SolicitudCredito.estatus;
        }
        if (clienteID != Constantes.CADENAVACIA && !isNaN(clienteID)) {
            var bean = {
                'personaID': clienteID
            };
            huellaDigitalServicio.consulta(var_numConsultaHuellaDigital.principal, bean, {
                async: false,
                callback: function(cliente) {
                    if (cliente == null) {
                        if (var_funcionHuella == Constantes.SI) {
                            mensajeSis("El " + var_clienteSocio + " No Tiene Huella Registrada.\nFavor de Verificar.");
                            if (estatusSolici == Constantes.ESTATUSINACTIVO || Constantes.CADENAVACIA) {
                                $('#creditoID').focus();
                                $('#creditoID').select();
                            } else {
                                $('#solicitudCreditoID').focus();
                                $('#solicitudCreditoID').select();
                            }
                        }
                    }
                }
            });
        }
    }
    // - Consulta parametros del sistema para verificar si la empresa esta configurada que requiere huella digital y parametros de renovaciones - //
    function consultaParametrosSistema() {
        var bean = {
            'empresaID': var_empresaID
        };
        parametrosSisServicio.consulta(var_numConsultaParamSis.principal, bean, {
            async: false,
            callback: function(parametrosSisBean) {
                if (parametrosSisBean != null) {
                    var_numReestructuraPer = parametrosSisBean.numTratamienCre;
                    var_capCubiertoReestruct = parametrosSisBean.capitalCubierto;
                    if (parametrosSisBean.reqhuellaProductos != null) {
                        var_requiereHuellaCreditos = parametrosSisBean.reqhuellaProductos;
                    } else {
                        var_requiereHuellaCreditos = Constantes.NO;
                    }
                } else {
                    var_requiereHuellaCreditos = Constantes.NO;
                    var_numReestructuraPer = Constantes.ENTEROCERO;
                    var_capCubiertoReestruct = Constantes.ENTEROCERO;
                }
            }
        });
    }
    // ------------------------------------------------ Calcula el monto de garantia liquida ------------------------------------------------ //
    function calculosyOperacionesDosDecimalesMultiplicacion(valor1, valor2) {
        var calcOperBean = {
            'valorUnoA': 0,
            'valorDosA': 0,
            'valorUnoB': valor1,
            'valorDosB': valor2,
            'numeroDecimales': 2
        };
        setTimeout("$('#cajaLista').hide();", 200);
        calculosyOperacionesServicio.calculosYOperaciones(2, calcOperBean, function(valoresResultado) {
            if (valoresResultado != null) {
                $('#aporteCliente').val(valoresResultado.resultadoCuatroDecimales);
                agregarFormatoMoneda('aporteCliente');
                agregaFormatoControles('formaGenerica');
            } else {
                mensajeSis('Indique el monto de nuevo.');
                $('#aporteCliente').val(Constantes.DECIMALCERO);
            }
        });
    }
    // ----------------------------  Función para calcular los días transcurridos entre dos fechas ------------------------------ //
    function restaFechas(fAhora, fEvento) {
        var ahora = new Date(fAhora);
        var evento = new Date(fEvento);
        var tiempo = evento.getTime() - ahora.getTime();
        var dias = Math.floor(tiempo / (1000 * 60 * 60 * 24));
        return dias;
    }
}); // fin $(document).ready()
//------------------------  Simulador de pagos libres de capital (La frecuencia es diferente de Libres) ----------------------------- //
function simuladorPagosLibres(numTransaccion) {
    $('#numTransacSim').val(numTransaccion);
    if (validaUltimaCuotaCapSimulador()) {
        if (crearMontosCapital(numTransaccion)) {
            var params = {};
            if ($('#calcInteresID').val() == var_TipoTasa.TASAFIJA) {
                switch ($('#tipoPagoCapital').val()) {
                    case var_PagoCapital.CRECIENTES:
                        tipoLista = var_Simulador.TasaFija_Crecientes;
                        break;
                    case var_PagoCapital.IGUALES:
                        tipoLista = var_Simulador.TasaFija_Iguales;
                        break;
                    case var_PagoCapital.LIBRES:
                        tipoLista = var_Simulador.TasaFija_Libres;
                        break;
                }
            } else {
                switch ($('#tipoPagoCapital').val()) {
                    case var_PagoCapital.IGUALES:
                        tipoLista = var_Simulador.NOTasaFija_Iguales;
                        break;
                    case var_PagoCapital.LIBRES:
                        tipoLista = var_Simulador.NOTasaFija_Libres;
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
            params['sucursal'] = parametroBean.sucursal;
            params['numTransaccion'] = $('#numTransacSim').val();
            params['numTransacSim'] = $('#numTransacSim').val();
            params['montosCapital'] = $('#montosCapital').val();
            params['cobraSeguroCuota'] = $('#cobraSeguroCuota option:selected').val();
            params['cobraIVASeguroCuota'] = $('#cobraIVASeguroCuota option:selected').val();
            params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
            params['plazoID'] = $('#plazoID').val();
            params['tipoOpera'] = 1;
            params['cobraAccesorios'] = cobraAccesorios;
            bloquearPantallaAmortizacion();
            var numeroError = 0;
            var mensajeTransaccion = "";
            $.post("simPagLibresCredito.htm", params, function(data) {
                if (data.length > Constantes.ENTEROCERO) {
                    $('#contenedorSimulador').html(Constantes.CADENAVACIA);
                    $('#contenedorSimulador').hide();
                    $('#contenedorSimuladorLibre').html(data);
                    if ($("#numeroErrorList").length) {
                        numeroError = $('#numeroErrorList').asNumber();
                        mensajeTransaccion = $('#mensajeErrorList').val();
                    }
                    if (numeroError == 0) {
                        $('#contenedorSimuladorLibre').show();
                        var valorTransaccion = $('#transaccion').val();
                        $('#numTransacSim').val(valorTransaccion);
                        $('#contenedorForma').unblock();
                        // actualiza la nueva fecha de vencimiento que devuelve el cotizador
                        var jqFechaVen = eval("'#valorFecUltAmor'");
                        $('#fechaVencimiento').val($(jqFechaVen).val());
                        // actualiza el numero de cuotas generadas por el cotizador
                        $('#numAmortInteres').val($('#valorCuotasInteres').val());
                        $('#numAmortizacion').val($('#valorCuotasCapital').val());
                        $('#totalCap').val(totalizaCapital());
                        $('#totalInt').val(totalizaInteres());
                        $('#totalIva').val(totalizaIva());
                        agregarFormatoMoneda('totalCap');
                        agregarFormatoMoneda('totalInt');
                        agregarFormatoMoneda('totalIva');
                        $("#imprimirRep").css({
                            display: "block"
                        });
                    }
                } else {
                    $('#contenedorSimulador').html(Constantes.CADENAVACIA);
                    $('#contenedorSimulador').show();
                }
                /****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
                if (numeroError != 0) {
                    $('#contenedorForma').unblock({
                        fadeOut: 0,
                        timeout: 0
                    });
                    mensajeSisError(numeroError, mensajeTransaccion);
                }
                /**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
            });
        }
    }
} // fin simuladorPagosLibres
// ----------------- Para ejecutar el simulador de pagos libres de capital y fecha cuando das clic en el boton calcular ------------- //
function simuladorLibresCapFec() {
    var mandar = "";
    if (validaUltimaCuotaCapSimulador()) {
        mandar = crearMontosCapitalFecha();
        if (mandar == 2) {
            var params = {};
            if ($('#calcInteresID').val() == 1) {
                if ($('#calendIrregularCheck').is(':checked')) {
                    tipoLista = 7;
                } else {
                    switch ($('#tipoPagoCapital').val()) {
                        case var_PagoCapital.CRECIENTES:
                            tipoLista = 1;
                            break;
                        case var_PagoCapital.IGUALES:
                            tipoLista = 2;
                            break;
                        case var_PagoCapital.LIBRES:
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
                        case var_PagoCapital.IGUALES:
                            tipoLista = 4;
                            break;
                        case var_PagoCapital.LIBRES:
                            tipoLista = 5;
                            break;
                        default:
                            tipoLista = 4;
                    }
                }
            }
            params['tipoLista'] = tipoLista;
            params['montoCredito'] = $('#montoSolici').asNumber();
            params['tasaFija'] = $('#tasaFija').asNumber();
            params['fechaInhabil'] = $('#fechInhabil').val();
            params['empresaID'] = parametroBean.empresaID;
            params['usuario'] = parametroBean.numeroUsuario;
            params['fecha'] = parametroBean.fechaSucursal;
            params['direccionIP'] = parametroBean.IPsesion;
            params['sucursal'] = parametroBean.sucursal;
            params['montosCapital'] = $('#montosCapital').val();
            params['pagaIva'] = $('#pagaIva').val();
            params['iva'] = $('#iva').asNumber();
            params['producCreditoID'] = $('#productoCreditoID').val();
            params['clienteID'] = $('#clienteID').val();
            params['montoComision'] = Constantes.DECIMALCERO;
            params['cobraSeguroCuota'] = $('#cobraSeguroCuota option:selected').val();
            params['cobraIVASeguroCuota'] = $('#cobraIVASeguroCuota option:selected').val();
            params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
            params['plazoID'] = $('#plazoID').val();
            params['tipoOpera'] = 1;
            params['cobraAccesorios'] = cobraAccesorios;
            bloquearPantallaAmortizacion();
            var numeroError = 0;
            var mensajeTransaccion = "";
            $.post("simPagLibresCredito.htm", params, function(data) {
                if (data.length > Constantes.ENTEROCERO) {
                    $('#contenedorSimulador').html(Constantes.CADENAVACIA);
                    $('#contenedorSimulador').hide();
                    $('#contenedorSimuladorLibre').html(data);
                    if ($("#numeroErrorList").length) {
                        numeroError = $('#numeroErrorList').asNumber();
                        mensajeTransaccion = $('#mensajeErrorList').val();
                    }
                    if (numeroError == 0) {
                        $('#contenedorSimuladorLibre').show();
                        var valorTransaccion = $('#transaccion').val();
                        $('#numTransacSim').val(valorTransaccion);
                        // actualiza la nueva fecha de vencimiento que devuelve el cotizador
                        var jqFechaVen = eval("'#valorFecUltAmor'");
                        $('#fechaVencimiento').val($(jqFechaVen).val());
                        $('#contenedorForma').unblock();
                        // actualiza el numero de cuotas generadas por el cotizador
                        $('#numAmortInteres').val($('#valorCuotasInteres').val());
                        $('#numAmortizacion').val($('#valorCuotasCapital').val());
                        $('#totalCap').val(totalizaCapital());
                        $('#totalInt').val(totalizaInteres());
                        $('#totalIva').val(totalizaIva());
                        agregarFormatoMoneda('totalCap');
                        agregarFormatoMoneda('totalInt');
                        agregarFormatoMoneda('totalIva');
                        $("#imprimirRep").css({
                            display: "block"
                        });
                        if ($('#solicitudCreditoID').val() == Constantes.ENTEROCERO) {
                            deshabilitaBoton('modificar', 'submit');
                            habilitaBoton('agregar', 'submit');
                        } else if ($('#solicitudCreditoID').asNumber() > Constantes.ENTEROCERO && $('#estatus').val() == Constantes.ESTATUSINACTIVO) {
                            habilitaBoton('modificar', 'submit');
                            deshabilitaBoton('agregar', 'submit');
                        } else {
                            deshabilitaBoton('modificar', 'submit');
                            deshabilitaBoton('agregar', 'submit');
                        }
                    }
                } else {
                    $('#contenedorSimulador').html(Constantes.CADENAVACIA);
                    $('#contenedorSimulador').hide();
                    $('#contenedorSimuladorLibre').html(Constantes.CADENAVACIA);
                    $('#contenedorSimuladorLibre').hide();
                }
                /****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
                if (numeroError != 0) {
                    $('#contenedorForma').unblock({
                        fadeOut: 0,
                        timeout: 0
                    });
                    mensajeSisError(numeroError, mensajeTransaccion);
                }
                /**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
            });
        }
    }
}
// ----------------------- Valida la ultima cuota de capital en el simulador de pagos NO sea cero ------------------------- //
function validaUltimaCuotaCapSimulador() {
    var procede = false;
    if ($('#tipoPagoCapital').val() == var_PagoCapital.LIBRES) {
        var numAmortizacion = $('input[name=capital]').length;
        for (var i = 1; i <= numAmortizacion; i++) {
            if (i == numAmortizacion) {
                var idCapital = eval("'#capital" + i + "'");
                if ($(idCapital).asNumber() == Constantes.ENTEROCERO) {
                    document.getElementById("capital" + i + "").focus();
                    document.getElementById("capital" + i + "").select();
                    $("capital" + i).addClass("error");
                    mensajeSis("La Última Cuota de Capital no Puede ser Cero.");
                    procede = false;
                } else {
                    if ($('#diferenciaCapital').asNumber() == Constantes.ENTEROCERO) {
                        procede = true;
                    } else {
                        mensajeSis(" La Suma de Capital en Amortizaciones debe ser Igual al Monto Solicitado.");
                        procede = false;
                    }
                }
            } else {
                if ($('#diferenciaCapital').asNumber() == Constantes.ENTEROCERO) {
                    procede = true;
                } else {
                    mensajeSis(" La Suma de Capital en Amortizaciones debe ser igual al Monto Solicitado.");
                    procede = false;
                }
            }
        }
    } else {
        // se valida que si el tipo de pago de capital es libre, no se pueda  escoger como frecuencia la opcion de libre  //
        if ($('#frecuenciaInt').val() == var_Frecuencia.LIBRE && $('#calendIrregular').val() == Constantes.NO) {
            mensajeSis("La Frecuencia de Interés Libre sólo Aplica para Calendario Irregular.");
            $('#frecuenciaInt').focus();
            $('#frecuenciaInt').val(Constantes.CADENAVACIA);
            procede = false;
        } else {
            if ($('#frecuenciaCap').val() == var_Frecuencia.LIBRE && $('#calendIrregular').val() == Constantes.NO) {
                mensajeSis("La Frecuencia de Capital Libre sólo Aplica para Calendario Irregular.");
                $('#frecuenciaCap').focus();
                $('#frecuenciaCap').val(Constantes.CADENAVACIA);
                procede = false;
            } else {
                procede = true;
            }
        }
    }
    return procede;
}
// Asigna valor por default a consultaSIC
function consultaSICParam() {
    var parametrosSisCon = {
        'empresaID': 1
    };
    setTimeout("$('#cajaLista').hide();", 200);
    parametrosSisServicio.consulta(1, parametrosSisCon, function(parametroSistema) {
        if (parametroSistema != null) {
            if (parametroSistema.conBuroCreDefaut == 'B') { // si tiene por default Buro
                $('#tipoConsultaSICBuro').attr("checked", true);
                $('#tipoConsultaSICCirculo').attr("checked", false);
                $('#consultaBuro').show();
                $('#consultaCirculo').hide();
                $('#folioConsultaCC').val('');
                $('#tipoConsultaSIC').val('BC');
            } else if (parametroSistema.conBuroCreDefaut == 'C') { // si tiene por default Circulo
                $('#tipoConsultaSICBuro').attr("checked", false);
                $('#tipoConsultaSICCirculo').attr("checked", true);
                $('#consultaBuro').hide();
                $('#consultaCirculo').show();
                $('#folioConsultaBC').val('');
                $('#tipoConsultaSIC').val('CC');
            }
        }
    });
}
// ----------------------------------------- Arma los montos de capital ------------------------------------------- //
function crearMontosCapital(numTransaccion) {
    var idCapital = Constantes.CADENAVACIA;
    if (sumaCapital()) {
        $('#montosCapital').val(Constantes.CADENAVACIA);
        for (var i = 1; i <= $('input[name=capital]').length; i++) {
            idCapital = eval("'#capital" + i + "'");
            if ($(idCapital).asNumber() >= Constantes.ENTEROCERO) {
                if (i == 1) {
                    $('#montosCapital').val($('#montosCapital').val() + i + ']' + $(idCapital).asNumber() + ']' + numTransaccion);
                } else {
                    $('#montosCapital').val($('#montosCapital').val() + '[' + i + ']' + $(idCapital).asNumber() + ']' + numTransaccion);
                }
            }
        }
        return true;
    } else {
        return false;
    }
}

function crearMontosCapitalFecha() {
    var mandar = verificarvaciosCapFec();
    var regresar = 1;
    if (mandar != 1) {
        if (sumaCapital()) {
            var numAmortizacion = $('input[name=capital]').length;
            $('#montosCapital').val("");
            for (var i = 1; i <= numAmortizacion; i++) {
                var idCapital = eval("'#capital" + i + "'");
                if (i == 1) {
                    $('#montosCapital').val($('#montosCapital').val() + i + ']' + $(idCapital).asNumber() + ']' + document.getElementById("fechaInicio" + i + "").value + ']' + document.getElementById("fechaVencim" + i + "").value);
                } else {
                    $('#montosCapital').val($('#montosCapital').val() + '[' + i + ']' + $(idCapital).asNumber() + ']' + document.getElementById("fechaInicio" + i + "").value + ']' + document.getElementById("fechaVencim" + i + "").value);
                }
            }
            regresar = 2;
        } else {
            regresar = 1;
        }
    }
    return regresar;
}

function verificarvaciosCapFec() {
    var numAmortizacion = $('input[name=capital]').length;
    $('#montosCapital').val(Constantes.CADENAVACIA);
    var regresar = 1;
    for (var i = 1; i <= numAmortizacion; i++) {
        var jqfechaInicio = eval("'#fechaInicio" + i + "'");
        var jqfechaVencim = eval("'#fechaVencim" + i + "'");
        var valFecIni = document.getElementById("fechaInicio" + i).value;
        var valFecVen = document.getElementById("fechaVencim" + i).value;
        if (valFecIni == Constantes.CADENAVACIA) {
            document.getElementById("fechaInicio" + i).focus();
            $(jqfechaInicio).addClass("error");
            regresar = 1;
            mensajeSis("Especifique Fecha de Inicio.");
            i = numAmortizacion + 2;
        } else {
            regresar = 3;
            $(jqfechaInicio).removeClass("error");
        }
        if (valFecVen == Constantes.CADENAVACIA) {
            document.getElementById("fechaVencim" + i).focus();
            $(jqfechaVencim).addClass("error");
            mensajeSis("Especifique Fecha de Vencimiento.");
            regresar = 1;
            i = numAmortizacion + 2;
        } else {
            regresar = 4;
            $(jqfechaVencim).removeClass("error");
        }
    }
    return regresar;
}
// ------------------------- funcion para verificar que la suma del capital sea igual que la del monto --------------------------- //
function sumaCapital() {
    var jqCapital;
    var suma = 0;
    var contador = 1;
    var capital;
    $('input[name=capital]').each(function() {
        jqCapital = eval("'#" + this.id + "'");
        capital = $(jqCapital).asNumber();
        if (capital != Constantes.CADENAVACIA && !isNaN(capital)) {
            suma = suma + capital;
            contador = contador + 1;
            agregarFormatoMoneda(this.id);
        } else {
            $(jqCapital).val(Constantes.ENTEROCERO);
        }
    });
    var conDecimal = suma.toFixed(2);
    if (conDecimal != $('#montoSolici').asNumber()) {
        mensajeSis("La suma de Montos de Capital debe ser Igual al Monto Solicitado.");
        deshabilitaBoton('continuar', 'submit');
        return false;
    } else {
        return true;
    }
}

function mostrarGridLibresDetalle() {
    var cobraSeguroCuota = $('#cobraSeguroCuota option:selected').val();
    var numeroFila = document.getElementById("numeroDetalle").value;
    var nuevaFila = parseInt(numeroFila) + 1;
    var filaAnterior = parseInt(nuevaFila) - 1;
    var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
    var valorDiferencia = $('#diferenciaCapital').asNumber();
    var valorSumaCapital = $('#totalCap').asNumber();
    if (numeroFila == 0) {
        tds += '<td><input type="text" id="consecutivoID' + nuevaFila + '" name="consecutivoID" size="4" value="1" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="fechaInicio' + nuevaFila + '"  name="fechaInicio" size="15" value="' + $('#fechaInicioAmor').val() + '" readonly="true" disabled="true"/></td>';
        tds += '<td align="center"><input type="text" id="fechaVencim' + nuevaFila + '" name="fechaVencim" size="15" value="" onblur="comparaFechas(this.id)"/></td>';
        tds += '<td align="center"><input type="text" id="fechaExigible' + nuevaFila + '" name="fechaExigible" size="15" value=" " readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="capital' + nuevaFila + '" name="capital" size="18" style="text-align: right;" value="" esMoneda="true"' + '  onblur="agregaFormatoMonedaGrid(this.id);calculaDiferenciaSimuladorLibre()"/></td>';
        tds += '<td><input type="text" id="interes' + nuevaFila + '" name="interes" size="18" style="text-align: right;" value="" esMoneda="true" readonly="true"  disabled="true"/></td>';
        tds += '<td><input type="text" id="ivaInteres' + nuevaFila + '" name="ivaInteres" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
        if (cobraSeguroCuota == 'S') {
            tds += '<td><input id="montoSeguroCuota' + nuevaFila + '" name="montoSeguroCuotaSim" size="18" style="text-align: right;" type="text" style="text-align: right;" value="" readonly="readonly" disabled="disabled" esMoneda="true" /></td>';
            tds += '<td><input id="iVASeguroCuota' + nuevaFila + '" name="iVASeguroCuota" size="18" style="text-align: right;" type="text" style="text-align: right;" value="" readonly="readonly" disabled="disabled" esMoneda="true" /></td>';
        }
        tds += '<td><input type="text" id="totalPago' + nuevaFila + '" name="totalPago" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="saldoInsoluto' + nuevaFila + '" name="saldoInsoluto" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
    } else {
        $('#trBtnCalcular').remove();
        $('#trDiferenciaCapital').remove();
        $('#filaTotales').remove();
        var valor = parseInt(document.getElementById("consecutivoID" + numeroFila + "").value) + 1;
        tds += '<td><input type="text" id="consecutivoID' + nuevaFila + '" name="consecutivoID" size="4" value="' + valor + '" autocomplete="off" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="fechaInicio' + nuevaFila + '"  name="fechaInicio" size="15" value="' + $('#fechaVencim' + filaAnterior).val() + '" readonly="true" disabled="true"/></td>';
        tds += '<td align="center"><input type="text" id="fechaVencim' + nuevaFila + '" name="fechaVencim" size="15" value="" onblur="comparaFechas(this.id)" /></td>';
        tds += '<td align="center"><input type="text" id="fechaExigible' + nuevaFila + '" name="fechaExigible" size="15" value="" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="capital' + nuevaFila + '" name="capital" size="18" style="text-align: right;" value="" esMoneda="true" ' + '  onblur="agregaFormatoMonedaGrid(this.id);calculaDiferenciaSimuladorLibre()"/></td>';
        tds += '<td><input type="text" id="interes' + nuevaFila + '" name="interes" size="18" style="text-align: right;" value="" esMoneda="true" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="ivaInteres' + nuevaFila + '" name="ivaInteres" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
        if (cobraSeguroCuota == 'S') {
            tds += '<td><input id="montoSeguroCuota' + nuevaFila + '" name="montoSeguroCuotaSim" size="18" style="text-align: right;" type="text" style="text-align: right;" value="" readonly="readonly" disabled="disabled" esMoneda="true" /></td>';
            tds += '<td><input id="iVASeguroCuota' + nuevaFila + '" name="iVASeguroCuota" size="18" style="text-align: right;" type="text" style="text-align: right;" value="" readonly="readonly" disabled="disabled" esMoneda="true" /></td>';
        }
        tds += '<td><input type="text" id="totalPago' + nuevaFila + '" name="totalPago" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="saldoInsoluto' + nuevaFila + '" name="saldoInsoluto" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
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
    tds += '<td  id="btnCalcularLibre" colspan="10" align="right">' + '<input type="button" class="submit" id="calcular" tabindex="37" value="Calcular" onclick="simuladorLibresCapFec();"/>' + '</td>';
    tds += '<td>' + '<input type="button" id="imprimirRep" class="submit" style="display:none;" value="Imprimir" onclick="generaReporte();"/>'; + '</td></tr>';
    document.getElementById("numeroDetalle").value = nuevaFila;
    $('#miTabla').append(tds);
    sugiereFechaSimuladorLibre();
    deshabilitaBoton('modificar', 'submit');
    deshabilitaBoton('liberar', 'submit');
    deshabilitaBoton('agregar', 'submit');
    agregaFormatoControles('formaGenerica');
}

function agregarNuevaAmortizacion() {
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
        tds += '<td><input type="text" id="consecutivoID' + nuevaFila + '" name="consecutivoID" size="4" value="1" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="fechaInicio' + nuevaFila + '"  name="fechaInicio" size="15" value="' + $('#fechaInicioAmor').val() + '" readonly="true" disabled="true"/></td>';
        tds += '<td align="center"><input type="text" id="fechaVencim' + nuevaFila + '" name="fechaVencim" size="15" value="" onblur="comparaFechas(this.id);"  /></td>';
        tds += '<td align="center"><input type="text" id="fechaExigible' + nuevaFila + '" name="fechaExigible" size="15" value="" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="capital' + nuevaFila + '" name="capital" size="18" style="text-align: right;" value="" esMoneda="true" ' + '  onblur="agregaFormatoMonedaGrid(this.id);calculaDiferenciaSimuladorLibre()"/></td>';
        tds += '<td><input type="text" id="interes' + nuevaFila + '" name="interes" size="18" style="text-align: right;" value="" esMoneda="true" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="ivaInteres' + nuevaFila + '" name="ivaInteres" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
        if (cobraSeguroCuota == 'S') {
            tds += '<td><input id="montoSeguroCuota' + nuevaFila + '" name="montoSeguroCuotaSim" size="18" style="text-align: right;" type="text" style="text-align: right;" value="" readonly="readonly" disabled="disabled" esMoneda="true" /></td>';
            tds += '<td><input id="iVASeguroCuota' + nuevaFila + '" name="iVASeguroCuota" size="18" style="text-align: right;" type="text" style="text-align: right;" value="" readonly="readonly" disabled="disabled" esMoneda="true" /></td>';
        }
        tds += '<td><input type="text" id="totalPago' + nuevaFila + '" name="totalPago" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="saldoInsoluto' + nuevaFila + '" name="saldoInsoluto" size="18" style="text-align: right;"  value=" " esMoneda="true" readonly="true" disabled="true"/></td>';
    } else {
        $('#trBtnCalcular').remove();
        $('#trDiferenciaCapital').remove();
        $('#filaTotales').remove();
        var valor = parseInt(document.getElementById("consecutivoID" + numeroFila + "").value) + 1;
        tds += '<td><input type="text" id="consecutivoID' + nuevaFila + '" name="consecutivoID" size="4" value="' + valor + '" autocomplete="off" readonly="true" disabled="true" /></td>';
        tds += '<td><input type="text" id="fechaInicio' + nuevaFila + '"  name="fechaInicio" size="15" value="' + $('#fechaVencim' + filaAnterior).val() + '" readonly="true" disabled="true"/></td>';
        tds += '<td align="center"><input type="text" id="fechaVencim' + nuevaFila + '" name="fechaVencim" size="15" value="" onblur="comparaFechas(this.id)" /></td>';
        tds += '<td align="center"><input type="text" id="fechaExigible' + nuevaFila + '" name="fechaExigible" size="15" value="" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="capital' + nuevaFila + '" name="capital" size="18" style="text-align: right;" value="" esMoneda="true"' + '  onblur="agregaFormatoMonedaGrid(this.id);calculaDiferenciaSimuladorLibre()"/></td>';
        tds += '<td><input type="text" id="interes' + nuevaFila + '" name="interes" size="18" style="text-align: right;" value="" esMoneda="true" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="ivaInteres' + nuevaFila + '" name="ivaInteres" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
        if (cobraSeguroCuota == 'S') {
            tds += '<td><input id="montoSeguroCuota' + nuevaFila + '" name="montoSeguroCuotaSim" size="18" style="text-align: right;" type="text" style="text-align: right;" value="" readonly="readonly" disabled="disabled" esMoneda="true" /></td>';
            tds += '<td><input id="iVASeguroCuota' + nuevaFila + '" name="iVASeguroCuota" size="18" style="text-align: right;" type="text" style="text-align: right;" value="" readonly="readonly" disabled="disabled" esMoneda="true" /></td>';
        }
        tds += '<td><input type="text" id="totalPago' + nuevaFila + '" name="totalPago" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
        tds += '<td><input type="text" id="saldoInsoluto' + nuevaFila + '" name="saldoInsoluto" size="18" style="text-align: right;"  value="" esMoneda="true" readonly="true" disabled="true"/></td>';
    }
    tds += '<td nowrap="nowrap"><input type="button" name="elimina" id="' + nuevaFila + '" value="" class="btnElimina" onclick="eliminaAmort(this)"/>' + '<input type="button" name="agrega" id="agrega' + nuevaFila + '" value="" class="btnAgrega" onclick="agregaNuevaAmort()"/></td>';
    tds += '</tr>';
    tds += '<tr id="filaTotales">' + '<td colspan="4" align="right"><label for="lblTotales">Totales: </label></td>';
    tds += '<td>' + '<input id="totalCap" name="totalCap"  size="18" readOnly="true" style="text-align: right;" value="' + valorSumaCapital + '"esMoneda="true"/>' + '</td>';
    tds += '</tr>';
    tds += '<tr id="trDiferenciaCapital" >';
    tds += '<td colspan="4" align="right"><label for="Diferencia">Diferencia: </label></td>';
    tds += '<td  id="inputDiferenciaCap">' + '<input type="text" id="diferenciaCapital" name="diferenciaCapital" size="18" style="text-align: right;" value="' + valorDiferencia + '" esMoneda="true" readonly="true" disabled="true"/>' + '</td>';
    tds += '<td colspan="5"></td>' + '</tr>';
    tds += '<tr id="trBtnCalcular" >';
    tds += '<td  id="btnCalcularLibre" colspan="10" align="right">' + '<input type="button" class="submit" id="calcular" tabindex="37" value="Calcular" onclick="simuladorLibresCapFec();"/>' + '</td>';
    tds += '<td>' + '<input type="button" id="imprimirRep" class="submit" style="display:none;" value="Imprimir" onclick="generaReporte();"/>' + '</td>';
    tds += '</tr>';
    document.getElementById("numeroDetalle").value = nuevaFila;
    $("#miTabla").append(tds);
    sugiereFechaSimuladorLibre();
    calculaDiferenciaSimuladorLibre();
    calculoTotalCapital();
    calculoTotalInteres();
    calculoTotalIva();
    return false;
}

function agregaNuevaAmort() {
    agregarNuevaAmortizacion();
}

function eliminaAmort(evento) {
    eliminarAmortizacion(evento);
}
// ------------------------------- funcion para eliminar una amortizacion del calendario irregular ------------------------- //
function eliminarAmortizacion(control) {
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
    var jqMontoSeguro = eval("'#montoSeguro" + numeroID + "'");
    var jqIVASeguroCuota = eval("'#iVASeguroCuota" + numeroID + "'");
    var jqTotalPago = eval("'#totalPago" + numeroID + "'");
    var jqSaldoInsoluto = eval("'#saldoInsoluto" + numeroID + "'");
    var jqElimina = eval("'#" + numeroID + "'");
    var jqAgrega = eval("'#agrega" + numeroID + "'");
    // Cambia el valor siguiente del que se modifica o elimina y las filas continual de manera coherente
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
        $(jqTotalPago).remove();
        $(jqSaldoInsoluto).remove();
        $(jqElimina).remove();
        $(jqAgrega).remove();
        $(jqTr).remove();
        // se asigna el numero de detalle que quedan
        var elementos = document.getElementsByName("renglon");
        $('#numeroDetalle').val(elementos.length);
        // Se compara si queda as de una fila
        if ($('#numeroDetalle').asNumber() > Constantes.ENTEROCERO) {
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
                var jqMontoSeg = eval("'montoSeguroCuota" + numero + "'");
                var jqiVASeguroCuo = eval("'iVASeguroCuota" + numero + "'");
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
                document.getElementById(jqMontoSeg).setAttribute('id', "montoSeguroCuota" + contador);
                document.getElementById(jqiVASeguroCuo).setAttribute('id', "iVASeguroCuota" + contador);
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
            // si el usuario elimina la ultima fila, se agrega una fila nueva
            agregarNuevaAmortizacion();
        }
    }
}

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
// ------------------ Sugiere fecha y monto de acuerdo a lo que ya se habia indicado en el formulario ---------------- //
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
            positiveFormat: '%n',
            roundToDecimalPlace: 2
        });
    } else {
        $(varCapitalID).val($('#montoSolici').val());
        $(varCapitalID).formatCurrency({
            positiveFormat: '%n',
            roundToDecimalPlace: 2
        });
    }
}
//funcion para validar que la fecha de vencimiento indicada sea mayor a la de inicio
function comparaFechas(controlID) {
    var fila = controlID.substr(11, controlID.length);
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
    if ($(jqFechaVen).val() != Constantes.CADENAVACIA) {
        if (esFechaValida($(jqFechaVen).val(), jqFechaVen)) {
            if (validaFechaVencimientoGrid($(jqFechaVen).val(), $('#fechaVencimiento').val(), jqFechaVen, fila)) {
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
                                    // cambia el valor siguiente del que se modifica o elimina y las filas continuen de manera coherente
                                    comparaFechaModificadaSiguiente(fila, jqFechaVen, jqFechaIni);
                                }
                            } else {
                                // cambia el valor siguiente del que se modifica o elimina y las filas continuen de manera coherente
                                comparaFechaModificadaSiguiente(fila, jqFechaVen, jqFechaIni);
                            }
                        }
                    } else {
                        // cambia el valor siguiente del que se modifica o elimina y las filas continuen de manera coherente
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
// -------------- funcion para validar que la fecha de vencimiento No sea mayor a la de vencimiento calculada por los plazos. --------//
function validaFechaVencimientoGrid(fechaVenGrid, fechaVenCred, jqFechaVen, fila) {
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
// ------------- Valida que la fecha de vencimiento modificada no sea mayor a la fecha de vencimiento siguiente -------------- //
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
                if (validaFechaVencimientoGrid($(jqFechaVen).val(), $('#fechaVencimiento').val(), jqFechaVen, varid)) {
                    if (yYear < xYear) {
                        mensajeSis("La Fecha Indicada debe ser Menor a la Fecha de Vencimiento \nde la siguiente Amortización.");
                        document.getElementById("fechaVencim" + varid).focus();
                        $(jqFechaVen).addClass("error");
                    } else {
                        if (xYear == yYear) {
                            if (yMonth <= xMonth) {
                                if (xMonth == yMonth) {
                                    if (yDay <= xDay || yDay == xDay) {
                                        mensajeSis("La Fecha Indicada debe ser Menor a la Fecha de Vencimiento \nde la siguiente Amortización.");
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
// ----------- Cambiar el valor siguiente del que se modifica o elimina y asi las filas continuen de manera coherente --------- //
function ajustaValoresFechaModifica(numeroID, jqFechaInicio) {
    var idCajaRenom = "";
    var siguiente = 0;
    var numFilas = $('input[name=fechaVencim]').length;
    if (numeroID <= numFilas) {
        if (numeroID < numFilas) {
            siguiente = parseInt(numeroID) + parseInt(1);
            idCajaRenom = eval("'#fechaInicio" + siguiente + "'");
            jqFechaVencim = eval("'#fechaVencim" + numeroID + "'");
            $(idCajaRenom).val($(jqFechaVencim).val());
        }
    }
}
// ------------------------- Cacula diferencia del monto con lo que se va poniendo en el  grid de pagos libres -------------------- //
function calculaDiferenciaSimuladorLibre() {
    var sumaMontoCapturado = 0;
    var diferenciaMonto = 0;
    var numero = 0;
    var varCapitalID = "";
    var muestramensajeSis = true;
    $('input[name=capital]').each(function() {
        numero = this.id.substr(7, this.id.length);
        numDetalle = $('input[name=capital]').length;
        varCapitalID = eval("'#capital" + numero + "'");
        sumaMontoCapturado = sumaMontoCapturado + $(varCapitalID).asNumber();
        var conDecimal = sumaMontoCapturado.toFixed(2);
        if (conDecimal > $('#montoSolici').asNumber()) {
            if (muestramensajeSis) {
                mensajeSis("La Suma de Montos de Capital debe ser Igual al Monto Solicitado.");
                muestramensajeSis = false;
            }
            $(varCapitalID).val(Constantes.CADENAVACIA);
            $(varCapitalID).select();
            $(varCapitalID).focus();
            agregarFormatoMoneda(this.id);
            return false;
        } else {
            diferenciaMonto = $('#montoSolici').asNumber() - sumaMontoCapturado.toFixed(2);
            $('#diferenciaCapital').val(diferenciaMonto);
            agregarFormatoMoneda('diferenciaCapital');
            agregarFormatoMoneda(this.id);
        }
    });
}

function calculoTotalCapital() {
    var sumaMontoCapturado = 0;
    var numero = 0;
    var varCapitalID = Constantes.CADENAVACIA;
    var muestramensajeSis = true;
    $('input[name=capital]').each(function() {
        numero = this.id.substr(7, this.id.length);
        numDetalle = $('input[name=capital]').length;
        varCapitalID = eval("'#capital" + numero + "'");
        sumaMontoCapturado = sumaMontoCapturado + $(varCapitalID).asNumber();
        var conDecimal = sumaMontoCapturado.toFixed(2);
        if (conDecimal > $('#montoSolici').asNumber()) {
            if (muestramensajeSis) {
                mensajeSis("La Suma de Montos de Capital debe ser Igual al Monto Solicitado.");
                muestramensajeSis = false;
            }
            $(varCapitalID).val(Constantes.CADENAVACIA);
            $(varCapitalID).select();
            $(varCapitalID).focus();
            agregarFormatoMoneda(this.id);
            return false;
        } else {
            sumaMonto = sumaMontoCapturado.toFixed(2);
            $('#totalCap').val(sumaMonto);
            agregarFormatoMoneda('totalCap');
            agregarFormatoMoneda(this.id);
        }
    });
}

function calculoTotalInteres() {
    var sumaMontoCapturado = 0;
    var sumaMonto = 0;
    var numero = 0;
    var varCapitalID = Constantes.CADENAVACIA;
    $('input[name=capital]').each(function() {
        numero = this.id.substr(7, this.id.length);
        numDetalle = $('input[name=interes]').length;
        varCapitalID = eval("'#interes" + numero + "'");
        sumaMontoCapturado = sumaMontoCapturado + $(varCapitalID).asNumber();
        sumaMonto = sumaMontoCapturado.toFixed(2);
        $('#totalInt').val(sumaMonto);
        agregarFormatoMoneda('totalInt');
        agregarFormatoMoneda(this.id);
    });
}

function calculoTotalIva() {
    var sumaMontoCapturado = 0;
    var sumaMonto = 0;
    var numero = 0;
    var varCapitalID = Constantes.CADENAVACIA;
    $('input[name=ivaInteres]').each(function() {
        numero = this.id.substr(10, this.id.length);
        numDetalle = $('input[name=ivaInteres]').length;
        varCapitalID = eval("'#ivaInteres" + numero + "'");
        sumaMontoCapturado = sumaMontoCapturado + $(varCapitalID).asNumber();
        sumaMonto = sumaMontoCapturado.toFixed(2);
        $('#totalIva').val(sumaMonto);
        agregarFormatoMoneda('totalIva');
        agregarFormatoMoneda(this.id);
    });
}

function totalizaCapital() {
    var suma = 0;
    $('input[name=capital]').each(function() {
        var numero = this.id.substr(7, this.id.length);
        var Cap = eval("'#capital" + numero + "'");
        var capital = $(Cap).asNumber();
        suma = suma + capital;
    });
    return suma;
}

function totalizaInteres() {
    var suma = 0;
    $('input[name=interes]').each(function() {
        var numero = this.id.substr(7, this.id.length);
        var Cap = eval("'#interes" + numero + "'");
        var capital = $(Cap).asNumber();
        suma = suma + capital;
    });
    return suma;
}

function totalizaIva() {
    var suma = 0;
    $('input[name=ivaInteres]').each(function() {
        var numero = this.id.substr(10, this.id.length);
        var Cap = eval("'#ivaInteres" + numero + "'");
        var capital = $(Cap).asNumber();
        suma = suma + capital;
    });
    return suma;
}
// -------  Funcion que genera el reporte Proyeccion de Credito, para mostrar la tabla de amortizaciones generada por el simulador ----- //
function generaReporte() {
    var clienteID = $("#clienteID").val();
    var nombreCliente = $("#nombreCte").val();
    var tipoReporte = var_TipoReporte.PDF;
    var nombreInstitucion = parametroBean.nombreInstitucion;
    var capitalPagar = $("#totalCap").asNumber();
    var interesPagar = $("#totalInt").asNumber();
    var ivaPagar = $("#totalIva").asNumber();
    var frecuencia = $("#frecuenciaCap").val();
    var frecuenciaInt = $("#frecuenciaInt").val();
    var frecuenciaDes = $("#frecuenciaCap option:selected").html();
    var tasaFija = $("#tasaFija").asNumber();
    var numCuotas = $("#numAmortizacion").asNumber();
    var numCuotasInt = $("#numAmortInteres").asNumber();
    var califCliente = $("#calificaCredito").val() + "     " + calificacionCliente;
    var ejecutivo = parametroBean.nombreUsuario;
    var numTransaccion = $('#numTransacSim').val();
    var montoSol = $("#totalCap").asNumber();
    var periodicidad = $('#periodicidadCap').val();
    var periodicidadInt = $('#periodicidadInt').val();
    var diaPago = var_DiaPagoCapital;
    var diaPagoInt = var_DiaPagoInteres;
    var diaMes = $('#diaMesCapital').asNumber();
    var diaMesInt = $('#diaMesInteres').asNumber();
    var fechaInicio = $('#fechaInicioAmor').val();
    var producCreditoID = $('#productoCreditoID').val();
    var diaHabilSig = $('#fechInhabil').val();
    var ajustaFecAmo = $('#ajFecUlAmoVen').val();
    var ajusFecExiVen = $('#ajusFecExiVen').val();
    var comApertura = Constantes.DECIMALCERO;
    var calculoInt = $('#calcInteresID').val();
    var tipoCalculoInt = $('#tipoCalInteres').val();
    var tipoPagCap = $('#tipoPagoCapital').val();
    var cat = $('#CAT').val();
    // SEGUROS
    var cobraSeguroCuota = $('#cobraSeguroCuota option:selected').val();
    var cobraIVASeguroCuota = $('#cobraIVASeguroCuota option:selected').val();
    var montoSeguroCuota = $('#montoSeguroCuota').asNumber();
    var convenio        = $('#convenioNominaID').asNumber();

    if (periodicidad == Constantes.CADENAVACIA) {
        periodicidad = 0;
    }
    if (periodicidadInt == Constantes.CADENAVACIA) {
        periodicidadInt = 0;
    }
    if (diaMes == Constantes.CADENAVACIA) {
        diaMes = 0;
    }
    if (diaMesInt == Constantes.CADENAVACIA) {
        diaMesInt = 0;
    }
    if (cat == Constantes.CADENAVACIA) {
        cat = 0.0;
    }
    url = 'reporteProyeccionCredito.htm?clienteID=' + clienteID
                                    + '&nombreCliente=' + nombreCliente
                                    + '&tipoReporte=' + tipoReporte
                                    + '&nombreInstitucion=' + nombreInstitucion
                                    + '&totalCap=' + capitalPagar
                                    + '&totalInteres=' + interesPagar
                                    + '&totalIva=' + ivaPagar
                                    + '&cat=' + cat
                                    + '&califCliente=' + califCliente
                                    + '&usuario=' + ejecutivo
                                    + '&frecuencia=' + frecuencia
                                    + '&frecuenciaInt=' + frecuenciaInt
                                    + '&frecuenciaDes=' + frecuenciaDes
                                    + '&tasaFija=' + tasaFija
                                    + '&numCuotas=' + numCuotas
                                    + '&numCuotasInt=' + numCuotasInt
                                    + '&montoSol=' + montoSol
                                    + '&periodicidad=' + periodicidad
                                    + '&periodicidadInt=' + periodicidadInt
                                    + '&diaPago=' + diaPago
                                    + '&diaPagoInt=' + diaPagoInt
                                    + '&diaMes=' + diaMes
                                    + '&diaMesInt=' + diaMesInt
                                    + '&fechaInicio=' + fechaInicio
                                    + '&producCreditoID=' + producCreditoID
                                    + '&diaHabilSig=' + diaHabilSig
                                    + '&ajustaFecAmo=' + ajustaFecAmo
                                    + '&ajusFecExiVen=' + ajusFecExiVen
                                    + '&comApertura=' + comApertura
                                    + '&calculoInt=' + calculoInt
                                    + '&tipoCalculoInt=' + tipoCalculoInt
                                    + '&tipoPagCap=' + tipoPagCap
                                    + '&numTransaccion=' + numTransaccion
                                    + '&cobraSeguroCuota=' + cobraSeguroCuota
                                    + '&cobraIVASeguroCuota=' + cobraIVASeguroCuota
                                    + '&montoSeguroCuota=' + montoSeguroCuota
                                    + '&cobraAccesorios='+cobraAccesorios
                                    + '&cobraAccesoriosGen='+cobraAccesoriosGen
                                    + '&convenioNominaID='+convenio;
    window.open(url, '_blank');
}
// ------------------------------------- funcion que bloque la pantalla mientras se simula ----------------------------------- //
function bloquearPantallaAmortizacion() {
    $('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
    $('#contenedorForma').block({
        message: $('#mensaje'),
        css: {
            border: 'none',
            background: 'none'
        }
    });
}
//agrega el scroll al div de simulador de pagos libres de capital
$('#contenedorSimuladorLibre').scroll(function() {});
// ---------------------------------------- funcion para validar la fecha -------------------------------------------- //
function esFechaValida(fecha, jcontrol) {
    if (fecha != undefined && fecha.value != Constantes.CADENAVACIA) {
        var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
        if (!objRegExp.test(fecha)) {
            if ($("#" + jcontrol)) mensajeSis("Formato de Fecha No Válido (aaaa-mm-dd).");
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
                };
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
// --------------------------------------------  Cancela las teclas [ ] en el formulario -------------------------------------------- //
document.onkeypress = pulsarCorchete;

function pulsarCorchete(e) {
    tecla = (document.all) ? e.keyCode : e.which;
    if (tecla == 91 || tecla == 93) {
        return false;
    }
    return true;
}
// -------------------------------------- funcion para poner el formato de moneda a un campo --------------------------------------- //
function agregarFormatoMoneda(controlID) {
    var jqControlID = eval("'#" + controlID + "'");
    $(jqControlID).formatCurrency({
        positiveFormat: '%n',
        roundToDecimalPlace: 2
    });
}

function agregaFormatoMonedaGrid(controlID) {
    var jqControlID = eval("'#" + controlID + "'");
    $(jqControlID).formatCurrency({
        positiveFormat: '%n',
        roundToDecimalPlace: 2
    });
}

function fnExitoTransaccion() {
    inicializaVariablesGlabales();
    inicializaValoresPantalla();
    inicializaCamposPantalla();
}

function fnErrorTransaccion() {}
// --------------------------------- Inicializa los valores por default de las variables globales ------------------------------------- //
function inicializaVariablesGlabales() {
    SolicitudCredito = null;
    ProductoCredito = null;
    var_montoSolicitudBase = Constantes.ENTEROCERO;
    var_inicioAfuturo = Constantes.NO;
    var_diasMaximo = Constantes.ENTEROCERO;
    var_productoIDBase = Constantes.ENTEROCERO;
    var_DiaPagoCapital = Constantes.CADENAVACIA;
    var_DiaPagoInteres = Constantes.CADENAVACIA;
}
// ------------------- Valida los campos que se habilitan o deshabilita de acuerdo al estatus de la solicitud de credito --------------- //
function validaCamposPantalla() {
    var estatusSolici = Constantes.CADENAVACIA;
    if (SolicitudCredito != null) {
        estatusSolici = SolicitudCredito.estatus;
    }
    if (estatusSolici == Constantes.ESTATUSINACTIVO || estatusSolici == Constantes.CADENAVACIA) {
        $('#simular').show();
        if (estatusSolici == Constantes.CADENAVACIA) {
            habilitaBoton('agregar', 'submit');
            deshabilitaBoton('modificar', 'submit');
        } else {
            deshabilitaBoton('agregar', 'submit');
            habilitaBoton('modificar', 'submit');
        }
        if ($("#calendIrregularCheck").is(':checked') == true) {
            deshabilitaControl('tipoPagoCapital');
            deshabilitaControl('frecuenciaCap');
        } else {
            habilitaControl('tipoPagoCapital');
            habilitaControl('frecuenciaCap');
        }
        habilitaControl('creditoID');
        habilitaControl('productoCreditoID');
        habilitaControl('horarioVeri');
        habilitaControl('plazoID');
    }
    // El estatus de la solicitud de credito NO es Inactivo
    else {
        $('#simular').hide();
        deshabilitaBoton('agregar', 'submit');
        deshabilitaBoton('modificar', 'submit');
        deshabilitaControl('creditoID');
        deshabilitaControl('productoCreditoID');
        deshabilitaControl('institucionNominaID');
        deshabilitaControl('folioCtrl');
        deshabilitaControl('horarioVeri');
        deshabilitaControl('fechaInicioAmor');
        $("#fechaInicioAmor").datepicker("destroy");
        deshabilitaControl('plazoID');
        deshabilitaControl('tipoPagoCapital');
        deshabilitaControl('calendIrregularCheck');
        deshabilitaControl('frecuenciaInt');
        deshabilitaControl('frecuenciaCap');
        deshabilitaControl('diaPagoInteres1');
        deshabilitaControl('diaPagoInteres2');
        deshabilitaControl('diaPagoCapital1');
        deshabilitaControl('diaPagoCapital2');
        deshabilitaControl('diaMesInteres');
        deshabilitaControl('diaMesCapital');
        deshabilitaControl('numAmortInteres');
        deshabilitaControl('numAmortizacion');
    }
    deshabilitaControl('comentarioEjecutivo');
    agregaFormatoControles('formaGenerica');
}
// Inicializa los valores de la pantalla para dar de alta una nueva solicitud de credito (selecciona los valores por default en algunos campos) //
function inicializaValoresNuevaSolicitud() {
    inicializaForma('formaGenerica', 'solicitudCreditoID');
    $('#fechaRegistro').val(parametroBean.fechaAplicacion);
    $('#fechaInicioAmor').val(parametroBean.fechaAplicacion);
    $('#fechaInicio').val(parametroBean.fechaAplicacion);
    $("#monedaID").val(Constantes.MONEDAPESOS).selected = true;
    $("#estatus").val(Constantes.ESTATUSINACTIVO).selected = true;
    dwr.util.removeAllOptions('plazoID');
    $('#plazoID').append(new Option('SELECCIONAR', "", true, true));
    dwr.util.removeAllOptions('tipoPagoCapital');
    $('#tipoPagoCapital').append(new Option('SELECCIONAR', "", true, true));
    dwr.util.removeAllOptions('frecuenciaInt');
    $('#frecuenciaInt').append(new Option('SELECCIONAR', "", true, true));
    dwr.util.removeAllOptions('frecuenciaCap');
    $('#frecuenciaCap').append(new Option('SELECCIONAR', "", true, true));
    $("#tipoCalInteres").val('0').selected = true;
    $("#calcInteresID").val('0').selected = true;
    $("#clasificacionDestin1").attr('checked', false);
    $("#clasificacionDestin2").attr('checked', false);
    $("#clasificacionDestin3").attr('checked', false);
    $("#fechInhabil1").attr('checked', true);
    $("#calendIrregularCheck").attr('checked', false);
    $("#diaPagoInteres1").attr('checked', true);
    $("#diaPagoCapital1").attr('checked', true);
    habilitaControl('creditoID');
    $("#creditoID").focus();
    // SEGUROS
    $('#cobraSeguroCuota').val('N').selected = true;
    $('#cobraIVASeguroCuota').val('N').selected = true;
    $('#montoSeguroCuota').val('');
    habilitaBoton('agregar', 'submit');
    dwr.util.removeAllOptions('sobreTasa');
    dwr.util.addOptions('sobreTasa', {
        "": 'SELECCIONAR'
    });
    $('#fieldServicioAdic').hide();
}
// ----------------- Inicializa los valores de la pantalla (selecciona los valores por default en algunos campos) -------------------- //
function inicializaValoresPantalla() {
    inicializaForma('formaGenerica', 'solicitudCreditoID');
    dwr.util.removeAllOptions('plazoID');
    $('#plazoID').append(new Option('SELECCIONAR', "", true, true));
    dwr.util.removeAllOptions('tipoPagoCapital');
    $('#tipoPagoCapital').append(new Option('SELECCIONAR', "", true, true));
    dwr.util.removeAllOptions('frecuenciaInt');
    $('#frecuenciaInt').append(new Option('SELECCIONAR', "", true, true));
    dwr.util.removeAllOptions('frecuenciaCap');
    $('#frecuenciaCap').append(new Option('SELECCIONAR', "", true, true));
    $('#sucursalID').val(parametroBean.sucursal);
    sucursalUsu = parametroBean.sucursal;
    $("#monedaID").val('0').selected = true;
    $("#estatus").val('0').selected = true;
    $("#tipoCalInteres").val('0').selected = true;
    $("#calcInteresID").val('0').selected = true;
    $("#clasificacionDestin1").attr('checked', false);
    $("#clasificacionDestin2").attr('checked', false);
    $("#clasificacionDestin3").attr('checked', false);
    $("#fechInhabil1").attr('checked', true);
    $("#calendIrregularCheck").attr('checked', false);
    $("#diaPagoInteres1").attr('checked', true);
    $("#diaPagoCapital1").attr('checked', true);
    dwr.util.removeAllOptions('convenioNominaID');
    dwr.util.addOptions('convenioNominaID', {
        "": 'SELECCIONAR'
    });
    $('#convenios').hide();
    limpiarServiciosAdicionales();
}
// ---------------------- Inicializa los campos de la pantalla (habilita/deshabilita, oculta/muestra) -------------------------- //
function inicializaCamposPantalla() {
    agregaFormatoControles('formaGenerica');
    $("#liberar").hide();
    $("#trNomina").hide();
    $('#simular').show();
    $('#contenedorSimulador').hide();
    $("#contenedorSimuladorLibre").hide();
    $("#comentarios").hide();
    $("#comentariosEjecutivo").hide();
    $("#separa").hide();
    $("#comentarios").hide();
    habilitaControl('creditoID');
    habilitaControl('productoCreditoID');
    habilitaControl('horarioVeri');
    habilitaControl('plazoID');
    deshabilitaControl('fechaInicioAmor');
    $("#fechaInicioAmor").datepicker("destroy");
    deshabilitaControl('cuentaCLABE');
    deshabilitaControl('calendIrregularCheck');
    deshabilitaControl('diaPagoInteres1');
    deshabilitaControl('diaPagoInteres2');
    deshabilitaControl('diaPagoCapital1');
    deshabilitaControl('diaPagoCapital2');
    deshabilitaControl('diaMesInteres');
    deshabilitaControl('diaMesCapital');
    deshabilitaBoton('agregar', 'submit');
    deshabilitaBoton('modificar', 'submit');
    deshabilitaBoton('liberar', 'submit');
    // SEGUROS
    $('#cobraSeguroCuota').val('N').selected = true;
    $('#cobraIVASeguroCuota').val('N').selected = true;
    $('#montoSeguroCuota').val('');
    consultaCambiaPromotor();
}
// ----------------------- Deshabilita permanentemente los campos de la pantalla que nunca se habilitaran -------------------------- //
function deshabilitaCamposPermanente() {
    deshabilitaControl('nombreCte');
    deshabilitaControl('descripProducto');
    deshabilitaControl('fechaRegistro');
    deshabilitaControl('nombrePromotor');
    deshabilitaControl('monedaID');
    deshabilitaControl('estatus');
    deshabilitaControl('nombreSucursal');
    deshabilitaControl('destinoCreID');
    deshabilitaControl('descripDestino');
    deshabilitaControl('destinCredFRID');
    deshabilitaControl('descripDestinoFR');
    deshabilitaControl('destinCredFOMURID');
    deshabilitaControl('descripDestinoFOMUR');
    deshabilitaControl('clasificacionDestin1');
    deshabilitaControl('clasificacionDestin2');
    deshabilitaControl('clasificacionDestin3');
    deshabilitaControl('numCreditos');
    deshabilitaControl('cicloClienteGrupal');
    deshabilitaControl('calificaCredito');
    deshabilitaControl('tipoSolCredito');
    deshabilitaControl('nombreInstit');
    deshabilitaControl('montoSolici');
    deshabilitaControl('montoAutorizado');
    deshabilitaControl('fechaInicio');
    deshabilitaControl('fechaVencimiento');
    deshabilitaControl('porcGarLiq');
    deshabilitaControl('aporteCliente');
    deshabilitaControl('tipoCalInteres');
    deshabilitaControl('calcInteresID');
    deshabilitaControl('tasaBase');
    deshabilitaControl('desTasaBase');
    deshabilitaControl('sobreTasa');
    deshabilitaControl('pisoTasa');
    deshabilitaControl('techoTasa');
    deshabilitaControl('fechInhabil1');
    deshabilitaControl('fechInhabil2');
    deshabilitaControl('periodicidadInt');
    deshabilitaControl('periodicidadCap');
    deshabilitaControl('montoCuota');
    deshabilitaControl('CAT');
}
// ----------------------------- Verifica si esta parametrizado que es posible modificar o no el promotor ---------------------------- //
function consultaCambiaPromotor() {
    if (permiteCambioPromotor == Constantes.NO) {
        deshabilitaControl('promotorID');
    } else {
        // Si el estatus de la solicitud de credito es Inactiva o si se trata de una nueva solicitud, ademas de que permita hacer el cambio de promotor
        if (permiteCambioPromotor == Constantes.SI && ($('#estatus').val() == Constantes.ESTATUSINACTIVO || $('#solicitudCreditoID').val() == Constantes.ENTEROCERO)) {
            habilitaControl('promotorID');
        } else {
            deshabilitaControl('promotorID');
        }
    }
}
//funcion que llena el combo de calcInteres
function consultaComboCalInteres() {
    dwr.util.removeAllOptions('calcInteresID');
    formTipoCalIntServicio.listaCombo(1, function(formTipoCalIntBean) {
        dwr.util.addOptions('calcInteresID', {
            '': 'SELECCIONAR'
        });
        dwr.util.addOptions('calcInteresID', formTipoCalIntBean, 'formInteresID', 'formula');
    });
}

function calculoTotalSeguros() {
    var sumaMontoCapturado = 0;
    var sumaMonto = 0;
    var numero = 0;
    var varCapitalID = "";
    $('input[name=montoSeguroCuotaSim]').each(function() {
        numero = this.id.substr(7, this.id.length);
        numDetalle = $('input[name=montoSeguroCuotaSim]').length;
        varCapitalID = eval("'#montoSeguroCuotaSim" + numero + "'");
        sumaMontoCapturado = sumaMontoCapturado + $(varCapitalID).asNumber();
        sumaMonto = sumaMontoCapturado.toFixed(2);
        $('#totalSeguroCuota').val(sumaMonto);
        $('#totalSeguroCuota').formatCurrency({
            positiveFormat: '%n',
            roundToDecimalPlace: 2
        });
        $(varCapitalID).formatCurrency({
            positiveFormat: '%n',
            roundToDecimalPlace: 2
        });
    });
}
// Funcion que cambia la etiqueta de Tasa Fija Actualizada por Tasa Base Actual
function setCalcInteresID(calcInteres, iniciaCampos) {
    $('#calcInteresID').val(calcInteres);
    if (TasaFijaID == calcInteres) {
        VarTasaFijaoBase = 'Tasa Fija Anualizada';
    } else {
        VarTasaFijaoBase = 'Tasa Base Actual';
    }
    $('#lblTasaFija').text(VarTasaFijaoBase + ': ');
    if (iniciaCampos) {
        limpiaCamposTasaInteres();
    }
    habilitaCamposTasa(calcInteres);
}
// Funcion que limpia los campos de Tasas
function limpiaCamposTasaInteres() {
    $('#tasaBase').val('');
    $('#desTasaBase').val('');
    $('#tasaFija').val('');
    $('#sobreTasa').val('');
    $('#pisoTasa').val('');
    $('#techoTasa').val('');
}
// Funcion que habilita y da formato de tasa dependiendo del calculo de interes
function habilitaCamposTasa(calcInteresID) {
    if (calcInteresID == TasaFijaID) {
        deshabilitaControl('tasaFija');
        deshabilitaControl('pisoTasa');
        deshabilitaControl('tasaBase');
        deshabilitaControl('sobreTasa');
        deshabilitaControl('techoTasa');
    }
    if (calcInteresID == 2 || calcInteresID == 4) {
        deshabilitaControl('tasaFija');
        deshabilitaControl('pisoTasa');
        habilitaControl('tasaBase');
        habilitaControl('sobreTasa');
        deshabilitaControl('techoTasa');
    }
    if (calcInteresID == TasaBasePisoTecho) {
        deshabilitaControl('tasaFija');
        habilitaControl('pisoTasa');
        habilitaControl('tasaBase');
        habilitaControl('sobreTasa');
        habilitaControl('techoTasa');
    }
    $('#tasaFija').formatCurrency({
        positiveFormat: '%n',
        roundToDecimalPlace: 4
    });
    $('#pisoTasa').formatCurrency({
        positiveFormat: '%n',
        roundToDecimalPlace: 4
    });
    $('#sobreTasa').formatCurrency({
        positiveFormat: '%n',
        roundToDecimalPlace: 4
    });
    $('#techoTasa').formatCurrency({
        positiveFormat: '%n',
        roundToDecimalPlace: 4
    });
}
/* Funcion que pone las banderas para que se solicite de nuevo la simulación
 * por cambio en tasas y oculta/limpia los simuladores */
function vuelveaSimular() {
    $("#numTransacSim").val('');
    estatusSimulacion = false;
    $('#contenedorSimulador').html("");
    $('#contenedorSimulador').hide();
    $('#contenedorSimuladorLibre').html("");
    $('#contenedorSimuladorLibre').hide();
}

function javaURLEncode(str) {
    return encodeURI(str).replace(/%20/g, "+").replace(/!/g, "%21").replace(/'/g, "%27").replace(/\(/g, "%28").replace(/\)/g, "%29").replace(/~/g, "%7E");
}

function mostrarLabelTasaFactorMora(tipoFactorMora) {
    if (tipoFactorMora == 'T') {
        $('#lblveces').hide();
        $('#lblTasaFija').show();
    } else if (tipoFactorMora == 'N') {
        $('#lblveces').show();
        $('#lblTasaFija').hide();
    } else {
        $('#lblveces').hide();
        $('#lblTasaFija').hide();
    }
}

function validarEsquemaCobroSeguro() {
    var tipoConPrincipal = 1;
    var productoCreditoID = $('#productoCreditoID').asNumber();
    var frecuenciaInt = $("#frecuenciaInt option:selected").val();
    var frecuenciaCap = $("#frecuenciaCap option:selected").val();
    var mostrarSeguroCuota = $('#mostrarSeguroCuota').val();
    var cobraSeguroCuota = $('#cobraSeguroCuota option:selected').val();
    var esquemaSeguroBean = {
        'producCreditoID': productoCreditoID,
        'frecuenciaCap': frecuenciaCap,
        'frecuenciaInt': frecuenciaInt,
    };
    $('#montoSeguroCuota').val(0);
    if (cobraSeguroCuota == 'S' && mostrarSeguroCuota == 'S') {
        if (productoCreditoID > 0) {
            if (frecuenciaCap != "") {
                if (frecuenciaInt != "") {
                    esquemaSeguroServicio.consulta(esquemaSeguroBean, tipoConPrincipal, {
                        async: false,
                        callback: function(esquemaBean) {
                            if (esquemaBean != null) {
                                $('#montoSeguroCuota').val(esquemaBean.monto);
                            } else {
                                mensajeSis('No Existe Parametrizado el Monto de Seguro Para esta Frecuencia.');
                                $('#montoSeguroCuota').val("");
                                return false;
                            }
                        }
                    });
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
function muestraSeccionSeguroCuota() {
    var con_paramSeccionEsp = 16;
    var parametrosSisCon = {
        'empresaID': 1
    };
    $('#mostrarSeguroCuota').val("N");
    mostrarElementoPorClase('ocultarSeguroCuota', "N");
    parametrosSisServicio.consulta(con_paramSeccionEsp, parametrosSisCon, {
        async: false,
        callback: function(varParamSistema) {
            if (varParamSistema != null) {
                var mostrarSeccionSeguros = varParamSistema.cobraSeguroCuota;
                $('#mostrarSeguroCuota').val(mostrarSeccionSeguros);
                mostrarElementoPorClase('ocultarSeguroCuota', mostrarSeccionSeguros);
                if (mostrarSeccionSeguros == 'N') {
                    $('#cobraSeguroCuota').val('N').selected = true;
                    $('#cobraIVASeguroCuota').val('N').selected = true;
                    $('#montoSeguroCuota').val('0.0');
                }
            } else {
                $('#mostrarSeguroCuota').val("N");
            }
        }
    });
}

function consultaReqValCalend() {
    var numConsulta = 1;
    var paramBean = {
        'empresaID': 1
    };
    parametrosSisServicio.consulta(numConsulta, paramBean, {
        async: false,
        callback: function(parametrosBean) {
            if (parametrosBean != null) {
                validaCalendario = parametrosBean.reestCalendarioVen;
                validaEstatus = parametrosBean.validaEstatusRees;
            }
        }
    });
}

function validaCredito() {
    fechaVencCred = $('#fechaVencimiento').val();
    procedeSubmit = 1;
    if (fechaVencCred < parametroBean.fechaAplicacion && validaCalendario == 'N') {
        procedeSubmit = 1;
        deshabilitaBoton('agregar', 'submit');
        mensajeSis("La Fecha de Vencimiento debe ser Mayor a la Fecha de Inicio.");
        $('#creditoID').focus();
        $('#creditoID').select();
    } else {
        procedeSubmit = 0;
    }
    return procedeSubmit;
}
// ----------------------consulta la tasa base --------------------
function consultaTasaBase(idControl, desdeInput) {
    var jqTasa = eval("'#" + idControl + "'");
    var tasaBase = $(jqTasa).asNumber();
    var TasaBaseBeanCon = {
        'tasaBaseID': tasaBase
    };
    if (tasaBase > 0) {
        tasasBaseServicio.consulta(1, TasaBaseBeanCon, {
            async: false,
            callback: function(tasasBaseBean) {
                if (tasasBaseBean != null) {
                    $('#desTasaBase').val(tasasBaseBean.nombre);
                    valorTasaBase = tasasBaseBean.valor;
                    if (desdeInput) {
                        $('#tasaFija').val($('#sobreTasa').asNumber() + Number(valorTasaBase)).change();
                    }
                    $('#tasaFija').formatCurrency({
                        positiveFormat: '%n',
                        roundToDecimalPlace: 4
                    });
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
    }
}

function validaSobreTasa() {
    var credBeanCon = {
        'sucursalID': $('#sucursalID').val(),
        'productoCreditoID': $('#productoCreditoID').val(),
        'montoInferior': $('#montoSolici').asNumber(),
        'calificacion': $('#calificaCliente').val(),
        'plazoID': $('#plazoID').val(),
        'institNominaID': $('#institucionNominaID').val(),
        'tasaFija': $('#tasaBase').val()
    };
    dwr.util.removeAllOptions('sobreTasa');
    esquemaTasasServicio.listaCombo(2, credBeanCon, {
        async: false,
        callback: function(esquemaTasas) {
            dwr.util.addOptions('sobreTasa', {
                "": 'SELECCIONAR'
            });
            dwr.util.addOptions('sobreTasa', esquemaTasas, 'sobreTasa', 'sobreTasa');
            if (esquemaTasas.length == 1) {
                $('#sobreTasa').val(esquemaTasas[0].sobreTasa);
            }
        }
    });
}

function consultaCobraAccesorios() {
    var tipoConsulta = 24;
    var bean = {
        'empresaID': 1
    };
    paramGeneralesServicio.consulta(tipoConsulta, bean, {
        async: false,
        callback: function(parametro) {
            if (parametro != null) {
                cobraAccesoriosGen = parametro.valorParametro;
            } else {
                cobraAccesoriosGen = 'N';
            }
        }
    });
}

function ClienteEspecifico() {
    var tipoConsulta = 13;
    paramGeneralesServicio.consulta(tipoConsulta, {
        async: false,
        callback: function(valor) {
            if (valor != null) {
                numeroCliente = valor.valorParametro;
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

//Métodos para servicios adicionales
function obtenerServiciosAdicionalesAll(productoCreditoID, institNominaID){

	if(productoCreditoID == '' || isNaN(productoCreditoID)){
		productoCreditoID = '0';
	}

	if(institNominaID == '' || isNaN(institNominaID)){
		institNominaID = '0';
	}

	var servicioAdicionalesBean = {
		'productoCreditoID': productoCreditoID,
		'institucionNominaID': institNominaID
	};
	var tipoConsulta = 2; //por ProductoCreditoID;

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

		var tipoConsulta = 2; //por SolicitudCreditoID;

		setTimeout("$('#cajaLista').hide();", 200);
		//Obtener servicios adicionales que ha registrado
		serviciosSolCredServicio.lista(tipoConsulta, serviciosSolCredBean, function(resultado) {
	    	var desactiva = '';
		    if(resultado != null) {
			    if (estatusSolicitudCredito == 'A'
                    || estatusSolicitudCredito == 'D'
                        || estatusSolicitudCredito == 'L'
                            || estatusSolicitudCredito == 'C') {
			    	 desactiva = 'disabled';
			    }
		    	resultado.forEach(function (elementRegistro){
		    		listaServiciosAdicionales.forEach(function (element){
		    			if (elementRegistro.servicioID == element.ServicioID){
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

//Valida que existan Accesorios parametrizados para el producto de crédito
function validaAccesorios(tipoCon) {
    var valAccesorios = false;
    var paramCon = {};
    paramCon['producCreditoID'] = $('#productoCreditoID').val();
    if (tipoCon == tipoConAccesorio.producto) {
        creditosServicio.consulta(tipoCon, paramCon, {
            async: false,
            callback: function(accesorios) {
                if (accesorios != null) {
                    valAccesorios = true;
                }
            }
        });
    } else if (tipoCon == tipoConAccesorio.plazo) {
        paramCon['plazoID'] = $('#plazoID').val();
        paramCon['montoPorDesemb'] = $('#montoSolici').asNumber();
        paramCon['convenioNominaID'] = $('#convenioNominaID').val();
        paramCon['cicloCliente'] = $('#numCreditos').asNumber();
        creditosServicio.consulta(tipoCon, paramCon, {
            async: false,
            callback: function(accesorios) {
                if (accesorios != null) {
                    valAccesorios = true;
                }
            }
        });
    }
    return valAccesorios;
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

			if (parseInt(numRegistros) > 0){
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

  //Función consulta el total de creditos en la lista
    function consultaFilasAccesorios() {
        var totales = 0;
        $('tr[name=renglonAccesorio]').each(function() {
            totales++;

        });
        return totales;
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


            agregaFormatoMonedaGrid(jqIdChecked);
        });

        $("input[name=montoIVAAccesorio]").each(function(i) {
            var numero = this.id.replace(/\D/g,'');
            var jqIdChecked = eval("'montoIVAAccesorio" + numero + "'");


            agregaFormatoMonedaGrid(jqIdChecked);
        });

    }


}
