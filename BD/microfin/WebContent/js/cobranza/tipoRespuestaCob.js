$(document).ready(function() {
	esTab = false;
	
	var catTipoTransaccion = { 
			'grabar'	: '1'
	};
	
	/********** METODOS Y MANEJO DE EVENTOS ************/
	agregaFormatoControles('formaGenerica');
	inicializaParametros();
	
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
       	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','accionID','exito','fallo');
       }
	});	
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {				
		},
		messages: {				
		}		
	});
	
	$('#accionID').change(function(){
		var accion = $('#accionID').val();
		if(accion == ''){
			inicializaParametros();
		}else{
			consultaTiposRespuesta(accion);
		}		
	});
	
	$('#grabar').click(function() { 
		if(consultaFilas() == 0){
			alert('No Existe Ningún Registro');
			event.preventDefault();
		}
		else{
			var mandar = verificarVacios(); 
			if(mandar != 1){
				$('#tipoTransaccion').val(catTipoTransaccion.grabar);
			}else{
				event.preventDefault();
			}			 
		}
	}); 
	
	$('#agregar').click(function() {		
		agregaNuevoParametro();
	});

	// Funcion para consultar los tipos de respuestas
	function consultaTiposRespuesta(accion){			
		var params = {};
		params['tipoLista'] = 1;
		params['accionID'] = accion;
		
		$.post("tipoRespuestaCobGridVista.htm", params, function(data){
			if(data.length >0) {
				$('#divGridTiposRespuesta').html(data);
				habilitaBoton('agregar', 'submit');	
				habilitaBoton('grabar', 'submit');	
				seleccionaCombos();
			}else{				
				$('#divGridTiposRespuesta').html("");
				deshabilitaBoton('agregar', 'submit');	
				deshabilitaBoton('grabar', 'submit');	
			}
		});
	}
});// Fin del document ready

//Función que inicializa todos los campos de la pantalla
function inicializaParametros(){
	inicializaForma('formaGenerica','accionID');
	funcionCargaComboTipoAccion();
	$('#accionID').val('');
	$('#accionID').focus();

	//Se limpia seccion del grid
	$('#divGridTiposRespuesta').html("");

	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('agregar', 'submit');
}

//Funcion que verifica que los campos no esten vacios
function verificarVacios(){	
	var exito = 0;	
	var numCred = consultaFilas();	
	
	for(var i = 1; i <= numCred; i++){
		var jqDescripcion =eval("'#descripcion" + i + "'");
		var jqEstatus=eval("'#estatus" + i + "'");
		
		
		if($(jqDescripcion).val() == ''){
			$(jqDescripcion).focus();
			alert('Especificar Descripción del Tipo de Respuesta');
			exito = 1;
			break;
		}else{
			if($(jqEstatus).val() == ''){
				$(jqEstatus).focus();
				alert('Especificar Estatus');
				exito = 1;
				break;
			}
		}	
	}
	return exito;
		
}

// Funcion consulta el numero de filas
function consultaFilas(){
	var totales=0;
	$('tr[name=renglons]').each(function() {
		totales++;		
	});
	return totales;
}

// Funcion selecciona las opciones de los combos al consultarlos
function seleccionaCombos(){
	$('tr[name=renglons]').each(function() {
		var numero= this.id.substr(8,this.id.length);
		var jqEstatus = eval("'estatus" + numero+ "'");
		var seleccionado = eval("'estatusSelec" + numero+ "'");
		$("#"+jqEstatus).val($("#"+seleccionado).val());

		//Mostramos la descripcion del texarea 
		var jqdescriResp = eval("'#descriResp" + numero+ "'");
		var jqdescripcion = eval("'descripcion" + numero+ "'");
		document.getElementById(jqdescripcion).innerHTML = $(jqdescriResp).val(); 
	});		
}

// Funcion para agregar nuevas Filas en el grid
function agregaNuevoParametro(){ 
	
	var numeroFila = ($('#miTabla >tbody >tr').length ) -1 ;
	var nuevaFila = parseInt(numeroFila) + 1;					
	var tds = '<tr id="renglons' + nuevaFila + '" name="renglons">';
	  
	
	tds += '<td><input type="hidden" id="consecutivo'+nuevaFila+'" name="consecutivo" size="4"  value="'+nuevaFila+'" />';
	tds += '	<input type="text" id="respuestaID'+nuevaFila+'" name="lisRespuestaID" size="4" value="'+nuevaFila+'" readOnly="true"  style="height:100%"/></td>';		
	tds += '<td><textarea id="descripcion'+nuevaFila+'" name="lisDescripcion" COLS="100" ROWS="2" onBlur=" ponerMayusculas(this)" ';
	tds += '		 maxlength = "200" tabindex="'+nuevaFila+'" autocomplete="off"/> </td>';
	tds += '<td><input type="hidden" id="estatusSelec'+nuevaFila+'" name="estatusSelec" size="3" />  ';																	
	tds += '		<select id="estatus'+nuevaFila+'" name="lisEstatus" type="select"  tabindex="'+nuevaFila+'" style="width:100%"  >';
	tds += '			  <option value="A">ACTIVO</option>	';						
	tds += '		</select></td>';		

	tds += '<td><input type="button" name="eliminar" id="'+nuevaFila +'" class="btnElimina" onclick="eliminarParametro(this.id)"  tabindex="'+nuevaFila+'" /></td>';
	tds += '<td><input type="button" name="agregar" id="agregar'+nuevaFila +'" class="btnAgrega" onclick="agregaNuevoParametro()" tabindex="'+nuevaFila+'" /></td>';
	tds += '</tr>';	   	   
	
	$("#miTabla").append(tds);
	$('#descripcion'+nuevaFila).focus();
	
	return false;
																														
}

// Funcion para eliminar Filas en el grid	
function eliminarParametro(control){
	var numeroID = control;
	
	var jqRenglon = eval("'#renglons" + numeroID + "'");
	var jqNumero = eval("'#consecutivo" + numeroID + "'");
	var jqRespuestaID = eval("'#respuestaID" + numeroID + "'");		
	var jqDescripcion =eval("'#descripcion" + numeroID + "'");
	var jqEstatusSelec = eval("'#estatusSelec" + numeroID + "'");
	var jqEstatus=eval("'#estatus" + numeroID + "'");
	
	var jqAgregar=eval("'#agregar" + numeroID + "'");
	var jqEliminar = eval("'#" + numeroID + "'");

	// se elimina la fila seleccionada
	$(jqRenglon).remove();
	$(jqNumero).remove();
	$(jqRespuestaID).remove();
	$(jqDescripcion).remove();
	$(jqEstatusSelec).remove();
	$(jqEstatus).remove();

	$(jqAgregar).remove();
	$(jqEliminar).remove();

	// reordenamiento de Controles

	var contador = 1 ;
	var numero= 0;
	$('tr[name=renglons]').each(function() {	
		numero= this.id.substr(8,this.id.length);
		var jqRenglon1 = eval("'#renglons" + numero + "'");
		var jqNumero1 = eval("'#consecutivo" + numero + "'");
		var jqRespuestaID1 = eval("'#respuestaID" + numero + "'");		
		var jqDescripcion =eval("'#descripcion" + numero + "'");
		var jqEstatusSelec =eval("'#estatusSelec" + numero + "'");
		var jqEstatus =eval("'#estatus" + numero + "'");
		
		var jqAgregar1=eval("'#agregar" + numero + "'");
		var jqEliminar1 = eval("'#" + numero + "'");
		

		$(jqRespuestaID1).val(contador);
		
		$(jqRenglon1).attr('id','renglons'+contador);
		$(jqNumero1).attr('id','consecutivo'+contador);
		$(jqRespuestaID1).attr('id','respuestaID'+contador);
		$(jqDescripcion).attr('id','descripcion'+contador);
		$(jqEstatusSelec).attr('id','estatusSelec'+contador);
		$(jqEstatus).attr('id','estatus'+contador);
		
		$(jqAgregar1).attr('id','agregar'+contador);		
		$(jqEliminar1).attr('id',contador);


		// reordenamiento indices
		$(jqRenglon1).attr('tabindex','renglons'+contador);
		$(jqNumero1).attr('tabindex','consecutivo'+contador);
		$(jqRespuestaID1).attr('tabindex','respuestaID'+contador);
		$(jqDescripcion).attr('tabindex','descripcion'+contador);
		$(jqEstatusSelec).attr('tabindex','estatusSelec'+contador);
		$(jqEstatus).attr('tabindex','estatus'+contador);
		
		$(jqAgregar1).attr('tabindex','agregar'+contador);		
		$(jqEliminar1).attr('tabindex',contador);
		
		contador = parseInt(contador + 1);	
		
	});
	
}

//Función carga todas las opciones en el combo tipo de accion
function funcionCargaComboTipoAccion(){
	dwr.util.removeAllOptions('accionID'); 
	tipoAccionCobServicio.listaCombo(2, function(tipoAacciones){
		dwr.util.addOptions('accionID', {'':'SELECCIONAR'});	
		dwr.util.addOptions('accionID', tipoAacciones, 'accionID', 'descripcion');
	});
}

// Funcion de exito al realizar una transaccion
function exito(){
	var jQmensaje = eval("'#ligaCerrar'");
	if($(jQmensaje).length > 0) { 
	mensajeAlert=setInterval(function() { 
		if($(jQmensaje).is(':hidden')) { 	
			clearInterval(mensajeAlert); 

			inicializaParametros();				
		}
        }, 50);
	}
	
}

// Funcion de error al realizar una trasaccion
function fallo(){	
}