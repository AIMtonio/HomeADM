var parametroBean = consultaParametrosSession();
var esTab = true;
var fechaSis = (parametroBean.fechaSucursal);
$(document).ready(function() {
	/* == Métodos y manejo de eventos ====  */
	agregaFormatoControles('formaGenerica');
	consultaMontoParametrizado();
	llenaComboAnios(fechaSis);
	$('#pdf').attr("checked", true);
	$('#anio').focus();
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});

	$('#anio').change(function() {
		if ($('#periodo').val() != '') {
			var mes = $('#periodo').val();
			var mesSistema = parseInt(fechaSis.substring(5, 7));
			var anioActual = parametroBean.fechaAplicacion.substring(0, 4);
			var anioSeleccionado = $('#anio').val();

			if ($('#anio').val() == '') {
				$('#anio').focus();
				$('#periodo').val('');
				$('#fechaInicio').val('');
				$('#fechaFin').val('');
				$('#monto').val('');
			} else {
				var fechaInicio = (anioSeleccionado + '-' + mes + '-01');
				$('#fechaInicio').val(fechaInicio);

				var diasFin = diasDelMes(mes, anioSeleccionado);
				var fechaFin = (anioSeleccionado + '-' + mes + '-' + diasFin);
				$('#fechaFin').val(fechaFin);
			}
		}

	});

	$('#periodo').change(function() {
		if ($('#anio').val() != '') {
			if ($('#periodo').val() != '') {
				var mes = $('#periodo').val();
				var mesSistema = parseInt(fechaSis.substring(5, 7));
				var anioActual = parametroBean.fechaAplicacion.substring(0, 4);
				var anioSeleccionado = $('#anio').val();

				if ((parseInt(this.value) > parseInt(mesSistema)) && parseInt(anioSeleccionado) >= parseInt(anioActual)) {
					mensajeSis("El Mes Indicado es Mayor al Mes Actual del Sistema.");
					$('#periodo').val(mesSistema);
					this.focus();
				} else {
					var fechaInicio = (anioSeleccionado + '-' + mes + '-01');
					$('#fechaInicio').val(fechaInicio);

					var diasFin = diasDelMes(mes, anioSeleccionado);
					var fechaFin = (anioSeleccionado + '-' + mes + '-' + diasFin);
					$('#fechaFin').val(fechaFin);
				}

			} else {
				mensajeSis("Especificar Periodo");
				$('#periodo').focus();
				$('#fechaInicio').val('');
				$('#fechaFin').val('');
				$('#monto').val('');

			}
		} else {
			mensajeSis("Especificar Año");
			$('#anio').focus();
			$('#periodo').val('');
		}

	});

	$('#generar').click(function() {
		if ($('#anio').val() == '') {
			mensajeSis("Especificar año");
			$('#periodo').focus();
			$('#ligaGenerar').removeAttr("href");
			$('#fechaInicio').val('');
			$('#fechaFin').val('');
			$('#monto').val('');
		} else if ($('#periodo').val() == '') {
			mensajeSis("Especificar Periodo");
			$('#periodo').focus();
			$('#ligaGenerar').removeAttr("href");
			$('#fechaInicio').val('');
			$('#fechaFin').val('');
			$('#monto').val('');

		} else if ($('#monto').val() == '') {
			mensajeSis("Especificar Monto Límite");
			$('#monto').focus();
			$('#ligaGenerar').removeAttr("href");

		} else {
			generaReporte();

		}

	});

});
function diasDelMes(month, year) {
	var dias = new Date(year || new Date().getFullYear(), month, 0).getDate();
	return dias;
}
function consultaMontoParametrizado() {
	numConsulta = 2;
	var paramBean = {
		'folioID' : 1
	};
	paramPLDOpeEfecServicio.consulta(paramBean, numConsulta, function(parametros) {
		if (parametros != null) {
			var mLimEfecF = parametros.montoLimEfecF;
			var mLimEfecM = parametros.montoLimEfecM;
			var mLimEfecMes = parametros.montoLimEfecMes;

			var bean = {
			'mLimEfecF' : mLimEfecF + "|FÍSICA",
			'mLimEfecM' : mLimEfecM + "|MORAL",
			'mLimEfecMes' : mLimEfecMes + "|FÍSICA-MORAL"
			};

			$.each(bean, function(key, value) {
				var valor = value.split('|');
				$('#monto').append('<option value=' + valor[0] + '>' + valor[1] + '</option>');
			});
		}
	});
}
function generaReporte() {
	var fechaInicio = $('#fechaInicio').val();
	var fechaFin = $('#fechaFin').val();
	var monto = $('#monto').val();
	var valorMonto = ($('#monto').val()).replace(/\,/g, '');
	var valorMontoDes = $("#monto option:selected").text();

	var tipoReporte = $('input:radio[name=tipoReporte]:checked').val();
	var tipoLista = 1;
	var fechaSis = parametroBean.fechaSucursal;
	var nombreUsuario = parametroBean.claveUsuario;
	var nombreInstitucion = parametroBean.nombreInstitucion;
	var periodo = $("#periodo").val();
	var tipoPersona = "T";
	if(valorMontoDes == "FÍSICA"){
		tipoPersona = "F";
	}
	if(valorMontoDes == "MORAL"){
		tipoPersona = "M";
	}
	 
	var url = 'reporteOperLimitesExcedidos.htm?'+
		'fechaInicio=' + fechaInicio +
		'&fechaFin=' + fechaFin +
		'&montoOp=' + monto +
		'&monto=' + valorMonto +
		'&montoDes=' +valorMontoDes+
		'&tipoReporte=' + tipoReporte +
		'&tipoPersona=' + tipoPersona+
		'&tipoLista=' + tipoLista + '&fechaSistema=' + fechaSis + '&nombreUsuario=' + nombreUsuario + '&nombreInstitucion=' + nombreInstitucion + '&periodo=' + periodo;
	window.open(url, "_blank");
}
//para llenael el combo  años
function llenaComboAnios(fechaActual) {
	var anioActual = fechaActual.substring(0, 4);
	var mesActual = parseInt(fechaActual.substring(5, 7));
	var numOption = 5;

	for (var i = 0; i < numOption; i++) {
		$("#anio").append('<option value="' + anioActual + '">' + anioActual + '</option>');
		anioActual = parseInt(anioActual) - 1;
	}

	$("#periodo option[value=" + mesActual + "]").attr("selected", true);
}