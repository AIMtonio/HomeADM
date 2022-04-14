var varperfilCancelPROFUN =0;
$(document).ready(function() {
	esTab = false;
	
	var catTipoConsultaCta = {
  		'prinAct':15
	};

	//-- Colocando los parámetreos de sesion--//
	parametroBean = consultaParametrosSession();
	var perfilUsuario =parametroBean.perfilUsuario; //Perfil del USuario logueado
	inicializaClientesPROFUNRegistro(); /*funcion para limpiar la forma*/
	
	// Definicion de Constantes y Enums
	var catTransClientePROFUN = {
		'guardar' : '1',
		'cancelar' : '2'
	};	
	
	var catTipoActClientePROFUN = {
			'cancelar' : '1'
	};
	
	
	var catTipoConsultaClientesPROFUN = {
	  		'principal':1,
	};
	
	var catTipoConsultaUsuarioPROFUN = {
	  		'principal':1,
	};
	expedienteBean = {
			'clienteID' : 0,
			'tiempo' : 0,
			'fechaExpediente' : '1900-01-01',
	};	

	listaPersBloqBean = {
			'estaBloqueado'	:'N',
			'coincidencia'	:0
	};
	var esCliente 			='CTE';
	var esUsuario			='USS';
	//-- Haciendo la transaccion
	$.validator.setDefaults({
	    submitHandler: function(event) { 
	    	grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','clienteID','funcionExitoProfun','funcionFalloProfun'); 
	      }
	 });
	
	consultaParametrosCaja();
	/* funcion para llenar de manera automatica la pantalla cuando se consulta el cliente 
	 * 	en la pantalla de tabs*/
	if($('#flujoCliNumCli').val() != undefined){
		if(!isNaN($('#flujoCliNumCli').val())){
			var numCliFlu = Number($('#flujoCliNumCli').val());
			if(numCliFlu > 0){
				$('#clienteID').val($('#flujoCliNumCli').val());
				consultaClientePROFUN('clienteID');
			}else{
				$('#personaFisica').show(500);
				$('#personaMoral').hide(500);
				$('#clienteID').val('0');
				$('#clienteID').focus().select();
			}
		}
	}
	
	$(':text').focus(function() {	
		esTab = false;
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
			
	$('#cancelar').click(function() {		
		$('#tipoActualizacion').val(catTipoActClientePROFUN.cancelar);
		$('#tipoTransaccion').val(catTransClientePROFUN.cancelar);
	});
	
	$('#guardar').click(function() {		
		$('#tipoActualizacion').val(catTransClientePROFUN.guardar);
		$('#tipoTransaccion').val(catTransClientePROFUN.guardar);
	});
	
	//--Lista de ayuda para Clientes--//
	$('#clienteID').bind('keyup',function(e) { 
		lista('clienteID', '2', '12', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	}); 
	
//	$('#clienteID').bind('keyup',function(e){
//		if($('#clienteID').val().length<3){		
//			$('#cajaListaCte').hide();
//		}
//	});

//	$('#buscarMiSuc').click(function(){
//		listaCte('clienteID', '3', '20', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
//	});
//	$('#buscarGeneral').click(function(){
//		listaCte('clienteID', '3', '12', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
//	});	
	
	
	$('#clienteID').blur(function() {
		if(esTab){
			setTimeout("$('#cajaLista').hide();", 200);
			var cliente = $('#clienteID').asNumber();
			if(cliente>0){
				listaPersBloqBean = consultaListaPersBloq(cliente, esCliente, 0, 0);
				if(listaPersBloqBean.estaBloqueado!='S'){
					expedienteBean = consultaExpedienteCliente(cliente);
					if(expedienteBean.tiempo<=1){
						consultaClientePROFUN(this.id);
					} else {
						mensajeSis('Es necesario Actualizar el Expediente del Cliente para Continuar.');
						inicializaClientesPROFUNRegistro();
						$('#clienteID').focus();
						$('#clienteID').val('');
					}
				} else {
					mensajeSis('La Persona se encuentra en la Lista de Personas Bloqueadas. No se puede Continuar con la Operación.');
					inicializaClientesPROFUNRegistro();
					$('#clienteID').focus();
					$('#clienteID').val('');
				}
			}			
		}
	});
	
    //-- Lista de ayuda para Tipo de Cuenta--//
	
	$('#cuentaAhoID').bind('keyup',function(e){	
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "clienteID";
		parametrosLista[0] = $('#clienteID').val();
		listaAlfanumerica('cuentaAhoID', '0', '2', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');		       
	});

	//-- Colocando en la caja de texto cuenta --//
	$('#cuentaAhoID').blur(function() {		
		consultaCtaAho($('#cuentaAhoID').val(),$('#clienteID').asNumber());
	});
	
	//------------ Validaciones de la Forma -------------------------------------	
	$('#formaGenerica').validate({
		rules: {
			clienteID: {
				required: true,
			
			},
			cuentaAhoID: {
				required: true
			}
		},
		messages: {
			clienteID: {
				required: 'Especificar Cliente',
				
			},
			cuentaAhoID: {
				required: 'Especifique la Cuenta'
			}
		}		
	});
	
	
	// ------------ Validaciones de Controles-------------------------------------
	
	/* Consulta del cliente en el beneficio PROFUN*/
	function consultaClientePROFUN(idControl) {
		var jqClientePROFUN = eval("'#" + idControl + "'");
		var numClientePROFUN = $(jqClientePROFUN).asNumber();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numClientePROFUN != '' && !isNaN(numClientePROFUN) ){	
			var clientePROFUNBeanCon ={
		 		 	'clienteID' : numClientePROFUN , 
		 		 	'cuentaAhoID' : $('#cuentaAhoID').val()
			};		
			clientesPROFUNServicio.consulta(catTipoConsultaClientesPROFUN.principal,clientePROFUNBeanCon,function(ClientePROFUN) {
				if(ClientePROFUN!=null){				
					$('#fechaRegistro').val(ClientePROFUN.fechaRegistro);    
					$('#usuarioReg').val(ClientePROFUN.usuarioReg);
					$('#sucursalReg').val(ClientePROFUN.sucursalReg);
					$('#estatus').val(ClientePROFUN.estatus).selected == true;
					$('#lblEstatus').show();
					$('#estatus').show();
					consultaUsuario(ClientePROFUN.usuarioReg);
					consultaSucursal(ClientePROFUN.sucursalReg);
					consultaCliente('clienteID'); 
					
					switch(ClientePROFUN.estatus){
						case "C": //cliente con estatus cancelado    
							$('#fechaCancela').val(ClientePROFUN.fechaCancela);
							$('#sucursalCan').val(ClientePROFUN.sucursalCan);
							esTab=true;
							consultaSucursalCancela(ClientePROFUN.sucursalCan);
							habilitaBoton('guardar', 'submit');
							deshabilitaBoton('cancelar', 'submit');
							$('#guardar').focus();
							$('#filaCancelar').show();
							break;
						case "P": //cliente con estatus pagado         
							$('#fechaCancela').val(parametroBean.fechaSucursal);
							$('#sucursalCan').val(parametroBean.sucursal);
							deshabilitaControl('cuentaAhoID');
							deshabilitaBoton('cancelar');
							deshabilitaBoton('guardar', 'submit'); //jjj
							$('#filaCancelar').hide();
							break;		
						case "R": //cliente con estatus registrado
							$('#fechaCancela').val(parametroBean.fechaSucursal);
							$('#sucursalCan').val(parametroBean.sucursal);
							deshabilitaBoton('guardar', 'submit');
							
							if(perfilUsuario == varperfilCancelPROFUN ){
								habilitaBoton('cancelar', 'submit');
							}else{
								deshabilitaBoton('cancelar', 'submit');//jjj
							}
							$('#filaCancelar').hide();
							break;							
						case "I":
							$('#fechaCancela').val(parametroBean.fechaSucursal);
							$('#sucursalCan').val(parametroBean.sucursal);
							deshabilitaBoton('guardar', 'submit');
						
							if(perfilUsuario == varperfilCancelPROFUN ){
								habilitaBoton('cancelar', 'submit');
							}else{
								deshabilitaBoton('cancelar', 'submit');//jjj
							}
							$('#filaCancelar').hide();
							break;
						default : 
							$('#fechaCancela').val(parametroBean.fechaSucursal);
							$('#sucursalCan').val(parametroBean.sucursal);
							deshabilitaBoton('guardar', 'submit');
							deshabilitaBoton('cancelar', 'submit');
							$('#filaCancelar').hide();
							break;
					}							
					$('#cancelar').focus();
				}else{
					inicializaClientesPROFUNNuevoRegistro();
					consultaCliente('clienteID'); 					
				}	
			});			
		}
	} 
	
	//-- Consulta de cliente --//
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		setTimeout("$('#cajaLista').hide();", 200);
		if (numCliente != '' && !isNaN(numCliente)) {
			clienteServicio.consulta(1, numCliente, function(cliente) {
				if (cliente != null) {
					if(cliente.estatus != 'A'){
						mensajeSis("El Cliente Se Encuentra Inactivo.");
						inicializaClientesPROFUNRegistro();
						deshabilitaBoton('guardar', 'submit');
						deshabilitaBoton('cancelar', 'submit');
						$(jqCliente).focus();
						$(jqCliente).val('');
					}else{
						if(cliente.edad < 18){
							mensajeSis("El Cliente es Menor de Edad.");
							inicializaClientesPROFUNNuevoRegistro();
							deshabilitaBoton('guardar', 'submit');
							deshabilitaBoton('cancelar', 'submit');
							$(jqCliente).focus();
							$(jqCliente).val('');
							 
						}
						else{
									$('#clienteID').val(cliente.numero);
									$('#nombreCliente').val(cliente.nombreCompleto);
									$('#fechaIngresoID').val(cliente.fechaAlta);
									$('#fechaNacimientoID').val(cliente.fechaNacimiento);
									$('#promotorID').val(cliente.promotorActual);
									consultaNomPromotorA('promotorID');
									$('#sucursalID').val(cliente.sucursalOrigen);
									consultaSucursalCliente('sucursalID');
									switch(cliente.tipoPersona){
										case 'F':
											$('#tipoPersonaID').val("FÍSICA");
											break;
										case 'A':
											$('#tipoPersonaID').val(" FÍSICA ACT. EMP.");
											break;
										case 'M':
											$('#tipoPersonaID').val("MORAL");
											break;
										default:
											$('#tipoPersonaID').val(cliente.tipoPersona);
									}
						}
					}
				} else {
					mensajeSis('El Cliente No Existe');
					$(jqCliente).focus();
					$(jqCliente).val("");
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
		        	$('#nombrePromotorID').val(promotor.nombrePromotor);
				} else {
					mensajeSis("No Existe el Promotor");
				}
			});
		}
	}
	
	//-- Consultar el usuario
	function consultaUsuario(numUsuario) {
		var usuarioBeanCon = {
			'usuarioID':numUsuario 
		};
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numUsuario != '' && !isNaN(numUsuario) ){
			usuarioServicio.consulta(catTipoConsultaUsuarioPROFUN.principal,usuarioBeanCon,function(usuario) {  
				if(usuario!=null){		
					$('#nombreUsuario').val(usuario.nombreCompleto);
				}	
			});
		}
	}
	
	/*Consulta la sucursal del registro del cliente en profun*/
	function consultaSucursal(numSucursal) {
		var conSucursal = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numSucursal != '' && !isNaN(numSucursal)) {
			sucursalesServicio.consultaSucursal(conSucursal,numSucursal, function(sucursal) {
				if (sucursal != null) {
					$('#desSucursalRegistro').val(sucursal.nombreSucurs);
				} else {
					mensajeSis("No Existe la Sucursal");
				}
			});
		}
	}
	
	/*Consulta la sucursal donde se cancelo el registro del cliente en profun*/
	function consultaSucursalCancela(numSucursal) {
		var conSucursal = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numSucursal != '' && !isNaN(numSucursal) && esTab) {
			sucursalesServicio.consultaSucursal(conSucursal,numSucursal, function(sucursal) {
				if (sucursal != null) {
					$('#nombreSucursalCan').val(sucursal.nombreSucurs);
				} else {
					mensajeSis("No Existe la Sucursal");
				}
			});
		}
	}
	
	/*Consulta la sucursal del CLiente*/
	function consultaSucursalCliente(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();
		var conSucursal = 2;
		setTimeout("$('#cajaLista').hide();", 200);
		if (numSucursal != '' && !isNaN(numSucursal) && esTab) {
			sucursalesServicio.consultaSucursal(conSucursal,numSucursal, function(sucursal) {
				if (sucursal != null) {
					$('#nombreSucursalID').val(sucursal.nombreSucurs);
				} else {
					mensajeSis("No Existe la Sucursal");
				}
			});
		}
	}	

	
	function consultaCtaActPrin(control) {
		var jqnumCte = eval("'#" + control + "'");
		var	cliente = $(jqnumCte).val(); 
		$('#gridReporteMovimientos').hide();     
		var CuentaAhoBeanCon = {
                'clienteID':cliente
		};
		setTimeout("$('#cajaLista').hide();", 200);    
		if(cliente != '' && !isNaN(cliente)){ 
			cuentasAhoServicio.consultaCuentasAho(catTipoConsultaCta.prinAct, CuentaAhoBeanCon, function(cuenta) {
				if(cuenta!=null){
					$('#cuentaAhoID').val(cuenta.cuentaAhoID);
					esTab=true;
                	consultaCtaAho(cuenta.cuentaAhoID,cliente);
                	$('#cuentaAhoID').focus();
				}
				else{
					$('#cuentaAhoID').focus();
	          		$('#cuentaAhoID').val("");
	          		$('#desCuentaAho').val("");
				}
			});                                                                                                                        
		}
	}
});

var parametroBean = consultaParametrosSession();

/*funcion para limpiar la forma*/
function inicializaClientesPROFUNRegistro(){
	inicializaForma('formaGenerica', 'clienteID');
	$('#clienteID').focus();
	$('#usuarioReg').val(parametroBean.numeroUsuario);   
	$('#nombreUsuario').val(parametroBean.nombreUsuario);           
	$('#fechaRegistro').val(parametroBean.fechaSucursal);           
	$('#fechaCancela').val(parametroBean.fechaSucursal);
	$('#usuarioCan').val(parametroBean.numeroUsuario);
	$('#sucursalReg').val(parametroBean.sucursal);
	$('#sucursalCan').val(parametroBean.sucursal);
	$('#desSucursalRegistro').val(parametroBean.nombreSucursal);
	deshabilitaBoton('guardar', 'submit');
	deshabilitaBoton('cancelar', 'submit');
	$('#filaCancelar').hide();	
}

/*funcion para limpiar la forma*/
function inicializaClientesPROFUNNuevoRegistro(){
	inicializaForma('formaGenerica', 'clienteID');
	habilitaBoton('guardar', 'submit');
	deshabilitaBoton('cancelar', 'submit');
	$('#usuarioReg').val(parametroBean.numeroUsuario);   
	$('#nombreUsuario').val(parametroBean.nombreUsuario);           
	$('#fechaRegistro').val(parametroBean.fechaSucursal);        
	$('#fechaCancela').val(parametroBean.fechaSucursal);
	$('#usuarioCan').val(parametroBean.numeroUsuario);
	$('#sucursalReg').val(parametroBean.sucursal);
	$('#sucursalCan').val(parametroBean.sucursal);
	$('#desSucursalRegistro').val(parametroBean.nombreSucursal);
	$('#guardar').focus();
	$('#filaCancelar').hide();
	$('#lblEstatus').hide();
	$('#estatus').hide();
}

function funcionExitoProfun(){
	inicializaClientesPROFUNRegistro();
}

function funcionFalloProfun(){
		
}


//-- Funcion para consultar el monto-- //
function consultaParametrosCaja() {
	var numParametrosCaja = 1;
	setTimeout("$('#cajaLista').hide();", 200);
	if(numParametrosCaja != ''){
		
		var parametrosCajaBeanCon ={
	 		 	'empresaID' : numParametrosCaja		 		 	
		};	
		parametrosCajaServicio.consulta(1,parametrosCajaBeanCon, function(ParametrosCaja) {
			if(ParametrosCaja!=null){	
				$('#perfilCancelPROFUN').val(ParametrosCaja.perfilCancelPROFUN);
				varperfilCancelPROFUN = ParametrosCaja.perfilCancelPROFUN;
				
			}else{
				mensajeSis('Valores no parametrizados');
				funcionExitoProfun();		
				varperfilCancelPROFUN =parseFloat(0);	
			}					
		});		
	}		
}