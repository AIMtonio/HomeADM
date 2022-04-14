var cantidadAvales;
var tipoSolicitud = "";
var esTab = false;
var catTipoListaAvales = {
		'aval' 		: 2,
		'cliente'	: 3,
		'prospecto'	: 4
};
var parametroBean = consultaParametrosSession();
var estaAutorizado ='S';
$(document).ready(function() {
			
			// Implementado para los Flujos Individuales
			if( $('#numSolicitud').val() != "" ){
				var numSolicitud=  $('#numSolicitud').val();
				$('#solicitudCreditoID').val(numSolicitud);
				$('#solicitudCreditoID').focus();
				consultaSolicitud('solicitudCreditoID');
				
			}
			// Definicion de Constantes y Enums
			var catTipoTransaccionAvales = {
				'grabar' : '1',
				'autorizar': '3'
				
			};
			var catTipoConsultaAvales = {
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
					$('#tipoTransaccion').val(catTipoTransaccionAvales.grabar);
					crearAvales(event);
				});	
				
				$('#autorizar').click(function(event) {
					if(consultaFilas()>0){
						$('#tipoTransaccion').val(catTipoTransaccionAvales.autorizar);
						crearAvales(event);
					} else {
						mensajeSis('No hay Avales Capturados.');
						deshabilitaBoton('autorizar', 'submit');
						event.preventDefault();
                        $('#solicitudCreditoID').focus();
					}
				});	
				
				 $('#solicitudCreditoID').blur(function() {
					 consultaSolicitud(this.id);
					 // consultaTipoSolicitud('solicitudCreditoID');
				 });
				 
				 $('#solicitudCreditoID').bind('keyup',function(e){
					 if(this.value.length >= 2){ 
						 var num = $('#solicitudCreditoID').val();
						 var camposLista = new Array();
							var parametrosLista = new Array();			
							camposLista[0] = "clienteID"; 
							parametrosLista[0] = num;
							
							lista('solicitudCreditoID', '1', '14', camposLista, parametrosLista, 'listaSolicitudCredito.htm'); } });
				
								 
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
					var conSolicitud = 5;
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
										tipoSolicitud = solicitud.tipoCredito;
										if ($('#clienteID').val() !=0){
											consultaNombreCliente('clienteID');
										} else if($('#prospectoID').val() !=0){
											consultaNombreProspecto('prospectoID');	
										}
										consultaProducto('productoCreditoID');
										if (solicitud.estatusSol != 'C'){
											var estatus= (solicitud.asignaSol);
											var solicitudDeCre=(solicitud.solicitudCreditoID);
											if(estatus=='A'){
												estaAutorizado ='S';
												habilitaBoton('agregaAval', 'submit');
												habilitaBoton('grabar', 'submit');
												habilitaBoton('autorizar', 'submit');
												consultaDetalle();
											} else if(estatus=='U'){
												mensajeSis("Los Avales de la Solicitud "+solicitudDeCre+" ya estan Autorizados.");
												limpiaCamposPorError();
											}
										} else {
											mensajeSis("La Solicitud está Cancelada.");
											limpiaCamposPorError();
											$('#tipoCredito').val('');
											$('#nombreCliente').val('');
											$('#fechaRegistro').val('');
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

				
				
				
// ////////////////funcion consultar Solicitud si no tiene avales asignados//////////////////
				
				function consultaSolicitudEx(idControl) {
					var jqSolicitud = eval("'#" + idControl + "'");
					var numSolicitud = $(jqSolicitud).val();
					var conSolicitud = 9;
					var SolicitudBeanCon = {
							'solicitudCreditoID' : numSolicitud,
							'sucursal':parametroBean.sucursal,
						};
					setTimeout("$('#cajaLista').hide();", 200);
					if (numSolicitud != '' && !isNaN(numSolicitud) && esTab) {
						solicitudCredServicio.consulta(conSolicitud, SolicitudBeanCon, function(solicitud) {
	
									if (solicitud.solicitudCreditoID>0) {
										if(solicitud.estatus != 'C'){
											var mensaje = confirm("La solicitud No tiene Avales Asignados, ¿Desea Asignarlos Ahora?");

											if(mensaje == true){
												$('#productoCreditoID').val(solicitud.productoCreditoID);
												$('#clienteID').val(solicitud.clienteID);
												$('#prospectoID').val(solicitud.prospectoID);
												$('#estSol').val(solicitud.estatus);
												if ($('#clienteID').val() !=0){
													consultaNombreCliente('clienteID');
												} else if($('#prospectoID').val() !=0){
													consultaNombreProspecto('prospectoID');	
												}
												consultaProducto('productoCreditoID');
												estaAutorizado ='S';
												habilitaBoton('agregaAval', 'submit');
												habilitaBoton('grabar', 'submit');
												habilitaBoton('autorizar', 'submit');
												consultaDetalle();
											} else {
												limpiaCamposPorError();
												$('#tipoCredito').val('');
												$('#nombreCliente').val('');
												$('#fechaRegistro').val('');
											}
										} else {
											mensajeSis("La Solicitud esta Cancelada.");
											limpiaCamposPorError();
											$('#tipoCredito').val('');
												$('#nombreCliente').val('');
												$('#fechaRegistro').val('');
											$(jqSolicitud).focus();
											$(jqSolicitud).select();
										}
									} else {	
										mensajeSis("No Existe la Solicitud o la Solicitud no es de la Sucursal.");
										limpiaCamposPorError();
										$('#tipoCredito').val('');
										$('#nombreCliente').val('');
										$('#fechaRegistro').val('');
										$(jqSolicitud).focus();
										$(jqSolicitud).select();
									} 
								});
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
								if(productos.requiereAvales=='S' || productos.requiereAvales=='I'){
									cantidadAvales = productos.cantidadAvales;
								} else {
									var req=$('#solicitudCreditoID').val();
									mensajeSis("La Solicitud de Credito "+req+" No requiere Avales.");
									deshabilitaBoton('grabar', 'submit');
									deshabilitaBoton('autorizar', 'submit');
									$('#gridAvales').hide();
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
					
					$.post("listaAutorizaAvales.htm", params, function(data){
							if(data.length >0) {		
									$('#gridAvales').html(data);
									$('#gridAvales').show();
									if(tipoSolicitud == 'R'){
										validaEstatus();
									}	
							}else{				
									$('#gridAvales').html("");
									$('#gridavales').show();
							}
					});
				}
				
				
				
				function crearAvales(event){	
					var mandar = verificarvacios()
					if(mandar!=1){   		  		
						quitaFormatoControles('gridAvales');
						var numDetalle = $('input[name=consecutivoID]').length;
						$('#avales').val("");
						for(var i = 1; i <= numDetalle; i++){
							
							if(i == 1){
							$('#avales').val($('#avales').val() +
										$('#solicitudCreditoID').val() + ']' +
										document.getElementById("avalID"+i+"").value + ']' +
										document.getElementById("clienteID"+i+"").value + ']' +
										document.getElementById("prospectoID"+i+"").value + ']' +
										document.getElementById("tiempoConocido"+i+"").value + ']' +
										document.getElementById("parentescoID"+i+"").value);
						
							}else{
								$('#avales').val($('#avales').val() + '[' +
										$('#solicitudCreditoID').val() + ']' +
										document.getElementById("avalID"+i+"").value + ']' +
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
						quitaFormatoControles('gridAvales');
						var numDetalle = $('input[name=consecutivoID]').length;
						$('#avales').val("");

						for ( var i = 1; i <= numDetalle; i++) {

							var idcc = document.getElementById("avalID" + i
									+ "").value;
							if (idcc == "") {
								document.getElementById("avalID" + i + "")
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
						deshabilitaBoton('agregaAval', 'submit');
						deshabilitaBoton('autorizar', 'submit');
						deshabilitaBoton('grabar', 'submit');
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

//////////////////funcion consultar Aval//////////////////
function consultaAvalGrid(idControl,tipoAval){
	var clienteActivo = 'A';
	var conCred;
	var control;
	var rol;
	
	switch (tipoAval) {
	case 1:
		conCred = 1;
		break;
	case 2:
		conCred = catTipoListaAvales.aval;								
		control= idControl.substr(6,idControl.length);
		rol = 'Aval';
		break;
	case 3:
		conCred = catTipoListaAvales.cliente;
		control= idControl.substr(9,idControl.length);
		rol = $('#valCliente').val();
		break;
	case 4:
		conCred = catTipoListaAvales.prospecto;
		control= idControl.substr(11,idControl.length);
		rol = 'Prospecto';
		break;
	}
	
	var controlID = eval("'#" + idControl + "'");		
	var numAval = $(controlID).val();					
	var aval = eval("'#avalID" + control + "'");		
	var cliente = eval("'#clienteID" + control + "'");
	var prospecto = eval("'#prospectoID" + control + "'");	
	var nombre = eval("'#nombre" + control + "'");		
	
	var AvalBeanCon = {
		'avalID':numAval
	};

	setTimeout("$('#cajaLista').hide();", 200);
	
		if(numAval != '' && !isNaN(numAval) && numAval !='0' && numAval != ''){
			avalesServicio.consulta(conCred,AvalBeanCon,function(avales){
				
				if(avales!=null){
							
					if(cantidadAvales < avales.creditosAvalados){
						mensajeSis("El " + rol + " ya Tiene la Cantidad de Créditos Avalados Permitidos.");
						$(aval).val("");
						$(cliente).val("");
						$(prospecto).val("");
						$(nombre).val("");
						switch (conCred) {
	                        case 1:
	                                conCred = 1;
	                                break;
	                        case 2:
	                                $(aval).focus();
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
							if(avales.estatusCliente !=clienteActivo){
								mensajeSis("El " + rol + " No esta Activo.");
								$(aval).val("");
								$(cliente).val("");
								$(prospecto).val("");
								$(nombre).val("");
			                    $(cliente).focus();
							} else {
								$(aval).val(avales.avalID);
								$(cliente).val(avales.clienteID);
								$(prospecto).val(avales.prospectoID);
								$(nombre).val(avales.nombreCompleto);
								habilitaBoton('grabar',' submit' );
							}
						} else {
							$(aval).val(avales.avalID);
							$(cliente).val(avales.clienteID);
							$(prospecto).val(avales.prospectoID);
							$(nombre).val(avales.nombreCompleto);
							habilitaBoton('grabar',' submit' );
						}
					}
					
					
				} else {
		            mensajeSis("El " + rol + " No Existe.");
		            $(aval).val("");
		            $(cliente).val("");
		            $(prospecto).val("");
		            $(nombre).val("");
		            switch (conCred) {
		                case 1:
		                        conCred = 1;
		                        break;
		                case 2:
		                        $(aval).focus();
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
					if(($(aval).asNumber() > 0) && $(cliente).asNumber() == 0 && $(prospecto).asNumber() == 0){
						$(aval).val("");
						$(cliente).val("");
						$(prospecto).val("");
						$(nombre).val("");
					}
					break;
				case 3:
					if(($(cliente).asNumber() > 0) && $(aval).asNumber() == 0 && $(prospecto).asNumber() == 0){
						$(aval).val("");
						$(cliente).val("");
						$(prospecto).val("");
						$(nombre).val("");
					}
					break;
				case 4:
					if(($(prospecto).asNumber() > 0) && $(aval).asNumber() == 0 && $(cliente).asNumber() == 0){
						$(aval).val("");
						$(cliente).val("");
						$(prospecto).val("");
						$(nombre).val("");
					}
					break;
			}
		}

	}

// Lista de Avales
function listaAvales(idControl) {
	var jq = eval("'#" + idControl + "'");
	var sbtrn = (idControl.length);
	var Control = idControl.substr(6, sbtrn);
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
		lista(idControl, '1', '1', camposLista, parametrosLista,
				'listaAvales.htm');
	});
}

// Lista de Clientes
function listaClientes(idControl) {
	var jq = eval("'#" + idControl + "'");
	var sbtrn = (idControl.length);
	var Control = idControl.substr(9, sbtrn);
	var avalGrid = eval("'#avalID" + Control + "'");
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
	var avalGrid = eval("'#avalID"+Control+"'");
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

//Lista de Parentescos con el Aval
function listaParentescos(idControl){
		var numero= idControl.substr(12,idControl.length);
		var parametro = $('#parentescoID'+numero).val();		
		var campo = "descripcion";
		lista(idControl, '2', '1', campo, parametro, 'listaParentescos.htm');
}

//Consulta de Parentescos con el Aval
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