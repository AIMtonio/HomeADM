	$(document).ready(function() {
		esTab = false;
		
		var catTipoTransaccion = { 
				'grabar'	: '1'
		};
		
		/********** METODOS Y MANEJO DE EVENTOS ************/
		agregaFormatoControles('formaGenerica');
		$('#agregar').focus();
		consultaTiposAccion();
		
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
	       	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','agregar','exito','fallo');
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
	
		
	}); // Fin document ready
	
	//Funcion para consultar los tipos de accion
	function consultaTiposAccion(){			
		var params = {};
		params['tipoLista'] = 1;
		$.post("tipoAccionCobGridVista.htm", params, function(data){
			if(data.length >0) {
				$('#divGridTiposAccion').html(data);
				$('#divGridTiposAccion').show();
				habilitaBoton('grabar', 'submit');	
				seleccionaCombos();
			}else{				
				$('#divGridTiposAccion').html("");
				$('#divGridTiposAccion').show(); 
			}
		});
	}
	
	// Funcion que verifica que los campos no esten vacios
	function verificarVacios(){	
		var exito = 0;	
		var numCred = consultaFilas();	
		
		for(var i = 1; i <= numCred; i++){
			var jqDescripcion =eval("'#descripcion" + i + "'");
			var jqEstatus=eval("'#estatus" + i + "'");
			
			
			if($(jqDescripcion).val() == ''){
				$(jqDescripcion).focus();
				alert('Especificar Descripción del Tipo de Acción');
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
			var jqdescriAccion = eval("'#descriAccion" + numero+ "'");
			var jqdescripcion = eval("'descripcion" + numero+ "'");
			document.getElementById(jqdescripcion).innerHTML = $(jqdescriAccion).val(); 
			
		});		
	}
	
	// Funcion para agregar nuevas Filas en el grid
	function agregaNuevoParametro(){ 
		
		var numeroFila = ($('#miTabla >tbody >tr').length ) -1 ;
		var nuevaFila = parseInt(numeroFila) + 1;					
		var tds = '<tr id="renglons' + nuevaFila + '" name="renglons">';
		  
		
		tds += '<td><input type="hidden" id="consecutivo'+nuevaFila+'" name="consecutivo" size="4"  value="'+nuevaFila+'" />';
		tds += '	<input type="text" id="accionID'+nuevaFila+'" name="lisAccionID" size="4" value="'+nuevaFila+'" readOnly="true"  style="height:100%"/></td>';			
		tds += '<td><textarea id="descripcion'+nuevaFila+'" name="lisDescripcion" COLS="100" ROWS="2" onBlur=" ponerMayusculas(this)" ';
		tds += '		 maxlength = "200" tabindex="'+nuevaFila+'" autocomplete="off"/> </td>';
		tds += '<td><input type="hidden" id="estatusSelec'+nuevaFila+'" name="estatusSelec" size="3" />  ';																	
		tds += '		<select id="estatus'+nuevaFila+'" name="lisEstatus" type="select"  tabindex="'+nuevaFila+'"  style="width:100%">';
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
		var jqAccionID = eval("'#accionID" + numeroID + "'");		
		var jqDescripcion =eval("'#descripcion" + numeroID + "'");
		var jqEstatusSelec = eval("'#estatusSelec" + numeroID + "'");
		var jqEstatus=eval("'#estatus" + numeroID + "'");
		
		var jqAgregar=eval("'#agregar" + numeroID + "'");
		var jqEliminar = eval("'#" + numeroID + "'");
	
		// se elimina la fila seleccionada
		$(jqRenglon).remove();
		$(jqNumero).remove();
		$(jqAccionID).remove();
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
			var jqAccionID1 = eval("'#accionID" + numero + "'");		
			var jqDescripcion =eval("'#descripcion" + numero + "'");
			var jqEstatusSelec =eval("'#estatusSelec" + numero + "'");
			var jqEstatus =eval("'#estatus" + numero + "'");
			
			var jqAgregar1=eval("'#agregar" + numero + "'");
			var jqEliminar1 = eval("'#" + numero + "'");
			
	
			$(jqAccionID1).val(contador);
			
			$(jqRenglon1).attr('id','renglons'+contador);
			$(jqNumero1).attr('id','consecutivo'+contador);
			$(jqAccionID1).attr('id','accionID'+contador);
			$(jqDescripcion).attr('id','descripcion'+contador);
			$(jqEstatusSelec).attr('id','estatusSelec'+contador);
			$(jqEstatus).attr('id','estatus'+contador);
			
			$(jqAgregar1).attr('id','agregar'+contador);		
			$(jqEliminar1).attr('id',contador);
	
	
			// reordenamiento indices
			$(jqRenglon1).attr('tabindex','renglons'+contador);
			$(jqNumero1).attr('tabindex','consecutivo'+contador);
			$(jqAccionID1).attr('tabindex','accionID'+contador);
			$(jqDescripcion).attr('tabindex','descripcion'+contador);
			$(jqEstatusSelec).attr('tabindex','estatusSelec'+contador);
			$(jqEstatus).attr('tabindex','estatus'+contador);
			
			$(jqAgregar1).attr('tabindex','agregar'+contador);		
			$(jqEliminar1).attr('tabindex',contador);
			
			contador = parseInt(contador + 1);	
			
		});
		
	}
	
	//Funcion de exito al realizar una transaccion
	function exito(){
		var jQmensaje = eval("'#ligaCerrar'");
		if($(jQmensaje).length > 0) { 
		mensajeAlert=setInterval(function() { 
			if($(jQmensaje).is(':hidden')) { 	
				clearInterval(mensajeAlert); 
				
				consultaTiposAccion();					
			}
	        }, 50);
		}
		
	}
	//Funcion de error al realizar una trasaccion
	
	function fallo(){	
	}