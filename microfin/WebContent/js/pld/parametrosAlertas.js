var esTab = false;
var parametroBean = consultaParametrosSession();
$(document).ready(function() {
	consultaTiposInstrumentos();
	inicializar();
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
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'folioID', 'funcionExito', '');
		}
	});

	$('#formaGenerica').validate({
		rules : {
			tipoPersona : {
				required : true
			},
			nivelRiesgo : {
				required : true
			},
			tipoInstruMonID : {
				required : true
			},
			varPTrans : {
				required : true,
				number : true,
				range : [0, 100]
			},

			varPagos : {
				required : true,
				number : true,
				range : [0, 100]
			},

			varPlazo : {
				required : true,
				number : true
			},

			liquidAnticipad : {
				required : true
			},

			estatus : {
				required : true
			},

			varNumDep : {
				required : true,
				number : true,
				range : [0, 100]
			},

			varNumRet : {
				required : true,
				number : true,
				range : [0, 100]
			},

			porcDiasLiqAnt : {
				required : true,
				number : true,
				range : [0, 100]
			},

			porcLiqAnt : {
				required : true,
				number : true,
				range : [0, 100]
			},

			porcAmoAnt : {
				required : true,
				number : true,
				range : [0, 100]
			}
		},

		messages : {
			tipoPersona : {
				required : 'Especifique el Tipo de Persona.'
			},
			nivelRiesgo : {
				required : 'Especifique el Nivel de Riesgo.'
			},
			tipoInstruMonID : {
				required : 'Especifique Instrumento.'
			},
			varPTrans : {
				required : 'Especifique Cambio.',
				number : 'Sólo Números.',
				range : '% Cambio Mínimo en Perfil<br>Transaccional debe de ser entre 0 y 100'
			},
			varPagos : {
				required : 'Especifique Cambio.',
				number : 'Sólo Números.',
				range : '% Cambio Mínimo en Pagos Exigibles<br>debe de ser entre 0 y 100'
			},

			varPlazo : {
				required : 'Especifique Plazo.',
				number : 'Sólo Números.'
			},

			liquidAnticipad : {
				required : 'Especifique si Permite Liquidación Anticipada.'
			},

			estatus : {
				required : 'Especifique Estado.'
			},
			varNumDep : {
				required : 'Especifique Núm. de Depósitos.',
				number : 'Sólo Números.',
				range : '% Cambio Mínimo en Número de Depositos<br>Extras debe ser entre 0 y 100'
			},

			varNumRet : {
				required : 'Especifique Núm. de Retiros.',
				number : 'Sólo Números.',
				range : '% Cambio Mínimo en Número de Retiros<br>Extras debe ser entre 0 y 100'
			},

			porcDiasLiqAnt : {
				required : 'Especifique Porcentaje de Días Liq. Ant.',
				number : 'Sólo Números.',
				range : '% debe ser entre 0 y 100.'
			},

			porcLiqAnt : {
				required : 'Especifique Porcentaje en Monto Liq. Ant.',
				number : 'Sólo Números.',
				range : '% debe ser entre 0 y 100.'
			},

			porcAmoAnt : {
				required : 'Especifique Porcentaje en Monto Cuota Ant.',
				number : 'Sólo Números.',
				range : '% debe ser entre 0 y 100.'
			}
		}
	});

	$('#modificar').click(function() {
		$('#tipoTransaccion').val(2);
	});
	$('#tipoPersona').change(function() {
		limpiaFormaCompleta('formaGenerica', true, ['tipoPersona']);
	});
	$('#nivelRiesgo').change(function() {
		limpiaFormaCompleta('formaGenerica', true, ['tipoPersona', 'nivelRiesgo']);
		ConsultaExitoFolioVigente();
	});
	$('#folioID').bind('keyup', function(e) {
		if (this.value.length >= 2) {
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "folioID";
			camposLista[1] = "tipoPersona";
			camposLista[2] = "nivelRiesgo";
			parametrosLista[0] = $('#folioID').val();
			parametrosLista[1] = $('#tipoPersona').val();
			parametrosLista[2] = $('#nivelRiesgo').val();
			listaAlfanumerica('folioID', '1', '1', camposLista, parametrosLista, 'listaParametrosAlertas.htm');
		}
	});

	$('#folioID').blur(function() {
		validaParametros(this.id);
	});

	$('input[name="liquidAnticipad"]').change(function (event){
		mostrarElementoPorClase('trLiqAnticipada',$('input[name="liquidAnticipad"]:checked').val());
	});
});

function inicializar() {
	limpiaFormaCompleta('formaGenerica', true, ['tipoPersona', 'nivelRiesgo', 'tipoInstruMonID']);
	deshabilitaBoton('modificar', 'submit');
	$('#folioVigente').val("N");
	$('#fechaVigencia').val(parametroBean.fechaSucursal);
	agregaFormatoControles('formaGenerica');
	mostrarElementoPorClase('parametrizacionXTipoNivel',false);
	$('#tipoPersona').focus();
	deshabilitaContHistorico();
}
function funcionExito() {
	deshabilitaBoton('modificar', 'submit');
	ConsultaExitoFolioVigente();
}
/**
 * Consulta los tipo de instrumentos del catalogo
 */
function consultaTiposInstrumentos() {
	dwr.util.removeAllOptions('tipoInstruMonID');
	tipoInstrumServicio.listaCombo(2, function(tiposInstrum) {
		dwr.util.addOptions('tipoInstruMonID', tiposInstrum, 'tipoInstruMonID', 'descripcion');
	});
}

/**
 * Consulta el folio vigente
 */
function ConsultaExitoFolioVigente() {
	var tipoPersona = $('#tipoPersona').val();
	var nivelRiesgo = $('#nivelRiesgo').val()
	var folioBeanCon = {
	'folioID' : "0",
	'tipoPersona' : $('#tipoPersona').val(),
	'nivelRiesgo' : $('#nivelRiesgo').val()
	};
	if (nivelRiesgo != '' && tipoPersona != '') {
		parametrosAlertasServicio.consulta(3, folioBeanCon, function(parametros) {
			if (parametros != null) {
				dwr.util.setValues(parametros);
				folio = parametros.folioID;
				$('#folioVigente').val("S");
				consultaComboTipoInstrumento(parametros.tipoInstruMonID);
				habilitaBoton('modificar', 'submit');
				habilitaControlesModificar();
				mostrarElementoPorClase('parametrizacionXTipoNivel',true);
			} else {
				$('#folioVigente').val("N");
				inicializar();
			}
		});
	} else {
		inicializar();
	}
}

function validaParametros(control) {
	setTimeout("$('#cajaLista').hide();", 200);

	var folioBeanCon = {
		'folioID' : $('#folioID').asNumber()
	};
	if ($('#folioID').asNumber() > 0) {
		parametrosAlertasServicio.consulta(1, folioBeanCon, function(parametros) {
			if (parametros != null) {
				dwr.util.setValues(parametros);
				if (parametros.estatus == 'B') {
					deshabilitaContHistorico();
				} else {
					consultaComboTipoInstrumento(parametros.tipoInstruMonID);
					habilitaControlesModificar();
					habilitaBoton('modificar', 'submit');
				}
				$('input[name="liquidAnticipad"]').change();
			} else {
				$('#folioVigente').val("N");
				deshabilitaContHistorico();
				mensajeSis("No Existen Parametros Asociados a Este Folio");
			}
		});
	}
}

function habilitaControlesModificar() {
	habilitaBoton('modificar', 'submit');
	habilitaControl('tipoInstruMonID');
	habilitaControl('varPTrans');
	habilitaControl('varPagos');
	habilitaControl('varPlazo');
	habilitaControl('liquidAnticipadS');
	habilitaControl('liquidAnticipadN');
	agregaFormatoControles('formaGenerica');
}

function deshabilitaContHistorico() {
	deshabilitaBoton('modificar', 'submit');
	deshabilitaControl('tipoInstruMonID');
	deshabilitaControl('varPTrans');
	deshabilitaControl('varPagos');
	deshabilitaControl('varPlazo');
	deshabilitaControl('liquidAnticipadS');
	deshabilitaControl('liquidAnticipadN');
	agregaFormatoControles('formaGenerica');
}
//Llena el campo de tipos de instrumentos dependiendo de lo parametrizado
function consultaComboTipoInstrumento(instrumentos) {
	var instru = instrumentos.split(',');
	var tamanio = instru.length;
	for (var i = 0; i < tamanio; i++) {
		var instrumento = instru[i];
		var jqTipoInstrumento = eval("'#tipoInstruMonID option[value=" + instrumento + "]'");
		$(jqTipoInstrumento).attr("selected", "selected");
	}
}
function ayuda(idDivMostrar) {
	$("#ayudaID1").hide();
	$("#ayudaID2").hide();
	$("#ayudaID3").hide();
	$("#ayudaID4").hide();
	$("#ayudaID5").hide();
	$("#ayudaID6").hide();
	$("#ayudaID7").hide();
	$("#ayudaID8").hide();
	$("#" + idDivMostrar).show();
	$.blockUI({
		message : $('#ContenedorAyuda'),
		css : {
			top : ($(window).height() - 400) / 2 + 'px',
			left : ($(window).width() - 400) / 2 + 'px',
			width : '400px'
			}
	});
	$('.blockOverlay').attr('title', 'Clic para Desbloquear').click(function() {
		$.unblockUI();
	});
}