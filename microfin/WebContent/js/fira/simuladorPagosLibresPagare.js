var idControlMinistraFocusError = null;
var idControlCapitalFocusError = null;
var simulacionRealizada = false;
//Campos para validar en caso de que se haya generado el simulador
var valorAnteriorMinistra = null;
var numTransaccionSimula = 0;
var numTransaccionInicGrupo = 0;//Número de transaccion de credito grupal de tipo operacion formal;
var tipoOperacionGrupo = '';
var tipoOperacion = {
	'global': 'G',
	'noFormal': 'NF'
};
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
				+ '	<td><input id="capitalMinis' + fila + '" name="capitalMinis" type="text" maxlength="10" size="20" esMoneda="true" style="text-align:right;" onchange="validaTablaMinistraciones(true,this.id,false,true)" tabindex="' + numTab + '"></td>'
				+ '	<td nowrap="nowrap">' + '		<input type="button" id="eliminarMinistra' + fila + '" name="eliminarMinistra" value="" class="btnElimina" onclick="eliminarMinistracion(' + fila + ')" disabled="disabled"/>' + '		<input type="button" id="agregaMinistra' + fila + '" name="agregaMinistra" value="" class="btnAgrega" onclick="agregarMinistracion(this.id)" tabindex="' + numTab + '"/>' + '	</td>' + '</tr>';
			} else {
				var idFechaPago = $('#ministraciones tr:last').find("input[name^='fechaPagoMinis']").attr("id");
				esTab=true;
				var fecha = sumaDiasFechaHabil(sumaFechaHabil, $('#' + idFechaPago).val(), 1, 1, 'S');
				nuevaFila = '<tr id="pagoMinistra' + fila + '" name="tr">' + '	<td><input id="numeroMinis' + fila + '" name="numeroMinis" type="text" maxlength="10" size="11" readonly="true" disabled="disabled" value="' + fila + '"></td>'
				+ '	<td><input id="fechaPagoMinis' + fila + '" name="fechaPagoMinis" type="text" maxlength="10" size="16" esCalendario="true" onblur="guardaValorTemporal(this.id);validaTablaMinistraciones(false,this.id,true,false);" onchange="validaTablaMinistraciones(true,this.id,true,false)" tabindex="' + numTab + '" value="' + fecha.fecha + '"></td>'
				+ '	<td><input id="capitalMinis' + fila + '" name="capitalMinis" type="text" maxlength="10" size="20" esMoneda="true" style="text-align:right;" onblur="validaTablaMinistraciones(false,this.id,false, true)" onchange="validaTablaMinistraciones(true,this.id,false, true)" tabindex="' + numTab + '"></td>'
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
	numTransaccionSimula = $('#numTransacSim').asNumber();
	if(numTransaccionSimula>0 && idControl !='graba'){
		simulacionRealizada = true;
		$('#numTransacSim').val("0");
	}
	//Si ya se realizo la simulación avisarle al usuario que si modifica las ministraciones se eliminaran todas las amortizaciones
	if (simulacionRealizada && esOnchange && idControl!='graba') {
		if (confirm("La Simulación ya se realizó. Si Modifica o Agrega Ministraciones se eliminarán todas las Amortizaciones.  \n¿Desea continuar con la operación?")) {
			//Se Eliminaran todas las amortizaciones
			$('#contenedorSimuladorLibre').html("");
			$('#gridAmortizacion').html("");
			$('#contenedorSimuladorLibre').hide();
			$('#gridAmortizacion').show();
			simulacionRealizada = false;
			$('#simular').show();
			deshabilitaBoton('grabar', 'submit');
			habilitaBoton('simular', 'submit');
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
	var fechaVencimiento = $('#fechaVencimien').val();
	if(fechaVencimiento == undefined || fechaVencimiento ==''){
		mensajeSis("La Fecha de Vencimiento esta Vacia");
		$('#fechaVencimien').addClass("error");
		if (idControlMinistraFocusError == null) {
			idControlMinistraFocusError = '#fechaVencimien';
			if (idControlMinistraFocusError != null) {
				$(idControlMinistraFocusError).focus();
				return false;
			}
		}
	} else {
		$('#fechaVencimien').removeClass("error");
	}
	var montoSolicitado = $('#montoCredito').asNumber();
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
	montoSolicitado = $('#montoCredito').asNumber();
	totalDif = 0;

	// Se obtiene por aparte los totales del capital
	$('#ministraciones tr').each(function(index) {
		var capitalMinis = "#" + $(this).find("input[name^='capitalMinis']").attr("id");
		var montoCapital = $(capitalMinis).asNumber();
		total = total + $(capitalMinis).asNumber();
		totalDif = $("#montoCredito").asNumber() - total;
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

			if( $("#esConsolidacionAgro").val() == 'S'){
				$("#fechaPagoMinis1").attr('readonly', true);
				$("#fechaPagoMinis1").datepicker("destroy");
				deshabilitaControl('fechaPagoMinis1');
			}
		} else {
			$("#gridMinistraCredAgro").html("");
			$("#gridMinistraCredAgro").show();
		}
	});
}
function consultaMinistracionesGrupales(solCred) {
	$("#gridMinistraCredAgro").html("");
	var solicitudC=$('#solicitudCreditoID').asNumber();
	var tipoListaMin = 4;
	if(solicitudC>0){
		tipoListaMin = 5;
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
			agregaFormatoControles('formaGenerica');
		} else {
			$("#gridMinistraCredAgro").html("");
			$("#gridMinistraCredAgro").show();
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
	esTab=true;
	if (validaTablaMinistraciones(true, 'graba', true, true)){
		var ministraDiferencia = $("#diferenciaMinistra").val().replace(",", "");
		if(parseFloat(ministraDiferencia)>0.00){
			mensajeSis("Aún existe Capital pendiente por Ministrar.");
		} else if (llenarDetalle()) {
			if ($('#grupo').val() != '' && $('#grupo').val() != undefined) {
				if (numTransaccionInicGrupo != undefined && numTransaccionInicGrupo != null && numTransaccionInicGrupo != 0 && tipoOperacionGrupo == tipoOperacion.noFormal) {
					consultaSimulador();
				} else {
					mostrarSimuladorLibres();
				}
			} else {
				mostrarSimuladorLibres();
			}
		}
	}
}
function mostrarSimuladorLibres(){
	var cobraSeguroCuota = $("#cobraSeguroCuota").val();
	quitaFormatoControles('formaGenerica');
	$('#contenedorSimulador').html("");
	$('#contenedorSimulador').hide();
	var montoSolicitud = $("#montoCredito").asNumber();
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
	"<input type=\"hidden\" id=\"numTabSimulador\" value=\"98\"/>" +
	"<input type=\"hidden\" id=\"numTabMinSimulador\" value=\"98\"/>" +
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
function agregaAmortizacion(){
	quitaFormatoControles('formaGenerica');
	var numTab = $("#numTabSimulador").asNumber()+1;
	var numFila = $("#numFila").asNumber();
	var capital = '';
	var fechaInicioAmor = '';
	var fechaVencimiento = '';
	if(numFila==1){
		capital = $("#montoCredito").val();
		fechaInicioAmor = $('#fechaInicioAmor').val();
		fechaVencimiento = $("#fechaVencimien").val();
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
		fechaVencimiento = $("#fechaVencimien").val();
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
	var montoSolicitud = $('#montoCredito').asNumber();
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
	$("#diferenciaCapital").val(montoSolicitud - total);
	$('#totalCap').val(total);
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
				if (fechaVencimAmorVal == $("#fechaVencimien").val()) {
					mensajeSis("La Fecha de Vencimiento de la Solicitud se ha alcanzado, Ya no puede Agregar más amortizaciones.");
					$(fechaVencimAmor).focus();
					error++;
					return false;
				}
			}
			if (fechaVencimAmorVal > $("#fechaVencimien").val()) {
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
	var montoCapitalSol = $('#montoCredito').val().replace(",","");
	var montoca = 0;

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
				if(fechaPagoMinisVal <= fechaVencimAmorVal){
					var capitalMinis = "#" + $(this).find("input[name^='capitalMinis']").attr("id");
					var montoCapital = $(capitalMinis).asNumber();
					montoMaxCapital = montoMaxCapital + montoCapital;
					consecutivoMinistracion = "#" + $(this).find("input[name^='numeroMinis']").attr("id");
				}
			});

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
	var montoCapitalSol = $('#montoCredito').val().replace(",", "");
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
	if (montoCapitalSol != montoca) {
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
	var montoSolicitud = $('#montoCredito').asNumber();
	$('#TablaAmortizaLibresBody tr').each(function(index) {
		var capital = "#" + $(this).find("input[name^='capital']").attr("id");
		total = total + $(capital).asNumber();
	});
	$("#diferenciaCapital").val(montoSolicitud - total);
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
	var mandar = false;
	var procedeCalculo = validaUltimaCuotaCapSimulador();
	if (procedeCalculo == 0) {
		mandar = crearMontosCapitalFecha();
		if (mandar && llenarDetalle()) {
			var params = {};
			tipoLista = 7;
			params['tipoLista'] = tipoLista;
			params['montoCredito'] = $('#montoCredito').asNumber();
			params['tasaFija'] = $('#tasaFija').asNumber();
			params['fechaInhabil'] = $('#fechaInhabil').val();
			params['empresaID'] = parametroBean.empresaID;
			params['usuario'] = parametroBean.numeroUsuario;
			params['fecha'] = parametroBean.fechaSucursal;
			params['direccionIP'] = parametroBean.IPsesion;
			params['sucursal'] = parametroBean.sucursal;
			params['montosCapital'] = $('#montosCapital').val();
			params['pagaIva'] = $('#pagaIva').val();
			params['iva'] = $('#iva').asNumber();
			params['producCreditoID'] = $('#producCreditoID').val();
			params['clienteID'] = $('#clienteID').val();
			params['montoComision'] = $('#montoComision').asNumber();
			params['cobraSeguroCuota'] = $('#cobraSeguroCuota option:selected').val();
			params['cobraIVASeguroCuota'] = $('#cobraIVASeguroCuota option:selected').val();
			params['montoSeguroCuota'] = $('#montoSeguroCuota').asNumber();
			params['ministraciones'] = $('#detalleMinistraAgro').val();
			params['solicitudCreditoID'] = $('#solicitudCreditoID').val();
			params['creditoID'] = $('#creditoID').val();

			bloquearPantalla();
			var numeroError = 0;
			var mensajeTransaccion = "";
			totalesAmortizaciones();
			$.post("simPagLibresAgroCredito.htm", params, function(data) {
				if (data.length > 0) {
					$('#gridAmortizacion').html("");
					$('#gridAmortizacion').hide();
					$('#contenedorSimuladorLibre').html(data);
					if ($("#numeroErrorList").length) {
						numeroError = $('#numeroErrorList').asNumber();
						mensajeTransaccion = $('#mensajeErrorList').val();
					}

					if (numeroError == 0) {
						$('#contenedorSimuladorLibre').show();
						$('#numTransacSim').val($('#transaccion').val());
						if ($('#transaccion').val() > 0) {
							deshabilitaBoton('simular', 'submit');
							habilitaBoton('grabar', 'submit');
							$('#fechaMinistradoOriginal').val($('#fechaInicioAmor').val());
							$('#simuladoNuevamente').val("S");
						} else {
							habilitaBoton('simular', 'submit');
							deshabilitaBoton('grabar', 'submit');
							$('#simuladoNuevamente').val("N");
						}


						// actualiza la nueva fecha de vencimiento que devuelve el cotizador
						var jqFechaVen = eval("'#valorFecUltAmor'");
						$('#fechaVencimien').val($(jqFechaVen).val());

						// se asigna el numero de cuotas calculadas
						$('#numAmortizacion').val($('#valorCuotasCapital').val());
						$('#numAmortInteres').val($('#valorCuotasInteres').val());

						// se debloquea el contenedor
						$('#contenedorForma').unblock();

						/****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
						if (numeroError != 0) {
							$('#contenedorForma').unblock({
								fadeOut : 0,
								timeout : 0
							});
							mensajeSisError(numeroError, mensajeTransaccion);
						}
						/**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
						totalesAmortizaciones();
					} else {

						// se debloquea el contenedor
						$('#contenedorForma').unblock();

						/****VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo **********************/
						if (numeroError != 0) {
							$('#contenedorForma').unblock({
								fadeOut : 0,
								timeout : 0
							});
							mensajeSisError(numeroError, mensajeTransaccion);
						}
						/**** FIN VALIDACION DEL SIMULADOR NOTA: No moverlo ni quitarlo ****************/
					}
				} else {
					$('#gridAmortizacion').html("");
					$('#gridAmortizacion').hide();
					$('#contenedorSimuladorLibre').html("");
					$('#contenedorSimuladorLibre').hide();
				}

			});
		}
	}
}
function simuladorPagosLibresTasaVar(numTransac, cuotas) {
	var mandar = crearMontosCapital(numTransac);
	$('#numAmortizacion').val(cuotas);
	$('#numTransacSim').val(numTransac);
	var jqFechaVen = eval("'#fechaVencim" + cuotas + "'");
	$('#fechaVencimien').val($(jqFechaVen).val());
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
		params['montoCredito'] = $('#montoCredito').val();
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
		params['creditoID'] = $('#creditoID').val();
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
				totalesAmortizaciones();

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
			tipoLista = 7;

			diaHabilSig = $('#fechInhabil').val();

			params['tipoLista'] = tipoLista;
			params['montoCredito'] = $('#montoCredito').asNumber();
			params['tasaFija'] = $('#tasaFija').val();
			params['producCreditoID'] = $('#producCreditoID').val();
			params['clienteID'] = $('#clienteID').val();
			params['fechaInhabil'] = diaHabilSig;
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
			params['creditoID'] = $('#creditoID').val();

			bloquearPantalla();
			var numeroError = 0;
			var mensajeTransaccion = "";
			$.post("simPagLibresAgroCredito.htm", params, function(data) {
				if (data.length > 0) {
					$('#gridAmortizacion').html("");
					$('#gridAmortizacion').hide();
					$('#contenedorSimuladorLibre').html(data);
					if ($("#numeroErrorList").length) {
						numeroError = $('#numeroErrorList').asNumber();
						mensajeTransaccion = $('#mensajeErrorList').val();
					}
					if (numeroError == 0) {
						$('#contenedorSimuladorLibre').show();
						$('#numTransacSim').val($('#transaccion').val());
						if ($('#transaccion').val() > 0) {
							deshabilitaBoton('simular', 'submit');
							habilitaBoton('grabar', 'submit');
							$('#fechaMinistradoOriginal').val($('#fechaInicioAmor').val());
							$('#simuladoNuevamente').val("S");
						} else {
							habilitaBoton('simular', 'submit');
							deshabilitaBoton('grabar', 'submit');
							$('#simuladoNuevamente').val("N");
						}
						$('#contenedorForma').unblock();
						// actualiza la nueva fecha de vencimiento que devuelve el
						// cotizador
						var jqFechaVen = eval("'#valorFecUltAmor'");
						$('#fechaVencimien').val($(jqFechaVen).val());
						// actualiza el numero de cuotas generadas por el cotizador
						$('#numAmortInteres').val($('#valorCuotasInteres').val());
						$('#numAmortizacion').val($('#valorCuotasCapital').val());
						habilitarBotonesSol();
						totalesAmortizaciones();

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
					$('#gridAmortizacion').html("");
					$('#gridAmortizacion').show();
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
	$('#fechaVencimien').val($(jqFechaVen).val());
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
		params['montoCredito'] = $('#montoCredito').val();
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
		params['creditoID'] = $('#creditoID').val();
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
				totalesAmortizaciones();

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
function consultaValoresPrimeraSolicitudGrupal(solCred) {
	setTimeout("$('#cajaLista').hide();", 200);
	habilitaControl('lineaFondeoID');
	habilitaControl('tipoFondeo2');
	habilitaControl('tipoFondeo');
	numTransaccionInicGrupo = 0;
	tipoOperacionGrupo = '';
	if (solCred != '' && !isNaN(solCred) && esTab) {

		if (solCred != '0') {
			var SolCredBeanCon = {
				'solicitudCreditoID' : solCred,
				'usuario' : usuario
			};
			solicitudCredServicio.consulta(9, SolCredBeanCon, {
				callback : function(solicitud) {
					if (solicitud != null && solicitud.solicitudCreditoID != 0) {
						esTab = true;

						if ($('#grupo').val() != undefined) {
							consultaGrupo('grupoID');
						}
						fechaVencimientoInicial = solicitud.fechaVencimiento;
						NumCuotas = solicitud.numAmortizacion;
						NumCuotasInt = solicitud.numAmortInteres;

						$('#grupoID').val(solicitud.grupoID);
						setCalcInteresID(solicitud.calcInteresID, false);

						// se llena la parte del calendario y valores parametrizados en el producto
						// seleccionando los que se trajo de resultado la consulta

						consultaProducCreditoForanea(solicitud.productoCreditoID, solicitud.fechaVencimiento);
						consultaGrupo('grupoID');
						numTransaccionInicGrupo = solicitud.numTransacSim;
					}
				},
				errorHandler : function(message, exception) {
					mensajeSis("Error en consulta de la Solicitud de Crédito Grupal.<br>" + message + ":" + exception);
				}
			});
		}
	}
}

function consultaGrupo(idControl) {
	var jqGrupo = eval("'#" + idControl + "'");
	var grupo = $(jqGrupo).val();
	var grupoBeanCon = {
		'grupoID' : grupo
	};
	setTimeout("$('#cajaLista').hide();", 200);
	tipoOperacionGrupo = '';
	if (grupo != '' && !isNaN(grupo)) {
		gruposCreditoServicio.consulta(15, grupoBeanCon, {
			callback : function(grupos) {
				if (grupos != null) {
					esTab = true;
					$('#nombreGr').val(grupos.nombreGrupo);
					tipoOperacionGrupo=grupos.tipoOperacion;
				} else {
					if ($('#grupoID').val() != 0 && $('#grupoID').val() != '') {
						mensajeSis("El Grupo no Existe");
						$('#nombreGr').val("");
						$('#tipoIntegrante').val("4");
						$(jqGrupo).focus();
						grupoIDBase = 0;
					}
				}
			},
			errorHandler : function(message, exception) {
				mensajeSis("Error al Consultar Grupo.<br>" + message + ":" + exception);
			}
		});
	}
}
function totalesAmortizaciones() {
	quitaFormatoControles('formaGenerica');
	var totalCapitalAmortiza = 0;
	var totalInteresAmortiza = 0;
	var totalIVAInteresAmortiza = 0;
	$('#TablaAmortizaLibresBody tr').each(function(index) {
		var capitalid = "#" + $(this).find("input[name^='capital']").attr("id");
		var interesID = "#" + $(this).find("input[name^='interes']").attr("id");
		var ivaInteresID = "#" + $(this).find("input[name^='ivaInteres']").attr("id");
		totalCapitalAmortiza = totalCapitalAmortiza + $(capitalid).asNumber();
		totalInteresAmortiza = totalInteresAmortiza + $(interesID).asNumber();
		totalIVAInteresAmortiza = totalIVAInteresAmortiza + $(ivaInteresID).asNumber();
	});
	$("#totalCap").val(totalCapitalAmortiza);
	$("#totalInt").val(totalInteresAmortiza);
	$("#totalIva").val(totalIVAInteresAmortiza);
	agregaFormatoControles('formaGenerica');
}