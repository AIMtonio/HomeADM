var esTab = false;
var parametroBean = consultaParametrosSession();
var catTipoConsultaUsuario = {
	'principal' : 1,
};
$(document).ready(function() {
	inicializarPantalla();
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});
	$('#modificar').click(function() {
		$('#tipoTransaccion').val(1);
	});

	$.validator.setDefaults({
		submitHandler : function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'empresaID', "exito", "error");
		}
	});

	$('#formaGenerica').validate({
		rules : {
			empresaID : {
				required : true
			},
			evaluacionMatriz : {
				required : true
			},
			frecuenciaMensual : {
			required : function() {
				return $('#evaluacionMatriz').val() == "S";
			},
			maxlength : 2,
			min : 1
			},
			actPerfilTransOpe : {
				required : true
			},
			frecuenciaMensPerf : {
				required : function() {
					return $('#actPerfilTransOpe').val() == "S";
				},
				maxlength : 2,
				min : 1
			},
			actPerfilTransOpeMas : {
				required : true
			},
			numEvalPerfilTrans : {
				required : function() {
					return $('#actPerfilTransOpeMas').val() == "S";
				},
				maxlength : 2,
				min : 1
			},
			fecVigenDomicilio : {
				required : function() {
					return $('#validarVigDomi').val() == "S";
				}
			},
			tipoDocDomID : {
				required : function() {
					return $('#validarVigDomi').val() == "S";
				}
			}
		},
		messages : {
			empresaID : {
				required : 'El Número de Empresa es Requerido.'
			},
			evaluacionMatriz : {
				required : 'Especifique si requiere Evaluación de la Matriz de Riesgo.'
			},
			frecuenciaMensual : {
			required : 'Especificar la Frecuencia de Evaluación.',
			maxlength : 'Máximo 2 dígitos.',
			min : 'La Frecuencia en Meses debe ser mayor a 0.'
			},
			actPerfilTransOpe : {
				required : 'Especifique si requiere la Actualización del Perfil Transaccional.'
			},
			frecuenciaMensPerf : {
				required : 'Especificar la Frecuencia de la Actualización del Perfil.',
				maxlength : 'Máximo 2 dígitos.',
				min : 'La Frecuencia en Meses debe ser mayor a 0.'
			},
			actPerfilTransOpeMas : {
				required : 'Especifique si requiere la Actualización Masiva del Perfil Transaccional.'
			},
			numEvalPerfilTrans : {
				required : 'Especificar la Frecuencia en Meses en el que ejecutara al año esta evaluación.',
				maxlength : 'Máximo 2 dígitos.',
				min : 'La Frecuencia en Meses debe ser mayor a 0.'
			},
			fecVigenDomicilio : {
				required : 'Especifique el Número de Meses para la Vigencia del Documento.'
			},
			tipoDocDomID : {
				required : 'Especifique el Tipo de Documento a Válidar.'
			}
		}
	});

	$('#empresaID').blur(function() {
		validaEmpresaID(this);
	});
	$('#empresaID').bind('keyup', function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreInstitucion";
		parametrosLista[0] = $('#empresaID').val();
		lista('empresaID', '1', '1', camposLista, parametrosLista, 'listaParametrosSis.htm');
	});

	$('input[name="evaluacionMatriz"]').change(function(event) {
		muestraFrecuenciaMatriz($('input[name=evaluacionMatriz]:checked').val());
	});

	$('input[name="actPerfilTransOpe"]').change(function(event) {
		muestraFrecActualizacionPerf($('input[name=actPerfilTransOpe]:checked').val());
	});
	
	$('input[name="actPerfilTransOpeMas"]').change(function(event) {
		muestraFrecActualizacionPerfMas($('input[name=actPerfilTransOpeMas]:checked').val());
	});

	$('input[name="validarVigDomi"]').change(function(event) {
		muestraValidaDomicilio($('input[name=validarVigDomi]:checked').val());
	});

	$('#frecuenciaMensual').blur(function() {});

	$('#frecuenciaMensPerf').blur(function() {});

	$('#tipoDocDomID').bind('keyup', function(e) {
		lista('tipoDocDomID', '2', '3', 'descripcion', $('#tipoDocDomID').val(), 'ListaTiposDocumentos.htm');
	});

	$('#tipoDocDomID').blur(function() {
			if ($('#tipoDocDomID').asNumber() > 0) {
				consultaDocumento();
			} else {
				$('#tipoDocDomID').val("");
				$('#descripcionDocumento').val("");
			}
	});

});

function inicializarPantalla() {
	$("#empresaID").focus();
	parametros = consultaParametrosSession();
	deshabilitaBoton('modificar', 'submit');
	agregaFormatoControles('formaGenerica');
	$('#tipoDocDomID').val("");
	$('#descripcionDocumento').val("");
}
function exito() {

}
function error() {

}
function validaEmpresaID(control) {
	var numEmpresaID = $('#empresaID').val();
	setTimeout("$('#cajaLista').hide();", 200);
	var tipoCon = 1;
	var ParametrosSisBean = {
		'empresaID' : numEmpresaID
	};
	if (numEmpresaID != '' && !isNaN(numEmpresaID)) {
		if (numEmpresaID == '0') {
			deshabilitaBoton('modificar', 'submit');
			inicializaForma('formaGenerica', 'empresaID');
		} else {
			habilitaBoton('modificar', 'submit');
			parametrosSisServicio.consulta(tipoCon, ParametrosSisBean, function(parametrosSisBean) {
				if (parametrosSisBean != null) {
					dwr.util.setValues(parametrosSisBean);

					if (parametrosSisBean.oficialCumID != 0 && parametrosSisBean.oficialCumID != '') {
						validaUsuario('oficialCumID');
					}

					$('#frecuenciaMensual').val(parametrosSisBean.frecuenciaMensual);
					$('#frecuenciaMensPerf').val(parametrosSisBean.frecuenciaMensPerf);
					$('#actPerfilTransOpeMas').val(parametrosSisBean.actPerfilTransOpeMas);
					$('#numEvalPerfilTrans').val(parametrosSisBean.numEvalPerfilTrans);
					$('#validarVigDomi').val(parametrosSisBean.validarVigDomi);
					$('input[name="evaluacionMatriz"]').change();
					$('input[name="actPerfilTransOpeMas"]').change();
					$('input[name="actPerfilTransOpe"]').change();
					$('input[name="validarVigDomi"]').change();
					if (parametrosSisBean.tipoDocDomID != 0 && parametrosSisBean.tipoDocDomID != '') {
						consultaDocumento()
					}
					agregaFormatoMoneda('formaGenerica');
					habilitaBoton('modificar', 'submit');
				} else {
					limpiaForm($('#formaGenerica'));
					deshabilitaBoton('modificar', 'submit');
					$('#empresaID').focus();
					$('#empresaID').select();
				}
			});
		}//else
	}//if

}//validaEmpresaID
function validaUsuario(control) {
	var jqUsuario = eval("'#" + control + "'");
	var numUsuario = $(jqUsuario).val();

	setTimeout("$('#cajaLista').hide();", 200);
	if (numUsuario != '' && !isNaN(numUsuario)) {
		var usuarioBeanCon = {
			'usuarioID' : numUsuario
		};
		usuarioServicio.consulta(catTipoConsultaUsuario.principal, usuarioBeanCon, function(usuario) {
			if (usuario != null) {
				if (control == 'oficialCumID') {
					$('#nombreOficialCumID').val(usuario.nombreCompleto);
				}
			} else {
				mensajeSis("No Existe el Usuario");
				if (control == 'oficialCumID') {
					$('#oficialCumID').focus();
					$('#oficialCumID').select();
					$('#oficialCumID').val('');
					$('#nombreOficialCumID').val('');
				}
			}
		});

	}
}

function ayudaEvaluacion() {
	$.blockUI({
	message : $('#ayudaEvaluacion'),
	css : {
	top : ($(window).height() - 400) / 2 + 'px',
	left : ($(window).width() - 400) / 2 + 'px',
	width : '400px'
	}
	});
	$('.blockOverlay').attr('title', 'Clic para Desbloquear').click($.unblockUI);
}

function ayudaPerfil() {
	$.blockUI({
		message : $('#ayudaPerfil'),
		css : {
			top : ($(window).height() - 400) / 2 + 'px',
			left : ($(window).width() - 400) / 2 + 'px',
			width : '400px'
		}
	});
	$('.blockOverlay').attr('title', 'Clic para Desbloquear').click($.unblockUI);
}
function ayudaPerfilMas() {
	$.blockUI({
	message : $('#ayudaPerfilMas'),
	css : {
	top : ($(window).height() - 400) / 2 + 'px',
	left : ($(window).width() - 400) / 2 + 'px',
	width : '400px'
	}
	});
	$('.blockOverlay').attr('title', 'Clic para Desbloquear').click($.unblockUI);
}

function ayudaConcidencias() {
	$.blockUI({
	message : $('#ayudaConcidencias'),
	css : {
	top : ($(window).height() - 400) / 2 + 'px',
	left : ($(window).width() - 400) / 2 + 'px',
	width : '400px'
	}
	});
	$('.blockOverlay').attr('title', 'Clic para Desbloquear').click($.unblockUI);
}
function ayudaValidaVig() {
	$.blockUI({
	message : $('#ayudaValVig'),
	css : {
	top : ($(window).height() - 400) / 2 + 'px',
	left : ($(window).width() - 400) / 2 + 'px',
	width : '400px'
	}
	});
	$('.blockOverlay').attr('title', 'Clic para Desbloquear').click($.unblockUI);
}

function muestraFrecuenciaMatriz(muestra) {
	mostrarElementoPorClase('tdEvaluacion', muestra);
	var frecuenciaMensual = $('#frecuenciaMensual').asNumber();
	if (muestra == 'S') {
		if (frecuenciaMensual == 0) {
			$('#frecuenciaMensual').val('');
		}
	} else {
		$('#frecuenciaMensual').val('');
	}
}

function muestraFrecActualizacionPerf(muestra) {
	mostrarElementoPorClase('tdFrecuenciaPerf', muestra);
	var frecuenciaMensual = $('#frecuenciaMensPerf').asNumber();
	if (muestra == 'S') {
		if (frecuenciaMensual == 0) {
			$('#frecuenciaMensPerf').val('');
		}
	} else {
		$('#frecuenciaMensPerf').val('');
	}
}
function muestraFrecActualizacionPerfMas(muestra) {
	mostrarElementoPorClase('tdFrecuenciaPerfMas', muestra);
	var frecuenciaMensual = $('#numEvalPerfilTrans').asNumber();
	if (muestra == 'S') {
		if (frecuenciaMensual == 0) {
			$('#numEvalPerfilTrans').val('');
		}
	} else {
		$('#numEvalPerfilTrans').val('');
	}
}

function muestraValidaDomicilio(muestra) {
	mostrarElementoPorClase('tdVigenciaDomicilio', muestra);
	var meses = $('#fecVigenDomicilio').asNumber();
	if (muestra == 'S') {
		if (meses == 0) {
			$('#fecVigenDomicilio').val('');
		}
	} else {
		$('#fecVigenDomicilio').val('');
	}
}

function consultaDocumento() {
	setTimeout("$('#cajaLista').hide();", 200);
	var tipoConsulta = 1;
	var num = $('#tipoDocDomID').asNumber();
	var bean = {
		'tipoDocumentoID' : num
	};

	if (num>0) {
		tiposDocumentosServicio.consulta(tipoConsulta, bean, {
		async : false,
		callback : function(descripcion) {
			if (descripcion != null) {
				$('#descripcionDocumento').val(descripcion.descripcion);

			} else {
				mensajeSis("No existe el tipo de Documento");
				$('#tipoDocDomID').val("");
				$('#descripcionDocumento').val("");
				$('#tipoDocDomID').focus();
			}
		}
		});
	} else {
		$('#tipoDocDomID').val("");
		$('#descripcionDocumento').val("");
	}
}