/*Pantalla*/
var numeroDocumentos = 0;
var parametroBean = consultaParametrosSession();
var esTab = false;
var catTipoTransaccionFileUpload = {
'enviar' : 1,
'modificar' : 2,
'eliminar' : 3
};

var catTipoConsultaProspec = {
	'foranea' : 2
};
//Definicion de Constantes y Enums  
var nomAr = "";
var divCajaLista = $('#cajaLista');
$(document).ready(function() {
	comboTiposDocumento();
	$('#ligaGenerar').removeAttr("href");

	//------------ Metodos y Manejo de Eventos -----------------------------------------
	habilitaBoton('pdf', 'submit');

	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$.validator.setDefaults({
		submitHandler : function(event) {
			grabaFormaArchivo(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'clienteID');
		}
	});

	$('#clienteID').focus();

	$('#enviar').click(function() {
		if (($('#clienteID').val() == null || $.trim($('#clienteID').val()) == '') && ($('#prospectoID').val() == null || $.trim($('#prospectoID').val()) == '')) {
			mensajeSis("Especifique un " + $("#safilocaleCTE").val() + " o Prospecto ");
			$('#clienteID').focus();
		} else {
			if ($('#tipoDocumento').val() == null || $('#tipoDocumento').val() == '') {
				mensajeSis("Seleccione un tipo de Documento");
				$('#tipoDocumento').focus();
			} else {
				subirArchivos();
			}
		}
	});

	$('#pdf').click(function() {
		if ($('#clienteID').val() == '' && $('#prospectoID').val() == '') {
			mensajeSis("Debe de indicar un " + $("#safilocaleCTE").val() + " o Prospecto");
			$('#clienteID').focus();
		} else {
			consultaNumeroDocumentosPorCliente();
		}
	});

	$('#clienteID').blur(function() {
		if (esTab) {
			consultaCliente('clienteID');
		}
		$('#imagenCte').hide();

	});

	$('#clienteID').bind('keyup', function(e) {
		lista('clienteID', '1', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#prospectoID').blur(function() {
		if (esTab) {
			consultaProspecto('prospectoID');
		}
	});

	$('#prospectoID').bind('keyup', function(e) {
		lista('prospectoID', '1', '1', 'prospectoID', $('#prospectoID').val(), 'listaProspecto.htm');
	});

	$('#file').blur(function() {
		nomAr = $('#file').val();
		$('#extarchivo').val(nomAr.substring(nomAr.lastIndexOf('.')));
		conta = 1;
		$('#observacion').focus();
	});

	$('#tipoDocumento').blur(function() {

		consultaArchivCliente();
		$('#imagenCte').hide();

	});

	$('#observacion').focus(function() {
		nomAr = $('#file').val();
		$('#extarchivo').val(nomAr.substring(nomAr.lastIndexOf('.')));
	});

	rutaArchivos = parametroBean.rutaArchivos;
	$('#recurso').val(parametroBean.rutaArchivos);

	//------------ Validaciones de la Forma -------------------------------------

	$.validator.addMethod('filesize', function(value, element, param) {
		// param = size (en bytes) 
		// element = element to validate (<input>)
		// value = value of the element (file name)
		return this.optional(element) || (element.files[0].size <= param);
	});

	$('#formaGenerica').validate({
	rules : {
	clienteID : {
		required : true
	},
	tipoDocumento : {
		required : true
	},
	observacion : {
		required : true
	},
	file : {
	required : true,
	filesize : 3145728
	}
	},
	messages : {
	clienteID : {
		required : 'Especificar Cliente'
	},
	tipoDocumento : {
		required : 'Especificar Tipo de Documento'
	},
	observacion : {
		required : 'Especificar Observación'
	},
	file : {
	required : 'Seleccionar Archivo',
	filesize : 'El archivo seleccionado debe tener un tamaño máximo de 3MB'
	}
	}
	});

});

//------------ Validaciones de Controles -------------------------------------
function consultaCliente(idControl) {
	var jqcliente = eval("'#" + idControl + "'");
	var numCliente = $(jqcliente).val();
	setTimeout("$('#cajaLista').hide();", 200);
	if (numCliente != '' && !isNaN(numCliente)) {
		clienteServicio.consulta(2, numCliente, function(cliente) {
			if (cliente != null) {
				$('#clienteID').val(cliente.numero);
				$('#nombreCliente').val(cliente.nombreCompleto);
				habilitaBoton('pdf', 'submit');
				$('#gridArchivosCliente').html("");
				$('#prospectoID').val("");
				$('#nombreProspecto').val("");
				clienteServicio.consulta(10, numCliente, function(prospectos){
				if(prospectos != null){	
                    		var prospectoBeanCon = {
					'prospectoID' : prospectos.prospectoID
					};
					prospectosServicio.consulta(catTipoConsultaProspec.foranea, prospectoBeanCon, function(prospectos) {
						if (prospectos != null) {
							$('#clienteID').val(prospectos.cliente);
							$('#prospectoID').val(prospectos.prospectoID);
							$('#nombreProspecto').val(prospectos.nombreCompleto);
							$('#gridArchivosCliente').html("");
						} else {
							mensajeSis("No Existe el Prospecto");
							$('#prospectoID').val("");
							$('#prospectoID').focus();
							$('#nombreProspecto').val("");
							$('#gridArchivosCliente').html("");
						}
					});
				}
				});
			} else {
				mensajeSis("No Existe el " + $("#safilocaleCTE").val());
				$('#clienteID').focus();
				$('#clienteID').select();
				$('#nombreCliente').val("");
				$('#gridArchivosCliente').html("");
				$('#prospectoID').val("");
				$('#nombreProspecto').val("");

			}
		});
	} else {
		$('#nombreCliente').val("");
	}
	if (numCliente != '' && isNaN(numCliente)) {
		$('#clienteID').val("");
		$('#nombreCliente').val("");
	}
}

function consultaClienteProspecto(idControl) {
	var jqcliente = eval("'#" + idControl + "'");
	var numCliente = $(jqcliente).val();
	setTimeout("$('#cajaLista').hide();", 200);
	if (numCliente != '' && !isNaN(numCliente)) {
		clienteServicio.consulta(2, numCliente, function(cliente) {
			if (cliente != null) {
				$('#clienteID').val(cliente.numero);
				$('#nombreCliente').val(cliente.nombreCompleto);
				habilitaBoton('pdf', 'submit');
				$('#gridArchivosCliente').html("");
			} else {
				mensajeSis("No Existe el " + $("#safilocaleCTE").val());
				$('#clienteID').focus();
				$('#clienteID').select();
				$('#nombreCliente').val("");
				$('#gridArchivosCliente').html("");
				$('#prospectoID').val("");
				$('#nombreProspecto').val("");

			}
		});
	} else {
		$('#nombreCliente').val("");
	}
	if (numCliente != '' && isNaN(numCliente)) {
		$('#clienteID').val("");
		$('#nombreCliente').val("");
	}
}

function consultaProspecto(idControl) {
	var jqProspecto = eval("'#" + idControl + "'");
	var numProspecto = $(jqProspecto).val();
	setTimeout("$('#cajaLista').hide();", 200);
	if (numProspecto != '' && !isNaN(numProspecto)) {
		deshabilitaBoton('agrega', 'submit');
		habilitaBoton('modifica', 'submit');
		var prospectoBeanCon = {
			'prospectoID' : numProspecto
		};
		prospectosServicio.consulta(catTipoConsultaProspec.foranea, prospectoBeanCon, function(prospectos) {
			if (prospectos != null) {
				$('#clienteID').val(prospectos.cliente);
				$('#prospectoID').val(prospectos.prospectoID);
				$('#nombreProspecto').val(prospectos.nombreCompleto);
				consultaClienteProspecto('clienteID');
				$('#gridArchivosCliente').html("");
			} else {
				mensajeSis("No Existe el Prospecto");
				$('#prospectoID').val("");
				$('#prospectoID').focus();
				$('#nombreProspecto').val("");
				$('#gridArchivosCliente').html("");
			}
		});
	}
	if (numProspecto != '' && isNaN(numProspecto)) {
		//if (!divCajaLista.is(':visible')){
		$('#prospectoID').val("");
		$('#nombreProspecto').val("");
		//}
	}
}
//Funcion para consultar el numero de documentos por cliente. y generar reporte
function consultaNumeroDocumentosPorCliente() {
	var clienteArchivosBean = {
	'prospectoID' : $('#prospectoID').val(),
	'clienteID' : $('#clienteID').val(),

	};
	setTimeout("$('#cajaLista').hide();", 200);

	if ($('#clienteID').val() != '' || !isNaN($('#clienteID').val())) {
		clienteArchivosServicio.consulta(3, clienteArchivosBean, function(clienteArchivos) {
			if (clienteArchivos != null) {
				numeroDocumentos = clienteArchivos.numeroDocumentos;
				if (numeroDocumentos > 0) {
					var parametrosBean = consultaParametrosSession();
					var fechaEmision = parametrosBean.fechaAplicacion;
					var claveUsuario = parametrosBean.claveUsuario;
					var nombreInstitucion = parametrosBean.nombreInstitucion;

					var clienteID = $('#clienteID').val();
					var nombre = $('#nombreCliente').val();
					var prospectoID = $('#prospectoID').val();
					var nombreProspecto = $('#nombreProspecto').val();

					var pagina = 'clientesFilePDF.htm?clienteID=' + clienteID + '&nombreCliente=' + nombre + '&prospectoID=' + prospectoID + '&nombreProspecto=' + nombreProspecto + '&usuario=' + claveUsuario + '&fechaEmision=' + fechaEmision + '&nombreInstitucion=' + nombreInstitucion + '&recurso=' + parametroBean.rutaArchivos;
					window.open(pagina);

				} else {
					mensajeSis("El " + $("#safilocaleCTE").val() + " no tiene documentos digitalizados.");
				}
			} else {
				mensajeSis("El " + $("#safilocaleCTE").val() + " no tiene documentos digitalizados.");
			}
		});
	}
}

function consultaArchivCliente() {
	if ($('#clienteID').val() != null || $('#clienteID').val() != '' || $('#prospectoID').val() != null || $('#prospectoID').val() != '') {
		var params = {};
		params['tipoLista'] = 1;
		params['clienteID'] = $('#clienteID').val();
		params['prospectoID'] = $('#prospectoID').val();
		params['tipoDocumento'] = $('#tipoDocumento').val();
		$.post("gridClienteFileUpload.htm", params, function(data) {
			if (data.length > 0) {
				$('#gridArchivosCliente').html(data);
				$('#gridArchivosCliente').show();
			} else {
				$('#gridArchivosCliente').html("");
				$('#gridArchivosCliente').show();
			}
		});
	}
}

var parametrosBean = consultaParametrosSession();
var rutaArchivos = parametrosBean.rutaArchivos;
var ventanaArchivosCliente = "";
function subirArchivos() {
	var url = "clientesFileUploadVista.htm?Cte=" + $('#clienteID').val() + "&td=" + $('#tipoDocumento').val() + "&pro=" + $('#prospectoID').val();
	var leftPosition = (screen.width) ? (screen.width - 850) / 2 : 0;
	var topPosition = (screen.height) ? (screen.height - 500) / 2 : 0;
	ventanaArchivosCliente = window.open(url, "PopUpSubirArchivo", "width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0" + "left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition);
}

//funcion para llenar el combo de procesos de escalamiento
function comboTiposDocumento() {
	var tiposDoc = {
		'requeridoEn' : 'C'
	};
	dwr.util.removeAllOptions('tipoDocumento');
	dwr.util.addOptions('tipoDocumento', {
		'' : 'SELECCIONAR'
	});
	tiposDocumentosServicio.listaCombo(1, tiposDoc, function(tiposDocumentos) {
		dwr.util.addOptions('tipoDocumento', tiposDocumentos, 'tipoDocumentoID', 'descripcion');
	});
}

//funcion para eliminar el documento digitalizado
function eliminaArchivo(folioDocumento,idDesTipoDoc) {
	confirmarEliminar(folioDocumento,idDesTipoDoc) ;
}

function eliminarArchivo(folioDocumento) {
	var bajaFolioDocumentoCliente = 1;
	var clienteArchivoBean = {
	'clienteID' : $('#clienteID').val(),
	'prospectoID' : $('#prospectoID').val(),
	'clienteArchivosID' : folioDocumento
	};

	clienteArchivosServicio.bajaArchivosCliente(bajaFolioDocumentoCliente, clienteArchivoBean, function(mensajeTransaccion) {
		if (mensajeTransaccion != null) {
			mensajeSis(mensajeTransaccion.descripcion);
			consultaArchivCliente();

		} else {
			mensajeSis("Existio un Error al Borrar el Documento");
		}
	});

}

function confirmarEliminar(folioDocumento,idDesTipoDoc) {
	mensajeSisRetro({
		mensajeAlert : '¿Desea eliminar el documento '+ idDesTipoDoc +'?',
		muestraBtnAceptar: true,
		muestraBtnCancela: true,
		muestraBtnCerrar: true,
		txtAceptar : 'Aceptar',
		txtCancelar : 'Cancelar',
		txtCabecera:  'Mensaje:',
		funcionAceptar : function(){
			eliminarArchivo(folioDocumento);
		},
		funcionCancelar : function(){},
		funcionCerrar   : function(){}
	});
	
}

function verArchivosCliente(id, idTipoDoc, idarchivo, recurso) {
	var varClienteVerArchivo = $('#clienteID').val();
	var varTipoDocVerArchivo = idTipoDoc;
	var varTipoConVerArchivo = 10;
	var parametros = "?clienteID=" + varClienteVerArchivo + "&prospectoID=" + $('#prospectoID').val() + "&tipoDocumento=" + varTipoDocVerArchivo + "&tipoConsulta=" + varTipoConVerArchivo + "&recurso=" + recurso;

	var pagina = "clientesVerArchivos.htm" + parametros;
	var idrecurso = eval("'#recursoCteInput" + id + "'");
	var extensionArchivo = $(idrecurso).val().substring($(idrecurso).val().lastIndexOf('.'));
	extensionArchivo = extensionArchivo.toLowerCase();
	if (extensionArchivo == ".jpg" || extensionArchivo == ".png" || extensionArchivo == ".jpeg" || extensionArchivo == ".gif") {
		$('#imgCliente').attr("src", pagina);
		$('#imagenCte').html();
		// $.blockUI({message: $('#imagenCte')}); 
		$.blockUI({
		message : $('#imagenCte'),
		css : {
		top : ($(window).height() - 400) / 2 + 'px',
		left : ($(window).width() - 1000) / 2 + 'px',
		width : '70%'
		}
		});
		$('.blockOverlay').attr('title', 'Clic para Desbloquear').click($.unblockUI);
	} else {
		window.open(pagina, '_blank');
		$('#imagenCte').hide();
	}
}
