// js para  funciones de grid de condiciones de descuento, destino en lineas de fondeo ----------------
$(document).ready(function() {
	//Definicion de Constantes y Enums  
	var catTipoTransaccionDesctoDest = {   
  		'agrega':1,
  		'modifica':2
	};
	$(':text').focus(function() {	
	 	esTab = false;
	});
	$.validator.setDefaults({
		submitHandler: function(event) {	
			var vacio=validaVacios();
			if(vacio==1){
			}else{
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica3', 'contenedorForma', 'mensaje','true','lineaFondeoID','funcionExitoCondCre','funcionFalloCondCre');
			}
		}
    });
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	// seccion de eventos para condiciones de destinos de credito
	$('#grabarDest').click(function() {		
		$('#tipoTransaccionDestino').val(catTipoTransaccionDesctoDest.agrega);
	});
	
	// formulario de grid de destinos de credito
	$('#formaGenerica3').validate({
		rules: {
			lineaFondeoIDDest: { required: true }
		},
		messages: {	
			lineaFondeoIDDest: { required: 'Especificar Linea de Fondeo ' }
		}		
	});
	function validaVacios(){
		var conta = 0;
		var numDetalle = $('input[name=listaDestinoCreID]').length;
		var jqCred = eval("'#destinoCreID" + numDetalle + "'");
		
		if($(jqCred).val()==''){
			$(jqCred).focus();
		    conta = 1;
		    return conta;
		}
	}
	
}); // fin del Ready

// función para mostrar el grid con las condiciones que corresponden a estados y municipios
function consultaConDesctoDestinosLinFon(numLineaFondeo){
	var params = {};
	params['tipoLista'] = 1;
	params['lineaFondeoIDDest'] = numLineaFondeo;
	esTab = true;
	$.post("gridCondicionesDesctoDestLinFon.htm", params, function(data){
		$('#gridDestino').show();
		$('#gridDestinoGrid').show();
		if(data.length >0) {
			$('#gridDestinoGrid').html(data);
			$('#gridDestinoGrid').show();
			$('#grabarDest').show();
			habilitaBoton('grabarDest', 'submit');
			// si no hay valores capturados se muestra la primera fila para su captura
			if($('#numeroDetalleDestino').asNumber() == 0 ){
				agregaNuevaFilaDestino();
				$('#gridDestinoGrid').show();
				habilitaBoton('grabarDest', 'submit');
			}else{
				consultaDescripcionesConDesGrid();
			}
			$('#lineaFondeoIDDest').val(numLineaFondeo);
		}else{
			$('#gridDestinoGrid').html("");
			$('#gridDestinoGrid').hide();
			$('#gridDestino').hide();
			$('#grabarDest').hide();
			deshabilitaBoton('grabarDest', 'submit');
			$('#numeroDetalleDestino').val("");
		}	
	});
}

// funcion para agregar una fila nueva de destinos de credito
function agregaNuevaFilaDestino(){
	var numeroFila = $("#numeroDetalleDestino").asNumber() +1;
	var nuevaFila = parseInt(numeroFila);			
	var tds = '<tr id="renglonDest' + nuevaFila + '" name="renglonDest">';		 	
	
	tds += '<td nowrap="nowrap"><input  type="text" id="destinoCreID'+nuevaFila+'" name="listaDestinoCreID" size="15" value="" autocomplete="off" '
				+' onkeypress="listaDestinosCreditoGrid(this.id);" onblur="validaDescripcion(this.id);consultaDestinoDescripcionGrid(this.id);" />';
	tds += '<input type="text" id="descripcionDestino'+nuevaFila+'" name="descripcionDestino" size="65" value=""  disabled="disabled" readonly="readonly"/></td>';
	
	tds += '<td><input type="button" name="eliminaDest" id="eliminaDest'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaFilaDestino(this.id)"/></td>';
	tds += '<td><input type="button" name="agregaDest"  id="agregaDest'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevaFilaDestino()"/></td>';
	tds += '</tr>';
	
	document.getElementById("numeroDetalleDestino").value = nuevaFila;    	
	$("#tablaDestinos").append(tds);		
	return false;		
}

//funcion para eliminar una fila  al grid de destinos de credito
function eliminaFilaDestino(control){	
	var contador = 0 ;
	var numeroID=control.substr(11);
	
	var jqRenglon 		= eval("'#renglonDest" + numeroID + "'");
	var jqDestinoCreID	= eval("'#destinoCreID" + numeroID + "'");
	var jqDescripcionDes= eval("'#descripcionDestino" + numeroID + "'");
	var jqEliminaDetalle= eval("'#eliminaDest" + numeroID + "'");
	var jqAgregaDetalle = eval("'#agregaDest" + numeroID + "'");
	
	// se elimina la fila seleccionada
	$(jqDestinoCreID).remove();
	$(jqDescripcionDes).remove();
	$(jqEliminaDetalle).remove();
	$(jqAgregaDetalle).remove();
	$(jqRenglon).remove();
				
	// se asigna el numero de detalle que quedan
	var elementos = document.getElementsByName("renglonDest");
	$('#numeroDetalleDestino').val(elementos.length);	

	//Reordenamiento de Controles
	contador = 1;
	var numero= 0;
	
	var jqRenglonCiclo = "" ;
	var jqDestinoCreIDCiclo = "" ;
	var jqDescripcionDesCiclo = "" ;
	var jqEliminaDetalleCiclo = "";
	var jqAgregaDetalleCiclo = "" ;
	
	$('tr[name=renglonDest]').each(function() {
		numero= this.id.substr(11,this.id.length);
		jqRenglonCiclo = eval("'renglonDest" + numero+ "'");	
		jqDestinoCreIDCiclo = eval("'destinoCreID" + numero + "'");
		jqDescripcionDesCiclo = eval("'descripcionDestino" + numero + "'");
		jqEliminaDetalleCiclo = eval("'eliminaDest" + numero + "'");
		jqAgregaDetalleCiclo = eval("'agregaDest" + numero + "'");

		document.getElementById(jqRenglonCiclo).setAttribute('id', "renglonDest" + contador);
		document.getElementById(jqDestinoCreIDCiclo).setAttribute('id', "destinoCreID" + contador);
		document.getElementById(jqDescripcionDesCiclo).setAttribute('id', "descripcionDestino" + contador);
		document.getElementById(jqEliminaDetalleCiclo).setAttribute('id', "eliminaDest" + contador);
		document.getElementById(jqAgregaDetalleCiclo).setAttribute('id', "agregaDest" + contador);

		contador = parseInt(contador + 1);	
	});	
}


//funcion para listar en el grid los destinos de credito
function listaDestinosCreditoGrid(idControl){
	var jqControl = eval("'#" + idControl+ "'");
	var camposLista = new Array();
	var parametrosLista = new Array();
	camposLista[0] = "destinoCreID";
	parametrosLista[0] = $(jqControl).val();
	if($(jqControl).val() != ''){
		listaAlfanumerica(idControl, '1', '1', camposLista, parametrosLista,'listaDestinosCredito.htm');
	}
}	


//funcion para consultar la descripcion del destino de credito  
function consultaDestinoDescripcionGrid(idControl) {
	var jqDestino = eval("'#" + idControl + "'");
	var jqDestinoDes = eval("'#descripcionDestino" + idControl.substr(12) + "'");
	var numDestinoCre = $(jqDestino).val();
	var destCredBeanCon = {
			'destinoCreID':numDestinoCre 
	};
	setTimeout("$('#cajaLista').hide();", 200);
	esTab = true;
	if (numDestinoCre != '' && !isNaN(numDestinoCre) && esTab) {
		destinosCredServicio.consulta(2,destCredBeanCon,function(destinos) {
			if (destinos != null) {
				$(jqDestinoDes).val(destinos.descripcion);
			} else {
				alert("No Existe el Destino de Credito");
				$(jqDestino).val("");
				$(jqDestino).focus();
			}
		});
	}	
}
function validaDescripcion(idCtrl){
	var cont=0;
	var jqDestino = eval("'#" + idCtrl + "'");
	var numDetalle = $('input[name=listaDestinoCreID]').length;
	var jqDescripcion = eval("'#descripcionDestino" + numDetalle + "'");
	var jqDestinoID = eval("'#destinoCreID" + numDetalle + "'");
	var act = $(jqDestino).val();
	$('input[name=listaDestinoCreID]').each(function() {
		if(this.value == act){
			cont++;
		}
	});
	if(cont>1){
		alert("Ya Existe el Destino del Credito");
		$(jqDestinoID).focus();
		$(jqDestinoID).val('');
		$(jqDescripcion).val('');
	} 
}
function consultaDescripcionesConDesGrid(){
	$('tr[name=renglonDest]').each(function() {
		var numero= this.id.substring(11,this.id.length);	
		var jqDestinoCreIDCiclo = "destinoCreID" + numero ;
		consultaDestinoDescripcionGrid(jqDestinoCreIDCiclo);
	});
}

function funcionExitoCondCre(){
	esTab=true;
	//validaLineaFondeo('lineaFondeoID');
	consultaConDesctoDestinosLinFon($('#lineaFondeoIDDest').asNumber());
}

function funcionFalloCondCre(){
	
}