var contFilas = 0;
var esTab = false;
var parametroBean = consultaParametrosSession();
var salarioMinimo = parametroBean.salMinDF;
var diasBase = parametroBean.diasBaseInversion;
var diaHabilSiguiente = '1'; // indica dia habil Siguiente
var montoIn = 0;
var numeroCliente=0;
var clitamazula = 28;
var catTipoConsulta = {
	'principal': 1,
	'institucion': 2
};

var catOperacFechas = {
	'sumaDias': 1,
	'restaFechas': 2
};

var catTipoTransaccion = {
	'agrega': 1,
	'modifica': 2
};

//Inicializando campos
$('#inversionID').focus();
limpiarforma();

///--------------------------------------------------------------------------------------------------
$(document).ready(function() {
	deshabilitaBoton('agrega', 'submit');
	ocultarCampos();
	agregaFormatoControles('formaGenerica');

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':text').focus(function() {
	 	esTab = false;
	});

	$.validator.setDefaults({
		submitHandler: function(event) {
			$('#fechaSistema').val(parametroBean.fechaSucursal);
			var continuar = false;
			if ($('#formaGenerica input[name=clasificacionInver]').is(":checked")) {
				if ($('#invValoresOp').is(":checked")) {
					if ($('#formaGenerica input[name=tipoTitulo]').is(":checked")) {
						if ($('#formaGenerica input[name=tipoRestriccion]').is(":checked")) {
							if ($('#formaGenerica input[name=tipoDeuda]').is(":checked")) {
								continuar = true;
							} else {
								$('#tdG').focus();
								mensajeSis('No se ha seleccionado la opción de Tipos de Deuda');
							}
						} else {
							$('#resC').focus();
							mensajeSis('No se ha seleccionado la opción de Restricción');
						}
					} else {
						$('#ttN').focus();
						mensajeSis('No se ha seleccionado la opción de Tipo de Titulo');
					}
				} else {
					if ($('#reportosOp').is(":checked")) {
						if ($('#formaGenerica input[name=tipoDeuda]').is(":checked")) {
							continuar = true;
						} else {
							mensajeSis('No se ha seleccionado la opción de Tipos de Deuda');
							$('#tdG').focus();
						}
					}
				}
			} else {
				$('#invValoresOp').focus();
				mensajeSis('No se ha seleccionado la Clasificación de la Inv.');
			}
			if (continuar && verificarvacios()) {
				// Verificar que haya distribuciones por
				// centro de costos
				var montoInversion = $("#monto").asNumber();
				var montoTo = sumaDCC();
				if (montoTo == montoInversion) {
					crearDetalle();
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'inversionID', 'exito', 'error');
				} else {
					mensajeSis("La Distribución por CC no cumple el Monto Total de la Inversión Bancaria.");
				}
			}
		}
	});

	$('#agrega').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.agrega);
	});

	$('#modificar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.modifica);
	});

	$('#inversionID').blur(function() {
		if (esTab) {
			validaInversion(this.id);
		}

	});

	$('#inversionID').bind('keyup', function(e) {
		var val = $('#inversionID').val();
		if (val === '0') {
			habilitaBoton('agrega', 'submit');
			limpiarforma();
		} else {
			deshabilitaBoton('agrega', 'submit');
		}
	});

	$('#inversionID').bind('keyup', function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();

		camposLista[0] = "nombreInstitucion";
		parametrosLista[0] = $('#inversionID').val();

		lista('inversionID', '1', '1', camposLista, parametrosLista, 'listaInversionesBanc.htm');
	});

	$('#institucionID').bind('keyup', function(e) {
		lista('institucionID', '1', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});

	$('#institucionID').blur(function() {
		if ($('#institucionID').val() != '' && esTab) {
			consultaInstitucion(this.id);
		}
	});

	$('#numCtaInstit').blur(function() {
		if ($('#institucionID').val() == '') {
			mensajeSis('Especifique No de Institución');
			$('#institucionID').focus();
		} else if ($('#numCtaInstit').val() != '' && !isNaN($('#numCtaInstit').val()) && esTab) {
			consultaCuentaAho();
		}
	});

	$('#numCtaInstit').bind('keyup', function(e) {
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "institucionID";
		parametrosLista[0] = $('#institucionID').val();
		camposLista[1] = "cuentaAhoID";
		parametrosLista[1] = $('#numCtaInstit').val();

		lista('numCtaInstit', '2', '2', camposLista, parametrosLista, 'tesoCargaMovLista.htm');
	});

	$('#tasa').blur(function() {
		deshabilitaBoton('agregarDCC', 'submit');
		calculaRendimiento();
		if ($('#tasa').val() != '' && $('#tasaISR').val() != '' && $('#monto').val() != '' && $('#plazo').val() != '') {
			if (parseFloat(this.value) >= parseFloat($('#tasaISR').val())) {
				recalculaRendimientoCC();
			} else {
				this.value = '';
				this.focus();
				mensajeSis('La Tasa Bruta No Puede Ser Menor a la Tasa ISR.');
			}
		}
	});

	$('#tasaISR').blur(function() {
		deshabilitaBoton('agregarDCC', 'submit');
		calculaRendimiento();
		if ($('#tasa').val() != '' && $('#tasaISR').val() != '' && $('#monto').val() != '' && $('#plazo').val() != '') {
			if (parseFloat(this.value) <= parseFloat($('#tasa').val())) {
				recalculaRendimientoCC();
			} else {
				this.value = '';
				this.focus();
				mensajeSis('La Tasa ISR No Puede Ser Mayor a la Tasa Bruta.');
			}
		}
	});

	$('#monto').blur(function() {
		deshabilitaBoton('agregarDCC', 'submit');
		if($('#monto').val()!='') {
			if ($('#monto').asNumber() > $('#totalCuenta').asNumber()) {
				mensajeSis("Monto de Inversión es mayor al Saldo");
				$('#monto').val("");
				$('#monto').focus();
			} else {
				var montoInversion = $("#monto").asNumber();
				var montoTo = sumaDCC();

				if (montoTo > montoInversion)
					mensajeSis("El Total de la Inversión es Menor al monto Total por Distribución por CC, reasigne los Montos a cada Centro de Costo.")
					//eliminarTodasDistribucionCC();
					calculaRendimiento();
				if ($('#tasa').val() != '' && $('#tasaISR').val() != '' && $('#monto').val() != '' && $('#plazo').val() != '') {
					recalculaRendimientoCC();
				}
			}
		} else {
			calculaRendimiento();
		}
	});

    $('#fechaInicio').change(function() {
        $('#fechaInicio').focus();
        var Xfecha = $('#fechaInicio').val();
        if (esFechaValida(Xfecha)) {
            if (Xfecha > parametroBean.fechaSucursal) {
                mensajeSis("La Fecha de Inicio es Mayor a la Fecha Actual."); // IALDANA T_13375 Se metió la validación para que las inversiones bancarias no inicien con fecha posterior al sistema.
                $('#fechaInicio').val(parametroBean.fechaSucursal); // IALDANA T_13375 
            }
            if (Xfecha == '') {
                $('#fechaInicio').val(parametroBean.fechaSucursal);
            }
            var Yfecha = $('#fechaVencimiento').val();
            if (Yfecha != '') {
                if (mayor(Xfecha, Yfecha)) {
                    mensajeSis("La Fecha de Inicio es mayor a la Fecha de Vencimiento.");
                    $('#fechaInicio').val(parametroBean.fechaSucursal);
                    $('#fechaInicio').focus();
                    $('#plazo').val("");
                }
            }
        } else {
            fechaHabilInicio($('#fechaInicio').val());
            calculaRendimiento();
            if ($('#fechaInicio').val() != '' && $('#tasa').val() != '' && $('#tasaISR').val() != '' && $('#monto').val() != '' && $('#plazo').val() != '') {
                fechaHabil($('#fechaVencimiento').val(), 'plazo');
                $('#fechaInicio').focus();
                recalculaRendimientoCC();
            }
        }
    });

	$('#fechaVencimiento').change(function() {
		$('#fechaVencimiento').focus();
		if ($('#fechaInicio').val() != '') {
			if ($('#fechaVencimiento').val() != '') {
				var fechax = parametroBean.fechaSucursal;
				if (esFechaValida($('#fechaVencimiento').val())) {
					/*if ($('#fechaVencimiento').val() < fechax) {
						mensajeSis('La Fecha de Vencimiento no puede ser Menor a la fecha Actual.');
						$('#fechaVencimiento').val("");
						$('#fechaVencimiento').focus();
						$('#plazo').val("");
					} else {*/
						fechaHabil($('#fechaVencimiento').val(), 'plazo');
						calculaRendimiento();
						recalculaRendimientoCC();
					//}
				} else {
					$('#fechaVencimiento').focus();
					$('#fechaVencimiento').val('');
					$('#plazo').val('');
				}
			}
		} else {
			mensajeSis("Error al Consultar la Fecha de la Sucursal.");
			$('#inversionID').focus();
			$('#inversionID').select();
		}
	});



	$('#fechaInicio').blur(function() {
		//fechaHabilInicio($('#fechaInicio').val());
		if($('#fechaVencimiento').val() != '')
			fechaHabil($('#fechaVencimiento').val(), 'plazo');
		calculaRendimiento();
		if ($('#tasa').val() != '' && $('#tasaISR').val() != '' && $('#monto').val() != '' && $('#plazo').val() != '') {

			recalculaRendimientoCC();
		}
	});

	$('#fechaVencimiento').blur(function() {
		if($('#fechaInicio').val() != '')
			fechaHabil($('#fechaVencimiento').val(), 'plazo');
		calculaRendimiento();
		if ($('#tasa').val() != '' && $('#tasaISR').val() != '' && $('#monto').val() != '' && $('#plazo').val() != '') {
			recalculaRendimientoCC();
		}
	});
	/* + Consulta la fecha de vencimiento + */
	$('#plazo').blur(function() {
		if ($('#fechaInicio').val() != '') {
			if ($('#plazo').val() != 0) {
				var opeFechaBean = {
					'primerFecha': $('#fechaInicio').val(),
					'numeroDias': $('#plazo').val()
				};
				operacionesFechasServicio.realizaOperacion(opeFechaBean, catOperacFechas.sumaDias, function(data) {
					if (data != null) {
						$('#fechaVencimiento').val(data.fechaResultado);
						fechaHabil($('#fechaVencimiento').val(), 'plazo');
					} else {
						mensajeSis("A ocurrido un error Interno al Consultar Fechas...");
					}
				});
			}
		} else {
			mensajeSis("Error al Consultar la Fecha de la Sucursal");
			$('#inversionID').focus();
			$('#inversionID').select();
		}
	});

	$('input[name=clasificacionInver]').change(function() {
		if ($('#invValoresOp').is(":checked")) {
			$('#pregTipoTitulo').show();
			$('#opTipoTitulo').show();
			$('#pregRestriccion').show();
			$('#opRestriccion').show();
			$('#pregTipoDeuda').show();
			$('#opTipoDeuda').show();
		} else if ($('#reportosOp').is(":checked")) {
			ocultarCampos();
			$('#pregTipoDeuda').show();
			$('#opTipoDeuda').show();
		}
	});

	// Funciones internas
	function validaInversion(idControl) {

		var jqFolio = eval("'#" + idControl + "'");
		var numFolio = $(jqFolio).val();
		eliminarTodasDistribucionCC();
		// Limpiar forma
		$('#formaGenerica input[name=clasificacionInver]').attr('checked', false);
		$('#formaGenerica input[name=tipoTitulo]').attr('checked', false);
		$('#formaGenerica input[name=tipoRestriccion]').attr('checked', false);
		$('#formaGenerica input[name=tipoDeuda]').attr('checked', false);

		if (numFolio == 0 && numFolio != '' ) {
			ClienteEspeficio()
			if(numeroCliente == clitamazula){
				$('#tasaISR').val('0.00');}
			else{
				$('#tasaISR').val('0.60');
			}
			$('#tasaISR').formatCurrency({
				positiveFormat: '%n',
				roundToDecimalPlace: 4
			});
			$('#diasBase').val(diasBase);
			$('#fechaInicio').val(parametroBean.fechaSucursal);
			consultaDetalle();
			habilitaBoton('agrega', 'submit');

		} else if (numFolio != '' && !isNaN(numFolio)) {
			var tipoConsulta = 1;
			var tasasInversionBean = {
				'inversionID': $('#inversionID').val()
			};

			invBancariaServicioScript.consultaInversionBancaria(tipoConsulta, tasasInversionBean, function(inversionBancaria) {
				if (inversionBancaria != null) {
					consultaDetalle();
					dwr.util.setValues(inversionBancaria);

					$('#monto').formatCurrency({
						positiveFormat: '%n',
						roundToDecimalPlace: 2
					});
					$('#tasaNeta').formatCurrency({
						positiveFormat: '%n',
						roundToDecimalPlace: 4
					});
					$('#interesGenerado').formatCurrency({
						positiveFormat: '%n',
						roundToDecimalPlace: 4
					});
					$('#interesRetener').formatCurrency({
						positiveFormat: '%n',
						roundToDecimalPlace: 4
					});
					$('#interesRecibir').formatCurrency({
						positiveFormat: '%n',
						roundToDecimalPlace: 4
					});
					$('#totalRecibir').formatCurrency({
						positiveFormat: '%n',
						roundToDecimalPlace: 2
					});

					var Clafi = inversionBancaria.clasificacionInver;
					if (Clafi == 'I') {
						$('#pregTipoTitulo').show();
						$('#opTipoTitulo').show();
						$('#pregRestriccion').show();
						$('#opRestriccion').show();
						$('#pregTipoDeuda').show();
						$('#opTipoDeuda').show();
					} else if (Clafi == 'R') {
						ocultarCampos();
						var tipoDeuda = inversionBancaria.tipoDeuda;
						$('#pregTipoDeuda').show();
						$('#opTipoDeuda').show();
					} else {
						ocultarCampos();
					}

					consultaInstitucion("institucionID");
					consultaCuentaAho();
				} else {
					mensajeSis("Inversión no encontrada");
					inicializaForma('formaGenerica', idControl);
					limpiarforma();
					$('#inversionID').focus()
				}
			});
			deshabilitaBoton('agrega', 'submit');
		}

	}

	function calculaRendimiento() {
		deshabilitaBoton('agregarDCC', 'submit');
		if($('#tasa').val()!='' && $('#tasaISR').val()!='' && $('#monto').asNumber() > 0 && $('#plazo').asNumber()>0 && $('#diasBase').asNumber()>0){
			var beanInversion = creaBeanInversion();
			invBancariaServicioScript.calculaRendimiento(beanInversion,function(rendimiento) {
					if (rendimiento != null) {
						$('#tasaNeta').val(rendimiento.tasaNeta);
						$('#interesGenerado').val(rendimiento.interesGenerado);
						$('#interesRetener').val(rendimiento.interesRetener);

						$('#interesRecibir').val(rendimiento.interesGenerado-rendimiento.interesRetener);
						$('#totalRecibir').val($('#monto').asNumber()+$('#interesRecibir').asNumber());

						$('#tasaNeta').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 4
						});
						$('#interesGenerado').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 4
						});
						$('#interesRetener').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 4
						});
						$('#interesRecibir').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 4
						});
						$('#totalRecibir').formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});



						var montoInversion = $("#monto").asNumber();
						var montoTo = sumaDCC();
						if (montoInversion <= montoTo)
							deshabilitaBoton('agregarDCC', 'submit');
						else
							habilitaBoton('agregarDCC', 'submit');
					}
				});
		} else {
			$('#interesGenerado').val('');
			$('#tasaNeta').val('');
			$('#interesRetener').val('');
			$('#interesRecibir').val('');
			$('#totalRecibir').val('');
		}

	}

	function consultaCuentaAho() {
		var numInstituto = $('#institucionID').val();
		var numCtaInstit = $('#numCtaInstit').val();
		var tipoConsulta = 6;
		var DispersionBeanCta = {
			'institucionID': numInstituto,
			'cuentaAhorro': numCtaInstit
		};
		if (numCtaInstit != '' && !isNaN(numCtaInstit)) {
			operDispersionServicio.consulta(tipoConsulta, DispersionBeanCta, function(data) {
				if (data != null) {
					$('#numCtaInstit').val(data.numCtaInstit);
					$('#totalCuenta').val(data.saldoCuenta);
					$('#monedaID').val(data.tipoMoneda);
					$('#totalCuenta').formatCurrency({
						positiveFormat: '%n',
						roundToDecimalPlace: 2
					});
					// $('#tasaISR').val(parametroBean.tasaISR);
					$('#tasaISR').formatCurrency({
						positiveFormat: '%n',
						roundToDecimalPlace: 4
					});
				} else {
					mensajeSis("No Existe el Número de Cuenta.");
					$('#numCtaInstit').focus();
					$('#numCtaInstit').val('');
					$('#totalCuenta').val('');
				}
			});
		}
	}

	function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();

		var InstitutoBeanCon = {
			'institucionID': numInstituto
		};

		if (numInstituto != '' && !isNaN(numInstituto)) {
			institucionesServicio.consultaInstitucion(catTipoConsulta.institucion, InstitutoBeanCon, function(instituto) {
				if (instituto != null) {
					$('#nombreCompleto').val(instituto.nombre);
				} else {
					mensajeSis("No existe la Institución");
					$('#institucionID').focus()
					$('#institucionID').val('')
					$('#nombreCompleto').val('')
				}
			});
		}
	}


	function fechaHabil(fechaPosible, idControl) {
		var diaFestivoBean = {
			'fecha': fechaPosible,
			'numeroDias': 0,
			'salidaPantalla': 'S'
		};
		if($('#fechaVencimiento').val()!='' && $('#fechaInicio').val()!='') {
			diaFestivoServicio.calculaDiaFestivo(1, diaFestivoBean, function(data) {
				if (data != null) {
					//$('#fechaVencimiento').val(data.fecha);
					var opeFechaBean = {
						'primerFecha': $('#fechaVencimiento').val(),
						'segundaFecha': $('#fechaInicio').val()
					};
					operacionesFechasServicio.realizaOperacion(opeFechaBean, catOperacFechas.restaFechas, function(data) {
						if (data != null) {
							$('#plazo').val(data.diasEntreFechas);
						} else {
							mensajeSis("A ocurrido un error Interno al Consultar Fechas.");
						}
					});
				} else {
					mensajeSis("A ocurrido un error al calcular Dias Festivos.");
				}
			});
		}
	}

	/**
	 * Establece la fecha habil de inicio
	 */
	function fechaHabilInicio(fechaPosible) {

		var diaFestivoBean = {
			'fecha': fechaPosible,
			'numeroDias': 0,
			'salidaPantalla': 'S'
		};

		diaFestivoServicio.calculaDiaFestivo(1, diaFestivoBean, function(data) {
			if (data != null) {
				$('#fechaInicio').val(data.fecha);
			} else {
				mensajeSis("A ocurrido un error al calcular Dias Festivos.");
			}
		});
	}

	/**
	 * Crea el bean de la inversion
	 */
	function creaBeanInversion() {
		var tasasInversionBean = {
			'tasa': $('#tasa').val(),
			'tasaISR': $('#tasaISR').val(),
			'monto': $('#monto').asNumber(),
			'plazo': $('#plazo').asNumber(),
			'diasBase': $('#diasBase').asNumber(),
			'salarioMinimo': salarioMinimo,
			'numeroSalarios': 5,
			'montoBaseInversion':$('#monto').asNumber()
		};
		return tasasInversionBean;
	}

	/**
	 * Validacion d ela forma
	 */
	$('#formaGenerica').validate({
		rules: {
			institucionID: 'required',
			numCtaInstit: 'required',
			tipoInversion: 'required',
			diasBase:{
				required: true,
				maxlength: 3,
				number: true
			},
			monto: {
				required: true,
				number: true
			},
			tasa: {
				required: true,
				numeroPositivo: true
			},
			tasaISR: {
				required: true,
				numeroPositivo: true
			},
			plazo: {
				required: true,
				numeroPositivo: true
			},
			fechaInicio: 'required',
			fechaVencimiento: 'required',
			montoD: {
				required: true,
				number: true
			}
		},

		messages: {
			institucionID: 'Especifique el n&uacute;mero de Instituci&oacute;n',
			numCtaInstit: 'Especifique el n&uacute;mero de cuenta',
			tipoInversion: 'Especifique la referencia de la inversi&oacute;n',
			diasBase:{
				required: 'Especifique el Año Bancario.',
				minlength: 'Al menos 3 digitos.',
				number: 'Solo Números.'
			},
			monto: {
				required: 'Especifique la cantidad a invertir',
				number: 'Sólo Números'
			},
			tasa: {
				required:'Especifique la tasa bruta',
				numeroPositivo: 'Sólo Números'
			},
			tasaISR: {
				required: 'Especifique la tasa ISR',
				numeroPositivo: 'Sólo Números'
			},
			plazo: {
				required: 'Especifique el plazo de la inversión',
				numeroPositivo: 'Sólo Números'
			},
			fechaInicio: 'Especifique la fecha de inicio',
			fechaVencimiento: 'Especifique la fecha de vencimiento',
			montoD: {
				required: 'Especifique la cantidad a invertir',
				number: 'Sólo Números'
			}
		}
	});

});

/**
 * Recalcula el rendimiento de cada distribucion
 */
function calcularRendimientoDISC(){
	$("#distribucionCC tr").each(function(index) {
		if (index > 0) {
			calculaDistribucionCC(index);
		}
	});
}

/**
 * Método para ocultar las preguntas de Condiciones
 */
function ocultarCampos() {
	$('#pregTipoTitulo').hide();
	$('#opTipoTitulo').hide();
	$('#pregRestriccion').hide();
	$('#opRestriccion').hide();
	$('#pregTipoDeuda').hide();
	$('#opTipoDeuda').hide();
}

/**
 * Método para agregar una nueva Distribución por Centro de Costos
 */
function agregarDistribucionCC() {
	var isrCal = $("#tasaISR").val();
	var aBancario = $("#diasBase").val();

	if (isrCal === undefined || isrCal == null || isrCal.length <= 0) {
		mensajeSis("Defina la Tasa ISR");
	} else if (aBancario === undefined || aBancario == null || aBancario.length <= 0) {
		mensajeSis("Defina el año Bancario");
	} else if ($('#distribucionCC tr').length == 1 || ValidarTabla()) {
		// Validar que no se este en el monto total de la inversion o que se
		// haya superado
		var montoInversion = $("#monto").asNumber();
		var montoTo = sumaDCC();

		if (montoTo < montoInversion) {
			var trs = $("#distribucionCC tr").length;
			// var idNuevo="idtr"+contFilas;
			contFilas = contFilas + 1;
			var nuevaFila = "<tr id=\"tr" + contFilas + "\">" +
			"<td ><input id=\"ccD" + contFilas + "\"				name=\"ccD\" 				type=\"text\"	value=\"\"		onblur=\"consultaCC(" + contFilas + ");\" 				onkeyup=\"consultaCCKeyUP(" + contFilas + ");\" size='10'></td>" +
			"<td ><input id=\"ccnameD" + contFilas + "\"			name=\"ccnameD\" 			type=\"text\"	value=\"\" size='60' disabled=\"true\"></td>" +
			"<td ><input id=\"montoD" + contFilas + "\" 			name=\"montoD\" 			type=\"text\"	value=\"\"		onblur=\"calculaDistribucionCC(" + contFilas + ");\" 	onkeyup=\"montoKeyup(" + contFilas + ");\" esMoneda=\"true\" style=\"text-align: right\"></td>" +
			"<td ><input id=\"interesGD" + contFilas + "\" 			name=\"interesGD\"			type=\"text\"	value=\"\"	esTasa=\"true\"	disabled=\"true\" style=\"text-align: right\"></td>" +
			"<td nowrap=\"nowrap\" ><input id=\"impuestoRetenerD" + contFilas + "\" 	name=\"impuestoRetenerD\" 	esTasa=\"true\" type=\"text\"	value=\"\" 		disabled=\"true\" style=\"text-align: right\"></td>" +
			"<td ><input id=\"totalRecibir" + contFilas + "\" 		name=\"totalRecibirD\"		type=\"text\"	value=\"\"		disabled=\"true\" esMoneda=\"true\" style=\"text-align: right\"></td>" +
			"<td nowrap=\"nowrap\">" +
			"<input type=\"button\" name=\"elimina\" value=\"\" class=\"btnElimina\" onclick=\"eliminarDistribucionCC('tr" + contFilas + "')\"/>" + "<input type=\"button\" name=\"agrega\" value=\"\" class=\"btnAgrega\" onclick=\"agregarDistribucionCC()\"/>" +
			"</td>" + "</tr>";
			$("#distribucionCC").append(nuevaFila);
			$("#ccD" + contFilas).focus();
		}
		agregaFormatoControles('gridDetalle');
	} else {
		mensajeSis("Hay campos en la Tabla de Distribución por CC que estan vacíos.");
	}
}
/**
 * Elimina la distribucion seleccionada
 * @param id
 */
function eliminarDistribucionCC(id) {
	var montoCC = $("#montoD" + id).asNumber();
	montoIn = montoIn - montoCC;
	$("#" + id).remove();
	var montoInversion = $("#monto").asNumber();
	var montoCC = $("#montoD" + id).asNumber();
	var montoTo = sumaDCC();
	if (montoTo <= montoInversion) {
		// Si el monto actual es igual al monto de la inversion deshabilitar el
		// boton de agregar
		if (montoTo == montoInversion)
			deshabilitaBoton('agregarDCC', 'submit');
		else
			habilitaBoton('agregarDCC', 'submit');
	}
}

/**
 * Elimina todas las distribuciones agregadas
 */
function eliminarTodasDistribucionCC() {
	$("#distribucionCC").find("tr:gt(0)").remove();
	montoIn = 0;
}

/**
 * Método que calcula el rendimiento de la inversión por centro de costos
 * @param id
 */
function calculaDistribucionCC(id) {

	var montoInversion = $("#monto").asNumber();
	var montoCC = $("#montoD" + id).asNumber();
	var montoTo = sumaDCC();
	if (montoTo <= montoInversion) {
		// Si el monto actual es igual al monto de la inversion deshabilitar el
		// boton de agregar
		if (montoTo == montoInversion)
			deshabilitaBoton('agregarDCC', 'submit');
		if (montoInversion >= montoCC) {
			var tasasInversionBean = {
				'tasa': $('#tasa').val(),
				'tasaISR': $('#tasaISR').val(),
				'monto': $("#montoD" + id).asNumber(),
				'plazo': $('#plazo').asNumber(),
				'diasBase': $('#diasBase').val(),
				'salarioMinimo': salarioMinimo,
				'numeroSalarios': 5,
				'montoBaseInversion':$('#monto').asNumber()
			};

			invBancariaServicioScript.calculaRendimiento(tasasInversionBean, function(rendimiento) {
				if (rendimiento != null) {
					$('#interesGD' + id).val(rendimiento.interesGenerado);
					$('#impuestoRetenerD' + id).val(rendimiento.interesRetener);
					$('#totalRecibir' + id).val(rendimiento.totalRecibir);

					if (montoTo == montoInversion){
						var totalInteresGD = sumaInteresGD();
						var totalImpuestoRetenerD = sumaImpuestoRetenerD();

						var interesGenera =  $('#interesGenerado').asNumber();
						var interesRetener = $('#interesRetener').asNumber();

						var diferenciaD	= 0;
						var diferenciaGD = 0;

						if(totalInteresGD > interesGenera){

							 diferenciaGD = parseFloat(totalInteresGD - interesGenera).toFixed(4);
							if(parseFloat($('#interesGD' + id).asNumber() - parseFloat(diferenciaGD)).toFixed(4)<=0){
								$('#interesGD' + id).val(0);
							}else{

								$('#interesGD' + id).val(parseFloat($('#interesGD' + id).asNumber() - parseFloat(diferenciaGD)).toFixed(4));
							}

						}else if (totalInteresGD < interesGenera){

							 diferenciaGD = parseFloat(interesGenera - totalInteresGD  ).toFixed(4);

							$('#interesGD' + id).val(parseFloat($('#interesGD' + id).asNumber() + parseFloat(diferenciaGD)).toFixed(4));

						}


					if(totalImpuestoRetenerD > interesRetener){

						 diferenciaD = parseFloat(totalImpuestoRetenerD - interesRetener).toFixed(4);
						if((parseFloat($('#impuestoRetenerD'+id).asNumber()-diferenciaD)).toFixed(4)<=0){
							$('#impuestoRetenerD'+id).val(0);
						}else{
							$('#impuestoRetenerD'+id).val(parseFloat($('#impuestoRetenerD'+id).asNumber()-parseFloat(diferenciaD)).toFixed(4));
						}

					}else if(totalImpuestoRetenerD < interesRetener){
						 diferenciaD = parseFloat(interesRetener - totalImpuestoRetenerD).toFixed(4);

						$('#impuestoRetenerD'+id).val(parseFloat($('#impuestoRetenerD'+id).asNumber()+parseFloat(diferenciaD)).toFixed(4));
					}

						$('#totalRecibir' + id).val($('#montoD'+id).asNumber()+$('#interesGD'+id).asNumber()-$('#impuestoRetenerD'+id).asNumber());
						validarGridTotalRecibir();

						$('#interesGD' + id).formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 4
						});
						$('#impuestoRetenerD' + id).formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 4
						});
						$('#totalRecibir' +id).formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
					}

					$('#interesGD' + id).formatCurrency({
						positiveFormat: '%n',
						roundToDecimalPlace: 4
					});
					$('#impuestoRetenerD' + id).formatCurrency({
						positiveFormat: '%n',
						roundToDecimalPlace: 4
					});
					$('#totalRecibir' + id).formatCurrency({
						positiveFormat: '%n',
						roundToDecimalPlace: 2
					});
					if($('#interesGD' + id).asNumber() <= '0.00'){
						deshabilitaBoton('agrega','submit');
						mensajeSis('El monto ingresado no puede ser prorrateado entre los centros de costo actuales');
					}else{
						habilitaBoton('agrega','submit');
					}
				}
			});
		} else {
			mensajeSis("El Monto Por Distribución Por CC No Puede Ser Mayor Al Monto de la Inversión.");
			var idAC = 'montoD' + id;
			var ultimoIDCC = $('#distribucionCC').find("input[name=montoD]").last(':visible').attr('id');
			var montoInversion = $("#monto").asNumber();
			var montoCC = $("#montoD" + id).asNumber();
			var montoTo = sumaDCC();
			if (idAC == ultimoIDCC) {
				var resttotal = montoInversion - (montoTo - montoCC);
				if (resttotal <= montoInversion)
					$('#montoD' + id).val(resttotal);
				$('#montoD' + id).focus();
			}
		}
	} else {
		mensajeSis("Has superado el Monto de la Inversión, Cambiar el Monto de la Distribución por CC.");
		var idAC = 'montoD' + id;
		var ultimoIDCC = $('#distribucionCC').find("input[name=montoD]").last(':visible').attr('id');
		if (idAC == ultimoIDCC) {
			var resttotal = montoInversion - (montoTo - montoCC);
			if (resttotal <= montoInversion)
				$('#montoD' + id).val(resttotal);
			$('#montoD' + id).focus();
		}
	}
}

/**
 * Consulta de CC evento blur
 * @param id
 */
function consultaCC(id) {
	var jqCentro = eval("'#ccD" + id + "'");
	var numCentro = $(jqCentro).val();
	setTimeout("$('#cajaLista').hide();", 200);
	var catTipoConsultaCentroCostos = {
		'foranea': 2,
	};
	var centroBeanCon = {
		'centroCostoID': $('#ccD' + id).val()
	};
	//Verificar que no este el centro de costo repetido
	if(noSeRepiteCC(numCentro)){
		if (numCentro != '' && !isNaN(numCentro)) {
			centroServicio.consulta(catTipoConsultaCentroCostos.foranea, centroBeanCon, function(centro) {
				if (centro != null) {
					$('#ccnameD' + id).val(centro.descripcion);
				} else {
					mensajeSis("No Existe el Centro de Costos");
					//$('#ccD' + id).focus();
					$('#ccD' + id).val('');
					$('#ccnameD' + id).val("");
				}
			});
		} else {
			//$('#ccD' + id).focus();
			$('#ccD' + id).val('');
			$('#ccnameD' + id).val('');
		}
	}
	else
		{
			mensajeSis("Ya se Encuentra Asignado el Centro de Costo");
			//$('#ccD' + id).focus();
			$('#ccD' + id).val('');
			$('#ccnameD' + id).val('');
		}
}


/**
 * Consulta de Centro de costos al evento key up
 */
function consultaCCKeyUP(id) {
	var jq = eval("'#ccD" + id + "'");
	$(jq).bind('keyup', function(e) {
		var jqControl = eval("'#" + this.id + "'");
		var num = $(jqControl).val();
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "descripcion";
		parametrosLista[0] = num;

		lista(this.id, '2', '1', camposLista, parametrosLista, 'listaCentroCostos.htm');
	});
}

/**
 * Validacion de cuando em monto de CC supere el monto de la inversión inhabilite los botones de agregar
 */
function montoKeyup(id) {
	var jq = eval("'#montoD" + id + "'");

	$(jq).bind('keyup', function(e) {
		var jqControl = eval("'#" + this.id + "'");
		var num = $(jqControl).val();
		var montoInversion = $("#monto").asNumber();
		var montoCC = $("#montoD" + id).asNumber();
		var montoTo = sumaDCC();
		if (montoTo <= montoInversion) {
			// Si el monto actual es igual al monto de la inversion deshabilitar
			// el boton de agregar
			if (montoTo == montoInversion) {
				deshabilitaBoton('agregarDCC', 'submit');
			} else
				habilitaBoton('agregarDCC', 'submit');
		} else {
			deshabilitaBoton('agregarDCC', 'submit');
		}
	});
}

/**
 * Verifica que no se repita el centro de costo en la distribución bancaria
 * @param numeroCC
 * @returns
 */
function noSeRepiteCC(numeroCC) {
	var noserepite = 0;
	$("#distribucionCC tr").each(function(index) {
		if (index > 0) {
			var ccDT = $(this).find("input[name=ccD]").val();
			if (ccDT!=undefined && ccDT!='' && ccDT == numeroCC) {
				noserepite ++;
			}
		}
	});
	return noserepite>1?false:true;
}

/**
 * Método que suma todos los montos del detalle de la Distribucción de CC
 * @returns {Number}
 */
function sumaDCC() {
	montoIn = 0;
	$("#distribucionCC tr").each(function(index) {
		if (index > 0) {
			var montoTC = $(this).find("input[name=montoD]").asNumber();
			if (montoTC > 0) {
				montoIn = montoIn + montoTC;
			}
		}
	});
	return montoIn;
}

/**
 * Validando que todos los montos y id de cc tengan valores
 * @returns {Boolean}
 */
function ValidarTabla() {
	var i = 0;
	var EsCorrecta = true;
	$("#distribucionCC tr").each(function(index) {
		if (index > 0) {
			var montoTC = $(this).find("input[name=montoD]").val();
			var ccDT = $(this).find("input[name=ccD]").val();
			if (montoTC === undefined || montoTC == null || montoTC.length <= 0) {
				EsCorrecta = false;
				return false;
			} else if (ccDT === undefined || ccDT == null || ccDT.length <= 0) {
				EsCorrecta = false;
				return false;
			}
		}
	});
	return EsCorrecta;
}

/**
 * Método que se usa cuando la transacción fue exitosa
 */
function exito() {
	var inversionVal = $('#inversionID').val();
	limpiarforma();
	$('#diasBase').val('');
	$('#fechaInicio').val('');
	$('#tasaISR').val('');
	deshabilitaBoton('agrega', 'submit');
	/*$('#formaGenerica input[type=text]').each(function() {
		$(this).val('');
	});*/
	//$('#inversionID').focus();
	//$('#inversionID').val(inversionVal);
}

function error() {
	quitaFormatoControles('formaGenerica');
	agregaFormatoControles('formaGenerica');
}

/**
 * valida si fecha > fecha2: true else false
 * @param fecha
 * @param fecha2
 * @returns {Boolean}
 */
function mayor(fecha, fecha2) {
	// 0|1|2|3|4|5|6|7|8|9|
	// 2 0 1 2 / 1 1 / 2 0
	var xMes = fecha.substring(5, 7);
	var xDia = fecha.substring(8, 10);
	var xAnio = fecha.substring(0, 4);

	var yMes = fecha2.substring(5, 7);
	var yDia = fecha2.substring(8, 10);
	var yAnio = fecha2.substring(0, 4);

	if (xAnio > yAnio) {
		return true;
	} else {
		if (xAnio == yAnio) {
			if (xMes > yMes) {
				return true;
			}
			if (xMes == yMes) {
				if (xDia > yDia) {
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		} else {
			return false;
		}
	}
}

/**
 * funcion valida fecha formato (yyyy-MM-dd)
 * @param fecha
 * @returns {Boolean}
 */
function esFechaValida(fecha) {

	if (fecha != undefined && fecha.value != "") {
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)) {
			mensajeSis("Formato de Fecha no Válido (aaaa-mm-dd)");
			return false;
		}

		var mes = fecha.substring(5, 7) * 1;
		var dia = fecha.substring(8, 10) * 1;
		var anio = fecha.substring(0, 4) * 1;

		switch (mes) {
			case 1:
			case 3:
			case 5:
			case 7:
			case 8:
			case 10:
			case 12:
				numDias = 31;
				break;
			case 4:
			case 6:
			case 9:
			case 11:
				numDias = 30;
				break;
			case 2:
				if (comprobarSiBisisesto(anio)) {
					numDias = 29
				} else {
					numDias = 28
				}
				break;
			default:
				mensajeSis("Fecha introducida errónea.");
				return false;
		}
		if (dia > numDias || dia == 0) {
			mensajeSis("Fecha introducida errónea.");
			return false;
		}
		return true;
	}
}

/**
 * Comprueba si el año es bisiesto
 * @param anio
 * @returns {Boolean}
 */
function comprobarSiBisisesto(anio) {
	if ((anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
		return true;
	} else {
		return false;
	}
}

/**
 * Método para llenar el detalle de la distribución de centro de costos
 */
function consultaDetalle() {
	var params = {};
	params['tipoLista'] = 1;
	params['inversionID'] = $('#inversionID').val();

	$.post("gridDetalleInvBancaria.htm", params, function(data) {
		if (data.length > 0) {
			$('#gridDetalle').html(data);
			$('#gridDetalle').show();
			// sumaCargosAbonos();
			agregaFormatoControles('gridDetalle');
		} else {
			$('#gridDetalle').html("");
			$('#gridDetalle').show();
		}
	});
}

/**
 * Método que es llamado cuando se va enviar la forma para enviar el detalle de la distribucción de centro de costos
 */
function crearDetalle() {
	if (verificarvacios()) {
		quitaFormatoControles('gridDetalle');
		$('#detalle').val("");
		$("#distribucionCC tr").each(function(index) {
			if (index > 0) {
				var centroCostoTR = $(this).find("input[name=ccD]").val();
				var montoTCTR = $(this).find("input[name=montoD]").val();
				var interesGDTR = $(this).find("input[name=interesGD]").val().replace(",","");
				var impuestoRetenerDTR = $(this).find("input[name=impuestoRetenerD]").val().replace(",","");
				var totalRecibirDTR = $(this).find("input[name=totalRecibirD]").val();
				if (index == 1) {
					$('#detalle').val($('#detalle').val() + centroCostoTR + ']' + montoTCTR + ']' + interesGDTR + ']' + impuestoRetenerDTR + ']' + totalRecibirDTR + ']');
				} else {
					$('#detalle').val($('#detalle').val() + '[' + centroCostoTR + ']' + montoTCTR + ']' + interesGDTR + ']' + impuestoRetenerDTR + ']' + totalRecibirDTR + ']');
				}
			}
		});
	} else {
		mensajeSis("Faltan Datos en la Distribución por CC");
		event.preventDefault();
	}
}

/**
 * Verifica si el detalle de la Distribución de Centro de costos tiene algún campo vacio
 * si si evita que se envie la forma hasta que se acomplete
 * @returns {Boolean}
 */
function verificarvacios() {
	var esValido = true;
	var mensaje = "";
	quitaFormatoControles('gridDetalle');
	$("#distribucionCC tr").each(function(index) {
		if (index > 0) {
			var centroCostoTR = $(this).find("input[name=ccD]").val();
			var montoTCTR = $(this).find("input[name=montoD]").val();
			var interesGDTR = $(this).find("input[name=interesGD]").val();
			var impuestoRetenerDTR = $(this).find("input[name=impuestoRetenerD]").val();
			var totalRecibirDTR = $(this).find("input[name=totalRecibirD]").val();
			if (centroCostoTR === undefined || centroCostoTR == null || centroCostoTR.length <= 0 || centroCostoTR == 0 || isNaN(centroCostoTR)) {
				$(this).find("input[name=ccD]").addClass("error");
				$(this).find("input[name=ccD]").focus();
				if (mensaje == "")
					mensaje = "No Asignó el Centro de Costos a la Distribución por CC"
				esValido = false;
			}
			if (montoTCTR === undefined || montoTCTR == null || montoTCTR.length <= 0 || montoTCTR == 0 || isNaN(montoTCTR)) {
				$(this).find("input[name=montoD]").addClass("error");
				$(this).find("input[name=montoD]").focus();
				if (mensaje == "")
					mensaje = "No Asignó el Monto a la Distribución por CC"
				esValido = false;
			}
			if (interesGDTR === undefined || interesGDTR == null || interesGDTR.length <= 0 || interesGDTR == 0 || isNaN(interesGDTR) ||
				impuestoRetenerDTR === undefined || impuestoRetenerDTR == null || impuestoRetenerDTR.length <= 0 || impuestoRetenerDTR == 0 || isNaN(impuestoRetenerDTR) ||
				totalRecibirDTR === undefined || totalRecibirDTR == null || totalRecibirDTR.length <= 0 || totalRecibirDTR == 0 || isNaN(totalRecibirDTR)) {
				var tasasInversionBean = {
					'tasa': $('#tasa').val(),
					'tasaISR': $('#tasaISR').val(),
					'monto': montoTCTR,
					'plazo': $('#plazo').asNumber(),
					'diasBase': $('#diasBase').val(),
					'salarioMinimo': salarioMinimo,
					'numeroSalarios': 5,
					'montoBaseInversion':$('#monto').asNumber()
				};

				var interCCID = $(this).find("input[name=interesGD]").attr('id');
				var impRDID = $(this).find("input[name=impuestoRetenerD]").attr('id');
				var totalRID = $(this).find("input[name=totalRecibirD]").attr('id');

				invBancariaServicioScript.calculaRendimiento(tasasInversionBean, function(rendimiento) {
					if (rendimiento != null) {
						$("#" + interCCID).val(rendimiento.interesGenerado);
						$("#" + impRDID).val(rendimiento.interesRetener);
						$("#" + totalRID).val(rendimiento.totalRecibir);

						$("#" + interCCID).formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 4
						});
						$("#" + impRDID).formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 4
						});
						$("#" + totalRID).formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});
					}
				});
			}
		}

	});
	agregaFormatoControles('gridDetalle');
	if (mensaje != "")
		mensajeSis(mensaje);
	return esValido;
}

/**
 * Método para limpiar toda la forma de las inversiones bancarias
 */
function limpiarforma() {

	$('#institucionID').val('');
	$('#nombreCompleto').val('');
	$('#numCtaInstit').val('');
	$('#totalCuenta').val('');
	$('#tipoInversion').val('');
	$('#monto').val('');
	$('#plazo').val('');
	$('#fechaVencimiento').val('');
	$('#tasa').val('');
	$('#interesGenerado').val('');
	$('#tasaISR').val('');
	$('#tasaNeta').val('');
	$('#interesRetener').val('');
	$('#interesRecibir').val('');
	$('#totalRecibir').val('');

	$('#diasBase').val(diasBase);
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#tasaISR').val('0.00');
	ocultarCampos();
	deshabilitaBoton('agregarDCC', 'submit');
	eliminarTodasDistribucionCC();
	$('#formaGenerica input[name=clasificacionInver]').attr('checked', false);
	$('#formaGenerica input[name=tipoTitulo]').attr('checked', false);
	$('#formaGenerica input[name=tipoRestriccion]').attr('checked', false);
	$('#formaGenerica input[name=tipoDeuda]').attr('checked', false);
}

/**
 * Cancela las teclas [ ] en el formulario
 * @param e
 * @returns {Boolean}
 */
document.onkeypress = pulsarCorchete;

function pulsarCorchete(e) {
	tecla = (document.all) ? e.keyCode : e.which;
	if (tecla == 91 || tecla == 93) {
		return false;
	}
	return true;
}

function ClienteEspeficio() {
    var tipoConsulta = 13;
    var cliente = 28;
    paramGeneralesServicio.consulta(tipoConsulta, {
        async: false,
        callback: function(valor) {
            if (valor != null) {
                numeroCliente = valor.valorParametro;
            }
        }
    });
}

/**
 * Recalculo del rendimiento por distribución
 * @returns {Boolean}
 */
function recalculaRendimientoCC() {
	var esValido = true;
	var mensaje = "";
	var habilitaDAgregar =false;
	quitaFormatoControles('gridDetalle');
	//Deshabilito el botón de agregar hasta que haga todo el recalculo para evitar que se guarden datos erroneos
	if(!$("#agrega").is(":disabled")){
		deshabilitaBoton('agrega', 'submit');
		habilitaDAgregar=true;
	}
	var montoInversion = $("#monto").asNumber();


	$("#distribucionCC tr").each(function(index) {

		if (index > 0) {
			var centroCostoTR = $(this).find("input[name=ccD]").val();
			var montoTCTR = $(this).find("input[name=montoD]").val();
			var interesGDTR = $(this).find("input[name=interesGD]").val();
			var impuestoRetenerDTR = $(this).find("input[name=impuestoRetenerD]").val();
			var totalRecibirDTR = $(this).find("input[name=totalRecibirD]").val();
			var id = $(this).find("input[name=ccD]").attr('id');

			var numero = id.substring(3,id.length);

			if (centroCostoTR === undefined || centroCostoTR == null || centroCostoTR.length <= 0 || centroCostoTR == 0 || isNaN(centroCostoTR)) {
				$(this).find("input[name=ccD]").addClass("error");
				$(this).find("input[name=ccD]").focus();
				if (mensaje == "")
					mensaje = "No Asignó el Centro de Costos a la Distribución por CC"
				esValido = false;
			}
			if (montoTCTR === undefined || montoTCTR == null || montoTCTR.length <= 0 || montoTCTR == 0 || isNaN(montoTCTR)) {
				$(this).find("input[name=montoD]").addClass("error");
				$(this).find("input[name=montoD]").focus();
				if (mensaje == "")
					mensaje = "No Asignó el Monto a la Distribución por CC"
				esValido = false;
			}
			if (!isNaN(montoTCTR)) {
				var tasasInversionBean = {
					'tasa': $('#tasa').val(),
					'tasaISR': $('#tasaISR').val(),
					'monto': montoTCTR,
					'plazo': $('#plazo').asNumber(),
					'diasBase': $('#diasBase').val(),
					'salarioMinimo': salarioMinimo,
					'numeroSalarios': 5,
					'montoBaseInversion':$('#monto').asNumber()
				};

				var interCCID = $(this).find("input[name=interesGD]").attr('id');
				var impRDID = $(this).find("input[name=impuestoRetenerD]").attr('id');
				var totalRID = $(this).find("input[name=totalRecibirD]").attr('id');

				invBancariaServicioScript.calculaRendimiento(tasasInversionBean, function(rendimiento) {
					if (rendimiento != null) {
						$("#" + interCCID).val(rendimiento.interesGenerado);
						$("#" + impRDID).val(rendimiento.interesRetener);
						$("#" + totalRID).val(rendimiento.totalRecibir);




				if (numero == contFilas){

					var totalInteresGD = sumaInteresGD();
					var totalImpuestoRetenerD = sumaImpuestoRetenerD();

					var interesGenera =  $('#interesGenerado').asNumber();
					var interesRetener = $('#interesRetener').asNumber();

					var diferenciaD	= 0;
					var diferenciaGD = 0;

					if(totalInteresGD > interesGenera){
						 diferenciaGD = parseFloat(totalInteresGD - interesGenera).toFixed(4);
						if(parseFloat($('#interesGD' + numero).asNumber() - parseFloat(diferenciaGD)).toFixed(4)<=0){
								$('#interesGD' + numero).val(0);
							}else{

								$('#interesGD' + numero).val(parseFloat($('#interesGD' + numero).asNumber() - parseFloat(diferenciaGD)).toFixed(4));
							}

					}else if (totalInteresGD < interesGenera){

						 diferenciaGD = parseFloat(interesGenera - totalInteresGD  ).toFixed(4);

						$('#interesGD' + numero).val(parseFloat($('#interesGD' + numero).asNumber() + parseFloat(diferenciaGD)).toFixed(4));

					}

					if(totalImpuestoRetenerD > interesRetener){
						diferenciaD = parseFloat(totalImpuestoRetenerD - interesRetener).toFixed(4);

						if((parseFloat($('#impuestoRetenerD'+numero).asNumber()-parseFloat(diferenciaD))).toFixed(4)<=0){

							$('#impuestoRetenerD'+numero).val(0);
						}else{
							$('#impuestoRetenerD'+numero).val(parseFloat($('#impuestoRetenerD'+numero).asNumber()-parseFloat(diferenciaD)).toFixed(4));
						}
					}else if(totalImpuestoRetenerD < interesRetener){

						 diferenciaD = parseFloat(interesRetener - totalImpuestoRetenerD).toFixed(4);
						$('#impuestoRetenerD'+numero).val(parseFloat($('#impuestoRetenerD'+numero).asNumber()+parseFloat(diferenciaD)).toFixed(4));
					}

					$('#totalRecibir' + numero).val($('#montoD'+numero).asNumber()+$('#interesGD'+numero).asNumber()-$('#impuestoRetenerD'+numero).asNumber());

					validarGridTotalRecibir();

					$('#interesGD' + numero).formatCurrency({
						positiveFormat: '%n',
						roundToDecimalPlace: 4
					});
					$('#impuestoRetenerD' + numero).formatCurrency({
						positiveFormat: '%n',
						roundToDecimalPlace: 4
					});
					$('#totalRecibir' + numero).formatCurrency({
						positiveFormat: '%n',
						roundToDecimalPlace: 2
					});


					if($('#interesGD'+numero).asNumber() <= 0){
							deshabilitaBoton('agrega','submit');
							mensajeSis('El monto ingresado no puede ser prorrateado entre los centros de costo actuales');
						}else{
							habilitaBoton('agrega','submit');
						}

				}


						$("#" + interCCID).formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 4
						});
						$("#" + impRDID).formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 4
						});
						$("#" + totalRID).formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});

					}
				});
			}
		}

	});



	//Volver habilitar el botón si es que estaba habilitado
	if(habilitaDAgregar){
		habilitaBoton('agrega', 'submit');
	}
	agregaFormatoControles('gridDetalle');
	return esValido;

}



function sumaInteresGD() {
	var montoTotal = 0;
	$("#distribucionCC tr").each(function(index) {
		if (index > 0) {
			var montoGD  = $(this).find("input[name=interesGD]").asNumber();
			if(montoGD>0){
				 montoTotal = montoTotal + montoGD;

			}
		}
	});
	return montoTotal;

}

function sumaImpuestoRetenerD() {
	montoIn = 0;
	$("#distribucionCC tr").each(function(index) {
		if (index > 0) {
			var montoTC = $(this).find("input[name=impuestoRetenerD]").asNumber();
			if (montoTC > 0) {
				montoIn = montoIn + montoTC;
			}
		}
	});
	return montoIn;
}

function validarGridTotalRecibir() {
	$("#distribucionCC tr").each(function(index) {
		if (index > 0) {

			var montoTC = $(this).find("input[name=montoD]").asNumber();
			var interesGD = $(this).find("input[name=interesGD]").asNumber();
			var impuestoRetenerD = $(this).find("input[name=impuestoRetenerD]").asNumber();
			var id = $(this).find("input[name=ccD]").attr('id');
			var numero = id.substring(3,id.length);

			var jqTotalRecibir = eval("'#totalRecibir"+numero+"'");
			  $(jqTotalRecibir).val(montoTC+interesGD-impuestoRetenerD);

			$('#totalRecibir' + numero).formatCurrency({
							positiveFormat: '%n',
							roundToDecimalPlace: 2
						});

		}
	});

}
