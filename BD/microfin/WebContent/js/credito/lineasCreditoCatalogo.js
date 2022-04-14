
var tipoCta		="";
var montoMax;
var montoMin;

var tipoInstitucion = 0; // Para determinar si es SOFIPO o SOFOM, SOCAP
var tipoSOFIPO		= 3; // Clave del Tipo de Institucion SOFIPO

$(document).ready(function() {
	esTab = true;

	//Definicion de Constantes y Enums  
	var catTipoTransaccionLineasCre = {
			'agrega':'1',
			'modifica':'2', 
	}; 

	var catTipoConsultaLineasCre = {
			'principal':1,
			'foranea':2
	};	
	var parametroBean = consultaParametrosSession();
	$('#sucursalID').val(parametroBean.sucursal);	
	$('#sucursal').val(parametroBean.nombreSucursal);	
	
	agregaFormatoControles('formaGenerica');
	consultaTipoInstitucion();
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	deshabilitaBoton('modifica', 'submit'); 
	deshabilitaBoton('agrega', 'submit');

	$(':text').focus(function() {	
		esTab = false;
	});

	$.validator.setDefaults({
		submitHandler: function(event) { 
			grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','lineaCreditoID');
			deshabilitaBoton('modifica', 'submit'); 
			deshabilitaBoton('agrega', 'submit');
		}
	});		

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionLineasCre.agrega);
		var fechaAplicacion = parametroBean.fechaAplicacion;
		var fechaIniForm = $('#fechaInicio').val();
		var fechaVenForm = $('#fechaVencimiento').val();
		if(fechaIniForm < fechaAplicacion){
			mensajeSis("Fecha es Menor a la del Sistema.");
			event.preventDefault();
		}
		if(fechaVenForm < fechaIniForm){
			mensajeSis("Fecha de Inicio es Inferior a la de Vencimiento.");
			event.preventDefault();
		}
		
	});

	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccionLineasCre.modifica);
		var fechaAplicacion = parametroBean.fechaAplicacion;
		var fechaIniForm = $('#fechaInicio').val();
		var fechaVenForm = $('#fechaVencimiento').val();
		if(fechaIniForm < fechaAplicacion){
			mensajeSis("Fecha es menor a la del Sistema.");
			event.preventDefault();
		}
		if(fechaVenForm < fechaIniForm){
			mensajeSis("Fecha de Inicio es Inferior a la de Vencimiento.");
			event.preventDefault();
		}

	});	

	$('#agrega').attr('tipoTransaccion', '1');
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
			mensajeSis("Fecha de Vencimiento debe ser superior a la de Inicio.  ");
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
			mensajeSis("Fecha de Inicio debe ser superior a la de Vencimiento.  ");
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
		lista('lineaCreditoID', '3', '1', camposLista, parametrosLista, 'lineasCreditoLista.htm');			       
	});

	$('#fechaInicio').blur(function() {
		var fechaAplicacion = parametroBean.fechaAplicacion;
		var fechInicio =  $('#fechaInicio').val();
		if ( fechInicio < fechaAplicacion &&  fechInicio != '' ){
			mensajeSis('La Fecha de Inicio no puede ser inferior a la del sistema.');
			$('#fechaInicio').focus();
			$('#fechaInicio').select();				
		}else
			$('#fechaVencimiento').focus();
	});
 
	$('#fechaVencimiento').bind('keyup',function(e){
		var fechaAplicacion = parametroBean.fechaAplicacion;
		var fechInicio =  $('#fechaInicio').val();
		if ( fechInicio < fechaAplicacion ){
			mensajeSis('La Fecha de Inicio no puede ser inferior a la del sistema.');
			$('#fechaInicio').focus();		
			$('#fechaInicio').select();		
		}
	});		

	$('#fechaVencimiento').blur(function() {
		var fechaAplicacion = parametroBean.fechaAplicacion;
		var fechInicio =  $('#fechaInicio').val();
		if ( fechInicio < fechaAplicacion &&  fechInicio != '' ){
			mensajeSis('La Fecha de Inicio no puede ser inferior a la del sistema.');
			$('#fechaInicio').focus();
			$('#fechaInicio').select();				
		}else
			$('#productoCreditoID').focus();
	});


	$('#solicitado').blur(function() {
		validaMonto();
		
	});

	consultaParametros();



	$('#lineaCreditoID').focus();



	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		// quitaFormatoControles('formaGenerica');
		rules: {


			clienteID: { 
				required: true
			},	
			sucursalID: { 
				required: true
			},
			cuentaID: { 
				required: true
			},	
			folioContrato: {
				required: true
			},
			productoCreditoID: {
				required: true
			},
			fechaInicio: { 
				required: true,
				date: true

			},
			fechaVencimiento: { 
				required: true,
				date: true
			},
			solicitado: { 
				required: true
			}

		},
		messages: {



			clienteID: {
				required: 'Especificar Cliente',
			},
			sucursalID: {
				required: 'Especificar sucursal',
			},
			cuentaID: {
				required: 'Especificar Cuenta',
			},
			folioContrato: {
				required: 'Especificar Folio del Contrato',
			},
			productoCreditoID: {
				required: 'Especificar Producto de Crédito.',
			},
			fechaInicio: {
				required: 'Especificar Fecha ',
				date :'Fecha Incorrecta'
			},
			fechaVencimiento: {
				required: 'Especificar Fecha',
				date : 'Fecha Incorrecta'
			},
			solicitado: { 
				required: 'Especificar monto'
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
		var var_estatus;
		setTimeout("$('#cajaLista').hide();", 200);

		if(lineaCredito != '' && !isNaN(lineaCredito) && esTab){

			if(lineaCredito=='0'){ 
				//$('#datos').hide();	
				$('#valores1').hide();	
				$('#valores2').hide();	
				$('#valores3').hide();	
				$('#valores4').hide();	


				habilitaBoton('agrega', 'submit');		
				deshabilitaBoton('modifica', 'submit');
				//inicializaForma('formaGenerica','lineaCreditoID');	
				//$('#lineaCreditoID').val('');
				$('#clienteID').val('');	
				$('#nombreCte').val('');	
				$('#cuentaID').val('');	
				$('#desCuenta').val('');
				$('#sucursalID').val('');	
				$('#sucursal').val('');	
				$('#monedaID').val('');	
				$('#moneda').val('');	
				$('#folioContrato').val('');	
				$('#fechaVencimiento').val('');	
				$('#productoCreditoID').val('');
				$('#desProductoCred').val('');	
				$('#solicitado').val('');	
				$('#autorizado').val('');	
				$('#dispuesto').val('');	
				$('#pagado').val('');
				$('#saldoDisponible').val('');	
				$('#saldoDeudor').val('');	
				$('#estatus').val('');	
				$('#numeroCreditos').val('');
				$('#sucursalID').val(parametroBean.sucursal);   
				$('#sucursal').val(parametroBean.nombreSucursal);   
				consultaParametros();
			} else { 
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');	

				//$('#datos').show();	
				$('#valores1').show();	
				$('#valores2').show();	
				$('#valores3').show();	
				$('#valores4').show();	
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
						if(var_estatus!='I'){ 
							deshabilitaBoton('modifica', 'submit');
						} else{
							deshabilitaBoton('agrega', 'submit');
							habilitaBoton('modifica', 'submit');	
						}
						//$('#datos').show();
						$('#valores1').show();	
						$('#valores2').show();	
						$('#valores3').show();	
						$('#valores4').show();	
					}else{ 
						mensajeSis("No existe la Línea de Crédito.");
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('agrega', 'submit');
						//inicializaForma('formaGenerica','lineaCreditoID');	
						$('#lineaCreditoID').val('');
						$('#clienteID').val('');	
						$('#nombreCte').val('');	
						$('#cuentaID').val('');	
						$('#desCuenta').val('');
						$('#sucursalID').val('');   
						$('#sucursal').val(''); 
						$('#monedaID').val('');	
						$('#moneda').val('');	
						$('#folioContrato').val('');	
						$('#fechaVencimiento').val('');	
						$('#productoCreditoID').val('');
						$('#desProductoCred').val('');	
						$('#solicitado').val('');	
						$('#autorizado').val('');	
						$('#dispuesto').val('');	
						$('#pagado').val('');
						$('#saldoDisponible').val('');	
						$('#saldoDeudor').val('');	
						$('#estatus').val('');	
						$('#numeroCreditos').val('');	
						$('#sucursalID').val(parametroBean.sucursal);   
						$('#sucursal').val(parametroBean.nombreSucursal); 
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
						mensajeSis("El Producto de Crédito debe ser Individual.");
						$('#productoCreditoID').focus();
						$('#productoCreditoID').select();
						$('#desProductoCred').val("");
					}
					}
				}else{
					mensajeSis("No existe el Producto de Crédito.");
					$('#productoCreditoID').val("");
					$('#desProductoCred').val("");
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
					mensajeSis("No existe el Cliente.");
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
					mensajeSis("No existe la Sucursal.");
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
					mensajeSis("No existe el Tipo de Moneda.");
					$(jqMoneda).focus();
				}    						
			});
		}
	}

	function consultaParametros(){
		var parametroBean = consultaParametrosSession();
		$('#sucursalID').val(parametroBean.sucursal);   
		$('#sucursal').val(parametroBean.nombreSucursal);           
		$('#fechaReg').val(parametroBean.fechaSucursal);
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
					if( $('#clienteID').val() != ''){
						if (cuenta.clienteID== $('#clienteID').val()){

					tipoCta = cuenta.tipoCuentaID;
					//$('#monedaID').val(cuenta.monedaID);
					//$('#sucursalID').val(cuenta.sucursalID);			
					//consultaMoneda('monedaID');
					//consultaSucursal('sucursalID');	
					consultaTipoCta();
						}else{
							mensajeSis("Cuenta No Asociada al Cliente.");
							$('#cuentaID').val("");
							$('#desCuenta').val("");
							$('#cuentaID').focus();
						}
					}else{
						$('#desCuenta').val(cuenta.descripcionTipoCta);
						$('#cuentaID').val(cuenta.cuentaAhoID);		
					}
				}else{
					mensajeSis("No existe la Cuenta.");

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
					//$('#sucursalID').val(cuenta.sucursalID);		
					//consultaSucursal('sucursalID');	
					consultaTipoCta();
				}else{
					mensajeSis("No existe la cuenta.");

					$('#cuentaID').focus();
					$('#cuentaID').select();						
				}
			});
		}	
	} 

	function consultaParametros(){
		var parametroBean = consultaParametrosSession();  
		$('#fechaInicio').val(parametroBean.fechaAplicacion);
	} 
	
	
	/* Validar Monto*/
	
	function validaMonto(){
		var montosol = $('#solicitado').asNumber();

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
			
				if(montosol < montoMin){
					mensajeSis("Para este Producto Puede Seleccionar un Monto Mínimo de: "+ montoMi +".");
					$('#solicitado').val("");
					$('#solicitado').focus();
					if($('#lineaCreditoID').val()=='0'){ 
						deshabilitaBoton('agrega', 'submit');
					    }else{deshabilitaBoton('modifica', 'submit');}

						

				}else{
					if(montosol > montoMax){
						mensajeSis("Para este Producto Puede Seleccionar un Monto Máximo de: "+ montoMa +".");
							$('#solicitado').val("");
							$('#solicitado').focus();
							if($('#lineaCreditoID').val()=='0'){ 
								deshabilitaBoton('agrega', 'submit');
							    }else{deshabilitaBoton('modifica', 'submit');}
						
					}else{
						
				if(montosol <= montoMax && montosol >= montoMin){
					if($('#lineaCreditoID').val()=='0'){ 
						habilitaBoton('agrega', 'submit');
						}else{ 
							habilitaBoton('modifica', 'submit');}
						}
			      	}
				}
		     //}

         } //Termina Funcion validaMonto

});



// Consulta el tipo de institucion
function consultaTipoInstitucion() {			
	var parametrosSisCon ={
 		 	'empresaID' : 1
	};			
	parametrosSisServicio.consulta(15,parametrosSisCon, function(institucion) {
		if (institucion != null) {			
			tipoInstitucion = institucion.tipoInstitID;

			if(tipoInstitucion == tipoSOFIPO){
				$('.tipoSofipo').show();
			}else{
				$('.tipoSofipo').hide();
			}
		}
	});
}