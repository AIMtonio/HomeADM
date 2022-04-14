$(document).ready(function() {
		esTab = true;
	 
	//Definicion de Constantes y Enums  
	var catTipoTransaccionInstFonde = {   
  		'agrega':'1',
  		'modifica':'2'	};
	
	var catTipoConsultaInstFonde = {
  		'principal'	: 1,
  		'foranea'	: 2
	};	
	
	var catTipoConsultaInstituciones = {
  		'principal':1, 
  		'foranea':2
	};
	var catTipoConsultaCentro = { 
	  		'principal'	: 1,
	  		'foranea'	: 2
		};	
	
	var catTipoConFondeador = {
	  		'tiposFondeadorAct'	: 2,
		};
	
	var tipoFisica = 'F';
	var tipoGubernamental = 'G';
	var tipoMoral = 'M';
	var tipoFisicaEmpresarial = 'A';
	var tipoAdmonFideicomiso = 'B';

	
		//------------ Metodos y Manejo de Eventos -----------------------------------------
	consultaTiposFondeadores();
	deshabilitaBoton('modifica', 'submit');
    deshabilitaBoton('agrega', 'submit');
    $('#institutFondID').focus();

    $('#divCliente').hide();
    $('#divNomCliente').hide();
    $('#divRepLegal').hide();
	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	

	$.validator.setDefaults({
            submitHandler: function(event) { 
        		habilitaControl('nombreCliente');
            	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','institutFondID','exito','error'); 
            }
    });				
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionInstFonde.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionInstFonde.modifica);
		
	});	
	$('#institucionID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		listaAlfanumerica('institucionID', '1', '1', 'nombre', $('#institucionID').val(), 'listaInstituciones.htm');
	});
	
	$('#institutFondID').bind('keyup',function(e){
		lista('institutFondID', '2', '1', 'nombreInstitFon', $('#institutFondID').val(), 'intitutFondeoLista.htm');
	});

	$('#institutFondID').blur(function() { 
  		validaInstitucion(this.id); 
	});
	
	$('#institucionID').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('institucionID', '1', '1', 'nombre', 
				$('#institucionID').val(), 'listaInstituciones.htm');
	});
	$('#institucionID').blur(function() {
  		consultaInstitucion(this.id);
  	});
	
	
	$('#institucionBanc').bind('keyup',function(e){
		//TODO Agregar Libreria de Constantes Tipo Enum
		lista('institucionBanc', '1', '1', 'nombre', 
				$('#institucionBanc').val(), 'listaInstituciones.htm');
	});

	$('#institucionBanc').blur(function() {
  		consultaInstitucion1(this.id);
	});
		
	$('#cuentaClabe').blur(function() {
		validaExisteFolio('cuentaClabe','institucionBanc'); 	
	});	
	
	$('#nombreInstitFon').blur(function() {
		var nombrei = $('#nombreInstitFon').val();
		$('#nombreInstitFon').val($.trim(nombrei));
	});

	  $('#centroCostos').bind('keyup',function(e){			
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "descripcion"; 
			parametrosLista[0] = $('#centroCostos').val();	
			lista('centroCostos' , '2', '1', camposLista, parametrosLista, 'listaCentroCostos.htm');
	    });

	$('#razonSocInstFo').blur(function() {
		var nombrer = $('#razonSocInstFo').val();
		$('#razonSocInstFo').val($.trim(nombrer));
	});
	$('#cuentaClabe').blur(function() {
		var nombrec = $('#cuentaClabe').val();
		$('#cuentaClabe').val($.trim(nombrec));
	});
	$('#clienteID').bind('keyup',function(e){
		lista('clienteID', '2', '1', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	$('#clienteID').blur(function() {
  		consultaCliente(this.id);
  		if($('#clienteID').val()==''){
  			habilitaControl('nombreCliente');
  		}
	});
	
	$('#tipoFondeador').change(function(){
		switch($(this).val())	{
			case tipoFisica:
				$('#razonSocial').hide();
				$('#razonSocInstFo').hide();
				$('#divInstitucion').hide();
				$('#razonSocInstFo').val('');
				$('#institucionID').val('');
				$("#razonSocInstFo").rules("remove");
				$("#institucionID").rules("remove");
			    $('#divCliente').show();
			    $('#divNomCliente').show();
			    $('#divNombre').hide();
			    $('#divDesc').hide();
			    $('#nombreInstitFon').val('');
			    $('#divRepLegal').hide();
			    $('#repLegal').val('');
			break;
			case tipoGubernamental: 
				$('#razonSocial').show();
				$('#razonSocInstFo').show();
				$('#divInstitucion').show();
				$('#institucionID').val('');
				$('#nombreInstitucion').val('');
				$('#razonSocInstFo').val('');
			    $('#divCliente').hide();
			    $('#divNomCliente').hide();
			    $('#divNombre').show();
			    $('#divDesc').show();
				$('#clienteID').val('');
				$('#nombreCliente').val('');
				$('#divRepLegal').hide();
				$('#repLegal').val('');
				habilitaDireccion();
				habilitaControl('RFC');	
				$('#RFC').val('');
			break;
			case tipoMoral:
				$('#razonSocial').show();
				$('#razonSocInstFo').show();
				$('#divInstitucion').hide();
				$('#institucionID').val('');
				$("#institucionID").rules("remove");
			    $('#divCliente').show();
			    $('#divNomCliente').show();
			    $('#divNombre').hide();
			    $('#divDesc').hide();
			    $('#nombreInstitFon').val('');
			    $('#divRepLegal').show();
			    $('#repLegal').val('');

			break;
			case tipoFisicaEmpresarial:
				$('#razonSocial').hide();
				$('#razonSocInstFo').hide();
				$('#divInstitucion').hide();
				$('#razonSocInstFo').val('');
				$('#institucionID').val('');
				$("#razonSocInstFo").rules("remove");
				$("#institucionID").rules("remove");
			    $('#divCliente').show();
			    $('#divNomCliente').show();
			    $('#divNombre').hide();
			    $('#divDesc').hide();
			    $('#nombreInstitFon').val('');
			    $('#divRepLegal').hide();
			    $('#repLegal').val('');
			break;
			case tipoAdmonFideicomiso:
				$('#razonSocial').show();
				$('#razonSocInstFo').show();
				$('#divInstitucion').hide();
				$('#institucionID').val('');
				$("#institucionID").rules("remove");
			    $('#divCliente').show();
			    $('#divNomCliente').show();
			    $('#divNombre').hide();
			    $('#divDesc').hide();
			    $('#nombreInstitFon').val('');
			    $('#divRepLegal').show();
			    $('#repLegal').val('');

			break;
		}
	});
	
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
				$('#nombreMuni').val('');
				mensajeSis('Especificar Estado');
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
					mensajeSis('Especificar Municipio');
				}
			}
		}else{
			if($('#localidadID').val().length >= 3){
				$('#estadoID').focus();
				$('#localidadID').val('');
				$('#nombreLocalidad').val('');
				mensajeSis('Especificar Estado');
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
					mensajeSis('Especificar Municipio');
					$('#municipioID').focus();
					$('#coloniaID').val('');
					$('#nombreColonia').val('');
				}
			}
		}else{
			if($('#coloniaID').val().length >= 3){
				mensajeSis('Especificar Estado');
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
	
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
				
		rules: {
			nombreInstitFon: {
				required: function() { return $('#tipoFondeador').val()=='G';},		
				maxlength:200
			},	
			
			razonSocInstFo: { 
				required: true,
				maxlength:200
			},	
			estatus:{
				required: true
				},
			institucionID: { 
				required: true
			},
			cuentaClabe:{
				required: function() { return $('#tipoFondeador').val() =='F'||$('#tipoFondeador').val() =='M'||$('#tipoFondeador').val() =='A' ||$('#tipoFondeador').val() =='B';},		
				minlength:18,
				maxlength:18
			},
			tipoFondeador: { 
				required: true
			},
			cobraISR : {
				required: true
			},
			institucionBanc:{
				required: function() { return $('#tipoFondeador').val() =='F'||$('#tipoFondeador').val() =='M'||$('#tipoFondeador').val() =='A' ||$('#tipoFondeador').val() =='B';},		
			},
			numCtaInstit:{
				required: function() { return $('#tipoFondeador').val() =='F'||$('#tipoFondeador').val() =='M'||$('#tipoFondeador').val() =='A' ||$('#tipoFondeador').val() =='B';},		
				maxlength:50
			},			
			nombreTitular:{
				required: function() { return $('#tipoFondeador').val() =='F'||$('#tipoFondeador').val() =='M'||$('#tipoFondeador').val() =='A' ||$('#tipoFondeador').val() =='B';},		
			},
			repLegal : {
				required :  function() {return $('#tipoFondeador').val() =='M' ||$('#tipoFondeador').val() =='B';}
			},
			estadoID: {
				required: true
			},
			municipioID: {
				required: true
			},
			calle: {
				required: true,
				minlength: 1
			},	
			coloniaID: {
				required: true
			},	
			CP: {
				required: true,
			    minlength: 5,
				maxlength: 6
			},	
			localidadID: {
				required: true
			},
			RFC:{
				required: true
			}
		
			
		},
		messages: {
			
			nombreInstitFon: {
				required: 'Especificar Nombre del Fondeador',
				maxlength:'Máximo 200 Caracteres'
			},
			
			razonSocInstFo: {
				required: 'Especificar Razón Social',
				maxlength:'Máximo 200 Caracteres'
			},
			
			estatus: {
				required: 'Seleccione Estatus',
				},
			institucionID: {
				required: 'Especificar Institución',
			},
			cuentaClabe:{
				required: 'Especificar Cuenta Clabe',
				minlength:'Minimo 18 Caracteres',
				maxlength:'Máximo de Caracteres'
			},
			tipoFondeador: { 
				required: 'Seleccione Tipo Fondeador',
			},
			cobraISR : {
				required: 'Seleccione Retención',
			},
			institucionBanc:{
				required: 'Especificar Institución Bancaria',
			},
			numCtaInstit:{
				required: 'Especificar Número de Cuenta Bancaria',
				maxlength:'Máximo de Caracteres'
			},
			nombreTitular:{
				required: 'Especificar Nombre de Titular',
			},
			repLegal:{
				required: 'Especificar Nombre de Representante Legal',
			},
			estadoID: {
				required: 'Especificar Estado.'
			},
			municipioID: {
				required: 'Especificar Municipio.'
			},
			calle: {
				required: 'Especificar Calle.', 
				minlength: 'Especificar Calle.'
			},
			
			coloniaID: {
				required: 'Especificar Colonia.'
			},
			CP: {
				required: 'Especificar C.P.', 
       			minlength: 'Mínimo 5 Caracteres.',
				maxlength: 'Máximo 6 Caracteres.'
			},
			localidadID: {
				required: 'Especificar Localidad.'
			},
			RFC:{
				required: 'Especificar RFC.'
			}
		}		
	});
	
	//Método de consulta de Institución
	
	function consultaInstitucion(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
  				'institucionID':numInstituto
				};
	 
		if(numInstituto != '' && !isNaN(numInstituto) ){
			institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){
						if(instituto!=null){							
							$('#nombreInstitucion').val(instituto.nombre);													
						}else{
							mensajeSis("El Número de Institución no Existe"); 
							$('#institucionID').val('');
							$('#institucionID').focus();
							$('#nombreInstitucion').val('');
							$('#cuentaClabe').val('');
						}    						
				});
			}
		}
	function consultaInstitucion1(idControl) {
		var jqInstituto = eval("'#" + idControl + "'");
		var numInstituto = $(jqInstituto).val();
		setTimeout("$('#cajaLista').hide();", 200);	
		var InstitutoBeanCon = {
  				'institucionID':numInstituto
				};
	 
		if(numInstituto != '' && !isNaN(numInstituto) ){
			institucionesServicio.consultaInstitucion(catTipoConsultaInstituciones.foranea,InstitutoBeanCon,function(instituto){
						if(instituto!=null){							
							$('#descripcionInstitucion').val(instituto.nombre);													
						}else{
							mensajeSis("El Número de Institución no Existe"); 
							$('#institucionBanc').val('');
							$('#institucionBanc').focus();
							$('#descripcionInstitucion').val('');
						}    						
				});
			}
		}

	
	//------------ Validaciones de Controles -------------------------------------
	


	function validaInstitucion(control) {
		var numInst = $('#institutFondID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		clearSelected("capturaIndica");
		if (numInst != '' && !isNaN(numInst) && esTab) {

			if (numInst == '0') {
				habilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');
				inicializaForma('formaGenerica', 'institutFondID');
				$('#nombreInstitFon').val('');
				$('#razonSocInstFo').val('');
				$('#institucionID').val('');
				$('#nombreInstitucion').val('');
				$('#cuentaClabe').val('');
				$('#tipoFondeador').val('');
				$('#cobraISR').val('');
				$('#estatus').val('');
				$('#descripcionInstitucion').val('');
				$('#numCtaInstit').val('');
				$('#nombreTitular').val('');
				$('#institucionBanc').val('');

			} else {
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');

				var instFondeoBeanCon = {
					'institutFondID' : $('#institutFondID').val()
				};
				
				fondeoServicio.consulta(catTipoConsultaInstFonde.principal, instFondeoBeanCon, {
				async : false,
				callback : function(instFondeo) {
					if (instFondeo != null) {
						dwr.util.setValues(instFondeo);
						checkMultiSELECT("capturaIndica", instFondeo.capturaIndica)
						consultaEstado('estadoID');
						consultaMunicipio('municipioID');
						consultaLocalidad('localidadID');
						consultaColonia('coloniaID');

						$('#institucionBanc').val(instFondeo.IDInstitucionBanc);
						if (instFondeo.IDInstitucionBanc == 0) {
							$('#institucionBanc').val('');
						}
						consultaInstitucion1('institucionBanc');

						esTab = true;
						deshabilitaBoton('agrega', 'submit');
						habilitaBoton('modifica', 'submit');
						if (instFondeo.institucionID > 0) {
							consultaInstitucion('institucionID');
						}

						if (instFondeo.tipoFondeador == tipoFisica || instFondeo.tipoFondeador == tipoFisicaEmpresarial) {
							$('#razonSocial').hide();
							$('#razonSocInstFo').hide();
							$('#divInstitucion').hide();
							$("#razonSocInstFo").rules("remove");
							$("#institucionID").rules("remove");
							$('#divCliente').show();
							$('#divNomCliente').show();
							$('#divNombre').hide();
							$('#divDesc').hide();
							$('#divRepLegal').hide();
							$('#repLegal').val('');
						}
						if (instFondeo.tipoFondeador == tipoGubernamental) {
							$('#razonSocial').show();
							$('#razonSocInstFo').show();
							$('#divInstitucion').show();
							consultaInstitucion('institucionID');
							$('#divCliente').hide();
							$('#divNomCliente').hide();
							$('#divNombre').show();
							$('#divDesc').show();
							$('#divRepLegal').hide();
							$('#repLegal').val('');
						}
						if (instFondeo.tipoFondeador == tipoMoral || instFondeo.tipoFondeador == tipoAdmonFideicomiso) {
							$('#razonSocial').show();
							$('#razonSocInstFo').show();
							$('#divInstitucion').hide();
							$("#institucionID").rules("remove");
							$('#divCliente').show();
							$('#divNomCliente').show();
							$('#divNombre').hide();
							$('#divDesc').hide();
							$('#divRepLegal').show();
						}
						consultaCentroCostos('centroCostos');
						if (instFondeo.clienteID != 0) {
							consultaClientes('clienteID');
							$('#nombreCliente').val(instFondeo.nombreInstitFon);

						} else {
							if (instFondeo.tipoFondeador == tipoFisica || instFondeo.tipoFondeador == tipoFisicaEmpresarial) {
								$('#nombreCliente').val(instFondeo.nombreInstitFon);
							}
						}
					} else {
						mensajeSis("No Existe la Institución de Fondeo");
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
						$('#institutFondID').focus();
						$('#institutFondID').select();
						$('#nombreInstitFon').val('');
						$('#razonSocInstFo').val('');
						$('#institucionID').val('');
						$('#nombreInstitucion').val('');
						$('#cuentaClabe').val('');
						$('#tipoFondeador').val('');
						$('#cobraISR').val('');
						$('#estatus').val('');
					}
				}
				});

			}

		}
	}
		function validaExisteFolio(numCta,institID){
	  		var jqNumCtaInstit = eval("'#" + numCta + "'");
	  		var jqInstitucionID = eval("'#" + institID + "'");
	  		var numCtaInstit = $(jqNumCtaInstit).val();
	  		var institucionID = $(jqInstitucionID).val();
	  		var CtaNostroBeanCon = {
	  				'institucionID':institucionID,
	  				'numCtaInstit':numCtaInstit
	  				
	  		};
	  		if(numCtaInstit!= "" && institucionID!=""){
	  			cuentaNostroServicio.consultaExisteCta(5,CtaNostroBeanCon, function(ctaNtro){
	  				if(ctaNtro!=null){  
	  					var folio = ctaNtro.cuentaClabe;// el folio de institucion se paso en el parametro cuentaClabe
	  					var cuentaClabe = $('#cuentaClabe').val();
	  					var substrClabe= cuentaClabe.substr(0,3);
	  					if(folio!=substrClabe){
	  						mensajeSis("La Cuenta Clabe no coincide con la Institución.");
							$('#cuentaClabe').val('');
	  						$('#cuentaClabe').focus();	
	  					}						 			
	  				}
	  			});
	  		}
	  	}
		function consultaCliente(idControl) {
			var jqCliente = eval("'#" + idControl + "'");
			var numCliente = $(jqCliente).val();	
			var tipConForanea = 1;	
			setTimeout("$('#cajaLista').hide();", 200);		
			if(numCliente != '' && !isNaN(numCliente)){
				clienteServicio.consulta(tipConForanea,numCliente, { async: false, callback: function(cliente) {
					if(cliente!=null){	
						if($('#tipoFondeador').val()=='M' && cliente.tipoPersona!='M'){
							mensajeSis("Seleccione una Persona Moral"); 
							$('#clienteID').val('');
							$('#nombreCliente').val('');
							$('#clienteID').focus();
						}else if($('#tipoFondeador').val()=='F' && cliente.tipoPersona!='F'){
							mensajeSis("Seleccione una Persona Fisica"); 
							$('#clienteID').val('');
							$('#nombreCliente').val('');
							$('#clienteID').focus();
						}else if($('#tipoFondeador').val()=='A' && cliente.tipoPersona!='A'){
							mensajeSis("Seleccione una Persona Fisica con Actividad Empresarial"); 
							$('#clienteID').val('');
							$('#nombreCliente').val('');
							$('#clienteID').focus();
						}else if($('#tipoFondeador').val()=='B' && cliente.tipoPersona!='M'){
							mensajeSis("Seleccione una Persona Moral"); 
							$('#clienteID').val('');
							$('#nombreCliente').val('');
							$('#clienteID').focus();
						}else{
							$('#clienteID').val(cliente.numero);			
							$('#nombreCliente').val(cliente.nombreCompleto);
							deshabilitaControl('nombreCliente');
							consultaDireccion('clienteID');
							if(cliente.RFC!='' && cliente.RFC!=null){
								$('#RFC').val(cliente.RFC);	
								deshabilitaControl('RFC');
							}else{
								$('#RFC').val('');
								habilitaControl('RFC');	
							}
							
						}
						
					}else{
						$('#clienteID').val('');
						$('#nombreCliente').val('');
						$('#nombreCliente').focus();
						$('#nombreCliente').select();	
						habilitaControl('nombreCliente');
						habilitaDireccion();
						habilitaControl('RFC');	
						$('#RFC').val('');
					}    	 						
				}});
			}else{
				$('#clienteID').val('');
				$('#nombreCliente').val('');
				$('#nombreCliente').focus();
				$('#nombreCliente').select();	
				habilitaControl('nombreCliente');
				habilitaDireccion();
				habilitaControl('RFC');	
				$('#RFC').val('');
			}
			
		}	
			$('#centroCostos').blur(function(){
				consultaCentroCostos(this.id);
			});

		function consultaClientes(idControl) {
			var jqCliente = eval("'#" + idControl + "'");
			var numCliente = $(jqCliente).val();	
			var tipConForanea = 2;	
			setTimeout("$('#cajaLista').hide();", 200);		
			if(numCliente != '' && !isNaN(numCliente) && esTab){
				clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
					if(cliente!=null){	
						$('#clienteID').val(cliente.numero);			
						$('#nombreCliente').val(cliente.nombreCompleto);
						deshabilitaControl('nombreCliente');
					}else{
						$('#clienteID').val('0');
						$('#nombreCliente').focus();
						$('#nombreCliente').select();	
						habilitaControl('nombreCliente');
					}    	 						
				});
			}
		}	
			
		
		// funcion para consultar centro de costos 
		function consultaCentroCostos(idControl) {
			var jqCentroCostos = eval("'#" + idControl + "'");
			var numCentroCostos = $(jqCentroCostos).val();
			setTimeout("$('#cajaLista').hide();", 200);	
			var CentroCostoBeanCon = {
	  				'centroCostoID':numCentroCostos
					};
		 
			if(numCentroCostos != '' && !isNaN(numCentroCostos) ){
						centroServicio.consulta(catTipoConsultaCentro.principal,CentroCostoBeanCon,function(centro) {
							if(centro!=null){							
								$('#descripcionCenCostos').val(centro.descripcion);													
							}else{
								mensajeSis("El centro de Costos no Existe"); 
								$('#centroCostos').val('');
								$('#centroCostos').focus();
								$('#descripcionCenCostos').val('');
							}    						
					});
				}
			}	
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
					$('#nombreEstado').val("");
					$('#estadoID').val("");
					$('#estadoID').focus();
					$('#estadoID').select();
					mensajeSis("No Existe el Estado");
				}    	 						
			}});
		}else{
			if(isNaN(numEstado)){
				$('#nombreEstado').val("");
				$('#estadoID').val("");
				$('#estadoID').focus();
				$('#estadoID').select();
				mensajeSis("No Existe el Estado");
			}else{
				if(numEstado == '' || numEstado == 0){
					$('#nombreEstado').val("");
					$('#estadoID').val("");					
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
				$('#municipioID').select();
					
			}else{
				if(numMunicipio == '' || numMunicipio == 0){
					$('#nombreMuni').val("");
					$('#municipioID').val("");			
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
							$('#nombrelocalidad').val(localidad.nombreLocalidad);
						}else{
							$('#nombreLocalidad').val("");
							$('#localidadID').val("");
							$('#localidadID').focus();
							$('#localidadID').select();
							mensajeSis("No Existe la Localidad");
						}    	 						
					}});
				}else{
					$('#nombreLocalidad').val("");
					$('#localidadID').val("");
					$('#municipioID').focus();
					mensajeSis("Especificar Municipio");
				}
			}else{
				$('#nombreLocalidad').val("");
				$('#localidadID').val("");
				$('#estadoID').focus();	
				mensajeSis("Especificar Estado");										
			}	
		}else{
			if(isNaN(numLocalidad)){
				mensajeSis("No Existe la Localidad");
				$('#nombreLocalidad').val("");
				$('#localidadID').val("");
				$('#localidadID').focus();
				$('#localidadID').select();
			}else{
				if(numLocalidad == '' || numLocalidad == 0){
					$('#nombreLocalidad').val("");
					$('#localidadID').val("");		
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
								mensajeSis("No Existe la Colonia");
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
					mensajeSis("Especificar Municipio");
				}
			}else{
				$('#nombreColonia').val("");
				$('#coloniaID').val("");
				$('#estadoID').focus();	
				mensajeSis("Especificar Estado");										
			}			
		}else{
			if(isNaN(numColonia)){
				mensajeSis("No Existe la Colonia");
				$('#nombreColonia').val("");
				$('#coloniaID').val("");
				$('#coloniaID').focus();
				$('#coloniaID').select();				
			}else{
				if(numColonia == '' || numColonia == 0){
					$('#nombreColonia').val("");
					$('#coloniaID').val("");
				}
			}
		}
	}

	function consultaDireccion(idControl) {
			var jqCliente = eval("'#" + idControl + "'");
			var numCliente = $(jqCliente).val();	
			var tipConForanea = 15;	
			var direccionesCliente ={
			 		'clienteID' : $('#clienteID').val()
				};
			setTimeout("$('#cajaLista').hide();", 200);		
			if(numCliente != '' && !isNaN(numCliente) && esTab){
				direccionesClienteServicio.consulta(tipConForanea, direccionesCliente, { async: false, callback: function(direccion) {
					if(direccion!=null){	
						$('#estadoID').val(direccion.estadoID);
						$('#municipioID').val(direccion.municipioID);
						$('#localidadID').val(direccion.localidadID);
						$('#coloniaID').val(direccion.coloniaID);	
						$('#calle').val(direccion.calle);
						$('#numeroCasa').val(direccion.numeroCasa);
						$('#numInterior').val(direccion.numInterior);
						$('#piso').val(direccion.piso);
						$('#primEntreCalle').val(direccion.primEntreCalle);
						$('#segEntreCalle').val(direccion.segEntreCalle);
						$('#CP').val(direccion.CP);
						consultaEstado('estadoID');
						consultaMunicipio('municipioID');
						consultaLocalidad('localidadID');
						consultaColonia('coloniaID');
						dehabilitaDireccion();
					}else{
		
						habilitaDireccion();
					}    	 						
				}});
			}
		}	

	function dehabilitaDireccion(){
		deshabilitaControl('estadoID');
		deshabilitaControl('municipioID');
		deshabilitaControl('localidadID');
		deshabilitaControl('coloniaID');
		deshabilitaControl('numeroCasa');
		deshabilitaControl('numInterior');
		deshabilitaControl('piso');
		deshabilitaControl('primEntreCalle');
		deshabilitaControl('segEntreCalle');
		deshabilitaControl('CP');
		deshabilitaControl('calle');

	}

	function habilitaDireccion(){
		habilitaControl('estadoID');
		habilitaControl('municipioID');
		habilitaControl('localidadID');
		habilitaControl('coloniaID');
		habilitaControl('numeroCasa');
		habilitaControl('numInterior');
		habilitaControl('piso');
		habilitaControl('primEntreCalle');
		habilitaControl('segEntreCalle');
		habilitaControl('CP');
		habilitaControl('calle');
		$('#estadoID').val('');
		$('#nombreEstado').val('');
		$('#municipioID').val('');
		$('#nombreMuni').val('');
		$('#localidadID').val('');
		$('#nombrelocalidad').val('');
		$('#coloniaID').val('');
		$('#nombreColonia').val('');		
		$('#calle').val('');
		$('#numeroCasa').val('');
		$('#numInterior').val('');
		$('#piso').val('');
		$('#primEntreCalle').val('');
		$('#segEntreCalle').val('');
		$('#CP').val('');
	}
	
	function consultaTiposFondeadores() {
		var tipoLista = catTipoConFondeador.tiposFondeadorAct;
		dwr.util.removeAllOptions('tipoFondeador');
		dwr.util.addOptions('tipoFondeador', {'':'SELECCIONAR'});
		tipoFondeadorServicio.listaCombo(tipoLista, function(instrumento){
			dwr.util.addOptions('tipoFondeador', instrumento, 'tipoFondeador', 'desTipoFondeador');

		});
	}
	
});
function exito(){
	habilitaBoton('modifica', 'submit');
	deshabilitaBoton('agrega', 'submit');
	$('#institutFondID').focus();
	inicializaForma('formaGenerica','institutFondID' );
	$('#tipoFondeador').val("");
	$('#cobraISR').val("");
	$('#estatus').val("");
	$('#divRepLegal').hide();
	$('#repLegal').val('');
	
}
function error(){
	
}
var nav4 = window.Event ? true : false;
function IsNumber(evt){
	var key = nav4 ? evt.which : evt.keyCode;
	return (key <= 13 || (key >= 48 && key <= 57) );
}

function checkMultiSELECT(idControl,valores) {
	if(valores!=null && idControl!=null){
		var array = valores.split(',');
		var tamanio = array.length;
		for (var i = 0; i < tamanio; i++) {
			var valor = array[i];
			var jqTipoInstrumento = eval("'#"+idControl+" option[value=" + valor + "]'");
			$(jqTipoInstrumento).attr("selected", "selected");
		}
	}
}

function clearSelected(idControl){
    var elements = document.getElementById(idControl).options;

    for(var i = 0; i < elements.length; i++){
      elements[i].selected = false;
    }
  }