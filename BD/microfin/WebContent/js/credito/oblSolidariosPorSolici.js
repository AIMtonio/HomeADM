var cantidadOblSolidarios;
var solicitudOrigen = "";
var esTab = false;
var requiere = false;
var catTipoListaOblSolidarios = {
		'oblSolid' 		: 2,
		'cliente'	: 3,
		'prospecto'	: 4
};
var estaAutorizado ='S';
var parametroBean = consultaParametrosSession();

listaPersBloqBean = {
		'estaBloqueado' : 'N',
		'coincidencia' : 0
	};
var queEs = '';

$(document).ready(function() {			
				
	// Fecha : 23-marzo-2013, Bloque de funcionalidad extra para esta pantalla
	// Solicitado por FCHIA para pantalla pivote (solicitud credito grupal)
	// Valida en la pantalla de solicitud grupal el numero de solicitud (perteneciente al grupo)seleccionado 
	// no eliminar, no afecta el comportamiento de la pantalla de manera individual
	if( $('#numSolicitud').val() != "" ){
		var numSolicitud=  $('#numSolicitud').val();
		$('#solicitudCreditoID').val(numSolicitud);
		$('#solicitudCreditoID').focus();
		consultaSolicitud('solicitudCreditoID');
		
	}
	// fin  Bloque de funcionalidad extra
	
	// Definicion de Constantes y Enums 
	var catTipoTransaccionOblSolid = {
		'grabar' : '1',
		'grabaReest' : '3'		
	};
	
	var catTipoConsultaOblSolid = {
		'principal' : 1,
		'foranea'	: 2
	};	
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('grabar', 'submit');
	agregaFormatoControles('formaGenerica');
		
	$(':text').focus(function() {
		esTab = false;
	});
	
	$(':text').bind('keydown', function(e) {
		if (e.which == 9 && !e.shiftKey) {
			esTab = true;
		}
	});
	
	$('#fechaReg').val(parametroBean.fechaAplicacion);
	
	$('#grabar').click(function(event) {		
		if(solicitudOrigen == 'R'){
			$('#tipoTransaccion').val(catTipoTransaccionOblSolid.grabaReest);
			crearOblSolidariosReestructura(event);
		}else{
			$('#tipoTransaccion').val(catTipoTransaccionOblSolid.grabar);
			crearOblSolidarios(event);
		}	
	});	
	
	$('#solicitudCreditoID').blur(function() {
		consultaTipoSolicitud('solicitudCreditoID');
	});
	 
	$('#solicitudCreditoID').bind('keyup',function(e){
		if(this.value.length >= 2){
			var num = $('#solicitudCreditoID').val();
			var camposLista = new Array();
			var parametrosLista = new Array();			
			camposLista[0] = "clienteID"; 
			parametrosLista[0] = num;
			
			lista('solicitudCreditoID', '1', '5', camposLista, parametrosLista, 'listaSolicitudCredito.htm');
		 } 
	});
						 
	$.validator.setDefaults({
	    submitHandler: function(event) { 
	           grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','solicitudCreditoID'); 
	    }
	});	
	
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
				
		rules: {
			
			solicitudCreditoID: {
				required: true
			},
	
		},		
		messages: {
			
		
			solicitudCreditoID: {
				required: 'Especificar Solicitud.'
			},
			
			}		
	});
				
//------------ Validaciones de Controles -------------------------------------
		
// ////////////////funcion consultar Solicitud//////////////////
				
	function consultaSolicitud(idControl) {
		var jqSolicitud = eval("'#" + idControl + "'");
		var numSolicitud = $(jqSolicitud).val();
		var conSolicitud = 12;
		var SolicitudBeanCon = {
				'solicitudCreditoID' : numSolicitud,
				'sucursal':parametroBean.sucursal,
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numSolicitud != '' && !isNaN(numSolicitud) && esTab) {
			solicitudCredServicio.consulta(conSolicitud, SolicitudBeanCon, function(solicitud) {
				if (solicitud != null) {
					$('#productoCreditoID').val(solicitud.productoCreditoID);
					$('#clienteID').val(solicitud.clienteID);
					$('#prospectoID').val(solicitud.prospectoID);
					if ($('#clienteID').val() !=0){
						consultaNombreCliente('clienteID');
					} else if($('#prospectoID').val() !=0){
						consultaNombreProspecto('prospectoID');
					}
					consultaProducto('productoCreditoID');
					if (solicitud.estatusSol != 'C'){
						var estatus= (solicitud.asignaOblSol);
						var solicitudDeCre=(solicitud.solicitudCreditoID);
						habilitaBoton('agregaOblSolidarios', 'submit');
							habilitaBoton('grabar', 'submit');
							estaAutorizado ='S';
	
							consultaDetalle();												
								if(estatus=='A'){
									habilitaBoton('agregaOblSolidarios', 'submit');
									habilitaBoton('grabar', 'submit');
									estaAutorizado ='S';
									consultaDetalle();										
								} else if(estatus=='U'){
									mensajeSis("Los Obligados solidarios de la Solicitud "+solicitudDeCre+" ya estan Autorizados.");
									limpiaCamposPorError();
									
								}
	
							consultaDetalle();										
						} else if(estatus=='U'){
							mensajeSis("Los Obligados Solidarios de la Solicitud "+solicitudDeCre+" ya estan Autorizados.");
							limpiaCamposPorError();
							consultaDetalle();										
						} else {
							mensajeSis("La Solicitud esta Cancelada.");
							limpiaCamposPorError();
						}
				} else {
					consultaSolicitudEx('solicitudCreditoID');
				} 
			});
		}
	}
	
	function consultaTipoSolicitud(idControl) {
		var jqSolicitud = eval("'#" + idControl + "'");
		var numSolicitud = $(jqSolicitud).val();
		var conSolicitud = 1;
		var SolicitudBeanCon = {
				'solicitudCreditoID' : numSolicitud,
				'sucursal':parametroBean.sucursal,
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numSolicitud != '' && !isNaN(numSolicitud) && esTab) {
			solicitudCredServicio.consulta(conSolicitud, SolicitudBeanCon,{ async: false, callback: function(solicitud) {
						if (solicitud != null) {
							solicitudOrigen = solicitud.tipoCredito;
							$('#productoCreditoID').val(solicitud.productoCreditoID);
							consultaProducto('productoCreditoID');
						} else {
							consultaSolicitudEx('solicitudCreditoID');
						} 
					 }});
		}
	}
	
	
	
	// ////////////////funcion consultar cliente////////////////
	function consultaNombreCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
	
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(1,	numCliente, function(cliente) {
				if (cliente != null) {
					$('#nombreCliente').val(cliente.nombreCompleto);
				} else {
					$('#nombreCliente').val("");
				}
			});
		}
	}
	
	
	// ////////////////funcion consultar Solicitud si no tiene obligados solidarios asignados//////////////////
	
	function consultaSolicitudEx(idControl) {
		var jqSolicitud = eval("'#" + idControl + "'");
		var numSolicitud = $(jqSolicitud).val();
		var conSolicitud = 4;
		var SolicitudBeanCon = {
				'solicitudCreditoID' : numSolicitud,
				'sucursal':parametroBean.sucursal,
			};
		setTimeout("$('#cajaLista').hide();", 200);
		if (numSolicitud != '' && !isNaN(numSolicitud) && esTab) {
			solicitudCredServicio.consulta(conSolicitud, SolicitudBeanCon, function(solicitud) {
						if (solicitud != null) {
								$('#productoCreditoID').val(solicitud.productoCreditoID);
								$('#clienteID').val(solicitud.clienteID);
								$('#prospectoID').val(solicitud.prospectoID);
								$('#estSol').val(solicitud.estatus);
								if ($('#clienteID').val() !=0){
									consultaNombreCliente('clienteID');
								} else if($('#prospectoID').val() !=0){
									consultaNombreProspecto('prospectoID');
								}
								estaAutorizado ='S';
								consultaDetalle();
								if(solicitud.estatus != 'C'){
									habilitaBoton('agregaOblSolidarios', 'submit');
									habilitaBoton('grabar', 'submit');
									estaAutorizado ='S';
									requiere = false;
								}else{
									mensajeSis("La Solicitud esta Cancelada.");
									limpiaCamposPorError();
								}
							
						} else {
							mensajeSis("No Existe la Solicitud o la Solicitud no es de la Sucursal.");
							limpiaCamposPorError();
							$(jqSolicitud).focus();
						} 
						
			});
		}
	}
	
	//////////////////funcion consultar prospecto////////////////
	function consultaNombreProspecto(idControl) {
		var jqProspecto = eval("'#" + idControl + "'");
		var numProspecto = $(jqProspecto).val();
		var prospBeanCon = { 
				'prospectoID':numProspecto		  				
			};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numProspecto != '' && !isNaN(numProspecto) && esTab){
			prospectosServicio.consulta(1,	prospBeanCon, function(prospecto) {
				if (prospecto != null) {
					$('#nombreCliente').val(prospecto.nombreCompleto);
				} else {
					$('#nombreCliente').val("");
				}
			});
		}
	}
	
	
	  //------------ Funcion Consulta Producto-------------------------------------
	
	function consultaProducto(idControl) {
		var jqProducto = eval("'#" + idControl + "'");
		var numProducto = $(jqProducto).val();	
		var tipConPrincipal = 1;
		var productoBeanCon = { 
				'producCreditoID':numProducto		  				
		};
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numProducto != '' && !isNaN(numProducto) && esTab){
			productosCreditoServicio.consulta(tipConPrincipal,productoBeanCon,function(productos) {
				if(productos!=null){
					$('#tipoCredito').val(productos.descripcion);
					if(productos.requiereObligadosSolidarios=='S' || productos.requiereObligadosSolidarios=='I'){
						cantidadOblSolidarios = productos.cantidadObligadosSolidarios;
						requiere = true;
						consultaSolicitud(idControl);
					} else {
						var req=$('#solicitudCreditoID').val();
						requiere = false;
						mensajeSis("La Solicitud de Credito "+req+" No Requiere Obligados Solidarios.");
						deshabilitaBoton('grabar', 'submit');
						$('#gridOblSolid').hide();
						$('#solicitudCreditoID').focus();
	                    $('#solicitudCreditoID').select();
					}																				
				} 	 						
			});
		}
	}
	
	/////consulta GridIntegrantes////////////
	
	function consultaDetalle(){	
		var params = {};
		if(solicitudOrigen == 'R'){
			params['tipoLista'] = 2;
		}else{
			params['tipoLista'] = 1;
		}
		params['solicitudCreditoID'] = $('#solicitudCreditoID').val();
		
		$.post("listaOblSolidPorSolici.htm", params, function(data){
			if(data.length >0) {		
				$('#gridOblSolid').html(data);
				$('#gridOblSolid').show();												
			}else{				
				$('#gridOblSolid').html("");
				$('#gridOblSolid').show();
			}
		});
	}
	
	
	
	function crearOblSolidarios(event){	
		var mandar = verificarvacios();
		if(mandar!=1){
			quitaFormatoControles('gridOblSolid');
			var numDetalle = $('input[name=consecutivoID]').length;
			$('#oblSolidarios').val("");
			for(var i = 1; i <= numDetalle; i++){
				if(i == 1){
					$('#oblSolidarios').val($('#oblSolidarios').val() +
							$('#solicitudCreditoID').val() + ']' +
							document.getElementById("oblSolidID"+i+"").value + ']' +
							document.getElementById("clienteID"+i+"").value + ']' +
							document.getElementById("prospectoID"+i+"").value + ']' +
							document.getElementById("tiempoConocido"+i+"").value + ']' +
							document.getElementById("parentescoID"+i+"").value);
				}else{
					$('#oblSolidarios').val($('#oblSolidarios').val() + '[' +
							$('#solicitudCreditoID').val() + ']' +
							document.getElementById("oblSolidID"+i+"").value + ']' +
							document.getElementById("clienteID"+i+"").value + ']' +
							document.getElementById("prospectoID"+i+"").value + ']' +
							document.getElementById("tiempoConocido"+i+"").value + ']' +
							document.getElementById("parentescoID"+i+"").value);
				}
			}
		} else {
			mensajeSis("Faltan Datos.");
			event.preventDefault();
		}
	}
	
	function crearOblSolidariosReestructura(event){	
		var mandar = verificarvacios();
		if(mandar!=1){
			quitaFormatoControles('gridOblSolid');
			var numDetalle = $('input[name=consecutivoID]').length;
			$('#oblSolidarios').val("");
			for(var i = 1; i <= numDetalle; i++){
				var estatusSol = $('#estatusSolicitud'+i).val();
					if(estatusSol == ''){
						$('#estatusSolicitud'+i).val('N');
					}
				if(i == 1){
					$('#oblSolidarios').val($('#oblSolidarios').val() + 
							$('#solicitudCreditoID').val() + ']' +
							$("#oblSolidID"+i+"").val() + ']' +
							$("#clienteID"+i+"").val() + ']' +
							$("#prospectoID"+i+"").val()+ ']' +
							$("#estatusSolicitud"+i+"").val() + ']' +
							$("#tiempoConocido"+i+"").val() + ']' +
							$("#parentescoID"+i+"").val());
			
				}else{
	
					$('#oblSolidarios').val($('#oblSolidarios').val() + '[' +
							$('#solicitudCreditoID').val() + ']' +
							$("#oblSolidID"+i+"").val() + ']' +
							$("#clienteID"+i+"").val() + ']' +
							$("#prospectoID"+i+"").val()+ ']' +
							$("#estatusSolicitud"+i+"").val() + ']' +
							$("#tiempoConocido"+i+"").val() + ']' +
							$("#parentescoID"+i+"").val());
	
				}
			}
		} else {
			mensajeSis("Faltan Datos.");
			event.preventDefault();
		}
	}
	
	function verificarvacios(){	
		quitaFormatoControles('gridOblSolid');
		var numDetalle = $('input[name=consecutivoID]').length;
		$('#oblSolidarios').val("");
		
		for(var i = 1; i <= numDetalle; i++){
			var idcc = document.getElementById("oblSolidID"+i+"").value;
				if (idcc ==""){
					document.getElementById("oblSolidID"+i+"").focus();				
					$(idcc).addClass("error");	
					return 1; 
				}
				var idcli = document.getElementById("clienteID"+i+"").value;
				if (idcli ==""){
					document.getElementById("clienteID"+i+"").focus();				
					$(idcc).addClass("error");	
					return 1; 
				}
				var idpro = document.getElementById("prospectoID"+i+"").value;
				if (idpro ==""){
					document.getElementById("prospectoID"+i+"").focus();				
					$(idpro).addClass("error");	
					return 1; 
				}
				var idcco = document.getElementById("nombre"+i+"").value;
				if (idcco ==""){
					document.getElementById("nombre"+i+"").focus();
					$(idcco).addClass("error");
					return 1; 
				}
				var idtic = document.getElementById("tiempoConocido"+i+"").value;
				if (idtic ==""){
					document.getElementById("tiempoConocido"+i+"").focus();
					$(idtic).addClass("error");
					return 1; 
				}
				var idpar = document.getElementById("parentescoID"+i+"").value;
				if (idpar ==""){
					document.getElementById("parentescoID"+i+"").focus();
					$(idpar).addClass("error");
					return 1; 
				}
				var idnpa = document.getElementById("nombreParentesco"+i+"").value;
				if (idnpa ==""){
					document.getElementById("nombreParentesco"+i+"").focus();
					$(idnpa).addClass("error");
					return 1; 
				}
		}
	}
	
	function limpiaCamposPorError(){
		estaAutorizado ='N';
		consultaDetalle();
		deshabilitaBoton('agregaOblSolidarios', 'submit');
		deshabilitaBoton('grabar', 'submit');
		requiere = false;
	}
});

// Funcion Obtener Dia
function obtenDia() {
	var f = new Date();
	dia = f.getDate();
	mes = f.getMonth() + 1;
	anio = f.getFullYear();
	if (dia < 10) {
		dia = "0" + dia;
	}
	if (mes < 10) {
		mes = "0" + mes;
	}

	return anio + "-" + mes + "-" + dia;
}


// ////////////////funcion consultar Obl solidario//////////////////

function consultaOblSolidGrid(idControl,tipoOblSolid){
	var conCred;
	var control;
	var rol;
	var clienteActivo = 'A';
	
	switch (tipoOblSolid) {
	case 1:
		conCred = 1;
		break;
	case 2:
		conCred = catTipoListaOblSolidarios.oblSolid;								
		control= idControl.substr(10,idControl.length);
		rol = 'Obligado Solidario';
		queEs = 'OBS';
		break;
	case 3:
		conCred = catTipoListaOblSolidarios.cliente;
		control= idControl.substr(9,idControl.length);
		rol = $('#valCliente').val();
		queEs = 'CTE';
		break;
	case 4:
		conCred = catTipoListaOblSolidarios.prospecto;
		control= idControl.substr(11,idControl.length);
		rol = 'Prospecto';
		queEs = 'PRO';
		break;
	}
	
	var controlID = eval("'#" + idControl + "'");		
	var numOblSolid = $(controlID).val();					
	var oblSolid = eval("'#oblSolidID" + control + "'");		
	var cliente = eval("'#clienteID" + control + "'");
	var prospecto = eval("'#prospectoID" + control + "'");	
	var nombre = eval("'#nombre" + control + "'");		
	
	var oblSolidBeanCon = {
			'oblSolidarioID':numOblSolid
	};

	setTimeout("$('#cajaLista').hide();", 200);
		if(numOblSolid != '' && !isNaN(numOblSolid) && numOblSolid !='0'){
		obligadosSolidariosServicio.consulta(conCred,oblSolidBeanCon,function(oblSolides){
			
			if(oblSolides!=null){
				listaPersBloqBean = consultaListaPersBloq(numOblSolid, queEs, 0, 0);
				if (listaPersBloqBean.estaBloqueado != 'S') {
					if(cantidadOblSolidarios < oblSolides.creditosoblSolidados){
						mensajeSis("El " + rol + " ya Tiene la Cantidad de Créditos oblSolidados Permitidos.");
						$(oblSolid).val("");
						$(cliente).val("");
						$(prospecto).val("");
						$(nombre).val("");
						switch (conCred) {
	                        case 1:
	                                conCred = 1;
	                                break;
	                        case 2:
	                                $(oblSolid).focus();
	                                break;
	                        case 3:
	                                $(cliente).focus();
	                                break;
	                        case 4:
	                                $(prospecto).focus();
	                                break;
	                    }
					}
					else { 
						if(conCred == 3){
							if(oblSolides.estatusCliente !=clienteActivo){
								mensajeSis("El " + rol + " No esta Activo.");
								$(oblSolid).val("");
								$(cliente).val("");
								$(prospecto).val("");
								$(nombre).val("");
			                    $(cliente).focus();
							} else {
								$(oblSolid).val(oblSolides.oblSolidarioID);
								$(cliente).val(oblSolides.clienteID);
								$(prospecto).val(oblSolides.prospectoID);
								$(nombre).val(oblSolides.nombreCompleto);
								habilitaBoton('grabar',' submit' );
							}
						} else {
							$(oblSolid).val(oblSolides.oblSolidarioID);
							$(cliente).val(oblSolides.clienteID);
							$(prospecto).val(oblSolides.prospectoID);
							$(nombre).val(oblSolides.nombreCompleto);
							habilitaBoton('grabar',' submit' );
						}
					}
				}else{
					mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación');
					$(oblSolid).val("");
		            $(cliente).val("");
		            $(prospecto).val("");
		            $(nombre).val("");
		            $(controlID).focus();
				}
				
			} else {
	            mensajeSis("El " + rol + " No Existe.");
	            $(oblSolid).val("");
	            $(cliente).val("");
	            $(prospecto).val("");
	            $(nombre).val("");
	            switch (conCred) {
	                case 1:
	                        conCred = 1;
	                        break;
	                case 2:
	                        $(oblSolid).focus();
	                        break;
	                case 3:
	                        $(cliente).focus();
	                        break;
	                case 4:
	                        $(prospecto).focus();
	                        break;
	            }
	
	        }
			});
		}else{

			switch (conCred) {
				case 1:
					break;
				case 2:
					if(($(oblSolid).asNumber() > 0) && $(cliente).asNumber() == 0 && $(prospecto).asNumber() == 0){
						$(oblSolid).val("");
						$(cliente).val("");
						$(prospecto).val("");
						$(nombre).val("");
					}
					break;
				case 3:
					if(($(cliente).asNumber() > 0) && $(oblSolid).asNumber() == 0 && $(prospecto).asNumber() == 0){
						$(oblSolid).val("");
						$(cliente).val("");
						$(prospecto).val("");
						$(nombre).val("");
					}
					break;
				case 4:
					if(($(prospecto).asNumber() > 0) && $(oblSolid).asNumber() == 0 && $(cliente).asNumber() == 0){
						$(oblSolid).val("");
						$(cliente).val("");
						$(prospecto).val("");
						$(nombre).val("");
					}
					break;
			}
		}

	}


// Lista de oblSolides
function listaoblSolides(idControl){
		var numero= idControl.substr(10,idControl.length);
		var num = $('#oblSolidID'+numero).val();
		var camposLista = new Array();
		var parametrosLista = new Array();			
		camposLista[0] = "nombreCompleto"; 
		parametrosLista[0] = num;
		lista(idControl, '2', '1', camposLista, parametrosLista, 'listaObligadosSolidarios.htm');
}


//Lista de ClientesoblSolid
function listaClientes(idControl){
		var numero= idControl.substr(9,idControl.length);
		var num = $('#clienteID'+numero).val();
		var camposLista = new Array();
		var parametrosLista = new Array();			
		camposLista[0] = "nombreCompleto"; 
		parametrosLista[0] = num;
		lista(idControl, '2', '1', camposLista, parametrosLista, 'listaCliente.htm');	
}


//Lista de Prospectos
function listaProspectos(idControl){
		var numero= idControl.substr(11,idControl.length);
		var num = $('#prospectoID'+numero).val();
		var camposLista = new Array();
		var parametrosLista = new Array();			
		camposLista[0] = "prospectoID"; 
		parametrosLista[0] = num;
		lista(idControl, '1', '1', camposLista, parametrosLista, 'listaProspecto.htm');
}

//Lista de Parentescos con el oblSolid
function listaParentescos(idControl){
		var numero= idControl.substr(12,idControl.length);
		var parametro = $('#parentescoID'+numero).val();		
		var campo = "descripcion";
		lista(idControl, '2', '1', campo, parametro, 'listaParentescos.htm');
}

//Consulta de Parentescos con el oblSolid
function consultaParentesco(idControl) {
	var numero= idControl.substr(12,idControl.length);
	var jqParentesco = eval("'#parentescoID" + numero + "'");
	var jqIdNombreParent =  eval("'#nombreParentesco" + numero + "'"); 
	var numParentesco = $(jqParentesco).val();
	var tipPrincipal= 1;
	setTimeout("$('#cajaLista').hide();", 200);

	var ParentescoBean = {
			'parentescoID' : numParentesco
	};

	if(numParentesco != '' && !isNaN(numParentesco)){
		parentescosServicio.consultaParentesco(tipPrincipal, ParentescoBean, function(parentesco) {
			if(parentesco!=null){
				$(jqIdNombreParent).val(parentesco.descripcion);
			}else{
				mensajeSis("No Existe el Tipo de relación");
				$(jqParentesco).val('');
				$(jqIdNombreParent).val('');
				$(jqParentesco).focus();
			}
		});
	}else{
		$(jqIdNombreParent).val('');
	}
}

function validaEstatus(){
	$("input[name=estatusSolicitud]").each(function(i){		
	
		var jqValida = eval("'#" + this.id + "'");	
		var id = jqValida.replace(/\D/g,'');
		var valor = $(jqValida).val();				
		if (valor == 'O') {
			$("#"+id).attr('disabled',true);
		}
		
	});
}

//Funcion para validar que solo se ingresen numeros y/o el punto decimal
function validaSoloNumero(e,elemento) {
	var key;
	if(window.event){//IE, chromium
		key = e.keyCode;
	}else if(e.which){//Firefox, Opera Netscape
		key = e.which;
	}
	if (key < 48 || key > 57) {
	    if(key == 46 || key == 8){ // Detecta . (punto) y backspace (retroceso)
	    	return true; 
	    }else {
	    	return false; 
	    }
	}
	return true;
}