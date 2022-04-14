	var parametroBean = consultaParametrosSession(); 
	
	var var_Parametros = {
		'Zona_Geografica' 	: 6,
		'Consumo' 			: 7,
		'Producto_Crédito' 	: 15,
		'SectorEconomico' 	: 16,
		'Sucursal' 			: 17,
		'Tipos_Ahorro' 		: 18	
	};
	
	$(document).ready(function() {
	esTab = true;
     
	$("#paramRiesgosID").focus();
	
	 deshabilitaBoton('grabar', 'submit');
	 var catTipoTransaccion = { 
		  	'grabar'	: 1
	 };

	 /********** METODOS Y MANEJO DE EVENTOS ************/
	 agregaFormatoControles('formaGenerica');
	$.validator.setDefaults({
        submitHandler: function(event) {             	
        	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','paramRiesgosID','exito','fallo');
        }
	});	
	
	 $(':text').focus(function() {	
		 	esTab = false;
		});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});	
	
	$('#paramRiesgosID').change(function() {	
		var parametrosID= $('#paramRiesgosID').val();
		if(parametrosID != var_Parametros.Consumo && parametrosID != var_Parametros.Tipos_Ahorro
				 && parametrosID != var_Parametros.SectorEconomico){
			consultaParamsRiesgos();
		}
		else if(parametrosID == var_Parametros.Consumo){
			consultaParamsConsumo();
		}
		else if(parametrosID == var_Parametros.Tipos_Ahorro){
			consultaParamsTipoAhorro();
		}
		else if(parametrosID == var_Parametros.SectorEconomico){
			consultaParamsSectorEconomico();
		}
		else {
			habilitaBoton('grabar', 'submit');
		}
	});
	
	$('#paramRiesgosID').blur(function() {
		var parametrosID= $('#paramRiesgosID').val();
		if(parametrosID != var_Parametros.Consumo && parametrosID != var_Parametros.Tipos_Ahorro
			 && parametrosID != var_Parametros.SectorEconomico){
			consultaParamsRiesgos();
		}
		else if(parametrosID == var_Parametros.Consumo){
			consultaParamsConsumo();
		}
		else if(parametrosID == var_Parametros.Tipos_Ahorro){
			consultaParamsTipoAhorro();
		}
		else if(parametrosID == var_Parametros.SectorEconomico){
			consultaParamsSectorEconomico();
		}
		else {
			habilitaBoton('grabar', 'submit');
		}
	});

	$('#grabar').click(function() { 
		if(consultaFilas() == 0){
			 deshabilitaBoton('grabar', 'submit');
		}
		else{
		$('#tipoTransaccion').val(catTipoTransaccion.grabar); 
		guardarParametros();
		}
	}); 
	
	$('#formaGenerica').validate({
		rules : {
		}
	 }
	);
	
	//------------ Validaciones de Controles --------------
	
	// Funcion para consultar los Parámetros de Riesgos.
	consultaParametrosRiesgos();
	function consultaParametrosRiesgos() {			
		dwr.util.removeAllOptions('paramRiesgosID'); 		
		dwr.util.addOptions('paramRiesgosID', {0:'SELECCIONAR'});						     
		parametrosRiesgosServicio.listaCombo(1, function(riesgos){
		dwr.util.addOptions('paramRiesgosID', riesgos, 'paramRiesgosID', 'descripcion');
		});
		}
	});  // Fin document

	// Función para Consultar Información de los Parámetros de Riesgos
	function consultaParamsRiesgos(){			
		var parametrosID= $('#paramRiesgosID').val();
		$('#riesgosID').val(parametrosID);
		var params = {};
		params['tipoLista'] = 2;
		params['paramRiesgosID'] = parametrosID;
		if(parametrosID >0){
		$.post("parametrosRiesgoGridVista.htm", params, function(data){
			if(data.length >0) {
				$('#divPorcentajes').html(data);
				$('#divPorcentajes').show();
				habilitaBoton('grabar', 'submit');
				if($('#riesgosID').val()!= var_Parametros.Zona_Geografica
						&& $('#riesgosID').val()!= var_Parametros.Producto_Crédito
						&& $('#riesgosID').val()!= var_Parametros.Sucursal){
					seleccionaPorcentaje(); 
				}
				if($('#riesgosID').val()== var_Parametros.Zona_Geografica){
					seleccionaEstado();
				}
				if($('#riesgosID').val()== var_Parametros.Producto_Crédito){
					seleccionaProducto();
				}
				if($('#riesgosID').val()== var_Parametros.Sucursal){
					seleccionaSucursal();
				}
				agregaFormatoControles('divPorcentajes');
			}else{				
				$('#divPorcentajes').html("");
				$('#divPorcentajes').show(); 
			}
		});
		}
		else{
			$('#divPorcentajes').html("");
			$('#divPorcentajes').hide();
			deshabilitaBoton('grabar', 'submit');
		}
	}
	
	// Función para Consultar Información de los Parámetros de Riesgos de Consumo
	function consultaParamsConsumo(){			
		var parametrosID= $('#paramRiesgosID').val();
		$('#riesgosID').val(parametrosID);
		var params = {};
		params['tipoLista'] = 3;
		params['paramRiesgosID'] = parametrosID;
		if(parametrosID >0){
		$.post("parametrosRiesgoGridVista.htm", params, function(data){
			if(data.length >0) {
				$('#divPorcentajes').html(data);
				$('#divPorcentajes').show();
				habilitaBoton('grabar', 'submit');
				seleccionaPorcentaje();
				agregaFormatoControles('divPorcentajes');
			}else{				
				$('#divPorcentajes').html("");
				$('#divPorcentajes').show(); 
			}
		});
		}
		else{
			$('#divPorcentajes').html("");
			$('#divPorcentajes').hide();
			deshabilitaBoton('grabar', 'submit');
		}
	}

	// Función para Consultar Información de los Parámetros de Riesgos de Tipos de Ahorro
	function consultaParamsTipoAhorro(){			
		var parametrosID= $('#paramRiesgosID').val();
		$('#riesgosID').val(parametrosID);
		var params = {};
		params['tipoLista'] = 4;
		params['paramRiesgosID'] = parametrosID;
		if(parametrosID >0){
		$.post("parametrosRiesgoGridVista.htm", params, function(data){
			if(data.length >0) {
				$('#divPorcentajes').html(data);
				$('#divPorcentajes').show();
				habilitaBoton('grabar', 'submit');
				seleccionaPorcentaje();
				agregaFormatoControles('divPorcentajes');
			}else{				
				$('#divPorcentajes').html("");
				$('#divPorcentajes').show(); 
			}
		});
		}
		else{
			$('#divPorcentajes').html("");
			$('#divPorcentajes').hide();
			deshabilitaBoton('grabar', 'submit');
		}
	}
	
	// Función para Consultar Información de los Parámetros de Riesgos Sectores Económicos
	function consultaParamsSectorEconomico(){			
		var parametrosID= $('#paramRiesgosID').val();
		$('#riesgosID').val(parametrosID);
		var params = {};
		params['tipoLista'] = 5;
		params['paramRiesgosID'] = parametrosID;
		if(parametrosID >0){
		$.post("parametrosRiesgoGridVista.htm", params, function(data){
			if(data.length >0) {
				$('#divPorcentajes').html(data);
				$('#divPorcentajes').show();
				habilitaBoton('grabar', 'submit');
				seleccionaPorcentaje();
				agregaFormatoControles('divPorcentajes');
			}else{				
				$('#divPorcentajes').html("");
				$('#divPorcentajes').show(); 
			}
		});
		}
		else{
			$('#divPorcentajes').html("");
			$('#divPorcentajes').hide();
			deshabilitaBoton('grabar', 'submit');
		}
	}

	// Función para seleccionar porcentaje
	 function seleccionaPorcentaje(control){
	 		$('select[name=porcentaje]').each(function() {
	 	});
	 		$('#porcentaje1').focus();
			$('#porcentaje1').select();
	 }
	 
	// Función para seleccionar el Estado
	 function seleccionaEstado(control){
	 		$('select[name=estadoID]').each(function() {
	 	});
	 		$('#estadoID1').focus();
			$('#estadoID1').select();
	 }
	 
	// Función para seleccionar el Producto de Credito
	 function seleccionaProducto(control){
	 		$('select[name=producCreditoID]').each(function() {
	 	});
	 		$('#producCreditoID1').focus();
			$('#producCreditoID1').select();
	 }
	 
	// Función para seleccionar la Sucursal
	 function seleccionaSucursal(control){
	 		$('select[name=sucursalID]').each(function() {
	 	});
	 		$('#sucursalID1').focus();
			$('#sucursalID1').select();
	 }
	 
	 // Función para agregar nuevas Filas en el grid de Porcentajes
	function agregaNuevoParametro(){ 
		if($('#riesgosID').val()== var_Parametros.Zona_Geografica){
		var numeroFila = ($('#miTabla >tbody >tr').length ) -1 ;
		var nuevaFila = parseInt(numeroFila) + 1;					
		var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
		  
		if(numeroFila == 0){
			tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="4"  value="1" autocomplete="off"  type="hidden" />';
			tds += '<input id="riesgo'+nuevaFila+'" name="riesgo"  size="6"  value="" autocomplete="off"  type="hidden" />';								
			tds += '<input id="estadoID'+nuevaFila+'" name="estadoID" size="4"  type="text" onkeypress="listaEstados(this.id)" onblur="consultaEstado(this.id)" /></td>';
			tds += '<td><input type="text" id="descripcion'+nuevaFila+'" name="ldescripcion"  size="40" readOnly="true" /></td>';	
			tds += '<td><input type="text" id="porcentaje'+nuevaFila+'" name="lporcentaje"  size="7" maxlength="6" onblur="validaPorcentaje(this.id),agregaFormatoPorcentaje()" style="text-align:right" onkeyPress="return validador(event);" /><label> %</label></td>';	
			tds += '<td><input type="hidden" id="referencia'+nuevaFila+'" name="lreferencia"  size="4" /></td>';
		} else{    		
			var valor = numeroFila+ 1;
			tds += '<td><input id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="4"  value="'+valor+'"autocomplete="off"  type="hidden" />';
			tds += '<input id="riesgo'+nuevaFila+'" name="riesgo"  size="6"  value="" autocomplete="off" type="hidden" />';								
			tds += '<input id="estadoID'+nuevaFila+'" name="estadoID" size="4" type="text" onkeypress="listaEstados(this.id)" onblur="consultaEstado(this.id)" /></td>';
			tds += '<td><input type="text" id="descripcion'+nuevaFila+'" name="ldescripcion" size="40" readOnly="true" /></td>';	
			tds += '<td><input type="text" id="porcentaje'+nuevaFila+'" name="lporcentaje"  size="7" maxlength="6" onblur="validaPorcentaje(this.id),agregaFormatoPorcentaje()" style="text-align:right" onkeyPress="return validador(event);" /><label> %</label></td>';	
			tds += '<td><input type="hidden" id="referencia'+nuevaFila+'" name="lreferencia"  size="4" /></td>';
		}
			tds += '<td ><input type="button" name="eliminar" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminarParametro(this.id)"/>';
			tds += '	<input type="button" name="agregar" id="agregar'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevoParametro()"/></td>';
			tds += '</tr>';	   	   
			$("#miTabla").append(tds);
			return false;
		}
		
		else if($('#riesgosID').val()== var_Parametros.Producto_Crédito){
			var numeroFila = ($('#miTabla >tbody >tr').length ) -1 ;
			var nuevaFila = parseInt(numeroFila) + 1;					
			var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
			  
			if(numeroFila == 0){
				tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="4"  value="1" autocomplete="off"  type="hidden"  />';
				tds += '<input id="riesgo'+nuevaFila+'" name="riesgo"  size="6"  value="" autocomplete="off"  type="hidden" />';								
				tds += '<input id="producCreditoID'+nuevaFila+'" name="producCreditoID" size="4" type="text" onkeypress="listaProductos(this.id)" onblur="consultaProducto(this.id)" /></td>';
				tds += '<td><input type="text" id="descripcion'+nuevaFila+'" name="ldescripcion"  size="40"  readOnly="true" /></td>';	
				tds += '<td><input type="text" id="porcentaje'+nuevaFila+'" name="lporcentaje"  size="7" maxlength="6" onblur="validaPorcentaje(this.id),agregaFormatoPorcentaje()" style="text-align:right" onkeyPress="return validador(event);" /><label> %</label></td>';	
				tds += '<td><input type="hidden" id="referencia'+nuevaFila+'" name="lreferencia"  size="4" /></td>';
			} else{    		
				var valor = numeroFila+ 1;
				tds += '<td><input id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="4"  value="'+valor+'"autocomplete="off"  type="hidden" />';
				tds += '<input id="riesgo'+nuevaFila+'" name="riesgo"  size="6"  value="" autocomplete="off" type="hidden" />';								
				tds += '<input id="producCreditoID'+nuevaFila+'" name="producCreditoID" size="4" type="text" onkeypress="listaProductos(this.id)" onblur="consultaProducto(this.id)"   /></td>';
				tds += '<td><input type="text" id="descripcion'+nuevaFila+'" name="ldescripcion"  size="40" readOnly="true" /></td>';	
				tds += '<td><input type="text" id="porcentaje'+nuevaFila+'" name="lporcentaje"  size="7" maxlength="6" onblur="validaPorcentaje(this.id),agregaFormatoPorcentaje()" style="text-align:right" onkeyPress="return validador(event);" /><label> %</label></td>';	
				tds += '<td><input type="hidden" id="referencia'+nuevaFila+'" name="lreferencia"  size="4" /></td>';
			}
				tds += '<td ><input type="button" name="eliminar" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminarParametro(this.id)"/>';
				tds += '	<input type="button" name="agregar" id="agregar'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevoParametro()"/></td>';
				tds += '</tr>';	   	   
				$("#miTabla").append(tds);
				return false;
			}
		else if($('#riesgosID').val()==var_Parametros.Sucursal){
			var numeroFila = ($('#miTabla >tbody >tr').length ) -1 ;
			var nuevaFila = parseInt(numeroFila) + 1;					
			var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
			  
			if(numeroFila == 0){
				tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="4"  value="1" autocomplete="off"  type="hidden"  />';
				tds += '<input id="riesgo'+nuevaFila+'" name="riesgo"  size="6"  value="" autocomplete="off"  type="hidden" />';								
				tds += '<input id="sucursalID'+nuevaFila+'" name="sucursalID" size="4"  type="text" onkeypress="listaSucursal(this.id)" onblur="consultaSucursal(this.id)" /></td>';
				tds += '<td><input type="text" id="descripcion'+nuevaFila+'" name="ldescripcion"  size="40" readOnly="true" /></td>';	
				tds += '<td><input type="text" id="porcentaje'+nuevaFila+'" name="lporcentaje"  size="7" maxlength="6" onblur="validaPorcentaje(this.id),agregaFormatoPorcentaje()" style="text-align:right" onkeyPress="return validador(event);" /><label> %</label></td>';	
				tds += '<td><input type="hidden" id="referencia'+nuevaFila+'" name="lreferencia"  size="4" /></td>';
			} else{    		
				var valor = numeroFila+ 1;
				tds += '<td><input id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="4"  value="'+valor+'"autocomplete="off" type="hidden"  />';
				tds += '<input id="riesgo'+nuevaFila+'" name="riesgo"  size="6"  value="" autocomplete="off" type="hidden" />';								
				tds += '<input id="sucursalID'+nuevaFila+'" name="sucursalID" size="4"  type="text" onkeypress="listaSucursal(this.id)" onblur="consultaSucursal(this.id)" /></td>';
				tds += '<td><input type="text" id="descripcion'+nuevaFila+'" name="ldescripcion"  size="40" readOnly="true" /></td>';	
				tds += '<td><input type="text" id="porcentaje'+nuevaFila+'" name="lporcentaje"  size="7" maxlength="6" onblur="validaPorcentaje(this.id),agregaFormatoPorcentaje()" style="text-align:right" onkeyPress="return validador(event);" /><label> %</label></td>';	
				tds += '<td><input type="hidden" id="referencia'+nuevaFila+'" name="lreferencia"  size="4" /></td>';
			}
				tds += '<td ><input type="button" name="eliminar" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminarParametro(this.id)"/>';
				tds += '	<input type="button" name="agregar" id="agregar'+nuevaFila +'" value="" class="btnAgrega" onclick="agregaNuevoParametro()"/></td>';
				tds += '</tr>';	   	   
				$("#miTabla").append(tds);
				return false;
			}
	}
	
	function consultaFilas(){
		var totales=0;
		$('tr[name=renglon]').each(function() {
			totales++;		
		});
		return totales;
	}
		
	 
	// Función para eliminar Filas en el grid de Porcentajes	
	function eliminarParametro(control){
		var contador = 0 ;
		var numeroID = control;
		
		var jqRenglon = eval("'#renglon" + numeroID + "'");
		var jqNumero = eval("'#consecutivoID" + numeroID + "'");
		var jqRiesgo = eval("'#riesgo" + numeroID + "'");		
		var jqParametroID = eval("'#paramRiesgosID" + numeroID + "'");
		var jqDescripcion=eval("'#descripcion" + numeroID + "'");
		var jqPorcentaje=eval("'#porcentaje" + numeroID + "'");
		var jqAgregar=eval("'#agregar" + numeroID + "'");
		var jqEliminar = eval("'#" + numeroID + "'");
	
		// se elimina la fila seleccionada
		$(jqRenglon).remove();
		$(jqNumero).remove();
		$(jqRiesgo).remove();
		$(jqParametroID).remove();
		$(jqDescripcion).remove();
		$(jqPorcentaje).remove();
		$(jqAgregar).remove();
		$(jqEliminar).remove();
	
		//Reordenamiento de Controles
		contador = 1;
		var numero= 0;
		$('tr[name=renglon]').each(function() {	
			numero= this.id.substr(7,this.id.length);
			var jqRenglon1 = eval("'#renglon"+numero+"'");
			var jqNumero1 = eval("'#consecutivoID"+numero+"'");
			var jqRiesgo1 = eval("'#riesgo"+numero+"'");		
			var jqParametroID1= eval("'#paramRiesgosID"+numero+"'");
			var jqDescripcion1=eval("'#descripcion"+ numero+"'");
			var jqPorcentaje1=eval("'#porcentaje"+ numero+"'");
			var jqAgregar1=eval("'#agregar"+ numero+"'");
			var jqEliminar1 = eval("'#"+numero+ "'");

			$(jqNumero1).attr('id','consecutivoID'+contador);
			$(jqRiesgo1).attr('id','riesgo'+contador);
			$(jqParametroID1).attr('id','paramRiesgosID'+contador);
			$(jqDescripcion1).attr('id','descripcion'+contador);
			$(jqPorcentaje1).attr('id','porcentaje'+contador);
			$(jqAgregar1).attr('id','agregar'+contador);
			$(jqEliminar1).attr('id',contador);
			$(jqRenglon1).attr('id','renglon'+ contador);
			contador = parseInt(contador + 1);	
			
		});
		
	}
	
	// Función para listar los Estados de la República.
	function listaEstados(idControl){
		var jq = eval("'#" + idControl + "'");
		$(jq).bind('keyup',function(e){
			var jqControl = eval("'#" + this.id + "'");
			var num = $(jqControl).val();
				
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "nombre"; 
			parametrosLista[0] = num;
			lista(idControl, '1', '1', camposLista, parametrosLista, 'listaEstados.htm');
		});
	}

	// Función Para consultar los Estados de la República.
	function consultaEstado(control) {
			var jqEstado = eval("'#" + control + "'");
			var numEstado = $(jqEstado).val();	
			var tipConPrincipal = 1;

			var jqDescripcion = eval("'#descripcion" + control.substr(8) + "'");
			var jqReferenciaID = eval("'#referencia" + control.substr(8) + "'");
			setTimeout("$('#cajaLista').hide();", 200);		
			if(numEstado != '' && !isNaN(numEstado) && verificaSeleccionadoEstado(control) == 0 && esTab){
				estadosServicio.consulta(tipConPrincipal,numEstado,function(estado) {
					if(estado!=null){
						$(jqDescripcion).val(estado.nombre);						
						$(jqReferenciaID).val(estado.estadoID);
					}else{
						alert("No Existe el Estado.");
						$(jqEstado).val("");
						$(jqDescripcion).val("");
						$(jqReferenciaID).val("");
						$(jqEstado).focus();
					}    	 						
			});
			}
		}
	
	// Función para verificar Estados repetidos
	function verificaSeleccionadoEstado(idCampo){
		var contador = 0;
		var nuevoEstado	=$('#'+idCampo).val();
		var numeroNuevo= idCampo.substr(8,idCampo.length);
		var jqDescripcion 	= eval("'descripcion" + numeroNuevo+ "'");
		var jqReferenciaID = eval("'referencia" + numeroNuevo + "'");
		var jqEstado 	= eval("'estadoID" + numeroNuevo+ "'");
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var jqEstadoID = eval("'estadoID" + numero+ "'");
			var valorEstado = $('#'+jqEstadoID).val();
			if(jqEstadoID != idCampo){
				if(valorEstado == nuevoEstado){
					alert("El Estado Especificado Ya Existe.");
					$('#'+idCampo).focus();
					$('#'+idCampo).val("");
					$('#'+jqDescripcion).val("");
					$('#'+jqEstado).val("");
					$('#'+jqReferenciaID).val("");
					contador = contador+1;
				}		
			}
		});		
		return contador;
	}

	// Función para listar los Productos de Crédito.
	function listaProductos(idControl){
		var jq = eval("'#" + idControl + "'");
		$(jq).bind('keyup',function(e){
			var jqControl = eval("'#" + this.id + "'");
			var num = $(jqControl).val();
				
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = num;
			lista(idControl, '1', '1', camposLista, parametrosLista, 'listaProductosCredito.htm');
		});
	}
	
	// Función para consultar los Productos de Crédito.
	function consultaProducto(control) {
		var jqProducto = eval("'#" + control + "'");
		var numProducto = $(jqProducto).val();	
		var tipConPrincipal = 1;
		var ProdCredBeanCon = {
				'producCreditoID' : numProducto
		};
		var jqDescripcion = eval("'#descripcion" + control.substr(15) + "'");
		var jqReferenciaID = eval("'#referencia" + control.substr(15) + "'");
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numProducto != '' && !isNaN(numProducto) && verificaSeleccionadoProductos(control) == 0 && esTab){
			productosCreditoServicio.consulta(tipConPrincipal,ProdCredBeanCon,function(prodCred) {
					if(prodCred!=null){
						$(jqDescripcion).val(prodCred.descripcion);
						$(jqReferenciaID).val(prodCred.producCreditoID);
					}else{
						alert("No Existe el Producto de Crédito.");
						$(jqProducto).val("");
						$(jqDescripcion).val("");
						$(jqReferenciaID).val("");
						$(jqProducto).focus();
					}    	 						
			});
		}
	}

	// Función para verificar Productos de Créditos repetidos
	function verificaSeleccionadoProductos(idCampo){
		var contador = 0;
		var nuevoProducto	=$('#'+idCampo).val();
		var numeroNuevo= idCampo.substr(15,idCampo.length);
		var jqDescripcion 	= eval("'descripcion" + numeroNuevo+ "'");
		var jqReferenciaID = eval("'referencia" + numeroNuevo + "'");
		var jqProducto 	= eval("'producCreditoID" + numeroNuevo+ "'");
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var jqProductoID = eval("'producCreditoID" + numero+ "'");
			var valorProducto = $('#'+jqProductoID).val();
			if(jqProductoID != idCampo){
				if(valorProducto == nuevoProducto){
					alert("El Producto de Crédito Especificado Ya Existe.");
					$('#'+idCampo).focus();
					$('#'+idCampo).val("");
					$('#'+jqDescripcion).val("");
					$('#'+jqProducto).val("");
					$('#'+jqReferenciaID).val("");
					contador = contador+1;
				}		
			}
		});		
		return contador;
	}
	
	// Función para listar las Sucursales.
	function listaSucursal(idControl){
		var jq = eval("'#" + idControl + "'");
		$(jq).bind('keyup',function(e){
			var jqControl = eval("'#" + this.id + "'");
			var num = $(jqControl).val();
				
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "nombreSucurs"; 
			parametrosLista[0] = num;
			lista(idControl, '1', '1', camposLista, parametrosLista, 'listaSucursales.htm');
		});
	}
	
	// Función para consultar las Sucursales.
	function consultaSucursal(control) {
		var jqSucursal = eval("'#" + control + "'");
		var numSucursal = $(jqSucursal).val();	
		var tipConPrincipal = 1;
		
		var jqDescripcion = eval("'#descripcion" + control.substr(10) + "'");
		var jqReferenciaID = eval("'#referencia" + control.substr(10) + "'");
		
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numSucursal != '' && !isNaN(numSucursal) && verificaSeleccionadoSucursal(control)== 0 && esTab){
			sucursalesServicio.consultaSucursal(tipConPrincipal,numSucursal,function(sucursal) {
					if(sucursal!=null){
						$(jqDescripcion).val(sucursal.nombreSucurs);
						$(jqReferenciaID).val(sucursal.sucursalID);
					}else{
						alert("No Existe la Sucursal.");
						$(jqSucursal).val("");
						$(jqDescripcion).val("");
						$(jqReferenciaID).val("");
						$(jqSucursal).focus();
					}    	 						
			});
		}
	}
	
	// Función para verificar Sucursales repetidos
	function verificaSeleccionadoSucursal(idCampo){
		var contador = 0;
		var nuevoEstado	=$('#'+idCampo).val();
		var numeroNuevo= idCampo.substr(10,idCampo.length);
		var jqDescripcion 	= eval("'descripcion" + numeroNuevo+ "'");
		var jqReferenciaID = eval("'referencia" + numeroNuevo + "'");
		var jqSucursal = eval("'sucursalID" + numeroNuevo+ "'");
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var jqEstadoID = eval("'sucursalID" + numero+ "'");
			var valorEstado = $('#'+jqEstadoID).val();
			if(jqEstadoID != idCampo){
				if(valorEstado == nuevoEstado){
					alert("La Sucursal Especificada Ya Existe.");
					$('#'+idCampo).focus();
					$('#'+idCampo).val("");
					$('#'+jqDescripcion).val("");
					$('#'+jqSucursal).val("");
					$('#'+jqReferenciaID).val("");
					contador = contador+1;
				}		
			}
		});		
		return contador;
	}
	
	// Función para validar que no exista campos vacios al grabar los parametros
	function guardarParametros(){		
		var mandar = verificarvacios();
		if(mandar!=1){   		  		
		var numCodigo = $('input[name=consecutivoID]').length;
		$('#riesgo').val("");
		for(var i = 1; i <= numCodigo; i++){
			if(i == 1){
				$('#riesgo').val($('#riesgo').val() +
				document.getElementById("descripcion"+i+"").value);
			}else{
				$('#riesgo').val($('#riesgo').val() + '[' +
				document.getElementById("descripcion"+i+"").value);			
				}	
			}
		}
		else{
		alert("El Parámetro No Deber Estar Vacío.");
			event.preventDefault();
		}
	}
	
	// Función para verificar campos vacios
	function verificarvacios(){	
		var numCodig = $('input[name=consecutivoID]').length;
		$('#riesgo').val("");
		for(var i = 1; i <= numCodig; i++){	
			var idcde = document.getElementById("descripcion"+i+"").value;
				if (idcde ==""){
					document.getElementById("descripcion"+i+"").focus();
				$(idcde).addClass("error");
					return 1; 
				}
			}
		}
	
	// Función para agregar formato al porcentaje
	function agregaFormatoPorcentaje(){ 
		var contador = 0;
		var jqPorcentaje ="";
		$('input[name=lporcentaje]').each(function() {	
			contador = contador + 1;
			jqPorcentaje = eval("'#porcentaje"+contador+"'");
			$(jqPorcentaje).formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 2	
			});
		});
	}
		
	function exito(){
		 deshabilitaBoton('grabar', 'submit');
	}
	function fallo(){
		
	}
	
	// Función para validar sólo números
	function validador(e){
		key=(document.all) ? e.keyCode : e.which;
		if ( key < 46 || key > 57){
			if (key==8 || key == 0){
				return true;
			}
			else 
				return false;
		}
	}
	
	// Función para validar el valor del porcentaje
	function validaPorcentaje(control){
	    var valorPorcentaje = 0;
	    var porcentaje=eval("'#" + control + "'");

		$('input[name=lporcentaje]').each(function() {
			var numero = this.id.substr(10, this.id.length);
			var jqPorcentaje=eval("'#porcentaje" + numero + "'");
			
			var valPorc=$(jqPorcentaje).asNumber();
			
			valorPorcentaje=valPorc;
						
			if(valorPorcentaje > 100){
				alert('Valor Máximo 100 %');
				$(porcentaje).val('0.00');
 				$(porcentaje).focus();
			}			
		});
	}
		
	

		
