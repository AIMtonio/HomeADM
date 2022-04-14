$(document).ready(function() {	

	$('#numero').focus();
	
	var catTipoConsultaProspec = {
	  		'principal':1,
	  		'prospectoCliente':3
	};	
	var parametroBean = consultaParametrosSession();
	$('#sucursalOrigen').val(parametroBean.sucursal);	
	$('#sucursalO').val(parametroBean.nombreSucursal);	

	//Validacion para mostrarar boton de calcular CURP 
	permiteCalcularCURPyRFC('generarc','',1);
	
	var numEmpresa =1;
	$('#empresa').val(numEmpresa);	
	esTab = true;
	$(':text').focus(function() {
		esTab = false;
	});

	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	// Definicion de Constantes y Enums
	var catTipoTransaccionCliente = {
		'agregaSocioMenor' : '1',
		'modificaSocioMenor' : '2'
	};

	var catTipoConsultaCliente = {
		'principal' : '1',
		'foranea' : '2'
	};

	var catTipoConsultaOcupacion = {
		'principal' : '1',
		'foranea' : '2'
	};

	var catTipoConsultaPromotor = {
		'principal' : '1',
		'foranea' : '2'
	};
	var catTipoConsultaSucursal = {
		'principal' : '1',
		'foranea' : '2'
	};
	var catTipoConsultaSociedad = {
		'principal' : 1,
		'foranea' : 2
	};

	// ------------ Metodos y Manejo de Eventos
	// -----------------------------------------
	deshabilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('actualiza','submit');
	agregaFormatoControles('formaGenerica');
	
	$('#fechaNacimiento').change(function() {
		
		var Xfecha= $('#fechaNacimiento').val(); 
		var Yfecha=  parametroBean.fechaSucursal;
		if(esFechaValida(Xfecha)){
			if(Xfecha=='')$('#fechaNacimiento').val(parametroBean.fechaSucursal);

			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La fecha capturada es mayor a la de hoy");
				$('#fechaNacimiento').val(parametroBean.fechaSucursal);
				
				$('#fechaNacimiento').focus();
			}else{			
				if (mayorEdad(Xfecha, Yfecha) ){
					mensajeSis("La Fecha Indicada Corresponde a un Socio Mayor, Registrarlo en la pantalla Correspondiente.");
					$('#fechaNacimiento').val(parametroBean.fechaSucursal);
					$('#fechaNacimiento').focus();
				}else{
					$('#CURP').val('');
					$('#nacion').focus();
				}	
			}
		}else{
			$('#fechaNacimiento').val(parametroBean.fechaSucursal);
			$('#fechaNacimiento').focus();
		}

	});
	
	$('#fechaNacimiento').blur(function() {		
		var Xfecha= $('#fechaNacimiento').val(); 
		var Yfecha=  parametroBean.fechaSucursal;
		if (esTab == true) {	
			if ( mayor(Xfecha, Yfecha) )
			{
				mensajeSis("La fecha capturada es mayor a la de hoy");
				$('#fechaNacimiento').val(parametroBean.fechaSucursal);
			}
			
		}
	});
	
	
	
	$('#parentescoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			lista('parentescoID', '2', '3', 'descripcion',$('#parentescoID').val(), 'listaParentescos.htm');
		}
	}); 
		
	$('#parentescoID').blur(function() {
  		consultaParentesco(this.id,'');
	}); 
	
	$('#clienteID').bind('keyup',function(e) { 
				listaAlfanumerica('clienteID', '3', '13', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	

	$('#clienteID').blur(function() {
		consultaTutor(this.id);
	});
	
	$('#nacion').change(function() {
		validaNacionalidadCte();
	});
	
	$('#primerNombre').blur(function() {
		var nombre = $('#primerNombre').val();
		$('#primerNombre').val($.trim(nombre));
	});
	
	$('#segundoNombre').blur(function() {
		var senombre = $('#segundoNombre').val();
		$('#segundoNombre').val($.trim(senombre));
	});
	
	$('#tercerNombre').blur(function() {
		var ternombre = $('#tercerNombre').val();
		$('#tercerNombre').val($.trim(ternombre));
	});
	
	$('#apellidoPaterno').blur(function() {
		var ap = $('#apellidoPaterno').val();
		$('#apellidoPaterno').val($.trim(ap));
	});
	
	$('#apellidoMaterno').blur(function() {
		var am = $('#apellidoMaterno').val();
		$('#apellidoMaterno').val($.trim(am));
	});
	
	$('#CURP').blur(function() {
			validaCURP('CURP');
		
	});
	$('#esSocioSi').attr('checked', 'true');
	$('#Socio').show();
	$('#Tutor').hide();

	$(':text').focus(function() {
		esTab = false;
	});

	$.validator.setDefaults({
		submitHandler : function(event) {
			if(validaCheck() != false){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','numero','exitoTransMenor','');

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

	$('#agrega').click(function() {
		
		$('#tipoTransaccion').val(catTipoTransaccionCliente.agregaSocioMenor);
	});

	$('#modifica').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionCliente.modificaSocioMenor);
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
	
	$('#numero').bind('keyup',function(e) { 
				lista('numero', '3', '5', 'nombreCompleto', $('#numero').val(), 'listaCliente.htm');
	});
//	$('#numero').bind('keyup',function(e){
//		if($('#numero').val().length<3){		
//			$('#cajaListaCte').hide();
//		}
//	});

//	$('#buscarMiSuc').click(function(){
//		listaCte('numero', '3', '23', 'nombreCompleto', $('#numero').val(), 'listaCliente.htm');
//	});
//	$('#buscarGeneral').click(function(){
//		listaCte('numero', '3', '5', 'nombreCompleto', $('#numero').val(), 'listaCliente.htm');
//	});

	$('#numero').blur(function() {
		validaCliente(this,0);
	});

	$('#agrega').attr('tipoTransaccion', '1');
	$('#modifica').attr('tipoTransaccion', '2');

	$('#ocupacionID').bind('keyup',function(e) { 
		lista('ocupacionID', '1', '1', 'descripcion',$('#ocupacionID').val(),'listaOcupaciones.htm');
	});

	$('#ocupacionID').blur(function() {
		consultaOcupacion(this.id);
	});

	$('#promotorInicial').bind('keyup',function(e) {
		parametroBean = consultaParametrosSession();
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombrePromotor";
		camposLista[1] = "sucursalID";
		parametrosLista[0] = $('#promotorInicial').val();
		parametrosLista[1] = parametroBean.sucursal;  
		lista('promotorInicial', '1', '2',camposLista, parametrosLista, 'listaPromotores.htm');
	});

	$('#promotorInicial').blur(function() {
		consultaPromotorI(this.id,'S');
		($('#actividadINEGI').val());
		($('#sectorEconomico').val());
	});

	$('#promotorActual').bind('keyup',function(e) { 
		parametroBean = consultaParametrosSession();
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombrePromotor";
		camposLista[1] = "sucursalID";
		parametrosLista[0] = $('#promotorInicial').val();
		parametrosLista[1] = parametroBean.sucursal;  
		lista('promotorActual', '1', '2',camposLista, parametrosLista, 'listaPromotores.htm');
	});

	$('#promotorActual').blur(function() {
		consultaPromotorA(this.id, 'S');
	});

	$('#sucursalOrigen').bind('keyup',function(e) {
		lista('sucursalOrigen', '1', '1','nombreSucurs', $('#sucursalOrigen').val(), 'listaSucursales.htm');
	});

	$('#sucursalOrigen').blur(function() {
		consultaSucursal(this.id);
	});

	$('#paisResidencia').bind('keyup',function(e) { 
		lista('paisResidencia', '1', '1', 'nombre', $('#paisResidencia').val(),'listaPaises.htm');
	});

	$('#paisResidencia').blur(function() {
		consultaPais(this.id);
	});

	$('#lugarNacimiento').bind('keyup',function(e) { 
		lista('lugarNacimiento', '1', '1', 'nombre', $('#lugarNacimiento').val(),'listaPaises.htm');
	});

	$('#lugarNacimiento').blur(function() {
		consultaPaisNac(this.id);
	});

	$('#estadoID').bind('keyup',function(e) {
		lista('estadoID', '2', '1', 'nombre',$('#estadoID').val(),'listaEstados.htm');
	});

	$('#estadoID').blur(function() {
		consultaEstado(this.id);
	});

			
	$('#tipoSociedadID').bind('keyup',function(e) {
		lista('tipoSociedadID', '2', '1','descripcion', $('#tipoSociedadID').val(),'listaTipoSociedad.htm');
	});

	$('#tipoSociedadID').blur(function() {
		consultaSociedad(this.id);
	});
	
	$('#prospectoID').blur(function() {
		consultaProspecto('prospectoID');
	});
	
	$('#prospectoID').bind('keyup',function(e){
		lista('prospectoID', '1', '1', 'prospectoID', $('#prospectoID').val(), 'listaProspecto.htm');
	});	

	$("#telefonoCelular").setMask('phone-us');
	$("#telefonoCasa").setMask('phone-us');
	
	$('#extTelefonoPart').blur(function() {
		if(this.value != ''){
			if($("#telefonoCasa").val() == ''){
				this.value = '';
				mensajeSis("El Número de Teléfono está Vacío.");
				$("#telefonoCasa").focus();
			}
		}
	});
	
	$("#telefonoCasa").blur(function (){
		if(this.value ==''){
			$('#extTelefonoPart').val('');
		}
	});

	
	
	$('#ejecutivoCap').bind('keyup',function(e) {
		parametroBean = consultaParametrosSession();
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombrePromotor";
		camposLista[1] = "sucursalID";
		parametrosLista[0] = $('#ejecutivoCap').val();
		parametrosLista[1] = parametroBean.sucursal;  
		lista('ejecutivoCap', '2', '8',camposLista, parametrosLista, 'listaPromotores.htm');
	});
	
	$('#promotorExtInv').bind('keyup',function(e) {
		parametroBean = consultaParametrosSession();
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "numero";
		camposLista[1] = "nombre";
		parametrosLista[0] = $('#promotorExtInv').val();
		parametrosLista[1] = parametroBean.sucursal;  
		lista('promotorExtInv', '2', '7',camposLista, parametrosLista, 'listaPromotores.htm');
	});
	
	
	/*$('#ejecutivoCap').blur(function() {
		consultaNombreCaptacion(this.id);
	});
	
	$('#promotorExtInv').blur(function() {
		consultaNomProExterno(this.id);
	});
	*/

	consultaPromotorActiva('empresa');
	jQuery.validator.addMethod("texto", function(value,  element) {
		return this.optional(element) ||/^([a-z ñáéíóú']{2,60})$/i.test(value);
		}, "Ingrese un nombre Validaciones");
	jQuery.validator.addMethod("numero", function(value,  element) {
		return this.optional(element) ||/^([1-9]{2,60})$/i.test(value);
		}, "Favor de Ingresar un Identificador Valido");
	
	// ------------ Validaciones de la Forma
	$('#formaGenerica').validate({
		rules : {
			numero : {
				required : false
			},
	
			primerNombre : {
				required : true,
				minlength : 2,
				texto: true
			},
			segundoNombre: {
				texto: true
			},
			tercerNombre: {
				texto: true
			},
			apellidoPaterno : {
				required : true,
				texto: true
			},
			apellidoMaterno :{
				texto: true
			},
			clienteID :{
				required : function () {return $('#esSocioSi').is(':checked'); },
				numeroPositivo : true
			},
			nombreTutor: {
				required : function () {return $('#esSocioNO').is(':checked'); },
				texto : true
			},
			
			razonSocial : {
				required : function() {return $('#tipoPersona2').is(':checked'); },
				minlength : 2
			},
			direccion : 'required',
			
			correo : {
				required : false,
				email : true
			},
			extTelefonoPart :{
				number :true,
			},
			sucursalOrigen : 'required',
	
			CURP : {
				required : true,
				maxlength : 18
			},
			fechaNacimiento : {
				required : function() {
					var Xfecha= $('#fechaNacimiento').val();
					var Yfecha=  parametroBean.fechaSucursal;
					var xAnio=Xfecha.substring(0,4);
					var anioActual = Yfecha.substring(0,4);
					var edad= ( anioActual - xAnio);		
					return edad >= 18; 
			},
				date: true
			},
			ocupacionID : {
				required : function() {return $('#tipoPersona').is(':checked');}
			},
			paisResidencia : {
				required : true, 
				numeroPositivo:true},
			lugarNacimiento: {
				required : true,
				numeroPositivo: true
			},
			/*
		ejecutivoCap : {
				required : function() {return $('#muestraEjec').val() == '1';}
			}
			*/
			
			promotorExtInv : {
				required : function() {return $('#muestraEjec').val() == '1';}	
			},
			estadoID:{
				required : true,
				numeroPositivo: true,
			},
			promotorInicial : {
				required : true,
				numeroPositivo : true
			},
			promotorActual :{
				required : true,
				numeroPositivo : true
			},
			
			parentescoID : {
				required : true,
				numeroPositivo : true
			}
			
		},
	
		
		
		messages : {
			
			
			
			primerNombre : {
				required : 'Especificar nombre',
				minlength : 'Al menos dos Carácteres',
				texto:'El nombre no es valido'
				
			},
			segundoNombre :{
				texto: 'El nombre no es valido'
			},
			tercerNombre :{
				texto: 'El nombre no es valido'
			},
			apellidoPaterno : {
				required : 'Especifique el Apellido Paterno',
				texto : 'El apellido no es valido'
			},
			apellidoMaterno : {
				texto: 'El apellido no es Valido'
			},
			clienteID : {
					required: 'Especifique el Cliente Suscriptor',
					numeroPositivo: 'Favor de Ingresar un Identificador Valido'
			},
			nombreTutor: {
				required : 'Especifique el nombre del Suscriptor',
				texto : 'El nombre no es valido'
			},
			correo : {
				required : 'Especifique un Correo',
				email : 'Dirección Invalida'
			},
	
			direccion : 'Especifique Dirección',
	
			representanteLegal : {
				required : 'Especifique Representante Legal',
				minlength : 'Al menos tres Carácteres'
			},
	
	
			sucursalOrigen : 'Especifique Sucursal',
	
			CURP : {
				required : 'Especifique CURP',
				maxlength : 'Maximo 18 carácteres'
			},
				
			fechaNacimiento : {
				required : 'Especifique Fecha de Nacimiento',
				date : 'Fecha Incorrecta'
			},
			
			lugarNacimiento : {
				required : 'Especifique Lugar de Nacimiento',
				numeroPositivo : 'Favor de ingresar un Identificador Valido'
			},
			ocupacionID : {
				required : 'Especifique la Ocupación del Cliente'
			},
			extTelefonoPart : {
				number :'Sólo Números(Campo opcional)'
			},
			
			paisResidencia : {
				required: 'Especifique País de Residencia',
				numeroPositivo : 'Favor de ingresar un Identificador Valido'
				},
			
			promotorExtInv : {
				required : 'Especificar Promotor externo de Inversión',
				
				},
			/*
				ejecutivoCap : {
				required : 'Especificar Promotor de Captación',
				
			}*/
			estadoID:{
				required : 'El Estado es Requerido',
			},
			promotorInicial : {
				required : 'EL promotor Inicial es Requerido'
				
			},
			promotorActual :{
				required : 'EL promotor Actual es Requerido'
				
			},
			
			parentesco : {
				required : 'EL Parentesco es Requerido',
				numeroPositivo : 'Favor de Ingresar un identificador Valido'
				
			}

			

			},
			
		
			
	});
	
	
	
	
	// ------------ Validaciones de Controles-------------------------------------

	
	function consultaProspecto(idControl) {
		var jqProspecto = eval("'#" + idControl + "'");
		var numProspecto = $(jqProspecto).val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numProspecto != '' && !isNaN(numProspecto) && esTab){	
			deshabilitaBoton('agrega', 'submit');
			habilitaBoton('modifica', 'submit');
			var prospectoBeanCon ={
		 		 	'prospectoID' : numProspecto 
			};		
			prospectosServicio.consulta(catTipoConsultaProspec.principal,prospectoBeanCon,function(prospectos) {
				if(prospectos!=null){
					if(prospectos.cliente>0){
						$('#numero').val(prospectos.cliente);
						$('#prospectoID').val(prospectos.prospectoID);
						$('#nombreProspecto').val(prospectos.nombreCompleto);
						esTab=true;
						validaCliente('numero',prospectos.prospectoID);			
						$('#prospectoID').val(prospectos.prospectoID);
						$('#nombreProspecto').val(prospectos.nombreCompleto);			
					}else{
						$('#prospectoID').val(prospectos.prospectoID);
						$('#nombreProspecto').val(prospectos.nombreCompleto);
						$('#numero').val("0",prospectos.prospectoID);
						validaCliente('numero',prospectos.prospectoID);		
						if (prospectos.tipoPersona == 'F') {
							$('#tipoPersona').attr("checked","1");
							$('#tipoPersona2').attr("checked",false);
							$('#tipoPersona3').attr("checked",false);
							$('#personaFisica').show(500);
							$('#personaMoral').hide(500);
							$('#generar').show(500);
							$('#ocupacionID').val('');

						} else {
							if (prospectos.tipoPersona == 'A') {
								$('#tipoPersona3').attr("checked","1");
								$('#tipoPersona2').attr("checked",false);
								$('#tipoPersona').attr("checked",false);
								$('#personaFisica').show(500);
								$('#personaMoral').hide(500);

							}
							if (prospectos.tipoPersona == 'M'){
								$('#tipoPersona2').attr("checked","1");
								$('#tipoPersona').attr("checked",false);
								$('#tipoPersona3').attr("checked",false);
								$('#personaMoral').show(500);
								$('#generar').hide(500);
								$('#personaFisica').hide(500);
								$('#grupoEmpresarial').val("");
							}
						}
						$('#razonSocial').val(prospectos.razonSocial);
						$('#primerNombre').val(prospectos.primerNombre);
						$('#segundoNombre').val(prospectos.segundoNombre);
						$('#tercerNombre').val(prospectos.tercerNombre);
						$('#apellidoPaterno').val(prospectos.apellidoPaterno);
						$('#apellidoMaterno').val(prospectos.apellidoMaterno);
						$('#RFC').val(prospectos.RFC);
						$('#fechaNacimiento').val(prospectos.fechaNacimiento);
						$('#estadoCivil').val(prospectos.estadoCivil);
						$('#telefonoCelular').val(prospectos.telefono);
						$('#telefonoCasa').val(prospectos.telefono);
						$('#prospectoID').val(prospectos.prospectoID);
						$('#nombreProspecto').val(prospectos.nombreCompleto);
						var select =	eval("'#sexo option[value="+prospectos.sexo+"]'");
						$(select).attr('selected','true');
					}
				}else{
					mensajeSis("No Existe el Prospecto");
					$('#prospectoID').val("0");
					$('#nombreProspecto').val("");
					$('#numero').val("0");
					validaCliente('numero',	$('#prospectoID').val());
				}	
			});			
		}
	} 
	
	// a traves de un numero de cliente consulta el numero de prospecto
	function consultaProspectoCliente(idControl) {
		var jqCte = eval("'#" + idControl + "'");
		var numCte = $(jqCte).val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCte != '' && !isNaN(numCte) && esTab){	
			deshabilitaBoton('agrega', 'submit');
			habilitaBoton('modifica', 'submit');
			var prospectoBeanCon ={
		 		 	'cliente' : numCte 
			};		
			prospectosServicio.consulta(catTipoConsultaProspec.prospectoCliente,prospectoBeanCon,function(prospectos) {
				if(prospectos!=null){
					if(prospectos.prospectoID>0){
						$('#numero').val(prospectos.cliente);
						$('#prospectoID').val(prospectos.prospectoID);
						$('#nombreProspecto').val(prospectos.nombreCompleto);			
					}else{
						$('#numero').val(prospectos.cliente);
						$('#prospectoID').val(prospectos.prospectoID);
						$('#nombreProspecto').val(prospectos.nombreCompleto);
					}
				}else{
					$('#prospectoID').val("0");
					$('#nombreProspecto').val("");
				}	
				
			});			
		}
	} 
	
	function validaNacionalidadCte(){
		var nacionalidad = $('#nacion').val();
		var pais= $('#lugarNacimiento').val();
		var mexico='700';
		var nacdadMex='N';
		var nacdadExtr='E';
		if(nacionalidad==nacdadMex){
			if(pais!=mexico){
				mensajeSis("Por la nacionalidad de la persona el país debe ser México");
				$('#lugarNacimiento').val('');
				$('#paisNac').val('');
				$('#estadoID').val('');
				$('#nombreEstado').val('');
				$('#lugarNacimiento').focus();
				
			}
		}
		if(nacionalidad==nacdadExtr){
			if(pais==mexico){
				mensajeSis("Por la nacionalidad de la persona el país NO debe ser México");
				$('#lugarNacimiento').val('');
				$('#paisNac').val('');
				$('#lugarNacimiento').focus();
			}
		}
	}
	
	function validaCliente(control,valorProspecto) {
		var numCliente = $('#numero').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if (numCliente != '' && !isNaN(numCliente) && esTab) {
			if (numCliente == '0') {    
				habilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');
				$('#promotorInicial').attr('readonly',false);
				$('#promotorActual').attr('readonly',false);
				inicializaForma('formaGenerica', 'numero');
				$('#RFC').val('');
				$('#esMenorEdad').val('S');
				$('#fax').val('');
				consultaPromotorActiva('empresa');
				if($('#prospectoID').asNumber()>0){
				}else{
					
					
					$('#tipoPersona').attr("checked", "1");
					$('#generar').show(500);
					$('#paisResidencia').val('700');
					consultaPais('paisResidencia');
					$('#nacion').val('N');		
					$('#prospectoID').val("");
					$('#nombreProspecto').val("");
					$('#prospectoID').focus();
					$('#nivelRiesgo').find('option').remove().end().append('<option value="A">ALTO</option><option value="M">MEDIO</option><option value="B">BAJO</option>') ;
					$('#sucursalOrigen').val(parametroBean.sucursal);	
					$('#sucursalO').val(parametroBean.nombreSucursal);
					
					
				}
				$('#esSocioSi').attr('checked', 'true');
				$('#Socio').show();
				$('#Tutor').hide();
		
			}
			
			else {
				
				if($('#prospectoID').asNumber()>0){
				}else{
					$('#lblProspecto').hide();
					$('#inputProspectoID').hide();
					$('#prospectoID').val("");
					$('#nombreProspecto').val("");	
					
				}
			
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				
				var socioMenorBean = {
					'numero' : numCliente
				};
				socioMenorServicio.consulta(1,socioMenorBean,function(cliente) {
					consultaPromotorActiva('empresa');
					if (cliente != null) {
						if(cliente.esMenorEdad =='S'){
						dwr.util.setValues(cliente);
									esTab = true;
									consultaProspectoCliente('numero');
									if (cliente.clienteTutorID != 0){
										consultaTutor('clienteID');
										$('#Socio').show();
										$('#Tutor').hide();
									}else{
										$('#esSocioSi').removeAttr('checked');
										$('#esSocioNO').attr('checked', 'true');
										$('#nombreTutor').val(cliente.nombreTutor);
										$('#Socio').hide();
										$('#Tutor').show();
									}
									
									consultaOcupacion('ocupacionID');
									consultaPromotorI('promotorInicial','N');
									consultaPromotorA('promotorActual', 'N');
									consultaParentesco('parentescoID','');
								
									/*consultaNombreCaptacion('ejecutivoCap');
									consultaNomProExterno('promotorExtInv');

									
								    if(cliente.ejecutivoCap == 0){
										$('#ejecutivoCap').val('');
									}else{
										$('#ejecutivoCap').val(cliente.ejecutivoCap);
										consultaNombreCaptacion('ejecutivoCap');
										
										
									}
									if(cliente.promotorExtInv == 0){
										$('#promotorExtInv').val('');
									}else{
										$('#promotorExtInv').val(cliente.promotorExtInv);
										consultaNomProExterno('promotorExtInv');
										
									}	*/
									
									
									
									if(cliente.telefonoCasa == 0){
										$('#telefonoCasa').val('');
									}
									if(cliente.telefonoCelular == 0){
										$('#telefonoCelular').val('');
									}
									if (cliente.fechaNacimiento == '1900-01-01'){
										$('#fechaNacimiento').val('');
									}else{
										$('#fechaNacimiento').val(cliente.fechaNacimiento);
									}
									$('#sucursalOrigen').val(cliente.sucursalOrigen);
									consultaSucursal('sucursalOrigen');
									$('#estadoID').val(cliente.estadoID);
									consultaEstado('estadoID');
									$('#lugarNacimiento').val(cliente.lugarNacimiento);
									consultaPaisNac('lugarNacimiento');
									$('#paisResidencia').val(cliente.paisResidencia);
									consultaPais('paisResidencia');
									$("#telefonoCelular").setMask('phone-us');
									$("#telefonoCasa").setMask('phone-us');
							}else{
								mensajeSis("El Socio Indicado No es Menor.");								
								inicializaForma('formaGenerica', 'numero');
								$('#numero').focus();
								$('#numero').select();
							}
						
						
						
				
						
						}else {
							mensajeSis("El Socio No Existe.");
							inicializaForma('formaGenerica', 'numero');
							$('#numero').focus();
							$('#numero').select();
						}
				});
			}
		}
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

	function validaRFC(idControl) {
		var jqRFC = eval("'#" + idControl + "'");
		var numRFC = $(jqRFC).val();
		var tipCon = 4;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numRFC != '' && esTab ) {
			clienteServicio.consultaRFC(tipCon,	numRFC,function(rfc) {
				if (rfc != null) {
					mensajeSis("El cliente: "
							+ rfc.numero
							+ "\ncon RFC : "
							+ rfc.RFCOficial
							+ ", \nya esta registrado en el sistema, \nfavor de utilizar este folio");
					$(jqRFC).focus();
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
							if(numOcupacion != 0){
								mensajeSis("No Existe la Ocupacion.");
								$('#ocupacionID').focus();
							}
						}
					});
		}
	}

	function consultaPromotorI(idControl,alerta) {
		var jqPromotor = eval("'#" + idControl + "'");
		var numPromotor = $(jqPromotor).val();
		var tipConForanea = 2;
		var promotor = {
			'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPromotor != '' && !isNaN(numPromotor) && esTab) {
			promotoresServicio.consulta(tipConForanea,promotor, function(promotor) {
				if (promotor != null) {
					if(promotor.estatus != 'A'){
						mensajeSis("El promotor debe de estar Activo.");
						 $(jqPromotor).val("");
						 $(jqPromotor).focus();
						 $('#nombrePromotorI').val("");
					}else{
						
						parametroBean = consultaParametrosSession();
						if(promotor.sucursalID != parametroBean.sucursal){
							if(alerta == 'S'){
							mensajeSis("El promotor debe de pertenecer a la sucursal: "+parametroBean.nombreSucursal);
							$(jqPromotor).val("");
							 $('#nombrePromotorI').val("");
							 $(jqPromotor).focus();
							}else
								$('#nombrePromotorI').val(promotor.nombrePromotor);
						}else{
							$('#nombrePromotorI').val(promotor.nombrePromotor);
						}
						
					}					
				} else {
					mensajeSis("No Existe el Promotor");
					$('#nombrePromotorI').val('');
					$('#promotorInicial').focus();
					$('#promotorInicial').select();
				}
			});
		}
	}

	function consultaPromotorA(idControl, alerta) {
		var jqPromotor = eval("'#" + idControl + "'");
		var numPromotor = $(jqPromotor).val();
		var tipConForanea = 2;
		var promotor = {
			'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPromotor != '' && !isNaN(numPromotor) && esTab) {
			promotoresServicio.consulta(tipConForanea,promotor, function(promotor) {
				if (promotor != null) {
					if(promotor.estatus != 'A'){
						mensajeSis("El promotor debe de estar Activo");
						 $(jqPromotor).val("");
						 $('#nombrePromotorA').val("");
						 $(jqPromotor).focus();
					}else{
						parametroBean = consultaParametrosSession();
						if(promotor.sucursalID != parametroBean.sucursal){
							if(alerta == 'S'){
							mensajeSis("El promotor debe de pertenecer ala sucursal: "+parametroBean.nombreSucursal);
							 $(jqPromotor).val("");
							 $(jqPromotor).focus();
							 $('#nombrePromotorA').val("");
							}else
								$('#nombrePromotorA').val(promotor.nombrePromotor);
						}else{
							$('#nombrePromotorA').val(promotor.nombrePromotor);
						}
					}
				} else {
					mensajeSis("No Existe el Promotor");
					$('#nombrePromotorA').val('');
					$('#promotorActual').focus();
					$('#promotorActual').select();
				}
			});
		}
	}
	
///////////leo//////////
	
	function consultaNomPromotorI(idControl) {
		var jqPromotor = eval("'#" + idControl + "'");
		var numPromotor = $(jqPromotor).val();
		var tipConForanea = 2;
		var promotor = {
			'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPromotor != '' && !isNaN(numPromotor) && esTab) {
			promotoresServicio.consulta(tipConForanea,promotor, function(promotor) {
				if (promotor != null) {
					$('#nombrePromotorI').val(
							promotor.nombrePromotor);

										
				} else {
					mensajeSis("No Existe el Promotor");
				}
			});
		}
	}
	
	function consultaNomPromotorA(idControl) {
		var jqPromotor = eval("'#" + idControl + "'");
		var numPromotor = $(jqPromotor).val();
		var tipConForanea = 2;
		var promotor = {
			'promotorID' : numPromotor
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPromotor != '' && !isNaN(numPromotor) && esTab) {
			promotoresServicio.consulta(tipConForanea,promotor, function(promotor) {
				if (promotor != null) {
						$('#nombrePromotorA').val(
							promotor.nombrePromotor);
										
				} else {
					mensajeSis("No Existe el Promotor");
				}
			});
		}
	}


	/////leo/////////

	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();
		var conSucursal = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numSucursal != '' && !isNaN(numSucursal) && esTab) {
			sucursalesServicio.consultaSucursal(conSucursal,
					numSucursal, function(sucursal) {
						if (sucursal != null) {
							$('#sucursalO').val(
									sucursal.nombreSucurs);
						} else {
							mensajeSis("No Existe la Sucursal");
						}
					});
		}
	}

	function consultaPais(idControl) {
		var jqPais = eval("'#" + idControl + "'");
		var numPais = $(jqPais).val();
		var conPais = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPais != '' && !isNaN(numPais) && esTab) {
			paisesServicio.consultaPaises(conPais, numPais,
					function(pais) {
						if (pais != null) {
							$('#paisR').val(pais.nombre);
						} else {
							mensajeSis("No Existe el País");
						}
					});
		}
	}
	function consultaPaisNac(idControl) {
		var jqPais = eval("'#" + idControl + "'");
		var numPais = $(jqPais).val();
		var conPais = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numPais != '' && !isNaN(numPais) && esTab) {
			paisesServicio.consultaPaises(conPais, numPais,
					function(pais) {
						if (pais != null) {
							$('#estadoID').attr('readonly',false);
							$('#estadoID').focus();
							$('#paisNac').val(pais.nombre);
							
							if (pais.paisID != 700 && $('#nacion').val()=='E') {
								$('#estadoID').val(0);
								$('#estadoID').attr('readonly',true);
								esTab=true;
								consultaEstado('estadoID');
								$('#paisResidencia').focus();
							}
							 validaNacionalidadCte();
						} else {
							mensajeSis("No Existe el País");
							$(jqPais).val('');
							$('#estadoID').val('');
							$('#nombreEstado').val('');
							$('#paisNac').val('');
							$(jqPais).focus();
						}
					});
		}
	}

	function consultaGEmpres(idControl) {
		var jqGempresa = eval("'#" + idControl + "'");
		var numGempresa = $(jqGempresa).val();
		var conGempresa = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numGempresa != '' && !isNaN(numGempresa) && esTab) {
			gruposEmpServicio.consulta(conGempresa,
					numGempresa, function(empresa) {
						if (empresa != null) {
							$('#descripcionGE').val(empresa.nombreGrupo);
						} else {
							mensajeSis("No Existe el Grupo");
						}
					});
			}
	}

	function consultaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();
		var tipConForanea = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numEstado != '' && !isNaN(numEstado) && esTab) {
			estadosServicio.consulta(tipConForanea,	numEstado, function(estado) {
								if (estado != null) {
									var p = $('#lugarNacimiento').val();
									if (p == 700 && estado.estadoID == 0 && esTab) {
										mensajeSis("No Existe el Estado");
										$('#estadoID').val('');
										$('#estadoID').focus();
									}
									$('#nombreEstado').val(estado.nombre);
								} else {
									mensajeSis("No Existe el Estado");
									$('#estadoID').val('');
									$('#estadoID').focus();
								}
							});
			}
	}

	function validaNacionalidad(idControl) {
		var jqnacion = eval("'#" + idControl + "'");
		var nacion = $(jqnacion).val();
		var conPais = 2;
		var numPais = 700;
		
		setTimeout("$('#cajaLista').hide();", 200);
		if (nacion == 'N' && esTab) {
			paisesServicio.consultaPaises(conPais, numPais,
					function(pais) {
						if (pais != null) {
							
							$('#paisR').val(pais.nombre);
						}
					});
			}
	}

	function consultaTutor(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConPrincipal = 1;	
		setTimeout("$('#cajaLista').hide();", 200);	
		if(numCliente != '' && !isNaN(numCliente) ){
			clienteServicio.consulta(tipConPrincipal,numCliente,function(cliente) {
				if(cliente!=null){
					if(cliente.esMenorEdad !='S'){
						esTab=true;						
						$('#nombreCte').val(cliente.nombreCompleto);
						$('#esSocioSi').attr('checked', 'true');
						$('#esSocioNO').removeAttr('checked');
					}else{
						mensajeSis("El Suscriptor No Debe ser Menor de Edad.");
						$('#clienteID').val("");
						$('#nombreCte').val("");
						$('#clienteID').focus();
						$('#clienteID').select();
					}
					
				}else{
						mensajeSis("El Cliente Especificado No Existe.");
						$('#clienteID').val("");
						$('#nombreCte').val("");
						$('#clienteID').focus();
						$('#clienteID').select();
				}    	 						
			});
		}
		

	}

	
	function consultaCliente(idControl) {
	
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		setTimeout("$('#cajaLista').hide();", 200);

		if (numCliente != '' && !isNaN(numCliente) && esTab) {
			clienteServicio.consulta(1, numCliente, function(cliente) {
				if (cliente != null) {
					$('#numero').val(cliente.numero);
					$('#nombreCliente').val(cliente.nombreCompleto);
					habilitaBoton('actualiza','submit');

				} else {
					mensajeSis("No Existe el Cliente");
					$('#numero').val('');
					$('#nombreCliente').val('');
					deshabilitaBoton('actualiza','submit');
				}
			});
		}
	}

	function consultaSociedad(idControl) {
		var jqSociedad = eval("'#" + idControl + "'");
		var numSociedad = $(jqSociedad).val();

		setTimeout("$('#cajaLista').hide();", 200);
		var SociedadBeanCon = {
			'tipoSociedadID' : numSociedad
		};
		if (numSociedad != '' && !isNaN(numSociedad) && esTab) {
			tipoSociedadServicio.consulta(catTipoConsultaSociedad.foranea, SociedadBeanCon,function(sociedad) {
				if (sociedad != null) {
					$('#descripSociedad').val(sociedad.descripcion);
				} else {
					var tp = $('#tipoPersona').val();
					if (tp == 'M') {
						mensajeSis("No Existe el Tipo de Sociedad");
					}
				}
			});
		}
	}

	function compare_dates(fecha){
      var fechaHoy = parametroBean.fechaSucursal;
      var xMonth=fecha.substring(3, 5);
      var xDay=fecha.substring(0, 2);
      var xYear=fecha.substring(6,10);
      var yMonth=fechaHoy.substring(3, 5);
      var yDay=fechaHoy.substring(0, 2);
      var yYear=fechaHoy.substring(6,10);
      if (xYear> yYear){
			return(true);
		}
      else{
			if (xYear == yYear){ 
				if (xMonth> yMonth){
					return(true);
            }
            else{ 
              if (xMonth == yMonth){
                if (xDay> yDay)
                  return(true);
                else
                  return(false);
              }
              else
              	return(false);
            }
          }
          else
				return(false);
		}
	}
	
	
	function mayor(fecha, fecha2){ // valida si fecha > fecha2: true else false
		//0|1|2|3|4|5|6|7|8|9|
		//2 0 1 2 / 1 1 / 2 0
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


	/*funcion valida fecha formato (yyyy-MM-dd)*/
	function esFechaValida(fecha){

		if (fecha != undefined && fecha.value != "" ){
			var objRegExp = /^\d{4}\-\d{2}\-\d{2}$/;
			if (!objRegExp.test(fecha)){
				mensajeSis("formato de fecha no válido (aaaa-mm-dd)");
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
				mensajeSis("Fecha introducida errónea.");
			return false;
			}
			if (dia>numDias || dia==0){
				mensajeSis("Fecha introducida errónea.");
				return false;
			}
			return true;
		}
	}


	function comprobarSiBisisesto(anio){
		if ( ( anio % 100 != 0) && ((anio % 4 == 0) || (anio % 400 == 0))) {
			return true;
		}
		else {
			return false;
		}
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
	
	
});//	FIN VALIDACIONES DE REPORTES
var  band = 0;

function formaCURP() {
	var sexo = $('#sexo').val();
	var nacionalidad = $('#nacion').val();
	if(sexo == "M")
	{sexo = "H";}
	else if(sexo == "F")
	{sexo = "M";}
	else{
		sexo = "H";
		mensajeSis("no se asigno sexo");
	}
	
	if(nacionalidad == "N")
	{nacionalidad = "N";}
	else if(nacionalidad == "E")
	{nacionalidad = "S";}
	else{
		nacionalidad = "N";
		mensajeSis("no se asigno nacionalidad");
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
			$('#CURP').val(cliente.CURP);
		}
	});
}

function validaCURP(idControl) {
	var jqCURP = eval("'#" + idControl + "'");
	var numCURP = $(jqCURP).val();
	var tipCon = 11;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numCURP != '' && esTab ) {
		clienteServicio.consultaCURP(tipCon, numCURP,function(curp) {
			if (curp != null) {
				mensajeSis("El cliente: "
						+ curp.numero
						+ "\ncon CURP : "
						+ curp.CURP
						+ ", \nya esta registrado en el sistema, \nfavor de utilizar este folio");
				$(jqCURP).focus();
			}
		});
	}
}

function validaCheck() {
		var Xfecha= $('#fechaNacimiento').val();
		var xAnio = Xfecha.substring(0,4);
		var xMes = Xfecha.substring(5,7);
		var xDia = Xfecha.substring(8,10);
		
		
		if ($('#esSocioSi').is(':checked') == true){
			if ($('#clienteID').val() == '') {
			mensajeSis("Especifique el Cliente Suscriptor.");
			$('#clienteID').focus();
			return false;
		}
	}else if ($('#esSocioNO').is(':checked') == true){
		if ($('#nombreTutor').val() == '') {
			mensajeSis("Especifique el Nombre del Suscriptor.");
			$('#nombreTutor').focus();
			return false;
		}
	}
	if($('#parentescoID').val()=='' || $('#parentescoID').val()==0 ){
		mensajeSis("Especifique el Parentesco.");
		$('#parentescoID').focus();
		return false;
	}
	

	
}
function validaTutor(val) {
	if (val=='S'){
		$('#Socio').show();
		$('#Tutor').hide();
		$('#clienteID').val('');
		$('#nombreTutor').val('');	
		$('#parentescoID').val('');
		$('#tipoParentesco').val('');
	}
	else if (val == 'N') {	
		$('#Socio').hide(); 
		$('#Tutor').show();
		$('#clienteID').val('');
		$('#nombreCte').val('');		
		$('#parentescoID').val('');
		$('#tipoParentesco').val('');
	}	
}

	function consultaParentesco(idControl,dato) {
		var numParentesco = dato;
		if(dato == ''){
			var jqParentesco = eval("'#" + idControl + "'");
			numParentesco = $(jqParentesco).val();
		}	
		var tipConRelaciones=3;
		setTimeout("$('#cajaLista').hide();", 200);
		var ParentescoBean = {
				'parentescoID' : numParentesco
		};
		if(numParentesco != '' && !isNaN(numParentesco)){
			
			parentescosServicio.consultaParentesco(tipConRelaciones, ParentescoBean, function(parentesco) {
				
						if(parentesco!=null){
							$('#tipoParentesco').val(parentesco.descripcion);
						}else{
							mensajeSis("No Existe el Parentesco");
							if(dato == ''){
								$(jqParentesco).focus().select();
							}
						}
				});
			}
		}
	

	
	//devuelve el nombre del Promotor de captacion 
	function consultaNombreCaptacion(idControl){	
		
		var tipoConsulta  = 6;
		var jqPromotor  = eval("'#" + idControl + "'");
		var numPromotor = $(jqPromotor).val();	

		if($('#ejecutivoCap').val()!='0'&& $('#ejecutivoCap').val()!=''){
			
		setTimeout("$('#cajaLista').hide();", 200);
		if(numPromotor != '' && !isNaN(numPromotor) && esTab){
			var promotorBeanCon = { 
				'promotorID'	: numPromotor,
				'sucursalID'	: parametroBean.sucursal
			};	
			promotoresServicio.consulta(tipoConsulta, promotorBeanCon ,function(promotor){ 
			
				if(promotor!=null){		
					if(promotor.varSucursalID == parametroBean.sucursal){
						$('#nomEjecutivoCap').val(promotor.nombrePromotor);
					}else if(promotor.varSucursalID != parametroBean.sucursal){
						mensajeSis('El Ejecutivo de Captación Indicado no Pertenece a esta Sucursal');
						$('#ejecutivoCap').focus();
						$('#ejecutivoCap').val('');
						$('#nomEjecutivoCap').val('');
					}
				}
				else{
					mensajeSis("El Ejecutivo de Captación Indicado no Existe");
					$('#ejecutivoCap').focus();
					$('#ejecutivoCap').val('');
					$('#nomEjecutivoCap').val('');
				}
			});
		}
	}
		else {
			$('#ejecutivoCap').val('');
			$('#nomEjecutivoCap').val('');
		}

	}

	//devuelve el nombre del Promotor de esterno de inversion
	function consultaNomProExterno(idControl){	
		
		var tipoConsulta  = 7;
		var jqPromotor  = eval("'#" + idControl + "'");
		var numPromotor = $(jqPromotor).val();	

		var promotorBeanCon = { 
				'numero'	:numPromotor
		};		
		
		if($('#promotorExtInv').val()!='0'&& $('#promotorExtInv').val()!=''){
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numPromotor != '' && !isNaN(numPromotor)){
		
			promotoresServicio.consulta(tipoConsulta, promotorBeanCon ,function(promotor){ 
				
				if(promotor!=null){				
					if(promotor.varEstatus == 'A'){
						$('#nomPromotorExtInv').val(promotor.nombre);
						}else if(promotor.varEstatus == 'C'){ 
							mensajeSis('El Promotor Externo Indicado no se Encuentra Activo');
						}
				
				}
				else{
					mensajeSis("El Promotor Externo Indicado no Existe");
					$('#promotorExtInv').focus();
					$('#promotorExtInv').val('');
					$('#nomPromotorExtInv').val('');
				}
			});
		}
		}
		else {
			$('#promotorExtInv').val('');
			$('#nomPromotorExtInv').val('');
		}
	}

	
	// funcion para validar para ocultar  o habilitar  campo en caso de ser requerido

	function consultaPromotorActiva(idControl) {	
		var tipoConsulta = 1;
		var tipoCon = 8;
		var parametroBean = { 
			'empresaID'		: 1
		};		
		
		var promotor = {
			'tipoPromotorID' : ''
		};

		parametrosSisServicio.consulta(tipoConsulta, parametroBean, function(parametroBean) {
		
					if (parametroBean.activaPromotorCapta == 'S'){
						
						
						promotoresServicio.consulta(tipoCon, promotor, function(promotor) {
							
							if (promotor != null){
								if (promotor.aplicaPromotor == '1'){
									$('#promotorcap').show();
									$('#muestraEjec').val(1);
									
								}else{
									$('#promotorcap').hide();
									$('#promotorExtInv').val(0);
									$('#ejecutivoCap').val(0);
								}

							
							}
					});
					
					}
					else{
						$('#promotorcap').hide();
						$('#promotorExtInv').val(0);
						$('#ejecutivoCap').val(0);
					}
					
					
			});

			}
	
	//validar mayor de edad
	
	function mayorEdad(fecha, fecha2){ // valida si fecha > fecha2: true else false
		//0|1|2|3|4|5|6|7|8|9|
		//2 0 1 2 / 1 1 / 2 0
		var xMes=fecha.substring(5, 7);
		var xDia=fecha.substring(8, 10);
		var xAnio=fecha.substring(0,4);

		var yMes=fecha2.substring(5, 7);
		var yDia=fecha2.substring(8, 10);
		var yAnio=fecha2.substring(0,4);
 
		var yAnioM = yAnio - xAnio;


		if (yAnioM > 18){
			return true;
		}else{
			if(yAnioM == 18){
				if (xMes < yMes){
					return true;
				}else{
					if (xMes == yMes){
						if (xDia < yDia){
							return true;
						}else{
							return true;
						}
					}else{
						return false;
					}
				}					
			}else{
				return false;
			}
		}
		 
	} 	
	
	function exitoTransMenor(){
		inicializaForma('formaGenerica', 'numero');
		deshabilitaBoton('modifica', 'submit');
		deshabilitaBoton('agrega', 'submit');
		$('#sexo').val('');
		$('#nacion').val('');
	}