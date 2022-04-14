var usuarioAdministracion = 0;
var checListCte = '';
var fechaSucursal = '';
var sucursalSesion = 0;
var nombreSucursalSession = '';
var checkListInstrumento = 0;
var DigitalizacionInstrumento = 0;
var documentoCheck = 0;
var documentoDigitalizado = 0;
$(document).ready(function() {

	// Definicion de Constantes y Enums
	esTab = false;
	var parametroBean = consultaParametrosSession();
	var clavePuestoID = parametroBean.clavePuestoID;
	var numeroUsuario = parametroBean.numeroUsuario;
	$('#sucursalID').val(parametroBean.sucursal);

	deshabilitarCampos();
	consultarTiposIntrumentos();
	validaEmpresaID();
	fechaSucursal = parametroBean.fechaSucursal;
	sucursalSesion = parametroBean.sucursal;
	$('#fechaRegistro').val(parametroBean.fechaSucursal);
	$('#numeroExpedienteID').focus();
	consultaSucursal();
	var tipoMensaje = $('#tipoMensaje').val();
	validarUsuario(clavePuestoID, numeroUsuario);

	//Definicion de Constantes y Enums
	var catDocumentosGuardaValores = {
		'registro'	: '1',
	};

	var cat_Instrumentos= {
		'cliente'           : '1',
		'cuentaAho'         : '2',
		'cede'              : '3',
		'inversion'         : '4',
		'solicitudCredito'  : '5',
		'credito'           : '6',
		'prospecto'         : '7',
		'aportacion'        : '8'
	};

	var cat_ConCliente= {
		'cliente'           : '1',
		'cuentaAho'         : '2',
		'cede'              : '3',
		'inversion'         : '4',
		'solicitudCredito'  : '5',
		'credito'           : '6',
		'prospecto'         : '7',
		'aportacion'        : '8'
	};

	var val_Instrumento = {
		'cliente'           : 1,
		'cuentaAho'         : 2,
		'cede'              : 3,
		'inversion'         : 4,
		'solicitudCredito'  : 5,
		'credito'           : 6,
		'prospecto'         : 7,
		'aportacion'        : 8
	};


	var lista_Expediente = {
		'expediente' : 1
	};

	var consulta_Expediente = {
		'expediente' : 1
	};

	var consulta_Propiedades = {
		'checkList' 	 : 1,
		'digitalizacion' : 2,
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	deshabilitaControl('fechaRegistro');
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({
		submitHandler: function(event) {

			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true','numeroExpedienteID', 'funcionExito', 'funcionError');
		}
	});

	$('#grabar').click(function() {
		var validacion = verificarVacio();
		if( validacion == 0){
			$('#tipoTransaccion').val(catDocumentosGuardaValores.registro);
			removerAtributos();
		} else{
			mensajeSis("Faltan Datos por Capturar");
			event.preventDefault();
		}
	});

	$('#cancelar').click(function() {
		limpiarCampos();
		deshabilitarCampos();
	});

	//------------ Validaciones de la Forma -----------------------------------

	$('#fechaRegistro').change(function() {

		var fechaInicio= $('#fechaRegistro').val();
		if(esFechaValida(fechaInicio)){

			if(fechaInicio==''){
				$('#fechaRegistro').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaRegistro').val(parametroBean.fechaSucursal);
			$('#fechaRegistro').focus();
		}
		$('#fechaRegistro').focus();

	});

	$('#fechaRegistro').blur(function() {

		var fechaInicio= $('#fechaRegistro').val();
		if(esFechaValida(fechaInicio)){

			var fechaSistema = parametroBean.fechaSucursal;
			if ( mayor(fechaInicio, fechaSistema)){
				mensajeSis("La Fecha es mayor a la fecha del sistema.");
				$('#fechaRegistro').val(parametroBean.fechaSucursal);
				$('#fechaRegistro').focus();
			}
		}else{
			$('#fechaRegistro').val(parametroBean.fechaSucursal);
			$('#fechaRegistro').focus();
		}
	});


	$('#numeroExpedienteID').bind('keyup',function(e) {

		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "nombreParticipante";
		camposLista[1] = "sucursalID";
		camposLista[2] = "usuarioAutorizaID";

		parametrosLista[0] = $('#numeroExpedienteID').val();
		parametrosLista[1] = $('#sucursalID').val();
		parametrosLista[2] = usuarioAdministracion;


		lista('numeroExpedienteID', '1', lista_Expediente.expediente, camposLista, parametrosLista, 'listaExpedientesGrdValores.htm');
	});

	$('#numeroExpedienteID').blur(function(){
		var expediente = $('#numeroExpedienteID').val();
		if(esTab && expediente != ''){
			if( expediente == '0'){
				limpiarCampos();
				habilitarCampos();
				$('#sucursalID').val(parametroBean.sucursal);
				$('#fechaRegistro').val(parametroBean.fechaSucursal);
				$('#sucursalID').focus();
				habilitaBoton('cancelar','submit');
			} else {
				$('#registradosExpedienteGrid').html("");
				$('#registradosExpedienteGrid').hide();
				consultaExpediente(this.id);
			}
		}
	});

	$('#sucursalID').bind('keyup',function(e){
		lista('sucursalID', '2', '4', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});

	$('#sucursalID').blur(function(){
		if(esTab){
			$('#tipoInstrumento').val('0');
			$('#numeroInstrumento').val('');
			$('#nombreNumeroInstrumento').val('');
			$('#documentosRegistradosGrid').html("");
			$('#documentosRegistradosGrid').hide();
			consultaSucursal();
		}
	});

	$('#tipoInstrumento').change(function(){
		$('#numeroInstrumento').val('');
		$('#nombreNumeroInstrumento').val('');
		$('#documentosRegistradosGrid').hide();
		$('#documentosRegistradosGrid').html("");
		$('#registradosExpedienteGrid').hide();
		$('#registradosExpedienteGrid').html("");
	});


	$('#tipoInstrumento').blur(function() {
		validaIntrumento();
	});

	function consultaExpediente(idControl){

		jqDocumentoID 	  = eval("'#" + idControl+"'");
		numeroExpedienteID = $(jqDocumentoID).val();

		var expedienteBean = {
			'numeroExpedienteID' :numeroExpedienteID,
			'sucursalID' :$('#sucursalID').val(),
			'usuarioAutorizaID' :usuarioAdministracion
		};

		documentosGuardaValoresServicio.consultaExpediente(consulta_Expediente.expediente,expedienteBean,function(expediente) {
			if(expediente != null){
				$('#sucursalID').val(expediente.sucursalID);
				$('#tipoInstrumento').val(expediente.tipoInstrumento);
				$('#numeroInstrumento').val(expediente.numeroInstrumento);
				$('#fechaRegistro').val(expediente.fechaRegistro);
				consultaSucursal();
				deshabilitarCampos();
				consultarInstrumentoGrdValor(expediente.tipoInstrumento, expediente.numeroInstrumento);
				mostrarGrid(expediente.numeroExpedienteID, expediente.tipoInstrumento, expediente.numeroInstrumento, expediente.sucursalID);
			}else{
				var mensaje = "";
				mensaje = "El Número de Expediente consultado no Existe.";
				if(usuarioAdministracion == 0){
					mensaje = "El Número de Expediente consultado no Existe en la Sucursal "+ $("#nombreSucursal").val();
				}

				mensajeSis(mensaje);
				$('#numeroExpedienteID').focus();
			}
		});
	}

	function validaIntrumento(){

		var catInsGrdValoresID = $("#tipoInstrumento option:selected").val();
		var catInstrumentoBean = {
			'catInsGrdValoresID' :catInsGrdValoresID
		};

		catInstGuardaValoresServicio.consulta(2,catInstrumentoBean,function(catalogoBean) {
			if(catalogoBean != null){
				$('#manejaCheckList').val(catalogoBean.manejaCheckList);
				$('#manejaDigitalizacion').val(catalogoBean.manejaDigitalizacion);
			}else{
				mensajeSis("El instrumento no Existe o se Encuentra Inactivo");
			}
		});
	}

	$('#numeroInstrumento').bind('keyup',function(e){
		var tipoInstrumento = $("#tipoInstrumento option:selected").val();
		switch(tipoInstrumento){
			case cat_Instrumentos.cliente:
				lista('numeroInstrumento', '2', '1',  'nombreCompleto', $('#numeroInstrumento').val(), 'listaCliente.htm');
			break;
			case cat_Instrumentos.cuentaAho:
				lista('numeroInstrumento', '2', '21',  'clienteID',      $('#numeroInstrumento').val(), 'cuentasAhoListaVista.htm');
			break;
			case cat_Instrumentos.cede:
				lista('numeroInstrumento', '2', '13', 'nombreCliente',  $('#numeroInstrumento').val(), 'listaCedes.htm');
			break;
			case cat_Instrumentos.inversion:
				lista('numeroInstrumento', '2', '9',  'nombreCliente',  $('#numeroInstrumento').val(), 'listaInversiones.htm');
			break;
			case cat_Instrumentos.solicitudCredito:
				lista('numeroInstrumento', '2', '17',  'clienteID',      $('#numeroInstrumento').val(), 'listaSolicitudCredito.htm');
			break;
			case cat_Instrumentos.credito:
				lista('numeroInstrumento', '2', '56',  'creditoID',  $('#numeroInstrumento').val(), 'ListaCredito.htm');
			break;
			case cat_Instrumentos.prospecto:
				lista('numeroInstrumento', '2', '1',  'prospectoID',  $('#numeroInstrumento').val(), 'listaProspecto.htm');
			break;
			case cat_Instrumentos.aportacion:
				lista('numeroInstrumento', '2', '5',  'nombreCliente', $('#numeroInstrumento').val(), 'listaAportaciones.htm');
			break;
		}
	});

	$('#numeroInstrumento').blur(function(){
		setTimeout("$('#cajaLista').hide();", 200);
		var tipoInstrumento = $("#tipoInstrumento option:selected").val();
		var numeroInstrumento = $('#numeroInstrumento').val();
		if(esTab){
			consultarInstrumentoGrdValor(tipoInstrumento, numeroInstrumento);
			var numeroInstrumento = $('#numeroInstrumento').val();

			if(tipoInstrumento == val_Instrumento.cliente || tipoInstrumento == val_Instrumento.solicitudCredito ||
				tipoInstrumento == val_Instrumento.credito){
				consultaPropiedadesInstrumento(consulta_Propiedades.checkList, numeroInstrumento,  1, tipoInstrumento);
			}
			if(tipoInstrumento == val_Instrumento.cliente 	|| tipoInstrumento == val_Instrumento.solicitudCredito ||
				tipoInstrumento == val_Instrumento.credito	|| tipoInstrumento == val_Instrumento.cuentaAho){
				consultaPropiedadesInstrumento(consulta_Propiedades.digitalizacion, numeroInstrumento,  2, tipoInstrumento);
			}
			mensajeValidaInstrumento(tipoInstrumento);
		}
	});


		//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			sucursalID: {
				required: true
			},
			tipoInstrumento: {
				required: true
			},
			numeroInstrumento: {
				required: true
			},
			listaOrigenDocumento: {
				required: true
			},
			listaGrupoDocumentoID: {
				required: true
			},
			listaTipoDocumentoID: {
				required: true
			},
			listaNombreDocumento: {
				required: true
			}
		},
		messages: {
			sucursalID: {
				required: 'Especifique la Sucursal.'
			},
			tipoInstrumento: {
				required: 'Especifique el Tipo de Instrumento'
			},
			numeroInstrumento: {
				required: 'Especifique un Número de Instrumento'
			},
			listaOrigenDocumento: {
				required: 'Especifique un Origen'
			},
			listaGrupoDocumentoID: {
				required: 'Especifique Grupo de Documento'
			},
			listaTipoDocumentoID: {
				required: 'Especifique un Tipo de Documento'
			},
			listaNombreDocumento: {
				required: 'Especifique un Nombre'
			}
		}
	});

	function validarUsuario(clavePuestoID, numeroUsuario){

		var validaUsuario = 0;
		var puestoFacultadoBean = {
			'puestoFacultado' : clavePuestoID
		};
		var consultaPuestoFacultado = 1;

		paramGuardaValoresServicio.consultaFacultados(consultaPuestoFacultado,puestoFacultadoBean,{ async: false, callback:function(paramGuardaValores) {
			if(paramGuardaValores != null){
				if(paramGuardaValores.usrGuardaValoresID > 0){
					validaUsuario = validaUsuario +1;
				}
			}else{
				mensajeSis("Ha ocurrido un Error en la validación de Puestos Facultados");
			}
		}});

		var usuarioFacultadoBean = {
			'usuarioFacultadoID' : numeroUsuario
		};
		var consultaUsuarioFacultaos = 2;

		paramGuardaValoresServicio.consultaFacultados(consultaUsuarioFacultaos,usuarioFacultadoBean, { async: false, callback:function(paramGuardaValores) {
			if(paramGuardaValores != null){
				if(paramGuardaValores.usrGuardaValoresID > 0){
					validaUsuario = validaUsuario +1;
				}
			}else{
				mensajeSis("Ha ocurrido un Error en la validación de Usuarios Facultados");
			}
		}});

		var usuarioAdmonBean = {
			'paramGuardaValoresID' : 1,
			'usuarioAdmon': numeroUsuario
		};
		var numeroConsulta = 3;

		paramGuardaValoresServicio.consulta(numeroConsulta,usuarioAdmonBean,{ async: false, callback: function(paramGuardaValores) {
			if(paramGuardaValores != null){
				if(paramGuardaValores.paramGuardaValoresID > 0){
					validaUsuario = validaUsuario +1;
					usuarioAdministracion = 1;
				}
			}else{
				mensajeSis("Ha ocurrido un Error en la validación de Usuario Administracion.");
			}
		}});

		if(validaUsuario == 0){
			deshabilitaPantalla();
		}

	}

	//Consulta el Nombre de La Sucursal
	function consultaSucursal(){

		var principal = 1;
		var numSucursal = $("#sucursalID").val();
		var sucursalID =  $("#sucursalID").val();
		setTimeout("$('#cajaLista').hide();", 200);

		if(sucursalID != 0  && sucursalID != '' && !isNaN(sucursalID)){
			sucursalesServicio.consultaSucursal(principal,numSucursal,{ async: false, callback:function(sucursal) {
				if(sucursal!=null){
					$('#sucursalID').val(sucursal.sucursalID);
					nombreSucursalSession = sucursal.nombreSucurs;
					$('#nombreSucursal').val(sucursal.nombreSucurs);
				}else{
					mensajeSis("La Sucursal no Existe.");
					$('#nombreSucursal').val("");
					$('#sucursalID').focus();
				}
			}});
		} else {
			mensajeSis("La Sucursal no Existe.");
			$('#nombreSucursal').val("");
			$('#sucursalID').focus();
		}
	}

	function consultarInstrumentoGrdValor(tipoInstrumento, numeroInstrumento){

		if(numeroInstrumento != '0'  &&numeroInstrumento != '' && !isNaN(numeroInstrumento) ){
			switch(tipoInstrumento){
				case cat_Instrumentos.cliente:
					consultaCliente(numeroInstrumento , cat_ConCliente.cliente);
				break;
				case cat_Instrumentos.cuentaAho:
					consultaCtaAho(numeroInstrumento);
				break;
				case cat_Instrumentos.cede:
					consultaCede(numeroInstrumento);
				break;
				case cat_Instrumentos.inversion:
					consultaInversion(numeroInstrumento);
				break;
				case cat_Instrumentos.solicitudCredito:
					consultaSolicitudCredito(numeroInstrumento);
				break;
				case cat_Instrumentos.credito:
					consultaCredito(numeroInstrumento);
				break;
				case cat_Instrumentos.prospecto:
					consultaProspecto(numeroInstrumento, cat_ConCliente.prospecto);
				break;
				case cat_Instrumentos.aportacion:
					consultaAportacion(numeroInstrumento);
				break;
				default:
					$('#numeroInstrumento').val('');
					$('#nombreNumeroInstrumento').val('');
				break;
			}
		}else{
			mensajeSis("El Instrumento no Existe");
			$('#nombreNumeroInstrumento').val('');
			$('#numeroInstrumento').focus();
		}

	}
	// Consulta de Cliente
	function consultaCliente(numeroCliente, tipoConsulta) {
		numeroConsulta = 1;

		if(numeroCliente != '0' ){
			setTimeout("$('#cajaLista').hide();", 200);
			if(numeroCliente != '' && !isNaN(numeroCliente) ){
				clienteServicio.consulta(numeroConsulta, numeroCliente,"", { async: false, callback: function(cliente){
					if(cliente!=null){
						switch(tipoConsulta){
							case cat_ConCliente.cliente:
								$('#nombreNumeroInstrumento').val(cliente.nombreCompleto);
								ejecutaGrid();
							break;
							case cat_ConCliente.cuentaAho:
								$('#nombreNumeroInstrumento').val(cliente.nombreCompleto);
							break;
							case cat_ConCliente.cede:
								$('#nombreNumeroInstrumento').val(cliente.nombreCompleto);
							break;
							case cat_ConCliente.inversion:
								$('#nombreNumeroInstrumento').val(cliente.nombreCompleto);
							break;
							case cat_ConCliente.solicitudCredito:
								$('#nombreNumeroInstrumento').val(cliente.nombreCompleto);
							break;
							case cat_ConCliente.credito:
								$('#nombreNumeroInstrumento').val(cliente.nombreCompleto);
							break;
							case cat_ConCliente.prospecto:
								$('#nombreNumeroInstrumento').val(cliente.nombreCompleto);
							break;
							case cat_ConCliente.aportacion:
								$('#nombreNumeroInstrumento').val(cliente.nombreCompleto);
							break;
							default:
								$('#numeroInstrumento').val('');
								$('#nombreNumeroInstrumento').val('');
							break;
						}
					}else{
						mensajeSis("El "+tipoMensaje+" No Existe.");
						$('#numeroInstrumento').val('');
						$('#nombreNumeroInstrumento').val('');
						$('#numeroInstrumento').focus();
						$('#registradosExpedienteGrid').html("");
						$('#registradosExpedienteGrid').hide();
					}
				}});
			}
		}
	}

	// Consulta de Cuenta de Ahorro
	function consultaCtaAho(numeroCuenta) {
		var numeroConsulta = 1;
		var CuentaAhoBeanCon = {
			'cuentaAhoID' :numeroCuenta
		};

		if(numeroCuenta != '0' ){
			setTimeout("$('#cajaLista').hide();", 200);
			if(numeroCuenta != '' && !isNaN(numeroCuenta) ){

				cuentasAhoServicio.consultaCuentasAho(numeroConsulta, CuentaAhoBeanCon,function(cuenta) {

					if(cuenta != null){
						var cliente = cuenta.clienteID;
						if(cliente > 0){
							consultaCliente(cliente, cat_ConCliente.cuentaAho);
							ejecutaGrid();
						} else{
							mensajeSis("La Cuenta de Ahorro No está Asignada a un "+ tipoMensaje+".");
							$('#nombreNumeroInstrumento').val('');
							$('#numeroInstrumento').focus();
						}
					}else{
						mensajeSis("La Cuenta de Ahorro No Existe.");
						$('#numeroInstrumento').val('');
						$('#nombreNumeroInstrumento').val('');
						$('#numeroInstrumento').focus();
						$('#registradosExpedienteGrid').html("");
						$('#registradosExpedienteGrid').hide();
					}
				});
			}
		}
	}

	// Consulta de CEDE
	function consultaCede(numeroCede){
		var numeroConsulta = 1;
		var CedeBean = {
			'cedeID' :numeroCede
		};

		if(numeroCede != '0' ){
			setTimeout("$('#cajaLista').hide();", 200);
			if(numeroCede != '' && !isNaN(numeroCede) ){

				cedesServicio.consulta(numeroConsulta, CedeBean, { async: false, callback: function(cede){
					if(cede != null){
						var cliente = cede.clienteID;
						if(cliente > 0){
							consultaCliente(cliente, cat_ConCliente.cede);
							ejecutaGrid();
						} else{
							mensajeSis("La CEDE No está Asignada a un "+tipoMensaje+".");
							$('#nombreNumeroInstrumento').val('');
							$('#numeroInstrumento').focus();
						}
					}else{
						mensajeSis("La CEDE no Existe.");
						$('#numeroInstrumento').val('');
						$('#nombreNumeroInstrumento').val('');
						$('#numeroInstrumento').focus();
						$('#registradosExpedienteGrid').html("");
						$('#registradosExpedienteGrid').hide();
					}
				}});
			}
		}
	}

	// Consulta de Inversion
	function consultaInversion(numeroInversion){
		var numeroConsulta = 1;
		var InversionBean = {
			'inversionID' :numeroInversion
		};

		if(numeroInversion != '0' ){
			setTimeout("$('#cajaLista').hide();", 200);
			if(numeroInversion != '' && !isNaN(numeroInversion) ){

				inversionServicioScript.consulta(numeroConsulta, InversionBean, { async: false, callback: function(inversion){
					if(inversion != null){
						var cliente = inversion.clienteID;
						if(cliente > 0){
							consultaCliente(cliente, cat_ConCliente.inversion);
							ejecutaGrid();
						} else{
							mensajeSis("La Inversión No está Asignada a un "+tipoMensaje+".");
							$('#nombreNumeroInstrumento').val('');
							$('#numeroInstrumento').focus();
						}
					}else{
						mensajeSis("La Inversión no Existe.");
						$('#numeroInstrumento').val('');
						$('#nombreNumeroInstrumento').val('');
						$('#numeroInstrumento').focus();
						$('#registradosExpedienteGrid').html("");
						$('#registradosExpedienteGrid').hide();
					}
				}});
			}
		}
	}

	// Consulta de SolicitudCredito
	function consultaSolicitudCredito(numeroSolicitudCredito){
		var numeroConsulta = 1;
		var solicitudCreditoBeanCon = {
			'solicitudCreditoID' :numeroSolicitudCredito
		};

		if(numeroSolicitudCredito != '0' ){
			setTimeout("$('#cajaLista').hide();", 200);
			if(numeroSolicitudCredito != '' && !isNaN(numeroSolicitudCredito) ){

				solicitudCredServicio.consulta(numeroConsulta, solicitudCreditoBeanCon, { async: false, callback: function(solicitudCredito){

					if(solicitudCredito != null){
						$('#numeroInstrumento').val(solicitudCredito.solicitudCreditoID);
						$('#productoCreditoID').val(solicitudCredito.productoCreditoID);
						if(solicitudCredito.clienteID > 0 && solicitudCredito.prospectoID == 0) {
							consultaCliente(solicitudCredito.clienteID, cat_ConCliente.solicitudCredito);
						}
						if(solicitudCredito.clienteID == 0 && solicitudCredito.prospectoID > 0) {
							consultaProspecto(solicitudCredito.prospectoID, cat_ConCliente.solicitudCredito);
						}
						ejecutaGrid();
					}else{
						mensajeSis("La Solicitud de Crédito no Existe.");
						$('#numeroInstrumento').val('');
						$('#nombreNumeroInstrumento').val('');
						$('#numeroInstrumento').focus();
						$('#registradosExpedienteGrid').html("");
						$('#registradosExpedienteGrid').hide();
					}
				}});
			}
		}
	}

	// Consulta de Credito
	function consultaCredito(numeroCredito){
		var numeroConsulta = 1;
		var creditoBeanCon = {
			'creditoID' :numeroCredito
		};

		if(numeroCredito != '0' ){
			setTimeout("$('#cajaLista').hide();", 200);
			if(numeroCredito != '' && !isNaN(numeroCredito) ){
				creditosServicio.consulta(numeroConsulta, creditoBeanCon, { async: false, callback: function(creditoID){
					if(creditoID != null){
						$('#numeroInstrumento').val(creditoID.creditoID);
						var cliente = creditoID.clienteID;
						if(cliente > 0){
							consultaCliente(cliente, cat_ConCliente.credito);
							ejecutaGrid();
						} else{
							mensajeSis("El Crédito no está Asignado a un "+tipoMensaje+".");
							$('#nombreNumeroInstrumento').val('');
							$('#numeroInstrumento').focus();
						}
					}else{
						mensajeSis("El Crédito no Existe.");
						$('#numeroInstrumento').val('');
						$('#nombreNumeroInstrumento').val('');
						$('#numeroInstrumento').focus();
						$('#registradosExpedienteGrid').html("");
						$('#registradosExpedienteGrid').hide();
					}
				}});
			}
		}
	}

	// Consulta de Prospecto
	function consultaProspecto(numeroProspecto, tipoConsulta) {
		var prospectoBeanCon = {
			'prospectoID' : numeroProspecto
		};
		numeroConsulta = 1;

		if(numeroProspecto != '0' ){
			setTimeout("$('#cajaLista').hide();", 200);
			if(numeroProspecto != '' && !isNaN(numeroProspecto) ){
				prospectosServicio.consulta(7,prospectoBeanCon,function(prospectos) {
					if(prospectos!=null){
						switch(tipoConsulta){
							case cat_ConCliente.solicitudCredito:
								$('#nombreNumeroInstrumento').val(prospectos.nombreCompleto);
							break;
							case cat_ConCliente.prospecto:
								if(prospectos.cliente > 0 && prospectos.prospectoID == 0) {
									$('#numeroInstrumento').val(prospectos.cliente);
									consultaCliente(prospectos.cliente, cat_ConCliente.cliente);
									$('#tipoInstrumento').val(1);
									mensajeSis("El Prospecto Consultado es "+tipoMensaje+"");
									$('#numeroInstrumento').focus();
								}
								if(prospectos.cliente == 0 && prospectos.prospectoID > 0) {
									$('#numeroInstrumento').val(prospectos.prospectoID);
									$('#nombreNumeroInstrumento').val(prospectos.nombreCompleto);
									ejecutaGrid();
								}
								if(prospectos.cliente > 0 && prospectos.prospectoID > 0) {
									$('#numeroInstrumento').val(prospectos.cliente);
									consultaCliente(prospectos.cliente, cat_ConCliente.cliente);
									$('#tipoInstrumento').val(1);
									mensajeSis("El Prospecto Consultado es "+tipoMensaje+"");
									$('#numeroInstrumento').focus();
								}
							break;
							default:
								$('#numeroInstrumento').val('');
								$('#nombreNumeroInstrumento').val('');
							break;
						}
					}else{
						mensajeSis("El Prospecto no Existe");
						$('#nombreNumeroInstrumento').val('');
						$('#numeroInstrumento').focus();
						$('#registradosExpedienteGrid').html("");
						$('#registradosExpedienteGrid').hide();
					}
				});
			}
		}
	}

	// Consulta de Aportacion
	function consultaAportacion(numeroAportacion){
		var numeroConsulta = 1;
		var aportacionBean = {
			'aportacionID': numeroAportacion
		};

		if(numeroAportacion != '0' ){
			setTimeout("$('#cajaLista').hide();", 200);
			if(numeroAportacion != '' && !isNaN(numeroAportacion) ){
				aportacionesServicio.consulta(numeroConsulta, aportacionBean, { async: false, callback: function(aportacion){
					if(aportacion != null){
						$('#numeroInstrumento').val(aportacion.aportacionID);
						var cliente = aportacion.clienteID;
						if(cliente > 0){
							consultaCliente(cliente, cat_ConCliente.aportacion);
							ejecutaGrid();
						} else{
							mensajeSis("La Aportación no está Asignado a un "+tipoMensaje+".");
							$('#nombreNumeroInstrumento').val('');
							$('#numeroInstrumento').focus();
						}
					}else{
						mensajeSis("La Aportación no Existe.");
						$('#numeroInstrumento').val('');
						$('#nombreNumeroInstrumento').val('');
						$('#numeroInstrumento').focus();
						$('#registradosExpedienteGrid').html("");
						$('#registradosExpedienteGrid').hide();
					}
				}});
			}
		}
	}

	function mostrarGrid(numeroExpedienteID, tipoInstrumento, numeroInstrumento, sucursalID){

		var params = {
			'numeroExpedienteID' : numeroExpedienteID,
			'tipoLista' : 1,
			'tipoReporte' : 4,
			'tipoInstrumento' : tipoInstrumento,
			'numeroInstrumento': numeroInstrumento,
			'sucursalID' : sucursalID,
			'usuarioAutorizaID' : usuarioAdministracion,
			'nombreLista' : 'listaRegistro',
		};

		$('#documentosRegistradosGrid').show();
		$.post("listaExpedientesGridGrdValores.htm", params, function(data) {
			if (data.length > 0) {
				agregaFormatoControles('formaGenerica');
				$('#documentosRegistradosGrid').html(data);
				$('#documentosRegistradosGrid').show();
			} else {
				$('#documentosRegistradosGrid').html("");
				$('#documentosRegistradosGrid').hide();
			}
		});
	}

	// Ejecuta Grid
	function ejecutaGrid(){
		if($('#numeroExpedienteID').val() == 0){
			mostrarGridRegistro();
		}
	}

	//Consulta para ver si se requiere que el cliente requiere check list
	function validaEmpresaID() {
		var numEmpresaID = 1;
		var tipoCon = 1;
		var ParametrosSisBean = {
				'empresaID'	:numEmpresaID
		};

		parametrosSisServicio.consulta(tipoCon,ParametrosSisBean, { async: false, callback:function(parametrosSisBean) {
			if (parametrosSisBean != null) {
				checListCte = parametrosSisBean.checListCte;

			}
		}});
	}

	// Grid de Registro
	function mostrarGridRegistro(){
		$('#registradosExpedienteGrid').html("");
		$('#registradosExpedienteGrid').hide();

		var params = {};

		$('#registradosExpedienteGrid').show();
		$.post("registroExpedientesGridGrdValores.htm", params, function(data) {
			if (data.length > 0) {
				agregaFormatoControles('formaGenerica');
				$('#registradosExpedienteGrid').html(data);
				$('#registradosExpedienteGrid').show();
			} else {
				$('#registradosExpedienteGrid').html("");
				$('#registradosExpedienteGrid').hide();
			}
		});
	}



	// Valida Documentos de Check list y de Digitalizacion
	function consultaPropiedadesInstrumento(tipoConsulta, numeroInstrumento, origenDocumento, tipoInstrumento){

		var documentoBean = {
			'numeroInstrumento' :numeroInstrumento,
			'origenDocumento' : origenDocumento,
			'tipoInstrumento' :tipoInstrumento
		};

		documentosGuardaValoresServicio.consultaDocumento(5,documentoBean,{ async: false, callback:function(documentosBean) {
			if(documentosBean != null){
				// Consulta de check list 1.- Si no hay registro no se habilita
				if(tipoConsulta == 1){
					documentoCheck = documentosBean.tipoDocumentoID;
				}
				// Consulta de Digitalizacion e.- Si no hay registro no se habilita
				if(tipoConsulta == 2){
					documentoDigitalizado = documentosBean.tipoDocumentoID;
				}
			}else{
				mensajeSis("Ha ocurrido un error al consultar los Documentos de Check List o Digitalización");
				$('#numeroInstrumento').focus();
			}
		}});
	}

	// mensaje de combo
	function mensajeValidaInstrumento(tipoInstrumento){

		if( tipoInstrumento == val_Instrumento.cliente || tipoInstrumento == val_Instrumento.solicitudCredito ||
			tipoInstrumento == val_Instrumento.credito){

			if(documentoCheck == 0 && documentoDigitalizado == 0){
				mensajeSis("El Intrumento no tiene documentos de Check List y Digitalización o se encuentran bajo Custodia en Guarda Valores.");
			}

		}

		if( tipoInstrumento == val_Instrumento.cliente 	|| tipoInstrumento == val_Instrumento.solicitudCredito ||
			tipoInstrumento == val_Instrumento.credito	|| tipoInstrumento == val_Instrumento.cuentaAho){
			if(documentoCheck != 0 && documentoDigitalizado == 0){
				mensajeSis("El Intrumento no tiene documentos Digitalizados o se encuentran bajo Custodia en Guarda Valores.");
			}
			if(documentoDigitalizado == 0 && tipoInstrumento == val_Instrumento.cuentaAho){
				mensajeSis("El Intrumento no tiene documentos Digitalizados o se encuentran bajo Custodia en Guarda Valores.");
			}
		}

		if( tipoInstrumento == val_Instrumento.cliente 	|| tipoInstrumento == val_Instrumento.solicitudCredito ||
			tipoInstrumento == val_Instrumento.credito	){
			if(documentoCheck == 0 && documentoDigitalizado != 0){
				mensajeSis("El Intrumento no tiene documentos de Check list o se encuentran bajo Custodia en Guarda Valores.");
			}
		}
	}
});

var tabIndex = 7;


//Agregar nuevo esquema al grid
function agregaNuevoEsquema(){
	var numeroFila = consultaFilas();
	var nuevaFila = parseInt(numeroFila) + 1;
	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	if(numeroFila == 0){

		tabIndex = tabIndex + 1;
		tds += '<td><input type="text" id="listaDocumentoID'	  +nuevaFila+'" name="listaDocumentoID"  		path="listaDocumentoID" 		tabIndex="'+ tabIndex + '" size="10" value="'+nuevaFila+'" disabled="true" style="text-align: center;" /></td>';
		tabIndex = tabIndex + 1;
		tds += '<td><select id="listaOrigenDocumento' 			  +nuevaFila+'" style= "width:100%;" name="listaOrigenDocumento" 	path="listaOrigenDocumento" 	tabIndex="'+ tabIndex + '" onblur="consultaGrupoDatos(this.id)"></select></td>';
		tabIndex = tabIndex + 1;
		tds += '<td><select id="listaGrupoDocumentoID'			  +nuevaFila+'" style= "width:100%;" name="listaGrupoDocumentoID"	path="listaGrupoDocumentoID" 	tabIndex="'+ tabIndex + '" >';
		tds += '<option value="">SELECCIONAR</option></select></td>';
		tabIndex = tabIndex + 1;
		tds += '<td><input type="text" id="listaTipoDocumentoID'  +nuevaFila+'" name="listaTipoDocumentoID" 	path="listaTipoDocumentoID" 	tabIndex="'+ tabIndex + '" size="10" size="60" maxlength="100" autocomplete="off" onkeyPress="listaDocumentos(this.id)" onblur="validarDocumento(this.id)"/>';
		tabIndex = tabIndex + 1;
		tds += '<input  type="text" id="listaNombreDocumento'	  +nuevaFila+'" name="listaNombreDocumento" 	path="listaNombreDocumento" 	tabIndex="'+ tabIndex + '" size="50"  onBlur=" ponerMayusculas(this)"  maxlength = "100"  disabled="true" />';
		tds += '<select id="listaComboDigitaliza'				  +nuevaFila+'" style= "display:none; width:100%;" name="listaComboDigitaliza"		path="listaComboDigitaliza" 	tabIndex="'+ tabIndex + '" onblur="consultaComboDigital(this.id)">';
		tds += '<option value="">SELECCIONAR</option></select></td>';
		tabIndex = tabIndex + 1;
		tds += '<td><input type="text" id="listaEstatus'		  +nuevaFila+'" name="listaEstatus" 			path="listaEstatus" 			tabIndex="'+ tabIndex + '" value="EN CAPTURA" disabled="true" style="text-align: center;" /></td>';
	} else{

		tds += '<td><input type="text" id="listaDocumentoID'	  +nuevaFila+'" name="listaDocumentoID"  		path="listaDocumentoID" 		tabIndex="'+ tabIndex + '" size="10" value="'+nuevaFila+'" disabled="true" style="text-align: center;" /></td>';
		tabIndex = tabIndex + 1;
		tds += '<td><select id="listaOrigenDocumento' 			  +nuevaFila+'" style= "width:100%;" name="listaOrigenDocumento" 	path="listaOrigenDocumento" 	tabIndex="'+ tabIndex + '" onblur="consultaGrupoDatos(this.id)"></select></td>';
		tabIndex = tabIndex + 1;
		tds += '<td><select id="listaGrupoDocumentoID'			  +nuevaFila+'" style= "width:100%;" name="listaGrupoDocumentoID"	path="listaGrupoDocumentoID" 	tabIndex="'+ tabIndex + '" >';
		tds += '<option value="">SELECCIONAR</option></select></td>';
		tabIndex = tabIndex + 1;
		tds += '<td><input type="text" id="listaTipoDocumentoID'  +nuevaFila+'" name="listaTipoDocumentoID" 	path="listaTipoDocumentoID" 	tabIndex="'+ tabIndex + '" size="10" size="60" maxlength="100" autocomplete="off" onkeyPress="listaDocumentos(this.id)" onblur="validarDocumento(this.id)"/>';
		tabIndex = tabIndex + 1;
		tds += '<input  type="text" id="listaNombreDocumento'	  +nuevaFila+'" name="listaNombreDocumento" 	path="listaNombreDocumento" 	tabIndex="'+ tabIndex + '" size="50"  onBlur=" ponerMayusculas(this)"  maxlength = "100"  disabled="true" />';
		tds += '<select id="listaComboDigitaliza'				  +nuevaFila+'" style= "display:none; width:100%;" name="listaComboDigitaliza"		path="listaComboDigitaliza" 	tabIndex="'+ tabIndex + '" onblur="consultaComboDigital(this.id)">';
		tds += '<option value="">SELECCIONAR</option></select></td>';
		tabIndex = tabIndex + 1;
		tds += '<td><input type="text" id="listaEstatus'		  +nuevaFila+'" name="listaEstatus" 			path="listaEstatus" 			tabIndex="'+ tabIndex + '" value="EN CAPTURA" disabled="true" style="text-align: center;" /></td>';
	}
	tabIndex = tabIndex + 1;
	tds += '<td><input type="button" name="agregaElemento" id="agregaElemento'+nuevaFila+'" value="" tabIndex="'+ tabIndex + '" class="btnAgrega"  onclick="agregaNuevoEsquema()" />';
	tabIndex = tabIndex + 1;
	tds += '<input type="button" name="elimina" id="'+nuevaFila+'" 		  value="" tabIndex="'+ tabIndex + '" class="btnElimina" onclick="eliminarEsquema(this.id)" />';
	tds += '<input type="hidden" name="tipoDeshabilitado" id="tipoDeshabilitado'+nuevaFila+'" value="N" />';
	tds += '<input type="hidden" name="listaArchivoID" id="listaArchivoID'+nuevaFila+'" value="0" />';
	tds += '<input type="hidden" name="deshalitado" id="esDeshabilitado'+nuevaFila+'"	value="N"/></td>';
	tds += '</tr>';
	document.getElementById("numeroDetalle").value = nuevaFila;
	$("#miTabla").append(tds);
	agregaEsquema();
	consultarOrigenDatos(nuevaFila);
	return false;

}


//consulta cuantas filas tiene el grid de documentos
function consultaFilas(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
		totales++;
	});
	return totales;
}

function agregaEsquema(){
	var contador = 1 ;

	//Reordenamiento de Controles
	var numero= 0;
	$('tr[name=renglon]').each(function() {
		numero= this.id.substr(7,this.id.length);
		var jqRenglon 				= eval("'#renglon" + numero + "'");
		var jqlistaDocumentoID 		= eval("'#listaDocumentoID" + numero + "'");
		var jqlistaOrigenDocumento 	= eval("'#listaOrigenDocumento" + numero + "'");
		var jqlistaGrupoDocumentoID	= eval("'#listaGrupoDocumentoID" + numero + "'");
		var jqlistaTipoDocumentoID 	= eval("'#listaTipoDocumentoID" + numero + "'");
		var jqlistaNombreDocumento	= eval("'#listaNombreDocumento" + numero + "'");
		var jqlistaEstatus 			= eval("'#listaEstatus" + numero + "'");
		var jqAgrega 				= eval("'#agregaElemento" + numero + "'");
		var jqElimina 				= eval("'#" + numero + "'");

		$(jqRenglon).attr('id','renglon'+ contador);
		$(jqlistaDocumentoID).attr('id','listaDocumentoID'+contador);
		$(jqlistaOrigenDocumento).attr('id','listaOrigenDocumento'+contador);
		$(jqlistaGrupoDocumentoID).attr('id','listaGrupoDocumentoID'+contador);
		$(jqlistaTipoDocumentoID).attr('id','listaTipoDocumentoID'+contador);
		$(jqlistaNombreDocumento).attr('id','listaNombreDocumento'+contador);
		$(jqlistaEstatus).attr('id','listaEstatus'+contador);
		$(jqAgrega).attr('id','agregaElemento'+contador);
		$(jqElimina).attr('id',contador);

		contador = parseInt(contador + 1);
	});
}

function eliminarEsquema(control){
	var contador = 0 ;
	var numero = control;
	var jqRenglon 				= eval("'#renglon" + numero + "'");
	var jqlistaDocumentoID 		= eval("'#listaDocumentoID" + numero + "'");
	var jqlistaOrigenDocumento 	= eval("'#listaOrigenDocumento" + numero + "'");
	var jqlistaGrupoDocumentoID	= eval("'#listaGrupoDocumentoID" + numero + "'");
	var jqlistaTipoDocumentoID 	= eval("'#listaTipoDocumentoID" + numero + "'");
	var jqlistaNombreDocumento	= eval("'#listaNombreDocumento" + numero + "'");
	var jqlistaEstatus 			= eval("'#listaEstatus" + numero + "'");
	var jqAgrega 				= eval("'#agregaElemento" + numero + "'");
	var jqElimina 				= eval("'#" + numero + "'");

	// se elimina la fila seleccionada
	$(jqRenglon).remove();
	$(jqlistaDocumentoID).remove();
	$(jqlistaOrigenDocumento).remove();
	$(jqlistaGrupoDocumentoID).remove();
	$(jqlistaTipoDocumentoID).remove();
	$(jqlistaNombreDocumento).remove();
	$(jqlistaEstatus).remove();
	$(jqAgrega).remove();
	$(jqElimina).remove();

	//Reordenamiento de Controles
	contador = 1;
	numero= 0;
	$('tr[name=renglon]').each(function() {
		numero= this.id.substr(7,this.id.length);
		var jqRenglon1 					= eval("'#renglon" + numero + "'");
		var jqlistaDocumentoID1 		= eval("'#listaDocumentoID" + numero + "'");
		var jqlistaOrigenDocumento1 	= eval("'#listaOrigenDocumento" + numero + "'");
		var jqlistaGrupoDocumentoID1	= eval("'#listaGrupoDocumentoID" + numero + "'");
		var jqlistaTipoDocumentoID1 	= eval("'#listaTipoDocumentoID" + numero + "'");
		var jqlistaNombreDocumento1		= eval("'#listaNombreDocumento" + numero + "'");
		var jqlistaEstatus1				= eval("'#listaEstatus" + numero + "'");
		var jqAgrega1 					= eval("'#agregaElemento" + numero + "'");
		var jqElimina1 					= eval("'#" + numero + "'");

		$(jqRenglon1).attr('id','renglon'+ contador);
		$(jqlistaDocumentoID1).attr('id','listaDocumentoID'+contador);
		$(jqlistaOrigenDocumento1).attr('id','listaOrigenDocumento'+contador);
		$(jqlistaGrupoDocumentoID1).attr('id','listaGrupoDocumentoID'+contador);
		$(jqlistaTipoDocumentoID1).attr('id','listaTipoDocumentoID'+contador);
		$(jqlistaNombreDocumento1).attr('id','listaNombreDocumento'+contador);
		$(jqlistaEstatus1).attr('id','listaEstatus'+contador);
		$(jqAgrega1).attr('id','agregaElemento'+contador);
		$(jqElimina1).attr('id',contador);
		$(eval("'#" + 'listaDocumentoID' + contador + "'")).val(contador);
		contador = parseInt(contador + 1);
	});
}

function consultarTiposIntrumentos() {
	var tipoConsulta = 2;
	dwr.util.removeAllOptions('tipoInstrumento');
	dwr.util.addOptions('tipoInstrumento', {'0':'SELECCIONA'});
	catInstGuardaValoresServicio.listaCombo(tipoConsulta, function(intrumentos){
		dwr.util.addOptions('tipoInstrumento', intrumentos, 'catInsGrdValoresID', 'nombreInstrumento');
	});
}

// Origen de documentos
function consultarOrigenDatos(numero) {
	var tipoConsulta = 2;
	var cliente = 1;
	var cuenta = 2;
	var cede = 3;
	var inversion = 4;
	var solicitudCredito = 5;
	var credito = 6;
	var prospecto = 7;
	var aportacion = 8;


	var tipoInstrumentoID =  $("#tipoInstrumento option:selected").val();
	var manejaCheckList = $('#manejaCheckList').val();
	var manejaDigitalizacion = $('#manejaDigitalizacion').val();
	catOrigenesDocumentosServicio.listaCombo(tipoConsulta, { async: false, callback:function(intrumentos){
		dwr.util.addOptions("listaOrigenDocumento"+numero, intrumentos, 'catOrigenDocumentoID', 'nombreOrigen');
		// se elimina la opcion de check list del origen de documento
		if(manejaCheckList == 'N' || checListCte == 'N' && tipoInstrumentoID == cliente){
			$("#listaOrigenDocumento"+ numero).children('option[value="1"]').remove();
		}
		if(manejaCheckList == 'N' && tipoInstrumentoID == solicitudCredito){
			$("#listaOrigenDocumento"+ numero).children('option[value="1"]').remove();
		}
		if(manejaCheckList == 'N' && tipoInstrumentoID == credito){
			$("#listaOrigenDocumento"+ numero).children('option[value="1"]').remove();
		}
		if(manejaCheckList == 'N' && tipoInstrumentoID == cuenta ||
		   tipoInstrumentoID == cede || tipoInstrumentoID == inversion ||
		   tipoInstrumentoID == prospecto || tipoInstrumentoID == aportacion ){
			$("#listaOrigenDocumento"+ numero).children('option[value="1"]').remove();
		}

		if(manejaDigitalizacion == 'N'){
			$("#listaOrigenDocumento"+ numero).children('option[value="2"]').remove();
		}

		// Se eliminan las opciones por documento
		if(documentoCheck == 0 && documentoDigitalizado == 0){
			$("#listaOrigenDocumento"+ numero).children('option[value="1"]').remove();
			$("#listaOrigenDocumento"+ numero).children('option[value="2"]').remove();
		}

		if(documentoCheck != 0 && documentoDigitalizado == 0){
			$("#listaOrigenDocumento"+ numero).children('option[value="2"]').remove();
		}

		if(documentoCheck == 0 && documentoDigitalizado != 0){
			$("#listaOrigenDocumento"+ numero).children('option[value="1"]').remove();
		}
	}});
}

// Grupos de Documentos
function consultaGrupoDatos(idControl) {

	var numero= idControl.substr(20,idControl.length);
	var listaOrigenDocumento    = $(eval("'#" + 'listaOrigenDocumento' + numero + "'")).val();
	var jqlistaTipoDocumentoID  = eval("'#" + 'listaTipoDocumentoID'   + numero + "'");
	var jqlistaGrupoDocumentoID = eval("'#" + 'listaGrupoDocumentoID'  + numero + "'");
	var jqlistaNombreDocumento  = eval("'#" + 'listaNombreDocumento'   + numero + "'");
	var jqTipoDeshabilitado 	= eval("'#" + 'tipoDeshabilitado'      + numero + "'");
	var jqEsDeshabilitado 	    = eval("'#" + 'esDeshabilitado'        + numero + "'");

	var tipoInstrumentoID =  $("#tipoInstrumento option:selected").val();

	// Origen de Documento
	if(listaOrigenDocumento == 1){
		$(jqlistaTipoDocumentoID).val('');
		$(jqlistaNombreDocumento).val('');
		mostrarComboDigitalizacion(1, numero);
		habilitaControl('listaGrupoDocumentoID'+numero);
		habilitaControl('listaTipoDocumentoID'+numero);
		// Seccion de Grupo de Documentos
		switch(tipoInstrumentoID){
			case "1":
				$(jqlistaGrupoDocumentoID).focus();
				consultaDocumentosCliente(numero);
			break;
			case "5":
				consultaDocumentosSolicitudCredito(numero);
			break;
			case "6":
				consultaDocumentosCredito(numero);
			break;
			case "2":
			case "3":
			case "4":
			case "7":
			case "8":
				dwr.util.removeAllOptions('listaGrupoDocumentoID'+numero);
				dwr.util.addOptions('listaGrupoDocumentoID'+numero, {'0':'NO APLICA'});
				$(jqEsDeshabilitado).val("S");
			break;
		}
	}

	// Documento de digitalizacón
	if(listaOrigenDocumento == 2){
		comboDigitalizacion(numero);
		mostrarComboDigitalizacion(2, numero);
		$(jqlistaTipoDocumentoID).focus();
		deshabilitaControl('listaGrupoDocumentoID'+numero);
		habilitaControl('listaTipoDocumentoID'+numero);
		dwr.util.removeAllOptions('listaGrupoDocumentoID'+numero);
		dwr.util.addOptions('listaGrupoDocumentoID'+numero, {'0':'NO APLICA'});
		$(jqEsDeshabilitado).val("S");
		$(jqTipoDeshabilitado).val("D");
	}

	// No Aplica
	if(listaOrigenDocumento == 3){
		mostrarComboDigitalizacion(1, numero);
		habilitaControl('listaNombreDocumento'+numero);
		$(jqlistaTipoDocumentoID).val(0);
		$(jqlistaNombreDocumento).val('');
		$(jqlistaNombreDocumento).focus();
		deshabilitaControl('listaGrupoDocumentoID'+numero);
		deshabilitaControl('listaTipoDocumentoID'+numero);
		dwr.util.removeAllOptions('listaGrupoDocumentoID'+numero);
		dwr.util.addOptions('listaGrupoDocumentoID'+numero, {'0':'NO APLICA'});
		$(jqEsDeshabilitado).val("S");
		$(jqTipoDeshabilitado).val("NA");
	}

}

//LLenar combo digitalizacion
function comboDigitalizacion(numero) {

	$('#listaTipoDocumentoID' + numero).hide();
	$('#listaNombreDocumento' + numero).hide();
	$('#listaComboDigitaliza'+numero).show();

	var tipoLista = 4;
	var numeroInstrumento =  parseInt($('#numeroInstrumento').val()) ;
	var tipoInstrumento	  =  $("#tipoInstrumento option:selected").val();
	var origenDocumento   = $(eval("'#" + 'listaOrigenDocumento' + numero + "'")).val();

	var documentoBean = {
		'numeroInstrumento' :numeroInstrumento,
		'origenDocumento' : origenDocumento,
		'tipoInstrumento' :tipoInstrumento
	};

	dwr.util.removeAllOptions('listaComboDigitaliza'+numero);
	dwr.util.addOptions( 'listaComboDigitaliza'+numero, {'0':'SELECCIONAR'});
	documentosGuardaValoresServicio.listaCombo(tipoLista, documentoBean,  function(tiposDocumentos){
		dwr.util.addOptions('listaComboDigitaliza'+numero, tiposDocumentos, 'tipoDocumentoID', 'descripcion');
	});
}

//LLenar combo digitalizacion
function consultaComboDigital(idControl) {
	var numero = idControl.substr(20);
	var cadena = $('#'+idControl).val();
	var posicion = cadena.indexOf("-");
	var tipoDocumentoID = cadena.substr(0,posicion);
	var archivoID = cadena.substring(posicion+1, cadena.length);
	$("#listaTipoDocumentoID"+ numero).val(tipoDocumentoID);
	$("#listaArchivoID"+ numero).val(archivoID);
	validarDocumento("listaTipoDocumentoID"+ numero);
}


// Check list de  cliente
function consultaDocumentosCliente(numero) {
	var tipoLista = 1;
	var numeroCliente =  parseInt($('#numeroInstrumento').val()) ;
	var instrumento = 4;

	dwr.util.removeAllOptions('listaGrupoDocumentoID'+numero);
	dwr.util.addOptions( 'listaGrupoDocumentoID'+numero, {'0':'SELECCIONAR'});
	grupoDocumentosServicio.listaCombo(numeroCliente, instrumento, tipoLista,  function(grupoDocumento){
		dwr.util.addOptions('listaGrupoDocumentoID'+numero, grupoDocumento, 'grupoDocumentoID', 'descripcion');
	});
}

// Check list de solicitud de Credito
function consultaDocumentosSolicitudCredito(numero) {
	var tipoLista = 2;
	var numeroSolicitudCredito =  parseInt($('#numeroInstrumento').val()) ;

	var params = {
		'solicitudCreditoID' : numeroSolicitudCredito
	};

	dwr.util.removeAllOptions('listaGrupoDocumentoID'+numero);
	dwr.util.addOptions( 'listaGrupoDocumentoID'+numero, {'0':'SELECCIONAR'});
	solicitudCheckListServicio.listaCombo(tipoLista, params, function(grupoDocumento){
		dwr.util.addOptions('listaGrupoDocumentoID'+numero, grupoDocumento, 'clasificaTipDocID', 'descripcion');
	});
}

// Check list de Credito
function consultaDocumentosCredito(numero) {
	var tipoLista = 2;
	var numeroSolicitudCredito =  parseInt($('#numeroInstrumento').val()) ;

	var params = {
		'creditoID' : numeroSolicitudCredito
	};

	dwr.util.removeAllOptions('listaGrupoDocumentoID'+numero);
	dwr.util.addOptions( 'listaGrupoDocumentoID'+numero, {'0':'SELECCIONAR'});
	creditoDocEntServicio.listaCombo(tipoLista, params, function(grupoDocumento){
		dwr.util.addOptions('listaGrupoDocumentoID'+numero, grupoDocumento, 'clasificaTipDocID', 'descripcion');
	});
}


// Lista de documentos
function listaDocumentos(idControl){

	var numero= idControl.substr(20,idControl.length);

	var jq = eval("'#" + idControl + "'");
	$(jq).bind('keyup',function(e){

		var jqControl = eval("'#" + this.id + "'");
		var numeroDocumento = $(jqControl).val();
		var var_origenDocumento = $(eval("'#" + 'listaOrigenDocumento' + numero + "'")).val();
		var var_grupoDocumentoID = $(eval("'#" + 'listaGrupoDocumentoID' + numero + "'")).val();

		if(var_origenDocumento == 1){

			var camposLista = new Array();
			var parametrosLista = new Array();
			var tipoInstrumentoID =  $("#tipoInstrumento option:selected").val();

			camposLista[0] = "origenDocumento";
			camposLista[1] = "tipoInstrumento";
			camposLista[2] = "numeroInstrumento";
			camposLista[3] = "nombreDocumento";
			camposLista[4] = "grupoDocumentoID";
			camposLista[5] = "campoArchivoID";
			parametrosLista[0] = 1;
			parametrosLista[1] = tipoInstrumentoID;
			parametrosLista[2] = $('#numeroInstrumento').val();
			parametrosLista[3] = $(jq).val();
			parametrosLista[4] = var_grupoDocumentoID;
			parametrosLista[5] = 'listaArchivoID'+numero;
			switch(tipoInstrumentoID){
				case "1":
					lista(idControl, '2', '4', camposLista, parametrosLista, 'listaDocumentosGrdValores.htm');
				break;
				case "5":
					lista(idControl, '2', '4', camposLista, parametrosLista, 'listaDocumentosGrdValores.htm');
				break;
				case "6":
					camposLista[0] = "clasificaTipDocID";
					camposLista[1] = "descripcion";
					camposLista[2] = "creditoID";
					parametrosLista[0] = $(eval("'#" + 'listaGrupoDocumentoID' + numero + "'")).val();
					parametrosLista[1] = numeroDocumento;
					parametrosLista[2] =  $('#numeroInstrumento').val();
					lista(idControl, '2', '3', camposLista, parametrosLista, 'listaDocumentosCreditoVista.htm');
				break;
			}
		}

		if(var_origenDocumento == 2){

			var camposLista = new Array();
			var parametrosLista = new Array();
			var tipoInstrumentoID =  $("#tipoInstrumento option:selected").val();

			camposLista[0] = "origenDocumento";
			camposLista[1] = "tipoInstrumento";
			camposLista[2] = "numeroInstrumento";
			camposLista[3] = "nombreDocumento";
			camposLista[4] = "grupoDocumentoID";
			camposLista[5] = "campoArchivoID";
			parametrosLista[0] = 2;
			parametrosLista[1] = tipoInstrumentoID;
			parametrosLista[2] = $('#numeroInstrumento').val();
			parametrosLista[3] = $(jq).val();
			parametrosLista[4] = var_grupoDocumentoID;
			parametrosLista[5] = 'listaArchivoID'+numero;

			switch(tipoInstrumentoID){
				case "1":
				case "2":
				case "5":
				case "6":
					lista(idControl, '2', '4', camposLista, parametrosLista, 'listaDocumentosGrdValores.htm');
				break;
				case "3":
				case "4":
				case "7":
				case "8":
					lista(idControl, '2', '3', 'descripcion', $(jqControl).val(), 'ListaTiposDocumentos.htm');
				break;
			}

		}

	});
}

// Consulta de documentos
function validarDocumento(control) {
	var evalDocumento = eval("'#" + control + "'");
	var numeroDocumento = $(evalDocumento).val();
	var nombreDocumento = eval("'#listaNombreDocumento" + control.substr(20) + "'");
	var tipoInstrumentoID =  $("#tipoInstrumento option:selected").val();
	setTimeout("$('#cajaLista').hide();", 200);

	if(numeroDocumento != '' && esTab && !isNaN(numeroDocumento)){
		if(tipoInstrumentoID == 1 || tipoInstrumentoID == 2 ||
		   tipoInstrumentoID == 5 || tipoInstrumentoID == 6 ){
			var documentoBean = {
				'numeroInstrumento' : $('#numeroInstrumento').val(),
				'origenDocumento'   : $(eval("'#" + 'listaOrigenDocumento' + control.substr(20) + "'")).val(),
				'tipoDocumentoID'   : numeroDocumento,
				'tipoInstrumento'   : $("#tipoInstrumento option:selected").val(),
				'grupoDocumentoID'  : $(eval("'#" + 'listaGrupoDocumentoID' + control.substr(20) + "'")).val(),
				'archivoID'			: $(eval("'#" + 'listaArchivoID' + control.substr(20) + "'")).val(),
			};

			documentosGuardaValoresServicio.consultaDocumento(4,documentoBean,function(tipoDocumento) {
				if(tipoDocumento != null){
					$(nombreDocumento).val(tipoDocumento.descripcion);
				} else {
					mensajeSis("No Existe el Documento.");
					$(nombreDocumento).val('');
					$(evalDocumento).focus();
				}
			});
		}

		if(tipoInstrumentoID == 3 || tipoInstrumentoID == 4 ||
		   tipoInstrumentoID == 8 || tipoInstrumentoID == 7 ){
			var documentoBean = {
				'tipoDocumentoID':numeroDocumento
			};

			tiposDocumentosServicio.consulta(3,documentoBean,function(tipoDocumento) {
				if(tipoDocumento != null){
					$(nombreDocumento).val(tipoDocumento.descripcion);
				} else {
					mensajeSis("No Existe el Documento.");
					$(nombreDocumento).val('');
					$(evalDocumento).focus();
				}
			});
		}

	} else{
		$(evalDocumento).val('');
	}
}

function funcionError(){
	agregaAtributos();
}

function funcionExito(){
	var jQmensaje = eval("'#ligaCerrar'");
	if($(jQmensaje).length > 0) {
		mensajeAlert=setInterval(function() {
			if($(jQmensaje).is(':hidden')) {
				clearInterval(mensajeAlert);
				$('#fechaRegistro').val(fechaSucursal);
				$('#sucursalID').val(sucursalSesion);
				$('#nombreSucursal').val(nombreSucursalSession);
				limpiarCampos();
				$('#tipoInstrumento').val(0);
				deshabilitaControl('tipoInstrumento');
				deshabilitaBoton('grabar','submit');
			}
		}, 50);
	}
}

function deshabilitaPantalla(){
	mensajeSis("Estimado Usuario no Cuenta con los Permisos Necesarios para el Módulo Guarda Valores.");
	$('#numeroExpedienteID').val('');
	$('#fechaRegistro').val('');
	$('#sucursalID').val('');
	$('#nombreSucursal').val('');
	$('#tipoInstrumento').val('');
	$('#numeroInstrumento').val('');
	$('#nombreNumeroInstrumento').val('');
	$("#productoCreditoID").val();
	$('#documentosRegistradosGrid').html("");
	$('#documentosRegistradosGrid').hide();
	$('#registradosExpedienteGrid').html("");
	$('#registradosExpedienteGrid').hide();
	deshabilitaControl('numeroExpedienteID');
	deshabilitaBoton('grabar', 'submit');
	deshabilitarCampos();
}

function limpiarCampos(){
	$("#tipoTransaccion").val('');
	$("#productoCreditoID").val('');
	$('#tipoInstrumento').val('');
	$('#numeroInstrumento').val('');
	$('#nombreNumeroInstrumento').val('');
	$('#documentosRegistradosGrid').html("");
	$('#documentosRegistradosGrid').hide();
	$('#registradosExpedienteGrid').html("");
	$('#registradosExpedienteGrid').hide();
	habilitaBoton('grabar', 'submit');
}

function habilitarCampos(){
	habilitaControl('sucursalID');
	habilitaControl('numeroInstrumento');
	habilitaControl('tipoInstrumento');
	habilitaBoton('grabar', 'submit');
}

function deshabilitarCampos(){
	deshabilitaControl('sucursalID');
	deshabilitaControl('numeroInstrumento');
	deshabilitaControl('tipoInstrumento');
	deshabilitaBoton('grabar','submit');
	deshabilitaBoton('cancelar','submit');
}

function removerAtributos(){

	//realizamos el recorrido solo por las celdas que contienen el código, que es la primera
	var numero ;
	$('tr[name=renglon]').each(function() {
		numero= this.id.substr(7,this.id.length);

		var listaOrigenDocumento  = eval("'#listaOrigenDocumento"  + numero + "'");
		var listaGrupoDocumentoID = eval("'#listaGrupoDocumentoID" + numero + "'");
		var listaTipoDocumentoID  = eval("'#listaTipoDocumentoID"  + numero + "'");
		var listaNombreDocumento  = eval("'#listaNombreDocumento"  + numero + "'");

		$(listaOrigenDocumento).removeAttr('disabled');
		$(listaGrupoDocumentoID).removeAttr('disabled');
		$(listaTipoDocumentoID).removeAttr('disabled');
		$(listaNombreDocumento).removeAttr('disabled');
	});
}

function agregaAtributos(){

	//realizamos el recorrido solo por las celdas que contienen el código, que es la primera
	var listaTipoDocumentoID  = eval("'#listaTipoDocumentoID"  + numero + "'");
	var numero = 0;
	$('tr[name=renglon]').each(function() {
		numero= this.id.substr(7,this.id.length);
		var jqTipoDeshabilitado 	= eval("'#" + 'tipoDeshabilitado'      + numero + "'");
		var jqEsDeshabilitado 	    = eval("'#" + 'esDeshabilitado'        + numero + "'");

		var tipoDeshabilitado = $(jqTipoDeshabilitado).val();
		var esDeshabilitado 	= $(jqEsDeshabilitado).val();

		if(esDeshabilitado == 'S' ){
			deshabilitaControl('listaGrupoDocumentoID'+numero);
			if(tipoDeshabilitado == 'D' ){
				deshabilitaControl('listaNombreDocumento'+numero);
			}
			if(tipoDeshabilitado == 'NA' ){
				deshabilitaControl('listaTipoDocumentoID'+numero);
				$(listaTipoDocumentoID).val("0");
			}
		}
	});
}

function verificarVacio(){
	var validacion = 0;
	// quitaFormatoControles('gridSolicitudCheckList');
	var numeroItereciones = $('input[name=listaTipoDocumentoID]').length;
	if(numeroItereciones == 0){
		validacion = 1;
		return validacion;
	}

	for(var iteracion = 1; iteracion <= numeroItereciones; iteracion++){

		var listaOrigenDocumento  = document.getElementById("listaOrigenDocumento"+iteracion+"").value;
		var listaGrupoDocumentoID = document.getElementById("listaGrupoDocumentoID"+iteracion+"").value;
		var listaTipoDocumentoID  = document.getElementById("listaTipoDocumentoID"+iteracion+"").value;
		var listaNombreDocumento  = document.getElementById("listaNombreDocumento"+iteracion+"").value;

		if(listaOrigenDocumento == ""){
			document.getElementById("listaOrigenDocumento"+iteracion+"").focus();
			$(listaOrigenDocumento).addClass("error");
			validacion = 1;
			return validacion;
		}

		if(listaGrupoDocumentoID == ""){
			document.getElementById("listaGrupoDocumentoID"+iteracion+"").focus();
			$(listaGrupoDocumentoID).addClass("error");
			validacion = 1;
			return validacion;
		}

		if(listaTipoDocumentoID == ""){
			document.getElementById("listaTipoDocumentoID"+iteracion+"").focus();
			$(listaTipoDocumentoID).addClass("error");
			validacion = 1;
			return validacion;
		}

		if(listaNombreDocumento == ""){
			document.getElementById("listaNombreDocumento"+iteracion+"").focus();
			$(listaNombreDocumento).addClass("error");
			validacion = 1;
			return validacion;
		}
	}
	return validacion;
}

function mostrarComboDigitalizacion(opcion, numeroControl){
	var mostrarCombo = 1;
	var ocultarCombo = 2;

	if(opcion == mostrarCombo){
		$('#listaTipoDocumentoID' + numeroControl).show();
		$('#listaNombreDocumento' + numeroControl).show();
		$('#listaComboDigitaliza' + numeroControl).hide();
	}

	if(opcion == ocultarCombo){
		$('#listaTipoDocumentoID' + numeroControl).hide();
		$('#listaNombreDocumento' + numeroControl).hide();
		$('#listaComboDigitaliza' + numeroControl).show();
	}
}