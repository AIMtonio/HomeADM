$(document).ready(function(){
	esTab = false;
	
	var catTipoTransaccionDirCliente = {
	  		'agrega':'1',
	  		'modifica':'2',
	  		'elimina':'3',
	  		'activa':'4'	
	};	

	inicializaParametros();
	$('#gestorID').focus();
	$("#telefonoParticular").setMask('phone-us');
	$("#telefonoCelular").setMask('phone-us');

	
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
           	
            	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','gestorID','funcionExito', 'funcionFallo');
                   
            }
    });
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionDirCliente.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionDirCliente.modifica);
	});	
	
	$('#elimina').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionDirCliente.elimina);
	});
	
	$('#activa').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionDirCliente.activa);
	});
	
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {		
			gestorID: {
				required: true
			},		
			usuarioID: {
				required:  function() {return $('#interno').is(':checked'); }
			},	
			nombre: {
				required: true
			},	
			porcentajeComision: {
				required: true,
				numeroPositivo : true,
				min: 0,
				max: 50
			},	
			tipoAsigCobranzaID: {
				required: true
			}
		},
		messages: {
			gestorID: {
				required: 'Especificar Gestor'
			},
			usuarioID: {
				required: 'Especificar Usuario'
			},
			nombre: {
				required: 'Especificar Nombre'
			},
			porcentajeComision: {
				required: 'Especificar % Comisión',
				numeroPositivo : "Sólo números",
				min: 'Valor Mínimo de  0',
				max: 'Valor Máximo de 50'
			},
			tipoAsigCobranzaID: {
				required: 'Especificar Tipo Asignación'
			}
			
		}		
	});
	
	
	$('#gestorID').bind('keyup', function(e){
		lista('gestorID', '2', '1', 'nombre', $('#gestorID').val(),'listaGestoresCobranza.htm');
	});
	
	$('#gestorID').blur(function(){
		if(esTab){
			if($('#gestorID').val() == 0 ){
				inicializaParametros();
				habilitaBoton('agrega','submit');
				
			}else{
				inicializaParametros();
				consultaGestorCobranza(this.id);			
			}
		}
	});
	
	$('#usuarioID').bind('keyup',function(e){
		lista('usuarioID', '2', '15', 'nombreCompleto', $('#usuarioID').val(), 'listaUsuarios.htm');
	});	
	
	$('#usuarioID').blur(function() {
  		consultaUsuario(this.id);
  		
	});
	
	$('#interno').click(function(){
		limpiaDatosGestor();
		limpiaDireccion();
		camposInterno();
		validaSucursal();
		$('#usuarioID').focus();
		
	});

	$('#externo').click(function(){
		limpiaDatosGestor();
		limpiaDireccion();
		camposExterno();
		$('#nombre').focus();
	});
	
	
	//******************** seccion direcciones 
	
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
				$('#municipioID').val('');
				$('#nombreMunicipio').val('');
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
					$('#localidadID').val('');
					$('#nombreLocalidad').val('');
					alert('Especificar Municipio');
				}
			}
		}else{
			if($('#localidadID').val().length >= 3){
				$('#estadoID').focus();
				$('#localidadID').val('');
				$('#nombreLocalidad').val('');
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
					$('#coloniaID').val('');
					$('#nombreColonia').val('');
				}
			}
		}else{
			if($('#coloniaID').val().length >= 3){
				alert('Especificar Estado');
				$('#estadoID').focus();
				$('#coloniaID').val('');
				$('#nombreColonia').val('');
			}
		}
		
		
	});
	
	$('#coloniaID').blur(function() {
		if(esTab){
			consultaColonia(this.id);			
		}
	});
	
	//Función consulta datos del estado
	function consultaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numEstado != '' && !isNaN(numEstado)){
			estadosServicio.consulta(tipConForanea,numEstado,{ async: false, callback: function(estado) {
				if(estado!=null){							
					$('#nombreEstado').val(estado.nombre);
				}else{
					$('#nombreEstado').val("");
					$('#estadoID').val("");
					$('#estadoID').focus();
					$('#estadoID').select();
					alert("No Existe el Estado");
				}    	 						
			}});
		}else{
			if(isNaN(numEstado)){
				$('#nombreEstado').val("");
				$('#estadoID').val("");
				$('#estadoID').focus();
				$('#estadoID').select();
				alert("No Existe el Estado");
			}else{
				if(numEstado == '' ){
					$('#nombreEstado').val("");
					$('#estadoID').val("");
				}
			}
		}
	}	
	
	//Función consulta datos del municipio
	function consultaMunicipio(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();	
		var numEstado =  $('#estadoID').val();				
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
					
		if(numMunicipio != '' && !isNaN(numMunicipio)){	
			if(numEstado !='' && numEstado > 0 ){
					municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,{ async: false, callback: function(municipio) {
						if(municipio!=null){							
							$('#nombreMunicipio').val(municipio.nombre);
						}else{
							alert("No Existe el Municipio");
							$('#nombreMunicipio').val("");
							$('#municipioID').val("");
							$('#municipioID').focus();
							$('#municipioID').select();
						}    	 						
					}});	

			}else{
				$('#nombreMunicipio').val("");
				$('#municipioID').val("");
				$('#estadoID').focus();
				alert("Especificar Estado");
			}
		}else{
			if(isNaN(numMunicipio)){
				alert("No Existe el Municipio");
				$('#nombreMunicipio').val("");
				$('#municipioID').val("");
				$('#municipioID').focus();
				$('#municipioID').select();
					
			}else{
				if(numMunicipio == '' ){
					$('#nombreMunicipio').val("");
					$('#municipioID').val("");
				}
			}
		}
	}	
	
	//Función consulta datos de la localidad
	function consultaLocalidad(idControl) {
		var jqLocalidad = eval("'#" + idControl + "'");
		var numLocalidad = $(jqLocalidad).val();
		var numMunicipio =	$('#municipioID').val();
		var numEstado =  $('#estadoID').val();				
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		
		
		if(numLocalidad != '' && !isNaN(numLocalidad)){
			if(numEstado != '' && numEstado > 0 ){
				if(numMunicipio !='' && numMunicipio > 0){
					localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad,{ async: false, callback: function(localidad) {
						if(localidad!=null){							
							$('#nombreLocalidad').val(localidad.nombreLocalidad);
						}else{
							$('#nombreLocalidad').val("");
							$('#localidadID').val("");
							$('#localidadID').focus();
							$('#localidadID').select();
							alert("No Existe la Localidad");
						}    	 						
					}});
				}else{
					$('#nombreLocalidad').val("");
					$('#localidadID').val("");
					$('#municipioID').focus();
					alert("Especificar Municipio");
				}
			}else{
				$('#nombreLocalidad').val("");
				$('#localidadID').val("");
				$('#estadoID').focus();	
				alert("Especificar Estado");										
			}	
		}else{
			if(isNaN(numLocalidad)){
				alert("No Existe la Localidad");
				$('#nombreLocalidad').val("");
				$('#localidadID').val("");
				$('#localidadID').focus();
				$('#localidadID').select();
			}else{
				if(numLocalidad == '' ){
					$('#nombreLocalidad').val("");
					$('#localidadID').val("");
				}
			}
		}		
	}
	
	//Función consulta datos de la Colonia
	function consultaColonia(idControl) {
		var jqColonia = eval("'#" + idControl + "'");
		var numColonia= $(jqColonia).val();		
		var numEstado =  $('#estadoID').val();	
		var numMunicipio =	$('#municipioID').val();
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		
				
		if(numColonia != '' && !isNaN(numColonia)){
			if(numEstado != '' && numEstado > 0 ){
				if(numMunicipio !='' && numMunicipio > 0){
					coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,{ async: false, callback: function(colonia) {
							if(colonia!=null){							
								$('#nombreColonia').val(colonia.asentamiento);
							}else{
								alert("No Existe la Colonia");
								$('#nombreColonia').val("");
								$('#coloniaID').val("");
								$('#coloniaID').focus();
								$('#coloniaID').select();
							}    	 						
						}});
				}else{
					$('#nombreColonia').val("");
					$('#coloniaID').val("");
					$('#municipioID').focus();
					alert("Especificar Municipio");
				}
			}else{
				$('#nombreColonia').val("");
				$('#coloniaID').val("");
				$('#estadoID').focus();	
				alert("Especificar Estado");										
			}			
		}else{
			if(isNaN(numColonia)){
				alert("No Existe la Colonia");
				$('#nombreColonia').val("");
				$('#coloniaID').val("");
				$('#coloniaID').focus();
				$('#coloniaID').select();				
			}else{
				if(numColonia == '' ){
					$('#nombreColonia').val("");
					$('#coloniaID').val("");
				}
			}
		}
	}
	
	//***************************** fin direcciones

	//Función consulta datos  del gestor de cobranza
	function consultaGestorCobranza(idControl) {
		var jqGestor = eval("'#" + idControl + "'");
		var numGestor = $(jqGestor).val();	
		var conGestor=1;
		var gestorBeanCon = {
  				'gestorID':numGestor 
				};	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numGestor != '' && !isNaN(numGestor) && $('#gestorID').val() > 0 && esTab){
			gestoresCobranzaServicio.consulta(conGestor,gestorBeanCon,function(gestor) {

						if(gestor!=null){
							if(gestor.tipoGestor == 'E'){
								$('#externo').attr("checked",true);
								camposExterno();
							}else{
								$('#interno').attr("checked",true);
								camposInterno();
							}
							$('#usuarioID').val(gestor.usuarioID);
							$('#nombre').val(gestor.nombre);	
							$('#apellidoPaterno').val(gestor.apellidoPaterno);
							$('#apellidoMaterno').val(gestor.apellidoMaterno);
							
							$('#telefonoParticular').val(gestor.telefonoParticular);
							$('#telefonoCelular').val(gestor.telefonoCelular);
							$("#telefonoParticular").setMask('phone-us');
							$("#telefonoCelular").setMask('phone-us');
							
							$('#estadoID').val(gestor.estadoID);
							if($('#estadoID').val() > 0){
								consultaEstado('estadoID');
							}
							$('#municipioID').val(gestor.municipioID);
							if($('#municipioID').val() > 0){
								consultaMunicipio('municipioID');
							}
							$('#localidadID').val(gestor.localidadID);
							if($('#localidadID').val() > 0){
								consultaLocalidad('localidadID');
							}
							$('#coloniaID').val(gestor.coloniaID);
							if($('#coloniaID').val() > 0){
								consultaColonia('coloniaID');
							}
							$('#calle').val(gestor.calle);
							$('#numeroCasa').val(gestor.numeroCasa);
							$('#numInterior').val(gestor.numInterior);
							$('#piso').val(gestor.piso);
							$('#primeraEntreCalle').val(gestor.primeraEntreCalle);
							$('#segundaEntreCalle').val(gestor.segundaEntreCalle);
							$('#CP').val(gestor.CP);
							$('#porcentajeComision').val(gestor.porcentajeComision);
							$('#tipoAsigCobranzaID').val(gestor.tipoAsigCobranzaID);
							if(gestor.estatus == "A"){
								$('#estatus').val("ACTIVO");
								deshabilitaBoton('agrega','submit');
								habilitaBoton('modifica','submit');
								habilitaBoton('elimina','submit');
								deshabilitaBoton('activa','submit');
							}else{
								if(gestor.estatus == "B"){
									$('#estatus').val("BAJA");
									deshabilitaBoton('agrega','submit');
									deshabilitaBoton('modifica','submit');
									deshabilitaBoton('elimina','submit');
									habilitaBoton('activa','submit');
								}								
							}
										
						}else{							
							alert("No Existe el Gestor de Cobranza");
							$('#gestorID').focus();
							$('#gestorID').val('');
						}  
				});
			}else{
				if(isNaN(numGestor) && esTab){
					alert("No Existe el Gestor de Cobranza");
					$('#gestorID').focus();
					$('#gestorID').val('');
				}
			}
		}
	
	//Función consulta datos de usuario
	function consultaUsuario(idControl) {
		var jqUsuario = eval("'#" + idControl + "'");
		var numUsuario = $(jqUsuario).val();	
		var conUsuario=1;
		var usuarioBeanCon = {
  				'usuarioID':numUsuario 
				};	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numUsuario != '' && !isNaN(numUsuario) && esTab){
			usuarioServicio.consulta(conUsuario,usuarioBeanCon,function(usuario) {

						if(usuario!=null){
							if(usuario.estatus == 'A' || usuario.estatus == 'B' ){
								$('#nombre').val(usuario.nombre);		
								$('#apellidoPaterno').val(usuario.apPaterno);		
								$('#apellidoMaterno').val(usuario.apMaterno);	
							}else{
								alert('El usuario esta Cancelado');
								$('#nombreUsuario').val('');
								$('#usuarioID').focus();
								$('#usuarioID').val('');
							}													
						}else{
							$('#nombreUsuario').val('');
							alert("No Existe el Usuario");
							$('#usuarioID').focus();
							$('#usuarioID').val('');
						}  
				});
			}else{
				if(isNaN(numUsuario) && esTab){
					alert("No Existe el Usuario");
					$('#usuarioID').focus();
					$('#usuarioID').val('');
					$('#nombreUsuario').val('');
					$('#apellidoPaterno').val('');
					$('#apellidoMaterno').val('');
					
				}
			}
		}
	
	//Función consulta datos de la sucursal
	function validaSucursal() {
		var parametroBean = consultaParametrosSession();
		var numSucursal = parametroBean.sucursal;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numSucursal != '' && !isNaN(numSucursal)){
			sucursalesServicio.consultaSucursal(1,numSucursal,function(sucursal) { 
				if(sucursal!=null){
					$('#estadoID').val(sucursal.estadoID);
					if($('#estadoID').val() > 0){
						consultaEstado('estadoID');
					}
					
					$('#municipioID').val(sucursal.municipioID);
					if($('#municipioID').val() > 0){
						consultaMunicipio('municipioID');
					}
					
					$('#localidadID').val(sucursal.localidadID);
					if($('#localidadID').val() > 0){
						consultaLocalidad('localidadID');
					}
					
					$('#coloniaID').val(sucursal.coloniaID);
					if($('#coloniaID').val() > 0){
						consultaColonia('coloniaID');
					}					
					
					$('#CP').val(sucursal.CP);
					$('#calle').val(sucursal.calle);
					$('#numeroCasa').val(sucursal.numero);
				}
			});
		}
	}
	
});

//Función que inicializa los campos de la pantalla
function inicializaParametros(){
	inicializaForma('formaGenerica','gestorID');
	
	$('#tipoAsigCobranzaID').val('');
	$('#externo').attr("checked",true);
	camposExterno();
	
	deshabilitaBoton('agrega','submit');
	deshabilitaBoton('modifica','submit');
	deshabilitaBoton('elimina','submit');
	deshabilitaBoton('activa','submit');
	deshabilitaControl('estatus');
	funcionCargaComboTipoAsig();
	
	var parametroBean = consultaParametrosSession();
	$('#usuarioLogeadoID').val(parametroBean.numeroUsuario);
	$('#fechaSis').val(parametroBean.fechaSucursal);
}

//Función que carga la opciones del combo tipo de asignación
function funcionCargaComboTipoAsig(){
	dwr.util.removeAllOptions('tipoAsigCobranzaID'); 
	gestoresCobranzaServicio.listaCombo(1, function(tipoAsignaciones){
		dwr.util.addOptions('tipoAsigCobranzaID', {'':'SELECCIONAR'});	
		dwr.util.addOptions('tipoAsigCobranzaID', tipoAsignaciones, 'tipoAsigCobranzaID', 'descripcion');
	});
}

//Función habilita campos para registrar gestor interno y deshabilita los que no
function camposInterno(){
	habilitaControl('usuarioID');
	deshabilitaControl('nombre');
	deshabilitaControl('apellidoPaterno');
	deshabilitaControl('apellidoMaterno');

	deshabilitaControl('estadoID');
	deshabilitaControl('municipioID');
	deshabilitaControl('localidadID');
	deshabilitaControl('coloniaID');
	deshabilitaControl('calle');
	deshabilitaControl('numeroID');
	deshabilitaControl('numeroCasa');
	deshabilitaControl('numInterior');
	deshabilitaControl('piso');
	deshabilitaControl('primeraEntreCalle');
	deshabilitaControl('segundaEntreCalle');
	deshabilitaControl('CP');
}

//Función habilita campos para regsitrar gestor externo y deshabilita los que no
function camposExterno(){
	deshabilitaControl('usuarioID');
	$('#usuarioID').val('');
	habilitaControl('nombre');
	habilitaControl('apellidoPaterno');
	habilitaControl('apellidoMaterno');
	

	habilitaControl('estadoID');
	habilitaControl('municipioID');
	habilitaControl('localidadID');
	habilitaControl('coloniaID');
	habilitaControl('calle');
	habilitaControl('numeroID');
	habilitaControl('numeroCasa');
	habilitaControl('numInterior');
	habilitaControl('piso');
	habilitaControl('primeraEntreCalle');
	habilitaControl('segundaEntreCalle');
	habilitaControl('CP');
}

//Fucnión limpia campos del gestor de cobranza
function limpiaDatosGestor(){
	$('#nombre').val('');
	$('#apellidoPaterno').val('');
	$('#apellidoMaterno').val('');
	$('#telefonoParticular').val('');
	$('#telefonoCelular').val('');
	
}

//Función limpia campso de la sección de dirección
function limpiaDireccion(){
	$('#estadoID').val('');
	$('#nombreEstado').val('');
	$('#municipioID').val('');
	$('#nombreMunicipio').val('');
	$('#localidadID').val('');
	$('#nombreLocalidad').val('');
	$('#coloniaID').val('');
	$('#nombreColonia').val('');
	$('#calle').val('');
	$('#numeroCasa').val('');
	$('#numInterior').val('');
	$('#piso').val('');
	$('#primeraEntreCalle').val('');
	$('#segundaEntreCalle').val('');
	$('#CP').val('');
}

//Función de éxito de la transacción
function funcionExito() {
	inicializaParametros();
}

//Función de error de la transacción
function funcionFallo() {
	
}