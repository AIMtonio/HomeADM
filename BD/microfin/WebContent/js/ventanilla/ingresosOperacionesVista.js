
		var Var_Poliza				='';
		var Var_ChequeInterno		='I';
		var Var_ChequeExterno		='E';
		var nombreCortoInstitucion 	='';
		var recepChequeSBC			=18;
		var mostrarBotones			= 'S';
		var Busqueda				= '';
		var parametroBean 			= consultaParametrosSession();
		var numeroCuenta 			= 0; // sirve para validar cobro seguro vida ayuda
		var OpeCambioefectivo 		= 11;
		var EstatusCteInactivo		= 'I';		// estatus cliente inactivo
		var noEsMenor 				= 'N';
		var Con_Efectivo			= 'E';
		var mostrarAlertLimite		= 0;
		var mensajeLimite 			= '';
		var esAgropecuario			= 'N';
		var catFormTipoCalInt = {
				'principal'	: 1,
		};
		var TasaFijaID 				= 1; // ID de la formula para tasa fija (FORMTIPOCALINT)
		var VarTasaFijaoBase		= 'Tasa Fija Anualizada'; // Texto que indica si se trata de tasa fija o tasa base actual
		var identificaSocioTarjeta = 0;
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

		var esProspecto 		='PRO';
		var esCliente 			='CTE';
		var esUsuario			='USS';
		var cobraAccesoriosGen;
		var garFinanciada 		= 'N';
		var cuotasMaxProyectar = 0;	// Cuotas Maximas a Proyectar

		$(document).ready(function() {

			var serverHuella = new HuellaServer({
			fnHuellaValida:	function(datos){
									grabaFormaTransaccionVentanilla({}, 'formaGenerica', 'contenedorForma', 'mensaje','true','numeroTransaccion');
								},
			fnHuellaInvalida: function(datos){
									mensajeSis(datos.mensajeRespuesta);
									deshabilitaBoton("grabar");
									return false;
								}
		});
			deshabilitaBoton('verFirmas', 'submit');
			$('#tarjetaIdentiCA').hide();
			$('#numeroTarjeta').val("");
			$('#idCtePorTarjeta').val("");
			$('#nomTarjetaHabiente').val("");
			$('#usuarioLogueado').val(parametroBean.claveUsuario);
		esTab = true;
		$('#tipoOperacion').focus();



		//Definicion de Constantes y Enums
		var catTipoTransaccionVen = {
			'cargoCuenta'		:'1',
			'abonoCuenta'		:'2',
			'pagoCredito'		:'3', 	//pago de Credito con Cargo a Cuenta
			'garantiaLiq'		:'4',
			'pagoCreditoGrupal'	:'5', 	//pago de Credito grupa||
		  	'comisionApertura'	:'6', 	//comision por Apertura
		  	'desembolsoCredito'	:'7',	 //desembolso Credito
		  	'devolucionGL'		:'8', 	//devolucion de garantia liquida
		  	'aplicaSeguroVida'	:'9',	// pago del seguro de Vida
		  	'cobroSeguroVida'	:'10',	// pago del seguro de Vida
			'cambioEfectivo'	:'11',	// Cambio de Efectivo en caja
			'transferenciaCuenta':'12',	// Transferencia entre cuentas
			'aportacionSocial'	:'13',	// Aportacion Social
			'devAportacionSocio':'14',	// Devolucion de la aportacion Social
			'cobroSegVidaAyuda'	:'15',	// Seguro de Vida Ayuda
			'aplicaSegVidaAyuda':'16',	// Aplicacion del Seguro de Vida Ayuda
			'pagoRemesas'		:'17',
			'pagoOportunidades'	:'18',
			'recepcionChequeSBC':'19',
			'aplicaChequeSBC'	:'20',
			'prepagoCredito'	: '21' ,
			'prepagoCreditoGrupal' :'22',
			'pagoServicios' 	:'23',
			'recuperaCartera' 	:'24',
			'pagoCancelSocio' 	:'25',	// pago por cancelacion de socio
			'pagoServifun' 		:'27',
			'cobroApoyoEscolar'	:'28',
			'ajusteSobrante'	:'29',
			'ajusteFaltante'	:'30',
			'anualidadTarjeta'	:'31',
			'anticiposGastos'	:'32',	//Gastos o Anticipos por Comprobar
			'devolucionesGastAnt':'33',	// Devoluciones de Gastos o Anticipos por Comprobar
			'haberesExmenor'	:'34',	//Reclamo Haberes Ex-Menor
			'pagoArrendamiento':'42',	//Pago de arrendamiento
			'pagoServiciosEnLinea':'43',
			'cobroAccesoriosCre' : '44', //Cobro de Accesorios Credito
			'depositoActivaCta' : '46' //DEPOSITO ACTIVACION DE CUENTA
			};
			//Definicion de Constantes y Enums
			var catTipoTicketVen = {
		  	  	'garantiaLiquidaAdicional'	:'10',	// Garantia liquida adicional
		  	  	'aportacionSocial'			:'11',  //aportacion social
		  	  	'devAportacionSocial'		:'12',  //aportacion social
		  	  	'cobroSegAyuda'				:'13', // cobro del seguro de Ayuda
		  	  	'pagoSegAyuda'				:'14', // cobro del seguro de Ayuda
		  	  	'pagoRemesa'				:'15',
		  	  	'pagoOportunidades'			:'16',
		  		'recepChequeSBC'			:'17',
		  		'aplicaChequeSBC'			:'18',
		  		'cartCastigada'				:'19',
		  		'pagoServifun'				:'20',
		  		'pagoApoyoEscolar'			:'21',
		  		'anualidaTD'				:'23',
		  	  	'pagoCancelSocio'			:'25',
		  	  	'anticiposGastos'			:'26',	//Ticket Gastos o Anticipos por Comprobar
		  	  	'devolucionesGastAnt'		:'27',	//Ticket Devoluciones de Gastos o Anticipos por Comprobar
		  	  	'haberesExmenor'			:'28'	//Ticket Reclamo Haberes  Exmenor
			};

			var catTipoConsultaCatalogoServ = {
					'principal' : 1
			};
			var catListaCatalogoServicio ={
				'combo'	: 2
			};
			var catTipoOrigenServicio = {
				'tercero' : 'T',
				'interno' : 'I'
			};

			var muestraAlertIntCtaGl= 0;
			var cargoCuenta 		= 1;
			var abonoCuenta 		= 2;
			var pagoCredito 		= 3;
			var garantiaLiq 		= 4;
			var devolucionGarLiq	= 5;
			var comAperCred 		= 6;
			var desemboCred 		= 7;
			var cobroSeguroVida		= 8;
			var aplicaSeguroVida	= 9;
			var tranferenciaCuenta	=10;
			var cambioEfectivo		=11;
			var aportacionSocio		=12;
			var devAportacionSocial	=13;
			var cobroSegVidaAyuda	=14;
			var pagoSeguroAyuda		=15;
			var pagoRemesas			=16;
			var pagoOportunidades	=17;
			var recepChequeSBC		=18;
			var aplicaChequeSBC		=19;
			var prepagoCredito		=20;
			var pagoServicios		=21;
			var RecupCarteraVencida	=22;
			var pargoServifun		=25;
			var cobroApoyoEscolar	=26;
			var ajusteSobrante		=27;
			var ajusteFaltante		=28;
			var anualidadTarjeta	=29;
			var pagoCancelSocio		=30;
			var gastosAnticiposV	=38;
			var devolucionesGastAnt	=39;
			var haberesExmenor		=40;
			var transferenciaInterna=41;
			var pagoArrendamiento=42;
			var pagoServiciosEnLinea=43;
			var cobroAccesoriosCre = 44;
			var depositoActivaCta = 46; //DEPOSITO ACTIVACION DE CUENTA

			var mil = parseFloat(1000);
			var quinientos = parseFloat(500);
			var doscientos = parseFloat(200);
			var cien = parseFloat(100);
			var cincuenta = parseFloat(50);
			var veinte = parseFloat(20);
			var monedaValor = parseFloat(1);
			var bloquearCaja = "no";
			var longitudIdentificacion = 0; // para pago de Remesas y oportunidades


			var rfcInst=parametroBean.rfcInst;
			var ivaSucursal=parametroBean.ivaSucursal;
			var telefono=parametroBean.telefonoLocal;
			var rfcInstitucion=parametroBean.rfcRepresentante;
			var sucursalID=parametroBean.sucursal;
			var direccionInstitucion=parametroBean.direccionInstitucion;
			var monedaBase=parametroBean.desCortaMonedaBase;
			var numeromonedaBase=parametroBean.numeroMonedaBase;
			var simboloMonedaBase=parametroBean.simboloMonedaBase;
			var descrpcion=parametroBean.nombreMonedaBase;
			var TipoImpresion=parametroBean.tipoImpTicket;
			var montoAportaSocio=parametroBean.montoAportacion;
			var numeroCaja=parametroBean.cajaID;
			var numeroUsuario=parametroBean.numeroUsuario;
			var tipoCajaSesion=parametroBean.tipoCaja;
			var montoPolizaSegAyuda=parametroBean.montoPolizaSegA;
			var montoSegAyuda=parametroBean.montoSegAyuda;
			var fechaSucursal=parametroBean.fechaSucursal;
			var saldo=parametroBean.impSaldoCred;
			nombreCortoInstitucion=  parametroBean.nombreCortoInst;

			var ticket='T';
			var procedePago = 2;
			var procedeGLAdi = 2;
			var creditoPagado = "N";
			var productoPermitePrepago	= '';

			$('#numeroUsuarios').val(numeroUsuario);
			$('#monedaCamEfectivoID').val(parametroBean.numeroMonedaBase);
			//-----------ocultamos campos
			$('#tdGrupoCreditoSC').hide();
			$('#tdGrupoCreditoSInputC').hide();
			$('#tdGrupoCicloSC').hide();
			$('#tdGrupoCicloSinputC').hide();
			$('#grupoDesSC').hide();
			$('#lblCreditoid').hide();

			$('#grupoIDSC').hide();
			$('#prepagos').hide();
			$('#impCheque').hide();
			$('#telefonoClienteServicio').setMask('phone-us');
			//------------ Metodos y Manejo de Eventos -----------------------------------------
			agregaFormatoControles('formaGenerica');

			consultarParametrosBean();
			inicializarEntradasSalidasEfectivo();
			consultaDisponibleDenominacion();
			inicializarCampos();
			inicializarCamposGL();
			consultaLimiteCaja();
			consultaOpcionesCaja(); //para el combo de Tipo de Operacion
			actualizaProceso($('#sucursalIDSesion').val(),$('#cajaIDSesion').val());// cambia el valor de bandera EjecutaProceso a 'N'
			revisarRecursosCargados();
			consultaComboCalInteres();
			muestraCamposTasa(0);
			$('#impPoliza').hide();
			deshabilitaControl('tipoPrepago');
			if (parametroBean.tipoCaja == '' || parametroBean.tipoCaja == undefined){
				mensajeSis('El Usuario No tiene una Caja Asignada.');
				deshabilitaItems();
			}else if (parametroBean.tipoCaja == 'CA' || parametroBean.tipoCaja == 'CP' || parametroBean.tipoCaja == 'BG'){
				estaAbiertaCaja($('#sucursalIDSesion').val(),$('#cajaIDSesion').val(),parametroBean.tipoCaja);

			}else{
				mensajeSis('El tipo de Caja No esta Definido Correctamente.');
				deshabilitaItems();
			}

			$(':text').focus(function() {
			 	esTab = false;
			});
			$('#huellaRequiere').val("");
			$.validator.setDefaults({
				submitHandler: function(event) {
					deshabilitaBoton('graba', 'submit');
					serverHuella.operacionEnProceso = false;
					bloquearCaja=consultaLimiteCaja();
					var funcionHuella = parametroBean.funcionHuella;
					if($('#tipoOperacion').val()=='2'){
						validaLimites();
					}


					if(validaListas()==0){
						if(bloquearCaja == "si"){
							deshabilitaBoton('graba', 'submit');
							$('#impTicket').hide();
							$('#impCheque').hide();
							ocultarBtnResumen();
						}else{
							if(bloquearCaja == "no"){
								if($('#numeroTransaccion').asNumber()>0 ){
									deshabilitaBoton('graba', 'submit');
								}else{
									if(creditoPagado=="S"){
										mensajeSis("El Crédito ya se encuentra Liquidado");
										deshabilitaBoton('graba', 'submit');
									}else{
										if($('#tipoTransaccion').val()==catTipoTransaccionVen.pagoCredito ||
												$('#tipoTransaccion').val()==catTipoTransaccionVen.pagoCreditoGrupal ){
											procedePago = validaFiniquito(event);
											if(procedePago ==2){
												deshabilitaBoton('graba', 'submit');
												$('#impTicket').hide();
												$('#impCheque').hide();
												ocultarBtnResumen();
											}else{
												if($('#grupoID').val() > 0){
													procedePago= validaSumaGarantiaAdicionalGrupo();
													if(procedePago ==2){
														deshabilitaBoton('graba', 'submit');
														$('#impTicket').hide();
														$('#impCheque').hide();
														ocultarBtnResumen();
													}else{
														crearListaCuentasGLAdicional();
														grabaFormaTransaccionVentanilla(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','numeroTransaccion');
													}
												}else{
													procedePago =1;
													grabaFormaTransaccionVentanilla(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','numeroTransaccion');
												}
											}
										}else {
											if(funcionHuella=="S" && $('#cajaRequiereHuella').val()=="S"){
												consultaSiRequiereHuella();
												if ($('#huellaRequiere').val()!="S"&& $('#requiereFirmante').val()=="N"){
													grabaFormaTransaccionVentanilla(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','numeroTransaccion');
												}else
													if($('#huellaRequiere').val()=="S"){
													mensajeSis("Favor de Verificar la Huella.");
												}
											}else{
												grabaFormaTransaccionVentanilla(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','numeroTransaccion');
											}//Else de verificación de Huella
										}// Else pago de Credito
									}// Else Credito Pagado	='S'
								} // Else Numero Transaccion > 0
							}// Bloquear Caja = N
						}// Else Bloquear Caja =S
					}
				}
			});

			$(':text').bind('keydown',function(e){
				if (e.which == 9 && !e.shiftKey){
					esTab= true;
				}
			});

			$('#tipoOperacion').change(function() {
				$('#grabaLimitesCta').val(0);
				serverHuella.operacionEnProceso = false;
				mostrarAlertLimite=0;
				mensajeLimite='';
				$('#tarjetaIdentiCA').hide();
				$('#numeroTarjeta').val("");
				$('#idCtePorTarjeta').val("");
				$('#nomTarjetaHabiente').val("");
				habilitaEntradasSalidasEfectivo();
				$('#sumTotalSal').val("");
				$('#sumTotalEnt').val("");
				$('#montoCargar').val("");
				$('#montoAbonar').val("");
				$('#montoPagar').val("");
				$('#montoPagadoCredito').val("");
				$('#montoGarantiaLiq').val("");
				$('#totalDepAR').val("");
				$('#totalRetirarDC').val("");
				$('#huellaRequiere').val("");//ok
				bloquearCaja = consultaLimiteCaja();
				$('#numeroTransaccion').val("");
				if(bloquearCaja == "si"){
						deshabilitaBoton('graba', 'submit');
				    	$('#impTicket').hide();
				    	$('#impCheque').hide();
				    	$('#impPoliza').hide();
				    	ocultarBtnResumen();
				}else{
					if(bloquearCaja == "no"){
						setTimeout("$('#cajaLista').hide();", 200);
						switch($(this).asNumber())
						{
							case cargoCuenta:
								$('#monedaCa').val('');
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#cargoCuenta').show();
								$('#entradaSalida').show();
								$('#totales').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
								$('#formaPagoOpera1').attr('checked','true');
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								$('#tipoTransaccion').val(catTipoTransaccionVen.cargoCuenta);
								consultarParametrosBean();
								mostrarSaldoDisponible();
								mostrarCampoTarjeta();
							break;
							case abonoCuenta:
								$('#monedaAb').val('');
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#abonoCuenta').show();
								$('#entradaSalida').show();
								$('#totales').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								$('#tipoTransaccion').val(catTipoTransaccionVen.abonoCuenta);
								consultarParametrosBean();
								mostrarSaldoDisponible();
								$('#formaPagoOpera1').attr('checked','true');
								$("#adeudoPROFUN").hide();
								$("#lblAdeudoProfun").hide();
								mostrarCampoTarjeta();
							break;
							case pagoCredito:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								if($('#exigible').is(':checked')){
									$('#totalAde').attr('checked',false);
								}
								$('#pagoCredito').show();
								$('#entradaSalida').show();
								$('#totales').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
								$('#totalAde').attr('checked', false);
							    $('#exigible').attr('checked', false);
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								mostrarSaldoDisponible();
								$('#tipoTransaccion').val(catTipoTransaccionVen.pagoCredito);
								$('#formaPagoOpera1').attr('checked','true');
								$("#lblAdeudoProfunPC").hide();
								$("#adeudoPROFUNPC").hide();
								mostrarCampoTarjeta();
								deshabilitaControl('prorrateoPagoCred');
							break;
							case garantiaLiq:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#garantiaLiq').show();
								$('#entradaSalida').show();
								$('#totales').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
								$('#pagoGLEfectivo').attr("checked",true);
								$('#pagoGLCargoCuenta').attr("checked",false);
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								mostrarSaldoDisponible();
								$('#tipoTransaccion').val(catTipoTransaccionVen.garantiaLiq);
								$('#formaPagoOpera1').attr('checked','true');
							break;
							case comAperCred:

								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#comisionApertura').show();
								$('#entradaSalida').show();
								$('#totales').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								$('#tipoTransaccion').val(catTipoTransaccionVen.comisionApertura);
								$('#formaPagoOpera1').attr('checked','true');
							break;
							case desemboCred:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#desembolsoCred').show();
								$('#entradaSalida').show();
								$('#totales').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								mostrarSaldoDisponible();
								$('#formaPagoOpera1').attr('checked','true');
								mostrarCampoTarjeta();
							break;
							case devolucionGarLiq:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#devolucionGL').show();
								$('#entradaSalida').show();
								$('#totales').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								$('#formaPagoOpera1').attr('checked','true');
								consultarParametrosBean();
								mostrarSaldoDisponible();

							break;
							case aplicaSeguroVida:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#pagoSeguroVida').show();
								$('#entradaSalida').show();
								$('#totales').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								$('#formaPagoOpera1').attr('checked','true');
								$('#tipoTransaccion').val(catTipoTransaccionVen.aplicaSeguroVida);
							break;
							case cobroSeguroVida:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#cobroSeguroVida').show();
								$('#entradaSalida').show();
								$('#totales').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								$('#formaPagoOpera1').attr('checked','checked');
								$('#tipoTransaccion').val(catTipoTransaccionVen.cobroSeguroVida);
							break;
							case cambioEfectivo:// cambio
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#entradaSalida').show();
								$('#totales').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								$('#formaPagoOpera1').attr('checked','checked');
								$('#tipoTransaccion').val(catTipoTransaccionVen.cambioEfectivo);
							break;
							case tranferenciaCuenta:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#transfiereACuenta').show();
								inicializaForma('formaGenerica','tipoOperacion');
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								mostrarSaldoDisponible();
								$('#formaPagoOpera1').attr('checked','checked');
								$('#divCuentaCheques').hide();
								$('#tipoTransaccion').val(catTipoTransaccionVen.transferenciaCuenta);
								mostrarCampoTarjeta();
							break;
							case aportacionSocio:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#entradaSalida').show();
								$('#totales').show();
								$('#aportacionSocial').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								$('#formaPagoOpera1').attr('checked','checked');
								$('#tipoTransaccion').val(catTipoTransaccionVen.aportacionSocial);
							break;
							case devAportacionSocial:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#entradaSalida').show();
								$('#totales').show();
								$('#devAportacionSocial').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								$('#formaPagoOpera1').attr('checked','checked');


							break;
							case cobroSegVidaAyuda:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#entradaSalida').show();
								$('#totales').show();
								$('#cobroSegVidaAyuda').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								$('#formaPagoOpera1').attr('checked','checked');
							break;
							case pagoSeguroAyuda:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#entradaSalida').show();
								$('#totales').show();
								$('#pagoSeguroAyuda').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								$('#formaPagoOpera1').attr('checked','checked');
								$('#tipoTransaccion').val(catTipoTransaccionVen.aplicaSegVidaAyuda);
							break;
							case pagoRemesas:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#entradaSalida').show();
								$('#totales').show();
								$('#pagoRemesas').show();
								$('#lblComboRemesadora').show();
								$('#remesaCatalogoID').show();
								$('#remesaCatalogoID').val("");
								llenaComboRemesadoras(); // SE LLENA EL COMBO DE REMESADORAS
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
								$('#numeroCuentaServicio').hide();
								$('#tdlblNumCuentaServicio').hide();
								habilitaCamposRemesasOportunidades();
								$('#pagoServicioRetiro').attr("checked",true);
								llenaComboTiposIdentiServicio(); // volvemos a consultar los tipos de identificacion
								$('#fielsetRemesaOport').text('Pago de Remesas');
								$('#tipoPagoServicio').val("R");
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								mostrarCampoTarjeta();
								$('#tipoTransaccion').val(catTipoTransaccionVen.pagoRemesas);
								limiteCaracteres();
							break;
							case pagoOportunidades:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#entradaSalida').show();
								$('#totales').show();
								$('#pagoRemesas').show();
								$('#remesaCatalogoID').val("");
								$('#lblComboRemesadora').hide();
								$('#remesaCatalogoID').hide();
								$('#remesaCatalogoID').val("");
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#numeroCuentaServicio').hide();
								$('#tdlblNumCuentaServicio').hide();
								habilitaCamposRemesasOportunidades();
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
								$('#pagoServicioRetiro').attr("checked",true);
								llenaComboTiposIdentiServicio(); // volvemos a consultar los tipos de identificacion
								$('#fielsetRemesaOport').text('Pago de Oportunidades');
								$('#tipoPagoServicio').val("R");
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								$('#numeroTarjetaRemesas').hide();
								$('#numerTarjetaRemesas').hide();
								$('#tipoTransaccion').val(catTipoTransaccionVen.pagoOportunidades);
								mostrarCampoTarjeta();
								limiteCaracteres();
							break;
							case recepChequeSBC:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#entradaSalida').hide();
								$('#totales').hide();
								$('#recepcionChequeSBC').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								mostrarSaldoDisponible();
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
								$('#formaPagoOpera2').attr('checked',false);
								$('#pagoServicioCheque').attr('checked',false);
								llenaComboTipoCuentaCheque();
								$('#formaPagoOpera1').attr('checked',false);
								$('#tipoTransaccion').val(catTipoTransaccionVen.recepcionChequeSBC);
								mostrarCampoTarjeta();
							break;
							case aplicaChequeSBC:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#entradaSalida').show();
								$('#totales').show();
								$('#aplicaChequeSBC').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								mostrarSaldoDisponible();
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
								$('#formaPagoOpera1').attr('checked','checked');
								$('#tipoTransaccion').val(catTipoTransaccionVen.aplicaChequeSBC);
								mostrarCampoTarjeta();
							break;
							case prepagoCredito:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#entradaSalida').show();
								$('#totales').show();
								$('#prepagoCredito').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								mostrarSaldoDisponible();
								$('#formaPagoOpera1').attr('checked','checked');
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
								$('#lblAdeudoProfunPREC').hide('');
								$('#adeudoPROFUNPREC').hide('');
								mostrarCampoTarjeta();

							break;
							case pagoServicios:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#entradaSalida').show();
								$('#totales').show();
								$('#pagoServicios').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#tipoTransaccion').val(catTipoTransaccionVen.pagoServicios);
								llenaComboCatalogoServicios();
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								$('#formaPagoOpera1').attr('checked','checked');
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
								$('#lblNumTarjetaSer').hide();
								$('#numeroTarjetaServicio').hide();


							break;
							case RecupCarteraVencida:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#entradaSalida').show();
								$('#totales').show();
								$('#carteraCastigada').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#tipoTransaccion').val(catTipoTransaccionVen.recuperaCartera);
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								consultaMotivosCastigo();  // Combo de motivos de Castigo
								$('#formaPagoOpera1').attr('checked','checked');
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
							break;
							case pargoServifun:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#entradaSalida').show();
								$('#totales').show();
								$('#pagoServifun').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#tipoTransaccion').val(catTipoTransaccionVen.recuperaCartera);
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								$('#formaPagoOpera1').attr('checked','checked');
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
								mostrarCampoTarjeta();
							break;
							case cobroApoyoEscolar:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#entradaSalida').show();
								$('#totales').show();
								$('#apoyoEscolar').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#tipoTransaccion').val(catTipoTransaccionVen.cobroApoyoEscolar);
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								$('#formaPagoOpera1').attr('checked','checked');
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
								mostrarCampoTarjeta();
							break;
							case ajusteSobrante:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#entradaSalida').show();
								$('#totales').show();
								$('#ajusteSobrante').show();
								$('#usuarioContrasenia').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#tipoTransaccion').val(catTipoTransaccionVen.ajusteSobrante);
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
							break;
							case ajusteFaltante:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#entradaSalida').show();
								$('#totales').show();
								$('#ajusteFaltante').show();
								$('#usuarioContrasenia').show();

								inicializaForma('formaGenerica','tipoOperacion' );
								$('#tipoTransaccion').val(catTipoTransaccionVen.ajusteFaltante);
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
							break;
							case anualidadTarjeta:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#entradaSalida').show();
								$('#totales').show();
								$('#cobroAnualidadTarjeta').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#tipoTransaccion').val(catTipoTransaccionVen.anualidadTarjeta);
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
							break;
							case pagoCancelSocio:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#entradaSalida').show();
								$('#totales').show();
								$('#pagoClientesCancela').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#tipoTransaccion').val(catTipoTransaccionVen.pagoCancelSocio);
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
								$('#clienteCancelaIDPCC').val('');
								$('#divBeneficiariosPCC').hide();
								$('#formaPagoOpera1').attr('checked',true);
								$('#formaPagoOpera2').attr('checked',false);
							break;
							case gastosAnticiposV:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#gastosAnticipos').show();
								$('#entradaSalida').show();
								$('#divFormaPago').show();
								$('#totales').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#tipoTransaccion').val(catTipoTransaccionVen.anticiposGastos);
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								llenaComboGastosAnticiposSalida();
								$('#formaPagoOpera1').attr('checked',true);
								$('#formaPagoOpera2').attr('checked',false);

							break;

							case devolucionesGastAnt:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#DevGastosAnticipos').show();
								$('#entradaSalida').show();
								$('#divFormaPago').hide();
								$('#totales').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#tipoTransaccion').val(catTipoTransaccionVen.devolucionesGastAnt);
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								llenaComboGastosAnticipos();
								$('#formaPagoOpera1').attr('checked',true);
								$('#formaPagoOpera2').attr('checked',false);
							break;
							case haberesExmenor:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#recHaberesMenor').show();
								$('#entradaSalida').show();
								$('#divFormaPago').show();
								$('#totales').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#tipoTransaccion').val(catTipoTransaccionVen.haberesExmenor);
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								llenaComboTiposIdentiGenerica('identiMenor');
								$('#formaPagoOpera1').attr('checked',true);
								$('#formaPagoOpera2').attr('checked',false);
							break;
							case transferenciaInterna:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#transfiereACuenta').show();
								inicializaForma('formaGenerica','tipoOperacion');
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								mostrarSaldoDisponible();
								$('#formaPagoOpera1').attr('checked','checked');
								$('#divCuentaCheques').hide();
								$('#tipoTransaccion').val(catTipoTransaccionVen.transferenciaCuenta);
							break;
							case pagoArrendamiento://vista de la sección de pago de arrendamiento
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#pagoArrendamiento').show();		//debe ser el id de la pantalla en la clase ingresosOperaciones
								$('#entradaSalida').show();
								$('#divFormaPagoEfecCuenta').show();
								$('#totales').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								$('#tipoTransaccion').val(catTipoTransaccionVen.pagoArrendamiento);
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
								mostrarSaldoDisponible();
								$('#totalArrendamiento').attr('checked', false);
							    $('#exigibleArrendamiento').attr('checked', true);
								$('#formaPagoEfectivo').attr('checked', true);
							break;
							case pagoServiciosEnLinea://vista de la sección de pago de arrendamiento
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#pagoServiciosEnLinea').show();
								$('#tipoTransaccion').val(catTipoTransaccionVen.pagoServiciosEnLinea);

								inicializaPagoServiciosEnLinea();
							break;
							case cobroAccesoriosCre:
								ocultaDivsOperaciones(); // Oculta toda las operaciones
								consultaCobraAccesorios();
								if (cobraAccesoriosGen=='S') {
									$('#cobroAccesoriosCre').show(); // Muestra la sección para Cobro de Accesorios
									$('#tipoTransaccion').val(catTipoTransaccionVen.cobroAccesoriosCre); // Asigna Tipo de Transaccion 44
								}else{
									mensajeSis("La institución actual no permite Cobro de Accesorios");
									$('#tipoOperacion').val('');
									setTimeout("$('#tipoOperacion').focus();",0);
								}
								$('#entradaSalida').show(); // Muestra Sección Entrada y Salida Efectivo
								$('#totales').show(); // Muestra la sección de Totales
								inicializaForma('formaGenerica','tipoOperacion' ); // Inicializa Formulario
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								consultarParametrosBean();
							break;
							case depositoActivaCta:
								ocultaDivsOperaciones(); // Oculta Todos las operaciones
								$('#divDepositoActivaCta').show();
								$('#entradaSalida').show();
								$('#totales').show();
								inicializaForma('formaGenerica','tipoOperacion' );
								inicializarEntradasSalidasEfectivo();
								consultaDisponibleDenominacion();
								$('#tipoTransaccion').val(catTipoTransaccionVen.depositoActivaCta);
								consultarParametrosBean();
								$('#formaPagoOpera1').attr('checked','true');
								//mostrarCampoTarjeta();
							break;
						}
					}
				 }
			});

			var mostrarSaldoDis = parametroBean.mostrarSaldDisCtaYSbc;
		// Funcion que muestra y oculta el saldo disponible de la cuenta
			function mostrarSaldoDisponible(){
				var tipoOpera = parseInt($('#tipoOperacion option:selected').val());

				switch(tipoOpera){
					case cargoCuenta:
						if(mostrarSaldoDis=="S"){
							$('#lblSaldoDis').show();
							$('#saldoDisponCa').show();
						}else if(mostrarSaldoDis=="N"){
							$('#lblSaldoDis').hide();
							$('#saldoDisponCa').hide();
						}
						break;
					case abonoCuenta:
						if(mostrarSaldoDis=="S"){
							$('#tdsaldoDisponAb').show();
							$('#saldoDisponAb').show();
						}else if(mostrarSaldoDis=="N"){
							$('#tdsaldoDisponAb').hide();
							$('#saldoDisponAb').hide();
						}
						break;
					case pagoCredito:
						if(mostrarSaldoDis=="S"){
							$('#tdSaldoCta').show();
							$('#saldoCta').show();
						}else if(mostrarSaldoDis=="N"){
							$('#tdSaldoCta').hide();
							$('#saldoCta').hide();
						}
						break;
					case garantiaLiq:
						if(mostrarSaldoDis=="S"){
							$('#trsaldoBloqGL').show();
						}else if(mostrarSaldoDis=="N"){
							$('#trsaldoBloqGL').hide();
						}
						break;
					case devolucionGarLiq:
						if(mostrarSaldoDis=="S"){
							$('#tdsaldoDisponDG').show();
							$('#saldoDisponDG').show();
						}else if(mostrarSaldoDis=="N"){
							$('#tdsaldoDisponDG').hide();
							$('#saldoDisponDG').hide();
						}
						break;
					case desemboCred:
						if(mostrarSaldoDis=="S"){
							$('#tdsaldoDisponDC').show();
							$('#saldoDisponDC').show();
						}else if(mostrarSaldoDis=="N"){
							$('#tdsaldoDisponDC').hide();
							$('#saldoDisponDC').hide();
						}
						break;//pato
					case tranferenciaCuenta:
						if(mostrarSaldoDis=="S"){
							$('#tdsaldoDisponT').show();
							$('#saldoDisponT').show();
						}else if(mostrarSaldoDis=="N"){
							$('#tdsaldoDisponT').hide();
							$('#saldoDisponT').hide();
						}
						break;
					case recepChequeSBC:
						if(mostrarSaldoDis=="S"){
							$('#trSalDispYSbc').show();
						}else if(mostrarSaldoDis=="N"){
							$('#trSalDispYSbc').hide();
						}
						break;
					case aplicaChequeSBC:
						if(mostrarSaldoDis=="S"){
							$('#trSaldosDispYSbc').show();
						}else if(mostrarSaldoDis=="N"){
							$('#trSaldosDispYSbc').hide();
						}
						break;
					case prepagoCredito:
						if(mostrarSaldoDis=="S"){
							$('#tdsaldoCtaPre').show();
							$('#saldoCtaPre').show();
						}else if(mostrarSaldoDis=="N"){
							$('#tdsaldoCtaPre').hide();
							$('#saldoCtaPre').hide();
						}
						break;
					case transferenciaInterna:
						if(mostrarSaldoDis=="S"){
							$('#tdsaldoDisponT').show();
							$('#saldoDisponT').show();
						}else if(mostrarSaldoDis=="N"){
							$('#tdsaldoDisponT').hide();
							$('#saldoDisponT').hide();
						}
						break;
					}
				}



			function ocultaDivsOperaciones(){
				inicializarCampos();
				inicializarCamposGL();
				creditoPagado = "N";
				$('#cargoCuenta').hide();
				$('#abonoCuenta').hide();
				$('#pagoCredito').hide();
				$('#garantiaLiq').hide();
				$('#comisionApertura').hide();
				$('#devolucionGL').hide();
				$('#desembolsoCred').hide();
				$('#pagoSeguroVida').hide();
				$('#cobroSeguroVida').hide();
				$('#entradaSalida').hide();
				$('#totales').hide();
				$('#transfiereACuenta').hide();
				$('#aportacionSocial').hide();
				$('#devAportacionSocial').hide();
				$('#cobroSegVidaAyuda').hide();
				$('#pagoSeguroAyuda').hide();
				$('#pagoRemesas').hide();
				$('#recepcionChequeSBC').hide();
				$('#aplicaChequeSBC').hide();
				$('#prepagoCredito').hide();
				$('#pagoServicios').hide();
				$('#carteraCastigada').hide();
				$('#pagoServifun').hide();
				$('#apoyoEscolar').hide();
				$('#ajusteSobrante').hide();
				$('#ajusteFaltante').hide();
				$('#usuarioContrasenia').hide();
				$('#cobroAnualidadTarjeta').hide();
				$('#pagoClientesCancela').hide();
				$('#gastosAnticipos').hide();
				$('#DevGastosAnticipos').hide();
				$('#recHaberesMenor').hide();
				$('#enlaceH').hide();
				$('#pagoArrendamiento').hide();
				$('#pagoServiciosEnLinea').hide();
				$('#cobroAccesoriosCre').hide();
				$('#divDepositoActivaCta').hide();
			}

			$('#tipoOperacion').blur(function() {
				if($('#tipoOperacion').val() !=  recepChequeSBC && $('#tipoOperacion').val() != pagoServiciosEnLinea){
					inicializarEntradasSalidasEfectivo();
					inicializaForma('formaGenerica','tipoOperacion' );
					consultarParametrosBean();
					$('#totalAde').attr('checked', false);
				    $('#exigible').attr('checked', false);
					$('#totalArrendamiento').attr('checked', false);
					$('#exigibleArrendamiento').attr('checked', true);
					$('#formaPagoEfectivo').attr('checked', true);
					validarFormaPago();
					$('#cuentaChequePago').val('');
					$('#tipoChequera').val('');
					$('#numeroTransaccion').val("");
					$('#numeroMensaje').val("1");
					if($('#tipoOperacion').val()== 'CEf'){
						$('#cantEntraMil').focus();
					}
				}

			});

			// SECCION DE EVENTOS DE CARGO A CUENTA
			$('#numeroTarjeta').blur(function(e){
				var longitudTarjeta=$('#numeroTarjeta').val().length;
				if (longitudTarjeta<16){
					$('#numeroTarjeta').val("");
				}else{
					consultaClienteIDTarDeb('numeroTarjeta');
				}
			});
			$('#numeroTarjeta').bind('keypress', function(e){
				 return validaAlfanumerico(e,this);
			});

			$('#numeroTarjetaServicio').bind('keypress', function(e){
				 return validaAlfanumerico(e,this);
			});
			$('#numeroTarjetaServicio').blur(function(e){
				var longitudTarjeta=$('#numeroTarjetaServicio').val().length;
				if (longitudTarjeta<16){
					$('#numeroTarjetaServicio').val("");
				}else{
					consultaClienteIDTarDeb('numeroTarjetaServicio');
				}
			});

			//Función para poder ingresar solo números o letras
			function validaAlfanumerico(e,elemento){//Recibe al evento
				var key;
				if(window.event){//Internet Explorer ,Chromium,Chrome
					key = e.keyCode;
				}else if(e.which){//Firefox , Opera Netscape
						key = e.which;
				}
				 if (key > 31 && (key < 48 ||  key > 57) && (key <65 || key >90) && (key<97 || key >122)) //Comparación con código ascii
				    return false;
				 var longitudTarjeta=$('#numeroTarjeta').val().length;
				 var longitudTarjetaRemesa=$('#numeroTarjetaRemesas').val().length;
				 var longitudTarjetaServ=$('#numeroTarjetaServicio').val().length;
				 	if ($('#numeroTarjeta').val()!=""){
				 		if (longitudTarjeta == 16 ){
							consultaClienteIDTarDeb('numeroTarjeta');
						}
				 	}else{
				 		if ($('#numeroTarjetaRemesas').val()!=""){
					 		if (longitudTarjetaRemesa == 16 ){
								consultaClienteIDTarDeb('numeroTarjetaRemesas');
							}
				 		}else{
				 			if (longitudTarjetaServ == 16 ){
								consultaClienteIDTarDeb('numeroTarjetaServicio');
							}
				 		}

					}
				 return true;


			}
			$('#buscarMiSucEf').click(function(){
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "clienteID";
				camposLista[1] = "nombreCompleto";
					parametrosLista[0] = 0;
					parametrosLista[1] = $('#cuentaAhoIDCa').val();

				listaCte('cuentaAhoIDCa', '2', '15', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
			});
			$('#buscarGeneralEf').click(function(){
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "clienteID";
				camposLista[1] = "nombreCompleto";

					parametrosLista[0] = 0;
					parametrosLista[1] = $('#cuentaAhoIDCa').val();
				listaCte('cuentaAhoIDCa', '2', '16', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');

			});

			$('#cuentaAhoIDCa').bind('keyup',function(e) {
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "clienteID";
				camposLista[1] = "nombreCompleto";
				parametrosLista[0] = 0;
				parametrosLista[1] = $('#cuentaAhoIDCa').val();

				if(Busqueda == 'GENERAL' && mostrarBotones== 'N'){
					listaCte('cuentaAhoIDCa', '2', '16', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
				}

				if(Busqueda == 'SUCURSAL' && mostrarBotones== 'N'){
					listaCte('cuentaAhoIDCa', '2', '15', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
				}
			});

			$('#cuentaAhoIDCa').blur(function() {
				$('#tipoCuentaCa').val('');
				$('#numClienteCa').val('');
				$('#nombreClienteCa').val('');
				$('#monedaIDCa').val('');
				$('#monedaCa').val('');
				$('#saldoDisponCa').val('');
		  		consultaCtaAhoCargo(this.id);
		  		inicializarEntradasSalidasEfectivo();
				consultarParametrosBean();
				borrarDivCheques();
				$('#tipoTransaccion').val(catTipoTransaccionVen.cargoCuenta);
				$('#montoCargar').val("");
				$('#referenciaCa').val("");
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
			});

			$('#verFirmas').blur(function() {
				if($('#formaPagoOpera2').is(':checked')){
					$('#formaPagoOpera2').focus();
				}
			});

			$('#referenciaCa').blur(function() {
				$('#numeroMensaje').val("1");
				ponerMayusculas(this);
				limpiarCajaTexto(this.id);
			});

			$('#folioIdentificacion').blur(function(){
				if($('#formaPagoOpera1').is(':checked')){
					$('#formaPagoOpera1').focus();
				}else{
					$('#formaPagoOpera2').focus();
				}
			});


	 function consultaClienteIDTarDeb(control) {
		var jqControl = eval("'#" + control + "'");
		var numeroTar = $(jqControl).val();
		var numTarIdenAccess = numeroTar.replace(/[%&(=?¡'{-|})><ĸ¬°Çü½«»~÷Ø§ç¨`^€¶ŧ←↓→øþæßðđŋħł¢“µ·½\/\]\]\[\”\\]/gi, '');
		numTarIdenAccess = numTarIdenAccess.replace(/[_]/gi, '');
		numTarIdenAccess = numTarIdenAccess.replace(/[' ']/gi, ''); // Quitamos los espacios en blanco
		numeroTar = numTarIdenAccess;

		$(jqControl).val(numeroTar);
		var conNumTarjeta = 20;
		var TarjetaBeanCon = {
			'tarjetaDebID' : numeroTar
		};
		if (numeroTar != '' && numeroTar > 0) {
			if ($(jqControl).val().length > 16) {
				mensajeSis("El Número de Tarjeta es Incorrecto, deben de ser 16 Dígitos.");
				$(jqControl).val("");
				$(jqControl).focus();
			}
			if ($(jqControl).val().length == 16) {
				tarjetaDebitoServicio.consulta(conNumTarjeta, TarjetaBeanCon, function(tarjetaDebito) {
					if (tarjetaDebito != null) {
						var cliente = Number(tarjetaDebito.clienteID);
						if (cliente > 0) {
							listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, tarjetaDebito.cuentaAhoID, 0);
							consultaSPL = consultaPermiteOperaSPL(cliente,'LPB',esCliente);

							if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
								expedienteBean = consultaExpedienteCliente(cliente);
								if (expedienteBean.tiempo <= 1) {
									if (alertaCte(cliente) != 999) {
										if (tarjetaDebito.estatusId == 7) {
											$('#idCtePorTarjeta').val(tarjetaDebito.clienteID);
											$('#nomTarjetaHabiente').val(tarjetaDebito.nombreCompleto);
											funcionListado();
										} else {
											$('#idCtePorTarjeta').val("");
											$('#nomTarjetaHabiente').val("");

											if (tarjetaDebito.estatusId == 1) {
												mensajeSis("La Tarjeta No se Encuentra Asociada a una Cuenta.");
											}
											if (tarjetaDebito.estatusId == 6) {
												mensajeSis("La Tarjeta No se Encuentra Activa.");
											}
											if (tarjetaDebito.estatusId == 8) {
												mensajeSis("La Tarjeta Se Encuentra Bloqueada.");
											}

											if (tarjetaDebito.estatusId == 9) {
												mensajeSis("La Tarjeta Se Encuentra Cancelada.");
											}

											$(jqControl).focus();
											$(jqControl).val("");

											if (control == 'numeroTarjetaServicio') {
												limpiaCamposPagoServicio();
												inicializarEntradasSalidasEfectivo();
												consultaCatalogoServicio($('#catalogoServID').asNumber());
											} else if (control == 'numeroTarjeta') {
												inicializarCampos();
												limpiarCamposRemesasOportunidades();
											} else if (control == 'numeroTarjetaRemesas') {
												$('#clienteIDServicio').val('');
												limpiarCamposRemesasOportunidades();
											}
										}
									}
								} else {
									mensajeSis('Es necesario Actualizar el Expediente del ' + $('#socioClienteAlert').val() + ' para Continuar.');
									$(jqControl).focus();
									$(jqControl).val("");
									$('#idCtePorTarjeta').val("");
									$('#nomTarjetaHabiente').val("");
									if (control == 'numeroTarjetaServicio') {
										limpiaCamposPagoServicio();
										inicializarEntradasSalidasEfectivo();
										consultaCatalogoServicio($('#catalogoServID').asNumber());
									} else if (control == 'numeroTarjeta') {
										inicializarCampos();
									} else if (control == 'numeroTarjetaRemesas') {
										$('#clienteIDServicio').val('');
										limpiarCamposRemesasOportunidades();
									}
								}
							} else {
								mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
								$(jqControl).focus();
								$(jqControl).val("");
								$('#idCtePorTarjeta').val("");
								$('#nomTarjetaHabiente').val("");
								if (control == 'numeroTarjetaServicio') {
									limpiaCamposPagoServicio();
									inicializarEntradasSalidasEfectivo();
									consultaCatalogoServicio($('#catalogoServID').asNumber());
								} else if (control == 'numeroTarjeta') {
									inicializarCampos();
								} else if (control == 'numeroTarjetaRemesas') {
									$('#clienteIDServicio').val('');
									limpiarCamposRemesasOportunidades();
								}
							}
						}
					} else {
						mensajeSis("La Tarjeta de Identificación No existe.");
						$(jqControl).focus();
						$(jqControl).val("");
						$('#idCtePorTarjeta').val("");
						$('#nomTarjetaHabiente').val("");
						if (control == 'numeroTarjetaServicio') {
							limpiaCamposPagoServicio();
							inicializarEntradasSalidasEfectivo();
							consultaCatalogoServicio($('#catalogoServID').asNumber());
						} else if (control == 'numeroTarjeta') {
							inicializarCampos();
						} else if (control == 'numeroTarjetaRemesas') {
							$('#clienteIDServicio').val('');
							limpiarCamposRemesasOportunidades();
						}
					}
				});
			}
		}
	}
			// FIN SECCION DE EVENTOS DE CARGO A CUENTA

			// SECCION DE EVENTOS DE ABONO  A CUENTA


			$('#buscarMiSucAb').click(function(){
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "clienteID";
				camposLista[1] = "nombreCompleto";

				parametrosLista[0] = 0;
				parametrosLista[1] = $('#cuentaAhoIDAb').val();

				listaCte('cuentaAhoIDAb', '2', '15', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
			});
			$('#buscarGeneralAb').click(function(){
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "clienteID";
				camposLista[1] = "nombreCompleto";
				parametrosLista[0] = 0;
				parametrosLista[1] = $('#cuentaAhoIDAb').val();

				listaCte('cuentaAhoIDAb', '2', '16', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
			});

			$('#cuentaAhoIDAb').bind('keyup',function(e) {
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "clienteID";
				camposLista[1] = "nombreCompleto";

				parametrosLista[0] = 0;
				parametrosLista[1] = $('#cuentaAhoIDAb').val();

				if(Busqueda == 'GENERAL' && mostrarBotones== 'N'){
					listaCte('cuentaAhoIDAb', '2', '16', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
				}

				if(Busqueda == 'SUCURSAL' && mostrarBotones== 'N'){
					listaCte('cuentaAhoIDAb', '2', '15', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
				}


			});

			$('#cuentaAhoIDAb').blur(function() {
				$('#monedaIDAb').val('');
				$('#monedaAb').val('');
				$('#monedaAb').val('');
		  		consultaCtaAhoAbono(this.id);
		  		consultarParametrosBean();
		  		inicializarEntradasSalidasEfectivo();
		  		$('#tipoTransaccion').val(catTipoTransaccionVen.abonoCuenta);
				$('#montoAbonar').val("");
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
			});

			$('#montoAbonar').blur(function() {
				totalEntradasSalidasDiferencia();
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
			});

			$('#referenciaAb').blur(function() {
				$('#cantEntraMil').focus();
				ponerMayusculas(this);
				limpiarCajaTexto(this.id);
			});
			// FIN SECCION DE EVENTOS DE ABONO A CUENTA


			// SECCION DE EVENTOS DE COM APER CREDITO
			$('#creditoIDAR').blur(function(){
				consultaCreditoComAp(this.id);
				consultarParametrosBean();
				inicializarEntradasSalidasEfectivo();
				habilitaEntradasSalidasEfectivo();
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
			});

			$('#creditoIDAR').bind('keyup', function(e){
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "creditoID";
				camposLista[1] = "nombreCliente";
				parametrosLista[0] = 0;
				parametrosLista[1] = $('#creditoIDAR').val();
				//lista 31
				listaAlfanumerica('creditoIDAR', '2', '31', camposLista, parametrosLista, 'ListaCredito.htm');
			});

			$('#totalDepAR').blur(function(){

				totalEntradasSalidasDiferencia();

				var cantDepComAp = $('#totalDepAR').asNumber();
				var comisionApert=0;
				var ivaComisionApert=0;

				if(cantDepComAp>0){
					comisionApert  = Math.round((cantDepComAp / (1+0.16))*100)/100;
					ivaComisionApert = Math.round(((cantDepComAp / (1+0.16))*0.16)*100)/100;
				}

				$('#comisionAR').val(comisionApert);
				$('#ivaAR').val(ivaComisionApert);
				agregaFormatoMoneda('formaGenerica');
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");

				var totales=$('#totalPagadoDepAR').asNumber()+ $('#comisionAR').asNumber();
				var comisionReal=$('#montoComisionAR').asNumber();
				if(totales.toFixed(2) > comisionReal ){
					mensajeSis("El Monto a Pagar Excede el Monto de Comisión por Apertura.");
				}else{
					$('#cantEntraMil').focus();
				}

			});



			// FIN SECCION DE EVENTOS DE COM APER CREDITO

			// SECCION DE EVENTOS DESEMBOLSO CREDITO
			$('#buscarMiSucDes').click(function(){
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "creditoID";
				camposLista[1] = "nombreCliente";
				parametrosLista[0] = 0;
				parametrosLista[1] = $('#creditoIDDC').val();
				listaAlfanumericaCte('creditoIDDC', '2', '30', camposLista, parametrosLista, 'ListaCredito.htm');
			});
			$('#buscarGeneralDes').click(function(){
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "creditoID";
				camposLista[1] = "nombreCliente";
				parametrosLista[0] = 0;
				parametrosLista[1] = $('#creditoIDDC').val();
				listaAlfanumericaCte('creditoIDDC', '2', '36', camposLista, parametrosLista, 'ListaCredito.htm');
			});

			$('#creditoIDDC').bind('keyup',function(e) {
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "creditoID";
				camposLista[1] = "nombreCliente";
				parametrosLista[0] = 0;
				parametrosLista[1] = $('#creditoIDDC').val();

				if(Busqueda == 'GENERAL' && mostrarBotones== 'N'){
					listaAlfanumericaCte('creditoIDDC', '2', '36', camposLista, parametrosLista, 'ListaCredito.htm');
				}

				if(Busqueda == 'SUCURSAL' && mostrarBotones== 'N'){
					listaAlfanumericaCte('creditoIDDC', '2', '30', camposLista, parametrosLista, 'ListaCredito.htm');
				}

			});

			$('#creditoIDDC').blur(function(){
				if($('#creditoIDDC').asNumber()>0){
					consultaCreditoDesCre(this.id);
					consultarParametrosBean();
					inicializarEntradasSalidasEfectivo();
					borrarDivCheques();
					$('#numeroTransaccion').val("");
					$('#numeroMensaje').val("1");
				} else {
					if( esTab){
						inicializarCampos();
						$('#clienteIDDC').val('');
						$('#nombreClienteDC').val('');
						$('#montoCreDC').val('');
						$('#productoCreditoIDDC').val('');
						$('#desProdCreditoDC').val('');
						$('#cuentaAhoIDDC').val('');
						$('#nomCuentaDC').val('');
						$('#saldoDisponDC').val('');
						$('#monedaIDDC').val('');
						$('#monedaDesDC').val('');
						$('#tipoComisionDC').val('');
						$('#comisionDC').val('');
						$('#ivaDC').val('');
						$('#totalDesembolsoDC').val('');
						$('#montoPorDesemDC').val('');
						$('#totalRetirarDC').val('');
						mensajeSis('El Número de Crédito no es Valido.');
						$('#creditoIDDC').focus();
					}
				}
			});

			$('#totalRetirarDC').blur(function() {
				validaMontoDesembolso();
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
			});

			// FIN SECCION DE EVENTOS DESEMBOLSO CREDITO


			// SECCION DE EVENTOS DE GARANTIA LIQUIDA

		// lllll por que se quito este codigo
 			$('#buscarMiSuc').click(function(){
				listaCte('numClienteGL', '2', '35', 'nombreCompleto', $('#numClienteGL').val(), 'listaCliente.htm');
			});
			$('#buscarGeneral').click(function(){
				listaCte('numClienteGL', '2', '34', 'nombreCompleto', $('#numClienteGL').val(), 'listaCliente.htm');
			});



			$('#montoGarantiaLiq').blur(function() {
				if ($('#pagoGLCargoCuenta').attr("checked")== true){
					//habilitaBoton('graba', 'submit');
					if($('#montoGarantiaLiq').asNumber() > 0 &&  $('#montoGarantiaLiq').asNumber() <= $('#saldoDisponGL').asNumber()){
						habilitaBoton('graba', 'submit');

					}else if($('#montoGarantiaLiq').asNumber() <= 0){
						mensajeSis("El Monto Debe ser Mayor a 0.");
						deshabilitaBoton('graba', 'submit');
					}else if($('#montoGarantiaLiq').asNumber() > $('#saldoDisponGL').asNumber()){
						mensajeSis("El Monto No debe ser Mayor al Saldo Disponible.");

						deshabilitaBoton('graba', 'submit');
					}
				}else{
					totalEntradasSalidasDiferencia();
				}
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
				$('#cantEntraMil').focus();

			});

			$('#referenciaGL').change(function() {
				consultaCreditoGL();
			});

			$('#referenciaGL').blur(function() {
				consultaCreditoGL();
			});


			$('#numClienteGL').blur(function() {
				if($.trim($('#numClienteGL').val())!=''){
					setTimeout("$('#cajaLista').hide();", 200);
					var cliente = $('#numClienteGL').asNumber();
					if(cliente>0){
						listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, 0, 0);
						consultaSPL = consultaPermiteOperaSPL(cliente,'LPB',esCliente);

						if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
							expedienteBean = consultaExpedienteCliente(cliente);
							if(expedienteBean.tiempo<=1){
								consultaClientePantallaGarantiaLiq('numClienteGL');
								$('#pagoGLEfectivo').attr("checked",true);
								$('#pagoGLCargoCuenta').attr("checked",false);
								$('#entradaSalida').show();
								$('#totales').show();
							} else {
								mensajeSis('Es necesario Actualizar el Expediente del '+$('#socioClienteAlert').val()+' para Continuar.');
								inicializarCamposGL();
								$('#numClienteGL').focus();
							}
						} else {
							mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
							inicializarCamposGL();
							$('#numClienteGL').focus();
						}
					}
				}
				else{
					$('#numClienteGL').val('');
				}

			});

			$('#numClienteGL').bind('keyup',function(e) {
				if(Busqueda == 'GENERAL' && mostrarBotones== 'N'){
					listaCte('numClienteGL', '2', '34', 'nombreCompleto', $('#numClienteGL').val(), 'listaCliente.htm');
				}

				if(Busqueda == 'SUCURSAL' && mostrarBotones== 'N'){
					listaCte('numClienteGL', '2', '35', 'nombreCompleto', $('#numClienteGL').val(), 'listaCliente.htm');
				}
			});

			$('#buscarMiSuc').click(function(){
				listaCte('numClienteGL', '2', '35', 'nombreCompleto', $('#numClienteGL').val(), 'listaCliente.htm');
			});
			$('#buscarGeneral').click(function(){
				listaCte('numClienteGL', '2', '34', 'nombreCompleto', $('#numClienteGL').val(), 'listaCliente.htm');
			});

			// cambiar esto
			$('#pagoGLCargoCuenta').click(function() {
				$('#entradaSalida').hide();
				$('#totales').hide();
			});

			$('#pagoGLEfectivo').click(function() {
				$('#entradaSalida').show();
				$('#totales').show();
			});

			$('#pagoGLEfectivo').blur(function() {
				$('#montoGarantiaLiq').focus();
			});
			$('#pagoGLCargoCuenta').blur(function() {
				$('#montoGarantiaLiq').focus();
			});
			// FIN SECCION DE EVENTOS DE GARANTIA LIQUIDA

			//EVENTOS DE PAGO DE ARRENDAMIENTO
			$('#arrendamientoID').bind('keyup',function(e) {
				var camposLista = new Array();
				var parametrosLista = new Array();

				camposLista[0] = "arrendaID";
				camposLista[1] = "sucursalID";
				parametrosLista[0] = $('#arrendamientoID').val();
				parametrosLista[1] = $('#numeroSucursal').val();


				if(Busqueda == 'GENERAL' && mostrarBotones== 'N'){
					listaCte('arrendamientoID', '2', '6', camposLista, parametrosLista, 'arrendamientosLista.htm');
				}

				if(Busqueda == 'SUCURSAL' && mostrarBotones== 'N'){
					listaCte('arrendamientoID', '2', '5', camposLista, parametrosLista, 'arrendamientosLista.htm');
				}

			});

			$('#arrendamientoID').blur(function() {
				if($('#arrendamientoID').asNumber()>0){
					var id=this.id;
				consultArrendamiento(id);
				consultarParametrosBean();
				inicializarEntradasSalidasEfectivo();
				$('#totalArrendamiento').attr('checked', false);
			    $('#exigibleArrendamiento').attr('checked', true);
				$('#formaPagoEfectivo').attr('checked', true);
				}else{
				inicializaForma('formaGenerica','arrendamientoID');
				inicializarCamposArrendamiento();
				inicializarEntradasSalidasEfectivo();
				}
			});

			$('#formaPagoEfectivo').click(function() {
				$('#entradaSalida').show();
				$('#totales').show();
				inicializarEntradasSalidasEfectivo();
				$('#formaPagoEfectivo').focus();
			});

			$('#montoPagarArrendamiento').focus(function() {
				validaFocoInputMoneda('montoPagarArrendamiento');
			});

			$('#montoPagarArrendamiento').blur(function() {
				var montoPago = $('#montoPagarArrendamiento').asNumber();
				var montoExi = $('#exigAlDiaArrendamiento').asNumber();
				if(montoPago !='' && !isNaN(montoPago) ){
					if(montoPago <= montoExi){
						inicializarEntradasSalidasEfectivo();
						totalEntradasSalidasDiferencia();
						$('#numeroTransaccion').val("");
						$('#numeroMensaje').val("1");;
					}else{
						inicializarEntradasSalidasEfectivo();
						mensajeSis("El monto a pagar no puede ser mayor al pago exigible del dia.");
						$('#montoPagarArrendamiento').val('0.00');
						$('#montoPagarArrendamiento').focus();
					}
				}
			});

			$('#formaPagoEfectivo').blur(function(){
				$('#cantEntraMil').focus();
			});

			//fin de evento de PAGO DE ARRENDAMIENTO


			// SECCION DE EVENTOS DE PAGO DE CREDITO
			$('#creditoID').blur(function(){
				if($('#creditoID').asNumber()>0){
					consultaCredito(this.id);
					consultarParametrosBean();
					inicializarEntradasSalidasEfectivo();
					$('#garantiaAdicionalPC').val(0.0);
					$('#numeroTransaccion').val("");
					$('#numeroMensaje').val("1");
					$('#tipoTransaccion').val('');
					$('#prorrateoPago').val('');
					consultaCobroFOGAFI();
				} else {
					if( esTab){
						inicializarCampos();
						$('#clienteID').val('');
						$('#nombreCliente').val('');
						$('#monedaID').val('');
						$('#cuentaID').val('');
						$('#nomCuenta').val('');
						$('#saldoCta').val('');
						$('#estatus').val('');
						$('#diasFaltaPago').val('');
						$('#garantiaAdicionalPC').val('');
						$('#diasFaltaPago').val('');
						$('#calcInteres').val('');
						$('#tasaFija').val('');
						$('#cobraSeguroCuota').val('N');
						$('#exigibleAlDia').val('0.00');
						mensajeSis('El Número de Crédito no es Valido.');
						$('#creditoID').focus();
					}
				}
			});

			$('#creditoID').bind('keyup',function(e) {
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "creditoID";
				camposLista[1] = "nombreCliente";
				parametrosLista[0] = 0;
				parametrosLista[1] = $('#creditoID').val();


				if(Busqueda == 'GENERAL' && mostrarBotones== 'N'){
					listaAlfanumericaCte('creditoID', '2', '37', camposLista, parametrosLista, 'ListaCredito.htm');
				}

				if(Busqueda == 'SUCURSAL' && mostrarBotones== 'N'){
					listaAlfanumericaCte('creditoID', '2', '29', camposLista, parametrosLista, 'ListaCredito.htm');
				}

			});

			$('#buscarMiSucCre').click(function(){
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "creditoID";
				camposLista[1] = "nombreCliente";
				parametrosLista[0] = 0;
				parametrosLista[1] = $('#creditoID').val();
				listaAlfanumericaCte('creditoID', '2', '29', camposLista, parametrosLista, 'ListaCredito.htm');
			});
			$('#buscarGeneralCre').click(function(){
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "creditoID";
				camposLista[1] = "nombreCliente";
				parametrosLista[0] = 0;
				parametrosLista[1] = $('#creditoID').val();
				listaAlfanumericaCte('creditoID', '2', '37', camposLista, parametrosLista, 'ListaCredito.htm');
			});

			$('#montoPagar').blur(function() {
				var montoPagoExigibleDia =$('#pagoExigible').asNumber();
				var montoPagoDia =$('#montoPagar').val();
				totalEntradasSalidasDiferencia();
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
				if(montoPagoDia == ""){
					if(creditoPagado=="S"){
						mensajeSis("El Crédito ya se encuentra Liquidado.");
						deshabilitaBoton('graba', 'submit');
					}else{
						//se calcula si hay garantia liquida adicional
						if(($('#prepagoCredito').is(':checked') )&& ($('#montoPagar').asNumber() >= $('#adeudoTotalPrepago').asNumber())){
							mensajeSis("Para Liquidar el Total del Adeudo, Por Favor Seleccione la Opción Adeudo Total");
							$('#montoPagar').focus();
						}else{
							validaGarantiaAdicional();
						}

					}
				}
				else{
					if($('#exigible').is(':checked')){
						if(montoPagoExigibleDia == 0.00){
								$('#montoPagar').val("");
								$('#montoPagar').focus();
								mensajeSis('El crédito no tiene exigible al día. Si desea adelantar un pago elija la opción Prepago de Crédito');
								return false;
							}

							if(creditoPagado=="S"){
								mensajeSis("El Crédito ya se encuentra Liquidado.");
								deshabilitaBoton('graba', 'submit');
							}else{
								//se calcula si hay garantia liquida adicional
								if(($('#prepagoCredito').is(':checked') )&& ($('#montoPagar').asNumber() >= $('#adeudoTotalPrepago').asNumber())){
									mensajeSis("Para Liquidar el Total del Adeudo, Por Favor Seleccione la Opción Adeudo Total");
									$('#montoPagar').focus();
								}else{
									validaGarantiaAdicional();
								}

							}
					}
					else{
						validaGarantiaAdicional();
					}
				}

				setTimeout("consultaSaldoFOGAFI();",100);

			});

			$('#garantiaAdicionalPC').blur(function() {
				validaMontoGarantiaAdicional();
			});

			$('#garantiaAdicionalPC').focus(function() {
				if($('#exigible').is(':checked')){
					 if($('#garantiaAdicionalPC').asNumber()>0){
						 $('#garantiaAdicionalPC').select();
					 }else{
						 if($('#garantiaAdicionalPC').asNumber()==0){
							 $('#garantiaAdicionalPC').val("0.00");
						 }else{
							 $('#garantiaAdicionalPC').val("");
						 }
					 }
				}
			});

			$('#garantiaAdicionalPC').change(function() {
				sugerirGarAdiNoProrrateo($('#garantiaAdicionalPC').asNumber());
			});

			$('#montoPagar').focus(function() {
				validaFocoInputMoneda('montoPagar');
			});


			$('#cuentaID').blur(function(){
				consultaCta(this.id);
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
			});

			// se validan los eventos cuando se selecciona el
			// total del adeudo
			$('#totalAde').click(function(){
				if($('#exigible').is(':checked')){
					$('#exigible').attr('checked',false);
				}
				$('#totalAde').attr('checked',true);
				$('#finiquito').val('S');

				consultaFiniquitoLiqAnticipada();
				consultaGrupoDeudaTotalFiniquito();
				ocultaPagoCuotas();
				if($('#grupoID').val() > 0){
					$('#tipoTransaccion').val(catTipoTransaccionVen.pagoCreditoGrupal);
				}else{
					$('#tipoTransaccion').val(catTipoTransaccionVen.pagoCredito);
				}
			});

			$('#exigible').click(function(){
				if($('#totalAde').is(':checked')){
					$('#totalAde').attr('checked',false);
				}

				$('#labelPagoExigiblePC').show();
				$('#pagoExigible').show();
				consultaExigible();
				$('#labelTotalAdeGrupalPC').hide();
				$('#montoTotDeudaPC').hide();
				$('#labelTotalAdeudoPC').hide();
				$('#adeudoTotal').hide();

				$('#lblexigibleAlDia').show();
				$('#exigibleAlDia').show();
				$('#montoProyectado').show();
				$('#lblmontoProyectado').show();

				if($('#totalAde').is(':checked')){
					$('#totalAde').attr('checked',false);
					$('#finiquito').val('N');
				}
				if($('#grupoID').val() > 0){
					consultaGrupoTotalExigible();
					$('#labelPagoExiGrupoPC').show();
					$('#montoTotExigiblePC').show();

					$('#exigibleAlDiaG').show();
					$('#montoProyectadoG').show();
					$('#lblExigibleAlDiaG').show();
					$('#lblMontoProyectadoG').show();

					if($('#prorrateoPago').val()=="S"){ // si permite prorrateo de pago entonces se ejecuta el procedimiento grupal // si permite prorrateo de pago entonces se ejecuta el procedimiento grupal
						$('#tipoTransaccion').val(catTipoTransaccionVen.pagoCreditoGrupal);
					}else{
						$('#tipoTransaccion').val(catTipoTransaccionVen.pagoCredito);
					}
					muestraPagoCuotas();
				}else{

					$('#labelPagoExiGrupoPC').hide();
					$('#montoTotExigiblePC').hide();
					$('#tipoTransaccion').val(catTipoTransaccionVen.pagoCredito);

					$('#exigibleAlDiaG').hide();
					$('#montoProyectadoG').hide();
					$('#lblExigibleAlDiaG').hide();
					$('#lblMontoProyectadoG').hide();
				}
				$('#exigible').focus();

				/*Se agrega validacion para evitar la operación al momento de cambiar entre radios buttons*/
				var montoPagoExigibleDia =$('#pagoExigible').asNumber();
				var montoPagoDia =$('#montoPagar').val();
				totalEntradasSalidasDiferencia();
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
				if(montoPagoDia == ""){
					if(creditoPagado=="S"){
						mensajeSis("El Crédito ya se encuentra Liquidado.");
						deshabilitaBoton('graba', 'submit');
					}else{
						//se calcula si hay garantia liquida adicional
						if(($('#prepagoCredito').is(':checked') )&& ($('#montoPagar').asNumber() >= $('#adeudoTotalPrepago').asNumber())){
							mensajeSis("Para Liquidar el Total del Adeudo, Por Favor Seleccione la Opción Adeudo Total");
							$('#montoPagar').focus();
						}else{
							validaGarantiaAdicional();
						}

					}
				}
				else{
					if($('#exigible').is(':checked')){
						if(montoPagoExigibleDia == 0.00){
								$('#montoPagar').val("");
								$('#montoPagar').focus();
								mensajeSis('El crédito no tiene exigible al día. Si desea adelantar un pago elija la opción Prepago de Crédito');
								return false;
							}

							if(creditoPagado=="S"){
								mensajeSis("El Crédito ya se encuentra Liquidado.");
								deshabilitaBoton('graba', 'submit');
							}else{
								//se calcula si hay garantia liquida adicional
								if(($('#prepagoCredito').is(':checked') )&& ($('#montoPagar').asNumber() >= $('#adeudoTotalPrepago').asNumber())){
									mensajeSis("Para Liquidar el Total del Adeudo, Por Favor Seleccione la Opción Adeudo Total");
									$('#montoPagar').focus();
								}else{
									validaGarantiaAdicional();
								}

							}
					}
					else{
						validaGarantiaAdicional();
					}
				}
				/*Fin seccción validación*/
			});

			$('#exigible').blur(function(){
				$('#cantEntraMil').focus();
			});

			//---------PREPAGO DE CREDITO   ------------------

			$('#creditoIDPre').blur(function(){
				var numCreditoPrepago = $('#creditoIDPre').asNumber();
				if(numCreditoPrepago>0 && esTab){
					limpiaCamposPrepagoCredito();
					consultaCreditoPrepago(this.id);
					consultarParametrosBean();
					inicializarEntradasSalidasEfectivo();
					$('#numeroTransaccion').val("");
					$('#numeroMensaje').val("1");
					$('#montoPagarPre').focus();
				}
				else{
					if(esTab){
						$('#creditoIDPre').val('');
						limpiaCamposPrepagoCredito();
						$('#saldoCtaPre').val('');
						$('#tipoPrepago').val('');
						mensajeSis("El Número de Crédito no es Valido.");
						$('#creditoIDPre').focus();
					}
				}
			});

				$('#creditoIDPre').bind('keyup', function(e){
					var camposLista = new Array();
					var parametrosLista = new Array();
					camposLista[0] = "creditoID";
					camposLista[1] = "nombreCliente";
					parametrosLista[0] = 0;
					parametrosLista[1] = $('#creditoIDPre').val();

					listaAlfanumericaSoloLetras('creditoIDPre', '2', '39', camposLista, parametrosLista, 'ListaCredito.htm');
				});

			$('#montoPagarPre').blur(function(){
				var tipoPrep = $('#tipoPrepago').val();
				if(tipoPrep != 'P'){
					if ($('#montoPagarPre').asNumber() >= $('#adeudoTotalPrepagoPre').asNumber() && $('#montoPagarPre').asNumber() > 0){
						mensajeSis("Para Liquidar el Total del Adeudo, por Favor Ingrese en la Opción de Pago de Crédito.");
						$('#montoPagarPre').focus();
					}else{
						if($('#montoPagarPre').asNumber() >= $('#totalCapitalPre').asNumber() && $('#montoPagarPre').asNumber() > 0){
							mensajeSis("No Puede Prepagar el Total del Capital, por Favor Ingrese en la Opción de Pago de Crédito.");
							$('#montoPagarPre').val("0.0");
							$('#montoPagarPre').focus();
						}else{
							totalEntradasSalidasDiferencia();
							if($('#montoPagarPre').asNumber() >0){
								$('#cantEntraMil').focus();
							}

						}
					}
				}
			});

			$('#cuotasProyectadasPrepago').blur(function(){
				var numCuotas = $('#cuotasProyectadasPrepago').asNumber();
				if(numCuotas == 0){
					$('#cuotasProyectadasPrepago').val(1);
					numCuotas = 1;
				}
				if(numCuotas > 0 && numCuotas <= cuotasMaxProyectar && !isNaN(numCuotas)){
					consultaProyeccionCredPrepago();
				}else{
					mensajeSis('El Maximo de Cuotas a Proyectar es ' + cuotasMaxProyectar);
					$('#cuotasProyectadasPrepago').val('');
					$('#cuotasProyectadasPrepago').focus();
				}
			});

			$('#recibeApoyoEscolar').blur(function(){
				if($('#formaPagoOpera1').is(':checked')){
					$('#formaPagoOpera1').focus();
				}else{
					$('#formaPagoOpera2').focus();
				}

			});

			// SECCION DE EVENTOS SECCION DE EVENTOS DEVOLUCION DE GARANTIA LIQUIDA
			$('#creditoDGL').bind('keyup', function(e){
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "creditoID";
				camposLista[1] = "nombreCliente";
				parametrosLista[0] = 0;
				parametrosLista[1] = $('#creditoDGL').val();

				listaAlfanumerica('creditoDGL', '2', '38', camposLista, parametrosLista, 'ListaCredito.htm');
			});

			$('#creditoDGL').blur(function() {
				consultaCreditoDevGL(this.id);
		  		inicializarEntradasSalidasEfectivo();
				consultarParametrosBean();
				borrarDivCheques();
				$('#tipoTransaccion').val(catTipoTransaccionVen.devolucionGL);
				$('#montoCargar').val("");
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
			});

			$('#montoDevGL').blur(function() {
				if($('#montoDevGL').asNumber() > $('#saldoDisponDG').asNumber()){
					mensajeSis("El Monto es Mayor que el Saldo Disponible.");
					$('#montoDevGL').val('');
					$('#montoDevGL').focus();
				}
			});

			$('#verFirmas').blur(function() {
				$('#denoEntraMil').focus();
			});


			//EVENTOS TRANSFERENCIA ENTRE CUENTAS
				$('#cuentaAhoIDT').bind('keyup',function(e){
					if(this.value.length >= 2){
						var camposLista = new Array();
						var parametrosLista = new Array();
						camposLista[0] = "clienteID";
						camposLista[1] = "nombreCompleto";
						parametrosLista[0] = 0;
						parametrosLista[1] = $('#cuentaAhoIDT').val();

						listaAlfanumerica('cuentaAhoIDT', '2', '13', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
					}
				});

			$('#cuentaAhoIDT').blur(function() {
				cargoCuentaTrans(this.id);
		  		inicializarEntradasSalidasEfectivo();
		  		if(($('#cuentaAhoIDTC').asNumber()== $('#cuentaAhoIDT').asNumber()) && $('#cuentaAhoIDTC').asNumber() > 0){
					mensajeSis("La Cuenta Destino es Igual a la Cuenta Origen.");
					deshabilitaBoton('graba', 'submit');
					$('#cuentaAhoIDT').focus();
				}
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
				$('#impTicket').hide();
				ocultarBtnResumen();
			});

			$('#montoCargarT').blur(function() {
				if($('#montoCargarT').asNumber() > 0 &&  $('#montoCargarT').asNumber() <= $('#saldoDisponT').asNumber()
									&& $('#cuentaAhoIDTC').val() > 0 && $('#cuentaAhoIDT').asNumber() >0 && (
									$('#cuentaAhoIDTC').val() != $('#cuentaAhoIDT').asNumber())){
					habilitaBoton('graba', 'submit');
				}else if($('#montoCargarT').asNumber() <= 0 && esTab){
					mensajeSis("El Monto Debe ser Mayor a 0.");
					deshabilitaBoton('graba', 'submit');
				}else if($('#montoCargarT').asNumber() > $('#saldoDisponT').asNumber() && esTab){
					mensajeSis("El Monto No debe ser Mayor al Saldo Disponible.");
					$('#montoCargarT').focus();
					deshabilitaBoton('graba', 'submit');
				}

				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
			});

			$('#cuentaAhoIDTC').change(function() {
		   		inicializarEntradasSalidasEfectivo();
		  		if(($('#cuentaAhoIDTC').asNumber() == $('#cuentaAhoIDT').asNumber() ) && $('#cuentaAhoIDT').asNumber() > 0){
					mensajeSis("La Cuenta Destino es Igual a la Cuenta Origen.");
					deshabilitaBoton('graba', 'submit');
					$('#cuentaAhoIDTC').focus();
				}else if($('#cuentaAhoIDTC').asNumber() <= 0){
					deshabilitaBoton('graba', 'submit');
				}
		  		else if($('#montoCargarT').asNumber() > 0 &&  $('#montoCargarT').asNumber() <= $('#saldoDisponT').asNumber() && $('#cuentaAhoIDTC').asNumber() > 0){
		  			consultaClienteCtaTransfers('cuentaAhoIDTC');

				}

				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
				$('#impTicket').hide();
				ocultarBtnResumen();
			});

			$('input[name=formaPagoServicio]').change(function(){
				if($('#pagoServicioRetiro').is(':checked')){
						$('#tipoPagoServicio').val('R');
				}else if($('#pagoServicioDeposito').is(':checked')){
						$('#tipoPagoServicio').val('D');
				}else if($('#pagoServicioCheque').is(':checked')){
						$('#tipoPagoServicio').val('C');
				}
			});

			// INICIO EVENTOS PARA EL DESPOSITO PARA ACTIVACION DE CUENTAS
			$('#cuentaAhoIDdepAct').blur(function() {
		  		consultaCtaAhoDepAct(this.id);
		  		consultarParametrosBean();
		  		inicializarEntradasSalidasEfectivo();
		  		$('#tipoTransaccion').val(catTipoTransaccionVen.depositoActivaCta);
			});

			$('#cuentaAhoIDdepAct').bind('keyup',function(e) {
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "clienteID";
				camposLista[1] = "nombreCompleto";

				parametrosLista[0] = 0;
				parametrosLista[1] = $('#cuentaAhoIDdepAct').val();

				listaCte('cuentaAhoIDdepAct', '2', '25', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
			});

			$('#montoDepositoActivaCta').blur(function() {
				if($('#montoDepositoActiva').asNumber() != $('#montoDepositoActivaCta').asNumber()){
					mensajeSis('El Monto debe ser igual al Depósito Requerido.');
					$('#montoDepositoActivaCta').focus();
					$('#montoDepositoActivaCta').val($('#montoDepositoActiva').val());
				}else{
					totalEntradasSalidasDiferencia();
					$('#numeroTransaccion').val("");
					$('#numeroMensaje').val("1");
					$('#cantEntraMil').focus();
				}
			});

			function consultaCtaAhoDepAct(idControl) {
				var jqCta = eval("'#" + idControl + "'");
				var numCta = $(jqCta).val();
				var tipCon= 36;
				var CuentaAhoBeanCon = {
					'cuentaAhoID'	:numCta
				};
				setTimeout("$('#cajaLista').hide();", 200);

				if(numCta != '' && !isNaN(numCta)){
					cuentasAhoServicio.consultaCuentasAho(tipCon, CuentaAhoBeanCon,function(cuenta) {
						if(cuenta!=null){
							if(cuenta.estatus == '1'){
								$('#clienteIDdepAct').val(cuenta.clienteID);
								$('#nombreClientedepAct').val(cuenta.nombreCompleto);
								$('#tipoCuentaIDdepAct').val(cuenta.tipoCuentaID);
								$('#descTipoCuentaIDdepAct').val(cuenta.descripcionTipoCta);
							    $('#monedaIDdepAct').val(cuenta.monedaID);
							    $('#descMonedaIDdepAct').val(cuenta.descripcionMoneda);
							    $('#montoDepositoActiva').val(cuenta.montoDepositoActiva);
							    $('#montoDepositoActivaCta').val(cuenta.montoDepositoActiva);
							    $('#refCuentaTicketdepAct').val('PAGO ACTIVACIÓN CTA AHORRO');
							}else{
								mensajeSis('La Cuenta de Ahorro ya Realizo el Depósito para Activación.');
								$(jqCta).focus();
								$(jqCta).val('');
								inicializaForma('formaGenerica',idControl );
							}
						}else{
							mensajeSis("La Cuenta de Ahorro No Requiere un Depósito para Activación.");
							$(jqCta).focus();
							$(jqCta).val('');
							inicializaForma('formaGenerica',idControl );
						}
						});
				}else{
					$(jqCta).focus();
					$(jqCta).val('');
					inicializaForma('formaGenerica',idControl );
				}
			}

			// FIN EVENTOS PARA EL DESPOSITO PARA ACTIVACION DE CUENTAS


			//**** EVENTOS PARA LOS INPUTS DE ENTRADA DE EFECTIVO
			$('#cantEntraMil').blur(function() {
				if($('#cantEntraMil').asNumber()<=0){
					$('#cantEntraMil').val("0");
				}
				cantidadPorDenominacionMil(this.id);
				totalEntradasSalidasDiferencia();
			});
			$('#cantEntraQui').blur(function() {
				if($('#cantEntraQui').asNumber()<=0){
					$('#cantEntraQui').val("0");
				}
				cantidadPorDenominacionQui(this.id);
				totalEntradasSalidasDiferencia();
			});
			$('#cantEntraDos').blur(function() {
				if($('#cantEntraDos').asNumber()<=0){
					$('#cantEntraDos').val("0");
				}
				cantidadPorDenominacionDos(this.id);
				totalEntradasSalidasDiferencia();
			});
			$('#cantEntraCien').blur(function() {
				if($('#cantEntraCien').asNumber()<=0){
					$('#cantEntraCien').val("0");
				}
				cantidadPorDenominacionCien(this.id);
				totalEntradasSalidasDiferencia();
			});
			$('#cantEntraCin').blur(function() {
				if($('#cantEntraCin').asNumber()<=0){
					$('#cantEntraCin').val("0");
				}
				cantidadPorDenominacionCin(this.id);
				totalEntradasSalidasDiferencia();
			});
			$('#cantEntraVei').blur(function() {
				if($('#cantEntraVei').asNumber()<=0){
					$('#cantEntraVei').val("0");
				}
				cantidadPorDenominacionVei(this.id);
				totalEntradasSalidasDiferencia();
			});
			$('#cantEntraMon').blur(function() {
				if($('#cantEntraMon').asNumber()<=0){
					$('#cantEntraMon').val("0");
				}
				cantidadPorDenominacionMon(this.id);
				totalEntradasSalidasDiferencia();
			});
			// FIN EVENTOS PARA LOS INPUTS DE ENTRADA DE EFECTIVO



			//**** EVENTOS PARA LOS INPUTS DE SALIDA DE EFECTIVO
			$('#cantSalMil').blur(function() {
				if($('#cantSalMil').asNumber()>0 && $('#cantSalMil').asNumber()> $('#disponSalMil').asNumber()){
					mensajeSis("Efectivo Insuficiente.");
					$('#cantSalMil').focus();
					$('#cantSalMil').select();
					$('#cantSalMil').val('0');
					deshabilitaBoton('graba', 'submit');
				}else{
					if($('#cantSalMil').asNumber()<=0){
						$('#cantSalMil').val("0");
					}
					cantidadPorDenominacionMilS(this.id);
				}
				totalEntradasSalidasDiferencia();
			});
			$('#cantSalQui').blur(function() {
				if($('#cantSalQui').asNumber()>0 && $('#cantSalQui').asNumber()> $('#disponSalQui').asNumber()){
					mensajeSis("Efectivo Insuficiente.");
					$('#cantSalQui').focus();
					$('#cantSalQui').select();
					$('#cantSalQui').val('0');
					deshabilitaBoton('graba', 'submit');
				}else{
					if($('#cantSalQui').asNumber()<=0){
						$('#cantSalQui').val("0");
					}
					cantidadPorDenominacionQuiS(this.id);
				}
				totalEntradasSalidasDiferencia();
			});
			$('#cantSalDos').blur(function() {
				if($('#cantSalDos').asNumber()>0 && $('#cantSalDos').asNumber()> $('#disponSalDos').asNumber()){
					mensajeSis("Efectivo Insuficiente.");
					$('#cantSalDos').focus();
					$('#cantSalDos').select();
					$('#cantSalDos').val('0');
					deshabilitaBoton('graba', 'submit');
				}else{
					if($('#cantSalDos').asNumber()<=0){
						$('#cantSalDos').val("0");
					}
					cantidadPorDenominacionDosS(this.id);
				}
				totalEntradasSalidasDiferencia();
			});
			$('#cantSalCien').blur(function() {
				if($('#cantSalCien').asNumber()>0 && $('#cantSalCien').asNumber()> $('#disponSalCien').asNumber()){
					mensajeSis("Efectivo Insuficiente.");
					$('#cantSalCien').focus();
					$('#cantSalCien').select();
					$('#cantSalCien').val('0');
				deshabilitaBoton('graba', 'submit');
				}else{
					if($('#cantSalCien').asNumber()<=0){
						$('#cantSalCien').val("0");
					}
					cantidadPorDenominacionCienS(this.id);
				}
				totalEntradasSalidasDiferencia();
			});
			$('#cantSalCin').blur(function() {
				if($('#cantSalCin').asNumber()>0 && $('#cantSalCin').asNumber()> $('#disponSalCin').asNumber()){
					mensajeSis("Efectivo Insuficiente.");
					$('#cantSalCin').focus();
					$('#cantSalCin').select();
					$('#cantSalCin').val('0');
					deshabilitaBoton('graba', 'submit');
				}else{
					if($('#cantSalCin').asNumber()<=0){
						$('#cantSalCin').val("0");
					}
					cantidadPorDenominacionCinS(this.id);
				}
				totalEntradasSalidasDiferencia();
			});
			$('#cantSalVei').blur(function() {
				if($('#cantSalVei').asNumber()>0 && $('#cantSalVei').asNumber()> $('#disponSalVei').asNumber()){
					mensajeSis("Efectivo Insuficiente.");
					$('#cantSalVei').focus();
					$('#cantSalVei').select();
					$('#cantSalVei').val('0');
					deshabilitaBoton('graba', 'submit');
				}else{
					if($('#cantSalVei').asNumber()<=0){
						$('#cantSalVei').val("0");
					}
					cantidadPorDenominacionVeiS(this.id);
				}
				totalEntradasSalidasDiferencia();
			});

			$('#cantSalMon').blur(function() {
				if($('#cantSalMon').asNumber()>0 && $('#cantSalMon').asNumber()> $('#disponSalMon').asNumber()){
					mensajeSis("Efectivo Insuficiente."); //XXXXXXX
					$('#cantSalMon').focus();
					$('#cantSalMon').select();
					$('#cantSalMon').val('0');
					deshabilitaBoton('graba', 'submit');
				}else{
					if($('#cantSalMon').asNumber()<=0){
						$('#cantSalMon').val("0");
					}
					cantidadPorDenominacionMonS(this.id);
				}
				totalEntradasSalidasDiferencia();
			});



			// FIN EVENTOS PARA LOS INPUTS DE SALIDA DE EFECTIVO

			// llama metodo totalEntradasSalidasDiferencia
			$('#montoCargar').blur(function() {
				var monto = $('#montoCargar').asNumber();
				var disponible =  $('#saldoDisponCa').asNumber();
				if(monto >0){
					if (parseFloat(monto)>parseFloat(disponible) ){
						mensajeSis("El Monto es Superior al Saldo Disponible.");
						$('#montoCargar').val("");
						$('#montoCargar').focus();
						deshabilitaBoton('graba', 'submit');
					}else{
						totalEntradasSalidasDiferencia();
					}

				}else{
					deshabilitaBoton('graba', 'submit');
				}
			});

			//Clic a boton agregar
			$('#agregarEntEfec').click(function() {
				$('#numeroTransaccion').val("");
				totalEntradasSalidasDiferencia();
				crearListaBilletesMonedasEntrada();
				crearListaBilletesMonedasSalida();
			});
			$('#agregarSalEfec').click(function() {
				$('#numeroTransaccion').val("");
				validaDisponibleDemoninacion() ;
				crearListaBilletesMonedasEntrada();
				crearListaBilletesMonedasSalida();



			});
			function validaDisponibleDemoninacion(){
					var insuficiente ='N';
					if($('#cantSalMil').asNumber()>0 && $('#cantSalMil').asNumber()> $('#disponSalMil').asNumber()){
						mensajeSis("Efectivo Insuficiente.");
						$('#cantSalMil').focus();
						$('#cantSalMil').select();
						$('#cantSalMil').val('0');
						insuficiente ='S';
						deshabilitaBoton('graba', 'submit');
						totalEntradasSalidasDiferencia();
					}else{
						if($('#cantSalQui').asNumber()>0 && $('#cantSalQui').asNumber()> $('#disponSalQui').asNumber()){
							mensajeSis("Efectivo Insuficiente.");
							$('#cantSalQui').focus();
							$('#cantSalQui').select();
							$('#cantSalQui').val('0');
							insuficiente ='S';
							deshabilitaBoton('graba', 'submit');
							totalEntradasSalidasDiferencia();
						}else{
							if($('#cantSalDos').asNumber()>0 && $('#cantSalDos').asNumber()> $('#disponSalDos').asNumber()){
								mensajeSis("Efectivo Insuficiente.");
								$('#cantSalDos').focus();
								$('#cantSalDos').select();
								$('#cantSalDos').val('0');
								insuficiente ='S';
								deshabilitaBoton('graba', 'submit');
								totalEntradasSalidasDiferencia();
							}else{
								if($('#cantSalCien').asNumber()>0 && $('#cantSalCien').asNumber()> $('#disponSalCien').asNumber()){
									mensajeSis("Efectivo Insuficiente.");
									$('#cantSalCien').focus();
									$('#cantSalCien').select();
									$('#cantSalCien').val('0');
									totalEntradasSalidasDiferencia();
								}else{
									if($('#cantSalCin').asNumber()>0 && $('#cantSalCin').asNumber()> $('#disponSalCin').asNumber()){
										mensajeSis("Efectivo Insuficiente.");
										$('#cantSalCin').focus();
										$('#cantSalCin').select();
										$('#cantSalCin').val('0');
										insuficiente ='S';
										deshabilitaBoton('graba', 'submit');
										totalEntradasSalidasDiferencia();
									}else{
										if($('#cantSalVei').asNumber()>0 && $('#cantSalVei').asNumber()> $('#disponSalVei').asNumber()){
											mensajeSis("Efectivo Insuficiente.");
											$('#cantSalVei').focus();
											$('#cantSalVei').select();
											$('#cantSalVei').val('0');
											deshabilitaBoton('graba', 'submit');
											totalEntradasSalidasDiferencia();
											insuficiente ='S';
										}else{
											if($('#cantSalMon').asNumber()>0 && $('#cantSalMon').asNumber()> $('#disponSalMon').asNumber()){
												mensajeSis("Efectivo Insuficiente.");
												$('#cantSalMon').focus();
												$('#cantSalMon').select();
												$('#cantSalMon').val('0');
												insuficiente ='S';
												deshabilitaBoton('graba', 'submit');
												totalEntradasSalidasDiferencia();
											}else{
												totalEntradasSalidasDiferencia();
											}

										}
									}
								}
							}

						}
					}

			}

			$('#fechaSistema').val(parametroBean.fechaAplicacion);
			$('#verFirmas').click(function(){
				verFirmasCta();
			});
			//***EVENTOS PARA aPLICACION DEL SEGURO DE VIDA ***
			$('#creditoIDS').blur(function(){
				consultaCreditoSeguro(this.id);
				consultarParametrosBean();
				inicializarEntradasSalidasEfectivo();
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
				habilitaEntradasSalidasEfectivo();
			});

				$('#creditoIDS').bind('keyup',function(e){
					var camposLista = new Array();
					var parametrosLista = new Array();
					camposLista[0] = "creditoID";
					camposLista[1] = "nombreCliente";
					parametrosLista[0] = 0;
					parametrosLista[1] = $('#creditoIDS').val();
					//lista 33
					listaAlfanumericaSoloLetras('creditoIDS', '2', '33', camposLista, parametrosLista, 'ListaCredito.htm');
				});

			//***EVENTOS PARA EL COBRO DEL SEGURO DE VIDA ***
			$('#creditoIDSC').blur(function(){
				habilitaEntradasSalidasEfectivo();
				$('#montoSeguroCobro').attr('disabled',false);
				$('#montoSeguroCobro').val('');
				consultaCreditoSeguroVidaCobro(this.id);
				consultarParametrosBean();
				inicializarEntradasSalidasEfectivo();
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");

			});

			$('#montoSeguroCobro').blur(function(){
				consultarParametrosBean();
				inicializarEntradasSalidasEfectivo();
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
				totalEntradasSalidasDiferencia();
				validaMontoCobrar();
				$('#cantEntraMil').focus();

			});

				$('#creditoIDSC').bind('keyup',function(e){
					var camposLista = new Array();
					var parametrosLista = new Array();
					camposLista[0] = "creditoID";
					camposLista[1] = "nombreCliente";
					parametrosLista[0] = 0;
					parametrosLista[1] = $('#creditoIDSC').val();
					listaAlfanumerica('creditoIDSC', '2', '32', camposLista, parametrosLista, 'ListaCredito.htm');
				});



			// EVENTOS PARA EL DEPOSITO DE LA APORTACION SOCIAL

			$('#buscarMiSucA').click(function(){
				listaCte('clienteIDAS', '2', '19', 'nombreCompleto', $('#clienteIDAS').val(), 'listaCliente.htm');
			});
			$('#buscarGeneralA').click(function(){
				listaCte('clienteIDAS', '2', '31', 'nombreCompleto', $('#clienteIDAS').val(), 'listaCliente.htm');
			});

			$('#clienteIDAS').bind('keyup',function(e) {
				if(Busqueda == 'GENERAL' && mostrarBotones== 'N'){
					listaCte('clienteIDAS', '2', '31', 'nombreCompleto', $('#clienteIDAS').val(), 'listaCliente.htm');
				}

				if(Busqueda == 'SUCURSAL' && mostrarBotones== 'N'){
					listaCte('clienteIDAS', '2', '19', 'nombreCompleto', $('#clienteIDAS').val(), 'listaCliente.htm');
				}
			});


			$('#clienteIDAS').blur(function(){
				consultarParametrosBean();
				inicializarEntradasSalidasEfectivo();
				totalEntradasSalidasDiferencia();
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
				consultaClienteAportacionSocial(this.id);
				$('#tipoTransaccion').val(catTipoTransaccionVen.aportacionSocial);

			});

			$('#montoAS').blur(function(){
				consultarParametrosBean();
				inicializarEntradasSalidasEfectivo();
				if($('#montoAS').asNumber()>$('#montoPendientePagoAS').asNumber()){
					mensajeSis("El Monto Indicado Excede el Monto de Aportación Solicitado.");
					$('#montoAS').val($('#montoPendientePagoAS').val());
					$('#montoAS').focus();
				}else{
					$('#numeroTransaccion').val("");
					$('#numeroMensaje').val("1");
					totalEntradasSalidasDiferencia();
					$('#cantEntraMil').focus();
				}


			});

			//EVENTOS PARA LA DEVOLUCION DE LA APORTACION SOCIAL


			$('#buscarMiSucD').click(function(){
				listaCte('clienteIDDAS', '2', '19', 'nombreCompleto', $('#clienteIDDAS').val(), 'listaCliente.htm');
			});
			$('#buscarGeneralD').click(function(){
				listaCte('clienteIDDAS', '2', '31', 'nombreCompleto', $('#clienteIDDAS').val(), 'listaCliente.htm');
			});

			$('#clienteIDDAS').bind('keyup',function(e) {
				if(Busqueda == 'GENERAL' && mostrarBotones== 'N'){
					listaCte('clienteIDDAS', '2', '31', 'nombreCompleto', $('#clienteIDDAS').val(), 'listaCliente.htm');
				}

				if(Busqueda == 'SUCURSAL' && mostrarBotones== 'N'){
					listaCte('clienteIDDAS', '2', '19', 'nombreCompleto', $('#clienteIDDAS').val(), 'listaCliente.htm');
				}
			});

			$('#clienteIDDAS').blur(function(){
				if($.trim($('#clienteIDDAS').val())!=''){
					consultarParametrosBean();
					inicializarEntradasSalidasEfectivo();
					borrarDivCheques();
					$('#numeroTransaccion').val("");
					$('#numeroMensaje').val("1");
					consultaCteDevAportaSocial(this.id);
					totalEntradasSalidasDiferencia();
					$('#tipoTransaccion').val(catTipoTransaccionVen.devAportacionSocio);
				}

			});

			//FIN EVENTOS PARA LA DEVOLUCION DE LA APORTACION SOCIAL

			//EVENTOS PARA EL COBRO SEGURO DE VIDA AYUDA


			$('#buscarMiSucSe').click(function(){
				listaCte('clienteIDCSVA', '2', '19', 'nombreCompleto', $('#clienteIDCSVA').val(), 'listaCliente.htm');
			});
			$('#buscarGeneralSe').click(function(){
				listaCte('clienteIDCSVA', '2', '31', 'nombreCompleto', $('#clienteIDCSVA').val(), 'listaCliente.htm');
			});


			$('#clienteIDCSVA').bind('keyup',function(e) {
				if(Busqueda == 'GENERAL' && mostrarBotones== 'N'){
					listaCte('clienteIDCSVA', '2', '31', 'nombreCompleto', $('#clienteIDCSVA').val(), 'listaCliente.htm');
				}

				if(Busqueda == 'SUCURSAL' && mostrarBotones== 'N'){
					listaCte('clienteIDCSVA', '2', '19', 'nombreCompleto', $('#clienteIDCSVA').val(), 'listaCliente.htm');
				}
			});


			$('#clienteIDCSVA').blur(function(){
				consultarParametrosBean();
				inicializarEntradasSalidasEfectivo();
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
				totalEntradasSalidasDiferencia();
				consultaCtaPrincipalBen(this.id);
				$('#tipoTransaccion').val(catTipoTransaccionVen.cobroSegVidaAyuda);

			});

			//FIN EVENTOS PARA EL COBRO SEGURO DE VIDA AYUDA

			//------------ PAGO DEL SEGURO DE AYUDA  ----------------

			$('#buscarMiSucPa').click(function(){
				var camposLista = new Array();
				var parametrosLista = new Array();

				camposLista[0] = "nombreCliente";
				parametrosLista[0] = $('#clienteIDASVA').val();
				listaAlfanumericaCte('clienteIDASVA', '2', '4', camposLista, parametrosLista, 'listaClientesSeguro.htm');
			});
			$('#buscarGeneralPa').click(function(){
				var camposLista = new Array();
				var parametrosLista = new Array();

				camposLista[0] = "nombreCliente";
				parametrosLista[0] = $('#clienteIDASVA').val();
				listaAlfanumericaCte('clienteIDASVA', '2', '5', camposLista, parametrosLista, 'listaClientesSeguro.htm');
			});

			$('#clienteIDASVA').bind('keyup',function(e) {
				var camposLista = new Array();
				var parametrosLista = new Array();

				camposLista[0] = "nombreCliente";
				parametrosLista[0] = $('#clienteIDASVA').val();

				if(Busqueda == 'GENERAL' && mostrarBotones== 'N'){
					listaAlfanumericaCte('clienteIDASVA', '2', '5', camposLista, parametrosLista, 'listaClientesSeguro.htm');
				}

				if(Busqueda == 'SUCURSAL' && mostrarBotones== 'N'){
					listaAlfanumericaCte('clienteIDASVA', '2', '4', camposLista, parametrosLista, 'listaClientesSeguro.htm');
				}


			});

			$('#clienteIDASVA').blur(function(){
				consultarParametrosBean();
				inicializarEntradasSalidasEfectivo();
				habilitaEntradasSalidasEfectivo();
				borrarDivCheques();
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
				setTimeout("$('#cajaLista').hide();", 200);
				var cliente = $('#clienteIDASVA').asNumber();
				if(cliente>0){
					listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, 0, 0);
					if(listaPersBloqBean.estaBloqueado!='S'){
						expedienteBean = consultaExpedienteCliente(cliente);
						if(expedienteBean.tiempo<=1){
							consultaClientePagoSeguroAyuda(this.id);
						} else {
							mensajeSis('Es necesario Actualizar el Expediente del '+$('#socioClienteAlert').val()+' para Continuar.');
							inicializarCampos();
							$('#clienteIDASVA').focus();
						}
					} else {
						mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
						inicializarCampos();
						$('#clienteIDASVA').focus();
					}
				}
				totalEntradasSalidasDiferencia();
				$('#tipoTransaccion').val(catTipoTransaccionVen.aplicaSegVidaAyuda);

			});

			$('#seguroClienteID').change(function() {
				habilitaEntradasSalidasEfectivo();
				consultaSeguroAyudaPago();
			});

			//----------- PAGO DE REMESAS -------------
			$('#remesaCatalogoID').change(function(){
			});


			$('#numeroTarjetaRemesas').blur(function(){
				var longitudTarjeta=$('#numeroTarjetaRemesas').val().length;
				if (longitudTarjeta < 16){
					$('#numeroTarjetaRemesas').val('');
				}else{
					consultaClienteIDTarDeb('numeroTarjetaRemesas');
				}
			});

			$('#numeroTarjetaRemesas').bind('keypress', function(e){
				 return validaAlfanumerico(e,this);
			});

			$('#buscarMiSucP').click(function(){
				listaCte('clienteIDServicio', '2', '19', 'nombreCompleto', $('#clienteIDServicio').val(), 'listaCliente.htm');
			});
			$('#buscarGeneralP').click(function(){
				listaCte('clienteIDServicio', '2', '31', 'nombreCompleto', $('#clienteIDServicio').val(), 'listaCliente.htm');
			});

			$('#clienteIDServicio').bind('keyup',function(e) {
				if(Busqueda == 'GENERAL' && mostrarBotones== 'N'){
					listaCte('clienteIDServicio', '2', '31', 'nombreCompleto', $('#clienteIDServicio').val(), 'listaCliente.htm');
				}

				if(Busqueda == 'SUCURSAL' && mostrarBotones== 'N'){
					listaCte('clienteIDServicio', '2', '19', 'nombreCompleto', $('#clienteIDServicio').val(), 'listaCliente.htm');
				}
			});

			$('#clienteIDServicio').blur(function(){
				setTimeout("$('#cajaLista').hide();", 200);
				var cliente = $('#clienteIDServicio').asNumber();
				if(cliente>0){
					listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, 0, 0);
					consultaSPL = consultaPermiteOperaSPL(cliente,'LPB',esCliente);

					if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
						expedienteBean = consultaExpedienteCliente(cliente);
						if(expedienteBean.tiempo<=1){
							if($.trim($('#clienteIDServicio').val())!=''){
								consultarParametrosBean();
								inicializarEntradasSalidasEfectivo();
								habilitaEntradasSalidasEfectivo();
								borrarDivCheques();
								$('#numeroTransaccion').val("");
								$('#numeroMensaje').val("1");

								consultaClienteOtraPantalla(this.id);
								totalEntradasSalidasDiferencia();

								if($('#pagoServicioRetiro').attr("checked")== true){
									$('#divCuentaCheques').hide();
									$('#entradaSalida').show();
									$('#totales').show();//OK
									inicializarEntradasSalidasEfectivo();
									$('#tdlblNumCuentaServicio').hide();
									$('#pagoServicioRetiro').focus();
								}else if($('#pagoServicioCheque').attr("checked")== true){
									$('#cuentaChequePago').val('');
									$('#tipoChequera').val('');
									$('#numeroCuentaServicio').hide();
									$('#tdlblNumCuentaServicio').hide();
									$('#pagoServicioCheque').focus();
								}else{
									$('#divCuentaCheques').hide();
									$('#entradaSalida').hide();
									$('#totales').hide();
									$('#tdlblNumCuentaServicio').show();
									inicializarEntradasSalidasEfectivo();
									$('#pagoServicioDeposito').focus();
								}
								validaMontoServicioRemesas();
							}else{
								// BORRAR DATOS- HABILITAR CAMPOS USUARIO
								habilitaControl('usuarioRem');
								$('#clienteIDServicio').val('');
								$('#nombreClienteServicio').val('');
								$('#clienteIDServicio').focus();
								$('#usuarioRem').val('');
								$('#nombreUsuarioRem').val('');
							}
						}else{
							mensajeSis('Es necesario Actualizar el Expediente del '+$('#socioClienteAlert').val()+' para Continuar.');
							habilitaControl('nombreClienteServicio');
							habilitaControl('telefonoClienteServicio');
							habilitaControl('direccionClienteServicio');
							habilitaControl('folioIdentiClienteServicio');
							$('#nombreClienteServicio').val('');
							$('#direccionClienteServicio').val('');
							$('#telefonoClienteServicio').val('');
							limpiarCamposRemesasOportunidades();
							$('#referenciaServicio').focus();
						}
					} else {
						mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
						habilitaControl('nombreClienteServicio');
						habilitaControl('telefonoClienteServicio');
						habilitaControl('direccionClienteServicio');
						habilitaControl('folioIdentiClienteServicio');
						$('#nombreClienteServicio').val('');
						$('#direccionClienteServicio').val('');
						$('#telefonoClienteServicio').val('');
						limpiarCamposRemesasOportunidades();
						$('#referenciaServicio').focus();
					}
				}
			});

			$('#usuarioRem').bind('keyup',function(e) {
				listaCte('usuarioRem', '2', '2', 'nombreCompleto', $('#usuarioRem').val(), 'listaUsuario.htm');
			});

			$('#usuarioRem').blur(function(){
				var usuarioServ = $('#usuarioRem').asNumber();
				if(usuarioServ>0){
					listaPersBloqBean = consultaListaPersBloq(usuarioServ, esUsuario, 0, 0);
					consultaSPL = consultaPermiteOperaSPL(usuarioServ,'LPB',esUsuario);

					if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
						if($.trim($('#usuarioRem').val())!=''){
							consultarParametrosBean();
							inicializarEntradasSalidasEfectivo();
							habilitaEntradasSalidasEfectivo();
							borrarDivCheques();
							$('#numeroTransaccion').val("");
							$('#numeroMensaje').val("1");

							consultaUsuarios(this.id);
							totalEntradasSalidasDiferencia();

								if($('#pagoServicioRetiro').attr("checked")== true){
									$('#divCuentaCheques').hide();
									$('#entradaSalida').show();
									$('#totales').show();//OK
									inicializarEntradasSalidasEfectivo();
									$('#tdlblNumCuentaServicio').hide();
									$('#pagoServicioRetiro').focus();
								}else if($('#pagoServicioCheque').attr("checked")== true){
									$('#cuentaChequePago').val('');
									$('#tipoChequera').val('');
									$('#numeroCuentaServicio').hide();
									$('#tdlblNumCuentaServicio').hide();
									$('#pagoServicioCheque').focus();
								}else{
									$('#divCuentaCheques').hide();
									$('#entradaSalida').hide();
									$('#totales').hide();
									$('#tdlblNumCuentaServicio').show();
									inicializarEntradasSalidasEfectivo();
									$('#pagoServicioDeposito').focus();
								}

								validaMontoServicioRemesas();
						}else{
							// BORRAR DATOS- HABILITAR CAMPOS CLIENTE
							habilitaControl('clienteIDServicio');
							limpiarCamposRemesasOportunidades();
						}
					} else {
						mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
						habilitaControl('clienteIDServicio');
						$('#clienteIDServicio').val('');
						$('#nombreClienteServicio').val('');
						$('#usuarioRem').val('');
						$('#nombreUsuarioRem').val('');
						limpiarCamposRemesasOportunidades();
						$('#referenciaServicio').focus();
					}
				}else{
					// BORRAR DATOS- HABILITAR CAMPOS CLIENTE
					habilitaControl('clienteIDServicio');
					$('#clienteIDServicio').val('');
					$('#nombreClienteServicio').val('');
					$('#usuarioRem').focus();
					$('#usuarioRem').val('');
					$('#nombreUsuarioRem').val('');
				}
			});
			
			$('#referenciaServicio').bind('keyup', function(e){
				var camposLista = new Array();
			    var parametrosLista = new Array();
			    camposLista[0] = "descripcion";
			    parametrosLista[0] = $('#referenciaServicio').val();
				lista('referenciaServicio', '2', '2', camposLista, parametrosLista,'listaRemesasWS.htm');
			});
			
			// Consulta de Referencia de la Remesa
			$('#referenciaServicio').blur(function() {
				setTimeout("$('#cajaLista').hide();", 200);
				if(esTab){
					consultaReferenciaClabeRemesa(this.id);					
				}
			});
			
			$('#clabeCobroRemesa').bind('keyup', function(e){
				var camposLista = new Array();
			    var parametrosLista = new Array();
			    camposLista[0] = "descripcion";
			    parametrosLista[0] = $('#clabeCobroRemesa').val();
				lista('clabeCobroRemesa', '2', '3', camposLista, parametrosLista,'listaRemesasWS.htm');
			});
			
			// Consulta de clabe cobro de la Remesa
			$('#clabeCobroRemesa').blur(function() {
				setTimeout("$('#cajaLista').hide();", 200);
				if(esTab){
					consultaReferenciaClabeRemesa(this.id);					
				}
			});
			// Función para consultar la Referencia de Remesas
			function consultaReferenciaClabeRemesa(idControl) {
				var jqIDControl = eval("'#" + idControl + "'");
				var remesaFolioID = $('#referenciaServicio').val();
				var clabeCobro = $('#clabeCobroRemesa').val();
				var numConsulta = 3;			
				var bean = {
						'remesaFolioID':remesaFolioID,
						'clabeCobroRemesa':clabeCobro 
				};
				limpiarCamposRemesasOportunidades();
				$('#clienteIDServicio').val('');
				$('#usuarioRem').val('');				
				$('#referenciaServicio').val('');
				$('#clabeCobroRemesa').val('');
				
				setTimeout("$('#cajaLista').hide();", 200);
				if(remesaFolioID != '' || clabeCobro != ''){
					bloquearPantalla();
					revisionRemesasServicio.consulta(numConsulta,bean,function(remesas){
						if (remesas != null) {
							if(remesas.formaPago == 'R'){
								if(remesas.estatus == 'N'){
									$('#referenciaServicio').val(remesas.remesaFolioID);
									$('#clabeCobroRemesa').val(remesas.clabeCobroRemesa);
									$('#montoServicio').val(remesas.monto);
									$('#montoServicio').formatCurrency({
										positiveFormat : '%n',
										roundToDecimalPlace : 2
									});
									$('#remesaCatalogoID').val(remesas.remesadora);
									$('#direccionClienteServicio').val(remesas.direccion);
									$('#telefonoClienteServicio').val(remesas.numTelefonico);
									$('#indentiClienteServicio').val(remesas.tipoIdentiID);
									$('#folioIdentiClienteServicio').val(remesas.folioIdentific);
									
															
									$('#nombreEmisor').val(remesas.nombreCompletoRemit);
									$('#paisRemitente').val(remesas.paisIDRemitente);
									$('#estadoRemitente').val(remesas.estadoIDRemitente);
									$('#ciudadRemitente').val(remesas.ciudadIDRemitente);
									$('#coloniaRemitente').val(remesas.coloniaIDRemitente);
									$('#cpRemitente').val(remesas.codigoPostalRemitente);
									$('#domicilioRemitente').val(remesas.direcRemitente);
									
									
									
									if(remesas.clienteID > 0){
										$('#clienteIDServicio').val(remesas.clienteID);
										$('#clienteIDServicio').focus();							
									}
									if(remesas.usuarioServicioID > 0){
										$('#usuarioRem').val(remesas.usuarioServicioID);
										$('#usuarioRem').focus();		
									}
									
									$('#contenedorForma').unblock();
								}else{
									$('#contenedorForma').unblock();
									$(jqIDControl).val('');				
									$(jqIDControl).focus();
									if(remesas.estatus == 'R'){
										mensajeSis('La Remesa está en revisión por el oficial de cumplimiento.');									
									}else if(remesas.estatus == 'P'){
										mensajeSis('La Remesa está Pagada.');									
									}else if(remesas.estatus == 'C'){
										mensajeSis('La Remesa está Rechazada.');									
									}else{
										mensajeSis('La Remesa No Existe.');
									}
								}
							}else{
								$('#contenedorForma').unblock();
								$(jqIDControl).val('');				
								$(jqIDControl).focus();
								mensajeSis('La Forma de Pago de la Remesa debe ser Retiro Efectivo(R).');								
							}
						}else {
							$('#contenedorForma').unblock();
							$(jqIDControl).val('');				
							$(jqIDControl).focus();
							mensajeSis('La Remesa No Existe.');
						}
					});
				}
			}

			// Función para Adjuntar el Documento de Check List ientificacion de Remesas
			function adjuntarDocumentoRemesa() {
				var varRemesaFolioID = $('#referenciaServicio').val();
				if(varRemesaFolioID != ''){
					if($('#indentiClienteServicio').val() != ''){
						if($('#folioIdentiClienteServicio').val() != ''){

							var varIdarchivo = 0;
							var varIdDocumento = 2;	
							if($('#indentiClienteServicio').val() == 1){
								varIdDocumento = 3;						
							}else if($('#indentiClienteServicio').val() == 2){
								varIdDocumento = 4;						
							}else if($('#indentiClienteServicio').val() == 3){
								varIdDocumento = 7;						
							}else if($('#indentiClienteServicio').val() == 4){
								varIdDocumento = 6;						
							}else if($('#indentiClienteServicio').val() == 5){
								varIdDocumento = 5;						
							}
							var varDescripcionDoc = $('#folioIdentiClienteServicio').val();
							

							if($('#usuarioRem').asNumber() > 0){ // adjunta archivos usuario
								var url ="usuarioFileUploadVista.htm?Usr="+$('#usuarioRem').val()+"&Ti="+$('#indentiClienteServicio').val();
								var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
								var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;

								ventanaArchivosCuenta = window.open(url,"PopUpSubirArchivo","width=680,height=340,scrollbars=auto,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
																"left="+leftPosition+
																",top="+topPosition+
																",screenX="+leftPosition+
																",screenY="+topPosition);	
							}else{ // adjunta archivos cliente
								var url ="revRemesasCheckListDoc.htm?remesaFolioID="+varRemesaFolioID+"&checkListRemWSID="+varIdarchivo+"&tipoDocumentoID="+varIdDocumento+"&descripcionDoc="+varDescripcionDoc;
						 		var leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
						 		var topPosition = (screen.height) ? (screen.height-500)/2 : 0;
						 		ventanaDocumentosRemesas = window.open(url,
						 				"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no," +
						 				"addressbar=0,menubar=0,toolbar=0"+
						 				"left="+leftPosition+
						 				",top="+topPosition+
						 				",screenX="+leftPosition+
						 				",screenY="+topPosition);
								
							}
							
						}else{
							$('#folioIdentiClienteServicio').focus();
							mensajeSis('Especifique el folio de Identificación');							
						}
					}else{
						$('#indentiClienteServicio').focus();
						mensajeSis('Especifique la Identificación');					
					}					
				}else{
					$('#referenciaServicio').focus();
					mensajeSis('Especifique la Referencia');					
				}
			}

			$('#pagoServicioRetiro').click(function() {
				$('#divCuentaCheques').hide();
				$('#entradaSalida').show();
				$('#totales').show();//OK
				inicializarEntradasSalidasEfectivo();
				$('#tdlblNumCuentaServicio').hide();
				$('#pagoServicioRetiro').focus();
			});

			$('#pagoServicioDeposito').click(function() {
				$('#divCuentaCheques').hide();
				$('#entradaSalida').hide();
				$('#totales').hide();
				$('#tdlblNumCuentaServicio').show();
				inicializarEntradasSalidasEfectivo();
				//$('#pagoServicioDeposito').focus();
				$('#numeroCuentaServicio').focus();
			});

			$('#numeroCuentaServicio').blur(function(){//
				consultaEstatusCuenta(this.id,'clienteIDServicio');
			});

			$('#pagoServicioCheque').click(function() {	//nnnn
				$('#cuentaChequePago').val('');
				$('#tipoChequera').val('');
				$('#numeroCuentaServicio').hide();
				$('#tdlblNumCuentaServicio').hide();
				$('#divCuentaCheques').show();
				$('#pagoServicioCheque').focus();
			});

			$('#indentiClienteServicio').change(function() {
				$('#folioIdentiClienteServicio').val('');
					consultaTipoIdent();
			});

				$('#numeroCuentaServicio').bind('keyup',function(e){
					var camposLista = new Array();
					var parametrosLista = new Array();
					camposLista[0] = "clienteID";
					camposLista[1] = "nombreCompleto";
					parametrosLista[0] = $('#clienteIDServicio').val();
					parametrosLista[1] = $('#numeroCuentaServicio').val();

					lista('numeroCuentaServicio', '2', '13', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
				});


			$('#numeroCuentaServicio').change(function(){
				setTimeout("$('#cajaLista').hide();", 200);
			});

			$('#pagoServicioRetiro').click(function() {
				habilitaEntradasSalidasEfectivo();
				$('#numeroCuentaServicio').hide();
				$('#tdlblNumCuentaServicio').hide();
				$('#numeroCuentaServicio').val("");
				$('#pagoServicioRetiro').focus();

				if($('#montoServicio').asNumber()>0){
					totalEntradasSalidasDiferencia();
				}
			});

			$('#pagoServicioDeposito').click(function() {
				habilitaEntradasSalidasEfectivo();
				$('#numeroCuentaServicio').show();
				$('#tdlblNumCuentaServicio').show();
				if($('#clienteIDServicio').val() > 0  && $('#clienteIDServicio').val() !=''){
					$('#numeroCuentaServicio').show();
					$('#tdlblNumCuentaServicio').show();
					$('#numeroCuentaServicio').val("");
					$('#pagoServicioDeposito').focus();
					soloLecturaEntradasSalidasEfectivo();
					inicializarSalidasEfectivo();
					if ($('#montoServicio').asNumber()>0){
						totalEntradasSalidasDiferencia();
					}

				}else{
					mensajeSis("No ha Especificado un Número de Socio.");
					$('#clienteIDServicio').focus();
				}
			});


			$('#montoServicio').blur(function() {
				validaMontoServicioRemesas();
			});

			$('#referenciaServicio').blur(function(){
				var referencia= $('#referenciaServicio').val().replace(/[' ']/gi,'');
				$('#referenciaServicio').val(referencia);

			});

			// boton para adjuntar identificacion en el pago de remesas
			$('#adjuntarIdentificacion').click(function(){
				if($('#indentiClienteServicio').val() != ''){
					if($('#folioIdentiClienteServicio').val() != ''){
						adjuntarDocumentoRemesa();	
					}else{
						$('#folioIdentiClienteServicio').focus();
						mensajeSis('Ingresar un folio de Identificación.');
					}
				}else{
					$('#indentiClienteServicio').focus();
					mensajeSis('Seleccionar una Identificación.');
				}
			});

			//-----------------Recepcion de Documentos SBCCC ---------------

			$('#numeroCuentaRec').blur(function() {
				var numCtaSBC=$('#numeroCuentaRec').val();
				if(numCtaSBC !='' && !isNaN(numCtaSBC) ){
					 var cuentaAhorroSBC=$('#numeroCuentaRec').val().length;
					 if(cuentaAhorroSBC>11){
						 var maxLong=$('#numeroCuentaRec').val();
						 var max=maxLong.substring(0,11);
						 $('#numeroCuentaRec').val(max);
					 }
				}
				limpiaCamposChequeSBC();
				consultaCtaAhoChequeSBC(this.id,'tipoCuentaSBC','clienteIDSBC','saldoDisponibleSBC',
										'saldoBloqueadoSBC','nombreClienteSBC');// recepcionDocumentosSBC.js
				consultarParametrosBean();
				inicializarEntradasSalidasEfectivo();
				$('#beneficiarioSBC').val('');
				$('#tipoTransaccion').val(catTipoTransaccionVen.recepcionChequeSBC);
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
			});

			//Cheques Internos
			$('#montoSBC').blur(function() {
				totalEntradasSalidasDiferencia();
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
				$('#graba').focus();
				validaEmpresaID();
			});







			//------------------------- APLICACION DE CHEQUE SSSBC----------------

				$('#numeroCuentaSBC').bind('keyup',function(e){
					if(this.value.length >= 2){
						var camposLista = new Array();
						var parametrosLista = new Array();
						camposLista[0] = "clienteID";
						camposLista[1] = "nombreCompleto";
						parametrosLista[0] = 0;
						parametrosLista[1] = $('#numeroCuentaSBC').val();

						listaAlfanumerica('numeroCuentaSBC', '2', '17', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
					}
				});

			$('#numeroCuentaSBC').blur(function() {
				var numCtaAplicaSBC=$('#numeroCuentaSBC').val();
				if(numCtaAplicaSBC !='' && !isNaN(numCtaAplicaSBC) ){
					 var cuentaAhorroSBCAplica=$('#numeroCuentaSBC').val().length;
					 if(cuentaAhorroSBCAplica>11){
						 var maxLongi=$('#numeroCuentaSBC').val();
						 var maxim=maxLongi.substring(0,11);
						 $('#numeroCuentaSBC').val(maxim);
					 }
				}
				limpiaCamposChequeSBC();
				consultaCtaAhoChequeSBC(this.id,'tipoCuentaSBCAplic','clienteIDSBCAplic','saldoDisponibleSBCAplic',
										'saldoBloqueadoSBCAplic','nombreClienteSBCAplic'); // recepcionDocumentosSBC.js
				llenaComboCheques();
				consultarParametrosBean();
				inicializarEntradasSalidasEfectivo();
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
			});

			$('#clientechequeSBCAplic').change(function() {
				consultaChequeSBC(this.id);
				$('#cantEntraMil').focus();

			});
			//-------------------- PAGO DE SERVICIOS ------------------
			validaEmpresaID();



			$('#buscarMiSucC').click(function(){
				if(reactiva==$('#catalogoServID').val()){
					listaCte('clienteIDCobroServ', '2', '27', 'nombreCompleto', $('#clienteIDCobroServ').val(), 'listaCliente.htm');
				}else{
					listaCte('clienteIDCobroServ', '2', '19', 'nombreCompleto', $('#clienteIDCobroServ').val(), 'listaCliente.htm');
				}
			});
			$('#buscarGeneralC').click(function(){

				if(reactiva==$('#catalogoServID').val()){
					listaCte('clienteIDCobroServ', '2', '32', 'nombreCompleto', $('#clienteIDCobroServ').val(), 'listaCliente.htm');
				}else{
					listaCte('clienteIDCobroServ', '2', '31', 'nombreCompleto', $('#clienteIDCobroServ').val(), 'listaCliente.htm');
				}
			});


			$('#clienteIDCobroServ').bind('keyup',function(e) {

				if(Busqueda == 'GENERAL' && mostrarBotones== 'N'){
					if(reactiva==$('#catalogoServID').val()){
						listaCte('clienteIDCobroServ', '2', '32', 'nombreCompleto', $('#clienteIDCobroServ').val(), 'listaCliente.htm');
					}else{
						listaCte('clienteIDCobroServ', '2', '31', 'nombreCompleto', $('#clienteIDCobroServ').val(), 'listaCliente.htm');
					}
				}

				if(Busqueda == 'SUCURSAL' && mostrarBotones== 'N'){
					if(reactiva==$('#catalogoServID').val()){
						listaCte('clienteIDCobroServ', '2', '27', 'nombreCompleto', $('#clienteIDCobroServ').val(), 'listaCliente.htm');
					}else{
						listaCte('clienteIDCobroServ', '2', '19', 'nombreCompleto', $('#clienteIDCobroServ').val(), 'listaCliente.htm');
					}
				}
			});


				$('#creditoIDServicio').bind('keyup',function(e){
					if(this.value.length >= 2){
						var camposLista = new Array();
						var parametrosLista = new Array();
						camposLista[0] = "creditoID";
						camposLista[1] = "nombreCliente";
						camposLista[2]="clienteID";
						parametrosLista[0] = '';
						parametrosLista[1] = $('#creditoIDServicio').val();
						parametrosLista[2]=$('#clienteIDCobroServ').val();
						//lista 26 antes
						lista('creditoIDServicio', '2', '13', camposLista, parametrosLista, 'ListaCredito.htm');
					}
				});

				$('#prospectoIDServicio').bind('keyup',function(e){
					lista('prospectoIDServicio', '1', '1', 'prospectoID', $('#prospectoIDServicio').val(), 'listaProspecto.htm');
				});

			$('#catalogoServID').change(function() {
				limpiaCamposPagoServicio();
				inicializarEntradasSalidasEfectivo();
		  		consultarParametrosBean();
		  		consultaCatalogoServicio($('#catalogoServID').asNumber());
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
			});


			$('#clienteIDCobroServ').blur(function() {
				setTimeout("$('#cajaLista').hide();", 200);
				var cliente = $('#clienteIDCobroServ').asNumber();
				if(cliente>0){
					listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, 0, 0);
					consultaSPL = consultaPermiteOperaSPL(cliente,'LPB',esCliente);

					if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
						expedienteBean = consultaExpedienteCliente(cliente);
						if(expedienteBean.tiempo<=1){
							if(reactiva == $('#catalogoServID').val()){
								consultaReactivacionCte('clienteIDCobroServ');
							}else{
								consultaProspectoCliente(this.id);
								limpiaCamposCreditoPagoServicio();
							}
						} else {
							mensajeSis('Es Necesario Actualizar el Expediente del '+$('#socioClienteAlert').val()+' para Continuar.');
							limpiaCamposPagoServicio();
							$('#clienteIDCobroServ').focus();
						}
					} else {
						mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
						limpiaCamposPagoServicio();
						$('#clienteIDCobroServ').focus();
					}
				}

			});
			$('#prospectoIDServicio').blur(function() {
				consultaClienteProspecto(this.id);
			});
			$('#montoPagoServicio').blur(function() {
				actualizaSaldoTotalPagarServicio();
			});
			$('#segundaRefeServicio').blur(function() {
				$('#cantEntraMil').focus();
			});
			$('#creditoIDServicio').blur(function() {
				if($('#creditoIDServicio').val()==""){
						$('#prodCredCobroServ').val('');
						$('#desProdCreditoPagServ').val('');

				}else{
					consultaCreditoPagoServicios(this.id);
				}

			});

			//----------------------EVENTOS PARA LA RECUPERACION DE LA CARTERA VENCIDA

				$('#creditoVencido').bind('keyup',function(e){
					if(this.value.length >= 2){
						var camposLista = new Array();
						var parametrosLista = new Array();
						camposLista[0] = "creditoID";
						camposLista[1] = "nombreCliente";
					parametrosLista[0] = 0;
						parametrosLista[1] = $('#creditoVencido').val();

					listaAlfanumericaSoloLetras('creditoVencido', '2', '21', camposLista, parametrosLista, 'ListaCredito.htm');
				}
				});

			$('#creditoVencido').blur(function() {
				consultaCreditoCartVencida(this.id);
				inicializarEntradasSalidasEfectivo();
		  		consultarParametrosBean();
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
			});

			$('#montoRecuperar').blur(function() {
				totalEntradasSalidasDiferencia();
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
				$('#cantEntraMil').focus();

			});

			//-----	SERVIFUN ----
			$('#serviFunFolioID').blur(function() {
				validaServiFun(this.id); /* pagoServifun.js*/
				consultarParametrosBean();
				inicializarEntradasSalidasEfectivo();
				totalEntradasSalidasDiferencia();
				borrarDivCheques();
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
				$('#tipoTransaccion').val(catTipoTransaccionVen.pagoServifun);
			});

			$('#montoSobrante').blur(function() {
				consultaParametros(this.id);
				consultarParametrosBean();
				inicializarEntradasSalidasEfectivo();
				totalEntradasSalidasDiferencia();
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
				$('#tipoTransaccion').val(catTipoTransaccionVen.ajusteSobrante);
			});
			$('#montoFaltante').blur(function() {
				consultaParametros(this.id);
				consultarParametrosBean();
				inicializarEntradasSalidasEfectivo();
				totalEntradasSalidasDiferencia();
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
				$('#tipoTransaccion').val(catTipoTransaccionVen.ajusteFaltante);
			});
			$('#contraseniaAut').blur(function() {
				if($('#tipoOperacion').val() == ajusteSobrante){
					$('#cantEntraMil').focus();
				}else if($('#tipoOperacion').val() == ajusteFaltante ){
					$('#cantSalMil').focus();
				}

			});

			function consultaParametros(param) {
				var numSucursal = parametroBean.sucursal;
				habilitaEntradasSalidasEfectivo();
				var jqMonto  = eval("'#" + param + "'");
				var monto = $(jqMonto).asNumber();

				var conParametros = 1;
				var parametros	={
						'sucursalID'	: numSucursal
				};
				if(numSucursal != '' && !isNaN(numSucursal) && monto > 0 ){
					paramFaltaSobraServicio.consulta(conParametros,parametros,function(datos) {
						if(datos!=null){
							if(param=="montoSobrante"){
								var monto=datos.montoMaximoSobra;
								var montoMax=monto.replace(/\,/g,'');
								if($('#montoSobrante').asNumber() >montoMax){
									mensajeSis("El Monto Máximo Permitido para Ajuste por Sobrante es: $"+datos.montoMaximoSobra);
									$('#montoSobrante').focus();
									$('#montoSobrante').val(datos.montoMaximoSobra);

								}
							}else{
								var monto=datos.montoMaximoFalta;
								var montoMax=monto.replace(/\,/g,'');
								if($('#montoFaltante').asNumber() > montoMax){
									mensajeSis("El Monto Máximo Permitido para Ajuste por Faltante es: $"+datos.montoMaximoFalta);
									$('#montoFaltante').focus();
									$('#montoFaltante').val(datos.montoMaximoFalta);

								}
							}
						}else{

							if(param=="montoSobrante"){
								mensajeSis('La Sucursal No Tiene Parametrizado el Ajuste por Sobrante.');
								$('#montoSobrante').focus();
								$('#montoSobrante').val('');

							}else{
								mensajeSis('La Sucursal No Tiene Parametrizado el Ajuste por Faltante.');
								$('#montoFaltante').focus();
								$('#montoFaltante').val('');
							}
						}
					});
				};
			}

			// --------------- INICIO SECCION EVENTOS COBRO ACCESORIOS  -----------------------
			$('#creditoIDCA').bind('keyup',function(){
				var camposLista = new Array();
				var parametrosLista = new Array();

				camposLista[0] = "creditoID";
				parametrosLista[0] = $('#creditoIDCA').val();

				lista('creditoIDCA', '2', '54', camposLista, parametrosLista, 'ListaCredito.htm');
			});

			$('#creditoIDCA').blur(function(){
				consultaCreditoCobAcc('creditoIDCA');
			});

			$('#accesorioID').change(function(){
				consultaSaldoAccesorio('creditoIDCA');
			});

			$('#totalDepCA').blur(function(){
				if ($('#totalDepCA').asNumber()>0) {
					totalEntradasSalidasDiferencia();

					calcMontosPagAccesorios();

					// validar el monto que se paga
					var totalPago = $('#totalDepCA').asNumber();
					var totalSugerido =  $('#comisionPendienteCA').asNumber() +  $('#ivaPendienteCA').asNumber();
					if (totalPago>totalSugerido) {
						mensajeSis("El monto de pago es mayor al monto del Accesorio");
						setTimeout("$('#totalDepCA').focus();",0);
					}else{
						$('#cantEntraMil').focus();
					}
				}
			});
			// --------------- FIN SECCION EVENTOS COBRO ACCESORIOS  --------------------------

			// INICIO SECCION DE EVENTOS DEPOSITO ACTIVA CUENTA

			$('#cuentaAhoIDdepAct').bind('keyup',function(e) {
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "clienteID";
				camposLista[1] = "nombreCompleto";

				parametrosLista[0] = 0;
				parametrosLista[1] = $('#cuentaAhoIDdepAct').val();

				listaCte('cuentaAhoIDdepAct', '2', '15', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
			});

			$('#cuentaAhoIDAb').blur(function() {
		  		consultaCtaAhoAbono(this.id);
		  		consultarParametrosBean();
		  		inicializarEntradasSalidasEfectivo();
		  		$('#tipoTransaccion').val(catTipoTransaccionVen.abonoCuenta);
				$('#montoAbonar').val("");
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
			});

			$('#montoAbonar').blur(function() {
				totalEntradasSalidasDiferencia();
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
			});
			// FIN SECCION DE EVENTOS ACTIVA CUENTA
			// SECCION DE EVENTOS DE PAGO POR CHEQUES

			$('#formaPagoOpera1').click(function(){
				$('#formaPagoOpera1').focus();
				if($('#formaPagoOpera1').is(':checked')){
					consultaDisponibleDenominacion();
				}
			});



			$('#formaPagoOpera2').click(function(){
				$('#formaPagoOpera2').focus();
				if($('#formaPagoOpera2').is(':checked')){
					inicializarEntradasSalidasEfectivo();
				}
			});

			//
		  	$('#impPoliza').click(function(){
				var fecha = parametroBean.fechaSucursal;
				window.open('RepPoliza.htm?polizaID='+Var_Poliza+'&fechaInicial='+fecha+
						'&fechaFinal='+fecha+'&nombreUsuario='+parametroBean.nombreUsuario,'_blank' );

			});

			//Clic a boton para imprimir ticket
			function imprimirTicketVentanilla(){
				var BotonTransaccion="G";
				consultaDisponibleDenominacion();
					switch($('#tipoTransaccion').val())
					{
						case catTipoTransaccionVen.pagoCredito:
							if(TipoImpresion !=ticket){

								if($('#montoPagar').asNumber()>$('#garantiaAdicionalPC').asNumber()){
									window.open('RepTicketVentanillaPagCred.htm?fechaSistemaP='+$('#fechaSistemaP').val()+
											'&monto='+$('#montoPagar').val()+
											'&nombreInstitucion='+$('#nombreInstitucion').val()+
											'&numeroSucursal='+$('#numeroSucursal').val()+
											'&nombreSucursal='+$('#nombreSucursal').val()+
											'&varCaja='+$('#numeroCaja').val()+
											'&nomCajero='+$('#nomCajero').val()+
											'&varCreditoID='+$('#creditoID').val()+
											'&numCopias='+$('#numCopias').val()+
											'&sumTotalEnt='+$('#sumTotalEnt').val()+
											'&diferencia='+$('#sumTotalSal').val()+
											'&varFormaPago='+"Efectivo"+
											'&tipoTransaccion='+$('#tipoTransaccion').val()+
											'&numTrans='+$('#numeroTransaccion').val()+
											'&moneda='+$('#monedaDes').val()+
											'&productoCred='+''+
											'&grupo='+$('#grupoDes').val()+
											'&ciclo='+$('#cicloID').val()+
											'&cobraSeguroCuota='+$('#cobraSeguroCuota').val()+
											'&montoSeguroCuota='+$('#montoSeguroCuota').val()+
											'&ivaSeguroCuota='+$('#ivaSeguroCuota').val()+
											'&grupo='+$('#grupoDes').val(),
											'_blank');
								}
								if($('#garantiaAdicionalPC').asNumber()>0){
									var fechaHora = $('#fechaSistemaP').val()+" " +hora();
									var varCreditoID = $('#creditoID').val();
									window.open('RepTicketVentanillaGLAdicional.htm?fechaSistemaP='+fechaHora+
											'&monto='+$('#garantiaAdicionalPC').val()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+
											$('#numeroSucursal').val()+
											'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
											'&varCreditoID='+varCreditoID+'&numCopias='+$('#numCopias').val()+'&sumTotalEnt='+$('#sumTotalEnt').val()+
											'&diferencia='+$('#sumTotalSal').val()+'&varFormaPago='+"Efectivo"+
											'&numCli='+$('#clienteID').val()+'&nombreCli='+limpiarCaracteresEsp($('#nombreCliente')).val()+'&cuentaAho='+$('#ctaGLAdiID').val()+
											'&tipoCuen='+""+'&tipoTransaccion='+catTipoTicketVen.garantiaLiquidaAdicional+
											'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+$('#monedaDes').val()+'&productoCred='+''+
											'&tipoCuen='+""+'&grupo='+$('#grupoDes').val()+
											'&ciclo='+$('#cicloID').val(), '_blank');
								}

							}else{
								var credito=$('#creditoID').val();
								var fechaPago=$('#fechaSistemaP').val();
								var transaccion=$('#numeroTransaccion').val();
								var contador=1;

								var ctaGLAdiIDInt = $('#ctaGLAdiID').val();
								var  montoGL =  $('#garantiaAdicionalPC').val();
								var clienteID		=$('#clienteID').val();
								var NombreCompelto	=$('#nombreCliente').val();

								if($('#garantiaAdicionalPC').asNumber()>0){
									imprimeTicketPagoCredito(credito, fechaPago, transaccion,contador,'S',ctaGLAdiIDInt,montoGL,clienteID,NombreCompelto);
								}else{
									imprimeTicketPagoCredito(credito, fechaPago, transaccion,contador,'N',ctaGLAdiIDInt,montoGL,clienteID,NombreCompelto);
								}
								imprimeTicket();
							}
						break;
						case catTipoTransaccionVen.pagoCreditoGrupal:
							if( $('#grupoID').val() >0){
								imprimirTicketGrupal();
								if($('#prorrateoPago').val()=="S"){ // si permite prorrateo de pago entonces se ejecuta el procedimiento grupal
									$('#tipoTransaccion').val(catTipoTransaccionVen.pagoCreditoGrupal);
								}else{
									$('#tipoTransaccion').val(catTipoTransaccionVen.pagoCredito);
								}
							}
						break;
						case catTipoTransaccionVen.garantiaLiq:
							var fechaHora = $('#fechaSistemaP').val()+" " +hora();
							var varCreditoID = $('#referenciaGL').val();
							if(TipoImpresion !=ticket){
							window.open('RepTicketVentanillaGarantiaLiq.htm?fechaSistemaP='+fechaHora+
									'&monto='+$('#montoGarantiaLiq').val()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
									'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
									'&varCreditoID='+varCreditoID+'&numCopias='+$('#numCopias').val()+'&sumTotalEnt='+$('#sumTotalEnt').val()+
									'&diferencia='+$('#sumTotalSal').val()+'&varFormaPago='+"Efectivo"+
									'&numCli='+$('#numClienteGL').val()+'&nombreCli='+limpiarCaracteresEsp($('#nombreClienteGL').val())+'&cuentaAho='+$('#cuentaAhoIDGL').val()+
									'&tipoCuen='+$('#tipoCuentaGL').val()+'&tipoTransaccion='+$('#tipoTransaccion').val()+
									'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+$('#monedaGL').val()+'&productoCred='+''+
									'&tipoCuen='+$('#tipoCuentaGL').val()+'&grupo='+$('#grupoDesGL').val()+
									'&ciclo='+$('#cicloIDGL').val(), '_blank');

							}else{
							imprimirTicketTransaccion(BotonTransaccion);
							}
						break;
						case catTipoTransaccionVen.cargoCuenta:

					reimprimeTickets(1, $('#numeroTransaccion').val(), $('#numCopias').val());

						break;
						case catTipoTransaccionVen.abonoCuenta:

					reimprimeTickets(2, $('#numeroTransaccion').val(), $('#numCopias').val());


						break;
						case catTipoTransaccionVen.comisionApertura:
							var fechaHora = $('#fechaSistemaP').val()+" " +hora();
							var varCreditoID = $('#creditoIDAR').val();
							if(TipoImpresion !=ticket){
							window.open('RepTicketVentanillaComApCre.htm?fechaSistemaP='+fechaHora+
									'&monto='+$('#totalDepAR').val()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
									'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
									'&varCreditoID='+varCreditoID+'&numCopias='+$('#numCopias').val()+'&sumTotalEnt='+$('#sumTotalEnt').val()+
									'&diferencia='+$('#sumTotalSal').val()+'&varFormaPago='+"Efectivo"+
									'&numCli='+$('#clienteIDAR').val()+'&nombreCli='+limpiarCaracteresEsp($('#nombreClienteAR').val())+'&cuentaAho='+$('#cuentaAhoIDAR').val()+
									'&tipoCuen='+$('#nomCuentaAR').val()+'&tipoTransaccion='+$('#tipoTransaccion').val()+
									'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+$('#monedaDesAR').val()+'&montoComision='+$('#comisionAR').val()+
									'&montoIva='+$('#ivaAR').val()+'&productoCred='+$('#desProdCreditoAR').val()+
									'&grupo='+$('#grupoDesAR').val()+'&ciclo='+$('#cicloIDAR').val(), '_blank');
							}else{
								imprimirTicketTransaccion(BotonTransaccion);
							}
						break;

						case catTipoTransaccionVen.desembolsoCredito:
							var fechaHora = $('#fechaSistemaP').val()+" " +hora();
							var varCreditoID = $('#creditoIDDC').val();
							var ante = $('#totalDesembolsoDC').asNumber();
							var porDesem = $('#montoPorDesemDC').asNumber()-$('#totalRetirarDC').asNumber();
							if(TipoImpresion !=ticket){
							window.open('RepTicketVentanillaDesCred.htm?fechaSistemaP='+fechaHora+
									'&monto='+$('#totalRetirarDC').val()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
									'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
									'&numCopias='+$('#numCopias').val()+'&sumTotalEnt='+$('#sumTotalEnt').val()+
									'&diferencia='+$('#sumTotalSal').val()+'&varFormaPago='+"Efectivo"+
									'&numCli='+$('#clienteIDDC').val()+'&nombreCli='+limpiarCaracteresEsp($('#nombreClienteDC').val())+'&cuentaAho='+$('#cuentaAhoIDDC').val()+
									'&referen='+$('#creditoIDDC').val()+'&tipoCuen='+$('#nomCuentaDC').val()+'&tipoTransaccion='+$('#tipoTransaccion').val()+
									'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+$('#monedaDesDC').val()+'&montoComision='+$('#comisionDC').val()+
									'&montoIva='+$('#ivaDC').val()+'&productoCred='+$('#desProdCreditoDC').val()+
									'&varCreditoID='+varCreditoID+'&montoCred='+$('#montoCreDC').val()+'&monPorDes='+porDesem+
									'&montoDes='+$('#totalDesembolsoDC').val()+'&montoResAnt='+ante+
									'&grupo='+$('#grupoDesDC').val()+'&ciclo='+$('#cicloIDDC').val(), '_blank');
							}else{
								imprimirTicketTransaccion(BotonTransaccion);
							}


						break;

						case catTipoTransaccionVen.cobroSeguroVida:
							if(TipoImpresion !=ticket){

							window.open('TicketVentanillaSegVida.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
									'&rfcInstitucion='+rfcInstitucion+
									'&nomCajero='+$('#nomCajero').val()+
									'&transaccion='+$('#numeroTransaccion').val()+
									'&clienteIDSC='+$('#clienteIDSC').val()+
									'&nombreClienteSC='+limpiarCaracteresEsp($('#nombreClienteSC').val())+
									'&montoSeguroCobro='+$('#montoSeguroCobro').asNumber()+
									'&numeroSucursal='+sucursalID+
									'&tipoTransaccion=8'+
									'&direccionInstitucion='+direccionInstitucion+
									'&nombreSucursal='+$('#nombreSucursal').val()+
									'&telefonosucursal='+telefono+'&fechaSistema='+$('#fechaSistema').val()+
									'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+'&simbMonedaBase='+simboloMonedaBase+
									'&descripcionMoneda='+descrpcion, '_blank');
							}else{
								imprimirTicketTransaccion(BotonTransaccion);
							}
						break;

						case catTipoTransaccionVen.aplicaSeguroVida:
							window.open('ReporteVentanillaSegVida.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
									'&poliza='+$('#numeroPolizaS').val()+'&clienteIDSC='+$('#clienteIDS').val()+'&nombreClienteSC='+limpiarCaracteresEsp($('#nombreClienteS').val())+
									'&creditoIDS='+$('#creditoIDS').val()+'&fechaInicioSeguro='+$('#fechaInicioSeguro').val()+
									'&fechaVencimiento='+$('#fechaVencimiento').val()+'&beneficiarioSeguro='+$('#beneficiarioSeguro').val()+
									'&direccionBeneficiario='+$('#direccionBeneficiario').val()+'&desRelacionBeneficiario='+$('#desRelacionBeneficiario').val()+
									'&montoPoliza='+$('#montoPoliza').asNumber()+'&nombreSucursal='+$('#nombreSucursal').val()+'&nomCajero='+$('#nomCajero').val()+
									'&fechaSistema='+$('#fechaSistema').val()+ '&tipoTransaccion=9'+'&numeroSucursal='+sucursalID+'&desMonedaBase='+monedaBase+
									'&numMonedaBase='+numeromonedaBase+'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+descrpcion, '_blank');
						break;
						case catTipoTransaccionVen.devolucionGL:
								imprimirTicketTransaccion(BotonTransaccion);
						break;
						case catTipoTransaccionVen.cambioEfectivo:
							imprimirTicketTransaccion(BotonTransaccion);
						break;
						case catTipoTransaccionVen.transferenciaCuenta:
							imprimirTicketTransaccion(BotonTransaccion);
						break;
						case catTipoTransaccionVen.aportacionSocial:
							var fechaHora = $('#fechaSistemaP').val()+" " +hora();
							var montoPendiente;
							 if($('#montoPendientePagoAS').asNumber() < $('#montoAS').asNumber()){
								 montoPendiente=0;
							 }else{
								 montoPendiente=$('#montoPendientePagoAS').asNumber() - $('#montoAS').asNumber();
							 }

							var montoPagado=$('#montoPagadoAS').asNumber()+$('#montoAS').asNumber();

							montoPagado=cantidadFormatoMoneda(montoPagado);
							montoPendiente=cantidadFormatoMoneda(montoPendiente);
							if(TipoImpresion !=ticket){
								window.open('RepTicketAportacionSocio.htm?fechaSistemaP='+fechaHora+
									'&monto='+$('#montoAS').val()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
									'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
									'&numCopias='+$('#numCopias').val()+'&sumTotalEnt='+$('#sumTotalEnt').val()+'&diferencia='+$('#sumTotalSal').val()+
									'&varFormaPago='+"Efectivo"+'&numCli='+$('#clienteIDAS').val()+'&nombreCli='+limpiarCaracteresEsp($('#nombreClienteAS').val())+
									'&tipoTransaccion='+catTipoTicketVen.aportacionSocial+'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+monedaBase+
									'&rfc='+$('#RFCAS').val()+'&montoPendiente='+montoPendiente+'&montoPagado='+montoPagado+'&desMonedaBase='+monedaBase+
									'&numMonedaBase='+numeromonedaBase+'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+descrpcion,'_blank');
							}else{
								imprimirTicketTransaccion(BotonTransaccion);
							}
							break;

						case catTipoTransaccionVen.devAportacionSocio:
							var fechaHora = $('#fechaSistemaP').val()+" " +hora();
							if(TipoImpresion !=ticket){
								window.open('RepTicketDevAportaSocio.htm?fechaSistemaP='+fechaHora+
									'&monto='+$('#montoDAS').val()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
									'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
									'&numCopias='+$('#numCopias').val()+'&sumTotalEnt='+$('#sumTotalEnt').val()+'&diferencia='+$('#sumTotalSal').val()+
									'&varFormaPago='+"Efectivo"+'&numCli='+$('#clienteIDDAS').val()+'&nombreCli='+limpiarCaracteresEsp($('#nombreClienteDAS').val())+
									'&tipoTransaccion='+catTipoTicketVen.devAportacionSocial+'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+monedaBase+
									'&rfc='+$('#RFCDAS').val()+'&desMonedaBase='+monedaBase+'&tipoPersona='+$('#tipoPersonaDAS').val()+
									'&numMonedaBase='+numeromonedaBase+'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+descrpcion,'_blank');
							}else{
								imprimirTicketTransaccion(BotonTransaccion);
							}
							break;
						case catTipoTransaccionVen.cobroSegVidaAyuda:
							 window.open('repCertSegVida.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
										'&RFCInstit='+rfcInst+'&nombreUsuario='+$('#nomCajero').val()+
										'&clienteID='+$('#clienteIDCSVA').val()+'&nombreCliente='+limpiarCaracteresEsp($('#nombreClienteCSVA').val())+
										'&sucursal='+sucursalID+'&tipoTransaccion='+catTipoTicketVen.cobroSegAyuda+
										'&direccionInstit='+direccionInstitucion+'&nombreSucursal='+$('#nombreSucursal').val()+
										'&telefonoInst='+telefono+'&fechaActual='+fechaSucursal+'&tipoReporte=1','_blank');

							if(TipoImpresion !=ticket){
								window.open('RepTicketCobroSegAyudaSocio.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
										'&rfcInstitucion='+rfcInstitucion+'&nomCajero='+$('#nomCajero').val()+'&transaccion='+
										$('#numeroTransaccion').val()+'&clienteID='+$('#clienteIDCSVA').val()+'&nombreCliente='+limpiarCaracteresEsp($('#nombreClienteCSVA').val())+
										'&montoSeguroCobro='+$('#montoCobrarSeg').asNumber()+'&numeroSucursal='+sucursalID+'&tipoTransaccion='+catTipoTicketVen.cobroSegAyuda+
										'&direccionInstitucion='+direccionInstitucion+'&nombreSucursal='+$('#nombreSucursal').val()+'&telefonosucursal='+
										telefono+'&fechaSistema='+$('#fechaSistema').val()+'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+
										'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+descrpcion,'_blank');
							}else{

								imprimirTicketTransaccion(BotonTransaccion);
							}


							break;
						case catTipoTransaccionVen.aplicaSegVidaAyuda:
							if(TipoImpresion !=ticket){
								window.open('RepTicketPagoSeguroAyuda.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
										'&rfcInstitucion='+rfcInstitucion+'&nomCajero='+$('#nomCajero').val()+'&transaccion='+
										$('#numeroTransaccion').val()+'&clienteID='+$('#clienteIDASVA').val()+'&nombreCliente='+limpiarCaracteresEsp($('#nombreClienteASVA').val())+
										'&montoSeguroPago='+$('#montoPolizaSegAyudaCobroA').asNumber()+'&numeroSucursal='+sucursalID+'&tipoTransaccion='+catTipoTicketVen.pagoSegAyuda+
										'&direccionInstitucion='+direccionInstitucion+'&nombreSucursal='+$('#nombreSucursal').val()+'&telefonosucursal='+
										telefono+'&fechaSistema='+$('#fechaSistema').val()+'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+
										'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+descrpcion,'_blank');
							}else{
								imprimirTicketTransaccion(BotonTransaccion);
							}
							break;


						case catTipoTransaccionVen.pagoRemesas:
							var clienteIDRemesa = '';
							var nombreClienteRemesa = '';
							if ($('#clienteIDServicio').val() != '' || $('#clienteIDServicio').val() != 0) {
								clienteIDRemesa = $('#clienteIDServicio').val();
								nombreClienteRemesa = $('#nombreClienteServicio').val();
							} else{
								clienteIDRemesa = '';
								nombreClienteRemesa = $('#nombreUsuarioRem').val();
							};

							if(TipoImpresion !=ticket){
								window.open('RepTicketPagoRemesas.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
										'&rfcInstitucion='+rfcInstitucion+'&nomCajero='+$('#nomCajero').val()+'&transaccion='+
										$('#numeroTransaccion').val()+'&clienteIDServicio='+clienteIDRemesa+'&nombreClienteServicio='+limpiarCaracteresEsp(nombreClienteRemesa)+
										'&montoServicio='+$('#montoServicio').asNumber()+'&numeroSucursal='+sucursalID+'&tipoTransaccion='+catTipoTicketVen.pagoRemesa+
										'&direccionInstitucion='+direccionInstitucion+'&nombreSucursal='+$('#nombreSucursal').val()+'&telefonosucursal='+
										telefono+'&fechaSistema='+$('#fechaSistema').val()+'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+
										'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+
										descrpcion+'&referenciaServicio='+limpiarCaracteresEsp($('#referenciaServicio').val())+'&sumTotalSal='+$('#sumTotalSal').val(),'_blank');
							}else{
								imprimirTicketTransaccion(BotonTransaccion);
							}
							break;
						case catTipoTransaccionVen.pagoOportunidades:
							var clienteIDRemesa = '';
							var nombreClienteRemesa = '';
							if ($('#clienteIDServicio').val() != '' || $('#clienteIDServicio').val() != 0) {
								clienteIDRemesa = $('#clienteIDServicio').val();
								nombreClienteRemesa = $('#nombreClienteServicio').val();
							} else{
								clienteIDRemesa = '';
								nombreClienteRemesa = $('#nombreUsuarioRem').val();
							};

							if(TipoImpresion !=ticket){
								window.open('RepTicketPagoOportunidades.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
										'&rfcInstitucion='+rfcInstitucion+'&nomCajero='+$('#nomCajero').val()+'&transaccion='+
										$('#numeroTransaccion').val()+'&clienteIDServicio='+clienteIDRemesa+'&nombreClienteServicio='+limpiarCaracteresEsp(nombreClienteRemesa)+
										'&montoServicio='+$('#montoServicio').asNumber()+'&numeroSucursal='+sucursalID+'&tipoTransaccion='+catTipoTicketVen.pagoOportunidades+
										'&direccionInstitucion='+direccionInstitucion+'&nombreSucursal='+$('#nombreSucursal').val()+'&telefonosucursal='+
										telefono+'&fechaSistema='+$('#fechaSistema').val()+'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+
										'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+
										descrpcion+'&referenciaServicio='+limpiarCaracteresEsp($('#referenciaServicio').val())+'&sumTotalSal='+$('#sumTotalSal').val(),'_blank');
							}else{
								imprimirTicketTransaccion(BotonTransaccion);
							}
							break;
						case catTipoTransaccionVen.recepcionChequeSBC:
							if(TipoImpresion !=ticket){
								window.open('RepTicketRecepChequeSBC.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
										'&rfcInstitucion='+rfcInstitucion+'&nomCajero='+$('#nomCajero').val()+'&transaccion='+
										$('#numeroTransaccion').val()+'&clienteID='+$('#clienteIDSBC').val()+'&nombreCliente='+limpiarCaracteresEsp($('#nombreClienteSBC').val())+
										'&monto='+$('#montoSBC').asNumber()+'&numeroSucursal='+sucursalID+'&tipoTransaccion='+catTipoTicketVen.recepChequeSBC+
										'&direccionInstitucion='+direccionInstitucion+'&nombreSucursal='+$('#nombreSucursal').val()+'&telefonosucursal='+
										telefono+'&fechaSistema='+$('#fechaSistema').val()+'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+
										'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+
										descrpcion+'&cuentaDestino='+$('#numeroCuentaRec').val()+'&cuentaEmisor='+$('#numeroCuentaEmisorSBC').val()
										+'&numCheque='+$('#numeroChequeSBC').val()+'&nombreEmisor='+$('#nombreEmisorSBC').val()
										+'&numBanco='+$('#bancoEmisorSBC').val()
										+'&nombreBanco='+$('#nombreBancoEmisorSBC').val()+'&tipoCheque='+$('#tipoCtaCheque').val(),'_blank');
							}else{
								imprimirTicketTransaccion(BotonTransaccion);
							}
							break;
						case catTipoTransaccionVen.aplicaChequeSBC:
							if(TipoImpresion !=ticket){
								window.open('RepTicketAplicaChequeSBC.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
										'&rfcInstitucion='+rfcInstitucion+'&nomCajero='+$('#nomCajero').val()+'&transaccion='+
										$('#numeroTransaccion').val()+'&clienteID='+$('#clienteIDSBCAplic').val()+'&nombreCliente='+limpiarCaracteresEsp($('#nombreClienteSBCAplic').val())+
										'&monto='+$('#montoSBCAplic').asNumber()+'&numeroSucursal='+sucursalID+'&tipoTransaccion='+catTipoTicketVen.aplicaChequeSBC+
										'&direccionInstitucion='+direccionInstitucion+'&nombreSucursal='+$('#nombreSucursal').val()+'&telefonosucursal='+
										telefono+'&fechaSistema='+$('#fechaSistema').val()+'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+
										'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+
										descrpcion+'&cuentaDestino='+$('#numeroCuentaSBC').val()+'&cuentaEmisor='+$('#numeroCuentaEmisorSBCAplic').val()
										+'&numCheque='+$('#numeroChequeSBCAplic').val()+'&nombreEmisor='+$('#nombreEmisorSBCAplic').val()
										+'&numBanco='+$('#bancoEmisorSBCAplic').val()
										+'&nombreBanco='+$('#nombreBancoEmisorSBCAplic').val(),'_blank');
							}else{
								imprimirTicketTransaccion(BotonTransaccion);
							}
							break;
						case catTipoTransaccionVen.prepagoCredito:
							var creditoPrepago= $('#creditoIDPre').val();
							var PrepagoIndividual='I';

							if(TipoImpresion !=ticket){
								var tituloOperacion='PREPAGO DE CREDITO EN EFECTIVO';
								var productoCredito=$('#producCreditoIDPre').val()+"   "+$('#descripcionProdPre').val();
									window.open('RepTicketPagoCredito.htm?fechaSistemaP='+$('#fechaSistemaP').val()+
											'&monto='+$('#montoPagarPre').val()+'&nombreInstitucion='+parametroBean.nombreInstitucion+'&numeroSucursal='+
											parametroBean.sucursal+'&nombreSucursal='+ parametroBean.nombreSucursal+'&varCreditoID='+creditoPrepago+
											'&numCopias='+1+'&varFormaPago='+"Efectivo"+'&numTrans='+$('#numeroTransaccion').val()+
											'&moneda='+$('#monedaDesPre').val()+'&productoCred='+productoCredito+'&grupo='+$('#grupoDesPre').val()+'&ciclo='+
											$('#cicloIDPre').val()+'&tituloOperacion='+tituloOperacion+'&edoMunSucursal='+parametroBean.edoMunSucursal, '_blank');
							}else{
								imprimeTicketPrepagoCredito(creditoPrepago,1,PrepagoIndividual);
							}
							break;
						case catTipoTransaccionVen.prepagoCreditoGrupal:
							if(TipoImpresion !=ticket){
								var tituloOperacion='PREPAGO DE CREDITO EN EFECTIVO';
								var productoCredito=$('#producCreditoIDPre').val()+"   "+$('#descripcionProdPre').val();
									window.open('RepTicketPagoCredito.htm?fechaSistemaP='+$('#fechaSistema').val()+
											'&monto='+$('#montoPagarPre').val()+'&nombreInstitucion='+parametroBean.nombreInstitucion+'&numeroSucursal='+
											parametroBean.sucursal+'&nombreSucursal='+ parametroBean.nombreSucursal+'&varCreditoID='+$('#creditoIDPre').val()+
											'&numCopias='+1+'&varFormaPago='+"Efectivo"+'&numTrans='+$('#numeroTransaccion').val()+
											'&moneda='+$('#monedaDesPre').val()+'&productoCred='+productoCredito+'&grupo='+$('#grupoDesPre').val()+'&ciclo='+
											$('#cicloIDPre').val()+'&tituloOperacion='+tituloOperacion+'&edoMunSucursal='+parametroBean.edoMunSucursal, '_blank');
							}else{
								imprimirTicketPrepagoGrupal(BotonTransaccion);
							}
							break;
							case catTipoTransaccionVen.pagoServicios:
									imprimirTicketTransaccion(BotonTransaccion);
							break;
							case catTipoTransaccionVen.recuperaCartera:
								if(TipoImpresion !=ticket){
									$('#montoPorRecuperarTotal').val($('#montoPorRecuperar').asNumber()-$('#montoRecuperar').asNumber());
									$('#montoRecuperadoTotal').val($('#monRecuperado').asNumber()+$('#montoRecuperar').asNumber());

									$('#montoPorRecuperarTotal').formatCurrency({
										positiveFormat: '%n',
										roundToDecimalPlace: 2
									});
									$('#montoRecuperadoTotal').formatCurrency({
										positiveFormat: '%n',
										roundToDecimalPlace: 2
									});


									window.open('RepTicketCredCastigado.htm?fechaSistemaP='+$('#fechaSistemaP').val()+
											'&montoPago='+$('#montoRecuperar').val()+
											'&nombreInstitucion='+$('#nombreInstitucion').val()+
											'&numeroSucursal='+$('#numeroSucursal').val()+
											'&nombreSucursal='+$('#nombreSucursal').val()+
											'&numeroCaja='+$('#numeroCaja').val()+
											'&nomCajero='+$('#nomCajero').val()+
											'&creditoID='+$('#creditoVencido').val()+
											'&numCopias='+$('#numCopias').val()+
											'&sumTotalEnt='+$('#sumTotalEnt').val()+
											'&diferencia='+$('#sumTotalSal').val()+
											'&formaPAgo='+"Efectivo"+'&tipoTransaccion='+catTipoTicketVen.cartCastigada+
											'&numTrans='+$('#numeroTransaccion').val()+
											'&moneda='+$('#desMonedaCartVencida').val()+'&productoCred='+$('#desProducVencido').val()+
											'&grupo='+$('#grupoDesCast').val()+'&ciclo='+$('#cicloIDCast').val()+'&fechaCastigo='+$('#fechaCastigo').val()
											+'&montoCastigado='+$('#totalCastigado').val()+'&clienteID='+$('#clienteIDVencido').val()+
											'&nombreCliente='+limpiarCaracteresEsp($('#nombreClienteVencido').val())+'&montoRecuperar='+$('#montoPorRecuperarTotal').val()+
											'&montoRecuperado='+$('#montoRecuperadoTotal').val()+'&moneda='+$('#monedaDesPre').val()
											,'_blank');
								}else{
									imprimirTicketTransaccion(BotonTransaccion);
								}


							break;
							case catTipoTransaccionVen.pagoServifun:
								if(TipoImpresion !=ticket){
									var jqNombreBenef= eval("'#nombreCteServifun'");
									var jqNombreRecibePago= eval("'#nombreCteServifun'");
									var jqMontoPago= eval("'#montoEntregarServifun'");
									var jqClienteBenefi = eval("'#clienteServifunID'");
									window.open('TicketPagoServifun.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
										'&rfcInstitucion='+rfcInst+'&nomCajero='+$('#nomCajero').val()+'&transaccion='+
										$('#numeroTransaccion').val()+'&nombreBeneficiario='+limpiarCaracteresEsp($(jqNombreBenef).val())+
										'&nombreRecibePago='+limpiarCaracteresEsp($(jqNombreRecibePago).val())+'&numeroSucursal='+sucursalID+'&tipoTransaccion='+catTipoTicketVen.pagoServifun+
										'&direccionInstitucion='+direccionInstitucion+'&nombreSucursal='+$('#nombreSucursal').val()+
										'&telefonosucursal='+telefono+'&fechaSistema='+	$('#fechaSistema').val()+'&desMonedaBase='+monedaBase+
										'&numMonedaBase='+numeromonedaBase+'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+descrpcion+
										'&montoPago='+$(jqMontoPago).asNumber()+'&porcentaje=100%'+'&tipoIdentificacion='+$('#tipoIdentificacion').val()+
										'&folioIdentifi='+$('#folioIdentificacion').val()+'&folioSolicitud='+$('#serviFunFolioID').val()
										+'&clienteIDBenef='+$(jqClienteBenefi).val(),
										'_blank');
								}else{
									imprimeTicketPagoServifun();  /* pagoServifun.js  */
								}
							break;

							case catTipoTransaccionVen.cobroApoyoEscolar:
								if(TipoImpresion !=ticket){
									var nombreRecibePago ='';
									if($('#recibeApoyoEscolar').val() !=''){
										nombreRecibePago =$('#recibeApoyoEscolar').val();
									}else{
										nombreRecibePago =$('#nombreCteApoyoEsc').val();
									}
									window.open('TicketPagoApoyoEscolar.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
											'&rfcInstitucion='+rfcInst+'&nomCajero='+$('#nomCajero').val()+'&transaccion='+
											$('#numeroTransaccion').val()+'&nombreCliente='+limpiarCaracteresEsp($('#nombreCteApoyoEsc').val())+
											'&nombreRecibePago='+$('#recibeApoyoEscolar').val()+'&numeroSucursal='+sucursalID+'&tipoTransaccion='+
											catTipoTicketVen.pagoApoyoEscolar+'&direccionInstitucion='+direccionInstitucion+
											'&nombreSucursal='+$('#nombreSucursal').val()+'&telefonosucursal='+telefono+'&fechaSistema='+
											$('#fechaSistema').val()+'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+
											'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+descrpcion+
											'&montoPago='+$('#monto').asNumber()+'&numeroSolicitud='+$('#apoyoEscSolID').val()+
											'&clienteID='+$("#clienteIDApoyoEsc").val(),'_blank');
								}else{
									imprimeTicketApoyoEscolar();  /*pagoApoyoEscolar.js*/
								}
							break;
							case catTipoTransaccionVen.anualidadTarjeta:
								if(TipoImpresion !=ticket){
									window.open('AnualidadTD.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
											'&rfcInstitucion='+rfcInst+'&nomCajero='+$('#nomCajero').val()+'&transaccion='+
											$('#numeroTransaccion').val()+'&nombreCliente='+limpiarCaracteresEsp($('#nombreCteTarjeta').val())+
											'&numeroSucursal='+sucursalID+'&tipoTransaccion='+catTipoTicketVen.anualidaTD+
											'&direccionInstitucion='+direccionInstitucion+'&nombreSucursal='+$('#nombreSucursal').val()+
											'&telefonosucursal='+telefono+'&fechaSistema='+$('#fechaSistema').val()+
											'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+
											'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+descrpcion+
											'&montoTotal='+$('#totalComisionTD').asNumber()+'&clienteID='+$("#clienteIDTarjeta").val()+
											'&munTarjetaDebito='+$('#tarjetaDebID').val() + '&IVAComision='+$('#ivaComisionTarjeta').asNumber()+
											'&totalEntradas='+$('#sumTotalEnt').asNumber()+'&totalSalidas='+$('#sumTotalSal').asNumber()+
											'&cuentaAhorro='+$('#numCtaTarjetaDeb').val() +'&montoComisionTarjeta='+$('#montoComisionTarjeta').asNumber()
											,'_blank');
								}else{
									imprimeTicketAnualidadTarjeta();  /*cobroAnualTarjetaDeb.js*/
								}
							break;
							case catTipoTransaccionVen.pagoCancelSocio:
								if(TipoImpresion !=ticket){
									var jqNombreBenef= eval("'#nombreBeneficiario'");
									var jqNombreRecibePago= eval("'#nombreRecibePago'");
									var jqMontoPago= eval("'#totalRecibir'");

									window.open('ticketPagoCancelacionSocio.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
										'&rfcInstitucion='+rfcInst+'&nomCajero='+$('#nomCajero').val()+'&transaccion='+
										$('#numeroTransaccion').val()+'&nombreBeneficiario='+$(jqNombreBenef).val()+
										'&nombreRecibePago='+limpiarCaracteresEsp($(jqNombreRecibePago).val())+'&numeroSucursal='+sucursalID+'&tipoTransaccion='+catTipoTicketVen.pagoCancelSocio+
										'&direccionInstitucion='+direccionInstitucion+'&nombreSucursal='+$('#nombreSucursal').val()+
										'&telefonosucursal='+telefono+'&fechaSistema='+	$('#fechaSistema').val()+'&desMonedaBase='+monedaBase+
										'&numMonedaBase='+numeromonedaBase+'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+descrpcion+
										'&montoPago='+$(jqMontoPago).asNumber()+'&porcentaje=100%'+'&tipoIdentificacion='+$('#tipoIdentificacion').val()+
										'&folioIdentifi='+$('#folioIdentificacion').val()+'&folioSolicitud='+$('#serviFunFolioID').val(),
										'_blank');
								}else{
									imprimeTicketPagoCancelacionSocio();  /* /ventanilla/pagoClientesCancela.js */
								}
							break;

							// Imprime el Ticket de Gastos o Anticipos por Comprobar
							case catTipoTransaccionVen.anticiposGastos:
								if(TipoImpresion !=ticket){
									var fechaHora = $('#fechaSistemaP').val()+" " +hora();
									if($('#formaPagoOpera1').is(':checked')){
										  formPago = "EFECTIVO";
										  totalEnt=$('#sumTotalEnt').val();
										  totalSal=$('#sumTotalSal').val();
									}else{
										 formPago = "CHEQUE";
										  totalEnt="0.00";
										  totalSal="0.00";
									}

									window.open('RepTicketVentanillaGastos.htm?fechaSistemaP='+fechaHora+
									'&monto='+$('#montoGastoAnt').asNumber()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
									'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
									'&numCopias='+$('#numCopias').val()+'&diferencia='+$('#diferencia').val()+'&sumTotalEnt='+totalEnt+
									'&totalSalida='+totalSal+'&montos='+$('#montoGastoAnt').val()+
									'&varFormaPago='+formPago+'&empleadoID='+$('#empleadoID').val()+'&nombreEmpleadoGA='+limpiarCaracteresEsp($('#nombreEmpleadoGA').val())+
									'&tipoTransaccion='+catTipoTicketVen.anticiposGastos+'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+monedaBase+
									'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+descrpcion+
									'&nombreOperacion='+descoperacion,'_blank');
								}else{
									imprimeTicketGastoAnt();  /* /ventanilla/salidaGastosAnticipos.js */
								}
							break;
							// Imprime el Ticket de Devoluciones de Gastos o Anticipos
							case catTipoTransaccionVen.devolucionesGastAnt:
								if(TipoImpresion !=ticket){
									var fechaHora = $('#fechaSistemaP').val()+" " +hora();
									window.open('RepTicketVentanillaDevGastos.htm?fechaSistemaP='+fechaHora+
									'&monto='+$('#montoGastoDev').asNumber()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
									'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
									'&numCopias='+$('#numCopias').val()+'&diferencia='+$('#diferencia').val()+'&sumTotalEnt='+$('#sumTotalEnt').val()+
									'&sumTotalSal='+$('#sumTotalSal').val()+'&montos='+$('#montoGastoDev').val()+
									'&varFormaPago='+"Efectivo"+'&empleadoID='+$('#empleadoIDDev').val()+'&nombreEmpleadoGA='+limpiarCaracteresEsp($('#nombreEmpleadoDev').val())+
									'&tipoTransaccion='+catTipoTicketVen.devolucionesGastAnt+'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+monedaBase+
									'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+descrpcion+
									'&totalSalidas='+$('#totalSalidas').val()+'&nombreOperacion='+descoperacion,'_blank');
								}else{
									imprimeTicketDevGastoAnt();  /* /ventanilla/entradaGastosAnticipos.js */
								}
							break;

							case catTipoTransaccionVen.haberesExmenor:
								if(TipoImpresion !=ticket){
								var fechaHora = $('#fechaSistemaP').val()+" " +hora();
								if($('#formaPagoOpera1').is(':checked')){
									  formPago = "EFECTIVO";
									  totalEnt=$('#sumTotalEnt').val();
									  totalSal=$('#sumTotalSal').val();
								}else{
									 formPago = "CHEQUE";
									  totalEnt="0.00";
									  totalSal="0.00";
								}
								window.open('RepTicketVentanillaHaberesExMenor.htm?fechaSistemaP='+fechaHora+
								'&monto='+$('#totalHaberes').asNumber()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
								'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
								'&numCopias='+$('#numCopias').val()+'&diferencia='+$('#diferencia').val()+'&sumTotalEnt='+totalEnt+
								'&sumTotalSal='+totalSal+'&montos='+$('#totalHaberes').val()+
								'&varFormaPago='+formPago+'&clienteID='+$('#clienteIDMenor').val()+'&nombreCliente='+limpiarCaracteresEsp($('#nombreClienteMenor').val())+
								'&tipoTransaccion='+catTipoTicketVen.haberesExmenor+'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+monedaBase+
								'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+descrpcion+
								'&totalSalidas='+$('#totalSalidas').val(),'_blank');
								}else{
									imprimeTicketHaberesExMenor();  /* /ventanilla/reclamoHaberesExMenor.js */
								}
							break;
							case catTipoTransaccionVen.pagoArrendamiento: //impresion ticket Pago de arrendamiento
								if(TipoImpresion !=ticket){
									window.open('RepTicketVentanillaPagArrendamiento.htm?fechaSistemaP='+$('#fechaSistemaP').val()+
											'&nombreInstitucion='+$('#nombreInstitucion').val()+
											'&numeroSucursal='+$('#numeroSucursal').val()+
											'&nombreSucursal='+$('#nombreSucursal').val()+
											'&varCaja='+$('#numeroCaja').val()+
											'&nomCajero='+$('#nomCajero').val()+
											'&varArrendamientoID='+$('#arrendamientoID').val()+
											'&numCopias='+$('#numCopias').val()+
											'&sumTotalEnt='+$('#sumTotalEnt').val()+
											'&diferencia='+$('#sumTotalSal').val()+
											'&varFormaPago='+"Efectivo"+
											'&tipoTransaccion='+$('#tipoTransaccion').val()+
											'&numTrans='+$('#numeroTransaccion').val()+
											'&moneda='+$('#monedaArrendamiento').val(),
											'_blank');
								}else{
									var arrendamiento=$('#arrendamientoID').val();
									var fechaPago=$('#fechaSistemaP').val();
									var transaccion=$('#numeroTransaccion').val();
									imprimeTicketPagoArrendamiento(arrendamiento,fechaPago, transaccion);  /* pagoArrendamiento.js  */
								}
							break;
							case catTipoTransaccionVen.pagoServiciosEnLinea:
								if(TipoImpresion != ticket) {
									var formaPago = '';
									if ($('#formaPagoE').is(':checked')) {
										formaPago = 'EFECTIVO';
									} else {
										formaPago = 'CARGO CTA';
									}
									window.open('RepTicketVentanillaPSL.htm?'+
											'fechaSistemaP='+$('#fechaSistemaP').val()+
											'&nombreInstitucion='+$('#nombreInstitucion').val()+
											'&direccionInstitucion='+direccionInstitucion+
											'&rfcInstitucion='+rfcInst+
											'&telefonoLocal='+telefono+
											'&numeroSucursal='+$('#numeroSucursal').val()+
											'&nombreSucursal='+$('#nombreSucursal').val()+
											'&producto='+$('#productoID option:selected').text()+
											'&formaPago='+formaPago+
											'&precio='+$('#precio').val()+
											'&comisiProveedor='+$('#comisiProveedor').val()+
											'&comisiInstitucion='+$('#comisiInstitucion').val()+
											'&ivaComisiInstitucion='+$('#ivaComisiInstitucion').val()+
											'&totalPagarPSL='+$('#totalPagarPSL').val()+
											'&referenciaPSL='+$('#referenciaPSL').val()+
											'&telefonoPSL='+$('#telefonoPSL').val()+
											'&sumTotalEnt='+$('#sumTotalEnt').val()+
											'&diferencia='+$('#sumTotalSal').val()+
											'&clienteIDPSL='+$('#clienteIDPSL').val()+
											'&nombreClientePSL='+$('#nombreClientePSL').val()+
											'&varCaja='+$('#numeroCaja').val()+
											'&nomCajero='+$('#nomCajero').val()+
											'&tipoTransaccion='+$('#tipoTransaccion').val()+
											'&numTrans='+$('#numeroTransaccion').val()+
											'&moneda='+'MXN',
											'_blank');
									break;
								}
								imprimirTicketTransaccion(BotonTransaccion);
								break;
							case catTipoTransaccionVen.cobroAccesoriosCre: // Seccion para impresion de ticket Accesorios Credito
								imprimirTicketTransaccion(BotonTransaccion);
								break;

							case catTipoTransaccionVen.depositoActivaCta:
								if(TipoImpresion == ticket){
									imprimirTicketTransaccion(BotonTransaccion);
								}
							break;
					}
			}

			$('#impCheque').click(function(){
				var monto=0, monedaID=0,nombreOperacion='';
				var nombreUsuario = parametroBean.claveUsuario;
				var numcheque=parseInt($('#numeroCheque').val());

				if($('#tipoOperacion').val()==cargoCuenta){
					monedaID=$('#monedaIDCa').val();
					controlQuitaFormatoMoneda('montoCargar');
					monto=$('#montoCargar').val();
					nombreOperacion='Retiro de Efectivo';
					numeroTransaccion=parseInt($('#numeroTransaccion').val());
				}else if($('#tipoOperacion').val()==desemboCred){
					monedaID=$('#monedaIDDC').val();
					controlQuitaFormatoMoneda('totalRetirarDC');
					monto=$('#totalRetirarDC').val();
					nombreOperacion='Desembolso de Credito';
				}else if($('#tipoOperacion').val()==devolucionGarLiq){
					monedaID=$('#monedaIDDG').val();
					controlQuitaFormatoMoneda('montoDevGL');
					monto=$('#montoDevGL').val();
					nombreOperacion='Devolucion de Garantia Liquida';
				}else if($('#tipoOperacion').val()==devAportacionSocial){
					monedaID=numeromonedaBase;
					controlQuitaFormatoMoneda('montoDAS');
					monto=$('#montoDAS').val();
					nombreOperacion='Devolucion de Aportacion Social';
				}else if($('#tipoOperacion').val()==pagoSeguroAyuda){
					monedaID=numeromonedaBase;
					controlQuitaFormatoMoneda('montoPolizaSegAyudaCobroA');
					monto=$('#montoPolizaSegAyudaCobroA').val();
					nombreOperacion='Pago de Seguro Ayuda';
				}else if($('#tipoOperacion').val()==pagoRemesas){
					monedaID=numeromonedaBase;
					controlQuitaFormatoMoneda('montoServicio');
					monto=$('#montoServicio').val();
					nombreOperacion='Remesas';
				}else if($('#tipoOperacion').val()==pagoOportunidades){
					monedaID=numeromonedaBase;
					controlQuitaFormatoMoneda('montoServicio');
					monto=$('#montoServicio').val();
					nombreOperacion='Pago de Oportunidades';
				}else if($('#tipoOperacion').val()==pargoServifun){
					monedaID=numeromonedaBase;
					controlQuitaFormatoMoneda('montoEntregarServifun');
					monto=$('#montoEntregarServifun').val();
					nombreOperacion='Pago de Servicios Funerarios';
				}else if($('#tipoOperacion').val()==cobroApoyoEscolar){
					monedaID=numeromonedaBase;
					controlQuitaFormatoMoneda('monto');
					monto=$('#monto').val();
					nombreOperacion='Cobro Apoyo Escolar';
					habilitaBoton();
				}else if($('#tipoOperacion').val()==gastosAnticiposV){
					monedaID=numeromonedaBase;
					controlQuitaFormatoMoneda('montoGastoAnt');
					monto=$('#montoGastoAnt').val();
					nombreOperacion='Gastos/Anticipos por Comprobar';
					habilitaBoton();
				}else if($('#tipoOperacion').val()==pagoCancelSocio){
					monedaID=numeromonedaBase;
					controlQuitaFormatoMoneda('totalRecibir');
					monto=$('#totalRecibir').val();
					nombreOperacion='Pago Cancelación Socio';
					habilitaBoton();
				}else if($('#tipoOperacion').val()==aplicaSeguroVida){
					monedaID=numeromonedaBase;
					controlQuitaFormatoMoneda('montoPoliza');
					monto=$('#montoPoliza').val();
					nombreOperacion='Pago Póliza Cobertura de Riesgo';
					habilitaBoton();
				}else if($('#tipoOperacion').val()==haberesExmenor){
					monedaID=numeromonedaBase;
					controlQuitaFormatoMoneda('totalHaberes');
					monto=$('#totalHaberes').val();
					nombreOperacion='Reclamo Haberes Socio Menor';
					habilitaBoton();
				}
				actualizaFormatosMoneda('formaGenerica');

				var nombreBeneficiario = $('#beneCheque').val();
				var rutaChequeInst	   = $('#rutaChequeInstit').val();

				imprimirCheque(Var_Poliza,rutaChequeInst,numeroTransaccion,sucursalID,monedaID,$('#fechaSistemaP').val(),nombreOperacion,nombreBeneficiario,monto, nombreUsuario,numcheque);

			});

			// metodo para la impresion del cheque
			function imprimirCheque(polizaID,	nombreBanco,	numTran,	sucursalID,	monedaID,
									fechaEmision, 	nombreOperacion,	nombreBeneficiario, 	monto, nombreUsuario, numcheque){
				/*var printWin=*/window.open('imprimeCheque.htm?polizaID='+polizaID+'&nombreReporte='+nombreBanco+
							'&sucursalID='+sucursalID+'&monedaID='+monedaID+'&fechaEmision='+fechaEmision+'&nombreOperacion='+
							limpiarCaracteresEsp(nombreOperacion)+'&nombreBeneficiario='+nombreBeneficiario+'&monto='+monto+'&nombreUsuario='+nombreUsuario
							+'&numeroTransaccion='+numTran+'&NumeroCheque='+numcheque,'_blank');

			};

			//Clic a boton para imprimir ticket
			$('#impTicket').click(function() {
				var ticket='T';
				var BotonTransaccion="I";
				consultaDisponibleDenominacion();
				if($('#numeroMensaje').val() == 0 && $('#numeroTransaccion').asNumber()>0){
					switch($('#tipoTransaccion').val()){
							case catTipoTransaccionVen.pagoCredito:
								if(TipoImpresion !=ticket){
								if($('#montoPagar').asNumber()>$('#garantiaAdicionalPC').asNumber()){
										$('#enlaceTicket').attr('href','RepTicketVentanillaPagCred.htm?fechaSistemaP='+$('#fechaSistemaP').val()+
												'&monto='+$('#montoPagar').val()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
												'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
												'&varCreditoID='+$('#creditoID').val()+'&numCopias='+$('#numCopias').val()+'&sumTotalEnt='+$('#sumTotalEnt').val()+
												'&diferencia='+$('#sumTotalSal').val()+'&varFormaPago='+"Efectivo"+'&tipoTransaccion='+$('#tipoTransaccion').val()+
												'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+$('#monedaDes').val()+'&productoCred='+''+
												'&grupo='+$('#grupoDes').val()+'&ciclo='+$('#cicloID').val());
									}

									if($('#garantiaAdicionalPC').asNumber()>0){
										var fechaHora = $('#fechaSistemaP').val()+" " +hora();
										var varCreditoID = $('#creditoID').val();
										window.open('RepTicketVentanillaGLAdicional.htm?fechaSistemaP='+fechaHora+
												'&monto='+$('#garantiaAdicionalPC').val()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
												'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
												'&varCreditoID='+varCreditoID+'&numCopias='+$('#numCopias').val()+'&sumTotalEnt='+$('#sumTotalEnt').val()+
												'&diferencia='+$('#sumTotalSal').val()+'&varFormaPago='+"Efectivo"+
												'&numCli='+$('#clienteID').val()+'&nombreCli='+limpiarCaracteresEsp($('#nombreCliente').val())+'&cuentaAho='+$('#ctaGLAdiID').val()+
												'&tipoCuen='+""+'&tipoTransaccion='+catTipoTicketVen.garantiaLiquidaAdicional+
												'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+$('#monedaDes').val()+'&productoCred='+''+
												'&tipoCuen='+""+'&grupo='+$('#grupoDes').val()+
												'&ciclo='+$('#cicloID').val(), '_blank');
									}
							}else{
								var credito=$('#creditoID').val();
								var fechaPago=$('#fechaSistemaP').val();
								var transaccion=$('#numeroTransaccion').val();
								var contador=1;

								var ctaGLAdiIDInt = $('#ctaGLAdiID').val();
								var  montoGL =  $('#garantiaAdicionalPC').val();
								var clienteID		=$('#clienteID').val();
								var NombreCompelto	=$('#nombreCliente').val();

								if($('#garantiaAdicionalPC').asNumber()>0){
									imprimeTicketPagoCredito(credito, fechaPago, transaccion,contador,'S',ctaGLAdiIDInt,montoGL,clienteID,NombreCompelto);
								}else{
									imprimeTicketPagoCredito(credito, fechaPago, transaccion,contador,'N',ctaGLAdiIDInt,montoGL,clienteID,NombreCompelto);
								}
								imprimeTicket();
							}
						break;
						case catTipoTransaccionVen.pagoCreditoGrupal:
							if( $('#grupoID').val() >0){
								imprimirTicketGrupal();
								if($('#prorrateoPago').val()=="S"){ // si permite prorrateo de pago entonces se ejecuta el procedimiento grupal
									$('#tipoTransaccion').val(catTipoTransaccionVen.pagoCreditoGrupal);
								}else{
									$('#tipoTransaccion').val(catTipoTransaccionVen.pagoCredito);
								}
							}
						break;
						case catTipoTransaccionVen.garantiaLiq:
							var fechaHora = $('#fechaSistemaP').val()+" " +hora();
							if(TipoImpresion !=ticket){
								var varCreditoID = $('#referenciaGL').val();
								$('#enlaceTicket').attr('href','RepTicketVentanillaGarantiaLiq.htm?fechaSistemaP='+fechaHora+
										'&monto='+$('#montoGarantiaLiq').val()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
										'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
										'&varCreditoID='+varCreditoID+'&numCopias='+$('#numCopias').val()+'&sumTotalEnt='+$('#sumTotalEnt').val()+
										'&diferencia='+$('#sumTotalSal').val()+'&varFormaPago='+"Efectivo"+
										'&numCli='+$('#numClienteGL').val()+'&nombreCli='+limpiarCaracteresEsp($('#nombreClienteGL').val())+'&cuentaAho='+$('#cuentaAhoIDGL').val()+
										'&tipoCuen='+$('#tipoCuentaGL').val()+'&tipoTransaccion='+$('#tipoTransaccion').val()+
										'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+$('#monedaGL').val()+'&productoCred='+''+
										'&tipoCuen='+$('#tipoCuentaGL').val()+'&grupo='+$('#grupoDesGL').val()+
										'&ciclo='+$('#cicloIDGL').val());
							}else{
								imprimirTicketTransaccion(BotonTransaccion);
							}
						break;
				case catTipoTransaccionVen.cargoCuenta:
					reimprimeTickets(1, $('#numeroTransaccion').val(), $('#numCopias').val());
						break;
				case catTipoTransaccionVen.abonoCuenta:
					reimprimeTickets(2, $('#numeroTransaccion').val(), $('#numCopias').val());

						break;
						case catTipoTransaccionVen.comisionApertura:
							var fechaHora = $('#fechaSistemaP').val()+" " +hora();
							var varCreditoID = $('#creditoIDAR').val();
							if(TipoImpresion !=ticket){
								$('#enlaceTicket').attr('href','RepTicketVentanillaComApCre.htm?fechaSistemaP='+fechaHora+
										'&monto='+$('#totalDepAR').val()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
										'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
										'&varCreditoID='+varCreditoID+'&numCopias='+$('#numCopias').val()+'&sumTotalEnt='+$('#sumTotalEnt').val()+
										'&diferencia='+$('#sumTotalSal').val()+'&varFormaPago='+"Efectivo"+
										'&numCli='+$('#clienteIDAR').val()+'&nombreCli='+limpiarCaracteresEsp($('#nombreClienteAR').val())+'&cuentaAho='+$('#cuentaAhoIDAR').val()+
										'&tipoCuen='+$('#nomCuentaAR').val()+'&tipoTransaccion='+$('#tipoTransaccion').val()+
										'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+$('#monedaDesAR').val()+'&montoComision='+$('#comisionAR').val()+
										'&montoIva='+$('#ivaAR').val()+'&productoCred='+$('#desProdCreditoAR').val()+
										'&grupo='+$('#grupoDesAR').val()+'&ciclo='+$('#cicloIDAR').val());


							}else{
								imprimirTicketTransaccion(BotonTransaccion);
							}

						break;

						case catTipoTransaccionVen.desembolsoCredito:
							var fechaHora = $('#fechaSistemaP').val()+" " +hora();
							var varCreditoID = $('#creditoIDDC').val();
							var ante = $('#totalDesembolsoDC').asNumber()-$('#montoPorDesemDC').asNumber();
							var porDesem = $('#montoPorDesemDC').asNumber()-$('#totalRetirarDC').asNumber();

							if(TipoImpresion !=ticket){
								$('#enlaceTicket').attr('href','RepTicketVentanillaDesCred.htm?fechaSistemaP='+fechaHora+
									'&monto='+$('#totalRetirarDC').val()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
									'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
									'&numCopias='+$('#numCopias').val()+'&sumTotalEnt='+$('#sumTotalEnt').val()+
									'&diferencia='+$('#sumTotalSal').val()+'&varFormaPago='+"Efectivo"+
									'&numCli='+$('#clienteIDDC').val()+'&nombreCli='+limpiarCaracteresEsp($('#nombreClienteDC').val())+'&cuentaAho='+$('#cuentaAhoIDDC').val()+
									'&referen='+$('#creditoIDDC').val()+'&tipoCuen='+$('#nomCuentaDC').val()+'&tipoTransaccion='+$('#tipoTransaccion').val()+
									'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+$('#monedaDesDC').val()+'&montoComision='+$('#comisionDC').val()+
									'&montoIva='+$('#ivaDC').val()+'&productoCred='+$('#desProdCreditoDC').val()+
									'&varCreditoID='+varCreditoID+'&montoCred='+$('#montoCreDC').val()+'&monPorDes='+porDesem+
									'&montoDes='+$('#totalDesembolsoDC').val()+'&montoResAnt='+ante+
									'&grupo='+$('#grupoDesDC').val()+'&ciclo='+$('#cicloIDDC').val());
							}else{
								imprimirTicketTransaccion(BotonTransaccion);
							}

						break;
						case catTipoTransaccionVen.cobroSeguroVida:
							var tipoTransaccionRepSeguroVidaCobro=8;

							if(TipoImpresion !=ticket){
									$('#enlaceTicket').attr('href','TicketVentanillaSegVida.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
										'&rfcInstitucion='+rfcInstitucion+'&nomCajero='+$('#nomCajero').val()+'&transaccion='+
										$('#numeroTransaccion').val()+'&clienteIDSC='+$('#clienteIDSC').val()+'&nombreClienteSC='+limpiarCaracteresEsp($('#nombreClienteSC').val())+
										'&montoSeguroCobro='+$('#montoSeguroCobro').asNumber()+'&numeroSucursal='+sucursalID+'&tipoTransaccion=8'+'&direccionInstitucion='+direccionInstitucion+
										'&nombreSucursal='+$('#nombreSucursal').val()+'&telefonosucursal='+telefono+'&fechaSistema='+$('#fechaSistema').val()+
										'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+'&simbMonedaBase='+simboloMonedaBase+
										'&descripcionMoneda='+descrpcion, '_blank');
							}else{
								imprimirTicketTransaccion(BotonTransaccion);
							}
						break;
						case catTipoTransaccionVen.aplicaSeguroVida:
							var transaccionReporteSiniestro=9;
							$('#enlaceTicket').attr('href','ReporteVentanillaSegVida.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
									'&poliza='+$('#numeroPolizaS').val()+'&clienteIDSC='+$('#clienteIDS').val()+'&nombreClienteSC='+limpiarCaracteresEsp($('#nombreClienteS').val())+
									'&creditoIDS='+$('#creditoIDS').val()+'&fechaInicioSeguro='+$('#fechaInicioSeguro').val()+'&fechaVencimiento='+$('#fechaVencimiento').val()+
									'&beneficiarioSeguro='+$('#beneficiarioSeguro').val()+'&direccionBeneficiario='+$('#direccionBeneficiario').val()+
									'&desRelacionBeneficiario='+$('#desRelacionBeneficiario').val()+'&montoPoliza='+$('#montoPoliza').asNumber()+
									'&nombreSucursal='+$('#nombreSucursal').val()+'&nomCajero='+$('#nomCajero').val()+
									'&fechaSistema='+$('#fechaSistema').val()+ '&tipoTransaccion=9'+'&numeroSucursal='+sucursalID+'&desMonedaBase='+monedaBase+
									'&numMonedaBase='+numeromonedaBase+'&simbMonedaBase='+simboloMonedaBase+
									'&descripcionMoneda='+descrpcion, '_blank');

						break;
						case catTipoTransaccionVen.devolucionGL:
							imprimirTicketTransaccion(BotonTransaccion);
						break;
						case catTipoTransaccionVen.cambioEfectivo:
							imprimirTicketTransaccion(BotonTransaccion);
						break;
						case catTipoTransaccionVen.transferenciaCuenta:
							imprimirTicketTransaccion(BotonTransaccion);
						break;
						case catTipoTransaccionVen.aportacionSocial:
							var fechaHora = $('#fechaSistemaP').val()+" " +hora();
							var montoPendiente;

							montoPendiente=$('#montoPendientePagoAS').asNumber() - $('#montoAS').asNumber();
							var montoPagado=$('#montoPagadoAS').asNumber()+$('#montoAS').asNumber();

							montoPagado=cantidadFormatoMoneda(montoPagado);
							montoPendiente=cantidadFormatoMoneda(montoPendiente);
							if(TipoImpresion !=ticket){
								$('#enlaceTicket').attr('href','RepTicketAportacionSocio.htm?fechaSistemaP='+fechaHora+
									'&monto='+$('#montoAS').val()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
									'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
									'&numCopias='+$('#numCopias').val()+'&sumTotalEnt='+$('#sumTotalEnt').val()+'&diferencia='+$('#sumTotalSal').val()+
									'&varFormaPago='+"Efectivo"+'&numCli='+$('#clienteIDAS').val()+'&nombreCli='+limpiarCaracteresEsp($('#nombreClienteAS').val())+
									'&tipoTransaccion='+catTipoTicketVen.aportacionSocial+'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+monedaBase+
									'&rfc='+$('#RFCAS').val()+'&montoPendiente='+montoPendiente+'&montoPagado='+montoPagado+'&desMonedaBase='+monedaBase+
									'&numMonedaBase='+numeromonedaBase+'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+descrpcion,'_blank');
							}else{
								imprimirTicketTransaccion(BotonTransaccion);
							}
							break;
						case catTipoTransaccionVen.devAportacionSocio:
							var fechaHora = $('#fechaSistemaP').val()+" " +hora();
							if(TipoImpresion !=ticket){
								$('#enlaceTicket').attr('href','RepTicketDevAportaSocio.htm?fechaSistemaP='+fechaHora+
										'&monto='+$('#montoDAS').val()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
										'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
										'&numCopias='+$('#numCopias').val()+'&sumTotalEnt='+$('#sumTotalEnt').val()+'&diferencia='+$('#sumTotalSal').val()+
										'&varFormaPago='+"Efectivo"+'&numCli='+$('#clienteIDDAS').val()+'&nombreCli='+limpiarCaracteresEsp($('#nombreClienteDAS').val())+
										'&tipoTransaccion='+catTipoTicketVen.devAportacionSocial+'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+monedaBase+
										'&rfc='+$('#RFCDAS').val()+'&desMonedaBase='+monedaBase+'&tipoPersona='+$('#tipoPersonaDAS').val()+
										'&numMonedaBase='+numeromonedaBase+'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+descrpcion,'_blank');
							}else{
								imprimirTicketTransaccion(BotonTransaccion);
							}
							break;

						case catTipoTransaccionVen.cobroSegVidaAyuda:
							window.open('repCertSegVida.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
									'&RFCInstit='+rfcInst+'&nombreUsuario='+$('#nomCajero').val()+
									'&clienteID='+$('#clienteIDCSVA').val()+'&nombreCliente='+limpiarCaracteresEsp($('#nombreClienteCSVA').val())+
									'&sucursal='+sucursalID+'&tipoTransaccion='+catTipoTicketVen.cobroSegAyuda+
									'&direccionInstit='+direccionInstitucion+'&nombreSucursal='+$('#nombreSucursal').val()+
									'&telefonoInst='+telefono+'&fechaActual='+fechaSucursal+'&tipoReporte=1','_blank');

							if(TipoImpresion !=ticket){
								$('#enlaceTicket').attr('href','RepTicketCobroSegAyudaSocio.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
										'&rfcInstitucion='+rfcInstitucion+'&nomCajero='+$('#nomCajero').val()+'&transaccion='+
										$('#numeroTransaccion').val()+'&clienteID='+$('#clienteIDCSVA').val()+'&nombreCliente='+limpiarCaracteresEsp($('#nombreClienteCSVA').val())+
										'&montoSeguroCobro='+$('#montoCobrarSeg').asNumber()+'&numeroSucursal='+sucursalID+'&tipoTransaccion='+catTipoTicketVen.cobroSegAyuda+
										'&direccionInstitucion='+direccionInstitucion+'&nombreSucursal='+$('#nombreSucursal').val()+'&telefonosucursal='+
										telefono+'&fechaSistema='+$('#fechaSistema').val()+'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+
										'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+descrpcion, '_blank');
							}else{
								imprimirTicketTransaccion(BotonTransaccion);
							}

							break;

						case catTipoTransaccionVen.aplicaSegVidaAyuda:
							if(TipoImpresion !=ticket){
								$('#enlaceTicket').attr('href','RepTicketPagoSeguroAyuda.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
										'&rfcInstitucion='+rfcInstitucion+'&nomCajero='+$('#nomCajero').val()+'&transaccion='+
										$('#numeroTransaccion').val()+'&clienteID='+$('#clienteIDASVA').val()+'&nombreCliente='+limpiarCaracteresEsp($('#nombreClienteASVA').val())+
										'&montoSeguroPago='+$('#montoPolizaSegAyudaCobroA').asNumber()+'&numeroSucursal='+sucursalID+'&tipoTransaccion='+catTipoTicketVen.pagoSegAyuda+
										'&direccionInstitucion='+direccionInstitucion+'&nombreSucursal='+$('#nombreSucursal').val()+'&telefonosucursal='+
										telefono+'&fechaSistema='+$('#fechaSistema').val()+'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+
										'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+descrpcion, '_blank');
							}else{
								imprimirTicketTransaccion(BotonTransaccion);
							}
							break;
						case catTipoTransaccionVen.pagoRemesas:
							var clienteIDRemesa = '';
							var nombreClienteRemesa = '';
							if ($('#clienteIDServicio').val() != '' || $('#clienteIDServicio').val() != 0) {
								clienteIDRemesa = $('#clienteIDServicio').val();
								nombreClienteRemesa = $('#nombreClienteServicio').val();
							} else{
								clienteIDRemesa = '';
								nombreClienteRemesa = $('#nombreUsuarioRem').val();
							};

							if(TipoImpresion !=ticket){
								$('#enlaceTicket').attr('href','RepTicketPagoRemesas.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
										'&rfcInstitucion='+rfcInstitucion+'&nomCajero='+$('#nomCajero').val()+'&transaccion='+
										$('#numeroTransaccion').val()+'&clienteIDServicio='+clienteIDRemesa+'&nombreClienteServicio='+limpiarCaracteresEsp(nombreClienteRemesa)+
										'&montoServicio='+$('#montoServicio').asNumber()+'&numeroSucursal='+sucursalID+'&tipoTransaccion='+catTipoTicketVen.pagoRemesa+
										'&direccionInstitucion='+direccionInstitucion+'&nombreSucursal='+$('#nombreSucursal').val()+'&telefonosucursal='+
										telefono+'&fechaSistema='+$('#fechaSistema').val()+'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+
										'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+
										descrpcion+'&referenciaServicio='+limpiarCaracteresEsp($('#referenciaServicio').val())+'&sumTotalSal='+$('#sumTotalSal').val(),'_blank');
							}else{
								imprimirTicketTransaccion(BotonTransaccion);
							}
							break;
						case catTipoTransaccionVen.pagoOportunidades:
							var clienteIDRemesa = '';
							var nombreClienteRemesa = '';
							if ($('#clienteIDServicio').val() != '' || $('#clienteIDServicio').val() != 0) {
								clienteIDRemesa = $('#clienteIDServicio').val();
								nombreClienteRemesa = $('#nombreClienteServicio').val();
							} else{
								clienteIDRemesa = '';
								nombreClienteRemesa = $('#nombreUsuarioRem').val();
							};
								if(TipoImpresion !=ticket){
									$('#enlaceTicket').attr('href','RepTicketPagoOportunidades.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
											'&rfcInstitucion='+rfcInstitucion+'&nomCajero='+$('#nomCajero').val()+'&transaccion='+
											$('#numeroTransaccion').val()+'&clienteIDServicio='+clienteIDRemesa+'&nombreClienteServicio='+limpiarCaracteresEsp(nombreClienteRemesa)+
											'&montoServicio='+$('#montoServicio').asNumber()+'&numeroSucursal='+sucursalID+'&tipoTransaccion='+catTipoTicketVen.pagoOportunidades+
											'&direccionInstitucion='+direccionInstitucion+'&nombreSucursal='+$('#nombreSucursal').val()+'&telefonosucursal='+
											telefono+'&fechaSistema='+$('#fechaSistema').val()+'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+
											'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+
											descrpcion+'&referenciaServicio='+limpiarCaracteresEsp($('#referenciaServicio').val())+'&sumTotalSal='+$('#sumTotalSal').val(),'_blank');
								}else{
									imprimirTicketTransaccion(BotonTransaccion);
								}
								break;

						case catTipoTransaccionVen.recepcionChequeSBC:
								if(TipoImpresion !=ticket){
									$('#enlaceTicket').attr('href','RepTicketRecepChequeSBC.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
											'&rfcInstitucion='+rfcInstitucion+'&nomCajero='+$('#nomCajero').val()+'&transaccion='+
											$('#numeroTransaccion').val()+'&clienteID='+$('#clienteIDSBC').val()+'&nombreCliente='+limpiarCaracteresEsp($('#nombreClienteSBC').val())+
											'&monto='+$('#montoSBC').asNumber()+'&numeroSucursal='+sucursalID+'&tipoTransaccion='+catTipoTicketVen.recepChequeSBC+
											'&direccionInstitucion='+direccionInstitucion+'&nombreSucursal='+$('#nombreSucursal').val()+'&telefonosucursal='+
											telefono+'&fechaSistema='+$('#fechaSistema').val()+'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+
											'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+
											descrpcion+'&cuentaDestino='+$('#numeroCuentaRec').val()+'&cuentaEmisor='+$('#numeroCuentaEmisorSBC').val()
											+'&numCheque='+$('#numeroChequeSBC').val()+'&nombreEmisor='+$('#nombreEmisorSBC').val()
											+'&numBanco='+$('#bancoEmisorSBC').val()
											+'&nombreBanco='+$('#nombreBancoEmisorSBC').val()+'&tipoCheque='+$('#tipoCtaCheque').val(),'_blank');
								}else{
									imprimirTicketTransaccion(BotonTransaccion);
								}
								break;
							case catTipoTransaccionVen.aplicaChequeSBC:
								if(TipoImpresion !=ticket){
									$('#enlaceTicket').attr('href','RepTicketAplicaChequeSBC.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
											'&rfcInstitucion='+rfcInstitucion+'&nomCajero='+$('#nomCajero').val()+'&transaccion='+
											$('#numeroTransaccion').val()+'&clienteID='+$('#clienteIDSBCAplic').val()+'&nombreCliente='+limpiarCaracteresEsp($('#nombreClienteSBCAplic').val())+
											'&monto='+$('#montoSBCAplic').asNumber()+'&numeroSucursal='+sucursalID+'&tipoTransaccion='+catTipoTicketVen.aplicaChequeSBC+
											'&direccionInstitucion='+direccionInstitucion+'&nombreSucursal='+$('#nombreSucursal').val()+'&telefonosucursal='+
											telefono+'&fechaSistema='+$('#fechaSistema').val()+'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+
											'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+
											descrpcion+'&cuentaDestino='+$('#numeroCuentaSBC').val()+'&cuentaEmisor='+$('#numeroCuentaEmisorSBCAplic').val()
											+'&numCheque='+$('#numeroChequeSBCAplic').val()+'&nombreEmisor='+$('#nombreEmisorSBCAplic').val()
											+'&numBanco='+$('#bancoEmisorSBCAplic').val()
											+'&nombreBanco='+$('#nombreBancoEmisorSBCAplic').val(),'_blank');
								}else{
									imprimirTicketTransaccion(BotonTransaccion);
								}
								break;
							case catTipoTransaccionVen.prepagoCredito:
								var creditoPrepago= $('#creditoIDPre').val();
								var PrepagoIndividual='I';

								if(TipoImpresion !=ticket){
									var tituloOperacion='PREPAGO DE CREDITO EN EFECTIVO';
									var productoCredito=$('#producCreditoIDPre').val()+"   "+$('#descripcionProdPre').val();
										$('#enlaceTicket').attr('href','RepTicketPagoCredito.htm?fechaSistemaP='+$('#fechaSistema').val()+
												'&monto='+$('#montoPagarPre').val()+'&nombreInstitucion='+parametroBean.nombreInstitucion+'&numeroSucursal='+
												parametroBean.sucursal+'&nombreSucursal='+ parametroBean.nombreSucursal+'&varCreditoID='+creditoPrepago+
												'&numCopias='+1+'&varFormaPago='+"Efectivo"+'&numTrans='+$('#numeroTransaccion').val()+
												'&moneda='+$('#monedaDesPre').val()+'&productoCred='+productoCredito+'&grupo='+$('#grupoDesPre').val()+'&ciclo='+
												$('#cicloIDPre').val()+'&tituloOperacion='+tituloOperacion+'&edoMunSucursal='+parametroBean.edoMunSucursal, '_blank');
								}else{
									imprimeTicketPrepagoCredito(creditoPrepago,1,PrepagoIndividual);
								}
								break;
							case catTipoTransaccionVen.prepagoCreditoGrupal:
								if(TipoImpresion !=ticket){
									var tituloOperacion='PREPAGO DE CREDITO EN EFECTIVO';
									var productoCredito=$('#producCreditoIDPre').val()+"   "+$('#descripcionProdPre').val();
										$('#enlaceTicket').attr('href','RepTicketPagoCredito.htm?fechaSistemaP='+$('#fechaSistema').val()+
												'&monto='+$('#montoPagarPre').val()+'&nombreInstitucion='+parametroBean.nombreInstitucion+'&numeroSucursal='+
												parametroBean.sucursal+'&nombreSucursal='+ parametroBean.nombreSucursal+'&varCreditoID='+$('#creditoIDPre').val()+
												'&numCopias='+1+'&varFormaPago='+"Efectivo"+'&numTrans='+$('#numeroTransaccion').val()+
												'&moneda='+$('#monedaDesPre').val()+'&productoCred='+productoCredito+'&grupo='+$('#grupoDesPre').val()+'&ciclo='+
												$('#cicloIDPre').val()+'&tituloOperacion='+tituloOperacion+'&edoMunSucursal='+parametroBean.edoMunSucursal, '_blank');
								}else{
									imprimirTicketPrepagoGrupal();
								}
								break;
							case catTipoTransaccionVen.pagoServicios:
									imprimirTicketTransaccion(BotonTransaccion);

							break;
							case catTipoTransaccionVen.recuperaCartera:
								if(TipoImpresion !=ticket){

									$('#montoPorRecuperarTotal').val($('#montoPorRecuperar').asNumber()-$('#montoRecuperar').asNumber());
									$('montoRecuperadoTotal').val($('#monRecuperado').asNumber()+$('#montoRecuperar').asNumber());

									$('#montoPorRecuperarTotal').formatCurrency({
										positiveFormat: '%n',
										roundToDecimalPlace: 2
									});
									$('#montoRecuperadoTotal').formatCurrency({
										positiveFormat: '%n',
										roundToDecimalPlace: 2
									});

									$('#enlaceTicket').attr('href','RepTicketCredCastigado.htm?fechaSistemaP='+$('#fechaSistemaP').val()+
											'&montoPago='+$('#montoRecuperar').val()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
											'&nombreSucursal='+$('#nombreSucursal').val()+'&numeroCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
											'&creditoID='+$('#creditoVencido').val()+'&numCopias='+$('#numCopias').val()+'&sumTotalEnt='+$('#sumTotalEnt').val()+
											'&diferencia='+$('#sumTotalSal').val()+'&formaPAgo='+"Efectivo"+'&tipoTransaccion='+catTipoTicketVen.cartCastigada+
											'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+$('#desMonedaCartVencida').val()+'&productoCred='+$('#desProducVencido').val()+
											'&grupo='+$('#grupoDesCast').val()+'&ciclo='+$('#cicloIDCast').val()+'&fechaCastigo='+$('#fechaCastigo').val()
											+'&montoCastigado='+$('#totalCastigado').val()+'&clienteID='+$('#clienteIDVencido').val()+
											'&nombreCliente='+limpiarCaracteresEsp($('#nombreClienteVencido').val())+'&montoRecuperar='+$('#montoPorRecuperarTotal').val()+
											'&montoRecuperado='+$('#montoRecuperadoTotal').val()
											,'_blank');
								}else{
									imprimirTicketTransaccion(BotonTransaccion);
								}

						break;
						case catTipoTransaccionVen.pagoServifun:
							if(TipoImpresion !=ticket){
								var jqNombreBenef= eval("'#nombreCteServifun'");
								var jqNombreRecibePago= eval("'#nombreCteServifun'");
								var jqMontoPago= eval("'#montoEntregarServifun'");
								var jqClienteBenefi = eval("'#clienteServifunID'");
								window.open('TicketPagoServifun.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
									'&rfcInstitucion='+rfcInst+'&nomCajero='+$('#nomCajero').val()+'&transaccion='+
									$('#numeroTransaccion').val()+'&nombreBeneficiario='+limpiarCaracteresEsp($(jqNombreBenef).val())+
									'&nombreRecibePago='+limpiarCaracteresEsp($(jqNombreRecibePago).val())+'&numeroSucursal='+sucursalID+'&tipoTransaccion='+catTipoTicketVen.pagoServifun+
									'&direccionInstitucion='+direccionInstitucion+'&nombreSucursal='+$('#nombreSucursal').val()+
									'&telefonosucursal='+telefono+'&fechaSistema='+	$('#fechaSistema').val()+'&desMonedaBase='+monedaBase+
									'&numMonedaBase='+numeromonedaBase+'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+descrpcion+
									'&montoPago='+$(jqMontoPago).asNumber()+'&porcentaje=100%'+'&tipoIdentificacion='+$('#tipoIdentificacion').val()+
									'&folioIdentifi='+$('#folioIdentificacion').val()+'&folioSolicitud='+$('#serviFunFolioID').val()
									+'&clienteIDBenef='+$(jqClienteBenefi).val(),
									'_blank');
							}else{
								imprimeTicketPagoServifun();  /* pagoServifun.js  */
							}
						break;
						case catTipoTransaccionVen.cobroApoyoEscolar:
							if(TipoImpresion !=ticket){
								var nombreRecibePago ='';
								if($('#recibeApoyoEscolar').val() !=''){
									nombreRecibePago =$('#recibeApoyoEscolar').val();
								}else{
									nombreRecibePago =$('#nombreCteApoyoEsc').val();
								}
								window.open('TicketPagoApoyoEscolar.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
										'&rfcInstitucion='+rfcInst+'&nomCajero='+$('#nomCajero').val()+'&transaccion='+
										$('#numeroTransaccion').val()+'&nombreCliente='+limpiarCaracteresEsp($('#nombreCteApoyoEsc').val())+
										'&nombreRecibePago='+limpiarCaracteresEsp($('#recibeApoyoEscolar').val())+'&numeroSucursal='+sucursalID+'&tipoTransaccion='+
										catTipoTicketVen.pagoApoyoEscolar+'&direccionInstitucion='+direccionInstitucion+
										'&nombreSucursal='+$('#nombreSucursal').val()+'&telefonosucursal='+telefono+'&fechaSistema='+
										$('#fechaSistema').val()+'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+
										'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+descrpcion+
										'&montoPago='+$('#monto').asNumber()+'&numeroSolicitud='+$('#apoyoEscSolID').val()+
										'&clienteID='+$("#clienteIDApoyoEsc").val(),'_blank');
							}else{
								imprimeTicketApoyoEscolar();  /* pagoApoyoEscolar.js  */
							}
						break;
					case catTipoTransaccionVen.anualidadTarjeta:
						if(TipoImpresion !=ticket){
							window.open('AnualidadTD.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
									'&rfcInstitucion='+rfcInst+'&nomCajero='+$('#nomCajero').val()+'&transaccion='+
									$('#numeroTransaccion').val()+'&nombreCliente='+limpiarCaracteresEsp($('#nombreCteTarjeta').val())+
									'&numeroSucursal='+sucursalID+'&tipoTransaccion='+catTipoTicketVen.anualidaTD+
									'&direccionInstitucion='+direccionInstitucion+'&nombreSucursal='+$('#nombreSucursal').val()+
									'&telefonosucursal='+telefono+'&fechaSistema='+$('#fechaSistema').val()+
									'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+
									'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+descrpcion+
									'&montoTotal='+$('#totalComisionTD').asNumber()+'&clienteID='+$("#clienteIDTarjeta").val()+
									'&munTarjetaDebito='+$('#tarjetaDebID').val() + '&IVAComision='+$('#ivaComisionTarjeta').asNumber()+
									'&totalEntradas='+$('#sumTotalEnt').asNumber()+'&totalSalidas='+$('#sumTotalSal').asNumber()+
									'&cuentaAhorro='+$('#numCtaTarjetaDeb').val() +'&montoComisionTarjeta='+$('#montoComisionTarjeta').asNumber()
									,'_blank');
						}else{
								imprimeTicketAnualidadTarjeta();  /*cobroAnualTarjetaDeb.js*/
						}
						break;
						case catTipoTransaccionVen.pagoCancelSocio:
							if(TipoImpresion !=ticket){
								var jqNombreBenef= eval("'#nombreBeneficiario'");
								var jqNombreRecibePago= eval("'#nombreRecibePago'");
								var jqMontoPago= eval("'#totalRecibir'");

								window.open('ticketPagoCancelacionSocio.htm?nombreInstitucion='+$('#nombreInstitucion').val()+
									'&rfcInstitucion='+rfcInst+'&nomCajero='+$('#nomCajero').val()+'&transaccion='+
									$('#numeroTransaccion').val()+'&nombreBeneficiario='+limpiarCaracteresEsp($(jqNombreBenef).val())+
									'&nombreRecibePago='+limpiarCaracteresEsp($(jqNombreRecibePago).val())+'&numeroSucursal='+sucursalID+'&tipoTransaccion='+catTipoTicketVen.pagoCancelSocio+
									'&direccionInstitucion='+direccionInstitucion+'&nombreSucursal='+$('#nombreSucursal').val()+
									'&telefonosucursal='+telefono+'&fechaSistema='+	$('#fechaSistema').val()+'&desMonedaBase='+monedaBase+
									'&numMonedaBase='+numeromonedaBase+'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+descrpcion+
									'&montoPago='+$(jqMontoPago).asNumber()+'&porcentaje=100%'+'&tipoIdentificacion='+$('#tipoIdentificacion').val()+
									'&folioIdentifi='+$('#folioIdentificacion').val()+'&folioSolicitud='+$('#serviFunFolioID').val(),
									'_blank');
							}else{
								imprimeTicketPagoCancelacionSocio();  /* /ventanilla/pagoClientesCancela.js */
							}
						break;

						// Imprime el Ticket de Gastos o Anticipos por Comprobar
						case catTipoTransaccionVen.anticiposGastos:
							if(TipoImpresion !=ticket){
								var fechaHora = $('#fechaSistemaP').val()+" " +hora();
								if($('#formaPagoOpera1').is(':checked')){
									  formPago = "EFECTIVO";
									  totalEnt=$('#sumTotalEnt').val();
									  totalSal=$('#sumTotalSal').val();
								}else{
									 formPago = "CHEQUE";
									  totalEnt="0.00";
									  totalSal="0.00";
								}
								window.open('RepTicketVentanillaGastos.htm?fechaSistemaP='+fechaHora+
								'&monto='+$('#montoGastoAnt').asNumber()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
								'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
								'&numCopias='+$('#numCopias').val()+'&diferencia='+$('#diferencia').val()+'&sumTotalEnt='+totalEnt+
								'&totalSalida='+totalSal+'&montos='+$('#montoGastoAnt').val()+
								'&varFormaPago='+formPago+'&empleadoID='+$('#empleadoID').val()+'&nombreEmpleadoGA='+limpiarCaracteresEsp($('#nombreEmpleadoGA').val())+
								'&tipoTransaccion='+catTipoTicketVen.anticiposGastos+'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+monedaBase+
								'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+descrpcion+
								'&nombreOperacion='+descoperacion,'_blank');
							}else{
								imprimeTicketGastoAnt();  /* /ventanilla/salidaGastosAnticipos.js */
							}
						break;
						// Imprime el Ticket de Devoluciones de Gastos o Anticipos
						case catTipoTransaccionVen.devolucionesGastAnt:
							if(TipoImpresion !=ticket){
								var fechaHora = $('#fechaSistemaP').val()+" " +hora();
								window.open('RepTicketVentanillaDevGastos.htm?fechaSistemaP='+fechaHora+
								'&monto='+$('#montoGastoDev').asNumber()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
								'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
								'&numCopias='+$('#numCopias').val()+'&diferencia='+$('#diferencia').val()+'&sumTotalEnt='+$('#sumTotalEnt').val()+
								'&sumTotalSal='+$('#sumTotalSal').val()+'&montos='+$('#montoGastoDev').val()+
								'&varFormaPago='+"Efectivo"+'&empleadoID='+$('#empleadoIDDev').val()+'&nombreEmpleadoGA='+limpiarCaracteresEsp($('#nombreEmpleadoDev').val())+
								'&tipoTransaccion='+catTipoTicketVen.devolucionesGastAnt+'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+monedaBase+
								'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+descrpcion+
								'&totalSalidas='+$('#totalSalidas').val()+'&nombreOperacion='+descoperacion,'_blank');
							}else{
								imprimeTicketDevGastoAnt();  /* /ventanilla/entradaGastosAnticipos.js */
							}
						break;
						case catTipoTransaccionVen.haberesExmenor:
							if(TipoImpresion !=ticket){
								var fechaHora = $('#fechaSistemaP').val()+" " +hora();
								if($('#formaPagoOpera1').is(':checked')){
									  formPago = "EFECTIVO";
									  totalEnt=$('#sumTotalEnt').val();
									  totalSal=$('#sumTotalSal').val();
								}else{
									 formPago = "CHEQUE";
									  totalEnt="0.00";
									  totalSal="0.00";
								}
								window.open('RepTicketVentanillaHaberesExMenor.htm?fechaSistemaP='+fechaHora+
								'&monto='+$('#totalHaberes').asNumber()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
								'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
								'&numCopias='+$('#numCopias').val()+'&diferencia='+$('#diferencia').val()+'&sumTotalEnt='+totalEnt+
								'&sumTotalSal='+totalSal+'&montos='+$('#totalHaberes').val()+
								'&varFormaPago='+formPago+'&clienteID='+$('#clienteIDMenor').val()+'&nombreCliente='+limpiarCaracteresEsp($('#nombreClienteMenor').val())+
								'&tipoTransaccion='+catTipoTicketVen.haberesExmenor+'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+monedaBase+
								'&desMonedaBase='+monedaBase+'&numMonedaBase='+numeromonedaBase+'&simbMonedaBase='+simboloMonedaBase+'&descripcionMoneda='+descrpcion+
								'&totalSalidas='+$('#totalSalidas').val(),'_blank');
								}else{
								imprimeTicketHaberesExMenor();  /* /ventanilla/reclamoHaberesExMenor.js */
							}
						break;
						case catTipoTransaccionVen.pagoArrendamiento: //ticket Pago de arrendamiento
							if(TipoImpresion !=ticket){
								window.open('RepTicketVentanillaPagArrendamiento.htm?fechaSistemaP='+$('#fechaSistemaP').val()+
										'&nombreInstitucion='+$('#nombreInstitucion').val()+
										'&numeroSucursal='+$('#numeroSucursal').val()+
										'&nombreSucursal='+$('#nombreSucursal').val()+
										'&varCaja='+$('#numeroCaja').val()+
										'&nomCajero='+$('#nomCajero').val()+
										'&varArrendamientoID='+$('#arrendamientoID').val()+
										'&numCopias='+$('#numCopias').val()+
										'&sumTotalEnt='+$('#sumTotalEnt').val()+
										'&diferencia='+$('#sumTotalSal').val()+
										'&varFormaPago='+"Efectivo"+
										'&tipoTransaccion='+$('#tipoTransaccion').val()+
										'&numTrans='+$('#numeroTransaccion').val()+
										'&moneda='+$('#monedaArrendamiento').val(),
										'_blank');
							}else{
								var arrendamiento=$('#arrendamientoID').val();
								var fechaPago=$('#fechaSistemaP').val();
								var transaccion=$('#numeroTransaccion').val();
								imprimeTicketPagoArrendamiento(arrendamiento,fechaPago, transaccion);  /* pagoArrendamiento.js  */
							}
						break;
						case catTipoTransaccionVen.cobroAccesoriosCre:
							if (TipoImpresion==ticket) {
								imprimirTicketTransaccion(BotonTransaccion);
							}
						break;

						case catTipoTransaccionVen.depositoActivaCta:
							if(TipoImpresion == ticket){
								imprimirTicketTransaccion(BotonTransaccion);
							}
						break;

					}

				}
				else{
					$('#impTicket').hide();
					$('#impCheque').hide();
					$('#numeroTransaccion').val("");
				}
			});



			function grabaFormaTransaccionVentanilla(event, idForma, idDivContenedor, idDivMensaje,inicializaforma, idCampoOrigen) {
				consultaSesion();
				var jqForma = eval("'#" + idForma + "'");
				var jqContenedor = eval("'#" + idDivContenedor + "'");
				var jqMensaje = eval("'#" + idDivMensaje + "'");
				var url = $(jqForma).attr('action');
				var resultadoTransaccion = 0;
				quitaFormatoControles(idForma);
				$(jqMensaje).html('<img src="images/barras.jpg" alt=""/>');
				$(jqContenedor).block({
					message: $(jqMensaje),
					css: {
						border:		'none',
						background:	'none'
					}
				});
				// Envio de la forma

				$.post( url, serializaForma(idForma), function( data ) {
					if(data.length >0) {
						$(jqMensaje).html(data);
						var exitoTransaccion =$('#numeroMensaje').asNumber();
						resultadoTransaccion = exitoTransaccion;
						parametroBean = consultaParametrosSession();
						if(mostrarAlertLimite == 1){
							mensajeSis(mensajeLimite);
							mostrarAlertLimite = 0;
							$('#grabaLimitesCta').val(0);
						}
						$('#saldoMNSesionLabel').text(parametroBean.saldoEfecMN);
						$('#saldoMNSesionLabel').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});

						$('#impTicket').hide();
						if( $('#numeroMensaje').val() != null
							&& $('#numeroMensaje').val().trim() != ''
							&& $('#numeroMensaje').val()!=undefined
							&& !isNaN($('#numeroMensaje').val())
							&& $('#numeroMensaje').asNumber()== '0'
							&& $('#consecutivo').val() != null
							&& $('#consecutivo').val().trim() != ''
							&& $('#consecutivo').val()!=undefined
							&& !isNaN($('#consecutivo').val().replace(",",""))
							&& $('#consecutivo').asNumber()>0 ){
							agregaFormatoControles(idForma);
							var campo = eval("'#" + idCampoOrigen + "'");
							if($('#consecutivo').val() != 0){

								var arreglo = $('#consecutivo').val().split(',');
								if(mensajeResp != undefined ){
									serverHuella.registroBitacora(arreglo[0]);
								}
								$(campo).val(arreglo[0]); // Numero de transaccion
								Var_Poliza = arreglo[1]; // Numero de Póliza
								if(Var_Poliza > 0 && ($('#tipoOperacion').val()==ajusteSobrante || $('#tipoOperacion').val()==ajusteFaltante)){
									$('#impPoliza').show();
								}else{
									$('#impPoliza').hide();
								}
							}
							if($('#tipoTransaccion').val() == catTipoTransaccionVen.ajusteFaltante || $('#tipoTransaccion').val() == catTipoTransaccionVen.ajusteSobrante){
								$('#impTicket').hide();
								$('#impCheque').hide();
								limpiaFormularioExito();// Exito no necesita datos para ticket
							}else{
								$('#impTicket').show();
								if($('#formaPagoOpera2').is(':checked') || $('#pagoServicioCheque').is(':checked')){
									$('#impCheque').show();
									soloLecturaControl('beneCheque');
									soloLecturaControl('numeroCheque');
									soloLecturaControl('confirmeCheque');
								}
							}


							deshabilitaBoton('graba', 'submit');
							$('#billetesMonedasEntrada').val("");
							$('#billetesMonedasSalida').val("");
							imprimirTicketVentanilla();
							mostrarBotonResumen($('#tipoOperacion').val());

						}else{
							mostrarAlertLimite=0;
							deshabilitaBoton('graba', 'submit');
							$('#impTicket').hide();
							$('#impCheque').hide();
							$('#impPoliza').hide();
							ocultarBtnResumen();
						}
						actualizaFormatosMoneda('formaGenerica');
						parametroBean = consultaParametrosSession();
						$('#saldoMNSesionLabel').text(parametroBean.saldoEfecMN);
						$('#saldoMNSesionLabel').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
					}
				});
				return resultadoTransaccion;
			}

			function validarConfirmacionTelefono(telefono){
				var numeroTelefono = $('#telefonoPSL').val();
				return numeroTelefono == telefono;

			}

			jQuery.validator.addMethod("confirmaTelefono", function(value, element) {
				return validarConfirmacionTelefono(value);
			}, "Confirmación de teléfono inválido");


			function validarConfirmacionReferencia(referencia){
				var numeroReferencia = $('#referenciaPSL').val();
				return numeroReferencia == referencia;

			}

			jQuery.validator.addMethod("confirmaReferencia", function(value, element) {
				return validarConfirmacionReferencia(value);
			}, "Confirmación de la referencia inválida");



			function validarMontoMayorCero(value){

				var monto = $('#precio').val();
				var valorMonto = monto.replace(',','');
				return parseFloat(valorMonto) > 0.0;

			}

			jQuery.validator.addMethod("validaMonto", function(value, element) {
				return validarMontoMayorCero(value);
			}, "Ingresar un monto mayor a cero");

			//------------ Validaciones de la Forma -------------------------------------
			$('#formaGenerica').validate({
				rules: {
					tipoOperacion: 'required'	,

					cantEntraMil: {number: true},
					cantEntraQui: {number: true},
					cantEntraDos: {number: true},
					cantEntraCien: {number: true},
					cantEntraCin: {number: true},
					cantEntraVei: {number: true},
					cantEntraMon: {number: true},

					cantSalMil: {number: true},
					cantSalQui: {number: true},
					cantSalDos: {number: true},
					cantSalCien: {number: true},
					cantSalCin: {number: true},
					cantSalVei: {number: true},
					cantSalMon: {number: true},

					garantiaAdicionalPC			: {number: true},
					montoServicio				: {number: true},
					folioIdentiClienteServicio:	{required: function() {
						return $('#tipoOperacion').asNumber() == 16 || $('#tipoOperacion').asNumber() == 17;}
					},

					bancoEmisorSBC: 		{number: true},
					numeroCuentaEmisorSBC: {maxlength:12},
					montoSBC: 				{number: true},
					totalPagar			:{number: true},
					montoPagoServicio	:{number: true},
					clienteIDCobroServ	:{required: function() {
											return $('#requiereClienteServicio').val() == 'S' && $('#prospectoIDServicio').asNumber() <= 0;}
										},
					prospectoIDServicio	:{required: function() {
											return  $('#requiereClienteServicio').val() == 'S' && $('#clienteIDCobroServ').asNumber() <= 0;},
											numeroPositivo: true
										},
					creditoIDServicio	:{required: function() {
											return $('#requiereCreditoServicio').val() == 'S';}
										},
					montoRecuperar:{number: true},
					recibeApoyoEscolar: {maxlength:200},
					montoFaltante:{number: true},
					montoSobrante:{number: true},
					tipoIdentificacion	:{required: function() {
						return $('#tipoOperacion').val() == "25";}
					},
					folioIdentificacion	:{required: function() {
						return $('#tipoOperacion').val() == "25";}
					},
					referenciaServicio:{required: function (){
						return $('#tipoOperacion').asNumber() ==16 || $('#tipoOperacion').asNumber() ==17;}
					},
					folioUtilizar:{required: function(){return ( ($('#formaPagoOpera2').is(':checked') || $('#pagoServicioCheque').is(':checked')));}},
					numeroCheque:{required:  function(){return ($('#formaPagoOpera2').is(':checked') || $('#pagoServicioCheque').is(':checked'));},
								 number:true},
					confirmeCheque:{required:  function(){return ($('#formaPagoOpera2').is(':checked') || $('#pagoServicioCheque').is(':checked'));},
									number:true},
					beneCheque:{required:  function(){return ($('#formaPagoOpera2').is(':checked') || $('#pagoServicioCheque').is(':checked'));}},
					empleadoID:{
						required: function(){return ($('#tipoOperacion').val()==38 && $('#reqEmp').val()=="SI");}
					},
					empleadoIDDev:{
						required: function(){return ($('#tipoOperacion').val()==39 && $('#reqEmp').val()=="S");}
					},

					identiMenor:{
						required: function(){return ($('#tipoOperacion').val()==40);}
					},

						remesaCatalogoID:{//uuuuu
							required: function(){return ($('#tipoOperacion').val()==16);}
						},
						indentiClienteServicio:{
							required: function(){return ($('#tipoOperacion').val()==16 || $('#tipoOperacion').val()==17);}
						},

						nombreClienteServicio:{
							maxlength:200
						},
						referenciaPagoServicio :{
							required: function(){return ($('#tipoOperacion').val()==21);},
							maxlength:200,
						},
						segundaRefeServicio :{
							maxlength:200,
						},
						numeroCuentaServicio:{
							required: function(){return ($('#tipoOperacion').val()==16 || $('#tipoOperacion').val()==17) && ($('#pagoServicioDeposito').attr('checked')== true);},
							maxlength: 12
						},
						montoCargar:{
							required: function(){return ($('#tipoOperacion').val()== 1);},
							number: true
						},
						montoAbonar:{
							required: function(){return ($('#tipoOperacion').val()== 2);},
							number: true
						},

						montoPagar:{
							required:function(){return ($('#tipoOperacion').val()== 3);},
							number: true
						},
						creditoID:{
							required:function(){return ($('#tipoOperacion').val()== 3);}
						},
						montoPagarArrendamiento:{
							required:function(){return ($('#tipoOperacion').val()== 42);},
							number: true
						},
						arrendamientoID:{
							required:function(){return ($('#tipoOperacion').val()== 42);}
						},
						numeroChequeSBC:{
							required: function() {return ($('#tipoOperacion').val() == 18);}
						},
						numeroCuentaEmisorSBC:{
							required: function(){return ($('#tipoOperacion').val() == 18);}
						},
						nombreEmisorSBC:{
							required: function(){return ($('#tipoOperacion').val() == 18 && $('#tipoCtaCheque').val() == 'E');}
						},
						montoSBC:{
							required: function(){return ($('#tipoOperacion').val() == 18);}
						},
						beneficiarioSBC:{
							required: function(){return ($('#tipoOperacion').val() == 18 && $('#tipoCtaCheque').val() == 'I');}
						},
						creditoIDPre:{
							required: function(){return ($('#tipoOperacion').val() == 20);}
						},
						montoPagarPre:{
							required: function(){return ($('#tipoOperacion').val() == 20);}
						},
						claveUsuarioAut:{
							required: function(){return ($('#tipoOperacion').val() == 27);}
						},
						contraseniaAut:{
							required: function(){return ($('#tipoOperacion').val() == 27);}
						},
						claveUsuarioAut:{
							required: function(){return ($('#tipoOperacion').val() == 28);}
						},
						contraseniaAut:{
							required: function(){return ($('#tipoOperacion').val() == 28);}
						},
						montoGastoAnt:{
							required: function(){return ($('#tipoOperacion').val() == 38);},
							number: true
						},
						montoGastoDev:{
							required: function(){return ($('#tipoOperacion').val() == 39);},
							number: true
						},
						montoCargarT:{
							required: function(){return ($('#tipoOperacion').val() == 41);},
						number: true
						},
						cuentaAhoIDCa:{
							required:function(){return ($('#tipoOperacion').val() == 1);}
						},
						cuentaAhoIDAb:{
							required:function(){return ($('#tipoOperacion').val() == 2);}
						},
						cuentaAhoIDT:{
							required:function(){return ($('#tipoOperacion').val() == 10);}
						},
						cuentaChequePago:{required:  function(){return ($('#formaPagoOpera2').is(':checked') || $('#pagoServicioCheque').is(':checked'));}
							 },
						tipoChequera:{required:  function(){return ($('#formaPagoOpera2').is(':checked') || $('#pagoServicioCheque').is(':checked'));}
							 },
						monedaIDAb:{
							required: function(){return ($('#tipoOperacion').val() == 2);}
						},


						productoID: {
							required: function(){ return ($('#tipoOperacion').val() == pagoServiciosEnLinea); }
						},
						tipoUsuario: {
							required: function(){ return ($('#tipoOperacion').val() == pagoServiciosEnLinea); }
						},
						clienteIDPSL: {
							required: function(){ return ($('#tipoOperacion').val() == pagoServiciosEnLinea && $("#tipoUsuarioC").attr('checked')); }
						},
						formaPagoPSL: {
							required: function(){ return ($('#tipoOperacion').val() == pagoServiciosEnLinea); }
						},
						telefonoPSL: {
							required: function(){ return ($('#tipoOperacion').val() == pagoServiciosEnLinea && $('#tipoFront').val() == 1 ); },
							minlength: 10,
							maxlength:10,
							digits:true
						},
						confirmTelefonoPSL: {
							required: function(){ return ($('#tipoOperacion').val() == pagoServiciosEnLinea && $('#tipoFront').val() == 1 ); },
							confirmaTelefono:true,
							minlength: 10,
							maxlength:10,
							digits: true
						},
						referenciaPSL: {
							required: function(){ return ($('#tipoOperacion').val() == pagoServiciosEnLinea && $('#tipoFront').val() > 1 ); }
						},
						confirmReferenciaPSL: {
							required: function(){ return ($('#tipoOperacion').val() == pagoServiciosEnLinea && $('#tipoFront').val() > 1 ); },
							confirmaReferencia:true
						},
						cuentaAhorroPSL: {
							required: function(){ return ($('#tipoOperacion').val() == pagoServiciosEnLinea && $('#formaPagoC').attr('checked')); },
							number: true,
							min: 1
						},
						numeroTarjetaPSL: {
							maxlength:16,
							digits: true,
							min: 1
						},
						montoDepositoActivaCta:{
							required: function(){return ($('#tipoOperacion').val()== 46);},
							number: true
						}
				},

				messages: {
					tipoOperacion: 'Especifique tipo de Operación.',

					cantEntraMil: {number: 'Sólo Números.'},
					cantEntraQui: {number: 'Sólo Números.'},
					cantEntraDos: {number: 'Sólo Números.'},
					cantEntraCien: {number: 'Sólo Números.'},
					cantEntraCin: {number: 'Sólo Números.'},
					cantEntraVei: {number: 'Sólo Números.'},
					cantEntraMon: {number: 'Sólo Números.'},

					cantSalMil: {number: 'Sólo Números.'},
					cantSalQui: {number: 'Sólo Números.'},
					cantSalDos: {number: 'Sólo Números.'},
					cantSalCien: {number: 'Sólo Números.'},
					cantSalCin: {number: 'Sólo Números.'},
					cantSalVei: {number: 'Sólo Números.'},
					cantSalMon: {number: 'Sólo Números.'},

					garantiaAdicionalPC: {number: 'Sólo Números.'},
					numeroCuentaServicio: {numeroPositivo:  'Sólo Números.'},
					montoServicio: {number:  'Sólo Números.'},
					numeroCuentaRec: 		{required: 'Especifique una Cuenta de Ahorro.'},
					bancoEmisorSBC:			{number: 'Sólo Números.'},
					numeroCuentaEmisorSBC:	{number: 'Sólo Números.', maxlength:'Máximo 12 Números.'},
					montoSBC:				{number: 'Sólo Números.'},
					totalPagar				:{number: 'Sólo Números.'},
					montoPagoServicio		:{number: 'Sólo Números.'},
					clienteIDCobroServ	:{required: 'Ingrese el '+$('#socioClienteAlert').val()},
					prospectoIDServicio	:{required:	'Ingrese el Prospecto.',numeroPositivo :'Sólo Números.'},
					creditoIDServicio	:{required: 'Ingrese el Crédito.'},
					montoRecuperar:{number: 'Sólo Números.'},
					recibeApoyoEscolar: {maxlength:'Máximo 200 Caracteres.'},
					montoFaltante:{number: 'Sólo Números.'},
					montoSobrante:{number: 'Sólo Números.'},
					tipoIdentificacion: 'Especifique Tipo de Identificación.',
					folioIdentificacion: 'Especifique Folio de Identificación.',
					folioUtilizar: {required: 'Último Folio Registrado Vacío.'},
					numeroCheque: {required: 'Especifique Número de Cheque.',
									number: 'Solo Números.'},
					confirmeCheque:{required: 'Especifique Confirmación de Cheque.',
									number: 'Solo Números.'},
					beneCheque: {required: 'Especifique el Nombre del Beneficiario.'},
					tipoIdentificacion:{required: 'Especifique tipo de Identificación.'},
					folioIdentificacion: {required: 'Especifique folio de Identificación.'},
					empleadoID:{
						required:'Especifique Empleado.'
					},
					empleadoIDDev:{
						required:'Especifique Empleado.'
					},
					identiMenor:{
						required:'Especifique Identificación.'
					},
					folioIdentiClienteServicio:{
						required:'Especifique Folio de Identificación.',
					},

					referenciaServicio:{
						required:'Especifique Referencia.',
					},
					remesaCatalogoID:{//uuuuu
						required:'Seleccione una Remesadora.'
					},
					indentiClienteServicio:{
						required:'Seleccione un Tipo de Identificación.'
					},

					nombreClienteServicio:{
						maxlength:'Máximo 200 Caracteres.'
					},
					referenciaPagoServicio:{
						maxlength:'Máximo 200 Caracteres.',
						required:'Especifique la Referencia.'
					},
					segundaRefeServicio:{
						maxlength:'Máximo 200 Caracteres.'
					},
					numeroCuentaServicio:{
						required:'Especifique un Número de Cuenta.',
						maxlength:'Máximo 12 Números.'
					},
					montoCargar:{
						required: 'Especifique el Monto.',
						number:'Sólo Números.'
					},
					montoAbonar:{
						required: 'Especifique el Monto.',
						number:'Sólo Números.'
					},
					montoPagar:{
						required: 'Especifique Monto.',
						number:'Sólo Números.'
					},
					creditoID:{
						required: 'Especifique Número de Crédito.'
					},
					montoPagarArrendamiento:{
						required: 'Especifique Monto.',
						number:'Sólo Números.'
					},
					arrendamientoID:{
						required: 'Especifique Número de Arrendamiento.'
					},
					numeroChequeSBC: {
						required:'Especifique el Número de Cheque.'
					},
					numeroCuentaEmisorSBC:{
						required:'Especifique Número de Cuenta.'
					},
					nombreEmisorSBC:{
						required: 'Especifique Nombre del Emisor.'
					},
					montoSBC:{
						required: 'Especifique Monto.'
					},
					beneficiarioSBC:{
						required: 'Especifique Beneficiario.'
					},
					creditoIDPre:{
						required: 'Especifique Número de Crédito.'
					},
					montoPagarPre:{
						required: 'Especifique Monto.'
					},
					claveUsuarioAut:{
						required: 'Especifique Usuario.'
					},
					contraseniaAut:{
						required: 'Especifique Contraseña.'
					},
					claveUsuarioAut:{
						required: 'Especifique Usuario.'
					},
					contraseniaAut:{
						required: 'Especifique Contraseña.'
					},
					montoGastoAnt:{
						required: 'Especifique Monto.',
						number:'Sólo Números.'
					},
					montoGastoDev:{
						required: 'Especifique Monto.',
						number: 'Sólo Números.'
					},
					montoCargarT:{
						required: 'Especifique Monto.',
					number: 'Sólo Números.'
					},
					cuentaAhoIDCa:{
						required:'Especifique Cuenta.'
					},
					cuentaAhoIDAb:{
						required:'Especifique Cuenta.'
					},
					cuentaAhoIDT:{
						required:'Especifique Cuenta.'
					},
					cuentaChequePago:{
						required:'Especifique Cuenta.'
					 },
					 tipoChequera:{
						 required:'Especifique Tipo Chequera'
					 },
					 monedaIDAb:{
						required:'La Moneda es Requerida.'
					 },




					productoID: {
						required:'Seleccione el Servicio.'
					},
					tipoUsuario: {
						required:'Seleccione una opción.'
					},
					clienteIDPSL: {
						required:'Especifique el cliente.'
					},
					formaPagoPSL: {
						required:'Seleccione una opción.'
					},
					telefonoPSL: {
						required:'Especifique el número telefónico.',
						minlength:'El número debe ser de 10 dígitos',
						maxlength:'El número debe ser de 10 dígitos',
						digits:'Sólo números'
					},
					confirmTelefonoPSL: {
						required:'Confirme el número telefónico.',
						minlength:'El número debe ser de 10 dígitos',
						maxlength:'El número debe ser de 10 dígitos',
						digits:'Sólo números'
					},
					referenciaPSL: {
						required:'Especifique la referencia'
					},
					confirmReferenciaPSL: {
						required:'Confirme la referencia.'
					},
					cuentaAhorroPSL: {
						required: 'Especifique la cuenta de ahorro',
						number: 'Debe ser númerico',
						min: 'Debe ser númerico'
					},
					numeroTarjetaPSL: {
						maxlength:'El numero debe de ser de 16 dígitos',
						digits: 'Debe ser númerico',
						min: 'Debe ser mayor a cero'
					},
					montoDepositoActivaCta:{
						required: 'Especifique el Monto.',
						number:'Sólo Números.'
					}
				}
			});

			function limpiaFormularioExito(){
				$('#montoFaltante').val('');
				$('#montoSobrante').val('');
				$('#claveUsuarioAut').val('');
				$('#contraseniaAut').val('');
				inicializarEntradasSalidasEfectivo();

			}
			//------------ Validaciones de Controles -------------------------------------
			function consultarParametrosBean() {
				var parametroBean = consultaParametrosSession();
				$('#fechaSistemaP').val(parametroBean.fechaSucursal);
				$('#nombreInstitucion').val(parametroBean.nombreInstitucion);
				$('#numeroSucursal').val(parametroBean.sucursal);
				$('#nombreSucursal').val(parametroBean.nombreSucursal);
				$('#numeroCaja').val(parametroBean.cajaID);
				$('#nomCajero').val(parametroBean.nombreUsuario);
			}

			// validar el limite de efectivo de la caja
			function consultaLimiteCaja() {
				parametroBean = consultaParametrosSession();
				var varMontoLimiteMN = parametroBean.limiteEfectivoMN;
				var saldoEfectCaja = $('#saldoEfecMNSesion').asNumber();
				if(parametroBean.cajaID>0){
					if(parseFloat(varMontoLimiteMN) >= parseFloat(saldoEfectCaja)){
						bloquearCaja = "no";

					}else{

						bloquearCaja = "si";
						inicializarCampos();
						deshabilitaBoton('graba', 'submit');
						$('#impTicket').hide();
						$('#impCheque').hide();
						ocultarBtnResumen();
						mensajeSis("Para Realizar una Nueva Operación es \n" +
								"Necesario Realizar una Transferencia de Efectivo.");
					}
				}
				else{
					mensajeSis('El Estado de Operación de esta Caja es Cerrada.');
					bloquearCaja = "si";
					inicializarCampos();
					deshabilitaBoton('graba', 'submit');
				}
				return bloquearCaja;
			}


			// se consulta por cargo a Cuenta -------****
			function consultaCtaAhoCargo(idControl) {
		var jqCta = eval("'#" + idControl + "'");
		var numCta = $(jqCta).val();
		var tipConCampos = 4;
		var estaActivo = 'A';
		var CuentaAhoBeanCon = {
			'cuentaAhoID' : numCta
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if (numCta != '' && !isNaN(numCta)) {
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon, function(cuenta) {
				if (cuenta != null) {
					if (cuenta.estatus == estaActivo) {
						$('#tipoCuentaCa').val(cuenta.descripcionTipoCta);
						$('#cuentaAhoIDCa').val(cuenta.cuentaAhoID);
						$('#numClienteCa').val(cuenta.clienteID);
						$('#monedaIDCa').val(cuenta.monedaID);
						var cliente = $('#numClienteCa').asNumber();
						if (cliente > 0) {
							listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, cuenta.cuentaAhoID, 0);
							consultaSPL = consultaPermiteOperaSPL(cliente,'LPB',esCliente);

							if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
								expedienteBean = consultaExpedienteCliente(cliente);
								if (expedienteBean.tiempo <= 1) {
									if (alertaCte(cliente) != 999) {
										esTab = "true";
										$('#saldoDisponCa').val(cuenta.saldoDispon);
										$('#monedaCa').val(cuenta.descripCortaMon);
										$('#saldoCargo').val(cuenta.saldo);
										consultaClientePantallaCargo('numClienteCa');
										$('#impTicket').hide();
										$('#impCheque').hide();
										ocultarBtnResumen();
										habilitaBoton('verFirmas', 'submit');
									}
								} else {
									mensajeSis('Es Necesario Actualizar el Expediente del ' + $('#socioClienteAlert').val() + ' para Continuar.');
									$('#cuentaAhoIDCa').focus();
									$('#cuentaAhoIDCa').select();
									inicializarCampos();
									deshabilitaBoton('verFirmas', 'submit');
								}
							} else {
								mensajeSis('La Persona se Encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
								$('#cuentaAhoIDCa').focus();
								$('#cuentaAhoIDCa').select();
								inicializarCampos();
								deshabilitaBoton('verFirmas', 'submit');
							}
						}
					} else {
						mensajeSis('La Cuenta Esta Inactiva.');
						$('#cuentaAhoIDCa').focus();
						$('#cuentaAhoIDCa').select();
						inicializarCampos();
						deshabilitaBoton('verFirmas', 'submit');
					}
				} else {
					mensajeSis("No Existe la Cuenta de Ahorro.");
					$('#cuentaAhoIDCa').focus();
					$('#cuentaAhoIDCa').select();
					inicializarCampos();
					deshabilitaBoton('verFirmas', 'submit');
				}
			});
		}
	}




			function consultaClientePantallaCargo(idControl) {
				var jqCliente  = eval("'#" + idControl + "'");
				var numCliente = $(jqCliente).val();
				var conCliente =1;
				var rfc = ' ';
				setTimeout("$('#cajaLista').hide();", 200);
				if(numCliente != '' && !isNaN(numCliente)){
					clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
								if(cliente!=null){
									$('#nombreClienteCa').val(cliente.nombreCompleto);
									 if (cliente.estatus=='I'){
											mensajeSis("El Cliente se encuentra Inactivo.");
											$('#nombreClienteCa').val('');
											$('#saldoDisponCa').val('');
											$('#cuentaAhoIDCa').focus();
											$('#numClienteCa').val('');
											$('#monedaIDCa').val('');
											$('#monedaCa').val('');
											$('#tipoCuentaCa').val('');
											$('#cuentaAhoIDCa').val('');
											$('#referenciaAb').val('');
									 }
								}else{
									mensajeSis("No Existe el Cliente.");
									$(jqCliente).focus();
								}
						});
					}
			}

			// se consulta por abono a cuenta -------****
			function consultaCtaAhoAbono(idControl) {
				var numCta = $('#cuentaAhoIDAb').val();
				var tipConCampos= 4;
				var activo = 'A';
				var CuentaAhoBeanCon = {
					'cuentaAhoID'	:numCta
				};
				if(numCta != '' && !isNaN(numCta)){
					setTimeout("$('#cajaLista').hide();", 200);
					cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
								if(cuenta!=null){
										if(cuenta.estatus == activo){
											$('#tipoCuentaAb').val(cuenta.descripcionTipoCta);
											$('#cuentaAhoIDAb').val(cuenta.cuentaAhoID);
											$('#numClienteAb').val(cuenta.clienteID);
										    $('#monedaIDAb').val(cuenta.monedaID);
											var cliente = $('#numClienteAb').asNumber();
											if(cliente>0){
												listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, cuenta.cuentaAhoID, 0);
												consultaSPL = consultaPermiteOperaSPL(cliente,'LPB',esCliente);

												if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
													expedienteBean = consultaExpedienteCliente($('#numClienteAb').val());
													if(expedienteBean.tiempo<=1){
														esTab= "true";
														consultaClientePantallaAbono('numClienteAb');
														$('#saldoDisponAb').val(cuenta.saldoDispon);
														$('#monedaAb').val(cuenta.descripCortaMon);

														$('#impTicket').hide();
														$('#impCheque').hide();
														ocultarBtnResumen();
														validaLimites();
													} else {
														mensajeSis('Es necesario Actualizar el Expediente del '+$('#socioClienteAlert').val()+' para Continuar.');
														$('#cuentaAhoIDAb').focus();
														$('#cuentaAhoIDAb').select();
														inicializarCampos();
													}
												} else {
													mensajeSis('La Persona se Encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
													$('#cuentaAhoIDAb').focus();
													$('#cuentaAhoIDAb').select();
													inicializarCampos();
												}
											}
										}else{
											mensajeSis('La Cuenta esta Inactiva.');
											$('#cuentaAhoIDAb').focus();
											$('#cuentaAhoIDAb').select();
											inicializarCampos();
										}
								}else{
									mensajeSis("No Existe la Cuenta de Ahorro.");
									$('#cuentaAhoIDAb').focus();
									$('#cuentaAhoIDAb').select();
									inicializarCampos();
								}
						});
				}else{
					if(esTab == true){
						inicializaForma('formaGenerica','cuentaAhoIDAb' );
						$('#cuentaChequePago').val('');
						$('#tipoChequera').val('');
						validarFormaPago();
					}
				}
			}


			//Cnsulta el estatus que tiene el cliente
			function consultaClientePantallaAbono(idControl) {//aqui puse
				var jqCliente  = eval("'#" + idControl + "'");
				var numCliente = $(jqCliente).val();
				var conCliente =1;
				var rfc = ' ';
				setTimeout("$('#cajaLista').hide();", 200);
				if(numCliente != '' && !isNaN(numCliente)){
					clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
								if(cliente!=null){
									$('#impTicket').hide();
									ocultarBtnResumen();
									$('#nombreClienteAb').val(cliente.nombreCompleto);
									consultaMontoAdeudoPROFUN(idControl);
									if(cliente.estatus=="I"){
										mensajeSis("El Cliente se Encuentra Inactivo.");
										$('#numClienteAb').val('');
										$('#nombreClienteAb').val('');
										$('#cuentaAhoIDAb').focus();
										$('#saldoDisponAb').val('');
										$('#monedaIDAb').val('');
										$('#monedaAb').val('');
										$('#tipoCuentaAb').val('');
										$('#cuentaAhoIDAb').val('');

									}
								}else{
									mensajeSis("No Existe el Cliente.");
									$(jqCliente).focus();
								}
						});
					}
			}






			// Consulta el monto adeudado de PROFUN
			function  consultaMontoAdeudoPROFUN(controlID){
				var jqCliente  = eval("'#" + controlID + "'");
				var clienteID = $(jqCliente).val();
				var numConsulta =2;
				var bean = {
						'clienteID'		: clienteID
					};
				setTimeout("$('#cajaLista').hide();", 200);


				if(clienteID != '' && !isNaN(clienteID)){
					clientesPROFUNServicio.consulta(numConsulta,bean,function(adeudo){
								if(adeudo!=null){
									// setea en los campos en los que se muestra esa informacion
									if(adeudo.numClientesProfun >0){
										$("#adeudoPROFUN").show();
										$("#lblAdeudoProfun").show();
										$('#lblAdeudoProfunPREC').show('');
										$('#adeudoPROFUNPREC').show('');
										$("#lblAdeudoProfunPC").show();
										$("#adeudoPROFUNPC").show();
										$("#adeudoPROFUN").val(adeudo.montoPendiente);
										$("#adeudoPROFUNPC").val(adeudo.montoPendiente);
										$("#adeudoPROFUNPREC").val(adeudo.montoPendiente);
									}else{
										$("#adeudoPROFUN").hide();
										$("#lblAdeudoProfun").hide();
									}

								}else{
									$("#adeudoPROFUN").val("0.00");
									$("#adeudoPROFUNPC").val("0.00");
									$("#adeudoPROFUNPREC").val("0.00");
								}
						});
					}
			}



			// se consulta por deposito de garantia Liquida -------****
			function consultaCtaAhoGarantiaLiquida(idControl) {
				var numCta = $('#cuentaAhoIDGL').val();
				var tipConCampos= 4;
				var CuentaAhoBeanCon = {
					'cuentaAhoID'	:numCta
				};
				setTimeout("$('#cajaLista').hide();", 200);

				if(numCta != '' && !isNaN(numCta)){
					cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
								if(cuenta!=null){
									$('#tipoCuentaGL').val(cuenta.descripcionTipoCta);
									$('#cuentaAhoIDGL').val(cuenta.cuentaAhoID);
									$('#numClienteGL').val(cuenta.clienteID);
									esTab= "true";
									consultaSaldoCtaAhoGarantiaLiq('cuentaAhoIDGL',cuenta.clienteID);
									$('#impTicket').hide();
									$('#impCheque').hide();
									ocultarBtnResumen();
									$('#pagoGLEfectivo').focus();
								}else{
									mensajeSis("No Existe la Cuenta de Ahorro.");
									$('#cuentaAhoIDGL').focus();
									$('#cuentaAhoIDGL').select();
									inicializarCampos();
								}
						});
				}else{
					inicializarCampos();
				}
			}

			function consultaSaldoCtaAhoGarantiaLiq(idControl,numCte) {
				var jqCta  = eval("'#" + idControl + "'");
				var numCta = $(jqCta).val();
				var tipConCampos= 5;
				var CuentaAhoBeanCon = {
					'cuentaAhoID'	:numCta,
					'clienteID'		:numCte
				};
				setTimeout("$('#cajaLista').hide();", 200);

				if(numCta != '' && !isNaN(numCta)){
					cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
								if(cuenta!=null){
									$('#saldoDisponGL').val(cuenta.saldoDispon);
									$('#saldoBloqGL').val(cuenta.saldoBloq);
									$('#monedaGL').val(cuenta.descripcionMoneda);
									$('#monedaIDGL').val(cuenta.monedaID);
									$('#impTicket').hide();
									$('#impCheque').hide();
									ocultarBtnResumen();
								}else{
									mensajeSis("No Existe la Cuenta de Ahorro o No Corresponde a ese Cliente.");
									$('#cuentaAhoIDGL').focus();
									$('#cuentaAhoIDGL').select();
								}
						});
				}
			}


			function consultaClientePantallaGarantiaLiq(idControl) {
				var jqCliente  = eval("'#" + idControl + "'");
				var numCliente = $(jqCliente).val();
				var conCliente =5;
				var rfc = ' ';
				setTimeout("$('#cajaLista').hide();", 200);
				if(numCliente != '' && !isNaN(numCliente)){
					clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
							if(cliente!=null){

								inicializarCamposGL();
						  		consultarParametrosBean();
						  		inicializarEntradasSalidasEfectivo();
								 if(cliente.estatus == EstatusCteInactivo){
									 mensajeSis ("El Cliente se Encuentra Inactivo.");
									 $(jqCliente).focus();
									 $(jqCliente).val('');
									 deshabilitaBoton('graba', 'submit');
								 }else{
									 $('#nombreClienteGL').val(cliente.nombreCompleto);
									 consultaCreditosClientes(numCliente);
								 }
							}else{
								mensajeSis("No Existe el Cliente.");
								$(jqCliente).focus();
							}
					});
				}
			}

			//funcion para llenar el combo de creditos por clientes      creditoProductoMonto
			function consultaCreditosClientes(clienteID) {
				var credBean = {
						'clienteID'	:clienteID
				};
		  		dwr.util.removeAllOptions('referenciaGL');
		  		if(clienteID != '' && !isNaN(clienteID)){
		  			creditosServicio.listaCombo(19,credBean, function(credCli){
		  				if(credCli!=null){

		  					for (var i = 0; i < credCli.length; i++){
		  						consultaGrupoMontoGL(credCli[0].creditoID);
		  					}
		  					dwr.util.addOptions('referenciaGL', credCli, 'creditoID', 'credito_Descripcion_Monto');
		  					$('#impTicket').hide();
		  					$('#impCheque').hide();
		  					ocultarBtnResumen();

		  				}else{//mensajeSis("combo no data  ");
		  					dwr.util.removeAllOptions('referenciaGL');
		  					dwr.util.addOptions('referenciaGL', 'NO TIENE CREDITOS');
		  					deshabilitaBoton('graba', 'submit');
		  				}
		  			});
		  		}
			}

			//** funciones para consultar el grupo y monto sugerido de gl***
			function consultaGrupoMontoGL(valControl){
				var numCredito = valControl;
				setTimeout("$('#cajaLista').hide();", 200);
				if(numCredito != '' && !isNaN(numCredito)){
					var creditoBeanCon = {
						'creditoID':numCredito
						};

		   			creditosServicio.consulta(12,creditoBeanCon,function(credito) {
		   				if(credito!=null){
		   					esTab=true;
							$('#montoGarantiaLiq').val(credito.montoGLSugerido);
							$('#grupoIDGL').val(credito.grupoID);
							if(credito.grupoID>0){
								$('#cicloIDGL').val(credito.cicloGrupo);
								consultaGrupo(credito.grupoID, 'grupoIDGL', 'grupoDesGL','cicloIDGL');
								$('#tdGrupoGLlabel').show();
								$('#tdGrupoGLinput').show();
								$('#tdGrupoCicloGLlabel').show();
								$('#tdGrupoCicloGLinput').show();
							}else {
								$('#grupoDesGL').val("");
								$('#tdGrupoGLlabel').hide();
								$('#tdGrupoGLinput').hide();
								$('#tdGrupoCicloGLlabel').hide();
								$('#tdGrupoCicloGLinput').hide();
							}
							$('#impTicket').hide();
							$('#impCheque').hide();
							ocultarBtnResumen();
							$('#tipoTransaccion').val(catTipoTransaccionVen.garantiaLiq);

		   				}else{
		   					inicializaForma('formaGenerica','creditoIDDC');
		   					consultaDisponibleDenominacion();
		   					inicializarCampos();
		   					validarFormaPago();
		   					$('#cuentaChequePago').val('');
		   					$('#tipoChequera').val('');
		   				}
					});
				}else{
					deshabilitaBoton('graba', 'submit');
				}
			}

			//** funciones para la consulta de los datos por deposito de gl al seleccionar un credito
			function consultaCreditoGL(){
				$('#tipoTransaccion').val(catTipoTransaccionVen.garantiaLiq);
				var numCredito = $('#referenciaGL').val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(numCredito != '' && !isNaN(numCredito) ){
					var creditoBeanCon = {
						'creditoID':$('#referenciaGL').val(),
		  				'fechaActual':$('#fechaSistema').val()
		  			};
		   			creditosServicio.consulta(11,creditoBeanCon,function(credito) {//catTipoConsultaCredito.saldos
		   				if(credito!=null){
		   					esTab=true;
							$('#numClienteGL').val(credito.clienteID);
							$('#cuentaAhoIDGL').val(credito.cuentaID);
							consultaCtaAhoGarantiaLiquida('cuentaAhoIDGL');
							$('#montoGarantiaLiq').val("");
							$('#numeroTransaccion').val("");
							$('#numeroMensaje').val("1");
							$('#impTicket').hide();
							$('#impCheque').hide();
							ocultarBtnResumen();
							agregaFormatoMoneda('formaGenerica');
							consultaGrupoMontoGL($('#referenciaGL').val());

		   				}else{
		   					inicializaForma('formaGenerica','numClienteGL');
		   					consultaDisponibleDenominacion();
		   					mensajeSis("El "+$('#socioClienteAlert').val()+ " No tiene un Crédito Relacionado.");
		   					inicializarCampos();
		   					validarFormaPago();
		   					$('#numClienteGL').focus();
		   					$('#cuentaChequePago').val('');
		   					$('#tipoChequera').val('');
		   				}
					});
				}
			}


			// funcion par inicializar los campos de gl
			function inicializarCamposGL(){
				$('#cuentaAhoIDGL').val("");
				$('#tipoCuentaGL').val("");
				$('#saldoDisponGL').val("");
				$('#saldoBloqGL').val("");
				$('#monedaIDGL').val("");

				$('#monedaGL').val("");
				$('#montoGarantiaLiq').val("");
				$('#grupoIDGL').val("");
				$('#cicloIDGL').val("");
				$('#grupoDesGL').val("");
				$('#sumaGarantiaAdicionalInt').val("");
				$('#sumaPendienteGarAdiInt').val("");
				$('#impTicket').hide();
				$('#impCheque').hide();
				ocultarBtnResumen();
			}

			// fin de consultas de garantia liquida

			// Consultas para la devolucion de garantia liquida
			function consultaCreditoDevGL(controlID){
				var estatusPagado		="P";
				var estatusVigente		="V";

				var numCredito = $('#creditoDGL').val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(numCredito != '' && !isNaN(numCredito) ){
					var creditoBeanCon = {
						'creditoID':$('#creditoDGL').val(),
		  				'fechaActual':$('#fechaSistema').val()
		  			};
		  			creditosServicio.consulta(11,creditoBeanCon,function(credito) {//catTipoConsultaCredito.saldos

		   				if(credito!=null){
		   					listaPersBloqBean = consultaListaPersBloq(credito.clienteID, esCliente, 0, 0);
							consultaSPL = consultaPermiteOperaSPL(credito.clienteID,'LPB',esCliente);

							if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
			   					esTab=true;
								$('#creditoDGL').val(credito.creditoID);
								$('#numClienteDG').val(credito.clienteID);

								$('#productoCreditoDGL').val(credito.producCreditoID);
								$('#cuentaAhoIDDG').val(credito.cuentaID);
								$('#montoCreditoDGL').val(credito.montoCredito);
								$('#monedaIDDG').val(credito.monedaID);
								$('#grupoIDDGL').val(credito.grupoID);
								$('#montoTotalGLD').val(credito.aporteCliente);
								if(credito.grupoID > 0){
									$('#cicloIDDGL').val(credito.cicloGrupo);
									consultaGrupo(credito.grupoID,'grupoIDDGL','grupoDesDGL','cicloIDDGL');
									$('#trGrupoDGL').show();
								}else {
									$('#grupoIDDGL').val();
									$('#cicloIDDGL').val();
									$('#grupoDesDGL').val();
									$('#trGrupoDGL').hide();
								}
								validaEstatusCreditoSeguro(credito.estatus, 'estatusCredDGL');
								consultaCtaDevGL(credito.cuentaID);
								consultaSaldoDevGL(credito.creditoID);
								consultaProdCredito(credito.producCreditoID,'productoCreditoDGL','desProducCreditoDGL');
								$('#tipoTransaccion').val(catTipoTransaccionVen.devolucionGL);
								$('#numeroTransaccion').val("");
								//$('#cantSalMil').focus();
								if($('#formaPagoOpera1').is(':checked')){
									$('#formaPagoOpera1').focus();
								}else{
									$('#formaPagoOpera2').focus();
								}

								if (credito.estatus == estatusPagado  || credito.estatus== estatusVigente){
									consultaPagoGarantiaLiquida('creditoDGL');

								}else{
									mensajeSis("El Crédito No tiene Estatus Vigente o Pagado.");
									soloLecturaEntradasSalidasEfectivo();

								}

								agregaFormatoMoneda('formaGenerica');
			   				}else{
			   					consultaDisponibleDenominacion();
								mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
								$('#creditoDGL').focus();
			   					$('#creditoDGL').select();
			   					inicializarCampos();
			   					inicializaForma('formaGenerica','creditoDGL');
			   					validarFormaPago();
			   					$('#cuentaChequePago').val('');
			   					$('#tipoChequera').val('');
			   				}
		   				}else{
		   					consultaDisponibleDenominacion();
		   					mensajeSis("No Existe el Crédito.");
		   					$('#creditoDGL').focus();
		   					$('#creditoDGL').select();
		   					inicializarCampos();
		   					inicializaForma('formaGenerica','creditoDGL');
		   					validarFormaPago();
		   					$('#cuentaChequePago').val('');
		   					$('#tipoChequera').val('');
		   				}
					});
				}


			}

			function consultaSaldoDevGL(credito){
				var consultaSaldoDevGL= 2;
				var DesbloqueoSal = {
					'referencia'	:$('#creditoDGL').val(),
					'cuentaAhoID'	:$('#cuentaAhoIDDG').val(),
				};
				setTimeout("$('#cajaLista').hide();", 200);
				if(credito != '' && !isNaN(credito)){
					bloqueoSaldoServicio.consulta(consultaSaldoDevGL, DesbloqueoSal,function(bloqueo) {
							if(bloqueo != null){
								$('#montoDevGL').val(bloqueo.montoBloq);
								if(($('#montoDevGL').asNumber() < $('#montoTotalGLD').asNumber())){
									mensajeSis("Es Necesario Desbloquear la Garantía Líquida Completa.");
									soloLecturaEntradasSalidasEfectivo();
								}

							}else{
								mensajeSis("Es Necesario Desbloquear la Garantía Líquida.");
							}
						});
				}
			}
			//Cre.AporteCliente as AporteCliente
			function consultaCtaDevGL(numCta) {
				var tipConCampos= 4;
				var CuentaAhoBeanCon = {
					'cuentaAhoID'	:numCta
				};
				setTimeout("$('#cajaLista').hide();", 200);

				if(numCta != '' && !isNaN(numCta)){
					cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
								if(cuenta!=null){
									$('#tipoCuentaDG').val(cuenta.descripcionTipoCta);
									$('#cuentaAhoIDDG').val(cuenta.cuentaAhoID);
									$('#numClienteDG').val(cuenta.clienteID);
									esTab= "true";
									consultaClientePantallaDevGL('numClienteDG');
									consultaSaldoCtaAhoDevGL('cuentaAhoIDDG',cuenta.clienteID);

								}else{
									mensajeSis("No Existe la Cuenta de Ahorro.");
									$('#cuentaAhoIDDG').focus();
									$('#cuentaAhoIDDG').select();
									inicializarCampos();
								}
						});
				}
			}

			function consultaSaldoCtaAhoDevGL(idControl,numCte) {
				var jqCta  = eval("'#" + idControl + "'");
				var numCta = $(jqCta).val();
				var tipConCampos= 5;
				var CuentaAhoBeanCon = {
					'cuentaAhoID'	:numCta,
					'clienteID'		:numCte
				};
				setTimeout("$('#cajaLista').hide();", 200);

				if(numCta != '' && !isNaN(numCta)){
					cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
								if(cuenta!=null){
									$('#saldoDisponDG').val(cuenta.saldoDispon);
									$('#monedaDG').val(cuenta.descripcionMoneda);
									$('#monedaIDDG').val(cuenta.monedaID);
								}else{
									mensajeSis("No Existe la Cuenta de Ahorro o No Corresponde a ese Cliente.");
									$('#cuentaAhoIDDG').focus();
									$('#cuentaAhoIDDG').select();
								}
						});
				}
			}


			function consultaClientePantallaDevGL(idControl) {//uuuu
				var jqCliente  = eval("'#" + idControl + "'");
				var numCliente = $(jqCliente).val();
				var conCliente =5;
				var rfc = ' ';
				setTimeout("$('#cajaLista').hide();", 200);
				if(numCliente != '' && !isNaN(numCliente)){
					clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
								if(cliente!=null){
									$('#nombreClienteDG').val(cliente.nombreCompleto);
									$('#impTicket').hide();
									$('#impCheque').hide();
									ocultarBtnResumen();
								}else{
									mensajeSis("No Existe el Cliente.");
									$(jqCliente).focus();
								}
						});
					}
			}


			// consulta si ya fue devuelta la  garantia liquida
			 function consultaPagoGarantiaLiquida(idControl){
				 	var jqCredito  = eval("'#" + idControl + "'");
					var numCredito = $(jqCredito).val();
					var conPrincipal =1;
					var CreditoGLCon = {
							'creditoDGL'	:numCredito
						};
					setTimeout("$('#cajaLista').hide();", 200);
					if(numCredito != '' && !isNaN(numCredito)){
						creditoDevGLServicio.consulta(conPrincipal,CreditoGLCon,function(garantiaLiq){
								if(garantiaLiq!=null){
									mensajeSis('Ya se ha Devuelto el Monto de la Garantía Líquida del Crédito.');
									$('#creditoDGL').focus();
									$('#creditoDGL').select();

								}else{
									habilitaEntradasSalidasEfectivo();
								}

						});
					}

			 }


			// fin de consultas para la devolucion de garantia liquida

			// Para la multiplicacion de las cantidades por la denominacion
			function cantidadPorDenominacionMil(idControl) {
				var jqCant  = eval("'#" + idControl + "'");
				var cantidad = $(jqCant).val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(cantidad != '' && !isNaN(cantidad)){
					$('#montoEntraMil').val(parseFloat(cantidad)*parseFloat(mil));
					sumaTotalEntradasEfectivo();
					crearListaBilletesMonedasEntrada();
					crearListaBilletesMonedasSalida();
				}
			}
			function cantidadPorDenominacionQui(idControl) {
				var jqCant  = eval("'#" + idControl + "'");
				var cantidad = $(jqCant).val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(cantidad != '' && !isNaN(cantidad)){
					$('#montoEntraQui').val(parseFloat(cantidad)*parseFloat(quinientos));
					sumaTotalEntradasEfectivo();
					crearListaBilletesMonedasEntrada();
					crearListaBilletesMonedasSalida();
				}
			}
			function cantidadPorDenominacionDos(idControl) {
				var jqCant  = eval("'#" + idControl + "'");
				var cantidad = $(jqCant).val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(cantidad != '' && !isNaN(cantidad)){
					$('#montoEntraDos').val(parseFloat(cantidad)*parseFloat(doscientos));
					sumaTotalEntradasEfectivo();
					crearListaBilletesMonedasEntrada();
					crearListaBilletesMonedasSalida();
				}
			}
			function cantidadPorDenominacionCien(idControl) {
				var jqCant  = eval("'#" + idControl + "'");
				var cantidad = $(jqCant).val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(cantidad != '' && !isNaN(cantidad)){
					$('#montoEntraCien').val(parseFloat(cantidad)*parseFloat(cien));
					sumaTotalEntradasEfectivo();
					crearListaBilletesMonedasEntrada();
					crearListaBilletesMonedasSalida();
				}
			}
			function cantidadPorDenominacionCin(idControl) {
				var jqCant  = eval("'#" + idControl + "'");
				var cantidad = $(jqCant).val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(cantidad != '' && !isNaN(cantidad)){
					$('#montoEntraCin').val(parseFloat(cantidad)*parseFloat(cincuenta));
					sumaTotalEntradasEfectivo();
					crearListaBilletesMonedasEntrada();
					crearListaBilletesMonedasSalida();
				}
			}
			function cantidadPorDenominacionVei(idControl) {
				var jqCant  = eval("'#" + idControl + "'");
				var cantidad = $(jqCant).val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(cantidad != '' && !isNaN(cantidad)){
					$('#montoEntraVei').val(parseFloat(cantidad)*parseFloat(veinte));
					sumaTotalEntradasEfectivo();
					crearListaBilletesMonedasEntrada();
					crearListaBilletesMonedasSalida();
				}
			}
			function cantidadPorDenominacionMon(idControl) {
				var jqCant  = eval("'#" + idControl + "'");
				var cantidad = $(jqCant).val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(cantidad != '' && !isNaN(cantidad)){
					$('#montoEntraMon').val(parseFloat(cantidad)*parseFloat(monedaValor));
					sumaTotalEntradasEfectivo();
					crearListaBilletesMonedasEntrada();
					crearListaBilletesMonedasSalida();
				}
			}

			// Para la multiplicacion de las cantidades por la denominacion
			function cantidadPorDenominacionMilS(idControl) {
				var jqCant  = eval("'#" + idControl + "'");
				var cantidad = $(jqCant).val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(cantidad != '' && !isNaN(cantidad)){
					$('#montoSalMil').val(parseFloat(cantidad)*parseFloat(mil));
					sumaTotalSalidasEfectivo();
					crearListaBilletesMonedasSalida();
					crearListaBilletesMonedasEntrada();
				}
			}
			function cantidadPorDenominacionQuiS(idControl) {
				var jqCant  = eval("'#" + idControl + "'");
				var cantidad = $(jqCant).val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(cantidad != '' && !isNaN(cantidad)){
					$('#montoSalQui').val(parseFloat(cantidad)*parseFloat(quinientos));
					sumaTotalSalidasEfectivo();
					crearListaBilletesMonedasSalida();
					crearListaBilletesMonedasEntrada();
				}
			}
			function cantidadPorDenominacionDosS(idControl) {
				var jqCant  = eval("'#" + idControl + "'");
				var cantidad = $(jqCant).val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(cantidad != '' && !isNaN(cantidad)){
					$('#montoSalDos').val(parseFloat(cantidad)*parseFloat(doscientos));
					sumaTotalSalidasEfectivo();
					crearListaBilletesMonedasSalida();
					crearListaBilletesMonedasEntrada();
				}
			}
			function cantidadPorDenominacionCienS(idControl) {
				var jqCant  = eval("'#" + idControl + "'");
				var cantidad = $(jqCant).val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(cantidad != '' && !isNaN(cantidad)){
					$('#montoSalCien').val(parseFloat(cantidad)*parseFloat(cien));
					sumaTotalSalidasEfectivo();
					crearListaBilletesMonedasSalida();
					crearListaBilletesMonedasEntrada();
				}
			}

			function cantidadPorDenominacionCinS(idControl) {
				var jqCant  = eval("'#" + idControl + "'");
				var cantidad = $(jqCant).val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(cantidad != '' && !isNaN(cantidad)){
					$('#montoSalCin').val(parseFloat(cantidad)*parseFloat(cincuenta));
					sumaTotalSalidasEfectivo();
					crearListaBilletesMonedasSalida();
					crearListaBilletesMonedasEntrada();
				}
			}

			function cantidadPorDenominacionVeiS(idControl) {
				var jqCant  = eval("'#" + idControl + "'");
				var cantidad = $(jqCant).val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(cantidad != '' && !isNaN(cantidad)){
					$('#montoSalVei').val(parseFloat(cantidad)*parseFloat(veinte));
					sumaTotalSalidasEfectivo();
					crearListaBilletesMonedasSalida();
					crearListaBilletesMonedasEntrada();
				}
			}
			function cantidadPorDenominacionMonS(idControl) {
				var jqCant  = eval("'#" + idControl + "'");
				var cantidad = $(jqCant).val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(cantidad != '' && !isNaN(cantidad)){
					$('#montoSalMon').val(parseFloat(cantidad)*parseFloat(monedaValor));
					sumaTotalSalidasEfectivo();
					crearListaBilletesMonedasSalida();
					crearListaBilletesMonedasEntrada();
				}
			}

			//para llevar el total de entradas de efectivo
			function sumaTotalEntradasEfectivo() {

				esTab= true;
				setTimeout("$('#cajaLista').hide();", 200);
				var suma = parseFloat(0);
				$('input[name=montoEntrada]').each(function() {
					jqMontoEntrada = eval("'#" + this.id + "'");
					montoEntrada= $(jqMontoEntrada).asNumber();
					if(montoEntrada != '' && !isNaN(montoEntrada)){
						suma = parseFloat(suma) + parseFloat(montoEntrada);
						$(jqMontoEntrada).formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
					}
					else {
						$(jqMontoEntrada).val(0);
					}
				});

				$('#sumTotalEnt').val(suma);
				$('#sumTotalEnt').formatCurrency({
					positiveFormat: '%n',
					roundToDecimalPlace: 2
				});
			}

			//para llevar el total de entradas de efectivo
			function sumaTotalSalidasEfectivo() {
				esTab= true;
				setTimeout("$('#cajaLista').hide();", 200);
				var suma = parseFloat(0);
				$('input[name=montoSalida]').each(function() {
					jqMontoSalida= eval("'#" + this.id + "'");
					montoSalida= $(jqMontoSalida).asNumber();
					if(montoSalida != '' && !isNaN(montoSalida)){
						suma = parseFloat(suma) + parseFloat(montoSalida);
						$(jqMontoSalida).formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
					}
					else {
						$(jqMontoSalida).val(0);
					}
				});

				$('#sumTotalSal').val(suma);
				$('#sumTotalSal').formatCurrency({
					positiveFormat: '%n',
					roundToDecimalPlace: 2
				});
			}

			//para llevar el total de entradas ttttt
			function totalEntradasSalidasDiferencia(){
				consultarParametrosBean();
				controlQuitaFormatoMoneda('sumTotalSal');
				controlQuitaFormatoMoneda('sumTotalEnt');
				esTab= true;
				setTimeout("$('#cajaLista').hide();", 200);
				var sumaEntradas = parseFloat(0);
				var sumaSalidas = parseFloat(0);
				var diferencia = parseFloat(0);
				var sumaEntradasOperacion = parseFloat(0);
				var sumaSalidasOperacion	= parseFloat(0);

				var sumTotalSal= $('#sumTotalSal').asNumber();
				var sumTotalEnt= $('#sumTotalEnt').asNumber();
				var montoCargar= $('#montoCargar').asNumber();
				var montoAbonar= $('#montoAbonar').asNumber();
				var montoPagar= $('#montoPagar').asNumber();
				var montoGarLiq= $('#montoGarantiaLiq').asNumber();
				var montoApCre= $('#totalDepAR').asNumber();
				var montoDesCre= $('#totalRetirarDC').asNumber();
				var montoPoliza= $('#montoPoliza').asNumber();
				var montDevGarLiq=$('#montoDevGL').asNumber();
				var montoSeguroCobrarC= $('#montoSeguroCobro').asNumber();
				var montoAportacionS= $('#montoAS').asNumber();
				var montDevolucionAS= $('#montoDAS').asNumber();
				var montCobroSegAyuda= $('#montoCobrarSeg').asNumber();
				var montoPagoPolSegAyuda=$('#montoPolizaSegAyudaCobroA').asNumber();
				var montoPagoRemesaOport=$('#montoServicio').asNumber();
				var montoRecepChequeSBC=	$('#montoSBC').asNumber();
				var montoChequeAplicacion =$('#montoSBCAplic').asNumber();
				var montoPrepagoCredito	= $('#montoPagarPre').asNumber();
				var montoPagarServicio	= $('#totalPagar').asNumber();
				var montoRecuperarCartVen = $('#montoRecuperar').asNumber();
				var montoPagarSERVIFUN		= $('#montoEntregarServifun').asNumber();
				var montoPagarApoyoEscolar	= $('#monto').asNumber();
				var montoAjuteSobrante	= $('#montoSobrante').asNumber();
				var montoAjusteFaltante		= $('#montoFaltante').asNumber();
				var montoComisionTarjeta	= $('#totalComisionTD').asNumber();
				var montoRecibirCancelSocio	= $('#totalRecibir').asNumber();
				var montoRecibirGastoAnticipos=$('#montoGastoAnt').asNumber();
				var montoRecibirDevolucionGasto=$('#montoGastoDev').asNumber();
				var montoRecibirHaberesExMenor=$('#totalHaberes').asNumber();
				var montoPagarArrendamiento= $('#montoPagarArrendamiento').asNumber();
				var montoEntradaServiciosEnLinea = $('#totalEntradaPSL').asNumber();
				var montoPagoServiciosEnLinea = $('#totalPagarPSL').asNumber();
				var montoCobAccesorio = $('#totalDepCA').asNumber();
				var montoDepositoActivaCta = $('#montoDepositoActivaCta').asNumber();

				sumaEntradas= parseFloat(sumTotalEnt)+ parseFloat(montoCargar) +parseFloat(montoDesCre)+
							parseFloat(montoPoliza)+montDevGarLiq+parseFloat(montDevolucionAS)+montoPagoPolSegAyuda+
							montoPagoRemesaOport+montoRecepChequeSBC+montoPagarSERVIFUN+montoPagarApoyoEscolar + montoAjusteFaltante+
							montoRecibirCancelSocio+montoRecibirGastoAnticipos+montoRecibirHaberesExMenor+parseFloat(montoEntradaServiciosEnLinea);

				sumaSalidas	= parseFloat(sumTotalSal)+ parseFloat(montoAbonar) + parseFloat(montoPagar)+
								parseFloat(montoGarLiq)+parseFloat(montoApCre)+parseFloat(montoSeguroCobrarC)+
								parseFloat(montoAportacionS)+montCobroSegAyuda+montoChequeAplicacion+
								montoPrepagoCredito+montoPagarServicio+montoRecuperarCartVen+montoAjuteSobrante+montoComisionTarjeta+
								montoRecibirDevolucionGasto+parseFloat(montoPagarArrendamiento)+parseFloat(montoPagoServiciosEnLinea)+montoCobAccesorio+montoDepositoActivaCta;

				sumaEntradasOperacion= parseFloat(montoCargar) +parseFloat(montoDesCre)+
						parseFloat(montoPoliza)+montDevGarLiq+parseFloat(montDevolucionAS)+montoPagoPolSegAyuda+
						montoPagoRemesaOport+montoRecepChequeSBC+montoPagarSERVIFUN+montoPagarApoyoEscolar + montoAjusteFaltante+
						montoRecibirCancelSocio+montoRecibirGastoAnticipos+montoRecibirHaberesExMenor;

				sumaSalidasOperacion	=  parseFloat(montoAbonar) + parseFloat(montoPagar)+
					parseFloat(montoGarLiq)+parseFloat(montoApCre)+parseFloat(montoSeguroCobrarC)+
					parseFloat(montoAportacionS)+montCobroSegAyuda+montoChequeAplicacion+
					montoPrepagoCredito+montoPagarServicio+montoRecuperarCartVen+montoAjuteSobrante+montoComisionTarjeta+
					montoRecibirDevolucionGasto+parseFloat(montoPagarArrendamiento)+montoCobAccesorio+montoDepositoActivaCta;


				if(($('#tipoOperacion').asNumber() == pagoRemesas) || ($('#tipoOperacion').asNumber() == pagoOportunidades )){
					if($('#montoServicio').asNumber() >0){
						if($('#pagoServicioRetiro').attr("checked")== true){
							// no hacemos nada
						}else{
							sumaSalidas = sumaEntradas;
							if(sumaEntradasOperacion > 0 || sumaSalidasOperacion > 0){
								habilitaBoton('graba', 'submit');
								$('#graba').focus();
							}


						}
					}
				}

				if($('#tipoOperacion').asNumber() == recepChequeSBC ){
					if(  ($('#tipoCtaCheque').val() == 'I' && $('#formaCobro1').attr('checked') == true)
							|| ($('#tipoCtaCheque').val() == 'E')){
						sumaSalidas = sumaEntradas;
						if(sumaEntradasOperacion > 0 || sumaSalidasOperacion > 0){
							habilitaBoton('graba', 'submit');
							$('#graba').focus();
						}
					}
				}



				if(sumaEntradas.toFixed(2)>=sumaSalidas.toFixed(2)){
					diferencia = parseFloat(sumaEntradas).toFixed(2)- parseFloat(sumaSalidas).toFixed(2) ;
				}else{
					diferencia = parseFloat(sumaSalidas).toFixed(2)- parseFloat(sumaEntradas).toFixed(2) ;
				}

				$('#totalEntradas').val(sumaEntradas);
				$('#totalSalidas').val(sumaSalidas);
				$('#diferencia').val(diferencia);

				if(diferencia == 0 && ($('#totalEntradas').asNumber() >0 || $('#totalSalidas').asNumber() >0) &&
						(sumaEntradasOperacion > 0 || sumaSalidasOperacion > 0) ){
					if($('#tipoTransaccion').val() ==catTipoTransaccionVen.garantiaLiq){
						if($('#referenciaGL').val()==null || $('#referenciaGL').val()==""){
							deshabilitaBoton('graba', 'submit');
						}
						else{
							if($('#numeroTransaccion').asNumber()>0 ){
			  		  			deshabilitaBoton('graba', 'submit');
			  		  		}else{
								habilitaBoton('graba', 'submit');

							}
						}
					}else{
						if($('#numeroTransaccion').asNumber()>0 ){
		  		  			deshabilitaBoton('graba', 'submit');
		  		  		}else{
							habilitaBoton('graba', 'submit');

		  		  		}
					}
				}else{
					deshabilitaBoton('graba', 'submit');
				}

				if($('#tipoOperacion').asNumber() == OpeCambioefectivo  && diferencia == 0 &&
						($('#totalEntradas').asNumber() >0 || $('#totalSalidas').asNumber() >0) && $('#numeroTransaccion').asNumber()<=0 ){
					habilitaBoton('graba', 'submit');
				}

				if($('#tipoOperacion').asNumber() == pagoServiciosEnLinea) {
					if(diferencia == 0 && ($('#totalEntradas').asNumber() >0 || $('#totalSalidas').asNumber() >0)) {
						habilitaBoton('graba', 'submit');
					}
					else {
						deshabilitaBoton('graba', 'submit');
					}

				}
				// todo : validar que si ya se hizo la transaccion no se habilite el boton

				actualizaFormatosMoneda('formaGenerica');
				$('#numeroTransaccion').val("");
				$('#impTicket').hide();
				$('#impCheque').hide();
				$('#impPoliza').hide();
				ocultarBtnResumen();
			}

			// funcion para inicializar valores de cantidad y Monto para
			// entradas y salidas de efectivo
			function inicializarEntradasSalidasEfectivo() {
				$('#cantEntraMil').val(0);
				$('#cantEntraQui').val(0);
				$('#cantEntraDos').val(0);
				$('#cantEntraCien').val(0);
				$('#cantEntraCin').val(0);
				$('#cantEntraVei').val(0);
				$('#cantEntraMon').val(0);

				$('#cantSalMil').val(0);
				$('#cantSalQui').val(0);
				$('#cantSalDos').val(0);
				$('#cantSalCien').val(0);
				$('#cantSalCin').val(0);
				$('#cantSalVei').val(0);
				$('#cantSalMon').val(0);

				$('#montoEntraMil').val(0);
				$('#montoEntraQui').val(0);
				$('#montoEntraDos').val(0);
				$('#montoEntraCien').val(0);
				$('#montoEntraCin').val(0);
				$('#montoEntraVei').val(0);
				$('#montoEntraMon').val(0);

				$('#montoSalMil').val(0);
				$('#montoSalQui').val(0);
				$('#montoSalDos').val(0);
				$('#montoSalCien').val(0);
				$('#montoSalCin').val(0);
				$('#montoSalVei').val(0);
				$('#montoSalMon').val(0);

				$('#sumTotalSal').val(0);
				$('#sumTotalEnt').val(0);
				$('#totalEntradas').val(0);
				$('#totalSalidas').val(0);
				$('#diferencia').val(0);

				$('#saldoCapVigent').val(0);
				$('#saldoCapAtrasad').val(0);
				$('#saldoCapVencido').val(0);
				$('#saldCapVenNoExi').val(0);
				$('#totalCapital').val(0);
				$('#saldoInterOrdin').val(0);
				$('#saldoInterAtras').val(0);
				$('#saldoInterAtras').val(0);
				$('#saldoInterVenc').val(0);
				$('#saldoInterProvi').val(0);
				$('#saldoIntNoConta').val(0);
				$('#totalInteres').val(0);
				$('#saldoIVAInteres').val(0);
				$('#saldoMoratorios').val(0);
				$('#saldoIVAMorator').val(0);
				$('#saldoComFaltPago').val(0);
				$('#saldoOtrasComis').val(0);
				//COM ADMON
				$('#saldoAdmonComis').val(0);
				$('#saldoIVAAdmonComisi').val(0);
				//FIN COM ADMON
				//SEGUROS
				$('#saldoSeguroCuota').val(0);
				$('#saldoIVASeguroCuota').val(0);
				$('#saldoSeguroCuotaPre').val(0);
				$('#saldoIVASeguroCuotaPre').val(0);
				//FIN SEGUROS
				//COMISION ANUAL
				$('#saldoComAnual').val(0);
				$('#saldoComAnualIVA').val(0);
				$('#saldoComAnualPre').val(0);
				$('#saldoComAnualIVAPre').val(0);
				//FIN COMISION ANUAL
				$('#totalComisi').val(0);
				$('#salIVAComFalPag').val(0);
				$('#saldoIVAComisi').val(0);
				$('#totalIVACom').val(0);
				$('#pagoExigible').val(0);
				$('#adeudoTotal').val(0);

				$('#denoEntraMon').val("Monedas");
				$('#denoSalMon').val("Monedas");
				$('#huellaRequiere').val('');
				$('#requiereFirmante').val('');
				esAgropecuario = 'N';
			}


			// funcion para inicializar valores que se requieren para la
			// generacion del ticket despues de grabar la transaccion  iiiii
			function inicializarCampos(){
				esAgropecuario = 'N';
				$('#creditoID').val("");
				$('#montoPagar').val("");
				$('#monedaDes').val("");
				$('#grupoID').val("");
				$('#cicloID').val("");
				$('#garantiaAdicionalPC').val("0.00");
				$('#gridIntegrantes').html("");
				$('#gridIntegrantes').hide();
				$('#producCreditoID').val("");
				$('#descripcionProd').val("");
				$('#esAhoVoluntario').val("");
				$('#montoAhorroVol').val("");
				$('#fechaProxPago').val("");
				$('#saldoAdmonComis').val("");
				$('#saldoIVAAdmonComisi').val("");
				$('#permiteFiniquito').val("");

				$('#fechaSistemaP').val("");
				$('#montoCargar').val("");
				$('#nombreInstitucion').val("");
				$('#numeroSucursal').val("");
				$('#nombreSucursal').val("");
				$('#numeroCaja').val("");
				$('#nomCajero').val("");
				$('#sumTotalEnt').val("");
				$('#sumTotalSal').val("");
				$('#numClienteCa').val("");
				$('#nombreClienteCa').val("");
				$('#cuentaAhoIDCa').val("");
				$('#referenciaCa').val("");
				$('#tipoCuentaCa').val("");
				$('#numeroTransaccion').val("");

				$('#montoAbonar').val("");
				$('#numClienteAb').val("");
				$('#nombreClienteAb').val("");
				$('#cuentaAhoIDAb').val("");
				$('#referenciaAb').val("");
				$('#tipoCuentaAb').val("");

				$('#montoGarantiaLiq').val("");
				$('#numClienteGL').val("");
				$('#nombreClienteGL').val("");
				$('#cuentaAhoIDGL').val("");
				$('#referenciaGL').val("");
				$('#tipoCuentaGL').val("");
				$('#grupoIDGL').val("");
				$('#grupoDesGL').val("");
				$('#monedaGL').val("");

				$('#adeudoPROFUN').val("");
				$('#adeudoPROFUNPC').val("");
				$('#adeudoPROFUNPREC').val("");
				dwr.util.removeAllOptions('referenciaGL');
				consultaCreditosClientes('');
				//PAGO DE CREDITO
				$('#cobraSeguroCuota').val("N");
				$('#seguroCuota').val("");
				$('#ivaSeguroCuota').val("");

				//PAGO DE ARRENDAMIENTO
				$('#arrendamientoID').val("");
				$('#montoPagarArrendamiento').val("");
				$('#monedaArrendamiento').val("");
				$('#fecProxPagoArrendamiento').val("");
				$('#prodArrendamientoID').val("");
				$('#descriProdArrendamiento').val("");

				//PREPAGO DE CREDITO
				$('#nomCuentaPre').val("");
				$('#saldoCtaPre').val("");
				$('#exigibleAlDiaPre').val("");
				//SEGURO CUOTA
				$('#cobraSeguroCuotaPre').val("N");
				$('#seguroCuotaPre').val("");
				$('#ivaSeguroCuotaPre').val("");
				//FIN SEGURO CUOTA
				//COMISION ANUAL
				$('#saldoComAnualPre').val("");
				$('#saldoComAnualIVAPre').val("");
				//FIN COMISION ANUAL


				// devolucion GL
				$('#creditoDGL').val("");
				$('#productoCreditoDGL').val("");
				$('#desProducCreditoDGL').val("");
				$('#estatusCredDGL').val("");
				$('#montoCreditoDGL').val("");
				$('#saldoDisponDG').val("");
				$('#monedaDG').val("");
				$('#monedaIDDG').val("");
				$('#grupoIDDGL').val("");
				$('#grupoDesDGL').val("");
				$('#cicloIDDGL').val("");
				$('#montoTotalGLD').val("");
				$('#nombreClienteDG').val("");

				//-------comision por apertura--
				$('#creditoIDAR').val("");
				$('#clienteIDAR').val("");
				$('#nombreClienteAR').val("");
				$('#montoCreAR').val("");
				$('#productoCreditoIDAR').val("");
				$('#desProdCreditoAR').val("");
				$('#cuentaAhoIDAR').val("");
				$('#nomCuentaAR').val("");
				$('#monedaIDAR').val("");
				$('#monedaDesAR').val("");
				$('#comisionAR').val("");
				$('#ivaAR').val("");
				$('#grupoDesAR').val("");
				$('#totalDepAR').val("");
				$('#tipoComisionAR').val("");
				$('#formaCobAR').val("");
				$('#grupoIDAR').val("");
				$('#grupoDesAR').val("");
				$('#cicloIDAR').val("");
				$('#montoComisionAR').val("");
				$('#ivaMontoRealAR').val("");
				$('#comisionPendienteAR').val("");
				$('#ivaPendienteAR').val("");
				$('#totalPagadoDepAR').val("");

				$('#creditoIDDC').val("");
				$('#clienteIDDC').val("");
				$('#nombreClienteDC').val("");
				$('#montoCreDC').val("");
				$('#productoCreditoIDDC').val("");
				$('#desProdCreditoDC').val("");
				$('#cuentaAhoIDDC').val("");
				$('#nomCuentaDC').val("");
				$('#monedaIDDC').val("");
				$('#monedaDesDC').val("");
				$('#comisionDC').val("");
				$('#ivaDC').val("");
				$('#tipoComisionDC').val("");
				$('#totalDesembolsoDC').val("");
				$('#saldoDisponDC').val("");
				$('#totalRetirarDC').val("");
				$('#montoPorDesemDC').val("");
				$('#grupoIDDC').val("");
				$('#grupoDesDC').val("");
				$('#cicloIDDC').val("");
				$('#montoPorRetirarActDC').val("");

				$('#montoTotDeudaPC').val("");
				$('#cuentaAhoIDDG').val("");
				$('#tipoCuentaDG').val("");
				$('#numClienteDG').val("");
				$('#nombreClienteDG').val("");
				$('#saldoDisponDG').val("");
				$('#monedaIDDG').val("");
				$('#monedaDG').val("");
				$('#montoDevGL').val("");
				$('#cicloIDGL').val("");
				$('#grupoDes').val("");

				//campos Aplica seguro de Vida
				$('#creditoIDS').val("");
				$('#clienteIDS').val("");
				$('#nombreClienteS').val("");
				$('#montoCreditoS').val("");
				$('#productoCreditoS').val("");
				$('#desProdCreditoS').val("");
				$('#estatusCreditoSeguro').val("");
				$('#diasAtrasoCredito').val("");
				$('#cuentaClienteS').val("");
				$('#descCuentaSeguro').val("");
				$('#monedaS').val("");
				$('#monedaDesS').val("");
				$('#grupoIDS').val("");
				$('#grupoDesS').val("");
				$('#cicloIDS').val("");
				$('#numeroPolizaS').val("");
				$('#estatusSeguro').val("");
				$('#fechaInicioSeguro').val("");
				$('#fechaVencimiento').val("");
				$('#beneficiarioSeguro').val("");
				$('#direccionBeneficiario').val("");
				$('#relacionBeneficiario').val("");
				$('#desRelacionBeneficiario').val("");
				$('#montoPoliza').val("");

				//campos cobro del seguro
				$('#creditoIDSC').val("");
				$('#clienteIDSC').val("");
				$('#nombreClienteSC').val("");
				$('#montoCreditoSC').val("");
				$('#productoCreditoSC').val("");
				$('#desProdCreditoSC').val("");
				$('#estatusCreditoSeguroC').val("");
				$('#cuentaClienteSC').val("");
				$('#descCuentaSeguroC').val("");
				$('#monedaSC').val("");
				$('#monedaDesSC').val("");
				$('#numeroPolizaSC').val("");
				$('#estatusSeguroC').val("");
				$('#fechaInicioSeguroC').val("");
				$('#fechaVencimientoC').val("");
				$('#relacionBeneficiarioC').val("");
				$('#desRelacionBeneficiarioC').val("");
				$('#direccionBeneficiarioC').val("");
				$('#beneficiarioSeguroC').val("");
				$('#montoPolizaC').val("");
				$('#montoPagoSegurVidaC').val("");
				$('#montoPendienteCobro').val("");
				$('#montoSeguroCobro').val("");
				$('#montoPendienteCobro').val("");
				$('#cicloIDSC').val("");
				$('#grupoIDSC').val("");
				$('#grupoDesSC').val("");
				$('#montoSeguroVidaC').val("");

				// transferencia entre cuentas
				$('#cuentaAhoIDT').val("");
				$('#tipoCuentaT').val("");
				$('#numClienteT').val("");
				$('#nombreClienteT').val("");
				$('#saldoDisponT').val("");
				$('#monedaIDT').val("");
				$('#monedaT').val("");
				$('#montoCargarT').val("");
				$('#referenciaT').val("");
				$('#cuentaAhoIDTC').val("");
				$('#tipoCuentaTC').val("");
				$('#numClienteTC').val("");
				$('#nombreClienteTC').val("");
				$('#etiquetaCuentaCargo').val("");
				$('#etiquetaCuentaAbono').val("");
				// aportacion social
				$('#clienteIDAS').val("");
				$('#nombreClienteAS').val("");
				$('#RFCAS').val("");
				$('#tipoPersonaAS').val("");
				$('#montoPagadoAS').val("");
				$('#montoPendientePagoAS').val("");
				$('#montoAS').val("");

				//devolucion de aportacion social
				$('#clienteIDDAS').val("");
				$('#nombreClienteDAS').val("");
				$('#RFCDAS').val("");
				$('#tipoPersonaDAS').val("");
				$('#montoDAS').val("");

				//cobro seguro Ayuda
				$('#clienteIDCSVA').val("");
				$('#nombreClienteCSVA').val("");
				$('#RFCCSVA').val("");
				$('#tipoPersonaCSVA').val("");
				$('#numeroPolizaSVA').val("");
				$('#estatusSeguroVA').val("");
				$('#montoPolizaSegAyudaCobro').val("");
				$('#montoSegAyudaCobro').val("");
				$('#montoCobrarSeg').val("");

				// pago del seguro de ayuda
				$('#clienteIDASVA').val("");
				$('#nombreClienteASVA').val("");
				$('#RFCASVA').val("");
				$('#tipoPersonaASVA').val("");
				$('#numeroPolizaSVAA').val("");
				$('#estatusSeguroVAA').val("");
				$('#fechaInicioSA').val("");
				$('#fechaVencimientoSA').val("");
				$('#montoCobradoSegAyudaA').val("");
				$('#montoPolizaSegAyudaCobroA').val("");
				dwr.util.removeAllOptions('seguroClienteID');

				//pago de remesas y oportunidades
				$('#clienteIDServicio').val("");
				$('#nombreClienteServicio').val("");
				$('#direccionClienteServicio').val("");
				$('#telefonoClienteServicio').val("");

				$('#folioIdentiClienteServicio').val("");
				$('#pagoServicioRetiro').attr("checked",true);
				$('#pagoServicioDeposito').attr("checked",false);
				$('#numeroCuentaServicio').val("");
				$('#referenciaServicio').val("");
				$('#clabeCobroRemesa').val("");
				$('#montoServicio').val("");

				// campos de recepcion de Documentos SBC
				$('#numeroCuentaRec').val("");
				$('#tipoCuentaSBC').val("");
				$('#clienteIDSBC').val("");
				$('#nombreClienteSBC').val("");
				$('#saldoDisponibleSBC').val("");
				$('#saldoBloqueadoSBC').val("");
				$('#bancoEmisorSBC').val("");
				$('#nombreBancoEmisorSBC').val("");
				$('#numeroCuentaEmisorSBC').val("");
				$('#nombreEmisorSBC').val("");
				$('#numeroChequeSBC').val("");
				$('#montoSBC').val("");
				$('#beneficiarioSBC').val("");
				$('#tipoCtaCheque option[value="E"]').attr('selected','true');

				// Aplicacion de Documentos SBC
				$('#numeroCuentaSBC').val("");
				$('#tipoCuentaSBCAplic').val("");
				$('#clienteIDSBCAplic').val("");
				$('#nombreClienteSBCAplic').val("");
				$('#saldoDisponibleSBCAplic').val("");
				$('#saldoBloqueadoSBCAplic').val("");
				dwr.util.removeAllOptions('clientechequeSBCAplic');
				$('#bancoEmisorSBCAplic').val("");
				$('#nombreBancoEmisorSBCAplic').val("");
				$('#numeroCuentaEmisorSBCAplic').val("");
				$('#nombreEmisorSBCAplic').val("");
				$('#numeroChequeSBCAplic').val("");
				$('#montoSBCAplic').val("");
				$('#fechaRecepcionSBC').val("");

				//------- inicio cobro accesorios credito --
				$('#creditoIDCA').val("");
				dwr.util.removeAllOptions('accesorioID');
				dwr.util.addOptions('accesorioID', {'':'SELECCIONAR'});
				$('#clienteIDCA').val("");
				$('#nombreClienteCA').val("");
				$('#montoCreCA').val("");
				$('#productoCreditoIDCA').val("");
				$('#desProdCreditoCA').val("");
				$('#cuentaAhoIDCAc').val("");
				$('#nomCuentaCA').val("");
				$('#monedaIDCAc').val("");
				$('#monedaDesCA').val("");
				$('#tipoComisionCA').val("");
				$('#formaCobCA').val("");
				$('#montoComisionCA').val("");
				$('#ivaMontoRealCA').val("");
				$('#totalPagadoDepCA').val("");
				$('#comisionPendienteCA').val("");
				$('#ivaPendienteCA').val("");
				$('#totalDepCA').val("");
				$('#comisionCA').val("");
				$('#ivaCA').val("");
				$('#grupoIDCA').val("");
				$('#grupoDesCA').val("");
				$('#cicloIDCA').val("");
				//----- termina cobro accesorios credito

				// prepago credito
				$('#creditoIDPre').val("");
				limpiaCamposPrepagoCredito();
				// pago de servicios
				//dwr.util.removeAllOptions('catalogoServID');
				limpiaCamposPagoServicio();
				//Campos de Cartera Castigada
				limpiaCamposRecCarteraCastigada();

				//-- Servifun
				$('#serviFunFolioID').val('');
				limpiacampoServifun();

				//---APOYO ESCOLAR
				$('#clienteIDApoyoEsc').val('');
				limpiaFormaApoyoEscolar(); // pagoApoyoEscolar.js
				//sobrante y faltante
				$('#montoSobrante').val('');
				$('#montoFaltante').val('');
				$('#claveUsuarioAut').val('');
				$('#contraseniaAut').val('');

				//Pago de Servicios en Linea
				limpiaCamposPSL();


				consultarParametrosBean();
				deshabilitaBoton('graba', 'submit');
				$('#impTicket').hide();
				$('#impCheque').hide();
				$('#impPoliza').hide();
				ocultarBtnResumen();
				inicializaCamposTarjeta();
				limpiaDatosClienteCancelSocio();

				//deposito activacion cuenta
				$('#clienteIDdepAct').val('');
				$('#nombreClientedepAct').val('');
				$('#tipoCuentaIDdepAct').val('');
				$('#descTipoCuentaIDdepAct').val('');
			    $('#monedaIDdepAct').val('');
			    $('#descMonedaIDdepAct').val('');
			    $('#montoDepositoActiva').val('');
			    $('#montoDepositoActivaCta').val('');
			    $('#refCuentaTicketdepAct').val('');


			}

			//deshabilitarEntradasSalidasEfectivo	hhhhh
			function soloLecturaEntradasSalidasEfectivo() {
				$('#cantEntraMil').attr('readOnly',true);
				$('#cantEntraQui').attr('readOnly',true);
				$('#cantEntraDos').attr('readOnly',true);
				$('#cantEntraCien').attr('readOnly',true);
				$('#cantEntraCin').attr('readOnly',true);
				$('#cantEntraVei').attr('readOnly',true);
				$('#cantEntraMon').attr('readOnly',true);
				$('#cantSalMil').attr('readOnly',true);
				$('#cantSalQui').attr('readOnly',true);
				$('#cantSalDos').attr('readOnly',true);
				$('#cantSalCien').attr('readOnly',true);
				$('#cantSalCin').attr('readOnly',true);
				$('#cantSalVei').attr('readOnly',true);
				$('#cantSalMon').attr('readOnly',true);
			}
			function habilitaEntradasSalidasEfectivo() {
				$('#cantEntraMil').attr('readOnly',false);
				$('#cantEntraQui').attr('readOnly',false);
				$('#cantEntraDos').attr('readOnly',false);
				$('#cantEntraCien').attr('readOnly',false);
				$('#cantEntraCin').attr('readOnly',false);
				$('#cantEntraVei').attr('readOnly',false);
				$('#cantEntraMon').attr('readOnly',false);
				$('#cantSalMil').attr('readOnly',false);
				$('#cantSalQui').attr('readOnly',false);
				$('#cantSalDos').attr('readOnly',false);
				$('#cantSalCien').attr('readOnly',false);
				$('#cantSalCin').attr('readOnly',false);
				$('#cantSalVei').attr('readOnly',false);
				$('#cantSalMon').attr('readOnly',false);
			}




			//** funciones para el pago de credito***
			function consultaCredito(controlID){
				/***** BLOQUEAR LA PANTALLA HASTA QUE TERMINE DE CONSULTAR ******/
				$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
					$('#contenedorForma').block({
						message: $('#mensaje'),
						css: {border:		'none',
							background:	'none'}
					});
				/***** FIN BLOQUEAR LA PANTALLA HASTA QUE TERMINE DE CONSULTAR ***/
				var numCredito = $('#creditoID').val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(numCredito != '' && !isNaN(numCredito)){
					var creditoBeanCon = {
						'creditoID':$('#creditoID').val(),
		  				'fechaActual':$('#fechaSistema').val()
		  			};
					$('#gridAmortizacion').hide();
					$('#gridMovimientos').hide();
					$('#totalAde').attr('checked',false);
					$('#exigible').attr('checked',true);
		   			creditosServicio.consulta(18,creditoBeanCon,function(credito) {//catTipoConsultaCredito.saldos
		   				if(credito!=null){
		   					listaPersBloqBean = consultaListaPersBloq(credito.clienteID, esCliente, 0, 0);
							consultaSPL = consultaPermiteOperaSPL(credito.clienteID,'LPB',esCliente);

							if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
			   					esTab=true;
								dwr.util.setValues(credito);
								// si la proxima fecha de pago es un valor vacio entonces el boton de adelantar pago no se activa
			   					if(credito.fechaProxPago == '1900-01-01'){
			   						$('#fechaProxPago').val("");
			   					}
								consultaCliente('clienteID');
								muestraCamposTasa(credito.calcInteresID);
								consultaMoneda('monedaID');
								consultaCta('cuentaID');
								$('#grupoID').val(credito.grupoID);
								$('#lblexigibleAlDia').show();
								$('#exigibleAlDia').show();
								$('#lblmontoProyectado').show();
								$('#montoProyectado').show();

								//SEGURO CUOTA
								$('#saldoSeguroCuota').val(credito.montoSeguroCuota);
								$('#saldoIVASeguroCuota').val(credito.iVASeguroCuota);
								$('#cobraSeguroCuota').val(credito.cobraSeguroCuota).selected = true;
								mostrarElementoPorClase('ocultaSeguro',credito.cobraSeguroCuota);
								//FIN SEGURO CUOTA
								//COMISION ANUAL
								$('#saldoComAnual').val(credito.saldoComAnual);
								$('#saldoComAnualIVA').val(credito.saldoComAnualIVA);
								//FIN COMISION ANUAL
								esAgropecuario = 'N';
								if(credito.grupoID > 0 && credito.esAgropecuario!='S'){
									$('#tdGrupoGrupoCredinput').show();
									$('#tdGrupoCicloCredlabel').show();
				   					$('#tdGrupoCicloCredinput').show();
				   					$('#tdGrupoGrupoCredlabel').show();
				   					$('#lblProrrateoPagoCred').show();

				   					$('#exigibleAlDiaG').show();
				   					$('#montoProyectadoG').show();
				   					$('#lblExigibleAlDiaG').show();
				   					$('#lblMontoProyectadoG').show();
				   					$('#prorrateoPagoCred').show();

									$('#cicloID').val(credito.cicloGrupo);
									consultaGrupo(credito.grupoID,'grupoID','grupoDes','cicloID');
									$('#labelPagoExiGrupoPC').show();
									$('#montoTotExigiblePC').show();
									$('#labelPagoExigiblePC').show();
									$('#pagoExigible').show();

									$('#labelTotalAdeGrupalPC').hide();
									$('#montoTotDeudaPC').hide();
									$('#labelTotalAdeudoPC').hide();
									$('#adeudoTotal').hide();


									consultaGrupoTotalExigible();
				   					consultaExigible();
				   					mostrarIntegrantesGrupo(credito.grupoID, 0);
									deshabilitarInputsGLAdi();
									consultaProdCreditoPagoCredito(credito.producCreditoID,'producCreditoID', 'descripcionProd',credito.grupoID,'prorrateoPago');
								}else{
									$('#labelPagoExigiblePC').show();
									$('#pagoExigible').show();

									$('#labelPagoExiGrupoPC').hide();
									$('#montoTotExigiblePC').hide();
									$('#labelTotalAdeGrupalPC').hide();
									$('#montoTotDeudaPC').hide();
									$('#labelTotalAdeudoPC').hide();
									$('#adeudoTotal').hide();
									$('#prorrateoPagoCred').hide();

				   					consultaExigible();
									$('#gridIntegrantes').hide();
									$('#gridIntegrantes').html("");
				   					$('#tdGrupoGrupoCredinput').hide();
				   					$('#tdGrupoGrupoCredlabel').hide();
				   					$('#tdGrupoCicloCredlabel').hide();
				   					$('#tdGrupoCicloCredinput').hide();
				   					$('#lblProrrateoPagoCred').hide();

									$('#grupoID').val("");
									$('#cicloID').val("");
									$('#grupoDes').val("");
									$('#labelPagoExiGrupoPC').hide();
									$('#montoTotExigiblePC').hide();
									$('#prorrateoPagoCred').val('N');

									$('#exigibleAlDiaG').hide();
									$('#montoProyectadoG').hide();
									$('#lblExigibleAlDiaG').hide();
									$('#lblMontoProyectadoG').hide();

									$('#lblUltCuotaPagada').hide();
									$('#ultCuotaPagada').hide();
									$('#lblFechaUltCuotaPagada').hide();
									$('#fechaUltCuotaPagada').hide();
									$('#lblCuotasAtraso').hide();
									$('#cuotasAtraso').hide();
									$('#lblMontoNoCartVencida').hide();
									$('#montoNoCartVencida').hide();

									consultaProdCreditoPagoCredito(credito.producCreditoID,'producCreditoID', 'descripcionProd',credito.grupoID,'prorrateoPago');
								}

								var estatus = credito.estatus;
								validaEstatusCredito(estatus);
								$('#impTicket').hide();
								$('#impCheque').hide();
								ocultarBtnResumen();
			   				}else{
			   					inicializaForma('formaGenerica','creditoID');
			   					consultaDisponibleDenominacion();
			   					mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
			   					$('#creditoID').focus();
			   					$('#creditoID').select();
			   					inicializarCampos();
			   					validarFormaPago();
			   					$('#cuentaChequePago').val('');
			   					$('#tipoChequera').val('');
			   				}
		   				}else{
		   					inicializaForma('formaGenerica','creditoID');
		   					consultaDisponibleDenominacion();
		   					mensajeSis("No Existe el Crédito.");
		   					$('#creditoID').focus();
		   					$('#creditoID').select();
		   					inicializarCampos();
		   					validarFormaPago();
		   					$('#cuentaChequePago').val('');
		   					$('#tipoChequera').val('');
		   				}
					});

				}
				$("#contenedorForma").unblock();
			}

			/*Consulta Para Verificar Si se cobra FOGAFI*/
			function consultaCobroFOGAFI(){

				paramGeneralesServicio.consulta(26,{},{
					async : false,
					callback : function(parametro){
						garFinanciada = parametro.valorParametro;
					}
				});

			}

			//para consultar producto de credito y sugerir ahorro voluntario
			function consultaProdCreditoPagoCredito(valorID,id,desProducto, esGrupal, prorrateoPago) {
				var numProdCre = valorID;
				var conTipoCta=2;
				var ProdCredBeanCon = {
		  			'producCreditoID':numProdCre
				};
				/***** BLOQUEAR LA PANTALLA HASTA QUE TERMINE DE CONSULTAR ******/
				$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
					$('#contenedorForma').block({
						message: $('#mensaje'),
						css: {border:		'none',
							background:	'none'}
					});
				/***** FIN BLOQUEAR LA PANTALLA HASTA QUE TERMINE DE CONSULTAR ***/

				if(numProdCre != '' && !isNaN(numProdCre)){
					productosCreditoServicio.consulta(conTipoCta, ProdCredBeanCon,function(prodCred) {
						if(prodCred!=null){
							$('#'+desProducto).val(prodCred.descripcion);
							$('#esAhoVoluntario').val(prodCred.ahoVoluntario);
							$('#montoAhorroVol').val(prodCred.porAhoVol);
							$('#'+prorrateoPago).val(prodCred.prorrateoPago);
							$('#prorrateoPagoCred').val(prodCred.prorrateoPago);

							if(prodCred.ahoVoluntario == "S"){
								$('#garantiaAdicionalPC').val(prodCred.porAhoVol);
								if(esGrupal > 0){
									$('#sumaPendienteGarAdiInt').val(prodCred.porAhoVol);
								}
							}

							if(esGrupal > 0){
								if(prodCred.prorrateoPago=='S'){
									$('#tipoTransaccion').val(catTipoTransaccionVen.pagoCreditoGrupal);// si permite prorrateo de pago entonces se ejecuta el procedimiento grupal
								}else{
									$('#tipoTransaccion').val(catTipoTransaccionVen.pagoCredito);
								}
							}else{
								$('#tipoTransaccion').val(catTipoTransaccionVen.pagoCredito);
							}
							$('#garantiaAdicionalPC').formatCurrency({
								positiveFormat: '%n',
								roundToDecimalPlace: 2
							});
						}else{
							$('#'+id).focus();
						}
					});
				}
				$("#contenedorForma").unblock();
			}

			function consultaExigible(){
				/***** BLOQUEAR LA PANTALLA HASTA QUE TERMINE DE CONSULTAR ******/
				$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
					$('#contenedorForma').block({
						message: $('#mensaje'),
						css: {border:		'none',
							background:	'none'}
					});
				/***** FIN BLOQUEAR LA PANTALLA HASTA QUE TERMINE DE CONSULTAR ***/
				var numCredito = $('#creditoID').val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(numCredito != '' && !isNaN(numCredito)){
					var Con_PagoCred = 8;
					var creditoBeanCon = {
						'creditoID':$('#creditoID').val(),
		  				'fechaActual':$('#fechaSistema').val()
		  			};
		  			$('#gridAmortizacion').hide();
		  			$('#gridMovimientos').hide();
		  			creditosServicio.consulta(Con_PagoCred,creditoBeanCon,function(credito) {//catTipoConsultaCredito.saldos
		  				if(credito!=null){
						$('#saldoCapVigent').val(credito.saldoCapVigent);
						$('#saldoCapAtrasad').val(credito.saldoCapAtrasad);
						$('#saldoCapVencido').val(credito.saldoCapVencido);
						$('#saldCapVenNoExi').val(credito.saldCapVenNoExi);
						$('#totalCapital').val(credito.totalCapital);
						$('#saldoInterOrdin').val(credito.saldoInterOrdin);
						$('#saldoInterAtras').val(credito.saldoInterAtras);
						$('#saldoInterAtras').val(credito.saldoInterAtras);
						$('#saldoInterVenc').val(credito.saldoInterVenc);
						$('#saldoInterProvi').val(credito.saldoInterProvi);
						$('#saldoIntNoConta').val(credito.saldoIntNoConta);
						$('#totalInteres').val(credito.totalInteres);
						$('#saldoIVAInteres').val(credito.saldoIVAInteres);
						$('#saldoMoratorios').val(credito.saldoMoratorios);
						$('#saldoIVAMorator').val(credito.saldoIVAMorator);
						$('#saldoComFaltPago').val(credito.saldoComFaltPago);
						$('#saldoOtrasComis').val(credito.saldoOtrasComis);
						$('#totalComisi').val(credito.totalComisi);
						$('#salIVAComFalPag').val(credito.salIVAComFalPag);
						$('#saldoIVAComisi').val(credito.saldoIVAComisi);
						//SEGUROS
						$('#saldoSeguroCuota').val(credito.saldoSeguroCuota);
						$('#saldoIVASeguroCuota').val(credito.saldoIVASeguroCuota);
						//FIN SEGUROS
						//COMISION ANUAL
						$('#saldoComAnual').val(credito.saldoComAnual);
						$('#saldoComAnualIVA').val(credito.saldoComAnualIVA);
						//FIN COMISION ANUAL
						$('#totalIVACom').val(credito.totalIVACom);
						$('#pagoExigible').val(credito.pagoExigible);
						$('#saldoAdmonComis').val("0.00");
						$('#saldoIVAAdmonComisi').val("0.00");

						$('#exigibleAlDia').val(credito.totalExigibleDia);
						$('#montoProyectado').val(credito.totalCuotaAdelantada);

						$('#lblCuotasAtraso').hide();
						$('#cuotasAtraso').hide();
						$('#lblMontoNoCartVencida').hide();
						$('#montoNoCartVencida').hide();
						$('#cuotasAtraso').val('');
						$('#montoNoCartVencida').val('');

						if($('#prorrateoPago').val()=='S'){
							$('#ultCuotaPagada').val(credito.ultCuotaPagada);
							$('#fechaUltCuotaPagada').val(credito.fechaUltCuota);

							$('#lblUltCuotaPagada').show();
							$('#ultCuotaPagada').show();
							$('#lblFechaUltCuotaPagada').show();
							$('#fechaUltCuotaPagada').show();

							if($('#estatus').val()=='VIGENTE'){
								$('#lblCuotasAtraso').show();
								$('#cuotasAtraso').show();
								$('#cuotasAtraso').val(credito.cuotasAtraso);
								$('#lblMontoNoCartVencida').show();
								$('#montoNoCartVencida').show();
								if(credito.cuotasAtraso==0 || credito.cuotasAtraso==1){
									$('#montoNoCartVencida').val('0.00');
								}else if(credito.cuotasAtraso>1){
									$('#montoNoCartVencida').val(credito.totalPrimerCuota);
								}
							}
						}else if($('#prorrateoPago').val()=='N'){
							$('#lblUltCuotaPagada').hide();
							$('#ultCuotaPagada').hide();
							$('#lblFechaUltCuotaPagada').hide();
							$('#fechaUltCuotaPagada').hide();
							$('#ultCuotaPagada').val('');
							$('#fechaUltCuotaPagada').val('');
						}

						$('#exigibleAlDia').formatCurrency({
							positiveFormat: '%n',
							negativeFormat: '%n',
							roundToDecimalPlace: 2
						});
						$('#montoProyectado').formatCurrency({
							positiveFormat: '%n',
							negativeFormat: '%n',
							roundToDecimalPlace: 2
						});

						$('#labelPagoExigiblePC').show();
						$('#pagoExigible').show();
						if($('#grupoID').val() > 0 && esAgropecuario!='S'){
							$('#labelPagoExiGrupoPC').show();
							$('#montoTotExigiblePC').show();
						}
						$('#labelTotalAdeGrupalPC').hide();
						$('#montoTotDeudaPC').hide();
						$('#labelTotalAdeudoPC').hide();
						$('#adeudoTotal').hide();
						$('#impTicket').hide();
						$('#impCheque').hide();
						ocultarBtnResumen();
						validaGarantiaAdicional();
		  				}else{
		  					mensajeSis("No Existe.");
		  				}
		  			});
				}
				 $("#contenedorForma").unblock({fadeOut: 0,timeout:0});
			}

			function consultaFiniquitoLiqAnticipada(){
				/***** BLOQUEAR LA PANTALLA HASTA QUE TERMINE DE CONSULTAR ******/
				bloquearPantalla();
				/***** FIN BLOQUEAR LA PANTALLA HASTA QUE TERMINE DE CONSULTAR ***/
				var numCredito = $('#creditoID').val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(numCredito != '' && !isNaN(numCredito) ){
					var Con_PagoCred = 17;
					var creditoBeanCon = {
							'creditoID':$('#creditoID').val(),
							'fechaActual':$('#fechaSistema').val()
							};
					$('#gridAmortizacion').hide();
					$('#gridMovimientos').hide();
					creditosServicio.consulta(Con_PagoCred,creditoBeanCon,{ async: false, callback:function(credito) {//catTipoConsultaCredito.saldos
						desbloquearPantalla();
						if(credito!=null){
							$('#permiteFiniquito').val(credito.permiteFiniquito);
							if(credito.permiteFiniquito == "S"){
								$('#saldoCapVigent').val(credito.saldoCapVigent);
								$('#saldoCapAtrasad').val(credito.saldoCapAtrasad);
								$('#saldoCapVencido').val(credito.saldoCapVencido);
								$('#saldCapVenNoExi').val(credito.saldCapVenNoExi);
								$('#totalCapital').val(credito.totalCapital);
								$('#saldoInterOrdin').val(credito.saldoInterOrdin);
								$('#saldoInterAtras').val(credito.saldoInterAtras);
								$('#saldoInterAtras').val(credito.saldoInterAtras);
								$('#saldoInterVenc').val(credito.saldoInterVenc);
								$('#saldoInterProvi').val(credito.saldoInterProvi);
								$('#saldoIntNoConta').val(credito.saldoIntNoConta);
								$('#totalInteres').val(credito.totalInteres);
								$('#saldoIVAInteres').val(credito.saldoIVAInteres);
								$('#saldoMoratorios').val(credito.saldoMoratorios);
								$('#saldoIVAMorator').val(credito.saldoIVAMorator);
								$('#saldoComFaltPago').val(credito.saldoComFaltPago);
								//SEGUROS
								$('#saldoSeguroCuota').val(credito.saldoSeguroCuota);
								$('#saldoIVASeguroCuota').val(credito.saldoIVASeguroCuota);
								//FIN SEGUROS
								//COMISION ANUAL
								$('#saldoComAnual').val(credito.saldoComAnual);
								$('#saldoComAnualIVA').val(credito.saldoComAnualIVA);
								//FIN COMISION ANUAL
								$('#saldoOtrasComis').val(credito.saldoOtrasComis);
								$('#totalComisi').val(credito.totalComisi);
								$('#salIVAComFalPag').val(credito.salIVAComFalPag);
								$('#saldoIVAComisi').val(credito.saldoIVAComisi);
								$('#totalIVACom').val(credito.totalIVACom);
								$('#adeudoTotal').val(credito.adeudoTotal);

								$('#saldoAdmonComis').val(credito.saldoAdmonComis);
								$('#saldoIVAAdmonComisi').val(credito.saldoIVAAdmonComisi);
								$('#permiteFiniquito').val(credito.permiteFiniquito);
								$('#pagoExigible').val("");

								if($('#grupoID').val() > 0 && esAgropecuario != 'S'){
									$('#labelPagoExiGrupoPC').hide();
									$('#montoTotExigiblePC').hide();
									$('#labelTotalAdeGrupalPC').show();
									$('#montoTotDeudaPC').show();

									$('#exigibleAlDiaG').hide();
				   					$('#montoProyectadoG').hide();
				   					$('#lblExigibleAlDiaG').hide();
				   					$('#lblMontoProyectadoG').hide();

				   					$('#lblexigibleAlDia').hide();
				   					$('#exigibleAlDia').hide();
				   					$('#exigibleAlDia').hide();
				   					$('#montoProyectado').hide();
								}

								$('#labelTotalAdeudoPC').show();
								$('#adeudoTotal').show();

								$('#labelPagoExiGrupoPC').hide();
								$('#montoTotExigiblePC').hide();
								$('#labelPagoExigiblePC').hide();
								$('#pagoExigible').hide();


								$('#exigibleAlDiaG').hide();
			   					$('#montoProyectadoG').hide();
			   					$('#lblExigibleAlDiaG').hide();
			   					$('#lblMontoProyectadoG').hide();

			   					$('#lblexigibleAlDia').hide();
			   					$('#exigibleAlDia').hide();
			   					$('#montoProyectado').hide();
			   					$('#lblmontoProyectado').hide();
							} else{
								$('#totalAde').attr('checked',false);
								$('#exigible').attr('checked',true);
								mensajeSis("El Producto de Crédito no permite Finiquitos o Liquidaciones Anticipadas.");
							}
							validaGarantiaAdicional();
							$('#impTicket').hide();
							$('#impCheque').hide();
							ocultarBtnResumen();
						}else{
							mensajeSis("No Existe.");
						}
					}
					});
				}
			}
			function consultaAdeudoTotal(){
				/***** BLOQUEAR LA PANTALLA HASTA QUE TERMINE DE CONSULTAR ******/
				$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
					$('#contenedorForma').block({
						message: $('#mensaje'),
						css: {border:		'none',
							background:	'none'}
					});
				/***** FIN BLOQUEAR LA PANTALLA HASTA QUE TERMINE DE CONSULTAR ***/
				var numCredito = $('#creditoID').val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(numCredito != '' && !isNaN(numCredito) ){
					var Con_PagoCred = 7;
					var creditoBeanCon = {
							'creditoID':$('#creditoID').val(),
							'fechaActual':$('#fechaSistema').val()
							};
					$('#gridAmortizacion').hide();
					$('#gridMovimientos').hide();
					creditosServicio.consulta(Con_PagoCred,creditoBeanCon,function(credito) {//catTipoConsultaCredito.saldos
						if(credito!=null){
							$('#saldoCapVigent').val(credito.saldoCapVigent);
							$('#saldoCapAtrasad').val(credito.saldoCapAtrasad);
							$('#saldoCapVencido').val(credito.saldoCapVencido);
							$('#saldCapVenNoExi').val(credito.saldCapVenNoExi);
							$('#totalCapital').val(credito.totalCapital);
							$('#saldoInterOrdin').val(credito.saldoInterOrdin);
							$('#saldoInterAtras').val(credito.saldoInterAtras);
							$('#saldoInterAtras').val(credito.saldoInterAtras);
							$('#saldoInterVenc').val(credito.saldoInterVenc);
							$('#saldoInterProvi').val(credito.saldoInterProvi);
							$('#saldoIntNoConta').val(credito.saldoIntNoConta);
							$('#totalInteres').val(credito.totalInteres);
							$('#saldoIVAInteres').val(credito.saldoIVAInteres);
							$('#saldoMoratorios').val(credito.saldoMoratorios);
							$('#saldoIVAMorator').val(credito.saldoIVAMorator);
							$('#saldoComFaltPago').val(credito.saldoComFaltPago);
							$('#saldoOtrasComis').val(credito.saldoOtrasComis);
							//SEGUROS
							$('#saldoSeguroCuota').val(credito.saldoSeguroCuota);
							$('#saldoIVASeguroCuota').val(credito.saldoIVASeguroCuota);
							//FIN SEGUROS
							//COMISION ANUAL
							$('#saldoComAnual').val(credito.saldoComAnual);
							$('#saldoComAnualIVA').val(credito.saldoComAnualIVA);
							//FIN COMISION ANUAL
							$('#totalComisi').val(credito.totalComisi);
							$('#salIVAComFalPag').val(credito.salIVAComFalPag);
							$('#saldoIVAComisi').val(credito.saldoIVAComisi);
							$('#totalIVACom').val(credito.totalIVACom);
							$('#adeudoTotal').val(credito.adeudoTotal);
							$('#saldoAdmonComis').val("0.00");
							$('#saldoIVAAdmonComisi').val("0.00");
							$('#pagoExigible').val('');

							$('#labelTotalAdeGrupalPC').show();
							$('#montoTotDeudaPC').show();
							$('#labelTotalAdeudoPC').show();
							$('#adeudoTotal').show();

							$('#labelPagoExiGrupoPC').hide();
							$('#montoTotExigiblePC').hide();
							$('#labelPagoExigiblePC').hide();
							$('#pagoExigible').hide();
							$('#impTicket').hide();
							$('#impCheque').hide();
							ocultarBtnResumen();
							if($('#grupoID').val() > 0 && esAgropecuario!='S'){

								if($('#montoPagar').asNumber()>credito.adeudoTotal){
									mostrarIntegrantesGrupo($('#grupoID').val(),$('#montoPagar').asNumber()-credito.adeudoTotal); // para mostrar integrantes del grupo
									habilitarInputsGLAdi();
								}else{
									mostrarIntegrantesGrupo($('#grupoID').val(),0.00); // para mostrar integrantes del grupo
									deshabilitarInputsGLAdi();
									limpiarCamposMontoGLAdiInt();
								}
							}
						}else{
							mensajeSis("No Existe.");
						}
					});
				}
				$("#contenedorForma").unblock();
			}

			function consultaCliente(idControl) {
				var jqCliente = eval("'#" + idControl + "'");
				var numCliente = $(jqCliente).val();
				var tipConPagoCred = 8;
				setTimeout("$('#cajaLista').hide();", 200);
				if(numCliente != '' && !isNaN(numCliente) ){
					clienteServicio.consulta(tipConPagoCred,numCliente,function(cliente) {
						if(cliente!=null){
							$('#clienteID').val(cliente.numero);
							$('#nombreCliente').val(cliente.nombreCompleto);
							$('#pagaIVA').val(cliente.pagaIVA);
							$('#impTicket').hide();
							$('#impCheque').hide();
							ocultarBtnResumen();
							consultaMontoAdeudoPROFUN(idControl);
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
							$('#impTicket').hide();
							$('#impCheque').hide();
							ocultarBtnResumen();
						}else{
							mensajeSis("No Existe el Tipo de Moneda.");
							$('#monedaDes').val('');
							$(jqMoneda).focus();
						}
					});
				}
			}

			function validaEstatusCredito(var_estatus) {
				var estatusInactivo 	="I";
				var estatusAutorizado 	="A";
				var estatusVigente		="V";
				var estatusPagado		="P";
				var estatusCancelada 	="C";
				var estatusVencido		="B";
				var estatusCastigado 	="K";
				var estatusSuspendido	="S";

				if(var_estatus == estatusInactivo){
					$('#estatus').val('INACTIVO');
					creditoPagado = "N";
				}
				if(var_estatus == estatusAutorizado){
					$('#estatus').val('AUTORIZADO');
					creditoPagado = "N";
				}
				if(var_estatus == estatusVigente){
					$('#estatus').val('VIGENTE');
					creditoPagado = "N";
				}
				if(var_estatus == estatusPagado){
					$('#estatus').val('PAGADO');
					deshabilitaBoton('graba', 'submit');
					creditoPagado = "S";
				}
				if(var_estatus == estatusCancelada){
					$('#estatus').val('CANCELADO');
					creditoPagado = "N";
				}
				if(var_estatus == estatusVencido){
					$('#estatus').val('VENCIDO');
					creditoPagado = "N";
				}
				if(var_estatus == estatusCastigado){
					$('#estatus').val('CASTIGADO');
					creditoPagado = "N";
				}
				if(var_estatus == estatusSuspendido){
					$('#estatus').val('SUSPENDIDO');
					creditoPagado = "N";
				}
			}
			//se usa para pago de credito
			function consultaCta(idControl) {
				var jqnumCta  = eval("'#" + idControl + "'");
				var numCta = $(jqnumCta).val();
		        var conCta = 3;
		        var estatusActivo = 'A';
		        var CuentaAhoBeanCon = {
		        		'cuentaAhoID':numCta,
		        		'clienteID':$('#clienteID').val()
		        };
		        setTimeout("$('#cajaLista').hide();", 200);

		        if(numCta != '' && !isNaN(numCta)){
		        	cuentasAhoServicio.consultaCuentasAho(conCta, CuentaAhoBeanCon,function(cuenta) {
		        		if(cuenta!=null){
		        			$('#nomCuenta').val(cuenta.tipoCuentaID);
		            			consultaTipoCta('nomCuenta');
		            			consultaSaldoCta('cuentaID');
		        			if(cuenta.estatus != estatusActivo){
		        				mensajeSis('La Cuenta Cargo no se Encuentra Activa.');
		        				$('#creditoID').focus();
		        			}
		        		}else{
		        			mensajeSis("No Existe la Cuenta de Ahorro.");
		        		}
		        	});
		        }
			}

			function consultaTipoCta(idControl) {
				var jqTipoCta = eval("'#" + idControl + "'");
				var numTipoCta = $(jqTipoCta).val();
				var conTipoCta=2;
				var TipoCuentaBeanCon = {
		  			'tipoCuentaID':numTipoCta
				};

				setTimeout("$('#cajaLista').hide();", 200);
				if(numTipoCta != '' && !isNaN(numTipoCta)){
					tiposCuentaServicio.consulta(conTipoCta, TipoCuentaBeanCon,function(tipoCuenta) {
						if(tipoCuenta!=null){
							$('#nomCuenta').val(tipoCuenta.descripcion);
						}else{
							$(jqTipoCta).focus();
						}
					});
				}
			}

			function consultaSaldoCta(idControl) {
				var jqnumCta  = eval("'#" + idControl + "'");
				var numCta = $(jqnumCta).val();
		        var conCta = 5;
		        var CuentaAhoBeanCon = {
		        		'cuentaAhoID':numCta,
		        		'clienteID':$('#clienteID').val()
		        };
		        setTimeout("$('#cajaLista').hide();", 200);

		        if(numCta != '' && !isNaN(numCta)){
		        	cuentasAhoServicio.consultaCuentasAho(conCta, CuentaAhoBeanCon,function(cuenta) {
		        		if(cuenta!=null){
		        			$('#saldoCta').val(cuenta.saldoDispon);
		        		}else{
		        			mensajeSis("No Existe la Cuenta de Ahorro.");
		        		}
		        	});
		        }
			}

			// Consulta de grupos Deuda Total
			function consultaGrupoDeudaTotalFiniquito() {

				var numGrupo = $('#grupoID').val();
				var tipConDeudaTotal= 10;
				var grupoBean = {
					'grupoID'	:numGrupo,
					'cicloActual':$('#cicloID').val()
				};
				setTimeout("$('#cajaLista').hide();", 200);

				if(numGrupo != '' && !isNaN(numGrupo) ){

					gruposCreditoServicio.consulta(tipConDeudaTotal, grupoBean,{ async: false, callback:function(grupoDeudaTotal) {

						if(grupoDeudaTotal!=null){

							$('#montoTotDeudaPC').val(grupoDeudaTotal.montoTotDeuda);
							$('#montoTotDeudaPC').formatCurrency({
								positiveFormat: '%n',
								roundToDecimalPlace: 2
							});
							$('#impTicket').hide();
							$('#impCheque').hide();
							ocultarBtnResumen();
							if($('#montoPagar').asNumber()>grupoDeudaTotal.montoTotDeuda){

								mostrarIntegrantesGrupoFiniquito($('#grupoID').val(),$('#montoPagar').asNumber()-grupoDeudaTotal.montoTotDeuda); // para mostrar integrantes del grupo

								habilitarInputsGLAdi();
								validaGarantiaAdicional();
							}else{

								mostrarIntegrantesGrupoFiniquito($('#grupoID').val(),0.00); // para mostrar integrantes del grupo

								validaGarantiaAdicional();

								deshabilitarInputsGLAdi();

								limpiarCamposMontoGLAdiInt();
							}
						}
					}
					});
				}
			}

			// Consulta de grupos Total Exigible
			function consultaGrupoTotalExigible() {
				var numGrupo = $('#grupoID').val();
				var tipConTotalExigible= 2;
				var grupoBean = {
					'grupoID'	:numGrupo,
					'cicloActual':$('#cicloID').val()
				};
				setTimeout("$('#cajaLista').hide();", 200);

				if(numGrupo != '' && !isNaN(numGrupo)){
					gruposCreditoServicio.consulta(tipConTotalExigible, grupoBean,function(grupoDeudaTotalExi) {
						if(grupoDeudaTotalExi!=null){
							$('#montoTotExigiblePC').val(grupoDeudaTotalExi.montoTotDeuda);
							$('#montoProyectadoG').val(grupoDeudaTotalExi.totalCuotaAdelantada);
							$('#exigibleAlDiaG').val(grupoDeudaTotalExi.totalExigibleDia);

							$('#montoTotExigiblePC').formatCurrency({
								positiveFormat: '%n',
								roundToDecimalPlace: 2
							});
							$('#montoProyectadoG').formatCurrency({
								positiveFormat: '%n',
								negativeFormat: '%n',
								roundToDecimalPlace: 2
							});
							$('#exigibleAlDiaG').formatCurrency({
								positiveFormat: '%n',
								negativeFormat: '%n',
								roundToDecimalPlace: 2
							});
							validaGarantiaAdicional();
						}
					});
				}
			}

			// --------------PREPAGO DEL CREDITO  ------------------------
			function consultaCreditoPrepago(controlID){
				var numCredito = $('#creditoIDPre').val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(numCredito != '' && !isNaN(numCredito)){
					var creditoBeanCon = {
						'creditoID':$('#creditoIDPre').val(),
		  				'fechaActual':$('#fechaSistema').val()
		  			};

		   			creditosServicio.consulta(18,creditoBeanCon,{async: false, callback:function(credito) { //catTipoConsultaCredito.saldos
		   				if(credito!=null){
		   					listaPersBloqBean = consultaListaPersBloq(credito.clienteID, esCliente, 0, 0);
							consultaSPL = consultaPermiteOperaSPL(credito.clienteID,'LPB',esCliente);

							if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
								$('#clienteIDPre').val(credito.clienteID);
								$('#grupoIDPre').val(credito.grupoID);
								$('#producCreditoIDPre').val(credito.producCreditoID);
								$('#cuentaIDPre').val(credito.cuentaID);
								$('#monedaIDPre').val(credito.monedaID);
								$('#diasFaltaPagoPre').val(credito.diasFaltaPago);
								$('#fechaProxPagoPre').val(credito.fechaProxPago);
								$('#cicloIDPre').val(credito.cicloGrupo);
								$('#tipoPrepago').val(credito.tipoPrepago);
								//SEGUROS
								$('#cobraSeguroCuotaPre').val(credito.cobraSeguroCuota).selected = true;
								mostrarElementoPorClase('ocultaSeguro',credito.cobraSeguroCuota);
								consultaMontoAdeudoPROFUN('clienteIDPre');

								if(credito.fechaProxPago == '1900-01-01'){
			   						$('#fechaProxPagoPre').val("");
			   					}

								if(credito.grupoID > 0 && credito.esAgropecuario!='S'){
									$('#cicloIDPRe').val(credito.cicloGrupo);
									$('#tdGrupoCicloCredlabelPre').show();
				   					$('#tdGrupoCicloCredinputPre').show();
				   					$('#tdGrupoGrupoCredinputPre').show();
				   					$('#tdGrupoGrupoCredlabelPre').show();
				   					$('#montoTotGrupalDeudaPrepagoPre').show();
				   					$('#lblmontoTotGrupalDeudaPrepagoPre').show();

				   					$('#lblExigibleAlDiaGPre').show();
				   					$('#exigibleAlDiaGPre').show();

				   					$('#tdlblProrrateoPagoPre').show();
				   					$('#tdProrrateoPagoPre').show();
									consultaGrupo(credito.grupoID,'grupoIDPre','grupoDesPre','cicloIDPre');
									consultaGrupoDeudaTotalPrepago();		//consulta el total del adeudo Grupal
									consultaGrupoTotalExigiblePrepago();	// consulta el exigible al dia y proyectdo(Grupal)
									$('#tipoTransaccion').val(catTipoTransaccionVen.prepagoCreditoGrupal);

								}else{
									$('#tdGrupoCicloCredlabelPre').hide();
				   					$('#tdGrupoCicloCredinputPre').hide();
				   					$('#tdGrupoGrupoCredinputPre').hide();
				   					$('#tdGrupoGrupoCredlabelPre').hide();
				   					$('#montoTotGrupalDeudaPrepagoPre').hide();
				   					$('#lblmontoTotGrupalDeudaPrepagoPre').hide();

				   					$('#lblExigibleAlDiaGPre').hide();
				   					$('#exigibleAlDiaGPre').hide();
				   					/*$('#lblMontoProyectadoGPre').hide();
				   					$('#montoProyectadoGPre').hide();*/

				   					$('#tdlblProrrateoPagoPre').hide();
				   					$('#tdProrrateoPagoPre').hide();

				   					$('#tipoTransaccion').val(catTipoTransaccionVen.prepagoCredito);

								}
								consultaProdCreditoPrepago(credito.producCreditoID,'producCreditoIDPre', 'descripcionProdPre',credito.grupoID,'prorrateoPagoPrepago');
								consultaClientePrepago('clienteIDPre');
			   					consultaMonedaSeguro(credito.monedaID, 'monedaIDPre','monedaDesPre');
			   					consultaNumeroTipoCuentaPrepago('cuentaIDPre');
			   					validaEstatusCreditoSeguro(credito.estatus, 'estatusPre');

			   					if($('#estatusPre').val() != 'PAGADO'){
			   						var tipoPrep = $('#tipoPrepago').val();

				   					if(tipoPrep != 'P'){
				   						consultaAdeudoTotalPrepago(); //consulat el total del adeudo individual
				   						$('#labelCuotaProyec').hide();
				   						$('#cuotasProyectadasPrepago').hide();
				   					}else{
				   						consultaCuotas();
				   						$('#labelCuotaProyec').show();
				   						$('#cuotasProyectadasPrepago').show();
										$('#cuotasProyectadasPrepago').focus();
				   					}
			   					}else{
			   						mensajeSis('No se Puede realizar un Prepago, Crédito Pagado.');
			   						$('#creditoIDPre').focus();
			   					}


							//	consultaExigiblePrepago();	// consulta el total exigible al dia y proyectado (individual)
								$('#impTicket').hide();
								$('#impCheque').hide();
			   				}else{
			   					inicializaForma('formaGenerica','creditoIDPre');
			   					consultaDisponibleDenominacion();
			   					mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
			   					$('#creditoIDPre').focus();
			   					$('#creditoIDPre').select();
			   					inicializarCampos();
			   					validarFormaPago();
			   					$('#cuentaChequePago').val('');
			   					$('#tipoChequera').val('');
			   				}
		   				}else{
		   					inicializaForma('formaGenerica','creditoIDPre');
		   					consultaDisponibleDenominacion();
		   					mensajeSis("No Existe el Crédito.");
		   					$('#creditoIDPre').focus();
		   					$('#creditoIDPre').select();
		   					inicializarCampos();
		   					validarFormaPago();
		   					$('#cuentaChequePago').val('');
		   					$('#tipoChequera').val('');
		   				}
					}});
				}
			}

			function consultaProdCreditoPrepago(valorID,id,desProducto, esGrupal, prorrateoPago) {
				var numProdCre = valorID;
				var conTipoCta=2;
				var ProdCredBeanCon = {
		  			'producCreditoID':numProdCre
				};
				habilitaControl('montoPagarPre');
				setTimeout("$('#cajaLista').hide();", 200);
				if(numProdCre != '' && !isNaN(numProdCre)){
					productosCreditoServicio.consulta(conTipoCta, ProdCredBeanCon,function(prodCred) {
						if(prodCred!=null){
							$('#'+desProducto).val(prodCred.descripcion);
							$('#'+prorrateoPago).val(prodCred.prorrateoPago);
							if(esGrupal > 0){
								if(prodCred.prorrateoPago == "S"){
									$('#tipoTransaccion').val(catTipoTransaccionVen.prepagoCreditoGrupal);
								}else{
									$('#tipoTransaccion').val(catTipoTransaccionVen.prepagoCredito);
								}
							}else{
								$('#tipoTransaccion').val(catTipoTransaccionVen.prepagoCredito);
							}
							productoPermitePrepago =prodCred.permitePrepago;

							if(prodCred.permitePrepago != 'S'){
								mensajeSis('El Producto de Crédito No Permite Prepagos.');
								$('#prepagos').hide();
								deshabilitaBoton('graba', 'submit');
								deshabilitaControl('montoPagarPre');
							}else{$('#prepagos').show();}
						}else{
							$('#'+id).focus();
							$('#prepagos').show();

						}
					});
				}
			}

			function consultaExigiblePrepago(muestraAlert){
				var numCredito = $('#creditoIDPre').val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(numCredito != '' && !isNaN(numCredito)){
					var Con_PagoCred = 8;
					var creditoBeanCon = {
						'creditoID':$('#creditoIDPre').val(),
		  				'fechaActual':$('#fechaSistema').val()
		  			};

		  			creditosServicio.consulta(Con_PagoCred,creditoBeanCon,{ async: false, callback:function(credito) {
		  				if(credito!=null){
						$('#exigibleAlDiaPre').val(credito.totalExigibleDia);
						$('#montoProyectadoPre').val(credito.totalCuotaAdelantada);

						$('#exigibleAlDiaPre').formatCurrency({
							positiveFormat: '%n',
							negativeFormat: '%n',
							roundToDecimalPlace: 2
						});
						$('#montoProyectadoPre').formatCurrency({
							positiveFormat: '%n',
							negativeFormat: '%n',
							roundToDecimalPlace: 2
						});


						if(productoPermitePrepago !='S'){
							deshabilitaControl('montoPagarPre');
						}else{
							 if($('#exigibleAlDiaPre').asNumber() > 0.0 ){
								 	if (muestraAlert == true ){
								 		mensajeSis("Antes de Realizar un Prepago, por Favor realice el Pago Exigible al Día.");
								 			$('#creditoIDPre').focus();
								 			$('#creditoIDPre').select();
								 			inicializarCampos();
								 	}
									deshabilitaControl('montoPagarPre');
								}else{
									habilitaControl('montoPagarPre');
								}
						}
		  				}else{
		  					mensajeSis("No Existe.");
		  				}
		  			}});
				}
			}

			function consultaAdeudoTotalPrepago(){
				var numCredito = $('#creditoIDPre').val();
				var muestraAlert =false;
				setTimeout("$('#cajaLista').hide();", 200);
				if(numCredito != '' && !isNaN(numCredito) ){
					var Con_PagoCred = 7;
					var creditoBeanCon = {
							'creditoID':$('#creditoIDPre').val(),
							'fechaActual':$('#fechaSistema').val()
							};
					creditosServicio.consulta(Con_PagoCred,creditoBeanCon,{ async: false, callback:function(credito) {//catTipoConsultaCredito.saldos
						if(credito!=null){
							$('#saldoCapVigentPre').val(credito.saldoCapVigent);
							$('#saldoCapAtrasadPre').val(credito.saldoCapAtrasad);
							$('#saldoCapVencidoPre').val(credito.saldoCapVencido);
							$('#saldCapVenNoExiPre').val(credito.saldCapVenNoExi);
							$('#totalCapitalPre').val(credito.totalCapital);
							$('#saldoInterOrdinPre').val(credito.saldoInterOrdin);
							$('#saldoInterAtrasPre').val(credito.saldoInterAtras);
							$('#saldoInterAtrasPre').val(credito.saldoInterAtras);
							$('#saldoInterVencPre').val(credito.saldoInterVenc);
							$('#saldoInterProviPre').val(credito.saldoInterProvi);
							$('#saldoIntNoContaPre').val(credito.saldoIntNoConta);
							$('#totalInteresPre').val(credito.totalInteres);
							$('#saldoIVAInteresPre').val(credito.saldoIVAInteres);
							$('#saldoMoratoriosPre').val(credito.saldoMoratorios);
							$('#saldoIVAMoratorPre').val(credito.saldoIVAMorator);
							$('#saldoComFaltPagoPre').val(credito.saldoComFaltPago);
							$('#saldoOtrasComisPre').val(credito.saldoOtrasComis);

							//FIN SEGUROS
							$('#totalComisiPre').val(credito.totalComisi);
							$('#salIVAComFalPagPre').val(credito.salIVAComFalPag);
							$('#saldoIVAComisiPre').val(credito.saldoIVAComisi);
							$('#totalIVAComPre').val(credito.totalIVACom);
							$('#adeudoTotalPrepagoPre').val(credito.adeudoTotal);
							$('#saldoAdmonComisPre').val("0.00");
							$('#saldoIVAAdmonComisiPre').val("0.00");
							//SEGUROS
							$('#saldoSeguroCuotaPre').val("0.00");
							$('#saldoIVASeguroCuotaPre').val("0.00");
							//COMISION ANUAL
							$('#saldoComAnualPre').val("0.00");
							$('#saldoComAnualIVAPre').val("0.00");
							//FIN COMISION ANUAL
							$('#pagoExigiblePre').val('');

							if($('#saldoCapAtrasadPre').asNumber() > 0.0 || $('#saldoCapVencidoPre').asNumber() > 0.0){
								mensajeSis("Antes de Realizar un Prepago, por Favor Realice el Pago  Exigible en Atraso.");
								deshabilitaControl('montoPagarPre');
								consultaExigiblePrepago(muestraAlert);
								$('#creditoIDPre').focus();
								inicializarCampos();

							}else{
								muestraAlert = true;
								consultaExigiblePrepago(muestraAlert);
								habilitaControl('montoPagarPre');
							}

							$('#impTicket').hide();
							$('#impCheque').hide();
							ocultarBtnResumen();
						}else{
							mensajeSis("No Existe.");
						}
					}});
				}
			}


			function consultaProyeccionCredPrepago(){
				// Funcion de Proyeccion de Cuotas Completas.
				var numCredito = $('#creditoIDPre').val();
				var muestraAlert =false;
				setTimeout("$('#cajaLista').hide();", 200);
				if(numCredito != '' && !isNaN(numCredito) ){
					var Con_PagoCred = 1;
					var creditoBeanCon = {
							'creditoID':$('#creditoIDPre').val(),
							'cuotasProyectadas':$('#cuotasProyectadasPrepago').val()
							};
					creditosServicio.proyeccionCuotas(Con_PagoCred,creditoBeanCon, { async: false, callback:function(credito) {//catTipoConsultaCredito.saldos
						if(credito!=null){
							$('#saldoCapVigentPre').val(credito.saldoCapVigent);
							$('#saldoCapAtrasadPre').val(credito.saldoCapAtrasad);
							$('#saldoCapVencidoPre').val(credito.saldoCapVencido);
							$('#saldCapVenNoExiPre').val(credito.saldCapVenNoExi);
							$('#totalCapitalPre').val(credito.totalCapital);
							$('#saldoInterOrdinPre').val(credito.saldoInterOrdin);
							$('#saldoInterAtrasPre').val(credito.saldoInterAtras);
							$('#saldoInterAtrasPre').val(credito.saldoInterAtras);
							$('#saldoInterVencPre').val(credito.saldoInterVenc);
							$('#saldoInterProviPre').val(credito.saldoInterProvi);
							$('#saldoIntNoContaPre').val(credito.saldoIntNoConta);
							$('#totalInteresPre').val(credito.totalInteres);
							$('#saldoIVAInteresPre').val(credito.saldoIVAInteres);
							$('#saldoMoratoriosPre').val(credito.saldoMoratorios);
							$('#saldoIVAMoratorPre').val(credito.saldoIVAMorator);
							$('#saldoComFaltPagoPre').val(credito.saldoComFaltPago);
							$('#saldoOtrasComisPre').val(credito.saldoOtrasComis);

							//FIN SEGUROS
							$('#totalComisiPre').val(credito.totalComisi);
							$('#salIVAComFalPagPre').val(credito.salIVAComFalPag);
							$('#saldoIVAComisiPre').val(credito.saldoIVAComisi);
							$('#totalIVAComPre').val(credito.totalIVACom);
							$('#adeudoTotalPrepagoPre').val(credito.adeudoTotal);
							$('#saldoAdmonComisPre').val("0.00");
							$('#saldoIVAAdmonComisiPre').val("0.00");
							//SEGUROS
							$('#saldoSeguroCuotaPre').val("0.00");
							$('#saldoIVASeguroCuotaPre').val("0.00");
							//COMISION ANUAL
							$('#saldoComAnualPre').val("0.00");
							$('#saldoComAnualIVAPre').val("0.00");
							//FIN COMISION ANUAL
							$('#pagoExigiblePre').val('');

							if($('#saldoCapAtrasadPre').asNumber() > 0.0 || $('#saldoCapVencidoPre').asNumber() > 0.0){
								mensajeSis("Antes de Realizar un Prepago, por Favor Realice el Pago  Exigible en Atraso.");
								deshabilitaControl('montoPagarPre');
								consultaExigiblePrepago(muestraAlert);
								$('#creditoIDPre').focus();
								inicializarCampos();

							}else{
								muestraAlert = true;
								consultaExigiblePrepago(muestraAlert);
								habilitaControl('montoPagarPre');
							}

							$('#impTicket').hide();
							$('#impCheque').hide();
							ocultarBtnResumen();
						}else{
							mensajeSis("No Existe.");
						}
					}});
				}
			}

			function consultaGrupoDeudaTotalPrepago() {
				var numGrupo = $('#grupoIDPre').val();
				var tipConDeudaTotal= 3;
				var grupoBean = {
					'grupoID'	:numGrupo,
					'cicloActual':$('#cicloIDPre').val()
				};
				setTimeout("$('#cajaLista').hide();", 200);

				if(numGrupo != '' && !isNaN(numGrupo) ){
					gruposCreditoServicio.consulta(tipConDeudaTotal, grupoBean,function(grupoDeudaTotal) {
						if(grupoDeudaTotal!=null){
							$('#montoTotGrupalDeudaPrepagoPre').val(grupoDeudaTotal.montoTotDeuda);
							$('#grupoDesPre').val(grupoDeudaTotal.nombreGrupo);
							$('#impTicket').hide();
							$('#impCheque').hide();
							ocultarBtnResumen();
						}
					});
				}
			}

			function consultaGrupoTotalExigiblePrepago() {
				var numGrupo = $('#grupoIDPre').val();
				var tipConTotalExigible= 2;
				var grupoBean = {
					'grupoID'	:numGrupo,
					'cicloActual':$('#cicloIDPre').val()
				};
				setTimeout("$('#cajaLista').hide();", 200);

				if(numGrupo != '' && !isNaN(numGrupo)){
					gruposCreditoServicio.consulta(tipConTotalExigible, grupoBean,function(grupoDeudaTotalExi) {
						if(grupoDeudaTotalExi!=null){
							$('#montoProyectadoGPre').val(grupoDeudaTotalExi.totalCuotaAdelantada);
							$('#exigibleAlDiaGPre').val(grupoDeudaTotalExi.totalExigibleDia);

							$('#montoProyectadoGPre').formatCurrency({
								positiveFormat: '%n',
								negativeFormat: '%n',
								roundToDecimalPlace: 2
							});

							$('#exigibleAlDiaGPre').formatCurrency({
								positiveFormat: '%n',
								negativeFormat: '%n',
								roundToDecimalPlace: 2
							});
						}
					});
				}
			}

			function consultaClientePrepago(idControl) {
				var jqCliente = eval("'#" + idControl + "'");
				var numCliente = $(jqCliente).val();
				var tipConPagoCred = 8;
				setTimeout("$('#cajaLista').hide();", 200);
				if(numCliente != '' && !isNaN(numCliente) ){
					clienteServicio.consulta(tipConPagoCred,numCliente,function(cliente) {
						if(cliente!=null){
							$('#clienteIDPre').val(cliente.numero);
							$('#nombreClientePre').val(cliente.nombreCompleto);
							$('#pagaIVAPre').val(cliente.pagaIVA);
							$('#impTicket').hide();
							$('#impCheque').hide();
							ocultarBtnResumen();
						}else{
							mensajeSis("No Existe el Cliente.");
							$('#clienteIDPre').focus();
							$('#clienteIDPre').select();
						}
					});
				}
			}
			function consultaNumeroTipoCuentaPrepago(idControl) {
				var jqnumCta  = eval("'#" + idControl + "'");
				var numCta = $(jqnumCta).val();
		        var conCta = 3;
		        var CuentaAhoBeanCon = {
		        		'cuentaAhoID':numCta,
		        		'clienteID':$('#clienteIDPre').val()
		        };
		        setTimeout("$('#cajaLista').hide();", 200);

		        if(numCta != '' && !isNaN(numCta)){
		        	cuentasAhoServicio.consultaCuentasAho(conCta, CuentaAhoBeanCon,{ async: false, callback:function(cuenta) {
		        		if(cuenta!=null){
		        			$('#nomCuentaPre').val(cuenta.tipoCuentaID);
		                    consultaTipoCtaPrepago('nomCuentaPre');
		                    consultaSaldoCtaPrepago('cuentaIDPre');
		        		}else{
		        			mensajeSis("No Existe la Cuenta de Ahorro.");
		        		}
		        	}});
		        }
			}
			function consultaTipoCtaPrepago(idControl) {
				var jqTipoCta = eval("'#" + idControl + "'");
				var numTipoCta = $(jqTipoCta).val();
				var conTipoCta=2;
				var TipoCuentaBeanCon = {
		  			'tipoCuentaID':numTipoCta
				};
				setTimeout("$('#cajaLista').hide();", 200);
				if(numTipoCta != '' && !isNaN(numTipoCta)){
					tiposCuentaServicio.consulta(conTipoCta, TipoCuentaBeanCon,function(tipoCuenta) {
						if(tipoCuenta!=null){
							$('#nomCuentaPre').val(tipoCuenta.descripcion);
						}else{
							$(jqTipoCta).focus();
						}
					});
				}
			}

			function consultaSaldoCtaPrepago(idControl) {
				var jqnumCta  = eval("'#" + idControl + "'");
				var numCta = $(jqnumCta).val();
		        var conCta = 5;
		        var CuentaAhoBeanCon = {
		        		'cuentaAhoID':numCta,
		        		'clienteID':$('#clienteIDPre').val()
		        };
		        setTimeout("$('#cajaLista').hide();", 200);

		        if(numCta != '' && !isNaN(numCta)){
		        	cuentasAhoServicio.consultaCuentasAho(conCta, CuentaAhoBeanCon,{ async: false, callback:function(cuenta) {
		        		if(cuenta!=null){
		        			$('#saldoCtaPre').val(cuenta.saldoDispon);
		        		}else{
		        			mensajeSis("No Existe la Cuenta de Ahorro.");
		        		}
		        	}});
		        }
			}

		// llll
			function limpiaCamposPrepagoCredito(){
				$('#clienteIDPre').val('');
				$('#clienteIDPre').val('');
				$('#nombreClientePre').val('');
				$('#nomCuentaPre').val('');
				$('#pagaIVAPre option[value=""]').attr('selected','true');
				$('#cuentaIDPre').val('');
				$('#nomCuentaPre').val('');
				$('#saldoCtaPre').val('0.0');
				$('#monedaIDPre').val('');
				$('#monedaDesPre').val('');
				$('#estatusPre').val('');
				$('#montoPagarPre').val('');
				$('#diasFaltaPagoPre').val('');
				$('#cicloIDPre').val('');
				$('#grupoIDPre').val('');
				$('#grupoDesPre').val('');
				$('#fechaProxPagoPre').val('');
				$('#producCreditoIDPre').val('');
				$('#descripcionProdPre').val('');
				// saldo
				$('#adeudoTotalPrepagoPre').val('0.0');
				$('#exigibleAlDiaPre').val('0.0');
				$('#montoProyectadoPre').val('0.0');

				$('#montoTotGrupalDeudaPrepagoPre').val('0.0');
				$('#exigibleAlDiaGPre').val('0.0');
				$('#montoProyectadoGPre').val('0.0');
				//capital
				$('#saldoCapVigentPre').val('0.0');
				$('#saldoCapAtrasadPre').val('0.0');
				$('#saldoCapVencidoPre').val('0.0');
				$('#saldCapVenNoExiPre').val('0.0');
				$('#totalCapitalPre').val('0.0');
				//interes
				$('#saldoInterOrdinPre').val('0.0');
				$('#saldoInterAtrasPre').val('0.0');
				$('#saldoInterVencPre').val('0.0');
				$('#saldoInterProviPre').val('0.0');
				$('#saldoIntNoContaPre').val('0.0');
				$('#totalInteresPre').val('0.0');
				// iva interes
				$('#saldoIVAInteresPre').val('0.0');
				$('#saldoMoratoriosPre').val('0.0');
				$('#saldoIVAMoratorPre').val('0.0');
				// comisiones
				$('#saldoComFaltPagoPre').val('0.0');
				$('#saldoOtrasComisPre').val('0.0');
				$('#saldoAdmonComisPre').val('0.0');
				$('#totalComisiPre').val('0.0');
				//SEGUROS
				$('#saldoSeguroCuotaPre').val('0.0');
				$('#saldoIVASeguroCuotaPre').val('0.0');
				//COMISION ANUAL
				$('#saldoComAnualPre').val('0.0');
				$('#saldoComAnualIVAPre').val('0.0');
				//FIN SEGUROS
				// iva comisiones
				$('#salIVAComFalPagPre').val('0.0');
				$('#saldoIVAComisiPre').val('0.0');
				$('#saldoIVAAdmonComisiPre').val('0.0');
				$('#totalIVAComPre').val('0.0');

				$('#prorrateoPagoPrepago').val('');
				$('#adeudoPROFUNPREC').val('');
				$('#cuotasProyectadasPrepago').val('');
				$('#cuotasProyectadasPrepago').hide();

			}


			//** funciones para el pago de comision por apertura  ***
			function consultaCreditoComAp(controlID){
				var numCredito = $('#creditoIDAR').val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(numCredito != '' && !isNaN(numCredito) ){
					var creditoBeanCon = {
						'creditoID':$('#creditoIDAR').val(),
		  				'fechaActual':$('#fechaSistema').val()
		  			};

		   			creditosServicio.consulta(11,creditoBeanCon,function(credito) {//catTipoConsultaCredito.saldos
		   				if(credito!=null){
		   					listaPersBloqBean = consultaListaPersBloq(credito.clienteID, esCliente, 0, 0);
							consultaSPL = consultaPermiteOperaSPL(credito.clienteID,'LPB',esCliente);

							if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
			   					esTab=true;
								$('#creditoIDAR').val(credito.creditoID);
								$('#clienteIDAR').val(credito.clienteID);
								$('#productoCreditoIDAR').val(credito.producCreditoID);
								$('#cuentaAhoIDAR').val(credito.cuentaID);
								$('#montoCreAR').val(credito.montoCredito);
								$('#monedaIDAR').val(credito.monedaID);

								$('#montoComisionAR').val(credito.montoComision); 		//monto real comision
								$('#ivaMontoRealAR').val(credito.IVAComApertura);				//iva del monto real
								$('#totalPagadoDepAR').val(credito.comAperPagado);		//comision ya pagada

								var comisionPendiente=$('#montoComisionAR').asNumber()- $('#totalPagadoDepAR').asNumber();
								$('#comisionPendienteAR').val(comisionPendiente);				// comisionPendiente de pago
								var IvaPendiente = comisionPendiente * (ivaSucursal);
								$('#ivaPendienteAR').val(IvaPendiente);					// iva de la comision Pendiente de Pago
								var totalSugerenciaPagar= $('#comisionPendienteAR').asNumber()+ $('#ivaPendienteAR').asNumber();
								$('#totalDepAR').val(totalSugerenciaPagar);				// sugerencia a pagar
								$('#comisionAR').val(comisionPendiente);				//comision a pagar
								$('#ivaAR').val(IvaPendiente);							//iva a pagar

								$('#totalDepAR').focus();
								$('#totalDepAR').select();
								$('#grupoIDAR').val(credito.grupoID);
								$('#formaCobAR').val(credito.forCobroComAper);

								if(credito.forCobroComAper == 'A'){
									$('#tipoComisionAR').val("ANTICIPADO");
								}else{

									mensajeSis("La Forma de Cobro de la Comisión por Apertura  del Crédito no es Anticipado.");
									soloLecturaEntradasSalidasEfectivo();
									deshabilitaBoton('graba', 'submit');
									$('#totalDepAR').attr('readOnly',true);

									if(credito.forCobroComAper == 'D'){
										$('#tipoComisionAR').val("DEDUCCIÓN");
									}else{
										if(credito.forCobroComAper == 'F'){
											$('#tipoComisionAR').val('FINANCIAMIENTO');
										}
									}
								}
								if(credito.grupoID > 0){
									$('#cicloIDAR').val(credito.cicloGrupo);
									consultaGrupo(credito.grupoID,'grupoIDAR','grupoDesAR','cicloIDAR');
									$('#tdGrupoARlabel').show();
									$('#tdGrupoARinput').show();
									$('#tdGrupoCicloARlabel').show();
									$('#tdGrupoCicloARinput').show();
								}else {
									$('#grupoDesAR').val("");
									$('#tdGrupoARlabel').hide();
									$('#tdGrupoARinput').hide();
									$('#tdGrupoCicloARlabel').hide();
									$('#tdGrupoCicloARinput').hide();
								}

								consultaClienteComApDes(credito.clienteID, 'clienteIDAR','nombreClienteAR');
								consultaMonedaComAp(credito.monedaID);
								consultaCtaComAp(credito.cuentaID,credito.clienteID);
								consultaProdCred(credito.producCreditoID);
								$('#tipoTransaccion').val(catTipoTransaccionVen.comisionApertura);
								$('#numeroTransaccion').val("");
								agregaFormatoMoneda('formaGenerica');
			   				}else{
			   					inicializaForma('formaGenerica','creditoIDAR');
			   					consultaDisponibleDenominacion();
								mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
								$('#creditoIDAR').focus();
			   					$('#creditoIDAR').select();
			   					inicializarCampos();
			   					validarFormaPago();
			   					$('#cuentaChequePago').val('');
			   					$('#tipoChequera').val('');
			   				}
		   				}else{
		   					inicializaForma('formaGenerica','creditoIDAR');
		   					consultaDisponibleDenominacion();
		   					mensajeSis("No Existe el Crédito.");
		   					$('#creditoIDAR').focus();
		   					$('#creditoIDAR').select();
		   					inicializarCampos();
		   					validarFormaPago();
		   					$('#cuentaChequePago').val('');
		   					$('#tipoChequera').val('');
		   				}
					});
				}
			}


			// Consulta de grupos
			function consultaGrupo(valID, id, desGrupo,idCiclo) {
				var jqDesGrupo  = eval("'#" + desGrupo + "'");
				var jqIDGrupo  = eval("'#" + id + "'");
				var numGrupo = valID;
				var tipConGrupo= 1;
				var grupoBean = {
					'grupoID'	:numGrupo,
					'cicloActual':$('#cicloID').val()
				};
				setTimeout("$('#cajaLista').hide();", 200);

				if(numGrupo != '' && !isNaN(numGrupo) ){
					gruposCreditoServicio.consulta(tipConGrupo, grupoBean,function(grupo) {
						if(grupo!=null){
							$(jqIDGrupo).val(grupo.grupoID);

							$(jqDesGrupo).val(grupo.nombreGrupo);

						}
					});
				}
			}

			// funcion para validar finiquito
			function validaFiniquito(event){
				var adeudo;
		    	var montoPag =$('#montoPagar').asNumber();
		    	if($('#grupoID').val() > 0){
					if($('#prorrateoPago').val()=="S"){ // si permite prorrateo de pago entonces se ejecuta el procedimiento grupal
						adeudo = $('#montoTotDeudaPC').asNumber();
						$('#tipoTransaccion').val(catTipoTransaccionVen.pagoCreditoGrupal);
					}else{
						adeudo = $('#adeudoTotal').asNumber();
						$('#tipoTransaccion').val(catTipoTransaccionVen.pagoCredito);
					}
				}else{
					adeudo = $('#adeudoTotal').asNumber();
					$('#tipoTransaccion').val(catTipoTransaccionVen.pagoCredito);
				}
		    	var uno = 1;
				if($('#totalAde').is(':checked') ){
					if($('#permiteFiniquito').val()== "S"){
						$('#finiquito').val('S');
						if($('#grupoID').val()>0){
							if( montoPag < adeudo ){
								agregaFormatoControles('formaGenerica');
								mensajeSis('En Liquidación Anticipada el Monto a Pagar debe ser el Monto Adeudado.');
								procedePago = 2;
							}else{
					    		if(montoPag < uno && $('#finiquito').val() != 'S'){
						    		agregaFormatoControles('formaGenerica');
						    		mensajeSis('El Monto Debe Ser Mayor a Cero.');
						    		procedePago = 2;
						    	}else{
						    		procedePago = 1;
						    	}
					    		if($('#prorrateoPago').val()!="S"){
									if( montoPag > adeudo ){
										mensajeSis('En una Liquidación Anticipada el Monto a Pagar debe ser el Monto Adeudado: $'+$('#adeudoTotal').val());
										procedePago = 2;
									}
								}
							}
						}  else{
							if( montoPag < adeudo ){
								agregaFormatoControles('formaGenerica');
								mensajeSis('En Liquidación Anticipada el Monto a Pagar debe ser el Monto Adeudado.');
								procedePago = 2;
							}else{
								if(montoPag < uno && $('#finiquito').val() != 'S'){

						    		agregaFormatoControles('formaGenerica');
						    		mensajeSis('El Monto Debe ser Mayor a Cero.');
						    		procedePago = 2;
						    	}else{
						    		procedePago = 1;
						    	}
							}
						}
					}else{
			    		procedePago = 2;
			    		mensajeSis("El Producto de Crédito No permite Finiquitos o Liquidaciones Anticipadas.");
					}

				}else{
					$('#finiquito').val('N');
					 if(montoPag > adeudo ){
						procedePago = 1;
			    	}else{
			    		if(montoPag < uno && $('#finiquito').val() != 'S'){
				    		agregaFormatoControles('formaGenerica');
				    		mensajeSis('El Monto Debe ser Mayor a Cero.');
				    		procedePago = 2;
				    	}else{
				    		procedePago = 1;
				    	}
				    }
					if($('#grupoID').val() > 0){
						if($('#prorrateoPago').val()=="S"){ // si permite prorrateo de pago entonces se ejecuta el procedimiento grupal
							$('#tipoTransaccion').val(catTipoTransaccionVen.pagoCreditoGrupal);
						}else{
							$('#tipoTransaccion').val(catTipoTransaccionVen.pagoCredito);
						}
					}else{
						$('#tipoTransaccion').val(catTipoTransaccionVen.pagoCredito);
					}
				}
				return procedePago;
			}
			// CC
			// Usado en: Com apertura o desembolso, cobro del seguro de Vida, Recuperacion de Cartera Vencida
			function consultaClienteComApDes(idControl, clienteID, nombreCliente) {
				var numCliente = idControl;
				var jqnumCte  = eval("'#" + clienteID + "'");
				var jqnomCte  = eval("'#" + nombreCliente + "'");

				var tipConPagoCred = 8;
				setTimeout("$('#cajaLista').hide();", 200);
				if(numCliente != '' && !isNaN(numCliente) ){
					clienteServicio.consulta(tipConPagoCred,numCliente,function(cliente) {
						if(cliente!=null){
							$(jqnumCte).val(cliente.numero);
							$(jqnomCte).val(cliente.nombreCompleto);
							$('#impTicket').hide();
							$('#impCheque').hide();
							ocultarBtnResumen();
						}else{
							mensajeSis("No Existe el Cliente.");
							$(jqnomCte).focus();
							$(jqnomCte).select();
						}
					});
				}
			}

			function consultaMonedaComAp(idControl) {
				var numMoneda = idControl;
				var conMoneda=2;
				setTimeout("$('#cajaLista').hide();", 200);
				if(numMoneda != '' && !isNaN(numMoneda)){
					monedasServicio.consultaMoneda(conMoneda,numMoneda,function(moneda) {
						if(moneda!=null){
							$('#monedaDesAR').val(moneda.descripcion);
							$('#impTicket').hide();
							$('#impCheque').hide();
							ocultarBtnResumen();
						}else{
							mensajeSis("No Existe el Tipo de Moneda.");
							$('#monedaDesAR').val('');
							$(jqMoneda).focus();
						}
					});
				}
			}

			function consultaCtaComAp(idControl, clienteID) {
				var numCta =idControl;
		        var conCta = 3;
		        var CuentaAhoBeanCon = {
		        		'cuentaAhoID':numCta,
		        		'clienteID':clienteID
		        };
		        setTimeout("$('#cajaLista').hide();", 200);

		        if(numCta != '' && !isNaN(numCta)){
		        	cuentasAhoServicio.consultaCuentasAho(conCta, CuentaAhoBeanCon,function(cuenta) {
		        		if(cuenta!=null){
		        			consultaTipoCtaComAp(cuenta.tipoCuentaID);
		        			$('#impTicket').hide();
		        			$('#impCheque').hide();
		        			ocultarBtnResumen();
		        		}else{
		        			mensajeSis("No Existe la Cuenta de Ahorro.");
		        		}
		        	});
		        }
			}

			function consultaTipoCtaComAp(idControl) {
				var numTipoCta = idControl;
				var conTipoCta=2;
				var TipoCuentaBeanCon = {
		  			'tipoCuentaID':numTipoCta
				};
				setTimeout("$('#cajaLista').hide();", 200);
				if(numTipoCta != '' && !isNaN(numTipoCta)){
					tiposCuentaServicio.consulta(conTipoCta, TipoCuentaBeanCon,function(tipoCuenta) {
						if(tipoCuenta!=null){
							$('#nomCuentaAR').val(tipoCuenta.descripcion);
							$('#impTicket').hide();
							$('#impCheque').hide();
							ocultarBtnResumen();
						}else{
							$('#cuentaAhoIDAR').focus();
						}
					});
				}
			}

			function consultaProdCred(idControl) {
				var numProdCre = idControl;
				var conTipoCta=2;
				var ProdCredBeanCon = {
		  			'producCreditoID':numProdCre
				};
				setTimeout("$('#cajaLista').hide();", 200);
				if(numProdCre != '' && !isNaN(numProdCre)){
					productosCreditoServicio.consulta(conTipoCta, ProdCredBeanCon,function(prodCred) {
						if(prodCred!=null){
							$('#desProdCreditoAR').val(prodCred.descripcion);
							$('#impTicket').hide();
							$('#impCheque').hide();
						}else{
							$('#creditoIDAR').focus();
						}
					});
				}
			}

			//** funciones para el DESEMBOLSO DE CREDITO***
			function consultaCreditoDesCre(controlID){
				var numCredito = $('#creditoIDDC').asNumber();
					var creditoBeanCon = {
						'creditoID':$('#creditoIDDC').val(),
		  				'fechaActual':$('#fechaSistema').val()
		  			};
				setTimeout("$('#cajaLista').hide();", 200);
				if(numCredito > 0){

					creditosServicio.consulta(11,creditoBeanCon,function(credito) {//catTipoConsultaCredito.saldos
		   				if(credito!=null){
		   					esTab=true;
							$('#creditoIDDC').val(credito.creditoID);
							$('#clienteIDDC').val(credito.clienteID);

							var cliente = $('#clienteIDDC').asNumber();
							if(cliente>0){
								listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, 0, credito.creditoID);
								consultaSPL = consultaPermiteOperaSPL(cliente,'LPB',esCliente);

								if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
									expedienteBean = consultaExpedienteCliente($('#clienteIDDC').val());
									if(expedienteBean.tiempo<=1){
										if (alertaCte(cliente) != 999) {
										$('#productoCreditoIDDC').val(credito.producCreditoID);
										$('#cuentaAhoIDDC').val(credito.cuentaID);
										$('#montoCreDC').val(credito.montoCredito);
										$('#monedaIDDC').val(credito.monedaID);
										$('#comisionDC').val(credito.montoComision);
										$('#ivaDC').val(credito.IVAComApertura);
										$('#totalDC').val(credito.totalComAper);
										$('#montoPorDesemDC').val(credito.montoPorDesemb);
										$('#totalDesembolsoDC').val(credito.montoDesemb);
										$('#totalRetirarDC').val(credito.montoPorDesemb);
										if(credito.forCobroComAper == 'A'){
											$('#tipoComisionDC').val("ANTICIPADO");
										}else{
											if(credito.forCobroComAper == 'D'){
												$('#tipoComisionDC').val("DEDUCCIÓN");
											}else{
												if(credito.forCobroComAper == 'F'){
													$('#tipoComisionDC').val('FINANCIAMIENTO');
												}
											}
										}
										$('#impTicket').hide();
										$('#impCheque').hide();
										ocultarBtnResumen();
										$('#grupoIDDC').val(credito.grupoID);

										if(credito.grupoID>0){
											$('#cicloIDDC').val(credito.cicloGrupo);
											consultaGrupo(credito.grupoID, 'grupoIDDC', 'grupoDesDC', 'cicloIDDC');
											$('#tdGrupoDClabel').show();
											$('#tdGrupoDCinput').show();
											$('#tdGrupoCicloDClabel').show();
											$('#tdGrupoCicloDCinput').show();

										}else {
											$('#grupoDesDC').val("");
											$('#tdGrupoDClabel').hide();
											$('#tdGrupoDCinput').hide();
											$('#tdGrupoCicloDClabel').hide();
											$('#tdGrupoCicloDCinput').hide();
										}
										if(credito.tipoDispersion != Con_Efectivo){
											mensajeSis("El Tipo de Dispersión del Crédito No es en Efectivo");
											inicializarCampos();
											$('#creditoIDDC').focus();
										}else{
											consultaCtaDesem(credito.cuentaID);
											consultaClienteComApDes(credito.clienteID, 'clienteIDDC','nombreClienteDC');
											consultaMonedaDesem(credito.monedaID);
											consultaProdCredDesem(credito.producCreditoID);
											consultaCtaDesem('cuentaAhoIDDC');
											consultaSaldoCtaDesem('cuentaAhoIDDC', 'saldoDisponDC','totalRetirarDC', credito.montoPorDesemb);
											agregaFormatoMoneda('formaGenerica');
											$('#tipoTransaccion').val(catTipoTransaccionVen.desembolsoCredito);
										}
									}
									} else {
					   					inicializaForma('formaGenerica','creditoIDDC');
										mensajeSis('Es necesario Actualizar el Expediente del '+$('#socioClienteAlert').val()+' para Continuar.');
					   					consultaDisponibleDenominacion();
					   					$('#creditoIDDC').focus();
					   					$('#creditoIDDC').select();
					   					inicializarCampos();
					   					validarFormaPago();
					   					$('#cuentaChequePago').val('');
					   					$('#tipoChequera').val('');
									}
								} else {
				   					inicializaForma('formaGenerica','creditoIDDC');
									mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
				   					consultaDisponibleDenominacion();
				   					$('#creditoIDDC').focus();
				   					$('#creditoIDDC').select();
				   					inicializarCampos();
				   					validarFormaPago();
				   					$('#cuentaChequePago').val('');
				   					$('#tipoChequera').val('');
								}
							}
		   				}else{
		   					inicializaForma('formaGenerica','creditoIDDC');
		   					mensajeSis("El Número de Crédito No Existe.");
		   					consultaDisponibleDenominacion();
		   					$('#creditoIDDC').focus();
		   					$('#creditoIDDC').select();
		   					inicializarCampos();
		   					validarFormaPago();
		   					$('#cuentaChequePago').val('');
		   					$('#tipoChequera').val('');
		   				}
					});
				}

			}
			// CONSULTA DE CUENTA PARA EL DESEMBOLSO
			function consultaCtaDesem(idControl) {
				var jqnumCta  = eval("'#" + idControl + "'");
				var numCta = $(jqnumCta).val();
		        var conCta = 3;
		        var CuentaAhoBeanCon = {
		        		'cuentaAhoID':numCta,
		        		'clienteID':$('#clienteIDDC').val()
		        };
		        setTimeout("$('#cajaLista').hide();", 200);

		        if(numCta != '' && !isNaN(numCta)){
		        	cuentasAhoServicio.consultaCuentasAho(conCta, CuentaAhoBeanCon,function(cuenta) {
		        		if(cuenta!=null){
		        			$('#nomCuentaDC').val(cuenta.tipoCuentaID);
		        			consultaTipoCtaDesem('nomCuentaDC');
		        			$('#impTicket').hide();
		        			$('#impCheque').hide();
		        			ocultarBtnResumen();
		        		}else{
		        			mensajeSis("No Existe la Cuenta de Ahorro.");
		        		}
		        	});
		        }
			}

			// CONSULTA DE TIPO DE CUENTA PARA EL DESEMBOLSO
			function consultaTipoCtaDesem(idControl) {
				var jqTipoCta = eval("'#" + idControl + "'");
				var numTipoCta = $(jqTipoCta).val();
				var conTipoCta=2;
				var TipoCuentaBeanCon = {
		  			'tipoCuentaID':numTipoCta
				};
				setTimeout("$('#cajaLista').hide();", 200);
				if(numTipoCta != '' && !isNaN(numTipoCta)){
					tiposCuentaServicio.consulta(conTipoCta, TipoCuentaBeanCon,function(tipoCuenta) {
						if(tipoCuenta!=null){
							$('#nomCuentaDC').val(tipoCuenta.descripcion);
							$('#impTicket').hide();
							$('#impCheque').hide();
							ocultarBtnResumen();
						}else{
							$(jqTipoCta).focus();
						}
					});
				}
			}

			// consulta de producto de credito para el desembolso
			function consultaProdCredDesem(idControl) {
				var numProdCre = idControl;
				var conTipoCta=2;
				var ProdCredBeanCon = {
		  			'producCreditoID':numProdCre
				};
				setTimeout("$('#cajaLista').hide();", 200);
				if(numProdCre != '' && !isNaN(numProdCre)){
					productosCreditoServicio.consulta(conTipoCta, ProdCredBeanCon,function(prodCred) {
						if(prodCred!=null){
							$('#desProdCreditoDC').val(prodCred.descripcion);
							$('#impTicket').hide();
							$('#impCheque').hide();
							ocultarBtnResumen();
						}else{
							$('#creditoIDDC').focus();
						}
					});
				}
			}

			// consulta de la moneda para el desembolso
			function consultaMonedaDesem(idControl) {
				var numMoneda = idControl;
				var conMoneda=2;
				setTimeout("$('#cajaLista').hide();", 200);
				if(numMoneda != '' && !isNaN(numMoneda)){
					monedasServicio.consultaMoneda(conMoneda,numMoneda,function(moneda) {
						if(moneda!=null){
							$('#monedaDesDC').val(moneda.descripcion);
						}else{
							mensajeSis("No Existe el Tipo de Moneda.");
							$('#monedaDesDC').val('');
							$('#creditoIDDC').focus();
						}
					});
				}
			}

			// valida el saldo disponible para el desembolso
			function consultaSaldoCtaDesem(idControl, idsaldo,totalDesID, totalDes) {
				var jqnumCta  = eval("'#" + idControl + "'");
				var jqsalCta  = eval("'#" + idsaldo + "'");
				var jqtotalDes  = eval("'#" + totalDesID + "'");
				var numCta = $(jqnumCta).val();
		        var conCta = 5;
		        var CuentaAhoBeanCon = {
		        		'cuentaAhoID':numCta,
		        		'clienteID':$('#clienteIDDC').val()
		        };
		        setTimeout("$('#cajaLista').hide();", 200);

		        if(numCta != '' && !isNaN(numCta)){
		        	cuentasAhoServicio.consultaCuentasAho(conCta, CuentaAhoBeanCon,function(cuenta) {
		        		if(cuenta!=null){
		        			$('#impTicket').hide();
		        			$('#impCheque').hide();
		        			ocultarBtnResumen();
		        			$(jqsalCta).val(cuenta.saldoDispon);
		        			$('#saldoAhoCre').val(cuenta.saldo);
		        			if (totalDes<=$(jqsalCta).asNumber() ){
		        				$(jqsalCta).val(cuenta.saldoDispon);
		        			}else{
		        				$(jqsalCta).val(cuenta.saldoDispon);
		        				$(jqtotalDes).val(cuenta.saldoDispon);
		        			}
		        		}else{
		        			mensajeSis("No Existe la Cuenta de Ahorro.");
		        		}
		        	});
		        }
			}

			// funcion para validar si el cliente ya se llevo el monto que se le
			// desembolso del credito
			function validaMontoDesembolso(){
				if($('#montoPorDesemDC').asNumber()>0 ){
					if(($('#totalRetirarDC').asNumber() <= $('#montoPorDesemDC').asNumber())){
						totalEntradasSalidasDiferencia();
						procedePago =1;
					}else{
						deshabilitaBoton('graba', 'submit');
						mensajeSis("El Monto Indicado es Mayor al Monto Pendiente de Desembolso.");
						$('#totalRetirarDC').val('0.00');
						$('#totalRetirarDC').focus();
						procedePago =2;
					}
				}else{
					deshabilitaBoton('graba', 'submit');
					mensajeSis("El Monto del Crédito ya fue Retirado.");
					$('#totalRetirarDC').val("0.00");
					procedePago =2;
				}
				return procedePago;
			}
			// fin de metodos para desembolso***


			function crearListaBilletesMonedasEntrada(){
				var estaHabilitadoGrabar=false;
				//Deshabilitar el botón de grabar hasta que este completa la lista
				if(!$("#graba").is(":disabled")){
					estaHabilitadoGrabar=true;
					deshabilitaBoton('graba','submit');
				}
				$('#billetesMonedasEntrada').val("");
				$('#billetesMonedasEntrada').val($('#billetesMonedasEntrada').val()+
				$('#denoEntraMilID').val()+"-"+
				$('#cantEntraMil').asNumber()+"-"+
				$('#montoEntraMil').asNumber()+","+
				$('#denoEntraQuiID').val()+"-"+
				$('#cantEntraQui').asNumber()+"-"+
				$('#montoEntraQui').asNumber()+","+
				$('#denoEntraDosID').val()+"-"+
				$('#cantEntraDos').asNumber()+"-"+
				$('#montoEntraDos').asNumber()+","+
				$('#denoEntraCienID').val()+"-"+
				$('#cantEntraCien').asNumber()+"-"+
				$('#montoEntraCien').asNumber()+","+
				$('#denoEntraCinID').val()+"-"+
				$('#cantEntraCin').asNumber()+"-"+
				$('#montoEntraCin').asNumber()+","+
				$('#denoEntraVeiID').val()+"-"+
				$('#cantEntraVei').asNumber()+"-"+
				$('#montoEntraVei').asNumber()+","+
				$('#denoEntraMonID').val()+"-"+
				$('#cantEntraMon').asNumber()+"-"+
				$('#montoEntraMon').asNumber());
				$('#impTicket').hide();
				$('#impCheque').hide();
				ocultarBtnResumen();
				//habilitar el botón de grabar hasta que este completa la lista
				if(estaHabilitadoGrabar){
					habilitaBoton('graba','submit');
				}
			}

			function crearListaBilletesMonedasSalida(){
				var estaHabilitadoGrabar=false;
				//Deshabilitar el botón de grabar hasta que este completa la lista
				if(!$("#graba").is(":disabled")){
					estaHabilitadoGrabar=true;
					deshabilitaBoton('graba','submit');
				}
				$('#billetesMonedasSalida').val("");
				$('#billetesMonedasSalida').val($('#billetesMonedasSalida').val()+
				$('#denoSalMilID').val()+"-"+
				$('#cantSalMil').asNumber()+"-"+
				$('#montoSalMil').asNumber()+","+
				$('#denoSalQuiID').val()+"-"+
				$('#cantSalQui').asNumber()+"-"+
				$('#montoSalQui').asNumber()+","+
				$('#denoSalDosID').val()+"-"+
				$('#cantSalDos').asNumber()+"-"+
				$('#montoSalDos').asNumber()+","+
				$('#denoSalCienID').val()+"-"+
				$('#cantSalCien').asNumber()+"-"+
				$('#montoSalCien').asNumber()+","+
				$('#denoSalCinID').val()+"-"+
				$('#cantSalCin').asNumber()+"-"+
				$('#montoSalCin').asNumber()+","+
				$('#denoSalVeiID').val()+"-"+
				$('#cantSalVei').asNumber()+"-"+
				$('#montoSalVei').asNumber()+","+
				$('#denoSalMonID').val()+"-"+
				$('#cantSalMon').asNumber()+"-"+
				$('#montoSalMon').asNumber());
				$('#impTicket').hide();
				$('#impCheque').hide();
				ocultarBtnResumen();
				//habilitar el botón de grabar hasta que este completa la lista
				if(estaHabilitadoGrabar){
					habilitaBoton('graba','submit');
				}
			}

			function consultaDisponibleDenominacion() {
		//			mensajeSis("ok83837837387383783738");
		//			$('#huellaRequiere').val("");
		//			$('#requiereFirmante').val('');
				var bean = {
						'sucursalID':$('#numeroSucursal').val(),
						'cajaID':$('#numeroCaja').val(),
						'denominacionID':0,
						'monedaID':1
					};
				ingresosOperacionesServicio.listaConsulta(1, bean,function(disponDenom){
					for (var i = 0; i < disponDenom.length; i++){
						switch(parseInt(disponDenom[i].denominacionID))
						{
						case 1:$('#disponSalMil').val(disponDenom[i].cantidadDenominacion);
						$('#disponSalMil').formatCurrency({
							positiveFormat: '%n',
							negativeFormat: '%n',
							roundToDecimalPlace: 0
						});
						break;
						case 2:$('#disponSalQui').val(disponDenom[i].cantidadDenominacion);
						$('#disponSalQui').formatCurrency({
							positiveFormat: '%n',
							negativeFormat: '%n',
							roundToDecimalPlace: 0
						});
						break;
						case 3:$('#disponSalDos').val(disponDenom[i].cantidadDenominacion);
						$('#disponSalDos').formatCurrency({
							positiveFormat: '%n',
							negativeFormat: '%n',
							roundToDecimalPlace: 0
						});
						break;
						case 4:$('#disponSalCien').val(disponDenom[i].cantidadDenominacion);
						$('#disponSalCien').formatCurrency({
							positiveFormat: '%n',
							negativeFormat: '%n',
							roundToDecimalPlace: 0
						});
						break;
						case 5:$('#disponSalCin').val(disponDenom[i].cantidadDenominacion);
						$('#disponSalCin').formatCurrency({
							positiveFormat: '%n',
							negativeFormat: '%n',
							roundToDecimalPlace: 0
						});
						break;
						case 6:$('#disponSalVei').val(disponDenom[i].cantidadDenominacion);
						$('#disponSalVei').formatCurrency({
							positiveFormat: '%n',
							negativeFormat: '%n',
							roundToDecimalPlace: 0
						});
						break;
						case 7:	$('#disponSalMon').val(disponDenom[i].cantidadDenominacion);
						$('#disponSalMon').formatCurrency({
							positiveFormat: '%n',
							negativeFormat: '%n',
							roundToDecimalPlace: 2
						});
						break;
						}
					}
					$('#saldoEfecMNSesion').val(
					parseFloat($('#disponSalMil').asNumber()*1000)+
					parseFloat($('#disponSalQui').asNumber()*500)+
					parseFloat($('#disponSalDos').asNumber()*200)+
					parseFloat($('#disponSalCien').asNumber()*100)+
					parseFloat($('#disponSalCin').asNumber()*50)+
					parseFloat($('#disponSalVei').asNumber()*20)+
					parseFloat($('#disponSalMon').asNumber()*1));

					$('#saldoEfecMNSesion').formatCurrency({
						positiveFormat: '%n',
						negativeFormat: '%n',
						roundToDecimalPlace: 2
					});
				});
			}

			function imprimirTicketGrupal() {

				var bean = {
						'grupoID':$('#grupoID').val(),
						'cicloActual': $('#cicloID').val()
					};

				var ctaGLAdiID = "";
				var glAdicionalID = "";
				var clienteID = "";
				var nombreCliente = "";
				var contador = 0;
				gruposCreditoServicio.listaConsulta(4, bean, function(credGrupo){
					for (var i = 0; i < credGrupo.length; i++){
						contador = contador +1;
						if(TipoImpresion !=ticket){
							if($('#montoPagar').asNumber()>$('#garantiaAdicionalPC').asNumber()){
							window.open('RepTicketVentanillaPagCredGrupal.htm?fechaSistemaP='+$('#fechaSistemaP').val()+
									'&monto='+$('#montoPagar').val()+'&nombreInstitucion='+$('#nombreInstitucion').val()+'&numeroSucursal='+$('#numeroSucursal').val()+
									'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
									'&varCreditoID='+credGrupo[i].creditoID+'&numCopias='+$('#numCopias').val()+'&sumTotalEnt='+$('#sumTotalEnt').val()+
									'&diferencia='+$('#sumTotalSal').val()+'&varFormaPago='+"Efectivo"+'&tipoTransaccion='+catTipoTransaccionVen.pagoCreditoGrupal+
									'&numTrans='+$('#numeroTransaccion').val()+'&numero='+i+'&moneda='+$('#monedaDes').val()+'&productoCred= '+
									'&grupo='+$('#grupoDes').val()+'&ciclo='+$('#cicloID').val(), '_blank');
							}
							ctaGLAdiID = eval("'#cuentaGLID"+contador+"'");
							glAdicionalID = eval("'#garantiaAdicional"+contador+"'");
							clienteID = eval("'#clienteIDIntegrante"+contador+"'");


							nombreCliente = eval("'#nombreIntegrante"+contador+"'");
							if($('#garantiaAdicionalPC').asNumber()>0){
								var fechaHora = $('#fechaSistemaP').val()+" " +hora();
								if($(glAdicionalID).asNumber()>0){
									window.open('RepTicketVentanillaGLAdicional.htm?fechaSistemaP='+fechaHora+
											'&monto='+$(glAdicionalID).val()+'&nombreInstitucion='+$('#nombreInstitucion').val()+
											'&numeroSucursal='+$('#numeroSucursal').val()+
											'&nombreSucursal='+$('#nombreSucursal').val()+'&varCaja='+$('#numeroCaja').val()+'&nomCajero='+$('#nomCajero').val()+
											'&varCreditoID='+credGrupo[i].creditoID+'&numCopias='+$('#numCopias').val()+'&sumTotalEnt='+$('#sumTotalEnt').val()+
											'&diferencia='+$('#sumTotalSal').val()+'&varFormaPago='+"Efectivo"+
											'&numCli='+$(clienteID).val()+'&nombreCli='+$(nombreCliente).val()+'&cuentaAho='+$(ctaGLAdiID).val()+
											'&tipoCuen='+""+'&tipoTransaccion='+catTipoTicketVen.garantiaLiquidaAdicional+
											'&numTrans='+$('#numeroTransaccion').val()+'&moneda='+$('#monedaDes').val()+'&productoCred='+''+
											'&tipoCuen='+""+'&grupo='+$('#grupoDes').val()+
											'&ciclo='+$('#cicloID').val(), '_blank');
								}
							}
						}else{

							var creditoID=credGrupo[i].creditoID;
							var fechaPago=$('#fechaSistemaP').val();
							var transaccion=$('#numeroTransaccion').val();
							var ctaGLAdiIDInt = $('#cuentaGLID'+contador).val();
							var montoGL =  $('#garantiaAdicional'+contador).val();
							var clienteID =  $('#clienteIDIntegrante'+contador).val();
							var nombreIntegrante =  $('#nombreIntegrante'+contador).val();

							if($('#garantiaAdicionalPC').asNumber()>0){
								 montoglAdicionalInt = eval("'#garantiaAdicional"+contador+"'");

								if($(montoglAdicionalInt).asNumber()>0 ){
										imprimeTicketPagoCredito(creditoID, fechaPago, transaccion, contador,'S',ctaGLAdiIDInt,montoGL,clienteID,nombreIntegrante);
								}else{
									imprimeTicketPagoCredito(creditoID, fechaPago, transaccion, contador,'N',ctaGLAdiIDInt,montoGL,clienteID,nombreIntegrante);
								}
							}else{
									imprimeTicketPagoCredito(creditoID, fechaPago, transaccion, contador,'N',ctaGLAdiIDInt,montoGL,clienteID,nombreIntegrante);
							}
						}// else si tiene ticket

					}
					imprimeTicket();

				});
			}


			function imprimeTicketPagoCredito(credito, fechaPago, transaccion, contador,conGarantia,ctaGLAdiID,montoglAdicionalID,ClienteID,NombreCompelto){
				var tipoConsulta=1;
				var numCliente=$('#clienteID').val();
				var RFCCliente='';
				var consultaC=10;
				var CuotasP='';
				var TotalC='';

				var beanDetalle = {
						'creditoID':credito,
						'fechaPago':fechaPago,
						'transaccion':transaccion

					};

				var creditoBeanCon = {
						'creditoID':credito,
					};

			        clienteServicio.consulta(tipoConsulta,ClienteID,
			        		{ async: false, callback:function(detalleRFC){
								if(detalleRFC != null){
								   RFCCliente= detalleRFC.RFC;
								}
			        		}});

					amortizacionCreditoServicio.consulta(consultaC,creditoBeanCon,
							{ async: false, callback:function(numCuotas){
						if(numCuotas != null){
							CuotasP= numCuotas.cuotasPagadas;
							TotalC= numCuotas.totalCuotas;
							}
		        		}});


					creditosServicio.consultaDetallePago(tipoConsulta, beanDetalle,
								{ async: false, callback:	function(detallePago){
								if(detallePago != null){
									$('#saldoCapital').val(detallePago.capital);
									$('#saldoCapitalInsoluto').val(detallePago.capitalInsoluto);


										var impresionPagoCredito={
											    'folio' 	        :$('#numeroTransaccion').val(),
										        'tituloOperacion'   :'COMPROBANTE PAGO DE CREDITO',
											    'clienteID' 		:detallePago.clienteID,
											    'creditoID' 		:credito,
											    'nombreCliente'     :detallePago.nombreCompelto,
											    'montoPago'         :detallePago.montoTotal,
											    'proxFechaPago'     :detallePago.proximaFechaPago,
											    'montoProximoPago'  :detallePago.montoPagado ,
											    'moneda' 			: monedaBase,
											    'grupo'  			: $('#grupoDes').val(),
											    'ciclo'  			: $('#cicloID').val(),
											    'capital'			: detallePago.capital,
											    'interes' 			: detallePago.interes,
											    'moratorios'		: detallePago.montoIntMora,
											    'comision'  		: detallePago.montoComision,
											    'comisionAdmon'		: detallePago.montoGastoAdmon,
											    'saldoComAnual'		: detallePago.saldoComAnual,
											    'iva'  				: detallePago.montoIVA,
											    'total' 		 	:'',
											    'montoRecibido'	  	:$('#sumTotalEnt').val() ,
											    'cambio' 		 	:$('#sumTotalSal').val(),
											    'cuenta'			:ctaGLAdiID,
											    'cuentaID' 		 	:$('#cuentaID').val(),
											    'montoGarantia'     :montoglAdicionalID,
											    'totalAdeudoPend'   :detallePago.totalDeudaPend,
											    'capVigente'		:$('#saldoCapitalInsoluto').asNumber()+$('#saldoCapital').asNumber(),
											    'capVigenteAct'		:detallePago.capitalInsoluto,
											    'rfc'               :RFCCliente,
											    'producto'          :$('#descripcionProd').val(),
											    'totalcuotas'       :TotalC,
											    'cuotasPaga'        :CuotasP,
											    'cobraSeguroCuota'	:$('#cobraSeguroCuota').val(),
											    'montoSeguroCuota'	:detallePago.montoSeguroCuota,
											    'iVASeguroCuota'	:detallePago.iVASeguroCuota
										};

										imprimirTicketPagCredGrupal(impresionPagoCredito,contador,conGarantia);
									}else{
										var montoglAdicionalIDN = montoglAdicionalID.toString().replace(',','');
										var montoglAdicionalIDNumero = Number(montoglAdicionalIDN);
										if(montoglAdicionalIDNumero > 0.00){
											$('#saldoCapital').val('0.00');
											var impresionPagoCredito={
											    'folio' 	        :$('#numeroTransaccion').val(),
										        'tituloOperacion'   :'COMPROBANTE PAGO DE CREDITO',
										        'clienteID' 		:ClienteID,
											    'creditoID' 		:credito,
											    'nombreCliente'     :NombreCompelto,
											    'montoPago'         :'0.00',
											    'proxFechaPago'     :'',
											    'montoProximoPago'  :'0.00' ,
											    'moneda' 			: monedaBase,
											    'grupo'  			: $('#grupoDes').val(),
											    'ciclo'  			: $('#cicloID').val(),
											    'capital'			: '0.00',
											    'interes' 			: '0.00',
											    'moratorios'		: '0.00',
											    'comision'  		: '0.00',
											    'comisionAdmon'		: '0.00',
											    'iva'  				: '0.00',
											    'total' 		 	:'0.00',
											    'montoRecibido'	  	:$('#sumTotalEnt').val() ,
											    'cambio' 		 	:$('#sumTotalSal').val(),
											    'cuenta'			:ctaGLAdiID,
											    'cuentaID' 		 	:$('#cuentaID').val(),
											    'montoGarantia'     :montoglAdicionalID,
											    'totalAdeudoPend'   :'0.00',
											    'capVigente'		:'0.00',
											    'capVigenteAct'		:'0.00',
											    'rfc'               :RFCCliente,
											    'producto'          :$('#descripcionProd').val(),
											    'totalcuotas'       :TotalC,
											    'cuotasPaga'        :CuotasP,
											    'cobraSeguroCuota'	:$('#cobraSeguroCuota').val(),
											    'montoSeguroCuota'	:$('#montoSeguroCuota').val(),
											    'ivaSeguroCuota'	:$('#iVASeguroCuota').val()
											};
										imprimirTicketPagCredGrupal(impresionPagoCredito,contador,conGarantia);
									}
									}
								}
							});


			}

			function verFirmasCta() {
				var varCuentaVerArchivo = $('#cuentaAhoIDCa').val();
				var varTipoConVerArchivo = 11;
				var parametros ='';
				var pagina='';
				var tipoCon= 12;
				var cuentaArBean ={
			 		 	'cuentaAhoID' : varCuentaVerArchivo
				};
				fileServicio.consultaArCuenta(tipoCon , cuentaArBean, function(archivo){
		 			if(archivo != null){
		 				var extensionArchivo=  archivo.recurso.substring(archivo.recurso.lastIndexOf('.'));
		 				parametros = "?cuentaAhoID="+varCuentaVerArchivo+"&tipoDocumento="+
		 				archivo.tipoDocumento+"&tipoConsulta="+varTipoConVerArchivo+"&archivoCuentaID="+archivo.archivoCuentaID;

		 				pagina="cuentasVerArchivos.htm"+parametros;
		 				if(extensionArchivo==".jpg" || extensionArchivo == ".png" || extensionArchivo == ".jpeg"){
		 					$('#imgCliente').attr("src",pagina);
		 					$('#imagenCte').html( $('#imgCliente').trigger('click'));
		 					 $.blockUI({message: $('#imagenCte'),
		 						   css: {
		 							  top:  ($(window).height() - 400) /2 + 'px',
		 						     left: ($(window).width() - 1000) /2 + 'px',
		 						     width: '70%'
		 			     } });
		 					  $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
		 	 				}else{

		 					window.open(pagina,'_blank');
		 					$('#imagenCte').hide();
		 				}
		 			}else{
		 				mensajeSis('No existen Archivos Para Mostrar.');
		 			}
				} );

			}

			// funcion para obtener la hora del sistema
			function hora(){
				 var Digital=new Date();
				 var hours=Digital.getHours();
				 var minutes=Digital.getMinutes();
				 var seconds=Digital.getSeconds();

				 if (minutes<=9)
				 minutes="0"+minutes;
				 if (seconds<=9)
				 seconds="0"+seconds;
				return  hours+":"+minutes+":"+seconds;
			 }


			//*****FUNCIONES PARA EL PAGO DEL SEGURO DE VIDA  ***
			function consultaCreditoSeguro(controlID){
				var Autorizado='A';
				var Vigente='V';
				var Vencido='B';
				var numCredito = $('#creditoIDS').val();
				setTimeout("$('#cajaLista').hide();", 200);

				if(numCredito != '' && !isNaN(numCredito)){
					var creditoBeanCon = {
						'creditoID':$('#creditoIDS').val(),
		  				'fechaActual':$('#fechaSistema').val()
		  			};

		   			creditosServicio.consulta(15,creditoBeanCon,function(credito) {
		   				if(credito!=null){
		   					listaPersBloqBean = consultaListaPersBloq(credito.clienteID, esCliente, 0, 0);
							consultaSPL = consultaPermiteOperaSPL(credito.clienteID,'LPB',esCliente);

							if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
			   					validaEstatusCreditoSeguro(credito.estatus,'estatusCreditoSeguro');
			   					if ( (credito.estatus==Autorizado) ||  (credito.estatus == Vigente )||( credito.estatus ==Vencido)){
			   						$('#creditoIDS').val(credito.creditoID);
			   						$('#clienteIDS').val(credito.clienteID);
			   						$('#productoCreditoS').val(credito.producCreditoID);
			   						$('#cuentaClienteS').val(credito.cuentaID);
			   						$('#montoCreditoS').val(credito.montoCredito);
			   						$('#monedaS').val(credito.monedaID);

			   						$('#grupoIDS').val(credito.grupoID);
			   						$('#diasAtrasoCredito').val(credito.diasAtraso);
			   						if(credito.grupoID > 0){
			   	   						$('#cicloIDS').val(credito.cicloGrupo);
			   							consultaGrupo(credito.grupoID, 'grupoIDS', 'grupoDesS', 'cicloIDS');

			   							$('#trGrupo').show();

			   						}else {
			   							$('#trGrupo').hide();

			   						}
			   						consultaClienteComApDes(credito.clienteID, 'clienteIDS','nombreClienteS');
			   						consultaMonedaSeguro(credito.monedaID,'monedaS', 'monedaDesS');
			   						consultaProdCredito(credito.producCreditoID,'productoCreditoS', 'desProdCreditoS');
			   						consultaCuenta(credito.cuentaID,'cuentaClienteS','descCuentaSeguro');
			   						validaEstatusCreditoSeguro(credito.estatus,'estatusCreditoSeguro');
			   						consultaSeguro('creditoIDS');
			   						$('#impTicket').hide();
			   						$('#impCheque').hide();
			   						ocultarBtnResumen();
			   						agregaFormatoMoneda('formaGenerica');
			   						$('#tipoTransaccion').val(catTipoTransaccionVen.aplicaSeguroVida);


			   						if($('#diasAtrasoCredito').asNumber()>0){
			   							mensajeSis("El Crédito Presenta Días de Atraso.");
				   						$('#creditoIDS').focus();
				   						$('#creditoIDS').select();
				   						deshabilitaBoton('graba','submit');
				   						validarFormaPago();
					   					consultaDisponibleDenominacion();
				   					}

								}else{
									mensajeSis("El Crédito se encuentra "+ $('#estatusCreditoSeguro').val());
									inicializarCampos();
				   					$('#creditoIDS').focus();
				   					$('#creditoIDS').select();
									deshabilitaBoton('graba', 'submit');
								}
			   				}else{
			   					inicializaForma('formaGenerica','creditoIDS');
			   					mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
			   					validarFormaPago();
			   					consultaDisponibleDenominacion();
			   					$('#creditoIDS').focus();
			   					$('#creditoIDS').select();
			   					inicializarCampos();
			   					$('#cuentaChequePago').val('');
			   					$('#tipoChequera').val('');
			   				}
		   				}else{
		   					inicializaForma('formaGenerica','creditoIDS');
		   					mensajeSis("El Crédito No Existe.");
		   					validarFormaPago();
		   					consultaDisponibleDenominacion();
		   					$('#creditoIDS').focus();
		   					$('#creditoIDS').select();
		   					inicializarCampos();
		   					$('#cuentaChequePago').val('');
		   					$('#tipoChequera').val('');
		   				}
					});
				}else{
					inicializarCampos();
				}
			}
			function consultaSeguro(controlID){
				var cobrado='C';
				var inactivo='I';
				var anticipado='A';
				var financiamiento='F';
				var deduccion='D';
				var solicitudCero='0';

				var numCredito = $('#creditoIDS').val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(numCredito != '' && !isNaN(numCredito )){
					var creditoBeanCon = {
						'seguroVidaID':solicitudCero,
						'solicitudCreditoID':solicitudCero,
						'creditoID'	  :$('#creditoIDS').val(),
						'cuentaAhoID':solicitudCero,

		  			};
					seguroVidaServicio.consulta(2,creditoBeanCon,function(seguro) {
		   				if(seguro!=null){
		   					$('#creditoIDS').val(seguro.creditoID);
		   					$('#numeroPolizaS').val(seguro.seguroVidaID);
		   					$('#clienteIDS').val(seguro.clienteID);
		   					$('#impTicket').hide();
		   					$('#impCheque').hide();
		   					ocultarBtnResumen();
		   					$('#fechaInicioSeguro').val(seguro.fechaInicio);
		   					$('#fechaVencimiento').val(seguro.fechaVencimiento);
		   					$('#estatusSeguro').val(seguro.estatus);
		   					$('#beneficiarioSeguro').val(seguro.beneficiario);
		   					$('#direccionBeneficiario').val(seguro.direccionBeneficiario);
		   					$('#relacionBeneficiario').val(seguro.relacionBeneficiario);
		   					$('#desRelacionBeneficiario').val(seguro.descriRelacionBeneficiario);
		   					$('#montoPoliza').val(seguro.montoPoliza);
		   					if(seguro.forCobroSegVida==anticipado){
		   						$('#pagoAnticipadoS').attr("checked",true);
		   						$('#pagoFinanciadoS').attr("checked",false);
		   						$('#pagoDeduccionS').attr("checked",false);
							}else if(seguro.forCobroSegVida==financiamiento){
								$('#pagoAnticipadoS').attr("checked",false);
								$('#pagoFinanciadoS').attr("checked",true);
								$('#pagoDeduccionS').attr("checked",false);
							}else if(seguro.forCobroSegVida==deduccion){
								$('#pagoAnticipadoS').attr("checked",false);
								$('#pagoFinanciadoS').attr("checked",false);
								$('#pagoDeduccionS').attr("checked",true);
							}

		   					if(seguro.estatus==cobrado){
								mensajeSis("La Póliza ya fue Cobrada.");
								soloLecturaEntradasSalidasEfectivo();
								deshabilitaBoton('graba', 'submit');
							}
		   					if(seguro.estatus==inactivo){
								mensajeSis("La Póliza no esta Vigente.");
								soloLecturaEntradasSalidasEfectivo();
								deshabilitaBoton('graba', 'submit');
							}
		   					var fechaSistema=$('#fechaSistema').val();
		   					if(seguro.fechaVencimiento <= fechaSistema){
		   						mensajeSis("La Fecha de Vencimiento de la Póliza ya paso.");
		   						soloLecturaEntradasSalidasEfectivo();
		   						deshabilitaBoton('graba', 'submit');
		   					}
		   					if(($('#pagoFinanciadoS').is(':checked') )&& ( $('#diasAtrasoCredito').val()>0) ){
		   						mensajeSis("La Cobertura de Riesgo Fue Financiada y el Crédito Relacionado Presenta Atrasos.");
		   						soloLecturaEntradasSalidasEfectivo();
		   						deshabilitaBoton('graba', 'submit');
		   					}
		   					validaEstatusSeguro(seguro.estatus,'estatusSeguro');
		   					totalEntradasSalidasDiferencia();


		   				}else{
		   					mensajeSis("El Crédito No tiene una Póliza Cobertura de Riesgo Asociada.");
		   					inicializaForma('formaGenerica','creditoIDS');
		   					validarFormaPago();
		   					$('#cuentaChequePago').val('');
		   					$('#tipoChequera').val('');
		   					consultaDisponibleDenominacion();
		   					$('#creditoIDS').focus();
		   					$('#creditoIDS').select();
		   					inicializarCampos();
		   					$('#totalEntradas').val(0);
		   					$('#diferencia').val(0);
		   				}
					});
				}
			}
			function validaEstatusSeguro(estatus, idCampo){
				var  inactivo='I';
				var  vigente='V';
				var  cobrado='C';

				if(estatus==inactivo){
					$('#'+idCampo).val('INACTIVO');
				}else if(estatus==vigente){
					$('#'+idCampo).val('VIGENTE');
				}else if(estatus==cobrado){
					$('#'+idCampo).val('COBRADO');
				}
			}

			//Usado En: Prepago de credito, Recuperacion de Cartera vencida
			function consultaMonedaSeguro(valorID, id,desMoneda){
				var numMoneda = valorID;
				var conMoneda=2;
				setTimeout("$('#cajaLista').hide();", 200);
				if(numMoneda != '' && !isNaN(numMoneda)){
					monedasServicio.consultaMoneda(conMoneda,numMoneda,function(moneda) {
						if(moneda!=null){
							$('#'+desMoneda).val(moneda.descripcion);
						}else{
							$('#'+id).val('');
							$('#'+id).focus();
						}
					});
				}
			}
			/*Usado En: Cobro del seguro de vida,Pago del Seguro de Vida,Pago de Servicios,
						devolucion de garantia liquida, Recuperacion de Cartera Vencida
			*/
			function consultaProdCredito(valorID,id,desProducto) {
				var numProdCre = valorID;
				var conTipoCta=2;
				var ProdCredBeanCon = {
		  			'producCreditoID':numProdCre
				};
				setTimeout("$('#cajaLista').hide();", 200);
				if(numProdCre != '' && !isNaN(numProdCre)){
					productosCreditoServicio.consulta(conTipoCta, ProdCredBeanCon,function(prodCred) {
						if(prodCred!=null){
							$('#'+desProducto).val(prodCred.descripcion);
						}else{
							$('#'+id).focus();
						}
					});
				}
			}
			// Usado Para: Seguro de Vida, devolucion de Garantia Liquida, Recuperacion cartera Vencida
			function validaEstatusCreditoSeguro(var_estatus, idCampo) {
				var estatusInactivo 	="I";
				var estatusAutorizado 	="A";
				var estatusVigente		="V";
				var estatusPagado		="P";
				var estatusCancelada 	="C";
				var estatusVencido		="B";
				var estatusCastigado 	="K";
				$('#impTicket').hide();
				$('#impCheque').hide();
				ocultarBtnResumen();
				if(var_estatus == estatusInactivo){
					$('#'+idCampo).val('INACTIVO');
				}
				if(var_estatus == estatusAutorizado){
					$('#'+idCampo).val('AUTORIZADO');
				}
				if(var_estatus == estatusVigente){
					$('#'+idCampo).val('VIGENTE');
				}
				if(var_estatus == estatusPagado){
					$('#'+idCampo).val('PAGADO');
				}
				if(var_estatus == estatusCancelada){
					$('#'+idCampo).val('CANCELADO');
				}
				if(var_estatus == estatusVencido){
					$('#'+idCampo).val('VENCIDO');
				}
				if(var_estatus == estatusCastigado){
					$('#'+idCampo).val('CASTIGADO');
				}
			}

			//consulta 4 CUENTASAHOCON
			function consultaCuenta(valorID,idCampo,desCuenta){
				var jqnumCta  = eval("'#" + idCampo + "'");
				var numCta = $(jqnumCta).val();
		        var conCta = 4;

		        var CuentaAhoBeanCon = {
		        		'cuentaAhoID':valorID,
		        		'clienteID':$('#clienteIDS').val()
		        };
		        setTimeout("$('#cajaLista').hide();", 200);

		        $('#impTicket').hide();
		        $('#impCheque').hide();
		        ocultarBtnResumen();
		        if(numCta != '' && !isNaN(numCta)){
		        	cuentasAhoServicio.consultaCuentasAho(conCta, CuentaAhoBeanCon,function(cuenta) {

		        		if(cuenta!=null){

		        			$('#cuentaClienteS').val(cuenta.cuentaAhoID);
		        			$('#'+desCuenta).val(cuenta.descripcionTipoCta);
		        		}else{
		        			mensajeSis("No Existe la Cuenta de Ahorro.");
		        		}
		        	});
		        }
			}


			//*****FIN FUNCIONES PARA EL PAGO DEL SEGURO DE VIDA***


			//*****FUNCIONES PARA EL COBRO DEL SEGURO DE VIDA  cccc***
			function consultaCreditoSeguroVidaCobro(controlID){
				var Inactivo='I';

				var numCredito = $('#creditoIDSC').val();
				setTimeout("$('#cajaLista').hide();", 200);

				if(numCredito != '' && !isNaN(numCredito)){
					var creditoBeanCon = {
						'creditoID':$('#creditoIDSC').val(),
		  				'fechaActual':$('#fechaSistema').val()
		  			};

		   			creditosServicio.consulta(11,creditoBeanCon,function(credito) {
		   				if(credito!=null){
		   					listaPersBloqBean = consultaListaPersBloq(credito.clienteID, esCliente, 0, 0);
							consultaSPL = consultaPermiteOperaSPL(credito.clienteID,'LPB',esCliente);

							if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
			   					$('#impTicket').hide();
			   					$('#impCheque').hide();
			   					validaEstatusCreditoSeguro(credito.estatus,'estatusCreditoSeguroC');
			   						$('#creditoIDSC').val(credito.creditoID);
			   						$('#clienteIDSC').val(credito.clienteID);

			   						$('#productoCreditoSC').val(credito.producCreditoID);
			   						$('#cuentaClienteSC').val(credito.cuentaID);
			   						$('#montoCreditoSC').val(credito.montoCredito);
			   						$('#monedaSC').val(credito.monedaID);
			   						$('#monedaSC').val(credito.monedaID);
			   						$('#montoPagoSegurVidaC').val(credito.seguroVidaPagado);
			   						$('#montoSeguroVidaC').val(credito.montoSeguroVida);
			   						$('#grupoIDSC').val(credito.grupoID);
			   						if(credito.grupoID>0){
			   							$('#cicloIDSC').val(credito.cicloGrupo);
			   							consultaGrupo(credito.grupoID, 'grupoIDSC', 'grupoDesSC', 'cicloIDSC');
			   							$('#tdGrupoCreditoS').show();
			   							$('#tdGrupoCreditoSInputC').show();
			   							$('#tdGrupoCicloSC').show();
			   							$('#tdGrupoCicloSinputC').show();
			   							$('#grupoDesSC').show();
			   							$('#lblCreditoid').show();
			   							$('#grupoIDSC').show();
			   						}else {
			   							$('#tdGrupoCreditoSC').hide();
			   							$('#tdGrupoCreditoSInputC').hide();
			   							$('#tdGrupoCicloSC').hide();
			   							$('#tdGrupoCicloSinputC').hide();
			   							$('#grupoDesSC').hide();
			   							$('#lblCreditoid').hide();
			   							$('#grupoIDSC').hide();
			   						}
			   						consultaClienteComApDes(credito.clienteID, 'clienteIDSC','nombreClienteSC');
			   						consultaMonedaSeguro(credito.monedaID,'monedaSC', 'monedaDesSC');
			   						consultaProdCredito(credito.producCreditoID,'productoCreditoSC', 'desProdCreditoSC');

			   						consultaCuenta(credito.cuentaID,'cuentaClienteSC','descCuentaSeguroC');
			   						consultaSeguroCobro('creditoIDSC');

			   						agregaFormatoMoneda('formaGenerica');
			   						$('#tipoTransaccion').val(catTipoTransaccionVen.cobroSeguroVida);
			   						if((credito.estatus!=Inactivo)){
										mensajeSis("El Crédito ya se encuentra Autorizado.");
										soloLecturaEntradasSalidasEfectivo();
										deshabilitaBoton('graba', 'submit');
										$('#montoSeguroCobro').attr('disabled',true);
			   						}
			   				}else{
			   					inicializaForma('formaGenerica','creditoIDSC');
			   					consultaDisponibleDenominacion();
			   					mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
			   					validarFormaPago();
			   					$('#creditoIDSC').focus();
			   					$('#creditoIDSC').select();
			   					inicializarCampos();
			   					$('#cuentaChequePago').val('');
			   					$('#tipoChequera').val('');
			   				}
		   				}else{
		   					inicializaForma('formaGenerica','creditoIDSC');
		   					consultaDisponibleDenominacion();
		   					validarFormaPago();
		   					$('#creditoIDSC').focus();
		   					$('#creditoIDSC').select();
		   					inicializarCampos();
		   					$('#cuentaChequePago').val('');
		   					$('#tipoChequera').val('');
		   				}
					});

				}else{
					inicializarCampos();
				}
			}
		function consultaSeguroCobro(controlID){
			var cobrado='C';
			var vigente='V';
			var anticipado='A';
			var financiamiento='F';
			var deduccion='D';
			var Cero='0';
			var otro = 'O';

			var numCredito = $('#creditoIDSC').val();

			setTimeout("$('#cajaLista').hide();", 200);
			if(numCredito != '' && !isNaN(numCredito )){
				var creditoBeanCon = {
					'seguroVidaID':Cero,
					'solicitudCreditoID':Cero,
					'creditoID'	  :$('#creditoIDSC').val(),
					'cuentaAhoID':Cero,

					};
				seguroVidaServicio.consulta(2,creditoBeanCon,function(seguro) {
						if(seguro!=null){
							validaEstatusSeguro(seguro.estatus,'estatusSeguroC');
							$('#impTicket').hide();
							$('#impCheque').hide();
							ocultarBtnResumen();
							$('#creditoIDSC').val(seguro.creditoID);
							$('#numeroPolizaSC').val(seguro.seguroVidaID);
							$('#clienteIDSC').val(seguro.clienteID);
							$('#cuentaClienteSC').val(seguro.cuentaAhoID);
							$('#fechaInicioSeguroC').val(seguro.fechaInicio);
							$('#fechaVencimientoC').val(seguro.fechaVencimiento);
							$('#beneficiarioSeguroC').val(seguro.beneficiario);
							$('#direccionBeneficiarioC').val(seguro.direccionBeneficiario);
							$('#relacionBeneficiarioC').val(seguro.relacionBeneficiario);
							$('#desRelacionBeneficiarioC').val(seguro.descriRelacionBeneficiario);
							$('#montoPolizaC').val(seguro.montoPoliza);


							var	 totalPendienteCobro= $('#montoSeguroVidaC').asNumber()-$('#montoPagoSegurVidaC').asNumber();
							$('#montoPendienteCobro').val(totalPendienteCobro);

							if(seguro.forCobroSegVida==anticipado ){
								$('#pagoAnticipadoSC').attr("checked",true);
								$('#pagoFinanciadoSC').attr("checked",false);
								$('#pagoDeduccionSC').attr("checked",false);

						}else if(seguro.forCobroSegVida==financiamiento){
							$('#pagoAnticipadoSC').attr("checked",false);
							$('#pagoFinanciadoSC').attr("checked",true);
							$('#pagoDeduccionSC').attr("checked",false);
							mensajeSis("La Forma de Pago de la Póliza no es Anticipado.");
							soloLecturaEntradasSalidasEfectivo();
							deshabilitaBoton('graba', 'submit');
							$('#montoSeguroCobro').attr('disabled',true);

						}else if(seguro.forCobroSegVida==deduccion){
							$('#pagoAnticipadoSC').attr("checked",false);
							$('#pagoFinanciadoSC').attr("checked",false);
							$('#pagoDeduccionSC').attr("checked",true);
							mensajeSis("La Forma de Pago de la Póliza no es Anticpado.");
							soloLecturaEntradasSalidasEfectivo();
							deshabilitaBoton('graba', 'submit');
							$('#montoSeguroCobro').attr('disabled',true);
						}else if(seguro.forCobroSegVida==otro ){
							$('#pagoAnticipadoSC').attr("checked",true);
							$('#pagoFinanciadoSC').attr("checked",false);
							$('#pagoDeduccionSC').attr("checked",false);
						}

						if(seguro.estatus==cobrado || seguro.estatus==vigente){
							mensajeSis("El Monto Total de la Póliza ya fue Depositado.");
							soloLecturaEntradasSalidasEfectivo();
							deshabilitaBoton('graba', 'submit');
							$('#montoSeguroCobro').attr('disabled',true);
						}

						var fechaSistema=$('#fechaSistema').val();
						if(seguro.fechaVencimiento <= fechaSistema){
							mensajeSis("La Fecha de Vencimiento del Seguro ya paso");
							soloLecturaEntradasSalidasEfectivo();
							deshabilitaBoton('graba', 'submit');
							$('#montoSeguroCobro').attr('disabled',true);
						}


						agregaFormatoMoneda('formaGenerica');
					}else{
						mensajeSis("El Crédito No tiene una Póliza de Cobertura de Riesgo Asociada.");
						inicializaForma('formaGenerica','creditoIDSC');
						validarFormaPago();
						$('#creditoIDSC').focus();
						$('#creditoIDSC').select();
						inicializarCampos();
						$('#cuentaChequePago').val('');
						$('#tipoChequera').val('');
					}
				});
			}
		}
				function validaMontoCobrar(){
					var montoPendiente=$('#montoPendienteCobro').asNumber();
					var montoACobrar=$('#montoSeguroCobro').asNumber();

						if (montoACobrar > montoPendiente){
							mensajeSis("El Monto a Cobrar No puede ser Mayor al Monto Pendiente de Cobro.");
							$('#montoSeguroCobro').focus();
		   					$('#montoSeguroCobro').select();
							soloLecturaEntradasSalidasEfectivo();
							deshabilitaBoton('graba', 'submit');
						}else if(montoACobrar <= 0){
							soloLecturaEntradasSalidasEfectivo();
							deshabilitaBoton('graba', 'submit');
						}else{
							habilitaEntradasSalidasEfectivo();
						}
				}

			//***** FIN FUNCIONES PARA EL COBRO DEL SEGURO DE VIDA


			//----------------------------------- para integrantes y garantia adicional
			function mostrarIntegrantesGrupo(valorGrupo, valor){
				var params = {};
				params['tipoLista'] = 7;
				params['controlIntegrante'] = 1;
				params['grupoID'] = valorGrupo;
				params['ciclo'] = $('#cicloID').val();
				$.post("listaIntegrantesGpo.htm", params, function(data){
					if(data.length >0) {
						$('#gridIntegrantes').html(data);
							muestraAlertIntCtaGl=0;
						$('input[name=cuentaGLID]').each(function() {
							consultaCtaGarantiaAdicionalGrupo(this.id);
							$('#sumaExigibleInt').formatCurrency({
								positiveFormat: '%n',
								roundToDecimalPlace: 2
							});
							$('#sumaPendienteGarAdiInt').val(valor);
							$('#sumaPendienteGarAdiInt').formatCurrency({
								positiveFormat: '%n',
								roundToDecimalPlace: 2
							});
						});
						$('#gridIntegrantes').show();
						$('#impTicket').hide();
						$('#impCheque').hide();
						ocultarBtnResumen();
						sugerirGarAdiNoProrrateo(valor);
					}else{
						$('#gridIntegrantes').html("");
						$('#gridIntegrantes').hide();
					}
				});
			}
			// finiquito de credito Grupal
			function mostrarIntegrantesGrupoFiniquito(valorGrupo, valor){
				var params = {};
				params['tipoLista'] = 8;
				params['controlIntegrante'] = 1;
				params['grupoID'] = valorGrupo;
				params['ciclo'] = $('#cicloID').val();
				$.post("listaIntegrantesGpo.htm", params,{ async: false, callback: function(data){
					if(data.length >0) {
						$('#gridIntegrantes').html(data);
							muestraAlertIntCtaGl=0;
						$('input[name=cuentaGLID]').each(function() {
							consultaCtaGarantiaAdicionalGrupo(this.id);
							$('#sumaExigibleInt').formatCurrency({
								positiveFormat: '%n',
								roundToDecimalPlace: 2
							});
							$('#sumaPendienteGarAdiInt').val(valor);
							$('#sumaPendienteGarAdiInt').formatCurrency({
								positiveFormat: '%n',
								roundToDecimalPlace: 2
							});
							sugerirGarAdiNoProrrateo(valor);
						});
						$('#gridIntegrantes').show();
						$('#impTicket').hide();
						$('#impCheque').hide();
						ocultarBtnResumen();
					}else{
						$('#gridIntegrantes').html("");
						$('#gridIntegrantes').hide();
					}
				}

				});
			}

			function sugerirGarAdiNoProrrateo(valor){
				contador = 0;
				$('input[name=cuentaGLID]').each(function() {
					contador = contador + 1;
					ctaGLAdiID = eval("'#cuentaGLID"+contador+"'");
					glAdicionalID = eval("'#garantiaAdicional"+contador+"'");
					clienteID = eval("'#clienteIDIntegrante"+contador+"'");
					if($('#prorrateoPago').val()=="S"){ // si permite prorrateo de pago entonces se ejecuta el procedimiento grupal // si permite prorrateo de pago entonces se ejecuta el procedimiento grupal

					}else{
						if($(clienteID).asNumber() == $('#clienteID').asNumber()){
							$('#sumaGarantiaAdicionalInt').val(valor);
							$(glAdicionalID).val(valor);
							$(glAdicionalID).formatCurrency({
								positiveFormat: '%n',
								roundToDecimalPlace: 2
							});
							$('#sumaGarantiaAdicionalInt').formatCurrency({
								positiveFormat: '%n',
								roundToDecimalPlace: 2
							});
							$('#sumaPendienteGarAdiInt').val("0.00");
						}
					}
				});


			}
			// valida que el monto de la garantia adicional sea correcto
			function validaMontoGarantiaAdicional(){
				if($('#garantiaAdicionalPC').asNumber()<=0){
					if($('#montoPagar').asNumber()==0 && $('#pagoExigible').asNumber() >0){
						$('#sumaPendienteGarAdiInt').val($('#garantiaAdicionalPC').val());
						$('#montoPagadoCredito').val($('#montoPagar').asNumber());
						sugerirGarAdiNoProrrateo($('#garantiaAdicionalPC').asNumber());
					}else{
						$('#garantiaAdicionalPC').val("0.00");
						$('#garantiaAdicionalPC').val("0.00");
						$('#sumaPendienteGarAdiInt').val("0.00");
						$('#montoPagadoCredito').val($('#montoPagar').asNumber());
						sugerirGarAdiNoProrrateo('0.00');
					}
				}else{
					if($('#garantiaAdicionalPC').asNumber()>$('#montoPagar').asNumber()){
						if($('#montoPagar').asNumber()==0 && $('#pagoExigible').asNumber() >0){
							$('#sumaPendienteGarAdiInt').val($('#garantiaAdicionalPC').val());
							$('#montoPagadoCredito').val($('#montoPagar').asNumber());
							sugerirGarAdiNoProrrateo($('#garantiaAdicionalPC').asNumber());
						}else{
							$('#garantiaAdicionalPC').val("0.00");
							$('#sumaPendienteGarAdiInt').val("0.00");
							$('#montoPagadoCredito').val($('#montoPagar').asNumber());
							sugerirGarAdiNoProrrateo("0.00");
						}
					}else{
						if($('#montoPagar').asNumber()< $('#pagoExigible').asNumber()){
							$('#garantiaAdicionalPC').val("0.00");
							$('#sumaPendienteGarAdiInt').val("0.00");
							$('#montoPagadoCredito').val($('#montoPagar').asNumber());
							mensajeSis("En Pago Incompleto no hay Garantía Adicional.");
							sugerirGarAdiNoProrrateo("0.00");
						}else{
							if($('#montoPagar').asNumber()== $('#pagoExigible').asNumber()){
								$('#garantiaAdicionalPC').val("0.00");
								$('#sumaPendienteGarAdiInt').val("0.00");
								$('#montoPagadoCredito').val($('#montoPagar').asNumber());
								sugerirGarAdiNoProrrateo("0.00");
							}else{
								if($('#montoPagar').asNumber()>$('#pagoExigible').asNumber()&& $('#montoPagar').asNumber()<$('#montoTotExigiblePC').asNumber()){
									if($('#garantiaAdicionalPC').asNumber()<=$('#montoPagar').asNumber()){
										if(($('#montoPagar').asNumber()-$('#garantiaAdicionalPC').asNumber())<$('#pagoExigible').asNumber()){
											mensajeSis("La Garantía Adicional Debe ser la Diferencia entre el \nPago exigible y el Monto a Pagar.");
											$('#garantiaAdicionalPC').val("0.00");
											$('#sumaPendienteGarAdiInt').val("0.00");
											$('#garantiaAdicionalPC').focus();
											$('#montoPagadoCredito').val($('#montoPagar').asNumber());
											sugerirGarAdiNoProrrateo("0.00");
										}else{
											$('#montoPagadoCredito').val($('#montoPagar').asNumber()-$('#garantiaAdicionalPC').asNumber());
											if($('#garantiaAdicionalPC').asNumber()<$('#sumaGarantiaAdicionalInt').asNumber()){
												limpiarCamposMontoGLAdiInt();
												$('#sumaPendienteGarAdiInt').val($('#garantiaAdicionalPC').asNumber());
											}else{
												$('#sumaPendienteGarAdiInt').val($('#garantiaAdicionalPC').asNumber()-$('#sumaGarantiaAdicionalInt').asNumber());
											}
											$('#sumaPendienteGarAdiInt').formatCurrency({
												positiveFormat: '%n',
												roundToDecimalPlace: 2
											});
											sugerirGarAdiNoProrrateo($('#garantiaAdicionalPC').asNumber());
										}
									}else{
										if($('#garantiaAdicionalPC').asNumber()==0){
											$('#garantiaAdicionalPC').val("0.00");
											$('#sumaPendienteGarAdiInt').val("0.00");
											$('#montoPagadoCredito').val($('#montoPagar').asNumber());
											sugerirGarAdiNoProrrateo("0.00");
										}else{
											mensajeSis("La Garantia Adicional debe ser la Diferencia entre el \nPago Exigible y el Monto a Pagar.");
											$('#garantiaAdicionalPC').val("0.00");
											$('#sumaPendienteGarAdiInt').val("0.00");
											$('#garantiaAdicionalPC').focus();
											$('#montoPagadoCredito').val($('#montoPagar').asNumber());
											sugerirGarAdiNoProrrateo("0.00");
										}
									}
									sugerirGarAdiNoProrrateo($('#garantiaAdicionalPC').asNumber());
								}else{
									if($('#montoPagar').asNumber()>$('#montoTotExigiblePC').asNumber()){
										if($('#garantiaAdicionalPC').asNumber()<=$('#montoPagar').asNumber()){
											if(($('#montoPagar').asNumber()-$('#garantiaAdicionalPC').asNumber()).toFixed(2) <$('#pagoExigible').asNumber()){
												mensajeSis("La Garantía Adicional debe ser la Diferencia entre el \nPago Exigible y el Monto a Pagar.");
												$('#garantiaAdicionalPC').val("0.00");
												$('#sumaPendienteGarAdiInt').val("0.00");
												$('#garantiaAdicionalPC').focus();
												$('#montoPagadoCredito').val($('#montoPagar').asNumber());
												sugerirGarAdiNoProrrateo("0.00");
											}else{
												$('#montoPagadoCredito').val($('#montoPagar').asNumber()-$('#garantiaAdicionalPC').asNumber());
												if($('#garantiaAdicionalPC').asNumber()<$('#sumaGarantiaAdicionalInt').asNumber()){
													limpiarCamposMontoGLAdiInt();
													$('#sumaPendienteGarAdiInt').val($('#garantiaAdicionalPC').asNumber());
												}else{
													$('#sumaPendienteGarAdiInt').val($('#garantiaAdicionalPC').asNumber()-$('#sumaGarantiaAdicionalInt').asNumber());
												}
												$('#sumaPendienteGarAdiInt').formatCurrency({
													positiveFormat: '%n',
													roundToDecimalPlace: 2
												});
												sugerirGarAdiNoProrrateo($('#garantiaAdicionalPC').asNumber());
											}
										}else{
											if($('#garantiaAdicionalPC').asNumber()==0){
												$('#garantiaAdicionalPC').val("0.00");
												$('#sumaPendienteGarAdiInt').val("0.00");
												$('#montoPagadoCredito').val($('#montoPagar').asNumber());
												sugerirGarAdiNoProrrateo("0.00");
											}else{
												mensajeSis("La Garantía Adicional Debe ser la Diferencia entre el \nPago Exigible Grupal y el Monto a Pagar.");
												$('#garantiaAdicionalPC').val("0.00");
												$('#sumaPendienteGarAdiInt').val("0.00");
												$('#garantiaAdicionalPC').focus();
												$('#montoPagadoCredito').val($('#montoPagar').asNumber());
												sugerirGarAdiNoProrrateo("0.00");
											}
										}
									}
								}
							}
						}
					}
				}
			}

			// funcion para validar si se activa pago por garantia liquida adicional
			// no se puede tener gl adicional si la opcion seleccionada es finiquito.
			function validaGarantiaAdicional(){// ppppp
				var montoPag =$('#montoPagar').asNumber();
				var pagoExigible =$('#pagoExigible').asNumber();
				var totalAdeudo =$('#adeudoTotal').asNumber();
				var montoGarantiaAdicional =$('#garantiaAdicionalPC').asNumber();
				var pagoExigibleGrupal=0;
				var totalAdeudoGrupal =0;
				if($('#totalAde').is(':checked')){
					if($('#grupoID').val() > 0){
						if($('#prorrateoPagoCred').val() == 'S'){
							totalAdeudoGrupal=$('#montoTotDeudaPC').asNumber();
						}else{
							totalAdeudoGrupal=$('#adeudoTotal').asNumber();
							consultaCtaGarantiaAdicional($('#clienteID').val(), 'ctaGLAdiID') ;
						}
						if(montoPag > totalAdeudoGrupal ){
							if($('#aplicaGarAdiPagoCre').val() == 'S'){
								mensajeSis('El Monto a Pagar debe ser igual al Monto Total Adeudo Grupal.');
								$('#montoPagar').val(totalAdeudoGrupal);
								$('#montoPagar').focus();
								$('#montoPagar').select();

								mostrarIntegrantesGrupoFiniquito($('#grupoID').val(), totalAdeudoGrupal); // para mostrar integrantes del grupo
								$('#garantiaAdicionalPC').val("0.00");
								sugerirGarAdiNoProrrateo(0);
								$('#garantiaAdicionalPC').attr('readOnly',true);
								$('#montoPagadoCredito').val(totalAdeudoGrupal);
								agregaFormatoControles('formaGenerica');
								habilitarInputsGLAdi();

							}else{
								mostrarIntegrantesGrupoFiniquito($('#grupoID').val(), montoPag-totalAdeudoGrupal); // para mostrar integrantes del grupo
								//$('#ctaGLAdiID').val("");
								$('#garantiaAdicionalPC').val(montoPag-totalAdeudoGrupal);
								sugerirGarAdiNoProrrateo(montoPag-totalAdeudoGrupal);
								$('#garantiaAdicionalPC').attr('readOnly',true);
								$('#montoPagadoCredito').val(totalAdeudoGrupal);
								agregaFormatoControles('formaGenerica');
								habilitarInputsGLAdi();
							}
						}else{

							mostrarIntegrantesGrupoFiniquito($('#grupoID').val(), 0.00); // para mostrar integrantes del grupo

							$('#garantiaAdicionalPC').attr('readOnly',true);
							if(montoPag == totalAdeudoGrupal ){
								$('#garantiaAdicionalPC').val("0.00");
								sugerirGarAdiNoProrrateo("0.00");
								$('#montoPagadoCredito').val(totalAdeudoGrupal);
								$('#ctaGLAdiID').val("");
								deshabilitarInputsGLAdi();
								limpiarCamposMontoGLAdiInt();
							}else{
								if( totalAdeudoGrupal > 0  && montoPag == 0){

									$('#montoPagadoCredito').val(montoPag);
								}else{
									$('#garantiaAdicionalPC').val("0.00");
									sugerirGarAdiNoProrrateo("0.00");
									$('#montoPagadoCredito').val(montoPag);
									$('#ctaGLAdiID').val("");
									deshabilitarInputsGLAdi();
									limpiarCamposMontoGLAdiInt();
								}
							}
						}
					}else{
						if(montoPag > totalAdeudo ){
							if($('#aplicaGarAdiPagoCre').val() == 'S'){
								mensajeSis('El Monto a Pagar debe ser igual al Monto Total Adeudo.');
								$('#garantiaAdicionalPC').attr('readOnly',true);
								$('#ctaGLAdiID').val("");
								$('#garantiaAdicionalPC').val("0.00");
								sugerirGarAdiNoProrrateo("0.00");
								$('#montoPagadoCredito').val(totalAdeudo);
								$('#gridIntegrantes').html("");
								$('#gridIntegrantes').hide();
								$('#montoPagar').val(totalAdeudo);
								$('#montoPagar').focus();
								$('#montoPagar').select();
							}else{
								$('#garantiaAdicionalPC').attr('readOnly',true);
								consultaCtaGarantiaAdicional($('#clienteID').val(), 'ctaGLAdiID') ;
								$('#garantiaAdicionalPC').val(montoPag-totalAdeudo);
								sugerirGarAdiNoProrrateo(montoPag-totalAdeudo);
								$('#montoPagadoCredito').val(totalAdeudo);
								$('#gridIntegrantes').html("");
								$('#gridIntegrantes').hide();
								agregaFormatoControles('formaGenerica');
							}
						}else{

							$('#garantiaAdicionalPC').attr('readOnly',true);
							if(montoPag == totalAdeudo ){
								$('#ctaGLAdiID').val("");
								$('#garantiaAdicionalPC').val("0.00");
								sugerirGarAdiNoProrrateo("0.00");
								$('#montoPagadoCredito').val(totalAdeudo);
								$('#gridIntegrantes').html("");
								$('#gridIntegrantes').hide();
							}else{
								if(montoPag == 0 && totalAdeudo>0){
									$('#montoPagadoCredito').val(montoPag);
									$('#gridIntegrantes').html("");
									$('#gridIntegrantes').hide();
									$('#ctaGLAdiID').val("");
								}else{
									$('#garantiaAdicionalPC').val('0.00');
									sugerirGarAdiNoProrrateo("0.00");
									$('#montoPagadoCredito').val(montoPag);
									$('#gridIntegrantes').html("");
									$('#gridIntegrantes').hide();
									$('#ctaGLAdiID').val("");
								}
							}
						}
					}
				}

				if($('#exigible').is(':checked')){
					if($('#grupoID').val() > 0){
						if($('#prorrateoPagoCred').val() == 'S'){
							pagoExigibleGrupal=$('#montoTotExigiblePC').asNumber();
						}else{
							pagoExigibleGrupal=$('#pagoExigible').asNumber();
							consultaCtaGarantiaAdicional($('#clienteID').val(), 'ctaGLAdiID') ;
						}
						if($('#montoPagar').asNumber() > $('#pagoExigible').asNumber() ){
							$('#garantiaAdicionalPC').attr('readOnly',false);
							//$('#ctaGLAdiID').val("");
							mostrarIntegrantesGrupo($('#grupoID').val(), montoPag-pagoExigibleGrupal); // para mostrar integrantes del grupo
							if($('#montoPagar').asNumber()<= pagoExigibleGrupal){
								$('#garantiaAdicionalPC').val("0.00");
								$('#montoPagadoCredito').val($('#montoPagar').asNumber());
							}else{
								if($('#aplicaGarAdiPagoCre').val() == 'S' && montoPag > pagoExigibleGrupal){
									mensajeSis('El Monto a Pagar debe ser igual al Monto Exigible Grupal.');
									$('#garantiaAdicionalPC').val("0.00");
									habilitarInputsGLAdi();
									$('#montoPagadoCredito').val(pagoExigibleGrupal);
									sugerirGarAdiNoProrrateo(0);

									$('#montoPagar').val(pagoExigibleGrupal);
									$('#montoPagar').focus();
									$('#montoPagar').select();
								}else{
									$('#garantiaAdicionalPC').val(montoPag - pagoExigibleGrupal);
									habilitarInputsGLAdi();
									$('#montoPagadoCredito').val(pagoExigibleGrupal);
									sugerirGarAdiNoProrrateo(montoPag-pagoExigibleGrupal);
								}
							}
							agregaFormatoControles('formaGenerica');
						}else{
							$('#garantiaAdicionalPC').attr('readOnly',false);
							mostrarIntegrantesGrupo($('#grupoID').val(), 0.00); // para mostrar integrantes del grupo
							if(montoPag == pagoExigibleGrupal ){
								$('#garantiaAdicionalPC').val("0.00");
								sugerirGarAdiNoProrrateo("0.00");
								$('#montoPagadoCredito').val(pagoExigibleGrupal);
								$('#ctaGLAdiID').val("");
								limpiarCamposMontoGLAdiInt();
								deshabilitarInputsGLAdi();
							}else{
								if(montoPag == 0 &&  pagoExigibleGrupal  > 0 ){
									$('#montoPagadoCredito').val(montoPag);
								}else{
									$('#garantiaAdicionalPC').val("0.00");
									sugerirGarAdiNoProrrateo("0.00");
									$('#montoPagadoCredito').val(montoPag);
									$('#ctaGLAdiID').val("");
									limpiarCamposMontoGLAdiInt();
									deshabilitarInputsGLAdi();
								}
							}
						}
					}else{

						$('#garantiaAdicionalPC').attr('readOnly',true);
						if(montoPag > pagoExigible ){
							if($('#aplicaGarAdiPagoCre').val() == 'S'){
								mensajeSis('El Monto a Pagar debe ser igual al Monto Exigible.');
								$('#ctaGLAdiID').val("");
								$('#garantiaAdicionalPC').val("0.00");
								sugerirGarAdiNoProrrateo("0.00");
								$('#montoPagadoCredito').val(pagoExigible);
								$('#gridIntegrantes').html("");
								$('#gridIntegrantes').hide();

								$('#montoPagar').val(pagoExigible);
								$('#montoPagar').focus();
								$('#montoPagar').select();
							}else{
								consultaCtaGarantiaAdicional($('#clienteID').val(), 'ctaGLAdiID') ;
								$('#garantiaAdicionalPC').val(montoPag-pagoExigible);
								sugerirGarAdiNoProrrateo(montoPag-pagoExigible);
								$('#montoPagadoCredito').val(pagoExigible);
								$('#gridIntegrantes').html("");
								$('#gridIntegrantes').hide();
								agregaFormatoControles('formaGenerica');
							}
						}else{
							if(montoPag == pagoExigible ){
								$('#ctaGLAdiID').val("");
								$('#garantiaAdicionalPC').val("0.00");
								sugerirGarAdiNoProrrateo("0.00");
								$('#montoPagadoCredito').val(pagoExigible);
								$('#gridIntegrantes').html("");
								$('#gridIntegrantes').hide();
							}else{
								if(montoPag == 0 && pagoExigible>0){
									$('#montoPagadoCredito').val(montoPag);
									$('#gridIntegrantes').html("");
									$('#gridIntegrantes').hide();
									$('#ctaGLAdiID').val("");
								}else{
									$('#garantiaAdicionalPC').val('0.00');
									sugerirGarAdiNoProrrateo("0.00");
									$('#montoPagadoCredito').val(montoPag);
									$('#gridIntegrantes').html("");
									$('#gridIntegrantes').hide();
									$('#ctaGLAdiID').val("");
								}
							}
						}
					}
				}
				return procedeGLAdi;
			}


			// funcion para validar que la suma de la GL adicional de los  integrantes
			// sea igual al monto de gl adicional indicado
			function validaSumaGarantiaAdicionalGrupo(){
				if($('#sumaGarantiaAdicionalInt').asNumber() == $('#garantiaAdicionalPC').asNumber()){
					procedeGLAdi = 1;
				}else{
					procedeGLAdi = 2;
					mensajeSis("La suma de la Garantía Adicional de los Integrantes \nDebe de ser Igual que la Garantía Adicional.");
					$('#garantiaAdicionalPC').focus();
				}
				return procedeGLAdi;
			}

		// funcion para consultar la cuenta de garantia liquida adicional del cliente
		function consultaCtaGarantiaAdicional(clienteID, ctaGLAdiID) {
			ctaGLAdiID = eval("'#"+ctaGLAdiID+"'");
			var tipConCtaGLAdi= 16;
			var CuentaAhoBeanCon = {
				'clienteID'	:clienteID,
				'cuentaAhoID' : $('#cuentaID').val()
			};
			setTimeout("$('#cajaLista').hide();", 200);
			if(clienteID != '' && !isNaN(clienteID)){
				cuentasAhoServicio.consultaCuentasAho(tipConCtaGLAdi, CuentaAhoBeanCon,{ async: false, callback:function(cuenta) {
					if(cuenta!=null){
						$(ctaGLAdiID).val(cuenta.cuentaAhoID);
						$('#impTicket').hide();
						$('#impCheque').hide();
						ocultarBtnResumen();
					}else{
						mensajeSis("El Cliente: "+clienteID+" No tiene una Cuenta para Depositar la \nGarantía Líquida Adicional.");
						$('#garantiaAdicionalPC').val("0.00");
						$('#montoPagar').val($('#pagoExigible').val());
					}
				}
				});
			}
		}

		// funcion para consultar la cuenta de garantia liquida adicional del cliente
		function consultaCtaGarantiaAdicionalGrupo(ctaGLAdiID) {
			var numero= ctaGLAdiID.substr(10,ctaGLAdiID.length);
			var clienteID = eval("'#clienteIDIntegrante"+numero+"'");
			var creditoIDInt = $('#creditoIDIntegrante'+numero).val();
			var valorclienteID = $(clienteID).val();
			var cuentaGLInte = '';

			//Obtenemos la cuenta ligada al crédito
			var creditoBeanCon = {
						'creditoID':creditoIDInt,
		  				'fechaActual':$('#fechaSistema').val()
		  			};

		  	creditosServicio.consulta(18,creditoBeanCon,function(credito) {//catTipoConsultaCredito.saldos
		   				cuentaGLInte = credito.cuentaID;

						ctaGLAdiID = eval("'#"+ctaGLAdiID+"'");
						var tipConCtaGLAdi= 16;
						var CuentaAhoBeanCon = {
							'clienteID'	:valorclienteID,
							'cuentaAhoID' : cuentaGLInte,
						};



						setTimeout("$('#cajaLista').hide();", 200);
						if(valorclienteID != '' && !isNaN(valorclienteID)){
							cuentasAhoServicio.consultaCuentasAho(tipConCtaGLAdi, CuentaAhoBeanCon,function(cuenta) {
								if(cuenta!=null){
									$(ctaGLAdiID).val(cuenta.cuentaAhoID);
									$('#impTicket').hide();
									$('#impCheque').hide();
									ocultarBtnResumen();
								}else{
									if(muestraAlertIntCtaGl == 0  && $('#garantiaAdicionalPC').asNumber() > 0 ){
										mensajeSis("El Cliente: "+valorclienteID+" No tiene una Cuenta para Depositar la \nGarantía Líquida Adicional.");
										muestraAlertIntCtaGl = 1;
										$('#garantiaAdicionalPC').val("0.00");
										$('#montoPagar').val($('#pagoExigible').val());
									}

								}
							});
						}

					});




		}

		// XX.XX
		function crearListaCuentasGLAdicional(){
			var contador = 0;
			var ctaGLAdiID = 0;
			var glAdicionalID = 0;
			var clienteID = 0;
			$('#listaCuentasGLAdicional').val("");
			$('input[name=cuentaGLID]').each(function() {
				contador = contador + 1;
				ctaGLAdiID = eval("'#cuentaGLID"+contador+"'");
				glAdicionalID = eval("'#garantiaAdicional"+contador+"'");
				clienteID = eval("'#clienteIDIntegrante"+contador+"'");
				if(contador ==1){
					$('#listaCuentasGLAdicional').val(
							$(ctaGLAdiID).asNumber()+"]"+$(glAdicionalID).asNumber()+"]"+$(clienteID).asNumber());
				}else{
					$('#listaCuentasGLAdicional').val($('#listaCuentasGLAdicional').val()+"["+
							$(ctaGLAdiID).asNumber()+"]"+$(glAdicionalID).asNumber()+"]"+$(clienteID).asNumber());
				}
			});
		}


		// funcion para  imprimir los tickets imm
		function imprimirTicketTransaccion(BotonOrigen){
			switch($('#tipoTransaccion').val()) {
				case catTipoTransaccionVen.abonoCuenta:
					reimprimeTickets(2,$('#numeroTransaccion').val());
				break;
				case catTipoTransaccionVen.cargoCuenta:
					reimprimeTickets(1,$('#numeroTransaccion').val());
				break;
				case catTipoTransaccionVen.garantiaLiq:
					var formaPago='';
					if($('#pagoGLEfectivo').attr('checked')==true){
						formaPago= 'EFECTIVO' ;
					}else{
						formaPago= 'CARGO A CUENTA' ;
					}
					var descCredito = $("#referenciaGL :selected").text();

					var partesCredito = [];
					var nombreCredito = "";
					if(descCredito != null) {
						partesCredito =  descCredito.split("-");
					}

					if(partesCredito.length > 1) {
						nombreCredito = partesCredito[1];
					}

				    var impresionGarantiaLiqBean={
			         'folio' 	        :$('#numeroTransaccion').val(),
			         'tituloOperacion2' :'DEPOSITO DE GARANTIA LIQUIDA',
				     'clienteID' 		:$('#numClienteGL').val(),
				     'nombreCliente'    :$('#nombreClienteGL').val(),
			         'noCuenta'        	:$('#cuentaAhoIDGL').val(),
				     'grupo'         	:$('#grupoDesGL').val(),
			         'ciclo'           	:$('#cicloIDGL').val(),
				     'noCredito'        :$('#referenciaGL').val(),
				     'montDep'          :$('#montoGarantiaLiq').val(),
			         'montRec'          :$('#totalEntradas').val(),
				     'cambio'           :$('#sumTotalSal').val(),
				     'proCred'          :nombreCredito,
			         'moneda'           :monedaBase,
			         'formaPago'		:formaPago
				    };

		           imprimeTicketGarantiaLiq(impresionGarantiaLiqBean);

				break;
				case catTipoTransaccionVen.comisionApertura:
				  var impresionComisionAperturaBean={
				         'folio'	        :$('#numeroTransaccion').val(),
		                 'tituloOperacion3' :'COMISION POR APERTURA',
		                 'clienteID' 		:$('#clienteIDAR').val(),
		                 'nombreCliente'    :$('#nombreClienteAR').val(),
		                 'noCuenta'         :$('#cuentaAhoIDAR').val(),
		                 'desCuenta'        :$('#nomCuentaAR').val(),
		                 'proCred'          :$('#desProdCreditoAR').val(),
		                 'grupo'            :$('#grupoDesAR').val(),
		                 'comision'         :$('#comisionAR').val(),
		                 'iva'              :$('#ivaAR').val(),
		                 'total'            :$('#totalDepAR').val(),
		                 'montoReci'        :$('#sumTotalEnt').val(),

		                 'cambio'           :$('#sumTotalSal').val(),
		                 'NoCredito'        :$('#creditoIDAR').val(),
		                 'montPago'         :$('#totalDepAR').val(),
		                 'moneda'            :monedaBase,
		                 'ciclo'            :$('#cicloIDAR').val(),


				};
					  imprimeTicketComisionApertura(impresionComisionAperturaBean);

				break;
				case catTipoTransaccionVen.cobroSeguroVida:
				   var impresionCobroSegVidaBean={
				   	    'folio' 	        :$('#numeroTransaccion').val(),
				        'tituloOperacion4'  :'COBRO POLIZA COBERTURA DE RIESGO',
					    'clienteID' 		:$('#clienteIDSC').val(),
					    'nombreCliente'     :$('#nombreClienteSC').val(),
				        'efectivo'          :$('#montoSeguroCobro').val(),
		   				'moneda'            :monedaBase,
					};
				   imprimeTicketCobroSegVida(impresionCobroSegVidaBean);

				break;
				case catTipoTransaccionVen.desembolsoCredito:
					var porDesem = $('#montoPorDesemDC').asNumber()-$('#totalRetirarDC').asNumber();
					if (BotonOrigen=="G"){
						SaldoTotalAho=$('#saldoAhoCre').asNumber()-$('#totalRetirarDC').asNumber();
					}else{
						$('#saldoAhoCre').val(SaldoTotalAho);
						$('#saldoAhoCre').val($('#saldoAhoCre').asNumber()+$('#totalRetirarDC').asNumber());
					}

					var impresionDesemCreditoBean={
					    'folio' 	        :$('#numeroTransaccion').val(),
				        'tituloOperacion'  :'DESEMBOLSO DE CREDITO',
					    'clienteID' 	    :$('#clienteIDDC').val(),
					    'nombreCliente'     :$('#nombreClienteDC').val(),
				        'noCuenta'          :$('#cuentaAhoIDDC').val(),
				        'tipoCuenta'        :$('#nomCuentaDC').val(),
					    'credito'        	:$('#creditoIDDC').val(),
					    'proCred'          :$('#desProdCreditoDC').val(),
					    'proCred2'          :$('#productoCreditoIDDC').val(),
				        'moneda'            :monedaBase,
					    'grupo'             :$('#grupoDesDC').val(),
				        'montoCred'         :$('#montoCreDC').val(),
				        'monRecAnt'  	    :$('#totalDesembolsoDC').val(),
				        'montRet'        	:$('#totalRetirarDC').val(),
				        'montoPend'      	:porDesem,//$('#montoPorRetirarActDC').val(),
				        'ciclo'          	:$('#cicloIDDC').val(),
				        'saldoIniAho'		:$('#saldoAhoCre').val(),
				        'saldoActAho'		:SaldoTotalAho
					};
					if (BotonOrigen=="I"){
						impresionDesemCreditoBean.saldoIniAho=cantidadFormatoMoneda(impresionDesemCreditoBean.saldoIniAho);
					}
					imprimeTicketDesemCredito(impresionDesemCreditoBean);

			    break;
				case catTipoTransaccionVen.devolucionGL:
					var impresionDevolucionGL={
					    'folio' 	        :$('#numeroTransaccion').val(),
				        'tituloOperacion' 	:'DEVOLUCION DE GARANTIA LIQUIDA',
					    'clienteID' 	    :$('#numClienteDG').val(),
					    'nombreCliente'     :$('#nombreClienteDG').val(),
				        'noCuenta'          :$('#cuentaAhoIDDG').val(),
				        'tipoCuenta'        :$('#tipoCuentaDG').val(),
					    'creditoID'        	:$('#creditoDGL').val(),
				        'moneda'            :monedaBase,
				        'monto'		        :$('#montoDevGL').val(),
					    'grupo'             :$('#grupoDesDGL').val(),
				        'ciclo'          	:$('#cicloIDDGL').val(),
				        'proCred'          	:$('#desProducCreditoDGL').val(),


					};
			       imprimeTicketDevGL(impresionDevolucionGL);
			    break;
				case catTipoTransaccionVen.cambioEfectivo:
					var impresionCambioEfectivo={
					    'folio' 	        :$('#numeroTransaccion').val(),
				        'tituloOperacion' 	:'CAMBIO DE EFECTIVO',
					    'monto' 	    	:$('#sumTotalEnt').val(),
					    'moneda'            :monedaBase,
					};
				       imprimeTicketCambioEfectivo(impresionCambioEfectivo);

				break;
				case catTipoTransaccionVen.transferenciaCuenta:
					var impresionTransfCuenta={
					    'folio' 	        :$('#numeroTransaccion').val(),
				        'tituloOperacion' 	:'TRASPASO ENTRE CUENTAS',
				        'clienteID' 		:$('#numClienteT').val(),
				        'nomCliente' 		:$('#nombreClienteT').val(),
				        'referencia' 		:$('#referenciaT').val(),
				        'cuentaRetiro' 		:$('#cuentaAhoIDT').val(),
				        'etiquetaCtaRet' 	:$('#etiquetaCuentaCargo').val(),
				        'tipoCtaRetiro' 	:$('#tipoCuentaT').val(),
				        'cuentaDeposito' 	:$('#cuentaAhoIDTC').val(),
					    'etiquetaCtaDep' 	:$('#etiquetaCuentaAbono').val(),
					    'tipoCtaAbono' 	    :$('#tipoCuentaTC').val(),
					    'monto' 	    	:$('#montoCargarT').val(),
					    'moneda'            :monedaBase,
					};
				       imprimeTicketTransferencia(impresionTransfCuenta);

				break;
				case catTipoTransaccionVen.aportacionSocial:
					var impresionAportaSocioBean={
					    'folio' 	        :$('#numeroTransaccion').val(),
				        'tituloOperacion'   :'DEPOSITO APORTACION SOCIO',
					    'clienteID' 		:$('#clienteIDAS').val(),
					    'nombreCliente'     :$('#nombreClienteAS').val(),
				        'montoAportacion'   :$('#montoAS').val(),
					    'moneda'            :monedaBase,
				        'montoRec'          :$('#sumTotalEnt').val(),
				        'cambio'            :$('#sumTotalSal').val(),
					};

						imprimeTicketAportacionSocio(impresionAportaSocioBean);
				break;
				case catTipoTransaccionVen.devAportacionSocio:
					var impresionDevAportaSocioBean={
					    'folio' 	        :$('#numeroTransaccion').val(),
				        'tituloOperacion'   :'DEVOLUCION APORTACION SOCIAL',
					    'clienteID' 		:$('#clienteIDDAS').val(),
					    'nombreCliente'     :$('#nombreClienteDAS').val(),
				        'montoDevolucion'   :$('#montoDAS').val(),
					    'moneda'            :monedaBase,
				        'montoRec'          :$('#sumTotalEnt').val(),
				        'cambio'            :$('#sumTotalSal').val(),
					};

					imprimeTicketDevAportacionSocioSocio(impresionDevAportaSocioBean);
				break;
				case catTipoTransaccionVen.cobroSegVidaAyuda:
				      var impresionCobroSegAyudaBean={
				   	    'folio' 	        :$('#numeroTransaccion').val(),
				        'tituloOperacion'  :'APORTACION APOYO TU AYUDA',
					    'clienteID' 		:$('#clienteIDCSVA').val(),
					    'nombreCliente'     :$('#nombreClienteCSVA').val(),
				        'efectivo'          :$('#montoCobrarSeg').val(),
		 				'moneda'            :monedaBase,
					};
				   imprimeTicketCobroSeguroAyuda(impresionCobroSegAyudaBean);
				break;

				case catTipoTransaccionVen.aplicaSegVidaAyuda:
				      var impresionAplicaSegAyudaBean={
				   	    'folio' 	        :$('#numeroTransaccion').val(),
				        'tituloOperacion'  	:'PAGO DE APOYO TU AYUDA',
					    'clienteID' 		:$('#clienteIDASVA').val(),
					    'nombreCliente'     :$('#nombreClienteASVA').val(),
				        'efectivo'          :$('#montoPolizaSegAyudaCobroA').val(),
				        'poliza'          	:$('#numeroPolizaSVAA').val(),
				        'moneda'            :monedaBase,
					};
				   imprimeTicketAplicaSeguroAyuda(impresionAplicaSegAyudaBean);
				break;

				case catTipoTransaccionVen.pagoRemesas:
					var formaPago='';
					var clienteIDRemesa = '';
					var nombreClienteRemesa = '';

					if($('#pagoServicioRetiro').attr('checked')== true){
						formaPago= 'Efectivo' ;
					}else if($('#pagoServicioDeposito').attr('checked')== true){
						formaPago= 'Deposito a Cuenta' ;
					}else if($('#pagoServicioCheque').attr('checked')== true){
						formaPago= 'Cheque' ;
					}

					if ($('#clienteIDServicio').val() != '' || $('#clienteIDServicio').val() != 0) {
						clienteIDRemesa = $('#clienteIDServicio').val();
						nombreClienteRemesa = $('#nombreClienteServicio').val();
					} else{
						clienteIDRemesa = 0;
						nombreClienteRemesa = $('#nombreUsuarioRem').val();
					};

				      var impresionPagoRemesaBean={
				   	    'folio' 	        	:$('#numeroTransaccion').val(),
				        'tituloOperacion'  		:'PAGO DE REMESAS',
					    'clienteID' 			:clienteIDRemesa,
					    'nombreCliente'    	 	:nombreClienteRemesa,
					    'telefonoCliente'   	:$('#telefonoClienteServicio').val(),

					    'tipoIdentificacion'   	:$("#indentiClienteServicio option:selected").html(),
					    'folioIdentificacion'   :$('#folioIdentiClienteServicio').val(),
					    'formaPago'   			:formaPago,
					    'numeroCuenta'   		:$('#numeroCuentaServicio').val(),
					    'referencia'		 	:$('#referenciaServicio').val(),
					    'monto'		 			:$('#montoServicio').val(),
				        'moneda'           		:monedaBase,
					};
				   imprimeTicketPagoServicio(impresionPagoRemesaBean);
				break;
				case catTipoTransaccionVen.pagoOportunidades:
					var formaPago='';
					var clienteIDRemesa = '';
					var nombreClienteRemesa = '';

					if($('#pagoServicioRetiro').attr('checked')== true){
						formaPago= 'Efectivo' ;
					}else if($('#pagoServicioDeposito').attr('checked')== true){
						formaPago= 'Deposito a Cuenta' ;
					}else if($('#pagoServicioCheque').attr('checked')== true){
						formaPago= 'Cheque' ;
					}
					if ($('#clienteIDServicio').val() != '' || $('#clienteIDServicio').val() != 0) {
						clienteIDRemesa = $('#clienteIDServicio').val();
						nombreClienteRemesa = $('#nombreClienteServicio').val();
					} else{
						clienteIDRemesa = 0;
						nombreClienteRemesa = $('#nombreUsuarioRem').val();
					};
				      var impresionPagooportunidadesBean={
				   	    'folio' 	        	:$('#numeroTransaccion').val(),
				        'tituloOperacion'  		:'PAGO DE OPORTUNIDADES',
					    'clienteID' 			:clienteIDRemesa,
					    'nombreCliente'    	 	:nombreClienteRemesa,
					    'telefonoCliente'   	:$('#telefonoClienteServicio').val(),

					    'tipoIdentificacion'   	:$("#indentiClienteServicio option:selected").html(),
					    'folioIdentificacion'   :$('#folioIdentiClienteServicio').val(),
					    'formaPago'   			:formaPago,
					    'numeroCuenta'   		:$('#numeroCuentaServicio').val(),
					    'referencia'		 	:$('#referenciaServicio').val(),
					    'monto'		 			:$('#montoServicio').val(),
				        'moneda'           		:monedaBase,
					};
				   imprimeTicketPagoServicio(impresionPagooportunidadesBean);
				break;
				case catTipoTransaccionVen.recepcionChequeSBC:
					  var tituloOperacion = 'RECEPCION DE CHEQUE SBC';
					  if ($('#tipoCtaCheque').val() == 'I'){
						  tituloOperacion = 'CAMBIO DE CHEQUE INTERNO';
					  }
				      var impresionRecepChequeSBCBean={
				   	    'folio' 	        	:$('#numeroTransaccion').val(),
				        'tituloOperacion'  		:tituloOperacion,
					    'clienteID' 			:$('#clienteIDSBC').val(),
					    'nombreCliente'    	 	:$('#nombreClienteSBC').val(),
					    'numeroCuenta'   		:$('#numeroCuentaRec').val(),
					    'formaCobro'   			:'CHEQUE SBC',
					    'cuentaEmisor'   		:$('#numeroCuentaEmisorSBC').val(),
					    'emisor'   				:$('#nombreEmisorSBC').val(),
					    'numCheque'   			:$('#numeroChequeSBC').val(),
					    'monto'		 			:$('#montoSBC').val(),
				        'moneda'           		:monedaBase,
				        'numBanco'				:$('#bancoEmisorSBC').val(),
						'nombreBanco'			:$('#nombreBancoEmisorSBC').val()
					};
				      imprimeTicketChequeSBC(impresionRecepChequeSBCBean);
				break;
				case catTipoTransaccionVen.aplicaChequeSBC:
				      var impresionAplicaChequeSBCBean={
						  	'folio' 	        	:$('#numeroTransaccion').val(),
					        'tituloOperacion'  		:'APLICACION DE CHEQUE SBC',
						    'clienteID' 			:$('#clienteIDSBCAplic').val(),
						    'nombreCliente'    	 	:$('#nombreClienteSBCAplic').val(),
						    'numeroCuenta'   		:$('#numeroCuentaSBC').val(),
						    'formaCobro'   			:'CHEQUE SBC',
						    'cuentaEmisor'   		:$('#numeroCuentaEmisorSBCAplic').val(),
						    'emisor'   				:$('#nombreEmisorSBCAplic').val(),
						    'numCheque'   			:$('#numeroChequeSBCAplic').val(),
						    'monto'		 			:$('#montoSBCAplic').val(),
					        'moneda'           		:monedaBase,
					        'numBanco'				:$('#bancoEmisorSBCAplic').val(),
							'nombreBanco'			:$('#nombreBancoEmisorSBCAplic').val()
					};
				      imprimeTicketChequeSBC(impresionAplicaChequeSBCBean);
				break; // SERVICIOS
				case catTipoTransaccionVen.pagoServicios:
					var TituloOperacionPagoServicio =('PAGO '+$("#catalogoServID option:selected").html()).toUpperCase();
				      var impresionPagoServicioBean={
						  	'folio' 	        	:$('#numeroTransaccion').val(),
					        'tituloOperacion'  		:TituloOperacionPagoServicio,
						    'clienteID' 			:$('#clienteIDCobroServ').val(),
						    'nombreCliente'    	 	:$('#nombreClientePagoServ').val(),
						    'prospectoID' 			:$('#prospectoIDServicio').val(),
						    'creditoID'				:$('#creditoIDServicio').val(),

						    'montoComision'   		:$('#montoComision').val(),
						    'IVAComision'   		:$('#ivaComision').val(),
						    'montoPagoServicio'   	:$('#montoPagoServicio').val(),
						    'IvaServicio'   		:$('#IvaServicio').val(),
						    'totalPagar'			:$('#totalPagar').val(),

						    'formaPago'   			:'EFECTIVO',
					        'moneda'           		:monedaBase,
					        'montoRecibido'			:$('#sumTotalEnt').val(),
					        'cambio'				:$('#sumTotalSal').val(),
					        'origenServicio'		:$('#origenServicio').val(),
					        'cobroComServicio'		:$('#cobroComisionPagoServicio').val(),
					        'requiereCteServicio'	:$('#requiereClienteServicio').val(),
					        'requiereCredServicio'	:$('#requiereCreditoServicio').val(),
					        'referencia'			:$('#referenciaPagoServicio').val()
					};
				      imprimeTicketCobroServicio(impresionPagoServicioBean);
				break;
				case catTipoTransaccionVen.recuperaCartera: // XX.XX
					var TituloOperacion ='PAGO DE CREDITO CASTIGADO';

					$('#montoPorRecuperarTotal').val($('#montoPorRecuperar').asNumber()-$('#montoRecuperar').asNumber());
					$('montoRecuperadoTotal').val($('#monRecuperado').asNumber()+$('#montoRecuperar').asNumber());

					$('#montoPorRecuperarTotal').formatCurrency({
						positiveFormat: '%n',
						roundToDecimalPlace: 2
					});
					$('#montoRecuperadoTotal').formatCurrency({
						positiveFormat: '%n',
						roundToDecimalPlace: 2
					});

				      var impresionCreditoCastigadoBean={
						  	'folio' 	        	:$('#numeroTransaccion').val(),
					        'tituloOperacion'  		:TituloOperacion,
					        'noCuenta'				:$('#cuentaAhoIDAb').val(),
						    'clienteID' 			:$('#clienteIDVencido').val(),
						    'nombreCliente'    	 	:$('#nombreClienteVencido').val(),
						    'creditoID'				:$('#creditoVencido').val(),
						    'productoCred'   		:$('#productoCreditoVencido').val(),
						    'descProduc'   			:$('#desProducVencido').val(),
						    'totalCastigado'   		:$('#totalCastigado').val(),
						    'monRecuperado'   		:$('#monRecuperado').asNumber()+ $('#montoRecuperar').asNumber(),
					        'moneda'           		:$('#desMonedaCartVencida').val(),
					        'totalPagar'			:$('#montoRecuperar').val(),
					        'montoRecibido'			:$('#sumTotalEnt').val(),
					        'cambio'				:$('#sumTotalSal').val(),
					        'montoPorRecuperar'		:$('#montoPorRecuperarTotal').val(),
					};
				      imprimeTicketCreditoCastigado(impresionCreditoCastigadoBean);
				break;
				case catTipoTransaccionVen.pagoServiciosEnLinea:
					var tituloOperacion = ('PAGO ' + $("#nombreProductoPSL").val()).toUpperCase();
					var tipoFormaPago = $("#formaPagoC").attr('checked')?'C':'E';
					var formaPago = $("#formaPagoC").attr('checked')?'Cargo a cuenta de ahorro':'Efectivo';
				    var impresionPagoServicioBean={
						  	'folio' 	        	:$('#numeroTransaccion').val(),
					        'tituloOperacion'  		:tituloOperacion,
						    'clienteID' 			:$('#clienteIDPSL').val(),
						    'nombreCliente'    	 	:$('#nombreClientePSL').val(),

						    'montoComision'   		:$('#comisiInstitucion').val(),
						    'IVAComision'   		:$('#ivaComisiInstitucion').val(),
						    'montoPagoServicio'   	:$('#precio').val(),
						    'comisionProveedor'		:$('#comisiProveedor').val(),
						    'IvaServicio'   		:0,
						    'totalPagar'			:$('#totalPagarPSL').val(),

						    'formaPago'   			:formaPago,
					        'moneda'           		:monedaBase,
					        'montoRecibido'			:$('#sumTotalEnt').val(),
					        'cambio'				:$('#sumTotalSal').val(),
					        'tipoFormaPago'			:tipoFormaPago,
					        'telefono' 				:$('#telefonoPSL').val(),
					        'referencia'			:$('#referenciaPSL').val()
					};
				    imprimeTicketPagoServiciosEnLinea(impresionPagoServicioBean);
				break;
				case catTipoTransaccionVen.cobroAccesoriosCre:
					var accesorioIDCA = $('#accesorioID')[0];
					var descAccesorio =  accesorioIDCA.options[accesorioIDCA.selectedIndex].text;

					var impresionAccesorioCreBean = {
						'folio'	        	:$('#numeroTransaccion').val(),
						'tituloOperacion'	:'ACCESORIOS DE CREDITO',
						'clienteID' 		:$('#clienteIDCA').val(),
						'nombreCliente'   	:$('#nombreClienteCA').val(),
						'noCuenta'        	:$('#cuentaAhoIDCAc').val(),
						'desCuenta'       	:$('#nomCuentaCA').val(),
						'proCred'         	:$('#desProdCreditoCA').val(),
						'grupo'           	:$('#grupoDesCA').val(),
						'comision'        	:$('#comisionCA').val(),
						'iva'             	:$('#ivaCA').val(),
						'total'           	:$('#totalDepCA').val(),
						'montoReci'       	:$('#sumTotalEnt').val(),
						'cambio'          	:$('#sumTotalSal').val(),
						'NoCredito'       	:$('#creditoIDCA').val(),
						'montPago'        	:$('#totalDepCA').val(),
						'moneda'            :monedaBase,
						'nomAccesorio' 		:descAccesorio
					};
					imprimeTicketAccesoriosCredito(impresionAccesorioCreBean);
					break;

				case catTipoTransaccionVen.depositoActivaCta:

					var impresionDepositoActivaCtaBean = {
						'folio' 			: $('#numeroTransaccion').val(),
						'tituloOperacion' 	: 'DEPÓSITO PARA ACTIVACIÓN DE CTA',
						'clienteID' 		: $('#clienteIDdepAct').val(),
						'nombreCliente' 	: $('#nombreClientedepAct').val(),
						'noCuenta' 			: $('#cuentaAhoIDdepAct').val(),
						'tipoCuenta' 		: $('#descTipoCuentaIDdepAct').val(),
						'refCuenta' 		: $('#refCuentaTicketdepAct').val(),

						'montoDep' 			: $('#montoDepositoActiva').val(),
						'moneda' 			: monedaBase,
						'montoRec'       	: $('#sumTotalEnt').val(),
						'cambio'          	: $('#sumTotalSal').val()
					};

					imprimeTicketDepositoActivaCta(impresionDepositoActivaCtaBean);

				break;
			}// switch
		}// funcion

		//gggg
		// funcion para consultar los integrantes del grupo de credito e imprimir el ticket
		function imprimirTicketPrepagoGrupal() {
			var PrepagoGrupal='G';
			var bean = {
					'grupoID':$('#grupoIDPre').val(),
					'cicloActual': $('#cicloIDPre').val()
				};

			var contador = 0;
			gruposCreditoServicio.listaConsulta(4, bean, function(credGrupo){
				for (var i = 0; i < credGrupo.length; i++){
					contador = contador +1;
					var creditoID=credGrupo[i].creditoID;
						imprimeTicketPrepagoCredito(creditoID,contador,PrepagoGrupal);
				}
				imprimeTicket();

			});
		}
		// funcion poara imprimir el ticket de Pago de Credito grupal e individual
		function imprimeTicketPrepagoCredito(credito,contador,tipoCredito){
			var tipoConsulta=1;
			var fechaPago=$('#fechaSistemaP').val();
			var transaccion=$('#numeroTransaccion').val();
			var beanDetalle = {
					'creditoID':credito,
					'fechaPago':fechaPago,
					'transaccion':transaccion

				};
				creditosServicio.consultaDetallePago(tipoConsulta, beanDetalle,
						{ async: false, callback:	function(detallePago){
							$('#saldoCapitalPre').val(detallePago.capital);
							$('#saldoCapitalInso').val(detallePago.capitalInsoluto);
							var impresionPrepagoCredito={
								    'folio' 	        :$('#numeroTransaccion').val(),
							        'tituloOperacion'   :'PREPAGO DE CREDITO',
								    'clienteID' 		:detallePago.clienteID,
								    'creditoID' 		:credito,
								    'nombreCliente'     :detallePago.nombreCompelto,
								    'montoPago'         :detallePago.montoTotal,
								    'proxFechaPago'     :detallePago.proximaFechaPago,
								    'montoProximoPago'  :detallePago.montoPagado ,
								    'moneda' 			: monedaBase,
								    'grupo'  			: $('#grupoDesPre').val(),
								    'ciclo'  			: $('#cicloIDPre').val(),
								    'capital'			: detallePago.capital,
								    'interes' 			: detallePago.interes,
								    'moratorios'		: detallePago.montoIntMora,
								    'comision'  		: detallePago.montoComision,
								    'comisionAdmon'		: detallePago.montoGastoAdmon,
								    'iva'  				: detallePago.montoIVA,
								    'total'				:'',
								    'montoRecibido'	  	:$('#sumTotalEnt').val() ,
								    'cambio' 		 	:$('#sumTotalSal').val(),
								    'saldoCapVigenteIni':$('#saldoCapitalPre').asNumber()+$('#saldoCapitalInso').asNumber(),
								    'saldoCapVigenteAct':detallePago.capitalInsoluto,
								    'cobraSeguroCuota'	:$('#cobraSeguroCuota').val(),
								    'montoSeguroCuota'	:detallePago.montoSeguroCuota,
								    'ivaSeguroCuota'	:detallePago.montoIVASeguroCuota,
								    'proCred'			:$('#descripcionProdPre').val() ,

							};
							imprimirTicketPrepagoCredito(impresionPrepagoCredito,contador, tipoCredito);
						}
					});

		}




			//Consulta si la caja esta Actual esta abierta y si es CA cual es su el ID de su CP
			function estaAbiertaCaja(sucursalID,cajaID,tipoCaja){
				 var CajasVentanillaBeanConCajSuc = {
				  			'cajaID': cajaID
						};
				 var conPrincipal = 3;
					cajasVentanillaServicio.consulta(conPrincipal, CajasVentanillaBeanConCajSuc ,function(cajasVentanillaConCaja){
						if(cajasVentanillaConCaja != null){
							if(cajasVentanillaConCaja.huellaDigital=="S"){
								$('#cajaRequiereHuella').val('S');
							}else{
								$('#cajaRequiereHuella').val('N');
							}
						if(cajasVentanillaConCaja.sucursalID != sucursalID){
							mensajeSis('No Puede Realizar esta Operación ya que la Sucursal del Cajero No concuerda con la Sucursal Asignada a la Caja.');
							deshabilitaItems();
						}else if(cajasVentanillaConCaja.estatusOpera == 'C'){
							deshabilitaItems();
							mensajeSis('La Caja se encuentra Cerrada. Apertura la Caja para Realizar Operaciones.');
						}else{
							habilitaItems();
						}
					}
				});
			 }

			 function deshabilitaItems(){
				$('#tipoOperacion').attr('disabled',true);
				$('#numCopias').attr('disabled',true);
				deshabilitaBoton('graba','submit');
				deshabilitaBoton('agregarEntEfec','submit');
				deshabilitaBoton('agregarSalEfec','submit');
				$('#cantEntraMil').attr('disabled',true);
				$('#cantEntraQui').attr('disabled',true);
				$('#cantEntraDos').attr('disabled',true);
				$('#cantEntraCien').attr('disabled',true);
				$('#cantEntraCin').attr('disabled',true);
				$('#cantEntraVei').attr('disabled',true);
				$('#cantEntraMon').attr('disabled',true);
				$('#cantSalMil').attr('disabled',true);
				$('#cantSalQui').attr('disabled',true);
				$('#cantSalDos').attr('disabled',true);
				$('#cantSalCien').attr('disabled',true);
				$('#cantSalCin').attr('disabled',true);
				$('#cantSalVei').attr('disabled',true);
				$('#cantSalMon').attr('disabled',true);
			 }
			 function habilitaItems(){
				$('#tipoOperacion').removeAttr('disabled');
				$('#numCopias').removeAttr('disabled');
				habilitaBoton('graba','submit');
				habilitaBoton('agregarEntEfec','submit');
				habilitaBoton('agregarSalEfec','submit');
				$('#cantEntraMil').removeAttr('disabled');
				$('#cantEntraQui').removeAttr('disabled');
				$('#cantEntraDos').removeAttr('disabled');
				$('#cantEntraCien').removeAttr('disabled');
				$('#cantEntraCin').removeAttr('disabled');
				$('#cantEntraVei').removeAttr('disabled');
				$('#cantEntraMon').removeAttr('disabled');
				$('#cantSalMil').removeAttr('disabled');
				$('#cantSalQui').removeAttr('disabled');
				$('#cantSalDos').removeAttr('disabled');
				$('#cantSalCien').removeAttr('disabled');
				$('#cantSalCin').removeAttr('disabled');
				$('#cantSalVei').removeAttr('disabled');
				$('#cantSalMon').removeAttr('disabled');
			 }

			 // limpia las cajas de texto para la garantia
			 // liquida adicional por integrante
			 function limpiarCamposMontoGLAdiInt(){
				 $('input[name=garantiaAdicional]').each(function() {
					 jqGarantiaAdiGruID = eval("'#" + this.id + "'");
					 $(jqGarantiaAdiGruID).val("0.00");
				 });
				 $('#sumaGarantiaAdicionalInt').val("0.00");
				 $('#sumaPendienteGarAdiInt').val("0.00");
			 }


			 // deshabilita las cajas de texto para la garantia
			 // liquida adicional por integrante
			 function deshabilitarInputsGLAdi(){
				 $('input[name=garantiaAdicional]').each(function() {
					 jqGarantiaAdiGruID = eval("'#" + this.id + "'");
					 $(jqGarantiaAdiGruID).attr('disabled',true);
				 });
			 }

			 // habilita las cajas de texto para la garantia
			 // liquida adicional por integrante
			 function habilitarInputsGLAdi(){
				 $('input[name=garantiaAdicional]').each(function() {
					 jqGarantiaAdiGruID = eval("'#" + this.id + "'");
					 $(jqGarantiaAdiGruID).removeAttr('disabled');
				 });
			 }

		//  FUNCIONES PARA LA TRANSFERENCIA ENTRE CUENTAS
	function cargoCuentaTrans(idControl) { //abonoCuentaTrans
		var jqCta = eval("'#" + idControl + "'");
		var numCta = $(jqCta).val();
		var tipConCampos = 4;
		var CuentaAhoBeanCon = {
			'cuentaAhoID' : numCta
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if (numCta != '' && !isNaN(numCta)) {
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon, function(cuenta) {
				if (cuenta != null) {
					$('#tipoCuentaT').val(cuenta.descripcionTipoCta);
					$('#cuentaAhoIDT').val(cuenta.cuentaAhoID);
					$('#numClienteT').val(cuenta.clienteID);

					var cliente = $('#numClienteT').asNumber();
					if (cliente > 0) {
						listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, cuenta.cuentaAhoID, 0);
						consultaSPL = consultaPermiteOperaSPL(cliente,'LPB',esCliente);

						if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
							expedienteBean = consultaExpedienteCliente(cliente);
							if (expedienteBean.tiempo <= 1) {
								if (alertaCte(cliente) != 999) {
									consultaCuentaTransfer(cuenta.clienteID);
									$('#etiquetaCuentaCargo').val(cuenta.etiqueta);
									consultaClienteCuenta('numClienteT', 'nombreClienteT');
									consultaSaldoCtaCargoTrans('cuentaAhoIDT', cuenta.clienteID);
									$('#montoCargarT').val('');
									$('#referenciaT').val('');
								}
							} else {
								mensajeSis('Es necesario Actualizar el Expediente del ' + $('#alertSocio').val() + ' para Continuar.');
								$('#cuentaAhoIDT').focus();
								$('#cuentaAhoIDT').select();
								$('#saldoDisponT').val('');
								$('#numClienteT').val('');
								$('#nombreClienteT').val('');
								$('#tipoCuentaT').val('');
								$('#montoCargarT').val('');
								$('#monedaIDT').val('');
								$('#monedaT').val('');
								$('#referenciaT').val('');
							}
						} else {
							mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
							$('#cuentaAhoIDT').focus();
							$('#cuentaAhoIDT').select();
							$('#saldoDisponT').val('');
							$('#numClienteT').val('');
							$('#nombreClienteT').val('');
							$('#tipoCuentaT').val('');
							$('#montoCargarT').val('');
							$('#monedaIDT').val('');
							$('#monedaT').val('');
							$('#referenciaT').val('');
						}
					}
				} else {
					mensajeSis("No Existe la Cuenta de Ahorro.");
					$('#cuentaAhoIDT').focus();
					$('#cuentaAhoIDT').select();
					$('#saldoDisponT').val('');
					$('#numClienteT').val('');
					$('#nombreClienteT').val('');
					$('#tipoCuentaT').val('');
					$('#montoCargarT').val('');
					$('#monedaIDT').val('');
					$('#monedaT').val('');
					$('#referenciaT').val('');

				}
			});
		} else {
			$('#saldoDisponT').val('');
			$('#numClienteT').val('');
			$('#nombreClienteT').val('');
			$('#tipoCuentaT').val('');
			$('#montoCargarT').val('');
			$('#monedaIDT').val('');
			$('#monedaT').val('');
			$('#referenciaT').val('');
		}
	}
			//noe
			 function consultaCuentaTransfer(numClienteT) {

				 var cuentaTranferBean = {
							'clienteID'	:numClienteT
					};
					dwr.util.removeAllOptions('cuentaAhoIDTC');
					dwr.util.addOptions('cuentaAhoIDTC', {'':'SELECCIONAR'});
					cuentasTransferServicio.listaCombo( 3,cuentaTranferBean, function(cuenta){
					dwr.util.addOptions('cuentaAhoIDTC',cuenta, 'cuentaTranID', 'ctaNomCompletTipoCta');

					});
				}

			 /* Funcion Usada en:
			 		Recuperacion de Cartera Vencida, Transferencias entre cuentas
			 */
				function consultaClienteCuenta(idControl,campoNomClie) {
					var jqCliente  = eval("'#" + idControl + "'");
					var numCliente = $(jqCliente).val();
					var conCliente =5;
					var rfc = ' ';
					setTimeout("$('#cajaLista').hide();", 200);
					if(numCliente != '' && !isNaN(numCliente)){
						clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
									if(cliente!=null){
										$('#'+campoNomClie).val(cliente.nombreCompleto);
									}else{
										mensajeSis("No Existe el " + $('#alertSocio').val());
										$(jqCliente).focus();
									}
							});
						}
				}

			 function consultaSaldoCtaCargoTrans(idControl,numCte) {
					var jqCta  = eval("'#" + idControl + "'");
					var numCta = $(jqCta).val();
					var tipConCampos= 5;
					var CuentaAhoBeanCon = {
						'cuentaAhoID'	:numCta,
						'clienteID'		:numCte
					};
					setTimeout("$('#cajaLista').hide();", 200);

					if(numCta != '' && !isNaN(numCta)){
						cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
									if(cuenta!=null){
										$('#saldoDisponT').val(cuenta.saldoDispon);
										$('#monedaT').val(cuenta.descripcionMoneda);
										$('#monedaIDT').val(cuenta.monedaID);
									}else{
										mensajeSis("No Existe la Cuenta de Ahorro o No Corresponde a ese " + $('#alertSocio').val());
										$('#cuentaAhoIDCa').focus();
										$('#cuentaAhoIDCa').select();
									}
							});
					}
				}

			 //funcion para saber el cliente al que se le hará la transferencia
			 function consultaClienteCtaTransfers(idControl){
				 var jqCtaTrans  = eval("'#" + idControl + "'");
					var numCtaTransferencia = $(jqCtaTrans).val();
						var tipConCampos= 4;
						var CuentaAhoBeanCon = {
							'cuentaAhoID'	:numCtaTransferencia
						};
						if(numCtaTransferencia != '' && !isNaN(numCtaTransferencia)){
							setTimeout("$('#cajaLista').hide();", 200);
							cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cteTransferCta) {
										if(cteTransferCta!=null){
											if (cteTransferCta.estatus != 'A') {
												deshabilitaBoton('graba', 'submit');
												mensajeSis('No se Puede hacer movimientos en esta Cuenta: '+cteTransferCta.cuentaAhoID+' por que no esta vigente.');
											}else {
												$('#numClienteTCtaRecep').val(cteTransferCta.clienteID);
												$('#etiquetaCuentaAbono').val(cteTransferCta.etiqueta);
												$('#tipoTransaccion').val(catTipoTransaccionVen.transferenciaCuenta);
												habilitaBoton('graba', 'submit');
											}
										}else{
											$('#numClienteTCtaRecep').val('');
											$('#etiquetaCuentaAbono').val('');
											mensajeSis("No Existe la Cuenta de Ahorro.");
											$('#cuentaAhoIDTC').select();
										}
								});
						}
				 }


			 // FUNCIONES PARA LA APORTACION SOCIAL
			 function consultaClienteAportacionSocial(idControl){
					var jqCliente  = eval("'#" + idControl + "'");
					var numCliente = $(jqCliente).val();
					var conCliente =1;
					var rfc = ' ';
					setTimeout("$('#cajaLista').hide();", 200);
					if(numCliente != '' && !isNaN(numCliente) ){
						var clienteExpediente = $(jqCliente).asNumber();
						if(clienteExpediente>0){
							listaPersBloqBean = consultaListaPersBloq(clienteExpediente, esCliente, 0, 0);
							if(listaPersBloqBean.estaBloqueado!='S'){
								expedienteBean = consultaExpedienteCliente(clienteExpediente);
								if(expedienteBean.tiempo<=1){
									clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
										if(cliente!=null){
											if(cliente.esMenorEdad == noEsMenor){
												 if (cliente.estatus == EstatusCteInactivo){
														estatusAportacionSocial=EstatusCteInactivo;
														mensajeSis('El ' + $('#alertSocio').val() +' se Encuentra Inactivo.');
														$('#clienteIDAS').val('');
														$('#nombreClienteAS').val('');
														$('#RFCAS').val('');
														$('#tipoPersonaAS').val('');
														$('#clienteIDAS').focus();
														$('#montoPagadoAS').val('');
														$('#montoAS').val('');
														$('#montoPendientePagoAS').val('');
												 }else{
														$('#RFCAS').val(cliente.RFC);
														$('#nombreClienteAS').val(cliente.nombreCompleto);//lll
														estatusAportacionSocial='';
													 	consultaAportacionSocio(numCliente);
												  		validaTipoPersona(cliente.tipoPersona,'tipoPersonaAS');
												  		  $('#montoAS').focus();
												 }

											}else{
												mensajeSis('El '+$('#alertSocio').val() +' es Menor de Edad y no Necesita Aportación Social.');

												$('#clienteIDAS').val('');
												$('#clienteIDAS').focus();
												$('#nombreClienteAS').val('');
												$('#RFCAS').val('');
												$('#tipoPersonaAS').val('');
												$('#montoPendientePagoAS').val('');
												$('#montoPagadoAS').val('');
												$('#montoAS').val('');
											}
										}else{
											mensajeSis("El Socio No Existe.");
											$(jqCliente).focus();
										}
									});
								} else {
									mensajeSis('Es necesario Actualizar el Expediente del '+$('#socioClienteAlert').val()+' para Continuar.');
									$('#clienteIDAS').val('');
									$('#clienteIDAS').focus();
									$('#nombreClienteAS').val('');
									$('#RFCAS').val('');
									$('#tipoPersonaAS').val('');
									$('#montoPendientePagoAS').val('');
									$('#montoPagadoAS').val('');
									$('#montoAS').val('');
								}
							} else {
								mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
								$('#clienteIDAS').val('');
								$('#clienteIDAS').focus();
								$('#nombreClienteAS').val('');
								$('#RFCAS').val('');
								$('#tipoPersonaAS').val('');
								$('#montoPendientePagoAS').val('');
								$('#montoPagadoAS').val('');
								$('#montoAS').val('');
							}
						}
					}
			 }

			 function consultaAportacionSocio(numCliente){
				var conAportacionSocio =1;
				var montoPendiente=0;
				var aportaCliente={
						'clienteID':numCliente
				};
				 setTimeout("$('#cajaLista').hide();", 200);
					if(numCliente != '' && !isNaN(numCliente)){

						aportacionSocial.consulta(conAportacionSocio,aportaCliente,function(aportacionSocio){
								if(aportacionSocio!=null){
									if(estatusAportacionSocial=='I'){
										mensajeSis("El Cliente se encuentra Inactivo.");
										$('#clienteIDAS').val('');
										$('#nombreClienteAS').val('');
										$('#RFCAS').val('');
										$('#tipoPersonaAS').val('');
										$('#clienteIDAS').focus();
										$('#montoPagadoAS').val('');
										$('#montoAS').val('');
										$('#montoPendientePagoAS').val('');
									}else{
									$('#montoPagadoAS').val(aportacionSocio.saldo);
									montoPendiente=montoAportaSocio- $('#montoPagadoAS').asNumber();
									montoPendiente=montoPendiente.toFixed(2);

									if(montoAportaSocio > $('#montoPagadoAS').asNumber()){

										$('#montoPendientePagoAS').val(montoPendiente);
										$('#montoAS').val(montoPendiente);
									}else{
										mensajeSis("El Monto de la Aportación Social ya fué Depositado.");
										$('#montoAS').val('0.00');

									}
									agregaFormatoMoneda('formaGenerica');
									}
								}else{
									$('#montoPagadoAS').val(0.00);
									$('#montoPendientePagoAS').val(montoAportaSocio);
									$('#montoAS').val(montoAportaSocio);
									agregaFormatoMoneda('formaGenerica');
								}
						});
					}
			 }
			 function  validaTipoPersona(tipoPersona,campo){
			 	var moral='M';
			 	var fisicaActEmp='A';
			 	var menorEdad='E';
			 	if(tipoPersona == moral){
			 		$('#'+campo).val('MORAL');
			 	}else if(tipoPersona == fisicaActEmp){
			 		$('#'+campo).val('PERSONA FISICA CON ACTIVIDAD EMPRESARIAL');
			 	}else if(tipoPersona == menorEdad){
			 		$('#'+campo).val('MENOR DE EDAD');
			 	}else{
			 		$('#'+campo).val('PERSONA FISICA SIN ACTIVIDAD EMPRESARIAL');
			 	}

			 }

			 //funciones para la DEVOLUCION APORTACION SOCIAL
			 function consultaCteDevAportaSocial(idControl){
				 	var jqCliente  = eval("'#" + idControl + "'");
					var numCliente = $(jqCliente).val();
					var conCliente =5;
					var rfc = ' ';
					setTimeout("$('#cajaLista').hide();", 200);
					if(numCliente != '' && !isNaN(numCliente)){
						var clienteExpediente = $(jqCliente).asNumber();
						if(clienteExpediente>0){
							listaPersBloqBean = consultaListaPersBloq(clienteExpediente, esCliente, 0, 0);
							if(listaPersBloqBean.estaBloqueado!='S'){
								expedienteBean = consultaExpedienteCliente(clienteExpediente);
								if(expedienteBean.tiempo<=1){
									clienteServicio.consulta(conCliente,numCliente,rfc,	function(cliente){
										if(cliente!=null){
											$('#nombreClienteDAS').val(cliente.nombreCompleto);
											$('#RFCDAS').val(cliente.RFC);
									  		consultaDevolucionSocio(numCliente);
									  		 validaTipoPersona(cliente.tipoPersona,'tipoPersonaDAS');
										}else{
											mensajeSis("El " + $('#alertSocio').val() + " No Existe.");
											$(jqCliente).focus();
											$(jqCliente).val('');
											$('#nombreClienteDAS').val('');
											$('#RFCDAS').val('');
											$('#tipoPersonaDAS').val('');
											$('#montoDAS').val('');
										}
									});
								} else {
									mensajeSis('Es necesario Actualizar el Expediente del '+$('#socioClienteAlert').val()+' para Continuar.');
									$(jqCliente).focus();
									$(jqCliente).val('');
									$('#nombreClienteDAS').val('');
									$('#RFCDAS').val('');
									$('#tipoPersonaDAS').val('');
									$('#montoDAS').val('');
								}
							} else {
								mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
								$(jqCliente).focus();
								$(jqCliente).val('');
								$('#nombreClienteDAS').val('');
								$('#RFCDAS').val('');
								$('#tipoPersonaDAS').val('');
								$('#montoDAS').val('');
							}
						}
					}
			 }

			 function consultaDevolucionSocio(numCliente){
					var conAportacionSocio =1;
					var aportaCliente={
							'clienteID':numCliente
					};
					 setTimeout("$('#cajaLista').hide();", 200);
						if(numCliente != '' && !isNaN(numCliente)){
							aportacionSocial.consulta(conAportacionSocio,aportaCliente,function(aportacionSocio){
									if(aportacionSocio!=null){
										$('#montoDAS').val(aportacionSocio.saldo);
										agregaFormatoMoneda('formaGenerica');
										$('#formaPagoOpera1').focus();
										if(aportacionSocio.creditoID != 0){
											mensajeSis('El '+ $('#alertSocio').val() + ' Tiene un Crédito Vigente. No se puede Realizar la Devolución de la Aportación.');
											$('#clienteIDDAS').val('');
											$('#clienteIDDAS').focus();
											$('#nombreClienteDAS').val('');
											$('#RFCDAS').val('');
											$('#tipoPersonaDAS').val('');
											$('#montoDAS').val('');
										}
										else if(aportacionSocio.inversionID != 0){
											mensajeSis('El '+ $('#alertSocio').val() + ' Tiene una Inversión Vigente. No se puede Realizar la Devolución de la Aportación.');
											$('#clienteIDDAS').val('');
											$('#clienteIDDAS').focus();
											$('#nombreClienteDAS').val('');
											$('#RFCDAS').val('');
											$('#tipoPersonaDAS').val('');
											$('#montoDAS').val('');
										}
										else if(aportacionSocio.cuentaAhoID != 0){
											mensajeSis('El '+ $('#alertSocio').val() + ' Tiene Cuentas con Saldo. No se puede Realizar la Devolución de la Aportación.');
											$('#clienteIDDAS').val('');
											$('#clienteIDDAS').focus();
											$('#nombreClienteDAS').val('');
											$('#RFCDAS').val('');
											$('#tipoPersonaDAS').val('');
											$('#montoDAS').val('');
										}

									}else{
										mensajeSis("El " + $('#alertSocio').val() +" no a realizado el Déposito de la Aportación Social.");
										$('#montoDAS').val('');
									}
							});
						}
				 }

			 function consultaOpcionesCaja() {
				 	parametroBean 			= consultaParametrosSession();
				 	tipoCajaSesion=parametroBean.tipoCaja;
					var opcionesCaja = {
							'tipoCaja'	:tipoCajaSesion,
					};

			  		dwr.util.removeAllOptions('tipoOperacion');
			  		dwr.util.addOptions('tipoOperacion', {'':'SELECCIONAR'});
			  		if(numeroCaja != '' && !isNaN(numeroCaja)){
			  			opcionesPorCajaServicio.listaCombo(1,opcionesCaja, function(opciones){
			  				if(opciones != null){

			  			  		dwr.util.removeAllOptions('tipoOperacion');
			  			  		dwr.util.addOptions('tipoOperacion', {'':'SELECCIONAR'});
			  					dwr.util.addOptions('tipoOperacion', opciones, 'opcionCajaID', 'descripcion');
			  					// si no necesita aportacion Social entonces no mostramos esas opciones en el combo de operaciones
			  					if(montoAportaSocio <= '0.0'){
			  						$('#tipoOperacion').find('option[value=12]').remove();
			  						$('#tipoOperacion').find('option[value=13]').remove();
			  					}
			  				}else{
			  					dwr.util.removeAllOptions('tipoOperacion');
			  					dwr.util.addOptions('tipoOperacion', 'NO TIENE OPCIONES');
			  					deshabilitaBoton('graba', 'submit');
			  				}
			  			});
			  		}
				}

			 function actualizaProceso(sucursalID,cajaID){
				 var actualizaNO = 10;
				var parametrosVentanilla = {
						'sucursalID':sucursalID,
						'cajaID':cajaID
				};
				cajasVentanillaServicio.actualizaProceso(actualizaNO, parametrosVentanilla , function(cajaVentanilla){

				});
			 }
			 // ----------------------- SEGURO DE AYUDA -----------------------------
			 function consultaCteCobroSeguroAyuda(idControl){
				 	var jqCliente  = eval("'#" + idControl + "'");
					var numCliente = $(jqCliente).val();
					var conCliente =5;
					var rfc = ' ';
					var noEsMenorEdad = 'N';
					setTimeout("$('#cajaLista').hide();", 200);
					if(numCliente != '' && !isNaN(numCliente)){
						clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
								if(cliente!=null){
									var montoPolizaSeguroAyuda = cantidadFormatoMoneda(montoPolizaSegAyuda);
									var montoMontoSegAyuda = cantidadFormatoMoneda(montoSegAyuda);

									if(cliente.esMenorEdad == noEsMenorEdad){
										$('#nombreClienteCSVA').val(cliente.nombreCompleto);
										$('#RFCCSVA').val(cliente.RFC);

										$('#numeroPolizaSVA').val(0);
										$('#montoPolizaSegAyudaCobro').val(montoPolizaSeguroAyuda);
										$('#montoSegAyudaCobro').val(montoMontoSegAyuda);
										$('#estatusSeguroVA').val('INACTIVO');
										$('#montoCobrarSeg').val(montoMontoSegAyuda);
								  		validaTipoPersona(cliente.tipoPersona,'tipoPersonaCSVA');
								  		$('#cantEntraMil').focus();
									}else{
										mensajeSis('La Persona es un '+ $('#alertSocio').val() +' Menor. No es necesario Cobro del Seguro de Ayuda.');
										$('#clienteIDCSVA').val('');
										$('#clienteIDCSVA').focus();
										$('#nombreClienteCSVA').val('');
										$('#RFCCSVA').val('');
										$('#tipoPersonaCSVA').val('');
										$('#montoPolizaSegAyudaCobro').val('');
										$('#montoCobrarSeg').val('');
										cuentaAhorro = 0;
									}

									if(numeroCuenta != 0){
										$('#nombreClienteCSVA').val(cliente.nombreCompleto);
										$('#RFCCSVA').val(cliente.RFC);

										$('#numeroPolizaSVA').val(0);
										$('#montoPolizaSegAyudaCobro').val(montoPolizaSeguroAyuda);
										$('#montoSegAyudaCobro').val(montoMontoSegAyuda);
										$('#estatusSeguroVA').val('INACTIVO');
										$('#montoCobrarSeg').val(montoMontoSegAyuda);
								  		validaTipoPersona(cliente.tipoPersona,'tipoPersonaCSVA');
								  		$('#cantEntraMil').focus();

									}else{
										mensajeSis('El '+ $('#alertSocio').val() +' No Tiene una Cuenta Principal con Beneficiarios Asignados.');
										$('#clienteIDCSVA').val('');
										$('#clienteIDCSVA').focus();
										$('#nombreClienteCSVA').val('');
										$('#RFCCSVA').val('');
										$('#tipoPersonaCSVA').val('');
										$('#montoPolizaSegAyudaCobro').val('');
										$('#montoCobrarSeg').val('');
									}

								}else{
									mensajeSis("El " + $('#alertSocio').val() + " No Existe.");
									inicializarCampos();
									$(jqCliente).focus();
								}

						});
					}
			 }


				// se consulta Si tiene cuenta princial con beneficiarios se usa en cobro seguro ayuda-------****
				function consultaCtaPrincipalBen(idControl) {
					var jqCte  = eval("'#" + idControl + "'");
					var numCte = $(jqCte).val();
					var Con_BenefCta = 24;

					var ClienteBeanCon = {
						'clienteID'	:numCte
					};
					setTimeout("$('#cajaLista').hide();", 200);

					if(numCte != '' && !isNaN(numCte)){
						cuentasAhoServicio.consultaCuentasAho(Con_BenefCta, ClienteBeanCon,function(cuenta) {
							if(cuenta!=null){
								numeroCuenta = 	cuenta.cuentaAhoID;
								var cliente = $('#clienteIDCSVA').asNumber();
								if(cliente>0){
									listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, numeroCuenta, 0);
									consultaSPL = consultaPermiteOperaSPL(cliente,'LPB',esCliente);

									if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
										expedienteBean = consultaExpedienteCliente(cliente);
										if(expedienteBean.tiempo<=1){
											consultaCteCobroSeguroAyuda('clienteIDCSVA');
										} else {
											mensajeSis('Es necesario Actualizar el Expediente del ' + $('#alertSocio').val() + ' para Continuar.');
											inicializarCampos();
											$('#clienteIDCSVA').focus();
										}
									} else {
										mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
										inicializarCampos();
										$('#clienteIDCSVA').focus();
									}
								}
							}
						});
					}
				}

			 //-----------------------Funciones para el Pago del Seguro de Ayuda----------
			 function consultaClientePagoSeguroAyuda(idControl){
				 	var jqCliente  = eval("'#" + idControl + "'");
					var numCliente = $(jqCliente).val();
					var conCliente =5;
					var rfc = ' ';
					setTimeout("$('#cajaLista').hide();", 200);
					if(numCliente != '' && !isNaN(numCliente)){
						clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
								if(cliente!=null){
									$('#nombreClienteASVA').val(cliente.nombreCompleto);
									$('#RFCASVA').val(cliente.RFC);
							  		//consultaSeguroAyudaPago(numCliente);
							  		consultaSegusosCliente(numCliente);
							  		 validaTipoPersona(cliente.tipoPersona,'tipoPersonaASVA');
								}else{
									mensajeSis("El " + $('#alertSocio').val() + " No Existe");
									inicializarCampos();
									$(jqCliente).focus();

								}

						});
					}
			 }

			 function consultaSegusosCliente(numCliente) {
				 	limpiaCamposSeguroAyuda();
				 	var listaSegurosporcliente=2;
					var seguroBean = {
							'clienteID'	:numCliente,
					};

			  		dwr.util.removeAllOptions('seguroClienteID');
			  		dwr.util.addOptions('seguroClienteID', {'':'SELECCIONAR'});
			  		if(numCliente != '' && !isNaN(numCliente)){
			  			seguroCliente.listaCombo(listaSegurosporcliente,seguroBean, function(segurosCliente){
			  				if(segurosCliente != null){
			  					dwr.util.addOptions('seguroClienteID', segurosCliente, 'seguroClienteID', 'estatus');
			  				}else{
			  					limpiaCamposSeguroAyuda();
			  					dwr.util.removeAllOptions('seguroClienteID');
			  					dwr.util.addOptions('seguroClienteID', 'NO TIENE OPCIONES');
			  					deshabilitaBoton('graba', 'submit');
			  				}
			  			});
			  		}
				}

			 function consultaSeguroAyudaPago(){
				 var numCliente= $('#clienteIDASVA').val();
				 var numSegCliente= $('#seguroClienteID').val();
				 	var estatusInactivo='I';
				 	var estatusCobrado='C';

					var conCliente =3;
					var seguro={
							'seguroClienteID':numSegCliente,
							'clienteID':numCliente
					};
					setTimeout("$('#cajaLista').hide();", 200);
					var cliente = $('#clienteIDASVA').asNumber();
					if(cliente>0){
						listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, 0, 0);
						consultaSPL = consultaPermiteOperaSPL(cliente,'LPB',esCliente);

						if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
							expedienteBean = consultaExpedienteCliente(cliente);
							if(expedienteBean.tiempo<=1){
								if(numCliente != '' && !isNaN(numCliente)){
									seguroCliente.consulta(conCliente,seguro,function(seguro){
											if(seguro!=null){
												$('#numeroPolizaSVAA').val(seguro.seguroClienteID);
												$('#montoCobradoSegAyudaA').val(seguro.montoSegPagado);
												$('#montoPolizaSegAyudaCobroA').val(seguro.montoPolizaSegAyuda);

												$('#fechaInicioSA').val(seguro.fechaInicio);
												$('#fechaVencimientoSA').val(seguro.fechaVencimiento);
												validaEstatusSeguro(seguro.estatus,'estatusSeguroVAA');
												if(seguro.estatus == estatusInactivo){
													mensajeSis("El Seguro de Ayuda tiene estatus Inactivo.");
													soloLecturaEntradasSalidasEfectivo();
													deshabilitaBoton('graba', 'submit');
												}else if(seguro.estatus == estatusCobrado){
													mensajeSis("El Seguro de Ayuda ya fue Cobrado");
													soloLecturaEntradasSalidasEfectivo();
													deshabilitaBoton('graba', 'submit');
												}else if(seguro.fechaVencimiento < fechaSucursal){
													mensajeSis("La Fecha de Vencimiento del Seguro Ya Paso.");
													soloLecturaEntradasSalidasEfectivo();
													deshabilitaBoton('graba', 'submit');
												}
												agregaFormatoMoneda('formaGenerica');
											}else{
												mensajeSis("El " + $('#alertSocio').val() + " No tiene un Seguro de Ayuda.");
												inicializaForma('formaGenerica','clienteIDASVA');
												consultaDisponibleDenominacion();
												validarFormaPago();
												$('#clienteIDASVA').focus();
												$('#clienteIDASVA').select();
												inicializarCampos();
												$('#cuentaChequePago').val('');
												$('#tipoChequera').val('');
											}
									});
								}
							} else {
								mensajeSis('Es necesario Actualizar el Expediente del '+ $('#alertSocio').val() +' para Continuar.');
								inicializaForma('formaGenerica','clienteIDASVA');
								consultaDisponibleDenominacion();
								validarFormaPago();
								$('#clienteIDASVA').focus();
								$('#clienteIDASVA').select();
								inicializarCampos();
								$('#cuentaChequePago').val('');
								$('#tipoChequera').val('');
							}
						} else {
							mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
							inicializaForma('formaGenerica','clienteIDASVA');
							consultaDisponibleDenominacion();
							validarFormaPago();
							$('#clienteIDASVA').focus();
							$('#clienteIDASVA').select();
							inicializarCampos();
							$('#cuentaChequePago').val('');
							$('#tipoChequera').val('');
						}
					}
			 }
			 function limpiaCamposSeguroAyuda(){
				 $('#numeroPolizaSVAA').val('');
				 $('#estatusSeguroVAA').val('');
				 $('#fechaInicioSA').val('');
				 $('#estatusSeguroVAA').val('');
				 $('#fechaVencimientoSA').val('');
				 $('#montoCobradoSegAyudaA').val('');
				 $('#montoPolizaSegAyudaCobroA').val('');
			 }
			//------------------PAGO DE REMESAS y Oportunidades
			 
			 function validaMontoServicioRemesas(){
				habilitaEntradasSalidasEfectivo();
				$('#numeroTransaccion').val("");
				$('#numeroMensaje').val("1");
				$('#impCheque').hide();

				if ($('#montoServicio').asNumber() >0){
					if($('#clienteIDServicio').asNumber() > 0  || $('#usuarioRem').asNumber() > 0){
						if($('#pagoServicioRetiro').attr("checked")== true){
							totalEntradasSalidasDiferencia();
							$('#cantSalMil').focus();
						}else if($('#pagoServicioCheque').attr("checked")== true){
							$('#cuentaChequePago').focus();
						}else{
							totalEntradasSalidasDiferencia();
						}
					}else{
						deshabilitaBoton('graba','submit');
					}
				}				
			 } 
			 
			 function llenaComboRemesadoras(){

				var bean={
						'remesaCatalogoID':0
				};

				 dwr.util.removeAllOptions('remesaCatalogoID');
				 catalogoRemesasServicio.listaCombo(2,bean, function(remesadorasLista){
					 dwr.util.addOptions('remesaCatalogoID'	,{'':'SELECCIONAR'});
					 dwr.util.addOptions('remesaCatalogoID', remesadorasLista, 'remesaCatalogoID', 'nombreCorto');
				 });
			 }
			 //Funcion agrega validacion de limite de caracteres
			 function limiteCaracteres(){
				 if($('#tipoOperacion').asNumber()==16){
					$('#formaGenerica #referenciaServicio').rules("add", {
						minlength        : longitudMinimaRemesa,
						maxlength        : longitudMaximaRemesa,

						messages        : {
							minlength    : 'Longitud Mínima '+longitudMinimaRemesa+ ' Caracteres',
					    	maxlength    : 'Longitud Máxima'+longitudMaximaRemesa+ ' Caracteres'
					    }
					});
				 }

				 if($('#tipoOperacion').asNumber()==17){
					 $('#formaGenerica #referenciaServicio').rules("add", {
							minlength        : longitudMinimaOpor,
							maxlength        : longitudMaximaOpor,

							messages        : {
						    	minlength    : 'Longitud Mínima '+longitudMinimaOpor+' Caracteres',
						    	maxlength    : 'Longitud Máxima'+longitudMaximaOpor+' Caracteres'
						    }
						});
				 }

			 }


	function consultaClienteOtraPantalla(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var conCliente = 5; // consulta 5 ()
		var rfc = ' ';
		var estatusActivo = 'A';
		setTimeout("$('#cajaLista').hide();", 200);
		if (numCliente != '' && !isNaN(numCliente)) {
			setTimeout("$('#cajaLista').hide();", 200);
			var cliente = $(jqCliente).asNumber();
			if (cliente > 0) {
				listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, 0, 0);
				if (listaPersBloqBean.estaBloqueado != 'S') {
					expedienteBean = consultaExpedienteCliente(cliente);
					if (expedienteBean.tiempo <= 1) {
						if (alertaCte(cliente) != 999) {
							clienteServicio.consulta(conCliente, numCliente, rfc, function(cliente) {
								if (cliente != null) {
									if (cliente.estatus == estatusActivo) {
										$('#nombreClienteServicio').val(cliente.nombreCompleto);
										$('#telefonoClienteServicio').val(cliente.telefonoCasa);
										consultaDirCliente('clienteIDServicio');
										soloLecturaControl('nombreClienteServicio');
										soloLecturaControl('telefonoClienteServicio');
										$('#telefonoClienteServicio').setMask('phone-us');
										$('#indentiClienteServicio').focus();
										$('#usuarioRem').val('');
										$('#nombreUsuarioRem').val('');
									} else {
										mensajeSis("El " + $('#alertSocio').val() + " está Inactivo.");
										$('#clienteIDServicio').focus();
										$('#clienteIDServicio').val('');
										$('#nombreClienteServicio').val('');
										$('#direccionClienteServicio').val('');
										$('#telefonoClienteServicio').val('');
										habilitaControl('usuarioRem');
									}
								} else {
									//EN TODO CASO HABILITAR REGISTRO DE USUARIO
									habilitaControl('usuarioRem');
									deshabilitaControl('nombreClienteServicio');
									deshabilitaControl('telefonoClienteServicio');
									soloLecturaControl('direccionClienteServicio');
									deshabilitaControl('folioIdentiClienteServicio');
								}
							});
						}
					} else {
						mensajeSis('Es necesario Actualizar el Expediente del ' + $('#socioClienteAlert').val() + ' para Continuar.');
						habilitaControl('nombreClienteServicio');
						habilitaControl('telefonoClienteServicio');
						habilitaControl('direccionClienteServicio');
						habilitaControl('folioIdentiClienteServicio');
						$('#nombreClienteServicio').val('');
						$('#direccionClienteServicio').val('');
						$('#telefonoClienteServicio').val('');
					}
				} else {
					mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
					habilitaControl('nombreClienteServicio');
					habilitaControl('telefonoClienteServicio');
					habilitaControl('direccionClienteServicio');
					habilitaControl('folioIdentiClienteServicio');
					$('#nombreClienteServicio').val('');
					$('#direccionClienteServicio').val('');
					$('#telefonoClienteServicio').val('');
				}
			}

		} else {
			//EN TODO CASO HABILITAR REGISTRO DE USUARIO
			habilitaControl('usuarioRem');
			deshabilitaControl('nombreClienteServicio');
			deshabilitaControl('telefonoClienteServicio');
			soloLecturaControl('direccionClienteServicio');
			deshabilitaControl('folioIdentiClienteServicio');

		}
	}

				function consultaDirCliente(idControl) { //generico
					var cte= $('#clienteIDServicio').val();
					var tipConDirClientePrincipal = 3; // consulta 1 direccion oficial delcliente (Solo toma en cuenta el numero de Cliente)

					setTimeout("$('#cajaLista').hide();", 200);

					if(cte != '' && !isNaN(cte)){
						var direccionesCliente = {
								'clienteID' 	:	cte,
								'direccionID'	: '0'
						};
				  		direccionesClienteServicio.consulta(tipConDirClientePrincipal,direccionesCliente,function(direccion) {
							if(direccion!=null){
								$('#direccionClienteServicio').val(direccion.direccionCompleta);
								soloLecturaControl('direccionClienteServicio');
							}else{
								mensajeSis("El "+ $('#alertSocio').val() +" No tiene una Dirección Oficial.");
								soloLecturaControl('direccionClienteServicio');
								$('#clienteIDServicio').focus();
							}
				  		});
					}
				}


				function validaIdenCliente(control, muestraAlertIdenti) {	// generica
					var numIdentificacion = $('#indentiClienteServicio').val();
					var tipoConIdentiClienteprincipal = 4;		// consulta por numero de identificacion y cliente
					setTimeout("$('#cajaLista').hide();", 200);

					if(numIdentificacion != '' && !isNaN(numIdentificacion)  ){
						if ($('#clienteIDServicio').val() != '') {
							var identifiCliente = {
									'clienteID' :  $('#clienteIDServicio').val(),
									'tipoIdentiID' : numIdentificacion
							};

							identifiClienteServicio.consulta(tipoConIdentiClienteprincipal,identifiCliente,function(identificacion) {
								if(identificacion!=null){
									$("#folioIdentiClienteServicio").rules("remove");
									$('#formaGenerica #folioIdentiClienteServicio').rules("add", {
										required        : function() {
															return $('#tipoOperacion').asNumber() == 16 || $('#tipoOperacion').asNumber() == 17;},
										messages        : {
											required:'Especificar Folio de Identificación',
									    }
									});
									$('#folioIdentiClienteServicio').val(identificacion.numIdentific);
									soloLecturaControl('folioIdentiClienteServicio');
								}else{
									if(muestraAlertIdenti =='S'){
										//mensajeSis("No existe la identificación del cliente");
										habilitaControl('folioIdentiClienteServicio');
										$('#folioIdentiClienteServicio').focus();
									}else{
										habilitaControl('folioIdentiClienteServicio');
										$('#indentiClienteServicio').focus();
									}

								}
							});
						}else{
							var numUsuario = $('#usuarioRem').val();
							var conUsuario = 1;

							var usuarioBean = {
								'usuarioID' : numUsuario
							};

							usuarioServicios.consulta(conUsuario,usuarioBean,function(usuario) {
								if(usuario!=null){
									if(usuario.estatus == "A"){
										if ($('#indentiClienteServicio').val() == usuario.tipoIdentiID) {
											$('#folioIdentiClienteServicio').val(usuario.numIdentific);
										} else{
											$('#folioIdentiClienteServicio').val('');
										}
									}else {
										mensajeSis("El Usuario de Servicio está Inactivo.");
										$('#usuarioRem').focus();
										$('#usuarioRem').val('');
										$('#nombreUsuarioRem').val('');
									}
								}
							});
						}

					}
				}

			function consultaTipoIdent() {
				var tipConP = 1;

				var numTipoIden = $('#indentiClienteServicio option:selected').val();
				setTimeout("$('#cajaLista').hide();", 200);

				if(numTipoIden >0){
					tiposIdentiServicio.consulta(tipConP,numTipoIden,	{ async: false, callback:function(identificacion) {
						if(identificacion!=null){
							longitudIdentificacion= identificacion.numeroCaracteres;

							 if($('#tipoOperacion').asNumber()==16 || $('#tipoOperacion').asNumber()==17 ){
									$('#formaGenerica #folioIdentiClienteServicio').rules("add", {
										minlength        : longitudIdentificacion,
										maxlength        : longitudIdentificacion,
										messages        : {
											minlength    : 'Se Requieren '+longitudIdentificacion+ ' Caracteres',
									    	maxlength    : 'Se Requieren '+longitudIdentificacion+ ' Caracteres',
									    }
									});
								}
							 var muestraAlertIdenti='S';
							 if($('#clienteIDServicio').val() > 0  && $('#clienteIDServicio').val() !=''){
								 validaIdenCliente('indentiClienteServicio',muestraAlertIdenti);
							}else{
								//Se valida la longitud de la identificacion solo si se permite capturarla
								muestraAlertIdenti='N';
								validaIdenCliente('indentiClienteServicio',muestraAlertIdenti);
							}

						}else{
							longitudIdentificacion=0;
						}
					}
					});
				}else{
					longitudIdentificacion=0;
				}
			}

			function consultaUsuarios(idControl) {
				var jqUsuario  = eval("'#" + idControl + "'");
				var numUsuario = $(jqUsuario).val();
				var conUsuario = 1;
				setTimeout("$('#cajaLista').hide();", 200);
				if(numUsuario != '' && !isNaN(numUsuario)){

					var usuarioBean = {
						'usuarioID' : numUsuario
					};

					usuarioServicios.consulta(conUsuario,usuarioBean,function(usuario) {
						if(usuario!=null){
							if(usuario.estatus == "A"){
								$('#usuarioRem').val(usuario.usuarioID);
								$('#nombreUsuarioRem').val(usuario.nombreCompleto);
								$('#direccionClienteServicio').val(usuario.direccion);
								$('#telefonoClienteServicio').val(usuario.telefonoCasa);
								$('#indentiClienteServicio').val(usuario.tipoIdentiID);
								$('#folioIdentiClienteServicio').val(usuario.numIdentific);
								$('#clienteIDServicio').val('');
								$('#nombreClienteServicio').val('');
								deshabilitaControl('nombreClienteServicio');
								deshabilitaControl('telefonoClienteServicio');
								$('#telefonoClienteServicio').setMask('phone-us');
								$('#indentiClienteServicio').focus();
								habilitaControl('folioIdentiClienteServicio');
								$('#clienteIDServicio').val('');
							}else {
								mensajeSis("El Usuario de Servicio está Inactivo.");
								$('#usuarioRem').focus();
								$('#usuarioRem').val('');
								$('#nombreUsuarioRem').val('');
							}
						}else{
							mensajeSis("El "+ $('#alertSocio').val() + " está Inactivo.");
							$('#clienteIDServicio').focus();
							$('#usuarioRem').val('');
							$('#nombreUsuarioRem').val('');
							$('#direccionClienteServicio').val('');
							$('#telefonoClienteServicio').val('');

							//Habilitar Registro de Usuario
							//MOstrar BOton
							deshabilitaControl('nombreClienteServicio');
							deshabilitaControl('telefonoClienteServicio');
							soloLecturaControl('direccionClienteServicio');
							deshabilitaControl('folioIdentiClienteServicio');
						}
					});
				}else{
						//Habilitar Registro de Cliente
						habilitaControl('clienteIDServicio');

						deshabilitaControl('nombreClienteServicio');
						deshabilitaControl('telefonoClienteServicio');
						soloLecturaControl('direccionClienteServicio');
						deshabilitaControl('folioIdentiClienteServicio');
					}
			}

				function habilitaCamposRemesasOportunidades(){
					//habilitaControl('nombreClienteServicio');
					habilitaControl('direccionClienteServicio');
					habilitaControl('telefonoClienteServicio');
					habilitaControl('folioIdentiClienteServicio');
					$('#pagoServicioRetiro').attr("checked",true);
					habilitaControl('referenciaServicio');
					habilitaControl('montoServicio');
				}

				function limpiarCamposRemesasOportunidades(){
					$('#nombreClienteServicio').val('');
					$('#direccionClienteServicio').val('');
					$('#telefonoClienteServicio').val('');
					$('#indentiClienteServicio').val('');
					$('#folioIdentiClienteServicio').val('');
					$('#pagoServicioRetiro').val('');
					//$('#referenciaServicio').val('');
					//$('#montoServicio').val('');
					$('#numeroCuentaServicio').val('');
					$('#numeroTarjetaRemesas').val('');
					$('#nombreUsuarioRem').val('');
										
					$('#nombreEmisor').val('');
					$('#paisRemitente').val('');
					$('#estadoRemitente').val('');
					$('#ciudadRemitente').val('');
					$('#coloniaRemitente').val('');
					$('#cpRemitente').val('');
					$('#domicilioRemitente').val('');
					$('#remesaCatalogoID').val('');
					$('#montoServicio').val('');

					inicializarEntradasSalidasEfectivo();
				}
				
				// lllll cuenta oportunidades  revisar generica
				function consultaEstatusCuenta(idControl,numCte) {
					var jqCta  = eval("'#" + idControl + "'");
					var numCta = $(jqCta).val();
					var tipConCampos= 5;
					var estatusCuenta = '';
					var estatusActivo = 'A';
					var CuentaAhoBeanCon = {
						'cuentaAhoID'	:numCta,
						'clienteID'		:numCte
					};
					setTimeout("$('#cajaLista').hide();", 200);

					if(numCta != '' && !isNaN(numCta)){
						cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
							if(cuenta!=null){
								estatusCuenta = cuenta.estatus;
								if(estatusCuenta != estatusActivo){
									mensajeSis('La Cuenta está Inactiva.');
									$('#numeroCuentaServicio').focus();
									$('#numeroCuentaServicio').val('');
								}
							}else{
								mensajeSis("No Existe la Cuenta de Ahorro o no Corresponde a ese " + $('#alertSocio').val());
								$('#numeroCuentaServicio').focus();
								$('#numeroCuentaServicio').val('');
							}
						});
					}
				}

			//------------------- Aplicacion de cheque SSSBC -------------------

			function llenaComboCheques(){
				var numeroCta=$('#numeroCuentaSBC').val();
				var chequeSBCBean = {
						'cuentaAhoID'	:numeroCta,
				};

		  		dwr.util.removeAllOptions('clientechequeSBCAplic');
		  		if(numeroCta != '' && !isNaN(numeroCta)){
		  			abonoChequeSBCServicio.listaCombo(1,chequeSBCBean, function(cheque){
		  				if(cheque != null){
		  					dwr.util.removeAllOptions('clientechequeSBCAplic');
		  					dwr.util.addOptions('clientechequeSBCAplic', {'0':'SELECCIONAR'});
		  					dwr.util.addOptions('clientechequeSBCAplic', cheque, 'chequeSBCID', 'numCheque');
		  				}else{
		  					dwr.util.removeAllOptions('clientechequeSBCAplic');
		  					dwr.util.addOptions('clientechequeSBCAplic', 'NO TIENE OPCIONES');
		  					deshabilitaBoton('graba', 'submit');
		  				}
		  			});
		  		}
			}
			function consultaChequeSBC(idControl){
				var jqControl=eval("'#"+idControl+"'");
				var valorControl=$(jqControl).val();
				var consultaPrincipal = 1;

				setTimeout("$('#cajaLista').hide();", 200);
				var chequeBean = {
		  				'chequeSBCID':valorControl
				};
				if(valorControl != '' && !isNaN(valorControl)){
					abonoChequeSBCServicio.consulta(consultaPrincipal,chequeBean,function(cheque){
						if(cheque !=null){
							$('#bancoEmisorSBCAplic').val(cheque.bancoEmisor);
							$('#numeroCuentaEmisorSBCAplic').val(cheque.bancoEmisor);
							$('#nombreEmisorSBCAplic').val(cheque.nombreEmisor);
							$('#numeroCuentaEmisorSBCAplic').val(cheque.cuentaEmisor);
							$('#numeroChequeSBCAplic').val(cheque.numCheque);
							$('#montoSBCAplic').val(cheque.monto);
							$('#fechaRecepcionSBC').val(cheque.fechaCobro);
							totalEntradasSalidasDiferencia();
							consultaInstitucion('bancoEmisorSBCAplic','nombreBancoEmisorSBCAplic');
						}else{
							mensajeSis("El Cheque no Existe.");
		                    $(jqControl).val('');
		                    $(jqControl).focus();
						}
					});
				}

			}
			function limpiaCamposChequeSBC(){
				// campos de recepcion de Documentos SBC
				$('#tipoCuentaSBC').val("");
				$('#clienteIDSBC').val("");
				$('#nombreClienteSBC').val("");
				$('#saldoDisponibleSBC').val("");
				$('#saldoBloqueadoSBC').val("");
				$('#bancoEmisorSBC').val("");
				$('#nombreBancoEmisorSBC').val("");
				$('#numeroCuentaEmisorSBC').val("");
				$('#nombreEmisorSBC').val("");
				$('#numeroChequeSBC').val("");
				$('#montoSBC').val("");

				// Aplicacion de Documentos SBC
				$('#tipoCuentaSBCAplic').val("");
				$('#clienteIDSBCAplic').val("");
				$('#nombreClienteSBCAplic').val("");
				$('#saldoDisponibleSBCAplic').val("");
				$('#saldoBloqueadoSBCAplic').val("");
				dwr.util.removeAllOptions('clientechequeSBCAplic');
				$('#bancoEmisorSBCAplic').val("");
				$('#nombreBancoEmisorSBCAplic').val("");
				$('#numeroCuentaEmisorSBCAplic').val("");
				$('#nombreEmisorSBCAplic').val("");
				$('#numeroChequeSBCAplic').val("");
				$('#montoSBCAplic').val("");
				$('#fechaRecepcionSBC').val("");
			}
			//------------------FUNCIONES PARA EL PAGO DE SERVICIOS
			function llenaComboCatalogoServicios() {
				catalogoServicios.listaCombo(catListaCatalogoServicio.combo, function(catalogoServBean){
					dwr.util.removeAllOptions('catalogoServID');
					dwr.util.addOptions('catalogoServID', {'':'SELECCIONAR'});
					dwr.util.addOptions('catalogoServID', catalogoServBean, 'catalogoServID', 'nombreServicio');
				});
			}
			function consultaCatalogoServicio(numeroServicio) {
				$('#totalPagar').val('');
				if(numeroServicio != '' && !isNaN(numeroServicio)){
					var catalogoServ = {
							'catalogoServID':numeroServicio
					};
					catalogoServicios.consulta(catTipoConsultaCatalogoServ.principal,catalogoServ,function(catalogoServicioBean) {
						if(catalogoServicioBean != null){
							if(catalogoServicioBean.requiereCliente == 'S'){
								$('#trRequiereCliente').show();
								if(identificaSocioTarjeta=="S"){
									$('#lblNumTarjetaSer').show();
									$('#numeroTarjetaServicio').show();
								}else{
									$('#lblNumTarjetaSer').hide();
									$('#numeroTarjetaServicio').hide();
								}

								if(reactiva==$('#catalogoServID').val()){
									$('#trRequiereProspecto').hide();
									if($('#clienteIDCobroServ').asNumber()>0){
										$('#referenciaPagoServicio').focus();
									}
								}else{
									$('#trRequiereProspecto').show();
									if(identificaSocioTarjeta=="S"){
										$('#numeroTarjetaServicio').focus();
									}else{
										$('#clienteIDCobroServ').focus();
									}
								}


							}else{
								$('#trRequiereCliente').hide();
								$('#trRequiereProspecto').hide();
								$('#clienteIDCobroServ').val('');
								$('#lblNumTarjetaSer').hide();
								$('#numeroTarjetaServicio').hide();
							}
							if(catalogoServicioBean.requiereCredito == 'S'){
								$('#trRequiereCredito').show();
							}else{
								$('#trRequiereCredito').hide();
								$('#creditoIDServicio').val('');
								$('#prodCredCobroServ').val('');
								$('#desProdCreditoPagServ').val('');
							}
							$('#origenServicio').val(catalogoServicioBean.origen);
							$('#cobroComisionPagoServicio').val(catalogoServicioBean.cobraComision);
							$('#requiereClienteServicio').val(catalogoServicioBean.requiereCliente);
							$('#requiereCreditoServicio').val(catalogoServicioBean.requiereCredito);

							$('#montoComision').val(catalogoServicioBean.montoComision);
							$('#montoPagoServicio').val(catalogoServicioBean.montoServicio);
							$('#ivaComision').val(catalogoServicioBean.montoComision * ivaSucursal);
							$('#IvaServicio').val(catalogoServicioBean.montoServicio * ivaSucursal);
							$('#tipoTransaccion').val(catTipoTransaccionVen.pagoServicios);

							if(catalogoServicioBean.origen == catTipoOrigenServicio.tercero){
								if(catalogoServicioBean.cobraComision == 'S'){
									$('#trComision').show();
									$('#totalPagar').val($('#montoComision').asNumber() + $('#ivaComision').asNumber()+$('#montoPagoServicio').asNumber());
								}else {
									$('#trComision').hide();
									$('#totalPagar').val($('#montoPagoServicio').asNumber());
								}
								$('#trMontoPagoServicio').show();
								$('#tdlabelMontoIVAPagoServicio').hide();
								$('#tdinputIVAPagoServicio').hide();
								habilitaControl('montoPagoServicio');
								if(	$('#requiereClienteServicio').val() == 'N'){
									$('#montoPagoServicio').focus();
								}
							}else if (catalogoServicioBean.origen == catTipoOrigenServicio.interno){
								$('#trComision').hide();
								$('#trServicio').show();
								$('#tdlabelMontoIVAPagoServicio').show();
								$('#tdinputIVAPagoServicio').show();
								soloLecturaControl('montoPagoServicio');
								if(	$('#requiereClienteServicio').val() == 'N'){
									$('#referenciaPagoServicio').focus();
								}
								$('#totalPagar').val($('#montoPagoServicio').asNumber() + $('#IvaServicio').asNumber());
							}
							totalEntradasSalidasDiferencia();
						}else{
							mensajeSis("No existe el Servicio.");

						}
					});
				}
			}

			function actualizaSaldoTotalPagarServicio(){
				if($('#origenServicio').val() == catTipoOrigenServicio.tercero){
					if($('#cobroComisionPagoServicio').val() == 'S'){
						$('#totalPagar').val($('#montoComision').asNumber() + $('#ivaComision').asNumber()+$('#montoPagoServicio').asNumber());
					}else{
						$('#totalPagar').val($('#montoPagoServicio').asNumber());
					}
				}else if($('#origenServicio').val()  == catTipoOrigenServicio.interno){
					$('#totalPagar').val($('#montoPagoServicio').asNumber() + $('#IvaServicio').asNumber());
				}
				totalEntradasSalidasDiferencia();

			}
			// a traves de un numero de cliente consulta el numero de prospecto ---clienteIDCobroServ
			function consultaProspectoCliente(idControl) {
				var jqCte = eval("'#" + idControl + "'");
				var numCte = $(jqCte).val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(numCte != '' && !isNaN(numCte) && numCte > 0){
					var prospectoBeanCon ={
				 		 	'cliente' : numCte
					};
					prospectosServicio.consulta(3,prospectoBeanCon,function(prospectos) {
						if(prospectos!=null){
							$('#clienteIDCobroServ').val(prospectos.cliente);
							$('#prospectoIDServicio').val(prospectos.prospectoID);
							$('#nombreProspectoServicio').val(prospectos.nombreCompleto);
							limpiaCamposCreditoPagoServicio();
						}else{
							$('#prospectoIDServicio').val("0");
							$('#nombreProspectoServicio').val("");
						}
						consultaClienteGenerica('clienteIDCobroServ','"nombreClientePagoServ"');
					});
				}
			}


			// a traves de un numero de prospecto consulta el numero de cliente ----- prospectoIDServicio
			function consultaClienteProspecto(idControl) {
				var jqProspecto = eval("'#" + idControl + "'");
				var numProspecto = $(jqProspecto).val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(numProspecto != '' && !isNaN(numProspecto) && numProspecto > 0 ){
					var prospectoBeanCon ={
				 		 	'prospectoID' : numProspecto
					};
					prospectosServicio.consulta(2,prospectoBeanCon,function(prospectos) {
						if(prospectos!=null){
							listaPersBloqBean = consultaListaPersBloq(prospectos.prospectoID, esProspecto, 0, 0);
							consultaSPL = consultaPermiteOperaSPL(prospectos.prospectoID,'LPB',esProspecto);

							if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
								$('#clienteIDCobroServ').val(prospectos.cliente);
								$('#prospectoIDServicio').val(prospectos.prospectoID);
								$('#nombreProspectoServicio').val(prospectos.nombreCompleto);
								if(prospectos.cliente > 0){
									consultaClienteGenerica('clienteIDCobroServ','"nombreClientePagoServ"');
								}else{
									$('#clienteIDCobroServ').val("0");
									$('#nombreClientePagoServ').val("");
									limpiaCamposCreditoPagoServicio();
								}
							}else{
								mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
								$('#clienteIDCobroServ').val("0");
								$('#nombreClientePagoServ').val("");
							}
						}else{
							$('#clienteIDCobroServ').val("0");
							$('#nombreClientePagoServ').val("");
						}
					});
				}
			}
			 //-- Consultya el nombre del Cliente -- --- prospectoIDServicio
			 function consultaClienteGenerica(idControl,nombreCliente){
				 	var jqCliente  = eval("'#" + idControl + "'");
					var numCliente = $(jqCliente).val();
					var conCliente =2;
					var rfc = ' ';
					setTimeout("$('#cajaLista').hide();", 200);

					if(numCliente != '' && !isNaN(numCliente)){
						clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
								if(cliente!=null){
									$('#nombreClientePagoServ').val(cliente.nombreCompleto);
								}else{
									mensajeSis("El "+ $('#alertSocio').val() +" no Existe.");
									$(jqCliente).focus();
								}
						});
					}
			 }
			function limpiaCamposPagoServicio(){
				$('#clienteIDCobroServ').val("");
				$('#nombreClientePagoServ').val("");
				$('#prospectoIDServicio').val("");
				$('#nombreProspectoServicio').val("");
				$('#creditoIDServicio').val("");
				$('#montoComision').val("");
				$('#ivaComision').val("");
				$('#montoPagoServicio').val("");
				$('#totalPagar').val("");
				$('#referenciaPagoServicio').val("");
				$('#segundaRefeServicio').val("");
				$('#origenServicio').val('');
				$('#cobroComisionPagoServicio').val('');
				$('#requiereClienteServicio').val('');
				$('#requiereCreditoServicio').val('');
				limpiaCamposCreditoPagoServicio ();
				$('#numeroTarjetaServicio').val('');
			}

			function limpiaCamposCreditoPagoServicio(){
				$('#creditoIDServicio').val('');
				$('#prodCredCobroServ').val('');
				$('#desProdCreditoPagServ').val('');
				$('#grupoIDCobroSer').val('');
				$('#cicloGrupoCredCobroServ').val('');
				$('#nombreGrupoCobroServ').val('');

			}

			// Consulta credito Pago de servicios
			function consultaCreditoPagoServicios(controlID){
				var numCredito = $('#creditoIDServicio').val();
				setTimeout("$('#cajaLista').hide();", 200);
				if(numCredito != '' && !isNaN(numCredito) ){
					var creditoBeanCon = {
						'creditoID':numCredito,
		  				'fechaActual':$('#fechaSistemaP').val()
		  			};
		  			creditosServicio.consulta(11,creditoBeanCon,function(credito) { // consulta de comision x apertura
		   				if(credito!=null){
		   					listaPersBloqBean = consultaListaPersBloq(credito.clienteID, esCliente, 0, 0);
							consultaSPL = consultaPermiteOperaSPL(credito.clienteID,'LPB',esCliente);

							if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
		   					if(credito.clienteID == $('#clienteIDCobroServ').asNumber()){
								if(credito.grupoID > 0){
									$('#trCredGrupalPagoServ').show();
									$('#grupoIDCobroSer').val(credito.grupoID);
									$('#cicloGrupoCredCobroServ').val(credito.CicloGrupo);
									consultaGrupo(credito.grupoID,'grupoIDCobroSer','nombreGrupoCobroServ','cicloGrupoCredCobroServ');
								}else {
									$('#trCredGrupalPagoServ').hide();
								}
								$('#prodCredCobroServ').val(credito.producCreditoID);
								consultaProdCredito(credito.producCreditoID,'prodCredCobroServ','desProdCreditoPagServ');
		   					}else{
		   						mensajeSis ("El Crédito no pertenece al "+ $('#alertSocio').val() +" indicado");
		   						$('#creditoIDServicio').focus();
		   						limpiaCamposCreditoPagoServicio();
		   					}
		   				}else{
		   					mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
		   					$('#creditoIDServicio').focus();
		   					$('#prodCredCobroServ').val('');
		   					$('#desProdCreditoPagServ').val('');
		   				}
		   				}else{
		   					mensajeSis("No Existe el Crédito.");
		   					$('#creditoIDServicio').focus();
		   					$('#prodCredCobroServ').val('');
		   					$('#desProdCreditoPagServ').val('');
		   				}
					});
				}else{
					$('#creditoIDServicio').focus();
					$('#prodCredCobroServ').val('');
					$('#desProdCreditoPagServ').val('');
					limpiaCamposCreditoPagoServicio();
				}


			}


			 // FUNCIONES CONSULTAR UN CLIENTE EN REACTIVACION DE CLIENTE
			 function consultaReactivacionCte(idControl){
					var jqClienteReac  = eval("'#" + idControl + "'");
					var numClienteRec = $(jqClienteReac).val();
					var conCliente =1;
					var rfc = ' ';


					setTimeout("$('#cajaLista').hide();", 200);
					if(numClienteRec != '' && !isNaN(numClienteRec)){

						clienteServicio.consulta(conCliente,numClienteRec,rfc,function(clienteRec){
								if(clienteRec!=null){
									if( clienteRec.tipoInactiva >0){
										validaMotivos(clienteRec.tipoInactiva);
										nombreClienteRec=clienteRec.nombreCompleto;

									}else{

										mensajeSis("El "+ $('#alertSocio').val() +" Consultado se Encuentra Activo.");
										$('#IvaServicio').val("");
										$('#segundaRefeServicio').val("");
										$('#referenciaPagoServicio').val("");
										$('#totalPagar').val("");
										$('#montoPagoServicio').val("");
										$('#nombreClientePagoServ').val("");
										$('#clienteIDCobroServ').focus();
									}
								}else{
									mensajeSis("El "+ $('#alertSocio').val() +" no Existe.");
									$('#IvaServicio').val("");
									$('#segundaRefeServicio').val("");
									$('#referenciaPagoServicio').val("");
									$('#totalPagar').val("");
									$('#montoPagoServicio').val("");
									$('#nombreClientePagoServ').val("");
									$('#clienteIDCobroServ').focus();
								}
						});
					}
			 }


			// consultar los datos que necesito para Reactivar cliente //
				function validaMotivos(tipoMovReact) {
					var motivoBean = {
							'motivoActivaID' : tipoMovReact,
							};
					motivActivacionServicio.consulta(motivoBean,1,function(motivosR) {
							if (motivosR != null) {
								if(motivosR.permiteReactivacion == 'N'){
										mensajeSis("El Motivo de Inactivación no Puede Volver a Activarse.");
										$('#IvaServicio').val("");
										$('#segundaRefeServicio').val("");
										$('#referenciaPagoServicio').val("");
										$('#totalPagar').val("");
										$('#montoPagoServicio').val("");
										$('#nombreClientePagoServ').val("");
										$('#clienteIDCobroServ').focus();

								}else
									if(motivosR.permiteReactivacion== 'S' && motivosR.requiereCobro == 'N'){
										mensajeSis("El Motivo de Inactivación no Requiere de Cobro.");
										$('#IvaServicio').val("");
										$('#segundaRefeServicio').val("");
										$('#referenciaPagoServicio').val("");
										$('#totalPagar').val("");
										$('#montoPagoServicio').val("");
										$('#nombreClientePagoServ').val("");
										$('#clienteIDCobroServ').focus();
									}else{
										$('#nombreClientePagoServ').val(nombreClienteRec);
										consultaCatalogoServicio($('#catalogoServID').asNumber());
									}
								}
						});
					}








			//--------------------------- FUNCIONES PARA LA RECUPERACION DE LA CARTERA VENCIDA ----------------------------
			function consultaCreditoCartVencida(controlID){
				var jqCreditoID  = eval("'#" + controlID + "'");
				var numeroCredito = $(jqCreditoID).val();

				setTimeout("$('#cajaLista').hide();", 200);
				if(numeroCredito != '' && !isNaN(numeroCredito) ){
					var creditoBeanCon = {
						'creditoID':numeroCredito,
		  				'fechaActual':$('#fechaSistemaP').val()
		  			};
		  			creditosServicio.consulta(11,creditoBeanCon,function(credito) { // consulta principal de CREDITOS
		   				if(credito!=null){
		   					listaPersBloqBean = consultaListaPersBloq(credito.clienteID, esCliente, 0, 0);
							consultaSPL = consultaPermiteOperaSPL(credito.clienteID,'LPB',esCliente);

							if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
			   					$('#productoCreditoVencido').val(credito.producCreditoID);
			   					$('#clienteIDVencido').val(credito.clienteID);

			   					$('#monedaCartVencida').val(credito.monedaID );
			   					$('#montoCreditoCast').val(credito.montoCredito );

			   					if (credito.grupoID >0){
			   						$('#trGrupoCredCast').show();
			   						$('#grupoIDCast').val(credito.grupoID);
			   						consultaGrupoGeneral('grupoIDCast', 'grupoDesCast', 'cicloIDCast');
			   					}else{
			   						$('#trGrupoCredCast').hide();
			   						$('#grupoIDCast').val('');
			   						$('#grupoDesCast').val('');
			   						$('#cicloIDCast').val('');
			   					}
			   					validaEstatusCreditoSeguro(credito.estatus,'estatusCredVencido');
			   					consultaProdCredito(credito.producCreditoID,'controlID','desProducVencido');
			   					consultaMonedaSeguro(credito.monedaID,'monedaCartVencida', 'desMonedaCartVencida');
			   					consultaClienteCuenta('clienteIDVencido','nombreClienteVencido');
			   					consultaCreditoCastigado(numeroCredito);
			   					$('#montoCreditoCast').formatCurrency({
			   						positiveFormat: '%n',
			   						roundToDecimalPlace: 2
			   					});
			   				}else{
			   					mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
			   					$('#'+controlID).focus();
			   					$('#'+controlID).select();
			   					limpiaCamposCreditoCastigado();
			   					inicializarEntradasSalidasEfectivo();
			   					$('#SaldoComFaltaPa').val("");
			   					$('#iva').val("");
			   					$('#saldoMoratoriosCast').val("");
			   					$('#productoCreditoVencido').val("");
			   					$('#desProducVencido').val("");
			   					$('#estatusCredVencido').val("");
			   					$('#montoCreditoCast').val("");
			   					$('#desMonedaCartVencida').val("");
			   					$('#monedaCartVencida').val("");
			   					$('#nombreClienteVencido').val("");
			   					$('#clienteIDVencido').val("");
			   				}
		   				}else{
		   					mensajeSis("No Existe el Crédito.");
		   					$('#'+controlID).focus();
		   					$('#'+controlID).select();
		   					limpiaCamposCreditoCastigado();
		   					inicializarEntradasSalidasEfectivo();
		   					$('#SaldoComFaltaPa').val("");
		   					$('#iva').val("");
		   					$('#saldoMoratoriosCast').val("");
		   					$('#productoCreditoVencido').val("");
		   					$('#desProducVencido').val("");
		   					$('#estatusCredVencido').val("");
		   					$('#montoCreditoCast').val("");
		   					$('#desMonedaCartVencida').val("");
		   					$('#monedaCartVencida').val("");
		   					$('#nombreClienteVencido').val("");
		   					$('#clienteIDVencido').val("");
		   				}
					});
				}else{
						limpiaCamposCreditoCastigado();
						inicializarEntradasSalidasEfectivo();
						$('#SaldoComFaltaPa').val("");
						$('#iva').val("");
						$('#saldoMoratoriosCast').val("");
						$('#productoCreditoVencido').val("");
						$('#desProducVencido').val("");
						$('#estatusCredVencido').val("");
						$('#montoCreditoCast').val("");
						$('#desMonedaCartVencida').val("");
						$('#monedaCartVencida').val("");
						$('#nombreClienteVencido').val("");
						$('#clienteIDVencido').val("");
						$('#'+controlID).select();

				}

			}
			function consultaCreditoCastigado(numeroCredito){
				setTimeout("$('#cajaLista').hide();", 200);
				habilitaControl('montoRecuperar');
				$('#montoRecuperar').val('');
				habilitaEntradasSalidasEfectivo();

				if(numeroCredito != '' && !isNaN(numeroCredito) ){
					var creditoCastigadoBeanCon = {
						'creditoID':numeroCredito
		  			};
					castigosCarteraServicio.consulta(1,creditoCastigadoBeanCon,function(creditoCastigado) { // consulta principal CREACASTIGOS
		   				if(creditoCastigado!=null){
		   					$('#fechaCastigo').val(creditoCastigado.fecha);
		   					$('#capitalCastigado').val(creditoCastigado.capitalCastigado);
		   					$('#interesCastigado').val(creditoCastigado.interesCastigado);
		   					$('#totalCastigado').val(creditoCastigado.totalCastigo);
		   					$('#monRecuperado').val(creditoCastigado.monRecuperado);
		   					$('#motivoCastigo').val(creditoCastigado.motivoCastigoID).selected = true;
		   					$('#observacionesCastigo').val(creditoCastigado.observaciones);
		   					$('#montoPorRecuperar').val(creditoCastigado.porRecuperar );
		   					$('#SaldoComFaltaPa').val(creditoCastigado.accesorioCastigado);
		   					$('#saldoMoratoriosCast').val(creditoCastigado.intMoraCastigado);
		   					$('#iva').val(creditoCastigado.IVA);


		   					$('#totalCastigado').formatCurrency({
		   						positiveFormat: '%n',
		   						roundToDecimalPlace: 2
		   					});

		   					$('#monRecuperado').formatCurrency({
		   						positiveFormat: '%n',
		   						roundToDecimalPlace: 2
		   					});
		   					$('#montoPorRecuperar').formatCurrency({
		   						positiveFormat: '%n',
		   						roundToDecimalPlace: 2
		   					});
		   					$('#iva').formatCurrency({
		   						positiveFormat: '%n',
		   						roundToDecimalPlace: 2
		   					});


		   				}else{
		   					mensajeSis("El Crédito no se Encuentra Castigado.");
		   					$('#creditoVencido').focus();
		   					deshabilitaControl('montoRecuperar');
		   					soloLecturaEntradasSalidasEfectivo();
		   					limpiaCamposCreditoCastigado();
		   				}
					});
				}
			}

			function limpiaCamposCreditoCastigado(){
				$('#fechaCastigo').val('');
					$('#capitalCastigado').val('');
					$('#interesCastigado').val('');
					$('#totalCastigado').val('');
					$('#monRecuperado').val('');
					$('#motivoCastigo').val('').selected=true;
					$('#observacionesCastigo').val('');
					$('#montoRecuperar').val('');
					$('#montoPorRecuperar').val("");
			}
			function limpiaCamposRecCarteraCastigada(){
				$('#creditoVencido').val("");
				$('#productoCreditoVencido').val("");
				$('#desProducVencido').val("");
				$('#clienteIDVencido').val("");
				$('#nombreClienteVencido').val("");
				$('#estatusCredVencido').val("");
				$('#monedaCartVencida').val("");
				$('#desMonedaCartVencida').val("");
				$('#montoCreditoCast').val("");

				limpiaCamposCreditoCastigado();
			}
			function consultaMotivosCastigo() {
		  		dwr.util.removeAllOptions('motivoCastigo');
		  		dwr.util.addOptions('motivoCastigo', {'':'SELECCIONAR'});
				castigosCarteraServicio.listaCombo(1, function(motivosCastigo){
				dwr.util.addOptions('motivoCastigo', motivosCastigo, 'motivoCastigoID', 'descricpion');
					});
			}

			function consultaGrupoGeneral( idGrupo, desGrupo, campoCiclo) {
				var jqDesGrupo  = eval("'#" + desGrupo + "'");
				var jqIDGrupo  = eval("'#" + idGrupo + "'");
				var jqCiclo		=eval("'#" + campoCiclo + "'");

				var numeroGrupo = $(jqIDGrupo).val();

				var tipConGrupo= 1;
				var grupoBean = {
					'grupoID'	:numeroGrupo,
					'cicloActual':0
				};
				setTimeout("$('#cajaLista').hide();", 200);

				if(numeroGrupo != '' && !isNaN(numeroGrupo) ){
					gruposCreditoServicio.consulta(tipConGrupo, grupoBean,function(grupo) {
						if(grupo!=null){
							$(jqIDGrupo).val(grupo.grupoID);
							$(jqDesGrupo).val(grupo.nombreGrupo);
							$(jqCiclo).val(grupo.cicloActual);

						}
					});
				}
			}
			function inicializarSalidasEfectivo(){
				$('#cantSalMil').val(0);
				$('#cantSalQui').val(0);
				$('#cantSalDos').val(0);
				$('#cantSalCien').val(0);
				$('#cantSalCin').val(0);
				$('#cantSalVei').val(0);
				$('#cantSalMon').val(0);

				$('#montoSalMil').val(0);
				$('#montoSalQui').val(0);
				$('#montoSalDos').val(0);
				$('#montoSalCien').val(0);
				$('#montoSalCin').val(0);
				$('#montoSalVei').val(0);
				$('#montoSalMon').val(0);

				$('#sumTotalSal').val(0);

			}

			//funcion para consultar la lista de pagare grupal
			function consultaPagareGrupal(idControl){
				var jqPagareGrupal  = eval("'#" + idControl + "'");
				var noPagareGrupal = $(jqPagareGrupal).val();
			if (noPagareGrupal != ''  && !isNaN(noPagareGrupal)){
					var params = {};
					params['tipoLista'] = 2;
					params['creditoID'] = noPagareGrupal;
					$.post("gridPagareGrupal.htm", params, function(data){
						if(data.length >0) {
							agregaFormatoControles('formaGenerica');
							$('#pagareGrupal').html(data);
							$('#pagareGrupal').show();
							var contador = 0;
							var contador2 = 0;
							var contador3 = 0;
							var jqSaldoCapID ="";
							var jqSaldoCapital ="";
							var jqSaldoCuota ="";
							$('input[name=saldoCapGrid]').each(function() {
								contador = contador + 1;
								jqSaldoCapID = eval("'#saldoCap"+contador+"'");
								$(jqSaldoCapID).formatCurrency({
											positiveFormat: '%n',
											roundToDecimalPlace: 2
								});
							});
							$('input[name=saldoCapitalGrid]').each(function() {
								contador2 = contador2 + 1;
								jqSaldoCapital = eval("'#saldoCapital"+contador2+"'");
								$(jqSaldoCapital).formatCurrency({
											positiveFormat: '%n',
											roundToDecimalPlace: 2
								});
							});
							$('input[name=totalPagoGrid]').each(function() {
								contador3 = contador3 + 1;
								jqSaldoCuota = eval("'#totalPago"+contador3+"'");
								$(jqSaldoCuota).formatCurrency({
											positiveFormat: '%n',
											roundToDecimalPlace: 2
								});
							});
						}else{

						}
					});
				}
			}



			function validaEmpresaID() {
				var numEmpresaID = 1;
				var tipoCon = 1;
				var ParametrosSisBean = {
						'empresaID'	:numEmpresaID
				};
				parametrosSisServicio.consulta(tipoCon,ParametrosSisBean,function(parametrosSisBean) {
					if (parametrosSisBean != null) {
						if(parametrosSisBean.servReactivaCliID !=null){
								reactiva=parametrosSisBean.servReactivaCliID;
								$('#afectacionContable').val(parametrosSisBean.afectaContaRecSBC);
								identificaSocioTarjeta=parametrosSisBean.tarjetaIdentiSocio;
								longitudMinimaRemesa =parametrosSisBean.lonMinPagRemesa;
								longitudMaximaRemesa=parametrosSisBean.lonMaxPagRemesa;
								longitudMinimaOpor=parametrosSisBean.lonMinPagOport;
								longitudMaximaOpor=parametrosSisBean.lonMaxPagOport;
								$('#aplicaGarAdiPagoCre').val(parametrosSisBean.aplicaGarAdiPagoCre);

						}else{
							reactiva=0;
							identificaSocioTarjeta=0;
							$('#afectacionContable').val("N");
						}
					}
				});
			}

			function consultaSiRequiereHuella() {
				var numOperacion = $('#tipoOperacion').val();
				var requiereHuella = $('#huellaRequiere').val();
				if (numOperacion != '' && !isNaN(numOperacion)) {
					if (requiereHuella == "" || requiereHuella != "N") {
						var operacionBean = {
							'opcionCajaID': $('#tipoOperacion').val()
						};
						opcionesPorCajaServicio.consulta(1, operacionBean, function (caja) {

							if (caja?.reqAutentificacion == "S") {

								var esUsuarioServ = +($('#usuarioRem').val().trim()) > 0;

								if (esUsuarioServ != true) {
									serverHuella.muestraFirma();
								} else {
									serverHuella.muestraFirmaUsuarioServicios();
								}
							} else {
								grabaFormaTransaccionVentanilla({}, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'numeroTransaccion');
							}
						});
					}
				}
			}

		function validaListas(){
			var vectorIdListas = ['cuentaAhoIDCa', 'cuentaAhoIDAb', 'creditoID','numClienteGL','creditoIDDC',
									'clienteIDAS','clienteIDDAS','clienteIDServicio','clienteIDCobroServ','clienteIDCSVA',
									'clienteIDASVA','clienteIDApoyoEsc','clienteIDMenor'];
			var socio=$('#socioClienteAlert').val();
			var vectorAlerts = ['Cuenta','Cuenta','Crédito',socio,'Crédito',
								socio,socio,socio,socio,socio,
								socio,socio,socio];
			var errorValidacion=0;
			$.each(vectorIdListas,function(index,idForma){
				var jqForma = eval("'#"+idForma+"'");
				var idVal	= $(jqForma).val();
		    	if(idVal!='' && isNaN(idVal)){
		        	mensajeSis('Especifique un Número de '+vectorAlerts[index]+' Válido.');
		        		$(jqForma).focus();
			        	errorValidacion++;
					}
				});
				return errorValidacion;
			}

		function funcionListado(){
			switch($('#tipoOperacion').asNumber()){
			case cargoCuenta:
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "clienteID";
				camposLista[1] = "nombreCompleto";
				parametrosLista[0] = $('#idCtePorTarjeta').val();
				parametrosLista[1] = 0;
				if ($('#numeroTarjeta').val()!="" &&  $('#idCtePorTarjeta').val()!=""){
					$('#cuentaAhoIDCa').val($('#nomTarjetaHabiente').val());
					listaCte('cuentaAhoIDCa', '2', '16', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
				}
				$('#numeroTarjeta').val("");
				$('#idCtePorTarjeta').val("");
				$('#nomTarjetaHabiente').val("");
				break;
			case abonoCuenta:
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "clienteID";
				camposLista[1] = "nombreCompleto";
				parametrosLista[0] = $('#idCtePorTarjeta').val();
				parametrosLista[1] = 0;
				if ($('#numeroTarjeta').val()!="" &&  $('#idCtePorTarjeta').val()!=""){
					$('#cuentaAhoIDAb').val($('#nomTarjetaHabiente').val());
					listaCte('cuentaAhoIDAb', '2', '16', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
				}

				$('#numeroTarjeta').val("");
				$('#idCtePorTarjeta').val("");
				$('#nomTarjetaHabiente').val("");
				break;
			case pagoCredito:
				var camposLista = new Array();
				var parametrosLista = new Array();

				camposLista[0] = "nombreCliente";
				camposLista[1] = "clienteID";
				parametrosLista[0] =$('#creditoID').val();
				parametrosLista[1] =  $('#idCtePorTarjeta').val();
				if ($('#numeroTarjeta').val()!="" &&  $('#idCtePorTarjeta').val()!=""){
					$('#creditoID').val($('#nomTarjetaHabiente').val());
					listaAlfanumericaCte('creditoID', '2', '37', camposLista, parametrosLista, 'ListaCredito.htm');
				}

				$('#numeroTarjeta').val("");
				$('#idCtePorTarjeta').val("");
				$('#nomTarjetaHabiente').val("");
				break;

			case prepagoCredito:
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "nombreCliente";
				camposLista[1] = "clienteID";
				parametrosLista[0] =$('#creditoIDPre').val();
				parametrosLista[1] =$('#idCtePorTarjeta').val();
				if ($('#numeroTarjeta').val()!="" &&  $('#idCtePorTarjeta').val()!=""){
					$('#creditoIDPre').val($('#nomTarjetaHabiente').val());
					listaAlfanumericaSoloLetras('creditoIDPre', '2', '39', camposLista, parametrosLista, 'ListaCredito.htm');
				}

				$('#numeroTarjeta').val("");
				$('#idCtePorTarjeta').val("");
				$('#nomTarjetaHabiente').val("");
				break;

			case desemboCred:
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "nombreCliente";
				camposLista[1] = "clienteID";
				parametrosLista[0] = $('#creditoIDDC').val();
				parametrosLista[1] = $('#idCtePorTarjeta').val();
				if ($('#numeroTarjeta').val()!="" &&  $('#idCtePorTarjeta').val()!=""){
					$('#creditoIDDC').val($('#nomTarjetaHabiente').val());
				listaAlfanumericaCte('creditoIDDC', '2', '36', camposLista, parametrosLista, 'ListaCredito.htm');
				}
				$('#numeroTarjeta').val("");
				$('#idCtePorTarjeta').val("");
				$('#nomTarjetaHabiente').val("");
				break;

			case tranferenciaCuenta:
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "clienteID";
				camposLista[1] = "nombreCompleto";
				parametrosLista[0] = $('#idCtePorTarjeta').val();
				parametrosLista[1] = 0;
				if ($('#numeroTarjeta').val()!="" &&  $('#idCtePorTarjeta').val()!=""){
					$('#cuentaAhoIDT').val($('#nomTarjetaHabiente').val());
					listaAlfanumerica('cuentaAhoIDT', '2', '13', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
				}

				$('#numeroTarjeta').val("");
				$('#idCtePorTarjeta').val("");
				$('#nomTarjetaHabiente').val("");
				break;

			case pagoRemesas:
				limpiarCamposRemesasOportunidades();
				 $('#numeroTarjetaRemesas').val("");
				$('#clienteIDServicio').val($('#idCtePorTarjeta').val());
				consultaClienteOtraPantalla('clienteIDServicio');
				$('#numeroTarjeta').val("");
				$('#idCtePorTarjeta').val("");
				$('#nomTarjetaHabiente').val("");

				break;
			case pagoOportunidades:
				limpiarCamposRemesasOportunidades();
				 $('#numeroTarjetaRemesas').val("");
				$('#clienteIDServicio').val($('#idCtePorTarjeta').val());
				consultaClienteOtraPantalla('clienteIDServicio');

				$('#numeroTarjeta').val("");
				$('#idCtePorTarjeta').val("");
				$('#nomTarjetaHabiente').val("");
				break;
			case recepChequeSBC:
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "clienteID";
				camposLista[1] = "nombreCompleto";
				parametrosLista[0] = $('#idCtePorTarjeta').val();
				parametrosLista[1] = $('#numeroCuentaRec').val();
				if ($('#numeroTarjeta').val()!="" &&  $('#idCtePorTarjeta').val()!=""){
					$('#numeroCuentaRec').val($('#nomTarjetaHabiente').val());
					listaAlfanumerica('numeroCuentaRec', '2', '13', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
				}
				$('#numeroTarjeta').val("");
				$('#idCtePorTarjeta').val("");
				$('#nomTarjetaHabiente').val("");
				break;
			case aplicaChequeSBC:
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "clienteID";
				camposLista[1] = "nombreCompleto";
				parametrosLista[0] =$('#idCtePorTarjeta').val();
				parametrosLista[1] = $('#numeroCuentaSBC').val();
				if ($('#numeroTarjeta').val()!="" &&  $('#idCtePorTarjeta').val()!=""){
					$('#numeroCuentaSBC').val($('#nomTarjetaHabiente').val());
					listaAlfanumerica('numeroCuentaSBC', '2', '17', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
				}
				$('#numeroTarjeta').val("");
				$('#nomTarjetaHabiente').val("");
				$('#idCtePorTarjeta').val("");
				break;
			case pagoServicios:
				$('#numeroTarjetaServicio').val("");
				$('#clienteIDCobroServ').val($('#idCtePorTarjeta').val());
				consultaClienteComApDes($('#idCtePorTarjeta').val(), 'clienteIDCobroServ', 'nombreClientePagoServ');
				$('#catalogoServID').focus("");


				$('#numeroTarjeta').val("");
				$('#idCtePorTarjeta').val("");
				$('#nomTarjetaHabiente').val("");
				break;

			case pagoServifun:
				var camposLista = new Array();
				var parametrosLista = new Array();

				camposLista[0] = "clienteID";
				camposLista[1] = "tramPrimerNombre";

				parametrosLista[0] = $('#idCtePorTarjeta').val();
				parametrosLista[1] = $('#serviFunFolioID').val();
				if ($('#numeroTarjeta').val()!="" &&  $('#idCtePorTarjeta').val()!=""){
					$('#serviFunFolioID').val($('#nomTarjetaHabiente').val());
				lista('serviFunFolioID', '2', '2', camposLista, parametrosLista, 'serviFunFoliosLista.htm');
				}
				$('#numeroTarjeta').val("");
				$('#idCtePorTarjeta').val("");
				$('#nomTarjetaHabiente').val("");
				break;
			case cobroApoyoEscolar:
				var camposLista = new Array();
				var parametrosLista = new Array();

				camposLista[0] = "clienteID";
				camposLista[1] = "apoyoEscSolID";
				camposLista[2] = "nombreCompleto";

				parametrosLista[0] = $('#idCtePorTarjeta').val();
				parametrosLista[1] = 0;
				parametrosLista[2] = $('#clienteIDApoyoEsc').val();
				if ($('#numeroTarjeta').val()!="" &&  $('#idCtePorTarjeta').val()!=""){
					$('#clienteIDApoyoEsc').val($('#nomTarjetaHabiente').val());
					listaCte('clienteIDApoyoEsc', '2', '7', camposLista, parametrosLista, 'listaApoyoEscolarSol.htm');
				}
				$('#numeroTarjeta').val("");
				$('#idCtePorTarjeta').val("");
				$('#nomTarjetaHabiente').val("");
				break;

			}
		}

			function mostrarCampoTarjeta(){
				if(identificaSocioTarjeta=="S"){
					if($('#tipoOperacion').asNumber()==16){
						$('#numerTarjetaRemesas').show();
						$('#numeroTarjetaRemesas').show();
						$('#tarjetaIdentiCA').hide();
					}else{
					$('#tarjetaIdentiCA').show();
					$('#numeroTarjeta').val("");
					$('#idCtePorTarjeta').val("");
					$('#nomTarjetaHabiente').val("");}
				}else{
					$('#numerTarjetaRemesas').hide();
					$('#numeroTarjetaRemesas').hide();
					$('#tarjetaIdentiCA').hide();
					$('#numeroTarjeta').val("");
					$('#idCtePorTarjeta').val("");
					$('#nomTarjetaHabiente').val("");
				}

			}

			function cargaProperties(){
				ingresosOperacionesServicio.consultaProperties(function(properties){
					var proper = properties.split(',');
					mostrarBotones = proper[0];
					Busqueda = proper[1];

				if(mostrarBotones == 'N'){
					$('#buscarMiSucEf').hide();
					$('#buscarGeneralEf').hide();

					$('#buscarMiSucAb').hide();
					$('#buscarGeneralAb').hide();

					$('#buscarMiSucCre').hide();
					$('#buscarGeneralCre').hide();

					$('#buscarMiSuc').hide();
					$('#buscarGeneral').hide();

					$('#buscarMiSucDes').hide();
					$('#buscarGeneralDes').hide();

					$('#buscarMiSucA').hide();
					$('#buscarGeneralA').hide();

					$('#buscarMiSucD').hide();
					$('#buscarGeneralD').hide();

					$('#buscarMiSucSe').hide();
					$('#buscarGeneralSe').hide();

					$('#buscarMiSucPa').hide();
					$('#buscarGeneralPa').hide();

					$('#buscarMiSucP').hide();
					$('#buscarGeneralP').hide();

					$('#buscarMiSucC').hide();
					$('#buscarGeneralC').hide();

					$('#buscarMiSucApo').hide();
					$('#buscarGeneralApo').hide();

					$('#buscarMiSucRe').hide();
					$('#buscarGeneralRe').hide();

					$('#buscarMiGralArrendamiento').hide();
					$('#buscarMiSucArrendamiento').hide();
				}
				});
			}

			function validaLimites(){
				var cuentaValidar = {
					'cuentaAhoID'	: $('#cuentaAhoIDAb').val(),
					'fechaMovimiento': parametroBean,
					'montoMovimiento' : $('#montoAbonar').val().replace(',','')
						};
				cuentasAhoServicio.consultaCuentasAho(27,cuentaValidar,function(cuentaValidada){
					if(cuentaValidada!=null){
						if(parseInt(cuentaValidada.numMensaje) > 0 && parseInt(cuentaValidada.numMensaje) != 3 && parseInt(cuentaValidada.numMensaje) != 4){
							mensajeSis(cuentaValidada.mensaje);
							$('#cuentaAhoIDAb').focus();
						}
						if(parseInt(cuentaValidada.numMensaje) == 3 || parseInt(cuentaValidada.numMensaje) == 4){
							mostrarAlertLimite = 1;
							mensajeLimite	= cuentaValidada.mensaje;
							$('#grabaLimitesCta').val(1);
						}
					}
					else{
						mostrarAlertLimite=0;
						mensajeLimite='';
						$('#grabaLimitesCta').val(0);
					}
				});

			}

			//INICIA FUNCIONES PARA LA SECCION DE PAGO DE SERVICIOS EN LINEA---------------------------->
			/* == Métodos y manejo de eventos ====  */
			esTab = false;
			var numeroClienteConsulta; // se utiliza para validar que el campo de cliente haya cambiado

			$(':text').focus(function() {
				esTab = false;
			});

			$(':text').bind('keydown', function(e) {
				if (e.which == 9 && !e.shiftKey) {
					esTab = true;
				}
			});

			$(':button, :submit').focus(function() {
				esTab = false;
			});

			$(':button, :submit').bind('keydown',function(e){
				if (e.which == 9 && !e.shiftKey){
					esTab= true;
				}
			});

			$('input:checkbox').focus(function() {
				esTab = false;
			});

			$('input:checkbox').bind('keydown',function(e){
				if (e.which == 9 && !e.shiftKey){
					esTab= true;
				}
			});

			$('input:radio').focus(function() {
				esTab = false;
			});

			$('input:radio').bind('keydown',function(e){
				if (e.which == 9 && !e.shiftKey){
					esTab= true;
				}
			});

			$('#productoID').blur(function(){
				if(esTab){
					$('#tipoUsuarioC').focus();
				}
			});

			$('#tipoUsuarioC').blur(function(){
				if(esTab){
					$('#tipoUsuarioU').focus();
				}
			});

			$('#buscarGeneralPSL').blur(function(){
				if(esTab){
					$('#formaPagoE').focus();
				}
			});

			$('#formaPagoE').blur(function(){
				if(esTab){
					$('#formaPagoC').focus();
				}
			});

			$('#confirmReferenciaPSL').blur(function(){
				if(esTab){
					var esVisible = $("#cantEntraMil").is(":visible");
					if(esVisible){
						$('#cantEntraMil').focus();
					}else{
						if ($('#graba').is(':enabled')) {
							$('#graba').focus();
						} else {
							$('#tipoOperacion').focus();
						}
					}
				}
			});

			$('#confirmTelefonoPSL').blur(function(){
				if(esTab){
					var esVisible = $("#cantEntraMil").is(":visible");
					if(esVisible){
						$('#cantEntraMil').focus();
					}else{
						if ($('#graba').is(':enabled')) {
							$('#graba').focus();
						} else {
							$('#tipoOperacion').focus();
						}
					}
				}
			});

			$(':text, :button, :submit, :input:radio').blur(function() {
		        if($(this).attr('id') == $('#formaGenerica :input:enabled:visible:last').attr('id') && esTab) {
					setTimeout(function() {
		                $('#tipoOperacion').focus();
		            }, 0);
		        }
		    });

			$("#productoID").change(function() {
				var productoID = $("#productoID").val();
				var nombreProducto = $("#productoID").find("option:selected").text();

				refrescaCamposPSL();
				if(productoID == "") {
					$("#nombreProductoPSL").val('');
					return;
				}

				$("#nombreProductoPSL").val(nombreProducto);
				consultaProductoEnLinea(productoID);
			});


			$("#tipoUsuarioC").click(function() {
				refrescaCamposPSL();
			});

			$("#tipoUsuarioU").click(function() {
				$("#numeroTarjetaPSL").val('');
				$('#clienteIDPSL').val('');
				$('#nombreClientePSL').val('');
				$('#cuentaAhorroPSL').val('');
				$('#nomCuentaAhoPSL').val('');
				$("#saldoDisponPSL").val(0.0);
				$("#totalEntradaPSL").val(0.0);

				refrescaCamposPSL();
			});

			$("#formaPagoC").click(function() {
				$("#filaCuentaAhorroPSL").show();

				refrescaEntradasSalidasPSL();
				actualizaTotalesPSL();
			});

			$("#formaPagoE").click(function() {
				$("#filaCuentaAhorroPSL").hide();
				$("#cuentaAhorroPSL").val('');
				$("#nomCuentaAhoPSL").val('');
				$("#lblDescSaldoDispon").text('');
				$("#totalEntradaPSL").val(0.0);
				$("#saldoDisponPSL").val(0.0);

				refrescaEntradasSalidasPSL();
				actualizaTotalesPSL();
			});

			$('#buscarMiSucPSL').click(function() {
				listaCte('clienteIDPSL', '2', '19', 'nombreCompleto', $('#clienteIDPSL').val(), 'listaCliente.htm');
			});

			$('#buscarGeneralPSL').click(function() {
				listaCte('clienteIDPSL', '2', '31', 'nombreCompleto', $('#clienteIDPSL').val(), 'listaCliente.htm');
			});

			$('#numeroTarjetaPSL').blur(function(e) {
				var numerotarjeta = $('#numeroTarjetaPSL').val();
				if(esTab && numerotarjeta != null && numerotarjeta.length > 0){

				var tipoConsulta = 1;
				var tarjetaID = $('#numeroTarjetaPSL').val();
				var tarjetaDebitoBean = {
					'tarjetaDebID': tarjetaID
				};

				tarjetaDebitoServicio.consulta(tipoConsulta, tarjetaDebitoBean, function(tarjetaDebitoBeanResponse) {
					if(tarjetaDebitoBeanResponse != null) {

						if(tarjetaDebitoBeanResponse.estatus != '7' ){
							mensajeSis("Estatus de la Tarjeta de Débito inválida.");
							refrescaCamposCliente();
							$('#numeroTarjetaPSL').focus();
							return;
						}

						if(tarjetaDebitoBeanResponse.tipoTarjetaDebID != '9'){
							mensajeSis("El tipo de  tarjeta de Débito inválido.");
							refrescaCamposCliente();
							$('#numeroTarjetaPSL').focus();
							return;
						}

						$('#clienteIDPSL').val(tarjetaDebitoBeanResponse.clienteID);
						numeroClienteConsulta = tarjetaDebitoBeanResponse.clienteID;
						consultaDatosCliente(tarjetaDebitoBeanResponse.clienteID, '');
					}
					else {
						mensajeSis("Tarjeta de Débito no encontrada.");
						refrescaCamposCliente();
						$('#numeroTarjetaPSL').focus();
					}
				});

				}
			});

			function refrescaCamposCliente(){
				$("#clienteIDPSL").val('');
				$("#nombreClientePSL").val('');
				$("#cuentaAhorroPSL").val('');
				refrescaCamposCtaAhorro();
			}

			function refrescaCamposCtaAhorro(){
				$('#nomCuentaAhoPSL').val('');
				$("#saldoDisponPSL").val(0.0);
				$("#formaPagoE").attr('checked', false);
				$("#formaPagoC").attr('checked', false);
				$("#lblDescSaldoDispon").text('');
			}

			$('#clienteIDPSL').blur(function(e) {
				var numCliente = $('#clienteIDPSL').val();
				if(numCliente != '' && numCliente.length > 0){
					if(numeroClienteConsulta != numCliente){
						$('#numeroTarjetaPSL').val('');
					}

					var rfc = '';
					setTimeout("$('#cajaLista').hide();", 200);
					consultaDatosCliente(numCliente, rfc);
				}
			});

			function consultaDatosCliente(numCliente, rfc) {
				var conCliente = 1;

				$('#nombreClientePSL').val('');
				$('#cuentaAhorroPSL').val('');
				$('#nomCuentaAhoPSL').val('');
				$("#saldoDisponPSL").val(0.0);
				$("#totalEntradaPSL").val(0.0);
				if(numCliente != '' && !isNaN(numCliente)){
					clienteServicio.consulta(conCliente,numCliente,rfc, function(cliente){
						if(cliente!=null){
							listaPersBloqBean = consultaListaPersBloq(numCliente, esCliente, 0, 0);
							consultaSPL = consultaPermiteOperaSPL(numCliente,'LPB',esCliente);

							if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
								if (cliente.estatus=='I'){
									mensajeSis("El Cliente se encuentra Inactivo.");
									$('#clienteIDPSL').focus();
									return;
								}

								$('#nombreClientePSL').val(cliente.nombreCompleto);
							}else{
								mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
								$('#clienteIDPSL').focus();
							}
						}
						else{
							mensajeSis("No Existe el Cliente.");
							$('#clienteIDPSL').focus();
						}
					});
				}

				actualizaTotalesPSL();
			}

			$('#cuentaAhorroPSL').bind('keyup', function(e) {
				var numCliente = $('#clienteIDPSL').val();
				if(numCliente == '' || isNaN(numCliente)) {
					$("#nomCuentaAhoPSL").val('');
					return;
				}



				var camposLista = new Array();
				camposLista[0] = "clienteID";
				camposLista[1] = "nombreCompleto";
				var parametrosLista = new Array();
				parametrosLista[0] = $('#clienteIDPSL').val();
				parametrosLista[1] = '';

				listaCte('cuentaAhorroPSL', '2', '2', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');
			});

			$('#cuentaAhorroPSL').focus(function() {
			 	esTab = false;
			});

			$('#cuentaAhorroPSL').blur(function() {

				var numCliente = $('#clienteIDPSL').asNumber();
				var numCta = $('#cuentaAhorroPSL').val();

				if(numCliente == '' || numCta== ''){
					esTab= false;
				}

				if ($("#graba").is(":disabled") && esTab) {
		 			$("#cuentaAhorroPSL").focus();
		 		}

				if(numCliente == '' || isNaN(numCliente)) {
					$("#nomCuentaAhoPSL").val('');
					$("#saldoDisponPSL").val(0.0);
					$("#totalEntradaPSL").val(0.0);
					actualizaTotalesPSL();
					return;
				}

				//var numCta = $('#cuentaAhorroPSL').val();
				var tipoConsulta = 1;
				var CuentaAhoBeanCon = {
					'cuentaAhoID':numCta
				};

				setTimeout("$('#cajaLista').hide();", 200);
				if(numCta != '' && !isNaN(numCta)) {
					cuentasAhoServicio.consultaCuentasAho(tipoConsulta, CuentaAhoBeanCon,function(cuenta) {

						if(cuenta != null ) {
							if(numCliente != cuenta.clienteID){
								mensajeSis("La Cuenta de Ahorro no corresponde al Cliente " + numCliente);
								esTab = false;
								return;
							}

							if(cuenta.estatus != 'A'){

								mensajeSis("Estatus de la Cuenta de Ahorro inválido.");
								$('#nomCuentaAhoPSL').val('');
								$("#saldoDisponPSL").val(0.0);
								$("#lblDescSaldoDispon").text('');
								esTab = false;
								return;
							}else{
								$("#nomCuentaAhoPSL").val(cuenta.etiqueta);
								$("#saldoDisponPSL").val(cuenta.saldoDispon);

							}

						}
						else {
							$("#nomCuentaAhoPSL").val('');
							$("#saldoDisponPSL").val(0.0);
							mensajeSis("No Existe la Cuenta de Ahorro.");
							esTab = false;
							return;
						}
						actualizaTotalesPSL();
					});
				}
				else{
					$("#nomCuentaAhoPSL").val('');
					$("#saldoDisponPSL").val(0.0);
					actualizaTotalesPSL();
				}

				actualizaTotalesPSL();

			});

			$('#totalPagarPSL').blur(function() {
				actualizaTotalesPSL();
			});

			function refrescaCamposPSL() {
				var deshabilitado = !($("#productoID").val() != "" && ($("#tipoUsuarioC").attr('checked') || $("#tipoUsuarioU").attr('checked')));

				$("#telefonoPSL").attr('disabled', deshabilitado);
				$("#confirmTelefonoPSL").attr('disabled', deshabilitado);
				$("#referenciaPSL").attr('disabled', deshabilitado);
				$("#confirmReferenciaPSL").attr('disabled', deshabilitado);

				if(deshabilitado) {
					return;
				}


				if($("#tipoUsuarioC").attr('checked')) {
					$("#formaPagoE").attr('disabled', false);
					$("#formaPagoC").attr('disabled', false);
					//$("#filaNumeroTarjetaPSL").show();
					$("#filaClientePSL").show();

					if(identificaSocioTarjeta == 'S'){
						$("#lblnumeroTarjetaPSL, #numeroTarjetaPSL").show();
					}else{
						$("#lblnumeroTarjetaPSL, #numeroTarjetaPSL").hide();
					}


					refrescaEntradasSalidasPSL();
					var productoID = $("#productoID").val();
					if(productoID == "") {
						return;
					}
					consultaProductoEnLinea(productoID);
				}
				else {
					$("#formaPagoE").attr('disabled', false);
					$("#formaPagoE").attr('checked', true);
					$("#formaPagoC").attr('disabled', true);

					$("#lblnumeroTarjetaPSL, #numeroTarjetaPSL").hide();
					$("#filaClientePSL").hide();
					$("#filaCuentaAhorroPSL").hide();

					refrescaEntradasSalidasPSL();
					var productoID = $("#productoID").val();
					if(productoID == "") {
						return;
					}
					consultaProductoEnLinea(productoID);
				}
			}

			function refrescaEntradasSalidasPSL() {
				inicializaSaldosPSL();

				if($("#formaPagoE").attr('checked')) {
					$('#entradaSalida').show();
					$('#totales').show();
				}
				else if($("#formaPagoC").attr('checked')) {
					$('#entradaSalida').hide();
					$('#totales').hide();
				}
			}

			function inicializaPagoServiciosEnLinea() {

				limpiaCamposPSL();
				consultaProductosEnLinea();
				inicializaSaldosPSL();
				$("#formaGenerica").validate().resetForm();
			}

			function inicializaSaldosPSL() {
				inicializarEntradasSalidasEfectivo();
				crearListaBilletesMonedasEntrada();
				crearListaBilletesMonedasSalida();
				consultaDisponibleDenominacion();
				consultarParametrosBean();
				mostrarSaldoDisponible();
			}

			function limpiaCamposPSL() {
				inicializarEntradasSalidasEfectivo();
				consultarParametrosBean();

				$("#nombreProductoPSL").val('');
				$("#totalEntradaPSL").val(0.0);
				$("#telefonoPSL").attr('disabled', true);
				$("#confirmTelefonoPSL").attr('disabled', true);
				$("#referenciaPSL").attr('disabled', true);
				$("#confirmReferenciaPSL").attr('disabled', true);

				$("#tipoUsuarioC").attr('checked', false);
				$("#tipoUsuarioU").attr('checked', false);
				$("#numeroTarjetaPSL").val('');
				$("#clienteIDPSL").val('');
				$("#nombreClientePSL").val('');

				$("#formaPagoE").attr('disabled', true);
				$("#formaPagoE").attr('checked', false);
				$("#formaPagoC").attr('disabled', true);
				$("#formaPagoC").attr('checked', false);
				$("#cuentaAhorroPSL").val('');
				$("#nomCuentaAhoPSL").val('');
				$("#saldoDisponPSL").val(0.0);
				$("#lblDescSaldoDispon").text('');
				$("#precio").val('');
				$("#comisiProveedor").val('');
				$("#comisiInstitucion").val('');
				$("#ivaComisiInstitucion").val('');
				$("#totalComisiones").val('');
				$("#totalPagarPSL").val('');
				$("#telefonoPSL").val('');
				$("#referenciaPSL").val('');
				$("#confirmTelefonoPSL").val('');
				$("#confirmReferenciaPSL").val('');
				$("#telefonoPSL").removeClass('error');
				$("#referenciaPSL").removeClass('error');
				$("#confirmTelefonoPSL").removeClass('error');
				$("#confirmReferenciaPSL").removeClass('error');
				$("#clienteIDPSL").removeClass('error');
				$("#cuentaAhorroPSL").removeClass('error');

				$("#tipoReferencia").val('');
				$("#tipoFront").val('');

				$("#lblnumeroTarjetaPSL, #numeroTarjetaPSL").hide();
				$("#filaClientePSL").hide();
				$("#filaCuentaAhorroPSL").hide();
			}

			$("#precio").blur(function() {
				actualizaTotalesPSL();
				actualizaDescSaldoSuficiente();
			});

			function consultaProductosEnLinea() {
				var configProductoBean = {
					"productoID": "",
					"servicioID": "",
					"clasificacionServ": ""
				};

				pslConfigProductoServicio.lista(1, configProductoBean, function(listaProductos) {
	  				if(listaProductos != null) {
	  			  		dwr.util.removeAllOptions('productoID');
	  			  		dwr.util.addOptions('productoID', {'':'SELECCIONAR'});
	  					dwr.util.addOptions('productoID', listaProductos, 'productoID', 'descProducto');
	  				}
	  				else{
	  					dwr.util.removeAllOptions('productoID');
	  					dwr.util.addOptions('productoID', 'NO TIENE OPCIONES');
	  				}
	  			});
			}

			function actualizaTotalPagarPSL() {
				var monto = parseFloat($("#precio").val().replace(/,/g , ""));
				if(isNaN(monto)) {
					monto = 0.0;
				}
				var mtoComisiProveedor = parseFloat($("#comisiProveedor").val());
				if(isNaN(mtoComisiProveedor)) {
					mtoComisiProveedor = 0.0;
				}
				var mtoComisiInstitucion = parseFloat($("#comisiInstitucion").val());
				if(isNaN(mtoComisiInstitucion)) {
					mtoComisiInstitucion = 0.0;
				}
				var mtoIvaComisiInstitucion = parseFloat($("#ivaComisiInstitucion").val());
				if(isNaN(mtoIvaComisiInstitucion)) {
					mtoIvaComisiInstitucion = 0.0;
				}

				var totalServicioPSL = monto + mtoComisiProveedor;
				var totalComision = mtoComisiProveedor + mtoComisiInstitucion + mtoIvaComisiInstitucion;
				var totalPagar = 0;
				if(monto != 0) {
					totalPagar = monto + totalComision;
				}
				$("#totalComisiones").val(totalComision);
				$("#totalPagarPSL").val(totalPagar);
				$("#totalServicioPSL").val(totalServicioPSL);
			}

			function actualizaDescSaldoSuficiente() {
				//Para forma de pago Efectivo no se muestra la descripcion de saldo
				$("#lblDescSaldoDispon").text('');
				if($("#formaPagoE").attr('checked')) {
					return;
				}

				var numCliente = $('#clienteIDPSL').val();
				var saldoDisponible = $("#saldoDisponPSL").asNumber();
				var totalAPagar = $("#totalPagarPSL").asNumber();
				var cuentaAhorroPSL = $("#cuentaAhorroPSL").asNumber();
				var productoID = $("#productoID").asNumber();

				if(numCliente == '' || isNaN(numCliente) || cuentaAhorroPSL <= 0 || productoID <= 0) {
					return;
				}

				if(totalAPagar > saldoDisponible) {
					$("#lblDescSaldoDispon").text("Saldo Insuficiente");
					$("#lblDescSaldoDispon").css('color', '#c12b0a');
				}
				else {
					$("#lblDescSaldoDispon").text("Saldo Suficiente");
					$("#lblDescSaldoDispon").css('color', '#34904c');
				}
			}

			function actualizaTotalesPSL() {
				$("#totalEntradaPSL").val(0.0);
				actualizaTotalPagarPSL();
				actualizaDescSaldoSuficiente();

				var productoID = $("#productoID").val();
				var clienteID = $("#clienteIDPSL").asNumber();
				var cuentaAhorroPSL = $("#cuentaAhorroPSL").asNumber();
				if(clienteID <= 0 || cuentaAhorroPSL <= 0 || productoID <= 0) {
					totalEntradasSalidasDiferencia();
					return;
				}

				var totalPagar = $("#totalPagarPSL").asNumber();
				if(totalPagar == null || isNaN(totalPagar)) {
					totalPagar = 0;
				}
				var saldoDisponible = $("#saldoDisponPSL").asNumber();
				if(saldoDisponible == null || isNaN(saldoDisponible)) {
					saldoDisponible = 0;
				}

				if($("#formaPagoC").attr('checked')) {
					if(saldoDisponible >= totalPagar) {
						$("#totalEntradaPSL").val(totalPagar);
					}
				}

				totalEntradasSalidasDiferencia();
			}

			function consultaProductoEnLinea(idProducto) {
				//Consultamos la configuracion del servicio

				var tipoConsulta = 1;
				var pslConfigProductoBean = {
					'productoID': idProducto,
					'servicioID': '',
					'clasificacionServ': ''
				};

				$("#numeroTarjetaPSL").val('');
				$('#clienteIDPSL').val('');
				$('#nombreClientePSL').val('');
				$('#cuentaAhorroPSL').val('');
				$('#nomCuentaAhoPSL').val('');
				$("#saldoDisponPSL").val(0.0);
				$("#totalEntradaPSL").val(0.0);
				$("#lblDescSaldoDispon").text('');
				$("#tipoReferencia").val('');
				$("#tipoFront").val('');

				pslConfigProductoServicio.consulta(tipoConsulta, pslConfigProductoBean, function(configProductoBeanResponse) {
					if(configProductoBeanResponse != null) {
						if(configProductoBeanResponse.clasificacionServ == "CO") {
							//Reiniciamos valores en los componentes
							$("#precio").val(0.0);
							$("#comisiProveedor").val(0.0);
							$("#servicioIDPSL").val(0);
							$("#clasificacionServPSL").val('');
							$("#comisiInstitucion").val(0.0);
							$("#ivaComisiInstitucion").val(0.0);
							$("#telefonoPSL").val('');
							$("#confirmTelefonoPSL").val('');
							$("#referenciaPSL").val('');
							$("#confirmReferenciaPSL").val('');

							//Deshabilitamos todos los componentes
							$("#precio").attr('disabled', true);
							$("#telefonoPSL").attr('disabled', true);
							$("#confirmTelefonoPSL").attr('disabled', true);
							$("#referenciaPSL").attr('disabled', true);
							$("#confirmReferenciaPSL").attr('disabled', true);
							$("#formaPagoE").attr('disabled', true);
							$("#formaPagoE").attr('checked', false);
							$("#formaPagoC").attr('disabled', true);
							$("#formaPagoC").attr('checked', false);
							$("#lblnumeroTarjetaPSL, #numeroTarjetaPSL").hide();
							$("#filaClientePSL").hide();
							$("#filaCuentaAhorroPSL").hide();

							actualizaTotalesPSL();
							//Oculto los grids de entradas y salidas
							$('#entradaSalida').hide();
							$('#totales').hide();
							mensajeSis("Los productos de Consulta de Saldo no son permitidos en Ventanilla.");

							return;
						}

						var monto = parseFloat(configProductoBeanResponse.precio);
						$("#tipoFront").val(configProductoBeanResponse.tipoFront);
						$("#tipoReferencia").val(configProductoBeanResponse.tipoReferencia);
						$("#precio").val(monto);
						$("#comisiProveedor").val(configProductoBeanResponse.mtoProveedor);
						$("#servicioIDPSL").val(configProductoBeanResponse.servicioID);
						$("#clasificacionServPSL").val(configProductoBeanResponse.clasificacionServ);
						if($("#tipoUsuarioU").attr('checked')) {
							if(configProductoBeanResponse.cobComVentanilla=='S') {
								$("#comisiInstitucion").val(configProductoBeanResponse.mtoUsuVentanilla);
								$("#ivaComisiInstitucion").val(configProductoBeanResponse.ivaMtoUsuVentanilla);
							}
							else {
								$("#comisiInstitucion").val(0.0);
								$("#ivaComisiInstitucion").val(0.0);
							}
						}
						else if($("#tipoUsuarioC").attr('checked')) {
							if(configProductoBeanResponse.cobComVentanilla=='S') {
								$("#comisiInstitucion").val(configProductoBeanResponse.mtoCteVentanilla);
								$("#ivaComisiInstitucion").val(configProductoBeanResponse.ivaMtoCteVentanilla);
							}
							else {
								$("#comisiInstitucion").val(0.0);
								$("#ivaComisiInstitucion").val(0.0);
							}
						}
						$("#telefonoPSL").val('');
						$("#confirmTelefonoPSL").val('');
						$("#referenciaPSL").val('');
						$("#confirmReferenciaPSL").val('');

						//Por defecto la referencia se habilita en tipoFront <> 1
						var habilitarReferencia = true;
						//Para el tipoFront 1 Se habilita el telefono o la referencia dependiendo del Tipo de Referencia
						if( configProductoBeanResponse.tipoFront == 1) {
							switch(configProductoBeanResponse.tipoReferencia) {
							    case "a":
							    case "":
							    	habilitarReferencia = false;
							        break;
							    case "b":
							    case "c":
							    case "bc":
							    	habilitarReferencia = true;
							        break;
							    default:
							    	habilitarReferencia = false;
							    	break;
							}

						}
						//El campo telefono se oculta o muestra dependiendo del campo de referencia
						var habilitarTelefono = !habilitarReferencia;

						//Desabilitamos el campo precio para Recarga y Consulta de Saldo
						$("#precio").attr('disabled', (configProductoBeanResponse.clasificacionServ == "RE"));
						$("#telefonoPSL").attr('disabled', !habilitarTelefono);
						$("#confirmTelefonoPSL").attr('disabled', !habilitarTelefono);
						$("#telefonoPSL").attr('hidden', !habilitarTelefono);
						$("#confirmTelefonoPSL").attr('hidden', !habilitarTelefono);
						$("#lbltelefonoPSL").attr('hidden', !habilitarTelefono);
						$("#lblconfirmTelefonoPSL").attr('hidden', !habilitarTelefono);

						$("#referenciaPSL").attr('disabled', !habilitarReferencia);
						$("#confirmReferenciaPSL").attr('disabled', !habilitarReferencia);
						$("#referenciaPSL").attr('hidden', !habilitarReferencia);
						$("#confirmReferenciaPSL").attr('hidden', !habilitarReferencia);
						$("#lblreferenciaPSL").attr('hidden', !habilitarReferencia);
						$("#lblconfirmReferenciaPSL").attr('hidden', !habilitarReferencia);

						actualizaTotalesPSL();
					}
				});
			}
			//<----------------------------TERMINA FUNCIONES PARA LA SECCION DE PAGO DE SERVICIOS EN LINEA

			// ------------ INICIO FUNCIONES PARA COBRO DE ACCESORIOS -------------------
			function consultaCreditoCobAcc(idControl){
				var jqControl = eval("'#"+idControl+"'");
				var creditoConBean = {
					'creditoID' : $(jqControl).val()
				};
				if ($(jqControl).val()!='' && !isNaN($(jqControl).val())) {
					creditosServicio.consulta(40,creditoConBean,{
						async:false,
						callback: function(creditoBean){
							if (creditoBean!=null) {
								listaPersBloqBean = consultaListaPersBloq(creditoBean.clienteID, esCliente, 0, 0);
								consultaSPL = consultaPermiteOperaSPL(creditoBean.clienteID,'LPB',esCliente);

								if((listaPersBloqBean.estaBloqueado == 'S' && consultaSPL.permiteOperacion == 'S') || listaPersBloqBean.estaBloqueado == 'N'){
									$('#clienteIDCA').val(creditoBean.clienteID);
									$('#montoCreCA').val(creditoBean.montoCredito);
									$('#productoCreditoIDCA').val(creditoBean.producCreditoID);
									$('#cuentaAhoIDCAc').val(creditoBean.cuentaID);
									$('#tipoComisionCA').val('ANTICIPADA');
									$('#monedaIDCAc').val(creditoBean.monedaID);
									consultaAccesorios('creditoIDCA');
									if (Number(creditoBean.grupoID)>0) {
										$('#grupoIDCA').val(creditoBean.grupoID);
										$('#tdGrupoCAlabel').show();
										$('#tdGrupoCAinput').show();
										consultaGrupo(creditoBean.grupoID,'grupoIDCA', 'grupoDesCA','');
									}else{
										$('#grupoIDCA').val('');
										$('#grupoDesCA').val('');
										$('#tdGrupoCAlabel').hide();
										$('#tdGrupoCAinput').hide();
									}
									consultaProdCredCA('productoCreditoIDCA');
									consultaClienteComApDes(creditoBean.clienteID, 'clienteIDCA', 'nombreClienteCA');
									consultaCuentaCA(creditoBean.cuentaID,'cuentaAhoIDCAc','nomCuentaCA');
									consultaMonedaCA('monedaIDCAc');
									inicializaMontos();
								}else{
									mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
									inicializarCampos();
									setTimeout("$('#creditoIDCA').focus();",0);
								}
							}else{
								mensajeSis("El Crédito seleccionado no Existe.");
								inicializarCampos();
								setTimeout("$('#creditoIDCA').focus();",0);
							}
						}
					});
				}
			}

			function consultaAccesorios(idControl){
				var jqControl = eval("'#"+idControl+"'");
				var esquemaConBean = {
					'creditoID' : $(jqControl).val()
				};
				if ($(jqControl).val()!='' && !isNaN($(jqControl).val())) {
					esquemaOtrosAccesoriosServicio.listaCombo(4,esquemaConBean,{
						async: false,
						callback: function(listaAccesorios){
							if(listaAccesorios!=null){
								dwr.util.removeAllOptions('accesorioID');
								dwr.util.addOptions('accesorioID', {'':'SELECCIONAR'});
								dwr.util.addOptions('accesorioID', listaAccesorios, 'accesorioID', 'nombreCorto');
								if(listaAccesorios.length==0){
									mensajeSis("El Crédito ya no tiene Accesorios Pendientes por Pagar.");
									$('#creditoIDCA').focus();
								}
							}else{
								mensajeSis("El Crédito seleccionado no crobra Accesorios.");
								inicializarCampos();
							}
						}
					});
				}
			}

			function consultaSaldoAccesorio(idControl){
				var jqControl = eval("'#"+idControl+"'");
				var accesorioBean = {
					'creditoID' 	: $(jqControl).val(),
					'accesorioID' 	: $('#accesorioID').val()
				};
				if ($('#accesorioID').val()!='' && !isNaN($('#accesorioID').val())) {
					esquemaOtrosAccesoriosServicio.consulta(2,accesorioBean,{
						async: false,
						callback: function(accesoriosBeanCon){
							if (accesoriosBeanCon!=null) {
								$('#montoComisionCA').val(accesoriosBeanCon.montoAccesorio);
								$('#ivaMontoRealCA').val(accesoriosBeanCon.montoIVAAccesorio);
								$('#totalPagadoDepCA').val(accesoriosBeanCon.montoPagado);
								$('#comisionPendienteCA').val(accesoriosBeanCon.saldoAccesorio);
								$('#ivaPendienteCA').val(accesoriosBeanCon.saldoIVAAccesorio);
								$('#comisionCA').val(accesoriosBeanCon.saldoAccesorio);
								$('#ivaCA').val(accesoriosBeanCon.saldoIVAAccesorio);
								$('#totalDepCA').val((parseFloat(accesoriosBeanCon.saldoAccesorio) + parseFloat(accesoriosBeanCon.saldoIVAAccesorio)).toFixed(2));
							}
						}
					});
				}else{
					$('#creditoIDCA').focus();
					inicializaMontos();
				}
			}

			function consultaProdCredCA(idControl) {
				var jqControl = eval("'#"+idControl+"'");
				var conTipo = 2;
				var ProdCredBeanCon = {
		  			'producCreditoID': $(jqControl).val()
				};
				if($(jqControl).val() != '' && !isNaN($(jqControl).val())){
					productosCreditoServicio.consulta(conTipo, ProdCredBeanCon,function(prodCred) {
						if(prodCred!=null){
							$(desProdCreditoCA).val(prodCred.descripcion);
						}
					});
				}
			}

			function consultaCuentaCA(valorID,idCampo,desCuenta){
				var jqnumCta  = eval("'#" + idCampo + "'");
				var numCta = $(jqnumCta).val();
		        var conCta = 4;

		        var CuentaAhoBeanCon = {
		        		'cuentaAhoID':valorID,
		        		'clienteID':$('#clienteIDCA').val()
		        };
		        if(numCta != '' && !isNaN(numCta)){
		        	cuentasAhoServicio.consultaCuentasAho(conCta, CuentaAhoBeanCon,function(cuenta) {
		        		if(cuenta!=null){
		        			$('#'+desCuenta).val(cuenta.descripcionTipoCta);
		        		}else{
		        			mensajeSis("No Existe la Cuenta de Ahorro.");
		        		}
		        	});
		        }
			}

			function consultaMonedaCA(idControl) {
				var jqMoneda = eval("'#" + idControl + "'");
				var numMoneda = $(jqMoneda).val();
				var conMoneda=2;
				if(numMoneda != '' && !isNaN(numMoneda)){
					monedasServicio.consultaMoneda(conMoneda,numMoneda,function(moneda) {
						if(moneda!=null){
							$('#monedaDesCA').val(moneda.descripcion);
						}else{
							mensajeSis("No Existe el Tipo de Moneda.");
						}
					});
				}
			}

			function calcMontosPagAccesorios(){
				var IVACliente = 'N';
				var IVAAccesorio = 'N';
				var valorIVA = 0.0;
				var sucursalCliente = 0;

				var clienteID = $('#clienteIDCA').val();

				if (!isNaN(clienteID)) {
					clienteServicio.consulta(1,clienteID,{
						async : false,
						callback: function(clienteBeanCon){
							if (clienteBeanCon!=null) {
								sucursalCliente = clienteBeanCon.sucursalOrigen;
								IVACliente = clienteBeanCon.pagaIVA;
							}
						}
					});
				}

				var accesorioBean = {
					'producCreditoID' : $('#productoCreditoIDCA').val(),
					'accesorioID' : $('#accesorioID').val()
				};
				if (!isNaN(accesorioBean.producCreditoID) && !isNaN(accesorioBean.accesorioID)) {
					esquemaOtrosAccesoriosServicio.consulta(1,accesorioBean,{
						async : false,
						callback : function(accesorio){
							if (accesorio!=null) {
								IVAAccesorio = accesorio.cobraIVA;
							}
						}
					});
				}

				if (!isNaN(sucursalCliente)) {
					sucursalesServicio.consultaSucursal(1,sucursalCliente,{
						async : false,
						callback : function(sucursal){
							if (sucursal!=null) {
								valorIVA = sucursal.IVA;
							}
						}
					});
				}

				if (IVACliente=='S' && IVAAccesorio=='S') {
					var montoSaldo = $('#totalDepCA').asNumber();
					$('#comisionCA').val((parseFloat(montoSaldo)/(parseFloat(1.0)+parseFloat(valorIVA))).toFixed(2));
					$('#ivaCA').val(((parseFloat(montoSaldo)/(parseFloat(1.0)+parseFloat(valorIVA)))*parseFloat(valorIVA)).toFixed(2));
				}else{
					$('#comisionCA').val($('#totalDepCA').val());
					$('#ivaCA').val('0.00');
				}

			}

			function consultaCobraAccesorios(){
				var tipoConsulta = 24;
				var bean = {
						'empresaID'		: 1
					};

				paramGeneralesServicio.consulta(tipoConsulta, bean, { async: false, callback:function(parametro) {
						if (parametro != null){
							cobraAccesoriosGen = parametro.valorParametro;
						}else{
							cobraAccesoriosGen = 'N';
						}
				}});
			}

			function inicializaMontos(){
				$('#montoComisionCA').val('0.00');
				$('#ivaMontoRealCA').val('0.00');
				$('#totalPagadoDepCA').val('0.00');
				$('#comisionPendienteCA').val('0.00');
				$('#ivaPendienteCA').val('0.00');
				$('#comisionCA').val('0.00');
				$('#ivaCA').val('0.00');
				$('#totalDepCA').val('0.00');
			}
			// ------------ FIN FUNCIONES PARA COBRO DE ACCESORIOS ----------------------

			/* ESTA LINEA SIEMPRE DEBE DE ESTAR AL FINAL DEL DOCUMENT*/
			if(parametroBean.tipoImpTicket == ticket){
				findPrinter();
			}
		});// fin Document

		// Función para consultar el saldo de FOGAFI y descontarlo a la garantía Adicional
		function consultaSaldoFOGAFI(){

			var montoGarAd = 0.00;

			if(garFinanciada=='S'){
				var creditoBean = {
					'creditoID' : $('#creditoID').val()
				};
				$('#garantiaAdicionalPC').attr('disabled','disabled');
				creditosServicio.consulta(42,creditoBean,{
					async : false,
					callback : function(credito){
						if( credito!=null && credito.montoFOGAFI!=null && credito.montoFOGAFI>0){

							montoGarAd = ( ($('#garantiaAdicionalPC').asNumber() - parseFloat(credito.montoFOGAFI)) < 0 ) ? '0.00' :( $('#garantiaAdicionalPC').asNumber() - parseFloat(credito.montoFOGAFI,2) );

							$('#garantiaAdicionalPC').val( montoGarAd );

							$('#sumaPendienteGarAdiInt').val( montoGarAd );

							$('#montoPagadoCredito').val( $('#montoPagar').asNumber() - $('#garantiaAdicionalPC').asNumber() );

						}

						$('#garantiaAdicionalPC').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});

						$('#sumaPendienteGarAdiInt').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
					}
				});
			}

		}

		// funcion para validar que la suma de la GL adicional por integrante
		// no sea mayor al monto de gl adicional indicado se usa en pago credito
		function validaSumaGarantiaAdicionalGrupal(fila){
			var jqGarantiaAdiGruID = "";
			var jqGarantiaAdiID = eval("'#garantiaAdicional"+ fila+ "'");
			var suma = 0;

			$('input[name=garantiaAdicional]').each(function() {
				jqGarantiaAdiGruID = eval("'#" + this.id + "'");
				if($(jqGarantiaAdiGruID).asNumber() >= "0" && !isNaN($(jqGarantiaAdiGruID).asNumber())){
					suma = suma + $(jqGarantiaAdiGruID).asNumber();
					if(suma.toFixed(2) > $('#garantiaAdicionalPC').asNumber()){
						if(muestraAlertInt == 0){
							mensajeSis("La Suma de la Garantía Adicional de los Integrantes \nDebe de Corresponder con la Garantía Adicional.");
						}
						$(jqGarantiaAdiID).val("0.00");
						$(jqGarantiaAdiID).focus();
						$(jqGarantiaAdiID).select();
						var pendiente = $('#garantiaAdicionalPC').asNumber()-$('#sumaGarantiaAdicionalInt').asNumber();
						$('#sumaPendienteGarAdiInt').val(pendiente.toFixed(2));
						$('#sumaGarantiaAdicionalInt').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
						muestraAlertInt = 1;
					}else{
						muestraAlertInt = 0;
						$('#sumaGarantiaAdicionalInt').val(suma.toFixed(2));
						$('#sumaGarantiaAdicionalInt').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
						var pendiente = $('#garantiaAdicionalPC').asNumber() - suma.toFixed(2);
						$('#sumaPendienteGarAdiInt').val(pendiente);
						$('#sumaPendienteGarAdiInt').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
					}
				}else {
					$(jqGarantiaAdiGruID).val("0.00");
				}
			});
		}
		//funcion para validar cuando un campo de un grid toma el foco
		function validaFocoInputMonedaGrid(controlID){
			jqID = eval("'#" + controlID + "'");
			if($(jqID).asNumber()>0){
				$(jqID).select();
			}else{
				$(jqID).val("");
			}
		}

		// funcion para validar cuando un campo toma el foco
		function validaFocoInputMoneda(controlID){
			 jqID = eval("'#" + controlID + "'");
			 if($(jqID).asNumber()>0){
				 $(jqID).select();
			 }else{
				 $(jqID).val("");
			 }
		}
		// valida el color de la etiqueta cuando es pago de credito
		// y existe garantia liquida adicional
		function estiloSumaPendienteGarAdiInt(){
			if($('#sumaPendienteGarAdiInt').asNumber()>0){
				document.getElementById('labelPendienteAsignar').style = "color: red";
			}else{
				document.getElementById('labelPendienteAsignar').style = "color: black";
			}
		}
		var muestraAlertInt = 0;

		function cantidadFormatoMoneda(num,prefix)  {
			num = Math.round(parseFloat(num)*Math.pow(10,2))/Math.pow(10,2) ;
			prefix = prefix || '';
			num += '';
			var splitStr = num.split('.');
			var splitLeft = splitStr[0];
			var splitRight = splitStr.length > 1 ? '.' + splitStr[1] : '.00';
			splitRight = splitRight + '00';
			splitRight = splitRight.substr(0,3);
			var regx = /(\d+)(\d{3})/;
			while (regx.test(splitLeft)) {
				splitLeft = splitLeft.replace(regx, '$1' + ',' + '$2');
			}
			return prefix + splitLeft + splitRight;
		}
		function llenaComboTiposIdenti(){
			dwr.util.removeAllOptions('tipoIdentificacion');
			tiposIdentiServicio.listaCombo(3, function(tIdentific){
				dwr.util.addOptions('tipoIdentificacion'	,{'':'SELECCIONAR'});
				dwr.util.addOptions('tipoIdentificacion', tIdentific, 'tipoIdentiID', 'nombre');
			});
		}
		function llenaComboTiposIdentiServicio(){
			dwr.util.removeAllOptions('indentiClienteServicio');
			tiposIdentiServicio.listaCombo(3, function(tIdentific){
				dwr.util.addOptions('indentiClienteServicio'	,{'':'SELECCIONAR'});
				dwr.util.addOptions('indentiClienteServicio', tIdentific, 'tipoIdentiID', 'nombre');
			});
		}
		function consultaSucursalGenerica(idControl,campoDescripcion) {
			var jqSucursal = eval("'#" + idControl + "'");
			var numSucursal = $(jqSucursal).val();
			var conSucursal=2;
			setTimeout("$('#cajaLista').hide();", 200);
			if(numSucursal != '' && !isNaN(numSucursal) ){
				sucursalesServicio.consultaSucursal(conSucursal,numSucursal,function(sucursal) {
					if(sucursal!=null){
						$('#'+campoDescripcion).val(sucursal.nombreSucurs);
					}else{
						mensajeSis("No Existe la Sucursal.");
					}
				});
			}
		}
		//para llevar el total de entradas    ttttt
		function totalEntradasSalidasGrid(){
			controlQuitaFormatoMoneda('sumTotalSal');
			controlQuitaFormatoMoneda('sumTotalEnt');
			esTab= true;
			setTimeout("$('#cajaLista').hide();", 200);
			var sumaEntradas = parseFloat(0);
			var sumaSalidas = parseFloat(0);
			var diferencia = parseFloat(0);
			var sumaEntradasOperacion	= parseFloat(0);
			var sumaSalidasOperacion	= parseFloat(0);

			var sumTotalSal= $('#sumTotalSal').asNumber();
			var sumTotalEnt= $('#sumTotalEnt').asNumber();
			var montoPagarApoyoEscolar	= $('#monto').asNumber();
			var montoPagarSERVIFUN		= $('#montoEntregarServifun').asNumber();
			var montoRecepChequeSBC=	$('#montoSBC').asNumber();
			var montoComisionTarjeta	= $('#totalComisionTD').asNumber();

			sumaEntradas= sumTotalEnt+montoPagarSERVIFUN+montoPagarApoyoEscolar+montoRecepChequeSBC;
			sumaSalidas	= sumTotalSal+montoComisionTarjeta;

			sumaEntradasOperacion= montoPagarSERVIFUN+montoPagarApoyoEscolar+montoRecepChequeSBC;
			sumaSalidasOperacion	= montoComisionTarjeta;

			if($('#tipoOperacion').asNumber() == recepChequeSBC ){
				if(  ($('#tipoCtaCheque').val() == 'I' && $('#formaCobro1').attr('checked') == true)
						|| ($('#tipoCtaCheque').val() == 'E')){
					sumaSalidas = sumaEntradas;
				}
			}


			if(sumaEntradas.toFixed(2)>=sumaSalidas.toFixed(2)){
				diferencia = parseFloat(sumaEntradas).toFixed(2)- parseFloat(sumaSalidas).toFixed(2) ;
			}else{
				diferencia = parseFloat(sumaSalidas).toFixed(2)- parseFloat(sumaEntradas).toFixed(2) ;
			}

			$('#totalEntradas').val(sumaEntradas);
			$('#totalSalidas').val(sumaSalidas);
			$('#diferencia').val(diferencia);

			if(diferencia == 0 && ($('#totalEntradas').asNumber() >0 || $('#totalSalidas').asNumber() >0) &&
					(sumaEntradasOperacion >0 || sumaSalidasOperacion >0) ){
				if($('#numeroTransaccion').asNumber()>0 ){
		  			deshabilitaBoton('graba', 'submit');
		  		}else{
					habilitaBoton('graba', 'submit');
		  		}

			}else{
				deshabilitaBoton('graba', 'submit');
			}

			actualizaFormatosMoneda('formaGenerica');
			$('#numeroTransaccion').val("");
			$('#impTicket').hide();
			$('#impCheque').hide();
			ocultarBtnResumen();
		}
		//deshabilitarEntradasSalidasEfectivo	hhhhh
		function soloLecturaEntradasSalidasEfectivo() {
			$('#cantEntraMil').attr('readOnly',true);
			$('#cantEntraQui').attr('readOnly',true);
			$('#cantEntraDos').attr('readOnly',true);
			$('#cantEntraCien').attr('readOnly',true);
			$('#cantEntraCin').attr('readOnly',true);
			$('#cantEntraVei').attr('readOnly',true);
			$('#cantEntraMon').attr('readOnly',true);
			$('#cantSalMil').attr('readOnly',true);
			$('#cantSalQui').attr('readOnly',true);
			$('#cantSalDos').attr('readOnly',true);
			$('#cantSalCien').attr('readOnly',true);
			$('#cantSalCin').attr('readOnly',true);
			$('#cantSalVei').attr('readOnly',true);
			$('#cantSalMon').attr('readOnly',true);
		}
		function habilitaEntradasSalidasEfectivo() {
			$('#cantEntraMil').attr('readOnly',false);
			$('#cantEntraQui').attr('readOnly',false);
			$('#cantEntraDos').attr('readOnly',false);
			$('#cantEntraCien').attr('readOnly',false);
			$('#cantEntraCin').attr('readOnly',false);
			$('#cantEntraVei').attr('readOnly',false);
			$('#cantEntraMon').attr('readOnly',false);
			$('#cantSalMil').attr('readOnly',false);
			$('#cantSalQui').attr('readOnly',false);
			$('#cantSalDos').attr('readOnly',false);
			$('#cantSalCien').attr('readOnly',false);
			$('#cantSalCin').attr('readOnly',false);
			$('#cantSalVei').attr('readOnly',false);
			$('#cantSalMon').attr('readOnly',false);
		}
		function inicializaCantidadEntradaSalida(){
			$('#cantEntraMil').val(0);
			$('#cantEntraQui').val(0);
			$('#cantEntraDos').val(0);
			$('#cantEntraCien').val(0);
			$('#cantEntraCin').val(0);
			$('#cantEntraVei').val(0);
			$('#cantEntraMon').val(0);

			$('#cantSalMil').val(0);
			$('#cantSalQui').val(0);
			$('#cantSalDos').val(0);
			$('#cantSalCien').val(0);
			$('#cantSalCin').val(0);
			$('#cantSalVei').val(0);
			$('#cantSalMon').val(0);

			$('#sumTotalSal').val(0);
			$('#sumTotalEnt').val(0);
			$('#totalEntradas').val(0);
			$('#totalSalidas').val(0);
			$('#diferencia').val(0);

		}
		function validarFormaPago(){
			if ($('#entradaSalida').is(':visible')){
				if($('#pagoServicioDeposito').attr('checked') ==  true){

				}else{
					$('#formaPagoOpera1').attr('checked','checked');
					$('#pagoServicioRetiro').attr("checked",true);
				}

			}else if($('#numeroCuentaServicio').is(':visible')){
				$('#pagoServicioDeposito').attr('checked',true);
			}
		}
		function ocultaPagoCuotas(){
			$('#lblUltCuotaPagada').hide();
			$('#ultCuotaPagada').hide();
			$('#lblFechaUltCuotaPagada').hide();
			$('#fechaUltCuotaPagada').hide();
			$('#lblCuotasAtraso').hide();
			$('#cuotasAtraso').hide();
			$('#lblMontoNoCartVencida').hide();
			$('#montoNoCartVencida').hide();
		}

		function muestraPagoCuotas(){
			$('#lblUltCuotaPagada').show();
			$('#ultCuotaPagada').show();
			$('#lblFechaUltCuotaPagada').show();
			$('#fechaUltCuotaPagada').show();
			$('#lblCuotasAtraso').show();
			$('#cuotasAtraso').show();
			$('#lblMontoNoCartVencida').show();
			$('#montoNoCartVencida').show();
		}


		//Función solo Enteros sin Puntos ni Caracteres Especiales .....OM4R
		function validaSoloNumero(e,elemento){//Recibe al evento
			var key;
			if(window.event){//Internet Explorer ,Chromium,Chrome
				key = e.keyCode;
			}else if(e.which){//Firefox , Opera Netscape
					key = e.which;
			}

			 if (key > 31 && (key < 48 || key > 57)) //se valida, si son números los deja
			    return false;
			 return true;
		}



		/* funcion para revisar que todos los recursos de ventanilla fueron cargados correctamente */
		function revisarRecursosCargados(){
			var contador = 0;
			for (var i=0; i<arregloVentanilla.length; i++) {
				  if($('script[src="'+arregloVentanilla[i] +'"]').length > 0){

				  }else{
					  contador = contador + 1;
				  }
			}
			if(contador > 0){
				mensajeSis("La Pagina no cargo correctamente. Vuelva a Cargar la Pantalla");
			}
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
					'tasaBaseID' : tasaBase
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
		function muestraCamposTasa(calcInteresID){
			calcInteresID = Number(calcInteresID);
			$('#calcInteres').val(calcInteresID);
			// Si el calculo de interes es por tasaFija se ocultan campos de tasa variable
			if(calcInteresID <= TasaFijaID){
				VarTasaFijaoBase = 'Tasa Fija Anualizada';
				$('tr[name=tasaBase]').hide();
				$('#tasaBase').val('');
				$('#desTasaBase').val('');
				$('#tasaBaseValor').val('');
			} else if(calcInteresID != TasaFijaID){
				// Si es por tasa variable, se consulta y se muestra
				VarTasaFijaoBase = 'Tasa Base Actual';
				consultaTasaBase('tasaBase');
				$('tr[name=tasaBase]').show();
			}
			$('#lblTasaFija').text(VarTasaFijaoBase+': ');
		}

		/*funcion para limpiar caracteres especiales*/
		function limpiarCaracteresEsp(cadena){
			 // Definimos los caracteres que queremos eliminar
		   var specialChars = "!@$^%*()+=-[]\/{}|:<>?,.";
		   // Elimina caracteres especiales
		   for (var i = 0; i < specialChars.length; i++) {
		       cadena= cadena.replace(new RegExp("\\" + specialChars[i], 'gi'), '');
		   }

		   // Se cambia las letras por valores URL
		   cadena = cadena.replace(/&/gi,"%26");
		   cadena = cadena.replace(/#/gi,"%23");

		   return cadena;

		}

		function consultaCuotas(){
			var tipoConsulta = 10; //Consulta Cuotas AMORTICREDITO
			var creditoBeanCon = {
				'creditoID': $('#creditoIDPre').val()
			};
			amortizacionCreditoServicio.consulta(tipoConsulta,creditoBeanCon,{ async: false, callback:function(numCuotas){
				if(numCuotas != null){
					cuotasMaxProyectar = numCuotas.totalCuotas - numCuotas.cuotasPagadas;
					}
			}});
		}

		function ocultarBtnResumen(){
			$('#imprimirResumen').hide();
			deshabilitaBoton('imprimirResumen', 'submit');
		}