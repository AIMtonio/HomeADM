var	requiereValidaCredito="N";
var funcionHuella = 'N';
var autorizaHuellaCliente = 'N';
var huellaCliente = 'N';
var tipoPersona = 'F';
$(document).ready(function() {
	consultaReqValidaCred();
	esTab = true;
	var tab2=false;

	validaAutorizacionHuellaCliente();
	var parametroBean = consultaParametrosSession();
	var funcionHuella = parametroBean.funcionHuella;

	var serverHuella = new HuellaServer({
		fnHuellaValida:	function(datos){
			grabaFormaTransaccionRetrollamada({}, 'formaGenerica', 'contenedorForma', 'mensaje','false','inversionID', 'funcionExito', 'funcionError');
		},
		fnHuellaInvalida: function(datos){
			mensajeSis("La huella del cliente/firmante no corresponde con el registro en el sistema.");
			deshabilitaBoton("grabar");
			return false;
		}
	});

	$("#creditoID").focus();
	$('#divComentarios').show('');

	var catHuellaDigital = {
		'noHuellas' : 4
	};

	//Definicion de Constantes y Enums
	var catTipoTransaccionCredito = {
  		'agrega':1,
  		'modifica':'2',
  		'desembolsar':4 //el numero 3 esta asignado a una transacion de actualizacion

  			};

	var catTipoConsultaCredito = {
  		'principal'	: 1,
  		'foranea'	: 2,
  		'impPagare' : 3
	};


	var Constantes = {
		'RENOVACION'		: 'O',
		'REESTRUCTURA'		: 'R',
		'SI'				: 'S',
		'NO'				: 'N'
	};

	expedienteBean = {
			'clienteID' : 0,
			'tiempo' : 0,
			'fechaExpediente' : '1900-01-01',
	};
	listaPersBloqBean = {
			'estaBloqueado'	:'N',
			'coincidencia'	:0
	};
	
	var consultaSPL = {
    		'opeInusualID' : 0,
    		'numRegistro' : 0,
    		'permiteOperacion' : 'S',
    		'fechaDeteccion' : '1900-01-01'
    };
	
	var esCliente 			='CTE';

	validaMonitorSolicitud();
		//------------ Metodos y Manejo de Eventos -----------------------------------------
		deshabilitaBoton('desembolsar', 'submit');
		validaEmpresaID();

	$(':text').focus(function() {
	 	esTab = false;
	});

	agregaFormatoControles('formaGenerica');

	$.validator.setDefaults({
            submitHandler: function(event) {
            	//grabaFormaTransaccionRetrollamada({}, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID','funcionExito','funcionError');

            }
    });

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#desembolsar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionCredito.desembolsar);
		if(funcionHuella == 'S' && autorizaHuellaCliente == 'S'){
			validaHuellaCliente();
			if(huellaCliente == 'S'){
				serverHuella.muestraFirmaAutorizacion();
				deshabilitaBoton('desembolsar', 'submit');
				tab2 = false;
				return false;
			}else{
				return false;
			}
		}else{
			grabaFormaTransaccionRetrollamada({}, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID','funcionExito','funcionError');
			deshabilitaBoton('desembolsar', 'submit');
			tab2 = false;

		}
	});

		$('#creditoID').bind('keyup',function(e){
		if(requiereValidaCredito == 'S'){
			lista('creditoID', '2', '43', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
		}else{
			lista('creditoID', '2', '10', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
		}


	});

	$('#creditoID').change(function() {
		if(isNaN($('#creditoID').val()) ){
			$('#creditoID').val("");
			$('#creditoID').focus();
			inicializaForma('formaGenerica','creditoID');
			tab2 = false;
			deshabilitaBoton('desembolsar', 'submit');
		}else{
			tab2=true;
			esTab = true;
			if(requiereValidaCredito == 'N'){
				consultaCredito(this.id);
			}else{
				consultaCreditoValida(this.id);
			}

		}
	});

	$('#creditoID').blur(function() {
		if(isNaN($('#creditoID').val()) ){
			$('#creditoID').val("");
			$('#creditoID').focus();
			inicializaForma('formaGenerica','creditoID');
			deshabilitaBoton('desembolsar', 'submit');
			tab2 = false;
		 }else{
			if(tab2 == false){
				esTab = true;
				if(requiereValidaCredito == 'N'){
				consultaCredito(this.id);
			}else{
				if(esTab== true){
					consultaCreditoValida(this.id);
				}

			}
		 	}
		}
	});

	$('#claveUsuarioAut').blur(function() {
  		validaUsuario(this);
	});

			//------------ Validaciones de la Forma -------------------------------------

	$('#formaGenerica').validate({
		rules: {

			producCreditoID: {
			required: false}
		},
		messages: {
			producCreditoID: {
				required: ''}
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
			var numCredito = $('#creditoID').val().trim();
    		$('#creditoID').val(numCredito);
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) && esTab){
				var creditoBeanCon = {
  				'creditoID':$('#creditoID').val()
				};

				creditosServicio.consulta(catTipoConsultaCredito.principal,creditoBeanCon,function(credito) {
						if(credito!=null){
							$('#comentarioCred').val('')
							$('#clienteID').val(credito.clienteID);
							var cliente = $('#clienteID').asNumber();
							if(cliente>0){
								listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, credito.cuentaID, numCredito);
								consultaSPL = consultaPermiteOperaSPL(cliente,'LPB',esCliente);
							
								if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
									expedienteBean = consultaExpedienteCliente(cliente);
									if(expedienteBean.tiempo<=1){
										if (alertaCte(cliente) != 999) {
										if(credito.esAgropecuario == Constantes.NO){
											esTab=true;
											var Estatus_Autorizado='A';
											var Estatus_Vigente='V';
											consultaCliente('clienteID');
											$('#tipoDispersion').val(credito.tipoDispersion);
											$('#lineaCreditoID').val(credito.lineaCreditoID);
											consultaLineaCredito('lineaCreditoID');
											$('#producCreditoID').val(credito.producCreditoID);
											consultaProducCredito('producCreditoID', credito.grupoID);
											$('#cuentaID').val(credito.cuentaID);
											$('#montoCredito').val(credito.montoCredito);
											$('#monedaID').val(credito.monedaID);
											consultaMoneda('monedaID');
											$('#fechaInicio').val(credito.fechaInicio);
											$('#fechaVencimien').val(credito.fechaVencimien);
											$('#factorMora').val(credito.factorMora);
											$('#estatus').val(credito.estatus);
											$('#solicitudCreditoID').val(credito.solicitudCreditoID);

											habilitaBoton('desembolsar', 'submit');

											if(credito.tipCobComMorato == 'T') {
												$('#lblveces').text('Tasa Fija Anualizada');
											} else {
												$('#lblveces').text('Veces la Tasa de Interés Ordinaria');
											}

											if(credito.estatus != Estatus_Autorizado && credito.estatus!=Estatus_Vigente){
												mensajeSis("El Crédito debe estar Autorizado.");
												deshabilitaBoton('desembolsar', 'submit');
												$('#creditoID').focus();
												$('#creditoID').select();
											}else
												if(credito.estatus == Estatus_Vigente){
													mensajeSis("El Crédito se encuentra Desembolsado.");
													deshabilitaBoton('desembolsar', 'submit');
													$('#creditoID').focus();
													$('#creditoID').select();
												}

											else{

													creditoBeanCon = {
										  				'creditoID': $('#creditoID').val()
													};

													creditosServicio.consulta(catTipoConsultaCredito.impPagare,creditoBeanCon,function(creditoPagare) {
														if(credito!=null){

															if(creditoPagare.pagareImpreso != "S"){
																mensajeSis("El Pagaré No ha Sido Impreso.");
																deshabilitaBoton('desembolsar', 'submit');
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
																							deshabilitaBoton('desembolsar', 'submit');
																							$('#creditoID').focus();
																							$('#creditoID').select();
																						}
																					}


																				}
																			});
																	}
															}

														}
													});
											}
										    consultaHuellaCliente();

										    if(funcionHuella == 'S' && autorizaHuellaCliente == 'S'){
												validaHuellaCliente();
											}

										} else {
											inicializaForma('formaGenerica','creditoID');
											deshabilitaBoton('desembolsar', 'submit');
											mensajeSis('El Crédito es Agropecuario.<br>Favor de Consultarlo en el Módulo <i><u>Créditos Agro</u></i>.');
											$('#creditoID').focus();
											$('#creditoID').select();
											tab2 = false;
										}
									} else {
										inicializaForma('formaGenerica','creditoID');
										deshabilitaBoton('desembolsar', 'submit');
										mensajeSis('Es necesario Actualizar el Expediente del Cliente para Continuar.');
										$('#creditoID').focus();
										$('#creditoID').select();
										tab2 = false;
									}
									}
								} else {
									inicializaForma('formaGenerica','creditoID');
									deshabilitaBoton('desembolsar', 'submit');
									mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
									$('#creditoID').focus();
									$('#creditoID').select();
									tab2 = false;
								}
							}
						}else{
							inicializaForma('formaGenerica','creditoID');
							deshabilitaBoton('desembolsar', 'submit');
							mensajeSis("No Existe el Crédito.");
								$('#creditoID').focus();
								$('#creditoID').select();
								tab2 = false;
							}
				});

			}
	}

		function consultaCreditoValida(control) {
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) && esTab){
				var creditoBeanCon = {
  				'creditoID':$('#creditoID').val()
				};
				creditosServicio.consulta(catTipoConsultaCredito.principal,creditoBeanCon,function(credito) {
						if(credito!=null){
							$('#clienteID').val(credito.clienteID);
							var cliente = $('#clienteID').asNumber();
							if(cliente>0){
								listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, credito.cuentaID, numCredito);
								if(listaPersBloqBean.estaBloqueado!='S'){
									expedienteBean = consultaExpedienteCliente(cliente);
									if(expedienteBean.tiempo<=1){
										if(credito.esAgropecuario == Constantes.NO){
											esTab=true;
											var Estatus_Vigente='V';
											var Estatus_Procesado = 'M';
											var Estatus_Desembolsado = 'D';
											var Estatus_Pagado = 'P';
											var Estatus_Castigado = 'K';
											var Estatus_Vencido = 'B';
											var Estatus_Cancelado = 'C';
											consultaCliente('clienteID');
											$('#lineaCreditoID').val(credito.lineaCreditoID);
											consultaLineaCredito('lineaCreditoID');
											$('#producCreditoID').val(credito.producCreditoID);
											consultaProducCredito('producCreditoID', credito.grupoID);
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

											habilitaBoton('desembolsar', 'submit');

											if(credito.estatus != Estatus_Procesado &&
												credito.estatus != Estatus_Desembolsado &&
												credito.estatus != Estatus_Vigente &&
												credito.estatus != Estatus_Pagado &&
												 credito.estatus != Estatus_Castigado &&
												 credito.estatus != Estatus_Vencido &&
												 credito.estatus != Estatus_Cancelado
												 ){
												mensajeSis("El Crédito debe estar Procesado.");
												deshabilitaBoton('desembolsar', 'submit');
												$('#creditoID').focus();
												$('#creditoID').select();
											}else
												if(credito.estatus == Estatus_Vigente ||
												 credito.estatus == Estatus_Desembolsado ||
												  credito.estatus == Estatus_Pagado ||
												   credito.estatus == Estatus_Castigado ||
												   credito.estatus == Estatus_Vencido ||
												   credito.estatus == Estatus_Cancelado){
													mensajeSis("El Crédito se encuentra Desembolsado.");
													deshabilitaBoton('desembolsar', 'submit');
													$('#creditoID').focus();
													$('#creditoID').select();
												}

												else{

													creditoBeanCon = {
										  				'creditoID': $('#creditoID').val()
													};

													creditosServicio.consulta(catTipoConsultaCredito.impPagare,creditoBeanCon,function(creditoPagare) {
														if(credito!=null){

															if(creditoPagare.pagareImpreso != "S"){
																mensajeSis("El Pagaré No ha Sido Impreso.");
																deshabilitaBoton('desembolsar', 'submit');
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
																							deshabilitaBoton('desembolsar', 'submit');
																							$('#creditoID').focus();
																							$('#creditoID').select();
																						}
																					}
																				}
																			});
																	}
															}

														}
													});
											}
										    consultaHuellaCliente();

										} else {
											inicializaForma('formaGenerica','creditoID');
											deshabilitaBoton('desembolsar', 'submit');
											mensajeSis('El Crédito es Agropecuario.<br>Favor de Consultarlo en el Módulo <i><u>Créditos Agro</u></i>.');
											$('#creditoID').focus();
											$('#creditoID').select();
											tab2 = false;
										}
									} else {
										inicializaForma('formaGenerica','creditoID');
										deshabilitaBoton('desembolsar', 'submit');
										mensajeSis('Es necesario Actualizar el Expediente del Cliente para Continuar.');
										$('#creditoID').focus();
										$('#creditoID').select();
										tab2 = false;
									}
								} else {
									inicializaForma('formaGenerica','creditoID');
									deshabilitaBoton('desembolsar', 'submit');
									mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
									$('#creditoID').focus();
									$('#creditoID').select();
									tab2 = false;
								}
							}
						}else{
							inicializaForma('formaGenerica','creditoID');
							deshabilitaBoton('desembolsar', 'submit');
							mensajeSis("No Existe el Crédito.");
								$('#creditoID').focus();
								$('#creditoID').select();
								tab2 = false;
							}
				});

			}
	}

	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var tipCon = 9;
		setTimeout("$('#cajaLista').hide();", 200);

		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipCon,numCliente, {async: false, callback: function(cliente) {
						if(cliente!=null){
							$('#clienteID').val(cliente.numero);
							$('#nombreCliente').val(cliente.nombreCompleto);
							tipoPersona = cliente.tipoPersona;
						}else{
							mensajeSis("No Existe el Cliente.");
							$('#clienteID').focus();
							$('#clienteID').select();
						}
				}});
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

function consultaLineaCredito(idControl) {
		var jqLinea  = eval("'#" + idControl + "'");
		var lineaCred = $(jqLinea).val();
		var lineaCreditoBeanCon = {
			'lineaCreditoID'	:lineaCred
		};

		setTimeout("$('#cajaLista').hide();", 200);
		if(lineaCred != '' && !isNaN(lineaCred) && esTab){
			lineasCreditoServicio.consulta(catTipoConsultaCredito.principal,lineaCreditoBeanCon,function(linea) {

					if(linea!=null){
						$('#saldoDisponible').val(linea.saldoDisponible);
						$('#saldoDeudor').val(linea.saldoDeudor);
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
						if(prodCred.esGrupal == 'S' && grupoID > 0){
							mensajeSis("Producto de Crédito Reservado para Créditos Grupales.");
							deshabilitaBoton('desembolsar', 'submit');
							inicializaForma('formaGenerica','creditoID');
							$('#monedaDes').val("");
							tab2=false;
							$('#creditoID').focus();
						}
					}else{
						mensajeSis("No Existe el Producto de Crédito.");
					}
			});
			}
		}



			// función para consultar si el cliente ya tiene huella digital registrada
			function consultaHuellaCliente(){
				var numCliente=$('#clienteID').val();
				var tipoConsultahuella = 1;
				if (tipoPersona == 'M'){
					tipoConsultahuella = 3;
				}
				if(numCliente != '' && !isNaN(numCliente )){
					var clienteIDBean = {
						'personaID':$('#clienteID').val()
						};
					huellaDigitalServicio.consulta(tipoConsultahuella,clienteIDBean,function(cliente) {
						if (cliente==null){
							var huella=parametroBean.funcionHuella;
							if(huella =="S" && huellaProductos=="S" && autorizaHuellaCliente=="S"){
								mensajeSis("El Cliente no tiene Huella Registrada.\nFavor de Verificar.");
								$('#creditoID').focus();
								deshabilitaBoton('desembolsar','submit');
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

	function validaAutorizacionHuellaCliente(){
		paramGeneralesServicio.consulta(35,{},function(parametro){
			if (parametro != null) {
				autorizaHuellaCliente = parametro.valorParametro;
			} else {
				autorizaHuellaCliente = 'N';
				mensajeSis('Ha ocurrido un error al consultar los parámetros del sistema.');
			}
		});
	}

	// función para consultar si el cliente ya tiene huella digital registrada
	function validaHuellaCliente(){

		var numCliente=$('#clienteID').val();
		var tipoConsultahuella = 1;
				if (tipoPersona == 'M'){
					tipoConsultahuella = 3;
				}
		if(numCliente != '' && !isNaN(numCliente )){
			var huellaDigitalBean = {
				'personaID'	  :$('#clienteID').val(),
				'cuentaAhoID' :$('#cuentaID').val()
			};

			huellaDigitalServicio.consulta(catHuellaDigital.noHuellas, huellaDigitalBean, {
				async: false,
				callback:function(huellaDigitalBeanResponse) {
					if (huellaDigitalBeanResponse != null){
						if (huellaDigitalBeanResponse.noHuellas == 0 || huellaDigitalBeanResponse.noHuellas == '0'){
							mensajeSis("No es posible realizar la operación. <br>El cliente no tiene una huella registrada.");
							huellaCliente = 'N';
							deshabilitaBoton('desembolsar', 'submit');
							return false;
						}else {
							huellaCliente = 'S';
							habilitaBoton('desembolsar', 'submit');
						}
					}else {
						mensajeSis("Ha ocurrido un error al consultar el No. de Huellas del cliente y los firmantes.");
					}
				},
				errorHandler : function(message, exception) {
					mensajeSis("Error en Consulta de Huellas Digitales del Cliente.<br>" + message + ":" + exception);
				}
			});
		}
	}
});

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

function funcionExito() {
	if($('#numeroMensaje').val()){
	}
}

function funcionError() {
}

function validaUsuario(control) {
	var claveUsuario = $('#claveUsuarioAut').val();
	serverHuella.cancelarOperacionActual();
	$('#statusSrvHuella').hide();
	$('#contraseniaAut').show();
	if(claveUsuario != ''){
		var usuarioBean = {
				'clave':claveUsuario
		};
		usuarioServicio.consulta(3, usuarioBean, function(usuario) {
						if(usuario!=null){
							accedeHuella = usuario.accedeHuella;
							huella_nombreCompleto = usuario.clave;
							huella_usuarioID = usuario.usuarioID;
							huella_OrigenDatos = usuario.origenDatos;
							$('#encriptaContrasenia').val(usuario.contrasenia);
							if(accedeHuella=='S'){
								$('#statusSrvHuella').show(500);
							}else{
								$('#statusSrvHuella').hide();
							}
						}else{
							mensajeSis('El Usuario Ingresado No Existe');
							accedeHuella=='N';
						}
			});
	}
}