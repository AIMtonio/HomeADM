$(document).ready(function(){
	
	var parametroBean = consultaParametrosSession();
	esTab = false;
	var parametroBean = consultaParametrosSession();
	$('#remitente').val('1');
	$(':text').focus(function() {	
	 	esTab = false;
	});
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$('#campaniaID').focus();
	//Definición de constantes y Enums
	
	var catTipoConSms = {
		'principal'	: 1,
		'foranea'	: 2,
		'numInst'	: 3,
		'prinSalCamp':4
	};
	var catTipoTranSms = { 
		'agregaMasivo'	: 2
		
	};
	var catTipoLisSms = { 
		'simulaFecha': 1
	};
	var txt = '';
//-----------------------Métodovalidas y manejo de eventos-----------------------
	deshabilitaBoton('aceptar', 'submit');
	deshabilitaBoton('adjuntar', 'submit');
	agregaFormatoControles('formaGenerica');
	
	// lista solo campañas Clasificacion=Salida y categoria campaña
	$('#campaniaID').bind('keyup',function(e) { 		
		lista('campaniaID', '2', '2', 'nombre', $('#campaniaID').val(),'campaniasLista.htm');
	});
	

	cargaListaPlantilla();
	    
	
	$.validator.setDefaults({
		submitHandler: function(event) {
			if ($("#opcEnvio:checked").val() == 3  && $('#numFilas').val() == 0){
				mensajeSis ("No Existen Fechas para Enviar Mensajes");
			}else{
				$('#remitente').removeAttr('disabled');
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','campaniaID',
					'funcionExito','funcionError');
				
			}
     	}
	});
	$('#simular').click(function(){
		if ($('#fechaInicio').val() == "")
			mensajeSis('Inserte la Fecha de Inicio');
		else if ($('#fechaFin').val() == "")
			mensajeSis('Inserte la Fecha Fin');
		else if ($('#horaPeriodicidad').val() == ""){
			mensajeSis('Inserte la Hora Periodicidad');
			$('#horaPeriodicidad').focus();
		}
		else{
			$('#tipoLista').val(catTipoLisSms.simulaFecha);
			habilitaBoton('aceptar', 'submit');
			consultaGridFechas();
		}
	});
	$('#aceptar').click(function(){
			$('#tipoTransaccion').val(catTipoTranSms.agregaMasivo);
			$('#numTrans').val($('#numTransaccion').val());
			$('#numFilas').val($('#cuotas').val());
			guardaFechas();
	});
	
	
	$('#adjuntar').click(function(){		
		subirArchivos();
	});
	
	$('#campaniaID').blur(function(){
		if(esTab){
			validaCampania(this.id);
		}
	});

	$('#fechaEnvio').datepicker('option', 'minDate', '0');
	$('#fechaInicio').datepicker('option', 'minDate', '0');
	$('#fechaFin').datepicker('option', 'minDate', '0');
	$('#fechaInicio').change(function(){
		$('#gridCalendarioSMS').hide();
		deshabilitaBoton('aceptar', 'submit');
	});
	$('#fechaFin').change(function(){
		$('#gridCalendarioSMS').hide();
		deshabilitaBoton('aceptar', 'submit');
	});
	$('#periodicidad').change(function(){
		$('#gridCalendarioSMS').hide();
		deshabilitaBoton('aceptar', 'submit');
	});
	$('#horaEnvio').blur(function(){
		validaHora(this.name,this.value);
		$('#fechaProgEnvio').val($('#fechaEnvio').val()+' '+$('#horaEnvio').val());
	});
	$('#horaPeriodicidad').blur(function(){
		validaHora(this.name, this.value);
	});
	$('#distancia').blur(function(){
		validaHora(this.name, this.value);
	});
	$.mask.definitions['H']='[012]';
	$.mask.definitions['N']='[012345]';
	$.mask.definitions['n']='[0123456789]';
	$('#horaEnvio').mask("Hn:Nn");
	$('#horaPeriodicidad').mask("Hn:Nn");
	$('#distancia').mask("Hn:Nn");
	
	$('#txtgeneral').click(function (event) {	
 		$('#msjenviar').val('');
		if ($('#txtgeneral').is(':checked')){
			
			$('#msjenviar').show('slow');
			$('#lblTexto').show('slow');
			$('#longitud_textarea').show();
			$('#lbPlantilla').show();
			$('#listaPlantilla').show();
			$('#listaPlantilla option[value=0]').attr('selected','true');
			$("#msjenviar").rules("add", {
		 		required: true,
		 		messages: {
   				required: "Inserte el mensaje a enviar"
 				} 			
			});
			txt = '';			// Limpiamos la cajita del texto en enviar
			consultaCodigos(); //consultamos codigos de respuesta para esa campaña
		}else{			
			$("#msjenviar").rules("remove");
			$('#msjenviar').val('');
			$('#msjenviar').hide('1000');
			$('#lblTexto').hide('1000');
			$('#longitud_textarea').hide();
			$('#lbPlantilla').hide();
			$('#listaPlantilla').hide();
		}
	});
	
	$('input[name=opcEnvio]:radio').click(function (event) {
		if ( $("#opcEnvio:checked").val() == 1 ){
			habilitaBoton('aceptar', 'submit');
			$('#gridCalendario').empty();
			$('#gridCalendarioSMS').hide();
			$('#tdFecha').hide();
			$('.trCalendar').hide();
			$("#fechaEnvio").rules("remove");
			$("#horaEnvio").rules("remove");
			$("#fechaInicio").rules("remove");
			$("#fechaFin").rules("remove");
			$("#horaPeriodicidad").rules("remove");
			$("#fechaEnvio").val("");
			$("#horaEnvio").val("");
			$("#fechaInicio").val("");
			$("#fechaFin").val("");
			$("#horaPeriodicidad").val("");
			$('.trTipoEnvio').show();
		}else if ( $("#opcEnvio:checked").val() == 2 ){
			habilitaBoton('aceptar', 'submit');
			$('#gridCalendario').empty();
			$('#gridCalendarioSMS').hide();
			$('.trCalendar').hide();
			$('#tdFecha').show();
			$("#fechaInicio").val("");
			$("#fechaFin").val("");
			$("#horaPeriodicidad").val("");
			$('.trTipoEnvio').show();
			$("#fechaInicio").rules("remove");
			$("#fechaFin").rules("remove");
			$("#horaPeriodicidad").rules("remove");
			$("#fechaEnvio").rules("add", {
		 		required: true,
		 		messages: {
   				required: "Seleccione la fecha de Envio"
 				}
			});
			$("#horaEnvio").rules("add", {
		 		required: true,
		 		messages: {
   				required: "Inserte la hora de envio (HH:MM)"
 				}
			});
		}else if($('#opcEnvio:checked').val() == 3){
			deshabilitaBoton('aceptar', 'submit');
			$('#gridCalendarioSMS').hide();
			$("#fechaEnvio").rules("remove");
			$("#horaEnvio").rules("remove");
			$("#tipoEnvio").rules("remove");
			$('#tdFecha').hide();
			$('.trCalendar').show();
			$("#fechaEnvio").val("");
			$("#horaEnvio").val("");
			$('.trTipoEnvio').hide();
			$("#fechaInicio").rules("add", {
		 		required: true,
		 		messages: {
   				required: "Inserte la fecha de inicio"
 				}
			});
			$("#fechaFin").rules("add", {
		 		required: true,
		 		messages: {
   				required: "Inserte la fecha fin"
 				}
			});
			$("#horaPeriodicidad").rules("add", {
		 		required: true,
		 		messages: {
   				required: "Inserte la periodicidad"
 				}
			});
		}
	});
	$('input[name=tipoEnvio]:radio').click(function (event) {
		if ( $("#tipoEnvio:checked").val() == 'U' ){
			$("#noVeces").rules("remove");
			$("#distancia").rules("remove");			
			$('#tipoPro').hide();
			$("#noVeces").val("");
			$("#distancia").val("");
		}else if ( $("#tipoEnvio:checked").val() == 'R' ){
			$('#tipoPro').show();
			$("#noVeces").rules("add", {
		 		required: true,
		 		messages: {
   				required: "Inserte el numero de veces a enviar"
 				}
			});
			$("#distancia").rules("add", {
		 		required: true,
		 		messages: {
   				required: "Inserte la distancia (HH:MM)"
 				}
			});
		}
	});
	
	$('#listaPlantilla').change(function (){
		var numPlantilla = this.value;
		var tipoConsulta = 1;
		var plantillaBean = {
			'plantillaID' :	numPlantilla
		};
		smsPlantillaServicio.consulta(tipoConsulta, plantillaBean, function(plantilla){
			if(plantilla != null){
				txt = plantilla.descripcion;
				consultaCodigos();		
				var longitud =txt.length;
				 $('#longitud_textarea').text(longitud+' de 160 caracteres');
			}else{				
				mensajeSis("Plantilla no encontrada");
			}
		});
	});
	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			campaniaID: {
				required: true,
				numeroPositivo: true
			},
			remitente: {
				required: true
			},
			opcEnvio: {
				required: true
			},
			tipoEnvio: {
				required: true
			},
			rutahidden:{
				required: true
				},
			noVeces:{
				numeroPositivo: true
				}
			
		},
		messages: {
			campaniaID: {
				required: 'Especificar Numero de Campaña',
				numeroPositivo: 'Sólo números positivos'
			},
			remitente: {
				required: 'Especificar Remitente'
			},
			opcEnvio: {
				required: 'Seleccione una opcion de Envio'
			},
			tipoEnvio: {
				required: 'Seleccione el Tipo de Envio'
			},
			rutahidden:{
				required: 'Adjunte un archivo'	
			},
			noVeces:{
				numeroPositivo: 'Sólo números positivos'
				}
		}
	});

//-------------Validaciones de controles---------------------	
	function validaHora(nombre, valor)
	{
		//que no existan elementos sin escribir
		if(valor.indexOf("_") == -1)
		{
		  	var hora = valor.split(":")[0];
		  	if(parseInt(hora) > 23 )
		  	{
		       	$("#"+nombre).val("");
		  	}
		}
	}	
	function consultaDestinatario() {
		var destinatarioBeanCon = {
				'numeroInstitu1' : 1
		};
		parametrosSMSServicio.consulta(catTipoConSms.numInst, destinatarioBeanCon, function(destinatario) {
			if (destinatario != null) {
				$('#remitente').val(destinatario.numeroInstitu1);
				$('#listaPlantilla').val(0);
				$('#msjenviar').val('');
			}
		});
	}
	
	
	function consultaNomCampania(){
		var numCamp = $('#campaniaID').val();
		var campaniaBeanCon = {
				'campaniaID' : numCamp
		};
		campaniasServicio.consulta(catTipoConSms.foranea, campaniaBeanCon, function(nombre){
			if (nombre != null){
				if(nombre.estatus == 'C'){
					mensajeSis ('Campa&ntilde;a cancelada');
					
					deshabilitaBoton('aceptar', 'submit');	
					deshabilitaBoton('adjuntar', 'submit');
					
					$('#campaniaID').val('');
					$('#remitente').val('1');
					$('#campaniaID').focus();
				}else{
					$('#nombreCampania').val(nombre.nombre);
					$('#remitente').val('1');
				}
				
			}
		});
	}
	
 	function subirArchivos() {
 		var url ="smsFileUploadVista.htm?idCampania="+$('#campaniaID').val();
 		var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
 		var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;

 		ventanaArchivosCliente = window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
 										"left="+leftPosition+
 										",top="+topPosition+
 										",screenX="+leftPosition+
 										",screenY="+topPosition);	
 	}
 	
 	function validaCampania(idControl){
		var jqCampania  = eval("'#" + idControl + "'");
		var numCamp = $(jqCampania).val();		
		if(numCamp != '' && !isNaN(numCamp)){
		
			consultaCodigos();
			var campaniaBeanCon = { 
				'campaniaID' :numCamp
			};
			campaniasServicio.consulta(catTipoConSms.prinSalCamp,campaniaBeanCon,{ async: false, callback:function(campanias) {
				if(campanias!=null){
					consultaNomCampania();
					habilitaBoton('aceptar', 'submit');	
					habilitaBoton('adjuntar', 'submit');
				}else{
					mensajeSis ("La campaña no existe");
					limpiaForm($('#formaGenerica'));	
					deshabilitaBoton('aceptar', 'submit');	
					deshabilitaBoton('adjuntar', 'submit');
					$('#nombreCampania').val('');
					$('#campaniaID').val('');
					$('#remitente').val('1');
					$('#campaniaID').focus();
					$('#listaPlantilla').val(0);
					$('#msjenviar').val('');	
				}
			}});
		}else{
			mensajeSis ("La campaña no existe");
			limpiaForm($('#formaGenerica'));	
			deshabilitaBoton('aceptar', 'submit');	
			deshabilitaBoton('adjuntar', 'submit');
			$('#nombreCampania').val('');
			$('#campaniaID').val('');
			$('#remitente').val('1');
			$('#campaniaID').focus();
			$('#listaPlantilla').val(0);
			$('#msjenviar').val('');
		}
	}
 	
 	function consultaGridFechas(){
 		var varCamp = $('#campaniaID').val();
 		var periodicidad = $('#periodicidad').val();
 		var fechaInicio = $('#fechaInicio').val();
 		var fechaFin = $('#fechaFin').val();
		var params = {
 			'periodicidad' 	: periodicidad,
 			'fechaInicio' 	: fechaInicio,
 			'fechaFin' 		: fechaFin,
			'campaniaID' 	: varCamp,
			'tipoLista'		: catTipoLisSms.simulaFecha
		};
		$.post("envioMasivoGridVista.htm", params,  function(data){
				if(data.length >0) {
					$('#gridCalendarioSMS').html(data);
					$('#gridCalendarioSMS').show();
				}else{
					$('#gridCalendarioSMS').html("");
					$('#gridCalendarioSMS').show();
				}
		});
	}
 	
 	function guardaFechas(){
 		var numFechas = $('input[name=envioID]').length;
 		$('#listaFechas').val("");
 		for (var i = 1; i<= numFechas; i++){
 			if (i == 1){
 				$('#listaFechas').val($('#listaFechas').val() + 
 										document.getElementById("fechaInicio"+i+"").value +']');
 			}else{
 				$('#listaFechas').val($('#listaFechas').val() + 
 										document.getElementById("fechaInicio"+i+"").value+']');
 			}
 		}
 	}
 	
 	
 	// para visualizar los codigos de respuesta en campañas interactivas
	function consultaCodigos(){	
		var params = {};
		params['tipoLista'] = 2;		
		params['campaniaID'] = $('#campaniaID').val();
			
		var jqCodigo = 'codigoRespID';
		var jqDescrip = 'descripcion';
		var codigos= "";
		var codigo= "";
		var descrip= "";
		
		$.post("codRespResumenActGridVista.htm", params, function(data){
				if(data.length >0) {		
						$('#gridCodigosResp').html(data);						

						var numCodig = $('input[name=consecutivoID]').length;
					
						for(var i = 1; i <= numCodig; i++){	 
							jqCodigo  = 'codigoRespID'+i;
							jqDescrip = 'descripcion'+i;
						
								codigo = $('#'+jqCodigo).val();
								descrip = $('#'+jqDescrip).val();
								codigos = codigos+"#"+codigo+"  "+descrip+" \n" ;
						}
							
						$('#msjenviar').val(txt +" "+ codigos);
						 $('#gridCodigosResp').val("");	
						 
				}else{				
						$('#gridCodigosResp').html("");
						$('#gridCodigosResp').show();
				}
		});
	} 	
 	
	// funcion que carga en un combo las platillas existentes
	function cargaListaPlantilla(){
		var tipoConsulta = 1;				
		var plantillaBean = {
			'nombre' :	'%%'
		};
		dwr.util.removeAllOptions('listaPlantilla'); 
		dwr.util.addOptions('listaPlantilla', {0:'SELECCIONAR'}); 
		smsPlantillaServicio.lista(tipoConsulta, plantillaBean, function(plantilla){
			dwr.util.addOptions('listaPlantilla', plantilla, 'plantillaID', 'nombre');
		});
		
	}
	//Funcion que cuenta número de caracteres en  existentes en el Campo :Mensaje a enviar
	$(".contador").each(function(){
		var longitud = $(this).val().length;
			$(this).parent().find('#longitud_textarea').html('<b>'+longitud+'</b> de 160 caracteres');
			$(this).keyup(function(){ 
				var nueva_longitud = $(this).val().length;
				$(this).parent().find('#longitud_textarea').html('<b>'+nueva_longitud+'</b> de 160 caracteres');
				});
			});
});

	function funcionExito(){
		var jQmensaje = eval("'#ligaCerrar'");
		if($(jQmensaje).length > 0) { 
		mensajeAlert=setInterval(function() { 
			if($(jQmensaje).is(':hidden')) { 	
				clearInterval(mensajeAlert); 
				
				deshabilitaBoton('aceptar', 'submit');
				$('#gridCalendarioSMS').hide();
				$('#tdFecha').hide();
				$('#calendario1').hide();
				$('#calendario2').hide();
				$('#tipoPro').hide();
				$('.trTipoEnvio').show();
				$('#lblTexto').hide();
				$('#longitud_textarea').hide();
				$('#lbPlantilla').hide();
				$('#listaPlantilla').hide();
				$('#msjenviar').hide();
				deshabilitaBoton('adjuntar', 'submit');
				limpiaForm();
				$('#campaniaID').focus();			
			}
	        }, 50);
		}	
	}

	// FUNCION DE ERROR
	function funcionError(){
		$('#remitente').val('1');
	}


