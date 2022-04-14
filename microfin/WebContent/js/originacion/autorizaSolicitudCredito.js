var huellaProductos = '';
var catFormTipoCalInt = { 
		'principal'	: 1,
};
var catTipoConsultaInstitucion = {
		'principal':1 
};
var catTipoNomCapacidadPagoSol = {
		'principal':1,
		'capacidadPago':2
};

var manejaCapacidadPago = "N";

var TasaFijaID = 1; // ID de la formula para tasa fija (FORMTIPOCALINT)
var TasaBasePisoTecho = 3; // ID de la formula para tasa base con piso y techo (FORMTIPOCALINT)
var InstitucionNominaID =0;
var ConvenioNominaID =0;
var SucursalID =0;
var QuinquenioID =0;
var ClienteID=0;
var manejaConvenio = 'N';
var noSeguirPro = false;
var var_instruccionesDispersion = "N";
var var_instrucccionesEstatus = "";


listaPersBloqBean = {
		'estaBloqueado'	:'N',
		'coincidencia'	:0
};

consultaSPL = {
		'opeInusualID' : 0,
		'numRegistro' : 0,
		'permiteOperacion' : 'S',
		'fechaDeteccion' : '1900-01-01'
};

var esCliente 			='CTE';

$(document).ready(function() {
    

    consultaManejaConvenios();
    
    listaCatQuinquenios();
    
    var SiPermiteProspecto = 'S';
    var var_permiteProspecto    ='N';

    $("#solicitudCreditoID").focus();

    esTab = true;
    //Definicion de Constantes y Enums
    var catTipoConsultaSolicitud = {
        'principal':1,
        'foranea':2,
        'checklist':6
    };

    var catTipoTranSolicitud = {
        'agrega': 1,
        'modifica': 2,
        'actualiza': 3
    };

    var catTipoActSolicitud = {
        'autoriza':1,
        'regresaEjec':3,
        'rechazo':4

    };

    var catTipoLisSolicitud = {
        'principal': 1,
        'gridFirmasAut': 4,
        'gridTodasFirmas': 5
    };

    var Constantes = {
        'ESTATUSLIBERADO': 'L',
        'NO': 'N',
        'INACTIVA': 'I',
        'AUTORIZADA': 'A',
        'CANCELADA': 'C',
        'RECHAZADA': 'R',
        'DESEMBOLSADA': 'D'
    };

    var sucursalPromotor=0;
    var atiendeSucursal='';
    var sucursalSolicitud=0;
    var estatus='';

    $('#fechaAutoriza').attr('disabled','disabled');

    consultaMoneda();
    // llena el combo para la Formula de Calculo de Interés
    consultaComboCalInteres();
    muestraCamposTasa(0);
    var parametroBean = consultaParametrosSession();
    var MontoMaxCre = 0;
    var MontoMinCre = 0;
    //  var PorcenGL =0 ;
    var grupal;

    validaMonitorSolicitud();
    funcionCargaComboMotivosCancelacion();
	funcionCargaMotivosDevolucion();
	

    // ===================================================== Metodos y Manejo de Eventos ========================================================
    deshabilitaBoton('guardarAutoriza', 'submit');
    deshabilitaBoton('guardarRechazo', 'submit');
    deshabilitaBoton('guardarRegresar', 'submit');
    deshabilitaBoton('rechazar', 'submit');
    deshabilitaBoton('regresarEjec', 'submit');
    deshabilitaBoton('autorizar', 'submit');
    validaEmpresaID();
    $('#datosNomina').hide();
    $('#institucionNominaID').val("");
    $('#nombreInstit').val("");
    $('#convenioNominaID').val("");
    $('#desConvenio').val("");
    $('#quinquenios').hide();
    $('#folioSolici').val("");

    $('#trCapacidadPago').show();

    agregaFormatoControles('formaGenerica');
    $(':text').focus(function() {
        esTab = false;
    });

    $(':text').bind('keydown',function(e){
        if (e.which == 9 && !e.shiftKey){
            esTab= true;
        }
    });

    $('#guardarAutoriza').click(function(event) {

        if(parseInt( cuentaSeleccionados()) > 0){
            validaMontoSolicitado(event);
            $('#tipoTransaccion').val(catTipoTranSolicitud.actualiza);
            $('#tipoActualizacion').val(catTipoActSolicitud.autoriza);
            guardarDetalle();
        } else {
            event.preventDefault();
            mensajeSis("Seleccione Firma(s) para Autorizar.");
        }


    });

    $('#solicitudCreditoID').blur(function() {
        if(isNaN($('#solicitudCreditoID').val()) ){
            $('#solicitudCreditoID').val("");
            $('#solicitudCreditoID').focus();
        } else {
            validaSolicitudCredito(this.id);
        }
    });

    $('#solicitudCreditoID').bind('keyup',function(e){
        if(this.value.length >= 0){
            var camposLista = new Array();
            var parametrosLista = new Array();

            camposLista[0] = "clienteID";
            parametrosLista[0] = $('#solicitudCreditoID').val();

            lista('solicitudCreditoID', '1', '9', camposLista, parametrosLista, 'listaSolicitudCredito.htm');
        }
    });

    $('#montoAutorizado').blur(function() {
        if($('#montoAutorizado').asNumber() <= $('#montoSolici').asNumber()){

            var procede = validaMontoSolicitadoCapLibre();
            if (procede == 0) {
                consultaPorcentajeGarantiaLiquida(this.id);

                if($("#estatus").val() == Constantes.ESTATUSLIBERADO){

                    if(manejaConvenio=='S')
                    {
                        if(noSeguirPro!=true){
                       habilitaBoton('autorizar','submit');
                      }else{
                          deshabilitaBoton('autorizar','submit');
                      }
                    }else{
                        habilitaBoton('autorizar','submit');
                    }
                }else{
                    deshabilitaBoton('autorizar','submit');
                }

            }
        }
        else{
            mensajeSis('El Monto Autorizado No Puede ser Mayor al Monto Solicitado.');
            $('#montoAutorizado').focus();
            $('#montoAutorizado').val('');
            $('#gridComentariosAutoriza').hide();
            deshabilitaBoton('autorizar', 'submit');
        }
    });

    $('#rechazar').click(function() {
        $('#comentarioEjecutivo').val('');
        $('#comentarioMesaControl').val('');

        $('#eComentario').text('Términos y Condiciones:');

		 $('#motivoRechazoID').val('');
		 		$('#motivoDevolucionID').hide();
		$('#labelMoitvoDevolucion').hide();
		$('#motivoRechazoID').show();
		$('#labelMoitvoCancelacion').show();

        $('#guardarRechazo').show();
        $('#guardarRegresar').hide();
        visualizaGridComentariosRechazoRegreso();

        $('#legendRegreso').text("Rechazar Solicitud");
        $('#legendRegreso').show();
        $("comentarioMesaControl").rules("remove");
    });

    $('#regresarEjec').click(function() {
		 $('#eComentarioi').text('Términos y Condiciones:');
		 $('#comentarioEjecutivo').val('');
		 $('#comentarioMesaControl').val('');
		 
		 $('#motivoDevolucionID').val('');
        $('#guardarRegresar').show();
        $('#guardarRechazo').hide();
        visualizaGridComentariosRechazoRegreso();
        		$('#motivoRechazoID').hide();
		$('#labelMoitvoCancelacion').hide();
		$('#motivoDevolucionID').show();
	    $('#labelMoitvoDevolucion').show();
        $('#legendRegreso').text("Regresar Solicitud a Ejecutivo");
        $('#legendRegreso').show();
        $("#comentarioMesaControl").rules("remove");

    });

    $('#autorizar').click(function(event) {
        $('#comentarioEjecutivo').val('');
        $('#comentarioMesaControl').val('');
        var monAut = $('#montoAutorizado').asNumber();
        var monYaAut = $('#montoA').asNumber();
        
        if ($('#clienteID').asNumber() == 0 && var_permiteProspecto != SiPermiteProspecto) {
            /*Se verifica primero si el producto de credito permite prospecto*/
            event.preventDefault();
            mensajeSis("Para continuar con el proceso de Autorización el Prospecto debe ser Cliente y debe contar con una Cuenta Principal Activa.");

        } else {
            consultaCuenta('clienteID');
            if ($('#montoAutorizado').val() == '') {
                mensajeSis("Especifique el Monto a Autorizar ");
                $('#montoAutorizado').focus();
                $('#montoAutorizado').val('');
                event.preventDefault();
            } else if (monAut > monYaAut && ($('#montoA').asNumber() != 0.0 || $('#montoA').asNumber() != 0.00)) {
                agregaFormatoMoneda('formaGenerica');

                mensajeSis("El Monto no debe ser mayor a "+ $('#montoA').val());
                $('#montoAutorizado').val( $('#montoA').val());
                $('#montoAutorizado').focus();
                $('#montoAutorizado').select();

                event.preventDefault(); 
            }else if (var_instruccionesDispersion == "S" && var_instrucccionesEstatus != "A"){
                 mensajeSis("Falta Autorizar Instrucciones de Dispersión.");
               
                event.preventDefault();
            } else {
                $('#comentarioMesaControl').val('');
                visualizaGridComentariosAutoriza();
            }
        }
    });

    $('#guardarRechazo').click(function(event) {
        var coment = $('#comentarioEjecutivo').val();
        		var motID = $('#motivoRechazoID').val();	

		if(motID == ""){
			mensajeSis("Seleccione Motivo de Cancelacion");
			event.preventDefault();	
		}
        if (coment == "") {
            mensajeSis("El comentario esta Vacío");
            event.preventDefault();
        } else {
            $('#tipoTransaccion').val(catTipoTranSolicitud.actualiza);
            $('#tipoActualizacion').val(catTipoActSolicitud.rechazo);
        }
    });

    $('#guardarRegresar').click(function(event) {
        var coment = $('#comentarioEjecutivo').val();
        var motDevID = $('#motivoDevolucionID').val();	
		if(motDevID == null){
			mensajeSis("Seleccione al menos un Motivo Devolucion");
			event.preventDefault();	
		}
        if (coment == "") {
            mensajeSis("El comentario esta Vacío");
            event.preventDefault();
        } else {
            $('#tipoTransaccion').val(catTipoTranSolicitud.actualiza);
            $('#tipoActualizacion').val(catTipoActSolicitud.regresaEjec);
        }
    });





    // ================================================  Validaciones de la Forma ==========================================================

    $.validator.setDefaults({
        submitHandler: function(event) {
            grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'solicitudCreditoID');
        }
   });

    $('#formaGenerica').validate({
        rules: {
            fechaAutoriza:  {required:true},
            solicitudCreditoID:  {required:true}

            },

        messages: {
            fechaAutoriza: {required:'Especifique Fecha'},
           solicitudCreditoID :{required : 'Especifique la Solicitud de Crédito.'}
        }
    });







    // ==================================================== FUNCIONES Y PROCESOS =====================================================

    function validaMonitorSolicitud() {
        // seccion para validar si la pantalla fue llamada desde la pantalla de Monitor de Solicitud
        if ($('#monitorSolicitud').val() != undefined) {
            var solicitud = $('#numSolicitud').val();
            var sol = "solicitudCreditoID";
            $('#solicitudCreditoID').val(solicitud);
            validaSolicitudCredito(sol);
        }
    }


    function validaSolicitudCredito(idControl) {

            $('#montoA').val('');
        $('#gridComentariosRechazoRegreso').hide();
        $('#gridComentariosAutoriza').hide();
        $('#montoAutorizado').removeAttr('disabled');
        var jqSolicitud = eval("'#" + idControl + "'");
            var solCred = $(jqSolicitud).val();

        setTimeout("$('#cajaLista').hide();", 200);

            if(solCred == ''){
            deshabilitaBoton('guardarAutoriza', 'submit');
            deshabilitaBoton('guardarRechazo', 'submit');
            deshabilitaBoton('guardarRegresar', 'submit');
            deshabilitaBoton('rechazar', 'submit');
            deshabilitaBoton('regresarEjec', 'submit');
            deshabilitaBoton('autorizar', 'submit');
            $('#gridFirmasAutoriza').html('');
            $('#gridFirmasOtorgadas').html('');
            $('#solicitudCreditoID').focus();
            inicializaForma('formaGenerica', 'solicitudCreditoID');
        }

            if(solCred == 0 && esTab && !isNaN(solCred) && solCred != ''){
            deshabilitaBoton('guardarAutoriza', 'submit');
            deshabilitaBoton('guardarRechazo', 'submit');
            deshabilitaBoton('guardarRegresar', 'submit');
            deshabilitaBoton('rechazar', 'submit');
            deshabilitaBoton('regresarEjec', 'submit');
            deshabilitaBoton('autorizar', 'submit');
            $('#gridFirmasAutoriza').html('');
            $('#gridFirmasOtorgadas').html('');
            mensajeSis("La Solicitud de Crédito No Existe.");
            $('#solicitudCreditoID').focus();
            $('#solicitudCreditoID').val('');
            inicializaForma('formaGenerica', 'solicitudCreditoID');
        }
        if (solCred != '' && !isNaN(solCred) && esTab && solCred != '0') {
            var SolCredBeanCon = {
                        'solicitudCreditoID':solCred,
                        'usuario':parametroBean.numeroUsuario
                        };

                    solicitudCredServicio.consulta(catTipoConsultaSolicitud.principal, SolCredBeanCon,{ async: false, callback: function(solicitud) {
                            if(solicitud!=null && solicitud.solicitudCreditoID !=0){

                                    dwr.util.setValues(solicitud);
                    $('#tipoPagoCapital').val(solicitud.tipoPagoCapital);
                    esTab = true;
                    agregaFormatoControles('formaGenerica');
                    estatus = solicitud.estatus;
                    sucursalSolicitud = solicitud.sucursalID;
                    sucursalPromotor = solicitud.sucursalPromotor;
                    atiendeSucursal = solicitud.promAtiendeSuc;
                    grupoID = solicitud.grupoID;
                    InstitucionNominaID = solicitud.institucionNominaID;
                    ConvenioNominaID = solicitud.convenioNominaID;
                    SucursalID = solicitud.sucursalID;
                    QuinquenioID = solicitud.quinquenioID;
                    ClienteID = solicitud.clienteID;
                    
                    $('#grupoID').val(grupoID);
                    $('#institucionNominaID').val(solicitud.institucionNominaID);
                    $('#convenioNominaID').val(solicitud.convenioNominaID);
                    $('#folioSolici').val(solicitud.folioSolici);
                    $('#quinquenioID').val(solicitud.quinquenioID);
                    
                    consultaGrupo(grupoID);
                    consultaProspecto('prospectoID');
                    consultaProducCredito('productoCreditoID');
                    
                    consultaPromotor('promotorID');
                    consultaCliente('clienteID');
                    consultaDestinoCredito('destinoCreID', solicitud.convenioID );
                    consultaPlazos(solicitud.plazoID, solicitud.plazoID);
                    $('#tipoCredito').val(solicitud.tipoCredito).selected = true;
                    $('#monedaID').val(solicitud.monedaID).selected = true;
                    
                    consultaSucursal('sucursalID');
                                    $('#montoSolici').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
                    muestraCamposTasa(solicitud.calcInteresID);
                    if (solicitud.estatus == 'I' || solicitud.estatus == 'L') {
                        $('#fechaAutoriza').val(parametroBean.fechaAplicacion);
                    } else {
                        $('#fechaAutoriza').val(solicitud.fechaAutoriza);
                    }
                    consultaFirmasSolGrid();
                    consultaFirmasOtorgadasSolGrid();
                    consultaFirmasAutorizarSolGrid();
                    consultaHuellaCliente();
                    if (solicitud.comentarioEjecutivo != null) {
                        $('#comentarioAltaSolicitud').show();
                        $('#comentariosEje').val(solicitud.comentarioEjecutivo);

                                    }else if (solicitud.comentarioEjecutivo = " ") {
                        $('#comentarioAltaSolicitud').hide();
                    } else {
                        $('#comentarioAltaSolicitud').hide();
                    }

					if(solicitud.institucionNominaID > 0 && solicitud.convenioNominaID > 0){
						if(manejaCapacidadPago == 'S'){
							validaNomCapacidadPagoSolServicio('solicitudCreditoID');
							$('#trCapacidadPago').show();
						}
					}else{
						$('#trCapacidadPago').hide();
					}

                     var montoAutorizado=solicitud.montoAutorizado;   //se guarda el monto en un campo oculto para compararlo despues
                                  $('#montoA').val(montoAutorizado);


                                  if((estatus == Constantes.ESTATUSLIBERADO && sucursalSolicitud == sucursalPromotor) || (estatus == Constantes.ESTATUSLIBERADO && atiendeSucursal == Constantes.NO)){
                                      if(manejaConvenio=='S'){
                                          if(noSeguirPro!=true){
                                            
                                                habilitaBoton('guardarAutoriza', 'submit');
                                                habilitaBoton('guardarRechazo', 'submit');
                                                habilitaBoton('guardarRegresar', 'submit');
                                                habilitaBoton('rechazar', 'submit');
                                                habilitaBoton('regresarEjec', 'submit');
                                                habilitaBoton('autorizar', 'submit');
                                                consultaEstado();
                                          }else
                                              {
                                                 
                                                deshabilitaBoton('guardarAutoriza', 'submit');
                                                deshabilitaBoton('guardarRechazo', 'submit');
                                                deshabilitaBoton('guardarRegresar', 'submit');
                                                deshabilitaBoton('rechazar', 'submit');
                                                deshabilitaBoton('regresarEjec', 'submit');
                                                deshabilitaBoton('autorizar', 'submit');
                                              }
                                          
                                      }
                                      else{
                                        habilitaBoton('guardarAutoriza', 'submit');
                                        habilitaBoton('guardarRechazo', 'submit');
                                        habilitaBoton('guardarRegresar', 'submit');
                                        habilitaBoton('rechazar', 'submit');
                                        habilitaBoton('regresarEjec', 'submit');
                                        habilitaBoton('autorizar', 'submit');
                                        consultaEstado();
                                        }
                                        
                                 }else{

                        deshabilitaBoton('guardarAutoriza', 'submit');
                        deshabilitaBoton('guardarRechazo', 'submit');
                        deshabilitaBoton('guardarRegresar', 'submit');
                        deshabilitaBoton('rechazar', 'submit');
                        deshabilitaBoton('regresarEjec', 'submit');
                                        deshabilitaBoton('autorizar', 'submit');
                                        $('#solicitudCreditoID').focus();



                         if(sucursalSolicitud != sucursalPromotor && estatus == Constantes.ESTATUSLIBERADO){
                            mensajeSis("La Solicitud no pertenece a la Sucursal");
                        }
                        if (estatus == Constantes.INACTIVA) {
                            mensajeSis("La Solicitud de Crédito debe tener Estatus Liberada.");
                        }
                        if (estatus == Constantes.AUTORIZADA) {
                            mensajeSis("La Solicitud de Crédito se encuentra Autorizada.");
                        }
                        if (estatus == Constantes.CANCELADA) {
                            mensajeSis("La Solicitud de Crédito se encuentra Cancelada.");
                        }
                        if (estatus == Constantes.RECHAZADA) {
                            mensajeSis("La Solicitud de Crédito se encuentra Rechazada.");
                        }
                        if (estatus == Constantes.DESEMBOLSADA) {
                            mensajeSis("La Solicitud de Crédito se encuentra Desembolsada.");
                        }

                                    }


                            }else{
                    deshabilitaBoton('guardarAutoriza', 'submit');
                    deshabilitaBoton('guardarRechazo', 'submit');
                    deshabilitaBoton('guardarRegresar', 'submit');
                    deshabilitaBoton('rechazar', 'submit');
                    deshabilitaBoton('regresarEjec', 'submit');
                    deshabilitaBoton('autorizar', 'submit');
                    $('#gridFirmasAutoriza').html('');
                    $('#gridFirmasOtorgadas').html('');
                    mensajeSis("La Solicitud de Crédito No Existe.");
                    $('#solicitudCreditoID').focus();
                    inicializaForma('formaGenerica', 'solicitudCreditoID');
                }
            }});
        }
    }



        function consultaGrupo(grupoID) {
            var numGrupo = grupoID;
            var tipConGrupo= 1;
        var grupoBean = {
            'grupoID': numGrupo
        };
        if (numGrupo != 0) {
            gruposCreditoServicio.consulta(tipConGrupo, grupoBean, function(grupo) {
                if (grupo != null) {
                    $('#tdGrupolbl').show();
                    $('#tdGrupo').show();
                    $('#nomGrupo').val(grupo.nombreGrupo);
                }
            });
            }else
            {

            $('#tdGrupolbl').hide();
                $('#tdGrupo').hide();

        }
    }




        function consultaMoneda() {
            dwr.util.removeAllOptions('monedaID');

            dwr.util.addOptions('monedaID', {0:'SELECCIONAR'});
            monedasServicio.listaCombo(3, function(monedas){
            dwr.util.addOptions('monedaID', monedas, 'monedaID', 'descripcion');
        });
    }


    function consultaCliente(idControl) {
        var jqCliente = eval("'#" + idControl + "'");
            var numCliente = $(jqCliente).val();
            var tipConPrincipal = 1;
            setTimeout("$('#cajaLista').hide();", 200);

            if(numCliente != '' && !isNaN(numCliente) && esTab){
                clienteServicio.consulta(tipConPrincipal,numCliente,function(cliente) {
                            if(cliente!=null){
                            	listaPersBloqBean = consultaListaPersBloq(numCliente, esCliente, 0, 0);
								consultaSPL = consultaPermiteOperaSPL(numCliente,'LPB',esCliente);
								if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
                                $('#clienteID').val(cliente.numero) ;
                    $('#nombreCte').val(cliente.nombreCompleto);
                    $('#pagaIVACte').val(cliente.pagaIVA);
                    $('#sucursalCte').val(cliente.sucursalOrigen);
                    if (cliente.estatus == "I") {
                        $('#estatusCliente').val(cliente.estatus);
                        deshabilitaBoton('autorizar', 'submit');
                        deshabilitaBoton('regresarEjec', 'submit');
                        deshabilitaBoton('rechazar', 'submit');
                        mensajeSis("El Cliente se encuentra Inactivo.");
                    } else {
                        $('#estatusCliente').val('');
                    }
								}else{
									mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
									 deshabilitaBoton('guardarAutoriza', 'submit');
				                    deshabilitaBoton('guardarRechazo', 'submit');
				                    deshabilitaBoton('guardarRegresar', 'submit');
				                    deshabilitaBoton('rechazar', 'submit');
				                    deshabilitaBoton('regresarEjec', 'submit');
				                    deshabilitaBoton('autorizar', 'submit');
				                    $('#gridFirmasAutoriza').html('');
				                    $('#gridFirmasOtorgadas').html('');
				                    $('#solicitudCreditoID').focus();
				                    inicializaForma('formaGenerica', 'solicitudCreditoID');
								}
                } else {
                    $('#nombreCte').val('');
                    var cte = $('#clienteID').val();
                    if (cte != '0') {
                        mensajeSis("Cliente No Valido");
                        $('#clienteID').focus();
                        $('#clienteID').select();
                    }
                }
            });
        }
    }

	function validaNomCapacidadPagoSolServicio(idControl) {
		var jqInstitucion  = eval("'#" + idControl + "'");
		var solicitudCreditoID = $(jqInstitucion).val();
		var nomCapacidadPagoSolBean = {
			'solicitudCreditoID': solicitudCreditoID
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(solicitudCreditoID == '' || solicitudCreditoID==0){
			$('#capacidadPago').val('0.0');
		}
		else
			if(solicitudCreditoID != '' && !isNaN(solicitudCreditoID) ){
				nomCapacidadPagoSolServicio.consulta(catTipoNomCapacidadPagoSol.capacidadPago,nomCapacidadPagoSolBean,function(nomCapacidadPagoSolBean) {
					if(nomCapacidadPagoSolBean !=null){
						$('#capacidadPago').val(nomCapacidadPagoSolBean.capacidadPago); 
					}else{
						mensajeSis("El Número de Solicitud de Crédito No tiene Descuento de Capacidad de Pago.");
						$('#capacidadPago').val('0.00');
					}
				});
			}
	}

        function consultaProducCredito(idControl) {
        var jqProdCred = eval("'#" + idControl + "'");
        var ProdCred = $(jqProdCred).val();
        var ProdCredBeanCon = {
            'producCreditoID':ProdCred
        };
        setTimeout("$('#cajaLista').hide();", 200);

            if(ProdCred != '' && !isNaN(ProdCred) && esTab){
                productosCreditoServicio.consulta(catTipoConsultaSolicitud.principal,ProdCredBeanCon,{async: false, callback:function(prodCred) {
                    if(prodCred!=null){
                        esTab=true;
                        var_permiteProspecto=prodCred.permiteAutSolPros;
                        var_instruccionesDispersion=prodCred.instruDispersion;
                        if (var_instruccionesDispersion == "S"){
                            obtienestatusdispercion();
                        }  

                    $('#descripProducto').val(prodCred.descripcion);
                    $('#factorMora').val(prodCred.factorMora);
                    $('#calcInteresID').val(prodCred.calcInteres);
                    if(prodCred.productoNomina=="S") {
                        if(manejaConvenio=='S'){
                        $('#datosNomina').show();
                        consultaNomInstit();
                        $('#quinquenios').show();
                        consultaConvenioNomina();
                        }else{
                            $('#datosNomina').hide();
                            $('#quinquenios').hide();
                        }
                        
                    }else{
                        $('#datosNomina').hide();
                        $('#institucionNominaID').val("");
                        $('#nombreInstit').val("");
                        $('#convenioNominaID').val("");
                        $('#desConvenio').val("");
                        $('#quinquenios').hide();
                        $('#folioSolici').val("");
                        dwr.util.removeAllOptions('quinquenioID');
                        dwr.util.addOptions('quinquenioID',{'':'SELECCIONAR'});
                        manejaCapacidadPago = "N";
                    }

                    if (prodCred.calcInteres == 1) {
                        deshabilitaControl('calcInteresID');
                        deshabilitaControl('tasaFija');
                        deshabilitaControl('pisoTasa');
                        deshabilitaControl('tasaBase');
                        deshabilitaControl('sobreTasa');
                        deshabilitaControl('techoTasa');
                    }
                    MontoMaxCre = prodCred.montoMaximo;
                    MontoMinCre = prodCred.montoMinimo;

                    grupal = prodCred.esGrupal;
                    if (grupal == 'S') {
                        if (grupoID == 0) {
                            mensajeSis("La Solicitud No Pertenece a un Grupo.");
                        }
                    }
                } else {
                    mensajeSis("No Existe el Producto de Crédito.");
                    $('#producCreditoID').focus();
                    $('#producCreditoID').select();
                }
            }});
        }
    }


        // funcion que llena el combo de plazos, de acuerdo al producto  se usa cuando se consulta un credito
    function consultaPlazos(varPlazos, plazoValor) {
        // se eliminan los tipos de pago que se tenian
        $('#plazoID').each(function() {
            $('#plazoID option').remove();
        });
        if (varPlazos != null) {
            var plazo = varPlazos.split(',');
            var tamanio = plazo.length;
            plazosCredServicio.listaCombo(3, function(plazoCreditoBean) {
                for (var i = 0; i < tamanio; i++) {
                    for (var j = 0; j < plazoCreditoBean.length; j++) {
                        if (plazo[i] == plazoCreditoBean[j].plazoID) {
                            $('#plazoID').append(new Option(plazoCreditoBean[j].descripcion, plazo[i], true, true));
                            $('#plazoID').val(plazoValor).selected = true;
                            break;
                        }
                    }
                }
            });
        }
    }


    function consultaPromotor(idControl) {
        var jqPromotor = eval("'#" + idControl + "'");
        var numPromotor = $(jqPromotor).val();
        var tipConForanea = 2;
        var promotor = {
            'promotorID': numPromotor
        };
        setTimeout("$('#cajaLista').hide();", 200);
            if (numPromotor != '' && !isNaN(numPromotor ) && esTab) {
                if(numPromotor!='0'){
                promotoresServicio.consulta(tipConForanea,
                        promotor, function(promotor){
                            if (promotor != null){
                        $('#nombrePromotor').val(promotor.nombrePromotor);
                    } else {
                        $('#nombrePromotor').val('');
                        mensajeSis("No Existe el Promotor.");
                    }
                });
            } else {
                $('#nombrePromotor').val('');
            }
        }
    }

    function consultaDestinoCredito(idControl, convenioID) {
        var jqDestino = eval("'#" + idControl + "'");
        var DestCred = $(jqDestino).val();
        var DestCredBeanCon = {
            'destinoCreID': DestCred
        };
        setTimeout("$('#cajaLista').hide();", 200);
        if (DestCred != '' && !isNaN(DestCred) && esTab) {
            destinosCredServicio.consulta(catTipoConsultaSolicitud.principal, DestCredBeanCon, function(destinos) {
                if (destinos != null) {
                    $('#descripDestino').val(destinos.descripcion);

                        }else{
                    mensajeSis("No Existe el Destino de Crédito.");
                    $('#destinoCreID').focus();
                    $('#destinoCreID').select();
                }
            });
        }
    }


    function consultaSucursal(idControl) {
        var jqSucursal = eval("'#" + idControl + "'");
        var numSucursal = $(jqSucursal).val();
        var conSucursal = 2;
        setTimeout("$('#cajaLista').hide();", 200);
        if (numSucursal != '' && !isNaN(numSucursal) && esTab) {
            sucursalesServicio.consultaSucursal(conSucursal, numSucursal, function(sucursal) {
                if (sucursal != null) {
                    $('#nombreSucursal').val(sucursal.nombreSucurs);
                } else {
                    mensajeSis("No Existe la Sucursal");
                }
            });
        }
    }

    function consultaProspecto(idControl) {
        var jqProspecto = eval("'#" + idControl + "'");
        var numProspecto = $(jqProspecto).val();
        setTimeout("$('#cajaLista').hide();", 200);

            var prospectoBeanCon ={
            'prospectoID' : numProspecto
            };

        if (numProspecto != '' && !isNaN(numProspecto) && esTab) {
            prospectosServicio.consulta(1, prospectoBeanCon, function(prospectos) {
                if (prospectos != null) {
                    $('#nombreProspecto').val(prospectos.nombreCompleto);
                } else {
                    $('#nombreProspecto').val('');
                    var prospec = $('#prospectoID').val();
                    if (prospec != '0') {
                        mensajeSis("No Existe el Prospecto.");
                        $('#prospectoID').focus();
                        $('#prospectoID').select();
                    }
                }
            });

        }
    }

    function validaMontoSolicitado(event) {
        var montoAutor = $('#montoAutorizado').asNumber();
        if (montoAutor > MontoMaxCre) {
            $('#montoProd').val(MontoMaxCre);
                $('#montoProd').formatCurrency({    positiveFormat: '%n', negativeFormat: '%n',  roundToDecimalPlace: 2 });
            var MontFormat = $('#montoProd').val();
            mensajeSis('El Monto Autorizado No debe ser Mayor a $' + MontFormat);
            $('#montoAutorizado').val('0.00');
            $('#montoAutorizado').select();
            event.preventDefault();
        }
        if (montoAutor < MontoMinCre) {
            $('#montoProd').val(MontoMinCre);
                $('#montoProd').formatCurrency({    positiveFormat: '%n', negativeFormat: '%n',  roundToDecimalPlace: 2 });
            var MontFormat = $('#montoProd').val();
            mensajeSis('El Monto Autorizado No debe ser Menor a $' + MontFormat);
            $('#montoAutorizado').val('0.00');
            $('#montoAutorizado').select();
            event.preventDefault();
        }

      }



    // consulta las firmas pendientes a autorizar
    function consultaFirmasAutorizarSolGrid() {
        $('#gridFirmasAutoriza').html('');
        $('#detalleFirmasAutoriza').val("");

        var params = {};
        params['tipoLista'] = catTipoLisSolicitud.gridFirmasAut;
        params['solicitudCreditoID'] = $('#solicitudCreditoID').val();
        params['productoCreditoID'] = $('#productoCreditoID').val();
        params['usuario'] = parametroBean.numeroUsuario;

        $.post("firmasautorizaSolGridVista.htm", params, function(data){

            if(data.length >0) {
                $('#gridFirmasAutoriza').html(data);
                $('#gridFirmasAutoriza').show();

                    if($('#numero1').val() == undefined ){
                    deshabilitaBoton('guardarAutoriza', 'submit');
                    deshabilitaBoton('autorizar', 'submit');
                    if ($('#nume1').val() == undefined && $('#estatus').val() == "L") {
                        if(manejaConvenio=='S'){
                            if(noSeguirPro!=true){
                            habilitaBoton('rechazar', 'submit');
                            habilitaBoton('regresarEjec', 'submit');
                            habilitaBoton('guardarRechazo', 'submit');
                            habilitaBoton('guardarRegresar', 'submit');
                            }else{
                                deshabilitaBoton('rechazar', 'submit');
                                deshabilitaBoton('regresarEjec', 'submit');
                                deshabilitaBoton('guardarRechazo', 'submit');
                                deshabilitaBoton('guardarRegresar', 'submit');
                            }
                        }else{
                            habilitaBoton('rechazar', 'submit');
                            habilitaBoton('regresarEjec', 'submit');
                            habilitaBoton('guardarRechazo', 'submit');
                            habilitaBoton('guardarRegresar', 'submit');
                        }
                    }
                }
                consultaEstado();
                //si no hay resultados se oculta el grid
                var numFilas = consultaFilas();
                if (numFilas == 0) {
                    $('#gridFirmasAutoriza').html("");
                    $('#gridFirmasAutoriza').show();
                }
            } else {
                $('#gridFirmasAutoriza').html("");
                $('#gridFirmasAutoriza').show();
            }
        });
    }

      // consulta las firmas otorgadas
      function consultaFirmasOtorgadasSolGrid(){
        $('#gridFirmasOtorgadas').html('');

            var params = {};
        params['tipoLista'] = catTipoLisSolicitud.principal;
        params['solicitudCreditoID'] = $('#solicitudCreditoID').val();
        params['productoCreditoID'] = $('#productoCreditoID').val();
        params['usuario'] = parametroBean.numeroUsuario;

            $.post("firmasautorizadasSolGridVista.htm", params, function(data){

                if(data.length >0) {
                    $('#gridFirmasOtorgadas').html(data);
                $('#gridFirmasOtorgadas').show();

                    var numRenglones= consultaRenglones();
                    if(numRenglones==0){
                    $('#gridFirmasOtorgadas').html("");
                    $('#gridFirmasOtorgadas').show();
                }
            } else {
                $('#gridFirmasOtorgadas').html("");
                $('#gridFirmasOtorgadas').show();
            }
        });
    }



    // consulta las todas firmas requeridas por producto para validar si el esquema esta parametrizado
      function consultaFirmasSolGrid(){

            var params = {};
        params['tipoLista'] = catTipoLisSolicitud.gridTodasFirmas; // 5
        params['solicitudCreditoID'] = $('#solicitudCreditoID').val();
        params['productoCreditoID'] = $('#productoCreditoID').val();
        params['usuario'] = parametroBean.numeroUsuario;

            $.post("firmasautorizaSolGridVista.htm", params, function(data){

                if(data.length >0) {
                    $('#gridFirmas').html(data);

                    if($('#nume1').val() == undefined ){
                    mensajeSis("La Solicitud de Crédito no tiene un Esquema de Autorización Parametrizado.");
                    deshabilitaBoton('guardarAutoriza', 'submit');
                    deshabilitaBoton('autorizar', 'submit');
                }
                }else{

                }
            });

        }


     function guardarDetalle(){
        var numDetalle = $('input[name=numero]').length;
        $('#detalleFirmasAutoriza').val("");
            for(var i = 1; i <= numDetalle; i++){

                var checkFirma= eval("'#checkFirma" +i+ "'");

                if(i == 1 && ($(checkFirma).is(':checked')) == true){

                $('#detalleFirmasAutoriza').val($('#detalleFirmasAutoriza').val() +
                                            document.getElementById("esquema"+i+"").value + ']' +
                                            document.getElementById("numeroFirm"+i+"").value + ']' +
                                            document.getElementById("organoA"+i+"").value);


                }else{
                    if(($(checkFirma).is(':checked')) == true){
                        $('#detalleFirmasAutoriza').val($('#detalleFirmasAutoriza').val() + '[' +
                                            document.getElementById("esquema"+i+"").value + ']' +
                                            document.getElementById("numeroFirm"+i+"").value + ']' +
                                            document.getElementById("organoA"+i+"").value);
                    }
                }
    }

      }


    // muestra el grid de datos requeridos cuando se rechaza o se regresa a ejecutivo  una solicitud de credito
    function visualizaGridComentariosRechazoRegreso() {
        $('#gridComentariosRechazoRegreso').show();
        $('#gridComentariosAutoriza').hide();
    }

    function visualizaGridComentariosAutoriza() {
        $('#gridComentariosRechazoRegreso').hide();
        $('#gridComentariosAutoriza').show();
    }

    function consultaCuenta(idControl) {
        var jqCliente = eval("'#" + idControl + "'");
        var numProspecto = $('#prospectoID').val();
        var numCliente = $(jqCliente).val();
        var numClienteBean = {
            'clienteID': numCliente
        };
        var tipoConsulta = 15;
        setTimeout("$('#cajaLista').hide();", 200);
        if (Number(numCliente) > 0 && Number(numProspecto) == 0) {
            cuentasAhoServicio.consultaCuentasAho(tipoConsulta, numClienteBean, function(cuenta) {
                if (cuenta == null) {
                    mensajeSis('El Cliente debe de tener una Cuenta Principal Activa.');
                    $('#gridComentariosAutoriza').hide();
                }

            });
        }
    }

    // función para consultar si el cliente ya tiene huella digital registrada
    function consultaHuellaCliente() {
        var numCliente = $('#clienteID').val();
        if (numCliente != '' && !isNaN(numCliente)) {
            var clienteIDBean = {
                'personaID': $('#clienteID').val()
            };
            huellaDigitalServicio.consulta(1, clienteIDBean, function(cliente) {
                if (cliente == null) {
                    var huella = parametroBean.funcionHuella;
                    if (huella == "S" && huellaProductos == "S") {
                        mensajeSis("El cliente no tiene Huella Registrada.\nFavor de Verificar.");
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
            'empresaID': numEmpresaID
        };
        parametrosSisServicio.consulta(tipoCon, ParametrosSisBean, function(parametrosSisBean) {
            if (parametrosSisBean != null) {
                if (parametrosSisBean.reqhuellaProductos != null) {
                    huellaProductos = parametrosSisBean.reqhuellaProductos;
                } else {
                    huellaProductos = "N";
                }
            }
        });
    }



}); // fin de document

// funcion para no permitir que el monto autorizado sea diferente al solicitado en pagos de capital libre
function validaMontoSolicitadoCapLibre() {
    var procede = 1;
    if ($('#montoAutorizado').asNumber() != $('#montoSolici').asNumber() && $('#montoAutorizado').asNumber() > 0) {
        if ($('#tipoPagoCapital').val() == "L") {
            mensajeSis("La Solicitud tiene Pagos de Capital Libre, \nel monto a Autorizar no puede ser diferente del Solicitado");
            $('#montoAutorizado').val($('#montoSolici').val());
            $('#montoAutorizado').select();
            $('#montoAutorizado').focus();
            procede = 1;
        } else {
            procede = 0;
        }
    } else {
        procede = 0;
    }
    return procede;
}


// habilita boton autorizar
function consultaEstado(){
    var numFilas=consultaFilas();
    var cuenta=cuentaSeleccionados();

    var estatus=$('#estatus').val();
    var estatusCli=$('#estatusCliente').val();
        if(numFilas!=0 && cuenta!=0 && estatus =='L' && estatusCli!='I'){
            if(manejaConvenio=='S'){
                if(noSeguirPro!=true){
                
                 habilitaBoton('autorizar', 'submit');
                }else{
                    deshabilitaBoton('autorizar', 'submit');
                }
            }else{ habilitaBoton('autorizar', 'submit');}

    }
    if (numFilas != 0 && cuenta == 0 && estatusCli == 'I') {
        deshabilitaBoton('autorizar', 'submit');
        if (estatusCli == 'I') {
            mensajeSis("El Cliente se encuentra Inactivo");
        }
    }
}


// consulta cuantas firmas estan seleccionadas para autorizar
function cuentaSeleccionados() {
    var totales = 0;
    $('tr[name=filas]').each(function() {
        var numero= this.id.substr(5,this.id.length);
        var jqIdCredChe = eval("'checkFirma" + numero+ "'");
        if($('#'+jqIdCredChe).attr('checked')==true){
            totales++;

        }
    });
    return totales;

}


// consulta total de filas (frid de firmas para autorizar)
function consultaFilas() {
    var totales = 0;
    $('tr[name=filas]').each(function() {
        totales++;

    });
    return totales;
}


// consulta total de filas (grid de firmas ya autorizadas)
function consultaRenglones() {
    var totales = 0;
    $('tr[name=renglones]').each(function() {
        totales++;

    });
    return totales;
}


function consultaPorcentajeGarantiaLiquida(controlID) {
    var jqControl = eval("'#" + controlID + "'");
    var tipoCon = 5;
    var producCreditoID = $("#productoCreditoID").val();
    var productoCreditoBean = {
            'producCreditoID'   :producCreditoID
    };

    // verifica que el producto de credito en pantalla requiere garantia liquida */
    productosCreditoServicio.consulta(tipoCon, productoCreditoBean, function(respuesta) {
        if (respuesta != null && respuesta.requiereGarantia == 'S') {
            var clienteID = $('#clienteID').val();
            var prospectoID = $('#prospectoID').val();
            var calificaCli = '';
            var monto = $('#montoAutorizado').asNumber();

            // verifica que los datos necesario para la consulta NO esten vacios..
            if (parseInt(producCreditoID) > 0 && (clienteID != '' || prospectoID != '') && parseFloat(monto) > 0) {
                tipoCon = 1;
                if (clienteID == '' || clienteID == '0') {
                    clienteID = prospectoID;
                }
                var bean = {
                    'producCreditoID': producCreditoID,
                    'clienteID': clienteID,
                    'calificacion': calificaCli,
                                'montoSolici'   :monto
                        };

                // obtiene el porcentaje de garantia liquida
                        esquemaGarantiaLiqServicio.consulta(tipoCon,bean,function(respuesta) {
                                    if (respuesta != null) {
                                        var aporte = ((monto*respuesta.porcentaje)/100 );
                                        $('#aporteCliente').val(aporte);
                                        $('#aporteCliente').formatCurrency({    positiveFormat: '%n', negativeFormat: '%n',  roundToDecimalPlace: 2 });
                        $('#gridComentariosAutoriza').hide();
                                    }
                                    else{
                                        $('#aporteCliente').val('0.00');
                                        mensajeSis("No existe un Esquema de Garantía Líquida para el Producto de Crédito, Calificación del cliente y Monto indicado");
                        $(jqControl).focus();
                        $(jqControl).val('');
                    }
                });
            }
        }
        // si el producto de credito no requiere garantia liquida
        else {
            $('#aporteCliente').val('0.00');
        }
    });

}

// Funcion que llena el combo de calcInteres
function consultaComboCalInteres() {
    dwr.util.removeAllOptions('calcInteres');
    formTipoCalIntServicio.listaCombo(catFormTipoCalInt.principal,function(formTipoCalIntBean){
        dwr.util.addOptions('calcInteres', {'':'SELECCIONAR'});
        dwr.util.addOptions('calcInteres', formTipoCalIntBean, 'formInteresID', 'formula');
    });
}

// Funcion que consulta la tasa base
function consultaTasaBase(idControl) {
    var jqTasa = eval("'#" + idControl + "'");
    var tasaBase = $(jqTasa).asNumber();
    var TasaBaseBeanCon = {
        'tasaBaseID': tasaBase
    };
    setTimeout("$('#cajaLista').hide();", 200);

    if (tasaBase > 0) {
        tasasBaseServicio.consulta(1, TasaBaseBeanCon, function(tasasBaseBean) {
            if (tasasBaseBean != null) {
                $('#desTasaBase').val(tasasBaseBean.nombre);
                $('#tasaBaseValor').val(tasasBaseBean.valor+'%');
                $('#tasaFija').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
                $('#tasaBaseValor').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
            } else {
                $('#desTasaBase').val('');
                $('#tasaBaseValor').val('');
            }
        });
    }
}

// Funcion que muestra los campos de la tasa variable
function muestraCamposTasa(calcInteresID) {
    calcInteresID = Number(calcInteresID);
    $('#calcInteres').val(calcInteresID);
    // Si el calculo de interes es por tasaFija se ocultan campos de tasa variable
    if (calcInteresID <= TasaFijaID) {
        $('tr[name=tasaBase]').hide();
        $('td[name=tasaPisoTecho]').hide();
        $('#tasaBase').val('');
        $('#desTasaBase').val('');
        $('#tasaFija').val('');
        $('#pisoTasa').val('');
        $('#techoTasa').val('');
    } else if (calcInteresID != TasaFijaID) {
        // Si es por tasa variable, se consulta y se muestra
        consultaTasaBase('tasaBase');
        $('tr[name=tasaBase]').show();
        $('td[name=tasaPisoTecho]').hide();
        if (calcInteresID == TasaBasePisoTecho) {
            $('td[name=tasaPisoTecho]').show();
        }
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


function consultaConvenioNomina(convenioID) {
    var convenioBean = {
        'convenioNominaID': $('#convenioNominaID').val()
    };
    var institucion = $('#institucionNominaID').val();
    var convenioID   = $('#convenioNominaID').val();
    setTimeout("$('#cajaLista').hide();", 200);;
    conveniosNominaServicio.consulta(1, convenioBean, {async: false, callback:function(resultado) {
        if (resultado != null) {
            $("#desConvenio").val(resultado.descripcion);
            if (resultado.manejaQuinquenios=="S") {
                existeEsquemaQConvenio(institucion,convenioID);
            
            }
            else{
                dwr.util.removeAllOptions('quinquenioID');
                dwr.util.addOptions('quinquenioID',{'':'SELECCIONAR'});
            }
            
            if (resultado.requiereFolio=="S") {
            	$('#folioSolici').show();
            	$('#folioSolicilbl').show();
            }
            else{     
            	$('#folioSolici').hide();
            	$('#folioSolicilbl').hide();
            }
            
            manejaCapacidadPago = resultado.manejaCapPago;
        } else {
           $("#convenioNominaID").val("");
           $("#desConvenio").val("");
           manejaCapacidadPago = "N";
        }
    }});
}

function consultaNomInstit() {
    var tipoCon = 1;
    var institucion=$('#institucionNominaID').val();
    if (institucion != ''  && !isNaN(institucion) && institucion >0 && esTab == true){
    var institNominaBean = {
            'institNominaID' : institucion
    };
        institucionNomServicio.consulta(tipoCon, institNominaBean, function(institucionNomina) {
            if (institucionNomina != null){
                $('#nombreInstit').val(institucionNomina.nombreInstit);
            }
            else {
                mensajeSis("La Empresa de Nómina no Existe.");
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
    };
    var tipoLista  = 1;
    dwr.util.addOptions('quinquenioID',{'':'SELECCIONAR'});
    catQuinqueniosServicio.lista(tipoLista, catQinqueniosBean, function(quinquenios){
        dwr.util.addOptions('quinquenioID', quinquenios, 'quinquenioID', 'descripcionCorta');

    });
}


function consultaEsquemaQuinquenio(institNominaID, convenioNominaID, sucursalID, quinquenioID, clienteID ){

    var quinquenio = $('#quinquenioID').asNumber();
    var plazos = "";
    var plazo = 0;
    var calendarioIngresosBean = {
        'institNominaID': institNominaID,
        'convenioNominaID': convenioNominaID,
        'sucursalID': sucursalID,
        'quinquenioID': quinquenioID,
        'clienteID': clienteID,
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
                    mensajeSis('El cliente se encuentra en el quinquenio <b>'+resultado.desQuinquenio
                                    +'</b> y no aplica para este plazo del convenio <b>'+$('#plazoID option:selected').html()
                                    +'</b>');

                }else{
                    //VALIDACIONSI CUENTA CON UN ESQUEMA CON EL PLAZO SELECCIONADO
                    if(plazos.indexOf(plazo)==0) {
                        mensajeSis("No existe un esquema con el plazo indicado");
                    }
                }
            }
        }
        else{
            mensajeSis("El quinquenio seleccionado no cuenta con un esquema");
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
               
                consultaEsquemaQuinquenio(InstitucionNominaID,
                           ConvenioNominaID,
                           SucursalID,
                           QuinquenioID,
                           ClienteID);
                noSeguirPro= false;

            }else{
                noSeguirPro = true;
                   deshabilitaBoton('guardarAutoriza', 'submit');
                    deshabilitaBoton('guardarRechazo', 'submit');
                    deshabilitaBoton('guardarRegresar', 'submit');
                    deshabilitaBoton('rechazar', 'submit');
                    deshabilitaBoton('regresarEjec', 'submit');
                    deshabilitaBoton('autorizar', 'submit');
                    mensajeSis("El convenio de la Empresa Nómina no cuenta con un Esquema de Quinquenios parametrizado");
            }
            
        }
        
    }});
}
//obtiene estatus de instruccionde dispercion
function obtienestatusdispercion() {
    
 
    var solCred = $('#solicitudCreditoID').val();
    
    if (solCred != '' && !isNaN(solCred)) {
        
        var SolCredBeanCon = {
        'solicitudCreditoID' : solCred
        };
      
        instruccionDispersionServicio.consulta(1, SolCredBeanCon, {
        callback : function(solicitud) {
            if (solicitud != null && solicitud.solicitudCreditoID != 0) {
               var_instrucccionesEstatus = solicitud.estatus ;
           
            } else {
                var_instrucccionesEstatus="";
                
            
            }
        },
        errorHandler : function(message) {
            mensajeSis("Error en Validacion de la instruccion de Disprsion.<br>" + message);
        }
        });
    }
}


/**
 * Consulta los tipo de motivos cancelacion del catalogo
 */
function funcionCargaComboMotivosCancelacion(){
	dwr.util.removeAllOptions('motivoRechazoID'); 
	solicitudCredServicio.listaComboMotivosCancelacion(1, function(beanLista){
		dwr.util.addOptions('motivoRechazoID', {'':'SELECCIONAR'});	
		dwr.util.addOptions('motivoRechazoID', beanLista, 'motivoRechazoID', 'descripcionMotivo');
	});
}	


/**
 * Consulta los tipo de motivos devolucion del catalogo
 */
function funcionCargaMotivosDevolucion() {
	dwr.util.removeAllOptions('motivoDevolucionID');
	solicitudCredServicio.listaCombo(2, function(tiposInstrum) {
		dwr.util.addOptions('motivoDevolucionID', tiposInstrum, 'motivoDevolucionID', 'descripcionMotivo');
	});
}


