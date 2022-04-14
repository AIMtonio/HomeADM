//Definición de constantes y Enums
esTab = true;

var catTipoConsultaCreditoAgro = { 
	'generalesAgro'			: 43
};	

var Enum_Constantes = {
	'SI' : 'S',
	'NO' : 'N',
	'Cadena_Vacia'	:'',
	'Entero_Cero'	:0,
	'Entero_Cien'	:100
};
var catTipoTranCredito = { 
	'recupCartera'			: 1
};
var parametroBean = consultaParametrosSession(); 
var fechaSistemaTicket= parametroBean.fechaAplicacion;

$(document).ready(function(){ 
		
		$("#creditoAgro").focus();
		//-----------------------Métodos y manejo de eventos-----------------------
		
		deshabilitaBoton('graba', 'submit');
		
		// llena el combo para la Formula de Calculo de Interés 
		consultaMotivosCastigo();

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
				var estatus = $('#estatusCred').val();
				var adeudo = 0; 
				var montoPag = 0;
				
					adeudo = $('#montoxRecActivoCast').asNumber() +  $('#montoxRecContCast').asNumber();
					
					montoPag = $('#monRecuperado').asNumber();
					if(montoPag > adeudo ){
						mensajeSis('El Monto a Pagar es Mayor al Adeudo.');
						$('#monRecuperado').focus();
					}else{
						if(montoPag > 0 && adeudo == 0 && estatus !='PAGADO'){
							mensajeSis("El Crédito No Presenta Adeudo.");
							$('#montoPagar').focus();
							$('#montoPagar').val('');

						}else {
							var porcentajeCreditoRecCont = $('#porcentajeCreditoRecCont').asNumber();
							var porcentajeCreditoRec = $('#porcentajeCreditoRec').asNumber();
							var total = porcentajeCreditoRecCont + porcentajeCreditoRec;
							if(total > 100){
								mensajeSis('La Suma de los Porcentajes No Puede Ser Mayor a 100%');
							}
							if(total < 100){
								mensajeSis('La Suma de los Porcentajes No Puede Ser Menor a 100%');
							}
							if(total == 100){
								grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','numeroTransaccion','funcionExitoPago','funcionFalloPago');
							}
						}
					}
	
			}
		});	
		
		$('#porcentajeCreditoRec').blur(function(){
			var porcentajeCreditoRecCont = $('#porcentajeCreditoRecCont').asNumber();
			var porcentajeCreditoRec = $('#porcentajeCreditoRec').asNumber();
			
			if(porcentajeCreditoRec > 100){
				$('#porcentajeCreditoRec').val('0');
				$('#porcentajeCreditoRec').focus();
				mensajeSis('El Valor Máximo es 100');
			}else{
				var total = porcentajeCreditoRecCont + porcentajeCreditoRec;
				if(total > 100){
					$('#porcentajeCreditoRec').val('0');
					$('#porcentajeCreditoRec').focus();
					mensajeSis('La Suma de los Porcentajes No Puede Ser Mayor a 100%');
				}
			}
		});

		$('#porcentajeCreditoRecCont').blur(function(){
			var porcentajeCreditoRecCont = $('#porcentajeCreditoRecCont').asNumber();
			var porcentajeCreditoRec = $('#porcentajeCreditoRec').asNumber();

			if(porcentajeCreditoRec > 100){
				$('#porcentajeCreditoRecCont').val('0');
				$('#porcentajeCreditoRecCont').focus();
				mensajeSis('El Valor Máximo es 100');
			}else{
				var total = porcentajeCreditoRecCont + porcentajeCreditoRec;
				if(total > 100){
					$('#porcentajeCreditoRecCont').val('0');
					$('#porcentajeCreditoRecCont').focus();
					mensajeSis('La Suma de los Porcentajes No Puede Ser Mayor a 100%');
				}
			}
		});

		
		$('#creditoAgro').blur(function(){
			if(isNaN($('#creditoAgro').val()) ){
				$('#creditoAgro').val("");
				$('#creditoAgro').focus();
			} else {
				esTab = true;
				consultaCredito(this.id);
			}
		});		

		$('#monRecuperado').blur(function(){
			var saldoCreditoAgro = $('#saldoCreditoAgro').asNumber();
			var monRecuperado = $('#monRecuperado').asNumber();
			if(monRecuperado > 0 && monRecuperado != ''){
				if(monRecuperado > saldoCreditoAgro ){
					deshabilitaBoton('graba', 'submit');
					$('#monRecuperado').val('0.00');
					mensajeSis('El Saldo de la Cuenta es Insuficiente');
				}else{
					habilitaBoton('graba', 'submit');
				}
			}

		});		

		
		$('#creditoAgro').bind('keyup', function(e){
			lista('creditoAgro', '2', '49', 'creditoID', $('#creditoAgro').val(), 'ListaCredito.htm');
		});


		// Porcentaje del crédito activo
		$('#creditoR').blur(function(e){
			var valorPorcentaje = Math.round($('#creditoR').asNumber());
			$('#creditoR').val((valorPorcentaje).toFixed(2));

			if(valorPorcentaje >= Enum_Constantes.Entero_Cero && valorPorcentaje <= Enum_Constantes.Entero_Cien){
				$('#creditoRC').val(Enum_Constantes.Entero_Cien - valorPorcentaje);
			} else {
				$('#creditoRC').val(Enum_Constantes.Entero_Cero);
			}
			agregaFormatoControles('formaGenerica');
		});

		//------------ Validaciones de la Forma -------------------------------------

		$('#formaGenerica').validate({
			rules: {
				creditoAgro: {
					required: true
				},
				montoPagar: {
					required: true
				},
				creditoR: {
					required: true,
					min : 0,
					max : 100
				}
			},
			messages: {
				creditoAgro: {
					required: 'Especificar Número de  Crédito'
				},
				montoPagar: {
					required: 'Especificar el Monto a Pagar.'
				},
				creditoR: {
					required : 'Especificar el Porcentaje del Crédito.',
					maxlength : 'Máximo 3 dígitos enteros.',
					min : 'Sólo números positivos.',
					max : 'El Porcentaje no debe ser Mayor al 100%.'
				}
			}		
		});	
		
		$('#graba').click(function(){ 
			$('#tipoTransaccion').val(catTipoTranCredito.recupCartera);	
		});

});

	//-------------Validaciones de controles---------------------					
	function consultaCredito(controlID){  // cccc
		esTab=true;	
		var numCredito = $('#creditoAgro').val();
		setTimeout("$('#cajaLista').hide();", 200);

		if(numCredito != '' && !isNaN(numCredito)){
			var creditoBeanCon = { 
				'creditoAgro':$('#creditoAgro').val(),
				'fechaActual':parametroBean.fechaAplicacion
			};

			recupCarteraCastAgroServicio.consulta(catTipoConsultaCreditoAgro.generalesAgro,creditoBeanCon,function(credito) {
				if(credito!=null){
					if(credito.esAgropecuario == Enum_Constantes.SI){
						esTab=true;	

						$('#creditoAgro').val(credito.creditoAgro);
						$('#productoCreditoAgro').val(credito.productoCreditoAgro);
						$('#desProducAgro').val(credito.desProducAgro);
						$('#clienteID').val(credito.clienteID);  
						$('#nombreCliente').val(credito.nombreCliente);
						$('#estatusCred').val(credito.estatusCred ); 
						$('#monedaCartAgro').val(credito.monedaCartAgro);
						$('#desMonedaCartAgro').val(credito.desMonedaCartAgro);
						$('#montoCreditoCastAgro').val(credito.montoCreditoCastAgro);
						$('#cuentaID').val(credito.cuentaID ); 
						$('#desCuenta').val(credito.desCuenta ); 
						$('#saldoCreditoAgro').val(credito.saldoCreditoAgro);
						$('#fechaCastigo').val(credito.fechaCastigo); 
						$('#motivoCastigo').val(credito.motivoCastigo);
						$('#observacionesCastigo').val(credito.observacionesCastigo);
						$('#monRecuperado').val(credito.monRecuperado ); 
						$('#porcentajeCreditoRec').val(credito.porcentajeCreditoRec);
						$('#porcentajeCreditoRecC').val(credito.porcentajeCreditoRecC);
						$('#capitalActivoCast').val(credito.capitalActivoCast ); 
						$('#interesActivoCast').val(credito.interesActivoCast ); 
						$('#moratoriosActivosCast').val(credito.moratoriosActivosCast);
						$('#comisionesActivasCast').val(credito.comisionesActivasCast);
						$('#IVAActivoCast').val(credito.IVAActivoCast);
						$('#totalActivoCastigado').val(credito.totalActivoCastigado);
						$('#montoRecActivoCast').val(credito.montoRecActivoCast);
						$('#montoxRecActivoCast').val(credito.montoxRecActivoCast);
						$('#capitalContCast').val(credito.capitalContCast);
						$('#interesContCast').val(credito.interesContCast ); 
						$('#moratoriosContCast').val(credito.moratoriosContCast);
						$('#comisionesContCast').val(credito.comisionesContCast);
						$('#IVAContCast').val(credito.IVAContCast);
						$('#totalContCastigado').val(credito.totalContCastigado);
						$('#montoRecContCast').val(credito.montoRecContCast);
						$('#montoxRecContCast').val(credito.montoxRecContCast);

						validaEstatusCredito(credito.estatusCred);
						consultaCta('cuentaID');
						consultaCliente('clienteID'); 
						consultaProducCredito('productoCreditoAgro');
						consultaMoneda('monedaCartAgro');
						agregaFormatoControles('formaGenerica');
						consultaCont();
					} else {
						if(credito.esAgropecuario == 'P'){
							inicializaForma('formaGenerica','creditoAgro');
							mensajeSis('El Crédito No Esta Castigado.<br>Favor de Consultarlo en el Módulo <i><u>Cartera</u></i>.');
							deshabilitaBoton('pagar','submit');
							$('#creditoAgro').focus();
						}else{
							inicializaForma('formaGenerica','creditoAgro');
							mensajeSis('El Crédito No es Agropecuario.<br>Favor de Consultarlo en el Módulo <i><u>Cartera</u></i>.');
							deshabilitaBoton('pagar','submit');
							$('#creditoAgro').focus();
						}
					}
				}else{
					inicializaForma('formaGenerica','creditoAgro');
					mensajeSis("No Existe el Credito");
					deshabilitaBoton('pagar','submit');
					consultaMotivosCastigo();
					$('#creditoAgro').focus();
				}
			});
		}
	}

	function consultaCliente(idControl){
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
					mensajeSis("No Existe el Cliente.");
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
					$('#desMonedaCartAgro').val(moneda.descripcion);										
				}else{
					mensajeSis("No Existe el Tipo de Moneda.");
					$('#desMonedaCartAgro').val('');
					$(jqMoneda).focus();
				}
			});
		}
	}

	function consultaProducCredito(idControl) {	
		var jqProdCred  = eval("'#" + idControl + "'");
		var numProdCre = $(jqProdCred).val();			

		var conTipoCta=2;
		var ProdCredBeanCon = {
			'producCreditoID':numProdCre
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numProdCre != '' && !isNaN(numProdCre)){
			productosCreditoServicio.consulta(conTipoCta, ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){			
					$('#desProducAgro').val(prodCred.descripcion);		
				}else{
					$('#'+id).focus();
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
			$('#estatusCred').val('INACTIVO');
			habilitaBoton('pagar', 'submit');
		}	
		if(var_estatus == estatusAutorizado){
			$('#estatusCred').val('AUTORIZADO');
			habilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusVigente){
			$('#estatusCred').val('VIGENTE');
			habilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusPagado){
			$('#estatusCred').val('PAGADO');
			deshabilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusCancelada){
			$('#estatusCred').val('CANCELADO');							
			habilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusVencido){
			$('#estatusCred').val('VENCIDO');							
			habilitaBoton('pagar', 'submit');
		}
		if(var_estatus == estatusCastigado){
			$('#estatusCred').val('CASTIGADO');							
			habilitaBoton('pagar', 'submit');
		}		
	}

	function consultaCta(idControl) {
		esTab=true;	

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
					consultaTipoCta(cuenta.tipoCuentaID);
					consultaSaldoCta('cuentaID'); 
				}else{
					mensajeSis("No Existe la Cuenta de Ahorro.");
				}
			});                                                                                                                        
		}  
	}
	
	function consultaTipoCta(tipoCta) {
		esTab=true;	

		var numTipoCta = tipoCta;
		var conTipoCta=2;
		var TipoCuentaBeanCon = {
			'tipoCuentaID':numTipoCta
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numTipoCta != '' && !isNaN(numTipoCta)){
			tiposCuentaServicio.consulta(conTipoCta, TipoCuentaBeanCon,function(tipoCuenta) {
				if(tipoCuenta!=null){			
					$('#desCuenta').val(tipoCuenta.descripcion);							
				}else{
					$(jqTipoCta).focus();
				}    						
			});
		}
	}
	function consultaCont() {
		var capitalContCast =$('#montoxRecContCast').asNumber();
		var IVAContCast=$('#IVAContCast').asNumber();
		
		var capitalActivoCast=$('#montoxRecActivoCast').asNumber();
		var IVAActivoCast=$('#IVAActivoCast').asNumber();
		
		var total = capitalActivoCast + IVAActivoCast;
		var totalCont = capitalContCast + IVAContCast; 
		
		
		if( total > 0 ){
		
			if(totalCont > 0 ){
				$('#porcentajeCreditoRec').val('0');
				$('#porcentajeCreditoRecCont').val('0');
				habilitaControl('porcentajeCreditoRec');
				habilitaControl('porcentajeCreditoRecCont');
			}else{
				$('#porcentajeCreditoRec').val('100');
				$('#porcentajeCreditoRecCont').val('0');
				deshabilitaControl('porcentajeCreditoRec');
				deshabilitaControl('porcentajeCreditoRecCont');
			}
		}else{
			if(totalCont > 0 ){
				$('#porcentajeCreditoRec').val('0');
				$('#porcentajeCreditoRecCont').val('100');
				deshabilitaControl('porcentajeCreditoRec');
				deshabilitaControl('porcentajeCreditoRecCont');
			}else{
				$('#porcentajeCreditoRec').val('0');
				$('#porcentajeCreditoRecCont').val('0');
				$('#monRecuperado').val('0');
				deshabilitaControl('porcentajeCreditoRec');
				deshabilitaControl('porcentajeCreditoRecCont');
				deshabilitaControl('monRecuperado');
				mensajeSis('El Crédito No tiene Saldo Pendiente Por Recuperar');
			}
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
			cuentasAhoServicio.consultaCuentasAho(conCta,CuentaAhoBeanCon,function(cuenta) {
				if(cuenta!=null){                 	               		
					$('#saldoCta').val(cuenta.saldoDispon);            
				}else{
					mensajeSis("No Existe la Cuenta de Ahorro.");
				}
			});                                                                                                                        
		}        
	}	
	function funcionExitoPago(){
		imprimeTicketPago();
		inicializaForma('formaGenerica','creditoAgro');
		consultaMotivosCastigo();
	}

	function funcionFalloPago(){
	}

	function imprimeTicketPago(){
		var tituloOperacion='RECUPERACIÓN DE CRÉDITO CASTIGADO CON CARGO A CUENTA';
	
		var productoCredito=$('#productoCreditoAgro').val()+"   "+$('#desProducAgro').val();	
		window.open('RepTicketPagoCreditoAgroCast.htm?fechaSistemaP='+fechaSistemaTicket+
			'&monto='+$('#monRecuperado').val()+'&nombreInstitucion='+parametroBean.nombreInstitucion+'&numeroSucursal='+
			parametroBean.sucursal+'&nombreSucursal='+ parametroBean.nombreSucursal+'&varCreditoID='+$('#creditoAgro').val()+
			'&numCopias='+1+'&varFormaPago='+"Cargo a Cuenta"+'&numTrans='+$('#numeroTransaccion').val()+
			'&moneda='+$('#desMonedaCartAgro').val()+'&productoCred='+productoCredito+'&tituloOperacion='+tituloOperacion+
			'&edoMunSucursal='+parametroBean.edoMunSucursal+'&clienteID='+$('#clienteID').val()+'&nombreCliente='+$('#nombreCliente').val()+
			'&usuarioID='+parametroBean.numeroUsuario+'&nomUsuario='+parametroBean.nombreUsuario, '_blank');		
	}
	// consulta y rellena el combo de motivos de castigo
	function consultaMotivosCastigo() {	
		dwr.util.removeAllOptions('motivoCastigo'); 
		dwr.util.addOptions('motivoCastigo', {'':'Selecciona'}); 
	castigosCarteraServicio.listaCombo(1, function(motivosCastigo){
	dwr.util.addOptions('motivoCastigo', motivosCastigo, 'motivoCastigoID', 'descricpion');
		});
	}	

