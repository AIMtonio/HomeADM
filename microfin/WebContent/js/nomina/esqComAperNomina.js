var varPlazos = {};
var varConvenios = {};
var varFilasConvenio = [];
var varTipoLista = {
		'listaPrincipal': 1,
		'listaConvenios': 9
	};
var varPlazosCalendario = [];
var varPlazosCombo = [];
var varPlazosFiltradosCombo = [];

$(document).ready(function() {
	esTab = true;

	agregaFormatoControles('formaGenerica');
	funcionCargaProductosNomina();
	var parametroBean = consultaParametrosSession();

	/**
	 * Pone tap falso cuando toma el foco input text
	 */
	$(':text').focus(function() {
	 	esTab = false;
	});

	/**
	 * Pone tab en verdadero cuando se presiona tab
	 */
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab = true;
		}
	});

	funcionListaConvenios();
    funcionListaPlazo();
	}); 
	/**
	 * Tipo de Transacción
	 */
	var varCatTipoTransaccion = {
		 'grabar'	: 1,
		 'modificar': 2,
		 'grabarEsq': 3
	};

	var varEsquemaConvenios = {
		 'principal'	: 1
	};

	/**
	 * METODOS  Y MANEJO DE EVENTOS
	 */

	$('#institNominaID').focus();

	deshabilitaBoton('agregar', 'submit');
	deshabilitaBoton('grabar', 'submit');

	/**
	 * Lista de Institución de Nómina
	 */
	$('#institNominaID').bind('keyup', function(e) {
		lista('institNominaID', '2',1 ,'institNominaID', $('#institNominaID').val(),'institucionesNomina.htm');
	});

	/**
	 * Consulta de Institución de Nómina
	 */
	$('#institNominaID').blur(function () {
		if(esTab){
			setTimeout("$('#cajaLista').hide();", 200);
			if(isNaN($('#institNominaID').val()) || $('#institNominaID').val() == '') {
				$('#institNominaID').val('');
				$('#nombreInstit').val('');
				dwr.util.removeAllOptions('convenioNominaID');
				dwr.util.addOptions('convenioNominaID', {'':'SELECCIONAR'});
			} else {
				funcionConsultaInstitucion(this.id);
			}
		}
	});
	
	/**
	 * Consulta de Esquema por Institución y Producto
	 */
	$('#producCreditoID').change(function () {
		if(esTab){
			setTimeout("$('#cajaLista').hide();", 200);
			if(!isNaN($('#institNominaID').val()) && $('#producCreditoID').val() != '') {
				funcionConsultaCalendario();
				funcionConsultaEsquema(this.id);
			}
		}
	});
	

	/**
	 * Grabar Esquemas Comision Apertura
	 */
	$('#grabarEsq').click(function() {
		if($('#esqComApertID').val()=='')
			$('#tipoTransaccion').val(varCatTipoTransaccion.grabar);
		else
			$('#tipoTransaccion').val(varCatTipoTransaccion.modificar);
		event.preventDefault();
		if ($("#formaGenerica").valid()) {
        	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','esqComApertID','funcionExito','funcionError');
		}
		if($('#manejaEsqConvenio').checked==true)
		funcionCargaEsquemasConvenio();
	});	
	/**
	 * Grabar Esquemas Convenios
	 */
	$('#grabar').click(function() {
		$('#tipoTransaccion').val(varCatTipoTransaccion.grabarEsq);
		event.preventDefault();
		if ($("#formaGenerica").valid()) {
			var mensaje = funcionValidaNuevoRegistro();
			if(mensaje.length>0){
				mensajeSis(mensaje);
				return;
			}

        	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','institNominaID','funcionExitoEsq','funcionErrorEsq');
     

		}
	});


	/**
	 * VALIDACIONES DE LA FORMA
	 */
	$('#formaGenerica').validate({
		rules: {
			institNominaID: {
				required: true
			},
			convenioNominaID : {
				required: true
			}
		},
		messages: {
			institNominaID: {
				required: 'Especifique la Empresa de Nómina.'
			},
			convenioNominaID: {
				required: 'Especifique Número Convenio.'
			}
		}
	});
	
   function funcionCargaProductosNomina(){
	   productosCreditoServicio.listaCombo(12, function(productosNom){
			dwr.util.removeAllOptions('producCreditoID');
			dwr.util.addOptions('producCreditoID', {'':'SELECCIONAR'});
			dwr.util.addOptions('producCreditoID', productosNom, 'producCreditoID', 'descripcion');
		});
	}
	/**
	 * Consulta de Institución de Nómina
	 */
	function funcionConsultaEsquema(idControl) {
		var jqControl = eval("'#" + idControl + "'");
		var beanEsquema = {
			'institNominaID': $('#institNominaID').val(),
		    'producCreditoID': $('#producCreditoID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if($(jqControl).val() != '' && !isNaN($(jqControl).val()) && $(jqControl).val() != 0) {
			esqComAperNominaServicio.consulta(1, beanEsquema, function(resultado) {
				if(resultado != null) {
					$('#esqComApertID').val(resultado.esqComApertID);
					if(resultado.manejaEsqConvenio=="S") {
						$('#manejaEsqConvenioSi').attr('checked', true);
						funcionListaGridEsquemaConvenios();
					}else{
						$('#manejaEsqConvenioNo').attr('checked', true);
						  $('#contenedorEsquema').hide();
				 	      $('#formaTablaEsquema').html("");
				 	      $('#formaTablaEsquema').hide();
					}
				}
				else
				{
					$('#esqComApertID').val('');
					$('#manejaEsqConvenioNo').attr('checked', true);
					  $('#contenedorEsquema').hide();
			 	      $('#formaTablaEsquema').html("");
			 	      $('#formaTablaEsquema').hide();
				}
			});
		}
	}

	/**
	 * Consulta de Institución de Nómina
	 */
	function funcionConsultaInstitucion(idControl) {
		var jqControl = eval("'#" + idControl + "'");
		var beanInstitucion = {
			'institNominaID': $('#institNominaID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if($(jqControl).val() != '' && !isNaN($(jqControl).val()) && $(jqControl).val() != 0) {
			institucionNomServicio.consulta(1, beanInstitucion, function(resultado) {
				if(resultado != null) {
					$('#nombreInstit').val(resultado.nombreInstit);
					funcionListaConveniosNomina();
					if($('#producCreditoID').val() != '')
					{
						setTimeout("$('#cajaLista').hide();", 200);
						if(!isNaN($('#institNominaID').val()) && $('#producCreditoID').val() != '') {
							funcionConsultaCalendario();
							funcionConsultaEsquema('producCreditoID');
						}
					}
					
				} else {
					mensajeSis('La Institución de Nómina no Existe.');
					$('#nombreInstit').val('');
					dwr.util.removeAllOptions('convenioNominaID');
					dwr.util.addOptions('convenioNominaID', {'':'SELECCIONAR'});
				}
			});
		}
		$('#contenedorEsquema').hide();
		$('#formaTablaEsquema').html('');
	}

	/**
	 * Lista de Convenios de Nómina
	 */
	function funcionListaConveniosNomina() {
		var beanConvenio = {
			'institNominaID': $('#institNominaID').val()
		};

		conveniosNominaServicio.lista(9, beanConvenio, function(resultado) {
			dwr.util.removeAllOptions('convenioNominaID');
			if (resultado != null && resultado.length > 0) {
				dwr.util.addOptions('convenioNominaID', {'':'SELECCIONAR'});
				dwr.util.addOptions('convenioNominaID', resultado, 'convenioNominaID', 'descripcion');
				return;
			}
			else
			{
			mensajeSis('No se encontraron convenios para esta empresa que cobren comision por apertura');
			funcionLimpiarEsquema();
			}	
		});
	}
	
	
	/**
	 * Consulta de Convenios
	 */
	function funcionCargaEsquemasConvenio() {
		
		if($('#esqComApertID').val()!=null && $('#esqComApertID').val()!= '') {
			funcionListaGridEsquemaConvenios();
		}else{
			 $('#contenedorEsquema').hide();
	 	      $('#formaTablaEsquema').html("");
	 	      $('#formaTablaEsquema').hide();
		} 
		
	};

	function funcionListaGridEsquemaConvenios(){
        
		var inst=$('#institNominaID').val();
		var producto=$('#producCreditoID').val();
            
		if (inst == ''){
		 	      mensajeSis("Especifique la Empresa Nómina");
		 	      $('#institNominaID').focus();
		 	      $('#contenedorEsquema').hide();
		 	      $('#formaTablaEsquema').html("");
		 	      $('#formaTablaEsquema').hide();
                
		 	      deshabilitaBoton('grabar');
		 	    }else if(producto == '' || producto == 0){
		 	      mensajeSis("Especifique el Producto");
		 	      $('#contenedorEsquema').hide();
		 	      $('#formaTablaEsquema').html("");
		 	      $('#formaTablaEsquema').hide();
		 	      deshabilitaBoton('grabar');

		 	    }

		 	    else if(inst != '' && producto != ''){
				 habilitaBoton('grabar');
		 	    var params = {};
		 	    
		 	    params['esqComApertID'] = $('#esqComApertID').val();
		 		params['institNominaID'] = $('#institNominaID').val();
		 		params['convenioNominaID'] = $('#producCreditoID option:selected').val();
		 		params['tipoLista'] = varEsquemaConvenios.principal;
			
		$.post("comApertConvenioGrid.htm",params, function(data) {
                  
				if(data.length > 0) {
					habilitaBoton('grabar');
					$('#formaTablaEsquema').html(data);
					$('#formaTablaEsquema').show();
					$('#contenedorEsquema').show();
					agregaFormatoControles('formaGenerica');
					//listaPlazo();
				    //listaConvenios();
					
				} else {
					mensajeSis("Error al generar la lista de esquema Convenios");
				  $('#contenedorEsquema').hide();
		 	      $('#formaTablaEsquema').html("");
		 	      $('#formaTablaEsquema').hide();
				}
			});
	}}
	
	function Validador(e) {
		var valid = true;
		key=(document.all) ? e.keyCode : e.which;
		if (key < 48 || key > 57 || key == 46) {
			if (key==8|| key == 46)	{ 
				valid = true;
			}
			else
				mensajeSis("sólo se pueden ingresar números");
			valid = false;

		}
		 if(e.target.value.length>10)
			 valid = false
		return valid;
	}

	function funcionMuestraConvenios(numConvenio,valueConvenio){
			funcionCargaConveniosCombo("convenioNominaID"+numConvenio,valueConvenio);
	}

	function funcionMuestraPlazos(numPlazo,valuePlazo,valuesPlazo){
		funcionCargaPlazosCombo("plazoID"+numPlazo,valuePlazo,valuesPlazo);
    }
	
	function funcionAgregarNuevoRegistro(idControl){
		var mensaje = funcionValidaNuevoRegistro();
		if(mensaje.length>0){
			mensajeSis(mensaje);
			return;
		}
	  //var numeroFila=funcionConsultaFilas();
	 
	  var numeroFila = funcionConsultaLastIndex();
	  var nuevaFila = parseInt(numeroFila) + 1;
      var tabIndex = 9*numeroFila+5;

	 			 var tds =	
	 				"<tr id=\"renglon"+ nuevaFila + "\" name=\"renglon\">"+
					"<td style=\"display:none\">"+
					"<input type=\"hidden\" id=\"fila"+ nuevaFila + "\" name=\"fila\" value=\""+ nuevaFila + "\"/>"+
					"</td>"+
					" <td valign=\"top\"> "+
					"  		<select id=\"convenioNominaID"+ nuevaFila + "\" tabindex=\""+tabIndex+1+"\" name=\"convenioNominaID\">"+ 
					"			<option value=\"0\">TODOS</option>"+
					"		</select>	"+
					"  		<input type=\"hidden\" id=\"lisConvenioID"+ nuevaFila + "\" name=\"lisConvenioID\" "+"value=\"${esquema.convenioNominaID}\"/>	"+
					" </td>"+
					" <td valign=\"top\"> "+
					"	<select id=\"formCobroComAper"+ nuevaFila + "\" name=\"formCobroComAper\"  path=\"formCobroComAper\"  tabindex=\""+tabIndex+2+"\" >"+
					"		<option value=\"\">SELECCIONAR</option> "+
					"		<option value=\"F\">FINANCIAMIENTO</option> "+
					"	    <option value=\"D\">DEDUCCI&Oacute;N</option>"+
					"	    <option value=\"A\">ANTICIPADO</option>"+
					"	    <option value=\"P\">PROGRAMADO</option>"+
					"	</select>	"+
					" </td>"+
					" <td valign=\"top\"> "+
					"	<select id=\"tipoComApert"+ nuevaFila + "\" name=\"tipoComApert\"  path=\"tipoComApert\"  tabindex=\""+tabIndex+3+"\" >"+
					"		<option value=\"\">SELECCIONAR</option> "+
					"		<option value=\"M\">MONTO</option> "+
					"		<option value=\"P\">PORCENTAJE</option> "+
					"	</select>	"+
					" </td>"+
					" <td valign=\"top\"> "+
					" 		<select multiple id=\"plazoID"+ nuevaFila + "\" tabindex=\""+tabIndex+4+"\" name=\"plazoID\" size=\"5\"  onchange=\"funcionSelecPlazos(this.id,"+ nuevaFila + ");\">"+
					"			<option value=\"0\">TODOS</option>"+
					"		</select>	"+
					"  		<input type=\"hidden\" id=\"lisPlazoID"+ nuevaFila + "\" name=\"lisPlazoID\" value=\"${esquema.lisPlazoID}\"/>	"+
					"    </td>"+
				    " <td valign=\"top\" class=\"label\"> "+
				    " 	<input type=\"text\" onkeyPress=\"return Validador(event);\" esMoneda=\"true\" id=\"montoMin"+ nuevaFila + "\" name=\"montoMin\" size=\"15\"  tabindex=\""+tabIndex+5+"\" />"+
				    " </td>"+
				    " <td valign=\"top\" class=\"label\"> "+
				    " 	<input type=\"text\" onkeyPress=\"return Validador(event);\" esMoneda=\"true\" id=\"montoMax"+ nuevaFila + "\" name=\"montoMax\" size=\"15\"  tabindex=\""+tabIndex+6+"\" />"+
				    " </td>"+
				    " <td valign=\"top\" class=\"label\"> "+
				    " 	<input type=\"text\" onkeyPress=\"return Validador(event);\" esMoneda=\"true\" id=\"valor"+ nuevaFila + "\" name=\"valor\" size=\"15\"  tabindex=\""+tabIndex+7+"\" />"+
				    " </td>"+
					" <td valign=\"top\">"+
					"    "+
					"	<input type=\"button\"  id=\"eliminar"+ nuevaFila + "\"  tabindex=\""+tabIndex+8+"\"  value=\"\" class=\"btnElimina\"  "+"onclick=\"funcionEliminarRegistro('renglon"+ nuevaFila + "')\"  />"+
					"	<input type=\"button\"  tabindex=\""+tabIndex+9+"\"  name=\"agrega\" id=\"agrega"+ nuevaFila + "\"  value=\"\" class=\"btnAgrega\" "+"onclick=\"funcionAgregarNuevoRegistro()\"/>"+
					"	"+
					"	</td>"+
					"</tr>";

	     
      $("#tablaGridEsquema").append(tds);
	agregaFormatoControles('formaGenerica');
	funcionAgregarPlazosDefinidos('plazoID' + nuevaFila);
	funcionAgregarConveniosDefinidos('convenioNominaID' + nuevaFila);
	}

	function funcionConsultaFilas(){
		var totales=0;
		$('tr[name=renglon]').each(function() {
	         
			totales++;
	
		});
		return totales;
	}
	
	function funcionConsultaLastIndex(){
		var last=0;
		$('tr[name=renglon]').each(function() {
	         
			last = Number(this.id.replace('renglon',''));
	
		});
		return last;
	}
	
    function funcionValMonto(el)
    {
    	el.value = el.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');
    }

	function funcionEliminarRegistro(id){
		
		$('#' + id).remove();
		
	}

	function funcionObtenerOpciones(select) {
					  var result="" ;
					
					  for (var i=0; i<select.length; i++) {
					  	if(i==select.length-1){
					  		 result+=select[i];
					  	}else{
					  		result+= select[i]+",";
					  	}
					   }
					  return result;
					}
	
	function funcionConsultaCalendario()
	{
		  var calendarioBeanCon = {
		                        'productoCreditoID' : $('#producCreditoID').val()
		                };
		                setTimeout("$('#cajaLista').hide();", 200);
		
		                    calendarioProdServicio.consulta(1,calendarioBeanCon, { async: false, callback:function(   calendario) {
		
		                    if (calendario != null) {
							     varPlazosCalendario = calendario.plazoID.split(',');
							}
							else
							{
								varPlazosCalendario = [];
								mensajeSis('Ocurrió un error al consultar el calendario de producto');
							}
					}
				}
			);
	}
	
	
	/*Obtener listado de plazos*/
	function funcionListaPlazo() {
		
	var plazoBean = {};
			
		plazosCredServicio.listaCombo(3, plazoBean,function(resultado) {
			                   if(resultado!=null)
			                   {
								varPlazosCombo = resultado;
								funcionFiltrarPlazosCalendario();
								funcionEstablecerValoresPlazosDefinidos();
							   }
								
					});
				
	}
	
	function funcionEstablecerValoresPlazosDefinidos() {
			$('#tablaGridEsquema tr').each(function(index) {
				if (index > 0) {
					agregarPlazosDefinidos('plazoID' + index);
					establecerValoresPlazos(index);
				}
			});
		}
	
	function funcionAgregarPlazosDefinidos(idControl) {
		funcionFiltrarPlazosCalendario();
		dwr.util.removeAllOptions(idControl);
		if (varPlazosFiltradosCombo != null && varPlazosFiltradosCombo.length > 0) {
			dwr.util.addOptions(idControl, {'0' : 'TODOS'});
			dwr.util.addOptions(idControl, varPlazosFiltradosCombo, 'plazoID', 'descripcion');
			return;
		} else {
			dwr.util.addOptions(idControl, {'' : 'NO SE ENCONTRARON PLAZOS'});
		}
	}
	
	
	function funcionEstablecerValoresPlazos(fila) {
		$('#tablaGridEsquema tr').each(function(index) {
			var valosPlazos = $("#lisPlazoID" + fila).val();
			if(valosPlazos == 0 ){
				$('#plazoID' + fila + ' option').attr('selected', true);
				$('#plazoID' + fila + ' option[value="0"]').attr('selected', false);
				return;
			}
	
			var listaPlazos = valosPlazos.split(',');
			for (var index=0;index< listaPlazos.length;index++) {
				var jqPlazo = eval("'#plazoID" + fila + " option[value=" + listaPlazos[index] + "]'");
				$(jqPlazo).attr("selected", "selected");
			}
		});
	}
	
	function funcionSelecPlazos(idControl, fila) {
		var valorPlazos = $('#' + idControl).val();
		if(valorPlazos != null){
	
				var listaPlazos = valorPlazos.toString();
			 if(listaPlazos == '0'){
					$('#' + idControl + ' option').attr('selected', true);
					$('#' + idControl + ' option[value="0"]').attr('selected', false);
					 valor = $('#' + idControl).val();
	                  $('#lisPlazoID' + fila).val(funcionObtenerOpciones(valor));
	                  return;
			}
				$('#lisPlazoID' + fila).val(listaPlazos);
				return;
			}
	
		}
	
	/*Obtener listado de convenios*/
	function funcionCargaConveniosCombo(idControl,value) {
		beanEntrada = {	
			'institNominaID': $('#institNominaID').val()
		};
		var convenio = eval(idControl);
		conveniosNominaServicio.lista(varTipoLista.listaConvenios, beanEntrada, function(resultado) {
			dwr.util.removeAllOptions(convenio);
			if (resultado != null && resultado.length > 0) {
				varConvenios =  resultado;
				dwr.util.addOptions(convenio, {'-1':'SELECCIONAR'});
				dwr.util.addOptions(convenio, {'0':'TODOS'});
				dwr.util.addOptions(convenio, resultado, 'convenioNominaID', 'descripcion');
				var jqConvenio = eval("'#" + idControl + " option[value=" + value + "]'");
				$(jqConvenio).attr("selected", "selected");
				return;
			}
			dwr.util.addOptions(convenio, {'': 'NO SE ENCONTRARON CONVENIOS'});
		});
	}
	
	function funcionCargaPlazosCombo(idControl,value,valuesList) {
		var plazoBean = {};
		plazosCredServicio.listaCombo(3, plazoBean,function(resultado) {
			if (resultado != null && resultado.length > 0) {
				varPlazosCombo =  resultado;
				funcionFiltrarPlazosCalendario();
				dwr.util.removeAllOptions(idControl);
				dwr.util.addOptions(idControl, {'0':'TODOS'});
				dwr.util.addOptions(idControl, varPlazosFiltradosCombo, 'plazoID', 'descripcion');
				for(var i=0;i<valuesList.length;i++)
				{
					var jqPlazo = eval("'#" + idControl + " option[value=" + valuesList[i] + "]'");
					$(jqPlazo).attr("selected", "selected");
				}
				
				return;
			}
			dwr.util.addOptions(idControl, {'': 'NO SE ENCONTRARON PLAZOS'});
		});
	}
	
	function funcionFiltrarPlazosCalendario()
	{
		varPlazosFiltradosCombo = [];
		for(var i=0;i<varPlazosCalendario.length;i++)
		{
			for(var j=0;j<varPlazosCombo.length;j++)
			{
				if(varPlazosCalendario[i]==varPlazosCombo[j].plazoID)
				{
					varPlazosFiltradosCombo.push(varPlazosCombo[j]);
					break;
				}
			}
		}
	}
	
	
	function funcionSetSelectOption(idControl,value)
	{
		$('#' + idControl).val(value);
	}
	
	/*Obtener listado de convenios*/
	function funcionListaConvenios() {
		beanEntrada = {
			'institNominaID': $('#institNominaID').val()
		};
		conveniosNominaServicio.lista(varTipoLista.listaConvenios, beanEntrada, function(resultado) {
			dwr.util.removeAllOptions('convenioNominaID');
			if (resultado != null && resultado.length > 0) {
				varConvenios =  resultado;
				dwr.util.addOptions('convenioNominaID', {'':'SELECCIONAR'});
				dwr.util.addOptions('convenioNominaID', resultado, 'convenioNominaID', 'descripcion');
				return;
			}
			dwr.util.addOptions('convenioNominaID', {'': 'NO SE ENCONTRARON CONVENIOS'});
		});
	}
	
	function funcionEstablecerValoresConveniosDefinidos() {
		$('#tablaGridEsquema tr').each(function(index) {
			if (index > 0) {
				funcionAgregarConveniosDefinidos('convenioNominaID' + index);
				funcionEstablecerValoresConvenios(index);
			}
		});
	}
	
	function funcionAgregarConveniosDefinidos(idControl) {
		
		beanEntrada = {
				'institNominaID': $('#institNominaID').val()
			};
			conveniosNominaServicio.lista(varTipoLista.listaConvenios, beanEntrada, function(resultado) {
				dwr.util.removeAllOptions(idControl);
				if (resultado != null && resultado.length > 0) {
					varConvenios =  resultado;
					dwr.util.addOptions(idControl, {'-1':'SELECCIONAR'});
					dwr.util.addOptions(idControl, {'0':'TODOS'});
					dwr.util.addOptions(idControl, resultado, 'convenioNominaID', 'descripcion');
					return;
				}
				dwr.util.addOptions('convenioNominaID', {'': 'NO SE ENCONTRARON CONVENIOS'});
			});	
	}
	
	
	function funcionEstablecerValoresConvenios(fila) {
	$('#tablaGridEsquema tr').each(function(index) {
		var valorConvenios = $("#lisConvenioID" + fila).val();
		if(valorConvenios == 0 ){
			$('#convenioNominaID' + fila + ' option').attr('selected', true);
			$('#convenioNominaID' + fila + ' option[value="0"]').attr('selected', false);
			return;
		}
	
		var listaConvenios = valorConvenios.split(',');
		for (var index=0;index< listaConvenios.length;index++) {
			var jqConvenio = eval("'#convenioNominaID" + fila + " option[value=" + listaConvenios[index] + "]'");
			$(jqConvenio).attr("selected", "selected");
		}
	});
	}
	
	function funcionSelecConvenios(idControl, fila) {
	var valorConvenios = $('#' + idControl).val();
	if(valorConvenios != null){
	
			var listaConvenios = valorConvenios.toString();
		 if(listaConvenios.includes('0')){
				$('#' + idControl + ' option').attr('selected', true);
				$('#' + idControl + ' option[value="0"]').attr('selected', false);
				 valor = $('#' + idControl).val();
	              $('#lisConvenioID' + fila).val(obtenerOpciones(valor));
	              return;
		}
			$('#lisConvenioID' + fila).val(listaConvenios);
			return;
		}
	
	}
	
	/*Fin Obtener listado de plazos*/
	
	
	function funcionValidaNuevoRegistro()
	{
		var tamanio = funcionConsultaFilas();
		if(tamanio==0)
		return '';
		
		var lastIndex = 0;
		$('tr[name=renglon]').each(function() {
	         
			lastIndex = Number(this.id.replace('renglon',''));
		});
		
		tamanio = lastIndex;
			//Opciones nuevas
		var filaIndex = {};
		filaIndex.montoMin = Number(($('#montoMin' + tamanio).val()+'$%').replace('%','').replace('$','').replace(',',''));
		filaIndex.montoMax = Number(($('#montoMax' + tamanio).val()+'$%').replace('%','').replace('$','').replace(',',''));
	    filaIndex.valor = Number(($('#valor' + tamanio).val()+'$%').replace('%','').replace('$','').replace(',',''));
		filaIndex.convenio = $('#convenioNominaID' + tamanio).val();
		filaIndex.formCobro = $('#formCobroComAper' + tamanio).val();
		filaIndex.tipoCom = $('#tipoComApert' + tamanio).val();
		filaIndex.plazos = $('#lisPlazoID' + tamanio).val().replace('[','').replace(']','').replace(' ','').split(',');
		var totalPlazosCombo = $('#plazoID1 option').map(function() { return $(this).val(); }).get().length-1;
		filaIndex.plazosTodos = filaIndex.plazos.length == totalPlazosCombo;
	
		if(filaIndex.convenio=='-1')
		return 'Seleccione convenio';
		if(filaIndex.formCobro=='')
		return 'Seleccione formaCobro';
		if(filaIndex.tipoCom=='')
		return 'Seleccione Tipo Comisión';	
		else
		{
			if(filaIndex.tipoCom=='P')
			{
				if(filaIndex.valor>100)
				return 'Valor Incorrecto de Porcentaje';
			}
			else
			{
				if(filaIndex.valor>filaIndex.montoMax)
					return 'Valor es Mayor a Monto Máximo';
			}
		}	
		if(filaIndex.plazos.length == 1)
		{
		 if(filaIndex.plazos[0].indexOf('esquema.')>-1)
		 return 'Seleccione plazo(s)';
		}
		if(filaIndex.montoMax<=filaIndex.montoMin)
		return 'Monto Máximo es Menor o Igual a Monto Mínimo';
		
		
		var cadenas =[];
		var cadenasCab = [];
		var fila ={};
	    var cadena = '';
	    var montos ='';
	    var plazosTodos ='';
	    var montoMin = 0;
	    var montoMax = 0;
	    var index = 0;
		var conveniosCombo = $('#convenioNominaID1 option').map(function() { return $(this).val(); }).get();
		
		//Todas las previas
		for(var i=1;i<tamanio;i++)
			{
				if($('#convenioNominaID' + i).val()==undefined)
			    continue;
				
				 fila.montoMin = Number(($('#montoMin' + i).val()+'$%').replace('%','').replace('$','').replace(',',''));
				 fila.montoMax = Number(($('#montoMax' + i).val()+'$%').replace('%','').replace('$','').replace(',',''));
				 fila.convenio = $('#convenioNominaID' + i).val();
				 fila.plazos = $('#lisPlazoID' + i).val().replace('[','').replace(']','').replace(' ','').split(',');
				 fila.plazosTodos = fila.plazos.length == totalPlazosCombo ? '0':'1';
				if(fila.convenio=='0')
				 {
					 for(var j=0;j<conveniosCombo.length;j++)
					  {
						  for(var k=0;k<fila.plazos.length;k++)
						  {
							  cadenasCab.push('C'+conveniosCombo[j]+'P'+fila.plazos[k]);
							  cadenas.push('C'+conveniosCombo[j]+'P'+fila.plazos[k]+'V'+fila.convenio+'T'+fila.plazosTodos+'%M'+fila.montoMin+'X'+fila.montoMax);				  
						  }
					  }
				 }
				 else
				 {
						  fila.plazos = $('#lisPlazoID' + i).val().replace('[','').replace(']','').replace(' ','').split(',');
						  for(var k=0;k<fila.plazos.length;k++)
						  {
							  cadenasCab.push('C'+fila.convenio+'P'+fila.plazos[k]);
							  cadenas.push('C'+fila.convenio+'P'+fila.plazos[k]+'V'+fila.convenio+'T'+fila.plazosTodos+'%M'+fila.montoMin+'X'+fila.montoMax);				  
						  }
				 }
			}
		
	  //valida nueva linea
	
		if(filaIndex.convenio=='0')
		{
			 for(var j=0;j<conveniosCombo.length;j++)
			  {
				  for(var k=0;k<filaIndex.plazos.length;k++)
				  {
					  index = cadenasCab.indexOf('C'+conveniosCombo[j]+'P'+filaIndex.plazos[k],index+1);
					  if(index>-1)
					  {
						  cadena = cadenas[index];
					      montos = cadena.split('%')[1].replace('M','').trim();
					      montoMin = Number(montos.split('X')[0].trim().replace(',',''));
					      montoMax = Number(montos.split('X')[1].trim().replace(',',''));
	                      plazosTodos= cadena.split('T')[1].split('%')[0];
						  conveniosTodos= cadena.split('V')[1].split('T')[0];
				     	  if(conveniosTodos != '0')
						  return 'Ultimo registro no valido, ya hay una configuracion por convenio individual';
						  
						  if(filaIndex.plazosTodos)
						  {
				  			 if(!(filaIndex.montoMin>montoMax || filaIndex.montoMax < montoMin))
						     return 'Ultimo registro no valido, el esquema incluye o se incluye en otro';
						  }
						  else
						  {
							if(plazosTodos=='0')
							return 'Ultimo registro no valido, ya hay una configuracion para todos los plazos';
						  }
					     if(!(filaIndex.montoMin>montoMax || filaIndex.montoMax < montoMin))
					    	 return 'Ultimo registro no valido, el esquema incluye o se incluye en otro';
					  }	  
				  }
			  }
		}
		else
		{
			  for(var k=0;k<filaIndex.plazos.length;k++)
			  {
				  index = cadenasCab.indexOf('C'+filaIndex.convenio+'P'+filaIndex.plazos[k],index+1);
				  if(index>-1)
				  {
						  cadena = cadenas[index];
					      montos = cadena.split('%')[1].replace('M','').trim();
					      montoMin = Number(montos.split('X')[0].trim().replace(',',''));
					      montoMax = Number(montos.split('X')[1].trim().replace(',',''));
	                      plazosTodos= cadena.split('T')[1].split('%')[0];
	                      conveniosTodos= cadena.split('V')[1].split('T')[0];
					  if(conveniosTodos == '0')
						return 'Ultimo registro no valido, ya hay una configuracion para todos los convenios';
					  if(filaIndex.plazosTodos)
					  {
						if(plazosTodos=='0')
						{
						  if(!(filaIndex.montoMin>montoMax || filaIndex.montoMax < montoMin))
						    return 'Ultimo registro no valido, el esquema incluye o se incluye en otro';
						}
						else
						   return 'Ultimo registro no valido, el esquema incluye o se incluye en otro';
					  }
					  else
					  {
						 if(plazosTodos=='0')
						 return 'Ultimo registro no valido, el esquema incluye o se incluye en otro';
					
						 if(!(filaIndex.montoMin>montoMax || filaIndex.montoMax < montoMin))
				    	 return 'Ultimo registro no valido, el esquema incluye o se incluye en otro';
					  }
				  }					  
			  }
		}	
		return '';
	}

	/**
	 * Función Exito
	 */
	function funcionExito(){
     //$('#contenedorEsquema').hide();
      $('#formaTablaEsquema').html("");
      $('#formaTablaEsquema').hide();
      $('#esqComApertId').val("");
      $('#producCreditoID').val("");
      $('#manejaEsqConvenioNo').attr('checked', true);
      $('#nombreInstit').val("");
      $('#institNominaID').focus();

	}

	/**
	 * Función Error
	 */
	function funcionError(){
//		funcionLimpiarEsquema();
	}
	
	function funcionExitoEsq(){
     	funcionLimpiarEsquema();
	}
	
	function funcionErrorEsq(){
//		funcionLimpiarEsquema();
	}
	
	function funcionLimpiarEsquema()
	{
		$('#esqComApertID').val('');
		$('#institNominaID').val('');
		$('#nombreInstit').val('');
		$('#producCreditoID').val('');
		$('#formaTablaEsquema').html("");
		$('#formaTablaEsquema').hide();
		$('#contenedorEsquema').hide(); 
		deshabilitaBoton('grabar', 'submit');
		$('#institNominaID').focus();
	}