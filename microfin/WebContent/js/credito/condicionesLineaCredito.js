
var tipoCta		="";
var montoMax;
var montoMin;
var var_estatus;


$(document).ready(function() {
	esTab = true;


	var catTipoActualizacionLineasCre = {
			'actualiza':'3', 
	}

	var catTipoConsultaLineasCre = {
			'principal':1,
			'foranea':2
	};	
	
	var catTipoTranLineasCre = {
			'actualizaMont':5
	};	
	var parametroBean = consultaParametrosSession();
	agregaFormatoControles('formaGenerica');
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('modifica', 'submit'); 

	$(':text').focus(function() {	
		esTab = false;
	});

	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','lineaCreditoID');
			deshabilitaBoton('modifica', 'submit'); 
		}
	});		

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});


	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoActualizacionLineasCre.actualiza);
		$('#tipoActualizacion').val(catTipoTranLineasCre.actualizaMont);

		var fechaAplicacion = parametroBean.fechaAplicacion;
		var fechaIniForm = $('#fechaInicio').val();
		var fechaVenForm = $('#fechaVencimiento').val();
		if(fechaVenForm < fechaAplicacion){
			mensajeSis("Fecha es menor a la del Sistema.");
			event.preventDefault();
		}
		if(fechaVenForm < fechaIniForm){
			mensajeSis("Fecha de Vencimiento es Inferior a la de Inicio.");
			event.preventDefault();
		}

	});	

	$('#modifica').attr('tipoTransaccion', '2');

	$('#cuentaID').blur(function() {
		consultaCta(this.id);
	});	


	$('#cuentaID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "clienteID";
		parametrosLista[0] = $('#clienteID').val();
		lista('cuentaID', '1', '2', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');		       
	});


	$('#clienteID').bind('keyup',function(e){
		if(this.value.length >= 4){
			lista('clienteID', '4', '14', 'nombreCompleto', $('#clienteID').val(), 'listaCliente.htm');
		}
	}); 

	$('#clienteID').blur(function() {
		consultaCliente(this.id);
	});

	$('#sucursalID').bind('keyup',function(e){
		if(this.value.length >= 3){
			lista('sucursalID', '3', '1', 'nombreSucurs', $('#sucursalID').val(), 'listaSucursales.htm');
		}				        
	});	


	$('#sucursalID').blur(function() {
		consultaSucursal(this.id);
	});

	$('#productoCreditoID').bind('keyup',function(e){ 
		var fechInicio =  $('#fechaInicio').val();
		var fechaVenForm = $('#fechaVencimiento').val(); 

		convertDate(fechInicio);
		convertDate(fechaVenForm);

		if(fechaVenForm < fechInicio && fechaVenForm != ''){ 
			mensajeSis("Fecha de Vencimiento debe ser superior a la de Inicio.");
			$('#fechaVencimiento').focus();
			$('#fechaVencimiento').select();
		}else
			if(this.value.length >= 2){
				lista('productoCreditoID', '1', '1', 'descripcion', $('#productoCreditoID').val(), 'listaProductosCredito.htm');
			}				       
	});  

	$('#productoCreditoID').blur(function() {
		var fechInicio =  $('#fechaInicio').val();
		var fechaVenForm = $('#fechaVencimiento').val(); 

		convertDate(fechInicio);
		convertDate(fechaVenForm);

		if(fechaVenForm < fechInicio && fechaVenForm != '' ){ 
			mensajeSis("Fecha de Vencimiento debe ser superior a la de Inicio.");
			$('#fechaVencimiento').focus();
			$('#fechaVencimiento').select();
		}
		consultaProductosCredito(this.id);
	}); 

	$('#monedaID').blur(function() {
		consultaMoneda(this.id);
	});

	$('#lineaCreditoID').blur(function() {
		validaLineaCredito(this.id);
	}); 

	$('#lineaCreditoID').bind('keyup',function(e){
		var camposLista = new Array();
		var parametrosLista = new Array();
		camposLista[0] = "clienteID";
		parametrosLista[0] = $('#lineaCreditoID').val();				
		lista('lineaCreditoID', '3', '3', camposLista, parametrosLista, 'lineasCreditoLista.htm');			       
	});


/*	$('#fechaVencimiento').bind('keyup',function(e){
		var fechaAplicacion = parametroBean.fechaAplicacion;
		var fechVenci =  $('#fechaVencimiento').val();
		if ( fechVenci < fechaAplicacion ){
			mensajeSis('La fecha de Vencimiento no puede ser inferior a la del sistema.');
			$('#fechaVencimiento').focus();		
			$('#fechaVencimiento').select();		
		}
	});		*/

/*	$('#fechaVencimiento').blur(function() {
		var fechaAplicacion = parametroBean.fechaAplicacion;
		var fechVenci =  $('#fechaVencimiento').val();
		if ( fechVenci < fechaAplicacion &&  fechVenci != '' ){
			mensajeSis('La fecha de Vencimiento no puede ser inferior a la del sistema.');
			$('#fechaVencimiento').focus();
			$('#fechaVencimiento').select();				
		}else
			$('#productoCreditoID').focus();
	});
*/

	$('#excedente').blur(function() {
		validaMonto();
		
	});

	$('#lineaCreditoID').focus();


	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		// quitaFormatoControles('formaGenerica');
		rules: {


			
			fechaVencimiento: { 
				required: true,
				date: true
			},
			excedente: { 
				required: true
			}

		},
		messages: {
		
			fechaVencimiento: {
				required: 'Especificar Fecha.',
				date : 'Fecha Incorrecta.'
			},
			excedente: { 
				required: 'Especificar Monto.'
			}
		}		
	});

	//------------ Validaciones de Controles -------------------------------------
	function validaLineaCredito(idControl) {
		var jqLinea  = eval("'#" + idControl + "'");
		var lineaCredito = $(jqLinea).val();	

		var tipConPrincipal = 1;
		var lineaCreditoBeanCon = { 
				'lineaCreditoID'	:lineaCredito
		};
		setTimeout("$('#cajaLista').hide();", 200);

		if(lineaCredito != '' && !isNaN(lineaCredito) && esTab){

			if(lineaCredito=='0'){ 
				mensajeSis("No exíste la Línea de Crédito.");
				limpiaFormulario();
				deshabilitaBoton('modifica', 'submit');
				$('#lineaCreditoID').focus();
			} else { 
				habilitaBoton('modifica', 'submit');	

			
				lineasCreditoServicio.consulta(tipConPrincipal, lineaCreditoBeanCon,function(linea) {
					if(linea!=null){
						agregaFormatoControles('formaGenerica');
						dwr.util.setValues(linea);
						consultaMoneda('monedaID');
						consultaCliente('clienteID');	 
						consultaSucursal('sucursalID');
						consultaProductosCredito('productoCreditoID');
						consultaCuenta(linea.cuentaID);
						
						$('#autorizado').formatCurrency({
							positiveFormat: '%n', 
							roundToDecimalPlace: 2	
						});	
						$('#solicitado').formatCurrency({
							positiveFormat: '%n', 
							roundToDecimalPlace: 2	
						});	
						var_estatus=(linea.estatus);
						validaEstatus(var_estatus); 
						if(var_estatus == 'I' || var_estatus == 'C' || var_estatus == 'B'){ 
							deshabilitaBoton('modifica', 'submit');
						} else{
							habilitaBoton('modifica', 'submit');	
						}
			
					}else{ 
						mensajeSis("No Existe la Línea de Crédito.");
						deshabilitaBoton('modifica', 'submit');
						inicializaForma('formaGenerica','lineaCreditoID');	
						$(jqLinea).focus();
						$(jqLinea).select();										
					}
				});										
			}								 				
		}
	}

	function validaEstatus(var_estatus) {
		var estatusAutorizada 	="A"; 
		var estatusBloqueado ="B";
		var estatusCancelada ="C";
		var estatusInactivo 	="I";
		if(var_estatus == estatusAutorizada){
			$('#estatus').val('AUTORIZADO');
		}
		if(var_estatus == estatusBloqueado){
			$('#estatus').val('BLOQUEADO');
		}
		if(var_estatus == estatusCancelada){
			$('#estatus').val('CANCELADO');
		}
		if(var_estatus == estatusInactivo){
			$('#estatus').val('INACTIVO');
		}	
	}

	function consultaProductosCredito(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var conForanea =2;
		var ProductoCreditoCon = { 
				'producCreditoID':numCliente
		};
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente != '' && !isNaN(numCliente)){
			productosCreditoServicio.consulta(conForanea,ProductoCreditoCon,function(productos){
				if(productos!=null){
					agregaFormatoControles('formaGenerica');
					$('#desProductoCred').val(productos.descripcion);
					montoMin = (productos.montoMinimo);
					montoMax = (productos.montoMaximo);
					if(productos.manejaLinea !='S'){
						mensajeSis("El Producto de Crédito no Maneja Línea de Crédito.");
						$('#productoCreditoID').focus();
						$('#productoCreditoID').select();
						$('#desProductoCred').val("");
						
					}else{
					if(productos.esGrupal !='N'){
						mensajeSis("El Producto de Crédito debe de ser Individual.");
						$('#productoCreditoID').focus();
						$('#productoCreditoID').select();
						$('#desProductoCred').val("");
					}
					}
				}else{
					mensajeSis("No Existe el Producto de Crédito.");
					$(jqCliente).focus();
				}    						
			});
		}
	}
	function consultaCliente(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var conCliente =6;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
				if(cliente!=null){	
					if(cliente.esMenorEdad != "S"){
							$('#clienteID').val(cliente.numero);	
							$('#nombreCte').val(cliente.nombreCompleto);	
					}else{
						mensajeSis("El Cliente es Menor de Edad.");
						$(jqCliente).focus();
						$(jqCliente).select();
						$("#nombreCte").val('');
					}  
				}else{
					mensajeSis("No Existe el Cliente.");
					$(jqCliente).focus();
					$(jqCliente).select();
					$("#nombreCte").val('');
				}    						
			});
		}
	} 
	// Cosulta la descripcion del tipo de cuenta 
	function consultaTipoCta() {
		var numTipoCta = tipoCta;
		var conTipoCta=2;
		var TipoCuentaBeanCon = { 
  			'tipoCuentaID':numTipoCta
		};

		setTimeout("$('#cajaLista').hide();", 200); 
		if(numTipoCta != '' && !isNaN(numTipoCta)){
			tiposCuentaServicio.consulta(conTipoCta, TipoCuentaBeanCon,function(tipoCuenta) {
						if(tipoCuenta!=null){
							$('#monedaID').val(tipoCuenta.monedaID);
							$('#desCuenta').val(tipoCuenta.descripcion)
							consultaMoneda('monedaID');									
						}else{
							$(jqTipoCta).focus();
						}    						 
				});
			}
	}  

	function consultaSucursal(idControl) {
		var jqSucursal = eval("'#" + idControl + "'");
		var numSucursal = $(jqSucursal).val();	
		var conSucursal=2;
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numSucursal != '' && !isNaN(numSucursal)){
			sucursalesServicio.consultaSucursal(conSucursal,numSucursal,function(sucursal) {
				if(sucursal!=null){	
					$('#sucursalID').val(sucursal.sucursalID);		
					$('#sucursal').val(sucursal.nombreSucurs);

				}else{
					mensajeSis("No Existe la Sucursal.");
					$(jqSucursal).focus();
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
					$('#moneda').val(moneda.descripcion);
				}else{
					mensajeSis("No Existe el Tipo de Moneda.");
					$(jqMoneda).focus();
				}    						
			});
		}
	}


	function consultaCta(idControl) {
		var jqCta  = eval("'#" + idControl + "'");
		var numCta = $(jqCta).val();
		var CuentaAhoBeanCon = {
				'cuentaAhoID'	:numCta,
				'clienteID'		:$('#clienteID').val()
		};
		var conCta =3;
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCta != '' && !isNaN(numCta) && esTab){
			cuentasAhoServicio.consultaCuentasAho(3,CuentaAhoBeanCon,function(cuenta) {
				if(cuenta!=null){
					tipoCta = cuenta.tipoCuentaID;
					//$('#monedaID').val(cuenta.monedaID);
					$('#sucursalID').val(cuenta.sucursalID);			
					//consultaMoneda('monedaID');
					consultaSucursal('sucursalID');	
					consultaTipoCta();
				}else{
					mensajeSis("No Existe la Cuenta.");

					$('#cuentaID').focus();
					$('#cuentaID').select();						
				}
			});
		}	
	} 
	function consultaCuenta(cuentas) {
		var numCta = cuentas;
		
		var CuentaAhoBeanCon = {
				'cuentaAhoID'	:numCta,
				'clienteID'		:$('#clienteID').val()
		};
		var conCta =3;
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCta != '' && !isNaN(numCta)){
			cuentasAhoServicio.consultaCuentasAho(3,CuentaAhoBeanCon,function(cuenta) {
				if(cuenta!=null){
					tipoCta = cuenta.tipoCuentaID;
					$('#sucursalID').val(cuenta.sucursalID);		
					consultaSucursal('sucursalID');	
					consultaTipoCta();
				}else{
					mensajeSis("No Existe la Cuenta.");

					$('#cuentaID').focus();
					$('#cuentaID').select();						
				}
			});
		}	
	} 

	
	/* Validar Monto*/
	
	function validaMonto(){
		var montoaut = $('#excedente').asNumber();
		var autoriza = $('#autorizado').asNumber();
		var suma = (montoaut + autoriza);
		
		
		 $('#montoMinimo').val(montoMin);
		 $('#montoMinimo').formatCurrency({
				positiveFormat : '%n',
				negativeFormat : '%n',
				roundToDecimalPlace : 2
			});
		 $('#montoMaximo').val(montoMax);
		 $('#montoMaximo').formatCurrency({
				positiveFormat : '%n',
				negativeFormat : '%n',
				roundToDecimalPlace : 2
			});
		
		var montoMi =  $('#montoMinimo').val();
		var montoMa =  $('#montoMaximo').val();
		
		
		
		$('#aumentado').val(suma);

				if(suma < montoMin ){
					mensajeSis("Para este Producto Puede Seleccionar un Monto Mínimo de:"+ montoMi+".");
					$('#excedente').val("");
					$('#excedente').focus();
					deshabilitaBoton('modifica', 'submit');

						

				}else{
					if(suma > montoMax){
						mensajeSis("Para este Producto Puede Seleccionar un Monto Máximo de: "+ montoMa+".")					
							deshabilitaBoton('modifica', 'submit');
						$('#excedente').val("");
						$('#excedente').focus();
						
					}else{
						
				if(suma <= montoMax && suma >= montoMin){
					   if(var_estatus == 'I' || var_estatus == 'C' || var_estatus == 'B'){
							deshabilitaBoton('autorizar', 'submit');	

				        }else{
					
					habilitaBoton('modifica', 'submit');}}
						
			      	}
				}

         } //Termina Funcion validaMonto
	
	
	function limpiaFormulario(){
		 $('#lineaCreditoID').val("");
		 $('#clienteID').val("");
		 $('#nombreCte').val("");
		 $('#cuentaID').val("");
		 $('#desCuenta').val("");
		 $('#monedaID').val("");
		 $('#moneda').val("");
		 $('#sucursalID').val("");
		 $('#sucursal').val("");
		 $('#folioContrato').val("");
		 $('#productoCreditoID').val("");
		 $('#desProductoCred').val("");
		 $('#solicitado').val("");
		 $('#autorizado').val("");
		 $('#dispuesto').val("");
		 $('#pagado').val("");
		 $('#saldoDisponible').val("");
		 $('#saldoDeudor').val("");
		 $('#estatus').val("");
		 $('#numeroCreditos').val("");
		 $('#aumentado').val("");
		 $('#fechaInicio').val("");
		 $('#fechaVencimiento').val("");

	}

});