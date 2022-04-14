var cantidadObligados;
var tipoSolicitud = "";
var esTab = false;
var requiere = false;
var tieneAsigObligados = "";
var catTipoListaObliados = {
		'obligado' 		: 2,
		'cliente'	: 3,
		'prospecto'	: 4
};
var parametroBean = consultaParametrosSession();
var estaAutorizado ='S';
$(document).ready(function() {

			// Definicion de Constantes y Enums
			var catTipoTransaccionObligados = {
				'grabar' : '1',
				'autorizar': '3'
				
			};
			var catTipoConsultaObligados = {
					'principal' : 1,
					'foranea'	: 2,
			};
			
			//------------ Metodos y Manejo de Eventos -----------------------------------------
               $('#solicitudCreditoID').focus();
			   deshabilitaBoton('grabar', 'submit');
			   deshabilitaBoton('autorizar', 'submit');
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
					$('#tipoTransaccion').val(catTipoTransaccionObligados.grabar);
					crearObligados(event);
				});	
				
				$('#autorizar').click(function(event) {
					if(consultaFilas()>0){
						$('#tipoTransaccion').val(catTipoTransaccionObligados.autorizar);
						crearObligados(event);
					} else {
						mensajeSis('No hay Obligados Solidarios Capturados.');
						deshabilitaBoton('autorizar', 'submit');
						event.preventDefault();
                        $('#solicitudCreditoID').focus();
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
							
							lista('solicitudCreditoID', '1', '1', camposLista, parametrosLista, 'listaSolicitudCredito.htm'); } });
				
								 
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
											if(estatus=='A'){
												estaAutorizado ='S';
												habilitaBoton('agregaObligado', 'submit');
												habilitaBoton('grabar', 'submit');
												habilitaBoton('autorizar', 'submit');
												consultaDetalle();
											} else if(estatus=='U'){
												mensajeSis("Los Obligados Solidarios de la Solicitud "+solicitudDeCre+" ya estan Autorizados.");
												limpiaCamposPorError();
											}
										} else {
											mensajeSis("La Solicitud está Cancelada.");
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
										tipoSolicitud = solicitud.tipoCredito;
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

									} 
									else{
										$('#nombreCliente').val("");
									}
								});
					}
				}
				
//////////////////funcion consultar Solicitud si no tiene Obligados asignados//////////////////
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
										var estatus = solicitud.estatus;
										var productoCreditoID = solicitud.productoCreditoID;
										var clienteID = solicitud.clienteID;
										var prospectoID = solicitud.prospectoID;

										tieneAsigObligados = "";
										var NumConsulta = 2;
										var ObligadoBean = {
												'solicitudCreditoID':numSolicitud
										};
										autorizaObliSolidServicio.consulta(NumConsulta,ObligadoBean,function(obligados){
											if(obligados != null){
												if(obligados.estatus != "U"){
													if(obligados.numOblAsign > 0){
														tieneAsigObligados = "S";
														datosCargaSolicitud(estatus,productoCreditoID,clienteID,prospectoID,jqSolicitud);
													}
												}else{
													mensajeSis("Los Obligados Solidarios de la Solicitud "+numSolicitud+" ya estan Autorizados.");
													limpiaCamposPorError();
												}
											}else{
												if (window.confirm("La solicitud No tiene Obligados Solidarios Asignados, ¿Desea Asignarlos Ahora?")) { 
													tieneAsigObligados = "S";
												}else{
													tieneAsigObligados = "N";
												}
												datosCargaSolicitud(estatus,productoCreditoID,clienteID,prospectoID,jqSolicitud);
											}
										});
									} else {	
										mensajeSis("No Existe la Solicitud o la Solicitud no es de la Sucursal.");
										limpiaCamposPorError();
										$(jqSolicitud).focus();
										$(jqSolicitud).select();
									} 
						});
					}
				}
				
				// funcion para cargar los datos de la solicitud de credito y sus datos respectivos
				function datosCargaSolicitud(estatus,productoCreditoID,clienteID,prospectoID,jqSolicitud){
						if(estatus != 'C'){
								if(tieneAsigObligados == "S"){
									$('#productoCreditoID').val(productoCreditoID);
									$('#clienteID').val(clienteID);
									$('#prospectoID').val(prospectoID);
									$('#estSol').val(estatus);
									if ($('#clienteID').val() !=0){
										consultaNombreCliente('clienteID');
									} else if($('#prospectoID').val() !=0){
										consultaNombreProspecto('prospectoID');	
									}
									estaAutorizado ='S';
									habilitaBoton('agregaObligado', 'submit');
									habilitaBoton('grabar', 'submit');
									habilitaBoton('autorizar', 'submit');
									consultaDetalle();
									requiere = false;
									tieneAsigObligados = "";
								} else {
										limpiaCamposPorError();
								}
						} else {
							mensajeSis("La Solicitud esta Cancelada.");
							limpiaCamposPorError();
							$(jqSolicitud).focus();
							$(jqSolicitud).select();
						}
				}
				
//////////////////funcion consultar propecto////////////////
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
									} 
									else{
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
									cantidadObligados = productos.cantidadObligados;
									requiere = true;
									consultaSolicitud(idControl);
									
								} else {
									var req=$('#solicitudCreditoID').val();
									requiere = false;
									mensajeSis("La Solicitud de Credito "+req+" No requiere Obligados Solidarios.");
									deshabilitaBoton('grabar', 'submit');
									deshabilitaBoton('autorizar', 'submit');
									$('#gridObligados').hide();
									$('#solicitudCreditoID').select();
								}
																				
							} 	 						
						});
					}
				}
				
				
				/////consulta GridIntegrantes////////////
				
				function consultaDetalle(){	
					var params = {};
					if(tipoSolicitud == "R"){
						params['tipoLista'] = 2;
					}else{
						params['tipoLista'] = 1;
					}
					
					params['solicitudCreditoID'] = $('#solicitudCreditoID').val();
					
					$.post("listaAutorizaObliSolid.htm", params, function(data){
							if(data.length >0) {		
									$('#gridObligados').html(data);
									$('#gridObligados').show();
									if(tipoSolicitud == 'R'){
										validaEstatus();
									}
							}else{
									$('#gridObligados').html("");
									$('#gridObligados').show();
							}
					});
				}
				
				
				
				function crearObligados(event){	
					var mandar = verificarvacios()
					if(mandar!=1){   		  		
						quitaFormatoControles('gridObligados');
						var numDetalle = $('input[name=consecutivoID]').length;
						$('#obligados').val("");
						for(var i = 1; i <= numDetalle; i++){
							
							if(i == 1){
							$('#obligados').val($('#obligados').val() +
										$('#solicitudCreditoID').val() + ']' +
										document.getElementById("obligadoID"+i+"").value + ']' +
										document.getElementById("clienteID"+i+"").value + ']' +
										document.getElementById("prospectoID"+i+"").value + ']' +
										document.getElementById("tiempoConocido"+i+"").value + ']' +
										document.getElementById("parentescoID"+i+"").value);
						
							}else{
								$('#obligados').val($('#obligados').val() + '[' +
										$('#solicitudCreditoID').val() + ']' +
										document.getElementById("obligadoID"+i+"").value + ']' +
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

					function verificarvacios() {
						quitaFormatoControles('gridObligados');
						var numDetalle = $('input[name=consecutivoID]').length;
						$('#obligados').val("");

						for ( var i = 1; i <= numDetalle; i++) {

							var idcc = document.getElementById("obligadoID" + i
									+ "").value;
							if (idcc == "") {
								document.getElementById("obligadoID" + i + "")
										.focus();
								$(idcc).addClass("error");
								return 1;
							}
							var idcli = document.getElementById("clienteID" + i
									+ "").value;
							if (idcli == "") {
								document.getElementById("clienteID" + i + "")
										.focus();
								$(idcc).addClass("error");
								return 1;
							}
							var idpro = document.getElementById("prospectoID" + i+ "").value;
							if (idpro == "") {
								document.getElementById("prospectoID" + i + "").focus();
								$(idpro).addClass("error");
								return 1;
							}
							var idcco = document.getElementById("nombre" + i
									+ "").value;
							if (idcco == "") {
								document.getElementById("nombre" + i + "")
										.focus();
								$(idcco).addClass("error");
								return 1;
							}
						}
					}

					function limpiaCamposPorError(){
						estaAutorizado ='N';
						consultaDetalle();
						deshabilitaBoton('agregaObligado', 'submit');
						deshabilitaBoton('autorizar', 'submit');
						deshabilitaBoton('grabar', 'submit');
						requiere = false;
						tieneAsigObligados = "";
					}
});// Fin documentReady

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

//////////////////funcion consultar Obligado//////////////////
function consultaObligadoGrid(idControl,tipoObligado){
	var clienteActivo = 'A';
	var conCred;
	var control;
	var rol;
	
	switch (tipoObligado) {
	case 1:
		conCred = 1;
		break;
	case 2:
		conCred = catTipoListaObliados.obligado;								
		control= idControl.substr(10,idControl.length);
		rol = 'Obligado Solidario';
		break;
	case 3:
		conCred = catTipoListaObliados.cliente;
		control= idControl.substr(9,idControl.length);
		rol = $('#valCliente').val();
		break;
	case 4:
		conCred = catTipoListaObliados.prospecto;
		control= idControl.substr(11,idControl.length);
		rol = 'Prospecto';
		break;
	}
	
	var controlID = eval("'#" + idControl + "'");		
	var numObigado = $(controlID).val();					
	var obligado = eval("'#obligadoID" + control + "'");		
	var cliente = eval("'#clienteID" + control + "'");
	var prospecto = eval("'#prospectoID" + control + "'");	
	var nombre = eval("'#nombre" + control + "'");		
	
	var ObligadoBeanCon = {
		'oblSolidarioID':numObigado
	};

	setTimeout("$('#cajaLista').hide();", 200);
	
		if(numObigado != '' && !isNaN(numObigado) && numObigado !='0' && numObigado != ''){
			obligadosSolidariosServicio.consulta(conCred,ObligadoBeanCon,function(obligados){
				
				if(obligados!=null){
							
					if(cantidadObligados < obligados.creditosObligados){
						mensajeSis("El " + rol + " ya Tiene la Cantidad de Créditos Obligados Permitidos.");
						$(obligado).val("");
						$(cliente).val("");
						$(prospecto).val("");
						$(nombre).val("");
						switch (conCred) {
	                        case 1:
	                                conCred = 1;
	                                break;
	                        case 2:
	                                $(obligado).focus();
	                                break;
	                        case 3:
	                                $(cliente).focus();
	                                break;
	                        case 4:
	                                $(prospecto).focus();
	                                break;
	                    }
					} else {  
						if(conCred == 3){
							if(obligados.estatusCliente !=clienteActivo){
								mensajeSis("El " + rol + " No esta Activo.");
								$(obligado).val("");
								$(cliente).val("");
								$(prospecto).val("");
								$(nombre).val("");
			                    $(cliente).focus();
							} else {
								$(obligado).val(obligados.oblSolidarioID);
								$(cliente).val(obligados.clienteID);
								$(prospecto).val(obligados.prospectoID);
								$(nombre).val(obligados.nombreCompleto);
								habilitaBoton('grabar',' submit' );
							}
						} else {
							$(obligado).val(obligados.oblSolidarioID);
							$(cliente).val(obligados.clienteID);
							$(prospecto).val(obligados.prospectoID);
							$(nombre).val(obligados.nombreCompleto);
							habilitaBoton('grabar',' submit' );
						}
					}
					
					
				} else {
		            mensajeSis("El " + rol + " No Existe.");
		            $(obligado).val("");
		            $(cliente).val("");
		            $(prospecto).val("");
		            $(nombre).val("");
		            switch (conCred) {
		                case 1:
		                        conCred = 1;
		                        break;
		                case 2:
		                        $(obligado).focus();
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
		} else {
			switch (conCred) {
				case 1:
					break;
				case 2:
					if(($(obligado).asNumber() > 0) && $(cliente).asNumber() == 0 && $(prospecto).asNumber() == 0){
						$(obligado).val("");
						$(cliente).val("");
						$(prospecto).val("");
						$(nombre).val("");
					}
					break;
				case 3:
					if(($(cliente).asNumber() > 0) && $(obligado).asNumber() == 0 && $(prospecto).asNumber() == 0){
						$(obligado).val("");
						$(cliente).val("");
						$(prospecto).val("");
						$(nombre).val("");
					}
					break;
				case 4:
					if(($(prospecto).asNumber() > 0) && $(obligado).asNumber() == 0 && $(cliente).asNumber() == 0){
						$(obligado).val("");
						$(cliente).val("");
						$(prospecto).val("");
						$(nombre).val("");
					}
					break;
			}
		}

	}

// Lista de Obligados
function listaObligados(idControl) {
	var jq = eval("'#" + idControl + "'");
	var sbtrn = (idControl.length);
	var Control = idControl.substr(10, sbtrn);
	var clienteGrid = eval("'#clienteID" + Control + "'");
	var prospectoGrid = eval("'#prospectoID"+Control+"'");
	var nombreGrid = eval("'#nombre" + Control + "'");

	$(jq).bind('keyup',function(e) {
		var jqControl = eval("'#" + this.id + "'");
		var num = $(jqControl).val();
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreCompleto";
		parametrosLista[0] = num;
		lista(idControl, '2', '1', camposLista, parametrosLista,'listaObligadosSolidarios.htm');
	});
}

// Lista de Clientes
function listaClientes(idControl) {
	var jq = eval("'#" + idControl + "'");
	var sbtrn = (idControl.length);
	var Control = idControl.substr(9, sbtrn);
	var obligadoGrid = eval("'#obligadoID" + Control + "'");
	var prospectoGrid = eval("'#prospectoID"+Control+"'");
	var nombreGrid = eval("'#nombre" + Control + "'");

	$(jq).bind('keyup',function(e) {
		var jqControl = eval("'#" + this.id + "'");
		var num = $(jqControl).val();
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreCompleto";
		parametrosLista[0] = num;
		lista(idControl, '2', '1', camposLista, parametrosLista, 'listaCliente.htm');
	});
}


//Lista de Prospectos
function listaProspectos(idControl){
	var jq = eval("'#" + idControl + "'");
	var sbtrn = (idControl.length);
	var Control= idControl.substr(11,sbtrn);
	var obligadoGrid = eval("'#obligadoID"+Control+"'");
	var clienteGrid = eval("'#clienteID"+Control+"'");
	var nombreGrid = eval("'#nombre"+Control+"'");
	
	$(jq).bind('keyup',function(e){		
		var jqControl = eval("'#" + this.id + "'");
		var num = $(jqControl).val();
		var camposLista = new Array();
		var parametrosLista = new Array();			
		camposLista[0] = "prospectoID"; 
		parametrosLista[0] = num;
		lista(idControl, '1', '1', camposLista, parametrosLista, 'listaProspecto.htm');
	});
}

// Cuenta las filas de la tabla del grid 
function consultaFilas(){
	var totales=0;
	$('tr[name=renglon]').each(function() {
		totales++;		
	});
	return totales;
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

//Lista de Parentescos con el Obligado Solidario
function listaParentescos(idControl){
		var numero= idControl.substr(12,idControl.length);
		var parametro = $('#parentescoID'+numero).val();		
		var campo = "descripcion";
		lista(idControl, '2', '1', campo, parametro, 'listaParentescos.htm');
}

//Consulta de Parentescos con el Obligado Solidario
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
