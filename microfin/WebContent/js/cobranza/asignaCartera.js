$(document).ready(function(){
	esTab = false;
	
	var catTipoTransaccionAsignaCartera = {
	  		'asignar':'1'
	};	
	
	agregaFormatoControles('formaGenerica');
	inicializaParametros();
	$('#asignadoID').focus();
	
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
	    	  if(guardarDatosGridCreditos() == true){
	    	      grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','asignadoID','funcionExito','funcionError');		  
	    	  }	     
	      }
	});	
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {		
			gestorID: {
				required: true
			},	
			adeudoMin: {
				maxlength: 22
			},	
			adeudoMax: {
				maxlength: 22
			}				
		},
		messages: {
			gestorID: {
				required: 'Especificar Gestor'
			},
			adeudoMin: {
				maxlength: 'Máximo 18 Dígitos'
			},
			adeudoMax: {
				maxlength: 'Máximo 18 Dígitos'
			}					
		}		
	});
	
	$('#asignadoID').bind('keyup', function(e){
		lista('asignadoID', '3', '1', 'nombreGestor', $('#asignadoID').val(),'listaAsignaCartera.htm');
	});

	$('#asignadoID').blur(function(){
		if(esTab){
			if($('#asignadoID').val() == 0 ){
				inicializaParametros();	
				habilitaBoton('buscar', 'submit');	
				$('#gestorID').focus();
			}else{
				consultaAsignados(this.id);	
			}
		}
	});
		
	$('#asignar').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionAsignaCartera.asignar);		
	});
	
	$('#gestorID').bind('keyup', function(e){
		lista('gestorID', '3', '1', 'nombre', $('#gestorID').val(),'listaGestoresCobranza.htm');
	});
	
	$('#gestorID').blur(function(){
		if(esTab){
			consultaGestorCobranza(this.id);	
		}
	});
	
	$('#diasAtrasoMin').blur(function(){
		if(esTab){
			if($('#diasAtrasoMax').asNumber() > 0 && $('#diasAtrasoMin').asNumber() > $('#diasAtrasoMax').asNumber()){
				alert('Los días de  Atraso Mínimo no pueden ser Mayor a los días de Atraso Máximo');
				$('#diasAtrasoMin').val('0');
				$('#diasAtrasoMin').focus();
			}
		}
	});
	
	$('#diasAtrasoMax').blur(function(){
		if(esTab){
			if($('#diasAtrasoMin').asNumber() > 0  && $('#diasAtrasoMax').asNumber() < $('#diasAtrasoMin').asNumber()){
				alert('Los días de  Atraso Máximo no pueden ser Menor a los días de Atraso Mínimo');
				$('#diasAtrasoMax').val($('#diasAtrasoMin').val());
				$('#diasAtrasoMax').focus();
			}
		}
		
	});
	
	$('#sucursalID').blur(function() {
		if(esTab){
			validaSucursal();
		}
  		
	});

	$('#sucursalID').bind('keyup',function(e){
		lista('sucursalID', '3', '4', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
	});
		
	$('#buscar').click(function(){
		$('#divListaCreditos').html("");
		if($('#diasAtrasoMax').asNumber() < $('#diasAtrasoMin').asNumber()){
			$('#diasAtrasoMax').focus();
			$('#divListaCreditos').html("");
			$('#divListaCreditos').hide();	
			$('#fieldsetLisCred').hide();
			deshabilitaBoton('asignar', 'submit');
			deshabilitaBoton('generar', 'submit');
			$('#diasAtrasoMax').val($('#diasAtrasoMin').val());
			alert('Los días de  Atraso Máximo no pueden ser Menor a los días de Atraso Mínimo');
		}else{			
			consultaGridCreditos(1);			
		}
	});
	
	$('#generar').click(function() {		
		generaReporte();
	});
	
	
	//********************
	
	$('#estadoID').bind('keyup',function(e){
		lista('estadoID', '2', '1', 'nombre', $('#estadoID').val(), 'listaEstados.htm');
	});
	
	$('#estadoID').blur(function() {
		if(esTab){
			consultaEstado(this.id);
		}
  		
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
				$('#municipioID').val('0');
				$('#nombreMunicipio').val('TODOS');
				alert('Especificar Estado');
			}			
		}		
	});
	
	$('#municipioID').blur(function() {
		if(esTab){
			consultaMunicipio(this.id);
		}
  		
	});
	
	$('#localidadID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = 'municipioID';
		camposLista[2] = "nombreLocalidad";
		
		
		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioID').val();
		parametrosLista[2] = $('#localidadID').val();
		
		if($('#estadoID').val() != '' && $('#estadoID').asNumber() > 0){
			if($('#municipioID').val() != '' && $('#municipioID').asNumber() > 0){
				lista('localidadID', '2', '1', camposLista, parametrosLista,'listaLocalidades.htm');
			}else{
				if($('#localidadID').val().length >= 3){
					$('#municipioID').focus();
					$('#localidadID').val('0');
					$('#nombreLocalidad').val('TODAS');
					alert('Especificar Municipio');
				}
			}
		}else{
			if($('#localidadID').val().length >= 3){
				$('#estadoID').focus();
				$('#localidadID').val('0');
				$('#nombreLocalidad').val('TODAS');
				alert('Especificar Estado');
			}
		}
		
		
	});

	$('#localidadID').blur(function() {
		if(esTab){
			consultaLocalidad(this.id);
		}
		
	});
	
	$('#coloniaID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = 'municipioID';
		camposLista[2] = "asentamiento";		
		
		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioID').val();
		parametrosLista[2] = $('#coloniaID').val();
		
		if($('#estadoID').val() != '' && $('#estadoID').asNumber() > 0){
			if($('#municipioID').val() != '' && $('#municipioID').asNumber() > 0){
				lista('coloniaID', '2', '1', camposLista, parametrosLista,'listaColonias.htm');
			}else{
				if($('#coloniaID').val().length >= 3){
					alert('Especificar Municipio');
					$('#municipioID').focus();
					$('#coloniaID').val('0');
					$('#nombreColonia').val('TODAS');
				}
			}
		}else{
			if($('#coloniaID').val().length >= 3){
				alert('Especificar Estado');
				$('#estadoID').focus();
				$('#coloniaID').val('0');
				$('#nombreColonia').val('TODAS');
			}
		}
		
		
	});
	
	$('#coloniaID').blur(function() {
		if(esTab){
			consultaColonia(this.id);			
		}
	});
	
	
	//Función que consulta los datos del estado 
	function consultaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numEstado != '' && !isNaN(numEstado) && numEstado > 0){
			estadosServicio.consulta(tipConForanea,numEstado,{ async: false, callback: function(estado) {
				if(estado!=null){							
					$('#nombreEstado').val(estado.nombre);
				}else{
					$('#nombreEstado').val("TODOS");
					$('#estadoID').val("0");
					$('#estadoID').focus();
					$('#estadoID').select();
					alert("No Existe el Estado");
				}    	 						
			}});
		}else{
			if(isNaN(numEstado)){
				$('#nombreEstado').val("TODOS");
				$('#estadoID').val("0");
				$('#estadoID').focus();
				$('#estadoID').select();
				alert("No Existe el Estado");
			}else{
				if(numEstado == '' || numEstado == 0){
					$('#nombreEstado').val("TODOS");
					$('#estadoID').val("0");					
				}
			}
		}
	}	
	
	//Función que consulta los datos del municipio
	function consultaMunicipio(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();	
		var numEstado =  $('#estadoID').val();				
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
					
		if(numMunicipio != '' && !isNaN(numMunicipio) && numMunicipio > 0){	
			if(numEstado !='' && numEstado > 0 ){
					municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,{ async: false, callback: function(municipio) {
						if(municipio!=null){							
							$('#nombreMunicipio').val(municipio.nombre);
						}else{
							alert("No Existe el Municipio");
							$('#nombreMunicipio').val("TODOS");
							$('#municipioID').val("0");
							$('#municipioID').focus();
							$('#municipioID').select();
						}    	 						
					}});	

			}else{
				$('#nombreMunicipio').val("TODOS");
				$('#municipioID').val("0");
				$('#estadoID').focus();
				alert("Especificar Estado");
			}
		}else{
			if(isNaN(numMunicipio)){
				alert("No Existe el Municipio");
				$('#nombreMunicipio').val("TODOS");
				$('#municipioID').val("0");
				$('#municipioID').focus();
				$('#municipioID').select();
					
			}else{
				if(numMunicipio == '' || numMunicipio == 0){
					$('#nombreMunicipio').val("TODOS");
					$('#municipioID').val("0");			
				}
			}
		}
	}	
	
	//Función que consulta los datos de la localidad
	function consultaLocalidad(idControl) {
		var jqLocalidad = eval("'#" + idControl + "'");
		var numLocalidad = $(jqLocalidad).val();
		var numMunicipio =	$('#municipioID').val();
		var numEstado =  $('#estadoID').val();				
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		
		
		if(numLocalidad != '' && !isNaN(numLocalidad) && numLocalidad > 0){
			if(numEstado != '' && numEstado > 0 ){
				if(numMunicipio !='' && numMunicipio > 0){
					localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad,{ async: false, callback: function(localidad) {
						if(localidad!=null){							
							$('#nombreLocalidad').val(localidad.nombreLocalidad);
						}else{
							$('#nombreLocalidad').val("TODAS");
							$('#localidadID').val("0");
							$('#localidadID').focus();
							$('#localidadID').select();
							alert("No Existe la Localidad");
						}    	 						
					}});
				}else{
					$('#nombreLocalidad').val("TODAS");
					$('#localidadID').val("0");
					$('#municipioID').focus();
					alert("Especificar Municipio");
				}
			}else{
				$('#nombreLocalidad').val("TODAS");
				$('#localidadID').val("0");
				$('#estadoID').focus();	
				alert("Especificar Estado");										
			}	
		}else{
			if(isNaN(numLocalidad)){
				alert("No Existe la Localidad");
				$('#nombreLocalidad').val("TODAS");
				$('#localidadID').val("0");
				$('#localidadID').focus();
				$('#localidadID').select();
			}else{
				if(numLocalidad == '' || numLocalidad == 0){
					$('#nombreLocalidad').val("TODAS");
					$('#localidadID').val("0");		
				}
			}
		}
		
		
			
		
	}
	//Función que consulta los datos de la Colonia
	function consultaColonia(idControl) {
		var jqColonia = eval("'#" + idControl + "'");
		var numColonia= $(jqColonia).val();		
		var numEstado =  $('#estadoID').val();	
		var numMunicipio =	$('#municipioID').val();
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		
				
		if(numColonia != '' && !isNaN(numColonia) && numColonia > 0){
			if(numEstado != '' && numEstado > 0 ){
				if(numMunicipio !='' && numMunicipio > 0){
					coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,{ async: false, callback: function(colonia) {
							if(colonia!=null){							
								$('#nombreColonia').val(colonia.asentamiento);
							}else{
								alert("No Existe la Colonia");
								$('#nombreColonia').val("TODAS");
								$('#coloniaID').val("0");
								$('#coloniaID').focus();
								$('#coloniaID').select();
							}    	 						
						}});
				}else{
					$('#nombreColonia').val("TODAS");
					$('#coloniaID').val("0");
					$('#municipioID').focus();
					alert("Especificar Municipio");
				}
			}else{
				$('#nombreColonia').val("TODAS");
				$('#coloniaID').val("0");
				$('#estadoID').focus();	
				alert("Especificar Estado");										
			}			
		}else{
			if(isNaN(numColonia)){
				alert("No Existe la Colonia");
				$('#nombreColonia').val("TODAS");
				$('#coloniaID').val("0");
				$('#coloniaID').focus();
				$('#coloniaID').select();				
			}else{
				if(numColonia == '' || numColonia == 0){
					$('#nombreColonia').val("TODAS");
					$('#coloniaID').val("0");
				}
			}
		}
	}
	
	//***************************** 
	
	//Función consulta de una asignacion de cartera
	function consultaAsignados(idControl){
		var jqGestor = eval("'#" + idControl + "'");
		var numAsignado = $(jqGestor).val();	
		var conAsig = 1;
		var asignaBeanCon = {
			'asignadoID':numAsignado	
		};
		setTimeout("$('#cajaLista').hide();", 200);	
		if(numAsignado != '' && !isNaN(numAsignado) && $('#asignadoID').val() > 0 && esTab){
			asignaCarteraServicio.consulta(conAsig,asignaBeanCon,function(asignacion){
				if(asignacion != null){
					$('#gestorID').val(asignacion.gestorID);
					consultaGestorCobranza('gestorID');
					$('#porcentajeComision').val(asignacion.porcentajeComision);
					$('#tipoAsigCobranzaID').val(asignacion.tipoAsigCobranzaID);
					

					$('#diasAtrasoMin').val(asignacion.diasAtrasoMin);	
					$('#diasAtrasoMax').val(asignacion.diasAtrasoMax); 
					$('#adeudoMin').val(asignacion.adeudoMin);	
					$('#adeudoMax').val(asignacion.adeudoMax);

					$('#adeudoMin').formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 2	
					});
					$('#adeudoMax').formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 2	
					});
					deshabilitaControl('adeudoMin');
					deshabilitaControl('adeudoMax');
					if(asignacion.estatusCreditos != ""){
						selecEstatusBus(asignacion.estatusCreditos);
					}					
					
					$('#sucursalID').val(asignacion.sucursalID);
					validaSucursal();
					$('#estadoID').val(asignacion.estadoID);	
					consultaEstado('estadoID');
					$('#municipioID').val(asignacion.municipioID);
					consultaMunicipio('municipioID');
					$('#localidadID').val(asignacion.localidadID);	
					consultaLocalidad('localidadID');
					$('#coloniaID').val(asignacion.coloniaID);
					consultaColonia('coloniaID');
					
					$('#limiteRenglones').val(asignacion.limiteRenglones);
					
					deshabilitaSeccionBusqueda();
					consultaGridCreditos(2);
				}
				else{
					inicializaParametros();
					$('#asignadoID').val('');
					$('#asignadoID').focus();
					alert("No existe la Asignación");
					
				}
			});
		}else{
			if(isNan(numAsignado) && esTab){
				inicializaParametros();	
				$('#asignadoID').val('');
				$('#asignadoID').focus();
				alert("No existe la Asignación");		
			}
		}
	}
	
	//Función muestra en el grid  el listado de los creditos de acuerdo a la búsqueda o la consulta
	function consultaGridCreditos(tipoLista){
		bloquearPantallaCarga();
		
		$('#listaGridCreditos').val('');
		var params = {};
		params['tipoLista'] = tipoLista;
		params['asignadoID'] = $('#asignadoID').val();
		params['diasAtrasoMin'] = $('#diasAtrasoMin').val();	
		params['diasAtrasoMax'] = $('#diasAtrasoMax').val(); 
		params['adeudoMin'] = $('#adeudoMin').val().replace(/,/g, "");	
		params['adeudoMax'] = $('#adeudoMax').val().replace(/,/g, "");	
		params['estatusCreditos'] = consultaEstatusSelec();	
		params['sucursalID'] = $('#sucursalID').val();	
		params['estadoID'] = $('#estadoID').val();	
		params['municipioID'] = $('#municipioID').val();
		params['localidadID'] = $('#localidadID').val();		
		params['coloniaID'] = $('#coloniaID').val();
		params['limiteRenglones'] = $('#limiteRenglones').val();		

		$.post("asigCreditosGridVista.htm", params, function(data){
			if(data.length >0) {	
				$('#divListaCreditos').html(data);
				$('#divListaCreditos').show();	
				$('#fieldsetLisCred').show();
				
				var numFilas=consultaFilas();		
				if(numFilas == 0 ){
					$('#divListaCreditos').html("");
					$('#divListaCreditos').hide();	
					$('#fieldsetLisCred').hide();
					deshabilitaBoton('asignar', 'submit');
					deshabilitaBoton('generar', 'submit');
					alert('No se Encontraron Coincidencias');
				}else{
					if(tipoLista == 1){
						habilitaBoton('asignar', 'submit');
						deshabilitaBoton('generar', 'submit');							
					}else{
						if(tipoLista == 2){
							deshabilitaBoton('asignar', 'submit');
							habilitaBoton('generar', 'submit');	
							deshabilitaControl('gestorID'); 
							deshabilitaChecks();
						}
					}						
				}
				hasChecked();
			}else{				
				$('#divListaCreditos').html("");
				$('#divListaCreditos').hide();
				$('#fieldsetLisCred').hide();	
				deshabilitaBoton('asignar', 'submit');
				deshabilitaBoton('generar', 'submit');
				alert('No se Encontraron Coincidencias');
			}
			$('#contenedorForma').unblock(); // desbloquear
		});		
	}
	
	//Función que regresa una cadena con los estatus seleccionados en pantalla
	function consultaEstatusSelec(){
		var cadenaEstatus = "";
		var aux = 0;
		$("#estatusCreditos option:selected").each(function() {	
			if(aux > 0){
				cadenaEstatus = cadenaEstatus + "-";
			}
			cadenaEstatus += $(this).val();
			aux++;
		});
		//Si no se selecciono ningun estatus por default se mostraran todos
		if(cadenaEstatus.length == 0){
			cadenaEstatus = "V-B-K";
		}
		
		return cadenaEstatus;		
	}	
	
	//Función consulta los datos de la sucursal
	function validaSucursal() {
		var numSucursal = $('#sucursalID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numSucursal != '' && !isNaN(numSucursal) && numSucursal > 0){
			sucursalesServicio.consultaSucursal(1,numSucursal,function(sucursal) { 
				if(sucursal!=null){
					$('#nombreSucursal').val(sucursal.nombreSucurs);				
				}else{
					$('#sucursalID').val('0');
					$('#nombreSucursal').val('TODAS');
					$('#sucursalID').focus();
					alert('No existe la Sucursal');
				}
			});
		}else{
			if(isNaN(numSucursal)){
				$('#sucursalID').val('0');
				$('#nombreSucursal').val('TODAS');
				$('#sucursalID').focus();
				alert('No existe la Sucursal');						
			}else{
				if(numSucursal =='' || numSucursal == 0){
					$('#sucursalID').val('0');
					$('#nombreSucursal').val('TODAS');					
				}
			}
		}
	}
	
	//Función consulta lso datos del gestor de cobranza	
	function consultaGestorCobranza(idControl) {
		var jqGestor = eval("'#" + idControl + "'");
		var numGestor = $(jqGestor).val();	
		var conGestor=1;
		var gestorBeanCon = {
  				'gestorID':numGestor 
				};	
		setTimeout("$('#cajaLista').hide();", 200);		
		
		if(numGestor != '' && !isNaN(numGestor) && $('#gestorID').val() > 0){
			gestoresCobranzaServicio.consulta(conGestor,gestorBeanCon,function(gestor) {

						if(gestor!=null){
							if(gestor.tipoGestor == 'E'){
								$('#externo').attr("checked",true);
							}else{
								$('#interno').attr("checked",true);
							}
							$('#usuarioID').val(gestor.usuarioID);
							$('#nombre').val(gestor.nombre);	
							$('#apellidoPaterno').val(gestor.apellidoPaterno);
							$('#apellidoMaterno').val(gestor.apellidoMaterno);
							
							$('#telefonoParticular').val(gestor.telefonoParticular);
							$('#telefonoCelular').val(gestor.telefonoCelular);
							$("#telefonoParticular").setMask('phone-us');
							$("#telefonoCelular").setMask('phone-us');
							
							
							$('#porcentajeComision').val(gestor.porcentajeComision);
							$('#tipoAsigCobranzaID').val(gestor.tipoAsigCobranzaID);
							if(gestor.estatus == "A"){
								$('#estatus').val("ACTIVO");
							}else{
								if(gestor.estatus == "B"){
									$('#estatus').val("BAJA");
								}								
							}
										
						}else{							
							limpiaDatosGestor();
							$('#gestorID').focus();
							$('#gestorID').val('');
							alert("No Existe el Gestor de Cobranza");
						}  
				});
			}else{
				if(isNaN(numGestor) || $('#gestorID').val() <= 0 && esTab && numGestor != ''){
					limpiaDatosGestor();
					$('#gestorID').focus();
					$('#gestorID').val('');
					alert("No Existe el Gestor de Cobranza");
				}
			}
	}
	  
	//Función para generar el reporte en excel de los creditos asignados
	function generaReporte(){
		var parametroBean = consultaParametrosSession();
		
		var varNombreInstitucion = parametroBean.nombreInstitucion;
		var varClaveUsuario		= parametroBean.claveUsuario;
	    var varFechaSistema     = parametroBean.fechaAplicacion;

		var pagina='reporteAsignaCartera.htm?asignadoID='+$('#asignadoID').val()+ 
							'&tipoLista=2'+ 
							'&tipoReporte=2' + 
							'&nombreInstitucion='	+varNombreInstitucion+ 
							'&claveUsuario='+varClaveUsuario.toUpperCase()+ 
							'&fechaSis='+ varFechaSistema+ 
							'&gestorID='+ $('#gestorID').val()+ 
							'&nombreCompleto='+ $('#nombre').val()+' '+$('#apellidoPaterno').val()+' '+$('#apellidoMaterno').val();
		window.open(pagina);	   
	}
	
//Selecciona los estatus que se aplicaron en la busqueda
	function selecEstatusBus(estatus) {
		var tipo= estatus.split(',');
		var tamanio = tipo.length;
		for (var i=0;i< tamanio;i++) {
			var tip = tipo[i];
			var jqEstatus = eval("'#estatusCreditos option[value="+tip+"]'");  
			$(jqEstatus).attr("selected","selected");
		}
	}	  

});

//Función que inicializa todos los campos de la pantalla
function inicializaParametros(){
	inicializaForma('formaGenerica','asignadoID');
	$('#limiteRenglones').val('200');
	$('#diasAtrasoMin').val('0');
	$('#diasAtrasoMax').val('0');
	$('#sucursalID').val('0');
	$('#nombreSucursal').val('TODAS');
	
	$('#estadoID').val("0");
	$('#nombreEstado').val("TODOS");
	$('#municipioID').val('0');
	$('#nombreMunicipio').val('TODOS');
	$('#localidadID').val('0');
	$('#nombreLocalidad').val('TODAS');
	$('#coloniaID').val('0');
	$('#nombreColonia').val('TODAS');
	
	$('#tipoAsigCobranzaID').val('');
	funcionCargaComboTipoAsig();
	
	var parametroBean = consultaParametrosSession();
	$('#usuarioLogeadoID').val(parametroBean.numeroUsuario);
	$('#fechaSis').val(parametroBean.fechaSucursal);
	
	//Se oculta seccion de creditos
	$('#divListaCreditos').html("");
	$('#divListaCreditos').hide();
	$('#fieldsetLisCred').hide();	
	
	//habilita seccion de busqueda
	habilitaSeccionBusqueda();

	deshabilitaBoton('buscar', 'submit');
	habilitaControl('gestorID'); 
}

//Función carga todas las opciones en el combo tipo de asignación
function funcionCargaComboTipoAsig(){
	dwr.util.removeAllOptions('tipoAsigCobranzaID'); 
	gestoresCobranzaServicio.listaCombo(1, function(tipoAsignaciones){
		dwr.util.addOptions('tipoAsigCobranzaID', {'':'SELECCIONAR'});	
		dwr.util.addOptions('tipoAsigCobranzaID', tipoAsignaciones, 'tipoAsigCobranzaID', 'descripcion');
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

//Función que limpia todos los campos del gestro de cobranza
function limpiaDatosGestor(){
	$('#externo').attr("checked",false);
	$('#interno').attr("checked",false);
	
	$('#usuarioID').val("");
	$('#nombre').val("");	
	$('#apellidoPaterno').val("");
	$('#apellidoMaterno').val("");
	
	$('#telefonoParticular').val("");
	$('#telefonoCelular').val("");
	
	$('#porcentajeComision').val("");
	$('#tipoAsigCobranzaID').val("");
	$('#estatus').val("");
}

//Función que deshabilita todos los campos de la sección de búsqueda
function deshabilitaSeccionBusqueda(){
	deshabilitaControl('diasAtrasoMin');
	deshabilitaControl('diasAtrasoMax');
	deshabilitaControl('adeudoMin');
	deshabilitaControl('adeudoMax');
	deshabilitaControl('estatusCreditos');
	deshabilitaControl('sucursalID');
	deshabilitaControl('estadoID');
	deshabilitaControl('municipioID');
	deshabilitaControl('localidadID');
	deshabilitaControl('coloniaID');
	deshabilitaControl('limiteRenglones');
	deshabilitaBoton('buscar','submit');
	
}

//Función que habilita todos los campos de la sección de búsqueda
function habilitaSeccionBusqueda(){
	habilitaControl('diasAtrasoMin');
	habilitaControl('diasAtrasoMax');
	habilitaControl('adeudoMin');
	habilitaControl('adeudoMax');
	habilitaControl('estatusCreditos');
	habilitaControl('sucursalID');
	habilitaControl('estadoID');
	habilitaControl('municipioID');
	habilitaControl('localidadID');
	habilitaControl('coloniaID');
	habilitaControl('limiteRenglones');
	habilitaBoton('buscar','submit');
	
}

//Función selecciona todos los checks del listado de creditos
function seleccionaTodos(control){
	var  si='S';
	 var no='N';
	if($('#'+control).attr('checked')==true){
		document.getElementById(control).value = si;
		$('tr[name=renglons]').each(function() {
			var numero= this.id.substr(8,this.id.length);
			var jqIdChecked = eval("'esAsignadocheck" + numero+ "'");	
			var valorChecked= document.getElementById(jqIdChecked).value;	
			var Nocheck='N';
			if(valorChecked==Nocheck){	
				$('#esAsignadocheck'+numero).attr('checked','true');
				document.getElementById(jqIdChecked).value = si;
			}
		});
	}else{
		document.getElementById(control).value = no;
		$('tr[name=renglons]').each(function() {
			var numero= this.id.substr(8,this.id.length);
			var jqIdChecked = eval("'esAsignadocheck" + numero+ "'");	
			var valorChecked= document.getElementById(jqIdChecked).value;	
			var Sicheck='S';
			if(valorChecked==Sicheck){	
				$('#esAsignadocheck'+numero).attr('checked',false);	
				document.getElementById(jqIdChecked).value = no;
			}
		});
	}
}

//Función que al dar click en un check de la lista de creditos asigna valor si es seleccionado o no
function realiza(control){	
	var  si='S';
	var no='N';
	if($('#'+control).attr('checked')==true){
		document.getElementById(control).value = si;		
	}else{
		document.getElementById(control).value = no;
	}
		
}

//Función construye la cadena de todos los creditos seleccionados para la asignacion 
function guardarDatosGridCreditos(){
	if($('#estatus').val()!= 'BAJA'){
		if(consultaNumFilasSelec()>0){
			  $('#listaGridCreditos').val("");
		  		
				$('tr[name=renglons]').each(function() {
					var numero= this.id.substr(8,this.id.length);
					var clienteID= eval("'#clienteID" + numero + "'");   
					var creditoID= eval("'#creditoID" + numero + "'");   
					var estatusCred= eval("'#estatusCred" + numero + "'");   
					var diasAtraso= eval("'#diasAtraso" + numero + "'");   
					var montoCredito= eval("'#montoCredito" + numero + "'");   
					var fechaDesembolso= eval("'#fechaDesembolso" + numero + "'");
					var fechaVencimien= eval("'#fechaVencimien" + numero + "'");   
					var saldoCapital= eval("'#saldoCapital" + numero + "'");   
					var saldoInteres= eval("'#saldoInteres" + numero + "'");   
					var saldoMoratorio= eval("'#saldoMoratorio" + numero + "'");   
					var asignar= eval("'#esAsignadocheck" + numero + "'"); 
					var sucursalID= eval("'#sucursalGridID" + numero + "'");    
					var nombreCompleto= eval("'#nombreCompleto" + numero + "'");    

					if ($(asignar).val()=="S"){
							$('#listaGridCreditos').val($('#listaGridCreditos').val() + '['+
								$(clienteID).val() + ']'+ 
								$(creditoID).val() + ']' +
								$(estatusCred).val() +']'+
								$(diasAtraso).val() + ']'+ 
								$(montoCredito).val().replace(/,/g, "") + ']' +
								$(fechaDesembolso).val() +']'+
								$(fechaVencimien).val() + ']'+ 
								$(saldoCapital).val().replace(/,/g, "") + ']' +
								$(saldoInteres).val().replace(/,/g, "") +']'+
								$(saldoMoratorio).val().replace(/,/g, "") +']'+
								$(sucursalID).val()+']'+
								$(nombreCompleto).val()+']'+
								$(asignar).val() 
							);
					}			
				});
				return true;
		  }else{
			  alert('No ha Seleccionado un Crédito');
				return false;
		  } 
	}else{
		alert('El Gestor no se Encuentra Activo');	
		$('#gestorID').focus();	
		return false;
	}
	       	
	

}  


//Función consulta el total de creditos en la lista
function consultaFilas(){
	var totales=0;
	$('tr[name=renglons]').each(function() {
		totales++;
		
	});
	return totales;
}

//Función que deshabilita todos los check del listado de creditos cunado se consulta
function deshabilitaChecks(){
	$('tr[name=renglons]').each(function() {
		var numero= this.id.substr(8,this.id.length);
		var jqIdChecked = eval("'esAsignadocheck" + numero+ "'");	
		deshabilitaControl(jqIdChecked);		
	});
	deshabilitaControl('selecTodos'); 
}

//Función consulta el número de creditos que se seleccionaron
function consultaNumFilasSelec(){
	var totales=0;
	$('tr[name=renglons]').each(function() {
		var numero= this.id.substr(8,this.id.length);
		var asignar= eval("'#esAsignadocheck" + numero + "'");   
		
		if ($(asignar).val()=="S"){
			totales++;
		}		
	});
	return totales;
}

//Función que al consultar el listado de creditos marca los creditos que aun estan asignados
function hasChecked(){	
	
	$('tr[name=renglons]').each(function() {
		var numero= this.id.substr(8,this.id.length);
		var jqIdChecked = eval("'esAsignadocheck" + numero+ "'");	
		var valorChecked= document.getElementById(jqIdChecked).value;	
		var seleccionado='S';
		if(valorChecked==seleccionado){
			$('#esAsignadocheck'+numero).attr('checked','true');					
		}else{
			$('#esAsignadocheck'+numero).attr('checked',false);
		}
		$('#montoCredito'+numero).formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});
		$('#saldoCapital'+numero).formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});
		$('#saldoInteres'+numero).formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});
		$('#saldoMoratorio'+numero).formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});

	});		
}

//funcion que bloquea la pantalla mientras se cargan los datos
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

//Función de éxito en la transación
function funcionExito(){
	var jQmensaje = eval("'#ligaCerrar'");
	if($(jQmensaje).length > 0) { 
	mensajeAlert=setInterval(function() { 
		if($(jQmensaje).is(':hidden')) { 	
			clearInterval(mensajeAlert); 
			
			inicializaParametros();
			$('#asignadoID').focus();					
		}
        }, 50);
	}	
}

//función de error en la transacción
function funcionError(){
	
}