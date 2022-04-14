var esTab = false;

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

	$('#grabar').click(function(event){
		$('#tipoTransaccion').val(1);
		grabaDetalles('tbParametrizacion',event);
	});

	inicializar();
	actualizaTabIndex();
});
/**
 * Llama al función grabaFormaTransaccionRetrollamada.
 * @param idControl : ID de la Tabla a grabar.
 * @author avelasco
 */
function grabaDetalles(idControl,event){
	if(validarTabla(idControl)){
		if ($("#formaGenerica").valid()) {
			if(llenarDetalle(idControl))
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','paisID','funcionExito','funcionError');
		}
	}
}
/**
 * Consulta la lista de paises y los muestra en el grid.
 * @param tipoLista : Número de lista a consultar: 1.
 * @author avelasco
 */
function consultaPaises(){
	var paisesBean = {
			'tipoLista' : 1
	};
	// Se declaran estas variables de manera local.
	var gridDetalleDiv ='#gridISRExtranjero';
	$(gridDetalleDiv).html("");

	$.post("tasasISRExtGrid.htm", paisesBean, function(data) {
		if (data.length > 0 ) {
			$(gridDetalleDiv).html(data);
			$(gridDetalleDiv).show();
			habilitaBoton('btnAgregar','submit');
		} else {
			$("#numTab").val(4);
			$(gridDetalleDiv).html("");
			$(gridDetalleDiv).show();
			deshabilitaBoton('btnAgregar','submit');
			deshabilitaBoton('grabar', 'submit');
		}
	});
	$("#agregar").focus();
	agregaFormatoControles('formaGenerica');
}

/**
 * Inicializa la forma. Carga y lista los paises de los dos catálogos.
 * @author avelasco
 */
function inicializar(){
	consultaPaises();
}
/**
 * Actualiza los tabindex de ambas tablas.
 * @author avelasco
 */
function actualizaTabIndex(){
	reasignaTabIndex('tbParametrizacion');
}
/**
 * Función de  de éxito que se ejecuta cuando después de grabar
 * la transacción y ésta fue exitosa.
 * @author avelasco
 */
function funcionExito(){
	inicializar();
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
	reasignaTabIndex(idTablaParametrizacion);
	habilitaBoton('grabar', 'submit');

	if(validarTabla(idTablaParametrizacion)){
		var numTab=$("#numTab").asNumber();
		var numeroFila=numTab;
		numTab++;
		numeroFila++;
		var nuevaFila=
			'<tr id="tr' + numeroFila + '" name="tr">' +
				'<td nowrap="nowrap">' +
					'<input type="text" id="paisID' + numeroFila + '" tabindex="'+numTab+'" name="paisID" size="5" value="" maxlength="5" onblur="consultaPais(this.id,\'nombre' + numeroFila + '\')" onkeypress="listaPaises(this.id)" onchange="verificaSeleccionado(this.id)" />' +
				'</td>' +
				'<td nowrap="nowrap">' +
					'<input type="text" id="nombre' + numeroFila + '" name="nombre" size="32" value="" maxlength="150" readonly="readonly" disabled="true"/>' +
				'</td>' +
				'<td nowrap="nowrap">' +
					'<input type="text" id="tasaISR' + numeroFila + '" name="tasaISR" size="8" value="" maxlength="150" esMoneda="true" style="text-align: right;" tabindex="'+numTab+'" onchange="validaTasaISR(this.id)"/> ' +
					'<label></label>' +
				'</td>' +
				'<td nowrap="nowrap">' +
					'<input type="button" id="eliminar' + numeroFila + '" name="eliminar" value="" class="btnElimina" onclick="eliminarParam(\'tr' + numeroFila + '\')" tabindex="'+numTab+'"/> ' +
					'<input type="button" id="agrega' + numeroFila + '" name="agrega" value="" class="btnAgrega" onclick="agregarDetalle(this.id)" tabindex="'+numTab+'"/>' +
				'</td>' +
			'</tr>';
		$('#'+idTablaParametrizacion).append(nuevaFila);
		$("#numTab").val(numTab);
		$("#numeroFila").val(numeroFila);
		agregaFormatoControles('formaGenerica');
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
	if(getRenglones('tbParametrizacion')>0){
		$('#tbParametrizacion >tbody >tr[name^="tr"]').each(function(index){
			if(index >= 0){
				var paisid = "#"+$(this).find("input[name^='paisID']").attr("id");
				var tasaISR="#"+$(this).find("input[name^='tasaISR']").attr("id");
				if($(paisid).val()==='') {
					agregarFormaError(paisid);
					validar=false;
				}
				if($(tasaISR).asNumber() == 0) {
					agregarFormaError(tasaISR);
					validar=false;
				}
			}
		});
	}
	return validar;
}
/**
 * Función arma la cadena con los detalles del grid.
 * @param idControl : ID de algún campo para obtener el ID de la tabla a la que pertenece.
 * @returns {Boolean}
 * @author avelasco
 */
function llenarDetalle(idControl){
	var idDetalle = '#detalle';
	var validar = true;

	$(idDetalle).val('');
	$('#tbParametrizacion >tbody >tr[name^="tr"]').each(function(index){
		if(index >= 0){
			var paisid = "#"+$(this).find("input[name^='paisID']").attr("id");
			var tasaISR = "#"+$(this).find("input[name^='tasaISR']").attr("id");

			if (index == 0) {
				$(idDetalle).val( $(idDetalle).val()+
				$(paisid).val()+']'+
				$(tasaISR).val()+']');
			} else{
				$(idDetalle).val( $(idDetalle).val()+'['+
				$(paisid).val()+']'+
				$(tasaISR).val()+']');
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
	var conPais = 6;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numPais != '' && !isNaN(numPais)) {
		paisesServicio.consultaPaises(conPais, numPais, function(pais) {
			if (pais != null) {
				$(jqDesc).val(pais.nombre);
			} else {
				mensajeSis("No Existe el País.");
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
	lista(idControl, '1', '4', 'nombre', $('#'+idControl).val(),'listaPaises.htm');
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
	var numRenglones = $('#'+idTablaParametrizacion+' >tbody >tr[name^="tr"]').length;
	return numRenglones;
}
/**
 * Reasigna/actualiza el número de tabindex de los inputs que se encuentran dentro de la tabla.
 * @param idTablaParametrizacion : ID de la tabla a actualizar.
 * @author avelasco
 */
function reasignaTabIndex(idTablaParametrizacion){
}
/**
 * Habilita o deshabilita el boton de GRABAR de la tabla.
 * @author avelasco
 */
function habilitaGrabar(){
	var numeroRenglones = Number(getRenglones('tbParametrizacion'));
	$('#btnAgregar').focus();
	if(numeroRenglones > 0){
		habilitaBoton('grabar', 'submit');
	} else {
		deshabilitaBoton('grabar', 'submit');
	}
}
function validaTasaISR(idControl){
	var jqTasaISR = eval("'#" + idControl + "'");
	var valorTasa = $(jqTasaISR).asNumber();
	var tasaLimite= 1.0;
	if(valorTasa >= tasaLimite){
		$(jqTasaISR).val('0.00');
		$(jqTasaISR).focus();
		mensajeSis('El Valor de la Tasa ISR no puede ser Mayor o Igual a <b>1.00</b>.')
	}
}