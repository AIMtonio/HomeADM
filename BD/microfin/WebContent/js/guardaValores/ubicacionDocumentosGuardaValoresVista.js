var usuarioAdministracion = 0;
var usuarioComboRegistro = 0;
var tipoOperacionVentana = 0;
$(document).ready(function() {

	// Definicion de Constantes y Enums
	esTab = false;
	var parametroBean = consultaParametrosSession();
	var clavePuestoID = parametroBean.clavePuestoID;
	var numeroUsuario = parametroBean.numeroUsuario;
	$('#sucursalID').val(parametroBean.sucursal);
	$('#tipoInstrumento').focus();
	validarUsuario(clavePuestoID, numeroUsuario);
	consultarTiposIntrumentos();
	var tipoMensaje = $('#tipoMensaje').val();

	//Definicion de Constantes y Enums
	var catDocumentosGuardaValores = {
		'custodia'	: '2',
	};

	var con_Documento= {
		'documentoRegistrado' : 2
	};

	var con_Almacen= {
		'almacenActivo'	: 2
	};

	var con_Cliente = {
		'principal' : 1
	};

	var con_Prospecto = {
		'foranea' : 7
	};

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('grabar','submit');
	deshabilitaBoton('cancelar','submit');

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
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true','tipoInstrumento', 'funcionExito', 'funcionError');
		}
	});

	$('#grabar').click(function() {
		$('#tipoTransaccion').val(catDocumentosGuardaValores.custodia);
		tipoOperacionVentana = $('#tipoTransaccion').val();
	});


	$('#cancelar').click(function() {
		limpiarFormulario();
		deshabilitarCampos();
		$('#tipoInstrumento').val(0);
		$('#tipoInstrumento').focus();

	});

	//------------ Validaciones de la Forma -----------------------------------

	$('#tipoInstrumento').blur(function(){
		limpiarFormulario();
	});

	$('#almacenID').bind('keyup',function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "nombreAlmacen";
		camposLista[1] = "sucursalID";

		parametrosLista[0] = $('#almacenID').val();
		parametrosLista[1] = $('#sucursalID').val();

		lista('almacenID', '2', '2', camposLista, parametrosLista, 'listaCatalogoAlmacenes.htm');
	});

	$('#almacenID').blur(function(){
		consultaAlmacen(this.id);
	});

	$('#documentoID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "nombreParticipante";
		camposLista[1] = "tipoInstrumento";
		camposLista[2] = "sucursalID";

		parametrosLista[0] = $('#documentoID').val();
		parametrosLista[1] = $('#tipoInstrumento').val();
		parametrosLista[2] = $('#sucursalID').val();

		lista('documentoID', '2', '2', camposLista, parametrosLista, 'listaDocumentosGrdValores.htm');
	});

	$('#documentoID').blur(function(){
		consultaDocumento(this.id);
	});

	$('#ubicacion').blur(function(){
		limpiarCaracterEscape(this.id, 500);
	});

	$('#seccion').blur(function(){
		limpiarCaracterEscape(this.id, 500);
	});

		//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			documentoID: {
				required: true
			},
			almacenID: {
				required: true
			},
			ubicacion: {
				required: true,
			},
			seccion: {
				required: true,
			}
		},
		messages: {
			documentoID: {
				required: 'Especificar el Documento'
			},
			almacenID: {
				required: 'Especificar el Almacén para Resguardo del Documento'
			},
			ubicacion: {
				required: 'Especificar una ubicación'
			},
			seccion: {
				required: 'Especificar una Sección'
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
	function consultaDocumento(idControl) {
		var jqDocumento = eval("'#" + idControl + "'");
		var numeroDocumento = $(jqDocumento).val();
		setTimeout("$('#cajaLista').hide();", 200);

		var	documentoBean = {
			'documentoID':numeroDocumento,
			'tipoInstrumento':$('#tipoInstrumento').val(),
			'sucursalID':$('#sucursalID').val()
		};

		if (numeroDocumento != '' && !isNaN(numeroDocumento) && esTab) {

			documentosGuardaValoresServicio.consultaDocumento(con_Documento.documentoRegistrado, documentoBean, function(documento) {

				if (documento != null) {
					$('#fechaRegistro').val(documento.fechaRegistro);
					$('#participanteID').val(documento.participanteID);
					$('#numeroInstrumento').val(documento.numeroInstrumento);
					$('#origenDocumento').val(documento.origenDocumento);

					$('#tipoDocumentoID').val(documento.grupoDocumentoID);
					$('#nombreDocumento').val(documento.nombreDocumento);
					$('#estatus').val(documento.estatus);

					$('#sucursalID').val(parametroBean.sucursal);
					consultarInstrumentoGrdValor(documento.tipoPersona, documento.participanteID);
					habilitarCampos();
					$('#almacenID').focus();
				} else {
					mensajeSis("El Documento Consultado no Existe o está en un Estatus Diferente de Registrado.");
					$('#documentoID').focus();
					limpiarFormulario();
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
			mensajeSis("El "+tipoMensaje+" o Prospecto no Existe");
			$('#participanteID').val('');
			$('#numeroInstrumento').focus();
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

	// Consulta de Almacén
	function consultaAlmacen(idControl) {
		var jqAlmacen = eval("'#" + idControl + "'");
		var numAlmacen = $(jqAlmacen).val();
		var sucursalID = $('#sucursalID').val();

		setTimeout("$('#cajaLista').hide();", 200);

		var catalogoAlmacenesBean = {
				'almacenID':numAlmacen,
				'sucursalID':sucursalID
		};

		if (numAlmacen != '' && !isNaN(numAlmacen) && esTab) {

			catalogoAlmacenesServicio.consulta(con_Almacen.almacenActivo, catalogoAlmacenesBean, function(catalogoAlmacen) {

				if (catalogoAlmacen != null) {
					$('#almacenID').val(catalogoAlmacen.almacenID);
					$('#nombreAlmacen').val(catalogoAlmacen.nombreAlmacen);
				} else {
					mensajeSis("El Almacén Consultado no Existe o está Inactivo.");
					$('#almacenID').focus();
				}
			});
		}
	}
});

function habilitarCampos(){
	habilitaControl('almacenID');
	habilitaControl('ubicacion');
	habilitaControl('seccion');
	habilitaBoton('grabar','submit');
	habilitaBoton('cancelar','submit');
}

function deshabilitarCampos(){
	deshabilitaControl('almacenID');
	deshabilitaControl('ubicacion');
	deshabilitaControl('seccion');
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
	$('#almacenID').val('');
	$('#nombreAlmacen').val('');

	$('#ubicacion').val('');
	$('#seccion').val('');
	$('#tipoTransaccion').val('');
	$('#documentoID').val('');
	deshabilitarCampos();
}

function funcionError(){
	$('#tipoTransaccion').focus();
	$("#tipoInstrumento").val(tipoOperacionVentana);
}

function funcionExito(){
	limpiarFormulario();
	$('#tipoInstrumento').val('0');
}

function consultarTiposIntrumentos() {
	var tipoConsulta = 2;
	dwr.util.removeAllOptions('tipoInstrumento');
	dwr.util.addOptions( 'tipoInstrumento', {'0':'SELECCIONAR'});
	catInstGuardaValoresServicio.listaCombo(tipoConsulta, function(intrumentos){
		dwr.util.addOptions('tipoInstrumento', intrumentos, 'catInsGrdValoresID', 'nombreInstrumento');
	});
}

function deshabilitaPantalla(){
	mensajeSis("Estimado Usuario no Cuenta con los Permisos Necesarios para el Módulo Guarda Valores.");
	$('#documentoID').val('');
	$('#tipoInstrumento').val('0');
	deshabilitaControl('documentoID');
	deshabilitaControl('tipoInstrumento');
	limpiarFormulario();
}