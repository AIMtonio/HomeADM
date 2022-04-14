var	requiereValidaCredito = "N";
var parametrosBean = consultaParametrosSession();
var Enum_TiposBloqueo = {
		'Bloqueado' : 'B',
		'Desbloqueado' : 'D'
};
var hayCalendarioParametrizado = false;
var fechaSistema = '1900-01-01';
var fechaMinistra =  '1900-01-01';
var fechaCalculadaBean = null;
var esMayor = false;
var esMenor = false;
var catTipoTransaccionCredito = {
	'desembolsar'	: 28,
	'cancelacion'	: 29
};

var catTipoActualizaccionCredito = {
	'desembolsar'	: 1,
	'cancelacion'	: 2
};

var catTipoCalculoInteres = {
	'fechaPactada'	: 'P',
	'fechaReal'		: 'R'
};

var catTipoConsultaCredito = {
	'principal'	: 1,
	'foranea'	: 2,
	'impPagare' : 3
};

var catTipoConsultaCalendario = {
	'principal'		: 1,
	'foranea'		: 2
};

var Constantes = {
	'RENOVACION'		: 'O',
	'REESTRUCTURA'		: 'R',
	'SI'				: 'S',
	'NO'				: 'N'
};

var catConLinea = {
	'agropecuaria': 4
};
var montoPagGarantia = 0.00;
var montoPagAdmon = 0.00;

var forPagComGarantia = '';
$(document).ready(function() {
	esTab = true;

	$("#creditoID").focus();
	$('#divComentarios').show('');

	expedienteBean = {
			'clienteID' : 0,
			'tiempo' : 0,
			'fechaExpediente' : '1900-01-01',
	};
	listaPersBloqBean = {
			'estaBloqueado'	:'N',
			'coincidencia'	:0
	};
	var esCliente 			='CTE';

	validaMonitorSolicitud();
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('desembolsar');
	deshabilitaBoton('cancelar');
	validaEmpresaID();

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	agregaFormatoControles('formaGenerica');

	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID', 'limpiaDesembolso', 'fallo');
		}
	});

	$('#desembolsar').click(function(event) {
		$('#tipoTransaccion').val(catTipoTransaccionCredito.desembolsar);
		$('#tipoActualizacion').val(catTipoActualizaccionCredito.desembolsar);

		if(forPagComGarantia != "" && $('#numeroID').asNumber() > 1){

			var formaCobroGarantia = $("#"+forPagComGarantia).val();
			$('#forPagComGarantia').val(formaCobroGarantia);

			if( $("#esLineaCreditoAgro").val() == 'S' && $('#forPagComGarantia').val() == '' ){
				mensajeSis("Seleccione una forma de Pago para la Comisión de Garantía.");
				$('#'+forPagComGarantia).focus();
				$('#'+forPagComGarantia).select();
			}
		}

		if(fechaMinistra != fechaSistema){
			// Se evalua si la fecha se encuentra del rango de los días max permitidos posterior al desembolso
			if(validaFechas(catTipoActualizaccionCredito.desembolsar)){
				if(confirm('¿Desea Recalcular los Intereses Devengados con la Fecha Pactada de Ministración?')){
					$('#tipoCalculoInteres').val(catTipoCalculoInteres.fechaPactada);
				} else {
					$('#tipoCalculoInteres').val(catTipoCalculoInteres.fechaReal);
				}
			} else {
				/* si la fecha de ministracion a desembolsar no se encuentra dentro del rango
				   de los días max permitidos posterior al desembolso se empezará a devengar con
				   la fecha real de ministración */
				$('#tipoCalculoInteres').val(catTipoCalculoInteres.fechaReal);
			}
		} else {
			$('#tipoCalculoInteres').val(catTipoCalculoInteres.fechaReal);
		}
	});

	$('#cancelar').click(function(event) {
		$('#usuarioContrasenia').show(500);
		$('#tipoTransaccion').val(catTipoTransaccionCredito.cancelacion);
		$('#tipoActualizacion').val(catTipoActualizaccionCredito.cancelacion);
		if(!validaFechas(catTipoActualizaccionCredito.cancelacion)){
			event.preventDefault();
			mensajeSis('No se puede cancelar la Ministración. Fuera del Periodo de Cancelación.');
			deshabilitaBoton('desembolsar');
			deshabilitaBoton('cancelar');
		}
	});

	$('#creditoID').bind('keyup',function(e){
		lista('creditoID', '2', '48', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
	});

	$('#creditoID').blur(function(e) {
		setTimeout("$('#cajaLista').hide();", 200);
		consultaCredito(this.id);
	});

	$('#creditoID').change(function(e) {
		setTimeout("$('#cajaLista').hide();", 200);
		limpiaDesembolso();
	});

	$('#usuarioAutoriza').blur(function() {
		consultaUsuario($('#usuarioAutoriza').val().trim());
	});

	$('#usuarioAutoriza').change(function() {
		$('#contraseniaAutoriza').val('');
	});

	$('#contraseniaAutoriza').blur(function() {
		$('#desembolsar').focus();
	});

	//------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({
		rules: {
			creditoID: {
				required: true
			},
			usuarioAutoriza: {
				required: function (){
					return $('#usuarioAutoriza').is(':visible');
				}
			},
			contraseniaAutoriza: {
				required: function (){
					return $('#contraseniaAutoriza').is(':visible');
				}
			}
		},
		messages: {
			creditoID: {
				required: 'Especifique un Crédito.'
			},
			usuarioAutoriza: {
				required: 'Especifique una Clave de Usuario.'
			},
			contraseniaAutoriza: {
				required: 'Especifique la Contraseña del Usuario.'
			}
		}
	});
	//------------ Validaciones de Controles -------------------------------------

	function validaMonitorSolicitud() {
		// seccion para validar si la pantalla fue llamada desde la pantalla de Monitor de Solicitud
		if ($('#monitorSolicitud').val() != undefined) {
			var credito = $('#numSolicitud').val();
			var creditoID = 'creditoID';
			$('#creditoID').val(credito);
			consultaCredito(creditoID);
		}
	}


	function consultaCredito(control) {
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) && esTab){
			var creditoBeanCon = {
					'creditoID':$('#creditoID').val()
			};
			$("#divLineaCredito").hide();
			creditosServicio.consulta(catTipoConsultaCredito.principal,creditoBeanCon,function(credito) {
				if(credito!=null){
					bloquearPantalla();
					$('#clienteID').val(credito.clienteID);
					var cliente = $('#clienteID').asNumber();
					if(cliente>0){
						listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, credito.cuentaID, numCredito);
						if(listaPersBloqBean.estaBloqueado!=Constantes.SI){
							expedienteBean = consultaExpedienteCliente(cliente);
							if(expedienteBean.tiempo<=1){
								if(credito.esAgropecuario == Constantes.SI){

									esTab=true;
									montoPagGarantia = credito.montoPagComAdmon;
									montoPagAdmon = credito.montoPagComGarantia;

									var Estatus_Autorizado='A';
									var Estatus_Vigente='V';
									consultaCliente('clienteID');
									var lineaCreditoAgroID = credito.lineaCreditoID;
									if( lineaCreditoAgroID > 0){
										$("#divLineaCredito").show();
										$('#lineaCreditoID').val(credito.lineaCreditoID);
										lineaCreditoAgro(credito.lineaCreditoID);
										forPagComGarantia = credito.forPagComGarantia;
										if( credito.manejaComGarantia == 'N'){
											$('#esLineaCreditoAgro').val('N');
										} else {
											$('#esLineaCreditoAgro').val('S');
										}
									}
									$('#producCreditoID').val(credito.producCreditoID);
									consultaProducCredito('producCreditoID', credito.grupoID);
									consultaCalendarioMinistra();
									$('#cuentaID').val(credito.cuentaID);
									$('#montoCredito').val(credito.montoCredito);
									$('#monedaID').val(credito.monedaID);
									consultaMoneda('monedaID');
									$('#fechaInicio').val(credito.fechaInicio);
									$('#fechaVencimien').val(credito.fechaVencimien);
									$('#factorMora').val(credito.factorMora);
									$('#estatus').val(credito.estatus);
									$('#solicitudCreditoID').val(credito.solicitudCreditoID);
									if(credito.tipCobComMorato == 'T') {
										$('#lblveces').text('Tasa Fija Anualizada');
									} else {
										$('#lblveces').text('Veces la Tasa de Interés Ordinaria');
									}
									consultaMinistraciones();
									if(credito.estatus != Estatus_Autorizado && credito.estatus!=Estatus_Vigente){
										deshabilitaBoton('desembolsar');
										deshabilitaBoton('cancelar');
									} else {

										creditoBeanCon = {
												'creditoID': $('#creditoID').val()
										};

										creditosServicio.consulta(catTipoConsultaCredito.impPagare,creditoBeanCon,function(creditoPagare) {
											if(credito!=null){

												if(creditoPagare.pagareImpreso != "S"){
													mensajeSis("El Pagaré No ha Sido Impreso.");
													deshabilitaBoton('desembolsar');
													deshabilitaBoton('cancelar');
													$('#creditoID').focus();
													$('#creditoID').select();
												}else{

													if(credito.tipoCredito == Constantes.RENOVACION || credito.tipoCredito == Constantes.REESTRUCTURA){
														creditoBeanCon = {
																'creditoID': credito.relacionado
														};

														creditosServicio.consulta(catTipoConsultaCredito.principal,creditoBeanCon,function(creditoRelacionado) {
															if(credito!=null){
																if(credito.tipoCredito == Constantes.REESTRUCTURA ){
																	if(creditoRelacionado.totalAdeudo != $('#montoCredito').asNumber()){
																		mensajeSis("El Monto de Crédito a Desembolsar debe ser Igual al Adeudo Total del Crédito a Reestructurar.");
																		deshabilitaBoton('desembolsar');
																		deshabilitaBoton('cancelar');
																		$('#creditoID').focus();
																		$('#creditoID').select();
																	}
																}


															}
														});
													}

													consultaFechaDesembolso(credito.esConsolidacionAgro);
												}

											}
										});
									}
									consultaHuellaCliente();

								} else {
									limpiaDesembolso();
									mensajeSis('El Crédito No es Agropecuario.<br>Favor de Consultarlo en el Módulo <i><u>Cartera</u></i>.');
									$('#creditoID').focus();
									$('#creditoID').select();
								}
							} else {
								limpiaDesembolso();
								mensajeSis('Es necesario Actualizar el Expediente del Cliente para Continuar.');
								$('#creditoID').focus();
								$('#creditoID').select();
							}
						} else {
							limpiaDesembolso();
							mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
							$('#creditoID').focus();
							$('#creditoID').select();
						}
					}
					/* Si el mensajeSis esta visible no se desbloquea la pantalla
					 * para que los mensajes de validación no desaparezcan. */
					if(!$('#alertInfo').is(":visible")){
						desbloquearPantalla();
					}
				}else{
					limpiaDesembolso();
					mensajeSis("No Existe el Crédito.");
					$('#creditoID').focus();
					$('#creditoID').select();
				}
			});

		}
	}

	//------------ Validaciones de Controles -------------------------------------
	function lineaCreditoAgro(lineaCreditoID) {

		var numeroConsulta = catConLinea.agropecuaria;
		var lineaCreditoAgroBean = {
			'lineaCreditoID' : lineaCreditoID
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if( lineaCreditoID != '' && !isNaN(lineaCreditoID) ){
			lineasCreditoServicio.consulta(numeroConsulta, lineaCreditoAgroBean,{
				async: false, callback:function(lineaCreditoBean){
					if(lineaCreditoBean!=null){
						$("#lineaCreditoID").val(lineaCreditoBean.lineaCreditoID);
						$('#saldoDisponible').val(lineaCreditoBean.saldoDisponible);
						$('#saldoDeudor').val(lineaCreditoBean.saldoDeudor);
						$('#esLineaCreditoAgro').val(lineaCreditoBean.esAgropecuario);

						$('#saldoDisponible').formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 2
						});

						$('#saldoDeudor').formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 2
						});
					}else{
						$("#esLineaCreditoAgro").val("");
						mensajeSis("La Línea de Crédito Agro no Existe.");
					}
				},
				errorHandler : function(message, exception) {
					mensajeSis("Error en Consulta  de Línea de Crédito Agropecuaria.<br>" + message + ":" + exception);
				}
			});
		}
	}

	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);

		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
				if(cliente!=null){
					$('#clienteID').val(cliente.numero);
					$('#nombreCliente').val(cliente.nombreCompleto);
				}else{
					mensajeSis("No Existe el Cliente.");
					$('#clienteID').focus();
					$('#clienteID').select();
				}
			});
		}
	}

	function consultaMoneda(idControl) {
		var jqMoneda = eval("'#" + idControl + "'");
		var numMoneda = $(jqMoneda).val();
		var conMoneda=2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numMoneda != '' && !isNaN(numMoneda)){
			monedasServicio.consultaMoneda(conMoneda,numMoneda,function(moneda) {
				if(moneda!=null){
					$('#monedaDes').val(moneda.descripcion);
				}else{
					mensajeSis("No Existe el Tipo de Moneda.");
					$('#monedaDes').val('');
					$(jqMoneda).focus();
				}
			});
		}
	}

	function consultaProducCredito(idControl, grupoID) {
		var jqProdCred  = eval("'#" + idControl + "'");
		var ProdCred = $(jqProdCred).val();
		var ProdCredBeanCon = {
				'producCreditoID':ProdCred
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if(ProdCred != '' && !isNaN(ProdCred) && esTab){
			productosCreditoServicio.consulta(catTipoConsultaCredito.principal,ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){
					$('#nombreProd').val(prodCred.descripcion);

				}else{
					mensajeSis("No Existe el Producto de Crédito.");
				}
			});
		}
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
					if(huella =="S" && huellaProductos=="S"){
						mensajeSis("El Cliente no tiene Huella Registrada.\nFavor de Verificar.");
						$('#creditoID').focus();
						deshabilitaBoton('desembolsar');
						deshabilitaBoton('cancelar');
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
				'empresaID'	:numEmpresaID
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

	function consultaCalendarioMinistra() {
		var jqproducto  = eval("'#producCreditoID'");
		var producto = $(jqproducto).val();
		quitaFormatoControles('formaGenerica');
		var calendarioBeanCon = {
			'productoCreditoID' :producto
		};

		setTimeout("$('#cajaLista').hide();", 200);
		if(producto != '' && !isNaN(producto) && esTab){
			calendarioMinistracionServicio.consulta(catTipoConsultaCalendario.principal, calendarioBeanCon,{ async: false, callback:function(calendario) {
				if(calendario!=null){
					hayCalendarioParametrizado = true;
					$('#diasCancelacion').val(calendario.diasCancelacion);
					$('#diasMaxMinistraPosterior').val(calendario.diasMaxMinistraPosterior);
				} else {
					hayCalendarioParametrizado = false;
					mensajeValCalendario(producto);
				}
			  }
			});
		}
	}

	function consultaFechaDesembolso(esConsolidacionAgro){
		var numeroConsulta = 3;

		var consolidacionesBean = {
			creditoID : $('#creditoID').val()
		};

		setTimeout("$('#cajaLista').hide();", 200);

		if (esConsolidacionAgro == 'S' ) {
			consolidacionesServicio.consultaConsolidacion(numeroConsulta, consolidacionesBean, {
				async : false,
				callback : function(consolidacionResponse) {
					if (consolidacionResponse != null) {

						if( consolidacionResponse.fechaDesembolso != parametrosBean.fechaAplicacion ){
							mensajeSis("La fecha de Desembolso del Crédito Consolidado: " + $('#creditoID').val()+ " es el día " + consolidacionResponse.fechaDesembolso);
							deshabilitaBoton('desembolsar');
							deshabilitaBoton('cancelar');
							$('#creditoID').focus();
							$('#creditoID').select();
						} else {

							consolidacionesBean = {
								'folioConsolidaID': consolidacionResponse.folioConsolidaID
							};

							numeroConsulta = 4;
							consolidacionesServicio.consultaConsolidacion(numeroConsulta, consolidacionesBean, {
								async : false,
								callback : function(creditoResponse) {
									if( creditoResponse != null ){
										var montoConsolidado = parseFloat(consolidacionResponse.montoConsolidado);
										montoConsolidado = montoConsolidado.toFixed(2);

										if( creditoResponse.montoExigible != montoConsolidado ){
											mensajeSis("El Monto de Crédito a Desembolsar debe ser Igual al Adeudo Total del Crédito a Consolidar.");
											deshabilitaBoton('desembolsar');
											deshabilitaBoton('cancelar');
											$('#creditoID').focus();
											$('#creditoID').select();
										}
									}
								}
							});
						}

					} else {
						mensajeSis("No Existe una fecha de Desembolso para el Crédito: "+ $('#creditoID').val() );
					}
				},
				errorHandler : function(message, exception) {
					mensajeSis("Error en Consulta de la Fecha de Desembolso.<br>" + message + ":" + exception);
				}
			});
		}
	}
});

function consultaUsuario(claveUsuario) {
	if(claveUsuario != ''){
		var usuarioBeanCon = {
			'clave' : claveUsuario
		};
		var consultaClave = 3;
		usuarioServicio.consulta(consultaClave,usuarioBeanCon,function(usuarioBean) {
			if(usuarioBean==null){
				mensajeSis('El Usuario No Existe.');
				$('#usuarioAutoriza').focus();
				$('#usuarioAutoriza').val('');
				$('#contraseniaAutoriza').val('');
			}
		});
	}
}

function mensajeValCalendario(producto){
	mensajeSis('No Existe Calendario de Ministraciones para el Producto '+producto+'.');
	$('#diasCancelacion').val(0);
	$('#diasMaxMinistraPosterior').val(0);
	deshabilitaBoton('desembolsar');
	deshabilitaBoton('cancelar');
}

function consultaReqValidaCred() {
	var numConsulta = 1;
	var paramBean = {
			'empresaID' : 1
	};
	parametrosSisServicio.consulta(numConsulta, paramBean, function(parametrosBean) {
		if (parametrosBean != null) {
			requiereValidaCredito = parametrosBean.reqValidaCred;
		}
	});
}

function consultaMinistraciones() {
	$("#calendarioMinistraGrid").html("");
	var beanMinistraciones = {
			'creditoID' 	: $("#creditoID").asNumber(),
			'tipoLista'		: 2,
			'esLineaCreditoAgro' : $("#esLineaCreditoAgro").val()
	};
	$.post("calendarioMinistraGrid.htm", beanMinistraciones, function(data) {
		if (data.length > 0) {
			$("#calendarioMinistraGrid").html(data);
			$("#calendarioMinistraGrid").show();
			agregaFormatoControles('formaGenerica');
		} else {
			$("#calendarioMinistraGrid").html("");
			$("#calendarioMinistraGrid").show();
		}
	});
	ocultaLimpiaAutorizacion();
}

function marcaEstatus(){
	$('#tbMinistraciones tr').each(function(index){
		if(index>0){
			var seleccionado = "#"+$(this).find("input:checkbox[name^='seleccionado']").attr("id");
			var bloqBoton = "#"+$(this).find("input:button[name^='estatusBloq']").attr("id");

			var estaSelecionado = $(seleccionado).val().trim();

			if(estaSelecionado==Constantes.SI){
				$(seleccionado).attr('checked', true);
				$(bloqBoton).hide();
			} else {
				$(seleccionado).attr('checked', false);
				estiloBloqueado(bloqBoton);
			}
		}
	});
}

function estiloDesbloqueado(idControl){
	$(idControl).css({'background' :'url(images/unlock.png) no-repeat '});
	$(idControl).css({'border' :' none'});
	$(idControl).css({'width' :' 21px'});
	$(idControl).css({'height' :' 21px'});
	$(idControl).val(Enum_TiposBloqueo.Desbloqueado);
}

function estiloBloqueado(idControl){
	$(idControl).css({'background' :'url(images/lock.png) no-repeat '});
	$(idControl).css({'border' :' none'});
	$(idControl).css({'width' :' 21px'});
	$(idControl).css({'height' :' 21px'});
	$(idControl).val(Enum_TiposBloqueo.Bloqueado);
}

function desbloqueaChecks(idControl, idSeleccionado){
	estiloDesbloqueado('#'+idControl);
	habilitaControl(idSeleccionado);
}

function desbloqueaManejaGarantia(numeroID){
	forPagComGarantia = '';
	if( $('#esLineaCreditoAgro').val() == 'S' ){
		var control = 'listaForPagComGarantia'+numeroID;
		habilitaControl(control);
		forPagComGarantia = control;
	}
}

function bloqueaChecks(idControl, idSeleccionado){
	estiloBloqueado('#'+idControl);
	deshabilitaControl(idSeleccionado);
	$('#'+idSeleccionado).removeAttr('checked');
	$('#numeroID').val('');
	deshabilitaBoton('desembolsar');
	deshabilitaBoton('cancelar');
}

function bloqueaManejaGarantia(numeroID){
	if( $('#esLineaCreditoAgro').val() == 'S' ){
		var control = 'listaForPagComGarantia'+numeroID;
		deshabilitaControl(control);
		$('#'+control).val('');
		$('#forPagComGarantia').val('');
	}
}

function seRepiteDesBloqueo(idControl){
	var seRepite = false;
	var valorEstatus = $('#'+idControl).val().trim();
	// sólo si el candado esta bloqueado
	if(valorEstatus == Enum_TiposBloqueo.Bloqueado){
		// busca en toda la tabla de ministraciones
		$("#tbMinistraciones input:button[name^='estatusBloq']").each(function(){
			var valorBuscado=$('#'+this.id).val();

			if (idControl != this.id && valorBuscado!=undefined && valorBuscado!='' && valorBuscado == Enum_TiposBloqueo.Desbloqueado) {
				seRepite = true;
			}
		});
	} else {
		seRepite = false;
	}
	return seRepite;
}

function accionCandado(idControl, idSeleccionado){
	var estatus = $('#'+idControl).val().trim();
	if(!seRepiteDesBloqueo(idControl)){
		var numeroID = idSeleccionado.substr(12,idSeleccionado.length);
		if(estatus == Enum_TiposBloqueo.Bloqueado){
			desbloqueaChecks(idControl, idSeleccionado);
			desbloqueaManejaGarantia(numeroID);
		} else if(estatus == Enum_TiposBloqueo.Desbloqueado){
			bloqueaChecks(idControl, idSeleccionado);
			bloqueaManejaGarantia(numeroID);
		}
		ocultaLimpiaAutorizacion();
	}
}

function validaFechaMinistracion(idControl, idFechaPagoMinis){
	fechaSistema = parametrosBean.fechaAplicacion;
	fechaMinistra = $('#'+idFechaPagoMinis).val();
	if($('#'+idControl).attr('checked') == true){
		if(hayCalendarioParametrizado){
			if(fechaMinistra != fechaSistema){
				$('#usuarioContrasenia').show(500);
				$('#usuarioAutoriza').focus();
			} else {
				ocultaLimpiaAutorizacion();
				habilitaBoton('desembolsar');
				habilitaBoton('cancelar');
			}
			calculaDiasFecha(idFechaPagoMinis);
		} else {
			mensajeValCalendario($('#producCreditoID').val());
			$('#'+idControl).removeAttr('checked');
			$('#fechaLimCancelacion').val('');
			$('#fechaLimMinistraPosterior').val('');
		}
	} else {
		ocultaLimpiaAutorizacion();
		deshabilitaBoton('desembolsar');
		deshabilitaBoton('cancelar');
		$('#numeroID').val('');
		$('#fechaLimCancelacion').val('');
		$('#fechaLimMinistraPosterior').val('');
	}
}

function validaAutorizacion(){
	var usuario = $('#usuarioAutoriza').val().trim();
	var pass = $('#contraseniaAutoriza').val().trim();

	var numeroMinistracion = $('#numeroID').asNumber();
	if(usuario != '' && pass != ''){
		if(hayCalendarioParametrizado){
			habilitaBoton('desembolsar');
			// Sólo si es la primer ministración, se deshablita el botón de cancelar.
			if(numeroMinistracion==1){
				deshabilitaBoton('cancelar');
			} else {
				habilitaBoton('cancelar');
			}
		} else {
			mensajeValCalendario($('#producCreditoID').val());
		}
	} else {
		deshabilitaBoton('desembolsar');
		deshabilitaBoton('cancelar');
	}
}

function validaUsuarioAutorizacion(){
	var usuario = $('#usuarioAutoriza').val().trim();
	var usuarioLogeado = parametrosBean.claveUsuario;

	if(usuario != ''){
		if(usuario === usuarioLogeado){
			mensajeSis('El Usuario que Autoriza no puede ser el mismo que el Usuario Logeado.');
			deshabilitaBoton('desembolsar');
			deshabilitaBoton('cancelar');
			$('#usuarioAutoriza').val('');
			$('#usuarioAutoriza').focus();
		}
	}
}

function ocultaLimpiaAutorizacion(){
	$('#usuarioAutoriza').val('');
	$('#contraseniaAutoriza').val('');
	// los readonly se usa para evitar el autocomplete
	$('#usuarioAutoriza').attr('readonly', 'readonly');
	$('#contraseniaAutoriza').attr('readonly', 'readonly');
	$('#usuarioContrasenia').hide(500);
}

function eligeMinistracion(idControl){
	$('#numeroID').val('');
	var numeroChecked = $('#'+idControl).val();

	$('#tbMinistraciones tr').each(function(index){
		if (index >= 0) {
			var numero = $(this).find("input[name=numero]").val();
			var seleccionado = "#"+$(this).find("input:checkbox[name^='seleccionado']").attr("id");

			if(numeroChecked==numero && $(seleccionado).attr('checked') == true){
				$('#numeroID').val(numero);
				// Sólo si es la primer ministración, se deshablita el botón de cancelar.
				if(numero==1){
					deshabilitaBoton('cancelar');
				}
			}
		}
	});
}

function calculaDiasFecha(idControl){
	esTab = true;
	var fecha = $('#'+idControl).val();
	$('#fechaDeMinistracion').val(fecha);
	var numeroDias = $('#diasCancelacion').asNumber();
	fechaCalculadaBean = sumaDiasFechaHabil(3,fecha, numeroDias, 0, 'S');
	$('#fechaLimCancelacion').val(fechaCalculadaBean.fecha);
	numeroDias = $('#diasMaxMinistraPosterior').asNumber();
	fechaCalculadaBean = sumaDiasFechaHabil(3,fecha, numeroDias, 0, 'S');
	$('#fechaLimMinistraPosterior').val(fechaCalculadaBean.fecha);
}

function validaFechas(tipoValidacion){
	var valido = false;
	var fechaMinistra = $('#fechaDeMinistracion').val();
	var fechaLimite = '';
	if(tipoValidacion==catTipoActualizaccionCredito.desembolsar){
		fechaLimite = $('#fechaLimMinistraPosterior').val();
	} else if(tipoValidacion==catTipoActualizaccionCredito.cancelacion){
		fechaLimite = $('#fechaLimCancelacion').val();
	}
	if(fechaSistema>=fechaMinistra && fechaSistema<=fechaLimite){
		valido = true;
	} else {
		valido = false;
	}
	return valido;
}

function limpiaDesembolso(){
	deshabilitaBoton('desembolsar');
	deshabilitaBoton('cancelar');
	limpiaFormaCompleta('formaGenerica', true, [ 'creditoID' ]);
	$('#usuarioContrasenia').hide();
	$("#calendarioMinistraGrid").hide();
	$("#esLineaCreditoAgro").val("");
	$("#divLineaCredito").hide();
	forPagComGarantia = '';
}

function fallo(){

}