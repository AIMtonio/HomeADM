var idControlMinistraFocusError = null;
var idControlCapitalFocusError = null;
var simulacionRealizada = false;
//Campos para validar en caso de que se haya generado el simulador
var valorAnteriorMinistra = null;

/**
 * Método para agregar las ministraciones
 * @param idControl
 */
function agregarMinistracion() {
	reasignaTabIndex();
	habilitaBoton('grabar', 'submit');
	var sumaFechaHabil = 3;
	var numTab = $("#numTab").asNumber() + 1;
	var fila = getRenglones('pagoMinistraciones') + 1;
	esTab =true;
	if (fila <= 20) {
		if (validaTablaMinistraciones(true, null, true, true)) {
			var nuevaFila = '';
			if (fila == 1) {
				var fechaInicio = $("#fechaInicioAmor").val();
				nuevaFila = '<tr id="pagoMinistra' + fila + '" name="tr">' + '	<td><input id="numeroMinis' + fila + '" name="numeroMinis" type="text" maxlength="10" size="11" readonly="true" disabled="disabled" value="' + fila + '"></td>'
				+ '	<td><input id="fechaPagoMinis' + fila + '" name="fechaPagoMinis" type="text" maxlength="10" size="16" esCalendario="true" onblur="guardaValorTemporal(this.id);validaTablaMinistraciones(false,this.id,true,false);" onchange="validaTablaMinistraciones(true,this.id,true,false)" tabindex="' + numTab + ' value="' + fechaInicio + '" disabled="disabled"></td>'
				+ '	<td><input id="capitalMinis' + fila + '" name="capitalMinis" type="text" maxlength="20" size="20" esMoneda="true" style="text-align:right;" onchange="validaTablaMinistraciones(true,this.id,false,true)" tabindex="' + numTab + '"></td>'
				+ '	<td nowrap="nowrap">' + '		<input type="button" id="eliminarMinistra' + fila + '" name="eliminarMinistra" value="" class="btnElimina" onclick="eliminarMinistracion(' + fila + ')" disabled="disabled"/>' + '		<input type="button" id="agregaMinistra' + fila + '" name="agregaMinistra" value="" class="btnAgrega" onclick="agregarMinistracion(this.id)" tabindex="' + numTab + '"/>' + '	</td>' + '</tr>';
			} else {
				var idFechaPago = $('#ministraciones tr:last').find("input[name^='fechaPagoMinis']").attr("id");
				esTab=true;
				var fecha = sumaDiasFechaHabil(sumaFechaHabil, $('#' + idFechaPago).val(), 1, 1, 'S');
				nuevaFila = '<tr id="pagoMinistra' + fila + '" name="tr">' + '	<td><input id="numeroMinis' + fila + '" name="numeroMinis" type="text" maxlength="10" size="11" readonly="true" disabled="disabled" value="' + fila + '"></td>'
				+ '	<td><input id="fechaPagoMinis' + fila + '" name="fechaPagoMinis" type="text" maxlength="10" size="16" esCalendario="true" onblur="guardaValorTemporal(this.id);validaTablaMinistraciones(false,this.id,true,false);" onchange="validaTablaMinistraciones(true,this.id,true,false)" tabindex="' + numTab + '" value="' + fecha.fecha + '"></td>'
				+ '	<td><input id="capitalMinis' + fila + '" name="capitalMinis" type="text" maxlength="20" size="20" esMoneda="true" style="text-align:right;" onblur="validaTablaMinistraciones(false,this.id,false, true)" onchange="validaTablaMinistraciones(true,this.id,false, true)" tabindex="' + numTab + '"></td>'
				+ '	<td nowrap="nowrap">' + '		<input type="button" id="eliminarMinistra' + fila + '" name="eliminarMinistra" value="" class="btnElimina" onclick="eliminarMinistracion(' + fila + ')" tabindex="' + numTab + '"/>' + '		<input type="button" id="agregaMinistra' + fila + '" name="agregaMinistra" value="" class="btnAgrega" onclick="agregarMinistracion(this.id)" tabindex="' + numTab + '"/>' + '	</td>' + '</tr>';
			}
			$('#ministraciones').append(nuevaFila);
			$("#numTab").val(numTab);
			agregaFormatoControles('formaGenerica');
		} else {
			$(idControlMinistraFocusError).focus();
		}
	}
}
/**
 * Método para la eliminacion de las ministraciones
 * @param fila : Numero de fila a Eliminar
 */
function eliminarMinistracion(fila) {
	$('#pagoMinistra' + fila).remove();
	$("#numTab").val($("#numTab").asNumber() - 1);
	reasignaTabIndex();
}
/**
 * Guarda el valor temporal del campo
 * @param idControl
 */
function guardaValorTemporal(idControl){
	valorAnteriorMinistra = $("#"+idControl).val();
}
/**
 * Método para validar la tabla de ministraciones.
 * @returns {Boolean}
 */
function validaTablaMinistraciones(esOnchange, idControl, validaFecha, validaCap) {
	idControlMinistraFocusError = null;
	//Si ya se realizo la simulación avisarle al usuario que si modifica las ministraciones se eliminaran todas las amortizaciones
	if (simulacionRealizada && esOnchange && idControl!='graba') {
		if (confirm("La Simulación ya se realizó. Si Modifica o Agrega Ministraciones se eliminarán todas las Amortizaciones.  \n¿Desea continuar con la operación?")) {
			//Se Eliminaran todas las amortizaciones
			$('#contenedorSimuladorLibre').html("");
			simulacionRealizada = false;
		} else {
			if(idControl!=null){
				$("#"+idControl).val(valorAnteriorMinistra);
				idControl = null;
				valorAnteriorMinistra = null;
			}
			//Se regresa false esto para que evite que se agregue otro renglon
			return false;
		}
	}
	quitaFormatoControles('formaGenerica');
	var fechaAnterior = '1900-01-01';
	var fechaActualSistema = parametroBean.fechaAplicacion;
	var total = 0;
	var diferencia = $('#diferenciaMinistra').asNumber();
	var fechaVencimiento = $('#fechaVencimiento').val();
	if(fechaVencimiento == undefined || fechaVencimiento ==''){
		mensajeSis("La Fecha de Vencimiento esta Vacia");
		$('#fechaVencimiento').addClass("error");
		if (idControlMinistraFocusError == null) {
			idControlMinistraFocusError = '#fechaVencimiento';
			if (idControlMinistraFocusError != null) {
				$(idControlMinistraFocusError).focus();
				return false;
			}
		}
	} else {
		$('#fechaVencimiento').removeClass("error");
	}
	var montoSolicitado = $('#montoSolici').asNumber();
	var totalDif = 0;
	if(esTab){
		$('#ministraciones tr').each(function(index) {
			/** VALIDACION CON LAS FECHAS */
			var fechaPagoMinis = "#" + $(this).find("input[name^='fechaPagoMinis']").attr("id");
			var fecha = $(fechaPagoMinis).val();
			if (fecha == null || fecha == '' || (fechaAnterior > fecha) || (fechaActualSistema> fecha) && validaFecha) {
				mensajeSis("La Fecha de la Ministración esta Vacia o es Menor a la Fecha del Sistema.");
				$(fechaPagoMinis).addClass("error");
				if (idControlMinistraFocusError == null) {
					idControlMinistraFocusError = fechaPagoMinis;
					return false;
				}
			} else {
				if ((fecha > fechaVencimiento) && validaFecha) {
					mensajeSis("La Fecha de la Ministración no puede ser Igual o Mayor a la Fecha de Vencimiento.");
					$(fechaPagoMinis).addClass("error");
					if (idControlMinistraFocusError == null) {
						idControlMinistraFocusError = fechaPagoMinis;
						return false;
					}
				} else {
					$(fechaPagoMinis).removeClass("error");
				}
			}
			esTab = true;
			var fechaValida = sumaDiasFechaHabil(3, $(fechaPagoMinis).val(), 0, 0, 'S');
			if (fechaValida.esFechaHabil != 'S' && validaFecha) {
				mensajeSis("La Fecha de la Ministración No es un Día Hábil.");
				$(fechaPagoMinis).addClass("error");
				if (idControlMinistraFocusError == null) {
					idControlMinistraFocusError = fechaPagoMinis;
					return false;
				}
			} else {
				$(fechaPagoMinis).removeClass("error");
			}

			fechaAnterior = fecha;
			/** FIN VALIDACION CON LAS FECHAS */
			// Validaciones del capital a desembolsar
			var capitalMinis = "#" + $(this).find("input[name^='capitalMinis']").attr("id");
			var montoCapital = $(capitalMinis).asNumber();

			if (montoCapital <= 0 && validaCap) {
				mensajeSis("El Monto de la Ministración no puede ser Menor a 0.");
				$(capitalMinis).addClass("error");
				$(capitalMinis).val('');
				if (idControlMinistraFocusError == null) {
					idControlMinistraFocusError = capitalMinis;
					return false;
				}
			} else {
				if (montoCapital > montoSolicitado && validaCap) {
					mensajeSis("El Monto de la Ministración no puede ser Mayor al Solicitado.");
					$(capitalMinis).addClass("error");
					$(capitalMinis).val('');
					if (idControlMinistraFocusError == null) {
						idControlMinistraFocusError = capitalMinis;
						return false;
					}
				} else {
					$(capitalMinis).removeClass("error");
				}
			}

			if (totalDif < 0 && validaCap) {
				total = total - $(capitalMinis).asNumber();
				mensajeSis("El Total de la Ministración Supera el Monto de la Solicitud.");
				$(capitalMinis).val('');
				$(capitalMinis).addClass("error");
				if (idControlMinistraFocusError == null) {
					idControlMinistraFocusError = capitalMinis;
					return false;
				}
			} else {

				diferencia = totalDif;
				$('#diferenciaMinistra').val(diferencia);
				$(capitalMinis).removeClass("error");
			}
		});
	}
	esTab = false;

	total = 0;
	diferencia = $('#diferenciaMinistra').asNumber();
	montoSolicitado = $('#montoSolici').asNumber();
	totalDif = 0;

	// Se obtiene por aparte los totales del capital
	$('#ministraciones tr').each(function(index) {
		var capitalMinis = "#" + $(this).find("input[name^='capitalMinis']").attr("id");
		var montoCapital = $(capitalMinis).asNumber();
		total = total + $(capitalMinis).asNumber();
		totalDif = $("#montoSolici").asNumber() - total;
		if (totalDif < 0) {
			total = total - $(capitalMinis).asNumber();
			$(capitalMinis).val('');
		} else {
			diferencia = totalDif;
			$('#diferenciaMinistra').val(diferencia);
		}
	});

	$('#totalMinistra').val(total);
	agregaFormatoControles('formaGenerica');
	//Validamos si hubo error en la tabla de ministraciones
	if (idControlMinistraFocusError != null) {
		$(idControlMinistraFocusError).focus();
		return false;
	}
	return true;

}
/**
 * Método para la reasignacion de TABS en la tabla de ministraciones
 */
function reasignaTabIndex() {
	var numInicioTabs = $('#numTabMin').asNumber();
	var numFila = 1;
	var total = 0;
	$('#ministraciones tr').each(function(index) {
		var numeroMinis = "#" + $(this).find("input[name^='numeroMinis']").attr("id");
		var fechaPagoMini = "#" + $(this).find("input[name^='fechaPagoMinis']").attr("id");
		var capitalMinis = "#" + $(this).find("input[name^='capitalMinis']").attr("id");
		var agrega = "#" + $(this).find("input[name^='agregaMinistra']").attr("id");
		var elimina = "#" + $(this).find("input[name^='eliminarMinistra']").attr("id");
		$(numeroMinis).val(numFila++);
		$(fechaPagoMini).attr('tabindex', numInicioTabs);
		$(capitalMinis).attr('tabindex', numInicioTabs);
		$(elimina).attr('tabindex', numInicioTabs);
		$(agrega).attr('tabindex', numInicioTabs);
		total = total + $(capitalMinis).asNumber();
		numInicioTabs++;
	});
	$('#numTab').val(numInicioTabs);
	$('#totalMinistra').val(total);
}
/**
 * Regresa el número de renglones de un grid.
 * @returns Número de renglones de la tabla.
 */
function getRenglones(idControl) {
	var numRenglones = $('#' + idControl + ' >tbody >tr[name^="tr"]').length;
	return numRenglones;
}
/**
 * Función arma la cadena con los detalles del grid.
 * @returns {Boolean}
 */
function llenarDetalle() {
	quitaFormatoControles('formaGenerica');
	var idDetalle = '#detalleMinistraAgro';
	$(idDetalle).val('');
	$('#ministraciones tr').each(function(index) {
		var numeroID = "#" + $(this).find("input[name^='numero'").attr("id");
		var fechaPagoMinisID = "#" + $(this).find("input[name^='fechaPagoMinis'").attr("id");
		var capitalID = "#" + $(this).find("input[name^='capital'").attr("id");

		var numeroIDVal = $(numeroID).val();
		var fechaPagoMinisIDVal = $(fechaPagoMinisID).val();
		var capitalIDVal = $(capitalID).val();

		if (index == 0) {
			$(idDetalle).val($(idDetalle).val() + numeroIDVal + ']' + fechaPagoMinisIDVal + ']' + capitalIDVal + ']');
		} else {
			$(idDetalle).val($(idDetalle).val() + '[' + numeroIDVal + ']' + fechaPagoMinisIDVal + ']' + capitalIDVal + ']');
		}
	});
	agregaFormatoControles('formaGenerica');
	return true;
}
function consultaMinistraciones(estatus) {
	$("#gridMinistraCredAgro").html("");
	var tipoListaMin = 3;
	if(estatus === '' || estatus === 'I'){
		tipoListaMin = 1;
	}
	var fechaMin = $("#fechaInicioAmor").val();
	if(fechaMin=='' || fechaMin ==undefined || fechaMin == null){
		fechaMin = parametroBean.fechaAplicacion;
	}

	var beanMinistraciones = {
		'solicitudCreditoID' : $("#solicitudCreditoID").asNumber(),
		'creditoID' : 0,
		'clienteID' : $("#clienteID").asNumber(),
		'prospectoID' : $("#prospectoID").asNumber(),
		'fechaPagoMinis' : fechaMin,
		'tipoLista' : tipoListaMin
	};

	$.post("ministraCredAgroGrid.htm", beanMinistraciones, function(data) {
		if (data.length > 0) {
			$("#gridMinistraCredAgro").html(data);
			$("#gridMinistraCredAgro").show();
			agregaFormatoControles('formaGenerica');
			if(estatus == 'ocultar'){
				$('#eliminarMinistra1').hide();
				$('#agregaMinistra1').hide();
			};
		} else {
			$("#gridMinistraCredAgro").html("");
			$("#gridMinistraCredAgro").show();
			if(estatus == 'ocultar'){
				$('#eliminarMinistra1').hide();
				$('#agregaMinistra1').hide();
			};
		}
	});
}

function consultaMinistracionesconsolidadas(estatus) {
	$("#gridMinistraCredAgro").html("");
	var tipoListaMin = 3;
	if(estatus === '' || estatus === 'I'){
		tipoListaMin = 1;
	}
	var fechaMin = $("#fechaInicioAmor").val();
	if(fechaMin=='' || fechaMin ==undefined || fechaMin == null){
		fechaMin = parametroBean.fechaAplicacion;
	}

	var beanMinistraciones = {
		'solicitudCreditoID' : $("#solicitudCreditoID").asNumber(),
		'creditoID' : 0,
		'clienteID' : $("#clienteID").asNumber(),
		'prospectoID' : $("#prospectoID").asNumber(),
		'fechaPagoMinis' : fechaMin,
		'tipoLista' : tipoListaMin
	};

	$.post("ministraCredAgroGrid.htm", beanMinistraciones, function(data) {
		if (data.length > 0) {
			$("#gridMinistraCredAgro").html(data);
			agregaFormatoControles('formaGenerica');
			if(estatus == 'ocultar'){
				$('#eliminarMinistra1').hide();
				$('#agregaMinistra1').hide();
			};
		} else {
			$("#gridMinistraCredAgro").html("");
			$("#gridMinistraCredAgro").show();
			if(estatus == 'ocultar'){
				$('#eliminarMinistra1').hide();
				$('#agregaMinistra1').hide();
			};
		}
	});
}


function consultaMinistracionesGrupales(solCred) {
	$("#gridMinistraCredAgro").html("");
	var solicitudC=$('#solicitudCreditoID').asNumber();
	var tipoListaMin = 3;
	if(solicitudC>0 && tipoOperacionGrupo==tipoOperacion.noFormal){
		tipoListaMin = 5;
	} else {
		if($('#estatus').val() == 'I'){
			tipoListaMin = 1;
		}
		if(solicitudC==0){
			solCred = 0;
		}
	}


	var fechaMin = $("#fechaInicioAmor").val();
	if(fechaMin=='' || fechaMin ==undefined || fechaMin == null){
		fechaMin = parametroBean.fechaAplicacion;
	}

	var beanMinistraciones = {
		'solicitudCreditoID' : solCred,
		'creditoID' : 0,
		'clienteID' : $("#clienteID").asNumber(),
		'prospectoID' : $("#prospectoID").asNumber(),
		'fechaPagoMinis' : fechaMin,
		'tipoLista' : tipoListaMin
	};

	$.post("ministraCredAgroGrid.htm", beanMinistraciones, function(data) {
		if (data.length > 0) {
			$("#gridMinistraCredAgro").html(data);
			$("#gridMinistraCredAgro").show();
			if(estatus == 'ocultar'){
				$('#eliminarMinistra1').hide();
				$('#agregaMinistra1').hide();
			};
			agregaFormatoControles('formaGenerica');
		} else {
			$("#gridMinistraCredAgro").html("");
			$("#gridMinistraCredAgro").show();
			if(estatus == 'ocultar'){
				$('#eliminarMinistra1').hide();
				$('#agregaMinistra1').hide();
			};
		}
	});
}
function validaCapital(fechaInicio) {
	quitaFormatoControles('formaGenerica');
	var sumCapital = 0;
	var fechInicioAmortizacion = new Date(fechaInicio);
	$('#ministraciones tr').each(function(index) {
		var fechaPagoMinisID = "#" + $(this).find("input[name^='fechaPagoMinis'").attr("id");
		var capitalID = "#" + $(this).find("input[name^='capital'").attr("id");
		var fechaPagoMinisIDVal = new Date($(fechaPagoMinisID).val());
		var capitalIDVal = $(capitalID).val();

		if (fechInicioAmortizacion <= fechaPagoMinisIDVal) {
			sumCapital = sumCapital + capitalIDVal;
		} else {
			return false;
		}

	});
	agregaFormatoControles('formaGenerica');
	return sumCapital;
}
function simulador() {
	// Validar si es un crédito grupal de tipo de operacion no formal ya que si es asi el número de amortizaciones debe ser el mismo en todas
	// las solicitudes
	if ($('#grupo').val() != '' && $('#grupo').val() != undefined) {

		if (numTransaccionInicGrupo != undefined && numTransaccionInicGrupo != null && numTransaccionInicGrupo != 0 && tipoOperacionGrupo == tipoOperacion.noFormal) {
			consultaSimulador();
		} else {
			mostrarSimuladorLibres();
		}
	} else {
		var tipoCredito = $('#tipoCredito').val();

		if(tipoCredito == 'R'){
			mostrarSimuladorLibresReest();
		}else{

			mostrarSimuladorLibres();
		}

	}
}
function mostrarSimuladorLibres(){
	var cobraSeguroCuota = $("#cobraSeguroCuota").val();
	quitaFormatoControles('formaGenerica');
	$('#contenedorSimulador').html("");
	$('#contenedorSimulador').hide();
	var montoSolicitud = $("#montoSolici").asNumber();
	var data = "<fieldset class=\"ui-widget ui-widget-content ui-corner-all\">" +
	"<legend>Simulador de Amortizaciones</legend>" +
	"<table id=\"TablaAmortizaLibres\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">" +
	"<thead><tr>" +
	"<td class=\"label\" align=\"center\"><label>N&uacute;mero</label></td>" +
	"<td class=\"label\" align=\"center\"><label>Fecha Inicio</label></td>" +
	"<td class=\"label\" align=\"center\"><label>Fecha Vencimiento</label></td>" +
	"<td class=\"label\" align=\"center\"><label>Fecha Pago</label></td>" +
	"<td class=\"label\" align=\"center\"><label>Capital</label></td>" +
	"<td class=\"label\" align=\"center\"><label>Inter&eacute;s</label></td>" +
	"<td class=\"label\" align=\"center\"><label>IVA Inter&eacute;s</label></td>";
	if(cobraSeguroCuota == "S"){
		data = data + "<td class=\"label\" align=\"center\"><label>Seguro</label></td>" +
		"<td class=\"label\" align=\"center\"><label>IVA Seguro</label></td>";
	}
	data = data + "<td class=\"label\" align=\"center\"><label>Total Pago</label></td>" +
	"<td class=\"label\" align=\"center\"><label>Saldo Capital</label></td>" +
	"<td class=\"label\" align=\"center\"></td></tr></thead>" +
	"<tbody id=\"TablaAmortizaLibresBody\"></tbody>" +
	"<tfoot><tr><td colspan=\"4\" align=\"right\"><label>Totales: </label></td>" +
	"<td><input type=\"text\" size=\"18\" readOnly=\"true\" style=\"text-align: right;\" esMoneda=\"true\" disabled=\"true\" id=\"totalCap\" name=\"totalCap\"/></td>" +
	"</tr>" +
	"<tr><td colspan=\"4\" align=\"right\"><label>Diferencia: </label></td>" +
	"<td><input type=\"text\" size=\"18\" readonly=\"true\" style=\"text-align: right;\" esMoneda=\"true\" disabled=\"true\" id=\"diferenciaCapital\" name=\"diferenciaCapital\" value=\""+montoSolicitud+"\"/></td></tr>"+
	"<tr>" +
	"<td colspan=\"12\" align=\"right\">" +
	"<input type=\"button\" class=\"submit\" id=\"calcular\" tabindex=\"37\" value=\"Calcular\" onclick=\"simuladorLibresCapFec();\" />" +
	"<input type=\"hidden\" id=\"numTabSimulador\" value=\"100\"/>" +
	"<input type=\"hidden\" id=\"numTabMinSimulador\" value=\"100\"/>" +
	"<input type=\"hidden\" id=\"numFila\" value=\"1\"/>" +
	"</td>" +
	"<td><input type=\"button\" id=\"imprimirRep\" class=\"submit\" style=\"display: none;\" value=\"Imprimir\" onclick=\"generaReporte();\" /></td>" +
	"</tr></tfoot>" +
	"</table></fieldset>";
	$('#contenedorSimuladorLibre').html(data);
	$('#contenedorSimuladorLibre').show();
	deshabilitaBoton('modificar', 'submit');
	deshabilitaBoton('liberar', 'submit');
	deshabilitaBoton('agregar', 'submit');
	agregaAmortizacion();
	agregaFormatoControles('formaGenerica');
}

function mostrarSimuladorLibresReest(){
	var cobraSeguroCuota = $("#cobraSeguroCuota").val();
	quitaFormatoControles('formaGenerica');
	$('#contenedorSimulador').html("");
	$('#contenedorSimulador').hide();
	var montoSolicitud = $("#montoSolici").asNumber();
	var data = "<fieldset class=\"ui-widget ui-widget-content ui-corner-all\">" +
	"<legend>Simulador de Amortizaciones</legend>" +
	"<table id=\"TablaAmortizaLibres\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"100%\">" +
	"<thead><tr>" +
	"<td class=\"label\" align=\"center\"><label>N&uacute;mero</label></td>" +
	"<td class=\"label\" align=\"center\"><label>Fecha Inicio</label></td>" +
	"<td class=\"label\" align=\"center\"><label>Fecha Vencimiento</label></td>" +
	"<td class=\"label\" align=\"center\"><label>Fecha Pago</label></td>" +
	"<td class=\"label\" align=\"center\"><label>Capital</label></td>" +
	"<td class=\"label\" align=\"center\"><label>Inter&eacute;s</label></td>" +
	"<td class=\"label\" align=\"center\"><label>IVA Inter&eacute;s</label></td>";
	if(cobraSeguroCuota == "S"){
		data = data + "<td class=\"label\" align=\"center\"><label>Seguro</label></td>" +
		"<td class=\"label\" align=\"center\"><label>IVA Seguro</label></td>";
	}
	data = data + "<td class=\"label\" align=\"center\"><label>Total Pago</label></td>" +
	"<td class=\"label\" align=\"center\"><label>Saldo Capital</label></td>" +
	"<td class=\"label\" align=\"center\"></td></tr></thead>" +
	"<tbody id=\"TablaAmortizaLibresBody\"></tbody>" +
	"<tfoot><tr><td colspan=\"4\" align=\"right\"><label>Totales: </label></td>" +
	"<td><input type=\"text\" size=\"18\" readOnly=\"true\" style=\"text-align: right;\" esMoneda=\"true\" disabled=\"true\" id=\"totalCap\" name=\"totalCap\"/></td>" +
	"</tr>" +
	"<tr><td colspan=\"4\" align=\"right\"><label>Diferencia: </label></td>" +
	"<td><input type=\"text\" size=\"18\" readonly=\"true\" style=\"text-align: right;\" esMoneda=\"true\" disabled=\"true\" id=\"diferenciaCapital\" name=\"diferenciaCapital\" value=\""+montoSolicitud+"\"/></td></tr>"+
	"<tr>" +
	"<td colspan=\"12\" align=\"right\">" +
	"<input type=\"button\" class=\"submit\" id=\"calcular\" tabindex=\"37\" value=\"Calcular\" onclick=\"simuladorLibresCapFecReest();\" />" +
	"<input type=\"hidden\" id=\"numTabSimulador\" value=\"110\"/>" +
	"<input type=\"hidden\" id=\"numTabMinSimulador\" value=\"110\"/>" +
	"<input type=\"hidden\" id=\"numFila\" value=\"1\"/>" +
	"</td>" +
	"<td><input type=\"button\" id=\"imprimirRep\" class=\"submit\" style=\"display: none;\" value=\"Imprimir\" onclick=\"generaReporte();\" /></td>" +
	"</tr></tfoot>" +
	"</table></fieldset>";
	$('#contenedorSimuladorLibre').html(data);
	$('#contenedorSimuladorLibre').show();
	deshabilitaBoton('modificar', 'submit');
	deshabilitaBoton('liberar', 'submit');
	deshabilitaBoton('agregar', 'submit');
	agregaAmortizacionReestr();
	agregaFormatoControles('formaGenerica');
}
function agregaAmortizacion(){
	quitaFormatoControles('formaGenerica');
	var numTab = $("#numTabSimulador").asNumber()+1;
	var numFila = $("#numFila").asNumber();
	var capital = '';
	var fechaInicioAmor = '';
	var fechaVencimiento = '';
	var diferenciaAmortiza = $('#diferenciaCapital').asNumber();
	if(diferenciaAmortiza==0 && var_NoEsNuevaSol){
		mensajeSis("El Monto de Capital ya fue Cubierto en su Totalidad.");
		agregaFormatoControles('formaGenerica');
		return;
	}
	if(numFila==1){
		capital = $("#montoSolici").val();
		fechaInicioAmor = $('#fechaInicioAmor').val();
		fechaVencimiento = $("#fechaVencimiento").val();

	} else {
		var idLastFechaVen = $('#TablaAmortizaLibresBody >tr:last').find("input[name^='fechaVencim']").attr("id");
		fechaInicioAmor = $('#'+idLastFechaVen).val();
		$('#ministraciones tr').each(function(index) {
			var fechaPagoMinisID = "#" + $(this).find("input[name^='fechaPagoMinis'").attr("id");
			var fechaPagoMinisIDVal = new Date($(fechaPagoMinisID).val());
			if(fechaInicioAmor>fechaInicioAmor){
				fechaVencimiento = fechaPagoMinisIDVal;
				return false;//Se sale del ciclo
			}
		});
	}

	if(fechaVencimiento == ''){//Se toma la fecha de vencimiento del credito
		fechaVencimiento = $("#fechaVencimiento").val();
	}
	if(validarFechas(false)){
		if(validaCapitalAmor()){
			var cobraSeguroCuota = $("#cobraSeguroCuota").val();
			var nuevaFila = "<tr id=\"tramor"+numFila+"\">" +
			"<td align=\"center\"><input type=\"text\" maxlength=\"5\" size=\"8\"                     disabled=\"disabled\"  id=\"consecutivoID"+numFila+"\" name=\"consecutivoID\" value=\""+numFila+"\" style=\"text-align:center;\" /></td>" +
			"<td align=\"center\"><input type=\"text\" maxlength=\"10\" size=\"15\"                   disabled=\"disabled\"  id=\"fechaInicio"+numFila+"\" name=\"fechaInicio\" value=\""+fechaInicioAmor+"\"/></td>" +
			"<td align=\"center\" nowrap=\"nowrap\"><input type=\"text\" maxlength=\"10\" size=\"15\" escalendario=\"true\"  id=\"fechaVencim"+numFila+"\" name=\"fechaVencim\" value=\""+fechaVencimiento+"\" tabindex=\""+numTab+"\" onchange=\"cambiarFechaInicioAmor(this.id);validarFechas(false);\"/></td>" +
			"<td align=\"center\"><input type=\"text\" maxlength=\"10\" size=\"15\"                   disabled=\"disabled\"  id=\"fechaExigible"+numFila+"\" name=\"fechaExigible\"/></td>" +
			"<td align=\"center\"><input type=\"text\" maxlength=\"18\" size=\"18\" esmoneda=\"true\"                        id=\"capital"+numFila+"\" name=\"capital\" tabindex=\""+numTab+"\" style=\"text-align:right;\" value=\""+capital+"\" onchange=\"validaCapitalAmor();\" onblur=\"sumaCapitalesAmor()\"/></td>" +
			"<td align=\"center\"><input type=\"text\" maxlength=\"18\" size=\"18\" esmoneda=\"true\" style=\"text-align:right;\" disabled=\"disabled\"  id=\"interes"+numFila+"\" name=\"interes\"/></td>" +
			"<td align=\"center\"><input type=\"text\" maxlength=\"18\" size=\"18\" esmoneda=\"true\" style=\"text-align:right;\" disabled=\"disabled\"  id=\"ivaInteres"+numFila+"\" name=\"ivaInteres\"/></td>";
			if(cobraSeguroCuota=="S"){
				nuevaFila = nuevaFila +
				"<td align=\"center\"><input type=\"text\" maxlength=\"18\" size=\"18\" esmoneda=\"true\" style=\"text-align:right;\" disabled=\"disabled\"  id=\"montoSeguro"+numFila+"\" name=\"montoSeguro\"/></td>" +
				"<td align=\"center\"><input type=\"text\" maxlength=\"18\" size=\"18\" esmoneda=\"true\" style=\"text-align:right;\" disabled=\"disabled\"  id=\"montoSeguroIVA"+numFila+"\" name=\"montoSeguroIVA\"/></td>";
			}
			nuevaFila = nuevaFila +
			"<td align=\"center\"><input type=\"text\" maxlength=\"18\" size=\"18\" esmoneda=\"true\" style=\"text-align:right;\" disabled=\"disabled\"  id=\"totalPago"+numFila+"\" name=\"totalPago\"/></td>" +
			"<td align=\"center\"><input type=\"text\" maxlength=\"18\" size=\"18\" esmoneda=\"true\" style=\"text-align:right;\" disabled=\"disabled\"  id=\"saldoInsoluto"+numFila+"\" name=\"saldoInsoluto\"/></td>" +
			"<td align=\"center\" nowrap=\"nowrap\">";
			if(numFila==1){
				nuevaFila= nuevaFila + "<input type=\"button\" id=\"eliminarAmor\" name=\"eliminarAmor\" class=\"btnElimina\" disabled=\"disabled\" />";
			} else {
				nuevaFila= nuevaFila + "<input type=\"button\" id=\"eliminarAmor\" name=\"eliminarAmor\" class=\"btnElimina\" onclick=\"eliminarAmortizacion('tramor"+numFila+"');\" tabindex=\""+numTab+"\" />";
			}
			nuevaFila = nuevaFila + "<input type=\"button\" id=\"agregaMinistra\" name=\"agregaAmor\" class=\"btnAgrega\" onclick=\"agregaAmortizacion();\" tabindex=\""+numTab+"\"/>" +
			"</td>" +
			"</tr>";
			$("#numFila").val(numFila+1);
			$("#numTabSimulador").val(numTab);
			$('#TablaAmortizaLibresBody').append(nuevaFila);
			reasignaTabIndexSimulador();
		} else {
			$(idControlCapitalFocusError).focus();
		}
	}
	agregaFormatoControles('formaGenerica');
}

function agregaAmortizacionReestr(){
	quitaFormatoControles('formaGenerica');
	var numTab = $("#numTabSimulador").asNumber()+1;
	var numFila = $("#numFila").asNumber();
	var capital = '';
	var fechaInicioAmor = '';
	var fechaVencimiento = '';
	var diferenciaAmortiza = $('#diferenciaCapital').asNumber();
	if(diferenciaAmortiza==0){
		mensajeSis("El Monto de Capital ya fue Cubierto en su Totalidad.");
		agregaFormatoControles('formaGenerica');
		return;
	}


	if(numFila==1){
		capital = $("#montoSolici").val();
		fechaInicioAmor = $('#fechaInicioAmor').val();
		fechaVencimiento = $("#fechaVencimiento").val();

	} else {
		var idLastFechaVen = $('#TablaAmortizaLibresBody >tr:last').find("input[name^='fechaVencim']").attr("id");
		fechaInicioAmor = $('#'+idLastFechaVen).val();

	}



	if(fechaVencimiento == ''){//Se toma la fecha de vencimiento del credito
		fechaVencimiento = $("#fechaVencimiento").val();
	}
	if(validarFechas(false)){
			var cobraSeguroCuota = $("#cobraSeguroCuota").val();
			var nuevaFila = "<tr id=\"tramor"+numFila+"\">" +
			"<td align=\"center\"><input type=\"text\" maxlength=\"5\" size=\"8\"                     disabled=\"disabled\"  id=\"consecutivoID"+numFila+"\" name=\"consecutivoID\" value=\""+numFila+"\" style=\"text-align:center;\" /></td>" +
			"<td align=\"center\"><input type=\"text\" maxlength=\"10\" size=\"15\"                   disabled=\"disabled\"  id=\"fechaInicio"+numFila+"\" name=\"fechaInicio\" value=\""+fechaInicioAmor+"\"/></td>" +
			"<td align=\"center\" nowrap=\"nowrap\"><input type=\"text\" maxlength=\"10\" size=\"15\" escalendario=\"true\"  id=\"fechaVencim"+numFila+"\" name=\"fechaVencim\" value=\""+fechaVencimiento+"\" tabindex=\""+numTab+"\" onchange=\"cambiarFechaInicioAmor(this.id);validarFechas(false);\"/></td>" +
			"<td align=\"center\"><input type=\"text\" maxlength=\"10\" size=\"15\"                   disabled=\"disabled\"  id=\"fechaExigible"+numFila+"\" name=\"fechaExigible\"/></td>" +
			"<td align=\"center\"><input type=\"text\" maxlength=\"18\" size=\"18\" esmoneda=\"true\"                        id=\"capital"+numFila+"\" name=\"capital\" tabindex=\""+numTab+"\" style=\"text-align:right;\" value=\""+capital+"\" onblur=\"sumaCapitalesAmor()\"/></td>" +
			"<td align=\"center\"><input type=\"text\" maxlength=\"18\" size=\"18\" esmoneda=\"true\" style=\"text-align:right;\" disabled=\"disabled\"  id=\"interes"+numFila+"\" name=\"interes\"/></td>" +
			"<td align=\"center\"><input type=\"text\" maxlength=\"18\" size=\"18\" esmoneda=\"true\" style=\"text-align:right;\" disabled=\"disabled\"  id=\"ivaInteres"+numFila+"\" name=\"ivaInteres\"/></td>";
			if(cobraSeguroCuota=="S"){
				nuevaFila = nuevaFila +
				"<td align=\"center\"><input type=\"text\" maxlength=\"18\" size=\"18\" esmoneda=\"true\" style=\"text-align:right;\" disabled=\"disabled\"  id=\"montoSeguro"+numFila+"\" name=\"montoSeguro\"/></td>" +
				"<td align=\"center\"><input type=\"text\" maxlength=\"18\" size=\"18\" esmoneda=\"true\" style=\"text-align:right;\" disabled=\"disabled\"  id=\"montoSeguroIVA"+numFila+"\" name=\"montoSeguroIVA\"/></td>";
			}
			nuevaFila = nuevaFila +
			"<td align=\"center\"><input type=\"text\" maxlength=\"18\" size=\"18\" esmoneda=\"true\" style=\"text-align:right;\" disabled=\"disabled\"  id=\"totalPago"+numFila+"\" name=\"totalPago\"/></td>" +
			"<td align=\"center\"><input type=\"text\" maxlength=\"18\" size=\"18\" esmoneda=\"true\" style=\"text-align:right;\" disabled=\"disabled\"  id=\"saldoInsoluto"+numFila+"\" name=\"saldoInsoluto\"/></td>" +
			"<td align=\"center\" nowrap=\"nowrap\">";
			if(numFila==1){
				nuevaFila= nuevaFila + "<input type=\"button\" id=\"eliminarAmor\" name=\"eliminarAmor\" class=\"btnElimina\" disabled=\"disabled\" />";
			} else {
				nuevaFila= nuevaFila + "<input type=\"button\" id=\"eliminarAmor\" name=\"eliminarAmor\" class=\"btnElimina\" onclick=\"eliminarAmortizacion('tramor"+numFila+"');\" tabindex=\""+numTab+"\" />";
			}
			nuevaFila = nuevaFila + "<input type=\"button\" id=\"agregaMinistra\" name=\"agregaAmor\" class=\"btnAgrega\" onclick=\"agregaAmortizacionReestr();\" tabindex=\""+numTab+"\"/>" +
			"</td>" +
			"</tr>";
			$("#numFila").val(numFila+1);
			$("#numTabSimulador").val(numTab);
			$('#TablaAmortizaLibresBody').append(nuevaFila);
			reasignaTabIndexSimulador();

	}
	agregaFormatoControles('formaGenerica');
}
function eliminarAmortizacion(idTr){
	var idTrLast = $('#TablaAmortizaLibresBody >tr:last').attr("id");
	if(idTr===idTrLast){
		$("#"+idTr).remove();
		$("#numTabSimulador").val($("#numTabSimulador").asNumber() - 1);
		reasignaTabIndexSimulador();
	} else {
		//Solo permitiremos que se elimine la ultima amortización para evitar mover todo el calendario.
		mensajeSis("Solo se puede Eliminar la última Amortización.");
	}
}
function reasignaTabIndexSimulador(){
	var numInicioTabs = $('#numTabMinSimulador').asNumber();
	var numFila = 1;
	var total = 0;
	var montoSolicitud = $('#montoSolici').asNumber();
	$('#TablaAmortizaLibresBody tr').each(function(index) {
		var consecutivoID = "#" + $(this).find("input[name^='consecutivoID']").attr("id");
		var capital = "#" + $(this).find("input[name^='capital']").attr("id");
		var fechaPago = "#" + $(this).find("input[name^='fechaVencim']").attr("id");
		var agrega = "#" + $(this).find("input[name^='agregaAmor']").attr("id");
		var elimina = "#" + $(this).find("input[name^='eliminarAmor']").attr("id");
		$(consecutivoID).val(numFila++);
		$(capital).attr('tabindex', numInicioTabs);
		$(fechaPago).attr('tabindex', numInicioTabs);
		$(agrega).attr('tabindex', numInicioTabs);
		$(elimina).attr('tabindex', numInicioTabs);
		total = total + $(capital).asNumber();
		numInicioTabs++;
	});
	$("#numTabSimulador").val(numInicioTabs);
	$("#diferenciaCapital").val(montoSolicitud - total.toFixed(2));
	$('#totalCap').val(total);
	$('#numFila').val(numFila) ;
}
/**
 * Método para validar las fechas en el Simulador de las Amortizaciones
 * @param esValidacionSimula : Boolean Define si la validación proviene del botón del Calcular
 * @returns {Boolean}
 */
function validarFechas(esValidacionSimula) {
	var error = 0;
	if ($("#numFila").asNumber() > 1) {
		$('#TablaAmortizaLibresBody tr').each(function(index) {
			var fechaInAmortizacion = "#" + $(this).find("input[name^='fechaInicio'").attr("id");
			var fechaVencimAmor = "#" + $(this).find("input[name^='fechaVencim'").attr("id");
			var capitalAmor = "#" + $(this).find("input[name^='capital'").attr("id");
			var fechaInAmortizacionVal = $(fechaInAmortizacion).val();
			var fechaVencimAmorVal = $(fechaVencimAmor).val();
			var capitalAmor = $(fechaInAmortizacion).asNumber();
			if (esFechaValida(fechaVencimAmorVal, $(this).find("input[name^='fechaVencim'").attr("id")) != true){
				$(fechaVencimAmor).focus();
				error++;
			}
			if (fechaInAmortizacionVal == null || fechaInAmortizacionVal == '' || fechaInAmortizacionVal == undefined) {
				mensajeSis("La Fecha de Inicio esta Vacía.");
				$(fechaInAmortizacion).focus();
				error++;
				return false;
			}
			if (fechaVencimAmorVal == null || fechaVencimAmorVal == '' || fechaVencimAmorVal == undefined) {
				mensajeSis("La Fecha de Vencimiento esta Vacía.");
				$(fechaVencimAmor).focus();
				error++;
				return false;
			}
			if (fechaVencimAmorVal < fechaInAmortizacionVal) {
				mensajeSis("La Fecha de Vencimiento es Menor a la Fecha de Inicio.");
				$(fechaVencimAmor).focus();
				error++;
				return false;
			}

			if (!esValidacionSimula) {
				if (fechaVencimAmorVal == $("#fechaVencimiento").val()) {
					mensajeSis("La Fecha de Vencimiento de la Solicitud se ha alcanzado, Ya no puede Agregar más amortizaciones.");
					$(fechaVencimAmor).focus();
					error++;
					return false;
				}
			}
			if (fechaVencimAmorVal > $("#fechaVencimiento").val()) {
				mensajeSis("La Fecha de Vencimiento de la Amortización Supera a la Fecha de Vencimiento de la Solicitud.");
				$(fechaVencimAmor).focus();
				error++;
				return false;
			}
		});
	}
	if (error == 0) {
		return true;
	} else {
		return false;
	}
}
function cambiarFechaInicioAmor(idControl){
	var cambiarFechas = false;
	idControl="#"+idControl;
	var fechaInicioAmorSig = $(idControl).val();

	$('#TablaAmortizaLibresBody tr').each(function(index) {
		var fechaInAmortizacion = "#" + $(this).find("input[name^='fechaInicio'").attr("id");
		var fechaVencimAmor = "#" + $(this).find("input[name^='fechaVencim'").attr("id");
		if(cambiarFechas){
			$(fechaInAmortizacion).val(fechaInicioAmorSig);
			$(fechaVencimAmor).val("");
			return false;
		}
		if( idControl === fechaVencimAmor){
			cambiarFechas = true;
		}
	});
}
function validaCapitalAmor(){
	quitaFormatoControles('formaGenerica');
	var error = 0;
	var montoMaxCapital = 0;
	var montoTotalAmor = 0;
	var consecutivoMinistracion = null;
	idControlCapitalFocusError = null;
	var montoCapitalSol = $('#montoSolici').val().replace(",","");
	var montoca = 0;
	var NumAmortizacionConCapital = 0;
	if($("#numFila").asNumber()>1){
		$('#TablaAmortizaLibresBody tr').each(function(index) {
			var fechaInAmortizacion = "#" + $(this).find("input[name^='fechaInicio'").attr("id");
			var fechaVencimAmor = "#" + $(this).find("input[name^='fechaVencim'").attr("id");
			var capitalAmor = "#" + $(this).find("input[name^='capital'").attr("id");
			var fechaInAmortizacionVal = $(fechaInAmortizacion).val();
			var fechaVencimAmorVal = $(fechaVencimAmor).val();
			var capitalAmorVal = $(capitalAmor).asNumber();
			montoTotalAmor = montoTotalAmor + capitalAmorVal;
			montoMaxCapital = 0;
			montoca = montoca + capitalAmorVal;
			$('#ministraciones tr').each(function(index2) {
				var fechaPagoMinis = "#" + $(this).find("input[name^='fechaPagoMinis']").attr("id");
				var fechaPagoMinisVal = $(fechaPagoMinis).val();
				if(fechaPagoMinisVal < fechaVencimAmorVal){
					var capitalMinis = "#" + $(this).find("input[name^='capitalMinis']").attr("id");
					var montoCapital = $(capitalMinis).asNumber();
					montoMaxCapital = montoMaxCapital + montoCapital;
					consecutivoMinistracion = "#" + $(this).find("input[name^='numeroMinis']").attr("id");
				}
			});

			/*Se revisa cuantas amortizaciones tienen capital para asi establecer si es frecuencia unica*/
			if(capitalAmorVal>0){
				NumAmortizacionConCapital = NumAmortizacionConCapital + 1;
			}
			montoTotalAmor = parseFloat(montoTotalAmor).toFixed(2);
			if(montoTotalAmor>montoMaxCapital){

				montoTotalAmor = montoMaxCapital - (montoTotalAmor - capitalAmorVal);
				if(montoTotalAmor > 0){
					mensajeSis("El Monto del Capital no puede ser Mayor a "+formatoMonedaVariable(montoTotalAmor)+".");
				} else if(montoTotalAmor < 0){
					var cn=$(consecutivoMinistracion).asNumber();
					mensajeSis("El Monto del Capital ya fue Cubierto en su Totalidad para la Ministración "+cn+". Cambie de Fecha de Inicio para la Iniciar con la Ministración "+cn+".");
				}

				if(idControlCapitalFocusError == null){
					idControlCapitalFocusError = capitalAmor;
					$(idControlCapitalFocusError).addClass("error");
					$(idControlCapitalFocusError).focus();
				}
				return false;
			}
			var montoTotalAmorSum = montoMaxCapital - montoTotalAmor;
		});
		if(NumAmortizacionConCapital == 1 && $('#estatus').val()=='I'){
			/*Se cambia la frecuencia del capital a Unica.*/
			$('#frecuenciaCap').val("U").selected = true;;
		} else {
			$('#frecuenciaCap').val("L").selected = true;;
		}

	}
	if(idControlCapitalFocusError !=null){
		return false;
	} else {
		return true;
	}
}
function validaCapitSimuladorAntesCal() {
	quitaFormatoControles('formaGenerica');
	var error = 0;
	var montoMaxCapital = 0;
	var montoTotalAmor = 0;
	var consecutivoMinistracion = null;
	idControlCapitalFocusError = null;
	var montoCapitalSol = $('#montoSolici').val().replace(",", "");
	var montoca = 0;

	if ($("#numFila").asNumber() > 1) {
		$('#TablaAmortizaLibresBody tr').each(function(index) {
			var fechaInAmortizacion = "#" + $(this).find("input[name^='fechaInicio'").attr("id");
			var fechaVencimAmor = "#" + $(this).find("input[name^='fechaVencim'").attr("id");
			var capitalAmor = "#" + $(this).find("input[name^='capital'").attr("id");
			var fechaInAmortizacionVal = $(fechaInAmortizacion).val();
			var fechaVencimAmorVal = $(fechaVencimAmor).val();
			var capitalAmorVal = $(capitalAmor).asNumber();
			montoTotalAmor = montoTotalAmor + capitalAmorVal;
			montoMaxCapital = 0;
			montoca = montoca + capitalAmorVal;
		});

	}


	var montoCapitalSolicitud = Number(montoCapitalSol);

	if (montoCapitalSolicitud != montoca.toFixed(2)) {
		if (idControlCapitalFocusError == null) {
			mensajeSis("El Monto del Capital de la Solicitud no coincide con la suma total de las amortizaciones.");
			return false;
		}
	}

	return true;

}
function sumaCapitalesAmor(){
	quitaFormatoControles('formaGenerica');
	var total = 0;
	var montoSolicitud = $('#montoSolici').asNumber();
	$('#TablaAmortizaLibresBody tr').each(function(index) {
		var capital = "#" + $(this).find("input[name^='capital']").attr("id");
		total = total + $(capital).asNumber();
	});

	$("#diferenciaCapital").val(montoSolicitud - total.toFixed(2));
	$('#totalCap').val(total);
	agregaFormatoControles('formaGenerica');
}
function validarSimulador(){
	var error = 0;
	if($("#numFila").asNumber()>1){
		$('#TablaAmortizaLibresBody tr').each(function(index) {
			var fechaInAmortizacion = "#" + $(this).find("input[name^='fechaInicio'").attr("id");
			var fechaVencimAmor = "#" + $(this).find("input[name^='fechaVencim'").attr("id");
			var capitalAmor = "#" + $(this).find("input[name^='capital'").attr("id");
			var fechaInAmortizacionVal = $(fechaInAmortizacion).val();
			var fechaVencimAmorVal = $(fechaVencimAmor).val();
			var capitalAmor = $(capitalAmor).asNumber();
			montoMaxCapital = 0;
			if(fechaInAmortizacionVal==null || fechaInAmortizacionVal=='' || fechaInAmortizacionVal == undefined){
				mensajeSis("La fecha de Inicio esta Vacía.");
				$(fechaInAmortizacion).focus();
				error ++;
				return false;
			}
			if(fechaVencimAmorVal==null || fechaVencimAmorVal=='' || fechaVencimAmorVal == undefined){
				mensajeSis("La fecha de Vencimiento esta Vacía.");
				$(fechaVencimAmor).focus();
				error ++;
				return false;
			}
		});
	}
	if(error == 0){
		return true;
	} else {
		return false;
	}
}
function crearMontosCapitalFecha() {
	$('#montosCapital').val("");
	var i=1;
	$('#TablaAmortizaLibresBody tr').each(function(index) {
		var fechaInAmortizacion = "#" + $(this).find("input[name^='fechaInicio'").attr("id");
		var fechaVencimAmor = "#" + $(this).find("input[name^='fechaVencim'").attr("id");
		var capitalAmor = "#" + $(this).find("input[name^='capital'").attr("id");
		var fechaInAmortizacionVal = $(fechaInAmortizacion).val();
		var fechaVencimAmorVal = $(fechaVencimAmor).val();
		var capitalAmor = $(capitalAmor).asNumber();
		if (i == 1) {
			$('#montosCapital').val($('#montosCapital').val() +
				i + ']' +
				capitalAmor+ ']' +
				fechaInAmortizacionVal+ ']' +
				fechaVencimAmorVal );
		} else {
			$('#montosCapital').val($('#montosCapital').val() + '[' +
				i + ']' +
				capitalAmor+ ']' +
				fechaInAmortizacionVal+ ']' +
				fechaVencimAmorVal );
		}
		i++;
	});
	return true;
}
/* Para ejecutar el simulador de pagos libres de capital y fecha cuando das clic en el boton calcular */
function simuladorLibresCapFec() {
	quitaFormatoControles('formaGenerica');

	//Validacion de fechas
	if(validarFechas(true)){
		//Validacion de capital
		if(validaCapitalAmor() && validaCapitSimuladorAntesCal()){
			//Se arma el array de las amortizaciones
			if (crearMontosCapitalFecha()) {
				var params = {};
				$("#calendIrregularCheck").attr('checked', 'checked');
				if ($('#calcInteresID').val() == 1) {
					tipoLista = 7;
				} else {
					if ($('#calendIrregularCheck').is(':checked')) {
						//Simulador de tasa variable
						tipoLista = 8;
					}
				}

				if ($('#diaPagoCapital1').is(':checked')) {
					auxDiaPagoCapital = "F";
				} else {
					auxDiaPagoCapital = "D";
				}
				if ($('#diaPagoInteres1').is(':checked')) {
					auxDiaPagoInteres = "F";
				} else {
					auxDiaPagoInteres = "D";
				}

				params['tipoLista'] = tipoLista;
				params['montoCredito'] = $('#montoSolici').asNumber();
				params['tasaFija'] = $('#tasaFija').asNumber();
				params['fechaInhabil'] = $('#fechInhabil').val();
				params['empresaID'] = parametroBean.empresaID;
				params['usuario'] = parametroBean.numeroUsuario;
				params['fecha'] = parametroBean.fechaSucursal;
				params['direccionIP'] = parametroBean.IPsesion;
				params['sucursal'] = parametroBean.sucursal;
				params['montosCapital'] = $('#montosCapital').val();
				params['pagaIva'] = $('#pagaIva').val();
				params['iva'] = $('#iva').asNumber();
				params['producCreditoID'] = $('#productoCreditoID').val();
				params['clienteID'] = $('#clienteID').val();
				params['prospectoID'] = $('#prospectoID').val();
				params['montoComision'] = $('#montoComApert').asNumber();
				params['cobraSeguroCuota'] = $('#cobraSeguroCuota option:selected').val();
				params['cobraIVASeguroCuota'] = $('#cobraIVASeguroCuota option:selected').val();
				params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
				params['ministraciones'] = $('#detalleMinistraAgro').val();
				params['solicitudCreditoID'] = $('#solicitudCreditoID').val();
				params['creditoID'] = 0;

				bloquearPantalla();
				var numeroError = 0;
				var mensajeTransaccion = "";
				$.post("simPagLibresAgroCredito.htm", params, function(data) {
					if (data.length > 0) {
						$('#contenedorSimulador').html("");
						$('#contenedorSimulador').hide();
						$('#contenedorSimuladorLibre').html(data);
						if ($("#numeroErrorList").length) {
							numeroError = $('#numeroErrorList').asNumber();
							mensajeTransaccion = $('#mensajeErrorList').val();
						}

						if (numeroError == 0) {
							$('#contenedorSimuladorLibre').show();
							var valorTransaccion = $('#transaccion').val();
							$('#numTransacSim').val(valorTransaccion);
							// actualiza la nueva fecha de vencimiento que devuelve el
							// cotizador
							var jqFechaVen = eval("'#valorFecUltAmor'");
							$('#fechaVencimiento').val($(jqFechaVen).val());
							$('#contenedorForma').unblock();
							// actualiza el numero de cuotas generadas por el cotizador
							$('#numAmortInteres').val($('#valorCuotasInteres').val());
							$('#numAmortizacion').val($('#valorCuotasCapital').val());
							habilitarBotonesSol();
							$('#totalCap').val(totalizaCap());
							$('#totalInt').val(totalizaInt());
							$('#totalIva').val(totalizaIva());
							$('#totalCap').formatCurrency({
								positiveFormat : '%n',
								roundToDecimalPlace : 2
							});
							$('#totalInt').formatCurrency({
								positiveFormat : '%n',
								roundToDecimalPlace : 2
							});
							$('#totalIva').formatCurrency({
								positiveFormat : '%n',
								roundToDecimalPlace : 2
							});

							$("#imprimirRep").css({
								display : "block"
							});
							$('#CAT').val($('#valorCat').val());
							$('#CAT').formatCurrency({
								positiveFormat : '%n',
								roundToDecimalPlace : 1
							});

							if( $('#lineaCreditoID').asNumber() > 0 &&  $('#manejaComGarantia').val() == 'S'){
								simulacionPagoGarantiasAgro();
							}
						}
					} else {
						$('#contenedorSimulador').html("");
						$('#contenedorSimulador').hide();
						$('#contenedorSimuladorLibre').html("");
						$('#contenedorSimuladorLibre').hide();
					}
					/****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
					if (numeroError != 0) {
						$('#contenedorForma').unblock({
							fadeOut : 0,
							timeout : 0
						});
						mensajeSisError(numeroError, mensajeTransaccion);
					}
					/**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
				});
			}
		}
	}
	agregaFormatoControles('formaGenerica');
}


/* Para ejecutar el simulador de pagos libres de capital y fecha cuando das clic en el boton calcular, REESTRUCTURAS*/
function simuladorLibresCapFecReest() {
	quitaFormatoControles('formaGenerica');

	//Validacion de fechas
	if(validarFechas(true)){
		//Validacion de capital
		if(validaCapitSimuladorAntesCal()){
			//Se arma el array de las amortizaciones
			if (crearMontosCapitalFecha()) {
				var params = {};
				$("#calendIrregularCheck").attr('checked', 'checked');
				if ($('#calcInteresID').val() == 1) {
					tipoLista = 15;
				} else {
					if ($('#calendIrregularCheck').is(':checked')) {
						//Simulador de tasa variable
						tipoLista = 8;
					}
				}

				if ($('#diaPagoCapital1').is(':checked')) {
					auxDiaPagoCapital = "F";
				} else {
					auxDiaPagoCapital = "D";
				}
				if ($('#diaPagoInteres1').is(':checked')) {
					auxDiaPagoInteres = "F";
				} else {
					auxDiaPagoInteres = "D";
				}

				params['tipoLista'] = tipoLista;
				params['montoCredito'] = $('#montoSolici').asNumber();
				params['tasaFija'] = $('#tasaFija').asNumber();
				params['fechaInhabil'] = $('#fechInhabil').val();
				params['empresaID'] = parametroBean.empresaID;
				params['usuario'] = parametroBean.numeroUsuario;
				params['fecha'] = parametroBean.fechaSucursal;
				params['direccionIP'] = parametroBean.IPsesion;
				params['sucursal'] = parametroBean.sucursal;
				params['montosCapital'] = $('#montosCapital').val();
				params['pagaIva'] = $('#pagaIva').val();
				params['iva'] = $('#iva').asNumber();
				params['producCreditoID'] = $('#productoCreditoID').val();
				params['clienteID'] = $('#clienteID').val();
				params['prospectoID'] = $('#prospectoID').val();
				params['montoComision'] = $('#montoComApert').asNumber();
				params['cobraSeguroCuota'] = $('#cobraSeguroCuota option:selected').val();
				params['cobraIVASeguroCuota'] = $('#cobraIVASeguroCuota option:selected').val();
				params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
				params['ministraciones'] = $('#detalleMinistraAgro').val();
				params['solicitudCreditoID'] = $('#solicitudCreditoID').val();
				params['creditoID'] = 0;

				bloquearPantalla();
				var numeroError = 0;
				var mensajeTransaccion = "";
				$.post("simPagLibresReestAgroCredito.htm", params, function(data) {
					if (data.length > 0) {
						$('#contenedorSimulador').html("");
						$('#contenedorSimulador').hide();
						$('#contenedorSimuladorLibre').html(data);
						if ($("#numeroErrorList").length) {
							numeroError = $('#numeroErrorList').asNumber();
							mensajeTransaccion = $('#mensajeErrorList').val();
						}

						if (numeroError == 0) {
							$('#contenedorSimuladorLibre').show();
							var valorTransaccion = $('#transaccion').val();
							$('#numTransacSim').val(valorTransaccion);
							// actualiza la nueva fecha de vencimiento que devuelve el
							// cotizador
							var jqFechaVen = eval("'#valorFecUltAmor'");
							$('#fechaVencimiento').val($(jqFechaVen).val());
							$('#contenedorForma').unblock();
							// actualiza el numero de cuotas generadas por el cotizador
							$('#numAmortInteres').val($('#valorCuotasInteres').val());
							$('#numAmortizacion').val($('#valorCuotasCapital').val());
							habilitarBotonesSol();
							$('#totalCap').val(totalizaCap());
							$('#totalInt').val(totalizaInt());
							$('#totalIva').val(totalizaIva());
							$('#totalCap').formatCurrency({
								positiveFormat : '%n',
								roundToDecimalPlace : 2
							});
							$('#totalInt').formatCurrency({
								positiveFormat : '%n',
								roundToDecimalPlace : 2
							});
							$('#totalIva').formatCurrency({
								positiveFormat : '%n',
								roundToDecimalPlace : 2
							});

							$("#imprimirRep").css({
								display : "block"
							});
							$('#CAT').val($('#valorCat').val());
							$('#CAT').formatCurrency({
								positiveFormat : '%n',
								roundToDecimalPlace : 1
							});

							if( $('#lineaCreditoID').asNumber() > 0 &&  $('#manejaComGarantia').val() == 'S'){
								simulacionPagoGarantiasAgro();
							}
						}
					} else {
						$('#contenedorSimulador').html("");
						$('#contenedorSimulador').hide();
						$('#contenedorSimuladorLibre').html("");
						$('#contenedorSimuladorLibre').hide();
					}
					/****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
					if (numeroError != 0) {
						$('#contenedorForma').unblock({
							fadeOut : 0,
							timeout : 0
						});
						mensajeSisError(numeroError, mensajeTransaccion);
					}
					/**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
				});
			}
		}
	}
	agregaFormatoControles('formaGenerica');
}

function simuladorPagosLibresTasaVar(numTransac, cuotas) {
	var mandar = crearMontosCapital(numTransac);
	$('#numAmortizacion').val(cuotas);
	$('#numTransacSim').val(numTransac);
	var jqFechaVen = eval("'#fechaVencim" + cuotas + "'");
	$('#fechaVencimiento').val($(jqFechaVen).val());
	if (mandar == 2) {
		var params = {};

		quitaFormatoControles('formaGenerica');

		if ($('#calcInteresID').val() == 1) {
			switch ($('#tipoPagoCapital').val()) {
				case "C": // SI ES CRECIENTE
					tipoLista = 1;
					break;
				case "I": // SI ES IGUAL
					tipoLista = 2;
					break;
				case "L": // SI ES LIBRE
					tipoLista = 3;
					break;
				default:
					tipoLista = 1;
				break;
			}
		} else {
			switch ($('#tipoPagoCapital').val()) {
				case "I": // SI ES IGUAL
					tipoLista = 2;
					break;
				case "L": // SI ES LIBRE
					tipoLista = 5;
					break;
				default:
					tipoLista = 2;
				break;
			}
		}

		params['tipoLista'] = tipoLista;
		params['montoCredito'] = $('#montoSolici').val();
		params['producCreditoID'] = $('#productoCreditoID').val();
		params['clienteID'] = $('#clienteID').val();

		params['empresaID'] = parametroBean.empresaID;
		params['usuario'] = parametroBean.numeroUsuario;
		params['fecha'] = parametroBean.fechaSucursal;
		params['direccionIP'] = parametroBean.IPsesion;
		params['sucursal'] = parametroBean.sucursal;
		params['numTransaccion'] = $('#numTransacSim').val();
		params['numTransacSim'] = $('#numTransacSim').val();

		params['montosCapital'] = $('#montosCapital').val();
		params['cobraSeguroCuota'] = $('#cobraSeguroCuota option:selected').val();
		params['cobraIVASeguroCuota'] = $('#cobraIVASeguroCuota option:selected').val();
		params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
		params['solicitudCreditoID'] = $('#solicitudCreditoID').val();
		params['creditoID'] = 0;
		var numeroError = 0;
		var mensajeTransaccion = "";

		$.post("simPagLibresAgroCredito.htm", params, function(data) {
			if (data.length > 0) {
				$('#contenedorSimulador').html(data);
				if ($("#numeroErrorList").length) {
					numeroError = $('#numeroErrorList').asNumber();
					mensajeTransaccion = $('#mensajeErrorList').val();
				}
				$('#contenedorSimulador').show();

				var valorTransaccion = $('#transaccion').val();
				$('#numTransacSim').val(valorTransaccion);
				mensajeSis("Datos Guardados");
				$('#totalCap').val(totalizaCap());
				$('#totalInt').val(totalizaInt());
				$('#totalIva').val(totalizaIva());
				$('#totalCap').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				$('#totalInt').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				$('#totalIva').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				$("#imprimirRep").css({
					display : "block"
				});
			} else {
				$('#contenedorSimulador').html("");
				$('#contenedorSimulador').show();
			}
			/****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
			if (numeroError != 0) {
				$('#contenedorForma').unblock({
					fadeOut : 0,
					timeout : 0
				});
				mensajeSisError(numeroError, mensajeTransaccion);
			}
			/**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
		});
	}

}
function validaUltimaCuotaCapSimulador() {

	var procede = 0;
	if ($('#tipoPagoCapital').val() == "L") {
		var numAmortizacion = $('input[name=capital]').length;
		for (var i = 1; i <= numAmortizacion; i++) {
			if (i == numAmortizacion) {
				var idCapital = eval("'#capital" + i + "'");
				if ($(idCapital).asNumber() == 0) {
					document.getElementById("capital" + i + "").focus();
					document.getElementById("capital" + i + "").select();
					$("capital" + i).addClass("error");
					mensajeSis("La Última Cuota de Capital no puede ser Cero.");
					procede = 1;
				} else {
					if ($('#diferenciaCapital').asNumber() == 0) {
						procede = 0;
					} else {
						mensajeSis(" La Suma de capital en Amortizaciones debe ser igual al Monto Solicitado.");
						procede = 1;
					}
				}
			} else {
				if ($('#diferenciaCapital').asNumber() == 0) {
					procede = 0;
				} else {
					mensajeSis(" La Suma de capital en Amortizaciones debe ser igual al Monto Solicitado.");
					procede = 1;
				}
			}
		}
	} else {
		/*
		 * se valida que si el tipo de pago de capital es libre, no se pueda  escoger como frecuencia la opcion de libre  */
		if ($('#frecuenciaInt').val() == "L" && $('#calendIrregular').val() == "N") {
			mensajeSis("La Frecuencia de Interés Libre sólo Aplica para Calendario Irregular.");
			$('#frecuenciaInt').focus();
			$('#frecuenciaInt').val("");
			procede = 1;
		} else {
			if ($('#frecuenciaCap').val() == "L" && $('#calendIrregular').val() == "N") {
				mensajeSis("La Frecuencia de Capital Libre sólo Aplica para Calendario Irregular.");
				$('#frecuenciaCap').focus();
				$('#frecuenciaCap').val("");
				procede = 1;
			} else {
				procede = 0;
			}
		}
	}
	return procede;
}
/* simulador de pagos libres de capital */
function simuladorPagosLibres(numTransac) {

	$('#numTransacSim').val(numTransac);
	var procedeCalculo = validaUltimaCuotaCapSimulador();
	if (procedeCalculo == 0) {
		var mandar = crearMontosCapital(numTransac);
		var diaHabilSig;
		if (mandar == 2) {
			var params = {};
			if ($('#calcInteresID').val() == 1) {
				switch ($('#tipoPagoCapital').val()) {
					case "C": // SI ES CRECIENTE
						tipoLista = 1;
						break;
					case "I": // SI ES IGUAL
						tipoLista = 2;
						break;
					case "L": // SI ES LIBRE
						tipoLista = 3;
						break;
					default:
						tipoLista = 1;
					break;
				}
			} else {
				switch ($('#tipoPagoCapital').val()) {
					case "I": // SI ES IGUAL
						tipoLista = 4;
						break;
					case "L": // SI ES LIBRE
						tipoLista = 5;
						break;
					default:
						tipoLista = 4;
					break;
				}
			}

			params['tipoLista'] = tipoLista;
			params['montoCredito'] = $('#montoSolici').asNumber();
			params['tasaFija'] = $('#tasaFija').val();
			params['producCreditoID'] = $('#productoCreditoID').val();
			params['clienteID'] = $('#clienteID').val();
			params['fechaInhabil'] = $('#fechInhabil').val();
			params['empresaID'] = parametroBean.empresaID;
			params['usuario'] = parametroBean.numeroUsuario;
			params['fecha'] = parametroBean.fechaSucursal;
			params['direccionIP'] = parametroBean.IPsesion;
			params['sucursal'] = parametroBean.sucursal;
			params['numTransaccion'] = $('#numTransacSim').val();
			params['numTransacSim'] = $('#numTransacSim').val();
			params['montosCapital'] = $('#montosCapital').val();
			params['montoComision'] = $('#montoComApert').asNumber();
			params['cobraSeguroCuota'] = $('#cobraSeguroCuota option:selected').val();
			params['cobraIVASeguroCuota'] = $('#cobraIVASeguroCuota option:selected').val();
			params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
			params['solicitudCreditoID'] = $('#solicitudCreditoID').val();
			params['creditoID'] = 0;

			bloquearPantalla();
			var numeroError = 0;
			var mensajeTransaccion = "";
			$.post("simPagLibresAgroCredito.htm", params, function(data) {
				if (data.length > 0) {
					$('#contenedorSimulador').html("");
					$('#contenedorSimulador').hide();
					$('#contenedorSimuladorLibre').html(data);
					if ($("#numeroErrorList").length) {
						numeroError = $('#numeroErrorList').asNumber();
						mensajeTransaccion = $('#mensajeErrorList').val();
					}
					if (numeroError == 0) {
						$('#contenedorSimuladorLibre').show();
						var valorTransaccion = $('#transaccion').val();
						$('#numTransacSim').val(valorTransaccion);
						$('#contenedorForma').unblock();
						// actualiza la nueva fecha de vencimiento que devuelve el
						// cotizador
						var jqFechaVen = eval("'#valorFecUltAmor'");
						$('#fechaVencimiento').val($(jqFechaVen).val());
						// actualiza el numero de cuotas generadas por el cotizador
						$('#numAmortInteres').val($('#valorCuotasInteres').val());
						$('#numAmortizacion').val($('#valorCuotasCapital').val());
						habilitarBotonesSol();
						$('#totalCap').val(totalizaCap());
						$('#totalInt').val(totalizaInt());
						$('#totalIva').val(totalizaIva());
						$('#totalCap').formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 2
						});
						$('#totalInt').formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 2
						});
						$('#totalIva').formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 2
						});

						$('#CAT').val($('#valorCat').val());
						$('#CAT').formatCurrency({
							positiveFormat : '%n',
							roundToDecimalPlace : 1
						});
						$("#imprimirRep").css({
							display : "block"
						});
					}
				} else {
					$('#contenedorSimulador').html("");
					$('#contenedorSimulador').show();
				}
				/****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
				if (numeroError != 0) {
					$('#contenedorForma').unblock({
						fadeOut : 0,
						timeout : 0
					});
					mensajeSisError(numeroError, mensajeTransaccion);
				}
				/**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
			});
		}
	}

}// fin simuladorPagosLibres
function simuladorPagosLibresTasaVar(numTransac, cuotas) {
	var mandar = crearMontosCapital(numTransac);
	$('#numAmortizacion').val(cuotas);
	$('#numTransacSim').val(numTransac);
	var jqFechaVen = eval("'#fechaVencim" + cuotas + "'");
	$('#fechaVencimiento').val($(jqFechaVen).val());
	if (mandar == 2) {
		var params = {};

		quitaFormatoControles('formaGenerica');

		if ($('#calcInteresID').val() == 1) {
			switch ($('#tipoPagoCapital').val()) {
				case "C": // SI ES CRECIENTE
					tipoLista = 1;
					break;
				case "I": // SI ES IGUAL
					tipoLista = 2;
					break;
				case "L": // SI ES LIBRE
					tipoLista = 3;
					break;
				default:
					tipoLista = 1;
				break;
			}
		} else {
			switch ($('#tipoPagoCapital').val()) {
				case "I": // SI ES IGUAL
					tipoLista = 2;
					break;
				case "L": // SI ES LIBRE
					tipoLista = 5;
					break;
				default:
					tipoLista = 2;
				break;
			}
		}

		params['tipoLista'] = tipoLista;
		params['montoCredito'] = $('#montoSolici').val();
		params['producCreditoID'] = $('#productoCreditoID').val();
		params['clienteID'] = $('#clienteID').val();

		params['empresaID'] = parametroBean.empresaID;
		params['usuario'] = parametroBean.numeroUsuario;
		params['fecha'] = parametroBean.fechaSucursal;
		params['direccionIP'] = parametroBean.IPsesion;
		params['sucursal'] = parametroBean.sucursal;
		params['numTransaccion'] = $('#numTransacSim').val();
		params['numTransacSim'] = $('#numTransacSim').val();

		params['montosCapital'] = $('#montosCapital').val();
		params['cobraSeguroCuota'] = $('#cobraSeguroCuota option:selected').val();
		params['cobraIVASeguroCuota'] = $('#cobraIVASeguroCuota option:selected').val();
		params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
		params['solicitudCreditoID'] = $('#solicitudCreditoID').val();
		params['creditoID'] = 0;
		var numeroError = 0;
		var mensajeTransaccion = "";

		$.post("simPagLibresAgroCredito.htm", params, function(data) {
			if (data.length > 0) {
				$('#contenedorSimulador').html(data);
				if ($("#numeroErrorList").length) {
					numeroError = $('#numeroErrorList').asNumber();
					mensajeTransaccion = $('#mensajeErrorList').val();
				}
				$('#contenedorSimulador').show();

				var valorTransaccion = $('#transaccion').val();
				$('#numTransacSim').val(valorTransaccion);
				mensajeSis("Datos Guardados");
				$('#totalCap').val(totalizaCap());
				$('#totalInt').val(totalizaInt());
				$('#totalIva').val(totalizaIva());
				$('#totalCap').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				$('#totalInt').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				$('#totalIva').formatCurrency({
					positiveFormat : '%n',
					roundToDecimalPlace : 2
				});
				$("#imprimirRep").css({
					display : "block"
				});
			} else {
				$('#contenedorSimulador').html("");
				$('#contenedorSimulador').show();
			}
			/****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
			if (numeroError != 0) {
				$('#contenedorForma').unblock({
					fadeOut : 0,
					timeout : 0
				});
				mensajeSisError(numeroError, mensajeTransaccion);
			}
			/**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
		});
	}

}
/**
 * Método para validar si la fecha es mayor a la fecha 2
 * @param fecha : Fecha Mayor
 * @param fecha2: Fecha Menor
 * @returns {Boolean}
 */
function mayor(fecha, fecha2) { // valida si fecha > fecha2: true else false
	//0|1|2|3|4|5|6|7|8|9|
	//2 0 1 2 / 1 1 / 2 0
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


function habilitarBotonesSol() {
	if ($('#solicitudCreditoID').val() == '0') {
		deshabilitaBoton('modificar', 'submit');
		deshabilitaBoton('liberar', 'submit');
		habilitaBoton('agregar', 'submit');

	} else {
		if ($('#estatus').val() != 'I') {
			if ($('#estatus').val() == 'A' || $('#estatus').val() == 'D' || $('#estatus').val() == 'L' || $('#estatus').val() == 'C') {
				deshabilitaBoton('modificar', 'submit');
				deshabilitaBoton('liberar', 'submit');
				deshabilitaBoton('agregar', 'submit');
			}
		} else {
			// si la solicitud es inactiva valida que el promotor pueda liberar la solicitud de credito si
			// corresponde con la sucursal  o si el promotor no atiende sucursal
			if ($('#sucursalID').val() == $('#sucursalPromotor').val() || $('#promAtiendeSuc').val() == 'N') {
				// si se trata de una solicitud individual entonces se muestra y  habilita
				// el boton de liberar, en caso contrario se oculta  si se trata de una solicitud individual entonces se muestra
				// el div  de comentarios, en caso contrario se oculta
				if ($('#grupo').val() != undefined) {
					deshabilitaBoton('liberar', 'submit');
				} else {
					if ($('#flujoIndividualBandera').val() == undefined) {
						habilitaBoton('liberar', 'submit');
					} else {
						deshabilitaBoton('liberar', 'submit');
					}
				}
				habilitaBoton('modificar', 'submit');
				deshabilitaBoton('agregar', 'submit');
				$('#simular').show();
			} else {
				deshabilitaBoton('liberar', 'submit');
				deshabilitaBoton('modificar', 'submit');
				deshabilitaBoton('agregar', 'submit');
			}
		}
	}
}


function simulacionPagoGarantiasAgro(){

	var lineaCreditoID		= null;
	var solicitudCreditoID	= null;
	var creditoID			= null;
	var ministracionID		= null;
	var transaccionID		= null;

	if( $('#lineaCreditoID').asNumber() > 0 ){
		lineaCreditoID = $('#lineaCreditoID').asNumber();
	}

	if( $('#solicitudCreditoID').asNumber() > 0 ){
		solicitudCreditoID = $('#solicitudCreditoID').asNumber();
	}

	if( $('#numTransacSim').asNumber() > 0 ){
		transaccionID = $('#numTransacSim').asNumber();
	}

	var creditosBean = {
		lineaCreditoID		: lineaCreditoID,
		solicitudCreditoID	: solicitudCreditoID,
		creditoID			: creditoID,
		ministracionID		: ministracionID,
		transaccionID		: transaccionID,
		montoCredito 		: $('#montoSolici').asNumber(),
		fechaVencimiento 	: $('#fechaVencimiento').val(),
		tipoTransaccion		: 41,
		tipoActualizacion	: 0
	};

	bloquearPantalla();
	$.post('simulacionPagoGarantiasAgro.htm', creditosBean,
		function(creditosBeanResponse) {
			desbloquearPantalla();
			if (creditosBeanResponse != null) {
				if( creditosBeanResponse.numero == 0 ){

					$('#montoComGarantia').val(creditosBeanResponse.consecutivoString);
					$('#montoComGarantia').formatCurrency({
						positiveFormat : '%n',
						roundToDecimalPlace : 2
					});

					var clientePagaIVA = $('#pagaIVACte').val();
					var montoIVAComGarantia = 0.00;
					if( clientePagaIVA == 'S'){
						montoIVAComGarantia = $('#montoComGarantia').asNumber() * parametroBean.ivaSucursal;
						montoIVAComGarantia =  montoIVAComGarantia.toFixed(2);
					}

					$('#montoIvaComGarantia').val(montoIVAComGarantia);
					$('#montoIvaComGarantia').formatCurrency({
						positiveFormat : '%n',
						roundToDecimalPlace : 2
					});

				} else {
					mensajeSis(creditosBeanResponse.numero +' - '+ creditosBeanResponse.descripcion);
				}
			} else {
				mensajeSis("Error en la simulación de pagos de servicios en garantías.");
			}
		}
	);
}