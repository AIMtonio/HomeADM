$(document).ready(function() {
	esTab = false;
	var continuar = false;
	var otra= false;
	
	var catTipoConsultaCta = {
  		'saldoDispon':5,
  		'saldoDisponHis':12,
  		'prinAct':15
	};

	var parametroBean = consultaParametrosSession();      
	var fechaSucursal =parametroBean.fechaSucursal;  
	var mesSucursal = fechaSucursal.substr(5,2);
	var anioSucursal = fechaSucursal.substr(0,4);
	$('#fechaSistemaMov').val(fechaSucursal);
	$('#numCliente').focus();
	
	//------------ Metodos y Manejo de Eventos -----------------------------------------

   
	agregaFormatoControles('formaGenerica');
	llenarAnio();
	validaEmpresaID();
	// se selecciona el mes actual
	$('#mes').val(mesSucursal).selected = true;
	
  	$(':text').focus(function() {	
	 	esTab = false;
	});
  	
  	inicializaForma('formaGenerica', 'numCliente');
  	$('cuentaAhoID').val("");
  	$('#gridReporteMovimientos').html("");
  	
	$.validator.setDefaults({
      submitHandler: function(event) { 
      	
      }
   });	

	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	$('#numCliente').bind('keyup',function(e){
		if(this.value.length >= 4){                  
			lista('numCliente', '2', '1', 'nombreCompleto', $('#numCliente').val(), 'listaCliente.htm');
		}	
		otra = false;
		continuar = false;
	});
		
	$('#numCliente').blur(function(){
		setTimeout("$('#cajaLista').hide();", 200);
		if(esTab){
			if($('#numCliente').val()!=""){
				consultaClientePantalla(this.id);				
				otra = false;
				continuar = false;
			}
			else{ 
				$('#nombreCliente').val("");
				$('#cuentaAhoID').val("");
				$('#mes').val(mesSucursal).selected = true;
				$('#anio').val(anioSucursal).selected = true;
				inicializaCampos();
			}
			
		}
	});
	
	$('#anio').blur(function(){
		$('#mes').focus();
		otra = false;
		continuar = false;
	});

	$('#mes').blur(function(){
		$('#cuentaAhoID').focus();
		otra = false;
		continuar = false;
	});
	
	$('#cuentaAhoID').blur(function() {
		setTimeout("$('#cajaLista').hide();", 200);
		if(esTab){
			if($('#cuentaAhoID').val()!=""){
				otra = false;
				continuar = false;
				if ($('#mes').val() == mesSucursal && $('#anio').val() == anioSucursal){
					consultaSaldoDisp(this.id);
					 $('#tipoListaMovs').val('1');
				}else{
					consultaSaldoDispHis(this.id); 
					 $('#tipoListaMovs').val('2');
				}
			}else{
				$('#cuentaAhoID').focus();
				$('#cuentaAhoID').select();
				inicializaCampos();
			}			
		}			
	});
	
	$('#cuentaAhoID').bind('keyup',function(e){
		continuar = false;
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#numCliente').val();
			listaAlfanumerica('cuentaAhoID', '0', '2', camposLista, parametrosLista, 'cuentasAhoListaVista.htm');		       
	});
	
	$('#consultar').click(function() {
		if($('#cuentaAhoID').val()!=""){
			var saldoIniMes = $('#saldoIniMes').val();
			habilitaBoton('excel');
			otra= true;
			if ($('#mes').val() == mesSucursal && $('#anio').val() == anioSucursal){
				
				consultaSaldoDisp('cuentaAhoID');
				 $('#tipoListaMovs').val('1');
			}else{
				
				consultaSaldoDispHis('cuentaAhoID'); 
				 $('#tipoListaMovs').val('2');
			}
			continuar = true;
		}else{
			mensajeSis("Especifique Cuenta ");
			$('#cuentaAhoID').focus();
		}	
	});	
	
	$('#imprimir').click(function() {
		tipoReporte = 2;
		if($('#cuentaAhoID').val()!=""){
			otra = false;
			continuar = true;
			if ($('#mes').val() == mesSucursal && $('#anio').val() == anioSucursal){
				
				consultaSaldoDisp('cuentaAhoID');
				 $('#tipoListaMovs').val('1');
			}else{
				
				consultaSaldoDispHis('cuentaAhoID'); 
				 $('#tipoListaMovs').val('2');
			}
		}	else{
			mensajeSis("Especifique Cuenta ");
			$('#enlace').removeAttr('href');
		}		
	});

	$('#excel').click(function() {
		generaExcel();
	});
	
	$('#salBloq').click(function() {
		pegaHtml($('#cuentaAhoID').val(),$('#saldoBloq').val());  	 
	});
	
	$('#cargosPendientesBtn').click(function() {
		gridCargosPendientes($('#cuentaAhoID').val(),$('#numCliente').val());  	 
	});
	
	$('#numeroTarjeta').bind('keypress', function(e){
		return validaAlfanumerico(e,this);		
	});
	$('#numeroTarjeta').blur(function(e){
		var longitudTarjeta=$('#numeroTarjeta').val().length; 
		if (longitudTarjeta<16){
			$('#numeroTarjeta').val("");
		}else{
			consultaClienteIDTarDeb('numeroTarjeta');	
		}
	});
	
	//------------ Validaciones de la Forma -------------------------------------
	
	$('#formaGenerica').validate({
		rules: {
			numCliente: 'required',
			cuentaAhoID: 'required'			
		},
		
		messages: {
			numCliente: 'Especifique Número de Cliente',
			cuentaAhoID: 'Especifique la Cuenta de Ahorro'	
		}		
	});
	
	
	//------------ Validaciones de Controles -------------------------------------
	
	//Función para poder ingresar solo números o letras 
	function validaAlfanumerico(e,elemento){//Recibe al evento 
		var key;
		if(window.event){//Internet Explorer ,Chromium,Chrome
			key = e.keyCode; 
		}else if(e.which){//Firefox , Opera Netscape
				key = e.which;
		}
		 if (key > 31 && (key < 48 ||  key > 57) && (key <65 || key >90) && (key<97 || key >122)) //Comparación con código ascii
		    return false;
		 var longitudTarjeta=$('#numeroTarjeta').val().length;		 	
		 		if (longitudTarjeta == 16 ){
					consultaClienteIDTarDeb('numeroTarjeta');							
				}	
		 return true;	
		 
		 
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
                	consultaCtaAho('cuentaAhoID',cliente);
                	consultaSaldos('cuentaAhoID');
					$('#cuentaAhoID').focus();
                	consultaCtaAho('cuentaAhoID',cliente);
                	$('#salBloq').show();
					$('#cargosPendientesBtn').show();
                	if ($('#mes').val() == mesSucursal && $('#anio').val() == anioSucursal){
        				
        				consultaSaldoDisp('cuentaAhoID');
        				 $('#tipoListaMovs').val('1');
        			}else{
        				
        				consultaSaldoDispHis('cuentaAhoID'); 
        				 $('#tipoListaMovs').val('2');
        			}
				}
				else{
					$('#tipoCuenta').val("");
					$('#saldoDispon').val("0.00");
		        	$('#gat').val("0.00");
		        	$('#valorGatReal').val("0.00");
                	$('#saldoProm').val("0.00");
	          		$('#moneda').val("");
	          		$('#saldoIniMes').val("0.00");
	          		$('#cargosMes').val("0.00");
	          		$('#abonosMes').val("0.00");
	          		$('#cargosDia').val("0.00");
	          		$('#abonosDia').val("0.00");
            		$('#cargosPendientes').val("0.00");      
	          		$('#saldo').val("0.00");  
	          		$('#saldoSBC').val("0.00");  
	          		$('#saldoBloq').val("0.00");               		
					$('#gridReporteMovimientos').hide();   
					$('#salBloq').hide();
					$('#cargosPendientesBtn').hide();
				}
			});                                                                                                                        
		}
	}
	
	function consultaSaldoDisp(control) {
		var jqnumCta = eval("'#" + control + "'");
		var	numCta = $(jqnumCta).val();  
		var cliente =  $('#numCliente').val();
		$('#gridReporteMovimientos').hide();     
		var CuentaAhoBeanCon = {
                'cuentaAhoID':numCta,
                'clienteID':cliente
		};
		setTimeout("$('#cajaLista').hide();", 200);    
		if(numCta != '' && !isNaN(numCta)){
			cuentasAhoServicio.consultaCuentasAho(catTipoConsultaCta.saldoDispon, CuentaAhoBeanCon, function(cuenta) {
				if(cuenta!=null){
					if(cliente!=''){
						if (cuenta.clienteID==cliente){
							habilitaBoton('imprimir');
							$('#saldoDispon').val(cuenta.saldoDispon);
	                		$('#saldo').val(cuenta.saldo);
	                		$('#saldoSBC').val(cuenta.saldoSBC);
	                		$('#saldoBloq').val(cuenta.saldoBloq);
	                		$('#cargosPendientes').val(cuenta.sumCanPenAct);
	                    	$('#moneda').val(cuenta.descripcionMoneda);
	                    	$('#gat').val(cuenta.gat);
	                    	$('#saldoProm').val(cuenta.saldoProm);
	                    	$('#valorGatReal').val(cuenta.valorGatReal);
	                    	consultaCtaAho('cuentaAhoID',cliente);
	                    	consultaSaldos('cuentaAhoID');
	                    	$('#consultar').focus();
	                    	$('#salBloq').show();
							$('#cargosPendientesBtn').hide();
	                    	if(otra==true){ 
	                			consultar();
	                		}
	                    	if(continuar==true){ 
	                			imprimir();
	                		}
						}
						else{
							mensajeSis("Cuenta no asociada al Cliente...");
			          		$('#saldoDispon').val("");
			            	$('#gat').val("");
				        	$('#valorGatReal').val("");
	                    	$('#saldoProm').val("");
			          		$('#cuentaAhoID').val("");
			          		$('#moneda').val("");
			          		$('#cuentaAhoID').focus();
			          		$('#tipoCuenta').val("");
			          		$('#saldoIniMes').val("");
			          		$('#cargosMes').val("");
			          		$('#abonosMes').val("");
			          		$('#cargosDia').val("");
			          		$('#abonosDia').val("");    
			           		$('#cargosPendientes').val("");   
			          		$('#saldo').val("");  
			          		$('#saldoSBC').val("");  
			          		$('#saldoBloq').val("");               		
							$('#gridReporteMovimientos').hide();
							$('#salBloq').hide();
							$('#cargosPendientesBtn').hide();
							deshabilitaBoton('imprimir');
						}   
					}
					else{
						habilitaBoton('imprimir');
						$('#saldoDispon').val(cuenta.saldoDispon);
			        	$('#gat').val(cuenta.gat);
			        	$('#valorGatReal').val(cuenta.valorGatReal);
                    	$('#saldoProm').val(cuenta.saldoProm);
                		$('#saldo').val(cuenta.saldo);
                		$('#saldoSBC').val(cuenta.saldoSBC);
                		$('#saldoBloq').val(cuenta.saldoBloq);
                		$('#cargosPendientes').val(cuenta.sumCanPenAct);
                    	$('#moneda').val(cuenta.descripcionMoneda);
                    	$('#numCliente').val(cuenta.clienteID);
                    	consultaClientePantalla('numCliente');
                    	consultaCtaAho('cuentaAhoID',cliente);
                    	consultaSaldos('cuentaAhoID');
                    	$('#consultar').focus();
                    	if(otra==true){ 
                			consultar();
                		}
                    	if(continuar==true){ 
                			imprimir();
                		}
					}
				}
				else{
					habilitaBoton('imprimir');
					consultaCtaAho('cuentaAhoID',cliente);
					inicializaCampos();    
					if(otra==true){ 
            			consultar();
            		}
					if(continuar==true){ 
            			imprimir();
            		}
				}
			});                                                                                                                        
		}else{
			if(isNaN(numCta)){
				$('#cuentaAhoID').focus();
				$('#cuentaAhoID').select();
				mensajeSis("No Existe la cuenta de ahorro");
				inicializaCampos();
			}
		}
	}
	
	function consultaSaldoDispHis(control) {
		$('#gridReporteMovimientos').hide();     
		var jqnumCta = eval("'#" + control + "'");
		var	numCta = $(jqnumCta).val();  
		var cliente =  $('#numCliente').val();
		var CuentaAhoBeanCon = {
	                'cuentaAhoID':numCta,
	                'clienteID':cliente,
	        		'mes' :$('#mes').val(),
	                'anio' :$('#anio').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);    
		if(numCta != '' && !isNaN(numCta)){
			cuentasAhoServicio.consultaCuentasAho(catTipoConsultaCta.saldoDisponHis, CuentaAhoBeanCon, function(cuenta) {
				if(cuenta!=null){
					if(cliente!=''){
						if (cuenta.clienteID==cliente){ 
							$('#saldoDispon').val(cuenta.saldoDispon);
							$('#saldo').val(cuenta.saldo);
							$('#saldoSBC').val(cuenta.saldoSBC);
							$('#saldoBloq').val(cuenta.saldoBloq);
							$('#moneda').val(cuenta.descripcionMoneda);
	                		$('#cargosPendientes').val(cuenta.sumCanPenAct);
	                    	$('#gat').val(cuenta.gat);
	                    	$('#saldoProm').val(cuenta.saldoProm);
	                    	$('#valorGatReal').val(cuenta.valorGatReal);
							consultaCtaAho('cuentaAhoID',cliente );
							consultaSaldosHis('cuentaAhoID');
							$('#consultar').focus();
							$('#salBloq').show();
							$('#cargosPendientesBtn').show();
							habilitaBoton('imprimir');
							if(otra==true){ 
	                			consultar();
	                		}
							if(continuar==true){ 
	                			imprimir();
	                		}
						}
						else{
							mensajeSis("Cuenta no asociada al Cliente...");
							$('#saldoDispon').val("");
				        	$('#gat').val("");
				        	$('#valorGatReal').val("");
	                    	$('#saldoProm').val("");
							$('#cuentaAhoID').val("");
							$('#moneda').val("");
							$('#cuentaAhoID').focus();
							$('#tipoCuenta').val("");
							$('#saldoIniMes').val("");
							$('#cargosMes').val("");
							$('#abonosMes').val("");
							$('#cargosDia').val("");
							$('#abonosDia').val("");     
	                		$('#cargosPendientes').val("");
							$('#saldo').val("");  
							$('#saldoSBC').val("");  
							$('#saldoBloq').val("");                   		
							$('#gridReporteMovimientos').hide();   
							$('#salBloq').hide(); 
							$('#cargosPendientesBtn').hide();
							deshabilitaBoton('imprimir');
							
						}   
					}
					else{
						habilitaBoton('imprimir');
						$('#saldoDispon').val(cuenta.saldoDispon);
			        	$('#gat').val(cuenta.gat);
			        	$('#valorGatReal').val(cuenta.valorGatReal);
                    	$('#saldoProm').val(cuenta.saldoProm);
                		$('#saldo').val(cuenta.saldo);
                		$('#saldoSBC').val(cuenta.saldoSBC);
                		$('#saldoBloq').val(cuenta.saldoBloq);
                		$('#cargosPendientes').val(cuenta.sumCanPenAct);
                    	$('#moneda').val(cuenta.descripcionMoneda);
                    	$('#numCliente').val(cuenta.clienteID);
                    	consultaClientePantalla('numCliente');
                    	consultaCtaAho('cuentaAhoID',cliente);
                    	consultaSaldos('cuentaAhoID');
                    	$('#consultar').focus();
                    	if(otra==true){ 
                			consultar();
                		}
                    	if(continuar==true){ 
                			imprimir();
                		}
					}
				}
				else{
					habilitaBoton('imprimir');
					consultaCtaAho('cuentaAhoID',cliente);
					inicializaCampos();    
					if(otra==true){ 
            			consultar();
            		}
					if(continuar==true){ 
            			imprimir();
            		}
				}
			});                                                                                                                        
		}else{
			if(isNaN(numCta)){
				$('#cuentaAhoID').focus();
				$('#cuentaAhoID').select();
				mensajeSis("No Existe la cuenta de ahorro");
				inicializaCampos();
			}
		}
	}

	
	function consultar() {
		if($('#cuentaAhoID').val()==''){
			mensajeSis("Especifique un Número de Cuenta");
			$('#cuentaAhoID').focus();
		}else{
			if ($('#mes').val() == mesSucursal && $('#anio').val() == anioSucursal){
				consultaMovimientosJs();
			}else{
				consultaMovimientosJs(); 
			}
		}
	}
	
	function imprimir() {
		var tipoCon = 0;
		tipoReporte = 2;
		var nombreInstitucion =  parametroBean.nombreInstitucion;
		var nombreUsuario = parametroBean.claveUsuario;
		var fechaAc = parametroBean.fechaSucursal;
		var FechaSistema= parametroBean.fechaSucursal;
		if ($('#mes').val() == mesSucursal && $('#anio').val() == anioSucursal){
			var ctaAho = $('#cuentaAhoID').val();	 	
			var anio = $('#anio').val();	 	
			var mes = $('#mes').val();	 	 	
			tipoCon = 1;	 	
			$('#enlace').attr('href','RepMovimientosCuenta.htm?cuentaAhoID='+ctaAho+'&mes='+mes+'&anio='+anio+'&tipoConsulta='+tipoCon+
					'&tipoReporte='+tipoReporte+'&fechaActual='+fechaAc+
					'&usuario='+nombreUsuario+'&nombreInstitucion='+nombreInstitucion+'&FechaSistema='+FechaSistema);
		}else{
			var ctaAho = $('#cuentaAhoID').val();	 	
			var anio = $('#anio').val();	 	
			var mes = $('#mes').val();
			tipoCon = 2;
			
			$('#enlace').attr('href','RepMovimientosCuenta.htm?cuentaAhoID='+ctaAho+'&mes='+mes+'&anio='+anio+'&tipoConsulta='+tipoCon+
					'&tipoReporte='+tipoReporte+'&fechaActual='+fechaAc+
					'&usuario='+nombreUsuario+'&nombreInstitucion='+nombreInstitucion+'&FechaSistema='+FechaSistema);
		}
		$('#gridReporteMovimientos').show();    
	}

	function generaExcel() {
		var tipoCon = 0;
		tipoReporte = 3;
		var nombreInstitucion =  parametroBean.nombreInstitucion;
		var nombreUsuario = parametroBean.claveUsuario;
		var fechaAc = parametroBean.fechaSucursal;
		var FechaSistema= parametroBean.fechaSucursal;

		var saldoProm = $('#saldoProm').val();
	

		if ($('#mes').val() == mesSucursal && $('#anio').val() == anioSucursal){
			var ctaAho = $('#cuentaAhoID').val();	 	
			var anio = $('#anio').val();	 	
			var mes = $('#mes').val();	 	 	
			tipoCon = 1;	 	
			$('#enlaceExcel').attr('href','RepMovimientosCuenta.htm?cuentaAhoID='+ctaAho+'&mes='+mes+'&anio='+anio+'&tipoConsulta='+tipoCon+
			'&tipoReporte='+tipoReporte+'&fechaActual='+fechaAc+
			'&usuario='+nombreUsuario+'&nombreInstitucion='+nombreInstitucion+'&FechaSistema='+FechaSistema+
			'&saldoProm='+ saldoProm);
			
		}else{
			var ctaAho = $('#cuentaAhoID').val();	 	
			var anio = $('#anio').val();	 	
			var mes = $('#mes').val();
			tipoCon = 2;
			
			$('#enlaceExcel').attr('href','RepMovimientosCuenta.htm?cuentaAhoID='+ctaAho+'&mes='+mes+'&anio='+anio+'&tipoConsulta='+tipoCon+
			'&tipoReporte='+tipoReporte+'&fechaActual='+fechaAc+
			'&usuario='+nombreUsuario+'&nombreInstitucion='+nombreInstitucion+'&FechaSistema='+FechaSistema+
			'&saldoProm='+ saldoProm );
		}
		$('#gridReporteMovimientos').show();    
	}
	
	
	function consultaSaldos(control) {
		var jqnumCta = eval("'#" + control + "'");
		var	numCta = $(jqnumCta).val();  
    	var tipConCampos= 6;
     	var CuentaAhoBeanCon = {
          'cuentaAhoID':numCta,
          'clienteID':$('#numCliente').val()
     	};
     	setTimeout("$('#cajaLista').hide();", 200);
     	if(numCta != '' && !isNaN(numCta)){
	       cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon, function(cuentaSaldos) {
	       	if(cuentaSaldos!=null){
	       			$('#saldoIniMes').val(cuentaSaldos.saldoIniMes);
	           		$('#cargosMes').val(cuentaSaldos.cargosMes);
	           		$('#abonosMes').val(cuentaSaldos.abonosMes);
	           		$('#saldoIniDia').val(cuentaSaldos.saldoIniDia);
	           		$('#cargosDia').val(cuentaSaldos.cargosDia);
	           		$('#abonosDia').val(cuentaSaldos.abonosDia);
	           		$('#cargosPendientes').val(cuentaSaldos.sumCanPenAct);
	       	}
	       });                                                                                                                        
     	}
	}
	
	function consultaSaldosHis(control) {
		var jqnumCta = eval("'#" + control + "'");
		var	numCta = $(jqnumCta).val();  
    	var tipConHis= 13;
     	var CuentaAhoBeanCon = {
          'cuentaAhoID':numCta,
          'clienteID':$('#numCliente').val(),
          'mes' :$('#mes').val(),
          'anio' :$('#anio').val()
     	};
     	setTimeout("$('#cajaLista').hide();", 200);
     	if(numCta != '' && !isNaN(numCta)){
	       cuentasAhoServicio.consultaCuentasAho(tipConHis, CuentaAhoBeanCon, function(cuentaSaldos) {
	       	if(cuentaSaldos!=null){
	       			$('#saldoIniMes').val(cuentaSaldos.saldoIniMes);
	           		$('#cargosMes').val(cuentaSaldos.cargosMes);
	           		$('#abonosMes').val(cuentaSaldos.abonosMes);
	           		$('#saldoIniDia').val(cuentaSaldos.saldoIniDia);
	           		$('#cargosDia').val(cuentaSaldos.cargosDia);
	           		$('#abonosDia').val(cuentaSaldos.abonosDia);
	           		$('#cargosPendientes').val(cuentaSaldos.sumCanPenAct);
	             	$('#cargosPendientes').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
	       	}
	       });                                                                                                                        
     	}
	}
	
	function consultaCtaAho(control,cliente) {
		var numCta = $('#cuentaAhoID').val();
		var tipConCampos= 4;
		var CuentaAhoBeanCon = {
			'cuentaAhoID'	:numCta
		};
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numCta != '' && !isNaN(numCta)){
			cuentasAhoServicio.consultaCuentasAho(tipConCampos, CuentaAhoBeanCon,function(cuenta) {
						if(cuenta!=null){	
							if(cliente!=''){
								if (cuenta.clienteID==cliente){
									$('#tipoCuenta').val(cuenta.descripcionTipoCta);
									$('#cuentaAhoID').val(cuenta.cuentaAhoID);
									$('#salBloq').show();
									$('#cargosPendientesBtn').show();
									$('#ctaClabe').val(cuenta.clabe);
								
								}else{
									mensajeSis("Cuenta no asociada al Cliente...");
									$('#tipoCuenta').val("");
									$('#cuentaAhoID').focus();
									$('#cuentaAhoID').select();	
									$('#salBloq').hide();
									$('#cargosPendientesBtn').hide();
									$('#ctaClabe').val('');
									continuar = false;
								}
							}
							else{
								$('#tipoCuenta').val(cuenta.descripcionTipoCta);
								$('#cuentaAhoID').val(cuenta.cuentaAhoID);		
							}
						}else{
							mensajeSis("No Existe la cuenta de ahorro");
							$('#cuentaAhoID').focus();
							$('#cuentaAhoID').select();
							$('#cuentaAhoID').val("");
							$('#salBloq').hide();
							$('#cargosPendientesBtn').hide();
							$('#ctaClabe').val("");
						}
			});															
		}
	}
	
	
	function consultaClientePantalla(idControl) {
		var jqCliente  = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();	
		var conCliente =5;
		var rfc = ' ';
		setTimeout("$('#cajaLista').hide();", 200);		
		if(numCliente != '' && !isNaN(numCliente)){
			clienteServicio.consulta(conCliente,numCliente,rfc,function(cliente){
						if(cliente!=null){		
							$('#numCliente').val(cliente.numero);
							var tipo = (cliente.tipoPersona);
							if(tipo=="M"){
								$('#nombreCliente').val(cliente.razonSocial);
							}else{
								$('#nombreCliente').val(cliente.nombreCompleto);
							}
							
	                		$('#anio').focus();
	                		$('#saldoDispon').val("0.00");
	                    	$('#gat').val("0");
				        	$('#valorGatReal').val("0.00");
	                    	$('#saldoProm').val("0.00");
			          		$('#moneda').val("");
			          		$('#saldoIniMes').val("0.00");
			          		$('#cargosMes').val("0.00");
			          		$('#abonosMes').val("0.00");
			          		$('#cargosDia').val("0.00");
			          		$('#abonosDia').val("0.00");  
	                		$('#cargosPendientes').val("0.00");
			          		$('#saldo').val("0.00");  
			          		$('#saldoSBC').val("0.00");  
			          		$('#saldoBloq').val("0.00");   
			          		$('#tipoCuenta').val("");
							$('#cuentaAhoID').val("");		
							$('#gridReporteMovimientos').hide();      
							consultaCtaActPrin('numCliente');
							$('#ctaClabe').val("");	
						}else{
							mensajeSis("No Existe el Cliente");
							$(jqCliente).focus();
							$(jqCliente).select();
							$('#nombreCliente').val("");
							$('#cuentaAhoID').val("");
							$('#mes').val(mesSucursal).selected = true;
							$('#anio').val(anioSucursal).selected = true;		
							inicializaCampos();
						}    						
				});
			}else{
				if(isNaN(numCliente)){
					mensajeSis("No Existe el Cliente");	
					$(jqCliente).focus();
					$(jqCliente).select();	
					$('#nombreCliente').val("");
					$('#cuentaAhoID').val("");
					$('#mes').val(mesSucursal).selected = true;
					$('#anio').val(anioSucursal).selected = true;			
					inicializaCampos();
				}
			}
	}
	
	
	
	function consultaMovimientosJs(){	
		setTimeout("$('#cajaLista').hide();", 200);  
		var params = {};
		params['tipoLista'] =  $('#tipoListaMovs').val();
		params['cuentaAhoID'] = $('#cuentaAhoID').val();
		params['anio'] = $('#anio').val();
		params['mes'] = $('#mes').val(); 
	
		
		$.post("gridReporteMovimientos.htm", params, function(data){
				if(data.length >0) {
					$('#gridReporteMovimientos').html(data);
					$('#gridReporteMovimientos').show();
					$('#imprimir').show();
					$('#excel').show();
				}else{
					$('#gridReporteMovimientos').html("");
					$('#gridReporteMovimientos').show(); 
					$('#imprimir').hide();
					$('#excel').hide();
				}
		});
		
	}
	
	function llenarAnio(){
		var i=0;
		document.forms[0].anio.clear;
		document.forms[0].anio.length = 5;
		for (i=0; i < (document.forms[0].anio.length); i++){
			document.forms[0].anio[i].text = anioSucursal-i;
			document.forms[0].anio[i].value = anioSucursal-i;			
		} 
		document.forms[0].anio[0].selected = true;
	}
	
	
	
	function convierteStrInt(jControl){
		var valor=($(jControl).formatCurrency({
			positiveFormat: '%n', 
			roundToDecimalPlace: 2	
		})).asNumber();
		return  parseFloat(valor);
	}


	function pegaHtml(cuentaAhoID, saldoBloq ){
		var  catTipoListaBloqPrincipal=1; 
		if(!isNaN(cuentaAhoID)){
			var params = {};	
				params['cuentaAhoID'] = cuentaAhoID;
				params['tipoLista'] =  catTipoListaBloqPrincipal;
				params['anio'] = $('#anio').val(); 
				params['mes'] = $('#mes').val(); 
			
				$.post("listaBloqueo.htm", params, function(data){
					if(data.length >0) {	
						$('#bloq').html(data);
						$('#bloq').show();

					}else{				
				 		$('#bloq').html("");
						$('#bloq').show();
					}
				}); 
				
				$.blockUI({message: $('#bloq'),
					css: { 
						top:  ($(window).height() - 450)  + 'px', 
						left: ($(window).width() - 1100)  + 'px', 
						width: '900px' 
					} });  
				$('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		
			} 
	}
	

	function gridCargosPendientes(cuentaAhoID, clienteID ){
		var  listaCargosPorCuentaCliente = 1;
		var  listaCargosPorCuentaClienteHis = 2;  
		if(!isNaN(cuentaAhoID)){
			var params = {};	
				params['cuentaAhoID'] = cuentaAhoID;
				params['clienteID'] = clienteID;
				params['anio'] = $('#anio').val(); 
				params['mes'] = $('#mes').val(); 
				if ($('#mes').val() == mesSucursal && $('#anio').val() == anioSucursal){
					params['tipoLista'] =  listaCargosPorCuentaCliente;
				}else{
					params['tipoLista'] =  listaCargosPorCuentaClienteHis;
				}
			
				$.post("listaCobrosPend.htm", params, function(data){
					if(data.length >0) {	
						$('#bloq').html(data);
						$('#bloq').show();

					}else{				
				 		$('#bloq').html("");
						$('#bloq').show();
					}
				}); 
				
				$.blockUI({message: $('#bloq'),
					css: { 
						top:  ($(window).height() - 450)  + 'px', 
						left: ($(window).width() - 1100)  + 'px', 
						width: '900px' 
					} });  
				$('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		
			} 
	}
	
	function validaEmpresaID() {
		var numEmpresaID = 1;
		var tipoCon = 1;
		var ParametrosSisBean = {
				'empresaID'	:numEmpresaID
		};
		parametrosSisServicio.consulta(tipoCon,ParametrosSisBean,function(parametrosSisBean) {
			if (parametrosSisBean != null) {
				if(parametrosSisBean.servReactivaCliID !=null){
					 if(parametrosSisBean.tarjetaIdentiSocio=="S"){
							$('#tarjetaIdentiCA').show();
							$('#numeroTarjeta').val("");
							$('#idCtePorTarjeta').val("");
							$('#nomTarjetaHabiente').val("");
							$("#numeroTarjeta").focus();
						}else{
							$("#numCliente").focus();
							$('#tarjetaIdentiCA').hide();
							$('#numeroTarjeta').val("");
							$('#idCtePorTarjeta').val("");
							$('#nomTarjetaHabiente').val("");
						}
				}else{
					
				}
			}
		});
	}
	function consultaClienteIDTarDeb(control){
		var jqControl=	eval("'#" + control + "'");
		var numeroTar=$(jqControl).val();
		var numTarIdenAccess=numeroTar.replace(/[%&(=?¡'{-|})><ĸ¬°Çü½«»~÷Ø§ç¨`^€¶ŧ←↓→øþæßðđŋħł¢“µ·½\/\]\]\[\”\\]/gi, '');
			numTarIdenAccess=numTarIdenAccess.replace(/[_]/gi,'');
			numTarIdenAccess=numTarIdenAccess.replace(/[' ']/gi,''); // Quitamos los espacios en blanco
			numeroTar=numTarIdenAccess;
			
		$(jqControl).val(numeroTar);
		var conNumTarjeta=20;
		var TarjetaBeanCon = {
				'tarjetaDebID'	:numeroTar
			};
		if(numeroTar != '' && numeroTar > 0){
			if ($(jqControl).val().length>16){
				mensajeSis("El Número de Tarjeta es Incorrecto deben de ser 16 dígitos");
				$(jqControl).val("");
				$(jqControl).focus();
			}
			if($(jqControl).val().length == 16){
				tarjetaDebitoServicio.consulta(conNumTarjeta,TarjetaBeanCon,function(tarjetaDebito) {
					if(tarjetaDebito!=null){					
						if (tarjetaDebito.estatusId==7){
							$('#idCtePorTarjeta').val(tarjetaDebito.clienteID);
							$('#nomTarjetaHabiente').val(tarjetaDebito.nombreCompleto);
								if ($('#numeroTarjeta').val()!=""&& $('#idCtePorTarjeta').val()!=""){
									$('#numCliente').val($('#idCtePorTarjeta').val());
									
									consultaClientePantalla('numCliente');
									$('#cuentaAhoID').focus();
									otra = false;
									continuar = false;
								}
								$('#numeroTarjeta').val("");
								$('#idCtePorTarjeta').val("");
						}else{
								if (tarjetaDebito.estatusId==1){
									mensajeSis("La Tarjeta no se Encuentra Asociada a una Cuenta");
								}else
								if (tarjetaDebito.estatusId==6){
									mensajeSis("La Tarjeta no se Encuentra Activa");
								}else
								if (tarjetaDebito.estatusId==8){
									mensajeSis("La Tarjeta se Encuentra Bloqueada");
								}else
								if (tarjetaDebito.estatusId==9){
									mensajeSis("La Tarjeta se Encuentra Cancelada");
								}
								$(jqControl).focus();
								$(jqControl).val("");
								$('#idCtePorTarjeta').val("");
								$('#nomTarjetaHabiente').val("");
								$('#idCtePorTarjeta').val("");
								$('#nomTarjetaHabiente').val("");
								$('#saldoDispon').val("");
					        	$('#gat').val("");
					        	$('#valorGatReal').val("");
			                	$('#saldoProm').val("");
								$('#cuentaAhoID').val("");
								$('#moneda').val("");
								$('#tipoCuenta').val("");
								$('#saldoIniMes').val("");
								$('#cargosMes').val("");
								$('#abonosMes').val("");
								$('#cargosDia').val("");
								$('#abonosDia').val("");     
			            		$('#cargosPendientes').val("");
								$('#saldo').val("");  
								$('#saldoSBC').val("");  
								$('#saldoBloq').val("");                   		
								$('#gridReporteMovimientos').hide();   
								$('#salBloq').hide(); 
								$('#cargosPendientesBtn').hide();
								$('#numCliente').val("");
								$('#nombreCliente').val("");
								deshabilitaBoton('imprimir');
						}
					}else{
						mensajeSis("La Tarjeta de Identificación no existe.");
						$(jqControl).focus();
						$(jqControl).val("");
						$('#idCtePorTarjeta').val("");
						$('#nomTarjetaHabiente').val("");
						$('#saldoDispon').val("");
			        	$('#gat').val("");
			        	$('#valorGatReal').val("");
	                	$('#saldoProm').val("");
						$('#cuentaAhoID').val("");
						$('#moneda').val("");
						$('#tipoCuenta').val("");
						$('#saldoIniMes').val("");
						$('#cargosMes').val("");
						$('#abonosMes').val("");
						$('#cargosDia').val("");
						$('#abonosDia').val("");     
	            		$('#cargosPendientes').val("");
						$('#saldo').val("");  
						$('#saldoSBC').val("");  
						$('#saldoBloq').val("");                   		
						$('#gridReporteMovimientos').hide();   
						$('#salBloq').hide(); 
						$('#cargosPendientesBtn').hide();
						$('#numCliente').val("");
						$('#nombreCliente').val("");
						deshabilitaBoton('imprimir');
					}
					});	
				}
			}
		 }

	function inicializaCampos(){
		$('#tipoCuenta').val("");
		$('#saldoDispon').val("0.00");
		$('#gat').val("0.00");
		$('#valorGatReal').val("0.00");
		$('#saldoProm').val("0.00");
		$('#cargosPendientes').val("0.00");
		$('#moneda').val("");
		$('#saldoIniMes').val("0.00");
		$('#cargosMes').val("0.00");
		$('#abonosMes').val("0.00");
		$('#cargosDia').val("0.00");
		$('#abonosDia').val("0.00");      
		$('#saldo').val("0.00");  
		$('#saldoSBC').val("0.00");  
		$('#saldoBloq').val("0.00");               		
		$('#gridReporteMovimientos').hide();   
		$('#gridReporteMovimientos').html("");
		$('#salBloq').hide();
		$('#cargosPendientesBtn').hide();
		$('#ctaClabe').val("");
		$('#imprimir').hide();
		$('#excel').hide();
	}
});

var tipoReporte=1;
	function consultaDesMovimientos(fecha,descripcion,tipo,referencia,monto,saldo){	
		var data;
		data = '<table><tr align="left"><td id="encabezadoListaDes0">Fecha: </td><td>'+
			fecha+'</td></tr><tr align="left"><td id="encabezadoListaDes1">Descripci&oacute;n: </td><td>'+
			descripcion+'</td></tr><tr align="left"><td id="encabezadoListaDes2">Tipo: </td><td>'+
			tipo+'</td></tr><tr align="left"><td id="encabezadoListaDes3">Referencia: </td><td>'+
			referencia+'</td></tr><tr><td align="left" id="encabezadoListaDes4">Monto: </td><td align="right">'+monto
			+'</td></tr><tr><td align="left" id="encabezadoListaDes5">Saldo</td><td align="right">'+saldo+'</td></tr></table>';
		$('#desMovimiento').html(data); 
		  $.blockUI({message: $('#desMovimiento')}); 
        $('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI); 		
        
	}	
	
	// agrega el scroll al div de simulador de pagos libres de capital
	$('#bloq').scroll(function() {
		 
	});
