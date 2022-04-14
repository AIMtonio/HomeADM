var parametroBean = consultaParametrosSession();

$(':text').focus(function() {	
 	esTab = false;
});
    
$(':text').bind('keydown',function(e){
	if (e.which == 9 && !e.shiftKey){
		esTab= true;
	}
});

$(document).ready(function() {
	/******* DEFINICION DE CONSTANTES Y NUMEROS DE CONSULTAS *******/	
	esTab = false;
	
	var catTipoTransaccion = {
		'grabar':'1',			// grabar personas relacionadas
	};

	/******* FUNCIONES CARGA AL INICIAR PANTALLA *******/	    
	inicializaPantalla();	
	llenaComboAnios(parametroBean.fechaAplicacion,10);
	$("#clienteID").focus();

    /******* VALIDACIONES DE LA FORMA *******/	
	$.validator.setDefaults({submitHandler: function(event) {
		if(validaCamposObligatoriosGrid() == true){
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','clienteID','funcionExito', 'funcionError');
		}		
	}});
	
	$('#formaGenerica').validate({
		rules: {			
			clienteID: {
				required: true
			},			
			ejercicio: {
				required: true
			}			
		},		
		messages: {	
			clienteID: {
				required: 'Especifique Aportante.'
			},
			ejercicio: {
				required: 'Especifique el Ejercicio.'
			}
		}
	});
	
	/******* MANEJO DE EVENTOS *******/	
	
	$('#clienteID').bind('keyup',function(e) { 
		lista('clienteID', '2', '8', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	$('#clienteID').blur(function() {	
		if(esTab){
			consultaCliente(this.id);
		}  		
	});

	$('#ejercicio').change(function() {		
		gridPersonasRelacionadas($('#clienteID').val(), $('#ejercicio').val());
	});
	
	$('#agregar').click(function() {		
		agregaPersonaRelacionadaGrid();
	});
	
	$('#grabar').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccion.grabar);		
	});
							
	/*******  FUNCIONES PARA VALIDACIONES DE CONTROLES *******/	 
	//CONSULTA CLIENTE
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var numCon = 1;
		setTimeout("$('#cajaLista').hide();", 200);
		
		inicializaPantalla();
		if (numCliente != '' && !isNaN(numCliente) && numCliente > 0) {				
			clienteServicio.consulta(numCon, numCliente, function(cliente) {
				if (cliente != null) {
					if(cliente.tipoPersona == 'F' || cliente.tipoPersona == 'A'){
						$('#clienteID').val(cliente.numero);
							if(cliente.tipoPersona == 'F'){
								$("#tipoPersonaFisicaCte").attr("checked", true);
							}else{
								$("#tipoPersonaFisActEmpCte").attr("checked", true);
							}
						$('#nombreCompletoCte').val(cliente.nombreCompleto);
						if(cliente.registroHacienda == 'S'){
							$("#registroHaciendaCteSi").attr("checked", true);
						}else{
							$("#registroHaciendaCteNo").attr("checked", true);
						}
						$('#nacionCte').val(cliente.nacion);
						$('#paisResidenciaCte').val(cliente.paisResidencia);
						consultaPais('paisResidenciaCte','nombrePaisResidencia');
						$('#RFCCte').val(cliente.RFC);
						$('#CURPCte').val(cliente.CURP);
						
						consultaDireccionFiscalCte('clienteID','domicilioFiscal');

						gridPersonasRelacionadas($('#clienteID').val(), $('#ejercicio').val());
						
					}else{
						$(jqCliente).val("");
						$(jqCliente).focus();
						mensajeSis('El Aportante debe ser tipo de persona Física o Física con Actividad Empresarial.');						
					}					
				} else {
					$(jqCliente).val("");
					$(jqCliente).focus();
					mensajeSis('El Aportante no Existe.');
				}
			});
		}else if(numCliente != '' || isNaN(numCliente)){
			$(jqCliente).val("");
			$(jqCliente).focus();
			mensajeSis('El Aportante no Existe.');
		}
	}
	
	// FUNCION CONSULTA PARTICIPACION CLIENTE
	function consultaParticipacionCte(idCliente, ejercicio) {
		var bean = {
			'clienteID' : idCliente,
			'ejercicio' : ejercicio
		};
		var numCon = 1;
		
		if(idCliente != '' && !isNaN(idCliente) && idCliente > 0) {
			relacionadosFiscalesServicio.consulta(numCon, bean, function(cliente) {
				if (cliente != null) {
					$('#participaFiscalCte').val(cliente.participaFiscalCte);
				}
			});
		}
	}

	//FUNCION PARA CONSULTAR LA DIRECCION FISCAL POR CLIENTE
	function consultaDireccionFiscalCte(idControl, idNombreCampoDir){
		var jqCteID = eval("'#" + idControl + "'");
		var jqNombreCampoDir = eval("'#" + idNombreCampoDir + "'");
		var numCte = $(jqCteID).val();
		var numCon = 10;
		var direccionesClienteF ={
			'clienteID' : $(jqCteID).val()
		};
			
		if(numCte != '' && !isNaN(numCte) && numCte > 0) {
			direccionesClienteServicio.consulta(numCon,direccionesClienteF,function(direccion) {
				if(direccion!=null){
					$(jqNombreCampoDir).val(direccion.direccionCompleta);	
				}
			});
		}
	}
	
	//FUNCIÓN CONSULTA LAS PERSONAS RELACIONADAS
	function gridPersonasRelacionadas(idCliente, ejercicio){
		if(idCliente > 0 && ejercicio > 0){
			bloquearPantallaCarga();
			
			var params = {};
			params['tipoLista'] = 1;
			params['clienteID'] = idCliente;
			params['ejercicio'] = ejercicio;
			
			var newArray = new Array();
			for (var i = 1; i <= 2; i++){
				var bean = {};
				bean['clienteID'] = i;
				bean['ejercicio'] = 2023;
				newArray.push(bean);
			}
								
			$.post("relacionadosFiscalesGridVista.htm", params, function(data){
				if(data.length >0) {	
					$('#divGridPersonasRelacionadas').html(data);
					consultaParticipacionCte(idCliente,ejercicio);
					agregaFormatoControles('formaGenerica');
				}
				
				var numRelacionados = consultaFilas();
				if(numRelacionados <= 0){
					$('#participaFiscalCte').val('100.00');
					mensajeSisRetro({
						mensajeAlert : 'No se tienen registrados Relacionados Fiscales para el Aportante y año seleccionado, ¿desea registrarlos?',
						muestraBtnAceptar: true,
						muestraBtnCancela: true,
						txtAceptar : 'Aceptar',
						txtCancelar : 'Cancelar',
						funcionAceptar : function(){
							$('#divPersonasRelacionadas').show();
							deshabilitaBoton('grabar','submit');
						},
						funcionCancelar : function(){
							$('#divPersonasRelacionadas').hide();
						}
					});
				}else{
					$('#divPersonasRelacionadas').show();
					habilitaBoton('grabar','submit');
					consultaCamposGrid();
				}			
													
				$('#contenedorForma').unblock(); // desbloquear			
			});				
		}		
	}

	//FUNCION LLENA COMBO DE ANIOS PARA EL EJERCICIO
	function llenaComboAnios(fechaActual, numRango){
	   var anioActual = fechaActual.substring(0, 4);
	   var anioMax = parseInt(anioActual) + parseInt(numRango);
	   var numOpciones = parseInt(numRango) * 2;
	  
	   for(var i=0; i < numOpciones; i++){
		   $('#ejercicio').append('<option value="'+anioMax+'">'+anioMax+'</option>');
		   anioMax = parseInt(anioMax) - 1;
	   }
	   $("#ejercicio").val(anioActual);
	}
	
}); // FIN $(DOCUMENT).READY()

//FUNCION INICIALIZA PANTALLA
function inicializaPantalla(){
	inicializaForma('formaGenerica','clienteID');
	agregaFormatoControles('formaGenerica');
	$('#divGridPersonasRelacionadas').html("");
	$('#divPersonasRelacionadas').hide();
	deshabilitaBoton('grabar','submit');	
}

//AGREGA NUEVA PERSONA RELACIONADA
function agregaPersonaRelacionadaGrid(){
	var nuevaFila = parseInt(consultaMaxID()) + 1;
	var nuevaFilaIndex = nuevaFila+5;
	var tds ='';
	tds +=	'<tr id="renglon'+nuevaFila+'" name="renglons">';
	tds +=		'<td>';
	tds +=			'<fieldset class="ui-widget ui-widget-content ui-corner-all">';
	tds +=				'<table id="tablaPersona'+nuevaFila+'">';
	tds +=	'<tr>';
	tds +=	'<td class="label" nowrap="nowrap">	';
	tds +=	'	<label for="cteRelacionadoID'+nuevaFila+'">Aportante:</label>';
	tds +=	'</td>';
	tds +=	'<td nowrap="nowrap">';
	tds +=	'   <input type="text" id="cteRelacionadoID'+nuevaFila+'" name="lisCteRelacionadoID" size="12" tabindex="'+nuevaFilaIndex+'" maxlength="20" autocomplete="off" onkeypress="listaClientesGrid(this.id);" onblur="consultaClienteGrid(this.id)" />';
	tds +=	'</td>';
	tds +=	'<td class="separador"/>';
	tds +=	'<td class="label" nowrap="nowrap">';
	tds +=	'	<label for="tipoPersona'+nuevaFila+'">Tipo de Persona:</label>	';
	tds +=	'</td>';
	tds +=	'<td nowrap="nowrap">';
	tds +=	'	<input type="radio" id="tipoPersonaFisica'+nuevaFila+'" name="tipoPersona'+nuevaFila+'" value="F" tabindex="'+nuevaFilaIndex+'" checked="checked" onclick="cambiaTipoPersona('+nuevaFilaIndex+',"F")"/>';
	tds +=	' 	<label>Física</label>	';
	tds +=	' 	<input type="radio" id="tipoPersonaFisActEmp'+nuevaFila+'" name="tipoPersona'+nuevaFila+'" value="A" tabindex="'+nuevaFilaIndex+'" onclick="cambiaTipoPersona('+nuevaFilaIndex+',"A")"/>';
	tds +=	' 	<label>Física Act. Emp.</label>	';
	tds +=	' 	<input type="hidden" id="tipoPersonaValor'+nuevaFila+'" name="lisTipoPersona" value="F" >';
	tds +=	'</td>';
	tds +=	'</tr>';
	tds +=	'<tr>';
	tds +=	'<td class="label" nowrap="nowrap">';
	tds +=	'	<label for="primerNombre'+nuevaFila+'">Primer Nombre:</label>';
	tds +=	'</td>';
	tds +=	'<td>';
	tds +=	'	<input type="text" id="primerNombre'+nuevaFila+'" name="lisPrimerNombre" tabindex="'+nuevaFilaIndex+'" onBlur="ponerMayusculas(this)" maxlength="50" />	';
	tds +=	'</td>  	';
	tds +=	'<td class="separador"></td>	';
	tds +=	'<td class="label">	';
	tds +=	'	<label for="segundoNombre'+nuevaFila+'">Segundo Nombre:</label>	';
	tds +=	'</td>	';
	tds +=	'<td >	';
	tds +=	'	<input type="text" id="segundoNombre'+nuevaFila+'" name="lisSegundoNombre" tabindex="'+nuevaFilaIndex+'" onBlur="ponerMayusculas(this)" maxlength="50" />	';
	tds +=	'</td>	';
	tds +=	'</tr>	';
	tds +=	'<tr>	';
	tds +=	'<td class="label">	';
	tds +=	'	<label for="tercerNombre'+nuevaFila+'">Tercer Nombre:</label>	';
	tds +=	'</td>	';
	tds +=	'<td>	';
	tds +=	'	<input type="text" id="tercerNombre'+nuevaFila+'" name="lisTercerNombre" tabindex="'+nuevaFilaIndex+'" onBlur="ponerMayusculas(this)" maxlength="50" />	';
	tds +=	'</td>    	';
	tds +=	'<td class="separador"></td>	';
	tds +=	'<td class="label">	';
	tds +=	'	<label for="apellidoPaterno'+nuevaFila+'">Apellido Paterno:</label>	';
	tds +=	'</td>	';
	tds +=	'<td>	';
	tds +=	'	<input type="text" id="apellidoPaterno'+nuevaFila+'" name="lisApellidoPaterno" tabindex="'+nuevaFilaIndex+'" onBlur="ponerMayusculas(this)" maxlength="50" />	';
	tds +=	'</td>  	';
	tds +=	'</tr>	';
	tds +=	'<tr>	';
	tds +=	'<td class="label">	';
	tds +=	'	<label for="apellidoMaterno'+nuevaFila+'">Apellido Materno:</label>	';
	tds +=	'</td>	';
	tds +=	'<td>	';
	tds +=	'	<input type="text" id="apellidoMaterno'+nuevaFila+'" name="lisApellidoMaterno" tabindex="'+nuevaFilaIndex+'" onBlur="ponerMayusculas(this)" maxlength="50" />	';
	tds +=	'</td>	';
	tds +=	'<td class="separador"></td>	';
	tds +=	'<td class="label" nowrap="nowrap">	';
	tds +=	'	<label for="registroHacienda'+nuevaFila+'">Registro de Alta en Hacienda: </label> 	';
	tds +=	'</td>	';
	tds +=	'<td class="label" nowrap="nowrap"> 	';
	tds +=	' 	<input type="radio" id="registroHaciendaSi'+nuevaFila+'" name="registroHacienda'+nuevaFila+'" value="S" tabindex="'+nuevaFilaIndex+'" checked="checked" onclick="cambiaRegistroHacienda('+nuevaFilaIndex+',"S")" />';
	tds +=	' 	<label for="si">Si</label>	';
	tds +=	' 	<input type="radio" id="registroHaciendaNo'+nuevaFila+'" name="registroHacienda'+nuevaFila+'" value="N" tabindex="'+nuevaFilaIndex+'"  onclick="cambiaRegistroHacienda('+nuevaFilaIndex+',"N")" />';
	tds +=	' 	<label for="no">No</label>  	';
	tds +=	'	<input type="hidden" id="registroHaciendaValor'+nuevaFila+'" name="lisRegistroHacienda" value="S" />';
	tds +=	'</td>';
	tds +=	'</tr>';
	tds +=	'<tr>';
	tds +=	'<td class="label">';
	tds +=	'	<label for="nacion'+nuevaFila+'">Nacionalidad:</label>';
	tds +=	'</td>';
	tds +=	'<td>';
	tds +=	'	<select id="nacion'+nuevaFila+'" name="lisNacion" tabindex="'+nuevaFilaIndex+'" onchange="limpiarMostrarOcultarCamposExtranjero('+nuevaFila+')" >';
	tds +=	'  		<option value="">SELECCIONAR</option>';
	tds +=	'  		<option value="N" >MEXICANA</option>';
	tds +=	'		<option value="E" >EXTRANJERA</option>';
	tds +=	'	</select>';
	tds +=	'</td>';
	tds +=	'<td class="separador"></td>';
	tds +=	'<td class="label">';
	tds +=	'	<label for="paisResidencia'+nuevaFila+'">Pa&iacute;s de Residencia:</label>	';
	tds +=	'</td>	';
	tds +=	'<td>	';
	tds +=	' 	<input type="text" id="paisResidencia'+nuevaFila+'" name="lisPaisResidencia" size="6" tabindex="'+nuevaFilaIndex+'" maxlength="9" onkeypress="listaPaisesGrid(this.id);" onblur="consultaPais(this.id,\'paisR'+nuevaFila+'\')"  />';
	tds +=	'	<input type="text" id="paisR'+nuevaFila+'" name="paisR" size="35" tabindex="'+nuevaFilaIndex+'" disabled="true" readOnly="true" />	';
	tds +=	'</td>	';
	tds +=	'</tr>	';
	tds +=	'<tr> 	';
	tds +=	'<td class="label">	';
	tds +=	'	<label for="RFC'+nuevaFila+'"> RFC:</label>	';
	tds +=	'</td>	';
	tds +=	'<td>	';
	tds +=	'	<input type="text" id="RFC'+nuevaFila+'" name="lisRFC" maxlength="13" tabindex="'+nuevaFilaIndex+'" onBlur="ponerMayusculas(this)" autocomplete="off" />	';
	tds +=	'</td>	';
	tds +=	'<td class="separador"></td>	';
	tds +=	'<td class="label">	';
	tds +=	'	<label for="CURP'+nuevaFila+'">CURP:</label>	';
	tds +=	'</td>	';
	tds +=	'<td>	';
	tds +=	'	<input type="text" id="CURP'+nuevaFila+'" name="lisCURP" tabindex="'+nuevaFilaIndex+'" size="25" onBlur="ponerMayusculas(this)" maxlength="18" autocomplete="off" />	';
	tds +=	'</td>	';
	tds +=	'</tr>	';
	tds +=	'<tr>	';
	tds +=	'<td class="label" >	';
	tds +=	'	<label>Domicilio Fiscal:</label>	';
	tds +=	'</td>	';
	tds +=	'<td></td> 	';
	tds +=	'<td class="separador"></td> 	';
	tds +=	'<td class="tdDomicilioFiscal'+nuevaFila+'" nowrap="nowrap"> 	';
	tds +=	'	<label for="estadoID'+nuevaFila+'">Entidad Federativa:</label> 	';
	tds +=	'</td> 	';
	tds +=	'<td nowrap="nowrap" class="tdDomicilioFiscal'+nuevaFila+'">';
	tds +=	' 	<input type="text" id="estadoID'+nuevaFila+'" name="lisEstadoID" size="6" tabindex="'+nuevaFilaIndex+'" autocomplete="off" onkeypress="listaEstado(this.id);" onblur="consultaEstado(this.id),consultaDirecCompleta('+nuevaFila+')" />';
	tds +=	'	<input type="text" id="nombreEstado'+nuevaFila+'" name="nombreEstado" size="35" disabled ="true" readonly="true"/>   	';
	tds +=	'</td>';
	tds +=	'</tr>';
	tds +=	'<tr class="trDomicilioFiscal'+nuevaFila+'">';
	tds +=	'<td class="label"> 	';
	tds +=	'   <label for="municipioID'+nuevaFila+'">Municipio: </label> 	';
	tds +=	'</td> 	';
	tds +=	'<td nowrap="nowrap"> 	';
	tds +=	'   <input type="text" id="municipioID'+nuevaFila+'" name="lisMunicipioID" size="6" tabindex="'+nuevaFilaIndex+'" autocomplete="off" onkeypress="listaMunicipio(this.id);" onblur="consultaMunicipio(this.id),consultaDirecCompleta('+nuevaFila+')" />';
	tds +=	'	<input type="text" id="nombreMuni'+nuevaFila+'" name="nombreMuni" size="35" disabled="true" readonly="true"/>   	';
	tds +=	'</td> 	';
	tds +=	'<td class="separador"></td> 	';
	tds +=	'<td class="label"> 	';
	tds +=	'	<label for="localidadID'+nuevaFila+'">Localidad: </label> 	';
	tds +=	'</td> 	';
	tds +=	'<td nowrap="nowrap"> 	';
	tds +=	'   <input type="text" id="localidadID'+nuevaFila+'" name="lisLocalidadID" size="6" tabindex="'+nuevaFilaIndex+'"  autocomplete="off" onkeypress="listaLocalidad(this.id);" onblur="consultaLocalidad(this.id),consultaDirecCompleta('+nuevaFila+')" />';
	tds +=	'	<input type="text" id="nombreLocalidad'+nuevaFila+'" name="nombreLocalidad" size="35" disabled="true" readonly="true"/>   	';
	tds +=	'</td>  	';
	tds +=	'</tr> 	';
	tds +=	'<tr class="trDomicilioFiscal'+nuevaFila+'">	';
	tds +=	'<td class="label"> 	';
	tds +=	'	<label for="coloniaID'+nuevaFila+'">Colonia: </label> 	';
	tds +=	'</td> 	';
	tds +=	'<td nowrap="nowrap"> 	';
	tds +=	'	<input type="text" id="coloniaID'+nuevaFila+'" name="lisColoniaID" size="6" tabindex="'+nuevaFilaIndex+'" autocomplete="off" onkeypress="listaColonia(this.id);" onblur="consultaColonia(this.id),consultaDirecCompleta('+nuevaFila+')" />';
	tds +=	'	<input type="text" id="nombreColonia'+nuevaFila+'" name="nombreColonia" size="35" disabled="true" readonly="true"/>   	';
	tds +=	'</td> 	';
	tds +=	'<td class="separador"></td>	';
	tds +=	'<td class="label"> 	';
	tds +=	'	<label for="nombreCiudad'+nuevaFila+'">Ciudad: </label> 	';
	tds +=	'</td> 	';
	tds +=	'<td nowrap="nowrap">	';
	tds +=	'	<input type="text" id="nombreCiudad'+nuevaFila+'" name="lisNombreCiudad" size="42"  disabled="true" readonly="true"/>	';
	tds +=	'</td>	';
	tds +=	'</tr>	';
	tds +=	'<tr class="trDomicilioFiscal'+nuevaFila+'"> 	';
	tds +=	'<td class="label"> 	';
	tds +=	'	<label for="calle'+nuevaFila+'">Calle: </label> 	';
	tds +=	'</td> 	';
	tds +=	'<td nowrap="nowrap"> 	';
	tds +=	'	<input type="text" id="calle'+nuevaFila+'" name="lisCalle" size="42" tabindex="'+nuevaFilaIndex+'" onBlur="ponerMayusculas(this),consultaDirecCompleta('+nuevaFila+')" maxlength = "50" /> 	';
	tds +=	'</td> 	';
	tds +=	'<td class="separador"></td>	';
	tds +=	'<td class="label"> 	';
	tds +=	'	<label for="numeroCasa">N&uacute;mero: </label> 	';
	tds +=	'</td>';
	tds +=	'<td nowrap="nowrap"> 	';
	tds +=	'	<input type="text" id="numeroCasa'+nuevaFila+'" name="lisNumeroCasa" size="5" tabindex="'+nuevaFilaIndex+'" onBlur="ponerMayusculas(this),consultaDirecCompleta('+nuevaFila+')" />	';
	tds +=	'   <label for="exterior">Interior: </label>	';
	tds +=	'   <input type="text" id="numInterior'+nuevaFila+'" name="lisNumInterior" size="5" tabindex="'+nuevaFilaIndex+'" onBlur="ponerMayusculas(this),consultaDirecCompleta('+nuevaFila+')" />	';
	tds +=	'   <label for="exterior">Piso: </label>	';
	tds +=	'   <input type="text" id="piso'+nuevaFila+'" name="lisPiso" size="5" tabindex="'+nuevaFilaIndex+'" onBlur="ponerMayusculas(this),consultaDirecCompleta('+nuevaFila+')" />	';
	tds +=	'</td> 	';
	tds +=	'</tr> 	';
	tds +=	'<tr class="trDomicilioFiscal'+nuevaFila+'"> 	';
	tds +=	'<td class="label"> 	';
	tds +=	'	<label for="CP'+nuevaFila+'">C&oacute;digo Postal:</label> 	';
	tds +=	'</td> 	';
	tds +=	'<td nowrap="nowrap"> 	';
	tds +=	'	<input type="text" id="CP'+nuevaFila+'" name="lisCP" size="15" maxlength="5" tabindex="'+nuevaFilaIndex+'"  onBlur="consultaDirecCompleta('+nuevaFila+')" />';
	tds +=	'</td>	';
	tds +=	'<td class="separador"></td>	';
	tds +=	'</tr>	';
	tds +=	'<tr class="trDomicilioFiscal'+nuevaFila+'"> 	';
	tds +=	'<td class="label"> 	';
	tds +=	'	<label for="lote'+nuevaFila+'">Lote: </label> 	';
	tds +=	'</td> 	';
	tds +=	'<td nowrap="nowrap"> 	';
	tds +=	'	<input type="text" id="lote'+nuevaFila+'" name="lisLote" size="20" tabindex="'+nuevaFilaIndex+'" onBlur="ponerMayusculas(this),consultaDirecCompleta('+nuevaFila+')" /> 	';
	tds +=	'</td> 	';
	tds +=	'<td class="separador"></td> 	';
	tds +=	'<td class="label"> 	';
	tds +=	'	<label for="manzana'+nuevaFila+'">Manzana: </label> 	';
	tds +=	'</td> 	';
	tds +=	'<td nowrap="nowrap"> 	';
	tds +=	'	<input type="text" id="manzana'+nuevaFila+'" name="lisManzana" size="20" tabindex="'+nuevaFilaIndex+'"  onBlur="ponerMayusculas(this),consultaDirecCompleta('+nuevaFila+')" /> 	';
	tds +=	'</td> 	';
	tds +=	'</tr>	';
	tds +=	'<tr>	';
	tds +=	'<td class="label"> 	';
	tds +=	'   <label for="direccionCompleta'+nuevaFila+'">Dirección Completa: </label> 	';
	tds +=	'</td> 	';
	tds +=	'<td nowrap="nowrap">	';
	tds +=	'	<textarea id="direccionCompleta'+nuevaFila+'" name="lisDireccionCompleta" cols="50" rows="6" tabindex="'+nuevaFilaIndex+'"	';
	tds +=	'	readonly="true"  onBlur=" ponerMayusculas(this)" maxlength="500"></textarea>	';
	tds +=	'</td>	';
	tds +=	'<td class="separador"></td> 	';
	tds +=	'<td class="label" nowrap="nowrap">	';
	tds +=	'	<label for="participaFiscal'+nuevaFila+'">Participación Fiscal:</label>	';
	tds +=	'</td>  	';
	tds +=	'<td nowrap="nowrap">	';
	tds +=	'	<input type="text" id="participacionFiscal'+nuevaFila+'" name="lisParticipacionFiscal" size="15" tabindex="'+nuevaFilaIndex+'" autocomplete="off"  maxlength="10" onblur="validaParticipacionFiscal(this.id)" esMoneda="true" style="text-align:right;" /><label>%</label>             	';
	tds +=	'</td>';
	tds +=	'</tr>';
	tds +=	'<tr>';
	tds +=	'<td nowrap="nowrap" colspan="5" align="right">';
	tds +=	' 	<input type="button" name="eliminar" id="eliminar'+nuevaFila+'" tabindex="'+nuevaFilaIndex+'" value="" class="btnElimina" onclick="eliminaFilaComprobante(this.id)" />';
	tds +=	'	<input type="button" name="agregar" id="agregar'+nuevaFila+'" tabindex="'+nuevaFilaIndex+'" value="" class="btnAgrega" onclick="agregaPersonaRelacionadaGrid()" />';
	tds +=	'</td>';
	tds +=	'</tr>';

	tds +=				'</table>';
	tds +=			'</fieldset>';
	tds +=		'</td>';
	tds +=	'</tr>';

	$("#miTabla").append(tds);
	agregaFormatoControles('formaGenerica');
	// agrega formato moneda
	$('#formaGenerica').find('input[esMoneda="true"]').each(function(){	    	
		var jControl = eval("'#" + this.id + "'"); 
			
		$(jControl).formatCurrency({
			positiveFormat: '%n',  
			negativeFormat: '%n',
			roundToDecimalPlace: 2	
		});			
	});
	$("#cteRelacionadoID"+nuevaFila).focus();
	habilitaBoton('grabar','submit');
}

//FUNCION ELIMINA COMPROBANTE
function eliminaFilaComprobante(idControl){
	var numeroID = idControl.substr(8,idControl.length);
	var jqRenglon = eval("'#renglon" + numeroID + "'");
	
	$(jqRenglon).remove();
	calculaParticipacionFiscalCte();
	var numFilas = consultaFilas();
	if(numFilas > 0){
		habilitaBoton('grabar','submit');
	}else{
		deshabilitaBoton('grabar','submit');
	}
}

//FUNCION CONSULTA EL NUMERO DE FILAS
function consultaFilas(){
	var totales=0;
	$('tr[name=renglons]').each(function() {
		totales++;
		
	});
	return totales;
}

//FUNCION CONSULTA EL MAXIMO ID
function consultaMaxID(){
	var idMax = 0;
	$('tr[name=renglons]').each(function() {
		var numeroID = this.id.substr(7,this.id.length);
		if(parseInt(numeroID) > parseInt(idMax)){
			idMax = parseInt(numeroID);
		}		
	});
	return idMax;
}

//FUNCION CONSULTA CAMPOS GRID
function consultaCamposGrid(){
	$('tr[name=renglons]').each(function() {
		var numeroID = this.id.substr(7,this.id.length);
		var jqClienteID = eval("'#cteRelacionadoID" + numeroID + "'");
		var jqPais = eval("'paisResidencia" + numeroID + "'");
		var jqPaisR = eval("'paisR" + numeroID + "'");
		var jqEstadoID = eval("'estadoID" + numeroID + "'");
		var jqMunicipioID = eval("'municipioID" + numeroID + "'");
		var jqLocalidadID = eval("'localidadID" + numeroID + "'");
		var jqColoniaID = eval("'coloniaID" + numeroID + "'");
		
		consultaPais(jqPais,jqPaisR);
		consultaEstado(jqEstadoID);
		consultaMunicipio(jqMunicipioID);
		consultaLocalidad(jqLocalidadID);
		consultaColonia(jqColoniaID);
		
		if($(jqClienteID).val() > 0 && $(jqClienteID).val() != ''){
			desHabilitaCamposPersonaGrid(numeroID);
		}else{
			habilitaCamposPersonaGrid(numeroID);
		}
		
		mostrarOcultarCamposExtranjero(numeroID);
		
	});
}

//FUNCION QUE BLOQUEA LA PANTALLA MIENTRAS SE CARGAN LOS DATOS
function bloquearPantallaCarga() {
	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');
	$('#contenedorForma').block({
		message : $('#mensaje'),
		css : {
			border : 'none',
			background : 'none'
		}
	});
}

// FUNCION PARA MOSTRAR LA LISTA DE CLIENTES EN EL GRID
function listaClientesGrid(idControl){
	lista(idControl, '2', '8', 'nombreCompleto', $('#'+idControl).val(), 'listaCliente.htm');
}

//CONSULTA CLIENTE DEL GRID
function consultaClienteGrid(idControl) {
	var jqCliente = eval("'#" + idControl + "'");
	var numeroID = idControl.substr(16,idControl.length);
	var numCliente = $(jqCliente).val();
	var numCon = 1;
	setTimeout("$('#cajaLista').hide();", 200);
	limpiaCamposPersonaGrid(numeroID);
	calculaParticipacionFiscalCte();
	habilitaCamposPersonaGrid(numeroID);
	
	if(numCliente == $('#clienteID').val()){
		$(jqCliente).val("");
		$(jqCliente).focus();
		mensajeSis('El Aportante no se puede Relacionar a el mismo.');			
	}else if (numCliente != '' && !isNaN(numCliente) && numCliente > 0) {	
		//valida que no este relacionado ya el cliente
		var existe = false;
		$('tr[name=renglons]').each(function() {
			var numeroIDotro = this.id.substr(7,this.id.length);
			var jqClienteIDotro = eval("'#cteRelacionadoID" + numeroIDotro + "'");
			
			if(parseInt(numeroID) != parseInt(numeroIDotro)){
				if(parseInt($(jqCliente).asNumber(	)) == parseInt($(jqClienteIDotro).asNumber())){
					existe = true;
				}
			}
		});
		if(existe == true){
			$(jqCliente).val("");
			$(jqCliente).focus();
			mensajeSis('El Aportante ya está Relacionado.');				
		}else{
			clienteServicio.consulta(numCon, numCliente, function(cliente) {
				if (cliente != null) {
					if(cliente.tipoPersona == 'F' || cliente.tipoPersona == 'A'){
						$(jqCliente).val(cliente.numero);
						if(cliente.tipoPersona == 'F'){
							$("#tipoPersonaFisica"+numeroID).attr("checked", true);
							$("#tipoPersonaValor"+numeroID).val("F");
						}else{
							$("#tipoPersonaFisActEmp"+numeroID).attr("checked", true);
							$("#tipoPersonaValor"+numeroID).val("A");
						}
						$('#primerNombre'+numeroID).val(cliente.primerNombre);
						$('#segundoNombre'+numeroID).val(cliente.segundoNombre);
						$('#tercerNombre'+numeroID).val(cliente.tercerNombre);
						$('#apellidoPaterno'+numeroID).val(cliente.apellidoPaterno);
						$('#apellidoMaterno'+numeroID).val(cliente.apellidoMaterno);					
						if(cliente.registroHacienda == 'S'){
							$("#registroHaciendaSi"+numeroID).attr("checked", true);
							$("#registroHaciendaValor"+numeroID).val("S");
						}else{
							$("#registroHaciendaNo"+numeroID).attr("checked", true);
							$("#registroHaciendaValor"+numeroID).val("N");
						}
						$('#nacion'+numeroID).val(cliente.nacion);
						limpiarMostrarOcultarCamposExtranjero(numeroID);
						$('#paisResidencia'+numeroID).val(cliente.paisResidencia);
						consultaPais('paisResidencia'+numeroID,'paisR'+numeroID);
						$('#RFC'+numeroID).val(cliente.RFC);
						$('#CURP'+numeroID).val(cliente.CURP);
						
						consultaDireccionFiscalCteGrid(idControl,'direccionCompleta'+numeroID);
						desHabilitaCamposPersonaGrid(numeroID);
					}else{
						$(jqCliente).val("");
						$(jqCliente).focus();
						mensajeSis('El Aportante debe ser tipo de persona Física o Física con Actividad Empresarial.');						
					}					
				} else {
					$(jqCliente).val("");
					$(jqCliente).focus();
					mensajeSis('El Aportante no Existe.');
				}
			});			
		}		
	}
}

//FUNCION PARA MOSTRAR LA LISTA DE PAISES EN EL GRID
function listaPaisesGrid(idControl){
	lista(idControl, '1', '1', 'nombre', $('#'+idControl).val(),'listaPaises.htm');
}

//FUNCION CONSULTA EL PAIS
function consultaPais(idControl, idNombre) {
	var jqPais = eval("'#" + idControl + "'");
	var jqNombrePais = eval("'#" + idNombre + "'");
	var numPais = $(jqPais).val();
	var conPais = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	
	if(numPais != '' && !isNaN(numPais) && numPais > 0) {
		paisesServicio.consultaPaises(conPais, numPais, function(pais) {
			if (pais != null) {
				$(jqNombrePais).val(pais.nombre);
			} else {
				$(jqPais).val('');
				$(jqNombrePais).val('');
				$(jqPais).focus();
				mensajeSis("No Existe el País");
			}
		});
	}else if(numPais != '' && isNaN(numPais)){
		$(jqNombrePais).val('');
	}
}

//FUNCION PARA CONSULTAR LA DIRECCION FISCAL POR CLIENTE
function consultaDireccionFiscalCteGrid(idControl, idNombreCampoDir){
	var jqCteID = eval("'#" + idControl + "'");
	var jqNombreCampoDir = eval("'#" + idNombreCampoDir + "'");
	var numeroID = idControl.substr(16,idControl.length);
	var numCte = $(jqCteID).val();
	var numCon = 10;
	var direccionesClienteF ={
		'clienteID' : $(jqCteID).val()
	};
		
	if(numCte != '' && !isNaN(numCte) && numCte > 0) {
		direccionesClienteServicio.consulta(numCon,direccionesClienteF,function(direccion) {
			if(direccion!=null){
				$(jqNombreCampoDir).val(direccion.direccionCompleta);	
				//Si tiene direccion fiscal se consulta mas informacion de la direccion
				var numConDos = 1;
				var direccionesClienteFis ={
					'clienteID' : $(jqCteID).val(),
					'direccionID': direccion.direccionID
				};
				direccionesClienteServicio.consulta(numConDos,direccionesClienteFis,function(direccionDatos) {
					if(direccionDatos!=null){
						$('#estadoID'+numeroID).val(direccionDatos.estadoID);
						consultaEstado('estadoID'+numeroID);
						$('#municipioID'+numeroID).val(direccionDatos.municipioID);	
						consultaMunicipio('municipioID'+numeroID);
						$('#localidadID'+numeroID).val(direccionDatos.localidadID);
						consultaLocalidad('localidadID'+numeroID);
						$('#coloniaID'+numeroID).val(direccionDatos.coloniaID);
						consultaColonia('coloniaID'+numeroID);
						$('#calle'+numeroID).val(direccionDatos.calle);	
						$('#numeroCasa'+numeroID).val(direccionDatos.numeroCasa);	
						$('#numInterior'+numeroID).val(direccionDatos.numInterior);	
						$('#piso'+numeroID).val(direccionDatos.piso);	
						$('#CP'+numeroID).val(direccionDatos.CP);	
						$('#lote'+numeroID).val(direccionDatos.lote);	
						$('#manzana'+numeroID).val(direccionDatos.manzana);	
						
						
						
						
					}
				});
			}
		});
	}
}

// FUNCION PARA LIMPIAR CAMPOS GRID PERSONA
function limpiaCamposPersonaGrid(numeroID){
	$("#tipoPersonaFisica"+numeroID).attr("checked", true);
	$("#tipoPersonaFisActEmp"+numeroID).attr("checked", false);
	$("#tipoPersonaValor"+numeroID).val("F");
	$('#primerNombre'+numeroID).val('');
	$('#segundoNombre'+numeroID).val('');
	$('#tercerNombre'+numeroID).val('');
	$('#apellidoPaterno'+numeroID).val('');
	$('#apellidoMaterno'+numeroID).val('');					
	$("#registroHaciendaSi"+numeroID).attr("checked", true);
	$("#registroHaciendaNo"+numeroID).attr("checked", false);
	$("#registroHaciendaValor"+numeroID).val("S");	
	$('#nacion'+numeroID).val('');
	limpiarMostrarOcultarCamposExtranjero(numeroID);
	$('#paisResidencia'+numeroID).val('');
	$('#paisR'+numeroID).val('');
	$('#RFC'+numeroID).val('');
	$('#CURP'+numeroID).val('');
	
	$('#estadoID'+numeroID).val('');
	$('#nombreEstado'+numeroID).val('');
	$('#municipioID'+numeroID).val('');	
	$('#nombreMuni'+numeroID).val('');	
	$('#localidadID'+numeroID).val('');	
	$('#nombreLocalidad'+numeroID).val('');	
	$('#coloniaID'+numeroID).val('');	
	$('#nombreColonia'+numeroID).val('');	
	$('#nombreCiudad'+numeroID).val('');	
	$('#calle'+numeroID).val('');	
	$('#numeroCasa'+numeroID).val('');	
	$('#numInterior'+numeroID).val('');	
	$('#piso'+numeroID).val('');	
	$('#CP'+numeroID).val('');	
	$('#lote'+numeroID).val('');	
	$('#manzana'+numeroID).val('');		
	$('#direccionCompleta'+numeroID).val('');		

	$('#participacionFiscal'+numeroID).val('');		
}

//FUNCION PARA DESHABILITAR CAMPOS PERSONA RELACIONADA
function desHabilitaCamposPersonaGrid(numeroID){
	deshabilitaControl('tipoPersonaFisica'+numeroID);
	deshabilitaControl('tipoPersonaFisActEmp'+numeroID);
	deshabilitaControl('primerNombre'+numeroID);
	deshabilitaControl('segundoNombre'+numeroID);
	deshabilitaControl('tercerNombre'+numeroID);
	deshabilitaControl('apellidoPaterno'+numeroID);
	deshabilitaControl('apellidoMaterno'+numeroID);
	deshabilitaControl('registroHaciendaSi'+numeroID);
	deshabilitaControl('registroHaciendaNo'+numeroID);
	deshabilitaControl('nacion'+numeroID);
	deshabilitaControl('paisResidencia'+numeroID);
	deshabilitaControl('RFC'+numeroID);
	deshabilitaControl('CURP'+numeroID);
	deshabilitaControl('estadoID'+numeroID);
	deshabilitaControl('municipioID'+numeroID);
	deshabilitaControl('localidadID'+numeroID);
	deshabilitaControl('coloniaID'+numeroID);
	deshabilitaControl('calle'+numeroID);
	deshabilitaControl('numeroCasa'+numeroID);
	deshabilitaControl('numInterior'+numeroID);
	deshabilitaControl('piso'+numeroID);
	deshabilitaControl('CP'+numeroID);
	deshabilitaControl('lote'+numeroID);
	deshabilitaControl('manzana'+numeroID);	
}


//FUNCION PARA HABILITAR CAMPOS PERSONA RELACIONADA
function habilitaCamposPersonaGrid(numeroID){
	habilitaControl('tipoPersonaFisica'+numeroID);
	habilitaControl('tipoPersonaFisActEmp'+numeroID);
	habilitaControl('primerNombre'+numeroID);
	habilitaControl('segundoNombre'+numeroID);
	habilitaControl('tercerNombre'+numeroID);
	habilitaControl('apellidoPaterno'+numeroID);
	habilitaControl('apellidoMaterno'+numeroID);
	habilitaControl('registroHaciendaSi'+numeroID);
	habilitaControl('registroHaciendaNo'+numeroID);
	habilitaControl('nacion'+numeroID);
	habilitaControl('paisResidencia'+numeroID);
	habilitaControl('RFC'+numeroID);
	habilitaControl('CURP'+numeroID);
	habilitaControl('estadoID'+numeroID);
	habilitaControl('municipioID'+numeroID);
	habilitaControl('localidadID'+numeroID);
	habilitaControl('coloniaID'+numeroID);
	habilitaControl('calle'+numeroID);
	habilitaControl('numeroCasa'+numeroID);
	habilitaControl('numInterior'+numeroID);
	habilitaControl('piso'+numeroID);
	habilitaControl('CP'+numeroID);
	habilitaControl('lote'+numeroID);
	habilitaControl('manzana'+numeroID);	
}

// FUNCION PARA VALIDAR PARTICIPACION FISCAL CLIENTE Y RELACIONADOS
function validaParticipacionFiscal(idControl){
	var jqParticipacion = eval("'#" + idControl + "'");
	var participaFiscalCte = $('#participaFiscalCte').val();
	var totalParticipacion = 0;
	
	// agrega formato moneda
	$('#formaGenerica').find('input[esMoneda="true"]').each(function(){	    	
		var jControl = eval("'#" + this.id + "'"); 
			
		$(jControl).formatCurrency({
			positiveFormat: '%n',  
			negativeFormat: '%n',
			roundToDecimalPlace: 2	
		});			
	});
	
	//obtenemos el total de los mas relacionaos
	$('input[name="lisParticipacionFiscal"]').each(function() {
		var jqParticipacionGrid = eval("'#" + this.id + "'");

		if(this.id != idControl){
			if(!isNaN($(jqParticipacionGrid).val())){
				totalParticipacion = totalParticipacion + $(jqParticipacionGrid).asNumber();
			}			
		}
	});
	var restaParticipacion = 0;
	restaParticipacion = 100 - totalParticipacion;
	
	//valida que la participacion sea mayor a 0 y menor o igual a 100
	if($(jqParticipacion).asNumber() > 0 && $(jqParticipacion).asNumber() <= 100){
		
		//valida que la participacion sea menor o igual a resta entre la participacion total del aportante menos la suma de los relacionados 
		if($(jqParticipacion).asNumber() <= restaParticipacion){
			restaParticipacion = restaParticipacion - $(jqParticipacion).asNumber();
			$('#participaFiscalCte').val(restaParticipacion);
		}else{
			$(jqParticipacion).val('');
			$(jqParticipacion).focus();
			$('#participaFiscalCte').val(restaParticipacion);
			mensajeSis('La Participación Fiscal debe ser menor o igual a '+restaParticipacion);			
		}		
	}else{
		if($(jqParticipacion).val() != ''){
			$(jqParticipacion).val('');
			$(jqParticipacion).focus();
			$('#participaFiscalCte').val(restaParticipacion);
			mensajeSis('La Participación Fiscal debe ser mayor a 0 y menor o igual a 100');			
		}
	}
	
	// agrega formato moneda
	$('#formaGenerica').find('input[esMoneda="true"]').each(function(){	    	
		var jControl = eval("'#" + this.id + "'"); 
			
		$(jControl).formatCurrency({
			positiveFormat: '%n',  
			negativeFormat: '%n',
			roundToDecimalPlace: 2	
		});			
	});
}

//FUNCION PARA CALCULAR LA PARTICIPACION FISCAL DEL CLIENTE AL ELIMINAR O CAMBIAR UN RELACIONADO
function calculaParticipacionFiscalCte(){
	var totalParticipacion = 0.00;	
	
	// agrega formato moneda
	$('#formaGenerica').find('input[esMoneda="true"]').each(function(){	    	
		var jControl = eval("'#" + this.id + "'"); 
			
		$(jControl).formatCurrency({
			positiveFormat: '%n',  
			negativeFormat: '%n',
			roundToDecimalPlace: 2	
		});			
	});
	
	var particiGridCte = 0.00;
	//obtenemos el total de los relacionados
	$('input[name="lisParticipacionFiscal"]').each(function() {
		var jqParticipacionGrid = eval("'#" + this.id + "'");
		particiGridCte = $(jqParticipacionGrid).asNumber();
		if(!isNaN(particiGridCte)){
			totalParticipacion = parseFloat(totalParticipacion) + parseFloat(particiGridCte);	
		}		
		particiGridCte = 0.00;
	});
	var restaParticipacion = 0.00;
	restaParticipacion = parseFloat(100.00) - parseFloat(totalParticipacion);
	$('#participaFiscalCte').val(restaParticipacion);
		
	// agrega formato moneda
	$('#formaGenerica').find('input[esMoneda="true"]').each(function(){	    	
		var jControl = eval("'#" + this.id + "'"); 
			
		$(jControl).formatCurrency({
			positiveFormat: '%n',  
			negativeFormat: '%n',
			roundToDecimalPlace: 2	
		});			
	});
}

// FUNCION PARA LISTAR EL ESTADO
function listaEstado(idControl){
	lista(idControl, '2', '1', 'nombre', $('#'+idControl).val(), 'listaEstados.htm');
}

function listaMunicipio(idMunicipio){
	var numeroID = idMunicipio.substr(11,idMunicipio.length);
	var camposLista = new Array();
	var parametrosLista = new Array();
	
	camposLista[0] = "estadoID";
	camposLista[1] = "nombre";
		
	parametrosLista[0] = $('#estadoID'+numeroID).val();
	parametrosLista[1] = $('#'+idMunicipio).val();
	
	if($('#estadoID'+numeroID).val() != '' && $('#estadoID'+numeroID).asNumber() > 0 ){
		lista(idMunicipio, '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
	}else{
		if($('#'+idMunicipio).val().length >= 3){
			$('#estadoID'+numeroID).focus();
			$('#'+idMunicipio).val('');
			$('#nombreMuni'+numeroID).val('');
			$('#nombreCiudad'+numeroID).val("");
			mensajeSis('Especificar Estado.');
		}			
	}		
}

function listaLocalidad(idLocalidad){
	var numeroID = idLocalidad.substr(11,idLocalidad.length);
	var camposLista = new Array();
	var parametrosLista = new Array();
	
	camposLista[0] = "estadoID";
	camposLista[1] = 'municipioID';
	camposLista[2] = "nombreLocalidad";
		
	parametrosLista[0] = $('#estadoID'+numeroID).val();
	parametrosLista[1] = $('#municipioID'+numeroID).val();
	parametrosLista[2] = $('#localidadID'+numeroID).val();
	
	if($('#estadoID'+numeroID).val() != '' && $('#estadoID'+numeroID).asNumber() > 0){
		if($('#municipioID'+numeroID).val() != '' && $('#municipioID'+numeroID).asNumber() > 0){
			lista(idLocalidad, '2', '1', camposLista, parametrosLista,'listaLocalidades.htm');
		}else{
			if($('#'+idLocalidad).val().length >= 3){
				$('#municipioID'+numeroID).focus();
				$('#'+idLocalidad).val('');
				$('#nombreLocalidad'+numeroID).val('');
				mensajeSis('Especificar Municipio.');
			}
		}
	}else{
		if($('#'+idLocalidad).val().length >= 3){
			$('#estadoID'+numeroID).focus();
			$('#'+idLocalidad).val('');
			$('#nombreLocalidad'+numeroID).val('');
			mensajeSis('Especificar Estado.');
		}
	}
}

function listaColonia(idColonia){
	var numeroID = idColonia.substr(9,idColonia.length);
	var camposLista = new Array();
	var parametrosLista = new Array();
	
	camposLista[0] = "estadoID";
	camposLista[1] = 'municipioID';
	camposLista[2] = "asentamiento";		
	
	parametrosLista[0] = $('#estadoID'+numeroID).val();
	parametrosLista[1] = $('#municipioID'+numeroID).val();
	parametrosLista[2] = $('#coloniaID'+numeroID).val();
	
	if($('#estadoID'+numeroID).val() != '' && $('#estadoID'+numeroID).asNumber() > 0){
		if($('#municipioID'+numeroID).val() != '' && $('#municipioID'+numeroID).asNumber() > 0){
			lista(idColonia, '2', '1', camposLista, parametrosLista,'listaColonias.htm');
		}else{
			if($('#'+idColonia).val().length >= 3){
				mensajeSis('Especificar Municipio.');
				$('#municipioID'+numeroID).focus();
				$('#'+idColonia).val('0');
				$('#nombreColonia'+numeroID).val('');
			}
		}
	}else{
		if($('#'+idColonia).val().length >= 3){
			mensajeSis('Especificar Estado.');
			$('#estadoID'+numeroID).focus();
			$('#'+idColonia).val('');
			$('#nombreColonia'+numeroID).val('');
		}
	}
	
	
}

//FUNCIÓN QUE CONSULTA LOS DATOS DEL ESTADO 
function consultaEstado(idControl) {
	var numeroID = idControl.substr(8,idControl.length);
	var jqEstado = eval("'#" + idControl + "'");
	var numEstado = $(jqEstado).val();	
	var tipConForanea = 2;	
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numEstado != '' && !isNaN(numEstado) && numEstado > 0){
		estadosServicio.consulta(tipConForanea,numEstado,{ async: false, callback: function(estado) {
			if(estado!=null){							
				$('#nombreEstado'+numeroID).val(estado.nombre);
			}else{
				$('#nombreEstado'+numeroID).val("");
				$('#'+idControl).val("");
				$('#'+idControl).focus();
				mensajeSis("No Existe el Estado.");
			}    	 						
		}});
	}else{
		if(numEstado == '' && isNaN(numEstado)){
			$('#nombreEstado'+numEstado == '').val("");
		}
	}
}	

//FUNCIÓN QUE CONSULTA LOS DATOS DEL MUNICIPIO
function consultaMunicipio(idControl) {
	var numeroID = idControl.substr(11,idControl.length);
	var jqMunicipio = eval("'#" + idControl + "'");
	var numMunicipio = $(jqMunicipio).val();	
	var numEstado =  $('#estadoID'+numeroID).val();				
	var tipConForanea = 2;	
	setTimeout("$('#cajaLista').hide();", 200);		
				
	if(numMunicipio != '' && !isNaN(numMunicipio) && numMunicipio > 0){	
		if(numEstado !='' && numEstado > 0 ){
				municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,{ async: false, callback: function(municipio) {
					if(municipio!=null){							
						$('#nombreMuni'+numeroID).val(municipio.nombre);
						$('#nombreCiudad'+numeroID).val(municipio.ciudad);
					}else{
						mensajeSis("No Existe el Municipio.");
						$('#nombreMuni'+numeroID).val("");
						$('#nombreCiudad'+numeroID).val("");
						$(jqMunicipio).val("");
						$(jqMunicipio).focus();
					}    	 						
				}});	

		}else{
			$('#nombreMuni'+numeroID).val("");
			$('#nombreCiudad'+numeroID).val("");
			$(jqMunicipio).val("0");
			$('#estadoID'+numeroID).focus();
			mensajeSis("Especificar Estado.");
		}
	}else{
		if(numMunicipio == '' && isNaN(numMunicipio)){
			$('#nombreMuni'+numeroID).val("");
			$('#nombreCiudad'+numeroID).val("");		
		}
	}
}	

//FUNCIÓN QUE CONSULTA LOS DATOS DE LA LOCALIDAD
function consultaLocalidad(idControl) {
	var numeroID = idControl.substr(11,idControl.length);
	var jqLocalidad = eval("'#" + idControl + "'");
	var numLocalidad = $(jqLocalidad).val();
	var numMunicipio =	$('#municipioID'+numeroID).val();
	var numEstado =  $('#estadoID'+numeroID).val();				
	var tipConPrincipal = 1;	
	setTimeout("$('#cajaLista').hide();", 200);		
	
	if(numLocalidad != '' && !isNaN(numLocalidad) && numLocalidad > 0){
		if(numEstado != '' && numEstado > 0 ){
			if(numMunicipio !='' && numMunicipio > 0){
				localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad,{ async: false, callback: function(localidad) {
					if(localidad!=null){							
						$('#nombreLocalidad'+numeroID).val(localidad.nombreLocalidad);
					}else{
						$('#nombreLocalidad'+numeroID).val("");
						$(jqLocalidad).val("");
						$(jqLocalidad).focus();
						mensajeSis("No Existe la Localidad.");
					}    	 						
				}});
			}else{
				$('#nombreLocalidad'+numeroID).val("");
				$(jqLocalidad).val("");
				$('#municipioID'+numeroID).focus();
				mensajeSis("Especificar Municipio.");
			}
		}else{
			$('#nombreLocalidad'+numeroID).val("");
			$(jqLocalidad).val("");
			$('#estadoID'+numeroID).focus();	
			mensajeSis("Especificar Estado.");										
		}	
	}else{
		if(numLocalidad == '' && isNaN(numLocalidad)){
			$('#nombreLocalidad'+numeroID).val("");
		}
	}	
}

//FUNCIÓN QUE CONSULTA LOS DATOS DE LA COLONIA
function consultaColonia(idControl) {
	var numeroID = idControl.substr(9,idControl.length);
	var jqColonia = eval("'#" + idControl + "'");
	var numColonia= $(jqColonia).val();		
	var numEstado =  $('#estadoID'+numeroID).val();	
	var numMunicipio =	$('#municipioID'+numeroID).val();
	var tipConPrincipal = 1;	
	setTimeout("$('#cajaLista').hide();", 200);		
			
	if(numColonia != '' && !isNaN(numColonia) && numColonia > 0){
		if(numEstado != '' && numEstado > 0 ){
			if(numMunicipio !='' && numMunicipio > 0){
				coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,{ async: false, callback: function(colonia) {
						if(colonia!=null){							
							$('#nombreColonia'+numeroID).val(colonia.asentamiento);
							$('#CP'+numeroID).val(colonia.codigoPostal);
						}else{
							mensajeSis("No Existe la Colonia.");
							$('#nombreColonia'+numeroID).val("");
							$('#CP'+numeroID).val("");
							$(jqColonia).val("");
							$(jqColonia).focus();
						}    	 						
					}});
			}else{
				$('#nombreColonia'+numeroID).val("");
				$('#CP'+numeroID).val("");
				$(jqColonia).val("");
				$('#municipioID'+numeroID).focus();
				mensajeSis("Especificar Municipio.");
			}
		}else{
			$('#nombreColonia'+numeroID).val("");
			$('#CP'+numeroID).val("");
			$(jqColonia).val("");
			$('#estadoID'+numeroID).focus();	
			mensajeSis("Especificar Estado.");										
		}			
	}else{
		if(numColonia == '' && isNaN(numColonia)){
			$('#nombreColonia'+numeroID).val("TODAS");
		}
	}
}

// FUNCION CONSULTA DIRECCION COMPLETA
function consultaDirecCompleta(numeroID) {
	var ca 		= $('#calle'+numeroID).val();
	var nu  	= $('#numeroCasa'+numeroID).val();
	var ni  	= $('#numInterior'+numeroID).val();
	var pis  	= $('#piso'+numeroID).val();
	var co 	 	= $('#nombreColonia'+numeroID).val();	
	var cp  	= $('#CP'+numeroID).val();	
	var nm  	= $('#nombreMuni'+numeroID).val();
	var ne 		= $('#nombreEstado'+numeroID).val();				
	var lot 	= $('#lote'+numeroID).val();
	var man 	= $('#manzana'+numeroID).val();
	
	var dirCom =  ca;
	
	if(nu != ''){
		dirCom = (dirCom +", No. "+ nu);
	}
	if(ni != ''){
			dirCom = (dirCom +", INTERIOR "+ ni); 
		}
	if(pis != ''){
			dirCom = (dirCom +", PISO "+ pis); 
		}
		if(lot != ''){
			dirCom = (dirCom + ", LOTE "+ lot); 
		}  
		if(man != ''){
			dirCom = (dirCom +", MANZANA " + man); 
		} 
		if(co != ''){
			dirCom = (dirCom +", COL. " + co); 
		}  		
		dirCom = (dirCom+", C.P. "+ cp +", "+ nm  + ", "+ ne +"." );
		$('#direccionCompleta'+numeroID).val(dirCom.toUpperCase());	
}

//FUNCION PARA VALIDAR CAMPOS OBLIGATORIOS
function validaCamposObligatoriosGrid(){
	var numeroID = 0;
	var continua = true;
	var participacionCte = parseFloat($('#participaFiscalCte').asNumber());
	var particiRelacionados = 0;
	var tolalParticipacion = 0;
	$('tr[name=renglons]').each(function() {
		numeroID = this.id.substr(7,this.id.length);
		// Validamos si no es cliente el relacionado
		if($('#cteRelacionadoID'+numeroID).val() == '' || $('#cteRelacionadoID'+numeroID).val() == 0){
			if($('#primerNombre'+numeroID).val() == ''){
				$('#primerNombre'+numeroID).focus();
				mensajeSis('Especifique el Primer Nombre.');
				continua = false;
				return false;
			}
			if($('#apellidoPaterno'+numeroID).val() == ''){
				$('#apellidoPaterno'+numeroID).focus();
				mensajeSis('Especifique el Apellido Paterno.');
				continua = false;
				return false;
			}
			if($('#nacion'+numeroID).val() == ''){
				$('#nacion'+numeroID).focus();
				mensajeSis('Especifique la Nacionalidad.');
				continua = false;
				return false;				
			}
			if($('#paisResidencia'+numeroID).val() == ''){
				$('#paisResidencia'+numeroID).focus();
				mensajeSis('Especifique el País de Residencia.');
				continua = false;
				return false;								
			}
			if($('#RFC'+numeroID).val() == '' && $('#nacion'+numeroID).val() != 'E'){
				$('#RFC'+numeroID).focus();
				mensajeSis('Especifique el RFC.');
				continua = false;
				return false;											
			}	
			if($('#RFC'+numeroID).val().length != 13 && $('#nacion'+numeroID).val() != 'E'){
				$('#RFC'+numeroID).focus();
				$('#RFC'+numeroID).select();
				mensajeSis('Especifique el RFC a 13 caracteres.');
				continua = false;
				return false;											
			}			
			if($('#CURP'+numeroID).val() == '' && $('#nacion'+numeroID).val() != 'E'){
				$('#CURP'+numeroID).focus();
				mensajeSis('Especifique el CURP.');
				continua = false;
				return false;			
			}
			if($('#CURP'+numeroID).val().length != 18 && $('#nacion'+numeroID).val() != 'E'){
				$('#CURP'+numeroID).focus();
				$('#CURP'+numeroID).select();
				mensajeSis('Especifique la CURP a 18 caracteres.');
				continua = false;
				return false;											
			}
			if($('#nacion'+numeroID).val() == 'E'){
				if($('#direccionCompleta'+numeroID).val() == ''){
					$('#direccionCompleta'+numeroID).focus();
					$('#direccionCompleta'+numeroID).select();
					mensajeSis('Especifique la Dirección Completa.');
					continua = false;
					return false;						
				}										
			}
		}	
		
		var particiFiscal = parseFloat($('#participacionFiscal'+numeroID).asNumber());
		if(particiFiscal <= 0 || $('#participacionFiscal'+numeroID).val() == ''){
			$('#participacionFiscal'+numeroID).focus();
			mensajeSis('Especifique la Participación Fiscal.'+$('#participacionFiscal'+numeroID).val());
			continua = false;
			return false;											
		}
		particiRelacionados = parseFloat(particiRelacionados) + parseFloat(particiFiscal);
	});
	
	
	
	if(continua == true){
		tolalParticipacion = parseFloat(participacionCte) + parseFloat(particiRelacionados); 

		if(tolalParticipacion != parseFloat(100.00)){
			$('#grabar').focus();
			mensajeSis('La suma de la Participación Fiscal no es igual al 100%.');
			continua = false;
			return false;
		}
		
		$('tr[name=renglons]').each(function() {
			numeroID = this.id.substr(7,this.id.length);
			habilitaCamposPersonaGrid(numeroID);
			// CAMPOS VACIOS SE MANDAN CON UN ESPACIO
			if($('#segundoNombre'+numeroID).val() == ''){$('#segundoNombre'+numeroID).html('&nbsp;');}
			if($('#tercerNombre'+numeroID).val() == ''){$('#tercerNombre'+numeroID).html('&nbsp;');}
			if($('#apellidoMaterno'+numeroID).val() == ''){$('#apellidoMaterno'+numeroID).html('&nbsp;');}
			if($('#estadoID'+numeroID).val() == ''){$('#estadoID'+numeroID).html('&nbsp;');}
			if($('#municipioID'+numeroID).val() == ''){$('#municipioID'+numeroID).html('&nbsp;');}
			if($('#localidadID'+numeroID).val() == ''){$('#localidadID'+numeroID).html('&nbsp;');}
			if($('#coloniaID'+numeroID).val() == ''){$('#coloniaID'+numeroID).html('&nbsp;');}
			if($('#calle'+numeroID).val() == ''){$('#calle'+numeroID).html('&nbsp;');}
			if($('#numeroCasa'+numeroID).val() == ''){$('#numeroCasa'+numeroID).html('&nbsp;');}
			if($('#numInterior'+numeroID).val() == ''){$('#numInterior'+numeroID).html('&nbsp;');}
			if($('#piso'+numeroID).val() == ''){$('#piso'+numeroID).html('&nbsp;');}
			if($('#CP'+numeroID).val() == ''){$('#CP'+numeroID).html('&nbsp;');}
			if($('#lote'+numeroID).val() == ''){$('#lote'+numeroID).html('&nbsp;');}
			if($('#manzana'+numeroID).val() == ''){$('#manzana'+numeroID).html('&nbsp;');}
			if($('#direccionCompleta'+numeroID).val() == ''){$('#direccionCompleta'+numeroID).html('&nbsp;');}
		});
	}
	
	return continua;
}

//FUNCION PARA LIMPIAR Y OCULTAR O MOSTRAR CAMPOS CUANDO ES DE NACIONALIDAD EXTRANJERA
function limpiarMostrarOcultarCamposExtranjero(numeroID){

	$('#estadoID'+numeroID).val('');
	$('#nombreEstado'+numeroID).val('');
	$('#municipioID'+numeroID).val('');	
	$('#nombreMuni'+numeroID).val('');	
	$('#localidadID'+numeroID).val('');	
	$('#nombreLocalidad'+numeroID).val('');	
	$('#coloniaID'+numeroID).val('');	
	$('#nombreColonia'+numeroID).val('');	
	$('#nombreCiudad'+numeroID).val('');	
	$('#calle'+numeroID).val('');	
	$('#numeroCasa'+numeroID).val('');	
	$('#numInterior'+numeroID).val('');	
	$('#piso'+numeroID).val('');	
	$('#CP'+numeroID).val('');	
	$('#lote'+numeroID).val('');	
	$('#manzana'+numeroID).val('');		
	$('#direccionCompleta'+numeroID).val('');
	
	if($('#nacion'+numeroID).val() == 'E'){
		$('td[class="tdDomicilioFiscal'+numeroID+'"]').hide();	
		$('tr[class="trDomicilioFiscal'+numeroID+'"]').hide();	
			
		if($('#cteRelacionadoID'+numeroID).val() == '' || $('#cteRelacionadoID'+numeroID).val() == 0){
			$('#direccionCompleta'+numeroID).attr('readOnly',false); 
		}
	}else{
		$('td[class="tdDomicilioFiscal'+numeroID+'"]').show();		
		$('tr[class="trDomicilioFiscal'+numeroID+'"]').show();
		if($('#cteRelacionadoID'+numeroID).val() == '' || $('#cteRelacionadoID'+numeroID).val() == 0){
			$('#direccionCompleta'+numeroID).attr('readOnly',true); 
		}
	}
}

//FUNCION PARA SOLO OCULTAR O MOSTRAR CAMPOS CUANDO ES DE NACIONALIDAD EXTRANJERA
function mostrarOcultarCamposExtranjero(numeroID){
	if($('#nacion'+numeroID).val() == 'E'){
		$('td[class="tdDomicilioFiscal'+numeroID+'"]').hide();	
		$('tr[class="trDomicilioFiscal'+numeroID+'"]').hide();	
			
		if($('#cteRelacionadoID'+numeroID).val() == '' || $('#cteRelacionadoID'+numeroID).val() == 0){
			$('#direccionCompleta'+numeroID).attr('readOnly',false); 
		}
	}else{
		$('td[class="tdDomicilioFiscal'+numeroID+'"]').show();		
		$('tr[class="trDomicilioFiscal'+numeroID+'"]').show();
		if($('#cteRelacionadoID'+numeroID).val() == '' || $('#cteRelacionadoID'+numeroID).val() == 0){
			$('#direccionCompleta'+numeroID).attr('readOnly',true); 
		}
	}
}

function cambiaRegistroHacienda(id, valor){
	$('#registroHaciendaValor'+id).val(valor);
}

function cambiaTipoPersona(id, valor){
	$('#tipoPersonaValor'+id).val(valor);
}

//FUNCIÓN DE ÉXITO DE LA TRANSACCIÓN
function funcionExito() {
	var jQmensaje = eval("'#ligaCerrar'");
	if($(jQmensaje).length > 0) { 
	mensajeAlert=setInterval(function() { 
		if($(jQmensaje).is(':hidden')) { 	
			clearInterval(mensajeAlert); 
			
			inicializaPantalla();						
		}
        }, 50);
	}	
}

//FUNCIÓN DE ERROR DE LA TRANSACCIÓN
function funcionError() {
	$('tr[name=renglons]').each(function() {
		var numeroID = this.id.substr(7,this.id.length);
		var jqClienteID = eval("'#cteRelacionadoID" + numeroID + "'");
		
		if($(jqClienteID).val() > 0 && $(jqClienteID).val() != ''){
			desHabilitaCamposPersonaGrid(numeroID);
		}else{
			habilitaCamposPersonaGrid(numeroID);
		}
	});
} 
