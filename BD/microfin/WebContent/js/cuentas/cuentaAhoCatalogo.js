$(document)
		.ready(
				function() {
					esTab = true;
					var cble = '';
					var autorizada='';
					var intitucionID = '';
					var telCelCliente = '';
					$('#clienteID').focus();
					// Definicion de Constantes y Enums
					var catTipoTransaccionCtaAho = {
						'agrega' : '1',
						'modifica' : '2',
					};

					// Definicion de Constantes y Enums
					var catTipoConsultaInstituciones = {
						'principal' : 1,
						'foranea' : 2
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
					
					consultaSPL = {
							'opeInusualID' : 0,
							'numRegistro' : 0,
							'permiteOperacion' : 'S',
							'fechaDeteccion' : '1900-01-01'
					};
					
					var esCliente 			='CTE';

					// ------------ Metodos y Manejo de Eventos
					// -----------------------------------------
					deshabilitaBoton('modifica', 'submit');
					deshabilitaBoton('agrega', 'submit');
					inicializaForma('formaGenerica', 'clienteID');
					$('#lbclabe').hide();
					$('#clabe').hide();
					
					$('#lbInstitucion').hide();
					$('#institucionID').hide();
					$('#nombreInstitucion').hide();
					
					
					
					
					
					
					consultaParametros();
					consultaTiposCuenta();
					
					if($('#flujoCliNumCli').val() != undefined){
						if(!isNaN($('#flujoCliNumCli').val())){
							var numCliFlu = Number($('#flujoCliNumCli').val());
							if(numCliFlu > 0){
								$('#clienteID').val($('#flujoCliNumCli').val());
								consultaCliente('clienteID');
								if($('#flujoCliSolCue').val() != undefined){
									if(!isNaN($('#flujoCliSolCue').val())){
										var SolCuentaFlu = Number($('#flujoCliSolCue').val());
										if(SolCuentaFlu > 0){
											$('#cuentaAhoID').val($('#flujoCliSolCue').val());
											validaCtaAho('cuentaAhoID');
										}else{
											$('#cuentaAhoID').val('0');
											$('#cuentaAhoID').focus().select();
										}
									}
								}
								
							}else{
								mensajeSis('No se puede Agregar una Solicitud de Cuenta sin Cliente');
							}
						}
					}
					
					
					$(':text').focus(function() {
						esTab = false;
					});

					$.validator.setDefaults({
						submitHandler : function(event) {
							grabaFormaTransaccion(event, 'formaGenerica',
									'contenedorForma', 'mensaje', 'true',
									'cuentaAhoID');
						}
					});

					$(':text').bind('keydown', function(e) {
						if (e.which == 9 && !e.shiftKey) {
							esTab = true;
						}
					});

					$('#agrega').click(
							function() {
								$('#tipoTransaccion').val(
										catTipoTransaccionCtaAho.agrega);
							});

					$('#modifica').click(
							function() {
								$('#tipoTransaccion').val(
										catTipoTransaccionCtaAho.modifica);
							});

					$('#agrega').attr('tipoTransaccion', '1');
					$('#modifica').attr('tipoTransaccion', '2');

					$('#cuentaAhoID').blur(function() {
						validaCtaAho(this.id);
					});

					$('#cuentaAhoID').bind(
							'keyup',
							function(e) {
								var camposLista = new Array();
								var parametrosLista = new Array();
								camposLista[0] = "clienteID";
								parametrosLista[0] = $('#clienteID').val();
								listaAlfanumerica('cuentaAhoID', '0', '9',
										camposLista, parametrosLista,
										'cuentasAhoListaVista.htm');
							});

					$('#clienteID').bind('keyup',function(e) {
										if (this.value.length >= 1) {
											listaAlfanumerica('clienteID', '1',	'1', 'nombreCompleto',$('#clienteID').val(),'listaCliente.htm');
										}
									});

	$('#clienteID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		var cliente = $('#clienteID').asNumber();
		if (cliente > 0) {
			listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, 0, 0);
			consultaSPL = consultaPermiteOperaSPL(cliente,'LPB',esCliente);
			if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
				expedienteBean = consultaExpedienteCliente($('#clienteID').val());
				if (expedienteBean.tiempo <= 1) {
					if (alertaCte(cliente) != 999) {
						consultaCliente(this.id);
					}
				} else {
					mensajeSis('Es necesario Actualizar el Expediente del Cliente para Continuar.');
					limpiaCampos();
					inicializaForma('formaGenerica', 'clienteID');
					$('#clienteID').focus();
					$('#clienteID').val('');
				}
			} else {
				mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
				limpiaCampos();
				inicializaForma('formaGenerica', 'clienteID');
				$('#clienteID').focus();
				$('#clienteID').val('');
			}
		}
	});

					$('#tipoCuentaID').change(function() {
						consultaTipoCta($('#tipoCuentaID').val());
					});

					$('#sucursalID').blur(function() {
						consultaSucursal(this.id);
					});

					$('#monedaID').blur(function() {
						consultaMoneda(this.id);
					});

					$('#institucionID').bind('keyup',function(e) {
								listaAlfanumerica('institucionID', '1', '1','nombre', $('#institucionID').val(),'listaInstituciones.htm');
							});
					

					$('#institucionID').blur(function() {
						consultaInstitucion(this.id);
					});
		

					$('#telefonoCelular').setMask('phone-us');
					// ------------ Validaciones de la Forma
					// -------------------------------------
				
					$('#formaGenerica').validate({
						rules : {
							clienteID : 'required',
							sucursalID : 'required',
							cuentaAhoID : 'required',
							tipoCuentaID : 'required',
							monedaID : 'required',
							fechaReg : 'required',
							etiqueta : 'required',
							telefonoCelular : {
							minlength : 14
								},
						},
						messages : {
							clienteID : 'Especifique número de cliente',
							sucursalID : 'Especifique la sucursal',
							cuentaAhoID : 'Especifique la '+ $('#varSafilocale').val(),
							tipoCuentaID : 'Especifique tipo de cuenta',
							monedaID : 'Especifique tipo de moneda',
							fechaReg : 'Especifique Fecha de Registro',
							etiqueta : 'Especifique Etiqueta',
							telefonoCelular: {
							minlength : 'Especifique 10 Digitos'
								},
								
						}
					});

					// ------------ Validaciones de Controles
					// -------------------------------------
					function validaCtaAho(control) {
						var numCta = $('#cuentaAhoID').val();
						var tipConPantallaR = 3;
						var CuentaAhoBeanCon = {
							'cuentaAhoID' : numCta
						};
						setTimeout("$('#cajaLista').hide();", 200);
						if (numCta != '' && !isNaN(numCta) ) {
							if (numCta == '0') {
								$('#clabe').val('');
								$('#tipoCuentaID').show();
								$('#tipoCta').hide();
								habilitaBoton('agrega', 'submit');
								deshabilitaBoton('modifica', 'submit');
								inicializaForma('formaGenerica', 'cuentaAhoID');
								$('#telefonoCelular').val(telCelCliente);
								$('#telefonoCelular').setMask('phone-us');
								consultaParametros();
								$('#tipoCuentaID').val(0).selected = true;
								$(tipoCuentaID).removeAttr('disabled');
								ocultarClabe();
								
								
								habilitaControl('tipoCuentaID');
							} else {
								deshabilitaBoton('agrega', 'submit');
								habilitaBoton('modifica', 'submit');
								
								
								if($('#flujoCliNumCli').val() != undefined){
									if(!isNaN($('#flujoCliNumCli').val())){
										var numCliFlu = Number($('#flujoCliNumCli').val());
										if(numCliFlu > 0){
											$('#flujoCliSolCue').val(numCta);
										}
									}
								}
								
								cuentasAhoServicio.consultaCuentasAho(tipConPantallaR,CuentaAhoBeanCon,function(cuenta) {
													if (cuenta != null) {
												
														dwr.util.setValues(cuenta);
														autorizada=cuenta.estatus;
														consultaMoneda('monedaID');
														consultaClienteCta('clienteID');
														consultaSucursal('sucursalID');
														consultaTipoCta(cuenta.tipoCuentaID);
														$('#telefonoCelular').setMask('phone-us');
														$('#tipoCuentaID').val(cuenta.tipoCuentaID).selected = true;
														
									
														if (cuenta.esPrincipal == 'S') {
															$('#esPrincipal').val(cuenta.esPrincipal).selected = true;

															if(cuenta.telefonoCelular == '' || cuenta.telefonoCelular == null){
																if($('#cuentaAhoID').val() == '0'){
																	$('#telefonoCelular').val(telCelCliente);
																}
																
															}
																
														} else {
															$('#esPrincipal').val('N').selected = true;
															
															if(cuenta.telefonoCelular == '' || cuenta.telefonoCelular == null){
																if($('#cuentaAhoID').val() == '0'){
																	$('#telefonoCelular').val(telCelCliente);
																}
																
															}
														}

														cble = cuenta.clabe;
														intitucionID = cuenta.institucionID;
														deshabilitaBoton('agrega','submit');
														habilitaBoton('modifica','submit');
					
														if(cuenta.estatus!='A' || cuenta.estatus!='C' || cuenta.estatus!='I' || cuenta.estatus!='B'){
															habilitaControl('tipoCuentaID');
															$('#tipoCuentaID').focus();	
																										
															}
														else{
															$('#tipoCuentaID').attr('disabled','disabled');
															deshabilitaControl('tipoCuentaID');
															$('#etiqueta').focus();	
														
														}
														
													} else {
														mensajeSis("No Existe la "+ $('#varSafilocale').val());
														deshabilitaBoton('modifica','submit');
														deshabilitaBoton('agrega','submit');
														$('#tipoCuentaID').val('');
														$('#clabe').val('');
														$('#institucionID').val('');
														$('#monedaID').val('');
														$('#moneda').val('');
														$('#etiqueta').val('');
														consultaParametros();
														$('#cuentaAhoID').val("");
														$('#cuentaAhoID').focus();
														$('#cuentaAhoID').select();
														$('#tiposCtaAlt').show();
														$('#tiposCtaCon').hide();
													}
												
												});
							}
						}
					}

					// Método de consulta de Institución
					function consultaInstitucion(idControl) {
						var jqInstituto = eval("'#" + idControl + "'");
						var numInstituto = $(jqInstituto).val();
						setTimeout("$('#cajaLista').hide();", 200);
						var InstitutoBeanCon = {
							'institucionID' : numInstituto
						};

						if (numInstituto != '' && !isNaN(numInstituto) && esTab) {
							institucionesServicio.consultaInstitucion(
									catTipoConsultaInstituciones.foranea,
									InstitutoBeanCon, function(instituto) {
										if (instituto != null) {
											$('#nombreInstitucion').val(
													instituto.nombre);
										}
									});
						}
					}

					function esBancaria(numTipoCta) {
						var tipoCon = 3;
						var tiposCuenta = {
							'tipoCuentaID' : numTipoCta
						};
						tiposCuentaServicio.consulta(tipoCon,tiposCuenta, function(tiposCuenta) {
											if (tiposCuenta != null) {
												if (tiposCuenta.esBancaria == 'S') {
													$('#clabe').val(cble);
													$('#institucionID').val(intitucionID);
													consultaInstitucion('institucionID');
													muestraCalbeEsBancaria();
													deshabilitaBoton('modifica','submit');
													deshabilitaBoton('agrega','submit');
												    deshabilitaControl('tipoCuentaID');
													deshabilitaControl('estadoCta');
													deshabilitaControl('esPrincipal');
													deshabilitaControl('etiqueta');

												} else {
													participaSPEI(numTipoCta);
														if(autorizada == 'A' || autorizada == 'B' || autorizada == 'I' || autorizada == 'C'){
																if($('#cuentaAhoID').val()!='0' || $('#cuentaAhoID').val()>'0'){
																	deshabilitaControl('tipoCuentaID');	
																	$('#etiqueta').focus();
																}
																else{
																	habilitaControl('tipoCuentaID');	
																	$('#tipoCuentaID').focus();
																}
																
															}
															else{
																habilitaControl('tipoCuentaID');
																$('#tipoCuentaID').focus();
															}
													
													habilitaControl('estadoCta');
													habilitaControl('esPrincipal');
													habilitaControl('etiqueta');
												}
											}
										 
										});
					}

					
					
					function participaSPEI(numTipoCta) {
						var tipoCon = 4;
						var tiposCuenta = {
							'tipoCuentaID' : numTipoCta
						};
						tiposCuentaServicio.consulta(tipoCon,tiposCuenta,{ async: false, callback:function(tiposCuenta) {
											if (tiposCuenta != null) {
												if ($('#clabe').val() != '' && $('#cuentaAhoID').val() != '0') {
													muestraClabeSpei();
													$('#clabe').val(cble);
												} else {
													ocultarClabe();
													$('#clabe').val('');
													$('#institucionID').val('');
													$('#nombreInstitucion').val('');												}
											}
										 }
										});
					}
			
					
					function consultaCliente(idControl) {
						var jqCliente = eval("'#" + idControl + "'");
						var numCliente = $.trim($(jqCliente).val());
						var conCliente = 1;
						var rfc = '';
						ocultarClabe();
						setTimeout("$('#cajaLista').hide();", 200);
						if (numCliente != '' && !isNaN(numCliente)) {
							clienteServicio.consulta(conCliente,numCliente,	rfc,function(cliente) {
												if (cliente != null) {							
												if(cliente.clasificacion != 'L'){
													$('#clienteID').val(cliente.numero);
													$('#nombreCte').val(cliente.nombreCompleto);
													deshabilitaBoton('modifica','submit');
													deshabilitaBoton('agrega','submit');
													$('#tipoCuentaID').val('');
													$('#clabe').val('');
													$('#institucionID').val('');
													$('#monedaID').val('');
													$('#moneda').val('');
													$('#etiqueta').val('');
													$('#cuentaAhoID').val('');
													$('#telefonoCelular').val('');
													consultaParametros();
													$('#cuentaAhoID').focus();
													$('#cuentaAhoID').select();
													$(tipoCuentaID).removeAttr('disabled');
													$('#tiposCtaAlt').show();
													$('#tiposCtaCon').hide();
													
													telCelCliente = cliente.telefonoCelular;
												
													
											
									
													
													if(cliente.estatus=="I"){
														deshabilitaBoton('modifica','submit');
														deshabilitaBoton('agrega','submit');
														mensajeSis("El Cliente se encuentra Inactivo");
														$('#clienteID').val('');
														$('#nombreCte').val('');
														$('#clienteID').focus();
													}
												}else{
													mensajeSis('La Clasificación de Tipo "Cliente Nivel 1" No Tiene Permitido Solicitar '+ $('#varSafilocale').val());
													$(jqCliente).val('');
													$(jqCliente).focus().select();
												}
											} else {
													mensajeSis("No Existe el Cliente");
													$(jqCliente).val("");
													$(jqCliente).focus();
													$(jqCliente).select();
													limpiaCampos();
												}
											});
						}
					}

					function consultaClienteCta(idControl) {
						var jqCliente = eval("'#" + idControl + "'");
						var numCliente = $.trim($(jqCliente).val());
						var conCliente = 2;
						var rfc = '';
						setTimeout("$('#cajaLista').hide();", 200);
						if (numCliente != '' && !isNaN(numCliente)) {
							clienteServicio.consulta(conCliente,numCliente,rfc,	function(cliente) {
												if (cliente != null) {
													$('#clienteID').val(cliente.numero);
													$('#nombreCte').val(cliente.nombreCompleto);
												} else {
													mensajeSis("No Existe el Cliente");
													$(jqCliente).focus();
													$(jqCliente).select();
													limpiaCampos();
												}
											});
						}
					}

					function consultaTipoCta(numTipoCta) {
						var numCta = $('#cuentaAhoID').val();
						var conTipoCta = 2;
						var TipoCuentaBeanCon = {
							'tipoCuentaID' : numTipoCta
						};
						if (numCta == 0) {
							$(tipoCuentaID).removeAttr('disabled');
						}
						setTimeout("$('#cajaLista').hide();", 200);
						if (numTipoCta != '' && !isNaN(numTipoCta)) {
							tiposCuentaServicio.consulta(conTipoCta,TipoCuentaBeanCon, function(tipoCuenta) {
										if (tipoCuenta != null) {
											$('#monedaID').val(tipoCuenta.monedaID);
											consultaMoneda('monedaID');
											esBancaria(numTipoCta);
											
										} else {
											$(jqTipoCta).focus();
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
							sucursalesServicio.consultaSucursal(conSucursal,numSucursal, function(sucursal) {
										if (sucursal != null) {
											$('#sucursalID').val(sucursal.sucursalID);
											$('#sucursal').val(sucursal.nombreSucurs);
										} else {
											mensajeSis("No Existe la Sucursal");
											$(jqSucursal).focus();
										}
									});
						}
					}

					function consultaMoneda(idControl) {
						var jqMoneda = eval("'#" + idControl + "'");
						var numMoneda = $(jqMoneda).val();
						var conMoneda = 2;
						setTimeout("$('#cajaLista').hide();", 200);
						if (numMoneda != '' && !isNaN(numMoneda)) {
							monedasServicio.consultaMoneda(conMoneda,numMoneda,
											function(moneda) {
												if (moneda != null) {
													$('#moneda').val(moneda.descripcion);
												} else {
													mensajeSis("No Existe el Tipo de Moneda");
													$(jqMoneda).focus();
												}
											});
						}
					}

					function consultaParametros() {
						var parametroBean = consultaParametrosSession();
						$('#sucursalID').val(parametroBean.sucursal);
						$('#sucursal').val(parametroBean.nombreSucursal);
						$('#fechaReg').val(parametroBean.fechaSucursal);
					}

					function consultaTiposCuenta() {
						dwr.util.removeAllOptions('tipoCuentaID');
						dwr.util.addOptions('tipoCuentaID', {'' : 'SELECCIONAR'});
						var bean={};
						tiposCuentaServicio.listaCombo(10,bean,function(tiposCuenta) {
									dwr.util.addOptions('tipoCuentaID',	tiposCuenta, 'tipoCuentaID','descripcion');
								});
					}

					function limpiaCampos() {
						$('#cuentaAhoID').val('');
						$('#nombreCte').val('');						
						$('#tipoCuentaID').val('');
						$('#clabe').val('');
						$('#institucionID').val('');
						$('#monedaID').val('');
						$('#moneda').val('');
						$('#etiqueta').val('');
						consultaParametros();
					}
					
					

			
					
					function ocultarClabe(){
						$('#lbclabe').hide();
						$('#clabe').hide();
						
						$('#lbInstitucion').hide();
						$('#institucionID').hide();
						$('#nombreInstitucion').hide();
					}
					
					
					function muestraClabeSpei(){
						$('#lbclabe').show();
						$('#clabe').show();
						
						$('#lbInstitucion').hide();
						$('#institucionID').hide();
						$('#nombreInstitucion').hide();
					
					}
					
					
					function muestraCalbeEsBancaria(){
						$('#lbclabe').show();
						$('#clabe').show();
						
						$('#lbInstitucion').show();
						$('#institucionID').show();
						$('#nombreInstitucion').show();
					
					}
				});


function ayudaCR(){	
	var data;
	
				       
	data ='<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 
			'<table id="tablaLista">'+
				'<tr align="left">'+
					'<td id="contenidoAyuda"><b>El Teléfono Celular proporcionado será asociado a su Cuenta de Ahorro '+
				     'para el uso en Aplicaciones Móviles</b></td>'+
				'</tr>'+
				
			'</table>'+
			'<br>'+
			'</fieldset>'; 
	
	$('#ContenedorAyuda').html(data); 
	$.blockUI({message: $('#ContenedorAyuda'),
				   css: { 
                top:  ($(window).height() - 400) /2 + 'px', 
                left: ($(window).width() - 400) /2 + 'px', 
                width: '400px' 
            } });  
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		      
}