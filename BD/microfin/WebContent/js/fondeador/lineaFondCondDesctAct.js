// js de funciones para grid de condiciones de descuento, Actividades BMX----------------
// js para  funciones de grid de condiciones de descuento, destino en lineas de fondeo ----------------
$(document).ready(function() {
	//Definicion de Constantes y Enums  
	var catTipoTransaccionDesctoAct = {   
  		'agrega':1,
  		'modifica':2
	};
	
	$.validator.setDefaults({
		submitHandler: function(event) {
			var vacio=validaVacios();
			if(vacio==1){
			
			}else{
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica4', 'contenedorForma', 'mensaje','true','lineaFondeoID','funcionExitoCondAct','funcionFalloCondAct');
			}
		}
    });
	
	// seccion de eventos para condiciones de actividades bmx
	$('#grabarAct').click(function() {		
		$('#tipoTransaccionAct').val(catTipoTransaccionDesctoAct.agrega);
	});
	
	// formulario de grid de actividades
	$('#formaGenerica4').validate({
		rules: {
			lineaFondeoIDAct: { required: true }
		},
		messages: {	
			lineaFondeoIDAct: { required: 'Especificar Linea de Fondeo '}
		}		
	});
	
	function validaVacios(){
		var conta = 0;
		var numDetalle = $('input[name=listaActividadBMXID]').length;
		var jqAct = eval("'#actividadBMXID" + numDetalle + "'");
		
		if($(jqAct).val()==''){
			$(jqAct).focus();
		    conta = 1;
		    return conta;
		}
	}
}); // fin del Ready

// función para mostrar el grid con las condiciones que corresponden a Actividades BMX
function consultaConDesctoActividadesLinFon(numLineaFondeo){
	var params = {};
	params['tipoLista'] = 1;
	params['lineaFondeoIDAct'] = numLineaFondeo;
	
	$.post("gridCondicionesDesctoActLinFon.htm", params, function(data){
		$('#gridActividades').show();
		$('#gridActividadesGrid').show();
		if(data.length >0) {
			$('#gridActividadesGrid').html(data);
			$('#gridActividadesGrid').show();
			$('#grabarAct').show();
			habilitaBoton('grabarAct', 'submit');
			
			// si no hay valores capturados se muestra la primera fila para su captura
			if($('#numeroDetalleAct').asNumber() == 0 ){ 
				agregaNuevaFilaAct();
				$('#gridActividadesGrid').show();
				habilitaBoton('grabarAct', 'submit');
			}else{
				consultaDescripcionesCondAct();
			}
			$('#lineaFondeoIDAct').val(numLineaFondeo);
		}else{
			$('#gridActividadesGrid').html("");
			$('#gridActividadesGrid').hide();
			$('#gridActividades').hide();
			$('#grabarAct').hide();
			deshabilitaBoton('grabarAct', 'submit');
			$('#numeroDetalleAct').val("");
		}
	});
}

// función para agregar una fila nueva de actividades BMX
function agregaNuevaFilaAct(){
	var numeroFila = $('#numeroDetalleAct').asNumber() +1;
	var nuevaFila = parseInt(numeroFila);
	var tds = '<tr id="renglonAct' + nuevaFila + '" name="renglonAct">';
 	
	tds += '<td nowrap="nowrap"><input type="text" id="actividadBMXID'+nuevaFila+'" name="listaActividadBMXID" size="15" value="" autocomplete="off"' 
				+' onkeypress="listaActividadesBMXGrid(this.id);" onblur="validaActividad(this.id);consultaActividadDescripcionGrid(this.id);" />';
	tds += '<input type="text" id="descripcionBMX'+nuevaFila+'" name="descripcionBMX" size="65" value="" disabled="disabled" readonly="readonly"/></td>';
	
	tds += '<td><input type="button" name="eliminaAct" id="eliminaAct'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaFilaAct(this.id)"/></td>';
	tds += '<td><input type="button" name="agregaAct"  id="agregaAct'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevaFilaAct()"/></td>';
	tds += '</tr>';

   $('#tablaActividades').append(tds);

   $('#numeroDetalleAct').val(nuevaFila);
   return false;	
}

//funcion para eliminar una fila  al grid de destinos de credito
function eliminaFilaAct(control){	
	var contador = 0 ;
	var numeroID=control.substr(10);
	
	var jqRenglon 		= eval("'#renglonAct" + numeroID + "'");
	var jqActividadID	= eval("'#actividadBMXID" + numeroID + "'");
	var jqActividadDes	= eval("'#descripcionBMX" + numeroID + "'");
	var jqEliminaDetalle= eval("'#eliminaAct" + numeroID + "'");
	var jqAgregaDetalle = eval("'#agregaAct" + numeroID + "'");
	
	// se elimina la fila seleccionada
	$(jqActividadID).remove();
	$(jqActividadDes).remove();
	$(jqEliminaDetalle).remove();
	$(jqAgregaDetalle).remove();
	$(jqRenglon).remove();
				
	// se asigna el numero de detalle que quedan
	var elementos = document.getElementsByName("renglonAct");
	$('#numeroDetalleAct').val(elementos.length);	

	//Reordenamiento de Controles
	contador = 1;
	var numero= 0;
	
	var jqRenglonCiclo		= "" ;
	var jqActividadID 		= "" ;
	var jqActividadDes 		= "" ;
	var jqEliminaDetalleCiclo = "";
	var jqAgregaDetalleCiclo = "" ;
	
	$('tr[name=renglonAct]').each(function() {
		numero= this.id.substr(10,this.id.length);
		jqRenglonCiclo 		= eval("'renglonAct" + numero+ "'");	
		jqActividadID 		= eval("'actividadBMXID" + numero + "'");
		jqActividadDes		= eval("'descripcionBMX" + numero + "'");
		jqEliminaDetalleCiclo= eval("'eliminaAct" + numero + "'");
		jqAgregaDetalleCiclo = eval("'agregaAct" + numero + "'");

		document.getElementById(jqRenglonCiclo).setAttribute('id', "renglonAct" + contador);
		document.getElementById(jqActividadID).setAttribute('id', "actividadBMXID" + contador);
		document.getElementById(jqActividadDes).setAttribute('id', "descripcionBMX" + contador);
		document.getElementById(jqEliminaDetalleCiclo).setAttribute('id', "eliminaAct" + contador);
		document.getElementById(jqAgregaDetalleCiclo).setAttribute('id', "agregaAct" + contador);

		contador = parseInt(contador + 1);	
	});	
}


//funcion para listar en el grid las actividades BMX
function listaActividadesBMXGrid(idControl){
	var jqControl = eval("'#" + idControl+ "'");
	var camposLista = new Array();
	var parametrosLista = new Array();
	camposLista[0] = "descripcion";
	parametrosLista[0] = $(jqControl).val();
	if($(jqControl).val() != ''){
		listaAlfanumerica(idControl, '1', '1', camposLista, parametrosLista,'listaActividades.htm');
	}
}
function validaActividad(idCtrl){
	var cont=0;
	var jqActividad = eval("'#" + idCtrl + "'");
	var jqActividadDes = eval("'#descripcionBMX" + idCtrl.substr(14) + "'");
	var jqActividadID = eval("'#actividadBMXID" + idCtrl.substr(14) + "'");
	var act = $(jqActividad).val();
	//var act = $('#'+idCtrl).val();
	$('input[name=listaActividadBMXID]').each(function() {
		if(this.value == act){
			cont++;
		}
	});
	if(cont>1){
		alert("Ya Existe la ActividadBMX");
		$(jqActividadID).focus();
		$(jqActividadID).val('');
		$(jqActividadDes).val('');
	} 
}

//funcion para consultar la descripcion de la actividad BMX  
function consultaActividadDescripcionGrid(idControl) {
	var jqActividad = eval("'#" + idControl + "'");
	var jqActividadDes = eval("'#descripcionBMX" + idControl.substr(14) + "'");
	var numActividad = $(jqActividad).val();
	setTimeout("$('#cajaLista').hide();", 200);
	esTab = true;
	if (numActividad != '' && !isNaN(numActividad) && esTab) {
		actividadesServicio.consultaActCompleta(3,	numActividad,function(actividadComp) {
			if (actividadComp != null) {
				$(jqActividadDes).val(actividadComp.descripcionBMX);
			} else {
				alert("No Existe la Actividad BMX");
				$(jqActividad).val("");
				$(jqActividad).focus();
			}
		});
	}	
}

function consultaDescripcionesCondAct(){
	$('tr[name=renglonAct]').each(function() {
		var numero= this.id.substring(10,this.id.length);	
		var jqActividadID = "actividadBMXID" + numero ;
		consultaActividadDescripcionGrid(jqActividadID);
	});
}

function funcionExitoCondAct(){
	esTab=true;
	//validaLineaFondeo('lineaFondeoID');
	consultaConDesctoActividadesLinFon($('#lineaFondeoIDAct').asNumber());
}

function funcionFalloCondAct(){
	
}