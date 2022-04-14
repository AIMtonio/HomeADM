var checListCte = '';
var usuarioAdministracion = 0;
var usuarioComboRegistro = 0;
var tipoOperacionVentana = 0;
var var_origenDocumento = 0;
var documentoDigitalizado = 0;
$(document).ready(function() {

	// Definicion de Constantes y Enums
	$('#catMovimientoID').focus();
	esTab = false;
	var parametroBean = consultaParametrosSession();
	var clavePuestoID = parametroBean.clavePuestoID;
	var numeroUsuario = parametroBean.numeroUsuario;
	validarUsuario(clavePuestoID, numeroUsuario);
	$('#sucursalID').val(parametroBean.sucursal);
	consultarTiposIntrumentos();
	consultarTiposMovimientos();
	deshabilitaBoton('grabar','submit');
	deshabilitaBoton('cancelar','submit');
	$('#movimientos').hide();
	var tipoMensaje = $('#tipoMensaje').val();
	//Definicion de Constantes y Enums

	var cat_TransaccionesDocumentos = {
		'prestamoDocumento'	   : '3',
		'devolucionDocumento'  : '4',
		'sustitucionDocumento' : '5',
		'bajaDocumento'		   : '6'
	};

	var con_TipoMovimiento = {
		'prestamoDocumento'	   : '1',
		'devolucionDocumento'  : '2',
		'sustitucionDocumento' : '3',
		'bajaDocumento'		   : '4'
	};

	var con_Documentos = {
		'principal'		: 1,
		'movDocumento'	: 3
	};

	var con_TipoDocumento = {
		'tipoDocumento' :3
	};

	var con_Cliente = {
		'principal' : 1
	};

	var con_Prestamo = {
		'principal' : 1
	};

	var con_Prospecto = {
		'foranea' : 7
	};

	var con_Usuarios = {
		'principal' : 1
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


	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

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
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true','catMovimientoID', 'funcionExito', 'funcionError');
		}
	});

	$('#grabar').click(function() {
		var var_CatMovimientoID = $("#catMovimientoID option:selected").val();
		tipoOperacionVentana = var_CatMovimientoID;
		switch(var_CatMovimientoID){
			case con_TipoMovimiento.prestamoDocumento:
				$('#tipoTransaccion').val(cat_TransaccionesDocumentos.prestamoDocumento);
			break;
			case con_TipoMovimiento.devolucionDocumento:
				$('#tipoTransaccion').val(cat_TransaccionesDocumentos.devolucionDocumento);
			break;
			case con_TipoMovimiento.sustitucionDocumento:
				$('#tipoTransaccion').val(cat_TransaccionesDocumentos.sustitucionDocumento);
			break;
			case con_TipoMovimiento.bajaDocumento:
				$('#tipoTransaccion').val(cat_TransaccionesDocumentos.bajaDocumento);
			break;
			default:
				$('#tipoTransaccion').val(0);
			break;
		}
	});

	$('#cancelar').click(function() {
		ocultarCampos(4);
		limpiarFormulario();
		limpiarCamposConsulta();
		$('#catMovimientoID').focus();
	});

	//------------ Validaciones de la Forma -----------------------------------
	$('#catMovimientoID').blur(function(){
		var operacion = $("#catMovimientoID option:selected").val();
		mostrarCampos(operacion);
		limpiarFormulario();
		$('#tipoInstrumento').val('0');
		$('#documentoID').val('');
	});

	$('#documentoID').bind('keyup',function(e){

		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "nombreParticipante";
		camposLista[1] = "tipoInstrumento";
		camposLista[2] = "catMovimientoID";
		camposLista[3] = "sucursalID";

		parametrosLista[0] = $('#documentoID').val();
		parametrosLista[1] = $("#tipoInstrumento option:selected").val();
		parametrosLista[2] = $("#catMovimientoID option:selected").val();
		parametrosLista[3] = $("#sucursalID").val();

		lista('documentoID', '2', '3', camposLista, parametrosLista, 'listaDocumentosGrdValores.htm');
	});

	$('#documentoID').blur(function(){
		validacionDocumentoGuardaValores(this.id);
	});

	$('#usuarioPrestamoID').bind('keyup',function(e){
		lista('usuarioPrestamoID', '2', '1', 'nombreCompleto', $('#usuarioPrestamoID').val(), 'listaUsuarios.htm');
	});

	$('#usuarioPrestamoID').blur(function() {
		validaUsuario(this.id);
	});

	$('#observaciones').blur(function(){
		limpiarCaracterEscape(this.id, 500);
	});


	$('#docSustitucionID').bind('keyup',function(e){
		if(var_origenDocumento == 1){

			var camposLista = new Array();
			var parametrosLista = new Array();
			var tipoInstrumentoID =  $("#tipoInstrumento option:selected").val();

			switch(tipoInstrumentoID){
				case "1":
					camposLista[0] = "grupoDocumentoID";
					camposLista[1] = "descripcion";
					parametrosLista[0] = $('#grupoDocumentoID').val();
					parametrosLista[1] = $("#docSustitucionID").val();
					lista('docSustitucionID', '2', '1', camposLista, parametrosLista, 'doctosPorGrupoListaVista.htm');
				break;
				case "5":
					camposLista[0] = "clasificaTipDocID";
					camposLista[1] = "productoCreditoID";
					camposLista[2] = "descripcion";
					parametrosLista[0] = $('#grupoDocumentoID').val();
					parametrosLista[1] = $("#productoCreditoID").val();
					parametrosLista[2] = $('#docSustitucionID').val();
					lista('docSustitucionID', '2', '4', camposLista, parametrosLista, 'solicitudCreditoListaVista.htm');
				break;
				case "6":
					camposLista[0] = "clasificaTipDocID";
					camposLista[1] = "creditoID";
					camposLista[2] = "descripcion";
					parametrosLista[0] = $('#grupoDocumentoID').val();
					parametrosLista[1] = $('#numeroInstrumento').val();
					parametrosLista[2] = $('#docSustitucionID').val();
					lista('docSustitucionID', '2', '3', camposLista, parametrosLista, 'listaDocumentosCreditoVista.htm');
				break;
			}
		}
		if(var_origenDocumento == 2){
			lista('docSustitucionID', '2', '3', 'descripcion', $('#docSustitucionID').val(), 'ListaTiposDocumentos.htm');
		}

	});

	$('#docSustitucionID').blur(function() {
		validarDocumento(this.id);
	});


	function listaDocumentos(idControl){
		var jq = eval("'#" + idControl + "'");
		$(jq).bind('keyup',function(e){
			var jqControl = eval("'#" + this.id + "'");
			var num = $(jqControl).val();

			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "descripcion";
			parametrosLista[0] = num;
			listaAlfanumerica(idControl, '2', '3',camposLista, parametrosLista,'ListaTiposDocumentos.htm');
		});
	}
		//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			documentoID: {
				required: true,
			},
			observaciones: {
				required :function() {
					if($("#tipoTransaccion").val() == '4' ) return false; else return true;}
			},
			usuarioPrestamoID: {
				required :function() {
					if($("#tipoTransaccion").val() == '3' ) return true; else return false;}
			},
			claveUsuario: {
				required :function() {
					if($("#tipoTransaccion").val() == '4' ) return false; else return true;}
			},
			contrasenia: {
				required :function() {
					if($("#tipoTransaccion").val() == '4' ) return false; else return true;}
			}
		},
		messages: {
			documentoID: {
				required: 'Especificar el Documento'
			},
			observaciones: {
				required: 'Especificar una Motivo'
			},
			usuarioPrestamoID: {
				required: 'Especificar el Usuario de Préstamo'
			},
			claveUsuario: {
				required: 'Ingresar el Usuario de Autorización'
			},
			contrasenia: {
				required: 'Ingresar la Contraseña'
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
				mensajeSis("Ha ocurrido un Error en la validación de Usuario Administración.");
			}
		}});

		if(validaUsuario == 0){
			deshabilitaPantalla();
		}

	}
	// Consulta de Documento
	function validacionDocumentoGuardaValores(idControl) {
		var jqDocumento = eval("'#" + idControl + "'");
		var numeroDocumento = $(jqDocumento).val();
		setTimeout("$('#cajaLista').hide();", 200);

		var	documentoBean = {
			'documentoID' : numeroDocumento,
			'tipoInstrumento' : $("#tipoInstrumento option:selected").val(),
			'catMovimientoID' : $("#catMovimientoID option:selected").val(),
			'sucursalID' : $("#sucursalID").val()
		};

		if (numeroDocumento != '' && !isNaN(numeroDocumento) && esTab) {
			documentosGuardaValoresServicio.consultaDocumento(1, documentoBean, function(documento) {
				if (documento != null) {
					if(documento.estatus == 'B'){
						mensajeSis("El documento consultado está en un estatus de Baja y no se pueden realizar operaciones.");
						$('#documentoID').focus();
						return false;
					}
					if(documento.estatus == 'R'){
						mensajeSis("El documento consultado está en un estatus de Registro y no se pueden realizar operaciones.");
						$('#documentoID').focus();
						return false;
					}

					consultaDocumento(idControl);
				} else {
					mensajeSis("El documento consultado no Existe");
					$('#documentoID').focus();
					limpiarFormulario();

				}
			});
		}
	}

	// Consulta de Documento
	function consultaDocumento(idControl) {
		var jqDocumento = eval("'#" + idControl + "'");
		var numeroDocumento = $(jqDocumento).val();
		var var_catMovimientoID = $("#catMovimientoID option:selected").val();
		setTimeout("$('#cajaLista').hide();", 200);

		var	documentoBean = {
			'documentoID' : numeroDocumento,
			'tipoInstrumento' : $("#tipoInstrumento option:selected").val(),
			'catMovimientoID' : $("#catMovimientoID option:selected").val(),
			'sucursalID' : $("#sucursalID").val()
		};

		if (numeroDocumento != '' && !isNaN(numeroDocumento) && esTab) {
			documentosGuardaValoresServicio.consultaDocumento(con_Documentos.movDocumento, documentoBean, function(documento) {
				if (documento != null) {
					$('#usuarioPrestamoID').val('');
					$('#nombreUsuarioPrestamoID').val('');
					$('#docSustitucionID').val('');
					$('#nombreDocSustitucion').val('');

					$('#fechaRegistro').val(documento.fechaRegistro);
					$('#participanteID').val(documento.participanteID);
					$('#numeroInstrumento').val(documento.numeroInstrumento);
					$('#origenDocumento').val(documento.origenDocumento);

					$('#tipoDocumentoID').val(documento.grupoDocumentoID);
					$('#nombreDocumento').val(documento.nombreDocumento);
					$('#estatus').val(documento.estatus);
					$('#sucursalID').val(documento.sucursalID);
					$('#fechaMovimiento').val(parametroBean.fechaSucursal);
					consultarInstrumentoGrdValor(documento.tipoPersona, documento.participanteID);
					habilitarCampos();
					switch(var_catMovimientoID){
						case con_TipoMovimiento.prestamoDocumento:
							habilitaControl('usuarioPrestamoID');
							$('#usuarioPrestamoID').focus();
						break;
						case con_TipoMovimiento.devolucionDocumento:
							$('#observaciones').focus();
							deshabilitaControl('usuarioPrestamoID');
							deshabilitaControl('claveUsuario');
							deshabilitaControl('contrasenia');
							consultaDevolucionDocumento(documento.prestamoDocGrdValoresID);
						break;
						case con_TipoMovimiento.sustitucionDocumento:
							consultaTipoDocumento(numeroDocumento);
							if(documento.tipoInstrumento == 5){
								consultaSolicitudCredito(documento.numeroInstrumento);
							}
						break;
						case con_TipoMovimiento.bajaDocumento:
							$('#observaciones').focus();
						break;
					}

				} else {
					switch(var_catMovimientoID){
						case con_TipoMovimiento.prestamoDocumento:
							mensajeSis("El Documento Consultado está en un Estatus Diferente de Custodia.");
						break;
						case con_TipoMovimiento.devolucionDocumento:
							mensajeSis("El Documento Consultado está en un Estatus Diferente de Préstamo.");
						break;
						case con_TipoMovimiento.sustitucionDocumento:
							mensajeSis("El Documento Consultado está en un Estatus Diferente de Custodia.");
						break;
						case con_TipoMovimiento.bajaDocumento:
							mensajeSis("El Documento Consultado está en un Estatus Diferente de Custodia.");
						break;
						default:
							mensajeSis("El Documento Consultado está en un Estatus Diferente del Tipo de Movimiento.");
						break;
					}
					$('#documentoID').focus();
					limpiarFormulario();
				}
			});
		}
	}

	function consultaTipoDocumento(numeroDocumento){
		if(numeroDocumento != '0' ){
			setTimeout("$('#cajaLista').hide();", 200);

			var documentoBean = {
				'documentoID' : numeroDocumento
			};

			if(numeroDocumento != '' && !isNaN(numeroDocumento) ){
				documentosGuardaValoresServicio.consultaDocumento(con_Documentos.principal,documentoBean,function(documentos) {
					if(documentos!=null){
						$('#origenDocumentoID').val(documentos.origenDocumento);
						$('#grupoDocumentoID').val(documentos.grupoDocumentoID);
						var_origenDocumento = documentos.origenDocumento;
						if(var_origenDocumento == 3 || var_origenDocumento == 1) {
							if(var_origenDocumento == 3){
								deshabilitaControl('docSustitucionID');
								habilitaControl('nombreDocSustitucion');
								mostrarCampos('3');
								$('#docSustitucionID').val('0');
								$('#nombreDocSustitucion').focus();
							}  else {
								$('#comboSustitucion').hide();
								$('#listaComboDigitaliza').hide();
								$('#docSustitucionID').show();
								$('#nombreDocSustitucion').show();
								mostrarCampos('3');
								deshabilitaControl('nombreDocSustitucion');
								habilitaControl('docSustitucionID');
								$('#docSustitucionID').focus();
							}
						} else {
							mostrarCamposDigitalizacion();
							consultaPropiedadesInstrumento();
							$('#listaComboDigitaliza').focus();
						}

					}else{
						mensajeSis("Ha ocurrido un Error al Consultar el Documento");
					}
				});
			}
		}

	}

	function consultaDevolucionDocumento(prestamoDocGrdValoresID){
		if(prestamoDocGrdValoresID != '0' ){
			setTimeout("$('#cajaLista').hide();", 200);

			var documentoBean = {
				'prestamoDocGrdValoresID' : prestamoDocGrdValoresID
			};

			if(prestamoDocGrdValoresID != '' && !isNaN(prestamoDocGrdValoresID) ){
				documentosGuardaValoresServicio.consultaPrestamoDocumento(con_Prestamo.principal,documentoBean,function(documentos) {
					if(documentos!=null){
						$('#usuarioPrestamoID').val(documentos.usuarioPrestamoID);
						$('#prestamoDocGrdValoresID').val(documentos.prestamoDocGrdValoresID);
						validaUsuarioPrestamo('usuarioPrestamoID');
					}else{
						mensajeSis("El Número de Préstamo no Existe o está en un estatus diferente de Vigente");
						$('#prestamoDocGrdValoresID').val('');
						$('#prestamoDocGrdValoresID').focus();
					}
				});
			}
		}
	}

	function validaUsuarioPrestamo(control) {

		var jqUsuarioID = eval("'#" + control + "'");
		var numUsuario = $(jqUsuarioID).val();
		setTimeout("$('#cajaLista').hide();", 200);

		var usuarioBeanCon = {
			'usuarioID':numUsuario
		};

		if(numUsuario != '' && !isNaN(numUsuario) && numUsuario >0 ){
			usuarioServicio.consulta(con_Usuarios.principal,usuarioBeanCon,function(usuario) {
				if(usuario!=null){
					switch(usuario.estatus){
						case "A":
							$('#usuarioPrestamoID').val(usuario.usuarioID);
							$('#nombreUsuarioPrestamoID').val(usuario.nombreCompleto);
						break;
						case "B":
							mensajeSis('El Usuario Consultado está Bloqueado');
							$('#nombreUsuarioPrestamoID').val('');
							$('#usuarioPrestamoID').focus();
						break;
						case "C":
							mensajeSis('El Usuario Consultado está Cancelado o en Baja');
							$('#nombreUsuarioPrestamoID').val('');
							$('#usuarioPrestamoID').focus();
							break;
						default:
							$('#usuarioPrestamoID').val('');
							$('#nombreUsuarioPrestamoID').val('');
						break;
					}
				} else {
					mensajeSis("No Existe el Usuario.");
					$('#nombreUsuarioPrestamoID').val('');
					$('#usuarioPrestamoID').focus();
				}
			});
		}
	}

	function consultarInstrumentoGrdValor(tipoPersona, numeroParticipante){
		if(numeroParticipante != '0'  &&numeroParticipante != '' && !isNaN(numeroParticipante) ){
			switch(tipoPersona){
				case 'C':
					consultaCliente(numeroParticipante);
				break;
				case 'P':
					consultaProspecto(numeroParticipante);
				break;
				default:
					$('#nombreParticipante').val('');
				break;
			}
		}else{
			mensajeSis("El "+ tipoMensaje +" o Prospecto no Existe");
			$('#participanteID').val('');
			$('#numeroInstrumento').focus();
		}
	}

	// Consulta de Cliente
	function consultaCliente(numeroCliente) {
		if(numeroCliente != '0' ){
			setTimeout("$('#cajaLista').hide();", 200);
			if(numeroCliente != '' && !isNaN(numeroCliente) ){
				clienteServicio.consulta(con_Cliente.principal, numeroCliente,"", { async: false, callback: function(cliente){
					if(cliente!=null){
						var nombreCliente = cliente.nombreCompleto;
						nombreCliente = nombreCliente.toUpperCase();
						$('#nombreParticipante').val(nombreCliente);
					}else{
						mensajeSis("El "+tipoMensaje+" No Existe.");
						$('#nombreParticipante').val('');
						$('#participanteID').focus();
					}
				}});
			}
		}
	}

	// Consulta de Prospecto
	function consultaProspecto(numeroProspecto) {
		var prospectoBeanCon = {
			'prospectoID' : numeroProspecto
		};
		numeroConsulta = 1;

		if(numeroProspecto != '0' ){
			setTimeout("$('#cajaLista').hide();", 200);
			if(numeroProspecto != '' && !isNaN(numeroProspecto) ){
				prospectosServicio.consulta(con_Prospecto.foranea,prospectoBeanCon,function(prospectos) {
					if(prospectos!=null){
						var nombreProspecto = prospectos.nombreCompleto;
						nombreProspecto = nombreProspecto.toUpperCase();
						$('#nombreParticipante').val(nombreProspecto);
					}else{
						mensajeSis("El Prospecto no Existe");
						$('#nombreParticipante').val('');
						$('#participanteID').focus();
					}
				});
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
						$('#productoCreditoID').val(solicitudCredito.productoCreditoID);
					}else{
						mensajeSis("La Solicitud de Crédito no Existe.");
						$('#numeroInstrumento').focus();
					}
				}});
			}
		}
	}

	function validaUsuario(control) {

		var jqUsuarioID = eval("'#" + control + "'");
		var numUsuario = $(jqUsuarioID).val();
		setTimeout("$('#cajaLista').hide();", 200);

		var usuarioBeanCon = {
			'usuarioID':numUsuario
		};

		if(numUsuario != '' && !isNaN(numUsuario) && numUsuario >0 && esTab){
			usuarioServicio.consulta(con_Usuarios.principal,usuarioBeanCon,function(usuario) {
				if(usuario!=null){
					switch(usuario.estatus){
						case "A":
							$('#usuarioPrestamoID').val(usuario.usuarioID);
							$('#nombreUsuarioPrestamoID').val(usuario.nombreCompleto);
						break;
						case "B":
							mensajeSis('El Usuario Consultado está Bloqueado');
							$('#nombreUsuarioPrestamoID').val('');
							$('#usuarioPrestamoID').focus();
						break;
						case "C":
							mensajeSis('El Usuario Consultado está Cancelado o en Baja');
							$('#nombreUsuarioPrestamoID').val('');
							$('#usuarioPrestamoID').focus();
							break;
						default:
							$('#usuarioPrestamoID').val('');
							$('#nombreUsuarioPrestamoID').val('');
						break;
					}
				} else {
					mensajeSis("No Existe el Usuario.");
					$('#nombreUsuarioPrestamoID').val('');
					$('#usuarioPrestamoID').focus();
				}
			});
		}
	}

	function validarDocumento(control) {

		var jqDocumentoID = eval("'#" + control + "'");
		var numeroDocumento = $(jqDocumentoID).val();
		setTimeout("$('#cajaLista').hide();", 200);

		var documentoBean = {
			'tipoDocumentoID':numeroDocumento
		};

		if(numeroDocumento != '' && !isNaN(numeroDocumento) && numeroDocumento >0  && esTab){

			tiposDocumentosServicio.consulta(con_TipoDocumento.tipoDocumento,documentoBean,function(tipoDocumento) {
				if(tipoDocumento != null){
					$('#nombreDocSustitucion').val(tipoDocumento.descripcion);
				} else {
					mensajeSis("No Existe el Documento.");
					$('#nombreDocSustitucion').val('');
					$('#docSustitucionID').focus();
				}
			});
		}
	}

	function mostrarCampos(operacion){
		switch(operacion){
			case '0':
				ocultarCampos(0);
			break;
			case '1':
				ocultarCampos(3);
				$('#movimientos').show();
				$('#labelSeparador').show();
				$('#lblSeccionPrestamo2').show();
				$('#lblSeccionPrestamo').show();
				$('#usuarioPrestamoID').show();
				$('#nombreUsuarioPrestamoID').show();
			break;
			case '2':
				ocultarCampos(2);
				$('#movimientos').show();
				$('#labelSeparador').show();
				$('#lblSeccionPrestamo').show();
				$('#lblSeccionPrestamo2').show();
				$('#usuarioPrestamoID').show();
				$('#nombreUsuarioPrestamoID').show();
				deshabilitaControl('claveUsuario');
				deshabilitaControl('contrasenia');
			break;
			case '3':
				ocultarCampos(1);
				$('#movimientos').show();
				$('#labelSeparador').show();
				$('#lblTipoDocumentoSusticionID').show();
				$('#lblTipoDocumentoSusticionID2').show();
				$('#docSustitucionID').show();
				$('#nombreDocSustitucion').show();
			break;
			case '4':
				ocultarCampos(4);
				$('#movimientos').show();
			break;
		}
	}

	function ocultarCampos(operacion){
		$('#movimientos').hide();
		switch(operacion){
			case 0:
				$('#movimientos').hide();
				$('#labelSeparador').hide();
				$('#lblTipoDocumentoSusticionID').hide();
				$('#lblTipoDocumentoSusticionID2').hide();
				$('#docSustitucionID').hide();
				$('#nombreDocSustitucion').hide();
				$('#lblSeccionPrestamo').hide();
				$('#lblSeccionPrestamo2').hide();
				$('#usuarioPrestamoID').hide();
				$('#listaComboDigitaliza').hide();
				$('#nombreUsuarioPrestamoID').hide();
			break;
			case 1:
				$('#lblSeccionPrestamo').hide();
				$('#lblSeccionPrestamo2').hide();
				$('#usuarioPrestamoID').hide();
				$('#nombreUsuarioPrestamoID').hide();
				$('#listaComboDigitaliza').hide();
			break;
			case 2:
				$('#lblSeccionPrestamo').hide();
				$('#lblSeccionPrestamo2').hide();
				$('#usuarioPrestamoID').hide();
				$('#nombreUsuarioPrestamoID').hide();
				$('#lblTipoDocumentoSusticionID').hide();
				$('#lblTipoDocumentoSusticionID2').hide();
				$('#docSustitucionID').hide();
				$('#nombreDocSustitucion').hide();
				$('#listaComboDigitaliza').hide();
			break;
			case 3:
				$('#lblTipoDocumentoSusticionID').hide();
				$('#lblTipoDocumentoSusticionID2').hide();
				$('#docSustitucionID').hide();
				$('#nombreDocSustitucion').hide();
				$('#listaComboDigitaliza').hide();
			break;
			case 4:
				$('#labelSeparador').hide();
				$('#lblTipoDocumentoSusticionID').hide();
				$('#lblTipoDocumentoSusticionID2').hide();
				$('#docSustitucionID').hide();
				$('#nombreDocSustitucion').hide();
				$('#lblSeccionPrestamo').hide();
				$('#lblSeccionPrestamo2').hide();
				$('#usuarioPrestamoID').hide();
				$('#nombreUsuarioPrestamoID').hide();
				$('#listaComboDigitaliza').hide();
				$('#comboSustitucion').hide();
			break;
		}
	}

	function mostrarCamposDigitalizacion(){

		habilitaControl('listaComboDigitaliza');
		var origenDocumentoID = $('#origenDocumentoID').val();
		if(origenDocumentoID == 2){
			$('#nombreDocSustitucion').hide();
			$('#docSustitucionID').hide();
			$('#lblTipoDocumentoSusticionID2').hide();
			$('#listaComboDigitaliza').show();
			$('#comboSustitucion').show();
			comboDigitalizacion();
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

	//LLenar combo digitalizacion
	function comboDigitalizacion() {

		var tipoLista = 4;
		var numeroInstrumento = parseInt($('#numeroInstrumento').val()) ;
		var tipoInstrumento	  = $("#tipoInstrumento option:selected").val();
		var origenDocumento   = $('#origenDocumentoID').val();

		var documentoBean = {
			'numeroInstrumento' :numeroInstrumento,
			'origenDocumento' : origenDocumento,
			'tipoInstrumento' :tipoInstrumento
		};

		dwr.util.removeAllOptions('listaComboDigitaliza');
		dwr.util.addOptions( 'listaComboDigitaliza', {'0':'SELECCIONAR'});
		documentosGuardaValoresServicio.listaCombo(tipoLista, documentoBean,  function(tiposDocumentos){
			dwr.util.addOptions('listaComboDigitaliza', tiposDocumentos, 'tipoDocumentoID', 'descripcion');
		});
	}
	// Valida Documentos de Check list y de Digitalizacion
	function consultaPropiedadesInstrumento(){

		var numeroInstrumento = parseInt($('#numeroInstrumento').val()) ;
		var tipoInstrumento	  = $("#tipoInstrumento option:selected").val();
		var origenDocumento   = $('#origenDocumentoID').val();

		var documentoBean = {
			'numeroInstrumento' :numeroInstrumento,
			'origenDocumento' : origenDocumento,
			'tipoInstrumento' :tipoInstrumento
		};

		documentosGuardaValoresServicio.consultaDocumento(5,documentoBean,{ async: false, callback:function(documentosBean) {
			if(documentosBean != null){
				documentoDigitalizado = documentosBean.tipoDocumentoID;
				mensajeValidaInstrumento(tipoInstrumento);
			}else{
				mensajeSis("Ha ocurrido un error al consultar los Documentos de Check List o Digitalización");
				$('#numeroInstrumento').focus();
			}
		}});
	}

	// mensaje de combo
	function mensajeValidaInstrumento(tipoInstrumento){
		if( tipoInstrumento == val_Instrumento.cliente 	|| tipoInstrumento == val_Instrumento.solicitudCredito ||
			tipoInstrumento == val_Instrumento.credito	|| tipoInstrumento == val_Instrumento.cuentaAho){
			if(documentoDigitalizado == 0){
				mensajeSis("El Intrumento no tiene documentos Digitalizados para realizar la operación de sustitución.");
				deshabilitaControl('listaComboDigitaliza');
				deshabilitarCampos();
				$('#documentoID').focus();
			}
		}
	}

});

function habilitarCampos(){
	habilitaControl('observaciones');
	habilitaControl('claveUsuario');
	habilitaControl('contrasenia');
	habilitaControl('docSustitucionID');
	habilitaBoton('grabar','submit');
	habilitaBoton('cancelar','submit');
}

function deshabilitarCampos(){
	deshabilitaControl('observaciones');
	deshabilitaControl('usuarioPrestamoID');
	deshabilitaControl('claveUsuario');
	deshabilitaControl('contrasenia');
	deshabilitaControl('docSustitucionID');
	deshabilitaBoton('grabar','submit');
	deshabilitaBoton('cancelar','submit');
}

function limpiarFormulario(){
	$('#fechaRegistro').val('');
	$('#participanteID').val('');
	$('#nombreParticipante').val('');
	$('#numeroInstrumento').val('');
	$('#origenDocumento').val('');

	$('#tipoDocumentoID').val('');
	$('#nombreDocumento').val('');
	$('#estatus').val('');
	$('#observaciones').val('');
	$('#usuarioPrestamoID').val('');

	$('#claveUsuario').val('');
	$('#contrasenia').val('');
	$('#fechaMovimiento').val('');
	$('#tipoTransaccion').val('');
	$('#nombreUsuarioPrestamoID').val('');
	$('#docSustitucionID');
	deshabilitaControl('nombreDocSustitucion');
	$('#docSustitucionID').val('');
	$('#nombreDocSustitucion').val('');
	$('#prestamoDocGrdValoresID').val('');
	$('#archivoID').val('');
	deshabilitarCampos();
	$('#listaComboDigitaliza').hide();
}

function limpiarCamposConsulta(){
	$('#catMovimientoID').val('0');
	$('#tipoInstrumento').val('0');
	$('#documentoID').val('');
}

function funcionError(){
	$('#tipoTransaccion').focus();
	$("#catMovimientoID").val(tipoOperacionVentana);
}

function funcionExito(){
	limpiarFormulario();
	limpiarCamposConsulta();
	$('#catMovimientoID').focus();
	var_origenDocumento = 0;
	tipoOperacionVentana = 0;
}

function consultarTiposIntrumentos() {
	var tipoConsulta = 2;
	dwr.util.removeAllOptions('tipoInstrumento');
	dwr.util.addOptions( 'tipoInstrumento', {'0':'SELECCIONAR'});
	catInstGuardaValoresServicio.listaCombo(tipoConsulta, function(intrumentos){
		dwr.util.addOptions('tipoInstrumento', intrumentos, 'catInsGrdValoresID', 'nombreInstrumento');
	});
}

function consultarTiposMovimientos() {
	var tipoConsulta = 2;
	dwr.util.removeAllOptions('catMovimientoID');
	dwr.util.addOptions( 'catMovimientoID', {'0':'SELECCIONAR'});
	catalogoMovGuardaValoresServicio.listaCombo(tipoConsulta, function(tipoMovimiento){
		dwr.util.addOptions('catMovimientoID', tipoMovimiento, 'catMovimientoID', 'nombreMovimiento');
	});
}

function deshabilitaPantalla(){
	mensajeSis("Estimado Usuario no Cuenta con los Permisos Necesarios para el Módulo Guarda Valores.");
	deshabilitaControl('tipoInstrumento');
	deshabilitaControl('catMovimientoID');
	deshabilitaControl('documentoID');
	limpiarFormulario();
	limpiarCamposConsulta();
}

//LLenar combo digitalizacion
function consultaComboDigital(idControl) {
	var cadena = $('#'+idControl).val();
	var posicion = cadena.indexOf("-");
	var tipoDocumentoID = cadena.substr(0,posicion);
	var archivoID = cadena.substring(posicion+1, cadena.length);
	$("#docSustitucionID").val(tipoDocumentoID);
	$("#archivoID").val(archivoID);
}