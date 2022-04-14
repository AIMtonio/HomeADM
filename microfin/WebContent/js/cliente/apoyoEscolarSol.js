var Var_TipoDocumento=55;
$(document).ready(function() {
	//consulta los parametros del usuario y sesion
	var parametrosBean = consultaParametrosSession();
	
	// consulta los parametros de caja para obtener el perfil para autorizar las solicitudes de apoyo escolar
	consultaPerfilAutoriza();
	
	var tipoTransaccion= {
			'alta' : '1',
			'modifica' : '2',
			'actualiza': '3'
		};
	
	var tipoActualizacion= {
			'ninguna'	: '0',
			'autorizaRechaza' : '1'			
		};
	

	esTab = false;
	
	/*pone tap falso cuando toma el foco input text */
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	/*pone tab en verdadero cuando se presiona tab */
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	

	
	/*   ============ METODOS  Y MANEJO DE EVENTOS =============   */
	
	/* consulta parametros de usuario y sesion */
	var parametrosBean = consultaParametrosSession();
	   
	
	/*le da formato de moneda, calendario, etc */
	agregaFormatoControles('formaGenerica');
	
	$('#clienteID').focus();
	$("#datosCliente").hide();
	$("#datosTutor").hide();
	$("#datosSolicitud").hide();
	$("#datosApoyoEscolar").hide();
	$("#datosApoyoEscolarReg").hide();
	$("#autorizar").hide();
	
	/*esta funcion esta en forma.js */
	deshabilitaBoton('modificar', 'submit');
	deshabilitaBoton('agregar', 'submit');
	deshabilitaBoton('grabar', 'submit');
	
	/*llena el combo que muestra los tipos de apoyo escolar segun el ciclo(nivel escolar) */
	consultaTiposApoyo();
	
	
	/* lista de ayudas para clientes */
	
	$('#clienteID').bind('keyup',function(e) { 
		lista('clienteID', '2', '8', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	}); 
	/*
	$('#clienteID').bind('keyup',function(e){
		if($('#clienteID').val().length<3){		
			$('#cajaListaCte').hide();
		}
	});
*/
	$('#buscarMiSuc').click(function(){
		listaCte('clienteID', '3', '24', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	$('#buscarGeneral').click(function(){
		listaCte('clienteID', '3', '8', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	$('#clienteID').blur(function() {	
		if(esTab){
			consultaCliente(this.id);
		}  		
	});
	
	/* lista de ayudas para solicitud (de apoyo escolar) */
	$('#apoyoEscSolID').bind('keyup',function(e) { 
		var numSolicitud = $('#apoyoEscSolID').val();
		var numCliente = $('#clienteID').val();
		
		if(numSolicitud !=0 && numCliente !=''){
			var camposLista = new Array();
			var parametrosLista = new Array();
			
			camposLista[0] = "apoyoEscSolID";
			camposLista[1] = "clienteID";
			
			parametrosLista[0] = numSolicitud;
			parametrosLista[1] = numCliente;
			
			listaAlfanumerica('apoyoEscSolID', '0', '2', camposLista, parametrosLista, 'listaApoyoEscolarSol.htm');
		}
	}); 
	
	
	$('#apoyoEscSolID').blur(function() {
		if(esTab){
			var numCliente = $('#clienteID').val();
			if(numCliente != '' && !isNaN(numCliente)){
					consultaSolicitudApoyoEsc(this.id);
			}
			else{
				$('#apoyoEscSolID').val('');
				$('#clienteID').focus();
				mensajeSis("Debe especificar el número de cliente");
			}			
		}
	});
	
	/* redondea el promedio a 1 decimal */
	$('#promedioEscolar').blur(function() {
		if(esTab){
			var promedio = this.value ;
			if(promedio != ''){
				
				if(parseFloat(promedio)> 0.0 ){
					$('#promedioEscolar').formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 1	
					});
				}
				else{
					mensajeSis("El Promedio Escolar es Incorrecto.");
					this.focus();
					this.select();
				}
			}			
		}		
	});
	
	
	
	/*asigna el tipo de transaccion */
	$('#modificar').click(function() {	
		$('#tipoTransaccion').val(tipoTransaccion.modifica);
		$('#tipoActualizacion').val(tipoActualizacion.ninguna);
	});
	$('#agregar').click(function() {		
		$('#tipoTransaccion').val(tipoTransaccion.alta);	
		$('#tipoActualizacion').val(tipoActualizacion.ninguna);
		$('#usuarioRegistra').val(parametrosBean.numeroUsuario);  
		$('#sucursalRegistroID').val(parametrosBean.sucursal); 
	});

	$('#grabar').click(function() {	
		var estatus = $('input:radio[name=autorizar]:checked').val();
		$('#tipoTransaccion').val(tipoTransaccion.actualiza);
		$('#tipoActualizacion').val(tipoActualizacion.autorizaRechaza);
		$('#usuarioAutoriza').val(parametrosBean.numeroUsuario); 
		if( estatus != undefined){
			$("#estatus").val(estatus);
		}
	});
	
	$('#adjuntar').click(function() {	
		subirArchivos();
	});
	
	
	/*esta funcion esta en forma.js, verifica que el mensaje d error o exito aparezcan correctamente y que realizara despues de cada caso */
	$.validator.setDefaults({		
	    submitHandler: function(event) { 
	    	var numTransaccion = $("#tipoTransaccion").val();
	    	var status = $('input:radio[name=autorizar]:checked').val();
	    	if(numTransaccion == 3 && status == undefined){
				mensajeSis("Especifique si desea Autorizar o Rechazar la solicitud de apoyo escolar");
	    	}
	    	else{
	    		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','apoyoEscSolID',
		    			'funcionExitoApoyoEscolarSol','funcionFalloApoyoEscolarSol'); 
	    	}
		
	      }
	 });
	
	

	/* =============== VALIDACIONES DE LA FORMA ================= */
		$('#formaGenerica').validate({			
			rules: {
				apoyoEscCicloID :{
					required:true
				},
				cicloEscolar : {
					required: true,
					maxlength: 50
				},
				gradoEscolar : {
					required : true,
					number : true,
					min:	1
				},
				promedioEscolar: {
					required: true,
					maxlength : 6,
					number: true,
					min: 0,
					max: 100
				},
				nombreEscuela : {
					required : true,
					maxlength : 200
				},
				direccionEscuela : {
					required : true,
					maxlength : 500
				},
				comentario : {
					required: function() {return $('#tipoTransaccion').val() == 3 &&  $('input:radio[name=autorizar]:checked').val()=='X';},
					maxlength : 300
				}
			},		
			messages: {
				apoyoEscCicloID :{
					required:'Especificar Grado Escolar.'
				},
				cicloEscolar : {
					required: 'Especificar Ciclo Escolar.',
					maxlength: 'Máximo 50 Caracteres.'
				},
				gradoEscolar : {
					required : 'Especificar Número de Grado Escolar.',
					number : 'Solo Números.',
					min:	'Mayor o Igual a 1.'
				},
				promedioEscolar: {
					required: 'Especificar Promedio Escolar.',
					maxlength : 'Máximo 6 Caracteres.',
					number: 'Sólo números',
					min: 'Mayor a cero',
					max: 'Menor o igual a 100'	
				},
				nombreEscuela : {
					required : 'Especificar Nombre de Escuela.',
					maxlength : 'Máximo 200 Caracteres.'
				},
				direccionEscuela : {
					required : 'Especificar Dirección de Escuela.',
					maxlength : 'Máximo 500 Caracteres.'
				},
				comentario : {
					required : 'Ingrese Comentario.',
					maxlength: 'Máximo 300 Caracteres.'
				}
			}		
		});

		
		
/* =================== FUNCIONES ========================= */
	

		/* Consulta el cliente */
		function consultaCliente(idControl) {
			var jqCliente = eval("'#" + idControl + "'");
			var numCliente = $(jqCliente).val();
			var tamanio = $(jqCliente).val().length;
			setTimeout("$('#cajaLista').hide();", 200);
			
			
			// si no esta vacio y es un numero ejecutara la consulta del cliente
			if (numCliente != '' && !isNaN(numCliente) && parseInt(tamanio) < 11) {				
				//constulta un cliente
				clienteServicio.consulta(15, numCliente, function(cliente) {
					//si el resultado obtenido de la consulta regreso un resultado
					if (cliente != null) {
						$("#datosCliente").show();						
						
						consultaSucursal('sucursalID',cliente.sucursalOrigen);
						switch(cliente.tipoPersona){
							case 'F':
								$('#tipoPersona').val("FÍSICA");
								break;
							case 'A':
								$('#tipoPersona').val(" FÍSICA ACT. EMP.");
								break;
							default:
								mensajeSis("El tipo de persona no existe.");
						}
						//coloca los valores del resultado en sus campos correspondientes
						$('#clienteID').val(cliente.numero);
						$('#clienteIDDes').val(cliente.nombreCompleto);
						$('#sucursalID').val(cliente.sucursalOrigen);
						$('#fechaIngreso').val(cliente.fechaAlta);
						$('#fechaNacimiento').val(cliente.fechaNacimiento);	
						$('#edadCliente').val(cliente.edad);
						$('#RFC').val(cliente.RFC);	
						
						//si el cliente es menor de edad
						if(cliente.edad<18){
							consultaTutor();
						}
						
						// muestra su historial de solicitudes
						mostrarGridsolicitudes();
						habilitaControl();
						
					} else {
						mensajeSis('El cliente no cumple los requerimientos para Solicitar Apoyo Escolar.');
						$(jqCliente).focus();
						$(jqCliente).val("");
						$('#clienteIDDes').val("");
						$("#datosCliente").hide();
						$("#datosTutor").hide();
						$("#datosSolicitud").hide();
						$("#datosApoyoEscolar").hide();
						$("#datosApoyoEscolarReg").hide();
						$("#autorizar").hide();
						inicializaForma('formaGenerica', 'clienteID');
					}
				});
			}
			else {				
				//$(jqCliente).focus();
				//$(jqCliente).val("");
				$('#clienteIDDes').val("");
				$("#datosCliente").hide();
				$("#datosTutor").hide();
				$("#datosSolicitud").hide();
				$("#datosApoyoEscolar").hide();
				$("#datosApoyoEscolarReg").hide();
				$("#autorizar").hide();
				inicializaForma('formaGenerica', 'clienteID');
			}
		}
		
		
		/* Consulta los datos de una solicitud de apoyo escolar */
		function consultaSolicitudApoyoEsc(idControl) {
			var numCliente = $('#clienteID').val();
			var numSolicitud = $('#apoyoEscSolID').val();
			setTimeout("$('#cajaLista').hide();", 200);
			
			var tipoCon = 2;
			var apoyoEscSolBean = {
					'clienteID'	: numCliente,
					'apoyoEscSolID'	:numSolicitud
			};
			
			// si no esta vacio es un numero ejecutara la consulta
			if (numSolicitud != '' && !isNaN(numSolicitud)) {	
				if (numSolicitud == '0') {			
					habilitaBoton('agregar', 'submit');
					deshabilitaBoton('grabar', 'submit');
					deshabilitaBoton('modificar', 'submit');
					
					$("#datosSolicitud").hide();
					$("#autorizar").hide();
					$("#datosApoyoEscolar").show();
					$("#documentosAdjuntos").hide();
					
					$('#apoyoEscCicloID').val("0").selected = true;
					$('#cicloEscolar').val("");
					$('#gradoEscolar').val("");
					$('#promedioEscolar').val("");
					$('#nombreEscuela').val("");
					$('#direccionEscuela').val("");
					
					$('#apoyoEscCicloID').focus();
					
				} else {
					apoyoEscolarSolServicio.consulta(tipoCon, apoyoEscSolBean, function(solicitud) {
						if (solicitud != null) {
							var numCliente =  $("#clienteID").val();
							if(solicitud.clienteID == numCliente){
									$("input:radio").attr("checked", false);
									$("#datosSolicitud").show();
									consultaArchivosCliente();
									//coloca los valores del resultado en sus campos correspondientes
									dwr.util.setValues(solicitud);	
									$('#usuarioRegistra').focus();
									
									deshabilitaBoton('agregar', 'submit');
									$("#datosApoyoEscolar").show();	
									$("#documentosAdjuntos").show();
									
									if(solicitud.estatus=='R'){										
										$('#estatus').val('REGISTRADA');
										if(parametrosBean.perfilUsuario == $("#rolAutoriza").val()){
											$("#autorizar").show();
										}
										habilitaBoton('adjuntar', 'submit');									
										habilitaBoton('modificar', 'submit');								
										habilitaBoton('grabar', 'submit');
									}
									else{
										if(solicitud.estatus=='A'){	
											$('#estatus').val('AUTORIZADA');
										}
										if(solicitud.estatus=='X'){	
											$('#estatus').val('RECHAZADA');
										}
										if(solicitud.estatus=='P'){	
											$('#estatus').val('PAGADA');
										}
										
										deshabilitaBoton('modificar', 'submit');
										$("#datosApoyoEscolarReg").show();
										$("#autorizar").hide();
									}									
									
							}
							else{
								mensajeSis('La solicitud de apoyo escolar no pertenece al cliente.');
								$("#apoyoEscSolID").focus();
								$("#apoyoEscSolID").val("");
								$("#datosSolicitud").hide();
								$("#datosApoyoEscolar").hide();							
								$("#autorizar").hide();
								deshabilitaBoton('modificar', 'submit');
								deshabilitaBoton('agregar', 'submit');
								deshabilitaBoton('grabar', 'submit');
							}
							
						} else {
							mensajeSis('La solicitud de apoyo escolar no existe.');
							$("#apoyoEscSolID").focus();
							$("#apoyoEscSolID").val("");
							$("#datosSolicitud").hide();
							$("#datosApoyoEscolar").hide();							
							$("#autorizar").hide();
							deshabilitaBoton('modificar', 'submit');
							deshabilitaBoton('agregar', 'submit');
							deshabilitaBoton('grabar', 'submit');
						}
					});
				
				}
			}
			else {
			}
		}
			
		
		
		/* Consulta la sucursal  */
		function consultaSucursal(idControl,numSucursal) {		
			var tipoConsulta = 2;
			setTimeout("$('#cajaLista').hide();", 200);
			
			if (numSucursal != '' && !isNaN(numSucursal)) {			
				sucursalesServicio.consultaSucursal(tipoConsulta,numSucursal, function(sucursal) {
					if (sucursal != null) {
						$('#sucursalIDDes').val(sucursal.nombreSucurs);						
					} else {
						mensajeSis("No Existe la Sucursal");
					}
				});
			}
		}	
		
		
		/* Consulta datos de tutor  cuando el cliente es menor de edad*/
			function consultaTutor() {
				var numCliente = $('#clienteID').val();			
				var tipoConsulta = 12;
				setTimeout("$('#cajaLista').hide();", 200);
			
				if (numCliente != '') {				
					socioMenorServicio.consultaTutor(tipoConsulta,numCliente, function(tutor) {
						if (tutor != null) {
							$("#datosTutor").show();
							$('#tutorID').val(tutor.clienteTutorID);	
							$('#tutorIDDes').val(tutor.nombreTutor);	
							$('#parentesco').val(tutor.parentescoTutor);	
						} else {
							$("#datosTutor").hide();
							mensajeSis("El cliente No tiene Registrado un Tutor");
						}
					});
				}
			}
			
			
			/* Consulta los tipos de apoyo escolar por ciclo */
			function consultaTiposApoyo(){
				var bean={
					'apoyoEscCicloID' :0,
					'descripcion'	:''
				};


				dwr.util.removeAllOptions('apoyoEscCicloID'); 
				dwr.util.addOptions('apoyoEscCicloID', {'':'SELECCIONAR'}); 
				apoyoEscCicloServicio.listaCombo(1,bean, function(tiposApoyo){
					dwr.util.addOptions('apoyoEscCicloID', tiposApoyo, 'apoyoEscCicloID', 'descripcion');
				});
			}
			
			
			// funcion para consultar el historial de solicitudes de apoyo escolar */
			function mostrarGridsolicitudes(){
				var numRenglones;
				$("#datosApoyoEscolarReg").show();
				
				
					var params = {};
					params['tipoLista'] = 1;
					params['clienteID'] = $("#clienteID").val();
					params['apoyoEscSolID'] = '';
					
					        
					$.post("gridListaApoyoEscolarSol.htm", params, function(solicitudes){
						$('#listaSolicitudes').html(solicitudes);
						numRenglones  = consultaFilas(); 
						
						if( numRenglones >0) {							
							$('#listaSolicitudes').show();	
						}else{							
							$("#datosApoyoEscolarReg").hide();
							$('#listaSolicitudes').html('');
						}
					});
				}

			
			/*consulta de parametros caja solo los parametros de apoyo escolar para obtener el perfil para autorizar las solicitudes */
			function consultaPerfilAutoriza() {
					var numEmpresaID = 1;
					var tipoCon = 1;
					var ParametrosCajaBean = {
							'empresaID'	:numEmpresaID
					};
					
					setTimeout("$('#cajaLista').hide();", 200);		
					
					parametrosCajaServicio.consulta(tipoCon,ParametrosCajaBean,function(parametros) {
						if (parametros != null) {
							$("#rolAutoriza").val(parametros.rolAutoApoyoEsc);							
						}
						else{
							mensajeSis('Error al consultar el perfil de usuario para autorizar solicitud de apoyo escolar.');
						}
					});
			}
			
			/* sube un archivo digital al servidor */
			function subirArchivos() {
				var ventanaArchivosCliente ="";
				var url ="clientesArchivosUploadVista.htm?Cte="+$('#clienteID').val()+"&td="+'55'+"&pro="+'0'+"&instrumento="+$('#apoyoEscSolID').val();
				var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
				var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;
				ventanaArchivosCliente = window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
												"left="+leftPosition+
												",top="+topPosition+
												",screenX="+leftPosition+
												",screenY="+topPosition);	
			}
			
			
	});//

/* muestra el grid con los documentos adjuntos para la solicitud de apoyo escolar del cliente */
function consultaArchivosCliente(){
	if($('#clienteID').val()!=null || $('#clienteID').val()!='' || $('#prospectoID').val()!=null || $('#prospectoID').val()!=''){
		var params = {};
		params['tipoLista'] = 2;
		params['clienteID'] = $('#clienteID').val();
		params['prospectoID'] = '0';
		params['tipoDocumento'] =Var_TipoDocumento;
		params['instrumento'] = $('#apoyoEscSolID').val(); 
		
		$.post("documentosClienteGridGeneral.htm", params, function(listaArchivos){		
				if(listaArchivos.length >0) {
					$('#gridDocumentosAdjuntos').html(listaArchivos);
					$('#gridDocumentosAdjuntos').show();
					if($("#estatus").val() != 'REGISTRADA'){
						deshabilitaBotonesEliminaArchivoCte();
					}
				}else{
					$('#gridDocumentosAdjuntos').html("");
					$('#gridDocumentosAdjuntos').show();
				}
		});
	}
}


/*funcion para eliminar el documento digitalizado */
function  eliminaArchivo(folioDocumento){
	var bajaFolioDocumentoCliente = 1;
	var clienteArchivoBean = {
		'clienteID'	:$('#clienteID').val(),
		'clienteArchivosID'	:folioDocumento
	};
	$('#mensaje').html('<img src="images/barras.jpg" alt=""/>');   
	$('#contenedorForma').block({
			message: $('#mensaje'),
		 	css: {border:		'none',
		 			background:	'none'}
	});
	clienteArchivosServicio.bajaArchivosCliente(bajaFolioDocumentoCliente, clienteArchivoBean, function(mensajeTransaccion) {
		if(mensajeTransaccion!=null){
			mensajeSis(mensajeTransaccion.descripcion);
			$('#contenedorForma').unblock(); 
			consultaArchivosCliente();

		}else{				
			mensajeSis("Ocurrio un Error al Borrar el Documento");			
		}
	});
}	


/* muestra en pantalla o descarga uno de los archivos adjuntos mostrados en la pantalla grid */
function verArchivosCliente(id, idTipoDoc, idarchivo,recurso) {
	var varClienteVerArchivo = $('#clienteID').val();
	var varTipoDocVerArchivo = idTipoDoc;
	var varTipoConVerArchivo = 10;
	var parametros = "?clienteID="+varClienteVerArchivo+"&prospectoID="+'0'+"&tipoDocumento="+
		varTipoDocVerArchivo+"&tipoConsulta="+varTipoConVerArchivo+"&recurso="+recurso;

	var pagina="clientesVerArchivos.htm"+parametros;
	var idrecurso = eval("'#recursoCteInput"+ id+"'");
	var extensionArchivo=  $(idrecurso).val().substring( $(idrecurso).val().lastIndexOf('.'));
	extensionArchivo = extensionArchivo.toLowerCase();
	if(extensionArchivo==".jpg" || extensionArchivo == ".png" || extensionArchivo == ".jpeg" || extensionArchivo == ".gif"){
		$('#imgCliente').attr("src",pagina); 		
		$('#imagenCte').html(); 
		 // $.blockUI({message: $('#imagenCte')}); 
		  $.blockUI({message: $('#imagenCte'),
			   css: { 
           top:  ($(window).height() - 400) /2 + 'px', 
           left: ($(window).width() - 400) /2 + 'px', 
           width: '400px' 
       } });  
		  $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
	}else{
		window.location=pagina;
		$('#imagenCte').hide();
	}	
}


/* Consulta el numero de filas de la tabla grid */
function consultaFilas(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
		totales++;
		
	});
	return totales;
}


// funcion para consultar el historial de solicitudes de apoyo escolar despues de una transaccion */
function mostrarGridsolicitudesPos(){
	var numRenglones;
	$("#datosApoyoEscolarReg").show();
	
	
		var params = {};
		params['tipoLista'] = 1;
		params['clienteID'] = $("#clienteID").val();
		params['apoyoEscSolID'] = '';
		
		        
		$.post("gridListaApoyoEscolarSol.htm", params, function(solicitudes){
			$('#listaSolicitudes').html(solicitudes);
			numRenglones  = consultaFilas(); 
			
			if( numRenglones >0) {							
				$('#listaSolicitudes').show();	
			}else{							
				$("#datosApoyoEscolarReg").hide();
				$('#listaSolicitudes').html('');
			}
		});
	}


/* deshabilita los botones (eliminar) del grid de archivos adjuntos */
function deshabilitaBotonesEliminaArchivoCte(){	
	$('tr[name=trArchivosCte]').each(function() {
		var numero= this.id.substr(13,this.id.length);
		var idCampo = eval("'elimina"+numero+"'");	
		deshabilitaControl(idCampo);
	});
	deshabilitaBoton('adjuntar', 'submit');
}

function funcionExitoApoyoEscolarSol(){
	inicializaForma('formaGenerica', 'apoyoEscSolID');	
	$("#autorizar").hide();
	$("#datosSolicitud").hide();
	$("#datosApoyoEscolar").hide();
	
	deshabilitaBoton('modificar', 'submit');
	deshabilitaBoton('agregar', 'submit');
	deshabilitaBoton('grabar', 'submit');
	mostrarGridsolicitudesPos();
}

function funcionFalloApoyoEscolarSol(){
	//inicializaForma('formaGenerica', 'clienteID');
}
			
