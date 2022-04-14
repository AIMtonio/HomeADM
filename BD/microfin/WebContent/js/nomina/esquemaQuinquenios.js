var plazos = {};
var sucursales = {};
var quinquenios = {};
$(document).ready(function() {
	esTab = true;

	agregaFormatoControles('formaGenerica');
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

    listaPlazo();
	listaSucursales();
	listaQuiquenios();

	}); 
	/**
	 * Tipo de Transacción
	 */
	var catTipoTransaccion = {
		 'grabar'	: 1
	};

	var esquemaQuinquenios = {
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
				consultaInstitucion(this.id);
			}
		}
	});
	
	
	/**
	 * Consulta de Convenios
	 */
	$('#convenioNominaID').change(function () {
		
		if($('#institNominaID').val() != '' && $('#convenioNominaID option:selected').val() != ''
			&& $('#convenioNominaID').val() != '' && $('#convenioNominaID').val() > 0) {
			listaGridEsquemaQ();
		}else{
			 $('#contenedorEsquema').hide();
	 	      $('#formaTablaEsquema').html("");
	 	      $('#formaTablaEsquema').hide();
		} 
		
	});
	
	/**
	 * Grabar Esquemas Quinquenios
	 */
	$('#grabar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccion.grabar);
		event.preventDefault();
		if ($("#formaGenerica").valid()) {
			if(existeRepetidosEsquema()){
				mensajeSis('No pueden existir más de un esquema de quinquenios con los mismos valores');
				return;
			}

        	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','institNominaID','funcionExito','funcionError');
     

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

	/**
	 * Consulta de Institución de Nómina
	 */
	function consultaInstitucion(idControl) {
		var jqControl = eval("'#" + idControl + "'");
		var beanInstitucion = {
			'institNominaID': $('#institNominaID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if($(jqControl).val() != '' && !isNaN($(jqControl).val()) && $(jqControl).val() != 0) {
			institucionNomServicio.consulta(1, beanInstitucion, function(resultado) {
				if(resultado != null) {
					$('#nombreInstit').val(resultado.nombreInstit);
					listaConveniosNomina();
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
	function listaConveniosNomina() {
		var beanConvenio = {
			'institNominaID': $('#institNominaID').val()
		};

		conveniosNominaServicio.lista(2, beanConvenio, function(resultado) {
			dwr.util.removeAllOptions('convenioNominaID');
			if (resultado != null && resultado.length > 0) {
				dwr.util.addOptions('convenioNominaID', {'':'SELECCIONAR'});
				dwr.util.addOptions('convenioNominaID', resultado, 'convenioNominaID', 'descripcion');
				return;
			}
			dwr.util.addOptions('convenioNominaID', {'': 'NO SE ENCONTRARON CONVENIOS'});
		});
	}


	function listaGridEsquemaQ(){
        
		var inst=$('#institNominaID').val();
		var convenio=$('#convenioNominaID').val();
            
		if (inst == ''){
		 	      mensajeSis("Especifique la Empresa Nómina");
		 	      $('#institNominaID').focus();
		 	      $('#contenedorEsquema').hide();
		 	      $('#formaTablaEsquema').html("");
		 	      $('#formaTablaEsquema').hide();
                
		 	      deshabilitaBoton('grabar');
		 	    }else if(convenio == '' || convenio == 0){
		 	      mensajeSis("Especifique el Número de Convenio");
		 	      $('#contenedorEsquema').hide();
		 	      $('#formaTablaEsquema').html("");
		 	      $('#formaTablaEsquema').hide();
		 	      deshabilitaBoton('grabar');

		 	    }

		 	    else if(inst != '' && convenio != ''){
				 habilitaBoton('grabar');
		 	    var params = {};
		 		params['institNominaID'] = $('#institNominaID').val();
		 		params['convenioNominaID'] = $('#convenioNominaID option:selected').val();
		 		params['tipoLista'] = esquemaQuinquenios.principal;
			
		$.post("esquemaQuinqueniosGrid.htm",params, function(data) {
                  
				if(data.length > 0) {
					habilitaBoton('grabar');
					$('#formaTablaEsquema').html(data);
					$('#formaTablaEsquema').show();
					$('#contenedorEsquema').show();
					listaPlazo();
					listaSucursales();
				    listaQuiquenios();
					
				} else {
					mensajeSis("Error al generar la lista de esquema Quinquenios");
				  $('#contenedorEsquema').hide();
		 	      $('#formaTablaEsquema').html("");
		 	      $('#formaTablaEsquema').hide();
				}
			});
	}}

	




	function agregarNuevoRegistro(idControl){
	  var numeroFila=consultaFilas();
	  var nuevaFila = parseInt(numeroFila) + 1;

	 			 var tds =	"<tr id=\"renglon" + nuevaFila + "\" name=\"renglon\">" + "<td>" + 
	 				"<input type=\"text\" id=\"consecutivoID" + nuevaFila + "\" size=\"12\" name=\"consecutivoID\" readonly  value=\""+ nuevaFila + "\"  />" +
	 				"</td>" +
					"<td>" +
					"<select multiple id=\"sucursalID"+ nuevaFila + "\" size=\"9\"  name=\"sucursalID\"  onchange=\"seleccionarSucursales(this.id," + nuevaFila+ ");\" >" +
					"<option value=\"0\">TODOS</option>" +
					"</select>" +
					"<input type=\"hidden\" id=\"lisSucursalID" + nuevaFila + "\"  name=\"lisSucursalID\" value=\"0\"  />" +
						
					"</td>" +
					"<td>" +
						"<select multiple id=\"quinquenioID"+ nuevaFila + "\" size=\"9\" name=\"quinquenioID\" onchange=\"seleccionarQuinquenios(this.id," + nuevaFila+ ");\">" +
							"<option value=\"0\">TODOS</option>" +
						"</select>" +
						"<input type=\"hidden\" id=\"lisQuinquenioID" + nuevaFila + "\"  name=\"lisQuinquenioID\" value=\"0\" />" +
					"</td>" +
					"<td>" +
					"<select multiple id=\"plazoID"+ nuevaFila + "\" size=\"9\" name=\"plazoID\" onchange=\"selecPlazos(this.id," + nuevaFila+ ");\">" +
						"<option value=\"0\">TODOS</option>" +
					"</select>" +
					"<input type=\"hidden\" id=\"lisPlazoID" + nuevaFila + "\"  name=\"lisPlazoID\" value=\"0\"  />" +
					"</td>" +
					
					"<td>" +
					    "<input type=\"button\" id=\"eliminar" + nuevaFila + "\" value=\"\" class=\"btnElimina\" onclick=\"eliminarRegistro('renglon" + nuevaFila + "')\" />" +
						"<input type=\"button\" id=\"agrega" + nuevaFila + "\" value=\"\" class=\"btnAgrega\" onclick=\"agregarNuevoRegistro()\" />" +
					
					"</td>" +
				"</tr>";

	     
      $("#tablaGridEsquema").append(tds);
	agregaFormatoControles('formaGenerica');
	agregarSucursales('sucursalID' + nuevaFila);
	agregarPlazosDefinidos('plazoID' + nuevaFila);
	agregarQuiquenios('quinquenioID' + nuevaFila);
	seleccionarSucursales('sucursalID' + nuevaFila, nuevaFila);
	selecPlazos('plazoID' + nuevaFila, nuevaFila);
	seleccionarQuinquenios('quinquenioID' + nuevaFila, nuevaFila);

	
}

function consultaFilas(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
         
		totales++;

	});
	return totales;
}
	


function eliminarRegistro(id){
	
	$('#' + id).remove();
	
}

/*Obtener listado de las sucursales*/
function listaSucursales() {

	var sucursalBean = {
			'nombreSucurs' : ''};
	
	sucursalesServicio.lista(5,sucursalBean, function(resultado) {
	   
		sucursales = resultado;
		establecerValoresSucursales();
	});
}


function establecerValoresSucursales() {
	$('#tablaGridEsquema tr').each(function(index) {
		if (index>0) {
			agregarSucursales('sucursalID' + index);
			establecerValorSucursales(index);
		}
	});
}



function agregarSucursales(idControl) {

	dwr.util.removeAllOptions(idControl);
	if (sucursales != null && sucursales.length > 0) {
		dwr.util.addOptions(idControl, {'0' : 'TODOS'});
		dwr.util.addOptions(idControl, sucursales, 'sucursalID','nombreSucurs');
		return;
	} else {
		dwr.util.addOptions(idControl, {'' : 'NO SE ENCONTRARON SUCURSALES'});
	}
}

function establecerValorSucursales(fila){
	var valorSucursales = $("#lisSucursalID" + fila).val();
	if(valorSucursales == 0 ){
		$('#sucursalID' + fila + ' option').attr('selected', true);
		$('#sucursalID' + fila + ' option[value="0"]').attr('selected', false);
		return;
	}
     
	var listaSucursales = valorSucursales.split(',');
	for (var index=0;index< listaSucursales.length;index++) {
		var jqSucursal = eval("'#sucursalID" + fila + " option[value=" + listaSucursales[index] + "]'");
		$(jqSucursal).attr("selected", "selected");
	}
}

function obtenerOpciones(select) {
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

function seleccionarSucursales(idControl, fila) {
	var valorSucursal = $('#' + idControl).val();
	if(valorSucursal != null){
          
			var listaSucursales = valorSucursal.toString();
			if(listaSucursales.includes('0')){
                
				$('#' + idControl + ' option').attr('selected', true);
				$('#' + idControl + ' option[value="0"]').attr('selected', false);
                  valor = $('#' + idControl).val();
                  $('#lisSucursalID' + fila).val(obtenerOpciones(valor));
				  
               return;
			}
			$('#lisSucursalID' + fila).val(listaSucursales);
			return;
		}

	}

/*Fin Obtener listado de las sucursales*/

/*Obtener listado de plazos*/
function listaPlazo() {
	
var plazoBean = {};
		
	plazosCredServicio.listaCombo(3, plazoBean,function(resultado) {
		
		                   if(resultado!=null)
		                   {plazos = resultado;
							establecerValoresPlazosDefinidos();
						   }
							
				});
			
}

function establecerValoresPlazosDefinidos() {
		$('#tablaGridEsquema tr').each(function(index) {
			if (index > 0) {
				agregarPlazosDefinidos('plazoID' + index);
				establecerValoresPlazos(index);
			}
		});
	}

function agregarPlazosDefinidos(idControl) {
	dwr.util.removeAllOptions(idControl);
	if (plazos != null && plazos.length > 0) {
		dwr.util.addOptions(idControl, {'0' : 'TODOS'});
		dwr.util.addOptions(idControl, plazos, 'plazoID', 'descripcion');
		return;
	} else {
		dwr.util.addOptions(idControl, {'' : 'NO SE ENCONTRARON PLAZOS'});
	}
}


function establecerValoresPlazos(fila) {
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

function selecPlazos(idControl, fila) {
	var valorPlazos = $('#' + idControl).val();
	if(valorPlazos != null){

		var listaPlazos = valorPlazos.toString();
		 if(listaPlazos=='0'){
			$('#' + idControl + ' option').attr('selected', true);
			$('#' + idControl + ' option[value="0"]').attr('selected', false);
			 valor = $('#' + idControl).val();
              $('#lisPlazoID' + fila).val(obtenerOpciones(valor));
              return;
		}
			$('#lisPlazoID' + fila).val(listaPlazos);
			return;
		}

	}

/*Fin Obtener listado de plazos*/

/*Obtener listado de Quinquenios*/
function listaQuiquenios() {
	
   		var quinquenioBean = {
			'descripcion' : '',
			'descripcionCorta' : ''};
					
				catQuinqueniosServicio.lista(1, quinquenioBean,function(resultado) {
					
					                   if(resultado!=null)
					                   {quinquenios = resultado;
										establecerValoresQuinquenios();
									   }
										
							});
			
}

function establecerValoresQuinquenios() {
		$('#tablaGridEsquema tr').each(function(index) {
			if (index > 0) {
				agregarQuiquenios('quinquenioID' + index);
				establecerQuinquenios(index);
			}
		});
	}
function agregarQuiquenios(idControl) {
	dwr.util.removeAllOptions(idControl);
	if (quinquenios != null && quinquenios.length > 0) {
		dwr.util.addOptions(idControl, {'0' : 'TODOS'});
		dwr.util.addOptions(idControl, quinquenios, 'quinquenioID', 'descripcionCorta');
		return;
	} else {
		dwr.util.addOptions(idControl, {'' : 'NO SE ENCONTRARON QUINQUENIOS'});
	}
}


function establecerQuinquenios(fila) {
	$('#tablaGridEsquema tr').each(function(index) {
		var valoresQ = $("#lisQuinquenioID" + fila).val();
		if(valoresQ == 0 ){
			$('#quinquenioID' + fila + ' option').attr('selected', true);
			$('#quinquenioID' + fila + ' option[value="0"]').attr('selected', false);
			return;
		}

		var listaQ = valoresQ.split(',');
		for (var index=0;index< listaQ.length;index++) {
			var jqQ = eval("'#quinquenioID" + fila + " option[value=" + listaQ[index] + "]'");
			$(jqQ).attr("selected", "selected");
		}
	});
}

function seleccionarQuinquenios(idControl, fila) {
	var valorQ = $('#' + idControl).val();
	if(valorQ != null){

			var listaQ = valorQ.toString();
		 if(listaQ.includes('0')){
				$('#' + idControl + ' option').attr('selected', true);
				$('#' + idControl + ' option[value="0"]').attr('selected', false);
				 valor = $('#' + idControl).val();
                  $('#lisQuinquenioID' + fila).val(obtenerOpciones(valor));
                   return;
		}
			$('#lisQuinquenioID' + fila).val(listaQ);
			return;
		}

	}

	
	function existeRepetidosEsquema(){
	
	var tamanio = consultaFilas();
	
	for(var j= 1; j <= tamanio ; j ++){
		for(var i = 1; i <= tamanio ; i ++){
			
			if($('#renglon' + i).val() != undefined && $('#renglon' + j).val() != undefined){
				
				if( i != j &&  $('#lisSucursalID' + j).val() == $('#lisSucursalID' + i).val()
						&& $('#lisQuinquenioID' + j).val() == $('#lisQuinquenioID' + i).val()
						&& $('#lisPlazoID' + j).val() == $('#lisPlazoID' + i).val()
						){
					return true;
				}

			}
			
		}
	}
	
	return false;
}

 // Fin document

	/**
	 * Función Exito
	 */
	function funcionExito(){
     $('#contenedorEsquema').hide();
      $('#formaTablaEsquema').html("");
      $('#formaTablaEsquema').hide();
      $('#convenioNominaID').val("");

	}

	/**
	 * Función Error
	 */
	function funcionError(){

	}