$(document).ready(function() {
	$('#avalID').focus();
	
	esTab = true;

	//Definicion de Constantes y Enums  
	var catTipoTransaccionAvales = {
  		'agrega':'1',
  		'modifica':'2', 
	}; 
	
	var catTipoConsultaAvales = {
  		'principal':1,
  		'foranea':2
	};	

	 //------------ Metodos y Manejo de Eventos -----------------------------------------
	
		deshabilitaBoton('modifica', 'submit'); 
		deshabilitaBoton('agrega', 'submit');
		agregaFormatoControles('formaGenerica');

		//Validacion para mostrarar boton de calcular  RFC
		permiteCalcularCURPyRFC('','generar',2);

		$(':text').focus(function() {	
		 	esTab = false;
		});
	
		$.validator.setDefaults({
	      submitHandler: function(event) {	    
	      	grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','avalID','exito','fallo');
	      }
		});		
	     
		$(':text').bind('keydown',function(e){
			if (e.which == 9 && !e.shiftKey){
				esTab= true;
			}
		});
	
		$('#fechaEsc').change(function() {
			var Xfecha= $('#fechaEsc').val(); 
			var Yfecha=  parametroBean.fechaSucursal;
			if(esFechaValida(Xfecha)){
				if(Xfecha=='')$('#fechaEsc').val(parametroBean.fechaSucursal);

				if ( mayor(Xfecha, Yfecha) )
				{
					mensajeSis("La Fecha capturada es mayor a la del Sistema")	;
					$('#fechaEsc').val(parametroBean.fechaSucursal);
				}else{
					$('#fechaEsc').focus();	
				}
			}else{
				$('#fechaEsc').val(parametroBean.fechaSucursal);
			}

		});
	
		$('#fechaRegPub').change(function() {
			var Xfecha= $('#fechaRegPub').val(); 
			var Yfecha=  parametroBean.fechaSucursal;
			if(esFechaValida(Xfecha)){
				if(Xfecha=='')$('#fechaRegPub').val(parametroBean.fechaSucursal);

				if ( mayor(Xfecha, Yfecha) )
				{
					mensajeSis("La Fecha capturada es mayor a la del Sistema")	;
					$('#fechaRegPub').val(parametroBean.fechaSucursal);
				}else{
					$('#fechaRegPub').focus();	
				}
			}else{
				$('#fechaRegPub').val(parametroBean.fechaSucursal);
			}

		});		
	
		$('#agrega').click(function() {		
			$('#tipoTransaccion').val(catTipoTransaccionAvales.agrega);	
		});
		
		$('#modifica').click(function() {		
	
			$('#tipoTransaccion').val(catTipoTransaccionAvales.modifica);			
		});	
	
		
		$('#avalID').blur(function() {
			esTab=true;
			validaAval(this.id);
		});

						
		$('#avalID').bind('keyup',function(e) {
			if (this.value.length >= 2) {
				var camposLista = new Array();
				var parametrosLista = new Array();
				camposLista[0] = "nombreCompleto";
				parametrosLista[0] = $('#avalID').val();
				lista('avalID', '1', '1', camposLista, parametrosLista, 'listaAvales.htm');
			}
		});

		$('#nacion').change(function() {
			validaNacionalidad();
		});

		$('#lugarNacimiento').bind('keyup',function(e) { 
			lista('lugarNacimiento', '1', '1', 'nombre', $('#lugarNacimiento').val(),'listaPaises.htm');
		});

		$('#lugarNacimiento').blur(function() {
			consultaPaisNac(this.id);
		});
		
		$('#estadoID').bind('keyup',function(e){
			lista('estadoID', '2', '1', 'nombre', $('#estadoID').val(), 'listaEstados.htm');
		});
		
		$('#estadoID').blur(function() {
			esTab=true;
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
			esTab=true;
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
			camposLista[2] = "localidadID";
			camposLista[3] = "asentamiento";
			
			
			parametrosLista[0] = $('#estadoID').val();
			parametrosLista[1] = $('#municipioID').val();
			parametrosLista[2] = $('#localidadID').val();
			parametrosLista[3] = $('#coloniaID').val();
			
			lista('coloniaID', '2', '1', camposLista, parametrosLista,'listaColonias.htm');
		
		});
		
		$('#coloniaID').blur(function() {
			consultaColonia(this.id);
		});
		

		// Estado Escritura Publica
		$('#estadoIDEsc').bind('keyup',function(e){
			lista('estadoIDEsc', '2', '1', 'nombre', $('#estadoIDEsc').val(), 'listaEstados.htm');
		});
		
		$('#estadoIDEsc').blur(function() {
			esTab=true;
	  		consultaEstadoEP(this.id);
		});
		
		// Municipio Escritura Publica
		$('#localidadEsc').bind('keyup',function(e){
			var camposLista = new Array();
			var parametrosLista = new Array();
				camposLista[0] = "estadoID";
				camposLista[1] = "nombre";
				parametrosLista[0] = $('#estadoIDEsc').val();
				parametrosLista[1] = $('#localidadEsc').val();
					lista('localidadEsc', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
	    });
	
		$('#localidadEsc').blur(function() {
			esTab=true;
	  		consultaMunicipioEP(this.id);
		});
		

		//Estado Registro Publico

		$('#estadoIDReg').bind('keyup',function(e){
			lista('estadoIDReg', '2', '1', 'nombre', $('#estadoIDReg').val(), 'listaEstados.htm');
		});
		
		$('#estadoIDReg').blur(function() {
	  		consultaEstadoRP(this.id);
		});


		// Municipio Registro Public

		$('#localidadRegPub').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		
		camposLista[0] = "estadoID";
		camposLista[1] = "nombre";
		
		
		parametrosLista[0] = $('#estadoIDReg').val();
		parametrosLista[1] = $('#localidadRegPub').val();
		
		lista('localidadRegPub', '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
		});
		
		$('#localidadRegPub').blur(function() {
	  		consultaMunicipioRP(this.id);
		});

			
		$('#notaria').bind('keyup',function(e){ 
			//TODO Agregar Libreria de Constantes Tipo Enum
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "estadoID";
			camposLista[1] = "municipioID";
			camposLista[2] = "titular"; 
			
			parametrosLista[0] = $('#estadoIDEsc').val();
			parametrosLista[1] = $('#localidadEsc').val();
			parametrosLista[2] = $('#notaria').val();
			
			if($('#estadoIDEsc').val() != '' && $('#estadoIDEsc').asNumber() > 0 ){
				if($('#localidadEsc').val()!='' && $('#localidadEsc').asNumber()>0){
					lista('notaria', '1', '1', camposLista, parametrosLista, 'listaNotarias.htm');
				}else{
					if($('#notaria').val().length >= 3){
						$('#localidadEsc').focus();
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
		 
		$('#notaria').blur(function() {
			setTimeout("$('#cajaLista').hide();", 200);
			if($('#notaria').val() 	!= 	'' &&	$('#notaria').val() > 0	&&	!isNaN($('#notaria').val())){
				if($('#estadoIDEsc').val()!=''  ){
					if($('#localidadEsc').val() !=''){
						consultaNotaria(this.id);
					}else{
						$('#nomNotario').val('');
						$('#notaria').val('');
						mensajeSis("Elija una Localidad  antes de buscar Notaria");
					}
				}else{
					$('#nomNotario').val('');
					$('#notaria').val('');
					mensajeSis("Elija una Entidad Federativa  antes de buscar Notaria");
				}
			}else{
				$('#nomNotario').val('');
				$('#notaria').val('');
			}

		});

	 	$('#RFC').blur(function() {
			if($('#tipoPersona').is(':checked')){  
				validaRFC('RFC');
			}else{
				if($('#tipoPersona3').is(':checked')){  
					validaRFC('RFC');
				}
			}
		});
		
		$('#RFCpm').blur(function() {
			if($('#tipoPersona2').is(':checked')){  
				validaRFC('RFCpm');
			}
		});


	$('#generar').click(function() {
		if ($('#fechaNac').val()!=''){
			$('#RFC').val('');
			//Estableciendo el bloqueo de pantalla mientras se genera el RFC
			$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');   
			$('#contenedorForma').block({
				message: $('#mensaje'),
				css: {border:		'none',
					background:	'none'}
			});
			formaRFC();
			$('#RFC').focus();
			$('#RFC').select();
		}else{
			mensajeSis('Se necesita la Fecha de Nacimiento para esta Opción.');
		}
	});
	
	$('#tipoPersona').click(function() {		 
		$('#lblRFCpm').hide();
		$('#rFCpm').hide();
		$('#rFCpm').val('');
		$('#personaMoral').hide(500);
		$('#esc_Tipo').val('');
		$('#escrituraPub').val('');
		$('#libroEscritura').val('');
		$('#volumenEsc').val('');
		$('#fechaEsc').val('');
		$('#estadoIDEsc').val('');
		$('#nombreEstadoEsc').val('');
		$('#localidadEsc').val('');
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
		$('#nombreEstadoReg').val('');
		$('#localidadRegPub').val('');
		$('#nombreMuniReg').val('');
	});
	
	$('#tipoPersona2').click(function() {		 
		$('#lblRFCpm').show();
		$('#rFCpm').show();
		$('#rFCpm').val('');
		$('#personaMoral').show(500);
		$('#esc_Tipo').val('');
		$('#escrituraPub').val('');
		$('#libroEscritura').val('');
		$('#volumenEsc').val('');
		$('#fechaEsc').val('');
		$('#estadoIDEsc').val('');
		$('#nombreEstadoEsc').val('');
		$('#localidadEsc').val('');
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
		$('#nombreEstadoReg').val('');
		$('#localidadRegPub').val('');
		$('#nombreMuniReg').val('');

	});
	
	$('#tipoPersona3').click(function() {		 
		$('#lblRFCpm').hide();
		$('#rFCpm').hide();
		$('#rFCpm').val('');
		$('#personaMoral').hide(500);
		$('#esc_Tipo').val('');
		$('#escrituraPub').val('');
		$('#libroEscritura').val('');
		$('#volumenEsc').val('');
		$('#fechaEsc').val('');
		$('#estadoIDEsc').val('');
		$('#nombreEstadoEsc').val('');
		$('#localidadEsc').val('');
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
		$('#nombreEstadoReg').val('');
		$('#localidadRegPub').val('');
		$('#nombreMuniReg').val('');
	});
	
	$('#fechaNac').change(function() {
		$('#RFC').val('');
		$('#RFC').focus();
		$('#rFCpm').val('');
	});
	
	$('#telefono').setMask('phone-us');
	$('#telefonoCel').setMask('phone-us');
	
	$('#telefono').blur(function(){
		if($('#telefono').val()==''){
			$('#extTelefonoPart').val('');
		}
	});
	
	$("#extTelefonoPart").blur(function(){
		if(this.value != ''){
			if($("#telefono").val() == ''){
				this.value = '';
				mensajeSis("El Número de Teléfono está Vacío.");
				$("#telefono").focus();
			}
		}				
	});
	

	$('#esc_Tipo').blur(function() {	 
		var tipActa = $('#esc_Tipo').val();
		if(tipActa == 'P'){
		$('#apoderados').show(500);
		$('#nomApoderado').val('');
		$('#RFC_Apoderado').val('');
		}else{
		$('#apoderados').hide(500);
		$('#nomApoderado').val('');
		$('#RFC_Apoderado').val('');
		
		}
	});

	$('#ocupacionID').bind('keyup',function(e) { 
		lista('ocupacionID', '1', '1', 'descripcion', $('#ocupacionID').val(), 'listaOcupaciones.htm');
	});
	

	$('#ocupacionID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if($('#tipoPersona').attr('checked') == true || $('#tipoPersona3').attr('checked') == true){
			consultaOcupacion(this.id);
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

	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({

		rules: {
						
			primerNombre: { 
				required: true
			},	
			
			apellidoPaterno: { 
				required: true
			},
			
			tipoPersona: { 
				required: true
			},	
			
			razonSocial : {
				required : function() {return $('#tipoPersona2:checked').val() == 'M' || $('#tipoPersona3:checked').val() == 'A';}
			},
			
			rFC	: {
				required	: true,
				maxlength	: 13
			},
			
			calle: { 
				required: true
			},
			
			numExterior: { 
				required: true
			},
			
			municipioID: { 
				required: true
			},
			
			estadoID: { 
				required: true
			},
			CP: { 
				required: true
			},	
			fechaNac: {
				 required: true,
				 date: true
			},
			rFCpm : {
					required : function() {return $('#tipoPersona2:checked').val() == 'M' ;}
			},
			coloniaID: { 
				required: true
			},
			localidadID: { 
				required: true
			},
			extTelefonoPart: {
				number: true
			},
			// Validaciones Escritura Publica si el Aval es Persona Moral	
			escrituraPub		: 	{
				required		: function() {return $('#tipoPersona2:checked').val() == 'M' ;}
			},

			fechaEsc		: 	{
				required		: function() {return $('#tipoPersona2:checked').val() == 'M' ;}
			},
			
			estadoIDEsc		: 	{
				required		: function() {return $('#tipoPersona2:checked').val() == 'M' ;}
			},
			
			localidadEsc		: 	{
				required		: function() {return $('#tipoPersona2:checked').val() == 'M' ;}
			},
			
			notaria		: 	{
				required		: function() {return $('#tipoPersona2:checked').val() == 'M' ;}
			},			

			//Registro Publico
			
			registroPub		: 	{
				required		: function() {return $('#tipoPersona2:checked').val() == 'M' ;}
			},
			
			folioRegPub		: 	{
				required		: function() {return $('#tipoPersona2:checked').val() == 'M' ;}
			},

			estadoIDReg		: 	{
				required		: function() {return $('#tipoPersona2:checked').val() == 'M' ;}
			},
			
			localidadRegPub		: 	{
				required		: function() {return $('#tipoPersona2:checked').val() == 'M' ;}
			},
	
			lugarNacimiento 	: {required : function() {return $('#tipoPersona').is(':checked');}	
			},
	
			nacion 	: {required : true
			},
			
			ocupacionID: {
				required: function() { return $('#tipoPersona').is(':checked') || $('#tipoPersona3').is(':checked'); }
			},
			telefonoTrabajo: {
				digits: true
			},
			extTelTrabajo: {
				digits: true
			},
			numIdentific:{				
				maxlength:18 	
			},
			fecExIden: {
				date : true
			},

			fecVenIden: {
				date : true
			}
		},
		
		messages: {

			primerNombre: {
				required: 'Especificar Nombre'
			},
			
			apellidoPaterno: {
				required: 'Especificar Apellido'
			},
			
			tipoPersona: {
				required: 'Especificar Tipo de Persona'
			},
			
			razonSocial : {
				required : 'Especificar Razon Social'
			},
			
			rFC	: {
				required		: 'Especifique RFC.',
				maxlength	: 'Máximo 13 caracteres.'
			}	,
			
			calle: {
				required: 'Especificar Calle'
			},
			
			numExterior: { 
				required: 'Especificar Numero'
			},
			
			municipioID: { 
				required: 'Especificar Municipio'
			},
			
			estadoID: { 
				required: 'Especificar Estado'
			},
			
			cP: { 
				required: 'Especificar Codigo Postal'
			},			
			
			fechaNac: {
				 required:'Especifique Fecha de Nacimiento..' ,
				 date: 'Fecha Incorrecta'
			},
			rFCpm: {
					required: 'Especificar RFC '
			},
			coloniaID: { 
				required: 'Especificar Colonia'
			},
			localidadID: { 
				required: 'Especificar Localidad'
			},
			extTelefonoPart:{
				number: 'Sólo Números(Campo opcional)'
			},
				//estas son validaciones de escritura publica si y solo si es apoderado
				
			escrituraPub		: 	{
				required		: function (){
					var mensaje = 'Especifique el Número de la Escritura Pública.';
					return mensaje;}
			},				
			fechaEsc		: 	{
				required		: function (){
					var mensaje = 'Especifique la Fecha de la Escritura Pública.';
					return mensaje;}
			},
			estadoIDEsc		:	{
				required		: function (){
					var mensaje = 'Especifique el Estado de la Escritura Pública.';
					return mensaje;
			}
			},			
			localidadEsc		:	{
				required		: function (){
					var mensaje = 'Especifique el Municipio de la Escritura Pública.';
					return mensaje;}
			},
			notaria		:	{
				required		: function (){
					var mensaje = 'Especifique el Número de Notaría de la Escritura Pública.';
					return mensaje;}
			},
			registroPub	:	{
				required		: function (){
					var mensaje = 'Especifique el Número de Registro Público.';
					return mensaje;}
			},
			folioRegPub	:	{
				required		: function (){
					var mensaje = 'Especifique el Folio de Registro Público.';
					return mensaje;}
			},
			estadoIDReg	:	{
				required		: function (){
					var mensaje = 'Especifique el Estado del Registro Público.';
					return mensaje;}
			},
			localidadRegPub	:	{
				required		: function (){
					var mensaje = 'Especifique el Municipio del Registro Público.';
					return mensaje;}
			},
			
			lugarNacimiento : {
				required : 'Especifique Lugar de Nacimiento.'
			},
			
			nacion : {
				required : 'Especifique Nacionalidad.'
			},
			
			ocupacionID: {
				required: 'Especifique ocupación'
			},
			telefonoTrabajo: {
				digits: 'Especifique teléfono válido'
			},
			extTelTrabajo: {
				digits: 'Especifique extensión válida'
			},
			numIdentific:{
				maxlength:jQuery.format("Se Requieren Máximo 18 Caracteres"),
			  } , 

		  fecExIden: {
			  date : 'Fecha Incorrecta'
		  },

		  fecVenIden: {
			  date : 'Fecha Incorrecta'
		  }
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------
	
	//------------ Funcion Valida Aval-----------------------------------
	
	  	function validaAval(idControl) {
	  		var jqAval = eval("'#" + idControl + "'");
	  		var numAval = $(jqAval).val();
	  		setTimeout("$('#cajaLista').hide();", 200);
		
	  			if(numAval != '' && !isNaN(numAval) && esTab){
	  				if(numAval == '0'){	
	  					habilitaBoton('agrega', 'submit');		
	  					deshabilitaBoton('modifica', 'submit');
	  					inicializaForma('formaGenerica','avalID');
	  					$('#tipoPersona').attr("checked","1");
						$('#tipoPersona2').attr("checked",false);
						$('#tipoPersona3').attr("checked",false);
						$('#estadoCivil').val('S');
						$('#sexo').val('M');
	  				} 
	  				else {
	  					deshabilitaBoton('agrega', 'submit');
	  					habilitaBoton('modifica', 'submit');
	  					
	  					var avalBeanCon ={
			 		 	'avalID' : numAval 
	  					};	
	  					
	  					avalesServicio.consulta(catTipoConsultaAvales.principal,avalBeanCon,function(avales) {
	  						if(avales!=null){
		  							if(evaluaEdad(avales.fechaNac)){		  							
			  							dwr.util.setValues(avales);
			  							esTab= true;
			  							avales;
										consultaPaisNac('lugarNacimiento');
			  							consultaEstado('estadoID'); 
			  							consultaMunicipio('municipioID');
			  							consultaLocalidad('localidadID');	
			  							consultaColonias('coloniaID');  									  							
			  							$('#sexo').val(avales.sexo);
			  							$('#estadoCivil').val(avales.estadoCivil);
										$('#numIdentific').val(avales.numIdentific);
	
										if(avales.fecExIden != '1900-01-01'){
											$('#fecExIden').val(avales.fecExIden);
										}
										else{
											$('#fecExIden').val("");
										}
										
										if(avales.fecVenIden != "1900-01-01"){
											$('#fecVenIden').val(avales.fecVenIden);
	
										}else{
											$('#fecVenIden').val("");
	
										}
										
			  								if (avales.tipoPersona == 'F') {
			  									$('#tipoPersona').attr("checked","1");
			  									$('#tipoPersona2').attr("checked",false);
			  									$('#tipoPersona3').attr("checked",false);
			  									$('#lblRFCpm').hide();
			  									$('#rFCpm').hide();
			  									$('#personaMoral').hide(500);
		 
			  								} 
			  								else {
			  									if (avales.tipoPersona == 'A') {
			  										$('#tipoPersona3').attr("checked","1");
			  										$('#tipoPersona2').attr("checked",false);
			  										$('#tipoPersona').attr("checked",false);
			  										$('#lblRFCpm').hide();
			  										$('#rFCpm').hide();
			  										$('#personaMoral').hide(500);
			  									}
			  									if (avales.tipoPersona == 'M'){
			  										
			  										$('#tipoPersona2').attr("checked","1");
			  										$('#tipoPersona').attr("checked",false);
			  										$('#tipoPersona3').attr("checked",false);
			  										$('#lblRFCpm').show();
			  										$('#rFCpm').show();
			  										$('#personaMoral').show(500);
			  										consultaEstadoEP('estadoIDEsc');	
						  							consultaMunicipioEP('localidadEsc');
						  							consultaEstadoRP('estadoIDReg');	 
						  							consultaMunicipioRP('localidadRegPub');					  							
						  							
			  									}
			  								}
			  								$('#telefono').setMask('phone-us');	
			  								$('#telefonoCel').setMask('phone-us');
		  							}else{
		  								
		  								mensajeSis("El Aval es Menor de Edad.");	
		  								deshabilitaBoton('modifica', 'submit');
			  							deshabilitaBoton('agrega', 'submit');
			  							limpiarCampos();
										$('#avalID').focus();
										$('#avalID').val('');	
		  							}
	  						}
	  						else{ 
	  							mensajeSis("No Existe el Aval");
	  							deshabilitaBoton('modifica', 'submit');
	  							deshabilitaBoton('agrega', 'submit');
	  							limpiarCampos();
								$('#avalID').focus();
								$('#avalID').val('');	  							
							}
	  					});		
	  			}
												
	  			}
	  	} 
	  	
	
	  //------------ Funcion Consulta Estado-------------------------------------
	  	
	function consultaEstado(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numEstado != '' && !isNaN(numEstado) && esTab
				){
			estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
						if(estado!=null){		
							esTab=true;
							$('#nombreEstado').val(estado.nombre);
																	
						}else{
							mensajeSis("No Existe el Estado");
							$('#estadoID').focus();
							$('#estadoID').val("");
						}    	 						
				});
			}
		}	
	
	//------------ Funcion Consulta Municipio-----------------------------------
		function consultaMunicipio(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();	
		var numEstado =  $('#estadoID').val();				
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numMunicipio != '' && !isNaN(numMunicipio)  && esTab
				){
			municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
						if(municipio!=null){							
							$('#nombreMuni').val(municipio.nombre);																	
						}else{
							mensajeSis("No Existe el Municipio");
								$('#municipioID').focus();
								$('#municipioID').val("");
						}    	 						
				});
			}
		}	
	
	// Funcion para consultar Estado(Escritura Publica)
	function consultaEstadoEP(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numEstado != '' && !isNaN(numEstado) && esTab
				){
			estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
						if(estado!=null){		
							esTab=true;
							$('#nombreEstadoEsc').val(estado.nombre);
																	
						}else{
							mensajeSis("No Existe el Estado");
							$('#estadoIDEsc').focus();
							$('#estadoIDEsc').val("");
						}    	 						
				});
			}
		}	

	//Funcion para consultar Municipio(Escritura Publica)
		function consultaMunicipioEP(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();	
		var numEstado =  $('#estadoIDEsc').val();				
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numMunicipio != '' && !isNaN(numMunicipio)  && esTab
				){
			municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
						if(municipio!=null){							
							$('#nombreMuniEsc').val(municipio.nombre);
																	
						}else{
							mensajeSis("No Existe el Municipio");
								$('#localidadEsc').focus();
								$('#localidadEsc').val("");
						}    	 						
				});
			}
		}	


	// Funcion para consultar Estado(Registro Publico)
	function consultaEstadoRP(idControl) {
		var jqEstado = eval("'#" + idControl + "'");
		var numEstado = $(jqEstado).val();	
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numEstado != '' && !isNaN(numEstado) && esTab
				){
			estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
						if(estado!=null){		
							esTab=true;
							$('#nombreEstadoReg').val(estado.nombre);
																	
						}else{
							mensajeSis("No Existe el Estado");
							$('#estadoIDReg').focus();
							$('#estadoIDReg').val("");
						}    	 						
				});
			}
		}	
	//Funcion para consultar Municipio(Registro Publico)
		function consultaMunicipioRP(idControl) {
		var jqMunicipio = eval("'#" + idControl + "'");
		var numMunicipio = $(jqMunicipio).val();	
		var numEstado =  $('#estadoIDReg').val();				
		var tipConForanea = 2;	
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numMunicipio != '' && !isNaN(numMunicipio)  && esTab
				){
			municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
						if(municipio!=null){							
							$('#nombreMuniReg').val(municipio.nombre);
																	
						}else{
							mensajeSis("No Existe el Municipio");
								$('#localidadRegPub').focus();
								$('#localidadRegPub').val("");
						}    	 						
				});
			}
		}	
		  
	//Funcion que consulta las notarias
	function consultaNotaria(idControl) { 
				var jqNotaria = eval("'#" + idControl + "'");
				var numNotaria = $(jqNotaria).val();	
				
				var notariaBeanCon = {
		  				'estadoID':$('#estadoIDEsc').val(),
		  				'municipioID':$('#localidadEsc').val(),
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
										mensajeSis("No Existe La Notaria");
											$('#notaria').focus();
											$('#notaria').select();	
											$('#notaria').val("");
											$('#direcNotaria').val("");
											$('#nomNotario').val("");
									}
							});
				}
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
	

		//------------ Funcion Valida RFC-----------------------------------
      function validaRFC(idControl) {
		var jqRFC = eval("'#" + idControl + "'");
		var numRFC = $(jqRFC).val();
		var tipCon = 4;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numRFC != '' && esTab) {
			clienteServicio.consultaRFC(tipCon,	numRFC,function(rfc) {
				if (rfc != null) {
						mensajeSis('El RFC ' + rfc.RFCOficial
								+ ' está registrado con el ' + $('#alertSocio').val()
								+ ' ' + rfc.numero + ', favor de utilizar la pantalla de Asignación aval.');
						$(jqRFC).focus();
				}
			});
		}
	}

/////////////////////funcion formar RFC//////////////////////////////

	function formaRFC() {
		var pn = $('#primerNombre').val();
		var sn = $('#segundoNombre').val();
		var nc = pn + ' ' + sn;

		var rfcBean = {
			'primerNombre' : nc,
			'apellidoPaterno' : $('#apellidoPaterno').val(),
			'apellidoMaterno' : $('#apellidoMaterno').val(),
			'fechaNacimiento' : $('#fechaNac').val()
		};
		clienteServicio.formaRFC(rfcBean, function(cliente) {
			if (cliente != null) {
				$('#RFC').val(cliente.RFC);
			}
			$("#contenedorForma").unblock();
		});
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


});	// fin document ready

// deshabilta controles 
function deshabilitaControler(){
	soloLecturaControl('calle');
	soloLecturaControl('numExterior');
	soloLecturaControl('numInterior');
	soloLecturaControl('manzana');
	soloLecturaControl('lote');
	soloLecturaControl('colonia');
	soloLecturaControl('estadoID');	
	soloLecturaControl('localidadID');	
	soloLecturaControl('coloniaID');
	soloLecturaControl('municipioID');
	soloLecturaControl('CP');
	soloLecturaControl('latitud');
	soloLecturaControl('longitud');
};

// habilita controles
function habilitaControler(){
	habilitaControl('calle');
	habilitaControl('numExterior');
	habilitaControl('numInterior');
	habilitaControl('manzana');
	habilitaControl('lote');
	habilitaControl('estadoID');	
	habilitaControl('localidadID');	
	habilitaControl('coloniaID');
	habilitaControl('municipioID');
	habilitaControl('CP');
	habilitaControl('latitud');
	habilitaControl('longitud');
};

//consulta colonias y CP
function consultaColonia(idControl) {
	var jqColonia = eval("'#" + idControl + "'");
	var numColonia= $(jqColonia).val();		
	var numEstado =  $('#estadoID').val();	
	var numMunicipio =	$('#municipioID').val();
	var tipConPrincipal = 1;	
	setTimeout("$('#cajaLista').hide();", 200);	
	if(numEstado==''){		 return;}
	if(numMunicipio==''){	  return;}
	
	
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numColonia != '' && !isNaN(numColonia) && esTab){
		coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,function(colonia) {
			if(colonia!=null){	
				esTab=true;
				$('#colonia').val(colonia.asentamiento);
				$('#CP').val(colonia.codigoPostal);
			}else{
				mensajeSis("No Existe la Colonia");
				$('#colonia').val("");
				$('#coloniaID').val("");
				$('#coloniaID').focus();
				$('#coloniaID').select();
			}    	 						
		});
	}else{
		$('#colonia').val("");
	}
}
//consulta colonias 
function consultaColonias(idControl) {
	var jqColonia = eval("'#" + idControl + "'");
	var numColonia= $(jqColonia).val();		
	var numEstado =  $('#estadoID').val();	
	var numMunicipio =	$('#municipioID').val();
	var tipConPrincipal = 1;	
	setTimeout("$('#cajaLista').hide();", 200);	
	if(numEstado==''){		 return;}
	if(numMunicipio==''){	  return;}	
	
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numColonia != '' && !isNaN(numColonia) && esTab){
		coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,function(colonia) {
			if(colonia!=null){	
				esTab=true;
				$('#colonia').val(colonia.asentamiento);
			}else{
				mensajeSis("No Existe la Colonia");
				$('#colonia').val("");
				$('#coloniaID').val("");
				$('#coloniaID').focus();
				$('#coloniaID').select();
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
	if(numEstado==''){		 return;}
	if(numMunicipio==''){	  return;}
	
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numLocalidad != '' && !isNaN(numLocalidad) && esTab){
		localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad,function(localidad) {
			if(localidad!=null){	
				esTab=true;
				$('#nombreLocalidad').val(localidad.nombreLocalidad);
			}else{
				mensajeSis("No Existe la Localidad");
				$('#nombreLocalidad').val("");
				$('#localidadID').val("");
				$('#localidadID').focus();
				$('#localidadID').select();
			}    	 						
		});
	}
}

function calculaEdad(fecha){
	
	if(fecha < parametroBean.fechaAplicacion){
			var fechaNac=(fecha).split('-');
			var fechaActual=(parametroBean.fechaAplicacion).split('-');
			var anioNac = fechaNac[0];
			var anioAct = fechaActual[0];
			var mesNac = fechaNac[1];
			var mesAct = fechaActual[1];
			var diaNac = fechaNac[2];
			var diaAct = fechaActual[2];
			var anios = anioAct - anioNac;
			
			if(mesAct < mesNac){
				anios=anios-1;
			}
			if(mesAct = mesNac)	{
				if(diaAct < diaNac ){
					anios = anios - 1;
				}
			}
			if(anios < 18){
				mensajeSis("El Aval No Debe de Ser Menor de Edad");		
				$('#fechaNac').focus();
				$('#fechaNac').val('');		
			}
	}else{
		mensajeSis("La Fecha de Nacimiento es Mayor a la del Sistema.");
		$('#fechaNac').focus();
		$('#fechaNac').val('');
	}
}

function soloLetrasYNum(idControl, campo){
	 if (!/^([a-zA-Z0-9])*$/.test(campo)){
    	mensajeSis("Solo caracteres alfanuméricos");
   	    $('#'+idControl).focus();
  	    $('#'+idControl).val('');
    }
}

function validaCampoSelect(campo,idcampo){
	if(campo.value=='-1')
	{
		swal({
	    		title: "",   
	    		text: "Seleccione un Tipo de Acta",
	    		Html:false
	    	},function(){
	    		setTimeout(function(){
	    			$('#'+idcampo).focus();
	    		},200);
	    		

	    	}); 	

	}
}
function evaluaEdad(fecha){	
	
	var fechaNac=(fecha).split('-');
	var fechaActual=(parametroBean.fechaAplicacion).split('-');
	var anioNac = fechaNac[0];
	var anioAct = fechaActual[0];
	var mesNac = fechaNac[1];
	var mesAct = fechaActual[1];
	var diaNac = fechaNac[2];
	var diaAct = fechaActual[2];
	var anios = anioAct - anioNac;
	
	if(mesAct < mesNac){
		anios=anios-1;
	}
	if(mesAct == mesNac)	{
		if(diaAct < diaNac ){
			anios = anios - 1;
		}
	}
	if(anios < 18){
		return false;		
	}else{
		return true;
	}
	
}
function limpiaDatosDomicilio(){
	$('#calle').val('');
	$('#numExterior').val('');
	$('#numInterior').val('');
	$('#manzana').val('');
	$('#lote').val('');
	$('#colonia').val('');
	
	$('#localidadID').val('');
	$('#coloniaID').val('');
	$('#nombreLocalidad').val('');
	
	$('#estadoID').val('');
	$('#municipioID').val('');
	$('#CP').val('');
	$('#latitud').val('');
	$('#longitud').val('');
	$('#nombreEstado').val('');
	$('#nombreMuni').val('');
}

function limpiarCampos(){
	$('#primerNombre').val('');	
	$('#segundoNombre').val('');	
	$('#tercerNombre').val('');	
	$('#apellidoPaterno').val('');	
	$('#apellidoMaterno').val('');
	$('#tipoPersona').attr("checked",true);
	$('#tipoPersona2').attr("checked",false);
	$('#tipoPersona3').attr("checked",false);
	$('#RFC').val('');
	$('#razonSocial').val('');	
	$('#fechaNac').val('');
	$('#telefono').val('');	
	$('#extTelefonoPart').val('');		
	$('#telefonoCel').val('');
	limpiaDatosDomicilio();
	$('#rFCpm').val('');
	$('#sexo').val('M');
	$('#lblRFCpm').hide();
	$('#rFCpm').hide();
	$('#estadoCivil').val('S');
	$('#nacion').val('');
	$('#lugarNacimiento').val('');
	$('#paisNac').val('');
	$('#ocupacionID').val('');
	$('#ocupacion').val('');
	$('#puesto').val('');
	$('#domicilioTrabajo').val('');
	$('#telefonoTrabajo').val('');
	$('#extTelTrabajo').val('');
	$('#numIdentific').val('');
	$('#fecExIden').val('');
	$('#fecVenIden').val('');
}
function limpiarDatosEscritura()
{
	$('#esc_Tipo').val('');
	$('#escrituraPub').val('');
	$('#libroEscritura').val('');
	$('#volumenEsc').val('');
	$('#fechaEsc').val('');
	$('#estadoIDEsc').val('');
	$('#nombreEstadoEsc').val('');
	$('#localidadEsc').val('');
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
	$('#nombreEstadoReg').val('');
	$('#localidadRegPub').val('');
	$('#nombreMuniReg').val('');
}

function exito(){
	if ($('#tipoPersona2').is(':checked')) 
		$('#personaMoral').hide(500);	

	limpiarCampos();
	limpiarDatosEscritura();

}

function fallo(){
	
}
/**
 * Consulta el país de nacimiento de un aval.
 * @param idControl : ID del input que genera el evento.
 * @author avelasco
 */
function consultaPaisNac(idControl) {
	var jqPais = eval("'#" + idControl + "'");
	var numPais = $(jqPais).val();
	var conPais = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numPais != '' && !isNaN(numPais) && esTab) {
		paisesServicio.consultaPaises(conPais, numPais,function(pais) {
			if (pais != null) {
				$('#paisNac').val(pais.nombre);
				//if (pais.paisID != 700) {
					validaNacionalidad();
				//}
			} else {
				mensajeSis("No Existe el País.");
				$(jqPais).val('');
				$(jqPais).focus();
			}
		});
	}else{
		if(esTab){
			mensajeSis("No Existe el País.");
			$(jqPais).val('');
			$(jqPais).focus();
		}
	}
}
/**
 * Valida la nacionalidad de un aval.
 * @author avelasco
 */
function validaNacionalidad(){
	var nacionalidad = $('#nacion').val();
	var pais= $('#lugarNacimiento').val();
	var mexico='700';
	var nacdadMex='N';
	var nacdadExtr='E';

	if(nacionalidad==nacdadMex){
		if(pais!=mexico && pais !='' ){
			mensajeSis("Por la nacionalidad de la persona el país debe ser México");
			$('#lugarNacimiento').val('');
			$('#paisNac').val('');
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

function consultaOcupacion(idControl) {
	var jqOcupacion = eval("'#" + idControl + "'");
	var numOcupacion = $(jqOcupacion).val();
	var tipConForanea = 2;

	setTimeout("$('#cajaLista').hide();", 200);
	if (numOcupacion != 0 && numOcupacion != '' && !isNaN(numOcupacion) ) {
		ocupacionesServicio.consultaOcupacion(tipConForanea, numOcupacion, { async: false, callback: function(ocupacion) {
			if (ocupacion != null) {
				$('#ocupacion').val(ocupacion.descripcion);
				if (ocupacion.implicaTrabajo == 'S' && numOcupacion != 9999) {
					$("#puesto").rules("add", {
						required: function() { return $('#tipoPersona').is(':checked') || $('#tipoPersona3').is(':checked'); },
						messages: {
							required: "Especifique el puesto"
						}
					});

					$("#domicilioTrabajo").rules("add", {
						required: function() { return $('#tipoPersona').is(':checked') || $('#tipoPersona3').is(':checked'); },
						messages: {
							required: "Especifique la dirección"
						}
					});

					$("#telefonoTrabajo").rules("add", {
						required: function() { return ($('#tipoPersona').is(':checked') || $('#tipoPersona3').is(':checked')) && $('#extTelTrabajo').val() != ''; },
						messages: {
							required: "Especifique el teléfono"
						}
					});
				} else {
					$("#puesto").rules("remove", "required");
					$("#domicilioTrabajo").rules("remove", "required");
					$("#telefonoTrabajo").rules("remove", "required");
					$('#puesto').focus();
					$('#puesto').blur();
					$('#domicilioTrabajo').focus();
					$('#domicilioTrabajo').blur();
					$('#telefonoTrabajo').focus();
					$('#telefonoTrabajo').blur();
				}
			} else {
				if (numOcupacion != 0) {
					mensajeSis("La ocupación no existe");
					$('#ocupacionID').val('');
					$('#ocupacion').val('');
					if (esTab) {
						$('#ocupacionID').focus();
					}
				}
			}}
		});
	} else {
		$('#ocupacionID').val('');
		$('#ocupacion').val('');
	}
}