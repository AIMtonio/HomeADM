var Enum_Lis_RatiosConf = {
'listaXConcepto' : 1,
'listaXClasificacion' : 2,
'listaXSubClasificacion' : 3,
'listaXPuntos' : 4
};
var esTab;
$(document).ready(function() {
	esTab = false;
	inicializar();
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	$(':text').focus(function() {
		esTab = false;
	});
	$('#producCreditoID').bind('keyup', function(e) {
		lista('producCreditoID', '1', '15', 'descripcion', $('#producCreditoID').val(), 'listaProductosCredito.htm');
	});
	$('#producCreditoID').blur(function() {
		var producto = $('#producCreditoID').asNumber();
		if (producto > 0) {
			consultaProductosCredito(this.id);
			habilitaBoton('grabar', 'submit');
		} else {
			agregaFormatoControles('formaGenerica');
			deshabilitaBoton('grabar', 'submit');
			$("#numTab").val(4);
			$('#listaConcepto').html("");
			$('#listaConcepto').show();
			$('#descripProducto').val("");
		}
	});
	$('#formaGenerica').validate({
	rules : {
		producCreditoID : 'required',
	},
	messages : {
		producCreditoID : 'Especifique el Producto de Crédito.',
	}
	});
	$.validator.setDefaults({
		submitHandler : function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'producCreditoID', 'exito', 'error');
		}
	});
});
function exito() {
	agregaFormatoControles('formaGenerica');
}
function error() {
}
function inicializar() {
	$("#producCreditoID").focus();
	agregaFormatoControles('formaGenerica');
}
function consultaProductosCredito(idControl) {
	var jqProducto = eval("'#" + idControl + "'");
	var numProducto = $(jqProducto).val();
	var conForanea = 1;
	var ProductoCreditoCon = {
		'producCreditoID' : numProducto
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if (numProducto != '' && !isNaN(numProducto) && esTab) {
		productosCreditoServicio.consulta(conForanea, ProductoCreditoCon, function(productos) {
			if (productos != null) {
				$('#descripProducto').val(productos.descripcion);
				$('#estatusProducCredito').val(productos.estatus);
				mostrarXConcepto();
			} else {
				mensajeSis("No Existe el Producto de Crédito");
				$(jqProducto).focus();
				$('#listaConcepto').html("");
				$('#listaConcepto').show();
				$('#estatusProducCredito').val("");
			}
		});
	}
}
function consultaConfiguracion(tipo_lista, ratiosCatalogoRelID) {
	var numProducto = $("#producCreditoID").val();
	var bean_conf_ratios = {
	'producCreditoID' : numProducto,
	'tipoLista' : tipo_lista,
	'ratiosCatalogoRelID' : ratiosCatalogoRelID
	}
	if (numProducto != '' && !isNaN(numProducto)) {
		$.post("configuracionRatiosGrid.htm", bean_conf_ratios, function(data) {
			switch (tipo_lista) {
				case Enum_Lis_RatiosConf.listaXConcepto:
					$('#listaConcepto').html(data);
					$('#listaConcepto').show();
					$('#ratiosCatalogoID11').focus();
					break;
				case Enum_Lis_RatiosConf.listaXClasificacion:
					$('#listaClasificacion').html(data);
					$('#listaClasificacion').show();
					break;
				case Enum_Lis_RatiosConf.listaXSubClasificacion:
					$('#listaSubClasificacion').html(data);
					$('#listaSubClasificacion').show();
					break;
				case Enum_Lis_RatiosConf.listaXPuntos:
					$('#listaPuntos').html(data);
					$('#listaPuntos').show();
					break;
			}
			agregaFormatoControles('formaGenerica');
		});
	}
}
function mostrarXConcepto() {
	$('#listaClasificacion').html("");
	$('#listaClasificacion').hide();
	$('#listaSubClasificacion').html("");
	$('#listaSubClasificacion').hide();
	$('#listaPuntos').html("");
	$('#listaPuntos').hide();
	consultaConfiguracion(Enum_Lis_RatiosConf.listaXConcepto, 0);
}
function mostrarXClasificacion(id) {
	var clasificacion = $("#" + id).val();
	$('#listaSubClasificacion').html("");
	$('#listaSubClasificacion').hide();
	consultaConfiguracion(Enum_Lis_RatiosConf.listaXClasificacion, clasificacion);
}
function mostrarXSubClasificacion(id) {
	var subclasificacion = $("#" + id).val();
	$('#listaPuntos').html("");
	$('#listaPuntos').hide();
	consultaConfiguracion(Enum_Lis_RatiosConf.listaXSubClasificacion, subclasificacion);
}
function mostrarXPuntos(id) {
	var puntos = $("#" + id).val();
	consultaConfiguracion(Enum_Lis_RatiosConf.listaXPuntos, puntos);
}
function grabar(tipo_lista) {
	quitaFormatoControles('formaGenerica');
	$('#tipoTransaccion').val(tipo_lista);
	var continuar = true;
	var tablaID = "";
	var totalID = "";
	var botonID = "";
	var total = 0;
	switch (tipo_lista) {
		case Enum_Lis_RatiosConf.listaXConcepto:
			tablaID = "tablaxConcepto";
			totalID = "totalXConcepto";
			botonID = "grabaConcepto";
			break;
		case Enum_Lis_RatiosConf.listaXClasificacion:
			tablaID = "tablaXClasificacion";
			totalID = "totalXClasificacion";
			botonID = "grabaClasificacion";
			break;
		case Enum_Lis_RatiosConf.listaXSubClasificacion:
			tablaID = "tablaXSubClasificacion";
			totalID = "totalXSubClasificacion";
			botonID = "grabaSubClasificacion";
			break;
		case Enum_Lis_RatiosConf.listaXPuntos:
			tablaID = "tablaXPuntos";
			totalID = "totalXPuntos";
			botonID = "grabaPuntos";
			break;
	}
	total = $("#" + totalID).asNumber();
	$("#tablaID input[name^='porcentaje" + tipo_lista + "']").each(function() {
		var porcentaje = $("#" + this.id).asNumber();
		if (porcentaje <= 0 || porcentaje >= 100) {
			$("#" + this.id).addClass("error");
			continuar = false;
		}
	});
	if (total != 100) {
		mensajeSis("El Porcentaje debe Sumar un Total de 100%.");
		$("#" + botonID).focus();
		continuar = false;
	}
	if (continuar) {
		if (crearDetalle(tipo_lista, tablaID)) {
			if ($("#formaGenerica").valid()) {
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'producCreditoID', 'exito', 'error');
			}
		} else {
			mensajeSis("Error al Crear el Detalle.");
			$("#" + botonID).focus();
		}
	}
}
function onBlur(id, tipo) {
	var porcentaje = $("#" + id).asNumber();
	if (porcentaje <= 0) {
		$("#" + id).addClass("error");
	} else {
		$("#" + id).removeClass("error");
	}
	sumarTotales(tipo, id);
}
/**
 * Suma los totales por cada una de las tablas
 */
function sumarTotales(tipo_lista, id) {
	var tablaID = "";
	var totalID = "";
	var total = 0;
	switch (tipo_lista) {
		case Enum_Lis_RatiosConf.listaXConcepto:
			tablaID = "tablaxConcepto";
			totalID = "totalXConcepto";
			break;
		case Enum_Lis_RatiosConf.listaXClasificacion:
			tablaID = "tablaXClasificacion";
			totalID = "totalXClasificacion";
			break;
		case Enum_Lis_RatiosConf.listaXSubClasificacion:
			tablaID = "tablaXSubClasificacion";
			totalID = "totalXSubClasificacion";
			break;
		case Enum_Lis_RatiosConf.listaXPuntos:
			tablaID = "tablaXPuntos";
			totalID = "totalXPuntos";
			break;
	}
	$("#" + tablaID + " input[name^='porcentaje" + tipo_lista + "']").each(function() {
		total = total + $("#" + this.id).asNumber();
	});
	if (total <= 100) {
		$("#" + totalID).val(total);
	} else {
		$("#" + id).val("");
		$("#" + id).focus();
	}
}
/**
 * Crea detalle
 */
function crearDetalle(tipo_lista, tablaID) {
	quitaFormatoControles('formaGenerica');
	$('#detalle').val('');
	var arrayID = [];
	var valoresXID = [];
	var limiteIn = [];
	var limiteSup = [];
	var puntos = [];
	var producCreditoID = $("#producCreditoID").asNumber();
	$("#" + tablaID + " input[name^='ratiosCatalogoID" + tipo_lista + "']").each(function() {
		var id = $("#" + this.id).val();
		arrayID.push(id);
		limiteIn.push(0);
		limiteSup.push(0);
		puntos.push(0);
	});
	$("#" + tablaID + " input[name^='porcentaje" + tipo_lista + "']").each(function() {
		var porcentaje = $("#" + this.id).asNumber();
		valoresXID.push(porcentaje);
		if (tipo_lista != Enum_Lis_RatiosConf.listaXPuntos) {
			limiteIn.push(0);
			limiteSup.push(0);
			puntos.push(0);
		}
	});
	if (tipo_lista == Enum_Lis_RatiosConf.listaXPuntos) {
		$("#" + tablaID + " input[name^='limiteInf']").each(function() {
			var limiteI = $("#" + this.id).asNumber();
			limiteIn.push(limiteI);
		});
		$("#" + tablaID + " input[name^='limiteSup']").each(function() {
			var limiteSup = $("#" + this.id).asNumber();
			limiteSup.push(limiteSup);
		});
		$("#" + tablaID + " input[name^='puntos']").each(function() {
			var punto = $("#" + this.id).asNumber();
			puntos.push(punto);
		});
	}
	for (var i = 0; i < arrayID.length; i++) {
		if (i == 0) {
			$('#detalle').val($('#detalle').val() + arrayID[i] + ']' + producCreditoID + ']' + valoresXID[i] + ']' + limiteIn[i] + ']' + limiteSup[i] + ']' + puntos[i] + ']');
		} else {
			$('#detalle').val($('#detalle').val() + '[' + arrayID[i] + ']' + producCreditoID + ']' + valoresXID[i] + ']' + limiteIn[i] + ']' + limiteSup[i] + ']' + puntos[i] + ']');
		}
	}
	return true;
}
function ayuda() {
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