var esTab = false;
var cat_TipoAccesorios = {
	'Accesorios' 		: 1
};

var paramGen = {
		'valorParametro': '',
		'llaveParametro': ''
};
var mostrar;

$(document).ready(function() {
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});

	$('#formaGenerica').validate({
		rules: {
			accesorioID: 'required'				
		},		
		messages: {
			accesorioID: 'Especifique un Accesorio.',		
		}		
	});
	
	$('#grabar').click(function(event){

		$('#tipoTransaccion').val(cat_TipoAccesorios.Accesorios);
		grabaDetalleAccesorios('tbParam',event);
	});
	

	inicializar();
	actualizaTabIndex();
});
/**
 * Llama al función grabaFormaTransaccionRetrollamada.
 * @param idControl : ID de la Tabla a grabar.
 */
function grabaDetalleAccesorios(idControl, event){
	if(validarTabla(idControl)){
		if ($("#formaGenerica").valid()) {
			if(llenarDetalle(idControl))
				var transaccion = $("#tipoTransaccion").val();
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','producCreditoID','funcionExito','funcionError');
		}
	}
}
/**
 * Función para listar los accesorios
 * @param tipoLista
 */
function listaAccesorios(tipoLista){
	var paisesBean = {
			'tipoLista':		tipoLista
	};
	// Se declaran estas variables de manera local.
	var gridDetalleDiv = '';
	var idBotonGrabar = '';
	var idBotonAgregar = '';
	var idTablaParametrizacion = '';
	var idTab = '';

	switch (tipoLista) {
	case cat_TipoAccesorios.Accesorios:
		gridDetalleDiv ='#gridAccesorios';
		idBotonGrabar ='grabar';
		idBotonAgregar ='agregar';
		idTablaParametrizacion = 'tbParam';
		idTab = 'numTabMejora';
		break;
	}
	$(gridDetalleDiv).html("");
	$.post("otrosAccesoriosGridVista.htm", paisesBean, function(data) {
		if (data.length > 0 ) {
			$(gridDetalleDiv).html(data);
			$(gridDetalleDiv).show();
			// aquí debemos decir que muestre/oculte el TD de CAT
			habilitaBoton(idBotonAgregar,'submit');
		} else {
			$("#numTab").val(4);
			$(gridDetalleDiv).html("");
			$(gridDetalleDiv).show();
			deshabilitaBoton(idBotonAgregar,'submit');
			deshabilitaBoton(idBotonGrabar, 'submit');
		}
		// Se cambia el id de la tabla que viene desde el jsp del grid por uno nuevo.
		$("#tbParametrizacion").attr('id', idTablaParametrizacion);
		$("#btnAgregar").attr('id', idBotonAgregar);
		$("#numTab").attr('id', idTab);
		$("#agregar").focus();
	});
	
}

function inicializar(){
	listaAccesorios(cat_TipoAccesorios.Accesorios);
}

/**
 * Verifica si se muestra cálculo cat
 * */
function muestraCAT() {
	var tipoConsulta = 39;
	paramGeneralesServicio.consulta(tipoConsulta, paramGen, function(consulta) {
		if(consulta != null) {
			if(consulta.valorParametro == 'S') {
				mostrar = true
			}
			else {
				$('#tdCAT, #valCAT').hide();
				$('#tdValCAT').hide();
				mostrar = false;
			}
		}
	});
}

/**
 * Actualiza los tabindex de ambas tablas.
 */
function actualizaTabIndex(){
	reasignaTabIndex('tbParam');
}
/**
 * Función de  de éxito que se ejecuta cuando después de grabar
 * la transacción y ésta fue exitosa.
 */
function funcionExito(){
	actualizaTabIndex();
	listaAccesorios(cat_TipoAccesorios.Accesorios);
}
/**
 * Funcion de error que se ejecuta cuando después de grabar
 * la transacción marca error.
 */
function funcionError(){
	
}
/**
 * Agrega un nuevo renglón (detalle) a la tabla del grid.
 * @param idControl : ID de algún campo para obtener el ID de la tabla a la que pertenece.
 */
function agregarDetalle(idControl){	
	var idTablaParametrizacion = $('#'+idControl).closest('table').attr('id');
	var idBotonGrabar = '';
	var idTab = '';

	if(idTablaParametrizacion == 'tbParam'){
		idBotonGrabar ='grabar';
		idTab = 'numTab';
	}
	reasignaTabIndex('tbParam');
	habilitaBoton(idBotonGrabar, 'submit');
	if(validarTabla(idTablaParametrizacion)){
		var numTab=$("#"+idTab).asNumber();

		var numeroFila=parseInt(getRenglones(idTablaParametrizacion));
		numTab++;
		numeroFila++;
		var nuevaFila;
		
		if(mostrar) {
			nuevaFila=
			"<tr id=\"tr"+numeroFila+"\" name=\"tr"+"\">"+
				"<td nowrap=\"nowrap\">"+
					"<input type=\"text\" id=\"accesorioID"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"accesorioID"+"\" size=\"5\" maxlength=\"5\" disabled=\"disabled\" value=\"0\" onkeypress=\"return validaNumero(event)\" />"+
				"</td><td></td>"+
				"<td>"+
					"<input type=\"text\" id=\"descripcion"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"descripcion"+"\" size=\"50\" maxlength=\"100\" onBlur='ponerMayusculas(this)'/>"+
				"</td><td></td>"+
				"<td>"+
					"<input type=\"text\" id=\"abreviatura"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"abreviatura"+"\" size=\"10\" maxlength=\"10\" onBlur='ponerMayusculas(this)'/>"+
				"</td><td></td>"+
				"<td>"+
					"<input type=\"text\" id=\"prelacion"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"prelacion"+"\" size=\"5\" maxlength=\"5\" onkeypress=\"return validaNumero(event)\" />"+
				"</td>"+
				"<td nowrap=\"nowrap\">"+
					"<input type=\"button\" id=\"eliminar"+numeroFila+"\"name=\"eliminar"+"\" value=\"\" class=\"btnElimina\" onclick=\"eliminarParam('tr"+numeroFila+"')\" tabindex=\""+(numTab)+"\"/> "+
					"<input type=\"button\" id=\"agrega"+numeroFila+"\" name=\"agrega"+"\" value=\"\" class=\"btnAgrega\" onclick=\"agregarDetalle(this.id)\" tabindex=\""+(numTab)+"\"/>"+
				"</td>"+
				// mostrar/ocultar la columna CAT
				"<td id=\"tdValCAT\">"+
					"<input type=\"checkbox\" id=\"calculoCAT"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"calculoCAT"+"\" readOnly checked/>"+
				"</td>"+
			"</tr>";
		} else {
			nuevaFila=
			"<tr id=\"tr"+numeroFila+"\" name=\"tr"+"\">"+
				"<td nowrap=\"nowrap\">"+
					"<input type=\"text\" id=\"accesorioID"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"accesorioID"+"\" size=\"5\" maxlength=\"5\" disabled=\"disabled\" value=\"0\" onkeypress=\"return validaNumero(event)\" />"+
				"</td><td></td>"+
				"<td>"+
					"<input type=\"text\" id=\"descripcion"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"descripcion"+"\" size=\"50\" maxlength=\"100\" onBlur='ponerMayusculas(this)'/>"+
				"</td><td></td>"+
				"<td>"+
					"<input type=\"text\" id=\"abreviatura"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"abreviatura"+"\" size=\"10\" maxlength=\"10\" onBlur='ponerMayusculas(this)'/>"+
				"</td><td></td>"+
				"<td>"+
					"<input type=\"text\" id=\"prelacion"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"prelacion"+"\" size=\"5\" maxlength=\"5\" onkeypress=\"return validaNumero(event)\" />"+
				"</td>"+
				"<td nowrap=\"nowrap\">"+
					"<input type=\"button\" id=\"eliminar"+numeroFila+"\"name=\"eliminar"+"\" value=\"\" class=\"btnElimina\" onclick=\"eliminarParam('tr"+numeroFila+"')\" tabindex=\""+(numTab)+"\"/> "+
					"<input type=\"button\" id=\"agrega"+numeroFila+"\" name=\"agrega"+"\" value=\"\" class=\"btnAgrega\" onclick=\"agregarDetalle(this.id)\" tabindex=\""+(numTab)+"\"/>"+
				"</td>"+
				 
				// mostrar/ocultar la columna CAT
				"<td id=\"tdValCAT\" style=\"visibility:hidden;\">"+
					"<input type=\"checkbox\" id=\"calculoCAT"+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"calculoCAT"+"\" readOnly checked/>"+
				"</td>"+
			"</tr>";
		}
		
		
		$('#'+idTablaParametrizacion).append(nuevaFila);
		$("#"+idTab).val(numTab);
		$("#numeroFila").val(numeroFila);
	}
	$("#descripcion"+numeroFila).focus();
}

/**
 * Remueve de la tabla un tr.
 * @param id : ID del tr.
 */
function eliminarParam(id){
	$('#'+id).remove();
}

/**
 * @param idControl : ID de la tabla a validar.
 * @returns {Boolean}
 */
function validarTabla(idControl){
	var validar = true;
	var arregloPrelacion = new Array();
	
	$('#'+idControl+' tr').each(function(index){
		if(index>1){
			var accesorioID = "#"+$(this).find("input[name^='accesorioID"+"']").attr("id");
			var descripcion="#"+$(this).find("input[name^='descripcion"+"']").attr("id");
			var abreviatura="#"+$(this).find("input[name^='abreviatura"+"']").attr("id");
			var prelacion ="#"+$(this).find("input[name^='prelacion"+"']").attr("id");
			var cat ="#"+$(this).find("input[name^='calculoCAT"+"']").attr("id");

			var accesorio = $(accesorioID).val().trim();
			var descAccesorio = $(descripcion).val().trim();
			var abrevAccesorio = $(abreviatura).val().trim();
			var prelacAccesorio = $(prelacion).val().trim();
			var catAccesorio = $(cat).val().trim();
			if($(cat).attr('checked')) catAccesorio = 'S'
			else catAccesorio = 'N'

			if(accesorio==='') {
				agregarFormaError(accesorioID);
				validar=false;
			}

			if(descAccesorio==='') {
				agregarFormaError(descripcion);
				validar=false;
			}

			if(abrevAccesorio==='') {
				agregarFormaError(abreviatura);
				validar=false;
			}

			if (arregloPrelacion.includes(prelacAccesorio)) {
				agregarFormaError(prelacion);
				mensajeSis("El número de prelación ya se encuentra asignado a otro Accesorio.");
				validar = false;
			}

			if(prelacAccesorio==='') {
				agregarFormaError(prelacion);
				validar=false;
			}

			arregloPrelacion[index] = prelacAccesorio;
		}
	});
	return validar;
}


/**
 * Función arma la cadena con los detalles del grid dependiendo del tipo de catálogo.
 * @param idControl : ID de algún campo para obtener el ID de la tabla a la que pertenece.
 * @returns {Boolean}
 */
function llenarDetalle(){
	var idDetalle = '#detalleAccesorios';

	$(idDetalle).val('');
	$('#tbParam tr').each(function(index){
		if(index>1){
			var accesorioID = "#"+$(this).find("input[name^='accesorioID"+"']").attr("id");
			var descripcion="#"+$(this).find("input[name^='descripcion"+"']").attr("id");
			var abreviatura="#"+$(this).find("input[name^='abreviatura"+"']").attr("id");
			var prelacion ="#"+$(this).find("input[name^='prelacion"+"']").attr("id");
			var cat ="#"+$(this).find("input[name^='calculoCAT"+"']").attr("id");
			var accesorio = $(accesorioID).val();
			var descAccesorio = $(descripcion).val();
			var abrevAccesorio = $(abreviatura).val();
			var prelacAccesorio = $(prelacion).val();
			var catAccesorio = '';
			
			if($(cat).attr('checked'))  catAccesorio = 'S';
			else catAccesorio = 'N';
			
			if (index == 1) {
				$(idDetalle).val( $(idDetalle).val()+
				 accesorio+']'+ descAccesorio+']'+ abrevAccesorio+']' + prelacAccesorio+']' + catAccesorio+']');
			} else{
				$(idDetalle).val( $(idDetalle).val()+'['+
				+ accesorio+']'+ descAccesorio+']'+ abrevAccesorio+']' + prelacAccesorio+']' + catAccesorio+']');
			}
		}
	});
	return true;
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


/**
 * @param idControl : ID del input que genera el evento.
 * @returns 
 */
function seRepite(idControl){
	var serepite = 0;
	var valor=$('#'+idControl).val();

	$("# input[name^='accesorioID']").each(function(){
		var valor2=$('#'+this.id).val();
		if (idControl!=this.id && (valor2!=undefined && valor2!='') && valor == valor2) {
			serepite++;
			return false;
		}
	});

	if(serepite>0){
		return true;
	}
	return false;
}

/**
 * Válida que no este repetida la frecuencia
 * @param id : ID del input que genera el evento.
 */
function verificaSeleccionado(id){
	if(seRepite(id)){
		$("#"+id).val("");
		$("#"+id).focus();
	}
}

/**
 * Regresa el número de renglones de un grid.
 * @param idTablaParametrizacion : ID de la tabla a la que se va a contar el número de renglones.
 * @returns Número de renglones de la tabla.
 */
function getRenglones(idTablaParametrizacion){
	var numRenglones = $('#'+idTablaParametrizacion+' >tbody >tr[name^="tr'+'"]').length;
	return numRenglones;
}

/**
 * Reasigna/actualiza el número de tabindex de los inputs que se encuentran dentro de la tabla. 
 * @param idTablaParametrizacion : ID de la tabla a actualizar.
 */
function reasignaTabIndex(idTablaParametrizacion){
	var numInicioTabs = 3;
	var idTab = '';
		idTab = 'numTab';

	$('#'+idTablaParametrizacion+' tr').each(function(index){
		if(index>1){
			var accesorioID = "#"+$(this).find("input[name^='accesorioID"+"']").attr("id");
			var descripcion="#"+$(this).find("input[name^='descripcion"+"']").attr("id");
			var abreviatura="#"+$(this).find("input[name^='abreviatura"+"']").attr("id");
			var prelacion ="#"+$(this).find("input[name^='prelacion"+"']").attr("id");

			var agrega="#"+$(this).find("input[name^='agrega"+"']").attr("id");
			var elimina="#"+$(this).find("input[name^='eliminar"+"']").attr("id");


			numInicioTabs++;
			$(accesorioID).attr('tabindex' , numInicioTabs);
			$(descripcion).attr('tabindex' , numInicioTabs);
			$(abreviatura).attr('tabindex' , numInicioTabs);
			$(prelacion).attr('tabindex' , numInicioTabs);
			$(elimina).attr('tabindex' , numInicioTabs);
			$(agrega).attr('tabindex' , numInicioTabs);
		}
	});
	$('#'+idTab).val(numInicioTabs);
}


/**
 *	checkea los campos en S
 **/

function checkCalculoCAT() {
	var numeroRenglones = Number(getRenglones('tbParametrizacion'));
	var id = 'calculoCAT';
	for(var i= 1; i<= numeroRenglones; i++) {
		id = '#calculoCAT'+i;
		var renglon = $(id);
		if(renglon.val() == 'S') {
			renglon.attr("checked", "checked");
		}
	}
	
}

/**
 * Habilita o deshabilita el boton de GRABAR de la tabla. 
 */
function habilitaGrabar(){
	var numeroRenglones = Number(getRenglones('tbParametrizacion'));
	if(numeroRenglones > 0){
		habilitaBoton('grabar', 'submit');
	} else {
		deshabilitaBoton('grabar', 'submit');
	}
	muestraCAT();
	checkCalculoCAT();
}

function validaNumero(e){
	var tecla = (document.all) ? e.keyCode : e.which;

	if(tecla==8){
		return true;
	}
	var teclasPermitidas = /[0-9]/;
	var teclaFinal = String.fromCharCode(tecla);
	return teclasPermitidas.test(teclaFinal);
}