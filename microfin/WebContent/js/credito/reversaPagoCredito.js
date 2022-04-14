var creditoRev = 0;
var fechaPagoCredito;
var numeroCajaRealizoPago	=0;
var accedeHuella = 'N';
var huella_nombreCompleto,huella_usuarioID,huella_OrigenDatos, motivo, motivoID, bandera;

var serverHuella = new HuellaServer({

	fnHuellaValida:	function(datos){
							$('#contraseniaUsuarioAutoriza').val('HD>>'+datos.tokenHuella);
							grabaFormaTransaccionRetrollamada({}, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID', 'exitoTransaccionReversa','falloTransacionReversa'); 
							$('#statusSrvHuella').hide();
							accedeHuella = '';


					},
	fnHuellaInvalida: function(datos){
							return false;
					}
	});
var catFormTipoCalInt = { 
		'principal'	: 1,
};
var TasaFijaID 			= 1; // ID de la formula para tasa fija (FORMTIPOCALINT)
var TasaBasePisoTecho 	= 3; // ID de la formula para tasa base con piso y techo (FORMTIPOCALINT)
var VarTasaFijaoBase 	= 'Tasa Fija'; // Texto que indica si se trata de tasa fija o tasa base actual (alert)

$(document).ready(function(){
	//Definición de constantes y Enums
	esTab = true;
	var parametroBean = consultaParametrosSession();  

	var fechaSistema = parametroBean.fechaAplicacion;
	var catTipoConsultaCredito = { 
			'principal'	: 1,
			'foranea'	: 2,
			'pago'		: 7 
	};	

	var catTipoTranCredito = { 
			'pagoCredito'		: 12 ,
			'pagoCreditoGrupal': 18 ,
	};		
	
	var tipoOperacionPagoCredito =28; // Corresponde con CAJATIPOSOPERA (CAJASMOVS) pago de credito en ventanilla
	
	
	//-----------------------Métodos y manejo de eventos-----------------------

	deshabilitaBoton('aceptar', 'submit');

	$(':text').focus(function() {	
		esTab = false;
	});

	agregaFormatoControles('formaGenerica');

	// llena el combo para la Formula de Calculo de Interés 
	consultaComboCalInteres();
	muestraCamposTasa(0);

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});			

	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID', 'exitoTransaccionReversa','falloTransacionReversa'); 
		}
	});	

	$('#creditoID').focus();
	$('#creditoID').blur(function(){
		consultaCredito(this.id);		
	});		

	$('#creditoID').bind('keyup', function(e){
		lista('creditoID', '2', '1', 'nombreCliente', $('#creditoID').val(), 'respaldoPagoCreditoLista.htm');
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
		motivo ='REVERSA DE PAGO DE CREDITO';
		motivoID = 104;

		if(!$('#formaGenerica').valid()){
			return false;
		}

		if(accedeHuella == 'S' && $('#claveUsuarioAut').val() != ''){
			bandera = 'N';
			if($('#contraseniaUsuarioAutoriza').val() != ''){
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID', 'exitoTransaccionReversa','falloTransacionReversa');
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
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID', 'exitoTransaccionReversa','falloTransacionReversa');
					$('#statusSrvHuella').hide();
			}
			
		}
	});


	$('#motivo').blur(function(){
		var texto = $('#motivo').val();
		texto = texto.replace(/[\n\r\t\f\b]/g, " ");
		$('#motivo').val(texto.slice(0, 200));
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
				required: 'Especificar Motivo Reversa De Pago de Crédito',
				maxlength:'Máximo de Caracteres'
			},
			usuarioAutorizaID: {
				required: 'Especificar el Usuario'
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
	
//	-------------Validaciones de controles---------------------	
//	consulta credito
	function consultaCredito(controlID){
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) && esTab){
			var creditoBeanCon = { 
					'creditoID':$('#creditoID').val(),
					'fechaActual':$('#fechaSistema').val()
			};
			creditosServicio.consulta(18,creditoBeanCon,function(credito) {
				if(credito!=null){
					esTab=true;						
					dwr.util.setValues(credito);					
					creditoRev = credito.creditoID;					
					consultaCliente('clienteID');			
					consultaMoneda('monedaID');							
					//consultaLineaCredito('lineaCreditoID');	
					consultaCta('cuentaID');
					consultaProducCredito('producCreditoID');
					var estatus = credito.estatus;
					validaEstatusCredito(estatus);
					habilitaBoton('aceptar', 'submit');
					$('#grupoID').val(credito.grupoID);
					$('#tasafija').val(credito.tasaFija);
					muestraCamposTasa(credito.calcInteresID);
					ConsultaTransaccionReversar();					
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
		var estatusSuspendido	="S";

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
		if(var_estatus == estatusSuspendido){
			$('#estatus').val('SUSPENDIDO');
			habilitaBoton('pagar', 'submit');
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
					consultaTipoCta('nomCuenta','nomCuenta'); 
					consultaSaldoCta('cuentaID'); 
				}else{
					mensajeSis("No Existe la Cuenta de Ahorro");
				}
			});                                                                                                                        
		}  
	}

	function consultaTipoCta(idControl,desCta) {
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
					$('#'+desCta).val(tipoCuenta.descripcion);							
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


	function ConsultaTransaccionReversar(){
		var credito =$('#creditoID').val();
		var conPrincipal = 1;
		var resPagoCredBean = {
				'creditoID'		:credito
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(credito != '' && !isNaN(credito)){
			respaldoPagoCreditoServicio.consulta(conPrincipal,resPagoCredBean,function(transaccion){
				
				if(transaccion !=null){
					if(transaccion.tranRespaldo !=0){
				
						$('#tranRespaldo').val(transaccion.tranRespaldo);
						$('#montoPagado').val(transaccion.montoPagado);
						$('#monto').val( $('#montoPagado').asNumber());
						fechaPagoCredito = transaccion.fechaPago;
						habilitaBoton('aceptar', 'submit');
						ValidaFechaPagoCredito();
					}
					else{
						mensajeSis("No hay  Pago(s) Efectuado(s) el Día de Hoy Para el Crédito: "+credito);
						deshabilitaBoton('aceptar', 'submit');
						$('#tranRespaldo').val('');
						$('#montoPagado').val('');
						$('#creditoID').focus();
					}
					agregaFormatoMoneda('formaGenerica');
					consultaMovsCajaPagoCredito('tranRespaldo');
					
				}else{
					mensajeSis("No hay  Pago(s) Efectuado(s) el Día de Hoy Para el Crédito: "+credito);
					deshabilitaBoton('aceptar', 'submit');
					$('#tranRespaldo').val('');
					$('#montoPagado').val('');
					$('#creditoID').focus();
				}
			});
		}
	}

	function ValidaFechaPagoCredito(){
		if (fechaPagoCredito < fechaSistema){
			mensajeSis("No se Puede Realizar el Proceso de Reversa de Días Anteriores");
			deshabilitaBoton('aceptar', 'submit');
			$('#creditoID').focus();
		}else{
			habilitaBoton('aceptar', 'submit');
		}
	}
	
	function consultaMovsCajaPagoCredito(idControl){		
		var jqTransaccion  = eval("'#" + idControl + "'");
		var transaccion = $(jqTransaccion).val();	
		var consultaTransaccion= 2;
	
		var transaccioncajamovs = {
			'numeroMov'		:$('#tranRespaldo').val(),
			'fecha'			:fechaSistema,
			'tipoOperacion'	:tipoOperacionPagoCredito
		};  
		
		setTimeout("$('#cajaLista').hide();", 200);
		if(transaccion != '' && !isNaN(transaccion)){
			ingresosOperacionesServicio.consulta(consultaTransaccion, transaccioncajamovs,function(transaccionCaja) {
						if(transaccionCaja!=null){	
							$('#formaPago option[value=E]').attr('selected','true');
							consultaCtaGarantiaAdicional('ctaGarantiaAdicional');
							$('#monto').val( $('#montoPagado').asNumber());
							numeroCajaRealizoPago = transaccionCaja.cajaID;
							parametroBean = consultaParametrosSession();							
							agregaFormatoMoneda('formaGenerica');
						}else{
							$('#formaPago option[value=C]').attr('selected','true');	
							$('#lblGAdicional').hide();
							$('#tdGarantiaAdicional').hide();
							$('#tdGarantiaAdicional').val('');
							$('#tdSeparadorMontoTotal').hide();
						}
				});															
		}		
	}
	// funcion para consultar la cuenta de garantia liquida adicional del cliente
	function consultaCtaGarantiaAdicional(ctaGLAdiID) {
		var clienteID=$('#clienteID').asNumber();
		ctaGLAdiID = eval("'#"+ctaGLAdiID+"'");
		var tipConCtaGLAdi= 16;
		var CuentaAhoBeanCon = {
			'clienteID'	:clienteID
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(clienteID != '' && !isNaN(clienteID)){
			cuentasAhoServicio.consultaCuentasAho(tipConCtaGLAdi, CuentaAhoBeanCon,function(cuenta) {
				if(cuenta!=null){	
					$(ctaGLAdiID).val(cuenta.cuentaAhoID);
					consultaGarantiaAdicional();
				}else{
					mensajeSis("El cliente no tiene una cuenta para depositar la \nGarantía Líquida Adicional");
					
				}
			});															
		}
	}
	function consultaGarantiaAdicional(){		
		var transaccion = $('#tranRespaldo').val();	
		var tipoGarantiaAdicional=44;
		
		var consultaTransaccion= 3;
		var transaccioncajamovs = {
			'numeroMov'		:$('#tranRespaldo').val(),
			'fecha'			:fechaSistema,
			'tipoOperacion'	:tipoGarantiaAdicional,
			'instrumento'	:$('#ctaGarantiaAdicional').asNumber(),
			'referenciaMov'	:$('#creditoID').asNumber()
		};  
		
		
		setTimeout("$('#cajaLista').hide();", 200);
		if(transaccion != '' && !isNaN(transaccion)){
			ingresosOperacionesServicio.consulta(consultaTransaccion, transaccioncajamovs,function(transaccionCaja) {						
						if(transaccionCaja!=null){	
							$('#garantiaAdicional').val(transaccionCaja.montoEnFirme);
							$('#monto').val($('#garantiaAdicional').asNumber() + $('#montoPagado').asNumber());
							agregaFormatoMoneda('formaGenerica');
							$('#lblGAdicional').show();
							$('#tdGarantiaAdicional').show();
							$('#tdSeparadorMontoTotal').show();
						}else{
							$('#garantiaAdicional').val('0.00');
							$('#monto').val($('#montoPagado').asNumber());
							agregaFormatoMoneda('formaGenerica');
							$('#lblGAdicional').show();
							$('#tdGarantiaAdicional').show();
							$('#tdSeparadorMontoTotal').show();
						}
				});															
		}		
	}

});


function exitoTransaccionReversa(){
	parametroBean = consultaParametrosSession();
	if(bandera == 'S'){
		serverHuella.registroBitacoraUsuario(motivo,motivoID, huella_usuarioID, $('#campoGenerico').val());
	}
	var arreglo = $('#consecutivo').val().split('-'); 	
	$('#creditoID').val(arreglo[0]); // Numero de transaccion
	var folio = arreglo[1]; // Numero de Póliza
	
	
	var cliente = 	$('#clienteID').val()+' '+ $('#nombreCliente').val();
	var noCredito = $('#creditoID').val()+' - '+ $('#producCreditoID').val()+' '+$('#descripProducto').val();
	var transaccion= $('#tranRespaldo').val();
	var pagCre	   =  $('#montoPagado').val();
	var totalRev   =  $('#monto').val();
	var formaPag   =  $('#formaPago').val();
	var garantiaAd =  $('#garantiaAdicional').val();
		
	var nombreUsuario =  parametroBean.claveUsuario; 			
	var nombreInstitucion =  parametroBean.nombreInstitucion; 
	var fechaEmision=parametroBean.fechaSucursal;
	var sucursal=parametroBean.sucursal+'  '+ parametroBean.nombreSucursal;
	var hora='';
	var horaEmision= new Date();
	hora = horaEmision.getHours();
	hora = hora+':'+horaEmision.getMinutes();
	hora = hora+':'+horaEmision.getSeconds();
	fechaEmision= fechaEmision+'  '+ hora ;
	if (formaPag == 'E'){
		formaPag='Efectivo';
	}else 
	if (formaPag == 'C'){
		formaPag='Pago con Cargo a Cuenta';
	}
	
	if(Number(numeroCajaRealizoPago) == parametroBean.cajaID){
		$('#saldoMNSesionLabel').text(parametroBean.saldoEfecMN);	
	}
	inicializaFormaReversa();
	var pagina='TicketReversaPagoCre.htm?clienteID='+cliente+'&creditoID='+noCredito+'&tranRespaldo='+transaccion+'&pagCre='+pagCre+
	  '&totalRev='+totalRev+'&formaPago='+formaPag+'&garantiaAd='+garantiaAd
	  +'&folio='+folio+
	  '&usuario='+nombreUsuario+'&nombreInstitucion='+nombreInstitucion+'&fechaEmision='+fechaEmision+'&sucursal='+sucursal;
	window.open(pagina,'_blank');
	deshabilitaBoton("aceptar","submit");
	$('#grupoDes').val("");
}

function falloTransacionReversa(){
}
function inicializaFormaReversa(){	
	$('#clienteID').val('');
	$('#nombreCliente').val('');
	$('#pagaIVA option[value=""]').attr('selected','true');
	$('#estatus').val('');
	$('#fechaInicio').val('');
	$('#monedaID').val('');
	$('#monedaDes').val('');
	$('#producCreditoID').val('');
	$('#descripProducto').val('');
	$('#grupoID').val('');
	$('#cicloID').val('');
	$('#cuentaID').val('');
	$('#nomCuenta').val('');
	$('#saldoCta').val('');
	$('#montoCredito').val('');
	$('#tasafija').val('');
	$('#tranRespaldo').val('');	
	$('#formaPago option[value=""]').attr('selected','true');
	$('#montoPagado').val('');
	$('#garantiaAdicional').val('');
	$('#monto').val('');
	$('#ctaGarantiaAdicional').val('');
	$('#motivo').val('');
	$('#usuarioAutorizaID').val('');
	$('#contraseniaUsuarioAutoriza').val('');
	$('#listaReversaPagoCredito').val('');
	$('#cajaID').val('');
	$('#integrantes').val('');
	$('#gridIntegrantes').html('');
}

// Funcion que llena el combo de calcInteres
function consultaComboCalInteres() {
	dwr.util.removeAllOptions('calcInteres'); 
	formTipoCalIntServicio.listaCombo(catFormTipoCalInt.principal,function(formTipoCalIntBean){
		dwr.util.addOptions('calcInteres', {'':'SELECCIONAR'});
		dwr.util.addOptions('calcInteres', formTipoCalIntBean, 'formInteresID', 'formula');
	});
}

// Funcion que consulta la tasa base 
function consultaTasaBase(idControl) {
	var jqTasa = eval("'#" + idControl + "'");
	var tasaBase = $(jqTasa).asNumber();
	var TasaBaseBeanCon = {
			'tasaBaseID' : tasaBase
	};
	setTimeout("$('#cajaLista').hide();", 200);

	if (tasaBase > 0) {
		tasasBaseServicio.consulta(1, TasaBaseBeanCon, function(tasasBaseBean) {
			if (tasasBaseBean != null) {
				$('#desTasaBase').val(tasasBaseBean.nombre);
				$('#tasaBaseValor').val(tasasBaseBean.valor+'%');
				$('#tasaFija').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
				$('#tasaBaseValor').formatCurrency({ positiveFormat : '%n', roundToDecimalPlace : 4});
			} else {
				$('#desTasaBase').val('');
				$('#tasaBaseValor').val('');
			}
		});
	}
}

// Funcion que muestra los campos de la tasa variable
function muestraCamposTasa(calcInteresID){
	calcInteresID = Number(calcInteresID);
	$('#calcInteres').val(calcInteresID);
	// Si el calculo de interes es por tasaFija se ocultan campos de tasa variable
	if(calcInteresID <= TasaFijaID){
		VarTasaFijaoBase = 'Tasa Fija';
		$('tr[name=tasaBase]').hide();
		$('td[name=tasaPisoTecho]').hide();
		$('#tasaBase').val('');
		$('#desTasaBase').val('');
		$('#pisoTasa').val('');
		$('#techoTasa').val('');
	} else if(calcInteresID != TasaFijaID){
		// Si es por tasa variable, se consulta y se muestra
		VarTasaFijaoBase = 'Tasa Base Actual';
		consultaTasaBase('tasaBase');
		$('tr[name=tasaBase]').show();
		$('td[name=tasaPisoTecho]').hide();
		if(calcInteresID == TasaBasePisoTecho){
			$('td[name=tasaPisoTecho]').show();
		}
	}
	$('#lbltasaFija').text(VarTasaFijaoBase+': ');
	agregaFormatoControles('formaGenerica');
}