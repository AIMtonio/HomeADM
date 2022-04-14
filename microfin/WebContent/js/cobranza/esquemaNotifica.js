$(document).ready(function() {
	esTab = false;
	
	var catTipoTransaccion = { 
			'grabar'	: '1'
	};
	
	/********** METODOS Y MANEJO DE EVENTOS ************/
	agregaFormatoControles('formaGenerica');
	consultaEsquemaNotifi();
	$('#agregar').focus();

	
	 $(':text').focus(function() {	
		 	esTab = false;
		});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});	
	
	$.validator.setDefaults({
		submitHandler: function(event) {
				var mandar = verificarVacios(); 
				if(mandar == 0){
			       	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','esquemaID1','exito','fallo');
				}		 
			             	
       }
	});	
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {				
		},
		messages: {				
		}		
	});
	
	$('#grabar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.grabar);
	}); 
	
	$('#agregar').click(function() {		
		agregaNuevoParametro();
	});
	

	// Función para Consultar el esquema de notificaciones
	function consultaEsquemaNotifi(){			
		var params = {};
		params['tipoLista'] = 1;
		$.post("esquemaNotificaGridVista.htm", params, function(data){
			if(data.length >0) {
				$('#divGridEsquemaNotifica').html(data);
				$('#divGridEsquemaNotifica').show();
				habilitaBoton('grabar', 'submit');	
				seleccionaCombos();
			}else{				
				$('#divGridEsquemaNotifica').html("");
				$('#divGridEsquemaNotifica').show(); 
			}
		});
	}
	
});

//funcion valida que no se traslapen los rangos de dias
function validarRangoDias(control){	
	var jqNumDias = eval("'#" +control+"'");
	diasID = control.substr(13,control.length);
	var numDias = $(jqNumDias).asNumber();
	
	$('tr[name=renglons]').each(function() {	
		numero= this.id.substr(8,this.id.length);		
		var jqDiasAtrasoIni = eval("'#diasAtrasoIni" + numero + "'");
		var jqDiasAtrasoFin =eval("'#diasAtrasoFin" + numero + "'");

		if(numDias >= $(jqDiasAtrasoIni).asNumber() && numDias <= $(jqDiasAtrasoFin).asNumber() && diasID != numero){
			if($(jqNumDias).val() != ''){
				alert('El Número de Días ya esta Parametrizado');
				$(jqNumDias).val('');
				$(jqNumDias).focus();
				$(jqNumDias).select();
			}
			return false;
		}		
	});
}

//Función que verifica que los campos no esten vacios
function verificarVacios(){	
	var exito = 0;	
	var numCred = consultaFilas();	
	
	for(var i = 1; i <= numCred; i++){
		var jqDiasAtrasoIni = eval("'#diasAtrasoIni" + i + "'");
		var jqDiasAtrasoFin =eval("'#diasAtrasoFin" + i + "'");
		var jqEtiquetaEtapa=eval("'#etiquetaEtapa" + i + "'");
		var jqFormatoNoti=eval("'#formatoNoti" + i + "'");
		
		
		if($(jqDiasAtrasoIni).val() == ''){
			$(jqDiasAtrasoIni).val('');
			$(jqDiasAtrasoIni).focus();
			alert('Especificar Días de Atraso Inicial');
			exito = 1;
			break;
		}else{
			if($(jqDiasAtrasoFin).val() == ''){
				$(jqDiasAtrasoFin).val('');
				$(jqDiasAtrasoFin).focus();
				alert('Especificar Días de Atraso Final');
				exito = 1;
				break;
			}else{
				if($(jqEtiquetaEtapa).val() == ''){
					$(jqEtiquetaEtapa).val('');
					$(jqEtiquetaEtapa).focus();
					alert('Especificar la Descripción de la Etiqueta');
					exito = 1;
					break;
				}else{
					if($(jqFormatoNoti).val() == ''){
						$(jqFormatoNoti).focus();
						alert('Seleccionar un Formato de Notificación');
						exito = 1;
						break;
					}
				}
			}
		}	
	}
	return exito;
		
}

//funcin consulta el numero de filas
function consultaFilas(){
	var totales=0;
	$('tr[name=renglons]').each(function() {
		totales++;		
	});
	return totales;
}

//funcion selecciona las opciones de los combos al consutarlos
function seleccionaCombos(){
	$('tr[name=renglons]').each(function() {
		var numero= this.id.substr(8,this.id.length);
		var jqIdFormato = eval("'#formatoID" + numero+ "'");
		var jqIdCombo = eval("'formatoNoti" + numero+ "'");
		
		comboFormatosNotifica(jqIdCombo,$(jqIdFormato).val());
	});		
}

// agrega las opciones que tendran los combos de los formatos de notificacion
function comboFormatosNotifica(idFormatoNoti,seleccionado){
	var tipoLista=1;

	dwr.util.removeAllOptions(idFormatoNoti); 
	dwr.util.addOptions(idFormatoNoti, {'':'SELECCIONAR'});
	esquemaNotificaServicio.listaCombo(tipoLista, function(formatos){
		dwr.util.addOptions(idFormatoNoti, formatos, 'formatoID', 'descripcion');
		var jqFormat = eval("'#"+idFormatoNoti+" option[value="+seleccionado+"]'");
		$(jqFormat).attr("selected","selected");
	});	

}	

// Función para agregar nuevas Filas en el grid de Porcentajes
function agregaNuevoParametro(){ 
	
	var numeroFila = ($('#miTabla >tbody >tr').length ) -1 ;
	var nuevaFila = parseInt(numeroFila) + 1;					
	var tds = '<tr id="renglons' + nuevaFila + '" name="renglons">';
	  
	
	tds += '<td><input type="hidden" id="consecutivo'+nuevaFila+'" name="consecutivo" size="4"  value="'+nuevaFila+'" />';
	tds += '	<input type="text" id="esquemaID'+nuevaFila+'" name="lisEsquemaID" size="4" value="'+nuevaFila+'" readOnly="true" /></td>';			
	tds += '<td><input type="text" id="diasAtrasoIni'+nuevaFila+'" name="lisDiasAtrasoIni" size="9" tabindex="'+nuevaFila+'" maxlength = "9" autocomplete="off" onblur="validarRangoDias(this.id)" onkeypress="validaSoloNumero(event,this)" /></td>';	
	tds += '<td><input type="text" id="diasAtrasoFin'+nuevaFila+'" name="lisDiasAtrasoFin" size="9" tabindex="'+nuevaFila+'" maxlength = "9" autocomplete="off" onblur="validarRangoDias(this.id)" onkeypress="validaSoloNumero(event,this)" /></td>';	
	tds += '<td><input type="text" id="numEtapa'+nuevaFila+'" name="lisNumEtapa" size="6" tabindex="'+nuevaFila+'" onblur="ponerMayusculas(this)" maxlength = "9" autocomplete="off" onkeypress="validaSoloNumero(event,this)" /></td>';		
	tds += '<td><input type="text" id="etiquetaEtapa'+nuevaFila+'" name="lisEtiquetaEtapa" size="15" tabindex="'+nuevaFila+'" onblur="ponerMayusculas(this)" maxlength = "10" autocomplete="off" /></td>';
	tds += '<td><input type="text" id="accion'+nuevaFila+'" name="lisAccion" size="50" tabindex="'+nuevaFila+'" onblur="ponerMayusculas(this)" maxlength = "200" autocomplete="off" /> </td>';
	tds += '<td><input type="hidden" id="formatoID'+nuevaFila+'" name="formatoID" size="10" />  ';																	
	tds += '		<select id="formatoNoti'+nuevaFila+'" name="lisFormatoNoti" type="select"  tabindex="'+nuevaFila+'"  >';
	tds += '			<option value="">SELECCIONAR</option>	';						
	tds += '		</select></td>';		

	tds += '<td><input type="button" name="eliminar" id="'+nuevaFila +'" class="btnElimina" onclick="eliminarParametro(this.id)"  tabindex="'+nuevaFila+'" /></td>';
	tds += '<td><input type="button" name="agregar" id="agregar'+nuevaFila +'" class="btnAgrega" onclick="agregaNuevoParametro()" tabindex="'+nuevaFila+'" /></td>';
	tds += '</tr>';	   	   
	
	$("#miTabla").append(tds);
	
	var idFormatoNoti = 'formatoNoti'+nuevaFila; 
	var seleccionado ="";
	comboFormatosNotifica(idFormatoNoti,seleccionado);
	$('#diasAtrasoIni'+nuevaFila).focus();
	
	return false;
																														
}

// Función para eliminar Filas en el grid de Porcentajes	
function eliminarParametro(control){
	var numeroID = control;
	
	var jqRenglon = eval("'#renglons" + numeroID + "'");
	var jqNumero = eval("'#consecutivo" + numeroID + "'");
	var jqEsquemaID = eval("'#esquemaID" + numeroID + "'");		
	var jqDiasAtrasoIni = eval("'#diasAtrasoIni" + numeroID + "'");
	var jqDiasAtrasoFin=eval("'#diasAtrasoFin" + numeroID + "'");
	var jqNumEtapa=eval("'#numEtapa" + numeroID + "'");
	var jqEtiquetaEtapa=eval("'#etiquetaEtapa" + numeroID + "'");
	var jqAccion =eval("'#accion" + numeroID + "'");
	var jqFormatoID=eval("'#formatoID" + numeroID + "'");
	var jqFormatoNoti=eval("'#formatoNoti" + numeroID + "'");
	
	var jqAgregar=eval("'#agregar" + numeroID + "'");
	var jqEliminar = eval("'#" + numeroID + "'");

	// se elimina la fila seleccionada
	$(jqRenglon).remove();
	$(jqNumero).remove();
	$(jqEsquemaID).remove();
	$(jqDiasAtrasoIni).remove();
	$(jqDiasAtrasoFin).remove();
	$(jqNumEtapa).remove();
	$(jqEtiquetaEtapa).remove();
	$(jqAccion).remove();
	$(jqFormatoID).remove();
	$(jqFormatoNoti).remove();

	$(jqAgregar).remove();
	$(jqEliminar).remove();

	//Reordenamiento de Controles

	var contador = 1 ;
	var numero= 0;
	$('tr[name=renglons]').each(function() {	
		numero= this.id.substr(8,this.id.length);
		var jqRenglon1 = eval("'#renglons" + numero + "'");
		var jqNumero1 = eval("'#consecutivo" + numero + "'");
		var jqEsquemaID1 = eval("'#esquemaID" + numero + "'");		
		var jqDiasAtrasoIni1 = eval("'#diasAtrasoIni" + numero + "'");
		var jqDiasAtrasoFin1 =eval("'#diasAtrasoFin" + numero + "'");
		var jqNumEtapa1 =eval("'#numEtapa" + numero + "'");
		var jqEtiquetaEtapa1 =eval("'#etiquetaEtapa" + numero + "'");
		var jqAccion1 =eval("'#accion" + numero + "'");
		var jqFormatoID1 =eval("'#formatoID" + numero + "'");
		var jqFormatoNoti1 =eval("'#formatoNoti" + numero + "'");
		
		var jqAgregar1=eval("'#agregar" + numero + "'");
		var jqEliminar1 = eval("'#" + numero + "'");
		

		$(jqEsquemaID1).val(contador);

		$(jqRenglon1).attr('id','renglons'+contador);
		$(jqNumero1).attr('id','consecutivo'+contador);
		$(jqEsquemaID1).attr('id','esquemaID'+contador);
		$(jqDiasAtrasoIni1).attr('id','diasAtrasoIni'+contador);
		$(jqDiasAtrasoFin1).attr('id','diasAtrasoFin'+contador);
		$(jqNumEtapa1).attr('id','numEtapa'+contador);
		$(jqEtiquetaEtapa1).attr('id','etiquetaEtapa'+contador);
		$(jqAccion1).attr('id','accion'+contador);
		$(jqFormatoID1).attr('id','formatoID'+contador);
		$(jqFormatoNoti1).attr('id','formatoNoti'+contador);
		
		$(jqAgregar1).attr('id','agregar'+contador);		
		$(jqEliminar1).attr('id',contador);


		// reordenamiento indeces

		$(jqEsquemaID1).attr('tabindex',contador);
		$(jqDiasAtrasoIni1).attr('tabindex',contador);
		$(jqDiasAtrasoFin1).attr('tabindex',contador);
		$(jqNumEtapa1).attr('tabindex',contador);
		$(jqEtiquetaEtapa1).attr('tabindex',contador);
		$(jqAccion1).attr('tabindex',contador);
		$(jqFormatoNoti1).attr('tabindex',contador);
		
		$(jqAgregar1).attr('tabindex',contador);		
		$(jqEliminar1).attr('tabindex',contador);
		
		contador = parseInt(contador + 1);	
		
	});
	
}
//Función solo Enteros sin Puntos ni Caracteres Especiales 
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

function exito(){
	//inicializaForma('formaGenerica','');
}

function fallo(){
	
}