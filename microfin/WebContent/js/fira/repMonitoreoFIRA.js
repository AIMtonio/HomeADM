esTab = true;
var parametroBean = '';

$(document).ready(function() {
	// Definicion de Constantes y Enums
	parametroBean = consultaParametrosSession();
	inicializa();
	consultaTiposReporte();


	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');

	$(':text').focus(function() {	
		esTab = false;
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	

	$.validator.setDefaults({
		submitHandler : function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje', 'false', 'tipoReporteID', 'funcionExito', 'funcionError');
		}
	});
	
	$('#formaGenerica').validate({
		rules : {
			tipoReporteID : {
				required : true
			},
			fechaReporte : {
				required : true
			}
		},
		messages : {
			tipoReporteID : {
				required : 'Seleccione el Tipo de Reporte.'
			},
			fechaReporte : {
				required : 'La fecha es Requerida.'
			}
		}
	});

	$('#tipoReporteID').change(function() {
		var tipoReporte = $('#tipoReporteID').asNumber();
		$("#calCartFira").val("");
		$("#rutaFinalCalCartFira").val("");
		$("#archivoRes").val("");
		$("#rutaFinalArchivoRes").val("");
		if(tipoReporte != 0){
			habilitaBoton('generar');
		} else {
			deshabilitaBoton('generar');
		}
	});

	$('#fechaReporte').change(function() {
		var fechaReporte = validacion.esFechaValida($('#fechaReporte').val()) == true ? $('#fechaReporte').val() : parametroBean.fechaSucursal;

		if (fechaReporte > parametroBean.fechaSucursal){
			mensajeSis("La Fecha es Mayor a la Fecha del Sistema.")	;
			$('#fechaReporte').val(parametroBean.fechaSucursal);
			$('#fechaReporte').focus();
		}
	});

	
	$('#generar').click(function() {
		generaReporte();
	});

	$('#grabar').click(function() {
		if($('#tipoReporteID').asNumber()==12){
			grabarProyeccion();	
		}
		if($('#tipoReporteID').asNumber()==8){
			grabarExcedentes();	
		}
					

	});

	$('#modificar').click(function() {		
		modificarProyeccion();
	});
			
	$('#tipoReporteID').change(function() {
		mostrarElementoPorClase('fechaReporte', true);
		mostrarElementoPorClase('anio', false);
		mostrarElementoPorClase('cargaProyeccion', false);
		mostrarElementoPorClase('cargaExcedentes', false);

		$('#grabar').hide();
		$('#modificar').hide();

		if($('#tipoReporteID').asNumber()==5 || $('#tipoReporteID').asNumber()==6){
			mostrarElementoPorClase('cargaArchivo', true);
			if($('#tipoReporteID').asNumber()==5){
				mostrarElementoPorClase('archivofira', true);
			} else {
				mostrarElementoPorClase('archivofira', false);
			}
		} else {
			mostrarElementoPorClase('cargaArchivo', false);
		}
		if($('#tipoReporteID').asNumber()==8) {
			$('#fechaReporte').val(parametroBean.fechaSucursal);
			mostrarElementoPorClase('cargaExcedentes', true);
			consultaGridExcedentes();
			
		} 
		if($('#tipoReporteID').asNumber()==12) {
			mostrarElementoPorClase('fechaReporte', false);
			mostrarElementoPorClase('anio', true);
			llenaComboAnios();
			$('#anio').focus();
			$("#calCartFira").val("");
			deshabilitaBoton('generar');
		}
		});

	$('#anio').change(function() {
		var fecha1= parametroBean.fechaSucursal.split("-");
		var anioSis = fecha1[0];
		var mesSis = fecha1[1];
		var anioRep = $('#anio').asNumber();

		if(anioRep > 0){
			habilitaBoton('generar');
			$('#grabar').hide();
			$('#modificar').hide();
			mostrarElementoPorClase('cargaProyeccion', false);
			$('#divGridProyeccion').html('');
			if(anioRep == anioSis && mesSis >= 1 && mesSis <=3){
				mostrarElementoPorClase('cargaProyeccion', true);
				consultaGridProyeccion();
			}			
				 		
		} else{
			deshabilitaBoton('generar');
			mostrarElementoPorClase('cargaProyeccion', false);
		}
	});

	$('#fechaReporte').change(function() {
		if($('#tipoReporteID').asNumber()==8) {
			var fechaRep= $('#fechaReporte').val().split("-");
			var anioRep = fechaRep[0];
			var mesRep = fechaRep[1];

			var fechaSis= parametroBean.fechaSucursal.split("-");
			var anioSis = fechaSis[0];
			var mesSis = fechaSis[1];
			
			if(anioRep == anioSis &&  mesRep == mesSis){
				mostrarElementoPorClase('cargaExcedentes', true);
				consultaGridExcedentes();
			}else{
				mostrarElementoPorClase('cargaExcedentes', false);
				$('#grabar').hide();
			}			
		}
	});
	
	$('#adjuntarCaliCartFira').click(function() {
		subirArchivos(1);
	});
	
	$('#adjuntarArchReserva').click(function() {
		subirArchivos(2);
	});

});


function generaReporte() {
	var tipoReporte = $('#tipoReporteID').asNumber();
	if(tipoReporte != 0){
		var ligaGenerar			= '';
		var tipoReporte	= $('#tipoReporteID').asNumber();
		var fechaReporte;
		if(tipoReporte == 12){
			 var anio = $('#anio').val();			
			 fechaReporte = (anio+"-"+"01-01");
		} else{
			 fechaReporte		= $('#fechaReporte').val();
		}
		
		var fechaSistema		= parametroBean.fechaSucursal;
		var claveUsuario		= parametroBean.claveUsuario;
		var nombreInstitucion	= parametroBean.nombreInstitucion; 
		var rutaFinalCalCartFira= $("#rutaFinalCalCartFira").val();
		var rutaFinalArchivoRes= $("#rutaFinalArchivoRes").val();

		ligaGenerar = 'reporteMonitoreoFiraVista.htm?' + 
			'&tipoReporteID=' 	+ tipoReporte +
			'&fechaReporte='	+ fechaReporte +
			'&tipoConsulta='	+ 1 +
			'&tipoLista='		+ 2 +
			'&fechaSistema=' 	+ fechaSistema +
			'&nomUsuario=' 		+ claveUsuario.toUpperCase() +
			'&rutaFinalCalCartFira='+rutaFinalCalCartFira+
			'&rutaFinalArchivoRes='+rutaFinalArchivoRes+
			'&nomInstitucion='	+ nombreInstitucion.toUpperCase();

		window.open(ligaGenerar, '_blank');
	} else {
		mensajeSis('Elegir un Tipo de Reporte.');
		deshabilitaBoton('generar');
	}
}



function inicializa(){
    $('#tipoReporteID').focus();
	$('#fechaReporte').val(parametroBean.fechaSucursal);
	deshabilitaBoton('generar');
	$('#grabar').hide();
	$('#modificar').hide();
}

function consultaTiposReporte() {
	dwr.util.removeAllOptions('tipoReporteID');
	dwr.util.addOptions('tipoReporteID', {
		'' : 'SELECCIONAR'
	});
	var bean = {};
	catReportesFIRAServicio.lista(1,bean,0, function(monedas) {
		dwr.util.addOptions('tipoReporteID', monedas, 'tipoReporteID', 'nombre');
	});
}

function subirArchivos(tipoArchivo){
	if(validacion.esFechaValida($('#fechaReporte').val())){
		if($('#tipoReporteID').asNumber()==5){
			if($('#calCartFira').val()=='' && tipoArchivo==2){
				mensajeSis("Adjunte el Archivo Calificación Cartera FIRA.");
				$('#adjuntarCaliCartFira').focus();
				deshabilitaBoton('generar');
			} else {
				var fecha = $('#fechaReporte').val();
				var tipoReporte = $('#tipoReporteID').asNumber();
				var url = "archMonitoreoUpload.htm?" +
						"fechaReporte=" + fecha +
						"&tipoReporte=" + tipoReporte +
						"&tipoArchivo=" + tipoArchivo;
				var leftPosition = (screen.width) ? (screen.width - 850) / 2 : 0;
				var topPosition = (screen.height) ? (screen.height - 500) / 2 : 0;
				ventanaArchivos = window.open(url, "PopUpSubirArchivo", "width=980,height=340,scrollbars=yes,status=yes,location=false,addressbar=false,menubar=0,toolbar=0" + "left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition);
			}
		} else if($('#tipoReporteID').asNumber()==6){
			var fecha = $('#fechaReporte').val();
			var tipoReporte = $('#tipoReporteID').asNumber();
			var url = "archMonitoreoUpload.htm?" +
					"fechaReporte=" + fecha +
					"&tipoReporte=" + tipoReporte +
					"&tipoArchivo=" + tipoArchivo;
			var leftPosition = (screen.width) ? (screen.width - 850) / 2 : 0;
			var topPosition = (screen.height) ? (screen.height - 500) / 2 : 0;
			ventanaArchivos = window.open(url, "PopUpSubirArchivo", "width=980,height=340,scrollbars=yes,status=yes,location=false,addressbar=false,menubar=0,toolbar=0" + "left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition);
		}
	} else {
		mensajeSis("La Fecha no es Válida.");
		$("#fechaReporte").focus();
		deshabilitaBoton('generar');
	}
}

function habilitaGenera(){
	habilitaBoton('generar');
}


 function llenaComboAnios(){
  dwr.util.removeAllOptions('anio');
	dwr.util.addOptions('anio', {
		'' : 'SELECCIONAR'
	});
	var bean = {};
	catReportesFIRAServicio.lista(3,bean,0, function(Anios) {
		dwr.util.addOptions('anio', Anios,'anio', 'anio');
	});
 }
 
var numFilas;

//Función muestra en el grid
 function consultaGridProyeccion() {
	 var anio = $('#anio').asNumber();
	 var params = {};
		params['anioLista'] = $('#anio').asNumber();
		params['tipoLista'] = 1;
	
	if(anio > 0){
		$.post("monitorProyeccionGridVista.htm", params, function(data) {
	 		if (data.length > 0) {
	 			bloquearPantallaCarga();
	 			$('#divGridProyeccion').html(data);
	 			numFilas = consultaFilas();	 
	 			var flag = $('#flag1').asNumber();
	 			habilitaBotonesGrid();
	 			formatoMonedaGrid();
	 					

	 			$('#contenedorForma').unblock(); // desbloquear
	 			var options = new GridViewScrollOptions();
	 			options.elementID = "gvMain";
	 			var tama=$(window).width();
	 			if(tama>300){
	 			tama=tama-300;
	 			}
	 			options.width = tama;
	 			options.height = 500;
	 			options.freezeColumn = true;
	 			options.freezeFooter = true;
	 			options.freezeColumnCssClass = "GridViewScrollItemFreeze";
	 			options.freezeColumnCount = 1;

	 			gridViewScroll = new GridViewScroll(options);
	 			gridViewScroll.enhance();
	 		} else {
	 			mensajeSis('No se Encontraron Coincidencias');
	 		}
	 });		
	} 
 	
 }
 
//Función muestra el grid de Excedentes
 function consultaGridExcedentes() {
 	var params = {};
		params['fecha'] = $('#fechaReporte').val();
		params['tipoLista'] = 1;
	
	 $.post("monitorExcedentesGridVista.htm", params, function(data) {
	 		if (data.length > 0) {
	 			bloquearPantallaCarga();
	 			$('#divGridExcedentes').html(data);
	 			formatoMonedaExcedentes();
	 			$('#contenedorForma').unblock(); // desbloquear
	 			var options = new GridViewScrollOptions();
	 			options.elementID = "gvMain";
	 			var tama=$(window).width();
	 			if(tama>300){
	 			tama=tama-300;
	 			}
	 			options.width = tama;
	 			options.height = 500;
	 			options.freezeColumn = true;
	 			options.freezeFooter = true;
	 			options.freezeColumnCssClass = "GridViewScrollItemFreeze";
	 			options.freezeColumnCount = 1;

	 			gridViewScroll = new GridViewScroll(options);
	 			gridViewScroll.enhance();
	 			
	 			habilitaBotonesGridExcedentes();	

	 		} else {
	 			mensajeSis('No se Encontraron Coincidencias');
	 		}	 			
	});	 	
 }

 
//funcion que bloquea la pantalla mientras se cargan los datos
 function bloquearPantallaCarga() {
 	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
 	$('#contenedorForma').block({
 	message : $('#mensaje'),
 	css : {
 	border : 'none',
 	background : 'none'
 	}
 	});

 }
 
//Función consulta el total de creditos en la lista
 function consultaFilas() {
 	var totales = 0;
 	$('tr[name=renglons]').each(function() {
 		totales++;

 	});
 	return totales;
 }

 
 function generaSeccion(pageValor) {
		
		var params = {};
		params['anioLista'] = $('#anio').asNumber();
		params['tipoLista'] = 1;
		params['page'] = pageValor;	

		$.post("monitorProyeccionGridVista.htm", params, function(data) {
			if (data.length > 0) {
				bloquearPantallaCarga();
				$('#divGridProyeccion').html(data);

				var numFilas = consultaFilas();
				
				$('#contenedorForma').unblock(); // desbloquear
				var options = new GridViewScrollOptions();
				options.elementID = "gvMain";
				var tama=$(window).width();
				if(tama>300){
				tama=tama-300;
				}
				options.width = tama;
				options.height = 500;
				options.freezeColumn = true;
				options.freezeFooter = true;
				options.freezeColumnCssClass = "GridViewScrollItemFreeze";
				options.freezeColumnCount = 1;

				gridViewScroll = new GridViewScroll(options);
				gridViewScroll.enhance();
			} else {
				mensajeSis('No se Encontraron Coincidencias');
			}

		});


	}
 
 function generaSeccionExcedentes(pageValor) {
		
		var params = {};
		params['fecha'] = $('#fechaReporte').val();
		params['tipoLista'] = 1;
		params['page'] = pageValor;	

		$.post("monitorExcedentesGridVista.htm", params, function(data) {
			if (data.length > 0) {
				bloquearPantallaCarga();
				$('#divGridExcedentes').html(data);
				formatoMonedaExcedentes();	
				$('#contenedorForma').unblock(); // desbloquear
				var options = new GridViewScrollOptions();
				options.elementID = "gvMain";
				var tama=$(window).width();
				if(tama>300){
				tama=tama-300;
				}
				options.width = tama;
				options.height = 500;
				options.freezeColumn = true;
				options.freezeFooter = true;
				options.freezeColumnCssClass = "GridViewScrollItemFreeze";
				options.freezeColumnCount = 1;

				gridViewScroll = new GridViewScroll(options);
				gridViewScroll.enhance();
			} else {
				mensajeSis('No se Encontraron Coincidencias');
			}

		});


	}

 // Función para habilitar los Botones del Grid Proyeccion (Agregar y Modificar)

function habilitaBotonesGrid(){
	var flag = $('#flag1').asNumber();
	var fecha1= parametroBean.fechaSucursal.split("-");
	var anioSis = fecha1[0];
	var mesSis = fecha1[1];
	var anioRep = $('#anio').asNumber();
	habilitaBoton('grabar');
	habilitaBoton('modificar');

	if(anioRep == anioSis && mesSis >= 1 && mesSis <=3) {
		$('#grabar').show();
		$('#modificar').show();
		habilitaCamposGrid();
		if(flag == 0){
			deshabilitaBoton('modificar');
		} else{
			deshabilitaBoton('grabar');
		}
		
	} else {
		$('#grabar').hide();
		$('#modificar').hide();
	}
}

// Función para habilitar los Botones del Grid de Excedentes(Agregar y Modificar)

function habilitaBotonesGridExcedentes(){
	$('#grabar').show();
	habilitaBoton('grabar');
}

 // Función para dar formato de monedas a los datos mostrados en el Grid

function agregaFormatoMonedaGrid(controlID) {	
	var jqControlID = eval("'#" + controlID + "'");
	var valor = $(jqControlID).val();
	var valorNumero = $(jqControlID).asNumber();
	var str = (valor).replace(/,/g, '');
		str = ""+ parseInt(str);
		str = str.length;

	if(isNaN(valor) && valorNumero==0){
		$(jqControlID).val('');
		$(jqControlID).focus();
		$(jqControlID).select();
		$(jqControlID).addClass("error");
	}
	if (parseInt(str) > 14){
		mensajeSisRetro({
				mensajeAlert : 'Error Máximo de Caracteres.',
				muestraBtnAceptar: true,
				muestraBtnCancela: false,
				txtAceptar : 'Aceptar',
				txtCancelar : 'Cancelar',
				funcionAceptar : function(){
					$(jqControlID).val('');
					$(jqControlID).focus();
				},
				funcionCancelar : function(){
					
				}
			});
	}

	$(jqControlID).formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 2 });

	if(($(jqControlID).val()).indexOf('$') != -1){
		mensajeSis("Error en el Formato.");
		$(jqControlID).val('');
		$(jqControlID).focus();
	}
}


function formatoMonedaGrid() {
	var contador = 12;
	
	var i;
	for (i = 1; i <= contador; i++) {
	  $("#" + "saldoTotal" + i).formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 2 });
	  $("#" + "saldoFira" + i).formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 2 });
	  $("#" + "gastosAdmin" + i).formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 2 });
	  $("#" + "capitalConta" + i).formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 2 });
	  $("#" + "utilidadNeta" + i).formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 2 });
	  $("#" + "activoTotal" + i).formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 2 });
	  $("#" + "saldoVencido" + i).formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 2 });
	  $("#" + "saldoTotal" + i).formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 2 });

	} 

}

function formatoMonedaExcedentes() {
	var numReg = consultaFilas();

	var i;
	for (i = 1; i <= numReg; i++) {
	  $("#" + "saldoIntegrante" + i).formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 2 });
	  $("#" + "saldoGrupal" + i).formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 2 });
	} 

}



 // Función para habilitar los campos del Grid

function habilitaCamposGrid(){
	var contador = 12;
	
	var i;
	for (i = 1; i <= contador; i++) {
	  $("#" + "saldoTotal" + i).attr('readonly', false);
	  $("#" + "saldoFira" + i).attr('readonly', false);
	  $("#" + "gastosAdmin" + i).attr('readonly', false);
	  $("#" + "capitalConta" + i).attr('readonly', false);
	  $("#" + "utilidadNeta" + i).attr('readonly', false);
	  $("#" + "activoTotal" + i).attr('readonly', false);
	  $("#" + "saldoVencido" + i).attr('readonly', false);
	  $("#" + "saldoTotal" + i).attr('readonly', false);

	} 
}


 // Función para grabar la proyeccion

 function grabarProyeccion(){
	var params = {};
		params['tipoTransaccion'] = '1'; 
		params['anioLista'] = $('#anio').val();
		params['lisConsecutivoID'] = {	};
		params['lisAnio'] = {	};
		params['lisMes'] = {	};
		params['lisSaldoTotal'] = {	};
		params['lisSaldoFira'] = {	};
		params['lisGastosAdmin'] = {	};
		params['lisCapitalConta'] = {	};
		params['lisUtilidadNeta'] = {	};
		params['lisActivoTotal'] = {	};
		params['lisSaldoVencido'] = {	};
		
		for (var i = 0; i < 12; i++) {
			params["lisConsecutivoID"][i] = $("#" + "consecutivoID" + (i + 1)).val();
			params["lisAnio"][i] = $("#" + "anio" + (i + 1)).val();
			params["lisMes"][i] = $("#" + "mes" + (i + 1)).val();
			params["lisSaldoTotal"][i] = ($("#" + "saldoTotal" + (i + 1)).val()).replace(/,/g, '');
			params["lisSaldoFira"][i] = ($("#" + "saldoFira" + (i + 1)).val()).replace(/,/g, '');
			params["lisGastosAdmin"][i] = ($("#" + "gastosAdmin" + (i + 1)).val()).replace(/,/g, '');
			params["lisCapitalConta"][i] = ($("#" + "capitalConta" + (i + 1)).val()).replace(/,/g, '');
			params["lisUtilidadNeta"][i] = ($("#" + "utilidadNeta" + (i + 1)).val()).replace(/,/g, '');
			params["lisActivoTotal"][i] = ($("#" + "activoTotal" + (i + 1)).val()).replace(/,/g, '');
			params["lisSaldoVencido"][i] = ($("#" + "saldoVencido" + (i + 1)).val()).replace(/,/g, '');
			
		}

	
	$.post("monitorProyeccion.htm", params, function(data) {
			
			mensajeSisRetro({
				mensajeAlert : 'Proyección Grabada Exitosamente',
				muestraBtnAceptar: true,
				muestraBtnCancela: false,
				txtAceptar : 'Aceptar',
				txtCancelar : 'Cancelar',
				funcionAceptar : function(){
					deshabilitaBoton('grabar');
					habilitaBoton('modificar');
					consultaGridProyeccion();
				},
				funcionCancelar : function(){
					
				}
			});
				});
}

 // Función para modificar la proyeccion
 
function modificarProyeccion(){
	var params = {};
		params['tipoTransaccion'] = '2'; 
		params['anioLista'] = $('#anio').val();
		params['lisConsecutivoID'] = {	};
		params['lisAnio'] = {	};
		params['lisMes'] = {	};
		params['lisSaldoTotal'] = {	};
		params['lisSaldoFira'] = {	};
		params['lisGastosAdmin'] = {	};
		params['lisCapitalConta'] = {	};
		params['lisUtilidadNeta'] = {	};
		params['lisActivoTotal'] = {	};
		params['lisSaldoVencido'] = {	};	
	
		
		for (var i = 0; i < 12; i++) {
			params["lisConsecutivoID"][i] = $("#" + "consecutivoID" + (i + 1)).val();
			params["lisAnio"][i] = $("#" + "anio" + (i + 1)).val();
			params["lisMes"][i] = $("#" + "mes" + (i + 1)).val();
			params["lisSaldoTotal"][i] = ($("#" + "saldoTotal" + (i + 1)).val()).replace(/,/g, '');
			params["lisSaldoFira"][i] = ($("#" + "saldoFira" + (i + 1)).val()).replace(/,/g, '');
			params["lisGastosAdmin"][i] = ($("#" + "gastosAdmin" + (i + 1)).val()).replace(/,/g, '');
			params["lisCapitalConta"][i] = ($("#" + "capitalConta" + (i + 1)).val()).replace(/,/g, '');
			params["lisUtilidadNeta"][i] = ($("#" + "utilidadNeta" + (i + 1)).val()).replace(/,/g, '');
			params["lisActivoTotal"][i] = ($("#" + "activoTotal" + (i + 1)).val()).replace(/,/g, '');
			params["lisSaldoVencido"][i] = ($("#" + "saldoVencido" + (i + 1)).val()).replace(/,/g, '');

			
		}
		
	$.post("monitorProyeccion.htm", params, function(data) {
			
			mensajeSisRetro({
				mensajeAlert : 'Proyección Modificada Exitosamente',
				muestraBtnAceptar: true,
				muestraBtnCancela: false,
				txtAceptar : 'Aceptar',
				txtCancelar : 'Cancelar',
				funcionAceptar : function(){
					consultaGridProyeccion();
				},
				funcionCancelar : function(){
					
				}
			});
		});
}

//Función para grabar los Excedentes de Riesgo

function grabarExcedentes(){
	var params = {};
		params['tipoTransaccion'] = '1'; 
		params['fecha'] = $('#fechaReporte').val();
		params['lisGrupoID'] = {	};
		params['lisRiesgoID'] = {	};
		params['lisClienteID'] = {	};
		params['lisNombreIntegrante'] = {	};
		params['lisTipoPersona'] = {	};
		params['lisRFC'] = {	};
		params['lisCURP'] = {	};
		params['lisSaldoIntegrante'] = {	};
		params['lisSaldoGrupal'] = {	};

		var numFilas = consultaFilas();
		for (var i = 0; i < numFilas; i++) {
			params["lisGrupoID"][i] = $("#" + "grupoID" + (i + 1)).val();
			params["lisRiesgoID"][i] = $("#" + "riesgoID" + (i + 1)).val();
			params["lisClienteID"][i] = $("#" + "clienteID" + (i + 1)).val();
			params["lisNombreIntegrante"][i] = $("#" + "nombreIntegrante" + (i + 1)).val();
			params["lisTipoPersona"][i] = $("#" + "tipoPersona" + (i + 1)).val();
			params["lisRFC"][i] = $("#" + "rfc" + (i + 1)).val();
			params["lisCURP"][i] = $("#" + "curp" + (i + 1)).val();
			params["lisSaldoIntegrante"][i] = ($("#" + "saldoIntegrante" + (i + 1)).val()).replace(/,/g, '');
			params["lisSaldoGrupal"][i] = ($("#" + "saldoGrupal" + (i + 1)).val()).replace(/,/g, '');
			
		}

	
	$.post("monitorExcedentes.htm", params, function(data) {
			mensajeSisRetro({
						mensajeAlert : 'Excedentes de Riesgo Grabado Exitosamente',
						muestraBtnAceptar: true,
						muestraBtnCancela: false,
						txtAceptar : 'Aceptar',
						txtCancelar : 'Cancelar',
						funcionAceptar : function(){
							consultaGridExcedentes();
						},
						funcionCancelar : function(){
							
						}
					});
	});

}


/**
 * Función de  de éxito que se ejecuta cuando después de grabar
 * la transacción y ésta fue exitosa.
 */
function funcionExito(){
	
}
/**
 * Funcion de error que se ejecuta cuando después de grabar
 * la transacción marca error.
 */
function funcionError(){
	
}
