var accedeHuella = 'N';
var huella_nombreCompleto,huella_usuarioID,huella_OrigenDatos, motivo, motivoID, bandera;

	function inicializa() {
		// Esta es tu funcion de exito
		if(bandera == 'S'){
		serverHuella.registroBitacoraUsuario(motivo,motivoID, huella_usuarioID, $('#campoGenerico').val());
		}	
		if($('#numeroMensaje').val()){
			inicializaForma('formaGenerica', 'numero');
			deshabilitaBoton('aceptar', 'submit');
			$('#creditoID').focus();
		}
	}
	function funcionError(){
	
	}


	var serverHuella = new HuellaServer({

	fnHuellaValida:	function(datos){
							$('#contraseniaUsuarioAutoriza').val('HD>>'+datos.tokenHuella);
							grabaFormaTransaccionRetrollamada({}, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID','inicializa','funcionError');
							$('#tipoTransaccion').val('');
							$('#usuarioAutorizaID').val('');
							$('#contraseniaUsuarioAutoriza').val('');
							$('#statusSrvHuella').hide();
							accedeHuella = '';


					},
	fnHuellaInvalida: function(datos){
							return false;
					}
	});
$(document).ready(function(){
	//Definición de constantes y Enums
	esTab = true;
	var parametroBean = consultaParametrosSession();   
	var catTipoConsultaCredito = { 
  		'principal'	: 1,
  		'foranea'	: 2,
  		'pago'		: 7 
	};	
			
	var catTipoTranCredito = { 
  		'pagoCredito'		: 12 ,
  		'pagoCreditoGrupal': 18 ,
	};		
	//-----------------------Métodos y manejo de eventos-----------------------

	var procedePago = 2;
	var montoPagarMayor = 1;
	deshabilitaBoton('aceptar', 'submit');
    $('#creditoID').focus();
		
	$(':text').focus(function() {	
	 	esTab = false;
	});
	
	agregaFormatoControles('formaGenerica');
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});			
    
   	$.validator.setDefaults({
            submitHandler: function(event) { 
                grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID','inicializa','funcionError');  
            }
    });	
   	
  
		
	$('#creditoID').blur(function(){
		consultaCredito(this.id);		
	});		
		
	$('#creditoID').bind('keyup', function(e){
		lista('creditoID', '2', '4', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
	});

	$('#cuentaID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "clienteID";
		parametrosLista[0] = $('#clienteID').val();
		listaAlfanumerica('cuentaID', '0', '2', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');		       
	});
	
	$('#cuentaID').blur(function(){
		consultaCta(this.id);		
	});
	
	$('#usuarioAutorizaID').blur(function(){
  		validaUsuario(this);		
	});
	
	$('#aceptar').click(function(event) {
		motivo ='REVERSA DE DESEMBOLSO';
		motivoID = 103;

		if(!$('#formaGenerica').valid()){
			return false;
		}

		if(accedeHuella == 'S'  && $('#usuarioAutorizaID').val() != '' ){
			bandera = 'N';
			$('#tipoTransaccion').val(catTipoTranCredito.pagoCredito);
			if($('#contraseniaUsuarioAutoriza').val() != ''){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID', 'inicializa','funcionError');
							$('#tipoTransaccion').val('');
							$('#usuarioAutorizaID').val('');
							$('#contraseniaUsuarioAutoriza').val('');
							$('#statusSrvHuella').hide();
			}else{
				bandera = 'S';		
				serverHuella.funcionMostrarFirmaUsuario(
					huella_nombreCompleto,huella_usuarioID,huella_OrigenDatos
				);
			}
		}else{ 
			if($('#contraseniaUsuarioAutoriza').val() == ''){
				mensajeSis("La contraseña está vacía");
				$('#contraseniaUsuarioAutoriza').focus();
			}else{
				bandera = 'N';
				$('#tipoTransaccion').val(catTipoTranCredito.pagoCredito);
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID', 'inicializa','funcionError');
							$('#tipoTransaccion').val('');
							$('#usuarioAutorizaID').val('');
							$('#contraseniaUsuarioAutoriza').val('');
							$('#statusSrvHuella').hide();
			}
			
		}
	});
	
	$('#fechaSistema').val(parametroBean.fechaAplicacion);
	

	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
		rules: {
			creditoID: {
				required: true
			},
			motivoReversa: {
				required: true,
				maxlength : 400
			},
			usuarioAutorizaID: {
				required: true
			}
	
		},
		messages: {
			creditoID: {
				required: 'Especificar Número de  Crédito'
			},
			motivoReversa: {
				required: 'Especificar Motivo Reversa Desembolso',
				maxlength:'Máximo de Caracteres'
			},
			usuarioAutorizaID: {
				required: 'Especificar El Usuario'
			}
		}		
	});

	
	function validaUsuario(control) {
		var claveUsuario = $('#usuarioAutorizaID').val();
		serverHuella.cancelarOperacionActual();
		$('#statusSrvHuella').hide();
		if(claveUsuario != ''){
			var usuarioBean = {
					'clave':claveUsuario
			};
			usuarioServicio.consulta(3, usuarioBean, function(usuario) {
							if(usuario!=null){
								accedeHuella = usuario.accedeHuella;
								huella_nombreCompleto = usuario.clave;
								huella_usuarioID = usuario.usuarioID;	
								huella_OrigenDatos = usuario.origenDatos;
								if(accedeHuella=='S'){
									$('#statusSrvHuella').show(500);
								}else{
									$('#statusSrvHuella').hide();
								}
							}else{
								mensajeSis('El Usuario Ingresado No Existe');
								accedeHuella=='N';
							}
				});
		}
	}
	
//-------------Validaciones de controles---------------------
/////consulta GridIntegrantes////////////
	
	function consultaDetalle(){	
		var params = {};
		params['tipoLista'] = 7;
		params['grupoID'] = $('#grupoID').val();
		params['ciclo'] = $('#cicloID').val(); 
		
		$.post("listaIntegrantesGpo.htm", params, function(data){
				if(data.length >0) {		
						$('#gridIntegrantes').html(data);
						
						$('input[name=productCre]').each(function() {		
							var jqCicInf = eval("'#" + this.id + "'");	
							productoCreditoID = $(jqCicInf).asNumber();
						});
						$('#gridIntegrantes').show();					
				}else{				
						$('#gridIntegrantes').html("");
						$('#gridIntegrantes').show();
				}
	
		});
	}		
		
	function mostrarIntegrantesGrupo(){	
		var params = {};
		params['tipoLista'] = 7;
		params['grupoID'] = $('#grupoID').val();
		params['ciclo'] = $('#cicloID').val();  
		$.post("listaIntegrantesGpo.htm", params, function(data){
			if(data.length >0) {		
				$('#gridIntegrantes').html(data);
				var contador = 0;
				$('input[name=cuentaGLID]').each(function() {	
					contador = contador + 1;
					ctaGLAdiID = eval("'#clienteIDIntegrante"+contador+"'");
				});
				$('#gridIntegrantes').show();					
			}else{				
				$('#gridIntegrantes').html("");
				$('#gridIntegrantes').hide();
			}		
		});
	}
	
//consulta credito
	function consultaCredito(controlID){
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) && esTab){
			var creditoBeanCon = { 
					'creditoID':$('#creditoID').val(),
					'fechaActual':$('#fechaSistema').val()
			};
			creditosServicio.consulta(18,creditoBeanCon,function(credito) {//catTipoConsultaCredito.saldos
				if(credito!=null){
					esTab=true;	
					dwr.util.setValues(credito);
					consultaCliente('clienteID');			
					consultaMoneda('monedaID');							
					consultaLineaCredito('lineaCreditoID');	
					consultaCta('cuentaID');
					consultaProducCredito('producCreditoID');
					var estatus = credito.estatus;
					validaEstatusCredito(estatus);
					habilitaBoton('aceptar', 'submit');
					$('#grupoID').val(credito.grupoID); 
					if(credito.grupoID > 0){
					$('#cicloID').val(credito.cicloGrupo);
					consultaGrupo(credito.grupoID,'grupoID','grupoDes');
					mostrarIntegrantesGrupo('grupoID');
					$('#tdGrupoGrupoCredinput').show();
   					$('#tdGrupoGrupoCredlabel').show();
   					$('#motivo').val("");
   					$('#usuarioAutorizaID').val("");
   					$('#contraseniaUsuarioAutoriza').val("");
					}
					else{
	   					$('#tdGrupoGrupoCredinput').hide();
	   					$('#tdGrupoGrupoCredlabel').hide();
	   					$('#gridIntegrantes').hide();
	   					$('#grupoID').val(0);  
						$('#grupoDes').val("");
						$('#motivo').val("");
	   					$('#usuarioAutorizaID').val("");
	   					$('#contraseniaUsuarioAutoriza').val("");
						$('#tipoTransaccion').val(catTipoTranCredito.pagoCredito);
					}

										
				}else{
					inicializaForma('formaGenerica','creditoID');
					mensajeSis("No Existe el Crédito");
					deshabilitaBoton('aceptar','submit');
					$('#tdGrupoGrupoCredinput').hide();
   					$('#tdGrupoGrupoCredlabel').hide();
   					$('#gridIntegrantes').hide();
   					$('#grupoID').val("");  
					$('#grupoDes').val("");
					$('#creditoID').focus();
					$('#creditoID').select();	
				}
			});
		}
	}
	

	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConPagoCred = 8;	 
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente != '' && !isNaN(numCliente) && esTab){
			clienteServicio.consulta(tipConPagoCred,numCliente,function(cliente) {
				if(cliente!=null){	
					$('#clienteID').val(cliente.numero);						
					$('#nombreCliente').val(cliente.nombreCompleto);
					$('#pagaIVA').val(cliente.pagaIVA);
				}else{
					mensajeSis("No Existe el Cliente");
					$('#clienteID').focus();
					$('#clienteID').select();	
				}    	 						
			});
		}
	}
		
	function consultaMoneda(idControl) {
		var jqMoneda = eval("'#" + idControl + "'");
		var numMoneda = $(jqMoneda).val();	
		var conMoneda=2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numMoneda != '' && !isNaN(numMoneda)){
			monedasServicio.consultaMoneda(conMoneda,numMoneda,function(moneda) {
				if(moneda!=null){							
					$('#monedaDes').val(moneda.descripcion);										
				}else{
					mensajeSis("No Existe el Tipo de Moneda");
					$('#monedaDes').val('');
					$(jqMoneda).focus();
				}
			});
		}
	}
		
		
	function consultaLineaCredito(idControl) {
		var jqLinea  = eval("'#" + idControl + "'");
		var lineaCred = $(jqLinea).val();	
		var lineaCreditoBeanCon = {
			'lineaCreditoID'	:lineaCred
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(lineaCred != '' && !isNaN(lineaCred) && esTab){
			lineasCreditoServicio.consulta(catTipoConsultaCredito.principal,lineaCreditoBeanCon,function(linea) {
				if(linea!=null){
					var estatus = linea.estatus;
					$('#saldoDisponible').val(linea.saldoDisponible);
					$('#dispuesto').val(linea.dispuesto);
					$('#numeroCreditos').val(linea.numeroCreditos);
					validaEstatusLineaCred(estatus);
				}						
			});																						
		}
	}
	
	function consultaProducCredito(idControl) {
		var jqProdCred  = eval("'#" + idControl + "'");
		var ProdCred = $(jqProdCred).val();			
		var ProdCredBeanCon = {
  			'producCreditoID':ProdCred
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(ProdCred != '' && !isNaN(ProdCred) && esTab){		
			productosCreditoServicio.consulta(catTipoConsultaCredito.principal,ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){	
					$('#descripProducto').val(prodCred.descripcion);
					
				}else{							
					mensajeSis("No Existe el Producto de Crédito");																			
				}
			});
		}									
	}
	
	function validaEstatusCredito(var_estatus) {
		var estatusInactivo 	="I";		
		var estatusAutorizado 	="A";
		var estatusVigente		="V";
		var estatusPagado		="P";
		var estatusCancelada 	="C";		
		var estatusVencido		="B";
		var estatusCastigado 	="K";		
		
		if(var_estatus == estatusInactivo){
			$('#estatus').val('INACTIVO');
			habilitaBoton('pagar', 'submit');
		}	
		if(var_estatus == estatusAutorizado){
			$('#estatus').val('AUTORIZADO');
			habilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusVigente){
			$('#estatus').val('VIGENTE');
			habilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusPagado){
			$('#estatus').val('PAGADO');
			deshabilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusCancelada){
			$('#estatus').val('CANCELADO');							
			habilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusVencido){
			$('#estatus').val('VENCIDO');							
			habilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusCastigado){
			$('#estatus').val('CASTIGADO');							
			habilitaBoton('pagar', 'submit');
		}		
	}
	
	function validaEstatusLineaCred(var_estatus) {
		var estatusActivo 		="A";
		var estatusBloqueado 	="B";
		var estatusCancelada 	="C";
		var estatusInactivo 	="I";
		var estatusRegistrada	="R";
	
		if(var_estatus == estatusActivo){
			 $('#estatusLinCred').val('ACTIVO');
		}
		if(var_estatus == estatusBloqueado){
			 $('#estatusLinCred').val('BLOQUEADO');
		}
		if(var_estatus == estatusCancelada){
			 $('#estatusLinCred').val('CANCELADO');
		}
		if(var_estatus == estatusInactivo){
			 $('#estatusLinCred').val('INACTIVO');
		}
		if(var_estatus == estatusRegistrada){
			 $('#estatusLinCred').val('REGISTRADO');
		}		
	}
	
	function consultaCta(idControl) {
		var jqnumCta  = eval("'#" + idControl + "'");
		var numCta = $(jqnumCta).val();	 
        var conCta = 3;   
        var CuentaAhoBeanCon = {
        		'cuentaAhoID':numCta,
        		'clienteID':$('#clienteID').val()
        };
        setTimeout("$('#cajaLista').hide();", 200);
        if(numCta != '' && !isNaN(numCta)){
            cuentasAhoServicio.consultaCuentasAho(conCta, CuentaAhoBeanCon,function(cuenta) {
            	if(cuenta!=null){ 
            		$('#nomCuenta').val(cuenta.tipoCuentaID);
                	consultaTipoCta('nomCuenta'); 
					consultaSaldoCta('cuentaID'); 
            	}else{
            		mensajeSis("No Existe la Cuenta de Ahorro");
            	}
            });                                                                                                                        
        }  
	}
	
	function consultaTipoCta(idControl) {
		var jqTipoCta = eval("'#" + idControl + "'");
		var numTipoCta = $(jqTipoCta).val();
		var conTipoCta=2;
		var TipoCuentaBeanCon = {
  			'tipoCuentaID':numTipoCta
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numTipoCta != '' && !isNaN(numTipoCta)){
			tiposCuentaServicio.consulta(conTipoCta, TipoCuentaBeanCon,function(tipoCuenta) {
				if(tipoCuenta!=null){			
					$('#nomCuenta').val(tipoCuenta.descripcion);							
				}else{
					$(jqTipoCta).focus();
				}    						
			});
		}
	}
	
	function consultaSaldoCta(idControl) {
		var jqnumCta  = eval("'#" + idControl + "'");
		var numCta = $(jqnumCta).val();	 
        var conCta = 5;   
        var CuentaAhoBeanCon = {
        		'cuentaAhoID':numCta,
        		'clienteID':$('#clienteID').val()
        };
        setTimeout("$('#cajaLista').hide();", 200);
        if(numCta != '' && !isNaN(numCta)){
       		cuentasAhoServicio.consultaCuentasAho(conCta,
                													CuentaAhoBeanCon,function(cuenta) {
                	if(cuenta!=null){ 
                	               		
							$('#saldoCta').val(cuenta.saldoDispon);
            
                	}else{
                		mensajeSis("No Existe la Cuenta de Ahorro");
                	}
                });                                                                                                                        
        }
        
	}
	
	// Consulta de grupos 
	//function consultaGrupo(valID, id, desGrupo,idCiclo)
	function consultaGrupo(valID, id, desGrupo) { 
		var jqDesGrupo  = eval("'#" + desGrupo + "'");
		var jqIDGrupo  = eval("'#" + id + "'");
		var numGrupo = valID;	
		var tipConGrupo= 1;
		var grupoBean = {
			'grupoID'	:numGrupo
		};
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numGrupo != '' && !isNaN(numGrupo) ){
			gruposCreditoServicio.consulta(tipConGrupo, grupoBean,function(grupo) {
				if(grupo!=null){	
					$(jqIDGrupo).val(grupo.grupoID);
					$(jqDesGrupo).val(grupo.nombreGrupo);	
				}
			});															
		}
	}

	
	//crear lista
	function crearListaReversaDes(){	
		var contador = 0;
		var creditoID = 0;
		var ctaGLAdiID = 0;
		var clienteID = 0;
		var nombreIntegrante = 0;
		$('#listaReversaDes').val("");
		$('input[name=cuentaGLID]').each(function() {	
			contador = contador + 1;
			
			creditoID = eval("'#creditoIDIntegrante"+contador+"'");
			ctaGLAdiID = eval("'#cuentaGLID"+contador+"'");
			clienteID = eval("'#clienteID"+contador+"'");
			nombreIntegrante = eval("'#nombreIntegrante"+contador+"'");

			if(contador ==1){
				$('#listaReversaDes').val(
						$(creditoID).asNumber()+"]"+$(ctaGLAdiID).asNumber()+"]"+$(clienteID).asNumber()+"]"+$(nombreIntegrante).asNumber());
			}else{
				$('#listaReversaDes').val($('#listaReversaDes').val()+"["+
						$(creditoID).asNumber()+"]"+$(ctaGLAdiID).asNumber()+"]"+$(clienteID).asNumber()+"]"+$(nombreIntegrante).asNumber() );
			}
		});
	}
	
	
});