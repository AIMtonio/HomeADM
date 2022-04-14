var listaProductosCredito = {};
var parametros = consultaParametrosSession();
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

	
	$('#contenedorEsqTasa').hide();
	$('#formaTablaEsqTasa').html('');
	$('#condicionCredID').val('');

	listaProductosNomina();
	reasignarTabIndex();
	
});



function listaProductosNomina(){
	productosCreditoServicio.listaCombo(12,{ async: false, callback: function(resultado) {
	
		listaProductosCredito = resultado;
	    establecerValoresListaCred();
	}});
	
}


function establecerValoresListaCred(){
	var contador = 0;
	$('#tablaGridCred tr').each( function(index) {
		if(index > 0){
			
			cambiaTipoTasaCred('lisTipoTasaCred'+ index, index);
			var idControlProducto ='lisProducCreditoID' + index;
			agregarProductosNominaFila(idControlProducto);	
			establecerProductoID(index);
			if(contador ==0){
		     ejecutar= consultarCantidadEsquemas(index);
			}
			if( ejecutar== true){
				contador = 1;
			}else{contador = 0;}
		}
	});
}


function agregarProductosNominaFila(idControl){
	dwr.util.removeAllOptions(idControl);
	if (listaProductosCredito != null && listaProductosCredito.length > 0) {
		dwr.util.addOptions(idControl, {'':'SELECCIONAR'});
		dwr.util.addOptions(idControl,listaProductosCredito, 'producCreditoID', 'descripcion');
		return;
	}else{
		dwr.util.addOptions(idControl, {'': 'NO SE ENCONTRARON PRODUCTOS DE CRÉDITO'});
	}
}

function establecerProductoID(index){
	var productoID = document.getElementById("lisProducCreditoID" + index).getAttribute("value");
	var jqTipo = eval("'#lisProducCreditoID" + index + " option[value="+ productoID +"]'");
	$(jqTipo).attr("selected","selected");
}



function cambiaTipoTasaCred(id, fila){

	var beanCondicion = {
			'condicionCredID' : $('#lisCondicionCredID' +fila).val()
	}

	condicionProductoServicio.consulta(2,beanCondicion,function(esqTasa){
		
		if(esqTasa != null){
			
			$('#cantidadEsqTasa' + fila).val(esqTasa.cantidad);
			}
	});
	
	var tipoTasa = $('#'+id + ' option:selected').val();
	if( tipoTasa == 'F') {
		if($('#cantidadEsqTasa' + fila).asNumber() > 0){
			$('#lisTipoTasaCred' + fila + ' option[value="E"]').attr("selected", "selected");
			mensajeSis('Debe eliminar esquemas de tasas para poder modificar el tipo de tasa.');
			return;
		}
		
		habilitaControl('lisValorTasaCred'+ fila);
		$('#contenedorEsqTasa').hide();
		$('#formaTablaEsqTasa').html('');
		return;
	}
	if(tipoTasa == 'E'){
		$('#lisValorTasaCred'+ fila).attr('readonly',true);
		$('#lisValorTasaCred' + fila).val(0);
		return;
	}
}




function cambiarProductoCredito(idControl, fila){
    var beanCondicion = {
			'condicionCredID' : $('#lisCondicionCredID' +fila).val()
	}

	condicionProductoServicio.consulta(2,beanCondicion,function(esqTasa){
		
		if(esqTasa != null){
			
			$('#cantidadEsqTasa' + fila).val(esqTasa.cantidad);
			
			if(esqTasa.cantidad > 0 && $('#lisTipoTasaCred'+ fila).val() == 'E'){

				if($('#cantidadEsqTasa' + fila).asNumber() > 0){
					
					var productoID = document.getElementById("lisProducCreditoID" + fila).getAttribute("value");
					var jqTipo = eval("'#lisProducCreditoID" + fila + " option[value="+ productoID +"]'");
					$(jqTipo).attr("selected","selected");
					mensajeSis('Debe eliminar esquemas de tasas para poder modificar el producto de crédito.');
	              }
			
			}

		
		}
	});

}





function eliminarProductoCredito(idControl, fila){

    var beanCondicion = {
			'condicionCredID' : $('#lisCondicionCredID' +fila).val()
	}

	condicionProductoServicio.consulta(2,beanCondicion,function(esqTasa){
		
		if(esqTasa != null){
			
			$('#cantidadEsqTasa' + fila).val(esqTasa.cantidad);
			
			if(esqTasa.cantidad > 0){
			
			 mensajeSis('Debe eliminar esquemas de tasas para poder modificar el producto de crédito.');
			
			}else{
				eliminarDetalleCred('renglonCred'+fila); 
			}

		
		}
	});

}




function eliminarDetalleCred(id) {
	$('#' + id).remove();
	reasignarTabIndex();
}

function agregarDetalleCred(idControl){
	$('#grabaCred').show();
	$('#contenedorEsqTasa').hide();
	$('#formaTablaEsqTasa').html('');
	
	var numeroFila = $("#numeroFilaCred").asNumber();
	numeroFila++;
	var nuevaFila =
		"<tr id=\"renglonCred" + numeroFila + "\" name=\"renglonCred\">" +
			"<td>"+
				"<input type=\"checkbox\" id=\"lisVerEsqTasa"+ numeroFila + "\" name=\"lisVerEsqTasa\" onclick=\"verEsquemaTasa(this.id," +numeroFila + "); desselecTodos(this.id," +numeroFila + ");\"/>"+
				"<input type=\"hidden\" id=\"lisCondicionCredID" + numeroFila + "\" name=\"lisCondicionCredID\" value=\"0\" />" +
				"<input type=\"hidden\" id=\"cantidadEsqTasa" + numeroFila + "\" name=\"cantidadEsqTasa\" value=\"0\"/> " +
			"</td>"+                                                             
			"<td>" +
				"<select id=\"lisProducCreditoID" + numeroFila + "\" name=\"lisProducCreditoID\"  onchange=\"cambiarProductoCredito(this.id,"+ numeroFila+");\">" +
					"<option value=\"\">SELECCIONAR</option>"+
				"</select>"+
			"</td>" +
			"<td>" +
				"<select id=\"lisTipoTasaCred" + numeroFila + "\" name=\"lisTipoTasaCred\" onchange=\"cambiaTipoTasaCred(this.id,"+ numeroFila+");\">" +
					"<option value=\"F\" selected >FIJA</option>" +
					"<option value=\"E\" >POR ESQUEMA</option>" +
				"</select>"+
				"<input type=\"hidden\" id=\"tipoTasaCredAnt$" + numeroFila + "\" name=\"tipoTasaCredAnt\" value=\"\"/>" +            
			"</td>" +
			"<td>" +
				"<input id=\"lisValorTasaCred" + numeroFila + "\" size=\"11\" name=\"lisValorTasaCred\" maxlength=\"10\" type=\"text\" value=\"\" onblur=\"validaValorTasa(this.id);\" />" +
			"</td>" +
			"<td>"+ 
    	 	"<select id=\"lisTipoCobMora"+ numeroFila +"\" name=\"lisTipoCobMora\">"+
				"<option value=\"N\">N veces Tasa Ordinaria</option>"+
	     		"<option value=\"T\">Tasa Fija Anualizada</option>"+
			"</select>"+     			
			"</td>"+
			"<td>"+
				"<input id=\"lisValorMora"+ numeroFila +"\" size=\"12\" name=\"lisValorMora\" maxlength=\"15\" type=\"text\" value=\"\"/>"+
			"</td>"+
			"<td nowrap=\"nowrap\">" +
				"<input type=\"button\" id=\"agregarCred" + numeroFila + "\" name=\"agregarCred" + numeroFila + "\" value=\"\" class=\"btnAgrega\" onclick=\"agregarDetalleCred('tablaGridCred');\"  />" +
			"</td>" +
			"<td nowrap=\"nowrap\">" +	
				"<input type=\"button\" id=\"cancelarCred" + numeroFila + "\" name=\"cancelarCred" + numeroFila + "\" value=\"\" class=\"btnElimina\" onclick=\" eliminarProductoCredito(this.id,"+ numeroFila+"); \" />" +
			"</td>" +
		"</tr>";
	
	$('#' + idControl).append(nuevaFila);
	$("#numeroFilaCred").val(numeroFila);
	agregaFormatoControles('formaGenerica');
	agregarProductosNominaFila('lisProducCreditoID' + numeroFila);
	validaCobroMora();
	$('input[name="lisVerEsqTasa"]').attr('checked', false);
	//$('#lisVerEsqTasa'+ numeroFila).attr('checked', true);
	$('input[name="lisVerEsqTasa"]').change(function() {
	    $('input[name="lisVerEsqTasa"]').not(this).attr('checked', false);
	});
 
	removeBackgroundCondicionCred();
	agregarBackgroundCondicionCredSeleccionado(numeroFila);
	reasignarTabIndex();
	
}


function consultarCantidadEsquemas(index){
	var detener = false;
	var beanCondicion = {
			'condicionCredID' : $('#lisCondicionCredID' +index).val()
	}
	
	condicionProductoServicio.consulta(2, beanCondicion,{ async: false, callback: function(esqTasa){
	
		if(esqTasa != null){
		
			$('#cantidadEsqTasa' + index).val(esqTasa.cantidad);
			
			// si tiene esquemas de tasas se selecciona el primero 
		
			if(esqTasa.cantidad > 0 && $('#lisTipoTasaCred'+ index).val() == 'E'){
				
			   $('#lisVerEsqTasa'+ index).attr('checked', true);
				
				agregarBackgroundCondicionCredSeleccionado(1);
				var condicionID = $('#lisCondicionCredID'+index).val();
				$('#condicionCredID').val(condicionID);
				var productoID = document.getElementById("lisProducCreditoID"+index).getAttribute("value");
				$('#productoCreditoID').val(productoID);
				listaEsquemasTasas();
				
             detener = true;
				return true;
			}else{detener = false;
			return false;

		}
		}
	}});
	
	return detener;
}

function listaEsquemasTasas(){
	$('#grabaEsqTasa').show();
	var condicionCred = $('#condicionCredID').val();
	var params = {};
	params['condicionCredID']	= condicionCred;
	params['tipoLista'] 		= 2;
	$.post("nomEsquemaTasaCredGridVista.htm", params, function(data) {
		// si la condicion de credito seleccionado no ha cambiado
		if(condicionCred == $('#condicionCredID').val()){
		
			if(data.length > 0) {
				habilitaBoton('grabaEsqTasa');
				$('#formaTablaEsqTasa').html(data);
				$('#contenedorEsqTasa').show();
				$('#formaTablaEsqTasa').show();
				
			} else {
				mensajeSis("Error al generar la lista de esquema tasa de crédito");
				$('#contenedorEsqTasa').hide();
			}
		}
	}).fail(function() {
		mensajeSis("Error al generar el grid de esquema tasa de crédito");
		$('#contenedorEsqTasa').hide();
	});
}




 function validaValorTasa(idControl){
		var numero = idControl.substr(16,idControl.length);
		var valorCampo1 = $('#lisValorTasaCred'+numero).asNumber();
		var campo = eval("'#lisValorTasaCred"+numero+"'");

	 	$(campo).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 4});
			
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


function desselecTodos(id,fila){	

   
 $('input[name=lisVerEsqTasa]').each(function() {
 	jqAutoriza = eval("'#" + this.id + "'");
    m = jqAutoriza.substr(14,jqAutoriza.length);
   
 		if ($(jqAutoriza).is(":checked")){
 			if(m != fila)
 			{ 
 				$(jqAutoriza).attr('checked', false);
 			}else{$(jqAutoriza).attr('checked', true);}
 	
 		}else{

			$('#lisVerEsqTasa'+m).attr('checked', false);
 		}

 	 });
		
}


 

function verEsquemaTasa(id,fila){

	$('#contenedorEsqTasa').hide();
	$('#formaTablaEsqTasa').html('');
	$('#condicionCredID').val('');
	
	var beanCondicion = {
			'condicionCredID' : $('#lisCondicionCredID' +fila).val()
	}

	removeBackgroundCondicionCred();
	
	if($('#' + id).attr('checked')){
		
		agregarBackgroundCondicionCredSeleccionado(fila);
		var condicionCredID = $('#lisCondicionCredID' + fila).asNumber();
		var condicionID = $('#lisCondicionCredID' + fila).val();
		$('#condicionCredID').val(condicionID);
		var productoID = $('#lisProducCreditoID' + fila).val();
		$('#productoCreditoID').val(productoID);
		
		condicionProductoServicio.consulta(3,beanCondicion,function(esqTasa){
			
			if(esqTasa != null){
				
			        if(esqTasa.nCoincidencias > 0)
			        	{
			        	if($('#lisTipoTasaCred' + fila + ' option:selected').val() == 'E' && condicionCredID > 0 ){
			
						listaEsquemasTasas();
				
			        	}	
			        }
			 }
			});
		}
	}


function removeBackgroundCondicionCred(){
	$('#tablaGridCred tr').each(function(index) {
		if(index > 0){
			$(this).css("border", "");
		}
	});
}

function agregarBackgroundCondicionCredSeleccionado(fila){
	$('#renglonCred' + fila).css("border", "3px solid #5c9ccc");
}

function listaGridCred(page){

	$('#contenedorEsqTasa').hide();
	$('#formaTablaEsqTasa').html('');
	
	var numeroLista = 0;
	var estatus = '';
	var filtro = $('#filtroEstatusCred option:selected').val();
	switch(filtro){
		case '0':
			numeroLista = 1;
			break;
		case 'V': 
		case 'B': 
		case 'P':
		case 'C':
			numeroLista = 2;
			estatus = filtro;
			break;

		case 'VP':
			numeroLista = 3;
			break;
	
	}
	
	var params = {};
	params['institNominaID']	= $('#institNominaID').val();
	params['convenioNominaID'] 	= $('#convenioNominaID option:selected').val();
	params['tipoLista'] 		= 1;
	params['numeroLista']  		= numeroLista;
	params['estatus']			= estatus;
	if(page != ''){
		params['page'] 			= page ;
	}
	$.post("condicionesProdNomCredGridVista.htm", params, function(data) {
		if(data.length > 0) {
			$('#formaTablaCred').html(data);
			$('#contenedorProductosCred').show();
			$('#formaTablaCred').show();
			if($('#numeroRegistrosCred').val() <= 0) {
				mensajeSis('No se encontraron condiciones de crédito');
				$('#grabaCred').hide();
			}else{
				$('#grabaCred').show();
			}
		} else {
			mensajeSis("Error al generar la lista de condiciones de crédito");
			$('#contenedorProductosCred').hide();
			$('#contenedorEsqMonto').hide();
			$('#contenedorEsqTasa').hide();
		}
	}).fail(function() {
		mensajeSis("Error al generar el grid de condiciones de crédito");
		$('#contenedorProductosCred').hide();
		$('#contenedorEsqMonto').hide();
		$('#contenedorEsqTasa').hide();
	});
	
}

function cambioPaginaGridCred(pageValor){
	listaGridCred(pageValor);
}


