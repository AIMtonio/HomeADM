$(document).ready(function() {
	esTab = false;
	$('#creditoID').focus();
	//Definicion de Constantes, Variables  y Enums
	var catTipoTransaccionCre = {
  		'condonar'	:'2',
	};
	var parametroBean = consultaParametrosSession();
	var divCajaLista = $('#cajaLista');
	var puestoUsuarioSesion = "";
	var numeroSucursal = "";
	var usuarioSesion = "";
	var fechaSistema ="";
	var nombreSucursal = ""; 
	var existeMontoCondonar = "2";
	var porcentaje = "0";
	var atiendeSucursal = "N";
	var diferenteSucursal= "2";
	var montoDeuda=false;
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	consultarParametrosBean();
	inicializarCampos();
	
	$(':text').focus(function() {	
	 	esTab = false;
	});

	$.validator.setDefaults({
      submitHandler: function(event) {
    	  validarMontosCondonar();
    	  if(existeMontoCondonar == "1"){
    		   grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','creditoID','funcionExito', 'funcionError');
    	  }else{
    	  }
      }
   });				

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	
	$('#creditoID').blur(function(){
		if(esTab){
			consultarParametrosBean();		
			if (!divCajaLista.is(':visible')){
				consultaCredito(this.id);	
			}else{
				if($('#creditoID').val() != '' && !isNaN($('#creditoID').val())){
					consultaCredito(this.id);
				}
				if($('#creditoID').val() != '' && isNaN($('#creditoID').val())|| $('#creditoID').val() == '' ){
					setTimeout("$('#cajaLista').hide();", 200);
					inicializaForma('formaGenerica','creditoID');
					$('#creditoID').focus();
					$('#creditoID').select();	
					inicializarCampos();
				}
			}	
		}

	});		
		
	$('#creditoID').bind('keyup', function(e){
		lista('creditoID', '1', '49', 'creditoID', $('#creditoID').val(), 'ListaCredito.htm');
	});
	
	$('#montoMoratorios').blur(function(){
		if ($('#montoMoratorios').asNumber()=='0'){
			$('#porceMoratorios').val('0.00');
		}else{
			 if($('#montoMoratorios').asNumber()>0){
			 	if($('#totalComisi').asNumber()>0 && $('#montoComisiones').asNumber() ==0 ){
			 		mensajeSisRetro({
						mensajeAlert : 'De acuerdo a la Prelación es necesario primero condonar Comisiciones y Accesorios, ¿Está seguro de continuar?',
						muestraBtnAceptar: true,
						muestraBtnCancela: true,
						txtAceptar : 'Aceptar',
						txtCancelar : 'Cancelar',
						funcionAceptar : function(){
							validarMontosMoratorio();
						},
						funcionCancelar : function(){
							$('#montoMoratorios').val("0.00");
							$('#porceMoratorios').val("0.00");
							$('#montoComisiones').focus();
							$('#montoComisiones').select();
						}
					});
				}else{
					validarMontosMoratorio();
				}
			}	
		}
	});	
	
	$('#montoInteres').blur(function(){
		if ($('#montoInteres').asNumber()=='0'){
			$('#porceInteres').val('0.00');
		}else{
		if($('#montoInteres').asNumber()>0){
			if($('#saldoMoratorios').asNumber()>0 && $('#montoMoratorios').asNumber() ==0 ){
				mensajeSisRetro({
					mensajeAlert : 'De acuerdo a la Prelación es necesario primero condonar  Moratorios, ¿Está seguro de continuar?',
					muestraBtnAceptar: true,
					muestraBtnCancela: true,
					txtAceptar : 'Aceptar',
					txtCancelar : 'Cancelar',
					funcionAceptar : function(){
						// si pulsamos en aceptar
						validarMontosInteres();
					},
					funcionCancelar : function(){// si no se pulsa en aceptar
						$('#montoInteres').val("0.00");
						$('#porceInteres').val("0.00");
						$('#montoMoratorios').focus();
						$('#montoMoratorios').select();
					}
				});
			}else{
				validarMontosInteres();
			}
		}
	  }
	});

	$('#montoCapital').blur(function(){
		if ($('#montoCapital').asNumber()=='0'){
			$('#porceCapital').val('0.00');
		}else{
		if($('#montoCapital').asNumber()>0){
			if($('#totalInteres').asNumber()>0 && $('#montoInteres').asNumber() ==0 ){
				mensajeSisRetro({
					mensajeAlert : 'De acuerdo a la Prelación es necesario primero condonar  Intéres, ¿Está seguro de continuar?',
					muestraBtnAceptar: true,
					muestraBtnCancela: true,
					txtAceptar : 'Aceptar',
					txtCancelar : 'Cancelar',
					funcionAceptar : function(){
						// si pulsamos en aceptar
						validarMontoCapital();
					},
					funcionCancelar : function(){// si no se pulsa en aceptar
						$('#montoCapital').val("0.00");
						$('#porceCapital').val("0.00");
						$('#montoInteres').focus();
						$('#montoInteres').select();
					}
				});

			}else{
				validarMontoCapital();
			}
		}
		}		
	});	
	
	//Clic a boton grabar
	$('#condonar').click(function() {
		if($('#montoMoratorios').asNumber() == '') {
			$('#montoMoratorios').val('0');
		}
		if($('#montoInteres').asNumber() == '') {
			$('#montoInteres').val('0');
		}
		if($('#montoCapital').asNumber() == '') {
			$('#montoCapital').val('0');
		}
		
		var totalCondonar = $('#montoMoratorios').asNumber() + $('#montoInteres').asNumber() + $('#montoCapital').asNumber();
		var exigible = $('#pagoExigible').asNumber();
		
		$('#tipoTransaccion').val(catTipoTransaccionCre.condonar);
	});

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			creditoID: 'required'	,

			montoMoratorios: {	number: true,
								required: true},
			porceMoratorios: {	number: true,
								required: true},

			montoInteres: {		number: true,
								required: true},
			porceInteres: {		number: true,
								required: true},

			montoCapital: {	number: true,
								required: true},
			porceCapital: {	number: true,
								required: true}																						
		},
		messages: {
			creditoID: 'Especifique Número de Crédito',

			montoMoratorios: {	number: 'Soló números',
								required: 'Indique Monto Moratorio'},
			porceMoratorios: {	number: 'Soló números',
								required: 'Indique % Moratorio'},
			
			montoInteres: {		number: 'Soló números',
								required: 'Indique Monto Intéres'},
			porceInteres: {		number: true,
								required: 'Indique % Intéres'},
			
			montoCapital: {	number: 'Soló números',
							required: 'Indique Monto Capital'},
			porceCapital: {	number: 'Soló números',
							required: 'Indique % Capital'}																						
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------
	function consultarParametrosBean() {
		parametroBean = consultaParametrosSession();
		puestoUsuarioSesion = parametroBean.clavePuestoID;
		usuarioSesion = parametroBean.numeroUsuario;
		fechaSistema = parametroBean.fechaSucursal;
		numeroSucursal = parametroBean.sucursal;
		nombreSucursal = parametroBean.nombreSucursal;
		consultaAtiendeSucursal();
		$('#usuarioID').val(usuarioSesion);
		$('#puestoID').val(puestoUsuarioSesion);
	}
	

	//** funciones para el pago de credito***
	function consultaCredito(controlID){
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito)){
			var creditoBeanCon = { 
				'creditoID':$('#creditoID').val(),
  				'fechaActual':parametroBean.fechaSucursal
  			};   			
   			creditosServicio.consulta(32,creditoBeanCon,function(credito) {
   				if(credito!=null){
   	   				if(credito.esAgropecuario == 'S'){
   	   					if(credito.estatusGarantiaFIRA == 'P'){
	   	   	   					esTab=true;	
	   	   						dwr.util.setValues(credito);
	   	   						consultarParametrosBean();
	   	   						if(atiendeSucursal == "S") {
	   	   							if(numeroSucursal != credito.sucursal){
	   	   								mensajeSis("Solo puede realizar condonaciones sobre créditos de la sucursal: "+nombreSucursal);
	   	   								deshabilitaBoton('condonar', 'submit');
	   	   								diferenteSucursal= "2"; 
	   	   							}else{
	   	   								diferenteSucursal= "1";
	   	   							}
	   	   						}else{
	   	   							diferenteSucursal= "1";
	   	   						}
	   	   						consultaCliente('clienteID');			
	   	   						consultaMoneda('monedaID');				
	   	   						consultaCta('cuentaID');
	   	   						consultaProdCred(credito.producCreditoID);
	   	   						consultaNumeroQuitas(credito.creditoID,credito.producCreditoID);
	   	   						consultaSucursal(credito.sucursal);
	   	   											
	   	   						$('#grupoID').val(credito.grupoID); 
	   	   						if(credito.grupoID > 0){
	   	   							$('#cicloID').val(credito.cicloGrupo);
	   	   							consultaGrupo(credito.grupoID,'grupoID','grupoDes','cicloID');
	   	   							$('#tdInputExiGrup').show();
	   	   							$('#tdLabelExiGrup').show();
	   	   		   					consultaGrupoTotalExigible();
	   	   		   					$('#tdGrupoCicloCredlabel').show();
	   	   		   					$('#tdGrupoCicloCredinput').show();
	   	   		   					$('#tdGrupoGrupoCredinput').show();
	   	   		   					$('#tdGrupoGrupoCredDesinput').show();
	   	   		   					$('#tdGrupoGrupoCredlabel').show();
	   	   						}
	   	   						else{
	   	   		   					$('#tdGrupoGrupoCredinput').hide();
	   	   		   					$('#tdGrupoGrupoCredDesinput').hide();
	   	   		   					$('#tdGrupoGrupoCredlabel').hide();
	   	   		   					$('#tdGrupoCicloCredlabel').hide();
	   	   		   					$('#tdGrupoCicloCredinput').hide();
	   	   							$('#tdInputExiGrup').hide();
	   	   							$('#tdLabelExiGrup').hide();
	   	   							$('#grupoID').val("");  
	   	   							$('#grupoDes').val("");
	   	   						}
	   	   						var estatus = credito.estatus;
	   	   						validaEstatusCredito(estatus);
	   	   						consultaExigible();
   	   					}else{
	   	   					mensajeSis("El Crédito " + credito.creditoID + " No es Contingente.<br>Favor de consultarla en " + "<b><a onclick=\"$('#Contenedor').load('creQuitasAgroVista.htm',function(response, status, xhr){" + "if(status == 'error') {$('#Contenedor').html(response);}});consultaSesion();\">Quitas y Condonaciones Agro. <img src=\"images/external.png\"></a></b>");
	   						inicializaForma('formaGenerica','creditoID');
							inicializarCampos();
							deshabilitarMontos();
	   						$('#creditoID').focus();
	   						$('#creditoID').val('0');	
   	   					}

   					}else{
   						mensajeSis("El Crédito " + credito.creditoID + " No es Agropecuario.<br>Favor de consultarla en " + "<b><a onclick=\"$('#Contenedor').load('creQuitasVista.htm',function(response, status, xhr){" + "if(status == 'error') {$('#Contenedor').html(response);}});consultaSesion();\"> Cartera. <img src=\"images/external.png\"></a></b>");
   						inicializaForma('formaGenerica','creditoID');
						inicializarCampos();
						deshabilitarMontos();
   						$('#creditoID').focus();
   						$('#creditoID').val('0');	
   					}
   				}else{
   					inicializaForma('formaGenerica','creditoID');
   					mensajeSis("No Existe el Crédito");
   					deshabilitaBoton('condonar', 'submit');
   					$('#creditoID').focus();
   					$('#creditoID').select();	
   					inicializarCampos();
   					deshabilitarMontos();
   				}
			});
		}else{
			inicializaForma('formaGenerica','creditoID');
			deshabilitaBoton('condonar', 'submit');
			inicializarCampos();
		}
	}
	
	function consultaExigible(){
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito)){
			var Con_PagoCred = 46;
			var creditoBeanCon = { 
				'creditoID':$('#creditoID').val(),
  				'fechaActual':fechaSistema
  			};
  			creditosServicio.consulta(Con_PagoCred,creditoBeanCon,function(credito) {
  				if(credito!=null){ 
					$('#saldoCapVigent').val(credito.saldoCapVigent);  
					$('#saldoCapAtrasad').val(credito.saldoCapAtrasad);  
					$('#saldoCapVencido').val(credito.saldoCapVencido);
					$('#saldCapVenNoExi').val(credito.saldCapVenNoExi);    
					$('#totalCapital').val(credito.totalCapital);  
					$('#saldoInterOrdin').val(credito.saldoInterOrdin);
					$('#saldoInterAtras').val(credito.saldoInterAtras);
					$('#saldoInterAtras').val(credito.saldoInterAtras);
					$('#saldoInterVenc').val(credito.saldoInterVenc);
					$('#saldoInterProvi').val(credito.saldoInterProvi);
					$('#saldoIntNoConta').val(credito.saldoIntNoConta);
					$('#totalInteres').val(credito.totalInteres);
					$('#saldoIVAInteres').val(credito.saldoIVAInteres);
					$('#saldoMoratorios').val(credito.saldoMoratorios);
					$('#saldoIVAMorator').val(credito.saldoIVAMorator);
					$('#saldoComFaltPago').val(credito.saldoComFaltPago);
					$('#saldoOtrasComis').val(credito.saldoOtrasComis);
					$('#totalComisi').val(credito.totalComisi);  
					$('#salIVAComFalPag').val(credito.salIVAComFalPag);
					$('#saldoIVAComisi').val(credito.saldoIVAComisi);
					//SEGUROS
					$('#saldoSeguroCuota').val(credito.saldoSeguroCuota);
					$('#saldoIVASeguroCuota').val(credito.saldoIVASeguroCuota);
					//FIN SEGUROS
					//COMISION ANUAL
					$('#saldoComAnual').val(credito.saldoComAnual);
					$('#saldoComAnualIVA').val(credito.saldoComAnualIVA);
					//FIN COMISION ANUAL
					$('#totalIVACom').val(credito.totalIVACom); 
					var totalAdeudoVencido = $('#saldoCapAtrasad').asNumber() + $('#saldoCapVencido').asNumber() + $('#saldCapVenNoExi').asNumber()+$('#saldoInterAtras').asNumber()+$('#saldoInterVenc').asNumber()+$('#saldoMoratorios').asNumber()+$('#totalComisi').asNumber(); // 
					var totalprovisionado = $('#saldoInterProvi').asNumber() ; 
					var estatusCredito =  $('#estatus').val();
					if(estatusCredito == 'VIGENTE' && totalprovisionado > 0 && totalAdeudoVencido == 0){
						habilitarMontos();
						habilitaBoton('condonar', 'submit');
						montoDeuda=true;
					}else{
						montoDeuda=true;
					}
					
					consultaAdeudoTotal();
					agregaFormatoControles('formaGenerica');
  				}else{
  					deshabilitaBoton('condonar', 'submit');
  					$('#montoTotExigible').val("0.00");
  					$('#pagoExigible').val("0.00");
  					$('#saldoCapVigent').val("0.00");
  					$('#saldoCapAtrasad').val("0.00");
  					$('#saldoCapVencido').val("0.00");
  					$('#saldCapVenNoExi').val("0.00");
  					$('#totalCapital').val("0.00");
  					$('#saldoInterOrdin').val("0.00");
  					$('#saldoInterAtras').val("0.00");
  					$('#saldoInterVenc').val("0.00");
  					$('#saldoInterProvi').val("0.00");
  					$('#saldoIntNoConta').val("0.00");
  					$('#totalInteres').val("0.00");
  					$('#saldoIVAInteres').val("0.00");
  					$('#saldoMoratorios').val("0.00");
  					$('#saldoIVAMorator').val("0.00");
  					$('#saldoComFaltPago').val("0.00");
  					$('#saldoOtrasComis').val("0.00");
  					//SEGUROS
  					$('#saldoSeguroCuota').val("0.00");
  					$('#saldoIVASeguroCuota').val("0.00");
  					//FIN SEGUROS
  					//COMISION ANUAL
					$('#saldoComAnual').val("0.00");
					$('#saldoComAnualIVA').val("0.00");
					//FIN COMISION ANUAL
  					$('#totalComisi').val("0.00");
  					$('#salIVAComFalPag').val("0.00");
  					$('#saldoIVAComisi').val("0.00");
  					$('#totalIVACom').val("0.00");  					
  				}
  			});
		}
	}
	
	function consultaCliente(idControl) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var tipConPagoCred = 8;	 
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente != '' && !isNaN(numCliente) ){
			clienteServicio.consulta(tipConPagoCred,numCliente,function(cliente) {
				if(cliente!=null){	
					$('#clienteID').val(cliente.numero);					
					$('#nombreCliente').val(cliente.nombreCompleto);
					if(cliente.pagaIVA == 'S'){
						$('#pagaIVA').val("Si");
					}else{
						$('#pagaIVA').val("No");
					}	
					
				}else{
					mensajeSis("No Existe el Cliente");
					$('#clienteID').focus();
					$('#clienteID').select();	
				}    	 						
			});
		}
	}

	function consultaAdeudoTotal(){
		var numCredito = $('#creditoID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito) ){
			var Con_PagoCred = 44;
			var creditoBeanCon = { 
					'creditoID':$('#creditoID').val(),
					'fechaActual':fechaSistema
					};
			creditosServicio.consulta(Con_PagoCred,creditoBeanCon,function(credito) {
				if(credito!=null){
					$('#adeudoTotal').val(credito.adeudoTotal);	
				}
			});

			Con_PagoCred = 45;
			creditosServicio.consulta(Con_PagoCred,creditoBeanCon,function(credito) {
				if(credito!=null){
					$('#pagoExigible').val(credito.totalExigibleDia);	
					$('#pagoExigible').formatCurrency({
						positiveFormat : '%n',
						roundToDecimalPlace : 2
					});
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
	
	function consultaSucursal(idControl) {
		var numSucursal = idControl;	
		var conSucursal=2;
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numSucursal != '' && !isNaN(numSucursal)){
			sucursalesServicio.consultaSucursal(conSucursal,numSucursal,function(sucursal) {
				if(sucursal!=null){	
					$('#sucursal').val(sucursal.sucursalID);		
					$('#nombreSucursal').val(sucursal.nombreSucurs);
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
			deshabilitaBoton('condonar', 'submit');
			deshabilitarMontos();
			mensajeSis('El Crédito se encuentra INACTIVO');
		}	
		if(var_estatus == estatusAutorizado){
			$('#estatus').val('AUTORIZADO');
			deshabilitaBoton('condonar', 'submit');
			deshabilitarMontos();
			mensajeSis('Aún no es posible condonar el Crédito');
		}
		if(var_estatus == estatusVigente){
			$('#estatus').val('VIGENTE');
			if(diferenteSucursal== "1"){
				habilitarMontos();
				habilitaBoton('condonar', 'submit');
			}else{
				deshabilitaBoton('condonar', 'submit');
			}
		}
		if(var_estatus == estatusPagado){
			$('#estatus').val('PAGADO');
			deshabilitaBoton('condonar', 'submit');
			deshabilitarMontos();
			mensajeSis('El Crédito se encuentra PAGADO');
		}
		if(var_estatus == estatusCancelada){
			$('#estatus').val('CANCELADO');
			deshabilitaBoton('condonar', 'submit');
			deshabilitarMontos();
			mensajeSis('El Crédito se encuentra  CANCELADO');
		}
		if(var_estatus == estatusVencido){
			$('#estatus').val('VENCIDO');
			if(diferenteSucursal== "1"){
				habilitarMontos();
				habilitaBoton('condonar', 'submit');
			}else{
				deshabilitaBoton('condonar', 'submit');
			}
		}
		if(var_estatus == estatusCastigado){
			$('#estatus').val('CASTIGADO');
			deshabilitaBoton('condonar', 'submit');
			deshabilitarMontos();
			mensajeSis('El Crédito se encuentra  CASTIGADO');
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
        	cuentasAhoServicio.consultaCuentasAho(conCta, CuentaAhoBeanCon,function(cuenta) {
        		if(cuenta!=null){ 
        			$('#saldoCta').val(cuenta.saldoDispon);
        		}else{
        			mensajeSis("No Existe la Cuenta de Ahorro");
        		}
        	});                                                                                                                        
        }
	}

	// Consulta de grupos Total Exigible
	function consultaGrupoTotalExigible() {
		var numGrupo = $('#grupoID').val();	
		var tipConTotalExigible= 9;
		var grupoBean = {
			'grupoID'	:numGrupo,
			'cicloActual':$('#cicloID').val() 
		};
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numGrupo != '' && !isNaN(numGrupo)){
			gruposCreditoServicio.consulta(tipConTotalExigible, grupoBean,function(grupoDeudaTotalExi) {
				if(grupoDeudaTotalExi!=null){	
					$('#montoTotExigible').val(grupoDeudaTotalExi.montoTotDeuda);																
				}
			});															
		}
	}

	// Consulta de grupos 
	function consultaGrupo(valID, id, desGrupo,idCiclo) { 
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
	
	// funcion para consultar la descripcion del producto de credito
	function consultaProdCred(idControl) {
		var numProdCre = idControl;	
		var conTipoCta=2;
		var ProdCredBeanCon = {
  			'producCreditoID':numProdCre
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(numProdCre != '' && !isNaN(numProdCre)){
			productosCreditoServicio.consulta(conTipoCta, ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){			
					$('#productoCredDes').val(prodCred.descripcion);
				}else{
					$('#creditoIDAR').focus();
				}    						
			});
		}
	}
	
	//Funcion para consultar el numero de quitas que lleva el credito indicado
	function consultaNumeroQuitas(numCredito,numProd) {
		var creQuitasBean = {
				'creditoID'	:numCredito,
				'usuarioID'	:usuarioSesion,
				'puestoID'	:puestoUsuarioSesion					
			};
		var conQuitasCre=2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numCredito != '' && !isNaN(numCredito)){
			creQuitasServicio.consulta(conQuitasCre,creQuitasBean,function(creQuitas) {
				if(creQuitas!=null){							
					$('#noQuitasPrevias').val(creQuitas.numQuitasCredito);										
					consultaLimitesCondonacion(numProd, creQuitas.numQuitasCredito); // se consulta el limite de condonacion que tiene el usuario
				}else{
					$('#noQuitasPrevias').val("0");
					consultaLimitesCondonacion(numProd, 0); // se consulta el limite de condonacion que tiene el usuario
				}
			});
		}
	}

	//Funcion para consultar los limites establecidos para el usuario.
	function consultaLimitesCondonacion(numProductoCredito, numQuitaLleva) {
		var creLimQuitasBean = {
				'producCreditoID'	:numProductoCredito,
				'clavePuestoID'		:puestoUsuarioSesion	
			};
		var conLimQuitasCre=2;
		setTimeout("$('#cajaLista').hide();", 200);
		if(numProductoCredito != '' && !isNaN(numProductoCredito)){
			creLimiteQuitasServicio.consulta(conLimQuitasCre,creLimQuitasBean,function(creLimiteQuitas) {
				if(creLimiteQuitas!=null){			
					$('#montoMoratoriosPer').val(creLimiteQuitas.limMontoMorato);
					$('#porceMoratoriosPer').val(creLimiteQuitas.limPorcenMorato);
					$('#montoInteresPer').val(creLimiteQuitas.limMontoIntere);
					$('#porceInteresPer').val(creLimiteQuitas.limPorcenIntere);
					$('#montoCapitalPer').val(creLimiteQuitas.limMontoCap);
					$('#porceCapitalPer').val(creLimiteQuitas.limPorcenCap);
					$('#numMaxCondona').val(creLimiteQuitas.numMaxCondona);
					agregaFormatoControles('formaGenerica');
					if(parseFloat(numQuitaLleva)>=parseFloat(creLimiteQuitas.numMaxCondona)){
						mensajeSis("El Crédito, ya recibio el máximo número de \ncondonaciones de acuerdo a los limites.");
						deshabilitaBoton('condonar', 'submit');
						$('#creditoID').focus();
					}
				}else{
					mensajeSis("El usuario no tiene asignados \nlimites de condonación.");
					deshabilitaBoton('condonar', 'submit');
					$('#creditoID').focus();
				}
			});
		}
		$('#montoMoratorios').val("0.00");
		$('#montoInteres').val("0.00");
		$('#montoCapital').val("0.00");

		$('#porceMoratorios').val("0.00");
		$('#porceInteres').val("0.00");
		$('#porceCapital').val("0.00");
	}
	
	//Funcion para consultar si el usuario tiene atributo "atiende Sucursal"
	function consultaAtiendeSucursal() {
		var puestoBeanCon = {
			'clavePuestoID' : puestoUsuarioSesion
		};
		var conPuestoPrin=1;
		setTimeout("$('#cajaLista').hide();", 200);
		puestosServicio.consulta(conPuestoPrin,puestoBeanCon, function(puestos) {
			if (puestos != null) {
				//si el usuario tiene el atributo atiende sucursal
				if(puestos.atiendeSuc == 'S') {
					atiendeSucursal = "S";	
				}else{
					atiendeSucursal = "N";
				}
			}else{
				atiendeSucursal = "N";
			} 
		});
	}
	
	function validarMontosCondonar() {
		// se compara si existe capital a condonar
		if($('#adeudoTotal').asNumber() ==0){
			mensajeSis("No hay montos a condonar");
			deshabilitaBoton('condonar', 'submit');
			existeMontoCondonar = 2;
		}else{
			if(  	$('#montoMoratorios').asNumber()>0 ||
					$('#montoInteres').asNumber()>0 ||
					$('#montoCapital').asNumber()>0 ){
				existeMontoCondonar = 1;
			}else{
				mensajeSis("Debe de indicar al menos un concepto  con monto a condonar");
			}
		}
	}
	
	function inicializarCampos() {
		$('#creditoID').val("");
		$('#grupoID').val("");
		$('#cicloID').val("");
		$('#clienteID').val("");
		$('#nombreCliente').val("");
		$('#pagaIVA').val("");
		$('#cuentaID').val("");
		$('#nomCuenta').val("");
		
		$('#saldoCta').val("");
		$('#monedaID').val("");
		$('#monedaDes').val("");
		$('#estatus').val("");
		$('#diasFaltaPago').val("");
		$('#noQuitasPrevias').val("");
		$('#productoCredDes').val("");
		$('#producCreditoID').val("");
		
		$('#grupoDes').val("");
		$('#montoTotExigible').val("0.00");
		$('#pagoExigible').val("0.00");
		$('#saldoCapVigent').val("0.00");
		$('#saldoCapAtrasad').val("0.00");
		$('#saldoCapVencido').val("0.00");
		$('#saldCapVenNoExi').val("0.00");
		$('#totalCapital').val("0.00");
		$('#saldoInterOrdin').val("0.00");
		$('#saldoInterAtras').val("0.00");
		$('#saldoInterVenc').val("0.00");
		$('#saldoInterProvi').val("0.00");
		$('#saldoIntNoConta').val("0.00");
		$('#totalInteres').val("0.00");
		$('#saldoIVAInteres').val("0.00");
		$('#saldoMoratorios').val("0.00");
		$('#saldoIVAMorator').val("0.00");
		$('#saldoComFaltPago').val("0.00");
		$('#saldoOtrasComis').val("0.00");
		//SEGUROS
		$('#saldoSeguroCuota').val("0.00");
		$('#saldoIVASeguroCuota').val("0.00");
		//FIN SEGUROS
		//COMISION ANUAL
		$('#saldoComAnual').val("0.00");
		$('#saldoComAnualIVA').val("0.00");
		//FIN COMISION ANUAL
		$('#totalComisi').val("0.00");
		$('#salIVAComFalPag').val("0.00");
		$('#saldoIVAComisi').val("0.00");
		$('#totalIVACom').val("0.00");
		

		$('#montoComisiones').val("0.00");
		$('#montoMoratorios').val("0.00");
		$('#montoInteres').val("0.00");
		$('#montoCapital').val("0.00");

		$('#porceMoratorios').val("0.00");
		$('#porceInteres').val("0.00");
		$('#porceCapital').val("0.00");

		$('#montoMoratoriosPer').val("0.00");
		$('#montoInteresPer').val("0.00");
		$('#montoCapitalPer').val("0.00");

		$('#porceMoratoriosPer').val("0.00");
		$('#porceInteresPer').val("0.00");
		$('#porceCapitalPer').val("0.00");

		$('#numMaxCondona').val("0");     
		
		consultarParametrosBean();
		deshabilitaBoton('condonar', 'submit');
	}
	
	function validarMontosMoratorio() {
		if($('#montoMoratorios').asNumber()>$('#saldoMoratorios').asNumber()){
			mensajeSis("El monto a condonar es mayor al \n saldo deudor");
			existeMontoCondonar = "2";
			$('#porceMoratorios').val("0.00");
			$('#montoMoratorios').val("");
			$('#montoMoratorios').focus();
		}else{
			if($('#saldoMoratorios').asNumber()>0){
				porcentaje = ($('#montoMoratorios').asNumber()/$('#saldoMoratorios').asNumber())*100;
				porcentaje = porcentaje.toFixed(4);
				$('#porceMoratorios').val(porcentaje);
				if($('#montoMoratorios').asNumber()>$('#montoMoratoriosPer').asNumber() ||
				porcentaje>$('#porceMoratoriosPer').asNumber()){
					mensajeSis("El monto a condonar es mayor a los límites establecidos.");
					$('#porceMoratorios').val("0.00");
					$('#montoMoratorios').val("");
					$('#montoMoratorios').focus();
					deshabilitaBoton('condonar', 'submit');
					existeMontoCondonar = "2";
				}else{
					$('#porceMoratorios').val(porcentaje);
					if(diferenteSucursal== "1"){
						habilitaBoton('condonar', 'submit');
					}else{
						deshabilitaBoton('condonar', 'submit');
					}
				}				
			}else{
				$('#porceMoratorios').val("0.00");
			}
		}
	}
	
	function validarMontosInteres() {
		if($('#montoInteres').asNumber()>$('#totalInteres').asNumber()){
			mensajeSis("El monto a condonar es mayor al \n saldo deudor");
			existeMontoCondonar = "2";
			$('#porceInteres').val("0.00");
			$('#montoInteres').val("");
			$('#montoInteres').focus();
		}else{
			if($('#totalInteres').asNumber()>0){
				porcentaje = ($('#montoInteres').asNumber()/$('#totalInteres').asNumber())*100;
				porcentaje = porcentaje.toFixed(4);
				$('#porceInteres').val(porcentaje);
				if($('#montoInteres').asNumber()>$('#montoInteresPer').asNumber() ||
						porcentaje>$('#porceInteresPer').asNumber()){
					mensajeSis("El monto a condonar es mayor a los límites establecidos.");
					$('#porceInteres').val("0.00");
					$('#montoInteres').val("");
					$('#montoInteres').focus();
					deshabilitaBoton('condonar', 'submit');
					existeMontoCondonar = "2";
				}else{
					$('#porceInteres').val(porcentaje);
					if(diferenteSucursal== "1"){
						habilitaBoton('condonar', 'submit');
					}else{
						deshabilitaBoton('condonar', 'submit');
					}
				}			
			}else{
				$('#porceInteres').val("0.00");
			}
		}
	}
	
	function validarMontoCapital() {
		if($('#montoCapital').asNumber()>$('#totalCapital').asNumber()){
			mensajeSis("El monto a condonar es mayor al \n saldo deudor");
			existeMontoCondonar = "2";
			$('#porceCapital').val("0.00");
			$('#montoCapital').val("");
			$('#montoCapital').select();
			$('#montoCapital').focus();
		}else{
			if($('#totalCapital').asNumber()>0){
				porcentaje = ($('#montoCapital').asNumber()/$('#totalCapital').asNumber())*100;
				porcentaje = porcentaje.toFixed(4);
				$('#porceCapital').val(porcentaje);
				if($('#montoCapital').asNumber()>$('#montoCapitalPer').asNumber() ||
						porcentaje>$('#porceCapitalPer').asNumber()){
					mensajeSis("El monto a condonar es mayor a los límites establecidos.");
					$('#porceCapital').val("0.00");
					$('#montoCapital').val("");
					$('#montoCapital').select();
					$('#montoCapital').focus();
					deshabilitaBoton('condonar', 'submit');
					existeMontoCondonar = "2";
				}else{
					$('#porceCapital').val(porcentaje);
					if(diferenteSucursal== "1"){
						habilitaBoton('condonar', 'submit');
					}else{
						deshabilitaBoton('condonar', 'submit');
					}
				}		
			}else{
				$('#porceCapital').val("0.00");
				}
			}
		}		
}); // FIN DEL DOCUMENT READY 

	//funcion para validar cuando un campo toma el foco
	function validaFocoInputMoneda(controlID){
		 jqID = eval("'#" + controlID + "'");
		 if($(jqID).asNumber()>0){
			 $(jqID).select();
		 }else{
			 $(jqID).val("");
		 }
	}
	
	function ayudaSeguroCuota(){
		var data;
		
		data = 
		'<fieldset class="ui-widget ui-widget-content ui-corner-all">'+ 
			'<div id="ContenedorAyuda">'+ 
				'<legend class="ui-widget ui-widget-header ui-corner-all">Cobro de Seguro por Cuota</legend>'+
				'<table border="0" id="tablaLista" width="100%" style="margin-top:10px">'+
					'<tr>'+
						'<td colspan="0" id="contenidoAyuda" style="padding: 5px"><b>El Seguro y el IVA Seguro no Puede ser Condonado.</b></td>'+
					'</tr>'+
				'</table>'+
			'</div>'+ 
		'</fieldset>';
		
		$('#ContenedorAyuda').html(data); 
	
		$.blockUI({
			message : $('#ContenedorAyuda'),
			css : {
				 left: '50%',	
				 top: '50%',
				 margin: '-200px 0 0 -200px',
				 border: '0',
				 'background-color': 'transparent'
			}
		});  
	   $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		      
	}
	
	function deshabilitarMontos(){
		deshabilitaControl('montoComisiones');
		deshabilitaControl('montoMoratorios');
		deshabilitaControl('montoInteres');
		deshabilitaControl('montoCapital');
	}
	
	function habilitarMontos(){
		habilitaControl('montoComisiones');
		habilitaControl('montoMoratorios');
		habilitaControl('montoInteres');
		habilitaControl('montoCapital');
	}
	
	function funcionExito(){
		inicializaForma('formaGenerica','creditoID');
		deshabilitaBoton('condonar', 'submit');
		inicializarCampos();
	}

	function funcionError(){
	}
