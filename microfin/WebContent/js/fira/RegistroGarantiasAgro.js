var desdeFlujo ='N';
var parametroBean = consultaParametrosSession();  
	
$(document).ready(function() {
	// Definicion de Constantes y Enums
	// Inicializaciones
	esTab = false;
	parametroBean = consultaParametrosSession();   
	var Yfecha= parametroBean.fechaAplicacion;	
	var efectoNo='N';
	
	$('#garantiaID').focus();	
	creaCamposPorDocumento($('#tipoDocumentoID').val(),efectoNo);	
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('modificar', 'submit');
	
	var tipoGarantia= $('#tipoGarantiaID').val();
	consultaClasificacionesGarantias(tipoGarantia,0);
	$('#trFechVencimiento').hide( );
	$('#trAsegurador').hide();
	$('#trEstatusGrabado').hide();
	$('#trNombreBenefi').hide();
	$('#direccionGarante').hide();   

	var catTipoTransaccionGarantias = {  
			'grabar':'1',
			'modificar':'2'	
	};	
		
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});	
		
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	$.validator.setDefaults({
		submitHandler: function(event) { 
			if($('#clienteID').val() > 0 || $('#prospectoID').val() > 0 ||  $('#garanteNombre').val() != ''){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','garantiaID','funcionEsExitoRegGaran','funcionEsErrorRegGaran');
			}else{
				mensajeSis(" Ingrese los datos del "+$('#varSafilocale').val()+", Prospecto o Garante");
				$('#clienteID').focus();
			}					 
		}
	});	

	/* *****************************************************************************************
   	Fecha : 18-abril-2013, Bloque de funcionalidad extra para esta pantalla
 	Solicitado por FCHIA para pantalla pivote (solicitud credito grupal)
 	Valida en la pantalla de solicitud grupal el numero de solicitud (perteneciente al grupo)seleccionado 
	no eliminar, no afecta el comportamiento de la pantalla de manera individual */

	var cteActual = $('#clientIDGrupal').asNumber();
	var proActual = $('#prospectIDGrupal').asNumber();

	if(cteActual>0){
		$('#clienteID').val(cteActual);
		consultaCliente('clienteID', 'clienteNombre');
	}else{
		if(proActual >0){
			$('#prospectoID').val(proActual);
			consultaProspectos('prospectoID', 'prospectoNombre');
		}
	}
	if($('#clienteID').asNumber()>0 || $('#prospectoID').asNumber()>0){
		$('#garantiaID').val('0');
		desdeFlujo ='S';
	}else {
		$('#garantiaID').val('');
		desdeFlujo ='N';
	}
	// fin  Bloque de funcionalidad extra
	/* *********************************************************************************************/

	$('#garantiaID').bind('keyup',function(e){
		lista('garantiaID', '2', '3', 'garantiaID', $('#garantiaID').val(), 'listaGarantias.htm');
	});
	
	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '2', '14', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#prospectoID').bind('keyup',function(e){
		lista('prospectoID', '2', '1', 'prospectoID', $('#prospectoID').val(), 'listaProspecto.htm');
	});

	$('#garanteID').bind('keyup',function(e) { 
		lista('garanteID', '3', '1', 'nombreCompleto', $('#garanteID').val(), 'listaGarantes.htm');
	});
	
	$('#garanteID').blur(function() {
		if(esTab){
			if ( $.trim($('#garanteID').val()) !=''){
				$('#direccionGarante').show(); 
				$('#estadoGarante').focus();  	
				$('#prospectoID').val('');
				$('#prospectoNombre').val('');
				$('#clienteID').val('');
				$('#clienteNombre').val('');
				consultaGarante(this.id);
			}
			if ( $.trim($('#garanteID').val()) ==''  ){
				$('#direccionGarante').hide();   
				limpiaDireccionGarante();
			}
		}
		
	});

	$('#prospectoID').blur(function() {
		if (esTab){
			consultaProspectos(this.id, 'prospectoNombre');
		}
	});
	
	$('#clienteID').blur(function() {
		if(esTab){
			consultaCliente(this.id, 'clienteNombre');
		}
	});

	$('#tipoGarantiaID').change(function(){
		var tipoGarantia= $('#tipoGarantiaID').val();
		consultaClasificacionesGarantias(tipoGarantia,0);
	});

	$('#tipoGravemen').change(function(){
		var tipoGravemen= $('#tipoGravemen').val();
		validagravemen(tipoGravemen);
	});

	$('#tipoDocumentoID').change(function(){
		var efectoSI='S';
		creaCamposPorDocumento($('#tipoDocumentoID').val(),efectoSI);
		agregaFormatoControles('formaGenerica');
	});
	
	
	$('#garantiaID').blur(function() {
		if(esTab){
			var numcliente=$('#clienteID').asNumber();
			var numprospect=$('#prospectoID').asNumber();
			
			if($('#garantiaID').val()!='' && $('#garantiaID').val()!= 0){
				habilitaBoton('modificar', 'submit');
				consultaGarantia(this.id);
			}
			if($('#garantiaID').val()!='' && $('#garantiaID').val()== 0){
				inicializaFormularioGarantia();
				habilitaBoton('grabar', 'submit');
			}
			if(desdeFlujo=='S' &&(numcliente>0 || numprospect>0)){
				$('#clienteID').val(numcliente);
				$('#prospectoID').val(numprospect);
			}
		}		
	});

	$('#grabar').click(function() {		
		if ($('#montoAvaluo').val() <= 0) {
			mensajeSis("El Monto de Avalúo no puede ser 0");
		}	
		else {
				$('#tipoTransaccion').val(catTipoTransaccionGarantias.grabar);
			}
		
	});

	$('#modificar').click(function() {		
		if ($('#montoAvaluo').val() <= 0) {
			mensajeSis("El Monto de Avalúo no puede ser 0");
		}	
			else {
				$('#tipoTransaccion').val(catTipoTransaccionGarantias.modificar);
				}
	});

	$('#fechaValuacion').change(function() {	
		 validaFechaVal();		
	});
	
	$('#fechaVerificacion').change(function() {	
		 validaFechaVer();		
	});

	$('#fechagravemen').change(function() {		
		 validaFechaGra();
	});


	/* Inicio datos de direccion de garante*/ 
	$('#estadoGarante').bind('keyup',function(e){
		lista('estadoGarante', '2', '1', 'nombre', $('#estadoGarante').val(), 'listaEstados.htm');
	});

	$('#municipioGarante').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = "nombre";
		
		parametrosLista[0] = $('#estadoGarante').val();
		parametrosLista[1] = $('#municipioGarante').val();

		if($('#estadoGarante').val() != '' && $('#estadoGarante').asNumber() > 0 ){
			lista('municipioGarante', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
		}else{
			if($('#municipioGarante').val().length >= 3){
				$('#estadoGarante').focus();
				$('#municipioGarante').val('');
				$('#mpioNombreGarante').val('');
				mensajeSis('Especificar Estado');
			}			
		}
	});
	
	$('#localidadIDGarante').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = 'municipioID';
		camposLista[2] = "nombreLocalidad";
		
		
		parametrosLista[0] = $('#estadoGarante').val();
		parametrosLista[1] = $('#municipioGarante').val();
		parametrosLista[2] = $('#localidadIDGarante').val();
		
		if($('#estadoGarante').val() != '' && $('#estadoGarante').asNumber() > 0){
			if($('#municipioGarante').val() != '' && $('#municipioGarante').asNumber() > 0){
				lista('localidadIDGarante', '2', '1', camposLista, parametrosLista,'listaLocalidades.htm');
			}else{
				if($('#localidadIDGarante').val().length >= 3){
					$('#municipioGarante').focus();
					$('#localidadIDGarante').val('');
					$('#nombrelocalidadGarante').val('');
					mensajeSis('Especificar Municipio');
				}
			}
		}else{
			if($('#localidadIDGarante').val().length >= 3){
				$('#estadoGarante').focus();
				$('#localidadIDGarante').val('');
				$('#nombrelocalidadGarante').val('');
				mensajeSis('Especificar Estado');
			}
		}
		
		
	});

	$('#estadoGarante').blur(function() {
		if(esTab){
			consultaEstadoGarante(this.id);
		}
	});
	
	$('#municipioGarante').blur(function() {
		if(esTab){
			consultaMunicipioGarante(this.id);
		}			
	});

	$('#localidadIDGarante').blur(function() {
		if(esTab){
			consultaLocalidadGarante(this.id);
		}		
	});	

	$('#verificada').change(function(){
		validaGarantiaVeridicada(this.id);
	});
	
	$('#coloniaID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = 'municipioID';
		camposLista[2] = "asentamiento";		
		
		parametrosLista[0] = $('#estadoGarante').val();
		parametrosLista[1] = $('#municipioGarante').val();
		parametrosLista[2] = $('#coloniaID').val();
		
		if($('#estadoGarante').val() != '' && $('#estadoGarante').asNumber() > 0){
			if($('#municipioGarante').val() != '' && $('#municipioGarante').asNumber() > 0){
				lista('coloniaID', '2', '1', camposLista, parametrosLista,'listaColonias.htm');
			}else{
				if($('#coloniaID').val().length >= 3){
					mensajeSis('Especificar Municipio');
					$('#municipioGarante').focus();
					$('#coloniaID').val('0');
					$('#coloniaGarante').val('TODAS');
				}
			}
		}else{
			if($('#coloniaID').val().length >= 3){
				mensajeSis('Especificar Estado');
				$('#estadoGarante').focus();
				$('#coloniaID').val('0');
				$('#coloniaGarante').val('TODAS');
			}
		}
		
		
	});
	
	$('#coloniaID').blur(function() {
		if(esTab){
			consultaColonia(this.id);			
		}
	});

	//FUNCION CONSULTA DATOS DEL ESTADO SECCION DIRECCION GARANTE
	function consultaEstadoGarante(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numEstado != '' && !isNaN(numEstado) && numEstado > 0){
			estadosServicio.consulta(tipConForanea,numEstado,{ async: false, callback: function(estado) {
				if(estado!=null){							
					$('#estadoGarante').val(estado.estadoID);
					$('#estadoNombGarante').val(estado.nombre);
				}else{
					$('#estadoGarante').val("");
					$('#estadoNombGarante').val("");
					$('#estadoGarante').focus();
					mensajeSis("No Existe el Estado");
				}    	 						
			}});
		}else{
			if(isNaN(numEstado)){
				$('#estadoGarante').val("");
				$('#estadoNombGarante').val("");
				$('#estadoGarante').focus();
				mensajeSis("No Existe el Estado");
			}else{
				if(numEstado == '' || numEstado == 0){
					$('#estadoGarante').val("");
					$('#estadoNombGarante').val("");		
				}
			}
		}		
	}
	
	//FUNCION CONSULTA DATOS DEL MUNICIPIO SECCION DIRECCION GARANTE
	function consultaMunicipioGarante(idControl) {			
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();	
		var numEstado =  $('#estadoGarante').val();				
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
					
		if(numMunicipio != '' && !isNaN(numMunicipio) && numMunicipio > 0){	
			if(numEstado !='' && numEstado > 0 ){
					municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,{ async: false, callback: function(municipio) {
						if(municipio!=null){							
							$('#mpioNombreGarante').val(municipio.nombre);
						}else{
							mensajeSis("No Existe el Municipio");
							$('#mpioNombreGarante').val("");
							$('#municipioGarante').val("");
							$('#municipioGarante').focus();
						}    	 						
					}});	

			}else{
				$('#mpioNombreGarante').val("");
				$('#municipioGarante').val("");
				$('#estadoGarante').focus();
				mensajeSis("Especificar Estado");
			}
		}else{
			if(isNaN(numMunicipio)){
				mensajeSis("No Existe el Municipio");
				$('#mpioNombreGarante').val("");
				$('#municipioGarante').val("");
				$('#municipioGarante').focus();
					
			}else{
				if(numMunicipio == '' || numMunicipio == 0){
					$('#mpioNombreGarante').val("");
					$('#municipioGarante').val("");
				}
			}
		}
	
	}	

	
	//FUNCION CONSULTA DATOS DE LA LOCALIDAD SECCION DIRECCION GARANTE
	function consultaLocalidadGarante(idControl) {
		var jqLocalidad = eval("'#" + idControl + "'");
		var numLocalidad = $(jqLocalidad).val();
		var numMunicipio =	$('#municipioGarante').val();
		var numEstado =  $('#estadoGarante').val();				
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		
		
		if(numLocalidad != '' && !isNaN(numLocalidad) && numLocalidad > 0){
			if(numEstado != '' && numEstado > 0 ){
				if(numMunicipio !='' && numMunicipio > 0){
					localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad,{ async: false, callback: function(localidad) {
						if(localidad!=null){							
							$('#nombrelocalidadGarante').val(localidad.nombreLocalidad);
						}else{
							$('#nombrelocalidadGarante').val("");
							$(jqLocalidad).val("");
							$(jqLocalidad).focus();
							mensajeSis("No Existe la Localidad");
						}    	 						
					}});
				}else{
					$('#nombrelocalidadGarante').val("");
					$(jqLocalidad).val("");
					$('#municipioGarante').focus();
					mensajeSis("Especificar Municipio");
				}
			}else{
				$('#nombrelocalidadGarante').val("");
				$(jqLocalidad).val("");
				$('#estadoGarante').focus();	
				mensajeSis("Especificar Estado");										
			}	
		}else{
			if(isNaN(numLocalidad)){
				mensajeSis("No Existe la Localidad");
				$('#nombrelocalidadGarante').val("");
				$(jqLocalidad).val("");
				$(jqLocalidad).focus();
			}else{
				if(numLocalidad == '' || numLocalidad == 0){
					$('#nombrelocalidadGarante').val("");
					$(jqLocalidad).val("");		
				}
			}
		}		
	}
	
	//FUNCION QUE CONSULTA LOS DATOS DE LA COLONIA
	function consultaColonia(idControl) {
		var jqColonia = eval("'#" + idControl + "'");
		var numColonia= $(jqColonia).val();		
		var numEstado =  $('#estadoGarante').val();	
		var numMunicipio =	$('#municipioGarante').val();
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		
				
		if(numColonia != '' && !isNaN(numColonia) && numColonia > 0){
			if(numEstado != '' && numEstado > 0 ){
				if(numMunicipio !='' && numMunicipio > 0){
					coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,{ async: false, callback: function(colonia) {
							if(colonia!=null){							
								$('#coloniaGarante').val(colonia.asentamiento);
							}else{
								mensajeSis("No Existe la Colonia");
								$('#coloniaGarante').val("");
								$(jqColonia).val("");
								$(jqColonia).focus();
							}    	 						
						}});
				}else{
					$('#coloniaGarante').val("");
					$(jqColonia).val("");
					$('#municipioGarante').focus();
					mensajeSis("Especificar Municipio");
				}
			}else{
				$('#coloniaGarante').val("");
				$(jqColonia).val("");
				$('#estadoGarante').focus();	
				mensajeSis("Especificar Estado");										
			}			
		}else{
			if(isNaN(numColonia)){
				mensajeSis("No Existe la Colonia");
				$('#coloniaGarante').val("");
				$(jqColonia).val("");
				$(jqColonia).focus();			
			}else{
				if(numColonia == '' || numColonia == 0){
					$('#coloniaGarante').val("");
					$(jqColonia).val("");
				}
			}
		}
	}
	/* Fin datos de direccion de garante*/ 		

	//FUNCION CONSULTA DATOS DEL ESTADO
	function consultaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);

		if(numEstado != '' && !isNaN(numEstado) && numEstado > 0){
			estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
				if(estado!=null){		
					$('#estadoGarante').val(estado.estadoID);					
					$('#nombreEstado').val(estado.nombre);
				}else{
					$('#nombreEstado').val("");
					$('#estadoID').val("");
					$('#estadoID').focus();
					mensajeSis("No Existe el Estado");
				}    	 						
			});
		}else{
			if(isNaN(numEstado)){
				$('#nombreEstado').val("");
				$('#estadoID').val("");
				$('#estadoID').focus();
				mensajeSis("No Existe el Estado");
			}else{
				if(numEstado == '' || numEstado == 0){
					$('#nombreEstado').val("");
					$('#estadoID').val("");					
				}
			}
		}
	
	}	

	
	//FUNCION CONSULTA DATOS DEL MUNICIPIO
	function consultaMunicipio(idControl) {			
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();	
		var numEstado =  $('#estadoID').val();				
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
					
		if(numMunicipio != '' && !isNaN(numMunicipio) && numMunicipio > 0){	
			if(numEstado !='' && numEstado > 0 ){
					municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio, function(municipio) {
						if(municipio!=null){							
							$('#nombreMuni').val(municipio.nombre);
						}else{
							mensajeSis("No Existe el Municipio");
							$('#nombreMuni').val("");
							$('#municipioID').val("");
							$('#municipioID').focus();
						}    	 						
					});	

			}else{
				$('#nombreMuni').val("");
				$('#municipioID').val("");
				$('#estadoID').focus();
				mensajeSis("Especificar Estado");
			}
		}else{
			if(isNaN(numMunicipio)){
				mensajeSis("No Existe el Municipio");
				$('#nombreMuni').val("");
				$('#municipioID').val("");
				$('#municipioID').focus();						
			}else{
				if(numMunicipio == '' || numMunicipio == 0){
					$('#nombreMuni').val("");
					$('#municipioID').val("");			
				}
			}
		}
	
	}	

	//FUNCION CONSULTA DATOS DEL CLIENTE
	function consultaCliente(idControl, cliNombre) {
		var jqCliente = eval("'#" + idControl + "'");
		var nombre = eval("'#" + cliNombre + "'");
		var numCliente = $(jqCliente).val();	
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);	
		
		if(numCliente != '' && !isNaN(numCliente) && numCliente > 0 ){
			$('#prospectoID').val('');
			$('#prospectoNombre').val('');
			limpiaDireccionGarante();
			$('#direccionGarante').hide();   
			$('#garanteNombre').val('');
			
			clienteServicio.consulta(tipConPrincipal,numCliente,function(cliente) {
				if(cliente!=null){
					if(cliente.esMenorEdad != "S"){
						$(jqCliente).val(cliente.numero);							
						$(nombre).val(cliente.nombreCompleto);
					}else{
						mensajeSis("El "+$('#varSafilocale').val()+" es Menor de Edad");
						$(jqCliente).val('');
						$(jqCliente).focus();
						$("#clienteNombre").val('');
					}  
				}else{
					mensajeSis("El "+$('#varSafilocale').val()+" no Existe");
					$(jqCliente).val('');
					$(jqCliente).focus();
					$("#clienteNombre").val('');
				}    	 						
			});
		}else{
			if(isNaN(numCliente)){
				mensajeSis("El "+$('#varSafilocale').val()+" no Existe");
				$(jqCliente).val('');
				$(jqCliente).focus();
				$("#clienteNombre").val('');
			}else{
				if(numCliente =='' || numCliente == 0){
					$('#clienteID').val('');
				}
			}
			
		} 
	}

	//FUNCION CONSULTA DATOS DEL PROSPECTO
	function consultaProspectos(idControl, prospNombre) {
		var jqProspecto = eval("'#" + idControl + "'");
		var nombre = eval("'#" + prospNombre + "'");
		var numProspecto = $(jqProspecto).val();	
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		
		var prospectoBean = {
				'prospectoID'	:numProspecto
		};
		
		if(numProspecto != '' && !isNaN(numProspecto) && numProspecto > 0){
			$('#clienteID').val('');
			$('#clienteNombre').val('');
			limpiaDireccionGarante();
			$('#direccionGarante').hide();   
			$('#garanteNombre').val('');
			
			prospectosServicio.consulta(tipConPrincipal,prospectoBean,function(Prospecto) {
				if(Prospecto!=null){
					$(nombre).val(Prospecto.nombreCompleto);
					$('#clienteID').val(Prospecto.cliente);
					$('#clienteNombre').val(Prospecto.nombreCompleto);
				}else{	
					mensajeSis("El Prospecto No Existe");
					$(jqProspecto).val('');
					$(nombre).val(''	);
					$('#clienteID').val('');
					$('#clienteNombre').val('');
					$(jqProspecto).focus();
				}    	 						
			});
		}else{
			if(isNaN(numProspecto)){
				mensajeSis("El Prospecto No Existe");
				$(jqProspecto).val('');
				$(nombre).val(''	);
				$('#clienteID').val('');
				$('#clienteNombre').val('');
				$(jqProspecto).focus();
			}else{
				if(numProspecto =='' || numProspecto == 0){
					$(jqProspecto).val('');
				}
			}
			
		} 
	}

	
	//Funcion que consulta datos del Garante
	function consultaGarante(idControl) {
	var jqGarante = eval("'#" + idControl + "'");
	var numGarante = $(jqGarante).val();
	var conGarante = 1;
	setTimeout("$('#cajaLista').hide();", 200);

	if (numGarante != '' && !isNaN(numGarante)) {

			garantesServicio.consulta(conGarante,numGarante,function(garante) {

			if (garante != null) {
				$('#garanteNombre').val(garante.nombreCompleto);
			} else {
				mensajeSis("No Existe el Garante");
				$(jqGarante).val('');
				$(jqGarante).focus();
			}
		});
	}else{
		if(esTab){
			mensajeSis("No Existe el Garante");
			$(jqGarante).val('');
			$(jqGarante).focus();
		}
	}
}

	function consultaClasificacionesGarantias(tipoGarantia,idClasif) {
		var tipoLista = 1;	
		var garantiaBean = {
				'tipoGarantiaID'	:tipoGarantia
		};
		if(tipoGarantia != '' && !isNaN(tipoGarantia)){
			garantiaAgroServicioScript.clasifGarantiasLista(tipoLista,garantiaBean,function(data) {
				if(data!=null){
					llenaSelectClasif(data,idClasif);
				}else{
					mensajeSis("No existe Tipo de garantí­a");

				}    	 						
			});
		} 
	}

	//FUNCION CONSULTA DATOS NOTARIA
	function consultaNotaria(idControl) {
		var jqNotaria = eval("'#" + idControl + "'");
		var numNotaria = $(jqNotaria).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);
		
		var notariaBeanCon = {
				'estadoID':$('#estadoID').val(),
				'municipioID':$('#municipioID').asNumber(),
				'notariaID':numNotaria
		};
		
		if(numNotaria != '' && !isNaN(numNotaria)   ){		
			notariaServicio.consulta(tipConForanea,notariaBeanCon,function(notaria) {
				if(notaria!=null){							
					$('#nombreNotario').val(notaria.titular);
				}else{
					$(jqNotaria).val('');
					$('#nombreNotario').val('');
					mensajeSis("No Existe la Notaría");
					$(jqNotaria).focus();
				}    	 						
			});
		}else{
			if(isNaN(numNotaria)){
				$(jqNotaria).val('');
				$('#nombreNotario').val('');
				mensajeSis("No Existe la Notaría");
				$(jqNotaria).focus();
			}else{
				if(numNotaria =='' || numNotaria == 0){
					$(jqNotaria).val('');
				}
			}			
		}
	}

	//FUNCION LLENA COMBO CLASIFICACION DE GARANTIA
	function llenaSelectClasif(data,idClasif){
		dwr.util.removeAllOptions('clasifGarantiaID');
		dwr.util.addOptions('clasifGarantiaID', {'':'SELECCIONAR'}); 
		if(data!=''){
			dwr.util.addOptions('clasifGarantiaID', data, 'clasifGarantiaID', 'clasifGarantiaDesc');
			if(idClasif>0){
				$('#clasifGarantiaID option[value='+idClasif+']').attr('selected','true');
			}
		} else{
			mensajeSis("No se encontraron clasificaciones de garantías");
		} 
	}
	
	//FUNCION LIMPIA CAMPOS SECCION DIRECCION GARANTE
	function limpiaDireccionGarante(){
		$('#calleGarante').val('');
		$('#numIntGarante').val('');
	    $('#numExtGarante').val('');
		$('#codPostalGarante').val('');
		$('#coloniaGarante').val('');
		$('#estadoGarante').val('');
		$('#municipioGarante').val('');
		$('#mpioNombreGarante').val('');
		$('#estadoNombGarante').val('');
		$('#localidadIDGarante').val('');
	}
	
	//FUNCION CONSULTA FOLIO DE GARANTIA
	function consultaGarantia(idControl) {
		var jqGarantia = eval("'#" + idControl + "'");
		var garantiaID = $(jqGarantia).val();	
		var tipConPrincipal = 1;	
		var efectoNo='N';
		var garantiaBean = {
				'garantiaID'	:garantiaID
		};	

		setTimeout("$('#cajaLista').hide();", 200);		

		if(garantiaID != '' && !isNaN(garantiaID) && garantiaID > 0){
			garantiaAgroServicioScript.consultaGarantia(tipConPrincipal,garantiaBean,function(data) {
				if(data!=null){
					creaCamposPorDocumento(data.tipoDocumentoID,efectoNo);
					dwr.util.setValues(data);
	
					agregaFormatoControles('formaGenerica');
					consultaClasificacionesGarantias(data.tipoGarantiaID,data.clasifGarantiaID);	
					$('#valorComercial').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					$('#montoAsignado').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
					muestraAseguradora();
					validagravemen(data.tipoGravemen);
					if($.trim(data.estadoGarante) != ''){
						consultaEstadoGarante('estadoGarante');
					}
					if($.trim(data.municipioGarante ) != ''){
						consultaMunicipioGarante('municipioGarante');     
					}
					if($.trim(data.garanteNombre) != ''){
						$('#direccionGarante').show();   
					}
					if(data.notarioID!='0' && data.notarioID!='') {
						consultaNotaria('notarioID');
					}
					if(data.clienteID!=0){						
						consultaCliente('clienteID', 'clienteNombre');
					}else{
						$('#clienteID').val('');
						$('#clienteNombre').val('');
					}
					if(data.prospectoID!=0){						
						consultaProspectos('prospectoID');
					}else{
						$('#prospectoID').val('');
						$('#prospectoNombre').val('');
					}
					if(data.estadoID!=0){
						consultaEstado('estadoID');
					}else{
						$('#estadoID').val('');
						$('#nombreEstado').val('');
					}
					if(data.municipioID!=0){
						consultaMunicipio('municipioID');
					}else{
						$('#municipioID').val('');
						$('#nombreMuni').val('');
					}
					if(data.localidadIDGarante!=0){
						consultaLocalidadGarante('localidadIDGarante');
					}else{
						$('#localidadIDGarante').val('');
						$('#nombrelocalidadGarante').val('');
					}
					if(data.coloniaID!=0){
						consultaColonia('coloniaID');
					}else{
						$('#coloniaID').val('');
						$('#coloniaGarante').val('');
					}

					validaGarantiaVeridicada('verificada');
					var m2Cons = data.m2Construccion ;

					if(parseInt(m2Cons) == data.m2Construccion){
						$('#m2Construccion').val(parseInt(m2Cons));						
					}else{
						if(m2Cons.substring(m2Cons.length-1, m2Cons.length) == 0){
							$('#m2Construccion').val(m2Cons.substring(0,m2Cons.length-1));							
						}
					}
					var m2Terr = data.m2Terreno ;

					if(parseInt(m2Terr) == data.m2Terreno){
						$('#m2Terreno').val(parseInt(m2Terr));						
					}else{
						if(m2Terr.substring(m2Terr.length-1, m2Terr.length) == 0){
							$('#m2Terreno').val(m2Terr.substring(0,m2Terr.length-1));							
						}
					}
					
					deshabilitaBoton('grabar', 'submit');
					habilitaBoton('modificar', 'submit');
				}else{
					mensajeSis("La garantía no existe");
					inicializaFormularioGarantia();
					$(jqGarantia).val("");
					$(jqGarantia).focus();
				}    	 						
			});
		}else{
			if(isNaN(garantiaID)){
				mensajeSis("La garantía no existe");
				inicializaFormularioGarantia();
				$(jqGarantia).val("");
				$(jqGarantia).focus();
			}else{
				if(garantiaID == '' || garantiaID == 0){
					$(jqGarantia).val("");	
				}
			}
		} 
	}

	//FUNCION INICIALIZA PANTALLA
	function inicializaFormularioGarantia(){
		inicializaForma('formaGenerica', 'garantiaID');
		creaCamposPorDocumento('','N');
		habilitaBoton('grabar', 'submit');
		deshabilitaBoton('grabar', 'submit');
		deshabilitaBoton('modificar', 'submit');
		limpiaForm($('#formaGenerica'));
		agregaFormatoControles('formaGenerica');
		$('#garantiaID').val('0');
		$('#direccionGarante').hide();
		$('#garanteNombre').val('');   
		limpiaDireccionGarante();
		
		$('#tipoGarantiaID').val('');
		$('#clasifGarantiaID').val('');
		$('#tipoDocumentoID').val('');
		$('#asegurado').val('');
		$('#verificada').val('');
		$('#fechaVerificacion').datepicker("destroy");
		$('#tipoGravemen').val('');
		$('#proporcion').val('');
		$('#usuafructuariaNo').val('N').attr('checked',true);

	}

	function validagravemen(tipoGravemen){
		var grabado='G';
		var libre='L';
		if(tipoGravemen == grabado){
			$('#trEstatusGrabado').show();
			$('#trNombreBenefi').show();
		}
		if(tipoGravemen == libre){
			$('#trEstatusGrabado').hide();
			$('#trNombreBenefi').hide();
		}
		if(tipoGravemen == ""){
			$('#trEstatusGrabado').hide();
			$('#trNombreBenefi').hide();
		}
	}

	$('#formaGenerica').validate({
		rules: {
			garantiaID: {
				required: true
			},
			fechaCompFactura : {
				required: true
			},
			rfcEmisor : {
				required : true,
				minlength : 12,
				maxlength : 13
			},
			fechaRegistro:{
				required: true
			},
			valorFactura: {
				number: true,
				required: true,
			},
			serieFactura : {
				required: true
			},
			calle : {
				required: true
			},
			colonia : {
				required: true
			},
			codigoPostal : {
				required: true,
				number: true,
			},
			folioRegistro : {
				required: true
			},
			nombreAutoridad : {
				required: true
			},
			valorComercial: {
				required: true,
				number: true,
			},
			m2Construccion: {
				number: true,
			},
			m2Terreno : {
				number: true,
			},
			observaciones : {
				required: true
			},
			tipoGarantiaID : {
				required: true
			},
			clasifGarantiaID : {
				required: true
			},
			fechaVerificacion : {
				required: function() {if($('#verificada').val() == 'S'){return true;}else{return false;} },
			},
			tipoGravemen : {
				required: true
			}	
		},		
		messages: {
			garantiaID: {
				required: 'Especifique Folio'
			},
			fechaCompFactura : {
				required: 'Especifique Fecha'
			},
			rfcEmisor	: {
				required	: 'Especifique RFC ',
				minlength : 'Mínimo 12 caracteres',
				maxlength : 'Máximo 13 caracteres'
			},
			fechaRegistro:{
				required: 'Especifique Fecha'
			},
			valorFactura : {
				number: 'Sólo números',
				required: 'Especifique el valor',
			},
			serieFactura : {
				required: 'Especifique Serie'
			},
			calle : {
				required: 'Especifique la Calle'
			},
			colonia : {
				required: 'Especifique la Colonia'
		    },
		    codigoPostal : {
		    	required: 'Especifique Código Postal',
		    	number: 'Sólo números',
		    },
		    folioRegistro :{
		    	required: 'Especifique Folio de Registro'
		    },
		    nombreAutoridad : {
		    	required: 'Especifique el Nombre de la Autoridad'
		    },
		    valorComercial: {
		    	required: 'Especifique el Valor Comercial',
				number: 'Sólo números',
		    },
		    m2Construccion: {
				number: 'Sólo números',
		    },
		    m2Terreno: {
		    	number: 'Sólo números',
		    },
		    observaciones: {
		    	required: 'Especifique observaciones',
		    },
		    tipoGarantiaID: {
		    	required: 'Especifique Tipo de Garantía',
		    },
		    clasifGarantiaID: {
		    	required: 'Especifique Clasificación Garantía',
		    },
		    fechaVerificacion: {
		    	required: 'Especifique la Fecha de Verificación',
		    },
		    tipoGravemen: {
		    	required: 'Especifique Estatus del Gravamen',
		    },
		    proporcion: {
				maxlength : 'Máximo 14 caracteres'
		    }

		   }
		    		
	});
	

	$('#proporcion').blur(function() {
		if ($('#proporcion').val=='' && esTab==true) {
				$('#proporcion').val("0.00");	
		}
	});


	$('#proporcion').keyup(function() {
		if( isNaN($('#proporcion').val())){
				$('#proporcion').val("0.00");	
			}
	});

	//FUNCION QUE MUESTRA LA SECCION DEPENDIENDO EL TIPO DE DOCUMENTO SELECCIONADO
	function creaCamposPorDocumento(documentoID,efecto){
		switch (documentoID){
			case '12':
				creaParamsFactura(efecto);
			break;
			case '13':
				creaParamsTestimonioNotarial();
				break;
	
			case '14':
				creaParamsActaPosecion();
				break;
	
			case '15':
				creaParamsReciboSimple();
				break; 	 
				
			case '77':
				creaParamsConstanciaPosesion();
				break;  
				
			case '':
				$('#contenedorParametros').html("");
				$('#contenedorParametros').hide();	
				break; 	 
		}			
	}

	
	//FUNCION CREACION DE SECCION ACTA DE POSESION
	function creaParamsActaPosecion(){
		var nuevoHtml='	<div id="contenedorParametros">	';
		nuevoHtml +='<fieldset class="ui-widget ui-widget-content ui-corner-all">';
		nuevoHtml +='<legend>Acta de Posesión</legend>';
		nuevoHtml +='<table border="0"> ';  
		nuevoHtml +='	<tr> ';
		nuevoHtml +='		<td class="label" nowrap="nowrap">';
		nuevoHtml +='			<label for="estadoID">Estado: </label> </td>'; 
		nuevoHtml +='		<td nowrap="nowrap"><input id="estadoID" name="estadoID" path="estadoID" size="8" tabindex="45" autocomplete="off" /> '; 
		nuevoHtml +='			<input type = "text" id="nombreEstado" name="nombreEstado" disabled="true" size="35"  /></td>';
		nuevoHtml +='		<td class="separador"></td>'; 
		nuevoHtml +='		<td class="label" nowrap="nowrap"> <label for="municipioID">Municipio: </label> </td> ';
		nuevoHtml +='		<td nowrap="nowrap"><input id="municipioID" name="municipioID" path="municipioID" size="8" tabindex="46" autocomplete="off" /> ';
		nuevoHtml +='			<input type = "text" id="nombreMuni" name="nombreMuni" disabled="true" size="35"  />  </td>';
		nuevoHtml +='	</tr>  ';
		nuevoHtml +='	<tr>';
		nuevoHtml +='		<td class="label" nowrap="nowrap"><label for="calle">Calle: </label> 	</td> ';
		nuevoHtml +='		<td> <input id="calle"  onblur=" ponerMayusculas(this)" name="calle" path="calle" size="40" tabindex="47"  maxlength="100" autocomplete="off"/>  </td>';
		nuevoHtml +='		<td class="separador"></td> ';
		nuevoHtml +='		<td class="label" nowrap="nowrap"> <label for="numero">N&uacute;mero Exterior: </label> </td> ';
		nuevoHtml +='		<td> <input id="numero" name="numero" path="numero" size="8" tabindex="48" maxlength="10" autocomplete="off" /> </td>';
		nuevoHtml +='	</tr>';  
		nuevoHtml +='	<tr> ';
		nuevoHtml +='		<td class="label"> <label for="numeroInt">N&uacute;mero Interior:</label> </td> ';
		nuevoHtml +='		<td>  <input id="numeroInt" name="numeroInt" path="numeroInt" size="8" tabindex="49" maxlength="10" autocomplete="off" />  </td>';
		nuevoHtml +='		<td class="separador"></td> ';
		nuevoHtml +='		<td class="label"> <label for="colonia">Colonia: </label> </td> ';
		nuevoHtml +='		<td> <input id="colonia" name="colonia" path="colonia"  onblur=" ponerMayusculas(this)" size="40" tabindex="50" maxlength="100" autocomplete="off" /> </td>';
		nuevoHtml +='	</tr> ';           
		nuevoHtml +='	<tr> ';
		nuevoHtml +='		<td class="label" nowrap="nowrap"> <label for="lote">Lote: </label> </td> ';
		nuevoHtml +='		<td>  <input id="lote" name="lote" path="lote" size="8" tabindex="51"  maxlength="10" autocomplete="off"/> </td>';
		nuevoHtml +='		<td class="separador"></td> ';
		nuevoHtml +='		<td class="label"> <label for="manzana">Manzana:</label> </td> ';
		nuevoHtml +='		<td>  <input id="manzana" name="manzana" path="manzana" size="8" tabindex="52" maxlength="100" autocomplete="off" />  </td>';
		nuevoHtml +='	</tr>';            
		nuevoHtml +='	<tr>'; 
		nuevoHtml +='		<td class="label"> <label for="codigoPostal">C&oacute;digo Postal:</label> </td> ';
		nuevoHtml +='		<td> <input id="codigoPostal" name="codigoPostal" path="codigoPostal" size="8" tabindex="53" maxlength="10" autocomplete="off" />  </td>';
		nuevoHtml +='		<td class="separador"></td> ';
		nuevoHtml +='		<td class="label" nowrap="nowrap"> <label for="m2Construccion">Metros Cuadrados de Construcci&oacute;n: </label> </td> ';
		nuevoHtml +='		<td> <input id="m2Construccion" name="m2Construccion" path="m2Construccion" size="8" tabindex="54" maxlength="10" autocomplete="off" /> </td>';
		nuevoHtml +='	</tr> ';           
		nuevoHtml +='	<tr> ';
		nuevoHtml +='		<td class="label" nowrap="nowrap"> <label for="m2Terreno">Metros Cuadrados de Terreno: </label> </td> ';
		nuevoHtml +='		<td> <input id="m2Terreno" name="m2Terreno" path="m2Terreno" size="8" tabindex="55" maxlength="10" autocomplete="off" /> </td>';
		nuevoHtml +='		<td class="separador"></td> ';
		nuevoHtml +='		<td class="label" nowrap="nowrap"> <label for="asegurado">Garant&iacute;a Asegurada </label> </td> ';
		nuevoHtml +=' 		<td><select id="asegurado" name="asegurado"  path="asegurado" onChange="muestraAseguradora();"  tabindex="56" autocomplete="off">';
		nuevoHtml +='			<option value="">SELECCIONAR</option> ';
		nuevoHtml +='			<option value="S">SI</option> ';  	
		nuevoHtml +='			<option value="N">NO</option> ';
		nuevoHtml +='  			</select></td>';
		nuevoHtml +='	</tr> '; 
		nuevoHtml +=' 	<tr id="trAsegurador">'; 
		nuevoHtml +='		<td class="label"> <label for="asegurador">Asegurador: </label> </td> ';
		nuevoHtml +='   	<td> <input id="asegurador"   name="asegurador" path="asegurador"  onblur=" ponerMayusculas(this)"  size="40" tabindex="57" maxlength="45" autocomplete="off"  /> </td>';
		nuevoHtml +=' 		<td class="separador"></td> ';
		nuevoHtml +='		<td class="label"> <label for="numPoliza">Número de Póliza: </label> </td> ';
		nuevoHtml +='   	<td> <input id="numPoliza"   name="numPoliza" path="numPoliza"   size="13" tabindex="58" maxlength="13" onkeypress="return validaSoloNumero(event,this);" autocomplete="off"  /> </td>';
		nuevoHtml +=' 	</tr> ';  
		nuevoHtml +=' 	<tr id="trFechVencimiento">'; 
		nuevoHtml +='		<td class="label" nowrap="nowrap"> <label for="vencimientoPoliza">Fecha de Vencimiento: </label> </td> ';
		nuevoHtml +='   	<td> <input id="vencimientoPoliza"  name="vencimientoPoliza" path="vencimientoPoliza" esCalendario="true" onchange="validaFechaVenPol()" size="11" tabindex="59" maxlength="10" autocomplete="off" /> </td>';
		nuevoHtml +=' 	</tr> ';
		nuevoHtml +=' 	<tr>'; 
		nuevoHtml +='		<td class="label"> <label for="nombreAutoridad"> Autoridad: </label> </td> ';
		nuevoHtml +=' 		<td> <input id="nombreAutoridad" name="nombreAutoridad"  onblur=" ponerMayusculas(this)"  size="40" tabindex="60" maxlength="45" autocomplete="off" />  </td>';
		nuevoHtml +=' 		<td class="separador"></td> ';
		nuevoHtml +='		<td class="label" nowrap="nowrap"> <label for="folioRegistro">Folio de Registro: </label> </td> ';
		nuevoHtml +='   	<td> <input id="folioRegistro"   name="folioRegistro" path="folioRegistro" size="11" tabindex="61" maxlength="45" autocomplete="off" /> </td>';
		nuevoHtml +=' 	</tr> ';      		     	
		nuevoHtml +='	<tr>'; 
		nuevoHtml +='		<td class="label" nowrap="nowrap"> <label for="cargoAutoridad">Cargo de Autoridad: </label> </td> ';
		nuevoHtml +='		<td> <input id="cargoAutoridad"   name="cargoAutoridad"  onblur=" ponerMayusculas(this)" path="cargoAutoridad"  size="40" tabindex="62" maxlength="45" autocomplete="off" /> </td>';
		nuevoHtml +=' 		<td class="separador"></td> ';
		nuevoHtml +='		<td class="label" nowrap="nowrap"> <label for="fechaRegistro">Fecha de Registro: </label> </td> ';
		nuevoHtml +='   	<td> <input id="fechaRegistro"  name="fechaRegistro" path="fechaRegistro" esCalendario="true" onchange="validaFechaReg(); mayorFecha(this.id);"  size="11" tabindex="63" maxlength="45" autocomplete="off" /> </td>';
		nuevoHtml +='	</tr> ';      		     	
		nuevoHtml +='</table>	 </fieldset> </div>';

		$('#contenedorParametros').replaceWith(nuevoHtml);
		$('#contenedorParametros').hide();
		$('#contenedorParametros').show();

		$('#estadoID').bind('keyup',function(e){
			lista('estadoID', '1', '1', 'nombre', $('#estadoID').val(), 'listaEstados.htm');
		});

		$('#municipioID').bind('keyup',function(e){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "estadoID";
			camposLista[1] = "nombre";
			
			
			parametrosLista[0] = $('#estadoID').val();
			parametrosLista[1] = $('#municipioID').val();
			
			if($('#estadoID').val() != '' && $('#estadoID').asNumber() > 0 ){
				lista('municipioID', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
			}else{
				if($('#municipioID').val().length >= 3){
					$('#estadoID').focus();
					$('#municipioID').val('');
					$('#nombreMunicipio').val('');
					mensajeSis('Especificar Estado');
				}			
			}		
		
		});

		$('#estadoID').blur(function() {
			setTimeout("$('#cajaLista').hide();", 200);
			if($('#estadoID').val() 	!= 	'' &&	$('#estadoID').val() > 0	&&	!isNaN($('#estadoID').val())){
				consultaEstado(this.id);
			}else{
				$('#nombreEstado').val("");
				$('#estadoID').val("");
			}

		});
		
		$('#municipioID').blur(function() {
			setTimeout("$('#cajaLista').hide();", 200);
			if($('#municipioID').val() 	!= 	'' &&	$('#municipioID').val() > 0	&&	!isNaN($('#municipioID').val())){
				consultaMunicipio(this.id);
			}else{
				$('#nombreMuni').val("");
				$('#municipioID').val("");
			}
		});
		
		muestraAseguradora();
	}

	//FUNCION CREACION DE SECCION CONSTANCIA DE POSESION
	function creaParamsConstanciaPosesion(){
		var nuevoHtml='	<div id="contenedorParametros">	';
		nuevoHtml +='<fieldset class="ui-widget ui-widget-content ui-corner-all">';
		nuevoHtml +='<legend>Constancia de Posesión</legend>';
		nuevoHtml +='<table border="0"> ';  
		nuevoHtml +='	<tr> ';
		nuevoHtml +='		<td class="label" nowrap="nowrap"><label for="estadoID">Estado: </label> </td>'; 
		nuevoHtml +='		<td nowrap="nowrap"> <input id="estadoID" name="estadoID" path="estadoID" size="8" tabindex="45" autocomplete="off" /> '; 
		nuevoHtml +='			<input type = "text" id="nombreEstado" name="nombreEstado" disabled="true" size="35"  /></td>';
		nuevoHtml +='		<td class="separador"></td>'; 
		nuevoHtml +='		<td class="label" nowrap="nowrap"> <label for="municipioID">Municipio: </label> </td> ';
		nuevoHtml +='		<td nowrap="nowrap">  <input id="municipioID" name="municipioID" path="municipioID" size="8" tabindex="46" autocomplete="off" /> ';
		nuevoHtml +='			<input type = "text" id="nombreMuni" name="nombreMuni" disabled="true" size="35"  />  </td>';
		nuevoHtml +='	</tr>  ';
		nuevoHtml +='	<tr>';
		nuevoHtml +='		<td class="label"> 	<label for="calle">Calle: </label> 	</td> ';
		nuevoHtml +='		<td> <input id="calle"  onblur=" ponerMayusculas(this)" name="calle" path="calle" size="40" tabindex="47" maxlength="100" autocomplete="off" />  </td>';
		nuevoHtml +='		<td class="separador"></td> ';
		nuevoHtml +='		<td class="label"> <label for="numero">N&uacute;mero Exterior: </label> </td> ';
		nuevoHtml +='		<td> <input id="numero" name="numero" path="numero" size="8" tabindex="48" maxlength="10" autocomplete="off" /> </td>';
		nuevoHtml +='	</tr>';  
		nuevoHtml +='	<tr> ';
		nuevoHtml +='		<td class="label"> <label for="numeroInt">N&uacute;mero Interior:</label> </td> ';
		nuevoHtml +='		<td>  <input id="numeroInt" name="numeroInt" path="numeroInt" size="8" tabindex="49" maxlength="10" autocomplete="off" />  </td>';
		nuevoHtml +='		<td class="separador"></td> ';
		nuevoHtml +='		<td class="label"> <label for="colonia">Colonia: </label> </td> ';
		nuevoHtml +='		<td> <input id="colonia" name="colonia" path="colonia"  onblur=" ponerMayusculas(this)" size="40" tabindex="50" maxlength="100" autocomplete="off" /> </td>';
		nuevoHtml +='	</tr> ';           
		nuevoHtml +='	<tr> ';
		nuevoHtml +='		<td class="label"> <label for="lote">Lote: </label> </td> ';
		nuevoHtml +='		<td>  <input id="lote" name="lote" path="lote" size="8" tabindex="51" maxlength="10" autocomplete="off" /> </td>';
		nuevoHtml +='		<td class="separador"></td> ';
		nuevoHtml +='		<td class="label"> <label for="manzana">Manzana:</label> </td> ';
		nuevoHtml +='		<td>  <input id="manzana" name="manzana" path="manzana" size="8" tabindex="52" maxlength="100" autocomplete="off" />  </td>';
		nuevoHtml +='	</tr>';            
		nuevoHtml +='	<tr>'; 
		nuevoHtml +='		<td class="label"> <label for="codigoPostal">C&oacute;digo Postal:</label> </td> ';
		nuevoHtml +='		<td> <input id="codigoPostal" name="codigoPostal" path="codigoPostal" size="8" tabindex="53" maxlength="10" autocomplete="off" />  </td>';
		nuevoHtml +='		<td class="separador"></td> ';
		nuevoHtml +='		<td class="label" nowrap="nowrap"> <label for="m2Construccion">Metros Cuadrados de Construcci&oacute;n: </label> </td> ';
		nuevoHtml +='		<td> <input id="m2Construccion" name="m2Construccion" path="m2Construccion" size="8" tabindex="54" maxlength="10" autocomplete="off"/> </td>';
		nuevoHtml +='	</tr> ';           
		nuevoHtml +='	<tr> ';
		nuevoHtml +='		<td class="label" nowrap="nowrap"> <label for="m2Terreno">Metros Cuadrados de Terreno: </label> </td> ';
		nuevoHtml +='		<td> <input id="m2Terreno" name="m2Terreno" path="m2Terreno" size="8" tabindex="55" maxlength="10" autocomplete="off"/> </td>';
		nuevoHtml +='		<td class="separador"></td> ';
		nuevoHtml +='		<td class="label"> <label for="asegurado">Garant&iacute;a Asegurada </label> </td> ';
		nuevoHtml +=' 		<td><select id="asegurado" name="asegurado"  path="asegurado" onChange="muestraAseguradora();"  tabindex="56">';
		nuevoHtml +='			<option value="">SELECCIONAR</option> ';
		nuevoHtml +='			<option value="S">SI</option> ';  	
		nuevoHtml +='			<option value="N">NO</option> ';
		nuevoHtml +='  			</select></td>';
		nuevoHtml +='	</tr> '; 
		nuevoHtml +=' 	<tr id="trAsegurador">'; 
		nuevoHtml +='		<td class="label"> <label for="asegurador">Asegurador: </label> </td> ';
		nuevoHtml +='  		<td> <input id="asegurador"   name="asegurador" path="asegurador"  onblur=" ponerMayusculas(this)"  size="47" tabindex="57" maxlength="45" autocomplete="off"  /> </td>';
		nuevoHtml +=' 		<td class="separador"></td> ';
		nuevoHtml +='		<td class="label"> <label for="numPoliza">Número de Póliza: </label> </td> ';
		nuevoHtml +='  		<td> <input id="numPoliza"   name="numPoliza" path="numPoliza"   size="13" tabindex="58" maxlength="13" onkeypress="return validaSoloNumero(event,this);" autocomplete="off" /> </td>';
		nuevoHtml +=' 	</tr> ';  
		nuevoHtml +=' 	<tr id="trFechVencimiento">'; 
		nuevoHtml +='		<td class="label"  nowrap="nowrap"> <label for="vencimientoPoliza">Fecha de Vencimiento: </label> </td> ';
		nuevoHtml +='   	<td> <input id="vencimientoPoliza"  name="vencimientoPoliza" path="vencimientoPoliza" esCalendario="true" onchange="validaFechaVenPol()" size="11" tabindex="59" maxlength="10" autocomplete="off" /> </td>';
		nuevoHtml +=' 	</tr> ';
		nuevoHtml +=' 	<tr>'; 
		nuevoHtml +='		<td class="label"> <label for="nombreAutoridad"> Autoridad: </label> </td> ';
		nuevoHtml +=' 		<td> <input id="nombreAutoridad" name="nombreAutoridad"  onblur=" ponerMayusculas(this)"  size="48" tabindex="60" maxlength="45" autocomplete="off"/>  </td>';
		nuevoHtml +=' 		<td class="separador"></td> ';
		nuevoHtml +='		<td class="label"> <label for="folioRegistro">Folio de Registro: </label> </td> ';
		nuevoHtml +='   	<td> <input id="folioRegistro"   name="folioRegistro" path="folioRegistro" size="11" tabindex="61" maxlength="45" autocomplete="off" /> </td>';
		nuevoHtml +=' 	</tr> ';      		     	
		nuevoHtml +='	<tr>'; 
		nuevoHtml +='		<td class="label"> <label for="cargoAutoridad">Cargo de Autoridad: </label> </td> ';
		nuevoHtml +='		<td> <input id="cargoAutoridad"   name="cargoAutoridad"  onblur=" ponerMayusculas(this)" path="cargoAutoridad"  size="48" tabindex="62" maxlength="45" autocomplete="off"/> </td>';
		nuevoHtml +='		<td class="separador"></td> ';
		nuevoHtml +='		<td class="label"> <label for="fechaRegistro">Fecha de Registro: </label> </td> ';
		nuevoHtml +='   	<td> <input id="fechaRegistro"  name="fechaRegistro" path="fechaRegistro" esCalendario="true" onchange="validaFechaReg(); mayorFecha(this.id);"  size="11" tabindex="63" maxlength="10" autocomplete="off" /> </td>';
		nuevoHtml +='	</tr> ';      		     	
		nuevoHtml +='</table>	 </fieldset> </div>';

		$('#contenedorParametros').replaceWith(nuevoHtml);
		$('#contenedorParametros').hide();
		$('#contenedorParametros').show();

		$('#estadoID').bind('keyup',function(e){
			lista('estadoID', '1', '1', 'nombre', $('#estadoID').val(), 'listaEstados.htm');
		});
		
		$('#municipioID').bind('keyup',function(e){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "estadoID";
			camposLista[1] = "nombre";
			
			
			parametrosLista[0] = $('#estadoID').val();
			parametrosLista[1] = $('#municipioID').val();
			
			if($('#estadoID').val() != '' && $('#estadoID').asNumber() > 0 ){
				lista('municipioID', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
			}else{
				if($('#municipioID').val().length >= 3){
					$('#estadoID').focus();
					$('#municipioID').val('');
					$('#nombreMunicipio').val('');
					mensajeSis('Especificar Estado');
				}			
			}		
		
		});

		$('#estadoID').blur(function() {
			setTimeout("$('#cajaLista').hide();", 200);
			if($('#estadoID').val() 	!= 	'' &&	$('#estadoID').val() > 0	&&	!isNaN($('#estadoID').val())){
				consultaEstado(this.id);
			}else{
				$('#nombreEstado').val("");
				$('#estadoID').val("");
			}

		});
		
		$('#municipioID').blur(function() {
			setTimeout("$('#cajaLista').hide();", 200);
			if($('#municipioID').val() 	!= 	'' &&	$('#municipioID').val() > 0	&&	!isNaN($('#municipioID').val())){
				consultaMunicipio(this.id);
			}else{
				$('#nombreMuni').val("");
				$('#municipioID').val("");
			}
		});
		
		muestraAseguradora();
	}

	//FUNCION CREACION DE SECCION TESTIMONIO NOTARIAL
	function creaParamsTestimonioNotarial(){
		var nuevoHtml='	<div id="contenedorParametros">	';
		nuevoHtml +='<fieldset class="ui-widget ui-widget-content ui-corner-all">';
		nuevoHtml +='<legend>Testimonio Notarial</legend>';
		nuevoHtml +='<table border="0"> ';  
		nuevoHtml +='	<tr> ';
		nuevoHtml +='		<td class="label" nowrap="nowrap"> 	<label for="estadoID">Estado: </label> </td>'; 
		nuevoHtml +=' 		<td nowrap="nowrap"> <input id="estadoID" name="estadoID" path="estadoID" size="8" tabindex="27"  autocomplete="off"/> '; 
		nuevoHtml +=' 			<input type = "text" id="nombreEstado" name="nombreEstado" disabled="true" size="35"  /></td>';
		nuevoHtml +='		<td class="separador"></td>'; 
		nuevoHtml +=' 		<td class="label"> <label for="municipioID">Municipio: </label> </td> ';
		nuevoHtml +='		<td nowrap="nowrap">  <input id="municipioID" name="municipioID" path="municipioID" size="8" tabindex="28" autocomplete="off" /> ';
		nuevoHtml +='  			<input type = "text" id="nombreMuni" name="nombreMuni" disabled="true" size="35"  />  </td>';
		nuevoHtml +='	</tr>  ';
		nuevoHtml +=' 	<tr>';
		nuevoHtml +='		<td class="label"> 	<label for="calle">Calle: </label> 	</td> ';
		nuevoHtml +='		<td> <input id="calle" name="calle" path="calle" size="40"  onblur=" ponerMayusculas(this)" tabindex="29" maxlength="100" autocomplete="off" />  </td>';
		nuevoHtml +='		<td class="separador"></td> ';
		nuevoHtml +=' 		<td class="label"> <label for="numero">N&uacute;mero Exterior: </label> </td> ';
		nuevoHtml +='		<td> <input id="numero" name="numero" path="numero" size="8" tabindex="30" maxlength="10" autocomplete="off" /> </td>';
		nuevoHtml +='	</tr>';  
		nuevoHtml +='	<tr> ';
		nuevoHtml +='		<td class="label"> <label for="numeroInt">N&uacute;mero Interior:</label> </td> ';
		nuevoHtml +='		<td>  <input id="numeroInt" name="numeroInt" path="numeroInt" size="8" tabindex="31" maxlength="10" autocomplete="off" />  </td>';
		nuevoHtml +='		<td class="separador"></td> ';
		nuevoHtml +='		<td class="label"> <label for="colonia">Colonia: </label> </td> ';
		nuevoHtml +=' 		<td> <input id="colonia" name="colonia" path="colonia" size="40"  onblur=" ponerMayusculas(this)" tabindex="32" maxlength="100" autocomplete="off" /> </td>';
		nuevoHtml +='	</tr> ';           
		nuevoHtml +=' 	<tr> ';
		nuevoHtml +=' 		<td class="label"> <label for="lote">Lote: </label> </td> ';
		nuevoHtml +=' 		<td>  <input id="lote" name="lote" path="lote" size="8" tabindex="33" maxlength="10" autocomplete="off" /> </td>';
		nuevoHtml +=' 		<td class="separador"></td> ';
		nuevoHtml +='		<td class="label"> <label for="manzana">Manzana:</label> </td> ';
		nuevoHtml +='		<td>  <input id="manzana" name="manzana" path="manzana" size="8" tabindex="34" maxlength="100" autocomplete="off" />  </td>';
		nuevoHtml +=' 	</tr>';            
		nuevoHtml +='	<tr>'; 
		nuevoHtml +='		<td class="label"> <label for="codigoPostal">C&oacute;digo Postal:</label> </td> ';
		nuevoHtml +='		<td> <input id="codigoPostal" name="codigoPostal" path="codigoPostal" size="8" tabindex="35" maxlength="10" autocomplete="off" />  </td>';
		nuevoHtml +=' 		<td class="separador"></td> ';
		nuevoHtml +=' 		<td class="label" nowrap="nowrap"> <label for="m2Construccion">Metros Cuadrados de Construcci&oacute;n: </label> </td> ';
		nuevoHtml +=' 		<td> <input id="m2Construccion" name="m2Construccion" path="m2Construccion" size="8" tabindex="36" maxlength="10" autocomplete="off" /> </td>';
		nuevoHtml +='	</tr> ';           
		nuevoHtml +=' 	<tr> ';
		nuevoHtml +='		<td class="label" nowrap="nowrap"> <label for="m2Terreno">Metros Cuadrados de Terreno: </label> </td> ';
		nuevoHtml +='  		<td> <input id="m2Terreno" name="m2Terreno" path="m2Terreno" size="8" tabindex="37" maxlength="10" autocomplete="off" /> </td>';
		nuevoHtml +='		<td class="separador"></td> ';
		nuevoHtml +='		<td class="label"> <label for="asegurado">Garant&iacute;a Asegurada </label> </td> ';
		nuevoHtml +=' 		<td><select id="asegurado" name="asegurado"  path="asegurado" onChange="muestraAseguradora();"  tabindex="38" autocomplete="off">';
		nuevoHtml +='			<option value="">SELECCIONAR</option> ';
		nuevoHtml +='			<option value="S">SI</option> '; 
		nuevoHtml +='			<option value="N">NO</option> '; 	
		nuevoHtml +=' 			</select></td>';
		nuevoHtml +=' </tr> ';      		     	
		nuevoHtml +=' <tr id="trAsegurador">'; 
		nuevoHtml +='	<td class="label"> <label for="asegurador">Asegurador: </label> </td> ';
		nuevoHtml +='   <td> <input id="asegurador"   name="asegurador" path="asegurador"   onblur=" ponerMayusculas(this)" size="48" tabindex="39" maxlength="45" autocomplete="off"  /> </td>';
		nuevoHtml +=' <td class="separador"></td> ';
		nuevoHtml +='	<td class="label"> <label for="numPoliza">Número de Póliza: </label> </td> ';
		nuevoHtml +='   <td> <input id="numPoliza"   name="numPoliza" path="numPoliza"   size="13"  tabindex="40"  maxlength="13" onkeypress="return validaSoloNumero(event,this);" autocomplete="off"  /> </td>';
		nuevoHtml +=' </tr> ';  
		nuevoHtml +=' <tr id="trFechVencimiento">'; 
		nuevoHtml +='	<td class="label"> <label for="vencimientoPoliza">Fecha de Vencimiento: </label> </td> ';
		nuevoHtml +='   <td> <input id="vencimientoPoliza"  name="vencimientoPoliza" path="vencimientoPoliza" esCalendario="true" onchange="validaFechaVenPol()" size="11" tabindex="41"  maxlength="10" autocomplete="off"/> </td>';
		nuevoHtml +=' </tr> '; 
		nuevoHtml +=' <tr>'; 
		nuevoHtml +='	<td class="label"> <label for="folioRegistro">Folio de Registro: </label> </td> ';
		nuevoHtml +='   <td> <input id="folioRegistro"   name="folioRegistro" path="folioRegistro" size="11" tabindex="42" maxlength="45" autocomplete="off" /> </td>';
		nuevoHtml +=' <td class="separador"></td> ';
		nuevoHtml +='	<td class="label"> <label for="notarioID">Número de Notario: </label> </td> ';
		nuevoHtml +='   <td nowrap="nowrap"> <input id="notarioID"   name="notarioID" path="notarioID"   size="8" tabindex="43" autocomplete="off" />  ';
		nuevoHtml +='  <input type "text" id="nombreNotario" name="nombreNotario" disabled="true" size="35"  />  </td>';
		nuevoHtml +=' </tr> ';  
		nuevoHtml +=' <tr>'; 
		nuevoHtml +='	<td class="label"> <label for="fechaRegistro">Fecha de Registro: </label> </td> ';
		nuevoHtml +='   <td> <input id="fechaRegistro"  name="fechaRegistro" path="fechaRegistro" esCalendario="true" onchange="validaFechaReg()"  size="11" tabindex="44" maxlength="45"  autocomplete="off"/> </td>';
		nuevoHtml +=' </tr> '; 
		nuevoHtml +='</table>	 </fieldset> </div>';
		
		$('#contenedorParametros').replaceWith(nuevoHtml);
		$('#contenedorParametros').hide();
		$('#contenedorParametros').show();
		
		$('#estadoID').bind('keyup',function(e){
			lista('estadoID', '1', '1', 'nombre', $('#estadoID').val(), 'listaEstados.htm');
		});
		
		$('#municipioID').bind('keyup',function(e){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "estadoID";
			camposLista[1] = "nombre";
			
			
			parametrosLista[0] = $('#estadoID').val();
			parametrosLista[1] = $('#municipioID').val();
			
			if($('#estadoID').val() != '' && $('#estadoID').asNumber() > 0 ){
				lista('municipioID', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
			}else{
				if($('#municipioID').val().length >= 3){
					$('#estadoID').focus();
					$('#municipioID').val('');
					$('#nombreMunicipio').val('');
					mensajeSis('Especificar Estado');
				}			
			}		
		
		});

		$('#estadoID').blur(function() {
			setTimeout("$('#cajaLista').hide();", 200);
			if($('#estadoID').val() 	!= 	'' &&	$('#estadoID').val() > 0	&&	!isNaN($('#estadoID').val())){
				consultaEstado(this.id);
			}else{
				$('#nombreEstado').val("");
				$('#estadoID').val("");
			}

		});
		
		$('#municipioID').blur(function() {
			setTimeout("$('#cajaLista').hide();", 200);
			if($('#municipioID').val() 	!= 	'' &&	$('#municipioID').val() > 0	&&	!isNaN($('#municipioID').val())){
				consultaMunicipio(this.id);
			}else{
				$('#nombreMuni').val("");
				$('#municipioID').val("");
			}
		});
		
		$('#notarioID').bind('keyup',function(e){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "estadoID";
			camposLista[1] = "municipioID";
			camposLista[2] = "titular";
			parametrosLista[0] = $('#estadoID').val();
			parametrosLista[1] = $('#municipioID').val();
			parametrosLista[2] = $('#notarioID').val();
			
			if($('#estadoID').val() != '' && $('#estadoID').asNumber() > 0 ){
				if($('#municipioID').val()!='' && $('#municipioID').asNumber()>0){
					lista('notarioID', '1', '1', camposLista, parametrosLista, 'listaNotarias.htm');
				}else{
					if($('#notarioID').val().length >= 3){
						$('#municipioID').focus();
						$('#notarioID').val('');
						$('#nombreNotario').val('');
						mensajeSis('Especificar Municipio');
					}
				}
			}else{
				if($('#notarioID').val().length >= 3){
					$('#estadoID').focus();
					$('#notarioID').val('');
					$('#nombreNotario').val('');
					mensajeSis('Especificar Estado');
				}

			}

			
		});

		$('#notarioID').blur(function() {		
			setTimeout("$('#cajaLista').hide();", 200);
			if($('#notarioID').val() 	!= 	'' &&	$('#notarioID').val() > 0	&&	!isNaN($('#notarioID').val())){
				if($('#estadoID').val()!=''  ){
					if($('#municipioID').val() !=''){
						consultaNotaria(this.id);
					}else{
						$('#nombreNotario').val('');
						$('#notarioID').val('');
						mensajeSis("Elija un Municipio  antes de buscar Notaria");
					}
				}else{
					$('#nombreNotario').val('');
					$('#notarioID').val('');
					mensajeSis("Elija un Estado  antes de buscar Notaria");
				}
			}else{
				$('#nombreNotario').val('');
				$('#notarioID').val('');
			}
		});
		
		muestraAseguradora();
	}

	//FUNCION CREACION DE SECCION FACTURA
	function creaParamsFactura(efecto){
		var efectoSi='S';
		var efectoNo='N';
		
		var nuevoHtml='	<div id="contenedorParametros">	';
		nuevoHtml +='<fieldset class="ui-widget ui-widget-content ui-corner-all">';
		nuevoHtml +='<legend>Factura</legend>';
		nuevoHtml +='<table> ';  
		nuevoHtml +='	<tr>';
		nuevoHtml +='		<td class="label"> 	<label for="fechaCompFactura">Fecha de Compra: </label> 	</td> ';
		nuevoHtml +='		<td> <input id="fechaCompFactura" name="fechaCompFactura" path="fechaCompFactura" esCalendario="true" onchange="validaFechaComp()" size="11"  tabindex="18" maxlength="10"  autocomplete="off"/>  </td>';
		nuevoHtml +='		<td class="separador"></td> ';
		nuevoHtml +='		<td class="label"> <label for="rfcEmisor">RFC del Emisor: </label> </td> ';
		nuevoHtml +='		<td> <input id="rfcEmisor" name="rfcEmisor" path="rfcEmisor"  onblur=" ponerMayusculas(this)" size="20" value="" maxlength="13" class="valid" tabindex="19" autocomplete="off" /> </td>';
		nuevoHtml +='	</tr>';  
		nuevoHtml +='	<tr> ';
		nuevoHtml +='		<td class="label"> <label for="valorFactura">Valor de Factura:</label> </td> ';
		nuevoHtml +='		<td>  <input id="valorFactura" esMoneda="true" style="text-align: right;"  name="valorFactura" path="valorFactura" size="15" tabindex="20" autocomplete="off" />  </td>';
		nuevoHtml +='		<td class="separador"></td> ';
		nuevoHtml +='		<td class="label"> <label for="serieFactura">Serie: </label> </td> ';
		nuevoHtml +=' 		<td>  <input id="serieFactura" name="serieFactura" path="serieFactura" size="20" tabindex="21" maxlength="45" autocomplete="off" /> </td>';
		nuevoHtml +='	</tr> ';           
		nuevoHtml +=' 	<tr> ';
		nuevoHtml +=' 		<td class="label"> <label for="referenciafact">Referencia: </label> </td> ';
		nuevoHtml +=' 		<td> <input id="referenciafact" name="referenciafact" path="referenciafact" size="50" tabindex="22" maxlength="45" autocomplete="off"  onblur=" ponerMayusculas(this)"/> </td>';
		nuevoHtml +='		<td class="separador"></td> ';
		nuevoHtml +='		<td class="label"> <label for="asegurado">Garant&iacute;a Asegurada: </label> </td> ';
		nuevoHtml +=' 		<td><select id="asegurado" name="asegurado"  path="asegurado" onChange="muestraAseguradora();"  tabindex="23">';
		nuevoHtml +='			<option value="">SELECCIONAR</option> ';
		nuevoHtml +='			<option value="S">SI</option> ';
		nuevoHtml +='			<option value="N">NO</option> ';  	
		nuevoHtml +='  			</select></td>';
		nuevoHtml +=' 	</tr>';  
		nuevoHtml +=' 	<tr id="trAsegurador">'; 
		nuevoHtml +='		<td class="label"> <label for="asegurador">Asegurador: </label> </td> ';
		nuevoHtml +='   	<td> <input id="asegurador"   name="asegurador" path="asegurador"   size="50"  tabindex="24" maxlength="45" onblur=" ponerMayusculas(this)" autocomplete="off" /> </td>';
		nuevoHtml +=' 		<td class="separador"></td> ';
		nuevoHtml +='		<td class="label"> <label for="numPoliza">Número de Póliza: </label> </td> ';
		nuevoHtml +='   	<td> <input id="numPoliza"   name="numPoliza" path="numPoliza"   size="13" tabindex="25"  maxlength="13" onkeypress="return validaSoloNumero(event,this);" autocomplete="off"/> </td>';
		nuevoHtml +=' 	</tr> ';  
		nuevoHtml +=' 	<tr id="trFechVencimiento">'; 
		nuevoHtml +='		<td class="label"> <label for="vencimientoPoliza">Fecha de <br>Vencimiento: </label> </td> ';
		nuevoHtml +='   	<td> <input id="vencimientoPoliza"  name="vencimientoPoliza" path="vencimientoPoliza" esCalendario="true" onchange="validaFechaVenPol()" size="11" tabindex="26" maxlength="10" autocomplete="off"/> </td>';
		nuevoHtml +=' 	</tr> '; 	     	
		nuevoHtml +='</table>	 </fieldset> </div>';
		
		$('#contenedorParametros').replaceWith(nuevoHtml);
		$('#contenedorParametros').hide();
		
		if(efecto==efectoSi){
			$('#contenedorParametros').show();
		}
		if(efecto==efectoNo){
			$('#contenedorParametros').show();
		}
		
		muestraAseguradora();
	}

	//FUNCION CREACION DE SECCION RECIBO SIMPLE
	function creaParamsReciboSimple(){
		var nuevoHtml='	<div id="contenedorParametros">	';
		nuevoHtml +='<fieldset class="ui-widget ui-widget-content ui-corner-all">';
		nuevoHtml +='<legend>Recibo Simple</legend>';
		nuevoHtml +='<table> ';  
		nuevoHtml +='	<tr>';
		nuevoHtml +='		<td class="label"> 	<label for="fechaCompFactura">Fecha de Compra: </label> 	</td> ';
		nuevoHtml +='		<td> <input id="fechaCompFactura" esCalendario="true" name="fechaCompFactura" path="fechaCompFactura" size="15" onchange="validaFechaComp()" tabindex="64" maxlength="10"  autocomplete="off"/>  </td>';
		nuevoHtml +='		<td class="separador"></td> ';
		nuevoHtml +=' 		<td class="label"> <label for="referenciafact">Referencia: </label> </td> ';
		nuevoHtml +=' 		<td> <input id="referenciafact" name="referenciafact" path="referenciafact" size="50" tabindex="65" maxlength="45"  autocomplete="off"  onblur=" ponerMayusculas(this)"/> </td>';
		nuevoHtml +='	</tr>';  
		nuevoHtml +='	<tr> ';
		nuevoHtml +='		<td class="label"> <label for="valorFactura">Valor del Recibo:</label> </td> ';
		nuevoHtml +='		<td>  <input id="valorFactura" name="valorFactura" esMoneda="true" style="text-align: right;" path="valorFactura" size="15" tabindex="66"  autocomplete="off"/>  </td>';
		nuevoHtml +='		<td class="separador"></td> ';
		nuevoHtml +='		<td class="label"> <label for="serieFactura">Serie: </label> </td> ';
		nuevoHtml +=' 		<td>  <input id="serieFactura" name="serieFactura" path="serieFactura" size="15" tabindex="67"  maxlength="45"  autocomplete="off"/> </td>';
		nuevoHtml +='	</tr> ';           
		nuevoHtml +='</table>	 </fieldset> </div>';
		
		$('#contenedorParametros').replaceWith(nuevoHtml);
		$('#contenedorParametros').hide();
		$('#contenedorParametros').show();
	}
	
	//FUNCION PARA OCULTAR O MOSTRAR CAMPO FECHA DE VERIFICACION
	function validaGarantiaVeridicada(verificadaCombo){
		var garantiaVeri= $('#'+verificadaCombo).val();
		if(garantiaVeri == 'S'){
			habilitaControl('fechaVerificacion');
			$('#fechaVerificacion').datepicker({			
    			showOn: "button",
    			buttonImage: "images/calendar.png",
    			buttonImageOnly: true,
				changeMonth: true, 
				changeYear: true,
				dateFormat: 'yy-mm-dd',
				yearRange: '-100:+10',
				defaultDate: Yfecha			
			});
		}else{
			$('#fechaVerificacion').val('');
			$('#fechaVerificacion').focus();
			$('#verificada').focus();
			deshabilitaControl('fechaVerificacion');
			$('#fechaVerificacion').datepicker("destroy");
		}
	}

});// f i n     d e     j q u e r y

var Yfecha= parametroBean.fechaAplicacion;	

//FUNCION OCULTA O MUESTRA CAMPOS SI TIENE GARANTIA ASEGURADA
function muestraAseguradora(){
	var esAsegurado = $('#asegurado').val();
	var siAsegurado='S';
	var noAsegurado='N';
	if(esAsegurado==siAsegurado){
		$('#trFechVencimiento').show();
		$('#trAsegurador').show();
	}
	if(esAsegurado==noAsegurado){
		$('#trFechVencimiento').hide();
		$('#trAsegurador').hide();
	}
	if(esAsegurado==""){
		$('#trFechVencimiento').hide();
		$('#trAsegurador').hide();
	}
}

//FUNCION VALIDA FECHA DE COMPRA DE FACTURA
function validaFechaComp(){
	if (esFechaValida($('#fechaCompFactura').val())) {		
		$('#fechaCompFactura').val(Yfecha);
		$('#fechaCompFactura').focus();
	}else{
		if(mayor($('#fechaCompFactura').val(),Yfecha)){
			$('#fechaCompFactura').val(Yfecha);
			$('#fechaCompFactura').focus();
		}else{
			$('#fechaCompFactura').focus();
		}
	}
}

//FUNCION VALIDA FECHA DE REGISTRO
function validaFechaReg(){
	if (esFechaValida($('#fechaRegistro').val())) {
		$('#fechaRegistro').val(Yfecha);
		$('#fechaRegistro').focus();
	}else{
		if(mayor($('#fechaRegistro').val(),Yfecha)){
			$('#fechaRegistro').val(Yfecha);
			$('#fechaRegistro').focus();
		}else{
			$('#fechaRegistro').focus();
		}
	}
}

//FUNCION VALIDA FECHA DE VALUACION
function validaFechaVal(){
	if (esFechaValida($('#fechaValuacion').val())) {
			$('#fechaValuacion').val(Yfecha);
			$('#fechaValuacion').focus();
	}else{
		if(mayor($('#fechaValuacion').val(),Yfecha)){
			$('#fechaValuacion').val(Yfecha);
			$('#fechaValuacion').focus();
		}else{
			$('#fechaValuacion').focus();
		}		
	}
}

//FUNCION VALIDA FECHA DE VENCIMIENTO DE POLIZA
function validaFechaVenPol(){
	if (esFechaValida($('#vencimientoPoliza').val())) {
			$('#vencimientoPoliza').val(Yfecha);
			$('#vencimientoPoliza').focus();
	}else{
		$('#vencimientoPoliza').focus();
	}
}

//FUNCION VALIDA FECHA DE VERIFICACION
function validaFechaVer(){
	if (esFechaValida($('#fechaVerificacion').val())) {
			$('#fechaVerificacion').val(Yfecha);
			$('#fechaVerificacion').focus();
	}
	if(mayor($('#fechaVerificacion').val(),Yfecha)){
		$('#fechaVerificacion').val(Yfecha);
		$('#fechaVerificacion').focus();
	}else{
		$('#fechaVerificacion').focus();
	}
}

//FUNCION VALIDA FECHA DE GRAVAMEN
function validaFechaGra(){
	if (esFechaValida($('#fechagravemen').val())) {
			$('#fechagravemen').val(Yfecha);
			$('#fechagravemen').focus();
	}
	if(mayor($('#fechagravemen').val(),Yfecha)){
		$('#fechagravemen').val(Yfecha);
		$('#fechagravemen').focus();
	}else{
		$('#fechagravemen').focus();
	}
}

//FUNCION VALIDA SI UNA FECHA ES NO ES VALIDA = TRUE, VALIDA= FALSE
function esFechaValida(fecha){
	var fecha2 = parametroBean.fechaSucursal;
	if(fecha == ""){return false;}
	if (fecha != undefined  ){
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)){
			mensajeSis("Formato de Fecha no válido (aaaa-mm-dd)");
			return true;
		}
		
		var mes=  fecha.substring(5, 7)*1;
		var dia= fecha.substring(8, 10)*1;
		var anio= fecha.substring(0,4)*1;
		var mes2=  fecha2.substring(5, 7)*1;
		var dia2= fecha2.substring(8, 10)*1;
		var anio2= fecha2.substring(0,4)*1;
				
		switch(mes){
		case 1: case 3:  case 5: case 7:
		case 8: case 10:
		case 12:
			numDias=31;
			break;
		case 4: case 6: case 9: case 11:
			numDias=30;
			break;
		case 2:
			if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
			break;
		default:
			mensajeSis("Fecha Introducida Errónea");
		return true;
		}
		if (dia>numDias || dia==0){
			mensajeSis("Fecha Introducida Errónea");
			return true;
		}
		return false;
	}
}

//FUNCION VALIDA SI ES AÑO BISISESTO
function comprobarSiBisisesto(anio){
	if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
		return true;
	}
	else {
		return false;
	}
}

//FUNCION VALIDA SI LA FECHA ES MAYOR = TRUE, NO ES MAYOR = FALSE
function mayor(fecha, fecha2){
	//0|1|2|3|4|5|6|7|8|9|
	//2 0 1 2 / 1 1 / 2 0
	var xMes=fecha.substring(5, 7);
	var xDia=fecha.substring(8, 10);
	var xAnio=fecha.substring(0,4);

	var yMes=fecha2.substring(5, 7);
	var yDia=fecha2.substring(8, 10);
	var yAnio=fecha2.substring(0,4);
	if (xAnio > yAnio){
		mensajeSis("La Fecha no puede ser Mayor a la Actual");
		return true;
	}else{
		if (xAnio == yAnio){
			if (xMes > yMes){
				mensajeSis("La Fecha no puede ser Mayor a la Actual");
				return true;
			}
			if (xMes == yMes){
				if (xDia > yDia){
					mensajeSis("La Fecha no puede ser Mayor a la Actual");
					return true;
				}else{
					return false;
				}
			}else{
				return false;
			}
		}else{
			return false ;
		}
	} 
}

//FUNCION VALIDA SOLO INGRESAR NUMEROS ENTEROS 
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

//FUNCION DE EXITO 
function funcionEsExitoRegGaran(){
	var jQmensaje = eval("'#ligaCerrar'");
	if($(jQmensaje).length > 0) { 
	mensajeAlert=setInterval(function() { 
		if($(jQmensaje).is(':hidden')) { 	
			clearInterval(mensajeAlert); 
			
			inicializaForma('formaGenerica', 'garantiaID');
			limpiaCamposAuxiliares();					
		}
        }, 50);
	}	
	
}

//FUNCION DE ERROR
function funcionEsErrorRegGaran(){
}

//FUNCION LIMPIA CAMPOS AUXILIARES
function limpiaCamposAuxiliares(){
	$('#fechaCompFactura').val('');
	$('#referenciafact').val('');
	$('#valorFactura').val('');
	$('#serieFactura').val('');
	$('#rfcEmisor').val('');
	
	$('#referenciafact').val('');
	$('#estadoID').val('');
	$('#nombreEstado').val('');
	$('#municipioID').val('');
	$('#nombreMuni').val('');
	
	$('#numero').val('');
	$('#calle').val('');
	$('#codigoPostal').val('');
	$('#colonia').val('');
	$('#lote').val('');
	
	$('#numeroInt').val('');
	$('#manzana').val('');
	$('#m2Construccion').val('');
	$('#m2Terreno').val('');
	$('#asegurador').val('');
	
	$('#numPoliza').val('');
	$('#vencimientoPoliza').val('');
	$('#folioRegistro').val('');
	$('#notarioID').val('');
	$('#nombreNotario').val('');
	
	$('#fechaRegistro').val('');
	$('#nombreAutoridad').val('');
	$('#cargoAutoridad').val('');
	$('#fechagravemen').val('');
	$('#nombBenefiGrav').val('');
	
	$('#montoGravemen').val('');	
	
	$('#direccionGarante').hide();
	
	$('#contenedorParametros').html("");
	$('#contenedorParametros').hide();
	
	$('#tipoGarantiaID').val('');
	$('#clasifGarantiaID').val('');
	$('#tipoDocumentoID').val('');
	$('#asegurado').val('');
	$('#verificada').val('');
	$('#tipoGravemen').val('');
	$('#proporcion').val('');
	
	

	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('modificar', 'submit');

}

