var montoMaximoProteccion = parseFloat(0);
var confirmar 				=false;
var EstatusAutorizado		= 'A';
var EstatusPagado			= 'P';
var EstatusRegistrado		= 'R';
var Var_EstatusProteccion	='';
var Var_EstatusRechazado	='C';

var Var_DeshabilitaBotonesGrid	='N';
var Var_PerfilAutoriProtec	= 0;

var catTipoTranPRoteccionCtaAhorro = {
		'alta'		:	1,
		'actualiza'	:	2
};	

var catTipoActProteccionCtaAhorro = {
		'autoriza'	:	1,
		'rechaza'	:	2
};	

$(document).ready(function() {
	esTab = false;
	
	//Definicion de Constantes y Enums  
	catTipoTranPRoteccionCtaAhorro = {
			'alta'		:	1,
			'actualiza'	:	2
	};	

	catTipoActProteccionCtaAhorro = {
			'autoriza'	:	1,
			'rechaza'	:	2
	};	

	var parametroBean = consultaParametrosSession();
	var perfilUsuario =parametroBean.perfilUsuario; //Perfil del USuario logueado
	$('#usuarioAut').val(parametroBean.numeroUsuario);
	var montoAplicaCredito	=0.00;
	consultaParametrosProteccion(); // consultamos los parametros de la empresa
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('agrega', 'submit');
	deshabilitaBoton('adjuntar', 'submit');
	deshabilitaBoton('guardarAutorizaRechaza', 'submit');
	agregaFormatoControles('formaGenerica');
	$('#clienteID').focus();
	
	$(':text').focus(function() {	
		esTab = false;	
	});

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$.validator.setDefaults({
	      submitHandler: function(event) { 
	    		ejecutaFuncion = validaAutorizaRechazo();
	    		if(ejecutaFuncion){
		    		if(confirmar == true){
		    			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','clienteID','ExitoProteccion','ErrorProteccion');
		    		}
	    		}
	      }
	  });
	
	$('#clienteID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "nombreCompleto";
		camposLista[1] = "areaCancela";
		parametrosLista[0] = $('#clienteID').val();
		parametrosLista[1] = 'Pro';
		lista('clienteID', '2', '4', camposLista, parametrosLista, 'listaClientesCancela.htm');
	});

	$('#buscarMiSuc').click(function(){
		listaCte('clienteID', '3', '22', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});
	
	$('#buscarGeneral').click(function(){
		listaCte('clienteID', '3', '10', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
	});

	$('#clienteID').blur(function() {
		if(esTab){
			consultaSolicitudCancelaCliente(this.id);
		}		
	});
	
	$('#agrega').click(function(){		
		$('#tipoTransaccion').val(catTipoTranPRoteccionCtaAhorro.alta);
		confirmar =true;
		guardarGridCreditos();
		guardarGridCuentas();		
	});
	
	$('#guardarAutorizaRechaza').click(function(){		
		$('#tipoTransaccion').val(catTipoTranPRoteccionCtaAhorro.actualiza);		
		if(  $('#autorizar').attr('checked')==true){
			$('#tipoActualizacion').val(catTipoActProteccionCtaAhorro.autoriza);						
			confirmarAutorizar();	
		}else{
			$('#tipoActualizacion').val(catTipoActProteccionCtaAhorro.rechaza);
			confirmar =true;
		}					
	});
	
	$('#autorizar').click(function(){		
		$('#autorizar').focus();	
	});
	
	$('#rechazar').click(function(){		
		$('#rechazar').focus();
	});
	
	$('#autorizar').change(function() {
		 if($('#autorizar').is(":checked")){
			 $('#autorizar').focus();
		 }else{
			 $('#rechazar').focus();
		 }
	});
	
	$('#rechazar').change(function() {
		 if($('#autorizar').is(":checked")){
			 $('#autorizar').focus();
		 }else{
			 $('#rechazar').focus();
		 }
	});

	$('#adjuntar').click(function() {		
		if($('#clienteID').val() == null || $.trim($('#clienteID').val()) == ''){
			mensajeSis("Especifique un Cliente  ");
			$('#clienteID').focus();
		}else{			
				subirArchivos();			
		}
	});
	
	$('#comentario').blur(function(){
		$('#guardarAutorizaRechaza').focus();
	});
	
	$('#fechaDefuncion').change(function() { 
		if(!esTab){			
			$('#fechaDefuncion').focus();
		}
		if($('#fechaDefuncion').val().trim()!=""){
			if(esFechaValida($('#fechaDefuncion').val())){
				
			}else{
				$('#fechaDefuncion').focus();
				$('#fechaDefuncion').val("");
			}
		}
	}); 

	//-----------validacion de la Forma--------
	$('#formaGenerica').validate({
		rules:{
			clienteID:{
				required:true
			},
			actaDefuncion:{
				required:true
			},
			fechaDefuncion:{
				required:true,
				date: true
			}
		},
		messages:{
			clienteID:{
				required:'Ingrese un Número de Cliente'
			},
			actaDefuncion:{
				required:'Ingrese el Número de Acta de Defunción'
			},
			fechaDefuncion:{
				required:'Ingrese la fecha de Defunción',
				date :'Fecha incorrecta'
			}
		}
	});
	
	//------------ Validaciones de Controles -------------------------------------	
	function consultaClienteProteccion(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numClienteP = $(jqCliente).val();	
		inicializaFormaProteccion();  // inicializa todos los datos del Cliente
		var tipConPrincipal = 1;	
		
		setTimeout("$('#cajaLista').hide();", 200);			
		var proteccionBeanP = {
				'clienteID': numClienteP								
			};
		if(numClienteP != '' && !isNaN(numClienteP)){						
			protectAhoCredServicio.consulta(tipConPrincipal,proteccionBeanP,function(proteccion) {
				if(proteccion!=null){	
					numCliente = $('#clienteID').val();
					$('#fechaRegistro').val(proteccion.fechaRegistro);						 
					$('#usuarioReg').val(proteccion.usuarioReg);					
					$('#comentario').val(proteccion.comentario);					
					$('#monAplicaCredito').val(proteccion.monAplicaCredito);
					$('#monAplicaCuenta').val(proteccion.monAplicaCuenta);
					$('#actaDefuncion').val(proteccion.actaDefuncion);	
					$('#fechaDefuncion').val(proteccion.fechaDefuncion);	
					
					 
					consultaArchivosCliente(proteccion.monAplicaCredito);
					montoAplicaCredito = proteccion.monAplicaCredito;
					Var_EstatusProteccion = proteccion.estatus ;


					$('#estatus').val(proteccion.estatus).selected = true;
					if(proteccion.estatus == EstatusPagado){
						deshabilitaBoton('guardarAutorizaRechaza', 'submit');
						deshabilitaBoton('adjuntar', 'submit');							 
						Var_DeshabilitaBotonesGrid ='S';	
						$('#autorizar').attr('checked',true);
						$('#rechazar').attr('checked',false);
						mensajeSis("La Solicitud al Programa Protección se Encuentra Pagada.");

						$('#gridCredCte').hide();
						$('#gridAhoCte').hide();
					}else if(proteccion.estatus == EstatusAutorizado){			 
						 $('#autorizar').attr('checked',true);
						 $('#rechazar').attr('checked',false);
						 deshabilitaBoton('guardarAutorizaRechaza', 'submit');
						 deshabilitaBoton('adjuntar', 'submit');							 
						 Var_DeshabilitaBotonesGrid ='S';	
						 mensajeSis("La Solicitud al Programa de Protección se Encuentra Autorizada.");

						 $('#gridCredCte').hide();
						 $('#gridAhoCte').hide();
						 if(perfilUsuario == Var_PerfilAutoriProtec ){
							proteccionConsultaAhoCte(numClienteP);
							proteccionConsultaCreditoCte(numClienteP);
						 }
					 }else if(proteccion.estatus == Var_EstatusRechazado){
						 $('#autorizar').attr('checked',false);
						 $('#rechazar').attr('checked',true);
						 deshabilitaBoton('guardarAutorizaRechaza', 'submit');
						 deshabilitaBoton('adjuntar', 'submit');							 
						 Var_DeshabilitaBotonesGrid ='S';	
						 mensajeSis("La Solicitud al Programa de Protección se encuentra Rechazada");

						 $('#gridCredCte').hide();
						 $('#gridAhoCte').hide();
					 }else{
						 $('#autorizar').attr('checked',true);
						 $('#rechazar').attr('checked',false);
						 habilitaBoton('adjuntar', 'submit');					 
						 Var_DeshabilitaBotonesGrid ='N';	

						 if(perfilUsuario == Var_PerfilAutoriProtec ){
							 $('#divAutoriza').show();
							 habilitaBoton('guardarAutorizaRechaza', 'submit');
							 $('#gridCredCte').show();
							 $('#gridAhoCte').show();		
							consultaAhoCte(numClienteP);
							consultaCreditoCte(numClienteP);
						 }
					 }

					$('#divArchivosCli').show();
					 consultaUsuario('usuarioReg', 'nombreUsuarioReg');
					 deshabilitaBoton('agrega', 'submit');
					 $('#trProteccion').show();
					 $('#estatusProteccion').show();								
				}else{
					$('#usuarioReg').val(parametroBean.numeroUsuario);
					$('#divAutoriza').hide();
					$('#trProteccion').hide();
					$('#estatusProteccion').hide();
					habilitaBoton('agrega', 'submit');
					deshabilitaBoton('adjuntar', 'submit');
					deshabilitaBoton('guardarAutorizaRechaza', 'submit');
					$('#gridCredCte').hide();
					$('#gridAhoCte').hide();
					$('#divArchivosCli').hide();
					
				}
			});
			consultaCliente('clienteID');
			
		}
	}
	

	function consultaParametrosProteccion() {			
		setTimeout("$('#cajaLista').hide();", 200);		
			var empresaBean = {
					'empresaID':1 
			};									
			parametrosCajaServicio.consulta(1,empresaBean,function(parametrosYanga) {
			if(parametrosYanga != null){				
				$('#montoMaximoProtec').val(parametrosYanga.montoMaxProtec);
				Var_PerfilAutoriProtec = parametrosYanga.perfilAutoriProtec;
				
				montoMaximoProteccion =	$('#montoMaximoProtec').asNumber();
			}else{
				montoMaximoProteccion = parseFloat(0);		
			}
			});
			
	}	
	
	function consultaUsuario(control,nombreUsuario) {	
		var jqUsuario = eval("'#" + control + "'");
		var jqNombreUsuario = eval("'#" + nombreUsuario + "'");
		
		var numUsuario = $(jqUsuario).val();			
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numUsuario != '' && !isNaN(numUsuario)){		
			var usuarioBeanCon = {
					'usuarioID':numUsuario 
			};									
			usuarioServicio.consulta(2,usuarioBeanCon,function(usuario) {
			if(usuario!=null){											
				$(jqNombreUsuario).val(usuario.nombreCompleto);					

			}else{
				$(jqUsuario).focus();
				$(jqUsuario).val("");
				$(jqNombreUsuario).val("");
			}
			});
		}	
	}	

	
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConPrincipal = 1;	
		
		var tipoConParamCaja = 1;
		var numEmpresa = 1;
		var ParametrosCajaBean = {
				'empresaID'	: numEmpresa
		};
		setTimeout("$('#cajaLista').hide();", 200);			
	
		if(numCliente != '' && !isNaN(numCliente) ){
			clienteServicio.consulta(tipConPrincipal,numCliente,function(cliente) {
				if(cliente!=null){					
					$('#nombreCliente').val(cliente.nombreCompleto);					
					$('#fechaIngreso').val(cliente.fechaAlta);
					$('#promotorID').val(cliente.promotorActual);					
					$('#fechaNacimiento').val(cliente.fechaNacimiento);
					$('#sucursalOrigen').val(cliente.sucursalOrigen);
							
					if(cliente.tipoPersona == 'F'){
						$('#tipoPersona').val('FÍSICA');
					}else{
						if(cliente.tipoPersona == 'A'){
							$('#tipoPersona').val('FÍSICA ACT. EMP.');
						}else{
							$('#tipoPersona').val('MORAL');
						}
					}
					 
					consultaPromotorActual('promotorID');					
					consultaSucursal('sucursalOrigen');
						
							$('#edad').val(cliente.edad);
							
							/* Si el cliente es menor edad, verifica que su edad este dentro del rango de edades parametrizado  */							
							if(cliente.esMenorEdad == 'S'){
								parametrosCajaServicio.consulta(tipoConParamCaja,ParametrosCajaBean,function(parametros) {
									if (parametros != null) {									
										if(parseInt(cliente.edad) < parseInt(parametros.edadMinimaCliMen) || parseInt(cliente.edad) > parseInt(parametros.edadMaximaCliMen)){
											mensajeSis("La Edad del " + $("#tipoCliente").val() + " No está Dentro del Rango de Edades Parametrizado.");
										}
									}
								});
							}
					
				}else{
					mensajeSis("No Existe el Cliente");				
					$('#clienteID').focus();
					$('#clienteID').select();		
					$('#nombreCliente').val("");					
					$('#fechaIngreso').val("");
					$('#promotorID').val("");					
					$('#fechaNacimiento').val("");
					$('#sucursalOrigen').val("");
					$('#tipoPersona').val("");
					$('#nombrePromotorID').val("");
					$('#nombreSucursal').val("");
					$('#edad').val("");
				}
			});
		}
	}
	
	function consultaPromotorActual(idControl) {
		var jqPromotor = eval("'#" + idControl + "'");
		var numPromotor = $(jqPromotor).val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numPromotor != '' && !isNaN(numPromotor)){
			var promotor = {
				'promotorID': numPromotor								
			};
			promotoresServicio.consulta(2,promotor,function(promotor) {
				if(promotor!=null){	
					$('#nombrePromotor').val(promotor.nombrePromotor);
				}else{
					mensajeSis("No Existe el Promotor");
				}
			});
		}
	}
		
	
	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();
		var conSucursal=2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numSucursal != '' && !isNaN(numSucursal) ){
			sucursalesServicio.consultaSucursal(conSucursal,numSucursal,function(sucursal) {
				if(sucursal!=null){	
					$('#nombreSucursal').val(sucursal.nombreSucurs);
				}else{
					mensajeSis("No Existe la Sucursal");
				}
			});
		}
	}
//::::::::::::::::::::::::::::::::::::::PROTECCION CUENTAS :::::::::::::::::::::::::::::::::
	function proteccionConsultaAhoCte(numCliente){
		var params = {};
		params['tipoLista'] = 1;
		params['clienteID'] = numCliente;
		if (numCliente != '' && !isNaN(numCliente)){
			$.post("proteccionAhorroGridVista.htm", params, function(data){
				agregaFormatoMoneda('formaGenerica');
				if(data.length >0) {					
					$('#gridAhoCte').html(data);
					$('#gridAhoCte').show(); 
					sumaProteccion();
					
					
				}else{
					$('#gridAhoCte').html("");
					$('#gridAhoCte').show();
				}
			});
		}
	}
	
	function consultaAhoCte(numCliente){
		var params = {};
		params['tipoLista'] = 2;
		params['clienteID'] = numCliente;
		if (numCliente != '' && !isNaN(numCliente)){
			$.post("CliAhorroGridVista.htm", params, function(data){						
				if(data.length >0) {	
					agregaFormatoMoneda('gridArchivosCliente');
					$('#gridAhoCte').html(data);
					$('#gridAhoCte').show(); 
					agregaFormatoMoneda('formaGenerica');
					sumaSaldoCta();
					
				}else{
					$('#gridAhoCte').html("");
					$('#gridAhoCte').show();
				}
			});
		}
	}
	
	function sumaProteccion(){
		var suma=0.00;
		var sumaSaldoCta =0.00;
		
		$('tr[name=renglons]').each(function() {
			var numero= this.id.substr(8,this.id.length);
			var idCampo = eval("'saldoProteccion" + numero+ "'");	
			var idCampoSaldo = eval("'saldoCta" + numero+ "'");	
			suma = suma+$('#'+idCampo).asNumber();
			sumaSaldoCta = sumaSaldoCta + $('#'+idCampoSaldo).asNumber();
			if(Var_EstatusProteccion ==  EstatusAutorizado|| Var_EstatusProteccion == EstatusPagado){
				soloLecturaControl(idCampo);
				$('#'+idCampo).attr('disabled',true);
			}
			
		});
		
		$('#monAplicaCuenta').val(suma);
		$('#totalCuentas').val(sumaSaldoCta);
		$('#totalCuentas').formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});
		$('#monAplicaCuenta').formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});			
		
	}
	
	function sumaSaldoCta(){		
		var sumaSaldoCta =0.00;
		
		$('tr[name=renglons]').each(function() {
			var numero= this.id.substr(8,this.id.length);
			var idCampo = eval("'saldoProteccion" + numero+ "'");	
			var idCampoSaldo = eval("'saldoCta" + numero+ "'");	
			$('#'+idCampo).val('0.00');
			$('#monAplicaCuenta').val('0.00');
			sumaSaldoCta = sumaSaldoCta + $('#'+idCampoSaldo).asNumber();	
			
		});				
		$('#totalCuentas').val(sumaSaldoCta);
		$('#totalCuentas').formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		});
					
		
	}
	
	
	function guardarGridCuentas(){			 		     	    
		var i =0;
		$('#listaCuentas').val("");			
			$('tr[name=renglons]').each(function() {
				i ++;
			//	if($('#saldoProteccion'+i).asNumber() >0){
					if(i == 1){
						$('#listaCuentas').val($('#listaCuentas').val() +
						document.getElementById("cuentaAhorro"+i+"").value + ']'+
						document.getElementById("saldoProteccion"+i+"").value);							
					}else{
						$('#listaCuentas').val($('#listaCuentas').val() + '[' +
						document.getElementById("cuentaAhorro"+i+"").value + ']'+
						document.getElementById("saldoProteccion"+i+"").value);
					}
				//}
			});//For	
	}

	//::::::::::::::::::::::::::::PROTECCION CREDITO :::::::::::::::::::::::::::::::::::::::::	
	function proteccionConsultaCreditoCte(clienteID){
		var params = {};			
		params['tipoLista'] = 2; 
		params['clienteID'] = clienteID;
		if (clienteID != '' && !isNaN(clienteID)){
				$.post("proteccionCreditoGridVista.htm", params, function(dat){	
				if(dat.length >0) {
					$('#gridCredCte').html(dat);
					$('#gridCredCte').show();					
					$('#monAplicaCredito').val(montoAplicaCredito);					
					
					estatusCredito();
					seleccionaDeshabilitaCheck();
				}else{
					$('#gridCredCte').html("");
					$('#gridCredCte').show();
				}
			});
		}		
	}
	
	function consultaCreditoCte(clienteID){
		var params = {};			
		params['tipoLista'] = 17; 
		params['clienteID'] = clienteID;
		if (clienteID != '' && !isNaN(clienteID)){
			$.post("CreditosClienteGridControlador.htm", params, function(dat){						
				if(dat.length >0) {
					$('#gridCredCte').html(dat);
					$('#gridCredCte').show();
					estatusCredito();
					
				}else{
					$('#gridCredCte').html("");
					$('#gridCredCte').show();
				}
			});
		}		
	}

	function guardarGridCreditos(){			 		     	    
		var i =0;
		$('#listaCreditos').val("");			
			$('tr[name=renglon]').each(function() {
				i ++;
			if($('#proteccion'+i).attr('checked')==true ){
				if(i == 1){					
					$('#listaCreditos').val($('#listaCreditos').val() +
					document.getElementById("numeroCredito"+i+"").value + ']'+
					document.getElementById("diferencia"+i+"").value);							
				}else{
					$('#listaCreditos').val($('#listaCreditos').val() + '[' +
					document.getElementById("numeroCredito"+i+"").value + ']'+
					document.getElementById("diferencia"+i+"").value);						
				
				}	
			}
					
					
		});//For	
	}

	function estatusCredito() {		
		var estatusInactivo 	="I";		
		var estatusAutorizado 	="A";
		var estatusVigente		="V";
		var estatusPagado		="P";
		var estatusCancelada 	="C";		
		var estatusVencido		="B";
		var estatusCastigado 	="K";		
		
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var idCampo = eval("'estatus" + numero+ "'");	
			var var_estatus= $('#'+idCampo).val();	
						
			if(var_estatus == estatusInactivo){
				$('#'+idCampo).val('INACTIVO');			
			}	
			if(var_estatus == estatusAutorizado){
				$('#'+idCampo).val('AUTORIZADO');
			}
			if(var_estatus == estatusVigente){
				$('#'+idCampo).val('VIGENTE');
			}
			if(var_estatus == estatusPagado){
				$('#'+idCampo).val('PAGADO');			
			}
			if(var_estatus == estatusCancelada){
				$('#'+idCampo).val('CANCELADO');		
			}
			if(var_estatus == estatusVencido){
				$('#'+idCampo).val('VENCIDO');			
			}
			if(var_estatus == estatusCastigado){
				$('#'+idCampo).val('CASTIGADO');		
			}
		});
	}
	
	function seleccionaDeshabilitaCheck(){
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var idCampo = eval("'proteccion" + numero+ "'");
			var idDiferencia = eval("'diferencia" + numero+ "'");
			var valorDiferencia = $('#'+idDiferencia).asNumber();
			
			if (valorDiferencia > 0){
				$('#'+idCampo).attr('checked',true);
				
				if(Var_EstatusProteccion== EstatusAutorizado|| Var_EstatusProteccion == EstatusPagado){
					$("#monAplicaCredito").val($("#monAplicaCredito").asNumber() + valorDiferencia);
					$("#monAplicaCredito").formatCurrency({
						positiveFormat: '%n', 
						roundToDecimalPlace: 2	
					});	
					deshabilitaControl(idCampo);
				}
				
			}
			
		});
	}

	// ::::::::::::::::::::::::::ARCHIVOS ::::::::::::::::
	function subirArchivos() {
		//var url ="clientesFileUploadVista.htm?Cte="+$('#clienteID').val()+"&td="+$('#tipoDocumento').val()+"&pro="+$('#prospectoID').val();
		
		var url ="clientesArchivosUploadVista.htm?Cte="+$('#clienteID').val()+"&td="+$('#tipoDocumento').val()+"&pro="+$('#prospectoID').val();		
		var	leftPosition = (screen.width) ? (screen.width-850)/2 : 0;
		var	topPosition = (screen.height) ? (screen.height-500)/2 : 0;
		ventanaArchivosCliente = window.open(url,"PopUpSubirArchivo","width=980,height=340,scrollbars=yes,status=yes,location=no,addressbar=0,menubar=0,toolbar=0"+
										"left="+leftPosition+
										",top="+topPosition+
										",screenX="+leftPosition+
										",screenY="+topPosition);	
	}
	
	function confirmarAutorizar(){
		var numeroCtasXSeleccionar	=0;
		var numeroCredXSeleccionar  =consultaCreditosFaltaBeneficio();	 //Consultamos el Número de Creditos que todavia pueden entrar dentro de la proteccion
		var montoAplicadoCreditos	=$('#monAplicaCredito').asNumber();	// Total Aplicado a Creditos
		
		$('tr[name=renglons]').each(function() {  //Grid de Ctas
			var numero= this.id.substr(8,this.id.length);
			var idCampo = eval("'saldoProteccion" + numero+ "'");
			var jqMonAplicaCuenta =eval("'jqMonAplicaCuenta" + numero+ "'");
			var jqSaldoCta =eval("'saldoCta" + numero+ "'");
			
			var valorSaldoProtec = $('#'+idCampo).asNumber();			
			var valorMontoAplicaCta	=  $('#'+jqMonAplicaCuenta).asNumber();			
			var valorSaldoCta	= $('#'+jqSaldoCta).asNumber();
			
			if (valorMontoAplicaCta < montoMaximoProteccion ){
				 if(valorSaldoProtec <= 0 && valorSaldoCta >0){
					 numeroCtasXSeleccionar ++;
				 }
			}
						
		});

		if (numeroCredXSeleccionar >0){
			confirmar = confirm("¿Esta Seguro que desea Autorizar la protección?. " +
									"Aún Existen Créditos que pueden entrar dentro de la protección"); 
		}else{
			if(numeroCtasXSeleccionar > 0 && montoAplicadoCreditos < montoMaximoProteccion){		
				confirmar = confirm("¿Esta Seguro que desea Autorizar la protección?. " +
								"Aún Existen Cuentas que pueden entrar dentro de la protección");
			}else{
				confirmar = true;
			}				
		}	

		guardarGridCreditos();
		guardarGridCuentas();
	}
	

	/* funcion para validar que el cliente tenga una solicitud de cancelacion de socio por 
	 * protecciones,*/
	function consultaSolicitudCancelaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var varClienteID = $(jqCliente).val();	
		var tipConCliente = 3;
		setTimeout("$('#cajaLista').hide();", 200);
		if (varClienteID != '' && !isNaN(varClienteID)) { // si es numero y no esta vacio el campo
			var clienteCancelaBean = {
				'clienteID'	:varClienteID.trim()
			};
			clientesCancelaServicio.consulta(tipConCliente,clienteCancelaBean,function(cliente) {
				if(cliente!=null){
					if(cliente.aplicaSeguro != "S"){
						mensajeSis("La  Solicitud de Cancelación del Socio No Permite Seguro.");	
						$('#clienteID').focus();
						$('#clienteID').select();		
						$('#nombreCliente').val("");					
						$('#fechaIngreso').val("");
						$('#promotorID').val("");					
						$('#fechaNacimiento').val("");
						$('#sucursalOrigen').val("");
						$('#tipoPersona').val("");
						$('#nombrePromotorID').val("");
						$('#nombreSucursal').val("");
						$('#usuarioReg').val(parametroBean.numeroUsuario);
						$('#divAutoriza').hide();
						$('#trProteccion').hide();
						$('#estatusProteccion').hide();
						$('#actaDefuncion').val("");
						$('#fechaDefuncion').val("");
						$('#nombrePromotor').val("");
						$('#edad').val("");
						
						deshabilitaBoton('agrega', 'submit');
						deshabilitaBoton('adjuntar', 'submit');
						deshabilitaBoton('guardarAutorizaRechaza', 'submit');
						$('#gridCredCte').hide();
						$('#gridAhoCte').hide();
						$('#divArchivosCli').hide();
					}else{
						$('#actaDefuncion').val(cliente.actaDefuncion);
						$('#fechaDefuncion').val(cliente.fechaDefuncion);
						consultaClienteProteccion(idControl);
					}
				}else{
					var numCliente = varClienteID;
					if(numCliente != '' && !isNaN(numCliente) ){
						clienteServicio.consulta(1,numCliente,function(cliente) {
							if(cliente!=null){	
								mensajeSis("El Socio No Tiene una Solicitud de Cancelación por Protecciones.");	
							}else{
								mensajeSis("No Existe el Socio.");				
							}
						});
					}
						
					$('#clienteID').focus();
					$('#clienteID').select();		
					$('#nombreCliente').val("");					
					$('#fechaIngreso').val("");
					$('#promotorID').val("");					
					$('#fechaNacimiento').val("");
					$('#sucursalOrigen').val("");
					$('#tipoPersona').val("");
					$('#nombrePromotorID').val("");
					$('#nombreSucursal').val("");
					$('#usuarioReg').val(parametroBean.numeroUsuario);
					$('#divAutoriza').hide();
					$('#trProteccion').hide();
					$('#estatusProteccion').hide();
					$('#actaDefuncion').val("");
					$('#fechaDefuncion').val("");
					$('#nombrePromotor').val("");
					$('#edad').val("");
					
					deshabilitaBoton('agrega', 'submit');
					deshabilitaBoton('adjuntar', 'submit');
					deshabilitaBoton('guardarAutorizaRechaza', 'submit');
					$('#gridCredCte').hide();
					$('#gridAhoCte').hide();
					$('#divArchivosCli').hide();
					
				}
			});		
		}	
	}
});




//funcion para validar la fecha
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
			case 1: case 3:  case 5: case 7: case 8: case 10: case 12:	
				numDias=31;
			break;
		case 4: case 6: case 9: case 11:
			numDias=30;
			break;
		case 2:
			if (comprobarSiBisisesto(anio)){ numDias=29; }else{ numDias=28;};
			break;
		default:
			mensajeSis("Fecha introducida errónea");
		return false;
		}
		if (dia>numDias || dia==0){
			mensajeSis("Fecha introducida errónea");
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
//---FIN


// ::::::::::::::::::::::: GRIDS :::::::::::::::::::::::::
function calculaProteccionCredito(idControl){
	var sumaSaldoProtec= 0.00;
	var sumaCuenta		=0.00;
	var montoTotalAplicaCredito = $('#monAplicaCredito').asNumber(); // Suma Total de Beneficios de Creditos
	var sumaTotal				=0.00; //Suma Total de Beneficio de creditos y Beneficios a cuentas
	var creditosPendientesBen	=consultaCreditosFaltaBeneficio();
	if( $('#'+idControl).asNumber() <= 0 ){
		 $('#'+idControl).val('0.00');		
	}
	$('#'+idControl).formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});	
	
	$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqSaldoCuenta = eval("'totalAdeudo" + numero+ "'");						
		var valorSaldoCta= $('#'+jqSaldoCuenta).asNumber();
		sumaCuenta		=sumaCuenta +valorSaldoCta;				
		var jqSaldoProteccion = eval("'#diferencia" + numero+"'");
		var valorSaldoProtecCta =  $(jqSaldoProteccion).asNumber();
		
		if(valorSaldoProtecCta > valorSaldoCta){
			mensajeSis("El monto de la Protección excede el Adeudo del Crédito ");
			 $('#'+idControl).val('0.00');
			 $('#'+idControl).focus();	
			 $('#'+idControl).select();	 			 
		}
		sumaSaldoProtec	= sumaSaldoProtec + $(jqSaldoProteccion).asNumber();
		
	});		
	 
	sumaTotal= montoTotalAplicaCredito + sumaSaldoProtec;
	
	if(montoTotalAplicaCredito > montoMaximoProteccion &&  $('#'+idControl).asNumber()>0){
		mensajeSis("El Pago de las Cuentas ya cubre el Monto Máximo de la Protección");
		$('#'+idControl).val('');
		$('#'+idControl).focus();	
		
	}else if(sumaTotal > montoMaximoProteccion){
		var numero= this.id.substr(10,this.id.length);
		mensajeSis("La Suma de la Protección a Cuentas mas el Beneficio que desea aplicar a este Crédito Excede el Monto Máximo de la Protección ");
		$('#'+idControl).val('');
		$('#'+idControl).focus();
		$('#proteccion'+numero).attr('checked',false);
	}else if(sumaSaldoProtec > montoMaximoProteccion){
		mensajeSis("La Suma  de la Protección que desea aplicar a esté Crédito excede el Monto Máximo de la Protección ");
		 $('#'+idControl).val('');
		 $('#'+idControl).focus();
	}else{	
		$('#monAplicaCredito').val(sumaSaldoProtec);
	}
	
	
	$('#monAplicaCredito').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});
	agregaFormatoMonedaGrid();
}


function calculaProteccionCuenta(idControl){
	var pasarfoco = true;
	var sumaSaldoProtec= 0.00;
	var sumaCuenta		=0.00;
	var montoTotalAplicaCredito = $('#monAplicaCuenta').asNumber(); // Suma Total de Beneficios de Creditos
	var sumaTotal				=0.00; //Suma Total de Beneficio de creditos y Beneficios a cuentas
	var creditosPendientesBen	=consultaCreditosFaltaBeneficio();
	if( $('#'+idControl).asNumber() <= 0 ){
		 $('#'+idControl).val('0.00');		
	}
	var jqProteccionCred ="";
	$('#'+idControl).formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});	
	
	$('tr[name=renglons]').each(function() {
		var numero= this.id.substr(8,this.id.length);
		var jqSaldoCuenta = eval("'saldoCta" + numero+ "'");						
		var valorSaldoCta= $('#'+jqSaldoCuenta).asNumber();
		sumaCuenta		=sumaCuenta +valorSaldoCta;				
		var jqSaldoProteccion = eval("'saldoProteccion" + numero+ "'");
		var valorSaldoProtecCta =  $('#'+jqSaldoProteccion).asNumber();
		
		var numero=  $('tr[name=renglons]').length;
		var numeroFila= idControl.substr(15,idControl.length);
		
		
		if(valorSaldoProtecCta > valorSaldoCta){
			 jqProteccionCred = eval("'#saldoProteccion" + numero+ "'");		
			 $(jqProteccionCred).val('0.00');
			 $(jqProteccionCred).focus();
			 $(jqProteccionCred).select();		
			mensajeSis("El monto de la Protección excede el Saldo de la Cuenta.");
		}
		sumaSaldoProtec	= sumaSaldoProtec + $('#'+jqSaldoProteccion).asNumber();
		
	});		
	 
	sumaTotal= montoTotalAplicaCredito + sumaSaldoProtec;
	
	if(montoTotalAplicaCredito >= montoMaximoProteccion &&  $('#'+idControl).asNumber()>0){
		mensajeSis("El Pago de los Créditos ya cubre el Monto Máximo de la Protección");
		$('#'+idControl).val('');
		$('#'+idControl).focus();
	}else if(sumaTotal > montoMaximoProteccion){
		mensajeSis("La Suma de la Protección a Créditos mas el Beneficio que desea aplicar a esta Cuenta Excede el Monto Máximo de la Protección ");
		$('#'+idControl).val('');
		$('#'+idControl).focus();
	}else if(sumaSaldoProtec > montoMaximoProteccion){
		mensajeSis("La Suma  de la Protección que desea aplicar a esta Cuenta excede el Monto Máximo de la Protección ");
		 $('#'+idControl).val('');
		 $('#'+idControl).focus();
	}else{	
		$('#monAplicaCuenta').val(sumaSaldoProtec);
	}
	
	
	$('#totalCuentas').val(sumaCuenta);	
	$('#totalCuentas').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});
	
	$('#monAplicaCuenta').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});		
}


//Consulta cuantos Creditos todavia pueden entrar dentro del programa de Proteccion.
function consultaCreditosFaltaBeneficio(){
	var TotalCredSinBeneficio	=0;
	var monAplicaCredito		=$('#monAplicaCredito').asNumber(); // Monto Total de Beneficio Aplicado a Creditos
	$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqProteccionCred = eval("'diferencia" + numero+ "'");						
		var valorProteccionCred= $('#'+jqProteccionCred).asNumber();
		
		if(valorProteccionCred <=  0  && monAplicaCredito < montoMaximoProteccion ){
			TotalCredSinBeneficio ++;			 
		}				
	});	
	return  TotalCredSinBeneficio;
}
//
function sumaProteccionCredito(idControl){	
	var numero= idControl.substr(10,idControl.length);
	var valorAdeudoCred = $('#totalAdeudo'+numero).asNumber();// Valor del Adeudo real del Crédito
	var sumaAdeudo	=$('#monAplicaCredito').asNumber();       // monto  monAplicaCredito
	var sumaAdeudoActual=$('#monAplicaCredito').asNumber();	
	var ValorAdeudoCredCalculado = $('#totalAdeudo'+numero).asNumber();  // Para la diferencia		
	var diferencia = $('#diferencia'+ numero).asNumber();				// solo si el crédito tiene una diferencia
	var idCheck = eval("'#diferencia"+ numero+"'");
	$(idCheck).focus();
	$(idCheck).select();
	if($('#'+idControl).attr('checked') == true){
		if(sumaAdeudo > montoMaximoProteccion  ){
			diferencia = sumaAdeudo - montoMaximoProteccion;			
			ValorAdeudoCredCalculado = ValorAdeudoCredCalculado - diferencia;
			
			mensajeSis("La Suma  de la Protección excede el Monto Máximo de la Protección" );			
			 if(diferencia > 0 ){
				 if(sumaAdeudoActual < montoMaximoProteccion){
					 $('#diferencia'+ numero).val(ValorAdeudoCredCalculado);
					 $('#'+idControl).attr('checked',true);
					 sumaAdeudo = sumaAdeudo - diferencia;
				 }else{
					 $('#'+idControl).attr('checked',false);
					 sumaAdeudo = sumaAdeudo - valorAdeudoCred;						
				 }
				
			 }else{					 
				 $('#'+idControl).attr('checked',false);					
			 }
 
		}else{
			 $('#diferencia'+ numero).val(valorAdeudoCred);
		}	
	}else{
		if(diferencia > 0){				
			sumaAdeudo = sumaAdeudo - diferencia;
			$('#diferencia'+numero).val('0.00');
		}else{
			sumaAdeudo = sumaAdeudo - valorAdeudoCred;
		}				
	}
	$('#monAplicaCredito').val(sumaAdeudo);				
	$('#monAplicaCredito').formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});				
	$('#diferencia'+numero).formatCurrency({
		positiveFormat: '%n', 
		roundToDecimalPlace: 2	
	});	
}


//::::::::::::::::::::  ARCHIVOS CLIENTE ::::::::::::::::::::::::::::::::::.
function consultaArchivosCliente(){		
		var params = {};
		params['tipoLista'] = 1;
		params['clienteID'] = $('#clienteID').val();
		params['prospectoID'] = $('#prospectoID').val();
		params['tipoDocumento'] = $('#tipoDocumento').val();
		$.post("documentosClienteGridGeneral.htm", params, function(data){		
				if(data.length >0) {
					$('#fielSetArchivosCliente').show();
					$('#gridArchivosCliente').html(data);
					$('#gridArchivosCliente').show();
					
					if(Var_DeshabilitaBotonesGrid == 'S'){						
						deshabilitabotonesArchivosCte();
					}else{
						habilitabotonesArchivosCte();
					}
					
				}else{
					$('#fielSetArchivosCliente').hide();
					$('#gridArchivosCliente').html("");
					$('#gridArchivosCliente').show();
				}
		});	
}
function verArchivosCliente(id, idTipoDoc, idarchivo,recurso) {
	var varClienteVerArchivo = $('#clienteID').val();
	var varTipoDocVerArchivo = idTipoDoc;
	var varTipoConVerArchivo = 10;
	var parametros = "?clienteID="+varClienteVerArchivo+"&prospectoID="+$('#prospectoID').val()+"&tipoDocumento="+
		varTipoDocVerArchivo+"&tipoConsulta="+varTipoConVerArchivo+"&recurso="+recurso;

	var pagina="clientesVerArchivos.htm"+parametros;
	var idrecurso = eval("'#recursoCteInput"+ id+"'");
	var extensionArchivo=  $(idrecurso).val().substring( $(idrecurso).val().lastIndexOf('.'));
	extensionArchivo = extensionArchivo.toLowerCase();
	if(extensionArchivo==".jpg" || extensionArchivo == ".png" || extensionArchivo == ".jpeg" || extensionArchivo == ".gif"){
		$('#imgCliente').attr("src",pagina); 		
		$('#imagenCte').html(); 
		  $.blockUI({message: $('#imagenCte'),
			   css: { 
           top:  ($(window).height() - 400) /2 + 'px', 
           left: ($(window).width() - 400) /2 + 'px', 
           width: '400px' 
       } });  
		  $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
	}else{
		window.open(pagina,'_blank');
		$('#imagenCte').hide();

	}	
}
//funcion para eliminar el documento digitalizado
function  eliminaArchivo(folioDocumento){
	if($('#estatus').val() =='R' ){
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
				mensajeSis("Existio un Error al Borrar el Documento");			
			}
		});
	}else{
		mensajeSis("Solo se pueden eliminar archivos de una solicitud con estatus Registrado.");
	}
}


//funcion para validar cuando un campo  toma el foco
function validaFocoInputMoneda(controlID){
	jqID = eval("'#" + controlID + "'");
	if($(jqID).asNumber()>0){
		$(jqID).select();
	}else{
		$(jqID).val("");
	}
}

function deshabilitabotonesArchivosCte(){	
	$('tr[name=trArchivosCte]').each(function() {
		var numero= this.id.substr(13,this.id.length);
		var idCampo = eval("'elimina" + numero+ "'");				
		deshabilitaBoton(idCampo, 'button');
	});
}



// :::::::::::::::::::::::::: TRANSACCION ::::::::::::::::::
function ExitoProteccion(){
	agregaFormatoControles('formaGenerica');
	inicializaFormaProteccion();	
	$('#actaDefuncion').val('');
	$('#fechaDefuncion').val('');
}


function inicializaFormaProteccion(){
	 $('#tipoTransaccion').val('');
	 $('#listaCuentas').val('');
	 $('#listaCreditos').val('');	
	 $('#usuarioReg').val('');			
	 $('#montoAplicaCredito').val('');
	 $('#monAplicaCuenta').val('');
	 $('#totalCuentas').val('');
	 $('#comentario').val('');
	 $('#gridArchivosCliente').html("");
	$('#gridArchivosCliente').hide();
	
	$('#gridCredCte').html("");
	$('#gridCredCte').hide();
	
	$('#gridAhoCte').html("");
	$('#gridAhoCte').hide();
	
	//inicializaForma('formaGenerica','clienteID');
}

function ErrorProteccion(){
	$('#listaCuentas').val('');
	$('#listaCreditos').val('');
	agregaFormatoControles('formaGenerica');	
}

// terminar esto
function deshabilitabotonesArchivosCte(){	
	$('tr[name=trArchivosCte]').each(function() {
		var numero= this.id.substr(13,this.id.length);
		var idCampo = eval("'elimina"+numero+"'");	
		deshabilitaControl(idCampo);
	});
	deshabilitaBoton('adjuntar', 'submit');
}
function habilitabotonesArchivosCte(){
	$('tr[name=trArchivosCte]').each(function() {
		var numero= this.id.substr(13,this.id.length);
		var idCampo = eval("'elimina" + numero+ "'");	
		habilitaControl(idCampo);
	});
	 habilitaBoton('adjuntar', 'submit');
}



/* funcion para validar los datos requeridos al autorizar o rechazar 
 * la solicitud del seguro de proteccion al ahorro y credito */
function validaAutorizaRechazo(){
	var procede = true;
	if( $('#tipoTransaccion').val()!=catTipoTranPRoteccionCtaAhorro.alta){
		
				if($('#comentario').val().trim() == "" && $('#rechazar').is(":checked")){
					mensajeSis("Especificar Comentario.");
					$('#comentario').focus();
					procede = false;
				}
	}
	return procede; 
}

/* funcion para calcular la diferencia del monto con lo que se va poniendo en  
 * el grid de pagos libres.*/ 
function agregaFormatoMonedaGrid(){
	var numero = 0;
	var varCapitalID = "";
	$('input[name=diferencia]').each(function() {		
		numero= this.id.substr(10,this.id.length);
		numDetalle = $('input[name=capital]').length;
		varCapitalID = eval("'#diferencia"+numero+"'");
		$(varCapitalID).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	});
}
