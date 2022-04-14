var usuarioAdministracion = 0;
var var_nombreSucursal = "";
$(document).ready(function() {

	// Definicion de Constantes y Enums
	$('#tipoInstrumento').focus();
	esTab = false;
	var parametroBean = consultaParametrosSession();
	var clavePuestoID = parametroBean.clavePuestoID;
	var numeroUsuario = parametroBean.numeroUsuario;
	var var_nombreSucursal = parametroBean.nombreSucursal;
	validarUsuario(clavePuestoID, numeroUsuario);
	limpiarBotones();
	consultarTiposIntrumentos();

	$('#sucursalID').val(parametroBean.sucursal);

	var tipoMensaje = $('#tipoMensaje').val();
	var con_Cliente = {
		'principal' : 1
	};

	var con_Prospecto = {
		'foranea' : 7
	};

	var lista_Grid = {
		'expediente' : 3
	};

	var lista_Expediente = {
		'expediente' : 2
	};


	var lista_Instrumento ={
		'foranea': 2
	};

	var catalogoInstrumentosGrid = {
		'cliente'			: 2,
		'cuenta'			: 3,
		'cede'				: 4,
		'inversion'			: 5,
		'solicitudCredito'	: 6,
		'credito'			: 7,
		'prospecto'			: 8,
		'aportacion'		: 9
	};

	var catalogoInstrumentos = {
		'cliente'			: '1',
		'cuenta'			: '2',
		'cede'				: '3',
		'inversion'			: '4',
		'solicitudCredito'	: '5',
		'credito'			: '6',
		'prospecto'			: '7',
		'aportacion'		: '8'
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

	$('#tipoInstrumento').blur(function() {
		$('#numeroExpedienteID').val('');
		$('#nombreParticipante').val('');
		$('#numeroExpedienteID').focus();
		limpiarDocumentos();
	});

	$('#numeroExpedienteID').bind('keyup',function(e){

		var camposLista = new Array();
		var parametrosLista = new Array();
		var numeroInstrumento = $('#tipoInstrumento').val();
		camposLista[0] = "nombreParticipante";
		camposLista[1] = "sucursalID";
		camposLista[2] = "usuarioAutorizaID";
		camposLista[3] = "campoTipoPersona";
		camposLista[4] = "tipoInstrumento";


		parametrosLista[0] = $('#numeroExpedienteID').val();
		parametrosLista[1] = $('#sucursalID').val();
		parametrosLista[2] = usuarioAdministracion;
		parametrosLista[3] = "tipoPersona";
		parametrosLista[4] = numeroInstrumento;

		lista('numeroExpedienteID', '2', lista_Expediente.expediente, camposLista, parametrosLista, 'listaExpedientesGrdValores.htm');
	});

	$('#numeroExpedienteID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if(esTab){
			limpiarDocumentos();
			validaExpediente(this.id);
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
	function validaExpediente(idControl) {
		var jqDocumento = eval("'#" + idControl + "'");
		var participanteID = $(jqDocumento).val();
		setTimeout("$('#cajaLista').hide();", 200);

		var validaDocumentos = 3;
		var mensaje  = "";
		var sucursalID = $('#sucursalID').val();
		var tipoInstrumento = $('#tipoInstrumento').val();


		var expedienteBean = {
			'tipoInstrumento' : tipoInstrumento,
			'numeroInstrumento' : participanteID,
			'sucursalID' : sucursalID
		};

		if (participanteID != '' && !isNaN(participanteID) && esTab) {

			documentosGuardaValoresServicio.consultaExpediente(validaDocumentos, expedienteBean, function(expediente) {
				if (expediente != null) {
					if(expediente.numeroExpedienteID == 0){
						switch(tipoInstrumento){
							case 1:
								mensaje = "El "+tipoMensaje+" consultado No tiene Documentos Registrados en Guarda Valores";
							break;
							case '7':
								mensaje = "El Prospecto consultado No tiene Documentos Registrados en Guarda Valores";
							break;
							default:
								mensaje ="El "+ tipoMensaje + " o Prospecto no tiene documentos en Guarda Valores";
							break;
						}
						mensajeSis(mensaje);
						$('#numeroExpedienteID').focus();
						$('#nombreParticipante').val('');
						limpiarBotones();
					} else {
						consultaExpedienteParticipante(participanteID);
					}

				} else {
					mensajeSis("El participante consultado no existe en Guarda Valores.");
					$('#numeroExpedienteID').focus();
				}
			});
		}
	}

	// Consulta de Documento
	function consultaExpedienteParticipante(participanteID) {

		var tipoConsulta = 2;
		var mensaje  = "";
		var usuarioAutorizaID = usuarioAdministracion;
		var sucursalID = $('#sucursalID').val();
		var tipoInstrumento = $('#tipoInstrumento').val();


		var expedienteBean = {
			'tipoInstrumento' : tipoInstrumento,
			'numeroInstrumento' : participanteID,
			'sucursalID' : sucursalID,
			'usuarioAutorizaID' : usuarioAutorizaID
		};

		if (participanteID != '' && !isNaN(participanteID) && esTab) {

			documentosGuardaValoresServicio.consultaExpediente(tipoConsulta, expedienteBean, function(expediente) {
				if (expediente != null) {
					if(expediente.numeroExpedienteID != 0){
						consultarParticipante(participanteID);
					} else {
						switch(tipoInstrumento){
							case '1':
								mensaje = "El "+tipoMensaje+" No tiene Documentos Registrados en Guarda Valores";
								if(usuarioAdministracion == 0){
									mensaje = "El "+tipoMensaje+" No tiene Documentos Registrados en la Sucursal "+var_nombreSucursal;
								}
							break;
							case '7':
								mensaje = "El Prospecto No tiene Documentos Registrados en Guarda Valores";
								if(usuarioAdministracion == 0){
									mensaje = "El Prospecto No tiene Documentos Registrados en la Sucursal: "+var_nombreSucursal;
								}
							break;
							default:
								mensaje ="El "+ tipoMensaje + " o Prospecto no tiene documentos en Guarda Valores";
							break;
						}
						mensajeSis(mensaje);
						$('#nombreParticipante').val('');
						$('#numeroExpedienteID').focus();
						limpiarBotones();
					}
				}
				else {
					mensajeSis("El participante consultado no existe en Guarda Valores.");
					$('#numeroExpedienteID').focus();
				}
			});
		}
	}

	function consultarParticipante( participanteID){

		var numeroInstrumento = $('#tipoInstrumento').val();
		if(numeroInstrumento == 1){
			$('#tipoPersona').val('C');
		} else {
			$('#tipoPersona').val('P');
		}

		if(participanteID != '0'  && participanteID != ''){
			switch(numeroInstrumento){
				case '1':
					consultaCliente(participanteID);
				break;
				case '7':
					consultaProspecto(participanteID);
				break;
				default:
					$('#nombreParticipante').val('');
				break;
			}
		}else{
			mensajeSis("El "+ tipoMensaje + " o Prospecto no Existe");
			$('#nombreParticipante').val('');
			$('#numeroExpedienteID').focus();
		}
	}

	// Consulta de Cliente
	function consultaCliente(numeroCliente) {
		numeroConsulta = 1;

		if(numeroCliente != '0' ){
			setTimeout("$('#cajaLista').hide();", 200);
			if(numeroCliente != '' && !isNaN(numeroCliente) ){
				clienteServicio.consulta(con_Cliente.principal, numeroCliente,"", { async: false, callback: function(cliente){
					if(cliente!=null){
						var nombreCliente = cliente.nombreCompleto;
						nombreCliente = nombreCliente.toUpperCase();
						$('#nombreParticipante').val(nombreCliente);
						habilitaBoton('consulta','submit');
					}else{
						mensajeSis("El "+tipoMensaje+ " No Existe.");
						$('#nombreParticipante').val('');
						$('#numeroExpedienteID').focus();
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

		if(numeroProspecto != '0' ){
			setTimeout("$('#cajaLista').hide();", 200);
			if(numeroProspecto != '' && !isNaN(numeroProspecto) ){
				prospectosServicio.consulta(con_Prospecto.foranea,prospectoBeanCon,function(prospectos) {
					if(prospectos!=null){
						var nombreProspecto = prospectos.nombreCompleto;
						nombreProspecto = nombreProspecto.toUpperCase();
						$('#nombreParticipante').val(nombreProspecto);
						habilitaBoton('consulta','submit');
					}else{
						mensajeSis("El Prospecto no Existe");
						$('#nombreParticipante').val('');
						$('#numeroExpedienteID').focus();
					}
				});
			}
		}
	}

	$('#consulta').click(function() {
		limpiarDocumentos();
		var numeroExpedienteID = $("#numeroExpedienteID").val();
		var tipoPersona = $('#tipoPersona').val();

		if( numeroExpedienteID == 0 || numeroExpedienteID == ''){
			mensajeSis("Ingrese un Número de participante.");
			$('#numeroExpedienteID').focus();

		} else {
			consultaCatalogoActivo(tipoPersona, numeroExpedienteID);
			habilitaBoton('generar','submit');
			habilitaBoton('cancelar','submit');
		}
	});

	$('#generar').click(function() {

		var nombreInstitucion=	parametroBean.nombreInstitucion;
		var nombreUsuario = parametroBean.claveUsuario;
		var fechaEmision = parametroBean.fechaSucursal;

		var numeroExpedienteID = $("#numeroExpedienteID").val();
		var numeroInstrumento = numeroExpedienteID + '- '+ caracteresEspeciales($("#nombreParticipante").val());
		var sucursalID = 0;
		var nombreSucursal = 'TODAS';
		if(usuarioAdministracion == 0){
			sucursalID = $('#sucursalID').val();
			nombreSucursal = var_nombreSucursal.toUpperCase();
		}
		var fecha = new Date();

		var segundos  = fecha.getSeconds();
		var minutos = fecha.getMinutes();
		var horas = fecha.getHours();

		if(fecha.getHours()<10){
			horas = "0"+fecha.getHours();
		}
		if(fecha.getMinutes()<10){
			minutos = "0"+fecha.getMinutes();
		}
		if(fecha.getSeconds()<10){
			segundos = "0"+fecha.getSeconds();
		}

		var tipoPersona =  $("#tipoPersona").val();
		var horaEmision = horas+":"+minutos+":"+segundos;
		var tipoReporte = 4;
		var tipoLista   = 4;

		$('#ligaGenerar').attr('href',
			'reporteDocumentosGrdValPDF.htm'+
			'?numeroExpedienteID='+numeroExpedienteID+
			'&tipoInstrumento='+numeroInstrumento+
			'&tipoPersona='+tipoPersona+
			'&nombreInstitucion='+nombreInstitucion+
			'&nombreUsuario='+nombreUsuario+
			'&fechaEmision='+fechaEmision+
			'&horaEmision='+horaEmision+
			'&sucursalID='+sucursalID+
			'&nombreSucursal='+nombreSucursal+
			'&tipoReporte='+tipoReporte+
			'&tipoLista='+tipoLista);

	});

	$('#cancelar').click(function() {

		limpiarDocumentos();
		deshabilitaBoton('consulta', 'submit');
		deshabilitaBoton('generar','submit');
		deshabilitaBoton('cancelar', 'submit');
		$("#numeroExpedienteID").val('');
		$("#nombreParticipante").val('');
		$("#numeroExpedienteID").focus();
	});

	// Consulta de Documento
	function consultaCatalogoActivo(tipoPersona, numeroExpedienteID) {

		var	catalogoBean = {
		};

		var tipoLista = lista_Grid.expediente;

		catInstGuardaValoresServicio.lista(lista_Instrumento.foranea, catalogoBean, function(catalogo) {

			if (catalogo != null) {
				var instrumentosActivos = catalogo;

				for (var iteracion = 0; iteracion <instrumentosActivos.length; iteracion++) {

					var objetoArreglo = instrumentosActivos[iteracion];
					instrumento = objetoArreglo.catInsGrdValoresID;
					if(tipoPersona == 'C'){
						switch(instrumento){
							case catalogoInstrumentos.cliente:
								mostrarGrid(catalogoInstrumentosGrid.cliente, catalogoInstrumentos.cliente, numeroExpedienteID, tipoLista, 'cliente');
							break;
							case catalogoInstrumentos.cuenta:
								mostrarGrid(catalogoInstrumentosGrid.cuenta, catalogoInstrumentos.cuenta, numeroExpedienteID, tipoLista, 'cuenta');
							break;
							case catalogoInstrumentos.cede:
								mostrarGrid(catalogoInstrumentosGrid.cede, catalogoInstrumentos.cede, numeroExpedienteID, tipoLista, 'cede');
							break;
							case catalogoInstrumentos.inversion:
								mostrarGrid(catalogoInstrumentosGrid.inversion, catalogoInstrumentos.inversion, numeroExpedienteID, tipoLista, 'inversion');
							break;
							case catalogoInstrumentos.solicitudCredito:
								mostrarGrid(catalogoInstrumentosGrid.solicitudCredito, catalogoInstrumentos.solicitudCredito, numeroExpedienteID, tipoLista, 'solicitudCredito');
							break;
							case catalogoInstrumentos.credito:
								mostrarGrid(catalogoInstrumentosGrid.credito, catalogoInstrumentos.credito, numeroExpedienteID, tipoLista, 'credito');
							break;
							case catalogoInstrumentos.aportacion:
								mostrarGrid(catalogoInstrumentosGrid.aportacion, catalogoInstrumentos.aportacion, numeroExpedienteID, tipoLista, 'aportacion');
							break;
							default:
								$('#tipoTransaccion').val(0);
							break;
						}
					}

					if(tipoPersona == 'P'){
						switch(instrumento){
							case catalogoInstrumentos.prospecto:
								mostrarGrid(catalogoInstrumentosGrid.prospecto, catalogoInstrumentos.prospecto, numeroExpedienteID, tipoLista, 'prospecto');
							break;
							default:
								$('#tipoTransaccion').val(0);
							break;
						}
					}
				}
			} else {
				mensajeSis("No existen Instrumentos Activos.");
				$('#numeroExpedienteID').focus();
			}
		});
	}

	function mostrarGrid( tipoLista, tipoInstrumento, numeroInstrumento, tipoReporte, nombreLista){

		var codigo  = '';
		var params = {
			'nombreParticipante' : $('#tipoPersona').val(),
			'tipoLista' : tipoLista,
			'tipoReporte' : tipoReporte,
			'tipoInstrumento' : tipoInstrumento,
			'numeroInstrumento': numeroInstrumento,
			'sucursalID' : $('#sucursalID').val(),
			'nombreLista' : nombreLista,
			'usuarioAutorizaID' : usuarioAdministracion
		};

		$.post("listaExpedientesGridGrdValores.htm", params, function(data) {
			switch(tipoInstrumento){
				case catalogoInstrumentos.cliente:
					codigo = $("#expedientesRegistradosGridCliente").html();
					if (data.length >0) {
						codigo = codigo + data;
						$('#expedientesRegistradosGridCliente').show();
						$("#expedientesRegistradosGridCliente").append(codigo);
					} else {
						codigo = codigo +'';
					}
				break;
				case catalogoInstrumentos.cuenta:
					codigo = $("#expedientesRegistradosGridCuenta").html();
					if (data.length >0) {
						codigo = codigo + data;
						$('#expedientesRegistradosGridCuenta').show();
						$("#expedientesRegistradosGridCuenta").append(codigo);
					} else {
						codigo = codigo +'';
					}
				break;
				case catalogoInstrumentos.cede:
					codigo = $("#expedientesRegistradosGridCede").html();
					if (data.length >0) {
						codigo = codigo + data;
						$('#expedientesRegistradosGridCede').show();
						$("#expedientesRegistradosGridCede").append(codigo);
					} else {
						codigo = codigo +'';
					}
				break;
				case catalogoInstrumentos.inversion:
					codigo = $("#expedientesRegistradosGridInversion").html();
					if (data.length >0) {
						codigo = codigo + data;
						$('#expedientesRegistradosGridInversion').show();
						$("#expedientesRegistradosGridInversion").append(codigo);
					} else {
						codigo = codigo +'';
					}
				break;
				case catalogoInstrumentos.solicitudCredito:
					codigo = $("#expedientesRegistradosGridSolicitudCredito").html();
					if (data.length >0) {
						codigo = codigo + data;
						$('#expedientesRegistradosGridSolicitudCredito').show();
						$("#expedientesRegistradosGridSolicitudCredito").append(codigo);
					} else {
						codigo = codigo +'';
					}
				break;
				case catalogoInstrumentos.credito:
					codigo = $("#expedientesRegistradosGridCredito").html();
					if (data.length >0) {
						codigo = codigo + data;
						$('#expedientesRegistradosGridCredito').show();
						$("#expedientesRegistradosGridCredito").append(codigo);
					} else {
						codigo = codigo +'';
					}
				break;
				case catalogoInstrumentos.prospecto:
					codigo = $("#expedientesRegistradosGridProspecto").html();
					if (data.length > 0) {
						codigo = codigo + data;
						$('#expedientesRegistradosGridProspecto').show();
						$("#expedientesRegistradosGridProspecto").append(codigo);
					} else {
						codigo = codigo +'';
					}
				break;
				case catalogoInstrumentos.aportacion:
					codigo = $("#expedientesRegistradosGridAportacion").html();
					if (data.length >0) {
						codigo = codigo + data;
						$('#expedientesRegistradosGridAportacion').show();
						$("#expedientesRegistradosGridAportacion").append(codigo);
					} else {
						codigo = codigo +'';
					}
				break;
			}
		});

		return codigo;
	}

});

var parametroBean = consultaParametrosSession();
var fechaSucursal = parametroBean.fechaSucursal;

function generaReporte(numeroReporte, idControl){

	var numero            = 0;
	var documentoID       = 0;
	var numeroInstrumento = '';
	var jqDocumentoID     = '';
	var jqNombreDocumento = '';

	switch(numeroReporte){
		case 1:

			numero = idControl.substr(14,idControl.length);
			jqDocumentoID 	  = eval("'#" + "listaClienteDocumentoID" + numero +"'");
			jqNombreDocumento = eval("'#" + "listaClienteDescripcion" + numero +"'");

		break;
		case 2:

			numero = idControl.substr(13,idControl.length);
			jqDocumentoID 	  = eval("'#" + "listaCuentaDocumentoID" + numero +"'");
			jqNombreDocumento = eval("'#" + "listaCuentaDescripcion" + numero +"'");

		break;
		case 3:

			numero = idControl.substr(11,idControl.length);
			jqDocumentoID 	  = eval("'#" + "listaCedeDocumentoID" + numero +"'");
			jqNombreDocumento = eval("'#" + "listaCedeDescripcion" + numero +"'");

		break;
		case 4:

			numero = idControl.substr(16,idControl.length);
			jqDocumentoID 	  = eval("'#" + "listaInversionDocumentoID" + numero +"'");
			jqNombreDocumento = eval("'#" + "listaInversionDescripcion" + numero +"'");

		break;
		case 5:

			numero = idControl.substr(16,idControl.length);
			jqDocumentoID 	  = eval("'#" + "listaSolicitudDocumentoID" + numero +"'");
			jqNombreDocumento = eval("'#" + "listaSolicitudDescripcion" + numero +"'");

		break;
		case 6:

			numero = idControl.substr(14,idControl.length);
			jqDocumentoID 	  = eval("'#" + "listaCreditoDocumentoID" + numero +"'");
			jqNombreDocumento = eval("'#" + "listaCreditoDescripcion" + numero +"'");

		break;
		case 7:

			numero = idControl.substr(16,idControl.length);
			jqDocumentoID 	  = eval("'#" + "listaProspectoDocumentoID" + numero +"'");
			jqNombreDocumento = eval("'#" + "listaProspectoDescripcion" + numero +"'");

		break;
		case 8:

			numero = idControl.substr(17,idControl.length);
			jqDocumentoID 	  = eval("'#" + "listaAportacionDocumentoID" + numero +"'");
			jqNombreDocumento = eval("'#" + "listaAportacionDescripcion" + numero +"'");

		break;
	}

	documentoID 	  = $(jqDocumentoID).val();
	numeroInstrumento = documentoID +' - '+caracteresEspeciales($(jqNombreDocumento).val());

	var tipoReporte = 4;
	var tipoLista   = 4;

	var nombreInstitucion=	parametroBean.nombreInstitucion;
	var nombreUsuario = parametroBean.claveUsuario;
	var fechaEmision = parametroBean.fechaSucursal;
	var fecha = new Date();

	var segundos  = fecha.getSeconds();
	var minutos = fecha.getMinutes();
	var horas = fecha.getHours();

	if(fecha.getHours()<10){
		horas = "0"+fecha.getHours();
	}
	if(fecha.getMinutes()<10){
		minutos = "0"+fecha.getMinutes();
	}
	if(fecha.getSeconds()<10){
		segundos = "0"+fecha.getSeconds();
	}

	var horaEmision = horas+":"+minutos+":"+segundos;

	var pagina ='reporteDocumentosGrdValExcel.htm'+
				'?documentoID='+documentoID+
				'&numeroInstrumento='+numeroInstrumento+
				'&tipoReporte='+tipoReporte+
				'&tipoLista='+tipoLista+
				'&fechaEmision='+fechaEmision+
				'&horaEmision='+horaEmision+
				'&nombreUsuario='+nombreUsuario+
				'&nombreInstitucion='+nombreInstitucion;
	window.open(pagina);
}

function cargaGrid(pageValor, tipoLista, numeroInstrumento){

	var catalogoInstrumentosGrid = {
		'cliente'			: 2,
		'cuenta'			: 3,
		'cede'				: 4,
		'inversion'			: 5,
		'solicitudCredito'	: 6,
		'credito'			: 7,
		'prospecto'			: 8,
		'aportacion'		: 9
	};

	var catalogoInstrumentos = {
		'cliente'			: 1,
		'cuenta'			: 2,
		'cede'				: 3,
		'inversion'			: 4,
		'solicitudCredito'	: 5,
		'credito'			: 6,
		'prospecto'			: 7,
		'aportacion'		: 8
	};

	var params = {
	};

	params['pagina']    = pageValor;
	params['tipoLista'] = tipoLista;

	switch(tipoLista){
		case catalogoInstrumentosGrid.cliente:
			params['nombreLista'] = 'cliente';
		break;
		case catalogoInstrumentosGrid.cuenta:
			params['nombreLista'] = 'cuenta';
		break;
		case catalogoInstrumentosGrid.cede:
			params['nombreLista'] = 'cede';
		break;
		case catalogoInstrumentosGrid.inversion:
			params['nombreLista'] = 'inversion';
		break;
		case catalogoInstrumentosGrid.solicitudCredito:
			params['nombreLista'] = 'solicitudCredito';
		break;
		case catalogoInstrumentosGrid.credito:
			params['nombreLista'] = 'credito';
		break;
		case catalogoInstrumentosGrid.prospecto:
			params['nombreLista'] = 'prospecto';
		break;
		case catalogoInstrumentosGrid.aportacion:
			params['nombreLista'] = 'aportacion';
		break;
	}

	$.post("listaExpedientesGridGrdValores.htm", params, function(data) {
		switch(numeroInstrumento){
			case catalogoInstrumentos.cliente:
				if (data.length >0) {
					$('#expedientesRegistradosGridCliente').html(data);
					$('#expedientesRegistradosGridCliente').show();
				}
			break;
			case catalogoInstrumentos.cuenta:
				if (data.length >0) {
					$('#expedientesRegistradosGridCuenta').html(data);
					$('#expedientesRegistradosGridCuenta').show();
				}
			break;
			case catalogoInstrumentos.cede:
				if (data.length >0) {
					$('#expedientesRegistradosGridCede').html(data);
					$('#expedientesRegistradosGridCede').show();
				}
			break;
			case catalogoInstrumentos.inversion:
				if (data.length >0) {
					$('#expedientesRegistradosGridInversion').html(data);
					$('#expedientesRegistradosGridInversion').show();
				}
			break;
			case catalogoInstrumentos.solicitudCredito:
				if (data.length >0) {
					$('#expedientesRegistradosGridSolicitudCredito').html(data);
					$('#expedientesRegistradosGridSolicitudCredito').show();
				}
			break;
			case catalogoInstrumentos.credito:
				if (data.length >0) {
					$('#expedientesRegistradosGridCredito').html(data);
					$('#expedientesRegistradosGridCredito').show();
				}
			break;
			case catalogoInstrumentos.prospecto:
				if (data.length > 0) {
					$('#expedientesRegistradosGridProspecto').html(data);
					$('#expedientesRegistradosGridProspecto').show();
				}
			break;
			case catalogoInstrumentos.aportacion:
				if (data.length >0) {
					$('#expedientesRegistradosGridAportacion').html(data);
					$('#expedientesRegistradosGridAportacion').show();
				}
			break;
		}
	});
}

//cambiar Caracteres especiales
function caracteresEspeciales(cadena){
	// Se cambia las letras por valores URL
	cadena = cadena.replace(/Á/gi,"%C1");
	cadena = cadena.replace(/É/gi,"%C9");
	cadena = cadena.replace(/Í/gi,"%CD");
	cadena = cadena.replace(/Ó/gi,"%D3");
	cadena = cadena.replace(/Ú/gi,"%DA");
	cadena = cadena.replace(/&/gi,"%26");
	cadena = cadena.replace(/#/gi,"%23");
	return cadena;
}

function limpiarDocumentos(){
	$("#expedientesRegistradosGridCliente").hide();
	$("#expedientesRegistradosGridCuenta").hide();
	$("#expedientesRegistradosGridCede").hide();
	$("#expedientesRegistradosGridInversion").hide();
	$("#expedientesRegistradosGridSolicitudCredito").hide();
	$("#expedientesRegistradosGridCredito").hide();
	$("#expedientesRegistradosGridProspecto").hide();
	$("#expedientesRegistradosGridAportacion").hide();
	$("#expedientesRegistradosGridCliente").html('');
	$("#expedientesRegistradosGridCuenta").html('');
	$("#expedientesRegistradosGridCede").html('');
	$("#expedientesRegistradosGridInversion").html('');
	$("#expedientesRegistradosGridSolicitudCredito").html('');
	$("#expedientesRegistradosGridCredito").html('');
	$("#expedientesRegistradosGridProspecto").html('');
	$("#expedientesRegistradosGridAportacion").html('');
}

function deshabilitaPantalla(){
	mensajeSis("Estimado Usuario no Cuenta con los Permisos Necesarios para el Módulo Guarda Valores.");
	deshabilitaControl('numeroExpedienteID');
	deshabilitaControl('nombreParticipante');
	deshabilitaBoton('consulta','submit');
	deshabilitaBoton('generar','submit');
	deshabilitaBoton('cancelar','submit');
	limpiarDocumentos();
}

function limpiarBotones(){

	deshabilitaBoton('consulta','submit');
	deshabilitaBoton('generar','submit');
	deshabilitaBoton('cancelar','submit');
	limpiarDocumentos();

}
function consultarTiposIntrumentos() {
	var tipoConsulta = 2;
	dwr.util.removeAllOptions('tipoInstrumento');
	dwr.util.addOptions('tipoInstrumento', {'0':'SELECCIONA'});
	catInstGuardaValoresServicio.listaCombo(tipoConsulta, function(intrumentos){
		dwr.util.addOptions('tipoInstrumento', intrumentos, 'catInsGrdValoresID', 'nombreInstrumento');
		$("#tipoInstrumento").children('option[value="2"]').remove();
		$("#tipoInstrumento").children('option[value="3"]').remove();
		$("#tipoInstrumento").children('option[value="4"]').remove();
		$("#tipoInstrumento").children('option[value="5"]').remove();
		$("#tipoInstrumento").children('option[value="6"]').remove();
		$("#tipoInstrumento").children('option[value="8"]').remove();
	});

}