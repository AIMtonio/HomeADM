var esTab = false;
var cat_TipoPaises = {
	'EnMejora' 		: 1,
	'NoCooperantes' : 2,
	'TipoMejora' 		: 'M',
	'TipoNoCooperantes' : 'N'
};

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
			paisID: 'required'				
		},		
		messages: {
			paisID: 'Especifique un país.',		
		}		
	});
	
	$('#grabarNoCoop').click(function(event){
		$('#tipoTransaccion').val(cat_TipoPaises.NoCooperantes);
		$('#tipoPais').val(cat_TipoPaises.TipoNoCooperantes);
		grabaDetallesPaisesGAFI('tbParamNoCoop',event);
	});
	
	$('#grabarMejora').click(function(event){
		$('#tipoTransaccion').val(cat_TipoPaises.EnMejora);
		$('#tipoPais').val(cat_TipoPaises.TipoMejora);
		grabaDetallesPaisesGAFI('tbParamMejora',event);
	});
	inicializar();
	actualizaTabIndex();
});
/**
 * Llama al función grabaFormaTransaccionRetrollamada.
 * @param idControl : ID de la Tabla a grabar.
 * @author avelasco
 */
function grabaDetallesPaisesGAFI(idControl,event){
	if(validarTabla(idControl)){
		if ($("#formaGenerica").valid()) {
			if(llenarDetalle(idControl))
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','producCreditoID','funcionExito','funcionError');
		}
	}
}
/**
 * Consulta la lista de paises de acuerdo al tipo de catálogo, y los muestra en el grid.
 * @param tipoLista : Número de lista a consultar: 1.- Paises en Mejora, 2.- Paises No Cooperantes.
 * @author avelasco
 */
function consultaPaisesGAFI(tipoLista){
	var paisesBean = {
			'tipoLista':		tipoLista
	};
	// Se declaran estas variables de manera local.
	var gridDetalleDiv = '';
	var idBotonGrabar = '';
	var idBotonAgregar = '';
	var idTablaParametrizacion = '';
	var idTab = '';
	// Dependiendo del tipo de pais a consultar se pobla con datos el grid correspondiente.
	switch (tipoLista) {
	case cat_TipoPaises.EnMejora:
		gridDetalleDiv ='#gridPaisesEnMejora';
		idBotonGrabar ='grabarMejora';
		idBotonAgregar ='agregarMejora';
		idTablaParametrizacion = 'tbParamMejora';
		idTab = 'numTabMejora';
		break;
	case cat_TipoPaises.NoCooperantes:
		gridDetalleDiv ='#gridPaisesNoCoop';
		idBotonGrabar ='grabarNoCoop';
		idBotonAgregar ='agregarNoCoop';
		idTablaParametrizacion = 'tbParamNoCoop';
		idTab = 'numTabNoCoop';
		break;
	}
	$(gridDetalleDiv).html("");
	$.post("paisesGafiGrid.htm", paisesBean, function(data) {
		if (data.length > 0 ) {
			$(gridDetalleDiv).html(data);
			$(gridDetalleDiv).show();
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
		$("#agregarNoCoop").focus();
	});
}

/**
 * Inicializa la forma. Carga y lista los paises de los dos catálogos.
 * @author avelasco
 */
function inicializar(){
	consultaPaisesGAFI(cat_TipoPaises.EnMejora);
	consultaPaisesGAFI(cat_TipoPaises.NoCooperantes);
}
/**
 * Actualiza los tabindex de ambas tablas.
 * @author avelasco
 */
function actualizaTabIndex(){
	reasignaTabIndex('tbParamMejora');
	reasignaTabIndex('tbParamNoCoop');
}
/**
 * Función de  de éxito que se ejecuta cuando después de grabar
 * la transacción y ésta fue exitosa.
 * @author avelasco
 */
function funcionExito(){
	inicializar();
	actualizaTabIndex();
}
/**
 * Funcion de error que se ejecuta cuando después de grabar
 * la transacción marca error.
 * @author avelasco
 */
function funcionError(){
	
}
/**
 * Agrega un nuevo renglón (detalle) a la tabla del grid.
 * @param idControl : ID de algún campo para obtener el ID de la tabla a la que pertenece.
 * @author avelasco
 */
function agregarDetalle(idControl){	
	var idTablaParametrizacion = $('#'+idControl).closest('table').attr('id');
	var idBotonGrabar = '';
	var idTipoReng = '';
	var idTab = '';

	if(idTablaParametrizacion == 'tbParamMejora'){
		idBotonGrabar ='grabarMejora';
		idTipoReng = 'M';
		idTab = 'numTabMejora';
	} else if(idTablaParametrizacion == 'tbParamNoCoop'){
		idBotonGrabar ='grabarNoCoop';
		idTipoReng = 'N';
		idTab = 'numTabNoCoop';
	}
	reasignaTabIndex(idTablaParametrizacion);
	habilitaBoton(idBotonGrabar, 'submit');
	if(validarTabla(idTablaParametrizacion)){
		var numTab=$("#"+idTab).asNumber();
		var numeroFila=parseInt(getRenglones(idTablaParametrizacion));
		numTab++;
		numeroFila++;
		var nuevaFila=
		"<tr id=\"tr"+idTipoReng+numeroFila+"\" name=\"tr"+idTipoReng+"\">"+
			"<td nowrap=\"nowrap\">"+
				"<label>Pa&iacute;s: </label>"+
				"<input type=\"text\" id=\"paisID"+idTipoReng+numeroFila+"\" tabindex=\""+(numTab)+"\" name=\"paisID"+idTipoReng+"\" size=\"5\" maxlength=\"5\" onblur=\"consultaPais(this.id,'nombre"+idTipoReng+numeroFila+"')\"  onkeypress=\"listaPaises(this.id)\" onchange=\"verificaSeleccionado(this.id)\" />"+
			"</td>"+
			"<td>"+
				"<input type=\"text\" id=\"nombre"+idTipoReng+numeroFila+"\" name=\"nombre"+idTipoReng+"\" size=\"32\" maxlength=\"150\" readonly=\"readonly\" disabled=\"true\"/>"+
			"</td>"+
			"<td nowrap=\"nowrap\">"+
				"<input type=\"button\" id=\"eliminar"+idTipoReng+numeroFila+"\"name=\"eliminar"+idTipoReng+"\" value=\"\" class=\"btnElimina\" onclick=\"eliminarParam('tr"+idTipoReng+numeroFila+"')\" tabindex=\""+(numTab)+"\"/> "+
				"<input type=\"button\" id=\"agrega"+idTipoReng+numeroFila+"\" name=\"agrega"+idTipoReng+"\" value=\"\" class=\"btnAgrega\" onclick=\"agregarDetalle(this.id)\" tabindex=\""+(numTab)+"\"/>"+
			"</td>"+
		"</tr>";
		$('#'+idTablaParametrizacion).append(nuevaFila);
		$("#"+idTab).val(numTab);
		$("#numeroFila").val(numeroFila);
	}
}
/**
 * Remueve de la tabla un tr.
 * @param id : ID del tr.
 * @author avelasco
 */
function eliminarParam(id){
	$('#'+id).remove();
}

/**
 * Válida que todos el campo con name paisID de la tabla este requisitado correctamente.
 * @param idControl : ID de la tabla a validar.
 * @returns {Boolean}
 * @author avelasco
 */
function validarTabla(idControl){
	var validar = true;
	var idTipoReng ='';
	if(idControl == 'tbParamMejora'){
		idTipoReng = 'M';
	} else if(idControl == 'tbParamNoCoop'){
		idTipoReng = 'N';
	}
	$('#'+idControl+' tr').each(function(index){
		if(index>0){
			var paisid = "#"+$(this).find("input[name^='paisID"+idTipoReng+"']").attr("id");
			var nombre="#"+$(this).find("input[name^='nombre"+idTipoReng+"']").attr("id");
			var pais = $(paisid).val();
			var nombPais = $(nombre).val();
			if(pais==='') {
				agregarFormaError(paisid);
				validar=false;
			}
		}
	});
	return validar;
}
/**
 * Función arma la cadena con los detalles del grid dependiendo del tipo de catálogo.
 * @param idControl : ID de algún campo para obtener el ID de la tabla a la que pertenece.
 * @returns {Boolean}
 * @author avelasco
 */
function llenarDetalle(idControl){
	var idTablaParametrizacion = $('#'+idControl).closest('table').attr('id');
	var idDetalle = '';
	var validar = true;
	var idTipoReng ='';
	if(idTablaParametrizacion == 'tbParamMejora'){
		idDetalle ='#detalleMejora';
		idTipoReng = 'M';
	} else if(idTablaParametrizacion == 'tbParamNoCoop'){
		idDetalle ='#detalleNoCoop';
		idTipoReng = 'N';
	}
	
	$('#detalleNoCoop').val('');
	$('#detalleMejora').val('');
	$('#'+idTablaParametrizacion+' tr').each(function(index){
		if(index>0){
			var paisid = "#"+$(this).find("input[name^='paisID"+idTipoReng+"']").attr("id");
			var nombre="#"+$(this).find("input[name^='nombre"+idTipoReng+"']").attr("id");
			var pais = $(paisid).val();
			var nombPais = $(nombre).val();
			
			if (index == 1) {
				$(idDetalle).val( $(idDetalle).val()+
				pais+']'+ nombPais+']' + idTipoReng+']');
			} else{
				$(idDetalle).val( $(idDetalle).val()+'['+
				pais+']'+ nombPais+']' + idTipoReng+']');
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
 * Consulta un pais del catálogo PAISES
 * @param idControl : ID del input que tiene el ID del país.
 * @param idControlNom	: ID del input para mostrar el nombre del país consultado.
 * @author avelasco
 */
function consultaPais(idControl,idControlDesc){
	var jqPais = eval("'#" + idControl + "'");
	var jqDesc = eval("'#" + idControlDesc + "'");
	var numPais = $(jqPais).val();
	var conPais = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numPais != '' && !isNaN(numPais)) {
		paisesServicio.consultaPaises(conPais, numPais, function(pais) {
			if (pais != null) {
				$(jqDesc).val(pais.nombre);
			} else {
				alert("No Existe el País.");
				$(jqPais).val('');
				$(jqDesc).val('');
				$(jqPais).focus();
			}
		});
	}else{
		$(jqPais).val('');
		$(jqDesc).val('');
	}
}

/**
 * Lista los paises en un determinado renglón del grid.
 * @param idControl : ID del input que tiene el ID del país.
 * @author avelasco
 */
function listaPaises(idControl){
	lista(idControl, '1', '1', 'nombre', $('#'+idControl).val(),'listaPaises.htm');
}
/**
 * Valida si se repite un pais en alguno de los catálogos.
 * @param idControl : ID del input que genera el evento.
 * @returns 
 * @author avelasco
 */
function seRepite(idControl){
	var serepite = 0;
	var valor=$('#'+idControl).val();
	// busca coincidencias en la tabla de paises no cooperantes
	$("#tbParamNoCoop input[name^='paisIDN']").each(function(){
		var valor2=$('#'+this.id).val();
		if (idControl!=this.id && (valor2!=undefined && valor2!='') && valor == valor2) {
			serepite++;
			return false;
		}
	});
	// busca coincidencias en la tabla de paises en mejora
	$("#tbParamMejora input[name^='paisIDM']").each(function(){
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
 * @author avelasco
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
 * @author avelasco
 */
function getRenglones(idTablaParametrizacion){
	var idTipoReng = '';
	if(idTablaParametrizacion == 'tbParamMejora'){
		idTipoReng = 'M';
	} else if(idTablaParametrizacion == 'tbParamNoCoop'){
		idTipoReng = 'N';
	}
	var numRenglones = $('#'+idTablaParametrizacion+' >tbody >tr[name^="tr'+idTipoReng+'"]').length;
	return numRenglones;
}
/**
 * Reasigna/actualiza el número de tabindex de los inputs que se encuentran dentro de la tabla. 
 * @param idTablaParametrizacion : ID de la tabla a actualizar.
 * @author avelasco
 */
function reasignaTabIndex(idTablaParametrizacion){
	var numInicioTabs = 0;
	var idTipoReng = '';
	var idTab = '';
	if(idTablaParametrizacion == 'tbParamMejora'){
		numInicioTabs = 301;
		idTipoReng = 'M';
		idTab = 'numTabMejora';
	} else if(idTablaParametrizacion == 'tbParamNoCoop'){
		numInicioTabs = 1;
		idTipoReng = 'N';
		idTab = 'numTabNoCoop';
	}
	$('#'+idTablaParametrizacion+' tr').each(function(index){
		if(index>0){
			var paisid = "#"+$(this).find("input[name^='paisID"+idTipoReng+"']").attr("id");
			var agrega="#"+$(this).find("input[name^='agrega"+idTipoReng+"']").attr("id");
			var elimina="#"+$(this).find("input[name^='eliminar"+idTipoReng+"']").attr("id");
			numInicioTabs++;
			$(paisid).attr('tabindex' , numInicioTabs);
			$(elimina).attr('tabindex' , numInicioTabs);
			$(agrega).attr('tabindex' , numInicioTabs);
		}
	});
	$('#'+idTab).val(numInicioTabs);
}
/**
 * Habilita o deshabilita el boton de GRABAR de la tabla. 
 * @author avelasco
 */
function habilitaGrabar(){
	var numeroRenglones = Number(getRenglones('tbParametrizacion'));

	if(numeroRenglones > 0){
		habilitaBoton('grabarNoCoop', 'submit');
		habilitaBoton('grabarMejora', 'submit');
	} else {
		deshabilitaBoton('grabarNoCoop', 'submit');
		deshabilitaBoton('grabarMejora', 'submit');
	}
}