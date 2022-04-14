var esTab;
var parametroBean = consultaParametrosSession();
var cargandoGrid=false;
var estatusProd = "";
var descripcion = "";

consultaProductosCredito();

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

	$('#formaGenerica').validate({
		rules: {
			producCreditoID: 'required'				
		},		
		messages: {
			producCreditoID: 'Especifique producto de crédito',		
		}		
	});
	
	$('#grabar').click(function(event){
		if(validarTabla()){
		if ($("#formaGenerica").valid()) {
				if(llenarDetalle())
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','producCreditoID','funcionExito','funcionError');
			}
		}
	});
	$('#producCreditoID').bind('keyup',function(e) {
		lista('producCreditoID', '1', '15','descripcion', $('#producCreditoID').val(),'listaProductosCredito.htm');
	});
	
	$('#producCreditoID').blur(function() {
		var producto = $('#producCreditoID').asNumber();
		if(producto>0){
			consultaProductosCredito(this.id);
			habilitaBoton('grabar', 'submit');
		} else {
			agregaFormatoControles('formaGenerica');
			deshabilitaBoton('grabar', 'submit');
			$("#numTab").val(4);
			$('#gridDetalleDiv').html("");
			$('#gridDetalleDiv').show();
		}
	});
});
/**
 * Inicializa la forma
 */
function inicializar(){
	agregaFormatoControles('formaGenerica');
	$('#producCreditoID').focus();
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('btnAgregar', 'submit');
	$("#numTab").val(4);
	$('#gridDetalleDiv').html("");
	$('#gridDetalleDiv').show();
}
/**
 * Funcio de exito
 */
function funcionExito(){

	$("#numTab").val(4);
	$('#gridDetalleDiv').html("");
	$('#gridDetalleDiv').show();
	deshabilitaBoton('btnAgregar','submit');
	deshabilitaBoton('grabar', 'submit');
	$("#producCreditoID").blur();
}
/**
 * Funcion de error
 */
function funcionError(){
	
}
/**
 * Consulta los productos de crédito
 */

function consultaProductosCredito(idControl) {

	var jqProducto = eval("'#" + idControl + "'");
	var numProducto = $(jqProducto).val();
	var conForanea = 1;
	var ProductoCreditoCon = {
		'producCreditoID' : numProducto
	};
	setTimeout("$('#cajaLista').hide();", 200);
	estatusProd = "";
	descripcion = "";
	if (numProducto != '' && !isNaN(numProducto)) {
		productosCreditoServicio.consulta(conForanea, ProductoCreditoCon, function(productos) {
			if (productos != null) {
				$('#descripProducto').val(productos.descripcion);
				estatusProd = productos.estatus;
				descripcion = productos.descripcion;
				consultaFrecuenciaProductos();
			} else {
				mensajeSis("No Existe el producto de crédito");
				$(jqProducto).focus();
			}
		});
	}
}
/**
 * Consulta los plazos por producto
 * @returns
 */
function consultaFrecuenciaProductos(){
	var lista_frecuencia = 3;
	var producCreditoID=$('#producCreditoID').asNumber();
	var bean={
			'producCreditoID': producCreditoID
	}
	dwr.util.removeAllOptions('frecuenciaBase');
	dwr.util.addOptions('frecuenciaBase', {'':'SELECCIONAR'});
	
	if(producCreditoID>0){
		catFrecuenciasServicio.lista(lista_frecuencia,bean,{ async: false, callback:function(frecuenciaCreditoBean) {
			if(frecuenciaCreditoBean!=null && frecuenciaCreditoBean.length>0){
				dwr.util.addOptions('frecuenciaBase', frecuenciaCreditoBean, 'frecuenciaID', 'descInfinitivo');
				$("#btnAgregar").focus();
				consultaparamDiasFrecuencias();
				return true;
			} else {
				mensajeSis("El Producto no tiene las Frecuencias Parametrizadas.");
				$("#numTab").val(4);
				$('#gridDetalleDiv').html("");
				$('#gridDetalleDiv').show();
				deshabilitaBoton('btnAgregar','submit');
				deshabilitaBoton('grabar', 'submit');
				return false;
			}
		}
		});
	}
	return false;
}
/**
 * Método para consultar la parametrización de los productos de crédito para el desembolso
 */
function consultaparamDiasFrecuencias(){
	var productoID=$('#producCreditoID').asNumber();
	var paramDiasFrecuencia = {
			'tipoLista':		1,
			'producCreditoID' : productoID
			};
	
	$('#gridDetalleDiv').html("");
	if(productoID>0){
		$.post("parametrizacionDiasFrecuenciaGrid.htm", paramDiasFrecuencia, function(data) {
			if (data.length > 0) {
				$('#gridDetalleDiv').html(data);
				$('#gridDetalleDiv').show();
				agregaFormatoControles('gridDetalleDiv');
				if(estatusProd == 'I'){
					mensajeSis("El Producto "+ descripcion+" se encuentra Inactivo, por favor comunicarse con el Administrador para más información.");
					$('#producCreditoID').focus();
					deshabilitaBoton('btnAgregar','submit');
					deshabilitaBoton('grabar', 'submit');
				}else{
					habilitaBoton('btnAgregar','submit');
					habilitaBoton('grabar', 'submit');
				}
				agregarPlazosTodosSelect();
				$("#btnAgregar").focus();
			} else {
				$("#numTab").val(4);
				$('#gridDetalleDiv').html("");
				$('#gridDetalleDiv').show();
				deshabilitaBoton('btnAgregar','submit');
				deshabilitaBoton('grabar', 'submit');
				$("#btnAgregar").focus();
			}
		});
		habilitaBoton('btnAgregar','submit');
		agregarPlazosTodosSelect();
	}
}
/**
 * Agrega un detalle al grid
 */
function agregarDetalle(){
	habilitaBoton('grabar', 'submit');
	if(validarTabla()){
		var numTab=$("#numTab").asNumber();
		numTab = numTab==0?10:numTab;
		var numeroFila=$("#numeroFila").asNumber();
		numTab++;
		numeroFila++;
		var nuevaFila="<tr id=\"tr"+numeroFila+"\">"+
		"<td>"+
		"<select id=\"frecuencia"+numeroFila+"\" name=\"frecuencia\" type=\"select\" onchange=\"verificaSeleccionado(this.id)\" tabindex=\""+(numTab++)+"\" >"+
		"</select>"+
		"<input type=\"hidden\" id=\"auxfrecuencia"+numeroFila+"\" tabindex=\""+(numTab++)+"\" name=\"auxfrecuencia\" size=\"5\"  />"+
		"</td>"+
		"<td>"+
		"<input type=\"text\" id=\"dias"+numeroFila+"\" tabindex=\""+(numTab++)+"\" name=\"dias\" size=\"5\" onchange=\"validarDias(this.id,"+numeroFila+")\" maxlength=\"11\"/>"+
		"</td>"+
		"<td nowrap=\"nowrap\">"+
		"<input type=\"button\" name=\"eliminar\" value=\"\" class=\"btnElimina\" onclick=\"eliminarParam('tr"+numeroFila+"')\" tabindex=\""+(numTab++)+"\"/> "+
		"<input type=\"button\" name=\"agrega\" value=\"\" class=\"btnAgrega\" onclick=\"agregarDetalle()\" tabindex=\""+(numTab++)+"\"/>"+
		"</td>"+
		"</tr>";
		
		$("#tbParametrizacion").append(nuevaFila);
		clonarSelect("frecuencia"+numeroFila);
		agregaFormatoControles('formaGenerica');
		$("#numTab").val(numTab);
		$("#numeroFila").val(numeroFila);
	}
}
/**
 * Quita la parametrizacion del grid
 * @param id
 */
function eliminarParam(id){
	$('#'+id).remove();
}
/**
 * Duplica y setea el plazo de la consulta
 */
function agregarPlazosTodosSelect(){
	$("#tbParametrizacion select[name^='frecuencia']").each(function(){
		clonarSelect(this.id);
		var idFrec = "aux"+this.id;
		$("#"+this.id+" select").val();
		var frecuencia = $('#'+idFrec).val();
		$("#"+this.id).val(frecuencia).change();
	});
}
/**
 * Método que clona los valores de un select a otro
 * @param id
 */
function clonarSelect(id){
	dwr.util.removeAllOptions(id);
	$('#frecuenciaBase').find('option').clone().appendTo('#'+id);
}

function validarDias(id){
	validarDia(id);
}

/**
 * Valida el dia
 * @param id
 */
function validarDia(id){
	var dia=$('#'+id).asNumber();
	if(dia<0){
		mensajeSis('Los Días debe ser Mayor o igual a 0.');
		$('#'+id).focus();
		$('#'+id).val('');
		return;
	}
}
/**
 * Valida si se repite el valor en la tabla
 * @param valor
 * @returns {Boolean}
 */
function seRepite(id){
	var serepite = 0;
	var valor=$('#'+id).val();
	$("#tbParametrizacion select[name^='frecuencia']").each(function(){
		var valor2=$('#'+this.id).val();
		if (id!=this.id && (valor2!=undefined && valor2!='') && valor == valor2) {
			serepite++;
			return false;
		}
	});
	if(serepite>0)
		return true;
	return false;
}

/**
 * Válida que no este repetida la frecuencia
 * @param id
 */
function verificaSeleccionado(id){	
	if(seRepite(id)){
		$("#"+id).val("").change();
		$("#"+id).focus();
	}
}
/**
 * Válida que todos los campos de la tabla esten llenos correctamente.
 * @returns {Boolean}
 */
function validarTabla(){
	var validar = true;
	$("#tbParametrizacion tr").each(function(index){
		if(index>0){
			var idFrecuencia = "#"+$(this).find("select[name^='frecuencia']").attr("id");
			var iddias="#"+$(this).find("input[name^='dias']").attr("id");
			var frecuencia = $(idFrecuencia).val().trim();
			var dias = $(iddias).asNumber();
			if(frecuencia==='') {
				agregarFormaError(idFrecuencia);
				validar=false;
			}
			
			if(dias<0){
				agregarFormaError(iddias);
				validar=false;
			}
			
		}
	});
	return validar;
}
/**
 * Funcion que llena el detalle del grid de parametrizacion
 * @returns {Boolean}
 */
function llenarDetalle(){
	var validar = true;
	$('#detalle').val('');
	$("#tbParametrizacion tr").each(function(index){
		if(index>0){
			var idFrecuencia = "#"+$(this).find("select[name^='frecuencia']").attr("id");
			var iddias="#"+$(this).find("input[name^='dias']").attr("id");
			var frecuencia = $(idFrecuencia).val().trim();
			var dias = $(iddias).asNumber();
			
			if (index == 1) {
				$('#detalle').val( $('#detalle').val()+
				frecuencia+']'+		dias+']');
			} else{
				$('#detalle').val( $('#detalle').val()+'['+
				frecuencia+']'+		dias+']');
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


function ayuda(){	
	var data;
	
	data = '<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 
			'<legend class="ui-widget ui-widget-header ui-corner-all">Descripci&oacute;n:</legend>'+
			
			'<table id="tablaLista">'+
				'<tr>'+
					'<td id="contenidoAyuda" align="left">Esta parametrizaci&oacute;n aplica s&oacute;lo para productos de cr&eacute;dito con frecuencia Quincenal y Mensual.<b></b></td>'+
				'</tr>'+
			'</table>'+
			'</div>'+ 
			'</fieldset>'; 
	
	$('#ejemploArchivo').html(data); 

	$.blockUI({
		message : $('#ejemploArchivo'),
		css : {
			top:  ($(window).height() - 400) /2 + 'px', 
			left: ($(window).width() - 400) /2 + 'px', 
			width: '400px' ,
			 border: '0',
			 'background-color': 'transparent'
		}
	});  
   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		      
}