var Cat_TipoTransaccion = {
'actualiza' : '3'
};

var catTipoConsultaCta = {
'principal' : 1,
'foranea' : 2
};

var catTipoRepPerfilTrans = {
		'Excel'		: 2
};
$(document).ready(function() {
	inicializa();
	var parametroBean = consultaParametrosSession();
	$(':text').focus(function() {
		esTab = false;
	});
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$('#clienteID').bind('keyup', function(e) {
		lista('clienteID', '3', '14', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#clienteID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		var cliente = $('#clienteID').asNumber();
		if (cliente > 0) {
			consultaCliente(this.id);
			agregaFormatoControles('formaGenerica');
		}
	});

	$('#sucursalID').bind('keyup', function(e) {
		lista('sucursalID', '2', '1', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});
	$('#sucursalID').blur(function() {
		consultaSucursal(this.id);
	});
	$('#consultar').click(function() {
		consultaGrid();
	});

	$('#procesar').click(function() {
		$('#tipoTransaccion').val(Cat_TipoTransaccion.actualiza);
		if(crearDetalle()){
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'sucursalID', 'funcionExito', 'funcionError');
		}
	});

	$('#exportarExcel').click(function() {
		generaExcel();
	});

});

function inicializa() {
	limpiaFormaCompleta('formaGenerica', true, ['consultar']);
	agregaFormatoControles('formaGenerica');
	var fechaSis = parametroBean.fechaSucursal;
	var mes = fechaSis.substring(5, 7) * 1;
	var anio = fechaSis.substring(0, 4);
	mes = pad(mes, 2);
	var fechaInicio = anio + "-" + mes + "-" + "01"
	$("#sucursalID").val('0');
	$("#nombreSucursal").val('TODAS');
	$("#clienteID").val('0');
	$("#nombreCliente").val('TODOS');
	$("#fechaInicio").val(fechaInicio);
	$("#fechaFin").val(fechaSis);
	$("#sucursalID").focus();
	deshabilitaBoton('procesar','submit');
	consultaGrid();
}

function consultaGrid(page) {
	var params = {};
	params['tipoLista'] = 2;
	params['sucursalID'] = $("#sucursalID").asNumber();
	params['clienteID'] = $("#clienteID").asNumber();
	params['fechaIncio'] = $("#fechaInicio").val();
	params['fechaFin'] = $("#fechaFin").val();
	params['pagina'] = page;
	bloquearPantalla();
	$.post("perfilTransaccionalAutGrid.htm", params, function(dat) {
		if (dat.length > 0) {
			$('#gridDetalle').html(dat);
			agregaFormatoControles('formaGenerica');
			if(consultaFilas() >0){
				habilitaBoton('exportarExcel','submit');
			}else{
				deshabilitaBoton('exportarExcel','submit');
			}
			$('#gridDetalle').show();
			habilitaBoton('procesar','submit');
			desbloquearPantalla();
		} else {
			$('#gridDetalle').html("");
			$('#gridDetalle').show();
			desbloquearPantalla();
			deshabilitaBoton('exportarExcel','submit');
		}
	});

}

function funcionExito() {
	$('#gridDetalle').html("");
	$('#gridDetalle').show();
	deshabilitaBoton('exportarExcel','submit');
}

function funcionError() {

}
function consultaSucursal(idControl) {
	var jqSucursal = eval("'#" + idControl + "'");
	var numSucursal = $(jqSucursal).val();
	var conSucursal = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numSucursal != '' && !isNaN(numSucursal) && numSucursal != 0) {
		sucursalesServicio.consultaSucursal(conSucursal,
				numSucursal, function(sucursal) {
					if (sucursal != null) {
						$('#sucursalID').val(sucursal.sucursalID);
						$('#nombreSucursal').val(sucursal.nombreSucurs);
						$('#clienteID').val('0');
						$('#nombreCliente').val('TODOS');
					} else {
						mensajeSis("No Existe la Sucursal");
						$('#clienteID').val('0');
						$('#nombreCliente').val('TODOS');
						$("#sucursalID").val("0");
						$("#nombreSucursal").val("TODAS");
					}
				});
	}
	else{
		$('#clienteID').val('0');
		$('#nombreCliente').val('TODOS');
		$("#sucursalID").val("0");
		$("#nombreSucursal").val("TODAS");
	}
}

function consultaCliente (idControl){
	var jqcliente = eval("'#" + idControl + "'");
	var numCliente = $(jqcliente).val();
	var conCliente = 1;
	setTimeout("$('#cajaLista').hide();", 200);

	if (numCliente != '' && !isNaN(numCliente) && numCliente != 0) {
		clienteServicio.consulta(conCliente, numCliente, function(cliente) {
			if (cliente != null) {
				$('#clienteID').val(cliente.numero);
				$('#nombreCliente').val(cliente.nombreCompleto);
				$("#sucursalID").val("0");
				$("#nombreSucursal").val("TODAS")
				$('#consultar').focus();

			} else {
				mensajeSis("No Existe el "+$("#socioClienteAlert").val()+".");
				$('#clienteID').val('0');
				$('#nombreCliente').val('TODOS');
				$("#sucursalID").val("0");
				$("#nombreSucursal").val("TODAS");
			}
		});
	}
	else {
		$('#clienteID').val('0');
		$('#nombreCliente').val('TODOS');
		$("#sucursalID").val("0");
		$("#nombreSucursal").val("TODAS");
	}
}

function crearDetalle() {
	quitaFormatoControles('formaGenerica');
	var detalle = "";
	$('#detalleTbody tr').each(function(index) {
		var clienteID = $(this).find("input[name^='clienteIDTabla']").attr("id");

		if (clienteID != undefined && clienteID != "") {
			var fecha = $(this).find("input[name^='fecha']").attr("id");
			var aceptado = $(this).find("input[name^='estatusAceptado']").attr("id");
			var rechazado = $(this).find("input[name^='estatusRechazado']").attr("id");
			var estatus = "";
			var agregar = false;
			var rechazar = false;
			if ($('#' + aceptado).is(':checked')) {
				agregar = true;
				estatus = "A";
			}

			if ($('#' + rechazado).is(':checked')) {
				rechazar = true;
				estatus = "R";
			}
			if (agregar || rechazar) {
				if (detalle == "") {
					detalle = detalle + $('#'+clienteID).val() + ']' + $("#"+fecha).val() + ']'+ estatus + ']';
				} else {
					detalle = detalle + '[' + $('#'+clienteID).val() + ']'+$("#"+fecha).val() + ']' + estatus + ']';
				}
			}
		}

	});
	if (detalle != "") {
		$("#detalles").val(detalle);
		return true;
	} else {
		mensajeSis("Ningún Perfil esta Seleccionado para Procesar.");
		return false;
	}

}

function generaExcel() {

		var tr= catTipoRepPerfilTrans.Excel;
		var tl=0;

		var fechaInicio = $('#fechaInicio').val();
		var fechaFin = $('#fechaFin').val();
		var sucursal = $('#sucursalID').val();
		var clienteID = $('#clienteID').val();

		var fechaSistema = parametroBean.fechaSucursal;
		var usuario = 	parametroBean.claveUsuario;


		/// VALORES TEXTO
		var nombreSucursal = $("#nombreSucursal").val();
		var nombreCliente = $("#nombreCliente").val();
		var nombreUsuario = parametroBean.nombreUsuario;
		var nombreInstitucion =  parametroBean.nombreInstitucion;

		var liga = 'perfilTransaccionalAutRep.htm?fechaInicio='+fechaInicio+'&fechaFinal='+
				fechaFin+'&clienteID='+clienteID+'&nombreCompleto='+nombreCliente+
				'&sucursalID='+sucursal+'&sucursalDes='+nombreSucursal+
				'&usuario='+usuario+'&nombreUsuario='+nombreUsuario+
				'&tipoReporte='+tr+'&nombreInstitucion='+nombreInstitucion+
				'&fechaSistema='+fechaSistema;
		window.open(liga, '_blank');

}


function marcar(idMarcar,idDesmarcar){
	if($('#'+idMarcar).attr('checked') && $('#'+idDesmarcar).attr('checked') ) {
		$('#'+idDesmarcar).attr('checked',false);
	}
}

function mostrarDetalle(idMostrar){
	mostrarElementoPorClase('detalle',false);
	$('#'+idMostrar).show(500);
}
function pad(n, width, z) {
	  z = z || '0';
	  n = n + '';
	  return n.length >= width ? n : new Array(width - n.length + 1).join(z) + n;
	}

function consultaFilas(){
		var totales=0;
		$('tr[name=detalle]').each(function() {
			totales++;

		});
		return totales;
	}