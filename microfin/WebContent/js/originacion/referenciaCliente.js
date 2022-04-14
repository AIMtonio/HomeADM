var esTab = false;
var isFlujo=false;
var parametroBean = consultaParametrosSession();
var usuario = parametroBean.numeroUsuario;
var estatusSol;
var catTipoConsultaSolicitud = {
'principal' : 1,
'foranea' : 2
};
$(document).ready(function() {
	if($('#numSolicitud').val() != undefined && $('#numSolicitud').asNumber()>0 ){
		var numSolicitud=  $('#numSolicitud').val();
		$('#solicitudCreditoID').val(numSolicitud);
		$('#solicitudCreditoID').focus();
		isFlujo=true;
	}
	
	$('#solicitudCreditoID').focus();
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('grabaReferencias', 'submit');
	agregaFormatoControles('formaGenerica');
	$("#numTab").val(4);
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});

	$(':text').focus(function() {
		esTab = false;
	});

	$('#solicitudCreditoID').bind('keyup', function(e) {
		if (this.value.length >= 0) {
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#solicitudCreditoID').val();
			lista('solicitudCreditoID', '1', '1', camposLista, parametrosLista, 'listaSolicitudCredito.htm');
		}
	});
	$('#solicitudCreditoID').blur(function() {
		if ($('#solicitudCreditoID').asNumber() > 0 && esTab == true) {
			consultaSolicitudCredito($('#solicitudCreditoID').asNumber());
		}
	});
	$('#formaGenerica').validate({
		rules: {
			solicitudCreditoID:{
				required: true
				}
		},
		messages: {
			solicitudCreditoID:{
				required: 'Especificar la Solicitud de Crédito.',
			}
		}
	});
	
	$('#grabaReferencias').click(function(event){
		 $("#gridDetalleDiv input[name^='primerNombre']").each(function(){
	 	        $(this).rules("add", {
	 	            required: true,
	 	            maxlength: 50,
	 	            messages: {
	 	               required: "Especificar Primer Nombre.",
	 	               maxlength: 'Máximo 50 Caracteres.'
	 	            }
	 	        } );            
	 	    });
		 $("#gridDetalleDiv input[name^='apellidoPaterno']").each(function(){
	 	        $(this).rules("add", {
	 					required: true,
	 					maxlength: 50,
	 	            messages: {
	 	            	required: 'Especificar Apellido Paterno.',
	 	               maxlength: 'Máximo 50 Caracteres.'
	 	            }
	 	        } );            
	 	    });
		 $("#gridDetalleDiv input[name^='telefono']").each(function(){
	 	        $(this).rules("add", {
	 	        	required: true,
					maxlength: 20,
	 	            messages: {
	 	            	required: 'Especificar Teléfono.',
	 					maxlength: 'Máximo 20 Caracteres.'
	 	            }
	 	        } );            
	 	    });
		 $("#gridDetalleDiv input[name^='extTelefonoPart']").each(function(){
	 	        $(this).rules("add", {
	 	        	numeroPositivo: true,
					maxlength: 7,
	 	            messages: {
	 	            	numeroPositivo: 'Solo números.',
	 					maxlength: 'Máximo 7 Caracteres.'
	 	            }
	 	        } );            
	 	    });
		 $("#gridDetalleDiv input[name^='validado']").each(function(){
	 	        $(this).rules("add", {
	 	        	required: function(){if($("#tipoClasificacion").val()=="M"){return false}else{return true}},
	 	            messages: {
	 	            	required: 'Especificar.'
	 	            }
	 	        } );            
	 	    });
		 $("#gridDetalleDiv input[name^='interesado']").each(function(){
	 	        $(this).rules("add", {
	 	        	required: function(){if($("#tipoClasificacion").val()=="M"){return false}else{return true}},
	 	            messages: {
	 	            	required: 'Especificar.'
	 	            }
	 	        } );            
	 	    });
		 $("#gridDetalleDiv input[name^='tipoRelacionID']").each(function(){
				$(this).rules("add", {
					required: function(){if($("#tipoClasificacion").val()=="M"){return false}else{return true}},
					numeroPositivo: true,
					messages: {
						required: 'Especificar el tipo de Relación.',
						numeroPositivo: 'Solo números.'
					}
				});
			});
			$("#gridDetalleDiv input[name^='estadoID']").each(function(){
				$(this).rules("add", {
					required: function(){if($("#tipoClasificacion").val()=="M"){return false}else{return true}},
					numeroPositivo: true,
					messages: {
						required: 'Especificar Estado.',
						numeroPositivo: 'Solo números.'
					}
				});
			});
			$("#gridDetalleDiv input[name^='municipioID']").each(function(){
				$(this).rules("add", {
					required: function(){if($("#tipoClasificacion").val()=="M"){return false}else{return true}},
					numeroPositivo: true,
					messages: {
						required: 'Especificar Municipio.',
						numeroPositivo: 'Solo números.'
					}
				});
			});
				$("#gridDetalleDiv input[name^='localidadID']").each(function(){
					$(this).rules("add", {
						required: function(){if($("#tipoClasificacion").val()=="M"){return false}else{return true}},
						numeroPositivo: true,
						messages: {
							required: 'Especificar Localidad.',
							numeroPositivo: 'Solo números.'
						}
					});
				});
				$("#gridDetalleDiv input[name^='coloniaID']").each(function(){
					$(this).rules("add", {
						required: function(){if($("#tipoClasificacion").val()=="M"){return false}else{return true}},
						numeroPositivo: true,
						messages: {
							required: 'Especificar Colonia.',
							numeroPositivo: 'Solo números.'
						}
					});
				});
				$("#gridDetalleDiv input[name^='calle']").each(function(){
					$(this).rules("add", {
						required: function(){if($("#tipoClasificacion").val()=="M"){return false}else{return true}},
						maxlength: 50,
						messages: {
							required: 'Especificar Calle.',
							maxlength: 'Máximo 50 Caracteres.'
						}
					});
				});
				$("#gridDetalleDiv input[name^='numeroCasa']").each(function(){
					$(this).rules("add", {
						required: function(){if($("#tipoClasificacion").val()=="M"){return false}else{return true}},
						maxlength: 10,
						messages: {
							required: 'Especificar el Número Exterior.',
							maxlength: 'Máximo 10 Caracteres.'
						}
					});
				});
				$("#gridDetalleDiv input[name^='numInterior']").each(function(){
					$(this).rules("add", {
						maxlength: 10,
						messages: {
							maxlength: 'Máximo 10 Caracteres.'
						}
					});
				});
				$("#gridDetalleDiv input[name^='piso']").each(function(){
					$(this).rules("add", {
						numeroPositivo: true,
						maxlength: 50,
						messages: {
							numeroPositivo: 'Solo números.',
							maxlength: 'Máximo 50 Caracteres.'
						}
					});
				});
				$("#input[name^='cp']").each(function(){
					$(this).rules("add", {
						required: function(){if($("#tipoClasificacion").val()=="M"){return false}else{return true}},
						numeroPositivo: true,
						maxlength: 5,
						messages: {
							required: 'Especificar C.P.',
							numeroPositivo: 'Solo números.',
							maxlength: 'Máximo 5 Caracteres.'
						}
					});
				});
				detalle();
				if ($("#formaGenerica").valid()) {
					//$("#formaGenerica").submit();
					grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','solicitudCreditoID','funcionExito',
	    			'funcionError');
				}
	});
	
});

function inicializarSolicitud(){
	//inicializaForma('formaGenerica', 'solicitudCreditoID');
	$('#solicitudCreditoID').focus();
	$('#solicitudCreditoID').select();
	deshabilitaBoton('agregar', 'submit');
	deshabilitaBoton('grabaReferencias', 'submit');
}
/**
 * Lista detipo derelacion
 * @param idControl
 */
function listaTipoRelacion(idControl){
	var jqControl = eval("'#" + idControl + "'");
	var valor = $(jqControl).val();
	if (valor.length >= 2) {
		lista(idControl, '2', '1', 'descripcion', valor, 'listaParentescos.htm');
	}
}
function listaEstado(idControl){
	var jqControl = eval("'#" + idControl + "'");
	var valor = $(jqControl).val();
	if (valor.length >= 2) {
		lista(idControl, '2', '1', 'nombre',valor,'listaEstados.htm');
	}
}
function listaLocalidad(idControl,num){
	var jqControl = eval("'#" + idControl + "'");
	var valor = $(jqControl).val();
	var camposLista = new Array();
	var parametrosLista = new Array();
	
	camposLista[0] = "estadoID";
	camposLista[1] = 'municipioID';
	camposLista[2] = "nombreLocalidad";

	parametrosLista[0] = $('#estadoID'+num).val();
	parametrosLista[1] = $('#municipioID'+num).val();
	parametrosLista[2] = $('#localidadID'+num).val();
	
	lista(idControl, '2', '1', camposLista, parametrosLista,'listaLocalidades.htm');
}

function listaColonias(idControl,num){
	var camposLista = new Array();
	var parametrosLista = new Array();
	
	camposLista[0] = "estadoID";
	camposLista[1] = 'municipioID';
	camposLista[2] = "asentamiento";		
	
	parametrosLista[0] = $('#estadoID'+num).val();
	parametrosLista[1] = $('#municipioID'+num).val();
	parametrosLista[2] = $('#coloniaID'+num).val();
	
	lista(idControl, '2', '1', camposLista, parametrosLista,'listaColonias.htm');
}

function listaMunicipio(idControl,num){
	var camposLista = new Array();
	var parametrosLista = new Array();
	camposLista[0] = "estadoID";
	camposLista[1] = "nombre";
	parametrosLista[0] = $('#estadoID'+num).val();
	parametrosLista[1] = $('#municipioID'+num).val();
	
	lista(idControl, '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
	
}

/**
 * Consulta de la solicitud de crédito
 * @param solicitudCreditoID
 */
function funcionconsultacliente(clienteID){
	
	clienteServicio.consulta(1,clienteID,	function(cliente){
		 if(cliente!=null){
			$("#tipoClasificacion").val(cliente.clasificacion);
		 }
	});
}
function consultaSolicitudCredito(solicitudCreditoID) {
	
	var SolCredBeanCon = {
	'solicitudCreditoID' : solicitudCreditoID,
	'usuario' : usuario
	};
	estatusSol='';
	solicitudCredServicio.consulta(catTipoConsultaSolicitud.principal, SolCredBeanCon, function(solicitud) {
		if (solicitud != null) {
			dwr.util.setValues(solicitud);
			if(solicitud.nombreCompletoCliente!=null && solicitud.nombreCompletoCliente!=''){
				$("#nombreCte").val(solicitud.nombreCompletoCliente);
				$("#tipoClasificacion").val(solicitud.clasifiDestinCred);
			} else {
				$("#nombreCte").val(solicitud.nombreCompletoProspecto);
				$("#tipoClasificacion").val(solicitud.clasifiDestinCred);
			}
			consultaProducCreditoForanea(solicitud.productoCreditoID);
			consultaReferenciasSolicitud(solicitud.solicitudCreditoID);
			estatusSol=solicitud.estatus;
			var clienteID = solicitud.clienteID;
			funcionconsultacliente(clienteID);
		} else {
			mensajeSis("La Solicitud de Credito No existe.");
			inicializarSolicitud();
		}
	});
}

function consultaReferenciasSolicitud(solicitudCreditoID){
	var params = {};
	params['tipoLista'] = 1;
	params['solicitudCreditoID'] = solicitudCreditoID;
	
	$.post("referenciaClienteGridVista.htm", params, function(data) {
		if (data.length > 0) {
			$('#gridDetalleDiv').html(data);
			$('#gridDetalleDiv').show();
			agregaFormatoControles('gridDetalleDiv');
			$("#gridDetalleDiv input[name^='telefono']").each(function(){
				setTelefonoMask(this.id);
			});
			habilitaBoton('grabaReferencias', 'submit');
			if(estatusSol==="I"){
				habilitaBoton('agrega', 'submit');
				habilitaBoton('grabaReferencias', 'submit');
				$("#agrega").focus();
			} else {
				deshabilitaBoton('agrega', 'submit');
				deshabilitaBoton('grabaReferencias', 'submit');
			}
		} else {
			$("#numTab").val(4);
			$('#gridDetalleDiv').html("");
			$('#gridDetalleDiv').show();
			if(estatusSol==="I"){
				habilitaBoton('agrega', 'submit');
				habilitaBoton('grabaReferencias', 'submit');
				$("#agrega").focus();
			} else {
				deshabilitaBoton('agrega', 'submit');
				deshabilitaBoton('grabaReferencias', 'submit');
			}
		}
	});
	
	
}


/**
 * Consulta del producto de crédito
 * @param producto
 * @param varfecha
 */
function consultaProducCreditoForanea(producto) {
	var ProdCredBeanCon = {
		'producCreditoID' : producto
	};

	if (producto != '' && !isNaN(producto)) {
		productosCreditoServicio.consulta(catTipoConsultaSolicitud.principal, ProdCredBeanCon, function(prodCred) {
			if (prodCred != null) {
				$('#descripProducto').val(prodCred.descripcion);

			} else {
				mensajeSis("No Existe el Producto de Credito.");
				inicializarSolicitud();
			}
		});
	}
}
/**
 * Consulta la descripcion de la relacion del cliente
 * @param idControl
 */
function consultaParentesco(idControl,num) {
	var jqParentesco = eval("'#" + idControl + "'");
	var numParentesco = $(jqParentesco).val();
	var tipConPrincipal = 1;
	setTimeout("$('#cajaLista').hide();", 200);
	var ParentescoBean = {
			'parentescoID' : numParentesco
	};
	if (numParentesco != '' && !isNaN(numParentesco)) {
		parentescosServicio.consultaParentesco(tipConPrincipal, ParentescoBean, function(parentesco) {
					if (parentesco != null) {
						$('#descripcionRelacion'+num).val(parentesco.descripcion);
					} else {
						mensajeSis("No Existe el Parentesco.");
						$(jqParentesco).focus();
						$(jqParentesco).val("");
					}
				});
	}
}

/**
 * Consulta Estado
 * @param idControl
 */
function consultaEstadoNac(idControl, num) {
	var jqEstado = eval("'#" + idControl + "'");
	var numEstado = $(jqEstado).val();
	var tipConForanea = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	if (numEstado != '' && !isNaN(numEstado)) {
		estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
			if (estado != null) {
				$('#nombreEstado'+num).val(estado.nombre);
			} else {
				mensajeSis("No Existe el Estado.");
				$(jqEstado).focus();
				$(jqEstado).val("");
			}
		});
	}
	consultaDirecCompleta(num);
}

function consultaMunicipio(idControl,num) {
	var jqMunicipio = eval("'#" + idControl + "'");
	var numMunicipio = $(jqMunicipio).val();	
	var numEstado =  $('#estadoID'+num).val();				
	var tipConForanea = 2;	
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numMunicipio != '' && !isNaN(numMunicipio) && numEstado != '' && !isNaN(numEstado)){
		municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
			if(municipio!=null){							
				$('#nombreMuni'+num).val(municipio.nombre);
			}else{
				mensajeSis('No Existe el Municipio.');
				$('#nombreMuni'+num).val('');
				$('#municipioID'+num).val('');
				$('#municipioID'+num).focus();
			}    	 						
		});
	}
	consultaDirecCompleta(num);
}

function consultaLocalidad(idControl,num) {
	var jqLocalidad = eval("'#" + idControl + "'");
	var numLocalidad = $(jqLocalidad).val();
	var numMunicipio =	$('#municipioID'+num).val();
	var numEstado =  $('#estadoID'+num).val();				
	var tipConPrincipal = 1;	
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numLocalidad != '' && !isNaN(numLocalidad) && numEstado != '' && !isNaN(numEstado) && numMunicipio != '' && !isNaN(numMunicipio)){
		localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad,function(localidad) {
			if(localidad!=null){	
				$('#nombreLocalidad'+num).val(localidad.nombreLocalidad);
			}else{
				mensajeSis("No Existe la Localidad.");
				$('#nombreLocalidad'+num).val("");
				$('#localidadID'+num).val("");
				$('#localidadID'+num).focus();
			}    	 						
		});
	}
	consultaDirecCompleta(num);
}

//consulta Colonia y CP
function consultaColonia(idControl, num) {
	var jqColonia = eval("'#" + idControl + "'");
	var numColonia= $(jqColonia).val();		
	var numEstado =  $('#estadoID'+num).val();	
	var numMunicipio =	$('#municipioID'+num).val();
	var tipConPrincipal = 1;	
	setTimeout("$('#cajaLista').hide();", 200);		
	if(numColonia != '' && !isNaN(numColonia) && numEstado != '' && !isNaN(numEstado) && numMunicipio != '' && !isNaN(numMunicipio)){
		coloniaRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numColonia,function(colonia) {
			if(colonia!=null){							
				$('#nombreColonia'+num).val(colonia.asentamiento);
				if($('#cp'+num).val()==''||colonia.codigoPostal!=''){
					$('#cp'+num).val(colonia.codigoPostal);
				}
			}else{
				mensajeSis('No Existe la Colonia.');
				$('#coloniaID'+num).focus();
				$('#nombreColonia'+num).val('');
				$('#coloniaID'+num).val('');
			}    	 						
		});
	}else{
		$('#nombreColonia'+num).val("");
	}
	consultaDirecCompleta(num);
}

function consultaDirecCompleta(num) {
	var ca = $('#calle'+ num).val();
	var nu = $('#numeroCasa'+ num).val();
	var ni = $('#numInterior'+ num).val();
	var pis = $('#piso' + num).val();
	var co = $('#nombreColonia' + num).val();
	var cp = $('#cp' + num).val();
	var nm = $('#nombreMuni' + num).val();
	var ne = $('#nombreEstado' + num).val();

	var dirCom = ca;
	if (nu != '') {
		dirCom = (dirCom + ", No. " + nu);
	}
	if (ni != '') {
		dirCom = (dirCom + ", INTERIOR " + ni);
	}
	if (pis != '') {
		dirCom = (dirCom + ", PISO " + pis);
	}
	if (co != '') {
		dirCom = (dirCom + ", COL. " + co);
	}
	dirCom = (dirCom + ", C.P. " + cp + ", " + nm + ", " + ne + ".");
	$('#direccionCompleta' + num).val(dirCom.toUpperCase());	
}

function eliminarDetalle(num){
	if(estatusSol==="I"){
		$("#trRefe"+num).remove();
	}
}
function agregarDetalle(){
	
	if(estatusSol==="I"){
		var numTab=$("#numTab").asNumber();
		numTab = numTab==0?4:numTab;
		var numReferencia=$("#numReferencia").asNumber();
		numTab++;
		numReferencia++;
		var nuevaFila = 
			"<tr id=\"trRefe"+numReferencia+"\">"
			+"<td>"
			+"<fieldset class=\"ui-widget ui-widget-content ui-corner-all\">"
			+"<table id=\"referencia"+numReferencia+"\" border=\"0\" width=\"100%\">"
			+"<tr>"
			+"<td class=\"label\" nowrap=\"nowrap\">"
			+"<input type=\"hidden\" name=\"numReferencia\" value=\""+numReferencia+"\"/>"
			+"<label for=\"primerNombre\">Primer Nombre:</label>"
			+"</td>"
			+"<td>"
			+"<input id=\"primerNombre"+numReferencia+"\" name=\"primerNombre"+numReferencia+"\" type=\"text\" tabindex=\""+(numTab++)+"\" maxlength=\"50\" size=\"50\" onBlur=\"ponerMayusculas(this)\"/>"
			+"</td>"
			+"<td class=\"separador\"></td>"
			+"<td class=\"label\" nowrap=\"nowrap\">"
			+"<label for=\"segundoNombre"+numReferencia+"\">Segundo Nombre: </label>"
			+"</td>"
			+"<td>"
			+"<input id=\"segundoNombre"+numReferencia+"\" name=\"segundoNombre"+numReferencia+"\" maxlength=\"50\" size=\"50\" type=\"text\" tabindex=\""+(numTab++)+"\"  onBlur=\" ponerMayusculas(this)\"/>"
			+"</td>"
			+"</tr>"
			+"<tr>"
			+"<td class=\"label\" nowrap=\"nowrap\">"
			+"<label for=\"tercerNombre"+numReferencia+"\">Tercer Nombre:</label>"
			+"</td>"
			+"<td>"
			+"<input id=\"tercerNombre"+numReferencia+"\" name=\"tercerNombre"+numReferencia+"\" tabindex=\""+(numTab++)+"\" maxlength=\"50\" size=\"50\" onBlur=\" ponerMayusculas(this)\" type=\"text\"/>"
			+"</td>"
			+"<td class=\"separador\"></td>"
			+"<td class=\"label\" nowrap=\"nowrap\">"
			+"<label for=\"apellidoPaterno"+numReferencia+"\">Apellido Paterno:</label>"
			+"</td>"
			+"<td>"
			+"<input id=\"apellidoPaterno"+numReferencia+"\" name=\"apellidoPaterno"+numReferencia+"\" maxlength=\"50\" tabindex=\""+(numTab++)+"\" size=\"50\" onBlur=\" ponerMayusculas(this)\" type=\"text\"/>"
			+"</td>"
			+"</tr>"
			+"<tr>"
			+"<td class=\"label\" nowrap=\"nowrap\">"
			+"<label for=\"apellidoMaterno"+numReferencia+"\">Apellido Materno:</label>"
			+"</td>"
			+"<td >"
			+"<input id=\"apellidoMaterno"+numReferencia+"\" name=\"apellidoMaterno"+numReferencia+"\" maxlength=\"50\" size=\"50\" tabindex=\""+(numTab++)+"\" onBlur=\" ponerMayusculas(this)\" type=\"text\"/>"
			+"</td>"
			+"<td class=\"separador\"></td>"
			+"<td class=\"label\">"
			+"<label for=\"tipoRelacionID"+numReferencia+"\">Tipo Relaci&oacute;n:</label>"
			+"</td>"
			+"<td nowrap=\"nowrap\">"
			+"<input id=\"tipoRelacionID"+numReferencia+"\" name=\"tipoRelacionID"+numReferencia+"\" size=\"6\" tabindex=\""+(numTab++)+"\" maxlength=\"20\" onkeypress=\"listaTipoRelacion(this.id)\" onBlur=\"consultaParentesco(this.id,"+numReferencia+")\" type=\"text\"/>&nbsp;"
			+"<input type=\"text\" id=\"descripcionRelacion"+numReferencia+"\" name=\"descripcionRelacion\" size=\"43\" disabled =\"true\" readOnly=\"true\"/>"
			+"</td>"
			+"</tr>"
			+"<tr>"
			+"<td class=\"label\" valign=\"top\">"
			+"<label for=\"telefono"+numReferencia+"\">Tel&eacute;fono:</label>"
			+"</td>"
			+"<td valign=\"top\">"
			+"<input id=\"telefono"+numReferencia+"\" name=\"telefono"+numReferencia+"\" size=\"20\" tabindex=\""+(numTab++)+"\" maxlength=\"10\" type=\"text\"/>"
			+"<label for=\"lblExt\">Ext.:</label>"
			+"<input id=\"extTelefonoPart"+numReferencia+"\" name=\"extTelefonoPart"+numReferencia+"\" size=\"10\" maxlength=\"7\" tabindex=\""+(numTab++)+"\" type=\"text\"/>"
			+"</td>"
			+"<td class=\"separador\"></td>"
			+"<td class=\"label\">"
			+"<label for=\"estadoID\">Entidad Federativa:</label>"
			+"</td>"
			+"<td>"
			+"<input id=\"estadoID"+numReferencia+"\" name=\"estadoID"+numReferencia+"\" size=\"6\" tabindex=\""+(numTab++)+"\" maxlength=\"20\" onkeypress=\"listaEstado(this.id)\" onBlur=\"consultaEstadoNac(this.id,"+numReferencia+");\" type=\"text\"/>&nbsp;"
			+"<input type=\"text\" id=\"nombreEstado"+numReferencia+"\" name=\"nombreEstado\" size=\"43\" disabled =\"true\" readOnly=\"true\"/>"
			+"</td>"
			+"</tr>"
			+"<tr>"
			+"<td class=\"label\">"
			+"<label for=\"municipioID"+numReferencia+"\">Municipio: </label>"
			+"</td>"
			+"<td>"
			+"<input id=\"municipioID"+numReferencia+"\" name=\"municipioID"+numReferencia+"\" size=\"6\" tabindex=\""+(numTab++)+"\" maxlength=\"20\" onkeypress=\"listaMunicipio(this.id,"+numReferencia+")\" onBlur=\"consultaMunicipio(this.id,"+numReferencia+");\" type=\"text\"/>&nbsp;"
			+"<input type=\"text\" id=\"nombreMuni"+numReferencia+"\" name=\"nombreMuni\" size=\"43\" disabled=\"true\" readOnly=\"true\"/>"
			+"</td>"
			+"<td class=\"separador\"></td>"
			+"<td class=\"label\">"
			+"<label for=\"localidadID"+numReferencia+"\">Localidad: </label>"
			+"</td>"
			+"<td>"
			+"<input id=\"localidadID"+numReferencia+"\" name=\"localidadID"+numReferencia+"\" size=\"6\" tabindex=\""+(numTab++)+"\" maxlength=\"20\" onkeypress=\"listaLocalidad(this.id,"+numReferencia+")\" onBlur=\"consultaLocalidad(this.id,"+numReferencia+");\" type=\"text\"/>&nbsp;"
			+"<input type=\"text\" id=\"nombreLocalidad"+numReferencia+"\" name=\"nombrelocalidad\" size=\"43\" disabled =\"true\" readOnly=\"true\"/>"
			+"</td>"
			+"</tr>"
			+"<tr>"
			+"<td class=\"label\">"
			+"<label for=\"coloniaID"+numReferencia+"\">Colonia: </label>"
			+"</td>"
			+"<td>"
			+"<input id=\"coloniaID"+numReferencia+"\" name=\"coloniaID"+numReferencia+"\" size=\"6\" tabindex=\""+(numTab++)+"\" maxlength=\"20\" onkeypress=\"listaColonias(this.id,"+numReferencia+")\" onBlur=\"consultaColonia(this.id,"+numReferencia+");\" type=\"text\"/>&nbsp;"
			+"<input type=\"text\" id=\"nombreColonia"+numReferencia+"\" name=\"nombreColonia"+numReferencia+"\" size=\"43\" disabled=\"true\" readOnly=\"true\"/>"
			+"</td>"
			+"<td class=\"separador\"></td>"
			+"<td class=\"label\">"
			+"<label for=\"calle\">Calle: </label>"
			+"</td>"
			+"<td>"
			+"<input id=\"calle"+numReferencia+"\" name=\"calle"+numReferencia+"\" size=\"50\" tabindex=\""+(numTab++)+"\" maxlength=\"50\" onBlur=\"ponerMayusculas(this);consultaDirecCompleta("+numReferencia+");\" type=\"text\"/>"
			+"</td>"
			+"</tr>"
			+"<tr>"
			+"<td class=\"label\">"
			+"<label for=\"numeroCasa"+numReferencia+"\">No. Exterior: </label>"
			+"</td>"
			+"<td nowrap=\"nowrap\">"
			+"<input id=\"numeroCasa"+numReferencia+"\" name=\"numeroCasa"+numReferencia+"\" size=\"6\" tabindex=\""+(numTab++)+"\" maxlength=\"10\" onBlur=\"ponerMayusculas(this);consultaDirecCompleta("+numReferencia+");\" type=\"text\"/>"
			+"<label for=\"numInterior"+numReferencia+"\">&nbsp;No. Interior: </label>"
			+"<input id=\"numInterior"+numReferencia+"\" name=\"numInterior"+numReferencia+"\" size=\"6\" tabindex=\""+(numTab++)+"\" maxlength=\"10\" onBlur=\"ponerMayusculas(this);consultaDirecCompleta("+numReferencia+");\" type=\"text\"/>"
			+"<label for=\"piso"+numReferencia+"\">&nbsp;Piso: </label>"
			+"<input id=\"piso"+numReferencia+"\" name=\"piso"+numReferencia+"\" size=\"6\" tabindex=\""+(numTab++)+"\"  onBlur=\"ponerMayusculas(this)\" type=\"text\"/>"
			+"</td>"
			+"<td class=\"separador\"></td>"
			+"<td class=\"label\">"
			+"<label for=\"cp"+numReferencia+"\">Código Postal: </label>"
			+"</td>"
			+"<td>"
			+"<input id=\"cp"+numReferencia+"\" name=\"cp"+numReferencia+"\" maxlength=\"5\" size=\"15\" tabindex=\""+(numTab++)+"\" onBlur=\"ponerMayusculas(this);consultaDirecCompleta("+numReferencia+");\" type=\"text\"/>"
			+"</td>"
			+"</tr>"
			+"<tr>"
			+"<td class=\"label\" valign=\"top\">"
			+"<label for=\"direccionCompleta"+numReferencia+"\">Domicilio:</label>"
			+"</td>"
			+"<td>"
			+"<textarea id=\"direccionCompleta"+numReferencia+"\" name=\"direccionCompleta"+numReferencia+"\" cols=\"47\" rows=\"3\" disabled =\"true\" readonly=\"true\" onBlur=\"ponerMayusculas(this)\" maxlength = \"500\" ></textarea>"
			+"</td>"
			+"<td class=\"separador\"></td>"
			+"<td class=\"label\" valign=\"top\">"
			+"<label for=\"validado"+numReferencia+"\">Validado: </label>"
			+"</td>"
			+"<td nowrap=\"nowrap\" valign=\"top\">"
			+"<input type=\"radio\" id=\"validado"+numReferencia+"\" name=\"validado"+numReferencia+"\" value=\"S\"  tabindex=\""+(numTab++)+"\" /><label>Si</label>"
			+"<input type=\"radio\" id=\"validado"+numReferencia+"\" name=\"validado"+numReferencia+"\" value=\"N\"  tabindex=\""+(numTab++)+"\" checked=\"true\"/><label>No</label>"
			+"</td>"
			+"</tr>"
			+"<tr>"
			+"<td class=\"label\">"
			+"<label for=\"interesado"+numReferencia+"\">Interesado: </label>"
			+"</td>"
			+"<td nowrap=\"nowrap\">"
			+"<input type=\"radio\" id=\"interesado"+numReferencia+"\" name=\"interesado"+numReferencia+"\" value=\"S\"  tabindex=\""+(numTab++)+"\" /><label>Si</label>"
			+"<input type=\"radio\" id=\"interesado"+numReferencia+"\" name=\"interesado"+numReferencia+"\" value=\"N\"  tabindex=\""+(numTab++)+"\" checked=\"true\"/><label>No</label>"
			+"</td>"
			+"</tr>"
			+"<tr>"
			+"<td nowrap=\"nowrap\" colspan=\"5\" align=\"right\">"
			+"<input type=\"button\" name=\"elimina\" value=\"\" class=\"btnElimina\" tabindex=\""+(numTab++)+"\" onclick=\"eliminarDetalle("+numReferencia+")\"/>"
			+"<input type=\"button\" name=\"agrega\" value=\"\" class=\"btnAgrega\" onclick=\"agregarDetalle()\" tabindex=\""+(numTab++)+"\"/>"
			+"</td>"
			+"</tr>"
			+"</table>"
			+"</fieldset>"
			+"<br></br>"
			+"</td>"
			+"</tr>";
		
		
		$("#tablaReferencias").append(nuevaFila);
		setTelefonoMask("telefono"+numReferencia);
		agregaFormatoControles('formaGenerica');
		$("#numTab").val(numTab);
		$("#numReferencia").val(numReferencia);
	}
}


function detalle(){
	var detail="";
	quitaFormatoControles('gridDetalleDiv');
	$('#detalle').val("");
	$('#tablaReferencias tr td fieldset table[id^="referencia"]').each(function(index) {
		if (index >= 0) {
			var primerNombre = $(this).find("input[name^=primerNombre]").val()!=''?$(this).find("input[name^=primerNombre]").val():'N/A';
			var segundoNombre = $(this).find("input[name^=segundoNombre]").val()!=''?$(this).find("input[name^=segundoNombre]").val():'N/A';
			var tercerNombre=$(this).find("input[name^=tercerNombre]").val()!=''?$(this).find("input[name^=tercerNombre]").val():'N/A';
			var apellidoPaterno=$(this).find("input[name^=apellidoPaterno]").val()!=''?$(this).find("input[name^=apellidoPaterno]").val():'N/A';
			var apellidoMaterno=$(this).find("input[name^=apellidoMaterno]").val()!=''?$(this).find("input[name^=apellidoMaterno]").val():'N/A';
			var telefono=$(this).find("input[name^=telefono]").val()!=''?$(this).find("input[name^=telefono]").val():'N/A';
			var extTelefonoPart=$(this).find("input[name^=extTelefonoPart]").val()!=''?$(this).find("input[name^=extTelefonoPart]").val():'N/A';
			var validado=$(this).find("input:radio[name^=validado]:checked").val()!=''?$(this).find("input:radio[name^=validado]:checked").val():'N/A';
			var interesado=$(this).find("input:radio[name^=interesado]:checked").val()!=''?$(this).find("input:radio[name^=interesado]:checked").val():'N/A';
			var tipoRelacionID=$(this).find("input[name^=tipoRelacionID]").val()!=''?$(this).find("input[name^=tipoRelacionID]").val():'N/A';
			var estadoID=$(this).find("input[name^=estadoID]").val()!=''?$(this).find("input[name^=estadoID]").val():'N/A';
			var municipioID=$(this).find("input[name^=municipioID]").val()!=''?$(this).find("input[name^=municipioID]").val():'N/A';
			var localidadID=$(this).find("input[name^=localidadID]").val()!=''?$(this).find("input[name^=localidadID]").val():'N/A';
			var coloniaID=$(this).find("input[name^=coloniaID]").val()!=''?$(this).find("input[name^=coloniaID]").val():'N/A';
			var calle=$(this).find("input[name^=calle]").val()!=''?$(this).find("input[name^=calle]").val():'N/A';
			var numeroCasa=$(this).find("input[name^=numeroCasa]").val()!=''?$(this).find("input[name^=numeroCasa]").val():'N/A';
			var numInterior=$(this).find("input[name^=numInterior]").val()!=''?$(this).find("input[name^=numInterior]").val():'N/A';
			var piso=$(this).find("input[name^=piso]").val()!=''?$(this).find("input[name^=piso]").val():'N/A';
			var cp=$(this).find("input[name^=cp]").val()!=''?$(this).find("input[name^=cp]").val():'N/A';
			if (index == 0) {
				$('#detalle').val($('#detalle').val() + 
						primerNombre+']'+		segundoNombre+']'+
						tercerNombre+']'+		apellidoPaterno+']'+
						apellidoMaterno+']'+
						telefono+']'+			extTelefonoPart+']'+
						validado+']'+			interesado+']'+
						tipoRelacionID+']'+		estadoID+']'+
						municipioID+']'+		localidadID+']'+
						coloniaID+']'+			calle+']'+
						numeroCasa+']'+			numInterior+']'+
						piso+']'+				cp+']');
			} else{
				$('#detalle').val($('#detalle').val() + '['+
						primerNombre+']'+		segundoNombre+']'+
						tercerNombre+']'+		apellidoPaterno+']'+
						apellidoMaterno+']'+
						telefono+']'+			extTelefonoPart+']'+
						validado+']'+			interesado+']'+
						tipoRelacionID+']'+		estadoID+']'+
						municipioID+']'+		localidadID+']'+
						coloniaID+']'+			calle+']'+
						numeroCasa+']'+			numInterior+']'+
						piso+']'+				cp+']');
			}
		}
		
	});
	return true;
}
function setTelefonoMask(idControl){
	var jcontrol = eval("'#" + idControl + "'");
	$(jcontrol).setMask('phone-us');
}

function funcionExito(){
	$("#numTab").val(4);
	$('#gridDetalleDiv').html("");
	$('#gridDetalleDiv').show();
	inicializarSolicitud();
}
function funcionError(){
	
}
/**
 * Cancela las teclas [ ] en el formulario
 * @param e
 * @returns {Boolean}
 */
document.onkeypress = pulsarCorchete;

function pulsarCorchete(e) {
	tecla = (document.all) ? e.keyCode : e.which;
	if (tecla == 91 || tecla == 93) {
		return false;
	}
	return true;
}