var tipoEmpleados = {};
var frecuencias = {};
var plazos = {};
var sucursales = {};
var tipoPlazo = '';
var montoMax = 0.0;
var montoMin = 0.0;
var tipoEmpleadoID = 0;
$(document).ready(function() {

	agregaFormatoControles('formaGenerica');

	$(':text, :button, :submit, :checkbox, select').focus(function() {
		esTab = false;
	});

	$(':text, :button, :submit, :checkbox, select').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	consultaProductoCredito();
	listaSucursales();
	listaTipoEmpleados();
	reasignarTabIndex();

});


/*Obtener listado de los Tipo Empleados Activos*/
function listaTipoEmpleados() {
	var productoBean = {
			'institNominaID' : $('#institNominaID').val(),
			'convenioNominaID' : $('#convenioNominaID').val()	
		};
	
	tipoEmpleadosConvenioServicio.lista(3, productoBean,function(resultado) {
		tipoEmpleados = resultado;
		establecerValoresTipoEmpleados();
	});
}

/*Obtener listado de las sucursales*/
function listaSucursales() {

	var sucursalBean = {
			'nombreSucurs' : ''};
	
	sucursalesServicio.lista(5,sucursalBean, function(resultado) {
	
		sucursales = resultado;
		establecerValoresSucursales();
	});
}

/*Obtener El monto Minimo  y Maximo del Cŕedito y el listado de plazos*/
function consultaProductoCredito() {
	var productoID = $('#productoCreditoID').val();


	if (productoID != '' && productoID != 0) {
   
		var productoBean = {
				'producCreditoID' : productoID
			};
			productosCreditoServicio.consulta(1, productoBean, function(producto) {
				
			if (producto != null) {
				montoMin = producto.montoMinimo;
				montoMax = producto.montoMaximo;
				var plazoBean = {
					'producCreditoID' : productoID};
				
					
				plazosCredServicio.listaComboProducto(5, plazoBean,function(resultado) {
										plazos = resultado;
										establecerValoresPlazosDefinidos();
							});
			}
			});
	}
}

function establecerValoresTipoEmpleados() {
	$('#tablaGridEsqTasa tr').each(function(index) {
		if (index > 0) {
			agregarTipoEmpleadosFila('tipoEmpleadoIDEsqTasa' + index);
			establecerValorTipoEmpleados(index);
		}
	});
}



function establecerValoresSucursales() {
	$('#tablaGridEsqTasa tr').each(function(index) {
		if (index > 0) {
			agregarSucursales('sucursalID' + index);
			establecerValorSucursales(index);
		}
	});
}

function establecerValoresPlazosDefinidos() {
		$('#tablaGridEsqTasa tr').each(function(index) {
			if (index > 0) {
				agregarPlazosDefinidos('plazoID' + index);
				establecerValoresPlazos(index);
			}
		});
	}


function agregarTipoEmpleadosFila(idControl) {
	dwr.util.removeAllOptions(idControl);
	if (tipoEmpleados != null && tipoEmpleados.length > 0) {
		dwr.util.addOptions(idControl, {'0' : 'TODOS'});
		dwr.util.addOptions(idControl, tipoEmpleados, 'tipoEmpleadoID','descripcion');
		return;
	} else {
		dwr.util.addOptions(idControl, {'' : 'NO SE ENCONTRARON TIPOS DE EMPLEADOS'});
	}
}



function agregarSucursales(idControl) {

	dwr.util.removeAllOptions(idControl);
	if (sucursales != null && sucursales.length > 0) {
		dwr.util.addOptions(idControl, {'0' : 'TODOS'});
		dwr.util.addOptions(idControl, sucursales, 'sucursalID','nombreSucurs');
		return;
	} else {
		dwr.util.addOptions(idControl, {'' : 'NO SE ENCONTRARON SUCURSALES'});
	}
}

function agregarPlazosDefinidos(idControl) {
	dwr.util.removeAllOptions(idControl);
	if (plazos != null && plazos.length > 0) {
		dwr.util.addOptions(idControl, {'0' : 'TODOS'});
		dwr.util.addOptions(idControl, plazos, 'plazoID', 'descripcion');
		return;
	} else {
		dwr.util.addOptions(idControl, {'' : 'NO SE ENCONTRARON PLAZOS'});
	}
}


function establecerValorSucursales(fila){
	var valorSucursales = $("#lisSucursalID" + fila).val();
	if(valorSucursales == 0 ){
		$('#sucursalID' + fila + ' option').attr('selected', true);
		$('#sucursalID' + fila + ' option[value="0"]').attr('selected', false);
		return;
	}

	var listaSucursales = valorSucursales.split(',');
	for (var index=0;index< listaSucursales.length;index++) {
		var jqSucursal = eval("'#sucursalID" + fila + " option[value=" + listaSucursales[index] + "]'");
		$(jqSucursal).attr("selected", "selected");
	}
}

function establecerValorTipoEmpleados(fila){
	var valorTipoEmpleados = $("#lisTipoEmpleadoIDEsqTasa" + fila).val();
	if(valorTipoEmpleados == 0 ){
		$('#tipoEmpleadoIDEsqTasa' + fila + ' option').attr('selected', true);
		$('#tipoEmpleadoIDEsqTasa' + fila + ' option[value="0"]').attr('selected', false);
		return;
	}

	var listaTipoEmpleados = valorTipoEmpleados.split(',');
	for (var index=0;index< listaTipoEmpleados.length;index++) {
		var jqSucursal = eval("'#tipoEmpleadoIDEsqTasa" + fila + " option[value=" + listaTipoEmpleados[index] + "]'");
		$(jqSucursal).attr("selected", "selected");
	}
}
	
	

function establecerValoresPlazos(fila) {
	$('#tablaGridEsqTasa tr').each(function(index) {
		var valosPlazos = $("#lisPlazoIDEsqTasa" + fila).val();
		if(valosPlazos == 0 ){
			$('#plazoID' + fila + ' option').attr('selected', true);
			$('#plazoID' + fila + ' option[value="0"]').attr('selected', false);
			return;
		}

		var listaPlazos = valosPlazos.split(',');
		for (var index=0;index< listaPlazos.length;index++) {
			var jqPlazo = eval("'#plazoID" + fila + " option[value=" + listaPlazos[index] + "]'");
			$(jqPlazo).attr("selected", "selected");
		}
	});
}

function obtenerOpciones(select) {
				  var result="" ;
				
				  for (var i=0; i<select.length; i++) {
				  	if(i==select.length-1){
				  		 result+=select[i];
				  	}else{
				  		result+= select[i]+",";
				  	}
				   }
				  return result;
				}

function seleccionarSucursales(idControl, fila) {
	var valorSucursal = $('#' + idControl).val();
	if(valorSucursal != null){

			var listaSucursales = valorSucursal.toString();
			if(listaSucursales=='0'){
				$('#' + idControl + ' option').attr('selected', true);
				$('#' + idControl + ' option[value="0"]').attr('selected', false);
				  valor = $('#' + idControl).val();
                  $('#lisSucursalID' + fila).val(obtenerOpciones(valor));
				  
               return;
			}
		
			$('#lisSucursalID' + fila).val(listaSucursales);
			return;
		}

	}


function selecTipoEmpledados(idControl, fila) {
	var valorTEmpleados = $('#' + idControl).val();
	if(valorTEmpleados != null){

			var listaTipoEmpleados = valorTEmpleados.toString();
		if(listaTipoEmpleados=='0'){
				$('#' + idControl + ' option').attr('selected', true);
				$('#' + idControl + ' option[value="0"]').attr('selected', false);
				valor = $('#' + idControl).val();
                  $('#lisTipoEmpleadoIDEsqTasa' + fila).val(obtenerOpciones(valor));
                  return;

		}
			$('#lisTipoEmpleadoIDEsqTasa' + fila).val(listaTipoEmpleados);
			return;
		}

	}


function selecPlazos(idControl, fila) {
	var valorPlazos = $('#' + idControl).val();
	if(valorPlazos != null){

		var listaPlazos = valorPlazos.toString();
		 if(listaPlazos=='0'){
				$('#' + idControl + ' option').attr('selected', true);
				$('#' + idControl + ' option[value="0"]').attr('selected', false);
				 valor = $('#' + idControl).val();
                  $('#lisPlazoIDEsqTasa' + fila).val(obtenerOpciones(valor));
                  return;
		}
			$('#lisPlazoIDEsqTasa' + fila).val(listaPlazos);
			return;
		}

	}


function validarMontoMin(id, fila) {
	var valorMinimo = $('#' + id).asNumber();

	if (!isNaN(valorMinimo) && valorMinimo != '') {
		if (valorMinimo < montoMin) {
			mensajeSis("El monto mínimo no puede ser menor al monto mínimo del esquema de monto");
			$('#' + id).val(montoMin);
			$('#' + id).focus();
			return;
		}
		if (valorMinimo > montoMax) {
			mensajeSis("El monto mínimo no puede ser mayor o igual al monto máximo del esquema de monto");
			$('#' + id).val(montoMin);
			$('#' + id).focus();
			return;
		}
	}

}

function validarMontoMax(id, fila) {
	var valorMaximo = $('#' + id).asNumber();
	var valorMinimo = $('#lisMontoMinEsqTasa' + fila).asNumber();

	if (!isNaN(valorMaximo) && valorMaximo != '') {
		if (valorMaximo > montoMax) {
			mensajeSis("El monto máximo no puede ser mayor al monto máximo del esquema de monto");
			$('#' + id).val(montoMax);
			$('#' + id).focus();
			return;
		}
		if (valorMaximo < montoMin) {
			mensajeSis("El monto máximo no puede ser menor o igual al monto mínimo del esquema de monto");
			$('#' + id).val(montoMax);
			$('#' + id).focus();
			return;
		}
		if (valorMaximo <= valorMinimo) {
			mensajeSis("El monto máximo no puede ser menor o igual al monto mínimo");
			$('#' + id).val(montoMax);
			$('#' + id).focus();
			return;
		}
	}
}

function eliminarDetalleEsqTasa(id) {
	$('#' + id).remove();
	reasignarTabIndex();
}

function agregarDetalleEsqTasa(idControl) {
	$('#grabaEsqTasa').show();
	var numTab = $('#numTabEsqTasa').asNumber();
	var numeroFila = $("#numeroFilaEsqTasa").asNumber();
	var numeroEsquema = $('#lisEsqTasaCredID' + numeroFila).asNumber();                         
	numeroEsquema++;
	numeroFila++;
	
	if(consultaFilas() == 0)
	{
		numeroFila=1;
	}
	
	var nuevaFila = "<tr id=\"renglonEsqTasa" + numeroFila + "\" name=\"renglonEsqTasa\">" + "<td>" +
						"<input id=\"consecutivoID" + numeroFila	+ "\" size=\"11\" name=\"consecutivoID\"  readonly  maxlength=\"9\" type=\"text\" value=\"" + numeroFila+ "\"  readonly/>" +
					"</td>" +
					"<td>" +
					"<select multiple id=\"sucursalID"+ numeroFila + "\" name=\"sucursalID\" onchange=\"seleccionarSucursales(this.id," + numeroFila+ ");\" >" +
					"<option value=\"0\">TODOS</option>" +
					"</select>" +
					"<input type=\"hidden\" id=\"lisSucursalID" + numeroFila + "\"  name=\"lisSucursalID\" value=\"0\"  />" +
						
					"</td>" +
					"<td>" +
						"<select multiple id=\"tipoEmpleadoIDEsqTasa"+ numeroFila + "\" name=\"tipoEmpleadoIDEsqTasa\");\" onchange=\"selecTipoEmpledados(this.id," + numeroFila+ ");\">" +
							"<option value=\"0\">TODOS</option>" +
						"</select>" +
						"<input type=\"hidden\" id=\"lisTipoEmpleadoIDEsqTasa" + numeroFila + "\"  name=\"lisTipoEmpleadoIDEsqTasa\" value=\"0\" />" +
					"</td>" +
					"<td>" +
					"<select multiple id=\"plazoID"+ numeroFila + "\" name=\"plazoID\");\" onchange=\"selecPlazos(this.id," + numeroFila+ ");\">" +
						"<option value=\"0\">TODOS</option>" +
					"</select>" +
					"<input type=\"hidden\" id=\"lisPlazoIDEsqTasa" + numeroFila + "\"  name=\"lisPlazoIDEsqTasa\" value=\"0\" />" +
					"</td>" +
					"<td>" +
					"<input id=\"lisMinCredEsqTasa" + numeroFila + "\" size=\"12\" name=\"lisMinCredEsqTasa\" type=\"text\" maxlength=\"6\"  value=\"0\"  style=\"text-align: right;\" onkeypress=\"return validaSoloNumero(event,this);\" />" +
					"</td>" +
					"<td>" +
					"<input id=\"lisMaxCredEsqTasa" + numeroFila + "\" size=\"12\" name=\"lisMaxCredEsqTasa\" type=\"text\" maxlength=\"6\"  value=\"0\"  style=\"text-align: right;\" onkeypress=\"return validaSoloNumero(event,this);\" />" +
					"</td>" +
					"<td>" +
						"<input id=\"lisMontoMinEsqTasa" + numeroFila + "\" size=\"12\" name=\"lisMontoMinEsqTasa\" maxlength=\"12\" type=\"text\" value=\"0\" esMoneda=\"true\"  style=\"text-align: right;\" onblur=\"validarMontoMin(this.id," + numeroFila + "); \" />" +
					"</td>" +
					"<td>" +
						"<input id=\"lisMontoMaxEsqTasa" + numeroFila + "\" size=\"12\" name=\"lisMontoMaxEsqTasa\" maxlength=\"12\"  type=\"text\" value=\"0\"  esMoneda=\"true\"  style=\"text-align: right;\" onblur=\"validarMontoMax(this.id," + numeroFila + ");\" />" +
					"</td>" +
					"<td>" +
					"<input id=\"lisTasaEsqTasa" + numeroFila + "\" size=\"12\" name=\"lisTasaEsqTasa\" type=\"text\" maxlength=\"10\"  value=\"0\" onblur=\"validaValorTasa(this.id);\" />" +
					"</td>" +
					"<td nowrap=\"nowrap\">" +
						"<input type=\"button\" id=\"agregarEsqTasa" + numeroFila + "\" name=\"agregarEsqTasa" + numeroFila + "\" value=\"\" class=\"btnAgrega\" onclick=\"agregarDetalleEsqTasa('tablaGridEsqTasa')\" />" +
					"</td>" +
					"<td nowrap=\"nowrap\">" +
						"<input type=\"button\" id=\"eliminarEsqTasa" + numeroFila + "\" name=\"eliminarEsqTasa" + numeroFila + "\" value=\"\" class=\"btnElimina\" onclick=\"eliminarDetalleEsqTasa('renglonEsqTasa" + numeroFila + "')\" />" +
					"</td>" +
				"</tr>";

	$('#' + idControl).append(nuevaFila);

	$("#numeroFilaEsqTasa").val(numeroFila);
	agregaFormatoControles('formaGenerica');
	
	if(tipoEmpleadoID != 0){
		$("#lisTipoEmpleadoIDEsqTasa" + numeroFila + " option[value=\"" + tipoEmpleadoID+ "\"]").attr("selected", "selected");
		$('#lisTipoEmpleadoIDEsqTasa' + numeroFila + ' option:not(:selected)').attr('disabled',true);
	}
    
	agregarSucursales('sucursalID' + numeroFila);
	agregarTipoEmpleadosFila('tipoEmpleadoIDEsqTasa' + numeroFila);
	seleccionarSucursales('sucursalID' + numeroFila, numeroFila);
	selecTipoEmpledados('tipoEmpleadoIDEsqTasa' + numeroFila, numeroFila);
	selecPlazos('plazoID' + numeroFila, numeroFila);	
	agregarPlazosDefinidos('plazoID' + numeroFila);
	
	reasignarTabIndex();
}


function consultaFilas(){
	var totales=0;
	$('tr[name=renglonEsqTasa]').each(function() {
         
		totales++;

	});
	return totales;
}
	


function cambioPaginaGridEsqTasa(pageValor) {
	var params = {};
	params['productoCreditoID']	= $('#productoCreditoID').val();
	params['tipoLista'] = 3;
	params['numeroLista'] = 1;
	params['page'] = pageValor;
	$.post("nomEsquemaTasaCredGridVista.htm", params, function(data) {
		if (data.length > 0) {
			$('#formaTablaEsqTasa').html(data);
			$('#contenedorEsqTasa').show();
			$('#formaTablaEsqTasa').show();
			if ($('#numeroRegistrosEsqTasa').val() <= 0) {
				$('#grabaEsqTasa').hide();
			} else {
				$('#grabaEsqTasa').show();
			}
		} else {
			mensajeSis("Error al generar la lista esquemas tasa de crédito");
			$('#contenedorEsqTasa').hide();
		}
	}).fail(function() {
		mensajeSis("Error al generar el grid de esquemas tasa de crédito");
		$('#contenedorEsqTasa').hide();
	});

}


function validaSoloNumero(e,elemento){//Recibe al evento 
		var key;
		if(window.event){//Internet Explorer ,Chromium,Chrome
		key = e.keyCode; 
		}else if(e.which){//Firefox , Opera Netscape
		key = e.which;
		}

		if (key > 31 && (key < 48 || key > 57)) //se valida, si son números los deja 
		return false;
		return true;
	}

