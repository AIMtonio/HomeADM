$(document).ready(function() {
	var parametroBean = consultaParametrosSession();
	//Validacion para mostrarar boton de calcular CURP Y RFC
	permiteCalcularCURPyRFC('generarc','generar',3);
	llenaComboTiposIdenti();
	// Definicion de Constantes y Enums
	var catTipoTransaccionGarante = {
		'agrega' : '1',
		'modifica' : '2',
		'actualiza' : '3'

	};
		

	esTab = true;
		
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$("#numero").focus();

	
	$('#numero').bind('keyup',function(e) { 
		lista('numero', '3', '1', 'nombreCompleto', $('#numero').val(), 'listaGarantes.htm');
	});

	// País de Nacimiento de la Persona Física
	$('#lugarNacimiento').bind('keyup',function(e) { 
		lista('lugarNacimiento', '1', '1', 'nombre', $('#lugarNacimiento').val(),'listaPaises.htm');
	});

	// Entidad Federativa de la Persona Física
	$('#estadoID').bind('keyup',function(e) {
		lista('estadoID', '2', '1', 'nombre',$('#estadoID').val(),'listaEstados.htm');
	});

	// País de Residencia de la Persona Física
	$('#paisResidencia').bind('keyup',function(e) { 
		lista('paisResidencia', '1', '1', 'nombre', $('#paisResidencia').val(),'listaPaises.htm');
	});

	// País de Constitución de la Persona Moral
	$('#paisConstitucionID').bind('keyup',function(e) { 
		lista('paisConstitucionID', '1', '1', 'nombre', $('#paisConstitucionID').val(),'listaPaises.htm');
	});

	// Tipo de Sociedad de la Persona Moral
	$('#tipoSociedad').bind('keyup',function(e) {
		lista('tipoSociedad', '2', '1','descripcion', $('#tipoSociedad').val(),'listaTipoSociedad.htm');
	});

	// Grupo Empresarial de la Persona Moral
	$('#grupoEmpresarial').bind('keyup',function(e) {
		lista('grupoEmpresarial', '3', '1','nombreGrupo', $('#grupoEmpresarial').val(), 'listaEmpresas.htm');
	});

	// Lista para los Paises de la FEA
	$('#paisFEA').bind('keyup',function(e) {
		lista('paisFEA', '1', '1', 'nombre', $('#paisFEA').val(),'listaPaises.htm');
	});

	// Lista los estados para la Dirección del Garante
	$('#estadoIDDir').bind('keyup',function(e){
		lista('estadoIDDir', '2', '1', 'nombre', $('#estadoIDDir').val(), 'listaEstados.htm');
	});
	// Lista los municipios para la Dirección del Cliente
	$('#municipioID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = "nombre";
		
		
		parametrosLista[0] = $('#estadoIDDir').val();
		parametrosLista[1] = $('#municipioID').val();
		
		lista('municipioID', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
	});
	
	// Lista las localidades para la Dirección del Cliente
	$('#localidadID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = 'municipioID';
		camposLista[2] = "nombreLocalidad";
		
		
		parametrosLista[0] = $('#estadoIDDir').val();
		parametrosLista[1] = $('#municipioID').val();
		parametrosLista[2] = $('#localidadID').val();
		
		lista('localidadID', '2', '1', camposLista, parametrosLista,'listaLocalidades.htm');
	});
	
	// Lista las colonias para la Dirección del Cliente
	$('#coloniaID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = 'municipioID';
		camposLista[2] = "asentamiento";		
		
		parametrosLista[0] = $('#estadoIDDir').val();
		parametrosLista[1] = $('#municipioID').val();
		parametrosLista[2] = $('#coloniaID').val();
		
		lista('coloniaID', '2', '1', camposLista, parametrosLista,'listaColonias.htm');
	});
	
	//  Estado Escritura Pública
	$('#estadoIDEsc').bind('keyup',function(e){
		lista('estadoIDEsc', '2', '1', 'nombre', $('#estadoIDEsc').val(), 'listaEstados.htm');
	});

	// Localidad Escritura Pública
	$('#municipioEsc').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = "nombre";
		
		
		parametrosLista[0] = $('#estadoIDEsc').val();
		parametrosLista[1] = $('#municipioEsc').val();
		
		lista('municipioEsc', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
	});

	$('#notaria').bind('keyup',function(e){ 
		//TODO Agregar Libreria de Constantes Tipo Enum
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = "municipioID";
		camposLista[2] = "titular"; 
		
		parametrosLista[0] = $('#estadoIDEsc').val();
		parametrosLista[1] = $('#municipioEsc').val();
		parametrosLista[2] = $('#notaria').val();
		
		if($('#estadoIDEsc').val() != '' && $('#estadoIDEsc').asNumber() > 0 ){
			if($('#municipioEsc').val()!='' && $('#municipioEsc').asNumber()>0){
				lista('notaria', '1', '1', camposLista, parametrosLista, 'listaNotarias.htm');
			}else{
				if($('#notaria').val().length >= 3){
					$('#municipioEsc').focus();
					$('#notaria').val('');
					$('#nomNotario').val('');
					mensajeSis('Especificar Localidad');
				}
			}
		}else{
			if($('#notaria').val().length >= 3){
				$('#estadoIDEsc').focus();
				$('#notaria').val('');
				$('#nomNotario').val('');
				mensajeSis('Especificar Entidad Federativa');
			}

		}		

	});

	$('#estadoIDReg').bind('keyup',function(e){
		lista('estadoIDReg', '2', '1', 'nombre', $('#estadoIDReg').val(), 'listaEstados.htm');
	});
	
	$('#municipioRegPub').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = "nombre";
		
		
		parametrosLista[0] = $('#estadoIDReg').val();
		parametrosLista[1] = $('#municipioRegPub').val();
		
		lista('municipioRegPub', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
	});
	$('#numero').blur(function() {
		if(isNaN($('#numero').val()) ){
			inicializaForma('formaGenerica', 'numero');
		}else   {
			if( $('#numero').val() =='0' ){
				limpiaDatosPersonaMoral();
				limpiaDatosPersonaFisica();
			}	
			validaGarante(this,0);
		}
	});

	// País de Nacimiento
	$('#lugarNacimiento').blur(function() {
		if(esTab){
			consultaPaisNac(this.id);
		}
	});

	// Entidad Federativo
	$('#estadoID').blur(function() {
		if(esTab){
			consultaEstado(this.id);
		}
		
	})

	// País de Residencia
	$('#paisResidencia').blur(function() {
		if(esTab){
			consultaPais(this.id);
		}
	});

	// Primer Nombre
	$('#primerNombre').blur(function() {
		var nombre = $('#primerNombre').val();
		$('#primerNombre').val($.trim(nombre));
		
	});
	
	// Segundo Nombre
	$('#segundoNombre').blur(function() {
		var segnombre = $('#segundoNombre').val();
		$('#segundoNombre').val($.trim(segnombre));
	});
	
	// Tercer Nombre
	$('#tercerNombre').blur(function() {
		var ternombre = $('#tercerNombre').val();
		$('#tercerNombre').val($.trim(ternombre));
	});

	// Apellido Paterno
	$('#apellidoPaterno').blur(function() {
		var ap = $('#apellidoPaterno').val();
		$('#apellidoPaterno').val($.trim(ap));
	});
	
	// Apellido Materno
	$('#apellidoMaterno').blur(function() {
		var am = $('#apellidoMaterno').val();
		$('#apellidoMaterno').val($.trim(am));
	});

	// CURP del Garante
	$('#curp').blur(function() {
		if($('#primerNombre').val() != '' && $('#fechaNacimiento').val() != '' && $('#nacionalidad').val() != '' && $('#sexo').val() != '' && esTab){
			validaCURP('curp');
			validaCURPv1($('#curp').val());
		}				
	});

	// RFC del Garante
	$('#rfc').blur(function() {
		if($('#tipoPersona1').is(':checked') && esTab && $('#rfc').val()!= ''){  
			validaRFC('rfc');
			validaRFCv1($('#rfc').val());
		}else{
			if($('#tipoPersona3').is(':checked') && esTab && $('#rfc').val()!= ''){  
				validaRFC('rfc');
			}
		}
	});

	// Telefono Particular del Garante
	$("#telefono").blur(function(){
		if($("#telefono").val() == ''){
			$('#extTelefonoPart').val('');
		}		
	});	

	$('#tipoIdentiID').change(function() {
		var numIden = $('#tipoIdentiID option:selected').val();
		
		if(numIden != ''){
			consultaTipoIdent(numIden);

		}
		else{
			mensajeSis("No Existe la Identificación del Cliente");
			deshabilitaBoton('agrega', 'submit');		
			deshabilitaBoton('modifica', 'submit');
			deshabilitaBoton('elimina', 'submit');
			$('#numIdentific').val('');
			$('#fecExIden').val('');
			$('#fecVenIden').val('');
		}
	});

	// Extensión del Telefono Particular del Garante
	$("#extTelefonoPart").blur(function(){
		if(esTab){
			if(this.value != ''){
				if($("#telefono").val() == ''){
					this.value = '';
					mensajeSis("El Número de Teléfono está Vacío");
					$("#telefono").focus();
				}
			}	
		}			
	});		

	// Razón Social de la Persona Moral
	$('#razonSocial').blur(function() {
		var rz = $('#razonSocial').val();
		$('#razonSocial').val($.trim(rz));
	});

	// RFC de la Persona Moral
	$('#rfcPM').blur(function() {
		if($('#tipoPersona2').is(':checked')){  
			validaRFC('rfcPM');
		}
	});

	// Nacionalidad de la Persona Moral
	$('#nacionalidadPM').change(function() {
		validaNacionalidadCte();
	});

	// País de Constitución de la Persona Moral
	$('#paisConstitucionID').blur(function() {
		if(esTab){
			consultaPaisNac(this.id);
		}
	});

	// Teléfono de la Persona Moral
	$("#telefonoPM").blur(function(){
		if($("#telefonoPM").val() == ''){
			$('#extTelefonoPartPM').val('');
		}		
	});	
	
	// Extensión del Teléfono de la Persona Moral
	$("#extTelefonoPartPM").blur(function(){
		if(esTab){
			if(this.value != ''){
				if($("#telefonoPM").val() == ''){
					this.value = '';
					mensajeSis("El Número de Teléfono está Vacío.");
					$("#telefonoPM").focus();
				}
			}
		}				
	});	

	// Tipo de Sociedad de la Persona Moral
	$('#tipoSociedad').blur(function() {
		if(esTab){
			consultaSociedad(this.id);
		}
	});

	// Grupo Empresarial de la Persona Moral.
	$('#grupoEmpresarial').blur(function() {
		if(esTab){
			consultaGEmpres(this.id);
		}
	});

	$('#paisFEA').blur(function() {
		if(esTab){
			consultaPaisFea(this.id);
		}
	});

	$('#estadoIDDir').blur(function() {
		consultaEstadoDir(this.id);
	  });
	  
	$('#municipioID').blur(function() {
		consultaMunicipio(this.id);
	});

	$('#localidadID').blur(function() {
		consultaLocalidad(this.id);
	});

	$('#coloniaID').blur(function() {
		consultaColonia(this.id);
	});

	$('#esc_Tipo').blur(function() {	 
		var tipActa = $('#esc_Tipo').val();
		if(tipActa == 'P'){
		$('#apoderados').show(500);
		}else{
		$('#apoderados').hide(500);
		$('#nomApoderado').val("");
		$('#RFC_Apoderado').val("");
		}
	});
	$('#estadoIDEsc').blur(function() {
		consultaEstadoEsc(this.id);
  	});
 	$('#municipioEsc').blur(function() {
		consultaMunicipioEsc(this.id);
	}); 
	$('#estadoIDReg').blur(function() {
		consultaEstadoReg(this.id);
	});
	$('#municipioRegPub').blur(function() {
		consultaMunicipioReg(this.id);
	});

	$('#notaria').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if($('#notaria').val() 	!= 	'' &&	$('#notaria').val() > 0	&&	!isNaN($('#notaria').val())){
			if($('#estadoIDEsc').val()!=''  ){
				if($('#municipioEsc').val() !=''){
					consultaNotaria(this.id);
				}else{
					$('#nomNotario').val('');
					$('#notaria').val('');
					mensajeSis("Elija un Municipio antes de buscar Notaría");
				}
			}else{
				$('#nomNotario').val('');
				$('#notaria').val('');
				mensajeSis("Elija una Entidad Federativa  antes de buscar Notaría");
			}
		}else{
			$('#nomNotario').val('');
			$('#notaria').val('');
		}
  
	});
	
	// Fecha de Nacimiento del Garante
	$('#fechaNacimiento').change(function() {
		var Xfecha= $('#fechaNacimiento').val(); 
		var Yfecha=  parametroBean.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaNacimiento').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha Capturada es Mayor a la de Hoy")	;
				$('#fechaNacimiento').val(parametroBean.fechaSucursal);
				$('#fechaNacimiento').focus();
			
			}else{
				$('#nacionalidad').focus();	
			}
		}else{
			$('#fechaNacimiento').val(parametroBean.fechaSucursal);
			
		}
		$('#CURP').val('');

	});

	// Fecha de Constitución del RFC del Garante
	$('#fechaConstitucion').change(function() {
		var Xfecha= $('#fechaConstitucion').val(); 
		var Yfecha=  parametroBean.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaConstitucion').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha Capturada es Mayor a la de Hoy")	;
				$('#fechaConstitucion').val(parametroBean.fechaSucursal);
				$('#fechaConstitucion').focus();
			}else{
				$('#estadoCivil').focus();	
			}
		}else{
			$('#fechaConstitucion').val(parametroBean.fechaSucursal);
		}

	});

	// Fecha de constitucion de la Persona Moral
	$('#fechaConstitucionPM').change(function() {
		var Xfecha= $('#fechaConstitucionPM').val(); 
		var Yfecha=  parametroBean.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaConstitucionPM').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La fecha capturada es mayor a la de hoy")	;
				$('#fechaConstitucionPM').val(parametroBean.fechaSucursal);
			}
		}else{
			$('#fechaConstitucionPM').val(parametroBean.fechaSucursal);
		}

	});

	// Fecah de Expedición de la Identificación del Garante
	$('#fecExIden').change(function() {
		var Zfecha=  parametroBean.fechaSucursal;
		
		var Xfecha= $('#fecExIden').val();
		var Yfecha= $('#fecVenIden').val();
		if(Yfecha!=''){
			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha de Expedición es Mayor a la Fecha de Vencimiento.")	;
				$('#fecExIden').val('');
				$('#fecExIden').focus();
			}
		}else{
			if ( mayor(Xfecha, Zfecha) )
			{
				mensajeSis("La Fecha Capturada es Mayor a la de Hoy.")	;
				$('#fecExIden').val('');
				$('#fecExIden').focus();
			
			}
		}
	});

	// Fecha de Vencimiento de la Identificación del Cliente
	$('#fecVenIden').change(function() {
		var Xfecha= $('#fecExIden').val();
		var Yfecha= $('#fecVenIden').val();
		if(Yfecha!=''){
			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha de Expedición es Mayor a la Fecha de Vencimiento.")	;
				$('#fecVenIden').val('');
				$('#fecVenIden').focus();
			}
		}
	});

	//Fecha de la Escritura Publica
	$('#fechaEsc').change(function() {
		var Xfecha= $('#fechaEsc').val(); 
		var Yfecha=  parametroBean.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaEsc').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha capturada es mayor a la del Sistema")	;
				$('#fechaEsc').focus();	
				$('#fechaEsc').val(parametroBean.fechaSucursal);
			}else{
				$('#fechaEsc').focus();	
			}
		}else{
			$('#fechaEsc').val(parametroBean.fechaSucursal);
		}

	});
	
	// Fecha del Registro Publico
	$('#fechaRegPub').change(function() {
		var Xfecha= $('#fechaRegPub').val(); 
		var Yfecha=  parametroBean.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaRegPub').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La Fecha capturada es mayor a la del Sistema")	;
				$('#fechaRegPub').val(parametroBean.fechaSucursal);
				$('#fechaRegPub').focus();	
			}else{
				$('#fechaRegPub').focus();	
			}
		}else{
			$('#fechaRegPub').val(parametroBean.fechaSucursal);
		}

	});

		// Evento click para el botón Calcular del botón CURP
	$('#generarc').click(function() {
		if ($('#fechaNacimiento').val()!=''){
			formaCURP();
			$('#curp').focus();
			$('#curp').select();
		}else{
			mensajeSis('Se necesita la Fecha de Nacimiento para esta Opción');
		}
	});

	// Evento click para el botón Calcular del botón RFC
	$('#generar').click(function() {
		if($('#primerNombre').val()!=''){
		if($('#apellidoPaterno').val()!=''|| $('#apellidoMaterno').val()!=''){
	
		
		if ($('#fechaNacimiento').val()!=''){
			//Estableciendo el bloqueo de pantalla mientras se genera el RFC
			$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');   
			$('#contenedorForma').block({
				message: $('#mensaje'),
				css: {border:		'none',
					background:	'none'}
			});
			formaRFC();
			$('#rfc').focus();
			$('#rfc').select();
		}else{
			mensajeSis('Se necesita la Fecha de Nacimiento para esta Opción');
		}
	}else{
		mensajeSis("Los campos Apellidos Paterno y Materno están vacios debe ingresar uno de ellos");
			$('#apellidoPaterno').focus();
	}
	}else{
		mensajeSis("El Nombre es requerido para esta operación");
		$('#primerNombre').focus();
	}
	
	});

	// Evento click para el check Persona Fisica
	$('#tipoPersona1').click(function() {

		$('#tipoPersona1').attr("checked", true);

		permiteCalcularCURPyRFC('','generar',2);
		$('#personaMoral').hide(500);
		$('#datosPersonaFisica').show(500);
		$('#registroHaciendaNo').val('N').attr('checked',true);

		limpiaDatosPersonaMoral();			

	});

	// Evento click para el check Persona Moral
	$('#tipoPersona2').click(function() {
		$('#tipoPersona2').attr("checked", true);
		$('#generar').hide(500);
		$('#datosPersonaFisica').hide(500);
		$('#personaMoral').show(500);
		$('#registroHaciendaSi').val('S').attr('checked',true);
		
		limpiaDatosPersonaFisica();		
	});
	
	$('#tipoPersona3').click(function() {

		$('#tipoPersona3').attr("checked", true);

		permiteCalcularCURPyRFC('','generar',2);
		$('#datosPersonaFisica').show(500);
		$('#personaMoral').hide(500);
		$('#registroHaciendaSi').val('S').attr('checked',true);
		limpiaDatosPersonaMoral();


	});
	
	$('#agrega').click(function() {
		limpiaChecks();
		$('#tipoTransaccion').val(catTipoTransaccionGarante.agrega);
	});

	$('#modifica').click(function() {
		limpiaChecks();
		$('#tipoTransaccion').val(catTipoTransaccionGarante.modifica);
	});


	// ------------ Metodos y Manejo de Eventos
	// -----------------------------------------
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	agregaFormatoControles('formaGenerica');

	$("#telefonoCelular").setMask('phone-us');
	$("#telefono").setMask('phone-us');
	$("#telefonoPM").setMask('phone-us');


	$.validator.setDefaults({
		submitHandler : function(event) {

			grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','numero','exitoTransCliente','falloTransCliente');
			
		}
	});




	// ------------ Validaciones de la Forma
	$('#formaGenerica').validate({
		rules : {
			numero : {
				required : false
			},
			titulo : {// Requerido si el tipo de persona es Moral
				required :  function() { if($('#tipoPersona2').is(':checked')) return false; else return true}		
			},					
			primerNombre : {
				required : function() { if($('#tipoPersona2').is(':checked')) return false; else return true},
				minlength : 2
			},
			fechaNacimiento : {required : function() {return $('#tipoPersona1').is(':checked');},
				date: true
			},		
			nacion : {
				required :  function() { if($('#tipoPersona2').is(':checked')) return false; else return true}
			},			
			lugarNacimiento : {
				required : function() {
					return $('#tipoPersona1').is(':checked');
				}	
			},
			estadoID : {
				required : function() { if($('#tipoPersona2').is(':checked')) return false; else return true},
			},			
			paisResidencia : {
				required : function() {
					if($('#tipoPersona2').is(':checked')) return false; else return true
				}
			},
			sexo : {
				required :  function() { if($('#tipoPersona2').is(':checked')) return false; else return true}
			},
			CURP : {
				required : function() { if($('#tipoPersona2').is(':checked')) return false; else return true},
				maxlength : 18
			},
			registroHacienda: {
				required : true,
			},
			RFC : {
				required : function() {
					if($('#tipoPersona2').is(':checked'))
						return false;
					else return $('#tipoPersona1').is(':checked') || $('#registroHaciendaSi').is(':checked')
				},
				maxlength	: 13,
			},
			fechaConstitucion : { required : function(){
				if(($('#tipoPersona3').is(':checked'))&&($('#nacionalidad').val().trim()=='N')){
					return true;
				} else {
					return false;
				}
				},
				date: true				
			},			
			estadoCivil : {
				required :  function() { if($('#tipoPersona2').is(':checked')) return false; else return true}
			},
			telefonoCelular : {
				required : function() { if($('#tipoPersona2').is(':checked')) return false; else return true}
			},
			correo : {
				required : false,
				email : true
			},
			extTelefonoPart: {
				number: true,
			},
			extTelefonoTrab: {
				number:true,
			},
			razonSocial : {
				required : function() {return $('#tipoPersona2').is(':checked'); },
				minlength : 2
			},			
			RFCpm : {
				required : function() {return $('#tipoPersona2').is(':checked');},
				minlength : function() { if($('#tipoPersona2').is(':checked')) return 12; else return 0}
			},
			paisConstitucionID : {
				required : function() {return $('#tipoPersona2').is(':checked');}	
			},				
			correoPM : {
				required : false,
				email : true
			},			
			correoAlterPM : {
				required : false,
				email : true
			},
			extTelefonoPartPM: {
				number:true,
			},			
			tipoSociedadID : {
				required : function() {return $('#tipoPersona2').is(':checked');}	
			},	
			fechaRegistroPM : {
				required : function() {return $('#tipoPersona2').is(':checked');},
				date: true
			},					
			nacionalidadPM : {
				required :  function() { if($('#tipoPersona2').is(':checked')) return true; else return false}
			},
			tipoIdentiID: {
				required :  function() { if($('#tipoPersona2').is(':checked')) return false; else return true},
				minlength: 1
			},	

			numIdentific:{
				required :  function() { if($('#tipoPersona2').is(':checked')) return false; else return true},
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
				required : function() { if($('#tipoPersona2').is(':checked')) return false; else return true},
				date : true
			},		
			fecVenIden: {
				date : true
			},
			estadoIDDir: {
				required : function() { if($('#tipoPersona2').is(':checked')) return false; else return true}
			},
			municipioID: {
				required : function() { if($('#tipoPersona2').is(':checked')) return false; else return true}
			},
			localidadID: {
				required : function() { if($('#tipoPersona2').is(':checked')) return false; else return true}
			},
			coloniaID: {
				required : function() { if($('#tipoPersona2').is(':checked')) return false; else return true}
			},
			calle: {
				required : function() { if($('#tipoPersona2').is(':checked')) return false; else return true}
			},
			numeroCasa: {
				required : function() { if($('#tipoPersona2').is(':checked')) return false; else return true}
			},
			CP: {
				required : function() { if($('#tipoPersona2').is(':checked')) return false; else return true}
			},
			esc_Tipo: {  
				required : function() {return $('#tipoPersona2').is(':checked');},

			},
			escrituraPub: {  
				required : function() {return $('#tipoPersona2').is(':checked');},
				minlength: 3,
				maxlength: 50
			},		
			libroEscritura: {
				
				maxlength: 50
			},
			volumenEsc:{
				
				maxlength: 10
			},
			
			fechaEsc: {  
				required : function() {return $('#tipoPersona2').is(':checked');},
				minlength: 5
			},	
			estadoIDEsc: {
				required : function() {return $('#tipoPersona2').is(':checked');},
				minlength: 1,
				number:true
			},	
			municipioEsc: { 
				required : function() {return $('#tipoPersona2').is(':checked');},
				minlength: 1,
				number:true
			},	
			notaria: {
				required : function() {return $('#tipoPersona2').is(':checked');},
			minlength: 1			
			},	
			
			registroPub: {
				required : function() {return $('#tipoPersona2').is(':checked');},
			maxlength: 10			
			},
			folioRegPub: {
				required : function() {return $('#tipoPersona2').is(':checked');},
			maxlength: 10
			},
			volumenRegPub: {
			maxlength: 10
			},
			libroRegPub: {
			
			maxlength: 10
			}, 
			auxiliarRegPub: {
			
			maxlength: 20
			},
			fechaRegPub: {
				required : function() {return $('#tipoPersona2').is(':checked');},			
			},
			estadoIDReg: {
				required : function() {return $('#tipoPersona2').is(':checked');},
			number:true
			},
			municipioRegPub: {
				required : function() {return $('#tipoPersona2').is(':checked');},
			number:true
			},
			fechaConstitucionPM: {
				required : function() {return $('#tipoPersona2').is(':checked');}
			}		
		},
	
		messages : {
            
			titulo : {
				required : 'Especifique Titulo'
            },		
			primerNombre : {
				required : 'Especifique nombre',
				minlength : 'Al menos dos Caracteres'
			},
			fechaNacimiento : {
				required : 'Especifique Fecha de Nacimiento',
				date : 'Fecha Incorrecta'
			},
		    nacionalidad : {
				required :  'Especifique la Nacionalidad.'
            },
            lugarNacimiento : {
				required : 'Especifique Lugar de Nacimiento'
            },
            estadoID : {
				required : "Especifique Entidad Federativa"
            },
            paisResidencia : {
				required: 'Especifique País de Residencia'
            },
            sexo : {
				required :  'Especifique el Género.'
            },
            CURP : {
				required : 'Especifique CURP',
				maxlength : 'Máximo 18 caracteres'
            },
            registroHacienda: {
				required: 'Especifique si está dado de Alta en Hacienda'
            },            
			RFC	: {
				required	: 'Especifique RFC.',
				maxlength	: "Máximo 13 caracteres."
            },
            fechaConstitucion : {
				required : 'Especifique Fecha de Constitución',
				date : 'Fecha Incorrecta'
            },
            estadoCivil : {
				required :  'Especifique el Estado Civil.'
			},
			telefonoCelular : {
				required :  'Especifique el Teléfono Celular.'
			},	
			correo : {
				required : 'Especifique un Correo Electrónico',
				email : 'Dirección Inválida'
			},
            extTelefonoPart:{
				number:'Sólo Números (Campo opcional)'
			},
			extTelefonoTrab:{
				number:'Sólo Números (Campo opcional)'
			},
			razonSocial : {
				required : 'Especifique Razón Social',
				minlength : 'Al menos dos Caracteres'
			},
            RFCpm :{
				required : 'Especifique RFC',
				minlength : 'Minimo 12 carácteres'
			
            },
            paisConstitucionID : {
				required : 'Especifique País de Constitución.'
            },
            correoPM : {
				required : 'Especifique Correo.',
				email : 'Dirección Inválida.'
            },
            correoAlterPM : {
				required : 'Especifique Correo Alternativo.',
				email : 'Dirección Inválida.'
			},
			extTelefonoPartPM:{
				number:'Sólo Números(Campo opcional).'
			},			
			tipoSociedadID : {
				required : 'Especifique Tipo de Sociedad.'
			},
	
			fechaRegistroPM : {
				required : 'Especifique Fecha de Registro.',
				date : 'Fecha Incorrecta.'
            },
            nacionalidadPM : {
				required :  'Especifique la Nacionalidad.'
			},
			tipoIdentiID: {
				required: 'Seleccione un tipo de identificación', 
				minlength: 'Seleccione un tipo de identificación'
			},
			numIdentific:{
				  required: 'Especifique Folio de Identificación',
				  minlength:jQuery.format("Se Requieren Mínimo {0} Caracteres"),
				  maxlength:jQuery.format("Se Requieren Máximo {0} Caracteres"),
				} , 

			fecExIden: {
				required : 'Especifique la Fecha de Expedición',
				date : 'Fecha Incorrecta'
			},

			fecVenIden: {
				date : 'Fecha Incorrecta'
			},
			estadoIDDir: {
				required : 'Especifique Entidad Federativa'
			},
			municipioID: {
				required : 'Especifique Municipio'
			},
			localidadID: {
				required :	'Especifique Localidad'
			},
			coloniaID: {
				required : 'Especifique Colonia'
			},
			calle: {
				required : 'Especifique la Calle'
			},
			numeroCasa: {
				required : 'Especifique Número Interior'
			},
			CP: {
				required : 'Especifique Código Postal'
			},
			esc_Tipo: {
				required: 'Especificar tipo de Escritura '
			},
			escrituraPub: {
				required: 'Especificar Escritura', 
				minlength: 'Al menos 5 Caracteres',
			    maxlength: 'Máximo 50 Caracteres'
			},
			
			libroEscritura: {
				required: 'Especificar Libro', 
			    maxlength: 'Máximo 50 Caracteres'
			},
			volumenEsc: {
				required: 'Especificar Volumen', 
			    maxlength: 'Máximo 10 Caracteres'
			},
			
			fechaEsc: {
				required: 'Especificar Fecha', 
				minlength: 'Al menos 8 Caracteres'
			},
			estadoIDEsc: {
				required: 'Especificar Estado', 
				minlength: 'Al menos 2 Caracteres',
				number:'Sólo Números'
			},
			municipioEsc: {
				required: 'Especificar Municipio.', 
				minlength: 'Al menos 2 Caracteres',
				number:'Sólo Números'
			},
			notaria: {
				required: 'Especificar Notaría.', 
				minlength: 'Al menos 1 Caracteres'
				
			},
			
			registroPub: {
			required: 'Especificar Registro Publico.',
			maxlength: 'Máximo 10 Caracteres'
				
			},
			folioRegPub: {
			required: 'Especificar Folio.',
			maxlength: 'Máximo 10 Caracteres'
			
			},
			volumenRegPub: {
				required: 'Especificar Volumen', 
			    maxlength: 'Máximo 10 Caracteres'
			},
			libroRegPub: {
				required: 'Especificar Volumen', 
			    maxlength: 'Máximo 10 Caracteres'
				}, 
				auxiliarRegPub:{
				required: 'Especificar Volumen', 
				maxlength: 'Máximo 20 Caracteres'
				},
			fechaRegPub: {
			required: 'Especificar Fecha.'
			
			},
			estadoIDReg: {
			required: 'Especificar Entidad.',
			number:'Sólo Números'
			
			},
			municipioRegPub: {
			required: 'Especificar Municipio.',
			number:'Sólo Números'
			
			},
			fechaConstitucionPM: {
				required: 'Especificar Fecha de Registro.'
				
				}

		
		}
	});

	

	




});//	FIN VALIDACIONES


// Consulta a un Garante específico
function validaGarante(control) {
	var numCliente = $('#numero').val();
	setTimeout("$('#cajaLista').hide();", 200);
	if (numCliente != '' && !isNaN(numCliente) && esTab) {
			if (numCliente == '0') {
				$('#tipoPersona1').attr("checked", true);
				habilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');
				
			} else {
				$('#tipoPersona1').focus();
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				garantesServicio.consulta(1,numCliente,function(garante) {
					if (garante != null) {
								esTab = true;
								
								$('#tipoPersona').val(garante.tipoPersona);
								$('#titulo').val(garante.titulo);
								$('#primerNombre').val(garante.primerNombre);
								$('#segundoNombre').val(garante.segundoNombre);
								$('#tercerNombre').val(garante.tercerNombre);
								$('#apellidoPaterno').val(garante.apellidoPaterno);
								$('#apellidoMaterno').val(garante.apellidoMaterno);
								$('#lugarNacimiento').val(garante.lugarNacimiento);
								$('#estadoID').val(garante.estadoID);
								$('#paisResidencia').val(garante.paisResidencia);
								$('#sexo').val(garante.sexo);
								$('#curp').val(garante.curp);
								$('#rfc').val(garante.rfc);
								$('#fechaConstitucion').val(garante.fechaConstitucion);
								$('#estadoCivil').val(garante.estadoCivil);
								$('#telefonoCelular').val(garante.telefonoCelular);
								$('#telefono').val(garante.telefono);
								$('#extTelefonoPart').val(garante.extTelefonoPart);
								$('#correo').val(garante.correo);
								$('#fax').val(garante.fax);
								$('#observaciones').val(garante.observaciones);
								$('#tipoIdentiID').val(garante.tipoIdentiID);
		
								
								$('#fecExIden').val(garante.fecExIden);
								$('#fecVenIden').val(garante.fecVenIden);
													

								if (garante.fechaNacimiento == '1900-01-01'){
									$('#fechaNacimiento').val('');
								} else {
									$('#fechaNacimiento').val(garante.fechaNacimiento);
								}
								if (garante.tipoPersona == 'F'){
									$('#tipoPersona1').attr("checked",true);
									$('#tipoPersona2').attr("checked",false);
									$('#tipoPersona3').attr("checked",false);
								}
								if (garante.tipoPersona == 'A') {
									limpiaDatosPersonaMoral();
									$('#tipoPersona3').attr("checked", true);
									$('#tipoPersona2').attr("checked",false);
									$('#tipoPersona1').attr("checked",false);
									$('#datosPersonaFisica').show(500);
									$('#personaMoral').hide(500);
									
									$('#nacionalidad').val(garante.nacionalidad);
								}
								if (garante.tipoPersona == 'F' || garante.tipoPersona == 'A') {
									limpiaDatosPersonaMoral();
									$('#personaMoral').hide(500);
									
									if(garante.registroHacienda=='S'){
										$('#registroHaciendaSi').attr("checked",true);
										$('#registroHaciendaNo').attr("checked",false);							
									}else if(garante.registroHacienda=='N'){
										$('#registroHaciendaNo').attr("checked",true);
										$('#registroHaciendaSi').attr("checked",false);
									}

									permiteCalcularCURPyRFC('','generar',2);

									if(garante.tipoIdentiID != ''){
										consultaTipoIdent(garante.tipoIdentiID);	
									}	
									$('#numIdentific').val(garante.numIdentific);
									$('#estadoIDDir').val(garante.estadoIDDir);
									consultaEstadoDir('estadoIDDir');
									$('#municipioID').val(garante.municipioID);
									consultaMunicipio('municipioID');
									$('#localidadID').val(garante.localidadID);
									consultaLocalidad('localidadID');
									$('#coloniaID').val(garante.coloniaID);
									consultaColonia('coloniaID');
									$('#calle').val(garante.calle);
									$('#numeroCasa').val(garante.numeroCasa);
									$('#numInterior').val(garante.numInterior);
									$('#CP').val(garante.CP);
									$('#lote').val(garante.lote);
									$('#manzana').val(garante.manzana);		

									consultaPaisNac('lugarNacimiento');
									consultaPais('paisResidencia');
									consultaEstado('estadoID');

	
									$('#datosPersonaFisica').show(500);
									$('#nacionalidad').val(garante.nacionalidad);
								} else {								
									if (garante.tipoPersona == 'M'){ 
										limpiaDatosPersonaFisica();
										$('#tipoPersona2').attr("checked", true);
										$('#tipoPersona1').attr("checked",false);
										$('#tipoPersona3').attr("checked",false);
										$('#generar').hide(500);
										
										$('#razonSocial').val(garante.razonSocial);
										$('#rfcPM').val(garante.rfcPM);
										$('#paisConstitucionID').val(garante.paisConstitucionID);
										$('#correoAlternativo').val(garante.correoAlternativo);
										if(garante.tipoSociedad == 0){
											$('#tipoSociedad').val("");	
										}
										else{
											$('#tipoSociedad').val(garante.tipoSociedad);
											consultaSociedad('tipoSociedad');
										}						

										$('#esc_Tipo').val(garante.esc_Tipo);
										$('#escrituraPub').val(garante.escrituraPub);
										$('#libroEscritura').val(garante.libroEscritura);
										$('#volumenEsc').val(garante.volumenEsc);
										$('#fechaEsc').val(garante.fechaEsc);
										$('#estadoIDEsc').val(garante.estadoIDEsc);
										consultaEstadoEsc('estadoIDEsc');
										$('#municipioEsc').val(garante.municipioEsc);
										consultaMunicipioEsc('municipioEsc');
										$('#notaria').val(garante.notaria);
										consultaNotaria('notaria');
										$('#nomApoderado').val(garante.nomApoderado);
										$('#RFC_Apoderado').val(garante.RFC_Apoderado);
										$('#registroPub').val(garante.registroPub);
										$('#folioRegPub').val(garante.folioRegPub);
										$('#volumenRegPub').val(garante.volumenRegPub);
										$('#libroRegPub').val(garante.libroRegPub);
										$('#auxiliarRegPub').val(garante.auxiliarRegPub);
										$('#fechaRegPub').val(garante.fechaRegPub);
										$('#estadoIDReg').val(garante.estadoIDReg);
										consultaEstadoReg('estadoIDReg');
										$('#municipioRegPub').val(garante.municipioRegPub);
										consultaMunicipioReg('municipioRegPub');
										
										if(garante.grupoEmpresarial == 0 ){
											$('#grupoEmpresarial').val("");	
										}
										else{
											$('#grupoEmpresarial').val(garante.grupoEmpresarial);
											consultaGEmpres('grupoEmpresarial');
										}
										
										$('#datosPersonaFisica').hide(500);
										$('#personaMoral').show(500);
										$('#nacionalidadPM').val(garante.nacionalidad);
										consultaPaisNac('paisConstitucionID');
										$('#correoPM').val(garante.correo);
										$('#telefonoPM').val(garante.telefono);
										$('#extTelefonoPartPM').val(garante.extTelefonoPart);
										$('#fechaConstitucionPM').val(garante.fechaConstitucion);
										varSeleccionaMoral = 'S';
										$('#fea').val(garante.fea);
										
										if(garante.paisFEA > 0){
											$('#paisFEA').val(garante.paisFEA);
											consultaPaisFea('paisFEA');
										}else{
											$('#paisFEA').val('');
										}
										$('#telefonoPM').setMask('phone-us');
									}
								}

								deshabilitaBoton('agrega','submit');
								habilitaBoton('modifica','submit');


								$("#telefonoCelular").setMask('phone-us');
								$("#telefonoCasa").setMask('phone-us');
								$("#telTrabajo").setMask('phone-us');

						
					} else {
						limpiaForm($('#formaGenerica'));
						mensajeSis("No Existe el Garante");
						deshabilitaBoton('modifica','submit');
						deshabilitaBoton('agrega','submit');
						$('#numero').focus();
						$('#numero').select();
					}
				});
			}			
		}
}

// Consulta el País de Nacimiento (Persona Física)
// Consulta el País de Constitución (Persona Moral)
function consultaPaisNac(idControl) {
	var jqPais = eval("'#" + idControl + "'");
	var numPais = $(jqPais).val();
	var conPais = 2;

	setTimeout("$('#cajaLista').hide();", 200);
	if (numPais != '' && !isNaN(numPais) && esTab) {
		paisesServicio.consultaPaises(conPais, numPais,	function(pais) {
			if (pais != null) {
				if($('#tipoPersona2').is(':checked')){
					$('#descPaisConst').val(pais.nombre);									
				}else{
					$('#estadoID').attr('readonly',false);
					$('#paisNac').val(pais.nombre);
					if (pais.paisID != 700) {
						$('#estadoID').val(0);
						$('#estadoID').attr('readonly',true);
					}
				}
				validaNacionalidadCte();
			} else {
				mensajeSis("No Existe el País.");
				$(jqPais).focus();
				$(jqPais).val("");
				if($('#tipoPersona2').is(':checked')){
					$('#descPaisConst').val("");
				}else{
					$('#paisNac').val("");
				}
			}
		});
	}
}

// Consulta el Pais de Constitución del RFC del Garante
function consultaPais(idControl) {
	var jqPais = eval("'#" + idControl + "'");
	var numPais = $(jqPais).val();
	var conPais = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numPais != '' && !isNaN(numPais) && esTab) {
		paisesServicio.consultaPaises(conPais, numPais, function(pais) {
			if (pais != null) {
				$('#paisR').val(pais.nombre);
			} else {
				mensajeSis("No Existe el País");
				$(jqPais).val('');
				$(jqPais).focus();
			}
		});
	}else{
		if(esTab){
			mensajeSis("No Existe el País");
			$(jqPais).val('');
			$(jqPais).focus();
		}
	}
}

// Función que valida la Nacionalidad del Garante
function validaNacionalidadCte(){
	if($('#tipoPersona2').is(':checked')){
		var nacionalidad = $('#nacionalidadPM').val();
		var pais= $('#paisConstitucionID').val();					
	}else{
		var nacionalidad = $('#nacionalidad').val();
		var pais= $('#lugarNacimiento').val();
	}
	var mexico='700';
	var nacdadMex='N';
	var nacdadExtr='E';

	if(nacionalidad==nacdadMex){
		if(pais!=mexico && pais!=''){
			mensajeSis("Por la Nacionalidad de la Persona el País debe ser México.");
			if($('#tipoPersona2').is(':checked')){
				$('#paisConstitucionID').focus();
				$('#paisConstitucionID').val('');
				$('#descPaisConst').val('');						
			}else{
			$('#lugarNacimiento').focus();
			$('#lugarNacimiento').val('');
			$('#paisNac').val('');
		}
	}
	}
	if(nacionalidad==nacdadExtr){
		if(pais==mexico){
			mensajeSis("Por la Nacionalidad de la Persona el País No debe ser México.");
			if($('#tipoPersona2').is(':checked')){
				$('#paisConstitucionID').val('');
				$('#paisConstitucionID').focus();
				$('#descPaisConst').val('');
			}else{
			$('#lugarNacimiento').val('');
			$('#lugarNacimiento').focus();
			$('#paisNac').val('');
			}
			

		}
	}
}

// Función que consulta la Entidad Federativa
function consultaEstado(idControl) {
	var jqEstado = eval("'#" + idControl + "'");
	var numEstado = $(jqEstado).val();
	var tipConForanea = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numEstado != '' && !isNaN(numEstado) && esTab) {
		estadosServicio.consulta(tipConForanea, numEstado, function(estado) {
			if (estado != null) {
				var p = $('#lugarNacimiento').val();
				if (p == 700 && estado.estadoID == 0 && esTab) {
					mensajeSis("No Existe el Estado");
					$('#estadoID').focus();
				}
				$('#nombreEstado').val(estado.nombre);
			} else {
				mensajeSis("No Existe el Estado");
				$(jqEstado).val('');
				$(jqEstado).focus();
			}
		});
	}else{
		if(esTab){
			mensajeSis("No Existe el Estado");
			$(jqEstado).val('');
			$(jqEstado).focus();
		}
	}
}

// Función que consulta el tipo de Sociedad.
function consultaSociedad(idControl) {
	var jqSociedad = eval("'#" + idControl + "'");
	var numSociedad = $(jqSociedad).val();

	setTimeout("$('#cajaLista').hide();", 200);
	var SociedadBeanCon = {
		'tipoSociedadID' : numSociedad
	};
	if (numSociedad != '' && !isNaN(numSociedad) && esTab) {
		tipoSociedadServicio.consulta(2, SociedadBeanCon,function(sociedad) {
			if (sociedad != null) {
				$('#descripSociedad').val(sociedad.descripcion);
			} else {
				var tp = $('#tipoPersona1').val();
				if (tp == 'M') {
					mensajeSis("No Existe el Tipo de Sociedad");
					$('#tipoSociedad').focus();
					$('#tipoSociedad').val("");
					$('#descripSociedad').val("");
				}
			}
		});
	}
}

// Función que consulta el Grupo Empresarial.
function consultaGEmpres(idControl) {
	var jqGempresa = eval("'#" + idControl + "'");
	var numGempresa = $(jqGempresa).val();
	var conGempresa = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numGempresa != '' && !isNaN(numGempresa) && esTab && numGempresa > 0) {
		gruposEmpServicio.consulta(conGempresa,
				numGempresa, function(empresa) {
					if (empresa != null) {
						$('#NombreGrupo').val(empresa.nombreGrupo);
					} else {
						if($('#grupoEmpresarial').val() > '0'){
						mensajeSis("No Existe el Grupo");
						$('#grupoEmpresarial').focus();
						$('#grupoEmpresarial').select();
						$('#NombreGrupo ').val('');
						}
					}
				});
	}else{
		$('#NombreGrupo').val('');
		$('#grupoEmpresarial').val('0');
	}
}



// Función que consulta el Pais de la FEA
function consultaPaisFea(idControl) {
	var jqPais = eval("'#" + idControl + "'");
	var numPais = $(jqPais).val();
	var conPais = 2;

	setTimeout("$('#cajaLista').hide();", 200);
	if (numPais != '' && !isNaN(numPais) && esTab) {
		paisesServicio.consultaPaises(conPais, numPais,function(pais) {
			if (pais != null) {
				$('#paisFPM').val(pais.nombre);
			}
			else {
				mensajeSis("No Existe el País");
				$('#'+idControl).focus();
				$('#paisFEA').val('');
				$('#paisFPM').val('');
			}
		});
	}else{
		if(isNaN(numPais) ){
			mensajeSis("No Existe el País");
			$('#paisFEA').val('');
			$('#paisFPM').val('');
			$('#'+idControl).focus();
			
		}
	}


}

// Función que consulta el Estado (Dirección del Garante)
function consultaEstadoDir(idControl) {
	var jqEstado = eval("'#" + idControl + "'");
	var numEstado = $(jqEstado).val();	
	var tipConForanea = 2;	
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numEstado != '' && !isNaN(numEstado)){
		estadosServicio.consulta(tipConForanea,numEstado,{ async: false, callback: function(estado) {
			if(estado!=null){							
				$('#nombreEstadoDir').val(estado.nombre);
			}else{
				mensajeSis("No Existe el Estado");
				$('#nombreEstadoDir').val("");
				$('#estadoIDDir').val("");
				$('#estadoIDDir').focus();
				$('#estadoIDDir').select();
			}    	 						
		}});
	}
}

// Función que consulta el Municipio (Dirección del Cliente)
function consultaMunicipio(idControl) {
	var jqMunicipio = eval("'#" + idControl + "'");
	var numMunicipio = $(jqMunicipio).val();	
	var numEstado =  $('#estadoIDDir').val();				
	var tipConForanea = 2;	
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numMunicipio != '' && !isNaN(numMunicipio)){
		if(numEstado !=''){				
			municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,{ async: false, callback: function(municipio) {
				if(municipio!=null){							
					$('#nombreMuni').val(municipio.nombre);
				}else{
					mensajeSis("No Existe el Municipio");
					$('#nombreMuni').val("");
					$('#municipioID').val("");
					$('#municipioID').focus();
					$('#municipioID').select();
				}    	 						
			}});
			
		}else{
			mensajeSis("Especificar Estado");
			$('#estadoIDDir').focus();
		}
	}else{
		if(isNaN(numMunicipio) && esTab){
			mensajeSis("No Existe el Municipio");
			$('#nombreMuni').val("");
			$('#municipioID').val("");
			$('#municipioID').focus();
			$('#municipioID').select();
			
		}
	}
}	

// Función que consulta la Localidad (Dirección del Cliente)
function consultaLocalidad(idControl) {
	var jqLocalidad = eval("'#" + idControl + "'");
	var numLocalidad = $(jqLocalidad).val();
	var numMunicipio =	$('#municipioID').val();
	var numEstado =  $('#estadoIDDir').val();				
	var tipConPrincipal = 1;	
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numLocalidad != '' && !isNaN(numLocalidad)){
		if(numEstado != '' && numMunicipio !=''){				
			localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad,{ async: false, callback: function(localidad) {
				if(localidad!=null){							
					$('#nombrelocalidad').val(localidad.nombreLocalidad);
				}else{
					mensajeSis("No Existe la Localidad");
					$('#nombrelocalidad').val("");
					$('#localidadID').val("");
					$('#localidadID').focus();
					$('#localidadID').select();
				}    	 						
			}});
		}else{
			if(numEstado == ''){
				mensajeSis("Especificar Estado");
				$('#estadoIDDir').focus();
			}else{
				mensajeSis("Especificar Municipio");
				$('#municipioID').focus();
			}
		}
		
	}
}
//consulta Colonia y CP (Dirección del Cliente)
function consultaColonia(idControl) {
	var jqColonia = eval("'#" + idControl + "'");
	var numColonia= $(jqColonia).val();		
	var numEstado =  $('#estadoIDDir').val();	
	var numMunicipio =	$('#municipioID').val();
	var tipConPrincipal = 1;	
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numColonia != '' && !isNaN(numColonia)){
		coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,{ async: false, callback: function(colonia) {
			if(colonia!=null){							
				$('#nombreColonia').val(colonia.asentamiento);
				$('#CP').val(colonia.codigoPostal);
			}else{
				mensajeSis("No Existe la Colonia");
				$('#nombreColonia').val("");
				$('#coloniaID').val("");
				$('#coloniaID').focus();
				$('#coloniaID').select();
			}    	 						
		}});
	}else{
		$('#nombreColonia').val("");
	}
}

// Función que consulta el Estado (Escritura Publica)
function consultaEstadoEsc(idControl) {
	var jqEstado = eval("'#" + idControl + "'");
	var numEstado = $(jqEstado).val();	
	var tipConForanea = 2;	
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numEstado != '' && !isNaN(numEstado) && esTab){
		estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
			if(estado!=null){							
				$('#nombreEstadoEsc').val(estado.nombre);
														
			}else{
				mensajeSis("No Existe el Estado");
				$('#estadoIDEsc').focus();
				$('#estadoIDEsc').select();
				$('#estadoIDEsc').val("");
				$('#nombreEstadoEsc').val("");
				$('#municipioEsc').val("");
				$('#nombreMuniEsc').val("");
			}    	 						
		});
	}else{if(isNaN(numEstado) && esTab)
		{
		mensajeSis("No existe el Estado");
		$('#estadoIDEsc').focus();
		$('#estadoIDEsc').select();
		$('#estadoIDEsc').val("");
		$('#nombreEstadoEsc').val("");
		$('#municipioEsc').val("");
		$('#nombreMuniEsc').val("");
		}
	}
}

	// Función que consulta el Municiío (Escritura Pública)
	function consultaMunicipioEsc(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();	
		var numEstado =  $('#estadoIDEsc').val();				
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numMunicipio != '' && !isNaN(numMunicipio) && esTab){
			municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
				if(municipio!=null){							
					$('#nombreMuniEsc').val(municipio.nombre);						
				}else{
					mensajeSis("No Existe el Municipio");
						$('#municipioEsc').focus();
						$('#municipioEsc').select();
						$('#municipioEsc').val("");
						$('#nombreMuniEsc').val("");
				}    	 						
			});
		}else{ 
		if(isNaN(numMunicipio) && esTab){
			mensajeSis("No Existe el Municipio");
			$('#municipioEsc').focus();
			$('#municipioEsc').select();
			$('#municipioEsc').val("");
			$('#nombreMuniEsc').val("");
		}
		
	}
}

function consultaEstadoReg(idControl) {
	var jqEstado = eval("'#" + idControl + "'");
	var numEstado = $(jqEstado).val();	
	var tipConForanea = 2;	
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numEstado != '' && !isNaN(numEstado) && esTab){
		estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
			if(estado!=null){							
				$('#nombreEstadoReg').val(estado.nombre);
														
			}else{
				mensajeSis("No Existe el Estado");
				$('#estadoIDReg').focus();
				$('#estadoIDReg').select();
				$('#estadoIDReg').val("");
				$('#nombreEstadoReg').val("");
				$('#municipioRegPub').val("");
				$('#nombreMuniReg').val("");
			}    	 						
		});
	}else{
		if(isNaN(numEstado) && esTab){
			mensajeSis("No Existe el Estado");
			$('#estadoIDReg').focus();
			$('#estadoIDReg').select();
			$('#estadoIDReg').val("");
			$('#nombreEstadoReg').val("");
			$('#municipioRegPub').val("");
			$('#nombreMuniReg').val("");
		}
	}
}

function consultaMunicipioReg(idControl) {
	var jqMunicipio = eval("'#" + idControl + "'");
	var numMunicipio = $(jqMunicipio).val();	
	var numEstado =  $('#estadoIDReg').val();				
	var tipConForanea = 2;	
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numMunicipio != '' && !isNaN(numMunicipio) && esTab){
		municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
			if(municipio!=null){							
				$('#nombreMuniReg').val(municipio.nombre);						
			}else{
				mensajeSis("No Existe el Municipio");
					$('#municipioRegPub').focus();
					$('#municipioRegPub').select();
					$('#municipioRegPub').val("");
					$('#nombreMuniReg').val("");
			}    	 						
		});
	}
	else{
		if(isNaN(numMunicipio) && esTab){
			mensajeSis("No Existe el Municipio");
			$('#municipioRegPub').focus();
			$('#municipioRegPub').select();
			$('#municipioRegPub').val("");
			$('#nombreMuniReg').val("");
		}
	}
}		

function consultaNotaria(idControl) { 
	var jqNotaria = eval("'#" + idControl + "'");
	var numNotaria = $(jqNotaria).val();	
	
	var notariaBeanCon = {
			  'estadoID':$('#estadoIDEsc').val(),
			  'municipioID':$('#municipioEsc').val(),
			  'notariaID':numNotaria
			};
			
	var tipConForanea = 2;	
	setTimeout("$('#cajaLista').hide();", 200);	
	if(numNotaria != '' && !isNaN(numNotaria) && esTab){			
			notariaServicio.consulta(tipConForanea,notariaBeanCon,function(notaria) {
			if(notaria!=null){	
				$('#notaria').val(notaria.notariaID);	
				$('#direcNotaria').val(notaria.direccion);
				$('#nomNotario').val(notaria.titular);					
			}else{ 
				mensajeSis("No Existe La Notaría");
					$('#notaria').focus();
					$('#notaria').select();	
					$('#notaria').val("");
					$('#direcNotaria').val("");
					$('#nomNotario').val("");
			}
		});
	}
}

function consultaTipoIdent(numIdentific) {
	var tipConP = 1;	
	
	var numTipoIden = $('#tipoIdentiID option:selected').val();
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numIdentific != '' && !isNaN(numIdentific)  ){

		tiposIdentiServicio.consulta(tipConP,numTipoIden,{ async: false, callback:function(identificacion) {
			if(identificacion!=null){							
				$('#tipoIdentiID').val(identificacion.tipoIdentiID);
				$('#numeroCaracteres').val(identificacion.numeroCaracteres);

			}else{
				mensajeSis("No Existe la Identificación");
			}    	 						
		}});
	}
}


	// ------------ Validaciones de Controles-------------------------------------
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
				//Validacion para mostrara boton de calcular CURP Y RFC
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
	

// Funcion que forma la CURP
function formaCURP() {
	var sexo = $('#sexo').val();
	var nacionalidad = $('#nacionalidad').val();
	if(sexo == "M")
	{sexo = "H";}
	else if(sexo == "F")
	{sexo = "M";}
	else{
		sexo = "H";
		mensajeSis("Especifique Género");
	}
	
	if(nacionalidad == "N")
	{nacionalidad = "N";}
	else if(nacionalidad == "E")
	{nacionalidad = "S";}
	else{
		nacionalidad = "N";
		mensajeSis("No se Asignó Nacionalidad");
	}
	var CURPBean = {
		'primerNombre'	:$('#primerNombre').val(),
		'segundoNombre'	:$('#segundoNombre').val(),
		'tercerNombre'	:$('#tercerNombre').val(),
		'apellidoPaterno' : $('#apellidoPaterno').val(),
		'apellidoMaterno' : $('#apellidoMaterno').val(),
		'sexo'			:sexo,
		'fechaNacimiento' : $('#fechaNacimiento').val(),
		'nacion'		:nacionalidad,
		'estadoID':$('#estadoID').val()
		
	};
	clienteServicio.formaCURP(CURPBean, function(cliente) {
		if (cliente != null) {
			$('#curp').val(cliente.CURP);
		}
	});
}

// Función que valida la CURP
function validaCURP(idControl) {
	var jqCURP = eval("'#" + idControl + "'");
	var numCURP = $(jqCURP).val();
	var tipoPer;
	var persona;
	var tipCon = 11;
	setTimeout("$('#cajaLista').hide();", 200);
	
	if($('#tipoPersona1').is(':checked')){
		persona = 'F';
	}else if(($('#tipoPersona2').is(':checked'))){
		persona = 'M';
	}else if(($('#tipoPersona3').is(':checked'))){
		persona = 'A';
	}
	
	
	if (numCURP != '' && esTab ) {
		clienteServicio.consultaCURP(tipCon, numCURP,function(curp) {
			if (curp != null) {
					 numCliente = curp.numero;
					 tipoPer = curp.tipoPersona;
						clienteServicio.consulta(17, numCliente, function(cliente) {
							
							if (cliente != null) {
								var numClienteID = parseInt(cliente.numero);
									if($('#numero').val() != numClienteID){
										if(persona == 'F' || persona == 'A'){
											if(cliente.descripcionCURP!=''){
												mensajeSis(cliente.descripcionCURP +cliente.numero);
												$(jqCURP).select();	
												$(jqCURP).focus();	
											}
								}
							}
							}
						});
					 
				}
		});
	}
}


// Funcion que valida la CURP generada
function validaCURPv1(curp){
	var fecha=$('#fechaNacimiento').val();
	var regexp = /^([A-Z][A,E,I,O,U,X][A-Z]{2})(\d{2})((01|03|05|07|08|10|12)(0[1-9]|[12]\d|3[01])|02(0[1-9]|[12]\d)|(04|06|09|11)(0[1-9]|[12]\d|30))([M,H])(AS|BC|BS|CC|CS|CH|CL|CM|DF|DG|GT|GR|HG|JC|MC|MN|MS|NT|NL|OC|PL|QT|QR|SP|SL|SR|TC|TS|TL|VZ|YN|ZS|NE)([B,C,D,F,G,H,J,K,L,M,N,Ñ,P,Q,R,S,T,V,W,X,Y,Z]{3})([0-9,A-Z][0-9])$/;
    if(regexp.test(curp) == false){
		mensajeSis('La CURP es incorrecta');
		$('#generarc').focus();
	}else{
		if(obtenFechaCurp(curp,fecha)!=true){
			 mensajeSis('La CURP no concuerda con la Fecha de Nacimiento');
		     $('#generarc').focus();
		}
	}

}

// Función que valida la fecha generada en la CURP con la fecha de nacimiento elegida.
function obtenFechaCurp(curp,fechaNaci){
	var esValido=true;
	var inicioCurp=4;
	var finCurp=10;
	var inicio = 2;
	var fin    = 9;  
	var exp=/([-])/;
	var fechaCurp=curp.substring(inicioCurp, finCurp);
	var fechaNac=fechaNaci.replace(exp,'');
	var fechaNacimiento=fechaNac.replace(exp,'');
	if(fechaCurp==fechaNacimiento.substring(inicio,fin)){
		 esValido=true;
	}else{
		esValido=false;
	}

	return esValido;
}


// Funcion que forma el RFC
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

			$('#rfc').val(cliente.RFC);
		}
		$("#contenedorForma").unblock();
	});
}

// Funcion que consulta si el RFC generado existe 
function validaRFC(idControl) {
	var jqRFC = eval("'#" + idControl + "'");
	var numRFC = $(jqRFC).val();
	var tipCon = 4;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numRFC != '' && esTab ) {
		clienteServicio.consultaRFC(tipCon,	numRFC,function(rfc) {
			if (rfc != null) {
				 numCliente = rfc.numero;		
					clienteServicio.consulta(17, numCliente, function(cliente) {
						if (cliente != null) {
							var numClienteID = parseInt(cliente.numero);
							if($('#numero').val() != numClienteID){
								if(cliente.descripcionRFC!=''){
									mensajeSis(cliente.descripcionRFC +cliente.numero);
									$(jqRFC).focus();	
									$(jqRFC).select();

								}
							}
						}
					});
			}
		});
	}
}

// Función que valida el RFC generado
function validaRFCv1(rfc){
	var fecha=$('#fechaNacimiento').val();
	var regexp=/^([A-Z,Ñ,&]{3,4}([0-9]{2})(0[1-9]|1[0-2])(0[1-9]|1[0-9]|2[0-9]|3[0-1])[A-Z|\d]{3})$/;
	if(regexp.test(rfc) == false){
		mensajeSis('El RFC es Incorrecto.');
		$('#generar').focus();
	}else{
		if(obtenFechaCurp(rfc,fecha)!=true){
			 mensajeSis('El RFC no concuerda con la Fecha de Nacimiento.');
		     $('#generar').focus();
		}			
	}
}





function limpiaDatosPersonaFisica(){
	$('#titulo').val("");
	$('#primerNombre').val('');
	$('#segundoNombre').val('');
	$('#tercerNombre').val('');
	$('#apellidoPaterno').val('');
	$('#apellidoMaterno').val('');
	$('#fechaNacimiento').val('');
	$('#nacionalidad').val('');
	$('#lugarNacimiento').val('');
	$('#paisNac').val('');
	$('#estadoID').val('');
	$('#nombreEstado').val('');	
	$('#paisResidencia').val('');
	$('#paisR').val('');
	$('#sexo').val("");
	$('#curp').val('');
	$('#registroHaciendaNo').attr('checked',true);		
	$('#rfc').val('');
	$('#fechaConstitucion').val('');
	$('#estadoCivil').val("");
	$('#telefonoCelular').val('');
	$('#telefono').val('');
	$('#extTelefonoPart').val('');
	$('#correo').val('');
	$('#fax').val('');
	$('#observaciones').val('');

	$('#tipoIdentiID').val('');
	$('#numIdentific').val('');
	$('#fecExIden').val('');
	$('#fecVenIden').val('');
	$('#estadoIDDir').val('');
	$('#nombreEstadoDir').val('');
	$('#municipioID').val('');
	$('#nombreMuni').val('');
	$('#localidadID').val('');
	$('#nombrelocalidad').val('');
	$('#coloniaID').val('');
	$('#nombreColonia').val('');
	$('#calle').val('');
	$('#numeroCasa').val('');
	$('#numInterior').val('');
	$('#CP').val('');
	$('#lote').val('');
	$('#manzana').val('');

}

function limpiaDatosPersonaMoral(){	
	$('#razonSocial').val('');
	$('#rfcPM').val('');	
	$('#nacionalidadPM').val("");
	$('#paisConstitucionID').val('');
	$('#descPaisConst').val('');	
	$('#correoPM').val('');
	$('#correoAlternativo').val('');
	$('#telefonoPM').val('');
	$('#extTelefonoPartPM').val('');	
	$('#tipoSociedad').val('');
	$('#descripSociedad').val('');
	$('#grupoEmpresarial').val('');
	$('#NombreGrupo').val('');
	$('#fechaConstitucionPM').val('');
	$('#fea').val('');	
	$('#paisFEA').val('');	
	$('#paisFPM').val('');	
	$('#esc_Tipo').val('');
	$('#escrituraPub').val('');	
	$('#libroEscritura').val('');	
	$('#volumenEsc').val('');	
	$('#fechaEsc').val('');	
	$('#estadoIDEsc').val('');	
	$('#nombreEstadoEsc').val('');	
	$('#municipioEsc').val('');	
	$('#nombreMuniEsc').val('');	
	$('#notaria').val('');	
	$('#direcNotaria').val('');	
	$('#nomNotario').val('');	
	$('#nomApoderado').val('');
	$('#RFC_Apoderado').val('');	
	$('#registroPub').val('');	
	$('#folioRegPub').val('');	
	$('#volumenRegPub').val('');	
	$('#libroRegPub').val('');	
	$('#auxiliarRegPub').val('');	
	$('#fechaRegPub').val('');	
	$('#estadoIDReg').val('');	
	$('#municipioRegPub').val('');
	$('#nombreEstadoReg').val('');
	$('#nombreMuniReg').val('');
	

	

}

function limpiaChecks(){
	if($('#tipoPersona2').is(':checked')){
		$('#ocupacionID').val('');
		$('#ocupacionC').val('');
		$('#puesto').val('');
		$('#lugarTrabajo').val('');
		$('#domicilioTrabajo').val('');
		$('#antiguedadTra').val('');
		$('#antiguedadTraMes').val('');
		$('#telTrabajo').val('');
		$('#extTelefonoTrab').val('');
	}
	if($('#tipoPersona1').is(':checked') || $('#tipoPersona3').is(':checked')){
		$('#razonSocial').val('');
		$('#tipoSociedadID').val('');
		$('#descripSociedad').val('');
		$('#RFCpm').val('');
		$('#grupoEmpresarial').val('');
	}

}

function limpiaForma(){
	limpiaFormaCompleta('formaGenerica', true, [ 'numero', 'sucursalOrigen', 'sucursalO' ]);
	$('#tipoPersona1').attr("checked", true);
	deshabilitaBoton('elimina', 'submit');
	deshabilitaBoton('agregar', 'submit');
	deshabilitaBoton('modifica', 'submit');
}


/*funcion valida fecha formato (yyyy-MM-dd)*/
function esFechaValida(fecha){

	if (fecha != undefined && fecha.value != "" ){
		var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
		if (!objRegExp.test(fecha)){
			mensajeSis("Formato de Fecha No Válido (aaaa-mm-dd)");
			return false;
		}

		var mes=  fecha.substring(5, 7)*1;
		var dia= fecha.substring(8, 10)*1;
		var anio= fecha.substring(0,4)*1;

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
			mensajeSis("Fecha introducida errónea");
		return false;
		}
		if (dia>numDias || dia==0){
			mensajeSis("Fecha introducida errónea");
			return false;
		}
		return true;
	}
}

function mayor(fecha, fecha2){ // valida si fecha > fecha2: true else false

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


function comprobarSiBisisesto(anio){
	if ((( anio % 100 != 0) && (anio % 4 == 0)) || (anio % 400 == 0)) {
		return true;
	}
	else {
		return false;
	}
}

function llenaComboTiposIdenti(){

	dwr.util.removeAllOptions('tipoIdentiID'); 
	tiposIdentiServicio.listaCombo(3, function(tIdentific){
		dwr.util.addOptions('tipoIdentiID'	,{'':'SELECCIONAR'});
		dwr.util.addOptions('tipoIdentiID', tIdentific, 'tipoIdentiID', 'nombre');
	});		

}

 function exitoTransCliente(){
	limpiaFormaCompleta('formaGenerica', true, [ 'numero']);
	
}
function falloTransCliente(){
	
}
