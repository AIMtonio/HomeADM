esTab = false;
var tipoReportePSL = {
	'PDF': 1,
	'Excel': 2
};
var tipoReporte = tipoReportePSL.PDF;

$(document).ready(function() {
	$('#fechaInicio').focus();
	
	agregaFormatoControles('formaGenerica');
	$('#canal').val('-1');
	$('#fechaInicio').val(parametroBean.fechaSucursal);
	$('#fechaFin').val(parametroBean.fechaSucursal);
	
	listaSucursales();
	listaTiposServicio();
	listaServicios();
	listaProductos();
	
	$(':text, :button').focus(function() {
		esTab = false;
	});
	
	$(':text, :button').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	
	$('#fechaInicio').change(function() {
		var Xfecha = $('#fechaInicio').val();
		if(esFechaValida(Xfecha)){
			if(Xfecha == '')$('#fechaInicio').val(parametroBean.fechaSucursal);
			var Yfecha = $('#fechaFin').val();
			if (mayor(Xfecha, Yfecha)){
				if($('#fechaFin').val() != ''){
					mensajeSis("La fecha de inicio es mayor a la fecha de fin");
					$('#fechaInicio').val(parametroBean.fechaSucursal);
					$('#fechaFin').val(parametroBean.fechaSucursal);
				}
			}
		}else{
			$('#fechaInicio').val(parametroBean.fechaSucursal);
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}
	});
	
	$('#fechaFin').change(function() {
		var Xfecha = $('#fechaInicio').val();
		var Yfecha = $('#fechaFin').val();
		if(esFechaValida(Yfecha)){
			if(Yfecha == '')$('#fechaFin').val(parametroBean.fechaSucursal);
			if (mayor(Xfecha, Yfecha)){
				mensajeSis("La fecha de inicio es mayor a la fecha de fin");
				$('#fechaFin').val(parametroBean.fechaSucursal);
				$('#fechaInicio').val(parametroBean.fechaSucursal);
			}else{
				if($('#fechaFin').val() > parametroBean.fechaSucursal) {
					mensajeSis("La fecha de fin es mayor a la fecha del sistema");
					$('#fechaFin').val(parametroBean.fechaSucursal);
					$('#fechaInicio').val(parametroBean.fechaSucursal);
				}
			}
		}else{
			$('#fechaFin').val(parametroBean.fechaSucursal);
		}
	});
	
	$('#sucursalID').change(function () {
		$('#sucursal').val($('#sucursalID option:selected').text());
	});
	
	$('#tipoServicioID').change(function () {
		listaServicios();
		listaProductos();
		$('#tipoServicio').val($('#tipoServicioID option:selected').text());
		$('#servicioID').change();
		$('#productoID').change();
	});
	
	$('#servicioID').change(function () {
		listaProductos();
		$('#servicio').val($('#servicioID option:selected').text());
		$('#productoID').change();
	});
	
	$('#productoID').change(function () {
		$('#producto').val($('#productoID option:selected').text());
	});
	
	$('input:checkbox[name="chkCanal"]').change(function () {
		
		if((!$('#chkVentanilla').is(':checked') && !$('#chkLinea').is(':checked') && !$('#chkMovil').is(':checked'))){
			$('#canal').val('-1');
			return;
		}
		
		if (($('#chkVentanilla').is(':checked') && $('#chkLinea').is(':checked') && $('#chkMovil').is(':checked'))) {
			$('#canal').val('');
			return;
		}
		if ($('#chkVentanilla').is(':checked') && !$('#chkLinea').is(':checked') && !$('#chkMovil').is(':checked')) {
			$('#canal').val('V');
			return;
		}
		if (!$('#chkVentanilla').is(':checked') && $('#chkLinea').is(':checked') && !$('#chkMovil').is(':checked')) {
			$('#canal').val('L');
			return;
		}
		if (!$('#chkVentanilla').is(':checked') && !$('#chkLinea').is(':checked') && $('#chkMovil').is(':checked')) {
			$('#canal').val('M');
			return;
		}
		if ($('#chkVentanilla').is(':checked') && $('#chkLinea').is(':checked') && !$('#chkMovil').is(':checked')) {
			$('#canal').val('VL');
			return;
		}
		if ($('#chkVentanilla').is(':checked') && !$('#chkLinea').is(':checked') && $('#chkMovil').is(':checked')) {
			$('#canal').val('VM');
			return;
		}
		if (!$('#chkVentanilla').is(':checked') && $('#chkLinea').is(':checked') && $('#chkMovil').is(':checked')) {
			$('#canal').val('LM');
			return;
		}
	});
	
	$('input:radio[name="opcionesReporte"]').click(function() {
		if($('input:radio[name="opcionesReporte"]:checked').val() == "pdf") {
			tipoReporte = tipoReportePSL.PDF;
		}
		if($('input:radio[name="opcionesReporte"]:checked').val() == "excel") {
			tipoReporte = tipoReportePSL.Excel;
		}
	});
	
	$('#generar').blur(function() {
		if (esTab) {
			$('#fechaInicio').focus();
		}
	});
	
	$('#generar').click(function() {		
		if($('#canal').val() == '-1') {
			mensajeSis("Especifique el(los) canal(es)");
			return;
		}

		if ($('#formaGenerica').valid()) {
			funcionGenerarReportePSL();
		}
	});

	function stringToDate(strDate) {
		if(strDate == null || strDate == "") {
	    	strDate = '1900-01-01';
	    }

		var parts = strDate.split('-');
		var date = new Date(parts[0], parts[1] - 1, parts[2]); 

		return date;
	}

	$.validator.addMethod("minDate", function(value, element) {
	    var strFechaInicio = $("#fechaInicio").val();
	    var fechaInicio = stringToDate(strFechaInicio);

	    var fechaFin = stringToDate(value);
		return fechaFin >= fechaInicio;
	}, "Invalid Date!");   // error message
	
	$('#formaGenerica').validate({
		rules: {
			fechaInicio: {
				required: true,
				date: true
			},
			fechaFin: {
				required: true,
				date: true,
				minDate: true
			},
			sucursalID: {
				required: true
			},
			servicioID: {
				required: true
			},
			productoID: {
				required: true
			}
		},
		messages: {
			fechaInicio: {
				required: 'Especifique fecha',
				date: 'Especifique fecha válida'
			},
			fechaFin: {
				required: 'Especifique fecha',
				date: 'Especifique fecha válida',
				minDate: 'Especifique fecha mayor o igual que la Fecha inicial'
			},
			sucursalID: {
				required: 'Especifique sucursal'
			},
			servicioID: {
				required: 'Especifique servicio'
			},
			productoID: {
				required: 'Especifique producto'
			}
		}
	});
});

function listaSucursales() {
	var sucursalesBean = {};
	dwr.util.removeAllOptions('sucursalID');
	dwr.util.addOptions('sucursalID', {
		'0': 'TODAS'
	});
	sucursalesServicio.listaCombo(2, sucursalesBean, function(sucursales) {
		if(sucursales != null) {
			dwr.util.addOptions('sucursalID', sucursales, 'sucursalID', 'nombreSucurs');
		} else {
			dwr.util.removeAllOptions('sucursalID');
			dwr.util.addOptions('sucursalID',{
				'':'No existen sucursales'});
		}
	});
}

function listaTiposServicio() {
	var pslConfigServicioBean = {};
	dwr.util.removeAllOptions('tipoServicioID');
	dwr.util.addOptions('tipoServicioID', {
		'': 'TODOS'
	});
	pslConfigServicioServicio.lista(2, pslConfigServicioBean, function(tiposServicio) {
		if(tiposServicio != null) {
			dwr.util.addOptions('tipoServicioID', tiposServicio, 'clasificacionServ', 'nomClasificacion');
		} else {
			dwr.util.removeAllOptions('tipoServicioID');
			dwr.util.addOptions('tipoServicioID',{
				'':'No existen tipos de servicio'});
		}
	});
}

function listaServicios() {
	var pslConfigServicioBean = {
		'clasificacionServ': $('#tipoServicioID').val()
	};
	dwr.util.removeAllOptions('servicioID');
	dwr.util.addOptions('servicioID', {
		'0': 'TODOS'
	});
	pslConfigServicioServicio.lista(4, pslConfigServicioBean, function(servicios) {
		if(servicios != null) {
			dwr.util.addOptions('servicioID', servicios, 'servicioID', 'servicio');
		} else {
			dwr.util.removeAllOptions('servicioID');
			dwr.util.addOptions('servicioID',{
				'':'No existen servicios'});
		}
	});
}

function listaProductos() {
	var pslConfigProductoBean = {
		'clasificacionServ': $('#tipoServicioID').val(),
		'servicioID': $('#servicioID').val()
	};
	dwr.util.removeAllOptions('productoID');
	dwr.util.addOptions('productoID', {
		'0': 'TODOS'
	});
	pslConfigProductoServicio.lista(2, pslConfigProductoBean, function(productos) {
		if(productos != null) {
			dwr.util.addOptions('productoID', productos, 'productoID', 'producto');
		} else {
			dwr.util.removeAllOptions('productoID');
			dwr.util.addOptions('productoID',{
				'':'No existen productos'});
		}
	});
}

function funcionGenerarReportePSL() {
	window.open('pslReportePago.htm?'
				+ 'fechaInicio=' + $('#fechaInicio').val()
				+ '&fechaFin=' + $('#fechaFin').val()
				+ '&sucursalID=' + $('#sucursalID').val()
				+ '&sucursal=' + $('#sucursal').val()
				+ '&tipoServicioID=' + $('#tipoServicioID').val()
				+ '&tipoServicio=' + $('#tipoServicio').val()
				+ '&servicioID=' + $('#servicioID').val()
				+ '&servicio=' + $('#servicio').val()
				+ '&productoID=' + $('#productoID').val()
				+ '&producto=' + $('#producto').val()
				+ '&canal=' + $('#canal').val()
				+ '&tipoReporte=' + tipoReporte
				+ '&fechaEmision=' + parametroBean.fechaSucursal
				+ '&claveUsuario=' + parametroBean.claveUsuario
				+ '&nombreUsuario=' + parametroBean.nombreUsuario
				+ '&nombreInstitucion=' + parametroBean.nombreInstitucion
				+ '&nombreSucursal=' + parametroBean.nombreSucursal
				+ '&rutaImagen=' + parametroBean.rutaImgReportes, '_blank');
}
