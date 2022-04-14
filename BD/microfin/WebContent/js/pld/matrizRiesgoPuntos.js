var Enum_Lis_RatiosConf = {
'listaXConcepto' : 1,
'listaXClasificacion' : 2,
'listaXClasificacionFisica' : 21,
'listaXClasificacionMoral' : 22,
'listaXSubClasificacion' : 3,
'listaXSubClasificacionFisica' : 31,
'listaXSubClasificacionMoral' : 32,
};
var esTab = false;
$(document).ready(function() {
	inicializar();
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	$(':text').focus(function() {
		esTab = false;
	});
	$.validator.setDefaults({
		submitHandler : function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'graba', 'exito', 'error');
		}
	});
	
	$('#formaGenerica').validate({
	rules : {
	},
	messages : {
	}
	});

});
function exito() {
	agregaFormatoControles('formaGenerica');
}
function error() {
}
function inicializar() {
	agregaFormatoControles('formaGenerica');
	mostrarXConcepto();
}

function consultaConfiguracion(tipo_lista, ratiosCatalogoRelID) {
	var numProducto = $("#producCreditoID").val();
	var bean_conf_ratios = {
	'tipoLista' : tipo_lista,
	'matrizCatalogoID' : ratiosCatalogoRelID
	}
	$.post("matrizRiesgoPuntosGrid.htm", bean_conf_ratios, function(data) {
		switch (tipo_lista) {
			case Enum_Lis_RatiosConf.listaXConcepto :
				$('#listaConcepto').html(data);
				$('#listaConcepto').show();
				$('#ratiosCatalogoID11').focus();
				break;
			case Enum_Lis_RatiosConf.listaXClasificacion :
				$('#listaClasificacion').html(data);
				$('#listaClasificacion').show();
				break;
			case Enum_Lis_RatiosConf.listaXSubClasificacion :
				$('#listaSubClasificacion').html(data);
				$('#listaSubClasificacion').show();
				break;
			case Enum_Lis_RatiosConf.listaXPuntos :
				$('#listaPuntos').html(data);
				$('#listaPuntos').show();
				break;
		}
		agregaFormatoControles('formaGenerica');
	});
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
	$('#tipoTransaccion').val(1);
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
			total = $("#" + totalID).asNumber();
			$("#"+tablaID+" input[name^='porcentaje" + tipo_lista + "']").each(function() {
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
			break;
		case Enum_Lis_RatiosConf.listaXClasificacion:
			tablaID = "tablaXClasificacion";
			totalID = "totalXClasificacion";
			botonID = "grabaClasificacion";
			total = $("#" + totalID).asNumber();
			$("#"+tablaID+" input[name^='porcentaje" + tipo_lista + "']").each(function() {
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
			break;
		case Enum_Lis_RatiosConf.listaXClasificacionFisica:
			tablaID = "tablaXClasificacionFisica";
			totalID = "totalXClasificacionFisica";
			botonID = "grabaClasificacionFisica";
			total = $("#" + totalID).asNumber();
			$("#"+tablaID+" input[name^='porcentaje21']").each(function() {
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
			break;
		case Enum_Lis_RatiosConf.listaXClasificacionMoral:
			tablaID = "tablaXClasificacionMoral";
			totalID = "totalXClasificacionMoral";
			botonID = "grabaClasificacionMoral";
			total = $("#" + totalID).asNumber();
			$("#"+tablaID+" input[name^='porcentaje22']").each(function() {
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
			break;
		case Enum_Lis_RatiosConf.listaXSubClasificacion:
			tablaID = "tablaXSubClasificacion";
			totalID = "totalXSubClasificacion";
			botonID = "grabaSubClasificacion";
			total = $("#" + totalID).asNumber();
			$("#"+tablaID+" input[name^='porcentaje" + tipo_lista + "']").each(function() {
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
			break;
		case Enum_Lis_RatiosConf.listaXSubClasificacionFisica:
			tablaID = "tablaXSubClasificacionFisica";
			totalID = "totalXSubClasificacionFisica";
			botonID = "grabaSubClasificacionFisica";
			total = $("#" + totalID).asNumber();
			$("#"+tablaID+" input[name^='porcentaje31']").each(function() {
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
			break;
		case Enum_Lis_RatiosConf.listaXSubClasificacionMoral:
			tablaID = "tablaXSubClasificacionMoral";
			totalID = "totalXSubClasificacionMoral";
			botonID = "grabaSubClasificacionMoral";
			total = $("#" + totalID).asNumber();
			$("#"+tablaID+" input[name^='porcentaje32']").each(function() {
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
			break;
	}
	
	if (continuar) {
		if (crearDetalle(tipo_lista, tablaID)) {
			if ($("#formaGenerica").valid()) {
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'true', 'graba', 'exito', 'error');
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
			$("#tablaxConcepto input[name^='porcentaje" + tipo_lista + "']").each(function() {
				total = total + $("#" + this.id).asNumber();
			});
			break;
		case Enum_Lis_RatiosConf.listaXClasificacion:
			tablaID = "tablaXClasificacion";
			totalID = "totalXClasificacion";
			$("#tablaXClasificacion input[name^='porcentaje" + tipo_lista + "']").each(function() {
				total = total + $("#" + this.id).asNumber();
			});
			break;
		case Enum_Lis_RatiosConf.listaXClasificacionFisica:
			tablaID = "tablaXClasificacionFisica";
			totalID = "totalXClasificacionFisica";
			$("#tablaXClasificacionFisica input[name^='porcentaje21']").each(function() {
				total = total + $("#" + this.id).asNumber();
			});
			break;
		case Enum_Lis_RatiosConf.listaXClasificacionMoral:
			tablaID = "tablaXClasificacionMoral";
			totalID = "totalXClasificacionMoral";
			$("#tablaXClasificacionMoral input[name^='porcentaje22']").each(function() {
				total = total + $("#" + this.id).asNumber();
			});
			break;
		case Enum_Lis_RatiosConf.listaXSubClasificacion:
			tablaID = "tablaXSubClasificacion";
			totalID = "totalXSubClasificacion";
			$("#tablaXSubClasificacion input[name^='porcentaje" + tipo_lista + "']").each(function() {
				total = total + $("#" + this.id).asNumber();
			});
			break;
		case Enum_Lis_RatiosConf.listaXSubClasificacionFisica:
			tablaID = "tablaXSubClasificacionFisica";
			totalID = "totalXSubClasificacionFisica";
			$("#tablaXSubClasificacionFisica input[name^='porcentaje31']").each(function() {
				total = total + $("#" + this.id).asNumber();
			});
			break;
		case Enum_Lis_RatiosConf.listaXSubClasificacionMoral:
			tablaID = "tablaXSubClasificacionMoral";
			totalID = "totalXSubClasificacionMoral";
			$("#tablaXSubClasificacionMoral input[name^='porcentaje32']").each(function() {
				total = total + $("#" + this.id).asNumber();
			});
			break;
	}
	
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
	$('#detalles').val('');
	var arrayID = [];
	var valoresXID = [];

	$("#" + tablaID + " input[name^='matrizCatalogoID" + tipo_lista + "']").each(function() {
		var id = $("#" + this.id).val();
		arrayID.push(id);
	});

	$("#" + tablaID + " input[name^='porcentaje" + tipo_lista + "']").each(function() {
		var porcentaje = $("#" + this.id).asNumber();
		valoresXID.push(porcentaje);
	});

	for (var i = 0; i < arrayID.length; i++) {
		if (i == 0) {
			$('#detalles').val($('#detalles').val() + arrayID[i] + ']' + valoresXID[i] + ']');
		} else {
			$('#detalles').val($('#detalles').val() + '[' + arrayID[i] + ']' + valoresXID[i] + ']');
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