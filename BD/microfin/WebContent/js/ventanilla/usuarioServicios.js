$(document).ready(function() {
	// Definicion de Constantes y Variables
	var parametroBean = consultaParametrosSession();

	var catTipoTransaccionUsuario = {
		'agrega' : '1',
		'modifica' : '2',
		'actualiza' : '3',
		'agregaRemi': '5',
		'modificaRemi':'6'
		
	};
	
	var catTipoActualizaUsuario = {
		'inactivaUsuario' : '1'
	};

	var catTipoConsultaSociedad = {
		'principal' : 1,
		'foranea' : 2
	};

	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('inactivar','submit');
	agregaFormatoControles('formaGenerica');
	
	$('#sucursalOrigen').val(parametroBean.sucursal);	
	$('#sucursalO').val(parametroBean.nombreSucursal);

	$("#telefonoCelular").setMask('phone-us');
	$("#telefonoCasa").setMask('phone-us');	
	
	$("#telefonoCelularRem").setMask('phone-us');
	$("#telefonoCasaRem").setMask('phone-us');	
	
	cargaComboDireccion();
	cargaComboIdentificacion();
	cargaComboTipoIdenRemitente();
	cargaComboTipoPersona();

	$('#usuarioID').focus();
	limpiaCombosInicio();

	//Validacion para mostrarar boton de calcular CURP Y RFC
	permiteCalcularCURPyRFC('generarc','generar',3);

	$(':text').focus(function() {
		esTab = false;
	});

	$.validator.setDefaults({
		submitHandler : function(event) {
			if($('#tipoTransaccion').val() == catTipoTransaccionUsuario.actualiza && $('#tipoActualizacion').val() == catTipoActualizaUsuario.inactivaUsuario){
    			mensajeSisRetro({
					mensajeAlert : '¿Desea Inactivar al Usuario de Servicio?',
					muestraBtnAceptar: true,
					muestraBtnCancela: true,
					txtAceptar : 'Aceptar',
					txtCancelar : 'Cancelar',
					funcionAceptar : function(){
						grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','usuarioID','exitoTransUsuario','falloTransUsuario');
						parametroBean = consultaParametrosSession();
						$('#sucursalOrigen').val(parametroBean.sucursal);	
						$('#sucursalO').val(parametroBean.nombreSucursal);
					},
					funcionCancelar : function(){
					}
				});
			}
			if($('#tipoTransaccion').val() == catTipoTransaccionUsuario.agregaRemi){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','remitenteID','exitoTransRemitente','falloTransUsuario');
				parametroBean = consultaParametrosSession();	
			}		
			if($('#tipoTransaccion').val() == catTipoTransaccionUsuario.modificaRemi){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','remitenteID','exitoTransRemitente','falloTransUsuario');
				parametroBean = consultaParametrosSession();

			}	
			if($('#tipoTransaccion').val() == catTipoTransaccionUsuario.agrega){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','usuarioID','exitoTransUsuario','falloTransUsuario');
				parametroBean = consultaParametrosSession();
				$('#sucursalOrigen').val(parametroBean.sucursal);	
				$('#sucursalO').val(parametroBean.nombreSucursal);
			}
			if($('#tipoTransaccion').val() == catTipoTransaccionUsuario.modifica){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','usuarioID','exitoTransUsuario','falloTransUsuario');
				parametroBean = consultaParametrosSession();
				$('#sucursalOrigen').val(parametroBean.sucursal);	
				$('#sucursalO').val(parametroBean.nombreSucursal);
			}
		}
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	//------------------------------EVENTOS-------------------------------------
	//Seccion Datos Usuario
	$('#usuarioID').bind('keyup',function(e) { 
		lista('usuarioID', '2', '1', 'nombreCompleto', $('#usuarioID').val(), 'listaUsuario.htm');
	});

	$('#usuarioID').blur(function() {
		setTimeout("$('#cajaListaCte').hide();", 200);
		var remi = $('#remitenteID').val();
		var user = $('#usuarioID').val();
		if(isNaN($('#usuarioID').val()) ){
			inicializaForma('formaGenerica', 'usuarioID');
			deshabilitaBoton('agrega', 'submit');
			deshabilitaBoton('modifica', 'submit');
			deshabilitaBoton('inactivar', 'submit');
			$('#tipoPersona1').attr('checked', true);
			limpiaCombosInicio();
		}
		else {		
			limpiaCamposRemitentes();
			validaUsuario();		
		}
	});

	//FISICA
	$('#tipoPersona1').click(function() {
		permiteCalcularCURPyRFC('','generar',2);
		$('#personaFisica').show(500);
		$('#personaMoral').hide(500);
	});
	//MORAL
	$('#tipoPersona2').click(function() {
		$('#generar').hide(500);
		$('#personaFisica').hide(500);
		$('#personaMoral').show(500);
		
		$('#razonSocial').val('');
		$('#tipoSociedadID').val('');	
		$('#RFCpm').val('');
		$('#ocupacionID').val('');
		$('#ocupacionC').val('');
	});
	//FISICA ACT EMPRESARIAL
	$('#tipoPersona3').click(function() {
		$('#generar').hide(500);
		$('#personaFisica').show(500);
		$('#personaMoral').hide(500);
	});

	$('#fechaNacimiento').blur(function(){
		if($('#fechaNacimiento').val()!= ''){
			validaFecha(this.id)
		}
	});
	
	$('#fechaNacimiento').change(function(){
		$('#fechaNacimiento').focus();
	});

	$('#paisNacimiento').bind('keyup',function(e) { 
		lista('paisNacimiento', '1', '1', 'nombre', $('#paisNacimiento').val(),'listaPaises.htm');
	});
	$('#paisResidencia').bind('keyup',function(e) { 
		lista('paisResidencia', '1', '1', 'nombre', $('#paisResidencia').val(),'listaPaises.htm');
	});
	$('#paisNacimiento').blur(function() {
		consultaPaisNac(this.id,1);
	});

	$('#nacion').change(function() {
		validaNacionalidad();
	});
	
	$('#estadoNac').bind('keyup',function(e) {
		lista('estadoNac', '2', '1', 'nombre',$('#estadoNac').val(),'listaEstados.htm');
	});

	$('#estadoNac').blur(function() {
		consultaEstadoNac(this.id);
	});

	$('#paisResidencia').blur(function() {
		consultaPais(this.id);
	});

	$("#telefonoCasa").blur(function(){
		if($("#telefonoCasa").val() == ''){
			$('#extTelefonoPart').val('');
		}		
	});	
	
	$("#extTelefonoPart").blur(function(){
		if(this.value != ''){
			if($("#telefonoCasa").val() == ''){
				this.value = '';
				mensajeSis("El Número de Teléfono está Vacío.");
				$("#telefonoCasa").focus();
			}
		}
	});

	$('#generar').click(function() {
		if ($('#fechaNacimiento').val()!=''){
			formaRFC();
			$('#RFC').focus();
			$('#RFC').select();
		}else{
			mensajeSis('Se necesita la Fecha de Nacimiento para esta Opción');
		}
	});
	
	$('#generarc').click(function() {
		if ($('#fechaNacimiento').val()!=''){
			formaCURP();
			$('#CURP').focus();
			$('#CURP').select();
		}else{
			mensajeSis('Se necesita la Fecha de Nacimiento para esta Opción');
		}
	});

	$('#fechaConstitucion').blur(function(){
		if($('#fechaConstitucion').val()!= ''){
			validaFecha(this.id)
		}
	});
	
	$('#fechaConstitucion').change(function(){
		$('#fechaConstitucion').focus();
	});

	$('#fecExIden').blur(function(){
		if($('#fecExIden').val()!= ''){
			validaFecha(this.id)
		}
	});

	$('#fecVenIden').blur(function(){
		if($('#fecVenIden').val()!= ''){
			validaFecha(this.id)
		}
	});
	
	$('#fecExIden').change(function(){
		$('#fecExIden').focus();
	});
	
	$('#fecVenIden').change(function(){
		$('#fecVenIden').focus();
	});

	//Seccion Persona Fisica
	$('#ocupacionID').bind('keyup',function(e) { 
		lista('ocupacionID', '1', '1', 'descripcion',$('#ocupacionID').val(),'listaOcupaciones.htm');
	});
	
	$('#ocupacionID').blur(function() {
		$("#ocupaTab").val('2');
		if( $('#tipoPersona1').attr('checked')==true || $('#tipoPersona3').attr('checked')==true){	
		consultaOcupacion(this.id);
		}
	});

	//Seccion Persona Moral
	$('#tipoSociedadID').bind('keyup',function(e) {
		lista('tipoSociedadID', '2', '1','descripcion', $('#tipoSociedadID').val(),'listaTipoSociedad.htm');
	});

	$('#tipoSociedadID').blur(function() {
		consultaSociedad(this.id);
	});

	//Seccion Direccion
	$('#estadoID').bind('keyup',function(e){
		lista('estadoID', '2', '1', 'nombre', $('#estadoID').val(), 'listaEstados.htm');
	});
	
	$('#estadoID').blur(function() {
  		consultaEstado(this.id);
	});

	$('#municipioID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = "nombre";
		
		
		parametrosLista[0] = $('#estadoID').val();
		parametrosLista[1] = $('#municipioID').val();
		
		lista('municipioID', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
	});

	$('#municipioID').blur(function() {
  		consultaMunicipio(this.id);
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
		
		lista('localidadID', '2', '1', camposLista, parametrosLista,'listaLocalidades.htm');
	});

	$('#localidadID').blur(function() {
		consultaLocalidad(this.id);
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
		
		lista('coloniaID', '2', '1', camposLista, parametrosLista,'listaColonias.htm');
	});

	$('#coloniaID').blur(function() {
		consultaColonia(this.id,true);
	});

	$('#tipoIdentiID').blur(function() {
		consultaTipoIdenti(this.id);
	});

	$('#paisRFC').blur(function() {
		consultaPais(this.id);
	});

	$('#paisRFC').bind('keyup',function(e) { 
		lista('paisRFC', '1', '1', 'nombre', $('#paisRFC').val(),'listaPaises.htm');
	});

	$('#fechaVenEst').blur(function(){
		if($('#fechaVenEst').val()!= ''){
			validaFecha(this.id)
		}
	});

	$('#agrega').click(function() {
		var user = $('#usuarioID').val();	
		var remi = $('#remitenteID').val();	
		
		if(user == 0 && user != ''){
			$('#tipoTransaccion').val(catTipoTransaccionUsuario.agrega);
			$('#tipoActualizacion').val(0);
		}
		
		if(remi != '' && remi == 0 && user > 0){		
			$('#tipoTransaccion').val(catTipoTransaccionUsuario.agregaRemi);
			$('#tipoActualizacion').val(0);						
		}
	});

	$('#modifica').click(function() {
		var user = $('#usuarioID').val();
		var remi = $('#remitenteID').val();
		if(user != '' && user > 0){
			$('#tipoTransaccion').val(catTipoTransaccionUsuario.modifica);
			$('#tipoActualizacion').val(0);
		}			
		if(remi != '' && remi > 0){
			$('#tipoTransaccion').val(catTipoTransaccionUsuario.modificaRemi);
			$('#tipoActualizacion').val(0);	
		}		
	});
	
	$('#inactivar').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionUsuario.actualiza);
		$('#tipoActualizacion').val(catTipoActualizaUsuario.inactivaUsuario);
	});
	
	// Lista de Remitentes del Usuario de Servicio
	$('#remitenteID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "usuarioID";
		camposLista[1] = "nombreCompleto";
		parametrosLista[0] = $('#usuarioID').val();
		parametrosLista[1] = $('#remitenteID').val();

		lista('remitenteID', '2', '3', camposLista, parametrosLista, 'listaUsuario.htm');
	});
	
	// Consulta de Remitentes del Usuario de Servicio
	$('#remitenteID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		var remi = $('#remitenteID').val();
		var user = $('#usuarioID').val();
		if(esTab){	
			if(esNumero(remi)){
				validaRemitenteUsuario();	
			}
			else{
				mensajeSis("Solo se Permiten Números en el Campo Remitente.");
				deshabilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');
			}						
		}
	});
	
	// Lista de Pais de Nacimiento del Remitente
	$('#paisNacimientoRem').bind('keyup',function(e) { 
		lista('paisNacimientoRem', '2', '1', 'nombre', $('#paisNacimientoRem').val(),'listaPaises.htm');
	});

	// Consulta de Pais de Nacimiento del Remitente
	$('#paisNacimientoRem').blur(function() {
		if(esTab){
			consultaPaisNacRem(this.id);
		}
	});
	
	// Lista de Estado de Nacimiento del Remitente
	$('#estadoNacRem').bind('keyup',function(e) {
		lista('estadoNacRem', '2', '1', 'nombre',$('#estadoNacRem').val(),'listaEstados.htm');
	});

	// Consulta de Estado de Nacimiento del Remitente
	$('#estadoNacRem').blur(function() {
		if(esTab){
			consultaEstadoNacRem(this.id);
		}
	});
	
	// Lista de Pais que asigna FEA
	$('#paisFEARem').bind('keyup',function(e) {
		lista('paisFEARem', '2', '1', 'nombre', $('#paisFEARem').val(),'listaPaises.htm');
	});

	// Consulta de Pais que asigna FEA
	$('#paisFEARem').blur(function() {
		if(esTab){
			consultaPaisFeaRem(this.id);
		}
	});
	
	// Lista de Ocupaciones del Remitente
	$('#ocupacionRem').bind('keyup',function(e) { 
		lista('ocupacionRem', '2', '1', 'descripcion',$('#ocupacionRem').val(),'listaOcupaciones.htm');
	});
	
	// Consulta de Ocupaciones del Remitente
	$('#ocupacionRem').blur(function() {
		if(esTab){
			consultaOcupacionRem(this.id);
		}
	});
	
	// Lista de Sector General
	$('#sectorGeneralRem').bind('keyup',function(e){
		lista('sectorGeneralRem', '2', '1', 'descripcion', $('#sectorGeneralRem').val(), 'listaSectores.htm');
	});
	
	// Consulta de Sector General
	$('#sectorGeneralRem').blur(function() {
		if(esTab){
			consultaSecGeneral(this.id);
		}
	});

	// Lista de Actividad BancoMX
	$('#actividadBancoMXRem').bind('keyup',function(e){
		if(this.value.length >= 4){
			lista('actividadBancoMXRem', '4', '1', 'descripcion',
					$('#actividadBancoMXRem').val(), 'listaActividades.htm');
		}
	});
	
	// Consulta de Actividad BancoMX
	$('#actividadBancoMXRem').blur(function() {
		if(esTab){
			consultaActividadBMX(this.id);
		}
	});
	
	// Consulta Tipo de Identificación del Remitente
	$('#tipoIdentiIDRem').blur(function() {
		if(esTab){
			consultaTipoIdentiRem(this.id);
		}
	});
	
	// Valida Fecha Expedición Identificación
	$('#fecExIdenRem').blur(function(){
		if($('#fecExIdenRem').val()!= ''){
			validaFechaRem(this.id)
		}
	});

	// Valida Fecha Vencimiento Identificación
	$('#fecVenIdenRem').blur(function(){
		if($('#fecVenIdenRem').val()!= ''){
			validaFechaRem(this.id)
		}
	});
	
	$('#fecExIdenRem').change(function(){
		$('#fecExIdenRem').focus();
	});
	
	$('#fecVenIdenRem').change(function(){
		$('#fecVenIdenRem').focus();
	});
	
	// Valida el Teléfono de Casa de la extensión
	$("#extTelefonoPartRem").blur(function(){
		if(this.value != ''){
			if($("#telefonoCasaRem").val() == ''){
				this.value = '';
				mensajeSis("El Número de Teléfono está Vacío");
				$("#telefonoCasaRem").focus();
			}
		}
	});
	
	$("#telefonoCasaRem").blur(function (){
		if(this.value ==''){
			$('#extTelefonoPartRem').val('');
		}
	});
	
	//	Valida Nacionalidad del Remitente
	$('#nacionRem').change(function () {
		var nacionRem = $('#nacionRem option:selected').val();
		if(nacionRem != ''){
			validaNacionalidadRem();
		}else{
			mensajeSis("Selecciona una Nacionalidad.");
			$("#nacionRem").focus();
		}
	});
	
	// Lista de Pais de Residencia del Remitente
	$('#paisResidenciaRem').bind('keyup',function(e) { 
		lista('paisResidenciaRem', '1', '1', 'nombre', $('#paisResidenciaRem').val(),'listaPaises.htm');
	});
	
	// Consulta de Pais de Residencia del Remitente
	$('#paisResidenciaRem').blur(function() {
		if(esTab){
			consultaPaisResidenciaRem(this.id);
		}
	});
	
	// ------------ Validaciones 
	$('#formaGenerica').validate({
		rules : {
			//-----PERSONA
			sucursalOrigen : {
				required : true
			},

			usuarioID : {
				required : false 
			},
	
			primerNombre : {
				required : true,
				minlength : 2
			},

			fechaNacimiento : {
				required : function() {return $('#tipoPersona1').is(':checked');},
				date: true
			},

			paisNacimiento : {
				required : function() {return $('#tipoPersona1').is(':checked');}	
			},		

			estadoNac : {
				required : function() {return $('#tipoPersona1').is(':checked');}	
			},		

			telefonoCelular:{
				required : function() {
								if ($('#telefonoCasa').val() == '' && $('#correo').val() == ''){
									return true;
								}else{
									return false;
								}
							}	
			},
			
			telefonoCasa:{
				required : function() {
								if ($('#telefonoCelular').val() == '' && $('#correo').val() == ''){
									return true;
								}else{
									return false;
								}
							}	
			},

			correo : {
				required :  function() {
								if ($('#telefonoCasa').val() == '' && $('#telefonoCelular').val() == ''){
									return true;
								}else{
									return false;
								}
							},	
				email : true
			},
	
			CURP : {
				required : true,
				maxlength : 18
			},
	
			RFC : {
				required : true,
				minlength: 13,
			},

			RFCpm : {
				required : function() {return $('#tipoPersona2').is(':checked');},
				minlength : function() { if($('#tipoPersona2').is(':checked')) return 12; else return 0}
			},

			tipoSociedadID :{
				required : function() {return $('#tipoPersona2').is(':checked');},
			},
	
			paisResidencia :  {
				required:function() {
					return ($('#tipoTransaccion').val() != catTipoTransaccionUsuario.actualiza);
				}
			},

			extTelefonoPart: {
				number: true,
			},
			nivelRiesgo: {
				required:function() {
					return ($('#tipoTransaccion').val() == catTipoTransaccionUsuario.agrega);
				}
			},
			//-----FISICAS
			ocupacionID : {
				required : function() {return $('#tipoPersona1').is(':checked');}
			},
			//-----MORALES
			razonSocial : {
				required : function() {return $('#tipoPersona2').is(':checked'); },
				minlength : 2
			},

			//-----DIRECCION
			tipoDireccionID: {
				required: true,
				minlength: 1
			},
			estadoID: {
				required:function() {
					return ($('#tipoTransaccion').val() != catTipoTransaccionUsuario.actualiza);
				}
			},
			municipioID: {
				required:function() {
					return ($('#tipoTransaccion').val() != catTipoTransaccionUsuario.actualiza);
				}
			},
			localidadID: {
				required:function() {
					return ($('#tipoTransaccion').val() != catTipoTransaccionUsuario.actualiza);
				}
			},
			coloniaID: {
				required:function() {
					return ($('#tipoTransaccion').val() != catTipoTransaccionUsuario.actualiza);
				}
			},	
			calle: {
				required: true,
				minlength: 1
			},	
			CP: {
				required: true,
			    minlength: 5,
				maxlength: 6
			},	
			numExterior: {
				required : function() {return $('#lote').val() == '' && $('#manzana').val() == ''? true : false;},
				minlength: 1
			},	
			piso: {
				maxlength: 50
			},
			manzana: {
				maxlength: 50
			},
			lote: {
				maxlength: 50
			},
			//-----IDENTIFICACION
			tipoIdentiID: {
				required:function() {
					return ($('#tipoTransaccion').val() != catTipoTransaccionUsuario.actualiza);
				}
			},	
			numIdentific:{
				required: true,
			  	minlength:function(){
					var tipoIdenti = $('#tipoIdentiID').val();
					var numc = 5;
					if(tipoIdenti==1){
					var elec= $('#numeroCaracteres').val();
						return elec;
					}if(tipoIdenti==2){
						var pasa= $('#numeroCaracteres').val();
						return pasa;
					}if(tipoIdenti>2){
						return numc;
					}
			  	} ,
			  	maxlength:function(){
					var tipoIdenti = $('#tipoIdentiID').val(); 
					var numc=15;
					if(tipoIdenti==1){
						var elec= $('#numeroCaracteres').val();
						return elec;
					}if(tipoIdenti==2){
						var pasa= $('#numeroCaracteres').val();
						return pasa;
					}if(tipoIdenti>2){
						return numc;
					}
			  	}  
			},
			fecExIden: {
				date : true
			},
			fecVenIden: {
				date : true
			},
			//-----EXTRANJERO
			paisRFC: {
				required : function(){
							if ($('#nacion').val() == 'E'){
								return true;
							}else{ 
								return false;
							}
						}
			},
			sexo: {
				required:function() {
					return ($('#tipoTransaccion').val() != catTipoTransaccionUsuario.actualiza);
				}
			},
			nacion: {
				required:function() {
					return ($('#tipoTransaccion').val() != catTipoTransaccionUsuario.actualiza);
				}
			},
			// Remitente
			nombreCompletoRem : {
				required: function () {
					return ($('#remitenteID').val() == '0');
				}
			},
			tipoPersonaRem : {
				required: function () {
					return ($('#remitenteID').val() == '0');
				}
			},
			sexoRem : {
				required: function () {
					return ($('#remitenteID').val() == '0');
				}    
			}

		},
	
		messages : {
			//-----PERSONA
			sucursalOrigen : {
				required : 'Especifique Sucursal.'
			},

			primerNombre : {
				required : 'Especifique Nombre.',
				minlength : 'Mínimo 2 Caracteres'
			},

			fechaNacimiento : {
				required : 'Especifique Fecha de Nacimiento.',
				date : 'Fecha Incorrecta.'
			},

			paisNacimiento : {
				required : 'Especifique País de Nacimiento.'
			},

			estadoNac : {
				required : 'Especifique Entidad de Nacimiento.'
			},		

			telefonoCelular:{
				required : "Especifique un Teléfono Celular."
			},
			
			telefonoCasa:{
				required : "Especifique un Teléfono."
			},
	
			correo : {
				required : 'Especifique un Correo.',
				email : 'Correo Inválido.'
			},

			CURP : {
				required : 'Especifique CURP.',
				maxlength : 'Máximo 18 Caracteres.'
			},
			RFC	: {
				required	: 'Especifique RFC.',
				minlength	: 'Mínimo 13 Caracteres.',
			}	,
			RFCpm :{
				required : 'Especifique RFC.',
				minlength : 'Mínimo 12 Caracteres'
			},		
			paisResidencia : {
				required: 'Especifique País de Residencia.'
			},
			extTelefonoPart:{
				number:'Sólo Números(Campo opcional).'
			},
			nivelRiesgo:{
				required : "Especifique el Nivel de Riesgo."
			},
			//-----FISICAS
			ocupacionID : {
				required : 'Especifique la Ocupación del Usuario.'
			},
			//-----MORALES
			razonSocial : {
				required : 'Especifique Razón Social.',
				minlength : 'Mínimo 2 Caracteres'
			},

			//-----DIRECCION
			tipoDireccionID: {
				required: 'Especifique Tipo de Dirección.', 
				minlength: 'Mínimo 1 Caracter.'
			},
			estadoID: {
				required: 'Especifique Estado.'
			},
			municipioID: {
				required: 'Especifique Municipio.'
			},
			localidadID: {
				required: 'Especifique Localidad.'
			},
			coloniaID: {
				required: 'Especifique Colonia.'
			},
			calle: {
				required: 'Especifique Calle.', 
				minlength: 'Mínimo 3 Caracteres.'
			},
			CP: {
				required: 'Especifique C.P.', 
       			minlength: 'Mínimo 5 Caracteres',
				maxlength: 'Máximo 6 Caracteres.'
			},
			numExterior: {
				required: 'Especifique Numero Ext.', 
				minlength: 'Mínimo 1 Caracter.'
			},
			piso: {
				maxlength: 'Máximo 50 Caracteres.'
			},
			manzana: {
				maxlength: 'Máximo 50 Caracteres.'
			},
			lote: {
				maxlength: 'Máximo 50 Caracteres.'
			},
			//-----IDENTIFIACIÓN
			tipoIdentiID: {
				required: 'Especifique un Tipo de Identificación.', 
			},
			numIdentific:{
				  required: 'Especifique Folio de Identificación.',
				  minlength:jQuery.format("Se Requieren Mínimo {0} Caracteres."),
				  maxlength:jQuery.format("Se Requieren Máximo {0} Caracteres."),
			}, 
			fecExIden: {
				date : 'Fecha Incorrecta.'
			},
			fecVenIden: {
				date : 'Fecha Incorrecta.'
			},
			//-----EXTRANJERO
			paisRFC: {
					required : 'Especifique País que Asigna RFC.'
			},
			sexo: {
				required: 'Especifique Sexo.', 
			},
			nacion: {
				required: 'Especifique Nacionalidad.', 
			},
			// Remitente
			nombreCompletoRem : {
				required : 'Especifique el Nombre Completo del Remitente'
			},
			tipoPersonaRem : {
				required : 'Especifique Tipo de Persona del Remitente.'          
			},
			sexoRem : {
				required : 'Especifique Género del Remitente.',  
			}  
		}
	});
		
	//------------------------------FUNCIONES-------------------------------------
	function validaUsuario(){
		var numUsuario = $('#usuarioID').val()
		setTimeout("$('#cajaLista').hide();", 200);
		var conUsuario = 1;
		
		if (numUsuario != '' && !isNaN(numUsuario) ) {
			if (numUsuario == 0) {
				inicializaForma('formaGenerica', 'usuarioID');
				habilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');
				deshabilitaBoton('inactivar', 'submit');
				limpiaCombosInicio();
				$('#tipoPersona1').attr("checked",true);

				$('#identiUsuario').hide();
			}else{
				inicializaForma('formaGenerica', 'usuarioID');
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				$('#tipoPersona1').attr("checked",true);
				
				var usuarioBean = {
					'usuarioID' : numUsuario
				};
				
				usuarioServicios.consulta(conUsuario,usuarioBean,function(usuario) {
					if(usuario!=null){
						$('#identiUsuario').show();
						//DATOS PERSONA
						$('#primerNombre').val(usuario.primerNombre);
						$('#segundoNombre').val(usuario.segundoNombre);
						$('#tercerNombre').val(usuario.tercerNombre);
						$('#apellidoPaterno').val(usuario.apellidoPaterno);
						$('#apellidoMaterno').val(usuario.apellidoMaterno);

						$('#fechaNacimiento').val(usuario.fechaNacimiento);
						$('#paisNacimiento').val(usuario.paisNacimiento);
						consultaPaisNac('paisNacimiento',2);
						$('#nacion').val(usuario.nacion);
						$('#estadoNac').val(usuario.estadoNac);
						consultaEstadoNac('estadoNac');
						$('#paisResidencia').val(usuario.paisResidencia);
						consultaPais('paisResidencia');
						$('#sexo').val(usuario.sexo);
						$('#telefonoCelular').val(usuario.telefonoCelular);
						$('#telefonoCasa').val(usuario.telefonoCasa);
						$('#extTelefonoPart').val(usuario.extTelefonoPart);
						$('#correo').val(usuario.correo);

						$("#telefonoCelular").setMask('phone-us');
						$("#telefonoCasa").setMask('phone-us');	

						$('#CURP').val(usuario.CURP);
						$('#RFC').val(usuario.RFC);
						$('#FEA').val(usuario.FEA);
						

						if(usuario.fechaConstitucion == '1900-01-01'){
							$('#fechaConstitucion').val('');
						}else{
							$('#fechaConstitucion').val(usuario.fechaConstitucion);
						}
						
						$('#nivelRiesgo').val(usuario.nivelRiesgo);
						
						//MOJARAR PROCESO
						if (usuario.tipoPersona == 'F') {
							$('#tipoPersona1').attr("checked",true);
							permiteCalcularCURPyRFC('','generar',2);
							$('#personaFisica').show(500);
							$('#personaMoral').hide(500);
							
							$('#ocupacionID').val(usuario.ocupacionID);
							consultaOcupacion('ocupacionID');

						} else if (usuario.tipoPersona == 'M') {
							$('#tipoPersona2').attr("checked",true);
							$('#generar').hide(500);
							$('#personaFisica').hide(500);
							$('#personaMoral').show(500);

							$('#razonSocial').val(usuario.razonSocial);
							$('#tipoSociedadID').val(usuario.tipoSociedadID);
							consultaSociedad('tipoSociedadID');
							$('#RFCpm').val(usuario.RFCpm);
						}else{
							$('#tipoPersona3').attr("checked",true);
							$('#generar').hide(500);
							$('#personaFisica').show(500);
							$('#personaMoral').hide(500);

							$('#ocupacionID').val(usuario.ocupacionID);
							consultaOcupacion('ocupacionID');
						}

						//DIRECCION
						$('#tipoDireccionID').val(usuario.tipoDireccionID);
						$('#estadoID').val(usuario.estadoID);
						consultaEstado('estadoID');
						$('#municipioID').val(usuario.municipioID);
						consultaMunicipio('municipioID');
						$('#localidadID').val(usuario.localidadID);
						consultaLocalidad('localidadID');
						$('#coloniaID').val(usuario.coloniaID);
						consultaColonia('coloniaID',false);
						$('#calle').val(usuario.calle);
						$('#numExterior').val(usuario.numExterior);
						$('#numInterior').val(usuario.numInterior);
						$('#piso').val(usuario.piso);
						$('#CP').val(usuario.CP);
						$('#lote').val(usuario.lote);
						$('#manzana').val(usuario.manzana);

						//IDENTIFICACION
						$('#tipoIdentiID').val(usuario.tipoIdentiID);
						consultaTipoIdenti();
						$('#numIdentific').val(usuario.numIdentific);
						
						if(usuario.fecExIden == '1900-01-01'){
							$('#fecExIden').val('');
						}else{
							$('#fecExIden').val(usuario.fecExIden);
						}
						
						if(usuario.fecVenIden == '1900-01-01'){
							$('#fecVenIden').val('');
						}else{
							$('#fecVenIden').val(usuario.fecVenIden);		
						}

						//EXTRANJERO
						if($('#nacion').val() == 'E') {
							$('#docEstanciaLegal').val(usuario.docEstanciaLegal);
							$('#docExisLegal').val(usuario.docExisLegal);

							if(usuario.fechaVenEst == '1900-01-01'){
								$('#fechaVenEst').val('');
							}else{
								$('#fechaVenEst').val(usuario.fechaVenEst);		
							}

							$('#paisRFC').val(usuario.paisRFC);
							consultaPais('paisRFC');
						}

						consultaArchivoUsuario();
						consultaOficialCumplimiento();
						
						if(usuario.estatus == "I"){
							mensajeSis("El Usuario de Servicio se encuentra Inactivo.");							
							$('#identiUsuario').hide();						
							deshabilitaBoton('agrega', 'submit');												
							deshabilitaBoton('modifica', 'submit');
							deshabilitaBoton('inactivar','submit');
							
						}
					}else{
						mensajeSis("No Existe el Usuario.");
						inicializaForma('formaGenerica', 'usuarioID');
						$('#tipoPersona1').attr('checked', true);
						$('#usuarioID').focus();

						$('#identiUsuario').hide();
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('inactivar','submit');
					}
				});
			}
		}else{
			inicializaForma('formaGenerica', 'usuarioID');
			$('#tipoPersona1').attr('checked', true);
		}
	}

	function consultaPais(idControl) {
		var jqPais = eval("'#" + idControl + "'");
		var numPais = $(jqPais).val();
		var conPais = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPais != '' && !isNaN(numPais)) {
			paisesServicio.consultaPaises(conPais, numPais, function(pais) {
				if (pais != null) {
					if (idControl == 'paisRFC') {
						$('#NomPaisRFC').val(pais.nombre);
					}else{
						$('#paisR').val(pais.nombre);	
					}
				} else {
					mensajeSis("No Existe el País.");
					if (idControl == 'paisRFC') {
						$('#paisRFC').focus();	
					}else{
						$('#paisResidencia').focus();
						
					}
				}
			});
		}
	}

	function consultaPaisNac(idControl,origen) {
		var jqPais = eval("'#" + idControl + "'");
		var numPais = $(jqPais).val();
		var conPais = 2;

		setTimeout("$('#cajaLista').hide();", 200);
		if (numPais != '' && !isNaN(numPais)) {
			paisesServicio.consultaPaises(conPais, numPais,function(pais) {
				if (pais != null) {
					$('#paisNac').val(pais.nombre);
					if (pais.paisID != 700) {
						$('#nacion').val('E');
						$('#estadoNac').val(0);
						$('#estadoNac').attr('readonly',true);
						$('#nombreEstado').val('NO APLICA');
						$('#extranjero').show(500);	
					} else if (pais.paisID == 700) {
						$('#nacion').val('N');
						if (origen ==1) {
							$('#estadoNac').val('');
							$('#nombreEstado').val('');	
						}
						$('#extranjero').hide(500);
						$('#estadoNac').attr('readonly',false);
					}
					validaNacionalidad();
				} else {
					mensajeSis("No Existe el País.");
					$('#paisNacimiento').focus();
				}
			});
		}
	}
	
	// FUNCIÓN PARA CONSULTAR EL PAIS DE NACIMIENTO DEL REMITENTE
	function consultaPaisNacRem(idControl) {
		var jqPais = eval("'#" + idControl + "'");
		var numPais = $(jqPais).val();
		var conPais = 2;

		setTimeout("$('#cajaLista').hide();", 200);
		if (numPais != '' && !isNaN(numPais) && numPais > 0) {
			paisesServicio.consultaPaises(conPais, numPais,function(pais) {
				if (pais != null) {
					$('#paisNacRem').val(pais.nombre);
					if (pais.paisID != 700) {
						$('#nacionRem').val('E');
						$('#estadoNacRem').val(0);
						$('#estadoNacRem').attr('readonly',true);
						$('#nombreEstadoRem').val('NO APLICA');
					} else if (pais.paisID == 700) {
						$('#nacionRem').val('N');
						$('#paisNacRem').val(pais.nombre);
						$('#estadoNacRem').attr('readonly',false);
						$('#nombreEstadoRem').val('');
					}
					validaNacionalidadRem();
				} else {
					mensajeSis("No Existe el País.");
					$('#paisNacimientoRem').focus();
					$('#paisNacimientoRem').val('');
					$('#paisNacRem').val('');
				}
			});
		}
		if(numPais == 0 || numPais == ''){
			$('#paisNacimientoRem').val('');
			$('#paisNacRem').val('');
		}
	}

	function validaNacionalidad(){
		var nacionalidad = $('#nacion').val();
		var pais= $('#paisNacimiento').val();
		var mexico='700';
		var mexicana='N';
		var extranjera='E';
	
		if(nacionalidad==mexicana){
			$('#extranjero').hide(500);
			if(pais!=mexico){
				mensajeSis("Por la Nacionalidad de la Persona el País debe ser México");
				$('#paisNacimiento').val('');
				$('#paisNac').val('');
				$('#estadoNac').val('');
				$('#nombreEstado').val('');
			}
		}else if(nacionalidad==extranjera){
			$('#extranjero').show(500);
			if(pais==mexico){
				mensajeSis("Por la Nacionalidad de la Persona el País No debe ser México");
				$('#paisNacimiento').val('');
				$('#paisNac').val('');
				$('#estadoNac').val('');
				$('#nombreEstado').val('');
			}
		}
	}
	
	// FUNCIÒN PARA VALIDAR LA NACIONALIDAD DEL REMITENTE
	function validaNacionalidadRem(){
		var nacionalidad = $('#nacionRem').val();
		var pais= $('#paisNacimientoRem').val();
		var mexico='700';
		var mexicana='N';
		var extranjera='E';
	
		if(nacionalidad==mexicana){
			if(pais!=mexico){
				mensajeSis("Por la Nacionalidad de la Persona el País debe ser México");
				$('#paisNacimientoRem').focus();
				$('#paisNacimientoRem').val('');
				$('#paisNacRem').val('');
				$('#estadoNacRem').val('');
				$('#nombreEstadoRem').val('');
			}
		}else if(nacionalidad==extranjera){
			if(pais==mexico){
				mensajeSis("Por la Nacionalidad de la Persona el País No debe ser México");
				$('#paisNacimientoRem').focus();
				$('#paisNacimientoRem').val('');
				$('#paisNacRem').val('');
				$('#estadoNacRem').val('');
				$('#nombreEstadoRem').val('');
			}
		}
	}
	
	// FUNCIÓN PARA CONSULTAR PAIS QUE ASIGNA FEA
	function consultaPaisFeaRem(idControl) {
		var jqPais = eval("'#" + idControl + "'");
		var numPais = $(jqPais).val();
		var conPais = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPais != '' && !isNaN(numPais) && numPais > 0) {
			paisesServicio.consultaPaises(conPais, numPais,function(pais) {
				if (pais != null) {
					$('#descPaisFEARem').val(pais.nombre);
				}
				else {
					mensajeSis("No Existe el País.");
					$('#paisFEARem').focus();
					$('#paisFEARem').val('');
					$('#descPaisFEARem').val('');
				}
			});
		}
		if(numPais == 0 || numPais ==''){
			$('#paisFEARem').val('');
			$('#descPaisFEARem').val('');
		}
	}
	
	// FUNCIÓN PARA CONSULTAR PAIS DE RESIDENCIA
	function consultaPaisResidenciaRem(idControl) {
		var jqPais = eval("'#" + idControl + "'");
		var numPais = $(jqPais).val();
		var conPais = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPais != '' && !isNaN(numPais) && numPais > 0) {
			paisesServicio.consultaPaises(conPais, numPais, function(pais) {
				if (pais != null) {
					$('#descpaisR').val(pais.nombre);	
				} else {
					mensajeSis("No Existe el País.");
					$('#paisResidenciaRem').focus();
					$('#paisResidenciaRem').val('');
					$('#descpaisR').val('');
				}
			});
		}
		if(numPais == 0 || numPais ==''){
			$('#paisResidenciaRem').val('');
			$('#descpaisR').val('');
		}
	}
	
	// FUNCIÓN PARA CONSULTAR EL SECTOR GENERAL
	function consultaSecGeneral(idControl) {
		var jqSecG = eval("'#" + idControl + "'");
		var numSec = $(jqSecG).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		var sectoresBeanCon = {
				'sectorID':numSec
			};
		if(numSec != '' && !isNaN(numSec)){
			sectoresServicio.consulta(tipConForanea,sectoresBeanCon,function(sector) {
				if(sector!=null){
					$('#descSectorGralRem').val(sector.descripcion);
				}else{
					mensajeSis("No Existe el Sector.");
					$('#sectorGeneralRem').focus();
					$('#sectorGeneralRem').val('');
					$('#descSectorGralRem').val('');
				}
			});
		}else {
			$('#sectorGeneralRem').val('');
			$('#descSectorGralRem').val('');
		}
	}
	
	function consultaEstadoNac(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numEstado != '' && !isNaN(numEstado)) {
			estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
				if (estado != null) {
					if ($('#paisNacimiento').val() == 700 && estado.estadoID == 0) {
						mensajeSis("No Existe el Estado.");
						$('#estadoNac').focus();
					}
					$('#nombreEstado').val(estado.nombre);
				} else {
					mensajeSis("No Existe el Estado.");
				}
			});
		}
	}
	
	// FUNCIÓN PARA CONSULTAR EL ESTADO DE NACIMIENTO DEL REMITENTE
	function consultaEstadoNacRem(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numEstado != '' && !isNaN(numEstado)) {
			estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
				if (estado != null) {
					if ($('#paisNacimientoRem').val() == 700 && estado.estadoID == 0) {
						mensajeSis("No Existe el Estado.");
						$('#estadoNacRem').focus();
						$('#estadoNacRem').val('');
						$('#nombreEstadoRem').val('');
					}
					$('#nombreEstadoRem').val(estado.nombre);
				} else {
					mensajeSis("No Existe el Estado.");
					$('#estadoNacRem').focus();
					$('#estadoNacRem').val('');
					$('#nombreEstadoRem').val('');
				}
			});
		}
	}

	function consultaOcupacion(idControl) {
		var jqOcupacion = eval("'#" + idControl + "'");
		var numOcupacion = $(jqOcupacion).val();
		var tipConForanea = 2;		
		
		setTimeout("$('#cajaLista').hide();", 200);		
		if (numOcupacion != 0 && numOcupacion != '' && !isNaN(numOcupacion) ) {
			ocupacionesServicio.consultaOcupacion(tipConForanea, numOcupacion, function(ocupacion) {
				if (ocupacion != null) {
					$('#ocupacionC').val(ocupacion.descripcion);
				} else {
					mensajeSis("No Existe la Ocupación");
					$('#ocupacionC').val('');
					$('#ocupacionID').focus();
				}
				
			});
		}else{
			$('#ocupacionID').val('');
			$('#ocupacionC').val('');
		}
	}
	
	// FUNCIÓN PARA CONSULTAR LAS OCUPACIONES DEL REMITENTE
	function consultaOcupacionRem(idControl) {
		var jqOcupacion = eval("'#" + idControl + "'");
		var numOcupacion = $(jqOcupacion).val();
		var tipConForanea = 2;		
		
		setTimeout("$('#cajaLista').hide();", 200);		
		if (numOcupacion != 0 && numOcupacion != '' && !isNaN(numOcupacion) ) {
			ocupacionesServicio.consultaOcupacion(tipConForanea, numOcupacion, function(ocupacion) {
				if (ocupacion != null) {
					$('#descOcupacionRem').val(ocupacion.descripcion);
				} else {
					mensajeSis("No Existe la Ocupación.");
					$('#ocupacionRem').focus();
					$('#ocupacionRem').val('');
					$('#descOcupacionRem').val('');
				}
			});
		}else{
			$('#ocupacionRem').val('');
			$('#descOcupacionRem').val('');
		}
	}

	function consultaSociedad(idControl) {
		var jqSociedad = eval("'#" + idControl + "'");
		var numSociedad = $(jqSociedad).val();
		setTimeout("$('#cajaLista').hide();", 200);
		var SociedadBeanCon = {
			'tipoSociedadID' : numSociedad
		};
		if (numSociedad != '' && !isNaN(numSociedad)) {
			tipoSociedadServicio.consulta(catTipoConsultaSociedad.foranea, SociedadBeanCon,function(sociedad) {
				if (sociedad != null) {
					$('#descripSociedad').val(sociedad.descripcion);
				} else {
					var tp = $('#tipoPersona1').val();
					if (tp == 'M') {
						mensajeSis("No Existe el Tipo de Sociedad");
					}
				}
			});
		}
	}

	function consultaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numEstado != '' && !isNaN(numEstado)) {
			estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
				if (estado != null) {
					$('#nomEstado').val(estado.nombre);
				} else {
					mensajeSis("No Existe el Estado.");
					$(jqEstado).focus();
					$('#nomEstado').val('');
				}
			});
		}
	}

	function consultaMunicipio(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();	
		var numEstado =  $('#estadoID').val();				
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numMunicipio != '' && !isNaN(numMunicipio)){
			municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
				if(municipio!=null){							
					$('#nombreMuni').val(municipio.nombre);
				}else{
					mensajeSis('No Existe el Municipio.');
					$('#nombreMuni').val('');
					$('#municipioID').val('');
					$('#municipioID').focus();
				}    	 						
			});
		}
	}

	function consultaLocalidad(idControl) {
		var jqLocalidad = eval("'#" + idControl + "'");
		var numLocalidad = $(jqLocalidad).val();
		var numMunicipio =	$('#municipioID').val();
		var numEstado =  $('#estadoID').val();				
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numLocalidad != '' && !isNaN(numLocalidad)){
			localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad,function(localidad) {
				if(localidad!=null){	
					$('#nombreLocalidad').val(localidad.nombreLocalidad);
				}else{
					mensajeSis("No Existe la Localidad.");
					$('#nombrelocalidad').val("");
					$('#localidadID').val("");
					$('#localidadID').focus();
				}    	 						
			});
		}
	}

	//consulta Colonia y CP
	function consultaColonia(idControl, desdeInput) {
		var jqColonia = eval("'#" + idControl + "'");
		var numColonia= $(jqColonia).val();		
		var numEstado =  $('#estadoID').val();	
		var numMunicipio =	$('#municipioID').val();
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numColonia != '' && !isNaN(numColonia)){
			coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,function(colonia) {
				if(colonia!=null){							
					$('#nombreColonia').val(colonia.asentamiento);
					if($('#CP').val()==''||colonia.codigoPostal!=''){
						$('#CP').val(colonia.codigoPostal);
					}
				}else{
					if(desdeInput){
						mensajeSis('No Existe la Colonia.');
						$('#coloniaID').focus();
					}
					$('#nombreColonia').val('');
					$('#coloniaID').val('');
				}    	 						
			});
		}else{
			$('#nombreColonia').val("");
		}
	}

	function consultaTipoIdenti() {
		var conIdenti = 1;	
		var oficialNo= 'N';
		var numTipoIden = $('#tipoIdentiID').val();
		
		if(numTipoIden != '' && !isNaN(numTipoIden)){
			tiposIdentiServicio.consulta(conIdenti,numTipoIden,function(identificacion) {
				if(identificacion!=null){							
					$('#numeroCaracteres').val(identificacion.numeroCaracteres);
				}else{
					mensajeSis("No Existe la Identificación.");
				}    	 						
			});
		}
	}
	
	// FUNCIÓN PARA CONSULTAR EL TIPO DE IDENTIFICACIÓN DEL REMITENTE
	function consultaTipoIdentiRem() {
		var conIdenti = 1;	
		var oficialNo= 'N';
		var numTipoIden = $('#tipoIdentiIDRem').val();
		
		if(numTipoIden != '' && !isNaN(numTipoIden)){
			tiposIdentiServicio.consulta(conIdenti,numTipoIden,function(identificacion) {
				if(identificacion!=null){							
					$('#numeroCaracteres').val(identificacion.numeroCaracteres);
				}else{
					mensajeSis("No Existe la Identificación.");
				}    	 						
			});
		}
	}


	function formaCURP() {
		var sexo = $('#sexo').val();
		var nacionalidad = $('#nacion').val();
		if(sexo == "M"){
			sexo = "H";
		}else if(sexo == "F"){
			sexo = "M";
		}else{
			sexo = "H";
			mensajeSis("Especifique el Sexo.");
		}
		
		if(nacionalidad == "N"){
			nacionalidad = "N";
		}else if(nacionalidad == "E"){
			nacionalidad = "S";
		}else{
			nacionalidad = "N";
			mensajeSis("Especifique la Nacionalidad.");
		}

		var CURPBean = {
			'primerNombre'	: $('#primerNombre').val(),
			'segundoNombre'	: $('#segundoNombre').val(),
			'tercerNombre'	: $('#tercerNombre').val(),
			'apellidoPaterno' : $('#apellidoPaterno').val(),
			'apellidoMaterno' : $('#apellidoMaterno').val(),
			'sexo' : sexo,
			'fechaNacimiento' : $('#fechaNacimiento').val(),
			'nacion' : nacionalidad,
			'estadoID' : $('#estadoNac').val()
		};

		clienteServicio.formaCURP(CURPBean, function(cliente) {
			if (cliente != null) {
				$('#CURP').val(cliente.CURP);
			}
		});
	}

	function formaRFC() {
		var pn = $('#primerNombre').val();
		var sn = $('#segundoNombre').val();
		var tn = $('#tercerNombre').val();
		var nc = pn + ' ' + sn + ' ' + tn;

		var rfcBean = {
			'primerNombre' : nc,
			'apellidoPaterno' : $('#apellidoPaterno').val(),
			'apellidoMaterno' : $('#apellidoMaterno').val(),
			'fechaNacimiento' : $('#fechaNacimiento').val()
		};
		clienteServicio.formaRFC(rfcBean, function(cliente) {
			if (cliente != null) {
				$('#RFC').val(cliente.RFC);
			}
		});
	}

	function validaFecha(idControl){
		var jqFecha = eval("'#" + idControl + "'");
		var Xfecha = $(jqFecha).val();		
		var Yfecha =  parametroBean.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if(Xfecha == ''){
				$(jqFecha).val(parametroBean.fechaSucursal);
			}

			if(idControl == 'fecVenIden' || idControl == 'fechaVenEst'){
				if(mayor(Yfecha, Xfecha)){
					mensajeSis("La Fecha ha Vencido.");
					$(jqFecha).val(parametroBean.fechaSucursal);
					$(jqFecha).focus();
					$(jqFecha).val('');
				}
			}else{
				if(mayor(Xfecha, Yfecha)){
					mensajeSis("La Fecha Capturada es Mayor a la Actual.");
					$(jqFecha).val(parametroBean.fechaSucursal);
					$(jqFecha).focus();
					$(jqFecha).select();
				}
			}
		}else{
			$(jqFecha).val(parametroBean.fechaSucursal);
			$(jqFecha).focus();
			$(jqFecha).select();
		}
	}
	
	// FUNCIÓN PARA VALIDAR LAS FECHAS DE IDENTIFICACIÓN DE REMITENTES
	function validaFechaRem(idControl){
		var jqFecha = eval("'#" + idControl + "'");
		var Xfecha = $(jqFecha).val();		
		var Yfecha =  parametroBean.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if(Xfecha == ''){
				$(jqFecha).val(parametroBean.fechaSucursal);
			}

			if(idControl == 'fecVenIdenRem' || idControl == 'fecVenIdenRem'){
				if(mayor(Yfecha, Xfecha)){
					mensajeSis("La Fecha ha Vencido.");
					$(jqFecha).val(parametroBean.fechaSucursal);
					$(jqFecha).focus();
					$(jqFecha).val('');
				}
			}else{
				if(mayor(Xfecha, Yfecha)){
					mensajeSis("La Fecha Capturada es Mayor a la Actual.");
					$(jqFecha).val(parametroBean.fechaSucursal);
					$(jqFecha).focus();
					$(jqFecha).select();
				}
			}
		}else{
			$(jqFecha).val(parametroBean.fechaSucursal);
			$(jqFecha).focus();
			$(jqFecha).select();
		}
	}

	/* Función para validar Formato Fecha (yyyy-MM-dd)*/
	function esFechaValida(fecha){
		var mes=  fecha.substring(5, 7)*1;
		var dia= fecha.substring(8, 10)*1;
		var anio= fecha.substring(0,4)*1;
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;

		if (fecha != undefined && fecha.value != "" ){
			if (!objRegExp.test(fecha)){
				mensajeSis("Formato de Fecha No Válido (aaaa-mm-dd)");
				return false;
			}

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
					mensajeSis("Fecha Incorrecta.");
				return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha Incorrecta.");
				return false;
			}
			return true;
		}
	}

	// Función para Validar si fecha > fecha2: BOOLEANO
	function mayor(fecha, fecha2){ 
		var xMes=fecha.substring(5, 7);
		var xDia=fecha.substring(8, 10);
		var xAnio=fecha.substring(0,4);
		var yMes=fecha2.substring(5, 7);
		var yDia=fecha2.substring(8, 10);
		var yAnio=fecha2.substring(0,4);

		if (xAnio > yAnio){
			return true;
		}else{
			if (xAnio == yAnio){
				if (xMes > yMes){
					return true;
				}
				if (xMes == yMes){
					if (xDia > yDia){
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

	function cargaComboDireccion(){
		dwr.util.removeAllOptions('tipoDireccionID'); 
		tiposDireccionServicio.listaCombo(3, function(tdirecciones){
			dwr.util.addOptions('tipoDireccionID', {'':'SELECCIONAR'});	
			dwr.util.addOptions('tipoDireccionID', tdirecciones, 'tipoDireccionID', 'descripcion');
	
		});
	}

	function cargaComboIdentificacion(){
		dwr.util.removeAllOptions('tipoIdentiID'); 
		tiposIdentiServicio.listaCombo(3, function(tIdentific){
			dwr.util.addOptions('tipoIdentiID'	,{'':'SELECCIONAR'});
			dwr.util.addOptions('tipoIdentiID', tIdentific, 'tipoIdentiID', 'nombre');
		});		
	}
	
	// FUNCIÓN PARA CARGAR EL COMBO DE TIPO DE IDENTIFICACIÓN DEL REMITENTE
	function cargaComboTipoIdenRemitente(){
		dwr.util.removeAllOptions('tipoIdentiIDRem'); 
		tiposIdentiServicio.listaCombo(3, function(tIdentific){
			dwr.util.addOptions('tipoIdentiIDRem'	,{'':'SELECCIONAR'});
			dwr.util.addOptions('tipoIdentiIDRem', tIdentific, 'tipoIdentiID', 'nombre');
		});		
	}
	
	// FUNCIÓN PARA CARGAR TIPO DE PERSONA
	function cargaComboTipoPersona(){
		dwr.util.removeAllOptions('tipoPersonaRem'); 
		usuarioServicios.listaCombo(3, function(tipoPersona){
			dwr.util.addOptions('tipoPersonaRem'	,{'':'SELECCIONAR'});
			dwr.util.addOptions('tipoPersonaRem', tipoPersona, 'tipoPersona', 'descripcion');
		});		
	}
	
	$('#adjuntar').click(function() {
		if($('#tipoIdentiID').val() == ''){
			mensajeSis("Seleccione un Tipo de Identificación");
			$('#tipoIdentiID').focus();
		}else{
			if ($('#numIdentific').val() == ''){
				mensajeSis("Epecifique un Folio de Identificación");
				$('#numIdentific').focus();
			}else{
				subirArchivos();
			}
		}
	});
	
	
	function subirArchivos() {
		var url ="usuarioFileUploadVista.htm?Usr="+$('#usuarioID').val()+"&Ti="+$('#tipoIdentiID').val();
		var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
		var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;

		ventanaArchivosCuenta = window.open(url,"PopUpSubirArchivo","width=680,height=340,scrollbars=auto,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
										"left="+leftPosition+
										",top="+topPosition+
										",screenX="+leftPosition+
										",screenY="+topPosition);	
		
	}

	/***********************************/
	//FUNCION PARA MOSTRAR O OCULTAR BOTONES CALCULAR CURP o RFC
	//PRIMER PARAMETRO ID BOTON CURP
	//SEGUNDO PARAMETRO ID BOTON RFC
	//TERCER PARAMETRO 1= SOLO CURP, 2= SOLO RFC, 3= AMBOS
	function permiteCalcularCURPyRFC(idBotonCURP,idBotonRFC,tipo) {
		var jqBotonCURP = eval("'#" + idBotonCURP + "'");
		var jqBotonRFC = eval("'#" + idBotonRFC + "'");
		var numEmpresaID = 1;
		var tipoCon = 17;
		var ParametrosSisBean = {
				'empresaID'	:numEmpresaID
		};
		parametrosSisServicio.consulta(tipoCon,ParametrosSisBean,function(parametrosSisBean) {
			if (parametrosSisBean != null) {
				//Validacion para mostrarar boton de calcular CURP Y RFC
				if(parametrosSisBean.calculaCURPyRFC == 'S'){
					if(tipo == 3){
						$(jqBotonCURP).show();
						$(jqBotonRFC).show();						
					}else{
						if(tipo == 1){
							$(jqBotonCURP).show();					
						}else{
							if(tipo == 2){
								$(jqBotonRFC).show();						
							}
						}
					}
				}else{
					if(tipo == 3){
						$(jqBotonCURP).hide();
						$(jqBotonRFC).hide();						
					}else{
						if(tipo == 1){
							$(jqBotonCURP).hide();					
						}else{
							if(tipo == 2){
								$(jqBotonRFC).hide();						
							}
						}
					}
				}
			}
		});
	}	
	
	// El boton de 'Inactivar Usuario' solo esta disponible para el usuario que es Oficial de Cumplimiento
	function consultaOficialCumplimiento(){
		var tipoConsulta = 19;
		var idUsuarioSesion = consultaParametrosSession().numeroUsuario * 1;
		var ParametrosSisBean = {
				'empresaID'	:1
		};

		parametrosSisServicio.consulta(tipoConsulta,ParametrosSisBean,{ async: false, callback:function(parametrosSisBean) {
			if (parametrosSisBean != null) {
				var oficialCumplimiento =  parametrosSisBean.oficialCumID * 1;

				if(oficialCumplimiento === idUsuarioSesion){
					habilitaBoton('inactivar','submit');
				}else{
					deshabilitaBoton('inactivar','submit');
				}
			}
		}});
	}
	
	// FUNCIÓN PARA VALIDAR REMITENTES DE USUARIO DE SERVICIOS
	function validaRemitenteUsuario(){
		var numUsuario = $('#usuarioID').val();
		var numRemitente = $('#remitenteID').val()
		var conUsuario = 4;
		setTimeout("$('#cajaLista').hide();", 200);

		if (numRemitente != '' && !isNaN(numRemitente)&& numRemitente > 0) {
			deshabilitaBoton('agrega', 'submit');
			deshabilitaBoton('inactivar', 'submit');
			habilitaBoton('modifica', 'submit');		
			var usuarioBean = {
				'usuarioID' : numUsuario,
				'remitenteID' : numRemitente
			};
			limpiaCamposRemitentes();
			usuarioServicios.consulta(conUsuario,usuarioBean,function(remitentes) {
				if(remitentes!=null){
					$('#tituloRem').val(remitentes.tituloRem);
					$('#tipoPersonaRem').val(remitentes.tipoPersonaRem);
					$('#nombreCompletoRem').val(remitentes.nombreCompletoRem);
					
					if(remitentes.fechaNacimientoRem == '1900-01-01'){
						$('#fechaNacimientoRem').val('');
					}else {
						$('#fechaNacimientoRem').val(remitentes.fechaNacimientoRem);
					}
					// FALTA LLAMAR A METODOS PARA CONSULTAR PAIS, ESTADO, OCUPACION, SECTORES, ACTIVIDAD INEGI
					$('#paisNacimientoRem').val(remitentes.paisNacimientoRem);
					consultaPaisNacRem('paisNacimientoRem');// Consulta Pais
					
					$('#estadoNacRem').val(remitentes.estadoNacRem);
					consultaEstadoNacRem('estadoNacRem');// Consulta estado
					$('#estadoCivilRem').val(remitentes.estadoCivilRem);
					
					$('#sexoRem').val(remitentes.sexoRem);
					$('#CURPRem').val(remitentes.CURPRem);
					$('#RFCRem').val(remitentes.RFCRem);
					
					$('#FEARem').val(remitentes.FEARem);
					$('#paisFEARem').val(remitentes.paisFEARem);
					consultaPaisFeaRem('paisFEARem');// Consulta Pais FEA
					$('#ocupacionRem').val(remitentes.ocupacionRem);
					consultaOcupacionRem('ocupacionRem');// Consulta Ocupacion
					$('#puestoRem').val(remitentes.puestoRem);
					$('#sectorGeneralRem').val(remitentes.sectorGeneralRem);
					consultaSecGeneral('sectorGeneralRem');// Consulta Sector General
					
					$('#actividadBancoMXRem').val(remitentes.actividadBancoMXRem);
					$('#actividadINEGIRem').val(remitentes.actividadINEGIRem);					
					$('#sectorEconomicoRem').val(remitentes.sectorEconomicoRem);
					consultaActividadBMX('actividadBancoMXRem');// Consulta Actividad Banco MX				
					$('#tipoIdentiIDRem').val(remitentes.tipoIdentiIDRem);
					$('#numIdentificRem').val(remitentes.numIdentificRem);
					
					if(remitentes.fecExIdenRem == '1900-01-01'){
						$('#fecExIdenRem').val('');
					}else {
						$('#fecExIdenRem').val(remitentes.fecExIdenRem);
					}
					
					if(remitentes.fecVenIdenRem == '1900-01-01'){
						$('#fecVenIdenRem').val('');
					}else {
						$('#fecVenIdenRem').val(remitentes.fecVenIdenRem);
					}
					
					$('#telefonoCasaRem').val(remitentes.telefonoCasaRem);
					$('#extTelefonoPartRem').val(remitentes.extTelefonoPartRem);
					$('#telefonoCelularRem').val(remitentes.telefonoCelularRem);
					
					$('#correoRem').val(remitentes.correoRem);
					$('#domicilioRem').val(remitentes.domicilioRem);
					$('#nacionRem').val(remitentes.nacionRem);
					$('#paisResidenciaRem').val(remitentes.paisResidenciaRem);
					consultaPaisResidenciaRem('paisResidenciaRem');// Consulta Pais Residencia
					
				}else{
					mensajeSis("El Remitente del Usuario de Servicio No Existe.");
					limpiaCamposRemitentes();
					$('#remitenteID').focus();
					$('#remitenteID').val("");
				}
			});
		}else{
			limpiaCamposRemitentes();
			habilitaBoton('agrega', 'submit');
			deshabilitaBoton('inactivar', 'submit');
			deshabilitaBoton('modifica', 'submit');
		}
	}
	
	// FUNCIÓN PARA CONSULTAR LA ACTIVIDAD BANCO MX
	function consultaActividadBMX(idControl) {
		var jqActividad = eval("'#" + idControl + "'");
		var numActividad = $(jqActividad).val();
		var tipConCompleta = 3;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numActividad != '' && !isNaN(numActividad)){
			actividadesServicio.consultaActCompleta(tipConCompleta, numActividad,function(actividadComp) {
				if(actividadComp!=null){
					$('#descripcionBMXRem').val(actividadComp.descripcionBMX);
					$('#actividadINEGIRem').val(actividadComp.actividadINEGIID);
					$('#descripcionINEGIRem').val(actividadComp.descripcionINE);
					$('#sectorEconomicoRem').val(actividadComp.sectorEcoID);
					$('#descripcionSERem').val(actividadComp.descripcionSEC);
				}else{
					mensajeSis("No Existe la Actividad BMX");
					$('#descripcionBMXRem').val('');
					$('#actividadINEGIRem').val('');
					$('#descripcionINEGIRem').val('');
					$('#sectorEconomicoRem').val('');
					$('#descripcionSERem').val('');
				}
			});
		}else {
			$('#descripcionBMXRem').val('');
			$('#actividadINEGIRem').val('');
			$('#descripcionINEGIRem').val('');
			$('#sectorEconomicoRem').val('');
			$('#descripcionSERem').val('');
		}
	}
});//fin document ready

function exitoTransUsuario(){
	inicializaForma('formaGenerica', 'usuarioID');
	limpiaCombosInicio();
	$('#identiUsuario').show();	 
}

function exitoTransRemitente(){
	limpiaCamposRemitentes();		 
}

function falloTransUsuario(){	
}

function consultaArchivoUsuario(){
	if($('#usuarioID').val()!=null || $('#usuarioID').val()!=''){
		var params = {};
		params['tipoLista'] = 1;
		params['usuarioID'] = $('#usuarioID').val();
		params['tipoDocumento'] = 2;
		$.post("gridUsuarioFileUpload.htm", params, function(data){		
				if(data.length >0) {
					$('#gridArchivosUsuario').html(data);
					$('#gridArchivosUsuario').show();
				}else{
					$('#gridArchivosUsuario').html("");
					$('#gridArchivosUsuario').show();
				}
		});
	}
}

function  eliminaArchivo(folioDocumento){
	var bajaFolioDocumentoCliente = 1;
	var clienteArchivoBean = {
		'usuarioID' : $('#usuarioID').val(),
		'usuarioArchivoID' : folioDocumento
	};
	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');   
	$('#contenedorForma').block({
			message: $('#mensaje'),
		 	css: {border:		'none',
		 			background:	'none'}
	});
	usuarioArchivosServicio.bajaArchivos(bajaFolioDocumentoCliente, clienteArchivoBean, function(mensajeTransaccion) {
		if(mensajeTransaccion!=null){
			mensajeSis(mensajeTransaccion.descripcion);
			$('#contenedorForma').unblock(); 
			consultaArchivoUsuario();
		}else{				
			mensajeSis("Ocurrió un Error al Borrar el Documento.");			
		}
	});
}


function verArchivosUsuario(id, idTipoDoc, idarchivo,recurso) {
	var varClienteVerArchivo = $('#usuarioID').val();
	var varTipoDocVerArchivo = idTipoDoc;
	var varTipoConVerArchivo = 10;
	var parametros = "?usuarioID="+varClienteVerArchivo+"&tipoDocumento="+
		varTipoDocVerArchivo+"&tipoConsulta="+varTipoConVerArchivo+"&recurso="+recurso;

	var pagina="usuariosVerArchivos.htm"+parametros;
	var idrecurso = eval("'#recursoUsrInput"+ id+"'");
	var extensionArchivo=  $(idrecurso).val().substring( $(idrecurso).val().lastIndexOf('.'));
	extensionArchivo = extensionArchivo.toLowerCase();
	if(extensionArchivo==".jpg" || extensionArchivo == ".png" || extensionArchivo == ".jpeg" || extensionArchivo == ".gif"){
		$('#imgCliente').attr("src",pagina); 		
		$('#imagenCte').html(); 
		  $.blockUI({message: $('#imagenCte'),
			   css: { 
           top:  ($(window).height() - 400) /2 + 'px', 
           left: ($(window).width() - 400) /2 + 'px', 
           width: '400px' 
       } });  
		  $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
	}else{
		window.open(pagina,'_blank');
		$('#imagenCte').hide();
	}	
}

function limpiaCombosInicio(){
	inicializaForma('formaGenerica', 'usuarioID');
	$('#sexo').val('');
	$('#nacion').val('');
	$('#tipoDireccionID').val('');
	$('#tipoIdentiID').val('');
	$('#nivelRiesgo').val('');
}

// FUNCIÓN PARA LIMPIAR LOS CAMPOS DE LA SECCIÓN REMITENTES
function limpiaCamposRemitentes(){
	$('#tituloRem').val('');
	$('#tipoPersonaRem').val('');
	$('#nombreCompletoRem').val('');
	$('#fechaNacimientoRem').val('');
	$('#paisNacimientoRem').val('');
	
	$('#estadoNacRem').val('');
	$('#estadoCivilRem').val('');
	$('#sexoRem').val('');
	$('#CURPRem').val('');
	$('#RFCRem').val('');
	
	$('#FEARem').val('');
	$('#paisFEARem').val('');
	$('#ocupacionRem').val('');
	$('#puestoRem').val('');
	$('#sectorGeneralRem').val('');
	
	$('#actividadBancoMXRem').val('');
	$('#actividadINEGIRem').val('');
	$('#sectorEconomicoRem').val('');
	$('#tipoIdentiIDRem').val('');
	$('#numIdentificRem').val('');
	
	$('#fecExIdenRem').val('');
	$('#fecVenIdenRem').val('');
	$('#telefonoCasaRem').val('');
	$('#extTelefonoPartRem').val('');
	$('#telefonoCelularRem').val('');
	
	$('#correoRem').val('');
	$('#domicilioRem').val('');

	$('#descripcionBMXRem').val('');			
	$('#descripcionINEGIRem').val('');					
	$('#descripcionSERem').val('');
	$('#descOcupacionRem').val('');
	$('#descPaisFEARem').val('');
	$('#paisNacRem').val('');
	$('#nombreEstadoRem').val('');
	$('#nacionRem').val('');
	$('#paisResidenciaRem').val('');
	$('#descpaisR').val('');
}

// Función para verificar que si son números lo que se ingresa en el input
function esNumero (valor){
    var valoresAceptados = /^[0-9]+$/;// Solo números
    if (valor.indexOf(".") === -1 ){
        if (valor.match(valoresAceptados)){
           return true;
        }else{
           return false;
        }
    }else{
        //dividir la expresión por el punto en un array
        var particion = valor.split(".");
        //evaluamos la primera parte de la división (parte entera)
        if (particion[0].match(valoresAceptados) || particion[0]== ""){
            if (particion[1].match(valoresAceptados)){
                return true;
            }else {
                return false;
            }
        }else{
            return false;
        }
    }
}